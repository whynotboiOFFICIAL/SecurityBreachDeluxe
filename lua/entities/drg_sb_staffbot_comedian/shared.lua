if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drg_sb_staffbot' -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = 'S.T.A.F.F. Bot (Comedian)'
ENT.Category = 'Security Breach'
ENT.Models = {'models/whynotboi/securitybreach/base/animatronics/staffbot/comedian/comedianbot.mdl'}

-- Speed --
ENT.WalkSpeed = 0
ENT.RunSpeed = 0

-- Possession --
ENT.PossessionEnabled = false
ENT.PossessionPrompt = false

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

    local delays = {
        [1] = 3,
        [2] = 3,
        [3] = 2,
        [4] = 4,
        [5] = 4,
        [6] = 4,
        [7] = 2,
        [8] = 2,
        [9] = 4,
        [10] = 3,
        [11] = 3,
        [12] = 3,
        [13] = 3,
        [14] = 0.6,
        [15] = 3,
        [16] = 3,
        [17] = 2,
        [18] = 3,
        [19] = 5,
    }
    -- Basic --

    function ENT:CustomInitialize()
        local g = math.random(2)

        self.Gender = 'm'

        if g == 2 then
            self.Gender = 'f'
        end
    end

    function ENT:BeginSequence()
        self.CurrentLine = 1

        local gender = self.Gender

        for i = 1, #voices do
            self:CallInCoroutine(function(self,delay)
                self:PlayVoiceLine(voices[self.CurrentLine], gender)
            end)
        end
    end

    function ENT:PlayVoiceLine(vo, g)
        local path = self.SFXPath

        if path == nil then return end

        local snd = path .. '/vo/comedy/' .. vo .. '_' .. g ..'.wav'

        self:EmitSound(snd)

        local dur = SoundDuration(snd)
        local seq = self:LookupSequence(vo)
        
        self:RemoveAllGestures()
        self:AddGestureSequence(seq, false)

        self:Wait(dur)
        self:Wait(delays[self.CurrentLine])
        self.CurrentLine = self.CurrentLine + 1
    end

    function ENT:StopVoiceLine(vo, g)
        local path = self.SFXPath

        if path == nil then return end

        self:StopSound(path .. '/vo/comedy/' .. vo .. '_' .. g ..'.wav')
    end

    function ENT:StopVoices()
        local gender = self.Gender
        
        for i = 1, #voices do
            self:StopVoiceLine(voices[i], gender)
        end
    end

    function ENT:CustomAnimEvents(e)
    end

    function ENT:AddCustomThink()
    end

    function ENT:OnIdle()
        if math.random(1, 100) > 60 then
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
FNaF_AddNextBot(ENT, 'Security Breach', 20)