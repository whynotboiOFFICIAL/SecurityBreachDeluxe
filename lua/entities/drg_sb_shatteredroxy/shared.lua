if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Shattered Roxy'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/shatteredroxy/shatteredroxy.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanPounce = true
ENT.CanBeSummoned = true
ENT.HidingSpotSearch = true
ENT.SearchID = 'roxy'

-- Stats --
ENT.SpawnHealth = 700

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
ENT.JumpscareSound = 'whynotboi/securitybreach/base/shatteredroxy/jumpscare/sfx_jumpScare_roxy.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/shatteredroxy'
ENT.VOPath = 'whynotboi/securitybreach/base/roxannewolf'

ENT.PounceJumpSounds = {
    '/leap/fly_roxy_leap_01.wav',
    '/leap/fly_roxy_leap_02.wav',
    '/leap/fly_roxy_leap_03.wav',
    '/leap/fly_roxy_leap_04.wav'
}

ENT.PounceLandSounds = {
    '/land/fly_roxy_land_01.wav',
    '/land/fly_roxy_land_02.wav',
    '/land/fly_roxy_land_03.wav'
}

include('binds.lua')
include('voice.lua')

if SERVER then
    ENT.AnimEventSounds = {
        ['servo'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/shatteredroxy/servo/sfx_roxy_servo_shattered_',
            count = 4,
            volume = 0.3,
            channel = CHAN_STATIC
        }
    }
        
    -- Basic --

    function ENT:CustomInitialize()
        self:SetMovement(60, 200)
        self:SetMovementRates(1, 1, 1)

        self:SetSightRange(800 * GetConVar('fnaf_sb_new_multiplier_sightrange'):GetFloat())
        
        self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()

        self.CanSee = GetConVar('fnaf_sb_new_shatteredroxy_haseyes'):GetBool()
        self.CanBeStunned = GetConVar('fnaf_sb_new_shatteredroxy_haseyes'):GetBool()
        self.DynamicListening = GetConVar('fnaf_sb_new_shatteredroxy_haseyes'):GetBool()

        self.CanPounce = GetConVar('fnaf_sb_new_shatteredroxy_pounceattack'):GetBool()
        self.CanWeep = GetConVar('fnaf_sb_new_shatteredroxy_weep'):GetBool()
        
        self:SetNWBool('HUDAddEnabled', GetConVar('fnaf_sb_new_shatteredroxy_hudadd'):GetBool())
        
        self:SetBodygroup(2, GetConVar('fnaf_sb_new_hw2_jumpscares'):GetInt())

        self:SetSkin(GetConVar('fnaf_sb_new_shattereds_redeyes'):GetInt())

        if self.CanSee then
            self:SpawnEyes()
        else
            self:SetSightFOV(0)
        end
    end

    function ENT:SpawnEyes()
        local eyes = ents.Create('prop_dynamic')
        
        eyes:SetModel('models/whynotboi/securitybreach/base/animatronics/shatteredroxy/shatteredroxyeyes.mdl')
        eyes:SetModelScale(1)
        eyes:SetParent(self)
        eyes:SetSolid(SOLID_NONE)

        eyes:Fire('SetParentAttachment','Head')

        eyes:Spawn()

        eyes:ResetSequence('idle')

        if self:GetSkin() == 1 then
            eyes:SetBodygroup(0, 1)
        end

        self:DeleteOnRemove(eyes)
    end
  
    function ENT:AddCustomThink()
        if self.Stunned or self.PounceStarted or self:GetAIDisabled() or self:IsPossessed() then return end
        if self.CanSee then return end

        if not self.KillTick then
            self.KillTick = true

            for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 30)) do
                if self:IsPossessed() then continue end
                if self:EntityInaccessible(v) then continue end

                self:CallInCoroutine(function(self,delay)
                    self:JumpscareEntity(v)
                end)
            end

            self:DrG_Timer(0.3, function()
                self.KillTick = false
            end)
        end

        if self.PursuePos and not self.LeapTick then
            if not self.CanPounce then return end

            self.LeapTick = true

            local pos = self.PursuePos
            local dist = pos:DistToSqr(self:GetPos())/ 1000

            if dist < 80 then
                self:FaceInstant(pos)

                self:EndPursuit()

                self:CallInCoroutine(function(self,delay)
                    self:PounceStart()
                end)
            end

            self:DrG_Timer(0.1, function()
                self.LeapTick = false
            end)
        end
    end
    
    function ENT:SpotEntity(ent)
        if self.CanSee then return self.BaseClass.SpotEntity(self, ent) end
        if self:IsPossessed() then return end
        if self:EntityInaccessible(ent) then return end
        if IsValid(self.CurrentVictim) then return end

        self:AlertedTo(ent:GetPos(), ent)
    end

    function ENT:AlertedTo(pos, ent)
        if self.CanSee then return end

        if not self.Alerted then
            if (ent.IsDrGNextbot and ent:IsPossessed()) then
                ent = ent:GetPossessor()
            end
            
            if not self.Pursuit then
                self.Pursuit = true

                self:CallOnClient('OnEnemySpotted', ent)

                self:OnSpotEnemy()
            end

            self.ForceRun = true
        end
        
        self:ClearPatrols()

        self:AddPatrolPos(pos)

        self.PursuePos = pos
    end

    function ENT:OnReachedPatrol()
        if self.Alerted then 
            self.Alerted = false
        end

        self:Wait(math.random(3, 7), function()
            if self.Alerted then return true end
        end)

        if not self.Alerted and self.Pursuit then 
            self:EndPursuit()
        end
    end

    function ENT:OnIdle()
        if self.Alerted then return end

        self:AddPatrolPos(self:RandomPos(1500))
    end

    function ENT:EndPursuit()
        if self.CanSee then return end

        self.Alerted = false
        self.Pursuit = false
        self.VoiceDisabled = false
        
        self.PursuePos = nil
        
        self:DrG_Timer(0.1, function()
            self.ForceRun = false
        end)
    end
    
    function ENT:OnStunned()
        self:StopVoices()

        if self.Weeping then
            self:StopWeeping()
        end

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
    
    function ENT:OnSpotEnemy()
        if self.Stunned then return end
        
        if self.Weeping then
            self:StopWeeping()
        end

        self:DrG_Timer(0.1, function()
            self:PlayVoiceLine(self.SpotVox[math.random(#self.SpotVox)])
        end)

        self:DrG_Timer(0.05, function()
            if self.CanSee then return end
            
            self:StopVoices(1)

            self.ForceRun = true

            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLoseEnemy()
        if self.Stunned then return end

        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
        end
    end

    function ENT:Removed()
    end

    -- Sounds --

    function ENT:OnHearNPCSound(ent, sound)
        if self.CanSee then return end
        
        self:SpotEntity(ent)
    end

    function ENT:StepSFX()
        local shake = 0.7

        if self:IsRunning() then
            self:EmitSound('whynotboi/securitybreach/base/roxannewolf/footsteps/run/fly_roxy_run_'.. math.random(1,11) .. '.wav')

            shake = 0.8
        else
            self:EmitSound('whynotboi/securitybreach/base/roxannewolf/footsteps/walk/fly_roxy_walk_'.. math.random(1,19) .. '.wav')
        end

        self:EmitSound('whynotboi/securitybreach/base/shatteredroxy/add/fly_roxy_shattered_add_0' .. math.random(6) .. '.wav')

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
FNaF_AddNextBot(ENT, 'Security Breach', 10)