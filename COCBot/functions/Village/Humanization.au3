; #FUNCTION# ====================================================================================================================
; Name ..........: Bot Humanization / Humanization.au3
; Description ...: This file controls the "Humanization" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: RoroTiti, NguyenAnhHD
; Modified ......: Moebius14 (09/2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2024
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ClanStats()
	If _ColorCheck(_GetPixelColor(60, 288 + $g_iMidOffsetY, True), Hex(0x7F7F66, 6), 20) Then ; Classic view
		Local $IsToClickStats = Random(0, 5, 1)
		Local $IsToClickStats2 = Random(0, 5, 1)
		If $IsToClickStats <= 1 Then
			SetLog("Click on Clan Stats", $COLOR_OLIVE)
			Click(90, 350 + $g_iMidOffsetY) ;Click Stats Tab
			If Not $g_bRunState Then Return
			If _Sleep(Random(3000, 6000, 1)) Then Return
			If QuickMIS("BC1", $ClanPerks, 590, 315 + $g_iMidOffsetY, 750, 360 + $g_iMidOffsetY) And $IsToClickStats2 <= 4 Then
				SetLog("Click on Clan Perks", $COLOR_OLIVE)
				Click($g_iQuickMISX - 14, $g_iQuickMISY) ;Click ClanPerks
				If Not $g_bRunState Then Return
				If _Sleep(Random(3000, 6000, 1)) Then Return
				SetLog("Click Back", $COLOR_OLIVE)
				Click(65, 100 + $g_iMidOffsetY) ;Click back to tabs
				If Not $g_bRunState Then Return
				If _Sleep(Random(2000, 3000, 1)) Then Return
				SetLog("Click Back on Classic View", $COLOR_OLIVE)
				Click(95, 245 + $g_iMidOffsetY) ;Click to classic View
				If Not $g_bRunState Then Return
			Else
				SetLog("Click Back on Classic View", $COLOR_OLIVE)
				Click(95, 245 + $g_iMidOffsetY) ;Click to classic View
				If Not $g_bRunState Then Return
			EndIf
		EndIf
	EndIf
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If Not $g_bRunState Then Return

	If _ColorCheck(_GetPixelColor(60, 395 + $g_iMidOffsetY, True), Hex(0x7F7F66, 6), 20) Then ; Stats view
		Local $IsToClickStats = Random(0, 5, 1)
		Local $IsToClickStats2 = Random(0, 5, 1)
		If QuickMIS("BC1", $ClanPerks, 590, 315 + $g_iMidOffsetY, 750, 360 + $g_iMidOffsetY) And $IsToClickStats <= 2 Then
			SetLog("Click on Clan Perks", $COLOR_OLIVE)
			Click($g_iQuickMISX - 14, $g_iQuickMISY) ;Click ClanPerks
			If Not $g_bRunState Then Return
			If _Sleep(Random(3000, 6000, 1)) Then Return
			SetLog("Click Back", $COLOR_OLIVE)
			Click(65, 100 + $g_iMidOffsetY) ;Click back to tabs
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			If $IsToClickStats2 <= 4 Then
				SetLog("Click on Classic View", $COLOR_OLIVE)
				Click(95, 245 + $g_iMidOffsetY) ;Click to classic View
			EndIf
			If Not $g_bRunState Then Return
		Else
			If $IsToClickStats2 <= 4 Then
				SetLog("Click on Classic View", $COLOR_OLIVE)
				Click(95, 245 + $g_iMidOffsetY) ;Click to classic View
			EndIf
			If Not $g_bRunState Then Return
		EndIf
	EndIf
	If _Sleep(Random(2000, 3000, 1)) Then Return
	If Not $g_bRunState Then Return
EndFunc   ;==>ClanStats

Func SCMessTabRead()
	SetLog("Read SC Messages Menu", $COLOR_BLUE)
	Click(715, 630 + $g_iBottomOffsetY)     ; open events
	If _Sleep(3000) Then Return

	If Not $g_bRunState Then Return

	Local $TabtoClick = Random(0, 2, 1)
	If _ColorCheck(_GetPixelColor(261, 75, True), "EC0A13", 20) Then
		$TabtoClick = 0
		SetLog("Detection in News Tab", $COLOR_OLIVE)
	ElseIf _ColorCheck(_GetPixelColor(596, 75, True), "EC0A13", 20) Then
		$TabtoClick = 2
		SetLog("Detection in Esports Tab", $COLOR_OLIVE)
	EndIf
	Switch $TabtoClick
		Case 0
			SetLog("Open News Tab", $COLOR_DEBUG)
			Click(195, 95)
			If _Sleep(Random(2000, 6000, 1)) Then Return

			Local $SideSwitchNews = Random(1, 4, 1)
			Switch $SideSwitchNews
				Case 1
					SetLog("Scrolling Left And Right Sides", $COLOR_OLIVE)
					ScrollNewsLeft(Random(0, 2, 1))
					If _Sleep(Random(3000, 5000, 1)) Then Return
					ScrollNewsRight(Random(0, 2, 1))
				Case 2
					SetLog("Scrolling Right And Left Sides", $COLOR_OLIVE)
					ScrollNewsRight(Random(0, 2, 1))
					If _Sleep(Random(3000, 5000, 1)) Then Return
					ScrollNewsLeft(Random(0, 2, 1))
				Case 3
					SetLog("Scrolling Right Side", $COLOR_OLIVE)
					ScrollNewsRight(Random(0, 2, 1))
				Case 4
					SetLog("Scrolling Left Side", $COLOR_OLIVE)
					ScrollNewsLeft(Random(0, 2, 1))
			EndSwitch

			If _Sleep(Random(2000, 4000, 1)) Then Return
		Case 1
			SetLog("Open Community Tab", $COLOR_DEBUG)
			Click(360, 95)
			SetLog("Just Wait in Community Tab", $COLOR_OLIVE)
			If _Sleep(Random(3000, 8000, 1)) Then Return
		Case 2
			SetLog("Open Esports Tab", $COLOR_DEBUG)
			Click(525, 95)
			Local $bLoop = 0
			While 1
				If $bLoop = 30 Then ExitLoop
				If WaitforPixel(700, 145 + $g_iMidOffsetY, 705, 150 + $g_iMidOffsetY, Hex(0xE8E8E0, 6), 15, 10) Then
					$bLoop += 1
					If _Sleep(500) Then Return
				Else
					ExitLoop
				EndIf
			WEnd
			Local $SideSwitchEsports = Random(1, 5, 1)
			If $bLoop = 30 Then $SideSwitchEsports = 5
			Switch $SideSwitchEsports
				Case 1
					SetLog("Scrolling Left And Right Sides", $COLOR_OLIVE)
					ScrollEsportsLeft(Random(1, 2, 1))
					If _Sleep(Random(3000, 5000, 1)) Then Return
					ScrollEsportsRight(Random(1, 2, 1))
				Case 2
					SetLog("Scrolling Right And Left Sides", $COLOR_OLIVE)
					ScrollEsportsRight(Random(1, 2, 1))
					If _Sleep(Random(3000, 5000, 1)) Then Return
					ScrollEsportsLeft(Random(1, 2, 1))
				Case 3
					SetLog("Scrolling Right Side", $COLOR_OLIVE)
					ScrollEsportsRight(Random(1, 2, 1))
				Case 4
					SetLog("Scrolling Left Side", $COLOR_OLIVE)
					ScrollEsportsLeft(Random(1, 2, 1))
				Case 5
					SetLog("Do Nothing On Esports Tab", $COLOR_OLIVE)
					If _Sleep(Random(3000, 8000, 1)) Then Return
			EndSwitch
			If _Sleep(2000) Then Return
	EndSwitch

	If QuickMIS("BC1", $ImgRedEvent, 100, 55, 650, 95, True, False) Then
		Click($g_iQuickMISX - 60, $g_iQuickMISY + 10)
		If _Sleep(Random(3000, 5000, 1)) Then Return
	EndIf

	If Not $g_bRunState Then Return
	If _Sleep(Random(2000, 4000, 1)) Then Return
	SetLog("Exiting ...", $COLOR_OLIVE)
	CloseWindow2()
	ReturnAtHome()
EndFunc   ;==>SCMessTabRead

Func LookAtWarLog()
	Local $IsToCheckRaidLog = Random(0, 3, 1)
	Local $MaxScroll = 0
	If _Sleep(1000) Then Return
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If _Sleep(2000) Then Return
	If Not $g_bRunState Then Return

	If ChatOpen() Then
		If _Sleep(1000) Then Return

		If IsClanChat() Then
			Click(120, 25) ; open the clan menu
			If _Sleep(1500) Then Return
			If Not $g_bRunState Then Return

			If IsClanOverview() Then

				If $IsToCheckRaidLog = 3 Then
					SetLog("Check Raid Log ...", $COLOR_BLUE)
					Click(700, 155 + $g_iMidOffsetY)
					If _Sleep(Random(2000, 4000, 1)) Then Return
					If QuickMIS("BC1", $g_sImgHumanizationRaidLog) Then
						Click($g_iQuickMISX, $g_iQuickMISY) ; open raid log
						If Not $g_bRunState Then Return
						If _Sleep(Random(2000, 4000, 1)) Then Return
						Click(720, 370 + $g_iMidOffsetY) ; Go Button
						If _Sleep(Random(2000, 4000, 1)) Then Return
						Click(425, 250 + $g_iMidOffsetY) ; Attack Log Tab
						If _Sleep(Random(2000, 3000, 1)) Then Return
						For $i = 0 To $MaxScroll ; Scroll Attack Log Tab
							Local $x = Random(270, 570, 1)
							Local $yStart = Random(550, 585, 1)
							Local $yEnd = Random(340, 380, 1)
							ClickDrag($x, $yStart, $x, $yEnd)
							If _Sleep(4000) Then Return
							If Not $g_bRunState Then Return
						Next
						Click(675, 250 + $g_iMidOffsetY) ; Defense Log Tab
						If _Sleep(Random(2000, 3000, 1)) Then Return
						Local $MaxScroll2 = Random(0, 2, 1)
						For $i = 0 To $MaxScroll2 ; Scroll Defense Log Tab
							Local $x = Random(270, 570, 1)
							Local $yStart = Random(550, 585, 1)
							Local $yEnd = Random(340, 380, 1)
							ClickDrag($x, $yStart, $x, $yEnd)
							If _Sleep(4000) Then Return
							If Not $g_bRunState Then Return
						Next
						If _Sleep(Random(2000, 3000, 1)) Then Return
						SetLog("Exiting ...", $COLOR_OLIVE)
						For $i = 0 To 1
							CloseWindow2()
						Next
					Else
						SetLog("No Raid Log Button Found ... Skipping ...", $COLOR_WARNING)
						If Not $g_bRunState Then Return
						CloseWindow() ; close window
						If _Sleep(1000) Then Return
						SetLog("Exiting ...", $COLOR_OLIVE)
					EndIf
				ElseIf $IsToCheckRaidLog < 3 Then
					If QuickMIS("BC1", $g_sImgHumanizationWarLog) Then ; October Update Changed
						Click($g_iQuickMISX, $g_iQuickMISY) ; open war log
						If _Sleep(Random(2000, 3000, 1)) Then Return
						If Not $g_bRunState Then Return

						Local $WarTypeChoice = Random(1, 2, 1)
						Switch $WarTypeChoice
							Case 1
								SetLog("Classic War Log ...", $COLOR_BLUE)
								Click(260, 160 + $g_iMidOffsetY) ; click Classic War tab
								If _Sleep(1000) Then Return
								If Not $g_bRunState Then Return
								SetLog("Let's Scrolling The Classic War Log ...", $COLOR_OLIVE)
								Scroll(Random(1, 4, 1)) ; scroll the log
							Case 2
								SetLog("War League Log ...", $COLOR_BLUE)
								Click(620, 160 + $g_iMidOffsetY) ; click War League tab
								If _Sleep(1000) Then Return
								If Not $g_bRunState Then Return
								SetLog("Let's Scrolling The War League Log ...", $COLOR_OLIVE)
								Scroll(Random(0, 1, 1)) ; scroll the log
						EndSwitch
					Else
						SetLog("No War Log Button Found ... Skipping ...", $COLOR_WARNING)
					EndIf
					If Not $g_bRunState Then Return
					CloseWindow2()
					SetLog("Exiting ...", $COLOR_OLIVE)
				EndIf
				If _Sleep(500) Then Return
				If Not ClickB("ClanChat") Then
					SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
					Return
				EndIf
			Else
				SetLog("Error When Trying To Open Clan Overview ... Skipping ...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error When Trying To Open Clan Chat ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Chat ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>LookAtWarLog

Func VisitClanmates()
	Local $Villagemode = Random(1, 6, 1)
	Local $ClanFilter = Random(1, 6, 1)
	Local $bVillage = ""
	If _Sleep(1000) Then Return
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If _Sleep(2000) Then Return

	If ChatOpen() Then
		If _Sleep(1000) Then Return
		If Not $g_bRunState Then Return

		If IsClanChat() Then
			Click(120, 25) ; open the clan menu
			If _Sleep(1500) Then Return
			If Not $g_bRunState Then Return

			If IsClanOverview() Then

				ClanStats()

				Switch $Villagemode
					Case 1
						SetLog("Let's Stay In Home Village Mode...", $COLOR_OLIVE)
						$bVillage = "HomeVillage"
						If _Sleep(1500) Then Return
					Case 2
						SetLog("Looking At Builder Base Mode ...", $COLOR_OLIVE)
						$bVillage = "Builder Base"
						Click(430, 155 + $g_iMidOffsetY)
						If _Sleep(1500) Then Return
					Case 3
						SetLog("Looking At Clan Capital Mode ...", $COLOR_OLIVE)
						$bVillage = "ClanCapital"
						Click(690, 155 + $g_iMidOffsetY)
						If _Sleep(1500) Then Return
					Case 4, 5, 6
						SetLog("Let's Stay In Home Village Mode...", $COLOR_OLIVE)
						$bVillage = "HomeVillage"
						If _Sleep(1500) Then Return
				EndSwitch

				If $ClanFilter <= 2 Then
					SetLog("Let's Use The Clan Filter", $COLOR_OLIVE)
					If QuickMIS("BC1", $g_sImgClanFilter, 380, 410 + $g_iMidOffsetY, 510, 540 + $g_iMidOffsetY) Then
						ClickClanFilter(Random(1, 5, 1), $g_iQuickMISX, $g_iQuickMISY)
					EndIf
				EndIf

				SetLog("Let's Visit a Random Player ...", $COLOR_OLIVE)
				Local $VisitClanmatesChoice = Random(1, 4, 1)
				Switch $VisitClanmatesChoice
					Case 1
						SetLog("Top of Clan ...", $COLOR_DEBUG)

						If Not FindMark($bVillage, True) Then
							SetLog("Exiting ...", $COLOR_OLIVE)
							If _Sleep(Random(2000, 3000, 1)) Then Return
							ReturnHomeFromHumanization()
						EndIf

						VisitAPlayer()
						If _Sleep(500) Then Return
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						ReturnHomeFromHumanization()
					Case 2, 3, 4
						SetLog("Lets Scroll Clan List ...", $COLOR_DEBUG)
						If _Sleep(1000) Then Return
						ScrollList(Random(1, 3, 1)) ; scroll the log

						If Not FindMark($bVillage, False) Then
							SetLog("Exiting ...", $COLOR_OLIVE)
							If _Sleep(Random(2000, 3000, 1)) Then Return
							ReturnHomeFromHumanization()
						EndIf

						VisitAPlayer()
						If _Sleep(500) Then Return
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						ReturnHomeFromHumanization()
				EndSwitch
			Else
				SetLog("Error When Trying To Open Clan overview ... Skipping ...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error When Trying To Open Clan Chat ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Chat ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>VisitClanmates

Func LookAtCurrentWar()
	Local $sResult, $bResult

	CheckWarTime($sResult, $bResult, False)
	If Not $g_bRunState Then Return

	If $IsWarNotActive Then
		SetLog("Exiting ...", $COLOR_OLIVE)
		If _Sleep(Random(2000, 3000, 1)) Then Return
		Return ReturnToHomeFromWar()
	EndIf

	If Not @error Then
		If _Sleep(250) Then Return
		If ($g_bClanWar Or $g_bClanWarLeague) And $IsStepWar Or ($g_bClanWarLeague And $CWLPrep) Then ; If any war step

			If IsWarMenu() Then
				Local $sWarMode = ($g_bClanWarLeague = True) ? ("Current CWL war") : ("Current War")
				SetLog("Let's Examine The " & $sWarMode & " Map ...", $COLOR_BLUE)
				If $g_bClanWar And $g_HowManyPlayersInCW < 10 Then
					SetLog("Little War : No Scroll", $COLOR_OLIVE)
				ElseIf $g_bClanWar And $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
					Scroll(Random(1, 2, 1))
				ElseIf $g_bClanWar And $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
					Scroll(Random(1, 3, 1))
				ElseIf $g_bClanWar And $g_HowManyPlayersInCW >= 40 Then
					Scroll(Random(1, 4, 1))
				EndIf
				If _Sleep(3000) Then Return
				If Not $g_bRunState Then Return

				If $g_bClanWarLeague And $g_HowManyPlayersInCWL < 10 Then
					SetLog("Little War : No Scroll", $COLOR_OLIVE)
				ElseIf $g_bClanWarLeague And $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
					Scroll(Random(1, 2, 1))
				ElseIf $g_bClanWarLeague And $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
					Scroll(Random(1, 3, 1))
				ElseIf $g_bClanWarLeague And $g_HowManyPlayersInCWL >= 40 Then
					Scroll(Random(1, 4, 1))
				EndIf
				If _Sleep(3000) Then Return
				If Not $g_bRunState Then Return

				If $g_bClanWar And $IsWarDay Then ; CW in Preparation / Switch/Scroll
					Local $Switchterritory = Random(0, 1, 1)
					Local $Switchterritory2 = Random(0, 1, 1)
					If $Switchterritory = 1 Then
						SetLog("Switch To Enemy Territory", $COLOR_DEBUG)
						If _Sleep(Random(1000, 2000, 1)) Then Return
						Click(790, 340 + $g_iMidOffsetY) ; Switch territory
						If _Sleep(Random(2000, 3000, 1)) Then Return
						If Not $g_bRunState Then Return
						If $g_HowManyPlayersInCW < 10 Then
							SetLog("Little War : No Scroll", $COLOR_OLIVE)
						ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
							Scroll(Random(1, 2, 1))
						ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
							Scroll(Random(1, 3, 1))
						ElseIf $g_HowManyPlayersInCW >= 40 Then
							Scroll(Random(1, 4, 1))
						EndIf
					EndIf
					If _Sleep(Random(2000, 3000, 1)) Then Return
					If Not $g_bRunState Then Return
					If $Switchterritory2 = 1 Then
						If $Switchterritory = 1 Then
							SetLog("Switch Back To Home Territory", $COLOR_DEBUG)
						Else
							SetLog("Switch To Enemy Territory", $COLOR_DEBUG)
						EndIf
						If _Sleep(Random(1000, 2000, 1)) Then Return
						Click(790, 340 + $g_iMidOffsetY) ; Switch territory
						If _Sleep(Random(2000, 3000, 1)) Then Return
						If Not $g_bRunState Then Return
						If $g_HowManyPlayersInCW < 10 Then
							SetLog("Little War : No Scroll", $COLOR_OLIVE)
						ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
							Scroll(Random(1, 2, 1))
						ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
							Scroll(Random(1, 3, 1))
						ElseIf $g_HowManyPlayersInCW >= 40 Then
							Scroll(Random(1, 4, 1))
						EndIf
					EndIf
					If _Sleep(Random(2000, 3000, 1)) Then Return
					If Not $g_bRunState Then Return
				ElseIf $g_bClanWar And ($IsWarDay Or $IsWarEnded) Then ; CW in war or ended / Switch/Scroll
					If Not $IsWarEnded Then
						Local $Switchterritory = Random(0, 1, 1)
						Local $Switchterritory2 = Random(0, 1, 1)
						If $Switchterritory = 1 Then
							SetLog("Switch To Home Territory", $COLOR_DEBUG)
							If _Sleep(Random(1000, 2000, 1)) Then Return
							Click(790, 340 + $g_iMidOffsetY) ; Switch territory
							If _Sleep(Random(2000, 3000, 1)) Then Return
							If Not $g_bRunState Then Return
							If $g_HowManyPlayersInCW < 10 Then
								SetLog("Little War : No Scroll", $COLOR_OLIVE)
							ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
								Scroll(Random(1, 2, 1))
							ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
								Scroll(Random(1, 3, 1))
							ElseIf $g_HowManyPlayersInCW >= 40 Then
								Scroll(Random(1, 4, 1))
							EndIf
						EndIf
						If $Switchterritory2 = 1 Then
							If $Switchterritory = 1 Then
								SetLog("Switch Back To Enemy Territory", $COLOR_DEBUG)
							Else
								SetLog("Switch To Home Territory", $COLOR_DEBUG)
							EndIf
							If _Sleep(Random(1000, 2000, 1)) Then Return
							Click(790, 340 + $g_iMidOffsetY) ; Switch territory
							If _Sleep(Random(2000, 3000, 1)) Then Return
							If Not $g_bRunState Then Return
							If $g_HowManyPlayersInCW < 10 Then
								SetLog("Little War : No Scroll", $COLOR_OLIVE)
							ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
								Scroll(Random(1, 2, 1))
							ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
								Scroll(Random(1, 3, 1))
							ElseIf $g_HowManyPlayersInCW >= 40 Then
								Scroll(Random(1, 4, 1))
							EndIf
						EndIf
						If _Sleep(Random(2000, 3000, 1)) Then Return
						If Not $g_bRunState Then Return
					ElseIf $IsWarEnded Then
						Local $Switchterritory = Random(0, 1, 1)
						Local $Switchterritory2 = Random(0, 1, 1)
						If $Switchterritory = 1 Then
							SetLog("Switch To Enemy Territory", $COLOR_DEBUG)
							If _Sleep(Random(1000, 2000, 1)) Then Return
							Click(790, 340 + $g_iMidOffsetY) ; Switch territory
							If _Sleep(Random(2000, 3000, 1)) Then Return
							If Not $g_bRunState Then Return
							If $g_HowManyPlayersInCW < 10 Then
								SetLog("Little War : No Scroll", $COLOR_OLIVE)
							ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
								Scroll(Random(1, 2, 1))
							ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
								Scroll(Random(1, 3, 1))
							ElseIf $g_HowManyPlayersInCW >= 40 Then
								Scroll(Random(1, 4, 1))
							EndIf
						EndIf
						If $Switchterritory2 = 1 Then
							If $Switchterritory = 1 Then
								SetLog("Switch Back To Home Territory", $COLOR_DEBUG)
							Else
								SetLog("Switch To Enemy Territory", $COLOR_DEBUG)
							EndIf
							If _Sleep(Random(1000, 2000, 1)) Then Return
							Click(790, 340 + $g_iMidOffsetY) ; Switch territory
							If _Sleep(Random(2000, 3000, 1)) Then Return
							If Not $g_bRunState Then Return
							If $g_HowManyPlayersInCW < 10 Then
								SetLog("Little War : No Scroll", $COLOR_OLIVE)
							ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
								Scroll(Random(1, 2, 1))
							ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
								Scroll(Random(1, 3, 1))
							ElseIf $g_HowManyPlayersInCW >= 40 Then
								Scroll(Random(1, 4, 1))
							EndIf
						EndIf
						If _Sleep(Random(2000, 3000, 1)) Then Return
						If Not $g_bRunState Then Return
					EndIf
				EndIf

				If ($g_bClanWarLeague And Not $IsAllowedPreparationDay And Not $CWLPrep) Or $IsWarDay Or $IsWarEnded Or $g_bClanWar Then
					SetLog("Open War Details Menu ...", $COLOR_BLUE)
					If $g_bClanWar Then Click(800, 610 + $g_iBottomOffsetY) ; go to war details
					If $g_bClanWarLeague Then Click(810, 540 + $g_iMidOffsetY) ; go to Cwl war details
					If _Sleep(Random(2000, 3000, 1)) Then Return
					If Not $g_bRunState Then Return

					If IsClanOverview() Then
						If $IsWarDay Or $IsWarEnded Then ; CW and CWL in war or ended
							Local $FirstMenu = Random(1, 2, 1)
							Switch $FirstMenu
								Case 1
									SetLog("Looking At War Stats ...", $COLOR_DEBUG)
									Click(180, 100 + $g_iMidOffsetY) ; click first tab
									Scroll(Random(0, 1, 1))
								Case 2
									SetLog("Looking At War Events ...", $COLOR_DEBUG)
									Click(355, 100 + $g_iMidOffsetY) ; click second tab
									If $g_bClanWar Then
										If Not $IsWarEnded Then
											If $g_HowManyPlayersInCW < 10 Then
												SetLog("Little War : No Scroll", $COLOR_OLIVE)
											ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
												Scroll(Random(1, 2, 1))
											ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
												Scroll(Random(1, 3, 1))
											ElseIf $g_HowManyPlayersInCW >= 40 Then
												Scroll(Random(1, 4, 1))
											EndIf
										ElseIf $IsWarEnded Then
											If $g_HowManyPlayersInCW < 10 Then
												Scroll(Random(0, 1, 1))
											ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
												Scroll(Random(1, 3, 1))
											ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
												Scroll(Random(1, 4, 1))
											ElseIf $g_HowManyPlayersInCW >= 40 Then
												Scroll(Random(1, 5, 1))
											EndIf
										EndIf
									ElseIf $g_bClanWarLeague Then
										If Not $IsWarEnded Then
											If $g_HowManyPlayersInCWL < 10 Then
												SetLog("Little War : No Scroll", $COLOR_OLIVE)
											ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
												Scroll(Random(1, 2, 1))
											ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
												Scroll(Random(1, 3, 1))
											ElseIf $g_HowManyPlayersInCWL >= 40 Then
												Scroll(Random(1, 4, 1))
											EndIf
										ElseIf $IsWarEnded Then
											If $g_HowManyPlayersInCWL < 10 Then
												Scroll(Random(0, 1, 1))
											ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
												Scroll(Random(1, 3, 1))
											ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
												Scroll(Random(1, 4, 1))
											ElseIf $g_HowManyPlayersInCWL >= 40 Then
												Scroll(Random(1, 5, 1))
											EndIf
										EndIf
									EndIf
									If _Sleep(1500) Then Return
									If Not $g_bRunState Then Return
							EndSwitch
						ElseIf Not $IsWarDay And Not $IsWarEnded Then ; CW and CWL Preparation
							Local $FirstMenu = Random(1, 2, 1)
							Switch $FirstMenu
								Case 1
									SetLog("Looking At My Team Tab ...", $COLOR_DEBUG)
									Click(180, 100 + $g_iMidOffsetY) ; click first tab
									If $g_bClanWar Then
										If $g_HowManyPlayersInCW < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCW >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
										If _Sleep(1500) Then Return
										If Not $g_bRunState Then Return
									ElseIf $g_bClanWarLeague Then
										If $g_HowManyPlayersInCWL < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCWL >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
										If _Sleep(1500) Then Return
										If Not $g_bRunState Then Return
									EndIf
								Case 2
									SetLog("Looking At Enemy Team Tab ...", $COLOR_DEBUG)
									Click(360, 100 + $g_iMidOffsetY) ; click second tab
									If $g_bClanWar Then
										If $g_HowManyPlayersInCW < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCW >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
										If _Sleep(1500) Then Return
										If Not $g_bRunState Then Return
									ElseIf $g_bClanWarLeague Then
										If $g_HowManyPlayersInCWL < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCWL >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
										If _Sleep(1500) Then Return
										If Not $g_bRunState Then Return
									EndIf
							EndSwitch
						EndIf

						If _Sleep(Random(3000, 6000, 1)) Then Return

						If Not $IsWarDay And Not $IsWarEnded Then ; CW And CWL preparation
							Local $SecondMenu = Random(1, 2, 1)
							Switch $SecondMenu
								Case 1
									SetLog("Looking At Attacks Tab ...", $COLOR_DEBUG)
									Click(260, 155 + $g_iMidOffsetY) ; click the Attacks tab
									If $g_bClanWar Then
										If $g_HowManyPlayersInCW < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCW >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									ElseIf $g_bClanWarLeague Then
										If $g_HowManyPlayersInCWL < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCWL >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									EndIf
									If _Sleep(1500) Then Return
									If Not $g_bRunState Then Return
								Case 2
									SetLog("Looking At Defenses Tab ...", $COLOR_DEBUG)
									Click(630, 155 + $g_iMidOffsetY) ; click the Defenses tab
									If $g_bClanWar Then
										If $g_HowManyPlayersInCW < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCW >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									ElseIf $g_bClanWarLeague Then
										If $g_HowManyPlayersInCWL < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCWL >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									EndIf
									If _Sleep(1500) Then Return
									If Not $g_bRunState Then Return
							EndSwitch
						ElseIf $IsWarDay Or $IsWarEnded Then ; CW and CWL in war or ended
							Local $SecondMenu = Random(1, 2, 1)
							Switch $SecondMenu
								Case 1
									SetLog("Looking At My Team Tab ...", $COLOR_DEBUG)
									Click(525, 100 + $g_iMidOffsetY) ; click the third tab
									If _Sleep(Random(2000, 4000, 1)) Then Return
									Local $SecondSubMenu = Random(1, 2, 1)
									Switch $SecondSubMenu
										Case 1
											SetLog("Looking At Attacks Tab ...", $COLOR_DEBUG)
											Click(260, 155 + $g_iMidOffsetY) ; click the Attacks tab
										Case 2
											SetLog("Looking At Defenses Tab ...", $COLOR_DEBUG)
											Click(630, 155 + $g_iMidOffsetY) ; click the Defenses tab
									EndSwitch
									If _Sleep(1500) Then Return
									If Not $g_bRunState Then Return
									If $g_bClanWar Then
										If $g_HowManyPlayersInCW < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCW >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									ElseIf $g_bClanWarLeague Then
										If $g_HowManyPlayersInCWL < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCWL >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									EndIf
								Case 2
									SetLog("Looking At Enemy Team Tab ...", $COLOR_DEBUG)
									Click(690, 100 + $g_iMidOffsetY) ; click the fourth tab
									If _Sleep(Random(2000, 4000, 1)) Then Return
									Local $SecondSubMenu = Random(1, 2, 1)
									Switch $SecondSubMenu
										Case 1
											SetLog("Looking At Attacks Tab ...", $COLOR_DEBUG)
											Click(260, 155 + $g_iMidOffsetY) ; click the Attacks tab
										Case 2
											SetLog("Looking At Defenses Tab ...", $COLOR_DEBUG)
											Click(630, 155 + $g_iMidOffsetY) ; click the Defenses tab
									EndSwitch
									If _Sleep(1500) Then Return
									If Not $g_bRunState Then Return
									If $g_bClanWar Then
										If $g_HowManyPlayersInCW < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCW > 10 And $g_HowManyPlayersInCW < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCW >= 20 And $g_HowManyPlayersInCW < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCW >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									ElseIf $g_bClanWarLeague Then
										If $g_HowManyPlayersInCWL < 10 Then
											SetLog("Little War : No Scroll", $COLOR_OLIVE)
										ElseIf $g_HowManyPlayersInCWL > 10 And $g_HowManyPlayersInCWL < 20 Then
											Scroll(Random(1, 2, 1))
										ElseIf $g_HowManyPlayersInCWL >= 20 And $g_HowManyPlayersInCWL < 40 Then
											Scroll(Random(1, 3, 1))
										ElseIf $g_HowManyPlayersInCWL >= 40 Then
											Scroll(Random(1, 4, 1))
										EndIf
									EndIf
							EndSwitch
						EndIf
						If _Sleep(Random(2000, 4000, 1)) Then Return
						CloseWindow()
						If Not $g_bRunState Then Return
					Else
						SetLog("Error When Trying To Open War Details Window ... Skipping ...", $COLOR_WARNING)
					EndIf
				EndIf
			EndIf
		Else
			SetLog("Your Clan Is Not In Active War yet ... Skipping ...", $COLOR_WARNING)
			If _Sleep(1500) Then Return
			If Not $g_bRunState Then Return
		EndIf
	Else
		SetLog("Error When Trying To Open War Details Window ... Skipping ...", $COLOR_WARNING)
	EndIf

	If $IsStepWar Or ($g_bClanWarLeague And $CWLPrep) Then
		Local $Is3tabstoclick = Random(0, 4, 1)
		If $g_bClanWarLeague And $Is3tabstoclick >= 2 Then
			SetLog("Look at Season Info", $COLOR_BLUE)
			Click(796, 615 + $g_iBottomOffsetY) ; go to Cwl Season Info
			If _Sleep(Random(2000, 3000, 1)) Then Return
			Local $Click3Tabs = Random(0, 2, 1)
			Switch $Click3Tabs
				Case 0
					SetLog("Look at Group Tab", $COLOR_DEBUG) ;Group Tab
				Case 1
					SetLog("Look at Round Tab", $COLOR_DEBUG) ;Round Tab
					Click(355, 80)
					If _Sleep(Random(2000, 3000, 1)) Then Return
				Case 2
					SetLog("Look at Clan Tab", $COLOR_DEBUG) ;Clan Tab
					Click(525, 80)
					If _Sleep(Random(2000, 3000, 1)) Then Return
					Scroll3Tabs(Random(1, 3, 1))
			EndSwitch

			If _Sleep(Random(2000, 4000, 1)) Then Return
			CloseWindow2()
			If Not $g_bRunState Then Return
		EndIf
	EndIf
	If _Sleep(Random(2000, 4000, 1)) Then Return

	If $g_bClanWarLeague Then
		If QuickMIS("BC1", $directoryDay & "\CWL_Battle", 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY, True, False) Then ; When Battle Day Is Unselected
			SetLog("Back To Battle Day", $COLOR_OLIVE)
			Click($g_iQuickMISX - 5, $g_iQuickMISY + 12)
			If _Sleep(1500) Then Return
		Else
			If $IsWarEnded Then
				Click($bResult, 615 + $g_iBottomOffsetY)
				If _Sleep(1500) Then Return
			EndIf
		EndIf
	EndIf

	$IsAllowedPreparationDay = True
	$IsARandomDay = False
	SetLog("Exiting ...", $COLOR_OLIVE)
	If _Sleep(Random(2000, 3000, 1)) Then Return
	Return ReturnToHomeFromWar()
EndFunc   ;==>LookAtCurrentWar

Func WatchWarReplays()
	Local $sResult, $bResult
	$IsAllowedPreparationDay = False
	CheckWarTime($sResult, $bResult, False, True)

	If $IsWarNotActive Then
		SetLog("Exiting ...", $COLOR_OLIVE)
		If _Sleep(Random(2000, 3000, 1)) Then Return
		Return ReturnToHomeFromWar()
	EndIf

	If $g_bClanWarLeague And $CWLPrep Then
		SetLog("CWL Preparation ... Skipping ...", $COLOR_WARNING)
		If _Sleep(1500) Then Return
		If Not $g_bRunState Then Return
		$IsAllowedPreparationDay = True
		SetLog("Exiting ...", $COLOR_OLIVE)
		If _Sleep(Random(2000, 3000, 1)) Then Return
		Return ReturnToHomeFromWar()
	EndIf

	If Not $IsStepWar Then
		SetLog("Your Clan Is Not In Active War Yet ... Skipping ...", $COLOR_WARNING)
		If _Sleep(1500) Then Return
		If Not $g_bRunState Then Return
		$IsAllowedPreparationDay = True
		SetLog("Exiting ...", $COLOR_OLIVE)
		If _Sleep(Random(2000, 3000, 1)) Then Return
		Return ReturnToHomeFromWar()
	EndIf

	If Not @error Then
		If _Sleep(250) Then Return
		If Not $g_bRunState Then Return
		If ($g_bClanWar Or $g_bClanWarLeague) And ($IsWarDay Or $IsWarEnded Or $IsARandomDay) Then
			SetLog("Open War Details Menu ...", $COLOR_BLUE)

			If $g_bClanWar Then Click(800, 610 + $g_iBottomOffsetY) ; go to war details
			If _Sleep(Random(2000, 3000, 1)) Then Return
			If Not $g_bRunState Then Return

			If $g_bClanWarLeague Then Click(810, 510 + $g_iBottomOffsetY) ; go to Cwl war details
			If _Sleep(Random(2000, 3000, 1)) Then Return

			If $IsWarDay Or $IsWarEnded Or $IsARandomDay Then

				If IsClanOverview() Then
					If _Sleep(Random(1000, 2000, 1)) Then Return
					SetLog("Looking At Second Tab ...", $COLOR_DEBUG)
					Click(350, 100 + $g_iMidOffsetY) ; go to replays tab
					If _Sleep(Random(1500, 2000, 1)) Then Return
					If Not $g_bRunState Then Return

					Local $aSarea[4] = [765, 245 + $g_iMidOffsetY, 845, 610 + $g_iMidOffsetY]
					Local $vReplayNumber = findMultipleQuick($g_sImgHumanizationReplay, 6, $aSarea, True, "", False, 36)
					If UBound($vReplayNumber) > 0 And Not @error Then
						SetLog("There Are " & UBound($vReplayNumber) & " Replays To Watch ... We Will Choose One Of Them ...", $COLOR_INFO)
						Local $iReplayToLaunch = Random(0, UBound($vReplayNumber) - 1, 1)

						Click($vReplayNumber[$iReplayToLaunch][1] - 10, $vReplayNumber[$iReplayToLaunch][2] + 10) ; click on the choosen replay

						WaitForReplayWindow()

						If IsReplayWindow() Then
							GetReplayDuration(1)
							If _Sleep(1000) Then Return
							If Not $g_bRunState Then Return

							If IsReplayWindow() Then
								AccelerateReplay(1)
							EndIf

							If _Sleep($g_aReplayDuration[1] / 3) Then Return

							If IsReplayWindow() Then
								DoAPauseDuringReplay(1)
							EndIf

							If _Sleep($g_aReplayDuration[1] / 3) Then Return

							If IsReplayWindow() And $g_aReplayDuration[0] <> 0 Then
								DoAPauseDuringReplay(1)
							EndIf

							SetLog("Waiting For Replay End ...", $COLOR_ACTION)

							While IsReplayWindow()
								If _Sleep(1000) Then Return
								If Not $g_bRunState Then Return
							WEnd

							If _Sleep(1000) Then Return
							If Not $g_bRunState Then Return

							Local $aBack = findButton("AttackButton", Default, 1, True)
							If IsArray($aBack) And UBound($aBack, 1) = 2 Then
								ClickP($aBack)
							EndIf

						EndIf
					Else
						SetLog("No Replay To Watch Yet ... Skipping ...", $COLOR_WARNING)
						CloseWindow2()
					EndIf
				Else
					SetLog("Error When Trying to Open War Details Window ... Skipping ...", $COLOR_WARNING)
				EndIf

				Local $iSleepForWindow = Random(2000, 3000, 1)
				CloseWindow2()
				Local $iSleepForWindow2 = Random(1000, 2000, 1)
				If _Sleep($iSleepForWindow2) Then Return

				If $g_bClanWarLeague Then
					If QuickMIS("BC1", $directoryDay & "\CWL_Battle", 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY, True, False) Then ; When Battle Day Is Unselected
						SetLog("Back To Battle Day", $COLOR_OLIVE)
						Click($g_iQuickMISX - 5, $g_iQuickMISY + 12)
						If _Sleep(1500) Then Return
					Else
						If $IsWarEnded Then
							SetLog("Back To Battle Day", $COLOR_OLIVE)
							Click($bResult, 615 + $g_iBottomOffsetY)
							If _Sleep(1500) Then Return
						EndIf
					EndIf
				EndIf

			Else
				SetLog("Your Clan Is Not In Active War Yet ... Skipping ...", $COLOR_WARNING)
				If _Sleep(1500) Then Return
				If Not $g_bRunState Then Return
			EndIf

		Else
			SetLog("No Replay To Watch Yet, See Ya Later", $COLOR_WARNING)
			CloseWindow2()
		EndIf

	EndIf

	$IsAllowedPreparationDay = True
	$IsARandomDay = False
	SetLog("Exiting ...", $COLOR_OLIVE)
	If _Sleep(Random(2000, 3000, 1)) Then Return
	Return ReturnToHomeFromWar()
EndFunc   ;==>WatchWarReplays

Func WatchDefense()
	Click(40, 120 + $g_iMidOffsetY) ; open messages tab - defenses tab
	If _Sleep(1500) Then Return
	If Not $g_bRunState Then Return

	If IsMessagesReplayWindow() Then
		Click(165, 75 + $g_iMidOffsetY) ; open defenses tab
		If _Sleep(1500) Then Return
		If Not $g_bRunState Then Return

		If IsDefensesTab() Then
			Local $aSarea[4] = [655, 100 + $g_iMidOffsetY, 800, 615 + $g_iMidOffsetY]
			Local $vReplayNumber = findMultipleQuick($g_sHVReplay, 6, $aSarea, True, "", False, 36)
			If UBound($vReplayNumber) > 0 And Not @error Then
				SetLog("There Are " & UBound($vReplayNumber) & " Replays To Watch ... We Will Choose One Of Them ...", $COLOR_INFO)
				Local $iReplayToLaunch = Random(0, UBound($vReplayNumber) - 1, 1)
				Click($vReplayNumber[$iReplayToLaunch][1], $vReplayNumber[$iReplayToLaunch][2]) ; click on the choosen replay
			Else
				SetLog("No Replay To Watch ... Skipping ...", $COLOR_WARNING)
				CloseWindow2()
				Return
			EndIf

			WaitForReplayWindow()

			If IsReplayWindow() Then
				GetReplayDuration(0)
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return

				If IsReplayWindow() Then
					AccelerateReplay(0)
				EndIf

				If _Sleep($g_aReplayDuration[1] / 3) Then Return

				Local $IsBoring = Random(1, 5, 1)
				If $IsBoring >= 4 Then
					If IsReplayWindow() Then
						SetLog("This Replay Is Boring, Let Me Go Out ...", $COLOR_OLIVE)
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						Click(70, 620 + $g_iBottomOffsetY) ; return home
					EndIf
				Else
					If IsReplayWindow() Then
						DoAPauseDuringReplay(0)
					EndIf

					If _Sleep($g_aReplayDuration[1] / 3) Then Return

					If IsReplayWindow() And $g_aReplayDuration[0] <> 0 Then
						DoAPauseDuringReplay(0)
					EndIf

					If IsReplayWindow() Then SetLog("Waiting For Replay End ...", $COLOR_ACTION)

					While IsReplayWindow()
						If _Sleep(2000) Then Return
						If Not $g_bRunState Then Return
					WEnd

					If _Sleep(1000) Then Return
					SetLog("Exiting ...", $COLOR_OLIVE)
					If _Sleep(Random(2000, 3000, 1)) Then Return
					ReturnHomeFromHumanization()
				EndIf
			EndIf
		Else
			SetLog("Error When Trying To Open Defenses Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Replays Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>WatchDefense

Func WatchAttack()
	Click(40, 120 + $g_iMidOffsetY) ; open messages tab - defenses tab
	If _Sleep(1500) Then Return
	If Not $g_bRunState Then Return

	If IsMessagesReplayWindow() Then
		Click(370, 75 + $g_iMidOffsetY) ; open attacks tab
		If _Sleep(1500) Then Return
		If Not $g_bRunState Then Return

		If IsAttacksTab() Then
			Local $aSarea[4] = [655, 100 + $g_iMidOffsetY, 800, 615 + $g_iMidOffsetY]
			Local $vReplayNumber = findMultipleQuick($g_sHVReplay, 6, $aSarea, True, "", False, 36)
			If UBound($vReplayNumber) > 0 And Not @error Then
				SetLog("There Are " & UBound($vReplayNumber) & " Replays To Watch ... We Will Choose One Of Them ...", $COLOR_INFO)
				Local $iReplayToLaunch = Random(0, UBound($vReplayNumber) - 1, 1)
				Click($vReplayNumber[$iReplayToLaunch][1], $vReplayNumber[$iReplayToLaunch][2]) ; click on the choosen replay
			Else
				SetLog("No Replay To Watch ... Skipping ...", $COLOR_WARNING)
				CloseWindow2()
				Return
			EndIf

			WaitForReplayWindow()

			If IsReplayWindow() Then
				GetReplayDuration(0)
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return

				If IsReplayWindow() Then
					AccelerateReplay(0)
				EndIf

				If _Sleep($g_aReplayDuration[1] / 3) Then Return

				Local $IsBoring = Random(1, 5, 1)
				If $IsBoring >= 4 Then
					If IsReplayWindow() Then
						SetLog("This Replay Is Boring, Let Me Go Out ...", $COLOR_OLIVE)
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						Click(70, 620 + $g_iBottomOffsetY) ; return home
					EndIf
				Else
					If IsReplayWindow() Then
						DoAPauseDuringReplay(0)
					EndIf

					If _Sleep($g_aReplayDuration[1] / 3) Then Return

					If IsReplayWindow() And $g_aReplayDuration[0] <> 0 Then
						DoAPauseDuringReplay(0)
					EndIf

					If IsReplayWindow() Then SetLog("Waiting For Replay End ...", $COLOR_ACTION)

					While IsReplayWindow()
						If _Sleep(2000) Then Return
						If Not $g_bRunState Then Return
					WEnd

					SetLog("Exiting ...", $COLOR_OLIVE)
					If _Sleep(Random(2000, 3000, 1)) Then Return
					ReturnHomeFromHumanization()
				EndIf
			EndIf
		Else
			SetLog("Error When Trying To Open Defenses Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open Replays Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>WatchAttack

Func BotHumanization()
	If $g_bUseBotHumanization = True Then
		If _Sleep(1500) Then Return
		ForumAccept()
		If _Sleep(500) Then Return
		If Not $g_bRunState Then Return
		SignUpWar()
		If _Sleep(500) Then Return
		If Not $g_bRunState Then Return
		Local $NoActionsToDo = 0
		SetLog("OK, Let The Bot Being More Human Like!", $COLOR_SUCCESS1)

		If $g_bLookAtRedNotifications Then LookAtRedNotifications()
		ReturnAtHome()

		For $i = 0 To UBound($g_iacmbPriority) - 1
			Local $ActionEnabled = $g_iacmbPriority[$i]
			If $ActionEnabled = 0 Then $NoActionsToDo += 1
		Next

		If $NoActionsToDo <> UBound($g_iacmbPriority) Then
			If _Sleep(2000) Then Return
			ReturnAtHome()
			RandomHumanAction()
		EndIf
		SetLog("Bot Humanization Finished !", $COLOR_SUCCESS1)
		If _Sleep(1500) Then Return
		ZoomOut()
	EndIf
EndFunc   ;==>BotHumanization

Func RandomHumanAction()
	For $i = 0 To UBound($g_iacmbPriority) - 1
		SetActionPriority($i)
	Next
	$g_iActionToDo = _ArrayMaxIndex($g_aSetActionPriority)
	Switch $g_iActionToDo
		Case 0
			SetLog("Humanization : Read Clan Chat Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Read Clan Chat"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			ReadClanChat()
			If Not $g_bRunState Then Return
		Case 1
			SetLog("Humanization : Watch a Defense Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Watch a Defense"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			WatchDefense()
			ReturnHomeFromHumanization()
			If Not $g_bRunState Then Return
		Case 2
			SetLog("Humanization : Watch an Attack Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Watch an Attack"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			WatchAttack()
			ReturnHomeFromHumanization()
			If Not $g_bRunState Then Return
		Case 3
			SetLog("Humanization : Look at War Log Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Look at War Log"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			LookAtWarLog()
			If Not $g_bRunState Then Return
		Case 4
			SetLog("Humanization : Visit Clanmates Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Visit Clanmates"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			VisitClanmates()
			If Not $g_bRunState Then Return
		Case 5
			SetLog("Humanization : Visit Best Players Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Visit Best Players"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			VisitBestPlayers()
			If Not $g_bRunState Then Return
		Case 6
			SetLog("Humanization : Look at Best Clans Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Look at Best Clans"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			LookAtBestClans()
			If Not $g_bRunState Then Return
		Case 7
			SetLog("Humanization : Look at Current War Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Look at Current War"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			LookAtCurrentWar()
			If Not $g_bRunState Then Return
		Case 8
			SetLog("Humanization : Watch War Replay Now. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Watch War Replay"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			WatchWarReplays()
			If Not $g_bRunState Then Return
		Case 9
			SetLog("Humanization : Read SC Messages Menu. Let's Go!", $COLOR_INFO)
			$ActionForModLog = "Read SC Messages Menu"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			SCMessTabRead()
			If Not $g_bRunState Then Return
		Case 10
			SetLog("Humanization : Do Nothing For Now.", $COLOR_INFO)
			DoNothing()
			If Not $g_bRunState Then Return
	EndSwitch
EndFunc   ;==>RandomHumanAction

Func SetActionPriority($ActionNumber)
	If $g_iacmbPriority[$ActionNumber] <> 0 Then
		MatchPriorityNValue($ActionNumber)
		$g_aSetActionPriority[$ActionNumber] = Random($g_iMinimumPriority, 100, 1)
	Else
		$g_aSetActionPriority[$ActionNumber] = 0
	EndIf
EndFunc   ;==>SetActionPriority

Func MatchPriorityNValue($ActionNumber)
	Switch $g_iacmbPriority[$ActionNumber]
		Case 1
			$g_iMinimumPriority = 0
		Case 2
			$g_iMinimumPriority = 30
		Case 3
			$g_iMinimumPriority = 70
		Case 4
			$g_iMinimumPriority = 90
		Case 5
			$g_iMinimumPriority = 98
	EndSwitch
EndFunc   ;==>MatchPriorityNValue

Func WaitForReplayWindow()
	SetLog("Waiting For Replay Screen...", $COLOR_ACTION)
	Local $CheckStep = 0
	While Not IsReplayWindow() And $CheckStep < 30
		If _Sleep(1000) Then Return
		$CheckStep += 1
	WEnd
	Return $g_bOnReplayWindow
EndFunc   ;==>WaitForReplayWindow

Func IsReplayWindow()
	$g_bOnReplayWindow = _ColorCheck(_GetPixelColor(799, 559 + $g_iBottomOffsetY, True), "FF5151", 20)
	Return $g_bOnReplayWindow
EndFunc   ;==>IsReplayWindow

Func GetReplayDuration($g_iReplayToPause) ; will work with this but can update to make time exact.
	Local $LoteryMaxSpeedrandom2 = Random(1, 4, 1)
	Switch $LoteryMaxSpeedrandom2
		Case 1
			Global $MaxSpeedrandom2 = 1
		Case 2
			Global $MaxSpeedrandom2 = 2
		Case 3, 4
			Global $MaxSpeedrandom2 = 4
	EndSwitch
	Local $MaxSpeed = $g_iacmbMaxSpeed[$g_iReplayToPause]
	If $MaxSpeed = 3 Then
		Switch $MaxSpeedrandom2
			Case 4
				$MaxSpeed = 2
			Case 2
				$MaxSpeed = 1
			Case 1
				$MaxSpeed = 0
		EndSwitch
	ElseIf $MaxSpeed < 3 Then
		$MaxSpeed = $g_iacmbMaxSpeed[$g_iReplayToPause]
	EndIf
	Local $bResult = QuickMIS("N1", $g_sImgHumanizationDuration, 375, 535 + $g_iBottomOffsetY, 430, 570 + $g_iBottomOffsetY)
	If $bResult = "OneMinute" Then
		$g_aReplayDuration[0] = 1
		$g_aReplayDuration[1] = 90000
	ElseIf $bResult = "TwoMinutes" Then
		$g_aReplayDuration[0] = 2
		$g_aReplayDuration[1] = 150000
	ElseIf $bResult = "ThreeMinutes" Then
		$g_aReplayDuration[0] = 3
		$g_aReplayDuration[1] = 180000
	Else
		$g_aReplayDuration[0] = 0
		$g_aReplayDuration[1] = 45000
	EndIf
	Switch $MaxSpeed
		Case 1
			$g_aReplayDuration[1] /= 2
		Case 2
			$g_aReplayDuration[1] /= 4
	EndSwitch
	SetLog("Estimated Replay Duration : " & $g_aReplayDuration[1] / 1000 & " second(s)", $COLOR_INFO)
EndFunc   ;==>GetReplayDuration

Func AccelerateReplay($g_iReplayToPause)
	Local $CurrentSpeed = 0
	Local $MaxSpeed = $g_iacmbMaxSpeed[$g_iReplayToPause]
	If $MaxSpeed = 3 Then
		Switch $MaxSpeedrandom2
			Case 4
				$MaxSpeed = 2
			Case 2
				$MaxSpeed = 1
			Case 1
				$MaxSpeed = 0
		EndSwitch
		SetLog("Replay Speed : " & $MaxSpeedrandom2 & "X", $COLOR_OLIVE)
	ElseIf $MaxSpeed < 3 Then
		$MaxSpeed = $g_iacmbMaxSpeed[$g_iReplayToPause]
		Local $ReplaySpeed = 0
		Switch $MaxSpeed
			Case 2
				$ReplaySpeed = 4
			Case 1
				$ReplaySpeed = 2
			Case 0
				$ReplaySpeed = 1
		EndSwitch
		SetLog("Replay Speed : " & $ReplaySpeed & "X", $COLOR_OLIVE)
	EndIf
	If $CurrentSpeed <> $MaxSpeed Then SetLog("Let's Make The Replay Faster ...", $COLOR_OLIVE)
	While $CurrentSpeed < $MaxSpeed
		Click(820, 630 + $g_iBottomOffsetY) ; click on the speed button
		If _Sleep(500) Then Return
		$CurrentSpeed += 1
	WEnd
EndFunc   ;==>AccelerateReplay

Func DoAPauseDuringReplay($g_iReplayToPause)
	Local $MinimumToPause = 0, $PauseScore = 0
	Local $Pause = $g_iacmbPause
	If $Pause <> 0 Then
		Switch $Pause
			Case 1
				$MinimumToPause = 80
			Case 2
				$MinimumToPause = 60
			Case 3
				$MinimumToPause = 40
			Case 4
				$MinimumToPause = 20
		EndSwitch
		$PauseScore = Random(0, 100, 1)
		If $PauseScore > $MinimumToPause Then
			SetLog("Let's Do a Small Pause To See What Happens ...", $COLOR_OLIVE)
			Click(750, 630 + $g_iBottomOffsetY) ; click pause button
			If _Sleep(Random(1000, 2500, 1)) Then Return
			SetLog("Pause Finished, Let's Relaunch Replay!", $COLOR_OLIVE)
			Click(750, 630 + $g_iBottomOffsetY) ; click play button
		EndIf
	EndIf
EndFunc   ;==>DoAPauseDuringReplay

Func VisitAPlayer()
	SetLog("Let's Visit a Player ...", $COLOR_INFO)
	If QuickMIS("BC1", $g_sImgHumanizationVisit) Then
		Click($g_iQuickMISX, $g_iQuickMISY)
		If _Sleep(Random(4500, 6000, 1)) Then Return

		If Random(0, 2, 1) < 2 Then
			If QuickMIS("BC1", $g_sImgPlayerProfil, 60, 10, 250, 40) Then
				SetLog("Check His Profil", $COLOR_OLIVE)
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(2000) Then Return

				Local $yCoordOffset = 0
				If QuickMIS("BC1", $g_sImgLegend, 280, 470 + $g_iMidOffsetY, 580, 520 + $g_iMidOffsetY) Then
					$yCoordOffset = 100
					If _Sleep(250) Then Return
				EndIf

				Local $x = Random(260, 670, 1)
				Local $yStart = Random(495 + $yCoordOffset, 505 + $yCoordOffset, 1)
				Local $yEnd = Random(200, 210, 1)

				ClickDrag($x, $yStart, $x, $yEnd)
				If _Sleep(Random(5000, 7000)) Then Return
				If Not $g_bRunState Then Return
				$x = Random(260, 670, 1)
				$yStart = Random(590, 610, 1)
				$yEnd = Random(235, 245, 1)
				ClickDrag($x, $yStart, $x, $yEnd)
				If _Sleep(Random(5000, 7000)) Then Return
				If Not $g_bRunState Then Return

				Local $xVillage = Random(0, 2, 1)
				Switch $xVillage
					Case 1
						SetLog("Go To Builder Base Tab", $COLOR_BLUE)
						Click(430, 155 + $g_iMidOffsetY)
						If _Sleep(Random(4000, 7000)) Then Return
						If QuickMIS("BC1", $g_sImgLegend, 280, 470 + $g_iMidOffsetY, 580, 520 + $g_iMidOffsetY) Then
							$yCoordOffset = 100
							If _Sleep(250) Then Return
						EndIf
						Local $x = Random(260, 670, 1)
						Local $yStart = Random(495 + $yCoordOffset, 505 + $yCoordOffset, 1)
						Local $yEnd = Random(200, 210, 1)

						ClickDrag($x, $yStart, $x, $yEnd)
						If _Sleep(Random(5000, 7000)) Then Return
						If Not $g_bRunState Then Return
					Case 2
						SetLog("Go To Clan Capital Tab", $COLOR_BLUE)
						Click(690, 155 + $g_iMidOffsetY)
						If _Sleep(Random(4000, 7000)) Then Return
						$x = Random(260, 670, 1)
						$yStart = Random(550, 580, 1)
						$yEnd = Random(350, 370, 1)

						ClickDrag($x, $yStart, $x, $yEnd)
						If _Sleep(Random(5000, 7000)) Then Return
						If Not $g_bRunState Then Return
				EndSwitch
				CloseWindow()
			EndIf
		EndIf

		Local $aRndFuncList = ['CheckMortar', 'CheckWizard', 'CheckXBows', 'CheckInferno', 'CheckEagle', 'Scatter', 'CheckAirDefense', 'GoldStorage', 'ElixirStorage', 'THALL', 'Monolith', 'MultiArcher', 'Ricochet']
		_ArrayShuffle($aRndFuncList)

		Local $trimmed = 12 - Random(7, 10, 1)
		SetLog("Bot Will Check " & $trimmed & " Types of Buildings", $COLOR_SUCCESS1)
		For $i = 0 To (12 - $trimmed)
			Local $sRange = 12 - $i
			_ArrayDelete($aRndFuncList, $sRange)
		Next

		For $Index In $aRndFuncList
			If Not $g_bRunState Then Return
			RunFunctionCheckBuildings($Index)
		Next
	Else
		SetLog("Error When Trying to Find Visit Button ... Skipping ...", $COLOR_WARNING)
		CloseWindow()
		If _Sleep(500) Then Return
		If Not ClickB("ClanChat") Then
			SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
			Return
		EndIf
	EndIf
EndFunc   ;==>VisitAPlayer

Func RunFunctionCheckBuildings($action)
	Switch $action
		Case "CheckMortar"
			CheckMortar()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "CheckWizard"
			CheckWizard()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "CheckXBows"
			CheckXBows()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "CheckInferno"
			CheckInferno()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "CheckEagle"
			CheckEagle()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "Scatter"
			CheckScatter()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "CheckAirDefense"
			CheckAirDefense()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "GoldStorage"
			GoldStorage()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "ElixirStorage"
			ElixirStorage()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "THALL"
			CheckTH()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "Monolith"
			Monolith()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "MultiArcher"
			MultiArcher()
			If _Sleep($DELAYRUNBOT3) Then Return
		Case "Ricochet"
			Ricochet()
			If _Sleep($DELAYRUNBOT3) Then Return
	EndSwitch
EndFunc   ;==>RunFunctionCheckBuildings

Func CheckTH()
	imglocTHSearch(False, False, True)
	If IsArray($IMGLOCTHLOCATION) And UBound($IMGLOCTHLOCATION) > 0 Then
		SetLog("We Will Click On TH...", $COLOR_OLIVE)
	Else
		SetLog("No TH Detected", $COLOR_DEBUG)
		Return
	EndIf

	PureClickVisit($g_iTHx, $g_iTHy)
	If _Sleep(800) Then Return
	Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
	If Not StringInStr($BuildingNameFull, "Town") Then
		SetLog("Oups ! Wrong click", $COLOR_ACTION)
		ClearScreen("Right")
		Return
	EndIf
	Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
	SetLog("TH Level " & $aResult[2], $COLOR_NAVY)
	If _Sleep(1500) Then Return
	If ClickB("Info") Then
		SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
		If _Sleep(Random(4000, 6000, 1)) Then Return
	Else
		SetLog("Info Button Not Found", $COLOR_DEBUG)
		ClearScreen("Right")
		Return
	EndIf

	For $t = 1 To 3
		If QuickMIS("BC1", $3DotsVisiting, 780, 450 + $g_iMidOffsetY, 820, 485 + $g_iMidOffsetY) And Random(0, 5, 1) < 2 Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(Random(2500, 3500, 1)) Then Return
		EndIf
	Next
	CloseWindow(False, False, False, True)
	If Not $g_bRunState Then Return

	If _Sleep(Random(2000, 3000, 1)) Then Return
EndFunc   ;==>CheckTH

Func CheckMortar()
	GetLocationBuilding($eBldgMortar, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Mortar Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = 0

	If $aNumResultBuildingDetect > 2 Then
		$RandomNumBuildingTocheck = Random(1, 2, 1)
	Else
		$RandomNumBuildingTocheck = 1
	EndIf

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Mortar", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Mortars", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $MortarCoord[2] = [0, 0]
			If $j = 1 Then
				$MortarCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $MortarCoord[0]
			EndIf
			If $j = 2 Then
				$MortarCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $MortarCoord[1]
			EndIf
		Next
		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On Mortar " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "Mortar") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("Mortar Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf

			For $t = 1 To 3
				If QuickMIS("BC1", $3DotsVisiting, 780, 450 + $g_iMidOffsetY, 820, 485 + $g_iMidOffsetY) And Random(0, 5, 1) < 2 Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If _Sleep(Random(2500, 3500, 1)) Then Return
				EndIf
			Next
			CloseWindow(False, False, False, True)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>CheckMortar

Func CheckWizard()
	GetLocationBuilding($eBldgWizTower, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Wizard Tower Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = 0

	If $aNumResultBuildingDetect > 2 Then
		$RandomNumBuildingTocheck = Random(1, 2, 1)
	Else
		$RandomNumBuildingTocheck = 1
	EndIf

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Wizard Tower", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Wizard Towers", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $WizardCoord[2] = [0, 0]
			If $j = 1 Then
				$WizardCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $WizardCoord[0]
			EndIf
			If $j = 2 Then
				$WizardCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $WizardCoord[1]
			EndIf
		Next

		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On Wizard Tower " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "Wizard") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("Wizard Tower Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			CloseWindow(False, False, False, True)
			If _Sleep(Random(2000, 3000, 1)) Then Return
			If Not $g_bRunState Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>CheckWizard

Func CheckXBows()
	GetLocationBuilding($eBldgXBow, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No X-Bow Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = 0

	If $aNumResultBuildingDetect > 2 Then
		$RandomNumBuildingTocheck = Random(1, 2, 1)
	Else
		$RandomNumBuildingTocheck = 1
	EndIf

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " XBow", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " XBows", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $XBowCoord[2] = [0, 0]
			If $j = 1 Then
				$XBowCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $XBowCoord[0]
			EndIf
			If $j = 2 Then
				$XBowCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $XBowCoord[1]
			EndIf
		Next
		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On X-Bow " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo + 9, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "Bow") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("X-Bow Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf

			For $t = 1 To 3
				If QuickMIS("BC1", $3DotsVisiting, 780, 450 + $g_iMidOffsetY, 820, 485 + $g_iMidOffsetY) And Random(0, 5, 1) < 2 Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If _Sleep(Random(2500, 3500, 1)) Then Return
				EndIf
			Next
			CloseWindow(False, False, False, True)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>CheckXBows

Func CheckInferno()
	GetLocationBuilding($eBldgInferno, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Inferno Tower Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = Random(1, 2, 1)
	If $RandomNumBuildingTocheck > $aNumResultBuildingDetect Then $RandomNumBuildingTocheck = $aNumResultBuildingDetect

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Inferno Tower", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Inferno Towers", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $InfernoCoord[2] = [0, 0]
			If $j = 1 Then
				$InfernoCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $InfernoCoord[0]
			EndIf
			If $j = 2 Then
				$InfernoCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $InfernoCoord[1]
			EndIf
		Next
		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On Inferno Tower " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "nferno") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("Inferno Tower Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf

			For $t = 1 To 3
				If QuickMIS("BC1", $3DotsVisiting, 780, 450 + $g_iMidOffsetY, 820, 485 + $g_iMidOffsetY) And Random(0, 5, 1) < 2 Then
					Click($g_iQuickMISX, $g_iQuickMISY)
					If _Sleep(Random(2500, 3500, 1)) Then Return
				EndIf
			Next
			CloseWindow(False, False, False, True)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>CheckInferno

Func CheckEagle()
	GetLocationBuilding($eBldgEagle, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Eagle Artillery Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0

	Local $aIndXY = StringSplit($aResultBuildingDetect, ",")
	$xInfo = $aIndXY[1]
	$yInfo = $aIndXY[2]

	SetLog("We Will Click On Eagle Artillery...", $COLOR_OLIVE)
	PureClickVisit($xInfo, $yInfo)
	If _Sleep(800) Then Return
	Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
	If Not StringInStr($BuildingNameFull, "Eagle") Then
		SetLog("Oups ! Wrong click", $COLOR_ACTION)
		ClearScreen("Right")
		Return
	EndIf
	Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
	SetLog("Eagle Artillery Level " & $aResult[2], $COLOR_NAVY)
	If _Sleep(1500) Then Return
	If ClickB("Info") Then
		SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
		If _Sleep(Random(4000, 6000, 1)) Then Return
	Else
		SetLog("Info Button Not Found", $COLOR_DEBUG)
		ClearScreen("Right")
		Return
	EndIf
	CloseWindow(False, False, False, True)
	If Not $g_bRunState Then Return

	If _Sleep(Random(2000, 3000, 1)) Then Return
EndFunc   ;==>CheckEagle

Func CheckScatter()
	GetLocationBuilding($eBldgScatter, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No ScatterShot Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = Random(1, 2, 1)
	If $RandomNumBuildingTocheck > $aNumResultBuildingDetect Then $RandomNumBuildingTocheck = $aNumResultBuildingDetect

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Scatter Shot", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Scatters Shot", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $ScatterCoord[2] = [0, 0]
			If $j = 1 Then
				$ScatterCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $ScatterCoord[0]
			EndIf
			If $j = 2 Then
				$ScatterCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $ScatterCoord[1]
			EndIf
		Next
		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On ScatterShot " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "Scatte") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("ScatterShot Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			CloseWindow(False, False, False, True)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>CheckScatter

Func CheckAirDefense()
	GetLocationBuilding($eBldgAirDefense, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Air Defense Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = 0

	If $aNumResultBuildingDetect > 2 Then
		$RandomNumBuildingTocheck = Random(1, 2, 1)
	Else
		$RandomNumBuildingTocheck = 1
	EndIf

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Air Defense", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Air Defenses", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $AirDefenseCoord[2] = [0, 0]
			If $j = 1 Then
				$AirDefenseCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $AirDefenseCoord[0]
			EndIf
			If $j = 2 Then
				$AirDefenseCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $AirDefenseCoord[1]
			EndIf
		Next
		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On Air Defense " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "Defense") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("Air Defense Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			CloseWindow(False, False, False, True)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>CheckAirDefense

Func GoldStorage()
	GetLocationBuilding($eBldgGoldS, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Gold Storage Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = 0

	If $aNumResultBuildingDetect > 2 Then
		$RandomNumBuildingTocheck = Random(1, 2, 1)
	Else
		$RandomNumBuildingTocheck = 1
	EndIf

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Gold Storage", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Gold Storages", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $GoldSCoord[2] = [0, 0]
			If $j = 1 Then
				$GoldSCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $GoldSCoord[0]
			EndIf
			If $j = 2 Then
				$GoldSCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $GoldSCoord[1]
			EndIf
		Next
		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On Gold Storage " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "Gold") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("Gold Storage Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			CloseWindow(False, False, False, True)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>GoldStorage

Func ElixirStorage()
	GetLocationBuilding($eBldgElixirS, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Elixir Storage Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0
	Local $aInd = StringSplit($aResultBuildingDetect, "|")
	Local $RandomNumBuildingTocheck = 0

	If $aNumResultBuildingDetect > 2 Then
		$RandomNumBuildingTocheck = Random(1, 2, 1)
	Else
		$RandomNumBuildingTocheck = 1
	EndIf

	Local $count = 1
	If $RandomNumBuildingTocheck = 1 Then
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Elixir Storage", $COLOR_DEBUG1)
	Else
		SetLog("Bot Will Check " & $RandomNumBuildingTocheck & " Elixir Storages", $COLOR_DEBUG1)
	EndIf
	For $i = 1 To $aInd[0]
		Local $aIndXY = StringSplit($aInd[$i], ",")
		For $j = 1 To $aIndXY[0]
			Local $ElixirSCoord[2] = [0, 0]
			If $j = 1 Then
				$ElixirSCoord[0] = $aIndXY[$j]
				If $i = $count Then $xInfo = $ElixirSCoord[0]
			EndIf
			If $j = 2 Then
				$ElixirSCoord[1] = $aIndXY[$j]
				If $i = $count Then $yInfo = $ElixirSCoord[1]
			EndIf
		Next
		If $count <= $RandomNumBuildingTocheck Then
			SetLog("We Will Click On Elixir Storage " & $count & "", $COLOR_OLIVE)
			PureClickVisit($xInfo, $yInfo)
			If _Sleep(800) Then Return
			Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
			If Not StringInStr($BuildingNameFull, "Elixir") Then
				SetLog("Oups ! Wrong click", $COLOR_ACTION)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
			SetLog("Elixir Storage Level " & $aResult[2], $COLOR_NAVY)
			If _Sleep(1500) Then Return
			If ClickB("Info") Then
				SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
				If _Sleep(Random(4000, 6000, 1)) Then Return
			Else
				SetLog("Info Button Not Found", $COLOR_DEBUG)
				If _Sleep(200) Then Return
				ClearScreen("Right")
				If _Sleep(1000) Then Return
				ContinueLoop
			EndIf
			CloseWindow(False, False, False, True)
			If Not $g_bRunState Then Return
			If _Sleep(Random(2000, 3000, 1)) Then Return
			$count += 1
		Else
			ExitLoop
		EndIf
	Next
EndFunc   ;==>ElixirStorage

Func Monolith()
	GetLocationBuilding($eBldgMonolith, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Monolith Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0

	Local $aIndXY = StringSplit($aResultBuildingDetect, ",")
	$xInfo = $aIndXY[1]
	$yInfo = $aIndXY[2]

	SetLog("We Will Click On Monolith...", $COLOR_OLIVE)
	PureClickVisit($xInfo, $yInfo)
	If _Sleep(800) Then Return
	Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
	If Not StringInStr($BuildingNameFull, "Monolith") Then
		SetLog("Oups ! Wrong click", $COLOR_ACTION)
		ClearScreen("Right")
		Return
	EndIf
	Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
	SetLog("Monolith Level " & $aResult[2], $COLOR_NAVY)
	If _Sleep(1500) Then Return
	If ClickB("Info") Then
		SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
		If _Sleep(Random(4000, 6000, 1)) Then Return
	Else
		SetLog("Info Button Not Found", $COLOR_DEBUG)
		ClearScreen("Right")
		Return
	EndIf
	CloseWindow(False, False, False, True)
	If Not $g_bRunState Then Return

	If _Sleep(Random(2000, 3000, 1)) Then Return
EndFunc   ;==>Monolith

Func MultiArcher()
	GetLocationBuilding($eBldgMultiArcher, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Multi-Archer Tower Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0

	Local $aIndXY = StringSplit($aResultBuildingDetect, ",")
	$xInfo = $aIndXY[1]
	$yInfo = $aIndXY[2]

	SetLog("We Will Click On Multi-Archer Tower...", $COLOR_OLIVE)
	PureClickVisit($xInfo, $yInfo)
	If _Sleep(800) Then Return
	Local $BuildingNameFull = getOcrAndCapture("coc-build", 240, 514 + $g_iBottomOffsetY, 395, 30)
	If Not StringInStr($BuildingNameFull, "Multi-Archer") Then
		SetLog("Oups ! Wrong click", $COLOR_ACTION)
		ClearScreen("Right")
		Return
	EndIf
	Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
	SetLog("Multi-Archer Tower Level " & $aResult[2], $COLOR_NAVY)
	If _Sleep(1500) Then Return
	If ClickB("Info") Then
		SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
		If _Sleep(Random(4000, 6000, 1)) Then Return
	Else
		SetLog("Info Button Not Found", $COLOR_DEBUG)
		ClearScreen("Right")
		Return
	EndIf
	CloseWindow(False, False, False, True)
	If Not $g_bRunState Then Return

	If _Sleep(Random(2000, 3000, 1)) Then Return
EndFunc   ;==>MultiArcher

Func Ricochet()
	GetLocationBuilding($eBldgRicochet, $g_iMaxTHLevel, True)
	If $aNumResultBuildingDetect = 0 Then
		SetLog("No Ricochet Cannon Detected", $COLOR_DEBUG)
		Return
	EndIf
	Local $xInfo = 0
	Local $yInfo = 0

	Local $aIndXY = StringSplit($aResultBuildingDetect, ",")
	$xInfo = $aIndXY[1]
	$yInfo = $aIndXY[2]

	SetLog("We Will Click On Ricochet Cannon...", $COLOR_OLIVE)
	PureClickVisit($xInfo, $yInfo)
	If _Sleep(800) Then Return
	Local $BuildingNameFull = getOcrAndCapture("coc-build", 250, 514 + $g_iBottomOffsetY, 350, 30)
	If Not StringInStr($BuildingNameFull, "Ricochet") Then
		SetLog("Oups ! Wrong click", $COLOR_ACTION)
		ClearScreen("Right")
		Return
	EndIf
	Local $aResult = BuildingInfo(242, 514 + $g_iBottomOffsetY)
	SetLog("Ricochet Cannon Level " & $aResult[2], $COLOR_NAVY)
	If _Sleep(1500) Then Return
	If ClickB("Info") Then
		SetLog("... And Open His Info Window ...", $COLOR_OLIVE)
		If _Sleep(Random(4000, 6000, 1)) Then Return
	Else
		SetLog("Info Button Not Found", $COLOR_DEBUG)
		ClearScreen("Right")
		Return
	EndIf
	CloseWindow(False, False, False, True)
	If Not $g_bRunState Then Return

	If _Sleep(Random(2000, 3000, 1)) Then Return
EndFunc   ;==>Ricochet

Func DoNothing()
	SetLog("Let The Bot Wait a Little Before Continue ...", $COLOR_OLIVE)
	If _Sleep(Random(3000, 8000, 1)) Then Return
EndFunc   ;==>DoNothing

Func LookAtRedNotifications()
	SetLog("Looking For Notifications ...", $COLOR_INFO)
	Local $NoNotif = 0
	ReturnAtHome()

	If _ColorCheck(_GetPixelColor(50, 137, True), "F5151D", 20) Then
		SetLog("You Have a New Message ...", $COLOR_OLIVE)
		Click(40, 120 + $g_iMidOffsetY) ; open Messages button
		If _Sleep(Random(3000, 7000, 1)) Then Return
		CloseWindow()
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()

	If _ColorCheck(_GetPixelColor(50, 76, True), "F5151D", 20) Then
		SetLog("Let's See The Current League You Are In ...", $COLOR_OLIVE)
		Click(40, 60 + $g_iMidOffsetY) ; open Cup button
		If _Sleep(4000) Then Return
		ClickB("Okay")
		If _Sleep(500) Then Return
		CloseWindow()
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()

	Local $bRedColor_InWarButton = _PixelSearch(45, 439 + $g_iBottomOffsetY, 55, 441 + $g_iBottomOffsetY, Hex(0xF81720, 6), 20) ; Red color in war buttons*
	If IsArray($bRedColor_InWarButton) Then
		SetLog("Something To Check In War Area ...", $COLOR_OLIVE)
		If _Sleep(Random(1000, 2000, 1)) Then Return
		If QuickMIS("BC1", $ImInWar, 40, 432 + $g_iBottomOffsetY, 66, 452 + $g_iBottomOffsetY) Then
			SetLog("-----------------------------------", $COLOR_ERROR)
			SetLog("|  You Have To Fight In War ! |", $COLOR_ERROR)
			SetLog("-----------------------------------", $COLOR_ERROR)
		Else
			SetLog("--------------------------------------", $COLOR_SUCCESS1)
			SetLog("|  Relax, Nothing To Do In War ! |", $COLOR_SUCCESS1)
			SetLog("--------------------------------------", $COLOR_SUCCESS1)
		EndIf
		If _Sleep(Random(4000, 6000, 1)) Then Return
		Click(40, 495 + $g_iMidOffsetY) ; open War menu
		Local $iSleepForWindow = Random(3000, 5000, 1)
		If _Sleep($iSleepForWindow) Then Return
		Click(60 + Random(0, 700, 1), 25 + Random(0, 5, 1)) ; Click to get any window away
		Local $iSleepForWindow2 = Random(1000, 2000, 1)
		If _Sleep($iSleepForWindow2) Then Return
		ReturnHomeFromHumanization()
		If _Sleep(1500) Then Return
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()

	If _ColorCheck(_GetPixelColor(54, 278 + $g_iMidOffsetY, True), Hex(0xE90914, 6), 20) Then
		SetLog("New Messages On The Chat Room ...", $COLOR_OLIVE)
		Local $ChatNotEveryTime = Random(1, 5, 1)
		If $ChatNotEveryTime > 3 Then
			If _Sleep(1000) Then Return
			If Not ClickB("ClanChat") Then
				SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
				Return
			EndIf
			If _Sleep(3000) Then Return
			If Not ClickB("ClanChat") Then
				SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
				Return
			EndIf
			If _Sleep(1000) Then Return
		Else
			SetLog("Not Open Chat Everytime !", $COLOR_DEBUG)
		EndIf
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()

	If _ColorCheck(_GetPixelColor(695, 650 + $g_iBottomOffsetY, True), "F12529", 20) Then
		SetLog("Esport Live Detected", $COLOR_OLIVE)
		Local $EsportNotEveryTime = Random(1, 5, 1)
		If $EsportNotEveryTime = 5 Then
			SetLog("Esport Live", $COLOR_BLUE)
			Click(715, 630 + $g_iBottomOffsetY) ; open SC Messages
			If _Sleep(3000) Then Return
			SetLog("Open Esports Tab", $COLOR_DEBUG)
			Click(525, 95)
			Local $bLoop = 0
			While 1
				If $bLoop = 30 Then ExitLoop
				If WaitforPixel(700, 145 + $g_iMidOffsetY, 705, 150 + $g_iMidOffsetY, Hex(0xE8E8E0, 6), 15, 10) Then
					$bLoop += 1
					If _Sleep(500) Then Return
				Else
					ExitLoop
				EndIf
			WEnd
			Local $SideSwitchEsports = Random(1, 4, 1)
			If $bLoop = 30 Then $SideSwitchEsports = 5
			Switch $SideSwitchEsports
				Case 1
					SetLog("Scrolling Left And Right Sides", $COLOR_OLIVE)
					ScrollEsportsLeft(Random(1, 2, 1))
					If _Sleep(Random(3000, 5000, 1)) Then Return
					ScrollEsportsRight(Random(1, 2, 1))
				Case 2
					SetLog("Scrolling Right And Left Sides", $COLOR_OLIVE)
					ScrollEsportsRight(Random(1, 2, 1))
					If _Sleep(Random(3000, 5000, 1)) Then Return
					ScrollEsportsLeft(Random(1, 2, 1))
				Case 3
					SetLog("Scrolling Right Side", $COLOR_OLIVE)
					ScrollEsportsRight(Random(1, 2, 1))
				Case 4
					SetLog("Scrolling Left Side", $COLOR_OLIVE)
					ScrollEsportsLeft(Random(1, 2, 1))
				Case 5
					SetLog("Do Nothing", $COLOR_OLIVE)
					If _Sleep(500) Then Return
			EndSwitch
			If _Sleep(3000) Then Return

			If _ColorCheck(_GetPixelColor(245, 70, True), "D80818", 20) Then
				SetLog("Detection in News Tab", $COLOR_BLUE)
				SetLog("Open News Tab", $COLOR_DEBUG)
				Click(185, 85)
				If _Sleep(Random(2000, 6000, 1)) Then Return

				Local $SideSwitchNews = Random(1, 4, 1)
				Switch $SideSwitchNews
					Case 1
						SetLog("Scrolling Left And Right Sides", $COLOR_OLIVE)
						ScrollNewsLeft(Random(0, 2, 1))
						If _Sleep(Random(3000, 5000, 1)) Then Return
						ScrollNewsRight(Random(0, 2, 1))
					Case 2
						SetLog("Scrolling Right And Left Sides", $COLOR_OLIVE)
						ScrollNewsRight(Random(0, 2, 1))
						If _Sleep(Random(3000, 5000, 1)) Then Return
						ScrollNewsLeft(Random(0, 2, 1))
					Case 3
						SetLog("Scrolling Right Side", $COLOR_OLIVE)
						ScrollNewsRight(Random(0, 2, 1))
					Case 4
						SetLog("Scrolling Left Side", $COLOR_OLIVE)
						ScrollNewsLeft(Random(0, 2, 1))
				EndSwitch

				If _Sleep(Random(2000, 5000, 1)) Then Return
				CloseWindow()
			EndIf
		Else
			SetLog("Not Visit Esport Everytime !", $COLOR_DEBUG)
		EndIf
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()

	If _ColorCheck(_GetPixelColor(224, 612 + $g_iBottomOffsetY, True), Hex(0xF81620, 6), 20) Then
		SetLog("Open News Tab", $COLOR_DEBUG)
		Click(212, 635 + $g_iBottomOffsetY) ; open events tab
		If _Sleep(Random(2000, 4000, 1)) Then Return
		Local $NeedScroll = Random(0, 3, 1)
		If $NeedScroll > 0 Then
			If _ColorCheck(_GetPixelColor(750, 585 + $g_iMidOffsetY, True), Hex(0xE8E8E0, 6), 20) Then
				SetLog("Just Wait in Events Tab", $COLOR_OLIVE)
			Else
				SetLog("Scroll Events Tab", $COLOR_OLIVE)
				ScrollEvents(Random(0, 1, 1))
			EndIf
		Else
			SetLog("Just Wait in Events Tab", $COLOR_OLIVE)
		EndIf
		If _Sleep(Random(2000, 6000, 1)) Then Return
		CloseWindow()
	Else
		$NoNotif += 1
	EndIf

	If _ColorCheck(_GetPixelColor(722, 614 + $g_iBottomOffsetY, True), Hex(0xF01522, 6), 20) Then
		SetLog("New Messages Or Events From SC To Read ...", $COLOR_OLIVE)
		Click(715, 630 + $g_iBottomOffsetY) ; open events
		If _Sleep(3000) Then Return

		If Not _ColorCheck(_GetPixelColor(240, 75 + $g_iMidOffsetY, True), Hex(0xE8E8E0, 6), 20) Then ; check if we are Not on news tab
			Click(195, 95) ; open news tab
			If _Sleep(Random(2000, 4000, 1)) Then Return
		EndIf

		Local $TabtoClick = Random(0, 2, 1)
		If _ColorCheck(_GetPixelColor(261, 75, True), Hex(0xEC0A13, 6), 20) Then
			$TabtoClick = 0
			SetLog("Detection in News Tab", $COLOR_OLIVE)
		ElseIf _ColorCheck(_GetPixelColor(596, 75, True), Hex(0xEC0A13, 6), 20) Then
			$TabtoClick = 2
			SetLog("Detection in Esports Tab", $COLOR_OLIVE)
		EndIf
		Switch $TabtoClick
			Case 0
				SetLog("Stay On News Tab", $COLOR_OLIVE)
				If _Sleep(Random(2000, 6000, 1)) Then Return
			Case 1
				SetLog("Open Community Tab", $COLOR_OLIVE)
				Click(360, 95)
				If _Sleep(Random(3000, 8000, 1)) Then Return
			Case 2
				SetLog("Open Esports Tab", $COLOR_DEBUG)
				Click(525, 95)
				Local $bLoop = 0
				While 1
					If $bLoop = 30 Then ExitLoop
					If WaitforPixel(700, 145 + $g_iMidOffsetY, 705, 150 + $g_iMidOffsetY, Hex(0xE8E8E0, 6), 15, 10) Then
						$bLoop += 1
						If _Sleep(500) Then Return
					Else
						ExitLoop
					EndIf
				WEnd
				Local $SideSwitchEsports = Random(1, 5, 1)
				Switch $SideSwitchEsports
					Case 1
						SetLog("Scrolling Left And Right Sides", $COLOR_OLIVE)
						ScrollEsportsLeft(Random(1, 2, 1))
						If _Sleep(Random(3000, 5000, 1)) Then Return
						ScrollEsportsRight(Random(1, 2, 1))
					Case 2
						SetLog("Scrolling Right And Left Sides", $COLOR_OLIVE)
						ScrollEsportsRight(Random(1, 2, 1))
						If _Sleep(Random(3000, 5000, 1)) Then Return
						ScrollEsportsLeft(Random(1, 2, 1))
					Case 3
						SetLog("Scrolling Right Side", $COLOR_OLIVE)
						ScrollEsportsRight(Random(1, 2, 1))
					Case 4
						SetLog("Scrolling Left Side", $COLOR_OLIVE)
						ScrollEsportsLeft(Random(1, 2, 1))
					Case 5
						SetLog("Do Nothing On Esports Tab", $COLOR_OLIVE)
						If _Sleep(Random(3000, 8000, 1)) Then Return
				EndSwitch
				If _Sleep(3000) Then Return
		EndSwitch

		If _Sleep(Random(2000, 5000, 1)) Then Return
		CloseWindow()
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()

	If _ColorCheck(_GetPixelColor(832, 578 + $g_iBottomOffsetY, True), "753D82", 20) Or _ColorCheck(_GetPixelColor(832, 577 + $g_iBottomOffsetY, True), "7A3D85", 20) Then
		SetLog("There Is Something New On The Shop ...", $COLOR_OLIVE)
		Local $ShopNotEveryTime = Random(1, 10, 1)
		If $ShopNotEveryTime > 8 Then
			Local $ShopCoordsX[2] = [775, 825]
			Local $ShopCoordsY[2] = [585 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
			Local $ShopButtonClickX = Random($ShopCoordsX[0], $ShopCoordsX[1], 1)
			Local $ShopButtonClickY = Random($ShopCoordsY[0], $ShopCoordsY[1], 1)
			Click($ShopButtonClickX, $ShopButtonClickY, 1, 170, "Shop") ; open Shop
			If _Sleep(Random(3000, 5000, 1)) Then Return
			Local $NeedScroll = Random(0, 2, 1)
			Local $NeedScroll2 = Random(0, 1, 1)
			If $NeedScroll >= 1 Then
				Local $xStart = Random(650, 800, 1)
				Local $xEnd = Random($xStart - 600, $xStart - 520, 1)
				Local $y = Random(160 + $g_iMidOffsetY, 580 + $g_iMidOffsetY, 1)
				ClickDrag($xStart, $y, $xEnd, $y) ; scroll the shop
			EndIf
			If $NeedScroll2 = 1 And $NeedScroll >= 1 Then
				If _Sleep(Random(2000, 3000, 1)) Then Return
				Local $xStart = Random(130, 350, 1)
				Local $xEnd = Random($xStart + 380, $xStart + 450, 1)
				Local $y = Random(160 + $g_iMidOffsetY, 580 + $g_iMidOffsetY, 1)
				ClickDrag($xStart, $y, $xEnd, $y)     ; scroll the shop
			EndIf
			If _Sleep(2000) Then Return
			CloseWindow()
		Else
			SetLog("Not Visit Shop Everytime !", $COLOR_DEBUG)
		EndIf
	Else
		$NoNotif += 1
	EndIf
	ReturnAtHome()
	If _ColorCheck(_GetPixelColor(51, 16, True), "F51621", 20) Then
		SetLog("Maybe You Have a New Friend Request, Let Me Check ...", $COLOR_OLIVE)
		Click(40, 40) ; open profile
		If _Sleep(2000) Then Return
		If Not $g_bRunState Then Return
		If IsClanOverview() Then
			If _ColorCheck(_GetPixelColor(757, 81 + $g_iMidOffsetY, True), Hex(0xEC0A12, 6), 20) Then
				Click(690, 100 + $g_iMidOffsetY)
				If Not $g_bRunState Then Return
				If _Sleep(2000) Then Return
				If _ColorCheck(_GetPixelColor(541, 146 + $g_iMidOffsetY, True), Hex(0xF71621, 6), 20) Then SetLog("It's Confirmed, You Have a New Friend Request, Let Me Check ...", $COLOR_SUCCESS1)
				If Not $g_iIsRefusedFriends Then
					While 1
						If QuickMIS("BC1", $g_sImgHumanizationFriend, 695, 200 + $g_iMidOffsetY, 755, 245 + $g_iMidOffsetY) Then
							SetLog("Accept Friend Request", $COLOR_ACTION)
							Click($g_iQuickMISX - 8, $g_iQuickMISY - 7)
							If _Sleep(1000) Then Return
							Local $aiOkayButton = findButton("Okay", Default, 1, True)
							If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
								PureClick($aiOkayButton[0], $aiOkayButton[1], 2, 150, "#0117") ; Click Okay Button
							Else
								SetLog("Error When Trying To Find Okay Button ... Skipping ...", $COLOR_WARNING)
								ExitLoop
							EndIf
						Else
							ExitLoop
						EndIf
						If _Sleep(1000) Then Return
					WEnd
				Else
					While 1
						If QuickMIS("BC1", $g_sImgHumanizationFriend, 695, 200 + $g_iMidOffsetY, 755, 245 + $g_iMidOffsetY) Then
							SetLog("Refuse Friend Request", $COLOR_ACTION)
							Click($g_iQuickMISX + 53, $g_iQuickMISY - 7)
							If _Sleep(1000) Then Return
							Local $aiOkayButton = findButton("Okay", Default, 1, True)
							If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
								PureClick($aiOkayButton[0], $aiOkayButton[1], 2, 150, "#0117") ; Click Okay Button
							Else
								SetLog("Error When Trying To Find Okay Button ... Skipping ...", $COLOR_WARNING)
								ExitLoop
							EndIf
						Else
							ExitLoop
						EndIf
						If _Sleep(1000) Then Return
					WEnd
				EndIf
			Else
				SetLog("No Friend Request Found ... Skipping ...", $COLOR_WARNING)
			EndIf
		Else
			SetLog("Error When Trying To Open Social Tab ... Skipping ...", $COLOR_WARNING)
		EndIf
		If _Sleep(2000) Then Return
		CloseWindow2()
	Else
		$NoNotif += 1
	EndIf
	If $NoNotif = 9 Then SetLog("No Notification Found, Nothing To Look At ...", $COLOR_OLIVE)
EndFunc   ;==>LookAtRedNotifications

Func Scroll($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $xStart = Random(430 - 20, 430 + 20, 1)
		Local $xEnd = Random(430 - 20, 430 + 20, 1)
		Local $yStart = Random(475 - 20 + $g_iMidOffsetY, 475 + 20 + $g_iMidOffsetY, 1)
		Local $yEnd = Random(200 - 20 + $g_iMidOffsetY, 200 + 20 + $g_iMidOffsetY, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd) ; generic random scroll
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>Scroll

Func ScrollList($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $xStart = Random(690 - 20, 690 + 20, 1)
		Local $xEnd = Random(690 - 20, 690 + 20, 1)
		Local $yStart = Random(580, 625, 1)
		Local $yEnd = Random(270, 320, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd) ; generic random scroll
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>ScrollList

Func ScrollNewsLeft($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $yStart = Random(150 + $g_iMidOffsetY, 470 + $g_iMidOffsetY, 1)
		Local $yEnd = Random($yStart - 20, $yStart + 20, 1)
		Local $xStart = Random(340, 380, 1)
		Local $xEnd = Random($xStart - 240, $xStart - 230, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd)
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>ScrollNewsLeft

Func ScrollNewsRight($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $xStart = Random(460, 670, 1)
		Local $xEnd = Random($xStart - 20, $xStart + 20, 1)
		Local $yStart = Random(500, 590, 1)
		Local $yEnd = Random($yStart - 300, $yStart - 200, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd)
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>ScrollNewsRight

Func ScrollEvents($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $xStart = Random(150, 530, 1)
		Local $xEnd = Random($xStart - 20, $xStart + 20, 1)
		Local $yStart = Random(450, 500, 1)
		Local $yEnd = Random($yStart - 290, $yStart - 190, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd)
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>ScrollEvents

Func ScrollCommunity($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $xStart = Random(150, 530, 1)
		Local $xEnd = Random($xStart - 20, $xStart + 20, 1)
		Local $yStart = Random(450, 500, 1)
		Local $yEnd = Random($yStart - 290, $yStart - 190, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd)
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>ScrollCommunity

Func ScrollEsportsLeft($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $yStart = Random(150 + $g_iMidOffsetY, 470 + $g_iMidOffsetY, 1)
		Local $yEnd = Random($yStart - 20, $yStart + 20, 1)
		Local $xStart = Random(340, 380, 1)
		Local $xEnd = Random($xStart - 240, $xStart - 230, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd)
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>ScrollEsportsLeft

Func ScrollEsportsRight($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $xStart = Random(460, 730, 1)
		Local $xEnd = Random($xStart - 20, $xStart + 20, 1)
		Local $yStart = Random(580, 640, 1)
		Local $yEnd = Random($yStart - 400, $yStart - 350, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd)
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>ScrollEsportsRight

Func Scroll3Tabs($MaxScroll)
	For $i = 0 To $MaxScroll
		Local $xStart = Random(150, 630, 1)
		Local $xEnd = Random($xStart - 20, $xStart + 20, 1)
		Local $yStart = Random(480, 620, 1)
		Local $yEnd = Random($yStart - 220, $yStart - 190, 1)
		ClickDrag($xStart, $yStart, $xEnd, $yEnd)
		If _Sleep(Random(3000, 4000, 1)) Then Return
		If Not $g_bRunState Then Return
	Next
EndFunc   ;==>Scroll3Tabs

Func ReturnAtHome()
	Local $CheckStep = 0
	While Not IsMainScreen() And $CheckStep <= 5
		AndroidBackButton()
		If _Sleep(3000) Then Return
		$CheckStep += 1
	WEnd
	If Not IsMainScreen() Then
		SetLog("Main Screen Not Found, Need To Restart CoC App...", $COLOR_ERROR)
		RestartAndroidCoC()
		waitMainScreen()
	EndIf
EndFunc   ;==>ReturnAtHome

Func IsMainScreen()
	;Wait for Main Screen To Be Appear
	Local $bResult = False

	If IsMainPage(2) Then
		$bResult = True
	ElseIf IsMainPageBuilderBase(2) Then
		$bResult = True
	EndIf

	Return $bResult
EndFunc   ;==>IsMainScreen

Func IsMessagesReplayWindow()
	Local $bResult = QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 75, 815, 85 + $g_iMidOffsetY) ;Wait for Replay Message Window To Be Appear
	Return $bResult
EndFunc   ;==>IsMessagesReplayWindow

Func IsDefensesTab()
	Local $bResult = _Wait4Pixel(245, 115, 0xE8E8E0, 20, 3000, "IsDefensesTab") ;Wait for Defence To Be Selected
	Return $bResult
EndFunc   ;==>IsDefensesTab

Func IsAttacksTab()
	Local $bResult = _Wait4Pixel(460, 115, 0xE8E8E0, 20, 3000, "IsAttacksTab") ;Wait for Attack To Be Selected
	Return $bResult
EndFunc   ;==>IsAttacksTab

Func IsBestPlayers()
	Local $bResult = _Wait4Pixel(530, 145, 0xE8E8E0, 20, 3000, "IsBestPlayers") ;Wait for Best Player Screen To Be Appear
	Return $bResult
EndFunc   ;==>IsBestPlayers

Func IsBestClans()
	Local $bResult = _Wait4Pixel(350, 145, 0xE8E8E0, 20, 3000, "IsBestClans") ;Wait for Best Clan Screen To Be Appear
	Return $bResult
EndFunc   ;==>IsBestClans

Func ChatOpen()
	Local $bResult = _Wait4Pixel(390, 320, 0xF3AB28, 20, 3000, "ChatOpen") ;Wait for Chat To Be Appear
	Return $bResult
EndFunc   ;==>ChatOpen

Func IsClanChat()
	Local $bResult = _Wait4Pixel(95, 20, 0xB1AC85, 20, 3000, "IsClanChat") ;Wait for Clan Chat To Be Appear
	Return $bResult
EndFunc   ;==>IsClanChat

Func IsClanOverview()
	Local $bResult = _Wait4Pixel(808, 127, 0xFFFFFF, 20, 3000, "IsClanOverview") ;Wait for Is Clan Overview To Be Appear
	Return $bResult
EndFunc   ;==>IsClanOverview

Func VisitBestPlayers()
	Click(40, 50 + $g_iMidOffsetY) ; open the cup menu
	If _Sleep(1500) Then Return
	If Not $g_bRunState Then Return

	If IsClanOverview() Then
		Click(525, 100 + $g_iMidOffsetY) ; open best players menu
		If _Sleep(3000) Then Return
		If Not $g_bRunState Then Return

		If IsBestPlayers() Then
			Local $PlayerList = Random(1, 2, 1)
			Local $bLocation = ""
			Switch $PlayerList
				Case 1
					SetLog("Let's Look At The Global List ...", $COLOR_DEBUG)
					$bLocation = "Global"
					Click(230, 160 + $g_iMidOffsetY) ; look at global list
					If _Sleep(1500) Then Return
					If Not $g_bRunState Then Return

					If Not FindMarkBestPlayer($bLocation) Then
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						ReturnHomeFromHumanization()
					EndIf

					If Not $g_bRunState Then Return
					VisitAPlayer()
					SetLog("Exiting ...", $COLOR_OLIVE)
					If _Sleep(Random(2000, 3000, 1)) Then Return
					ReturnHomeFromHumanization()
				Case 2
					SetLog("Let's Look At The Local List ...", $COLOR_DEBUG)
					Click(620, 160 + $g_iMidOffsetY) ; look at local list
					$bLocation = "Local"
					If _Sleep(1500) Then Return
					If Not $g_bRunState Then Return

					If Not FindMarkBestPlayer($bLocation) Then
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						ReturnHomeFromHumanization()
					EndIf

					If Not $g_bRunState Then Return
					VisitAPlayer()
					SetLog("Exiting ...", $COLOR_OLIVE)
					If _Sleep(Random(2000, 3000, 1)) Then Return
					ReturnHomeFromHumanization()
			EndSwitch
		Else
			SetLog("Error When Trying To Open Best Players Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying To Open League Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>VisitBestPlayers

Func LookAtBestClans()
	Click(40, 50 + $g_iMidOffsetY) ; open the cup menu
	If _Sleep(1500) Then Return

	If IsClanOverview() Then
		Local $BestClanWarLog = Random(1, 2, 1)
		Local $BestClanMembers = Random(1, 6, 1)
		Local $TopClansAll = Random(0, 10, 1)
		Local $ClanFilter = Random(1, 6, 1)
		Local $IsClanWarLeagueSelected = False
		Local $bLocation = ""

		If $TopClansAll > 2 Then
			SetLog("Let's Look At Top Clans Tab ...", $COLOR_BLUE)
			Click(350, 105 + $g_iMidOffsetY) ; open best clans menu
			If _Sleep(3000) Then Return
			$IsClanWarLeagueSelected = False
		Else
			SetLog("Let's Look At Clan War League Tab ...", $COLOR_BLUE)
			Click(690, 105 + $g_iMidOffsetY) ; open Clan War League menu
			If _Sleep(3000) Then Return
			$IsClanWarLeagueSelected = True
		EndIf

		If IsBestClans() And $IsClanWarLeagueSelected = False Then
			Local $PlayerList = Random(1, 2, 1)
			Switch $PlayerList
				Case 1
					SetLog("Let's Look At The Global List ...", $COLOR_DEBUG)
					$bLocation = "Global"
					Click(250, 160 + $g_iMidOffsetY) ; look at global list
					SetLog("Choose Random Clan ...", $COLOR_OLIVE)
					If _Sleep(1500) Then Return
				Case 2
					SetLog("Let's Look At The International List ...", $COLOR_DEBUG)
					$bLocation = "International"
					Click(620, 160 + $g_iMidOffsetY) ; look at local list
					SetLog("Choose Random Clan ...", $COLOR_OLIVE)
					If _Sleep(1500) Then Return
			EndSwitch

			If Not FindMarkBestClan($bLocation) Then
				SetLog("Exiting ...", $COLOR_OLIVE)
				If _Sleep(Random(2000, 3000, 1)) Then Return
				ReturnHomeFromHumanization()
			EndIf

			ClanStats()

			If QuickMIS("BC1", $g_sImgHumanizationWarLog) Then

				Switch $BestClanWarLog
					Case 1
						SetLog("We Have Found a War Clan Log Button, Let's Look At It ...", $COLOR_OLIVE)
						Click($g_iQuickMISX, $g_iQuickMISY) ; open war log
						If Not $g_bRunState Then Return
						If _Sleep(Random(2000, 3000, 1)) Then Return
						SetLog("Let's Look At The Classic Clan War Log ...", $COLOR_OLIVE)
						Click(230, 155 + $g_iMidOffsetY) ; click Classic War tab
						SetLog("Let's Scrolling The Log ...", $COLOR_OLIVE)
						If _Sleep(1500) Then Return
						Scroll(Random(0, 5, 1)) ; scroll the war log
					Case 2
						SetLog("We Have Found a War Clan Log Button, Let's Look At It ...", $COLOR_OLIVE)
						Click($g_iQuickMISX, $g_iQuickMISY) ; open war log
						If Not $g_bRunState Then Return
						If _Sleep(Random(2000, 3000, 1)) Then Return
						SetLog("Let's Look At The Clan War League Log ...", $COLOR_OLIVE)
						Click(620, 155 + $g_iMidOffsetY) ; click Clan War League tab
						SetLog("Let's Scrolling The Log ...", $COLOR_OLIVE)
						If _Sleep(1500) Then Return
						Scroll(Random(0, 2, 1)) ; scroll the war log
				EndSwitch

				SetLog("Exiting ...", $COLOR_OLIVE)
				If _Sleep(Random(2000, 3000, 1)) Then Return
				CloseWindow()
			Else
				SetLog("No War Log Found...", $COLOR_WARNING)

				If $ClanFilter <= 2 Then
					SetLog("Let's Use The Clan Filter", $COLOR_OLIVE)
					If QuickMIS("BC1", $g_sImgClanFilter, 380, 410 + $g_iMidOffsetY, 510, 540 + $g_iMidOffsetY) Then
						ClickClanFilter(Random(1, 5, 1), $g_iQuickMISX, $g_iQuickMISY)
					EndIf
				EndIf

				Switch $BestClanMembers
					Case 1
						SetLog("Let's Scrolling The Clan Members In Home Village Mode...", $COLOR_OLIVE)
						Scroll(Random(2, 6, 1)) ; scroll the Members list
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						CloseWindow()
					Case 2
						SetLog("Let's Scrolling The Clan Members In Builder Base Mode ...", $COLOR_OLIVE)
						_Sleep(1500)
						Click(430, 155 + $g_iMidOffsetY)
						If _Sleep(1500) Then Return
						Scroll(Random(2, 6, 1)) ; scroll the Members list
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						CloseWindow()
					Case 3
						SetLog("Let's Scrolling The Clan Members In Clan Capital Mode ...", $COLOR_OLIVE)
						_Sleep(1500)
						Click(690, 155 + $g_iMidOffsetY)
						If _Sleep(1500) Then Return
						Scroll(Random(2, 6, 1)) ; scroll the Members list
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						CloseWindow()
					Case 4
						SetLog("Let's Visit a Random Player ...", $COLOR_OLIVE)
						If _Sleep(1500) Then Return
						If Not FindMark() Then
							SetLog("Exiting ...", $COLOR_OLIVE)
							If _Sleep(Random(2000, 3000, 1)) Then Return
							ReturnHomeFromHumanization()
						EndIf
						VisitAPlayer()
						If _Sleep(1500) Then Return
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						ReturnHomeFromHumanization()
					Case 5
						SetLog("Let's exit for this time ...", $COLOR_OLIVE)
						If _Sleep(Random(1000, 5000, 1)) Then Return
						CloseWindow()
					Case 6
						SetLog("Let's Scrolling Clan Members And Visit Random Player...", $COLOR_OLIVE)
						If _Sleep(1000) Then Return
						Scroll(Random(1, 3, 1)) ; scroll the log
						If Not FindMark("HomeVillage", False) Then
							SetLog("Exiting ...", $COLOR_OLIVE)
							If _Sleep(Random(2000, 3000, 1)) Then Return
							ReturnHomeFromHumanization()
						EndIf
						VisitAPlayer()
						If _Sleep(1500) Then Return
						SetLog("Exiting ...", $COLOR_OLIVE)
						If _Sleep(Random(2000, 3000, 1)) Then Return
						ReturnHomeFromHumanization()
				EndSwitch
			EndIf

		ElseIf $IsClanWarLeagueSelected = True Then
			Scroll(Random(1, 6, 1))     ; scroll the log
			SetLog("Exiting ...", $COLOR_OLIVE)
			CloseWindow()
		Else
			SetLog("Error When Trying To Open Best Clans Menu ... Skipping ...", $COLOR_WARNING)
		EndIf
	Else
		SetLog("Error When Trying Clans Menu ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>LookAtBestClans

Func ReadClanChat()
	If _Sleep(1000) Then Return
	If Not ClickB("ClanChat") Then
		SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
		Return
	EndIf
	If _Sleep(3000) Then Return

	If ChatOpen() Then
		Local $MaxScroll = Random(0, 4, 1)
		SetLog("Let's Scrolling The Chat ...", $COLOR_OLIVE)
		For $i = 0 To $MaxScroll
			Local $xStart = Random(170 - 20, 170 + 20, 1)
			Local $xEnd = Random(170 - 20, 170 + 20, 1)
			Local $yStart = Random(110 - 10, 110 + 10, 1)
			Local $yEnd = Random(570 - 10, 570 + 10, 1)
			ClickDrag($xStart, $yStart, $xEnd, $yEnd) ; scroll the chat
			If _Sleep(Random(1000, 3000)) Then Return
		Next
		If _Sleep(1000) Then Return
		If Not ClickB("ChatDown") Then
			SetDebugLog("No Chat Down Button", $COLOR_DEBUG)
		EndIf
		SetLog("Exiting ...", $COLOR_OLIVE)
		If _Sleep(Random(2000, 3000, 1)) Then Return
		If Not ClickB("ClanChat") Then
			SetLog("Error finding the Clan Tab Button", $COLOR_ERROR)
			Return
		EndIf
	Else
		SetLog("Error When Trying To Open Chat ... Skipping ...", $COLOR_WARNING)
	EndIf
EndFunc   ;==>ReadClanChat

Func CheckWarTime(ByRef $sResult, ByRef $bResult, $bReturnFrom = True, $WWR = False)
	Local $bRedColor_InWarButton, $sWarDay, $sTime
	Local $bLocalReturn = False
	$IsWarEnded = False
	$IsWarNotActive = False
	$IsStepWar = False
	HowManyinCWCombo()
	HowManyinCWLCombo()

	$g_bClanWarLeague = False
	$g_bClanWar = False
	$sResult = ""

	If IsMainPage(1) = False Then
		CheckMainScreen(False)
	EndIf

	_CaptureRegion()
	$bRedColor_InWarButton = _PixelSearch(45, 439 + $g_iBottomOffsetY, 55, 441 + $g_iBottomOffsetY, Hex(0xF81720, 6), 20) ; Red color in war buttons*
	If IsArray($bRedColor_InWarButton) Then
		$bRedColor_InWarButton = True
	Else
		$bRedColor_InWarButton = False
	EndIf
	$g_bClanWarLeague = _ColorCheck(_GetPixelColor(30, 473 + $g_iMidOffsetY, True), Hex(0xFFFFD6, 6), 20) ; Golden color at left side of clan war button
	$g_bClanWar = _ColorCheck(_GetPixelColor(36, 472 + $g_iMidOffsetY, True), Hex(0xFCB847, 6), 20) ; Ordinary war color at left side of clan war button
	If $g_bClanWarLeague Then SetDebugLog("Your Clan Is Doing Clan War League.", $COLOR_INFO)

	If $bRedColor_InWarButton Then
		SetLog("Red color on war button :", $COLOR_BLUE)
		If QuickMIS("BC1", $ImInWar, 40, 432 + $g_iBottomOffsetY, 66, 452 + $g_iBottomOffsetY) Then
			SetLog("-----------------------------------", $COLOR_ERROR)
			SetLog("|  You Have To Fight In War ! |", $COLOR_ERROR)
			SetLog("-----------------------------------", $COLOR_ERROR)
		Else
			SetLog("--------------------------------------", $COLOR_SUCCESS1)
			SetLog("|  Relax, Nothing To Do In War ! |", $COLOR_SUCCESS1)
			SetLog("--------------------------------------", $COLOR_SUCCESS1)
		EndIf
	EndIf

	If _Sleep(Random(2000, 3000, 1)) Then Return
	If Not $g_bRunState Then Return

	Click(40, 470 + $g_iBottomOffsetY) ; open war menu

	If _Sleep(Random(3000, 4000, 1)) Then Return
	If Not $g_bRunState Then Return

	If $g_bClanWarLeague Then
		If CloseWindow2(1) Then
			SetLog("War is finished.", $COLOR_WARNING)
			$IsWarEnded = True
			Local $iSleepForWindow = Random(2500, 3000, 1)
			If _Sleep($iSleepForWindow) Then Return
		EndIf
	EndIf
	If Not $g_bRunState Then Return

	If $g_bClanWar Then
		Local $WhiteInfo = _PixelSearch(744, 48, 746, 50, Hex(0x9D2C2C, 6), 20)
		If IsArray($WhiteInfo) Then
			SetLog("War is finished.", $COLOR_WARNING)
			$IsWarEnded = True
		EndIf
	EndIf

	If (_ColorCheck(_GetPixelColor(160, 270 + $g_iMidOffsetY, True), Hex(0x671C1C, 6), 20) And _ColorCheck(_GetPixelColor(700, 270 + $g_iMidOffsetY, True), Hex(0x671C1C, 6), 20) And _
			_ColorCheck(_GetPixelColor(300, 370 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 20) And _ColorCheck(_GetPixelColor(600, 370 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 20)) Or _
			(_ColorCheck(_GetPixelColor(160, 220 + $g_iMidOffsetY, True), Hex(0x671C1C, 6), 20) And _ColorCheck(_GetPixelColor(700, 220 + $g_iMidOffsetY, True), Hex(0x671C1C, 6), 20) And _
			_ColorCheck(_GetPixelColor(260, 400 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 20) And _ColorCheck(_GetPixelColor(600, 400 + $g_iMidOffsetY, True), Hex(0xFFFFFF, 6), 20)) Then
		SetLog("Your Clan is not in war yet.", $COLOR_INFO)
		$IsWarNotActive = True
		Return
	EndIf

	If _Sleep(300) Then Return
	If Not $g_bRunState Then Return

	If _Wait4PixelGoneArray($aIsMain) = False Then
		SetLog("War check fail.", $COLOR_ERROR)
		$bLocalReturn = False
	EndIf

	If IsWarMenu() Then

		If $g_bClanWarLeague And $IsWarEnded And $WWR Then
			Local $DaysCount = StringRight(getOcrAndCapture("coc-ores", 175, 622 + $g_iBottomOffsetY, 515, 25, True), 1)
			$DaysCount = StringReplace($DaysCount, "#", "", 0)
			If $DaysCount = "" Then $DaysCount = 7
			SetLog("Total days for this CWL : " & $DaysCount, $COLOR_ACTION)

			Local $xBattleDay = Random(0, $DaysCount - 1, 1)
			If $xBattleDay > 0 Then
				SetLog("Open Random Day", $COLOR_OLIVE)
			Else
				SetLog("Stay In Last Day", $COLOR_OLIVE)
			EndIf
			Switch $xBattleDay
				Case 1
					SetLog("Open Day " & $DaysCount - 1, $COLOR_BLUE)
				Case 2
					SetLog("Open Day " & $DaysCount - 2, $COLOR_BLUE)
				Case 3
					SetLog("Open Day " & $DaysCount - 3, $COLOR_BLUE)
				Case 4
					SetLog("Open Day " & $DaysCount - 4, $COLOR_BLUE)
				Case 5
					SetLog("Open Day " & $DaysCount - 5, $COLOR_BLUE)
				Case 6
					SetLog("Open Day " & $DaysCount - 6, $COLOR_BLUE)
			EndSwitch
			For $t = 0 To 4 ; Check 5 times
				If QuickMIS("BC1", $directoryDay & "\CWL_BattleDay", 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY) Then
					If $xBattleDay > 0 Then Click($g_iQuickMISX - ($xBattleDay * 76) - 5, 615 + $g_iBottomOffsetY)
					ExitLoop
				Else
					If QuickMIS("BC1", $directoryDay2, 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY) Then
						If $xBattleDay > 0 Then Click($g_iQuickMISX - ($xBattleDay * 76) - 5, 615 + $g_iBottomOffsetY)
						ExitLoop
					EndIf
				EndIf
				If _Sleep(250) Then Return
			Next
			$bResult = $g_iQuickMISX
		EndIf

		If $g_bClanWarLeague And Not $IsWarEnded Then

			Local $RandomXDayToClick = 0, $WarNumberAfterRandom = 0, $PrepDayNumber = 0, $DayReal = 0
			For $t = 0 To 4 ; Check 5 times
				If QuickMIS("BC1", $directoryDay & "\CWL_BattleDay", 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY) Then ; Battle Day Number
					$DayReal = Number(getOcrAndCapture("coc-ores", $g_iQuickMISX - 20, 622 + $g_iBottomOffsetY, 26, 25, True))
					Local $RandomXDayBefore = Random(1, $DayReal - 1, 1)
					$RandomXDayToClick = $g_iQuickMISX - ($RandomXDayBefore * 76) - 5
					$WarNumberAfterRandom = $DayReal - $RandomXDayBefore
					$PrepDayNumber = $DayReal + 1
					ExitLoop
				EndIf
				If _Sleep(250) Then Return
			Next
			If $DayReal > 0 Then
				SetLog("Actual War Day : " & $DayReal & "", $COLOR_INFO)
				$CWLPrep = False
				$IsStepWar = True
			Else
				$CWLPrep = True
			EndIf
			If _Sleep(Random(1500, 2500, 1)) Then Return
			If Not $g_bRunState Then Return

			If $WWR Then
				If Random(0, 5, 1) > 2 And $DayReal > 1 Then
					Local $XDayNumberMinus = Random(1, $DayReal - 1, 1)
					Local $RandomXDay = ($g_iQuickMISX - 5) - ($XDayNumberMinus * 76)
					Local $Daynumber = $DayReal - $XDayNumberMinus
					SetLog("Open Random Day", $COLOR_OLIVE)
					If _Sleep(250) Then Return
					SetLog("Open Day " & $Daynumber, $COLOR_OLIVE)
					If _Sleep(500) Then Return
					$IsARandomDay = True
					Click($RandomXDay, $g_iQuickMISY + 12)
					If _Sleep(Random(3000, 5000, 1)) Then Return
				Else
					SetLog("Stay In This Day", $COLOR_OLIVE)
				EndIf
			Else
				Local $SwitchBattleDay = Random(1, 5, 1)
				If $DayReal <= 1 Then $SwitchBattleDay = Random(1, 4, 1)
				If Not $CWLPrep Then
					Switch $SwitchBattleDay
						Case 1, 2
							If QuickMIS("BC1", $directoryDay & "\CWL_Battle", 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY) Then ; When Battle Day Is Unselected
								SetLog("CWL : Enter In Battle Day", $COLOR_OLIVE)
								Click($g_iQuickMISX - 5, $g_iQuickMISY + 12)
							Else
								SetLog("CWL : Stay In This Day", $COLOR_OLIVE)
							EndIf
							$IsAllowedPreparationDay = False
						Case 3
							If $IsAllowedPreparationDay Then
								If QuickMIS("BC1", $directoryDay & "\CWL_Preparation", 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY) Then ;Find Preparation Button
									If $PrepDayNumber >= 2 Then
										SetLog("CWL : Enter In Preparation Day (Day " & $PrepDayNumber & ")", $COLOR_OLIVE)
									Else
										SetLog("CWL : Enter In Preparation Day", $COLOR_OLIVE)
									EndIf
									Click($g_iQuickMISX - 5, $g_iQuickMISY + 12)
									If _Sleep(500) Then Return
									If Not IsWarMenu() Then
										SetLog("Error when trying to open CWL Preparation page.", $COLOR_ERROR)
										$bLocalReturn = SetError(1, 0, "Error Open CWL Preparation page")
									EndIf
								EndIf
							Else
								SetLog("CWL : Stay In This Day", $COLOR_OLIVE)
								$IsAllowedPreparationDay = False
							EndIf
						Case 4
							If QuickMIS("BC1", $directoryDay & "\CWL_Battle", 175, 585 + $g_iBottomOffsetY, 690, 625 + $g_iBottomOffsetY) Then ; When Battle Day Is Unselected
								SetLog("CWL : Enter In Battle Day", $COLOR_OLIVE)
								$IsAllowedPreparationDay = False
								Click($g_iQuickMISX - 5, $g_iQuickMISY + 12)
								If _Sleep(500) Then Return
								If Not IsWarMenu() Then
									SetLog("Error when trying to open CWL Battle page.", $COLOR_ERROR)
									$bLocalReturn = SetError(1, 0, "Error Open CWL Battle page")
								EndIf
							EndIf
						Case 5
							SetLog("CWL : Enter Random Previous Day", $COLOR_OLIVE)
							SetLog("Entering War Day " & $WarNumberAfterRandom & "", $COLOR_INFO)
							Click($RandomXDayToClick, 620 + $g_iBottomOffsetY)
							$IsAllowedPreparationDay = False
							$IsARandomDay = True
							If _Sleep(Random(3000, 5000, 1)) Then Return
					EndSwitch
				EndIf
			EndIf
		EndIf

		If _Sleep(Random(3000, 5000, 1)) Then Return
		If Not $g_bRunState Then Return

		$sWarDay = QuickMIS("N1", $directoryDay, 360, 85, 505, 113, True, False) ; Prepare or Battle
		If $sWarDay = "none" Then
			$bLocalReturn = SetError(1, 0, "Error reading war day")
		EndIf

		If Not StringInStr($sWarDay, "Battle") And Not StringInStr($sWarDay, "Preparation") Then
			$bLocalReturn = False
		ElseIf StringInStr($sWarDay, "Battle") Or StringInStr($sWarDay, "Preparation") Then
			$sTime = QuickMIS("OCR", $directoryTime, 396, 65, 466, 100, True, False)
			If $sTime = "none" Then Return SetError(1, 0, "Error reading war time")

			Local $iConvertedTime = ConvertOCRTime("War", $sTime, False)
			If $iConvertedTime = 0 Then Return SetError(1, 0, "Error converting war time")

			; set $sResult to be the date and time of war end
			If StringInStr($sWarDay, "Preparation") Then
				SetLog("Clan war " & ($g_bClanWarLeague = True ? "league" : "") & " is now in preparation. Battle will start in " & $sTime, $COLOR_INFO)
				$sResult = _DateAdd("n", $iConvertedTime + 24 * 60, _NowCalc()) ; $iBattleFinishTime
				$IsWarDay = False
			ElseIf StringInStr($sWarDay, "Battle") Then
				SetLog("Clan war " & ($g_bClanWarLeague = True ? "league" : "") & " is now in battle day. Battle will finish in " & $sTime, $COLOR_INFO)
				$sResult = _DateAdd("n", $iConvertedTime, _NowCalc()) ; $iBattleFinishTime
				$IsWarDay = True
			EndIf

			If Not _DateIsValid($sResult) Then Return SetError(1, 0, "Error converting battle finish time")

			$bLocalReturn = True
		EndIf
	EndIf

	If $IsARandomDay Then $IsWarDay = True

	If $IsWarEnded Or $IsARandomDay Then $IsStepWar = True
	If $IsWarNotActive Then $IsStepWar = False

	If $g_bClanWar And $IsWarEnded Then
		If _Sleep(Random(3000, 5000, 1)) Then Return
		Click(430, 590 + $g_iBottomOffsetY) ; Click On view map
		If _Sleep(Random(2000, 3000, 1)) Then Return
		If Not $g_bRunState Then Return
	EndIf

	If $bReturnFrom Then
		ReturnToHomeFromWar()
	EndIf

	Return $bLocalReturn
EndFunc   ;==>CheckWarTime

Func IsWarMenu()
	If _Sleep(250) Then Return
	If IsArray(_PixelSearch(823, 33, 832, 33, Hex(0xFFFFFF, 6), 20, True)) Then Return True
	Return False
EndFunc   ;==>IsWarMenu

Func ReturnToHomeFromWar()
	If _Wait4PixelGoneArray($aIsMain) = True Then
		Click(70, 620 + $g_iBottomOffsetY) ; return home
		If _Wait4PixelArray($aIsMain) = False Then
			Click(70, 620 + $g_iBottomOffsetY) ; return home
			CheckMainScreen()
		EndIf
	EndIf
	Return True
EndFunc   ;==>ReturnToHomeFromWar

Func ClickClanFilter($MaxTime, $FilterX, $FilterY)
	For $i = 1 To $MaxTime
		Click($FilterX, $FilterY)
		If _Sleep(Random(1500, 2500, 1)) Then Return
	Next
EndFunc   ;==>ClickClanFilter

Func BBBattleLog()
	If Not $g_bUseBotHumanization Then Return
	Local $IsToViewBBBattleLog = Random(0, 100, 1)
	Local $ViewPriorityNumber = 0
	Local $RedSignal = _ColorCheck(_GetPixelColor(50, 103 + $g_iMidOffsetY, True), Hex(0xF61621, 6), 20)
	If $g_iacmbPriorityBB[0] = 0 Then Return
	If $g_iacmbPriorityBB[0] = 1 Then $ViewPriorityNumber = 85
	If $g_iacmbPriorityBB[0] = 2 Then $ViewPriorityNumber = 70
	If $g_iacmbPriorityBB[0] = 3 Then $ViewPriorityNumber = 50
	If $g_iacmbPriorityBB[0] = 4 Then $ViewPriorityNumber = 30
	If $g_iacmbPriorityBB[0] = 5 Then $ViewPriorityNumber = 2

	If $ViewPriorityNumber < $IsToViewBBBattleLog Or $RedSignal Then
		SetLog("OK, Let The Bot Being More Human Like!", $COLOR_SUCCESS1)
		If _Sleep(Random(1500, 2500, 1)) Then Return
		SetLog("Lets Look At BattleLog", $COLOR_OLIVE)
		$ActionForModLog = "Look At BB BattleLog"
		If $g_iTxtCurrentVillageName <> "" Then
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
		Else
			GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
		EndIf
		_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
		If Not $g_bRunState Then Return
		If _Sleep(Random(3000, 5000, 1)) Then Return
		Click(38, 120 + $g_iMidOffsetY) ; open Messages button
		If Not $g_bRunState Then Return
		If _Sleep(Random(2000, 3000, 1)) Then Return
		Local $bNotificationDEFRed = _ColorCheck(_GetPixelColor(243, 90, True), Hex(0xE80914, 6), 20)
		Local $bNotificationATKRed = _ColorCheck(_GetPixelColor(452, 90, True), Hex(0xE80914, 6), 20)
		If Random(1, 2, 1) = 1 Or $bNotificationATKRed Then
			Click(375, 75 + $g_iMidOffsetY) ; click Attack Log
			SetLog("Lets Look At Attack Log", $COLOR_DEBUG2)
			If Random(1, 2, 1) = 1 And $bNotificationDEFRed Then
				If _Sleep(Random(2000, 2500, 1)) Then Return
				Click(165, 75 + $g_iMidOffsetY) ; click Defense Log
				SetLog("Lets Look At Defense Log", $COLOR_DEBUG2)
			EndIf
		Else
			If Random(1, 2, 1) = 1 Then
				Click(165, 75 + $g_iMidOffsetY) ; click Defense Log
				SetLog("Lets Look At Defense Log", $COLOR_DEBUG2)
			Else
				Click(375, 75 + $g_iMidOffsetY) ; click Attack Log
				SetLog("Lets Look At Attack Log", $COLOR_DEBUG2)
			EndIf
		EndIf
		If _Sleep(Random(500, 1000, 1)) Then Return
		If Not $g_bRunState Then Return
		If Random(1, 3, 1) = 1 Then
			Scroll(Random(1, 2, 1))
			If Not $g_bRunState Then Return
			If _Sleep(Random(3000, 5000, 1)) Then Return
			If Not BBBattleWatchReplay() Then CloseWindow()
		Else
			CloseWindow()
		EndIf
		If Not $g_bRunState Then Return
		If _Sleep(Random(1000, 2000, 1)) Then Return
		ZoomOut()
	EndIf

EndFunc   ;==>BBBattleLog

Func BBBattleWatchReplay()
	Local $IsToWatchBBReplays = Random(0, 100, 1)
	Local $WatchPriorityNumber = 0
	If $g_iacmbPriorityBB[1] = 0 Then Return
	If $g_iacmbPriorityBB[1] = 1 Then $WatchPriorityNumber = 85
	If $g_iacmbPriorityBB[1] = 2 Then $WatchPriorityNumber = 70
	If $g_iacmbPriorityBB[1] = 3 Then $WatchPriorityNumber = 50
	If $g_iacmbPriorityBB[1] = 4 Then $WatchPriorityNumber = 30
	If $g_iacmbPriorityBB[1] = 5 Then $WatchPriorityNumber = 2

	If $WatchPriorityNumber > $IsToWatchBBReplays Then Return False

	SetLog("Lets Watch A Replay", $COLOR_OLIVE)
	$ActionForModLog = "Watch A BB Replay"
	If $g_iTxtCurrentVillageName <> "" Then
		GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
	Else
		GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
	EndIf
	_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)

	If QuickMis("BC1", $g_sImgBBLive, 560, 140 + $g_iMidOffsetY, 720, 250 + $g_iMidOffsetY) Then
		SetLog("Watch Live Detected", $COLOR_ACTION)
		If _Sleep(Random(2000, 3000, 1)) Then Return
		Click($g_iQuickMISX + 65, $g_iQuickMISY)
		If IsReplayWindow() Then
			Local $IsBoring = Random(1, 5, 1)
			If $IsBoring >= 4 Then
				If IsReplayWindow() Then
					SetLog("This Live Is Boring, Let Me Go Out ...", $COLOR_OLIVE)
					If _Sleep(1000) Then Return
					SetLog("Exiting ...", $COLOR_OLIVE)
					If _Sleep(Random(2000, 3000, 1)) Then Return
					Local $AttackCoordsX[2] = [45, 85]
					Local $AttackCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
					Local $AttackButtonClickX = Random($AttackCoordsX[0], $AttackCoordsX[1], 1)
					Local $AttackButtonClickY = Random($AttackCoordsY[0], $AttackCoordsY[1], 1)
					Click($AttackButtonClickX, $AttackButtonClickY, 1, 160) ; return home
					If Not $g_bRunState Then Return
					If _Sleep(Random(2000, 3000, 1)) Then Return
				EndIf
			Else
				SetLog("Waiting For Live End ...", $COLOR_ACTION)
				While IsReplayWindow()
					If _Sleep(1000) Then Return
					If Not $g_bRunState Then Return
				WEnd
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
				Local $AttackCoordsX[2] = [45, 85]
				Local $AttackCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
				Local $AttackButtonClickX = Random($AttackCoordsX[0], $AttackCoordsX[1], 1)
				Local $AttackButtonClickY = Random($AttackCoordsY[0], $AttackCoordsY[1], 1)
				Click($AttackButtonClickX, $AttackButtonClickY, 1, 160) ; return home
				If Not $g_bRunState Then Return
				If _Sleep(Random(2000, 3000, 1)) Then Return
			EndIf
			Return True
		EndIf
	EndIf

	Local $aSarea[4] = [615, 100 + $g_iMidOffsetY, 760, 615 + $g_iMidOffsetY]
	Local $vReplayNumber = findMultipleQuick($g_sBBReplay, 3, $aSarea)
	If UBound($vReplayNumber) > 0 And Not @error Then
		SetLog("There Are " & UBound($vReplayNumber) & " Replays To Watch ... We Will Choose One Of Them ...", $COLOR_INFO)
		Local $iReplayToLaunch = Random(0, UBound($vReplayNumber) - 1, 1)
		Click($vReplayNumber[$iReplayToLaunch][1], $vReplayNumber[$iReplayToLaunch][2]) ; click on the choosen replay
		WaitForReplayWindow()
		If IsReplayWindow() Then
			GetReplayDuration(2)
			If _Sleep(1000) Then Return
			If Not $g_bRunState Then Return
			If IsReplayWindow() Then
				AccelerateReplay(2)
			EndIf
			If _Sleep($g_aReplayDuration[1] / 3) Then Return
			Local $IsBoring = Random(1, 5, 1)
			If $IsBoring >= 4 Then
				If IsReplayWindow() Then
					SetLog("This Replay Is Boring, Let Me Go Out ...", $COLOR_OLIVE)
					If _Sleep(1000) Then Return
					SetLog("Exiting ...", $COLOR_OLIVE)
					If _Sleep(Random(2000, 3000, 1)) Then Return
					Local $AttackCoordsX[2] = [45, 85]
					Local $AttackCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
					Local $AttackButtonClickX = Random($AttackCoordsX[0], $AttackCoordsX[1], 1)
					Local $AttackButtonClickY = Random($AttackCoordsY[0], $AttackCoordsY[1], 1)
					Click($AttackButtonClickX, $AttackButtonClickY, 1, 160) ; return home
					If Not $g_bRunState Then Return
					If _Sleep(Random(2000, 3000, 1)) Then Return
				EndIf
			Else
				If IsReplayWindow() Then
					DoAPauseDuringReplay(2)
				EndIf
				If _Sleep($g_aReplayDuration[1] / 3) Then Return
				If IsReplayWindow() And $g_aReplayDuration[0] <> 0 Then
					DoAPauseDuringReplay(2)
				EndIf
				SetLog("Waiting For Replay End ...", $COLOR_ACTION)
				While IsReplayWindow()
					If _Sleep(1000) Then Return
					If Not $g_bRunState Then Return
				WEnd
				If _Sleep(1000) Then Return
				If Not $g_bRunState Then Return
				Local $AttackCoordsX[2] = [45, 85]
				Local $AttackCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
				Local $AttackButtonClickX = Random($AttackCoordsX[0], $AttackCoordsX[1], 1)
				Local $AttackButtonClickY = Random($AttackCoordsY[0], $AttackCoordsY[1], 1)
				Click($AttackButtonClickX, $AttackButtonClickY, 1, 160) ; return home
				If Not $g_bRunState Then Return
				If _Sleep(Random(2000, 3000, 1)) Then Return
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Else
		SetLog("No Replay To Watch ... Skipping ...", $COLOR_WARNING)
		If Not $g_bRunState Then Return
		CloseWindow()
	EndIf

	Return True
EndFunc   ;==>BBBattleWatchReplay

Func ReturnHomeFromHumanization()
	While 1
		If QuickMIS("BC1", $g_sImgReturnHome, 25, 570 + $g_iBottomOffsetY, 105, 630 + $g_iBottomOffsetY) Then
			Local $AttackCoordsX[2] = [45, 85]
			Local $AttackCoordsY[2] = [590 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
			Local $AttackButtonClickX = Random($AttackCoordsX[0], $AttackCoordsX[1], 1)
			Local $AttackButtonClickY = Random($AttackCoordsY[0], $AttackCoordsY[1], 1)
			Click($AttackButtonClickX, $AttackButtonClickY, 1, 160) ; return home
			If _Sleep(Random(3000, 3500, 1)) Then Return
			Local $aMain = findButton("AttackButton", Default, 1, True)
			If IsArray($aMain) And UBound($aMain, 1) = 2 Then ExitLoop
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>ReturnHomeFromHumanization

Func CheckRaidMap()
	If Not $g_bUseBotHumanization Then Return
	Local $IsToCheckRaidMap = Random(0, 100, 1)
	Local $CheckRaidMapPriority = 0
	If $g_iacmbPriorityChkRaid = 0 Then Return
	If $g_iacmbPriorityChkRaid = 1 Then $CheckRaidMapPriority = 85
	If $g_iacmbPriorityChkRaid = 2 Then $CheckRaidMapPriority = 70
	If $g_iacmbPriorityChkRaid = 3 Then $CheckRaidMapPriority = 50
	If $g_iacmbPriorityChkRaid = 4 Then $CheckRaidMapPriority = 30
	If $g_iacmbPriorityChkRaid = 5 Then $CheckRaidMapPriority = 2

	If $CheckRaidMapPriority > $IsToCheckRaidMap Then Return

	SwitchToCapitalMain()
	If QuickMIS("BC1", $g_sImgCCMap, 760, 570 + $g_iBottomOffsetY, 840, 650 + $g_iBottomOffsetY) Then
		If $g_iQuickMISName = "RaidMapButton" Then
			SetLog("Lets Look At Raid Map", $COLOR_ACTION)
			$ActionForModLog = "Look At Raid Map"
			If $g_iTxtCurrentVillageName <> "" Then
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_iTxtCurrentVillageName & "] Humanization : " & $ActionForModLog, 1)
			Else
				GUICtrlSetData($g_hTxtModLog, @CRLF & _NowTime() & " [" & $g_sProfileCurrentName & "] Humanization : " & $ActionForModLog, 1)
			EndIf
			_FileWriteLog($g_sProfileLogsPath & "\ModLog.log", " [" & $g_sProfileCurrentName & "] - Humanization : " & $ActionForModLog)
			If _Sleep(1000) Then Return
			Local $RaidMapCoordsX[2] = [775, 825]
			Local $RaidMapCoordsY[2] = [585 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
			Local $RaidMapButtonClickX = Random($RaidMapCoordsX[0], $RaidMapCoordsX[1], 1)
			Local $RaidMapButtonClickY = Random($RaidMapCoordsY[0], $RaidMapCoordsY[1], 1)
			Click($RaidMapButtonClickX, $RaidMapButtonClickY, 1, 170, "RaidMap") ; open Raid Map
			If _Sleep(Random(5000, 7000, 1)) Then Return
			If QuickMIS("BC1", $g_sImgRaidMap, 710, 25, 730, 45) Then
				Local $sForRaidTimeOCR = getTimeForRaid(715, 55)
				Local $iConvertedTime = ConvertOCRTime("Raid Time2", $sForRaidTimeOCR, False)
				If $iConvertedTime > 1440 Then
					SetLog("Raid Weekend Will Finish in " & $sForRaidTimeOCR & "", $COLOR_GREEN)
				ElseIf $iConvertedTime < 1440 And $iConvertedTime > 120 Then
					SetLog("Raid Weekend Will Finish in " & $sForRaidTimeOCR & "", $COLOR_OLIVE)
				ElseIf $iConvertedTime < 120 Then
					SetLog("Raid Weekend Will Finish in " & $sForRaidTimeOCR & "", $COLOR_RED)
				EndIf
				If _Sleep(2500) Then Return
				If QuickMIS("BC1", $g_sImgCCMap, 760, 570 + $g_iBottomOffsetY, 845, 650 + $g_iBottomOffsetY) Then
					If $g_iQuickMISName = "RaidInfoButton" Then
						SetLog("Lets Look At Raid Info", $COLOR_ACTION)
						Local $RaidInfoCoordsX[2] = [775, 825]
						Local $RaidInfoCoordsY[2] = [585 + $g_iBottomOffsetY, 625 + $g_iBottomOffsetY]
						Local $RaidInfoButtonClickX = Random($RaidInfoCoordsX[0], $RaidInfoCoordsX[1], 1)
						Local $RaidInfoButtonClickY = Random($RaidInfoCoordsY[0], $RaidInfoCoordsY[1], 1)
						Click($RaidInfoButtonClickX, $RaidInfoButtonClickY, 1, 170, "RaidInfo") ; open Raid Info
						If _Sleep(2000) Then Return
						SetLog("Lets Scroll Clan Info", $COLOR_ACTION)
						For $i = 0 To Random(0, 2, 1)
							Local $x = Random(270, 450, 1)
							Local $yStart = Random(570 + $g_iMidOffsetY, 600 + $g_iMidOffsetY, 1)
							Local $yEnd = Random($yStart - 200, $yStart - 170, 1)
							ClickDrag($x, $yStart, $x, $yEnd)
							If _Sleep(2000) Then Return
							If Not $g_bRunState Then Return
						Next
						Local $bToReScroll = 0
						If Random(0, 1, 1) = 1 Then
							SetLog("Lets Look At Attack Log", $COLOR_ACTION)
							Click(430, 250 + $g_iMidOffsetY)
							If _Sleep(2000) Then Return
							$yStart = Random(570 + $g_iMidOffsetY, 600 + $g_iMidOffsetY, 1)
							$yEnd = Random($yStart + 140, $yStart + 160, 1)
							ClickDrag($x, $yStart, $x, $yEnd)
							$bToReScroll += 1
							If _Sleep(Random(3000, 7000, 1)) Then Return
						EndIf
						If Random(0, 1, 1) = 1 Then
							SetLog("Lets Look At Defense Log", $COLOR_ACTION)
							Click(675, 250 + $g_iMidOffsetY)
							If $bToReScroll = 0 Then
								If _Sleep(2000) Then Return
								$yStart = Random(570 + $g_iMidOffsetY, 600 + $g_iMidOffsetY, 1)
								$yEnd = Random($yStart + 140, $yStart + 160, 1)
								ClickDrag($x, $yStart, $x, $yEnd)
							EndIf
							If _Sleep(Random(4000, 6000, 1)) Then Return
						EndIf
						CloseWindow()
					EndIf
					If _Sleep(Random(1000, 3000, 1)) Then Return
				EndIf
				SwitchToCapitalMain()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckRaidMap

Func FindMark($bVillage = "HomeVillage", $bIsTop = True)

	Switch $bVillage
		Case "HomeVillage", "Builder Base"
			If $bIsTop Then
				Local $aSarea[4] = [760, 470 + $g_iMidOffsetY, 820, 600 + $g_iMidOffsetY]
			Else
				Local $aSarea[4] = [760, 180 + $g_iMidOffsetY, 820, 600 + $g_iMidOffsetY]
			EndIf
		Case "ClanCapital"
			If $bIsTop Then
				Local $aSarea[4] = [590, 470 + $g_iMidOffsetY, 670, 600 + $g_iMidOffsetY]
			Else
				Local $aSarea[4] = [590, 180 + $g_iMidOffsetY, 670, 600 + $g_iMidOffsetY]
			EndIf
	EndSwitch

	Local $vPlayerMarks = findMultipleQuick($g_sImgPlayerMark, 10, $aSarea)
	If UBound($vPlayerMarks) > 0 And Not @error Then
		Local $iPlayerToVisit = Random(0, UBound($vPlayerMarks) - 1, 1)
		Switch $bVillage
			Case "HomeVillage", "Builder Base"
				Local $aColorGreen[4] = [$vPlayerMarks[$iPlayerToVisit][1] - 380, $vPlayerMarks[$iPlayerToVisit][2] + 30, 0xA3C469, 20]
				Local $bLoop = 0
				While _CheckPixel($aColorGreen, True)
					If $bLoop = 10 Then Return False
					$iPlayerToVisit = Random(0, UBound($vPlayerMarks) - 1, 1)
					Local $aColorGreen[4] = [$vPlayerMarks[$iPlayerToVisit][1] - 380, $vPlayerMarks[$iPlayerToVisit][2] + 30, 0xA3C469, 20]
					$bLoop += 1
				WEnd
				Click($vPlayerMarks[$iPlayerToVisit][1] - 340, $vPlayerMarks[$iPlayerToVisit][2]) ; click on Player
				If _Sleep(Random(500, 1000, 1)) Then Return
			Case "ClanCapital"
				Local $aColorGreen[4] = [$vPlayerMarks[$iPlayerToVisit][1] - 220, $vPlayerMarks[$iPlayerToVisit][2] + 20, 0xA3C469, 20]
				Local $bLoop = 0
				While _CheckPixel($aColorGreen, True)
					If $bLoop = 10 Then Return False
					$iPlayerToVisit = Random(0, UBound($vPlayerMarks) - 1, 1)
					Local $aColorGreen[4] = [$vPlayerMarks[$iPlayerToVisit][1] - 220, $vPlayerMarks[$iPlayerToVisit][2] + 20, 0xA3C469, 20]
					$bLoop += 1
				WEnd
				Click($vPlayerMarks[$iPlayerToVisit][1] - 200, $vPlayerMarks[$iPlayerToVisit][2]) ; click on Player
				If _Sleep(Random(500, 1000, 1)) Then Return
		EndSwitch
	Else
		SetLog("No Player Mark Found ... Skipping ...", $COLOR_WARNING)
		Return False
	EndIf

	Return True
EndFunc   ;==>FindMark

Func FindMarkBestPlayer($bLocation = "Global")

	Switch $bLocation
		Case "Global"
			Local $aSarea[4] = [760, 345 + $g_iMidOffsetY, 820, 600 + $g_iMidOffsetY]
		Case "Local"
			Local $aSarea[4] = [760, 190 + $g_iMidOffsetY, 820, 600 + $g_iMidOffsetY]
	EndSwitch

	Local $vPlayerMarks = findMultipleQuick($g_sImgPlayerMark, 10, $aSarea)
	If UBound($vPlayerMarks) > 0 And Not @error Then
		Local $iPlayerToVisit = Random(0, UBound($vPlayerMarks) - 1, 1)

		Click($vPlayerMarks[$iPlayerToVisit][1] - 400, $vPlayerMarks[$iPlayerToVisit][2]) ; click on Player
		If _Sleep(Random(500, 1000, 1)) Then Return
	Else
		SetLog("No Player Mark Found ... Skipping ...", $COLOR_WARNING)
		Return False
	EndIf

	Return True
EndFunc   ;==>FindMarkBestPlayer

Func FindMarkBestClan($bLocation = "Global")

	Switch $bLocation
		Case "Global"
			Local $aSarea[4] = [760, 345 + $g_iMidOffsetY, 845, 600 + $g_iMidOffsetY]
		Case "International"
			Local $aSarea[4] = [760, 190 + $g_iMidOffsetY, 845, 600 + $g_iMidOffsetY]
	EndSwitch

	Local $vPlayerMarks = findMultipleQuick($g_sImgPlayerMark, 10, $aSarea)
	If UBound($vPlayerMarks) > 0 And Not @error Then
		Local $iPlayerToVisit = Random(0, UBound($vPlayerMarks) - 1, 1)

		Click($vPlayerMarks[$iPlayerToVisit][1] - 400, $vPlayerMarks[$iPlayerToVisit][2]) ; click on Clan
		If _Sleep(Random(500, 1000, 1)) Then Return
	Else
		SetLog("No Player Mark Found ... Skipping ...", $COLOR_WARNING)
		Return False
	EndIf

	Return True
EndFunc   ;==>FindMarkBestClan
