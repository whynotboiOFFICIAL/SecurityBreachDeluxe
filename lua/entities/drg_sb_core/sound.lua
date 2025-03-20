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
        local soundPath = tab.path .. '0' .. math.random(tab.count) .. '.wav'

        self:EmitSound(soundPath, 75, 100, volume, channel)

        table.insert(self:_GetSoundCache(name), soundPath)
    end
    
    -- Voice 

    function ENT:PlayVoiceLine(vo, anim)
        local path = self.SFXPath
        if path == nil then return end

        self:EmitSound(path .. '/vo/' .. vo .. '.wav')

        if not anim then return end

        self:PlaySequence(vo)
    end

    function ENT:StopVoiceLine(vo)
        local path = self.SFXPath
        if path == nil then return end

        self:StopSound(path .. '/vo/' .. vo .. '.wav')
    end
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