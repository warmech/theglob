;These routines, when inserted into the game loop somewhere (ideally running every VBLANK),
;use the previous port $01 RAM mod to detect if the P1 start button has been pressed and,
;if it has, increment a counter. When the button has been pressed five times, the flag for
;ending the current level is set to $01 (TRUE) and the game ends the current level and
;begins the next one.

;This code is 42 bytes long, but may as well be 42 kilobytes; game code occupies every last
;discernable byte of space. Other, neutered routines will need to located and replaced
;before this can be implemented.

;7DC0h - PORT_STATUS
;7DC1h - UNUSED
;7DC2h - HIT_COUNTER
;7DC3h - PORT_FLAG
;7999h - LEVEL_END_FLAG

;----------------------------------- DETECTION ROUTINE -----------------------------------

----: 3A C0 7D    LD   A,($7DC0)	;Load PORT_STATUS into A
----: CB 57       BIT  $02,A			;Test bit $02 of PORT_STATUS for HI/LO
----: CA XX YY    JP   Z,(XXYYh)	;Jump to XXYYh if zero flag is set (TO: INCREMENT COUNTER)
----: 3E 00       LD   A,$00			;Load $00 into A
----: 32 C3 7D    LD   ($7DC3),A	;Load A into address 7DC3h to set PORT_FLAG to off

;----------------------------------- INCREMENT COUNTER -----------------------------------

----: 3A C3 7D    LD   A,($7DC3)	;Load PORT_FLAG into A
----: D6 00       SUB  $00				;Subtract $00 from A
----: 28 XX       JR   Z,XX				;Relative jump if zero flag is set

;.........................................................................................

----: 3A C2 7D    LD   A,($7DC2)	;Load HIT_COUNTER into A
----: FE 04       CP   $04				;Subtract $04 from A and affect flags
----: 20 XX       JR   NZ,XX			;Relative jump if zero flag is set (TO: LEVEL SKIP)
----: 3C          INC  A					;Increment A by $01
----: 32 C2 7D    LD   ($7DC2),A	;Load A into address 7DC2h to store the counter
----: 3E 0        LD   A,$00			;Load $01 into A
----: 32 C3 7D    LD   ($7DC3),A	;Load A into address 7DC3h to set PORT_FLAG

;--------------------------------------- LEVEL SKIP --------------------------------------

----: 3E 00       LD   A,$00			;Load $00 into A
----: 32 C2 7D    LD   ($7DC2),A	;Load A into address 7DC2h to reset HIT_COUNTER
----: 3E 01       LD   A,$01			;Load $01 into A
----: 32 99 79    LD   ($7999),A	;Load A into address 7999h to set LEVEL_END_FLAG