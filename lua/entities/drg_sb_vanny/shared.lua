if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Vanny'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/humans/vanny/vanny.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(8, 8, 75)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.CanBeSummoned = true

-- Stats --
ENT.SpawnHealth = 150

-- Animations --
ENT.WalkAnimation = 'skip'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'run'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Speed -- 
ENT.WalkSpeed = 0
ENT.RunSpeed = 0

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/vanny/jumpscare/sfx_jumpScare_vanny.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/vanny'
ENT.DisableMat = true

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
        if GetConVar('fnaf_sb_new_vanny_preidle'):GetBool() then
            self.IdleAnimation = 'idlepre'
        end

        if GetConVar('fnaf_sb_new_vanny_prewalk'):GetBool() then
            self.WalkAnimation = 'walkpre' .. math.random(3)
        end

        if GetConVar('fnaf_sb_new_vanny_prerun'):GetBool() then
            self.RunAnimation = 'runpre'
        end
    end

    function ENT:Jumpscare()
        if GetConVar('fnaf_sb_new_vanny_prejumpscare'):GetBool() then
            self:EmitSound('whynotboi/securitybreach/base/vanny/jumpscare/sfx_jumpScare_vanny_pre.wav')

            self:RemoveAllGestures()
        
            self:PlaySequenceAndMove('jumpscarepre')
        else
            self.BaseClass.Jumpscare(self)
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    function ENT:StepSFX()
        self:EmitSound('whynotboi/securitybreach/base/vanny/footsteps/walk/fly_vanny_walk_0' .. math.random(6) .. '.wav')
    end

    function ENT:CustomAnimEvents(e)
        if e == 'scuff' then
            self:EmitSound('whynotboi/securitybreach/base/vanny/scuff/fly_vanny_scuff_0' .. math.random(6) .. '.wav')
        end
    end
else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 13)