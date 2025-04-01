ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
            if self.Stunned or GetConVar('ai_disabled'):GetBool() or self.DisableControls then return end

            if not self.CatchTick and not self.AlertDelay then          
                local size = 140
                local dir = self:GetForward()
                local angle = math.cos( math.rad( 90 ) )
                local startPos = self:WorldSpaceCenter()
    
                self.CatchTick = true
    
                for k, v in ipairs( ents.FindInCone( startPos, dir, size, angle ) ) do
                    if (v == self or v == self:GetPossessor()) or (v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC')) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool()) or v:Health() < 1 then continue end
    
                    self:CallInCoroutine(function(self,delay)
                        self:AlertMode(self.AlertPhase, v)
                    end)
    
                    break
                end
    
                self:DrG_Timer(0.3, function()
                    self.CatchTick = false
                end)
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
end

if SERVER then
    function ENT:OnPossessed()
    end

    function ENT:OnDispossessed()
    end
end

AddCSLuaFile()