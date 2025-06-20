if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drgbase_nextbot' -- DO NOT TOUCH (obviously)

ENT.RagdollOnDeath = true

-- Speed --
ENT.UseWalkframes = false
ENT.WalkSpeed = 60
ENT.RunSpeed = 200

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 30
ENT.RangeAttackRange = 150
ENT.MeleeAttackRange = 60
ENT.ReachEnemyRange = 60
ENT.AvoidEnemyRange = 0

-- Detection --
ENT.EyeBone = 'Head_jnt'
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 60
ENT.SightRange = 1600
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

-- Relationships --
ENT.Factions = {'FACTION_ANIMATRONIC'}
ENT.Frightening = true
ENT.DefaultRelationship = D_HT
ENT.AllyDamageTolerance = 0
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

-- Locomotion --
ENT.Acceleration = 2000
ENT.Deceleration = 2000
ENT.JumpHeight = 50
ENT.StepHeight = 20
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionPrompt = true
ENT.PossessionCrosshair = false
ENT.PossessionMovement = POSSESSION_MOVE_CUSTOM

ENT.StoredPlayerWeapon_Freddy = nil

ENT.PossessionBinds = {
    [IN_JUMP] = {{
        coroutine = false,
        onkeydown = function(self)
        end
    }},
    
    [IN_ATTACK] = {{
        coroutine = true,
        onkeydown = function(self)
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

ENT.HidingSpotOffsets = {
    ['cart'] = 55,
    ['firstaid'] = 70,
    ['kiosk'] = 60,
    ['locker'] = 55,
    ['photobooth'] = 65,
    ['servicecart'] = 55,
}

include('sound.lua')
include('possession.lua')

if SERVER then

    include('movement.lua')
    include('footsteps.lua')
    include('patrol.lua')
    include('chase.lua')
    include('interaction.lua')
    include('jumpscare.lua')

    -- Basic

    function ENT:_BaseInitialize()
        self:SetNWBool('HUDEnabled', GetConVar('fnaf_sb_new_possessionhud'):GetBool())

        self.WalkMultiplier = GetConVar('fnaf_sb_new_multiplier_walkspeed'):GetFloat()
        self.RunMultiplier = GetConVar('fnaf_sb_new_multiplier_runspeed'):GetFloat()

        self.PounceUpMultiplier = GetConVar('fnaf_sb_new_multiplier_pounceup'):GetFloat()
        self.PounceForwardMultiplier = GetConVar('fnaf_sb_new_multiplier_pounceforward'):GetFloat()

        self:SetSightRange(1600 * GetConVar('fnaf_sb_new_multiplier_sightrange'):GetFloat())

        self.Width = self:BoundingRadius() * 0.1

        self.DamageTolerance = 0
    end

    function ENT:CustomThink()
        if self.AddCustomThink then
            self:AddCustomThink()
        end

        if self.ForceRun and not self.Stunned then
            self:OnPatrolling()
        end

        if self.VoiceThink then
            self:VoiceThink()
        end

        if self.LockAim then
            local ent = self:GetEnemy()

            if IsValid(ent) then
                self:FaceInstant(ent)
            else
                self.LockAim = false
            end
        end

        if self.Pouncing and not self.PounceTick then
            self.PounceTick = true

            for k,v in ipairs(ents.FindInSphere(self:WorldSpaceCenter(), 60)) do
                if v == self or v == self:GetPossessor() then continue end
                if self.Stunned then continue end
                if (v:IsPlayer() and self:GetIgnorePlayers() or self:GetAIDisabled()) then continue end
                if (v:IsPlayer() and IsValid(v:DrG_GetPossessing())) or (v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC')) or v:Health() < 1 then continue end
                if IsValid(v:GetNWEntity('2PlayFreddy')) or IsValid(v:GetNWEntity('HidingSpotSB')) then continue end
                if not (v:IsPlayer() or v:IsNextBot() or v:IsNPC()) then continue end
                
                self:CallInCoroutine(function(self, delay)
                    self:JumpscareEntity(v)
                end)
            end

            self:DrG_Timer(0.1, function()
                self.PounceTick = false
            end)
        end

        if self:IsMoving() and self.Moving then
            if self.CurrentFoot == 1 then
                if self:IsRunning() then
                    self.ToStopAnim = 'runtostopl'
                else
                    self.ToStopAnim = 'walktostopl'
                end
            elseif self.CurrentFoot == 2 then
                if self:IsRunning() then
                    self.ToStopAnim = 'runtostopr'
                else
                    self.ToStopAnim = 'walktostopr'
                end
            end
        end

        if not self:IsMoving() and self.Moving then
            self.Moving = false
            self.IdleAnimation = self.ToStopAnim
        end
    end
    
    -- Returns

    function ENT:EntityInaccessible(ent)
        if ent == self or ent == self:GetPossessor() then return true end
        if self.Stunned or self.PounceStarted or self:IsPossessed() then return true end
        if self:GetAIDisabled() or (ent:IsPlayer() and self:GetIgnorePlayers()) then return true end
        if (ent:IsPlayer() and IsValid(ent:DrG_GetPossessing())) or (ent.IsDrGNextbot and ent:IsInFaction('FACTION_ANIMATRONIC')) or ent:Health() < 1 then return true end
        if IsValid(ent:GetNWEntity('2PlayFreddy')) or IsValid(ent:GetNWEntity('HidingSpotSB')) then return true end
        if not (ent:IsPlayer() or ent:IsNextBot() or ent:IsNPC()) then return true end
    end

    function ENT:IsBeingLookedAt()
        local players = player.GetHumans()
        local isBeingLookedAt = false
    
        for i = 1, #players do
            local ply = players[i]
    
            if self:GetPossessor() ~= ply then
                local tr = util.TraceLine{
                    start = self:GetPos(),
                    endpos = ply:WorldSpaceCenter(),
                    mask = 1,
                    filter = function(self)
                        return not self:IsNextBot() and not self:IsNPC()
                    end
                }
                
                if tr.Fraction < 1 or tr.Fraction > 0.1 then
                    local viewEntity = ply:GetViewEntity()
    
                    if viewEntity:IsValid() then
                        local fov = ply:GetFOV()
                        local disp = (self:GetPos() - viewEntity:GetPos())
                        local dist = disp:Length()
                        local maxcos = math.abs(math.cos(math.acos(dist / math.sqrt(dist * dist + self.Width * self.Width)) + fov * (math.pi / 180)))
                        
                        if disp:GetNormalized():Dot(ply:EyeAngles():Forward()) > maxcos then
                            isBeingLookedAt = true
                            break
                        end
                    end
                end
            end
        end
    
        return isBeingLookedAt
    end

    function ENT:BeingFlashed()
        local players = player.GetHumans()
        local isBeingFlashed = false
    
        for i = 1, #players do
            local ply = players[i]
            local nextbot = ply:DrG_GetPossessing()
                
            if self:GetPossessor() ~= ply then
                local ent = ply:GetEyeTrace().Entity
                local poslight = false

                if IsValid(nextbot) and nextbot.LightOn then
                    poslight = true
                end

                if ent == self and (ply:FlashlightIsOn() or poslight) then
                    isBeingFlashed = true
                end
            end
        end
    
        return isBeingFlashed
    end

    local ai_ignoreplayers = GetConVar('ai_ignoreplayers')
    local ai_disabled = GetConVar('ai_disabled')

    function ENT:GetAIDisabled()
        return ai_disabled:GetBool()
    end

    function ENT:GetIgnorePlayers()
        return ai_ignoreplayers:GetBool()
    end

    function ENT:timerName(name)
        local timname = name
    
        while timer.Exists(timname) do
            timname = timname .. '1'
        end
    
        return timname
    end

    function ENT:SBTimer(delay, func)
        local cancelled = false
    
        timer.Simple(delay, function()
            if not cancelled and self:IsValid() then
                func(self)
            end
        end)
    
        return function() cancelled = true end
    end

    function ENT:LayerBlend(id, rate, out)
        if out then
            self:SetLayerWeight(id, 1)
        else
            self:SetLayerWeight(id, 0)
        end

        local name = self:timerName('drgblendin')

        timer.Create( name, 0, rate, function()  
            if not IsValid(self) then return end
            
            if out then
                self:SetLayerWeight(id, self:GetLayerWeight(id) - (1 / rate))
            else
                self:SetLayerWeight(id, self:GetLayerWeight(id) + (1 / rate))
            end
        end)
    end

    -- Eventframes

    function ENT:HandleAnimEvent(a,b,c,d,e)
        if string.sub(e, 1, 4) == 'sfx_' then
            local name = string.sub(e, 5)
            local isEnd, endPos = string.find(name, 'end_')

            if isEnd then
                name = string.sub(name, endPos + 1)
            end

            self:HandleAnimSound(name, isEnd and true or false)
        elseif e == 'stopsounds' then
            local soundDictionary = self.AnimEventSounds

            if soundDictionary then
                for name in pairs(soundDictionary) do
                    self:StopAnimSounds(name, true)
                end
            end
        end

        if string.sub(e, 1, 7) == 'turneye' then
            local toturn = string.sub(e, 8, 10)

            self.EyeAngle = Angle(0, toturn, 0)
        end

        if e == 'step' and self.StepSFX then
            self:StepSFX() 
            self:MatStepSFX()
        end

        if self.CustomAnimEvents then
            self:CustomAnimEvents(e)
        end

        if e == 'search' then
            local spot = self.InvestigatingSpot
            
            if not IsValid(spot) then return end

            local ent = spot.Occupant

            if not IsValid(ent) then return end

            spot:ForceEject(ent)

            self._InterruptSeq = true

            self:CallInCoroutine(function(self,delay)
                self:JumpscareEntity(ent)
            end)

            self.InterruptSeq = false
        end

        if e == 'onlleg' then
            self.CurrentFoot = 1

            if not self.Moving then
                self.Moving = true
            end
        end

        if e == 'onrleg' then
            self.CurrentFoot = 2

            if not self.Moving then
                self.Moving = true
            end
        end

        if self:GetClass() == 'drg_sb_daycareattendant' then return end
        
        if e == 'toidle' then
            self.IdleAnimation = 'idle'
        end
    end

    -- Aim

    function ENT:SmoothDirectPoseParametersAt(pos, pitch, yaw, center, speed)
        if not isstring(yaw) then
            return self:SmoothDirectPoseParametersAt(pos, pitch.."_pitch", pitch.."_yaw", yaw, speed)
        elseif isentity(pos) then pos = pos:WorldSpaceCenter() end
        if isvector(pos) then
            center = center or self:WorldSpaceCenter()
            local angle = (pos - center):Angle()
  
            local currentPitch = self:GetPoseParameter(pitch) or 0
            local currentYaw = self:GetPoseParameter(yaw) or 0

            local targetPitch = math.AngleDifference(angle.p, self:GetAngles().p)
            local targetYaw = math.AngleDifference(angle.y, self:GetAngles().y)

            local smoothPitch = Lerp(FrameTime() * speed, currentPitch, targetPitch)
            local smoothYaw = Lerp(FrameTime() * speed, currentYaw, targetYaw)
  
            self:SetPoseParameter(pitch, smoothPitch)
            self:SetPoseParameter(yaw, smoothYaw)
        else
            self:SetPoseParameter(pitch, 0)
            self:SetPoseParameter(yaw, 0)
        end
    end
    

    function ENT:AimControl()
        --local transitionProgress = math.Clamp((CurTime() - self.TransitionStart) / 0.1, 0, 1)

        --local lerped = LerpVector(transitionProgress, self:WorldSpaceCenter(), self.AimTarget)

        local target = self.AimTarget

        if IsValid(target) then
            if target:IsPlayer() then
                target = target:EyePos() - Vector(0, 0, 30)
            elseif target.IsDrGNextbot then
                local eyebone = target:LookupBone(target.EyeBone)

                target = target:WorldSpaceCenter() - Vector(0, 0, 20)
            end
        end

        if IsValid(self.AimTarget) and not self.AimDisabled  then
            self:SmoothDirectPoseParametersAt(target, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter(), 8)
        else
            self:SmoothDirectPoseParametersAt(self:WorldSpaceCenter() + self:GetForward() * 1, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter(), 3)
        end
    end

    -- Cinematic

    function ENT:EnterCinematic(ent)
        if ent:IsPlayer() then
            ent:Freeze(true)
            ent:DrawViewModel(false)
            self.StoredPlayerWeapon_Freddy = IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon() or nil
            ent:CrosshairDisable()
            ent:SetActiveWeapon(nil)

            net.Start('SECURITYBREACHFINALLYCINEMATIC')
            net.WriteEntity(self)
            net.WriteBool(true)
            net.Send(ent)
        else
            if ent.DoPossessorJumpscare then
                ent:SetNoDraw(true)
        
                ent:SetNWBool('CustomPossessorCam', true)
                ent:SetNWEntity('PossessionCinematicEntity', self)
            end

            ent:NextThink(CurTime() + 1e9)
        end
    
        ent:AddFlags(FL_NOTARGET)
        
        self.CinTarget = ent
    end
    
    function ENT:ExitCinematic(ent)
        if not IsValid(ent) then return end
        
        ent:RemoveFlags(FL_NOTARGET)

        if ent:IsPlayer() then
            net.Start('SECURITYBREACHFINALLYCINEMATIC')
            net.WriteEntity(self)
            net.WriteBool(false)
            net.Send(ent)
        
            ent:Freeze(false)
            ent:DrawViewModel(true)
        else
            if ent.DoPossessorJumpscare then
                ent:SetNoDraw(false)
        
                ent:SetNWBool('CustomPossessorCam', false)
                ent:SetNWEntity('PossessionCinematicEntity', nil)
            end

            ent:NextThink(CurTime())
        end

        self.CinTarget = nil
    end

    -- Damage
       
    function ENT:DoStunned()
        if self.Stunned or self.StunDelay or self.PounceStarted or self.StunDisabled then return end
        
        self.Moving = false

        if self.OnStunned then
            self:OnStunned()
        end

        self.DisableControls = true
        self.VoiceDisabled = true
        self._InterruptSeq = true
        self.Stunned = true
        self.NullifyVoicebox = true

        self:SetAIDisabled(true)
        
        if not self.CustomStunSFX then
            self:EmitSound('whynotboi/securitybreach/base/bot/stunned/sfx_bot_status_stunned_lp_0' .. math.random(4) .. '.wav', 75, 100, 0.5)
        end

        self:DrG_Timer(10, function()
            for i = 1, 4 do
                self:StopSound('whynotboi/securitybreach/base/bot/stunned/sfx_bot_status_stunned_lp_0' .. i .. '.wav')
            end

            if self.OnStunExit then
                self:OnStunExit()
            end

            self.DisableControls = false
            self.Stunned = false
            self.NullifyVoicebox = false
            self._InterruptSeq = false

            if not self:HasEnemy() then
                self.VoiceDisabled = false
            end

            self:SetAIDisabled(false)

            self.StunDelay = true

            self:DrG_Timer(1, function()
                self.StunDelay = false
            end)
        end)
    end

    function ENT:OnTakeDamage(dmg)
        self:SpotEntity(dmg:GetAttacker())

        if not self.GradualDamaging or self:GetSkin() == 3 then return end

        local num = dmg:GetDamage()
        
        self.DamageTolerance = self.DamageTolerance + num

        if self.DamageTolerance > 400 then
            self.DamageTolerance = 0 

            self:SetSkin(self:GetSkin() + 1)
        end
    end

    function ENT:OnDeath()
        if not self.GradualDamaging then return end

        self:SetSkin(3)
    end

    function ENT:OnRemove()
        if self.Removed then
            self:Removed()
        end

        if self.StopVoices then
            self:StopVoices()
        end

        if self.CinTarget then
            self:ExitCinematic(self.CinTarget)
        end

        for i = 1, 4 do
            self:StopSound('whynotboi/securitybreach/base/bot/stunned/sfx_bot_status_stunned_lp_0' .. i .. '.wav')
        end

        local soundDictionary = self.AnimEventSounds

        if soundDictionary then
            for name in pairs(soundDictionary) do
                self:StopAnimSounds(name, false)
            end
        end

        self:CancelJumpscare()
    end

else
    function ENT:CustomInitialize() 
        self.BaseTable = scripted_ents.GetStored("drgbase_nextbot").t
    end

    function ENT:CustomThink() 
    end

    function ENT:CustomDraw() 

    end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)