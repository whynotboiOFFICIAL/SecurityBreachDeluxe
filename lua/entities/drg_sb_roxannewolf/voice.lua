ENT.SearchingVox = {
    'ROXY_00009',
    'ROXY_00014',
    'ROXY_00022',
    'ROXY_00029',
    'ROXY_00030',
    'ROXY_00031',
    'ROXY_00032',
    'ROXY_00033',
    'ROXY_00034',
    'ROXY_00035',
    'ROXY_00036',
    'ROXY_00037'
}

ENT.ListeningVox = {
    'ROXY_00011',
    'ROXY_00014',
    'ROXY_00021',
}

ENT.SpotVox = {
    'ROXY_00015',
    'ROXY_00018',
    'ROXY_00020'
}

ENT.PursuitVox = {
    'ROXY_00016',
    'ROXY_00017',
    'ROXY_00018'
}

ENT.LostVox = {
    'ROXY_00034',
    'ROXY_00044',
    'ROXY_00045'
}

ENT.PounceAnticVox = {
    'ROXY_00042_01',
    'ROXY_00042_02',
    'ROXY_00042_03',
    'ROXY_00042_04',
    'ROXY_00042_05',
    'ROXY_00042_06',
    'ROXY_00042_07',
    'ROXY_00042_08',
    'ROXY_00042_09',
    'ROXY_00042_10',
    'ROXY_00042_11',
    'ROXY_00042_12',
    'ROXY_00042_13'
}

ENT.PounceJumpVox = {
    'ROXY_00043_01',
    'ROXY_00043_02',
    'ROXY_00043_03',
    'ROXY_00043_04',
    'ROXY_00043_05',
    'ROXY_00043_06',
    'ROXY_00043_07'
}

ENT.LandVox = {
    'ROXY_00041_01',
    'ROXY_00041_02',
    'ROXY_00041_03',
    'ROXY_00041_04',
    'ROXY_00041_05',
    'ROXY_00041_06'
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
       
        for i = 1, #self.PursuitVox do
            self:StopVoiceLine(self.PursuitVox[i])
        end

        for i = 1, #self.LostVox do
            self:StopVoiceLine(self.LostVox[i])
        end
        
        self:StopVoiceLine('ROXY_00001')
        self:StopVoiceLine('ROXY_00002')

        if mode == 1 then return end

        for i = 1, #self.SpotVox do
            self:StopVoiceLine(self.SpotVox[i])
        end
    end
end

AddCSLuaFile()