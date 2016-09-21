@ECHO OFF

:: MathLibrary.cmd
:: David Colborne - david@colbornemmx.com

:: https://github.com/Oatworm/MathLibrary.cmd
:: This project is licensed using the Simplified BSD license.
:: For additional details, see the LICENSE file on GitHub.

:: To use MathLibrary.cmd, simply call it:
:: 		MathLibrary.cmd 1 / 2
:: It will (eventually) return: 
:: 		0.5

:ExtUI
	:: Front-end for MathLibrary.
	:: Requires all subroutines listed here.
	:: Accepts three arguments, passed when script is called:
	:: %1 - First number
	:: %2 - Operation to be performed (+, -, *, /)
	:: %3 - Second number
	:: %4 - Result (optional - passed by reference)
	::
	:: Example invocation:
	:: CALL MathLibrary.cmd 1 + 2 _Result
	:: |--> Adds 1+2 and saves result in _Result

	SET _Num1=%1
	SET _Op=%2
	SET _Num2=%3
	SET _CmdResult=
	
	IF %_Op%==+ (
		CALL :ExtAdd %_Num1% %_Num2% _CmdResult
	)
	
	IF %_Op%==- (
		CALL :ExtSubtract %_Num1% %_Num2% _CmdResult
	)
	
	IF %_Op%==* (
		CALL :ExtMultiply %_Num1% %_Num2% _CmdResult
	)
	
	IF %_Op%==/ (
		CALL :ExtDivision %_Num1% %_Num2% _CmdResult
	)
	
	IF /I %_Op%==com (
		CALL :ExtCompare %_Num1% %_Num2% _CmdResult
	)
	
	IF NOT [%4]==[] (
		SET %4=%_CmdResult%
		GOTO :EOF
	)
	
	ECHO:%_CmdResult%

GOTO :EOF

