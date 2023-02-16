; #FUNCTION# ====================================================================================================================
; Name ..........: AttackBB
; Description ...: This file controls attacking preperation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......: Moebius 14 (02.2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Local $ai_AttackDropPoints
Local $bFirstAttackClick 
Local $bBMDeployed, $hBMTimer
Local $bMachineAlive

Func DoAttackBB()
	If Not $g_bChkEnableBBAttack Then Return
	
	If IsBBStoragesFull() Then
		SetLog("Skip Attack This Time...", $COLOR_DEBUG)
		Return
	EndIf
	
	Local $AttackForCount = 0
	
	If $g_iBBAttackCount = 0 Then
		Local $count = 1
		While PrepareAttackBB($AttackForCount)
			If Not $g_bRunState Then Return
			SetDebugLog("PrepareAttackBB(): Success.", $COLOR_SUCCESS)
			SetLog("Attacking For Loot", $COLOR_OLIVE)
			SetLog("Attack #" & $count & "/~", $COLOR_INFO)
			AttackBB()
			$AttackForCount += 1
			If $g_bChkForceBBAttackOnClanGames And $g_bIsBBevent Then
				SetLog("Check if Challenge is Completed", $COLOR_DEBUG)
				For $x = 0 To 5
					If QuickMIS("BC1", $g_sImgGameComplete, 760, 510, 820, 550, True, $g_bDebugImageSave) Then
						SetLog("Nice, Game Completed !", $COLOR_SUCCESS)
						ExitLoop 2
					Endif
					_Sleep(500)
				Next
				SetLog("Challenge Is Not Finished...", $COLOR_ERROR)
			EndIf
			If _Sleep($DELAYRUNBOT3) Then Return
			If checkObstacles(True) Then Return
			$count += 1
			If $count > 10 Then
				SetLog("Something May Wrong", $COLOR_INFO)
				SetLog("Already Attack 10 times", $COLOR_INFO)
				ExitLoop
			Endif
		 Wend

		SetLog("Skip Attack This Time..", $COLOR_DEBUG)
		ClickAway()
	Else
		Local $g_iBBAttackCountFinal = 0
		Local $AttackNbDisplay = 0
		If $g_iBBAttackCount = 1 Then
			$g_iBBAttackCountFinal = Random(2, 6, 1)
		ElseIf $g_iBBAttackCount > 1 Then
			$g_iBBAttackCountFinal = $g_iBBAttackCount - 1
		EndIf

		For $i = 1 To $g_iBBAttackCountFinal
			If PrepareAttackBB($AttackForCount) Then
				If $AttackNbDisplay = 0 Then
					If $g_iBBAttackCount = 1 Then
						SetLog("Random Number Of Attacks : " & $g_iBBAttackCountFinal & "", $COLOR_OLIVE)
					ElseIf $g_iBBAttackCount > 1 Then
						SetLog("Number Of Attacks : " & $g_iBBAttackCountFinal & "", $COLOR_OLIVE)
					EndIf
				EndIf
				$AttackNbDisplay += 1
				SetDebugLog("PrepareAttackBB(): Success.", $COLOR_SUCCESS)
				SetLog("Attack #" & $i & "/" & $g_iBBAttackCountFinal, $COLOR_INFO)
				AttackBB()
				$AttackForCount += 1
				If $g_bChkForceBBAttackOnClanGames And $g_bIsBBevent Then
					SetLog("Check if Challenge is Completed", $COLOR_DEBUG)
					For $x = 0 To 5
						If QuickMIS("BC1", $g_sImgGameComplete, 760, 510, 820, 550, True, $g_bDebugImageSave) Then
							SetLog("Nice, Game Completed !", $COLOR_SUCCESS)
							ExitLoop 2
						Endif
						_Sleep(500)
					Next
					SetLog("Challenge Is Not Finished...", $COLOR_ERROR)
				EndIf
				If $g_bRestart = True Then Return
				If _Sleep($DELAYRUNBOT3) Then Return
				If checkObstacles(True) Then Return
			Else
				SetLog("Skip Attack This Time..", $COLOR_DEBUG)
				ClickAway()
				ExitLoop
			Endif
		Next
	EndIf
	ZoomOut()
	If $AttackForCount > 0 Then SetLog("BB Attack Cycle Done", $COLOR_SUCCESS1)
EndFunc

Func AttackBB($iAttackSide = 0)
	If Not $g_bChkEnableBBAttack Then Return

	Local $iSide, $aBMPos
	Local $bAttack = True
   
	SetLog("Going to attack.", $COLOR_BLUE)

	If _Sleep(3000) Then Return


		If $iAttackSide = 0 Then
			$iSide = Random(1, 4, 1) ; randomly choose top left or top right
		Else
			$iSide = $iAttackSide
		EndIf
		
		$aBMPos = 0

		; search for a match
		If _Sleep(2000) Then Return

		Local $aBBFindNow = [521, 278 + $g_iMidOffsetY, 0xffc246, 30] ; search button

		If _CheckPixel($aBBFindNow, True) Then
			PureClick($aBBFindNow[0], $aBBFindNow[1])
		Else
			SetLog("Could not locate search button to go find an attack.", $COLOR_ERROR)
			Return
		EndIf

		If _Sleep(1500) Then Return ; give time for find now button to go away

		If _CheckPixel($aBBFindNow, True) Then ; click failed so something went wrong
			SetLog("Click BB Find Now failed. We will come back and try again.", $COLOR_ERROR)
			ClickAway()
			ZoomOut()
			Return
		EndIf

		Local $iAndroidSuspendModeFlagsLast = $g_iAndroidSuspendModeFlags
		$g_iAndroidSuspendModeFlags = 0 ; disable suspend and resume
		If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Disabled")

		; wait for the clouds to clear
		SetLog("Searching for Opponent.", $COLOR_BLUE)
		Local $timer = __TimerInit()
		Local $iPrevTime = 0

		While Not CheckBattleStarted()
			Local $iTime = Int(__TimerDiff($timer)/ 60000)

			CheckAllObstacles($g_bDebugImageSave, 5, 6)
			If CheckAllObstacles($g_bDebugImageSave, 0, 1) Then Return False

			If $iTime > $iPrevTime Then ; if we have increased by a minute
				SetLog("Clouds: " & $iTime & "-Minute(s)")
				$iPrevTime = $iTime
			EndIf

			If _Sleep($DELAYRESPOND) Then
				$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
				If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
				Return
			EndIf
		WEnd

		ZoomOut()

		If _Sleep(250) Then Return

		;generate attack drop points
		Switch $iSide
			Case 1
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorLeftTop)
			Case 2
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorRightTop)
			Case 3
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorRightBottom)
			Case Else
				$ai_AttackDropPoints = _GetVectorOutZone($eVectorLeftBottom)
		EndSwitch

		; Get troops on attack bar and their quantities
		Local $aBBAttackBar = GetAttackBarBB()
		If _Sleep($DELAYRESPOND) Then
			$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
			If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
			Return
		EndIf

		$bFirstAttackClick = True

	  ; Deploy all troops
		Local $bTroopsDropped = False
		Local $hAtkTimer = TimerInit() ; exit timer
		$bBMDeployed = False
		$bMachineAlive = True
		SetLog( $g_bBBDropOrderSet = True ? "Deploying Troops in Custom Order." : "Deploying Troops in Order of Attack Bar.", $COLOR_BLUE)
		While Not $bTroopsDropped And _Timer_Diff($hAtkTimer) < 210000
			Local $iNumSlots = UBound($aBBAttackBar, 1)
			If $g_bBBDropOrderSet = True Then
				Local $asBBDropOrder = StringSplit($g_sBBDropOrder, "|")
				For $i = 0 To $g_iBBTroopCount - 1 ; loop through each name in the drop order
					Local $j=0, $bDone = 0
					While $j < $iNumSlots And Not $bDone
						If $aBBAttackBar[$j][0] = $asBBDropOrder[$i+1] Then
							DeployBBTroop($aBBAttackBar[$j][0], $aBBAttackBar[$j][1], $aBBAttackBar[$j][2], $aBBAttackBar[$j][4], $iSide)
							If $j = $iNumSlots-1 Or $aBBAttackBar[$j][0] <> $aBBAttackBar[$j+1][0] Then
								$bDone = True
								If _Sleep($g_iBBNextTroopDelay) Then ; wait before next troop
									$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
									If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
									Return
								EndIf
							EndIf
						EndIf
						$j+=1
					WEnd
				Next
			Else
				For $i=0 To $iNumSlots - 1
					DeployBBTroop($aBBAttackBar[$i][0], $aBBAttackBar[$i][1], $aBBAttackBar[$i][2], $aBBAttackBar[$i][4], $iSide)
					If $i = $iNumSlots-1 Or $aBBAttackBar[$i][0] <> $aBBAttackBar[$i+1][0] Then
						If _Sleep($g_iBBNextTroopDelay) Then ; wait before next troop
							$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
							If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
							Return
						EndIf
					Else
						If _Sleep($DELAYRESPOND) Then ; we are still on same troop so lets drop them all down a bit faster
							$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
							If $g_bDebugSetlog = True Then SetDebugLog("Android Suspend Mode Enabled")
							Return
						EndIf
					EndIf
				Next
			EndIf
	
			If __TimerDiff($hBMTimer) > ($g_iBBMachAbilityTime - 500) And $bBMDeployed And $bMachineAlive Then
				SetLog("Check Ability") 
				$aBMPos = GetMachinePos()
				If IsArray($aBMPos) Then 
					PureClickP($aBMPos) ; ability
					$hBMTimer = __TimerInit()
				Else
					$bMachineAlive = False
				EndIf
			EndIf
		
			If _Sleep(250) Then Return
			
			$aBBAttackBar = GetAttackBarBB(True)
			If $aBBattackBar = "" And (Not $bMachineAlive Or Not $g_bBBMAchineReady) Then $bTroopsDropped = True
			
			CheckAllObstacles($g_bDebugImageSave, 5, 6)
			If CheckAllObstacles($g_bDebugImageSave, 0, 1) Then Return False
		WEnd

		SetLog("All Troops Deployed", $COLOR_SUCCESS)

		If $bBMDeployed And Not $bMachineAlive Then SetLog("Battle Machine Dead")

		; wait for end of battle
		SetLog("Waiting for end of battle.", $COLOR_BLUE)
		If Not Okay() Then
			$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
			If $g_bDebugSetlog Then SetDebugLog("Android Suspend Mode Enabled")
			Return
		EndIf

		SetLog("Battle ended")
		If _Sleep(3000) Then
			$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast
			If $g_bDebugSetlog Then SetDebugLog("Android Suspend Mode Enabled")
			Return
		EndIf

	  ; wait for ok after both attacks are finished
	  SetLog("Waiting for opponent", $COLOR_BLUE)
	  Okay()
	  
	SetLog("Done", $COLOR_SUCCESS)
	If _Sleep(1500) Then Return
	
	$g_iAndroidSuspendModeFlags = $iAndroidSuspendModeFlagsLast ; reset android suspend and resume stuff
	If $g_bDebugSetlog Then SetDebugLog("Android Suspend Mode Enabled")
	
	If _Sleep(2000) Then Return
	ClickAway()
