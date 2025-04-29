local laughter = {
    'whynotboi/securitybreach/base/burntrap/laughter/sfx_burntrap_battle_scatter_laughter_01.wav',
    'whynotboi/securitybreach/base/burntrap/laughter/sfx_burntrap_battle_scatter_laughter_02.wav',
    'whynotboi/securitybreach/base/burntrap/laughter/sfx_burntrap_battle_scatter_laughter_03.wav',
    'whynotboi/securitybreach/base/burntrap/laughter/sfx_burntrap_battle_scatter_laughter_demonic_01.wav',
    'whynotboi/securitybreach/base/burntrap/laughter/sfx_burntrap_battle_scatter_laughter_demonic_02.wav',
    'whynotboi/securitybreach/base/burntrap/laughter/sfx_burntrap_battle_scatter_laughter_demonic_03.wav'
}

local whispers = {
    'whynotboi/securitybreach/base/burntrap/whisper/sfx_burntrap_battle_scatter_whisper_01.wav',
    'whynotboi/securitybreach/base/burntrap/whisper/sfx_burntrap_battle_scatter_whisper_02.wav',
    'whynotboi/securitybreach/base/burntrap/whisper/sfx_burntrap_battle_scatter_whisper_03.wav',
    'whynotboi/securitybreach/base/burntrap/whisper/sfx_burntrap_battle_scatter_whisper_04.wav',
    'whynotboi/securitybreach/base/burntrap/whisper/sfx_burntrap_battle_scatter_whisper_05.wav',
    'whynotboi/securitybreach/base/burntrap/whisper/sfx_burntrap_battle_scatter_whisper_06.wav'
}

local swells = {
    'whynotboi/securitybreach/base/burntrap/swell/sfx_burntrap_battle_scatter_swell_01.wav',
    'whynotboi/securitybreach/base/burntrap/swell/sfx_burntrap_battle_scatter_swell_02.wav',
    'whynotboi/securitybreach/base/burntrap/swell/sfx_burntrap_battle_scatter_swell_03.wav'
}

local chains = {
    'whynotboi/securitybreach/base/burntrap/chains/sfx_burntrap_battle_scatter_chains_01.wav',
    'whynotboi/securitybreach/base/burntrap/chains/sfx_burntrap_battle_scatter_chains_02.wav'
}

if SERVER then
    function ENT:VoiceThink()
        if self.VoiceTick or self.VoiceDisabled then return end

        self.VoiceTick = true

        local timer = math.random(10, 15)

        local sound = math.random(1, 500)

        if sound < 100 then
            self:EmitSound(laughter[math.random(#laughter)], 150)
        elseif sound > 200 and sound < 300 then
            self:EmitSound(whispers[math.random(#whispers)], 150)
        elseif sound > 300 and sound < 400 then
            self:EmitSound(swells[math.random(#swells)], 150)
        elseif sound > 400 then
            self:EmitSound(chains[math.random(#chains)], 150)
        end

        self:DrG_Timer(timer, function()
            self.VoiceTick = false
        end)
    end

    function ENT:StopVoices()
        for i = 1, #laughter do
            self:StopSound(laughter[i])
        end
        for i = 1, #chains do
            self:StopSound(chains[i])
        end
        for i = 1, #swells do
            self:StopSound(swells[i])
        end
        for i = 1, #whispers do
            self:StopSound(whispers[i])
        end
    end

    function ENT:OnNewEnemy()
    end
    
    function ENT:OnLoseEnemy()
    end
end

AddCSLuaFile()