:ExtDivision
	SETLOCAL EnableDelayedExpansion
	:: Used to divide arbitrary numbers together
	:: Requires - :ExtDim, :ExtMatchPad, :ExtUnDecimal, :ExtCompare, :ExtSubtract, :ExtAdd, :ExtPad
	:: Accepts three parameters:
	:: %1, %2 - The numerator and denominator, respectively (passed by value)
	:: %3 - The result (passed by reference)
	::
	:: Example invocation:
	:: CALL :ExtDivision %_Num1% %_Num2% _Result
	:: |--> Divides _Num1 by _Num2 and returns result in _Result
	
	SET _DivN=%1
	SET _DivD=%2
	SET _DivResult=
	SET _IntLen=1
	SET _DivNRtoL=0
	SET _DivDRtoL=0
	SET _DivNegFlag=0
	
	IF %_DivN:~0,1%==- (
		IF %_DivD:~0,1%==- (
			SET _DivN=%_DivN:~1%
			SET _DivD=%_DivD:~1%
		) ELSE (
			SET _DivN=%_DivN:~1%
			SET _DivNegFlag=1
		)
	) ELSE (
		IF %_DivD:~0,1%==- (
			SET _DivD=%_DivD:~1%
			SET _DivNegFlag=1
		)
	)

	CALL :ExtDim %_DivN% _DivNLen _DivNDec
	CALL :ExtDim %_DivD% _DivDLen _DivDDec
	
	IF %_DivNDec% LEQ %_DivNLen% (
		CALL :ExtUnDecimal _DivN %_DivNLen% %_DivNDec%
		SET /A _DivNRtoL=_DivNLen-_DivNDec
		SET _DivDecFlag=1
	)
	
	IF %_DivDDec% LEQ %_DivDLen% (
		CALL :ExtUnDecimal _DivD %_DivDLen% %_DivDDec%
		SET /A _DivDRtoL=_DivDLen-_DivDDec
		SET /A _DivD_L_1=_DivDLen-1
		SET /A _DivD_D_1=_DivD_L_1+1
		SET _DivDecFlag=1
	)
	
	:: Set max precision here!
	IF %_DivNLen% GEQ %_DivDLen% (
		SET /A _DivMaxPrec=_DivNLen+10
	) ELSE (
		SET /A _DivMaxPrec=_DivDLen+10
	)
	
	:: Multiplication is expensive - let's do it as little as needed.
	:: Meaning NEVER.	
	SET _DivD_1=%_DivD%
	IF NOT DEFINED _DivD_L_1 SET _DivD_L_1=%_DivDLen%
	IF NOT DEFINED _DivD_D_1 SET _DivD_D_1=%_DivDDec%
	SET _DivD_Prev=%_DivD%
	FOR /L %%G IN (2,1,9) DO (
		CALL :ExtAdd !_DivD_Prev! %_DivD% _DivD_%%G
		SET _DivD_Prev=!_DivD_%%G!
		CALL :ExtDim !_DivD_%%G! _DivD_L_%%G _DivD_D_%%G
	)
	
	:: Long division time...
	SET _DivLoop=0
	SET _DivCoef=
	SET _DivResDecPos=
	SET _DivCoef_L=0
	SET _DivCoef_D=1
	
	:ExtDivisionLoop
		IF %_DivLoop% GTR %_DivMaxPrec% GOTO ExtEndDivisionLoop
		SET _DivResCol=0
		CALL SET _DivCol=%%_DivN:~%_DivLoop%,%_IntLen%%%
		IF NOT DEFINED _DivCol (
			IF [%_DivCoef%]==[0] GOTO ExtEndDivisionLoop
			SET _DivCol=0
			SET _DivDecFlag=1
			IF NOT DEFINED _DivResDecPos SET /A _DivResDecPos=_DivLoop+1
		)
		IF NOT [%_DivCoef%]==[0] (
			SET _DivCoef=%_DivCoef%%_DivCol%
			SET /A _DivCoef_L+=1
			SET /A _DivCoef_D+=1
		) ELSE (
			SET _DivCoef=%_DivCol%
			SET /A _DivCoef_L=1
			SET /A _DivCoef_D=2
		)
		IF %_DivCoef% EQU 0 GOTO ExtContinueDivLoop
		FOR /L %%H IN (9,-1,0) DO (
			CALL :ExtCompare !_DivD_%%H! %_DivCoef% _DivInComp !_DivD_L_%%H! !_DivD_D_%%H! %_DivCoef_L% %_DivCoef_D%
			IF NOT !_DivInComp!==GTR (
				SET _DivResCol=%%H
				CALL :ExtSubtract %_DivCoef% !_DivD_%%H! _DivCoef
				CALL :ExtDim !_DivCoef! _DivCoef_L _DivCoef_D
				GOTO ExtContinueDivLoop
			)
		)
		:ExtContinueDivLoop
		SET _DivResult=%_DivResult%%_DivResCol%
		SET /A _DivLoop+=1
		GOTO ExtDivisionLoop
	:ExtEndDivisionLoop
	
	IF DEFINED _DivDecFlag (
		CALL :ExtDim %_DivResult% _DivResLen _DivResTmp
		IF NOT DEFINED _DivResDecPos SET /A _DivResDecPos=_DivResTmp
		SET /A "_DivResDecPos=_DivResDecPos-_DivNRtoL+_DivDRtoL"
		CALL :ExtReDecimal _DivResult _DivResLen !_DivResDecPos!
		SET /A _DivRightPad=_DivDRtoL-_DivNRtoL-_DivResLen+_DivDLen
		IF !_DivRightPad! GTR 0 (
			CALL :ExtPad _DivResult !_DivRightPad! R _DivResLen _DivResDecPos
		)
	) ELSE (
		CALL :ExtDim %_DivResult% _DivResLen _DivResTmp
	)

	:ExtDivStripLeadingZeroes
		SET _Zero=0
		SET _IntLen=2
		CALL SET _DivLInt=%%_DivResult:~%_Zero%,%_IntLen%%%
		SET _DivLInt0=%_DivLInt:~0,1%
		SET _DivLInt1=%_DivLInt:~1,1%
		IF NOT %_DivLInt0%==0 GOTO ExtDivDoneStrippingLeadingZeroes
		IF NOT DEFINED _DivLInt1 GOTO ExtDivDoneStrippingLeadingZeroes
		IF %_DivLInt1%==. GOTO ExtDivDoneStrippingLeadingZeroes
		SET /A _DivResLen-=1
		CALL SET _DivResult=%%_DivResult:~-%_DivResLen%%%
		GOTO ExtDivStripLeadingZeroes
	:ExtDivDoneStrippingLeadingZeroes
	
	:ExtDivisionReturnResult
	IF %_DivNegFlag%==1 SET _DivResult=-%_DivResult%
	ENDLOCAL & SET %3=%_DivResult%
GOTO :EOF

