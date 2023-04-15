; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: AnubiS (2021)
; Modified ......: 2023
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
; Mod Tabs
;~ -------------------------------------------------------------
Func chkUseBotHumanization()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		$g_bUseBotHumanization = True
		For $i = $g_hChkLookAtRedNotifications To $g_hBtnSecondaryVillages
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		chkLookAtRedNotifications()
		ChkForumRequestOnly()
		cmbStandardReplay()
		cmbWarReplay()
		GuiLookatCurrentWar()
		ViewBattleLog()
	Else
		$g_bUseBotHumanization = False
		For $i = $g_hChkLookAtRedNotifications To $g_hBtnSecondaryVillages
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkUseBotHumanization

Func chkLookAtRedNotifications()
	If GUICtrlRead($g_hChkLookAtRedNotifications) = $GUI_CHECKED Then
		$g_bLookAtRedNotifications = True
		GUICtrlSetState($g_IsRefusedFriends, $GUI_ENABLE)
	Else
		$g_bLookAtRedNotifications = False
		GUICtrlSetState($g_IsRefusedFriends, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkLookAtRedNotifications

Func ChkForumRequestOnly()
	If GUICtrlRead($g_hChkForumRequestOnly) = $GUI_CHECKED Then
		$g_bForumRequestOnly = True
		GUICtrlSetState($g_hBtnWelcomeMessage, $GUI_ENABLE)
		chkUseWelcomeMessage()
	Else
		$g_bForumRequestOnly = False
		GUICtrlSetState($g_hBtnWelcomeMessage, $GUI_DISABLE)
	EndIf
EndFunc

Func cmbStandardReplay()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		If (_GUICtrlComboBox_GetCurSel($g_acmbPriority[1]) > 0) Or (_GUICtrlComboBox_GetCurSel($g_acmbPriority[2]) > 0) Then
			For $i = $g_hLabel7 To $g_acmbPause[0]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
		Else
			For $i = $g_hLabel7 To $g_acmbPause[0]
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	EndIf
EndFunc   ;==>cmbStandardReplay

Func cmbWarReplay()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		If _GUICtrlComboBox_GetCurSel($g_acmbPriority[8]) > 0 Then
			For $i = $g_hLabel13 To $g_acmbPause[1]
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_ENABLE)
			Next
		Else
			For $i = $g_hLabel13 To $g_acmbPause[1]
				GUICtrlSetState($i, $GUI_DISABLE)
			Next
			For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	EndIf
EndFunc   ;==>cmbWarReplay

Func GuiLookatCurrentWar()
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_CHECKED Then
		If _GUICtrlComboBox_GetCurSel($g_acmbPriority[7]) > 0 Then
			For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_ENABLE)
			Next
		Else
			For $i = $g_HowManyinCWLabel To $g_HowManyinCWLCombo
			GUICtrlSetState($i, $GUI_DISABLE)
			Next
		EndIf
	EndIf
EndFunc   ;==>cmbWarReplay

Func chkForecastEnable()
	$g_bForecastEnable = (GUICtrlRead($g_hChkForecastEnable) = $GUI_CHECKED)
	For $i = $g_hCmbPriorityForecast To $g_hForecastPauseIntervalUnit
		GUICtrlSetState($i, $g_bForecastEnable ? $GUI_ENABLE : $GUI_DISABLE)
	Next
If $g_iCmbPriorityForecast = 0 Then
	$g_iCmbPauseForecastBelow = 2
Else
	$g_iCmbPauseForecastBelow = ($g_iCmbPriorityForecast / 2) + 2
EndIf	
ChkVillageReport()
ChkVillageReport2()
If GUICtrlRead($g_hChkForecastEnable) = $GUI_UNCHECKED And GUICtrlRead($g_hChkForecastBoostEnable) = $GUI_UNCHECKED Then
	For $i = $g_hLabelForecastPauseInterval to $g_hForecastPauseIntervalMax
		GUICtrlSetState($i, $GUI_DISABLE)
	Next
ElseIf GUICtrlRead($g_hChkForecastEnable) = $GUI_CHECKED Then
	For $i = $g_hLabelForecastPauseInterval to $g_hForecastPauseIntervalMax
		GUICtrlSetState($i, $GUI_ENABLE)
	Next
EndIf
If GUICtrlRead($g_hChkForecastEnable) = $GUI_CHECKED Then
	GUICtrlSetState($g_hChkTrophyDropinPause, $GUI_ENABLE)
	GUICtrlSetState($g_hChkVisitBbaseinPause, $GUI_ENABLE)
Else
	If GUICtrlRead($g_hChkAttackPlannerEnable) = $GUI_CHECKED Then 
		GUICtrlSetState($g_hChkTrophyDropinPause, $GUI_ENABLE)
		GUICtrlSetState($g_hChkVisitBbaseinPause, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkTrophyDropinPause, $GUI_DISABLE)
		GUICtrlSetState($g_hChkVisitBbaseinPause, $GUI_DISABLE)
	EndIf
EndIf
If $currentForecast = 0 Then
	GUICtrlSetData($ActualForecastReturn, "??")
	GUICtrlSetData($ActualForecastReturnTime, "?????")
Else
	If $IsForecastDown Then
		GUICtrlSetData($ActualForecastReturn, "XX")
	Else
		GUICtrlSetData($ActualForecastReturn, _NumberFormat($currentForecast, True))
	EndIf
	GUICtrlSetData($ActualForecastReturnTime, $ForecastTimeStamp)
EndIf
EndFunc

Func ForecastPauseIntervalMin()
	If Int(GUICtrlRead($g_hForecastPauseIntervalMax)) < Int(GUICtrlRead($g_hForecastPauseIntervalMin)) Then
		GUICtrlSetData($g_hForecastPauseIntervalMin, GUICtrlRead($g_hForecastPauseIntervalMax))
	EndIf
	$g_iForecastPauseIntervalMin = Int(GUICtrlRead($g_hForecastPauseIntervalMin))
EndFunc   ;==>ForecastPauseIntervalMin

Func ForecastPauseIntervalMax()
	If Int(GUICtrlRead($g_hForecastPauseIntervalMax)) < Int(GUICtrlRead($g_hForecastPauseIntervalMin)) Then
		GUICtrlSetData($g_hForecastPauseIntervalMax, GUICtrlRead($g_hForecastPauseIntervalMin))
	EndIf
	$g_iForecastPauseIntervalMax = Int(GUICtrlRead($g_hForecastPauseIntervalMax))
EndFunc   ;==>ForecastPauseIntervalMax

Func btnChkForecast()
$currentForecast = readCurrentForecast()
$ForecastTimeStamp = _NowTime(4)
If $IsForecastDown Then
	GUICtrlSetData($ActualForecastReturn, "XX")
Else
	GUICtrlSetData($ActualForecastReturn, _NumberFormat($currentForecast, True))
EndIf
GUICtrlSetData($ActualForecastReturnTime, $ForecastTimeStamp)
EndFunc   ;==>btnChkForecast

