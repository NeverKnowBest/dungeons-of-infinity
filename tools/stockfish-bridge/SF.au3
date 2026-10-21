#NoTrayIcon

#include <FileConstants.au3>
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>


$iPID = -1

While 1

	If FileExists("Command") Then

        Local $CommandArray = FileReadToArray("Command")
		Local $Commands = @extended

		FileDelete("Command")

		Select

			Case $CommandArray[0] = "OpenSF"
				$iPID = Run("Stockfish.exe", "", 0, $STDIN_CHILD + $STDOUT_CHILD + $STDERR_CHILD)

			case $CommandArray[0] = "UCI"
				SendSFCommand("uci", "uciok")
				SendResponse("uciok")

			case $CommandArray[0] = "Ready"
				SendSFCommand("isready", "readyok")
				SendResponse("readyok")

			case $CommandArray[0] = "Go"
				;array 1 = FEN
				;array 2 = depth
				SendSFCommand("position fen " & $CommandArray[1])
				Local $BestMove = SendSFCommand("go depth " & $CommandArray[2], "bestmove")
				SendResponse($BestMove)

			case $CommandArray[0] = "Exit"
				StdinWrite($iPID)
				Exit

		EndSelect





	EndIf

	sleep(10)

WEnd


Func SendSFCommand($C, $DesiredResponse = "")

	StdinWrite($iPID, $C & @LF)

	If $DesiredResponse <> "" Then

		Local $Output = "" ; Store the output of StdoutRead to a variable.

		While 1

			$Output = StdoutRead($iPID) ; Read the Stdout stream of the PID returned by Run.

			If StringInStr($Output, $DesiredResponse) Then
				return $Output
			EndIf

		WEnd
	EndIf

EndFunc

Func SendResponse($R)

	Local $ResponseFile = FileOpen("Response", $FO_OVERWRITE)
	FileWrite($ResponseFile, $R)
	FileClose($ResponseFile)

EndFunc
