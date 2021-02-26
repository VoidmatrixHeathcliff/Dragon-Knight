SceneManager = require("SceneManager")
ArchiveManager = require("ArchiveManager")

LeadingScene = {}

LeadingScene.name = "LeadingScene"

local _FONT_NAME_ = nil
local _FONT_TEXT_ = nil
local _FONT_CHOICE_ = nil

local _COLOR_TEXT_NAME_ = {r = 170, g = 76, b = 143, a = 255}
local _COLOR_TEXT_TEXT_ = {r = 234, g = 237, b = 247, a = 255}

local _window_width, _window_height = GetWindowSize()

local _RECT_CHOICE_1_ = {x = _window_width / 2 - 395, y = 125, w = 790, h = 35}
local _RECT_CHOICE_2_ = {x = _window_width / 2 - 395, y = 250, w = 790, h = 35}

local _width_image_Textbox, _height_image_Textbox = nil, nil

local _image_Background = nil
local _image_Textbox = nil
local _image_ChoiceNormal = nil
local _image_ChoiceHover = nil

local _texture_Background = nil
local _texture_Textbox = nil
local _texture_ChoiceNormal = nil
local _texture_ChoiceHover = nil

local _image_WarriorNormal = nil
local _image_WarriorSad = nil
local _image_WarriorScared = nil
local _image_WarriorAngry = nil

local _music_Background = nil
local _sound_Keyboard = nil

local _current_dialogue_list = nil

local _dialogue_lists = nil

local _dialogue_text_index = 1

local _isChioce_Showing = false

local _text_Choice_1 = nil
local _text_Choice_2 = nil

local function _FreeRenderResWhenUpdating(imageTable, textureTable)
    for _, texture in pairs(textureTable) do
        DestroyTexture(texture)
    end
    
    for _, image in pairs(imageTable) do
        UnloadImage(image)
    end
end

local function _FadeOut()
    SetDrawColor({r = 0, g = 0, b = 0, a = 15})
    for i = 1, 100 do
        FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
        UpdateWindow()
        Sleep(10)
    end
end

function LeadingScene.Init()
    SceneManager.ClearWindowWhenUpdate = false
    
    _FONT_NAME_ = LoadFont("./Resource/Font/SIMYOU.TTF", 45)
    _FONT_TEXT_ = LoadFont("./Resource/Font/SIMYOU.TTF", 25)
    _FONT_CHOICE_ = LoadFont("./Resource/Font/SIMYOU.TTF", 18)

    _image_Background = LoadImage("./Resource/Image/Background/Road_Morning.png")
    _image_Textbox = LoadImage("./Resource/Image/textbox.png")
    _image_ChoiceNormal = LoadImage("./Resource/Image/choice_idle.png")
    _image_ChoiceHover = LoadImage("./Resource/Image/choice_hover.png")
    
    _width_image_Textbox, _height_image_Textbox = GetImageSize(_image_Textbox)
    
    _texture_Background = CreateTexture(_image_Background)
    _texture_Textbox = CreateTexture(_image_Textbox)
    _texture_ChoiceNormal = CreateTexture(_image_ChoiceNormal)
    _texture_ChoiceHover = CreateTexture(_image_ChoiceHover)
    
    _image_WarriorNormal = LoadImage("./Resource/Image/Character/WarriorNormal.png")
    _image_WarriorSad = LoadImage("./Resource/Image/Character/WarriorSad.png")
    _image_WarriorScared = LoadImage("./Resource/Image/Character/WarriorScared.png")
    _image_WarriorAngry = LoadImage("./Resource/Image/Character/WarriorAngry.png")
    
    _texture_WarriorNormal = CreateTexture(_image_WarriorNormal)
    _texture_WarriorSad = CreateTexture(_image_WarriorSad)
    _texture_WarriorScared = CreateTexture(_image_WarriorScared)
    _texture_WarriorAngry = CreateTexture(_image_WarriorAngry)
    
    _music_Background = LoadMusic("./Resource/Audio/bgm_1.ogg")
    _sound_Keyboard = LoadSound("./Resource/Audio/keyboard.wav")
    
    _dialogue_lists = {
        {
            {name = "骑士", text = "所以，你就是那位来自央都的勇者对吧？", image = _image_WarriorNormal},
            {name = "我", text = "……", image = _image_WarriorNormal},
            {name = "骑士", text = "所以，卡尔就是因为你们才死的对吧？！", image = _image_WarriorSad},
            {choices = {"是的，卡尔它是英雄……", "怎么可能，那条恶龙死有余辜！"}}
        },
        {
            {name = "骑士", text = "你们这些下民，早晚都将会化作灰土，又怎样值得被一条高贵的飞龙冒死拯救？！", image = _image_WarriorAngry},
            {name = "骑士", text = "你们必将因此而付出代价！", image = _image_WarriorAngry},
            {jump = "BattleScene_Normal"}
        },
        {
            {name = "骑士", text = "你……！！！", image = _image_WarriorScared},
            {name = "骑士", text = "你们这些不识好歹的下民……！！！", image = _image_WarriorScared},
            {name = "骑士", text = "去死吧！！！！！！", image = _image_WarriorAngry},
            {jump = "BattleScene_Hard"}
        }
    }
    
    _current_dialogue_list = _dialogue_lists[ArchiveManager.GetData("_dialogue_list_index")]
    _dialogue_text_index = ArchiveManager.GetData("_dialogue_text_index")
    
    FadeInMusic(_music_Background, -1, 1000)
