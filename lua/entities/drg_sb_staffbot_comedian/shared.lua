if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Comedian)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/comedian/comedianbot.mdl'}

-- Speed --
ENT.WalkSpeed = 0
ENT.RunSpeed = 0

include('binds.lua')

if SERVER then

    local voices = {
        'COMEDYBOT_00001',
        'COMEDYBOT_00002',
        'COMEDYBOT_00003',
        'COMEDYBOT_00004',
        'COMEDYBOT_00005',
        'COMEDYBOT_00006',
        'COMEDYBOT_00007',
        'COMEDYBOT_00008',
        'COMEDYBOT_00009',
        'COMEDYBOT_00010',
        'COMEDYBOT_00011',
        'COMEDYBOT_00012',
        'COMEDYBOT_00013',
        'COMEDYBOT_00014',
        'COMEDYBOT_00015',
        'COMEDYBOT_00016',
        'COMEDYBOT_00017',
        'COMEDYBOT_00018',
        'COMEDYBOT_00019'
    }

    -- Basic --

    function ENT:CustomInitialize()
        self.Gender = math.random(2)
    end

    function ENT:BeginSequence()
        self.CurrentLine = 1

        local gender = 'm'

        if self.Gender == 2 then
            gender = 'f'
        end

        for i = 1, #voices do
            self:PlayVoiceLine(voices[self.CurrentLine], gender)
            self.CurrentLine = self.CurrentLine + 1
        end
    end

    function ENT:PlayVoiceLine(vo, g)
        local path = self.SFXPath

        if path == nil then return end

        self:EmitSound(path .. '/vo/comedy/' .. vo .. '_' .. g ..'.wav')

        self:PlaySequenceAndMove(vo)
    end

    function ENT:StopVoiceLine(vo, g)
        local path = self.SFXPath

        if path == nil then return end

        self:StopSound(path .. '/vo/comedy/' .. vo .. '_' .. g ..'.wav')
    end

    function ENT:StopVoices()
        local gender = 'm'

        if self.Gender == 2 then
            gender = 'f'
        end

        for i = 1, #voices do
            self:StopVoiceLine(voices[i], gender)
        end
    end

    function ENT:CustomAnimEvents(e)
    end

    function ENT:AddCustomThink()
    end

    function ENT:OnIdle()
        if math.random(1, 100) > 50 then
            self:BeginSequence()
        end

        self:Wait(math.random(15,25))
    end

    function ENT:OnDeath()
    end

else

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)