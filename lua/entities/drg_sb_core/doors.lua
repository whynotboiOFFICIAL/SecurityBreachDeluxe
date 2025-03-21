function ENT:DoorCode(door)
    if self.DoorDelay then return end
    for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 60)) do
        if not IsValid(v) then continue end
        local classname = v:GetClass()
        
        local propDoor = classname == 'prop_door_rotating'
        local funcDoor = classname == 'func_door_rotating'
        
        if (propDoor or funcDoor) then
            local toggle
            
            if propDoor then
                if v:GetInternalVariable('m_eDoorState') == 0 then
                    if v:GetInternalVariable('m_bLocked') then
                        if self.BreakDoor then
                            self:FaceInstant(v)
                            self.Breaking = v
                            self:BreakDoor(v)
                        end
                    else
                        v:Fire('OpenAwayFrom', self:GetName())
                    end
                    
                    toggle = 1
                else
                    toggle = 0
                end
            elseif funcDoor then
                if v:GetInternalVariable('m_toggle_state') == 1 then
                    if v:GetInternalVariable('m_bLocked') then
                        if self.BreakDoor then
                            self:FaceInstant(v)
                            self.Breaking = v
                            self:BreakDoor(v)
                        end
                    else
                        v:Fire('Open')
                    end
                    
                    toggle = 1
                else
                    toggle = 0
                end
            end
            if not IsValid(v) then continue end
            if toggle then
                if toggle == 0 then
                    if self:IsPossessed() then
                        v:Fire('Close')
                    end
                elseif not self.Charging then
                end
                
                if not v:GetInternalVariable('m_bLocked') then
                    v:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                end
                
                self.DoorDelay = true
                
                self:DrG_Timer(0.5, function()
                    if v:IsValid() then
                        v:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
                    end
                    
                    self.DoorDelay = nil
                end)
                
                break
            end
        end
    end
end
