AddCSLuaFile()
ENT.Type = 'anim'

ENT.PrintName = 'Recharge Station'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/rechargestation/rechargestation.mdl'

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Initialize()
    self:SetModel(self.Model)

    if SERVER then
        self:SpawnDoor()

        self:EmitSound('whynotboi/securitybreach/base/props/rechargestation/idle/sfx_rechargeStation_idle_lp.wav')

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

function ENT:SpawnDoor()
    local door = ents.Create('prop_dynamic')

    door:SetModel('models/whynotboi/securitybreach/base/props/rechargestation/door.mdl')
    door:SetModelScale(1)
    door:SetParent(self)
    door:PhysicsInit(SOLID_VPHYSICS)

    door:Fire('SetParentAttachment','Door')

    door:Spawn()

    constraint.NoCollide(door, self, 0, 0, true)

    self:DeleteOnRemove(door)
end

function ENT:HandleAnimEvent(a,b,c,d,e)
    if e == 'open' then
    end
    
    if e == 'close' then
    end
end

function ENT:Use(ent)
    if ent:GetClass() ~= 'drg_sb_glamrockfreddy' then return end
    
    ent:EnterRecharge(self)
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
    self:StopSound('whynotboi/securitybreach/base/props/rechargestation/idle/sfx_rechargeStation_idle_lp.wav')
    self:StopSound('whynotboi/securitybreach/base/props/rechargestation/idle/sfx_rechargeStation_active_progress.wav')
    self:StopSound('whynotboi/securitybreach/base/props/rechargestation/idle/sfx_rechargeStation_active_static.wav')
end

function ENT:PhysicsCollide(colData, collider)
end

function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
        

		return true
	end
end