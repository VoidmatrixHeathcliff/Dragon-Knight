QuitHandler = {}

local _WIDTH_TIPBOX_, _HEIGHT_TIPBOX = 850, 300

local _window_width, _window_height = GetWindowSize()

local _FONT_ = LoadFont("./Resource/Font/SIMYOU.TTF", 75)

local _COLOR_TEXT_ = {r = 23, g = 24, b = 75, a = 255}
local _COLOR_MASK_ = {r = 0, g = 0, b = 0, a = 200}
local _COLOR_TIPBOX_BORDER_ = {r = 106, g = 93, b = 33, a = 255}
local _COLOR_TIPBOX_ = {r = 241, g = 191, b = 153, a = 200}
local _COLOR_BUTTON_CONFIRM_ = {r = 187, g = 200, b = 230, a = 255}
local _COLOR_BUTTON_CANCEL_ = {r = 234, g = 85, b = 6, a = 255}
local _COLOR_BUTTON_BORDER_ = {r = 70, g = 14, b = 68, a = 255}

local _RECT_TIPBOX_ = {x = _window_width / 2 - _WIDTH_TIPBOX_ / 2, y = _window_height / 2 - _HEIGHT_TIPBOX / 2, w = _WIDTH_TIPBOX_, h = _HEIGHT_TIPBOX}
local _RECT_INFOTEXT_ = {x = _RECT_TIPBOX_.x + _RECT_TIPBOX_.w / 2 - 250, y = _RECT_TIPBOX_.y + _RECT_TIPBOX_.h * 0.2, w = 500, h = 50}
local _RECT_BUTTON_CONFIRM_ = {x = 350, y = 410, w = 175, h = 45}
local _RECT_BUTTONTEXT_CONFIRM_ = {
    x = _RECT_BUTTON_CONFIRM_.x + 40,
    y = _RECT_BUTTON_CONFIRM_.y + 10,
    w = _RECT_BUTTON_CONFIRM_.w - 80,
    h = _RECT_BUTTON_CONFIRM_.h - 20
}
local _RECT_BUTTON_CANCEL_ = {x = 750, y = 410, w = 175, h = 45}
local _RECT_BUTTONTEXT_CANCEL_ = {
    x = _RECT_BUTTON_CANCEL_.x + 40,
    y = _RECT_BUTTON_CANCEL_.y + 10,
    w = _RECT_BUTTON_CANCEL_.w - 80,
    h = _RECT_BUTTON_CANCEL_.h - 20
}

local function _HandleQuit()
    ArchiveManager = require("ArchiveManager")
    ArchiveManager.DumpArchive()
    ArchiveManager.CloseArchive()
end

local _image_InfoText = nil
local _image_ButtonText_Confirm = nil
local _image_ButtonText_Cancel = nil

local _texture_InfoText = nil
local _texture_ButtonText_Confirm = nil
local _texture_ButtonText_Cancel = nil

local function _Init()
    _window_width, _window_height = GetWindowSize()
    SetDrawColor(_COLOR_MASK_)
    FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
    SetDrawColor(_COLOR_TIPBOX_BORDER_)
    FillRoundRectangle({x = _RECT_TIPBOX_.x - 10, y = _RECT_TIPBOX_.y - 10, w = _RECT_TIPBOX_.w + 20, h = _RECT_TIPBOX_.h + 20}, 25)
    SetDrawColor(_COLOR_TIPBOX_)
    FillRoundRectangle(_RECT_TIPBOX_, 25)
    SetDrawColor(_COLOR_BUTTON_CONFIRM_)
    FillRectangle(_RECT_BUTTON_CONFIRM_)
    SetDrawColor(_COLOR_BUTTON_CANCEL_)
    FillRectangle(_RECT_BUTTON_CANCEL_)
    
    SetDrawColor(_COLOR_BUTTON_BORDER_)
    Rectangle(_RECT_BUTTON_CONFIRM_)
    Rectangle(_RECT_BUTTON_CANCEL_)
    
    _image_InfoText = CreateUTF8TextImageBlended(_FONT_, "确定要退出并保存游戏吗？", _COLOR_TEXT_)
    _image_ButtonText_Confirm = CreateUTF8TextImageBlended(_FONT_, "确定", _COLOR_TEXT_)
    _image_ButtonText_Cancel = CreateUTF8TextImageBlended(_FONT_, "取消", _COLOR_TEXT_)
    
    _texture_InfoText = CreateTexture(_image_InfoText)
    _texture_ButtonText_Confirm = CreateTexture(_image_ButtonText_Confirm)
    _texture_ButtonText_Cancel = CreateTexture(_image_ButtonText_Cancel)
    
    CopyTexture(_texture_InfoText, _RECT_INFOTEXT_)
    CopyTexture(_texture_ButtonText_Confirm, _RECT_BUTTONTEXT_CONFIRM_)
    CopyTexture(_texture_ButtonText_Cancel, _RECT_BUTTONTEXT_CANCEL_)
end

local function _Unload()
    DestroyTexture(_texture_InfoText)
    DestroyTexture(_texture_ButtonText_Confirm)
    DestroyTexture(_texture_ButtonText_Cancel)
    
    UnloadImage(_image_InfoText)
    UnloadImage(_image_ButtonText_Confirm)
    UnloadImage(_image_ButtonText_Cancel)
end

local function _Mainloop()
    while true do
        if UpdateEvent() then
            local _event = GetEventType()
            if _event == EVENT_QUIT then
                _HandleQuit()
                return true
            elseif _event == EVENT_MOUSEBTNDOWN_LEFT then
                local _x, _y = GetCursorPosition()
                if _x > _RECT_BUTTON_CONFIRM_.x
                    and _x < _RECT_BUTTON_CONFIRM_.x + _RECT_BUTTON_CONFIRM_.w
                    and _y > _RECT_BUTTON_CONFIRM_.y
                    and _y < _RECT_BUTTON_CONFIRM_.y + _RECT_BUTTON_CONFIRM_.h
                then
                    _HandleQuit()
                    return true
                else
                    return false
                end
            end
        end
        
        UpdateWindow()
    end
end

function QuitHandler.Entry()
    _Init()
    local flag = _Mainloop()
    _Unload()
    return flag
end

return QuitHandler
