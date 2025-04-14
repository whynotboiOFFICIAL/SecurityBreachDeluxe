if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Gregory'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/humans/gregory/gregory.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(3, 3, 40)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.DoPossessorJumpscare = true

-- Stats --
ENT.SpawnHealth = 100

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'run'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'fall'
ENT.JumpAnimRate = 1

-- Speed --
ENT.UseWalkframes = false
ENT.WalkSpeed = 41.25
ENT.RunSpeed = 210

-- Sounds --
ENT.SFXPath = 'whynotboi/securitybreach/base/gregory'

-- Relationships --
ENT.Factions = {'FACTION_HUMAN', 'FACTION_PLAYER'}
ENT.Frightening = false
ENT.DefaultRelationship = D_FR
ENT.AvoidAfraidOfRange = 20000
ENT.WatchAfraidOfRange = 19999

-- Detection --
ENT.EyeBone = 'Head_jnt'
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

-- Possession --
ENT.PossessionMovement = POSSESSION_MOVE_8DIR

include('binds.lua')
include('voice.lua')

if SERVER then
    include('footsteps.lua')

    -- Basic --

    function ENT:CustomInitialize()
        self:SetPlayersRelationship(D_LI)
        self:SetClassRelationship('drg_sb_glamrockfreddy', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_security', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_sewer', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_map', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_mop', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_comedian', D_LI)
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

    function ENT:OnMeleeAttack()
    end

    function ENT:CustomAnimEvents(e)
    end

    function ENT:AddCustomThink()
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