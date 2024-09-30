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

	If Not $g_bRunState Then Return

	Local $aSnacksButton = findButton("Snacks", Default, 1, True)
	If Not IsArray($aSnacksButton) Or UBound($aSnacksButton, 1) < 2 Then Return False

	Local Static $iLastTimeChecked[8]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	If $StarBonusReceived[2] = 0 And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Magic Snacks LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each from 2 to 3 hours [2*60 = 120 to 3*60 = 180]
		Local $iDelayToCheck = Random(120, 180, 1)
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
		Local $aMagicSnacksEmpty[0][4]
		Local $bRecheck = False, $bLoop = 0
		Local $aMagicSnacksTemp = QuickMIS("CNX", $g_sImgMagicSnacks, 300, 560 + $g_iBottomOffsetY, 620, 630 + $g_iBottomOffsetY) ; 0 : Name, 1 : X Coord, 2 : Y Coord, 3 : Empty
		If IsArray($aMagicSnacksTemp) And UBound($aMagicSnacksTemp) > 0 And UBound($aMagicSnacksTemp, $UBOUND_COLUMNS) > 1 Then
			Local $iSnacksCount = UBound($aMagicSnacksTemp)
			While 1
				If $bLoop >= UBound($aMagicSnacksTemp) Then ExitLoop
				SetDebugLog("Loop #" & $bLoop, $COLOR_DEBUG)
				$bLoop += 1
				If $bRecheck Then
					$aMagicSnacks = $aMagicSnacksEmpty ; Empty array
					SetLog("Item Position might change, Re-Check!", $COLOR_ACTION)
					$aMagicSnacksTemp = QuickMIS("CNX", $g_sImgMagicSnacks, 300, 560 + $g_iBottomOffsetY, 620, 630 + $g_iBottomOffsetY)
					$bRecheck = False
				EndIf
				For $i = 0 To UBound($aMagicSnacksTemp) - 1
					$aMagicSnacksTemp[$i][1] = Number($aMagicSnacksTemp[$i][1])
					$aMagicSnacksTemp[$i][2] = Number($aMagicSnacksTemp[$i][2])
				Next
				_ArraySort($aMagicSnacksTemp, 1, 0, 0, 1) ; X Coord from right to left
				For $i = 0 To UBound($aMagicSnacksTemp) - 1
					Switch $aMagicSnacksTemp[$i][1]
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
						Switch $aMagicSnacksTemp[$i][1]
							Case 312 To 406
								Local $aiIsFull = decodeSingleCoord(FindImageInPlace2("MagicSnackIsFull", $g_sImgMagicSnacksFull, 312, 555 + $g_iBottomOffsetY, 364, 580 + $g_iBottomOffsetY, True))
							Case 418 To 512
								Local $aiIsFull = decodeSingleCoord(FindImageInPlace2("MagicSnackIsFull", $g_sImgMagicSnacksFull, 418, 555 + $g_iBottomOffsetY, 470, 580 + $g_iBottomOffsetY, True))
							Case 524 To 618
								Local $aiIsFull = decodeSingleCoord(FindImageInPlace2("MagicSnackIsFull", $g_sImgMagicSnacksFull, 524, 555 + $g_iBottomOffsetY, 576, 580 + $g_iBottomOffsetY, True))
						EndSwitch
						If IsArray($aiIsFull) And UBound($aiIsFull) = 2 Then
							_ArrayAdd($aMagicSnacks, $aMagicSnacksTemp[$i][0] & "|" & $aMagicSnacksTemp[$i][1] & "|" & $aMagicSnacksTemp[$i][2] & "| Full")
						Else
							_ArrayAdd($aMagicSnacks, $aMagicSnacksTemp[$i][0] & "|" & $aMagicSnacksTemp[$i][1] & "|" & $aMagicSnacksTemp[$i][2] & "| No")
						EndIf
					EndIf
				Next
				;;; Array Rework ;;;;;
				For $i = 0 To UBound($aMagicSnacks) - 1
					$aMagicSnacks[$i][1] = Number($aMagicSnacks[$i][1])
					$aMagicSnacks[$i][2] = Number($aMagicSnacks[$i][2])
				Next
				_ArraySort($aMagicSnacks, 0, 0, 0, 1) ; 0 : Name, 1 : X Coord from left to right, 2 : Y Coord, 3 : IsToUse
				;;;;;;;;;;;;;;;;;;;;

				For $i = 0 To UBound($aMagicSnacks) - 1
					If StringInStr($aMagicSnacks[$i][3], "No", $STR_NOCASESENSEBASIC) Then
						SetLog(ConvertName($aMagicSnacks[$i][0]) & " already used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
						If StringInStr($aMagicSnacks[$i][0], "Castle", $STR_NOCASESENSEBASIC) Then
							If Not _DateIsValid($ClanCastleCakeTimer) Then
								Switch $aMagicSnacks[$i][1]
									Case 312 To 406
										Local $aiOCRXCord = 312
									Case 418 To 512
										Local $aiOCRXCord = 418
									Case 524 To 618
										Local $aiOCRXCord = 524
								EndSwitch
								Local $TimerReadOCR = getOcrAndCapture("coc-guardshield", $aiOCRXCord, 634 + $g_iBottomOffsetY, 82, 16)
								Local $TimerReadMinutes = ConvertOCRTime("CakeTime", $TimerReadOCR, False)
								If $TimerReadMinutes > 0 Then
									$ClanCastleCakeTimer = _DateAdd('n', Ceiling($TimerReadMinutes), _NowCalc())
									SetLog("Clan Castle Cake Will Finish @ " & $ClanCastleCakeTimer, $COLOR_DEBUG1)
								EndIf
							EndIf
						EndIf
						If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
						If _Sleep(1000) Then Return
					ElseIf StringInStr($aMagicSnacks[$i][3], "Full", $STR_NOCASESENSEBASIC) Then
						If StringInStr($aMagicSnacks[$i][0], "BuilderPotion", $STR_NOCASESENSEBASIC) Then
							If $IsAnyBuildingUpgrade Then
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " can be used, even full", $COLOR_SUCCESS1)
								If _Sleep(500) Then Return
								Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
								If _Sleep(1000) Then Return
								Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
								If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
									ClickP($aiUseButton)
									If _Sleep(1000) Then Return
									$ActionForModLog = "Boosting Builders"
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Snacks : " & $ActionForModLog & " Using Builder Potion", 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Snacks : " & $ActionForModLog & " Using Builder Potion", 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Snacks : " & $ActionForModLog)
									If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
									$bRecheck = True
									If _Sleep(1000) Then Return
									ExitLoop
								Else
									SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
									CloseWindow2()
								EndIf
							Else
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " won't be used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
								SetLog("Not Enough Upgrades in Progress", $COLOR_DEBUG)
							EndIf
						Else
							SetLog(ConvertName($aMagicSnacks[$i][0]) & " can't be used (Full)" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
							If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
							If _Sleep(1000) Then Return
						EndIf
					ElseIf StringInStr($aMagicSnacks[$i][3], "Yes", $STR_NOCASESENSEBASIC) Then
						If StringInStr($aMagicSnacks[$i][0], "Soup", $STR_NOCASESENSEBASIC) Then
							If $IsAnyLabUpgrade Then
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " can be used.", $COLOR_SUCCESS1)
								If _Sleep(500) Then Return
								Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
								If _Sleep(1000) Then Return
								Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
								If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
									ClickP($aiUseButton)
									If _Sleep(1000) Then Return
									$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTimeMod - 180), _NowCalc())
									SetLog("Recalculate Research time, using Study Soup (" & $g_sLabUpgradeTime & ")")
									LabStatusGUIUpdate()
									$ActionForModLog = "Boosting Lab Research"
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Snacks : " & $ActionForModLog & " Using Study Soup", 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Snacks : " & $ActionForModLog & " Using Study Soup", 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Snacks : " & $ActionForModLog)
									If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
									$bRecheck = True
									If _Sleep(1000) Then Return
									ExitLoop
								Else
									SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
									CloseWindow2()
								EndIf
							Else
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " won't be used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
								SetLog("No Laboratory Upgrade in Progress", $COLOR_DEBUG)
							EndIf
						ElseIf StringInStr($aMagicSnacks[$i][0], "Bite", $STR_NOCASESENSEBASIC) Then
							If $IsAnyBuildingUpgrade Then
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " can be used.", $COLOR_SUCCESS1)
								If _Sleep(500) Then Return
								Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
								If _Sleep(1000) Then Return
								Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
								If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
									ClickP($aiUseButton)
									If _Sleep(1000) Then Return
									$ActionForModLog = "Boosting Builders"
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Snacks : " & $ActionForModLog & " Using Builder Bite", 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Snacks : " & $ActionForModLog & " Using Builder Bite", 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Snacks : " & $ActionForModLog)
									If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
									$bRecheck = True
									If _Sleep(1000) Then Return
									ExitLoop
								Else
									SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
									CloseWindow2()
								EndIf
							Else
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " won't be used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
								SetLog("Not Enough Upgrades in Progress", $COLOR_DEBUG)
							EndIf
						ElseIf StringInStr($aMagicSnacks[$i][0], "Castle", $STR_NOCASESENSEBASIC) Then
							If $bChkUseOnlyCCMedals Or (Not $bChkUseOnlyCCMedals And $g_aiCmbCCDecisionThen = 1) Then
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " can be used.", $COLOR_SUCCESS1)
								If _Sleep(500) Then Return
								Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
								If _Sleep(1000) Then Return
								Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
								If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
									ClickP($aiUseButton)
									$ClanCastleCakeTimer = __TimerInit()
									If _Sleep(1000) Then Return
									$ActionForModLog = "Using Clan Castle Cake"
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Magic Snacks : " & $ActionForModLog, 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Magic Snacks : " & $ActionForModLog, 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Magic Snacks : " & $ActionForModLog)
									If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
									$bRecheck = True
									If _Sleep(1000) Then Return
									ExitLoop
								Else
									SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
									CloseWindow2()
								EndIf
							Else
								SetLog(ConvertName($aMagicSnacks[$i][0]) & " won't be used" & ($i = UBound($aMagicSnacks) - 1 ? "." : ", looking next..."), $COLOR_DEBUG1)
								SetLog("Can be used only when CC Medal Filling", $COLOR_DEBUG)
							EndIf
						Else
							SetLog(ConvertName($aMagicSnacks[$i][0]) & " can be used.", $COLOR_SUCCESS1)
							Click($aMagicSnacks[$i][1], $aMagicSnacks[$i][2])
							If _Sleep(1000) Then Return
							Local $aiUseButton = decodeSingleCoord(FindImageInPlace2("UseButton", $g_sImgUseButton, 380, 470 + $g_iMidOffsetY, 500, 540 + $g_iMidOffsetY, True))
							If IsArray($aiUseButton) And UBound($aiUseButton) = 2 Then
								ClickP($aiUseButton)
								If _Sleep(1000) Then Return
								$ActionForModLog = $aMagicSnacks[$i][0]
								If $g_iTxtCurrentVillageName <> "" Then
									GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Using Magic Snack : " & $ActionForModLog, 1)
								Else
									GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Using Magic Snack : " & $ActionForModLog, 1)
								EndIf
								_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Using Magic Snack : " & $ActionForModLog)
								If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
								$bRecheck = True
								If _Sleep(1000) Then Return
								ExitLoop
							Else
								SetDebugLog("Cannot Find Use Button", $COLOR_ERROR)
								CloseWindow2()
							EndIf
						EndIf
						If $aMagicSnacks[$i][1] > 524 Then ExitLoop 2 ; Exit loops if last snack
						If _Sleep(1000) Then Return
					EndIf
				Next
				If _Sleep(1000) Then Return
			WEnd
			If _Sleep(500) Then Return
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

	If Number($g_iFreeBuilderCount) < 2 Then
		SetDebugLog("Enough Upgrades in Progress", $COLOR_SUCCESS)
		Return True
	Else
		SetDebugLog("Not Enough Upgrades in Progress", $COLOR_DEBUG)
		Return False
	EndIf
