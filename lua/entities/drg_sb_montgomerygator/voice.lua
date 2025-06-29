ENT.SearchingVox = {
    'MONTY_00005',
    'MONTY_00006',
    'MONTY_00007',
    'MONTY_00009',
    'MONTY_00010'
}

ENT.ListeningVox = {
    'MONTY_00015'
}

ENT.SpotVox = {
    'MONTY_00013',
    'MONTY_00014',
    'MONTY_00016',
    'MONTY_00017',
    'MONTY_00018',
    'MONTY_00020',
    'MONTY_00021'
}

ENT.PursuitVox = {
    'MONTY_00017',
    'MONTY_00018',
    'MONTY_00019',
    'MONTY_00020'
}

ENT.LostVox = {
    'MONTY_00008',
    'MONTY_00011',
    'MONTY_00012'
}

ENT.StunVox = {
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

local growlvox = {
    'MONTY_00001_01',
    'MONTY_00001_02',
    'MONTY_00001_03',
    'MONTY_00001_04',
    'MONTY_00001_05',
    'MONTY_00001_06'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            local table = self.SearchingVox

            --[[if self.Chasing then
                table = self.PursuitVox
            end]]--

            local snd = table[math.random(#table)]
  
            local path = self.SFXPath

            self:StopGrowls()
        
            self:PlayVoiceLine(snd, true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:GrowlThink()
        if self.Talking or self.VoiceDisabled or self.GrowlTick then return end
        
        self.GrowlTick = true

        local timer = 4

        self:PlayVoiceLine(growlvox[math.random(#growlvox)])   

        self:DrG_Timer(timer, function()
            self.GrowlTick = false
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
        for i = 1, #self.SearchingVox do
            self:StopVoiceLine(self.SearchingVox[i])
        end

        for i = 1, #self.ListeningVox do
            self:StopVoiceLine(self.ListeningVox[i])
        end

        for i = 1, #self.LostVox do
            self:StopVoiceLine(self.LostVox[i])
        end
        
        self:StopGrowls()

        if mode == 1 then return end

        for i = 1, #self.SpotVox do
            self:StopVoiceLine(self.SpotVox[i])
        end
        
        for i = 1, #self.PursuitVox do
            self:StopVoiceLine(self.PursuitVox[i])
        end
        
        if mode == 2 then return end

        for i = 1, #self.StunVox do
            self:StopVoiceLine(self.StunVox[i])
        end
    end
    
    function ENT:StopGrowls()
        for i = 1, #growlvox do
            self:StopVoiceLine(growlvox[i])
        end
    end
end

AddCSLuaFile()