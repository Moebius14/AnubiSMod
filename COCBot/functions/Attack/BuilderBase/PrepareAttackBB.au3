; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preperation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2023
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func PrepareAttackBB($AttackForCount = 0)

	If $g_bChkForceBBAttackOnClanGames And $g_bIsBBevent Then
		Setlog("Running Challenge is BB Challenge : " & $CurrentActiveChallenge, $COLOR_ACTION)
		SetLog("Force BB Attack on Clan Games Enabled", $COLOR_DEBUG2)
		SetLog("Attack, No Matter What !!", $COLOR_DEBUG2)
		CheckLootAvail()
		CheckBBGoldStorageFull()
		CheckBBElixirStorageFull()
		If Not ClickAttack() Then Return False
		If _Sleep(1500) Then Return
		CheckArmyReady()
		$g_bBBMachineReady = CheckMachReady()
		Return True
	EndIf

	If $g_bChkBBAttackForDailyChallenge Then
		If $g_IsBBDailyChallengeAvailable Then
			SetLog("Attack To Earn A Star, No Matter What !!", $COLOR_DEBUG2)
			$g_IsBBDailyChallengeAvailable = False
			CheckLootAvail()
			CheckBBGoldStorageFull()
			CheckBBElixirStorageFull()
			If Not ClickAttack() Then Return False
			If _Sleep(1500) Then Return
			CheckArmyReady()
			$g_bBBMachineReady = CheckMachReady()
			Return True
		EndIf

		If $AttackForCount > 0 Then
			If Not IsBBDailyChallengeStillAvailable() Then Return False
			If $g_IsBBDailyChallengeAvailable Then
				$g_IsBBDailyChallengeAvailable = False
				CheckLootAvail()
				CheckBBGoldStorageFull()
				CheckBBElixirStorageFull()
				If Not ClickAttack() Then Return False
				If _Sleep(1500) Then Return
				CheckArmyReady()
				$g_bBBMachineReady = CheckMachReady()
				Return True
			EndIf
		EndIf
	EndIf

	If Not $g_bRunState Then Return ; Stop Button
	
	If $g_bChkBBHaltOnResourcesFull Then
		If CheckBBGoldStorageFull() And CheckBBElixirStorageFull() Then
			If _Sleep(1500) Then Return
			Return False
		EndIf
	EndIf	

	If $g_bChkBBAttIfLootAvail Then
		If Not CheckLootAvail() Then
			If _Sleep(1500) Then Return
			ClickAway()
			Return False
		EndIf
	EndIf

	If Not ClickAttack() Then Return False
	If _Sleep(1000) Then Return

	If Not CheckArmyReady() Then
		If _Sleep(1500) Then Return
		ClickAway()
		Return False
	EndIf

	$g_bBBMachineReady = CheckMachReady()
	If $g_bChkBBWaitForMachine And Not $g_bBBMachineReady Then
		SetLog("Battle Machine is not ready.")
		If _Sleep(1500) Then Return
		ClickAway()
		Return False
	EndIf

	Return True ; returns true if all checks succeed
EndFunc

Func CheckBBGoldStorageFull($SetLog = True)
	Local $aBBGoldFull[4] = [661, 35, 0xE7C00D, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBGoldFull, True, Default, "BB Gold Full") Then
		If $SetLog Then SetLog("BB Gold Full")
		Return True
	EndIf
 	Return False
EndFunc

Func CheckBBElixirStorageFull($SetLog = True)
	Local $aBBElixirFull[4] = [661, 85, 0x7945C5, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBElixirFull, True, Default, "BB Elixir Full") Then
		If $SetLog Then SetLog("BB Elixir Full")
		Return True
	EndIf
	Return False
EndFunc	

Func CheckLootAvail($Setlog = True)
	Local $bRet = False, $iRemainStars = 0, $iMaxStars = 0
	Local $sStars = getOcrAndCapture("coc-BBAttackAvail", 40, 568  + $g_iBottomOffsetY, 50, 20)
	
	If $g_bDebugSetLog Then SetLog("Stars: " & $sStars, $COLOR_DEBUG2)
	If $sStars <> "" And StringInStr($sStars, "#") Then 
		Local $aStars = StringSplit($sStars, "#", $STR_NOCOUNT)
		If IsArray($aStars) Then 
			$iRemainStars = $aStars[0]
			$iMaxStars = $aStars[1]
		EndIf
		If Number($iRemainStars) <= Number($iMaxStars) Then
			If $Setlog Then SetLog("Remaining Stars : " & $iRemainStars & "/" & $iMaxStars, $COLOR_INFO)
			$bRet = True
		Else
			If $Setlog Then SetLog("All attacks used")
		EndIf
	EndIf
	Return $bRet
EndFunc

Func CheckMachReady()
	Local $bRet = False
	If QuickMis("BC1", $g_sImgBBMachReady, 120, 270 + $g_iMidOffsetY, 180, 325 + $g_iMidOffsetY) Then
		$bRet = True
		SetLog("Battle Machine ready.")
	EndIf
	Return $bRet
EndFunc

