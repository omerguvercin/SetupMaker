#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\vnc.ico
#AutoIt3Wrapper_Res_Comment=VNC Launcher Kurulum
#AutoIt3Wrapper_Res_Description=VNC Launcher Installer
#AutoIt3Wrapper_Res_ProductName=VNC Launcher Installer
#AutoIt3Wrapper_Res_ProductVersion=1.3
#AutoIt3Wrapper_Res_CompanyName=omerguvercin
#AutoIt3Wrapper_Res_LegalCopyright=t.me/iomerg
#AutoIt3Wrapper_Res_Language=1055
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WinAPIFiles.au3>
#include <FileConstants.au3>

Global $installPath = @AppDataDir & "\VNCLauncher"
Global $desktopShortcut = @DesktopDir & "\VNC Launcher.lnk"

GUICreate("VNC Launcher Kurulumu", 320, 170, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU))
GUISetBkColor(0xF4F4F4)

; Açıklama metni
GUICtrlCreateLabel("VNC Launcher kurulumu başlayacaktır.", 40, 30, 250, 30)
GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")

; Kur butonu
Global $btnInstall = GUICtrlCreateButton("KUR", 110, 90, 100, 30)
GUICtrlSetFont(-1, 10, 800, 0, "Segoe UI")
GUICtrlSetBkColor(-1, 0x0078D7)
GUICtrlSetColor(-1, 0xFFFFFF)

; Progress bar
Global $progress = GUICtrlCreateProgress(30, 140, 260, 18, $PBS_SMOOTH)
GUICtrlSetColor(-1, 0x0078D7)

GUISetState(@SW_SHOW)

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
        Case $btnInstall
            GUICtrlSetState($btnInstall, $GUI_DISABLE)
            Install()
    EndSwitch
WEnd

Func UpdateProgress($percent)
    GUICtrlSetData($progress, $percent)
EndFunc

Func Install()
    DirCreate($installPath)

    FileInstall("Hardcodet.NotifyIcon.Wpf.dll", $installPath & "\Hardcodet.NotifyIcon.Wpf.dll", 1)
    UpdateProgress(20)

    FileInstall("Newtonsoft.Json.dll", $installPath & "\Newtonsoft.Json.dll", 1)
    UpdateProgress(40)

    FileInstall("VNCLauncher.dll", $installPath & "\VNCLauncher.dll", 1)
    UpdateProgress(60)

    FileInstall("VNCLauncher.exe", $installPath & "\VNCLauncher.exe", 1)
    UpdateProgress(80)

    CreateRuntimeConfig()
    UpdateProgress(100)

    CreateShortcut()
    ShowModernDoneMessage()
EndFunc

Func CreateShortcut()
    Local $oShell = ObjCreate("WScript.Shell")
    Local $oShortcut = $oShell.CreateShortcut($desktopShortcut)
    $oShortcut.TargetPath = $installPath & "\VNCLauncher.exe"
    $oShortcut.WorkingDirectory = $installPath
    $oShortcut.IconLocation = $installPath & "\VNCLauncher.exe"
    $oShortcut.Save
EndFunc

Func CreateRuntimeConfig()
    Local $jsonFile = $installPath & "\VNCLauncher.runtimeconfig.json"
    Local $jsonContent = _
        '{' & @CRLF & _
        '  "runtimeOptions": {' & @CRLF & _
        '    "tfm": "net8.0",' & @CRLF & _
        '    "frameworks": [' & @CRLF & _
        '      {' & @CRLF & _
        '        "name": "Microsoft.NETCore.App",' & @CRLF & _
        '        "version": "8.0.0"' & @CRLF & _
        '      },' & @CRLF & _
        '      {' & @CRLF & _
        '        "name": "Microsoft.WindowsDesktop.App",' & @CRLF & _
        '        "version": "8.0.0"' & @CRLF & _
        '      }' & @CRLF & _
        '    ],' & @CRLF & _
        '    "configProperties": {' & @CRLF & _
        '      "System.Runtime.Serialization.EnableUnsafeBinaryFormatterSerialization": true,' & @CRLF & _
        '      "CSWINRT_USE_WINDOWS_UI_XAML_PROJECTIONS": false' & @CRLF & _
        '    }' & @CRLF & _
        '  }' & @CRLF & _
        '}'

    Local $hFile = FileOpen($jsonFile, $FO_OVERWRITE + $FO_CREATEPATH + $FO_UTF8)
    If $hFile <> -1 Then
        FileWrite($hFile, $jsonContent)
        FileClose($hFile)
    EndIf
EndFunc

Func ShowModernDoneMessage()
    Local $doneGUI = GUICreate("Kurulum Tamamlandı", 280, 120, -1, -1, $WS_CAPTION + $WS_SYSMENU)
    GUICtrlCreateIcon("imageres.dll", 1400, 20, 20, 24, 24)
    GUICtrlCreateLabel("Kurulum başarıyla tamamlandı.", 60, 28, 200, 24)
    Local $btnOK = GUICtrlCreateButton("Tamam", 90, 70, 100, 25)
    GUISetState(@SW_SHOW, $doneGUI)

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $btnOK
                GUIDelete($doneGUI)
                Exit
        EndSwitch
    WEnd
EndFunc
