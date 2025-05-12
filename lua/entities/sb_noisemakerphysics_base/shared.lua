AddCSLuaFile()
ENT.Type = 'anim'

ENT.PrintName = 'Base Physics Noise Maker'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/paintcans/paintcans2.mdl'

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.AutomaticFrameAdvance = true

ENT.SBDistraction = true
ENT.Toppled = false
ENT.IsPartofStack = false
ENT.DontSpawnCluster = false
ENT.NoiseMakerChildren = {}

ENT.StackAmount = 2
ENT.StackCreateOffset = 10.75
ENT.StackCreatePOSOffset = 0.33

ENT.UseSounds = {
    "whynotboi/securitybreach/base/props/noisemaker/paintcans/topple/sfx_dynObj_paintCans_topple_01.wav", 
    "whynotboi/securitybreach/base/props/noisemaker/paintcans/topple/sfx_dynObj_paintCans_topple_02.wav", 
    "whynotboi/securitybreach/base/props/noisemaker/paintcans/topple/sfx_dynObj_paintCans_topple_03.wav"
}

ENT.AllSounds = {}

table.Merge(ENT.AllSounds, ENT.UseSounds)

function ENT:Initialize()
    self:SetModel( self.Model )
    self.SBN_NoiseMakerBase = self
    self:SetBodygroup( 0, math.random(0, 3) )

    if SERVER then
        self:PhysicsInit(SOLID_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetUseType(SIMPLE_USE)

        if not self.IsPartofStack then
            self:DropToFloor()
            for i = 1, self.StackAmount do
                self:SpawnStack(i)
            end
        end
    end
end

function ENT:SpawnStack(id)
    if CLIENT or self.IsPartofStack then return end

    local stackentry = ents.Create(self:GetClass())
    
    offsetnum = self.StackCreatePOSOffset
    offset = ( Vector(0, 0, self.StackCreateOffset) * id ) + Vector( math.random(-offsetnum, offsetnum), math.random(-offsetnum, offsetnum), 0 )
    stackentry:SetPos(self:GetPos() + offset)
    stackentry:SetAngles( Angle( 0, math.random(0, 359), 0 ) )

    stackentry.IsPartofStack = true
    stackentry:Spawn()

    stackentry:DrawShadow(false)

    local phys = stackentry:GetPhysicsObject()

    if IsValid(phys) then
        phys:SetVelocity(Vector(0,0,0))
    end

    self:DeleteOnRemove(stackentry)

    stackentry.SBN_NoiseMakerBase = self
    table.insert(self.NoiseMakerChildren, stackentry)

    return stackentry
end

function ENT:ApplyToppleForce()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)

    local calc = ( 25 * math.Rand( 0.80, 1.20 ) )

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        local physcalc = VectorRand(-calc, calc)
        physcalc.z = 125
        phys:SetVelocity( physcalc + phys:GetVelocity() )
        phys:SetAngleVelocity( physcalc + phys:GetAngleVelocity() )
    end

    return rand
end

function ENT:Topple()
    local base = IsValid(self.SBN_NoiseMakerBase) and self.SBN_NoiseMakerBase or nil
    local children = IsValid(base) and base.NoiseMakerChildren or nil

    if CLIENT or base.Toppled then return end

    base.Toppled = true
    base:EmitSound( base.UseSounds[ math.random(1, 3) ] )
    base:ApplyToppleForce()

    for i = 1, #children do
        local stack = children[i]
        stack:PhysWake()
        stack:ApplyToppleForce()
    end

end

function ENT:Use(ent)
    local base = IsValid(self.SBN_NoiseMakerBase) and self.SBN_NoiseMakerBase or nil

    if ent:IsPlayer() and base.Toppled then
        ent:PickupObject(self)
        self:PhysWake()
    end

    self:Topple()
end

local function IsFastEnough(length)
    return length >= 50
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