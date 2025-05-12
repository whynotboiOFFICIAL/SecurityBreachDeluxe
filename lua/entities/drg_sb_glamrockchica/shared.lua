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
        self:SetMovement(60, 200)
        self:SetMovementRates(1, 1, 1)

        self:SetSightRange(1200 * GetConVar('fnaf_sb_new_multiplier_sightrange'):GetFloat())

        self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()
        self.GradualDamaging = GetConVar('fnaf_sb_new_damaging'):GetBool()
        self.DynamicListening = GetConVar('fnaf_sb_new_sounddetect'):GetBool()
        self.PreAnim = GetConVar('fnaf_sb_new_traileranims'):GetBool()

        self.BreathEnabled = GetConVar('fnaf_sb_new_chica_breaths'):GetBool()
        self.CanShred = GetConVar('fnaf_sb_new_chica_shred'):GetBool()
        self.Valley = GetConVar('fnaf_sb_new_chica_valley'):GetBool()
        self.Voicebox = GetConVar('fnaf_sb_new_chica_voiceattack'):GetBool()
        self.AIEating = GetConVar('fnaf_sb_new_chica_canlure'):GetBool()
        self.PlayerEating = GetConVar('fnaf_sb_new_chica_playereat'):GetBool()

        self:SetBodygroup(2, GetConVar('fnaf_sb_new_betaeyes'):GetInt())

        if self.CanShred then
            self.FreePatrols = 0
        end

        if self.Valley then           
            self:ValleyInit()
        end

        if self.PreAnim then
            self.IdleAnimation = 'preidle'
            self.WalkAnimation = 'prewalk'
            self.RunAnimation = 'prerun'

            self:SetMovement(60, 240)
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

        self:PlaySequenceAndMove('shredding', nil, function()
            if self:HasEnemy() or self.Luring then 
                return true 
            end
        end)

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

        if self.BreathEnabled then
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
        
    function ENT:OnStunned()
        self:StopVoices()

        self:CallInCoroutine(function(self,delay)
            self:PlayVoiceLine(self.StunVox[math.random(#self.StunVox)], true)
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        if self.PreAnim then
            self.IdleAnimation = 'preidle'
        else
            self.IdleAnimation = 'idle'
        end
    end

    function ENT:LuredToMix(ent)
        self:StopVoices() 
        
        self:SetDefaultRelationship(D_LI)

        self:CallInCoroutine(function(self,delay)
            
            local snd = self.PizzaVox[math.random(#self.PizzaVox)]

            self:PlayVoiceLine(snd, true) 

            if not IsValid(ent) then return end

            self.NullifyVoicebox = true
            self.Luring = true
            self.StunDisabled = true
            self.VoiceDisabled = true

            self.LuringTo = ent

            self:GoTo(ent:GetPos() + ent:GetForward() * 35)

            if not IsValid(ent) then self.Luring = false self.StunDisabled = false return end

            ent:SetBodygroup(1, 1)

            self:SetVelocity(vector_origin)

            self:SetPos(ent:GetPos() + ent:GetForward() * 35)

            self:FaceInstant(ent)

            self.DisableControls = true
            self.Moving = false

            self:SetAIDisabled(true)

            self.IdleAnimation = 'rummageloop'

            self:PlaySequenceAndMove('rummagein')

            self:PlayVoiceLine('CHICA_EATING_GARBAGE_0' .. math.random(2))

            self:DrG_Timer(6, function()
                ParticleEffectAttach( 'fnafsb_drool_chica', 4, self, 3 )
            end)
            
            self:DrG_Timer(10, function()
                if IsValid(ent) then
                    ent:SetBodygroup(2, 1)
                end

                self:CallInCoroutine(function(self,delay)
                    if self.PreAnim then
                        self.IdleAnimation = 'preidle'
                    else
                        self.IdleAnimation = 'idle'
                    end

                    self:PlaySequenceAndMove('rummageout')

                    self.DisableControls = false
                    self.Luring = false
                    self.NullifyVoicebox = false
                    self.VoiceDisabled = false
                    self.StunDisabled = false

                    self.LuringTo = nil

                    self:SetAIDisabled(false)
                    self:SetDefaultRelationship(D_HT)
                end)
            end)
        end)
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

    function ENT:OnSpotEnemy()
        if self.Stunned then return end
        
        self.VoiceDisabled = true
        
        if self.VoiceCancel then
            self:VoiceCancel()
        end
        
        self:DrG_Timer(0.1, function()
            if self.FreePatrols then
                self.FreePatrols = 0
            end

            self:PlayVoiceLine(self.SpotVox[math.random(#self.SpotVox)], true)             
        end)
        
        self:DrG_Timer(0.05, function()
            self:StopVoices(1)
        end)
    end

    function ENT:OnLoseEnemy()
        if self.Stunned then return end

        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceCancel = self:SBTimer(4, function()
                self.VoiceDisabled = false
            end)
        end

        self:StopVoices(2)

        if IsValid(self.CurrentVictim) then return end

        self:DrG_Timer(0.05, function()
            self:PlayVoiceLine(self.LostVox[math.random(#self.LostVox)], true)
        end)
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