end

function LeadingScene.Update()
    if UpdateEvent() then
        local _event = GetEventType()
        if _event == EVENT_QUIT then
            SceneManager.Quit()
            return
        elseif _event == EVENT_MOUSEBTNDOWN_LEFT then
            if _isChioce_Showing then
                local _x, _y = GetCursorPosition()
                if _x > _RECT_CHOICE_1_.x and _x < _RECT_CHOICE_1_.x + _RECT_CHOICE_1_.w and _y > _RECT_CHOICE_1_.y and _y < _RECT_CHOICE_1_.y + _RECT_CHOICE_1_.h then
                    -- 处理选择选项1的操作
                    _current_dialogue_list = _dialogue_lists[2]
                    ArchiveManager.SetData("_dialogue_list_index", 2)
                    _dialogue_text_index = 1
                    ArchiveManager.SetData("_dialogue_text_index", _dialogue_text_index)
                    ArchiveManager.SetData("choice", 1)
                    _isChioce_Showing = false
                elseif _x > _RECT_CHOICE_2_.x and _x < _RECT_CHOICE_2_.x + _RECT_CHOICE_2_.w and _y > _RECT_CHOICE_2_.y and _y < _RECT_CHOICE_2_.y + _RECT_CHOICE_2_.h then
                    -- 处理选择选项2的操作
                    _current_dialogue_list = _dialogue_lists[3]
                    ArchiveManager.SetData("_dialogue_list_index", 3)
                    _dialogue_text_index = 1
                    ArchiveManager.SetData("_dialogue_text_index", _dialogue_text_index)
                    ArchiveManager.SetData("choice", 2)
                    _isChioce_Showing = false
                end
            else
                PlaySound(_sound_Keyboard, 0)
                if _current_dialogue_list[_dialogue_text_index + 1].name then
                    _dialogue_text_index = _dialogue_text_index + 1
                    ArchiveManager.SetData("_dialogue_text_index", _dialogue_text_index)
                else
                    if _current_dialogue_list[_dialogue_text_index + 1].choices then
                        _isChioce_Showing = true
                        _text_Choice_1 = _current_dialogue_list[_dialogue_text_index + 1].choices[1]
                        _text_Choice_2 = _current_dialogue_list[_dialogue_text_index + 1].choices[2]
                    elseif _current_dialogue_list[_dialogue_text_index + 1].jump then
                        FadeOutMusic(1000)
                        _FadeOut()
                        SceneManager.LoadScene(_current_dialogue_list[_dialogue_text_index + 1].jump)
                        return
                    end
                end
            end
        end
    end
    
    CopyTexture(_texture_Background, {x = 0, y = 0, w = _window_width, h = _window_height})
    
    local _image_NameText = CreateUTF8TextImageBlended(_FONT_NAME_, _current_dialogue_list[_dialogue_text_index].name, _COLOR_TEXT_NAME_)
    local _image_TextText = CreateUTF8TextImageBlended(_FONT_TEXT_, _current_dialogue_list[_dialogue_text_index].text, _COLOR_TEXT_TEXT_)
    local _image_Drawing = _current_dialogue_list[_dialogue_text_index].image
        
    local _texture_NameText = CreateTexture(_image_NameText)
    local _texture_TextText = CreateTexture(_image_TextText)
    local _texture_Drawing = CreateTexture(_image_Drawing)

    local _width_image_NameText, _height_image_NameText = GetImageSize(_image_NameText)
    local _width_image_TextText, _height_image_TextText = GetImageSize(_image_TextText)
    local _width_image_Drawing, _height_image_Drawing = GetImageSize(_image_Drawing)
    _width_image_Drawing, _height_image_Drawing = _width_image_Drawing * 0.8, _height_image_Drawing * 0.8
    
    CopyTexture(_texture_Drawing, {x = _window_width / 2 - _width_image_Drawing / 2, y = -100, w = _width_image_Drawing, h = _height_image_Drawing})
    CopyTexture(_texture_Textbox, {x = 0, y = _window_height - _height_image_Textbox - _window_height * 0.05, w = _width_image_Textbox, h = _height_image_Textbox})
    
    CopyTexture(_texture_NameText, {x = 225, y = 515, w = _width_image_NameText, h = _height_image_NameText})
    CopyTexture(_texture_TextText, {x = 275, y = 575, w = _width_image_TextText, h = _height_image_TextText})
    
    if _isChioce_Showing then
        local _x, _y = GetCursorPosition()
        if _x > _RECT_CHOICE_1_.x and _x < _RECT_CHOICE_1_.x + _RECT_CHOICE_1_.w and _y > _RECT_CHOICE_1_.y and _y < _RECT_CHOICE_1_.y + _RECT_CHOICE_1_.h then
            CopyTexture(_texture_ChoiceHover, _RECT_CHOICE_1_)
        else
            CopyTexture(_texture_ChoiceNormal, _RECT_CHOICE_1_)
        end
        if _x > _RECT_CHOICE_2_.x and _x < _RECT_CHOICE_2_.x + _RECT_CHOICE_2_.w and _y > _RECT_CHOICE_2_.y and _y < _RECT_CHOICE_2_.y + _RECT_CHOICE_2_.h then
            CopyTexture(_texture_ChoiceHover, _RECT_CHOICE_2_)
        else
            CopyTexture(_texture_ChoiceNormal, _RECT_CHOICE_2_)
        end

        local _image_Choice_1_Text = CreateUTF8TextImageBlended(_FONT_TEXT_, _text_Choice_1, _COLOR_TEXT_TEXT_)
        local _image_Choice_2_Text = CreateUTF8TextImageBlended(_FONT_TEXT_, _text_Choice_2, _COLOR_TEXT_TEXT_)
        local _texture_Choice_1_Text = CreateTexture(_image_Choice_1_Text)
        local _texture_Choice_2_Text = CreateTexture(_image_Choice_2_Text)
        local _width_image_Choice_1_Text, _height_image_Choice_1_Text = GetImageSize(_image_Choice_1_Text)
        local _width_image_Choice_2_Text, _height_image_Choice_2_Text = GetImageSize(_image_Choice_2_Text)
        CopyTexture(_texture_Choice_1_Text, {
            x = _window_width / 2 - _width_image_Choice_1_Text / 2,
            y = _RECT_CHOICE_1_.y + 5,
            w = _width_image_Choice_1_Text,
            h = _height_image_Choice_1_Text
        })
        CopyTexture(_texture_Choice_2_Text, {
            x = _window_width / 2 - _width_image_Choice_2_Text / 2,
            y = _RECT_CHOICE_2_.y + 5,
            w = _width_image_Choice_2_Text,
            h = _height_image_Choice_2_Text
        })
        _FreeRenderResWhenUpdating({_image_Choice_1_Text, _image_Choice_2_Text}, {_texture_Choice_1_Text, _texture_Choice_2_Text})
    end
    
    _FreeRenderResWhenUpdating({_image_NameText, _image_TextText}, {_texture_NameText, _texture_TextText, _texture_Drawing})
end

function LeadingScene.Unload()
    DestroyTexture(_texture_Background)
    DestroyTexture(_texture_Textbox)
    DestroyTexture(_texture_ChoiceNormal)
    DestroyTexture(_texture_ChoiceHover)
    
    UnloadImage(_image_Background)
    UnloadImage(_image_Textbox)
    UnloadImage(_image_ChoiceNormal)
    UnloadImage(_image_WarriorNormal)
    UnloadImage(_image_WarriorSad)
    UnloadImage(_image_WarriorScared)
    UnloadImage(_image_WarriorAngry)
    
    UnloadFont(_FONT_NAME_)
    UnloadFont(_FONT_TEXT_)
    UnloadFont(_FONT_CHOICE_)

    UnloadMusic(_music_Background)
    UnloadSound(_sound_Keyboard)
end

return LeadingScene
