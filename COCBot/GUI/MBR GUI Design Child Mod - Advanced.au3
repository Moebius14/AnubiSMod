; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Anubis (2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
; Advanced Tab
;~ -------------------------------------------------------------
Global $g_hChkNoLabCheck = 0, $g_hChkNoLabCheckLabel = 0, $g_hChkNoLabCheckLabelTypo = 0
Global $g_hChkNoStarLabCheck = 0, $g_hChkNoStarLabCheckLabel = 0, $g_hChkNoStarLabCheckLabelTypo = 0
Global $g_hChkNoPetHouseCheck = 0, $g_hChkNoPetHouseCheckLabel = 0, $g_hChkNoPetHouseCheckLabelTypo = 0
Global $g_hCmbPriorityMagicItemsFrequency = 0, $g_hChkMagicItemsFrequencyLabel = 0, _
	   $g_hChkMagicItemsFrequencyLabel1 = 0
Global $g_hCmbPriorityBBaseFrequency = 0, $g_hChkBBaseFrequencyLabel = 0, _
	   $g_hChkBBaseFrequencyLabel1 =0
Global $g_hCmbPriorityPersoChallengesFrequency = 0, $g_hChkPersoChallengesFrequencyLabel = 0, _
	   $g_hChkPersoChallengesFrequencyLabel1 =0
Global $g_hcmbAdvancedVariation[3] = [0, 0, 0]
Global $g_hChkTrophyDropinPause = 0, $g_acmdRandomDelay = 0
Global $g_hChkVisitBbaseinPause = 0, $g_hChkPersoChallengesinPause = 0
Global $g_acmdRandomDelayMin = 0, $g_hLabelDelayPauseIntervalAnd = 0, $g_acmdRandomDelayMax = 0, $g_hLabelDelayPauseIntervalUnit = 0

Func TabAdvancedGUI()
	
	Local $x = 10, $y = 30
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Advanced", "Group_01", "Labs And Pet House Check Frequency"), $x , $y , 430, 130)
	
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabUpgrade, $x + 30, $y + 17, 32, 32)
	$g_hChkNoLabCheck = GUICtrlCreateCombo("", $x + 80, $y + 23, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Never|One Time|Classic", "Classic")
	GUICtrlSetOnEvent(-1, "DisplayChkNoLabCheck")
	$g_hChkNoLabCheckLabel = GUICtrlCreateLabel("", $x + 180, $y + 25, 250, 20)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x + 30, $y + 50, 32, 32)
	$g_hChkNoPetHouseCheck = GUICtrlCreateCombo("", $x + 80, $y + 56, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Never|One Time|Classic", "Classic")
	GUICtrlSetOnEvent(-1, "DisplayChkNoPetHouseCheck")
	$g_hChkNoPetHouseCheckLabel = GUICtrlCreateLabel("", $x + 180, $y + 58, 250, 20)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x + 30, $y + 83, 32, 32)
	$g_hChkNoStarLabCheck = GUICtrlCreateCombo("", $x + 80, $y + 89, 70, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Never|One Time|Classic", "Classic")
	GUICtrlSetOnEvent(-1, "DisplayChkNoStarLabCheck")
	$g_hChkNoStarLabCheckLabel = GUICtrlCreateLabel("", $x + 180, $y + 91, 250, 20)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
		
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 135
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Advanced", "Group_02", "Magical Items Check Frequency"), $x , $y , 430, 65)
	
	GUICtrlCreateIcon($g_sLibModIconPath, $g_sIcnTrader, $x + 33, $y + 20, 35, 35)
	$g_hChkMagicItemsFrequencyLabel = GUICtrlCreateLabel("Check Every :", $x + 90, $y + 34, -1, -1)
	$g_hCmbPriorityMagicItemsFrequency = GUICtrlCreateCombo("", $x + 165, $y + 30, 75, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Day|1 Hour|2 Hours|3 Hours|4 Hours|5 Hours|6 Hours|7 Hours|8 Hours", "Day")
	GUICtrlSetOnEvent(-1, "MagicItemsFrequencyDatas")
	$g_hChkMagicItemsFrequencyLabel1 = GUICtrlCreateLabel("With Random :", $x + 250, $y + 34, -1, -1)
	$g_hcmbAdvancedVariation[0] = GUICtrlCreateCombo("", $x + 325, $y + 30, 50, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0 %|10 %|20 %|30 %|40 %|50 %", "30 %")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 70
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Advanced", "Group_03", "BBase Switch Frequency"), $x , $y , 430, 50)
	
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 38, $y + 19, 24, 24)
	$g_hChkBBaseFrequencyLabel = GUICtrlCreateLabel("Check Every :", $x + 90, $y + 24, -1, -1)
	$g_hCmbPriorityBBaseFrequency = GUICtrlCreateCombo("", $x + 165, $y + 20, 75, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Everytime|1 Hour|2 Hours|3 Hours|4 Hours|5 Hours|6 Hours|7 Hours|8 Hours", "3 Hours")
	GUICtrlSetOnEvent(-1, "BBaseFrequencyDatas")
	$g_hChkBBaseFrequencyLabel1 = GUICtrlCreateLabel("With Random :", $x + 250, $y + 24, -1, -1)
	$g_hcmbAdvancedVariation[1] = GUICtrlCreateCombo("", $x + 325, $y + 20, 50, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0 %|10 %|20 %|30 %|40 %|50 %", "30 %")
		
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 56
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Advanced", "Group_04", "Challenges Check Frequency"), $x , $y , 430, 50)
	
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnChallenge, $x + 39, $y + 18, 24, 24)
	$g_hChkPersoChallengesFrequencyLabel = GUICtrlCreateLabel("Check Every :", $x + 90, $y + 24, -1, -1)
	$g_hCmbPriorityPersoChallengesFrequency = GUICtrlCreateCombo("", $x + 165, $y + 20, 75, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Everytime|1 Hour|2 Hours|3 Hours|4 Hours|5 Hours", "Everytime")
	GUICtrlSetOnEvent(-1, "PersoChallengesFrequencyDatas")
	$g_hChkPersoChallengesFrequencyLabel1 = GUICtrlCreateLabel("With Random :", $x + 250, $y + 24, -1, -1)
	$g_hcmbAdvancedVariation[2] = GUICtrlCreateCombo("", $x + 325, $y + 20, 50, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0 %|10 %|20 %|30 %|40 %|50 %", "30 %")
	
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 56
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Advanced", "Group_05", "Advanced Schedule Settings"), $x , $y , 430, 85)
	
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 15, $y + 22, 24, 24)
	$g_hChkTrophyDropinPause = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - Advanced", "Drop Trophy in pause time", "Always Drop Trophies"), $x + 45, $y + 25, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "ChkTrophyDropinPause")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design - Advanced", "DropEverytime", "Drop trophies even when pause time."))
	
	GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 170, $y + 22, 24, 24)
	$g_hChkVisitBbaseinPause = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - Advanced", "Visit Bbase in pause time", "BBase/Pause"), $x + 200, $y + 25, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "ChkVisitBbaseinPause")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design - Advanced", "VisitBbaseEverytime", "Visit BBase If necessary even when pause time."))
	
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnChallenge, $x + 290, $y + 22, 22, 24)
	$g_hChkPersoChallengesinPause = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - Advanced", "Check Perso Challenges in pause time", "Challenges/Pause"), $x + 320, $y + 25, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "ChkPersoChallengesinPause")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design - Advanced", "CheckPersoChallengesEverytime", "Check Personnal Challenges even when pause time."))
	
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnChrono, $x + 15, $y + 52, 24, 24)
	$g_acmdRandomDelay = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - Advanced", "chkRandomPauseDelayEnable", "Enable Random Pause Delay Between"), $x + 45, $y + 55, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design - Advanced", "RandomDelayAtRestart", "This option adds random delay to time restart after break."))
	GUICtrlSetOnEvent(-1, "chkRandomPauseDelayEnable")
	$g_acmdRandomDelayMin = GUICtrlCreateInput("10", $x + 253, $y + 57, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "cmdRandomDelayMin")
	$g_hLabelDelayPauseIntervalAnd = GUICtrlCreateLabel("And", $x + 283, $y + 59, 20, -1)
	$g_acmdRandomDelayMax = GUICtrlCreateInput("30", $x + 310, $y + 57, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "cmdRandomDelayMax")
	$g_hLabelDelayPauseIntervalUnit = GUICtrlCreateLabel("mn", $x + 340, $y + 59, 20, -1)	
	
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
EndFunc   ;==>CreateAdvancedTab	