AddCSLuaFile()

SWEP.Base = 'weapon_base'

SWEP.PrintName = 'FazCamera'
SWEP.Category = 'Security Breach'

SWEP.ViewModel = 'models/whynotboi/securitybreach/base/props/fazcamera/v_fazcamera.mdl'
SWEP.WorldModel = 'models/whynotboi/securitybreach/base/props/fazcamera/fazcamera.mdl'

SWEP.HoldType = 'camera'

SWEP.WepSelectIcon = 60

SWEP.BobScale = 0.7

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFlip = true

function SWEP:Initialize()
    self:SetWeaponHoldType( self.HoldType )

    self:SetNWBool('IsCharged', true)

    self.InfiniteAmmo = GetConVar('fnaf_sb_new_fazcam_infiniteammo'):GetBool()

    if CLIENT then
        self.BarCharge = 1
    end
end

function SWEP:Deploy()
    local vm = self.Owner:GetViewModel()

    vm:ResetSequence('equip')

    timer.Simple( 0.4, function()
        if not IsValid(self)  then return end
        vm:SendViewModelMatchingSequence(self:LookupSequence('idle'))
    end)

    if not self:GetNWBool('IsCharged') then
        self:EmitSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_0' .. math.random(3) .. '.wav', 75, 100, 0.3)
    end
end

function SWEP:PrimaryAttack()
    if self.FireDelay then return end

    self.FireDelay = true
    
    self:EmitSound('whynotboi/securitybreach/base/props/fazcamera/trigger/sfx_fazcam_trigger_click_0' .. math.random(6) .. '.wav')

    local vm = self.Owner:GetViewModel()

    vm:SendViewModelMatchingSequence(self:LookupSequence('fire'))

    timer.Simple( 0.2, function()
        if not IsValid(self)  then return end

        self:EmitSound('whynotboi/securitybreach/base/props/fazcamera/activate/sfx_fazcam_activate_0' .. math.random(3) .. '.wav', 75, 100, 1, CHAN_STATIC)

        self:LightFlash()

        if not self.InfiniteAmmo then
            self:SetNWBool('IsCharged', false)
        end

        local size = 350
        local dir = self:GetForward()
        local angle = math.cos( math.rad( 90 ) )
        local startPos = self:WorldSpaceCenter()

        for k, v in ipairs( ents.FindInCone( startPos, dir, size, angle ) ) do
            if (v == self) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and self:GetIgnorePlayers()) or (v:IsPlayer() and IsValid(v:DrG_GetPossessing())) or v:Health() < 1 then continue end

            if SERVER and IsValid(v) then
                local ent = v
        
                if ent.IsDrGNextbot and ent.Category == 'Security Breach' and ent.CanBeStunned then
                    ent:DoStunned()
                end
                
                if ent:IsPlayer() then
                    ent:ScreenFade(SCREENFADE.IN, color_white, 0.3, 0.3)
                end
            end
        end

        timer.Simple( 0.2, function()
            if not IsValid(self)  then return end
            vm:SendViewModelMatchingSequence(self:LookupSequence('idle'))

            if self.InfiniteAmmo then return end
            
            self:EmitSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_0' .. math.random(3) .. '.wav', 75, 100, 0.3)
        end)

        local delay = 29.8
        
        if self.InfiniteAmmo then
            delay = 1
        end

        timer.Simple( delay, function()
            if not IsValid(self) then return end

            self.FireDelay = false
            self:SetNWBool('IsCharged', true)

            self:StopSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_01.wav')
            self:StopSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_02.wav')
            self:StopSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_03.wav')

            self:EmitSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_recharge_0' .. math.random(3) .. '.wav')
        end)
    end)
end

function SWEP:Think()
    self:SetClip1( self:GetNWBool("IsCharged", 1) and 1 or 0 )
end

local color_white = Color(255, 255, 255)

if SERVER then
    function SWEP:LightFlash()
        local owner = self:GetOwner()
        if not owner:IsValid() or not owner:IsPlayer() then return end

        self:CallOnClient('LightFlash')
        self:SetNWBool('SB_IsFlashing', true)

        self:DrG_Timer(0.2, function()
            self:SetNWBool('SB_IsFlashing', false)
        end)
    end
