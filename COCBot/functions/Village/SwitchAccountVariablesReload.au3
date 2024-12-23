; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchAccountVariablesReload
; Description ...: This file contains the Sequence that runs all MBR Bot
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchAccountVariablesReload($sType = "Load", $iAccount = $g_iCurAccount)

	; Empty arrays
	Local $aiZero[8] = [0, 0, 0, 0, 0, 0, 0, 0], $aiTrue[8] = [1, 1, 1, 1, 1, 1, 1, 1], $aiMinus[8] = [-1, -1, -1, -1, -1, -1, -1, -1]
	Local $aiZero82[8][2] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
	Local $aiZero83[8][3] = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]
	Local $aiZero84[8][4] = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
	Local $aiZero85[8][5] = [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
	Local $asEmpty[8] = ["", "", "", "", "", "", "", ""]
	Local $aiZeroTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiZeroSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiMinusOneTrue[8][2] = [[-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True]]
	Local $aiNonAvailable[8] = ["N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A", "N/A"]

	; FirstRun
	Static $abFirstStart = $aiTrue
	Static $aiFirstRun = $aiTrue
	Static $gSbFirstStartForAll = $aiZero
	Static $gSbFirstStartAccountFMI = $aiZero
	Static $gSbFirstStartAccountSBB = $aiZero
	Static $gSbFirstStartAccountSBB2 = $aiZero
	Static $gSbFirstStartAccountCGRA = $aiZero
	Static $gSbFirstStartForLab = $aiZero
	Static $gSbFirstStartForPetHouse = $aiZero
	Static $gSbFirstStartForStarLab = $aiZero

	;Mods
	Static $SLootCartTimer = $aiZero
	Static $SLootCartFrequency = $aiZero
	Static $SIsToOpenOffers = $aiZero
	Static $SDelayReturnedtocheckCGRA = $aiZero
	Static $SCGRACheckTimer = $aiZero
	Static $SIsStatusForCG = $aiZero
	Static $SIstoSwitchMod = $aiZero
	Static $SBBaseCheckTimer = $aiZero
	Static $SDelayReturnedtocheckBBaseMS = $aiZero
	Static $SCCBaseCheckTimer = $aiZero
	Static $SiLastTimeCCRaidChecked = $aiZero
	Static $SDelayReturnedtocheckCCBaseMS = $aiZero
	Static $SIstoRecheckTrader = $aiZero
	Static $SIsdroptrophiesActive = $aiZero
	Static $SIsDropTrophyBreaked = $aiZero

	; Bottom & Multi-Stats
	Static $aiSkippedVillageCount = $aiZero
	Static $aiAttackedCount = $aiZero

	; Gain Stats
	Static $aiStatsTotalGain = $aiZero84, $aiStatsStartedWith = $aiZero84, $aiStatsLastAttack = $aiZero84, $aiStatsBonusLast = $aiZero84

	;Humanization
	Static $gSiTimerBoostBuilders = $aiZero
	Static $gSCCWaitChrono = $aiZero

	;Super Troops Boost
	Static $gSbFirstStartBarrel = $aiTrue
	Static $SMaxTroopsToBoost = $aiZero
	Static $SiCmbSuperTroopsThird = $aiZero

	;Clan Capital
	Static $gSiLootCCGold = $aiZero
	Static $gSiLootCCMedal = $aiZero
	Static $gSiCCTrophies = $aiZero
	Static $IsSRaidRunning = $aiZero
	Static $SAllCCRaidAttacksDone = $aiZero
	Static $gSiRank = $asEmpty
	Static $SIsCCGoldJustCollected = $aiZero
	Static $SIsCCGoldJustCollectedDChallenge = $aiZero

	;Builders Base
	Static $gSaiCurrentLootBB = $aiZero83
	Static $gSiFreeBuilderCountBB = $aiZero
	Static $gSiTotalBuilderCountBB = $aiZero
	Static $g_SIsBuilderJarAvl = $aiTrue

	; Misc Stats
	Static $aiNbrOfOoS = $aiZero
	Static $aiDroppedTrophyCount = $aiZero
	Static $aiSearchCost = $aiZero, $aiTrainCostElixir = $aiZero, $aiTrainCostDElixir = $aiZero, $aiTrainCostGold = $aiZero ; search and train troops cost
	Static $aiGoldFromMines = $aiZero, $aiElixirFromCollectors = $aiZero, $aiDElixirFromDrills = $aiZero ; number of resources gain by collecting mines, collectors, drills
	Static $aiCostGoldWall = $aiZero, $aiCostElixirWall = $aiZero, $aiCostGoldBuilding = $aiZero, $aiCostElixirBuilding = $aiZero, $aiCostDElixirBuilding = $aiZero, $aiCostDElixirHero = $aiZero, $aiCostElixirWarden = $aiZero ; wall, building and hero upgrade costs
	Static $aiNbrOfWallsUppedGold = $aiZero, $aiNbrOfWallsUppedElixir = $aiZero, $aiNbrOfBuildingsUppedGold = $aiZero, $aiNbrOfBuildingsUppedElixir = $aiZero, $aiNbrOfBuildingsUppedDElixir = $aiZero, $aiNbrOfHeroesUpped = $aiZero, $aiNbrOfWardenUpped = $aiZero ; number of wall, building, hero upgrades with gold, elixir, delixir
	Static $aiNbrOfWallsUpped = $aiZero

	; Attack Stats
	Static $aiAttackedVillageCount = $aiZero83 ; number of attack villages for DB, LB, TB
	Static $aiTotalGoldGain = $aiZero83, $aiTotalElixirGain = $aiZero83, $aiTotalDarkGain = $aiZero83, $aiTotalTrophyGain = $aiZero83 ; total resource gains for DB, LB, TB
	Static $aiNbrOfDetectedMines = $aiZero83, $aiNbrOfDetectedCollectors = $aiZero83, $aiNbrOfDetectedDrills = $aiZero83 ; number of mines, collectors, drills detected for DB, LB, TB
	Static $aiSmartZapGain = $aiZero, $aiNumEQSpellsUsed = $aiZero, $aiNumLSpellsUsed = $aiZero ; smart zap

	; Labs time
	Static $asLabUpgradeTime = $asEmpty, $aiLabStatus = $aiZero, $aiLabElixirCost = $aiZero, $aiLabDElixirCost = $aiZero
	Static $asPetLabUpgradeTime = $asEmpty, $aiPetStatus = $aiZero, $asiMinDark4PetUpgrade = $aiZero
	Static $asStarLabUpgradeTime = $asEmpty
	Static $asBSUpgradeTime = $asEmpty
	Static $SIsResearchPotInStock = $aiZero
	Static $SIsPetPotInStock = $aiZero
	Static $SIsBOFJustCollected = $aiZero
	Static $SIsBOSJustCollected = $aiZero
	Static $SIsResPotJustCollected = $aiZero
	Static $SIsPetPotJustCollected = $aiZero
	Static $SIsAutoForgeSlotJustCollected = $aiZero

	; BlackSmith
	Static $asBSmithUpgradeTime = $asEmpty

	;Event
	Static $SIsOresJustCollected = $aiZero

	; Hero State
	Static $aiHeroAvailable = $aiZero
	Static $aiHeroUpgradingBit = $aiZero
	Static $aiHeroUpgrading = $aiZero83
	Static $aiFirstStartForHiddenHero = $aiTrue
	Static $g_aiSHeroUpgradeFinishDate = $aiZero85
	Static $g_aiSHeroNeededResource = $aiZero85
	Static $bSCheckValuesForWarden = $aiZero

	; Other global status
	Static $aiCommandStop = $aiMinus
	Static $aiAllBarracksUpgd = $aiZero

	Static $abFullStorage = $aiZero84
	Static $aiBuilderBoostDiscount = $aiZero

	Static $abNotNeedAllTime0 = $aiTrue
	Static $abNotNeedAllTime1 = $aiTrue
	Static $SbControlCCMedal = $aiZero

	;Daily Challenge
	Static $gaSsNewChallengeTime = $aiZero

	;Clan Games
	Static $Sg_sClanGamesScore = $aiNonAvailable
	Static $Sg_sClanGamesTimeRemaining = $aiNonAvailable
	Static $SYourAccScore = $aiMinusOneTrue
	Static $gSbClanGamesCompleted = $aiZero
	Static $gSaiAttackedCGCount = $aiZero
	Static $IsSReachedMaxCGDayAttack = $aiZero
	Static $iSRandomAttackCGCountToday = $aiZero
	Static $gSbIsBBevent = $aiZero
	Static $SIsCGEventRunning = $aiZero
	Static $Sb_COCClose = $aiTrue
	Static $Sg_hCoolDownTimer = $aiZero

	;StarBonus
	Static $SStarBonusReceived = $aiZero83

	;Builder's Apprentice
	Static $gaSsAvailableAppBuilder = $aiZero
	Static $aSTimeDiffAppBuilder = $aiZero

	;Lab Assistant
	Static $gaSsAvailableLabAssistant = $aiZero
	Static $aSTimeDiffLabAssistant = $aiZero
	Static $SbLabAssistantUsedTime = $aiZero

	;Magic Snack (Clan Castle Timer)
	Static $SClanCastleCakeTimer = $aiZero

	; First time switch account
	Switch $sType
		Case "Reset"
			$abFirstStart = $aiTrue
			$aiFirstRun = $aiTrue
			$gSbFirstStartForAll = $aiZero
			$gSbFirstStartAccountFMI = $aiZero
			$gSbFirstStartAccountSBB = $aiZero
			$gSbFirstStartAccountSBB2 = $aiZero
			$gSbFirstStartAccountCGRA = $aiZero
			$gSbFirstStartForLab = $aiZero
			$gSbFirstStartForPetHouse = $aiZero
			$gSbFirstStartForStarLab = $aiZero

			;Mods
			$SLootCartTimer = $aiZero
			$SLootCartFrequency = $aiZero
			$SIsToOpenOffers = $aiZero
			$SDelayReturnedtocheckCGRA = $aiZero
			$SCGRACheckTimer = $aiZero
			$SIsStatusForCG = $aiZero
			$SIstoSwitchMod = $aiZero
			$SBBaseCheckTimer = $aiZero
			$SDelayReturnedtocheckBBaseMS = $aiZero
			$SCCBaseCheckTimer = $aiZero
			$SiLastTimeCCRaidChecked = $aiZero
			$SDelayReturnedtocheckCCBaseMS = $aiZero
			$SIstoRecheckTrader = $aiZero
			$SIsdroptrophiesActive = $aiZero
			$SIsDropTrophyBreaked = $aiZero

			$g_asTrainTimeFinish = $asEmpty
			For $i = 0 To 7
				GUICtrlSetData($g_ahLblTroopTime[$i], "")
				GUICtrlSetData($g_ahLblTroopTimeRep[$i], "")
			Next
			$g_ahTimerSinceSwitched = $aiZero
			$g_ahTimerSinceSwitched[$iAccount] = $g_hTimerSinceStarted

			; Multi-Stats
			$aiSkippedVillageCount = $aiZero
			$aiAttackedCount = $aiZero

			; Gain Stats
			$aiStatsTotalGain = $aiZero84
			$aiStatsStartedWith = $aiZero84
			$aiStatsLastAttack = $aiZero84
			$aiStatsBonusLast = $aiZero84

			; Misc Stats
			$aiNbrOfOoS = $aiZero
			$aiDroppedTrophyCount = $aiZero
			$aiSearchCost = $aiZero
			$aiTrainCostElixir = $aiZero
			$aiTrainCostDElixir = $aiZero
			$aiTrainCostGold = $aiZero
			$aiGoldFromMines = $aiZero
			$aiElixirFromCollectors = $aiZero
			$aiDElixirFromDrills = $aiZero

			$aiCostGoldWall = $aiZero
			$aiCostElixirWall = $aiZero
			$aiCostGoldBuilding = $aiZero
			$aiCostElixirBuilding = $aiZero
			$aiCostDElixirBuilding = $aiZero
			$aiCostDElixirHero = $aiZero
			$aiCostElixirWarden = $aiZero
			$aiNbrOfWallsUppedGold = $aiZero
			$aiNbrOfWallsUppedElixir = $aiZero
			$aiNbrOfBuildingsUppedGold = $aiZero
			$aiNbrOfBuildingsUppedElixir = $aiZero
			$aiNbrOfBuildingsUppedDElixir = $aiZero
			$aiNbrOfHeroesUpped = $aiZero
			$aiNbrOfWardenUpped = $aiZero
			$aiNbrOfWallsUpped = $aiZero

			; Attack Stats
			$aiAttackedVillageCount = $aiZero83
			$aiTotalGoldGain = $aiZero83
			$aiTotalElixirGain = $aiZero83
			$aiTotalDarkGain = $aiZero83
			$aiTotalTrophyGain = $aiZero83
			$aiNbrOfDetectedMines = $aiZero83
			$aiNbrOfDetectedCollectors = $aiZero83
			$aiNbrOfDetectedDrills = $aiZero83
			$aiSmartZapGain = $aiZero
			$aiNumEQSpellsUsed = $aiZero
			$aiNumLSpellsUsed = $aiZero

			; Labs time
			$asLabUpgradeTime = $asEmpty
			$aiLabElixirCost = $aiZero
			$aiLabDElixirCost = $aiZero
			$aiLabStatus = $aiZero
			$asPetLabUpgradeTime = $asEmpty
			$aiPetStatus = $aiZero
			$asiMinDark4PetUpgrade = $asEmpty
			$asStarLabUpgradeTime = $asEmpty
			$asBSUpgradeTime = $asEmpty
			$SIsResearchPotInStock = $aiZero
			$SIsPetPotInStock = $aiZero
			$SIsBOFJustCollected = $aiZero
			$SIsBOSJustCollected = $aiZero
			$SIsResPotJustCollected = $aiZero
			$SIsPetPotJustCollected = $aiZero
			$SIsAutoForgeSlotJustCollected = $aiZero

			; BlackSmith
			$asBSmithUpgradeTime = $asEmpty

			;Event
			$SIsOresJustCollected = $aiZero

			;Daily Challenge
			$gaSsNewChallengeTime = $aiZero

			;Clan Games
			$Sg_sClanGamesScore = $aiNonAvailable
			$Sg_sClanGamesTimeRemaining = $aiNonAvailable
			$SYourAccScore = $aiMinusOneTrue
			$gSbClanGamesCompleted = $aiZero
			$gSaiAttackedCGCount = $aiZero
			$IsSReachedMaxCGDayAttack = $aiZero
			$iSRandomAttackCGCountToday = $aiZero
			$gSbIsBBevent = $aiZero
			$SIsCGEventRunning = $aiZero
			$Sb_COCClose = $aiTrue
			$Sg_hCoolDownTimer = $aiZero

			;StarBonus
			$SStarBonusReceived = $aiZero83

			; Hero State
			$aiHeroAvailable = $aiZero
			$aiHeroUpgradingBit = $aiZero
			$aiHeroUpgrading = $aiZero83
			$aiFirstStartForHiddenHero = $aiTrue
			$g_aiSHeroUpgradeFinishDate = $aiZero85
			$g_aiSHeroNeededResource = $aiZero85
			$bSCheckValuesForWarden = $aiZero

			; Other global status
			$aiCommandStop = $aiMinus
			$aiAllBarracksUpgd = $aiZero
			$abFullStorage = $aiZero84
			$aiBuilderBoostDiscount = $aiZero
			$abNotNeedAllTime0 = $aiTrue
			$abNotNeedAllTime1 = $aiTrue
			$SbControlCCMedal = $aiZero

			;Humanization
			$gSiTimerBoostBuilders = $aiZero
			$gSCCWaitChrono = $aiZero

			;Super Troops Boost
			$gSbFirstStartBarrel = $aiTrue
			$SMaxTroopsToBoost = $aiZero
			$SiCmbSuperTroopsThird = $aiZero

			;Clan Capital
			$gSiLootCCGold = $aiZero
			$gSiLootCCMedal = $aiZero
			$gSiCCTrophies = $aiZero
			$IsSRaidRunning = $aiZero
			$SAllCCRaidAttacksDone = $aiZero
			$gSiRank = $asEmpty
			$SIsCCGoldJustCollected = $aiZero
			$SIsCCGoldJustCollectedDChallenge = $aiZero

			;Builders Base
			$gSaiCurrentLootBB = $aiZero83
			$gSiFreeBuilderCountBB = $aiZero
			$gSiTotalBuilderCountBB = $aiZero
			$g_SIsBuilderJarAvl = $aiTrue

			;Builder's Apprentice
			$gaSsAvailableAppBuilder = $aiZero
			$aSTimeDiffAppBuilder = $aiZero

			;Lab Assistant
			$gaSsAvailableLabAssistant = $aiZero
			$aSTimeDiffLabAssistant = $aiZero
			$SbLabAssistantUsedTime = $aiZero

			;Magic Snack (Clan Castle Timer)
			$SClanCastleCakeTimer = $aiZero

		Case "Save"
			$abFirstStart[$iAccount] = $g_bFirstStart
			$aiFirstRun[$iAccount] = $g_iFirstRun
			$gSbFirstStartForAll[$iAccount] = $g_bFirstStartCheckDone
			$gSbFirstStartAccountFMI[$iAccount] = $g_bFirstStartAccountFMI
			$gSbFirstStartAccountSBB[$iAccount] = $g_bFirstStartAccountSBB
			$gSbFirstStartAccountSBB2[$iAccount] = $g_bFirstStartAccountSBB2
			$gSbFirstStartAccountCGRA[$iAccount] = $g_bFirstStartAccountCGRA
			$gSbFirstStartForLab[$iAccount] = $g_bFirstStartForLab
			$gSbFirstStartForPetHouse[$iAccount] = $g_bFirstStartForPetHouse
			$gSbFirstStartForStarLab[$iAccount] = $g_bFirstStartForStarLab

			;Mods
			$SLootCartTimer[$iAccount] = $LootCartTimer
			$SLootCartFrequency[$iAccount] = $LootCartFrequency
			$SIsToOpenOffers[$iAccount] = $IsToOpenOffers
			$SDelayReturnedtocheckCGRA[$iAccount] = $DelayReturnedtocheckCGRA
			$SCGRACheckTimer[$iAccount] = $CGRACheckTimer
			$SIsStatusForCG[$iAccount] = $IsStatusForCG
			$SIstoSwitchMod[$iAccount] = $IstoSwitchMod
			$SBBaseCheckTimer[$iAccount] = $BBaseCheckTimer
			$SDelayReturnedtocheckBBaseMS[$iAccount] = $DelayReturnedtocheckBBaseMS
			$SCCBaseCheckTimer[$iAccount] = $CCBaseCheckTimer
			$SiLastTimeCCRaidChecked[$iAccount] = $iLastTimeCCRaidChecked
			$SDelayReturnedtocheckCCBaseMS[$iAccount] = $DelayReturnedtocheckCCBaseMS
			$SIstoRecheckTrader[$iAccount] = $IstoRecheckTrader
			$SIsdroptrophiesActive[$iAccount] = $IsdroptrophiesActive
			$SIsDropTrophyBreaked[$iAccount] = $IsDropTrophyBreaked

			; Multi-Stats
			$aiSkippedVillageCount[$iAccount] = $g_iSkippedVillageCount
			$aiAttackedCount[$iAccount] = $g_aiAttackedCount

			; Gain Stats
			For $i = 0 To 3
				$aiStatsTotalGain[$iAccount][$i] = $g_iStatsTotalGain[$i]
				$aiStatsStartedWith[$iAccount][$i] = $g_iStatsStartedWith[$i]
				$aiStatsLastAttack[$iAccount][$i] = $g_iStatsLastAttack[$i]
				$aiStatsBonusLast[$iAccount][$i] = $g_iStatsBonusLast[$i]
			Next

			;Humanization
			$gSiTimerBoostBuilders[$iAccount] = $g_iTimerBoostBuilders
			$gSCCWaitChrono[$iAccount] = $CCWaitChrono

			;Super Troops Boost
			$gSbFirstStartBarrel[$iAccount] = $g_bFirstStartBarrel
			$SMaxTroopsToBoost[$iAccount] = UBound($g_iCmbSuperTroops)
			If $SMaxTroopsToBoost[$iAccount] > $iMaxSupersTroop Then
				$SiCmbSuperTroopsThird[$iAccount] = $g_iCmbSuperTroops[$iMaxSupersTroop]
			EndIf

			;Clan Capital
			$gSiLootCCGold[$iAccount] = $g_iLootCCGold
			$gSiLootCCMedal[$iAccount] = $g_iLootCCMedal
			$gSiCCTrophies[$iAccount] = $g_iCCTrophies
			$IsSRaidRunning[$iAccount] = $IsRaidRunning
			$SAllCCRaidAttacksDone[$iAccount] = $AllCCRaidAttacksDone
			$gSiRank[$iAccount] = $g_iRank
			$SIsCCGoldJustCollected[$iAccount] = $IsCCGoldJustCollected
			$SIsCCGoldJustCollectedDChallenge[$iAccount] = $IsCCGoldJustCollectedDChallenge

			;Builders Base
			For $i = 0 To UBound($g_aiCurrentLootBB) - 1
				$gSaiCurrentLootBB[$iAccount][$i] = $g_aiCurrentLootBB[$i]
			Next
			$gSiFreeBuilderCountBB[$iAccount] = $g_iFreeBuilderCountBB
			$gSiTotalBuilderCountBB[$iAccount] = $g_iTotalBuilderCountBB
			$g_SIsBuilderJarAvl[$iAccount] = $g_IsBuilderJarAvl

			; Misc Stats
			$aiNbrOfOoS[$iAccount] = $g_iNbrOfOoS
			$aiDroppedTrophyCount[$iAccount] = $g_iDroppedTrophyCount
			$aiSearchCost[$iAccount] = $g_iSearchCost
			$aiTrainCostElixir[$iAccount] = $g_iTrainCostElixir
			$aiTrainCostDElixir[$iAccount] = $g_iTrainCostDElixir
			$aiTrainCostGold[$iAccount] = $g_iTrainCostGold
			$aiGoldFromMines[$iAccount] = $g_iGoldFromMines
			$aiElixirFromCollectors[$iAccount] = $g_iElixirFromCollectors
			$aiDElixirFromDrills[$iAccount] = $g_iDElixirFromDrills

			$aiCostGoldWall[$iAccount] = $g_iCostGoldWall
			$aiCostElixirWall[$iAccount] = $g_iCostElixirWall
			$aiCostGoldBuilding[$iAccount] = $g_iCostGoldBuilding
			$aiCostElixirBuilding[$iAccount] = $g_iCostElixirBuilding
			$aiCostDElixirBuilding[$iAccount] = $g_iCostDElixirBuilding
			$aiCostDElixirHero[$iAccount] = $g_iCostDElixirHero
			$aiCostElixirWarden[$iAccount] = $g_iCostElixirWarden
			$aiNbrOfWallsUppedGold[$iAccount] = $g_iNbrOfWallsUppedGold
			$aiNbrOfWallsUppedElixir[$iAccount] = $g_iNbrOfWallsUppedElixir
			$aiNbrOfBuildingsUppedGold[$iAccount] = $g_iNbrOfBuildingsUppedGold
			$aiNbrOfBuildingsUppedElixir[$iAccount] = $g_iNbrOfBuildingsUppedElixir
			$aiNbrOfBuildingsUppedDElixir[$iAccount] = $g_iNbrOfBuildingsUppedDElixir
			$aiNbrOfHeroesUpped[$iAccount] = $g_iNbrOfHeroesUpped
			$aiNbrOfWardenUpped[$iAccount] = $g_iNbrOfWardenUpped
			$aiNbrOfWallsUpped[$iAccount] = $g_iNbrOfWallsUpped

			; Attack Stats
			For $i = 0 To $g_iModeCount - 1
				$aiAttackedVillageCount[$iAccount][$i] = $g_aiAttackedVillageCount[$i]
				$aiTotalGoldGain[$iAccount][$i] = $g_aiTotalGoldGain[$i]
				$aiTotalElixirGain[$iAccount][$i] = $g_aiTotalElixirGain[$i]
				$aiTotalDarkGain[$iAccount][$i] = $g_aiTotalDarkGain[$i]
				$aiTotalTrophyGain[$iAccount][$i] = $g_aiTotalTrophyGain[$i]
				$aiNbrOfDetectedMines[$iAccount][$i] = $g_aiNbrOfDetectedMines[$i]
				$aiNbrOfDetectedCollectors[$iAccount][$i] = $g_aiNbrOfDetectedCollectors[$i]
				$aiNbrOfDetectedDrills[$iAccount][$i] = $g_aiNbrOfDetectedDrills[$i]
			Next
			$aiSmartZapGain[$iAccount] = $g_iSmartZapGain
			$aiNumEQSpellsUsed[$iAccount] = $g_iNumEQSpellsUsed
			$aiNumLSpellsUsed[$iAccount] = $g_iNumLSpellsUsed

			; Labs time
			$asLabUpgradeTime[$iAccount] = $g_sLabUpgradeTime
			$aiLabElixirCost[$iAccount] = $g_iLaboratoryElixirCost
			$aiLabDElixirCost[$iAccount] = $g_iLaboratoryDElixirCost
			If GUICtrlGetState($g_hPicLabGreen) = $GUI_ENABLE + $GUI_SHOW Then
				$aiLabStatus[$iAccount] = 1
			ElseIf GUICtrlGetState($g_hPicLabRed) = $GUI_ENABLE + $GUI_SHOW Then
				$aiLabStatus[$iAccount] = 2
			Else
				$aiLabStatus[$iAccount] = 0
			EndIf

			$asPetLabUpgradeTime[$iAccount] = $g_sPetUpgradeTime
			If GUICtrlGetState($g_hPicPetGreen) = $GUI_ENABLE + $GUI_SHOW Then
				$aiPetStatus[$iAccount] = 1
			ElseIf GUICtrlGetState($g_hPicPetRed) = $GUI_ENABLE + $GUI_SHOW Then
				$aiPetStatus[$iAccount] = 2
			Else
				$aiPetStatus[$iAccount] = 0
			EndIf
			$asiMinDark4PetUpgrade[$iAccount] = $g_iMinDark4PetUpgrade

			$asStarLabUpgradeTime[$iAccount] = $g_sStarLabUpgradeTime

			$asBSUpgradeTime[$iAccount] = $g_sBSUpgradeTime

			$SIsResearchPotInStock[$iAccount] = $IsResearchPotInStock
			$SIsPetPotInStock[$iAccount] = $IspetPotInStock
			$SIsBOFJustCollected[$iAccount] = $IsBOFJustCollected
			$SIsBOSJustCollected[$iAccount] = $IsBOSJustCollected
			$SIsResPotJustCollected[$iAccount] = $IsResPotJustCollected
			$SIsPetPotJustCollected[$iAccount] = $IsPetPotJustCollected
			$SIsAutoForgeSlotJustCollected[$iAccount] = $IsAutoForgeSlotJustCollected

			; BlackSmith
			$asBSmithUpgradeTime[$iAccount] = $g_sBSmithUpgradeTime

			;Event
			$SIsOresJustCollected[$iAccount] = $IsOresJustCollected

			;Daily challenge
			$gaSsNewChallengeTime[$iAccount] = $g_sNewChallengeTime

			;Clan Games
			$Sg_sClanGamesScore[$iAccount] = $g_sClanGamesScore
			$Sg_sClanGamesTimeRemaining[$iAccount] = $g_sClanGamesTimeRemaining
			For $i = 0 To UBound($YourAccScore) - 1
				$SYourAccScore[$iAccount][$i] = $YourAccScore[$i]
			Next
			$gSbClanGamesCompleted[$iAccount] = $g_bClanGamesCompleted
			$gSaiAttackedCGCount[$iAccount] = $g_aiAttackedCGCount
			$IsSReachedMaxCGDayAttack[$iAccount] = $IsReachedMaxCGDayAttack
			$iSRandomAttackCGCountToday[$iAccount] = $iRandomAttackCGCountToday
			$gSbIsBBevent[$iAccount] = $g_bIsBBevent
			$SIsCGEventRunning[$iAccount] = $IsCGEventRunning
			$Sb_COCClose[$iAccount] = $b_COCClose
			$Sg_hCoolDownTimer[$iAccount] = $g_hCoolDownTimer

			;StarBonus
			For $i = 0 To UBound($StarBonusReceived) - 1
				$SStarBonusReceived[$iAccount][$i] = $StarBonusReceived[$i]
			Next

			; Hero State
			$aiHeroAvailable[$iAccount] = $g_iHeroAvailable
			$aiHeroUpgradingBit[$iAccount] = $g_iHeroUpgradingBit
			For $i = 0 To 2
				$aiHeroUpgrading[$iAccount][$i] = $g_iHeroUpgrading[$i]
			Next
			$aiFirstStartForHiddenHero[$iAccount] = $g_bFirstStartForHiddenHero
			For $i = 0 To 4
				$g_aiSHeroUpgradeFinishDate[$iAccount][$i] = $g_aiHeroUpgradeFinishDate[$i]
			Next
			For $i = 0 To 4
				$g_aiSHeroNeededResource[$iAccount][$i] = $g_aiHeroNeededResource[$i]
			Next
			$bSCheckValuesForWarden[$iAccount] = $bSCheckValuesForWarden

			; Other global status
			$aiCommandStop[$iAccount] = $g_iCommandStop
			$aiAllBarracksUpgd[$iAccount] = $g_bAllBarracksUpgd

			For $i = 0 To 3
				$abFullStorage[$iAccount][$i] = $g_abFullStorage[$i]
			Next
			$aiBuilderBoostDiscount[$iAccount] = $g_iBuilderBoostDiscount
			$abNotNeedAllTime0[$iAccount] = $g_abNotNeedAllTime[0]
			$abNotNeedAllTime1[$iAccount] = $g_abNotNeedAllTime[1]
			$SbControlCCMedal[$iAccount] = $bControlCCMedal

			;Builder's Apprentice
			$gaSsAvailableAppBuilder[$iAccount] = $g_sAvailableAppBuilder
			$aSTimeDiffAppBuilder[$iAccount] = $TimeDiffAppBuilder

			;Lab Assistant
			$gaSsAvailableLabAssistant[$iAccount] = $g_sAvailableLabAssistant
			$aSTimeDiffLabAssistant[$iAccount] = $TimeDiffLabAssistant
			$SbLabAssistantUsedTime[$iAccount] = $bLabAssistantUsedTime

			;Magic Snack (Clan Castle Timer)
			$SClanCastleCakeTimer[$iAccount] = $ClanCastleCakeTimer

		Case "Load"
			$g_bFirstStart = $abFirstStart[$iAccount]
			$g_iFirstRun = $aiFirstRun[$iAccount]
			$g_bFirstStartCheckDone = $gSbFirstStartForAll[$iAccount]
			$g_bFirstStartAccountFMI = $gSbFirstStartAccountFMI[$iAccount]
			$g_bFirstStartAccountSBB = $gSbFirstStartAccountSBB[$iAccount]
			$g_bFirstStartAccountSBB2 = $gSbFirstStartAccountSBB2[$iAccount]
			$g_bFirstStartAccountCGRA = $gSbFirstStartAccountCGRA[$iAccount]
			$g_bFirstStartForLab = $gSbFirstStartForLab[$iAccount]
			$g_bFirstStartForPetHouse = $gSbFirstStartForPetHouse[$iAccount]
			$g_bFirstStartForStarLab = $gSbFirstStartForStarLab[$iAccount]

			;Mods
			$LootCartTimer = $SLootCartTimer[$iAccount]
			$LootCartFrequency = $SLootCartFrequency[$iAccount]
			$IsToOpenOffers = $SIsToOpenOffers[$iAccount]
			$DelayReturnedtocheckCGRA = $SDelayReturnedtocheckCGRA[$iAccount]
			$CGRACheckTimer = $SCGRACheckTimer[$iAccount]
			$IsStatusForCG = $SIsStatusForCG[$iAccount]
			$IstoSwitchMod = $SIstoSwitchMod[$iAccount]
			$BBaseCheckTimer = $SBBaseCheckTimer[$iAccount]
			$DelayReturnedtocheckBBaseMS = $SDelayReturnedtocheckBBaseMS[$iAccount]
			$CCBaseCheckTimer = $SCCBaseCheckTimer[$iAccount]
			$iLastTimeCCRaidChecked = $SiLastTimeCCRaidChecked[$iAccount]
			$DelayReturnedtocheckCCBaseMS = $SDelayReturnedtocheckCCBaseMS[$iAccount]
			$IstoRecheckTrader = $SIstoRecheckTrader[$iAccount]
			$IsdroptrophiesActive = $SIsdroptrophiesActive[$iAccount]
			$IsDropTrophyBreaked = $SIsDropTrophyBreaked[$iAccount]

			; Multi-Stats
			$g_iSkippedVillageCount = $aiSkippedVillageCount[$iAccount]
			$g_aiAttackedCount = $aiAttackedCount[$iAccount]

			; Gain Stats
			For $i = 0 To 3
				$g_iStatsTotalGain[$i] = $aiStatsTotalGain[$iAccount][$i]
				$g_iStatsStartedWith[$i] = $aiStatsStartedWith[$iAccount][$i]
				$g_iStatsLastAttack[$i] = $aiStatsLastAttack[$iAccount][$i]
				$g_iStatsBonusLast[$i] = $aiStatsBonusLast[$iAccount][$i]
			Next

			;Humanization
			$g_iTimerBoostBuilders = $gSiTimerBoostBuilders[$iAccount]
			$CCWaitChrono = $gSCCWaitChrono[$iAccount]

			;Super Troops Boost
			$g_bFirstStartBarrel = $gSbFirstStartBarrel[$iAccount]
			If $SMaxTroopsToBoost[$iAccount] > 0 Then
				If $SMaxTroopsToBoost[$iAccount] > $iMaxSupersTroop Then
					ReDim $g_iCmbSuperTroops[$iMaxSupersTroop + 1]
					$g_iCmbSuperTroops[$iMaxSupersTroop] = $SiCmbSuperTroopsThird[$iAccount]
				Else
					If UBound($g_iCmbSuperTroops) > $SMaxTroopsToBoost[$iAccount] Then
						ReDim $g_iCmbSuperTroops[$iMaxSupersTroop]
					EndIf
				EndIf
			Else
				If UBound($g_iCmbSuperTroops) > $SMaxTroopsToBoost[$iAccount] And UBound($g_iCmbSuperTroops) = ($iMaxSupersTroop + 1) Then ; Only ReDim If running Event or Finished.
					ReDim $g_iCmbSuperTroops[$iMaxSupersTroop]
				EndIf
			EndIf

			;Clan Capital
			$g_iLootCCGold = $gSiLootCCGold[$iAccount]
			$g_iLootCCMedal = $gSiLootCCMedal[$iAccount]
			$g_iCCTrophies = $gSiCCTrophies[$iAccount]
			GUICtrlSetData($g_lblCapitalGold, _NumberFormat($g_iLootCCGold, True))
			GUICtrlSetData($g_lblCapitalMedal, _NumberFormat($g_iLootCCMedal, True))
			GUICtrlSetData($g_lblCapitalTrophies, _NumberFormat($g_iCCTrophies, True))
			PicCCTrophies()
			$IsRaidRunning = $IsSRaidRunning[$iAccount]
			$AllCCRaidAttacksDone = $SAllCCRaidAttacksDone[$iAccount]
			$g_iRank = $gSiRank[$iAccount]
			$IsCCGoldJustCollected = $SIsCCGoldJustCollected[$iAccount]
			$IsCCGoldJustCollectedDChallenge = $SIsCCGoldJustCollectedDChallenge[$iAccount]

			;Builders Base
			For $i = 0 To UBound($g_aiCurrentLootBB) - 1
				$g_aiCurrentLootBB[$i] = $gSaiCurrentLootBB[$iAccount][$i]
				GUICtrlSetData($g_alblBldBaseStats[$i], _NumberFormat($g_aiCurrentLootBB[$i], True))
			Next
			PicBBTrophies()
			$g_iFreeBuilderCountBB = $gSiFreeBuilderCountBB[$iAccount]
			$g_iTotalBuilderCountBB = $gSiTotalBuilderCountBB[$iAccount]
			$g_IsBuilderJarAvl = $g_SIsBuilderJarAvl[$iAccount]

			; Misc Stats
			$g_iNbrOfOoS = $aiNbrOfOoS[$iAccount]
			$g_iDroppedTrophyCount = $aiDroppedTrophyCount[$iAccount]
			$g_iSearchCost = $aiSearchCost[$iAccount]
			$g_iTrainCostElixir = $aiTrainCostElixir[$iAccount]
			$g_iTrainCostDElixir = $aiTrainCostDElixir[$iAccount]
			$g_iTrainCostGold = $aiTrainCostGold[$iAccount]
			$g_iGoldFromMines = $aiGoldFromMines[$iAccount]
			$g_iElixirFromCollectors = $aiElixirFromCollectors[$iAccount]
			$g_iDElixirFromDrills = $aiDElixirFromDrills[$iAccount]

			$g_iCostGoldWall = $aiCostGoldWall[$iAccount]
			$g_iCostElixirWall = $aiCostElixirWall[$iAccount]
			$g_iCostGoldBuilding = $aiCostGoldBuilding[$iAccount]
			$g_iCostElixirBuilding = $aiCostElixirBuilding[$iAccount]
			$g_iCostDElixirBuilding = $aiCostDElixirBuilding[$iAccount]
			$g_iCostDElixirHero = $aiCostDElixirHero[$iAccount]
			$g_iCostElixirWarden = $aiCostElixirWarden[$iAccount]
			$g_iNbrOfWallsUppedGold = $aiNbrOfWallsUppedGold[$iAccount]
			$g_iNbrOfWallsUppedElixir = $aiNbrOfWallsUppedElixir[$iAccount]
			$g_iNbrOfBuildingsUppedGold = $aiNbrOfBuildingsUppedGold[$iAccount]
			$g_iNbrOfBuildingsUppedElixir = $aiNbrOfBuildingsUppedElixir[$iAccount]
			$g_iNbrOfBuildingsUppedDElixir = $aiNbrOfBuildingsUppedDElixir[$iAccount]
			$g_iNbrOfHeroesUpped = $aiNbrOfHeroesUpped[$iAccount]
			$g_iNbrOfWardenUpped = $aiNbrOfWardenUpped[$iAccount]
			$g_iNbrOfWallsUpped = $aiNbrOfWallsUpped[$iAccount]

			; Attack Stats
			For $i = 0 To $g_iModeCount - 1
				$g_aiAttackedVillageCount[$i] = $aiAttackedVillageCount[$iAccount][$i]
				$g_aiTotalGoldGain[$i] = $aiTotalGoldGain[$iAccount][$i]
				$g_aiTotalElixirGain[$i] = $aiTotalElixirGain[$iAccount][$i]
				$g_aiTotalDarkGain[$i] = $aiTotalDarkGain[$iAccount][$i]
				$g_aiTotalTrophyGain[$i] = $aiTotalTrophyGain[$iAccount][$i]
				$g_aiNbrOfDetectedMines[$i] = $aiNbrOfDetectedMines[$iAccount][$i]
				$g_aiNbrOfDetectedCollectors[$i] = $aiNbrOfDetectedCollectors[$iAccount][$i]
				$g_aiNbrOfDetectedDrills[$i] = $aiNbrOfDetectedDrills[$iAccount][$i]
			Next
			$g_iSmartZapGain = $aiSmartZapGain[$iAccount]
			$g_iNumEQSpellsUsed = $aiNumEQSpellsUsed[$iAccount]
			$g_iNumLSpellsUsed = $aiNumLSpellsUsed[$iAccount]

			; Labs time
			$g_sLabUpgradeTime = $asLabUpgradeTime[$iAccount]
			GUICtrlSetData($g_hLbLLabTime, "")
			$g_iLaboratoryElixirCost = $aiLabElixirCost[$iAccount]
			$g_iLaboratoryDElixirCost = $aiLabDElixirCost[$iAccount]
			Local $Counter = 0
			For $i = $g_hPicLabGray To $g_hPicLabRed
				GUICtrlSetState($i, $GUI_HIDE)
				If $aiLabStatus[$iAccount] = $Counter Then GUICtrlSetState($i, $GUI_SHOW)
				$Counter += 1
			Next

			$g_sPetUpgradeTime = $asPetLabUpgradeTime[$iAccount]
			GUICtrlSetData($g_hLbLPetTime, "")
			Local $Counter = 0
			For $i = $g_hPicPetGray To $g_hPicPetRed
				GUICtrlSetState($i, $GUI_HIDE)
				If $aiPetStatus[$iAccount] = $Counter Then GUICtrlSetState($i, $GUI_SHOW)
				$Counter += 1
			Next
			$g_iMinDark4PetUpgrade = $asiMinDark4PetUpgrade[$iAccount]

			$g_sStarLabUpgradeTime = $asStarLabUpgradeTime[$iAccount]

			$g_sBSUpgradeTime = $asBSUpgradeTime[$iAccount]

			$IsResearchPotInStock = $SIsResearchPotInStock[$iAccount]
			$IsPetPotInStock = $SIsPetPotInStock[$iAccount]
			$IsBOFJustCollected = $SIsBOFJustCollected[$iAccount]
			$IsBOSJustCollected = $SIsBOSJustCollected[$iAccount]
			$IsResPotJustCollected = $SIsResPotJustCollected[$iAccount]
			$IsPetPotJustCollected = $SIsPetPotJustCollected[$iAccount]
			$IsAutoForgeSlotJustCollected = $SIsAutoForgeSlotJustCollected[$iAccount]

			; BlackSmith
			$g_sBSmithUpgradeTime = $asBSmithUpgradeTime[$iAccount]

			;Event
			$IsOresJustCollected = $SIsOresJustCollected[$iAccount]

			;Daily challenge
			$g_sNewChallengeTime = $gaSsNewChallengeTime[$iAccount]

			;Clan Games
			$g_sClanGamesScore = $Sg_sClanGamesScore[$iAccount]
			$g_sClanGamesTimeRemaining = $Sg_sClanGamesTimeRemaining[$iAccount]
			For $i = 0 To UBound($YourAccScore) - 1
				$YourAccScore[$i] = $SYourAccScore[$iAccount][$i]
			Next
			$g_bClanGamesCompleted = $gSbClanGamesCompleted[$iAccount]
			$g_aiAttackedCGCount = $gSaiAttackedCGCount[$iAccount]
			$IsReachedMaxCGDayAttack = $IsSReachedMaxCGDayAttack[$iAccount]
			$iRandomAttackCGCountToday = $iSRandomAttackCGCountToday[$iAccount]
			$g_bIsBBevent = $gSbIsBBevent[$iAccount]
			$IsCGEventRunning = $SIsCGEventRunning[$iAccount]
			$b_COCClose = $Sb_COCClose[$iAccount]
			$g_hCoolDownTimer = $Sg_hCoolDownTimer[$iAccount]

			;StarBonus
			For $i = 0 To UBound($StarBonusReceived) - 1
				$StarBonusReceived[$i] = $SStarBonusReceived[$iAccount][$i]
			Next

			; Hero State
			$g_iHeroAvailable = $aiHeroAvailable[$iAccount]
			$g_iHeroUpgradingBit = $aiHeroUpgradingBit[$iAccount]
			For $i = 0 To 2
				$g_iHeroUpgrading[$i] = $aiHeroUpgrading[$iAccount][$i]
			Next
			$g_bFirstStartForHiddenHero = $aiFirstStartForHiddenHero[$iAccount]
			For $i = 0 To 4
				$g_aiHeroUpgradeFinishDate[$i] = $g_aiSHeroUpgradeFinishDate[$iAccount][$i]
			Next
			For $i = 0 To 4
				$g_aiHeroNeededResource[$i] = $g_aiSHeroNeededResource[$iAccount][$i]
			Next
			$bSCheckValuesForWarden = $bSCheckValuesForWarden[$iAccount]

			; Other global status
			$g_iCommandStop = $aiCommandStop[$iAccount]
			$g_bAllBarracksUpgd = $aiAllBarracksUpgd[$iAccount]
			For $i = 0 To 3
				$g_abFullStorage[$i] = $abFullStorage[$iAccount][$i]
			Next
			$g_iBuilderBoostDiscount = $aiBuilderBoostDiscount[$iAccount]
			$g_abNotNeedAllTime[0] = $abNotNeedAllTime0[$iAccount]
			$g_abNotNeedAllTime[1] = $abNotNeedAllTime1[$iAccount]
			$bControlCCMedal = $SbControlCCMedal[$iAccount]

			ResetVariables("donated") ; reset for new account
			$g_aiAttackedCountSwitch[$iAccount] = $aiAttackedCount[$iAccount]

			; Reset the log
			$g_hLogFile = 0

			;Builder's Apprentice
			$g_sAvailableAppBuilder = $gaSsAvailableAppBuilder[$iAccount]
			$TimeDiffAppBuilder = $aSTimeDiffAppBuilder[$iAccount]

			;Lab Assistant
			$g_sAvailableLabAssistant = $gaSsAvailableLabAssistant[$iAccount]
			$TimeDiffLabAssistant = $aSTimeDiffLabAssistant[$iAccount]
			$bLabAssistantUsedTime = $SbLabAssistantUsedTime[$iAccount]

			;Magic Snack (Clan Castle Timer)
			$ClanCastleCakeTimer = $SClanCastleCakeTimer[$iAccount]

		Case "UpdateStats"
			For $i = 0 To 3
				GUICtrlSetData($g_ahLblStatsStartedWith[$i], _NumberFormat($g_iStatsStartedWith[$i], True))
				$aiStatsTotalGain[$iAccount][$i] = $g_iStatsTotalGain[$i]
			Next
			For $i = 0 To 7
				GUICtrlSetData($g_ahLblHourlyStatsGoldAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
				GUICtrlSetData($g_ahLblHourlyStatsElixirAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
				GUICtrlSetData($g_ahLblHourlyStatsDarkAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
			Next

		Case "SetTime"
			Local $day, $hour, $min, $sec
			For $i = 0 To $g_iTotalAcc
				If _DateIsValid($asLabUpgradeTime[$i]) Then
					Local $iLabTime = _DateDiff('s', _NowCalc(), $asLabUpgradeTime[$i]) * 1000
					If $iLabTime > 0 Then
						_TicksToDay($iLabTime, $day, $hour, $min, $sec)
						GUICtrlSetData($g_ahLblLabTime[$i], $day > 0 ? StringFormat("%2ud %02i:%02i'", $day, $hour, $min) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
						GUICtrlSetColor($g_ahLblLabTime[$i], $day > 0 ? $COLOR_GREEN : $COLOR_OLIVE)
					Else
						GUICtrlSetData($g_ahLblLabTime[$i], "")
						$asLabUpgradeTime[$i] = ""
					EndIf
				Else
					GUICtrlSetData($g_ahLblLabTime[$i], "")
				EndIf
				If _DateIsValid($asStarLabUpgradeTime[$i]) Then
					Local $iStarLabTime = _DateDiff("s", _NowCalc(), $asStarLabUpgradeTime[$i]) * 1000
					If $iStarLabTime > 0 Then
						_TicksToDay($iStarLabTime, $day, $hour, $min, $sec)
						GUICtrlSetData($g_ahLbLStarLabTime[$i], $day > 0 ? StringFormat("%2ud %02i:%02i'", $day, $hour, $min) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
						GUICtrlSetColor($g_ahLbLStarLabTime[$i], $day > 0 ? $COLOR_GREEN : $COLOR_OLIVE)
					Else
						GUICtrlSetData($g_ahLbLStarLabTime[$i], "")
						$asStarLabUpgradeTime[$i] = ""
					EndIf
				Else
					GUICtrlSetData($g_ahLbLStarLabTime[$i], "")
				EndIf
				If _DateIsValid($asPetLabUpgradeTime[$i]) Then
					Local $iPetHouseTime = _DateDiff('s', _NowCalc(), $asPetLabUpgradeTime[$i]) * 1000
					If $iPetHouseTime > 0 Then
						_TicksToDay($iPetHouseTime, $day, $hour, $min, $sec)
						GUICtrlSetData($g_ahLbLPetTime[$i], $day > 0 ? StringFormat("%2ud %02i:%02i'", $day, $hour, $min) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
						GUICtrlSetColor($g_ahLbLPetTime[$i], $day > 0 ? $COLOR_GREEN : $COLOR_OLIVE)
					Else
						GUICtrlSetData($g_ahLbLPetTime[$i], "")
						$asPetLabUpgradeTime[$i] = ""
					EndIf
				Else
					GUICtrlSetData($g_ahLbLPetTime[$i], "")
				EndIf
			Next

		Case "$g_iCommandStop"
			Return $aiCommandStop[$iAccount]

	EndSwitch

EndFunc   ;==>SwitchAccountVariablesReload
