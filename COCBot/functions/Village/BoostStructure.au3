; #FUNCTION# ====================================================================================================================
; Name ..........: Boost any structure (King, Queen, Warden, Champion)
; Description ...:
; Syntax ........: BoostStructure($sName, $sOcrName, $aPos, ByRef $icmbBoostValue, $cmbBoostCtrl)
; Parameters ....:
; Return values .: True if boosted, False if not
; Author ........: Cosote Oct. 2016
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BoostStructure($sName, $sOcrName, $aPos, ByRef $icmbBoostValue, $cmbBoostCtrl)
	Local $boosted = False
	Local $ok = False

	If $g_iCommandStop = 0 Or $g_iCommandStop = 3 Then ;halt attack.. do not boost now
		SetLog("Boost skipped, account on halt attack mode", $COLOR_ACTION)
		Return False
	EndIf

	If UBound($aPos) > 1 And $aPos[0] > 0 And $aPos[1] > 0 Then
		BuildingClickP($aPos, "#0462")
		If _Sleep($DELAYBOOSTHEROES2) Then Return
		ForceCaptureRegion()
		Local $aResult = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $aResult[0] > 1 Then
			Local $sN = $aResult[1] ; Store bldg name
			Local $sL = $aResult[2] ; Sotre bdlg level
			If $sOcrName = "" Or StringInStr($sN, $sOcrName, $STR_NOCASESENSEBASIC) > 0 Then
				; Structure located
				SetLog("Boosting " & $sN & " (Level " & $sL & ") located at " & $aPos[0] & ", " & $aPos[1], $COLOR_SUCCESS)
				$ok = True
			Else
				SetLog("Cannot boost " & $sN & " (Level " & $sL & ") located at " & $aPos[0] & ", " & $aPos[1], $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $ok = True Then
		Local $Boost = findButton("BoostOne")
		If IsArray($Boost) Then
			If $g_bDebugSetlog Then SetDebugLog("Boost Button X|Y = " & $Boost[0] & "|" & $Boost[1], $COLOR_DEBUG)
			Click($Boost[0], $Boost[1], 1, 120, "#0463")
			If _Sleep($DELAYBOOSTHEROES1) Then Return
			$Boost = findButton("GEM")
			If IsArray($Boost) Then
				Click($Boost[0], $Boost[1], 1, 120, "#0464")
				If _Sleep($DELAYBOOSTHEROES4) Then Return
				If IsArray(findButton("EnterShop")) Then
					SetLog("Not enough gems to boost " & $sName, $COLOR_ERROR)
				Else
					If $icmbBoostValue <= 24 Then
						$icmbBoostValue -= 1
						SetLog($sName & " Boost completed. Remaining iteration" & ($icmbBoostValue > 1 ? "s: " : ": ") & $icmbBoostValue, $COLOR_SUCCESS)
						_GUICtrlComboBox_SetCurSel($cmbBoostCtrl, $icmbBoostValue)
					Else
						SetLog($sName & ' Boost completed. Remaining iterations: Unlimited', $COLOR_SUCCESS)
					EndIf
					$boosted = True
				EndIf
			Else
				SetLog($sName & " is already Boosted", $COLOR_SUCCESS)
			EndIf
			If _Sleep($DELAYBOOSTHEROES3) Then Return
			ClearScreen()
		Else
			SetLog($sName & " Boost Button not found", $COLOR_ERROR)
			If _Sleep($DELAYBOOSTHEROES4) Then Return
		EndIf
	Else
		SetLog("Abort boosting " & $sName & ", bad location", $COLOR_ERROR)
	EndIf

	Return $boosted
EndFunc   ;==>BoostStructure

Func AllowBoosting($sName, $icmbBoost)
	If ($g_bTrainEnabled = True And $icmbBoost > 0) = False Then Return False

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If $g_abBoostBarracksHours[$hour[0]] = False Then
		SetLog("Boosting " & $sName & " is not planned and skipped...", $COLOR_DEBUG)
		Return False
	EndIf

	Return True
EndFunc   ;==>AllowBoosting

Func BoostPotion($sName, $sOcrName, $aPos, ByRef $icmbBoostValue, $cmbBoostCtrl)
	Local $boosted = False
	Local $ok = False

	SetLog("Boosting Everything using potion", $COLOR_OLIVE)
	BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return

	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)

	If $BuildingInfo[1] = "Town Hall" Then
		$ok = True
	Else
		SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClearScreen()
		Sleep(Random(1000, 1500, 1))
		imglocTHSearch(False, True, True) ;Sets $g_iTownHallLevel
		Sleep(Random(1000, 1500, 1))
		BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		$BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $BuildingInfo[1] = "Town Hall" Then $ok = True
	EndIf

	If $ok Then
		Local $sTile = "BoostPotion_0_90.xml", $sRegionToSearch = "172,238,684,439"
		Local $Boost = findButton("MagicItems")
		If UBound($Boost) > 1 Then
			If $g_bDebugSetlog Then SetDebugLog("Magic Items Button X|Y = " & $Boost[0] & "|" & $Boost[1], $COLOR_DEBUG)
			Click($Boost[0], $Boost[1], 1, 120, "#0463")
			If _Sleep($DELAYBOOSTHEROES1) Then Return
			$Boost = decodeSingleCoord(FindImageInPlace($sTile, @ScriptDir & "\imgxml\imglocbuttons\" & $sTile, $sRegionToSearch))
			If UBound($Boost) > 1 Then
				If $g_bDebugSetlog Then SetDebugLog("Boost Potion Button X|Y = " & $Boost[0] & "|" & $Boost[1], $COLOR_DEBUG)
				ClickP($Boost)
				If _Sleep($DELAYBOOSTHEROES1) Then Return
				If Not _ColorCheck(_GetPixelColor(256, 500 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 25) Then
					SetLog("Cannot find/verify 'Use' Button", $COLOR_WARNING)
					ClickAway()
					Return False ; Exit Function
				EndIf
				Click(600, 505 + $g_iMidOffsetY) ; Click on 'Use'
				If _Sleep($DELAYBOOSTHEROES2) Then Return
				If Not $g_bRunState Then Return
				$Boost = findButton("BoostPotionGreen")
				If IsArray($Boost) Then
					Click($Boost[0], $Boost[1], 1, 120, "#0465")
					If _Sleep($DELAYBOOSTHEROES4) Then Return
					If $icmbBoostValue <= 5 Then
						$icmbBoostValue -= 1
						SetLog($sName & " Boost completed. Remaining iteration" & ($icmbBoostValue > 1 ? "s: " : ": ") & $icmbBoostValue, $COLOR_SUCCESS)
						_GUICtrlComboBox_SetCurSel($cmbBoostCtrl, $icmbBoostValue)
					EndIf
					$boosted = True
				Else
					SetLog($sName & " is already Boosted", $COLOR_SUCCESS)
				EndIf
			Else
				SetLog($sName & " Boost Potion Button not found!", $COLOR_ERROR)
				If _Sleep($DELAYBOOSTHEROES4) Then Return
			EndIf
			If _Sleep($DELAYBOOSTHEROES3) Then Return
			ClearScreen()
		Else
			SetLog("Abort boosting " & $sName & ", bad location", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Cannot boost using training potion some error occured", $COLOR_ERROR)
	EndIf
	ClearScreen()
	If _Sleep(Random(1000, 1500, 1)) Then Return
	Return $boosted
EndFunc   ;==>BoostPotion

Func AllowBoostingBuilders($Masked = False)
	If $g_iCmbBoostBuilders = 0 Then Return False

	Local $g_iTimerBoostBuildersDiff = __TimerDiff($g_iTimerBoostBuilders)
	If $g_iTimerBoostBuildersDiff > 0 And $g_iTimerBoostBuildersDiff < Number(60 * 60 * 1000) Then ; < 1 Hour
		Local $BoostedMin = Round($g_iTimerBoostBuildersDiff / 60 / 1000) ; Convert in Minutes
		SetLog("Builder Potion :", $COLOR_NAVY)
		SetLog("Last iteration " & $BoostedMin & " minutes ago, Recheck later", $COLOR_NAVY)
		Return False
	EndIf

	If Not $Masked Then
		If Not getBuilderCount() Then Return False
		If _Sleep($DELAYRESPOND) Then Return
	EndIf

	SetLog("Checking for Use Builder Potion", $COLOR_INFO)

	If $g_iFreeBuilderCount < ($g_iCmbFreeBuilders + 1) Then
		SetLog("Boosting Builders Allowed, Enough Upgrades in Progress", $COLOR_SUCCESS)
		Return True
	Else
		SetLog("Boosting Builders is skipped, Not Enough Upgrades in Progress", $COLOR_DEBUG)
		Return False
	EndIf
EndFunc   ;==>AllowBoostingBuilders

Func CheckBuilderPotion()
	If Not $g_bRunState Then Return
	If Not AllowBoostingBuilders() Then Return
	Local $IsForge = False
	ClickMainBuilder()
	If _Sleep(500) Then Return
	If QuickMIS("BC1", $g_sImgAUpgradeHour, 430, 75 + $g_iMidOffsetY, 600, 110 + $g_iMidOffsetY) Then
		Local $sUpgradeTime = getBuilderLeastUpgradeTime($g_iQuickMISX - 50, $g_iQuickMISY - 8)
		Local $mUpgradeTime = ConvertOCRTime("Least Upgrade", $sUpgradeTime, False)
		If $mUpgradeTime > 540 Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(2000) Then Return

			If QuickMIS("BC1", $g_sImgGeneralCloseButton, 765, 130 + $g_iMidOffsetY, 815, 175 + $g_iMidOffsetY) Then
				SetLog("Forge Time > 9h, will use Builder Potion", $COLOR_INFO)
				$IsForge = True
			Else
				SetLog("Upgrade Time > 9h, will use Builder Potion", $COLOR_INFO)
			EndIf

			If QuickMIS("BC1", $g_sBoostBuilderInForge, 650, 450 + $g_iMidOffsetY, 720, 510 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX + 50, $g_iQuickMISY)
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
				If ClickB("BoostConfirm") Then
					SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
					If $g_sBSUpgradeTime <> "" And _DateIsValid($g_sBSUpgradeTime) Then
						Local $BSTimeDiff ; time remaining for Blacksmith upgrade
						$BSTimeDiff = _DateDiff('n', _NowCalc(), $g_sBSUpgradeTime) ; what is difference between end time and now in minutes?
						$g_sBSUpgradeTime = _DateAdd('n', Ceiling($BSTimeDiff - 540), _NowCalc())
						If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
					EndIf
					If $g_iCmbBoostBuilders <= 5 Then $g_iCmbBoostBuilders -= 1
					If $g_iCmbBoostBuilders > 0 Then
						$g_iTimerBoostBuilders = __TimerInit()
					Else
						$g_iTimerBoostBuilders = 0
					EndIf
					If $g_iCmbBoostBuilders <= 5 Then
						SetLog("Builders Boost completed. Remaining iteration" & ($g_iCmbBoostBuilders > 1 ? "s: " : ": ") & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
						_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
					ElseIf $g_iCmbBoostBuilders = 6 Then
						SetLog("Builders Boost completed.", $COLOR_SUCCESS)
					EndIf
					$ActionForModLog = "Boosting Builders"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog)
					CloseWindow2()
					ZoomOut()
					Return
				EndIf
			EndIf

			If ClickB("BuilderPot") Then
				If _Sleep(1000) Then Return
				If ClickB("BoostConfirm") Then
					SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
					If $g_sBSUpgradeTime <> "" And _DateIsValid($g_sBSUpgradeTime) Then
						Local $BSTimeDiff ; time remaining for Blacksmith upgrade
						$BSTimeDiff = _DateDiff('n', _NowCalc(), $g_sBSUpgradeTime) ; what is difference between end time and now in minutes?
						$g_sBSUpgradeTime = _DateAdd('n', Ceiling($BSTimeDiff - 540), _NowCalc())
						If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
					EndIf
					If $g_iCmbBoostBuilders <= 5 Then $g_iCmbBoostBuilders -= 1
					If $g_iCmbBoostBuilders > 0 Then
						$g_iTimerBoostBuilders = __TimerInit()
					Else
						$g_iTimerBoostBuilders = 0
					EndIf
					If $g_iCmbBoostBuilders <= 5 Then
						SetLog("Builders Boost completed. Remaining iteration" & ($g_iCmbBoostBuilders > 1 ? "s: " : ": ") & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
						_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
					ElseIf $g_iCmbBoostBuilders = 6 Then
						SetLog("Builders Boost completed.", $COLOR_SUCCESS)
					EndIf
					$ActionForModLog = "Boosting Builders"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog)
					ClearScreen()
				EndIf
			Else
				SetLog("BuilderPot Not Found", $COLOR_DEBUG)
				ClearScreen()
			EndIf
		Else
			If $IsForge Then
				SetLog("Forge Time < 9h, cancel using Builder Potion", $COLOR_INFO)
				CloseWindow2()
			Else
				SetLog("Upgrade Time < 9h, cancel using Builder Potion", $COLOR_INFO)
				If IsBuilderMenuOpen() Then
					Click(435, 30)
					If _Sleep(500) Then Return
				EndIf
				ClearScreen()
				If _Sleep(500) Then Return
			EndIf
		EndIf
	Else
		SetLog("Failed to read Upgrade time on BuilderMenu", $COLOR_ERROR)
		If IsBuilderMenuOpen() Then
			Click(435, 30)
			If _Sleep(500) Then Return
		EndIf
		ClearScreen()
		If _Sleep(500) Then Return
	EndIf
	ZoomOut()
EndFunc   ;==>CheckBuilderPotion

Func ClickMainBuilder($bTest = False, $Counter = 3)
	Local $b_WindowOpened = False
	If Not $g_bRunState Then Return
	; open the builders menu
	Click(435, 30)
	If _Sleep(1000) Then Return

	If IsBuilderMenuOpen() Then
		SetDebugLog("Open Upgrade Window, Success", $COLOR_SUCCESS)
		$b_WindowOpened = True
	Else
		For $i = 1 To $Counter
			SetLog("Upgrade Window didn't open, trying again!", $COLOR_DEBUG)
			Click(435, 30)
			If _Sleep(1000) Then Return
			If IsBuilderMenuOpen() Then
				$b_WindowOpened = True
				ExitLoop
			EndIf
		Next
		If Not $b_WindowOpened Then
			SetLog("Something is wrong with upgrade window, already tried 3 times!", $COLOR_DEBUG)
		EndIf
	EndIf
	Return $b_WindowOpened
EndFunc   ;==>ClickMainBuilder

Func IsBuilderMenuOpen()
	Local $bRet = False
	Local $aBorder0[4] = [400, 73, 0x8C9CB6, 20]
	Local $aBorder1[4] = [400, 73, 0xC0C9D3, 20]
	Local $aBorder2[4] = [400, 73, 0xBEBFBC, 20]
	Local $aBorder3[4] = [400, 73, 0xFFFFFF, 20]
	Local $aBorder4[4] = [400, 73, 0xF7F8F5, 20]
	Local $aBorder5[4] = [400, 73, 0xC3CBD9, 20]
	Local $aBorder6[4] = [400, 73, 0xF4F4F5, 20]
	Local $sTriangle

	For $i = 0 To 5
		If _CheckPixel($aBorder0, True) Or _CheckPixel($aBorder1, True) Or _CheckPixel($aBorder2, True) Or _CheckPixel($aBorder3, True) Or _CheckPixel($aBorder4, True) Or _
				_CheckPixel($aBorder5, True) Or _CheckPixel($aBorder6, True) Then
			SetDebugLog("Found Border Color: " & _GetPixelColor($aBorder0[0], $aBorder0[1], True), $COLOR_ACTION)
			$bRet = True ;got correct color for border
			ExitLoop
		EndIf
		_Sleep(500)
	Next

	If Not $bRet Then ;lets re check if border color check not success
		$sTriangle = getOcrAndCapture("coc-buildermenu-main", 420, 60, 445, 73)
		SetDebugLog("$sTriangle: " & $sTriangle)
		If $sTriangle = "^" Then $bRet = True
	EndIf

	Return $bRet
EndFunc   ;==>IsBuilderMenuOpen
