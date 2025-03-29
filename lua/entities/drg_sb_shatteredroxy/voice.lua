local idlevox = {
    'ROXY_00021',
    'ROXY_00023',
    'ROXY_00024',
    'ROXY_00025',
    'ROXY_00026',
    'ROXY_00027',
    'ROXY_00028',
    'ROXY_00046',
    'ROXY_00047',
    'ROXY_00048',
    'ROXY_00049',
    'ROXY_00050',
    'ROXY_00050a',
    'ROXY_00051'
}

local spotvox = {
    'ROXY_00007_01',
    'ROXY_00007_02',
    'ROXY_00007_03'
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

        if mode == 1 then return end

        for i = 1, #spotvox do
            self:StopVoiceLine(spotvox[i])
        end
    end

    function ENT:OnSpotEnemy()
        if self.Stunned then return end
        
        self:DrG_Timer(0, function()
            self:PlayVoiceLine(spotvox[math.random(#spotvox)], true)
        end)

        self:DrG_Timer(0.05, function()
            self:StopVoices(1)

            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLoseEnemy()
        if self.Stunned then return end
        
        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
        end
    end
end