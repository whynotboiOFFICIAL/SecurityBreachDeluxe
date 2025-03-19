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
    local tensions = {}

    local function createTension(index)
        local name = 'whynotboi/securitybreach/base/music/tension/tension' .. index
        local world = game.GetWorld()

        local tension1 = CreateSound(world, name .. '_int1_lp.wav')
        local tension2 = CreateSound(world, name .. '_int2_lp.wav')
        local tension3 = CreateSound(world, name .. '_int3_lp.wav')

        tension1:SetSoundLevel(0)
        tension2:SetSoundLevel(0)
        tension3:SetSoundLevel(0)

        return {
            tension1,
            tension2,
            tension3
        }
    end

    function ENT:OnEnemySpotted(ent)
        if ent ~= LocalPlayer() then return end

        tensions[1] = tensions[1] or createTension(1)
        tensions[2] = tensions[2] or createTension(2)
        tensions[3] = tensions[3] or createTension(3)

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

    local function setTensionVolume(tension, index, volume)
        volume = math.max(0.016, volume)

        local sound = tension[index]

        if not sound:IsPlaying() then
            sound:Play()
        end

        sound:ChangeVolume(volume)
    end

    local function stopTension(tension)
        tension = tensions[tension]
        if not tension then return end

        tension[1]:Stop()
        tension[2]:Stop()
        tension[3]:Stop()
    end

    local lastTension
    
    local tension1Dist = 800
    local tension2Dist = 400
    local tension3Dist = 100

    timer.Create('fnaf_sb_tension_controller', 0.05, 0, function()
        local closetEnt = getClosestSpotted()

        if not closetEnt then 
            if lastTension then
                stopTension(lastTension)
            end

            lastTension = nil

            return 
        end

        local currentTension = closetEnt.Tension

        if currentTension ~= lastTension then
            if lastTension then
                stopTension(lastTension)
            end

            lastTension = currentTension
        end

        if currentTension < 1 then return end

        local dist = LocalPlayer():GetPos():Distance(closetEnt:GetPos())

        local sum1 = math.min(1, tension1Dist / dist)
        local sum2 = math.min(1, tension2Dist / dist)
        local sum3 = math.min(1, tension3Dist / dist)

        local tension = tensions[currentTension]

        setTensionVolume(tension, 1, sum1)
        setTensionVolume(tension, 2, sum2)
        setTensionVolume(tension, 3, sum3)
    end)
end