; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preperation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func PrepareAttackBB($AttackForCount = 0)

	If $g_bChkForceBBAttackOnClanGames And $g_bIsBBevent[$g_iCurAccount] Then
		Setlog("Running Challenge is BB Challenge", $COLOR_OLIVE)
		SetLog("Force BB Attack on Clan Games Enabled", $COLOR_DEBUG)
		SetLog("Attack, No Matter What !!", $COLOR_DEBUG)
		If Not ClickAttack() Then Return False
		_Sleep(1500)
		CheckLootAvail()
		CheckBBGoldStorageFull()
		CheckBBElixirStorageFull()
		CheckArmyReady()
		$g_bBBMachineReady = CheckMachReady()
		Return True
	EndIf
	
	If $g_bChkBBAttackForDailyChallenge Then
		If $g_IsBBDailyChallengeAvailable Then
			SetLog("Attack To Earn A Star, No Matter What !!", $COLOR_DEBUG)
			$g_IsBBDailyChallengeAvailable = False
			If Not ClickAttack() Then Return False
			_Sleep(1500)
			CheckLootAvail()
			CheckBBGoldStorageFull()
			CheckBBElixirStorageFull()
			CheckArmyReady()
			$g_bBBMachineReady = CheckMachReady()
			Return True
		EndIf	
	
		If $AttackForCount > 0 Then
			If Not IsBBDailyChallengeStillAvailable() Then Return False
			If $g_IsBBDailyChallengeAvailable Then
				$g_IsBBDailyChallengeAvailable = False
				If Not ClickAttack() Then Return False
				_Sleep(1500)
				CheckLootAvail()
				CheckBBGoldStorageFull()
				CheckBBElixirStorageFull()
				CheckArmyReady()
				$g_bBBMachineReady = CheckMachReady()
				Return True
			EndIf
		EndIf
	EndIf

	If $g_bChkBBTrophyRange Then
		If ($g_aiCurrentLootBB[$eLootTrophyBB] > $g_iTxtBBTrophyUpperLimit or $g_aiCurrentLootBB[$eLootTrophyBB] < $g_iTxtBBTrophyLowerLimit) Then
			SetLog("Trophies out of range.")
			SetDebugLog("Current Trophies: " & $g_aiCurrentLootBB[$eLootTrophyBB] & " Lower Limit: " & $g_iTxtBBTrophyLowerLimit & " Upper Limit: " & $g_iTxtBBTrophyUpperLimit)
			_Sleep(1500)
			Return False
		EndIf
	EndIf
	
	If Not $g_bRunState Then Return ; Stop Button

	If Not ClickAttack() Then Return False
	_Sleep(1000)
	
	If $g_bChkBBHaltOnGoldFull And $g_bChkBBHaltOnElixirFull Then
		If CheckBBGoldStorageFull(False) And CheckBBElixirStorageFull(False) Then
			SetLog("BB Gold And Elixir Full")
			_Sleep(1500)
			Return False
		EndIf
		If CheckBBGoldStorageFull() Or CheckBBElixirStorageFull() Then
			_Sleep(1500)
			Return False
		EndIf
	EndIf
	
	If $g_bChkBBHaltOnGoldFull And Not $g_bChkBBHaltOnElixirFull Then
		If CheckBBGoldStorageFull() Then
			_Sleep(1500)
			Return False
		EndIf
	EndIf
	
	If $g_bChkBBHaltOnElixirFull And Not $g_bChkBBHaltOnGoldFull Then
		If CheckBBElixirStorageFull() Then
			_Sleep(1500)
			Return False
		EndIf
	EndIf	
	
	If $g_bChkBBAttIfLootAvail Then
		If Not CheckLootAvail() Then
			_Sleep(1500)
			ClickAway()
			Return False
		EndIf
	EndIf
	
	If Not CheckArmyReady() Then
		_Sleep(1500)
		ClickAway()
		Return False
	EndIf

	$g_bBBMachineReady = CheckMachReady()
	If $g_bChkBBWaitForMachine And Not $g_bBBMachineReady Then
		SetLog("Battle Machine is not ready.")
		_Sleep(1500)
		ClickAway()
		Return False
	EndIf

	Return True ; returns true if all checks succeed
EndFunc

Func IsBBStoragesFull()
	If ($g_bChkForceBBAttackOnClanGames And $g_bIsBBevent[$g_iCurAccount]) Or ($g_bChkBBAttackForDailyChallenge And $g_IsBBDailyChallengeAvailable) Then Return False
	
	If $g_bChkBBHaltOnGoldFull And $g_bChkBBHaltOnElixirFull Then
		If CheckBBGoldStorageFullMod(False) And CheckBBElixirStorageFullMod(False) Then
			SetLog("BB Gold And Elixir Full")
			_Sleep(1500)
			Return True
		EndIf	
		If CheckBBGoldStorageFullMod() Or CheckBBElixirStorageFullMod() Then
			_Sleep(1500)
			Return True
		EndIf
	EndIf
	
	If $g_bChkBBHaltOnGoldFull And Not $g_bChkBBHaltOnElixirFull Then
		If CheckBBGoldStorageFullMod() Then
			_Sleep(1500)
			Return True
		EndIf
	EndIf
	
	If $g_bChkBBHaltOnElixirFull And Not $g_bChkBBHaltOnGoldFull Then
		If CheckBBElixirStorageFullMod() Then
			_Sleep(1500)
			Return True
		EndIf
	EndIf	
	
	Return False
