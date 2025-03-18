
function ENT:OpenChestHatch()
    self.OpenChest = true

    self:StopSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav')
    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav', 75, 100, 0.5)

    self:AddGestureSequence(20, false)
end

function ENT:CloseChestHatch()
    self.OpenChest = false

    self:RemoveAllGestures()

    self:StopSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav')
    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav', 75, 100, 0.5)

    self:PlaySequence('closechest')
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
    self.OpenChest = false
    self.Inhabited = true

    self:DirectPoseParametersAt(nil, 'aim_pitch', 'aim_yaw', self:WorldSpaceCenter())
    
    self:DrG_Timer(0, function()
        self:FaceInstant(ent)

        self:RemoveAllGestures()
        
        self:EnterCinematic(ent)

        self:PlaySequence('enterfreddy')

        ent:EmitSound('whynotboi/securitybreach/base/gregory/enterfreddy/fly_gregory_freddy_enter_0' .. math.random(1,5) .. '.wav')
        
        self:DrG_Timer(3, function()
            self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestclose.wav', 75, 100, 0.5)
        end)

        self:DrG_Timer(4.3, function()
            self:ExitCinematic(ent)
            ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.8, 0 )
            self:InitChestControls(ent)
        end)
    end)
end

function ENT:ExitFreddy(ent)
    ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.8, 0 )

    self.WalkAnimation = 'walk'
    self.RunAnimation = 'run'
    self.PossessionMovement = POSSESSION_MOVE_CUSTOM

    self:Dispossess()

    ent:SetPos(self:GetPos() + self:GetForward() * 35)

    ent:SetAngles(self:GetAngles())

    self:RemoveAllGestures()
        
    self:EnterCinematic(ent)

    self:EmitSound('whynotboi/securitybreach/base/glamrockfreddy/hatch/sfx_char_freddy_chestopen.wav', 75, 100, 0.5)

    self:AddGestureSequence(23, false)

    ent:EmitSound('whynotboi/securitybreach/base/gregory/exitfreddy/fly_gregory_freddy_exit_0' .. math.random(1,5) .. '.wav')

    self:DrG_Timer(2.5, function()
        self.Inhabited = false
        self.OpenChest = true

        self:ExitCinematic(ent)

        self:ForceLose(ent)
    end)
end

function ENT:InitChestControls(ent)
    self.WalkAnimation = 'jog'
    self.RunAnimation = 'jog'

    self.PossessionMovement = POSSESSION_MOVE_4DIR
    if not self:IsPossessed() then
        self:SetNWBool('UseHeadAttach', true)
        self:Possess(ent)
    end
end
