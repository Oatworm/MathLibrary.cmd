@ECHO OFF
SETLOCAL EnableDelayedExpansion
:: Tests three strategies for de-octalizing a number in CMD:
:: 1. Append 1 at the beginning and use %% operator to extract decimal integer.
::		:TestModulus
:: 2. Use cascading if-then statements and string manipulation.
::		:TestIf
:: 3. Use a for loop to extract leading 0's.
::		:TestFor
::
:: All tests assume a 9-digit block since that is the largest that addition or subtraction
:: can be performed against. 

ECHO:Testing 1-digit block (000000001)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000001
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000001
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000001
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 2-digit block (000000012)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000012
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000012
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000012
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 3-digit block (000000123)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000123
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000123
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000000123
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 4-digit block (000001234)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000001234
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000001234
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000001234
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 5-digit block (000012345)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000012345
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000012345
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000012345
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 6-digit block (000123456)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000123456
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000123456
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=000123456
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 7-digit block (001234567)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=001234567
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=001234567
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=001234567
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 8-digit block (012345678)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=012345678
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=012345678
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=012345678
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing 9-digit block (123456789)...

SET _Mod1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=123456789
	CALL :TestModulus _Test1
)
SET _Mod1End=!time!

SET _If1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=123456789
	CALL :TestIf _Test1
)
SET _If1End=!time!

SET _For1Start=!time!
FOR /L %%G IN (1,1,1000) DO (
	SET _Test1=123456789
	CALL :TestFor _Test1
)
SET _For1End=!time!

SET _Mod1Elapsed=
SET _If1Elapsed=
SET _For1Elapsed=

CALL :CalcTime %_Mod1Start% %_Mod1End% _Mod1Elapsed
CALL :CalcTime %_If1Start% %_If1End% _If1Elapsed
CALL :CalcTime %_For1Start% %_For1End% _For1Elapsed
ECHO:Mod:%_Mod1Elapsed%
ECHO: If:%_If1Elapsed%
ECHO:For:%_For1Elapsed%

ECHO.
ECHO:Testing complete!
PAUSE

GOTO :EOF

:TestModulus
	SETLOCAL EnableDelayedExpansion
	:: Accepts one parameter:
	:: %1 - The digit to be de-octalized (passed by reference)
	
	SET _TestMod=1!%1!
	SET /A _TestMod=_TestMod %% 1000000000

	ENDLOCAL & SET %1=%_TestMod%
GOTO :EOF

:TestIf
	SETLOCAL EnableDelayedExpansion
	:: Accepts one parameter:
	:: %1 - The digit to be de-octalized (passed by reference)
	
	SET _TestIf=!%1!
	
	IF %_TestIf:~0,1%==0 (
		IF %_TestIf:~1,1%==0 (
			IF %_TestIf:~2,1%==0 (
				IF %_TestIf:~3,1%==0 (
					IF %_TestIf:~4,1%==0 (
						IF %_TestIf:~5,1%==0 (
							IF %_TestIf:~6,1%==0 (
								IF %_TestIf:~7,1%==0 (
									SET _TestIf=%_TestIf:~-1%
								) ELSE SET _TestIf=%_TestIf:~-2%
							) ELSE SET _TestIf=%_TestIf:~-3%
						) ELSE SET _TestIf=%_TestIf:~-4%
					) ELSE SET _TestIf=%_TestIf:~-5%
				) ELSE SET _TestIf=%_TestIf:~-6%
			) ELSE SET _TestIf=%_TestIf:~-7%
		) ELSE SET _TestIf=%_TestIf:~-8%
	)
	
	ENDLOCAL & SET %1=%_TestIf%
GOTO :EOF

:TestFor
	SETLOCAL EnableDelayedExpansion
	:: Accepts one parameter
	:: %1 - The digit to be deoctalized (passed by reference)
	
	SET _TestFor=!%1!
	FOR /L %%G IN (1,1,8) DO (
		SET _TestZero=!_TestFor:~0,1!
		IF !_TestZero!==0 (
			SET _TestFor=!_TestFor:~1!
		) ELSE GOTO TestForReturn
	)
	
	:TestForReturn
	ENDLOCAL & SET %1=%_TestFor%
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
	
	:: Get leading 0 out - if we don't, CMD will think we're doing math against
	:: an improperly formatted octal number and behave erratically.
	IF %_HEnd:~0,1% EQU 0 (
		SET _HEnd=%_HEnd:~1,1%
	)
	IF %_MEnd:~0,1% EQU 0 (
		SET _MEnd=%_MEnd:~1,1%
	)
	IF %_SEnd:~0,1% EQU 0 (
		SET _SEnd=%_SEnd:~1,1%
	)
	IF %_mSEnd:~0,1% EQU 0 (
		SET _mSEnd=%_mSEnd:~1,1%
	)
	
	IF %_HStart:~0,1% EQU 0 (
		SET _HStart=%_HStart:~1,1%
	)
	IF %_MStart:~0,1% EQU 0 (
		SET _MStart=%_MStart:~1,1%
	)
	IF %_SStart:~0,1% EQU 0 (
		SET _SStart=%_SStart:~1,1%
	)
	IF %_mSStart:~0,1% EQU 0 (
		SET _mSStart=%_mSStart:~1,1%
	)
	
	SET _mSElapsed=
	SET _SElapsed=
	SET _MElapsed=
	SET _HElapsed=
	SET _TimeElapsed=

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