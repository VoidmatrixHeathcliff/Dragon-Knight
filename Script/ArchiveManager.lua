--[[ 存档管理器 ]] --
ArchiveManager = {}

-- 归档
local _archive = nil

-- 归档文件名称
local _archive_name = nil

-- 当前选中的Table
local _current_table = nil

--[[
    打开指定名称的归档文件
    参数：无
    返回值：无
--]]
function ArchiveManager.OpenArchive(name)
    _archive = require(name)
    _archive_name = name
end

--[[
    检查指定名称的Table是否存在
    参数：Table名称
    返回值：是否存在
--]]
function ArchiveManager.HashTable(name)
    if _archive[name] then return true else return false end
end

--[[
    新建指定名称的Table
    参数：Table名称
    返回值：无
--]]
function ArchiveManager.NewTable(name)
    assert(_archive, "ArchiveManager.NewTable()：未打开归档文件")
    assert(type(name) == "string", "ArchiveManager.NewTable()：参数必须为string类型")
    assert(not _archive[name], "ArchiveManager.NewTable()：指定名称的Table已存在")
    _archive[name] = {}
end

--[[
    删除指定名称的Table
    参数：Table名称
    返回值：无
--]]
function ArchiveManager.DeleteTable(name)
    assert(_archive, "ArchiveManager.DeleteTable()：未打开归档文件")
    assert(type(name) == "string", "ArchiveManager.DeleteTable()：参数必须为string类型")
    assert(_archive[name], "ArchiveManager.DeleteTable()：指定名称的Table不存在")
    _archive[name] = nil
end

--[[
    选中指定名称的Table
    参数：Table名称
    返回值：无
--]]
function ArchiveManager.SelectTable(name)
    assert(_archive, "ArchiveManager.SelectTable()：未打开归档文件")
    assert(type(name) == "string", "ArchiveManager.SelectTable()：参数必须为string类型")
    assert(_archive[name], "ArchiveManager.SelectTable()：指定名称的Table不存在")
    _current_table = _archive[name]
end

--[[
    设置当前选中Table的数据
    参数：键，值
    返回值：无
--]]
function ArchiveManager.SetData(key, value)
    assert(_archive, "ArchiveManager.SetData()：未打开归档文件")
    assert(_current_table, "ArchiveManager.SetData()：未选中数据存储表")
    assert(type(key) == "string", "ArchiveManager.SetData()：key必须为string类型")
    assert(type(value) == "nil" or type(value) == "boolean" or type(value) == "number" or type(value) == "string",
        "ArchiveManager.SetData()：value必须为nil、boolean、number、string类型中的一个")
    _current_table[key] = value
end

--[[
    获取当前选中Table的指定键对应的值
    参数：键
    返回值：键对应的值
--]]
function ArchiveManager.GetData(key)
    assert(_archive, "ArchiveManager.GetData()：未打开归档文件")
    assert(_current_table, "ArchiveManager.GetData()：未选中数据存储表")
    assert(type(key) == "string", "ArchiveManager.GetData()：key必须为string类型")
    return _current_table[key]
end

--[[
    转储当前归档到文件
    参数：无
    返回值：无
--]]
function ArchiveManager.DumpArchive()
    assert(_archive, "ArchiveManager.DumpArchive()：未打开归档文件")
    local _file = io.open("./Archive/".._archive_name..".data", "w+")
    local _content = "return{"
    for name, table in pairs(_archive) do
        if table then
            _content = _content..name.."={"
            for key, value in pairs(table) do
                if value then
                    _content = _content..key.."="
                    if type(value) == "boolean" then
                        if value then
                            _content = _content.."true,"
                        else
                            _content = _content.."false,"
                        end
                    elseif type(value) == "string" then
                        _content = _content.."\""..value.."\","
                    else
                        _content = _content..value..","
                    end
                end
            end
            _content = _content.."},"
        end
    end
    _content = _content.."}"
    _file:write(_content)
    _file:close()
end

--[[
    关闭已打开的归档文件
    参数：无
    返回值：无
--]]
function ArchiveManager.CloseArchive()
    assert(_archive, "ArchiveManager.CloseArchive()：未打开归档文件")
    _archive = nil
end

return ArchiveManager
