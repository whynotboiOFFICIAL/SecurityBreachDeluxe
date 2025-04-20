-- General
local useplyfov = CreateClientConVar('fnaf_sb_new_fov_camera', 0, true, false, 'Camera Inherits Player FOV', 0, 1)

CreateConVar('fnaf_sb_new_hw2_jumpscares', 0, FCVAR_ARCHIVE, 'Help Wanted 2 Jumpscares', 0, 1)
CreateConVar('fnaf_sb_new_voicelines', 1, FCVAR_ARCHIVE, 'Use Voice Lines', 0, 1)
CreateConVar('fnaf_sb_new_damaging', 1, FCVAR_ARCHIVE, 'Gradual Damging', 0, 1)
CreateConVar('fnaf_sb_new_betaeyes', 0, FCVAR_ARCHIVE, 'Beta Eye Glows', 0, 1)
CreateConVar('fnaf_sb_new_traileranims', 0, FCVAR_ARCHIVE, 'Gameplay Trailer Animations', 0, 1)
CreateConVar('fnaf_sb_new_shattereds_redeyes', 0, FCVAR_ARCHIVE, 'Shattereds Red Eyes', 0, 1)

-- Glamrock Freddy

CreateConVar('fnaf_sb_new_freddy_friendly', 1, FCVAR_ARCHIVE, 'Glamrock Freddy Safe Mode', 0, 1)
CreateConVar('fnaf_sb_new_freddy_safeeyes', 1, FCVAR_ARCHIVE, 'Glamrock Freddy Safe Mode Eyes', 0, 1)
CreateConVar('fnaf_sb_new_freddy_montyclaws', 0, FCVAR_ARCHIVE, 'Glamrock Freddy Claws Upgrade', 0, 1)
CreateConVar('fnaf_sb_new_freddy_chicavoice', 0, FCVAR_ARCHIVE, 'Glamrock Freddy Voicebox Upgrade', 0, 1)
CreateConVar('fnaf_sb_new_freddy_roxyeyes', 0, FCVAR_ARCHIVE, 'Glamrock Freddy Ocular Upgrade', 0, 1)
CreateConVar('fnaf_sb_new_freddy_montylegs', 0, FCVAR_ARCHIVE, 'Glamrock Freddy Locomotive Upgrade', 0, 1)
CreateConVar('fnaf_sb_new_freddy_batteryconfig', 1, FCVAR_ARCHIVE, 'Glamrock Freddy Battery', 1, 3)

-- Glamrock Chica

CreateConVar('fnaf_sb_new_chica_voiceattack', 0, FCVAR_ARCHIVE, 'Glamrock Chica Voicebox', 0, 1)
CreateConVar('fnaf_sb_new_chica_canlure', 1, FCVAR_ARCHIVE, 'Glamrock Chica Eating', 0, 1)
CreateConVar('fnaf_sb_new_chica_playereat', 1, FCVAR_ARCHIVE, 'Glamrock Chica Possession Eating', 0, 1)

-- Montgomery Gator

CreateConVar('fnaf_sb_new_monty_transglass', 0, FCVAR_ARCHIVE, 'Montgomery Gator Transparent Shades', 0, 1)
CreateConVar('fnaf_sb_new_monty_pounceattack', 1, FCVAR_ARCHIVE, 'Montgomery Gator Pounce', 0, 1)
CreateConVar('fnaf_sb_new_monty_enablestun', 0, FCVAR_ARCHIVE, 'Montgomery Gator Stun', 0, 1)

-- Roxanne Wolf

CreateConVar('fnaf_sb_new_roxy_pounceattack', 1, FCVAR_ARCHIVE, 'Roxanne Wolf Pounce', 0, 1)

-- Shattered Chica

