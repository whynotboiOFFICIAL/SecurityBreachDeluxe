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

        self:SetMovement(80, 230)
        self:SetMovementRates(1, 1, 1)

        if not self.DisableFreezeOnSight then     
            self.WalkSpeed = 0
            self.RunSpeed = 0
        end
        
        local appearance = GetConVar('fnaf_sb_new_endo_appearance'):GetInt()

        if appearance == 4 then
            appearance = math.random(3)
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
        [2] = 'models/whynotboi/securitybreach/base/animatronics/endo/frostendo.mdl',
        [3] = 'models/whynotboi/securitybreach/base/animatronics/endo/cakeendo.mdl',  
    }

    function ENT:SetAppearance(a)
        if a == 1 then return end

        self:SetModel(models[a])

        self:SetCollisionBounds(Vector(-10, -10, 0), Vector(10, 10, 75))

        self.Appearance = a
    end

    function ENT:SleepMode()
        local animt = self.Type

        if animt > 2 then
            animt = math.random(2)
        end

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
     
            if self.Appearance == 3 then
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

        self.Cycle = math.Rand(0, 1)

        if self.Appearance == 3 then
            self.IdleAnimation = 'endocrawl'
            self.WalkAnimation = 'endocrawl'
            self.RunAnimation = 'endocrawl'
        else
            self.IdleAnimation = 'endowalk' .. self.Type
            self.WalkAnimation = 'endowalk' .. self.Type
            self.RunAnimation = 'endowalk' .. self.Type
        end

        self:SetMovement(0, 0, 0, true)
 
        self.ForceCycle = true
    end

    function ENT:UnFrozen()
        if not self.IsFrozen then return end

        self.IsFrozen = false
        self.ForceCycle = false

        self.IdleAnimation = 'idle' .. self.Type

        if self.Appearance == 3 then
            self.WalkAnimation = 'crawl'
            self.RunAnimation = 'crawl'
            
            self:SetMovement(200, 200, 250)
        else
            self.WalkAnimation = 'walk' .. self.Type
            self.RunAnimation = 'run' .. self.Type
            
            self:SetMovement(80, 240, 250)
        end
        
        self:SetMovementRates(1, 1, 1)

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