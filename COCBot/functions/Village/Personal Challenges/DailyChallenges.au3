; #FUNCTION# ====================================================================================================================
; Name ..........: DailyChallenges()
; Description ...: Daily Challenges
; Author ........: TripleM (04/2019), Demen (07/2019)
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015-2019
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
	For $i = 0 to $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then
			$bUpgradePets = True
		EndIf
	Next
	
	Local $bCheckDiscount = $bGoldPass And ($g_bUpgradeKingEnable Or $g_bUpgradeQueenEnable Or $g_bUpgradeWardenEnable Or $g_bUpgradeChampionEnable Or $g_bAutoUpgradeWallsEnable Or $bUpgradePets)

	If Not $g_bChkCollectRewards And Not $bCheckDiscount Then Return
	
	If Not $g_bFirstStartAccountDC Then
	$IsToCheckdiff[$g_iCurAccount] = False
	$asLastTimeCheckedforChallenges[$g_iCurAccount] = 0
	$DelayPersoChallengesMn[$g_iCurAccount] = 0
	$g_bFirstStartAccountDC = 1
	EndIf
	
	If $IsToCheckdiff[$g_iCurAccount] And Not $IsToCheckBeforeStop And $g_iCmbPriorityPersoChallengesFrequency > 0 Then
		Local $iLastCheckdiff = TimerDiff($asLastTimeCheckedforChallenges[$g_iCurAccount])
		Local $iLastCheck = Round($iLastCheckdiff / 1000 / 60) ; Minutes
		
		If $iLastCheck <= $DelayPersoChallengesMn[$g_iCurAccount] Then
			Local $iWaitTime = ($DelayPersoChallengesMn[$g_iCurAccount] - $iLastCheck) * 60 * 1000 ; ms
			Local $sWaitTime = ""
			Local $iMin, $iHour, $iWaitSec
	
			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			If $iWaitSec <= 60 Then $sWaitTime = "Imminent"
		SetLog("Next Personnal Challenges Check : " & $sWaitTime & "", $COLOR_OLIVE)
		Return ; If random time is >= to $iLastCheck then return
		EndIf
	EndIf

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
	If Not $IsToCheckBeforeStop And $CCControl Then
		If SwitchBetweenBasesMod2() Then
			_Sleep(Random(2000, 3000, 1))
			AutoUpgradeCC()
			_Sleep($DELAYRUNBOT3)
		EndIf
	EndIf
EndFunc   ;==>DailyChallenges

Func OpenPersonalChallenges()
$g_iCmbPriorityPersoChallengesFrequency = _GUICtrlComboBox_GetCurSel($g_hCmbPriorityPersoChallengesFrequency) * 60 ; minutes
$g_icmbAdvancedVariation[2] = _GUICtrlComboBox_GetCurSel($g_hcmbAdvancedVariation[2]) / 10
Local $DelayPersoChallengesInf = ($g_iCmbPriorityPersoChallengesFrequency - ($g_iCmbPriorityPersoChallengesFrequency * $g_icmbAdvancedVariation[2]))
Local $DelayPersoChallengesSup = ($g_iCmbPriorityPersoChallengesFrequency + ($g_iCmbPriorityPersoChallengesFrequency * $g_icmbAdvancedVariation[2]))
$DelayPersoChallengesMn[$g_iCurAccount] = Random($DelayPersoChallengesInf, $DelayPersoChallengesSup, 1)
Local $DelayReturnedtocheckPersoChallengesMS = $DelayPersoChallengesMn[$g_iCurAccount] * 60 * 1000
Local $iWaitTime = $DelayReturnedtocheckPersoChallengesMS
Local $sWaitTime = ""
Local $iMin, $iHour, $iWaitSec
$iWaitSec = Round($iWaitTime / 1000)
$iHour = Floor(Floor($iWaitSec / 60) / 60)
$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
$asLastTimeCheckedforChallenges[$g_iCurAccount] = TimerInit()
$IsToCheckdiff[$g_iCurAccount] = True

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
	
	sleep(random(2000, 4000, 1))
	
	Local $xMarge = Random(0, 6, 1)
	If _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) Then
		If Random(0, 2, 1) > 1 Then Click(660 + ($xMarge * 10), 75) ; Perks
		sleep(random(2000, 4000, 1))
	Else
		Click(450 + ($xMarge * 10), 75) ; Rewards
		sleep(random(2000, 4000, 1))
		If Random(0, 2, 1) > 1 Then Click(660 + ($xMarge * 10), 75) ; Perks
		sleep(random(2000, 4000, 1))
	EndIf
	
	If Not _ColorCheck(_GetPixelColor(185, 70, True), "C5DBE5", 20) Or Not _ColorCheck(_GetPixelColor(250, 90, True), "A8D0EC", 20) Then
		Click(250 + ($xMarge * 10), 75)
	EndIf
	sleep(random(2000, 4000, 1))
	
    Local $counter = 0
	While Not _CheckPixel($aPersonalChallengeCloseButton, $g_bCapturePixel) ; test for Personal Challenge Close Button
		SetDebugLog("Wait for Personal Challenge Close Button to appear #" & $counter)
		If _Sleep($DELAYRUNBOT6) Then Return
		$counter += 1
		If $counter > 40 Then Return False
	WEnd
	If $IsToCheckBeforeStop = False And $g_iCmbPriorityPersoChallengesFrequency > 0 Then SetLog("Next Personnal Challenges Check : " & $sWaitTime & "", $COLOR_OLIVE)
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
	If $IsToCheckBeforeStop = False And $g_iCmbPriorityPersoChallengesFrequency > 0 Then SetLog("Next Personnal Challenges Check : " & $sWaitTime & "", $COLOR_OLIVE)
	Return False
