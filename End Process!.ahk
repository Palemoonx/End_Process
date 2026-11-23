#NoTrayIcon
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetBatchLines, -1

logDir := A_MyDocuments "\Log Files"

processListFile := A_ScriptDir "\assets\config\Process List.txt"

processLog := logDir "\End Process!.txt"

processWait := 500
forceWait := 750

FileCreateDir %logDir%
FileDelete %processLog%

if !FileExist(processListFile)
{
    LogProcess("ERROR: Process List.txt does not exist")
    LogProcess("===== END =====")
    ExitApp
}

FileRead processList, %processListFile%

if ErrorLevel
{
    LogProcess("ERROR: Could not read Process List.txt")
    LogProcess("===== END =====")
    ExitApp
}

processedProcesses := Object()

processCount := 0
foundCount := 0
closedCount := 0
forcedCount := 0
failedCount := 0

Loop, Parse, processList, `n, `r
{
    processName := Trim(A_LoopField)

    if (processName = "")
        continue

    if (SubStr(processName, 1, 1) = ";")
        continue

    processKey := processName
    StringLower processKey, processKey

    if (processedProcesses.HasKey(processKey))
    {
        LogProcess("SKIPPED: duplicate process: " processName)
        continue
    }

    processedProcesses[processKey] := true
    processCount++

    Process Exist, %processName%
    processPID := ErrorLevel

    if (!processPID)
    {
        LogProcess("NOT FOUND: " processName)
        continue
    }

    foundCount++

    LogProcess("FOUND: " processName " (PID " processPID ")")

    LogProcess("PROCESS, CLOSE: trying to close "
        . processName
        . " (PID "
        . processPID
        . ")")

    Process Close, %processPID%

    if ErrorLevel
    {
        LogProcess("WARNING: Process, Close returned error for "
            . processName
            . " (PID "
            . processPID
            . ")")
    }
    else
    {
        LogProcess("PROCESS, CLOSE sent to "
            . processName
            . " (PID "
            . processPID
            . ")")
    }

    Sleep %processWait%

    Process Exist, %processPID%

    if (!ErrorLevel)
    {
        closedCount++

        LogProcess("CLOSED: "
            . processName
            . " (PID "
            . processPID
            . ") via Process, Close")

        continue
    }

    LogProcess("STILL RUNNING: "
        . processName
        . " (PID "
        . processPID
        . ") is still active.")

    LogProcess("STARTING FORCED CLOSE: "
        . processName
        . " (PID "
        . processPID
        . ")")

    command := ComSpec
        . " /c taskkill /PID "
        . processPID
        . " /F >nul 2>&1"

    RunWait %command%, , Hide
    taskkillExitCode := ErrorLevel

    if (taskkillExitCode = 0)
    {
        LogProcess("TASKKILL /F executed successfully for "
            . processName
            . " (PID "
            . processPID
            . ")")
    }
    else
    {
        LogProcess("WARNING: TASKKILL /F returned code "
            . taskkillExitCode
            . " for "
            . processName
            . " (PID "
            . processPID
            . ")")
    }

    Sleep %forceWait%

    Process Exist, %processPID%

    if (!ErrorLevel)
    {
        closedCount++
        forcedCount++

        LogProcess("FORCE CLOSED: "
            . processName
            . " (PID "
            . processPID
            . ")")

        continue
    }

    failedCount++

    LogProcess("ERROR: "
        . processName
        . " (PID "
        . processPID
        . ") remains active after Process, Close and TASKKILL /F")
}

LogProcess("================================================")
LogProcess("===== PROCESS SUMMARY =====")
LogProcess("================================================")

LogProcess("Processes processed: " processCount)
LogProcess("Processes found: " foundCount)
LogProcess("Processes closed: " closedCount)
LogProcess("Of those, force closed: " forcedCount)
LogProcess("Processes still active: " failedCount)

LogProcess("================================================")
LogProcess("===== END OF PROCESS SWEEP =====")
LogProcess("================================================")

unlockSound := A_WinDir "\Media\Windows Unlock.wav"
if FileExist(unlockSound)
    SoundPlay, %unlockSound%
else
    SoundPlay, *-1

Sleep 5000

ExitApp


LogProcess(message)
{
    global processLog

    timestamp := CurrentTimestamp()
    FileAppend [%timestamp%] %message%`n, %processLog%
}

CurrentTimestamp()
{
    FormatTime timestamp,, yyyy-MM-dd HH:mm:ss
    return timestamp
}
