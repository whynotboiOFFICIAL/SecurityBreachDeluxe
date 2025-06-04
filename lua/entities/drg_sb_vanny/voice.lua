local idlevox = {
    'VANNY_00001',
    'VANNY_00002_001',
    'VANNY_00002_002',
    'VANNY_00002_003',
    'VANNY_00003_001',
    'VANNY_00003_002',
    'VANNY_00003_003'
}

local oldidlevox = {
    'Vanny_Laugh_01',
    'Vanny_Laugh_02',
    'Vanny_Laugh_03',
    'Vanny_Laugh_04',
    'Vanny_Laugh_05',
    'Vanny_Laugh_06',
    'Vanny_VO_Fun',
    'Vanny_VO_ISeeYou',
}
if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(15, 30)

        if math.random(1,10) > 3 then
            if GetConVar('fnaf_sb_new_vanny_oldvo'):GetBool() then
                self:PlayVoiceLine(oldidlevox[math.random(#oldidlevox)])
            else
                self:PlayVoiceLine(idlevox[math.random(#idlevox)])
            end
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices(mode)
        for i = 1, #idlevox do
            self:StopVoiceLine(idlevox[i])
        end
        for i = 1, #oldidlevox do
            self:StopVoiceLine(oldidlevox[i])
        end
    end

    function ENT:OnSpotEnemy()
        if GetConVar('fnaf_sb_new_vanny_spotps5'):GetBool() then
            if self.IdleAnimation ~= 'wave' then
                self.UseWalkframes = false

                self.IdleAnimation = 'wave'

                self:DrG_Timer(3, function()
                    self.UseWalkframes = true

                    self.IdleAnimation = 'idle'
                end)
            end
        elseif GetConVar('fnaf_sb_new_vanny_prespot'):GetBool() then
            self:CallInCoroutine(function(self,delay)
                self:PlaySequenceAndMove('cartwheelpre')
            end)
        end

        self:DrG_Timer(0.05, function()
            self.VoiceDisabled = true
        end)
    end

    function ENT:OnLoseEnemy()
        if self.VoiceDisabled and not IsValid(self.CurrentVictim) then
            self.VoiceDisabled = false
        end
    end
end

AddCSLuaFile()