Func CheckArmyReady()
	local $i = 0
	local $bReady = True, $bNeedTrain = False, $bTraining = False

	If _ColorCheck(_GetPixelColor(126, 246 + $g_iMidOffsetY, True), Hex(0xE84C50, 6), 20) Then 
		SetLog("Army is not Ready", $COLOR_DEBUG)
		$bNeedTrain = True ;need train, so will train cannon cart
		$bReady = False
	EndIf

	If Not $bReady And $bNeedTrain Then
		SetLog("Train to Fill Army", $COLOR_INFO)
		ClickAway()
		If _Sleep(2000) Then Return
		ClickP($aArmyTrainButton, 1, 0, "BB Train Button")

		If _Sleep(1000) Then Return ; wait for window
		For $i = 1 To 5
			SetLog("Waiting for Army Window #" & $i, $COLOR_ACTION)
			If _Sleep(500) Then Return
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 760, 140 + $g_iMidOffsetY, 800, 190 + $g_iMidOffsetY) Then ExitLoop
		Next

		Local $Camp = QuickMIS("CNX", $g_sImgFillCamp, 70, 210 + $g_iMidOffsetY, 800, 250 + $g_iMidOffsetY)
		For $i = 1 To UBound($Camp)
			If QuickMIS("BC1", $g_sImgFillTrain, 75, 390 + $g_iMidOffsetY, 800, 530 + $g_iMidOffsetY) Then
				Setlog("Fill ArmyCamp with : " & $g_iQuickMISName, $COLOR_DEBUG)
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(500) Then Return
			EndIf
		Next

		$Camp = QuickMIS("CNX", $g_sImgFillCamp, 70, 210 + $g_iMidOffsetY, 800, 250 + $g_iMidOffsetY)
		If UBound($Camp) > 0 Then 
			$bReady = False
		Else
			$bReady = True
		EndIf

		ClickAway("Left")
		If _Sleep(1000) Then Return ; wait for window close
		ClickAttack()
	EndIf

	If Not $bReady Then
		SetLog("Army is not ready.")
	Else
		SetLog("Army is ready.")
	EndIf
	Return $bReady
EndFunc

Func ClickAttack()
	Local $sSearchDiamond = GetDiamondFromRect2(10, 560 + $g_iBottomOffsetY, 115, 660 + $g_iBottomOffsetY)
	Local $aCoords = decodeSingleCoord(findImage("ClickAttack", $g_sImgBBAttackButton, $sSearchDiamond, 1, True)) ; bottom
	local $bRet = False

	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		SetDebugLog(String($aCoords[0]) & " " & String($aCoords[1]))
		PureClick($aCoords[0], $aCoords[1]) ; Click Attack Button
		$bRet = True
	Else
		SetLog("Can not find button for Builders Base Attack button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugDiamondImage("ClickAttack", $sSearchDiamond)
	EndIf

	Return $bRet
EndFunc

Func ReturnHomeDropTrophyBB($bOnlySurender = False)
	SetLog("Returning Home", $COLOR_SUCCESS)

	For $i = 1 To 15
		Select
			Case IsBBAttackPage() = True
				Click(65, 550) ;click surrender
				If _Sleep(1000) Then Return
			Case QuickMIS("BC1", $g_sImgBBReturnHome, 390, 515 + $g_iMidOffsetY, 470, 560 + $g_iMidOffsetY) = True
				If $bOnlySurender Then 
					Return True
				EndIf
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(3000) Then Return
			Case QuickMIS("BC1", $g_sImgBBAttackBonus, 410, 460 + $g_iMidOffsetY, 454, 490 + $g_iMidOffsetY) = True
				SetLog("Congrats Chief, Stars Bonus Awarded", $COLOR_INFO)
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(2000) Then Return
				Return True
			Case isOnBuilderBase() = True
				Return True
			Case IsOKCancelPage() = True
				ClickOkay("BB Attack Surrender"); Click Okay to Confirm surrender
				If _Sleep(1000) Then Return
		EndSelect
		If _Sleep(500) Then Return
	Next

	Return True
EndFunc

Func BuilderJar()

	If Not $g_bChkEnableBBAttack Or Not $g_bChkUseBuilderJar Or $g_bIsBBevent Or $g_bChkBBAttackForDailyChallenge Then Return

	If Not CheckLootAvail(False) Then
		If CheckBBGoldStorageFull(False) And CheckBBElixirStorageFull(False) Then
			SetLog("Storages Are Full, Builder Jar Won't Be Used", $COLOR_DEBUG2)
			Return
		EndIf
		SetLog("Use Builder Jar", $COLOR_INFO)
		If Not ClickAttack() Then Return
		If _Sleep(2000) Then Return
		If QuickMIS("BC1", $g_sImgUseBuilderJar, 125, 465 + $g_iMidOffsetY, 190, 510 + $g_iMidOffsetY) Then
			Click($g_iQuickMISX + 20, $g_iQuickMISY)
			If _Sleep(1500) Then Return
			If ClickB("BoostConfirm") Then
				SetLog("Stars Unlocked With Builder Jar", $COLOR_SUCCESS)
				$ActionForModLog = "Using Builder Jar"
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Stars Unlocked " & $ActionForModLog, 1)
				Else
					GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Stars Unlocked " & $ActionForModLog, 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Stars Unlocked " & $ActionForModLog & "")
			Else
				SetLog("No Confirm Button Found", $COLOR_DEBUG)
			EndIf
		Else
			SetLog("No Builder Jar Found", $COLOR_DEBUG2)
		EndIf
		If _Sleep(1000) Then Return
		CloseWindow()
	EndIf

EndFunc