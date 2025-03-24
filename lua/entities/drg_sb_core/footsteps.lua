    -- Footstep Code

    local footsteps5walk = {
        -- Concrete
        [67] = 'whynotboi/securitybreach/base/bot/footsteps/walk/concete/fly_bot_concrete_walk_0',

        -- Dirt
        [85] = 'whynotboi/securitybreach/base/bot/footsteps/walk/dirt/fly_bot_dirt_walk_0',
        [78] = 'whynotboi/securitybreach/base/bot/footsteps/walk/dirt/fly_bot_dirt_walk_0',
        [68] = 'whynotboi/securitybreach/base/bot/footsteps/walk/dirt/fly_bot_dirt_walk_0',

        -- Metal
        [77] = 'whynotboi/securitybreach/base/bot/footsteps/walk/metal/fly_bot_metal_walk_0',
    }
   
    local footsteps6walk = {
        -- HardTile
        [84] = 'whynotboi/securitybreach/base/bot/footsteps/walk/hardtile/fly_bot_hardTile_walk_0',
        [89] = 'whynotboi/securitybreach/base/bot/footsteps/walk/hardtile/fly_bot_hardTile_walk_0',
   
        -- Carpet
        [74] = 'whynotboi/securitybreach/base/bot/footsteps/walk/carpet/fly_bot_carpet_walk_0',

        -- Wood
        [87] = 'whynotboi/securitybreach/base/bot/footsteps/walk/wood/fly_bot_wood_walk_0',

        -- Vent
        [86] = 'whynotboi/securitybreach/base/bot/footsteps/walk/vent/fly_bot_vent_walk_0',
        [71] = 'whynotboi/securitybreach/base/bot/footsteps/walk/vent/fly_bot_vent_walk_0'
    }

    local footstepsrun = {
        -- Concrete
        [67] = 'whynotboi/securitybreach/base/bot/footsteps/run/concrete/fly_bot_concrete_run_0',

        -- Dirt
        [85] = 'whynotboi/securitybreach/base/bot/footsteps/run/dirt/fly_bot_dirt_run_0',
        [78] = 'whynotboi/securitybreach/base/bot/footsteps/run/dirt/fly_bot_dirt_run_0',
        [68] = 'whynotboi/securitybreach/base/bot/footsteps/run/dirt/fly_bot_dirt_run_0',

        -- HardTile
        [84] = 'whynotboi/securitybreach/base/bot/footsteps/run/hardtile/fly_bot_hardTile_run_0',
        [89] = 'whynotboi/securitybreach/base/bot/footsteps/run/hardtile/fly_bot_hardTile_run_0',
   
        -- Carpet
        [74] = 'whynotboi/securitybreach/base/bot/footsteps/run/carpet/fly_bot_carpet_run_0',

        -- Wood
        [87] = 'whynotboi/securitybreach/base/bot/footsteps/run/wood/fly_bot_wood_run_0',

        -- Metal
        [77] = 'whynotboi/securitybreach/base/bot/footsteps/run/metal/fly_bot_metal_run_0',

        -- Vent
        [86] = 'whynotboi/securitybreach/base/bot/footsteps/walk/vent/fly_bot_vent_walk_0',
        [71] = 'whynotboi/securitybreach/base/bot/footsteps/walk/vent/fly_bot_vent_walk_0'
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

        local path = footsteps5walk[material] or footsteps6walk[material]

        local num = 5

        if footsteps6walk[material] then
            num = 6
        end

        if self:IsRunning() then
            path = footstepsrun[material]

            num = 6
        end

        if path then
            self:EmitSound(path .. math.random(num) .. '.wav')
        end
    end