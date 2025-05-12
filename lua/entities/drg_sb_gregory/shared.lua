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
ENT.SpawnHealth = 80

-- Animations --
ENT.WalkAnimation = 'walk'
ENT.WalkAnimRate = 2
ENT.RunAnimation = 'run'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'fall'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.SFXPath = 'whynotboi/securitybreach/base/gregory'

-- Relationships --
ENT.Factions = {'FACTION_HUMAN', 'FACTION_PLAYER'}
ENT.Frightening = false
ENT.DefaultRelationship = D_FR
ENT.AvoidAfraidOfRange = 20000
ENT.WatchAfraidOfRange = 20000

-- Possession --
ENT.PossessionMovement = POSSESSION_MOVE_8DIR

include('binds.lua')
include('voice.lua')

if SERVER then
    include('footsteps.lua')

    -- Basic --

    function ENT:CustomInitialize()
        self:SetMovement(110, 220)
        self:SetMovementRates(1, 2, 1)

        self.InfiniteStamina = GetConVar('fnaf_sb_new_gregory_infinitestamina'):GetBool()

        self:SetPlayersRelationship(D_LI)

        if GetConVar('fnaf_sb_new_freddy_friendly'):GetBool() then
            self:SetClassRelationship('drg_sb_glamrockfreddy', D_LI)
        end

        self:SetClassRelationship('drg_sb_staffbot_security', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_sewer', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_map', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_mop', D_LI)
        self:SetClassRelationship('drg_sb_staffbot_comedian', D_LI)

        self:SetNWFloat('Stamina', 200)
    end

    function ENT:AddCustomThink()
        self:SetNWBool('DisableRun', self.DisableRun)

        if self.GlamrockFreddy then
            if not IsValid(self.GlamrockFreddy) then
                self.GlamrockFreddy = nil
            end
        end
        
        if self.InfiniteStamina then return end

        if self:IsRunning() then
            local stamina = self:GetNWFloat('Stamina')

            if stamina <= 0 then
                self.DisableRun = true
            end
            
            self:SetNWFloat('Stamina', math.Clamp(stamina - 0.4, 0, 200))

            self:SetCooldown('staminacharge', 1)
        elseif self:GetCooldown('staminacharge') <= 0 then
            local stamina = self:GetNWFloat('Stamina')

            if stamina < 200 then
                self:SetNWFloat('Stamina', math.Clamp(stamina + 1, 0, 200))
            else
                self.DisableRun = false
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

    function ENT:RestoreMovement()
        if self.Crouched then
            self:SetMovement(30, 60)
            self:SetMovementRates(1, 1, 1, 1)       
        else
            self:SetMovement(110, 220)
            self:SetMovementRates(1, 2, 1, 1)       
        end
    end

    function ENT:FlashlightToggle()
        if self.LightOn then
            self:EmitSound('whynotboi/securitybreach/base/props/flashlight/sfx_general_flashlight_off_03.wav', 75, 100, 0.5)

            self.Light:Fire('TurnOff')
            
            self.LightOn = false
        else
            self:EmitSound('whynotboi/securitybreach/base/props/flashlight/Gregory_Flashlight_On.wav')

            self.Light:Fire('TurnOn')

            self.LightOn = true
        end
    end

    function ENT:DeEquipFlashlight()
        self:SetNWBool('HasFlashlight', false)

        self:EmitSound('whynotboi/securitybreach/base/gregory/putaway/sfx_gregory_inventory_item_equip_putAway_0' .. math.random(6) .. '.wav')

        local state = ''

        if self.Crouched then
            state = 'crouch'
        end

        local idle = state .. 'idle'
        local walk = state .. 'walk'
        local run = state .. 'run'

        self:SetMovementAnims(idle, walk, run, 'fall')

        SafeRemoveEntity(self.FlashLight)

        SafeRemoveEntity(self.Light)
        
        self.CurrentItem = 0

        self.LightOn = false
    end

    function ENT:EquipFlashlight()
        self:SetNWBool('HasFlashlight', true)

        self:EmitSound('whynotboi/securitybreach/base/gregory/takeout/sfx_gregory_inventory_item_equip_takeOut_0' .. math.random(6) .. '.wav')

        local state = ''

        if self.Crouched then
            state = 'crouch'
        end

        local idle = 'fl' .. state .. 'idle'
        local walk = 'fl' .. state .. 'walk'
        local run = 'fl' .. state .. 'run'

        self:SetMovementAnims(idle, walk, run, 'flfall')
        
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
FNaF_AddNextBot(ENT, 'Security Breach', 1)