; #FUNCTION# ====================================================================================================================
; Name ..........: StartClockTowerBoost
; Description ...:
; Syntax ........: StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)
; Parameters ....: $bSwitchToBB: Switch from Normal Village to Builder Base - $bSwitchToNV: Switch back to normal Village after Function ran
; Return values .: None
; Author ........: Fliegerfaust (06-2017), MMHK (07-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func ClockTimeGained()
Local $aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY)
Local $TowerClockLevel = $aResult[2]
SetLog("Clock Tower Level " & $TowerClockLevel & " Detected")
Local $ClockTimeGained = 0
	Switch $TowerClockLevel
		Case 1
			$ClockTimeGained = 126
		Case 2
			$ClockTimeGained = 144
		Case 3
			$ClockTimeGained = 162
		Case 4
			$ClockTimeGained = 180
		Case 5
			$ClockTimeGained = 198
		Case 6
			$ClockTimeGained = 216
		Case 7
			$ClockTimeGained = 236
		Case 8
			$ClockTimeGained = 252
		Case 9
			$ClockTimeGained = 270
		Case Else
			$ClockTimeGained = 270
	EndSwitch
Return $ClockTimeGained
EndFunc

Func StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False, $bConditionsToUseClockPotion = False)

	If Not $g_bChkStartClockTowerBoost Then Return
	If Not $g_bRunState Then Return
	
	Local $TimeGained = 0
	Local $IsCTToOpen = False
	Local $IsCTOpenNonAvail = False

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases() Then Return ; Switching to Builders Base
	EndIf

	Local $bCTBoost = True
	If $g_bChkCTBoostBlderBz Then
		getBuilderCount(True, True) ; Update Builder Variables for Builders Base
		If $g_iFreeBuilderCountBB = $g_iTotalBuilderCountBB Then $bCTBoost = False ; Builder is not busy, skip Boost
	EndIf

	If Not $bCTBoost Then
		SetLog("Skip Clock Tower Boost as no Building is currently under Upgrade!", $COLOR_INFO)
	Else ; Start Boosting
		SetLog("Boosting Clock Tower", $COLOR_INFO)
		If _Sleep($DELAYCOLLECT2) Then Return

		ClickAway("Left")
		Local $sCTCoords, $aCTCoords, $aCTBoost
		$sCTCoords = findImage("ClockTowerAvailable", $g_sImgStartCTBoost, "FV", 1, True) ; Search for Clock Tower
		If $sCTCoords <> "" Then
			$aCTCoords = StringSplit($sCTCoords, ",", $STR_NOCOUNT)
			ClickP($aCTCoords)
			If _Sleep($DELAYCLOCKTOWER1) Then Return
			$TimeGained = ClockTimeGained()
			
			$aCTBoost = findButton("BoostCT") ; Search for Start Clock Tower Boost Button
			If IsArray($aCTBoost) Then
				ClickP($aCTBoost)
				If _Sleep($DELAYCLOCKTOWER1) Then Return

				$aCTBoost = findButton("BOOSTBtn") ; Search for Boost Button
				If IsArray($aCTBoost) Then
					ClickP($aCTBoost)
					If _Sleep($DELAYCLOCKTOWER2) Then Return
					SetLog("Boosted Clock Tower successfully!", $COLOR_SUCCESS)
					If $iStarLabFinishTimeMod > 0 Then
						$g_sStarLabUpgradeTime = _DateAdd('n', Ceiling($iStarLabFinishTimeMod - $TimeGained), _NowCalc())
						SetLog("Recalculate Research Time, Boosting Clock Tower (" & $g_sStarLabUpgradeTime & ")")
						StarLabStatusGUIUpdate()
					EndIf
				Else
					SetLog("Failed to find the BOOST window button", $COLOR_ERROR)
				EndIf
			Else
				SetLog("Cannot find the Boost Button of Clock Tower", $COLOR_ERROR)
			EndIf
		Else
			SetLog("Clock Tower boost is not available!")
			If $bConditionsToUseClockPotion And $bUseClockPotion Then $IsCTToOpen = True
		EndIf
		
		If $IsCTToOpen Then
			_Sleep(1000)
			For $i = 0 To 20
				If QuickMIS("BC1", $g_sImgCTNonAvailable) Then
					Click($g_iQuickMISX - 7, $g_iQuickMISY) ;Click On CT Non Available
					If _Sleep($DELAYCLOCKTOWER1) Then Return
					$IsCTOpenNonAvail = True
					_Sleep(500)
					ExitLoop
				EndIf
				_Sleep(150)
			Next
			$TimeGained = ClockTimeGained()
		EndIf
		
		If Not $g_bRunState Then Return
		
		If $IsCTToOpen And Not $IsCTOpenNonAvail Then
			SetLog("Clock Tower Didn't Open")
			Return
		EndIf
		
		If $bConditionsToUseClockPotion And $bUseClockPotion Then
			_Sleep(1500)
			Local $click = ClickB("ClockTowerPot") ;click Clock Tower Boost potion Button
			If $click Then
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
				If ClickB("BoostConfirm") Then
					SetLog("Builderbase Boosted With Clock Tower Potion", $COLOR_SUCCESS)
					If $iStarLabFinishTimeMod > 0 Then
						If $IsCTToOpen Then
							$g_sStarLabUpgradeTime = _DateAdd('n', Ceiling($iStarLabFinishTimeMod - 270), _NowCalc())
						Else
							$g_sStarLabUpgradeTime = _DateAdd('n', Ceiling($iStarLabFinishTimeMod - (270 + $TimeGained)), _NowCalc())
						EndIf
						SetLog("Recalculate Research Time, Using Potion (" & $g_sStarLabUpgradeTime & ")")
						StarLabStatusGUIUpdate()
					EndIf
					$ActionForModLog = "Clock Tower Boosting"
					If $g_iTxtCurrentVillageName <> "" Then
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] BuilderBase : " & $ActionForModLog & " Using Potion", 1)
					Else
						GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] BuilderBase : " & $ActionForModLog & " Using Potion", 1)
					EndIf
					_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - BuilderBase : " & $ActionForModLog & "")
				EndIf
			Else
				SetLog("Clock Tower Potion Not Found", $COLOR_DEBUG)
			EndIf
		EndIf
		
	EndIf
	ClickAway()
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")

	If $bSwitchToNV Then SwitchBetweenBases() ; Switching back to the normal Village if true
