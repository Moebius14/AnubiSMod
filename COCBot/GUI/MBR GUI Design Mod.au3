; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design
; Description ...: This file creates the "MOD" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: NguyenAnhHD
; Modified ......: AnubiS
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_MOD = 0, $g_hGUI_MOD_TAB = 0, $g_hGUI_MOD_TAB_ITEM1 = 0, $g_hGUI_MOD_TAB_ITEM2 = 0
Global $g_hChkUseBotHumanization = 0, $g_acmbPriority[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLabel01 = 0, $g_hCmbMaxActionsNumber = 0, $g_IsRefusedFriends = 0, $g_hChkForumRequestOnly = 0
Global $g_hGUI_WelcomeMessage = 0, $g_hBtnWelcomeMessage = 0, $g_hChkUseWelcomeMessage = 0, $g_hTxtRequestMessage = 0, $g_hTxtWelcomeMessage = 0, $g_hBtnWelcomeMessageClose = 0, $g_hChkAcceptAllRequests = 0
Global $g_HowManyinCWLabel = 0, $g_HowManyinCWCombo = 0, $g_HowManyinCWLLabel = 0, $g_HowManyinCWLCombo = 0
Global $g_hChkNoLabCheck = 0, $g_hChkNoLabCheckLabel = 0, $g_hChkNoLabCheckLabelTypo = 0
Global $g_hChkNoStarLabCheck = 0, $g_hChkNoStarLabCheckLabel = 0, $g_hChkNoStarLabCheckLabelTypo = 0
Global $g_hChkNoPetHouseCheck = 0, $g_hChkNoPetHouseCheckLabel = 0, $g_hChkNoPetHouseCheckLabelTypo = 0
Global $g_hCmbPriorityBBaseFrequency = 0, $g_hChkBBaseFrequencyLabel = 0, _
		$g_hChkBBaseFrequencyLabel1 = 0
Global $g_hcmbAdvancedVariation = 0

Local $sTxtTip = ""

Global $g_hTxtModLog = 0, $g_hBtnModLogClear

Func CreateModTab()
	$g_hGUI_MOD = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_MOD)
	$g_hGUI_MOD_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

	$g_hGUI_MOD_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_Mod_Tab_01", "Humanization"))
	TabHumanizationGUI()
	$g_hGUI_MOD_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_Mod_Tab_02", "Mod Log"))
	TabModLogGUI()
	CreateChatWelcomeMessage()

	GUICtrlCreateTabItem("")
EndFunc   ;==>CreateModTab

