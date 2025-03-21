local idlevox = {
    'ROXY_00009',
    'ROXY_00010',
    'ROXY_00011',
    'ROXY_00012',
    'ROXY_00013',
    'ROXY_00014',
    'ROXY_00016',
    'ROXY_00017',
    'ROXY_00018',
    'ROXY_00022',
    'ROXY_00029',
    'ROXY_00030',
    'ROXY_00031',
    'ROXY_00032',
    'ROXY_00033',
    'ROXY_00034',
    'ROXY_00035',
    'ROXY_00036',
    'ROXY_00037',
    'ROXY_00038',
    'ROXY_00044',
    'ROXY_00045'
}

local spotvox = {
    'ROXY_00019',
    'ROXY_00020'
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

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 0 then
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

        if mode == 1 then return end

        for i = 1, #spotvox do
            self:StopVoiceLine(spotvox[i])
        end
    end

    function ENT:OnSpotEnemy()
        self:DrG_Timer(0, function()
            self:PlayVoiceLine(spotvox[math.random(#spotvox)], true)
        end)

        self:DrG_Timer(0.05, function()
            self:StopVoices(1)

            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLoseEnemy()
        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
        end
    end
end