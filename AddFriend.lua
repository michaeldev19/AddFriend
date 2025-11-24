--ver: 3.27
AFriend = LibStub("AceAddon-3.0"):NewAddon("AFriend", "AceHook-3.0");
local AFriend = AFriend;
local AFriendButtons = {};
local AfriendMenu = {};
local AButtons = {"Add_Friend", "Remove_Friend", "Add_Guild", "Remove_Guild"};
local AButtonTxt = {L["OP_Add_Friend"], L["OP_Remove_Friend"], L["OP_Add_Guild"], L["OP_Remove_Guild"]};
local AToolTips = {L["TT_Add_Friend"], L["TT_Remove_Friend"], L["TT_Add_Guild"], L["TT_Remove_Guild"]};
local redColor, greenColor = "|cffff2020", "|cff20ff20";
local AColors = {greenColor, redColor, greenColor, redColor};
local gsub, ipairs = gsub, ipairs;
local GuildRoster, ShowFriends, GetNumFriends, GetFriendInfo = GuildRoster, ShowFriends, GetNumFriends, GetFriendInfo;
local IsInGuild, CanGuildInvite, GetGuildRosterInfo, GetNumGuildMembers  = IsInGuild, CanGuildInvite, GetGuildRosterInfo, GetNumGuildMembers;
local AddFriend, RemoveFriend, GuildInvite, GuildUninvite = AddFriend, RemoveFriend, GuildInvite, GuildUninvite;
local UnitGUID, UnitName, UnitCanCooperate = UnitGUID, UnitName, UnitCanCooperate;
local UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton = UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton;
local frameTypes = {["FRIEND"]=1,["PLAYER"]=1,["PARTY"]=1,["RAID_PLAYER"]=1,["RAID"]=1,["PET"]=false,["SELF"]=false};

function AFriend:OnEnable()
	for i,v in ipairs(AButtons) do
		AFriendButtons[v] = {text=AButtonTxt[i], dist=0, color=AColors[i], tooltipText=AToolTips[i]};
		AfriendMenu[i] = v;
	end
	self:SecureHook("UnitPopup_ShowMenu");
end

local function AFriend_Button_Onclick(self, info)
	assert(info);
	local button = info.button; assert(button);
	local name = info.name or UnitName(info.unit); assert(name);
	if button == "Add_Friend" then AddFriend(name);
	elseif button == "Remove_Friend" then RemoveFriend(name);
	elseif button == "Add_Guild" then GuildInvite(name);
	elseif button == "Remove_Guild" then GuildUninvite(name); end
end

local function isFriend(name)
	ShowFriends();
	for x=1, GetNumFriends() do
		if GetFriendInfo(x) == name then return true; end
	end
	return false;
end

local function isGuildee(name)
	GuildRoster();
	for x=1, GetNumGuildMembers() do
		if GetGuildRosterInfo(x) == name then return true; end
	end
	return false;
end

function AFriend:UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData)
	local thisName = name or UnitName(unit);
	which = gsub(which, "PB4_", "");
	if not frameTypes[which] then return; end
	if (which ~= "FRIEND") and (not UnitCanCooperate("player", unit) or UnitGUID(unit) == UnitGUID("player")) then return; end
	if which == "FRIEND" and thisName == UnitName("player") then return; end
	if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return; end
	local info = UIDropDownMenu_CreateInfo();
	for _,v in ipairs(AfriendMenu) do
		info.text=AFriendButtons[v].text;
		info.value=v;
		info.owner=which;
		info.func=AFriend_Button_Onclick;
		info.notCheckable=1;
		info.colorCode = AFriendButtons[v].color or nil;
		info.arg1 = {["button"]=v, ["unit"]=unit, ["name"]=name};
		info.tooltipTitle = AFriendButtons[v].text;
		info.tooltipText = AFriendButtons[v].tooltipText;
		if IsInGuild() and CanGuildInvite() then
			if v == "Remove_Guild" and isGuildee(thisName) then UIDropDownMenu_AddButton(info);
			elseif v == "Add_Guild" and not isGuildee(thisName) then UIDropDownMenu_AddButton(info); end
		end
		if v == "Remove_Friend" and isFriend(thisName) then UIDropDownMenu_AddButton(info);
		elseif v == "Add_Friend" and not isFriend(thisName) then UIDropDownMenu_AddButton(info); end
	end
end