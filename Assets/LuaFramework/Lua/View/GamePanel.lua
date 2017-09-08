
require "Common/define"
require "View/PanelsMag"

local gameObject
local gameObject_luabe

GamePanel = {}
local this = GamePanel

local roomid

local player_0_id            -- ���id�����
local player_1_id      -- �����id�����
local player_2_id       -- �����id�����

local player_0_touxiang    -- ͷ��
local player_1_touxiang
local player_2_touxiang

local player_0_shenfen   -- ���
local player_1_shenfen
local player_2_shenfen

local player_1_go
local player_2_go

local player_0_id_text
local player_1_id_text 
local player_2_id_text

local player_0_readytext
local player_1_readytext
local player_2_readytext

local readybtn 
local quxiaoreadybtn

local pais0     -- װ�Ƶ� ����
local allkapaigameobject = {} --���п��ƶ���

local currentcards = {} -- ��ǰ�������
local cardwidth = 40  -- ���￨��¶���Ŀ�ȡ�

local jiaofen   -- �з�gameobject
local Fen_Button_0  --  ����
local Fen_Button_1  --  һ�� �� button ��gameobject
local Fen_Button_2   --  ���� �� button
local Fen_Button_3  --  ���� �� button 

local sendcardordesend -- ���� ���� ��ʾ  �ĸ�����
local sendcardbutton  -- ���� ��ť
local desendcardbutton  -- ���� ��ť
local tishibutton        -- ��ʾ ��ť

local DiPais   --  ���� ������
 local cards  --���Ƴ�
local threedipai = {}

local pitchupcard = {}  -- ѡ�е� ��
--��ʼ�����--
function GamePanel.InitPanel(obj,kapai)
	gameObject = obj;
		
	gameObject_luabe = gameObject:AddComponent(typeof(LuaBehaviour))
	readybtn = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/Ready_Button")
    quxiaoreadybtn =PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/QuXiaoRead_Button")  
	
    DiPais = PanelsMag.FindGameObjectByName(gameObject,"DiPais")  

	player_1_go =PanelsMag.FindGameObjectByName(gameObject,"Self_Player_1")
    player_2_go =PanelsMag.FindGameObjectByName(gameObject,"Self_Player_2")
	
	player_0_id_text =PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/Self_Info/PlayerID")
	player_1_id_text =PanelsMag.FindGameObjectByName(gameObject,"Self_Player_1/Self_Info/PlayerID")
	player_2_id_text =PanelsMag.FindGameObjectByName(gameObject,"Self_Player_2/Self_Info/PlayerID")

    player_0_touxiang = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/Self_Info/Self_TouXiang")
    player_1_touxiang = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_1/Self_Info/Self_TouXiang")
    player_2_touxiang = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_2/Self_Info/Self_TouXiang")	

    player_0_shenfen = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/Self_Info/Self_ShenFen")
    player_1_shenfen = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_1/Self_Info/Self_ShenFen")
    player_2_shenfen = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_2/Self_Info/Self_ShenFen")

	player_0_readytext = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/ReadyText")
    player_1_readytext = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_1/ReadyText")	
    player_2_readytext = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_2/ReadyText")		

    jiaofen = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/JiaoFen")	
    Fen_Button_0 = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/JiaoFen/0_Fen_Button")
    Fen_Button_1 = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/JiaoFen/1_Fen_Button")	
    Fen_Button_2 = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/JiaoFen/2_Fen_Button")	
    Fen_Button_3 = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/JiaoFen/3_Fen_Button")	
  
     sendcardordesend = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/SendCaoZuo")	
     sendcardbutton = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/SendCaoZuo/Send_Button") 
     desendcardbutton = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/SendCaoZuo/DeSend_Button")  
     tishibutton = PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/SendCaoZuo/Msg_Button")  

	gameObject_luabe:AddClick(readybtn,OnClickReady)
	gameObject_luabe:AddClick(quxiaoreadybtn,OnClickQuXiaoReady)
    gameObject_luabe:AddClick(Fen_Button_0,OnClickJiaoFenButton)
    gameObject_luabe:AddClick(Fen_Button_1,OnClickJiaoFenButton)
	gameObject_luabe:AddClick(Fen_Button_2,OnClickJiaoFenButton)
    gameObject_luabe:AddClick(Fen_Button_3,OnClickJiaoFenButton)
    gameObject_luabe:AddClick(sendcardbutton,OnClickSendCardButton)
	gameObject_luabe:AddClick(desendcardbutton,OnClickSendCardButton)
    gameObject_luabe:AddClick(tishibutton,OnClickSendCardButton)
    this.JiaoFenGameObject(false)   
    this.SendCardOrDesendGameObject(false)
    
	pais0 =  PanelsMag.FindGameObjectByName(gameObject,"Self_Player_0/Pais")
	
    cards = GameObject.FindGameObjectWithTag("Cards");
    for index,value in pairs(kapai) do
      value.transform:SetParent(cards.transform,false)
	  value.transform.localPosition = Vector3.New(0,0,0)
    end   
	allkapaigameobject = kapai  
    
