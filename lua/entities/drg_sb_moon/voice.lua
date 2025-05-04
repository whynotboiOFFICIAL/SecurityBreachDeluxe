ENT.SearchingVox = {
    'MOON_00002',
    'MOON_00003',
    'MOON_00006_01',
    'MOON_00006_02',
    'MOON_00006_03',
    'MOON_00006_04',
    'MOON_00006_05',
    'MOON_00006_06',
    'MOON_00006_07',
    'MOON_00006_08',
}

ENT.ListeningVox = {
    'MOON_00003',
    'MOON_00004',
    'MOON_00005',
    'MOON_00007',
    'MOON_00006_01',
    'MOON_00006_05',
    'MOON_00006_08' 
}

ENT.SpotVox = {
    'MOON_00003',
    'MOON_00009',
}

ENT.PursuitVox = {
    'MOON_00005',
    'MOON_00006_01',
    'MOON_00006_02',
    'MOON_00006_03',
    'MOON_00006_04',
    'MOON_00006_05',
    'MOON_00006_06',
    'MOON_00006_07',
    'MOON_00006_08',
    'MOON_00008'
}

ENT.LostVox = {
    'MOON_00002',
    'MOON_00004',
    'MOON_00005'
}

ENT.StunVox = {
    'MOON_pain_yell',
    'MOON_pain_yell_02'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            local table = self.SearchingVox

            --[[if self.Chasing then
                table = self.PursuitVox
            end]]--

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
        
        for i = 1, #self.PursuitVox do
            self:StopVoiceLine(self.PursuitVox[i])
        end
        
        if mode == 2 then return end

        for i = 1, #self.StunVox do
            self:StopVoiceLine(self.StunVox[i])
        end
    end
end

AddCSLuaFile()