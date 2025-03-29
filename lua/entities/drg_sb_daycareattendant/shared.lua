if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Daycare Attendant'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/daycareattendant/daycareattendant.mdl'}
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
            path = 'whynotboi/securitybreach/base/moon/mech/headspin/sfx_moonman_mech_head_spin_',
            count = 5,
            volume = 1,
            channel = CHAN_STATIC
        }
    }

    -- Basic --

    function ENT:SetAttendantType(typeNum)
        self.AttendantType = typeNum

        self:StopSound('whynotboi/securitybreach/base/sun/mech/sfx_sunman_mech_lp.wav')
        self:StopSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_detail_lp.wav')
        self:StopSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_general_lp.wav')

        if typeNum == 0 then -- Sun
            self:EmitSound('whynotboi/securitybreach/base/sun/mech/sfx_sunman_mech_lp.wav', 75, 100, 0.45)
            self:SetDefaultRelationship(D_LI)
            self:SetSkin(0)
            self:SetBodygroup(1, 0)
        else -- Moon
            self:EmitSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_detail_lp.wav', 75, 100, 0.45)
            self:EmitSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_general_lp.wav', 75, 100, 0.45)
            self:SetDefaultRelationship(D_HT)
            self:SetSkin(1)
            self:SetBodygroup(1, 1)

            self.SFXPath = 'whynotboi/securitybreach/base/moon'
            
            self.IdleAnimation = 'moonidle1'
            self.WalkAnimation = 'moonwalk'
            self.RunAnimation = 'moonwalk'
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

            local tbl = self.NPCTable
            local enableSwitching = tbl.SwitchingEnabled

            self:SetAttendantType(tbl.AttendantType or 0)

            self.EnableSwitching = enableSwitching ~= nil and true or enableSwitching
        end)

        self.SpawnPosition = self:GetPos()
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

    function ENT:StartHook()
        local hookpos = self:HookTrace()

        if hookpos then
            self.JumpAnimation = 'moonswimloop'

            self.Swimming = true

            local oldhookpos = Vector(hookpos)

            hookpos.z = hookpos.z - (hookpos.z - self:GetPos().z) / 2

            self:SetPos(hookpos)

            self.loco:SetVelocity(vector_origin)
            self.loco:SetGravity(0)
            
            constraint.Elastic(
                self, 
                game.GetWorld(), 
                0, 0, 
                self:WorldToLocal(self:GetBonePosition(3)), 
                oldhookpos, 
                59, 59, 0, 
                nil, 2
            )
        end
    end

    function ENT:CustomThink()
        if self.AttendantType == 0 then
            self:SunThink()
        else
            self:MoonThink()
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
        self:StopSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_detail_lp.wav')
        self:StopSound('whynotboi/securitybreach/base/moon/mech/sfx_moonman_mech_general_lp.wav')
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
        if self.AttendantType == 1 then
            self:EmitSound('whynotboi/securitybreach/base/moon/footsteps/walk/fly_moonMan_walk_0' .. math.random(8) .. '.wav')
            self:EmitSound('whynotboi/securitybreach/base/moon/footsteps/bells/sfx_moonman_step_bells_0' .. math.random(8) .. '.wav')
        else
            self:EmitSound('whynotboi/securitybreach/base/sun/footsteps/fly_sunMan_walk_0' .. math.random(6) .. '.wav')
        end
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

local sunClass = {
    Name = 'Sun',
    Class = 'drg_sb_daycareattendant',
    Category = ENT.Category,
    AttendantType = 0,
    SwitchingEnabled = false
}

local moonClass = {
    Name = 'Moon',
    Class = 'drg_sb_daycareattendant',
    Category = ENT.Category,
    AttendantType = 1,
    SwitchingEnabled = false
}

list.Set('NPC', 'drg_sb_sun', sunClass)
list.Set('NPC', 'drg_sb_moon', moonClass)
list.Set('DrGBaseNextbots', 'drg_sb_sun', sunClass)
list.Set('DrGBaseNextbots', 'drg_sb_moon', moonClass)

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)