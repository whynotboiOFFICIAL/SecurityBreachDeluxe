if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Shattered Monty'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/shatteredmonty/shatteredmonty.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(15, 15, 25)
ENT.BloodColor = DONT_BLEED
ENT.CanPounce = true
ENT.CanBeSummoned = true
ENT.CanBeStunned = true
ENT.HidingSpotSearch = true

-- Stats --
ENT.SpawnHealth = 600

-- Animations --
ENT.WalkAnimation = 'crawl'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'crawlfast'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/shatteredmonty/jumpscare/sfx_jumpScare_monty.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/shatteredmonty'
ENT.VOPath = 'whynotboi/securitybreach/base/montgomerygator'

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

include('binds.lua')
include('voice.lua')

if SERVER then
    ENT.AnimEventSounds = {
        ['servo'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/shatteredmonty/servo/sfx_monty_servo_shattered_',
            count = 4,
            volume = 0.45,
            channel = CHAN_STATIC
        }
    }
    -- Basic --

    function ENT:CustomInitialize()
        self:SetMovement(60, 160)
        self:SetMovementRates(1, 1, 1)

        self:SetSightRange(1000 * GetConVar('fnaf_sb_new_multiplier_sightrange'):GetFloat())

        self.DynamicListening = GetConVar('fnaf_sb_new_sounddetect'):GetBool()
        
        self.CanPounce = GetConVar('fnaf_sb_new_shatteredmonty_pounceattack'):GetBool()
        self.HasLegs = GetConVar('fnaf_sb_new_shatteredmonty_haslegs'):GetBool()

        if self.HasLegs then
            self:SetModel('models/whynotboi/securitybreach/base/animatronics/shatteredmonty/shatteredmontywithlegs.mdl')
            
            self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 75))

            self:SetMovementAnims('idle', 'walk', 'run', 'idle')
            self:SetMovement(60, 240)
        end

        self:SetBodygroup(1, GetConVar('fnaf_sb_new_shattereds_redeyes'):GetInt())
    end

    function ENT:AddCustomThink()
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    function ENT:OnStunned()
        self:StopVoices()

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunin') 
        end)

        self:PlayVoiceLine(self.StunVox[math.random(#self.StunVox)], false)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        self.IdleAnimation = 'idle'
    end
    
    -- Sounds --

    function ENT:StepSFX()
        local shake = 0.1

        if self.HasLegs then
            shake = 0.8

            if self:IsRunning() then
                self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/run/fly_monty_run_'.. math.random(1,23) .. '.wav')

                shake = 1
            else
                self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/walk/fly_monty_walk_'.. math.random(1,19) .. '.wav')
            end
        else
            self:EmitSound('whynotboi/securitybreach/base/shatteredmonty/handtouch/fly_monty_shattered_handTouch_0'.. math.random(6) .. '.wav')
            self:EmitSound('whynotboi/securitybreach/base/shatteredmonty/add/fly_monty_shattered_add_0'.. math.random(6) .. '.wav')
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 9)