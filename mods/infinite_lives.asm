;The unmodified contents of 0x1F91 are 35, which decrements, by $01, the contents
;of the address currently in HL. At 0x1F91's point of execution, HL contains the
;address of the current count of Player 1's lives. Changing this opcode to 00 will
;prevent the game from subtracting lives from Player 1.

1F91: 00          NOP							;No operation