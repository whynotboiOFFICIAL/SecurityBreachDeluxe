AddCSLuaFile()

ENT.Base = 'sb_hidingspot_core'

ENT.PrintName = 'Beverage Cart'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/cart/cart.mdl'
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.SpotID = 'cart'

function ENT:CoInitialize()
    if SERVER then
        self:SetSkin(math.random(0, 4))
    end
end