:ExtMultiply
	SETLOCAL EnableDelayedExpansion
	:: Used to multiply arbitrary numbers together
	:: Requires - :ExtDim, :ExtMatchPad, :ExtAdd, :ExtUnDecimal, :ExtReDecimal
	:: Accepts three parameters:
	:: %1, %2 - The two numbers being multipled (passed by value)
	:: %3 - The result (passed by reference)
	::
	:: Example invocation:
	:: CALL :ExtMultiply %_Num1% %_Num2% _Result
	:: |--> Multiplies _Num1 and _Num2 together, saves result in _Result
	
	SET _Mul1=%1
	SET _Mul2=%2
	SET _MulResult=0
	SET _MulCarry=0
	SET _IntLen=1
	SET _MulNegFlag=0
	
	IF %_Mul1:~0,1%==- (
		IF %_Mul2:~0,1%==- (
			SET _Mul1=%_Mul1:~1%
			SET _Mul2=%_Mul2:~1%
		) ELSE (
			SET _Mul1=%_Mul1:~1%
			SET _MulNegFlag=1
		)
	) ELSE (
		IF %_Mul2:~0,1%==- (
			SET _Mul2=%_Mul2:~1%
			SET _MulNegFlag=1
		)
	)
	
	CALL :ExtDim %_Mul1% _MulLen1 _MulDec1
	CALL :ExtDim %_Mul2% _MulLen2 _MulDec2
	
	IF %_MulDec1% LEQ %_MulLen1% (
		CALL :ExtUnDecimal _Mul1 %_MulLen1% %_MulDec1%
		SET /A _MulDecPos1=_MulLen1-_MulDec1
		SET _MulDecPos2=0
		SET /A _MulLen1-=1
		SET _MulDecFlag=1
	)
	
	IF %_MulDec2% LEQ %_MulLen2% (
		CALL :ExtUnDecimal _Mul2 %_MulLen2% %_MulDec2%
		SET /A _MulDecPos2=_MulLen2-_MulDec2
		IF NOT DEFINED _MulDecPos1 SET _MulDecPos1=0
		SET /A _MulLen2-=1
		SET _MulDecFlag=1
	)

	FOR /L %%G IN (%_MulLen1%,-1,1) DO (
		SET /A _BMulPos=%%G-1
		SET _MulColRes=
		SET _MulCarry=0
		SET /A _MulCol=%%G+1

		FOR /L %%H IN (!_MulCol!,1,%_MulLen1%) DO SET _MulColRes=0!_MulColRes!

		FOR /L %%I IN (%_MulLen2%,-1,1) DO (
			SET /A _TMulPos=%%I-1
			CALL SET _MulInt1=%%_Mul1:~!_BMulPos!,%_IntLen%%%
			CALL SET _MulInt2=%%_Mul2:~!_TMulPos!,%_IntLen%%%
			SET /A _MulByPos=_MulInt1*_MulInt2+_MulCarry
			IF !_MulByPos! GEQ 10 (
				SET _MulCarry=!_MulByPos:~0,1!
				SET _MulByPos=!_MulByPos:~1,1!
			) ELSE (
				SET _MulCarry=0
			)
			SET _MulColRes=!_MulByPos!!_MulColRes!
		)

		IF !_MulCarry! GTR 0 SET _MulColRes=!_MulCarry!!_MulColRes!
		CALL :ExtAdd !_MulColRes! !_MulResult! _MulResult
	)
	
	IF DEFINED _MulDecFlag (
		SET /A _MulDecPos=_MulDecPos1+_MulDecPos2
		CALL :ExtDim %_MulResult% _MulResLen _MulResDec
		SET /A _MulResDec=_MulResLen-_MulDecPos+1
		CALL :ExtReDecimal _MulResult _MulResLen !_MulResDec!
	)
	
	:ExtMultiplyReturnResult
	IF %_MulNegFlag%==1 SET _MulResult=-%_MulResult%
	ENDLOCAL & SET %3=%_MulResult%
GOTO :EOF

