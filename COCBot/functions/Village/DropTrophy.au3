; #FUNCTION# ====================================================================================================================
; Name ..........: DropTrophy
; Description ...: Gets trophy count of village and compares to max trophy input. Will drop a troop and return home with no screenshot or gold wait.
; Syntax ........: DropTrophy()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Promac (2015-04), KnowJack(2015-08), Hervidero (2016-01), MonkeyHunter (2016-01,05)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DropTrophy()

	If $g_bDropTrophyEnable Then

		SetDebugLog("Drop Trophy()", $COLOR_DEBUG)

		If $g_bDebugDeadBaseImage Then
			DirCreate($g_sProfileTempDebugPath & "\SkippedZombies\")
			DirCreate($g_sProfileTempDebugPath & "\Zombies\")
			setZombie()
		EndIf

		For $i = 0 To 5
			$g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
			SetDebugLog("Current Trophy Count: " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_DEBUG)
			If $g_aiCurrentLoot[$eLootTrophy] <> "" Then ExitLoop
			If _Sleep(1000) Then Return
			ClearScreen()
		Next

		If Not $IsdroptrophiesActive Then
			If Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMax) Then
				$IsdroptrophiesActive = 1
			Else
				Return
			EndIf
		EndIf

		SetLog("Check Train/Donate/Request Before Drop Trophies", $COLOR_BLUE)

		If Not IsToFillCCWithMedalsOnly() Then RequestCC()

		If Not _Sleep($DELAYRUNBOT1) Then checkMainScreen(False)

		If $g_iActiveDonate And $g_bChkDonate Then
			If $g_bFirstStart Then
				getArmyTroopCapacity(True, False)
				If _Sleep($DELAYRESPOND) Then Return
				getArmySpellCapacity(False, True)
				If _Sleep($DELAYRESPOND) Then Return
			EndIf
			; if in "Halt/Donate" don't skip near full army
			If (Not SkipDonateNearFullTroops(True) Or $g_iCommandStop = 3 Or $g_iCommandStop = 0) And BalanceDonRec(True) Then DonateCC()
		EndIf
		If Not _Sleep($DELAYRUNBOT1) Then checkMainScreen(False)
		If $g_bTrainEnabled Then     ; check for training enabled in halt mode
			If $g_iActualTrainSkip < $g_iMaxTrainSkip Then
				TrainSystem()
				_Sleep($DELAYRUNBOT1)
			Else
				SetLog("Humanize bot, prevent to delete and recreate troops " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_blue)
				$g_iActualTrainSkip = $g_iActualTrainSkip + 1
				If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
					$g_iActualTrainSkip = 0
				EndIf
				CheckOverviewFullArmy(True, False)     ; use true parameter to open train overview window
				If _Sleep($DELAYRESPOND) Then Return
				getArmySpells()
				If _Sleep($DELAYRESPOND) Then Return
				getArmyHeroCount(False, True)
			EndIf
		Else
			If $g_bDebugSetlogTrain Then SetLog("Halt mode - training disabled", $COLOR_DEBUG)
		EndIf

		;Check if proper troop types avail during last checkarmycamp(), no need to call separately since droptrophy checked often
		Local $bHaveTroops = 0
		For $i = 0 To UBound($g_avDTtroopsToBeUsed, 1) - 1
			If $g_avDTtroopsToBeUsed[$i][1] > 0 Then
				$bHaveTroops = 1
				If $g_bDebugSetlog Then
					SetDebugLog("Drop Trophy Found " & StringFormat("%3s", $g_avDTtroopsToBeUsed[$i][1]) & " " & $g_avDTtroopsToBeUsed[$i][0], $COLOR_DEBUG)
					ContinueLoop ; display all troop counts if debug flag set
				Else
					ExitLoop ; Finding 1 troop type is enough to use trophy drop, stop checking rest when no debug flag
				EndIf
			EndIf
		Next

		If $g_bDropTrophyUseHeroes = 1 Then
			$IsKingReadyForDropTrophies = 0
			$IsQueenReadyForDropTrophies = 0
			$IsWardenReadyForDropTrophies = 0
			$IsChampionReadyForDropTrophies = 0
			getArmyHeroCount(True, True)
		EndIf

		Local $g_iHeroAvailableForTrophies = $IsKingReadyForDropTrophies + $IsQueenReadyForDropTrophies + $IsWardenReadyForDropTrophies + $IsChampionReadyForDropTrophies
		Local $bHaveHero = 0

		; if heroes enabled, check them and reset drop trophy disable
		If $g_iHeroAvailableForTrophies > 0 Then
			SetDebugLog("Drop Trophy Found Hero BK|AQ|GW|RC: " & BitOR($g_iHeroAvailable, $eHeroKing) & "|" & BitOR($g_iHeroAvailable, $eHeroQueen) & "|" & BitOR($g_iHeroAvailable, $eHeroWarden) & "|" & BitOR($g_iHeroAvailable, $eHeroChampion), $COLOR_DEBUG)
			$bHaveHero = 1
			If $g_bDropTrophyUseHeroes = 1 Then SetLog("Heroes available !", $COLOR_OLIVE)
			SetLog("Number of heroes : " & $g_iHeroAvailableForTrophies & "", $COLOR_OLIVE)
		EndIf

		Local $bReadyToDrop = 0

		If $g_bDropTrophyUseHeroes = 1 And $g_bChkTrophyAtkWithHeroesOnly = True Then
			$bReadyToDrop = $bHaveHero
		ElseIf $g_bDropTrophyUseHeroes = 1 And $g_bChkTrophyAtkWithHeroesOnly = False Then
			If $bHaveTroops = 1 Then $bReadyToDrop = $bHaveTroops
			If $bHaveHero = 1 Then $bReadyToDrop = $bHaveHero
		ElseIf $g_bDropTrophyUseHeroes = 0 Then
			$bReadyToDrop = $bHaveTroops
		EndIf

		If $bReadyToDrop = 0 Then ; troops Or Heroe(s) available?
			SetLog("Drop Trophy temporarily disabled, missing proper troop type", $COLOR_ERROR)
			If $g_bDropTrophyUseHeroes = 1 Then SetLog("No Heroe available !", $COLOR_ERROR)
			If $g_bDropTrophyUseHeroes = 0 Then SetLog("Please Train DT Troops !", $COLOR_ERROR)
			SetDebugLog("Drop Trophy(): No troops in $g_avDTtroopsToBeUsed array", $COLOR_DEBUG)

			CollectCCGold()
			If SwitchBetweenBasesMod2() Then
				ForgeClanCapitalGold()
				_Sleep($DELAYRUNBOT3)
				AutoUpgradeCC()
				_Sleep($DELAYRUNBOT3)
			EndIf

			Local $AllowCG = True
			If ProfileSwitchAccountEnabled() And $g_bChkBBMaxEventsInARow Then
				If Number($g_aiAttackedBBEventCount) >= Number($g_aiLimitBBEventCount) And Number($g_aiLimitBBEventCount) > 0 Then $AllowCG = False
			EndIf

			If $g_bChkClanGamesEnabled And $g_bChkEnableBBAttack And $g_bDropTrophyUseHeroes = 1 And $AllowCG Then
				SetLog("Check Clan Games !", $COLOR_OLIVE)
				_ClanGames()
				If $g_bChkForceBBAttackOnClanGames And $g_bIsBBevent Then
					SwitchBetweenBasesMod()
					If $IstoSwitchMod Then
						$ActionForModLog = "Switch To Builder Base - BB Event Detected"
						If $g_iTxtCurrentVillageName <> "" Then
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] " & $ActionForModLog, 1)
						Else
							GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] " & $ActionForModLog, 1)
						EndIf
						_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] " & $ActionForModLog)
						BuilderBase()
					EndIf
				EndIf
			EndIf

			_Sleep($DELAYRUNBOT3)

			If $g_bDropTrophyUseHeroes = 1 And $g_bChkTrophyAtkWithHeroesOnly = True Then
				If ProfileSwitchAccountEnabled() And $g_bChkSmartSwitch Then
					SetLog("Switching Account While Waiting For Heroes", $COLOR_OLIVE)
					$g_iNextAccount = $g_iCurAccount + 1
					SwitchCoCAcc($g_iNextAccount)
				Else
					SetLog("Check/Close Bot To Wait For Heroes", $COLOR_OLIVE)
					SmartWait4Train()
				EndIf
			EndIf

			Return
		EndIf

		If $bReadyToDrop = 1 And $g_bChkTrophyAtkWithHeroesOnly = False Then
			SetLog("Drop Trophies using Heroe(s) Or DT Troops", $COLOR_OLIVE)
		ElseIf $bReadyToDrop = 1 And $g_bChkTrophyAtkWithHeroesOnly = True Then
			SetLog("Drop Trophies using Heroe(s) Only", $COLOR_OLIVE)
		EndIf

		Local $iCount, $aRandomEdge, $iRandomXY
		Local Const $DTArmyPercent = Round(Int($g_iDropTrophyArmyMinPct) / 100, 2)
		Local $g_iDropTrophyMaxNeedCheck = $g_iDropTrophyMax ; set trophy target to max trophy
		If $IsDropTrophyBreaked Then $g_iDropTrophyMaxNeedCheck = $g_iDropTrophyMin
		Local Const $iWaitTime = 4 ; wait time for base recheck during long drop times in minutes (4 minutes ~5-10 drop attacks)
		Local $iDateCalc, $sWaitToDate
		$sWaitToDate = _DateAdd('n', Int($iWaitTime), _NowCalc()) ; find delay time for checkbasequick
		SetDebugLog("ChkBaseQuick delay time= " & $sWaitToDate & " Now= " & _NowCalc() & " Diff= " & _DateDiff('s', _NowCalc(), $sWaitToDate), $COLOR_DEBUG)

		Local $bLoop = 0
		While $IsdroptrophiesActive
			$g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
			SetLog("Trophy Count : " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_SUCCESS)
			If Number($g_aiCurrentLoot[$eLootTrophy]) > Number($g_iDropTrophyMaxNeedCheck) Then
				;Check everytime if Troop/Heroe Still available
				;Check if proper troop types avail during last checkarmycamp(), no need to call separately since droptrophy checked often

				If $bLoop > 0 Then

					If $g_bDropTrophyUseHeroes = 0 Then CheckOverviewFullArmy(True, True)
					Local $bHaveTroops = 0
					For $i = 0 To UBound($g_avDTtroopsToBeUsed, 1) - 1
						If $g_avDTtroopsToBeUsed[$i][1] > 0 Then
							$bHaveTroops = 1
							If $g_bDebugSetlog Then
								SetDebugLog("Drop Trophy Found " & StringFormat("%3s", $g_avDTtroopsToBeUsed[$i][1]) & " " & $g_avDTtroopsToBeUsed[$i][0], $COLOR_DEBUG)
								ContinueLoop ; display all troop counts if debug flag set
							Else
								ExitLoop ; Finding 1 troop type is enough to use trophy drop, stop checking rest when no debug flag
							EndIf
						EndIf
					Next

					If $g_bDropTrophyUseHeroes = 1 Then
						$IsKingReadyForDropTrophies = 0
						$IsQueenReadyForDropTrophies = 0
						$IsWardenReadyForDropTrophies = 0
						$IsChampionReadyForDropTrophies = 0
						getArmyHeroCount(True, True)
					EndIf

					Local $g_iHeroAvailableForTrophies = $IsKingReadyForDropTrophies + $IsQueenReadyForDropTrophies + $IsWardenReadyForDropTrophies + $IsChampionReadyForDropTrophies
					Local $bHaveHero = 0

					; if heroes enabled, check them and reset drop trophy disable
					If $g_iHeroAvailableForTrophies > 0 Then
						SetDebugLog("Drop Trophy Found Hero BK|AQ|GW|RC: " & BitOR($g_iHeroAvailable, $eHeroKing) & "|" & BitOR($g_iHeroAvailable, $eHeroQueen) & "|" & BitOR($g_iHeroAvailable, $eHeroWarden) & "|" & BitOR($g_iHeroAvailable, $eHeroChampion), $COLOR_DEBUG)
						$bHaveHero = 1
						If $g_bDropTrophyUseHeroes = 1 Then SetLog("Heroes available !", $COLOR_OLIVE)
						SetLog("Number of heroes : " & $g_iHeroAvailableForTrophies & "", $COLOR_OLIVE)
					EndIf

					Local $bReadyToDrop = 0

					If $g_bDropTrophyUseHeroes = 1 And $g_bChkTrophyAtkWithHeroesOnly = True Then
						$bReadyToDrop = $bHaveHero
					ElseIf $g_bDropTrophyUseHeroes = 1 And $g_bChkTrophyAtkWithHeroesOnly = False Then
						If $bHaveTroops = 1 Then $bReadyToDrop = $bHaveTroops
						If $bHaveHero = 1 Then $bReadyToDrop = $bHaveHero
					ElseIf $g_bDropTrophyUseHeroes = 0 Then
						$bReadyToDrop = $bHaveTroops
					EndIf

					If $bReadyToDrop = 0 Then ; troops available?

						SetLog("Drop Trophy temporarily disabled, missing proper troop type", $COLOR_ERROR)
						If $g_bDropTrophyUseHeroes = 1 Then SetLog("No Heroe available !", $COLOR_ERROR)
						If $g_bDropTrophyUseHeroes = 0 Then SetLog("Please Train DT Troops !", $COLOR_ERROR)
						SetDebugLog("Drop Trophy(): No troops in $g_avDTtroopsToBeUsed array", $COLOR_DEBUG)
						$IsDropTrophyBreaked = 1

						CollectCCGold()
						If SwitchBetweenBasesMod2() Then
							ForgeClanCapitalGold()
							_Sleep($DELAYRUNBOT3)
							AutoUpgradeCC()
							_Sleep($DELAYRUNBOT3)
						EndIf

						Local $AllowCG = True
						If ProfileSwitchAccountEnabled() And $g_bChkBBMaxEventsInARow Then
							If Number($g_aiAttackedBBEventCount) >= Number($g_aiLimitBBEventCount) And Number($g_aiLimitBBEventCount) > 0 Then $AllowCG = False
						EndIf

						If $g_bChkClanGamesEnabled And $g_bChkEnableBBAttack And $g_bDropTrophyUseHeroes = 1 And $AllowCG Then
							SetLog("Check Clan Games !", $COLOR_OLIVE)
							_ClanGames()
							If $g_bChkForceBBAttackOnClanGames And $g_bIsBBevent Then
								SwitchBetweenBasesMod()
								If $IstoSwitchMod Then
									$ActionForModLog = "Switch To Builder Base - BB Event Detected"
									If $g_iTxtCurrentVillageName <> "" Then
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] " & $ActionForModLog, 1)
									Else
										GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] " & $ActionForModLog, 1)
									EndIf
									_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] " & $ActionForModLog)
									BuilderBase()
								EndIf
							EndIf
						EndIf

						_Sleep($DELAYRUNBOT3)

						If $g_bDropTrophyUseHeroes = 1 And $g_bChkTrophyAtkWithHeroesOnly = True Then
							If ProfileSwitchAccountEnabled() And $g_bChkSmartSwitch Then
								SetLog("Switching Account While Waiting For Heroes", $COLOR_OLIVE)
								$g_iNextAccount = $g_iCurAccount + 1
								SwitchCoCAcc($g_iNextAccount)
							Else
								SetLog("Check/Close Bot To Wait For Heroes", $COLOR_OLIVE)
								SmartWait4Train()
							EndIf
						EndIf
						Return
					EndIf

					If $bReadyToDrop = 1 And $g_bChkTrophyAtkWithHeroesOnly = False Then
						SetLog("Drop Trophies using Heroe(s) Or DT Troops", $COLOR_OLIVE)
					ElseIf $bReadyToDrop = 1 And $g_bChkTrophyAtkWithHeroesOnly = True Then
						SetLog("Drop Trophies using Heroe(s) Only", $COLOR_OLIVE)
					EndIf

				EndIf

				$bLoop += 1

				;
				; Check for enough troops before starting base search to save search costs
				If $g_bDropTrophyAtkDead Then
					; If attack dead bases during trophy drop is enabled then make sure we have enough army troops
					If ($g_CurrentCampUtilization <= ($g_iTotalCampSpace * $DTArmyPercent)) Then ; check if current troops above setting
						SetLog("Drop Trophy is waiting for " & $g_iDropTrophyArmyMinPct & "% full army to also attack Deadbases.", $COLOR_ACTION)
						SetDebugLog("Drop Trophy(): Drop Trophy + Dead Base skipped, army < " & $g_iDropTrophyArmyMinPct & "%.", $COLOR_DEBUG)
						ExitLoop ; no troops then cycle again
					EndIf

					; no deadbase attacks enabled, then only 1 giant or hero needed to enable drop trophy to work
				Else
					If ($g_CurrentCampUtilization < 5) And ($g_bDropTrophyUseHeroes = 1 And $g_iHeroAvailable = $eHeroNone) Then
						SetLog("No troops available to use on Drop Trophy", $COLOR_ERROR)
						SetDebugLog("Drop Trophy(): Drop Trophy skipped, no army.", $COLOR_DEBUG)
						ExitLoop ; no troops then cycle again
					EndIf
				EndIf

				$g_iDropTrophyMaxNeedCheck = $g_iDropTrophyMin ; already checked above max trophy, so set target to min trophy value
				SetLog("Dropping Trophies to " & $g_iDropTrophyMin, $COLOR_INFO)
				If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
				ZoomOut()
				PrepareSearch($DT)
				If $g_bOutOfGold Then Return
				If $g_bRestart Then
					CleanSuperchargeTemplates()
					Return
				EndIf

				WaitForClouds() ; Wait for clouds to disappear

				If $g_bRestart Then
					CleanSuperchargeTemplates()
					Return
				EndIf

				If _Sleep($DELAYDROPTROPHY4) Then ExitLoop

				$g_iSearchCount = 0
				GetResources(False, $DT) ; no log, use $DT matchmode (DropThrophy)
				If $g_bRestart Then
					CleanSuperchargeTemplates()
					Return
				EndIf

				If $g_bDropTrophyAtkDead Then
					; Check for Dead Base on 1st search
					$g_iAimGold[$DB] = $g_aiFilterMinGold[$DB]
					$g_iAimElixir[$DB] = $g_aiFilterMinElixir[$DB]
					$g_iAimGoldPlusElixir[$DB] = $g_aiFilterMinGoldPlusElixir[$DB]

					Local $G = (Number($g_iSearchGold) >= Number($g_iAimGold[$DB]))
					Local $E = (Number($g_iSearchElixir) >= Number($g_iAimElixir[$DB]))
					Local $GPE = ((Number($g_iSearchElixir) + Number($g_iSearchGold)) >= Number($g_iAimGoldPlusElixir[$DB]))
					If $G = True And $E = True And $GPE = True Then
						SetLog("Found [G]:" & StringFormat("%7s", $g_iSearchGold) & " [E]:" & StringFormat("%7s", $g_iSearchElixir) & " [D]:" & StringFormat("%5s", $g_iSearchDark) & " [T]:" & StringFormat("%2s", $g_iSearchTrophy), $COLOR_BLACK, "Lucida Console", 7.5)
						If $g_bDebugDeadBaseImage Then setZombie()
						ForceCaptureRegion()
						_CaptureRegion2() ; take new capture for deadbase
						If checkDeadBase() Then

							SetLog("      " & "Dead Base Found while dropping Trophies!", $COLOR_SUCCESS, "Lucida Console", 7.5)
							SetLog("Identification of your troops:", $COLOR_INFO)
							PrepareAttack($DB) ; ==== Troops :checks for type, slot, and quantity ===
							If $g_bRestart Then
								CleanSuperchargeTemplates()
								Return
							EndIf
							Attack()
							ReturnHome($g_bTakeLootSnapShot)
							$g_bIsClientSyncError = False ; reset OOS flag to get new new army
							$g_bIsSearchLimit = False ; reset search limit flag to get new new army
							$g_bRestart = True ; Set restart flag after dead base attack to ensure troops are trained
							SetDebugLog("Drop Trophy END: Dead Base was attacked, reset army and return to Village.", $COLOR_DEBUG)
							CleanSuperchargeTemplates()
							ExitLoop ; or Return, Will end function, no troops left to drop Trophies, will need to Train new Troops first
						Else
							SetLog("      " & "Not a Dead Base, resuming Trophy Dropping.", $COLOR_BLACK, "Lucida Console", 7.5)
						EndIf
					EndIf
					CleanSuperchargeTemplates()
				EndIf

				; Normal Drop Trophy, no check for Dead Base
				SetLog("Identification of your troops:", $COLOR_INFO)
				PrepareAttack($DT) ; ==== Troops :checks for type, slot, and quantity ===
				If $g_bRestart Then Return

				If _Sleep($DELAYDROPTROPHY4) Then ExitLoop

				; Drop a Hero or Troop
				If $g_bDropTrophyUseHeroes Then
					;a) identify heroes avaiables...
					SetSlotSpecialTroops()

					;b) calculate random drop point...
					Local $IsBoostButton = False
					For $i = 1 To 5
						If _Sleep(300) Then Return
						If QuickMIS("BFI", $g_sImgImgLocButtons & "\BoostButtons\BoostButton*.xml", 130, 515 + $g_iBottomOffsetY, 390, 555 + $g_iBottomOffsetY) Then
							$IsBoostButton = True
							ExitLoop
						EndIf
					Next
					If $IsBoostButton Then
						$aRandomEdge = $g_aaiEdgeDropPoints2[Round(Random(0, 3))]
					Else
						$aRandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
					EndIf
					$iRandomXY = Round(Random(0, 4))
					SetDebugLog("Hero Loc = " & $iRandomXY & ", X:Y= " & $aRandomEdge[$iRandomXY][0] & "|" & $aRandomEdge[$iRandomXY][1], $COLOR_DEBUG)

					;c) check if hero avaiable and drop according to priority
					If ($g_iQueenSlot <> -1 Or $g_iKingSlot <> -1 Or $g_iWardenSlot <> -1 Or $g_iChampionSlot <> -1) Then
						Local $sHeroPriority
						Local $SwitchPriority = $g_iDropTrophyHeroesPriority
						If $g_iChkHeroesPriorityRandom Then $SwitchPriority = Random(0, 7, 1)
						Switch $SwitchPriority
							Case 0
								$sHeroPriority = "QKWC"
							Case 1
								$sHeroPriority = "QWKC"
							Case 2
								$sHeroPriority = "KQWC"
							Case 3
								$sHeroPriority = "KWQC"
							Case 4
								$sHeroPriority = "WKQC"
							Case 5
								$sHeroPriority = "WQKC"
							Case 6
								$sHeroPriority = "CWQK"
							Case 7
								$sHeroPriority = "CQWK"
						EndSwitch

						Local $t
						Local $DELAYDROPTROPHYHERO = _Sleep(Random(850, 1350, 1))
						For $i = 1 To 4
							$t = StringMid($sHeroPriority, $i, 1)
							Switch $t
								Case "Q"
									If $g_iQueenSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying Queen", $COLOR_INFO)
										SelectDropTroop($g_iQueenSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 120, "#0180") ;Drop Queen
										If _Sleep($DELAYDROPTROPHYHERO) Then ExitLoop
										SelectDropTroop($g_iQueenSlot) ;If Queen was not activated: Boost Queen before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
								Case "K"
									If $g_iKingSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying King", $COLOR_INFO)
										SelectDropTroop($g_iKingSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 120, "#0178") ;Drop King
										If _Sleep($DELAYDROPTROPHYHERO) Then ExitLoop
										SelectDropTroop($g_iKingSlot) ;If King was not activated: Boost King before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
								Case "W"
									If $g_iWardenSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying Warden", $COLOR_INFO)
										SelectDropTroop($g_iWardenSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 120, "#0000") ;Drop Warden
										If _Sleep($DELAYDROPTROPHYHERO) Then ExitLoop
										SelectDropTroop($g_iWardenSlot) ;If Warden was not activated: Boost Warden before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
								Case "C"
									If $g_iChampionSlot <> -1 Then
										SetTrophyLoss()
										SetLog("Deploying Royal Champion", $COLOR_INFO)
										SelectDropTroop($g_iChampionSlot)
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 120, "#0000") ;Drop Champion
										If _Sleep($DELAYDROPTROPHYHERO) Then ExitLoop
										SelectDropTroop($g_iChampionSlot) ;If Champion was not activated: Boost Champion before EndBattle to restore some health
										ReturnfromDropTrophies()
										If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
										ExitLoop
									EndIf
							EndSwitch
						Next
						$IsDropTrophyBreaked = 1
						$g_iDropTrophyMaxNeedCheck = $g_iDropTrophyMin
					EndIf
				EndIf
				If ($g_iQueenSlot = -1 And $g_iKingSlot = -1 And $g_iWardenSlot = -1 And $g_iChampionSlot = -1) Or $g_bDropTrophyUseHeroes = 0 Then
					$aRandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
					$iRandomXY = Round(Random(0, 4))
					SetDebugLog("Troop Loc = " & $iRandomXY & ", X:Y= " & $aRandomEdge[$iRandomXY][0] & "|" & $aRandomEdge[$iRandomXY][1], $COLOR_DEBUG)
					For $i = 0 To UBound($g_avAttackTroops) - 1
						If ($g_avAttackTroops[$i][0] >= $eBarb And $g_avAttackTroops[$i][0] <= $eWiza) Or $g_avAttackTroops[$i][0] = $eMini Then
							SelectDropTroop($i)
							If _Sleep($DELAYDROPTROPHY4) Then ExitLoop
							Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 120, "#0181") ;Drop one troop
							SetLog("Deploying 1 " & $g_asTroopNames[$g_avAttackTroops[$i][0]], $COLOR_INFO)
							$g_aiCurrentTroops[$g_avAttackTroops[$i][0]] -= 1
							ExitLoop
						EndIf
						If $g_avAttackTroops[$i][0] = -1 Or $g_avAttackTroops[$i][0] >= $eTroopCount Then
							SetLog("You don't have Tier 1/2 Troops, Stop dropping trophies.", $COLOR_INFO) ; preventing of deploying Tier 2/3 expensive troops
							ExitLoop 2
						EndIf
					Next
					SetTrophyLoss()
					If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
					ReturnHome(False, False) ;Return home no screenshot
					If _Sleep($DELAYDROPTROPHY1) Then ExitLoop
				EndIf
				$iDateCalc = _DateDiff('s', _NowCalc(), $sWaitToDate)
				SetDebugLog("ChkBaseQuick delay= " & $sWaitToDate & " Now= " & _NowCalc() & " Diff= " & $iDateCalc, $COLOR_DEBUG)
				If $iDateCalc <= 0 Then ; check length of time in drop trophy
					SetLog(" Checking base during long drop cycle", $COLOR_INFO)
					CheckBaseQuick() ; check base during long drop times
					$sWaitToDate = _DateAdd('n', Int($iWaitTime), _NowCalc()) ; create new delay date/time
					SetDebugLog("ChkBaseQuick new delay time= " & $sWaitToDate, $COLOR_DEBUG)
				EndIf
			Else
				SetLog("Trophy Drop Complete", $COLOR_INFO)
				$IsdroptrophiesActive = 0
				$IsDropTrophyBreaked = 0
				ClearScreen()
				If IsSearchAttackEnabled() Then
					TrainSystem()
				Else
					If Not $g_bRunState Then Return
					Return
				EndIf
			EndIf
		WEnd
		SetDebugLog("DropTrophy(): End", $COLOR_DEBUG)
	Else
		SetDebugLog("Drop Trophy SKIP", $COLOR_DEBUG)
	EndIf

EndFunc   ;==>DropTrophy

Func SetTrophyLoss()
	Local $sTrophyLoss
	If _ColorCheck(_GetPixelColor(33, 148 + 7, True), Hex(0x000000, 6), 10) Or _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixir") Then ; check if the village have a Dark Elixir Storage
		$sTrophyLoss = getTrophyLossAttackScreen(48, 214 + 7)
	Else
		$sTrophyLoss = getTrophyLossAttackScreen(48, 184 + 7)
	EndIf
	SetLog(" Trophy loss = " & $sTrophyLoss, $COLOR_DEBUG) ; record trophy loss
	$g_iDroppedTrophyCount -= Number($sTrophyLoss)
	UpdateStats()
EndFunc   ;==>SetTrophyLoss
