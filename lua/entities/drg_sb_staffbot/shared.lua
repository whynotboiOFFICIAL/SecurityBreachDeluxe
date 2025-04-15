if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot'
ENT.Category = 'Security Breach'
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.WheelsID = 28

-- Stats --
ENT.SpawnHealth = 1000

-- Relationships --
ENT.Frightening = false
ENT.DefaultRelationship = D_LI

-- Speed --
ENT.UseWalkframes = false
ENT.WalkSpeed = 150
ENT.RunSpeed = 150

-- Animations --
ENT.WalkAnimation = 'idle'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'idle'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/staffbot/jumpscare/sfx_mapbot_jumpscare_02.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/staffbot'

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

if SERVER then

    ENT.AnimEventSounds = {
        ['servo'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/staffbot/servo/sfx_staffBot_servo_',
            count = 4,
            volume = 0.25,
            channel = CHAN_STATIC
        },
        ['mopswipe'] = {
            hasEnding = false,
            path = 'whynotboi/securitybreach/base/staffbot/mopswipe/sfx_staffBot_mop_swipe_',
            count = 4,
            volume = 0.45,
            channel = CHAN_STATIC
        }
    }

    -- Basic --

    function ENT:_BaseInitialize()
        self.WheelAngle = 0
    end

    function ENT:RandomizePatrolPaths()
        self.PatrolPaths = {}

        local pos = self:GetPos()

        table.insert( self.PatrolPaths, pos )

        pos = self:RandomPos(500, 500)

        table.insert( self.PatrolPaths, pos )

        pos = self:RandomPos(700, 700)

        table.insert( self.PatrolPaths, pos )
    end

    function ENT:DoStunned()
        if self.Stunned or self.StunDelay or self.PounceStarted then return end
        
        self.Moving = false

        if self.StopVoices then 
            self:StopVoices()
        end
        
        self:EmitSound('whynotboi/securitybreach/base/staffbot/vo/NoTampering.wav')

        if self.OnStunned then
            self:OnStunned()
        end

        self.DisableControls = true
        self.VoiceDisabled = true
        self.Stunned = true

        self:SetAIDisabled(true)

        self:DrG_Timer(10, function()
            if self.OnStunExit then
                self:OnStunExit()
            end

            self.DisableControls = false
            self.Stunned = false

            if not self:HasEnemy() then
                self.VoiceDisabled = false
            end

            self:SetAIDisabled(false)

            self.StunDelay = true

            self:DrG_Timer(1, function()
                self.StunDelay = false
            end)
        end)
    end

    function ENT:CustomThink()
        if self.AddCustomThink then
            self:AddCustomThink()
        end

        if self:IsMoving() and self:IsOnGround() then
            if not self.Wheels then
                self:EmitSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_0' .. math.random(3) .. '.wav')

                self.Wheels = true
            end

            self.WheelAngle = self.WheelAngle + 10

            self:ManipulateBoneAngles(self.WheelsID, Angle(0, 0, self.WheelAngle))
        else
            if self.Wheels then
                self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_01.wav')
                self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_02.wav')
                self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_03.wav')

                self.Wheels = false
            end
        end

        local param = self:GetPoseParameter('move') 

        if self:IsMoving() then
            if param < 1 then
                self:SetPoseParameter('move', param + 0.05)
            else
                self:SetPoseParameter('move', 1)
            end
        else
            if param > 0 then
                self:SetPoseParameter('move', param - 0.05)
            else
                self:SetPoseParameter('move', 0)
            end
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/staffbot/vo/NoTampering.wav')
        self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_01.wav')
        self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_02.wav')
        self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_03.wav')
    end

    function ENT:OnNewEnemy()
    end
else

end

-- DO NOT TOUCH --
AddCSLuaFile()