@ECHO OFF

:: Unit Test Library
:: Used to test and performance characteristics of MathLibrary.bat
:: Author: David Colborne
::   Date: 2014-12-01
:: Edited: 2014-12-01

:: Note - script assumes it's in the same directory as MathLibrary.bat

:: ****************************************
:: Identical Integers - Addition - No Carry
:: ****************************************
CALL :UnitTest 01 2 + 2 4
CALL :UnitTest 02 11 + 11 22
CALL :UnitTest 03 141 + 141 282
CALL :UnitTest 04 2431 + 2431 4862
CALL :UnitTest 05 14320 + 14320 28640
CALL :UnitTest 06 320140 + 320140 640280
CALL :UnitTest 07 2413142 + 2413142 4826284
CALL :UnitTest 08 44332211 + 44332211 88664422
CALL :UnitTest 09 102142230 + 102142230 204284460
CALL :UnitTest 10 2134031021 + 2134031021 4268062042
CALL :UnitTest 11 13420342110 + 13420342110 26840684220
CALL :UnitTest 12 333322224444 + 333322224444 666644448888
::CALL :UnitTest 13 
::CALL :UnitTest 14
::CALL :UnitTest 15
::CALL :UnitTest 16
::CALL :UnitTest 17
::CALL :UnitTest 18
::CALL :UnitTest 19
::CALL :UnitTest 20

:: ********************************
:: Identical Integers - Subtraction
:: ********************************

GOTO :EOF

:UnitTest
	SETLOCAL EnableDelayedExpansion
	
	SET _TestID=%1
	SET _Num1=%2
	SET _Op=%3
	SET _Num2=%4
	SET _UnitResult=
	SET _DesiredResult=%5
	SET _TimeElapsed=
	
	SET _TimeStart=!time!
	CALL MathLibrary.bat %_Num1% %_Op% %_Num2% _UnitResult
	SET _TimeEnd=!time!
	
	CALL :CalcTime %_TimeStart% %_TimeEnd% _TimeElapsed
	
	IF %_UnitResult%==%_DesiredResult% (
		ECHO:%_TestID% OK %_TimeEnd% %_TimeStart% %_TimeElapsed%
	) ELSE (
		ECHO:%_TestID% NO %_TimeEnd% %_TimeStart% %_TimeElapsed%
	)
	
GOTO :EOF

:CalcTime
	SETLOCAL EnableDelayedExpansion
	:: Calculates time elapsed between two given times.
	:: Assumes US location/time format
	:: Accepts three parameters:
	:: %1, %2 - Start, End times (passed by value)
	:: %3 - Time delta (returned by reference)
	::
	:: Example invocation:
	:: CALL :CalcTime 12:00:00.00 12:30:00.00 _Elapsed
	:: |--> Returns 00:30:00.00 in _Elapsed
	
	SET _Time1=%1
	SET _Time2=%2
	
	FOR /F "tokens=1-4 delims=:." %%G IN ("%_Time2%") DO (
		SET _HEnd=%%G
		SET _MEnd=%%H
		SET _SEnd=%%I
		SET _mSEnd=%%J
	)

	FOR /F "tokens=1-4 delims=:." %%K IN ("%_Time1%") DO (
		SET _HStart=%%K
		SET _MStart=%%L
		SET _SStart=%%M
		SET _mSStart=%%N
	)

	SET /A _mSElapsed=_mSEnd-_mSStart
	IF %_mSElapsed% LSS 0 (
		SET /A _SElapsed=-1
		SET /A _mSElapsed+=100
	)
	
	SET /A _SElapsed=_SEnd-_SStart+_SElapsed
	IF %_SElapsed% LSS 0 (
		SET /A _MElapsed=-1
		SET /A _SElapsed+=60
	)
	
	SET /A _MElapsed=_MEnd-_MStart+_MElapsed
	IF %_MElapsed% LSS 0 (
		SET /A _HElapsed=-1
		SET /A _MElapsed+=60
	)
	
	SET /A _HElapsed=_HEnd-_HStart+_HElapsed
	IF %_HElapsed% LSS 0 (
		SET /A _HElapsed+=24
	)
	
	SET _TimeElapsed=%_HElapsed%:%_MElapsed%:%_SElapsed%.%_mSElapsed%
	
	ENDLOCAL & SET %3=%_TimeElapsed%
GOTO :EOF