local idlevox = {
    'VANNY_00001',
    'VANNY_00002_001',
    'VANNY_00002_002',
    'VANNY_00002_003',
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
            self:PlayVoiceLine(idlevox[math.random(#idlevox)], true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        for i = 1, #idlevox do
            self:StopVoiceLine(idlevox[i])
        end
    end

    function ENT:OnSpotEnemy()
        self:DrG_Timer(0.05, function()
            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLoseEnemy()
        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
        end
    end
end