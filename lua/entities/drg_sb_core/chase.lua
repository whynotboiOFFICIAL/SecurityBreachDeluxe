-- Enemy Stuff

function ENT:OnNewEnemy(ent)
    if self.OnSpotEnemy then
        self:OnSpotEnemy(ent)
    end

    self.Chasing = true
    self.Luring = false
    
    if (ent.IsDrGNextbot and ent:IsPossessed()) then
        ent = ent:GetPossessor()
    end

    self:CallOnClient('OnEnemySpotted', ent)
end

function ENT:OnLastEnemy(ent)
    if self.OnLoseEnemy then
        self:OnLoseEnemy(ent)
    end

    self.Chasing = false

    if self.Stunned or not self.HidingSpotSearch then return end

    if (ent:IsPlayer() or ent.IsDrGNextbot) and IsValid(ent:GetNWEntity('HidingSpotSB')) and self:VisibleVec(ent:GetPos()) then

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
    if not (self.CanPounce or self.Voicebox) then return end
    if self.RangeTick or self.PounceStarted then return end
    if self.Stunned or self.Luring then return end
    if self.StunDelay or self.VoiceboxDelay then return end

    self.RangeTick = true

    if math.random(100) > 60 then
        if self.Voicebox and self.CanPounce then
            local attack = math.random(1, 100)

            if attack  > 50 then
                self:UseVoicebox()
            else
                self:PounceStart()
            end
        else
            if self.Voicebox then
                self:UseVoicebox()
            else
                self:PounceStart()
            end
        end
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
        
                local path = self.VOPath or self.PouncePath or self.SFXPath

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
                
                if self.PreAnim then
                    self.IdleAnimation = 'preidle'
                else
                    self.IdleAnimation = 'idle'
                end

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

-- Returns

function ENT:SkyTrace()
    local startpS = self:WorldSpaceCenter()
    local endpos = Vector(0, 0, 1e9)
    local tr = util.QuickTrace(startpS, endpos, self)
    --debugoverlay.Line( startpS, startpS + endpos, 1, Color( 255, 255, 255 ), false )
    
    if tr.HitSky then
        return true
    end
end

function ENT:GetRandomPosUnderSky(min, max)
    while true do
        local pos = self:RandomPos(min, max)
        local tr = util.QuickTrace(pos, pos + vector_up * 1e9, self)

        if tr and tr.HitSky then
            return pos
        end
    end

    return self:RandomPos(min, max)
end

-- Attacks

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

        local path = self.VOPath or self.PouncePath or self.SFXPath
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

function ENT:JumpAttack()
    if not self:SkyTrace() then return end

    local toland = self:GetRandomPosUnderSky(2000, 4000)

    self:StopVoices()

    self.VoiceDisabled = true

    self:FaceInstant(toland)

    self:PlaySequenceAndMove('jump')

    self:SetPos(toland)

    self:ClearPatrols()
    
    self:AddPatrolPos(self:RandomPos(1500))

    self.Moving = false
    
    self:PlaySequenceAndMove('land')

    self.VoiceDisabled = false
end

function ENT:UseVoicebox()
    self.VoiceboxDelay = true

    self:StopVoices()

    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/voicebox/sfx_chicaVoicebox_screech_0' .. math.random(3) .. '.wav')

    for k,v in pairs(ents.FindInSphere(self:WorldSpaceCenter(), 600)) do
        if (v == self) or (v == self:GetPossessor()) or not (v:IsPlayer() or v.IsDrGNextbot) or (self:GetAIDisabled()) or v:Health() < 1 then continue end
        if v.Stunned or v.PounceStared or v.Luring or v.FoundRecharge or v.NullifyVoicebox then continue end

        if v:IsPlayer() then
            v:SetNWBool('SBVoiceBoxStun', true)

            timer.Simple(5, function()
                if not IsValid(v) then return end

                v:SetNWBool('SBVoiceBoxStun', false)
            end)
        end

        if v.IsDrGNextbot then
            if not v:IsInFaction('FACTION_ANIMATRONIC') then continue end

            v:CallInCoroutine(function(self,delay)
                v.ForceRun = true

                v:GoTo(v:RandomPos(900, 1000))

                if not v.Alerted then
                    v.ForceRun = false
                end
            end)
        end
    end
    
    self:DrG_Timer(15, function()
        self.VoiceboxDelay = false
    end)
end
