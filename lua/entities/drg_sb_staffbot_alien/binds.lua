ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self.Stunned or not self.Aiming then return end
            local trace = self:PossessorTrace()

            self:FireLaser(trace)
        end
    }},

    [IN_ATTACK2] = {{
        coroutine = false,
        onkeydown = function(self)
            if self.AimDelay or self.Stunned then return end

            self.AimDelay = true

            if not self.Aiming then
                self.Aiming = true

                self.PossessionMovement = POSSESSION_MOVE_8DIR

                self:SetNWBool('UseHeadAttach', true)
            else
                self.Aiming = false

                self.PossessionMovement = POSSESSION_MOVE_CUSTOM

                self:SetNWBool('UseHeadAttach', false)
            end

            self:DrG_Timer(0.5, function()
                self.AimDelay = false
            end)
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
            if not self:IsOnGround() or self.DisableControls or self.InteractDelay then return end

            self.InteractDelay = true

            self:DoorCode()
            
            self:DrG_Timer(0.5, function()
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
    local crosshair = Material('ui/securitybreach/blaster/allienbotcrosshair.png')
    local staffbotoverlay = Material('ui/securitybreach/staffbot/Staffbot_HUD_Frame_2k.png')

    function ENT:PossessionHUD() 
        surface.SetDrawColor(255, 255, 255, 255)

        surface.SetMaterial(staffbotoverlay)

        local w1, h1 = ScreenScale(890), ScreenScale(290)
        local w1 = ScrW()

        surface.DrawTexturedRect(0, 0, w1, ScrH())

        if self:GetNWBool('UseHeadAttach') then
            local pos = self:PossessorTrace().HitPos - self:GetRight() * 10

            pos = pos:ToScreen()

            surface.SetMaterial(crosshair)
            surface.DrawTexturedRect(pos.x, pos.y, 25, 25)
        end
    end
end

if SERVER then
    function ENT:OnPossessed()
    end

    function ENT:OnDispossessed()
    end
end

AddCSLuaFile()