Func chkForecastBoostEnable()
	$g_bForecastBoostEnable = (GUICtrlRead($g_hChkForecastBoostEnable) = $GUI_CHECKED)
	For $i = $g_hCmbPriorityForecastBoost to $g_hCmbPriorityForecastBoost
		GUICtrlSetState($i, $g_bForecastBoostEnable ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	
	Switch $g_iCmbPriorityForecastBoost
		Case 0
			$g_iCmbForecastBoost = 6
		Case 1
			$g_iCmbForecastBoost = 6.5
		Case 2
			$g_iCmbForecastBoost = 7
		Case 3
			$g_iCmbForecastBoost = 7.5
		Case 4
			$g_iCmbForecastBoost = 8
		Case 5
			$g_iCmbForecastBoost = 8.5
		Case 6
			$g_iCmbForecastBoost = 9
	EndSwitch

ChkVillageReport()
ChkVillageReport2()
If $currentForecast = 0 Then
	GUICtrlSetData($ActualForecastReturn, "??")
	GUICtrlSetData($ActualForecastReturnTime, "?????")
Else
	If $IsForecastDown Then
		GUICtrlSetData($ActualForecastReturn, "XX")
	Else
		GUICtrlSetData($ActualForecastReturn, _NumberFormat($currentForecast, True))
	EndIf
	GUICtrlSetData($ActualForecastReturnTime, $ForecastTimeStamp)
EndIf
EndFunc

Func _RoundDown($nVar, $iCount)
    Return Round((Int($nVar * (10 ^ $iCount))) / (10 ^ $iCount), $iCount)
EndFunc

Func IsForecastWebSiteReached()
    Local $TimerURL, $PID, $timeout_server = 500;(500 ms)
	Local $Reached = True
    FileDelete(@tempdir&"\initread.txt")
    $TimerURL = TimerInit()
    $PID = Run(@AutoItexe & ' /AutoIt3ExecuteLine "filewrite(@tempdir&''\initread.txt'',inetread( ''http://clashofclansforecaster.com'',1))"',"",@SW_HIDE)
    While 1
        If $PID = 0 Or TimerDiff($TimerURL) >= $timeout_server Then
            ProcessClose($PID)
			$Reached = False
        ElseIf FileExists(@tempdir&"\initread.txt") And Not ProcessExists($PID) Then
           FileDelete(@tempdir&"\initread.txt")
        Else
            ContinueLoop
        EndIf
        ExitLoop
    WEnd
	If FileExists(@tempdir&"\initread.txt") Then FileDelete(@tempdir&"\initread.txt")
	Return $Reached
Endfunc

Func readCurrentForecast()
;	Ping("clashofclansforecaster.com", 500)
;	If @error <> 0 Then
	If Not IsForecastWebSiteReached() Then
		If $g_bForecastEnable Or $g_bForecastBoostEnable Then SetLog("Forecast Seems To Be Down!", $COLOR_RED)
		$IsForecastDown = True
		GUICtrlSetData($ActualForecastReturn, "XX")
		Return False
	EndIf

	$IsForecastDown = False

	Local $return = getCurrentForecast()
	If $return > 0 Then Return $return

	Local $line = ""
	Local $filename = @ScriptDir & "\COCBot\Forecast\forecast.mht"

	SetLog("Reading Forecast...", $COLOR_BLUE)

	_INetGetMHT( "http://clashofclansforecaster.com", $filename)

	Local $file = FileOpen($filename, 0)
	If $file = -1 Then
		SetLog("     Error reading forecast!", $COLOR_RED)
		Return False
	EndIf

	ReDim $dtStamps[0]
	ReDim $lootMinutes[0]
	While 1
		$line = FileReadLine($file)
		If @error <> 0 Then ExitLoop
		If StringCompare(StringLeft($line, StringLen("<script language=""javascript"">var militaryTime")), "<script language=""javascript"">var militaryTime") = 0 Then
			Local $pos1
			Local $pos2

			$pos1 = StringInStr($line, "minuteNow")
			If $pos1 > 0 Then
				$pos1 = StringInStr($line, ":", 0, 1, $pos1 + 1)
				If $pos1 > 0 Then
					$pos2 = StringInStr($line, ",", 9, 1, $pos1 + 1)
					Local $minuteNowString = StringMid($line, $pos1 + 1, $pos2 - $pos1 - 1)
					$timeOffset = Int($minuteNowString) - nowTicksUTC()
				EndIf
			EndIf

			$pos1 = StringInStr($line, "dtStamps")
			If $pos1 > 0 Then
				$pos1 = StringInStr($line, "[", 0, 1, $pos1 + 1)
				If $pos1 > 0 Then
					$pos2 = StringInStr($line, "]", 9, 1, $pos1 + 1)
					Local $dtStampsString = StringMid($line, $pos1 + 1, $pos2 - $pos1 - 1)
					$dtStamps = StringSplit($dtStampsString, ",", 2)
				EndIf
			EndIf

			$pos1 = StringInStr($line, "lootMinutes", 0, 1, $pos1 + 1)
			If $pos1 > 0 Then
				$pos1 = StringInStr($line, "[", 0, 1, $pos1 + 1)
				If $pos1 > 0 Then
					$pos2 = StringInStr($line, "]", 9, 1, $pos1 + 1)
					Local $minuteString = StringMid($line, $pos1 + 1, $pos2 - $pos1 - 1)
					$lootMinutes = StringSplit($minuteString, ",", 2)
				EndIf
			EndIf

			$pos1 = StringInStr($line, "lootIndexScaleMarkers", 0, 1, $pos1 + 1)
			If $pos1 > 0 Then
				$pos1 = StringInStr($line, "[", 0, 1, $pos1 + 1)
				If $pos1 > 0 Then
					$pos2 = StringInStr($line, "]", 9, 1, $pos1 + 1)
					Local $lootIndexScaleMarkersString = StringMid($line, $pos1 + 1, $pos2 - $pos1 - 1)
					$lootIndexScaleMarkers = StringSplit($lootIndexScaleMarkersString, ",", 2)
				EndIf
			EndIf

			ExitLoop
		EndIf
	WEnd
	FileClose($file)
	$return = getCurrentForecast()
	If $return = 0 Then
		SetLog("Error parsing forecast.")
	EndIf
	Return $return
EndFunc

Func _INetGetMHT( $url, $file )
	Local $msg = ObjCreate("CDO.Message")
	If @error Then Return False
	Local $ado = ObjCreate("ADODB.Stream")
	If @error Then Return False
	Local $conf = ObjCreate("CDO.Configuration")
	If @error Then Return False

	With $ado
		.Type = 2
		.Charset = "US-ASCII"
		.Open
	EndWith

	Local $flds = $conf.Fields
	$flds.Item("http://schemas.microsoft.com/cdo/configuration/urlgetlatestversion") = True
	$flds.Update()
	$msg.Configuration = $conf
	$msg.CreateMHTMLBody($url, 31)
	$msg.DataSource.SaveToObject($ado, "_Stream")
	FileDelete($file)
	$ado.SaveToFile($file, 1)
	$msg = ""
	$ado = ""
	Return True
EndFunc

Func getCurrentForecast()
	Local $return = 0
	Local $nowTicks = nowTicksUTC() + $timeOffset ; + 240
	If UBound($dtStamps) > 0 And UBound($lootMinutes) > 0 And UBound($dtStamps) = UBound($lootMinutes) Then
		If $nowTicks >= Int($dtStamps[0]) And $nowTicks <= Int($dtStamps[UBound($dtStamps) - 1]) Then
			Local $i
			For $i = 0 To UBound($dtStamps) - 1
				If $nowTicks >= Int($dtStamps[$i]) Then
					$return = Int($lootMinutes[$i])
				Else
					ExitLoop
				EndIf
			Next
		Else
			Return 0
		EndIf
	Else
		Return 0
	EndIf

	Return CalculateIndex($return)
EndFunc

Func CalculateIndex($minutes)
	Local $index = 0
	If $minutes < $lootIndexScaleMarkers[0] Then
		$index = $minutes / $lootIndexScaleMarkers[0]
	ElseIf $minutes < $lootIndexScaleMarkers[1] Then
		$index = (($minutes - $lootIndexScaleMarkers[0]) / ($lootIndexScaleMarkers[1] - $lootIndexScaleMarkers[0])) + 1
	ElseIf $minutes < $lootIndexScaleMarkers[2] Then
		$index = (($minutes - $lootIndexScaleMarkers[1]) / ($lootIndexScaleMarkers[2] - $lootIndexScaleMarkers[1])) + 2
	ElseIf $minutes < $lootIndexScaleMarkers[3] Then
		$index = (($minutes - $lootIndexScaleMarkers[2]) / ($lootIndexScaleMarkers[3] - $lootIndexScaleMarkers[2])) + 3
	ElseIf $minutes < $lootIndexScaleMarkers[4] Then
		$index = (($minutes - $lootIndexScaleMarkers[3]) / ($lootIndexScaleMarkers[4] - $lootIndexScaleMarkers[3])) + 4
	ElseIf $minutes < $lootIndexScaleMarkers[5] Then
		$index = (($minutes - $lootIndexScaleMarkers[4]) / ($lootIndexScaleMarkers[5] - $lootIndexScaleMarkers[4])) + 5
	ElseIf $minutes < $lootIndexScaleMarkers[6] Then
		$index = (($minutes - $lootIndexScaleMarkers[5]) / ($lootIndexScaleMarkers[6] - $lootIndexScaleMarkers[5])) + 6
	ElseIf $minutes < $lootIndexScaleMarkers[7] Then
		$index = (($minutes - $lootIndexScaleMarkers[6]) / ($lootIndexScaleMarkers[7] - $lootIndexScaleMarkers[6])) + 7
	ElseIf $minutes < $lootIndexScaleMarkers[8] Then
		$index = (($minutes - $lootIndexScaleMarkers[7]) / ($lootIndexScaleMarkers[8] - $lootIndexScaleMarkers[7])) + 8
	ElseIf $minutes < $lootIndexScaleMarkers[9] Then
		$index = (($minutes - $lootIndexScaleMarkers[8]) / ($lootIndexScaleMarkers[9] - $lootIndexScaleMarkers[8])) + 9
	Else
		$index = (($minutes - $lootIndexScaleMarkers[9]) / (44739594 - $lootIndexScaleMarkers[9])) + 10
	EndIf
	Return _RoundDown($index, 1)
EndFunc

Func nowTicksUTC()
	Local $now = _Date_Time_GetSystemTime()
	Local $nowUTC = _Date_Time_SystemTimeToDateTimeStr($now)
	$nowUTC = StringMid($nowUTC, 7, 4) & "/" & StringMid($nowUTC, 1, 2) & "/" & StringMid($nowUTC, 4, 2) & StringMid($nowUTC, 11)
	Return _DateDiff('s', "1970/01/01 00:00:00", $nowUTC)
EndFunc

Func IsForecastChecked($SetLog = True)
If $g_bForecastEnable Or $g_bForecastBoostEnable Then
	$ForecastCheckTimerDiff = TimerDiff($ForecastCheckTimer)
	If $ForecastCheckTimerDiff > $ReadForecastRepeatDelay Or $ForecastCheckTimer = 0 Or $g_bFirstStartForForecast = 1 Or $RecheckForecastAfterPause = 1 Then
		$ForecastCheckTimer = TimerInit()
		$currentForecast = readCurrentForecast()
		If $IsForecastDown Then $SetLog = False
		$ForecastTimeStamp = _NowTime(4)
		If $IsForecastDown Then
			GUICtrlSetData($ActualForecastReturn, "XX")
		Else
			GUICtrlSetData($ActualForecastReturn, _NumberFormat($currentForecast, True))
		EndIf
		GUICtrlSetData($ActualForecastReturnTime, $ForecastTimeStamp)
	EndIf
	If $currentForecast < $g_iCmbPauseForecastBelow Then
		If $SetLog Then SetLog("Current Forecast : " & $currentForecast & "", $COLOR_RED)
	Else
		If $SetLog Then SetLog("Current Forecast : " & $currentForecast & "", $COLOR_GREEN)
	EndIf
	$g_bFirstStartForForecast = 0
	$RecheckForecastAfterPause = 0
ElseIf Not $g_bForecastEnable And Not $g_bForecastBoostEnable Then
	$ForecastCheckTimerDiff = TimerDiff($ForecastCheckTimer)
	If $ForecastCheckTimerDiff > $ReadForecastRepeatDelay Or $ForecastCheckTimer = 0 Or $g_bFirstStartForForecast = 1 Or $RecheckForecastAfterPause = 1 Then
		$ForecastCheckTimer = TimerInit()
		$currentForecast = readCurrentForecast()
		If $IsForecastDown Then $SetLog = False
		$ForecastTimeStamp = _NowTime(4)
		If $IsForecastDown Then
			GUICtrlSetData($ActualForecastReturn, "XX")
		Else
			GUICtrlSetData($ActualForecastReturn, _NumberFormat($currentForecast, True))
		EndIf
		GUICtrlSetData($ActualForecastReturnTime, $ForecastTimeStamp)
	EndIf
	If $SetLog Then SetLog("Current Forecast : " & $currentForecast & "", $COLOR_BLUE)
EndIf
EndFunc

Func IsForecastBAD($SetLog = True)
If $g_bForecastEnable Or $g_bForecastBoostEnable Then
	If $IsForecastDown Then
		SetLog("Forecast is Down : Override Settings", $COLOR_WARNING)
		SetLog("Let's Play", $COLOR_WARNING)
		Return False
	EndIf
	Local $StopEmulator = False
	Local $bFullRestart = True
	Local $bSuspendComputer = False
	If $g_bCloseRandom Then $StopEmulator = "random"
	If $g_bDropTrophyEnable And $g_bChkTrophyDropinPause And (Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMax) Or $IsdroptrophiesActive) Then
		If $currentForecast < $g_iCmbPauseForecastBelow Then SetLog("Forget Forecast To Drop Trophies !", $COLOR_BLUE)	
		Return False
	ElseIf $g_iCmbPauseForecastBelow > $currentForecast Then
		If Not IsSearchAttackEnabled(True) Then Return
		SetLog("Forecast is bad for now", $COLOR_INFO)
		SetLog("Prepare Bot before pause...", $COLOR_WARNING)
		If $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack) Then SwitchBetweenBasesMod()
		If $IstoSwitchMod And $g_bChkVisitBbaseinPause And ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_iChkBBSuggestedUpgrades Or $g_bChkEnableBBAttack) Then
			If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
				UpgradeWall()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeBuilding()
				If _Sleep($DELAYRUNBOT3) Then Return
				AutoUpgrade()
				If _Sleep($DELAYRUNBOT3) Then Return
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
					'PetHouse', 'BuilderBase']
				Else
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _ 
					'PetHouse', 'BuilderBase']
				EndIf
			Else	
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
					'UpgradeBuilding', 'PetHouse', 'BuilderBase']
				Else
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _ 
					'UpgradeBuilding', 'PetHouse', 'BuilderBase']
				EndIf
			EndIf
			$IstoSwitchMod = 0
		Else
			If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
				UpgradeWall()
				If _Sleep($DELAYRUNBOT3) Then Return
				UpgradeBuilding()
				If _Sleep($DELAYRUNBOT3) Then Return
				AutoUpgrade()
				If _Sleep($DELAYRUNBOT3) Then Return
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
					'PetHouse']
				Else
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _ 
					'PetHouse']
				EndIf
			Else	
				If IsToFillCCWithMedalsOnly() Then
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
					'UpgradeBuilding', 'PetHouse']
				Else
					Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _ 
					'UpgradeBuilding', 'PetHouse']
				EndIf
			EndIf
		EndIf
		For $Index In $aRndFuncList
			_RunFunction($Index)
		Next
		If _Sleep(1000) Then Return
		If $g_bChkPersoChallengesinPause Then DailyChallenges(False)
		If _Sleep(1000) Then Return
		CollectCCGold()
		If SwitchBetweenBasesMod2() Then
			ForgeClanCapitalGold()
			_Sleep($DELAYRUNBOT3)
			AutoUpgradeCC()
			_Sleep($DELAYRUNBOT3)
		EndIf
		If _Sleep($DELAYRESPOND) Then Return
		$g_bRestart = True
		$g_bFirstStartForForecast = 0
		$RecheckForecastAfterPause = 1
		Local $g_iacmdRandomDelayforForecastPause = Random(($g_iForecastPauseIntervalMin * 60), ($g_iForecastPauseIntervalMax * 60), 1)
		Local $RandomiWaitTime2ForecastPause = Round(($g_iacmdRandomDelayforForecastPause / 60), 2)
		SetLog("Time before Live Recheck : " & $RandomiWaitTime2ForecastPause & " mn", $COLOR_BLUE)
		If $RandomiWaitTime2ForecastPause < 11 Then $StopEmulator = False
		Local $iWaitTime = $RandomiWaitTime2ForecastPause * 60 * 1000; compute mseconds
		;close emulator as directed
		UniversalCloseWaitOpenCoC($iWaitTime, "SmartWait4TrainForecast_", $StopEmulator, $bFullRestart, $bSuspendComputer)
		$g_bRestart = True
		$IsMainScreenLocated = 0
		Return True
	Else
		If $SetLog Then SetLog("Forecast meets settings, Let's Continue !", $COLOR_BLUE)	
		Return False
	EndIf
