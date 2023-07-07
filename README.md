MathLibrary.cmd
===============

A collection of math subroutines written in Windows batch script. Includes floating point and large number support. 

MathLibrary.cmd was originally written to make it somewhat possible to solve Project Euler (https://projecteuler.net/) problems using Windows batch script (CMD) - this necessitated working floating point and large number support, neither of which is provided natively by Windows batch script. Usual workarounds in production environments for this issue involve piping output from other scripting languages, such as VBScript or PowerShell, into CMD, or just not solving complex math problems in a Windows batch script; both of these solutions are perfectly valid and reasonable. 

MathLibrary.cmd is _not_ a reasonable solution to these problems and should not be used in production by _anyone_. However, if you ever woke up and asked yourself, "Is it possible to get CMD to do floating point math on arbitrarily large numbers without leaving the CMD environment?", this project should answer that question in the affirmative. 

### HOW TO USE
There are two scripts in this repo:
* MathLibrary.cmd
  * This is the script that does all the math. To use it, type in the equation like so: `MathLibrary.cmd 1 + 2`. At the present time, it can also handle subtraction (`MathLibrary.cmd 2 - 1`), multiplication (`MathLibrary.cmd 2 * 1`), division (`MathLibrary.cmd 2 / 1`), and comparison (`MathLibrary.cmd 2 com 1`).
  * Subroutines in the script can be reused in other scripts. To do so, copy the desired subroutine and all subroutines below it and paste the resulting code into the other script.
* UnitTest.cmd
  * This is the script used to test MathLibrary.cmd's performance and accuracy. You can test individual functions by including the arithmetic symbol as an argument - for example, `UnitTest.cmd +` will run addition tests. If you supply no argument, it'll run all tests.

### VERSION HISTORY
* 0.4
  * First update in several years.
    * Accepts requested input in a single parameter instead of requiring multiple separate parameters (meaning "1+2" works just as well as "1 + 2").
      * As of 0.4.0, this works for +, -, *, and /, but does not work for COM.
    * CMD-style help text now included and displays automatically when invalid input is entered.
    * Release goal: Square roots!
* 0.3
  * This is the first release in which division is actually usable.
    * :ExtDivision no longer calls :ExtMultiply - instead, Divisor * (1-10) is handled by incrementing itself via :ExtAdd.
    * Removed extraneous calls to :ExtDim.
* 0.2
  * Significant performance improvements (up to 50%) for all arithmetic functions by removing repeated calls to :ExtDim and instead tracking length and decimal position arithmetically.
* 0.1
  * Added negative number support to all functions.
* 0.0 (Initial Sync)
  * Addition, subtraction, multiplication and division of positive arbitrarily large floating point numbers.
  * Does the math like an elementary school student - slowly and column by column via string manipulation.

### TODO
* Finish UnitTest.cmd to facilitate easier troubleshooting.
* Use CMD's built-in math abilities more efficiently. Namely...
  * Explore rewriting ExtAdd and ExtSubtract to use 8-digit blocks, instead of performing math column by column.
  * Rewrite ExtMultiply to use 4-digit blocks, instead of performing multiplication column by column.

### FURTHER DETAILS
For additional details, follow [my blog](http://blog.colbornemmx.com/ "Retroactive Ramblings"), especially the posts tagged [MathLibrary.cmd](http://blog.colbornemmx.com/search/label/MathLibrary.cmd "Retroactive Ramblings - MathLibrary.cmd").
