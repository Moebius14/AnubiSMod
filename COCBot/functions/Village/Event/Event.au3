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
	Local $Area[4] = [220, 55, 320, 110 + $g_iMidOffsetY]
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

	Local $offColors[3][3] = [[0xFFFFFF, 2, 0], [0x0D0D0D, 17, 16], [0x0D0D0D, 34, 0]] ; 2nd pixel white Color at Left, 3rd pixel Black Bottom color, 4th pixel black at right
	Local $RightResResource = _MultiPixelSearch(770, 418, 780, 420, 1, 1, Hex(0x0D0D0D, 6), $offColors, 40) ; first black pixel on side of button
	SetDebugLog("Pixel Color #1: " & _GetPixelColor(773, 418, True) & ", #2: " & _GetPixelColor(775, 418, True) & ", #3: " & _GetPixelColor(790, 434, True) & ", #4: " & _GetPixelColor(807, 418, True), $COLOR_DEBUG)
	If IsArray($RightResResource) Then
		Click(790, 385 + $g_iMidOffsetY)
		If _Sleep(1500) Then Return
	EndIf

	Local $iClaim = 0
	Local $IsOresPresent = 0
	Local $IsShinyPresent = 0
	Local $IsGlowyPresent = 0
	Local $IsStarryPresent = 0
	For $i = 0 To 14
		If Not $g_bRunState Then Return
		Local $SearchArea = GetDiamondFromRect("35,336(800,270)")
		Local $aResult = findMultiple(@ScriptDir & "\imgxml\DailyChallenge\", $SearchArea, $SearchArea, 0, 1000, 6, "objectname,objectpoints", True)
		If $aResult <> "" And IsArray($aResult) Then
			For $i = 0 To UBound($aResult) - 1
				Local $aResultArray = $aResult[$i] ; ["Button Name", "x1,y1", "x2,y2", ...]
				SetDebugLog("Find Claim buttons, $aResultArray[" & $i & "]: " & _ArrayToString($aResultArray))
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
						ClickP($aAllCoords[$j], 1, 0, "Claim " & $j + 1) ; Click Claim button
						If WaitforPixel(329, 390 + $g_iMidOffsetY, 331, 392 + $g_iMidOffsetY, Hex(0xFDC875, 6), 20, 3) Then ; wait for Cancel Button popped up in 1.5 second
							If $g_bChkSellRewards Then
								Setlog("Selling extra reward for gems", $COLOR_SUCCESS)
								ClickP($aPersonalChallengeOkBtn, 1, 0, "Okay Btn") ; Click the Okay
								$iClaim += 1
							Else
								SetLog("Cancel. Not selling extra rewards.", $COLOR_SUCCESS)
								ClickP($aPersonalChallengeCancelBtn, 1, 0, "Cancel Btn") ; Click Claim button
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
		Local $IsLeftBall = False
		Local $offColors[3][3] = [[0xFFFFFF, 2, 0], [0x0D0D0D, 17, 16], [0x0D0D0D, 34, 0]] ; 2nd pixel white Color at Left, 3rd pixel Black Bottom color, 4th pixel black at right
		Local $LeftBall = _MultiPixelSearch(55, 418, 65, 420, 1, 1, Hex(0x0D0D0D, 6), $offColors, 40) ; first black pixel on side of button
		SetDebugLog("Pixel Color #1: " & _GetPixelColor(58, 418, True) & ", #2: " & _GetPixelColor(60, 418, True) & ", #3: " & _GetPixelColor(75, 434, True) & ", #4: " & _GetPixelColor(92, 418, True), $COLOR_DEBUG)
		If IsArray($LeftBall) Then $IsLeftBall = True

		If Not _CheckPixel($aEventLeftEdge, $g_bCapturePixel) And $IsLeftBall Then ; far left edge And no reward at left.
			If $i = 0 Then
				SetLog("Dragging back for more... ", Default, Default, Default, Default, Default, Default, False) ; no end line
			Else
				SetLog($i & ".. ", Default, Default, Default, Default, Default, 0, $i < 13 ? False : Default) ; no time
			EndIf
			ClickDrag(120, 400 + $g_iMidOffsetY, 730, 400 + $g_iMidOffsetY, 1000)
			If _Sleep(500) Then ExitLoop
		Else
			If $i > 0 Then SetLog($i & ".", Default, Default, Default, Default, Default, False) ; no time + end line
			ExitLoop
		EndIf
	Next
	SetLog($iClaim > 0 ? "Claimed " & $iClaim & " reward(s)!" : "Nothing to claim!", $COLOR_SUCCESS)
	If _Sleep(500) Then Return
	Local $bLoop = 0
	While 1
		If Not _CheckPixel($aEventRightEdge, $g_bCapturePixel) Or $bLoop = 15 Then ExitLoop
		If QuickMIS("BC1", $g_sImgClaimBonus, 350, 335 + $g_iMidOffsetY, 590, 475 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			SetLog("Bonus Collected", $COLOR_SUCCESS1)
			If _Sleep(1500) Then ExitLoop
		Else
			ExitLoop
		EndIf
		If _Sleep(500) Then ExitLoop
		$bLoop += 1
	WEnd
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