EndFunc

Func CheckBBGoldStorageFullMod($SetLog = True)
	Local $aBBGoldFull[4] = [659, 35, 0xE7C00D, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBGoldFull, True, Default, "BB Gold Full") Then
		If $SetLog Then SetLog("BB Gold Full")
		Return True
	EndIf
 	Return False
EndFunc

Func CheckBBElixirStorageFullMod($SetLog = True)
	Local $aBBElixirFull[4] = [659, 85, 0x7945C5, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBElixirFull, True, Default, "BB Elixir Full") Then
		If $SetLog Then SetLog("BB Elixir Full")
		Return True
	EndIf
	Return False
EndFunc	

Func CheckBBGoldStorageFull($SetLog = True)
	Local $aBBGoldFull[4] = [710, 35, 0xDAB300, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBGoldFull, True, Default, "BB Gold Full") Then
		If $SetLog Then SetLog("BB Gold Full")
		Return True
	EndIf
 	Return False
EndFunc

Func CheckBBElixirStorageFull($SetLog = True)
	Local $aBBElixirFull[4] = [710, 65, 0xB31AB3, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBElixirFull, True, Default, "BB Elixir Full") Then
		If $SetLog Then SetLog("BB Elixir Full")
		Return True
	EndIf
	Return False
EndFunc	

Func CheckLootAvail()
 	local $bRet = False
	Local $sSearchDiamond = GetDiamondFromRect2(210, 592 + $g_iMidOffsetY, 658, 691 + $g_iMidOffsetY)
	Local $aCoords = decodeSingleCoord(findImage("BBLootAvail_bmp", $g_sImgBBLootAvail, $sSearchDiamond, 1, True))

	If Not $g_bRunState Then Return ; Stop Button
	
	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		$bRet = True
		SetLog("Loot is Available.")
	Else
		SetLog("No loot available.")
		If $g_bDebugImageSave Then SaveDebugDiamondImage("CheckLootAvail", $sSearchDiamond)
	EndIf

	Return $bRet
EndFunc

Func CheckMachReady()
 	local $bRet = False
	Local $sSearchDiamond = GetDiamondFromRect2(113, 358 + $g_iMidOffsetY, 170, 418 + $g_iMidOffsetY)
	Local $aCoords = decodeSingleCoord(findImage("BBMachReady_bmp", $g_sImgBBMachReady, $sSearchDiamond, 1, True))

	If Not $g_bRunState Then Return ; Stop Button
	
	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		$bRet = True
		SetLog("Battle Machine ready.")
	Else
		If $g_bDebugImageSave Then SaveDebugDiamondImage("CheckMachReady", $sSearchDiamond)
	EndIf

	Return $bRet
EndFunc

Func CheckArmyReady()
	local $i = 0
	local $bReady = True, $bNeedTrain = False, $bTraining = False
	Local $sSearchDiamond = GetDiamondFromRect2(114, 354 + $g_iMidOffsetY, 190, 420 + $g_iMidOffsetY) ; start of trained troops bar untill a bit after the 'r' "in Your Troops"

	If Not $g_bRunState Then Return ; Stop Button
	
	If _Sleep($DELAYCHECKFULLARMY2) Then Return False ; wait for window
	While $i < 6 And $bReady ; wait for fight preview window
		local $aNeedTrainCoords = decodeSingleCoord(findImage("NeedTrainBB", $g_sImgBBNeedTrainTroops, $sSearchDiamond, 1, True))
		local $aTroopsTrainingCoords = decodeSingleCoord(findImage("TroopsTrainingBB", $g_sImgBBTroopsTraining, $sSearchDiamond, 1, False)) ; shouldnt need to capture again as it is the same diamond

		If IsArray($aNeedTrainCoords) And UBound($aNeedTrainCoords) = 2 Then
			$bReady = False
			$bNeedTrain = True
		EndIf
		If IsArray($aTroopsTrainingCoords) And UBound($aTroopsTrainingCoords) = 2 Then
			$bReady = False
			$bTraining = True
		EndIf

		$i += 1
	WEnd
	
	If Not $g_bRunState Then Return ; Stop Button
		
	If Not $bReady Then
		SetLog("Army is not ready.")
		If $bTraining Then SetLog("Troops are training.")
		If $bNeedTrain Then SetLog("Troops need to be trained in the training tab.")
		If $g_bDebugImageSave Then SaveDebugImage("FindIfArmyReadyBB")
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