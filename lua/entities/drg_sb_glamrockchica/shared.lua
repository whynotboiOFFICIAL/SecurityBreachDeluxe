if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Glamrock Chica'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/glamrockchica/glamrockchica.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanBeSummoned = true
ENT.CanBeStunned = true

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
ENT.SFXPath = 'whynotboi/securitybreach/base/glamrockchica'

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
            path = 'whynotboi/securitybreach/base/glamrockchica/servo/sfx_chica_servo_',
            count = 6,
            volume = 0.7,
            channel = CHAN_STATIC
        },
        ['servo_s'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/glamrockchica/servo/short/sfx_chica_servo_short_',
            count = 14,
            volume = 1,
            channel = CHAN_STATIC
        },
        ['servo_g'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/glamrockchica/servo/grind/sfx_chica_servo_head_grind_',
            count = 4,
            volume = 0.7,
            channel = CHAN_STATIC
        },
        ['headtwitch'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/glamrockchica/servo/headtwitch/sfx_chica_servo_head_twitch_',
            count = 14,
            volume = 1,
            channel = CHAN_STATIC
        },        
        ['rummage'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/glamrockchica/garbage/rummage/sfx_chica_garbage_rummage_',
            count = 6,
            volume = 1,
            channel = CHAN_STATIC
        },        
        ['garbageeat'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/glamrockchica/garbage/eat/sfx_chica_garbage_eat_',
            count = 6,
            volume = 1,
            channel = CHAN_STATIC
        }
    }

    -- Basic --

    function ENT:CustomInitialize()
    end

    function ENT:AddCustomThink()
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    -- Sounds --

    function ENT:StepSFX()
        local shake = 0.6

        if self:IsRunning() then
            self:EmitSound('whynotboi/securitybreach/base/glamrockchica/footsteps/run/fly_chica_run_'.. math.random(1,12) .. '.wav')

            shake = 0.7
        else
            self:EmitSound('whynotboi/securitybreach/base/glamrockchica/footsteps/walk/fly_chica_walk_'.. math.random(1,24) .. '.wav')
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)