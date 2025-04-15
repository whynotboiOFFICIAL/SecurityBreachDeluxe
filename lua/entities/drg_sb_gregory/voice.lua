local hidingvox = {
    'GREGORY_HIDING_00001',
    'GREGORY_HIDING_00002',
    'GREGORY_HIDING_00003',
    'GREGORY_HIDING_00004',
    'GREGORY_HIDING_00005',
    'GREGORY_HIDING_00006',
    'GREGORY_HIDING_00007',
    'GREGORY_HIDING_00008',
    'GREGORY_HIDING_00009',
    'GREGORY_HIDING_00010',
    'GREGORY_HIDING_00011',
    'GREGORY_HIDING_00012',
    'GREGORY_HIDING_00013',
    'GREGORY_HIDING_00014',
    'GREGORY_HIDING_00015',
    'GREGORY_HIDING_00016',
    'GREGORY_HIDING_00017',
    'GREGORY_HIDING_00018'
}

ENT.CineVox = {
    'GREGORY_00046',
    'GREGORY_00074',
    'GREGORY_00102',
    'GREGORY_00104',
    'GREGORY_00105',
    'GREGORY_00127a',
    'GREGORY_00106',
    'GREGORY_00058',
    'GREGORY_00067'
}

ENT.JumpVox = {
    'GREGORY_JUMP_00001',
    'GREGORY_JUMP_00002',
    'GREGORY_JUMP_00004'
}

ENT.LandVox = {
    'GREGORY_JUMP_00003',
    'GREGORY_LAND_00001',
    'GREGORY_LAND_00002',
    'GREGORY_LAND_00003',
    'GREGORY_LAND_00004',
    'GREGORY_LAND_00005'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        if self.IsHiding then
            self:PlayVoiceLine(hidingvox[math.random(#hidingvox)])
        end

        self:DrG_Timer(2, function()
            self.VoiceTick = false
        end)
    end

    function ENT:PlayVoiceLineSingular(vo)
        local path = self.SFXPath

        local snd = path .. '/vo/' .. vo .. '.wav'

        local dur = SoundDuration(snd) + 0.5

        self.VoiceDisabled = true
        
        self:PlayVoiceLine(vo)

        self:DrG_Timer(dur, function()
            self.VoiceDisabled = false
        end)
    end
    
    function ENT:StopVoices(mode)
        for i = 1, #self.CineVox do
            self:StopVoiceLine(self.CineVox[i])
        end
    end
end

AddCSLuaFile()