ElseIf Not $g_bForecastEnable And Not $g_bForecastBoostEnable Then
	Return False
EndIf
EndFunc

Func IsForecastBoostAllowed()
If $IsForecastDown Then
	SetLog("Forecast is Down : Override Settings", $COLOR_WARNING)
	Return False
EndIf
If $g_iCmbForecastBoost > $currentForecast Then
	Return False
Else
	Return True
EndIf
EndFunc

Func DisplayChkNoLabCheck()
	Switch _GUICtrlComboBox_GetCurSel($g_hChkNoLabCheck)
		Case 0
			$g_hChkNoLabCheckLabelTypo = "Never Check Laboratory"
		Case 1
			$g_hChkNoLabCheckLabelTypo = "Check Laboratory Just One Time"
		Case 2
			$g_hChkNoLabCheckLabelTypo = "Check Regulary (2->5 hours)"
	EndSwitch
	GUICtrlSetData($g_hChkNoLabCheckLabel, $g_hChkNoLabCheckLabelTypo)
EndFunc

Func DisplayChkNoPetHouseCheck()
	Switch _GUICtrlComboBox_GetCurSel($g_hChkNoPetHouseCheck)
		Case 0
			$g_hChkNoPetHouseCheckLabelTypo = "Never Check Pet House"
		Case 1
			$g_hChkNoPetHouseCheckLabelTypo = "Check Pet House Just One Time"
		Case 2
			$g_hChkNoPetHouseCheckLabelTypo = "Check Regulary (2->5 hours)"
	EndSwitch
If $g_iTownHallLevel > 13 Then ; Must be TH14 to Have Pet House
	GUICtrlSetState($g_hChkNoPetHouseCheck, $GUI_ENABLE)
ElseIf $g_iTownHallLevel > 0 And $g_iTownHallLevel < 14 Then
	GUICtrlSetData($g_hChkNoPetHouseCheck, "Never")
	_Ini_Add("Advanced", "NoPetHouseCheck", 0)
	GUICtrlSetState($g_hChkNoPetHouseCheck, $GUI_DISABLE)
	$g_hChkNoPetHouseCheckLabelTypo = "TownHall Is Not Level 14"
ElseIf $g_iTownHallLevel = 0 Then
	GUICtrlSetData($g_hChkNoPetHouseCheck, "Never")
	_Ini_Add("Advanced", "NoPetHouseCheck", 0)
	GUICtrlSetState($g_hChkNoPetHouseCheck, $GUI_DISABLE)
	$g_hChkNoPetHouseCheckLabelTypo = "TH Level 14 Required, Please Locate TH"
EndIf
GUICtrlSetData($g_hChkNoPetHouseCheckLabel, $g_hChkNoPetHouseCheckLabelTypo)
EndFunc

Func DisplayChkNoStarLabCheck()
	Switch _GUICtrlComboBox_GetCurSel($g_hChkNoStarLabCheck)
		Case 0
			$g_hChkNoStarLabCheckLabelTypo = "Never Check StarLab"
		Case 1
			$g_hChkNoStarLabCheckLabelTypo = "Check StarLab Just One Time"
		Case 2
			$g_hChkNoStarLabCheckLabelTypo = "Check Regulary (2->5 hours)"
	EndSwitch
GUICtrlSetData($g_hChkNoStarLabCheckLabel, $g_hChkNoStarLabCheckLabelTypo)
EndFunc

Func MagicItemsFrequencyDatas()
	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityMagicItemsFrequency) = 0 Or GUICtrlRead($g_hChkFreeMagicItems) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hcmbAdvancedVariation[0], $GUI_DISABLE)
	ElseIf GUICtrlRead($g_hChkFreeMagicItems) = $GUI_CHECKED And _GUICtrlComboBox_GetCurSel($g_hCmbPriorityMagicItemsFrequency) > 0 Then 
		GUICtrlSetState($g_hcmbAdvancedVariation[0], $GUI_ENABLE)
	EndIf
EndFunc

Func BBaseFrequencyDatas()
	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityBBaseFrequency) = 0 Then
		GUICtrlSetState($g_hcmbAdvancedVariation[1], $GUI_DISABLE)
	Else
		If GUICtrlRead($g_hChkBBaseFrequency) = $GUI_CHECKED Then GUICtrlSetState($g_hcmbAdvancedVariation[1], $GUI_ENABLE)
	EndIf
EndFunc

