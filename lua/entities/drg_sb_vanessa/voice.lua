ENT.SearchingVox = {
    'VANESSA_00016',
    'VANESSA_00019',
    'VANESSA_00020',
    'VANESSA_00021',
    'VANESSA_00022',
    'VANESSA_00023',
    'VANESSA_00024',
    'VANESSA_00025',
    'VANESSA_00026',
    'VANESSA_00027',
    'VANESSA_00028',
    'VANESSA_00029',
    'VANESSA_00030',
    'VANESSA_00030b',
    'VANESSA_00031'
}

ENT.ListeningVox = {
    'VANESSA_00019',
    'VANESSA_00030b'
}

ENT.SpotVox = {
    'VANESSA_00010',
    'VANESSA_00011',
    'VANESSA_00015'
}

ENT.PursuitVox = {
    'VANESSA_00016'
}

ENT.LostVox = {
    'VANESSA_00013',
    'VANESSA_00014',
    'VANESSA_00017',
    'VANESSA_00020'
}

ENT.StunVox = {
    'VANESSA_LIGHT_FLASH_001',
    'VANESSA_LIGHT_FLASH_002',
    'VANESSA_LIGHT_FLASH_003',
    'VANESSA_LIGHT_FLASH_004',
    'VANESSA_LIGHT_FLASH_005',
    'VANESSA_LIGHT_FLASH_006',
    'VANESSA_LIGHT_FLASH_007',
    'VANESSA_LIGHT_FLASH_008',
    'VANESSA_LIGHT_FLASH_009',
    'VANESSA_LIGHT_FLASH_010',
    'VANESSA_LIGHT_FLASH_011',
    'VANESSA_LIGHT_FLASH_012',
    'VANESSA_LIGHT_FLASH_013',
    'VANESSA_LIGHT_FLASH_014',
    'VANESSA_LIGHT_FLASH_015',
    'VANESSA_LIGHT_FLASH_016',
    'VANESSA_LIGHT_FLASH_017',
    'VANESSA_LIGHT_FLASH_018',
    'VANESSA_LIGHT_FLASH_019'
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

        for i = 1, #self.ListeningVox do
            self:StopVoiceLine(self.ListeningVox[i])
        end

        for i = 1, #self.LostVox do
            self:StopVoiceLine(self.LostVox[i])
        end

        if mode == 1 then return end

        for i = 1, #self.SpotVox do
            self:StopVoiceLine(self.SpotVox[i])
        end
        
        for i = 1, #self.PursuitVox do
            self:StopVoiceLine(self.PursuitVox[i])
        end

        if mode == 2 then return end

        for i = 1, #self.StunVox do
            self:StopVoiceLine(self.StunVox[i])
        end
    end
end

AddCSLuaFile()