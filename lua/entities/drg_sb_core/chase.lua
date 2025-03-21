function ENT:OnChaseEnemy()
    self:DoorCode()  
end

function ENT:OnRangeAttack(ent)
    if not self.CanPounce or self.RangeTick or self.PounceStarted then return end

    self.RangeTick = true

    if math.random(100) > 50 then
        self:PounceStart()
    end

    self:DrG_Timer(5, function()
        self.RangeTick = false
    end)
end

function ENT:OnLandOnGround()
    if self.PounceStarted then
        self.Pouncing = false

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('pounceland')
        end)

        self.PounceStarted = false

        self.Moving = false
    
        self.JumpAnimation = 'idle'
        self.IdleAnimation = 'pouncestunloop'

        self:DrG_Timer(5, function()
            self:CallInCoroutine(function(self,delay)
                self:PlaySequenceAndMove('pouncestuntoidle')
                self.IdleAnimation = 'idle'

                self:SetAIDisabled(false)
                self:SetMaxYawRate(250)
            end)
        end)
    end
end

function ENT:PounceStart()
    self:EmitSound('whynotboi/securitybreach/base/bot/leap/fly_bot_leap_prep_0' .. math.random(3) .. '.wav')

    self:SetAIDisabled(true)

    self.PounceStarted = true

    self.LockAim = true

    self.JumpAnimation = 'pouncejumploop'

    self:PlaySequenceAndMove('pounceantic')

    self.LockAim = false

    self:SetMaxYawRate(0)

    self:SetPos(self:GetPos() + Vector(0, 0, 30))

    self:SetVelocity(self:GetForward() * 800 + Vector(0, 0, 300))
    
    self:PlaySequence('pouncejumpin')

    self.Pouncing = true
end