else
    function SWEP:LightFlash()
        if not self.DrawingWorldModel then
            local owner = self:GetOwner()

            if owner == LocalPlayer() then
                owner:ScreenFade(SCREENFADE.IN, color_white, 0.3, 0.3)
            end
        end
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Holster( wep )
    self:StopSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_01.wav')
    self:StopSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_02.wav')
    self:StopSound('whynotboi/securitybreach/base/props/fazcamera/recharge/sfx_fazcam_charging_lp_03.wav')

    return true
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture(surface.GetTextureID('vgui/weapon_sb_fazcamera'))

	y = y + 20
	x = x + 10
	wide = wide - 20

	surface.DrawTexturedRect( x, y, wide , ( wide / 2 ))
end

if CLIENT then
    local camerameter = Material('ui/securitybreach/camera/Fazerblast_Fazcam_meter_1k.png')
    local camerafill = Material('ui/securitybreach/camera/Fazerblast_Fazcam_fill_1k.png')

    local icon = Material('ui/securitybreach/camera/FazCamIcon.png')
    local iconEmpty = Material('ui/securitybreach/camera/FazCamIconEmpty.png')

    local barColor = Color(255, 0, 0)
    local iconColor = Color(255, 255, 255)

    function SWEP:DrawHUD()
        local w, h = ScrW(), ScrH()

        local newCharge
        local isCharged = self:GetNWBool('IsCharged')

        if not isCharged then
            newCharge = self.BarCharge - FrameTime()
        else
            newCharge = self.BarCharge + FrameTime()
        end

        newCharge = math.Clamp(newCharge, 0, 1)

        self.BarCharge = newCharge

        -- Meter --

        surface.SetDrawColor(255, 255, 255, 255)

        local w2, h2 = ScreenScale(15), ScreenScale(120)
        local camerabar = w / 2 - w2 * -19

        if not isCharged then
            local saturation = math.abs(math.sin(CurTime() * 3))

            iconColor:SetSaturation(1 - saturation)
        else
            iconColor:SetSaturation(0)
        end
        
        surface.SetDrawColor(iconColor.r, iconColor.g, iconColor.b)
        surface.SetMaterial(isCharged and icon or iconEmpty)
        surface.DrawTexturedRect(camerabar - 15, ScreenScale(70), 70, 100)

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(camerameter)
        surface.DrawTexturedRect(camerabar, h - h2 * 2.1, w2, h2)

        local charge = math.EaseInOut(self.BarCharge, 0.5, 0)

        barColor:SetHue(40 * math.min(1, charge / 0.75))
        
        surface.SetDrawColor(barColor.r, barColor.g, barColor.b)
        surface.SetMaterial(camerafill)
        surface.DrawTexturedRect(camerabar, h - h2 * 2.1, w2, h2)

        surface.SetDrawColor(38, 38, 41, 255)
        surface.DrawTexturedRect(camerabar, h - h2 * 2.1, w2, h2 * (1 - charge))
    end
end

if SERVER then return end

-- Camera flash

function SWEP:ViewModelDrawn()
    self.DrawingWorldModel = false
end

function SWEP:DrawWorldModel()
    self:DrawModel()

    self.DrawingWorldModel = true
end

local flashSprite = Material('sprites/light_glow02_add.vmt')

-- Drawing it in this hook so it actually draws over the player
hook.Add('PreDrawEffects', 'fnaf_sb_fazcamera_flash', function()
    local ply = LocalPlayer()
    if not ply:IsValid() then return end

    local wep = ply:GetActiveWeapon()

    if not IsValid(wep) then return end
    if wep:GetClass() ~= 'weapon_sb_fazcamera' or not wep.DrawingWorldModel then return end
    if not wep:GetNWBool('SB_IsFlashing') then return end

    local attachment = wep:GetAttachment(wep:LookupAttachment('Flash'))
    if not attachment then return end

    local pos = attachment.Pos
    pos = pos + ply:GetForward() * 10

    render.SetMaterial(flashSprite)
    render.DrawSprite(pos, 256, 256, color_white)
end)