ENT.SearchingVox = {
    'MONTY_00002_01',
    'MONTY_00002_02',
    'MONTY_00002_03'
}

ENT.StunVox = {
    'MONTY_00025_01',
    'MONTY_00025_02',
    'MONTY_00025_03'
}

ENT.PounceJumpVox = {
    'MONTY_00024_01',
    'MONTY_00024_02',
    'MONTY_00024_03',
    'MONTY_00024_04',
    'MONTY_00024_05',
    'MONTY_00024_06',
    'MONTY_00024_07',
    'MONTY_00024_08',
    'MONTY_00024_09',
    'MONTY_00024_10',
    'MONTY_00024_11',
    'MONTY_00024_12',
    'MONTY_00024_13'
}

ENT.PounceLandVox = {
    'MONTY_00026_01',
    'MONTY_00026_02',
    'MONTY_00026_03',
    'MONTY_00026_04',
    'MONTY_00026_05',
    'MONTY_00026_06',
    'MONTY_00026_07',
    'MONTY_00026_08',
    'MONTY_00026_09',
    'MONTY_00026_10',
    'MONTY_00026_11',
    'MONTY_00026_12'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            local table = self.SearchingVox

            --[[if self.Chasing then
                table = self.PursuitVox
            end]]--

            local snd = table[math.random(#table)]
  
            self:PlayVoiceLine(snd, true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        for i = 1, #self.SearchingVox do
            self:StopVoiceLine(self.SearchingVox[i])
        end

        if mode == 1 then return end

        for i = 1, #self.StunVox do
            self:StopVoiceLine(self.StunVox[i])
        end
    end

    function ENT:OnSpotEnemy()
    end

    function ENT:OnLoseEnemy()
    end
end

AddCSLuaFile()