:ExtSubtract
	SETLOCAL EnableDelayedExpansion
	:: Used to subtract an arbitrary number from another
	:: Requires - :ExtMatchPad, :ExtDim, :ExtCompare
	:: Accepts three parameters:
	:: %1 - Minuend (passed by value)
	:: %2 - Subtrahend (passed by value)
	:: %3 - The result (passed by reference)
	::
	:: Example invocation:
	:: CALL :ExtSubtract %_Num1% %_Num2% _Result
	:: |--> Subtracts _Num2 from _Num1 and saves result in _Result

	SET _SubtractResult=
	SET _SubtractCarry=0
	SET _IntLen=1
	SET _SubNegChk1=%1
	SET _SubNegChk2=%2
	SET _SubtractNegSwap=0
	SET _Zero=0
	SET _One=1
	
	IF %_SubNegChk1:~0,1%==- (
		IF NOT %_SubNegChk2:~0,1%==- (
			SET _SubtractNegSwap=1
			SET _SubtractM=%_SubNegChk1:~1%
			SET _SubtractS=%_SubNegChk2%
			CALL :ExtAdd !_SubtractM! !_SubtractS! _SubtractResult
			GOTO ExtSubtractReturnResult
		) ELSE (
			CALL :ExtCompare %1 %2 _SubComResult
			IF !_SubComResult!==GTR (
				SET _SubtractM=%_SubNegChk2:~1%
				SET _SubtractS=%_SubNegChk1:~1%
			) ELSE (
				SET _SubtractM=%_SubNegChk1:~1%
				SET _SubtractS=%_SubNegChk2:~1%
				SET _SubtractNegSwap=1
			)
		)
	) ELSE (
		IF %_SubNegChk2:~0,1%==- (
			SET _SubtractM=%_SubNegChk1%
			SET _SubtractS=%_SubNegChk2:~1%
			CALL :ExtAdd !_SubtractM! !_SubtractS! _SubtractResult
			GOTO ExtSubtractReturnResult
		) ELSE (
			CALL :ExtCompare %1 %2 _SubComResult
			IF !_SubComResult!==LSS (
				SET _SubtractM=%2
				SET _SubtractS=%1
				SET _SubtractNegSwap=1
			) ELSE (
				SET _SubtractM=%1
				SET _SubtractS=%2
			)
		)
	)

	CALL :ExtDim %_SubtractM% _SubtractMLen _SubtractMDec
	CALL :ExtDim %_SubtractS% _SubtractSLen _SubtractSDec
	CALL :ExtMatchPad _SubtractM _SubtractS _SubtractLen _SubtractDec %_SubtractMLen% %_SubtractMDec% %_SubtractSLen% %_SubtractSDec%

	FOR /L %%G IN (%_SubtractLen%,-1,1) DO (
		SET /A _SubtractPos=%%G-1
		CALL SET _SubtractIntM=%%_SubtractM:~!_SubtractPos!,%_IntLen%%%
		CALL SET _SubtractIntS=%%_SubtractS:~!_SubtractPos!,%_IntLen%%%
		IF !_SubtractIntM!==. (
			SET _SubtractResult=.!_SubtractResult!
		) ELSE (
			SET /A _SubtractByPos=_SubtractIntM-_SubtractIntS-_SubtractCarry
			IF !_SubtractByPos! LSS 0 (
				SET _SubtractCarry=1
				SET /A _SubtractByPos+=10
			) ELSE (
				SET _SubtractCarry=0
			)
			SET _SubtractResult=!_SubtractByPos!!_SubtractResult!
		)
	)
	
	CALL :ExtDim %_SubtractResult% _SubtractResLen _SubtractResDec
	IF %_SubtractResDec% GTR %_SubtractResLen% GOTO ExtSubtractDoneStrippingTrailingZeroes
	:ExtSubtractStripTrailingZeroes
		SET /A _SubStripMax=_SubtractResLen-_SubtractResDec+1
		SET _SubStripOff=0
		FOR /L %%G IN (1,1,%_SubStripMax%) DO (
			SET _SubStripPos=%%G
			CALL SET _SubZChk=%%_SubtractResult:~-!_SubStripPos!,%_One%%%
			IF NOT !_SubZChk!==0 (
				GOTO ExtSubtractFoundTrailingZeroes
			) ELSE SET _SubStripOff=%%G
		)
	:ExtSubtractFoundTrailingZeroes
		IF %_SubZChk%==. SET /A _SubStripOff+=1
		CALL SET _SubtractResult=%%_SubtractResult:~%_Zero%,-%_SubStripOff%%%
    :ExtSubtractDoneStrippingTrailingZeroes
	
	:ExtSubtractStripLeadingZeroes
		CALL :ExtDim %_SubtractResult% _SubtractResLen _SubtractResDec
		IF %_SubtractResLen% GTR %_SubtractResDec% (
			SET /A _SubStripLoopLen=%_SubtractResDec%-2
		) ELSE SET /A _SubStripLoopLen=%_SubtractResLen%-1
		FOR /L %%G IN (0,1,%_SubStripLoopLen%) DO (
			SET _SubStripPos=%%G
			SET _SubStripOff=%%G
			CALL SET _SubZChk=%%_SubtractResult:~!_SubStripPos!,%_One%%%
			IF NOT !_SubZChk!==0 GOTO ExtSubtractFoundLeadingZeroes
		)
	:ExtSubtractFoundLeadingZeroes
		CALL SET _SubtractResult=%%_SubtractResult:~%_SubStripOff%%%
	:ExtSubtractDoneStrippingLeadingZeroes

	:ExtSubtractReturnResult
	IF %_SubtractNegSwap% EQU 1 SET _SubtractResult=-%_SubtractResult%

	ENDLOCAL & SET %3=%_SubtractResult%
