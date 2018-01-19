;The unmodified contents of 0x0640 are 28 09, which is a conditional relative jump
;(jump on zero flag set) that adds $09 to the program counter from the start of the
;jump opcode (28). Making changes to the ROMs causes the zero flag to not be set
;and the jump to not occur. When the jump does not occur, the program code senses
;an invalid checksum and behaves accordingly. Changing the 28 opcode to a 18 opcode
;(non-conditional relative jump) neuters the zero flag check and advances the PC to
;the next checksum subroutine interation.

0640: 18 09       JR   $09				;Add $09 to PC