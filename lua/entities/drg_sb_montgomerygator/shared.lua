if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Montgomery Gator'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/montgomerygator/montgomerygator.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanPounce = true
ENT.CanBeSummoned = true
ENT.HidingSpotSearch = true
ENT.SearchID = 'monty'

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
ENT.SFXPath = 'whynotboi/securitybreach/base/montgomerygator'

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
        ['servo_l'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/montgomerygator/servo/large/sfx_servo_large_',
            count = 4,
            volume = 0.45,
            channel = CHAN_STATIC
        }
    }
    -- Basic --

    function ENT:CustomInitialize()
        if GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool() then
            self.HW2Jumpscare = true
        end
        
        if GetConVar('fnaf_sb_new_damaging'):GetBool() then
            self.GradualDamaging = true
        end

        if GetConVar('fnaf_sb_new_monty_transglass'):GetBool() then
            self:SetBodygroup(2, 1)
        end

        if GetConVar('fnaf_sb_new_betaeyes'):GetBool() then
            self:SetBodygroup(3, 1)
        end

        if GetConVar('fnaf_sb_new_traileranims'):GetBool() then
            self.IdleAnimation = 'preidle'
            self.WalkAnimation = 'prewalk'
            self.RunAnimation = 'prerun'

            self.PreAnim = true
        end

        if not GetConVar('fnaf_sb_new_monty_pounceattack'):GetBool() then
            self.CanPounce = false
        end

        if GetConVar('fnaf_sb_new_monty_jumpattack'):GetBool() and navmesh.IsLoaded() then
            self.CanJump = true
        end

        if GetConVar('fnaf_sb_new_monty_enablestun'):GetBool() then
            self.CanBeStunned = true
        end
    end

    function ENT:BreakDoor(d)
        self.DisableControls = true
        self.UseWalkframes = false
        self.Moving = false

        self:DrG_Timer(0.3, function()
            if not IsValid(d) then return end
            local phys = self:GetPhysicsObject()

            if (phys:IsValid()) then
                self:SpawnDoorProp(d)
            else
                d:Fire('Unlock')

                d:Fire('Open')
            end

            self:DrG_Timer(0.5, function()
                self.DisableControls = false
                self.UseWalkframes = true
            end)
        end)

        self:CallInCoroutine(function(self,delay)
            self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/claws/swing/sfx_montyClaws_swing_0' .. math.random(3) .. '.wav')

            self:DrG_Timer(0.3, function()
                self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/claws/impact/sfx_montyClaws_fence_impact_0' .. math.random(3) .. '.wav')
            end)

            self:PlaySequenceAndMove('fencebreak')
        end)
    end

    function ENT:SpawnDoorProp(ent)
        local pos = ent:GetPos()
        local ang = ent:GetAngles()
        local model = ent:GetModel()
        local mats = ent:GetMaterials()
        local skin = ent:GetSkin()
        ent:Remove()

        local door = ents.Create('prop_physics')
        
        door:SetModel(model)
        door:SetModelScale(1)
        door:SetSkin(skin)
        
        door:SetPos(pos)
        door:SetAngles(ang)
        door:SetSolid(SOLID_NONE)

        for i, matName in ipairs(mats) do
            door:SetSubMaterial(i - 1, matName)
        end

        door:Spawn()

        local aim = self:GetPos() + self:GetForward() * 300 + Vector(0, 0, 50)

        door:DrG_AimAt(aim, 300)	 
    end

    function ENT:AddCustomThink()
        if GetConVar('fnaf_sb_new_monty_growls'):GetBool() then
            self:GrowlThink()
        end
    end

    function ENT:Removed()
    end

    -- Sounds --

    function ENT:CustomAnimEvents(e)
        if e == 'jump' then
            self:EmitSound('whynotboi/securitybreach/base/montgomerygator/leap/fly_monty_leap_0' .. math.random(4) .. '.wav')

            self:PlayVoiceLine(self.PounceJumpVox[math.random(#self.PounceJumpVox)])
        end
        if e == 'land' then
            self:EmitSound('whynotboi/securitybreach/base/montgomerygator/land/fly_monty_land_0' .. math.random(3) .. '.wav')

            self:PlayVoiceLine(self.PounceLandVox[math.random(#self.PounceLandVox)])
        end
    end

    function ENT:StepSFX()
        local shake = 0.8

        if self:IsRunning() then
            self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/run/fly_monty_run_'.. math.random(1,23) .. '.wav')

            shake = 1
        else
            self:EmitSound('whynotboi/securitybreach/base/montgomerygator/footsteps/walk/fly_monty_walk_'.. math.random(1,19) .. '.wav')
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 4)