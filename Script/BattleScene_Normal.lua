SceneManager = require("SceneManager")

BattleScene_Normal = {}

BattleScene_Normal.name = "BattleScene_Normal"

local _window_width, _window_height = GetWindowSize()

local _FONT_HP_ = nil
local _FONT_TIP_ = nil

local _COLOR_CLEAR_ = {r = 0, g = 0, b = 0, a = 75}
local _COLORLIST_ENEMY_ = {
    {r = 162, g = 215, b = 221, a = 255},
    {r = 242, g = 242, b = 176, a = 255},
    {r = 246, g = 191, b = 188, a = 255},
    {r = 104, g = 190, b = 141, a = 255},
    {r = 133, g = 104, b = 89, a = 255}
}

local _RECT_PLAYER_HP_BAR_ = {x = 50, y = 35, w = 250, h = 30}
local _RECT_RIDER_HP_BAR_ = {x = _window_width - 300, y = 35, w = 250, h = 30}

local _ENEMY_SIZE_ = 13
local _ENEMY_GENERATE_DELAY_ = 40

local _RIDER_HP_DECREASE_DELAY_ = 45
local _PLAYER_HP_DECREASE_DELAY_ = 35

local _hp = 100
local _speed = 10
local _colors_player = {{r = 197, g = 61, b = 67, a = 255}, {r = 2, g = 135, b = 96, a = 255}}

local _rider_hp = 100

local _timer_enemy_generate = 0
local _timer_rider_hp_decrease = 0
local _timer_player_hp_decrease = 0

local _player_x, _player_y = _window_width / 2, _window_height / 2

local _move_up, _move_down, _move_left, _move_right = false, false, false, false

local _isReserveMode = false

local _tips_text = {"接受正义的审判吧！", "你似乎熟悉了我的攻击方式，真是有趣的事情呢！", "反转一切！", "卑微的下民，你的行动怎么慢下来了！", "看样子你已经撑不住了！"}

local _tips_text_index = 1

local _enemy_list = {}

local _music_Background = nil

local function _FadeOut()
    SetDrawColor({r = 0, g = 0, b = 0, a = 15})
    for i = 1, 100 do
        FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
        UpdateWindow()
        Sleep(10)
    end
end

local function _DrawPlayer()
    if _isReserveMode then SetDrawColor(_colors_player[2]) else SetDrawColor(_colors_player[1]) end
    FillTriangle({x = _player_x, y = _player_y}, {x = _player_x, y = _player_y - 20}, {x = _player_x - 10, y = _player_y + 10})
    FillTriangle({x = _player_x, y = _player_y}, {x = _player_x, y = _player_y - 20}, {x = _player_x + 10, y = _player_y + 10})
end

local function _DrawPlayerHpField()
    -- 绘制白色HP条外边框
    SetDrawColor({r = 255, g = 255, b = 255, a = 255})
    FillRectangle(_RECT_PLAYER_HP_BAR_)
    SetDrawColor({r = 0, g = 0, b = 0, a = 255})
    FillRectangle({x = _RECT_PLAYER_HP_BAR_.x + 3, y = _RECT_PLAYER_HP_BAR_.y + 3, w = _RECT_PLAYER_HP_BAR_.w - 6, h = _RECT_PLAYER_HP_BAR_.h - 6})
    -- 绘制当前血量条
    if _isReserveMode then SetDrawColor(_colors_player[2]) else SetDrawColor(_colors_player[1]) end
    if _hp > 0 then FillRectangle({x = _RECT_PLAYER_HP_BAR_.x + 3, y = _RECT_PLAYER_HP_BAR_.y + 3, w = (_RECT_PLAYER_HP_BAR_.w - 6) * (_hp / 100), h = _RECT_PLAYER_HP_BAR_.h - 6}) end
    -- 绘制血量值数值
    local _image_HpValueText
    if _hp > 0 then
        _image_HpValueText = CreateUTF8TextImageBlended(_FONT_HP_, _hp, {r = 255, g = 255, b = 255, a = 255})
    else
        _image_HpValueText = CreateUTF8TextImageBlended(_FONT_HP_, 0, {r = 255, g = 255, b = 255, a = 255})
    end
    local _texture_HpValueText = CreateTexture(_image_HpValueText)
    local _width_image_HpValueText, _height_image_HpValueText = GetImageSize(_image_HpValueText)
    CopyTexture(_texture_HpValueText, {x = _RECT_PLAYER_HP_BAR_.x + _RECT_PLAYER_HP_BAR_.w + 20, y = _RECT_PLAYER_HP_BAR_.y, w = _width_image_HpValueText, h = _height_image_HpValueText})
    DestroyTexture(_texture_HpValueText)
    UnloadImage(_image_HpValueText)
end

