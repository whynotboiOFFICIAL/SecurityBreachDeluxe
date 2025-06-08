local PANEL = {}

PANEL.Base = 'DPanel'

local popupX = Material('ui/securitybreach/popup_x_icon.png')
local popupBG = Material('ui/securitybreach/popup_bg.png')
local popupCheck = Material('ui/securitybreach/popup_check_icon.png')
local popupMessage = Material('ui/securitybreach/popup_message.png')
local freddyThinking = Material('ui/securitybreach/glamrock_freddy_think.png')

local color_white = Color(255, 255, 255, 255)

surface.CreateFont('SB.RequiredAddonsPopup', {
	font = 'Roboto', 
	size = ScreenScale(6),
	weight = 800,
    outline = true
})

function PANEL:Init()
    self:SetSize(800, 500)
    self:Center()
    self:MakePopup()

    self:SetupControlBar()
    self:SetupAddonList()
end

function PANEL:SetupControlBar()
    local controlBar = self:Add('DPanel')

    controlBar:Dock(TOP)

    function controlBar:Paint(w, h)
        local old = DisableClipping(true)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(0, 3, w, h)

        DisableClipping(old)

        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, w, h)
    end

    local closeButton = controlBar:Add('DButton')
    
    closeButton:SetText('')
    closeButton:SetSize(50, 0)
    closeButton:Dock(RIGHT)

    function closeButton:Paint(w, h)
        local old = DisableClipping(true)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(-3, 0, w, h)

        DisableClipping(old)

        if self:IsHovered() then
            surface.SetDrawColor(255, 0, 0, 255)
        else
            surface.SetDrawColor(0, 0, 0, 255)
        end

        surface.DrawRect(0, 0, w, h)

        local xW = 12
        local xWHalf = xW / 2

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(popupX)
        surface.DrawTexturedRect(w / 2 - xWHalf, h / 2 - xWHalf, xW, xW)
    end

    closeButton.DoClick = function() 
        self:Remove()
    end

    self.ControlBar = controlBar
end

function PANEL:SetupAddonList()
    local addonList = self:Add('DPanel')

    addonList:SetSize(350, 98)
    addonList:SetPos(10, 315)

    function addonList:Paint(w, h)
        local old = DisableClipping(true)

        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(0, 0, w, h * 1.89)

        DisableClipping(old)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(0, 0, w, h)
    end

    local listHolder = addonList:Add('DPanel')

    listHolder:Dock(FILL)
    listHolder:DockMargin(4, 4, 4, 0)

    self.AddonList = listHolder
end

-- It's hard-coded to support only up to 3 but whatever
function PANEL:AddAddon(name, wsid, installed)
    local panel = self.AddonList:Add('DPanel')

    panel:Dock(TOP)
    panel:SetSize(0, 30)
    panel:DockMargin(0, 0, 0, 0)
    panel:SetText('')

    function panel:Paint(w, h)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, w, h)
    end

    local icon = panel:Add('DPanel')

    icon:SetSize(35, 0)
    icon:Dock(LEFT)

    function icon:Paint(w, h)
        local xW = 20
        local xWHalf = xW / 2

        if installed then
            surface.SetDrawColor(0, 255, 0, 10)
            surface.DrawRect(0, 0, w, h)
            
            surface.SetDrawColor(0, 255, 0, 255)
            surface.SetMaterial(popupCheck)
        else
            surface.SetDrawColor(255, 0, 0, 10)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 0, 0, 255)
            surface.SetMaterial(popupX)
        end

        surface.DrawTexturedRect(w / 2 - xWHalf, h / 2 - xWHalf, xW, xW)

        local old = DisableClipping(true)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(w, 0, 4, h)

        DisableClipping(old)
    end

    local addon = panel:Add('DButton')

    addon:DockMargin(4, 0, 0, 0)
    addon:SetFont('SB.RequiredAddonsPopup')
    addon:SetText(name)
    addon:SetTextColor(color_white)
    addon:Dock(FILL)

    function addon:Paint(w, h)
        if self:IsHovered() then
            surface.SetDrawColor(0, 255, 255, 100)
            surface.DrawRect(0, 0, w, h)
        end
    end

    function addon:DoClick()
        steamworks.ViewFile(wsid)
    end
end

function PANEL:Paint(w, h)
    local w2, h2 = w * 1.15, h

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(popupBG)
    surface.DrawTexturedRect(w / 2 - w2 / 2, (h / 2 - h2 / 2) + 7.5, w2, h2)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(freddyThinking)
    surface.DrawTexturedRect(w / 4, 0, w2, h2)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(popupMessage)
    surface.DrawTexturedRect(0, -5, w / 1.6, h / 2)
end

vgui.Register('SB_RequiredAddons_Popup', PANEL, 'DPanel')