; #FUNCTION# ====================================================================================================================
; Name ..........: Event()
; Description ...: Event Rewards
; Author ........: Moebius (02-2024)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: EventRewards()
; ===============================================================================================================================

Func EventRewards()

	If Not $g_bChkEventCollect Then Return

	ZoomOut()

	Local $Found = False
	Local $RewardFirst = False
	Local $Area[4] = [220, 45, 320, 110 + $g_iMidOffsetY]
	If $g_iTree = $eTreeMS Or $g_iTree = $eTreeEG Then
		$Area[0] = 250
		$Area[1] = 60 + $g_iMidOffsetY
		$Area[2] = 350
		$Area[3] = 155 + $g_iMidOffsetY
	EndIf
	For $i = 1 To 10
		If QuickMIS("BC1", $g_sImgEventResource, $Area[0], $Area[1], $Area[2], $Area[3]) Then
			$Found = True
			If StringInStr($g_iQuickMISName, "Event") Then
				SetLog("Collect Event Resource", $COLOR_SUCCESS)
				Click($g_iQuickMISX, $g_iQuickMISY + 20)
				; Just wait for Collect resource
				If _Sleep(Random(4000, 5000)) Then Return
			Else
				SetLog("Check Event Rewards", $COLOR_INFO)
				Click($g_iQuickMISX, $g_iQuickMISY + 22)
				$RewardFirst = True
				; Just wait Buttons appear
				If _Sleep(2500) Then Return
			EndIf
			ExitLoop
		EndIf
		If _Sleep(200) Then Return
	Next
	If Not $Found Then Return False
	If Not $g_bRunState Then Return

	If Not $RewardFirst Then
		$Found = False
		For $i = 1 To 10
			If QuickMIS("BC1", $g_sImgEventResource, $Area[0], $Area[1], $Area[2], $Area[3]) Then
				$Found = True
				SetLog("Check Event Rewards", $COLOR_INFO)
				Click($g_iQuickMISX, $g_iQuickMISY + 22)
				; Just wait Buttons appear
				If _Sleep(2500) Then Return
				ExitLoop
			EndIf
			If _Sleep(300) Then Return
		Next
		If Not $Found Then Return False
		If Not $g_bRunState Then Return
	EndIf

	Local $aEventButton = findButton("EventButton", Default, 1, True)
	If IsArray($aEventButton) And UBound($aEventButton, 1) = 2 Then
		Click($aEventButton[0], $aEventButton[1] - 20)
		If _Sleep(2500) Then Return
	Else
		SetLog("Cannot find Event Button!", $COLOR_ERROR)
		ClearScreen()
		Return False
	EndIf

	Local $aContinueButton = findButton("Continue", Default, 1, True)
	If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
		ClickP($aContinueButton)
		If _Sleep(2500) Then Return
	EndIf

	If Not $g_bRunState Then Return

	Local $aiButton
	Local $sImageDir = @ScriptDir & "\imgxml\Windows\CloseButton\*"
	Local $iMidPointX = Round($g_iGAME_WIDTH / 2)
	Local $iMidPointY = Round($g_iGAME_HEIGHT / 2)
	Local $iX1 = $iMidPointX
	Local $iX2 = $g_iGAME_WIDTH
	Local $iY1 = 0
	Local $iY2 = $iMidPointY
	Local $aSearchArea = $iX1 & "," & $iY1 & "|" & $iX2 & "," & $iY1 & "|" & $iX2 & "," & $iY2 & "|" & $iX1 & "," & $iY2

	$aiButton = decodeSingleCoord(findImage("CloseWindow", $sImageDir, $aSearchArea, 1, True))
	If IsArray($aiButton) And UBound($aiButton) >= 2 Then
		SetDebugLog("Event Window Opened", $COLOR_DEBUG)
	Else
		SetLog("Event Window not Found!", $COLOR_ERROR)
		ClearScreen()
		Return False
	EndIf

	CollectEventRewards()

	CloseEventWindow()
EndFunc   ;==>EventRewards

