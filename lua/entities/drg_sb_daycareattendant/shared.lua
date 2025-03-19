if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Daycare Attendant'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/daycareattendant/sun.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED

-- Stats --
ENT.SpawnHealth = 1000

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 124.90
ENT.RunAnimation = 'walk'
ENT.RunAnimRate = 124.90
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

ENT.UseWalkframes = true

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/bot/jumpscare/sfx_jumpScare_scream.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/daycareattendant'

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

include('binds.lua')

if SERVER then
    -- Basic --

    function ENT:JumpscareEntity()
    end

    function ENT:CustomInitialize()
        self:Timer(0, function()
            self.Target = self:GetCreator()

            self.loco:SetAcceleration(3000)
            self.loco:SetDeceleration(0)
        end)

        self.SpawnPosition = self:GetPos()
    end

    function ENT:OnReachedPatrol()
	end

    function ENT:CustomThink()
        if self.Holding then
            self.SpawnPosition.z = self:GetPos().z

            self:ClearPatrols()
            self:AddPatrolPos(self.SpawnPosition)

            return
        end

        local ply = self.Target
        if not ply then return end

        if not ply:IsValid() then
            local humans = player.GetHumans()

            ply = humans[math.random(1, #humans)]

            self.Target = ply
        end

        if not ply:IsValid() then return end

        local plyPos = ply:GetPos()
        local pos = self:GetPos()

        self:ClearPatrols()

        if plyPos:Distance(pos) > 80 then
            self.WalkAnimation = 'walk'
            self.IsBlocking = false

            self:AddPatrolPos(plyPos)
            self:SetDefaultRelationship(D_HT)

            return
        else
            self:SetDefaultRelationship(D_LI)

            self.WalkAnimation = 'walkblocking'
            self.IsBlocking = true
        end

        self:FaceInstant(Entity(1))

        local ang = ply:EyeAngles()

        ang.x = 0

        local forward = ang:Forward()
        local walkPos = plyPos + forward * 45;
        local dist = pos:DistToSqr(walkPos)
        local nside = (walkPos - plyPos):Dot(self:GetRight())

        self:SetPoseParameter("move_y", nside > 1 and 1 or -1)

        if dist > 3000 then
            local farPos = walkPos + forward * 150;
            local farDist = pos:DistToSqr(farPos)

            if farDist > 3000 then
                self:AddPatrolPos(farPos)
            else
                self.loco:Approach(walkPos, 1)
            end
        elseif dist > 300 then
            self.loco:Approach(walkPos, 1)
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    function ENT:OnIdle()
    end

    function ENT:OnNewEnemy()
    end

    function ENT:OnMeleeAttack(ply)
        if not self.IsBlocking and ply == self.Target then
            self:EnterCinematic(self.Target)

            self.Holding = true
            self.WalkAnimation = 'walkcarry'
            self.RunAnimation = 'walkcarry'
            self.IdleAnimation = 'walkcarry'
        end
    end

    function ENT:OnReachedPatrol()
        if self.Holding then
            self.Holding = false
            self.Target:SetPos(self:GetPos() + self:GetForward() * 40)

            self:ExitCinematic(self.Target)

            local angle = (self:GetPos() - self.Target:GetPos()):Angle()
            self.Target:SetEyeAngles(Angle(0, angle.y, 0))

            self.WalkAnimation = 'walk'
            self.RunAnimation = 'walk'
            self.IdleAnimation = 'idle'
        end
    end

    -- Sounds --
else
    ENT.Tension = 0
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)