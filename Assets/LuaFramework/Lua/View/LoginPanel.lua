
require "Common/define"

local transform;
local gameObject;

LoginPanel = {};
local this = LoginPanel;


--��ʼ�����--
function LoginPanel.InitPanel(obj)
	gameObject = obj;
	transform = obj.transform;
    local loginbtn = transform:Find("Login_Button").gameObject;
    local regbtn = transform:Find("Register").gameObject;
	gameObject_luabe = gameObject:AddComponent(typeof(LuaBehaviour))
	gameObject_luabe:AddClick(loginbtn,OnClickAddFinish)
    gameObject_luabe:AddClick(regbtn,OnClickReg)
	
end

--�����¼�--
function LoginPanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

local logininfo = {}
function OnClickAddFinish(go)
  logininfo[1] = "sb"
  logininfo[2] = "123"
  
  MyPeer.SendMsg(1,logininfo)

end

function OnClickReg(go)
  Util.Log("�������")
  ProtoSerTest(101,"asdadasdasdas")
  
end

