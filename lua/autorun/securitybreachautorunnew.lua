if SERVER then
	util.AddNetworkString('SECURITYBREACHFINALLYJUMPSCARE')
	util.AddNetworkString('SECURITYBREACHFINALLYCINEMATIC')
	--util.AddNetworkString('SECURITYBREACHFINALLYHIDING')

	
    hook.Add("PlayerButtonDown", "SBNEWSECONDARYNOBUTTONS", function(ply, button)
        if not IsValid(ply:GetNWEntity('HidingSpotSB')) then return end

        local spot  = ply:GetNWEntity('HidingSpotSB') 

        if button == 15 then
			spot:Use(ply)
        end
    end)

    hook.Add( "PlayerSwitchWeapon", "SBNEWSECONDARYNOWEAPONSWITCH", function(ply)
		if not IsValid(ply:GetNWEntity('HidingSpotSB')) then return end

        return true
    end)

end

if CLIENT then
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
			return {
				origin = LerpVector(transitionProgress, pos, cam.Pos),
				angles = LerpAngle(transitionProgress, angles, cam.Ang + AngleRand(-0.35,0.35)),
				fov = 70,
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
			return {
				origin = LerpVector(transitionProgress, pos, cam.Pos),
				angles = LerpAngle(transitionProgress, angles, cam.Ang),
				fov = 80,
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