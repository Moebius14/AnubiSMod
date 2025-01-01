; #FUNCTION# ====================================================================================================================
; Name ..........: DailyChallenges()
; Description ...: Daily Challenges
; Author ........: TripleM (04/2019), Demen (07/2019)
; Modified ......: Moebius (04/2024)
; Remarks .......: This file is part of MyBot Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: DailyChallenges()
; ===============================================================================================================================

Func DailyChallenges($CCControl = True)
	checkMainScreen(False)
	Local $bGoldPass = _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) ; golden badge button at mainscreen

	; Check at least one pet upgrade is enabled
	Local $bUpgradePets = False
	For $i = 0 To $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then
			$bUpgradePets = True
		EndIf
	Next

	Local $bCheckDiscount = $bGoldPass And ($g_bUpgradeKingEnable Or $g_bUpgradeQueenEnable Or $g_bUpgradePrinceEnable Or $g_bUpgradeWardenEnable Or $g_bUpgradeChampionEnable Or $g_bAutoUpgradeWallsEnable Or $bUpgradePets)

	If Not $g_bChkCollectRewards And Not $bCheckDiscount Then Return

	SetLog("Check Personnal Challenges", $COLOR_INFO)
	If $bGoldPass Then SetLog("Gold Pass Detected", $COLOR_SUCCESS1)

	If OpenPersonalChallenges() Then
		CollectDailyRewards($bGoldPass)
		If $bCheckDiscount Then CheckDiscountPerks()

		If _Sleep(1000) Then Return
		ClosePersonalChallenges()
		Sleep(Random(2000, 3000, 1))
	Else
		If $bGoldPass And Not $g_bFirstStartCheckDone Then
			If $bCheckDiscount Then CheckDiscountPerksMod()
		EndIf
	EndIf

	If ($g_bUseBOF And $IsBOFJustCollected) Or ($g_bUseBOS And $IsBOSJustCollected) Or ($g_bUseLabPotion And $IsResPotJustCollected) Then
		Local $BookTypes[3][2] = [[$IsBOFJustCollected, "Book Of Fighting"], [$IsBOSJustCollected, "Book Of Spells"], [$IsResPotJustCollected, "Research Potion"]]
		For $i = 0 To UBound($BookTypes) - 1
			If $BookTypes[$i][0] Then SetLog("Time To Check Laboratory, " & $BookTypes[$i][1] & " Just Collected", $COLOR_OLIVE)
		Next
		If _Sleep(500) Then Return
		LabGuiDisplay()
	EndIf

	If $g_bUsePetPotion And $IsPetPotJustCollected Then
		SetLog("Time To Check Pet House, Pet Potion Just Collected", $COLOR_OLIVE)
		If _Sleep(500) Then Return
		PetGuiDisplay()
	EndIf

	If Not $IsToCheckBeforeStop And $CCControl Then
		If SwitchBetweenBasesMod2() Then
			ForgeClanCapitalGold()
			_Sleep($DELAYRUNBOT3)
			AutoUpgradeCC()
			_Sleep($DELAYRUNBOT3)
		EndIf
	EndIf
EndFunc   ;==>DailyChallenges