end

--�����¼�--
function GamePanel.OnDestroy()
	logWarn("OnDestroy---->>>");
end

local logininfo = {}

function OnClickReady(go)
 
  MyPeer.SendMsg(7,logininfo)
  Util.Log("zhunbei")
end


function OnClickQuXiaoReady(go)
 
  MyPeer.SendMsg(8,logininfo)
  Util.Log("ȡ��׼��")
end

-- ������� �� �����ƶ�
function OnClickCard(go)
   local card_y = go.transform.localPosition.y
   local card_x = go.transform.localPosition.x
   if card_y == 40 then   
    go.transform.localPosition = Vector3.New(card_x,0,0)
    for index,value in pairs(pitchupcard) do
      if value == go then
        table.remove(pitchupcard,index)
       break
      end
    end      
   elseif card_y == 0 then
    go.transform.localPosition = Vector3.New(card_x,40,0)
    table.insert(pitchupcard,go)
   end
end

-- ��� �з� ��ť
function OnClickJiaoFenButton(go)
    local sendmsg = {}
    if go.name == "1_Fen_Button" then
         jiaofen:SetActive(false)
         sendmsg[1] = "1";
         MyPeer.SendMsg(9,sendmsg)
    elseif go.name == "2_Fen_Button" then
         jiaofen:SetActive(false)
         sendmsg[1] = "2";
         MyPeer.SendMsg(9,sendmsg)
    elseif  go.name == "3_Fen_Button" then
         jiaofen:SetActive(false)
         sendmsg[1] = "3";
         MyPeer.SendMsg(9,sendmsg)
    elseif  go.name == "0_Fen_Button" then
         jiaofen:SetActive(false)
         sendmsg[1] = "0";
         MyPeer.SendMsg(9,sendmsg)
    end
end

local sended_cards = {} -- ������

-- ��� ���ƣ���������ʾ ��ť
function OnClickSendCardButton(go)
   local sendmsg = {}
   local fadepais = ""
    if go.name == "Send_Button" then  -- ����         
         --sendcardordesend:SetActive(false)
         --sendmsg[1] = "10";
        sendmsg[1] = "1";  
        local sendpai_names = {}            
        for index,value in pairs(pitchupcard) do
          sendpai_names[index] = value:GetComponent(typeof(Image)).sprite.name
        end 
        local sendpai_sort_name = this.CardSort(sendpai_names)     
        sendmsg[2] = table.concat(sendpai_sort_name,",")   -- �������� 
        MyPeer.SendMsg(10,sendmsg)        
        
    elseif go.name == "DeSend_Button" then  -- ����
         sendcardordesend:SetActive(false)
        -- sendmsg[1] = "10";
         sendmsg[1] = "2";
         MyPeer.SendMsg(10,sendmsg)
         this.SendCardOrDesendGameObject(false)
    elseif  go.name == "Msg_Button" then  -- ��ʾ
        -- ��ʾ �� ʲô��
    end

   
