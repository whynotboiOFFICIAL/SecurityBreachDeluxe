if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Sun'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/daycareattendant/daycareattendant.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanBeStunned = true

-- Stats --
ENT.SpawnHealth = 1000

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'walk'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Speed --
ENT.WalkSpeed = 150
ENT.RunSpeed = 150

-- Sounds --
ENT.DisableMat = true
ENT.JumpscareSound = 'whynotboi/securitybreach/base/bot/jumpscare/sfx_jumpScare_scream.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/sun'

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
            path = 'whynotboi/securitybreach/base/sun/mech/mvmtlarge/sfx_sunman_mech_mvmt_large_',
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
            path = 'whynotboi/securitybreach/base/sun/mech/headspin/sfx_moonman_mech_head_spin_',
            count = 5,
            volume = 1,
            channel = CHAN_STATIC
        }
    }

    -- Basic --

    function ENT:CustomInitialize()
        self:Timer(0, function()
            self.Target = nil

            self.loco:SetAcceleration(3000)
            self.loco:SetDeceleration(0)

            self.AlwaysAngry = GetConVar('fnaf_sb_new_sun_alwayshostile'):GetBool()
            
            self.SunAnger = 0

            if self.AlwaysAngry then
                self.SunAnger = 6
            end
    
            self:EmitSound('whynotboi/securitybreach/base/sun/mech/sfx_sunman_mech_lp.wav', 75, 100, 0.45)

            self:SetDefaultRelationship(D_HT)

            self:SetSkin(0)
            self:SetBodygroup(1, 0)
        end)

        self.SpawnPosition = self:GetPos()
        self.IdleCycles = 0
    end

    function ENT:SpotEntity(ent)
        if self:IsPossessed() then return end
        if self:EntityInaccessible(ent) then return end
        if IsValid(self.Target) then return end
        
        if self.AlwaysAngry then
            self:PlayVoiceLine(self.AngerVox[math.random(7,9)], false)
        else
            self:PlayVoiceLine('SUN_00001')
        end
        
        self.Target = ent
    end
    
    function ENT:LoseEntity(ent)
        if self.Target == ent then
            self.Target = nil
        end

        self.BaseClass.LoseEntity(self, ent)
    end

    function ENT:JumpscareEntity(ent)
        if self.SunAnger > 5 then
            self.BaseClass.JumpscareEntity(self, ent)
        end
    end

    function ENT:Jumpscare()
        if self.JumpscareSound then
            self:EmitSound(self.JumpscareSound)
        end
    
        self:RemoveAllGestures()
    
        local anim = 'jumpscare'

        self:PlaySequenceAndMove(anim)

        self:PlayVoiceLine('SUN_HW2_00067')

        if not self.AlwaysAngry then
            self.SunAnger = 0

            self.ForceRun = false
        end
    end

    function ENT:GrabEntity(ply)
        self:EnterCinematic(ply)
        
        self.HoldEnt = ply

        self.Holding = true
        self.WalkAnimation = 'walkcarry'
        self.RunAnimation = 'walkcarry'
        self.IdleAnimation = 'walkcarry'
    end

    function ENT:CustomThink()
        if self.Stunned then return end

        local aiDisabled = self:GetAIDisabled() or self:IsPossessed()
        local aiIgnorePlayers = self:GetIgnorePlayers()

        if self.Holding then
            if aiDisabled and not self:IsPossessed() then
                self:OnReachedPatrol()
                return
            end

            self.SpawnPosition.z = self:GetPos().z

            self:ClearPatrols()
            self:AddPatrolPos(self.SpawnPosition)

            return
        end

        if aiDisabled then return end

        local ply = self.Target
        
        if not ply then return end

        if not ply:IsValid() then return end

        if (ply:IsPlayer() and aiIgnorePlayers) or (self:EntityInaccessible(ply)) then return end

        local ang = ply:GetAngles()

        if ply:IsPlayer() then
            ang = ply:EyeAngles()
        end

        ang.x = 0

        local forward = ang:Forward()

        local plyPos = ply:GetPos()
        local pos = self:GetPos()

        self:ClearPatrols()

        local plyDist = plyPos:Distance(pos)

        if plyPos:Distance(self.SpawnPosition) > 120 then
            self.IsBlocking = false
        end

        if IsValid(self.HoldEnt) then
            self.HoldEnt:SetPos(self:GetPos() + self:GetForward() * 60)
        end

        if plyDist > 100 then
            if self.SunAnger > 5 then
                self:SetMovement(150, 230)
                
                self.ForceRun = true
                
                self.RunAnimation = 'moonrun'
            else
                self.WalkAnimation = 'walk'

                if not self.SunPanicked and self.SunGreeted and self.SunAnger < 1 then
                    self:StopVoices()

                    self.SunPanicked = true
    
                    self:PlayVoiceLine('SUN_00004')

                    self:DrG_Timer(7, function()
                        if self.SunAnger > 0 or self.Stunned or self.Holding or self.IsBlocking then return end

                        self:PlayVoiceLine('SUN_00004a')
                    end)
                end
            end

                
            self:AddPatrolPos(plyPos + forward * 5)

            return
        else
            if self.IsBlocking then
                if IsValid(self.HoldEnt) then
                    self.HoldEnt = nil
                end

                self.WalkAnimation = 'walkblocking'
            elseif not self.Holding then
                if self.SunAnger > 5 then
                    self:CallInCoroutine(function(self,delay)
                        self:JumpscareEntity(ply)
                    end)
                else
                    self:GrabEntity(ply)
                    
                    if self.SunAnger > 0 then
                        if not self.SunWarned then
                            self:SunAngerResponse()
                        end
                    else
                        if not self.SunGreeted then
                            self.SunGreeted = true

                            self:StopVoiceLine('SUN_00001')
                            
                            self:PlayVoiceLine('SUN_00001a')

                            self:DrG_Timer(8, function()
                                if self.SunPanicked or self.SunAnger > 0 or self.Stunned or not IsValid(self.Target) then return end

                                self:PlayVoiceLine('SUN_00001b')

                                self:DrG_Timer(8, function()
                                    if self.SunPanicked or self.SunAnger > 0 or self.Stunned or not IsValid(self.Target) then return end

                                    self:PlayVoiceLine('SUN_00001c')
                                end)
                            end)
                        end
                    end
                end
            end
        end

        if not self.IsBlocking then return end


        self:FaceInstant(ply)

        ang.x = 0

        local forward = ang:Forward()
        local walkPos = plyPos + forward * 45;
        local dist = pos:DistToSqr(walkPos)
        local nside = (walkPos - plyPos):Dot(self:GetRight())

        self:SetPoseParameter("move_y", nside > 1 and 1 or -1)

        if dist > 3000 then
            local farPos = walkPos + forward * 100;
            local farDist = pos:DistToSqr(farPos)

            if farDist > 3000 then
                self:AddPatrolPos(farPos)
            else
                self.loco:Approach(walkPos, 50)
            end
        elseif dist > 300 then
            self.loco:Approach(walkPos, 50)
        end
    end

    function ENT:GetRadians(ent)
        local ang = -ent:EyeAngles()
        ang:Normalize()
        
        local x = (ang.y + 90)
        local radians = (x * (math.pi / 180.0))

        return radians
    end

    function ENT:OnStunned()
        self:StopVoices()
        
        self:PlayVoiceLine(self.StunVox[math.random(#self.StunVox)], false)

        if self.SunWarned then
            self.SunWarned = false
        end

        self.SunAnger = self.SunAnger + 1

        self.IdleAnimation = 'idlesad'
    end

    function ENT:OnStunExit()
        self.IdleAnimation = 'idle'

        if self.SunAnger > 5 then
            self:PlayVoiceLine(self.AngerVox[math.random(7,9)], false)
        end
    end
    
    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/sun/mech/sfx_sunman_mech_lp.wav')
    end

    function ENT:OnIdle()
    end

    function ENT:OnNewEnemy()
    end

    function ENT:OnLoseEnemy()
    end

    function ENT:OnReachedPatrol()
        if self.Holding then
            self.Holding = false
            self.IsBlocking = true

            self.WalkAnimation = 'walk'
            self.RunAnimation = 'walk'
            self.IdleAnimation = 'idle'

            local ent = self.Target

            if (not IsValid(ent) and IsValid(self.HoldEnt)) or self:IsPossessed() then
                ent = self.HoldEnt  

                self.HoldEnt = nil
            end

            if not IsValid(ent) then return end
            
            ent:SetPos(self:GetPos() + self:GetForward() * 60)
                    
            self:ExitCinematic(ent)

            local angle = (self:GetPos() - ent:GetPos()):Angle()

            if ent:IsPlayer() then
                ent:SetEyeAngles(Angle(0, angle.y, 0))
            else
                ent:SetAngles(Angle(0, angle.y, 0))
            end

            self.CurrentRadians = self:GetRadians(ent)
        end
    end

    -- Sounds --

    function ENT:StepSFX()
        self:EmitSound('whynotboi/securitybreach/base/sun/footsteps/fly_sunMan_walk_0' .. math.random(6) .. '.wav')
    end
else
end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 6)