function ENT:JumpscareEntity(entity, alt)
    if not IsValid(entity) or entity:Health() < 0.1 then return end

    if self.StopVoices then
        self.VoiceDisabled = true
        
        self:DrG_Timer(0.1, function()
            self:StopVoices()
        end)
    end

    entity:SetPos(self:GetPos() + self:GetForward() * 35)
    
    self.ForceCycle = false
    self._InterruptSeq = true
    
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

    if alt and self.Jumpscare2 then
        self:Jumpscare2()
    else
        self:Jumpscare()
    end

    self._InterruptSeq = false

    if !IsValid(self.CurrentVictim) then return end
    
    self.CurrentVictim = nil

    entity:RemoveFlags(FL_NOTARGET)

    if entity:IsPlayer() then
        net.Start('SECURITYBREACHFINALLYJUMPSCARE')
        net.WriteEntity(self)
        net.WriteBool(false)
        net.Send(entity)

        entity:Freeze(false)
        entity:DrawViewModel(true)
        entity:Kill(self)
    else
        if entity:IsNPC() or entity:IsNextBot() then
            entity:NextThink(CurTime()) 
        end

        entity:TakeDamage(1e9, self)
    end

    self.Moving = false
    
    if self.VoiceDisabled then
        self.VoiceDisabled = false
    end
end

function ENT:Jumpscare()
    if self.JumpscareSound then
        self:EmitSound(self.JumpscareSound)
    end

    self:RemoveAllGestures()

    if self.HW2Jumpscare then
        self:PlaySequenceAndMove('jumpscarehw')
    else
        self:PlaySequenceAndMove('jumpscare')
    end
end

function ENT:CancelJumpscare()
    if !IsValid(self.CurrentVictim) then return end
    
    local ent = self.CurrentVictim

    if self.JumpscareSound then
        self:StopSound(self.JumpscareSound)
    end

    ent:RemoveFlags(FL_NOTARGET)

    if ent.DoPossessorJumpscare then
        ent:SetNoDraw(false)

        ent:SetNWBool('CustomPossessorJumpscare', false)
        ent:SetNWEntity('PossessionJumpscareEntity', nil)
    end

    if ent:IsPlayer() then
        net.Start('SECURITYBREACHFINALLYJUMPSCARE')
        net.WriteEntity(self)
        net.WriteBool(false)
        net.Send(ent)

        ent:Freeze(false)
        ent:DrawViewModel(true)
    else
        if ent:IsNPC() or ent:IsNextBot() then
            ent:NextThink(CurTime()) 
        end
    end
end

function ENT:OnMeleeAttack(enemy)
    self:FaceInstant(enemy)
    self:JumpscareEntity(enemy)
end