end


function GamePanel.MeJionRoomTime(name)

   player_0_id = name
   player_0_id_text:GetComponent(typeof(Text)).text = player_0_id
end

-- ���뷿��
function GamePanel.OtherJionRoomTimeOne(playerids)
	      
     local player_num_inroom = 0
     for index,value in pairs(playerids) do
        if value == player_0_id then
          player_num_inroom = index
        end
     end
     
    if player_num_inroom == 1 then     
       if player_1_id == nil then
			if playerids[3] ~= nil and playerids[3] ~="" then
			  player_1_id = playerids[3]
	          player_1_go:SetActive(true)
              player_1_id_text:GetComponent(typeof(Text)).text = player_1_id
			end		
       end
	   if player_2_id == nil then
		  if playerids[2] ~= nil and playerids[2] ~="" then
			player_2_id = playerids[2]
	        player_2_go:SetActive(true)
            player_2_id_text:GetComponent(typeof(Text)).text = player_2_id
          end
	  end
    elseif player_num_inroom == 2 then
       if player_1_id == nil then
			if playerids[1] ~= nil and playerids[1] ~="" then
			  player_1_id = playerids[1]
	          player_1_go:SetActive(true)
              player_1_id_text:GetComponent(typeof(Text)).text = player_1_id
			end	
        end		
	    if player_2_id == nil then
		  if playerids[3] ~= nil and playerids[3] ~="" then
			player_2_id = playerids[3]
	        player_2_go:SetActive(true)
            player_2_id_text:GetComponent(typeof(Text)).text = player_2_id
          end
		end
    elseif player_num_inroom == 3 then
       if player_1_id == nil then
			if playerids[2] ~= nil and playerids[2] ~="" then
			  player_1_id = playerids[2]
	          player_1_go:SetActive(true)
              player_1_id_text:GetComponent(typeof(Text)).text = player_1_id
			end	
       end		
	    if	player_2_id == nil then
		  if playerids[1] ~= nil and playerids[1] ~="" then
			player_2_id = playerids[1]
	        player_2_go:SetActive(true)
            player_2_id_text:GetComponent(typeof(Text)).text = player_2_id
          end
		end
    end
				
end

--function GamePanel.OtherJionRoomTimeTwo(ids)

--       -- �㲥����Ϣ

--		if	player_1_id == nil then

--			player_1_id = ids
--	        player_1_go:SetActive(true)
--            player_1_id_text:GetComponent(typeof(Text)).text = player_1_id

--	    elseif	player_2_id == nil then

--			player_2_id = ids
--	        player_2_go:SetActive(true)
--            player_2_id_text:GetComponent(typeof(Text)).text = player_2_id
--		end

--end


-- ��� ׼����ť �� MyGameManager �����
function GamePanel.ReadyBtn(playerid)
	
	if playerid == player_0_id then
		
		readybtn:SetActive(false)
        quxiaoreadybtn:SetActive(true)
	    player_0_readytext:SetActive(true)
		
	elseif playerid == player_1_id then
		
		 player_1_readytext:SetActive(true)
		
	elseif playerid == player_2_id then
		
		 player_2_readytext:SetActive(true)		
		
	end
   
end


-- ��� ȡ��׼����ť �� MyGameManager �����
function GamePanel.QuXiaoReadyBtn(playerid)
    
	if playerid == player_0_id then
		
		player_0_readytext:SetActive(false)
		readybtn:SetActive(true)
        quxiaoreadybtn:SetActive(false)
		
	elseif playerid == player_1_id then
		
		player_1_readytext:SetActive(false)
		
	elseif playerid == player_2_id then
		
		player_2_readytext:SetActive(false)		
		
	end
	    	 
end

