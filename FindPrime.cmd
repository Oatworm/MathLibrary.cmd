@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: FindPrime.cmd
:: Used to test various prime number finding algorithms in CMD

SET _TimeElapsed1=
SET _TimeElapsed2=

:: Find primes up to...
SET _Max=10000

:: Algorithm 1
SET _TimeStart=!time!
FOR /L %%G IN (2,1,%_Max%) DO (
	IF NOT DEFINED _%%G (
		SET /A _Start=%%G+%%G
		FOR /L %%H IN (!_Start!,%%G,%_Max%) DO (
			SET _%%H=1
		)
		ECHO:%%G
	)
)
SET _TimeEnd=!time!
CALL :CalcTime %_TimeStart% %_TimeEnd% _TimeElapsed1

:: Algorithm 2
:: Used in Problem7.cmd
SET _TimeStart=!time!
SET _Count=1
SET _Check=1
SET _PHashCt=1

:Loop
SET /A _Check+=2
FOR /L %%G IN (1,1,%_PHashCt%) DO (
	SET /A _CheckMax=!_Check!/3
	IF DEFINED _PHash%%G (
		FOR %%H IN (!_PHash%%G!) DO (
			IF %%H LEQ !_CheckMax! (
				SET /A _PCheck = !_Check! %% %%H
				IF !_PCheck! EQU 0 GOTO Loop
			)
		)
	) 
)
SET /A _Count+=1
FOR /L %%I IN (1,1,%_PHashCt%) DO (
	IF %_Count% LSS %%I000 (
		IF DEFINED _PHash%%I (
			SET _PHash%%I=!_PHash%%I!,%_Check%
			GOTO Break
		) ELSE (
			SET _PHash%%I=%_Check%
			SET /A _PHashCt+=1
			GOTO Break
		)
	)
)

:Break
ECHO:%_Check%
IF %_Check% LSS %_Max% GOTO Loop
SET _TimeEnd=!time!
CALL :CalcTime %_TimeStart% %_TimeEnd% _TimeElapsed2

ECHO:1st:%_TimeElapsed1%
ECHO:2nd:%_TimeElapsed2%

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
