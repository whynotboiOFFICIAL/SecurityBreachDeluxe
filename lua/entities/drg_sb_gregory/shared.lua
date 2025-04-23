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

        if GetConVar('fnaf_sb_new_freddy_friendly'):GetBool() then
            self:SetClassRelationship('drg_sb_glamrockfreddy', D_LI)
        end

        self:SetClassRelationship('drg_sb_staffbot_security', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_sewer', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_map', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_mop', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_comedian', D_LI)
    end

    function ENT:AddCustomThink()
        if self.GlamrockFreddy then
            if not IsValid(self.GlamrockFreddy) then
                self.GlamrockFreddy = nil
            end
        end
    end

    function ENT:SpawnFlashlight()
        local flashlight = ents.Create('prop_dynamic')
        
        flashlight:SetModel('models/whynotboi/securitybreach/base/props/flashlight/flashlight.mdl')
        flashlight:SetModelScale(0.8)
        flashlight:SetParent(self)
        flashlight:SetSolid(SOLID_NONE)

        flashlight:Fire('SetParentAttachment','FlashLight')

        flashlight:Spawn()

        self:DeleteOnRemove(flashlight)
        
        self.FlashLight = flashlight
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
            light:Fire('TurnOff')

            self:DeleteOnRemove(light)
    
            self.Light = light
        end
    end

    function ENT:FlashlightToggle()
        self:EmitSound('whynotboi/securitybreach/base/props/flashlight/Gregory_Flashlight_On.wav')

        if self.LightOn then
            self.Light:Fire('TurnOff')

            self.LightOn = false
        else
            self.Light:Fire('TurnOn')

            self.LightOn = true
        end
    end

    function ENT:DeEquipFlashlight()
        self:EmitSound('whynotboi/securitybreach/base/gregory/putaway/sfx_gregory_inventory_item_equip_putAway_0' .. math.random(6) .. '.wav')

        local state = ''

        if self.Crouched then
            state = 'crouch'
        end

        self.IdleAnimation = state .. 'idle'
        self.WalkAnimation = state .. 'walk'
        self.RunAnimation = state .. 'run'

        self.JumpAnimation = 'fall'

        self.FlashLight:Remove()
        self.Light:Remove()
        
        self.CurrentItem = 0

        self.LightOn = false
    end

    function ENT:EquipFlashlight()
        self:EmitSound('whynotboi/securitybreach/base/gregory/takeout/sfx_gregory_inventory_item_equip_takeOut_0' .. math.random(6) .. '.wav')

        local state = ''

        if self.Crouched then
            state = 'crouch'
        end

        self.IdleAnimation = 'fl' .. state .. 'idle'
        self.WalkAnimation = 'fl' .. state .. 'walk'
        self.RunAnimation = 'fl' .. state .. 'run'

        self.JumpAnimation = 'flfall'

        self:SpawnFlashlight()
        self:SpawnLight()
        
        self.CurrentItem = 1
    end

    function ENT:OnAvoidAfraidOf()
        self:DoorCode() 
    end

    function ENT:OnMeleeAttack()
    end

    function ENT:OnNewEnemy()
    end

    function ENT:OnLastEnemy()
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