if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Burntrap'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/burntrap/burntrap.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = BLOOD_COLOR_RED

-- Stats --
ENT.SpawnHealth = 1000

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'run'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/burntrap/jumpscare/sfx_jumpscare_burntrap.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/burntrap'

-- Detection --
ENT.EyeBone = 'Head_jnt'
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

include('binds.lua')
include('voice.lua')

if SERVER then

    -- Basic --

    function ENT:CustomInitialize()
        self:SetMovement(60, 120)
        self:SetMovementRates(1, 1, 1)

        self:SetRenderMode(1)

        self.ExtraEffects = GetConVar('fnaf_sb_new_burntrap_fx'):GetBool()
        self.CanJumpscare = GetConVar('fnaf_sb_new_burntrap_jumpscare'):GetBool()
        self.CanHack = GetConVar('fnaf_sb_new_burntrap_hacksfreddy'):GetBool()
        self.CanBeStunned = GetConVar('fnaf_sb_new_burntrap_stun'):GetBool()

        if not self.CanJumpscare then
            self:SetDefaultRelationship(D_LI)
        end
        
        if not self.ExtraEffects then return end
        
        ParticleEffectAttach( 'whynotboi_burntrap_halo', 1, self, 0)
        ParticleEffectAttach( 'whynotboi_burntrap_eyeball', 4, self, 2)
        ParticleEffectAttach( 'whynotboi_burntrap_eyeball', 4, self, 3)
    end

    function ENT:AddCustomThink()
        if self.Hacking then
            if not IsValid(self.HackEntity) then
                self:CallInCoroutine(function(self,delay)
                    self:HackExit()
                end)
            else
                if self.DamageSustained > 100 then
                    self:HackInterrupted()
                end
            end
        end
    end

    function ENT:HackCheck()
        if not self.CanHack then return end
            
        self.HackDelay = true

        local timer = 3

        for k,v in pairs(ents.FindInSphere(self:LocalToWorld(Vector(0,0,50)), 300)) do
            if v ~= self and v ~= self:GetPossessor() then
                if v:IsNextBot() and v:GetClass() == 'drg_sb_glamrockfreddy' and not v.Hacked then
                    timer = 130

                    self:Hack(v)

                    break
                end
            end
        end
              
        self:DrG_Timer(timer, function()
            self.HackDelay = false
        end)
    end
    
    function ENT:OnChaseEnemy()
        if not self.HackDelay and not self.Hacking then
            self:CallInCoroutine(function(self,delay)
                self:HackCheck()
            end)
        end

        self:DoorCode()
    end
    
    function ENT:DoStunned()
        if self.Stunned or not self.CanBeStunned then return end

        ParticleEffect( 'whynotboi_burntrap_dissapear', self:GetPos(), self:GetAngles(), nil)

        if self.Hacking then
            self:HackInterrupted()
        end

        self:SetColor(Color(255, 255, 255, 0))

        self:SetAIDisabled(true)
    
        self.DisableControls = true

        self.Stunned = true

        self:DrG_Timer(2, function()   
            self:SetColor(Color(255, 255, 255, 255))

            self:SetAIDisabled(false)

            self.DisableControls = false
            self.Stunned = false

            self:SetPos(self:RandomPos(5000, 12000))

            if self:HasEnemy() then
                local ent = self:GetEnemy()

                self:LoseEntity(ent)

                self:SetEntityRelationship(ent, D_LI)

                self:DrG_Timer(1, function()
                if not IsValid(self) then return end

                    self:SetEntityRelationship(ent, D_HT)
                end)
            end
        end)
    end

    function ENT:Hack(ent)
        self:FaceInstant(ent)

        self:EmitSound('whynotboi/securitybreach/base/burntrap/hackfreddy/activate/sfx_burntrap_hackFreddy_activate_0' .. math.random(3) .. '.wav')

        self:SetMovement(0, 0, 0, true)

        self:SetAIDisabled(true)
        
        self.DamageSustained = 0 

        self.HackEntity = ent
        
        ent.Hacker = self

        ent:CallInCoroutine(function(self,delay)
            self:HackStart()
        end)

        self:PlaySequenceAndMove('hackin')

        if self.ExtraEffects then
            local startpos = self:GetAttachment(4).Pos

            util.ParticleTracerEx( 'whynotboi_burntrap_electricity_laser', startpos , ent:WorldSpaceCenter(), true, self:EntIndex(), 4 )
        end

        self.Hacking = true

        self.IdleAnimation = 'hackloop'
    end
    
    function ENT:HackInterrupted()
        self.HackEntity:HackInterrupted()

        self.HackEntity = nil

        self.Interrupted = true
    end

    function ENT:HackExit()
        if IsValid(self.HackEntity) and self.ExtraEffects then
            local startpos = self:GetAttachment(4).Pos
            local ent = self.HackEntity
            
            util.ParticleTracerEx( 'whynotboi_burntrap_electricity_laser', startpos , ent:WorldSpaceCenter(), true, self:EntIndex(), 4 )

            ParticleEffectAttach( 'whynotboi_flaming_purplesmoke_mist', 1, self.HackEntity, 0)
        end

        self.IdleAnimation = 'idle'

        self.Hacking = false

        self:PlaySequenceAndMove('hackout')
        
        if self.Interrupted then
            self.Interrupted = false
        end

        self.RunAnimation = 'run'
        self:SetMovement(60, 120, 250)

        if self.Stunned then return end
        
        self.DisableControls = false

        self:SetAIDisabled(false)
    end

    function ENT:OnIdle()
        if not self.CanHack then return self.BaseClass:OnIdle(self) end

        local tohack = nil

        for k,v in pairs(ents.FindByClass('drg_sb_glamrockfreddy')) do
            if v == self and v == self:GetPossessor() then continue end
            if v.Hacked then continue end
            if self.HackDelay then continue end
            if not self:Visible(v) then continue end

            tohack = v

            break
        end

        if IsValid(tohack) then
            self.RunAnimation = 'runfull'
            
            self:SetMovement(60, 230, 250)

            self.Luring = true

            self.ForceRun = true

            self:GoTo(tohack:RandomPos(150, 160))

            self.ForceRun = false

            self.RunAnimation = 'run'

            if not IsValid(tohack) then self.Luring = false return end

            self:HackCheck()
        else
            self:AddPatrolPos(self:RandomPos(1500))
        end
    end

    function ENT:OnTakeDamage(dmg)
        self:SpotEntity(dmg:GetAttacker())

        if not self.Hacking then return end

        self.DamageSustained = self.DamageSustained + dmg:GetDamage()
    end

    function ENT:OnDeath()
        self:StopVoices()

        self.VoiceDisabled = true
        
        ParticleEffectAttach( 'whynotboi_flaming_purplesmoke_mist', 1, self, 0)

        self:PlaySequenceAndMove('death')
    end
    
    function ENT:Removed()
    end

    -- Sounds --

    function ENT:CustomAnimEvents(e)
        if e == 'endostep' then
            self:StepSFX(2)
            self:MatStepSFX()
        end

        if e == 'handstep' then
            self:StepSFX(3)
            self:MatStepSFX()
        end

        if e == 'onknees' or e == 'onstomach' then
            self:EmitSound('whynotboi/securitybreach/base/montgomerygator/land/fly_monty_land_0' .. math.random(3) .. '.wav')
        end
    end
    
    function ENT:StepSFX(var)
        local shake = 0.3

        if var == 3 then
            shake = 0.1

            self:EmitSound('whynotboi/securitybreach/base/shatteredmonty/handtouch/fly_monty_shattered_handTouch_0'.. math.random(6) .. '.wav')
        elseif var == 2 then
            local shake = 0.6

            if self:IsRunning() then
                shake = 0.7
            end

            self:EmitSound('whynotboi/securitybreach/base/endo/footsteps/walk/fly_endo_walk_0'.. math.random(1,8) .. '.wav')
        else
            if self:IsRunning() then
                self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/run/fly_monty_run_'.. math.random(1,23) .. '.wav')

                shake = 0.4
            else
                self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/walk/fly_monty_walk_'.. math.random(1,19) .. '.wav')
            end
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end
else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 24)