Func OpenPersonalChallenges()
	If _CheckPixel($aPersonalChallengeOpenButton3, $g_bCapturePixel) Then
		$ActionForModLog = "Check Personnal Challenges - Something Detected"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] " & $ActionForModLog, 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] " & $ActionForModLog, 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] " & $ActionForModLog)
		SetLog("Something Detected In Personal Challenges !", $COLOR_BLUE)
		SetLog("Opening...", $COLOR_INFO)
		ClearScreen()
		If _Sleep($DELAYRUNBOT1) Then Return
		Local $bRet = False
		For $i = 0 To 9
			If _CheckPixel($aPersonalChallengeOpenButton1, $g_bCapturePixel) Then
				ClickP($aPersonalChallengeOpenButton1, 1, 120, "#0666")
				$bRet = True
				ExitLoop
			ElseIf _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
				ClickP($aPersonalChallengeOpenButton2, 1, 120, "#0666")
				$bRet = True
				ExitLoop
			EndIf
			If _Sleep(200) Then Return
		Next
		If $bRet = False Then
			SetLog("Can't find button", $COLOR_ERROR)
			ClearScreen()
			Return False
		EndIf

		If _Sleep(Random(2000, 4000, 1)) Then Return

		Local $xMarge = Random(0, 6, 1)
		If _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) Then
			If Random(0, 2, 1) > 1 Then
				Click(545 + ($xMarge * 10), 120) ; Perks
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
			If Random(0, 2, 1) > 1 Then
				Click(710 + ($xMarge * 10), 120) ; Bank
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
		Else
			Click(385 + ($xMarge * 10), 120) ; Rewards
			If _Sleep(Random(2000, 4000, 1)) Then Return
			If Random(0, 2, 1) > 1 Then
				Click(545 + ($xMarge * 10), 120) ; Perks
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
			If Random(0, 2, 1) > 1 Then
				Click(710 + ($xMarge * 10), 120) ; Bank
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
		EndIf

		If Not _ColorCheck(_GetPixelColor(185, 135, True), "A8D0EC", 20) Then
			Click(220 + ($xMarge * 10), 120)
		EndIf
		If _Sleep(Random(2000, 3000, 1)) Then Return

		Local $counter = 0
		While Not _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) ; test for Personal Challenge Close Button
			SetDebugLog("Wait for Personal Challenge Close Button to appear #" & $counter)
			If _Sleep($DELAYRUNBOT6) Then Return
			$counter += 1
			If $counter > 40 Then Return False
		WEnd
		Return True
	Else
		SetLog("Nothing In Personal Challenges", $COLOR_BLUE)
		If $g_iCmbPriorityPersoChallengesFrequency > 0 Then
			$ActionForModLog = "Check Personnal Challenges - Nothing Detected"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] " & $ActionForModLog)
		EndIf
		Return False
	EndIf
EndFunc   ;==>OpenPersonalChallenges

