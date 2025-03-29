local vox = {
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
    'sfx_chica_shattered_vox_low_11',
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

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            self:PlayVoiceLine(vox[math.random(#vox)], true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        for i = 1, #vox do
            self:StopVoiceLine(vox[i])
        end
    end
end