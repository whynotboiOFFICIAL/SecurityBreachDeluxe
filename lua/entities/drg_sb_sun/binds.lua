ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self.Stunned or self.GrabDelay then return end

            self.GrabDelay = true

            if IsValid(self.HoldEnt) then
                self:OnReachedPatrol()
            else
                for k,v in pairs(ents.FindInSphere(self:LocalToWorld(Vector(0,0,50)), 50)) do
                    if v ~= self and v ~= self:GetPossessor() then
                        if v:IsPlayer() or v:IsNextBot() or v:IsNPC() then
                            self:GrabEntity(v)
                        end
                    end
                end
            end

            self:DrG_Timer(0.5, function()
                self.GrabDelay = false
            end)
        end
    }},

    [IN_ATTACK2] = {{
        coroutine = true,
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
    local eyes = Material('ui/securitybreach/attendant/SunHUD.png')

    function ENT:PossessionHUD() 
        if not self:GetNWBool('HUDEnabled') then return end
        
        local w, h = ScrW(), ScrH()

        surface.SetDrawColor(255, 255, 255, 255)

        surface.SetMaterial(eyes)

        local w1, h1 = ScreenScale(890), ScreenScale(290)
        local w1 = ScrW() + 800

        surface.DrawTexturedRect(-400, -180, w1, ScrH() / 1.5)
    end
end

if SERVER then
    function ENT:OnPossessed()
        if self.IsBlocking then
            self.WalkAnimation = 'walk'

            self.IsBlocking = false
        end
    end
end

AddCSLuaFile()