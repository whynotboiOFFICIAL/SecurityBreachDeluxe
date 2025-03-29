if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Map)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/map/mapbot.mdl'}
ENT.WheelsID = 44
ENT.CanBeStunned = true

-- Relationships --
ENT.DefaultRelationship = D_HT

-- Animations --
ENT.WalkAnimation = 'idlestay'
ENT.RunAnimation = 'idlestay'

-- Sounds --
ENT.JumpscareSound = 'whynotboi/securitybreach/base/staffbot/jumpscare/sfx_mapbot_jumpscare.wav'

include('binds.lua')

if SERVER then

    local voices = {
        'MAPBOT_00001',
        'MAPBOT_00001alt',
        'MAPBOT_00002',
        'MAPBOT_00003',
        'MAPBOT_00004'
    }

    -- Basic --

    function ENT:CustomInitialize()
        local g = math.random(2)

        self.Gender = 'm'

        if g == 2 then
            self.Gender = 'f'
        end

        self.Offers = 0
        self.SpawnPos = self:GetPos()
        self.SpawnAng = self:GetAngles()
    end

    function ENT:Use(ent)
        if self.OfferingMap and ent == self.OfferEntity then
            self:StopVoices()

            self:StopOffer(ent)

            self:PlayVoiceLine(voices[5])
        end
    end
    
    function ENT:PlayVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender

        local snd = path .. '/vo/map/' .. vo .. '_' .. g ..'.wav'

        self:EmitSound(snd)
    end

    function ENT:StopVoiceLine(vo)
        local path = self.SFXPath

        if path == nil then return end

        local g = self.Gender
        
        self:StopSound(path .. '/vo/map/' .. vo .. '_' .. g ..'.wav')
    end

    function ENT:StopVoices()
        local gender = self.Gender
        
        for i = 1, #voices do
            self:StopVoiceLine(voices[i], gender)
        end
    end

    function ENT:SpawnMap()
        local map = ents.Create('prop_dynamic')
        
        map:SetModel('models/whynotboi/securitybreach/base/animatronics/staffbot/props/map.mdl')
        map:SetModelScale(1)
        map:SetParent(self)
        map:SetSolid(SOLID_NONE)

        map:Fire('SetParentAttachment','Prop')

        map:Spawn()
        
        self.Map = map
    end

    function ENT:AddCustomThink()
        if not self.OfferingMap then return end

        if not self.VoDelay then
            self.VoDelay = true

            self.Offers = self.Offers + 1
            self:PlayVoiceLine(voices[3])

            self:DrG_Timer(math.random(2,4), function()
                self.VoDelay = false
            end)
        end

        if not IsValid(self.OfferEntity) or self.Offers > 8 then
            self.Offers = 0
            self.OfferingMap = false

            self:StopOffer(self.OfferEntity)

            self.OfferEntity = nil
        end
    end

    function ENT:OnReachedPatrol()
        if self.Returning then
            self.Returning = false
            self:SetAngles(self.SpawnAng)
        end
    end

    function ENT:OnIdle()
    end

    function ENT:OnNewEnemy()
        self:ClearPatrols()
        self.Returning = false
    end

    function ENT:OnMeleeAttack(enemy)
        if self.OfferingMap then return end

        self:JumpscareEntity(enemy)
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

        self:OfferMap(entity)

        self:Wait(5)

        self.Stunned = false
    end

    function ENT:OfferMap(ent)
        if not IsValid(ent) then return end

        self:SpawnMap()
        
        self.OfferEntity = ent

        self.VoDelay = true

        self.IdleAnimation = 'idlestay'

        self.OfferingMap = true
        
        self:AddGestureSequence(4, false)

        self:PlayVoiceLine(voices[math.random(2)])
        
        self:DrG_Timer(3, function()
            self.VoDelay = false
        end)
    end
    
    function ENT:StopOffer(ent)
        if IsValid(ent) then
            self:SetEntityRelationship(ent, D_LI)
        end

        if IsValid(self.Map) then
            self.Map:Remove()
        end

        self:SetDefaultRelationship(D_LI)

        self.OfferingMap = false

        self:RemoveAllGestures()

        self:PlaySequence('giveout')

        self.IdleAnimation = 'idle'
        
        self:CallInCoroutine(function(self,delay)
            self:Wait(1)

            self.Returning = true

            self:AddPatrolPos(self.SpawnPos)
        end)
        
        self:DrG_Timer(6, function()
            self:SetDefaultRelationship(D_HT)
        end)
    end

    function ENT:OnDeath()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)