GOTO :EOF

:ExtAdd
	SETLOCAL EnableDelayedExpansion
	:: Used to add two arbitrary numbers together.
	:: Requires - :ExtMatchPad, :ExtDim
	:: Accepts three parameters:
	:: %1, %2 - The numbers to be added together (passed by value)
	:: %3 - The result (passed by reference)
	::
	:: Example invocation:
	:: CALL :ExtAdd %_Num1% %_Num2% _Result
	:: |--> Sums _Num1 and _Num2 and saves result in _Result

	SET _Add1=%1
	SET _Add2=%2
	SET _AddResult=
	SET _AddCarry=0
	SET _IntLen=1
	SET _AddNegFlag=0
	
	IF %_Add1:~0,1%==- (
		IF %_Add2:~0,1%==- (
			SET _AddNegFlag=1
			SET _Add1=%_Add1:~1%
			SET _Add2=%_Add2:~1%
			GOTO ExtAddNums
		) ELSE (
			SET _Add1=%_Add1:~1%
			CALL :ExtSubtract %_Add2% !_Add1! _AddResult
			GOTO ExtAddReturnResult
		)
	) ELSE (
		IF %_Add2:~0,1%==- (
			SET _Add2=%_Add2:~1%
			CALL :ExtSubtract %_Add1% !_Add2! _AddResult
			GOTO ExtAddReturnResult
		)
	)
	
	:ExtAddNums
	CALL :ExtDim %_Add1% _Add1Len _Add1Dec
	CALL :ExtDim %_Add2% _Add2Len _Add2Dec
	CALL :ExtMatchPad _Add1 _Add2 _AddLen _AddDec %_Add1Len% %_Add1Dec% %_Add2Len% %_Add2Dec%

	FOR /L %%G IN (%_AddLen%,-1,1) DO (
		SET /A _AddPos=%%G-1
		CALL SET _AddInt1=%%_Add1:~!_AddPos!,%_IntLen%%%
		CALL SET _AddInt2=%%_Add2:~!_AddPos!,%_IntLen%%%
		IF !_AddInt1!==. (
			SET _AddResult=.!_AddResult!
		) ELSE (
			SET /A _AddByPos=_AddInt1+_AddInt2+_AddCarry
			IF !_AddByPos! GEQ 10 (
				SET _AddCarry=1
				SET /A _AddByPos-=10
			) ELSE (
				SET _AddCarry=0
			)
			SET _AddResult=!_AddByPos!!_AddResult!
		)
	)

	IF %_AddCarry% EQU 1 SET _AddResult=1%_AddResult%
	IF %_AddNegFlag% EQU 1 SET _AddResult=-%_AddResult%

	:ExtAddReturnResult
	ENDLOCAL & SET %3=%_AddResult%
GOTO :EOF

