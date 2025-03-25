if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot_security' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Sewer)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/sewer/sewerbot.mdl'}

if SERVER then
    function ENT:AlertAnimatronics()
        self:EmitSound('whynotboi/securitybreach/base/staffbot/alert/sfx_staffBot_security_alert_0' .. math.random(3) .. '.wav')
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)