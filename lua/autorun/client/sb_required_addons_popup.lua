local addonList = { '3495213752', '3495214499', '1560118657' } -- add the other 2 required addons later

local function getAddonName(wsid)
    local cor = coroutine.running()

    steamworks.FileInfo(wsid, function(result)
        coroutine.resume(cor, result and result.title or false)
    end)

    return coroutine.yield()
end

timer.Simple(0.1, function()
    coroutine.wrap(function()
        local names = {}
        local installed = {}

        for k, addonID in ipairs(addonList) do
            local title = getAddonName(addonID)
            if not title then return end -- they probably aren't connected to internet, stop here

            for _, addon in ipairs(engine.GetAddons()) do
                if addon.wsid == addonID then
                    installed[k] = true

                    break
                end
            end

            names[k] = title
        end

        if table.Count(installed) >= #addonList then return end

        local popup = vgui.Create('SB_RequiredAddons_Popup')

        for i = 1, 3 do
            popup:AddAddon(names[i], addonList[i], installed[i])
        end
    end)()
end)