EndFunc   ;==>AllowBoostingBuildersForSnacks

Func ConvertName($bName = "")

	Local $bProperName = ""

	Switch $bName
		Case "BuilderBite"
			$bProperName = "Builder Bite"
		Case "BuilderJar"
			$bProperName = "Builder Star Jar"
		Case "CastleCake"
			$bProperName = "Castle Cake"
		Case "PowerPancake"
			$bProperName = "Power Pancake"
		Case "StudySoup"
			$bProperName = "Study Soup"
		Case "TrainingTreat"
			$bProperName = "Training Treat"
		Case "MightyMorsel"
			$bProperName = "Mighty Morsel"
		Case "TrainingPotion"
			$bProperName = "Training Potion"
		Case "PowerPotion"
			$bProperName = "Power Potion"
		Case "BuilderPotion"
			$bProperName = "Builder Potion"
		Case "RuneofElixir"
			$bProperName = "Rune of Elixir"
		Case "Shovel"
			$bProperName = "Shovel"
		Case "ResourcePotion"
			$bProperName = "Resource Potion"
		Case "HeroPotion"
			$bProperName = "Hero Potion"
		Case "BookOfHero"
			$bProperName = "Book Of Hero"
		Case Else
			$bProperName = $bName
	EndSwitch

	Return $bProperName

EndFunc   ;==>ConvertName
