ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = true,
        onkeydown = function(self) 
            if self.PounceStarted or self.DisableControls or not self.CanPounce or self.Inhabited then return end

            self:PounceStart()
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self:GetNWBool('UseHeadAttach') or self.Stunned then return end
            for k,v in pairs(ents.FindInSphere(self:LocalToWorld(Vector(0,0,50)), 50)) do
                if v ~= self and v ~= self:GetPossessor() then
                    if v:IsPlayer() or v:IsNextBot() or v:IsNPC() then
                        self:JumpscareEntity(v)
                    end
                end
            end
        end
    }},

    [IN_ATTACK2] = {{
        coroutine = false,
        onkeydown = function(self)
            if not self:IsOnGround() or not self.Voicebox or self.Stunned or self.VoiceboxDelay then return end

            self:UseVoicebox()
        end
    }},

    [IN_SPEED] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }},

    [IN_RELOAD] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self:GetNWBool('UseHeadAttach') or self.Stunned or self.ChestDelay then return end

            self.ChestDelay = true

            if not self.OpenChest then
                self:OpenChestHatch()
            else
                self:CloseChestHatch()
            end

            self:DrG_Timer(2, function()
                self.ChestDelay = false
            end)
        end
    }},

    [IN_SCORE] = {{
        coroutine = true,
        onkeydown = function(self)
        end
    }},

    [IN_USE] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self.DisableControls or self.InteractDelay then return end

            self.InteractDelay = true

            self:DoorCode()
            
            self:DrG_Timer(1, function()
                self.InteractDelay = false
            end)
        end
    }},

    [IN_DUCK] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }}
}

ENT.PossessionViews = {
    {
        offset = Vector(0, 0, 20),
        distance = 90
    }
}

