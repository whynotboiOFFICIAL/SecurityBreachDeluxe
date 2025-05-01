if SERVER then
    function ENT:Turn(pos, subs)
        if self:IsDown() or self.DisableControls then return end

        local direction = self:CalcPosDirection(pos, subs)
        if direction == 'W' then
            self.LastTurn = CurTime()
        elseif direction == 'E' then
            self.LastTurn = CurTime()
        elseif direction == 'S' and math.random(2) == 1 then
            self.LastTurn = CurTime()
        elseif direction == 'S' then
            self.LastTurn = CurTime()
        end
    end

    function ENT:PossessionControls(forward, backward, right, left)
        if self:IsDown() or self.DisableControls then return end
        
        local direction = self:GetPos()

        if forward then direction = direction + self:PossessorForward()
        elseif backward then direction = direction - self:PossessorForward() end

        if right then direction = direction + self:PossessorRight()
        elseif left then direction = direction - self:PossessorRight() end

        if direction ~= self:GetPos() then
            self:Turn(direction, true)
            self:MoveTowards(direction)
        end
    end
end

if CLIENT then
    function ENT:PossessorView()
        local pos, ang = self.BaseTable.PossessorView(self)

        if self:GetNWBool('UseHeadAttach') then
            local head = self:GetAttachment(self:LookupAttachment('HeadCam'))

            pos = head.Pos + Vector(0, 0, 3)
            ang = head.Ang + Angle(ang.p, 0, 0)
        end

        return pos, ang
    end
end

AddCSLuaFile()