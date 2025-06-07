ENT.PossessionBinds = {    
    [KEY_0] = {{
        coroutine = false,
        onbuttondown = function(self)
            if self.SwitchDelay or self.CurrentItem == 0 then return end

            self.SwitchDelay = true

            self:DeEquipFlashlight()

            self:DrG_Timer(0.5, function()
                self.SwitchDelay = false
            end)
        end,
        onkeydown = function(self)
            if self.FlashlightToggleDelay or self.CurrentItem ~= 1 then return end

            self.FlashlightToggleDelay = true
            
            self:FlashlightToggle()

            self:DrG_Timer(0.3, function()
                self.FlashlightToggleDelay = false
            end)
        end
    }},

    [KEY_1] = {{
        coroutine = false,
        onbuttondown = function(self)
            if self.SwitchDelay or self.CurrentItem == 1 then return end

            self.SwitchDelay = true

            self:EquipFlashlight()

            self:DrG_Timer(0.5, function()
                self.SwitchDelay = false
            end)
        end,
        onkeydown = function(self)
            if not self:IsOnGround() or self.Crouched then return end
            
            self:DoJump()
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
            if self.SummonDelay or not self.GlamrockFreddy or self.VoiceDisabled then return end

            local fred = self.GlamrockFreddy

            self.SummonDelay = true

            if fred.IsSick and math.random(1,100) > 50 and not fred.MetWhenSick then
                self:PlayVoiceLineSingular(self.CineVox[math.random(6)])
            end

            fred:SummonFreddy(self)

            self:DrG_Timer(0.5, function()
                self.SummonDelay = false
            end)
        end
    }},

    [IN_SCORE] = {{
        coroutine = false,
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
    local staminaframe = Material('ui/securitybreach/gregory/Gregory_HUD_Stamina_frame.png')
    local staminabar = Material('ui/securitybreach/gregory/Gregory_HUD_Stamina_Fill.png')

    local crouch = Material('ui/securitybreach/gregory/Gregory_HUD_crouch_noflashlight_white_icon.png')
    local crouchLight = Material('ui/securitybreach/gregory/Gregory_HUD_crouch_white_icon.png')

    local currentStamina = 200
    local alpha = 0
    local alpha2 = 0

    local hasRunOut = false

    function ENT:PossessionHUD() 
        if not self:GetNWBool('HUDEnabled') then return end
        
        local w, h = ScrW(), ScrH()

        local stamina = self:GetNWFloat('Stamina')

        local isRunDisabled = self:GetNWBool('DisableRun')

        if hasRunOut and not isRunDisabled then
            alpha = 1
        end

        hasRunOut = isRunDisabled

        if stamina < 200 then
            if hasRunOut then
                local value = math.floor((SysTime() * 3) % 2)

                alpha = (value == 0 and 0 or 1)
            else
                alpha = math.Clamp(alpha + RealFrameTime(), 0, 1)
            end
        elseif stamina >= 200 then
            alpha = math.Clamp(alpha - RealFrameTime(), 0, 1)
        end

        if hasRunOut then
            surface.SetDrawColor(255, 0, 0, 255 * alpha)
        else
            surface.SetDrawColor(76, 77, 174, 255 * alpha)
        end

        surface.SetMaterial(staminaframe)

        local w2, h2 = ScreenScale(200), ScreenScale(10)
        local batteryx = w / 2 - w2 / 2

        surface.DrawTexturedRect(batteryx, h - h2 * 3.5, w2, h2)

        currentStamina = math.Approach(currentStamina, stamina, RealFrameTime() * 85)

        w2 = ScreenScale(200 * (currentStamina / 200))

        batteryx = w / 2 - w2 / 2

        surface.SetMaterial(staminabar)

        surface.DrawTexturedRect(batteryx, h - h2 * 3.5, w2, h2)
        
        -- Crouching 

        local crouching = self:GetNWBool('Crouching')

        local hasFlashlight = self:GetNWBool('HasFlashlight')

        if crouching then
            alpha2 = math.Clamp(alpha2 + RealFrameTime() * 1.5, 0, 1)
        else
            alpha2 = math.Clamp(alpha2 - RealFrameTime() * 1.5, 0, 1)
        end

        surface.SetDrawColor(76, 77, 174, 255 * alpha2)

        w2, h2 = ScreenScale(40), ScreenScale(40)

        batteryx = w / 1.1 - w2 / 2

        if hasFlashlight then
            surface.SetMaterial(crouchLight)
        else
            surface.SetMaterial(crouch)
        end

        surface.DrawTexturedRect(batteryx, h - h2 * 1.3, w2, h2)
    end

    function ENT:PossessorView()
        local pos, ang = self.BaseTable.PossessorView(self)

        if self:GetNWBool('CustomPossessorJumpscare') then
            local ent = self:GetNWEntity('PossessionJumpscareEntity')

            if IsValid(ent) then
                local attach = ent:GetAttachment(ent:LookupAttachment('Jumpscare_jnt'))

                pos = attach.Pos
                ang = attach.Ang + AngleRand(-0.35,0.35)
            end
        end

        if self:GetNWBool('CustomPossessorCam') then
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