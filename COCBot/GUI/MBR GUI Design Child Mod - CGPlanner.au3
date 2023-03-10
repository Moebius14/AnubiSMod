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
#include-once
;~ -------------------------------------------------------------
; CG Planner Tab
;~ -------------------------------------------------------------

; Attack schedule
Global $g_hChkAttackCGPlannerEnable = 0, $g_hChkAttackCGPlannerRandom = 0, _
	   $g_hCmbAttackCGPlannerRandomTime = 0, $g_hChkAttackCGPlannerDayLimit = 0, $g_hCmbAttackCGPlannerDayMin = 0, $g_hCmbAttackCGPlannerDayMax = 0, _
	   $g_hLbAttackCGPlannerThen = 0, $hCGPlannerThenContinue = 0, $hCGPlannerThenStopBot = 0, $g_hChkSTOPWhenCGPointsMax = 0, _
	   $TitleDailyLimit = 0, $MaxDailyLimit = 0, $DailyLimitSlash = 0, $ActualNbrsAttacks = 0
Global $g_ahChkAttackCGWeekdays[7] = [0, 0, 0, 0, 0, 0, 0], $g_ahChkAttackCGHours[24] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_hLbAttackCGPlannerRandom = 0, $g_hLbAttackCGPlannerDayLimit = 0, $g_ahChkAttackCGWeekdaysE = 0, $g_ahChkAttackCGHoursE1 = 0, $g_ahChkAttackCGHoursE2 = 0, $g_ahChkAttackCGHoursE2Label = 0
Global $g_hLbAttackCGPlannerRandomProba = 0, $g_hCmbAttackCGPlannerRandomProba = 0, $g_LabelAttackCGPlannerRandomVariation = 0, $g_hCmbAttackCGPlannerRandomVariation = 0
Global $g_hTxtCGRandomLog = 0

Local $sTxtTip = ""

