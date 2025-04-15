local stunvox = {
    'FREDDY_00199',
    'FREDDY_00200',
    'FREDDY_00201',
    'FREDDY_00202'
}

if SERVER then
    function ENT:StopVoices(mode)
        self:StopVoiceLine('FREDDY_00094')

        for i = 1, #stunvox do
            self:StopVoiceLine(stunvox[i])
        end
    end

    function ENT:OnStunned()
        self:StopVoices()

        self:PlayVoiceLine(stunvox[math.random(#stunvox)], true)
        
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        self.IdleAnimation = 'idle'
    end

end

AddCSLuaFile()