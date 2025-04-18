
function ENT:OpenChestHatch()
    self.OpenChest = true

    self:StopSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav')
    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav', 75, 100, 0.5)

    self:AddGestureSequence(21, false)
end

function ENT:CloseChestHatch()
    self.OpenChest = false

    self:StopSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav')
    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav', 75, 100, 0.5)

    self:RemoveAllGestures()

    self:PlaySequence('closechest')
end

function ENT:ForceLose(ent)
    for k, v in ipairs( ents.GetAll() ) do
        if v.IsDrGNextbot then
            v:LoseEntity(ent)

            v:SetEntityRelationship(ent, D_LI)

            self:DrG_Timer(1, function()
                if not IsValid(v) then return end
                
                v:SetEntityRelationship(ent, D_HT)
            end)
        end
    end
end

function ENT:EnterFreddy(ent)
    if not self.OpenChest then return end

    self.OpenChest = false
    self.Inhabited = true
    self.DisableControls = true

    self:DirectPoseParametersAt(nil, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter())
    
    self:DrG_Timer(0, function()
        self:FaceInstant(ent)
        
        self:EnterCinematic(ent)

        self:RemoveAllGestures()
            
        self:PlaySequence('enterfreddy')

        ent:EmitSound('whynotboi/securitybreach/base/gregory/enterfreddy/fly_gregory_freddy_enter_0' .. math.random(1,5) .. '.wav')
        
        self:DrG_Timer(3, function()
            self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav', 75, 100, 0.5)
        end)

        self:DrG_Timer(4.3, function()
            self:ExitCinematic(ent)

            if ent:IsPlayer() then
                ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.8, 0 )
            end
            
            self:InitChestControls(ent)

            self.DisableControls = false
        end)
    end)
end

function ENT:ExitFreddy(ent)

    local oldent = ent

    if IsValid(self.HoldEntity) then
        ent = self.HoldEntity

        self.HoldEntity = nil
    end

    if ent:IsPlayer() then
        ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.8, 0 )
    end

    if IsValid(self.PlayerInside) then
        ent:SetNWBool('InFreddy2Play', false)
        ent:SetNWEntity('2PlayFreddy', nil)
    
        self.PlayerInside = nil
    else
        self:Dispossess()
    end

    if ent.IsDrGNextbot then
        ent:SetNoDraw(false)
        ent:SetAIDisabled(false)

        ent:SetCollisionGroup(9)

        ent.DisableControls = false

        ent:Possess(oldent)
    end

    self.WalkAnimation = 'walk'
    self.RunAnimation = 'run'
    self.PossessionMovement = POSSESSION_MOVE_CUSTOM
    self.DisableControls = true

    ent:SetPos(self:GetPos() + self:GetForward() * 35)

    ent:SetAngles(self:GetAngles())

    self:RemoveAllGestures()
        
    self:EnterCinematic(ent)

    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav', 75, 100, 0.5)

    self:AddGestureSequence(24, false)

    ent:EmitSound('whynotboi/securitybreach/base/gregory/exitfreddy/fly_gregory_freddy_exit_0' .. math.random(1,5) .. '.wav')

    self:DrG_Timer(2.5, function()
        self.Inhabited = false
        self.OpenChest = true
        self.DisableControls = false

        self:ExitCinematic(ent)

        ent:RemoveFlags(FL_NOTARGET)
        
        self:ForceLose(ent)
    end)
end

function ENT:InitChestControls(ent)
    self.WalkAnimation = 'jog'
    self.RunAnimation = 'jog'

    self.PossessionMovement = POSSESSION_MOVE_4DIR

    self:SetNWBool('UseHeadAttach', true)

    local oldent = ent

    if ent.IsDrGNextbot then
        ent:SetNoDraw(true)
        ent:SetAIDisabled(true)

        ent:SetCollisionGroup(10)

        ent.DisableControls = true

        self.HoldEntity = ent

        if ent:IsPossessed() then
            ent = ent:GetPossessor()

            self.BackupEnt = ent

            oldent:Dispossess()
        end
    end

    self:DrG_Timer(0, function()
        if not self:IsPossessed() then
            self:Possess(ent)
        else
            self:SecondaryInit(oldent, ent)
        end
    end)
end

function ENT:SecondaryInit(ent, ply)
    if not IsValid(ply) then
        ply = ent
    end

    if ply:IsPlayer() then
        ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
        ply:SetNoTarget(true)
        ply:SetNoDraw(true)
        ply:Freeze(true)
        ply:Flashlight(false)
        ply:AllowFlashlight(false)
        ply:SetEyeAngles(self:EyeAngles())
        ply:Give('drgbase_possession')
        ply:SpectateEntity(self)
        
        ply:SetNWEntity('2PlayFreddy', self)
        ply:SetNWBool('InFreddy2Play', true)

        self:DrG_Timer(0.1, function()
            if not IsValid(ply) then return end
            ply:StripWeapon('drgbase_possession')
        end)
    end

    self.PlayerInside = ply
    self.HoldEntity = ent
end

function ENT:DeinitSecondary(ent)

    local ply = ent
    
    if ply:IsPlayer() then
        ply:SetCollisionGroup(5)
        ply:SetNoTarget(false)
        ply:SetNoDraw(false)
        ply:Freeze(false)
        ply:Flashlight(false)
        ply:AllowFlashlight(true)
        ply:UnSpectate()
    end
    
    if IsValid(self) then
        self:ExitFreddy(ply)

        self:SetNWBool('UseHeadAttach', false)
    end
end