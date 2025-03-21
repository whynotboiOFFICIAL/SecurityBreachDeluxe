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

local stunvox = {
    'MONTY_00002_01',
    'MONTY_00002_02',
    'MONTY_00002_03'
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
        
        if mode == 2 then return end

        for i = 1, #stunvox do
            self:StopVoiceLine(stunvox[i])
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