Func ChkBBaseFrequency()
	If GUICtrlRead($g_hChkBBaseFrequency) = $GUI_CHECKED Then
		$g_bChkBBaseFrequency = True
		For $i = $g_hChkBBaseFrequencyLabel To $g_hcmbAdvancedVariation[1]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		$g_bChkBBaseFrequency = False
		For $i = $g_hChkBBaseFrequencyLabel To $g_hcmbAdvancedVariation[1]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc

Func PersoChallengesFrequencyDatas()
	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityPersoChallengesFrequency) = 0 Then
		GUICtrlSetState($g_hcmbAdvancedVariation[2], $GUI_DISABLE)
	Else
		If GUICtrlRead($g_hChkCollectRewards) = $GUI_CHECKED Then GUICtrlSetState($g_hcmbAdvancedVariation[2], $GUI_ENABLE)
	EndIf
EndFunc

Func ChkCollectRewards()
If GUICtrlRead($g_hChkCollectRewards) = $GUI_CHECKED Then
		$g_bChkCollectRewards = True
		For $i = $g_hChkPersoChallengesFrequencyLabel To $g_hcmbAdvancedVariation[2]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityPersoChallengesFrequency) = 0 Then GUICtrlSetState($g_hcmbAdvancedVariation[2], $GUI_DISABLE)
		GUICtrlSetState($g_hChkPersoChallengesinPause, $GUI_ENABLE)
	Else
		$g_bChkCollectRewards = False
		For $i = $g_hChkPersoChallengesFrequencyLabel To $g_hcmbAdvancedVariation[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetState($g_hChkPersoChallengesinPause, $GUI_DISABLE)
	EndIf
EndFunc

Func SwitchBetweenBasesMod()
If Not $g_bFirstStartAccountSBB Then
	$IstoSwitchMod = 0
	$BBaseCheckTimer = 0
	$DelayReturnedtocheckBBaseMS = 0
	$g_bFirstStartAccountSBB = 1
EndIf

	$g_iCmbPriorityBBaseFrequency = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityBBaseFrequency) * 60 * 60 * 1000
	$g_icmbAdvancedVariation[1] = _GUICtrlComboBox_GetCurSel($g_hcmbAdvancedVariation[1]) / 10
	
If Not $g_bChkCollectBuilderBase And Not $g_bChkStartClockTowerBoost And Not $g_iChkBBSuggestedUpgrades And Not $g_bChkEnableBBAttack And Not $g_bChkCleanBBYard Then
	If $g_bIsBBevent Then SetLog("Please Enable BB Attack To Complete Challenge !", $COLOR_ERROR)
	$IstoSwitchMod = 0
	Return
EndIf	

If $g_bIsBBevent And Not $g_bChkEnableBBAttack Then
	SetLog("Please Enable BB Attack To Complete Challenge !", $COLOR_ERROR)
	$IstoSwitchMod = 0
	Return
EndIf

If Not $g_bChkBBaseFrequency Then ; Return True and End fonction Without Timing
	If ($g_bChkEnableForgeBBGold Or $g_bChkEnableForgeBBElix) And ($g_aiCurrentLootBB[$eLootGoldBB] = 0 Or $g_aiCurrentLootBB[$eLootElixirBB] = 0) Then
		$IstoSwitchMod = 1
		Return
	EndIf
	If Not IsBBDailyChallengeAvailable() Then
		$IstoSwitchMod = 0
		Return
	EndIf
	$IstoSwitchMod = 1
	Return
	
ElseIf $g_bChkBBaseFrequency Then ; Cases Check Frequency enable

	If $g_iCmbPriorityBBaseFrequency = 0 Then ; Case Everytime, Return True and End fonction Without Timing
		$IstoSwitchMod = 1
		Return
	EndIf

	If Not $BBaseCheckTimer And Not $g_bIsBBevent Then; First Time
	
		$BBaseCheckTimer = TimerInit()
	
		Local $DelayReturnedtocheckBBaseInf = ($g_iCmbPriorityBBaseFrequency - ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation[1]))
		Local $DelayReturnedtocheckBBaseSup = ($g_iCmbPriorityBBaseFrequency + ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation[1]))
		$DelayReturnedtocheckBBaseMS = Random($DelayReturnedtocheckBBaseInf, $DelayReturnedtocheckBBaseSup, 1)
		
		Local $iWaitTime = $DelayReturnedtocheckBBaseMS
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iWaitSec
	
			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		SetLog("Time to Check Builder Base", $COLOR_OLIVE)
		SetLog("Next Builder Base Check : " & $sWaitTime & "", $COLOR_OLIVE)
		If Not IsBBDailyChallengeAvailable() Then
			$IstoSwitchMod = 0
			Return
		EndIf
		$IstoSwitchMod = 1
		Return
	EndIf

	If $g_bIsBBevent Then ; Case BB Event Detected
		SetLog("BB Event Detected : Time to Switch To Builder Base", $COLOR_OLIVE)
		$BBaseCheckTimer = TimerInit()
	
		Local $DelayReturnedtocheckBBaseInf = ($g_iCmbPriorityBBaseFrequency - ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation[1]))
		Local $DelayReturnedtocheckBBaseSup = ($g_iCmbPriorityBBaseFrequency + ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation[1]))
		$DelayReturnedtocheckBBaseMS = Random($DelayReturnedtocheckBBaseInf, $DelayReturnedtocheckBBaseSup, 1)
		
		Local $iWaitTime = $DelayReturnedtocheckBBaseMS
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iWaitSec
	
			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		SetLog("Next Regular Switch To Builder Base : " & $sWaitTime & "", $COLOR_OLIVE)
		$IstoSwitchMod = 1
		Return
	EndIf

	Local $BBaseCheckTimerDiff = TimerDiff($BBaseCheckTimer)
	
	If $BBaseCheckTimer > 0 And $BBaseCheckTimerDiff < $DelayReturnedtocheckBBaseMS Then ;Delay not reached : return False
	
		Local $iWaitTime = ($DelayReturnedtocheckBBaseMS - $BBaseCheckTimerDiff)
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iWaitSec
	
			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			If $iWaitSec <= 60 Then $sWaitTime = "Imminent"
		
			SetLog("Next Builder Base Check : " & $sWaitTime & "", $COLOR_OLIVE)
			$IstoSwitchMod = 0
		Return
	EndIf
	
	If $BBaseCheckTimer > 0 And $BBaseCheckTimerDiff > $DelayReturnedtocheckBBaseMS Then ;Delay reached : reset chrono ans set new delay. Return True

			$BBaseCheckTimer = TimerInit()
				
			Local $DelayReturnedtocheckBBaseInf = ($g_iCmbPriorityBBaseFrequency - ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation[1]))
			Local $DelayReturnedtocheckBBaseSup = ($g_iCmbPriorityBBaseFrequency + ($g_iCmbPriorityBBaseFrequency * $g_icmbAdvancedVariation[1]))
			$DelayReturnedtocheckBBaseMS = Random($DelayReturnedtocheckBBaseInf, $DelayReturnedtocheckBBaseSup, 1)
	
			Local $iWaitTime = $DelayReturnedtocheckBBaseMS
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec
	
				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		
			SetLog("Time to Check Builder Base", $COLOR_OLIVE)
			SetLog("Next Builder Base Check : " & $sWaitTime & "", $COLOR_OLIVE)
			If Not IsBBDailyChallengeAvailable() Then
				$IstoSwitchMod = 0
				Return
			EndIf
			$IstoSwitchMod = 1
		Return
	EndIf
EndIf
EndFunc

Func ChkTrophyDropinPause()
If GUICtrlRead($g_hChkTrophyDropinPause) = $GUI_CHECKED Then
		$g_bChkTrophyDropinPause = True
	Else
		$g_bChkTrophyDropinPause = False
EndIf
EndFunc

Func ChkVisitBbaseinPause()
If GUICtrlRead($g_hChkVisitBbaseinPause) = $GUI_CHECKED Then
		$g_bChkVisitBbaseinPause = True
	Else
		$g_bChkVisitBbaseinPause = False
EndIf
EndFunc

Func ChkPersoChallengesinPause()
If GUICtrlRead($g_hChkPersoChallengesinPause) = $GUI_CHECKED Then
		$g_bChkPersoChallengesinPause = True
	Else
		$g_bChkPersoChallengesinPause = False
EndIf
EndFunc

Func chkRandomPauseDelayEnable()
If GUICtrlRead($g_acmdRandomDelay) = $GUI_CHECKED And $g_bAttackPlannerEnable = True Then
		$g_iacmdRandomDelay = True
		For $i = $g_acmdRandomDelayMin To $g_hLabelDelayPauseIntervalUnit
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
ElseIf GUICtrlRead($g_acmdRandomDelay) = $GUI_UNCHECKED And $g_bAttackPlannerEnable = True Then
		$g_iacmdRandomDelay = False
		For $i = $g_acmdRandomDelayMin To $g_hLabelDelayPauseIntervalUnit
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
ElseIf GUICtrlRead($g_acmdRandomDelay) = $GUI_UNCHECKED And $g_bAttackPlannerEnable = False Then
		$g_iacmdRandomDelay = False
		For $i = $g_acmdRandomDelayMin To $g_hLabelDelayPauseIntervalUnit
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
EndIf
$g_iacmdRandomDelayFinal = Random(($g_iacmdRandomDelayMin * 60), ($g_iacmdRandomDelayMax * 60), 1) ; seconds
EndFunc

Func cmdRandomDelayMin()
	If Int(GUICtrlRead($g_acmdRandomDelayMax)) < Int(GUICtrlRead($g_acmdRandomDelayMin)) Then
		GUICtrlSetData($g_acmdRandomDelayMin, GUICtrlRead($g_acmdRandomDelayMax))
	EndIf
	$g_iacmdRandomDelayMin = Int(GUICtrlRead($g_acmdRandomDelayMin))