EndFunc

Func CheckBattleStarted()
	Local $sSearchDiamond = GetDiamondFromRect("376,10,460,28") ; top

	Local $aCoords = decodeSingleCoord(findImage("BBBattleStarted", $g_sImgBBBattleStarted, $sSearchDiamond, 1, True))
	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		SetLog("Battle Started", $COLOR_SUCCESS)
		Return True
	EndIf

	Return False ; If battle not started
EndFunc

Func GetMachinePos($bDeployed = False)
	If Not $g_bBBMachineReady Then Return

	Local $sSearchDiamond = GetDiamondFromRect2(0, 600 + $g_iMidOffsetY, 860, 702+ $g_iMidOffsetY)
	Local $aCoords

	If $bDeployed Then
		SetDebugLog("Search BM Hammer")
		Local $iLoop = 10
		Local $sImgBattleMachine = @ScriptDir & "\imgxml\Attack\BuilderBase\BattleMachine\BBBattleMachineDeployed_0_90.xml"
	Else
		SetDebugLog("Search BM Eye")
		Local $iLoop = 10
		Local $sImgBattleMachine = @ScriptDir & "\imgxml\Attack\BuilderBase\BattleMachine\BBBattleMachine_0_90.xml"
	EndIf

	For $i = 0 to $iLoop
	   $aCoords = decodeSingleCoord(findImage("BBBattleMachinePos", $sImgBattleMachine, $sSearchDiamond, 1, True))

		If IsArray($aCoords) And UBound($aCoords) = 2 Then
			If _Sleep(100) Then Return
			Return $aCoords
		Else
			If $g_bDebugImageSave Then SaveDebugImage("BBBattleMachinePos")
			;SaveDebugRectImage("BBBattleMachinePos", "0,630,860,732")
			SetDebugLog("AttackBar: Locate BM Failed : " & $i)
		EndIf

		If _Sleep(100) Then Return
	Next

	Return
