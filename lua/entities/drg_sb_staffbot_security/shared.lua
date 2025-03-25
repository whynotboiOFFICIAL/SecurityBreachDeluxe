if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Security)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/security/securitybot.mdl'}

if SERVER then

    -- Basic --

    function ENT:CustomInitialize()
        self.CurrentPath = 1

        self:SpawnHat()
        self:SpawnFlashlight()
        self:SpawnLight()

        self:RandomizePatrolPaths()
    end

    function ENT:CustomAnimEvents(e)
        if e == 'idlecycle' then
            self.IdleAnimation = 'idleaction' .. math.random(1,4)
        end
        if e == 'toidle' then
            self.IdleAnimation = 'idle'
        end
    end

    function ENT:OnDispossessed() 
        self:RandomizePatrolPaths()
    end

    function ENT:SpawnHat()
        local hat = ents.Create('prop_dynamic')
        
        hat:SetModel('models/whynotboi/securitybreach/base/animatronics/staffbot/props/securityhat.mdl')
        hat:SetModelScale(1.4)
        hat:SetParent(self)
        hat:SetSolid(SOLID_NONE)

        hat:Fire('SetParentAttachmentMaintainOffset','Head')
        hat:SetLocalPos(Vector(9, -1.85, 76.5))
        hat:SetLocalAngles(Angle(0, 0, 0))

        hat:Spawn()
    end

    function ENT:SpawnFlashlight()
        local flashlight = ents.Create('prop_dynamic')
        
        flashlight:SetModel('models/whynotboi/securitybreach/base/props/flashlight/flashlight.mdl')
        flashlight:SetModelScale(1)
        flashlight:SetParent(self)
        flashlight:SetSolid(SOLID_NONE)

        flashlight:Fire('SetParentAttachmentMaintainOffset','Prop')
        flashlight:SetLocalPos(Vector(13, -15, 69))
        flashlight:SetLocalAngles(Angle(40, 0, -120))

        flashlight:Spawn()
    end

    function ENT:SpawnLight()
        local light = ents.Create('env_projectedtexture')
        local pos = self:GetAttachment(4).Pos

        if IsValid(light) then
            light:SetKeyValue('brightness', 0)
            light:SetKeyValue('distance', 1)
            light:SetPos(pos)
            light:SetAngles(self:GetAngles())
            light:SetKeyValue('lightcolor', '255 255 255')
            light:SetKeyValue('lightfov', '75')
            light:SetKeyValue('farz', '200')
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

    function ENT:AddCustomThink()
        if self.Stunned or GetConVar('ai_disabled'):GetBool() then return end

        if not self.CatchTick then          
            local size = 140
            local dir = self:GetForward()
            local angle = math.cos( math.rad( 50 ) )
            local startPos = self:WorldSpaceCenter()

            self.CatchTick = true

            for k, v in ipairs( ents.FindInCone( startPos, dir, size, angle ) ) do
                if (v == self or v == self:GetPossessor()) or (v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC')) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool()) or v:Health() < 1 then continue end

                self:CallInCoroutine(function(self,delay)
                    self:JumpscareEntity(v)
                end)

                break
            end

            self:DrG_Timer(0.3, function()
                self.CatchTick = false
            end)
        end
    end

    function ENT:OnReachedPatrol()
    end

    function ENT:OnIdle()
        if self.CurrentPath == 3 then
            self.CurrentPath = 1
            self:PlaySequenceAndMove('turn360')
        else
            self.CurrentPath = self.CurrentPath + 1
        end

        self:ClearPatrols()
        self:AddPatrolPos(self.PatrolPaths[self.CurrentPath])
    end

    function ENT:JumpscareEntity(entity)
        if not IsValid(entity) or entity:Health() < 0.1 then return end

        self.Stunned = true

        entity:SetPos(self:GetPos() + self:GetForward() * 35)
    
        self.CurrentVictim = entity
        entity:AddFlags(FL_NOTARGET)
    
        if entity:IsPlayer() then
            entity:Freeze(true)
            entity:AddFlags(FL_NOTARGET)
            entity:DrawViewModel(false)
            entity:SetActiveWeapon(nil)
    
            net.Start('SECURITYBREACHFINALLYJUMPSCARE')
            net.WriteEntity(self)
            net.WriteBool(true)
            net.Send(entity)
        else
            if entity:IsNPC() or entity:IsNextBot() then
                entity:NextThink(CurTime() + 1e9) 
            end
        end
    
        self:Jumpscare()
    
        if !IsValid(self.CurrentVictim) then return end
        
        self.CurrentVictim = nil
    
        entity:RemoveFlags(FL_NOTARGET)
    
        if entity:IsPlayer() then
            entity:Freeze(false)
            net.Start('SECURITYBREACHFINALLYJUMPSCARE')
            net.WriteEntity(self)
            net.WriteBool(false)
            net.Send(entity)
        else
            if entity:IsNPC() or entity:IsNextBot() then
                entity:NextThink(CurTime()) 
            end
        end

        self:AlertAnimatronics(entity)

        self:Wait(5)

        self.Stunned = false
    end

    function ENT:AlertAnimatronics(ent)
        if not IsValid(ent) then return end
        
        self:EmitSound('whynotboi/securitybreach/base/staffbot/alert/sfx_staffBot_security_alert_0' .. math.random(3) .. '.wav')

        for k, v in ipairs( ents.GetAll() ) do
            if v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC') and v.CanBeSummoned then
                v:SpotEntity(ent)
            end
        end
    end
    
    function ENT:OnDeath()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)