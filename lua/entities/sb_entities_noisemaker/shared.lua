AddCSLuaFile()
ENT.Type = 'anim'

ENT.PrintName = 'Noise Maker'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/noisemaker/noisemaker.mdl'

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.AutomaticFrameAdvance = true

ENT.Toppled = false
ENT.IsPartofStack = false

ENT.UseSounds = {
    "whynotboi/securitybreach/base/props/noisemaker/daycare/topple/sfx_dynObj_noisemaker_topple_01.wav", 
    "whynotboi/securitybreach/base/props/noisemaker/daycare/topple/sfx_dynObj_noisemaker_topple_02.wav", 
    "whynotboi/securitybreach/base/props/noisemaker/daycare/topple/sfx_dynObj_noisemaker_topple_03.wav"
}

ENT.AllSounds = {}

function ENT:Initialize()
    self:SetModel( self.Model )
    self:SetSkin( math.random(0, 4) )

    if SERVER then
        for i = 1, 2 do
            if not self.IsPartofStack then
                self:SpawnStack(i)
            end
        end

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetMoveType(MOVETYPE_NONE)
    end
end

function ENT:HandleAnimEvent(a,b,c,d,e)

end

function ENT:SpawnStack(id)
    if self.IsPartofStack then return end

    local stackentry = ents.Create('sb_entities_noisemaker')

    stackentry:SetParent(self)

    offsetnum = 5 / id
    offset = Vector(0, 0, 19.5) * id + Vector( math.random(-offsetnum, offsetnum), math.random(-offsetnum, offsetnum), 0 )
    stackentry:SetPos(self:GetPos() + offset)
    stackentry:SetAngles( Angle( 0, math.random(0, 359), 0 ) )

    stackentry.Toppled = false
    stackentry.IsPartofStack = true
    stackentry.StackID = id

    stackentry:Spawn()

    constraint.NoCollide(self, stackentry, 0, 0, true)

    self:DeleteOnRemove(stackentry)

    return stackentry
end

function ENT:Topple()
    if CLIENT or self.Toppled then return end
    if self.IsPartofStack then
        if IsValid(self:GetParent()) then
            local bottomstack = self:GetParent()
            bottomstack:Topple()
        end
    else
        self.Toppled = true
        self:ResetSequence("collapse1")
        self:EmitSound( self.UseSounds[ math.random(1, 3) ] )
        PrintTable(self:GetChildren())
        for i = 1, #self:GetChildren() do
            local stackentry = self:GetChildren()[i]
            stackentry:ResetSequence("collapse"..math.Clamp(i + 1, 1, 3))
            stackentry:SetPos(self:GetPos())
            if i >= 4 then
                stackentry:SetPos(self:GetPos() + Vector(0,0,19.5 * (i - 3)))
            end
        end
    end
end

function ENT:Use(ent)
    print('use')
    self:Topple()
end

function ENT:Touch(ent)
    print('touch')
    self:Topple()
end

function ENT:OnTakeDamage(dmg)
    print('dmg')
    self:Topple()
end

function ENT:OnRemove()
    for i = 1, #self.AllSounds do
        self:StopSound(self.AllSounds[i])
    end
end

function ENT:PhysicsCollide(colData, collider)

end

function ENT:Think()
    self:NextThink(CurTime())
    return true
end