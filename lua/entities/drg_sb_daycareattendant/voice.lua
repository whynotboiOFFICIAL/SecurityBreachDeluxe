local idlevox = {
    'MOON_00002',
    'MOON_00003',
    'MOON_00004',
    'MOON_00005',
    'MOON_00006_01',
    'MOON_00006_02',
    'MOON_00006_03',
    'MOON_00006_04',
    'MOON_00006_05',
    'MOON_00006_06',
    'MOON_00006_07',
    'MOON_00006_08',
    'MOON_00007',
    'MOON_00008'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 4 then
            self:PlayVoiceLine(idlevox[math.random(#idlevox)], false)
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
end