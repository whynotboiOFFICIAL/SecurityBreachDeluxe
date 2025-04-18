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
    'MONTY_00025_01',
    'MONTY_00025_02',
    'MONTY_00025_03'
}

ENT.PounceJumpVox = {
    'MONTY_00024_01',
    'MONTY_00024_02',
    'MONTY_00024_03',
    'MONTY_00024_04',
    'MONTY_00024_05',
    'MONTY_00024_06',
    'MONTY_00024_07',
    'MONTY_00024_08',
    'MONTY_00024_09',
    'MONTY_00024_10',
    'MONTY_00024_11',
    'MONTY_00024_12',
    'MONTY_00024_13'
}

ENT.PounceLandVox = {
    'MONTY_00026_01',
    'MONTY_00026_02',
    'MONTY_00026_03',
    'MONTY_00026_04',
    'MONTY_00026_05',
    'MONTY_00026_06',
    'MONTY_00026_07',
    'MONTY_00026_08',
    'MONTY_00026_09',
    'MONTY_00026_10',
    'MONTY_00026_11',
    'MONTY_00026_12'
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

    function ENT:OnStunned()
        self:StopVoices()

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunin') 
        end)

        self:PlayVoiceLine(stunvox[math.random(#stunvox)], true)

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

AddCSLuaFile()