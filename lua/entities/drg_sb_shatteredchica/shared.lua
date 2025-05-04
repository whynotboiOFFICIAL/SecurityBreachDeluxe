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
ENT.DynamicListening = true
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
        self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()

        self.CanSpeak = GetConVar('fnaf_sb_new_shatteredchica_hasvoice'):GetBool()
        self.AIEating = GetConVar('fnaf_sb_new_shatteredchica_canlure'):GetBool()
        self.PlayerEating = GetConVar('fnaf_sb_new_shatteredchica_playereat'):GetBool()

        self:SetBodygroup(2, GetConVar('fnaf_sb_new_shattereds_redeyes'):GetInt())

        if self.CanSpeak then
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
        if IsValid(self.LuringTo) then
            self.LuringTo.BeingDevoured = false
        end
    end

    function ENT:LuredToMix(ent)
        self:StopVoices() 
        
        self:SetDefaultRelationship(D_LI)

        if self.CanSpeak then
            self:PlayVoiceLine(self.ScroakVox[math.random(#self.ScroakVox)])
        else
            self:PlayVoiceLine(self.LowVox[math.random(#self.LowVox)])
        end

        self:CallInCoroutine(function(self,delay)
            self.Luring = true
            self.LuringTo = ent
            self.VoiceDisabled = true

            self:GoTo(ent:GetPos() + ent:GetForward() * 35)

            if not IsValid(ent) then self.Luring = false return end

            ent:SetBodygroup(1, 1)

            self:SetVelocity(vector_origin)

            self:SetPos(ent:GetPos() + ent:GetForward() * 35)

            self:FaceInstant(ent)

            self.DisableControls = true
            self.Moving = false

            self:SetAIDisabled(true)

            self.IdleAnimation = 'rummageloop'

            self:PlaySequenceAndMove('rummagein')

            self:DrG_Timer(6, function()
                ParticleEffectAttach( 'fnafsb_drool_chica', 4, self, 3 )
            end)
            
            self:DrG_Timer(10, function()
                if IsValid(ent) then
                    ent:SetBodygroup(2, 1)
                end

                self:CallInCoroutine(function(self,delay)
                    self.IdleAnimation = 'idle'
                    self:PlaySequenceAndMove('rummageout')

                    self.DisableControls = false
                    self.Luring = false
                    self.VoiceDisabled = false

                    self.LuringTo = nil

                    self:SetAIDisabled(false)
                    self:SetDefaultRelationship(D_HT)
                end)
            end)
        end)
    end
    
    function ENT:OnStunned()
        self:StopVoices()

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunin') 
        end)

        if self.CanSpeak then
            self:PlayVoiceLine(self.ScroakVox[math.random(#self.ScroakVox)])
        else
            self:PlayVoiceLine(self.HighVox[math.random(#self.HighVox)])
        end

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
        
        self:DrG_Timer(0.1, function()
            if self.CanSpeak then
                self:PlayVoiceLine(self.ScroakVox[math.random(#self.ScroakVox)])
            else
                self:PlayVoiceLine(self.HighVox[math.random(#self.HighVox)])
            end
        end)
        
        self:DrG_Timer(0.05, function()
            self:StopVoices(1)

            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLoseEnemy()
        if self.Stunned or not self.CanSpeak then return end

        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
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

        self:EmitSound('whynotboi/securitybreach/base/shatteredchica/add/fly_chica_shattered_add_0' .. math.random(6) .. '.wav')

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 8)