EndFunc   ;==>cmdRandomDelayMin

Func cmdRandomDelayMax()
	If Int(GUICtrlRead($g_acmdRandomDelayMax)) < Int(GUICtrlRead($g_acmdRandomDelayMin)) Then
		GUICtrlSetData($g_acmdRandomDelayMax, GUICtrlRead($g_acmdRandomDelayMin))
	EndIf
	$g_iacmdRandomDelayMax = Int(GUICtrlRead($g_acmdRandomDelayMax))
EndFunc   ;==>cmdRandomDelayMax

Func btnModLogClear()
_GUICtrlRichEdit_SetText($g_hTxtModLog, "")
GUICtrlSetData($g_hTxtModLog, "------------------------------------------------------- Log of Mod Events -------------------------------------------------")
EndFunc   ;==>btnModLogClear

Func btnCGRALogClear()
_GUICtrlRichEdit_SetText($g_hTxtCGRandomLog, "")
GUICtrlSetData($g_hTxtCGRandomLog, "--------------------------------------------- Log of Clan Games Enabling------------------------------------------")
EndFunc   ;==>btnModLogClear

Func CGLogClear()
_GUICtrlRichEdit_SetText($g_hTxtClanGamesLog, "")
GUICtrlSetData($g_hTxtClanGamesLog, "--------------------------------------------------------- Clan Games LOG ------------------------------------------------")
EndFunc   ;==>CGLogClear

Func HowManyinCWCombo()
$g_HowManyPlayersInCW = ($g_iHowManyinCWCombo * 5) + 5
EndFunc

Func HowManyinCWLCombo()
$g_HowManyPlayersInCWL = ($g_iHowManyinCWLCombo * 5) + 5
EndFunc

Func LoadCurrentProfile()
If $g_iTxtCurrentVillageName <> "" Then
	GUICtrlSetData($g_hTxtNotifyOrigin, $g_iTxtCurrentVillageName)
ElseIf $g_iTxtCurrentVillageName = "" Then
	GUICtrlSetData($g_hTxtNotifyOrigin, $g_sProfileCurrentName)
EndIf
GUICtrlSetData($g_hGrpVillageName, GetTranslatedFileIni("MBR Main GUI", "Tab_03", "Profile") & ": " & $g_sProfileCurrentName)
GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_02", "Village") & "[TH" & $g_iTownHallLevel & "]" & " : " & $g_iTxtCurrentVillageName)
Endfunc

Func LoadCurrentAlias()
If $g_iTxtCurrentVillageName = "" Then
	GUICtrlSetData($g_iTxtCurrentVillageName, $g_sProfileCurrentName)
EndIf
GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_02", "Village") & "[TH" & $g_iTownHallLevel & "]" & " : " & $g_iTxtCurrentVillageName)
EndFunc

Func chkAttackCGPlannerEnable()
	If GUICtrlRead($g_hChkAttackCGPlannerEnable) = $GUI_CHECKED Then
		$g_bAttackCGPlannerEnable = True
		GUICtrlSetState($g_hChkAttackCGPlannerRandom, $GUI_ENABLE)
		GUICtrlSetState($g_hChkAttackCGPlannerDayLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hChkSTOPWhenCGPointsMax, $GUI_ENABLE)
		chkAttackCGPlannerDayLimit()
		cmbAttackCGPlannerRandom()
		If GUICtrlRead($g_hChkAttackCGPlannerRandom) = $GUI_CHECKED Then
			For $i = $g_hCmbAttackCGPlannerRandomTime to $g_hCmbAttackCGPlannerRandomProba
			GUICtrlSetState($i, $GUI_ENABLE)
			Next
			GUICtrlSetState($g_hTxtCGRandomLog, $GUI_ENABLE)
			For $i = 0 To 6
				GUICtrlSetState($g_ahChkAttackCGWeekdays[$i], $GUI_DISABLE)
			Next
			GUICtrlSetState($g_ahChkAttackCGWeekdaysE, $GUI_DISABLE)
			For $i = 0 To 23
				GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_DISABLE)
			Next
			GUICtrlSetState($g_ahChkAttackCGHoursE1, $GUI_DISABLE)
			GUICtrlSetState($g_ahChkAttackCGHoursE2, $GUI_DISABLE)
		Else
			For $i = $g_hCmbAttackCGPlannerRandomTime to $g_hCmbAttackCGPlannerRandomProba
			GUICtrlSetState($i, $GUI_DISABLE)
			Next
			If GUICtrlRead($g_hChkAttackCGPlannerDayLimit) = $GUI_CHECKED Then
				GUICtrlSetState($g_hTxtCGRandomLog, $GUI_ENABLE)
			Else
				GUICtrlSetState($g_hTxtCGRandomLog, $GUI_DISABLE)
			EndIf
			For $i = 0 To 6
				GUICtrlSetState($g_ahChkAttackCGWeekdays[$i], $GUI_ENABLE)
			Next
			GUICtrlSetState($g_ahChkAttackCGWeekdaysE, $GUI_ENABLE)
			For $i = 0 To 23
				GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_ENABLE)
			Next
			GUICtrlSetState($g_ahChkAttackCGHoursE1, $GUI_ENABLE)
			GUICtrlSetState($g_ahChkAttackCGHoursE2, $GUI_ENABLE)
		EndIf
	Else
		$g_bAttackCGPlannerEnable = False
		For $i = $g_hChkAttackCGPlannerRandom To $g_hTxtCGRandomLog
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_UNCHECKED Then
		For $i = $g_hChkAttackCGPlannerEnable To $g_hTxtCGRandomLog
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkAttackPlannerEnable

Func chkAttackCGPlannerRandom()
	If GUICtrlRead($g_hChkAttackCGPlannerRandom) = $GUI_CHECKED Then
		$g_bAttackCGPlannerRandomEnable = True
		For $i = $g_hCmbAttackCGPlannerRandomTime to $g_hCmbAttackCGPlannerRandomProba
		GUICtrlSetState($i, $GUI_ENABLE)
		Next
		GUICtrlSetState($g_hTxtCGRandomLog, $GUI_ENABLE)
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackCGWeekdays[$i], $GUI_DISABLE)
		Next
		GUICtrlSetState($g_ahChkAttackCGWeekdaysE, $GUI_DISABLE)

		For $i = 0 To 23
			GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_DISABLE)
		Next
		GUICtrlSetState($g_ahChkAttackCGHoursE1, $GUI_DISABLE)
		GUICtrlSetState($g_ahChkAttackCGHoursE2, $GUI_DISABLE)
	Else
		$g_bAttackCGPlannerRandomEnable = False
		For $i = $g_hCmbAttackCGPlannerRandomTime to $g_hCmbAttackCGPlannerRandomProba
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		If GUICtrlRead($g_hChkAttackCGPlannerDayLimit) = $GUI_CHECKED Then
			GUICtrlSetState($g_hTxtCGRandomLog, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hTxtCGRandomLog, $GUI_DISABLE)
		EndIf
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackCGWeekdays[$i], $GUI_ENABLE)
		Next
		GUICtrlSetState($g_ahChkAttackCGWeekdaysE, $GUI_ENABLE)

		For $i = 0 To 23
			GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_ENABLE)
		Next
		GUICtrlSetState($g_ahChkAttackCGHoursE1, $GUI_ENABLE)
		GUICtrlSetState($g_ahChkAttackCGHoursE2, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkAttackCGPlannerRandom

Func cmbAttackCGPlannerRandom()
	$g_iAttackCGPlannerRandomTime = Int(_GUICtrlComboBox_GetCurSel($g_hCmbAttackCGPlannerRandomTime))
	GUICtrlSetData($g_hLbAttackCGPlannerRandom, $g_iAttackCGPlannerRandomTime > 0 ? GetTranslatedFileIni("MBR Global GUI Design", "hrs", "hrs") : GetTranslatedFileIni("MBR Global GUI Design", "hrs", "hr"))
EndFunc   ;==>cmbAttackCGPlannerRandom

Func chkAttackCGPlannerDayLimit()
	If GUICtrlRead($g_hChkAttackCGPlannerDayLimit) = $GUI_CHECKED Then
		$g_bAttackCGPlannerDayLimit = True
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerDayLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMax, $GUI_ENABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerThen, $GUI_ENABLE)
		GUICtrlSetState($hCGPlannerThenContinue, $GUI_ENABLE)
		GUICtrlSetState($hCGPlannerThenStopBot, $GUI_ENABLE)
		If $iRandomAttackCGCountToday = 0 Then
			GUICtrlSetData($MaxDailyLimit, "0")
			GUICtrlSetData($ActualNbrsAttacks, "0")
		EndIf
		For $i = $TitleDailyLimit To $MaxDailyLimit
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		GUICtrlSetState($g_hTxtCGRandomLog, $GUI_ENABLE)
	Else
		$g_bAttackCGPlannerDayLimit = False
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerDayLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbAttackCGPlannerDayMax, $GUI_DISABLE)
		GUICtrlSetState($g_hLbAttackCGPlannerThen, $GUI_DISABLE)
		GUICtrlSetState($hCGPlannerThenContinue, $GUI_DISABLE)
		GUICtrlSetState($hCGPlannerThenStopBot, $GUI_DISABLE)
		GUICtrlSetData($MaxDailyLimit, "X")
		GUICtrlSetData($ActualNbrsAttacks, "X")
		For $i = $TitleDailyLimit To $MaxDailyLimit
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		If GUICtrlRead($g_hChkAttackCGPlannerRandom) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtCGRandomLog, $GUI_ENABLE)
		Else
		GUICtrlSetState($g_hTxtCGRandomLog, $GUI_DISABLE)
		EndIf
	EndIf
	_cmbAttackCGPlannerDayLimit()
