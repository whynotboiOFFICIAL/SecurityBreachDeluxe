local idlevox = {
    'CHICA_00005',
    'CHICA_00005b',
    'CHICA_00006',
    'CHICA_00007',
    'CHICA_00008',
    'CHICA_00009',
    'CHICA_00010',
    'CHICA_00011',
    'CHICA_00012_01',
    'CHICA_00012_02',
    'CHICA_00012_03',
    'CHICA_00013',
    'CHICA_00014',
    'CHICA_00015',
    'CHICA_00016',
    'CHICA_00016a',
    'CHICA_00017',
    'CHICA_00018'
}

local spotvox = {
    'CHICA_00019',
    'CHICA_00020',
    'CHICA_00021',
    'CHICA_00022',
    'CHICA_00023',
    'CHICA_00024'
}

local stunvox = {
    'CHICA_00001_01',
    'CHICA_00001_02',
    'CHICA_00001_03',
    'CHICA_00001_04',
    'CHICA_00002_01',
    'CHICA_00002_02',
    'CHICA_00002_03',
    'CHICA_00002_04',
    'CHICA_00002_05',
    'CHICA_00003_01',
    'CHICA_00003_02'
}

local pizzavox = {
    'CHICA_00025_01',
    'CHICA_00025_02',
    'CHICA_00025_03'
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

        for i = 1, #pizzavox do
            self:StopVoiceLine(pizzavox[i])
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