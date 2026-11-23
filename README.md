# End Process List

A small, lightweight utility to close programs from a list, with one click.
No install. No browser. No heavy runtime. Just AutoHotkey v1.

- Size: under 4 MB
- Language: AutoHotkey v1
- Style: Dark, simple
- Main use: Close the programs you choose, when you choose

---

## Screenshot

[End Process List GUI](End_Process.png)

---

## What it does

1. You add programs to a list with the GUI.
2. You run `End Process!.ahk`.
3. It tries to close each program in a soft way first.
4. If a program is still open, it tries a forced close.
5. It writes a log with what happened.
6. It plays a system sound when it finishes.

It only closes programs. It does not delete files. It does not uninstall anything.

---

## Portable files

The portable has only 4 files, in the same folder. No extra folders needed.

```
End Process List/
├── End Process!.ahk
├── End Process! List.ahk
├── End Process!.ico
├── End Process! List.ico
└── README.md
```

- `End Process!.ahk` - The main tool. Closes the programs in the list.
- `End Process! List.ahk` - The GUI. Adds programs to the list and creates what is needed.
- `End Process!.ico` - Icon for the main tool, for compiling.
- `End Process! List.ico` - Icon for the GUI, for compiling.
- `README.md` - This file.

No `assets` folder is included. The GUI creates it when you save.

---

## How to use

### 1. You need AutoHotkey v1

Install AutoHotkey v1 on Windows. This tool is made for v1.

### 2. First run: Add programs to the list

You need to run the GUI first, because it creates the list and the folder.

Double click:

```
End Process! List.ahk
```

In the GUI:

- Click `+ Find Program` and pick a `.exe` file. Only the file name is saved, not the full path.
- Click `Remove Selected` to remove a program from the list.
- Click `DONE` to save and close.

When you click `DONE`, the GUI creates:

```
assets/config/Process List.txt
```

The GUI is centered on screen. The `X` on the top right only closes the GUI.

### 3. Close the programs

After you have a list, double click:

```
End Process!.ahk
```

It will close the programs in your list, one by one. Then it will play the system sound and close itself.

### 4. Check the log

After each run, you can check:

```
Documents\Log Files\End Process!.txt
```

The log shows, for each program:

- `NOT FOUND` - The program was not open.
- `FOUND` - The program was open.
- `CLOSED` - Closed with a soft close.
- `STILL RUNNING` - Still open after the soft close.
- `FORCE CLOSED` - Closed with a forced close.
- `PROCESS SUMMARY` - Total counts at the end.

Example:

```
[2026-11-20 15:10:08] Processes processed: 43
[2026-11-20 15:10:08] Processes found: 1
[2026-11-20 15:10:08] Processes closed: 1
[2026-11-20 15:10:08] Of those, force closed: 1
[2026-11-20 15:10:08] Processes still active: 0
```

---

## Notes for new users

### About the .exe version

The main version is the `.ahk` scripts. They are plain text, you can open them and read them.

An optional `.exe` version is only for users who know its source. New users may see a false positive from security tools because the `.exe` is made with AutoHotkey. The `.ahk` files are the clean version. Both `.ahk` files were checked on VirusTotal with a result of 0 / 60.

If you prefer, use only the `.ahk` files.

### About the sound

The tool uses a Windows system sound, `Windows Unlock.wav`, when it finishes. If that file is not on your Windows, it plays the default system sound instead. No extra sound file is needed.

### About closing system programs

If you add a system program like `explorer.exe`, your screen may go blank for a moment. Just restart your computer and it will come back. The tool only closes programs, it does not change Windows.

---

## Support

If this tool was useful for you, you can support the project here:

[Support on Ko-fi](https://ko-fi.com/palemoonx)

Thank you.

---

## License

Free for personal use. You can share it, with credit.
