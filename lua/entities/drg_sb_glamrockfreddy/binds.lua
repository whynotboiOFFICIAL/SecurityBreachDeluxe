ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
        end
    }},

    [IN_ATTACK2] = {{
        coroutine = false,
        onkeydown = function(self)
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
            if not self:IsOnGround() or self.DisableControls then return end
            self:DoorCode() -- DO NOT TOUCH
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
    local battery = Material('ui/securitybreach/freddy/Freddy_HUD_Battery.png')
    local batteryslot = Material('ui/securitybreach/freddy/Freddy_HUD_Battery_slot.png')
    local batterypower = Material('ui/securitybreach/freddy/Freddy_HUD_Battery_fill.png')

    function ENT:PossessionHUD() 
        local w, h = ScrW(), ScrH()

        surface.SetDrawColor(255, 255, 255, 255)

        -- Eyes --

        if self:GetNWBool('UseHeadAttach') then
            surface.SetMaterial(eyesfreddy)

            local w1, h1 = ScreenScale(890), ScreenScale(290)
            local w1 = ScrW() + 800

            surface.DrawTexturedRect(-400, -125, w1, ScrH() / 1.25)
        end

        -- Battery --

        local energy = self:GetNWInt('Energy')

        if energy < 20 then
            surface.SetDrawColor(255, 0, 0, 255)
        else
            surface.SetDrawColor(255, 100, 0, 255)
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
            surface.SetDrawColor(100, 255, 255, 255)
        end

        surface.SetMaterial(batteryslot)

        local w3, h3 = ScreenScale(18), ScreenScale(38)

        surface.DrawTexturedRect(batteryx + 25, h - h3 * 1.42, w3, h3)  
  
        surface.DrawTexturedRect(batteryx + 80, h - h3 * 1.42, w3, h3)    
         
        surface.DrawTexturedRect(batteryx + 135, h - h3 * 1.42, w3, h3)    

        surface.DrawTexturedRect(batteryx + 190, h - h3 * 1.42, w3, h3) 

        surface.DrawTexturedRect(batteryx + 245, h - h3 * 1.42, w3, h3) 

        if maxbatteries > 5 then
            surface.DrawTexturedRect(1455 - batterysub * 14.2, h - h3 * 1.43, w3, h3) 
        end

        if maxbatteries > 6 then
            surface.DrawTexturedRect(1510 - batterysub * 14.2, h - h3 * 1.43, w3, h3) 
        end

        -- Battery Powered --
        
        surface.SetMaterial(batterypower)

        if energy < 1 then return end
        
        surface.DrawTexturedRect(batteryx + 25, h - h3 * 1.42, w3, h3)  
  
        if energy < 20 then return end
        
        surface.DrawTexturedRect(batteryx + 80, h - h3 * 1.42, w3, h3)    
         
        if energy < 40 then return end
        
        surface.DrawTexturedRect(batteryx + 135, h - h3 * 1.42, w3, h3)    

        if energy < 60 then return end
        
        surface.DrawTexturedRect(batteryx + 190, h - h3 * 1.42, w3, h3) 

        if energy < 80 then return end
        
        surface.DrawTexturedRect(batteryx + 245, h - h3 * 1.42, w3, h3) 

        if energy < 120 then return end
        
        surface.DrawTexturedRect(1455 - batterysub * 14.2, h - h3 * 1.42, w3, h3) 

        if energy < 140 then return end
        
        surface.DrawTexturedRect(1510 - batterysub * 14.2, h - h3 * 1.42, w3, h3) 
    end
end

if SERVER then
    function ENT:OnPossessed()
        self:DirectPoseParametersAt(nil, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter())
        
        self:RemoveAllGestures()

        self.OpenChest = false
    end

    function ENT:OnDispossessed(ent)
        self:DrG_Timer(0, function()
            if self:GetNWBool('UseHeadAttach') and self:GetNWInt('Energy') > 1 then
                self:ExitFreddy(ent)
            end

            self:SetNWBool('UseHeadAttach', false)
        end)
    end
end

AddCSLuaFile()