if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Vanessa'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/humans/vanessa/vanessa.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(8, 8, 68)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.CanBeStunned = true
ENT.CustomStunSFX = true

-- Stats --
ENT.SpawnHealth = 100

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
ENT.SFXPath = 'whynotboi/securitybreach/base/vanessa'

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
    include('footsteps.lua')

    -- Basic --

    function ENT:CustomInitialize()
        self:SpawnLight()
    end

    function ENT:SpawnLight()
        local light = ents.Create('env_projectedtexture')
        local pos = self:GetAttachment(2).Pos

        if IsValid(light) then
            light:SetKeyValue('brightness', 1)
            light:SetKeyValue('distance', 1)
            light:SetPos(pos)
            light:SetAngles(self:GetAngles())
            light:SetKeyValue('lightcolor', '255 255 255')
            light:SetKeyValue('lightfov', '75')
            light:SetKeyValue('farz', '300')
            light:SetKeyValue('nearz', '5')
            light:SetKeyValue('shadowquality', '1')

            light:Input('SpotlightTexture', NULL, NULL, 'effects/flashlight001')
    
            light:SetParent(self)
            light:Spawn()
            light:Fire('SetParentAttachment', 'light')
            light:Fire('LightOn')

            self:DeleteOnRemove(light)
    
            self.Flashlight = light
        end
    end

    function ENT:OnRangeAttack(enemy)
        if self.RangeTick or self.Stunned or not enemy:IsPlayer() then return end
        
        self.RangeTick = true

        if math.random(1,100) > 60 then
            if self:IsBeingLookedAt() then
                self.LockEntity = enemy

                self:PlaySequenceAndMove('stun')

                self.LockEntity = nil
            end
        end

        self:DrG_Timer(3, function()
            self.RangeTick = false
        end)
    end

    function ENT:CustomAnimEvents(e)
        if e == 'idlecycle' then
            self.IdleAnimation = 'idlescan' .. math.random(1,2)
        end
        if e == 'toidle' then
            self.IdleAnimation = 'idle'
        end
        if e == 'walkcycle' then
            if math.random(1,10) > 9 then
                self.WalkAnimation = 'walkscan'
            end
        end
        if e == 'towalk' then
            self.WalkAnimation = 'walk'
        end
        if e == 'toidle' then
            self.IdleAnimation = 'idle'
        end
        if e == 'flash' then
            if self:IsBeingLookedAt() and IsValid(self.LockEntity) then
                self.LockEntity:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 255 ), 3, 0 )
            end
        end
    end

    function ENT:AddCustomThink()
        if IsValid(self.LockEntity) then
            self:FaceInstant(self.LockEntity)
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    function ENT:StepSFX()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)