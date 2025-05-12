ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() or self.Stunned  then return end

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
        coroutine = true,
        onkeydown = function(self)
            if self.Swimming then return end
            
            -- Fuck this --

            --self:StartHook()
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
        coroutine = true,
        onkeydown = function(self)
            if self.Stunned or self.SkitterDelay then return end

            self.SkitterDelay = true

            if self.Skittering then
                self:PlaySequenceAndMove('mooncrawltowalk')
            else
                self:PlaySequenceAndMove('moonwalktocrawl')
            end
            
            self:DrG_Timer(2, function()
                self.SkitterDelay = false
            end)
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
        self.RunAnimation = 'moonrun'

        self:SetMovement(136, 240)
    end

    function ENT:OnDispossessed()
        if self.MoonRun then
            self.RunAnimation = 'moonrun'

            self:SetMovement(136, 240)
        else
            self.RunAnimation = 'moonwalk'

            self:SetMovement(136, 136)
        end
    end
end

AddCSLuaFile()