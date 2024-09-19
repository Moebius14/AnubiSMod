; #FUNCTION# ====================================================================================================================
; Name ..........: MagicSnacks.au3
; Description ...: This file controls the Magic Snacks Use
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Moebius14 (09/2024)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MagicSnacks()

	If Not $g_bChkUseSnacks Then Return False

	Local $aSnacksButton = findButton("Snacks", Default, 1, True)
	If Not IsArray($aSnacksButton) Or UBound($aSnacksButton, 1) < 2 Then Return False

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	If $StarBonusReceived[2] = 0 And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Magic Snacks LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
		Local $iDelayToCheck = Random(120, 240, 1)
		If $iLastCheck <= $iDelayToCheck Then Return
	EndIf

	;Laboratory Upgrade
	Local $IsAnyLabUpgrade = False
	If _DateIsValid($g_sLabUpgradeTime) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime) ; Minutes
		If $iLabTime > 3 * 60 Then $IsAnyLabUpgrade = True ; 3 Hours
	EndIf

	;Building Upgrades in Progress (More than 2 builders at work)
	Local $IsAnyBuildingUpgrade = False
	If AllowBoostingBuildersForSnacks() Then $IsAnyBuildingUpgrade = True

	If ClickB("Snacks") Then
		SetLog("Check Magic Snacks", $COLOR_SUCCESS)
		$iLastTimeChecked[$g_iCurAccount] = _NowCalc()
		If $StarBonusReceived[2] = 1 Then $StarBonusReceived[2] = 0
		If _Sleep(1000) Then Return

		Local $aMagicSnacks[0][4]
		Local $aMagicSnacksTemp = QuickMIS("CNX", $g_sImgMagicSnacks, 200, 560 + $g_iBottomOffsetY, 620, 630 + $g_iBottomOffsetY) ; 0 : Name, 1 : X Coord, 2 : Y Coord, 3 : Empty
		If IsArray($aMagicSnacksTemp) And UBound($aMagicSnacksTemp) > 0 And UBound($aMagicSnacksTemp, $UBOUND_COLUMNS) > 1 Then
			For $i = 0 To UBound($aMagicSnacksTemp) - 1
				$aMagicSnacksTemp[$i][1] = Number($aMagicSnacksTemp[$i][1])
				$aMagicSnacksTemp[$i][2] = Number($aMagicSnacksTemp[$i][2])
			Next
			_ArraySort($aMagicSnacksTemp, 1, 0, 0, 1) ; X Coord from right to left
			For $i = 0 To UBound($aMagicSnacksTemp) - 1
				Switch $aMagicSnacksTemp[$i][1]
					Case 206 To 300
						Local $aiToUse = decodeSingleCoord(FindImageInPlace2("ToUse", $g_sImgMagicSnacksToUse, 206, 555 + $g_iBottomOffsetY, 258, 580 + $g_iBottomOffsetY, True))
					Case 312 To 406
						Local $aiToUse = decodeSingleCoord(FindImageInPlace2("ToUse", $g_sImgMagicSnacksToUse, 312, 555 + $g_iBottomOffsetY, 364, 580 + $g_iBottomOffsetY, True))
					Case 418 To 512
						Local $aiToUse = decodeSingleCoord(FindImageInPlace2("ToUse", $g_sImgMagicSnacksToUse, 418, 555 + $g_iBottomOffsetY, 470, 580 + $g_iBottomOffsetY, True))
					Case 524 To 618
						Local $aiToUse = decodeSingleCoord(FindImageInPlace2("ToUse", $g_sImgMagicSnacksToUse, 524, 555 + $g_iBottomOffsetY, 576, 580 + $g_iBottomOffsetY, True))
				EndSwitch
				If IsArray($aiToUse) And UBound($aiToUse) = 2 Then
					_ArrayAdd($aMagicSnacks, $aMagicSnacksTemp[$i][0] & "|" & $aMagicSnacksTemp[$i][1] & "|" & $aMagicSnacksTemp[$i][2] & "| Yes")
				Else
					_ArrayAdd($aMagicSnacks, $aMagicSnacksTemp[$i][0] & "|" & $aMagicSnacksTemp[$i][1] & "|" & $aMagicSnacksTemp[$i][2] & "| No")
				EndIf
			Next
			;;; To Be Sure ;;;;;
			For $i = 0 To UBound($aMagicSnacks) - 1
				$aMagicSnacks[$i][1] = Number($aMagicSnacks[$i][1])
				$aMagicSnacks[$i][2] = Number($aMagicSnacks[$i][2])
			Next
			_ArraySort($aMagicSnacks, 1, 0, 0, 1) ; 0 : Name, 1 : X Coord from right to left, 2 : Y Coord, 3 : IsToUse
			;;;;;;;;;;;;;;;;;;;;

			For $i = 0 To UBound($aMagicSnacks) - 1
				If StringInStr($aMagicSnacks[$i][3], "No", $STR_NOCASESENSEBASIC) Then
					SetLog("Snack " & $aMagicSnacks[$i][0] & " can't be used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
					If _Sleep(1000) Then Return
				ElseIf StringInStr($aMagicSnacks[$i][3], "Yes", $STR_NOCASESENSEBASIC) Then
					If StringInStr($aMagicSnacks[$i][0], "Soup", $STR_NOCASESENSEBASIC) Then
						If $IsAnyLabUpgrade Then
							SetLog("Snack " & $aMagicSnacks[$i][0] & " can be used.", $COLOR_SUCCESS1)
							Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
							If _Sleep(1000) Then Return
							Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
							If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
								ClickB($aiUseButton)
								If _Sleep(1000) Then Return
								$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTimeMod - 180), _NowCalc())
								SetLog("Recalculate Research time, using Study Soup (" & $g_sLabUpgradeTime & ")")
								LabStatusGUIUpdate()
								$ActionForModLog = "Boosting Research"
								If $g_iTxtCurrentVillageName <> "" Then
									GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Laboratory : " & $ActionForModLog & " Using Study Soup", 1)
								Else
									GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Laboratory : " & $ActionForModLog & " Using Study Soup", 1)
								EndIf
								_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Laboratory : " & $ActionForModLog)
							Else
								SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
								CloseWindow2()
							EndIf
						Else
							SetLog("Snack " & $aMagicSnacks[$i][0] & " can't be used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
						EndIf
					ElseIf StringInStr($aMagicSnacks[$i][0], "Bite", $STR_NOCASESENSEBASIC) Then
						If $IsAnyBuildingUpgrade Then
							SetLog("Snack " & $aMagicSnacks[$i][0] & " can be used.", $COLOR_SUCCESS1)
							Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
							If _Sleep(1000) Then Return
							Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
							If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
								ClickB($aiUseButton)
								If _Sleep(1000) Then Return
								$ActionForModLog = "Boosting Builders"
								If $g_iTxtCurrentVillageName <> "" Then
									GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Builder Bite", 1)
								Else
									GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Builder Bite", 1)
								EndIf
								_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog)
							Else
								SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
								CloseWindow2()
							EndIf
						Else
							SetLog("Snack " & $aMagicSnacks[$i][0] & " can't be used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
						EndIf
					Else
						SetLog("Snack " & $aMagicSnacks[$i][0] & " can be used.", $COLOR_SUCCESS1)
						Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
						If _Sleep(1000) Then Return
						Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
						If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
							ClickB($aiUseButton)
							If _Sleep(1000) Then Return
							$ActionForModLog = $aMagicSnacks[$i][0]
							If $g_iTxtCurrentVillageName <> "" Then
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Using Magic Snack : " & $ActionForModLog, 1)
							Else
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Using Magic Snack : " & $ActionForModLog, 1)
							EndIf
							_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Using Magic Snack : " & $ActionForModLog)
						Else
							SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
							CloseWindow2()
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		If ClickB("Snacks") Then SetLog("Closing Magic Snacks", $COLOR_SUCCESS)
		Return True
	Else
		Return False
	EndIf

EndFunc   ;==>MagicSnacks

Func AllowBoostingBuildersForSnacks()
	If Not getBuilderCount() Then Return False
	If _Sleep($DELAYRESPOND) Then Return

	If $g_iTotalBuilderCount - $g_iFreeBuilderCount < 2 Then
		SetLog("Enough Upgrades in Progress", $COLOR_SUCCESS)
		Return True
	Else
		SetLog("Not Enough Upgrades in Progress", $COLOR_DEBUG)
		Return False
	EndIf
EndFunc   ;==>AllowBoostingBuildersForSnacks

