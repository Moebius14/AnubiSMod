
; #FUNCTION# ====================================================================================================================
; Name ..........: BotCommand
; Description ...: There are Commands to Shutdown, Sleep, Halt Attack and Halt Training mode
; Syntax ........: BotCommand()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #17
; Modified ......: MonkeyHunter (2016-2), CodeSlinger69 (2017), MonkeyHunter (2017-3)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func BotCommand()

	Static $TimeToStop = -1

	Local $bChkBotStop, $iCmbBotCond, $iCmbBotCommand

	If $g_bOutOfElixir Or $g_bOutOfGold Then ; Check for out of loot conditions
		$bChkBotStop = True ; set halt attack mode
		$iCmbBotCond = 18 ; set stay online/collect only mode
		$iCmbBotCommand = 0 ; set stop mode to stay online
		Local $sOutOf = ($g_bOutOfGold ? "Gold" : "") & (($g_bOutOfGold And $g_bOutOfElixir) ? " and " : "") & ($g_bOutOfElixir ? "Elixir" : "")
		SetLog("Out of " & $sOutOf & " condition detected, force HALT mode!", $COLOR_WARNING)
	Else
		$bChkBotStop = $g_bChkBotStop ; Normal use GUI halt mode values
		$iCmbBotCond = $g_iCmbBotCond
		$iCmbBotCommand = $g_iCmbBotCommand
	EndIf

	$g_bMeetCondStop = False ; reset flags so bot can restart farming when conditions change.
	$g_bTrainEnabled = True
	$g_bDonationEnabled = True
	Local $MaxTrophiesReached = False

	If $bChkBotStop Then

		If $iCmbBotCond < 15 Then
			isGoldFull()
			isElixirFull()
			isDarkElixirFull()
		ElseIf $g_bSearchReductionStorageEnable Then
			isGoldFull(True)
			isElixirFull(True)
			isDarkElixirFull(True)
		EndIf

		If isTrophyMax() Then $MaxTrophiesReached = True

		If $iCmbBotCond = 15 And $g_iCmbHoursStop <> 0 Then $TimeToStop = $g_iCmbHoursStop * 3600000 ; 3600000 = 1 Hours

		Switch $iCmbBotCond
			Case 0
				If $g_abFullStorage[$eLootGold] And $g_abFullStorage[$eLootElixir] And $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 1
				If ($g_abFullStorage[$eLootGold] And $g_abFullStorage[$eLootElixir]) Or $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 2
				If ($g_abFullStorage[$eLootGold] Or $g_abFullStorage[$eLootElixir]) And $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 3
				If $g_abFullStorage[$eLootGold] Or $g_abFullStorage[$eLootElixir] Or $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 4
				If $g_abFullStorage[$eLootGold] And $g_abFullStorage[$eLootElixir] Then $g_bMeetCondStop = True
			Case 5
				If $g_abFullStorage[$eLootGold] Or $g_abFullStorage[$eLootElixir] Or $g_abFullStorage[$eLootDarkElixir] Then $g_bMeetCondStop = True
			Case 6
				If $g_abFullStorage[$eLootGold] And $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 7
				If $g_abFullStorage[$eLootElixir] And $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 8
				If $g_abFullStorage[$eLootGold] Or $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 9
				If $g_abFullStorage[$eLootElixir] Or $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 10
				If $g_abFullStorage[$eLootGold] Then $g_bMeetCondStop = True
			Case 11
				If $g_abFullStorage[$eLootElixir] Then $g_bMeetCondStop = True
			Case 12
				If $MaxTrophiesReached Then $g_bMeetCondStop = True
			Case 13
				If $g_abFullStorage[$eLootDarkElixir] Then $g_bMeetCondStop = True
			Case 14
				If $g_abFullStorage[$eLootGold] And $g_abFullStorage[$eLootElixir] And $g_abFullStorage[$eLootDarkElixir] Then $g_bMeetCondStop = True
			Case 15 ; Bot running for...
				If Round(__TimerDiff($g_hTimerSinceStarted)) > $TimeToStop Then $g_bMeetCondStop = True
			Case 16 ; Train/Donate Only
				$g_bMeetCondStop = True
			Case 17 ; Donate Only
				$g_bMeetCondStop = True
				$g_bTrainEnabled = False
			Case 18 ; Only stay online
				$g_bMeetCondStop = True
				$g_bTrainEnabled = False
				$g_bDonationEnabled = False
			Case 19 ; Have shield - Online/Train/Collect/Donate
				If $g_bWaitShield = True Then $g_bMeetCondStop = True
			Case 20 ; Have shield - Online/Collect/Donate
				If $g_bWaitShield = True Then
					$g_bMeetCondStop = True
					$g_bTrainEnabled = False
				EndIf
			Case 21 ; Have shield - Online/Collect
				If $g_bWaitShield = True Then
					$g_bMeetCondStop = True
					$g_bTrainEnabled = False
					$g_bDonationEnabled = False
				EndIf
			Case 22 ; At certain time in the day
				Local $bResume = ($iCmbBotCommand = 0)
				If StopAndResumeTimer($bResume) Then $g_bMeetCondStop = True
			Case 23 ; When star bonus unavailable
				$g_bMeetCondStop = True
		EndSwitch

		If $g_bMeetCondStop Then

			Switch $iCmbBotCommand
				Case 0
					If (($iCmbBotCond <= 14 And $g_bCollectStarBonus) Or $iCmbBotCond = 23) And StarBonusSearch() Then
						If Not IsCCTreasuryFull() And Not $MaxTrophiesReached Then
							Return False
						EndIf
					ElseIf $iCmbBotCond = 23 Then
						SetLog("Star bonus unavailable.", $COLOR_DEBUG)
					EndIf
					If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
						_ClanGames()
						If $IsCGEventRunning And Not $g_bIsBBevent Then
							SetLog("Clan Games Challenge Running, Don't Halt Attack.", $COLOR_SUCCESS)
							Return False
						EndIf
					EndIf
					If Not $g_bDonationEnabled Then
						SetLog("Halt Attack, Stay Online/Collect", $COLOR_INFO)
					ElseIf Not $g_bTrainEnabled Then
						SetLog("Halt Attack, Stay Online/Collect/Donate", $COLOR_INFO)
					Else
						SetLog("Halt Attack, Stay Online/Train/Collect/Donate", $COLOR_INFO)
					EndIf
					$g_iCommandStop = 0 ; Halt Attack
					If _Sleep($DELAYBOTCOMMAND1) Then Return
				Case 1
					If $iCmbBotCond = 23 And StarBonusSearch() Then
						If Not IsCCTreasuryFull() Then
							Return False
						EndIf
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					Else
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								If $iCmbBotCond = 23 Then SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
						SetLog(($iCmbBotCond = 23 ? "Star bonus unavailable. " : "") & "Bot Will Stop After Routines", $COLOR_DEBUG)
						$IsToCheckBeforeStop = True
						Sleep(Random(3500, 5500, 1))
						If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
							UpgradeWall()
							If _Sleep($DELAYRUNBOT3) Then Return
							UpgradeBuilding()
							If _Sleep($DELAYRUNBOT3) Then Return
							AutoUpgrade()
							If _Sleep($DELAYRUNBOT3) Then Return
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							EndIf
						Else
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							EndIf
						EndIf
						_ArrayShuffle($aRndFuncList)
						For $Index In $aRndFuncList
							_RunFunction($Index)
						Next
						If _Sleep(1000) Then Return
						DailyChallenges()
						If _Sleep(1000) Then Return
						CollectCCGold()
						If SwitchBetweenBasesMod2() Then
							ForgeClanCapitalGold()
							_Sleep($DELAYRUNBOT3)
							AutoUpgradeCC()
							_Sleep($DELAYRUNBOT3)
						EndIf
						If _Sleep($DELAYRUNBOT3) Then Return
						VillageReport()
					EndIf
					If $g_bNotifyStopBot Then
						If $iCmbBotCond = 23 Then
							NotifyWhenStop("StopStar")
						Else
							NotifyWhenStop("Stop")
						EndIf
					EndIf
					Sleep(Random(3500, 5500, 1))
					CloseCoC(False)
					Sleep(Random(1500, 2500, 1))
					SetLog("MyBot.run Bot Stop as requested", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Return True
				Case 2
					If $iCmbBotCond = 23 And StarBonusSearch() Then
						If Not IsCCTreasuryFull() Then
							Return False
						EndIf
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					Else
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								If $iCmbBotCond = 23 Then SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
						SetLog(($iCmbBotCond = 23 ? "Star bonus unavailable. " : "") & "Bot Will Be Closed After Routines", $COLOR_DEBUG)
						$IsToCheckBeforeStop = True
						Sleep(Random(3500, 5500, 1))
						If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
							UpgradeWall()
							If _Sleep($DELAYRUNBOT3) Then Return
							UpgradeBuilding()
							If _Sleep($DELAYRUNBOT3) Then Return
							AutoUpgrade()
							If _Sleep($DELAYRUNBOT3) Then Return
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							EndIf
						Else
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							EndIf
						EndIf
						_ArrayShuffle($aRndFuncList)
						For $Index In $aRndFuncList
							_RunFunction($Index)
						Next
						If _Sleep(1000) Then Return
						DailyChallenges()
						If _Sleep(1000) Then Return
						CollectCCGold()
						If SwitchBetweenBasesMod2() Then
							ForgeClanCapitalGold()
							_Sleep($DELAYRUNBOT3)
							AutoUpgradeCC()
							_Sleep($DELAYRUNBOT3)
						EndIf
					EndIf
					If $g_bNotifyStopBot Then
						If $iCmbBotCond = 23 Then
							NotifyWhenStop("CloseBotStar")
						Else
							NotifyWhenStop("CloseBot")
						EndIf
					EndIf
					SetLog("MyBot.run Close Bot as requested", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 3
					If $iCmbBotCond = 23 And StarBonusSearch() Then
						If Not IsCCTreasuryFull() Then
							Return False
						EndIf
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					Else
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								If $iCmbBotCond = 23 Then SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
						SetLog(($iCmbBotCond = 23 ? "Star bonus unavailable. " : "") & "Android And Bot Will Stop After Routines", $COLOR_DEBUG)
						$IsToCheckBeforeStop = True
						Sleep(Random(3500, 5500, 1))
						If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
							UpgradeWall()
							If _Sleep($DELAYRUNBOT3) Then Return
							UpgradeBuilding()
							If _Sleep($DELAYRUNBOT3) Then Return
							AutoUpgrade()
							If _Sleep($DELAYRUNBOT3) Then Return
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							EndIf
						Else
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							EndIf
						EndIf
						_ArrayShuffle($aRndFuncList)
						For $Index In $aRndFuncList
							_RunFunction($Index)
						Next
						If _Sleep(1000) Then Return
						DailyChallenges()
						If _Sleep(1000) Then Return
						CollectCCGold()
						If SwitchBetweenBasesMod2() Then
							ForgeClanCapitalGold()
							_Sleep($DELAYRUNBOT3)
							AutoUpgradeCC()
							_Sleep($DELAYRUNBOT3)
						EndIf
					EndIf
					If $g_bNotifyStopBot Then
						If $iCmbBotCond = 23 Then
							NotifyWhenStop("CloseANBStar")
						Else
							NotifyWhenStop("CloseANB")
						EndIf
					EndIf
					SetLog("Close Android and Bot as requested", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					CloseAndroid("BotCommand")
					BotClose()
					Return True ; HaHa - No Return possible!
				Case 4
					If $iCmbBotCond = 23 And StarBonusSearch() Then
						If Not IsCCTreasuryFull() Then
							Return False
						EndIf
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					Else
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								If $iCmbBotCond = 23 Then SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
						SetLog(($iCmbBotCond = 23 ? "Star bonus unavailable. " : "") & "Computer Will ShutDown After Routines", $COLOR_DEBUG)
						$IsToCheckBeforeStop = True
						Sleep(Random(3500, 5500, 1))
						If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
							UpgradeWall()
							If _Sleep($DELAYRUNBOT3) Then Return
							UpgradeBuilding()
							If _Sleep($DELAYRUNBOT3) Then Return
							AutoUpgrade()
							If _Sleep($DELAYRUNBOT3) Then Return
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							EndIf
						Else
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							EndIf
						EndIf
						_ArrayShuffle($aRndFuncList)
						For $Index In $aRndFuncList
							_RunFunction($Index)
						Next
						If _Sleep(1000) Then Return
						DailyChallenges()
						If _Sleep(1000) Then Return
						CollectCCGold()
						If SwitchBetweenBasesMod2() Then
							ForgeClanCapitalGold()
							_Sleep($DELAYRUNBOT3)
							AutoUpgradeCC()
							_Sleep($DELAYRUNBOT3)
						EndIf
					EndIf
					If $g_bNotifyStopBot Then
						If $iCmbBotCond = 23 Then
							NotifyWhenStop("ShutdownStar")
						Else
							NotifyWhenStop("Shutdown")
						EndIf
					EndIf
					SetLog("Force Shutdown of Computer", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Shutdown(BitOR($SD_SHUTDOWN, $SD_FORCE)) ; Force Shutdown
					Return True ; HaHa - No Return possible!
				Case 5
					If $iCmbBotCond = 23 And StarBonusSearch() Then
						If Not IsCCTreasuryFull() Then
							Return False
						EndIf
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					Else
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								If $iCmbBotCond = 23 Then SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
						SetLog(($iCmbBotCond = 23 ? "Star bonus unavailable. " : "") & "Computer Will Sleep After Routines", $COLOR_DEBUG)
						$IsToCheckBeforeStop = True
						Sleep(Random(3500, 5500, 1))
						If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
							UpgradeWall()
							If _Sleep($DELAYRUNBOT3) Then Return
							UpgradeBuilding()
							If _Sleep($DELAYRUNBOT3) Then Return
							AutoUpgrade()
							If _Sleep($DELAYRUNBOT3) Then Return
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							EndIf
						Else
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							EndIf
						EndIf
						_ArrayShuffle($aRndFuncList)
						For $Index In $aRndFuncList
							_RunFunction($Index)
						Next
						If _Sleep(1000) Then Return
						DailyChallenges()
						If _Sleep(1000) Then Return
						CollectCCGold()
						If SwitchBetweenBasesMod2() Then
							ForgeClanCapitalGold()
							_Sleep($DELAYRUNBOT3)
							AutoUpgradeCC()
							_Sleep($DELAYRUNBOT3)
						EndIf
					EndIf
					If $g_bNotifyStopBot Then
						If $iCmbBotCond = 23 Then
							NotifyWhenStop("CPUSleepStar")
						Else
							NotifyWhenStop("CPUSleep")
						EndIf
					EndIf
					SetLog("Computer Sleep Mode Start now", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Shutdown($SD_STANDBY) ; Sleep / Stand by
					Return True ; HaHa - No Return possible!
				Case 6
					If $iCmbBotCond = 23 And StarBonusSearch() Then
						If Not IsCCTreasuryFull() Then
							Return False
						EndIf
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					Else
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								If $iCmbBotCond = 23 Then SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
						SetLog(($iCmbBotCond = 23 ? "Star bonus unavailable. " : "") & "Computer Will Reboot After Routines", $COLOR_DEBUG)
						$IsToCheckBeforeStop = True
						Sleep(Random(3500, 5500, 1))
						If $g_bAutoUpgradeWallsEnable And $g_bChkWallUpFirst Then
							UpgradeWall()
							If _Sleep($DELAYRUNBOT3) Then Return
							UpgradeBuilding()
							If _Sleep($DELAYRUNBOT3) Then Return
							AutoUpgrade()
							If _Sleep($DELAYRUNBOT3) Then Return
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'Laboratory', 'UpgradeHeroes', _
										'PetHouse', 'Blacksmith']
							EndIf
						Else
							If IsToFillCCWithMedalsOnly() Then
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							Else
								Local $aRndFuncList = ['CleanYard', 'DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', _
										'UpgradeBuilding', 'PetHouse', 'Blacksmith']
							EndIf
						EndIf
						_ArrayShuffle($aRndFuncList)
						For $Index In $aRndFuncList
							_RunFunction($Index)
						Next
						If _Sleep(1000) Then Return
						DailyChallenges()
						If _Sleep(1000) Then Return
						CollectCCGold()
						If SwitchBetweenBasesMod2() Then
							ForgeClanCapitalGold()
							_Sleep($DELAYRUNBOT3)
							AutoUpgradeCC()
							_Sleep($DELAYRUNBOT3)
						EndIf
					EndIf
					If $g_bNotifyStopBot Then
						If $iCmbBotCond = 23 Then
							NotifyWhenStop("RebootingStar")
						Else
							NotifyWhenStop("Rebooting")
						EndIf
					EndIf
					SetLog("Rebooting Computer", $COLOR_INFO)
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Shutdown(BitOR($SD_REBOOT, $SD_FORCE)) ; Reboot
					Return True ; HaHa - No Return possible!
				Case 7
					If $iCmbBotCond = 23 And StarBonusSearch() Then
						If Not IsCCTreasuryFull() Then
							Return False
						EndIf
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					ElseIf $iCmbBotCond = 23 Then
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Star bonus unavailable.", $COLOR_DEBUG)
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
						If ProfileSwitchAccountEnabled() Then
							Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
							If UBound($aActiveAccount) >= 2 Then
								GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_UNCHECKED)
								$g_iCommandStop = 1 ; Turn Idle
								checkSwitchAcc()
							Else
								SetLog("This is the last account to turn off. Stop bot now. Adios!", $COLOR_INFO)
								If _Sleep($DELAYBOTCOMMAND1) Then Return
								If $g_bNotifyStopBot Then
									NotifyWhenStop("StopStar")
								EndIf
								CloseCoC()
								Return True
							EndIf
						EndIf
					Else
						If $g_bChkForceAttackOnClanGamesWhenHalt And Not $g_bClanGamesCompleted Then
							_ClanGames(False, True)
							If $IsCGEventRunning Then
								SetLog("Clan Games Challenge Running, Finish it First.", $COLOR_ACTION)
								Return False
							EndIf
						EndIf
					EndIf
					If ProfileSwitchAccountEnabled() Then
						Local $aActiveAccount = _ArrayFindAll($g_abAccountNo, True)
						If UBound($aActiveAccount) >= 2 Then
							GUICtrlSetState($g_ahChkAccount[$g_iCurAccount], $GUI_UNCHECKED)
							$g_iCommandStop = 1 ; Turn Idle
							checkSwitchAcc()
						Else
							SetLog("This is the last account to turn off. Stop bot now. Adios!", $COLOR_INFO)
							If _Sleep($DELAYBOTCOMMAND1) Then Return
							If $g_bNotifyStopBot Then
								NotifyWhenStop("Stop")
							EndIf
							CloseCoC()
							Return True
						EndIf
					EndIf
			EndSwitch
		EndIf
	EndIf
	Return False
EndFunc   ;==>BotCommand

; #FUNCTION# ====================================================================================================================
; Name ..........: isTrophyMax
; Description ...:
; Syntax ........: isTrophyMax()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (2017-3)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func isTrophyMax()
	If Number($g_aiCurrentLoot[$eLootTrophy]) >= Number($g_iDropTrophyMax) Then
		SetLog("Max. Trophy Reached!", $COLOR_SUCCESS)
		If _Sleep($DELAYBOTCOMMAND1) Then Return
		$g_abFullStorage[$eLootTrophy] = True
	ElseIf $g_abFullStorage[$eLootTrophy] Then
		If Number($g_aiCurrentLoot[$eLootTrophy]) >= Number($g_aiResumeAttackLoot[$eLootTrophy]) Then
			SetLog("Trophy is still relatively high: " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootTrophy] = True
		Else
			SetLog("Switching back to normal when Trophy drops below " & $g_aiResumeAttackLoot[$eLootTrophy], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootTrophy] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootTrophy]
EndFunc   ;==>isTrophyMax

Func StopAndResumeTimer($bResume = False)

	Static $abStop[8] = [False, False, False, False, False, False, False, False]

	Local $iTimerStop, $iTimerResume = 25
	$iTimerStop = Number($g_iCmbTimeStop)
	If $bResume Then $iTimerResume = Number($g_iResumeAttackTime)
	Local $bCurrentStatus = $abStop[$g_iCurAccount]
	SetDebugLog("$iTimerStop: " & $iTimerStop & ", $iTimerResume: " & $iTimerResume & ", Max: " & _Max($iTimerStop, $iTimerResume) & ", Min: " & _Min($iTimerStop, $iTimerResume) & ", $bCurrentStatus: " & $bCurrentStatus)

	If @HOUR < _Min($iTimerStop, $iTimerResume) Then ; both timers are ahead.
		;Do nothing
	ElseIf @HOUR < _Max($iTimerStop, $iTimerResume) Then ; 1 timer has passed, 1 timer ahead
		If $iTimerStop < $iTimerResume Then ; reach Timer to Stop
			$abStop[$g_iCurAccount] = True
			If Not $bCurrentStatus Then SetLog("Timer to stop is set at: " & $iTimerStop & ":00hrs. It's time to stop!", $COLOR_SUCCESS)
		Else ; reach Timer to Resume
			$abStop[$g_iCurAccount] = False
			If $bCurrentStatus Then SetLog("Timer to resume attack is set at: " & $iTimerResume & ":00hrs. Resume attack now!", $COLOR_SUCCESS)
		EndIf
	Else ; passed both timers
		If $iTimerStop < $iTimerResume Then ; reach Timer to Stop
			$abStop[$g_iCurAccount] = False
			If $bCurrentStatus Then SetLog("Timer to resume attack is set at: " & $iTimerResume & ":00hrs. Resume attack now!", $COLOR_SUCCESS)
		Else
			$abStop[$g_iCurAccount] = True
			If Not $bCurrentStatus Then SetLog("Timer to stop is set at: " & $iTimerStop & ":00hrs. It's time to stop!", $COLOR_SUCCESS)
		EndIf
	EndIf
	SetDebugLog("@HOUR: " & @HOUR & ", $bCurrentStatus: " & $bCurrentStatus & ", $abStop[$g_iCurAccount]: " & $abStop[$g_iCurAccount])
	Return $abStop[$g_iCurAccount]
EndFunc   ;==>StopAndResumeTimer

Func IsCCTreasuryFull()
	If Not $g_bCCTreasuryFull Then
		SetLog("Star Bonus Available ! Continue Attacking...", $COLOR_SUCCESS1)
		Return False
	EndIf

	SetLog("Star Bonus Available ! Continue Attacking...", $COLOR_SUCCESS1)

	Local $CCTreasuryCheckTimerDiff = TimerDiff($TreasuryCheckChrono)
	If $TreasuryCheckChrono <> 0 Then
		If $CCTreasuryCheckTimerDiff < 2 * 60 * 60 * 1000 Then
			Switch $IsToCheckCCTreasury
				Case True
					Return False
				Case False
					Return True
			EndSwitch
		EndIf
	EndIf

	SetLog("Check If Treasury Is Full Or Not", $COLOR_INFO)

	ClickAway()
	If _Sleep($DELAYRESPOND) Then Return

	If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ;check for valid CC location
		SetLog("Need Clan Castle location for the Treasury, Please locate your Clan Castle.", $COLOR_WARNING)
		LocateClanCastle()
		If ($g_aiClanCastlePos[0] = "-1" Or $g_aiClanCastlePos[1] = "-1") Then ; can not assume CC was located due msgbox timeout and unattended bo, must verify
			SetLog("Treasury skipped, bad Clan Castle location", $COLOR_ERROR)
			If _Sleep($DELAYRESPOND) Then Return
			Return
		EndIf
	EndIf
	ClickAway()
	If _Sleep($DELAYCOLLECT3) Then Return
	BuildingClick($g_aiClanCastlePos[0], $g_aiClanCastlePos[1], "#0250") ; select CC
	If _Sleep($DELAYTREASURY2) Then Return
	Local $BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

	If $BuildingInfo[1] = "Clan Castle" Then
		SetDebugLog("Clan Castle Windows Is Open", $COLOR_DEBUG1)
	Else
		For $i = 1 To 10
			Local $NewX = Number($g_aiClanCastlePos[0] + (2 * $i))
			Local $NewY = Number($g_aiClanCastlePos[1] - (2 * $i))
			SetLog("Clan Castle Windows Didn't Open", $COLOR_DEBUG1)
			SetLog("New Try...", $COLOR_DEBUG1)
			ClickAway()
			If _Sleep(Random(1000, 1500, 1)) Then Return
			PureClickVisit($NewX, $NewY) ; select CC
			If _Sleep($DELAYBUILDINGINFO1) Then Return

			$BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

			If $BuildingInfo[1] = "Clan Castle" Then ExitLoop
			ClickAway()
			$NewX = Number($g_aiClanCastlePos[0] - (2 * $i))
			$NewY = Number($g_aiClanCastlePos[1] + (2 * $i))
			If _Sleep(Random(1000, 1500, 1)) Then Return
			PureClickVisit($NewX, $NewY) ; select CC
			If _Sleep($DELAYBUILDINGINFO1) Then Return

			$BuildingInfo = BuildingInfo(242, 468 + $g_iBottomOffsetY)

			If $BuildingInfo[1] = "Clan Castle" Then ExitLoop
		Next
	EndIf

	If _Sleep($DELAYTREASURY2) Then Return
	Local $aTreasuryButton = findButton("Treasury", Default, 1, True)
	If IsArray($aTreasuryButton) And UBound($aTreasuryButton, 1) = 2 Then
		If IsMainPage() Then ClickP($aTreasuryButton, 1, 0, "#0330")
		If _Sleep($DELAYTREASURY1) Then Return
	Else
		SetLog("Cannot find the Treasury Button", $COLOR_ERROR)
	EndIf

	If _CheckPixel($aReceivedTroopsTreasury, True) Then ; Found the "You have received" Message on Screen, wait till its gone.
		SetDebugLog("Detected Clan Castle Message Blocking Treasury Window. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		Local $Safetyexit = 0
		While _CheckPixel($aReceivedTroopsTreasury, True)
			If _Sleep($DELAYTRAIN1) Then Return
			$Safetyexit = $Safetyexit + 1
			If $Safetyexit > 60 Then ExitLoop  ;If waiting longer than 1 min, something is wrong
		WEnd
	EndIf

	If Not _WaitForCheckPixel($aTreasuryWindow, $g_bCapturePixel, Default, "Wait treasury window:") Then
		SetLog("Treasury window not found!", $COLOR_ERROR)
		Return
	EndIf

	Local $IsTreasuryFull = False
	Local $aFullCCBar = QuickMIS("CNX", $g_sImgFullCCRes, 658, 200 + $g_iMidOffsetY, 710, 315 + $g_iMidOffsetY)
	If IsArray($aFullCCBar) And UBound($aFullCCBar) > 0 Then
		SetDebugLog("CC full bars found = " & Number(UBound($aFullCCBar)), $COLOR_DEBUG)
		If Number(UBound($aFullCCBar)) = 3 Then $IsTreasuryFull = True
	EndIf

	$TreasuryCheckChrono = TimerInit()
	If _Sleep(200) Then Return
	CloseWindow()

	If $IsTreasuryFull Then
		SetLog("Clan Castle Treasury is Full !", $COLOR_WARNING)
		SetLog("Bot Won't Attack For Star Bonus", $COLOR_DEBUG)
		$IsToCheckCCTreasury = False
		Return True
	Else
		SetLog("Clan Castle Treasury is Not Full !", $COLOR_WARNING)
		SetLog("Bot Will Attack For Star Bonus", $COLOR_SUCCESS1)
		$IsToCheckCCTreasury = True
		Return False
	EndIf
EndFunc   ;==>IsCCTreasuryFull
