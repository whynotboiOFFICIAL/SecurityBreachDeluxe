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

ENT.UseWalkframes = true

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

        if GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool() then
            anim = 'moonjumpscarehw'
        end

        self:PlaySequenceAndMove(anim)
    end

    function ENT:CustomInitialize()
        self:Timer(0, function()
            self.Target = nil

            self.loco:SetAcceleration(3000)
            self.loco:SetDeceleration(0)

            if GetConVar('fnaf_sb_new_moon_userun'):GetBool() then
                self.MoonRun = true
            end
    
            self:EmitSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_detail_lp.wav', 75, 100, 0.45)
            self:EmitSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_general_lp.wav', 75, 100, 0.45)

            self:SetDefaultRelationship(D_HT)

            self:SetSkin(1)
            self:SetBodygroup(1, 1)
    
            self.SFXPath = 'whynotboi/securitybreach/base/moon'
            
            self.IdleAnimation = 'moonidle1'
            self.WalkAnimation = 'moonwalk'
            
            if self.MoonRun then
                self.RunAnimation = 'moonrun'
            else
                self.RunAnimation = 'moonwalk'
            end
        end)

        self.SpawnPosition = self:GetPos()
        self.IdleCycles = 0
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
                    self.IdleAnimation = 'moonwalktocrawl'
                    self.WalkAnimation = 'moonwalktocrawl'
                    self.RunAnimation = 'moonwalktocrawl'
                end

                self.IdleCycles = 0
            end
        end

        if e == 'skittercycle' then
            if self:IsPossessed() then return end

            self.IdleCycles = self.IdleCycles + 1

            if self.IdleCycles > 3 and math.random(1,100) > 50 then
                if self.WalkAnimation ~= 'moonwalk' then
                    self.IdleAnimation = 'mooncrawltowalk'
                    self.WalkAnimation = 'mooncrawltowalk'
                    self.RunAnimation = 'mooncrawltowalk'
                end

                self.IdleCycles = 0
            end
        end

        if e == 'toskitter' then
            self.IdleAnimation = 'moonidle4'
            self.WalkAnimation = 'moonskitter'
            self.RunAnimation = 'moonskitter'
            
            self.Skittering = true

            self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 35))
        end

        if e == 'towalk' then
            self.IdleAnimation = 'moonidle1'
            self.WalkAnimation = 'moonwalk'
            self.RunAnimation = 'moonwalk'

            self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 75))

            self.Skittering = false

            if self:IsPossessed() then
                self.RunAnimation = 'moonrun'
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

    function ENT:OnNewEnemy()
    end

    function ENT:OnLoseEnemy()
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