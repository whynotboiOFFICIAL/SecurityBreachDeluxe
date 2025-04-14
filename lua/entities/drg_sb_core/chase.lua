function ENT:OnNewEnemy(ent)
    if self.OnSpotEnemy then
        self:OnSpotEnemy(ent)
    end

    if (ent.IsDrGNextbot and ent:IsPossessed()) then
        ent = ent:GetPossessor()
    end

    self:CallOnClient('OnEnemySpotted', ent)
end

function ENT:OnLastEnemy(ent)
    if self.OnLoseEnemy then
        self:OnLoseEnemy(ent)
    end

    if self.Stunned or not self.HidingSpotSearch then return end
    
    if ent:IsPlayer() and IsValid(ent:GetNWEntity('HidingSpotSB')) and self:VisibleVec(ent:GetPos()) then

        local spot = ent:GetNWEntity('HidingSpotSB')

        if spot.CantBeSearched then return end

        local tosearch = spot.SpotID

        local offset = self.HidingSpotOffsets[tosearch] or 55

        self.InvestigatingSpot = spot
        
        self:ClearPatrols()

        self:AddPatrolPos(spot:GetPos() + spot:GetForward() * offset)
    end
end

function ENT:OnChaseEnemy()
    self:DoorCode()  
end

function ENT:OnRangeAttack(ent)
    if not self.CanPounce or self.RangeTick or self.PounceStarted or self.Stunned or self.StunDelay then return end

    self.RangeTick = true

    if math.random(100) > 60 then
        self:PounceStart()
    else
        self:DrG_Timer(5, function()
            self.RangeTick = false
        end)
    end
end

function ENT:OnLandOnGround()
    if self.PounceStarted then
        self.Pouncing = false

        self:CallInCoroutine(function(self,delay)
            if self.PounceLandSounds then
                local snd = self.PounceLandSounds[math.random(#self.PounceLandSounds)]
        
                local path = self.VOPath or self.SFXPath

                self:EmitSound(path .. snd)
            end

            if self.PounceLandVox then
                self:StopVoices()
                self:PlayVoiceLine(self.PounceLandVox[math.random(#self.PounceLandVox)])
            end

            self:PlaySequenceAndMove('pounceland')
        end)

        self.PounceStarted = false
        self.Moving = false
        self.Stunned = true

        self.JumpAnimation = 'idle'
        self.IdleAnimation = 'pouncestunloop'

        self:DrG_Timer(5, function()
            self:CallInCoroutine(function(self,delay)
                self:PlaySequenceAndMove('pouncestuntoidle')
                self.IdleAnimation = 'idle'

                self.DisableControls = false
                self.Stunned = false
                self.VoiceDisabled = false

                self:SetAIDisabled(false)
                self:SetMaxYawRate(250)
                
                self:DrG_Timer(5, function()
                    self.RangeTick = false
                end)
            end)
        end)
    end
end

function ENT:PounceStart()
    self:EmitSound('whynotboi/securitybreach/base/bot/leap/fly_bot_leap_prep_0' .. math.random(3) .. '.wav', 75, 100, 0.5)

    self:SetAIDisabled(true)

    if self.Weeping then
        self:StopWeeping()
    end
    
    self.PounceStarted = true
    self.LockAim = true
    self.VoiceDisabled = true

    self.JumpAnimation = 'pouncejumploop'

    if self.PounceAnticVox then
        self:StopVoices()
        self:PlayVoiceLine(self.PounceAnticVox[math.random(#self.PounceAnticVox)])
    end

    self:PlaySequenceAndMove('pounceantic')

    self.DisableControls = true
    
    if self.PounceJumpVox then
        self:StopVoices()
        self:PlayVoiceLine(self.PounceJumpVox[math.random(#self.PounceJumpVox)])
    end

    if self.PounceJumpSounds then
        local snd = self.PounceJumpSounds[math.random(#self.PounceJumpSounds)]

        local path = self.VOPath or self.SFXPath
        self:EmitSound(path .. snd)
    end

    self.LockAim = false

    self:SetMaxYawRate(0)

    self:SetPos(self:GetPos() + Vector(0, 0, 30))

    local nerf = self.PounceNerf or 1

    local fnerfed = 800 / nerf

    local znerfed = 300 / nerf

    self:SetVelocity(self:GetForward() * fnerfed + Vector(0, 0, znerfed))
    
    self:PlaySequence('pouncejumpin')

    self.Pouncing = true
end