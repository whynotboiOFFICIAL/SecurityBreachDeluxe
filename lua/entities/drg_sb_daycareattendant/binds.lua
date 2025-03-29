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
            if self.Swimming then return end
            
            self:StartHook()
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
    function ENT:PossessionHUD() 
    end
end

if SERVER then
    function ENT:OnPossessed()
        if self.AttendantType == 1 then
            self.RunAnimation = 'moonrun'
        end
    end

    function ENT:OnDispossessed()
        if self.AttendantType == 1 then
            self.RunAnimation = 'moonwalk'
        end
    end
end

AddCSLuaFile()