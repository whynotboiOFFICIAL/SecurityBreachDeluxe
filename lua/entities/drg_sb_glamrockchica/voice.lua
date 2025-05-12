ENT.SearchingVox = {
    'CHICA_00007',
    'CHICA_00011',
    'CHICA_00013',
    'CHICA_00015',
    'CHICA_00016',
    'CHICA_00016a',
    'CHICA_00018'
}

ENT.ListeningVox = {
    'CHICA_00010',
    'CHICA_00011',
    'CHICA_00018',
    'CHICA_00023'
}

ENT.SpotVox = {
    'CHICA_00019',
    'CHICA_00020',
    'CHICA_00021',
    'CHICA_00022',
    'CHICA_00023',
    'CHICA_00024'
}

ENT.PursuitVox = {
    'CHICA_00005',
    'CHICA_00005b',
    'CHICA_00006',
    'CHICA_00007',
    'CHICA_00008',
    'CHICA_00009',
    'CHICA_00013',
    'CHICA_00015',
    'CHICA_00016',
    'CHICA_00016a',
    'CHICA_00018'
}

ENT.LostVox = {
    'CHICA_00010',
    'CHICA_00017',
    'CHICA_00023'
}

ENT.StunVox = {
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

ENT.PizzaVox = {
    'CHICA_00025_01',
    'CHICA_00025_02',
    'CHICA_00025_03'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            local table = self.SearchingVox

            if math.random(1,100) > 50 then
                table = self.PursuitVox
            end

            --[[if self.Chasing then
                table = self.PursuitVox
            end]]--

            local snd = table[math.random(#table)]
  
            local path = self.SFXPath

            self:StopBreaths()
        
            self:PlayVoiceLine(snd, true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:BreathThink()
        if self.Talking or self.VoiceDisabled or self.BreathTick then return end
        
        self.BreathTick = true

        local timer = math.random(5, 10)

        self:EmitSound('whynotboi/securitybreach/base/glamrockchica/breaths/sfx_chica_creepy_breaths_' .. math.random(8) .. '.wav')  

        self:DrG_Timer(timer, function()
            self.BreathTick = false
        end)
    end

    function ENT:StopVoices(mode)
        for i = 1, #self.SearchingVox do
            self:StopVoiceLine(self.SearchingVox[i])
        end

        for i = 1, #self.ListeningVox do
            self:StopVoiceLine(self.PursuitVox[i])
        end

        for i = 1, #self.PizzaVox do
            self:StopVoiceLine(self.PizzaVox[i])
        end

        for i = 1, #self.LostVox do
            self:StopVoiceLine(self.LostVox[i])
        end
        
        self:StopBreaths()

        self:StopVoiceLine('CHICA_EATING_GARBAGE_01')
        self:StopVoiceLine('CHICA_EATING_GARBAGE_02')

        if mode == 1 then return end

        for i = 1, #self.PursuitVox do
            self:StopVoiceLine(self.PursuitVox[i])
        end

        for i = 1, #self.SpotVox do
            self:StopVoiceLine(self.SpotVox[i])
        end
        
        if mode == 2 then return end

        for i = 1, #self.StunVox do
            self:StopVoiceLine(self.StunVox[i])
        end
    end

    function ENT:StopBreaths()
        for i = 1, 8 do
            self:StopSound('whynotboi/securitybreach/base/glamrockchica/breaths/sfx_chica_creepy_breaths_' .. i .. '.wav')
        end
    end

    function ENT:ValleyInit()
        self.SearchingVox = {
            'CHICA_VALLEY_00007',
            'CHICA_VALLEY_00011',
            'CHICA_VALLEY_00013',
            'CHICA_VALLEY_00015_01',
            'CHICA_VALLEY_00015_02',
            'CHICA_VALLEY_00016a',
            'CHICA_VALLEY_00018'
        }
        
        self.ListeningVox = {
            'CHICA_VALLEY_00010',
            'CHICA_VALLEY_00011',
            'CHICA_VALLEY_00018',
            'CHICA_VALLEY_00023'
        }

        self.SpotVox = {
            'CHICA_VALLEY_00019',
            'CHICA_VALLEY_00020',
            'CHICA_VALLEY_00021',
            'CHICA_VALLEY_00022',
            'CHICA_VALLEY_00023',
            'CHICA_VALLEY_00024'
        }

        self.PursuitVox = {
            'CHICA_VALLEY_00005',
            'CHICA_VALLEY_00005b',
            'CHICA_VALLEY_00006',
            'CHICA_VALLEY_00007',
            'CHICA_VALLEY_00008',
            'CHICA_VALLEY_00009',
            'CHICA_VALLEY_00013',
            'CHICA_VALLEY_00015_01',
            'CHICA_VALLEY_00015_02',
            'CHICA_VALLEY_00016a',
            'CHICA_VALLEY_00018'
        }
                
        self.LostVox = {
            'CHICA_VALLEY_00010',
            'CHICA_VALLEY_00017',
            'CHICA_VALLEY_00023'
        }

        self.PizzaVox = {
            'CHICA_VALLEY_00025'
        }
    end
end

AddCSLuaFile()