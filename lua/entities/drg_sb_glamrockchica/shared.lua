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
ENT.HidingSpotSearch = true
ENT.SearchID = 'chica'

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
        if GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool() then
            self.HW2Jumpscare = true
        end
        
        if GetConVar('fnaf_sb_new_damaging'):GetBool() then
            self.GradualDamaging = true
        end

        if GetConVar('fnaf_sb_new_betaeyes'):GetBool() then
            self:SetBodygroup(2, 1)
        end

        if GetConVar('fnaf_sb_new_traileranims'):GetBool() then
            self.IdleAnimation = 'preidle'
            self.WalkAnimation = 'prewalk'
            self.RunAnimation = 'prerun'

            self.PreAnim = true
        end

        if GetConVar('fnaf_sb_new_chica_shred'):GetBool() then
            self.CanShred = true

            self.FreePatrols = 0
        end

        if GetConVar('fnaf_sb_new_chica_valley'):GetBool() then
            self.Valley = true
        end

        if GetConVar('fnaf_sb_new_chica_voiceattack'):GetBool() then
            self.Voicebox = true
        end
    end

    function ENT:SpawnGuitar()
        local guitar = ents.Create('prop_dynamic')
        
        guitar:SetModel('models/whynotboi/securitybreach/base/animatronics/glamrockchica/guitar.mdl')
        guitar:SetModelScale(1)
        guitar:SetParent(self)
        guitar:SetSolid(SOLID_NONE)

        guitar:Fire('SetParentAttachment','World_Prop_jnt')

        guitar:Spawn()

        self:DeleteOnRemove(guitar)

        self.Guitar = guitar
    end

    function ENT:ShredGuitar()
        self:StopVoices()

        self.VoiceDisabled = true

        self:EmitSound('whynotboi/securitybreach/base/glamrockchica/sfx_chicajam_guitarsolo_loop_b.wav')

        self:SpawnGuitar()

        self:PlaySequenceAndMove('shredding')

        self:StopSound('whynotboi/securitybreach/base/glamrockchica/sfx_chicajam_guitarsolo_loop_b.wav')
        
        self.VoiceDisabled = false

        self.Guitar:Remove()

        if math.random(1, 100) > 50 then
            self.FreePatrols = 0
        end
    end

    function ENT:AddCustomThink()
        if self.Luring and not self.Stunned then
            self:OnPatrolling()
        end

        if GetConVar('fnaf_sb_new_chica_breaths'):GetBool() then
            self:BreathThink()
        end
    end

    function ENT:CustomAnimEvents(e)
        if e == 'sfx_rummage' then
            ParticleEffectAttach( 'fnafsb_chicagrabfood', 4, self, 2 )
        end
        if e == 'sfx_garbageeat' then
            ParticleEffectAttach( 'fnafsb_slime_eating', 4, self, 3 )
        end
    end
        
    function ENT:OnReachedPatrol()
        if self.FreePatrols then
            self.FreePatrols = self.FreePatrols + 1
        end

        self.BaseClass.OnReachedPatrol(self)
    end

    function ENT:OnIdle()
        if (self.CanShred and not self.ShredDelay) and (self.FreePatrols > 5 and math.random(100) > 50) then
            self:ShredGuitar()
        else
            self.BaseClass.OnIdle(self)
        end
    end

    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/glamrockchica/sfx_chicajam_guitarsolo_loop_b.wav')

        if IsValid(self.LuringTo) then
            self.LuringTo.BeingDevoured = false
        end
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
FNaF_AddNextBot(ENT, 'Security Breach', 3)