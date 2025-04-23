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

local sunstunvox = {
    'SUN_HW2_00039a',
    'SUN_HW2_00085',
    'SUN_HW2_00091',
    'SUN_HW2_00092'
}

local sunangervox = {
    'SUN_HW2_00040',
    'SUN_HW2_00070',
    'SUN_HW2_00042',
    'SUN_HW2_00088',
    'SUN_HW2_00043',
    'SUN_HW2_00040',
    'SUN_HW2_00044',
    'SUN_HW2_00046',
    'SUN_00006a'
}

local moonstunvox = {
    'MOON_pain_yell',
    'MOON_pain_yell_02'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            self:PlayVoiceLine(idlevox[math.random(#idlevox)], false)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:OnStunned()
        self:StopVoices()
        
        if self.AttendantType == 0 then
            self:PlayVoiceLine(sunstunvox[math.random(#sunstunvox)], false)

            if self.SunWarned then
                self.SunWarned = false
            end

            self.SunAnger = self.SunAnger + 1
        else
            self:PlayVoiceLine(moonstunvox[math.random(#moonstunvox)], false)
        end

        self.IdleAnimation = 'idlesad'
    end

    function ENT:OnStunExit()

        if self.AttendantType == 0 then
            self.IdleAnimation = 'idle'
        else
            self.IdleAnimation = 'moonidle1'
        end

        if self.AttendantType == 0 and self.SunAnger > 5 then
            self:PlayVoiceLine(sunangervox[math.random(7,9)], false)
        end
    end
    
    function ENT:SunAngerResponse()
        self.SunWarned = true

        if self.SunAnger < 6 then
            self:PlayVoiceLine(sunangervox[self.SunAnger], false)
        end
    end

    function ENT:StopVoices(mode)
        for i = 1, #idlevox do
            self:StopVoiceLine(idlevox[i])
        end

        for i = 1, #sunstunvox do
            self:StopVoiceLine(sunstunvox[i])
        end

        for i = 1, #sunangervox do
            self:StopVoiceLine(sunangervox[i])
        end
        
        for i = 1, #moonstunvox do
            self:StopVoiceLine(moonstunvox[i])
        end

        self:StopVoiceLine('SUN_00004')
        self:StopVoiceLine('SUN_00001a')
        self:StopVoiceLine('SUN_00001b')
        self:StopVoiceLine('SUN_00001c')
    end
end

AddCSLuaFile()