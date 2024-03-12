; #FUNCTION# ====================================================================================================================
; Name ..........: DailyChallenges()
; Description ...: Daily Challenges
; Author ........: TripleM (04/2019), Demen (07/2019)
; Modified ......: Moebius (06/2023)
; Remarks .......: This file is part of MyBot Copyright 2015-2024
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

	Local $bCheckDiscount = $bGoldPass And ($g_bUpgradeKingEnable Or $g_bUpgradeQueenEnable Or $g_bUpgradeWardenEnable Or $g_bUpgradeChampionEnable Or $g_bAutoUpgradeWallsEnable Or $bUpgradePets)

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
		If $bGoldPass And Not $g_bFirstStartForAll Then
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
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Avanced : " & $ActionForModLog & "", 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Avanced : " & $ActionForModLog & "", 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Advanced : " & $ActionForModLog & "")
		SetLog("Something Detected In Personal Challenges !", $COLOR_BLUE)
		SetLog("Opening...", $COLOR_INFO)
		ClickAway()
		If _Sleep($DELAYRUNBOT1) Then Return
		Local $bRet = False
		For $i = 0 To 9
			If _CheckPixel($aPersonalChallengeOpenButton1, $g_bCapturePixel) Then
				ClickP($aPersonalChallengeOpenButton1, 1, 0, "#0666")
				$bRet = True
				ExitLoop
			ElseIf _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then
				ClickP($aPersonalChallengeOpenButton2, 1, 0, "#0666")
				$bRet = True
				ExitLoop
			EndIf
			If _Sleep(200) Then Return
		Next
		If $bRet = False Then
			SetLog("Can't find button", $COLOR_ERROR)
			ClickAway()
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
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Avanced : " & $ActionForModLog & "", 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Avanced : " & $ActionForModLog & "", 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Advanced : " & $ActionForModLog & "")
		EndIf
		Return False
	EndIf
EndFunc   ;==>OpenPersonalChallenges