Func CollectDailyRewards($bGoldPass = False)

	If Not $g_bChkCollectRewards Or Not _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) Then Return ; no red badge on rewards tab

	SetLog("Collecting Daily Rewards...")

	ClickP($aPersonalChallengeRewardsTab, 1, 120, "Rewards tab") ; Click Rewards tab
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If Not $g_bRunState Then Return

	Local $IsWhiteAtRight = _ColorCheck(_GetPixelColor(773, 386 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 15) And _ColorCheck(_GetPixelColor(827, 386 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 15)
	Local $aMiniCupButton = decodeSingleCoord(FindImageInPlace2("MiniCupButton", $ImgMiniCupButton, 765, 355 + $g_iMidOffsetY, 830, 415 + $g_iMidOffsetY, True))
	If UBound($aMiniCupButton) < 2 And $IsWhiteAtRight Then
		Click(797, 386 + $g_iMidOffsetY)
		If _Sleep(1500) Then Return
	EndIf

	Local $iClaim = 0
	;	Local $IsCCGoldPresent = 0
	;	Local $IsBOFPresent = 0
	;	Local $IsBOSPresent = 0
	;	Local $IsResPotPresent = 0
	;	Local $IsPetPotPresent = 0
	;	Local $IsAutoForgeSlotPresent = 0
	Local $sAllCoordsString, $aAllCoordsTemp, $aTempCoords
	Local $aAllCoords[0][2]
	Local $aAllCoordsBackup[0][2]

	For $i = 0 To 15
		If Not $g_bRunState Then Return
		Local $SearchArea = $bGoldPass ? GetDiamondFromRect("25,336(810,270)") : GetDiamondFromRect("25,550(810,60)")
		Local $aResult = findMultiple(@ScriptDir & "\imgxml\DailyChallenge\", $SearchArea, $SearchArea, 0, 1000, $bGoldPass ? 12 : 6, "objectname,objectpoints", True)
		If $aResult <> "" And IsArray($aResult) Then
			If $i > 0 Then $aAllCoords = $aAllCoordsBackup ; Empty Array
			For $t = 0 To UBound($aResult) - 1
				Local $aResultArray = $aResult[$t] ; ["Button Name", "x1,y1", "x2,y2", ...]
				SetDebugLog("Find Claim buttons, $aResultArray[" & $t & "]: " & _ArrayToString($aResultArray))
				If IsArray($aResultArray) And $aResultArray[0] = "ClaimBtn" Then
					$sAllCoordsString = _ArrayToString($aResultArray, "|", 1) ; "x1,y1|x2,y2|..."
					$aAllCoordsTemp = decodeMultipleCoords($sAllCoordsString, 50, 50) ; [{coords1}, {coords2}, ...]
					For $k = 0 To UBound($aAllCoordsTemp, 1) - 1
						$aTempCoords = $aAllCoordsTemp[$k]
						_ArrayAdd($aAllCoords, Number($aTempCoords[0]) & "|" & Number($aTempCoords[1]))
					Next
				EndIf
			Next
			RemoveDupXY($aAllCoords)
			_ArraySort($aAllCoords, 1, 0, 0, 0) ;sort by x from right to left
			Local $RewardTypes[6][3] = [[$g_sImgCCGoldCollectDaily, False, "Clan Capital Gold Collected"], _
					[$g_sImgBOFCollectDaily, False, "Book Of Fighting Collected"], _
					[$g_sImgBOSCollectDaily, False, "Book Of Spells Collected"], _
					[$g_sImgResPotCollectDaily, False, "Research Potion Collected"], _
					[$g_sImgPetPotCollectDaily, False, "Pet Potion Collected"], _
					[$g_sImgAutoForgeSlotDaily, False, "AutoForge Slot Collected"]]

			For $j = 0 To UBound($aAllCoords) - 1
				For $z = 0 To UBound($RewardTypes) - 1
					If QuickMIS("BC1", $RewardTypes[$z][0], $aAllCoords[$j][0] - 50, $aAllCoords[$j][1] - 90, $aAllCoords[$j][0] + 45, $aAllCoords[$j][1] - 20) Then $RewardTypes[$z][1] = True
				Next
				Click($aAllCoords[$j][0], $aAllCoords[$j][1], 1, 120, "Claim " & $j + 1)         ; Click Claim button
				If WaitforPixel(329, 390 + $g_iMidOffsetY, 331, 392 + $g_iMidOffsetY, Hex(0xFFC877, 6), 20, 3) Then         ; wait for Cancel Button popped up in 1.5 second
					If $g_bChkSellRewards Then
						SetLog("Selling extra reward for gems", $COLOR_SUCCESS)
						ClickP($aPersonalChallengeOkBtn, 1, 120, "Okay Btn")         ; Click the Okay
						$iClaim += 1
					Else
						SetLog("Cancel. Not selling extra rewards.", $COLOR_SUCCESS)
						ClickP($aPersonalChallengeCancelBtn, 1, 120, "Cancel Btn")         ; Click Claim button
					EndIf
					If _Sleep(1000) Then ExitLoop
				Else
					If _Sleep(Random(500, 1000, 1)) Then ExitLoop
					$iClaim += 1
					For $z = 0 To UBound($RewardTypes) - 1
						If $RewardTypes[$z][1] Then
							Switch $z
								Case 0
									$IsCCGoldJustCollected = 1
									$IsCCGoldJustCollectedDChallenge = 1
								Case 1
									$IsBOFJustCollected = 1
								Case 2
									$IsBOSJustCollected = 1
								Case 3
									$IsResPotJustCollected = 1
								Case 4
									$IsPetPotJustCollected = 1
								Case 5
									$IsAutoForgeSlotJustCollected = 1
							EndSwitch
							SetLog($RewardTypes[$z][2], $COLOR_SUCCESS1)
							If $g_iTxtCurrentVillageName <> "" Then
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] " & $RewardTypes[$z][2], 1)
							Else
								GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] " & $RewardTypes[$z][2], 1)
							EndIf
							_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] " & $RewardTypes[$z][2])
							ExitLoop
						EndIf
					Next
					If _Sleep(100) Then ExitLoop
				EndIf
				;Reset local variables
				For $z = 0 To UBound($RewardTypes) - 1
					$RewardTypes[$z][1] = False
				Next
			Next
		EndIf
		If _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) And Not _CheckPixel($aPersonalChallengeLeftEdge, $g_bCapturePixel) Then ; far left edge
			If $i = 0 Then SetLog("Dragging back for more... ") ; no end line
			SetLog($i + 1 & ".. ", Default, Default, Default, Default, Default, 0, False) ; no reward
			ClickDrag(120, 400 + $g_iMidOffsetY, 740, 400 + $g_iMidOffsetY, 1000)
			If _Sleep(Random(400, 600, 1)) Then ExitLoop
		Else
			If $i > 1 Then SetLog("EndLine.", Default, Default, Default, Default, Default, 0, Default) ; no reward + end line
			ExitLoop
		EndIf
	Next
	If $iClaim > 0 Then
		SetLog("Claimed " & $iClaim & " reward" & ($iClaim > 1 ? "s" : "") & "!", $COLOR_SUCCESS)
	Else
		SetLog("Nothing to claim!", $COLOR_SUCCESS)
	EndIf
	If _Sleep(500) Then Return