if CLIENT then
    local eyesfreddy = Material('ui/securitybreach/freddy/Freddy_HUD_frame_4k.png')
    local eyesroxy = Material('ui/securitybreach/freddy/Roxy_HUD_Frame_v3_4k.png')

    local battery = Material('ui/securitybreach/freddy/Freddy_HUD_Battery.png')
    local batteryslot = Material('ui/securitybreach/freddy/Freddy_HUD_Battery_slot.png')
    local batterypower = Material('ui/securitybreach/freddy/Freddy_HUD_Battery_fill.png')

    function ENT:PossessionHUD() 
        local w, h = ScrW(), ScrH()

        surface.SetDrawColor(255, 255, 255, 255)

        -- Eyes --

        if self:GetNWBool('UseHeadAttach') then
            if self:GetNWBool('RoxyEyes') then
                surface.SetMaterial(eyesroxy)  
            else
                surface.SetMaterial(eyesfreddy)
            end

            local w1, h1 = ScreenScale(890), ScreenScale(290)
            local w1 = ScrW() + 800

            surface.DrawTexturedRect(-400, -180, w1, ScrH() / 1.5)
        end

        -- Battery --

        if self:GetNWBool('NoBatteryHUD') then return end

        local energy = self:GetNWInt('Energy')

        if energy < 20 then
            surface.SetDrawColor(255, 0, 0, 255)
        else
            if self:GetNWBool('RoxyEyes') then
                surface.SetDrawColor(132, 0, 255, 255)
            else
                surface.SetDrawColor(255, 100, 0, 255)
            end
        end

        surface.SetMaterial(battery)

        local w2, h2 = ScreenScale(110), ScreenScale(50)
        local batteryx = w / 2 - w2 / 2

        surface.DrawTexturedRect(batteryx, h - h2 * 1.2, w2, h2)
        
        -- Battery Slot --
        
        local batterysub = 0

        local maxbatteries = 5

        if energy < 20 then
            surface.SetDrawColor(255, 0, 0, 255)
        else
            if self:GetNWBool('RoxyEyes') then
                surface.SetDrawColor(93, 201, 107)
            else
                surface.SetDrawColor(100, 255, 255, 255)
            end
        end

        surface.SetMaterial(batteryslot)

        local w3, h3 = ScreenScale(18), ScreenScale(38)

        surface.DrawTexturedRect(batteryx + ScreenScale(8), h - h3 * 1.42, w3, h3)  
  
        surface.DrawTexturedRect(batteryx + ScreenScale(26.8), h - h3 * 1.42, w3, h3)    
         
        surface.DrawTexturedRect(batteryx + ScreenScale(45), h - h3 * 1.42, w3, h3)    

        surface.DrawTexturedRect(batteryx + ScreenScale(63.5), h - h3 * 1.42, w3, h3) 

        surface.DrawTexturedRect(batteryx + ScreenScale(81.8), h - h3 * 1.42, w3, h3) 

        if maxbatteries > 5 then
            surface.DrawTexturedRect(1455 - batterysub * 14.2, h - h3 * 1.43, w3, h3) 
        end

        if maxbatteries > 6 then
            surface.DrawTexturedRect(1510 - batterysub * 14.2, h - h3 * 1.43, w3, h3) 
        end

        -- Battery Powered --
        
        surface.SetMaterial(batterypower)

        if energy < 1 then return end
        
        surface.DrawTexturedRect(batteryx + ScreenScale(8.5), h - h3 * 1.42, w3, h3)  
  
        if energy < 20 then return end
        
        surface.DrawTexturedRect(batteryx + ScreenScale(26.8), h - h3 * 1.42, w3, h3)    
         
        if energy < 40 then return end
        
        surface.DrawTexturedRect(batteryx + ScreenScale(45), h - h3 * 1.42, w3, h3)    

        if energy < 60 then return end
        
        surface.DrawTexturedRect(batteryx + ScreenScale(63.5), h - h3 * 1.42, w3, h3) 

        if energy < 80 then return end
        
        surface.DrawTexturedRect(batteryx + ScreenScale(81.8), h - h3 * 1.42, w3, h3) 

        if energy < 120 then return end
        
        surface.DrawTexturedRect(1455 - batterysub * 14.2, h - h3 * 1.42, w3, h3) 

        if energy < 140 then return end
        
        surface.DrawTexturedRect(1510 - batterysub * 14.2, h - h3 * 1.42, w3, h3) 
    end

    hook.Add("CalcView", "SBNEWSECONDARYCAMERAVIEW", function(ply, origin, angles, fov, znear, zfar)
        if not ply:GetNWBool('InFreddy2Play') then return end

        local possessing = ply:GetNWEntity('2PlayFreddy')

        if not IsValid(possessing) then return end

		local view = {}
		view.origin, view.angles = possessing:PossessorView()
		view.fov, view.znear, view.zfar = fov, znear, zfar
		view.drawviewer = true
		return view
	end)
end

if SERVER then
    function ENT:OnPossessed()
        self:DirectPoseParametersAt(nil, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter())

        self:RemoveAllGestures()

        self.OpenChest = false

        if self:GetNWBool('RoxyEyes') then
            self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/sfx_roxyEyes_hud_lp.wav')
        end

        if not self:GetNWBool('UseHeadAttach') then
            if self.BatteryConfig == 1 then
                self:SetNWBool('NoBatteryHUD', true)
            end

            if IsValid(self.Partner) then
                self.Partner.GlamrockFreddy = nil
                self.Partner = nil
            end
        end
    end

    function ENT:OnDispossessed(ent)
        self:DrG_Timer(0, function()

            if self.BatteryConfig ~= 3 then
                self:SetNWBool('NoBatteryHUD', false)
            end

            if not self.DisableControls then
                self:SetMovement(60, 280, 250)
            end

            if self:GetNWBool('UseHeadAttach') and self:GetNWInt('Energy') > 1 then
                self:ExitFreddy(ent)
            end

            if self:GetNWBool('RoxyEyes') then
                self:StopSound('whynotboi/securitybreach/base/glamrockfreddy/sfx_roxyEyes_hud_lp.wav')
            end

            self:SetNWBool('UseHeadAttach', false)
        end)
    end
    
end

AddCSLuaFile()