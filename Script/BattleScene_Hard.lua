SceneManager = require("SceneManager")
ArchiveManager = require("ArchiveManager")

BattleScene_Hard = {}

BattleScene_Hard.name = "BattleScene_Hard"

local _FONT_ = nil

local _TEXTS_ = {"这里是极度困难的战斗场景……", "虽然还没有开发完成，但是你绝对无法通过~", "Enjoy Ether !"}

local _TEXT_SHOW_DELAY_ = 360

local _RECTS_TEXT_ = nil

local _window_width, _window_height = GetWindowSize()

local _image_Text_1 = nil
local _image_Text_2 = nil
local _image_Text_3 = nil

local _texture_Text_1 = nil
local _texture_Text_2 = nil
local _texture_Text_3 = nil

local _width_image_text_1, _height_image_text_1 = nil, nil
local _width_image_text_2, _height_image_text_2 = nil, nil
local _width_image_text_3, _height_image_text_3 = nil, nil

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

function BattleScene_Hard.Init()
    SceneManager.ClearWindowWhenUpdate = false

    _FONT_ = LoadFont("./Resource/Font/YGYCY.TTF", 60)

    _image_Text_1 = CreateUTF8TextImageBlended(_FONT_, _TEXTS_[1], {r = 147, g = 202, b = 118, a = 255})
    _image_Text_2 = CreateUTF8TextImageBlended(_FONT_, _TEXTS_[2], {r = 147, g = 202, b = 118, a = 255})
    _image_Text_3 = CreateUTF8TextImageBlended(_FONT_, _TEXTS_[3], {r = 243, g = 152, b = 0, a = 255})
    _texture_Text_1 = CreateTexture(_image_Text_1)
    _texture_Text_2 = CreateTexture(_image_Text_2)
    _texture_Text_3 = CreateTexture(_image_Text_3)

    _width_image_text_1, _height_image_text_1 = GetImageSize(_image_Text_1)
    _width_image_text_2, _height_image_text_2 = GetImageSize(_image_Text_2)
    _width_image_text_3, _height_image_text_3 = GetImageSize(_image_Text_3)
    _RECTS_TEXT_ = {
        {x = _window_width / 2 - _width_image_text_1 / 2, y = _window_height / 2 - _height_image_text_1 / 2 - 100, w = _width_image_text_1, h = _height_image_text_1},
        {x = _window_width / 2 - _width_image_text_2 / 2, y = _window_height / 2 + _height_image_text_1 / 2 + 50, w = _width_image_text_2, h = _height_image_text_2},
        {x = _window_width / 2 - _width_image_text_3 / 2, y = _window_height / 2 + _height_image_text_1 / 2 + 200, w = _width_image_text_3, h = _height_image_text_3}
    }
end

function BattleScene_Hard.Update()
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
    CopyTexture(_texture_Text_3, _RECTS_TEXT_[3])
    SetDrawColor({r = 0, g = 0, b = 0, a = _alpha})
    FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
end

function BattleScene_Hard.Unload()
    ArchiveManager.SetData("_dialogue_list_index", 1)
    ArchiveManager.SetData("_dialogue_text_index", 1)
    ArchiveManager.SetData("choice", 0)
    ArchiveManager.DumpArchive()
    ArchiveManager.CloseArchive()

    UnloadFont(_FONT_)
    DestroyTexture(_texture_Text_1)
    DestroyTexture(_texture_Text_2)
    DestroyTexture(_texture_Text_3)
    UnloadImage(_image_Text_1)
    UnloadImage(_image_Text_2)
    UnloadImage(_image_Text_3)
end

return BattleScene_Hard