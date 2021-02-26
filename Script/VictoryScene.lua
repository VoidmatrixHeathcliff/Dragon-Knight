SceneManager = require("SceneManager")
ArchiveManager = require("ArchiveManager")

VictoryScene = {}

VictoryScene.name = "VictoryScene"

local _FONT_ = nil

local _TEXTS_ = {"你打败了他……", "虽然，你仍可以有其他选择……"}

local _COLOR_TEXT_ = {r = 137, g = 195, b = 235, a = 255}

local _TEXT_SHOW_DELAY_ = 240

local _RECTS_TEXT_ = nil

local _window_width, _window_height = GetWindowSize()

local _image_Text_1 = nil
local _image_Text_2 = nil

local _texture_Text_1 = nil
local _texture_Text_2 = nil

local _width_image_text_1, _height_image_text_1 = nil, nil
local _width_image_text_2, _height_image_text_2 = nil, nil

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

function VictoryScene.Init()
    SceneManager.ClearWindowWhenUpdate = false

    _FONT_ = LoadFont("./Resource/Font/YGYCY.TTF", 80)

    _image_Text_1 = CreateUTF8TextImageBlended(_FONT_, _TEXTS_[1], _COLOR_TEXT_)
    _image_Text_2 = CreateUTF8TextImageBlended(_FONT_, _TEXTS_[2], _COLOR_TEXT_)
    _texture_Text_1 = CreateTexture(_image_Text_1)
    _texture_Text_2 = CreateTexture(_image_Text_2)

    _width_image_text_1, _height_image_text_1 = GetImageSize(_image_Text_1)
    _width_image_text_2, _height_image_text_2 = GetImageSize(_image_Text_2)
    _RECTS_TEXT_ = {
        {x = _window_width / 2 - _width_image_text_1 / 2, y = _window_height / 2 - _height_image_text_1 / 2 - 100, w = _width_image_text_1, h = _height_image_text_1},
        {x = _window_width / 2 - _width_image_text_2 / 2, y = _window_height / 2 + _height_image_text_1 / 2 + 50, w = _width_image_text_2, h = _height_image_text_2},
    }
end

function VictoryScene.Update()
    UpdateEvent()

    if _alpha > 0 then _alpha = _alpha - 5 end
    if _timer_show > _TEXT_SHOW_DELAY_ then
        _FadeOut()
        SceneManager.SetQuitHandler(function() return true end)
        SceneManager.Quit()
        return
    else
        _timer_show = _timer_show + 1
    end

    CopyTexture(_texture_Text_1, _RECTS_TEXT_[1])
    CopyTexture(_texture_Text_2, _RECTS_TEXT_[2])
    SetDrawColor({r = 0, g = 0, b = 0, a = _alpha})
    FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
end

function VictoryScene.Unload()
    ArchiveManager.SetData("_dialogue_list_index", 1)
    ArchiveManager.SetData("_dialogue_text_index", 1)
    ArchiveManager.SetData("choice", 0)
    ArchiveManager.DumpArchive()
    ArchiveManager.CloseArchive()

    UnloadFont(_FONT_)
    DestroyTexture(_texture_Text_1)
    DestroyTexture(_texture_Text_2)
    UnloadImage(_image_Text_1)
    UnloadImage(_image_Text_2)
end

return VictoryScene