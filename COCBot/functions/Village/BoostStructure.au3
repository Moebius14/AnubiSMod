; #FUNCTION# ====================================================================================================================
; Name ..........: Boost any structure (King, Queen, Warden, Champion)
; Description ...:
; Syntax ........: BoostStructure($sName, $sOcrName, $aPos, ByRef $icmbBoostValue, $cmbBoostCtrl)
; Parameters ....:
; Return values .: True if boosted, False if not
; Author ........: Cosote Oct. 2016
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
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
		Local $aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY)
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
			Click($Boost[0], $Boost[1], 1, 0, "#0463")
			If _Sleep($DELAYBOOSTHEROES1) Then Return
			$Boost = findButton("GEM")
			If IsArray($Boost) Then
				Click($Boost[0], $Boost[1], 1, 0, "#0464")
				If _Sleep($DELAYBOOSTHEROES4) Then Return
				If IsArray(findButton("EnterShop")) Then
					SetLog("Not enough gems to boost " & $sName, $COLOR_ERROR)
				Else
					If $icmbBoostValue <= 24 Then
						$icmbBoostValue -= 1
						SetLog($sName & ' Boost completed. Remaining iterations: ' & $icmbBoostValue, $COLOR_SUCCESS)
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
			ClickAway()
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
	
	Local $BuildingInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY)

	If $BuildingInfo[1] = "Town Hall" Then
		$ok = True
	Else
		SetLog("Town Hall Windows Didn't Open", $COLOR_DEBUG1)
		SetLog("New Try...", $COLOR_DEBUG1)
		ClickAway()
		Sleep(Random(1000, 1500, 1))
		imglocTHSearch(False, True, True) ;Sets $g_iTownHallLevel
		Sleep(Random(1000, 1500, 1))
		BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
		$BuildingInfo = BuildingInfo(242, 490 + $g_iBottomOffsetY)
		If $BuildingInfo[1] = "Town Hall" Then $ok = True
	EndIf		
				
	If $ok Then
		Local $sTile = "BoostPotion_0_90.xml", $sRegionToSearch = "172,238,684,469"
		Local $Boost = findButton("MagicItems")
		If UBound($Boost) > 1 Then
			If $g_bDebugSetlog Then SetDebugLog("Magic Items Button X|Y = " & $Boost[0] & "|" & $Boost[1], $COLOR_DEBUG)
			Click($Boost[0], $Boost[1], 1, 0, "#0463")
			If _Sleep($DELAYBOOSTHEROES1) Then Return
			$Boost = decodeSingleCoord(FindImageInPlace($sTile, @ScriptDir & "\imgxml\imglocbuttons\" & $sTile, $sRegionToSearch))
			If UBound($Boost) > 1 Then
				If $g_bDebugSetlog Then SetDebugLog("Boost Potion Button X|Y = " & $Boost[0] & "|" & $Boost[1], $COLOR_DEBUG)
				ClickP($Boost)
				If _Sleep($DELAYBOOSTHEROES1) Then Return
				If Not _ColorCheck(_GetPixelColor(255, 535, True), Hex(0xFFFFFF, 6), 25) Then
					SetLog("Cannot find/verify 'Use' Button", $COLOR_WARNING)
					ClickAway()
					Return False ; Exit Function
				EndIf
				Click(260, 536) ; Click on 'Use'
				If _Sleep($DELAYBOOSTHEROES2) Then Return
				If Not $g_bRunState Then Return
				$Boost = findButton("BoostPotionGreen")
				If IsArray($Boost) Then
					Click($Boost[0], $Boost[1], 1, 0, "#0465")
					If _Sleep($DELAYBOOSTHEROES4) Then Return
					If $icmbBoostValue <= 5 Then
						$icmbBoostValue -= 1
						SetLog($sName & ' Boost completed. Remaining iterations: ' & $icmbBoostValue, $COLOR_SUCCESS)
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
			ClickAway()
		Else
			SetLog("Abort boosting " & $sName & ", bad location", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Cannot boost using training potion some error occured", $COLOR_ERROR)	
	EndIf
	ClickAway()
	_Sleep(Random(2000, 3000, 1))
	Return $boosted
EndFunc   ;==>BoostPotion

Func AllowBoostingBuilders($Masked = False)
	If $g_iCmbBoostBuilders = 0 Then Return False
	
	Local $g_iTimerBoostBuildersDiff = TimerDiff($g_iTimerBoostBuilders[$g_iCurAccount])
	If $g_iTimerBoostBuildersDiff > 0 And $g_iTimerBoostBuildersDiff < Number(60 * 60 * 1000) Then
		SetLog("Last iteration < 60 minutes, Recheck later", $COLOR_NAVY)
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
EndFunc   ;==>AllowBoosting

Func CheckBuilderPotion()
	If Not $g_bRunState Then Return
	If Not AllowBoostingBuilders() Then Return
	Local $IsForge = False
	ClickMainBuilder()
	If _Sleep(500) Then Return
	If QuickMIS("BC1", $g_sImgAUpgradeHour, 330, 105, 440, 140) Then
		Local $sUpgradeTime = getBuilderLeastUpgradeTime($g_iQuickMISX - 50, $g_iQuickMISY - 8)
		Local $mUpgradeTime = ConvertOCRTime("Least Upgrade", $sUpgradeTime, False)
		If $mUpgradeTime > 540 Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(2000) Then Return
			
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 715, 180, 760, 225) Then
				SetLog("Forge Time > 9h, will use Builder Potion", $COLOR_INFO)
				$IsForge = True
			Else
				SetLog("Upgrade Time > 9h, will use Builder Potion", $COLOR_INFO)
			EndIf
			
			If QuickMis("BC1", $g_sBoostBuilderInForge, 620, 470, 665, 520) Then
			Click($g_iQuickMISX + 42, $g_iQuickMISY)
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
				If ClickB("BoostConfirm") Then
					SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
					If $g_iCmbBoostBuilders <= 5 Then
						$g_iCmbBoostBuilders -= 1
						If $g_iCmbBoostBuilders > 0 Then
							$g_iTimerBoostBuilders[$g_iCurAccount] = TimerInit()
						Else
							$g_iTimerBoostBuilders[$g_iCurAccount] = 0
						EndIf
						SetLog("Builders Boost completed. Remaining iterations: " & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
						_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
					EndIf
					$ActionForModLog = "Boosting Builders"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog & "")
					ClickAway()
					ZoomOut()
					Return
				EndIf
			EndIf
			
			If ClickB("BuilderPot") Then
				If _Sleep(1000) Then Return
				If ClickB("BoostConfirm") Then
					SetLog("Builders Boosted Using Potion", $COLOR_SUCCESS1)
					If $g_iCmbBoostBuilders <= 5 Then
						$g_iCmbBoostBuilders -= 1
						If $g_iCmbBoostBuilders > 0 Then
							$g_iTimerBoostBuilders[$g_iCurAccount] = TimerInit()
						Else
							$g_iTimerBoostBuilders[$g_iCurAccount] = 0
						EndIf
						SetLog("Builders Boost completed. Remaining iterations: " & $g_iCmbBoostBuilders, $COLOR_SUCCESS)
						_GUICtrlComboBox_SetCurSel($g_hCmbBoostBuilders, $g_iCmbBoostBuilders)
					EndIf
					$ActionForModLog = "Boosting Builders"
					If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
						Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Upgrade Village : " & $ActionForModLog & " Using Potion", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Upgrade Village : " & $ActionForModLog & "")
					ClickAway()
				EndIf
			Else
				SetLog("BuilderPot Not Found", $COLOR_DEBUG)
				ClickAway()
			EndIf
		Else
			If $IsForge Then
				SetLog("Forge Time < 9h, cancel using Builder Potion", $COLOR_INFO)
			Else
				SetLog("Upgrade Time < 9h, cancel using Builder Potion", $COLOR_INFO)
			EndIf
			ClickAway()
		EndIf
	Else
		SetLog("Failed to read Upgrade time on BuilderMenu", $COLOR_ERROR)
		ClickAway()
	EndIf
	ZoomOut()
EndFunc

Func ClickMainBuilder($bTest = False, $Counter = 3)
	Local $b_WindowOpened = False
	If Not $g_bRunState Then Return
	; open the builders menu
	If Not _ColorCheck(_GetPixelColor(350,73, True), "FFFFFF", 50) Then
		Click(292, 30)
		If _Sleep(1000) Then Return
	EndIf

	If IsBuilderMenuOpen() Then
		SetDebugLog("Open Upgrade Window, Success", $COLOR_SUCCESS)
		$b_WindowOpened = True
	Else
		For $i = 1 To $Counter
			SetLog("Upgrade Window didn't open, trying again!", $COLOR_DEBUG)
			If IsFullScreenWindow() Then
				Click(825,45)
				If _Sleep(1000) Then Return
			EndIf
			Click(292, 30)
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
EndFunc ;==>ClickMainBuilder

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
		$sTriangle = getOcrAndCapture("coc-buildermenu-main", 320, 60, 345, 73)
		SetDebugLog("$sTriangle: " & $sTriangle)
		If $sTriangle = "^" Then $bRet = True
	EndIf
	
	Return $bRet
EndFunc

Func IsFullScreenWindow()
	Local $result
	$result = WaitforPixel(823,49,825,51, "FFFFFF", 10, 2) Or WaitforPixel(823,49,825,51, "8C9CB6", 10, 2) Or WaitforPixel(823,49,825,51, "C0C9D3", 10, 2) Or _
	WaitforPixel(823,49,825,51, "BEBFB", 10, 2) Or WaitforPixel(823,49,825,51, "F7F8F5", 10, 2) Or WaitforPixel(823,49,825,51, "C3CBD9", 10, 2)
	
	If $result Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("Found FullScreen Window", $COLOR_ACTION)
		Return True
	EndIf
	Return False
EndFunc