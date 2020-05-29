# csci-241-ch11-4
Random_Color_Char_Screen_Fill

The main purpose of this assignment is to reduce system I/O API calls
-The following two implementations are separated and independent methods with different ideas to result in the same display. Please choose one of the approaches you like, without mixing two ideas in one implementation:

Implementation One: Write a program that fills each screen cell with a random character, in a random color. The characters could be printable from ASCII code 20h (Space) to 07Ah (lower case z) without control characters. Assign a 50% probability that the color of any character will be red. Assign a 25% probability of green and 25% of yellow. Display 50 random characters a line and then show 20 lines as the following is expected:

ch11_04.png

Two procedures are suggested as below:
;-----------------------------------------------------------------------
ChooseColor PROC
; Selects a color with 50% probability of red, 25% green and 25% yellow
; Receives: nothing
; Returns:  AX = randomly selected color

;-----------------------------------------------------------------------
ChooseCharacter PROC
; Randomly selects an ASCII character, from ASCII code 20h to 07Ah
; Receives: nothing
; Returns:  AL = randomly selected character
Now, you can simply call them in a loop to set a color array bufColor and a char array bufChar selected. The requirement is to practice Windows API calls you just learned. So you can write the 50 random characters per line with
INVOKE WriteConsoleOutputAttribute, outHandle, ADDR bufColor, MAXCOL, xyPos, ADDR cellsWritten
INVOKE WriteConsoleOutputCharacter, outHandle, ADDR bufChar, MAXCOL, xyPos, ADDR cellsWritten
Implementation Two, (Non-loop for API call):
Suppose that your initial console window and screen buffer are both larger than 50 columns and 25 rows
Save current sizes of console window and screen buffer at the beginning by GetConsoleWindowInfo for later use
Use SetConsoleWindowInfo and SetConsoleScreenBufferSize to make the console to be exactly 50 columns wide
Write at once all 1000 (50 by 20) random colors/characters with above pair of API WriteConsoleOutputxxx
Very carefully prepare console and resume it including both screen buffer and console window.
Run ch11_04winBuf.exe to understand step by step.
- If you working on Windows 10, please go Properties/Layout tab to make sure the Wrap text output on resize unchecked:

imove win10 fixed