:ExtCompare
	SETLOCAL EnableDelayedExpansion
	:: Used to compare two numbers.
	:: Requires - :ExtDim, :ExtMatchPad
	:: Accepts the following parameters:
	:: %1, %2 - The numbers to compare, evaluated in order (passed by value)
	:: %3 - The result, returned as GTR, LSS, or EQU
	::
	:: Optional arguments:
	:: %4, %5 - Length and decimal position of %1
	:: %6, %7 - Length and decimal position of %2
	::
	:: Example invocation:
	:: CALL :ExtCompare %_Num1% %_Num2% _Result
	:: |--> If _Num1 is 1 and _Num2 is 3, returns LSS.
	:: |--> If _Num1 is 3 and _Num2 is 1, returns GTR
	:: |--> If _Num1 and _Num2 are both 3, returns EQU
	
	SET _Com1=%1
	SET _Com2=%2
	SET _ComLen=
	SET _IntLen=1
	SET _ComResult=EQU
	SET _ComNegFlag=0
	
	IF %_Com1:~0,1%==- (
		IF NOT %_Com2:~0,1%==- (
			SET _ComResult=LSS
			GOTO ExtCompareReturnResult
		) ELSE (
			SET _ComNegFlag=1
			SET _Com1=%_Com1:~1%
			SET _Com2=%_Com2:~1%
			GOTO ExtCompareCheck
		)
	)
	
	IF %_Com2:~0,1%==- (
		SET _ComResult=GTR
		GOTO ExtCompareReturnResult
	)
	
	:ExtCompareCheck
	IF NOT [%7]==[] (
		SET _Com2Len=%6
		SET _Com2Dec=%7
	) ELSE CALL :ExtDim %_Com2% _Com2Len _Com2Dec
	
	IF NOT [%5]==[] (
		SET _Com1Len=%4
		SET _Com1Dec=%5
	) ELSE CALL :ExtDim %_Com1% _Com1Len _Com1Dec
	
	SET /A _Com1IntLen=_Com1Len-_Com1Dec
	IF %_Com1IntLen%==-1 (SET _Com1IntLen=%_Com1Len%) ELSE (SET /A _Com1IntLen=_Com1Len-_Com1IntLen-1)
	SET /A _Com2IntLen=_Com2Len-_Com2Dec
	IF %_Com2IntLen%==-1 (SET _Com2IntLen=%_Com2Len%) ELSE (SET /A _Com2IntLen=_Com2Len-_Com2IntLen-1)
	
	IF %_Com1IntLen% GTR %_Com2IntLen% (
		SET _ComResult=GTR
		GOTO ExtCompareReturnResult
	)
	
	IF %_Com2IntLen% GTR %_Com1IntLen% (
		SET _ComResult=LSS
		GOTO ExtCompareReturnResult
	)
	
	CALL :ExtMatchPad _Com1 _Com2 _ComLen _ComDec %_Com1Len% %_Com1Dec% %_Com2Len% %_Com2Dec%
	
	FOR /L %%G IN (0,1,%_ComLen%) DO (
		SET /A _ComPos=%%G
		CALL SET _ComLInt=%%_Com1:~!_ComPos!,%_IntLen%%%
		CALL SET _ComRInt=%%_Com2:~!_ComPos!,%_IntLen%%%
		IF NOT !_ComLInt!==. (
			IF !_ComLInt! LSS !_ComRInt! (
				SET _ComResult=LSS
				GOTO ExtCompareCheckNeg
			)
			IF !_ComLInt! GTR !_ComRInt! (
				SET _ComResult=GTR
				GOTO ExtCompareCheckNeg
			)
		)
	)
	
	:ExtCompareCheckNeg
	IF %_ComNegFlag% EQU 1 (
		IF %_ComResult%==GTR SET _ComResult=LSS
		IF %_ComResult%==LSS SET _ComResult=GTR
	)
	
	:ExtCompareReturnResult
	ENDLOCAL & SET %3=%_ComResult%
GOTO :EOF

:ExtUnDecimal
	SETLOCAL EnableDelayedExpansion
	:: Used to strip decimal points out of numbers.
	:: Requires - :ExtDim
	:: Necessary for division and multiplication. See :ExtReDecimal.
	:: Accepts the following parameters:
	:: %1 - The number to strip (passed by reference)
	:: %2, %3 (Optional) - Length and Decimal position of the stripped number
	::
	:: Example invocation:
	:: CALL :ExtUnDecimal _Num1
	:: |--> If _Num1=123.45, returns 12345
	:: Note that you should store the decimal position for use in :ExtReDecimal
	:: elsewhere.
	
	SET _UnDNum=!%1!
	SET _UnDResult=
	SET _UnDLeft=
	SET _UnDRight=
	
	IF NOT [%3]==[] (
		SET _UnDLen=%2
		SET _UnDDec=%3
	) ELSE CALL :ExtDim %_UnDNum% _UnDLen _UnDDec
	
	IF %_UnDDec% LEQ %_UnDLen% (
		SET _UnD0=0
		SET /A _UnDLLen=_UnDDec-1
		SET /A _UnDRLen=_UnDLen-_UnDDec
		CALL SET _UnDLeft=%%_UnDNum:~!_UnD0!,!_UnDLLen!%%
		CALL SET _UnDRight=%%_UnDNum:~%_UnDDec%,!_UnDRLen!%%
		SET _UnDResult=!_UnDLeft!!_UnDRight!
	) ELSE (
		SET _UnDResult=!_UnDNum!
	)
	
	ENDLOCAL & SET %1=%_UnDResult%