EndIf
EndFunc   ;==>OpenPersonalChallenges

Func CollectDailyRewards($bGoldPass = False)

	If Not $g_bChkCollectRewards Or Not _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) Then Return ; no red badge on rewards tab

	SetLog("Collecting Daily Rewards...")

	ClickP($aPersonalChallengeRewardsTab, 1, 0, "Rewards tab") ; Click Rewards tab
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If Not $g_bRunState Then Return
	
	If QuickMIS("BC1", $g_sImgGreenButton, 790, 360 + $g_iMidOffsetY, 820, 395 + $g_iMidOffsetY) Then
		Click($g_iQuickMISX - 8, $g_iQuickMISY + 7)
		If _Sleep(1500) Then Return
	EndIf
	
	Local $iClaim = 0
	Local $IsCCGoldPresent = 0
	Local $IsBOFPresent = 0
	Local $IsBOSPresent = 0
	Local $IsResPotPresent = 0
	For $i = 0 To 10
		If Not $g_bRunState Then Return
		Local $SearchArea = $bGoldPass ? GetDiamondFromRect("25,336(810,240)") : GetDiamondFromRect("25,535(810,35)")
		Local $aResult = findMultiple(@ScriptDir & "\imgxml\DailyChallenge\", $SearchArea, $SearchArea, 0, 1000, $bGoldPass ? 5 : 2, "objectname,objectpoints", True)
		If $aResult <> "" And IsArray($aResult) Then
			For $i = 0 To UBound($aResult) - 1
				Local $aResultArray = $aResult[$i] ; ["Button Name", "x1,y1", "x2,y2", ...]
				SetDebugLog("Find Claim buttons, $aResultArray[" & $i & "]: " & _ArrayToString($aResultArray))

				If IsArray($aResultArray) And $aResultArray[0] = "ClaimBtn" Then
					Local $sAllCoordsString = _ArrayToString($aResultArray, "|", 1) ; "x1,y1|x2,y2|..."
					Local $aAllCoords = decodeMultipleCoords($sAllCoordsString, 50, 50) ; [{coords1}, {coords2}, ...]

					For $j = 0 To UBound($aAllCoords) - 1
						If $bGoldPass Then
							If QuickMIS("BC1", $g_sImgCCGoldCollectDaily, 40, 270, 810, 340) Then $IsCCGoldPresent += 1
							If QuickMIS("BC1", $g_sImgBOFCollectDaily, 40, 270, 810, 340) Then $IsBOFPresent += 1
							If QuickMIS("BC1", $g_sImgBOSCollectDaily, 40, 270, 810, 340) Then $IsBOSPresent += 1
							If QuickMIS("BC1", $g_sImgResPotCollectDaily, 40, 270, 810, 340) Then $IsResPotPresent += 1
						Else
							If QuickMIS("BC1", $g_sImgCCGoldCollectDaily, 40, 470, 810, 540) Then $IsCCGoldPresent += 1
							If QuickMIS("BC1", $g_sImgBOFCollectDaily, 40, 470, 810, 540) Then $IsBOFPresent += 1
							If QuickMIS("BC1", $g_sImgBOSCollectDaily, 40, 470, 810, 540) Then $IsBOSPresent += 1
							If QuickMIS("BC1", $g_sImgResPotCollectDaily, 40, 470, 810, 540) Then $IsResPotPresent += 1
						EndIf
						ClickP($aAllCoords[$j], 1, 0, "Claim " & $j + 1) ; Click Claim button
						_Sleep(Random(2000, 4000, 1))
						If WaitforPixel(350, 410, 351, 411, Hex(0xFDC875, 6), 20, 3) Then; wait for Cancel Button popped up in 1.5 second
						    If $g_bChkSellRewards Then
							    Setlog("Selling extra reward for gems", $COLOR_SUCCESS)
								ClickP($aPersonalChallengeOkBtn, 1, 0, "Okay Btn") ; Click the Okay
								$iClaim += 1
							Else
								SetLog("Cancel. Not selling extra rewards.", $COLOR_SUCCESS)
								ClickP($aPersonalChallengeCancelBtn, 1, 0, "Cancel Btn") ; Click Claim button
							Endif
							If _Sleep(1000) Then ExitLoop
						Else
							$iClaim += 1
							If $bGoldPass Then
								If Not QuickMIS("BC1", $g_sImgCCGoldCollectDaily, 40, 260, 810, 340) And $IsCCGoldPresent > 0 Then $IsCCGoldJustCollected = 1
								If Not QuickMIS("BC1", $g_sImgBOFCollectDaily, 40, 260, 810, 340) And $IsBOFPresent > 0 Then $IsBOFJustCollected = 1
								If Not QuickMIS("BC1", $g_sImgBOSCollectDaily, 40, 260, 810, 340) And $IsBOSPresent > 0 Then $IsBOSJustCollected = 1
								If Not QuickMIS("BC1", $g_sImgResPotCollectDaily, 40, 260, 810, 340) And $IsResPotPresent > 0 Then $IsResPotJustCollected = 1
							Else
								If Not QuickMIS("BC1", $g_sImgCCGoldCollectDaily, 40, 470, 810, 540) And $IsCCGoldPresent > 0 Then $IsCCGoldJustCollected = 1
								If Not QuickMIS("BC1", $g_sImgBOFCollectDaily, 40, 470, 810, 540) And $IsBOFPresent > 0 Then $IsBOFJustCollected = 1
								If Not QuickMIS("BC1", $g_sImgBOSCollectDaily, 40, 470, 810, 540) And $IsBOSPresent > 0 Then $IsBOSJustCollected = 1
								If Not QuickMIS("BC1", $g_sImgResPotCollectDaily, 40, 470, 810, 540) And $IsResPotPresent > 0 Then $IsResPotJustCollected = 1
							EndIf
							If $IsCCGoldJustCollected Then SetLog("Clan Capital Gold Collected", $COLOR_SUCCESS1)
							$IsCCGoldJustCollectedDChallenge = $IsCCGoldJustCollected
							If $IsBOFJustCollected Then SetLog("Book Of Fighting Collected", $COLOR_SUCCESS1)
							If $IsBOSJustCollected Then SetLog("Book Of Spells Collected", $COLOR_SUCCESS1)
							If $IsResPotJustCollected Then SetLog("Research Potion Collected", $COLOR_SUCCESS1)
							If _Sleep(100) Then ExitLoop
						EndIf
					Next
				EndIf
			Next
		EndIf
		If _CheckPixel($aPersonalChallengeRewardsAvail, $g_bCapturePixel) And Not _CheckPixel($aPersonalChallengeLeftEdge, $g_bCapturePixel) Then ; far left edge
			If $i = 0 Then
				SetLog("Dragging back for more... ", Default, Default, Default, Default, Default, Default, False) ; no end line
			Else
				SetLog($i & ".. ", Default, Default, Default, Default, Default, 0, $i < 10 ? False : Default) ; no time
			EndIf
			ClickDrag(100, 415, 750, 415, 1000) ;x1 was 50. x2 was 810  Change for Dec '20 update
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
					Hex($aPersonalChallengePerksTab[2], 6), $aPersonalChallengePerksTab[3], 2) Then Return; wait for Perks Tab completely loaded in 1 second

	If _Sleep(500) Then Return

	; find builder boost rate %
	Local $sDiscount = getOcrAndCapture("coc-builderboost", 370, 330, 110, 46)
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
					Hex($aPersonalChallengePerksTab[2], 6), $aPersonalChallengePerksTab[3], 2) Then Return; wait for Perks Tab completely loaded in 1 second

	If _Sleep(500) Then Return

	; find builder boost rate %
	Local $sDiscount = getOcrAndCapture("coc-builderboost", 370, 330, 110, 46)
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
EndFunc   ;==>CheckDiscountPerks