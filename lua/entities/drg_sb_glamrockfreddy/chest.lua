
function ENT:OpenChestHatch()
    self.OpenChest = true

    self:StopSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav')
    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav', 75, 100, 0.5)

    self:CallInCoroutine(function(self,delay)
        self:AddGestureSequence(20, false)
    end)
end

function ENT:CloseChestHatch()
    self.OpenChest = false

    self:StopSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav')
    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav', 75, 100, 0.5)

    self:CallInCoroutine(function(self,delay)
        self:RemoveAllGestures()

        self:PlaySequence('closechest')
    end)
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

function ENT:ForceLose(ent)
    for k, v in ipairs( ents.GetAll() ) do
        if v.IsDrGNextbot then
            v:LoseEntity(ent)

            v:SetEntityRelationship(ent, D_LI)

            self:DrG_Timer(1, function()
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

        self:CallInCoroutine(function(self,delay)
            self:RemoveAllGestures()
            
            self:PlaySequence('enterfreddy')
        end)

        ent:EmitSound('whynotboi/securitybreach/base/gregory/enterfreddy/fly_gregory_freddy_enter_0' .. math.random(1,5) .. '.wav')
        
        self:DrG_Timer(3, function()
            self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav', 75, 100, 0.5)
        end)

        self:DrG_Timer(4.3, function()
            self:ExitCinematic(ent)
            ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.8, 0 )
            self:InitChestControls(ent)

            self.DisableControls = false
        end)
    end)
end

function ENT:ExitFreddy(ent)
    ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.8, 0 )

    self.WalkAnimation = 'walk'
    self.RunAnimation = 'run'
    self.PossessionMovement = POSSESSION_MOVE_CUSTOM
    self.DisableControls = true

    if IsValid(self.PlayerInside) then
        ent:SetNWBool('InFreddy2Play', false)
        ent:SetNWEntity('2PlayFreddy', nil)
    
        self.PlayerInside = nil
    else
        self:Dispossess()
    end

    ent:SetPos(self:GetPos() + self:GetForward() * 35)

    ent:SetAngles(self:GetAngles())

    self:RemoveAllGestures()
        
    self:EnterCinematic(ent)

    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav', 75, 100, 0.5)

    self:CallInCoroutine(function(self,delay)
        self:AddGestureSequence(23, false)
    end)

    ent:EmitSound('whynotboi/securitybreach/base/gregory/exitfreddy/fly_gregory_freddy_exit_0' .. math.random(1,5) .. '.wav')

    self:DrG_Timer(2.5, function()
        self.Inhabited = false
        self.OpenChest = true
        self.DisableControls = false

        self:ExitCinematic(ent)

        self:ForceLose(ent)
    end)
end

function ENT:InitChestControls(ent)
    self.WalkAnimation = 'jog'
    self.RunAnimation = 'jog'

    self.PossessionMovement = POSSESSION_MOVE_4DIR

    self:SetNWBool('UseHeadAttach', true)

    if not self:IsPossessed() then
        self:Possess(ent)
    else
        self:SecondaryInit(ent)
    end
end

function ENT:SecondaryInit(ply)
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

    self.PlayerInside = ply

    self:DrG_Timer(0.1, function()
        ply:StripWeapon('drgbase_possession')
    end)
end

function ENT:DeinitSecondary(ply)
    ply:SetCollisionGroup(5)
    ply:SetNoTarget(false)
    ply:SetNoDraw(false)
    ply:Freeze(false)
    ply:Flashlight(false)
    ply:AllowFlashlight(true)
    ply:UnSpectate()
    
    if IsValid(self) then
        self:ExitFreddy(ply)
        self:SetNWBool('UseHeadAttach', false)
    end
end