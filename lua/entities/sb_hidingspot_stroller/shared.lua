AddCSLuaFile()

ENT.Base = 'sb_hidingspot_core'

ENT.PrintName = 'Stroller'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/stroller/stroller.mdl'
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.CanEnterBack = false
ENT.CanEnterLeft = false
ENT.CanEnterRight = false

ENT.FrontAdd = 55

ENT.SpotID = 'stroller'

function ENT:CoInitialize()
    if SERVER then
        self:SetSkin(math.random(0, 3))
    end
end