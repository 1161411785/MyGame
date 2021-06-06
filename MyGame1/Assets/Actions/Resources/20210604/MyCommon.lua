

--[[
    一句话功能简述
    功能详细描述及注意事项
    @param1 参数1 参数1说明
    @param2 参数2 参数2说明
    @return 返回类型说明
    @exception/throws 违例类型 违例说明
    @see 类、类#方法、类#成员
    @deprecated
]]
-- 模拟一个面向对象的类
local mt = {}
function mt:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


-- string字符串处理相关

--返回当前字符实际占用的字符数
--[[
    返回当前字符实际占用的字符数
    功能详细描述及注意事项
    @param str
    @param index
    @return 返回当前字符实际占用的字符数
]]
local function SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end

--获取中英混合UTF8字符串的真实字符数量
local function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

--获取中英混合UTF8字符串的真实字符数量
local function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end


-- 截取中英文混合的字符串 --
local function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end


-- lua字符串全部转为大写
local function StringUpper(s)
    local str = string.upper(s)
    return str
end

-- 字符串全部转为小写
local function StrLower(s)
    local str = string.lower(s)
    return str
end

-- 字符串分割
local function StrSplit()
    
end
    
end



-- GameObject相关

-- 获取gameObject在Hierarhy下的路径
--[[
    * 获取gameObject在Hierarhy下的路径
    * @param1 gameObject类型，需要获取的路径的节点
    * @return 无返回值
    * @exception/throws [违例类型] [违例说明]
---]]
local function GetGameObjectPath(gameObject)
    local path = "";
    local tmpTransform = gameObject.transform;
    while tmpTransform ~= nil and tmpTransform ~= null do
        path = "/" .. tmpTransform.name .. path;
        tmpTransform = tmpTransform.parent;
    end
    return string.sub(path, 2);
end


--根据表的长度创建子物体
local function InstantiateByTab(tab,parentObj,templateObj)
    local tabLength = 0
	local childCount = parentObj.transform.childCount
    local objTab = {}
	-- 渲染回放记录
	for k,v in pairs(tab) do
		tabLength = tabLength + 1
		local itemObj = nil
		if childCount >= tabLength then
			itemObj = parentObj.transform:GetChild(tabLength - 1)
		else
			itemObj = UnityEngine.GameObject.Instantiate(templateObj)
		end
        itemObj.transform:SetParent(parentObj.transform, false)
		itemObj.gameObject:SetActive(true)
		itemObj.transform.localScale = UnityEngine.Vector3.one
        table.insert(objTab,itemObj)
    end
    DestroyChild(parentObj,tabLength)
    return objTab
end

-- 同步销毁多余的子物体
local function DestroyChild(childParent,needCount)
    local childCount = childParent.transform.childCount
    if tonumber(childCount) <= tonumber(needCount) then
        return
    end
    for index = childCount -1 ,needCount, -1 do
        local curChildCount = childParent.transform.childCount
        if tonumber(curChildCount) <= 4 then
            childParent.transform:GetChild(index).gameObject:SetActive(false)
        else
            -- 同步销毁
            UnityEngine.GameObject.DestroyImmediate(childParent.transform:GetChild(index).gameObject)
        end
    end
end

-- NGUI 添加按钮绑定事件
local function NGUIButtonEvent(go,func,...)
    UIEventListener.Get(go).onClick = func(...)
end

-- 添加锚点
local function AddAnchor()
    local titleAnchor = curTableWeek.transform:GetComponent("UIWidget")
    titleAnchor:SetAnchor(lteMatchItem)
    titleAnchor.leftAnchor:Set(0, 0)
    titleAnchor.rightAnchor:Set(0, 629)
    titleAnchor.topAnchor:Set(1, 48)
    titleAnchor.bottomAnchor:Set(1, 20)
end

-- 动态修改游戏物体位置
local function SetPosition(Obj,vec3)
    Obj.transform.localPosition=UnityEngine.Vector3(vec3[1],vec3[2],vec3[3])
end

-- 动态修改Ngui scrollView 的位置
local function SetScrollViewPosition(SCGameObject,vec4)
    if SCGameObject then
        SCGameObject.transform:GetComponent("UIPanel").clipRange = UnityEngine.Vector4(vec4[1],vec4[2],vec4[3],vec4[4])
    end
end

-- 重制NGUI Scroll View 位置
local function ResetSVPosition(scrollViewObj)
	scrollViewObj.transform:GetComponent("UIScrollView"):Reposition()
	scrollViewObj.transform:Find("Grid"):GetComponent("UIGrid"):ResetPosition()
end

-- 使用SpringPanel组件动态修改Scroll view 内容的位置
local function SetAniSVPosition(scrollViewObj)
    local selcetIndex = 0
    if selcetIndex == 1 then
        selcetIndex = #self.playerData
    else
        selcetIndex = selcetIndex -1
    end
    lastSelectObj:SetActive(false)
    lastSelectObj = self.leftGrid.transform:GetChild(selcetIndex - 1):Find("Sprite_select").gameObject
    lastSelectObj:SetActive(true)
    self:RenderPlayerStatus(self.playerData[selcetIndex])

    local moveIndex = selcetIndex
    if moveIndex <= 4 then
        moveIndex = 0
    elseif 4 < moveIndex and moveIndex <= #self.playerData - 4 then
        moveIndex = moveIndex - 4
    else
        moveIndex = #self.playerData - 6
    end
    local TablePosititon = 74 * moveIndex
    local SpringPanel = self.leftScrollView.transform:GetComponent("SpringPanel")
    SpringPanel.Begin(self.leftScrollView, UnityEngine.Vector3(-418, 47+TablePosititon, 0),10)
end






-- table类

--[[
    * 对table表进行排序
    * @param1 [tab] [需要进行排序的table表]
    * @param2 [SortType] [默认为从小到大排序 SortType = “1”时进行从大到小排序]
    * @param3 [par] [当表的元素需要进行下层索引的时候进行传递对应的索引例如对 a["sort"]进行排序，则需要传"sort"]
    * @return 无返回值
    * @exception/throws [违例类型] [违例说明]
---]]
local function SortTable(tab,SortType,par)
    table.sort(tab,function (a,b)
        if par then
            if SortType and tostring(SortType) == "1" then
                return tonumber(a[par]) > tonumber(b[par])
            else
                return tonumber(a[par]) < tonumber(b[par])
            end
        else
            if SortType and tostring(SortType) == "1" then
                return tonumber(a) > tonumber(b)
            else
                return tonumber(a) < tonumber(b)
            end
        end
    end)
end

-- 获取table表的真实长度
local function GetTabLong(t)
    local i = 0
    if t then
        for k,v in pairs(t) do
            i = i + 1
        end
    end
    return i
end






-- lua垃圾回收机制

-- lua层垃圾回收
local function LuaGC()
    collectgarbage("collect");
end

-- 获取当前内存占用
local function GetGcCount()
    collectgarbage("count")
end

-- 垃圾回收当前是否在工作
local function IsWorkGc()
    return collectgarbage("isrunning")
end