EndFunc   ;==>chkAttackCGPlannerDayLimit

Func cmbAttackCGPlannerDayMin()
	If Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax)) < Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin)) Then
		GUICtrlSetData($g_hCmbAttackCGPlannerDayMin, GUICtrlRead($g_hCmbAttackCGPlannerDayMax))
	EndIf
	$g_iAttackCGPlannerDayMin = Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin))
	_cmbAttackCGPlannerDayLimit()
EndFunc   ;==>cmbAttackCGPlannerDayMin

Func cmbAttackCGPlannerDayMax()
	If Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax)) < Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin)) Then
		GUICtrlSetData($g_hCmbAttackCGPlannerDayMax, GUICtrlRead($g_hCmbAttackCGPlannerDayMin))
	EndIf
	$g_iAttackCGPlannerDayMax = Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax))
	_cmbAttackCGPlannerDayLimit()
EndFunc   ;==>cmbAttackCGPlannerDayMax

Func LiveDailyCount()
If $g_bAttackCGPlannerEnable And $g_bAttackCGPlannerDayLimit And $iRandomAttackCGCountToday > 0 Then
	GUICtrlSetData($MaxDailyLimit, $iRandomAttackCGCountToday)
	GUICtrlSetData($ActualNbrsAttacks, $g_aiAttackedCGCount)
EndIf
EndFunc

Func _cmbAttackCGPlannerDayLimit()
	Switch Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMin))
		Case 0 To 8
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMin, $COLOR_MONEYGREEN)
		Case 9 To 12
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMin, $COLOR_YELLOW)
		Case 13 To 999
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMin, $COLOR_RED)
	EndSwitch
	Switch Int(GUICtrlRead($g_hCmbAttackCGPlannerDayMax))
		Case 0 To 8
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMax, $COLOR_MONEYGREEN)
		Case 9 To 12
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMax, $COLOR_YELLOW)
		Case 13 To 999
			GUICtrlSetBkColor($g_hCmbAttackCGPlannerDayMax, $COLOR_RED)
	EndSwitch
EndFunc   ;==>_cmbAttackCGPlannerDayLimit