Func CollectDailyRewards($bGoldPass = False)

	If Not $g_bChkCollectRewards Or Not _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) Then Return ; no red badge on rewards tab

	SetLog("Collecting Daily Rewards...")

	ClickP($aPersonalChallengeRewardsTab, 1, 0, "Rewards tab") ; Click Rewards tab
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If Not $g_bRunState Then Return

	If QuickMIS("BC1", $g_sImgGreenButton, 770, 360 + $g_iMidOffsetY, 820, 410 + $g_iMidOffsetY) Then
		Click($g_iQuickMISX - 8, $g_iQuickMISY + 7)
		If _Sleep(1500) Then Return
	EndIf

	Local $iClaim = 0
	Local $IsCCGoldPresent = 0
	Local $IsBOFPresent = 0
	Local $IsBOSPresent = 0
	Local $IsResPotPresent = 0
	Local $IsPetPotPresent = 0
	Local $IsAutoForgeSlotPresent = 0
	For $i = 0 To 14
		If Not $g_bRunState Then Return
		Local $SearchArea = $bGoldPass ? GetDiamondFromRect("25,336(810,270)") : GetDiamondFromRect("25,550(810,60)")
		Local $aResult = findMultiple(@ScriptDir & "\imgxml\DailyChallenge\", $SearchArea, $SearchArea, 0, 1000, $bGoldPass ? 5 : 2, "objectname,objectpoints", True)
		If $aResult <> "" And IsArray($aResult) Then
			For $i = 0 To UBound($aResult) - 1
				Local $aResultArray = $aResult[$i] ; ["Button Name", "x1,y1", "x2,y2", ...]
				SetDebugLog("Find Claim buttons, $aResultArray[" & $i & "]: " & _ArrayToString($aResultArray))

				If IsArray($aResultArray) And $aResultArray[0] = "ClaimBtn" Then
					Local $sAllCoordsString = _ArrayToString($aResultArray, "|", 1) ; "x1,y1|x2,y2|..."
					Local $aAllCoords = decodeMultipleCoords($sAllCoordsString, 50, 50) ; [{coords1}, {coords2}, ...]
					Local $RewardImagesTypes[6][2] = [[$g_sImgCCGoldCollectDaily, $IsCCGoldPresent], _
							[$g_sImgBOFCollectDaily, $IsBOFPresent], _
							[$g_sImgBOSCollectDaily, $IsBOSPresent], _
							[$g_sImgResPotCollectDaily, $IsResPotPresent], _
							[$g_sImgPetPotCollectDaily, $IsPetPotPresent], _
							[$g_sImgAutoForgeSlotDaily, $IsAutoForgeSlotPresent]]

					For $j = 0 To UBound($aAllCoords) - 1
						For $z = 0 To UBound($RewardImagesTypes) - 1
							If QuickMIS("BC1", $RewardImagesTypes[$z][0], ($aAllCoords[$j])[0] - 50, ($aAllCoords[$j])[1] - 90, ($aAllCoords[$j])[0] + 45, ($aAllCoords[$j])[1] - 20) Then $RewardImagesTypes[$z][1] = 1
						Next
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
							If _Sleep(Random(3000, 4000, 1)) Then ExitLoop
							$iClaim += 1
							For $z = 0 To UBound($RewardImagesTypes) - 1
								If Not QuickMIS("BC1", $RewardImagesTypes[$z][0], ($aAllCoords[$j])[0] - 50, ($aAllCoords[$j])[1] - 90, ($aAllCoords[$j])[0] + 45, ($aAllCoords[$j])[1] - 20) And $RewardImagesTypes[$z][1] = 1 Then
									Switch $z
										Case 0
											$IsCCGoldJustCollected = 1
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
								EndIf
							Next

							Local $RewardTypes[6][2] = [[$IsCCGoldJustCollected, "Clan Capital Gold Collected"], _
									[$IsBOFJustCollected, "Book Of Fighting Collected"], _
									[$IsBOSJustCollected, "Book Of Spells Collected"], _
									[$IsResPotJustCollected, "Research Potion Collected"], _
									[$IsPetPotJustCollected, "Pet Potion Collected"], _
									[$IsAutoForgeSlotJustCollected, "AutoForge Slot Collected"]]

							For $z = 0 To UBound($RewardTypes) - 1
								If $z = 0 Then $IsCCGoldJustCollectedDChallenge = $RewardTypes[$z][0]
								If $RewardTypes[$z][0] = 1 Then
									SetLog($RewardTypes[$z][1], $COLOR_SUCCESS1)
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Avanced : " & $RewardTypes[$z][1] & "", 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Avanced : " & $RewardTypes[$z][1] & "", 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Advanced : " & $RewardTypes[$z][1] & "")
								EndIf
							Next
							If _Sleep(100) Then ExitLoop
						EndIf
						$IsCCGoldPresent = 0
						$IsBOFPresent = 0
						$IsBOSPresent = 0
						$IsResPotPresent = 0
						$IsPetPotPresent = 0
						$IsAutoForgeSlotPresent = 0
					Next
				EndIf
			Next
		EndIf
		If _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) And Not _CheckPixel($aPersonalChallengeLeftEdge, $g_bCapturePixel) Then ; far left edge
			If $i = 0 Then
				SetLog("Dragging back for more... ", Default, Default, Default, Default, Default, Default, False) ; no end line
			Else
				SetLog($i & ".. ", Default, Default, Default, Default, Default, 0, $i < 13 ? False : Default) ; no time
			EndIf
			ClickDrag(120, 400 + $g_iMidOffsetY, 740, 400 + $g_iMidOffsetY, 1000) ;x1 was 50. x2 was 810  Change for Dec '20 update
			If _Sleep(500) Then ExitLoop
		Else
			If $i > 0 Then SetLog($i & ".", Default, Default, Default, Default, Default, False) ; no time + end line
			ExitLoop
		EndIf
	Next
	SetLog($iClaim > 0 ? "Claimed " & $iClaim & " reward(s)!" : "Nothing to claim!", $COLOR_SUCCESS)
	If _Sleep(500) Then Return
EndFunc   ;==>CollectDailyRewards

Func CheckDiscountPerks()
	SetLog("Checking for builder boost...")
	If $g_bFirstStart Then $g_iBuilderBoostDiscount = 0

	ClickP($aPersonalChallengePerksTab, 1, 0, "PerksTab")

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

	If _CheckPixel($aPersonalChallengeOpenButton2, $g_bCapturePixel) Then ClickP($aPersonalChallengeOpenButton2, 1, 0, "#0666")

	If _Sleep(2500) Then Return

	If $g_bFirstStart Then $g_iBuilderBoostDiscount = 0

	ClickP($aPersonalChallengePerksTab, 1, 0, "PerksTab")

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
	Else
		SetLog("Cannot read builder boost", $COLOR_ERROR)
	EndIf

	If _Sleep(1000) Then Return

	ClosePersonalChallenges()
EndFunc   ;==>CheckDiscountPerksMod