Func CollectEventRewards()

	SetLog("Collecting Event Rewards...")

	If _Sleep(Random(1000, 3000, 1)) Then Return
	If Not $g_bRunState Then Return

	Local $offColors[2][3] = [[0x0D0D0D, 31, 10], [0xFFFF7A, 35, 3]] ; 2nd pixel black Color, 3rd pixel yellow color
	Local $RightResResource = _MultiPixelSearch(759, 423, 810, 433, 1, 1, Hex(0xFFFFFF, 6), $offColors, 40) ; first white pixel on side of button
	SetDebugLog("Pixel Color #1: " & _GetPixelColor(763, 423, True) & ", #2: " & _GetPixelColor(794, 433, True) & ", #3: " & _GetPixelColor(798, 426, True), $COLOR_DEBUG)
	If Not IsArray($RightResResource) Then
		Click(790, 386 + $g_iMidOffsetY)
		If _Sleep(1500) Then Return
	EndIf

	Local $iClaim = 0, $iBonus = 0
	Local $IsOresPresent = 0
	Local $IsShinyPresent = 0
	Local $IsGlowyPresent = 0
	Local $IsStarryPresent = 0
	For $i = 0 To 14
		If Not $g_bRunState Then Return
		Local $SearchArea = GetDiamondFromRect("35,336(800,275)")
		Local $aResult = findMultiple(@ScriptDir & "\imgxml\DailyChallenge\", $SearchArea, $SearchArea, 0, 1000, 6, "objectname,objectpoints", True)
		If $aResult <> "" And IsArray($aResult) Then
			For $t = 0 To UBound($aResult) - 1
				Local $aResultArray = $aResult[$t] ; ["Button Name", "x1,y1", "x2,y2", ...]
				SetDebugLog("Find Claim buttons, $aResultArray[" & $t & "]: " & _ArrayToString($aResultArray))
				If IsArray($aResultArray) And $aResultArray[0] = "ClaimBtn" Then
					Local $sAllCoordsString = _ArrayToString($aResultArray, "|", 1) ; "x1,y1|x2,y2|..."
					Local $aAllCoords = decodeMultipleCoords($sAllCoordsString, 50, 50) ; [{coords1}, {coords2}, ...]
					For $j = 0 To UBound($aAllCoords) - 1
						If QuickMIS("BC1", $g_sImgOresCollect, ($aAllCoords[$j])[0] - 50, ($aAllCoords[$j])[1] - 90, ($aAllCoords[$j])[0] + 45, ($aAllCoords[$j])[1] - 20) Then
							Switch $g_iQuickMISName
								Case "Shiny"
									$IsShinyPresent = 1
								Case "Glowy"
									$IsGlowyPresent = 1
								Case "Starry"
									$IsStarryPresent = 1
							EndSwitch
							$IsOresPresent = 1
						EndIf
						ClickP($aAllCoords[$j], 1, 160, "Claim " & $j + 1) ; Click Claim button
						If WaitforPixel(329, 390 + $g_iMidOffsetY, 331, 392 + $g_iMidOffsetY, Hex(0xFDC875, 6), 20, 3) Then ; wait for Cancel Button popped up in 1.5 second
							If $g_bChkSellRewards Then
								Setlog("Selling extra reward for gems", $COLOR_SUCCESS)
								ClickP($aPersonalChallengeOkBtn, 1, 160, "Okay Btn") ; Click the Okay
								$iClaim += 1
							Else
								SetLog("Cancel. Not selling extra rewards.", $COLOR_SUCCESS)
								ClickP($aPersonalChallengeCancelBtn, 1, 160, "Cancel Btn") ; Click Claim button
							EndIf
							If _Sleep(1000) Then ExitLoop
						Else
							If _Sleep(Random(4000, 5000, 1)) Then ExitLoop
							$iClaim += 1
							If Not QuickMIS("BC1", $g_sImgOresCollect, ($aAllCoords[$j])[0] - 50, ($aAllCoords[$j])[1] - 90, ($aAllCoords[$j])[0] + 45, ($aAllCoords[$j])[1] - 20) And $IsOresPresent = 1 Then
								$IsOresJustCollected = 1
								If $IsShinyPresent Then
									SetLog("Shiny Ore Collected", $COLOR_SUCCESS1)
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Event : Shiny Ore Collected", 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Event : Shiny Ore Collected", 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Event : Shiny Ore Collected")
								ElseIf $IsGlowyPresent Then
									SetLog("Glowy Ore Collected", $COLOR_SUCCESS1)
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Event : Glowy Ore Collected", 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Event : Glowy Ore Collected", 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Event : Glowy Ore Collected")
								ElseIf $IsStarryPresent Then
									SetLog("Starry Ore Collected", $COLOR_SUCCESS1)
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Event : Starry Ore Collected", 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Event : Starry Ore Collected", 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Event : Starry Ore Collected")
								EndIf
							EndIf
							If _Sleep(100) Then ExitLoop
						EndIf
						$IsOresPresent = 0
						$IsShinyPresent = 0
						$IsGlowyPresent = 0
						$IsStarryPresent = 0
					Next
				EndIf
			Next
		EndIf

		Local $IsLeftRes = False
		If _ColorCheck(_GetPixelColor(45, 386 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 15) And _ColorCheck(_GetPixelColor(100, 386 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 15) Then $IsLeftRes = True

		If Not _CheckPixel($aEventLeftEdge, $g_bCapturePixel) And $IsLeftRes Then ; far left edge and progress bar at left.
			If $i = 0 Then SetLog("Dragging back for more... ") ; no end line
			SetLog($i + 1 & ".. ", Default, Default, Default, Default, Default, 0, False) ; no reward
			ClickDrag(120, 400 + $g_iMidOffsetY, 730, 400 + $g_iMidOffsetY, 1000)
			If _Sleep(Random(400, 600, 1)) Then ExitLoop
		Else
			If $i > 1 And _CheckPixel($aEventLeftEdge, $g_bCapturePixel) Then SetLog("EndLine.", Default, Default, Default, Default, Default, 0, Default) ; no reward + end line
			ExitLoop
		EndIf
	Next
	If _Sleep(500) Then Return
	Local $bLoop = 0
	While 1
		If Not _CheckPixel($aEventRightEdge, $g_bCapturePixel) Or $bLoop = 15 Then ExitLoop
		If QuickMIS("BC1", $g_sImgClaimBonus, 350, 335 + $g_iMidOffsetY, 590, 475 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			$iBonus += 1
			If _Sleep(1500) Then ExitLoop
		Else
			ExitLoop
		EndIf
		If _Sleep(500) Then ExitLoop
		$bLoop += 1
	WEnd
	Select
		Case $iClaim > 0 And $iBonus = 0
			SetLog("Claimed " & $iClaim & " reward" & ($iClaim > 1 ? "s" : "") & "!", $COLOR_SUCCESS)
		Case $iClaim = 0 And $iBonus > 0
			SetLog("Claimed " & $iBonus & " bonus" & ($iBonus > 1 ? "es" : "") & "!", $COLOR_SUCCESS)
		Case $iClaim > 0 And $iBonus > 0
			SetLog("Claimed " & $iClaim & " reward" & ($iClaim > 1 ? "s" : "") & " and " & $iBonus & " bonus" & ($iBonus > 1 ? "es" : "") & "!", $COLOR_SUCCESS)
		Case $iClaim = 0 And $iBonus = 0
			SetLog("Nothing to claim!", $COLOR_SUCCESS)
	EndSelect
	If _Sleep(500) Then Return
EndFunc   ;==>CollectEventRewards

Func CloseEventWindow()
	SetLog("Closing Event Window", $COLOR_INFO)

	CloseWindow()

	Local $counter = 0
	While Not IsMainPage(1) ; test for Personal Challenge Close Button
		SetDebugLog("Wait for Personal Challenge Window to close #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then ExitLoop
		$counter += 1
		If $counter > 40 Then ExitLoop
	WEnd

EndFunc   ;==>CloseEventWindow

