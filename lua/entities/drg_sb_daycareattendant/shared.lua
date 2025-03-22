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
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'walk'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

ENT.UseWalkframes = true

-- Sounds --
ENT.DisableMat = true
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

if SERVER then
    include('binds.lua')

    ENT.AnimEventSounds = {
        ['mvmt_large'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/sun/mech/mvmtlarge/sfx_sunman_mech_mvmt_large_',
            count = 6,
            volume = 0.45,
            channel = CHAN_STATIC
        }
    }

    -- Basic --

    function ENT:SetAttendantType(typeNum)
        self.AttendantType = typeNum

        self:StopSound('whynotboi/securitybreach/base/sun/mech/sfx_sunman_mech_lp.wav')

        if typeNum == 0 then -- Sun
            self:EmitSound('whynotboi/securitybreach/base/sun/mech/sfx_sunman_mech_lp.wav')
            self:SetDefaultRelationship(D_LI)
        else -- Moon
            self:SetDefaultRelationship(D_HT)
        end

        self:CallOnClient('SetAttendantType', typeNum)
    end

    function ENT:JumpscareEntity()
    end

    function ENT:CustomInitialize()
        self:Timer(0, function()
            self.Target = self:GetCreator()

            self.loco:SetAcceleration(3000)
            self.loco:SetDeceleration(0)
        end)

        self.SpawnPosition = self:GetPos()

        self:SetAttendantType(1)
    end

    function ENT:OnReachedPatrol()
	end

    function ENT:SunThink()
        local aiDisabled = self:GetAIDisabled() or self:GetIgnorePlayers()

        if self.Holding then
            if aiDisabled then
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

        if not ply:IsValid() then
            local humans = player.GetHumans()

            ply = humans[math.random(1, #humans)]

            self.Target = ply
        end

        if not ply:IsValid() then return end

        local ang = ply:EyeAngles()

        ang.x = 0

        local forward = ang:Forward()

        local plyPos = ply:GetPos()
        local pos = self:GetPos()

        self:ClearPatrols()

        local plyDist = plyPos:Distance(pos)

        if plyPos:Distance(self.SpawnPosition) > 180 then
            self.IsBlocking = false
        end

        if plyDist > 100 then
            self.WalkAnimation = 'walk'

            self:AddPatrolPos(plyPos + forward * 5)

            return
        else
            if self.IsBlocking then
                self.WalkAnimation = 'walkblocking'
            elseif not self.Holding then
                self:EnterCinematic(ply)
    
                self.Holding = true
                self.WalkAnimation = 'walkcarry'
                self.RunAnimation = 'walkcarry'
                self.IdleAnimation = 'walkcarry'
            end
        end

        if not self.IsBlocking then return end

        self:FaceInstant(Entity(1))

        local radians = self:GetRadians(self.Target)
        local currentRadian = self.CurrentRadians
        
        currentRadian = math.Approach(currentRadian, radians, FrameTime() * 3)

        self.CurrentRadians = currentRadian

        local x = 75 * math.sin(currentRadian)
        local y = 75 * math.cos(currentRadian)
        local z = 0

        local walkPos = self.Target:GetPos() + Vector(x, y)

        local secondPos = (plyPos + forward * 75)
        local dist = pos:DistToSqr(secondPos)
        local nside = (secondPos - plyPos):Dot(self:GetRight())

        self:SetPoseParameter("move_y", nside > 1 and 1 or -1)

        --[[if dist > 3000 then
            local farPos = walkPos + forward * 150
            local farDist = pos:DistToSqr(farPos)

            if farDist > 3000 then -- use nav mesh to mitigate getting stuck
                self:SetCollisionGroup(10)
                self:AddPatrolPos(farPos)
            else
                self:SetCollisionGroup(0)
                self.loco:Approach(walkPos, 1)
            end]]

        if dist > 800 then
            self.loco:Approach(walkPos, 1)
        end
    end

    function ENT:MoonThink()
    end

    function ENT:CustomThink()
        if self.AttendantType == 0 then
            self:SunThink()
        else
            self:MoonThink()
        end
    end

    function ENT:GetRadians(ent)
        local ang = -ent:EyeAngles()
        ang:Normalize()
        
        local x = (ang.y + 90)
        local radians = (x * (math.pi / 180.0))

        return radians
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/sun/mech/sfx_sunman_mech_lp.wav')
    end

    function ENT:OnIdle()
        if self.AttendantType ~= 0 then
            self:AddPatrolPos(self:RandomPos(1500))
        end
    end

    function ENT:OnNewEnemy()
        if self.OnSpotEnemy then
            self:OnSpotEnemy(ent)
        end
    end

    function ENT:OnMeleeAttack(ply)
    end

    function ENT:OnReachedPatrol()
        if self.AttendantType == 0 then
            if self.Holding then
                self.Holding = false
                self.IsBlocking = true

                self.Target:SetPos(self:GetPos() + self:GetForward() * 80)

                self:ExitCinematic(self.Target)

                local angle = (self:GetPos() - self.Target:GetPos()):Angle()

                self.Target:SetEyeAngles(Angle(0, angle.y, 0))
                self.CurrentRadians = self:GetRadians(self.Target)

                self.WalkAnimation = 'walk'
                self.RunAnimation = 'walk'
                self.IdleAnimation = 'idle'
            end
        else
            self:Wait(math.random(3, 7))
        end
    end

    -- Sounds --

    function ENT:StepSFX()
        self:EmitSound('whynotboi/securitybreach/base/sun/footsteps/fly_sunMan_walk_0' .. math.random(6) .. '.wav')
    end
else
    function ENT:SetAttendantType(typeNum)
        self.AttendantType = typeNum

        if typeNum == 0 then -- Sun
            self.Tension = 0
        else -- Moon
            self.Tension = 3
        end
    end

    ENT.Tension = 0
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)