AddCSLuaFile()
ENT.Type = 'anim'
ENT.Category = 'Security Breach'
ENT.AutomaticFrameAdvance = true
ENT.SBHidingSpot = true

function ENT:Initialize()
    self:SetModel(self.Model)

    self.SFXPath = 'whynotboi/securitybreach/base/props/'

    if self.CoInitialize then
        self:CoInitialize()
    end
    
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(6)
        self:SetSolid(SOLID_VPHYSICS)

        local phys = self:GetPhysicsObject()

        if (phys:IsValid()) then
            phys:Wake()
            phys:EnableDrag(false)
            phys:SetDamping(5, 3)
        end
    end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
    if e == 'open' then
        local path1 = self.SFXPath
        local path2 = self.SpotID

        if path2 ~= nil then
            self:EmitSound(path1 .. path2 .. '/open/botOpen_0' .. math.random(3) .. '.wav')
        end
    end
    
    if e == 'close' then
        local path1 = self.SFXPath
        local path2 = self.SpotID

        if path2 ~= nil then
            self:EmitSound(path1 .. path2 .. '/close/botClose_0' .. math.random(3) .. '.wav')
        end
    end
end

function ENT:Use(ent)
    if self.SpotDisabled or self.SpotDelay then return end

    if IsValid(self.Occupant) and ent == self.Occupant then
        self:ExitSpot(ent)
    else
        self:EnterSpot(ent)
    end
end

function ENT:EnterSpot(ent)
    self.SpotDelay = true

    self.Occupant = ent

    self.Occupant:SetNWEntity('HidingSpotSB', self)

    local path1 = self.SFXPath
    local path2 = self.SpotID

    self:EnterCinematic(ent)

    self:ResetSequence('enterfront')

    if path2 ~= nil then
        self:EmitSound(path1 .. path2 .. '/enter/enter_0' .. math.random(3) .. '.wav')
    end

    timer.Simple(1.3, function()
        if not IsValid(self) or not IsValid(ent) then return end

        ent:SetNoDraw(true)

        --self:EnterHiding(ent)
    end)

    timer.Simple(1.5, function()
        if not IsValid(self) then return end

        self.SpotDelay = false
    end)
end

function ENT:ExitSpot(ent)
    self.SpotDelay = true

    self.Occupant:SetNWEntity('HidingSpotSB', nil)

    self.Occupant = nil

    local path1 = self.SFXPath
    local path2 = self.SpotID

    self:ResetSequence('exitfront')

    if path2 ~= nil then
        self:EmitSound(path1 .. path2 .. '/exit/exit_0' .. math.random(3) .. '.wav')
    end

    timer.Simple(1.3, function()
        if not IsValid(self) or not IsValid(ent) then return end

        ent:SetNoDraw(false)

        self:ExitCinematic(ent)
    end)

    timer.Simple(1.5, function()
        if not IsValid(self) then return end

        self.SpotDelay = false
    end)
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
    if IsValid(self.Occupant) then
        self:ExitCinematic(self.Occupant)

        self.Occupant:SetNWEntity('HidingSpotSB', nil)
    end
end

function ENT:PhysicsCollide(colData, collider)
end

function ENT:EnterCinematic(ent)
    ent:Freeze(false)
    ent:AddFlags(FL_NOTARGET)
    ent:DrawViewModel(false)
    ent:SetActiveWeapon(nil)

    net.Start('SECURITYBREACHFINALLYCINEMATIC')
    net.WriteEntity(self)
    net.WriteBool(true)
    net.Send(ent)

    self.CinTarget = ent
end

function ENT:EnterHiding(ent)
    net.Start('SECURITYBREACHFINALLYCINEMATIC')
    net.WriteEntity(self)
    net.WriteBool(false)
    net.Send(ent)

    self.CinTarget = nil

    net.Start('SECURITYBREACHFINALLYHIDING')
    net.WriteEntity(self)
    net.WriteBool(true)
    net.Send(ent)
end

function ENT:ExitCinematic(ent)
    net.Start('SECURITYBREACHFINALLYCINEMATIC')
    net.WriteEntity(self)
    net.WriteBool(false)
    net.Send(ent)

    ent:RemoveFlags(FL_NOTARGET)
    ent:Freeze(false)
    ent:DrawViewModel(true)

    self.CinTarget = nil
end

function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
        
		return true
	end
end
