
-- Glamrocks

hook.Add('SetupCloseCaptions', 'SBDELUXE_GLAMROCKCHICACAPTIONS', function()
    hook.Remove('SetupCloseCaptions', 'SBDELUXE_GLAMROCKCHICACAPTIONS')

    local path = 'whynotboi/securitybreach/base/glamrockchica/vo/'

    -- Chica Idle Voices
    
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00005.wav', '<clr:255, 177, 255>Are you lost?')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00005b.wav', '<clr:255, 177, 255>I\'ll take you to your parents...')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00006.wav', '<clr:255, 177, 255>Let me take you to your parents...')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00007.wav', '<clr:255, 177, 255>Your family is looking for you!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00008.wav', '<clr:255, 177, 255>Your parents want you to follow me!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00009.wav', '<clr:255, 177, 255>Don\'t worry! You\'re safe with me...')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00010.wav', '<clr:255, 177, 255>Gregory?')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00011.wav', '<clr:255, 177, 255>Where are you?')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00012_01.wav', '<clr:255, 177, 255>No more games')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00012_02.wav', '<clr:255, 177, 255>No more games')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00012_03.wav', '<clr:255, 177, 255>No more games')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00013.wav', '<clr:255, 177, 255>Our friendly security staff can help!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00014.wav', '<clr:255, 177, 255>Come out come out wherever you are!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00015.wav', '<clr:255, 177, 255>This area is off limits')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00016.wav', '<clr:255, 177, 255>Employees only')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00016a.wav', '<clr:255, 177, 255>Staff only')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00017.wav', '<clr:255, 177, 255>I am just trying to help')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00018.wav', '<clr:255, 177, 255>Who wants candy?')

    -- Chica Spot Voices

    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00019.wav', '<clr:255, 177, 255>I found you!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00020.wav', '<clr:255, 177, 255>There you are!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00021.wav', '<clr:255, 177, 255>Tag! You\'re it!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00022.wav', '<clr:255, 177, 255>Stop!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00023.wav', '<clr:255, 177, 255>Gregory!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00024.wav', '<clr:255, 177, 255>Lost boy over here!')

    path = 'whynotboi/securitybreach/base/montgomerygator/vo/'
    
    -- Monty Idle Voices

    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00005.wav', '<clr:25, 255, 0>Hey kid! Come on out, we\'re only trying to help')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00006.wav', '<clr:25, 255, 0>I know you\'re here...')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00007.wav', '<clr:25, 255, 0>Give up')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00008.wav', '<clr:25, 255, 0>You can hide, but you can\'t hide!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00009.wav', '<clr:25, 255, 0>Let\'s rock')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00010.wav', '<clr:25, 255, 0>I will find you...')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00011.wav', '<clr:25, 255, 0>You really think we won\'t find you?')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00012.wav', '<clr:25, 255, 0>You can\'t hide forever!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00023.wav', '<clr:25, 255, 0>Don\'t be scared')

    -- Monty Spot Voices

    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00013.wav', '<clr:25, 255, 0>Over here!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00014.wav', '<clr:25, 255, 0>There you are!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00015.wav', '<clr:25, 255, 0>Hey! Little guy!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00016.wav', '<clr:25, 255, 0>Where you going?')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00017.wav', '<clr:25, 255, 0>Party time!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00018.wav', '<clr:25, 255, 0>Ha ha ha ha ha ha!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00019.wav', '<clr:25, 255, 0>Game over kid!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00020.wav', '<clr:25, 255, 0>Rock and roll!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00021.wav', '<clr:25, 255, 0>Run run run!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00022.wav', '<clr:25, 255, 0>You\'re in trouble now!')
end)