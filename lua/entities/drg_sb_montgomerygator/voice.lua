local idlevox = {
    'MONTY_00005',
    'MONTY_00006',
    'MONTY_00007',
    'MONTY_00008',
    'MONTY_00009',
    'MONTY_00010',
    'MONTY_00011',
    'MONTY_00012',
    'MONTY_00023'
}

local spotvox = {
    'MONTY_00013',
    'MONTY_00014',
    'MONTY_00015',
    'MONTY_00016',
    'MONTY_00017',
    'MONTY_00018',
    'MONTY_00019',
    'MONTY_00020',
    'MONTY_00021',
    'MONTY_00022'
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

    function ENT:OnNewEnemy()
        self:DrG_Timer(0, function()
            self:PlayVoiceLine(spotvox[math.random(#spotvox)], true)
        end)

        self:DrG_Timer(0.05, function()
            self:StopVoices(1)

            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLastEnemy()
        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
        end
    end
end