CreateConVar('fnaf_sb_new_shatteredchica_hasvoice', 0, FCVAR_ARCHIVE, 'Shattered Chica Has Voice', 0, 1)
CreateConVar('fnaf_sb_new_shatteredchica_canlure', 1, FCVAR_ARCHIVE, 'Shattered Chica Eating', 0, 1)
CreateConVar('fnaf_sb_new_shatteredchica_playereat', 1, FCVAR_ARCHIVE, 'Shattered Chica Possession Eating', 0, 1)

-- Shattered Monty

CreateConVar('fnaf_sb_new_shatteredmonty_haslegs', 0, FCVAR_ARCHIVE, 'Shattered Monty Has Legs', 0, 1)
CreateConVar('fnaf_sb_new_shatteredmonty_pounceattack', 1, FCVAR_ARCHIVE, 'Shattered Monty Pounce', 0, 1)

-- Shattered Roxy

CreateConVar('fnaf_sb_new_shatteredroxy_haseyes', 0, FCVAR_ARCHIVE, 'Shattered Roxy Has Eyes', 0, 1)
CreateConVar('fnaf_sb_new_shatteredroxy_pounceattack', 1, FCVAR_ARCHIVE, 'Shattered Roxy Pounce', 0, 1)

-- Daycare Attendant

CreateConVar('fnaf_sb_new_sun_alwayshostile', 0, FCVAR_ARCHIVE, 'Sun Always Hostile', 0, 1)
CreateConVar('fnaf_sb_new_moon_userun', 0, FCVAR_ARCHIVE, 'Moon Run Animation', 0, 1)

-- Glamrock Endo

CreateConVar('fnaf_sb_new_endo_sleep', 1, FCVAR_ARCHIVE, 'Glamrock Endo Sleeping', 0, 1)
CreateConVar('fnaf_sb_new_endo_chase', 0, FCVAR_ARCHIVE, 'Glamrock Endo Chase', 0, 1)

-- STAFF Bots

CreateConVar('fnaf_sb_new_staffbot_stunvoice', 1, FCVAR_ARCHIVE, 'S.T.A.F.F. Bot Stun Voiceline', 0, 1)
CreateConVar('fnaf_sb_new_alienbot_skin', 1, FCVAR_ARCHIVE, 'FazerBlast Bot Skin', 1, 4)
CreateConVar('fnaf_sb_new_cleanerbot_voice', 1, FCVAR_ARCHIVE, 'Cleaner Bot Voicelines', 0, 1)
CreateConVar('fnaf_sb_new_nightmarebot_buried', 1, FCVAR_ARCHIVE, 'Nightmare Bot Buried', 0, 1)

-- Wind-Up Music Man

CreateConVar('fnaf_sb_new_ldjmm_music', 1, FCVAR_ARCHIVE, 'Wind-Up Music Man Music', 0, 1)

-- DJ Music Man

CreateConVar('fnaf_sb_new_djmm_music', 1, FCVAR_ARCHIVE, 'DJ Music Man Music', 0, 1)
CreateConVar('fnaf_sb_new_djmm_sleep', 1, FCVAR_ARCHIVE, 'DJ Music Man Sleeping', 0, 1)
CreateConVar('fnaf_sb_new_djmm_animeyes', 0, FCVAR_ARCHIVE, 'DJ Music Man Animated Eyes', 0, 1)

-- Vanessa

CreateConVar('fnaf_sb_new_vanessa_oldvo', 0, FCVAR_ARCHIVE, 'Vanessa Old Voicelines', 0, 1)
CreateConVar('fnaf_sb_new_vanessa_oldface', 0, FCVAR_ARCHIVE, 'Vanessa Old Textures', 0, 1)
CreateConVar('fnaf_sb_new_vanessa_lightstun', 0, FCVAR_ARCHIVE, 'Vanessa Light Stun', 0, 1)

-- Vanny