GOTO :EOF

:ExtReDecimal
	SETLOCAL EnableDelayedExpansion
	:: Used to place a decimal point back into a number.
	:: Useful for proper decimal placement when multiplying or dividing.
	:: Accepts the following parameters:
	:: %1 - The number to place the decimal into (passed by reference)
	:: %2 - The length of the number string (passed by reference)
	:: %3 - The decimal position (passed by value, counting from the left)
	::
	:: Example invocation:
	:: CALL :ExtReDecimal _Num1 _NumLen 6
	:: |--> If _Num1=1234567, returns 12345.67 with a new length of 8.
	::
	:: Note that this subroutine assumes that the number being changed is 
	:: an integer - there's no error checking.
	
	SET _ReDNum=!%1!
	SET _ReDLen=!%2!
	SET /A _ReDPos=%3
	SET _ReDLeft=
	SET _ReDRight=
	SET _ReDResult=
	
	IF %_ReDPos% LEQ %_ReDLen% (
		SET _ReD0=0
		SET /A _ReDLLen=_ReDPos-1
		SET /A _ReDLen+=1
		CALL SET _ReDLeft=%%_ReDNum:~!_ReD0!,!_ReDLLen!%%
		CALL SET _ReDRight=%%_ReDNum:~!_ReDLLen!,!_ReDLen!%%
		SET _ReDResult=!_ReDLeft!.!_ReDRight!
	) ELSE (
		SET _ReDResult=!_ReDNum!
	)
	
	ENDLOCAL & SET %1=%_ReDResult%& SET %2=%_ReDLen%
GOTO :EOF

:ExtMatchPad
	SETLOCAL EnableDelayedExpansion
	:: Used to match length and decimal position of two number strings
	:: Requires - :ExtPad, :ExtDim
	:: Accepts the following parameters (passed by reference):
	:: %1, %2 - Two numbers to match
	:: %3, %4 - Length and decimal position of padded numbers.
	::
	:: Optionally accepts the following (passed by value)
	:: %5, %6 - Length and decimal position of %1
	:: %7, %8 - Length and decimal position of %2
	::
	:: Example invocation:
	:: CALL :ExtMatchPad _Num1 _Num2
	:: |--> Makes _Num1 and _Num2 have the same length
	::      and decimal position
	:: So, 1234.5 and 1.2345 become 1234.5000 and 0001.2345.

	SET _MatchPad1=!%1!
	SET _MatchPad2=!%2!
	SET _MatchPadL=
	SET _MatchPadD=
	
	IF NOT [%8]==[] (
		SET _MatchPadL2=%7
		SET _MatchPadD2=%8
	) ELSE CALL :ExtDim %_MatchPad2% _MatchPadL2 _MatchPadD2
	
	IF NOT [%6]==[] (
		SET _MatchPadL1=%5
		SET _MatchPadD1=%6
	) ELSE CALL :ExtDim %_MatchPad1% _MatchPadL1 _MatchPadD1


	:: Add a decimal if one number has a decimal and the other doesn't.
	IF %_MatchPadD1% GTR %_MatchPadL1% (
		IF %_MatchPadD2% LEQ %_MatchPadL2% (
			CALL :ExtMakeFloat _MatchPad1 _MatchPadL1
		)
	)
	IF %_MatchPadD2% GTR %_MatchPadL2% (
		IF %_MatchPadD1% LEQ %_MatchPadL1% (
			CALL :ExtMakeFloat _MatchPad2 _MatchPadL2
		)
	)
	
	:: Pad number strings so they both line up.
	IF %_MatchPadD1% GTR %_MatchPadD2% (
		SET /A "_DPadLen=_MatchPadD1-_MatchPadD2"
		CALL :ExtPad _MatchPad2 !_DPadLen! L _MatchPadL2 _MatchPadD2
		SET _MatchPadD=_MatchPadD1
	)
	IF %_MatchPadD2% GTR %_MatchPadD1% (
		SET /A "_DPadLen=_MatchPadD2-_MatchPadD1"
		CALL :ExtPad _MatchPad1 !_DPadLen! L _MatchPadL1 _MatchPadD1
		SET _MatchPadD=_MatchPadD2
	)

	IF %_MatchPadL1% GTR %_MatchPadL2% (
		SET /A _LPadLen=_MatchPadL1-_MatchPadL2
		CALL :ExtPad _MatchPad2 !_LPadLen! R _MatchPadL2 _MatchPadD2
		SET _MatchPadL=_MatchPadL1
	)
	IF %_MatchPadL2% GTR %_MatchPadL1% (
		SET /A _LPadLen=_MatchPadL2-_MatchPadL1
		CALL :ExtPad _MatchPad1 !_LPadLen! R _MatchPadL1 _MatchPadD1
		SET _MatchPadL=_MatchPadL2
	)
	
	IF NOT DEFINED _MatchPadL SET _MatchPadL=%_MatchPadL1%
	IF NOT DEFINED _MatchPadD SET _MatchPadD=%_MatchPadD1%

	ENDLOCAL & SET %1=%_MatchPad1%& SET %2=%_MatchPad2%& SET %3=%_MatchPadL%& SET %4=%_MatchPadD%
