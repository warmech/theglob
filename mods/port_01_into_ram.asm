;For some reason, the folks at EPOS decided to write into the subroutine that handles
;joystick/button detection a snippet of code that writes port $02's unmasked activity
;into memory at 0x7D62, but not include the same code in the subroutine that handles
;port $01. If the ROM checksum failure routine is bypassed, exactly nine bytes of
;code become available, one byte more than necessary to remedy this issue. To make
;these changes, overwrite 0x009C with CD 42 06 00 and overwrite 0x0642 with 32 C0 7D
;E6 C0 FE 80 C9 00. The new contents of 0x009C perform a CALL to the now diused
;checksum routine (plus a NOP to fill in an additional byte of unused space) and the
;new contents of 0x0642 load A into 0x7DC0 (port $02 having been loaded into A prior
;to the CALL instruction) and perform the two instructions that were overwritten at
;0x009C before the RET returns to 0x00A0.

;This may seem unnecessary, but it provides a static location in RAM that additional 
;mods can us to refer to port $01's status. Why is port $01 important? Observe the 
;following diagram, which indicates port $02's bitwise values:

;													1	1	1	1	1	1	1	1
;													-	-	D	U	B	A	L	R

;The two most significant bits are unused, but the other six represent up, down, left,
;right, jump (A), and action (B); as a note, all are active low and so the default byte
;value at 0x7D62 with no input detected is $FF. Missing from this list are P1 start, 
;P2 start, coin-in, and service; they are represented on port $01, indicated below:

;													1	1	1	1	1	1	1	1
;													-	-	-	S	2	1	-	$

;As the coin bit and bit six must be active high, the default byte value with no
;input detected is $BE, indicated below:

;													1	0	1	1	1	1	1	0
;													-	-	-	S	2	1	-	$

;With port $01's status written frequently into memory, a mod can use the rest of the
;game's control scheme as additional interface options (i.e. hold P1 start down for a
;few seconds to advance the level).

009C: CD 42 06    CALL $0642			;Push PC + $03 to the top of the stack then jump to 0x0642
009F: 00          NOP							;No operation

0642: 32 C0 7D    LD   ($7DC0),A	;Load A into address 7DC0h
0645: E6 C0       AND  $0C0				;Bitwise AND between A and 0C0h
0647: FE 80       CP   $80				;Subtracts 80h from A and affects flags according to the result - does not affect A
0649: C9          RET							;Pop the top stack entry into PC
064A: 00          NOP							;No operation