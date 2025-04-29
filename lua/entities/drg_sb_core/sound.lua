if SERVER then
    function ENT:GetSoundCount(path, name)
        if not self.SFXPath then return end

        local dir = 'sound/' .. self.SFXPath .. '/' .. path
        if not file.Exists(dir, 'GAME') then return 0 end

        local files = file.Find(dir .. '/*.wav', 'GAME')
        if not files[1] then return 0 end

        local count = 0

        for k, fileName in ipairs(files) do
            local index = string.match(fileName, '_(%d+).wav')
            
            if not index or (name and not string.find(fileName, name)) then 
                continue 
            end

            count = count + 1
        end

        return count
    end

    function ENT:_GetSoundCache(name)
        local rootC = self._AnimSoundCache

        if not rootC then
            rootC = {}
            self._AnimSoundCache = rootC
        end

        local cache = rootC[name]

        if not cache then
            cache = {}
            rootC[name] = cache
        end

        return cache
    end

    function ENT:_GetAnimSoundDictionary(name)
        local soundDictionary = self.AnimEventSounds
        if not soundDictionary then return end

        return soundDictionary[name]
    end

    function ENT:StopAnimSounds(name, playEndingSound)
        local tab = self:_GetAnimSoundDictionary(name)
        if not tab then return end

        local cache = self:_GetSoundCache(name)
        if cache[1] == nil then return end

        local path = tab.path
        local volume = tab.volume or 0.45
        local channel = tab.channel or CHAN_STATIC

        for k, path in ipairs(cache) do
            self:StopSound(path)

            if playEndingSound and tab.hasEnding then
                local endSoundPath = string.sub(path, 1, #path - 4) .. '_e.wav'

                self:EmitSound(endSoundPath, 75, 100, volume, channel)
            end
        end

        table.Empty(cache)
    end

    function ENT:HandleAnimSound(name, isEnd)
        if isEnd then
            return self:StopAnimSounds(name, true)
        end

        local tab = self:_GetAnimSoundDictionary(name)
        if not tab then return end

        local volume = tab.volume or 0.45
        local channel = tab.channel or CHAN_STATIC
        local soundPath = tab.path

        if not tab.count or tab.count < 2 then
            soundPath = soundPath .. '.wav'
        else
            if tab.count > 9 then
                soundPath = soundPath .. math.random(1, tab.count) .. '.wav'
            else
                soundPath = soundPath .. '0' .. math.random(1, tab.count) .. '.wav'
            end
        end

        self:EmitSound(soundPath, 75, 100, volume, channel)

        table.insert(self:_GetSoundCache(name), soundPath)
    end
    
    -- Voice 

    function ENT:PlayVoiceLine(vo, anim)
        if not GetConVar('fnaf_sb_new_voicelines'):GetBool() then return end

        local path = self.VOPath or self.SFXPath

        if path == nil then return end

        local snd = path .. '/vo/' .. vo .. '.wav'

        self:EmitSound(snd)

        if not anim then return end

        local anim = self:AddGestureSequence(self:LookupSequence(vo))
        self:SetLayerWeight(anim, 0)

        self:SetLayerBlendIn(anim, 0.1)
        self:SetLayerBlendOut(anim, 0.2)
    end

    function ENT:StopVoiceLine(vo)
        local path = self.VOPath or self.SFXPath
        if path == nil then return end

        self:StopSound(path .. '/vo/' .. vo .. '.wav')
    end

    local EnableHearing = CreateConVar("drgbase_ai_hearing", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

    local function HandleNPCSound(ent, sound)
		if #DrGBase.GetNextbots() == 0 then return end

		sound.Pos = sound.Pos or ent:GetPos()

		local distance = math.pow(sound.SoundLevel / 2, 2) * sound.Volume

		for i, nextbot in ipairs(DrGBase.GetNextbots()) do
			if ent == nextbot or not nextbot.OnHearNPCSound then continue end
			if nextbot:IsAIDisabled() then continue end
			if nextbot:IsDeaf() then continue end

			local mult = nextbot:VisibleVec(sound.Pos) and 1 or 0.5

			if (distance * nextbot:GetHearingCoefficient() * mult) ^ 2 >= nextbot:GetRangeSquaredTo(sound.Pos) then
				nextbot:Timer(0, nextbot.OnHearNPCSound, ent, sound)
			end
		end
	end

    hook.Add('EntityEmitSound', 'sb_npc_sound_detection', function(sound)
		if not EnableHearing:GetBool() then return end

        local ent = sound.Entity
		if not IsValid(sound.Entity) then return end

        if ent:IsNPC() or ent:IsNextBot() then
            HandleNPCSound(ent, sound)
        end
	end)
else
    ENT.Tension = 1

    local spotted = {}

    function ENT:OnEnemySpotted(ent)
        if ent ~= LocalPlayer() then return end

        spotted[self] = true

        surface.PlaySound('whynotboi/securitybreach/base/bot/sting/sfx_bot_sting_player_detected.wav')
    end

    local function getClosestSpotted()
        local currentDist = math.huge
        local ply = LocalPlayer()

        local selectedEnt

        for ent in pairs(spotted) do
            if not ent:IsValid() or ent:GetEnemy() ~= ply then
                spotted[ent] = nil
            else
                local dist = ply:GetPos():Distance(ent:GetPos())

                if dist < currentDist then
                    currentDist = dist
                    selectedEnt = ent
                end
            end
        end

        return selectedEnt
    end
end

AddCSLuaFile()