EndFunc

Func Okay()
	Local $timer = __TimerInit()
	Local $ResultXTime = 0

	While 1
		If $ResultXTime = 0 Then
			If QuickMIS("BC1", $g_sImgBBAttackResult, 390, 155 + $g_iMidOffsetY, 475, 180 + $g_iMidOffsetY) Then 
				If $g_iQuickMISName = "Victory" Then
					SetLog("Match Result : Victory !", $COLOR_SUCCESS1)
					$ResultXTime += 1
				ElseIf $g_iQuickMISName = "Defeat" Then
					SetLog("Match Result : Defeat !", $COLOR_ERROR)
					$ResultXTime += 1
				EndIf
			EndIf
		EndIf
	
		Local $aCoords = decodeSingleCoord(findImage("OkayButton", $g_sImgOkButton, "FV", 1, True))
		If IsArray($aCoords) And UBound($aCoords) = 2 Then
			PureClickP($aCoords)
			If _Sleep(500) Then Return
			Return True
		EndIf

		; check for advert
		If $g_sAndroidGameDistributor = "Magic" Then ClashOfMagicAdvert()
		
		CheckAllObstacles($g_bDebugImageSave, 5, 6)
		If CheckAllObstacles($g_bDebugImageSave, 0, 1) Then Return False

		If __TimerDiff($timer) >= 180000 Then
			SetLog("Could not find button 'Okay'", $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("BBFindOkay")
			Return False
		EndIf

		If Mod(__TimerDiff($timer), 3000) Then
			If _Sleep($DELAYRESPOND) Then Return
		EndIf
	WEnd

	Return True
EndFunc

Func DeployBBTroop($sName, $x, $y, $iAmount, $iSide)
	Local $aBMPos
	SetLog("Deploying " & $sName & "x" & String($iAmount), $COLOR_ACTION)

	PureClick($x, $y) ; select troop
	If _Sleep($g_iBBSameTroopDelay) Then Return ; slow down selecting then dropping troops

	; place hero and activate ability
	If $sName = "BattleMachine" And $g_bBBMachineReady And Not $bBMDeployed Then 
		; get random drop point
		Local $iPoint = Random(0, UBOUND($ai_AttackDropPoints) - 1, 1)
		Local $iPixel = $ai_AttackDropPoints[$iPoint]
		PureClickP($iPixel) ; Click Map
		SetDebugLog("attack click :" & $iPixel[0] & ", " & $iPixel[1], $COLOR_INFO)

		; BM 5+ will display a hammer once deployed - search for hammer
		$aBMPos = GetMachinePos(True)
		If IsArray($aBMPos) Then 
			$bBMDeployed = True
			PureClickP($aBMPos) ; ability
			$hBMTimer = __TimerInit()
		Else
			; no hammer could be BM 1-4 or BM has failed to deployed
			; search for eye
			$aBMPos = GetMachinePos()
			If Not IsArray($aBMPos) Then 
				$bBMDeployed = True ; no eye must be BM 1-4
				$bMachineAlive = False ; no ability
			EndIf
		EndIf

		If $bBMDeployed Then SetLog("Battle Machine Deployed", $COLOR_SUCCESS)
	Else
		For $j=0 To $iAmount - 1
			; get random drop point
			Local $iPoint = Random(0, UBOUND($ai_AttackDropPoints) - 1, 1)
			Local $iPixel = $ai_AttackDropPoints[$iPoint]

			If $bFirstAttackClick Then
				IsClickOnPotions($iPixel[0], $iPixel[1])
				$bFirstAttackClick = False
			EndIf

			PureClickP($iPixel)

			If _Sleep($g_iBBSameTroopDelay) Then Return ; slow down dropping of troops
		Next
	EndIf
 EndFunc

Func IsClickOnPotions(ByRef $x, ByRef $y)
	Local $bResult = False
	SetDebugLog("IsClickOnPotions :" & $x & ", " & $y, $COLOR_INFO)
	If $y > 500 + $g_iBottomOffsetY  Then
		$y = 500 + $g_iBottomOffsetY
		If $x < 460 Then 
			$x = 460
		EndIf
		SetDebugLog("Adjusted Pixel :" & $x & ", " & $y, $COLOR_INFO)

		$bResult = True
	EndIf
	
	Return $bResult
EndFunc