ENT.SearchingVox = {
    'FREDDY_00135',
    'FREDDY_00136',
    'FREDDY_00137',
    'FREDDY_00138'
}

ENT.ListeningVox = {
    'FREDDY_00136',
    'FREDDY_00137'
}

ENT.LostVox = {
    'FREDDY_00133',
    'FREDDY_00134',
    'FREDDY_00138',
    'FREDDY_00139'    
}

ENT.StunVox = {
    'FREDDY_00199',
    'FREDDY_00200',
    'FREDDY_00201',
    'FREDDY_00202'
}

ENT.CorruptedVox = {
    'FREDDY_00175b_01',
    'FREDDY_00175b_02',
    'FREDDY_00175b_03'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled or not self.Hostile then return end

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
        self:StopVoiceLine('FREDDY_00083') 
        self:StopVoiceLine('FREDDY_00094')
        self:StopVoiceLine('FREDDY_00122a')
        self:StopVoiceLine('FREDDY_00160')
        self:StopVoiceLine('FREDDY_00161')

        for i = 1, #self.SearchingVox do
            self:StopVoiceLine(self.SearchingVox[i])
        end

        for i = 1, #self.ListeningVox do
            self:StopVoiceLine(self.ListeningVox[i])
        end

        for i = 1, #self.LostVox do
            self:StopVoiceLine(self.LostVox[i])
        end

        if mode == 2 then return end

        for i = 1, #self.StunVox do
            self:StopVoiceLine(self.StunVox[i])
        end

        for i = 1, #self.CorruptedVox do
            self:StopVoiceLine(self.CorruptedVox[i])
        end
    end
end

AddCSLuaFile()