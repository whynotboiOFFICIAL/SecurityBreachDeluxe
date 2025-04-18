local idlevox = {
    'FREDDY_00133',
    'FREDDY_00134',
    'FREDDY_00135',
    'FREDDY_00136',
    'FREDDY_00137',
    'FREDDY_00138',
    'FREDDY_00139'
}

local stunvox = {
    'FREDDY_00199',
    'FREDDY_00200',
    'FREDDY_00201',
    'FREDDY_00202'
}

local corruptvox = {
    'FREDDY_00175b_01',
    'FREDDY_00175b_02',
    'FREDDY_00175b_03'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled or not self.Hostile then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            self:PlayVoiceLine(idlevox[math.random(#idlevox)], true)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        self:StopVoiceLine('FREDDY_00094')

        for i = 1, #idlevox do
            self:StopVoiceLine(idlevox[i])
        end

        for i = 1, #stunvox do
            self:StopVoiceLine(stunvox[i])
        end

        for i = 1, #corruptvox do
            self:StopVoiceLine(stunvox[i])
        end
    end

    function ENT:OnStunned()
        self:StopVoices()
        
        if self.OpenChest then
            self:CloseChestHatch()
        end

        if self.Hostile then
            self:PlayVoiceLine(corruptvox[math.random(#corruptvox)], true)
        else
            self:PlayVoiceLine(stunvox[math.random(#stunvox)], true)
        end

        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunin') 
        end)

        self.IdleAnimation = 'stunloop'
    end

    function ENT:OnStunExit()
        self:CallInCoroutine(function(self,delay)
            self:PlaySequenceAndMove('stunout') 
        end)

        self.IdleAnimation = 'idle'
    end

end

AddCSLuaFile()