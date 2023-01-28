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
; Forecast Tab
;~ -------------------------------------------------------------
Global $g_hChkForecastEnable = 0, $g_hCmbPriorityForecast = 0, $lblForecastSource = 0
Global $g_hLabelForecastPauseInterval = 0, $g_hForecastPauseIntervalMin = 0, $g_hForecastPauseIntervalMax = 0
Global $g_hForecastPauseIntervalAnd = 0, $g_hForecastPauseIntervalUnit = 0
Global $g_hChkForecastBoostEnable = 0, $g_hCmbPriorityForecastBoost = 0, $TitleActualForecast = 0, $ActualForecastReturn = 0, $ActualForecastReturnTime = 0, _
	   $ActualForecastReturnTimeAT = 0, $AskActualForecast = 0
Global $g_hCmbForecastCheckFrequencyLabel = 0, $g_hCmbForecastCheckFrequency = 0

Func TabForecastGUI()
	
	Local $x = 10, $y = 30
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Forecaster", "Group_01", "Forecast Management"), $x , $y , 430, 400)
	
	$x += 5
	$y += 25
	
	$g_hLastControlToHidemod = GUICtrlCreateDummy()
	
	$lblForecastSource = _GUICtrlCreatePic($g_sIcnForecaster, $x + 60, $y , -1, -1)
	GUICtrlSetCursor(-1, 0)
	
	$x += 5
	$y += 70
	
	GUICtrlCreateGroup("", $x + 89 , $y , 220, 40)
	
	$TitleActualForecast = GUICtrlCreateLabel("Forecast Score : ", $x + 104, $y + 13, 100, -1)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_TEAL)
	$ActualForecastReturn =  GUICtrlCreateLabel("", $x + 208, $y + 11, 60, 25)
	GUICtrlSetFont(-1, 12, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_TEAL)
	$ActualForecastReturnTimeAT =  GUICtrlCreateLabel("At", $x + 237, $y + 13, 60, 20)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_TEAL)
	$ActualForecastReturnTime =  GUICtrlCreateLabel("", $x + 257, $y + 13, 60, 20)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_TEAL)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$g_hFirstControlToHidemod = GUICtrlCreateDummy()
	
	$AskActualForecast = GUICtrlCreateButton("Check Now", $x + 325, $y + 8, 70, 28)
	_GUICtrlSetTip(-1,"Use This To Ask Actual Forecast Before Starting Bot")
	GUICtrlSetOnEvent(-1, "btnChkForecast")
		
	$y += 55
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Forecaster", "Group_02", "Forecast Check To Play"), $x , $y , 410, 90)
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnStop, $x + 20, $y + 25, 24, 24)
	$g_hChkForecastEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - Forecaster", "chkForecastEnable", "Pause Bot When Below :"), $x + 55, $y + 26, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkForecastEnable")
	$g_hCmbPriorityForecast = GUICtrlCreateCombo("", $x + 200, $y + 25, 50, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "2|2.5|3|3.5|4|4.5|5|5.5|6|6.5|7", "3")
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnChrono, $x + 20, $y + 60, 24, 24)
	$g_hLabelForecastPauseInterval = GUICtrlCreateLabel("Time Before Live Recheck : Between", $x + 55, $y + 66, -1, -1)
	$g_hForecastPauseIntervalMin = GUICtrlCreateInput($g_iForecastPauseIntervalMin, $x + 239, $y + 64, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "ForecastPauseIntervalMin")
	$g_hForecastPauseIntervalAnd = GUICtrlCreateLabel("And", $x + 270, $y + 66, 20, -1)
	$g_hForecastPauseIntervalMax = GUICtrlCreateInput($g_iForecastPauseIntervalMax, $x + 295, $y + 64, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 2)
	GUICtrlSetOnEvent(-1, "ForecastPauseIntervalMax")
	$g_hForecastPauseIntervalUnit = GUICtrlCreateLabel("mn", $x + 328, $y + 66, 20, -1)		
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 100
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Forecaster", "Group_03", "Forecast Check To Boost Everything"), $x , $y , 410, 70)
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModForecastBoost, $x + 20, $y + 25, 24, 24)
	$g_hChkForecastBoostEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - Forecast", "chkForecastBoostEnable", "Boost Only When Above :"), $x + 55, $y + 28, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkForecastBoostEnable")
	$g_hCmbPriorityForecastBoost = GUICtrlCreateCombo("", $x + 200, $y + 28, 50, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "6|6.5|7|7.5|8|8.5|9", "8")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 75
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - Forecaster", "Group_04", "Forecast Check Frequency"), $x , $y , 410, 50)
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModRecycle, $x + 21, $y + 17, 24, 24)
	$g_hCmbForecastCheckFrequencyLabel = GUICtrlCreateLabel("Minimum Check Interval Time :", $x + 55, $y + 23, -1, -1)
	$g_hCmbForecastCheckFrequency = GUICtrlCreateCombo("", $x + 210, $y + 19, 50, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0 Min.|1 Min.|2 Min.|3 Min.|4 Min.|5 Min.", "3 Min.")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
			
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateForecastTab

