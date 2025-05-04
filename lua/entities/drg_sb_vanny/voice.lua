ENT.SearchingVox = {
    'VANNY_00001',
    'VANNY_00003_001',
    'VANNY_00003_002',
    'VANNY_00003_003'
}

ENT.ListeningVox = {
    'VANNY_00003_001',
    'VANNY_00003_002',
    'VANNY_00003_003'
}

ENT.SpotVox = {
    'VANNY_00002_001',
    'VANNY_00002_002',
    'VANNY_00002_003'
}

ENT.LostVox = {
    'VANNY_00003_001',
    'VANNY_00003_002',
    'VANNY_00003_003'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            local table = self.SearchingVox

            local snd = table[math.random(#table)]
  
            self:PlayVoiceLine(snd, true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        for i = 1, #self.SearchingVox do
            self:StopVoiceLine(self.SearchingVox[i])
        end

        for i = 1, #self.ListeningVox do
            self:StopVoiceLine(self.ListeningVox[i])
        end
        
        for i = 1, #self.LostVox do
            self:StopVoiceLine(self.LostVox[i])
        end

        if mode == 1 then return end

        for i = 1, #self.SpotVox do
            self:StopVoiceLine(self.SpotVox[i])
        end
    end
end

AddCSLuaFile()