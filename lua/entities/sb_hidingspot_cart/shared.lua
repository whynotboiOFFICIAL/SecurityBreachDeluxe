AddCSLuaFile()

ENT.Base = 'sb_hidingspot_core'

ENT.PrintName = 'Beverage Cart'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/cart/cart.mdl'
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.CanEnterLeft = false
ENT.CanEnterRight = false

ENT.FrontAdd = 45
ENT.BackAdd = 45

ENT.SpotID = 'cart'

function ENT:CoInitialize()
    if SERVER then
        self:SetSkin(math.random(0, 4))
    end
end
