; #FUNCTION# ====================================================================================================================
; Name ..........: AppBuilder.au3
; Description ...: This file controls the Builder's Apprentice Assignment
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Moebius14 (06/2024)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AppBuilder()

	If Not $g_bChkAppBuilder Then Return

	If $g_iTownHallLevel < 10 Then
		Return
	EndIf

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec

	If _DateIsValid($g_sAvailableAppBuilder) Then
		$TimeDiffAppBuilder = _DateDiff("n", _NowCalc(), $g_sAvailableAppBuilder)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffAppBuilder > 0 Then

			$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			SetLog("Builder's Apprentice Unavailable", $COLOR_DEBUG1)
			SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)
			Return
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableAppBuilder) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then Return
		EndIf
	EndIf

	Local $bRet = False
	Local $bLocateTH = False
	BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

	If $BuildingInfo[1] <> "Town Hall" Then $bLocateTH = True
	If $bLocateTH Then
		SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClearScreen()
		If _Sleep(Random(1000, 1500, 1)) Then Return
		imglocTHSearch(False, True, True) ;Sets $g_iTownHallLevel
		If _Sleep(Random(1000, 1500, 1)) Then Return
		BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)
		If $BuildingInfo[1] <> "Town Hall" Then
			SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
			Return
		EndIf
	EndIf

	Local $BuildersApp = FindButton("BuildersApp")
	If IsArray($BuildersApp) And UBound($BuildersApp) = 2 Then
		Click($BuildersApp[0], 545 + $g_iBottomOffsetY)
		If _Sleep(Random(1500, 2000, 1)) Then Return
	Else
		ClearScreen()
		Return
	EndIf

	If Not QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 100, 845, 130 + $g_iMidOffsetY) Then
		SetLog("Builder's Apprentice Window Didn't Open", $COLOR_DEBUG1)
		CloseWindow2()
		ClearScreen()
		Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 160, 155 + $g_iMidOffsetY, 270, 195 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Builder's Apprentice is Locked", $COLOR_ERROR)
		CloseWindow()
		Return
	EndIf

	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	_ArraySort($GreenAssignButtons, 0, 0, 0, 2)

	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign for the longest time (Top)
			If _Sleep(Random(1500, 2000, 1)) Then Return
			ExitLoop
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = StringReplace(getOcrAndCapture("coc-BuildersApptime", 212, 167 + $g_iMidOffsetY, 75, 15, True), "b", "")
			SetLog("Job In Progress", $COLOR_SUCCESS)
		Else
			Local $Result = StringReplace(getOcrAndCapture("coc-BuildersApptime", 222, 167 + $g_iMidOffsetY, 75, 15, True), "b", "")
		EndIf
		Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iAppBuilderAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			SetLog("Buider's App Available @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
			$TimeDiffAppBuilder = _DateDiff("n", _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Builder's Apprentice Unavailable", $COLOR_DEBUG1)
				SetLog("Will Be Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		CloseWindow()
		Return
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 445 + $g_iMidOffsetY, 520, 520 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $CoordsX[2] = [390, 470]
		Local $CoordsY[2] = [465 + $g_iMidOffsetY, 500 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Builder's Apprentice Assigned", $COLOR_SUCCESS)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = StringReplace(getOcrAndCapture("coc-BuildersApptime", 212, 167 + $g_iMidOffsetY, 75, 15, True), "b", "")
			SetLog("Job In Progress", $COLOR_SUCCESS)
		Else
			Local $Result = StringReplace(getOcrAndCapture("coc-BuildersApptime", 222, 167 + $g_iMidOffsetY, 75, 15, True), "b", "")
		EndIf
		Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iAppBuilderAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			SetLog("Buider's App Available @ " & $g_sAvailableAppBuilder, $COLOR_DEBUG1)
			$TimeDiffAppBuilder = _DateDiff("n", _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				SetLog("Builder's Apprentice Available in " & $sWaitTime, $COLOR_ACTION)

			EndIf
		Else
			SetLog("Error processing New Challenge time required, try again!", $COLOR_WARNING)
		EndIf
	Else
		PureClickP($aAway, 1, 160, "#0133") ;Click away If things are open
		If _Sleep(1000) Then Return
	EndIf

	CloseWindow()
EndFunc   ;==>AppBuilder
