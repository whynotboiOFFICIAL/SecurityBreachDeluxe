
-- Humans

hook.Add('SetupCloseCaptions', 'SBDELUXE_MISCCAPTIONS', function()
    hook.Remove('SetupCloseCaptions', 'SBDELUXE_MISCCAPTIONS')

    local path = 'whynotboi/securitybreach/base/props/noisemaker/daycare/topple/'

    -- Daycare Noisemaker SFX
    
    SBDELUXE:AddEnglishCaption(path .. 'sfx_dynObj_noisemaker_topple_01.wav', '<clr:255, 255, 255><sfx>*Noisemaker Toppling*<sfx>')
    SBDELUXE:AddEnglishCaption(path .. 'sfx_dynObj_noisemaker_topple_02.wav', '<clr:255, 255, 255><sfx>*Noisemaker Toppling*<sfx>')
    SBDELUXE:AddEnglishCaption(path .. 'sfx_dynObj_noisemaker_topple_03.wav', '<clr:255, 255, 255><sfx>*Noisemaker Toppling*<sfx>')
end)