EndFunc   ;==>StartClockTowerBoost

Func CheckBBuilderTime()
	If Not $g_bRunState Then Return
	
	If Not $bUseClockPotion Then Return False
	
	getBuilderCount(False, True)
	
	If $g_iFreeBuilderCountBB = $g_iTotalBuilderCountBB Then Return False
	
	ClickMainBBuilder()
	If _Sleep(500) Then Return
	If QuickMIS("BC1", $g_sImgAUpgradeHour, 430, 105, 510, 140) Then
		Local $sUpgradeTime = getBuilderLeastUpgradeTime($g_iQuickMISX - 50, $g_iQuickMISY - 8)
		Local $mUpgradeTime = ConvertOCRTime("Least Upgrade", $sUpgradeTime, False)
		If $mUpgradeTime > 540 Then
			ClickAway("Right")
			Return True
		EndIf
	EndIf
	ClickAway("Right")
	Return False
EndFunc		
		
Func ClickMainBBuilder($bTest = False, $Counter = 3)
	Local $b_WindowOpened = False
	If Not $g_bRunState Then Return
	; open the builders menu
	If Not _ColorCheck(_GetPixelColor(440,73, True), "FFFFFF", 50) Then
		Click(383, 30)
		If _Sleep(1000) Then Return
	EndIf

	If IsBBuilderMenuOpen() Then
		SetDebugLog("Open Upgrade Window, Success", $COLOR_SUCCESS)
		$b_WindowOpened = True
	Else
		For $i = 1 To $Counter
			SetLog("Upgrade Window didn't open, trying again!", $COLOR_DEBUG)
			If IsFullBBScreenWindow() Then
				Click(825,45)
				If _Sleep(1000) Then Return
			EndIf
			Click(383, 30)
			If _Sleep(1000) Then Return
			If IsBBuilderMenuOpen() Then
				$b_WindowOpened = True
				ExitLoop
			EndIf
		Next
		If Not $b_WindowOpened Then
			SetLog("Something is wrong with upgrade window, already tried 3 times!", $COLOR_DEBUG)
		EndIf
	EndIf
	Return $b_WindowOpened
EndFunc ;==>ClickMainBBuilder

Func IsBBuilderMenuOpen()
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
		$sTriangle = getOcrAndCapture("coc-buildermenu-main", 415, 60, 430, 73)
		SetDebugLog("$sTriangle: " & $sTriangle)
		If $sTriangle = "^" Then $bRet = True
	EndIf
	
	Return $bRet
EndFunc

Func IsFullBBScreenWindow()
	Local $result
	$result = WaitforPixel(823,49,825,51, "FFFFFF", 10, 2) Or WaitforPixel(823,49,825,51, "8C9CB6", 10, 2) Or WaitforPixel(823,49,825,51, "C0C9D3", 10, 2) Or _
	WaitforPixel(823,49,825,51, "BEBFB", 10, 2) Or WaitforPixel(823,49,825,51, "F7F8F5", 10, 2) Or WaitforPixel(823,49,825,51, "C3CBD9", 10, 2)
	
	If $result Then
		If $g_bDebugSetlog Or $g_bDebugClick Then SetLog("Found FullScreen Window", $COLOR_ACTION)
		Return True
	EndIf
	Return False
EndFunc
