if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Glamrock Endo'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/endo/glamrockendo.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 75)
ENT.BloodColor = DONT_BLEED
ENT.CanBeStunned = true
ENT.CustomStunSFX = true

-- Stats --
ENT.SpawnHealth = 200

-- Animations --
ENT.WalkAnimation = 'walk1'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'run1'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle1'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle1'
ENT.JumpAnimRate = 1

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/endo/jumpscare/sfx_jumpscare_endo.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/endo'

include('binds.lua')

if SERVER then

    -- Basic --

    function ENT:CustomInitialize()
        self.Type = math.random(3)
       
        self.HW2Jumpscare =  GetConVar('fnaf_sb_new_hw2_jumpscares'):GetBool()
        self.DisableFreezeOnSight = GetConVar('fnaf_sb_new_endo_chase'):GetBool()
        self.HasVisor = GetConVar('fnaf_sb_new_endo_visor'):GetBool()

        if self.HasVisor then
            self.CanBeStunned = false
            
            self:SpawnVisor()
        end

        self:SetMovement(80, 230)
        self:SetMovementRates(1, 1, 1)

        if not self.DisableFreezeOnSight then     
            self.WalkSpeed = 0
            self.RunSpeed = 0
        end
        
        local appearance = GetConVar('fnaf_sb_new_endo_appearance'):GetInt()

        if appearance == 2 and not self.Visor then
            self:SpawnEyelights()
        end

        if appearance == 5 then
            appearance = math.random(4)
        end

        self:SetAppearance(appearance)

        if GetConVar('fnaf_sb_new_endo_sleep'):GetBool() then
            self:SleepMode()
        else
            self:SetMaxYawRate(250)
            self:SetSightRange(15000)
            self:SetSightFOV(150)
        end
    end

    local models = {
        [2] = 'models/whynotboi/securitybreach/base/animatronics/endo/glamrockendohw2.mdl',
        [3] = 'models/whynotboi/securitybreach/base/animatronics/endo/frostendo.mdl',
        [4] = 'models/whynotboi/securitybreach/base/animatronics/endo/cakeendo.mdl',  
    }

    function ENT:SetAppearance(a)
        if a == 1 then return end

        self:SetModel(models[a])

        self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 75))

        self.Appearance = a
    end

    function ENT:SpawnEyelights()
        local pos = self:GetPos()
        local ang = self:GetAngles()

        local beam = ents.Create("env_sprite")

        if IsValid(beam) then

            beam:SetPos(pos)
            beam:SetAngles(ang)
            
            beam:SetKeyValue("model", "sprites/light_glow02_add.vmt")
            beam:SetKeyValue("scale", "0.1")
            beam:SetKeyValue("rendermode", "5")
            beam:SetKeyValue("renderamt", "255")
            beam:SetKeyValue("rendercolor", "255 0 0")

            beam:SetParent(self)
            beam:Fire('SetParentAttachment', 'L_Eyelight')

            beam:Spawn()

            beam:Fire('HideSprite')

            self:DeleteOnRemove(beam)
        end

        local beam2 = ents.Create("env_sprite")
        
        if IsValid(beam2) then

            beam2:SetPos(pos)
            beam2:SetAngles(ang)
            
            beam2:SetKeyValue("model", "sprites/light_glow02_add.vmt")
            beam2:SetKeyValue("scale", "0.1")
            beam2:SetKeyValue("rendermode", "5")
            beam2:SetKeyValue("renderamt", "255")
            beam2:SetKeyValue("rendercolor", "255 0 0")

            beam2:SetParent(self)
            beam2:Fire('SetParentAttachment', 'R_Eyelight')
            beam2:Spawn()

            beam2:Fire('HideSprite')

            self:DeleteOnRemove(beam2)
        end        
        
        self.LLight = beam
        self.RLight = beam2
    end

    function ENT:SpawnVisor()
        local visor = ents.Create('prop_dynamic')
        
        visor:SetPos(self:GetPos())
        visor:SetAngles(self:GetAngles())

        visor:SetModel('models/whynotboi/securitybreach/base/props/visor/visor.mdl')
        visor:SetModelScale(1)
        visor:SetParent(self)
        visor:SetSolid(SOLID_NONE)

        visor:Fire('SetParentAttachment','Visor')

        visor:Spawn()

        self:DeleteOnRemove(visor)
    end

    function ENT:SleepMode()
        local animt = self.Type

        if animt > 2 then
            animt = math.random(2)
        end

        self:SetSightRange(0)
        self:SetSightFOV(0)

        self:SetMovement(0, 0, 0, true)
        
        self.IdleAnimation = 'deactivated' .. animt

        self.Sleeping = true
    end

    function ENT:WakeUp()
        if self.Stunned then return end

        self.CueFreeze = true

        self.Sleeping = false

        local animt = 0

        if self.IdleAnimation == 'deactivated1' then
            animt = 1
        else
            animt = 2
        end

        self:CallInCoroutine(function(self,delay)
            self:EmitSound('whynotboi/securitybreach/base/endo/wake/sfx_endo_wake_0' .. math.random(6) .. '.wav', 75, 100, 0.5)
            self:PlaySequenceAndMove('activate' .. animt)

            self.CueFreeze = false

            self:SetMaxYawRate(250)
            self:SetSightRange(15000)
            self:SetSightFOV(150)

            self.IdleAnimation = 'idle' .. self.Type

            self.DisableControls = false
     
            if self.Appearance == 4 then
                self.WalkAnimation = 'crawl'
                self.RunAnimation = 'crawl'
                   
                self:SetMovement(200, 200, 250)
            else
                self.WalkAnimation = 'walk' .. self.Type
                self.RunAnimation = 'run' .. self.Type
                   
                self:SetMovement(80, 240, 250)
            end
        end)
    end

    function ENT:OnStunned()
        self.IsFrozen = false
        self.ForceCycle = false

        self:SleepMode()
    end

    function ENT:Frozen()
        if self.IsFrozen or self.CueFreeze then return end

        self.IsFrozen = true

        if IsValid(self.LLight) then
            self.LLight:Fire('HideSprite')
        end

        if IsValid(self.RLight) then
            self.RLight:Fire('HideSprite')
        end

        local anim = 'endowalk' .. self.Type

        if self.Appearance == 4 then
            anim = 'endocrawl'
        end
        
        self:SetMovementRates(0, 0, 0, 0)

        self:SetMovement(0, 0, 0, true)
        
        self:SetMovementAnims(anim, anim, anim, anim)
    end

    function ENT:UnFrozen()
        if not self.IsFrozen then return end

        self.IsFrozen = false
        self.ForceCycle = false

        self.IdleAnimation = 'idle' .. self.Type

        if IsValid(self.LLight) then
            self.LLight:Fire('ShowSprite')
        end

        if IsValid(self.RLight) then
            self.RLight:Fire('ShowSprite')
        end

        if self.Appearance == 4 then
            self.WalkAnimation = 'crawl'
            self.RunAnimation = 'crawl'
            
            self:SetMovement(200, 200, 250)
        else 
            self.WalkAnimation = 'walk' .. self.Type
            self.RunAnimation = 'run' .. self.Type
            
            self:SetMovement(80, 240, 250)
        end
        
        self:SetMovementRates(1, 1, 1, 1)

        self.DisableControls = false
    end

    function ENT:AddCustomThink()
        if IsValid(self.CurrentVictim) or self.Stunned or self.DisableFreezeOnSight then return end

        if self.ForceCycle then
            self:SetCycle(self.Cycle)
        end

        local isPossessed = self:IsPossessed()
    
        if self:GetAIDisabled() or isPossessed then return end
        
        local enemy = self:GetEnemy()

        if IsValid(enemy) and enemy:IsPlayer() and enemy:Health() > 0  then
            if not self:IsBeingLookedAt() or not self:Visible(enemy) then
                self:UnFrozen()
            else
                self:Frozen()
            end
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
    end

    -- Sounds --

    function ENT:CustomAnimEvents(e)
        if e == 'handtouch' then
            self:EmitSound('whynotboi/securitybreach/base/endo/footsteps/handtouch/fly_endo_handTouch_0' .. math.random(6) .. '.wav')
        end
    end

    function ENT:OnNewEnemy()
        self:EmitSound('whynotboi/securitybreach/base/endo/mode/sfx_endo_mode_hunt.wav', 75, 100, 0.5)

        if self.Sleeping then
            self:WakeUp()
        end
    end

    function ENT:OnLastEnemy()
        if self.IsFrozen then
            self:UnFrozen()
        end

        if IsValid(self.LLight) then
            self.LLight:Fire('HideSprite')
        end

        if IsValid(self.RLight) then
            self.RLight:Fire('HideSprite')
        end

        if IsValid(self.CurrentVictim) then return end

        self:EmitSound('whynotboi/securitybreach/base/endo/mode/sfx_endo_mode_patrol_0'.. math.random(1,6) .. '.wav', 75, 100, 0.5)
    end

    function ENT:StepSFX()
        if self.IsFrozen then return end

        local shake = 0.6

        if self:IsRunning() then
            shake = 0.7
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
        
        self:EmitSound('whynotboi/securitybreach/base/endo/footsteps/walk/fly_endo_walk_0'.. math.random(1,8) .. '.wav')
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 11)