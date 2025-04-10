AddCSLuaFile()

ENT.Base = 'sb_hidingspot_core'

ENT.PrintName = 'Kiosk'
ENT.Category = 'Security Breach'
ENT.Model = 'models/whynotboi/securitybreach/base/props/kiosk/kiosk.mdl'
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.FrontAdd = 60
ENT.BackAdd = 60
ENT.LeftAdd = 70
ENT.RightAdd = 70

ENT.SpotID = 'kiosk'

function ENT:CoInitialize()
    if SERVER then
        self:SetSkin(math.random(0, 5))
    end
end
