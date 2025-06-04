AddCSLuaFile()
ENT.Type = 'anim'

ENT.PrintName = 'Monty\'s Mystery Mix'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/montymysterymix/montymysterymix.mdl'

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Initialize()
    self:SetModel(self.Model)

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

function ENT:Use(ent)
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
end

function ENT:PhysicsCollide(colData, collider)
end

local canlure = {
    drg_sb_glamrockchica = true,
    drg_sb_shatteredchica = true
}

local function CanLure(ent)
    return canlure[ent:GetClass()] == true
end

function ENT:LureCheck()
    if self.LureTick or self.BeingDevoured then return end

    self.LureTick = true

    for k,v in pairs(ents.FindInSphere(self:WorldSpaceCenter(), 600)) do
        if (v == self) or not (v:IsNPC() or v:IsNextBot()) or (v:IsNPC() or v:IsNextBot() and GetConVar('ai_disabled'):GetBool()) or v:Health() < 1 then continue end
        if v:GetClass() == 'drg_sb_glamrockchica' and (not v:IsPossessed() and not GetConVar('fnaf_sb_new_chica_canlure'):GetBool()) or (v:IsPossessed() and not GetConVar('fnaf_sb_new_chica_playereat'):GetBool()) then continue end
        if v:GetClass() == 'drg_sb_shatteredchica' and (not v:IsPossessed() and not GetConVar('fnaf_sb_new_shatteredchica_canlure'):GetBool()) or (v:IsPossessed() and not GetConVar('fnaf_sb_new_shatteredchica_playereat'):GetBool()) then continue end

        if CanLure(v) and not v.Luring and not v.Stunned then
            v:LuredTo(self)

            self.BeingDevoured = true
            break
        end
    end

    self:DrG_Timer(1, function()
        self.LureTick = false
    end)
end

function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
        
        self:LureCheck()
		return true
	end
end