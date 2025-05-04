if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Moon'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/daycareattendant/daycareattendant.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanBeStunned = true
ENT.DynamicListening = true

-- Stats --
ENT.SpawnHealth = 1000

-- Animations --
ENT.WalkAnimation = 'moonwalk'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'moonwalk'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'moonidle1'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'moonidle1'
ENT.JumpAnimRate = 1

-- Speed --
ENT.WalkSpeed = 136
ENT.RunSpeed = 136

-- Sounds --
ENT.DisableMat = true
ENT.JumpscareSound = 'whynotboi/securitybreach/base/bot/jumpscare/sfx_jumpScare_scream.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/moon'

-- Detection --
ENT.EyeBone = 'Head_jnt'
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

ENT.DefaultRelationship = D_LI

include('voice.lua')
include('binds.lua')

if SERVER then

    ENT.AnimEventSounds = {
        ['mvmt_large'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/moon/mech/mvmtlarge/sfx_moonman_mech_mvmt_large_',
            count = 6,
            volume = 0.45,
            channel = CHAN_STATIC
        },
        ['mvmt_small'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/moon/mech/mvmtsmall/sfx_moonman_mech_mvmt_small_',
            count = 8,
            volume = 0.45,
            channel = CHAN_STATIC
        },
        ['springwronk'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/moon/mech/springwronk/sfx_moonman_mech_spring_wronk_',
            count = 6,
            volume = 0.45,
            channel = CHAN_STATIC
        },
        ['headspin'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/moon/mech/headspin/sfx_moonman_mech_head_spin_',
            count = 5,
            volume = 1,
            channel = CHAN_STATIC
        }
    }

    -- Basic --

    function ENT:Jumpscare()
        if self.JumpscareSound then
            self:EmitSound(self.JumpscareSound)
        end
    
        self:RemoveAllGestures()
    
        local anim = 'moonjumpscare'

        if self.HW2Jumpscare then
            anim = 'moonjumpscarehw'
        end

        self:PlaySequenceAndMove(anim)
    end

    function ENT:CustomInitialize()
        self:Timer(0, function()
            self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()

            self.MoonRun = GetConVar('fnaf_sb_new_moon_userun'):GetBool()
            self.CanFlashStun = GetConVar('fnaf_sb_new_moon_flashstun'):GetBool()
            self.JackOMoon = GetConVar('fnaf_sb_new_moon_jackomoon'):GetBool()

            self.loco:SetAcceleration(3000)
            self.loco:SetDeceleration(0)

            self:EmitSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_detail_lp.wav', 75, 100, 0.45)
            self:EmitSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_general_lp.wav', 75, 100, 0.45)

            self:SetDefaultRelationship(D_HT)

            self:SetSkin(1)
            self:SetBodygroup(1, 1)
    
            self.SFXPath = 'whynotboi/securitybreach/base/moon'
            
            if self.MoonRun then
                self.RunAnimation = 'moonrun'

                self:SetMovement(136, 230)
            end
                
            if self.JackOMoon then
                self:ApplyJackO()
            end
        end)

        self.SpawnPosition = self:GetPos()
        self.IdleCycles = 0
        self.FlashTolerance = 0
    end

    function ENT:ApplyJackO()
        self:SetModel('models/whynotboi/securitybreach/base/animatronics/daycareattendant/jackomoon.mdl')

        self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 75))

        self.SearchingVox = {
            'Moon_Carousel_001',
            'Moon_Carousel_002',
            'Moon_Carousel_004',
            'Moon_Laugh_001',
            'Moon_Laugh_002',
            'Moon_Laugh_003',
            'Moon_Laugh_004'
        }
        
        self.ListeningVox = {
            'Moon_Carousel_003',
            'Moon_Laugh_003',
            'Moon_Laugh_004'
        }
                
        self.SpotVox = {
            'Moon_Carousel_003',
            'Moon_Carousel_004',
            'Moon_Carousel_005',
            'Moon_Laugh_001',
            'Moon_Laugh_002',
            'Moon_Laugh_003',
            'Moon_Laugh_004'
        }
       
        self.PursuitVox = {
            'Moon_Carousel_005'
        }

        self.LostVox = {
            'Moon_Laugh_001',
            'Moon_Laugh_002',
            'Moon_Laugh_003',
            'Moon_Laugh_004'
        }
    end

    function ENT:SpawnHook(pos)
        local hook = ents.Create('prop_dynamic')
        
        hook:SetModel('models/whynotboi/securitybreach/base/animatronics/daycareattendant/hook.mdl')
        hook:SetModelScale(1)
        hook:SetParent(self)
        hook:SetSolid(SOLID_NONE)

        hook:Fire('SetParentAttachment','Hook')

        hook:Spawn()

        self:DeleteOnRemove(hook)

        self.HookModel = hook
        
        constraint.Elastic(
            self, 
            game.GetWorld(), 
            0, 0, 
            self:WorldToLocal(self:GetBonePosition(0)), 
            pos, 
            59, 59, 0, 
            nil, 2
        )
    end

    function ENT:StartHook()
        local hookpos = self:HookTrace()

        if hookpos then

            self.JumpAnimation = 'moonswimloop'

            self.Swimming = true
            
            self.loco:SetVelocity(vector_origin)
            self.loco:SetGravity(0)
            

            local oldhookpos = Vector(hookpos)

            hookpos.z = hookpos.z - (hookpos.z - self:GetPos().z) / 2

            self:SetPos(hookpos)

            self:SpawnHook(oldhookpos)
        end
    end

    function ENT:CustomThink()
        if self.Stunned then return end

        if self.CanFlashStun then
            if self:BeingFlashed() and not self.Shaking then
                self.Shaking = true

                self:AddGestureSequence(self:LookupSequence('shake'), false)
            end

            if not self:BeingFlashed() and self.Shaking then
                self.Shaking = false

                self:RemoveAllGestures()
            end

            if not self.FlashTick then
                self.FlashTick = true

                if self.Shaking then
                    if self.FlashTolerance < 10 then
                        self.FlashTolerance = self.FlashTolerance + 1
                    else
                        self:FlashStun()

                        self.FlashTolerance = 0
                    end
                else
                    if self.FlashTolerance > 0 then
                        self.FlashTolerance = self.FlashTolerance - 2
                    end
                end     

                self:DrG_Timer(0.2, function()
                    self.FlashTick = false
                end)
            end
        end
        
        if self.VoiceThink then
            self:VoiceThink()
        end

        if self.Swimming then
            if self:IsPossessed() then
                local ply = self:GetPossessor()
                local currentVelocity = vector_origin

                if ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_BACK)  then
                    currentVelocity = currentVelocity + self:GetForward() * 100

                    hasmoved = true
                end

                if ply:KeyDown(IN_JUMP) then
                    currentVelocity = currentVelocity + vector_up * 100
                    hasmoved = true
                end

                if ply:KeyDown(IN_DUCK) then
                    currentVelocity = currentVelocity + vector_up * -100
                    hasmoved = true
                end

                self:SetVelocity(currentVelocity)
            end
        end
    end

    function ENT:HookTrace()
        local startpS = self:WorldSpaceCenter()
        local endpos = Vector(0, 0, 1e9)
        local tr = util.QuickTrace(startpS, endpos, self)
        --debugoverlay.Line( startpS, startpS + endpos, 1, Color( 255, 255, 255 ), false )
        
        if tr.Hit and not tr.HitSky then
            return tr.HitPos
        end
    end

    function ENT:CustomAnimEvents(e) 
        if e == 'idlecycle' then
            self.IdleCycles = self.IdleCycles + 1

            if self.IdleCycles > 3 then
                if self.IdleAnimation ~= 'moonidle3' then
                    if math.random(1,100) > 50 then
                        self.IdleAnimation = 'moonidle' .. math.random(2,3)
                    end
                else
                    self.IdleAnimation = 'moonidle1'
                end

                self.IdleCycles = 0
            end
        end

        if e == 'walkcycle' then
            if self:IsPossessed() then return end

            self.IdleCycles = self.IdleCycles + 1

            if self.IdleCycles > 3 and math.random(1,100) > 50 then
                if self.WalkAnimation ~= 'moonskitter' then
                    self:CallInCoroutine(function(self,delay)
                        self:PlaySequenceAndMove('moonwalktocrawl')
                    end)
                end

                self.IdleCycles = 0
            end
        end

        if e == 'skittercycle' then
            if self:IsPossessed() then return end

            self.IdleCycles = self.IdleCycles + 1

            if self.IdleCycles > 3 and math.random(1,100) > 50 then
                if self.WalkAnimation ~= 'moonwalk' then
                    self:CallInCoroutine(function(self,delay)
                        self:PlaySequenceAndMove('mooncrawltowalk')
                    end)
                end

                self.IdleCycles = 0
            end
        end

        if e == 'toskitter' then
            self:SetMovementAnims('moonidle4', 'moonskitter', 'moonskitter')
            
            self:SetMovement(136, 136)

            self.Skittering = true

            self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 35))
        end

        if e == 'towalk' then
            self:SetMovementAnims('moonidle1', 'moonwalk', 'moonwalk')

            self:SetMovement(136, 136)

            self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 75))

            self.Skittering = false

            if self:IsPossessed() then
                self.RunAnimation = 'moonrun'

                self:SetMovement(136, 230)
            end
        end

        if e == 'toidle' then
            self.IdleAnimation = 'moonidle1'
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_detail_lp.wav')
        self:StopSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_general_lp.wav')
    end
       
    function ENT:FlashStun()
        self:StopVoices()
        
        self:RemoveAllGestures()

        self:PlayVoiceLine(self.StunVox[math.random(#self.StunVox)], false)

        self.IdleAnimation = 'idlesad'

        self.Stunned = true
        self.NullifyVoicebox = true
        self.DisableControls = true

        self:SetAIDisabled(true)

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('moonstun')
        end)
        
        self:DrG_Timer(8, function()
            self:OnStunExit()

            self.Stunned = false
            self.NullifyVoicebox = false
            self.DisableControls = false

            self:SetAIDisabled(false)
        end)
    end

    function ENT:OnStunned()
        self:StopVoices()

        self:RemoveAllGestures()

        self:PlayVoiceLine(self.StunVox[math.random(#self.StunVox)], false)

        self.IdleAnimation = 'idlesad'
    end

    function ENT:OnStunExit()
        if self.Skittering then
            self.IdleAnimation = 'moonidle4'
        else
            self.IdleAnimation = 'moonidle1'
        end
    end

    function ENT:OnNewEnemy()
        if self.Stunned then return end
        
        self.VoiceDisabled = true
             
        if self.VoiceCancel then
            self:VoiceCancel()
        end

        self:DrG_Timer(0.1, function()
            if math.random(1, 100) > 50 then
                self:PlayVoiceLine(self.PursuitVox[math.random(#self.PursuitVox)], true)
            else
                self:PlayVoiceLine(self.SpotVox[math.random(#self.SpotVox)], true)
            end             
        end)
        
        self:DrG_Timer(0.05, function()
            self:StopVoices(1)
        end)
    end

    function ENT:OnLastEnemy()
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
    
    -- Sounds --

    function ENT:StepSFX()
        self:EmitSound('whynotboi/securitybreach/base/moon/footsteps/walk/fly_moonMan_walk_0' .. math.random(8) .. '.wav')
        self:EmitSound('whynotboi/securitybreach/base/moon/footsteps/bells/sfx_moonman_step_bells_0' .. math.random(8) .. '.wav')
    end
else
end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 7)