CreateConVar('fnaf_sb_new_vanny_oldvo', 0, FCVAR_ARCHIVE, 'Vanny Old Voicelines', 0, 1)
CreateConVar('fnaf_sb_new_vanny_spotps5', 0, FCVAR_ARCHIVE, 'Vanny Wave Spot Animation', 0, 1)
CreateConVar('fnaf_sb_new_vanny_preidle', 0, FCVAR_ARCHIVE, 'Vanny Prerelease Idle Animation', 0, 1)
CreateConVar('fnaf_sb_new_vanny_prewalk', 0, FCVAR_ARCHIVE, 'Vanny Prerelease Walk Animation', 0, 1)
CreateConVar('fnaf_sb_new_vanny_prerun', 0, FCVAR_ARCHIVE, 'Vanny Prerelease Run Animation', 0, 1)
CreateConVar('fnaf_sb_new_vanny_prespot', 0, FCVAR_ARCHIVE, 'Vanny Prerelease Run Animation', 0, 1)
CreateConVar('fnaf_sb_new_vanny_prejumpscare', 0, FCVAR_ARCHIVE, 'Vanny Prerelease Jumpscare Animation', 0, 1)

-- The Blob

CreateConVar('fnaf_sb_new_blob_tendrils', 1, FCVAR_ARCHIVE, 'Blob Tendril Attack', 0, 1)
CreateConVar('fnaf_sb_new_blob_proxjumpscare', 1, FCVAR_ARCHIVE, 'Blob Hostile', 0, 1)

-- Burntrap

CreateConVar('fnaf_sb_new_burntrap_jumpscare', 1, FCVAR_ARCHIVE, 'Burntrap Jumpscare', 0, 1)
CreateConVar('fnaf_sb_new_burntrap_hacksfreddy', 1, FCVAR_ARCHIVE, 'Burntrap Hacks Freddy', 0, 1)

game.AddParticles( 'particles/jummyyummy_fnafsb.pcf')

function FNaF_AddNextBot(ENT, category, order)
    local classname = string.gsub(ENT.Folder, 'entities/', '')

    list.Set('FNaF', classname, {classname, ENT.PrintName, category, order})

    DrGBase.AddNextbot(ENT)
end
	
hook.Add('SetupMove', 'SBNEWCHICAVOICEBOXSLOWED', function(ply, mv, cmd)
	if ply:GetNWBool('SBVoiceBoxStun') then
		mv:SetMaxClientSpeed(70)
	end
end)

if SERVER then
	util.AddNetworkString('SECURITYBREACHFINALLYJUMPSCARE')
	util.AddNetworkString('SECURITYBREACHFINALLYCINEMATIC')
	--util.AddNetworkString('SECURITYBREACHFINALLYHIDING')

    hook.Add('PlayerButtonDown', 'SBNEWSECONDARYNOBUTTONS', function(ply, button)
        if not IsValid(ply:GetNWEntity('2PlayFreddy')) and not IsValid(ply:GetNWEntity('HidingSpotSB')) and not IsValid(ply.GlamrockFreddy) then return end

        local ent = ply:GetNWEntity('HidingSpotSB')

		if IsValid(ply:GetNWEntity('2PlayFreddy')) then
			ent = ply:GetNWEntity('2PlayFreddy')
		end

		
		if IsValid(ply.GlamrockFreddy) then
			ent = ply.GlamrockFreddy
	
			if button == 17 then
				if ent.SummonFreddy then
					ent:SummonFreddy(ply)
				end
			end
		else
			if button == 15 then
				if ent.DeinitSecondary then
					ent:DeinitSecondary(ply)
				else
					ent:Use(ply)
				end
			end
		end
    end)

    hook.Add( 'PlayerSwitchWeapon', 'SBNEWSECONDARYNOWEAPONSWITCH', function(ply)
		if IsValid(ply:GetNWEntity('2PlayFreddy')) or not IsValid(ply:GetNWEntity('HidingSpotSB')) then return end

        return true
    end)
end