Func TabHumanizationGUI()

	Local $x = 30, $y = 50

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_01", "Settings"), $x - 20, $y - 20, 430, 400)

	$x -= 20
	$y += 0
	_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnHumanization, $x + 20, $y, 16, 16)
	$g_hChkUseBotHumanization = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkUseBotHumanization", "Enable Bot Humanization"), 50, $y, 136, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_02", "Bot performs more Human-Like behaviors."))
	GUICtrlSetOnEvent(-1, "chkUseBotHumanization")
	GUICtrlSetState(-1, $GUI_CHECKED)

	_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnBell, $x + 22, $y + 26, 14, 16)
	$g_IsRefusedFriends = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "RefuseFriends", "Refuse Friends"), 50, $y + 26, 90, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGUI, $x + 20, $y + 55, 16, 16)
	$g_hChkForumRequestOnly = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkForumRequestOnly", "Accept Joining Requests"), 50, $y + 52, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_03", "Will Click ""Accept"" With Keywords in Requests But Won't Do Anything For Other Requests"))
	GUICtrlSetOnEvent(-1, "ChkForumRequestOnly")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$g_hBtnWelcomeMessage = GUICtrlCreateButton("Chat", $x + 190, $y + 50, -1, -1)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetColor(-1, $COLOR_SUCCESS)
	_GUICtrlSetTip(-1, "Set The Welcome Message After Accept")
	GUICtrlSetOnEvent(-1, "BtnWelcomeMessage")

	$y += 25
	_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModZZZ, $x + 245, $y - 1, 26, 26)
	$g_hLabel01 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_01", "Do nothing"), $x + 280, $y + 5, 110, 17)
	$g_acmbPriority[10] = GUICtrlCreateCombo("", $x + 340, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Ultra Often")

	$x += 10
	$y += 70
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Advanced", "Group_01", "Labs And Pet House Check Frequency"), $x, $y, 410, 130)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabUpgrade, $x + 30, $y + 22, 32, 32)
	$g_hChkNoLabCheck = GUICtrlCreateCombo("", $x + 80, $y + 28, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Never|One Time|Classic", "Classic")
	GUICtrlSetOnEvent(-1, "DisplayChkNoLabCheck")
	$g_hChkNoLabCheckLabel = GUICtrlCreateLabel("", $x + 180, $y + 30, 250, 20)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x + 30, $y + 55, 32, 32)
	$g_hChkNoPetHouseCheck = GUICtrlCreateCombo("", $x + 80, $y + 61, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Never|One Time|Classic", "Classic")
	GUICtrlSetOnEvent(-1, "DisplayChkNoPetHouseCheck")
	$g_hChkNoPetHouseCheckLabel = GUICtrlCreateLabel("", $x + 180, $y + 63, 250, 20)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x + 30, $y + 88, 32, 32)
	$g_hChkNoStarLabCheck = GUICtrlCreateCombo("", $x + 80, $y + 94, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Never|One Time|Classic", "Classic")
	GUICtrlSetOnEvent(-1, "DisplayChkNoStarLabCheck")
	$g_hChkNoStarLabCheckLabel = GUICtrlCreateLabel("", $x + 180, $y + 96, 250, 20)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 145
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Advanced", "Group_03", "BBase Switch Frequency"), $x, $y, 410, 50)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 38, $y + 19, 24, 24)
	$g_hChkBBaseFrequencyLabel = GUICtrlCreateLabel("Check Every :", $x + 90, $y + 24, -1, -1)
	$g_hCmbPriorityBBaseFrequency = GUICtrlCreateCombo("", $x + 165, $y + 20, 75, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Everytime|1 Hour|2 Hours|3 Hours|4 Hours|5 Hours|6 Hours|7 Hours|8 Hours", "3 Hours")
	GUICtrlSetOnEvent(-1, "BBaseFrequencyDatas")
	$g_hChkBBaseFrequencyLabel1 = GUICtrlCreateLabel("With Random :", $x + 250, $y + 24, -1, -1)
	$g_hcmbAdvancedVariation = GUICtrlCreateCombo("", $x + 325, $y + 20, 50, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0 %|10 %|20 %|30 %|40 %|50 %", "30 %")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - ModLog", "Group_01", "Informations for humanization"), $x, $y + 20, 410, 60)

	_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModCW, $x + 8, $y + 38, 32, 32)
	$g_HowManyinCWLabel = GUICtrlCreateLabel("Players in CW : ", $x + 48, $y + 49, -1, -1)
	$g_HowManyinCWCombo = GUICtrlCreateCombo("", $x + 128, $y + 45, 40, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "5|10|15|20|25|30|35|40|45|50", "5")
	_GUICtrlSetTip(-1, "Please Select Number Of Players In Classic War - Humanization Optimization")
	GUICtrlSetOnEvent(-1, "HowManyinCWCombo")
	_GUICtrlCreateIcon($g_sLibModIconPath, $eIcnCWLChampion, $x + 208, $y + 37, 34, 34)
	$g_HowManyinCWLLabel = GUICtrlCreateLabel("Players in CWL : ", $x + 248, $y + 49, -1, -1)
	$g_HowManyinCWLCombo = GUICtrlCreateCombo("", $x + 333, $y + 45, 40, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "5|10|15|20|25|30|35|40|45|50", "15")
	_GUICtrlSetTip(-1, "Please Select Number Of Players In Clan War League - Humanization Optimization")
	GUICtrlSetOnEvent(-1, "HowManyinCWLCombo")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>TabHumanizationGUI

Func CreateChatWelcomeMessage()
	Local $x = 25, $y = 5
	$g_hGUI_WelcomeMessage = _GUICreate("Welcome Message", $_GUI_MAIN_WIDTH - 4, $_GUI_MAIN_HEIGHT - 460, $g_iFrmBotPosX, $g_iFrmBotPosY + 80, $WS_DLGFRAME, -1, $g_hFrmBot)

	$g_hChkUseWelcomeMessage = GUICtrlCreateCheckbox("Use Welcome Message", $x + 70, $y)
	_GUICtrlSetTip(-1, "Enable Welcome Chat Message")
	GUICtrlSetOnEvent(-1, "chkUseWelcomeMessage")

	$g_hTxtRequestMessage = GUICtrlCreateEdit("", $x + 100, $y + 30, 120, 72, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, StringFormat("Forum\r\nforum"))
	_GUICtrlSetTip(-1, "Request Keywords To Detect")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkAcceptAllRequests = GUICtrlCreateCheckbox("Accept All Joining Requests", $x + 250, $y + 60)
	_GUICtrlSetTip(-1, "Accept All Joining Requests, What Ever The Request Message")
	GUICtrlSetOnEvent(-1, "chkAcceptAllRequests")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hTxtWelcomeMessage = GUICtrlCreateInput($g_aWelcomeMessage, $x + 70, $y + 120, 260, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
	_GUICtrlSetTip(-1, "Type Your Welcome Chat Message" & @CRLF & "Will Be Written After Accept With Keywords")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 160
	$g_hBtnWelcomeMessageClose = GUICtrlCreateButton("Close", $_GUI_MAIN_WIDTH - 110, $y, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseWelcomeMessage")
EndFunc   ;==>CreateChatWelcomeMessage

Func TabModLogGUI()
	Local $x = 0, $y = 0
	$g_hTxtModLog = GUICtrlCreateEdit("", 10, 40, $g_iSizeWGrpTab3 - 3, 350, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, "------------------------------------------------------- Log of Mod Events -------------------------------------------------")

	$g_hBtnModLogClear = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Log", "BtnModLogClear", "Clear Mod Log"), $x + 330, $y + 400, 80, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Log", "BtnModLogClear_Info_01", "Use this to clear the Mod Log."))
	GUICtrlSetOnEvent(-1, "btnModLogClear")
EndFunc   ;==>TabModLogGUI
