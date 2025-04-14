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

    local instant = self.IsInstant

    if IsValid(self.Occupant) and ent == self.Occupant then
        self:ExitSpot(ent, instant)
    else
        self:EnterSpot(ent, instant)
    end
end

function ENT:EnterSpot(ent, instant)
    local side = self:GetSide(ent)

    if not side then return end

    self.SpotDelay = true

    self.Occupant = ent

    self.OccupantSide = side

    if ent:IsPlayer() then
        self.Occupant:SetNWEntity('HidingSpotSB', self)  
    end

    self.Occupant.IsHiding = true

    local path1 = self.SFXPath
    local path2 = self.SpotID

    self:EnterCinematic(ent)

    self:ForceLose(ent)

    if path2 ~= nil then
        self:EmitSound(path1 .. path2 .. '/enter/enter_0' .. math.random(3) .. '.wav')
    end

    local animtime = 0

    if not instant then      
        self:ResetSequence('enter' .. (side))

        animtime = 1.3
    end

    timer.Simple(animtime, function()
        if not IsValid(self) or not IsValid(ent) then return end

        ent:SetNoDraw(true)

        --self:EnterHiding(ent)
    end)

    timer.Simple((animtime + 0.2), function()
        if not IsValid(self) then return end

        self.SpotDelay = false
    end)
end

function ENT:SearchSpot(char)
    local seq = self:LookupSequence('search' .. char)

    self.SpotDisabled = true

    self:AddLayeredSequence(seq, 1)

    timer.Simple(5, function()
        if not IsValid(self) then return end

        self:RemoveAllGestures()

        self.SpotDisabled = false
    end)
end

function ENT:ExitSpot(ent, instant)
    local side = self.OccupantSide

    if not side then return end

    self.SpotDelay = true

    self.OccupantSide = nil

    self.Occupant.IsHiding = false

    local path1 = self.SFXPath
    local path2 = self.SpotID

    if path2 ~= nil then
        self:EmitSound(path1 .. path2 .. '/exit/exit_0' .. math.random(3) .. '.wav')
    end

    local animtime = 0

    if not instant then      
        self:ResetSequence('exit' .. (side))

        animtime = 1.3
    end

    timer.Simple(animtime, function()
        if not IsValid(self) or not IsValid(ent) then return end

        self.Occupant:SetNWEntity('HidingSpotSB', nil)

        self.Occupant = nil

        ent:SetNoDraw(false)

        self:ExitCinematic(ent)
        
        self:ResetSequence('ref')

        local exitpos =  self:GetExitPos(side)
        local pos = (self:GetPos() + exitpos)
        local ang = (pos - self:GetPos()):Angle()

        ent:SetPos(pos)

        if ent:IsPlayer() then
            ent:SetEyeAngles(Angle(0, ang.y, 0))
        else
            ent:SetAngles(Angle(0, ang.y, 0))
        end
    end)

    timer.Simple((animtime + 0.3), function()
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
        self.Occupant:SetNoDraw(false)
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
    ent:SetCollisionGroup(10)

    net.Start('SECURITYBREACHFINALLYCINEMATIC')
    net.WriteEntity(self)
    net.WriteBool(true)
    net.Send(ent)

    self.CinTarget = ent
end

function ENT:EnterCinematic(ent)
    if ent:IsPlayer() then
        ent:Freeze(true)
        ent:AddFlags(FL_NOTARGET)
        ent:DrawViewModel(false)
        ent:SetActiveWeapon(nil)

        net.Start('SECURITYBREACHFINALLYCINEMATIC')
        net.WriteEntity(self)
        net.WriteBool(true)
        net.Send(ent)
    else
        if ent.DoPossessorJumpscare then
            ent:SetNoDraw(true)
    
            ent:SetNWBool('CustomPossessorCam', true)
            ent:SetNWEntity('PossessionCinematicEntity', self)
        end

        --ent:NextThink(CurTime() + 1e9)
    end

    self.CinTarget = ent
end

function ENT:ExitCinematic(ent)
    if ent:IsPlayer() then
        net.Start('SECURITYBREACHFINALLYCINEMATIC')
        net.WriteEntity(self)
        net.WriteBool(false)
        net.Send(ent)
    
        ent:RemoveFlags(FL_NOTARGET)
        ent:Freeze(false)
        ent:DrawViewModel(true)
    else
        if ent.DoPossessorJumpscare then
            ent:SetNoDraw(false)
    
            ent:SetNWBool('CustomPossessorCam', false)
            ent:SetNWEntity('PossessionCinematicEntity', nil)
        end

        --ent:NextThink(CurTime())
    end

    self.CinTarget = nil
end

function ENT:ForceEject(ent)
    self:ExitCinematic(ent)

    self.Occupant = nil
    
    ent:SetNWEntity('HidingSpotSB', nil)

    ent:SetNoDraw(false)
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

