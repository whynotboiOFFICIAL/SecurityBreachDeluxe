if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_core' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'The Blob'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/blob/blob.mdl'}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(100, 100, 200)
ENT.BloodColor = DONT_BLEED

-- Stats --
ENT.SpawnHealth = 2000

-- Animations --
ENT.WalkAnimation = 'idle'
ENT.WalkAnimRate = 1
ENT.RunAnimation = 'idle'
ENT.RunAnimRate = 1
ENT.IdleAnimation = 'idle'
ENT.IdleAnimRate = 1
ENT.JumpAnimation = 'idle'
ENT.JumpAnimRate = 1

-- Speed --
ENT.WalkSpeed = 0
ENT.RunSpeed = 0

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/bot/jumpscare/sfx_jumpScare_scream.wav'
ENT.SFXPath = 'whynotboi/securitybreach/base/blob'

-- Detection --
ENT.EyeBone = 'Head_jnt'
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1
ENT.MaxYawRate = 0

include('binds.lua')

if SERVER then

    -- Basic --

    function ENT:CustomInitialize()
        self:SetAIDisabled(true)

        self.DisableControls = true

        self.AvailibleTendrils = 8

        self.OrigPos = self:GetPos()
    end

    function ENT:AddCustomThink()
        if GetConVar('fnaf_sb_new_blob_proxjumpscare'):GetBool() and not self.KillTick then
            self.KillTick = true

            for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 250)) do
                if self:IsPossessed() then continue end
                if self:EntityInaccessible(v) then continue end

                self:FaceInstant(v)
                self:Removed()

                self:CallInCoroutine(function(self,delay)
                    self:JumpscareEntity(v)
                end)
                
                break
            end

            self:DrG_Timer(0.3, function()
                self.KillTick = false
            end)
        end

        if self.AvailibleTendrils < 1 or not GetConVar('fnaf_sb_new_blob_tendrils'):GetBool() then return end

        if not self.TendrilCheckTick then
            self.TendrilCheckTick = true

            local timer = 0.3 

            if IsValid(self.TendrilVictim) then
                if self:EntityInaccessible(self.TendrilVictim) then 
                    self.TendrilVictim = nil 
                else
                    timer = math.random(5, 10)

                    self:SpawnTendril(self.TendrilVictim, math.random(2))
                end
            else
                for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 800)) do
                    if self:IsPossessed() then continue end
                    if self:EntityInaccessible(v) then continue end

                    self.TendrilVictim = v
                              
                    self:DrG_Timer(60, function()
                        self.TendrilVictim = nil
                    end)

                    break
                end
            end

            self:DrG_Timer(timer, function()
                self.TendrilCheckTick = false
            end)
        end
    end

    function ENT:SpawnTendril(ent, amount)
        for i = 1, amount do
            local pos = ent:DrG_RandomPos(300, 400)

            local tendril = ents.Create('sb_entities_blobtentacle')
            
            tendril:SetPos(pos)

            tendril:Spawn()
            
            tendril.Owner = self

            self:DeleteOnRemove(tendril)

            self.AvailibleTendrils = self.AvailibleTendrils - 1
        end
    end

    function ENT:Jumpscare2()
        if self.JumpscareSound then
            self:EmitSound(self.JumpscareSound)
        end
    
        self:RemoveAllGestures()
        
        self:PlaySequenceAndMove('jumpscarefloor')
        
        self:SetPos(self.OrigPos)
        self:SetCollisionGroup(9)
    end

    function ENT:CustomAnimEvents(e) 
        if e == 'breathin' then
            self:EmitSound('whynotboi/securitybreach/base/blob/breath/sfx_tangle_blob_breathIn_0' .. math.random(4) .. '.wav')
        end
        if e == 'breathout' then
            self:EmitSound('whynotboi/securitybreach/base/blob/breath/sfx_tangle_blob_breathOut_0' .. math.random(4) .. '.wav')
        end
    end

    function ENT:OnDeath()
    end
    
    function ENT:Removed()
        for i = 1, 4 do 
            self:StopSound('whynotboi/securitybreach/base/blob/breath/sfx_tangle_blob_breathIn_0' .. i .. '.wav')
        end
        for i = 1, 4 do 
            self:StopSound('whynotboi/securitybreach/base/blob/breath/sfx_tangle_blob_breathOut_0' .. i .. '.wav')
        end
    end

    -- Sounds --

    function ENT:OnNewEnemy()
    end

    function ENT:OnLastEnemy()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 23)