if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Security)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/security/securitybot.mdl'}
ENT.CanBeStunned = true

include('binds.lua')
if SERVER then

    local voices = {
        'sentrybot_00011',
        'sentrybot_00012',
        'sentrybot_00013',
        'sentrybot_00014',
        'sentrybot_00015',
        'sentrybot_00016',
        'sentrybot_00017'
    }

    -- Basic --

    function ENT:CustomInitialize()
        self.CurrentPath = 1

        self:SpawnHat()
        self:SpawnFlashlight()
        self:SpawnLight()

        self:RandomizePatrolPaths()
        
        local g = math.random(2)

        self.Gender = 'm'

        if g == 2 then
            self.Gender = 'f'
        end
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

    function ENT:PlayVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender

        local snd = path .. '/vo/sentry/' .. vo .. '_' .. g ..'.wav'

        self:EmitSound(snd)
    end

    function ENT:StopVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender
        
        self:StopSound(path .. '/vo/sentry/' .. vo .. '_' .. g ..'.wav')
    end

    function ENT:StopVoices()
        local gender = self.Gender
        
        for i = 1, #voices do
            self:StopVoiceLine(voices[i], gender)
        end
    end

    function ENT:SpawnHat()
        local hat = ents.Create('prop_dynamic')
        
        hat:SetModel('models/whynotboi/securitybreach/base/animatronics/staffbot/props/securityhat.mdl')
        hat:SetModelScale(1)
        hat:SetParent(self)
        hat:SetSolid(SOLID_NONE)

        hat:Fire('SetParentAttachment','Head')

        hat:Spawn()

        self:DeleteOnRemove(hat)
    end

    function ENT:SpawnFlashlight()
        local flashlight = ents.Create('prop_dynamic')
        
        flashlight:SetModel('models/whynotboi/securitybreach/base/props/flashlight/flashlight.mdl')
        flashlight:SetModelScale(1)
        flashlight:SetParent(self)
        flashlight:SetSolid(SOLID_NONE)

        flashlight:Fire('SetParentAttachment','Prop')

        flashlight:Spawn()

        self:DeleteOnRemove(flashlight)
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
        if self.Stunned or self:GetAIDisabled() or self:IsPossessed() then return end

        if not self.CatchTick then          
            local size = 140
            local dir = self:GetForward()
            local angle = math.cos( math.rad( 50 ) )
            local startPos = self:WorldSpaceCenter()

            self.CatchTick = true

            for k, v in ipairs( ents.FindInCone( startPos, dir, size, angle ) ) do
                if self:EntityInaccessible(v) then continue end

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
    
        if entity.DoPossessorJumpscare then
            entity:SetNoDraw(true)

            entity:SetNWBool('CustomPossessorJumpscare', true)
            entity:SetNWEntity('PossessionJumpscareEntity', self)
        end

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
    
        if entity.DoPossessorJumpscare then
            entity:SetNoDraw(false)

            entity:SetNWBool('CustomPossessorJumpscare', false)
            entity:SetNWEntity('PossessionJumpscareEntity', nil)
        end

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

        self:DrG_Timer(0.5, function()
            self:PlayVoiceLine(voices[math.random(#voices)])
        end)

        local tosummon = {}
        
        for k, v in pairs( ents.GetAll() ) do
            if v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC') and v.CanBeSummoned then
                if v.Stunned then continue end
                
                table.insert(tosummon, v)
            end
        end

        local tospawn = tosummon[math.random(#tosummon)]
        
        if not IsValid(tospawn) then return end

        tospawn:SpotEntity(ent)

        tospawn:SetPos(self:RandomPos(300))
    end
    
    function ENT:Removed()
        self:StopSound('whynotboi/securitybreach/base/staffbot/jumpscare/sfx_jumpScare_sewer.wav')
        self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_01.wav')
        self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_02.wav')
        self:StopSound('whynotboi/securitybreach/base/staffbot/wheels/sfx_staffBot_wheels_lp_03.wav')
    end

    function ENT:OnDeath()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
FNaF_AddNextBot(ENT, 'Security Breach', 14)