ENT.LowVox = {
    'sfx_chica_shattered_vox_low_01',
    'sfx_chica_shattered_vox_low_02',
    'sfx_chica_shattered_vox_low_03',
    'sfx_chica_shattered_vox_low_04',
    'sfx_chica_shattered_vox_low_05',
    'sfx_chica_shattered_vox_low_06',
    'sfx_chica_shattered_vox_low_07',
    'sfx_chica_shattered_vox_low_08',
    'sfx_chica_shattered_vox_low_09',
    'sfx_chica_shattered_vox_low_10',
    'sfx_chica_shattered_vox_low_11'
}

ENT.HighVox = {
    'sfx_chica_shattered_vox_high_01',
    'sfx_chica_shattered_vox_high_02',
    'sfx_chica_shattered_vox_high_03',
    'sfx_chica_shattered_vox_high_04',
    'sfx_chica_shattered_vox_high_05',
    'sfx_chica_shattered_vox_high_06',
    'sfx_chica_shattered_vox_high_07',
    'sfx_chica_shattered_vox_high_08',
    'sfx_chica_shattered_vox_high_09',
    'sfx_chica_shattered_vox_high_10',
    'sfx_chica_shattered_vox_high_11',
    'sfx_chica_shattered_vox_high_12'
}

ENT.ScroakVox = {
    'scroak1',
    'scroak2',
    'scroak3',
    'scroak4',
    'scroak5'
}


if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            if self.CanSpeak then
                self:PlayVoiceLine(self.ScroakVox[math.random(#self.ScroakVox)])
            else
                self:PlayVoiceLine(self.LowVox[math.random(#self.LowVox)])
            end
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        for i = 1, #self.LowVox do
            self:StopVoiceLine(self.LowVox[i])
        end
        for i = 1, #self.HighVox do
            self:StopVoiceLine(self.HighVox[i])
        end
        for i = 1, #self.ScroakVox do
            self:StopVoiceLine(self.ScroakVox[i])
        end
    end
end

AddCSLuaFile()