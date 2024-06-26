
; #FUNCTION# ====================================================================================================================
; Name ..........: _PixelSearch
; Description ...: PixelSearch a certain region, works for memory BMP
; Syntax ........: _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $sColor, $iColorVariation)
; Parameters ....: $iLeft               - an integer value.
;                  $iTop                - an integer value.
;                  $iRight              - an integer value.
;                  $iBottom             - an integer value.
;                  $sColor              - an string value with hex color to search
;                  $iColorVariation     - an integer value.
;                  $bNeedCapture        - [optional] a boolean flag to get new screen capture, when False full screen must have been captured wuth _CaptureRegion() !!!
; Return values .: None
; Author ........: Your Name
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $sColor, $iColorVariation, $bNeedCapture = True)
	Local $x1, $x2, $y1, $y2
	If $bNeedCapture = True Then
		_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
		$x1 = $iRight - $iLeft
		$x2 = 0
		$y1 = 0
		$y2 = $iBottom - $iTop
	Else
		$x1 = $iRight
		$x2 = $iLeft
		$y1 = $iTop
		$y2 = $iBottom
	EndIf
	For $x = $x1 To $x2 Step -1
		For $y = $y1 To $y2
			If _ColorCheck(_GetPixelColor($x, $y), $sColor, $iColorVariation) Then
				Local $Pos[2] = [$iLeft + $x - $x2, $iTop + $y - $y1]
				Return $Pos
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_PixelSearch

Func WaitForClanMessage($bType)
	Switch $bType
		Case "DonatedTroops"
			If IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True)) Then
				SetDebugLog("Detected Clan Castle Message Blocking Troop Count. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "TrainTabs"
			If IsArray(_PixelSearch($aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1], $aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1] + $aReceivedTroopsDouble[4], Hex($aReceivedTroopsDouble[2], 6), $aReceivedTroopsDouble[3], True)) Or _
					IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True)) Then
				SetDebugLog("Detected Clan Castle Message Blocking Troop Count. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1], $aReceivedTroopsDouble[0], $aReceivedTroopsDouble[1] + $aReceivedTroopsDouble[4], Hex($aReceivedTroopsDouble[2], 6), $aReceivedTroopsDouble[3], True)) Or _
						IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "ArmyOverview"
			If IsArray(_PixelSearch($aReceivedTroops[0], $aReceivedTroops[1], $aReceivedTroops[0], $aReceivedTroops[1] + $aReceivedTroops[4], Hex($aReceivedTroops[2], 6), $aReceivedTroops[3], True)) Or _
					IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True)) Then
				SetDebugLog("Detected Clan Castle Message Blocking Troop Images. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroops[0], $aReceivedTroops[1], $aReceivedTroops[0], $aReceivedTroops[1] + $aReceivedTroops[4], Hex($aReceivedTroops[2], 6), $aReceivedTroops[3], True)) Or _
						IsArray(_PixelSearch($aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1], $aReceivedTroopsOCR[0], $aReceivedTroopsOCR[1] + $aReceivedTroopsOCR[4], Hex($aReceivedTroopsOCR[2], 6), $aReceivedTroopsOCR[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "SuperTroops"
			If IsArray(_PixelSearch($aBoostTroopsWindow[0], $aBoostTroopsWindow[1], $aBoostTroopsWindow[0], $aBoostTroopsWindow[1] + $aBoostTroopsWindow[4], Hex($aBoostTroopsWindow[2], 6), $aBoostTroopsWindow[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aBoostTroopsWindow[0], $aBoostTroopsWindow[1], $aBoostTroopsWindow[0], $aBoostTroopsWindow[1] + $aBoostTroopsWindow[4], Hex($aBoostTroopsWindow[2], 6), $aBoostTroopsWindow[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "RaidMedals"
			If IsArray(_PixelSearch($aReceivedTroopsRaidMedals[0], $aReceivedTroopsRaidMedals[1], $aReceivedTroopsRaidMedals[0], $aReceivedTroopsRaidMedals[1] + $aReceivedTroopsRaidMedals[4], Hex($aReceivedTroopsRaidMedals[2], 6), $aReceivedTroopsRaidMedals[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsRaidMedals[0], $aReceivedTroopsRaidMedals[1], $aReceivedTroopsRaidMedals[0], $aReceivedTroopsRaidMedals[1] + $aReceivedTroopsRaidMedals[4], Hex($aReceivedTroopsRaidMedals[2], 6), $aReceivedTroopsRaidMedals[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "WeeklyDeals"
			If IsArray(_PixelSearch($aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1], $aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1] + $aReceivedTroopsWeeklyDeals[4], Hex($aReceivedTroopsWeeklyDeals[2], 6), $aReceivedTroopsWeeklyDeals[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1], $aReceivedTroopsWeeklyDeals[0], $aReceivedTroopsWeeklyDeals[1] + $aReceivedTroopsWeeklyDeals[4], Hex($aReceivedTroopsWeeklyDeals[2], 6), $aReceivedTroopsWeeklyDeals[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "Treasury"
			If IsArray(_PixelSearch($aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1], $aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1] + $aReceivedTroopsTreasury[4], Hex($aReceivedTroopsTreasury[2], 6), $aReceivedTroopsTreasury[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1], $aReceivedTroopsTreasury[0], $aReceivedTroopsTreasury[1] + $aReceivedTroopsTreasury[4], Hex($aReceivedTroopsTreasury[2], 6), $aReceivedTroopsTreasury[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
		Case "Tabs"
			If IsArray(_PixelSearch($aReceivedTroopsTab[0], $aReceivedTroopsTab[1], $aReceivedTroopsTab[0], $aReceivedTroopsTab[1] + $aReceivedTroopsTab[4], Hex($aReceivedTroopsTab[2], 6), $aReceivedTroopsTab[3], True)) Then
				SetDebugLog("Detected Clan Castle Message. Waiting until it's gone", $COLOR_INFO)
				Local $Safetyexit = 0
				While IsArray(_PixelSearch($aReceivedTroopsTab[0], $aReceivedTroopsTab[1], $aReceivedTroopsTab[0], $aReceivedTroopsTab[1] + $aReceivedTroopsTab[4], Hex($aReceivedTroopsTab[2], 6), $aReceivedTroopsTab[3], True))
					If _Sleep($DELAYTRAIN1) Then Return
					$Safetyexit = $Safetyexit + 1
					If $Safetyexit > 20 Then ExitLoop ; If waiting longer than 20 secs, something is wrong
				WEnd
			EndIf
	EndSwitch
EndFunc   ;==>WaitForClanMessage
