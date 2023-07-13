; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design - Humanization
; Description ...: Design Sub GUI for Humanization
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: RoroTiti (2016)
; Modified ......: AnubiS
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_hChkUseBotHumanization = 0, $g_acmbPriority = 0
Global $g_hLabel1 = 0, $g_hLabel2 = 0, $g_hLabel3 = 0, $g_hLabel4 = 0
Global $g_hLabel5 = 0, $g_hLabel6 = 0, $g_hLabel7 = 0, $g_hLabel8 = 0
Global $g_hLabel9 = 0, $g_hLabel10 = 0, $g_hLabel11 = 0, $g_hLabel12 = 0
Global $g_hLabel14 = 0, $g_hLabel15 = 0, $g_hLabel16 = 0, $g_hLabel13 = 0
Global $g_hLabel17 = 0, $g_hLabel18 = 0, $g_hLabel19 = 0
Global $g_hChkLookAtRedNotifications = 0, $g_hCmbMaxActionsNumber = 0, $g_IsRefusedFriends = 0, $g_hChkForumRequestOnly = 0
Global $g_acmbPriority[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_acmbMaxSpeed[3] = [0, 0, 0]
Global $g_acmbPause[3] = [0, 0, 0]
Global $g_hLabelBB1 = 0, $g_hLabelBB2 = 0, $g_hLabelBB3 = 0, $g_hLabelBB4 = 0
Global $g_hGUI_WelcomeMessage = 0, $g_hBtnWelcomeMessage = 0, $g_hChkUseWelcomeMessage = 0, $g_hTxtWelcomeMessage = 0, $g_hBtnWelcomeMessageClose = 0
Global $g_hGUI_SecondaryVillages = 0, $g_hBtnSecondaryVillages = 0, $g_hBtnSecondaryVillagesClose = 0
Global $g_acmbPriorityBB[2] = [0, 0]
Global $g_hLabelCC1 = 0, $g_acmbPriorityChkRaid = 0
Global $g_HowManyinCWLabel = 0, $g_HowManyinCWCombo = 0, $g_HowManyinCWLLabel = 0, $g_HowManyinCWLCombo = 0

Func TabHumanizationGUI()

	Local $x = 30, $y = 50

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_01", "Settings"), $x - 20, $y - 20, 430, 400)

	$x -= 20
	$y += 0
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnHumanization, $x + 20, $y, 16, 16)
	$g_hChkUseBotHumanization = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkUseBotHumanization", "Enable Bot Humanization"), 50, $y, 136, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_02", "Bot performs more Human-Like behaviors."))
	GUICtrlSetOnEvent(-1, "chkUseBotHumanization")
	GUICtrlSetState(-1, $GUI_CHECKED)

	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnBell, $x + 22, $y + 26, 14, 16)
	$g_hChkLookAtRedNotifications = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkLookAtRedNotifications", "Notifications"), 50, $y + 26, 80, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "chkLookAtRedNotifications2", "Check Notifications : Messages, League, War, Chat, Events, Shop,..."))
	GUICtrlSetOnEvent(-1, "chkLookAtRedNotifications")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$g_IsRefusedFriends = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "RefuseFriends", "Refuse Friends"), 140, $y + 26, 90, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)

	GUICtrlCreateIcon($g_sLibIconPath, $eIcnGUI, $x + 20, $y + 55, 16, 16)
	$g_hChkForumRequestOnly = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkForumRequestOnly", "Accept ""Forum"" Requests"), 50, $y + 52, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_03", "Will Click ""Accept"" With ""Forum"" in Requests But Won't Do Anything For Other Requests"))
	GUICtrlSetOnEvent(-1, "ChkForumRequestOnly")
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	$g_hBtnWelcomeMessage = GUICtrlCreateButton("Chat", $x + 190, $y + 50, -1, -1)
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	GUICtrlSetColor(-1, $COLOR_SUCCESS)
	_GUICtrlSetTip(-1, "Set The Welcome Message After Accept")
	GUICtrlSetOnEvent(-1, "BtnWelcomeMessage")

	$y += 25

	$g_hLabel19 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_19", "Read Events"), 248, $y + 2, 110, 17)
	$g_acmbPriority[9] = GUICtrlCreateCombo("", $x + 348, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")

	$x += 6
	$y += 25

	$g_hLabel1 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_01", "Read The Clan Chat"), $x + 232, $y + 3, 110, 17)
	$g_acmbPriority[0] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")

	$y += 30 
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroops, $x, $y + 9, 32, 32)
	$g_hLabel5 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_05", "Watch Defenses"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[1] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$g_hLabel6 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_06", "Watch Attacks"), $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[2] = GUICtrlCreateCombo("", $x + 140, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	GUICtrlSetOnEvent(-1, "cmbStandardReplay")
	$g_hLabel7 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_07", "Max Replay Speed"), $x + 232, $y + 5, 110, 17)
	$g_acmbMaxSpeed[0] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1x|2x|4x|Random", "Random")
	$g_hLabel8 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_08", "Pause Replay"), $x + 232, $y + 30, 110, 17)
	$g_acmbPause[0] = GUICtrlCreateCombo("", $x + 342, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")

	$y += 62

	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnVillager, $x - 2, $y + 7, 35, 35)
	$g_hLabel9 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_09", "Look at War log"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[3] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	$g_hLabel10 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_10", "Visit Clanmates"), $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[4] = GUICtrlCreateCombo("", $x + 140, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	$g_hLabel11 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_11", "Look at Best Players"), $x + 232, $y + 5, 110, 17)
	$g_acmbPriority[5] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	$g_hLabel12 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_12", "Look at Best Clans"), $x + 232, $y + 30, 110, 17)
	$g_acmbPriority[6] = GUICtrlCreateCombo("", $x + 342, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")

	$y += 62

	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModCWL, $x + 1, $y + 8, 32, 32)
	$g_hLabel14 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_14", "Look at Current War"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[7] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	GUICtrlSetOnEvent(-1, "GuiLookatCurrentWar")
	$g_hLabel16 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_16", "Watch Replays"), $x + 40, $y + 30, 110, 17)
	$g_acmbPriority[8] = GUICtrlCreateCombo("", $x + 140, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	GUICtrlSetOnEvent(-1, "cmbWarReplay")
	$g_hLabel13 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_13", "Max Replay Speed"), $x + 232, $y + 5, 110, 17)
	$g_acmbMaxSpeed[1] = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1x|2x|4x|Random", "Random")
	$g_hLabel15 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_15", "Pause Replay"), $x + 232, $y + 30, 110, 17)
	$g_acmbPause[1] = GUICtrlCreateCombo("", $x + 342, $y + 25, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")

	$y += 57

	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModZZZ, $x + 5, $y - 1, 26, 26)
	$g_hLabel17 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_17", "Do nothing"), $x + 40, $y + 5, 110, 17)
	$g_acmbPriority[10] = GUICtrlCreateCombo("", $x + 140, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Ultra Often")
	$g_hLabel18 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_18", "Max Actions by Loop"), $x + 232, $y + 5, 103, 17)
	$g_hCmbMaxActionsNumber = GUICtrlCreateCombo("", $x + 342, $y, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1|2|3|4|5", "1")

	$x += 4
	$y += 30

	$g_hBtnSecondaryVillages = GUICtrlCreateButton("Secondary Villages", $x + 155, $y - 4, -1, -1)
	_GUICtrlSetTip(-1, "Set The Humanization For Builder Base And Clan Capital")
	GUICtrlSetOnEvent(-1, "BtnSecondaryVillages")

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - ModLog", "Group_01", "Informations for humanization"), $x, $y + 20, 410, 60)

	$x += 20
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModCW, $x + 8, $y + 38, 32, 32)
	$g_HowManyinCWLabel = GUICtrlCreateLabel("Players in CW : ", $x + 48, $y + 49, -1, -1)
	$g_HowManyinCWCombo = GUICtrlCreateCombo("", $x + 128, $y + 45, 40, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "5|10|15|20|25|30|35|40|45|50", "5")
	_GUICtrlSetTip(-1, "Please Select Number Of Players In Classic War - Humanization Optimization")
	GUICtrlSetOnEvent(-1, "HowManyinCWCombo")
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnCWLChampion, $x + 208, $y + 37, 34, 34)
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
	$g_hGUI_WelcomeMessage = _GUICreate("Welcome Message", $_GUI_MAIN_WIDTH - 4, $_GUI_MAIN_HEIGHT - 570, $g_iFrmBotPosX, $g_iFrmBotPosY + 80, $WS_DLGFRAME, -1, $g_hFrmBot)

	$g_hChkUseWelcomeMessage = GUICtrlCreateCheckbox("Use Welcome Message", $x + 70, $y)
		_GUICtrlSetTip(-1, "Enable Welcome Chat Message")
		GUICtrlSetOnEvent(-1, "chkUseWelcomeMessage")
	$g_hTxtWelcomeMessage = GUICtrlCreateInput($g_aWelcomeMessage, $x + 70, $y + 30, 260, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
		_GUICtrlSetTip(-1, "Type Your Welcome Chat Message" & @CRLF & "Will Be Written After Accept With ""Forum"" Keyword")
		GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 50
	$g_hBtnWelcomeMessageClose = GUICtrlCreateButton("Close", $_GUI_MAIN_WIDTH - 110, $y, 85, 25)
		GUICtrlSetOnEvent(-1, "CloseWelcomeMessage")
EndFunc

Func CreateSecondaryVillages()
	Local $x = 25, $y = 5
	$g_hGUI_SecondaryVillages = _GUICreate("Secondary Villages", $_GUI_MAIN_WIDTH - 4, $_GUI_MAIN_HEIGHT - 440, $g_iFrmBotPosX, $g_iFrmBotPosY + 80, $WS_DLGFRAME, -1, $g_hFrmBot)

	$y += 10

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_02", "Builder Base"), $x, $y, 410, 80)

	$g_hLabelBB1 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_BB01", "Look at Battle log"), $x + 10, $y + 25, 110, 17)
	$g_acmbPriorityBB[0] = GUICtrlCreateCombo("", $x + 110, $y + 20, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	GUICtrlSetOnEvent(-1, "ViewBattleLog")
	$g_hLabelBB2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_06", "Watch Battles"), $x + 10, $y + 55, 110, 17)
	$g_acmbPriorityBB[1] = GUICtrlCreateCombo("", $x + 110, $y + 50, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")
	GUICtrlSetOnEvent(-1, "WatchBBBattles")
	$g_hLabelBB3 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_07", "Max Replay Speed"), $x + 222, $y + 25, 110, 17)
	$g_acmbMaxSpeed[2] = GUICtrlCreateCombo("", $x + 322, $y + 20, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "1x|2x|4x|Random", "Random")
	$g_hLabelBB4 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_08", "Pause Replay"), $x + 222, $y + 55, 110, 17)
	$g_acmbPause[2] = GUICtrlCreateCombo("", $x + 322, $y + 50, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Sometimes")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 100

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_03", "Clan Capital"), $x, $y, 410, 60)

	$g_hLabelCC1 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Label_CC1", "Look at Raid Map"), $x + 100, $y + 25, 110, 17)
	$g_acmbPriorityChkRaid = GUICtrlCreateCombo("", $x + 200, $y + 20, 75, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, $g_sFrequenceChain, "Very Often")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 70
	$g_hBtnSecondaryVillagesClose = GUICtrlCreateButton("Close", $_GUI_MAIN_WIDTH - 110, $y, 85, 25)
		GUICtrlSetOnEvent(-1, "CloseSecondaryVillages")
EndFunc