local function _DrawRiderHpField()
    -- 绘制白色HP外边框
    SetDrawColor({r = 255, g = 255, b = 255, a = 255})
    FillRectangle(_RECT_RIDER_HP_BAR_)
    SetDrawColor({r = 0, g = 0, b = 0, a = 255})
    FillRectangle({x = _RECT_RIDER_HP_BAR_.x + 3, y = _RECT_RIDER_HP_BAR_.y + 3, w = _RECT_RIDER_HP_BAR_.w - 6, h = _RECT_RIDER_HP_BAR_.h - 6})
    -- 绘制蓝色当前血量条
    SetDrawColor({r = 39, g = 146, b = 145, a = 255})
    if _rider_hp > 0 then FillRectangle({x = _RECT_RIDER_HP_BAR_.x + 3, y = _RECT_RIDER_HP_BAR_.y + 3, w = (_RECT_RIDER_HP_BAR_.w - 6) * (_rider_hp / 100), h = _RECT_RIDER_HP_BAR_.h - 6}) end
    -- 绘制骑士名字
    local _image_HpValueText = CreateUTF8TextImageBlended(_FONT_HP_, "骑士", {r = 255, g = 255, b = 255, a = 255})
    local _texture_HpValueText = CreateTexture(_image_HpValueText)
    local _width_image_HpValueText, _height_image_HpValueText = GetImageSize(_image_HpValueText)
    CopyTexture(_texture_HpValueText, {x = _RECT_RIDER_HP_BAR_.x - _width_image_HpValueText - 20, y = _RECT_RIDER_HP_BAR_.y, w = _width_image_HpValueText, h = _height_image_HpValueText})
    DestroyTexture(_texture_HpValueText)
    UnloadImage(_image_HpValueText)
end

local function _DrawTipText()
    local _image_TipText = CreateUTF8TextImageBlended(_FONT_TIP_, _tips_text[_tips_text_index], {r = 255, g = 255, b = 255, a = 255})
    local _texture_TipText = CreateTexture(_image_TipText)
    local _width_image_TipText, _height_image_TipText = GetImageSize(_image_TipText)
    local _rect_TipText = {
        x = _window_width / 2 - _width_image_TipText / 2,
        y = _window_height - _height_image_TipText - 50,
        w = _width_image_TipText,
        h = _height_image_TipText
    }
    -- 绘制白色提示框
    SetDrawColor({r = 255, g = 255, b = 255, a = 255})
    FillRectangle({x = _rect_TipText.x - 100, y = _rect_TipText.y - 10, w = _rect_TipText.w + 200, h = _rect_TipText.h + 20})
    SetDrawColor({r = 0, g = 0, b = 0, a = 255})
    FillRectangle({x = _rect_TipText.x - 97, y = _rect_TipText.y - 7, w = _rect_TipText.w + 194, h = _rect_TipText.h + 14})
    CopyTexture(_texture_TipText, _rect_TipText)
    DestroyTexture(_texture_TipText)
    UnloadImage(_image_TipText)
end

local function _ClearWindow()
    SetDrawColor(_COLOR_CLEAR_)
    FillRectangle({x = 0, y = 0, w = _window_width, h = _window_height})
end

