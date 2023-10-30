; #FUNCTION# ====================================================================================================================
; Name ..........: StartClockTowerBoost
; Description ...:
; Syntax ........: StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)
; Parameters ....: $bSwitchToBB: Switch from Normal Village to Builder Base - $bSwitchToNV: Switch back to normal Village after Function ran
; Return values .: None
; Author ........: Fliegerfaust (06-2017), MMHK (07-2017)
; Modified ......: Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func ClockTimeGained()
	Local $aResult = BuildingInfo(242, 468 + $g_iBottomOffsetY)
	Local $TowerClockLevel = $aResult[2]
	SetLog("Clock Tower Level " & $TowerClockLevel & " Detected")
	Local $ClockTimeGained = 0
	Switch $TowerClockLevel
		Case 1
			$ClockTimeGained = 126 ;boost lenght*(10-1) <=> boost lenght*9
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
		Case 10
			$ClockTimeGained = 288
		Case Else
			$ClockTimeGained = 270 ;30 minutes boost(?)
	EndSwitch
	Return $ClockTimeGained
EndFunc   ;==>ClockTimeGained

Func StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False, $bConditionsToUseClockPotion = False)

	If Not $g_bChkStartClockTowerBoost Then Return
	If Not $g_bRunState Then Return

	Local $TimeGained = 0
	Local $IsCTToOpen = False
	Local $IsCTOpenNonAvail = False

	If $bSwitchToBB Then
		ClickAway()
		If Not SwitchBetweenBases(True, True) Then Return ; Switching to Builders Base
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
			If _Sleep(1000) Then Return
			For $i = 0 To 20
				If QuickMIS("BC1", $g_sImgCTNonAvailable) Then
					Click($g_iQuickMISX - 7, $g_iQuickMISY) ;Click On CT Non Available
					If _Sleep($DELAYCLOCKTOWER1) Then Return
					$IsCTOpenNonAvail = True
					If _Sleep(500) Then Return
					ExitLoop
				EndIf
				If _Sleep(150) Then Return
			Next
			$TimeGained = ClockTimeGained()
		EndIf

		If Not $g_bRunState Then Return

		If $IsCTToOpen And Not $IsCTOpenNonAvail Then
			SetLog("Clock Tower Didn't Open")
			Return
		EndIf

		If $bConditionsToUseClockPotion And $bUseClockPotion Then
			If _Sleep(2000) Then Return
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
					If _Sleep(1000) Then Return
				EndIf
			Else
				SetLog("Clock Tower Potion Not Found", $COLOR_DEBUG)
				If _Sleep(1000) Then Return
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

	If $g_iFreeBuilderCountBB > 0 Then Return False ; Change july 2023 : All Builders have work To use Clock Potion.

	If Not ClickOnBuilder2() Then Return False

	If _Sleep(500) Then Return
	If QuickMIS("BC1", $g_sImgAUpgradeHour, 550, 105, 630, 140) Then
		Local $sUpgradeTime = getBuilderLeastUpgradeTime($g_iQuickMISX - 50, $g_iQuickMISY - 8)
		Local $mUpgradeTime = ConvertOCRTime("Least Upgrade", $sUpgradeTime, False)
		If $mUpgradeTime > 540 Then
			ClickAway("Right")
			Return True
		EndIf
	EndIf
	ClickAway("Right")
	Return False
EndFunc   ;==>CheckBBuilderTime

Func ClickOnBuilder2()

	; Master Builder Check pixel [i] icon
	Local Const $aMasterBuilder[4] = [463, 10, 0x7ABDE3, 10]
	; Debug Stuff
	Local $sDebugText = ""

	; Check the Color and click
	If _CheckPixel($aMasterBuilder, True) Then
		; Click on Builder
		Click($aMasterBuilder[0], $aMasterBuilder[1], 1)
		If _Sleep(2000) Then Return
		; Let's verify if the Suggested Window open
		If QuickMIS("BC1", $g_sImgAutoUpgradeWindow, 455, 50, 585, 100) Then
			Return True
		Else
			$sDebugText = "Window didn't opened"
		EndIf
	Else
		$sDebugText = "BB Pixel problem"
	EndIf

	If $sDebugText <> "" Then SetLog("Problem on Suggested Upg Window: [" & $sDebugText & "]", $COLOR_ERROR)
	Return False

EndFunc   ;==>ClickOnBuilder
