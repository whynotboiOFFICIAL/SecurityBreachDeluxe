    -- Footstep Code

    local footsteps6walk = {
        -- Concrete
        [67] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/concrete/fly_vanessa_concrete_walk_0',
        
        -- HardTile
        [84] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/hardtile/fly_vanessa_hardTile_walk_0',
        [89] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/hardtile/fly_vanessa_hardTile_walk_0.wav'
    }
   
    local footsteps7walk = {
        -- Metal
        [77] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/metal/fly_vanessa_metal_walk_0',
        [86] = 'whynotboi/securitybreach/base/bot/footsteps/walk/vent/fly_bot_vent_walk_0',
        [71] = 'whynotboi/securitybreach/base/bot/footsteps/walk/vent/fly_bot_vent_walk_0'        
    }
   
    local footsteps8walk = {
        -- Carpet
        [74] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/carpet/fly_vanessa_carpet_walk_0',

        -- Dirt
        [85] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/dirt/fly_vanessa_dirt_walk_0',
        [78] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/dirt/fly_vanessa_dirt_walk_0',
        [68] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/dirt/fly_vanessa_dirt_walk_0',
   
        -- Wood
        [87] = 'whynotboi/securitybreach/base/vanessa/footsteps/walk/wood/fly_vanessa_wood_walk_0'
    }

    local footsteps6run = {
        -- Wood
        [87] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/wood/fly_vanessa_wood_run_0'
    }

    local footsteps7run = {
        -- Carpet
        [74] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/carpet/fly_vanessa_carpet_run_0'
    }

    local footsteps8run = {
        -- Concrete
        [67] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/concrete/fly_vanessa_concrete_run_0',

        -- Dirt
        [85] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/dirt/fly_vanessa_dirt_run_0',
        [78] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/dirt/fly_vanessa_dirt_run_0',
        [68] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/dirt/fly_vanessa_dirt_run_0',

        -- HardTile
        [84] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/hardtile/fly_vanessa_hardTile_run_0',
        [89] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/hardtile/fly_vanessa_hardTile_run_0',

        -- Metal
        [77] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/metal/fly_vanessa_metal_run_0',
        [86] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/metal/fly_vanessa_metal_run_0',
        [71] = 'whynotboi/securitybreach/base/vanessa/footsteps/run/metal/fly_vanessa_metal_run_0'
    }

    function ENT:MaterialCheck()
        if IsValid(self) then
            local tr = util.TraceLine({
                start = self:GetPos(),
                endpos = self:GetPos()+Vector(0,0,-self.StepHeight),
                ignoreworld = false,
                filter = function(ent)
                    if(not IsValid(ent)||ent==NULL||ent:IsWorld()) then
                        //	return true
                    end
                end
            })
            return tr.MatType
        end
    end

    function ENT:MatStepSFX()
        if self.DisableMat or self.IsFrozen then return end
        
        local material = self:MaterialCheck()

        if not material then return end

        local path = footsteps6walk[material]

        local num = 6

        if self:IsRunning() then
            path = footsteps6run[material] or footsteps7run[material] or footsteps8run[material]

            if footsteps7run[material] then
                num = 7
            end
    
            if footsteps8run[material] then
                num = 8
            end
        else         
            path = footsteps6walk[material] or footsteps7walk[material] or footsteps8walk[material]

            if footsteps7walk[material] then
                num = 7
            end

            if footsteps8walk[material] then
                num = 8
            end
        end

        if path then
            self:EmitSound(path .. math.random(num) .. '.wav', 75, 100, 0.5)
        end
    end