local function _GenerateEnemies()
    local _point_center_x, _point_center_y = math.random(100, _window_width - 100), math.random(100, _window_height - 100)
    local _meta_speeds = {
        {x = 1, y = 0}, {x = 0.707, y = -0.707}, {x = 0, y = -1}, {x = -0.707, y = -0.707},
        {x = -1, y = 0}, {x = -0.707, y = 0.707}, {x = 0, y = 1}, {x = 0.707, y = 0.707}
    }
    local _speed = math.random(2, 10)
    local _color = _COLORLIST_ENEMY_[math.random(1, #_COLORLIST_ENEMY_)]
    for _, _meta_speed in ipairs(_meta_speeds) do
        table.insert(_enemy_list, {
            color = _color,
            speed = {x = _meta_speed.x * _speed, y = _meta_speed.y * _speed},
            position = {x = _point_center_x, y = _point_center_y}
        })
    end
end

local function _UpdateEnemies()
    for index, enemy in pairs(_enemy_list) do
        if enemy.position.x > 0 and enemy.position.x < _window_width and enemy.position.y > 0 and enemy.position.y < _window_height then
            if math.sqrt((enemy.position.x - _player_x) ^ 2 + (enemy.position.y - _player_y) ^ 2) <= _ENEMY_SIZE_ then
                if _isReserveMode then
                    -- 反转模式下碰触回血
                    if _hp < 100 then
                        _hp = _hp + 6
                    end
                else
                    if _hp > 0 then
                        _hp = _hp - 10
                    end
                end
                table.remove(_enemy_list, index)
            end
            enemy.position.x = enemy.position.x + enemy.speed.x
            enemy.position.y = enemy.position.y + enemy.speed.y
        else
            table.remove(_enemy_list, index)
        end
    end
end

local function _DrawEnemies()
    for _, enemy in pairs(_enemy_list) do
        SetDrawColor(enemy.color)
        FillCircle({x = enemy.position.x, y = enemy.position.y}, _ENEMY_SIZE_)
    end
end

function BattleScene_Normal.Init()
    SceneManager.ClearWindowWhenUpdate = false
    
    _FONT_HP_ = LoadFont("./Resource/Font/SIMYOU.TTF", 25)
    _FONT_TIP_ = LoadFont("./Resource/Font/SIMYOU.TTF", 35)
    
    _music_Background = LoadMusic("./Resource/Audio/bgm_2.ogg")
    
    FadeInMusic(_music_Background, -1, 1000)
    SetMusicVolume(50)
end

function BattleScene_Normal.Update()
    _ClearWindow()
    
    if UpdateEvent() then
        local _event = GetEventType()
        if _event == EVENT_QUIT then
            SceneManager.Quit()
            return
        elseif _event == EVENT_KEYDOWN_UP then
            _move_up = true
        elseif _event == EVENT_KEYUP_UP then
            _move_up = false
        elseif _event == EVENT_KEYDOWN_DOWN then
            _move_down = true
        elseif _event == EVENT_KEYUP_DOWN then
            _move_down = false
        elseif _event == EVENT_KEYDOWN_LEFT then
            _move_left = true
        elseif _event == EVENT_KEYUP_LEFT then
            _move_left = false
        elseif _event == EVENT_KEYDOWN_RIGHT then
            _move_right = true
        elseif _event == EVENT_KEYUP_RIGHT then
            _move_right = false
        elseif _event == EVENT_KEYDOWN_1 then
            _hp = _hp - 1
        end
    end
    
    if _move_up then if _player_y > _speed then _player_y = _player_y - _speed end end
    if _move_down then if _player_y < _window_height - _speed then _player_y = _player_y + _speed end end
    if _move_left then if _player_x > _speed then _player_x = _player_x - _speed end end
    if _move_right then if _player_x < _window_width - _speed then _player_x = _player_x + _speed end end
    
    if _timer_enemy_generate >= _ENEMY_GENERATE_DELAY_ then
        _GenerateEnemies()
        _timer_enemy_generate = 0
    else
        _timer_enemy_generate = _timer_enemy_generate + 1
    end
    
    if _timer_rider_hp_decrease >= _RIDER_HP_DECREASE_DELAY_ then
        if _rider_hp > 0 then
            _rider_hp = _rider_hp - 1
        end
        _timer_rider_hp_decrease = 0
    else
        _timer_rider_hp_decrease = _timer_rider_hp_decrease + 1
    end
    
    if _isReserveMode and _timer_player_hp_decrease >= _PLAYER_HP_DECREASE_DELAY_ then
        if _hp >= 2 then
            _hp = _hp - 2
        end
        _timer_player_hp_decrease = 0
    else
        _timer_player_hp_decrease = _timer_player_hp_decrease + 1
    end
    
    if _rider_hp <= 50 and _rider_hp > 40 then
        -- 骑士血量在40~50期间，更换标语
        _tips_text_index = 2
    elseif _rider_hp <= 43 and _rider_hp > 0 then
        -- 骑士血量在0~43期间，更换标语并启动反转模式
        _tips_text_index = 3
        _isReserveMode = true
    elseif _rider_hp <= 0 then
        -- 骑士血量归零，切换到成功场景
        FadeOutMusic(1000)
        _FadeOut()
        SceneManager.LoadScene("VictoryScene")
        return
    end
    
    if _hp <= 80 and _hp > 60 then
        -- 玩家血量在60~80期间，第一次减速，更换标语
        _speed = 6
        if _tips_text_index ~= 2 and _tips_text_index ~= 3 then _tips_text_index = 4 end
    elseif _hp <= 50 and _hp > 40 then
        -- 玩家血量在40~50期间，第二次减速
        _speed = 5
    elseif _hp <= 40 and _hp > 0 then
        -- 玩家血量在0~40期间，第三次减速，更换标语
        _speed = 4
        if _tips_text_index ~= 2 and _tips_text_index ~= 3 then _tips_text_index = 5 end
    elseif _hp <= 0 then
        -- 玩家血量归零，切换到失败场景
        FadeOutMusic(1000)
        _FadeOut()
        SceneManager.LoadScene("FailureScene")
        return
    end
    
    _UpdateEnemies()
    _DrawEnemies()
    _DrawPlayer()
    _DrawPlayerHpField()
    _DrawRiderHpField()
    _DrawTipText()
end

function BattleScene_Normal.Unload()
    UnloadFont(_FONT_HP_)
    UnloadFont(_FONT_TIP_)
    UnloadMusic(_music_Background)
end

return BattleScene_Normal
