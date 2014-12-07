MathLibrary.cmd
===============

A collection of math subroutines written in Windows batch script. Includes floating point and large number support. 

MathLibrary.cmd was originally written to make it somewhat possible to solve Project Euler (https://projecteuler.net/) problems using Windows batch script (CMD) - this necessitated working floating point and large number support, neither of which is provided natively by Windows batch script. Usual workarounds in production environments for this issue involve piping output from other scripting languages, such as VBScript or PowerShell, into CMD, or just not solving complex math problems in a Windows batch script; both of these solutions are perfectly valid and reasonable. 

MathLibrary.cmd is _not_ a reasonable solution to these problems and should not be used in production by _anyone_. However, if you ever woke up and asked yourself, "Is it possible to get CMD to do floating point math on arbitrarily large numbers without leaving the CMD environment?", this project should answer that question in the affirmative. 

###VERSION HISTORY
* 0.0 (Initial Sync)
  * Addition, subtraction, multiplication and division of positive arbitrarily large floating point numbers.
  * Does the math like an elementary school student - slowly and column by column via string manipulation.

###TODO
* Finish UnitTest.cmd to facilitate easier troubleshooting.
* Add negative number support.
* Use CMD's built-in math abilities more efficiently. Namely...
  * Rewrite ExtAdd and ExtSubtract to use 8-digit blocks, instead of performing math column by column.
  * Rewrite ExtMultiply to use 4-digit blocks, instead of performing multiplication column by column.
  * Figure out a better way to handle division.