if CLIENT then
	hook.Add( 'AddToolMenuTabs', 'SBNEWCONFIGOPTIONSFNAF', function()
        spawnmenu.GetToolMenu('wnbfnaftab', 'FNaF', 'ui/fnafico.png')
    
		-- Security Breach Options

        spawnmenu.AddToolCategory('wnbfnaftab', 'wnbfnafsb', 'FNaF Security Breach')
    
        spawnmenu.AddToolMenuOption( 'wnbfnaftab', 'wnbfnafsb', 'wnbfnafsbentry', 'Options', '', '', function( panel )
            panel:ClearControls()
			
			-- Clientsided
			panel:Help('')
			panel:Help('Personal Settings')
			panel:Help('')

			panel:CheckBox('Camera Inherits Player FOV', 'fnaf_sb_new_fov_camera')
            panel:ControlHelp('Hiding Spots and Jumpscares use the players current FOV instead of using a fixed value of 80 and 70 degrees respectively.')

			-- General

			panel:Help('')
			panel:Help('')
			panel:Help('General')
			panel:Help('')


            panel:CheckBox('Help Wanted 2 Jumpscares', 'fnaf_sb_new_hw2_jumpscares')
            panel:ControlHelp('Characters that have jumpscares in Help Wanted 2 will switch to those respective jumpscares')
			panel:ControlHelp('(This will apply model changes to Shattered Roxy)')

			panel:CheckBox('Use Voice Lines', 'fnaf_sb_new_voicelines')
            panel:ControlHelp('Characters talk and make vocals as they do ingame')

			panel:CheckBox('Gradual Damaging', 'fnaf_sb_new_damaging')
			panel:ControlHelp('Characters get dirtier the more they take damage')
			panel:ControlHelp('(This will only apply to the main 4 Glamrocks)')

			panel:CheckBox('Beta Eye Glows', 'fnaf_sb_new_betaeyes')
			panel:ControlHelp('Characters will use their early eye emission textures')
			panel:ControlHelp('(This will only apply to the main 4 Glamrocks)')
			panel:ControlHelp('(This does not apply to Freddy\'s Safe Mode or Purple eyes)')

			panel:CheckBox('Gameplay Trailer Animations', 'fnaf_sb_new_traileranims')
			panel:ControlHelp('Characters will use recreations of their animations from the gameplay trailer')
			panel:ControlHelp('(This will only apply to Chica, Monty, and Roxy)')

			panel:CheckBox('Shattereds Red Eyes', 'fnaf_sb_new_shattereds_redeyes')
			panel:ControlHelp('Shattereds will use a red eye glow like in the Halloween tweet by Steel Wool')

			-- Glamrock Freddy

			panel:Help('')
			panel:Help('')
			panel:Help('Glamrock Freddy')
			panel:Help('')

			panel:CheckBox('Glamrock Freddy Safe Mode', 'fnaf_sb_new_freddy_friendly')
            panel:ControlHelp('Glamrock Freddy will not be hostile and instead will assist if available')
			
			panel:CheckBox('Glamrock Freddy Safe Mode Eyes', 'fnaf_sb_new_freddy_safeeyes')
            panel:ControlHelp('Glamrock Freddy\'s eyes will glow white when Safe Mode is applied')

			panel:CheckBox('Glamrock Freddy Claws Upgrade', 'fnaf_sb_new_freddy_montyclaws')
            panel:ControlHelp('Glamrock Freddy will be equipped with Monty\'s claws')

			panel:CheckBox('Glamrock Freddy Voicebox Upgrade', 'fnaf_sb_new_freddy_chicavoice')
            panel:ControlHelp('Glamrock Freddy will be equipped with Chica\'s voicebox')

			panel:CheckBox('Glamrock Freddy Ocular Upgrade', 'fnaf_sb_new_freddy_roxyeyes')
            panel:ControlHelp('Glamrock Freddy will be equipped with Roxy\'s eyes')
			
			panel:CheckBox('Glamrock Freddy Locomotive Upgrade', 'fnaf_sb_new_freddy_montylegs')
            panel:ControlHelp('Glamrock Freddy will be equipped with Monty\'s legs')
	
            local batteryconfig = panel:ComboBox('Glamrock Freddy Battery', 'fnaf_sb_new_freddy_batteryconfig')

            batteryconfig:AddChoice( 'Battery Only Drains When Inside', 1 )
            batteryconfig:AddChoice( 'Battery Drains Both Inside and Out', 2 )
            batteryconfig:AddChoice( 'Infinite Battery', 3 )

			-- Glamrock Chica

			panel:Help('')
			panel:Help('')
			panel:Help('Glamrock Chica')
			panel:Help('')

			panel:CheckBox('Glamrock Chica Voicebox', 'fnaf_sb_new_chica_voiceattack')
            panel:ControlHelp('Glamrock Chica will be use her vocals to slow enemies and scare animatronics')
			
			panel:CheckBox('Glamrock Chica Eating', 'fnaf_sb_new_chica_canlure')
            panel:ControlHelp('Glamrock Chica will be forced to eat Monty Mix during AI')
			
			panel:CheckBox('Glamrock Chica Possession Eating', 'fnaf_sb_new_chica_playereat')
            panel:ControlHelp('Glamrock Chica will be forced to eat Monty Mix during possession')
			
			-- Montgomery Gator

			panel:Help('')
			panel:Help('')
			panel:Help('Montgomery Gator')
			panel:Help('')

			panel:CheckBox('Montgomery Gator Transparent Shades', 'fnaf_sb_new_monty_transglass')
            panel:ControlHelp('Montgomery Gator has see through glasses')

			panel:CheckBox('Montgomery Gator Pounce', 'fnaf_sb_new_monty_pounceattack')
            panel:ControlHelp('Montgomery Gator will leap through the air to try and kill you')

			panel:CheckBox('Montgomery Gator Stun', 'fnaf_sb_new_monty_enablestun')
            panel:ControlHelp('Montgomery Gator will be stunned like the other animatronics')	

			-- Roxanne Wolf

			panel:Help('')
			panel:Help('')
			panel:Help('Roxanne Wolf')
			panel:Help('')

			panel:CheckBox('Roxanne Wolf Pounce', 'fnaf_sb_new_roxy_pounceattack')
            panel:ControlHelp('Roxanne Wolf will leap through the air to try and kill you')
			
			-- Shattered Chica
			
			panel:Help('')
			panel:Help('')
			panel:Help('Shattered Chica')
			panel:Help('')

			panel:CheckBox('Shattered Chica Has Voice', 'fnaf_sb_new_shatteredchica_hasvoice')
            panel:ControlHelp('Shattered Chica will be able to use her voicebox again')
			
			panel:CheckBox('Shattered Chica Eating', 'fnaf_sb_new_shatteredchica_canlure')
            panel:ControlHelp('Shattered Chica will be forced to eat Monty Mix during AI')
			
			panel:CheckBox('Shattered Chica Possession Eating', 'fnaf_sb_new_shatteredchica_playereat')
            panel:ControlHelp('Shattered Chica will be forced to eat Monty Mix during possession')
					
			-- Shattered Monty
			
			panel:Help('')
			panel:Help('')
			panel:Help('Shattered Monty')
			panel:Help('')

			panel:CheckBox('Shattered Monty Has Legs', 'fnaf_sb_new_shatteredmonty_haslegs')
            panel:ControlHelp('Shattered Monty will be able to stand on his legs again')
			
			panel:CheckBox('Shattered Monty Pounce', 'fnaf_sb_new_shatteredmonty_pounceattack')
            panel:ControlHelp('Shattered Monty will leap through the air to try and kill you')
						
			-- Shattered Roxy
			
			panel:Help('')
			panel:Help('')
			panel:Help('Shattered Roxy')
			panel:Help('')

			panel:CheckBox('Shattered Roxy Has Eyes', 'fnaf_sb_new_shatteredroxy_haseyes')
            panel:ControlHelp('Shattered Roxy will be able to see again')
			
			panel:CheckBox('Shattered Roxy Pounce', 'fnaf_sb_new_shatteredroxy_pounceattack')
            panel:ControlHelp('Shattered Roxy will leap through the air to try and kill you')
			
			-- Daycare Attendant

			panel:Help('')
			panel:Help('')
			panel:Help('Daycare Attendant')
			panel:Help('')

			panel:CheckBox('Sun Always Hostile', 'fnaf_sb_new_sun_alwayshostile')
            panel:ControlHelp('Sun will chase and kill you instead of being protective')
			
			panel:CheckBox('Moon Run Animation', 'fnaf_sb_new_moon_userun')
            panel:ControlHelp('Moon will run when chasing you instead of walking')
			panel:ControlHelp('(This will stop Moon from crawling when he is chasing you)')
			
			-- Glamrock Endo

			panel:Help('')
			panel:Help('')
			panel:Help('Glamrock Endo')
			panel:Help('')

			panel:CheckBox('Glamrock Endo Sleeping', 'fnaf_sb_new_endo_sleep')
            panel:ControlHelp('Glamrock Endo will spawn in asleep')

			panel:CheckBox('Glamrock Endo Chase', 'fnaf_sb_new_endo_chase')
            panel:ControlHelp('Glamrock Endo will chase you even if you are staring')
													
			-- STAFFBOTS

			panel:Help('')
			panel:Help('')
			panel:Help('S.T.A.F.F. Bots')
			panel:Help('')

			panel:CheckBox('S.T.A.F.F. Bot Stun Voiceline', 'fnaf_sb_new_staffbot_stunvoice')
            panel:ControlHelp('S.T.A.F.F. Bots use the stun voiceline that was removed from the game')

            local batteryconfig = panel:ComboBox('FazerBlast Bot Skin', 'fnaf_sb_new_alienbot_skin')

            batteryconfig:AddChoice( 'Base S.T.A.F.F. Bot', 1 )
            batteryconfig:AddChoice( 'Cut Alien Skin', 2 )
            batteryconfig:AddChoice( 'Cut FazerBlast Skin', 3 )
			batteryconfig:AddChoice( 'Randomize Skin', 4 )

			panel:CheckBox('Cleaner Bot Voicelines', 'fnaf_sb_new_cleanerbot_voice')
            panel:ControlHelp('Cleaner Bot uses its unused voice lines')

			panel:CheckBox('Nightmare Bot Buried', 'fnaf_sb_new_nightmarebot_buried')
            panel:ControlHelp('Nightmare Bot will work more as a landmine rather than a Security Bot')

			-- Wind-Up Music Man

			panel:Help('')
			panel:Help('')
			panel:Help('Wind-Up Music Man')
			panel:Help('')

			panel:CheckBox('Wind-Up Music Man Music', 'fnaf_sb_new_ldjmm_music')
            panel:ControlHelp('Wind-Up Music Man plays his music box while spawned')
									
			-- DJ Music Man

			panel:Help('')
			panel:Help('')
			panel:Help('DJ Music Man')
			panel:Help('')

			panel:CheckBox('DJ Music Man Music', 'fnaf_sb_new_djmm_music')
            panel:ControlHelp('DJ Music Man plays his groovy music while spawned')

			panel:CheckBox('DJ Music Man Sleeping', 'fnaf_sb_new_djmm_sleep')
            panel:ControlHelp('DJ Music Man sleeps when spawned and not alerted')

			panel:CheckBox('DJ Music Man Animated Eyes', 'fnaf_sb_new_djmm_animeyes')
            panel:ControlHelp('DJ Music Man plays animations on his eyes from Help Wanted 2')
												
			-- Vanessa

			panel:Help('')
			panel:Help('')
			panel:Help('Vanessa')
			panel:Help('')

			panel:CheckBox('Vanesssa Old Voicelines', 'fnaf_sb_new_vanessa_oldvo')
            panel:ControlHelp('Vanessa uses old versions of her search lines')

			panel:CheckBox('Vanesssa Old Textures', 'fnaf_sb_new_vanessa_oldface')
            panel:ControlHelp('Vanessa uses old versions of her face textures')

			panel:CheckBox('Vanessa Light Stun', 'fnaf_sb_new_vanessa_lightstun')
            panel:ControlHelp('Vanessa glares her light at players blinding them')
															
			-- Vanny

			panel:Help('')
			panel:Help('')
			panel:Help('Vanny')
			panel:Help('')

			panel:CheckBox('Vanny Old Voicelines', 'fnaf_sb_new_vanny_oldvo')
            panel:ControlHelp('Vanny uses old versions of her voicelines')

			panel:CheckBox('Vanny Wave Spot Animation', 'fnaf_sb_new_vanny_spotps5')
            panel:ControlHelp('Vanny uses her wave animation when she spots something')

			panel:CheckBox('Vanny Prerelease Idle Animation', 'fnaf_sb_new_vanny_preidle')
            panel:ControlHelp('Vanny uses her prerelease idle animation')

			panel:CheckBox('Vanny Prerelease Walk Animation', 'fnaf_sb_new_vanny_prewalk')
            panel:ControlHelp('Vanny uses her prerelease walk animation')

			panel:CheckBox('Vanny Prerelease Run Animation', 'fnaf_sb_new_vanny_prerun')
            panel:ControlHelp('Vanny uses her prerelease run animation')
			
			panel:CheckBox('Vanny Prerelease Spot Animation', 'fnaf_sb_new_vanny_prespot')
            panel:ControlHelp('Vanny uses her prerelease cartwheel animation when she spots something')
				
			panel:CheckBox('Vanny Trailer Jumpscare Animation', 'fnaf_sb_new_vanny_prejumpscare')
            panel:ControlHelp('Vanny uses her jumpscare animation from the trailer')
																	
			-- The Blob

			panel:Help('')
			panel:Help('')
			panel:Help('The Blob')
			panel:Help('')

			panel:CheckBox('Blob Tendril Attack', 'fnaf_sb_new_blob_tendrils')
            panel:ControlHelp('The Blob uses its tendrils to search and attack you around the map')

			panel:CheckBox('Blob Hostile', 'fnaf_sb_new_blob_proxjumpscare')
            panel:ControlHelp('The Blob will jumpscare you when too close')
																				
			-- Burntrap

			panel:Help('')
			panel:Help('')
			panel:Help('Burntrap')
			panel:Help('')

			panel:CheckBox('Burntrap Jumpscare', 'fnaf_sb_new_burntrap_jumpscare')
            panel:ControlHelp('Burntrap uses a custom jumpscare whenever you get cloes')

			panel:CheckBox('Burntrap Hacks Freddy', 'fnaf_sb_new_burntrap_hacksfreddy')
            panel:ControlHelp('Burntrap will attempt to hack Glamrock Freddy in an attempt to kill you')
		end)
	end)

	hook.Add( 'PreDrawHalos', 'SBNEWTHESEAREROXYSEYES?!', function()
		local color = Color(255,255,0)
		local ply = LocalPlayer()
		local nextbot = ply:DrG_GetPossessing()

		if not IsValid(nextbot) or not nextbot:GetNWBool('RoxyEyes') then return end

		local targets = {}

		for k,v in ipairs(ents.FindInSphere(nextbot:WorldSpaceCenter(), 1000)) do
			if v == ply or v == nextbot then continue end
			if (v:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool()) then continue end
			if IsValid(v:GetNWEntity('2PlayFreddy')) or IsValid(v:GetNWEntity('HidingSpotSB')) then continue end
			if not (v:IsPlayer() or v:IsNextBot() or v:IsNPC()) then continue end
			
			table.insert(targets, v)
		end
		
		halo.Add(targets, color, 1, 1, 5, true, true )
	end )

	net.Receive('SECURITYBREACHFINALLYJUMPSCARE', function()
		local ply = LocalPlayer()
		local ent = net.ReadEntity()
		local state = net.ReadBool()
		local hookname = 'sbnewjumpcamera' .. tostring(ply)

		if not state then
			hook.Remove('CalcView', hookname)
			return
		end

		local transitionStart = RealTime()

		hook.Add('CalcView', hookname, function(ply, pos, angles, fov)
			if not IsValid(ply) or not ply:Alive() or not IsValid(ent) then
				hook.Remove('CalcView', hookname)
				return
			end	
			local transitionProgress = math.Clamp((RealTime() - transitionStart) / 0.25, 0, 1)
			local cam = ent:GetAttachment(ent:LookupAttachment('Jumpscare_jnt'))
			local fovnum = useplyfov:GetBool() and LocalPlayer():GetFOV() or 70
			return {
				origin = LerpVector(transitionProgress, pos, cam.Pos),
				angles = LerpAngle(transitionProgress, angles, cam.Ang + AngleRand(-0.35,0.35)),
				fov = fovnum,
				drawviewer = false
			}
		end)
	end)

	net.Receive('SECURITYBREACHFINALLYCINEMATIC', function()
		local ply = LocalPlayer()
		local ent = net.ReadEntity()
		local state = net.ReadBool()
		local hookname = 'sbnewcincamera' .. tostring(ply)

		if not state then
			hook.Remove('CalcView', hookname)
			return
		end

		local transitionStart = RealTime()

		hook.Add('CalcView', hookname, function(ply, pos, angles, fov)
			if not IsValid(ply) or not ply:Alive() or not IsValid(ent) then
				hook.Remove('CalcView', hookname)
				return
			end	
			local transitionProgress = math.Clamp((RealTime() - transitionStart) / 0.25, 0, 1)
			local cam = ent:GetAttachment(ent:LookupAttachment('Cam'))
			local fovnum = useplyfov:GetBool() and LocalPlayer():GetFOV() or 80
			return {
				origin = LerpVector(transitionProgress, pos, cam.Pos),
				angles = LerpAngle(transitionProgress, angles, cam.Ang),
				fov = fovnum,
				drawviewer = false
			}
		end)
	end)
	
	--[[net.Receive('SECURITYBREACHFINALLYHIDING', function()
		local ply = LocalPlayer()
		local ent = net.ReadEntity()
		local state = net.ReadBool()
		local hookname = 'sbnewhidingcamera' .. tostring(ply)

		if not state then
			hook.Remove('CalcView', hookname)
			return
		end

		local transitionStart = RealTime()

		hook.Add('CalcView', hookname, function(ply, pos, angles, fov)
			if not IsValid(ply) or not ply:Alive() or not IsValid(ent) then
				hook.Remove('CalcView', hookname)
				return
			end	
			local transitionProgress = math.Clamp((RealTime() - transitionStart) / 0.25, 0, 1)
			local cam = ent:GetAttachment(ent:LookupAttachment('Cam'))
			return {
				origin = cam.Pos - Vector(0, 0, 5),
				angles = cam.Ang + angles,
				fov = 80,
				drawviewer = false
			}
		end)
	end)]]--
end

SBDELUXE = {}

function SBDELUXE:AddEnglishCaption(soundName, text, isfx)
    sound.AddCaption({
        sound = soundName:lower(),
        duration = SoundDuration(soundName:lower()),
        sfx = isfx,
        text = { english = text }
    })
end

local files = file.Find('lua/captions/securitybreach/*.lua', 'GAME')

for k, filename in ipairs(files) do
    local path = 'captions/securitybreach/' .. filename

    if SERVER then
        AddCSLuaFile(path)
    end
    
    include(path)
end