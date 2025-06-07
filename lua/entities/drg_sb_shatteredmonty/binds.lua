ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = true,
        onkeydown = function(self)
            if self.PounceStarted or self.DisableControls then return end

            self:PounceStart()
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self.Stunned then return end
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
    local eyes = Material('ui/securitybreach/monty/Monty_HUD.png')

    function ENT:PossessionHUD() 
        if not self:GetNWBool('HUDEnabled') then return end
        
        local w, h = ScrW(), ScrH()

        surface.SetDrawColor(100, 100, 100, 255)

        surface.SetMaterial(eyes)

        local w1, h1 = ScreenScale(890), ScreenScale(290)
        local w1 = ScrW() + 800

        surface.DrawTexturedRect(-400, -180, w1, ScrH() / 1.5)
    end
end

if SERVER then
    function ENT:OnPossessed()
    end

    function ENT:OnDispossessed()
    end
end

AddCSLuaFile()