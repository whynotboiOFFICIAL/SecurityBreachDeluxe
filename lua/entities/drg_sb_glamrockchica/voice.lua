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

local valleyidlevox = {
    'CHICA_VALLEY_00005',
    'CHICA_VALLEY_00005b',
    'CHICA_VALLEY_00006',
    'CHICA_VALLEY_00007',
    'CHICA_VALLEY_00008',
    'CHICA_VALLEY_00009',
    'CHICA_VALLEY_00010',
    'CHICA_VALLEY_00011',
    'CHICA_VALLEY_00012',
    'CHICA_VALLEY_00013',
    'CHICA_VALLEY_00014',
    'CHICA_VALLEY_00015_01',
    'CHICA_VALLEY_00015_02', 
    'CHICA_VALLEY_00016a',
    'CHICA_VALLEY_00017',
    'CHICA_VALLEY_00018'
}

local valleyspotvox = {
    'CHICA_VALLEY_00019',
    'CHICA_VALLEY_00020',
    'CHICA_VALLEY_00021',
    'CHICA_VALLEY_00022',
    'CHICA_VALLEY_00023',
    'CHICA_VALLEY_00024'
}

local valleypizzavox = {
    'CHICA_VALLEY_00025'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            self.Talking = true
    
            local snd = idlevox[math.random(#idlevox)]
        
            if self.Valley then
                snd = valleyidlevox[math.random(#valleyidlevox)]
            end

            local path = self.SFXPath

            self:StopBreaths()
        
            self:PlayVoiceLine(snd, true)

            local dur = SoundDuration(path .. '/vo/' .. snd .. '.wav')
                
            self:DrG_Timer(dur, function()
                self.Talking = false
            end)
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

    function ENT:OnStunned()
        self:StopVoices()

        self:CallInCoroutine(function(self,delay)
            self:PlayVoiceLine(stunvox[math.random(#stunvox)], true)
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        if self.PreAnim then
            self.IdleAnimation = 'preidle'
        else
            self.IdleAnimation = 'idle'
        end
    end

    function ENT:LuredTo(ent)
        self:StopVoices() 
        
        self:SetDefaultRelationship(D_LI)

        self:CallInCoroutine(function(self,delay)
            
            local snd = pizzavox[math.random(#pizzavox)]
        
            if self.Valley then
                snd = valleypizzavox[math.random(#valleypizzavox)]
            end

            self:PlayVoiceLine(snd, true) 

            self.Luring = true
            self.LuringTo = ent
            self.VoiceDisabled = true

            if not IsValid(ent) then return end

            self:GoTo(ent:GetPos() + ent:GetForward() * 35)

            if not IsValid(ent) then self.Luring = false return end

            ent:SetBodygroup(1, 1)

            self:SetVelocity(vector_origin)

            self:SetPos(ent:GetPos() + ent:GetForward() * 35)

            self:FaceInstant(ent)

            self.DisableControls = true
            self.Moving = false

            self:SetAIDisabled(true)

            self.IdleAnimation = 'rummageloop'

            self:PlaySequenceAndMove('rummagein')

            self:PlayVoiceLine('CHICA_EATING_GARBAGE_0' .. math.random(2))

            self:DrG_Timer(6, function()
                ParticleEffectAttach( 'fnafsb_drool_chica', 4, self, 3 )
            end)
            
            self:DrG_Timer(10, function()
                if IsValid(ent) then
                    ent:SetBodygroup(2, 1)
                end

                self:CallInCoroutine(function(self,delay)
                    if self.PreAnim then
                        self.IdleAnimation = 'preidle'
                    else
                        self.IdleAnimation = 'idle'
                    end

                    self:PlaySequenceAndMove('rummageout')

                    self.DisableControls = false
                    self.Luring = false
                    self.VoiceDisabled = false

                    self.LuringTo = nil

                    self:SetAIDisabled(false)
                    self:SetDefaultRelationship(D_HT)
                end)
            end)
        end)
    end
    
    function ENT:StopVoices(mode)
        for i = 1, #idlevox do
            self:StopVoiceLine(idlevox[i])
        end

        for i = 1, #pizzavox do
            self:StopVoiceLine(pizzavox[i])
        end

        for i = 1, #valleyidlevox do
            self:StopVoiceLine(valleyidlevox[i])
        end

        for i = 1, #valleypizzavox do
            self:StopVoiceLine(valleypizzavox[i])
        end

        self:StopBreaths()

        self:StopVoiceLine('CHICA_EATING_GARBAGE_01')
        self:StopVoiceLine('CHICA_EATING_GARBAGE_02')

        if mode == 1 then return end

        for i = 1, #spotvox do
            self:StopVoiceLine(spotvox[i])
        end
        
        for i = 1, #valleyspotvox do
            self:StopVoiceLine(valleyspotvox[i])
        end
        
        if mode == 2 then return end

        for i = 1, #stunvox do
            self:StopVoiceLine(stunvox[i])
        end
    end

    function ENT:StopBreaths()
        for i = 1, 8 do
            self:StopSound('whynotboi/securitybreach/base/glamrockchica/breaths/sfx_chica_creepy_breaths_' .. i .. '.wav')
        end
    end

    function ENT:OnSpotEnemy()
        if self.Stunned then return end
        
        self:DrG_Timer(0, function()
            if self.FreePatrols then
                self.FreePatrols = 0
            end

            local snd = spotvox[math.random(#pizzavox)]
        
            if self.Valley then
                snd = valleyspotvox[math.random(#valleyspotvox)]
            end

            self:PlayVoiceLine(snd, true) 
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

AddCSLuaFile()