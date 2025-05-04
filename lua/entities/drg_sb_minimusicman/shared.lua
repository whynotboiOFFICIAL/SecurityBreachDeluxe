if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Wind-Up Music Man'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/minimusicman/minimusicman.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(8, 8, 22)
ENT.BloodColor = DONT_BLEED

-- Stats --
ENT.SpawnHealth = 200

-- Speed --
ENT.WalkSpeed = 90
ENT.RunSpeed = 90

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'walk'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/bot/jumpscare/sfx_jumpScare_scream.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/minimusicman'
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

if SERVER then
    ENT.AnimEventSounds = {
        ['servo'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/minimusicman/servo/sfx_lmm_servo',
            volume = 1,
            channel = CHAN_STATIC
        },
        ['teethscrape'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/minimusicman/teeth/scrape/fly_lmm_teeth_chomp_scrape_',
            count = 5,
            volume = 0.45,
            channel = CHAN_STATIC
        },
        ['teethchomp'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/minimusicman/teeth/transient/fly_lmm_teeth_chomp_transient_',
            count = 6,
            volume = 0.45,
            channel = CHAN_STATIC
        },
        ['cymbol'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/minimusicman/cymbal/fly_lmm_cymbal_smash_',
            count = 5,
            volume = 1,
            channel = CHAN_STATIC
        },
    }

    -- Basic --

    function ENT:CustomInitialize()
        self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()

        if GetConVar('fnaf_sb_new_ldjmm_music'):GetBool() then
            self:EmitSound('whynotboi/securitybreach/base/minimusicman/music.wav',75, 100, 0.4)
        end
    end

    function ENT:AddCustomThink()
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/minimusicman/music.wav')
    end

    -- Sounds --

    function ENT:OnNewEnemy()
    end

    function ENT:OnLastEnemy()
    end

    function ENT:StepSFX()
        self:EmitSound('whynotboi/securitybreach/base/minimusicman/footsteps/walk/fly_lmm_walk_'.. math.random(1,10) .. '.wav', 75, 100, 0.6)
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 21)