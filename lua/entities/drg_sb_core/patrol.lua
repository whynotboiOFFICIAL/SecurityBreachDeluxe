function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(3, 7))
end 

function ENT:OnPatrolling(pos)
    self:DoorCode()  
end

function ENT:OnIdle()
    if IsValid(self.InvestigatingSpot) then
        local spot = self.InvestigatingSpot

        local tosearch = spot.SpotID

        local offset = self.HidingSpotOffsets[tosearch] or 55

        self:SetPos(spot:GetPos() + spot:GetForward() * offset)

        self:FaceInstant(spot)

        local searchid = self.SearchID or 'monty'

        spot:SearchSpot(searchid)

        if self.SearchID then
            self:PlaySequenceAndMove(('search' .. tosearch), nil, function()
                if self._InterruptSeq then 
                    return true 
                end
            end)
        else
            self:Wait(3)

            if not IsValid(spot) then return end

            local ent = spot.Occupant

            if not IsValid(ent) then return end

            spot:ForceEject(ent)
            
            self:JumpscareEntity(ent)
        end

        self.InvestigatingSpot = nil
    end
    
    self:AddPatrolPos(self:RandomPos(1500))
end
