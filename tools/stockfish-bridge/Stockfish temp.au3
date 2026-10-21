

#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>

Local $iPID = Run("Stockfish.exe", "", 0, $STDIN_CHILD + $STDOUT_CHILD + $STDERR_CHILD)

StdinWrite($iPID, "uci" & @LF)
;sleep(500)

;msgbox(0, "", StdoutRead($iPID))

StdinWrite($iPID, "isready" & @LF)
;sleep(500)

;msgbox(0, "", StdoutRead($iPID))




StdinWrite($iPID, "position startpos moves e2e4 c7c5 g1f3" & @LF)

;sleep(500)

StdinWrite($iPID, "go movetime 3000" & @LF)

Local $sOutput = "" ; Store the output of StdoutRead to a variable.

While 1
	;msgbox(0, "", StdoutRead($iPID))

	$sOutput = StdoutRead($iPID) ; Read the Stdout stream of the PID returned by Run.

	If StringInStr($sOutput, "bestmove") Then
		ExitLoop

		;If @error Then ; Exit the loop if the process closes or StdoutRead returns an error.
		;		ExitLoop
	EndIf
WEnd

msgbox(0, "", $sOutput)


;StdinWrite($iPID, "position startpos moves e2e4 c7c5 g1f3 e7e6 h2h3" & @LF)
;sleep(500)

;StdinWrite($iPID, "go movetime 1000" & @LF)
;sleep(2000)

;msgbox(0, "", StdoutRead($iPID))





StdinWrite($iPID)
; & "position startpos moves e2e4" & @LF & "go movetime 2000" & @LF)

