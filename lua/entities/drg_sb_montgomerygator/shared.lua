if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Montgomery Gator'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/montgomerygator/montgomerygator.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanPounce = true
ENT.CanBeSummoned = true
ENT.HidingSpotSearch = true
ENT.SearchID = 'monty'

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
ENT.JumpscareSound = 'whynotboi/securitybreach/base/bot/jumpscare/sfx_jumpScare_scream.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/montgomerygator'

ENT.PounceJumpSounds = {
    '/leap/fly_monty_leap_01.wav',
    '/leap/fly_monty_leap_02.wav',
    '/leap/fly_monty_leap_03.wav',
    '/leap/fly_monty_leap_04.wav'
}

ENT.PounceLandSounds = {
    '/land/fly_monty_land_01.wav',
    '/land/fly_monty_land_02.wav',
    '/land/fly_monty_land_03.wav'
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
        ['servo_l'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/montgomerygator/servo/large/sfx_servo_large_',
            count = 4,
            volume = 0.45,
            channel = CHAN_STATIC
        }
    }
    -- Basic --

    function ENT:CustomInitialize()
        if GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool() then
            self.HW2Jumpscare = true
        end
        
        if GetConVar('fnaf_sb_new_damaging'):GetBool() then
            self.GradualDamaging = true
        end

        if GetConVar('fnaf_sb_new_monty_transglass'):GetBool() then
            self:SetBodygroup(2, 1)
        end

        if GetConVar('fnaf_sb_new_betaeyes'):GetBool() then
            self:SetBodygroup(3, 1)
        end

        if GetConVar('fnaf_sb_new_traileranims'):GetBool() then
            self.IdleAnimation = 'preidle'
            self.WalkAnimation = 'prewalk'
            self.RunAnimation = 'prerun'

            self.PreAnim = true
        end

        if not GetConVar('fnaf_sb_new_monty_pounceattack'):GetBool() then
            self.CanPounce = false
        end

        if GetConVar('fnaf_sb_new_monty_enablestun'):GetBool() then
            self.CanBeStunned = true
        end
    end

    function ENT:AddCustomThink()
    end

    function ENT:Removed()
    end

    -- Sounds --

    function ENT:StepSFX()
        local shake = 0.8

        if self:IsRunning() then
            self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/run/fly_monty_run_'.. math.random(1,23) .. '.wav')

            shake = 1
        else
            self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/walk/fly_monty_walk_'.. math.random(1,19) .. '.wav')
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 4)