local jiaofen_id
function GamePanel.StartGame(kapais,kapaisprite,jiaofenid)
   
    local mycard = {} -- ��ǰ���Ӧ�÷��䵽����
  
	readybtn:SetActive(false)
    quxiaoreadybtn:SetActive(false)
    player_0_readytext:SetActive(false)
    player_1_readytext:SetActive(false)
	player_2_readytext:SetActive(false)	
	jiaofen_id = jiaofenid

    if player_0_id-player_1_id > 0 then
       if player_0_id - player_2_id>0 then
         -- �õ�ǰ17����
          Util.Log("q17")
          for i = 1,17 do
             mycard[i] = kapais[i]
           end
       else
         -- �õ��м�17����
           Util.Log("z17")
           for i = 18,34 do
             mycard[i-17] = kapais[i]
           end         
       end
    else
      if player_0_id - player_2_id>0 then
         -- �õ��м�17����
          Util.Log("z17")
          for i = 18,34 do          
             mycard[i-17] = kapais[i]
           end
       else
         -- �õ���17����
           Util.Log("h17")
           for i = 35,51 do
             mycard[i-34] = kapais[i]
           end
       end
    end
    
    for i= 52,54 do
         -- ����
       for iiii,vvvvv in pairs(kapaisprite) do    
        if kapais[i] == vvvvv.name then  
         allkapaigameobject[1].transform:SetParent(DiPais.transform,false)  
         allkapaigameobject[1].transform.localPosition = Vector3.New(110*(53-i),0,0)       
		 allkapaigameobject[1]:GetComponent(typeof(Image)).sprite = vvvvv   
         threedipai[i-51] = allkapaigameobject[1]
         table.remove(allkapaigameobject,1)   
         threedipai[i-51]:SetActive(true)
        end     
    end
    end
    --  ����
         
    -- mysortcard �� ����˳��� ��
    local mysortcard = this.CardSort(mycard)
 
    for i = 1,17 do          
       for iiii,vvvvv in pairs(kapaisprite) do           
        if mysortcard[i] == vvvvv.name then                    
        --allkapaigameobject[i]:SetActive(true)
		allkapaigameobject[1].transform:SetParent(pais0.transform,false)     
		allkapaigameobject[1]:GetComponent(typeof(Image)).sprite = vvvvv     
        currentcards[i] = allkapaigameobject[1]  
        table.remove(allkapaigameobject,1)           
        --this.HandCardTrim(currentcards)     
        break
        end
      end                
    end  
    StartCoroutine(this.ShowCard)
  
   -- to do ��ʾ �з�
end

-- ��ʾ����
 function GamePanel.ShowCard()
	        local c = 1

	        while c<=17 do
		        WaitForSeconds(0.2) 
		        currentcards[c]:SetActive(true)             
                currentcards[c].transform.localPosition = Vector3.New(20*(c-1),0,0)
                for  i = 1,c do
                   currentcards[i].transform.localPosition =currentcards[i].transform.localPosition - Vector3.New(20,0,0)
                end
             
		        c = c + 1
	        end    
    if jiaofen_id == player_0_id then
       this.JiaoFenGameObject(true)   
       Fen_Button_1:GetComponent(typeof(Button)).interactable = false
       Fen_Button_2:GetComponent(typeof(Button)).interactable = false;
    end
 end


-- �� ���� ��� ����¼�
function GamePanel.AddButtonEventOfCards(args)
    
  for index,value in pairs(args) do
    gameObject_luabe:AddClick(value,OnClickCard)
  end
  
      
end

