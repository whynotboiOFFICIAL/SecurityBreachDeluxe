SWEP.Base = 'weapon_base'

SWEP.PrintName = 'FazCamera'
SWEP.Category = 'Security Breach'

SWEP.ViewModel = 'models/whynotboi/securitybreach/base/props/fazcamera/v_fazcamera.mdl'
SWEP.WorldModel = 'models/whynotboi/securitybreach/base/props/fazcamera/fazcamera.mdl'

SWEP.HoldType = 'camera'

SWEP.WepSelectIcon = 60

SWEP.BobScale = 0.7

SWEP.SlotPos = 2

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

function SWEP:Initialize()
    self.Weapon:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
    local vm = self.Owner:GetViewModel()

    vm:ResetSequence('equip')

    timer.Simple( 0.4, function()
        if not IsValid(self)  then return end
        vm:SendViewModelMatchingSequence(self:LookupSequence('idle'))
    end)
end

function SWEP:PrimaryAttack()
    if self.FireDelay then return end

    self.FireDelay = true

    
    self:EmitSound('whynotboi/securitybreach/base/props/fazcamera/trigger/sfx_fazcam_trigger_click_0' .. math.random(6) .. '.wav')


    local vm = self.Owner:GetViewModel()

    vm:SendViewModelMatchingSequence(self:LookupSequence('fire'))

    timer.Simple( 0.2, function()
        if not IsValid(self)  then return end
        self:EmitSound('whynotboi/securitybreach/base/props/fazcamera/activate/sfx_fazcam_activate_0' .. math.random(3) .. '.wav')

        self:LightFlash()

        local size = 350
        local dir = self:GetForward()
        local angle = math.cos( math.rad( 90 ) )
        local startPos = self:WorldSpaceCenter()

        for k, v in ipairs( ents.FindInCone( startPos, dir, size, angle ) ) do
            if (v == self) or not (v:IsPlayer() or v:IsNPC() or v:IsNextBot()) or (v:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool()) or (v:IsPlayer() and IsValid(v:DrG_GetPossessing())) or v:Health() < 1 then continue end

            if SERVER and IsValid(v) then
                local ent = v
        
                if ent.IsDrGNextbot and ent.Category == 'Security Breach' and ent.CanBeStunned then
                    ent:DoStunned()
                end
            end
        end

        timer.Simple( 0.2, function()
            if not IsValid(self)  then return end
            vm:SendViewModelMatchingSequence(self:LookupSequence('idle'))
        end)

        timer.Simple( 0.8, function()
            if not IsValid(self)  then return end
            self.FireDelay = false
        end)
    end)
end

function SWEP:LightFlash()
    local beam = ents.Create("env_sprite")
    if IsValid(beam) then

        beam:SetPos(self.Owner:EyePos() + self.Owner:GetForward() * 25)
        beam:SetKeyValue("model", "sprites/light_glow02_add.vmt")
        beam:SetKeyValue("scale", "1.5")
        beam:SetKeyValue("rendermode", "5")
        beam:SetKeyValue("renderamt", "255")
        beam:SetKeyValue("rendercolor", "255 255 255")

        beam:SetParent(self.Owner)

        beam:Spawn()

        self:DeleteOnRemove(beam)

        timer.Simple(0.2, function()
            if not IsValid(beam) then return end

            beam:Remove()
        end)
    end
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

function SWEP:Holster( wep )
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