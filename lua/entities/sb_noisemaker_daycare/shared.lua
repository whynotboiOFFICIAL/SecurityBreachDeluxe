AddCSLuaFile()
ENT.Type = 'anim'

ENT.PrintName = 'Noise Maker'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/noisemaker/noisemaker.mdl'

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.AutomaticFrameAdvance = true

ENT.SBDistraction = true
ENT.Toppled = false
ENT.IsPartofStack = false
ENT.NoiseMakerChildren = {}

ENT.UseSounds = {
    "whynotboi/securitybreach/base/props/noisemaker/daycare/topple/sfx_dynObj_noisemaker_topple_01.wav", 
    "whynotboi/securitybreach/base/props/noisemaker/daycare/topple/sfx_dynObj_noisemaker_topple_02.wav", 
    "whynotboi/securitybreach/base/props/noisemaker/daycare/topple/sfx_dynObj_noisemaker_topple_03.wav"
}

ENT.AllSounds = {}

table.Merge(ENT.AllSounds, ENT.UseSounds)

function ENT:Initialize()
    self:SetModel( self.Model )
    self:SetSkin( math.random(0, 4) )
    self.SBN_NoiseMakerBase = self

    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)

        local phys = self:GetPhysicsObject()

        if IsValid(phys) then
            phys:SetDamping(0, 0)
        end

        if not self.IsPartofStack then
            self:DropToFloor()
            for i = 1, 2 do
                self:SpawnStack(i)
            end
        end
    end
end


function ENT:SpawnStack(id)
    if CLIENT or self.IsPartofStack then return end

    local stackentry = ents.Create('sb_noisemaker_daycare')
    stackentry:SetModel('models/whynotboi/securitybreach/base/props/noisemaker/noisemaker.mdl')

    offsetnum = 3 / math.Clamp(id, 1, 3)
    offset = ( Vector(0, 0, 19.9) * id ) + Vector( math.random(-offsetnum, offsetnum), math.random(-offsetnum, offsetnum), 0 )
    stackentry:SetPos(self:GetPos() + offset)
    stackentry:SetAngles( Angle( 0, math.random(0, 359), 0 ) )

    stackentry.IsPartofStack = true
    stackentry:Spawn()
    stackentry:DrawShadow(false)

    constraint.NoCollide(self, stackentry, 0, 0, true)

    self:DeleteOnRemove(stackentry)

    stackentry.SBN_NoiseMakerBase = self
    table.insert(self.NoiseMakerChildren, stackentry)

    return stackentry
end

function ENT:Topple()
    local base = IsValid(self.SBN_NoiseMakerBase) and self.SBN_NoiseMakerBase or nil
    local children = IsValid(base) and base.NoiseMakerChildren or nil
    if CLIENT or base.Toppled then return end
    base.Toppled = true
    base:ResetSequence("collapse1")
    base:SetSolid(SOLID_NONE)
    base:EmitSound( base.UseSounds[ math.random(1, 3) ] )
    for i = 1, #children do
        local stack = children[i]
        if i + 1 >= 4 then 
            stack:SetMoveType(MOVETYPE_VPHYSICS) 
            stack:SetSolid(SOLID_VPHYSICS)
            stack:PhysWake()
        else
            stack:ResetSequence("collapse"..i + 1)
            stack:SetPos(base:GetPos())
            stack:SetSolid(SOLID_NONE)
        end
    end
end

function ENT:Use(ent)
    local base = IsValid(self.SBN_NoiseMakerBase) and self.SBN_NoiseMakerBase or nil
    if ent:IsPlayer() and base.Toppled then
        ent:PickupObject(self)
        self:SetMoveType(MOVETYPE_VPHYSICS) 
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysWake()
        self:SetSequence("ref")
    end
    self:Topple()
end

local function IsFastEnough(length)
    return length >= 100
end

function ENT:Touch(ent)
    if IsFastEnough(ent:GetVelocity():Length()) then
        self:Topple()
    end
end

function ENT:OnTakeDamage(dmg)
    local base = self.SBN_NoiseMakerBase
    local children = base.NoiseMakerChildren
    timer.Simple(0, function()
        if IsValid(base) and IsTableOfEntitiesValid(children) then
            self:Topple()
        end
    end)
    self:TakePhysicsDamage(dmg)
end

function ENT:OnRemove()
    for i = 1, #self.AllSounds do
        self:StopSound(self.AllSounds[i])
    end
end

function ENT:Think()
    self:NextThink(CurTime())
    return true
end