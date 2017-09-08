
require "Common/define"

local transform;
local gameObject;

GameSelectPanel = {};
local this = GameSelectPanel;


--��ʼ�����--
function GameSelectPanel.InitPanel(obj)
	gameObject = obj;
	transform = obj.transform;
	
	gameObject_luabe = gameObject:AddComponent(typeof(LuaBehaviour))
	
    local xinshoubtn = transform:Find("XinShou/XinShou_Button").gameObject;
	local gaojibtn = transform:Find("Gaoji/GaoJi_Button").gameObject;
	local dashibtn = transform:Find("Dashi/DaShi_Button").gameObject;
	
	gameObject_luabe:AddClick(xinshoubtn,OnClickXinShou)
	gameObject_luabe:AddClick(gaojibtn,OnClickGaoJi)
	gameObject_luabe:AddClick(dashibtn,OnClickDaShi)
	
end

--�����¼�--
function GameSelectPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

local logininfo = {}

function OnClickXinShou(go)
 
  MyPeer.SendMsg(4,logininfo)
end

function OnClickGaoJi(go)
 
  
  MyPeer.SendMsg(5,logininfo)

end

function OnClickDaShi(go)
 
  
  MyPeer.SendMsg(6,logininfo)

end