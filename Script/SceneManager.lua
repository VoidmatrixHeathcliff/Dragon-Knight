--[[ 场景管理器 ]]--
SceneManager = {}

-- 帧率
local __FPS__ = 60

-- 窗口标题
local __TITLE__ = "EtherEngine 示例游戏 - 巨龙与骑士"

-- 启动场景
local _start_scene = nil

-- 当前场景
local _current_scene = nil

-- 场景列表
local _scene_list = {}

-- 游戏退出事件触发时处理函数
local _quit_handler = nil

-- 是否进行游戏主循环
local _is_running = false

SceneManager.ClearWindowWhenUpdate = true

--[[
    卸载当前场景：调用当前场景的卸载回调函数
    参数：无
    返回值：无
--]]
local function _UnloadCurrentScene()
    if _current_scene then
        _current_scene.Unload()
    end
end

--[[
    初始化场景管理器
    参数：无
    返回值：无
--]]
function SceneManager.Init()
    CreateWindow(__TITLE__, {x = -1, y = -1, w = 1280, h = 720}, {})
end

--[[
    设置启动场景
    参数：启动场景
    返回值：无
--]]
function SceneManager.SetStartScene(scene)
    assert(type(scene) == "table", "SceneManager.SetStartScene()：参数必须为table类型")
    _start_scene = scene
end

--[[
    添加新场景
    参数：新场景
    返回值：无
--]]
function SceneManager.AddScene(scene)
    assert(type(scene) == "table", "SceneManager.AddScene()：参数必须为table类型")
    table.insert(_scene_list, scene)
end

--[[
    加载指定名字的场景：卸载当前场景并加载新场景
    参数：新场景名字
    返回值：无
--]]
function SceneManager.LoadScene(name)
    assert(type(name) == "string", "SceneManager.LoadScene()：参数必须为string类型")
    for _, scene in pairs(_scene_list) do
        if scene.name == name then
            _UnloadCurrentScene()
            _current_scene = scene
            _current_scene.Init()
            return
        end
    end

    error("SceneManager.LoadScene()：找不到指定名称的场景")
end

--[[
    设置游戏退出时的回调函数
    参数：回调函数
    返回值：无
--]]
function SceneManager.SetQuitHandler(callback)
    assert(type(callback) == "function", "SceneManager.SetQuitHandler()：参数必须为function类型")
    _quit_handler = callback
end

--[[
    启动游戏主循环
    参数：无
    返回值：无
--]]
function SceneManager.Mainloop()
    _is_running = true
    assert(type(_start_scene) == "table", "SceneManager.Mainloop()：启动场景未设置")
    _current_scene = _start_scene
    _current_scene.Init()
    while _is_running do
        local _frame_start_time = GetInitTime()

        if SceneManager.ClearWindowWhenUpdate then ClearWindow() end

        _current_scene.Update()
        UpdateWindow()

        local _frame_end_time = GetInitTime()
        local _frame_delay = _frame_end_time - _frame_start_time
        if _frame_delay < 1000 / __FPS__ then
            Sleep(1000 / __FPS__ - _frame_delay)
        end
    end
end

--[[
    退出程序主循环
    参数：无
    返回值：无
--]]
function SceneManager.Quit()
    assert(_quit_handler, "SceneManager.Quit()：游戏退出回调函数未设置")
    if _quit_handler() then
        _UnloadCurrentScene()
        _is_running = false
    end
end


return SceneManager