function GamePanel.JiaoDiZhu(info,dizhutouxiang)
  
    --local allplayerjiaofen = this.JiaoFenSplit(info[4])

  if info[2] == "start" then
     if info[3] == player_0_id then
       -- ����
        -- ����
        player_0_touxiang:GetComponent(typeof(Image)).sprite = dizhutouxiang[1]  
        player_0_shenfen:GetComponent(typeof(Image)).sprite = dizhutouxiang[3]  
        
        for i=1,3 do
          for index,value in pairs(currentcards) do
           local threedipai_num = this.Split(threedipai[i]:GetComponent(typeof(Image)).sprite.name,"_")
           local currentpai_num = this.Split(value:GetComponent(typeof(Image)).sprite.name,"_")
           if threedipai_num[3] - currentpai_num[3] < 0 then
              threedipai[i].transform:SetParent(pais0.transform,false) 
              table.insert(currentcards,index,threedipai[i])  
              currentcards[index].transform:SetSiblingIndex(index-1) -- �� �Ƶ�gameobject������е�λ�� ���µ�һ��                                   
              break;          
           end         
          end   
         if threedipai[i].transform.parent == DiPais.transform then
            threedipai[i].transform:SetParent(pais0.transform,false) 
            table.insert(currentcards,threedipai[i])  
            threedipai[i].transform:SetAsLastSibling() -- �� �Ƶ�gameobject������е�λ�� ���µ�һ��     
         end    
      end

        this.HandCardTrim(currentcards)  -- ������� ��������
        this.SendCardOrDesendGameObject(true)
     elseif info[3] == player_1_id then
         -- ����
          player_1_touxiang:GetComponent(typeof(Image)).sprite = dizhutouxiang[1]  
          player_1_shenfen:GetComponent(typeof(Image)).sprite = dizhutouxiang[3]  
     elseif info[3] == player_2_id then
         -- ����
         player_2_touxiang:GetComponent(typeof(Image)).sprite = dizhutouxiang[1]  
         player_2_shenfen:GetComponent(typeof(Image)).sprite = dizhutouxiang[3]  
     end
     this.AddButtonEventOfCards(currentcards)
     --this.SendCardOrDesendGameObject(true)
  elseif info[2] == player_0_id then     
       -- to do ��ʾ ���� ���ٷ�
           this.ShowJiaoFenText(info[4],info[3]) 
           if info[4] == "1" then
            this.JiaoFenGameObject(true)
            Fen_Button_1:GetComponent(typeof(Button)).interactable = false     
           elseif info[4] == "2" then
            this.JiaoFenGameObject(true)
            Fen_Button_1:GetComponent(typeof(Button)).interactable = false
            Fen_Button_2:GetComponent(typeof(Button)).interactable = false;
           end  
                                                   
    -- �з�  
  elseif info[2] == player_1_id then  
     -- ������ �з�
      this.ShowJiaoFenText(info[4],info[3])
  elseif info[2] == player_2_id then  
      this.ShowJiaoFenText(info[4],info[3])
  end

end

function GamePanel.ShowJiaoFenText(fenshu,playerid)
   if fenshu == "2" then
      if playerid == player_0_id then
         -- to do ��ʾ ���� ����
      elseif playerid == player_1_id then

      elseif playerid == player_2_id then

      end
   elseif fenshu == "1" then
       if playerid == player_0_id then
         -- to do ��ʾ ���� ����
      elseif playerid == player_1_id then

      elseif playerid == player_2_id then

      end

   elseif fenshu == "0" then
      if playerid == player_0_id then
         -- to do ��ʾ ���� ����
      elseif playerid == player_1_id then

      elseif playerid == player_2_id then

      end

   end
end

function GamePanel.SendCardShow(sendid,sendordesend,sendcardinfo,isornosend,sendcardofplayer)
   
   if sendordesend == "1" then -- ���˳���
      -- show����
      if sendid == player_0_id then
         if isornosend == "1" then
           for index,value in pairs(pitchupcard) do
           value.transform:SetParent(cards.transform,false)                
           value:SetActive(false)
             for iii,vvv in pairs(currentcards) do
              if value == vvv then
                table.remove(currentcards,iii)
              end
            end          
          end              
        pitchupcard = {}
        this.HandCardTrim(currentcards)
        this.SendCardOrDesendGameObject(false)
        else
         Util.Log("bu fu he pai xing")
        end        
      elseif sendid == player_1_id then
         -- to do show �ϼ���
      elseif sendid == player_2_id then
         -- to do show �¼���
      end
      sended_cards = sendcardinfo -- ���� ���� �ƣ�Ҳ�������Լ�����
   elseif sendordesend == "2" then
      -- ����
      if sendid == player_0_id then
       
      elseif sendid == player_1_id then

      elseif sendid == player_2_id then

      end
   end

  if sendcardofplayer == player_0_id then
      this.SendCardOrDesendGameObject(true)
  elseif sendcardofplayer == player_1_id then

  elseif sendcardofplayer == player_2_id then

  end
