if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'Glamrock Freddy'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/glamrockfreddy/glamrockfreddy.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 85)
ENT.BloodColor = DONT_BLEED
ENT.CanBeStunned = true

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

-- Relationships --
ENT.DefaultRelationship = D_LI

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/glamrockfreddy/jumpscare/sfx_jumpscare_pas_freddy.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/glamrockfreddy'

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
    include('chest.lua')

    -- Basic --

    function ENT:CustomInitialize()
        self:SetNWInt('Energy', 100)
    end

    function ENT:AddCustomThink()
        if not self.PowerTick then
            local currentpower = self:GetNWInt('Energy')

            self.PowerTick = true

            self:SetNWInt('Energy', currentpower - 1)

            if self:GetNWInt('Energy') < 1 and (self.Inhabited and self:GetPossessor() == self.Partner or self:GetPossessor() == self.BackupEnt) then
                local loldie = self.Partner

                self:Dispossess(loldie)
                
                self:CallInCoroutine(function(self,delay)
                    self:JumpscareEntity(loldie)
                end)
            end

            local ticktimer = 2
            
            if self.Inhabited then 
                ticktimer = 1
            end

            self:DrG_Timer(ticktimer, function()
                self.PowerTick = false
            end)
        end

        if self:GetNWInt('Energy') < 1 and not self.IsSick then
            self:SickMode()
        end

        if IsValid(self.HoldEntity) then
            self.HoldEntity:SetPos(self:GetPos() + self:GetForward() * 10)
        end

        if self.Inhabited then return end
        
        if IsValid(self.Partner) and not self:IsPossessed() then
            local partner = self.Partner
            local pos = partner:GetPos()
            local dist = pos:DistToSqr(self:GetPos())/ 1000

            if dist > 15000 then
                partner.GlamrockFreddy = nil

                partner:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/alerts/sfx_freddy_alert_connectionError.wav')
                
                self.Partner = nil
            end
            
            if  dist < 50 and not (GetConVar('ai_disabled'):GetBool() or GetConVar('ai_ignoreplayers'):GetBool()) and partner:Health() > 0 then
                if self.AimTarget ~= partner then
                    self.AimTarget = partner

                    if math.random(1,100) > 60 and not self.WaveDelay and not self.Summoning then
                        self:CallInCoroutine(function(self,delay)
                            self.WaveDelay = true

                            self:PlaySequenceAndMove('wave2')

                            self:DrG_Timer(20, function()
                                self.WaveDelay = false
                            end)
                        end)
                    end

                    self:DialogueTrigger(2, partner)
                end
            else
                if self.AimTarget ~= nil then
                    self.AimTarget = nil
                end
            end

            if not self.IsSick then
                if dist < 20 and not (GetConVar('ai_disabled'):GetBool() or GetConVar('ai_ignoreplayers'):GetBool()) and partner:Health() > 0 then
                    if not self.OpenChest then
                        self:OpenChestHatch()
                    end
                else
                    if self.OpenChest then
                        self:CloseChestHatch()
                    end
                end
            end

            self:AimControl()
        end
    end

    function ENT:DialogueTrigger(inst, ent)
        if ent:GetClass() ~= 'drg_sb_gregory' then return end

        if inst == 1 then
            self:PlayVoiceLine('FREDDY_00094', true)
            
            self.MetWhenSick = true
        elseif inst == 2 then
            if self.IsSick and not self.MetWhenSick then
                self.MetWhenSick = true

                self:PlayVoiceLine('FREDDY_00094', true)
            end
        end
    end

    function ENT:SickMode()
        self.Inhabited = false
        self.Moving = false
        --self.Partner = nil
        self.IsSick = true
        
        self.PossessionMovement = POSSESSION_MOVE_CUSTOM

        self.IdleAnimation = 'idlesick'
        self.WalkAnimation = 'walksick'
        self.RunAnimation = 'runsick'
        
        if self.OpenChest then
            self:CloseChestHatch()
        end

        if not IsValid(self.Partner) then return end

        local partner = self.Partner
        local pos = partner:GetPos()
        local dist = pos:DistToSqr(self:GetPos())/ 1000

        if dist < 50 then
            self:DialogueTrigger(1, partner)
        end
    end

    function ENT:SummonFreddy(ent)
        if self.IsSick then 
            ent:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/call/sfx_freddy_call_unsuccesful.wav')
        return end

        local partner = self.Partner
        local pos = partner:GetPos()
        local dist = pos:DistToSqr(self:GetPos())/ 1000

        if dist < 90 then return end

        ent:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/call/sfx_freddy_call_succesful.wav')

        local pos = ent:DrG_RandomPos(50, 100)

        self.WalkAnimation = 'run'

        self.Summoning = true

        self:ClearPatrols()

        self:AddPatrolPos(pos)
    end

    function ENT:Use(ent)
        if (GetConVar('ai_disabled'):GetBool() or GetConVar('ai_ignoreplayers'):GetBool()) or self.IsSick then return end

        if (ent == self.Partner) or (self:IsPossessed() and not IsValid(self.Partner)) then
            self:EnterFreddy(ent)
        else
            if IsValid(self.Partner) then return end
            
            self.Partner = ent
            ent.GlamrockFreddy = self
            self:ClearPatrols()
        end
    end

    function ENT:OnReachedPatrol()
        if self.Summoning then
            self.Summoning = false
            
            self.WalkAnimation = 'walk'
        end

        if IsValid(self.Partner) then return end

        self:Wait(math.random(3, 7))
    end

    function ENT:OnIdle()
        if IsValid(self.Partner) then return end

        self:AddPatrolPos(self:RandomPos(1500))
    end
    
    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        if self.Partner then
            self.Partner.GlamrockFreddy = nil
        end

        if IsValid(self.PlayerInside) then
            local ply = self.PlayerInside

            self:DeinitSecondary(ply)
        end

        if IsValid(self.CinTarget) then
            self:ExitCinematic(self.CinTarget)
        end
    end

    -- Sounds --

    function ENT:StepSFX()
        local shake = 0.75

        if self:IsRunning() then
            self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/footsteps/run/fly_freddy_run_st_'.. math.random(1,11) .. '.wav')

            shake = 0.8
        else
            self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/footsteps/walk/fly_freddy_walk_st_'.. math.random(1,23) .. '.wav')
        end

        util.ScreenShake( self:GetPos(), shake, 1, 1, 500 )
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)