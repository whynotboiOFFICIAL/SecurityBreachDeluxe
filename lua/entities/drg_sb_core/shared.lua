if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = 'drgbase_nextbot' -- DO NOT TOUCH (obviously)

-- I updated it again

-- Misc --
ENT.RagdollOnDeath = true

-- Speed --
ENT.UseWalkframes = true

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 30
ENT.RangeAttackRange = 600
ENT.MeleeAttackRange = 60
ENT.ReachEnemyRange = 60
ENT.AvoidEnemyRange = 0

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

include('sound.lua')

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

if SERVER then

    include('possession.lua')
    include('walkframe.lua')
    include('footsteps.lua')
    include('patrol.lua')
    include('chase.lua')
    include('doors.lua')
    --include('crawling.lua')
    include('jumpscare.lua')

    -- Basic

    function ENT:_BaseInitialize()
        self.Width = self:BoundingRadius() * 0.1
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

    function ENT:CustomThink()
        if self.AddCustomThink then
            self:AddCustomThink()
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
                if (v == self or v == self:GetPossessor()) or (v.IsDrGNextbot and v:IsInFaction('FACTION_ANIMATRONIC')) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and IsValid(v:DrG_GetPossessing())) or v:Health() < 1 then continue end
                self:CallInCoroutine(function(self,delay)
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
    
    function ENT:LayerBlend(id, rate)
        self:SetLayerWeight(id, 0)

        local name = self:timerName('drgblendin')

        timer.Create( name, 0, rate, function()  
            if not IsValid(self) then return end
            
            self:SetLayerWeight(id, self:GetLayerWeight(id) + (1 / rate))
        end)
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

        local soundDictionary = self.AnimEventSounds

        if soundDictionary then
            for name in pairs(soundDictionary) do
                self:StopAnimSounds(name, false)
            end
        end

        self:CancelJumpscare()
    end

    -- EventFrames

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

        if e == 'step' and self.StepSFX then
            self:StepSFX() 
            self:MatStepSFX()
        end

        if self.CustomAnimEvents then
            self:CustomAnimEvents(e)
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

        if self.AimTarget ~= nil and not self.AimDisabled  then
            self:SmoothDirectPoseParametersAt(self.AimTarget, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter(), 8)
        elseif self.AimTarget == nil then
            self:SmoothDirectPoseParametersAt(self:WorldSpaceCenter() + self:GetForward() * 1, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter(), 3)
        end
    end

    function ENT:OnNewEnemy(ent)
        if self.OnSpotEnemy then
            self:OnSpotEnemy(ent)
        end

        self:CallOnClient('OnEnemySpotted', ent)
    end

    function ENT:OnLastEnemy(ent)
        if self.OnLoseEnemy then
            self:OnLoseEnemy(ent)
        end
    end

    function ENT:EnterCinematic(ent)
        ent:Freeze(true)
        ent:AddFlags(FL_NOTARGET)
        ent:DrawViewModel(false)
        ent:SetActiveWeapon(nil)
    
        net.Start('SECURITYBREACHFINALLYCINEMATIC')
        net.WriteEntity(self)
        net.WriteBool(true)
        net.Send(ent)
    
        self.CinTarget = ent
    end
    
    function ENT:ExitCinematic(ent)
        net.Start('SECURITYBREACHFINALLYCINEMATIC')
        net.WriteEntity(self)
        net.WriteBool(false)
        net.Send(ent)
    
        ent:RemoveFlags(FL_NOTARGET)
        ent:Freeze(false)
        ent:DrawViewModel(true)
    
        self.CinTarget = nil
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