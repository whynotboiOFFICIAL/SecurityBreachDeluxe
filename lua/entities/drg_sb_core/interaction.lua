function ENT:DoorCode(door)
    if self.DoorDelay then return end
    
    local range = 40

    if self:IsPossessed() then
        range = 60 
    end

    for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), range)) do
        if not IsValid(v) or v == self or self.DisableControls then continue end
        local classname = v:GetClass()
        
        local propDoor = classname == 'prop_door_rotating'
        local funcDoor = classname == 'func_door_rotating'
        
        local freddy = (classname == 'drg_sb_glamrockfreddy' and self:IsPossessed())
        local mapBot = (classname == 'drg_sb_staffbot_map' and v.OfferingMap and self:IsPossessed())

        local hidingSpot = (v.SBHidingSpot and self:IsPossessed())
        local distraction = (v.SBDistraction and self:IsPossessed())
        local rechargeStation = (classname == 'sb_entities_rechargestation' and self:IsPossessed() and self:GetClass() == 'drg_sb_glamrockfreddy')

        if (propDoor or funcDoor) then
            local toggle
            
            if propDoor then
                if v:GetInternalVariable('m_eDoorState') == 0 then
                    if v:GetInternalVariable('m_bLocked') then
                        if self.BreakDoor then
                            self:FaceInstant(v:WorldSpaceCenter())
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
                            self:FaceInstant(v:WorldSpaceCenter())
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
                end

            if not v:GetInternalVariable('m_bLocked') then
                v:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
            end
            
            self.DoorDelay = true
            
            self:DrG_Timer(0.8, function()
                if v:IsValid() then
                    v:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
                end
                
                self.DoorDelay = nil
            end)

                break
            end
        end

        if (freddy or mapBot or hidingSpot or distraction) then
            if self:GetClass() ~= 'drg_sb_gregory' then continue end

            v:Use(self)

            if mapBot then
                self:DrG_Timer(math.random(3,6), function()
                    if not self.HasMap then
                        self.HasMap = true

                        self:PlayVoiceLineSingular('GREGORY_00128b')
                    end
                end)
            end
        end
        
        if (rechargeStation) then
            v:Use(self)
        end
    end
end
