local config = require("modules/config")
local utils = require("modules/utils")
local tweaks = require("modules/tweaks")

local settings = {}

function settings.addKeybinds(mod)
    -- Keyboard
    local info = mod.inputManager.createBindingInfo()
    info.keybindLabel = "キー"
    info.keybindDescription = "ホットキーの一部として使うキーを登録する"
    info.isHoldLabel = "長押し設定"
    info.supportsHold = false
    info.id = "mkbBinding"
    info.maxKeys = 2
    info.maxKeysLabel = "ホットキーの数"
    info.maxKeysDescription = "このホットキーに必要なキーの数を変更する。起動するには全てのキーを押す必要がある"
    info.nativeSettingsPath = "/nightVision/hotkeyMKB"
    info.defaultOptions = mod.defaultSettings.keyboard
    info.savedOptions = mod.settings.keyboard
    info.saveCallback = function(name, value)
        mod.settings.keyboard[name] = value
        config.saveFile("config/config.json", mod.settings)
        tweaks.applyTweaks(mod)
    end
    info.callback = function()
        mod:toggleNV()
    end
    mod.inputManager.addNativeSettingsBinding(info)

    -- Gamepad
    info = utils.deepcopy(info)
    info.supportsHold = true
    info.isHoldDescription = "起動の際、登録したキーを一定時間押し続ける必要があるかどうか設定する"
    info.id = "padBinding"
    info.maxKeys = 3
    info.maxKeysLabel = "ホットキーの数"
    info.maxKeysDescription = "このホットキーに必要なキーの数を変更する。起動するには全てのキーを押す必要がある"
    info.nativeSettingsPath = "/nightVision/hotkeyPad"
    info.defaultOptions = mod.defaultSettings.pad
    info.savedOptions = mod.settings.pad
    info.saveCallback = function(name, value)
        mod.settings.pad[name] = value
        config.saveFile("config/config.json", mod.settings)
        tweaks.applyTweaks(mod)
    end
    mod.inputManager.addNativeSettingsBinding(info)
end

function settings.setupNative(mod)
    local nativeSettings = GetMod("nativeSettings")

    if not nativeSettings then
        print("[NightVision] 情報: NativeSettings ライブラリが見つかりません!")
        return
    end

    local cetVer = tonumber((GetVersion():gsub('^v(%d+)%.(%d+)%.(%d+)(.*)', function(major, minor, patch, wip) -- <-- This has been made by psiberx, all credits to him
        return ('%d.%02d%02d%d'):format(major, minor, patch, (wip == '' and 0 or 1))
    end)))

    if cetVer < 1.18 then
        print("[NightVision] エラー: CET が推奨バージョン未満です!")
        return
    end

    nativeSettings.addTab("/nightVision", "ナイトビジョン サイバーウェア")
    nativeSettings.addSubcategory("/nightVision/hotkeyMKB", "キーボード ホットキー")
    nativeSettings.addSubcategory("/nightVision/hotkeyPad", "コントローラー ホットキー")

    settings.addKeybinds(mod)
end

return settings