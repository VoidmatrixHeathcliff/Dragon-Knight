SceneManager = require("SceneManager")
ArchiveManager = require("ArchiveManager")

FailureScene = {}

FailureScene.name = "FailureScene"

local _FONT_ = nil

local _TEXT_ = "别灰心，你还有机会……"

local _COLOR_TEXT_ = {r = 226, g = 4, b = 27, a = 255}

local _TEXT_SHOW_DELAY_ = 120

local _RECT_TEXT_ = nil

local _window_width, _window_height = GetWindowSize()

local _image_Text = nil

local _texture_Text = nil

local _width_image_text, _height_image_text = nil, nil

local _start_FadeIn = true

local _timer_show = 0

local _alpha = 255

local function _FadeOut()
    SetDrawColor({r = 0, g = 0, b = 0, a = 15})
    for i = 1, 100 do
        FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
        UpdateWindow()
        Sleep(10)
    end
end

function FailureScene.Init()
    SceneManager.ClearWindowWhenUpdate = false

    _FONT_ = LoadFont("./Resource/Font/YGYCY.TTF", 90)

    _image_Text = CreateUTF8TextImageBlended(_FONT_, _TEXT_, _COLOR_TEXT_)
    _texture_Text = CreateTexture(_image_Text)

    _width_image_text, _height_image_text = GetImageSize(_image_Text)
    _RECT_TEXT_ = {x = _window_width / 2 - _width_image_text / 2, y = _window_height / 2 - _height_image_text, w = _width_image_text, h = _height_image_text}
end

function FailureScene.Update()
    UpdateEvent()

    if _start_FadeIn and _alpha > 0 then _alpha = _alpha - 5 end
    if _timer_show > _TEXT_SHOW_DELAY_ then
        _FadeOut()
        SceneManager.SetQuitHandler(function() return true end)
        SceneManager.Quit()
        return
    else
        _timer_show = _timer_show + 1
    end

    CopyTexture(_texture_Text, _RECT_TEXT_)
    SetDrawColor({r = 0, g = 0, b = 0, a = _alpha})
    FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
end

function FailureScene.Unload()
    ArchiveManager.DumpArchive()
    ArchiveManager.CloseArchive()

    UnloadFont(_FONT_)
    DestroyTexture(_texture_Text)
    UnloadImage(_image_Text)
end

return FailureScene