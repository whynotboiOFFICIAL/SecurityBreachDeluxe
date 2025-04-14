ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = false,
        onkeydown = function(self)
            if not self:IsOnGround() or self.Crouched then return end
            
            self:DoJump()
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
            if not self:IsOnGround() then return end
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
            if self.CrouchDelay then return end

            self.CrouchDelay = true

            if not self.Crouched then
                self:Crouch()
            else
                self:UnCrouch()
            end

            self:DrG_Timer(0.5, function()
                self.CrouchDelay = false
            end)
        end
    }}
}

ENT.PossessionViews = {
    {
        offset = Vector(0, 0, 20),
        distance = 40
    },
    {
        offset = Vector(5, 0, 0),
        distance = 0,
        eyepos = true
    }
}

if CLIENT then
    function ENT:PossessionHUD() 
    end

    function ENT:PossessorView()
        local pos, ang = self.BaseTable.PossessorView(self)

        if self:GetNWBool('CustomPossessorCam') then
            local ent = self:GetNWEntity('PossessionJumpscareEntity')

            if IsValid(ent) then
                local attach = ent:GetAttachment(ent:LookupAttachment('Jumpscare_jnt'))

                pos = attach.Pos
                ang = attach.Ang + AngleRand(-0.35,0.35)
            end

            ent = self:GetNWEntity('PossessionCinematicEntity')

            if IsValid(ent) then
                local attach = ent:GetAttachment(ent:LookupAttachment('Cam'))

                pos = attach.Pos
                ang = attach.Ang
            end
        end

        return pos, ang
    end
end

if SERVER then
    function ENT:OnPossessed()
    end

    function ENT:OnDispossessed()
    end
end

AddCSLuaFile()