Func TabCGPlannerGUI()
	Local $x = 35, $y = 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "Group_02", "Clan Games Attack Schedule"), $x - 20, $y - 20, $g_iSizeWGrpTab4, 240)
	$x -= 5
		$g_hChkAttackCGPlannerEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerEnable", "Enable Schedule"), $x , $y , -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerEnable_Info_01", "This option will allow you to schedule attack times in Clan Games") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerEnable_Info_02", "Bot continues to run and will attack in Clan Games only when schedule allows"))
			GUICtrlSetOnEvent(-1, "chkAttackCGPlannerEnable")
		GUICtrlCreatePic($g_sLibIconPathMOD, $x + 25, $y + 25, 94, 128, $SS_BITMAP)
		
		$g_hChkAttackCGPlannerRandom = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerRandom", "Random Disable"), $x + 145, $y + 92, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerRandom_Info_01", "This option will randomly stop attacking in Clan Games") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlanner_Info_01"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkAttackCGPlannerRandom")
		$g_hCmbAttackCGPlannerRandomTime = GUICtrlCreateCombo("", $x + 245, $y + 90, 37, 16, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerRandom_Info_02", "Select number of hours to stop attacking in Clan Games"))
			GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10", "2")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbAttackCGPlannerRandom")
		$g_hLbAttackCGPlannerRandom = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "hrs", "hrs"), $x + 285, $y + 95, -1,-1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			
		$g_LabelAttackCGPlannerRandomVariation = GUICtrlCreateLabel("Variation", $x + 305, $y + 95, -1, -1)
		$g_hCmbAttackCGPlannerRandomVariation = GUICtrlCreateCombo("", $x + 352, $y + 90, 45, 16, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerRandom_Info_04", "Select Variation Probability to stop attacking in Clan Games"))
			GUICtrlSetData(-1, "10%|20%|30%|40%|50%|60%|70%|80%|90%", "30%")	
			
		$g_hLbAttackCGPlannerRandomProba = GUICtrlCreateLabel("Disable Probability", $x + 205, $y + 123, -1, -1)
		$g_hCmbAttackCGPlannerRandomProba = GUICtrlCreateCombo("", $x + 300, $y + 119, 45, 16, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerRandom_Info_03", "Select Probability to stop attacking in Clan Games"))
			GUICtrlSetData(-1, "10%|20%|30%|40%|50%|60%|70%|80%|90%", "40%")
					
		$g_hChkAttackCGPlannerDayLimit = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerDayLimit", "CG Daily Limit"), $x + 188, $y + 147, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "ChkAttackPlannerDayLimit_Info_01", "Will randomly stop attacking in Clan Games when exceed random number of attacks between range selected"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkAttackCGPlannerDayLimit")
		$g_hCmbAttackCGPlannerDayMin = GUICtrlCreateInput($g_iAttackCGPlannerDayMin, $x + 278, $y + 149, 37, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "TxtMinLbAttackPlannerDayLimit_Info_01", "Enter minimum number of attacks in Clan Games allowed per day"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "cmbAttackCGPlannerDayMin")
		$g_hLbAttackCGPlannerDayLimit = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "LbAttackPlannerDayLimit", "To"), $x + 320, $y + 151, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hCmbAttackCGPlannerDayMax = GUICtrlCreateInput($g_iAttackCGPlannerDayMax, $x + 335, $y + 149, 37, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "TxtMaxLbAttackPlannerDayLimit_Info_01", "Enter maximum number of attacks in Clan Games allowed per day"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "cmbAttackCGPlannerDayMax")
		
		$g_hLbAttackCGPlannerThen = GUICtrlCreateLabel("Then", $x + 185, $y + 178, -1, -1)
		
		$x += 35
		$hCGPlannerThenContinue = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "Continue", "Continue"), $x + 185, $y + 175, -1, -1)
		_GUICtrlSetTip(-1, "Bot continues when limit is reached")
		GUICtrlSetState(-1, $GUI_CHECKED)

		$x += 65
		$hCGPlannerThenStopBot = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-CGAttack", "StopBot", "Stop Bot"), $x + 185, $y + 175, -1, -1)
		_GUICtrlSetTip(-1, "Bot stops when limit is reached")
		GUICtrlSetState(-1, $GUI_UNCHECKED)	
		
		$g_hChkSTOPWhenCGPointsMax = GUICtrlCreateCheckbox("Stop Bot When Max Points", $x + 88, $y + 195, -1, -1)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
			
		GUICtrlCreateGroup("", $x - 73, $y + 158, 80, 50)
		$TitleDailyLimit = GUICtrlCreateLabel("Daily Limit : ", $x - 65, $y + 168, -1, -1)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
		$ActualNbrsAttacks =  GUICtrlCreateLabel("", $x - 49, $y + 188, -1, 15)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
		$DailyLimitSlash =  GUICtrlCreateLabel(" / ", $x - 39, $y + 188, -1, -1)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
		$MaxDailyLimit =  GUICtrlCreateLabel("", $x - 25, $y + 188, -1, 15)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
			
	$x += 98
	$y -= 5
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Day", -1) & ":", $x, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Su", -1), $x + 30, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Sunday", -1))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Mo", -1), $x + 46, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Monday", -1))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Tu", -1), $x + 63, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Tuesday", -1))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "We", -1), $x + 79, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Wednesday", -1))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Th", -1), $x + 99, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Thursday", -1))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Fr", -1), $x + 117, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Friday", -1))
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Sa", -1), $x + 133, $y, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Saturday", -1))
		GUICtrlCreateLabel("X", $x + 155, $y+1, -1, 15)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))

	$y += 13
		$g_ahChkAttackCGWeekdays[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 16, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_ahChkAttackCGWeekdays[1] = GUICtrlCreateCheckbox("", $x + 47, $y, 16, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_ahChkAttackCGWeekdays[2] = GUICtrlCreateCheckbox("", $x + 64, $y, 16, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_ahChkAttackCGWeekdays[3] = GUICtrlCreateCheckbox("", $x + 81, $y, 16, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_ahChkAttackCGWeekdays[4] = GUICtrlCreateCheckbox("", $x + 99, $y, 16, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_ahChkAttackCGWeekdays[5] = GUICtrlCreateCheckbox("", $x + 117, $y, 16, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_ahChkAttackCGWeekdays[6] = GUICtrlCreateCheckbox("", $x + 133, $y, 16, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Only_during_day", -1))
		$g_ahChkAttackCGWeekdaysE = GUICtrlCreateCheckbox("", $x + 151, $y, 15, 15, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkattackCGWeekDaysE")

	$x -= 25
	$y += 17
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & ":", $x, $y, -1, 15)
			$sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", "Only during these hours of each day")
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 0", $x + 30, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 1", $x + 45, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 2", $x + 60, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 3", $x + 75, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 4", $x + 90, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 5", $x + 105, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 6", $x + 120, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 7", $x + 135, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 8", $x + 150, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel(" 9", $x + 165, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel("10", $x + 180, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel("11", $x + 195, $y, 13, 15)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel("X", $x + 214, $y + 1, 11, 11)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 15
		$g_ahChkAttackCGHours[0] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[1] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[2] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[3] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[4] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[5] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[6] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[7] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[8] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[9] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[10] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[11] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
		   GUICtrlSetState(-1, $GUI_CHECKED)
		   GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahChkAttackCGHoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
		   _GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
		   GUICtrlSetState(-1, $GUI_UNCHECKED)
		   GUICtrlSetState(-1, $GUI_DISABLE)
		   _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
		   GUICtrlSetOnEvent(-1, "chkattackCGHoursE1")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "AM", "AM"), $x + 10, $y)

	$y += 15
		$sTxtTip = GetTranslatedFileIni("MBR Global GUI Design", "Only_during_hours", -1)
		$g_ahChkAttackCGHours[12] = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[13] = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[14] = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[15] = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[16] = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[17] = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[18] = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[19] = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[20] = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[21] = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[22] = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHours[23] = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_ahChkAttackCGHoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y + 1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
			_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnGoldStar, 0)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Global GUI Design", "Clear_set_row_of_boxes", -1))
			GUICtrlSetOnEvent(-1, "chkattackCGHoursE2")
		$g_ahChkAttackCGHoursE2Label = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "PM", "PM"), $x + 10, $y)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$g_hTxtCGRandomLog = GUICtrlCreateEdit("", 15, 290, $g_iSizeWGrpTab4, 130, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, "--------------------------------------------- Log of Clan Games Enabling------------------------------------------")
EndFunc