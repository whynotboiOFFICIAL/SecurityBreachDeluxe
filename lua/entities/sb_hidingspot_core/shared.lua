AddCSLuaFile()
ENT.Type = 'anim'
ENT.Category = 'Security Breach'
ENT.AutomaticFrameAdvance = true
ENT.SBHidingSpot = true
ENT.CanEnterLeft = true
ENT.CanEnterRight = true
ENT.CanEnterBack = true

function ENT:Initialize()
    self:SetModel(self.Model)

    self.SFXPath = 'whynotboi/securitybreach/base/props/'

    if self.CoInitialize then
        self:CoInitialize()
    end
    
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)

        local phys = self:GetPhysicsObject()

        if (phys:IsValid()) then
            phys:Wake()
            phys:EnableDrag(false)
            phys:SetDamping(0, 0)
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
    if IsValid(self.Occupant) and ent ~= self.Occupant then return end

    if IsValid(self.Occupant) and ent == self.Occupant then
        self:ExitSpot(ent)
    else
        self:EnterSpot(ent)
    end
end

function ENT:EnterSpot(ent)
    local side = self:GetSide(ent)

    if not side then return end

    self.SpotDelay = true

    self.Occupant = ent

    self.Occupant:SetNWEntity('HidingSpotSB', self)

    local path1 = self.SFXPath
    local path2 = self.SpotID

    self:EnterCinematic(ent)

    self:ResetSequence('enter' .. (side))

    self:ForceLose(ent)

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
    local side = self:GetSide(ent)

    if not side then return end

    self.SpotDelay = true

    self.Occupant:SetNWEntity('HidingSpotSB', nil)

    self.Occupant = nil

    local path1 = self.SFXPath
    local path2 = self.SpotID

    self:ResetSequence('exit' .. (side))

    if path2 ~= nil then
        self:EmitSound(path1 .. path2 .. '/exit/exit_0' .. math.random(3) .. '.wav')
    end

    timer.Simple(1.3, function()
        if not IsValid(self) or not IsValid(ent) then return end

        print(ent:EyeAngles())

        ent:SetNoDraw(false)

        self:ExitCinematic(ent)
        
        local exitpos =  self:GetExitPos(side)
        local pos = (self:GetPos() + exitpos)
        local ang = (pos - self:GetPos()):Angle()

        ent:SetPos(pos)
        ent:SetEyeAngles(Angle(0, ang.y, 0))
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

function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
        
		return true
	end
end

function ENT:GetSide(ent)
    if not IsValid(ent) then return end

    local pos = self:GetPos()

    local entpos = ent:GetPos()

    local fside = (pos - entpos):Dot(self:GetForward())
    local rside = (pos - entpos):Dot(self:GetRight())

    --print('front', fside, 'side', rside)

    if fside < -25 then
        return 'front'
    elseif fside > 25 and self.CanEnterBack then
        return 'back'
    elseif rside < -25 and self.CanEnterLeft then
        return 'left'
    elseif rside > 25 and self.CanEnterRight then
        return 'right'
    end
end

function ENT:GetExitPos(side)
    local fadd = self.FrontAdd or 0
    local badd = self.BackAdd or 0
    local ladd = self.LeftAdd or 0
    local radd = self.RightAdd or 0

    if side == 'front' then
        return (self:GetForward() * fadd)
    elseif side == 'back' then
        return (self:GetForward() * -badd) 
    elseif side == 'left' then
        return (self:GetRight() * ladd)        
    elseif side == 'right' then
        return (self:GetRight() * -radd) 
    end
end

function ENT:EnterCinematic(ent)
    ent:Freeze(true)
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

function ENT:ForceLose(ent)
    for k, v in ipairs( ents.GetAll() ) do
        if v.IsDrGNextbot then
            v:LoseEntity(ent)

            v:SetEntityRelationship(ent, D_LI)

            self:DrG_Timer(1, function()
                if not IsValid(v) then return end
                
                v:SetEntityRelationship(ent, D_HT)
            end)
        end
    end
end

