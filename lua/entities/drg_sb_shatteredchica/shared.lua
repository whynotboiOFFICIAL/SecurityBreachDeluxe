if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Shattered Chica'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/shatteredchica/shatteredchica.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanBeSummoned = true
ENT.CanBeStunned = true
ENT.HidingSpotSearch = true
ENT.SearchID = 'chica'

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
ENT.JumpscareSound = 'whynotboi/securitybreach/base/shatteredchica/jumpscare/sfx_jumpScare_shattered_chica.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/shatteredchica'

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
            path = 'whynotboi/securitybreach/base/shatteredchica/servo/sfx_chica_servo_shattered_',
            count = 4,
            volume = 0.9,
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
        if GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool() then
            self.HW2Jumpscare = true
        end

        if GetConVar('fnaf_sb_new_shattereds_redeyes'):GetBool() then
            self:SetBodygroup(2, 1)
        end

        if GetConVar('fnaf_sb_new_shatteredchica_hasvoice'):GetBool() then
            self.CanSpeak = true

            self.VOPath = 'whynotboi/securitybreach/base/glamrockchica'
            
            self:SpawnBeak()
        end
    end

    function ENT:SpawnBeak()
        local beak = ents.Create('prop_dynamic')
        
        beak:SetModel('models/whynotboi/securitybreach/base/animatronics/shatteredchica/shatteredchicabeak.mdl')
        beak:SetModelScale(1)
        beak:SetParent(self)
        beak:SetSolid(SOLID_NONE)
        
        beak:AddEffects(EF_BONEMERGE)

        beak:Spawn()

        beak:Fire('SetParentAttachment','Jumpscare_jnt')

        self:DeleteOnRemove(beak)
    end

    function ENT:AddCustomThink()
    end

    function ENT:OnDeath()
    end
    
    function ENT:CustomAnimEvents(e)
        if e == 'sfx_rummage' then
            ParticleEffectAttach( 'fnafsb_chicagrabfood', 4, self, 2 )
        end
        if e == 'sfx_garbageeat' then
            ParticleEffectAttach( 'fnafsb_slime_eating', 4, self, 3 )
        end
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

        self:EmitSound('whynotboi/securitybreach/base/shatteredchica/add/fly_chica_shattered_add_0' .. math.random(6) .. '.wav')

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 8)