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
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self.Stunned then return end
            self:PlaySequenceAndMove('turn360')
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
    local staffbotoverlay = Material('ui/securitybreach/staffbot/Staffbot_HUD_Frame_2k.png')

    function ENT:PossessionHUD() 
        local w, h = ScrW(), ScrH()

        surface.SetDrawColor(255, 255, 255, 255)

        -- Overlay --

        surface.SetMaterial(staffbotoverlay)

        local w1, h1 = ScreenScale(890), ScreenScale(290)
        local w1 = ScrW()

        surface.DrawTexturedRect(0, 0, w1, ScrH())
    end
end

if SERVER then
    function ENT:OnPossessed()
    end

    function ENT:OnDispossessed()
    end
end

AddCSLuaFile()