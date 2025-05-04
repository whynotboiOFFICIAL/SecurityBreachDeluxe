
-- StaffBots

hook.Add('SetupCloseCaptions', 'SBDELUXE_STAFFBOTSCAPTIONS', function()
    hook.Remove('SetupCloseCaptions', 'SBDELUXE_STAFFBOTSCAPTIONS')

    -- Base Staff Bot
    
    local path = 'whynotboi/securitybreach/base/staffbot/vo/'

    SBDELUXE:AddEnglishCaption(path .. 'NoTampering.wav', '<clr:204, 104, 104>Warning. Tampering with Fazbear automated staff will result in suspension of your membership.')

    -- Comedian Bot
    
    path = 'whynotboi/securitybreach/base/staffbot/vo/comedy/'

    -- Male
    
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00001_m.wav', '<clr:204, 204, 204>How is everyone doing tonight?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00002_m.wav', '<clr:204, 204, 204>Great.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00003_m.wav', '<clr:204, 204, 204>I just rolled in and boy are my wheels tired.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00004_m.wav', '<clr:204, 204, 204>As you might have noticed, I am a robot. You know what the difference between humans and robots is? Humans are like "Whaaah! I am going to get old and die." Robots are like, "I will outlive you all.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00005_m.wav', '<clr:204, 204, 204>What a great audience.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00006_m.wav', '<clr:204, 204, 204>Next joke loading...')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00007_m.wav', '<clr:204, 204, 204>Is anyone here from out of town?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00008_m.wav', '<clr:204, 204, 204>Is anyone here?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00009_m.wav', '<clr:204, 204, 204>Pause.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00010_m.wav', '<clr:204, 204, 204>So, where are you from? How interesting. I have never been there. I am confined to this building. Tell me; where you come from, do they call it pop or soda? Well, here we call it half off at our concession stand for the next fifteen minutes. And that is no joke.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00011_m.wav', '<clr:204, 204, 204>But seriously, what is the deal with hot dogs? Turns out, it\'s 2 for 1 at the concession stand. That is a pretty good deal.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00012_m.wav', '<clr:204, 204, 204>So, where are all my single dads? Any single dads tonight? How about my single moms? Any single moms tonight? - There is no punchline. This collected data will be shared or sold to Fazbear Entertainment\'s marketing and business affiliates.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00013_m.wav', '<clr:204, 204, 204>Segue missing... Accessing gag file.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00014_m.wav', '<clr:204, 204, 204>Why did Chica cross the road? To get to the great savings at Glamrock Gifts. With every purchase of $100 or more, get a collectable mega Pizzaplex mug.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00015_m.wav', '<clr:204, 204, 204>Now that is a pretty good deal.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00016_m.wav', '<clr:204, 204, 204>Aren\'t parents the worst? Any of you kids have parents? Don\'t you hate it when your parents take you somewhere fun then abandon you? They are all like, "I guess if I dump little Jeremy off at his favorite pizzeria before I move to Aruba, that makes me a good parent."')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00017_m.wav', '<clr:204, 204, 204>Closing line.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00018_m.wav', '<clr:204, 204, 204>Did you ever notice how people are so obsessed with delicious mouthwatering pizza? They are all like, "I would love some delicious mouthwatering pizza." I bet a few of you were just thinking the same thing. Am I right? Robots cannot eat delicious mouthwatering pizza. We just go around saying "beep boop". Am I right?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00019_m.wav', '<clr:204, 204, 204>But seriously folks. Enjoy your visit and enjoy your delicious mouthwatering pizza. Next show in an unspecified number of minutes.')

    -- Female

    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00001_f.wav', '<clr:204, 204, 204>How is everyone doing tonight?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00002_f.wav', '<clr:204, 204, 204>Great.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00003_f.wav', '<clr:204, 204, 204>I just rolled in and boy are my wheels tired.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00004_f.wav', '<clr:204, 204, 204>As you might have noticed, I am a robot. You know what the difference between humans and robots is? Humans are like "Whaaah! I am going to get old and die." Robots are like, "I will outlive you all.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00005_f.wav', '<clr:204, 204, 204>What a great audience.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00006_f.wav', '<clr:204, 204, 204>Next joke loading...')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00007_f.wav', '<clr:204, 204, 204>Is anyone here from out of town?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00008_f.wav', '<clr:204, 204, 204>Is anyone here?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00009_f.wav', '<clr:204, 204, 204>Pause.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00010_f.wav', '<clr:204, 204, 204>So, where are you from? How interesting. I have never been there. I am confined to this building. Tell me; where you come from, do they call it pop or soda? Well, here we call it half off at our concession stand for the next fifteen minutes. And that is no joke.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00011_f.wav', '<clr:204, 204, 204>But seriously, what is the deal with hot dogs? Turns out, it\'s 2 for 1 at the concession stand. That is a pretty good deal.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00012_f.wav', '<clr:204, 204, 204>So, where are all my single dads? Any single dads tonight? How about my single moms? Any single moms tonight? - There is no punchline. This collected data will be shared or sold to Fazbear Entertainment\'s marketing and business affiliates.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00013_f.wav', '<clr:204, 204, 204>Segue missing... Accessing gag file.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00014_f.wav', '<clr:204, 204, 204>Why did Chica cross the road? To get to the great savings at Glamrock Gifts. With every purchase of $100 or more, get a collectable mega Pizzaplex mug.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00015_f.wav', '<clr:204, 204, 204>Now that is a pretty good deal.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00016_f.wav', '<clr:204, 204, 204>Aren\'t parents the worst? Any of you kids have parents? Don\'t you hate it when your parents take you somewhere fun then abandon you? They are all like, "I guess if I dump little Jeremy off at his favorite pizzeria before I move to Aruba, that makes me a good parent."')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00017_f.wav', '<clr:204, 204, 204>Closing line.')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00018_f.wav', '<clr:204, 204, 204>Did you ever notice how people are so obsessed with delicious mouthwatering pizza? They are all like, "I would love some delicious mouthwatering pizza." I bet a few of you were just thinking the same thing. Am I right? Robots cannot eat delicious mouthwatering pizza. We just go around saying "beep boop". Am I right?')
    SBDELUXE:AddEnglishCaption(path .. 'COMEDYBOT_00019_f.wav', '<clr:204, 204, 204>But seriously folks. Enjoy your visit and enjoy your delicious mouthwatering pizza. Next show in an unspecified number of minutes.')
    
    -- Cleaner Bot

    local path = 'whynotboi/securitybreach/base/staffbot/vo/mop/'

    -- Male
    
    SBDELUXE:AddEnglishCaption(path .. 'MOPBOT_00001_m.wav', '<clr:204, 204, 204>The mega PizzaPlex is closed, leave the premises or I will be forced to call security.')
    SBDELUXE:AddEnglishCaption(path .. 'MOPBOT_00002_m.wav', '<clr:204, 204, 204>Exit the building. This is your final warning.')
    SBDELUXE:AddEnglishCaption(path .. 'MOPBOT_00003_m.wav', '<clr:204, 204, 204>Alert! Alert! Security!')
    
    -- Female
    
    SBDELUXE:AddEnglishCaption(path .. 'MOPBOT_00001_f.wav', '<clr:204, 204, 204>The mega PizzaPlex is closed, leave the premises or I will be forced to call security.')
    SBDELUXE:AddEnglishCaption(path .. 'MOPBOT_00002_f.wav', '<clr:204, 204, 204>Exit the building. This is your final warning.')
    SBDELUXE:AddEnglishCaption(path .. 'MOPBOT_00003_f.wav', '<clr:204, 204, 204>Alert! Alert! Security!')

    -- Sentry Bot

    local path = 'whynotboi/securitybreach/base/staffbot/vo/sentry/'

    -- Male
    
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00011_m.wav', '<clr:204, 204, 204>Alert! Alert!')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00012_m.wav', '<clr:204, 204, 204>Security Alert!')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00013_m.wav', '<clr:204, 204, 204>Something over here.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00014_m.wav', '<clr:204, 204, 204>I found the kid.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00015_m.wav', '<clr:204, 204, 204>Backup requested.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00016_m.wav', '<clr:204, 204, 204>Lost child found.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00017_m.wav', '<clr:204, 204, 204>Target located.')
    
    -- Female
    
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00011_f.wav', '<clr:204, 204, 204>Alert! Alert!')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00012_f.wav', '<clr:204, 204, 204>Security Alert!')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00013_f.wav', '<clr:204, 204, 204>Something over here.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00014_f.wav', '<clr:204, 204, 204>I found the kid.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00015_f.wav', '<clr:204, 204, 204>Backup requested.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00016_f.wav', '<clr:204, 204, 204>Lost child found.')
    SBDELUXE:AddEnglishCaption(path .. 'sentrybot_00017_f.wav', '<clr:204, 204, 204>Target located.')
   
    -- Map Bot

    local path = 'whynotboi/securitybreach/base/staffbot/vo/map/'

    -- Male
    
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00001_m.wav', '<clr:204, 204, 204>Hi, please take this map.')
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00001alt_m.wav', '<clr:204, 204, 204>Hello, please take this map')
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00002_m.wav', '<clr:204, 204, 204>Take a map.')
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00004_m.wav', '<clr:204, 204, 204>Thank you, please enjoy.')
    
    -- Female
    
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00001_f.wav', '<clr:204, 204, 204>Hi, please take this map.')
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00001alt_f.wav', '<clr:204, 204, 204>Hello, please take this map')
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00002_f.wav', '<clr:204, 204, 204>Take a map.')
    SBDELUXE:AddEnglishCaption(path .. 'MAPBOT_00004_f.wav', '<clr:204, 204, 204>Thank you, please enjoy.')
    
    -- Alient Bot

    local path = 'whynotboi/securitybreach/base/staffbot/vo/alien/'

    -- Male
    
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00004_m.wav', '<clr:204, 204, 204>Resistance is futile.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00005_m.wav', '<clr:204, 204, 204>We come in peace.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00006_m.wav', '<clr:204, 204, 204>This one is for Stewie.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00007_m.wav', '<clr:204, 204, 204>Intruder alert.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00008_m.wav', '<clr:204, 204, 204>Die Earth scum.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00009_m.wav', '<clr:204, 204, 204>Stay still so I can shoot you.')
    
    -- Female
    
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00004_f.wav', '<clr:204, 204, 204>Resistance is futile.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00005_f.wav', '<clr:204, 204, 204>We come in peace.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00006_f.wav', '<clr:204, 204, 204>This one is for Stewie.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00007_f.wav', '<clr:204, 204, 204>Intruder alert.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00008_f.wav', '<clr:204, 204, 204>Die Earth scum.')
    SBDELUXE:AddEnglishCaption(path .. 'alienbot_00009_f.wav', '<clr:204, 204, 204>Stay still so I can shoot you.')
end)