Func chkAttackCGHoursE1()
	If GUICtrlRead($g_ahChkAttackCGHoursE1) = $GUI_CHECKED And IschkAttackCGHoursE1() Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_CHECKED)
		Next
	EndIf
	If _Sleep(300) Then Return
	GUICtrlSetState($g_ahChkAttackCGHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkAttackCGHoursE1

Func IschkAttackCGHoursE1()
	For $i = 0 To 11
		If GUICtrlRead($g_ahChkAttackCGHours[$i]) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkAttackCGHoursE1

Func chkAttackCGHoursE2()
	If GUICtrlRead($g_ahChkAttackCGHoursE2) = $GUI_CHECKED And IschkAttackCGHoursE2() Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkAttackCGHours[$i], $GUI_CHECKED)
		Next
	EndIf
	If _Sleep(300) Then Return
	GUICtrlSetState($g_ahChkAttackCGHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkAttackCGHoursE2

Func IschkAttackCGHoursE2()
	For $i = 12 To 23
		If GUICtrlRead($g_ahChkAttackCGHours[$i]) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkAttackCGHoursE2

Func chkAttackCGWeekDaysE()
	If GUICtrlRead($g_ahChkAttackCGWeekdaysE) = $GUI_CHECKED And IschkAttackCGWeekdays() Then
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackCGWeekdays[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 6
			GUICtrlSetState($g_ahChkAttackCGWeekdays[$i], $GUI_CHECKED)
		Next
	EndIf
	If _Sleep(300) Then Return
	GUICtrlSetState($g_ahChkAttackCGWeekdaysE, $GUI_UNCHECKED)
EndFunc   ;==>chkAttackCGWeekDaysE

Func IschkAttackCGWeekdays()
	For $i = 0 To 6
		If GUICtrlRead($g_ahChkAttackCGWeekdays[$i]) = $GUI_CHECKED Then Return True
	Next
	Return False
EndFunc   ;==>IschkAttackCGWeekdays

Func SwitchBetweenBasesMod2()
If Not $g_bFirstStartAccountSBB2 Then
	$CCBaseCheckTimer = 0
	$DelayReturnedtocheckCCBaseMS = 0
	$g_bFirstStartAccountSBB2 = 1
EndIf

	Local $aForgeType[5] = [$g_bChkEnableForgeGold, $g_bChkEnableForgeElix, $g_bChkEnableForgeDE, $g_bChkEnableForgeBBGold, $g_bChkEnableForgeBBElix]
	Local $bForgeEnabled = False
	For $i In $aForgeType ;check for every option enabled
		If $i = True Then 
			$bForgeEnabled = True
			ExitLoop
		EndIf
	Next
	If Not $bForgeEnabled And Not $g_bChkEnableAutoUpgradeCC Then Return False
	
	$g_iCmbPriorityCCBaseFrequency = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityCCBaseFrequency) * 60 * 60 * 1000
	$g_icmbAdvancedVariationCC = _GUICtrlComboBox_GetCurSel($g_hcmbAdvancedVariationCC) / 10

	If $g_iCmbPriorityCCBaseFrequency = 0 Then ; Case Everytime, Return True and End fonction Without Timing
		Return True
	EndIf
	
	If Not $CCBaseCheckTimer Then; First Time
	
		$CCBaseCheckTimer = TimerInit()
		
		Local $DelayReturnedtocheckCCBaseInf = ($g_iCmbPriorityCCBaseFrequency - ($g_iCmbPriorityCCBaseFrequency * $g_icmbAdvancedVariationCC))
		Local $DelayReturnedtocheckCCBaseSup = ($g_iCmbPriorityCCBaseFrequency + ($g_iCmbPriorityCCBaseFrequency * $g_icmbAdvancedVariationCC))
		$DelayReturnedtocheckCCBaseMS = Random($DelayReturnedtocheckCCBaseInf, $DelayReturnedtocheckCCBaseSup, 1)
		
		Local $iWaitTime = $DelayReturnedtocheckCCBaseMS
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iWaitSec
	
			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		If $IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge Then
			SetLog("Time To Check Clan Capital Stuff, CC Gold Just Collected", $COLOR_OLIVE)
		Else
			SetLog("Time To Check Clan Capital Stuff", $COLOR_OLIVE)
		EndIf
		SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
		Return True
	EndIf

	Local $CCBaseCheckTimerDiff = TimerDiff($CCBaseCheckTimer)
	
	If $CCBaseCheckTimer > 0 And $CCBaseCheckTimerDiff < $DelayReturnedtocheckCCBaseMS And Not ($IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge) Then ;Delay not reached And no CCGold : Return False
	
		Local $iWaitTime = ($DelayReturnedtocheckCCBaseMS - $CCBaseCheckTimerDiff)
		Local $sWaitTime = ""
		Local $iMin, $iHour, $iWaitSec
	
			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			If $iWaitSec <= 60 Then $sWaitTime = "Imminent"
		
			SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
		Return False
	EndIf
	
	If ($CCBaseCheckTimer > 0 And $CCBaseCheckTimerDiff > $DelayReturnedtocheckCCBaseMS) Or $IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge Then ;Delay reached or CCgold: reset chrono ans set new delay. Return True

			$CCBaseCheckTimer = TimerInit()
			
			Local $DelayReturnedtocheckCCBaseInf = ($g_iCmbPriorityCCBaseFrequency - ($g_iCmbPriorityCCBaseFrequency * $g_icmbAdvancedVariationCC))
			Local $DelayReturnedtocheckCCBaseSup = ($g_iCmbPriorityCCBaseFrequency + ($g_iCmbPriorityCCBaseFrequency * $g_icmbAdvancedVariationCC))
			$DelayReturnedtocheckCCBaseMS = Random($DelayReturnedtocheckCCBaseInf, $DelayReturnedtocheckCCBaseSup, 1)
	
			Local $iWaitTime = $DelayReturnedtocheckCCBaseMS
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec
	
				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		
			If $IsCCGoldJustCollected Or $IsCCGoldJustCollectedDChallenge Then
				SetLog("Time To Check Clan Capital Stuff, CC Gold Just Collected", $COLOR_OLIVE)
			Else
				SetLog("Time To Check Clan Capital Stuff", $COLOR_OLIVE)
			EndIf
			SetLog("Next Check For Clan Capital Stuff : " & $sWaitTime & "", $COLOR_OLIVE)
		Return True
	EndIf
EndFunc

Func CCBaseFrequencyDatas()
	If _GUICtrlComboBox_GetCurSel($g_hCmbPriorityCCBaseFrequency) = 0 Then
		GUICtrlSetState($g_hcmbAdvancedVariationCC, $GUI_DISABLE)
	Else
		GUICtrlSetState($g_hcmbAdvancedVariationCC, $GUI_ENABLE)
	EndIf
EndFunc

Func ChkEnableForgeGold()
	If GUICtrlRead($g_hChkEnableForgeGold) = $GUI_CHECKED Then
		$g_bChkEnableForgeGold = True
		For $i = $g_hLbacmdGoldSaveMin To $g_acmdGoldSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else	
		$g_bChkEnableForgeGold = False
		For $i = $g_hLbacmdGoldSaveMin To $g_acmdGoldSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeGold

Func ChkEnableForgeElix()
	If GUICtrlRead($g_hChkEnableForgeElix) = $GUI_CHECKED Then
		$g_bChkEnableForgeElix = True
		For $i = $g_hLbacmdElixSaveMin To $g_acmdElixSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else	
		$g_bChkEnableForgeElix = False
		For $i = $g_hLbacmdElixSaveMin To $g_acmdElixSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeElix

Func ChkEnableForgeDE()
	If GUICtrlRead($g_hChkEnableForgeDE) = $GUI_CHECKED Then
		$g_bChkEnableForgeDE = True
		For $i = $g_hLbacmdDarkSaveMin To $g_acmdDarkSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else	
		$g_bChkEnableForgeDE = False
		For $i = $g_hLbacmdDarkSaveMin To $g_acmdDarkSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeDE

Func ChkEnableForgeBBGold()
	If GUICtrlRead($g_hChkEnableForgeBBGold) = $GUI_CHECKED Then
		$g_bChkEnableForgeBBGold = True
		For $i = $g_hLbacmdBBGoldSaveMin To $g_acmdBBGoldSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else	
		$g_bChkEnableForgeBBGold = False
		For $i = $g_hLbacmdBBGoldSaveMin To $g_acmdBBGoldSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeBBGold

Func ChkEnableForgeBBElix()
	If GUICtrlRead($g_hChkEnableForgeBBElix) = $GUI_CHECKED Then
		$g_bChkEnableForgeBBElix = True
		For $i = $g_hLbacmdBBElixSaveMin To $g_acmdBBElixSaveMin
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else	
		$g_bChkEnableForgeBBElix = False
		For $i = $g_hLbacmdBBElixSaveMin To $g_acmdBBElixSaveMin
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkEnableForgeBBElix

Func cmdGoldSaveMin()
	If Int(GUICtrlRead($g_acmdGoldSaveMin)) < 150000 Then
		GUICtrlSetData($g_acmdGoldSaveMin, 150000)
	ElseIf Int(GUICtrlRead($g_acmdGoldSaveMin)) > 22000000 Then
		GUICtrlSetData($g_acmdGoldSaveMin, 22000000)
	EndIf
EndFunc   ;==>cmdGoldSaveMin

Func cmdElixSaveMin()
	If Int(GUICtrlRead($g_acmdElixSaveMin)) < 1000 Then
		GUICtrlSetData($g_acmdElixSaveMin, 1000)
	ElseIf Int(GUICtrlRead($g_acmdElixSaveMin)) > 22000000 Then
		GUICtrlSetData($g_acmdElixSaveMin, 22000000)
	EndIf
EndFunc   ;==>cmdElixSaveMin

Func cmdDarkSaveMin()
	If Int(GUICtrlRead($g_acmdDarkSaveMin)) < 1000 Then
		GUICtrlSetData($g_acmdDarkSaveMin, 1000)
	ElseIf Int(GUICtrlRead($g_acmdDarkSaveMin)) > 370000 Then
		GUICtrlSetData($g_acmdDarkSaveMin, 370000)
	EndIf
EndFunc   ;==>cmdDarkSaveMin

Func cmdBBGoldSaveMin()
	If Int(GUICtrlRead($g_acmdBBGoldSaveMin)) < 1000 Then
		GUICtrlSetData($g_acmdBBGoldSaveMin, 1000)
	ElseIf Int(GUICtrlRead($g_acmdBBGoldSaveMin)) > 5000000 Then
		GUICtrlSetData($g_acmdBBGoldSaveMin, 5000000)
	EndIf
EndFunc   ;==>cmdBBGoldSaveMin

Func cmdBBElixSaveMin()
	If Int(GUICtrlRead($g_acmdBBElixSaveMin)) < 1000 Then
		GUICtrlSetData($g_acmdBBElixSaveMin, 1000)
	ElseIf Int(GUICtrlRead($g_acmdBBElixSaveMin)) > 5000000 Then
		GUICtrlSetData($g_acmdBBElixSaveMin, 5000000)
	EndIf
EndFunc   ;==>cmdBBElixSaveMin

Func CmbForgeBuilder()
	$g_iCmbForgeBuilder = Int(_GUICtrlComboBox_GetCurSel($g_hCmbForgeBuilder))
	GUICtrlSetData($g_hLbCmbForgeBuilder, $g_iCmbForgeBuilder > 0 ? GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builders for Forge") : _
	GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builder for Forge"))
EndFunc   ;==>CmbForgeBuilder

Func EnableAutoUpgradeCC()
If GUICtrlRead($g_hChkEnableAutoUpgradeCC) = $GUI_CHECKED Then
	GUICtrlSetState($g_hChkStartWeekendRaid, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnCCUpgradesSettingsOpen, $GUI_ENABLE)
	GUICtrlSetState($g_hChkEnableSmartSwitchCC, $GUI_ENABLE)
	GUICtrlSetState($g_acmbPriorityChkRaid, $GUI_ENABLE)
Else
	GUICtrlSetState($g_hChkStartWeekendRaid, $GUI_DISABLE)
	GUICtrlSetState($g_hBtnCCUpgradesSettingsOpen, $GUI_DISABLE)
	GUICtrlSetState($g_hChkEnableSmartSwitchCC, $GUI_DISABLE)
	GUICtrlSetState($g_acmbPriorityChkRaid, $GUI_DISABLE)
EndIf
EndFunc

Func ViewBattleLog()
	If _GUICtrlComboBox_GetCurSel($g_acmbPriorityBB[0]) = 0 Then
		For $i = $g_hLabelBB2 To $g_acmbPause[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		For $i = $g_hLabelBB2 To $g_acmbPause[2]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		WatchBBBattles()
	EndIf
	If GUICtrlRead($g_hChkUseBotHumanization) = $GUI_UNCHECKED Then
		For $i = $g_hLabelBB2 To $g_acmbPause[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc

Func WatchBBBattles()
	If _GUICtrlComboBox_GetCurSel($g_acmbPriorityBB[1]) = 0 Then
		For $i = $g_hLabelBB3 To $g_acmbPause[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		For $i = $g_hLabelBB3 To $g_acmbPause[2]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	EndIf
EndFunc

Func CheckDonateOften()
If Not $g_bCheckDonateOften Or Not $g_bChkDonate Then Return

If _ColorCheck(_GetPixelColor(32, 354, True), "BF0718", 20) Then
	SetLog("Check Donate Often", $COLOR_DEBUG1)
	checkArmyCamp(True, True)
		
	; if in "Halt/Donate" don't skip near full army
	If (Not SkipDonateNearFullTroops(True) Or $g_iCommandStop = 3 Or $g_iCommandStop = 0) And BalanceDonRec(True) Then DonateCC()
	Local $IsAnythingDonated = False
	If $IsTroopDonated Or $IsSpellDonated Or $IsSiegeDonated Then $IsAnythingDonated = True

	If Not _Sleep($DELAYRUNBOT1) Then checkMainScreen(False)
	If $g_bTrainEnabled And $IsAnythingDonated Then ; check for training enabled in halt mode
		If $g_iActualTrainSkip < $g_iMaxTrainSkip Then
			IschkAddRandomClickTimingDelay2()
			IschkAddRandomClickTimingDelay1()
			TrainSystem()
			_Sleep($DELAYRUNBOT1)
		Else
			SetLog("Humanize bot, prevent to delete and recreate troops " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_blue)
			$g_iActualTrainSkip = $g_iActualTrainSkip + 1
			If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
				$g_iActualTrainSkip = 0
			EndIf
			CheckOverviewFullArmy(True, False) ; use true parameter to open train overview window
			If _Sleep($DELAYRESPOND) Then Return
			getArmySpells()
			If _Sleep($DELAYRESPOND) Then Return
			getArmyHeroCount(False, True)
		EndIf
	Else
		If $g_bDebugSetlogTrain Then SetLog("Halt mode - training disabled", $COLOR_DEBUG)
	EndIf
	$IsTroopDonated = False
	$IsSpellDonated = False
	$IsSiegeDonated = False
EndIf
EndFunc

Func StarBonusSearch()
	Local $bRet = False
	For $i = 1 to 10
		If WaitforPixel(84, 570 + $g_iBottomOffsetY, 97, 575 + $g_iBottomOffsetY, "AF5725", 20, 0.2) Then
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(400) Then Return
		If Not $g_bRunState Then Return
	Next
	Return $bRet
EndFunc

Func IsBBDailyChallengeAvailable()

	If Not $g_bChkBBAttackForDailyChallenge Or Not $g_bChkEnableBBAttack Then Return True
	
	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec
	
	
	If _DateIsValid($g_sNewChallengeTime) Then
		$TimeDiffBBChallenge = _DateDiff("n", _NowCalc(), $g_sNewChallengeTime)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffBBChallenge > 0 Then
		
			$iWaitTime = $TimeDiffBBChallenge * 60 * 1000
			$sWaitTime = ""
				
			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		
			SetLog("Daily BB Challenge Unavailable", $COLOR_DEBUG1)
			SetLog("New Challenge in " & $sWaitTime, $COLOR_ACTION)
			SetLog("Check Builder Base Later", $COLOR_NAVY)
			Return False
		EndIf
	EndIf
	
	ClickAway()
	If _Sleep($DELAYRUNBOT1) Then Return

	Local $bRet = False
	For $i = 0 To 9
		If _CheckPixel($aPersonalChallengeOpenButton1, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton1, 1, 0, "#0666")
			$bRet = True
			ExitLoop
		ElseIf _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton2, 1, 0, "#0666")
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(200) Then Return		
	Next	
	If $bRet = False Then
		SetLog("Can't find button", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf

	Local $counter = 0
	While Not _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) ; test for Personal Challenge Close Button
		SetDebugLog("Wait for Personal Challenge Close Button to appear #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then Return
		$counter += 1
		If $counter > 40 Then Return False
	WEnd
	
	If _Sleep(5000) Then Return
	
	If QuickMIS("BC1", $g_sImgBBDailyAvail, 65, 320 + $g_iMidOffsetY, 105, 345 + $g_iMidOffsetY) Then
		SetLog("Check Builder Base Now, Daily Challenge Available", $COLOR_SUCCESS1)
		$g_IsBBDailyChallengeAvailable = True
		CloseWindow()
		Return True
	Else
		SetLog("Daily BB Challenge Unavailable", $COLOR_DEBUG1)
		Local $Result = getOcrAndCapture("coc-uptime", 65, 570 + $g_iBottomOffsetY, 80, 18, True)
		Local $iBBDailyNewChalTime = ConvertOCRTime("Challenge Time", $Result, False)
		
		SetDebugLog("New Challenge OCR Time = " & $Result & ", $iBBDailyNewChalTime = " & $iBBDailyNewChalTime & " m", $COLOR_INFO)
		Local $StartTime = _NowCalc() ; what is date:time now
		If $iBBDailyNewChalTime > 0 Then
			$g_sNewChallengeTime = _DateAdd('n', Ceiling($iBBDailyNewChalTime), $StartTime)
			SetLog("New Challenge @ " & $g_sNewChallengeTime, $COLOR_DEBUG1)
			$TimeDiffBBChallenge = _DateDiff("n", _NowCalc(), $g_sNewChallengeTime) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffBBChallenge > 0 Then
			
				$iWaitTime = $TimeDiffBBChallenge * 60 * 1000
				$sWaitTime = ""
					
				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		
				SetLog("New Challenge in " & $sWaitTime, $COLOR_ACTION)
				SetLog("Check Builder Base Later", $COLOR_NAVY)
				
				$g_IsBBDailyChallengeAvailable = False
				CloseWindow()
				Return False
			EndIf
		Else
			SetLog("Error processing New Challenge time required, try again!", $COLOR_WARNING)
			CloseWindow()
			Return False
		EndIf
	EndIf

EndFunc

Func IsBBDailyChallengeStillAvailable()

	If Not $g_bChkBBAttackForDailyChallenge Then Return True
	
	ClickAway("Right")
	If _Sleep($DELAYRUNBOT1) Then Return
	Local $bRet = False
	For $i = 0 To 9
		If _CheckPixel($aPersonalChallengeOpenButton1, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton1, 1, 0, "#0666")
			$bRet = True
			ExitLoop
		ElseIf _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
			ClickP($aPersonalChallengeOpenButton2, 1, 0, "#0666")
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(200) Then Return		
	Next	
	If $bRet = False Then
		SetLog("Can't find button", $COLOR_ERROR)
		ClickAway()
		Return False
	EndIf

	Local $counter = 0
	While Not _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) ; test for Personal Challenge Close Button
		SetDebugLog("Wait for Personal Challenge Close Button to appear #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then Return
		$counter += 1
		If $counter > 40 Then Return False
	WEnd
	
	If _Sleep(5000) Then Return
	
	If QuickMIS("BC1", $g_sImgBBDailyAvail, 65, 320 + $g_iMidOffsetY, 105, 345 + $g_iMidOffsetY) Then
		SetLog("Builder Base Daily Challenge Available", $COLOR_SUCCESS1)
		$g_IsBBDailyChallengeAvailable = True
		CloseWindow()
		Return True
	Else
		SetLog("Builder Base Daily Challenge Unavailable", $COLOR_DEBUG1)
		$g_IsBBDailyChallengeAvailable = False
		CloseWindow()
		Return False
	EndIf

EndFunc

Func ForumAccept()

	If Not $g_bForumRequestOnly Then Return
	
	SetLog("Checking Requests From Forum", $COLOR_ACTION)
	
	Local $Scroll, $bRet, $Accepted = 0
	Local $aForumWrite[2] = ["Forum", "forum"]
	
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If Not $g_bRunState Then Return
	If _Sleep(1500) Then Return
	
	While 1
		ForceCaptureRegion()
		$Scroll = _PixelSearch(294, 83, 296, 93, Hex(0xFFFFFF, 6), 20)
		If IsArray($Scroll) And _ColorCheck(_GetPixelColor(300, 85, True), Hex(0x95CD0E, 6), 20) Then
			ClickP($Scroll)
			If _Sleep(350) Then ExitLoop
			ContinueLoop
		EndIf
		ExitLoop
	WEnd

	While 1
		Local $aTmpCoord = QuickMIS("CNX", $g_sImgACCEPT, 10, 115, 270, 615 + $g_iBottomOffsetY)
		If _Sleep(1000) Then ExitLoop
		_ArraySort($aTmpCoord, 0, 0, 0, 2)
		If IsArray($aTmpCoord) And UBound($aTmpCoord) > 0 Then
			$bRet = False
			Local $Result = getOcrAndCapture("coc-latinA", $aTmpCoord[0][1] - 190, $aTmpCoord[0][2] - 56, 160, 20)
			If _Sleep(500) Then ExitLoop
			For $y In $aForumWrite
				If StringInStr($Result, $y) Then
					SetLog("Forum Request Detected", $COLOR_FUCHSIA)
					$bRet = True
					ExitLoop
				EndIf
			Next
			If Not $g_bRunState Then ExitLoop
			If $bRet Then
				SetLog("Click Accept", $COLOR_SUCCESS1)
				Click($aTmpCoord[0][1], $aTmpCoord[0][2] + 5)
				$Accepted += 1
				$ActionForModLog = "Accept Forum Request"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog & "", 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog & "")
				If _Sleep(2000) Then ExitLoop
				ContinueLoop
			Else
				ForceCaptureRegion()
				$Scroll = _PixelSearch(294, 593 + $g_iBottomOffsetY, 296, 603 + $g_iBottomOffsetY, Hex(0xFFFFFF, 6), 20)
				If IsArray($Scroll) Then
					Click($Scroll[0], $Scroll[1])
					If _Sleep(250) Then ExitLoop
					ContinueLoop
				EndIf
				ExitLoop
			EndIf
		EndIf
		ExitLoop
	WEnd
	
	If $Accepted > 0 Then
		If $g_bUseWelcomeMessage And $g_aWelcomeMessage <> "" Then
			SetLog("Sending Welcome Message", $COLOR_ACTION)
			If Not SelectChatInput() Then Return False
			If Not ChatTextInput($g_aWelcomeMessage) Then Return False
			If Not SendTextChat() Then Return False
		EndIf
	EndIf
	
	If Not ClickB("ChatDown") Then
		SetDebugLog("No Chat Down Button", $COLOR_DEBUG)
	EndIf
	
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	
	If Not $g_bRunState Then Return

EndFunc

Func SelectChatInput() ; select the textbox for Global chat or Clan Chat

	Click($aChatSelectTextBox[0], $aChatSelectTextBox[1] + 5, 1, 0, "SelectTextBoxBtn")
	If _Sleep(2000) Then Return
	
	If _WaitForCheckPixel($aOpenedChatSelectTextBox, $g_bCapturePixel, Default, "Wait for Chat Select Text Box:") Then
		SetDebugLog("Chat TextBox Appeared.", $COLOR_INFO)
		Return True
	Else
		SetDebugLog("Not find $aOpenedChatSelectTextBox | Pixel was:" & _GetPixelColor($aOpenedChatSelectTextBox[0], $aOpenedChatSelectTextBox[1], True), $COLOR_ERROR)
		Return False
	EndIf
	
EndFunc   ;==>SelectChatInput

Func ChatTextInput($g_sMessage)

	Click($aOpenedChatSelectTextBox[0], $aOpenedChatSelectTextBox[1] + 5, 1, 0, "ChatInput")
	If _Sleep(1500) Then Return

	SendText($g_sMessage)
	If _Sleep(1000) Then Return
	Return True
	
EndFunc   ;==>ChatTextInput

Func SendTextChat() ; click send for clan chat

	If _CheckPixel($aChatSendBtn, $g_bCapturePixel, Default, "Chat Send Btn:") Then
		Click($aChatSendBtn[0], $aChatSendBtn[1] + 12, 1, 0, "ChatSendBtn") ; send
		If _Sleep(1500) Then Return
		Return True
	Else
		SetDebugLog("Not find $aChatSendBtn | Pixel was:" & _GetPixelColor($aChatSendBtn[0], $aChatSendBtn[1], True), $COLOR_ERROR)
		Return False
	EndIf
	
EndFunc   ;==>SendTextChat

Func chkUseWelcomeMessage()
	If GUICtrlRead($g_hChkUseWelcomeMessage) = $GUI_CHECKED Then
		$g_bUseWelcomeMessage = True
		GUICtrlSetState($g_hTxtWelcomeMessage, $GUI_ENABLE)
	Else
		$g_bUseWelcomeMessage = False
		GUICtrlSetState($g_hTxtWelcomeMessage, $GUI_DISABLE)
	EndIf
EndFunc

Func BtnWelcomeMessage()
	GUISetState(@SW_SHOW, $g_hGUI_WelcomeMessage)
EndFunc

Func CloseWelcomeMessage()
	GUISetState(@SW_HIDE, $g_hGUI_WelcomeMessage)
EndFunc

Func BtnSecondaryVillages()
	GUISetState(@SW_SHOW, $g_hGUI_SecondaryVillages)
EndFunc

Func CloseSecondaryVillages()
	GUISetState(@SW_HIDE, $g_hGUI_SecondaryVillages)
EndFunc