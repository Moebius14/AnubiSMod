; #FUNCTION# ====================================================================================================================
; Name ..........: Clan Games
; Description ...: This file contains the Clan Games algorithm
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: ViperZ And Uncle Xbenk 01-2018
; Modified ......: ProMac 02/2018 [v2 and v3] , ProMac 08/2018 v4 , GrumpyHog 08/2020
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================
Func _ClanGames($test = False)
	If Not $g_bChkClanGamesEnabled Then Return
	
   ; Check if games has been completed
   If $g_bClanGamesCompleted Then
	  SetLog("Clan Games has already been completed")
	  Return
   EndIf	
	
	;Prevent checking clangames before date 22 (clangames should start on 22 and end on 28 or 29) depends on how many tiers/maxpoint
	Local $currentDate = Number(@MDAY)
	If $currentDate < 21 Then
		SetLog("Current date : " & $currentDate & " --> Skip Clan Games", $COLOR_INFO)
		Return
	EndIf
	
	If IsCGCoolDownTime() Then Return
	
	If $iNowDayCG <> @YDAY Or Not $g_bFirstStartForAll Then; if 1 day or more has passed since last time Or First start, update daily random value
		$iNowDayCG = @YDAY ; set new year day value
		$g_aiAttackedCGCount = 0
		$IsReachedMaxCGDayAttack = 0
		If $g_bAttackCGPlannerEnable And $g_bAttackCGPlannerDayLimit And IsClanGamesWindow() Then
			Local $aiScoreLimit = GetTimesAndScores()
			If $aiScoreLimit[0] < $aiScoreLimit[1] Then
				$iRandomAttackCGCountToday = Random($g_iAttackCGPlannerDayMin,$g_iAttackCGPlannerDayMax, 1)
				If Not $g_bFirstStartForAll Then 
					SetLog("Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "", $COLOR_ERROR)
				ElseIf $g_bFirstStartForAll Then
					SetLog("It's A Brand New Day ! Reset Max Clan Games Challenges", $COLOR_ERROR)
					SetLog("Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "", $COLOR_ERROR)
				EndIf
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "", 1)
				Else
					GUICtrlSetData($g_hTxtCGRandomLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\CGRALog.log", " [" & $g_sProfileCurrentName & "] - Max Clan Games Challenges Today : " & $iRandomAttackCGCountToday & "")
			EndIf
			CloseWindow()
		EndIf
	EndIf
	
	$g_bIsBBevent = 0 ;just to be sure, reset to false
	
	If $IsReachedMaxCGDayAttack = 1 Then Return

	; A user Log and a Click away just in case
	ClickAway()
	SetLog("Entering Clan Games", $COLOR_INFO)
	If _Sleep(1000) Then Return

	; Local and Static Variables
	Local $TabChallengesPosition[2] = [820, 100 + $g_iMidOffsetY]
	Local $sTimeRemain = "", $sEventName = "", $getCapture = True
	Local Static $YourAccScore[8][2] = [[-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True], [-1, True]]

	; Initial Timer
	Local $hTimer = TimerInit()
	
	; Enter on Clan Games window
	If IsClanGamesWindow() Then
		; Let's selected only the necessary images 
		Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
		Local $sTempPath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"

		;Remove All previous file (in case setting changed)
		DirRemove($sTempPath, $DIR_REMOVE)

		If $g_bChkClanGamesLoot Then ClanGameImageCopy($sImagePath, $sTempPath, "L") ;L for Loot
		If $g_bChkClanGamesBattle Then ClanGameImageCopy($sImagePath, $sTempPath, "B") ;B for Battle
		If $g_bChkClanGamesDes Then ClanGameImageCopy($sImagePath, $sTempPath, "D") ;D for Destruction
		If $g_bChkClanGamesAirTroop Then ClanGameImageCopy($sImagePath, $sTempPath, "A") ;A for AirTroops
		If $g_bChkClanGamesGroundTroop Then ClanGameImageCopy($sImagePath, $sTempPath, "G") ;G for GroundTroops

		If $g_bChkClanGamesMiscellaneous Then ClanGameImageCopy($sImagePath, $sTempPath, "M") ;M for Misc
		If $g_bChkClanGamesSpell Then ClanGameImageCopy($sImagePath, $sTempPath, "S") ;S for GroundTroops
		If $g_bChkClanGamesBBBattle Then ClanGameImageCopy($sImagePath, $sTempPath, "BBB") ;BBB for BB Battle
		If $g_bChkClanGamesBBDes Then ClanGameImageCopy($sImagePath, $sTempPath, "BBD") ;BBD for BB Destruction
		If $g_bChkClanGamesBBTroops Then ClanGameImageCopy($sImagePath, $sTempPath, "BBT") ;BBT for BB Troops
		
		;now we need to copy selected challenge before checking current running event is not wrong event selected
		
		; Let's get some information , like Remain Timer, Score and limit
		If Not _ColorCheck(_GetPixelColor(300, 236 + $g_iMidOffsetY, True), Hex(0x53E050, 6), 5) Then ;no greenbar = there is active event or completed event
			_Sleep(3000) ; just wait few second, as completed event will need sometime to animate on score
		EndIf
		Local $aiScoreLimit = GetTimesAndScores()
		If $aiScoreLimit = -1 Or UBound($aiScoreLimit) <> 2 Then
			$g_bClanGamesCompleted = 1
			Return
		Else
			SetLog("Your Score is: " & $aiScoreLimit[0], $COLOR_INFO)
			If _Sleep(500) Then Return
			If $g_bChkClanGamesDebug Then SaveDebugImage("ClanGames_Challenges", True)
			Local $sTimeCG
			If $aiScoreLimit[0] = $aiScoreLimit[1] Then
				SetLog("Your score limit is reached ! Congrats", $COLOR_SUCCESS1)
				$g_bClanGamesCompleted = 1
				CloseWindow()
				If $g_bAttackCGPlannerEnable And $g_bChkSTOPWhenCGPointsMax Then
					SetLog("Bot Will Stop After Routines", $COLOR_DEBUG)
					Sleep(Random(3500, 5500, 1))
					If IsToFillCCWithMedalsOnly() Then
						Local $aRndFuncList = ['DonateCC,Train', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
					Else
						Local $aRndFuncList = ['DonateCC,Train', 'RequestCC', 'CollectFreeMagicItems', 'Collect', 'DailyChallenge', 'UpgradeWall', 'Laboratory', 'UpgradeHeroes', 'UpgradeBuilding', 'PetHouse', 'CheckTombs', 'CleanYard']
					EndIf
					For $Index In $aRndFuncList
					_RunFunction($Index)
					Next
					If $g_bNotifyStopBot Then
						Local $text ="Village : " & $g_sNotifyOrigin & "%0A"
						$text &="Profile : " & $g_sProfileCurrentName & "%0A"
						If $g_bNotifyAlertForecastReport Then
						$text &="Forecast : " & $currentForecast & "%0A"
						EndIf
						Local $currentDate = Number(@MDAY)
						If $g_bChkClanGamesEnabled And $g_bChkNotifyCGScore And $currentDate >= 21 And $currentDate < 29 Then
						$text &="CG Score : " & $g_sClanGamesScore & "%0A"
						EndIf
						If $g_bChkNotifyStarBonusAvail Then
						IsStarBonusAvail()
						$text &="" & $StarBonusStatus & "%0A"
						EndIf
						$text &= "CG Max Score Is Reached, Bot Stopped"
						NotifyPushToTelegram($text)
					EndIf
					Sleep(Random(3500, 5500, 1))
					CloseCoC(False)
					Sleep(Random(1500, 2500, 1))
					btnStop()
				EndIf
				Return
			ElseIf $aiScoreLimit[0] + 300 > $aiScoreLimit[1] Then
				SetLog("You have almost reached max point")
				If $g_bChkClanGamesStopBeforeReachAndPurge Then
					If IsEventRunning() Then Return
					$sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, True)
					Setlog("Clan Games Minute Remain: " & $sTimeCG)
					If $g_bChkClanGamesPurgeAny And $sTimeCG > 1440 Then ; purge, but not purge on last day of clangames
						SetLog("Stop before completing your limit and only Purge")
						SetLog("Lets only purge 1 most top event", $COLOR_WARNING)
						PurgeEvent(False, True)
						Return
					EndIf
				EndIf
			EndIf
			If $YourAccScore[$g_iCurAccount][0] = -1 Then $YourAccScore[$g_iCurAccount][0] = $aiScoreLimit[0]
		EndIf
	Else
		ClickAway()
		Return
	EndIf

	;check cooldown purge
	If CooldownTime() Then Return
	If Not $g_bRunState Then Return ;trap pause or stop bot
	If IsEventRunning() Then Return
	If Not $g_bRunState Then Return ;trap pause or stop bot

	If $g_bChkCCGDebugNoneFound Then
		SaveDebugImage("CG_All_Challenges", True)
		If _Sleep(1000) Then Return
	EndIf

	UpdateStats()
	
	If Not IsSearchCGAttackEnabled() Then
		CloseWindow()
		Return
	EndIf
	
	Local $HowManyImages = _FileListToArray($sTempPath, "*", $FLTA_FILES)
	If IsArray($HowManyImages) Then
		Setlog($HowManyImages[0] & " Events to search")
	Else
		Setlog("ClanGames-Error on $HowManyImages: " & @error)
		Return
	EndIf

	Local $aAllDetectionsOnScreen = FindEvent()
	
	Local $aSelectChallenges[0][5]

	If UBound($aAllDetectionsOnScreen) > 0 Then
		For $i = 0 To UBound($aAllDetectionsOnScreen) - 1

			Switch $aAllDetectionsOnScreen[$i][0]
				Case "L"
					If Not $g_bChkClanGamesLoot Then ContinueLoop
					Local $LootChallenges = ClanGamesChallenges("$LootChallenges")
					For $j = 0 To UBound($LootChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $LootChallenges[$j][0] Then
							; Verify your TH level and Challenge kind
							If $g_iTownHallLevel < $LootChallenges[$j][2] Then ExitLoop
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$LootChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $LootChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
				Case "A"
					If Not $g_bChkClanGamesAirTroop Then ContinueLoop
					Local $AirTroopChallenges = ClanGamesChallenges("$AirTroopChallenges")
					For $j = 0 To UBound($AirTroopChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $AirTroopChallenges[$j][0] Then
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$AirTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $AirTroopChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next

				Case "S" ; - grumpy
					If Not $g_bChkClanGamesSpell Then ContinueLoop
					Local $SpellChallenges = ClanGamesChallenges("$SpellChallenges") ; load all spell challenges
					For $j = 0 To UBound($SpellChallenges) - 1 ; loop through all challenges
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $SpellChallenges[$j][0] Then
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$SpellChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $SpellChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next

			   Case "G"
					If Not $g_bChkClanGamesGroundTroop Then ContinueLoop
					Local $GroundTroopChallenges = ClanGamesChallenges("$GroundTroopChallenges")
					For $j = 0 To UBound($GroundTroopChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $GroundTroopChallenges[$j][0] Then
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$GroundTroopChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $GroundTroopChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					 Next

				Case "B"
					If Not $g_bChkClanGamesBattle Then ContinueLoop
					Local $BattleChallenges = ClanGamesChallenges("$BattleChallenges")
					For $j = 0 To UBound($BattleChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $BattleChallenges[$j][0] Then
							; Verify the TH level and a few Challenge to destroy TH specific level
							If $BattleChallenges[$j][1] = "Scrappy 6s" And ($g_iTownHallLevel < 5 Or $g_iTownHallLevel > 7) Then ExitLoop        ; TH level 5-6-7
							If $BattleChallenges[$j][1] = "Super 7s" And ($g_iTownHallLevel < 6 Or $g_iTownHallLevel > 8) Then ExitLoop            ; TH level 6-7-8
							If $BattleChallenges[$j][1] = "Exciting 8s" And ($g_iTownHallLevel < 7 Or $g_iTownHallLevel > 9) Then ExitLoop        ; TH level 7-8-9
							If $BattleChallenges[$j][1] = "Noble 9s" And ($g_iTownHallLevel < 8 Or $g_iTownHallLevel > 10) Then ExitLoop        ; TH level 8-9-10
							If $BattleChallenges[$j][1] = "Terrific 10s" And ($g_iTownHallLevel < 9 Or $g_iTownHallLevel > 11) Then ExitLoop    ; TH level 9-10-11
							If $BattleChallenges[$j][1] = "Exotic 11s" And ($g_iTownHallLevel < 10 Or $g_iTownHallLevel > 12) Then ExitLoop     ; TH level 10-11-12
							If $BattleChallenges[$j][1] = "Triumphant 12s" And ($g_iTownHallLevel < 11 Or $g_iTownHallLevel > 13) Then ExitLoop  ; TH level 11-12-13
						    If $BattleChallenges[$j][1] = "Tremendous 13s" And ($g_iTownHallLevel < 12 Or $g_iTownHallLevel > 14) Then ExitLoop  ; TH level 12-13-14
							If $BattleChallenges[$j][1] = "Formidable 14s" And $g_iTownHallLevel < 13 Then ExitLoop  ; TH level 13-14-15
							
							; Verify your TH level and Challenge
							If $g_iTownHallLevel < $BattleChallenges[$j][2] Then ExitLoop
							
							; If you are a TH15 , doesn't exist the TH16 yet
							If $BattleChallenges[$j][1] = "Attack Up" And $g_iTownHallLevel = 15 Then ExitLoop
							
							; Check your Trophy Range
							If $BattleChallenges[$j][1] = "Slaying The Titans" And (Int($g_aiCurrentLoot[$eLootTrophy]) < 4100 or Int($g_aiCurrentLoot[$eLootTrophy]) > 5000) Then ExitLoop

						    If $BattleChallenges[$j][1] = "Clash of Legends" And Int($g_aiCurrentLoot[$eLootTrophy]) < 5000 Then ExitLoop

							; Check if exist a probability to use any Spell
							If $BattleChallenges[$j][1] = "No-Magic Zone" And (($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1)) Then ExitLoop
							
							; Check if you are using Heroes
							If $BattleChallenges[$j][1] = "No Heroics Allowed" And ((Int($g_aiAttackUseHeroes[$DB]) > $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) > $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop
							
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$BattleChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BattleChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
				Case "D"
					If Not $g_bChkClanGamesDes Then ContinueLoop
					Local $DestructionChallenges = ClanGamesChallenges("$DestructionChallenges")
					For $j = 0 To UBound($DestructionChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $DestructionChallenges[$j][0] Then
							; Verify your TH level and Challenge kind
							If $g_iTownHallLevel < $DestructionChallenges[$j][2] Then ExitLoop

							; Check if you are using Heroes
							If	$DestructionChallenges[$j][1] = "Hero Level Hunter" Or _
								$DestructionChallenges[$j][1] = "King Level Hunter" Or _
								$DestructionChallenges[$j][1] = "Queen Level Hunter" Or _
								$DestructionChallenges[$j][1] = "Warden Level Hunter" And _
								((Int($g_aiAttackUseHeroes[$DB]) = $eHeroNone And $g_iMatchMode = $DB) Or (Int($g_aiAttackUseHeroes[$LB]) = $eHeroNone And $g_iMatchMode = $LB)) Then ExitLoop
								
							
							If $aAllDetectionsOnScreen[$i][1] = "BBreakdown" And $aAllDetectionsOnScreen[$i][4] = "CGBB" Then ContinueLoop
							If $aAllDetectionsOnScreen[$i][1] = "WallWhacker" And $aAllDetectionsOnScreen[$i][4] = "CGBB" Then ContinueLoop
							
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$DestructionChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $DestructionChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
				Case "M"
					If Not $g_bChkClanGamesMiscellaneous Then ContinueLoop
					Local $MiscChallenges = ClanGamesChallenges("$MiscChallenges")
					For $j = 0 To UBound($MiscChallenges) - 1
						; Match the names
						If $aAllDetectionsOnScreen[$i][1] = $MiscChallenges[$j][0] Then
						
							; Exceptions :
							; 1 - "Gardening Exercise" needs at least a Free Builder and "Remove Obstacles" enabled
							If $MiscChallenges[$j][1] = "Gardening Exercise" And ($g_iFreeBuilderCount < 1 Or Not $g_bChkCleanYard) Then ExitLoop

							; 2 - Verify your TH level and Challenge kind
							If $g_iTownHallLevel < $MiscChallenges[$j][2] Then ExitLoop

							; 3 - If you don't Donate Troops
							If $MiscChallenges[$j][1] = "Helping Hand" And Not $g_iActiveDonate Then ExitLoop

							; 4 - If you don't Donate Spells , $g_aiPrepDon[2] = Donate Spells , $g_aiPrepDon[3] = Donate All Spells [PrepareDonateCC()]
							If $MiscChallenges[$j][1] = "Donate Spells" And ($g_aiPrepDon[2] = 0 And $g_aiPrepDon[3] = 0) Then ExitLoop

							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$MiscChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $MiscChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
						EndIf
					Next
                Case "BBB" ; BB Battle challenges
                    If Not $g_bChkClanGamesBBBattle Then ContinueLoop
                    Local $BBBattleChallenges = ClanGamesChallenges("$BBBattleChallenges")
                    For $j = 0 To UBound($BBBattleChallenges) - 1
                        ; Match the names
                        If $aAllDetectionsOnScreen[$i][1] = $BBBattleChallenges[$j][0] Then
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
                            Local $aArray[5] = [$BBBattleChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BBBattleChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
                        EndIf
                    Next
                Case "BBD" ; BB Destruction challenges
					If Not $g_bChkClanGamesBBDes Then ContinueLoop
                    Local $BBDestructionChallenges = ClanGamesChallenges("$BBDestructionChallenges")
                    For $j = 0 To UBound($BBDestructionChallenges) - 1
						; Match the names
                        If $aAllDetectionsOnScreen[$i][1] = $BBDestructionChallenges[$j][0] Then
						
							If $aAllDetectionsOnScreen[$i][1] = "BuildingDes" And $aAllDetectionsOnScreen[$i][4] = "CGMain" Then ContinueLoop
							If $aAllDetectionsOnScreen[$i][1] = "WallDes" And $aAllDetectionsOnScreen[$i][4] = "CGMain" Then ContinueLoop
							
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$BBDestructionChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BBDestructionChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
                        EndIf
                    Next
				Case "BBT" ; BB Troop challenges
					If Not $g_bChkClanGamesBBTroops Then ContinueLoop
                    Local $BBTroopsChallenges = ClanGamesChallenges("$BBTroopsChallenges")
                    For $j = 0 To UBound($BBTroopsChallenges) - 1
                        ; Match the names
                        If $aAllDetectionsOnScreen[$i][1] = $BBTroopsChallenges[$j][0] Then
							; [0] Event Name Full Name  , [1] Xaxis ,  [2] Yaxis , [3] Difficulty, [4] CGMAIN/CGBB
							Local $aArray[5] = [$BBTroopsChallenges[$j][1], $aAllDetectionsOnScreen[$i][2], $aAllDetectionsOnScreen[$i][3], $BBTroopsChallenges[$j][3], $aAllDetectionsOnScreen[$i][4]]
                        EndIf
                    Next
			EndSwitch
			If IsDeclared("aArray") And $aArray[0] <> "" Then
				ReDim $aSelectChallenges[UBound($aSelectChallenges) + 1][6]
				$aSelectChallenges[UBound($aSelectChallenges) - 1][0] = $aArray[0] ; Event Name Full Name
				$aSelectChallenges[UBound($aSelectChallenges) - 1][1] = $aArray[1] ; Xaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][2] = $aArray[2] ; Yaxis
				$aSelectChallenges[UBound($aSelectChallenges) - 1][3] = $aArray[3] ; difficulty
				$aSelectChallenges[UBound($aSelectChallenges) - 1][4] = 0 		   ; timer minutes
				$aSelectChallenges[UBound($aSelectChallenges) - 1][5] = $aArray[4] ; EventType: MainVillage/BuilderBase
				$aArray[0] = ""
			EndIf
		Next
	EndIf

	If $g_bChkClanGamesDebug Then Setlog("_ClanGames aAllDetectionsOnScreen (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds)", $COLOR_INFO)
	$hTimer = TimerInit()
	
	; Sort by Yaxis , TOP to Bottom
	_ArraySort($aSelectChallenges, 0, 0, 0, 2)

	If UBound($aSelectChallenges) > 0 Then
		; let's get the Event timing
		For $i = 0 To UBound($aSelectChallenges) - 1
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(1500) Then Return
			Local $EventHours = GetEventInformation()
			Setlog("Detected " & $aSelectChallenges[$i][0] & " difficulty of " & $aSelectChallenges[$i][3] & " Time: " & $EventHours & " min", $COLOR_INFO)
			Click($aSelectChallenges[$i][1], $aSelectChallenges[$i][2])
			If _Sleep(250) Then Return
			$aSelectChallenges[$i][4] = Number($EventHours)
		Next

		; let's get the 180 minutes events and remove from array
		Local $aTempSelectChallenges[0][6]
		For $i = 0 To UBound($aSelectChallenges) - 1
			If $aSelectChallenges[$i][4] > 180 And $g_bChkClanGames3hOnly Then
				Setlog($aSelectChallenges[$i][0] & " unselected, is not a 3 Hours event!", $COLOR_INFO)
				ContinueLoop
			EndIf
			If $aSelectChallenges[$i][4] = 180 And $g_bChkClanGames3h Then
				Setlog($aSelectChallenges[$i][0] & " unselected, is a 3 Hours event!", $COLOR_INFO)
				ContinueLoop
			EndIf
			ReDim $aTempSelectChallenges[UBound($aTempSelectChallenges) + 1][6]
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][0] = $aSelectChallenges[$i][0] ; Event Name Full Name
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][1] = $aSelectChallenges[$i][1] ; Xaxis
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][2] = $aSelectChallenges[$i][2] ; Yaxis
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][3] = Number($aSelectChallenges[$i][3]) ; difficulty
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][4] = Number($aSelectChallenges[$i][4]) ; timer minutes
			$aTempSelectChallenges[UBound($aTempSelectChallenges) - 1][5] = $aSelectChallenges[$i][5] ; EventType: MainVillage/BuilderBase
		Next

		Local $aTmpBBChallenges[0][6]
		Local $aTmpMainChallenges[0][6]
		If $g_bChkForceBBAttackOnClanGames And $bSearchBBEventFirst Then
			Local $CGMAinCount = 0
			SetLog("Try To Do BB Challenge First", $COLOR_DEBUG1)
			For $i = 0 To UBound($aTempSelectChallenges) - 1
				If $aTempSelectChallenges[$i][5] = "CGMain" Then
					$CGMAinCount += 1
					ContinueLoop
				EndIf
				ReDim $aTmpBBChallenges[UBound($aTmpBBChallenges) + 1][6]
				$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][0] = $aTempSelectChallenges[$i][0] ; Event Name Full Name
				$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][1] = $aTempSelectChallenges[$i][1] ; Xaxis
				$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][2] = $aTempSelectChallenges[$i][2] ; Yaxis
				$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][3] = Number($aTempSelectChallenges[$i][3]) ; difficulty
				$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][4] = Number($aTempSelectChallenges[$i][4]) ; timer minutes
				$aTmpBBChallenges[UBound($aTmpBBChallenges) - 1][5] = $aTempSelectChallenges[$i][5] ; EventType: MainVillage/BuilderBase
			Next
			
			If Ubound($aTmpBBChallenges) > 0 Then
				If Ubound($aTmpBBChallenges) = 1 Then
					SetLog("Found " & Ubound($aTmpBBChallenges) & " BB Challenge", $COLOR_SUCCESS)
				Else
					SetLog("Found " & Ubound($aTmpBBChallenges) & " BB Challenges", $COLOR_SUCCESS)
				EndIf
				$aTempSelectChallenges = $aTmpBBChallenges ;replace All Challenge array with BB Only Event Array
			Else
				If $CGMAinCount = 1 Then
					SetLog("No BB Challenge Found, using current detected Main Village Challenge", $COLOR_INFO)
				Else
					SetLog("No BB Challenge Found, using current detected Main Village Challenges", $COLOR_INFO)
				EndIf
			EndIf
		ElseIf $g_bChkForceBBAttackOnClanGames And $bSearchMainEventFirst Then
			Local $CGBBCount = 0
			SetLog("Try To Do Main Village Challenge First", $COLOR_DEBUG1)
			For $i = 0 To UBound($aTempSelectChallenges) - 1
				If $aTempSelectChallenges[$i][5] = "CGBB" Then
					$CGBBCount += 1
					ContinueLoop
				EndIf
				ReDim $aTmpMainChallenges[UBound($aTmpMainChallenges) + 1][6]
			$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][0] = $aTempSelectChallenges[$i][0] ; Event Name Full Name
			$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][1] = $aTempSelectChallenges[$i][1] ; Xaxis
			$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][2] = $aTempSelectChallenges[$i][2] ; Yaxis
			$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][3] = Number($aTempSelectChallenges[$i][3]) ; difficulty
			$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][4] = Number($aTempSelectChallenges[$i][4]) ; timer minutes
			$aTmpMainChallenges[UBound($aTmpMainChallenges) - 1][5] = $aTempSelectChallenges[$i][5] ; EventType: MainVillage/BuilderBase
			Next
			
			If Ubound($aTmpMainChallenges) > 0 Then
				If Ubound($aTmpMainChallenges) = 1 Then
					SetLog("Found " & Ubound($aTmpMainChallenges) & " Main Village Challenge", $COLOR_SUCCESS)
				Else
					SetLog("Found " & Ubound($aTmpMainChallenges) & " Main Village Challenges", $COLOR_SUCCESS)
				EndIf
				$aTempSelectChallenges = $aTmpMainChallenges ;replace All Challenge array with Main Only Event Array
			Else
				If $CGBBCount = 1 Then
					SetLog("No Main Village Challenge Found, using current detected BB Challenge", $COLOR_INFO)
				Else
					SetLog("No Main Village Challenge Found, using current detected BB Challenges", $COLOR_INFO)
				EndIf
			EndIf
		ElseIf $g_bChkForceBBAttackOnClanGames And $bSearchBothVillages Then
			SetLog("Both Villages Equal Priority To Choose Challenges", $COLOR_DEBUG1)
		EndIf

		; Drop to top again , because coordinates Xaxis and Yaxis
		ClickP($TabChallengesPosition, 2, 0, "#Tab")
		If _sleep(1000) Then Return
		ClickDrag(807, 210, 807, 385, 500)
		If _Sleep(2000) Then Return
	EndIf
	
	; After removing is necessary check Ubound
	If IsDeclared("aTempSelectChallenges") Then
		If UBound($aTempSelectChallenges) > 0 Then
			If $g_bSortClanGames Then
				Switch $g_iSortClanGames
					Case 0 ;sort by Difficulty
						_ArraySort($aTempSelectChallenges, 0, 0, 0, 3) ;sort ascending, lower difficulty = easiest
						SetLog("Sort Challenges by Difficulty", $COLOR_ACTION)
					Case 1 ;sort by Score
						_ArraySort($aTempSelectChallenges, 1, 0, 0, 6) ;sort descending, Higher score first
						SetLog("Sort Challenges by Score", $COLOR_ACTION)
					Case 2 ;sort by Time
						_ArraySort($aTempSelectChallenges, 0, 0, 0, 4) ;sort descending, shortest time first
						SetLog("Sort Challenges by Time, Shortest First", $COLOR_ACTION)
					Case 3 ;sort by Time
						_ArraySort($aTempSelectChallenges, 1, 0, 0, 4) ;sort descending, longest time first
						SetLog("Sort Challenges by Time, Longest First", $COLOR_ACTION)
				EndSwitch
			EndIf
			For $i = 0 To UBound($aTempSelectChallenges) - 1
				If Not $g_bRunState Then Return
				SetDebugLog("$aTempSelectChallenges: " & _ArrayToString($aTempSelectChallenges))
				Setlog("Next Event will be " & $aTempSelectChallenges[$i][0] & " to make in " & $aTempSelectChallenges[$i][4] & " min.")
				; Select and Start EVENT
				$sEventName = $aTempSelectChallenges[$i][0]
				If Not QuickMIS("BC1", $sTempPath & "Selected\", $aTempSelectChallenges[$i][1] - 60, $aTempSelectChallenges[$i][2] - 60, $aTempSelectChallenges[$i][1] + 60, $aTempSelectChallenges[$i][2] + 60, True) Then 
					SetLog($sEventName & " not found on previous location detected", $COLOR_ERROR)
					SetLog("Maybe event tile changed, Looking Next Event...", $COLOR_INFO)
					If _Sleep(2000) Then Return
					ContinueLoop
				EndIf
				
				Click($aTempSelectChallenges[$i][1], $aTempSelectChallenges[$i][2])
				If _Sleep(1750) Then Return
				Return ClickOnEvent($YourAccScore, $aiScoreLimit, $sEventName, $getCapture)
			Next
		EndIf
	EndIf

	If $g_bChkClanGamesPurgeAny Then ; still have to purge, because no enabled event on setting found
		SetLog("Purge needed, because no enabled event on setting found", $COLOR_WARNING)
		SetLog("No Event found, lets purge 1 most top event", $COLOR_WARNING)
		PurgeEvent(False, True)
		If _Sleep(1000) Then Return
	Else
		SetLog("No Event found, Check your settings", $COLOR_WARNING)
		
		If $g_bChkCCGDebugNoneFound Then
			SaveDebugImage("CG_No_Challenge", True)
			If _Sleep(2000) Then Return
		EndIf	
		
		CloseWindow()
		If _Sleep(2000) Then Return
	EndIf
EndFunc ;==>_ClanGames

Func ClanGameImageCopy($sImagePath, $sTempPath, $sImageType = Default, $ImageName = Default)
	If $sImageType = Default Then Return
	Switch $sImageType
		Case "L"
			Local $CGMainLoot = ClanGamesChallenges("$LootChallenges")
			For $i = 0 To UBound($g_abCGMainLootItem) - 1
				If $g_abCGMainLootItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "LootChallenges: " & $CGMainLoot[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainLoot[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainLoot[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "B"
			Local $CGMainBattle = ClanGamesChallenges("$BattleChallenges")
			For $i = 0 To UBound($g_abCGMainBattleItem) - 1
				If $g_abCGMainBattleItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BattleChallenges: " & $CGMainBattle[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainBattle[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainBattle[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "D"
			Local $CGMainDestruction = ClanGamesChallenges("$DestructionChallenges")
			For $i = 0 To UBound($g_abCGMainDestructionItem) - 1
				If $g_abCGMainDestructionItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "DestructionChallenges: " & $CGMainDestruction[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainDestruction[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainDestruction[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "A"
			Local $CGMainAir = ClanGamesChallenges("$AirTroopChallenges")
			For $i = 0 To UBound($g_abCGMainAirItem) - 1
				If $g_abCGMainAirItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "AirTroopChallenges: " & $CGMainAir[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainAir[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainAir[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "G"
			Local $CGMainGround = ClanGamesChallenges("$GroundTroopChallenges")
			For $i = 0 To UBound($g_abCGMainGroundItem) - 1
				If $g_abCGMainGroundItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "GroundTroopChallenges: " & $CGMainGround[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainGround[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainGround[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "M"
			Local $CGMainMisc = ClanGamesChallenges("$MiscChallenges")
			For $i = 0 To UBound($g_abCGMainMiscItem) - 1
				If $g_abCGMainMiscItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "MiscChallenges: " & $CGMainMisc[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainMisc[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainMisc[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "S"
			Local $CGMainSpell = ClanGamesChallenges("$SpellChallenges")
			For $i = 0 To UBound($g_abCGMainSpellItem) - 1
				If $g_abCGMainSpellItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "SpellChallenges: " & $CGMainSpell[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainSpell[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGMainSpell[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)	
				EndIf
			Next
		Case "BBB"
			Local $CGBBBattle = ClanGamesChallenges("$BBBattleChallenges")
			For $i = 0 To UBound($g_abCGBBBattleItem) - 1
				If $g_abCGBBBattleItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBBattleChallenges: " & $CGBBBattle[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBBattle[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBBattle[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "BBD"
			Local $CGBBDestruction = ClanGamesChallenges("$BBDestructionChallenges")
			For $i = 0 To UBound($g_abCGBBDestructionItem) - 1
				If $g_abCGBBDestructionItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBDestructionChallenges: " & $CGBBDestruction[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBDestruction[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBDestruction[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
		Case "BBT"
			Local $CGBBTroops = ClanGamesChallenges("$BBTroopsChallenges")
			For $i = 0 To UBound($g_abCGBBTroopsItem) - 1
				If $g_abCGBBTroopsItem[$i] > 0 Then
					If $g_bChkClanGamesDebug Then SetLog("[" & $i & "]" & "BBTroopsChallenges: " & $CGBBTroops[$i][1], $COLOR_DEBUG)
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBTroops[$i][0] & "_*", $sTempPath, $FC_OVERWRITE + $FC_CREATEPATH)
				Else
					FileCopy($sImagePath & "\" & $sImageType & "-" & $CGBBTroops[$i][0] & "_*", $sTempPath & "\Purge\", $FC_OVERWRITE + $FC_CREATEPATH)
				EndIf
			Next
	EndSwitch
	If $sImageType = "Selected" Then 
		If $g_bChkClanGamesDebug Then SetLog("[" & $ImageName & "] Selected", $COLOR_DEBUG)
		FileCopy($sImagePath & "\" & $ImageName & "_*", $sTempPath & "\Selected\", $FC_OVERWRITE + $FC_CREATEPATH)
	EndIf
EndFunc ;==>ClanGameImageCopy

Func FindEvent()
	Local $hStarttime = _Timer_Init()
	Local $sImagePath = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Challenges"
	Local $sTempPath = @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\"
	Local $aEvent, $aReturn[0][6], $toBottom = False
	Local $aX[4] = [290, 415, 542, 668]
	Local $aY[3] = [119 + $g_iMidOffsetY, 278 + $g_iMidOffsetY, 438 + $g_iMidOffsetY]
	
	For $y = 0 To Ubound($aY) - 1
		For $x = 0 To Ubound($aX) - 1
			$aEvent = QuickMIS("CNX", $sTempPath, $aX[$x], $aY[$y], $aX[$x] + 107, $aY[$y] + 110);270,130|790,130|790,570|270,570 Diamond For Check
			If IsArray($aEvent) And UBound($aEvent) > 0 Then 
				Local $IsBBEvent = IsBBChallenge($aEvent[0][1], $aEvent[0][2])
				If $IsBBEvent Then $IsBBEvent = "CGBB"
				If Not $IsBBEvent Then $IsBBEvent = "CGMain"
				Local $ChallengeEvent = StringSplit($aEvent[0][0], "-", $STR_NOCOUNT)
				ClanGameImageCopy($sImagePath, $sTempPath, "Selected", $aEvent[0][0])
				;Return Case(L, A, S, etc...), Event File Name, X, Y, IsBBEvent, Full File Event Name 
				_ArrayAdd($aReturn, $ChallengeEvent[0] & "|" & $ChallengeEvent[1] & "|" & $aEvent[0][1] & "|" & $aEvent[0][2] & "|" & $IsBBEvent & "|" & $aEvent[0][0] )
			EndIf
		Next
	Next
	SetDebugLog("Benchmark FindEvent selection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms", $COLOR_DEBUG)
	Return $aReturn
EndFunc

Func IsClanGamesWindow($getCapture = True)
	Local $sState, $bRet = False
	Local $Found = False
	Local $currentDate = Number(@MDAY)
	
	For $i = 1 To 10
		If QuickMIS("BC1", $g_sImgCaravan, 180, 55, 300, 120 + $g_iMidOffsetY, $getCapture, False) Then
			$Found = True
			SetLog("Caravan available! Entering Clan Games", $COLOR_SUCCESS)
			Click($g_iQuickMISX, $g_iQuickMISY)
			; Just wait for window open
			If _Sleep(2500) Then Return
			$sState = IsClanGamesRunning()
			Switch $sState
				Case "Prepare"
					$bRet = False
				Case "Running"
					$bRet = True
				Case "Ended"
					$bRet = False
			EndSwitch
			ExitLoop
		EndIf
		If QuickMIS("BC1", $g_sImgBeforeCG, 200, 70, 300, 120 + $g_iMidOffsetY, $getCapture, False) And $currentDate < 23 Then
			$Found = True
			$sState = "Prepare"
			$bRet = False
			ExitLoop
		EndIf
		If $currentDate >= 28 And Not QuickMIS("BC1", $g_sImgCaravan, 180, 55, 300, 120 + $g_iMidOffsetY, $getCapture, False) Then
			$g_bClanGamesCompleted = 1
			$Found = False
			$bRet = False
			ExitLoop
		EndIf
		_Sleep(1000)
	Next
	
	If $Found = False And $currentDate < 22 Then
		SetLog("Caravan not available", $COLOR_WARNING)
		$sState = "Not Running"
		$bRet = False
	ElseIf $Found = False And $currentDate >= 28 Then
		SetLog("Caravan not available", $COLOR_WARNING)
		SetLog("Clan Games has already been completed")
		$sState = "Ended"
		$bRet = False
	EndIf

	SetLog("Clan Games State is : " & $sState, $COLOR_INFO)
	Return $bRet
EndFunc   ;==>IsClanGamesWindow

Func IsClanGamesWindow2($getCapture = True)
	Local $sState, $bRet = False
	Local $Found = False
	Local $currentDate = Number(@MDAY)
	
	For $i = 1 To 10
		If QuickMIS("BC1", $g_sImgCaravan, 200, 55, 300, 120 + $g_iMidOffsetY, $getCapture, False) Then
			$Found = True
			SetLog("Caravan available! Entering Clan Games", $COLOR_SUCCESS)
			Click($g_iQuickMISX, $g_iQuickMISY)
			; Just wait for window open
			If _Sleep(2500) Then Return
			$sState = IsClanGamesRunning()
			Switch $sState
				Case "Prepare"
					$bRet = False
				Case "Running"
					$bRet = True
				Case "Ended"
					$bRet = False
			EndSwitch
			ExitLoop
		EndIf
		If QuickMIS("BC1", $g_sImgBeforeCG, 200, 70, 300, 120 + $g_iMidOffsetY, $getCapture, False) And $currentDate < 23 Then
			$Found = True
			Click($g_iQuickMISX, $g_iQuickMISY)
			; Just wait for window open
			If _Sleep(2500) Then Return
			$sState = IsClanGamesRunning()
			$bRet = False
			ExitLoop
		EndIf
		If $currentDate >= 28 And Not QuickMIS("BC1", $g_sImgCaravan, 180, 55, 300, 120 + $g_iMidOffsetY, $getCapture, False) Then
			$g_bClanGamesCompleted = 1
			$Found = False
			$bRet = False
			ExitLoop
		EndIf
		_Sleep(1000)
	Next
	
	If $Found = False And $currentDate < 22 Then
		SetLog("Caravan not available", $COLOR_WARNING)
		$sState = "Not Running"
		$bRet = False
	ElseIf $Found = False And $currentDate >= 28 Then
		SetLog("Caravan not available", $COLOR_WARNING)
		SetLog("Clan Games has already been completed")
		$sState = "Ended"
		$bRet = False
	EndIf

	SetLog("Clan Games State is : " & $sState, $COLOR_INFO)
	Return $bRet
EndFunc   ;==>IsClanGamesWindow

Func IsClanGamesRunning($getCapture = True) ;to check whether clangames current state, return string of the state "prepare" "running" "end"
	Local $aGameTime[4] = [384, 388, 0xFFFFFF, 10]
	Local $sState = "Running"
	If QuickMIS("BC1", $g_sImgWindow, 70, 70 + $g_iMidOffsetY, 150, 120 + $g_iMidOffsetY, $getCapture, False) Then
		SetLog("Window Opened", $COLOR_DEBUG)
		If QuickMIS("BC1", $g_sImgReward, 580, 450 + $g_iMidOffsetY, 830, 540 + $g_iMidOffsetY, $getCapture, False) Then
			SetLog("Your Reward is Ready", $COLOR_INFO)
			CollectClanGamesRewards()
			$sState = "Ended"
			If Not $g_bChkClanGamesCollectRewards Then $g_bClanGamesCompleted = 1
		EndIf
	Else
		If _CheckPixel($aGameTime, True) Then
			Local $sTimeRemain = getOcrTimeGameTime(370, 431 + $g_iMidOffsetY) ; read Clan Games waiting time
			SetLog("Clan Games will start in " & $sTimeRemain, $COLOR_INFO)
			$g_sClanGamesTimeRemaining = $sTimeRemain
			$sState = "Prepare"
		Else
			SetLog("Clan Games Window Not Opened", $COLOR_DEBUG)
			$sState = "Cannot open ClanGames"
		EndIf
	EndIf
	Return $sState
EndFunc ;==>IsClanGamesRunning

Func IsClanGamesRunning2($getCapture = True) ;to check whether clangames current state, return string of the state "prepare" "running" "end"
	Local $aGameTime[4] = [384, 358 + $g_iMidOffsetY, 0xFFFFFF, 10]
	Local $sState = "Running"
	If QuickMIS("BC1", $g_sImgWindow, 70, 70 + $g_iMidOffsetY, 150, 120 + $g_iMidOffsetY, $getCapture, False) Then
		If QuickMIS("BC1", $g_sImgReward, 580, 450 + $g_iMidOffsetY, 830, 540 + $g_iMidOffsetY, $getCapture, False) Then
			$sState = "Ended"
		EndIf
	Else
		If _CheckPixel($aGameTime, True) Then
			Local $sTimeRemain = getOcrTimeGameTime(370, 431 + $g_iMidOffsetY) ; read Clan Games waiting time
			$g_sClanGamesTimeRemaining = $sTimeRemain
			$sState = "Prepare"
		Else
			$sState = "Cannot open ClanGames"
		EndIf
	EndIf
	Return $sState
EndFunc ;==>IsClanGamesRunning

Func GetTimesAndScores()
	Local $iRestScore = -1, $sYourGameScore = "", $aiScoreLimit, $sTimeRemain = 0

	;Ocr for game time remaining
	$sTimeRemain = StringReplace(getOcrTimeGameTime(55, 447 + $g_iMidOffsetY), " ", "") ; read Clan Games waiting time

	;Check if OCR returned a valid timer format
	If Not StringRegExp($sTimeRemain, "([0-2]?[0-9]?[DdHhSs]+)", $STR_REGEXPMATCH, 1) Then
		SetLog("getOcrTimeGameTime(): no valid return value (" & $sTimeRemain & ")", $COLOR_ERROR)
	EndIf

	SetLog("Clan Games time remaining: " & $sTimeRemain, $COLOR_INFO)

	; This Loop is just to check if the Score is changing , when you complete a previous events is necessary to take some time
	For $i = 0 To 10
		$sYourGameScore = getOcrYourScore(45, 500 + $g_iMidOffsetY) ;  Read your Score
		If $g_bChkClanGamesDebug Then SetLog("Your OCR score: " & $sYourGameScore)
		$sYourGameScore = StringReplace($sYourGameScore, "#", "/")
		$aiScoreLimit = StringSplit($sYourGameScore, "/", $STR_NOCOUNT)
		If UBound($aiScoreLimit, 1) > 1 Then
			If $iRestScore = Int($aiScoreLimit[0]) Then ExitLoop
			$iRestScore = Int($aiScoreLimit[0])
		Else
			Return -1
		EndIf
		If _Sleep(800) Then Return
		If $i = 10 Then Return -1
	Next

	;Update Values
	$g_sClanGamesScore = $sYourGameScore
	$g_sClanGamesTimeRemaining = $sTimeRemain

	$aiScoreLimit[0] = Int($aiScoreLimit[0])
	$aiScoreLimit[1] = Int($aiScoreLimit[1])
	Return $aiScoreLimit
EndFunc   ;==>GetTimesAndScores

Func IsEventRunning($bOpenWindow = False)
	Local $aEventFailed[4] = [300, 225 + $g_iMidOffsetY, 0xEA2B24, 20]
	Local $aEventPurged[4] = [300, 236 + $g_iMidOffsetY, 0x57C68F, 20]
	
	If $bOpenWindow Then
		ClickAway()
		SetLog("Entering Clan Games", $COLOR_INFO)
		If Not IsClanGamesWindow() Then Return
	EndIf

	; Check if any event is running or not
	If Not _ColorCheck(_GetPixelColor(300, 236 + $g_iMidOffsetY, True), Hex(0x53E050, 6), 5) Then ; Green Bar from First Position
		;Check if Event failed
		If _CheckPixel($aEventFailed, True) Then
			SetLog("Couldn't finish last event! Lets trash it and look for a new one", $COLOR_INFO)
			If TrashFailedEvent() Then
				If _Sleep(3000) Then Return ;Add sleep here, to wait ClanGames Challenge Tile ordered again as 1 has been deleted
				Return False
			Else
				SetLog("Error happend while trashing failed event", $COLOR_ERROR)
				CloseWindow()
				Return True
			EndIf
		ElseIf _CheckPixel($aEventPurged, True) Then
				SetLog("An event purge cooldown in progress!", $COLOR_WARNING)
				CloseWindow()
				Return True
		Else
			SetLog("An event is already in progress!", $COLOR_SUCCESS)
			
			;check if its Enabled Challenge, if not = purge
			
			Local $bNeedPurge = False
			Local $aActiveEvent = QuickMIS("CNX", @TempDir & "\" & $g_sProfileCurrentName & "\Challenges\", 298, 127 + $g_iMidOffsetY, 388, 217 + $g_iMidOffsetY, True) 
			If IsArray($aActiveEvent) And UBound($aActiveEvent) > 0 Then
				SetLog("Active Challenge " & $aActiveEvent[0][0] & " is Enabled on Setting, OK!!", $COLOR_DEBUG)
				
				If $g_bAttackCGPlannerEnable And $g_bAttackCGPlannerDayLimit And $g_bFirstStartForAll Then
					Local $remainingCGattacks = $iRandomAttackCGCountToday - $g_aiAttackedCGCount
					LiveDailyCount()
					If $remainingCGattacks = 0 Then
						SetLog("Running Last Challenge Of This Day", $COLOR_ERROR)
					ElseIf $remainingCGattacks > 0 Then
						SetLog("Remaining Challenges Today After This One : " & $remainingCGattacks & "", $COLOR_OLIVE)
					EndIf
				EndIf
				
				If $g_bAttackCGPlannerEnable And $g_bAttackCGPlannerDayLimit And Not $g_bFirstStartForAll Then
					$g_bFirstStartAccountCGRA = 1
					$g_aiAttackedCGCount += 1
					LiveDailyCount()
					Local $remainingCGattacks = $iRandomAttackCGCountToday - $g_aiAttackedCGCount
					If $remainingCGattacks = 0 Then
						SetLog("Running Last Challenge Of This Day", $COLOR_ERROR)
					ElseIf $remainingCGattacks > 0 Then
						SetLog("Remaining Challenges Today After This One : " & $remainingCGattacks & "", $COLOR_OLIVE)
					EndIf
					$g_bFirstStartForAll = 1
				EndIf
				
				;check if Challenge is BB Challenge, enabling force BB attack
				If $g_bChkForceBBAttackOnClanGames Then
					
					Click(340,210)
					If _Sleep(1000) Then Return
					SetLog("Re-Check If Running Challenge is BB Event or No?", $COLOR_DEBUG1)
					If QuickMIS("BC1", $g_sImgVersus, 425, 150 + $g_iMidOffsetY, 700, 205 + $g_iMidOffsetY, True, False) Then
						Setlog("Running Challenge is BB Challenge", $COLOR_INFO)
						If $aActiveEvent[0][0] = "D-BBreakdown" Or $aActiveEvent[0][0] = "D-WallWhacker" Then 
							SetLog("Event with shared Image: " & $aActiveEvent[0][0])
							If $g_abCGBBDestructionItem[14] < 1 Then $bNeedPurge = True ;WallDes
							If $g_abCGBBDestructionItem[1] < 1 Then $bNeedPurge = True ;BuildingDes
						EndIf
						If $bNeedPurge Then ;Purge BB event, Not Wanted
							Setlog("Event started by mistake?", $COLOR_ERROR)
							PurgeEvent(False, False)
						EndIf
						$g_bIsBBevent = 1
					Else
						Setlog("Running Challenge is MainVillage Challenge", $COLOR_OLIVE)
						If $aActiveEvent[0][0] = "BBD-WallDes" Or $aActiveEvent[0][0] = "BBD-BuildingDes" Then 
							SetLog("Event with shared Image: " & $aActiveEvent[0][0])
							If $g_abCGMainDestructionItem[23] < 1 Then $bNeedPurge = True ;BBreakdown
							If $g_abCGMainDestructionItem[22] < 1 Then $bNeedPurge = True ;WallWhacker
						EndIf
						If $bNeedPurge Then ;Purge Event, Not Wanted
							Setlog("Event started by mistake?", $COLOR_ERROR)
							PurgeEvent(False, False)
						EndIf
						$g_bIsBBevent = 0
					EndIf
				EndIf
			Else
				Setlog("Active Challenge Not Enabled on Setting! started by mistake?", $COLOR_ERROR)
				PurgeEvent(False, False)
				CloseWindow()
				Return True
			EndIf
			CloseWindow()
			Return True
		EndIf
	Else
		SetLog("No event under progress", $COLOR_INFO)
		$g_bFirstStartForAll = 1
		Return False
	EndIf
	Return False
EndFunc   ;==>IsEventRunning

Func ClickOnEvent(ByRef $YourAccScore, $ScoreLimits, $sEventName, $getCapture)
	If Not $YourAccScore[$g_iCurAccount][1] Then
		Local $Text = "", $color = $COLOR_SUCCESS
		If $YourAccScore[$g_iCurAccount][0] <> $ScoreLimits[0] Then
			$Text = "You got " & $ScoreLimits[0] - $YourAccScore[$g_iCurAccount][0] & " points in last Event"
		Else
			$Text = "You could not complete the last event!"
			$color = $COLOR_WARNING
		EndIf
		SetLog($Text, $color)
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - " & $Text)
	EndIf
	$YourAccScore[$g_iCurAccount][1] = False
	$YourAccScore[$g_iCurAccount][0] = $ScoreLimits[0]
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $YourAccScore[" & $g_iCurAccount & "][1]: " & $YourAccScore[$g_iCurAccount][1])
	If $g_bChkClanGamesDebug Then SetLog("ClickOnEvent $YourAccScore[" & $g_iCurAccount & "][0]: " & $YourAccScore[$g_iCurAccount][0])
	If Not StartsEvent($sEventName, $getCapture, $g_bChkClanGamesDebug) Then Return False
	CloseWindow()
	Return True
EndFunc   ;==>ClickOnEvent

Func StartsEvent($sEventName, $getCapture = True, $g_bChkClanGamesDebug = False)
	If Not $g_bRunState Then Return

	If QuickMIS("BC1", $g_sImgStart, 220, 120 + $g_iMidOffsetY, 830, 550 + $g_iMidOffsetY, $getCapture, False) Then
		Local $Timer = GetEventTimeInMinutes($g_iQuickMISX, $g_iQuickMISY)
		SetLog("Starting Event" & " [" & $Timer & " min]", $COLOR_SUCCESS)
		Click($g_iQuickMISX, $g_iQuickMISY)
		If $g_iTxtCurrentVillageName <> "" Then
		GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] - Starting " & $sEventName & " for " & $Timer & " min", 1)
		$g_aiAttackedCGCount += 1
		LiveDailyCount()
		Else
		GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min", 1)
		$g_aiAttackedCGCount += 1
		LiveDailyCount()
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Starting " & $sEventName & " for " & $Timer & " min")
		$g_bFirstStartForAll = 1
		
		;check if Challenge is BB Challenge, enabling force BB attack
		If $g_bChkForceBBAttackOnClanGames Then
			Click(450,75) ;Click Clan Tab
			If _Sleep(3000) Then Return
			Click(300,75) ;Click Challenge Tab
			If _Sleep(500) Then Return
			Click(340,210) ;Click Active Challenge
			If _Sleep(1000) Then Return
			
			SetLog("Re-Check If Running Challenge is BB Event or No?", $COLOR_DEBUG1)
			If QuickMIS("BC1", $g_sImgVersus, 425, 150 + $g_iMidOffsetY, 700, 205 + $g_iMidOffsetY, True, False) Then
				Setlog("Running Challenge is BB Challenge", $COLOR_INFO)
				$g_bIsBBevent = 1
			Else
				Setlog("Running Challenge is MainVillage Challenge", $COLOR_OLIVE)
				$g_bIsBBevent = 0
			EndIf
		EndIf
		Return True
	Else
		SetLog("Didn't Get the Green Start Button Event", $COLOR_WARNING)
		If $g_bChkClanGamesDebug Then SetLog("[X: " & 220 & " Y:" & 150 & " X1: " & 830 & " Y1: " & 580 & "]", $COLOR_WARNING)
		CloseWindow()
		Return False
	EndIf

EndFunc   ;==>StartsEvent

Func PurgeEvent($bTest = False, $startFirst = True)

	If $g_bChkCCGDebugNoneFound Then
		SaveDebugImage("CG_All_Challenges", True)
		If _Sleep(1000) Then Return
	EndIf

	Local $SearchArea

	Click(344,180 + $g_iMidOffsetY) ;Most Top Challenge

	If _Sleep(1000) Then Return
	If $startFirst Then
		Local $sTimeCG
		$sTimeCG = ConvertOCRTime("ClanGames()", $g_sClanGamesTimeRemaining, True)
		If $sTimeCG > 1440 And $g_bChkClanGamesStopBeforeReachAndPurge Then
			SetLog("Start and Purge a Challenge", $COLOR_INFO)
		Else
			SetLog("No event Found, Start and Purge a Challenge", $COLOR_INFO)
		EndIf
		If StartAndPurgeEvent($bTest) Then
			CloseWindow()
			SetCGCoolDownTime()
			Return True
		EndIf
	Else
		SetLog("Purge a Wrong Challenge", $COLOR_INFO)
		If QuickMIS("BC1", $g_sImgTrashPurge, 400, 170 + $g_iMidOffsetY, 700, 320 + $g_iMidOffsetY, True, False) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1200) Then Return
			SetLog("Click Trash", $COLOR_INFO)
			If QuickMIS("BC1", $g_sImgOkayPurge, 440, 370 + $g_iMidOffsetY, 580, 420 + $g_iMidOffsetY, True, False) Then
				SetLog("Click OK", $COLOR_INFO)
				If $bTest Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(1500) Then Return
				If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] - PurgeEvent: Purge a Wrong Challenge ", 1)
				Else
				GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - PurgeEvent: Purge a Wrong Challenge ", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - PurgeEvent: Purge a Wrong Challenge ")
				SetCGCoolDownTime()
				If _Sleep(1500) Then Return
			Else
				SetLog("$g_sImgOkayPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		Else
			SetLog("$g_sImgTrashPurge Issue", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	Return False
EndFunc   ;==>PurgeEvent

Func StartAndPurgeEvent($bTest = False)

	If QuickMIS("BC1", $g_sImgStart, 220, 120 + $g_iMidOffsetY, 700, 370 + $g_iMidOffsetY, True, False) Then
		Local $Timer = GetEventTimeInMinutes($g_iQuickMISX , $g_iQuickMISY)
		SetLog("Starting  Event" & " [" & $Timer & " min]", $COLOR_SUCCESS)
		Click($g_iQuickMISX, $g_iQuickMISY)
		If $g_iTxtCurrentVillageName <> "" Then
		GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] - Starting Purge for " & $Timer & " min", 1)
		Else
		GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Starting Purge for " & $Timer & " min", 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Starting Purge for " & $Timer & " min")

		If _Sleep(3000) Then Return
		If QuickMIS("BC1", $g_sImgTrashPurge, 400, 170 + $g_iMidOffsetY, 700, 320 + $g_iMidOffsetY, True, False) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(3000) Then Return
			SetLog("Click Trash", $COLOR_INFO)
			If QuickMIS("BC1", $g_sImgOkayPurge, 440, 370 + $g_iMidOffsetY, 580, 420 + $g_iMidOffsetY, True, False) Then
				SetLog("Click OK", $COLOR_INFO)
				If $bTest Then Return
				Click($g_iQuickMISX, $g_iQuickMISY)
				SetLog("Start And Purge Any Event!", $COLOR_SUCCESS)
				If $g_iTxtCurrentVillageName <> "" Then
					GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] - Start And Purge Any Event : No event Found ", 1)
				Else
					GUICtrlSetData($g_hTxtClanGamesLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] - Start And Purge Any Event : No event Found ", 1)
				EndIf
				_FileWriteLog($g_sProfileLogsPath & "\ClanGames.log", " [" & $g_sProfileCurrentName & "] - Start And Purge Any Event : No event Found ")
			Else
				SetLog("$g_sImgOkayPurge Issue", $COLOR_ERROR)
				Return False
			EndIf
		Else
			SetLog("$g_sImgTrashPurge Issue", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	If _Sleep(1500) Then Return
	Return True
EndFunc

Func TrashFailedEvent()
	;Look for the red cross on failed event
	If Not ClickB("EventFailed") Then
		SetLog("Could not find the failed event icon!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(1000) Then Return

	;Look for the red trash event Button and press it
	If Not ClickB("TrashEvent") Then
		SetLog("Could not find the trash event button!", $COLOR_ERROR)
		Return False
	EndIf

	If _Sleep(500) Then Return
	Return True
EndFunc   ;==>TrashFailedEvent

Func GetEventTimeInMinutes($iXStartBtn, $iYStartBtn, $bIsStartBtn = True)

	Local $XAxis = $iXStartBtn - 163 ; Related to Start Button
	Local $YAxis = $iYStartBtn + 8 ; Related to Start Button

	If Not $bIsStartBtn Then
		$XAxis = $iXStartBtn - 163 ; Related to Trash Button
		$YAxis = $iYStartBtn + 8 ; Related to Trash Button
	EndIf

	Local $Ocr = getOcrEventTime($XAxis, $YAxis)
	If $Ocr = "1" Then $Ocr = "1d"
	If $Ocr = "2" Then $Ocr = "2d"
    Return ConvertOCRTime("ClanGames()", $Ocr, False)
EndFunc   ;==>GetEventTimeInMinutes

Func GetEventInformation()
	If QuickMIS("BC1", $g_sImgStart, 220, 120 + $g_iMidOffsetY, 830, 550 + $g_iMidOffsetY, True, False) Then
		Return GetEventTimeInMinutes($g_iQuickMISX, $g_iQuickMISY)
	Else
		Return 0
	EndIf
EndFunc   ;==>GetEventInformation


Func IsBBChallenge($i = Default, $j = Default)

	Local $BorderX[4] = [294, 420, 546, 672]
	Local $BorderY[3] = [175 + $g_iMidOffsetY, 333 + $g_iMidOffsetY, 490 + $g_iMidOffsetY]
	Local $iColumn, $iRow, $bReturn

	Switch $i
		Case $BorderX[0] To $BorderX[1]
			$iColumn = 1
		Case $BorderX[1] To $BorderX[2]
			$iColumn = 2
		Case $BorderX[1] To $BorderX[3]
			$iColumn = 3
		Case Else
			$iColumn = 4
	EndSwitch

	Switch $j
		Case $BorderY[0]-50 To $BorderY[1]-50
			$iRow = 1
		Case $BorderY[1]-50 To $BorderY[2]-50
			$iRow = 2
		Case Else
			$iRow = 3
	EndSwitch
	If $g_bChkClanGamesDebug Then SetLog("Row: " & $iRow & ", Column : " & $iColumn, $COLOR_DEBUG)
	For $y = 0 To 2
		For $x = 0 To 3
			If $iRow = ($y+1) And $iColumn = ($x+1) Then 
				;Search image border, our image is MainVillage event border, so If found return False
				If QuickMIS("BC1", $g_sImgBorder, $BorderX[$x] - 50, $BorderY[$y] - 50, $BorderX[$x] + 50, $BorderY[$y] + 50, True, False) Then
					If $g_bChkClanGamesDebug Then SetLog("IsBBChallenge = False", $COLOR_ERROR)
					Return False
				Else
					If $g_bChkClanGamesDebug Then SetLog("IsBBChallenge = True", $COLOR_INFO)
					Return True
				EndIf
			EndIf
		Next
	Next
	
EndFunc ;==>IsBBChallenge

Func ClanGamesChallenges($sReturnArray)

	;[0]=ImageName
	;[1]=Challenge Name
	;[2]=THlevel
	;[3]=Difficulty
	;[4]=Description

	Local $LootChallenges[6][5] = [ _
			["GoldChallenge", 			"Gold Challenge", 				 7, 6, "Loot certain amount of Gold from a single Multiplayer Battle"								], _ ;|8h 	|50
			["ElixirChallenge", 		"Elixir Challenge", 			 7, 6, "Loot certain amount of Elixir from a single Multiplayer Battle"								], _ ;|8h 	|50
			["DarkEChallenge", 			"Dark Elixir Challenge", 		 8, 6, "Loot certain amount of Dark elixir from a single Multiplayer Battle"						], _ ;|8h 	|50
			["GoldGrab", 				"Gold Grab", 					 6, 1, "Loot a total amount of Gold (accumulated from many attacks) from Multiplayer Battle"		], _ ;|1h-2d 	|100-600
			["ElixirEmbezz", 			"Elixir Embezzlement", 			 6, 1, "Loot a total amount of Elixir (accumulated from many attacks) from Multiplayer Battle"		], _ ;|1h-2d 	|100-600
			["DarkEHeist", 				"Dark Elixir Heist", 			 9, 1, "Loot a total amount of Dark Elixir (accumulated from many attacks) from Multiplayer Battle"	]]   ;|1h-2d 	|100-600

	Local $AirTroopChallenges[13][5] = [ _
			["Ball", 					"Balloon", 						 4, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Balloons"		], _ ;|3h-8h	|40-100
			["Drag", 					"Dragon", 						 7, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Dragons"			], _ ;	|3h-8h	|40-100
			["BabyD", 					"Baby Dragon", 					 9, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Baby Dragons"	], _ ;|3h-8h	|40-100
			["Edrag", 					"Electro Dragon", 				10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Electro Dragon"	], _ ;	|3h-8h	|40-300
			["RDrag", 					"Dragon Rider", 				10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Dragon Rider"	], _ ;	|3h-8h	|40-300
			["Mini", 					"Minion", 						 7, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Minions"			], _ ;|3h-8h	|40-100
			["Lava", 					"Lavahound", 					 9, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Lava Hounds"		], _ ;	|3h-8h	|40-100
			["RBall", 					"Rocket Balloon", 				12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Rocket Balloon"], _ ;
			["Smini", 					"Super Minion", 				12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Super Minion"], _ ;
			["InfernoD",				"Inferno Dragon", 				12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Inferno Dragon"], _ ;
			["IceH", 					"Ice Hound", 					12, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Ice Hound"], _ ;
			["BattleB", 				"Battle Blimp", 				10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using a of Battle Blimp"], _ ;
			["StoneS",	 				"Stone Slammer", 				10, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using a of Stone Slammer"]]   ;

	Local $GroundTroopChallenges[28][5] = [ _
			["Arch", 					"Archer", 						  6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Archers"		], _ ;	|3h-8h	|40-100
			["Barb", 					"Barbarian", 					  6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Barbarians"			], _ ;|3h-8h	|40-100
			["Giant", 					"Giant", 						  6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Giants"			], _ ;	|3h-8h	|40-100
			["Gobl", 					"Goblin", 						  2, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Goblins"			], _ ;|3h-8h	|40-100
			["Wall", 					"WallBreaker", 					  6, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Wall Breakers"	], _ ;|3h-8h	|40-100
			["Wiza", 					"Wizard", 						  5, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Wizards"			], _ ;|3h-8h	|40-100
			["Heal", 					"Healer", 				          4, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Healer"		    ], _ ;|3h-8h	|40-100
			["Hogs", 					"HogRider", 					  7, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Hog Riders"		], _ ;	|3h-8h	|40-100
			["Mine", 					"Miner", 						 10, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Miners"			], _ ;	|3h-8h	|40-100
			["Pekk", 					"Pekka", 						  8, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Pekka"       	], _ ;
			["Witc", 					"Witch", 						  9, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Witches"			], _ ;	|3h-8h	|40-100
			["Bowl", 					"Bowler", 						 10, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Bowlers"			], _ ;	|3h-8h	|40-100
			["Valk", 					"Valkyrie", 					  8, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Valkyries"		], _ ;|3h-8h	|40-100
			["Gole", 					"Golem", 						  8, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Golems"			], _ ;	|3h-8h	|40-100
			["Yeti", 					"Yeti", 						 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Yeti" 			], _ ;
			["IceG", 					"IceGolem", 					 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Ice Golem" 		], _ ;
			["Hunt", 					"HeadHunters", 					 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Head Hunters" 	], _ ;
			["Sbarb", 					"SuperBarbarian", 				 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Barbarian" ], _ ;
			["Sarch", 					"SuperArcher", 					 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Archer" 	], _ ;
			["Sgiant", 					"SuperGiant", 					 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Giant" 	], _ ;
			["Sgobl", 					"SneakyGoblin", 				 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Goblin" 	], _ ;
			["Swall", 					"SuperWallBreaker", 			 11, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Wall Breaker" ], _ ;
			["Swiza", 					"SuperWizard",					 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Wizard" 	], _ ;
			["Svalk", 					"SuperValkyrie",				 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Valkyrie"	], _ ;
			["Switc", 					"SuperWitch", 					 12, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Witch" 	], _ ;
			["WallW", 					"Wall Wrecker", 				 10, 1, "Earn 1-5 Stars from Multiplayer Battles using a Wall Wrecker" 					], _ ;
			["SiegeB", 					"Siege Barrack", 				 10, 1, "Earn 1-5 Stars from Multiplayer Battles using a Siege Barracks" 				], _ ;
			["LogL", 					"Log Launcher", 				 10, 1, "Earn 1-5 Stars from Multiplayer Battles using a Log Launcher"					]]   ;

	Local $BattleChallenges[22][5] = [ _
			["Start", 					"Star Collector", 				 6, 1, "Collect a total amount of Stars (accumulated from many attacks) from Multiplayer Battle"					], _ ;	|8h-2d	|100-600
			["Destruction", 			"Lord of Destruction", 			 6, 1, "Collect a total amount of percentage Destruction % (accumulated from many attacks) from Multiplayer Battle"	], _ ;	|8h-2d	|100-600
			["PileOfVictores", 			"Pile Of Victories", 			 6, 2, "Win 1-5 Multiplayer Battles"																				], _ ;	|8h-2d	|100-600
			["StarThree", 				"Hunt for Three Stars", 		10, 8, "Score a Perfect 3 Stars in Multiplayer Battles"																], _ ;	|8h 	|200
			["WinningStreak", 			"Winning Streak", 				 9, 8, "Win 1-5 Multiplayer Battles in a row"																		], _ ;|8h-2d	|100-600
			["SlayingTitans", 			"Slaying The Titans", 			11, 1, "Win a Multiplayer Battles In Titan League"																	], _ ;|5h		|300
			["NoHero", 					"No Heroics Allowed", 			 3, 5, "Win a stars without using Heroes"																			], _ ;	|8h		|100
			["NoMagic", 				"No-Magic Zone", 				 6, 5, "Win a stars without using Spells"																			], _ ;	|8h		|100
			["Scrappy6s", 				"Scrappy 6s", 					 6, 4, "Gain 3 Stars Against Town Hall level 6"																		], _ ;	|8h		|200
			["Super7s", 				"Super 7s", 					 7, 4, "Gain 3 Stars Against Town Hall level 7"																		], _ ;	|8h		|200
			["Exciting8s", 				"Exciting 8s", 					 8, 4, "Gain 3 Stars Against Town Hall level 8"																		], _ ;	|8h		|200
			["Noble9s", 				"Noble 9s", 					 9, 4, "Gain 3 Stars Against Town Hall level 9"																		], _ ;	|8h		|200
			["Terrific10s", 			"Terrific 10s", 				10, 4, "Gain 3 Stars Against Town Hall level 10"																	], _ ;	|8h		|200
			["Exotic11s", 			    "Exotic 11s", 					11, 4, "Gain 3 Stars Against Town Hall level 11"																	], _ ;	|8h		|200
			["Triumphant12s", 			"Triumphant 12s", 				12, 4, "Gain 3 Stars Against Town Hall level 12"																	], _ ;	|8h		|200
			["Tremendous13s", 			"Tremendous 13s", 				13, 4, "Gain 3 Stars Against Town Hall level 13"                                                             		], _ ;	|8h		|200
			["Formidable14s", 			"Formidable 14s", 				14, 4, "Gain 3 Stars Against Town Hall level 14"																	], _ ;	|3h		|300
			["AttackUp", 				"Attack Up", 					 6, 8, "Gain 3 Stars Against Town Hall a level higher"																], _ ;|8h		|200
			["ClashOfLegends", 			"Clash of Legends", 			11, 1, "Win a Multiplayer Battles In Legend League"                                                             	], _ ;
			["GainStarsFromClanWars",	"3 Stars From Clan War",		 6,99, "Gain 3 Stars on Clan War"                                                             						], _ ;
			["SpeedyStars", 			"3 Stars in 60 seconds",		 6, 2, "Gain 3 Stars (accumulated from many attacks) from Multiplayer Battle but only stars gained below a minute counted"], _ ;
			["SuperCharge", 			"Deploy SuperTroops",			 6, 0, "Deploy certain housing space of Any Super Troops"                                                           ]]

	Local $DestructionChallenges[34][5] = [ _
			["Cannon", 					"Cannon", 				 6, 1, "Destroy 5-25 Cannons in Multiplayer Battles"					], _ ;	|1h-8h	|75-350
			["ArcherT", 				"Archer Tower", 		 6, 1, "Destroy 5-20 Archer Towers in Multiplayer Battles"			], _ ;	|1h-8h	|75-350
			["BuilderHut", 				"Builder Hut", 		     6, 1, "Destroy 4-12 BuilderHut in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["Mortar", 					"Mortar", 				 6, 2, "Destroy 4-12 Mortars in Multiplayer Battles"					], _ ;	|1h-8h	|40-350
			["AirD", 					"Air Defenses", 		 7, 3, "Destroy 3-12 Air Defenses in Multiplayer Battles"			], _ ;|1h-8h	|40-350
			["WizardT", 				"Wizard Tower", 		 6, 3, "Destroy 4-12 Wizard Towers in Multiplayer Battles"			], _ ;	|1h-8h	|40-350
			["AirSweepers", 			"Air Sweepers", 		 8, 3, "Destroy 2-6 Air Sweepers in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["Tesla", 					"Tesla Towers", 		 7, 3, "Destroy 4-12 Hidden Teslas in Multiplayer Battles"			], _ ;	|1h-8h	|50-350
			["BombT", 					"Bomb Towers", 			 8, 3, "Destroy 2 Bomb Towers in Multiplayer Battles"				], _ ;|1h-8h	|50-350
			["Xbow", 					"X-Bows", 				 9, 4, "Destroy 3-12 X-Bows in Multiplayer Battles"					], _ ;	|1h-8h	|50-350
			["Inferno", 				"Inferno Towers", 		11, 4, "Destroy 2 Inferno Towers in Multiplayer Battles"				], _ ;	|1h-2d	|50-600
			["EagleA", 					"Eagle Artillery", 	    11, 5, "Destroy 1-7 Eagle Artillery in Multiplayer Battles"			], _ ;	|1h-2d	|50-600
			["ClanC", 					"Clan Castle", 			 5, 3, "Destroy 1-4 Clan Castle in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["GoldSRaid", 				"Gold Storage", 		 6, 3, "Destroy 3-15 Gold Storages in Multiplayer Battles"			], _ ;	|1h-8h	|40-350
			["ElixirSRaid", 			"Elixir Storage", 		 6, 3, "Destroy 3-15 Elixir Storages in Multiplayer Battles"			], _ ;	|1h-8h	|40-350
			["DarkEStorageRaid", 		"Dark Elixir Storage", 	 8, 3, "Destroy 1-4 Dark Elixir Storage in Multiplayer Battles"		], _ ;	|1h-8h	|40-350
			["GoldM", 					"Gold Mine", 			 6, 1, "Destroy 6-20 Gold Mines in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["ElixirPump", 				"Elixir Pump", 		 	 6, 1, "Destroy 6-20 Elixir Collectors in Multiplayer Battles"		], _ ;	|1h-8h	|40-350
			["DarkEPlumbers", 			"Dark Elixir Drill", 	 6, 1, "Destroy 2-8 Dark Elixir Drills in Multiplayer Battles"		], _ ;	|1h-8h	|40-350
			["Laboratory", 				"Laboratory", 			 6, 1, "Destroy 2-6 Laboratories in Multiplayer Battles"				], _ ;	|1h-8h	|40-200
			["SFacto", 					"Spell Factory", 		 6, 1, "Destroy 2-6 Spell Factories in Multiplayer Battles"			], _ ;	|1h-8h	|40-200
			["DESpell", 				"Dark Spell Factory", 	 8, 1, "Destroy 2-6 Dark Spell Factories in Multiplayer Battles"		], _ ;	|1h-8h	|40-200
			["WallWhacker", 			"Wall Whacker", 		10, 8, "Destroy 50-250 Walls in Multiplayer Battles"					], _ ;	|
			["BBreakdown",	 			"Building Breakdown", 	 6, 1, "Destroy 50-250 Buildings in Multiplayer Battles"				], _ ;		|
			["BKaltar", 				"Barbarian King Altars", 9, 4, "Destroy 2-5 Barbarian King Altars in Multiplayer Battles"	], _ ;|1h-8h	|50-150
			["AQaltar", 				"Archer Queen Altars", 	10, 4, "Destroy 2-5 Archer Queen Altars in Multiplayer Battles"		], _ ;	|1h-8h	|50-150
			["GWaltar", 				"Grand Warden Altars", 	11, 4, "Destroy 2-5 Grand Warden Altars in Multiplayer Battles"		], _ ;	|1h-8h	|50-150
			["HeroLevelHunter", 		"Hero Level Hunter", 	 9, 5, "Knockout 125 Level Heroes on Multiplayer Battles"			], _ ;|8h		|100
			["KingLevelHunter", 		"King Level Hunter", 	 9, 5, "Knockout 50 Level King on Multiplayer Battles"				], _ ;	|8h		|100
			["QueenLevelHunt", 			"Queen Level Hunter", 	10, 5, "Knockout 50 Level Queen on Multiplayer Battles"				], _ ;	|8h		|100
			["WardenLevelHunter", 		"Warden Level Hunter", 	11, 5, "Knockout 20 Level Warden on Multiplayer Battles"				], _ ;	|8h		|100
			["ArmyCamp", 				"Destroy ArmyCamp", 	 6, 1, "Destroy 3-16 Army Camp in Multiplayer Battles"				], _ ;	|8h		|100
			["ScatterShotSabotage",		"ScatterShot",			13, 5, "Destroy 1-4 ScatterShot in Multiplayer Battles"				], _ ;
			["ChampionLevelHunt",		"Champion Level Hunter",13, 5, "Knockout 20 Level Champion on Multiplayer Battles"			]]   ;


	Local $MiscChallenges[3][5] = [ _
			["Gard", 					"Gardening Exercise", 			 6, 8, "Clear 5 obstacles from your Home Village or Builder Base"		], _ ; |8h	|50
			["DonateSpell", 			"Donate Spells", 				 9, 8, "Donate a total of 3 spells"				], _ ; |8h	|50
			["DonateTroop", 			"Helping Hand", 				 6, 8, "Donate a total of 45 housing space worth of troops"			]]   ; 	|8h	|50


	Local $SpellChallenges[12][5] = [ _
			["LSpell", 					"Lightning", 					 6, 1, "Use certain amount of Lightning Spell to Win a Stars in Multiplayer Battles"	], _ ;
			["HSpell", 					"Heal",							 6, 1, "Use certain amount of Heal Spell to Win a Stars in Multiplayer Battles"			], _ ; updated 25/01/2021
			["RSpell", 					"Rage", 					 	 6, 1, "Use certain amount of Rage Spell to Win a Stars in Multiplayer Battles"			], _ ;
			["JSpell", 					"Jump", 					 	 6, 1, "Use certain amount of Jump Spell to Win a Stars in Multiplayer Battles"			], _ ;
			["FSpell", 					"Freeze", 					 	 9, 1, "Use certain amount of Freeze Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["CSpell", 					"Clone", 					 	11, 1, "Use certain amount of Clone Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["ISpell", 					"Invisibility", 			    11, 1, "Use certain amount of Invisibility Spell to Win a Stars in Multiplayer Battles"	], _ ;
			["PSpell", 					"Poison", 					 	 6, 1, "Use certain amount of Poison Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["ESpell", 					"Earthquake", 					 6, 1, "Use certain amount of Earthquake Spell to Win a Stars in Multiplayer Battles"	], _ ;
			["HaSpell", 				"Haste",	 					 6, 1, "Use certain amount of Haste Spell to Win a Stars in Multiplayer Battles"		], _ ; updated 25/01/2021
			["SkSpell",					"Skeleton", 					11, 1, "Use certain amount of Skeleton Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["BtSpell",					"Bat", 					 		10, 1, "Use certain amount of Bat Spell to Win a Stars in Multiplayer Battles"			]]   ;

    Local $BBBattleChallenges[4][5] = [ _
            ["StarM",					"BB Star Master",				 6, 1, "Collect certain amount of stars in Versus Battles"						], _ ; Earn 6 - 24 stars on the BB
            ["Victories",				"BB Victories",					 6, 3, "Get certain count of Victories in Versus Battles"						], _ ; Earn 3 - 6 victories on the BB
			["StarTimed",				"BB Star Timed",				 6, 2, "Earn stars in Versus Battles, but only stars gained below a minute counted"	], _
            ["Destruction",				"BB Destruction",				 6, 1, "Earn certain amount of destruction percentage (%) in Versus Battles"			]] ; Earn 225% - 900% on BB attacks

	Local $BBDestructionChallenges[18][5] = [ _
            ["Airbomb",					"Air Bomb",                 	6, 4, "Destroy certain number of Air Bomb in Versus Battles"		], _
			["BuildingDes",             "BB Building",					6, 4, "Destroy certain number of Building in Versus Battles"		], _
			["BuilderHall",             "BuilderHall",					6, 2, "Destroy certain number of Builder Hall in Versus Battles"	], _
            ["Cannon",                 	"BB Cannon",                  	6, 1, "Destroy certain number of Cannon in Versus Battles"			], _
			["ClockTower",             	"Clock Tower",                 	6, 1, "Destroy certain number of Clock Tower in Versus Battles"		], _
            ["DoubleCannon",         	"Double Cannon",             	6, 1, "Destroy certain number of Double Cannon in Versus Battles"	], _
			["FireCrackers",         	"Fire Crackers",              	6, 2, "Destroy certain number of Fire Crackers in Versus Battles"	], _
			["GemMine",                 "Gem Mine",                  	6, 1, "Destroy certain number of Gem Mine in Versus Battles"		], _
			["GiantCannon",             "Giant Cannon",               	6, 4, "Destroy certain number of Giant Cannon in Versus Battles"	], _
			["GuardPost",               "Guard Post",                 	6, 4, "Destroy certain number of Guard Post in Versus Battles"		], _
			["MegaTesla",               "Mega Tesla",               	6, 5, "Destroy certain number of Mega Tesla in Versus Battles"		], _
			["MultiMortar",             "Multi Mortar",               	6, 2, "Destroy certain number of Multi Mortar in Versus Battles"	], _
			["Roaster",                 "Roaster",			            6, 4, "Destroy certain number of Roaster in Versus Battles"			], _
			["StarLab",                 "Star Laboratory",              6, 1, "Destroy certain number of Star Laboratory in Versus Battles"	], _
			["WallDes",             	"Wall Whacker",              	6, 2, "Destroy certain number of Wall in Versus Battles"			], _
			["Crusher",             	"Crusher",                 		6, 2, "Destroy certain number of Crusher in Versus Battles"			], _
			["ArcherTower",             "Archer Tower",            		6, 1, "Destroy certain number of Archer Tower in Versus Battles"	], _
			["LavaLauncher",            "Lava Launcher",           		6, 5, "Destroy certain number of Lava Launcher in Versus Battles"	]]

	Local $BBTroopsChallenges[11][5] = [ _
            ["RBarb",					"Raged Barbarian",              6, 1, "Win 1-5 Attacks using Raged Barbarians in Versus Battle"	], _ ;BB Troops
            ["SArch",                 	"Sneaky Archer",                6, 1, "Win 1-5 Attacks using Sneaky Archer in Versus Battle"	], _
            ["BGiant",         			"Boxer Giant",             		6, 1, "Win 1-5 Attacks using Boxer Giant in Versus Battle"		], _
			["BMini",         			"Beta Minion",              	6, 1, "Win 1-5 Attacks using Beta Minion in Versus Battle"		], _
			["Bomber",                 	"Bomber",                  		6, 1, "Win 1-5 Attacks using Bomber in Versus Battle"			], _
			["BabyD",               	"Baby Dragon",                 	6, 1, "Win 1-5 Attacks using Baby Dragon in Versus Battle"		], _
			["CannCart",             	"Cannon Cart",               	6, 1, "Win 1-5 Attacks using Cannon Cart in Versus Battle"		], _
			["NWitch",                 	"Night Witch",                 	6, 1, "Win 1-5 Attacks using Night Witch in Versus Battle"		], _
			["DShip",                 	"Drop Ship",                  	6, 1, "Win 1-5 Attacks using Drop Ship in Versus Battle"		], _
			["SPekka",                 	"Super Pekka",                  6, 1, "Win 1-5 Attacks using Super Pekka in Versus Battle"		], _
			["HGlider",                 "Hog Glider",                  	6, 1, "Win 1-5 Attacks using Hog Glider in Versus Battle"		]]


	Switch $sReturnArray
		Case "$AirTroopChallenges"
			Return $AirTroopChallenges
		Case "$GroundTroopChallenges"
			Return $GroundTroopChallenges
		Case "$SpellChallenges"
			Return $SpellChallenges
        Case "$BBBattleChallenges"
            Return $BBBattleChallenges
		Case "$BBDestructionChallenges"
			Return $BBDestructionChallenges
		Case "$BBTroopsChallenges"
			Return $BBTroopsChallenges
		Case "$LootChallenges"
			Return $LootChallenges
		Case "$BattleChallenges"
			Return $BattleChallenges
		Case "$DestructionChallenges"
			Return $DestructionChallenges
		Case "$MiscChallenges"
			Return $MiscChallenges
	EndSwitch
	
EndFunc   ;==>ClanGamesChallenges

Func CollectClanGamesRewards($bTest = False)
	If Not $g_bChkClanGamesCollectRewards Then
		SetLog("Clan Games collect rewards disable!", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aRewardsList[41][2] = [ _  ; books-1, Research\Builder Pots-2, gems-3, runes-4, shovel-5,  50gems-6, all other Pots - 7, wall rings-8, 10gems - 9
		["BookOfEverything",		$g_iacmbPriorityReward[11]], _
		["BookOfHero",				$g_iacmbPriorityReward[11]], _
		["BookOfFighting",			$g_iacmbPriorityReward[11]], _
		["BookOfBuilding",			$g_iacmbPriorityReward[11]], _
		["BookOfSpell",				$g_iacmbPriorityReward[11]], _
		["Gems",					$g_iacmbPriorityReward[0]], _
		["RuneOfGold",				$g_iacmbPriorityReward[13]], _
		["RuneOfElixir",			$g_iacmbPriorityReward[13]], _
		["RuneOfDarkElixir",		$g_iacmbPriorityReward[14]], _
		["RuneOfBuilderGold",		$g_iacmbPriorityReward[16]], _
		["RuneOfBuilderElixir",		$g_iacmbPriorityReward[16]], _
		["Shovel",					$g_iacmbPriorityReward[4]], _
		["FullBookOfEverything",	$g_iacmbPriorityReward[12]], _ ; 50 gems
		["FullBookOfHero",			$g_iacmbPriorityReward[12]], _ ; 50 gems
		["FullBookOfFighting",		$g_iacmbPriorityReward[12]], _ ; 50 gems
		["FullBookOfBuilding",		$g_iacmbPriorityReward[12]], _ ; 50 gems
		["FullBookOfSpell",			$g_iacmbPriorityReward[12]], _ ; 50 gems
		["FullRuneOfGold",			$g_iacmbPriorityReward[21]], _ ; 50 gems
		["FullRuneOfElixir",		$g_iacmbPriorityReward[21]], _ ; 50 gems
		["FullRuneOfDarkElixir",	$g_iacmbPriorityReward[15]], _ ; 50 gems
		["FullRuneOfBuilderGold",	$g_iacmbPriorityReward[17]], _ ; 50 gems
		["FullRuneOfBuilderElixir",	$g_iacmbPriorityReward[17]], _ ; 50 gems
		["FullShovel",				$g_iacmbPriorityReward[5]], _ ; 50 gems
		["FullWallRing",			$g_iacmbPriorityReward[10]], _ ; ? gem
		["WallRing",				$g_iacmbPriorityReward[9]], _
		["PotBuilder",				$g_iacmbPriorityReward[2]], _ 
		["PotResearch",				$g_iacmbPriorityReward[6]], _ 
		["PotClock",				$g_iacmbPriorityReward[3]], _ 
		["PotBoost",				$g_iacmbPriorityReward[18]], _ 
		["PotHero",					$g_iacmbPriorityReward[1]], _
		["PotResources",			$g_iacmbPriorityReward[19]], _ 
		["PotPower",				$g_iacmbPriorityReward[7]], _ 
		["PotSuper",				$g_iacmbPriorityReward[20]], _ 
		["FullPotBuilder",			$g_iacmbPriorityReward[8]], _ ; 10 gems
		["FullPotResearch",			$g_iacmbPriorityReward[8]], _ ; 10 gems
		["FullPotClock",			$g_iacmbPriorityReward[8]], _ ; 10 gems
		["FullPotBoost",			$g_iacmbPriorityReward[8]], _ ; 10 gems
		["FullPotHero",				$g_iacmbPriorityReward[8]], _ ; 10 gems
		["FullPotResources",		$g_iacmbPriorityReward[8]], _ ; 10 gems 
		["FullPotPower",			$g_iacmbPriorityReward[8]], _ ; 10 gems
		["FullPotSuper",			$g_iacmbPriorityReward[8]]]   ; 10 gems
		
	Local $aiColumn[4] = [248, 190, 333, 494]
	Local $iColumnWidth = 108
	Local $sImgClanGamesReceivedWindow = 	@ScriptDir & "\imgxml\Windows\ClanGamesReceivedWindow*"
	Local $sImgClanGamesRewardsTab = 		@ScriptDir & "\imgxml\Windows\ClanGamesRewardsTab*"
	Local $sImgClanGamesExtraRewardWindow = @ScriptDir & "\imgxml\Windows\ClanGamesExtraRewardWindow*"

	If Not IsWindowOpen($sImgClanGamesRewardsTab, 30, 200, GetDiamondFromRect("190,45,830,185")) Then
		SetLog("Failed to verify Rewards Window!")
		Return False
	EndIf

	SaveDebugImage("ClanGamesRewardsWindow", False)
	
	Local $i = 0
	Local $bLoop = True
	Local $aCollectRewardsButton

	While $bLoop
		SetLog("Column :" & $i)
	
		DragRewardColumnIfNeeded($i)

		If $bTest Then SaveDebugRectImage("CGRewardSearch",$aiColumn[0] & "," & $aiColumn[1] & "," & $aiColumn[2] & "," & $aiColumn[3])

		Local $avRewards = SearchColumn($aiColumn, $aRewardsList)

		If Not IsArray($avRewards) Or UBound($avRewards, $UBOUND_ROWS) < 1 Then
			SetLog("No rewards found in column :" & $i, $COLOR_WARNING)
		Else
			DebugClanGamesRewards($avRewards, $i)

			; get Coord of top reward
			Local $iX = $avRewards[0][1]
			Local $iY = $avRewards[0][2]

			If Not SelectReward($iX, $iY) Then Return
		EndIf

		If _Sleep(250) Then Return

		; look for collect reward button
		$aCollectRewardsButton = findButton("ClanGamesCollectRewards", Default, 1, True)

		If IsArray($aCollectRewardsButton) And UBound($aCollectRewardsButton, 1) = 2 Then
			If _Sleep(250) Then Return
			SetLog("Found Collect Rewards Button")

			If $bTest = True Then Return True

			ClickP($aCollectRewardsButton)

			; wait for animations
			If _Sleep(2500) Then Return

			; check for bonus rewards - grey claim reward
			If IsWindowOpen($sImgClanGamesExtraRewardWindow, 10, 200, GetDiamondFromRect("570,505,830,570")) Then

				Local $avRewards = SearchColumn($aiColumn, $aRewardsList)

				If Not IsArray($avRewards) Or UBound($avRewards, $UBOUND_ROWS) < 1 Then
					SetLog("No rewards found in BOUNS column :" & $i, $COLOR_WARNING)
				Else
					DebugClanGamesRewards($avRewards, "Bonus")

					Local $iX = $avRewards[0][1]
					Local $iY = $avRewards[0][2]

					If Not SelectReward($iX, $iY) Then Return
				EndIf

				If _Sleep(1000) Then Return

				; claim bonus reward
				Local $aClaimRewardButton = findButton("ClanGamesClaimReward", Default, 1, True)

				If IsArray($aClaimRewardButton) And UBound($aClaimRewardButton, 1) = 2 Then
					If _Sleep(250) Then Return
					SetLog("Found Claim Rewards Button")

					ClickP($aClaimRewardButton)

					If _Sleep(250) Then Return
				EndIf
			EndIf

			; check rewards received summary page
			If IsWindowOpen($sImgClanGamesReceivedWindow, 10, 200, GetDiamondFromRect("225,150,800,595")) Then
				SetLog("Found Rewards Received Summary Window")

				SaveDebugImage("ClanGamesReceivedWindow", False)

				; click close window
				Click(817,83)

				If _Sleep(500) Then Return

				Return True
			EndIf

		EndIf

		;If _Sleep(250) Then Return

		If $i < 4 Then
			$aiColumn[0] = ($aiColumn[0] + $iColumnWidth)
			$aiColumn[2] = ($aiColumn[2] + $iColumnWidth)
		Else
			$aiColumn[0] = 743
			$aiColumn[1] = 190
			$aiColumn[2] = 838
			$aiColumn[3] = 494
		EndIf

		$i += 1
		
		If $i = 10 Then 
			$bLoop = False
			SaveDebugImage("ClanGamesRewardsWindow", False)
		EndIf
	Wend

	SetLog("Failed to locate Collect Rewards Button")

	Return False
EndFunc

Func SearchColumn($aiColumn, $aRewardsList)
	;If $sSearchArea = "" Then Return False

	Local $sRewardsDir = @ScriptDir & "\imgxml\Resources\ClanGamesImages\Rewards"
	Local $aSelectReward[0][4]
	Local $sSearchArea
	Local $avRewards
	; normal templates should cover the area of the animation
	$sSearchArea = GetDiamondFromArray($aiColumn)

	; animations on full storage rewards requires repeated search to locate
	Local $i = 0
	Local $iMax = 30
	While 1
		$avRewards = findMultiple($sRewardsDir, $sSearchArea, $sSearchArea, 0, 1000, 3, "objectname,objectpoints", True)

		; Exit loop if rewards found
		If IsArray($avRewards) Or UBound($avRewards, $UBOUND_ROWS) > 0 Then ExitLoop

		SetLog("No Rewards found in column - loop :" & $i)

		If _Sleep(100) Then Return

		$i += 1

		If $i > $iMax Then Return False
	WEnd

	;
	For $j = 0 to UBound($avRewards, $UBOUND_ROWS) - 1

		Local $avTempReward = $avRewards[$j]

		;SetLog("$avTempReward : " & $avTempReward[0] & " found at " & $avTempReward[1])

		For $k = 0 to UBound($aRewardsList) - 1
			;SetLog("$aRewardsList: " & $aRewardsList[$k][0] & " Piority " & $aRewardsList[$k][1])
			If $avTempReward[0] = $aRewardsList[$k][0] Then
				;SetLog("Matched!")
				Local $aiTempCoords = decodeSingleCoord($avTempReward[1])
				; [0] reward, [1] X axis, [2] Y axis, [3] Piority
				Local $aArray[4] = [$avTempReward[0], $aiTempCoords[0], $aiTempCoords[1], $aRewardsList[$k][1]]
			EndIf
		Next

		If IsDeclared("aArray") And $aArray[0] <> "" Then
			;SetLog("Added!")
			ReDim $aSelectReward[UBound($aSelectReward) + 1][4]
			$aSelectReward[UBound($aSelectReward) - 1][0] = $aArray[0] ; Reward
			$aSelectReward[UBound($aSelectReward) - 1][1] = $aArray[1] ; Xaxis
			$aSelectReward[UBound($aSelectReward) - 1][2] = $aArray[2] ; Yaxis
			$aSelectReward[UBound($aSelectReward) - 1][3] = $aArray[3] ; Piority
			$aArray[0] = ""
		EndIf

	Next

	_ArraySort($aSelectReward, 0, 0, 0, 3)

	Return $aSelectReward
EndFunc

Func SelectReward($iX, $iY)
	Local $sImgClanGamesStorageFullWindow =  @ScriptDir & "\imgxml\Windows\ClanGamesStorageFull*"
	Local $sSearchArea = "245,250,615,480"

	; click reward
	Click($iX, $iY)

	If _Sleep(1000) Then Return

	; check for storage full window
	If IsWindowOpen($sImgClanGamesStorageFullWindow, 0, 0, GetDiamondFromRect($sSearchArea)) Then

		Local $aYesButton = findButton("ClanGamesStorageFullYes", Default, 1, True)

		If IsArray($aYesButton) And UBound($aYesButton, 1) = 2 Then
			If _Sleep(250) Then Return
			ClickP($aYesButton)
			If _Sleep(250) Then Return
		EndIf

	EndIf

	Return True
EndFunc

Func DebugClanGamesRewards($avRewards, $sText = "")

	SetLog("Column " & $sText & " Valid Rewards :" & Ubound($avRewards))

	For $l = 0 to UBound($avRewards) - 1
		SetLog("$aSelectReward : " & $avRewards[$l][0])
	Next

EndFunc

Func DragRewardColumnIfNeeded($iColumn = 0)

	If $iColumn <= 4 Then Return

	If $iColumn = 5 Then
		ClickDrag(755, 190 + $g_iMidOffsetY, 755 - 47, 190 + $g_iMidOffsetY, 200)
	Else
		ClickDrag(755, 190 + $g_iMidOffsetY, 755 - 108, 190 + $g_iMidOffsetY, 200)
	EndIf

	If _Sleep(200) Then Return

	Return
EndFunc

Func CooldownTime($getCapture = True)
	;check cooldown purge
	Local $aiCoolDown = decodeSingleCoord(findImage("Cooldown", $g_sImgCoolPurge & "\*.xml", GetDiamondFromRect("480,370,570,410"), 1, True, Default))
	If IsArray($aiCoolDown) And UBound($aiCoolDown, 1) >= 2 Then
		SetLog("Cooldown Purge Detected", $COLOR_INFO)
		If _Sleep(1500) Then Return
		CloseWindow()
		Return True
	EndIf
	Return False
EndFunc   ;==>CooldownTime

Func SetCGCoolDownTime($bTest = False)
	$g_hCoolDownTimer = 0
	SetDebugLog("$g_hCoolDownTimer before: " & $g_hCoolDownTimer, $COLOR_DEBUG2)
	$g_hCoolDownTimer = TimerInit()
	Local $sleep = Random(500, 1500, 1)
	If _Sleep($sleep) Then Return
	SetDebugLog("$g_hCoolDownTimer after: " & Round(TimerDiff($g_hCoolDownTimer)/1000/60, 2), $COLOR_DEBUG2)
	
	If $bTest Then
		$sleep = Random(500, 5500, 1)
		If _Sleep($sleep) Then Return
		SetLog("Timer after " & $sleep & " : " & Round(TimerDiff($g_hCoolDownTimer)/1000/60, 2) & " Minutes", $COLOR_DEBUG2) 
		$g_hCoolDownTimer = 0
	EndIf
EndFunc

Func IsCGCoolDownTime()
	Local $iTimer = Round(TimerDiff($g_hCoolDownTimer)/1000/60, 2)
	SetDebugLog("CG Cooldown Timer : " & $iTimer)
	If $iTimer > 10 Then 
		$g_bIsCGCoolDownTime = False
	Else
		SetLog("Cooldown Time Detected: " & $iTimer & " Minutes", $COLOR_DEBUG2) 
		$g_bIsCGCoolDownTime = True
	EndIf
	
	Return $g_bIsCGCoolDownTime
EndFunc
	