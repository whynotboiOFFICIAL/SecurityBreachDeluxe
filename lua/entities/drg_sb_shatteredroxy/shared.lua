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
        self:SetSightFOV(0)
    end

    function ENT:SpotEntity(ent)
        if IsValid(self.CurrentVictim) or self.Stunned or self.PounceStarted then return end
        if GetConVar('ai_disabled'):GetBool() or (ent:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool()) then return end
        if (ent:IsPlayer() and IsValid(ent:DrG_GetPossessing())) or (ent.IsDrGNextbot and ent:IsInFaction('FACTION_ANIMATRONIC')) or ent:Health() < 1 then return end

        self:AlertedTo(ent:GetPos(), ent)
    end

    function ENT:AlertedTo(pos)
        if not self.Alerted then
            self.WalkAnimation = 'run'

            self:OnSpotEnemy()
            self:CallOnClient('OnEnemySpotted', ent)

            self.Alerted = true
        end
        
        self:ClearPatrols()

        self:AddPatrolPos(pos)

        self.PursuePos = pos
    end

    function ENT:OnReachedPatrol()
        if self.Alerted then 
            self:EndPursuit()
        end

        self:Wait(math.random(3, 7), function()
            if self.Alerted then return true end
        end)
    end

    function ENT:OnIdle()
        if self.Alerted then return end

        self:AddPatrolPos(self:RandomPos(1500))
    end

    function ENT:EndPursuit()
        self.Alerted = false
        self.VoiceDisabled = false

        self.WalkAnimation = 'walk'
        
        self.PursuePos = nil
    end

    function ENT:AddCustomThink()
        if self.Stunned or self.PounceStarted then return end
        
        if not self.KillTick then
            self.KillTick = true

            for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 30)) do
                if (v == self or v == self:GetPossessor()) or (v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC')) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and IsValid(v:DrG_GetPossessing())) or v:Health() < 1 then continue end
                self:CallInCoroutine(function(self,delay)
                    self:JumpscareEntity(v)
                end)
            end

            self:DrG_Timer(0.3, function()
                self.KillTick = false
            end)
        end

        if self.PursuePos and not self.LeapTick then
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

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    -- Sounds --

    function ENT:OnHearNPCSound(ent, sound)
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