EndFunc   ;==>CollectDailyRewards

Func CheckDiscountPerks()
	SetLog("Checking for builder boost...")
	If $g_bFirstStart Then $g_iBuilderBoostDiscount = 0

	ClickP($aPersonalChallengePerksTab, 1, 120, "PerksTab")

	If Not WaitforPixel($aPersonalChallengePerksTab[0] - 1, $aPersonalChallengePerksTab[1] - 1, $aPersonalChallengePerksTab[0] + 1, $aPersonalChallengePerksTab[1] + 1, _
			Hex($aPersonalChallengePerksTab[2], 6), $aPersonalChallengePerksTab[3], 2) Then Return        ; wait for Perks Tab completely loaded in 1 second

	If _Sleep(500) Then Return

	; find builder boost rate %
	Local $sDiscount = getOcrAndCapture("coc-builderboost", 110, 277 + $g_iMidOffsetY, 100, 40, True)
	SetDebugLog("Builder boost OCR: " & $sDiscount)
	If StringInStr($sDiscount, "%") Then
		Local $aDiscount = StringSplit($sDiscount, "%", $STR_NOCOUNT)
		$g_iBuilderBoostDiscount = Number($aDiscount[0])
		SetLog($g_iBuilderBoostDiscount > 0 ? "Current Builder boost: " & $g_iBuilderBoostDiscount & "%" : "Keep working hard on challenges", $COLOR_SUCCESS)
		cmbWalls()
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	Else
		SetLog("Cannot read builder boost", $COLOR_ERROR)
	EndIf
EndFunc   ;==>CheckDiscountPerks

Func ClosePersonalChallenges()
	SetLog("Closing personal challenges", $COLOR_INFO)

	CloseWindow()

	Local $counter = 0
	While Not IsMainPage(1) ; test for Personal Challenge Close Button
		SetDebugLog("Wait for Personal Challenge Window to close #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then ExitLoop
		$counter += 1
		If $counter > 40 Then ExitLoop
	WEnd

EndFunc   ;==>ClosePersonalChallenges

Func CheckDiscountPerksMod()
	SetLog("Checking for builder boost...")

	If _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then ClickP($aPersonalChallengeOpenButton2, 1, 120, "#0666")

	If _Sleep(2500) Then Return

	If $g_bFirstStart Then $g_iBuilderBoostDiscount = 0

	ClickP($aPersonalChallengePerksTab, 1, 120, "PerksTab")

	If Not WaitforPixel($aPersonalChallengePerksTab[0] - 1, $aPersonalChallengePerksTab[1] - 1, $aPersonalChallengePerksTab[0] + 1, $aPersonalChallengePerksTab[1] + 1, _
			Hex($aPersonalChallengePerksTab[2], 6), $aPersonalChallengePerksTab[3], 2) Then Return        ; wait for Perks Tab completely loaded in 1 second

	If _Sleep(500) Then Return

	; find builder boost rate %
	Local $sDiscount = getOcrAndCapture("coc-builderboost", 110, 277 + $g_iMidOffsetY, 100, 40, True)
	SetDebugLog("Builder boost OCR: " & $sDiscount)
	If StringInStr($sDiscount, "%") Then
		Local $aDiscount = StringSplit($sDiscount, "%", $STR_NOCOUNT)
		$g_iBuilderBoostDiscount = Number($aDiscount[0])
		SetLog($g_iBuilderBoostDiscount > 0 ? "Current Builder boost: " & $g_iBuilderBoostDiscount & "%" : "Keep working hard on challenges", $COLOR_SUCCESS)
		cmbWalls()
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
	Else
		SetLog("Cannot read builder boost", $COLOR_ERROR)
	EndIf

	If _Sleep(1000) Then Return

	ClosePersonalChallenges()
EndFunc   ;==>CheckDiscountPerksMod
