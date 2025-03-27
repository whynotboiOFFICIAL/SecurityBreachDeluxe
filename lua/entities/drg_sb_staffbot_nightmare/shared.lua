if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot_security' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Nightmare)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/nightmare/nightmarebot.mdl'}

if SERVER then
    function ENT:CustomInitialize()
        self.CurrentPath = 1

        self:SpawnHat()
        self:SpawnFlashlight()
        self:SpawnLight()

        self:RandomizePatrolPaths()

        self:SetSkin(math.random(0, 1))
                
        local g = math.random(2)

        self.Gender = 'm'

        if g == 2 then
            self.Gender = 'f'
        end
    end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)