#NoTrayIcon
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1

processListFile := A_ScriptDir "\assets\config\Process List.txt"
processArray := Object()

if FileExist(processListFile)
{
    FileRead, fileContent, %processListFile%
    Loop, Parse, fileContent, `n, `r
    {
        name := Trim(A_LoopField)
        if (name = "")
            continue
        if (SubStr(name, 1, 1) = ";")
            continue
        StringLower, key, name
        if (processArray.HasKey(key))
            continue
        processArray[key] := name
    }
}

Gui, New, -Caption -Border -SysMenu +ToolWindow, End Process
Gui, Color, 1F1F1F
Gui, Margin, 20, 20
Gui, Font, s11 cWhite, Segoe UI

Gui, Add, Text, x0 y0 w470 h48 Background262626 gDragWindow +0x200,
Gui, Add, Text, x20 y14 w430 h25 Background262626 cWhite, End Process!  -  Add Programs
Gui, Add, Text, x478 y10 w32 h28 +Center +0x200 Background262626 cWhite gCloseGui, X

Gui, Font, s10 cB0B0B0, Segoe UI
Gui, Add, Text, x20 y62 w480 h28 Background1F1F1F, Choose the programs you want to close automatically.
Gui, Font, s11 cWhite, Segoe UI

Gui, Add, ListView, x20 y98 w480 h268 vMyListView Background2A2A2A cWhite -Hdr -Multi -Border, Program
LV_ModifyCol(1, 460)

Gui, Font, s11 cWhite Bold, Segoe UI
Gui, Add, Text, x20 y382 w235 h44 +Center +0x200 Background00C48C cWhite gBtnBuscar, + Find Program
Gui, Font, s11 cWhite, Segoe UI
Gui, Add, Text, x265 y382 w235 h44 +Center +0x200 Background3A3A3A cWhite gBtnQuitar, Remove Selected

Gui, Font, s10 c8A8A8A, Segoe UI
Gui, Add, Text, x20 y438 w480 h20 Background1F1F1F vTxtStatus, 0 programs in the list

Gui, Font, s12 cWhite Bold, Segoe UI
Gui, Add, Text, x20 y468 w480 h46 +Center +0x200 Background00C48C cWhite gBtnHecho, DONE

Gosub, RefreshList

CenterX := (A_ScreenWidth - 520) // 2
CenterY := (A_ScreenHeight - 540) // 2
Gui, Show, x%CenterX% y%CenterY% w520 h540, End Process
WinGet, hWnd, ID, A
hRgn := DllCall("gdi32\CreateRoundRectRgn", "Int", 0, "Int", 0, "Int", 520, "Int", 540, "Int", 18, "Int", 18)
DllCall("user32\SetWindowRgn", "UInt", hWnd, "UInt", hRgn, "Int", 1)
return

BtnBuscar:
    FileSelectFile, SelectedFile, 1, , Choose the program you want to close, Programs (*.exe)
    if (ErrorLevel)
        return
    SplitPath, SelectedFile, FileName
    if (FileName = "")
        return
    StringLower, key, FileName
    if (processArray.HasKey(key))
    {
        MsgBox, 48, Already in the list, %FileName% is already added.
        return
    }
    processArray[key] := FileName
    Gosub, RefreshList
return

BtnQuitar:
    Gui, ListView, MyListView
    Row := LV_GetNext(0, "F")
    if (Row = 0)
    {
        MsgBox, 48, Nothing selected, Select a program from the list to remove it.
        return
    }
    LV_GetText(SelectedName, Row, 1)
    StringLower, key, SelectedName
    processArray.Delete(key)
    Gosub, RefreshList
return

BtnHecho:
    Gosub, SaveList
    Gui, Destroy
    ExitApp
return

CloseGui:
GuiClose:
GuiEscape:
    ExitApp
return

DragWindow:
    PostMessage, 0xA1, 2,,, A
return

RefreshList:
    Gui, ListView, MyListView
    LV_Delete()
    For key, name in processArray
    {
        LV_Add("", name)
    }
    LV_ModifyCol(1, 460)
    count := processArray.Count()
    GuiControl,, TxtStatus, %count% programs in the list.
return

SaveList:
    SplitPath, processListFile, , OutDir
    FileCreateDir, %OutDir%
    FileDelete, %processListFile%
    For key, name in processArray
    {
        FileAppend, %name%`n, %processListFile%
    }
return
