ENT.SearchingVox = {
    'ROXY_00023',
    'ROXY_00027',
    'ROXY_00046',
    'ROXY_00047',
    'ROXY_00048',
    'ROXY_00049',
    'ROXY_00050a',
    'ROXY_00051'
}

ENT.ListeningVox = {
    'ROXY_00021',
    'ROXY_00024',
    'ROXY_00025',
    'ROXY_00028'
}

ENT.SpotVox = {
    'ROXY_00007_01',
    'ROXY_00007_02',
    'ROXY_00007_03'
}

ENT.PounceAnticVox = {
    'ROXY_00042_01',
    'ROXY_00042_02',
    'ROXY_00042_03',
    'ROXY_00042_04',
    'ROXY_00042_05',
    'ROXY_00042_06',
    'ROXY_00042_07',
    'ROXY_00042_08',
    'ROXY_00042_09',
    'ROXY_00042_10',
    'ROXY_00042_11',
    'ROXY_00042_12',
    'ROXY_00042_13'
}

ENT.PounceJumpVox = {
    'ROXY_00043_01',
    'ROXY_00043_02',
    'ROXY_00043_03',
    'ROXY_00043_04',
    'ROXY_00043_05',
    'ROXY_00043_06',
    'ROXY_00043_07'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if self.Weeping then
            if math.random(1, 100) > 60 then
                self:StopWeeping()
            else
                timer = math.random(20, 25)

                self:PlayVoiceLine('ROXY_00050', false)
            end
        else
            if math.random(1,10) > 3 then
                if math.random(1, 100) > 60 and self.CanWeep then
                    timer = 20

                    self:StartWeeping()

                    self:PlayVoiceLine('ROXY_00050', false)
                else
                    local table = self.SearchingVox

                    local snd = table[math.random(#table)]
          
                    self:PlayVoiceLine(snd, true)
                end
            end
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StartWeeping()
        if not self.CanWeep then return end

        self:SetMovement(70, 70, 250)

        self.IdleAnimation = 'weepidle'
        self.WalkAnimation = 'weepwalk'
        self.RunAnimation = 'weepwalk'

        self.Weeping = true
        
        self.Moving = false
    end

    function ENT:StopWeeping()
        self:SetMovement(60, 200, 250)

        self.IdleAnimation = 'idle'
        self.WalkAnimation = 'walk'
        self.RunAnimation = 'run'

        self.Weeping = false
    end

    function ENT:StopVoices(mode)
        for i = 1, #self.SearchingVox do
            self:StopVoiceLine(self.SearchingVox[i])
        end

        for i = 1, #self.ListeningVox do
            self:StopVoiceLine(self.ListeningVox[i])
        end

        self:StopVoiceLine('ROXY_00050')

        if mode == 1 then return end

        for i = 1, #self.SpotVox do
            self:StopVoiceLine(self.SpotVox[i])
        end
    end
end

AddCSLuaFile()