GOTO :EOF

:ExtMakeFloat
	SETLOCAL EnableDelayedExpansion
	:: Used to add a decimal point to a number string
	:: Accepts the following parameters:
	:: %1 - The variable that needs a decimal point
	::
	:: Example invocation:
	:: CALL :ExtMakeFloat _Num _Len
	:: |--> Returns _Num with a . at the end (1234 -> 1234.)
	:: |--> Automatically increments length by one.

	SET _FloatNum=!%1!
	SET /A _FloatLength=%2

	:: Only do this if we really need to...
	CALL :ExtDim %_FloatNum% _FloatLen _FloatDec
	IF %_FloatDec% GTR %_FloatLen% (
		SET _FloatNum=!_FloatNum!.
		SET /A _FloatLength+=1
	)
	
	ENDLOCAL & SET %1=%_FloatNum%& SET /A %2=%_FloatLength%
GOTO :EOF

:ExtPad
	SETLOCAL EnableDelayedExpansion
	:: Used to pad a number to facilitate mathematical operations
	:: Accepts the following parameters:
	:: %1 - The variable that needs to be padded
	:: %2 - The number of positions to pad
	:: %3 - The direction the pad needs to be applied (L or R)
	:: %4 - Length variable - Returned with padded length
	:: %5 - Decimal variable - Returned with adjusted position
	::
	:: Example invocation:
	:: CALL :ExtPad _Num 5 L _Len _Dec
	:: |--> Returns padded length and decimal position in _Len & _Dec.
	:: |--> Returns padded number back in _Num

	SET _PadNum=!%1!
	SET /A _PadLength=%4
	SET /A _PadDecimal=%5
	IF %3==L (
		FOR /L %%G IN (1,1,%2) DO (
			SET _PadNum=0!_PadNum!
			SET /A _PadLength+=1
			SET /A _PadDecimal+=1
		)
	)
	IF %3==R (
		FOR /L %%G IN (1,1,%2) DO (
			SET _PadNum=!_PadNum!0
			SET /A _PadLength+=1
		)
	)
	ENDLOCAL & SET %1=%_PadNum%& SET /A %4=%_PadLength% & SET /A %5=%_PadDecimal%
GOTO :EOF	

:ExtDim
	SETLOCAL EnableDelayedExpansion
	:: Used to get the string length and decimal position of a number.
	:: Accepts three parameters:
	:: %1 - The number that needs its size and precision
	:: %2 - A variable in which the size is returned
	:: %3 - A variable in which the position of the decimal is returned
	:: Returns length and decimal position by reference.
	::
	:: Example invocation:
	:: CALL :ExtDim %_Num% _Len _Dec
	
	SET _DimLength=0
	SET _DimDecimal=-1
	SET _DimArg=%1
	SET _DimPos=1
	:DimLoop
		CALL SET _DimLCheck=%%_DimArg:~%_DimLength%,%_DimPos%%%
		IF NOT DEFINED _DimLCheck GOTO ExitDimLoop
		SET /A _DimLength+=1
		IF %_DimLCheck%==. SET _DimDecimal=%_DimLength%
	GOTO DimLoop
	:ExitDimLoop
	IF %_DimDecimal% EQU -1 SET /A "_DimDecimal=_DimLength+1"
	ENDLOCAL & SET /A %2=%_DimLength% & SET /A %3=%_DimDecimal%
GOTO :EOF
