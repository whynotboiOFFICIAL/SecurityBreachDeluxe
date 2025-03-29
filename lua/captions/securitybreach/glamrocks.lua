
-- Glamrocks

hook.Add('SetupCloseCaptions', 'SBDELUXE_GLAMROCKCAPTIONS', function()
    hook.Remove('SetupCloseCaptions', 'SBDELUXE_GLAMROCKSCAPTIONS')

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
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00012_01.wav', '<clr:255, 177, 255>No more games.')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00012_02.wav', '<clr:255, 177, 255>No more games.')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00012_03.wav', '<clr:255, 177, 255>No more games.')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00013.wav', '<clr:255, 177, 255>Our friendly security staff can help!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00014.wav', '<clr:255, 177, 255>Come out come out wherever you are!')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00015.wav', '<clr:255, 177, 255>This area is off limits.')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00016.wav', '<clr:255, 177, 255>Employees only.')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00016a.wav', '<clr:255, 177, 255>Staff only.')
    SBDELUXE:AddEnglishCaption(path .. 'CHICA_00017.wav', '<clr:255, 177, 255>I am just trying to help.')
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

    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00005.wav', '<clr:25, 255, 0>Hey kid! Come on out, we\'re only trying to help.')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00006.wav', '<clr:25, 255, 0>I know you\'re here...')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00007.wav', '<clr:25, 255, 0>Give up.')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00008.wav', '<clr:25, 255, 0>You can hide, but you can\'t hide!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00009.wav', '<clr:25, 255, 0>Let\'s rock.')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00010.wav', '<clr:25, 255, 0>I will find you...')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00011.wav', '<clr:25, 255, 0>You really think we won\'t find you?')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00012.wav', '<clr:25, 255, 0>You can\'t hide forever!')
    SBDELUXE:AddEnglishCaption(path .. 'MONTY_00023.wav', '<clr:25, 255, 0>Don\'t be scared.')

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
    
    path = 'whynotboi/securitybreach/base/roxannewolf/vo/'
    
    -- Roxy Idle Voices

    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00009.wav', '<clr:200, 0, 255>Hey kid! Come on out, we\'re only trying to help.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00010.wav', '<clr:200, 0, 255>You might as well give up.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00011.wav', '<clr:200, 0, 255>Give up, you can\'t win.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00012.wav', '<clr:200, 0, 255>There\'s nowhere to hide...')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00013.wav', '<clr:200, 0, 255>You really think we won\'t find you?')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00014.wav', '<clr:200, 0, 255>You can\'t hide forever')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00016.wav', '<clr:200, 0, 255>You can\'t outrun me!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00017.wav', '<clr:200, 0, 255>You think you\'re better than me?!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00022.wav', '<clr:200, 0, 255>Want an autograph?')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00029.wav', '<clr:200, 0, 255>Are you lost?')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00030.wav', '<clr:200, 0, 255>I can help.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00031.wav', '<clr:200, 0, 255>Are you hungry?')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00032.wav', '<clr:200, 0, 255>Don\'t be scared.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00033.wav', '<clr:200, 0, 255>I bet I\'m your favorite.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00034.wav', '<clr:200, 0, 255>Sneak away little coward.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00035.wav', '<clr:200, 0, 255>I bet you don\'t even have friends.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00036.wav', '<clr:200, 0, 255>You are nothing!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00037.wav', '<clr:200, 0, 255>Nobody will miss you.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00038.wav', '<clr:200, 0, 255>Come on out!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00044.wav', '<clr:200, 0, 255>You\'re the best... You will find him first.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00045.wav', '<clr:200, 0, 255>Keep searching! He can\'t hide forever.')

    -- Roxy Spot Voices
    
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00018.wav', '<clr:200, 0, 255>I\'m the best!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00019.wav', '<clr:200, 0, 255>I found him!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00020.wav', '<clr:200, 0, 255>Over here!')
 
    -- Shattered Roxy Idle Voices

    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00021.wav', '<clr:200, 0, 255>I heard that.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00023.wav', '<clr:200, 0, 255>Where are you!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00024.wav', '<clr:200, 0, 255>I can still hear you!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00025.wav', '<clr:200, 0, 255>I can hear you...')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00026.wav', '<clr:200, 0, 255>I can\'t see you, but I can hear you!')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00027.wav', '<clr:200, 0, 255>Why are you hiding from me?')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00028.wav', '<clr:200, 0, 255>I know you\'re there...')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00046.wav', '<clr:200, 0, 255>Everybody still loves me, right?')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00047.wav', '<clr:200, 0, 255>I am... still beautiful.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00048.wav', '<clr:200, 0, 255>I just need a little work done.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00049.wav', '<clr:200, 0, 255>My hair is ruined.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00050.wav', '<clr:200, 0, 255>*Crying*')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00050a.wav', '<clr:200, 0, 255>I\'m not a loser.')
    SBDELUXE:AddEnglishCaption(path .. 'ROXY_00051.wav', '<clr:200, 0, 255>Why!... Why!...')

    -- Moon Idle Voices

    path = 'whynotboi/securitybreach/base/moon/vo/'
    
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00002.wav', '<clr:0, 21, 255>Hidey hide! Hide away...')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00003.wav', '<clr:0, 21, 255>It\'s past your bedtime.')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00004.wav', '<clr:0, 21, 255>Bad children must be found.')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00005.wav', '<clr:0, 21, 255>Bad children must be punished.')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_01.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_02.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_03.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_04.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_05.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_06.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_07.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00006_08.wav', '<clr:0, 21, 255>*Laughing*')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00007.wav', '<clr:0, 21, 255>Knock knock.')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00008.wav', '<clr:0, 21, 255>Good night...')
    SBDELUXE:AddEnglishCaption(path .. 'MOON_00010.wav', '<clr:0, 21, 255>Rrrrggh... Clean up! Clean up!')
end)