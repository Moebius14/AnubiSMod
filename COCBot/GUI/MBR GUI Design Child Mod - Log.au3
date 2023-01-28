; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Anubis (2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
; Advanced Tab
;~ -------------------------------------------------------------
Global $g_hTxtModLog = 0, $g_hBtnModLogClear
Global $g_HowManyinCWLabel = 0, $g_HowManyinCWCombo = 0, $g_HowManyinCWLLabel = 0, $g_HowManyinCWLCombo = 0
Global $g_hTxtCurrentVillageName = 0, $g_hBtnSaveAlias = 0

Func TabModLogGUI()
Local $x = 0, $y = 0
	$g_hTxtModLog = GUICtrlCreateEdit("", 10, 40, $g_iSizeWGrpTab3, 250, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, "------------------------------------------------------- Log of Mod Events -------------------------------------------------")
			
	$g_hBtnModLogClear = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Log", "BtnModLogClear", "Clear Mod Log"), $x + 330, $y + 300, 80, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Log", "BtnModLogClear_Info_01", "Use this to clear the Mod Log."))
	GUICtrlSetOnEvent(-1, "btnModLogClear")
	
	$y += 310
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - ModLog", "Group_01", "Informations for humanization"), $x + 10, $y + 17 , 430, 60)
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnModCW, $x + 35, $y + 36, 32, 32)
	$g_HowManyinCWLabel = GUICtrlCreateLabel("Players in CW : ", $x + 75, $y + 47, -1, -1)
	$g_HowManyinCWCombo = GUICtrlCreateCombo("", $x + 155, $y + 43, 40, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "5|10|15|20|25|30|35|40|45|50", "5")
	_GUICtrlSetTip(-1, "Please Select Number Of Players In Classic War - Humanization Optimization")
	GUICtrlSetOnEvent(-1, "HowManyinCWCombo")
	GUICtrlCreateIcon($g_sLibModIconPath, $eIcnCWLChampion, $x + 235, $y + 35, 34, 34)
	$g_HowManyinCWLLabel = GUICtrlCreateLabel("Players in CWL : ", $x + 275, $y + 47, -1, -1)
	$g_HowManyinCWLCombo = GUICtrlCreateCombo("", $x + 360, $y + 43, 40, 10, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "5|10|15|20|25|30|35|40|45|50", "15")
	_GUICtrlSetTip(-1, "Please Select Number Of Players In Clan War League - Humanization Optimization")
	GUICtrlSetOnEvent(-1, "HowManyinCWLCombo")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$y += 60
	
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design - ModLog", "Group_02", "Village Name"), $x + 10, $y + 17 , 430, 45)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - ModLog", "TxtCurrentVillageName", "Current Alias") & ":", $x + 90, $y + 37, -1, -1, $SS_RIGHT)
	$g_hTxtCurrentVillageName = GUICtrlCreateInput("", $x + 170, $y + 34, 115, 19)
	_GUICtrlSetTip(-1, "Please Enter The Name Of The Village For The Current Profile")
	GUICtrlSetOnEvent(-1, "LoadCurrentAlias")
	Static $bIconSave = _GUIImageList_Create(24, 24, 4)
	_GUIImageList_AddBitmap($bIconSave, @ScriptDir & "\images\Button\iconConfirm.bmp")
	$g_hBtnSaveAlias = GUICtrlCreateButton("", $x + 300, $y + 31, 24, 24)
	_GUICtrlButton_SetImageList($g_hBtnSaveAlias, $bIconSave, 4)
	GUICtrlSetOnEvent(-1, "BtnSaveprofile2")
	_GUICtrlSetTip(-1, "Save your current Village Name.")
	GUICtrlCreateGroup("", -99, -99, 1, 1)	
	
	
EndFunc   ;==>CreateAdvancedTab	