end

-- ��� Ҫ���� �� �Ƿ� ���� ���ͣ�����Ϊ����һ�ҳ����ƣ���ǰѡ��Ҫ�����ƣ���
function WantToSendCardDetection(lastcards,args)
   if lastcards == nil then
      -- to do �ж� ���� �Ƿ� ����
   
   else
     -- to do �ж� ��һ�����ͣ��Ƶ�����
     -- to do �ж� ����ѡ��  ���� �� ����
   end
end

function GamePanel.JiaoFenSplit(args)
  local jiaofens = this.Split(args,",")
  for index,value in pairs(jiaofens) do
    value = this.Split(value,"|")
  end
  return jiaofens
end

-- �з� ������ť�� ���� ��
function GamePanel.JiaoFenGameObject(bool)

  if bool then
    jiaofen:SetActive(true)
  else
   jiaofen:SetActive(false)
  end
end

-- ���Ƶ� ������ť�� ���� ��
function GamePanel.SendCardOrDesendGameObject(bool)

  if bool then
    sendcardordesend:SetActive(true)
  else
    sendcardordesend:SetActive(false)
  end
end

-- �����Ƶ� ����,��λ��
function GamePanel.HandCardTrim(args)
      
    local argscount = 0
    
    for  index,value in pairs(args) do
      argscount = index
    end
      
    if argscount == 1 then
      args[argscount].transform.localPosition = Vector3.New(0,0,0)
      return
    end

    local num = argscount % 2
    if num == 0 then      
       for i=1,argscount / 2 do
         args[i].transform.localPosition = Vector3.New(-cardwidth*(argscount / 2-i+1),0,0)
       end
       for i=argscount/2+1,argscount do
         args[i].transform.localPosition = Vector3.New(cardwidth*(i-argscount / 2-1),0,0)
       end        
      
    else
       for i=1,(argscount-1)/2 do
         args[i].transform.localPosition = Vector3.New(-cardwidth*((argscount-1)/2-i+1),0,0)
       end
       args[(argscount+1) / 2].transform.localPosition = Vector3.New(0,0,0) 
       for i=(argscount+1)/2+1,argscount do
         args[i].transform.localPosition = Vector3.New(cardwidth*(i-(argscount-1)/2-1),0,0)
       end         
    end     
end

-- ���������������� �������������Ŵ�С
function GamePanel.CardSort(args)

   local myallcard = {}
   local pai_count = 0
   for index,value in pairs(args) do
     myallcard[index] = this.Split(value,"_")
     pai_count = index
   end

    -- ð������  �� args ����
    for i = 1,pai_count do
       for j = 1,pai_count-i do
         if myallcard[j][3]-myallcard[j+1][3]> 0 then
             local temp = myallcard[j]
             myallcard[j] = myallcard[j+1]
             myallcard[j+1] = temp
         end        
       end      
    end 

   for i = 1,pai_count do
    myallcard[i] = table.concat(myallcard[i],"_")
   end
--     for i= 1,pai_count do
--      Util.Log(myallcard[i])
--     end
     
   return myallcard  
end

function GamePanel.Split(str,char)

  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
   local nFindLastIndex = string.find(str, char, nFindStartIndex)
   if not nFindLastIndex then
    nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, string.len(str))
    break
   end
   nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, nFindLastIndex - 1)
   nFindStartIndex = nFindLastIndex + string.len(char)
   nSplitIndex = nSplitIndex + 1
  end

  return nSplitArray

end

