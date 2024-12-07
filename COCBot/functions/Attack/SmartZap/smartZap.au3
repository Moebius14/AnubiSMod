; #FUNCTION# ====================================================================================================================
; Name ..........: smartZap
; Description ...: This file Includes all functions to current GUI
; Syntax ........: smartZap()
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(03-2016)
; Modified ......: TheRevenor(11-2016), ProMac(12-2016), TheRevenor(12-2016), TripleM(01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func displayZapLog(Const ByRef $aDarkDrills, Const ByRef $Spells)
	; Create the log entry string
	Local $drillStealableString = "Drills Lvl/Estimated Amount left: "
	Local $spellsLeftString = "Spells left: "
	; Loop through the array and add results to the log entry string
	For $i = 0 To UBound($aDarkDrills) - 1
		If $i = 0 Then
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= "Lvl" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		Else
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= ", Lvl" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		EndIf
	Next
	If $Spells[0][4] + $Spells[1][4] + $Spells[2][4] = 0 Then
		$spellsLeftString &= "None"
	Else
		If $Spells[2][4] > 0 Then $spellsLeftString &= $Spells[2][4] & " " & GetTroopName($Spells[2][1], 2)
		If $Spells[2][4] > 0 And $Spells[0][4] + $Spells[1][4] > 0 Then $spellsLeftString &= ", "
		If $Spells[0][4] + $Spells[1][4] > 0 Then $spellsLeftString &= $Spells[0][4] + $Spells[1][4] & " " & GetTroopName($Spells[1][1], 2)
	EndIf
	; Display the drill string if it contains any information
	If $drillStealableString <> "Drills Lvl/Estimated Amount left: " Then
		If Not $g_bNoobZap Then
			SetLog($drillStealableString, $COLOR_INFO)
		Else
			If $g_bDebugSmartZap = True Then SetLog($drillStealableString, $COLOR_DEBUG)
		EndIf
	EndIf
	If $spellsLeftString <> "Spells left: " Then
		SetLog($spellsLeftString, $COLOR_INFO)
	EndIf
EndFunc   ;==>displayZapLog

Func getDarkElixir()
	Local $g_iSearchDark = "", $iCount = 0

	;SetLog("Getting Dark Elixir Values.")
	If _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixir") Or _ColorCheck(_GetPixelColor(31, 151, True), Hex(0x282020, 6), 5) Then ; check if the village have a Dark Elixir Storage
		While $g_iSearchDark = ""
			$g_iSearchDark = getDarkElixirVillageSearch(48, 126 + 7)
			$iCount += 1
			If $iCount > 15 Then ExitLoop ; Check a couple of times in case troops are blocking the image
			If _Sleep($DELAYSMARTZAP1) Then Return
		WEnd
	Else
		$g_iSearchDark = False
		If $g_bDebugSmartZap = True Then SetLog(" - No DE detected.", $COLOR_DEBUG)
	EndIf

	Return $g_iSearchDark
EndFunc   ;==>getDarkElixir

Func getDrillOffset()
	Local $result = -1

	; Checking our global variable holding the town hall level
	Switch $g_iTownHallLevel
		Case 0 To 7
			$result = 2
		Case 8
			$result = 1
		Case Else
			$result = 0
	EndSwitch

	Return $result
EndFunc   ;==>getDrillOffset

Func getSpellOffset()
	Local $result = -1

	; Checking our global variable holding the town hall level
	Switch $g_iTownHallLevel
		Case 0 To 4
			$result = -1
		Case 5, 6
			; Town hall 5 and 6 have lightning spells, but why would you want to zap?
			$result = -1
		Case 7, 8
			$result = 2
		Case 9
			$result = 1
		Case Else
			$result = 0
	EndSwitch

	Return $result
EndFunc   ;==>getSpellOffset

Func smartZap($minDE = -1)
	Local $strikeOffsets = [0, 14] ; Adjust according to drill locate pictures in "imgxml\Storages\Drills"
	Local $drillLvlOffset, $spellAdjust, $numDrills, $testX, $testY, $tempTestX, $tempTestY, $strikeGain, $expectedDE
	Local $error = 5 ; 5 pixel error margin for DE drill search
	Local $g_iSearchDark, $oldSearchDark = 0, $performedZap = False, $dropPoint
	Local $aSpells[3][5] = [["Own", $eLSpell, -1, -1, 0] _         ; Own/Donated, SpellType, AttackbarPosition, Level, Count
			, ["Donated", $eLSpell, -1, -1, 0] _
			, ["Donated", $eESpell, -1, -1, 0]]
	Local $bZapDrills = True

	; If smartZap is not checked, exit.
	If $g_bDebugSmartZap = True Then SetLog("$g_bSmartZapEnable = " & $g_bSmartZapEnable & " | $g_bNoobZap = " & $g_bNoobZap, $COLOR_DEBUG)
	If $g_bSmartZapEnable = False Then Return $performedZap
	If $bZapDrills Then
		If $g_bSmartZapEnable And Not $g_bNoobZap Then
			SetLog("====== You have activated SmartZap Mode ======", $COLOR_ERROR)
		ElseIf $g_bNoobZap Then
			SetLog("====== You have activated NoobZap Mode ======", $COLOR_ERROR)
		EndIf
	EndIf
	; Use UI Setting if no Min DE is specified
	If $minDE = -1 Then $minDE = Number($g_iSmartZapMinDE)

	If $bZapDrills Then
		; Get Dark Elixir value, if no DE value exists, exit.
		$g_iSearchDark = getDarkElixirVillageSearch(48, 126 + 7)
		If Number($g_iSearchDark) = 0 Then
			SetLog("No Dark Elixir!", $COLOR_INFO)
			If $g_bDebugSmartZap Then SetLog("$g_iSearchDark|Current DE value: " & Number($g_iSearchDark), $COLOR_DEBUG)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap Then SetLog("$g_iSearchDark|Current DE value: " & Number($g_iSearchDark), $COLOR_DEBUG)
		EndIf
	EndIf

	If $bZapDrills Then
		; Check to see if the DE Storage is already full
		If isAtkDarkElixirFull() Then
			SetLog("No need to zap!", $COLOR_INFO)
			If $g_bDebugSmartZap Then SetLog("isAtkDarkElixirFull(): True", $COLOR_DEBUG)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap Then SetLog("isAtkDarkElixirFull(): False", $COLOR_DEBUG)
		EndIf
	EndIf

	If $bZapDrills Then
		; Check to make sure the account is high enough level to store DE.
		If $g_iTownHallLevel < 2 Then
			SetLog("Your Townhalllevel has yet to be determined.", $COLOR_ERROR)
			SetLog("It reads as TH" & $g_iTownHallLevel & ".", $COLOR_ERROR)
			SetLog("Locate your Townhall manually at Village->Misc.", $COLOR_ERROR)
			$bZapDrills = False
		ElseIf $g_iTownHallLevel < 7 Then
			SetLog("You do not have the ability to store Dark Elixir!", $COLOR_ERROR)
			If $g_bDebugSmartZap Then SetLog("Your Town Hall Lvl: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap Then SetLog("Your Town Hall Lvl: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
		EndIf
	EndIf

	If $bZapDrills Then
		; Check match mode
		If $g_bDebugSmartZap Then SetLog("$g_bSmartZapDB = " & $g_bSmartZapDB, $COLOR_DEBUG)
		If $g_bSmartZapDB And $g_iMatchMode <> $DB Then
			SetLog("Not a dead base!", $COLOR_INFO)
			$bZapDrills = False
		EndIf
	EndIf

	If $bZapDrills Then
		; Offset the drill level based on town hall level
		$drillLvlOffset = getDrillOffset()
		If $g_bDebugSmartZap Then SetLog("Drill Level Offset is: " & Number($drillLvlOffset), $COLOR_DEBUG)

		; Offset the number of spells based on town hall level
		$spellAdjust = getSpellOffset()
		If $g_bDebugSmartZap Then SetLog("Spell Adjust is: " & Number($spellAdjust), $COLOR_DEBUG)
	EndIf

	; Get the number of lightning/EQ spells
	Local $iTroops = PrepareAttack($g_iMatchMode, True) ; Check remaining troops/spells
	If $iTroops > 0 Then
		For $i = 0 To UBound($g_avAttackTroops) - 1
			If $g_avAttackTroops[$i][0] = $eLSpell Then
				If $aSpells[0][4] = 0 Then
					If $g_bDebugSmartZap Then SetLog(GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
					$aSpells[0][2] = $i
					$aSpells[0][3] = Number($g_iLSpellLevel) ; Get the Level on Attack bar
					$aSpells[0][4] = $g_avAttackTroops[$i][1]
				Else
					If $g_bDebugSmartZap Then SetLog("Donated " & GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
					$aSpells[1][2] = $i
					$aSpells[1][3] = Number($g_iLSpellLevel) ; Get the Level on Attack bar
					$aSpells[1][4] = Number($g_avAttackTroops[$i][1])
				EndIf
			EndIf
			If $g_avAttackTroops[$i][0] = $eESpell Then
				If $g_bDebugSmartZap Then SetLog(GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
				$aSpells[2][2] = $i
				$aSpells[2][3] = Number($g_iESpellLevel) ; Get the Level on Attack bar
				$aSpells[2][4] = Number($g_avAttackTroops[$i][1])
			EndIf
		Next
	EndIf

	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells trained, time to go home!", $COLOR_ERROR)
		Return $performedZap
	Else
		If $aSpells[0][4] > 0 Then
			SetLog(" - Number of " & GetTroopName($aSpells[0][1], 2) & " (Lvl " & $aSpells[0][3] & "): " & Number($aSpells[0][4]), $COLOR_INFO)
		EndIf
		If $aSpells[1][4] > 0 Then
			SetLog(" - Number of Donated " & GetTroopName($aSpells[1][1], 2) & " (Lvl " & $aSpells[1][3] & "): " & Number($aSpells[1][4]), $COLOR_INFO)
		EndIf
	EndIf

	If $aSpells[2][4] > 0 And $g_bEarthQuakeZap = True Then
		SetLog(" - Number of " & GetTroopName($aSpells[2][1], 2) & " (Lvl " & $aSpells[2][3] & "): " & Number($aSpells[2][4]), $COLOR_INFO)
	Else
		$aSpells[2][4] = 0 ; remove the EQ , is not to use it
	EndIf

	If $bZapDrills Then
		; Check to ensure there is at least the minimum amount of DE available.
		If (Number($g_iSearchDark) < Number($minDE)) And $g_bNoobZap = True Then
			SetLog("Dark Elixir is below minimum value [" & Number($g_iSmartZapMinDE) & "]!", $COLOR_INFO)
			If $g_bDebugSmartZap Then SetLog("$g_iSearchDark|Current DE value: " & Number($g_iSearchDark), $COLOR_DEBUG)
			$bZapDrills = False
		ElseIf Number($g_iSearchDark) < ($g_aDrillLevelTotal[3 - $drillLvlOffset] / $g_aDrillLevelHP[3 - $drillLvlOffset] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel) Then
			SetLog("There is less Dark Elixir(" & Number($g_iSearchDark) & ") than", $COLOR_INFO)
			SetLog("gain per zap for a single Lvl " & 3 - Number($drillLvlOffset) & " drill(" & Ceiling($g_aDrillLevelTotal[3 - $drillLvlOffset] / $g_aDrillLevelHP[3 - $drillLvlOffset] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel) & ").", $COLOR_INFO)
			SetLog("Base is not worth a Zap!", $COLOR_INFO)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap Then SetLog("$g_iSearchDark = " & Number($g_iSearchDark) & " | $g_iSmartZapMinDE = " & Number($g_iSmartZapMinDE), $COLOR_DEBUG)
		EndIf

		If $g_bDebugSmartZap Then
			SetLog("$g_iSmartZapExpectedDE| Expected DE value:" & Number($g_iSmartZapExpectedDE), $COLOR_DEBUG)
			SetLog("$g_abStopAtkNoLoot1Enable[$DB] = " & $g_abStopAtkNoLoot1Enable[$DB] & ", $g_aiStopAtkNoLoot1Time[$DB] = " & $g_aiStopAtkNoLoot1Time[$DB] & "s", $COLOR_DEBUG)
		EndIf
	EndIf

	If $bZapDrills Then
		; Get Drill locations and info
		Local $aDarkDrills = drillSearch()

		; Get the number of drills
		If UBound($aDarkDrills) = 0 Then
			SetLog("No drills found!", $COLOR_INFO)
			$bZapDrills = False
		Else
			SetLog(" - Number of Dark Elixir Drills: " & UBound($aDarkDrills), $COLOR_INFO)
		EndIf

		_ArraySort($aDarkDrills, 1, 0, 0, 3)

		Local $itotalStrikeGain = 0
		Local $hTempTimer
	EndIf

	; Loop while you still have spells and the first drill in the array has Dark Elixir, if you are town hall 7 or higher
	While IsAttackPage() And $bZapDrills And $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > 0 And UBound($aDarkDrills) > 0 And $spellAdjust <> -1
		Local $Spellused = $eLSpell
		Local $skippedZap = True
		; Store the DE value before any Zaps are done.
		Local $oldSearchDark = $g_iSearchDark
		CheckHeroesHealth()

		If ($g_iSearchDark < Number($g_iSmartZapMinDE)) And $g_bNoobZap = True Then
			SetLog("Dark Elixir is below minimum value [" & Number($g_iSmartZapMinDE) & "], Exiting Now!", $COLOR_INFO)
			$bZapDrills = False
			ExitLoop
		EndIf

		Local $aCluster = getDrillCluster($aDarkDrills)
		If $aCluster <> -1 Then
			Local $tLastZap = 0
			For $i = 0 To UBound($aCluster[3]) - 1
				If $aDarkDrills[($aCluster[3])[$i]][4] <> 0 Then
					If $tLastZap = 0 Then
						$tLastZap = __TimerDiff($aDarkDrills[($aCluster[3])[$i]][4])
					Else
						$tLastZap = _Min(__TimerDiff($aDarkDrills[($aCluster[3])[$i]][4]), $tLastZap)
					EndIf
				EndIf
			Next
			If $tLastZap > 0 Then
				If _Sleep(_Max($DELAYSMARTZAP10 - $tLastZap, 0)) Then Return ; 10 seconds since zap to disappear dust and bars
				Local $sToDelete = ""
				Local $iToDelete = 0
				For $i = 0 To UBound($aCluster[3]) - 1
					If $aDarkDrills[($aCluster[3])[$i]][4] <> 0 Then
						If ReCheckDrillExist($aDarkDrills[($aCluster[3])[$i]][0], $aDarkDrills[($aCluster[3])[$i]][1]) Then
							$aDarkDrills[($aCluster[3])[$i]][4] = 0
						Else
							If $sToDelete = "" Then
								$sToDelete &= ($aCluster[3])[$i]
							Else
								$sToDelete &= ";" & ($aCluster[3])[$i]
							EndIf
							$iToDelete += 1
						EndIf
					EndIf
				Next
				If $iToDelete > 1 Then
					SetLog("Removing " & $iToDelete & " destroyed drills from list.", $COLOR_ACTION)
					_ArrayDelete($aDarkDrills, $sToDelete)
					ContinueLoop
				ElseIf $iToDelete > 0 Then
					SetLog("Removing 1 destroyed drill from list.", $COLOR_ACTION)
					_ArrayDelete($aDarkDrills, $sToDelete)
					ContinueLoop
				EndIf
			EndIf
			If $g_bDebugSmartZap = True Then SetLog("Cluster Hold: " & $aCluster[2] & ", First Drill Hold: " & $aDarkDrills[0][3], $COLOR_DEBUG)
			If $aCluster[2] < $aDarkDrills[0][3] Then $aCluster = -1
		EndIf
		If $aCluster = -1 And $aDarkDrills[0][4] <> 0 Then
			If _Sleep(_Max($DELAYSMARTZAP10 - __TimerDiff($aDarkDrills[0][4]), 0)) Then Return ; 10 seconds since zap to disappear dust and bars
			If ReCheckDrillExist($aDarkDrills[0][0], $aDarkDrills[0][1]) Then
				$aDarkDrills[0][4] = 0
			Else
				SetLog("Removing 1 destroyed drill from list.", $COLOR_ACTION)
				_ArrayDelete($aDarkDrills, 0)
				ContinueLoop
			EndIf
		EndIf

		; Create the log entry string for amount stealable
		displayZapLog($aDarkDrills, $aSpells)

		$hTempTimer = __TimerInit() ; Set Last Zap Timer
		; If you activate N00bZap, drop lightning on any DE drill
		If $g_bNoobZap = True Then
			SetLog("NoobZap is going to attack any drill.", $COLOR_ACTION)
			If $aCluster <> -1 Then
				$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
				For $i = 0 To UBound($aCluster[3]) - 1
					$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
				Next
			Else
				$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
				$aDarkDrills[0][4] = $hTempTimer
			EndIf

			$performedZap = True
			$skippedZap = False
			If _Sleep($DELAYSMARTZAP4) Then Return
		Else
			; If you have max lightning spells, drop lightning on any level DE drill
			If $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > (4 - $spellAdjust) Then
				SetLog("First condition: More than " & 4 - $spellAdjust & " Spells so attack any drill.", $COLOR_INFO)
				If $aCluster <> -1 Then
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				Else
					$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$aDarkDrills[0][4] = $hTempTimer
				EndIf

				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return

				; If you have one less then max, drop it on drills with level (4 - drill offset) and higher
			ElseIf $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > (3 - $spellAdjust) And $aDarkDrills[0][2] > (3 - $drillLvlOffset) Then
				SetLog("Second condition: Attack Lvl " & 4 - Number($drillLvlOffset) & " and greater drills if you have more than " & 3 - Number($spellAdjust) & " spells", $COLOR_INFO)
				If $aCluster <> -1 Then
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				Else
					$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$aDarkDrills[0][4] = $hTempTimer
				EndIf

				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return

				; If the collector or cluster has more content left than a lvl (5 - drill offset) drill would give to a single zap
			ElseIf $aDarkDrills[0][2] > (4 - $drillLvlOffset) And ($aDarkDrills[0][3] / ($g_aDrillLevelTotal[$aDarkDrills[0][2] - 1] * $g_fDarkStealFactor)) > 0.3 Then
				SetLog("Third condition: Attack Lvl " & 5 - Number($drillLvlOffset) & " drills with more then 30% estimated DE left", $COLOR_INFO)
				If $aCluster <> -1 Then
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				Else
					$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$aDarkDrills[0][4] = $hTempTimer
				EndIf

				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return

			ElseIf $aCluster <> -1 Then
				If $aCluster[2] >= ($g_aDrillLevelTotal[5 - $drillLvlOffset] / $g_aDrillLevelHP[5 - $drillLvlOffset] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel) Then
					SetLog("Fourth condition: Attack, when potential left content in cluster is greater than gain for a single Lvl " & 5 - Number($drillLvlOffset) & " drill", $COLOR_INFO)
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				EndIf

				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return

			Else
				$skippedZap = True
				SetLog("Drill did not match any attack conditions, so we will remove it from the list.", $COLOR_ACTION)
				_ArrayDelete($aDarkDrills, 0)
			EndIf
		EndIf

		; Get the DE Value after SmartZap has performed its actions.
		$g_iSearchDark = getDarkElixir()

		; No Dark Elixir Left
		If Not $g_iSearchDark Or $g_iSearchDark = 0 Then
			SetLog("No Dark Elixir left!", $COLOR_INFO)
			SetDebugLog("$g_iSearchDark = " & Number($g_iSearchDark))
			; Update statistics, if we zapped
			If $skippedZap = False Then
				If $Spellused = $eESpell Then
					$g_iNumEQSpellsUsed += 1
				Else
					$g_iNumLSpellsUsed += 1
				EndIf
				$g_iSmartZapGain += $oldSearchDark
			EndIf
			$bZapDrills = False
			ExitLoop
		Else
			If $g_bDebugSmartZap Then SetLog("$g_iSearchDark = " & Number($g_iSearchDark), $COLOR_DEBUG)
		EndIf

		; Check to make sure we actually zapped
		If Not $skippedZap Then
			If $g_bDebugSmartZap Then SetLog("$oldSearchDark = [" & Number($oldSearchDark) & "] - $g_iSearchDark = [" & Number($g_iSearchDark) & "]", $COLOR_DEBUG)
			$strikeGain = Number($oldSearchDark - $g_iSearchDark)
			If $g_bDebugSmartZap Then SetLog("$strikeGain = " & Number($strikeGain), $COLOR_DEBUG)

			$expectedDE = -1

			If $Spellused = $eESpell Then
				$g_iNumEQSpellsUsed += 1
				If $aCluster <> -1 Then
					For $i = 0 To UBound($aCluster[3]) - 1
						$expectedDE = _Max(Number($expectedDE), Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_fDarkStealFactor * $g_aEQSpellDmg[$aSpells[2][3] - 1] * $g_fDarkFillLevel)))
					Next
				Else
					$expectedDE = Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[0][2] - 1] * $g_fDarkStealFactor * $g_aEQSpellDmg[$aSpells[2][3] - 1] * $g_fDarkFillLevel))
				EndIf
			Else
				$g_iNumLSpellsUsed += 1
				If $g_bNoobZap = False Then
					If $aCluster <> -1 Then
						For $i = 0 To UBound($aCluster[3]) - 1
							$expectedDE = _Max(Number($expectedDE), Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] / $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel)))
						Next
					Else
						$expectedDE = Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[0][2] - 1] / $g_aDrillLevelHP[$aDarkDrills[0][2] - 1] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel))
					EndIf
				Else
					$expectedDE = $g_iSmartZapExpectedDE
				EndIf
			EndIf

			If $g_bDebugSmartZap Then SetLog("$expectedDE = " & Number($expectedDE), $COLOR_DEBUG)

			; If change in DE is less than expected, remove the Drill from list. else, subtract change from assumed total
			If $strikeGain < $expectedDE And $expectedDE <> -1 Then
				SetLog("Gained: " & $strikeGain & ", Expected: " & $expectedDE, $COLOR_INFO)
				If $aCluster <> -1 Then
					_ArrayDelete($aDarkDrills, _ArrayToString($aCluster[3], ";"))
					SetLog("Last zap gained less DE then expected, removing the drills from the list.", $COLOR_ACTION)
				Else
					_ArrayDelete($aDarkDrills, 0)
					SetLog("Last zap gained less DE then expected, removing the drill from the list.", $COLOR_ACTION)
				EndIf
			Else
				If $aCluster <> -1 Then
					Local $iSumTotalHP = 0
					Local $sToDelete = ""
					If UBound($aCluster[3]) = 2 Then ; Formula for Individual Drill DE1 = DE * Total1 * HP2 / (Total1 * HP2 + Total2 * HP1)
						For $i = 0 To 1
							$iSumTotalHP += $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 2)]][2] - 1]
						Next
						For $i = 0 To 1
							Local $iSubGain = Ceiling(Number($strikeGain * $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 2)]][2] - 1] / $iSumTotalHP))
							$aDarkDrills[($aCluster[3])[$i]][3] -= $iSubGain
							SetLog(($i + 1) & ".Drill Gained: " & $iSubGain & ", adjusting amount left in this drill.", $COLOR_INFO)
						Next
					Else ; Formula for Individual Drill DE1 = DE * Total1 * HP2 * HP3 / (Total1 * HP2 * HP3 + Total2 * HP1 * HP3 + Total3 * HP1 * HP2)
						For $i = 0 To 2
							$iSumTotalHP += $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 3)]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 2, 3)]][2] - 1]
						Next
						For $i = 0 To 2
							Local $iSubGain = Ceiling(Number($strikeGain * $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 3)]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 2, 3)]][2] - 1] / $iSumTotalHP))
							$aDarkDrills[($aCluster[3])[$i]][3] -= $iSubGain
							SetLog(($i + 1) & ".Drill Gained: " & $iSubGain & ", adjusting amount left in this drill.", $COLOR_INFO)
						Next
					EndIf
					If $sToDelete <> "" Then _ArrayDelete($aDarkDrills, $sToDelete)
				Else
					$aDarkDrills[0][3] -= $strikeGain
					SetLog("Gained: " & Number($strikeGain) & ", adjusting amount left in this drill.", $COLOR_INFO)
				EndIf
			EndIf

			$itotalStrikeGain += $strikeGain
			$g_iSmartZapGain += $strikeGain
			SetLog("Total DE from SmartZap/NoobZap: " & Number($itotalStrikeGain), $COLOR_INFO)

		EndIf

		; Resort the array
		_ArraySort($aDarkDrills, 1, 0, 0, 3)

		; Check once again for donated lightning spell, if all own lightning spells are used
		If $aSpells[0][4] = 0 Then
			Local $iTroops = PrepareAttack($g_iMatchMode, True) ; Check remaining troops/spells
			If $iTroops > 0 Then
				For $i = 0 To UBound($g_avAttackTroops) - 1
					If $g_avAttackTroops[$i][0] = $eLSpell Then
						If $g_bDebugSmartZap Then SetLog("Donated " & GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
						$aSpells[1][2] = $i
						$aSpells[1][3] = Number($g_iLSpellLevel) ; Get the Level on Attack bar
						$aSpells[1][4] = $g_avAttackTroops[$i][1]
					EndIf
				Next
			EndIf
			If $aSpells[1][4] > 0 Then
				SetLog("Woohoo, found a donated " & GetTroopName($aSpells[1][1]) & " (Lvl " & $aSpells[1][3] & ").", $COLOR_INFO)
			EndIf
		EndIf

	WEnd

	If $g_bSmartZapFTW Then
		SetLog("====== SmartZap/NoobZap FTW Mode ======", $COLOR_INFO)
	Else
		Return $performedZap
	EndIf

	If _CheckPixel($aWonOneStar, True) Then
		SetLog("One Star already reached.", $COLOR_INFO)
		Return $performedZap
	EndIf

	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells left, time to go home!", $COLOR_ERROR)
		Return $performedZap
	Else
		If $aSpells[0][4] > 0 Then
			SetLog(" - Number of " & GetTroopName($aSpells[0][1], 2) & " (Lvl " & $aSpells[0][3] & "): " & Number($aSpells[0][4]), $COLOR_INFO)
		EndIf
		If $aSpells[1][4] > 0 Then
			SetLog(" - Number of Donated " & GetTroopName($aSpells[1][1], 2) & " (Lvl " & $aSpells[1][3] & "): " & Number($aSpells[1][4]), $COLOR_INFO)
		EndIf
	EndIf

	Local $iPercentageNeeded = 50 - getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
	SetLog("Percentage needed: " & $iPercentageNeeded, $COLOR_INFO)

	_ArrayDelete($aSpells, 2)
	Local $aEasyPrey = easyPreySearch()
	If UBound($aEasyPrey) = 0 Then
		SetLog("No easy targets found!", $COLOR_INFO)
		Return $performedZap
	Else
		; Get the number of targets
		Local $iTargetCount = 0
		For $iTargets = 0 To UBound($aEasyPrey) - 1
			$iTargetCount += $aEasyPrey[$iTargets][2]
			If $g_bDebugSmartZap = True Then
				SetLog($iTargets + 1 & ". target: x=" & $aEasyPrey[$iTargets][0] & ",y=" & $aEasyPrey[$iTargets][1] & ",w=" & $aEasyPrey[$iTargets][2], $COLOR_DEBUG)
			EndIf
		Next
		SetLog("Count of easy targets: " & $iTargetCount, $COLOR_INFO)
		; Get the number of zappable targets
		$iTargetCount = 0
		For $iTargets = 0 To _Min(Number(UBound($aEasyPrey) - 1), Number($aSpells[0][4] + $aSpells[1][4]) - 1)
			$iTargetCount += $aEasyPrey[$iTargets][2]
		Next
		SetLog("Easy targets, we can zap: " & $iTargetCount, $COLOR_INFO)
		If $iPercentageNeeded > $iTargetCount Then
			SetLog("No chance to win!", $COLOR_INFO)
			SetLog("Needed percentage (" & $iPercentageNeeded & ") is greater than targets, we can zap (" & $iTargetCount & ")!", $COLOR_INFO)
			Return $performedZap
		EndIf
	EndIf

	Local $Spellused = $eLSpell
	While IsAttackPage() And $aSpells[0][4] + $aSpells[1][4] > 0 And UBound($aEasyPrey) > 0 And Not _CheckPixel($aWonOneStar, True)
		$Spellused = zapBuilding($aSpells, $aEasyPrey[0][0] + 5, $aEasyPrey[0][1] + 5)
		_ArrayDelete($aEasyPrey, 0)
		If _Sleep(6000) Then Return
	WEnd

	If _CheckPixel($aWonOneStar, True) Then
		SetLog("Hooray, One Star reached, we have won!", $COLOR_INFO)
	EndIf
	Return $performedZap
EndFunc   ;==>smartZap

; This function taken and modified by the CastSpell function to make Zapping works
Func zapBuilding(ByRef $Spells, $x, $y)
	Local $iSpell
	For $i = 0 To UBound($Spells) - 1
		If $Spells[$i][4] > 0 Then
			$iSpell = $i
		EndIf
	Next
	If $Spells[$iSpell][2] > -1 Then
		SetLog("Dropping " & $Spells[$iSpell][0] & " " & String(GetTroopName($Spells[$iSpell][1])), $COLOR_ACTION)
		SelectDropTroop($Spells[$iSpell][2])
		If _Sleep($DELAYCASTSPELL1) Then Return
		If IsAttackPage() Then Click($x, $y, 1, 100, "#0029")
		$Spells[$iSpell][4] -= 1
	Else
		If $g_bDebugSmartZap = True Then SetLog("No " & String(GetTroopName($Spells[$iSpell][1])) & " Found", $COLOR_DEBUG)
	EndIf
	Return $Spells[$iSpell][1]
EndFunc   ;==>zapBuilding

Func ReCheckDrillExist($x, $y)
	_CaptureRegion2($x - 25, $y - 25, $x + 25, $y + 25)

	Local $aResult = multiMatches($g_sImgSearchDrill, 1, "FV", "FV", "", 0, 1000, False) ; Setting Force Captureregion to false, else it will recapture the whole screen, finding any drill

	If UBound($aResult) > 1 Then
		If $g_bDebugSmartZap = True Then SetLog("ReCheckDrillExist: Yes| " & UBound($aResult), $COLOR_SUCCESS)
		Return True
	Else
		If $g_bDebugSmartZap = True Then SetLog("ReCheckDrillExist: No| " & UBound($aResult), $COLOR_ERROR)
	EndIf
	Return False
EndFunc   ;==>ReCheckDrillExist

Func AirZap($bScripted = False, $bMainSide = "")
	Local $performedZap = False
	Local $aSpells[2][5] = [["Own", $eLSpell, -1, -1, 0], ["Donated", $eLSpell, -1, -1, 0]] ; Own/Donated, SpellType, AttackbarPosition, Level, Count

	Local $bZapAirDef = True, $bZapAirSw = True

	If $g_bSmartZapEnableAD = 0 Then Return $performedZap

	SetLog("====== You have activated AirZap Mode ======", $COLOR_ACTION)
	Switch $g_bSmartZapEnableAD
		Case 1
			SetLog("====== Air Defenses ======", $COLOR_ACTION)
		Case 2
			SetLog("====== Air Sweepers ======", $COLOR_ACTION)
		Case 3
			SetLog("====== All Air Defs ======", $COLOR_ACTION)
	EndSwitch

	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $eLSpell Then
			If $aSpells[0][4] = 0 Then
				SetLog(GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
				$aSpells[0][2] = $i
				$aSpells[0][3] = Number($g_iLSpellLevel) ; Get the Level on Attack bar
				$aSpells[0][4] = Number($g_avAttackTroops[$i][1]) ; Amount
			Else
				SetLog("Donated " & GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
				$aSpells[1][2] = $i
				$aSpells[1][3] = Number($g_iLSpellLevel) ; Get the Level on Attack bar
				$aSpells[1][4] = Number($g_avAttackTroops[$i][1]) ; Amount
			EndIf
		EndIf
	Next

	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells trained, time to go home!", $COLOR_ERROR)
		Return $performedZap
	Else
		If $aSpells[0][4] > 0 Then
			SetLog(" - Number of " & GetTroopName($aSpells[0][1], 2) & " (Lvl " & $aSpells[0][3] & "): " & Number($aSpells[0][4]), $COLOR_INFO)
		EndIf
		If $aSpells[1][4] > 0 Then
			SetLog(" - Number of Donated " & GetTroopName($aSpells[1][1], 2) & " (Lvl " & $aSpells[1][3] & "): " & Number($aSpells[1][4]), $COLOR_INFO)
		EndIf
	EndIf

	; Wait Battle Ends in...
	Local $bLoop = 0
	Local $BattleStart = decodeSingleCoord(FindImageInPlace2("BattleStart", $ImgBattleStart, 380, 10, 490, 27, True))
	If IsArray($BattleStart) And UBound($BattleStart) = 2 Then
		While 1
			If UBound(decodeSingleCoord(FindImageInPlace2("BattleStart", $ImgBattleStart, 380, 10, 490, 27, True))) = 2 Then
				If _Sleep(1000) Then ExitLoop
				$bLoop += 1
			Else
				ExitLoop
			EndIf
			If $bLoop = 10 Then ExitLoop
		WEnd
	EndIf

	; Get AD locations and info
	Local $aAirDefs = ADSearch()
	Local $aAirSweepers = ASweeperSearch()

	; Get the number of AD
	If $g_bSmartZapEnableAD = 1 Or $g_bSmartZapEnableAD = 3 Then
		If $g_bSmartZapEnableAD = 1 Then $bZapAirSw = False
		If UBound($aAirDefs) = 0 Then
			SetLog("No Air Defense found!", $COLOR_INFO)
			$bZapAirDef = False
		Else
			SetLog(" - Number of Air Defense: " & UBound($aAirDefs), $COLOR_INFO)
		EndIf
	EndIf
	; Get the number of AS
	If $g_bSmartZapEnableAD = 2 Or $g_bSmartZapEnableAD = 3 Then
	If $g_bSmartZapEnableAD = 2 Then $bZapAirDef = False
		If UBound($aAirSweepers) = 0 Then
			SetLog("No Air Sweeper found!", $COLOR_INFO)
			$bZapAirSw = False
		Else
			SetLog(" - Number of Air Sweepers: " & UBound($aAirSweepers), $COLOR_INFO)
		EndIf
	EndIf

	Switch $g_bSmartZapEnableAD
		Case 1
			If Not $bZapAirDef Then Return
		Case 2
			If Not $bZapAirSw Then Return
		Case 3
			If Not $bZapAirDef And Not $bZapAirSw Then Return
	EndSwitch

	If $bScripted Then
		Switch $bMainSide
			Case "TOP-LEFT", "TOP-RIGHT"
				If $g_bSmartZapEnableAD = 1 Or $g_bSmartZapEnableAD = 3 Then _ArraySort($aAirDefs, 0, 0, 0, 1)     ; Sort by y top first
				If $g_bSmartZapEnableAD > 1 Then _ArraySort($aAirSweepers, 0, 0, 0, 1)
			Case "BOTTOM-LEFT", "BOTTOM-RIGHT"
				If $g_bSmartZapEnableAD = 1 Or $g_bSmartZapEnableAD = 3 Then _ArraySort($aAirDefs, 1, 0, 0, 1)     ; Sort by y bottom first
				If $g_bSmartZapEnableAD > 1 Then _ArraySort($aAirSweepers, 1, 0, 0, 1)
		EndSwitch
	Else
		If $g_bSmartZapEnableAD = 1 Or $g_bSmartZapEnableAD = 3 Then _ArraySort($aAirDefs, 1, 0, 0, 3)     ; Sort by Level/HP
		If $g_bSmartZapEnableAD > 1 Then _ArraySort($aAirSweepers, 1, 0, 0, 3)
	EndIf

	; Loop while you still have spells and Air Defense
	Local $SameAD = False, $SameAS = False

	If $bZapAirDef And Not $bZapAirSw Then

		For $i = 0 To UBound($aAirDefs) - 1

			If $aSpells[0][4] + $aSpells[1][4] = 0 Then ExitLoop

			If $aSpells[1][4] > 0 Then
				Local $Hits = Ceiling($aAirDefs[$i][3] / $g_aLSpellDmg[$aSpells[1][3] - 1])
				If $Hits > Number($aSpells[1][4]) Then
					$Hits = Number($aSpells[1][4])
					$SameAD = True
				Else
					$SameAD = False
				EndIf
				SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[1][1])), $COLOR_ACTION)
				SelectDropTroop($aSpells[1][2])
				If _Sleep($DELAYCASTSPELL1) Then Return
				If IsAttackPage() Then
					For $t = 0 To $Hits - 1
						Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
						If _Sleep(Random(150, 200, 1)) Then ExitLoop
					Next
				EndIf
				$aSpells[1][4] -= $Hits
				If $SameAD And $aSpells[0][4] > 0 Then
					$Hits = Ceiling(($aAirDefs[$i][3] - ($Hits * $g_aLSpellDmg[$aSpells[1][3] - 1])) / $g_aLSpellDmg[$aSpells[1][3] - 1])
					If $Hits > Number($aSpells[0][4]) Then
						$Hits = Number($aSpells[0][4])
					Else
						$SameAD = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[0][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[0][4] -= $Hits
					If $aSpells[0][4] = 0 Then ExitLoop
					ContinueLoop
				Else
					ContinueLoop
				EndIf
			EndIf

			If $aSpells[0][4] > 0 Then
				Local $Hits = Ceiling($aAirDefs[$i][3] / $g_aLSpellDmg[$aSpells[0][3] - 1])
				If $Hits > Number($aSpells[0][4]) Then
					$Hits = Number($aSpells[0][4])
					$SameAD = True
				Else
					$SameAD = False
				EndIf
				SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
				SelectDropTroop($aSpells[0][2])
				If _Sleep($DELAYCASTSPELL1) Then Return
				If IsAttackPage() Then
					For $t = 0 To $Hits - 1
						Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
						If _Sleep(Random(150, 200, 1)) Then ExitLoop
					Next
				EndIf
				$aSpells[0][4] -= $Hits
				If $aSpells[0][4] = 0 Then ExitLoop
				If Not $SameAD Then ContinueLoop
			EndIf

		Next

	ElseIf Not $bZapAirDef And $bZapAirSw Then

		For $i = 0 To UBound($aAirSweepers) - 1

			If $aSpells[0][4] + $aSpells[1][4] = 0 Then ExitLoop

			If $aSpells[1][4] > 0 Then
				Local $Hits = Ceiling($aAirSweepers[$i][3] / $g_aLSpellDmg[$aSpells[1][3] - 1])
				If $Hits > Number($aSpells[1][4]) Then
					$Hits = Number($aSpells[1][4])
					$SameAS = True
				Else
					$SameAS = False
				EndIf
				SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[1][1])), $COLOR_ACTION)
				SelectDropTroop($aSpells[1][2])
				If _Sleep($DELAYCASTSPELL1) Then Return
				If IsAttackPage() Then
					For $t = 0 To $Hits - 1
						Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
						If _Sleep(Random(150, 200, 1)) Then ExitLoop
					Next
				EndIf
				$aSpells[1][4] -= $Hits
				If $SameAS And $aSpells[0][4] > 0 Then
					$Hits = Ceiling(($aAirSweepers[$i][3] - ($Hits * $g_aLSpellDmg[$aSpells[1][3] - 1])) / $g_aLSpellDmg[$aSpells[1][3] - 1])
					If $Hits > Number($aSpells[0][4]) Then
						$Hits = Number($aSpells[0][4])
					Else
						$SameAS = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[0][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[0][4] -= $Hits
					If $aSpells[0][4] = 0 Then ExitLoop
					ContinueLoop
				Else
					ContinueLoop
				EndIf
			EndIf

			If $aSpells[0][4] > 0 Then
				Local $Hits = Ceiling($aAirSweepers[$i][3] / $g_aLSpellDmg[$aSpells[0][3] - 1])
				If $Hits > Number($aSpells[0][4]) Then
					$Hits = Number($aSpells[0][4])
					$SameAS = True
				Else
					$SameAS = False
				EndIf
				SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
				SelectDropTroop($aSpells[0][2])
				If _Sleep($DELAYCASTSPELL1) Then Return
				If IsAttackPage() Then
					For $t = 0 To $Hits - 1
						Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
						If _Sleep(Random(150, 200, 1)) Then ExitLoop
					Next
				EndIf
				$aSpells[0][4] -= $Hits
				If $aSpells[0][4] = 0 Then ExitLoop
				If Not $SameAS Then ContinueLoop
			EndIf

		Next

	ElseIf $bZapAirDef And $bZapAirSw Then

		If $g_bChkSweepersFirst Then

			;  Air Sweeper First, Air Defenses Second

			For $i = 0 To UBound($aAirSweepers) - 1

				If $aSpells[0][4] + $aSpells[1][4] = 0 Then ExitLoop

				If $aSpells[1][4] > 0 Then
					Local $Hits = Ceiling($aAirSweepers[$i][3] / $g_aLSpellDmg[$aSpells[1][3] - 1])
					If $Hits > Number($aSpells[1][4]) Then
						$Hits = Number($aSpells[1][4])
						$SameAS = True
					Else
						$SameAS = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[1][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[1][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[1][4] -= $Hits
					If $SameAS And $aSpells[0][4] > 0 Then
						$Hits = Ceiling(($aAirSweepers[$i][3] - ($Hits * $g_aLSpellDmg[$aSpells[1][3] - 1])) / $g_aLSpellDmg[$aSpells[1][3] - 1])
						If $Hits > Number($aSpells[0][4]) Then
							$Hits = Number($aSpells[0][4])
						Else
							$SameAS = False
						EndIf
						SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
						SelectDropTroop($aSpells[0][2])
						If _Sleep($DELAYCASTSPELL1) Then Return
						If IsAttackPage() Then
							For $t = 0 To $Hits - 1
								Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
								If _Sleep(Random(150, 200, 1)) Then ExitLoop
							Next
						EndIf
						$aSpells[0][4] -= $Hits
						If $aSpells[0][4] = 0 Then ExitLoop
						ContinueLoop
					Else
						ContinueLoop
					EndIf
				EndIf

				If $aSpells[0][4] > 0 Then
					Local $Hits = Ceiling($aAirSweepers[$i][3] / $g_aLSpellDmg[$aSpells[0][3] - 1])
					If $Hits > Number($aSpells[0][4]) Then
						$Hits = Number($aSpells[0][4])
						$SameAS = True
					Else
						$SameAS = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[0][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[0][4] -= $Hits
					If $aSpells[0][4] = 0 Then ExitLoop
					If Not $SameAS Then ContinueLoop
				EndIf

			Next

			For $i = 0 To UBound($aAirDefs) - 1

				If $aSpells[0][4] + $aSpells[1][4] = 0 Then ExitLoop

				If $aSpells[1][4] > 0 Then
					Local $Hits = Ceiling($aAirDefs[$i][3] / $g_aLSpellDmg[$aSpells[1][3] - 1])
					If $Hits > Number($aSpells[1][4]) Then
						$Hits = Number($aSpells[1][4])
						$SameAD = True
					Else
						$SameAD = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[1][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[1][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[1][4] -= $Hits
					If $SameAD And $aSpells[0][4] > 0 Then
						$Hits = Ceiling(($aAirDefs[$i][3] - ($Hits * $g_aLSpellDmg[$aSpells[1][3] - 1])) / $g_aLSpellDmg[$aSpells[1][3] - 1])
						If $Hits > Number($aSpells[0][4]) Then
							$Hits = Number($aSpells[0][4])
						Else
							$SameAD = False
						EndIf
						SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
						SelectDropTroop($aSpells[0][2])
						If _Sleep($DELAYCASTSPELL1) Then Return
						If IsAttackPage() Then
							For $t = 0 To $Hits - 1
								Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
								If _Sleep(Random(150, 200, 1)) Then ExitLoop
							Next
						EndIf
						$aSpells[0][4] -= $Hits
						If $aSpells[0][4] = 0 Then ExitLoop
						ContinueLoop
					Else
						ContinueLoop
					EndIf
				EndIf

				If $aSpells[0][4] > 0 Then
					Local $Hits = Ceiling($aAirDefs[$i][3] / $g_aLSpellDmg[$aSpells[0][3] - 1])
					If $Hits > Number($aSpells[0][4]) Then
						$Hits = Number($aSpells[0][4])
						$SameAD = True
					Else
						$SameAD = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[0][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[0][4] -= $Hits
					If $aSpells[0][4] = 0 Then ExitLoop
					If Not $SameAD Then ContinueLoop
				EndIf

			Next

		Else

			; Air Defenses First, Air Sweeper Second

			For $i = 0 To UBound($aAirDefs) - 1

				If $aSpells[0][4] + $aSpells[1][4] = 0 Then ExitLoop

				If $aSpells[1][4] > 0 Then
					Local $Hits = Ceiling($aAirDefs[$i][3] / $g_aLSpellDmg[$aSpells[1][3] - 1])
					If $Hits > Number($aSpells[1][4]) Then
						$Hits = Number($aSpells[1][4])
						$SameAD = True
					Else
						$SameAD = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[1][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[1][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[1][4] -= $Hits
					If $SameAD And $aSpells[0][4] > 0 Then
						$Hits = Ceiling(($aAirDefs[$i][3] - ($Hits * $g_aLSpellDmg[$aSpells[1][3] - 1])) / $g_aLSpellDmg[$aSpells[1][3] - 1])
						If $Hits > Number($aSpells[0][4]) Then
							$Hits = Number($aSpells[0][4])
						Else
							$SameAD = False
						EndIf
						SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
						SelectDropTroop($aSpells[0][2])
						If _Sleep($DELAYCASTSPELL1) Then Return
						If IsAttackPage() Then
							For $t = 0 To $Hits - 1
								Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
								If _Sleep(Random(150, 200, 1)) Then ExitLoop
							Next
						EndIf
						$aSpells[0][4] -= $Hits
						If $aSpells[0][4] = 0 Then ExitLoop
						ContinueLoop
					Else
						ContinueLoop
					EndIf
				EndIf

				If $aSpells[0][4] > 0 Then
					Local $Hits = Ceiling($aAirDefs[$i][3] / $g_aLSpellDmg[$aSpells[0][3] - 1])
					If $Hits > Number($aSpells[0][4]) Then
						$Hits = Number($aSpells[0][4])
						$SameAD = True
					Else
						$SameAD = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[0][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirDefs[$i][0], $aAirDefs[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[0][4] -= $Hits
					If $aSpells[0][4] = 0 Then ExitLoop
					If Not $SameAD Then ContinueLoop
				EndIf

			Next

			For $i = 0 To UBound($aAirSweepers) - 1

				If $aSpells[0][4] + $aSpells[1][4] = 0 Then ExitLoop

				If $aSpells[1][4] > 0 Then
					Local $Hits = Ceiling($aAirSweepers[$i][3] / $g_aLSpellDmg[$aSpells[1][3] - 1])
					If $Hits > Number($aSpells[1][4]) Then
						$Hits = Number($aSpells[1][4])
						$SameAS = True
					Else
						$SameAS = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[1][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[1][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[1][4] -= $Hits
					If $SameAS And $aSpells[0][4] > 0 Then
						$Hits = Ceiling(($aAirSweepers[$i][3] - ($Hits * $g_aLSpellDmg[$aSpells[1][3] - 1])) / $g_aLSpellDmg[$aSpells[1][3] - 1])
						If $Hits > Number($aSpells[0][4]) Then
							$Hits = Number($aSpells[0][4])
						Else
							$SameAS = False
						EndIf
						SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
						SelectDropTroop($aSpells[0][2])
						If _Sleep($DELAYCASTSPELL1) Then Return
						If IsAttackPage() Then
							For $t = 0 To $Hits - 1
								Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
								If _Sleep(Random(150, 200, 1)) Then ExitLoop
							Next
						EndIf
						$aSpells[0][4] -= $Hits
						If $aSpells[0][4] = 0 Then ExitLoop
						ContinueLoop
					Else
						ContinueLoop
					EndIf
				EndIf

				If $aSpells[0][4] > 0 Then
					Local $Hits = Ceiling($aAirSweepers[$i][3] / $g_aLSpellDmg[$aSpells[0][3] - 1])
					If $Hits > Number($aSpells[0][4]) Then
						$Hits = Number($aSpells[0][4])
						$SameAS = True
					Else
						$SameAS = False
					EndIf
					SetLog("Dropping " & $Hits & " " & String(GetTroopName($aSpells[0][1])), $COLOR_ACTION)
					SelectDropTroop($aSpells[0][2])
					If _Sleep($DELAYCASTSPELL1) Then Return
					If IsAttackPage() Then
						For $t = 0 To $Hits - 1
							Click($aAirSweepers[$i][0], $aAirSweepers[$i][1], 1, Random(120, 150, 1), "#0029")
							If _Sleep(Random(150, 200, 1)) Then ExitLoop
						Next
					EndIf
					$aSpells[0][4] -= $Hits
					If $aSpells[0][4] = 0 Then ExitLoop
					If Not $SameAS Then ContinueLoop
				EndIf

			Next

		EndIf

	EndIf

	; Update AttackBar
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $eLSpell Then
			If $aSpells[0][2] = $i Then
				If Number($g_avAttackTroops[$i][1]) <> Number($aSpells[0][4]) Then $g_avAttackTroops[$i][1] = Number($aSpells[0][4])
				SetLog("Remaining " & GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
			ElseIf $aSpells[1][2] = $i Then
				If Number($g_avAttackTroops[$i][1]) <> Number($aSpells[1][4]) Then $g_avAttackTroops[$i][1] = Number($aSpells[1][4])
				SetLog("Remaining Donated " & GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

EndFunc   ;==>AirZap

Func ADSearch($bForceCapture = True)

	If $g_bSmartZapEnableAD = 0 Or $g_bSmartZapEnableAD = 2 Then Return

	Local $sCocDiamond = "ECD"
	Local $redLines = $sCocDiamond
	Local $minLevel = 0
	Local $maxLevel = 1000
	Local $maxReturnPoints = 0 ; all positions
	Local $returnProps = "objectname,objectpoints,objectlevel"
	Local $aTempArray, $aTempCoords, $aTempMultiCoords, $aTempLevel, $aTempHP
	Local $aADefs[0][4], $bFoundADs = False
	Local $g_aADLevelTotal[15] = [800, 850, 900, 950, 1000, 1050, 1100, 1210, 1300, 1400, 1500, 1650, 1750, 1850, 1950]
	Local $g_sImgSearchAirDef = @ScriptDir & "\imgxml\Buildings\ADefense"

	; check for Air Defenses
	Local $result = findMultiple($g_sImgSearchAirDef, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
	Local $bFoundAirDefs = $result <> "" And IsArray($result)

	If $bFoundAirDefs Then

		;Add found Results into our Array
		For $i = 0 To UBound($result, 1) - 1
			$aTempArray = $result[$i]
			$aTempLevel = $aTempArray[2] ; Level
			$aTempHP = Number($g_aADLevelTotal[$aTempLevel - 1]) ; HP
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 5, 5)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				_ArrayAdd($aADefs, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $aTempLevel & "|" & $aTempHP)
				$bFoundADs = True
			Next
		Next
		If $bFoundADs Then
			For $i = 0 To UBound($aADefs) - 1
				$aADefs[$i][0] = Number($aADefs[$i][0])
				$aADefs[$i][1] = Number($aADefs[$i][1])
				$aADefs[$i][2] = Number($aADefs[$i][2])
				$aADefs[$i][3] = Number($aADefs[$i][3])
			Next
			RemoveDupXYAD($aADefs)
		EndIf

	EndIf

	Return $aADefs

EndFunc   ;==>ADSearch

Func ASweeperSearch($bForceCapture = True)

	If $g_bSmartZapEnableAD = 0 Or $g_bSmartZapEnableAD = 1 Then Return

	Local $sCocDiamond = "ECD"
	Local $redLines = $sCocDiamond
	Local $minLevel = 0
	Local $maxLevel = 1000
	Local $maxReturnPoints = 0 ; all positions
	Local $returnProps = "objectname,objectpoints,objectlevel"
	Local $aTempArray, $aTempCoords, $aTempMultiCoords, $aTempLevel, $aTempHP
	Local $aASweepers[0][4], $bFoundASweepers = False
	Local $g_aADLevelTotal[7] = [750, 800, 850, 900, 950, 1000, 1050]
	Local $g_sImgSearchAirSweeper = @ScriptDir & "\imgxml\Buildings\ASweeper"

	; check for Air Defenses
	Local $result = findMultiple($g_sImgSearchAirSweeper, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)
	Local $bFoundAirSweepers = $result <> "" And IsArray($result)

	If $bFoundAirSweepers Then

		;Add found Results into our Array
		For $i = 0 To UBound($result, 1) - 1
			$aTempArray = $result[$i]
			$aTempLevel = $aTempArray[2] ; Level
			$aTempHP = Number($g_aADLevelTotal[$aTempLevel - 1]) ; HP
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 5, 5)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				_ArrayAdd($aASweepers, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $aTempLevel & "|" & $aTempHP)
				$bFoundASweepers = True
			Next
		Next
		If $bFoundASweepers Then
			For $i = 0 To UBound($aASweepers) - 1
				$aASweepers[$i][0] = Number($aASweepers[$i][0])
				$aASweepers[$i][1] = Number($aASweepers[$i][1])
				$aASweepers[$i][2] = Number($aASweepers[$i][2])
				$aASweepers[$i][3] = Number($aASweepers[$i][3])
			Next
			RemoveDupXYAD($aASweepers)
		EndIf

	EndIf

	Return $aASweepers

EndFunc   ;==>ASweeperSearch

Func RemoveDupXYAD(ByRef $arr)
	; Remove Dup X Sorted
	Local $atmparray[0][4]
	Local $tmpCoordX = 0
	Local $tmpCoordY = 0
	_ArraySort($arr, 0, 0, 0, 0) ;sort by x
	For $i = 0 To UBound($arr) - 1
		Local $a = $arr[$i][0] - $tmpCoordX
		Local $b = $arr[$i][1] - $tmpCoordY
		Local $c = Sqrt($a * $a + $b * $b)
		If $c < 25 Then
			SetDebugLog("Skip this dup : " & $arr[$i][0] & "," & $arr[$i][1], $COLOR_INFO)
			ContinueLoop
		Else
			_ArrayAdd($atmparray, $arr[$i][0] & "|" & $arr[$i][1] & "|" & $arr[$i][2] & "|" & $arr[$i][3])
			$tmpCoordX = $arr[$i][0]
			$tmpCoordY = $arr[$i][1]
		EndIf
	Next
	; Remove Dup Y Sorted
	Local $atmparray2[0][4]
	$tmpCoordX = 0
	$tmpCoordY = 0
	_ArraySort($atmparray, 0, 0, 0, 1) ;sort by y
	For $i = 0 To UBound($atmparray) - 1
		Local $a = $atmparray[$i][0] - $tmpCoordX
		Local $b = $atmparray[$i][1] - $tmpCoordY
		Local $c = Sqrt($a * $a + $b * $b)
		If $c < 25 Then
			SetDebugLog("Skip this dup : " & $atmparray[$i][0] & "," & $atmparray[$i][1], $COLOR_INFO)
			ContinueLoop
		Else
			_ArrayAdd($atmparray2, $atmparray[$i][0] & "|" & $atmparray[$i][1] & "|" & $atmparray[$i][2] & "|" & $atmparray[$i][3])
			$tmpCoordX = $atmparray[$i][0]
			$tmpCoordY = $atmparray[$i][1]
		EndIf
	Next
	_ArraySort($atmparray2, 0, 0, 0, 0) ;sort by x
	For $i = 0 To UBound($atmparray2) - 1
		$atmparray2[$i][0] = Number($atmparray2[$i][0])
		$atmparray2[$i][1] = Number($atmparray2[$i][1])
		$atmparray2[$i][2] = Number($atmparray2[$i][2])
		$atmparray2[$i][3] = Number($atmparray2[$i][3])
	Next
	$arr = $atmparray2
EndFunc   ;==>RemoveDupXYAD


