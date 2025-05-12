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

include('binds.lua')
include('voice.lua')

if SERVER then
    ENT.AnimEventSounds = {
        ['servo_l'] = {
            hasEnding = true,
            path = 'whynotboi/securitybreach/base/montgomerygator/servo/large/sfx_monty_servo_large_',
            count = 4,
            volume = 0.45,
            channel = CHAN_STATIC
        }
    }
    -- Basic --

    function ENT:CustomInitialize()
        self:SetMovement(60, 240)
        self:SetMovementRates(1, 1, 1)

        self:SetSightRange(1000 * GetConVar('fnaf_sb_new_multiplier_sightrange'):GetFloat())

        self.HW2Jumpscare = GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()
        self.GradualDamaging = GetConVar('fnaf_sb_new_damaging'):GetBool()
        self.DynamicListening = GetConVar('fnaf_sb_new_sounddetect'):GetBool()
        self.PreAnim = GetConVar('fnaf_sb_new_traileranims'):GetBool()

        self.GrowlEnabled = GetConVar('fnaf_sb_new_monty_growls'):GetBool()
        self.CanPounce = GetConVar('fnaf_sb_new_monty_pounceattack'):GetBool()
        self.CanJump = GetConVar('fnaf_sb_new_monty_jumpattack'):GetBool() and navmesh.IsLoaded()
        self.CanBeStunned = GetConVar('fnaf_sb_new_monty_enablestun'):GetBool()
        
        self:SetBodygroup(2, GetConVar('fnaf_sb_new_monty_transglass'):GetInt())
        self:SetBodygroup(3, GetConVar('fnaf_sb_new_betaeyes'):GetInt())

        if self.PreAnim then
            self.IdleAnimation = 'preidle'
            self.WalkAnimation = 'prewalk'
            self.RunAnimation = 'prerun'
        end

    end

    function ENT:BreakDoor(d)        
        self:SetMovement(0, 0, 0, true)

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
                
                self:SetMovement(60, 230, 250)
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
        if self.GrowlEnabled then
            self:GrowlThink()
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

    function ENT:OnSpotEnemy()
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