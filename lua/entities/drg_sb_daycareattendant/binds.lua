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
                            if self.AttendantType == 1 then
                                self:JumpscareEntity(v)
                            else
                                self:GrabEntity(v)
                            end
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
        coroutine = false,
        onkeydown = function(self)
            if self.Stunned or self.SkitterDelay or self.AttendantType ~= 1 then return end

            self.SkitterDelay = true

            if self.Skittering then
                self.IdleAnimation = 'mooncrawltowalk'
                self.WalkAnimation = 'mooncrawltowalk'
                self.RunAnimation = 'mooncrawltowalk'
            else
                self.IdleAnimation = 'moonwalktocrawl'
                self.WalkAnimation = 'moonwalktocrawl'
                self.RunAnimation = 'moonwalktocrawl'
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
        if self.AttendantType == 1 then
            self.RunAnimation = 'moonrun'
        else
            if self.IsBlocking then
                self.WalkAnimation = 'walk'

                self.IsBlocking = false
            end
        end
    end

    function ENT:OnDispossessed()
        if self.AttendantType == 1 then      
            if self.MoonRun then
                self.RunAnimation = 'moonrun'
            else
                self.RunAnimation = 'moonwalk'
            end
        end
    end
end

AddCSLuaFile()