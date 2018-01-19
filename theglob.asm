0000: DB 01       IN   A,($01)		;Read SYSTEM port ($01) - for a normal system A will be loaded with $BE
0002: E6 C0       AND  $C0			;Bitwise AND on A - A should become $00
0004: FE 80       CP   $80			;I can only guess that this is to verify that the physical mask on bit 6 of port $01 is working correctly
0006: 28 01       JR   Z,$0009		;If the physical (as in, the copper trace on the PCB) mask is working, proceed with game code - otherwise...
0008: 76          HALT				;Crash and burn
0009: 06 00       LD   B,$00
000B: 31 FF 7F    LD   SP,$7FFF		;Initialize the stack
000E: CD AC 11    CALL $11AC		;GOSUB: DELAY_LOOP (I think it's a delay loop, at least)
0011: ED 56       IM   1			;Set INTERRUPT_MODE $01
0013: 97          SUB  A
0014: D3 01       OUT  ($01),A		
0016: 47          LD   B,A
0017: 0E 88       LD   C,$88
0019: 6F          LD   L,A
001A: 26 78       LD   H,$78
001C: 77          LD   (HL),A
001D: 23          INC  HL
001E: 10 FC       DJNZ $001C
0020: D3 00       OUT  ($00),A
0022: 0D          DEC  C
0023: 20 F7       JR   NZ,$001C
0025: 3C          INC  A
0026: 32 4B 7C    LD   ($7C4B),A
0029: 21 59 7D    LD   HL,$7D59
002C: 77          LD   (HL),A
002D: 23          INC  HL
002E: 77          LD   (HL),A
002F: 23          INC  HL
0030: 77          LD   (HL),A
0031: 3E FF       LD   A,$FF
0033: C3 42 01    JP   $0142
0036: 28 4E       JR   Z,$0086

;SUBROUTINE: INTERRUPT_MODE_01_HANDLER - This is the handler subroutine for IM1 (always located at 0x0038 for a Z80)

0038: F5          PUSH AF			;Handler always starts with a save sequence
0039: C5          PUSH BC
003A: D5          PUSH DE
003B: E5          PUSH HL
003C: DB 00       IN   A,($00)		;Read port $00 into A - the EPOS driver in MAME seems to indicate that this is the dipswitch/watchdog interface
003E: CB 7F       BIT  7,A			;Test bit 7 of A; set zero flag if true - If these are the DIP settings, this would be the switch for demo sounds
0040: 28 0A       JR   Z,$004C		;If demo sounds are enabled, jump to 0x004C, otherwise...
0042: 3A 8C 7C    LD   A,($7C8C)	;Store A (port $00 - DIP settings) into RAM
0045: FE 00       CP   $00
0047: 28 03       JR   Z,$004C
0049: 97          SUB  A
004A: 18 02       JR   $004E
004C: 3E 01       LD   A,$01		;Load $01 into A
004E: 32 5B 7D    LD   ($7D5B),A
0051: 21 59 7D    LD   HL,$7D59
0054: 97          SUB  A
0055: BE          CP   (HL)
0056: C4 98 00    CALL NZ,$0098
0059: 23          INC  HL
005A: BE          CP   (HL)
005B: C4 7C 00    CALL NZ,$007C
005E: 23          INC  HL
005F: BE          CP   (HL)
0060: C4 6A 09    CALL NZ,$096A
0063: CC 3B 09    CALL Z,$093B
0066: 23          INC  HL
0067: 35          DEC  (HL)
0068: 23          INC  HL
0069: 35          DEC  (HL)
006A: 23          INC  HL
006B: 36 00       LD   (HL),$00
006D: E1          POP  HL
006E: D1          POP  DE
006F: C1          POP  BC
0070: F1          POP  AF
0071: FB          EI
0072: C9          RET

;SUBROUTINE: READ_PLAYER_INPUT - Whole sub not used, CALLs usually start at 0x007C. This reads player input (not P1/P2 start buttons, though)

0073: FF          RST  $38
0074: FF          RST  $38
0075: 0B          DEC  BC
0076: 7C          LD   A,H
0077: 70          LD   (HL),B
0078: EA 05 F9    JP   PE,$F905
007B: 45          LD   B,L
007C: F5          PUSH AF			;This is where most CALLs land
007D: C5          PUSH BC
007E: 06 FF       LD   B,$FF
0080: 3A 62 7D    LD   A,($7D62)
0083: CB 57       BIT  2,A
0085: 20 02       JR   NZ,$0089
0087: 06 FB       LD   B,$FB
0089: CB 5F       BIT  3,A
008B: 20 02       JR   NZ,$008F
008D: 06 F7       LD   B,$F7
008F: DB 02       IN   A,($02)
0091: A0          AND  B
0092: 32 62 7D    LD   ($7D62),A
0095: C1          POP  BC
0096: F1          POP  AF
0097: C9          RET

0098: F5          PUSH AF
0099: E5          PUSH HL
009A: DB 01       IN   A,($01)
009C: E6 C0       AND  $C0
009E: FE 80       CP   $80
00A0: 28 03       JR   Z,$00A5
00A2: C3 08 00    JP   $0008
00A5: DB 01       IN   A,($01)
00A7: 2F          CPL
00A8: 47          LD   B,A
00A9: CB 47       BIT  0,A
00AB: CC C2 00    CALL Z,$00C2
00AE: 21 5C 7D    LD   HL,$7D5C
00B1: 97          SUB  A
00B2: BE          CP   (HL)
00B3: 20 05       JR   NZ,$00BA
00B5: CD 19 01    CALL $0119
00B8: 36 1E       LD   (HL),$1E
00BA: CB 60       BIT  4,B
00BC: C2 88 01    JP   NZ,$0188
00BF: E1          POP  HL
00C0: F1          POP  AF
00C1: C9          RET

00C2: F5          PUSH AF
00C3: C5          PUSH BC
00C4: 21 5B 7D    LD   HL,$7D5B
00C7: 36 01       LD   (HL),$01
00C9: 3A 60 7D    LD   A,($7D60)
00CC: FE 00       CP   $00
00CE: 28 46       JR   Z,$0116
00D0: 97          SUB  A
00D1: 32 60 7D    LD   ($7D60),A
00D4: 3A 8C 7C    LD   A,($7C8C)
00D7: FE 01       CP   $01
00D9: 28 07       JR   Z,$00E2
00DB: 3A 78 7D    LD   A,($7D78)
00DE: FE 01       CP   $01
00E0: 28 10       JR   Z,$00F2
00E2: CD 3B 09    CALL $093B
00E5: 3E 01       LD   A,$01
00E7: 32 B5 7C    LD   ($7CB5),A
00EA: 3E 04       LD   A,$04
00EC: 32 61 7D    LD   ($7D61),A
00EF: CD 53 0B    CALL $0B53
00F2: 3E 0F       LD   A,$0F
00F4: 32 5C 7D    LD   ($7D5C),A
00F7: DB 00       IN   A,($00)
00F9: E6 01       AND  $01
00FB: 21 65 7D    LD   HL,$7D65
00FE: FE 00       CP   $00
0100: 28 05       JR   Z,$0107
0102: 7E          LD   A,(HL)
0103: C6 01       ADD  A,$01
0105: 27          DAA
0106: 77          LD   (HL),A
0107: 7E          LD   A,(HL)
0108: C6 01       ADD  A,$01
010A: 27          DAA
010B: 77          LD   (HL),A
010C: 3A 5F 7D    LD   A,($7D5F)
010F: CB D7       SET  2,A
0111: 32 5F 7D    LD   ($7D5F),A
0114: D3 01       OUT  ($01),A
0116: C1          POP  BC
0117: F1          POP  AF
0118: C9          RET

0119: F5          PUSH AF
011A: C5          PUSH BC
011B: E5          PUSH HL
011C: 3E 01       LD   A,$01
011E: 32 60 7D    LD   ($7D60),A
0121: D3 03       OUT  ($03),A
0123: 21 5F 7D    LD   HL,$7D5F
0126: 0E F8       LD   C,$F8
0128: 3A 65 7D    LD   A,($7D65)
012B: FE 00       CP   $00
012D: 28 08       JR   Z,$0137
012F: 0E F9       LD   C,$F9
0131: FE 01       CP   $01
0133: 28 02       JR   Z,$0137
0135: 0E FB       LD   C,$FB
0137: 7E          LD   A,(HL)
0138: EE 03       XOR  $03
013A: 77          LD   (HL),A
013B: A1          AND  C
013C: D3 01       OUT  ($01),A
013E: E1          POP  HL
013F: C1          POP  BC
0140: F1          POP  AF
0141: C9          RET

0142: 32 62 7D    LD   ($7D62),A
0145: CD 3B 09    CALL $093B
0148: 21 F9 7B    LD   HL,$7BF9
014B: 36 00       LD   (HL),$00
014D: 23          INC  HL
014E: 36 01       LD   (HL),$01
0150: 23          INC  HL
0151: 36 00       LD   (HL),$00
0153: 23          INC  HL
0154: 36 0D       LD   (HL),$0D
0156: 23          INC  HL
0157: 36 0F       LD   (HL),$0F
0159: 23          INC  HL
015A: 36 02       LD   (HL),$02
015C: CD D2 05    CALL $05D2
015F: 0E 04       LD   C,$04
0161: CD 78 01    CALL $0178
0164: CD 00 05    CALL $0500
0167: 0E 02       LD   C,$02
0169: CD 78 01    CALL $0178
016C: CD EF 03    CALL $03EF
016F: 0E 03       LD   C,$03
0171: CD 78 01    CALL $0178
0174: FB          EI
0175: C3 53 21    JP   $2153
0178: 06 00       LD   B,$00
017A: CD AC 11    CALL $11AC
017D: 3A 7C 7C    LD   A,($7C7C)
0180: FE 00       CP   $00
0182: C8          RET  Z

0183: 41          LD   B,C
0184: F1          POP  AF
0185: C3 3F 02    JP   $023F
0188: F3          DI
0189: CD 3B 09    CALL $093B
018C: 06 00       LD   B,$00
018E: 97          SUB  A
018F: 32 5F 7D    LD   ($7D5F),A
0192: CD 45 12    CALL $1245
0195: CD D2 1A    CALL $1AD2
0198: FD 21 C9 06 LD   IY,$06C9
019C: DD 21 DC A1 LD   IX,$A1DC
01A0: CD 98 12    CALL $1298
01A3: FD 21 5D 02 LD   IY,$025D
01A7: DD 21 AA 85 LD   IX,$85AA
01AB: CD 93 12    CALL $1293
01AE: FD 21 AE 02 LD   IY,$02AE
01B2: DD 21 36 90 LD   IX,$9036
01B6: CD 93 12    CALL $1293
01B9: FD 21 C7 02 LD   IY,$02C7
01BD: DD 21 D6 9A LD   IX,$9AD6
01C1: CD 93 12    CALL $1293
01C4: 0E 00       LD   C,$00
01C6: DD 21 7E 8C LD   IX,$8C7E
01CA: C3 E7 01    JP   $01E7
01CD: D3 00       OUT  ($00),A
01CF: DB 02       IN   A,($02)
01D1: 2F          CPL
01D2: 4F          LD   C,A
01D3: FE 00       CP   $00
01D5: 28 F6       JR   Z,$01CD
01D7: CB 6F       BIT  5,A
01D9: 28 03       JR   Z,$01DE
01DB: 04          INC  B
01DC: 18 05       JR   $01E3
01DE: CB 67       BIT  4,A
01E0: 28 31       JR   Z,$0213
01E2: 05          DEC  B
01E3: 3E 07       LD   A,$07
01E5: A0          AND  B
01E6: 47          LD   B,A
01E7: 97          SUB  A
01E8: 32 F2 7B    LD   ($7BF2),A
01EB: FD 21 24 03 LD   IY,$0324
01EF: CD 93 12    CALL $1293
01F2: 11 FC FF    LD   DE,$FFFC
01F5: 78          LD   A,B
01F6: DD 21 82 8C LD   IX,$8C82
01FA: 3C          INC  A
01FB: DD 19       ADD  IX,DE
01FD: 3D          DEC  A
01FE: 20 FB       JR   NZ,$01FB
0200: 3E 0E       LD   A,$0E
0202: 32 F2 7B    LD   ($7BF2),A
0205: FD 21 24 03 LD   IY,$0324
0209: CD 93 12    CALL $1293
020C: C5          PUSH BC
020D: 06 70       LD   B,$70
020F: CD AC 11    CALL $11AC
0212: C1          POP  BC
0213: CB 51       BIT  2,C
0215: 28 B6       JR   Z,$01CD
0217: 78          LD   A,B
0218: FE 00       CP   $00
021A: CA 0A 07    JP   Z,$070A
021D: FE 01       CP   $01
021F: CC 40 03    CALL Z,$0340
0222: FE 02       CP   $02
0224: CC 00 05    CALL Z,$0500
0227: FE 03       CP   $03
0229: CC EF 03    CALL Z,$03EF
022C: FE 04       CP   $04
022E: CC D2 05    CALL Z,$05D2
0231: FE 05       CP   $05
0233: CC B3 03    CALL Z,$03B3
0236: FE 06       CP   $06
0238: CA 64 05    JP   Z,$0564
023B: FE 07       CP   $07
023D: 28 FE       JR   Z,$023D
023F: CD 45 02    CALL $0245
0242: C3 8E 01    JP   $018E
0245: F5          PUSH AF
0246: C5          PUSH BC
0247: DD 21 31 C5 LD   IX,$C531
024B: FD 21 26 03 LD   IY,$0326
024F: CD 93 12    CALL $1293
0252: DB 02       IN   A,($02)
0254: D3 00       OUT  ($00),A
0256: CB 57       BIT  2,A
0258: 20 F8       JR   NZ,$0252
025A: C1          POP  BC
025B: F1          POP  AF
025C: C9          RET

025D: 50          LD   D,B
025E: FF          RST  $38
025F: 04          INC  B
0260: 3C          INC  A
0261: 46          LD   B,(HL)
0262: 69          LD   L,C
0263: 14          INC  D
0264: 82          ADD  A,D
0265: FF          RST  $38
0266: 08          EX   AF,AF'
0267: 2D          DEC  L
0268: 46          LD   B,(HL)
0269: 78          LD   A,B
026A: 5A          LD   E,D
026B: 5F          LD   E,A
026C: 28 0A       JR   Z,$0278
026E: 32 82 FF    LD   ($FF82),A
0271: 04          INC  B
0272: 5F          LD   E,A
0273: 46          LD   B,(HL)
0274: 82          ADD  A,D
0275: 5A          LD   E,D
0276: 14          INC  D
0277: 37          SCF
0278: 14          INC  D
0279: 0A          LD   A,(BC)
027A: 5F          LD   E,A
027B: 82          ADD  A,D
027C: 5F          LD   E,A
027D: 14          INC  D
027E: 5A          LD   E,D
027F: 5F          LD   E,A
0280: 82          ADD  A,D
0281: FF          RST  $38
0282: 80          ADD  A,B
0283: FF          RST  $38
0284: 80          ADD  A,B
0285: 4B          LD   C,E
0286: 55          LD   D,L
0287: 14          INC  D
0288: 5A          LD   E,D
0289: 5A          LD   E,D
028A: 82          ADD  A,D
028B: FF          RST  $38
028C: 08          EX   AF,AF'
028D: 14          INC  D
028E: 41          LD   B,C
028F: 14          INC  D
0290: 55          LD   D,L
0291: 1E 78       LD   E,$78
0293: 82          ADD  A,D
0294: FF          RST  $38
0295: 04          INC  B
0296: 5F          LD   E,A
0297: 46          LD   B,(HL)
0298: 82          ADD  A,D
0299: 14          INC  D
029A: 41          LD   B,C
029B: 5F          LD   E,A
029C: 14          INC  D
029D: 55          LD   D,L
029E: 82          ADD  A,D
029F: 00          NOP
02A0: 41          LD   B,C
02A1: 0F          RRCA
02A2: 82          ADD  A,D
02A3: FF          RST  $38
02A4: 80          ADD  A,B
02A5: 14          INC  D
02A6: 73          LD   (HL),E
02A7: 28 5F       JR   Z,$0308
02A9: 82          ADD  A,D
02AA: 5F          LD   E,A
02AB: 14          INC  D
02AC: 5A          LD   E,D
02AD: 5F          LD   E,A
02AE: 18 8C       JR   $023C
02B0: FF          RST  $38
02B1: 80          ADD  A,B
02B2: 91          SUB  C
02B3: FF          RST  $38
02B4: 80          ADD  A,B
02B5: 96          SUB  (HL)
02B6: FF          RST  $38
02B7: 80          ADD  A,B
02B8: 9B          SBC  A,E
02B9: FF          RST  $38
02BA: 80          ADD  A,B
02BB: A0          AND  B
02BC: FF          RST  $38
02BD: 80          ADD  A,B
02BE: A5          AND  L
02BF: FF          RST  $38
02C0: 80          ADD  A,B
02C1: AA          XOR  D
02C2: FF          RST  $38
02C3: 80          ADD  A,B
02C4: AF          XOR  A
02C5: FF          RST  $38
02C6: 80          ADD  A,B
02C7: 5C          LD   E,H
02C8: 0A          LD   A,(BC)
02C9: 64          LD   H,H
02CA: 55          LD   D,L
02CB: 55          LD   D,L
02CC: 14          INC  D
02CD: 41          LD   B,C
02CE: 5F          LD   E,A
02CF: 82          ADD  A,D
02D0: 5A          LD   E,D
02D1: 14          INC  D
02D2: 5F          LD   E,A
02D3: 5F          LD   E,A
02D4: 28 41       JR   Z,$0317
02D6: 1E 5A       LD   E,$5A
02D8: FF          RST  $38
02D9: 80          ADD  A,B
02DA: 0A          LD   A,(BC)
02DB: 46          LD   B,(HL)
02DC: 37          SCF
02DD: 46          LD   B,(HL)
02DE: 55          LD   D,L
02DF: 82          ADD  A,D
02E0: 5F          LD   E,A
02E1: 00          NOP
02E2: 05          DEC  B
02E3: 37          SCF
02E4: 14          INC  D
02E5: 82          ADD  A,D
02E6: FF          RST  $38
02E7: 80          ADD  A,B
02E8: 5A          LD   E,D
02E9: 0A          LD   A,(BC)
02EA: 55          LD   D,L
02EB: 00          NOP
02EC: 5F          LD   E,A
02ED: 0A          LD   A,(BC)
02EE: 23          INC  HL
02EF: 4B          LD   C,E
02F0: 00          NOP
02F1: 0F          RRCA
02F2: 82          ADD  A,D
02F3: 55          LD   D,L
02F4: 00          NOP
02F5: 3C          INC  A
02F6: FF          RST  $38
02F7: 80          ADD  A,B
02F8: 69          LD   L,C
02F9: 28 0F       JR   Z,$030A
02FB: 14          INC  D
02FC: 46          LD   B,(HL)
02FD: 82          ADD  A,D
02FE: 55          LD   D,L
02FF: 00          NOP
0300: 3C          INC  A
0301: FF          RST  $38
0302: 80          ADD  A,B
0303: 55          LD   D,L
0304: 46          LD   B,(HL)
0305: 3C          INC  A
0306: FF          RST  $38
0307: 80          ADD  A,B
0308: 0A          LD   A,(BC)
0309: 46          LD   B,(HL)
030A: 41          LD   B,C
030B: 69          LD   L,C
030C: 14          INC  D
030D: 55          LD   D,L
030E: 1E 14       LD   E,$14
0310: 41          LD   B,C
0311: 0A          LD   A,(BC)
0312: 14          INC  D
0313: FF          RST  $38
0314: 80          ADD  A,B
0315: 05          DEC  B
0316: 64          LD   H,H
0317: 5F          LD   E,A
0318: 5F          LD   E,A
0319: 46          LD   B,(HL)
031A: 41          LD   B,C
031B: 5A          LD   E,D
031C: FF          RST  $38
031D: 80          ADD  A,B
031E: 14          INC  D
031F: 73          LD   (HL),E
0320: 28 5F       JR   Z,$0381
0322: FF          RST  $38
0323: 80          ADD  A,B
0324: 01 CD 19    LD   BC,$19CD
0327: FF          RST  $38
0328: 03          INC  BC
0329: 23          INC  HL
032A: 28 5F       JR   Z,$038B
032C: 82          ADD  A,D
032D: FF          RST  $38
032E: 0E 14       LD   C,$14
0330: 41          LD   B,C
0331: 14          INC  D
0332: 55          LD   D,L
0333: 1E 78       LD   E,$78
0335: FF          RST  $38
0336: 80          ADD  A,B
0337: FF          RST  $38
0338: 03          INC  BC
0339: 5F          LD   E,A
033A: 46          LD   B,(HL)
033B: 82          ADD  A,D
033C: 14          INC  D
033D: 73          LD   (HL),E
033E: 28 5F       JR   Z,$039F
0340: F5          PUSH AF
0341: C5          PUSH BC
0342: 0E 02       LD   C,$02
0344: 06 10       LD   B,$10
0346: 97          SUB  A
0347: 5F          LD   E,A
0348: 57          LD   D,A
0349: CD 45 12    CALL $1245
034C: 32 F3 7B    LD   ($7BF3),A
034F: FE 00       CP   $00
0351: 20 23       JR   NZ,$0376
0353: 79          LD   A,C
0354: 07          RLCA
0355: 07          RLCA
0356: 07          RLCA
0357: E6 08       AND  $08
0359: D3 01       OUT  ($01),A
035B: 3E 0F       LD   A,$0F
035D: 32 F2 7B    LD   ($7BF2),A
0360: DD 21 60 A4 LD   IX,$A460
0364: 79          LD   A,C
0365: FE 02       CP   $02
0367: FD 21 E4 06 LD   IY,$06E4
036B: 28 04       JR   Z,$0371
036D: FD 21 EF 06 LD   IY,$06EF
0371: CD 98 12    CALL $1298
0374: 18 14       JR   $038A
0376: DD 21 A0 B9 LD   IX,$B9A0
037A: C5          PUSH BC
037B: 97          SUB  A
037C: 32 F2 7B    LD   ($7BF2),A
037F: 32 80 7C    LD   ($7C80),A
0382: 7A          LD   A,D
0383: CD B4 10    CALL $10B4
0386: CD C1 10    CALL $10C1
0389: C1          POP  BC
038A: C5          PUSH BC
038B: 06 C8       LD   B,$C8
038D: CD AC 11    CALL $11AC
0390: C1          POP  BC
0391: 05          DEC  B
0392: 28 0C       JR   Z,$03A0
0394: 3E 01       LD   A,$01
0396: 82          ADD  A,D
0397: 27          DAA
0398: 57          LD   D,A
0399: 3E 11       LD   A,$11
039B: 83          ADD  A,E
039C: 5F          LD   E,A
039D: C3 49 03    JP   $0349
03A0: 0D          DEC  C
03A1: C2 44 03    JP   NZ,$0344
03A4: 97          SUB  A
03A5: 32 F3 7B    LD   ($7BF3),A
03A8: CD 45 12    CALL $1245
03AB: D3 01       OUT  ($01),A
03AD: CD D2 1A    CALL $1AD2
03B0: C1          POP  BC
03B1: F1          POP  AF
03B2: C9          RET

03B3: F5          PUSH AF
03B4: D9          EXX
03B5: 97          SUB  A
03B6: CD 45 12    CALL $1245
03B9: FD 21 00 80 LD   IY,$8000
03BD: 26 EC       LD   H,$EC
03BF: 11 0D 00    LD   DE,$000D
03C2: 0E 0B       LD   C,$0B
03C4: FD 36 00 07 LD   (IY+$00),$07
03C8: FD 19       ADD  IY,DE
03CA: 0D          DEC  C
03CB: 20 F7       JR   NZ,$03C4
03CD: 11 F9 FF    LD   DE,$FFF9
03D0: FD 19       ADD  IY,DE
03D2: 25          DEC  H
03D3: 20 EA       JR   NZ,$03BF
03D5: 21 00 80    LD   HL,$8000
03D8: 16 88       LD   D,$88
03DA: CB 7C       BIT  7,H
03DC: 28 0E       JR   Z,$03EC
03DE: 36 77       LD   (HL),$77
03E0: 23          INC  HL
03E1: 15          DEC  D
03E2: 20 F6       JR   NZ,$03DA
03E4: 01 38 0C    LD   BC,$0C38
03E7: 09          ADD  HL,BC
03E8: CB 7C       BIT  7,H
03EA: 20 EC       JR   NZ,$03D8
03EC: D9          EXX
03ED: F1          POP  AF
03EE: C9          RET

03EF: F5          PUSH AF
03F0: C5          PUSH BC
03F1: CD 76 04    CALL $0476
03F4: 97          SUB  A
03F5: 32 7C 7C    LD   ($7C7C),A
03F8: CD 45 12    CALL $1245
03FB: CD D2 1A    CALL $1AD2
03FE: 32 F3 7B    LD   ($7BF3),A
0401: FD 21 2F 04 LD   IY,$042F
0405: DD 21 2C A7 LD   IX,$A72C
0409: CD 98 12    CALL $1298
040C: FD 21 F0 04 LD   IY,$04F0
0410: DD 21 97 95 LD   IX,$9597
0414: 21 00 80    LD   HL,$8000
0417: 11 BC 7C    LD   DE,$7CBC
041A: CD 3B 04    CALL $043B
041D: FD 21 F8 04 LD   IY,$04F8
0421: DD 21 B7 CA LD   IX,$CAB7
0425: 21 01 80    LD   HL,$8001
0428: 13          INC  DE
0429: CD 3B 04    CALL $043B
042C: C1          POP  BC
042D: F1          POP  AF
042E: C9          RET

042F: 0B          DEC  BC
0430: FF          RST  $38
0431: 07          RLCA
0432: 16 09       LD   D,$09
0434: 04          INC  B
0435: 05          DEC  B
0436: 0F          RRCA
0437: 00          NOP
0438: 12          LD   (DE),A
0439: 01 0D 22    LD   BC,$220D
043C: B9          CP   C
043D: 7C          LD   A,H
043E: 06 01       LD   B,$01
0440: DD E5       PUSH IX
0442: D5          PUSH DE
0443: CD D9 04    CALL $04D9
0446: FD 23       INC  IY
0448: 11 B8 03    LD   DE,$03B8
044B: DD 19       ADD  IX,DE
044D: D1          POP  DE
044E: FD E5       PUSH IY
0450: FD 21 5B 06 LD   IY,$065B
0454: 1A          LD   A,(DE)
0455: A0          AND  B
0456: FE 00       CP   $00
0458: 28 09       JR   Z,$0463
045A: FD 21 5E 06 LD   IY,$065E
045E: 3E 01       LD   A,$01
0460: 32 7C 7C    LD   ($7C7C),A
0463: CD 93 12    CALL $1293
0466: FD E1       POP  IY
0468: DD E1       POP  IX
046A: D5          PUSH DE
046B: 11 FA FF    LD   DE,$FFFA
046E: DD 19       ADD  IX,DE
0470: D1          POP  DE
0471: CB 20       SLA  B
0473: 20 CB       JR   NZ,$0440
0475: C9          RET

0476: F5          PUSH AF
0477: C5          PUSH BC
0478: E5          PUSH HL
0479: 97          SUB  A
047A: 21 BC 7C    LD   HL,$7CBC
047D: 77          LD   (HL),A
047E: 23          INC  HL
047F: 77          LD   (HL),A
0480: 21 00 80    LD   HL,$8000
0483: CD 8E 04    CALL $048E
0486: 23          INC  HL
0487: CD 8E 04    CALL $048E
048A: E1          POP  HL
048B: C1          POP  BC
048C: F1          POP  AF
048D: C9          RET

048E: 3E FF       LD   A,$FF
0490: 0E 10       LD   C,$10
0492: CD 21 12    CALL $1221
0495: 06 FF       LD   B,$FF
0497: CD A0 04    CALL $04A0
049A: 06 00       LD   B,$00
049C: CD A0 04    CALL $04A0
049F: C9          RET

04A0: E5          PUSH HL
04A1: D5          PUSH DE
04A2: 11 40 00    LD   DE,$0040
04A5: 7E          LD   A,(HL)
04A6: D3 00       OUT  ($00),A
04A8: B8          CP   B
04A9: C4 BF 04    CALL NZ,$04BF
04AC: 78          LD   A,B
04AD: 2F          CPL
04AE: 77          LD   (HL),A
04AF: 23          INC  HL
04B0: CB FC       SET  7,H
04B2: 77          LD   (HL),A
04B3: 23          INC  HL
04B4: 15          DEC  D
04B5: C2 A5 04    JP   NZ,$04A5
04B8: 1D          DEC  E
04B9: C2 A5 04    JP   NZ,$04A5
04BC: D1          POP  DE
04BD: E1          POP  HL
04BE: C9          RET

04BF: 4F          LD   C,A
04C0: 78          LD   A,B
04C1: E5          PUSH HL
04C2: D5          PUSH DE
04C3: FE 00       CP   $00
04C5: 79          LD   A,C
04C6: 28 01       JR   Z,$04C9
04C8: 2F          CPL
04C9: F5          PUSH AF
04CA: 7D          LD   A,L
04CB: 21 BC 7C    LD   HL,$7CBC
04CE: E6 01       AND  $01
04D0: 28 01       JR   Z,$04D3
04D2: 23          INC  HL
04D3: F1          POP  AF
04D4: B6          OR   (HL)
04D5: 77          LD   (HL),A
04D6: D1          POP  DE
04D7: E1          POP  HL
04D8: C9          RET

04D9: C5          PUSH BC
04DA: 3E 07       LD   A,$07
04DC: 32 F2 7B    LD   ($7BF2),A
04DF: 21 31 17    LD   HL,$1731
04E2: CD 67 16    CALL $1667
04E5: FD 7E 00    LD   A,(IY+$00)
04E8: CD B4 10    CALL $10B4
04EB: CD F5 10    CALL $10F5
04EE: C1          POP  BC
04EF: C9          RET

04F0: 51          LD   D,C
04F1: 50          LD   D,B
04F2: 31 52 33    LD   SP,$3352
04F5: 48          LD   C,B
04F6: 49          LD   C,C
04F7: 32 53 54    LD   ($5453),A
04FA: 55          LD   D,L
04FB: 34          INC  (HL)
04FC: 57          LD   D,A
04FD: 36 56       LD   (HL),$56
04FF: 35          DEC  (HL)
0500: F5          PUSH AF
0501: C5          PUSH BC
0502: 97          SUB  A
0503: 32 7C 7C    LD   ($7C7C),A
0506: CD 45 12    CALL $1245
0509: CD D2 1A    CALL $1AD2
050C: FD 21 D7 06 LD   IY,$06D7
0510: DD 21 84 A4 LD   IX,$A484
0514: CD 98 12    CALL $1298
0517: DD 21 CC B3 LD   IX,$B3CC
051B: FD 21 47 05 LD   IY,$0547
051F: CD D9 04    CALL $04D9
0522: 21 00 78    LD   HL,$7800
0525: 0E 08       LD   C,$08
0527: 45          LD   B,L
0528: CD 48 05    CALL $0548
052B: 01 B8 03    LD   BC,$03B8
052E: DD 09       ADD  IX,BC
0530: FD 21 5B 06 LD   IY,$065B
0534: FE 00       CP   $00
0536: 28 09       JR   Z,$0541
0538: FD 21 5E 06 LD   IY,$065E
053C: 3E 01       LD   A,$01
053E: 32 7C 7C    LD   ($7C7C),A
0541: CD 93 12    CALL $1293
0544: C1          POP  BC
0545: F1          POP  AF
0546: C9          RET

0547: 12          LD   (DE),A
0548: 56          LD   D,(HL)
0549: 36 00       LD   (HL),$00
054B: 7E          LD   A,(HL)
054C: FE 00       CP   $00
054E: 20 11       JR   NZ,$0561
0550: 35          DEC  (HL)
0551: 7E          LD   A,(HL)
0552: FE FF       CP   $FF
0554: 20 0B       JR   NZ,$0561
0556: 72          LD   (HL),D
0557: 23          INC  HL
0558: 10 EE       DJNZ $0548
055A: D3 00       OUT  ($00),A
055C: 0D          DEC  C
055D: 20 E9       JR   NZ,$0548
055F: 97          SUB  A
0560: C9          RET

0561: 3E FF       LD   A,$FF
0563: C9          RET

0564: F5          PUSH AF
0565: C5          PUSH BC
0566: 97          SUB  A
0567: CD 45 12    CALL $1245
056A: CD D2 1A    CALL $1AD2
056D: FD 21 69 06 LD   IY,$0669
0571: DD 21 96 85 LD   IX,$8596
0575: CD 93 12    CALL $1293
0578: FD 21 BA 06 LD   IY,$06BA
057C: DD 21 34 9F LD   IX,$9F34
0580: CD 98 12    CALL $1298
0583: DD 21 21 C4 LD   IX,$C421
0587: FD 21 26 03 LD   IY,$0326
058B: CD 93 12    CALL $1293
058E: 97          SUB  A
058F: D3 06       OUT  ($06),A
0591: 3E 80       LD   A,$80
0593: D3 02       OUT  ($02),A
0595: 3E 01       LD   A,$01
0597: D3 06       OUT  ($06),A
0599: D3 02       OUT  ($02),A
059B: 3E 07       LD   A,$07
059D: D3 06       OUT  ($06),A
059F: 3E FE       LD   A,$FE
05A1: D3 02       OUT  ($02),A
05A3: 3E 08       LD   A,$08
05A5: D3 06       OUT  ($06),A
05A7: 97          SUB  A
05A8: D3 02       OUT  ($02),A
05AA: DB 02       IN   A,($02)
05AC: D3 00       OUT  ($00),A
05AE: 2F          CPL
05AF: CB 57       BIT  2,A
05B1: 20 17       JR   NZ,$05CA
05B3: FE 00       CP   $00
05B5: 28 04       JR   Z,$05BB
05B7: 3E 0F       LD   A,$0F
05B9: 18 0B       JR   $05C6
05BB: DB 01       IN   A,($01)
05BD: 2F          CPL
05BE: E6 0C       AND  $0C
05C0: FE 00       CP   $00
05C2: 28 02       JR   Z,$05C6
05C4: 18 F1       JR   $05B7
05C6: D3 02       OUT  ($02),A
05C8: 18 E0       JR   $05AA
05CA: 97          SUB  A
05CB: D3 02       OUT  ($02),A
05CD: C1          POP  BC
05CE: F1          POP  AF
05CF: C3 8E 01    JP   $018E
05D2: F5          PUSH AF
05D3: C5          PUSH BC
05D4: 97          SUB  A
05D5: 32 7C 7C    LD   ($7C7C),A
05D8: CD 45 12    CALL $1245
05DB: CD D2 1A    CALL $1AD2
05DE: FD 21 AC 06 LD   IY,$06AC
05E2: DD 21 DC A1 LD   IX,$A1DC
05E6: CD 98 12    CALL $1298
05E9: 06 08       LD   B,$08
05EB: DD 21 4A 90 LD   IX,$904A
05EF: FD 21 53 06 LD   IY,$0653
05F3: DD E5       PUSH IX
05F5: CD D9 04    CALL $04D9
05F8: DD E1       POP  IX
05FA: 11 F8 FF    LD   DE,$FFF8
05FD: DD 19       ADD  IX,DE
05FF: FD 23       INC  IY
0601: 10 F0       DJNZ $05F3
0603: DD 21 92 9D LD   IX,$9D92
0607: FD 21 73 00 LD   IY,$0073
060B: 21 00 70    LD   HL,$7000		;Load mask for ROM 11, as it is checksummed first
060E: 0E 08       LD   C,$08		;Load range for ROM 11 (0x0800 = 2048 bytes)
0610: 45          LD   B,L
0611: CD 26 06    CALL $0626		;GOSUB: CHECKSUM
0614: 06 07       LD   B,$07
0616: 21 00 00    LD   HL,$0000		;Load mask for ROM 10 (all subsequent ROM masks increment from 0 to 6)
0619: C5          PUSH BC
061A: 01 10 00    LD   BC,$0010		;Load range for ROM 11 (0x1000 = 4096 bytes)
061D: CD 26 06    CALL $0626		;GOSUB: CHECKSUM
0620: C1          POP  BC
0621: 10 F6       DJNZ $0619
0623: C1          POP  BC
0624: F1          POP  AF
0625: C9          RET

;SUBROUTINE: CHECKSUM - Perform ROM checksums

0626: 3E 07       LD   A,$07		;Initialize the ROM counter
0628: 32 F2 7B    LD   ($7BF2),A
062B: 97          SUB  A
062C: FD 23       INC  IY
062E: 86          ADD  A,(HL)		;Loop through all addresses in range HL
062F: 23          INC  HL
0630: 10 FC       DJNZ $062E
0632: 0D          DEC  C
0633: 20 F9       JR   NZ,$062E
0635: FD 86 00    ADD  A,(IY+$00)	;Add the checksum complement to A
0638: FD E5       PUSH IY
063A: FD 21 5B 06 LD   IY,$065B
063E: FE 00       CP   $00			;Compare A to $00 - for a valid checksum, A will contain $00
0640: 28 09       JR   Z,$064B		;Valid checksum skips to the status output subroutine
0642: FD 21 5E 06 LD   IY,$065E
0646: 3E 01       LD   A,$01		;Set CHECKSUM_INVALID_FLAG = TRUE
0648: 32 7C 7C    LD   ($7C7C),A
064B: CD 93 12    CALL $1293		;GOSUB: ROM_STATUS_OUTPUT
064E: DD 19       ADD  IX,DE
0650: FD E1       POP  IY
0652: C9          RET

0653: 11 10 09    LD   DE,$0910
0656: 08          EX   AF,AF'
0657: 07          RLCA
0658: 06 05       LD   B,$05
065A: 04          INC  B
065B: 02          LD   (BC),A
065C: 46          LD   B,(HL)
065D: 32 0A FF    LD   ($FF0A),A
0660: 01 41 46    LD   BC,$4641
0663: 5F          LD   E,A
0664: 82          ADD  A,D
0665: FF          RST  $38
0666: 08          EX   AF,AF'
0667: 46          LD   B,(HL)
0668: 32 40 FF    LD   ($FF40),A
066B: 03          INC  BC
066C: 4B          LD   C,E
066D: 64          LD   H,H
066E: 5A          LD   E,D
066F: 23          INC  HL
0670: 82          ADD  A,D
0671: 05          DEC  B
0672: 64          LD   H,H
0673: 5F          LD   E,A
0674: 5F          LD   E,A
0675: 46          LD   B,(HL)
0676: 41          LD   B,C
0677: 5A          LD   E,D
0678: 82          ADD  A,D
0679: 5F          LD   E,A
067A: 46          LD   B,(HL)
067B: 82          ADD  A,D
067C: 5F          LD   E,A
067D: 14          INC  D
067E: 5A          LD   E,D
067F: 5F          LD   E,A
0680: 82          ADD  A,D
0681: FF          RST  $38
0682: 80          ADD  A,B
0683: 00          NOP
0684: 82          ADD  A,D
0685: 5F          LD   E,A
0686: 46          LD   B,(HL)
0687: 41          LD   B,C
0688: 14          INC  D
0689: 82          ADD  A,D
068A: 6E          LD   L,(HL)
068B: 28 37       JR   Z,$06C4
068D: 37          SCF
068E: 82          ADD  A,D
068F: 5A          LD   E,D
0690: 46          LD   B,(HL)
0691: 64          LD   H,H
0692: 41          LD   B,C
0693: 0F          RRCA
0694: 82          ADD  A,D
0695: 28 19       JR   Z,$06B0
0697: 82          ADD  A,D
0698: FF          RST  $38
0699: 80          ADD  A,B
069A: 5F          LD   E,A
069B: 23          INC  HL
069C: 14          INC  D
069D: 82          ADD  A,D
069E: 05          DEC  B
069F: 64          LD   H,H
06A0: 5F          LD   E,A
06A1: 5F          LD   E,A
06A2: 46          LD   B,(HL)
06A3: 41          LD   B,C
06A4: 82          ADD  A,D
06A5: 28 5A       JR   Z,$0701
06A7: 82          ADD  A,D
06A8: 46          LD   B,(HL)
06A9: 32 FF 08    LD   ($08FF),A
06AC: 0D          DEC  C
06AD: FF          RST  $38
06AE: 07          RLCA
06AF: 05          DEC  B
06B0: 10 12       DJNZ $06C4
06B2: 0F          RRCA
06B3: 0D          DEC  C
06B4: 00          NOP
06B5: 03          INC  BC
06B6: 08          EX   AF,AF'
06B7: 05          DEC  B
06B8: 03          INC  BC
06B9: 0B          DEC  BC
06BA: 0E FF       LD   C,$FF
06BC: 07          RLCA
06BD: 02          LD   (BC),A
06BE: 15          DEC  D
06BF: 14          INC  D
06C0: 14          INC  D
06C1: 0F          RRCA
06C2: 0E 00       LD   C,$00
06C4: 03          INC  BC
06C5: 08          EX   AF,AF'
06C6: 05          DEC  B
06C7: 03          INC  BC
06C8: 0B          DEC  BC
06C9: 0D          DEC  C
06CA: FF          RST  $38
06CB: 07          RLCA
06CC: 04          INC  B
06CD: 09          ADD  HL,BC
06CE: 01 07 0E    LD   BC,$0E07
06D1: 0F          RRCA
06D2: 13          INC  DE
06D3: 14          INC  D
06D4: 09          ADD  HL,BC
06D5: 03          INC  BC
06D6: 13          INC  DE
06D7: 0C          INC  C
06D8: FF          RST  $38
06D9: 07          RLCA
06DA: 13          INC  DE
06DB: 03          INC  BC
06DC: 12          LD   (DE),A
06DD: 01 14 03    LD   BC,$0314
06E0: 08          EX   AF,AF'
06E1: 10 01       DJNZ $06E4
06E3: 04          INC  B
06E4: 0A          LD   A,(BC)
06E5: 10 01       DJNZ $06E8
06E7: 0C          INC  C
06E8: 0C          INC  C
06E9: 05          DEC  B
06EA: 14          INC  D
06EB: 14          INC  D
06EC: 05          DEC  B
06ED: 00          NOP
06EE: 1C          INC  E
06EF: 0A          LD   A,(BC)
06F0: 10 01       DJNZ $06F3
06F2: 0C          INC  C
06F3: 0C          INC  C
06F4: 05          DEC  B
06F5: 14          INC  D
06F6: 14          INC  D
06F7: 05          DEC  B
06F8: 00          NOP
06F9: 1D          DEC  E
06FA: 0F          RRCA
06FB: FF          RST  $38
06FC: 07          RLCA
06FD: 03          INC  BC
06FE: 0F          RRCA
06FF: 0E 06       LD   C,$06
0701: 09          ADD  HL,BC
0702: 07          RLCA
0703: 15          DEC  D
0704: 12          LD   (DE),A
0705: 01 14 09    LD   BC,$0914
0708: 0F          RRCA
0709: 0E F5       LD   C,$F5
070B: C5          PUSH BC
070C: 97          SUB  A
070D: CD 45 12    CALL $1245
0710: CD D2 1A    CALL $1AD2
0713: FD 21 FA 06 LD   IY,$06FA
0717: DD 21 9C 9D LD   IX,$9D9C
071B: CD 98 12    CALL $1298
071E: FD 21 60 08 LD   IY,$0860
0722: DD 21 48 88 LD   IX,$8848
0726: CD 93 12    CALL $1293
0729: DB 00       IN   A,($00)
072B: 32 BB 7C    LD   ($7CBB),A
072E: DD 21 D8 91 LD   IX,$91D8
0732: 11 FC FF    LD   DE,$FFFC
0735: 06 08       LD   B,$08
0737: 21 2D 08    LD   HL,$082D
073A: FD 21 81 08 LD   IY,$0881
073E: 3A BB 7C    LD   A,($7CBB)
0741: 2F          CPL
0742: A6          AND  (HL)
0743: 23          INC  HL
0744: 20 04       JR   NZ,$074A
0746: FD 21 87 08 LD   IY,$0887
074A: CD 93 12    CALL $1293
074D: DD 19       ADD  IX,DE
074F: 10 E9       DJNZ $073A
0751: 3E 01       LD   A,$01
0753: 32 80 7C    LD   ($7C80),A
0756: 3A BB 7C    LD   A,($7CBB)
0759: E6 01       AND  $01
075B: 3C          INC  A
075C: DD 21 C8 A1 LD   IX,$A1C8
0760: CD B4 10    CALL $10B4
0763: CD F5 10    CALL $10F5
0766: FD 21 8D 08 LD   IY,$088D
076A: DD 21 F0 AC LD   IX,$ACF0
076E: CD 93 12    CALL $1293
0771: DD 21 C2 A1 LD   IX,$A1C2
0775: 3E 01       LD   A,$01
0777: 32 80 7C    LD   ($7C80),A
077A: 3A BB 7C    LD   A,($7CBB)
077D: CD 35 08    CALL $0835
0780: CD B4 10    CALL $10B4
0783: CD F5 10    CALL $10F5
0786: FD 21 9E 08 LD   IY,$089E
078A: DD 21 EA AC LD   IX,$ACEA
078E: CD 93 12    CALL $1293
0791: DD 21 F2 E0 LD   IX,$E0F2
0795: 3E 01       LD   A,$01
0797: 32 80 7C    LD   ($7C80),A
079A: 3A BB 7C    LD   A,($7CBB)
079D: CD 47 08    CALL $0847
07A0: 57          LD   D,A
07A1: 3C          INC  A
07A2: CD B4 10    CALL $10B4
07A5: CD F5 10    CALL $10F5
07A8: FD 21 AF 08 LD   IY,$08AF
07AC: DD 21 72 A5 LD   IX,$A572
07B0: CD 93 12    CALL $1293
07B3: CD F9 08    CALL $08F9
07B6: FD 21 C8 08 LD   IY,$08C8
07BA: DD 21 7E D9 LD   IX,$D97E
07BE: CD 93 12    CALL $1293
07C1: FD 21 CF 08 LD   IY,$08CF
07C5: DD 21 68 A5 LD   IX,$A568
07C9: CD 93 12    CALL $1293
07CC: DD 21 78 D9 LD   IX,$D978
07D0: 3E 01       LD   A,$01
07D2: 32 80 7C    LD   ($7C80),A
07D5: 3A BB 7C    LD   A,($7CBB)
07D8: CB 5F       BIT  3,A
07DA: 3E 02       LD   A,$02
07DC: 28 02       JR   Z,$07E0
07DE: 3E 10       LD   A,$10
07E0: 82          ADD  A,D
07E1: 27          DAA
07E2: CD B4 10    CALL $10B4
07E5: CD F5 10    CALL $10F5
07E8: FD 21 DD 08 LD   IY,$08DD
07EC: DD 21 E8 E0 LD   IX,$E0E8
07F0: CD 93 12    CALL $1293
07F3: FD 21 E6 08 LD   IY,$08E6
07F7: DD 21 64 A5 LD   IX,$A564
07FB: CD 93 12    CALL $1293
07FE: DD 21 0C EC LD   IX,$EC0C
0802: FD 21 87 08 LD   IY,$0887
0806: 3A BB 7C    LD   A,($7CBB)
0809: CB 7F       BIT  7,A
080B: 20 04       JR   NZ,$0811
080D: FD 21 81 08 LD   IY,$0881
0811: CD 93 12    CALL $1293
0814: DD 21 21 C4 LD   IX,$C421
0818: FD 21 26 03 LD   IY,$0326
081C: CD 93 12    CALL $1293
081F: DB 02       IN   A,($02)
0821: D3 00       OUT  ($00),A
0823: CB 57       BIT  2,A
0825: C2 29 07    JP   NZ,$0729
0828: C1          POP  BC
0829: F1          POP  AF
082A: C3 8E 01    JP   $018E
082D: 01 10 40    LD   BC,$4010
0830: 02          LD   (BC),A
0831: 20 04       JR   NZ,$0837
0833: 08          EX   AF,AF'
0834: 80          ADD  A,B
0835: D5          PUSH DE
0836: 0F          RRCA
0837: 0F          RRCA
0838: 0F          RRCA
0839: 0F          RRCA
083A: 0F          RRCA
083B: CB 12       RL   D
083D: 0F          RRCA
083E: CB 1A       RR   D
0840: 17          RLA
0841: E6 03       AND  $03
0843: C6 03       ADD  A,$03
0845: D1          POP  DE
0846: C9          RET

0847: D5          PUSH DE
0848: 0F          RRCA
0849: 0F          RRCA
084A: CB 1A       RR   D
084C: 0F          RRCA
084D: CB 1B       RR   E
084F: 0F          RRCA
0850: 0F          RRCA
0851: 0F          RRCA
0852: CB 1A       RR   D
0854: CB 13       RL   E
0856: CB 1A       RR   D
0858: 7A          LD   A,D
0859: 07          RLCA
085A: 07          RLCA
085B: 07          RLCA
085C: E6 07       AND  $07
085E: D1          POP  DE
085F: C9          RET

0860: 20 5A       JR   NZ,$08BC
0862: 8C          ADC  A,H
0863: FF          RST  $38
0864: 80          ADD  A,B
0865: 5A          LD   E,D
0866: 91          SUB  C
0867: FF          RST  $38
0868: 80          ADD  A,B
0869: 5A          LD   E,D
086A: 96          SUB  (HL)
086B: FF          RST  $38
086C: 80          ADD  A,B
086D: 5A          LD   E,D
086E: 9B          SBC  A,E
086F: FF          RST  $38
0870: 80          ADD  A,B
0871: 5A          LD   E,D
0872: A0          AND  B
0873: FF          RST  $38
0874: 80          ADD  A,B
0875: 5A          LD   E,D
0876: A5          AND  L
0877: FF          RST  $38
0878: 80          ADD  A,B
0879: 5A          LD   E,D
087A: AA          XOR  D
087B: FF          RST  $38
087C: 80          ADD  A,B
087D: 5A          LD   E,D
087E: AF          XOR  A
087F: FF          RST  $38
0880: 80          ADD  A,B
0881: 05          DEC  B
0882: FF          RST  $38
0883: 07          RLCA
0884: 46          LD   B,(HL)
0885: 41          LD   B,C
0886: 82          ADD  A,D
0887: 05          DEC  B
0888: FF          RST  $38
0889: 07          RLCA
088A: 46          LD   B,(HL)
088B: 19          ADD  HL,DE
088C: 19          ADD  HL,DE
088D: 10 0A       DJNZ $0899
088F: 55          LD   D,L
0890: 14          INC  D
0891: 0F          RRCA
0892: 28 5F       JR   Z,$08F3
0894: 5A          LD   E,D
0895: 82          ADD  A,D
0896: 4B          LD   C,E
0897: 14          INC  D
0898: 55          LD   D,L
0899: 82          ADD  A,D
089A: 0A          LD   A,(BC)
089B: 46          LD   B,(HL)
089C: 28 41       JR   Z,$08DF
089E: 10 1E       DJNZ $08BE
08A0: 37          SCF
08A1: 46          LD   B,(HL)
08A2: 05          DEC  B
08A3: 5A          LD   E,D
08A4: 82          ADD  A,D
08A5: 4B          LD   C,E
08A6: 14          INC  D
08A7: 55          LD   D,L
08A8: 82          ADD  A,D
08A9: 0A          LD   A,(BC)
08AA: 55          LD   D,L
08AB: 14          INC  D
08AC: 0F          RRCA
08AD: 28 5F       JR   Z,$090E
08AF: 18 0F       JR   $08C0
08B1: 28 19       JR   Z,$08CC
08B3: 19          ADD  HL,DE
08B4: 28 0A       JR   Z,$08C0
08B6: 64          LD   H,H
08B7: 37          SCF
08B8: 5F          LD   E,A
08B9: 78          LD   A,B
08BA: 82          ADD  A,D
08BB: 37          SCF
08BC: 14          INC  D
08BD: 69          LD   L,C
08BE: 14          INC  D
08BF: 37          SCF
08C0: FF          RST  $38
08C1: 80          ADD  A,B
08C2: 14          INC  D
08C3: 00          NOP
08C4: 5A          LD   E,D
08C5: 78          LD   A,B
08C6: FF          RST  $38
08C7: 01 06 FF    LD   BC,$FF06
08CA: 07          RLCA
08CB: 23          INC  HL
08CC: 00          NOP
08CD: 55          LD   D,L
08CE: 0F          RRCA
08CF: 0D          DEC  C
08D0: 14          INC  D
08D1: 73          LD   (HL),E
08D2: 5F          LD   E,A
08D3: 55          LD   D,L
08D4: 00          NOP
08D5: 82          ADD  A,D
08D6: 1E 37       LD   E,$37
08D8: 46          LD   B,(HL)
08D9: 05          DEC  B
08DA: 82          ADD  A,D
08DB: 00          NOP
08DC: 5F          LD   E,A
08DD: 08          EX   AF,AF'
08DE: 87          ADD  A,A
08DF: 87          ADD  A,A
08E0: 87          ADD  A,A
08E1: 87          ADD  A,A
08E2: 82          ADD  A,D
08E3: 4B          LD   C,E
08E4: 5F          LD   E,A
08E5: 5A          LD   E,D
08E6: 12          LD   (DE),A
08E7: 00          NOP
08E8: 5F          LD   E,A
08E9: 5F          LD   E,A
08EA: 55          LD   D,L
08EB: 00          NOP
08EC: 0A          LD   A,(BC)
08ED: 5F          LD   E,A
08EE: 82          ADD  A,D
08EF: 3C          INC  A
08F0: 46          LD   B,(HL)
08F1: 0F          RRCA
08F2: 14          INC  D
08F3: 82          ADD  A,D
08F4: 5A          LD   E,D
08F5: 46          LD   B,(HL)
08F6: 64          LD   H,H
08F7: 41          LD   B,C
08F8: 0F          RRCA
08F9: D5          PUSH DE
08FA: E5          PUSH HL
08FB: 47          LD   B,A
08FC: 3E 09       LD   A,$09
08FE: 90          SUB  B
08FF: 4F          LD   C,A
0900: DD 21 06 B8 LD   IX,$B806
0904: 21 B3 17    LD   HL,$17B3
0907: CD 67 16    CALL $1667
090A: 10 FB       DJNZ $0907
090C: 97          SUB  A
090D: 32 F2 7B    LD   ($7BF2),A
0910: 41          LD   B,C
0911: 11 90 F8    LD   DE,$F890
0914: DD 21 C6 D5 LD   IX,$D5C6
0918: 21 B3 17    LD   HL,$17B3
091B: CD 67 16    CALL $1667
091E: DD 19       ADD  IX,DE
0920: 10 F9       DJNZ $091B
0922: 21 F7 B6    LD   HL,$B6F7
0925: 01 02 03    LD   BC,$0302
0928: 11 B8 03    LD   DE,$03B8
092B: 3E 09       LD   A,$09
092D: F5          PUSH AF
092E: 3E 77       LD   A,$77
0930: CD 4F 11    CALL $114F
0933: F1          POP  AF
0934: 19          ADD  HL,DE
0935: 3D          DEC  A
0936: 20 F5       JR   NZ,$092D
0938: E1          POP  HL
0939: D1          POP  DE
093A: C9          RET

093B: F5          PUSH AF
093C: C5          PUSH BC
093D: E5          PUSH HL
093E: 21 16 7D    LD   HL,$7D16
0941: 3E 20       LD   A,$20
0943: 06 00       LD   B,$00
0945: 70          LD   (HL),B
0946: 23          INC  HL
0947: 70          LD   (HL),B
0948: 23          INC  HL
0949: 3D          DEC  A
094A: F5          PUSH AF
094B: CD 48 0B    CALL $0B48
094E: F1          POP  AF
094F: 20 F4       JR   NZ,$0945
0951: 3E F8       LD   A,$F8
0953: 32 24 7D    LD   ($7D24),A
0956: 47          LD   B,A
0957: 3E 07       LD   A,$07
0959: CD 48 0B    CALL $0B48
095C: 21 BE 7C    LD   HL,$7CBE
095F: 06 0C       LD   B,$0C
0961: 97          SUB  A
0962: 77          LD   (HL),A
0963: 23          INC  HL
0964: 10 FC       DJNZ $0962
0966: E1          POP  HL
0967: C1          POP  BC
0968: F1          POP  AF
0969: C9          RET

096A: F5          PUSH AF
096B: C5          PUSH BC
096C: D5          PUSH DE
096D: E5          PUSH HL
096E: 06 00       LD   B,$00
0970: 11 04 00    LD   DE,$0004
0973: 21 BE 7C    LD   HL,$7CBE
0976: 7E          LD   A,(HL)
0977: FE 00       CP   $00
0979: C4 91 09    CALL NZ,$0991
097C: 19          ADD  HL,DE
097D: 04          INC  B
097E: 7E          LD   A,(HL)
097F: FE 00       CP   $00
0981: C4 91 09    CALL NZ,$0991
0984: 19          ADD  HL,DE
0985: 04          INC  B
0986: 7E          LD   A,(HL)
0987: FE 00       CP   $00
0989: C4 91 09    CALL NZ,$0991
098C: E1          POP  HL
098D: D1          POP  DE
098E: C1          POP  BC
098F: F1          POP  AF
0990: C9          RET

0991: C5          PUSH BC
0992: D5          PUSH DE
0993: E5          PUSH HL
0994: 78          LD   A,B
0995: 32 57 7D    LD   ($7D57),A
0998: 23          INC  HL
0999: 23          INC  HL
099A: E5          PUSH HL
099B: 5E          LD   E,(HL)
099C: 23          INC  HL
099D: 56          LD   D,(HL)
099E: 1A          LD   A,(DE)
099F: E6 E0       AND  $E0
09A1: 07          RLCA
09A2: 07          RLCA
09A3: 07          RLCA
09A4: D5          PUSH DE
09A5: 21 B0 09    LD   HL,$09B0
09A8: 5F          LD   E,A
09A9: 07          RLCA
09AA: 83          ADD  A,E
09AB: 16 00       LD   D,$00
09AD: 5F          LD   E,A
09AE: 19          ADD  HL,DE
09AF: E9          JP   (HL)
09B0: C3 CC 09    JP   $09CC
09B3: C3 E7 09    JP   $09E7
09B6: C3 00 0A    JP   $0A00
09B9: C3 27 0A    JP   $0A27
09BC: C3 48 0A    JP   $0A48
09BF: C3 B4 0A    JP   $0AB4
09C2: C3 EE 0A    JP   $0AEE
09C5: C3 F7 0A    JP   $0AF7
09C8: E1          POP  HL
09C9: D1          POP  DE
09CA: C1          POP  BC
09CB: C9          RET

09CC: E1          POP  HL
09CD: 7E          LD   A,(HL)
09CE: E6 1F       AND  $1F
09D0: 23          INC  HL
09D1: 46          LD   B,(HL)
09D2: 23          INC  HL
09D3: E5          PUSH HL
09D4: CD 48 0B    CALL $0B48
09D7: 07          RLCA
09D8: 16 00       LD   D,$00
09DA: 5F          LD   E,A
09DB: 21 16 7D    LD   HL,$7D16
09DE: 19          ADD  HL,DE
09DF: 70          LD   (HL),B
09E0: 23          INC  HL
09E1: 36 00       LD   (HL),$00
09E3: D1          POP  DE
09E4: C3 9E 09    JP   $099E
09E7: E1          POP  HL
09E8: 7E          LD   A,(HL)
09E9: E6 1F       AND  $1F
09EB: 23          INC  HL
09EC: 4E          LD   C,(HL)
09ED: 23          INC  HL
09EE: 46          LD   B,(HL)
09EF: 23          INC  HL
09F0: E5          PUSH HL
09F1: 07          RLCA
09F2: 16 00       LD   D,$00
09F4: 5F          LD   E,A
09F5: 21 CA 7C    LD   HL,$7CCA
09F8: 19          ADD  HL,DE
09F9: 71          LD   (HL),C
09FA: 23          INC  HL
09FB: 70          LD   (HL),B
09FC: D1          POP  DE
09FD: C3 9E 09    JP   $099E
0A00: E1          POP  HL
0A01: 7E          LD   A,(HL)
0A02: E6 1F       AND  $1F
0A04: 23          INC  HL
0A05: 4E          LD   C,(HL)
0A06: 23          INC  HL
0A07: 46          LD   B,(HL)
0A08: 23          INC  HL
0A09: E5          PUSH HL
0A0A: F5          PUSH AF
0A0B: 07          RLCA
0A0C: 16 00       LD   D,$00
0A0E: 5F          LD   E,A
0A0F: 21 16 7D    LD   HL,$7D16
0A12: 19          ADD  HL,DE
0A13: E5          PUSH HL
0A14: 7E          LD   A,(HL)
0A15: 23          INC  HL
0A16: 6E          LD   L,(HL)
0A17: 67          LD   H,A
0A18: 09          ADD  HL,BC
0A19: 44          LD   B,H
0A1A: 4D          LD   C,L
0A1B: E1          POP  HL
0A1C: 70          LD   (HL),B
0A1D: 23          INC  HL
0A1E: 71          LD   (HL),C
0A1F: F1          POP  AF
0A20: CD 48 0B    CALL $0B48
0A23: D1          POP  DE
0A24: C3 9E 09    JP   $099E
0A27: E1          POP  HL
0A28: 7E          LD   A,(HL)
0A29: E6 1F       AND  $1F
0A2B: 23          INC  HL
0A2C: 46          LD   B,(HL)
0A2D: 23          INC  HL
0A2E: E5          PUSH HL
0A2F: 07          RLCA
0A30: 16 00       LD   D,$00
0A32: 5F          LD   E,A
0A33: 21 16 7D    LD   HL,$7D16
0A36: 19          ADD  HL,DE
0A37: 7E          LD   A,(HL)
0A38: B8          CP   B
0A39: 28 07       JR   Z,$0A42
0A3B: E1          POP  HL
0A3C: 5E          LD   E,(HL)
0A3D: 23          INC  HL
0A3E: 56          LD   D,(HL)
0A3F: C3 F0 0A    JP   $0AF0
0A42: D1          POP  DE
0A43: 13          INC  DE
0A44: 13          INC  DE
0A45: C3 9E 09    JP   $099E
0A48: E1          POP  HL
0A49: 7E          LD   A,(HL)
0A4A: E6 1F       AND  $1F
0A4C: 23          INC  HL
0A4D: 46          LD   B,(HL)
0A4E: 23          INC  HL
0A4F: 4E          LD   C,(HL)
0A50: 23          INC  HL
0A51: E5          PUSH HL
0A52: F5          PUSH AF
0A53: 07          RLCA
0A54: 16 00       LD   D,$00
0A56: 5F          LD   E,A
0A57: 21 16 7D    LD   HL,$7D16
0A5A: 19          ADD  HL,DE
0A5B: 97          SUB  A
0A5C: BE          CP   (HL)
0A5D: 28 06       JR   Z,$0A65
0A5F: 35          DEC  (HL)
0A60: F1          POP  AF
0A61: D1          POP  DE
0A62: C3 9E 09    JP   $099E
0A65: 78          LD   A,B
0A66: E6 E0       AND  $E0
0A68: 07          RLCA
0A69: 07          RLCA
0A6A: 07          RLCA
0A6B: 07          RLCA
0A6C: 16 00       LD   D,$00
0A6E: 5F          LD   E,A
0A6F: 21 CA 7C    LD   HL,$7CCA
0A72: 19          ADD  HL,DE
0A73: 5E          LD   E,(HL)
0A74: 23          INC  HL
0A75: 56          LD   D,(HL)
0A76: F1          POP  AF
0A77: E5          PUSH HL
0A78: 07          RLCA
0A79: D5          PUSH DE
0A7A: 16 00       LD   D,$00
0A7C: 5F          LD   E,A
0A7D: 21 16 7D    LD   HL,$7D16
0A80: 19          ADD  HL,DE
0A81: D1          POP  DE
0A82: 1A          LD   A,(DE)
0A83: 77          LD   (HL),A
0A84: 13          INC  DE
0A85: 78          LD   A,B
0A86: E6 1F       AND  $1F
0A88: 32 56 7D    LD   ($7D56),A
0A8B: 79          LD   A,C
0A8C: 07          RLCA
0A8D: D5          PUSH DE
0A8E: 16 00       LD   D,$00
0A90: 5F          LD   E,A
0A91: 21 16 7D    LD   HL,$7D16
0A94: 19          ADD  HL,DE
0A95: D1          POP  DE
0A96: 1A          LD   A,(DE)
0A97: 13          INC  DE
0A98: 47          LD   B,A
0A99: 79          LD   A,C
0A9A: CD 48 0B    CALL $0B48
0A9D: 0C          INC  C
0A9E: 70          LD   (HL),B
0A9F: 23          INC  HL
0AA0: 36 00       LD   (HL),$00
0AA2: 23          INC  HL
0AA3: 3A 56 7D    LD   A,($7D56)
0AA6: 3D          DEC  A
0AA7: 32 56 7D    LD   ($7D56),A
0AAA: 20 EA       JR   NZ,$0A96
0AAC: E1          POP  HL
0AAD: 72          LD   (HL),D
0AAE: 2B          DEC  HL
0AAF: 73          LD   (HL),E
0AB0: D1          POP  DE
0AB1: C3 9E 09    JP   $099E
0AB4: E1          POP  HL
0AB5: 7E          LD   A,(HL)
0AB6: E6 1F       AND  $1F
0AB8: 23          INC  HL
0AB9: F5          PUSH AF
0ABA: E5          PUSH HL
0ABB: 3A 57 7D    LD   A,($7D57)
0ABE: 07          RLCA
0ABF: 07          RLCA
0AC0: 16 00       LD   D,$00
0AC2: 5F          LD   E,A
0AC3: 21 BE 7C    LD   HL,$7CBE
0AC6: 19          ADD  HL,DE
0AC7: 46          LD   B,(HL)
0AC8: 23          INC  HL
0AC9: 4E          LD   C,(HL)
0ACA: 79          LD   A,C
0ACB: 07          RLCA
0ACC: 16 00       LD   D,$00
0ACE: 5F          LD   E,A
0ACF: 21 D6 7C    LD   HL,$7CD6
0AD2: 19          ADD  HL,DE
0AD3: D1          POP  DE
0AD4: 73          LD   (HL),E
0AD5: 23          INC  HL
0AD6: 72          LD   (HL),D
0AD7: F1          POP  AF
0AD8: 07          RLCA
0AD9: 07          RLCA
0ADA: 16 00       LD   D,$00
0ADC: 5F          LD   E,A
0ADD: 21 C0 0B    LD   HL,$0BC0
0AE0: 19          ADD  HL,DE
0AE1: 5E          LD   E,(HL)
0AE2: 23          INC  HL
0AE3: 56          LD   D,(HL)
0AE4: 23          INC  HL
0AE5: 23          INC  HL
0AE6: 7E          LD   A,(HL)
0AE7: CD AD 0B    CALL $0BAD
0AEA: E1          POP  HL
0AEB: C3 C8 09    JP   $09C8
0AEE: D1          POP  DE
0AEF: 13          INC  DE
0AF0: E1          POP  HL
0AF1: 73          LD   (HL),E
0AF2: 23          INC  HL
0AF3: 72          LD   (HL),D
0AF4: C3 C8 09    JP   $09C8
0AF7: E1          POP  HL
0AF8: E1          POP  HL
0AF9: 3A 57 7D    LD   A,($7D57)
0AFC: 07          RLCA
0AFD: 07          RLCA
0AFE: 16 00       LD   D,$00
0B00: 5F          LD   E,A
0B01: 21 BE 7C    LD   HL,$7CBE
0B04: 19          ADD  HL,DE
0B05: 46          LD   B,(HL)
0B06: 23          INC  HL
0B07: 4E          LD   C,(HL)
0B08: 79          LD   A,C
0B09: 07          RLCA
0B0A: 16 00       LD   D,$00
0B0C: 5F          LD   E,A
0B0D: 21 D7 7C    LD   HL,$7CD7
0B10: 19          ADD  HL,DE
0B11: 7E          LD   A,(HL)
0B12: FE 00       CP   $00
0B14: 28 10       JR   Z,$0B26
0B16: 57          LD   D,A
0B17: 2B          DEC  HL
0B18: 5E          LD   E,(HL)
0B19: 97          SUB  A
0B1A: 77          LD   (HL),A
0B1B: 23          INC  HL
0B1C: 77          LD   (HL),A
0B1D: 3A 57 7D    LD   A,($7D57)
0B20: CD AD 0B    CALL $0BAD
0B23: C3 C8 09    JP   $09C8
0B26: 3A 57 7D    LD   A,($7D57)
0B29: F5          PUSH AF
0B2A: C6 08       ADD  A,$08
0B2C: 06 00       LD   B,$00
0B2E: CD 48 0B    CALL $0B48
0B31: F1          POP  AF
0B32: 07          RLCA
0B33: 16 00       LD   D,$00
0B35: 5F          LD   E,A
0B36: 21 16 7D    LD   HL,$7D16
0B39: 19          ADD  HL,DE
0B3A: 72          LD   (HL),D
0B3B: 23          INC  HL
0B3C: 72          LD   (HL),D
0B3D: 07          RLCA
0B3E: 5F          LD   E,A
0B3F: 21 BE 7C    LD   HL,$7CBE
0B42: 19          ADD  HL,DE
0B43: 36 00       LD   (HL),$00
0B45: C3 C8 09    JP   $09C8
0B48: FE 0E       CP   $0E
0B4A: D0          RET  NC

0B4B: F5          PUSH AF
0B4C: D3 06       OUT  ($06),A
0B4E: 78          LD   A,B
0B4F: D3 02       OUT  ($02),A
0B51: F1          POP  AF
0B52: C9          RET

0B53: F5          PUSH AF
0B54: C5          PUSH BC
0B55: D5          PUSH DE
0B56: E5          PUSH HL
0B57: F5          PUSH AF
0B58: 3A 8C 7C    LD   A,($7C8C)
0B5B: FE 01       CP   $01
0B5D: 20 0A       JR   NZ,$0B69
0B5F: 3A B5 7C    LD   A,($7CB5)
0B62: FE 01       CP   $01
0B64: 28 03       JR   Z,$0B69
0B66: F1          POP  AF
0B67: 18 3F       JR   $0BA8
0B69: F1          POP  AF
0B6A: 32 58 7D    LD   ($7D58),A
0B6D: 4F          LD   C,A
0B6E: 07          RLCA
0B6F: 07          RLCA
0B70: 16 00       LD   D,$00
0B72: 5F          LD   E,A
0B73: 21 C0 0B    LD   HL,$0BC0
0B76: 19          ADD  HL,DE
0B77: E5          PUSH HL
0B78: 23          INC  HL
0B79: 23          INC  HL
0B7A: 46          LD   B,(HL)
0B7B: 23          INC  HL
0B7C: 7E          LD   A,(HL)
0B7D: C5          PUSH BC
0B7E: E5          PUSH HL
0B7F: 07          RLCA
0B80: 07          RLCA
0B81: 16 00       LD   D,$00
0B83: 5F          LD   E,A
0B84: 21 BE 7C    LD   HL,$7CBE
0B87: 19          ADD  HL,DE
0B88: 7E          LD   A,(HL)
0B89: B8          CP   B
0B8A: 38 07       JR   C,$0B93
0B8C: 20 09       JR   NZ,$0B97
0B8E: 23          INC  HL
0B8F: 7E          LD   A,(HL)
0B90: B9          CP   C
0B91: 28 04       JR   Z,$0B97
0B93: 3E 01       LD   A,$01
0B95: 18 01       JR   $0B98
0B97: 97          SUB  A
0B98: E1          POP  HL
0B99: C1          POP  BC
0B9A: FE 00       CP   $00
0B9C: E1          POP  HL
0B9D: 28 09       JR   Z,$0BA8
0B9F: 5E          LD   E,(HL)
0BA0: 23          INC  HL
0BA1: 56          LD   D,(HL)
0BA2: 23          INC  HL
0BA3: 23          INC  HL
0BA4: 7E          LD   A,(HL)
0BA5: CD AD 0B    CALL $0BAD
0BA8: E1          POP  HL
0BA9: D1          POP  DE
0BAA: C1          POP  BC
0BAB: F1          POP  AF
0BAC: C9          RET

0BAD: D5          PUSH DE
0BAE: 07          RLCA
0BAF: 07          RLCA
0BB0: 16 00       LD   D,$00
0BB2: 5F          LD   E,A
0BB3: 21 BE 7C    LD   HL,$7CBE
0BB6: 19          ADD  HL,DE
0BB7: 70          LD   (HL),B
0BB8: 23          INC  HL
0BB9: 71          LD   (HL),C
0BBA: 23          INC  HL
0BBB: D1          POP  DE
0BBC: 73          LD   (HL),E
0BBD: 23          INC  HL
0BBE: 72          LD   (HL),D
0BBF: C9          RET

0BC0: 14          INC  D
0BC1: 0C          INC  C
0BC2: 02          LD   (BC),A
0BC3: 00          NOP
0BC4: 22 0C 02    LD   ($020C),HL
0BC7: 00          NOP
0BC8: 30 0C       JR   NC,$0BD6
0BCA: 01 01 4C    LD   BC,$4C01
0BCD: 0C          INC  C
0BCE: 03          INC  BC
0BCF: 01 5C 0C    LD   BC,$0C5C
0BD2: 02          LD   (BC),A
0BD3: 00          NOP
0BD4: C9          RET

0BD5: 0D          DEC  C
0BD6: 01 00 AF    LD   BC,$AF00
0BD9: 0D          DEC  C
0BDA: 01 00 73    LD   BC,$7300
0BDD: 0C          INC  C
0BDE: 02          LD   (BC),A
0BDF: 00          NOP
0BE0: 87          ADD  A,A
0BE1: 0C          INC  C
0BE2: 02          LD   (BC),A
0BE3: 00          NOP
0BE4: 9B          SBC  A,E
0BE5: 0C          INC  C
0BE6: 02          LD   (BC),A
0BE7: 00          NOP
0BE8: 3E 0C       LD   A,$0C
0BEA: 02          LD   (BC),A
0BEB: 00          NOP
0BEC: A9          XOR  C
0BED: 0C          INC  C
0BEE: 01 00 C1    LD   BC,$C100
0BF1: 0C          INC  C
0BF2: 04          INC  B
0BF3: 00          NOP
0BF4: D9          EXX
0BF5: 0C          INC  C
0BF6: 04          INC  B
0BF7: 00          NOP
0BF8: F1          POP  AF
0BF9: 0C          INC  C
0BFA: 03          INC  BC
0BFB: 01 45 0D    LD   BC,$0D45
0BFE: 03          INC  BC
0BFF: 00          NOP
0C00: 2E 0D       LD   L,$0D
0C02: 01 00 5E    LD   BC,$5E00
0C05: 0D          DEC  C
0C06: 04          INC  B
0C07: 00          NOP
0C08: 7F          LD   A,A
0C09: 0D          DEC  C
0C0A: 01 00 97    LD   BC,$9700
0C0D: 0D          DEC  C
0C0E: 04          INC  B
0C0F: 01 16 0D    LD   BC,$0D16
0C12: 03          INC  BC
0C13: 01 08 07    LD   BC,$0708
0C16: 00          NOP
0C17: BF          CP   A
0C18: 01 00 40    LD   BC,$4000
0C1B: 00          NOP
0C1C: FF          RST  $38
0C1D: 60          LD   H,B
0C1E: 05          DEC  B
0C1F: 1A          LD   A,(DE)
0C20: 0C          INC  C
0C21: E0          RET  PO

0C22: 08          EX   AF,AF'
0C23: 07          RLCA
0C24: 00          NOP
0C25: 05          DEC  B
0C26: 01 00 40    LD   BC,$4000
0C29: 00          NOP
0C2A: 01 60 BF    LD   BC,$BF60
0C2D: 28 0C       JR   Z,$0C3B
0C2F: E0          RET  PO

0C30: 09          ADD  HL,BC
0C31: 0F          RRCA
0C32: 02          LD   (BC),A
0C33: 10 03       DJNZ $0C38
0C35: 00          NOP
0C36: 49          LD   C,C
0C37: 80          ADD  A,B
0C38: FF          RST  $38
0C39: 69          LD   L,C
0C3A: 00          NOP
0C3B: 36 0C       LD   (HL),$0C
0C3D: E0          RET  PO

0C3E: 08          EX   AF,AF'
0C3F: 09          ADD  HL,BC
0C40: 00          NOP
0C41: 18 01       JR   $0C44
0C43: 00          NOP
0C44: 48          LD   C,B
0C45: 80          ADD  A,B
0C46: FF          RST  $38
0C47: 68          LD   L,B
0C48: 00          NOP
0C49: 44          LD   B,H
0C4A: 0C          INC  C
0C4B: E0          RET  PO

0C4C: 09          ADD  HL,BC
0C4D: 07          RLCA
0C4E: 02          LD   (BC),A
0C4F: 0F          RRCA
0C50: 03          INC  BC
0C51: 00          NOP
0C52: 11 06 51    LD   DE,$5106
0C55: 00          NOP
0C56: FF          RST  $38
0C57: 71          LD   (HL),C
0C58: 00          NOP
0C59: 54          LD   D,H
0C5A: 0C          INC  C
0C5B: E0          RET  PO

0C5C: 08          EX   AF,AF'
0C5D: 07          RLCA
0C5E: 10 03       DJNZ $0C63
0C60: 01 00 00    LD   BC,$0000
0C63: 28 40       JR   Z,$0CA5
0C65: 00          NOP
0C66: FB          EI
0C67: 60          LD   H,B
0C68: 0A          LD   A,(BC)
0C69: 64          LD   H,H
0C6A: 0C          INC  C
0C6B: 50          LD   D,B
0C6C: 00          NOP
0C6D: FF          RST  $38
0C6E: 70          LD   (HL),B
0C6F: 00          NOP
0C70: 62          LD   H,D
0C71: 0C          INC  C
0C72: E0          RET  PO

0C73: 08          EX   AF,AF'
0C74: 10 00       DJNZ $0C76
0C76: 1F          RRA
0C77: 01 00 0D    LD   BC,$0D00
0C7A: 0E 0B       LD   C,$0B
0C7C: EA 0C 00    JP   PE,$000C
0C7F: 40          LD   B,B
0C80: 00          NOP
0C81: FE 60       CP   $60
0C83: 05          DEC  B
0C84: 7F          LD   A,A
0C85: 0C          INC  C
0C86: E0          RET  PO

0C87: 08          EX   AF,AF'
0C88: 10 00       DJNZ $0C8A
0C8A: 05          DEC  B
0C8B: 01 00 0D    LD   BC,$0D00
0C8E: 0E 0B       LD   C,$0B
0C90: EA 0C 00    JP   PE,$000C
0C93: 40          LD   B,B
0C94: 00          NOP
0C95: 02          LD   (BC),A
0C96: 60          LD   H,B
0C97: 1F          RRA
0C98: 93          SUB  E
0C99: 0C          INC  C
0C9A: E0          RET  PO

0C9B: 08          EX   AF,AF'
0C9C: 08          EX   AF,AF'
0C9D: 00          NOP
0C9E: 18 01       JR   $0CA1
0CA0: 02          LD   (BC),A
0CA1: 48          LD   C,B
0CA2: 80          ADD  A,B
0CA3: FF          RST  $38
0CA4: 68          LD   L,B
0CA5: 00          NOP
0CA6: A1          AND  C
0CA7: 0C          INC  C
0CA8: E0          RET  PO

0CA9: 08          EX   AF,AF'
0CAA: 0A          LD   A,(BC)
0CAB: 20 05       JR   NZ,$0CB2
0CAD: 0E 16       LD   C,$16
0CAF: 1F          RRA
0CB0: 13          INC  DE
0CB1: 00          NOP
0CB2: 93          SUB  E
0CB3: 02          LD   (BC),A
0CB4: 00          NOP
0CB5: 73          LD   (HL),E
0CB6: 00          NOP
0CB7: B2          OR   D
0CB8: 0C          INC  C
0CB9: 56          LD   D,(HL)
0CBA: 00          NOP
0CBB: FF          RST  $38
0CBC: 76          HALT
0CBD: 00          NOP
0CBE: B2          OR   D
0CBF: 0C          INC  C
0CC0: E0          RET  PO

0CC1: 08          EX   AF,AF'
0CC2: 0A          LD   A,(BC)
0CC3: 20 C2       JR   NZ,$0C87
0CC5: 0E 16       LD   C,$16
0CC7: 15          DEC  D
0CC8: 13          INC  DE
0CC9: 00          NOP
0CCA: 93          SUB  E
0CCB: 02          LD   (BC),A
0CCC: 00          NOP
0CCD: 73          LD   (HL),E
0CCE: 00          NOP
0CCF: CA 0C 56    JP   Z,$560C
0CD2: 00          NOP
0CD3: FF          RST  $38
0CD4: 76          HALT
0CD5: 00          NOP
0CD6: CA 0C E0    JP   Z,$E00C
0CD9: 08          EX   AF,AF'
0CDA: 0A          LD   A,(BC)
0CDB: 20 2E       JR   NZ,$0D0B
0CDD: 0F          RRCA
0CDE: 16 3A       LD   D,$3A
0CE0: 13          INC  DE
0CE1: 00          NOP
0CE2: 93          SUB  E
0CE3: 02          LD   (BC),A
0CE4: 00          NOP
0CE5: 73          LD   (HL),E
0CE6: 00          NOP
0CE7: E2 0C 56    JP   PO,$560C
0CEA: 00          NOP
0CEB: FF          RST  $38
0CEC: 76          HALT
0CED: 00          NOP
0CEE: E2 0C E0    JP   PO,$E00C
0CF1: 02          LD   (BC),A
0CF2: 10 03       DJNZ $0CF7
0CF4: 01 11 04    LD   BC,$0411
0CF7: 09          ADD  HL,BC
0CF8: 10 0B       DJNZ $0D05
0CFA: 1F          RRA
0CFB: 0C          INC  C
0CFC: 00          NOP
0CFD: 0D          DEC  C
0CFE: 08          EX   AF,AF'
0CFF: 14          INC  D
0D00: 0F          RRCA
0D01: 42          LD   B,D
0D02: 00          NOP
0D03: 04          INC  B
0D04: 54          LD   D,H
0D05: 00          NOP
0D06: FF          RST  $38
0D07: 74          LD   (HL),H
0D08: 00          NOP
0D09: 01 0D 4C    LD   BC,$4C0D
0D0C: 00          NOP
0D0D: 01 51 00    LD   BC,$0051
0D10: FF          RST  $38
0D11: 71          LD   (HL),C
0D12: 00          NOP
0D13: FF          RST  $38
0D14: 0C          INC  C
0D15: E0          RET  PO

0D16: 09          ADD  HL,BC
0D17: 07          RLCA
0D18: 21 E1 0D    LD   HL,$0DE1
0D1B: 17          RLA
0D1C: 0C          INC  C
0D1D: 14          INC  D
0D1E: 00          NOP
0D1F: 94          SUB  H
0D20: 22 02 74    LD   ($7402),HL
0D23: 00          NOP
0D24: 1F          RRA
0D25: 0D          DEC  C
0D26: 57          LD   D,A
0D27: 00          NOP
0D28: FF          RST  $38
0D29: 77          LD   (HL),A
0D2A: 00          NOP
0D2B: 1F          RRA
0D2C: 0D          DEC  C
0D2D: E0          RET  PO

0D2E: 00          NOP
0D2F: FF          RST  $38
0D30: 01 03 08    LD   BC,$0803
0D33: 03          INC  BC
0D34: 10 05       DJNZ $0D3B
0D36: 50          LD   D,B
0D37: 00          NOP
0D38: FF          RST  $38
0D39: 70          LD   (HL),B
0D3A: 00          NOP
0D3B: 36 0D       LD   (HL),$0D
0D3D: 48          LD   C,B
0D3E: 00          NOP
0D3F: 01 68 0A    LD   BC,$0A68
0D42: 3D          DEC  A
0D43: 0D          DEC  C
0D44: E0          RET  PO

0D45: 00          NOP
0D46: 1C          INC  E
0D47: 01 00 08    LD   BC,$0800
0D4A: 10 10       DJNZ $0D5C
0D4C: 0C          INC  C
0D4D: 0B          DEC  BC
0D4E: 1F          RRA
0D4F: 0C          INC  C
0D50: 00          NOP
0D51: 0D          DEC  C
0D52: 0E 50       LD   C,$50
0D54: 00          NOP
0D55: FF          RST  $38
0D56: 40          LD   B,B
0D57: 00          NOP
0D58: 68          LD   L,B
0D59: 70          LD   (HL),B
0D5A: 00          NOP
0D5B: 53          LD   D,E
0D5C: 0D          DEC  C
0D5D: E0          RET  PO

0D5E: 01 00 10    LD   BC,$1000
0D61: 05          DEC  B
0D62: 08          EX   AF,AF'
0D63: 0B          DEC  BC
0D64: 00          NOP
0D65: F0          RET  P

0D66: 40          LD   B,B
0D67: 00          NOP
0D68: E0          RET  PO

0D69: 60          LD   H,B
0D6A: 50          LD   D,B
0D6B: 66          LD   H,(HL)
0D6C: 0D          DEC  C
0D6D: 40          LD   B,B
0D6E: 00          NOP
0D6F: 10 60       DJNZ $0DD1
0D71: A0          AND  B
0D72: 6D          LD   L,L
0D73: 0D          DEC  C
0D74: 41          LD   B,C
0D75: 00          NOP
0D76: 01 50 00    LD   BC,$0050
0D79: FF          RST  $38
0D7A: 70          LD   (HL),B
0D7B: 00          NOP
0D7C: 64          LD   H,H
0D7D: 0D          DEC  C
0D7E: E0          RET  PO

0D7F: 08          EX   AF,AF'
0D80: 0A          LD   A,(BC)
0D81: 20 01       JR   NZ,$0D84
0D83: 0F          RRCA
0D84: 16 0F       LD   D,$0F
0D86: 13          INC  DE
0D87: 00          NOP
0D88: 93          SUB  E
0D89: 02          LD   (BC),A
0D8A: 00          NOP
0D8B: 73          LD   (HL),E
0D8C: 00          NOP
0D8D: 88          ADC  A,B
0D8E: 0D          DEC  C
0D8F: 56          LD   D,(HL)
0D90: 00          NOP
0D91: FF          RST  $38
0D92: 76          HALT
0D93: 00          NOP
0D94: 88          ADC  A,B
0D95: 0D          DEC  C
0D96: E0          RET  PO

0D97: 09          ADD  HL,BC
0D98: 0A          LD   A,(BC)
0D99: 21 62 0E    LD   HL,$0E62
0D9C: 17          RLA
0D9D: 20 14       JR   NZ,$0DB3
0D9F: 00          NOP
0DA0: 94          SUB  H
0DA1: 22 02 74    LD   ($7402),HL
0DA4: 00          NOP
0DA5: A0          AND  B
0DA6: 0D          DEC  C
0DA7: 57          LD   D,A
0DA8: 00          NOP
0DA9: FF          RST  $38
0DAA: 77          LD   (HL),A
0DAB: 00          NOP
0DAC: A0          AND  B
0DAD: 0D          DEC  C
0DAE: E0          RET  PO

0DAF: 08          EX   AF,AF'
0DB0: 0A          LD   A,(BC)
0DB1: 10 04       DJNZ $0DB7
0DB3: 01 02 00    LD   BC,$0002
0DB6: 0A          LD   A,(BC)
0DB7: 40          LD   B,B
0DB8: 00          NOP
0DB9: 05          DEC  B
0DBA: 41          LD   B,C
0DBB: 00          NOP
0DBC: 03          INC  BC
0DBD: 60          LD   H,B
0DBE: 5A          LD   E,D
0DBF: B7          OR   A
0DC0: 0D          DEC  C
0DC1: 50          LD   D,B
0DC2: 00          NOP
0DC3: FF          RST  $38
0DC4: 70          LD   (HL),B
0DC5: 00          NOP
0DC6: B5          OR   L
0DC7: 0D          DEC  C
0DC8: E0          RET  PO

0DC9: 08          EX   AF,AF'
0DCA: 07          RLCA
0DCB: 20 DC       JR   NZ,$0DA9
0DCD: 0F          RRCA
0DCE: 16 48       LD   D,$48
0DD0: 13          INC  DE
0DD1: 00          NOP
0DD2: 93          SUB  E
0DD3: 02          LD   (BC),A
0DD4: 00          NOP
0DD5: 73          LD   (HL),E
0DD6: 00          NOP
0DD7: D2 0D 56    JP   NC,$560D
0DDA: 00          NOP
0DDB: FF          RST  $38
0DDC: 76          HALT
0DDD: 00          NOP
0DDE: D2 0D E0    JP   NC,$E00D
0DE1: 02          LD   (BC),A
0DE2: E8          RET  PE

0DE3: 01 01 00    LD   BC,$0001
0DE6: 00          NOP
0DE7: 02          LD   (BC),A
0DE8: 83          ADD  A,E
0DE9: 01 01 00    LD   BC,$0001
0DEC: 00          NOP
0DED: 02          LD   (BC),A
0DEE: 45          LD   B,L
0DEF: 01 01 00    LD   BC,$0001
0DF2: 00          NOP
0DF3: 06 7A       LD   B,$7A
0DF5: 00          NOP
0DF6: 06 00       LD   B,$00
0DF8: 00          NOP
0DF9: 04          INC  B
0DFA: 91          SUB  C
0DFB: 00          NOP
0DFC: 02          LD   (BC),A
0DFD: 00          NOP
0DFE: 00          NOP
0DFF: 0A          LD   A,(BC)
0E00: 7A          LD   A,D
0E01: 00          NOP
0E02: 12          LD   (DE),A
0E03: 00          NOP
0E04: 00          NOP
0E05: 03          INC  BC
0E06: 23          INC  HL
0E07: 01 01 00    LD   BC,$0001
0E0A: 00          NOP
0E0B: 03          INC  BC
0E0C: 00          NOP
0E0D: 01 01 00    LD   BC,$0001
0E10: 00          NOP
0E11: 05          DEC  B
0E12: 3C          INC  A
0E13: 00          NOP
0E14: 01 00 00    LD   BC,$0000
0E17: 05          DEC  B
0E18: 78          LD   A,B
0E19: 00          NOP
0E1A: 01 00 00    LD   BC,$0000
0E1D: 05          DEC  B
0E1E: 55          LD   D,L
0E1F: 00          NOP
0E20: 01 00 00    LD   BC,$0000
0E23: 05          DEC  B
0E24: C8          RET  Z

0E25: 00          NOP
0E26: 01 00 00    LD   BC,$0000
0E29: 03          INC  BC
0E2A: 4B          LD   C,E
0E2B: 01 01 00    LD   BC,$0001
0E2E: 00          NOP
0E2F: 03          INC  BC
0E30: 78          LD   A,B
0E31: 00          NOP
0E32: 01 00 00    LD   BC,$0000
0E35: 03          INC  BC
0E36: 55          LD   D,L
0E37: 00          NOP
0E38: 01 00 00    LD   BC,$0000
0E3B: 02          LD   (BC),A
0E3C: C3 00 01    JP   $0100
0E3F: 00          NOP
0E40: 00          NOP
0E41: 02          LD   (BC),A
0E42: 41          LD   B,C
0E43: 00          NOP
0E44: 02          LD   (BC),A
0E45: 00          NOP
0E46: 00          NOP
0E47: 03          INC  BC
0E48: 3C          INC  A
0E49: 00          NOP
0E4A: 02          LD   (BC),A
0E4B: 00          NOP
0E4C: 00          NOP
0E4D: 02          LD   (BC),A
0E4E: 37          SCF
0E4F: 00          NOP
0E50: 02          LD   (BC),A
0E51: 00          NOP
0E52: 00          NOP
0E53: 02          LD   (BC),A
0E54: 32 00 02    LD   ($0200),A
0E57: 00          NOP
0E58: 00          NOP
0E59: 02          LD   (BC),A
0E5A: 2F          CPL
0E5B: 00          NOP
0E5C: 02          LD   (BC),A
0E5D: 00          NOP
0E5E: 00          NOP
0E5F: 03          INC  BC
0E60: 2C          INC  L
0E61: 00          NOP
0E62: 04          INC  B
0E63: 81          ADD  A,C
0E64: 00          NOP
0E65: 03          INC  BC
0E66: 00          NOP
0E67: 00          NOP
0E68: 04          INC  B
0E69: 34          INC  (HL)
0E6A: 01 03 00    LD   BC,$0003
0E6D: 00          NOP
0E6E: 02          LD   (BC),A
0E6F: B0          OR   B
0E70: 02          LD   (BC),A
0E71: 02          LD   (BC),A
0E72: 0E 03       LD   C,$03
0E74: 01 00 00    LD   BC,$0000
0E77: 02          LD   (BC),A
0E78: A1          AND  C
0E79: 03          INC  BC
0E7A: 01 00 00    LD   BC,$0000
0E7D: 04          INC  B
0E7E: A9          XOR  C
0E7F: 03          INC  BC
0E80: 02          LD   (BC),A
0E81: 00          NOP
0E82: 00          NOP
0E83: 02          LD   (BC),A
0E84: 00          NOP
0E85: 01 02 00    LD   BC,$0002
0E88: 00          NOP
0E89: 02          LD   (BC),A
0E8A: F3          DI
0E8B: 02          LD   (BC),A
0E8C: 03          INC  BC
0E8D: 00          NOP
0E8E: 00          NOP
0E8F: 02          LD   (BC),A
0E90: CD 00 03    CALL $0300
0E93: 00          NOP
0E94: 00          NOP
0E95: 01 B7 00    LD   BC,$00B7
0E98: 03          INC  BC
0E99: 00          NOP
0E9A: 00          NOP
0E9B: 05          DEC  B
0E9C: 6A          LD   L,D
0E9D: 00          NOP
0E9E: 02          LD   (BC),A
0E9F: 00          NOP
0EA0: 00          NOP
0EA1: 03          INC  BC
0EA2: 93          SUB  E
0EA3: 00          NOP
0EA4: 03          INC  BC
0EA5: 00          NOP
0EA6: 00          NOP
0EA7: 03          INC  BC
0EA8: 52          LD   D,D
0EA9: 00          NOP
0EAA: 02          LD   (BC),A
0EAB: 00          NOP
0EAC: 00          NOP
0EAD: 03          INC  BC
0EAE: 32 00 02    LD   ($0200),A
0EB1: 00          NOP
0EB2: 00          NOP
0EB3: 03          INC  BC
0EB4: 2B          DEC  HL
0EB5: 00          NOP
0EB6: 02          LD   (BC),A
0EB7: 00          NOP
0EB8: 00          NOP
0EB9: 03          INC  BC
0EBA: 32 00 02    LD   ($0200),A
0EBD: 00          NOP
0EBE: 00          NOP
0EBF: 08          EX   AF,AF'
0EC0: 64          LD   H,H
0EC1: 00          NOP
0EC2: 07          RLCA
0EC3: 7F          LD   A,A
0EC4: 01 01 00    LD   BC,$0001
0EC7: 00          NOP
0EC8: 02          LD   (BC),A
0EC9: 32 02 02    LD   ($0202),A
0ECC: 64          LD   H,H
0ECD: 02          LD   (BC),A
0ECE: 02          LD   (BC),A
0ECF: 96          SUB  (HL)
0ED0: 02          LD   (BC),A
0ED1: 01 00 00    LD   BC,$0000
0ED4: 01 C8 06    LD   BC,$06C8
0ED7: 01 00 00    LD   BC,$0000
0EDA: 01 C8 06    LD   BC,$06C8
0EDD: 01 00 00    LD   BC,$0000
0EE0: 01 C8 06    LD   BC,$06C8
0EE3: 01 00 00    LD   BC,$0000
0EE6: 01 C8 06    LD   BC,$06C8
0EE9: 01 00 00    LD   BC,$0000
0EEC: 01 C8 06    LD   BC,$06C8
0EEF: 01 00 00    LD   BC,$0000
0EF2: 01 C8 06    LD   BC,$06C8
0EF5: 01 00 00    LD   BC,$0000
0EF8: 01 C8 06    LD   BC,$06C8
0EFB: 01 00 00    LD   BC,$0000
0EFE: 03          INC  BC
0EFF: 00          NOP
0F00: 05          DEC  B
0F01: 03          INC  BC
0F02: F0          RET  P

0F03: 00          NOP
0F04: 01 00 00    LD   BC,$0000
0F07: 02          LD   (BC),A
0F08: 1E 01       LD   E,$01
0F0A: 01 00 00    LD   BC,$0000
0F0D: 02          LD   (BC),A
0F0E: 1E 02       LD   E,$02
0F10: 01 00 00    LD   BC,$0000
0F13: 02          LD   (BC),A
0F14: 1E 03       LD   E,$03
0F16: 01 00 00    LD   BC,$0000
0F19: 02          LD   (BC),A
0F1A: 1E 04       LD   E,$04
0F1C: 01 00 00    LD   BC,$0000
0F1F: 02          LD   (BC),A
0F20: 1E 05       LD   E,$05
0F22: 01 00 00    LD   BC,$0000
0F25: 02          LD   (BC),A
0F26: 1E 06       LD   E,$06
0F28: 01 00 00    LD   BC,$0000
0F2B: 02          LD   (BC),A
0F2C: 1E 07       LD   E,$07
0F2E: 01 96 03    LD   BC,$0396
0F31: 04          INC  B
0F32: 00          NOP
0F33: 00          NOP
0F34: 01 C8 03    LD   BC,$03C8
0F37: 04          INC  B
0F38: 00          NOP
0F39: 00          NOP
0F3A: 01 64 03    LD   BC,$0364
0F3D: 04          INC  B
0F3E: 00          NOP
0F3F: 00          NOP
0F40: 01 96 02    LD   BC,$0296
0F43: 04          INC  B
0F44: 00          NOP
0F45: 00          NOP
0F46: 01 C8 02    LD   BC,$02C8
0F49: 04          INC  B
0F4A: 00          NOP
0F4B: 00          NOP
0F4C: 01 64 02    LD   BC,$0264
0F4F: 04          INC  B
0F50: 00          NOP
0F51: 00          NOP
0F52: 01 96 01    LD   BC,$0196
0F55: 04          INC  B
0F56: 00          NOP
0F57: 00          NOP
0F58: 01 C8 01    LD   BC,$01C8
0F5B: 04          INC  B
0F5C: 00          NOP
0F5D: 00          NOP
0F5E: 01 64 01    LD   BC,$0164
0F61: 04          INC  B
0F62: 00          NOP
0F63: 00          NOP
0F64: 01 96 00    LD   BC,$0096
0F67: 04          INC  B
0F68: 00          NOP
0F69: 00          NOP
0F6A: 01 C8 00    LD   BC,$00C8
0F6D: 04          INC  B
0F6E: 00          NOP
0F6F: 00          NOP
0F70: 01 64 00    LD   BC,$0064
0F73: 04          INC  B
0F74: 00          NOP
0F75: 00          NOP
0F76: 01 78 01    LD   BC,$0178
0F79: 03          INC  BC
0F7A: 00          NOP
0F7B: 00          NOP
0F7C: 01 A0 01    LD   BC,$01A0
0F7F: 03          INC  BC
0F80: 00          NOP
0F81: 00          NOP
0F82: 01 4B 01    LD   BC,$014B
0F85: 03          INC  BC
0F86: 00          NOP
0F87: 00          NOP
0F88: 01 78 00    LD   BC,$0078
0F8B: 03          INC  BC
0F8C: 00          NOP
0F8D: 00          NOP
0F8E: 01 A0 00    LD   BC,$00A0
0F91: 03          INC  BC
0F92: 00          NOP
0F93: 00          NOP
0F94: 01 4B 00    LD   BC,$004B
0F97: 01 5A 01    LD   BC,$015A
0F9A: 02          LD   (BC),A
0F9B: 00          NOP
0F9C: 00          NOP
0F9D: 01 78 01    LD   BC,$0178
0FA0: 02          LD   (BC),A
0FA1: 00          NOP
0FA2: 00          NOP
0FA3: 01 32 01    LD   BC,$0132
0FA6: 02          LD   (BC),A
0FA7: 00          NOP
0FA8: 00          NOP
0FA9: 01 5A 00    LD   BC,$005A
0FAC: 02          LD   (BC),A
0FAD: 00          NOP
0FAE: 00          NOP
0FAF: 01 78 00    LD   BC,$0078
0FB2: 02          LD   (BC),A
0FB3: 00          NOP
0FB4: 00          NOP
0FB5: 01 32 00    LD   BC,$0032
0FB8: 02          LD   (BC),A
0FB9: 00          NOP
0FBA: 00          NOP
0FBB: 01 3C 01    LD   BC,$013C
0FBE: 01 00 00    LD   BC,$0000
0FC1: 01 50 01    LD   BC,$0150
0FC4: 01 00 00    LD   BC,$0000
0FC7: 01 1E 01    LD   BC,$011E
0FCA: 01 00 00    LD   BC,$0000
0FCD: 01 3C 00    LD   BC,$003C
0FD0: 01 00 00    LD   BC,$0000
0FD3: 01 50 00    LD   BC,$0050
0FD6: 01 00 00    LD   BC,$0000
0FD9: 01 1E 00    LD   BC,$001E
0FDC: 03          INC  BC
0FDD: 6D          LD   L,L
0FDE: 01 03 59    LD   BC,$5903
0FE1: 01 03 45    LD   BC,$4503
0FE4: 01 03 33    LD   BC,$3303
0FE7: 01 03 22    LD   BC,$2203
0FEA: 01 03 12    LD   BC,$1203
0FED: 01 03 02    LD   BC,$0203
0FF0: 01 03 F4    LD   BC,$F403
0FF3: 00          NOP
0FF4: 03          INC  BC
0FF5: E6 00       AND  $00
0FF7: 03          INC  BC
0FF8: D9          EXX
0FF9: 00          NOP
0FFA: 03          INC  BC
0FFB: CD 00 03    CALL $0300
0FFE: C2 00 03    JP   NZ,$0300
1001: B7          OR   A
1002: 00          NOP
1003: 03          INC  BC
1004: AC          XOR  H
1005: 00          NOP
1006: 03          INC  BC
1007: A3          AND  E
1008: 00          NOP
1009: 03          INC  BC
100A: 9A          SBC  A,D
100B: 00          NOP
100C: 03          INC  BC
100D: 91          SUB  C
100E: 00          NOP
100F: 03          INC  BC
1010: 89          ADC  A,C
1011: 00          NOP
1012: 03          INC  BC
1013: A3          AND  E
1014: 00          NOP
1015: 03          INC  BC
1016: 9A          SBC  A,D
1017: 00          NOP
1018: 03          INC  BC
1019: 91          SUB  C
101A: 00          NOP
101B: 03          INC  BC
101C: AC          XOR  H
101D: 00          NOP
101E: 03          INC  BC
101F: A3          AND  E
1020: 00          NOP
1021: 03          INC  BC
1022: 9A          SBC  A,D
1023: 00          NOP
1024: 03          INC  BC
1025: B7          OR   A
1026: 00          NOP
1027: 03          INC  BC
1028: AC          XOR  H
1029: 00          NOP
102A: 03          INC  BC
102B: A3          AND  E
102C: 00          NOP
102D: 03          INC  BC
102E: C2 00 03    JP   NZ,$0300
1031: B7          OR   A
1032: 00          NOP
1033: 03          INC  BC
1034: AC          XOR  H
1035: 00          NOP
1036: 03          INC  BC
1037: A3          AND  E
1038: 00          NOP
1039: 03          INC  BC
103A: 9A          SBC  A,D
103B: 00          NOP
103C: 03          INC  BC
103D: 91          SUB  C
103E: 00          NOP
103F: 03          INC  BC
1040: 89          ADC  A,C
1041: 00          NOP
1042: 03          INC  BC
1043: 81          ADD  A,C
1044: 00          NOP
1045: 03          INC  BC
1046: 7A          LD   A,D
1047: 00          NOP
1048: 03          INC  BC
1049: 73          LD   (HL),E
104A: 00          NOP
104B: 03          INC  BC
104C: 6D          LD   L,L
104D: 00          NOP
104E: 03          INC  BC
104F: 67          LD   H,A
1050: 00          NOP
1051: 03          INC  BC
1052: 61          LD   H,C
1053: 00          NOP
1054: 03          INC  BC
1055: 5B          LD   E,E
1056: 00          NOP
1057: 03          INC  BC
1058: 56          LD   D,(HL)
1059: 00          NOP
105A: 03          INC  BC
105B: 51          LD   D,C
105C: 00          NOP
105D: 03          INC  BC
105E: 4D          LD   C,L
105F: 00          NOP
1060: 03          INC  BC
1061: 48          LD   C,B
1062: 00          NOP
1063: 03          INC  BC
1064: 56          LD   D,(HL)
1065: 00          NOP
1066: 03          INC  BC
1067: 51          LD   D,C
1068: 00          NOP
1069: 03          INC  BC
106A: 4D          LD   C,L
106B: 00          NOP
106C: 03          INC  BC
106D: 5B          LD   E,E
106E: 00          NOP
106F: 03          INC  BC
1070: 56          LD   D,(HL)
1071: 00          NOP
1072: 03          INC  BC
1073: 51          LD   D,C
1074: 00          NOP
1075: 03          INC  BC
1076: 61          LD   H,C
1077: 00          NOP
1078: 03          INC  BC
1079: 5B          LD   E,E
107A: 00          NOP
107B: 03          INC  BC
107C: 56          LD   D,(HL)
107D: 00          NOP
107E: 03          INC  BC
107F: 67          LD   H,A
1080: 00          NOP
1081: 03          INC  BC
1082: 61          LD   H,C
1083: 00          NOP
1084: 03          INC  BC
1085: 5B          LD   E,E
1086: 00          NOP
1087: 03          INC  BC
1088: 56          LD   D,(HL)
1089: 00          NOP
108A: 03          INC  BC
108B: 51          LD   D,C
108C: 00          NOP
108D: 03          INC  BC
108E: 4D          LD   C,L
108F: 00          NOP
1090: 03          INC  BC
1091: 48          LD   C,B
1092: 00          NOP
1093: 03          INC  BC
1094: 44          LD   B,H
1095: 00          NOP
1096: 03          INC  BC
1097: 41          LD   B,C
1098: 00          NOP
1099: 03          INC  BC
109A: 3D          DEC  A
109B: 00          NOP
109C: 03          INC  BC
109D: 3A 00 03    LD   A,($0300)
10A0: 36 00       LD   (HL),$00
10A2: 03          INC  BC
10A3: 33          INC  SP
10A4: 00          NOP
10A5: 03          INC  BC
10A6: 30 00       JR   NC,$10A8
10A8: 03          INC  BC
10A9: 2E 00       LD   L,$00
10AB: 03          INC  BC
10AC: 2B          DEC  HL
10AD: 00          NOP
10AE: 03          INC  BC
10AF: 29          ADD  HL,HL
10B0: 00          NOP
10B1: 03          INC  BC
10B2: 27          DAA
10B3: 00          NOP
10B4: F5          PUSH AF
10B5: E6 F0       AND  $F0
10B7: 0F          RRCA
10B8: 0F          RRCA
10B9: 0F          RRCA
10BA: 0F          RRCA
10BB: 47          LD   B,A
10BC: F1          POP  AF
10BD: E6 0F       AND  $0F
10BF: 4F          LD   C,A
10C0: C9          RET

10C1: E5          PUSH HL
10C2: 68          LD   L,B
10C3: CD CC 10    CALL $10CC
10C6: 69          LD   L,C
10C7: CD CC 10    CALL $10CC
10CA: E1          POP  HL
10CB: C9          RET

10CC: F5          PUSH AF
10CD: C5          PUSH BC
10CE: D5          PUSH DE
10CF: 45          LD   B,L
10D0: 26 00       LD   H,$00
10D2: CD 45 11    CALL $1145
10D5: 11 D1 14    LD   DE,$14D1
10D8: 19          ADD  HL,DE
10D9: 3A 80 7C    LD   A,($7C80)
10DC: FE 00       CP   $00
10DE: 28 0E       JR   Z,$10EE
10E0: 78          LD   A,B
10E1: FE 00       CP   $00
10E3: 28 06       JR   Z,$10EB
10E5: 97          SUB  A
10E6: 32 80 7C    LD   ($7C80),A
10E9: 18 03       JR   $10EE
10EB: 21 57 13    LD   HL,$1357
10EE: CD 03 13    CALL $1303
10F1: D1          POP  DE
10F2: C1          POP  BC
10F3: F1          POP  AF
10F4: C9          RET

10F5: E5          PUSH HL
10F6: 68          LD   L,B
10F7: CD 00 11    CALL $1100
10FA: 69          LD   L,C
10FB: CD 00 11    CALL $1100
10FE: E1          POP  HL
10FF: C9          RET

1100: F5          PUSH AF
1101: C5          PUSH BC
1102: D5          PUSH DE
1103: 45          LD   B,L
1104: 26 00       LD   H,$00
1106: 7D          LD   A,L
1107: 07          RLCA
1108: 07          RLCA
1109: 85          ADD  A,L
110A: 6F          LD   L,A
110B: 11 54 17    LD   DE,$1754
110E: 19          ADD  HL,DE
110F: 3A 80 7C    LD   A,($7C80)
1112: FE 00       CP   $00
1114: 28 0E       JR   Z,$1124
1116: 78          LD   A,B
1117: FE 00       CP   $00
1119: 28 06       JR   Z,$1121
111B: 97          SUB  A
111C: 32 80 7C    LD   ($7C80),A
111F: 18 03       JR   $1124
1121: 21 4F 17    LD   HL,$174F
1124: CD 67 16    CALL $1667
1127: D1          POP  DE
1128: C1          POP  BC
1129: F1          POP  AF
112A: C9          RET

112B: E5          PUSH HL
112C: 16 00       LD   D,$00
112E: 5F          LD   E,A
112F: 62          LD   H,D
1130: 6A          LD   L,D
1131: 19          ADD  HL,DE
1132: 10 FD       DJNZ $1131
1134: EB          EX   DE,HL
1135: E1          POP  HL
1136: C9          RET

1137: E5          PUSH HL
1138: 6B          LD   L,E
1139: 62          LD   H,D
113A: 29          ADD  HL,HL
113B: 29          ADD  HL,HL
113C: 29          ADD  HL,HL
113D: 29          ADD  HL,HL
113E: 19          ADD  HL,DE
113F: 29          ADD  HL,HL
1140: 29          ADD  HL,HL
1141: 29          ADD  HL,HL
1142: EB          EX   DE,HL
1143: E1          POP  HL
1144: C9          RET

1145: D5          PUSH DE
1146: 5D          LD   E,L
1147: 54          LD   D,H
1148: 29          ADD  HL,HL
1149: 19          ADD  HL,DE
114A: 29          ADD  HL,HL
114B: 19          ADD  HL,DE
114C: 29          ADD  HL,HL
114D: D1          POP  DE
114E: C9          RET

114F: C5          PUSH BC
1150: D5          PUSH DE
1151: E5          PUSH HL
1152: F5          PUSH AF
1153: 3E 88       LD   A,$88
1155: 90          SUB  B
1156: 51          LD   D,C
1157: 4F          LD   C,A
1158: F1          POP  AF
1159: 58          LD   E,B
115A: 77          LD   (HL),A
115B: 23          INC  HL
115C: 10 FC       DJNZ $115A
115E: 09          ADD  HL,BC
115F: 43          LD   B,E
1160: 15          DEC  D
1161: 20 F7       JR   NZ,$115A
1163: E1          POP  HL
1164: D1          POP  DE
1165: C1          POP  BC
1166: C9          RET

;SUBROUTINE: DRAW_ELEVATOR - Draws elevator borders when they are in motion

1167: C5          PUSH BC			;Store registers
1168: D5          PUSH DE
1169: E5          PUSH HL
116A: 32 A9 78    LD   ($78A9),A	;Load brush color into memory
116D: 3E 88       LD   A,$88		;Load the maximum horizontal draw distance
116F: 90          SUB  B			;Calculate the number of vertical pixel groups to draw on this CALL
1170: 51          LD   D,C			;Load the horizontal distance to perform the draw (in units of pixel groups)
1171: 4F          LD   C,A			;Load the distance to jump in memory to make the next draw (used at 0x117B: ADD HL, BC)
1172: 58          LD   E,B			;Store the vertical distance to perform the draw (in units of pixel groups)
1173: 3A A9 78    LD   A,($78A9)	;Load brush color into A
1176: AE          XOR  (HL)			;XOR (complement) the data at address in HL with A and store result in A
1177: 77          LD   (HL),A		;Draw the color in A to the address in HL
1178: 23          INC  HL			;Move to the next vertical pixel group
1179: 10 F8       DJNZ $1173		;Decrement the vertical pixel group counter
117B: 09          ADD  HL,BC		;Move to the next horizontal pixel group (B will always be $00 at this point, so, technically, only C is added to HL
117C: 43          LD   B,E			;Re-initialize the vertical pixel group counter
117D: 15          DEC  D			;Loop counter - used to set the zero flag to skip the following jump
117E: 20 F3       JR   NZ,$1173		;Loop back to beginning of draw routine
1180: E1          POP  HL			;Reload registers before returning
1181: D1          POP  DE
1182: C1          POP  BC
1183: C9          RET

1184: 7E          LD   A,(HL)
1185: 12          LD   (DE),A
1186: 23          INC  HL
1187: 13          INC  DE
1188: 10 FA       DJNZ $1184
118A: C9          RET

118B: F5          PUSH AF
118C: 3E 01       LD   A,$01
118E: 32 5E 7D    LD   ($7D5E),A
1191: 3A 5E 7D    LD   A,($7D5E)
1194: FB          EI
1195: FE 00       CP   $00
1197: 20 F8       JR   NZ,$1191
1199: F1          POP  AF
119A: C9          RET

119B: F5          PUSH AF
119C: 78          LD   A,B
119D: 32 5D 7D    LD   ($7D5D),A
11A0: D3 00       OUT  ($00),A
11A2: FB          EI
11A3: 3A 5D 7D    LD   A,($7D5D)
11A6: FE 00       CP   $00
11A8: 20 F6       JR   NZ,$11A0
11AA: F1          POP  AF
11AB: C9          RET

;SUBROUTINE: DELAY_LOOP - This appears to loop through 65,790 iterations, as B is almost always loaded as $00. Is it a delay loop to allow [video] hardware to catch up?

11AC: C5          PUSH BC
11AD: 0E 00       LD   C,$00
11AF: 0D          DEC  C
11B0: 20 FD       JR   NZ,$11AF
11B2: D3 00       OUT  ($00),A
11B4: 10 F9       DJNZ $11AF
11B6: C1          POP  BC
11B7: C9          RET

11B8: 06 02       LD   B,$02
11BA: CD 9B 11    CALL $119B
11BD: D5          PUSH DE
11BE: E5          PUSH HL
11BF: 21 BF 7C    LD   HL,$7CBF
11C2: 11 04 00    LD   DE,$0004
11C5: 06 03       LD   B,$03
11C7: 4E          LD   C,(HL)
11C8: B9          CP   C
11C9: 28 05       JR   Z,$11D0
11CB: 19          ADD  HL,DE
11CC: 10 F9       DJNZ $11C7
11CE: 18 17       JR   $11E7
11D0: 2B          DEC  HL
11D1: 3A 8C 7C    LD   A,($7C8C)
11D4: FE 01       CP   $01
11D6: 20 08       JR   NZ,$11E0
11D8: FB          EI
11D9: 3A B5 7C    LD   A,($7CB5)
11DC: FE 00       CP   $00
11DE: 28 07       JR   Z,$11E7
11E0: 7E          LD   A,(HL)
11E1: D3 00       OUT  ($00),A
11E3: FE 00       CP   $00
11E5: 20 EA       JR   NZ,$11D1
11E7: E1          POP  HL
11E8: D1          POP  DE
11E9: C9          RET

11EA: 06 3C       LD   B,$3C
11EC: CD 03 12    CALL $1203
11EF: FB          EI
11F0: 3A 5E 7D    LD   A,($7D5E)
11F3: FE 00       CP   $00
11F5: 20 F5       JR   NZ,$11EC
11F7: D3 00       OUT  ($00),A
11F9: 3C          INC  A
11FA: 32 5E 7D    LD   ($7D5E),A
11FD: 10 ED       DJNZ $11EC
11FF: 0D          DEC  C
1200: 20 E8       JR   NZ,$11EA
1202: C9          RET

1203: F5          PUSH AF
1204: 3A 65 7D    LD   A,($7D65)
1207: FE 00       CP   $00
1209: 20 02       JR   NZ,$120D
120B: F1          POP  AF
120C: C9          RET

120D: 31 FF 7F    LD   SP,$7FFF
1210: 3E 0A       LD   A,$0A
1212: D3 06       OUT  ($06),A
1214: 97          SUB  A
1215: 32 8C 7C    LD   ($7C8C),A
1218: 32 78 7D    LD   ($7D78),A
121B: D3 02       OUT  ($02),A
121D: FB          EI
121E: C3 86 20    JP   $2086
1221: F5          PUSH AF
1222: C5          PUSH BC
1223: D5          PUSH DE
1224: E5          PUSH HL
1225: 16 00       LD   D,$00
1227: 59          LD   E,C
1228: 26 80       LD   H,$80
122A: 6A          LD   L,D
122B: 22 50 7C    LD   ($7C50),HL
122E: 77          LD   (HL),A
122F: 19          ADD  HL,DE
1230: CB 7C       BIT  7,H
1232: 20 FA       JR   NZ,$122E
1234: D3 00       OUT  ($00),A
1236: 2A 50 7C    LD   HL,($7C50)
1239: 23          INC  HL
123A: 22 50 7C    LD   ($7C50),HL
123D: 0D          DEC  C
123E: 20 EE       JR   NZ,$122E
1240: E1          POP  HL
1241: D1          POP  DE
1242: C1          POP  BC
1243: F1          POP  AF
1244: C9          RET

;SUBROUTINE: DEATH_SPIRAL - Draws the spiraling, black letterbox that fills the screen upon losing a life

1245: F5          PUSH AF
1246: C5          PUSH BC
1247: D5          PUSH DE
1248: E5          PUSH HL
1249: 08          EX   AF,AF'
124A: 3E 44       LD   A,$44
124C: 21 FF 7F    LD   HL,$7FFF
124F: D9          EXX
1250: 21 89 00    LD   HL,$0089
1253: 11 EC 00    LD   DE,$00EC
1256: 08          EX   AF,AF'
1257: 2B          DEC  HL
1258: E5          PUSH HL
1259: D9          EXX
125A: C1          POP  BC
125B: 11 01 00    LD   DE,$0001			;Top black bar
125E: CD 8A 12    CALL $128A
1261: 1B          DEC  DE
1262: D5          PUSH DE
1263: D9          EXX
1264: C1          POP  BC
1265: 11 88 00    LD   DE,$0088			;Right black bar
1268: CD 8A 12    CALL $128A
126B: 2B          DEC  HL
126C: E5          PUSH HL
126D: D9          EXX
126E: C1          POP  BC
126F: 11 FF FF    LD   DE,$FFFF			;Bottom black bar
1272: CD 8A 12    CALL $128A
1275: 1B          DEC  DE
1276: D5          PUSH DE
1277: D9          EXX
1278: C1          POP  BC
1279: 11 78 FF    LD   DE,$FF78			;Left black bar
127C: CD 8A 12    CALL $128A
127F: 08          EX   AF,AF'
1280: 3D          DEC  A
1281: 20 D3       JR   NZ,$1256
1283: 08          EX   AF,AF'
1284: D9          EXX
1285: E1          POP  HL
1286: D1          POP  DE
1287: C1          POP  BC
1288: F1          POP  AF
1289: C9          RET

;SUBROUTINE: DEATH_SPIRAL_DRAW - Loads $00 into the relevant memory locations for each black bar

128A: 41          LD   B,C
128B: 19          ADD  HL,DE			;HL will be the address in video RAM to be written to
128C: 77          LD   (HL),A			;Load $00 (black) into the address
128D: 10 FC       DJNZ $128B			;Loop until B sets the zero flag
128F: D3 00       OUT  ($00),A			;Output to CRT controller via port $00?
1291: D9          EXX
1292: C9          RET

;SUBROUTINE: ROM_STATUS_OUTPUT - Output ROM OK/NOT OK status after performing checksums

1293: F5          PUSH AF
1294: 3E 01       LD   A,$01
1296: 18 02       JR   $129A
1298: F5          PUSH AF
1299: 97          SUB  A
129A: 32 F0 7B    LD   ($7BF0),A
129D: C5          PUSH BC
129E: D5          PUSH DE
129F: E5          PUSH HL
12A0: DD E5       PUSH IX
12A2: FD E5       PUSH IY
12A4: FD 46 00    LD   B,(IY+$00)
12A7: DD E5       PUSH IX
12A9: 11 57 13    LD   DE,$1357
12AC: 08          EX   AF,AF'
12AD: 3A F0 7B    LD   A,($7BF0)
12B0: FE 00       CP   $00
12B2: 28 03       JR   Z,$12B7
12B4: 11 CD 16    LD   DE,$16CD
12B7: 08          EX   AF,AF'
12B8: FD 23       INC  IY
12BA: FD 7E 00    LD   A,(IY+$00)
12BD: FE FF       CP   $FF
12BF: 28 15       JR   Z,$12D6
12C1: 6F          LD   L,A
12C2: 26 00       LD   H,$00
12C4: 08          EX   AF,AF'
12C5: CC 45 11    CALL Z,$1145
12C8: 19          ADD  HL,DE
12C9: D3 00       OUT  ($00),A
12CB: CC 03 13    CALL Z,$1303
12CE: C4 67 16    CALL NZ,$1667
12D1: 08          EX   AF,AF'
12D2: 10 D5       DJNZ $12A9
12D4: 18 22       JR   $12F8
12D6: FD 23       INC  IY
12D8: FD 7E 00    LD   A,(IY+$00)
12DB: FE 80       CP   $80
12DD: 28 06       JR   Z,$12E5
12DF: 32 F2 7B    LD   ($7BF2),A
12E2: 05          DEC  B
12E3: 18 ED       JR   $12D2
12E5: DD E1       POP  IX
12E7: 11 F8 FF    LD   DE,$FFF8
12EA: 08          EX   AF,AF'
12EB: 28 03       JR   Z,$12F0
12ED: 11 FC FF    LD   DE,$FFFC
12F0: 08          EX   AF,AF'
12F1: DD 19       ADD  IX,DE
12F3: DD E5       PUSH IX
12F5: 05          DEC  B
12F6: 18 DA       JR   $12D2
12F8: DD E1       POP  IX
12FA: FD E1       POP  IY
12FC: DD E1       POP  IX
12FE: E1          POP  HL
12FF: D1          POP  DE
1300: C1          POP  BC
1301: F1          POP  AF
1302: C9          RET

1303: C5          PUSH BC
1304: 11 04 00    LD   DE,$0004
1307: DD 19       ADD  IX,DE
1309: 0E 07       LD   C,$07
130B: 06 04       LD   B,$04
130D: CD 24 13    CALL $1324
1310: 06 03       LD   B,$03
1312: CD 24 13    CALL $1324
1315: 11 8F 00    LD   DE,$008F
1318: DD 19       ADD  IX,DE
131A: 0D          DEC  C
131B: 20 EE       JR   NZ,$130B
131D: 11 94 01    LD   DE,$0194
1320: DD 19       ADD  IX,DE
1322: C1          POP  BC
1323: C9          RET

1324: 5E          LD   E,(HL)
1325: 23          INC  HL
1326: 3A F1 7B    LD   A,($7BF1)
1329: FE 00       CP   $00
132B: 3A F3 7B    LD   A,($7BF3)
132E: 28 03       JR   Z,$1333
1330: DD 7E 00    LD   A,(IX+$00)
1333: CB 3B       SRL  E
1335: 30 0B       JR   NC,$1342
1337: E6 0F       AND  $0F
1339: 57          LD   D,A
133A: 3A F2 7B    LD   A,($7BF2)
133D: 07          RLCA
133E: 07          RLCA
133F: 07          RLCA
1340: 07          RLCA
1341: B2          OR   D
1342: CB 3B       SRL  E
1344: 30 09       JR   NC,$134F
1346: F6 0F       OR   $0F
1348: 57          LD   D,A
1349: 3A F2 7B    LD   A,($7BF2)
134C: F6 F0       OR   $F0
134E: A2          AND  D
134F: DD 77 00    LD   (IX+$00),A
1352: DD 2B       DEC  IX
1354: 10 D0       DJNZ $1326
1356: C9          RET

1357: 00          NOP
1358: 00          NOP
1359: 00          NOP
135A: 00          NOP
135B: 00          NOP
135C: 00          NOP
135D: 00          NOP
135E: 00          NOP
135F: 00          NOP
1360: 00          NOP
1361: 00          NOP
1362: 00          NOP
1363: 00          NOP
1364: 00          NOP
1365: F8          RET  M

1366: 03          INC  BC
1367: FC 03 CE    CALL M,$CE03
136A: 00          NOP
136B: C7          RST  $00
136C: 00          NOP
136D: CE 00       ADC  A,$00
136F: FC 03 F8    CALL M,$F803
1372: 03          INC  BC
1373: FF          RST  $38
1374: 03          INC  BC
1375: FF          RST  $38
1376: 03          INC  BC
1377: 33          INC  SP
1378: 03          INC  BC
1379: 33          INC  SP
137A: 03          INC  BC
137B: BB          CP   E
137C: 03          INC  BC
137D: FF          RST  $38
137E: 01 EE 00    LD   BC,$00EE
1381: FC 00 FE    CALL M,$FE00
1384: 01 87 03    LD   BC,$0387
1387: 03          INC  BC
1388: 03          INC  BC
1389: 03          INC  BC
138A: 03          INC  BC
138B: 03          INC  BC
138C: 03          INC  BC
138D: 03          INC  BC
138E: 03          INC  BC
138F: FF          RST  $38
1390: 03          INC  BC
1391: FF          RST  $38
1392: 03          INC  BC
1393: 03          INC  BC
1394: 03          INC  BC
1395: 03          INC  BC
1396: 03          INC  BC
1397: 87          ADD  A,A
1398: 03          INC  BC
1399: FE 01       CP   $01
139B: FC 00 FF    CALL M,$FF00
139E: 03          INC  BC
139F: FF          RST  $38
13A0: 03          INC  BC
13A1: 33          INC  SP
13A2: 03          INC  BC
13A3: 33          INC  SP
13A4: 03          INC  BC
13A5: 33          INC  SP
13A6: 03          INC  BC
13A7: 03          INC  BC
13A8: 03          INC  BC
13A9: 03          INC  BC
13AA: 03          INC  BC
13AB: FF          RST  $38
13AC: 03          INC  BC
13AD: FF          RST  $38
13AE: 03          INC  BC
13AF: 33          INC  SP
13B0: 00          NOP
13B1: 33          INC  SP
13B2: 00          NOP
13B3: 33          INC  SP
13B4: 00          NOP
13B5: 03          INC  BC
13B6: 00          NOP
13B7: 03          INC  BC
13B8: 00          NOP
13B9: FC 00 FE    CALL M,$FE00
13BC: 01 87 03    LD   BC,$0387
13BF: 03          INC  BC
13C0: 03          INC  BC
13C1: 63          LD   H,E
13C2: 03          INC  BC
13C3: E7          RST  $20
13C4: 03          INC  BC
13C5: E6 03       AND  $03
13C7: FF          RST  $38
13C8: 03          INC  BC
13C9: FF          RST  $38
13CA: 03          INC  BC
13CB: 30 00       JR   NC,$13CD
13CD: 30 00       JR   NC,$13CF
13CF: 30 00       JR   NC,$13D1
13D1: FF          RST  $38
13D2: 03          INC  BC
13D3: FF          RST  $38
13D4: 03          INC  BC
13D5: 00          NOP
13D6: 00          NOP
13D7: 03          INC  BC
13D8: 03          INC  BC
13D9: FF          RST  $38
13DA: 03          INC  BC
13DB: FF          RST  $38
13DC: 03          INC  BC
13DD: 03          INC  BC
13DE: 03          INC  BC
13DF: 00          NOP
13E0: 00          NOP
13E1: 00          NOP
13E2: 00          NOP
13E3: C0          RET  NZ

13E4: 00          NOP
13E5: C0          RET  NZ

13E6: 01 80 03    LD   BC,$0380
13E9: 00          NOP
13EA: 03          INC  BC
13EB: 80          ADD  A,B
13EC: 03          INC  BC
13ED: FF          RST  $38
13EE: 01 FF 00    LD   BC,$00FF
13F1: FF          RST  $38
13F2: 03          INC  BC
13F3: FF          RST  $38
13F4: 03          INC  BC
13F5: 78          LD   A,B
13F6: 00          NOP
13F7: FC 00 CE    CALL M,$CE00
13FA: 01 87 03    LD   BC,$0387
13FD: 03          INC  BC
13FE: 03          INC  BC
13FF: FF          RST  $38
1400: 03          INC  BC
1401: FF          RST  $38
1402: 03          INC  BC
1403: 00          NOP
1404: 03          INC  BC
1405: 00          NOP
1406: 03          INC  BC
1407: 00          NOP
1408: 03          INC  BC
1409: 00          NOP
140A: 03          INC  BC
140B: 00          NOP
140C: 03          INC  BC
140D: FF          RST  $38
140E: 03          INC  BC
140F: FE 03       CP   $03
1411: 1C          INC  E
1412: 00          NOP
1413: 38 00       JR   C,$1415
1415: 1C          INC  E
1416: 00          NOP
1417: FE 03       CP   $03
1419: FF          RST  $38
141A: 03          INC  BC
141B: FF          RST  $38
141C: 03          INC  BC
141D: FF          RST  $38
141E: 03          INC  BC
141F: 3C          INC  A
1420: 00          NOP
1421: 78          LD   A,B
1422: 00          NOP
1423: F0          RET  P

1424: 00          NOP
1425: FF          RST  $38
1426: 03          INC  BC
1427: FF          RST  $38
1428: 03          INC  BC
1429: FC 00 FE    CALL M,$FE00
142C: 01 87 03    LD   BC,$0387
142F: 03          INC  BC
1430: 03          INC  BC
1431: 87          ADD  A,A
1432: 03          INC  BC
1433: FE 01       CP   $01
1435: FC 00 FF    CALL M,$FF00
1438: 03          INC  BC
1439: FF          RST  $38
143A: 03          INC  BC
143B: 33          INC  SP
143C: 00          NOP
143D: 33          INC  SP
143E: 00          NOP
143F: 3B          DEC  SP
1440: 00          NOP
1441: 1F          RRA
1442: 00          NOP
1443: 0E 00       LD   C,$00
1445: FC 00 FE    CALL M,$FE00
1448: 01 87 03    LD   BC,$0387
144B: 43          LD   B,E
144C: 03          INC  BC
144D: 87          ADD  A,A
144E: 03          INC  BC
144F: FE 01       CP   $01
1451: FC 02 FF    CALL M,$FF02
1454: 03          INC  BC
1455: FF          RST  $38
1456: 03          INC  BC
1457: 73          LD   (HL),E
1458: 00          NOP
1459: 73          LD   (HL),E
145A: 00          NOP
145B: FB          EI
145C: 01 9F 03    LD   BC,$039F
145F: 0E 03       LD   C,$03
1461: 1E 03       LD   E,$03
1463: 3F          CCF
1464: 03          INC  BC
1465: 33          INC  SP
1466: 03          INC  BC
1467: 33          INC  SP
1468: 03          INC  BC
1469: 33          INC  SP
146A: 03          INC  BC
146B: F3          DI
146C: 03          INC  BC
146D: E3          EX   (SP),HL
146E: 01 03 00    LD   BC,$0003
1471: 03          INC  BC
1472: 00          NOP
1473: FF          RST  $38
1474: 03          INC  BC
1475: FF          RST  $38
1476: 03          INC  BC
1477: 03          INC  BC
1478: 00          NOP
1479: 03          INC  BC
147A: 00          NOP
147B: 00          NOP
147C: 00          NOP
147D: FF          RST  $38
147E: 01 FF 03    LD   BC,$03FF
1481: 00          NOP
1482: 03          INC  BC
1483: 00          NOP
1484: 03          INC  BC
1485: 00          NOP
1486: 03          INC  BC
1487: FF          RST  $38
1488: 03          INC  BC
1489: FF          RST  $38
148A: 01 1F 00    LD   BC,$001F
148D: 7F          LD   A,A
148E: 00          NOP
148F: F0          RET  P

1490: 01 C0 03    LD   BC,$03C0
1493: F0          RET  P

1494: 01 7F 00    LD   BC,$007F
1497: 1F          RRA
1498: 00          NOP
1499: FF          RST  $38
149A: 01 FF 03    LD   BC,$03FF
149D: C0          RET  NZ

149E: 01 E0 00    LD   BC,$00E0
14A1: C0          RET  NZ

14A2: 01 FF 03    LD   BC,$03FF
14A5: FF          RST  $38
14A6: 01 87 03    LD   BC,$0387
14A9: CF          RST  $08
14AA: 03          INC  BC
14AB: FC 00 78    CALL M,$7800
14AE: 00          NOP
14AF: FC 00 CF    CALL M,$CF00
14B2: 03          INC  BC
14B3: 87          ADD  A,A
14B4: 03          INC  BC
14B5: 0F          RRCA
14B6: 00          NOP
14B7: 1F          RRA
14B8: 00          NOP
14B9: F8          RET  M

14BA: 03          INC  BC
14BB: F8          RET  M

14BC: 03          INC  BC
14BD: 1F          RRA
14BE: 00          NOP
14BF: 0F          RRCA
14C0: 00          NOP
14C1: 00          NOP
14C2: 00          NOP
14C3: 83          ADD  A,E
14C4: 03          INC  BC
14C5: C3 03 F3    JP   $F303
14C8: 03          INC  BC
14C9: 7B          LD   A,E
14CA: 03          INC  BC
14CB: 3F          CCF
14CC: 03          INC  BC
14CD: 0F          RRCA
14CE: 03          INC  BC
14CF: 07          RLCA
14D0: 03          INC  BC
14D1: FE 01       CP   $01
14D3: FF          RST  $38
14D4: 03          INC  BC
14D5: 03          INC  BC
14D6: 03          INC  BC
14D7: 03          INC  BC
14D8: 03          INC  BC
14D9: 03          INC  BC
14DA: 03          INC  BC
14DB: FF          RST  $38
14DC: 03          INC  BC
14DD: FE 01       CP   $01
14DF: 00          NOP
14E0: 00          NOP
14E1: 02          LD   (BC),A
14E2: 03          INC  BC
14E3: FF          RST  $38
14E4: 03          INC  BC
14E5: FF          RST  $38
14E6: 03          INC  BC
14E7: 00          NOP
14E8: 03          INC  BC
14E9: 00          NOP
14EA: 00          NOP
14EB: 00          NOP
14EC: 00          NOP
14ED: 0C          INC  C
14EE: 03          INC  BC
14EF: 8E          ADC  A,(HL)
14F0: 03          INC  BC
14F1: C7          RST  $00
14F2: 03          INC  BC
14F3: E3          EX   (SP),HL
14F4: 03          INC  BC
14F5: 77          LD   (HL),A
14F6: 03          INC  BC
14F7: 3E 03       LD   A,$03
14F9: 1C          INC  E
14FA: 03          INC  BC
14FB: CC 00 CE    CALL Z,$CE00
14FE: 01 87 03    LD   BC,$0387
1501: 33          INC  SP
1502: 03          INC  BC
1503: 33          INC  SP
1504: 03          INC  BC
1505: FF          RST  $38
1506: 03          INC  BC
1507: EE 01       XOR  $01
1509: 3E 00       LD   A,$00
150B: 3E 00       LD   A,$00
150D: 30 00       JR   NC,$150F
150F: 30 00       JR   NC,$1511
1511: FF          RST  $38
1512: 03          INC  BC
1513: FF          RST  $38
1514: 03          INC  BC
1515: 30 00       JR   NC,$1517
1517: BF          CP   A
1518: 01 BF 03    LD   BC,$03BF
151B: 33          INC  SP
151C: 03          INC  BC
151D: 33          INC  SP
151E: 03          INC  BC
151F: 33          INC  SP
1520: 03          INC  BC
1521: F3          DI
1522: 03          INC  BC
1523: E3          EX   (SP),HL
1524: 01 FE 01    LD   BC,$01FE
1527: FF          RST  $38
1528: 03          INC  BC
1529: 30 03       JR   NC,$152E
152B: 30 03       JR   NC,$1530
152D: 30 03       JR   NC,$1532
152F: F0          RET  P

1530: 03          INC  BC
1531: E0          RET  PO

1532: 01 03 00    LD   BC,$0003
1535: 03          INC  BC
1536: 02          LD   (BC),A
1537: 83          ADD  A,E
1538: 03          INC  BC
1539: E3          EX   (SP),HL
153A: 03          INC  BC
153B: FB          EI
153C: 00          NOP
153D: 3F          CCF
153E: 00          NOP
153F: 0F          RRCA
1540: 00          NOP
1541: CE 01       ADC  A,$01
1543: FF          RST  $38
1544: 03          INC  BC
1545: 33          INC  SP
1546: 03          INC  BC
1547: 33          INC  SP
1548: 03          INC  BC
1549: 33          INC  SP
154A: 03          INC  BC
154B: FF          RST  $38
154C: 03          INC  BC
154D: CE 01       ADC  A,$01
154F: 1E 00       LD   E,$00
1551: 3F          CCF
1552: 00          NOP
1553: 33          INC  SP
1554: 00          NOP
1555: 33          INC  SP
1556: 00          NOP
1557: 33          INC  SP
1558: 00          NOP
1559: FF          RST  $38
155A: 03          INC  BC
155B: FE 01       CP   $01
155D: 00          NOP
155E: 00          NOP
155F: 00          NOP
1560: 00          NOP
1561: 30 03       JR   NC,$1566
1563: 30 03       JR   NC,$1568
1565: 00          NOP
1566: 00          NOP
1567: 00          NOP
1568: 00          NOP
1569: 00          NOP
156A: 00          NOP
156B: 00          NOP
156C: 00          NOP
156D: 00          NOP
156E: 00          NOP
156F: 00          NOP
1570: 03          INC  BC
1571: 00          NOP
1572: 03          INC  BC
1573: 00          NOP
1574: 00          NOP
1575: 00          NOP
1576: 00          NOP
1577: 00          NOP
1578: 00          NOP
1579: 00          NOP
157A: 00          NOP
157B: 00          NOP
157C: 00          NOP
157D: 0B          DEC  BC
157E: 00          NOP
157F: 07          RLCA
1580: 00          NOP
1581: 00          NOP
1582: 00          NOP
1583: 00          NOP
1584: 00          NOP
1585: 00          NOP
1586: 00          NOP
1587: 00          NOP
1588: 00          NOP
1589: 00          NOP
158A: 00          NOP
158B: 3F          CCF
158C: 03          INC  BC
158D: 3F          CCF
158E: 03          INC  BC
158F: 00          NOP
1590: 00          NOP
1591: 00          NOP
1592: 00          NOP
1593: 00          NOP
1594: 00          NOP
1595: 0E 00       LD   C,$00
1597: 0F          RRCA
1598: 00          NOP
1599: 63          LD   H,E
159A: 03          INC  BC
159B: 73          LD   (HL),E
159C: 03          INC  BC
159D: 1F          RRA
159E: 00          NOP
159F: 0E 00       LD   C,$00
15A1: 00          NOP
15A2: 00          NOP
15A3: 00          NOP
15A4: 00          NOP
15A5: 01 00 02    LD   BC,$0200
15A8: 00          NOP
15A9: 00          NOP
15AA: 00          NOP
15AB: 01 00 02    LD   BC,$0200
15AE: 00          NOP
15AF: 00          NOP
15B0: 00          NOP
15B1: 00          NOP
15B2: 00          NOP
15B3: 02          LD   (BC),A
15B4: 00          NOP
15B5: 01 00 00    LD   BC,$0000
15B8: 00          NOP
15B9: 02          LD   (BC),A
15BA: 00          NOP
15BB: 01 00 00    LD   BC,$0000
15BE: 00          NOP
15BF: C0          RET  NZ

15C0: 01 EE 03    LD   BC,$03EE
15C3: 3B          DEC  SP
15C4: 03          INC  BC
15C5: 3F          CCF
15C6: 03          INC  BC
15C7: E6 03       AND  $03
15C9: E0          RET  PO

15CA: 01 70 03    LD   BC,$0370
15CD: 00          NOP
15CE: 00          NOP
15CF: 00          NOP
15D0: 00          NOP
15D1: 30 00       JR   NC,$15D3
15D3: 30 00       JR   NC,$15D5
15D5: 30 00       JR   NC,$15D7
15D7: 00          NOP
15D8: 00          NOP
15D9: 00          NOP
15DA: 00          NOP
15DB: 38 00       JR   C,$15DD
15DD: 38 00       JR   C,$15DF
15DF: FF          RST  $38
15E0: 01 FE 00    LD   BC,$00FE
15E3: 7C          LD   A,H
15E4: 00          NOP
15E5: 38 00       JR   C,$15E7
15E7: 10 00       DJNZ $15E9
15E9: 10 00       DJNZ $15EB
15EB: 38 00       JR   C,$15ED
15ED: 7C          LD   A,H
15EE: 00          NOP
15EF: FE 00       CP   $00
15F1: FF          RST  $38
15F2: 01 38 00    LD   BC,$0038
15F5: 38 00       JR   C,$15F7
15F7: 7C          LD   A,H
15F8: 00          NOP
15F9: 82          ADD  A,D
15FA: 00          NOP
15FB: 39          ADD  HL,SP
15FC: 01 45 01    LD   BC,$0145
15FF: 29          ADD  HL,HL
1600: 01 82 00    LD   BC,$0082
1603: 7C          LD   A,H
1604: 00          NOP
1605: 00          NOP
1606: 18 00       JR   $1608
1608: 18 00       JR   $160A
160A: 18 00       JR   $160C
160C: 18 00       JR   $160E
160E: 18 00       JR   $1610
1610: 18 00       JR   $1612
1612: 18 00       JR   $1614
1614: 00          NOP
1615: 00          NOP
1616: 00          NOP
1617: 00          NOP
1618: 0B          DEC  BC
1619: 00          NOP
161A: 07          RLCA
161B: 00          NOP
161C: 00          NOP
161D: 00          NOP
161E: 00          NOP
161F: 00          NOP
1620: 00          NOP
1621: 00          NOP
1622: 00          NOP
1623: 00          NOP
1624: 00          NOP
1625: 30 0B       JR   NC,$1632
1627: 30 07       JR   NC,$1630
1629: 00          NOP
162A: 00          NOP
162B: 00          NOP
162C: 00          NOP
162D: 00          NOP
162E: 00          NOP
162F: 00          NOP
1630: 00          NOP
1631: 00          NOP
1632: 00          NOP
1633: FC 00 FE    CALL M,$FE00
1636: 01 03 03    LD   BC,$0303
1639: 00          NOP
163A: 00          NOP
163B: 00          NOP
163C: 00          NOP
163D: 00          NOP
163E: 00          NOP
163F: 00          NOP
1640: 00          NOP
1641: 03          INC  BC
1642: 03          INC  BC
1643: FE 01       CP   $01
1645: FC 00 00    CALL M,$0000
1648: 00          NOP
1649: 00          NOP
164A: 00          NOP
164B: 00          NOP
164C: 03          INC  BC
164D: C0          RET  NZ

164E: 03          INC  BC
164F: F0          RET  P

1650: 00          NOP
1651: 3C          INC  A
1652: 00          NOP
1653: 0F          RRCA
1654: 00          NOP
1655: 03          INC  BC
1656: 00          NOP
1657: 00          NOP
1658: 00          NOP
1659: 78          LD   A,B
165A: 0C          INC  C
165B: CC 0C FE    CALL Z,$FE0C
165E: 1F          RRA
165F: CC 0C FE    CALL Z,$FE0C
1662: 1F          RRA
1663: CC 0C 8C    CALL Z,$8C0C
1666: 07          RLCA
1667: F5          PUSH AF
1668: C5          PUSH BC
1669: D5          PUSH DE
166A: E5          PUSH HL
166B: 06 05       LD   B,$05
166D: 0E 04       LD   C,$04
166F: 7E          LD   A,(HL)
1670: 07          RLCA
1671: F5          PUSH AF
1672: 3A F1 7B    LD   A,($7BF1)
1675: FE 00       CP   $00
1677: 3A F3 7B    LD   A,($7BF3)
167A: 28 03       JR   Z,$167F
167C: DD 7E 00    LD   A,(IX+$00)
167F: 32 F4 7B    LD   ($7BF4),A
1682: F1          POP  AF
1683: F5          PUSH AF
1684: 30 0F       JR   NC,$1695
1686: C5          PUSH BC
1687: 3A F4 7B    LD   A,($7BF4)
168A: E6 F0       AND  $F0
168C: 47          LD   B,A
168D: 3A F2 7B    LD   A,($7BF2)
1690: 80          ADD  A,B
1691: 32 F4 7B    LD   ($7BF4),A
1694: C1          POP  BC
1695: F1          POP  AF
1696: 07          RLCA
1697: F5          PUSH AF
1698: 30 15       JR   NC,$16AF
169A: C5          PUSH BC
169B: 3A F4 7B    LD   A,($7BF4)
169E: E6 0F       AND  $0F
16A0: 47          LD   B,A
16A1: 3A F2 7B    LD   A,($7BF2)
16A4: 07          RLCA
16A5: 07          RLCA
16A6: 07          RLCA
16A7: 07          RLCA
16A8: E6 F0       AND  $F0
16AA: 80          ADD  A,B
16AB: 32 F4 7B    LD   ($7BF4),A
16AE: C1          POP  BC
16AF: 3A F4 7B    LD   A,($7BF4)
16B2: DD 77 00    LD   (IX+$00),A
16B5: DD 23       INC  IX
16B7: F1          POP  AF
16B8: 0D          DEC  C
16B9: 20 B5       JR   NZ,$1670
16BB: 23          INC  HL
16BC: 11 84 00    LD   DE,$0084
16BF: DD 19       ADD  IX,DE
16C1: 10 AA       DJNZ $166D
16C3: 11 10 01    LD   DE,$0110
16C6: DD 19       ADD  IX,DE
16C8: E1          POP  HL
16C9: D1          POP  DE
16CA: C1          POP  BC
16CB: F1          POP  AF
16CC: C9          RET

16CD: 1C          INC  E
16CE: 0A          LD   A,(BC)
16CF: 09          ADD  HL,BC
16D0: 0A          LD   A,(BC)
16D1: 1C          INC  E
16D2: 1F          RRA
16D3: 15          DEC  D
16D4: 15          DEC  D
16D5: 15          DEC  D
16D6: 0A          LD   A,(BC)
16D7: 0E 11       LD   C,$11
16D9: 11 11 11    LD   DE,$1111
16DC: 1F          RRA
16DD: 11 11 11    LD   DE,$1111
16E0: 0E 1F       LD   C,$1F
16E2: 15          DEC  D
16E3: 15          DEC  D
16E4: 15          DEC  D
16E5: 11 1F 05    LD   DE,$051F
16E8: 05          DEC  B
16E9: 05          DEC  B
16EA: 01 0E 11    LD   BC,$110E
16ED: 15          DEC  D
16EE: 15          DEC  D
16EF: 1C          INC  E
16F0: 1F          RRA
16F1: 04          INC  B
16F2: 04          INC  B
16F3: 04          INC  B
16F4: 1F          RRA
16F5: 00          NOP
16F6: 11 1F 11    LD   DE,$111F
16F9: 00          NOP
16FA: 09          ADD  HL,BC
16FB: 11 1F 01    LD   DE,$011F
16FE: 01 1F 04    LD   BC,$041F
1701: 0E 1B       LD   C,$1B
1703: 11 1F 10    LD   DE,$101F
1706: 10 10       DJNZ $1718
1708: 10 1F       DJNZ $1729
170A: 01 1E 01    LD   BC,$011E
170D: 1F          RRA
170E: 1F          RRA
170F: 02          LD   (BC),A
1710: 04          INC  B
1711: 08          EX   AF,AF'
1712: 1F          RRA
1713: 0E 11       LD   C,$11
1715: 11 11 0E    LD   DE,$0E11
1718: 1F          RRA
1719: 05          DEC  B
171A: 05          DEC  B
171B: 05          DEC  B
171C: 02          LD   (BC),A
171D: 0E 11       LD   C,$11
171F: 15          DEC  D
1720: 09          ADD  HL,BC
1721: 16 1F       LD   D,$1F
1723: 05          DEC  B
1724: 0D          DEC  C
1725: 15          DEC  D
1726: 12          LD   (DE),A
1727: 12          LD   (DE),A
1728: 15          DEC  D
1729: 15          DEC  D
172A: 15          DEC  D
172B: 09          ADD  HL,BC
172C: 01 01 1F    LD   BC,$1F01
172F: 01 01 0F    LD   BC,$0F01
1732: 10 10       DJNZ $1744
1734: 10 0F       DJNZ $1745
1736: 07          RLCA
1737: 08          EX   AF,AF'
1738: 10 08       DJNZ $1742
173A: 07          RLCA
173B: 0F          RRCA
173C: 10 0C       DJNZ $174A
173E: 10 0F       DJNZ $174F
1740: 11 0A 04    LD   DE,$040A
1743: 0A          LD   A,(BC)
1744: 11 01 02    LD   DE,$0201
1747: 1C          INC  E
1748: 02          LD   (BC),A
1749: 01 11 19    LD   BC,$1911
174C: 15          DEC  D
174D: 13          INC  DE
174E: 11 00 00    LD   DE,$0000
1751: 00          NOP
1752: 00          NOP
1753: 00          NOP
1754: 0E 19       LD   C,$19
1756: 15          DEC  D
1757: 13          INC  DE
1758: 0E 00       LD   C,$00
175A: 12          LD   (DE),A
175B: 1F          RRA
175C: 10 00       DJNZ $175E
175E: 12          LD   (DE),A
175F: 19          ADD  HL,DE
1760: 15          DEC  D
1761: 15          DEC  D
1762: 12          LD   (DE),A
1763: 09          ADD  HL,BC
1764: 11 15 15    LD   DE,$1515
1767: 0B          DEC  BC
1768: 07          RLCA
1769: 04          INC  B
176A: 1F          RRA
176B: 04          INC  B
176C: 04          INC  B
176D: 17          RLA
176E: 15          DEC  D
176F: 15          DEC  D
1770: 15          DEC  D
1771: 09          ADD  HL,BC
1772: 0E 19       LD   C,$19
1774: 14          INC  D
1775: 14          INC  D
1776: 08          EX   AF,AF'
1777: 01 19 05    LD   BC,$0519
177A: 03          INC  BC
177B: 01 0A 15    LD   BC,$150A
177E: 15          DEC  D
177F: 15          DEC  D
1780: 0A          LD   A,(BC)
1781: 02          LD   (BC),A
1782: 05          DEC  B
1783: 05          DEC  B
1784: 13          INC  DE
1785: 0E 02       LD   C,$02
1787: 01 2D 05    LD   BC,$052D
178A: 02          LD   (BC),A
178B: 00          NOP
178C: 10 00       DJNZ $178E
178E: 00          NOP
178F: 00          NOP
1790: 00          NOP
1791: 04          INC  B
1792: 04          INC  B
1793: 04          INC  B
1794: 00          NOP
1795: 04          INC  B
1796: 0E 1F       LD   C,$1F
1798: 04          INC  B
1799: 04          INC  B
179A: 04          INC  B
179B: 04          INC  B
179C: 1F          RRA
179D: 0E 04       LD   C,$04
179F: 00          NOP
17A0: 20 10       JR   NZ,$17B2
17A2: 00          NOP
17A3: 00          NOP
17A4: 00          NOP
17A5: 00          NOP
17A6: 03          INC  BC
17A7: 00          NOP
17A8: 00          NOP
17A9: 00          NOP
17AA: 00          NOP
17AB: 17          RLA
17AC: 00          NOP
17AD: 00          NOP
17AE: 00          NOP
17AF: 14          INC  D
17B0: 00          NOP
17B1: 00          NOP
17B2: 00          NOP
17B3: 3F          CCF
17B4: 3F          CCF
17B5: 3F          CCF
17B6: 3F          CCF
17B7: 3F          CCF
17B8: F5          PUSH AF
17B9: DD E5       PUSH IX
17BB: FD E5       PUSH IY
17BD: 3E 0B       LD   A,$0B
17BF: 32 F2 7B    LD   ($7BF2),A
17C2: FD 21 19 18 LD   IY,$1819
17C6: DB 00       IN   A,($00)
17C8: E6 01       AND  $01
17CA: FE 00       CP   $00
17CC: 28 04       JR   Z,$17D2
17CE: FD 21 2C 18 LD   IY,$182C
17D2: DD 21 E8 9E LD   IX,$9EE8
17D6: CD 93 12    CALL $1293
17D9: D3 00       OUT  ($00),A
17DB: 3E 01       LD   A,$01
17DD: 32 80 7C    LD   ($7C80),A
17E0: FD 21 10 18 LD   IY,$1810
17E4: DD 21 D9 A6 LD   IX,$A6D9
17E8: CD 98 12    CALL $1298
17EB: 3A 51 7C    LD   A,($7C51)
17EE: 3C          INC  A
17EF: FE 10       CP   $10
17F1: 38 02       JR   C,$17F5
17F3: 3E 01       LD   A,$01
17F5: 32 51 7C    LD   ($7C51),A
17F8: 32 F2 7B    LD   ($7BF2),A
17FB: 3A 65 7D    LD   A,($7D65)
17FE: DD 21 59 D1 LD   IX,$D159
1802: C5          PUSH BC
1803: CD B4 10    CALL $10B4
1806: CD C1 10    CALL $10C1
1809: C1          POP  BC
180A: FD E1       POP  IY
180C: DD E1       POP  IX
180E: F1          POP  AF
180F: C9          RET

1810: 08          EX   AF,AF'
1811: FF          RST  $38
1812: 03          INC  BC
1813: 03          INC  BC
1814: 12          LD   (DE),A
1815: 05          DEC  B
1816: 04          INC  B
1817: 09          ADD  HL,BC
1818: 14          INC  D
1819: 12          LD   (DE),A
181A: 8C          ADC  A,H
181B: 82          ADD  A,D
181C: 0A          LD   A,(BC)
181D: 55          LD   D,L
181E: 14          INC  D
181F: 0F          RRCA
1820: 28 5F       JR   Z,$1881
1822: 82          ADD  A,D
1823: 4B          LD   C,E
1824: 14          INC  D
1825: 55          LD   D,L
1826: 82          ADD  A,D
1827: 0A          LD   A,(BC)
1828: 46          LD   B,(HL)
1829: 28 41       JR   Z,$186C
182B: 82          ADD  A,D
182C: 12          LD   (DE),A
182D: 91          SUB  C
182E: 82          ADD  A,D
182F: 0A          LD   A,(BC)
1830: 55          LD   D,L
1831: 14          INC  D
1832: 0F          RRCA
1833: 28 5F       JR   Z,$1894
1835: 5A          LD   E,D
1836: 82          ADD  A,D
1837: 4B          LD   C,E
1838: 14          INC  D
1839: 55          LD   D,L
183A: 82          ADD  A,D
183B: 0A          LD   A,(BC)
183C: 46          LD   B,(HL)
183D: 28 41       JR   Z,$1880
183F: F5          PUSH AF
1840: E5          PUSH HL
1841: DD E5       PUSH IX
1843: 21 68 7D    LD   HL,$7D68
1846: 3A 8C 7C    LD   A,($7C8C)
1849: FE 01       CP   $01
184B: 28 24       JR   Z,$1871
184D: 3A 67 7D    LD   A,($7D67)
1850: FE 01       CP   $01
1852: 28 0E       JR   Z,$1862
1854: 3E 03       LD   A,$03
1856: 32 F2 7B    LD   ($7BF2),A
1859: 3A 64 7D    LD   A,($7D64)
185C: 77          LD   (HL),A
185D: CD 76 18    CALL $1876
1860: 18 0F       JR   $1871
1862: 3E 0F       LD   A,$0F
1864: 32 F2 7B    LD   ($7BF2),A
1867: 36 01       LD   (HL),$01
1869: CD 76 18    CALL $1876
186C: 36 02       LD   (HL),$02
186E: CD 76 18    CALL $1876
1871: F1          POP  AF
1872: E1          POP  HL
1873: DD E1       POP  IX
1875: C9          RET

1876: C5          PUSH BC
1877: D5          PUSH DE
1878: E5          PUSH HL
1879: 3E 01       LD   A,$01
187B: 32 80 7C    LD   ($7C80),A
187E: DD 21 C8 85 LD   IX,$85C8
1882: 11 8A 7D    LD   DE,$7D8A
1885: BE          CP   (HL)
1886: 28 07       JR   Z,$188F
1888: DD 21 BE 85 LD   IX,$85BE
188C: 11 8D 7D    LD   DE,$7D8D
188F: 2E 02       LD   L,$02
1891: 1A          LD   A,(DE)
1892: CD B4 10    CALL $10B4
1895: CD C1 10    CALL $10C1
1898: 1B          DEC  DE
1899: 2D          DEC  L
189A: 20 F5       JR   NZ,$1891
189C: 1A          LD   A,(DE)
189D: CD B4 10    CALL $10B4
18A0: 97          SUB  A
18A1: 32 80 7C    LD   ($7C80),A
18A4: CD C1 10    CALL $10C1
18A7: E1          POP  HL
18A8: D1          POP  DE
18A9: C1          POP  BC
18AA: C9          RET

18AB: C5          PUSH BC
18AC: D5          PUSH DE
18AD: E5          PUSH HL
18AE: 3A 6C 7D    LD   A,($7D6C)
18B1: 67          LD   H,A
18B2: 3E 0E       LD   A,$0E
18B4: 32 F2 7B    LD   ($7BF2),A
18B7: DD 21 BC 85 LD   IX,$85BC
18BB: 11 8A 7D    LD   DE,$7D8A
18BE: 3E 01       LD   A,$01
18C0: 32 80 7C    LD   ($7C80),A
18C3: 2E 02       LD   L,$02
18C5: 1A          LD   A,(DE)
18C6: CD B4 10    CALL $10B4
18C9: CD F5 10    CALL $10F5
18CC: 1B          DEC  DE
18CD: 2D          DEC  L
18CE: 20 F5       JR   NZ,$18C5
18D0: 1A          LD   A,(DE)
18D1: CD B4 10    CALL $10B4
18D4: 97          SUB  A
18D5: 32 80 7C    LD   ($7C80),A
18D8: CD F5 10    CALL $10F5
18DB: 7C          LD   A,H
18DC: FE 02       CP   $02
18DE: 20 0B       JR   NZ,$18EB
18E0: 26 00       LD   H,$00
18E2: DD 21 3C E3 LD   IX,$E33C
18E6: 11 8D 7D    LD   DE,$7D8D
18E9: 18 D3       JR   $18BE
18EB: E1          POP  HL
18EC: D1          POP  DE
18ED: C1          POP  BC
18EE: C9          RET

18EF: F5          PUSH AF
18F0: C5          PUSH BC
18F1: D5          PUSH DE
18F2: E5          PUSH HL
18F3: 57          LD   D,A
18F4: 3A 8C 7C    LD   A,($7C8C)
18F7: FE 01       CP   $01
18F9: CA 35 19    JP   Z,$1935
18FC: 7A          LD   A,D
18FD: 21 58 19    LD   HL,$1958
1900: 07          RLCA
1901: 82          ADD  A,D
1902: 85          ADD  A,L
1903: 6F          LD   L,A
1904: 3E 00       LD   A,$00
1906: 8C          ADC  A,H
1907: 67          LD   H,A
1908: 11 88 7D    LD   DE,$7D88
190B: 3A 64 7D    LD   A,($7D64)
190E: FE 01       CP   $01
1910: 28 03       JR   Z,$1915
1912: 11 8B 7D    LD   DE,$7D8B
1915: 1A          LD   A,(DE)
1916: 86          ADD  A,(HL)
1917: 27          DAA
1918: 12          LD   (DE),A
1919: 23          INC  HL
191A: 13          INC  DE
191B: 1A          LD   A,(DE)
191C: 8E          ADC  A,(HL)
191D: 27          DAA
191E: 12          LD   (DE),A
191F: 23          INC  HL
1920: 13          INC  DE
1921: 1A          LD   A,(DE)
1922: 8E          ADC  A,(HL)
1923: 27          DAA
1924: 12          LD   (DE),A
1925: 21 84 7D    LD   HL,$7D84
1928: 3A 64 7D    LD   A,($7D64)
192B: FE 01       CP   $01
192D: 20 03       JR   NZ,$1932
192F: 21 82 7D    LD   HL,$7D82
1932: CD 3D 19    CALL $193D
1935: CD 3F 18    CALL $183F
1938: E1          POP  HL
1939: D1          POP  DE
193A: C1          POP  BC
193B: F1          POP  AF
193C: C9          RET

193D: 3A 4D 7C    LD   A,($7C4D)
1940: 47          LD   B,A
1941: 1A          LD   A,(DE)
1942: B8          CP   B
1943: 38 12       JR   C,$1957
1945: 7E          LD   A,(HL)
1946: FE 00       CP   $00
1948: 28 0D       JR   Z,$1957
194A: 23          INC  HL
194B: 34          INC  (HL)
194C: CD 8E 19    CALL $198E
194F: 3E 13       LD   A,$13
1951: CD 53 0B    CALL $0B53
1954: 97          SUB  A
1955: 2B          DEC  HL
1956: 77          LD   (HL),A
1957: C9          RET

1958: 00          NOP
1959: 50          LD   D,B
195A: 00          NOP
195B: 55          LD   D,L
195C: 00          NOP
195D: 00          NOP
195E: 66          LD   H,(HL)
195F: 00          NOP
1960: 00          NOP
1961: 77          LD   (HL),A
1962: 00          NOP
1963: 00          NOP
1964: 88          ADC  A,B
1965: 00          NOP
1966: 00          NOP
1967: 99          SBC  A,C
1968: 00          NOP
1969: 00          NOP
196A: 00          NOP
196B: 01 00 10    LD   BC,$1000
196E: 01 00 20    LD   BC,$2000
1971: 01 00 30    LD   BC,$3000
1974: 01 00 40    LD   BC,$4000
1977: 01 00 50    LD   BC,$5000
197A: 01 00 60    LD   BC,$6000
197D: 01 00 70    LD   BC,$7000
1980: 01 00 80    LD   BC,$8000
1983: 01 00 90    LD   BC,$9000
1986: 01 00 00    LD   BC,$0000
1989: 02          LD   (BC),A
198A: 00          NOP
198B: 10 02       DJNZ $198F
198D: 00          NOP
198E: F5          PUSH AF
198F: C5          PUSH BC
1990: D5          PUSH DE
1991: E5          PUSH HL
1992: DD E5       PUSH IX
1994: 3A 8C 7C    LD   A,($7C8C)
1997: FE 01       CP   $01
1999: 28 1B       JR   Z,$19B6
199B: 01 55 10    LD   BC,$1055
199E: 21 EE AA    LD   HL,$AAEE
19A1: CD 4F 11    CALL $114F
19A4: 01 83 7D    LD   BC,$7D83
19A7: 21 F8 AA    LD   HL,$AAF8
19AA: CD BD 19    CALL $19BD
19AD: 01 85 7D    LD   BC,$7D85
19B0: 21 EE AA    LD   HL,$AAEE
19B3: CD BD 19    CALL $19BD
19B6: DD E1       POP  IX
19B8: E1          POP  HL
19B9: D1          POP  DE
19BA: C1          POP  BC
19BB: F1          POP  AF
19BC: C9          RET

19BD: 0A          LD   A,(BC)
19BE: FE 00       CP   $00
19C0: C8          RET  Z

19C1: FE 06       CP   $06
19C3: 38 02       JR   C,$19C7
19C5: 3E 05       LD   A,$05
19C7: 47          LD   B,A
19C8: 11 DA 42    LD   DE,$42DA
19CB: CD 84 30    CALL $3084
19CE: 11 F8 07    LD   DE,$07F8
19D1: 19          ADD  HL,DE
19D2: 10 F4       DJNZ $19C8
19D4: C9          RET

19D5: F5          PUSH AF
19D6: E5          PUSH HL
19D7: FD E5       PUSH IY
19D9: 21 68 7D    LD   HL,$7D68
19DC: 3A 8C 7C    LD   A,($7C8C)
19DF: FE 01       CP   $01
19E1: 28 4A       JR   Z,$1A2D
19E3: FD 21 56 1A LD   IY,$1A56
19E7: 3A 67 7D    LD   A,($7D67)
19EA: FE 01       CP   $01
19EC: 28 22       JR   Z,$1A10
19EE: 3E 0E       LD   A,$0E
19F0: 32 F2 7B    LD   ($7BF2),A
19F3: DD 21 A8 D8 LD   IX,$D8A8
19F7: 3A 64 7D    LD   A,($7D64)
19FA: 77          LD   (HL),A
19FB: FE 01       CP   $01
19FD: 28 04       JR   Z,$1A03
19FF: DD 21 9E D8 LD   IX,$D89E
1A03: CD 93 12    CALL $1293
1A06: 3E 03       LD   A,$03
1A08: 32 F2 7B    LD   ($7BF2),A
1A0B: CD 32 1A    CALL $1A32
1A0E: 18 1D       JR   $1A2D
1A10: 3E 0F       LD   A,$0F
1A12: 32 F2 7B    LD   ($7BF2),A
1A15: DD 21 9E D8 LD   IX,$D89E
1A19: CD 93 12    CALL $1293
1A1C: 36 02       LD   (HL),$02
1A1E: CD 32 1A    CALL $1A32
1A21: DD 21 A8 D8 LD   IX,$D8A8
1A25: CD 93 12    CALL $1293
1A28: 36 01       LD   (HL),$01
1A2A: CD 32 1A    CALL $1A32
1A2D: FD E1       POP  IY
1A2F: E1          POP  HL
1A30: F1          POP  AF
1A31: C9          RET

1A32: C5          PUSH BC
1A33: DD E5       PUSH IX
1A35: 3E 01       LD   A,$01
1A37: 32 80 7C    LD   ($7C80),A
1A3A: DD 21 F8 EE LD   IX,$EEF8
1A3E: 01 92 7D    LD   BC,$7D92
1A41: BE          CP   (HL)
1A42: 28 07       JR   Z,$1A4B
1A44: DD 21 EE EE LD   IX,$EEEE
1A48: 01 95 7D    LD   BC,$7D95
1A4B: 0A          LD   A,(BC)
1A4C: CD B4 10    CALL $10B4
1A4F: CD F5 10    CALL $10F5
1A52: DD E1       POP  IX
1A54: C1          POP  BC
1A55: C9          RET

1A56: 05          DEC  B
1A57: 37          SCF
1A58: 14          INC  D
1A59: 69          LD   L,C
1A5A: 14          INC  D
1A5B: 37          SCF
1A5C: DD E5       PUSH IX
1A5E: FD E5       PUSH IY
1A60: 3E B5       LD   A,$B5
1A62: 32 79 7D    LD   ($7D79),A
1A65: FD 21 86 1A LD   IY,$1A86
1A69: DD 21 34 83 LD   IX,$8334
1A6D: CD 93 12    CALL $1293
1A70: 01 B5 05    LD   BC,$05B5
1A73: 21 81 99    LD   HL,$9981
1A76: 3E EE       LD   A,$EE
1A78: CD 4F 11    CALL $114F
1A7B: 21 21 F9    LD   HL,$F921
1A7E: 22 7A 7D    LD   ($7D7A),HL
1A81: FD E1       POP  IY
1A83: DD E1       POP  IX
1A85: C9          RET

1A86: 10 FF       DJNZ $1A87
1A88: 04          INC  B
1A89: 14          INC  D
1A8A: 41          LD   B,C
1A8B: 14          INC  D
1A8C: 55          LD   D,L
1A8D: 1E 78       LD   E,$78
1A8F: FF          RST  $38
1A90: 80          ADD  A,B
1A91: 82          ADD  A,D
1A92: 37          SCF
1A93: 14          INC  D
1A94: 69          LD   L,C
1A95: 14          INC  D
1A96: 37          SCF
1A97: 21 7C 7D    LD   HL,$7D7C
1A9A: 35          DEC  (HL)
1A9B: 20 34       JR   NZ,$1AD1
1A9D: 32 7C 7D    LD   ($7D7C),A
1AA0: 3A 8C 7C    LD   A,($7C8C)
1AA3: FE 01       CP   $01
1AA5: 28 2A       JR   Z,$1AD1
1AA7: 2A 7A 7D    LD   HL,($7D7A)
1AAA: 3E 11       LD   A,$11
1AAC: 77          LD   (HL),A
1AAD: 23          INC  HL
1AAE: 77          LD   (HL),A
1AAF: 23          INC  HL
1AB0: 77          LD   (HL),A
1AB1: 23          INC  HL
1AB2: 77          LD   (HL),A
1AB3: 23          INC  HL
1AB4: 77          LD   (HL),A
1AB5: 11 74 FF    LD   DE,$FF74
1AB8: 19          ADD  HL,DE
1AB9: 22 7A 7D    LD   ($7D7A),HL
1ABC: 21 79 7D    LD   HL,$7D79
1ABF: 35          DEC  (HL)
1AC0: 20 05       JR   NZ,$1AC7
1AC2: 3E 01       LD   A,$01
1AC4: 32 6D 7D    LD   ($7D6D),A
1AC7: 7E          LD   A,(HL)
1AC8: FE 32       CP   $32
1ACA: 30 05       JR   NC,$1AD1
1ACC: 3E 03       LD   A,$03
1ACE: CD 53 0B    CALL $0B53
1AD1: C9          RET

1AD2: F5          PUSH AF
1AD3: C5          PUSH BC
1AD4: D5          PUSH DE
1AD5: E5          PUSH HL
1AD6: DD E5       PUSH IX
1AD8: FD E5       PUSH IY
1ADA: 3E 0F       LD   A,$0F
1ADC: 32 52 7C    LD   ($7C52),A
1ADF: DD 21 A9 8C LD   IX,$8CA9
1AE3: 0E 14       LD   C,$14
1AE5: 11 A8 02    LD   DE,$02A8
1AE8: 21 39 1D    LD   HL,$1D39
1AEB: CD 56 1B    CALL $1B56
1AEE: DD 19       ADD  IX,DE
1AF0: 21 7B 1D    LD   HL,$1D7B
1AF3: CD 56 1B    CALL $1B56
1AF6: DD 19       ADD  IX,DE
1AF8: 21 FF 1B    LD   HL,$1BFF
1AFB: CD 56 1B    CALL $1B56
1AFE: 11 A0 0A    LD   DE,$0AA0
1B01: DD 19       ADD  IX,DE
1B03: 21 55 1E    LD   HL,$1E55
1B06: CD 56 1B    CALL $1B56
1B09: 11 A8 02    LD   DE,$02A8
1B0C: DD 19       ADD  IX,DE
1B0E: 21 87 1C    LD   HL,$1C87
1B11: CD 56 1B    CALL $1B56
1B14: DD 19       ADD  IX,DE
1B16: 21 C9 1C    LD   HL,$1CC9
1B19: CD 56 1B    CALL $1B56
1B1C: DD 19       ADD  IX,DE
1B1E: 21 BF 1D    LD   HL,$1DBF
1B21: CD 56 1B    CALL $1B56
1B24: 21 D1 EB    LD   HL,$EBD1
1B27: 11 44 1B    LD   DE,$1B44
1B2A: 06 09       LD   B,$09
1B2C: 1A          LD   A,(DE)
1B2D: 77          LD   (HL),A
1B2E: 23          INC  HL
1B2F: 13          INC  DE
1B30: 1A          LD   A,(DE)
1B31: 77          LD   (HL),A
1B32: 13          INC  DE
1B33: D5          PUSH DE
1B34: 11 87 00    LD   DE,$0087
1B37: 19          ADD  HL,DE
1B38: D1          POP  DE
1B39: 10 F1       DJNZ $1B2C
1B3B: FD E1       POP  IY
1B3D: DD E1       POP  IX
1B3F: E1          POP  HL
1B40: D1          POP  DE
1B41: C1          POP  BC
1B42: F1          POP  AF
1B43: C9          RET

1B44: 00          NOP
1B45: 01 11 01    LD   BC,$0111
1B48: 00          NOP
1B49: 01 00 00    LD   BC,$0000
1B4C: 11 01 00    LD   DE,$0001
1B4F: 01 11 00    LD   BC,$0011
1B52: 00          NOP
1B53: 01 11 01    LD   BC,$0111
1B56: F5          PUSH AF
1B57: C5          PUSH BC
1B58: D5          PUSH DE
1B59: E5          PUSH HL
1B5A: 11 55 7C    LD   DE,$7C55
1B5D: 1A          LD   A,(DE)
1B5E: C6 03       ADD  A,$03
1B60: E6 0F       AND  $0F
1B62: 12          LD   (DE),A
1B63: 47          LD   B,A
1B64: 13          INC  DE
1B65: 1A          LD   A,(DE)
1B66: 3C          INC  A
1B67: CB 67       BIT  4,A
1B69: 28 02       JR   Z,$1B6D
1B6B: 3E 01       LD   A,$01
1B6D: 12          LD   (DE),A
1B6E: B8          CP   B
1B6F: 28 F5       JR   Z,$1B66
1B71: D3 00       OUT  ($00),A
1B73: 3A 52 7C    LD   A,($7C52)
1B76: 47          LD   B,A
1B77: 97          SUB  A
1B78: 32 81 7C    LD   ($7C81),A
1B7B: 7E          LD   A,(HL)
1B7C: 57          LD   D,A
1B7D: E6 07       AND  $07
1B7F: CB 3A       SRL  D
1B81: CB 3A       SRL  D
1B83: CB 3A       SRL  D
1B85: 5F          LD   E,A
1B86: 3A 81 7C    LD   A,($7C81)
1B89: FE 00       CP   $00
1B8B: 20 1F       JR   NZ,$1BAC
1B8D: DD 7E 00    LD   A,(IX+$00)
1B90: 32 4F 7C    LD   ($7C4F),A
1B93: D5          PUSH DE
1B94: 7B          LD   A,E
1B95: FE 00       CP   $00
1B97: 28 07       JR   Z,$1BA0
1B99: CD F0 1B    CALL $1BF0
1B9C: AA          XOR  D
1B9D: 32 4F 7C    LD   ($7C4F),A
1BA0: D1          POP  DE
1BA1: 15          DEC  D
1BA2: 20 08       JR   NZ,$1BAC
1BA4: 3E 01       LD   A,$01
1BA6: 32 81 7C    LD   ($7C81),A
1BA9: 23          INC  HL
1BAA: 18 CF       JR   $1B7B
1BAC: D5          PUSH DE
1BAD: 7B          LD   A,E
1BAE: FE 00       CP   $00
1BB0: 28 0F       JR   Z,$1BC1
1BB2: CD F0 1B    CALL $1BF0
1BB5: CB 22       SLA  D
1BB7: CB 22       SLA  D
1BB9: CB 22       SLA  D
1BBB: CB 22       SLA  D
1BBD: AA          XOR  D
1BBE: 32 4F 7C    LD   ($7C4F),A
1BC1: D1          POP  DE
1BC2: 3A 4F 7C    LD   A,($7C4F)
1BC5: DD 77 00    LD   (IX+$00),A
1BC8: DD 23       INC  IX
1BCA: 97          SUB  A
1BCB: 32 81 7C    LD   ($7C81),A
1BCE: 10 02       DJNZ $1BD2
1BD0: 18 06       JR   $1BD8
1BD2: 15          DEC  D
1BD3: 20 B1       JR   NZ,$1B86
1BD5: 23          INC  HL
1BD6: 18 A3       JR   $1B7B
1BD8: 3A 52 7C    LD   A,($7C52)
1BDB: 47          LD   B,A
1BDC: D5          PUSH DE
1BDD: 16 00       LD   D,$00
1BDF: 5F          LD   E,A
1BE0: 3E 88       LD   A,$88
1BE2: 93          SUB  E
1BE3: 5F          LD   E,A
1BE4: DD 19       ADD  IX,DE
1BE6: D1          POP  DE
1BE7: 0D          DEC  C
1BE8: 23          INC  HL
1BE9: 20 90       JR   NZ,$1B7B
1BEB: E1          POP  HL
1BEC: D1          POP  DE
1BED: C1          POP  BC
1BEE: F1          POP  AF
1BEF: C9          RET

1BF0: E5          PUSH HL
1BF1: 21 53 7C    LD   HL,$7C53
1BF4: 3D          DEC  A
1BF5: 5F          LD   E,A
1BF6: 16 00       LD   D,$00
1BF8: 19          ADD  HL,DE
1BF9: 56          LD   D,(HL)
1BFA: E1          POP  HL
1BFB: 3A 4F 7C    LD   A,($7C4F)
1BFE: C9          RET

1BFF: F4 F4 14    CALL P,$14F4
1C02: D3 14       OUT  ($14),A
1C04: 14          INC  D
1C05: D3 14       OUT  ($14),A
1C07: 14          INC  D
1C08: 13          INC  DE
1C09: 54          LD   D,H
1C0A: 13          INC  DE
1C0B: 54          LD   D,H
1C0C: 13          INC  DE
1C0D: 14          INC  D
1C0E: 14          INC  D
1C0F: 13          INC  DE
1C10: 54          LD   D,H
1C11: 13          INC  DE
1C12: 54          LD   D,H
1C13: 13          INC  DE
1C14: 14          INC  D
1C15: 14          INC  D
1C16: 13          INC  DE
1C17: 14          INC  D
1C18: 30 14       JR   NC,$1C2E
1C1A: 13          INC  DE
1C1B: 14          INC  D
1C1C: 30 14       JR   NC,$1C32
1C1E: 13          INC  DE
1C1F: 14          INC  D
1C20: 14          INC  D
1C21: 13          INC  DE
1C22: 14          INC  D
1C23: 30 14       JR   NC,$1C39
1C25: 13          INC  DE
1C26: 14          INC  D
1C27: 30 14       JR   NC,$1C3D
1C29: 13          INC  DE
1C2A: 14          INC  D
1C2B: 14          INC  D
1C2C: 13          INC  DE
1C2D: 14          INC  D
1C2E: 30 14       JR   NC,$1C44
1C30: 13          INC  DE
1C31: 14          INC  D
1C32: 30 14       JR   NC,$1C48
1C34: 13          INC  DE
1C35: 14          INC  D
1C36: 14          INC  D
1C37: 13          INC  DE
1C38: 14          INC  D
1C39: 30 14       JR   NC,$1C4F
1C3B: 13          INC  DE
1C3C: 14          INC  D
1C3D: 30 14       JR   NC,$1C53
1C3F: 13          INC  DE
1C40: 14          INC  D
1C41: 14          INC  D
1C42: 13          INC  DE
1C43: 14          INC  D
1C44: 30 14       JR   NC,$1C5A
1C46: 13          INC  DE
1C47: 14          INC  D
1C48: 30 14       JR   NC,$1C5E
1C4A: 13          INC  DE
1C4B: 14          INC  D
1C4C: 14          INC  D
1C4D: 13          INC  DE
1C4E: 14          INC  D
1C4F: 30 34       JR   NC,$1C85
1C51: 30 14       JR   NC,$1C67
1C53: 13          INC  DE
1C54: 14          INC  D
1C55: 14          INC  D
1C56: 13          INC  DE
1C57: 14          INC  D
1C58: 30 34       JR   NC,$1C8E
1C5A: 30 14       JR   NC,$1C70
1C5C: 13          INC  DE
1C5D: 14          INC  D
1C5E: 14          INC  D
1C5F: 13          INC  DE
1C60: 14          INC  D
1C61: 90          SUB  B
1C62: 14          INC  D
1C63: 13          INC  DE
1C64: 14          INC  D
1C65: 14          INC  D
1C66: 13          INC  DE
1C67: 14          INC  D
1C68: 90          SUB  B
1C69: 14          INC  D
1C6A: 13          INC  DE
1C6B: 14          INC  D
1C6C: 14          INC  D
1C6D: 13          INC  DE
1C6E: 14          INC  D
1C6F: 90          SUB  B
1C70: 14          INC  D
1C71: 13          INC  DE
1C72: 14          INC  D
1C73: 14          INC  D
1C74: 13          INC  DE
1C75: 14          INC  D
1C76: 90          SUB  B
1C77: 14          INC  D
1C78: 13          INC  DE
1C79: 14          INC  D
1C7A: 14          INC  D
1C7B: 13          INC  DE
1C7C: 14          INC  D
1C7D: 90          SUB  B
1C7E: 14          INC  D
1C7F: 13          INC  DE
1C80: 14          INC  D
1C81: 34          INC  (HL)
1C82: 90          SUB  B
1C83: 34          INC  (HL)
1C84: 34          INC  (HL)
1C85: 90          SUB  B
1C86: 34          INC  (HL)
1C87: F4 F4 14    CALL P,$14F4
1C8A: D3 14       OUT  ($14),A
1C8C: 14          INC  D
1C8D: D3 14       OUT  ($14),A
1C8F: 14          INC  D
1C90: 13          INC  DE
1C91: D4 14 13    CALL NC,$1314
1C94: D4 14 13    CALL NC,$1314
1C97: 14          INC  D
1C98: C0          RET  NZ

1C99: 14          INC  D
1C9A: 13          INC  DE
1C9B: 14          INC  D
1C9C: C0          RET  NZ

1C9D: 14          INC  D
1C9E: 13          INC  DE
1C9F: 14          INC  D
1CA0: C0          RET  NZ

1CA1: 14          INC  D
1CA2: 13          INC  DE
1CA3: 14          INC  D
1CA4: C0          RET  NZ

1CA5: 14          INC  D
1CA6: 13          INC  DE
1CA7: 14          INC  D
1CA8: C0          RET  NZ

1CA9: 14          INC  D
1CAA: 13          INC  DE
1CAB: 14          INC  D
1CAC: C0          RET  NZ

1CAD: 14          INC  D
1CAE: 13          INC  DE
1CAF: 14          INC  D
1CB0: C0          RET  NZ

1CB1: 14          INC  D
1CB2: 13          INC  DE
1CB3: 14          INC  D
1CB4: C0          RET  NZ

1CB5: 14          INC  D
1CB6: 13          INC  DE
1CB7: 14          INC  D
1CB8: C0          RET  NZ

1CB9: 14          INC  D
1CBA: 13          INC  DE
1CBB: 14          INC  D
1CBC: C0          RET  NZ

1CBD: 14          INC  D
1CBE: 13          INC  DE
1CBF: 14          INC  D
1CC0: C0          RET  NZ

1CC1: 14          INC  D
1CC2: 13          INC  DE
1CC3: 14          INC  D
1CC4: C0          RET  NZ

1CC5: 34          INC  (HL)
1CC6: C0          RET  NZ

1CC7: 34          INC  (HL)
1CC8: C0          RET  NZ

1CC9: 28 A4       JR   Z,$1C6F
1CCB: 28 18       JR   Z,$1CE5
1CCD: C4 18 10    CALL NZ,$1018
1CD0: 1C          INC  E
1CD1: A3          AND  E
1CD2: 1C          INC  E
1CD3: 10 08       DJNZ $1CDD
1CD5: 1C          INC  E
1CD6: B3          OR   E
1CD7: 1C          INC  E
1CD8: 08          EX   AF,AF'
1CD9: 08          EX   AF,AF'
1CDA: 14          INC  D
1CDB: 1B          DEC  DE
1CDC: 94          SUB  H
1CDD: 1B          DEC  DE
1CDE: 14          INC  D
1CDF: 08          EX   AF,AF'
1CE0: 14          INC  D
1CE1: 1B          DEC  DE
1CE2: A4          AND  H
1CE3: 1B          DEC  DE
1CE4: 14          INC  D
1CE5: 14          INC  D
1CE6: 13          INC  DE
1CE7: 1C          INC  E
1CE8: 80          ADD  A,B
1CE9: 1C          INC  E
1CEA: 13          INC  DE
1CEB: 14          INC  D
1CEC: 14          INC  D
1CED: 13          INC  DE
1CEE: 14          INC  D
1CEF: 90          SUB  B
1CF0: 14          INC  D
1CF1: 13          INC  DE
1CF2: 14          INC  D
1CF3: 14          INC  D
1CF4: 13          INC  DE
1CF5: 14          INC  D
1CF6: 90          SUB  B
1CF7: 14          INC  D
1CF8: 13          INC  DE
1CF9: 14          INC  D
1CFA: 14          INC  D
1CFB: 13          INC  DE
1CFC: 14          INC  D
1CFD: 90          SUB  B
1CFE: 14          INC  D
1CFF: 13          INC  DE
1D00: 14          INC  D
1D01: 14          INC  D
1D02: 13          INC  DE
1D03: 14          INC  D
1D04: 90          SUB  B
1D05: 14          INC  D
1D06: 13          INC  DE
1D07: 14          INC  D
1D08: 14          INC  D
1D09: 13          INC  DE
1D0A: 14          INC  D
1D0B: 90          SUB  B
1D0C: 14          INC  D
1D0D: 13          INC  DE
1D0E: 14          INC  D
1D0F: 14          INC  D
1D10: 13          INC  DE
1D11: 14          INC  D
1D12: 90          SUB  B
1D13: 14          INC  D
1D14: 13          INC  DE
1D15: 14          INC  D
1D16: 14          INC  D
1D17: 13          INC  DE
1D18: 1C          INC  E
1D19: 80          ADD  A,B
1D1A: 1C          INC  E
1D1B: 13          INC  DE
1D1C: 14          INC  D
1D1D: 14          INC  D
1D1E: 1B          DEC  DE
1D1F: A4          AND  H
1D20: 1B          DEC  DE
1D21: 14          INC  D
1D22: 08          EX   AF,AF'
1D23: 14          INC  D
1D24: 1B          DEC  DE
1D25: 94          SUB  H
1D26: 1B          DEC  DE
1D27: 14          INC  D
1D28: 08          EX   AF,AF'
1D29: 08          EX   AF,AF'
1D2A: 1C          INC  E
1D2B: B3          OR   E
1D2C: 1C          INC  E
1D2D: 08          EX   AF,AF'
1D2E: 10 1C       DJNZ $1D4C
1D30: A3          AND  E
1D31: 1C          INC  E
1D32: 10 18       DJNZ $1D4C
1D34: C4 18 28    CALL NZ,$2818
1D37: A4          AND  H
1D38: 28 C0       JR   Z,$1CFA
1D3A: 34          INC  (HL)
1D3B: C0          RET  NZ

1D3C: 34          INC  (HL)
1D3D: C0          RET  NZ

1D3E: 14          INC  D
1D3F: 13          INC  DE
1D40: 14          INC  D
1D41: C0          RET  NZ

1D42: 14          INC  D
1D43: 13          INC  DE
1D44: 14          INC  D
1D45: C0          RET  NZ

1D46: 14          INC  D
1D47: 13          INC  DE
1D48: 14          INC  D
1D49: C0          RET  NZ

1D4A: 14          INC  D
1D4B: 13          INC  DE
1D4C: 14          INC  D
1D4D: C0          RET  NZ

1D4E: 14          INC  D
1D4F: 13          INC  DE
1D50: 14          INC  D
1D51: D4 13 14    CALL NC,$1413
1D54: D4 13 14    CALL NC,$1413
1D57: 14          INC  D
1D58: D3 14       OUT  ($14),A
1D5A: 14          INC  D
1D5B: D3 14       OUT  ($14),A
1D5D: D4 13 14    CALL NC,$1413
1D60: D4 13 14    CALL NC,$1413
1D63: C0          RET  NZ

1D64: 14          INC  D
1D65: 13          INC  DE
1D66: 14          INC  D
1D67: C0          RET  NZ

1D68: 14          INC  D
1D69: 13          INC  DE
1D6A: 14          INC  D
1D6B: C0          RET  NZ

1D6C: 14          INC  D
1D6D: 13          INC  DE
1D6E: 14          INC  D
1D6F: C0          RET  NZ

1D70: 14          INC  D
1D71: 13          INC  DE
1D72: 14          INC  D
1D73: C0          RET  NZ

1D74: 14          INC  D
1D75: 13          INC  DE
1D76: 14          INC  D
1D77: C0          RET  NZ

1D78: 34          INC  (HL)
1D79: C0          RET  NZ

1D7A: 34          INC  (HL)
1D7B: F4 F4 14    CALL P,$14F4
1D7E: D3 14       OUT  ($14),A
1D80: 14          INC  D
1D81: D3 14       OUT  ($14),A
1D83: 74          LD   (HL),H
1D84: 13          INC  DE
1D85: 74          LD   (HL),H
1D86: 74          LD   (HL),H
1D87: 13          INC  DE
1D88: 74          LD   (HL),H
1D89: 60          LD   H,B
1D8A: 14          INC  D
1D8B: 13          INC  DE
1D8C: 14          INC  D
1D8D: 60          LD   H,B
1D8E: 60          LD   H,B
1D8F: 14          INC  D
1D90: 13          INC  DE
1D91: 14          INC  D
1D92: 60          LD   H,B
1D93: 60          LD   H,B
1D94: 14          INC  D
1D95: 13          INC  DE
1D96: 14          INC  D
1D97: 60          LD   H,B
1D98: 60          LD   H,B
1D99: 14          INC  D
1D9A: 13          INC  DE
1D9B: 14          INC  D
1D9C: 60          LD   H,B
1D9D: 60          LD   H,B
1D9E: 14          INC  D
1D9F: 13          INC  DE
1DA0: 14          INC  D
1DA1: 60          LD   H,B
1DA2: 60          LD   H,B
1DA3: 14          INC  D
1DA4: 13          INC  DE
1DA5: 14          INC  D
1DA6: 60          LD   H,B
1DA7: 60          LD   H,B
1DA8: 14          INC  D
1DA9: 13          INC  DE
1DAA: 14          INC  D
1DAB: 60          LD   H,B
1DAC: 60          LD   H,B
1DAD: 14          INC  D
1DAE: 13          INC  DE
1DAF: 14          INC  D
1DB0: 60          LD   H,B
1DB1: 74          LD   (HL),H
1DB2: 13          INC  DE
1DB3: 74          LD   (HL),H
1DB4: 74          LD   (HL),H
1DB5: 13          INC  DE
1DB6: 74          LD   (HL),H
1DB7: 14          INC  D
1DB8: D3 14       OUT  ($14),A
1DBA: 14          INC  D
1DBB: D3 14       OUT  ($14),A
1DBD: F4 F4 F4    CALL P,$F4F4
1DC0: F4 14 D3    CALL P,$D314
1DC3: 14          INC  D
1DC4: 14          INC  D
1DC5: D3 14       OUT  ($14),A
1DC7: 14          INC  D
1DC8: 13          INC  DE
1DC9: 54          LD   D,H
1DCA: 13          INC  DE
1DCB: 54          LD   D,H
1DCC: 13          INC  DE
1DCD: 14          INC  D
1DCE: 14          INC  D
1DCF: 13          INC  DE
1DD0: 54          LD   D,H
1DD1: 13          INC  DE
1DD2: 54          LD   D,H
1DD3: 13          INC  DE
1DD4: 14          INC  D
1DD5: 14          INC  D
1DD6: 13          INC  DE
1DD7: 14          INC  D
1DD8: 30 14       JR   NC,$1DEE
1DDA: 13          INC  DE
1DDB: 14          INC  D
1DDC: 30 14       JR   NC,$1DF2
1DDE: 13          INC  DE
1DDF: 14          INC  D
1DE0: 14          INC  D
1DE1: 13          INC  DE
1DE2: 14          INC  D
1DE3: 30 14       JR   NC,$1DF9
1DE5: 13          INC  DE
1DE6: 14          INC  D
1DE7: 30 14       JR   NC,$1DFD
1DE9: 13          INC  DE
1DEA: 14          INC  D
1DEB: 14          INC  D
1DEC: 13          INC  DE
1DED: 14          INC  D
1DEE: 30 14       JR   NC,$1E04
1DF0: 13          INC  DE
1DF1: 14          INC  D
1DF2: 30 14       JR   NC,$1E08
1DF4: 13          INC  DE
1DF5: 14          INC  D
1DF6: 14          INC  D
1DF7: 13          INC  DE
1DF8: 14          INC  D
1DF9: 30 14       JR   NC,$1E0F
1DFB: 13          INC  DE
1DFC: 14          INC  D
1DFD: 30 14       JR   NC,$1E13
1DFF: 13          INC  DE
1E00: 14          INC  D
1E01: 14          INC  D
1E02: 13          INC  DE
1E03: 14          INC  D
1E04: 30 14       JR   NC,$1E1A
1E06: 13          INC  DE
1E07: 14          INC  D
1E08: 30 14       JR   NC,$1E1E
1E0A: 13          INC  DE
1E0B: 14          INC  D
1E0C: 14          INC  D
1E0D: 13          INC  DE
1E0E: 14          INC  D
1E0F: 30 14       JR   NC,$1E25
1E11: 13          INC  DE
1E12: 14          INC  D
1E13: 30 14       JR   NC,$1E29
1E15: 13          INC  DE
1E16: 14          INC  D
1E17: 14          INC  D
1E18: 13          INC  DE
1E19: 14          INC  D
1E1A: 30 14       JR   NC,$1E30
1E1C: 13          INC  DE
1E1D: 14          INC  D
1E1E: 30 14       JR   NC,$1E34
1E20: 13          INC  DE
1E21: 14          INC  D
1E22: 14          INC  D
1E23: 13          INC  DE
1E24: 1C          INC  E
1E25: 20 1C       JR   NZ,$1E43
1E27: 13          INC  DE
1E28: 1C          INC  E
1E29: 20 1C       JR   NZ,$1E47
1E2B: 13          INC  DE
1E2C: 14          INC  D
1E2D: 14          INC  D
1E2E: 1B          DEC  DE
1E2F: 44          LD   B,H
1E30: 23          INC  HL
1E31: 44          LD   B,H
1E32: 1B          DEC  DE
1E33: 14          INC  D
1E34: 08          EX   AF,AF'
1E35: 14          INC  D
1E36: 1B          DEC  DE
1E37: 34          INC  (HL)
1E38: 33          INC  SP
1E39: 34          INC  (HL)
1E3A: 1B          DEC  DE
1E3B: 14          INC  D
1E3C: 08          EX   AF,AF'
1E3D: 08          EX   AF,AF'
1E3E: 1C          INC  E
1E3F: 53          LD   D,E
1E40: 14          INC  D
1E41: 53          LD   D,E
1E42: 1C          INC  E
1E43: 08          EX   AF,AF'
1E44: 10 1C       DJNZ $1E62
1E46: 43          LD   B,E
1E47: 24          INC  H
1E48: 43          LD   B,E
1E49: 1C          INC  E
1E4A: 10 18       DJNZ $1E64
1E4C: 5C          LD   E,H
1E4D: 10 5C       DJNZ $1EAB
1E4F: 18 28       JR   $1E79
1E51: 44          LD   B,H
1E52: 20 44       JR   NZ,$1E98
1E54: 28 28       JR   Z,$1E7E
1E56: A4          AND  H
1E57: 28 18       JR   Z,$1E71
1E59: C4 18 10    CALL NZ,$1018
1E5C: 1C          INC  E
1E5D: A3          AND  E
1E5E: 1C          INC  E
1E5F: 10 08       DJNZ $1E69
1E61: 1C          INC  E
1E62: B3          OR   E
1E63: 1C          INC  E
1E64: 08          EX   AF,AF'
1E65: 08          EX   AF,AF'
1E66: 14          INC  D
1E67: 1B          DEC  DE
1E68: 94          SUB  H
1E69: 1B          DEC  DE
1E6A: 14          INC  D
1E6B: 08          EX   AF,AF'
1E6C: 14          INC  D
1E6D: 1B          DEC  DE
1E6E: A4          AND  H
1E6F: 1B          DEC  DE
1E70: 14          INC  D
1E71: 14          INC  D
1E72: 13          INC  DE
1E73: 1C          INC  E
1E74: 80          ADD  A,B
1E75: 1C          INC  E
1E76: 13          INC  DE
1E77: 14          INC  D
1E78: 14          INC  D
1E79: 13          INC  DE
1E7A: 14          INC  D
1E7B: 90          SUB  B
1E7C: 14          INC  D
1E7D: 13          INC  DE
1E7E: 14          INC  D
1E7F: 14          INC  D
1E80: 13          INC  DE
1E81: 14          INC  D
1E82: 90          SUB  B
1E83: 14          INC  D
1E84: 13          INC  DE
1E85: 14          INC  D
1E86: 14          INC  D
1E87: 13          INC  DE
1E88: 14          INC  D
1E89: 90          SUB  B
1E8A: 14          INC  D
1E8B: 13          INC  DE
1E8C: 14          INC  D
1E8D: 14          INC  D
1E8E: 13          INC  DE
1E8F: 14          INC  D
1E90: 20 34       JR   NZ,$1EC6
1E92: 40          LD   B,B
1E93: 14          INC  D
1E94: 13          INC  DE
1E95: 14          INC  D
1E96: 14          INC  D
1E97: 13          INC  DE
1E98: 14          INC  D
1E99: 20 34       JR   NZ,$1ECF
1E9B: 40          LD   B,B
1E9C: 14          INC  D
1E9D: 13          INC  DE
1E9E: 14          INC  D
1E9F: 14          INC  D
1EA0: 13          INC  DE
1EA1: 14          INC  D
1EA2: 20 14       JR   NZ,$1EB8
1EA4: 13          INC  DE
1EA5: 14          INC  D
1EA6: 40          LD   B,B
1EA7: 14          INC  D
1EA8: 13          INC  DE
1EA9: 14          INC  D
1EAA: 14          INC  D
1EAB: 13          INC  DE
1EAC: 14          INC  D
1EAD: 20 14       JR   NZ,$1EC3
1EAF: 13          INC  DE
1EB0: 14          INC  D
1EB1: 38 1C       JR   C,$1ECF
1EB3: 13          INC  DE
1EB4: 14          INC  D
1EB5: 14          INC  D
1EB6: 13          INC  DE
1EB7: 44          LD   B,H
1EB8: 13          INC  DE
1EB9: 14          INC  D
1EBA: 30 1C       JR   NC,$1ED8
1EBC: 1B          DEC  DE
1EBD: 14          INC  D
1EBE: 14          INC  D
1EBF: 13          INC  DE
1EC0: 44          LD   B,H
1EC1: 13          INC  DE
1EC2: 14          INC  D
1EC3: 30 14       JR   NC,$1ED9
1EC5: 1B          DEC  DE
1EC6: 14          INC  D
1EC7: 08          EX   AF,AF'
1EC8: 14          INC  D
1EC9: 63          LD   H,E
1ECA: 14          INC  D
1ECB: 30 14       JR   NC,$1EE1
1ECD: 13          INC  DE
1ECE: 1C          INC  E
1ECF: 08          EX   AF,AF'
1ED0: 14          INC  D
1ED1: 63          LD   H,E
1ED2: 14          INC  D
1ED3: 30 14       JR   NC,$1EE9
1ED5: 0B          DEC  BC
1ED6: 1C          INC  E
1ED7: 10 84       DJNZ $1E5D
1ED9: 30 2C       JR   NC,$1F07
1EDB: 18 84       JR   $1E61
1EDD: 30 1C       JR   NC,$1EFB
1EDF: 28 F5       JR   Z,$1ED6
1EE1: C5          PUSH BC
1EE2: D5          PUSH DE
1EE3: DD E5       PUSH IX
1EE5: FD E5       PUSH IY
1EE7: 3E 05       LD   A,$05
1EE9: 32 F2 7B    LD   ($7BF2),A
1EEC: 21 F7 15    LD   HL,$15F7
1EEF: DD 21 40 95 LD   IX,$9540
1EF3: CD 03 13    CALL $1303
1EF6: FD 21 09 1F LD   IY,$1F09
1EFA: DD 21 90 9A LD   IX,$9A90
1EFE: CD 93 12    CALL $1293
1F01: FD E1       POP  IY
1F03: DD E1       POP  IX
1F05: D1          POP  DE
1F06: C1          POP  BC
1F07: F1          POP  AF
1F08: C9          RET

1F09: 17          RLA
1F0A: FF          RST  $38
1F0B: 09          ADD  HL,BC
1F0C: 8C          ADC  A,H
1F0D: B4          OR   H
1F0E: AF          XOR  A
1F0F: 96          SUB  (HL)
1F10: 82          ADD  A,D
1F11: 14          INC  D
1F12: 4B          LD   C,E
1F13: 46          LD   B,(HL)
1F14: 5A          LD   E,D
1F15: 82          ADD  A,D
1F16: 0A          LD   A,(BC)
1F17: 46          LD   B,(HL)
1F18: 55          LD   D,L
1F19: 4B          LD   C,E
1F1A: 46          LD   B,(HL)
1F1B: 55          LD   D,L
1F1C: 00          NOP
1F1D: 5F          LD   E,A
1F1E: 28 46       JR   Z,$1F66
1F20: 41          LD   B,C
1F21: DB 00       IN   A,($00)
1F23: CB 5F       BIT  3,A
1F25: 16 02       LD   D,$02
1F27: 28 02       JR   Z,$1F2B
1F29: 16 10       LD   D,$10
1F2B: CD 47 08    CALL $0847
1F2E: 82          ADD  A,D
1F2F: 27          DAA
1F30: 32 4D 7C    LD   ($7C4D),A
1F33: DB 00       IN   A,($00)
1F35: CD 35 08    CALL $0835
1F38: 21 69 7D    LD   HL,$7D69
1F3B: 77          LD   (HL),A
1F3C: 97          SUB  A
1F3D: 32 6D 7D    LD   ($7D6D),A
1F40: 32 85 7D    LD   ($7D85),A
1F43: 3C          INC  A
1F44: 32 64 7D    LD   ($7D64),A
1F47: 32 7F 7D    LD   ($7D7F),A
1F4A: 32 80 7D    LD   ($7D80),A
1F4D: 7E          LD   A,(HL)
1F4E: 32 83 7D    LD   ($7D83),A
1F51: 3A 66 7D    LD   A,($7D66)
1F54: 32 6A 7D    LD   ($7D6A),A
1F57: FE 01       CP   $01
1F59: 28 04       JR   Z,$1F5F
1F5B: 7E          LD   A,(HL)
1F5C: 32 85 7D    LD   ($7D85),A
1F5F: 97          SUB  A
1F60: 06 0F       LD   B,$0F
1F62: 21 88 7D    LD   HL,$7D88
1F65: 77          LD   (HL),A
1F66: 23          INC  HL
1F67: 10 FC       DJNZ $1F65
1F69: 32 B4 7C    LD   ($7CB4),A
1F6C: 3C          INC  A
1F6D: 32 91 7D    LD   ($7D91),A
1F70: 32 94 7D    LD   ($7D94),A
1F73: 32 92 7D    LD   ($7D92),A
1F76: 32 95 7D    LD   ($7D95),A
1F79: 32 82 7D    LD   ($7D82),A
1F7C: 32 84 7D    LD   ($7D84),A
1F7F: 32 86 7D    LD   ($7D86),A
1F82: 32 87 7D    LD   ($7D87),A
1F85: 21 83 7D    LD   HL,$7D83
1F88: 3A 64 7D    LD   A,($7D64)
1F8B: FE 01       CP   $01
1F8D: 28 02       JR   Z,$1F91
1F8F: 23          INC  HL
1F90: 23          INC  HL
1F91: 35          DEC  (HL)
1F92: CD 0F 27    CALL $270F
1F95: D3 00       OUT  ($00),A
1F97: CD FA 2B    CALL $2BFA
1F9A: D3 00       OUT  ($00),A
1F9C: 3A 6D 7D    LD   A,($7D6D)
1F9F: FE 01       CP   $01
1FA1: 28 30       JR   Z,$1FD3
1FA3: 97          SUB  A
1FA4: CD 45 12    CALL $1245
1FA7: 3A 64 7D    LD   A,($7D64)
1FAA: 01 87 7D    LD   BC,$7D87
1FAD: 21 94 7D    LD   HL,$7D94
1FB0: FE 01       CP   $01
1FB2: 20 06       JR   NZ,$1FBA
1FB4: 01 86 7D    LD   BC,$7D86
1FB7: 21 91 7D    LD   HL,$7D91
1FBA: 34          INC  (HL)
1FBB: 23          INC  HL
1FBC: 7E          LD   A,(HL)
1FBD: C6 01       ADD  A,$01
1FBF: 27          DAA
1FC0: 77          LD   (HL),A
1FC1: 23          INC  HL
1FC2: 7E          LD   A,(HL)
1FC3: CE 00       ADC  A,$00
1FC5: 27          DAA
1FC6: 77          LD   (HL),A
1FC7: DB 00       IN   A,($00)
1FC9: CD 47 08    CALL $0847
1FCC: 3C          INC  A
1FCD: 57          LD   D,A
1FCE: 0A          LD   A,(BC)
1FCF: 82          ADD  A,D
1FD0: 02          LD   (BC),A
1FD1: 18 BF       JR   $1F92
1FD3: 97          SUB  A
1FD4: CD 45 12    CALL $1245
1FD7: 32 6D 7D    LD   ($7D6D),A
1FDA: 21 64 7D    LD   HL,$7D64
1FDD: 3C          INC  A
1FDE: BE          CP   (HL)
1FDF: 11 83 7D    LD   DE,$7D83
1FE2: 28 03       JR   Z,$1FE7
1FE4: 11 85 7D    LD   DE,$7D85
1FE7: 1A          LD   A,(DE)
1FE8: FE 00       CP   $00
1FEA: 28 4D       JR   Z,$2039
1FEC: 3A 6A 7D    LD   A,($7D6A)
1FEF: FE 02       CP   $02
1FF1: 28 06       JR   Z,$1FF9
1FF3: 97          SUB  A
1FF4: 32 77 7D    LD   ($7D77),A
1FF7: 18 7A       JR   $2073
1FF9: 7E          LD   A,(HL)
1FFA: EE 03       XOR  $03
1FFC: 77          LD   (HL),A
1FFD: 97          SUB  A
1FFE: 32 77 7D    LD   ($7D77),A
2001: 3E 05       LD   A,$05
2003: CD 53 0B    CALL $0B53
2006: F5          PUSH AF
2007: 0E 12       LD   C,$12
2009: 3E EE       LD   A,$EE
200B: CD 21 12    CALL $1221
200E: 0E 15       LD   C,$15
2010: 97          SUB  A
2011: CD 21 12    CALL $1221
2014: FD 21 3F 21 LD   IY,$213F
2018: DD 21 78 A5 LD   IX,$A578
201C: CD 98 12    CALL $1298
201F: 7E          LD   A,(HL)
2020: FD 21 3D 21 LD   IY,$213D
2024: DD 21 A0 CA LD   IX,$CAA0
2028: FE 02       CP   $02
202A: 28 04       JR   Z,$2030
202C: FD 21 3B 21 LD   IY,$213B
2030: CD 98 12    CALL $1298
2033: F1          POP  AF
2034: CD B8 11    CALL $11B8
2037: 18 3A       JR   $2073
2039: 3A 6A 7D    LD   A,($7D6A)
203C: 3D          DEC  A
203D: 32 6A 7D    LD   ($7D6A),A
2040: F5          PUSH AF
2041: FD 21 27 21 LD   IY,$2127
2045: DD 21 78 A5 LD   IX,$A578
2049: CD 98 12    CALL $1298
204C: 3E 01       LD   A,$01
204E: FD 21 3D 21 LD   IY,$213D
2052: BE          CP   (HL)
2053: C2 5A 20    JP   NZ,$205A
2056: FD 21 3B 21 LD   IY,$213B
205A: DD 21 A0 CA LD   IX,$CAA0
205E: CD 98 12    CALL $1298
2061: 3E 12       LD   A,$12
2063: CD 53 0B    CALL $0B53
2066: CD B8 11    CALL $11B8
2069: F1          POP  AF
206A: FE 01       CP   $01
206C: 28 8B       JR   Z,$1FF9
206E: 3E 01       LD   A,$01
2070: 32 77 7D    LD   ($7D77),A
2073: 3A 77 7D    LD   A,($7D77)
2076: FE 01       CP   $01
2078: C2 85 1F    JP   NZ,$1F85
207B: CD 2A 3E    CALL $3E2A
207E: 3A 65 7D    LD   A,($7D65)
2081: FE 00       CP   $00
2083: CA 53 21    JP   Z,$2153
2086: 97          SUB  A
2087: 32 8C 7C    LD   ($7C8C),A
208A: 3C          INC  A
208B: 32 B5 7C    LD   ($7CB5),A
208E: 21 65 7D    LD   HL,$7D65
2091: 97          SUB  A
2092: 32 78 7D    LD   ($7D78),A
2095: CD 45 12    CALL $1245
2098: CD D2 1A    CALL $1AD2
209B: FD 21 FF 20 LD   IY,$20FF
209F: DD 21 B0 B1 LD   IX,$B1B0
20A3: CD 98 12    CALL $1298
20A6: 7E          LD   A,(HL)
20A7: FD 21 10 21 LD   IY,$2110
20AB: DD 21 B0 A9 LD   IX,$A9B0
20AF: FE 01       CP   $01
20B1: 28 08       JR   Z,$20BB
20B3: FD 21 19 21 LD   IY,$2119
20B7: DD 21 C0 99 LD   IX,$99C0
20BB: CD 98 12    CALL $1298
20BE: DB 01       IN   A,($01)
20C0: 2F          CPL
20C1: 47          LD   B,A
20C2: CB 50       BIT  2,B
20C4: 28 0C       JR   Z,$20D2
20C6: 3E 01       LD   A,$01
20C8: 32 66 7D    LD   ($7D66),A
20CB: 7E          LD   A,(HL)
20CC: D6 01       SUB  $01
20CE: 27          DAA
20CF: 77          LD   (HL),A
20D0: 18 14       JR   $20E6
20D2: 7E          LD   A,(HL)
20D3: FE 02       CP   $02
20D5: 38 20       JR   C,$20F7
20D7: CB 58       BIT  3,B
20D9: CA F7 20    JP   Z,$20F7
20DC: 3E 02       LD   A,$02
20DE: 32 66 7D    LD   ($7D66),A
20E1: 7E          LD   A,(HL)
20E2: D6 02       SUB  $02
20E4: 27          DAA
20E5: 77          LD   (HL),A
20E6: 3A 66 7D    LD   A,($7D66)
20E9: 32 6C 7D    LD   ($7D6C),A
20EC: 97          SUB  A
20ED: D3 01       OUT  ($01),A
20EF: 3E 06       LD   A,$06
20F1: CD 53 0B    CALL $0B53
20F4: C3 21 1F    JP   $1F21
20F7: D3 00       OUT  ($00),A
20F9: CD B8 17    CALL $17B8
20FC: C3 A6 20    JP   $20A6
20FF: 10 FF       DJNZ $2100
2101: 07          RLCA
2102: 10 12       DJNZ $2116
2104: 05          DEC  B
2105: 13          INC  DE
2106: 13          INC  DE
2107: FF          RST  $38
2108: 80          ADD  A,B
2109: FF          RST  $38
210A: 80          ADD  A,B
210B: 13          INC  DE
210C: 14          INC  D
210D: 01 12 14    LD   BC,$1412
2110: 08          EX   AF,AF'
2111: 1C          INC  E
2112: 00          NOP
2113: 10 0C       DJNZ $2121
2115: 01 19 05    LD   BC,$0519
2118: 12          LD   (DE),A
2119: 0D          DEC  C
211A: 1C          INC  E
211B: 00          NOP
211C: 0F          RRCA
211D: 12          LD   (DE),A
211E: 00          NOP
211F: 1D          DEC  E
2120: 00          NOP
2121: 10 0C       DJNZ $212F
2123: 01 19 05    LD   BC,$0519
2126: 12          LD   (DE),A
2127: 13          INC  DE
2128: FF          RST  $38
2129: 01 07 01    LD   BC,$0107
212C: 0D          DEC  C
212D: 05          DEC  B
212E: 00          NOP
212F: 0F          RRCA
2130: 16 05       LD   D,$05
2132: 12          LD   (DE),A
2133: FF          RST  $38
2134: 80          ADD  A,B
2135: 10 0C       DJNZ $2143
2137: 01 19 05    LD   BC,$0519
213A: 12          LD   (DE),A
213B: 01 1C 01    LD   BC,$011C
213E: 1D          DEC  E
213F: 13          INC  DE
2140: FF          RST  $38
2141: 07          RLCA
2142: 07          RLCA
2143: 05          DEC  B
2144: 14          INC  D
2145: 00          NOP
2146: 12          LD   (DE),A
2147: 05          DEC  B
2148: 01 04 19    LD   BC,$1904
214B: FF          RST  $38
214C: 80          ADD  A,B
214D: 10 0C       DJNZ $215B
214F: 01 19 05    LD   BC,$0519
2152: 12          LD   (DE),A
2153: FB          EI
2154: 97          SUB  A
2155: CD 45 12    CALL $1245
2158: 3C          INC  A
2159: 32 8C 7C    LD   ($7C8C),A
215C: DB 00       IN   A,($00)
215E: CB 7F       BIT  7,A
2160: 3E 01       LD   A,$01
2162: 28 01       JR   Z,$2165
2164: 97          SUB  A
2165: 32 B5 7C    LD   ($7CB5),A
2168: 3E 01       LD   A,$01
216A: 32 B4 7C    LD   ($7CB4),A
216D: 3E 18       LD   A,$18
216F: 32 91 7D    LD   ($7D91),A
2172: 3E 10       LD   A,$10
2174: 32 86 7D    LD   ($7D86),A
2177: CD A8 21    CALL $21A8
217A: 32 B4 7C    LD   ($7CB4),A
217D: 3C          INC  A
217E: 32 91 7D    LD   ($7D91),A
2181: 3E 11       LD   A,$11
2183: 32 86 7D    LD   ($7D86),A
2186: CD A8 21    CALL $21A8
2189: CD 16 42    CALL $4216
218C: CD 46 25    CALL $2546
218F: 0E 08       LD   C,$08
2191: CD EA 11    CALL $11EA
2194: 97          SUB  A
2195: CD 45 12    CALL $1245
2198: 3E 08       LD   A,$08
219A: 32 91 7D    LD   ($7D91),A
219D: 3E 12       LD   A,$12
219F: 32 86 7D    LD   ($7D86),A
21A2: CD A8 21    CALL $21A8
21A5: C3 68 21    JP   $2168
21A8: 3E 01       LD   A,$01
21AA: 32 64 7D    LD   ($7D64),A
21AD: 32 7F 7D    LD   ($7D7F),A
21B0: 32 81 7D    LD   ($7D81),A
21B3: CD 0F 27    CALL $270F
21B6: 06 09       LD   B,$09
21B8: 3E FF       LD   A,$FF
21BA: 32 65 79    LD   ($7965),A
21BD: F5          PUSH AF
21BE: 97          SUB  A
21BF: CD D7 21    CALL $21D7
21C2: F1          POP  AF
21C3: 3C          INC  A
21C4: 10 F4       DJNZ $21BA
21C6: CD D2 1A    CALL $1AD2
21C9: CD E0 1E    CALL $1EE0
21CC: CD AB 18    CALL $18AB
21CF: CD FA 2B    CALL $2BFA
21D2: 97          SUB  A
21D3: CD 45 12    CALL $1245
21D6: C9          RET

21D7: F5          PUSH AF
21D8: C5          PUSH BC
21D9: D5          PUSH DE
21DA: E5          PUSH HL
21DB: 4F          LD   C,A
21DC: 97          SUB  A
21DD: 32 B3 7C    LD   ($7CB3),A
21E0: 3A 65 79    LD   A,($7965)
21E3: 3C          INC  A
21E4: 16 00       LD   D,$00
21E6: 5F          LD   E,A
21E7: 21 A8 7C    LD   HL,$7CA8
21EA: 19          ADD  HL,DE
21EB: E5          PUSH HL
21EC: 21 8D 7C    LD   HL,$7C8D
21EF: 19          ADD  HL,DE
21F0: E5          PUSH HL
21F1: CB 03       RLC  E
21F3: 21 96 7C    LD   HL,$7C96
21F6: 19          ADD  HL,DE
21F7: E5          PUSH HL
21F8: 79          LD   A,C
21F9: FE 01       CP   $01
21FB: 28 2A       JR   Z,$2227
21FD: 3A 91 7D    LD   A,($7D91)
2200: FE 18       CP   $18
2202: 21 5D 22    LD   HL,$225D
2205: 28 0A       JR   Z,$2211
2207: FE 01       CP   $01
2209: 21 6F 22    LD   HL,$226F
220C: 28 03       JR   Z,$2211
220E: 21 81 22    LD   HL,$2281
2211: 19          ADD  HL,DE
2212: 4E          LD   C,(HL)
2213: 23          INC  HL
2214: 46          LD   B,(HL)
2215: E1          POP  HL
2216: 71          LD   (HL),C
2217: 23          INC  HL
2218: 70          LD   (HL),B
2219: E1          POP  HL
221A: 36 00       LD   (HL),$00
221C: C1          POP  BC
221D: 3A B3 7C    LD   A,($7CB3)
2220: FE 01       CP   $01
2222: 20 28       JR   NZ,$224C
2224: 4F          LD   C,A
2225: 18 B9       JR   $21E0
2227: E1          POP  HL
2228: 22 B1 7C    LD   ($7CB1),HL
222B: 5E          LD   E,(HL)
222C: 23          INC  HL
222D: 56          LD   D,(HL)
222E: E1          POP  HL
222F: C1          POP  BC
2230: 7E          LD   A,(HL)
2231: FE 00       CP   $00
2233: 20 12       JR   NZ,$2247
2235: 1A          LD   A,(DE)
2236: FE FF       CP   $FF
2238: 28 1A       JR   Z,$2254
223A: 77          LD   (HL),A
223B: 13          INC  DE
223C: 1A          LD   A,(DE)
223D: 02          LD   (BC),A
223E: 13          INC  DE
223F: E5          PUSH HL
2240: 2A B1 7C    LD   HL,($7CB1)
2243: 73          LD   (HL),E
2244: 23          INC  HL
2245: 72          LD   (HL),D
2246: E1          POP  HL
2247: 35          DEC  (HL)
2248: 0A          LD   A,(BC)
2249: 32 B3 7C    LD   ($7CB3),A
224C: CD 03 12    CALL $1203
224F: E1          POP  HL
2250: D1          POP  DE
2251: C1          POP  BC
2252: F1          POP  AF
2253: C9          RET

2254: 3E 01       LD   A,$01
2256: 32 B3 7C    LD   ($7CB3),A
2259: 0E 00       LD   C,$00
225B: 18 83       JR   $21E0
225D: 93          SUB  E
225E: 22 BC 22    LD   ($22BC),HL
2261: C1          POP  BC
2262: 22 D0 22    LD   ($22D0),HL
2265: DF          RST  $18
2266: 22 F6 22    LD   ($22F6),HL
2269: 0D          DEC  C
226A: 23          INC  HL
226B: 16 23       LD   D,$23
226D: 1B          DEC  DE
226E: 23          INC  HL
226F: 26 23       LD   H,$23
2271: 8D          ADC  A,L
2272: 23          INC  HL
2273: 9C          SBC  A,H
2274: 23          INC  HL
2275: B5          OR   L
2276: 23          INC  HL
2277: C2 23 F7    JP   NZ,$F723
227A: 23          INC  HL
227B: 16 24       LD   D,$24
227D: 1B          DEC  DE
227E: 24          INC  H
227F: 56          LD   D,(HL)
2280: 24          INC  H
2281: 67          LD   H,A
2282: 24          INC  H
2283: C0          RET  NZ

2284: 24          INC  H
2285: CB 24       SLA  H
2287: D2 24 EF    JP   NC,$EF24
228A: 24          INC  H
228B: 0C          INC  C
228C: 25          DEC  H
228D: 21 25 30    LD   HL,$3025
2290: 25          DEC  H
2291: 41          LD   B,C
2292: 25          DEC  H
2293: 19          ADD  HL,DE
2294: 80          ADD  A,B
2295: 08          EX   AF,AF'
2296: 85          ADD  A,L
2297: 07          RLCA
2298: 84          ADD  A,H
2299: 04          INC  B
229A: 80          ADD  A,B
229B: 04          INC  B
229C: 88          ADC  A,B
229D: 03          INC  BC
229E: 80          ADD  A,B
229F: 01 84 18    LD   BC,$1884
22A2: 87          ADD  A,A
22A3: 02          LD   (BC),A
22A4: 80          ADD  A,B
22A5: 02          LD   (BC),A
22A6: 85          ADD  A,L
22A7: 0B          DEC  BC
22A8: 90          SUB  B
22A9: 11 80 0A    LD   DE,$0A80
22AC: 90          SUB  B
22AD: 20 80       JR   NZ,$222F
22AF: 0C          INC  C
22B0: 90          SUB  B
22B1: 16 80       LD   D,$80
22B3: 0E 90       LD   C,$90
22B5: 1D          DEC  E
22B6: 80          ADD  A,B
22B7: 0C          INC  C
22B8: 90          SUB  B
22B9: 64          LD   H,H
22BA: 80          ADD  A,B
22BB: FF          RST  $38
22BC: 07          RLCA
22BD: 84          ADD  A,H
22BE: 64          LD   H,H
22BF: 80          ADD  A,B
22C0: FF          RST  $38
22C1: 01 85 04    LD   BC,$0485
22C4: 88          ADC  A,B
22C5: 02          LD   (BC),A
22C6: 80          ADD  A,B
22C7: 08          EX   AF,AF'
22C8: 84          ADD  A,H
22C9: 02          LD   (BC),A
22CA: 80          ADD  A,B
22CB: 02          LD   (BC),A
22CC: 88          ADC  A,B
22CD: 64          LD   H,H
22CE: 80          ADD  A,B
22CF: FF          RST  $38
22D0: 08          EX   AF,AF'
22D1: 87          ADD  A,A
22D2: 02          LD   (BC),A
22D3: 80          ADD  A,B
22D4: 03          INC  BC
22D5: 84          ADD  A,H
22D6: 08          EX   AF,AF'
22D7: 86          ADD  A,(HL)
22D8: 02          LD   (BC),A
22D9: 80          ADD  A,B
22DA: 04          INC  B
22DB: 84          ADD  A,H
22DC: 64          LD   H,H
22DD: 80          ADD  A,B
22DE: FF          RST  $38
22DF: 01 85 02    LD   BC,$0285
22E2: 88          ADC  A,B
22E3: 04          INC  B
22E4: 80          ADD  A,B
22E5: 01 84 08    LD   BC,$0884
22E8: 87          ADD  A,A
22E9: 08          EX   AF,AF'
22EA: 86          ADD  A,(HL)
22EB: 02          LD   (BC),A
22EC: 80          ADD  A,B
22ED: 04          INC  B
22EE: 84          ADD  A,H
22EF: 02          LD   (BC),A
22F0: 80          ADD  A,B
22F1: 03          INC  BC
22F2: 84          ADD  A,H
22F3: 64          LD   H,H
22F4: 80          ADD  A,B
22F5: FF          RST  $38
22F6: 08          EX   AF,AF'
22F7: 87          ADD  A,A
22F8: 02          LD   (BC),A
22F9: 80          ADD  A,B
22FA: 04          INC  B
22FB: 84          ADD  A,H
22FC: 04          INC  B
22FD: 88          ADC  A,B
22FE: 04          INC  B
22FF: 80          ADD  A,B
2300: 01 85 02    LD   BC,$0285
2303: 80          ADD  A,B
2304: 08          EX   AF,AF'
2305: 86          ADD  A,(HL)
2306: 02          LD   (BC),A
2307: 80          ADD  A,B
2308: 0F          RRCA
2309: 84          ADD  A,H
230A: 0F          RRCA
230B: 85          ADD  A,L
230C: FF          RST  $38
230D: 0A          LD   A,(BC)
230E: 85          ADD  A,L
230F: 0A          LD   A,(BC)
2310: 88          ADC  A,B
2311: 0A          LD   A,(BC)
2312: 85          ADD  A,L
2313: FA 88 FF    JP   M,$FF88
2316: 10 84       DJNZ $229C
2318: FA 80 FF    JP   M,$FF80
231B: 02          LD   (BC),A
231C: 85          ADD  A,L
231D: 02          LD   (BC),A
231E: 84          ADD  A,H
231F: 02          LD   (BC),A
2320: 85          ADD  A,L
2321: 02          LD   (BC),A
2322: 84          ADD  A,H
2323: FA 80 FF    JP   M,$FF80
2326: 0A          LD   A,(BC)
2327: 80          ADD  A,B
2328: 02          LD   (BC),A
2329: 85          ADD  A,L
232A: 03          INC  BC
232B: 84          ADD  A,H
232C: 03          INC  BC
232D: 80          ADD  A,B
232E: 05          DEC  B
232F: 85          ADD  A,L
2330: 0A          LD   A,(BC)
2331: 90          SUB  B
2332: 02          LD   (BC),A
2333: 80          ADD  A,B
2334: 04          INC  B
2335: 85          ADD  A,L
2336: 04          INC  B
2337: 88          ADC  A,B
2338: 06 85       LD   B,$85
233A: 01 80 06    LD   BC,$0680
233D: 90          SUB  B
233E: 03          INC  BC
233F: 80          ADD  A,B
2340: 07          RLCA
2341: 84          ADD  A,H
2342: 07          RLCA
2343: 87          ADD  A,A
2344: 09          ADD  HL,BC
2345: 84          ADD  A,H
2346: 04          INC  B
2347: 88          ADC  A,B
2348: 0A          LD   A,(BC)
2349: 80          ADD  A,B
234A: 01 85 07    LD   BC,$0785
234D: 87          ADD  A,A
234E: 03          INC  BC
234F: 84          ADD  A,H
2350: 02          LD   (BC),A
2351: 85          ADD  A,L
2352: 07          RLCA
2353: 87          ADD  A,A
2354: 03          INC  BC
2355: 84          ADD  A,H
2356: 02          LD   (BC),A
2357: 85          ADD  A,L
2358: 07          RLCA
2359: 87          ADD  A,A
235A: 03          INC  BC
235B: 84          ADD  A,H
235C: 02          LD   (BC),A
235D: 85          ADD  A,L
235E: 07          RLCA
235F: 87          ADD  A,A
2360: 03          INC  BC
2361: 85          ADD  A,L
2362: 0A          LD   A,(BC)
2363: 90          SUB  B
2364: 02          LD   (BC),A
2365: 85          ADD  A,L
2366: 08          EX   AF,AF'
2367: 88          ADC  A,B
2368: 0A          LD   A,(BC)
2369: 80          ADD  A,B
236A: 01 85 08    LD   BC,$0885
236D: 86          ADD  A,(HL)
236E: 03          INC  BC
236F: 87          ADD  A,A
2370: 02          LD   (BC),A
2371: 86          ADD  A,(HL)
2372: 04          INC  B
2373: 87          ADD  A,A
2374: 03          INC  BC
2375: 86          ADD  A,(HL)
2376: 05          DEC  B
2377: 87          ADD  A,A
2378: 08          EX   AF,AF'
2379: 86          ADD  A,(HL)
237A: 02          LD   (BC),A
237B: 85          ADD  A,L
237C: 02          LD   (BC),A
237D: 84          ADD  A,H
237E: 02          LD   (BC),A
237F: 85          ADD  A,L
2380: 06 80       LD   B,$80
2382: 0A          LD   A,(BC)
2383: 90          SUB  B
2384: 02          LD   (BC),A
2385: 85          ADD  A,L
2386: 0F          RRCA
2387: 86          ADD  A,(HL)
2388: 07          RLCA
2389: 80          ADD  A,B
238A: 03          INC  BC
238B: 85          ADD  A,L
238C: FF          RST  $38
238D: 01 80 08    LD   BC,$0880
2390: 84          ADD  A,H
2391: 02          LD   (BC),A
2392: 80          ADD  A,B
2393: 05          DEC  B
2394: 85          ADD  A,L
2395: 04          INC  B
2396: 84          ADD  A,H
2397: 0A          LD   A,(BC)
2398: 80          ADD  A,B
2399: 05          DEC  B
239A: 85          ADD  A,L
239B: FF          RST  $38
239C: 0D          DEC  C
239D: 85          ADD  A,L
239E: 0A          LD   A,(BC)
239F: 80          ADD  A,B
23A0: 0E 84       LD   C,$84
23A2: 0A          LD   A,(BC)
23A3: 80          ADD  A,B
23A4: 06 85       LD   B,$85
23A6: 07          RLCA
23A7: 84          ADD  A,H
23A8: 02          LD   (BC),A
23A9: 80          ADD  A,B
23AA: 05          DEC  B
23AB: 85          ADD  A,L
23AC: 06 84       LD   B,$84
23AE: 10 80       DJNZ $2330
23B0: 04          INC  B
23B1: 85          ADD  A,L
23B2: 32 80 FF    LD   ($FF80),A
23B5: 04          INC  B
23B6: 85          ADD  A,L
23B7: 04          INC  B
23B8: 88          ADC  A,B
23B9: 02          LD   (BC),A
23BA: 80          ADD  A,B
23BB: 02          LD   (BC),A
23BC: 84          ADD  A,H
23BD: 04          INC  B
23BE: 88          ADC  A,B
23BF: 02          LD   (BC),A
23C0: 85          ADD  A,L
23C1: FF          RST  $38
23C2: 0A          LD   A,(BC)
23C3: 80          ADD  A,B
23C4: 02          LD   (BC),A
23C5: 85          ADD  A,L
23C6: 04          INC  B
23C7: 88          ADC  A,B
23C8: 01 80 01    LD   BC,$0180
23CB: 85          ADD  A,L
23CC: 1F          RRA
23CD: 86          ADD  A,(HL)
23CE: 09          ADD  HL,BC
23CF: 85          ADD  A,L
23D0: 0A          LD   A,(BC)
23D1: 80          ADD  A,B
23D2: 0C          INC  C
23D3: 84          ADD  A,H
23D4: 04          INC  B
23D5: 88          ADC  A,B
23D6: 09          ADD  HL,BC
23D7: 80          ADD  A,B
23D8: 01 84 17    LD   BC,$1784
23DB: 87          ADD  A,A
23DC: 04          INC  B
23DD: 85          ADD  A,L
23DE: 04          INC  B
23DF: 88          ADC  A,B
23E0: 01 80 01    LD   BC,$0180
23E3: 85          ADD  A,L
23E4: 07          RLCA
23E5: 87          ADD  A,A
23E6: 07          RLCA
23E7: 85          ADD  A,L
23E8: 04          INC  B
23E9: 88          ADC  A,B
23EA: 04          INC  B
23EB: 80          ADD  A,B
23EC: 01 85 01    LD   BC,$0185
23EF: 80          ADD  A,B
23F0: 03          INC  BC
23F1: 87          ADD  A,A
23F2: 1A          LD   A,(DE)
23F3: 86          ADD  A,(HL)
23F4: 03          INC  BC
23F5: 85          ADD  A,L
23F6: FF          RST  $38
23F7: 03          INC  BC
23F8: 84          ADD  A,H
23F9: 09          ADD  HL,BC
23FA: 85          ADD  A,L
23FB: 04          INC  B
23FC: 88          ADC  A,B
23FD: 02          LD   (BC),A
23FE: 80          ADD  A,B
23FF: 02          LD   (BC),A
2400: 85          ADD  A,L
2401: 04          INC  B
2402: 88          ADC  A,B
2403: 02          LD   (BC),A
2404: 80          ADD  A,B
2405: 02          LD   (BC),A
2406: 84          ADD  A,H
2407: 0A          LD   A,(BC)
2408: 80          ADD  A,B
2409: 04          INC  B
240A: 88          ADC  A,B
240B: 03          INC  BC
240C: 85          ADD  A,L
240D: 04          INC  B
240E: 88          ADC  A,B
240F: 03          INC  BC
2410: 84          ADD  A,H
2411: 02          LD   (BC),A
2412: 80          ADD  A,B
2413: 01 85 FF    LD   BC,$FF85
2416: 05          DEC  B
2417: 84          ADD  A,H
2418: 05          DEC  B
2419: 85          ADD  A,L
241A: FF          RST  $38
241B: 19          ADD  HL,DE
241C: 80          ADD  A,B
241D: 01 84 0F    LD   BC,$0F84
2420: 80          ADD  A,B
2421: 04          INC  B
2422: 88          ADC  A,B
2423: 0A          LD   A,(BC)
2424: 80          ADD  A,B
2425: 01 85 07    LD   BC,$0785
2428: 87          ADD  A,A
2429: 04          INC  B
242A: 80          ADD  A,B
242B: 02          LD   (BC),A
242C: 85          ADD  A,L
242D: 04          INC  B
242E: 88          ADC  A,B
242F: 02          LD   (BC),A
2430: 80          ADD  A,B
2431: 04          INC  B
2432: 84          ADD  A,H
2433: 04          INC  B
2434: 88          ADC  A,B
2435: 02          LD   (BC),A
2436: 80          ADD  A,B
2437: 01 84 08    LD   BC,$0884
243A: 87          ADD  A,A
243B: 04          INC  B
243C: 85          ADD  A,L
243D: 04          INC  B
243E: 80          ADD  A,B
243F: 03          INC  BC
2440: 84          ADD  A,H
2441: 02          LD   (BC),A
2442: 80          ADD  A,B
2443: 07          RLCA
2444: 87          ADD  A,A
2445: 03          INC  BC
2446: 84          ADD  A,H
2447: 03          INC  BC
2448: 85          ADD  A,L
2449: 17          RLA
244A: 80          ADD  A,B
244B: 04          INC  B
244C: 86          ADD  A,(HL)
244D: 04          INC  B
244E: 87          ADD  A,A
244F: 05          DEC  B
2450: 80          ADD  A,B
2451: 07          RLCA
2452: 86          ADD  A,(HL)
2453: 06 84       LD   B,$84
2455: FF          RST  $38
2456: 14          INC  D
2457: 80          ADD  A,B
2458: 04          INC  B
2459: 84          ADD  A,H
245A: 04          INC  B
245B: 88          ADC  A,B
245C: 03          INC  BC
245D: 85          ADD  A,L
245E: 03          INC  BC
245F: 84          ADD  A,H
2460: 07          RLCA
2461: 87          ADD  A,A
2462: 0F          RRCA
2463: 85          ADD  A,L
2464: 04          INC  B
2465: 88          ADC  A,B
2466: FF          RST  $38
2467: 0C          INC  C
2468: 80          ADD  A,B
2469: 06 85       LD   B,$85
246B: 0C          INC  C
246C: 90          SUB  B
246D: 02          LD   (BC),A
246E: 80          ADD  A,B
246F: 06 85       LD   B,$85
2471: 06 88       LD   B,$88
2473: 0C          INC  C
2474: 80          ADD  A,B
2475: 01 85 06    LD   BC,$0685
2478: 80          ADD  A,B
2479: 01 85 06    LD   BC,$0685
247C: 80          ADD  A,B
247D: 04          INC  B
247E: 88          ADC  A,B
247F: 0A          LD   A,(BC)
2480: 80          ADD  A,B
2481: 02          LD   (BC),A
2482: 90          SUB  B
2483: 02          LD   (BC),A
2484: 84          ADD  A,H
2485: 27          DAA
2486: 87          ADD  A,A
2487: 03          INC  BC
2488: 84          ADD  A,H
2489: 03          INC  BC
248A: 85          ADD  A,L
248B: 05          DEC  B
248C: 80          ADD  A,B
248D: 04          INC  B
248E: 88          ADC  A,B
248F: 08          EX   AF,AF'
2490: 80          ADD  A,B
2491: 04          INC  B
2492: 88          ADC  A,B
2493: 08          EX   AF,AF'
2494: 80          ADD  A,B
2495: 01 84 10    LD   BC,$1084
2498: 86          ADD  A,(HL)
2499: 03          INC  BC
249A: 85          ADD  A,L
249B: 01 80 08    LD   BC,$0880
249E: 84          ADD  A,H
249F: 06 90       LD   B,$90
24A1: 04          INC  B
24A2: 80          ADD  A,B
24A3: 02          LD   (BC),A
24A4: 85          ADD  A,L
24A5: 0A          LD   A,(BC)
24A6: 90          SUB  B
24A7: 02          LD   (BC),A
24A8: 80          ADD  A,B
24A9: 08          EX   AF,AF'
24AA: 84          ADD  A,H
24AB: 05          DEC  B
24AC: 80          ADD  A,B
24AD: 07          RLCA
24AE: 85          ADD  A,L
24AF: 01 80 04    LD   BC,$0480
24B2: 90          SUB  B
24B3: 03          INC  BC
24B4: 80          ADD  A,B
24B5: 04          INC  B
24B6: 90          SUB  B
24B7: 02          LD   (BC),A
24B8: 80          ADD  A,B
24B9: 03          INC  BC
24BA: 85          ADD  A,L
24BB: 02          LD   (BC),A
24BC: 90          SUB  B
24BD: 64          LD   H,H
24BE: 80          ADD  A,B
24BF: FF          RST  $38
24C0: 02          LD   (BC),A
24C1: 85          ADD  A,L
24C2: 02          LD   (BC),A
24C3: 80          ADD  A,B
24C4: 03          INC  BC
24C5: 84          ADD  A,H
24C6: 02          LD   (BC),A
24C7: 80          ADD  A,B
24C8: 08          EX   AF,AF'
24C9: 85          ADD  A,L
24CA: FF          RST  $38
24CB: 06 85       LD   B,$85
24CD: 14          INC  D
24CE: 80          ADD  A,B
24CF: 64          LD   H,H
24D0: 80          ADD  A,B
24D1: FF          RST  $38
24D2: 19          ADD  HL,DE
24D3: 80          ADD  A,B
24D4: 05          DEC  B
24D5: 85          ADD  A,L
24D6: 1B          DEC  DE
24D7: 80          ADD  A,B
24D8: 02          LD   (BC),A
24D9: 88          ADC  A,B
24DA: 1E 80       LD   E,$80
24DC: 08          EX   AF,AF'
24DD: 88          ADC  A,B
24DE: 03          INC  BC
24DF: 80          ADD  A,B
24E0: 07          RLCA
24E1: 87          ADD  A,A
24E2: 08          EX   AF,AF'
24E3: 84          ADD  A,H
24E4: 14          INC  D
24E5: 80          ADD  A,B
24E6: 06 85       LD   B,$85
24E8: 03          INC  BC
24E9: 84          ADD  A,H
24EA: 01 80 0A    LD   BC,$0A80
24ED: 84          ADD  A,H
24EE: FF          RST  $38
24EF: 20 80       JR   NZ,$2471
24F1: 05          DEC  B
24F2: 85          ADD  A,L
24F3: 10 80       DJNZ $2475
24F5: 04          INC  B
24F6: 84          ADD  A,H
24F7: 05          DEC  B
24F8: 85          ADD  A,L
24F9: 0A          LD   A,(BC)
24FA: 80          ADD  A,B
24FB: 0C          INC  C
24FC: 84          ADD  A,H
24FD: 07          RLCA
24FE: 85          ADD  A,L
24FF: 06 80       LD   B,$80
2501: 03          INC  BC
2502: 85          ADD  A,L
2503: 02          LD   (BC),A
2504: 84          ADD  A,H
2505: 02          LD   (BC),A
2506: 85          ADD  A,L
2507: 03          INC  BC
2508: 84          ADD  A,H
2509: 0A          LD   A,(BC)
250A: 80          ADD  A,B
250B: FF          RST  $38
250C: 04          INC  B
250D: 84          ADD  A,H
250E: 05          DEC  B
250F: 88          ADC  A,B
2510: 02          LD   (BC),A
2511: 80          ADD  A,B
2512: 04          INC  B
2513: 85          ADD  A,L
2514: 05          DEC  B
2515: 88          ADC  A,B
2516: 02          LD   (BC),A
2517: 80          ADD  A,B
2518: 02          LD   (BC),A
2519: 85          ADD  A,L
251A: 04          INC  B
251B: 88          ADC  A,B
251C: 02          LD   (BC),A
251D: 80          ADD  A,B
251E: 05          DEC  B
251F: 84          ADD  A,H
2520: FF          RST  $38
2521: 03          INC  BC
2522: 84          ADD  A,H
2523: 04          INC  B
2524: 85          ADD  A,L
2525: 04          INC  B
2526: 84          ADD  A,H
2527: 0D          DEC  C
2528: 85          ADD  A,L
2529: 07          RLCA
252A: 86          ADD  A,(HL)
252B: 05          DEC  B
252C: 84          ADD  A,H
252D: 0A          LD   A,(BC)
252E: 80          ADD  A,B
252F: FF          RST  $38
2530: 0A          LD   A,(BC)
2531: 80          ADD  A,B
2532: 01 84 02    LD   BC,$0284
2535: 85          ADD  A,L
2536: 05          DEC  B
2537: 80          ADD  A,B
2538: 01 84 03    LD   BC,$0384
253B: 85          ADD  A,L
253C: 02          LD   (BC),A
253D: 80          ADD  A,B
253E: 01 84 FF    LD   BC,$FF84
2541: 04          INC  B
2542: 84          ADD  A,H
2543: 04          INC  B
2544: 85          ADD  A,L
2545: FF          RST  $38
2546: F5          PUSH AF
2547: C5          PUSH BC
2548: DD E5       PUSH IX
254A: FD E5       PUSH IY
254C: DD 21 91 99 LD   IX,$9991
2550: FD 21 7C 25 LD   IY,$257C
2554: CD 93 12    CALL $1293
2557: DD 21 A1 CD LD   IX,$CDA1
255B: 3E 01       LD   A,$01
255D: 32 80 7C    LD   ($7C80),A
2560: DB 00       IN   A,($00)
2562: CB 5F       BIT  3,A
2564: 16 02       LD   D,$02
2566: 28 02       JR   Z,$256A
2568: 16 10       LD   D,$10
256A: CD 47 08    CALL $0847
256D: 82          ADD  A,D
256E: 27          DAA
256F: CD B4 10    CALL $10B4
2572: CD F5 10    CALL $10F5
2575: FD E1       POP  IY
2577: DD E1       POP  IX
2579: C1          POP  BC
257A: F1          POP  AF
257B: C9          RET

257C: 16 FF       LD   D,$FF
257E: 08          EX   AF,AF'
257F: 05          DEC  B
2580: 46          LD   B,(HL)
2581: 41          LD   B,C
2582: 64          LD   H,H
2583: 5A          LD   E,D
2584: 82          ADD  A,D
2585: 1E 37       LD   E,$37
2587: 46          LD   B,(HL)
2588: 05          DEC  B
2589: 82          ADD  A,D
258A: 00          NOP
258B: 5F          LD   E,A
258C: 82          ADD  A,D
258D: 82          ADD  A,D
258E: 82          ADD  A,D
258F: 87          ADD  A,A
2590: 87          ADD  A,A
2591: 87          ADD  A,A
2592: 87          ADD  A,A
2593: F5          PUSH AF
2594: D5          PUSH DE
2595: E5          PUSH HL
2596: DD E5       PUSH IX
2598: FD E5       PUSH IY
259A: 21 B8 7C    LD   HL,$7CB8
259D: 35          DEC  (HL)
259E: 20 1C       JR   NZ,$25BC
25A0: 36 05       LD   (HL),$05
25A2: 2B          DEC  HL
25A3: 35          DEC  (HL)
25A4: 28 14       JR   Z,$25BA
25A6: 2B          DEC  HL
25A7: 7E          LD   A,(HL)
25A8: EE 01       XOR  $01
25AA: 77          LD   (HL),A
25AB: 32 F2 7B    LD   ($7BF2),A
25AE: 21 E9 15    LD   HL,$15E9
25B1: DD 21 A2 9A LD   IX,$9AA2
25B5: CD 03 13    CALL $1303
25B8: 18 02       JR   $25BC
25BA: 36 01       LD   (HL),$01
25BC: 21 F5 7B    LD   HL,$7BF5
25BF: 97          SUB  A
25C0: BE          CP   (HL)
25C1: 28 03       JR   Z,$25C6
25C3: 35          DEC  (HL)
25C4: 18 33       JR   $25F9
25C6: 21 F6 7B    LD   HL,$7BF6
25C9: 97          SUB  A
25CA: 34          INC  (HL)
25CB: CB 46       BIT  0,(HL)
25CD: 28 02       JR   Z,$25D1
25CF: 3E 0B       LD   A,$0B
25D1: 32 F2 7B    LD   ($7BF2),A
25D4: 2A F7 7B    LD   HL,($7BF7)
25D7: 5E          LD   E,(HL)
25D8: 23          INC  HL
25D9: 56          LD   D,(HL)
25DA: 23          INC  HL
25DB: D5          PUSH DE
25DC: DD E1       POP  IX
25DE: 5E          LD   E,(HL)
25DF: 23          INC  HL
25E0: 56          LD   D,(HL)
25E1: 23          INC  HL
25E2: D5          PUSH DE
25E3: FD E1       POP  IY
25E5: 3A F2 7B    LD   A,($7BF2)
25E8: FE 00       CP   $00
25EA: 7E          LD   A,(HL)
25EB: 20 06       JR   NZ,$25F3
25ED: 23          INC  HL
25EE: 22 F7 7B    LD   ($7BF7),HL
25F1: 3E 05       LD   A,$05
25F3: 32 F5 7B    LD   ($7BF5),A
25F6: CD 93 12    CALL $1293
25F9: FD E1       POP  IY
25FB: DD E1       POP  IX
25FD: E1          POP  HL
25FE: D1          POP  DE
25FF: F1          POP  AF
2600: C9          RET

2601: 9F          SBC  A,A
2602: AA          XOR  D
2603: 33          INC  SP
2604: 26 32       LD   H,$32
2606: 52          LD   D,D
2607: A5          AND  L
2608: 41          LD   B,C
2609: 26 3A       LD   H,$3A
260B: A2          AND  D
260C: AA          XOR  D
260D: 6A          LD   L,D
260E: 26 2D       LD   H,$2D
2610: 53          LD   D,E
2611: A5          AND  L
2612: 8E          ADC  A,(HL)
2613: 26 1C       LD   H,$1C
2615: 9F          SBC  A,A
2616: AA          XOR  D
2617: CC 26 14    CALL Z,$1426
261A: 3F          CCF
261B: B5          OR   L
261C: DF          RST  $18
261D: 26 2A       LD   H,$2A
261F: 3F          CCF
2620: B5          OR   L
2621: E8          RET  PE

2622: 26 34       LD   H,$34
2624: 3F          CCF
2625: B5          OR   L
2626: F2 26 41    JP   P,$4126
2629: 3F          CCF
262A: B5          OR   L
262B: FB          EI
262C: 26 41       LD   H,$41
262E: 3F          CCF
262F: B5          OR   L
2630: 05          DEC  B
2631: 27          DAA
2632: FA 0D 3C    JP   M,$3C0D
2635: 14          INC  D
2636: 14          INC  D
2637: 5F          LD   E,A
2638: 82          ADD  A,D
2639: 5F          LD   E,A
263A: 23          INC  HL
263B: 14          INC  D
263C: 82          ADD  A,D
263D: 1E 37       LD   E,$37
263F: 46          LD   B,(HL)
2640: 05          DEC  B
2641: 28 3C       JR   Z,$267F
2643: 64          LD   H,H
2644: 41          LD   B,C
2645: 0A          LD   A,(BC)
2646: 23          INC  HL
2647: 82          ADD  A,D
2648: 00          NOP
2649: 37          SCF
264A: 37          SCF
264B: 82          ADD  A,D
264C: 5F          LD   E,A
264D: 23          INC  HL
264E: 14          INC  D
264F: 82          ADD  A,D
2650: 5A          LD   E,D
2651: 41          LD   B,C
2652: 00          NOP
2653: 0A          LD   A,(BC)
2654: 32 5A FF    LD   ($FF5A),A
2657: 80          ADD  A,B
2658: 5F          LD   E,A
2659: 46          LD   B,(HL)
265A: 82          ADD  A,D
265B: 0A          LD   A,(BC)
265C: 37          SCF
265D: 14          INC  D
265E: 00          NOP
265F: 55          LD   D,L
2660: 82          ADD  A,D
2661: 5F          LD   E,A
2662: 23          INC  HL
2663: 14          INC  D
2664: 82          ADD  A,D
2665: 37          SCF
2666: 14          INC  D
2667: 69          LD   L,C
2668: 14          INC  D
2669: 37          SCF
266A: 23          INC  HL
266B: 4B          LD   C,E
266C: 64          LD   H,H
266D: 5A          LD   E,D
266E: 23          INC  HL
266F: 82          ADD  A,D
2670: 0A          LD   A,(BC)
2671: 00          NOP
2672: 37          SCF
2673: 37          SCF
2674: 82          ADD  A,D
2675: 05          DEC  B
2676: 64          LD   H,H
2677: 5F          LD   E,A
2678: 5F          LD   E,A
2679: 46          LD   B,(HL)
267A: 41          LD   B,C
267B: FF          RST  $38
267C: 80          ADD  A,B
267D: 5F          LD   E,A
267E: 46          LD   B,(HL)
267F: 82          ADD  A,D
2680: 55          LD   D,L
2681: 28 0F       JR   Z,$2692
2683: 14          INC  D
2684: 82          ADD  A,D
2685: 14          INC  D
2686: 37          SCF
2687: 14          INC  D
2688: 69          LD   L,C
2689: 00          NOP
268A: 5F          LD   E,A
268B: 46          LD   B,(HL)
268C: 55          LD   D,L
268D: 5A          LD   E,D
268E: 3D          DEC  A
268F: 64          LD   H,H
2690: 5A          LD   E,D
2691: 14          INC  D
2692: 82          ADD  A,D
2693: 14          INC  D
2694: 41          LD   B,C
2695: 14          INC  D
2696: 55          LD   D,L
2697: 1E 78       LD   E,$78
2699: 82          ADD  A,D
269A: 5F          LD   E,A
269B: 46          LD   B,(HL)
269C: 82          ADD  A,D
269D: 5A          LD   E,D
269E: 5F          LD   E,A
269F: 28 0A       JR   Z,$26AB
26A1: 32 82 FF    LD   ($FF82),A
26A4: 80          ADD  A,B
26A5: 5F          LD   E,A
26A6: 46          LD   B,(HL)
26A7: 82          ADD  A,D
26A8: 0A          LD   A,(BC)
26A9: 14          INC  D
26AA: 28 37       JR   Z,$26E3
26AC: 28 41       JR   Z,$26EF
26AE: 1E 82       LD   E,$82
26B0: 00          NOP
26B1: 41          LD   B,C
26B2: 0F          RRCA
26B3: 82          ADD  A,D
26B4: 0F          RRCA
26B5: 55          LD   D,L
26B6: 46          LD   B,(HL)
26B7: 4B          LD   C,E
26B8: 82          ADD  A,D
26B9: FF          RST  $38
26BA: 80          ADD  A,B
26BB: 0F          RRCA
26BC: 46          LD   B,(HL)
26BD: 6E          LD   L,(HL)
26BE: 41          LD   B,C
26BF: 82          ADD  A,D
26C0: 46          LD   B,(HL)
26C1: 41          LD   B,C
26C2: 5F          LD   E,A
26C3: 46          LD   B,(HL)
26C4: 82          ADD  A,D
26C5: 5F          LD   E,A
26C6: 23          INC  HL
26C7: 14          INC  D
26C8: 82          ADD  A,D
26C9: 3C          INC  A
26CA: 46          LD   B,(HL)
26CB: 05          DEC  B
26CC: 12          LD   (DE),A
26CD: 05          DEC  B
26CE: 14          INC  D
26CF: 6E          LD   L,(HL)
26D0: 00          NOP
26D1: 55          LD   D,L
26D2: 14          INC  D
26D3: 82          ADD  A,D
26D4: 46          LD   B,(HL)
26D5: 19          ADD  HL,DE
26D6: 82          ADD  A,D
26D7: 5F          LD   E,A
26D8: 23          INC  HL
26D9: 14          INC  D
26DA: 82          ADD  A,D
26DB: 3C          INC  A
26DC: 46          LD   B,(HL)
26DD: 05          DEC  B
26DE: E1          POP  HL
26DF: 08          EX   AF,AF'
26E0: BE          CP   (HL)
26E1: BE          CP   (HL)
26E2: BE          CP   (HL)
26E3: 1E 00       LD   E,$00
26E5: 5F          LD   E,A
26E6: 46          LD   B,(HL)
26E7: 55          LD   D,L
26E8: 09          ADD  HL,BC
26E9: BE          CP   (HL)
26EA: BE          CP   (HL)
26EB: BE          CP   (HL)
26EC: 19          ADD  HL,DE
26ED: 55          LD   D,L
26EE: 46          LD   B,(HL)
26EF: 1E 1E       LD   E,$1E
26F1: 78          LD   A,B
26F2: 08          EX   AF,AF'
26F3: BE          CP   (HL)
26F4: BE          CP   (HL)
26F5: BE          CP   (HL)
26F6: 05          DEC  B
26F7: 64          LD   H,H
26F8: 41          LD   B,C
26F9: 41          LD   B,C
26FA: 78          LD   A,B
26FB: 09          ADD  HL,BC
26FC: BE          CP   (HL)
26FD: BE          CP   (HL)
26FE: BE          CP   (HL)
26FF: 3C          INC  A
2700: 46          LD   B,(HL)
2701: 41          LD   B,C
2702: 32 14 78    LD   ($7814),A
2705: 09          ADD  HL,BC
2706: BE          CP   (HL)
2707: BE          CP   (HL)
2708: BE          CP   (HL)
2709: 4B          LD   C,E
270A: 46          LD   B,(HL)
270B: 55          LD   D,L
270C: 32 14 55    LD   ($5514),A
270F: 97          SUB  A
2710: CD 45 12    CALL $1245
2713: 32 A2 78    LD   ($78A2),A
2716: 32 89 7C    LD   ($7C89),A
2719: 06 C9       LD   B,$C9
271B: 21 99 79    LD   HL,$7999
271E: 77          LD   (HL),A
271F: 23          INC  HL
2720: 10 FC       DJNZ $271E
2722: 06 0A       LD   B,$0A
2724: 21 6D 7D    LD   HL,$7D6D
2727: 77          LD   (HL),A
2728: 23          INC  HL
2729: 10 FC       DJNZ $2727
272B: 21 B6 7C    LD   HL,$7CB6
272E: 77          LD   (HL),A
272F: 23          INC  HL
2730: 36 0D       LD   (HL),$0D
2732: 23          INC  HL
2733: 36 68       LD   (HL),$68
2735: 3A B4 7C    LD   A,($7CB4)
2738: FE 01       CP   $01
273A: 20 13       JR   NZ,$274F
273C: 97          SUB  A
273D: 32 F6 7B    LD   ($7BF6),A
2740: 3E 05       LD   A,$05
2742: 32 F5 7B    LD   ($7BF5),A
2745: 21 01 26    LD   HL,$2601
2748: 22 F7 7B    LD   ($7BF7),HL
274B: 3E 19       LD   A,$19
274D: 18 1F       JR   $276E
274F: 3A 64 7D    LD   A,($7D64)
2752: FE 01       CP   $01
2754: 21 7F 7D    LD   HL,$7D7F
2757: 11 91 7D    LD   DE,$7D91
275A: 28 06       JR   Z,$2762
275C: 21 80 7D    LD   HL,$7D80
275F: 11 94 7D    LD   DE,$7D94
2762: 7E          LD   A,(HL)
2763: 32 81 7D    LD   ($7D81),A
2766: 1A          LD   A,(DE)
2767: FE 19       CP   $19
2769: 20 03       JR   NZ,$276E
276B: 3E 01       LD   A,$01
276D: 12          LD   (DE),A
276E: 11 2B 6E    LD   DE,$6E2B
2771: 26 00       LD   H,$00
2773: 3D          DEC  A
2774: 07          RLCA
2775: 6F          LD   L,A
2776: 19          ADD  HL,DE
2777: 7E          LD   A,(HL)
2778: 23          INC  HL
2779: 66          LD   H,(HL)
277A: 6F          LD   L,A
277B: 11 82 7C    LD   DE,$7C82
277E: 7E          LD   A,(HL)
277F: 12          LD   (DE),A
2780: 47          LD   B,A
2781: 23          INC  HL
2782: 13          INC  DE
2783: 7E          LD   A,(HL)
2784: 12          LD   (DE),A
2785: E6 0F       AND  $0F
2787: 32 58 7C    LD   ($7C58),A
278A: 4F          LD   C,A
278B: 78          LD   A,B
278C: E6 F0       AND  $F0
278E: B1          OR   C
278F: 13          INC  DE
2790: 12          LD   (DE),A
2791: 07          RLCA
2792: 07          RLCA
2793: 07          RLCA
2794: 07          RLCA
2795: 13          INC  DE
2796: 12          LD   (DE),A
2797: 78          LD   A,B
2798: E6 0F       AND  $0F
279A: 32 59 7C    LD   ($7C59),A
279D: CD 20 2B    CALL $2B20
27A0: D3 00       OUT  ($00),A
27A2: 23          INC  HL
27A3: 7E          LD   A,(HL)
27A4: 32 63 79    LD   ($7963),A
27A7: E5          PUSH HL
27A8: 21 BC 29    LD   HL,$29BC
27AB: 3D          DEC  A
27AC: 07          RLCA
27AD: 16 00       LD   D,$00
27AF: 5F          LD   E,A
27B0: 19          ADD  HL,DE
27B1: 5E          LD   E,(HL)
27B2: 23          INC  HL
27B3: 56          LD   D,(HL)
27B4: ED 53 5F 79 LD   ($795F),DE
27B8: D1          POP  DE
27B9: 21 0B 80    LD   HL,$800B
27BC: 22 5D 79    LD   ($795D),HL
27BF: 06 06       LD   B,$06
27C1: D5          PUSH DE
27C2: 3E 06       LD   A,$06
27C4: 90          SUB  B
27C5: 5F          LD   E,A
27C6: 07          RLCA
27C7: 83          ADD  A,E
27C8: 07          RLCA
27C9: 83          ADD  A,E
27CA: 07          RLCA
27CB: 16 00       LD   D,$00
27CD: 5F          LD   E,A
27CE: 21 B1 78    LD   HL,$78B1
27D1: 19          ADD  HL,DE
27D2: 36 06       LD   (HL),$06
27D4: 23          INC  HL
27D5: 22 59 79    LD   ($7959),HL
27D8: 21 05 79    LD   HL,$7905
27DB: 19          ADD  HL,DE
27DC: 36 D8       LD   (HL),$D8
27DE: 23          INC  HL
27DF: 22 5B 79    LD   ($795B),HL
27E2: D1          POP  DE
27E3: 13          INC  DE
27E4: 1A          LD   A,(DE)
27E5: D5          PUSH DE
27E6: 21 45 2A    LD   HL,$2A45
27E9: 0E 01       LD   C,$01
27EB: CD D4 29    CALL $29D4
27EE: D1          POP  DE
27EF: 13          INC  DE
27F0: 1A          LD   A,(DE)
27F1: D5          PUSH DE
27F2: 21 4B 2A    LD   HL,$2A4B
27F5: 0E 02       LD   C,$02
27F7: CD D4 29    CALL $29D4
27FA: 3E FF       LD   A,$FF
27FC: 2A 59 79    LD   HL,($7959)
27FF: 77          LD   (HL),A
2800: 2A 5B 79    LD   HL,($795B)
2803: 77          LD   (HL),A
2804: 2A 5D 79    LD   HL,($795D)
2807: 11 10 00    LD   DE,$0010
280A: 19          ADD  HL,DE
280B: 22 5D 79    LD   ($795D),HL
280E: D1          POP  DE
280F: 10 B0       DJNZ $27C1
2811: 3A 8C 7C    LD   A,($7C8C)
2814: FE 01       CP   $01
2816: 28 2D       JR   Z,$2845
2818: D5          PUSH DE
2819: 21 A1 B5    LD   HL,$B5A1
281C: ED 5B 5F 79 LD   DE,($795F)
2820: 13          INC  DE
2821: CD 84 30    CALL $3084
2824: 3E 07       LD   A,$07
2826: 32 F2 7B    LD   ($7BF2),A
2829: 3A 63 79    LD   A,($7963)
282C: FE 0A       CP   $0A
282E: 38 02       JR   C,$2832
2830: C6 06       ADD  A,$06
2832: C6 09       ADD  A,$09
2834: 27          DAA
2835: DD 21 40 C0 LD   IX,$C040
2839: CD B4 10    CALL $10B4
283C: CD F5 10    CALL $10F5
283F: 2E 00       LD   L,$00
2841: CD 00 11    CALL $1100
2844: D1          POP  DE
2845: 21 0A 78    LD   HL,$780A
2848: 06 08       LD   B,$08
284A: 13          INC  DE
284B: 1A          LD   A,(DE)
284C: 77          LD   (HL),A
284D: 23          INC  HL
284E: 13          INC  DE
284F: 1A          LD   A,(DE)
2850: 77          LD   (HL),A
2851: D5          PUSH DE
2852: 11 07 00    LD   DE,$0007
2855: 19          ADD  HL,DE
2856: D1          POP  DE
2857: 36 00       LD   (HL),$00
2859: 23          INC  HL
285A: 23          INC  HL
285B: 10 ED       DJNZ $284A
285D: 21 0B 80    LD   HL,$800B
2860: 22 5D 79    LD   ($795D),HL
2863: 06 06       LD   B,$06
2865: C5          PUSH BC
2866: D5          PUSH DE
2867: D3 00       OUT  ($00),A
2869: 3E 06       LD   A,$06
286B: 90          SUB  B
286C: 5F          LD   E,A
286D: 07          RLCA
286E: 07          RLCA
286F: 07          RLCA
2870: 07          RLCA
2871: 07          RLCA
2872: 83          ADD  A,E
2873: 16 00       LD   D,$00
2875: 5F          LD   E,A
2876: 3A 64 7D    LD   A,($7D64)
2879: FE 01       CP   $01
287B: 21 62 7A    LD   HL,$7A62
287E: 28 03       JR   Z,$2883
2880: 21 28 7B    LD   HL,$7B28
2883: 19          ADD  HL,DE
2884: 22 EE 7B    LD   ($7BEE),HL
2887: 21 9C 79    LD   HL,$799C
288A: 19          ADD  HL,DE
288B: D1          POP  DE
288C: 13          INC  DE
288D: 1A          LD   A,(DE)
288E: 01 AC 29    LD   BC,$29AC
2891: CD 5C 29    CALL $295C
2894: 13          INC  DE
2895: 1A          LD   A,(DE)
2896: 01 B4 29    LD   BC,$29B4
2899: CD 5C 29    CALL $295C
289C: 36 FF       LD   (HL),$FF
289E: 2A 5D 79    LD   HL,($795D)
28A1: 01 10 00    LD   BC,$0010
28A4: 09          ADD  HL,BC
28A5: 22 5D 79    LD   ($795D),HL
28A8: C1          POP  BC
28A9: 10 BA       DJNZ $2865
28AB: 62          LD   H,D
28AC: 6B          LD   L,E
28AD: 23          INC  HL
28AE: 7E          LD   A,(HL)
28AF: 32 86 7C    LD   ($7C86),A
28B2: CD 51 2A    CALL $2A51
28B5: 11 DA 42    LD   DE,$42DA
28B8: 21 C3 83    LD   HL,$83C3
28BB: CD 84 30    CALL $3084
28BE: 21 88 2B    LD   HL,$2B88
28C1: 11 00 78    LD   DE,$7800
28C4: 06 0A       LD   B,$0A
28C6: 7E          LD   A,(HL)
28C7: 12          LD   (DE),A
28C8: 13          INC  DE
28C9: 23          INC  HL
28CA: 10 FA       DJNZ $28C6
28CC: 3A 8C 7C    LD   A,($7C8C)
28CF: FE 01       CP   $01
28D1: 20 05       JR   NZ,$28D8
28D3: 3A 86 7D    LD   A,($7D86)
28D6: 18 13       JR   $28EB
28D8: 3A 64 7D    LD   A,($7D64)
28DB: FE 01       CP   $01
28DD: 3A 86 7D    LD   A,($7D86)
28E0: 28 03       JR   Z,$28E5
28E2: 3A 87 7D    LD   A,($7D87)
28E5: FE 10       CP   $10
28E7: 38 02       JR   C,$28EB
28E9: 3E 0F       LD   A,$0F
28EB: 11 70 74    LD   DE,$7470
28EE: 26 00       LD   H,$00
28F0: 3D          DEC  A
28F1: 07          RLCA
28F2: 6F          LD   L,A
28F3: 19          ADD  HL,DE
28F4: 5E          LD   E,(HL)
28F5: 23          INC  HL
28F6: 56          LD   D,(HL)
28F7: 1A          LD   A,(DE)
28F8: 32 88 7C    LD   ($7C88),A
28FB: 13          INC  DE
28FC: 1A          LD   A,(DE)
28FD: 13          INC  DE
28FE: 32 7C 7D    LD   ($7D7C),A
2901: 32 7D 7D    LD   ($7D7D),A
2904: 1A          LD   A,(DE)
2905: 13          INC  DE
2906: 32 7E 7D    LD   ($7D7E),A
2909: 06 08       LD   B,$08
290B: 21 71 79    LD   HL,$7971
290E: C5          PUSH BC
290F: 01 08 00    LD   BC,$0008
2912: 1A          LD   A,(DE)
2913: 77          LD   (HL),A
2914: 13          INC  DE
2915: 09          ADD  HL,BC
2916: 1A          LD   A,(DE)
2917: 77          LD   (HL),A
2918: 13          INC  DE
2919: 09          ADD  HL,BC
291A: 1A          LD   A,(DE)
291B: 77          LD   (HL),A
291C: 13          INC  DE
291D: 09          ADD  HL,BC
291E: 1A          LD   A,(DE)
291F: 77          LD   (HL),A
2920: 09          ADD  HL,BC
2921: 77          LD   (HL),A
2922: 01 E1 FF    LD   BC,$FFE1
2925: 13          INC  DE
2926: 09          ADD  HL,BC
2927: C1          POP  BC
2928: 10 E4       DJNZ $290E
292A: 3A 8C 7C    LD   A,($7C8C)
292D: FE 01       CP   $01
292F: 28 22       JR   Z,$2953
2931: CD 8E 19    CALL $198E
2934: 3A 66 7D    LD   A,($7D66)
2937: FE 02       CP   $02
2939: 20 0F       JR   NZ,$294A
293B: 3E 01       LD   A,$01
293D: 32 67 7D    LD   ($7D67),A
2940: CD 3F 18    CALL $183F
2943: CD D5 19    CALL $19D5
2946: 97          SUB  A
2947: 32 67 7D    LD   ($7D67),A
294A: CD 3F 18    CALL $183F
294D: CD D5 19    CALL $19D5
2950: CD 5C 1A    CALL $1A5C
2953: CD 3B 09    CALL $093B
2956: 3E FF       LD   A,$FF
2958: 32 62 7D    LD   ($7D62),A
295B: C9          RET

295C: D5          PUSH DE
295D: 50          LD   D,B
295E: 59          LD   E,C
295F: 06 08       LD   B,$08
2961: 0F          RRCA
2962: 30 43       JR   NC,$29A7
2964: F5          PUSH AF
2965: 3A 81 7D    LD   A,($7D81)
2968: FE 01       CP   $01
296A: 28 15       JR   Z,$2981
296C: E5          PUSH HL
296D: 2A EE 7B    LD   HL,($7BEE)
2970: 7E          LD   A,(HL)
2971: 23          INC  HL
2972: 23          INC  HL
2973: 22 EE 7B    LD   ($7BEE),HL
2976: E1          POP  HL
2977: FE 00       CP   $00
2979: 20 06       JR   NZ,$2981
297B: 77          LD   (HL),A
297C: 23          INC  HL
297D: 77          LD   (HL),A
297E: 23          INC  HL
297F: 18 25       JR   $29A6
2981: 36 01       LD   (HL),$01
2983: 23          INC  HL
2984: 1A          LD   A,(DE)
2985: 77          LD   (HL),A
2986: 23          INC  HL
2987: D5          PUSH DE
2988: E5          PUSH HL
2989: ED 5B 5F 79 LD   DE,($795F)
298D: 6F          LD   L,A
298E: 1A          LD   A,(DE)
298F: 13          INC  DE
2990: D5          PUSH DE
2991: 85          ADD  A,L
2992: 16 00       LD   D,$00
2994: 5F          LD   E,A
2995: CD 37 11    CALL $1137
2998: 2A 5D 79    LD   HL,($795D)
299B: 19          ADD  HL,DE
299C: D1          POP  DE
299D: CD 84 30    CALL $3084
29A0: 21 9B 79    LD   HL,$799B
29A3: 34          INC  (HL)
29A4: E1          POP  HL
29A5: D1          POP  DE
29A6: F1          POP  AF
29A7: 13          INC  DE
29A8: 10 B7       DJNZ $2961
29AA: D1          POP  DE
29AB: C9          RET

29AC: 06 15       LD   B,$15
29AE: 24          INC  H
29AF: 33          INC  SP
29B0: 42          LD   B,D
29B1: 51          LD   D,C
29B2: 60          LD   H,B
29B3: 6F          LD   L,A
29B4: 76          HALT
29B5: 7E          LD   A,(HL)
29B6: 8D          ADC  A,L
29B7: 9C          SBC  A,H
29B8: AB          XOR  E
29B9: BA          CP   D
29BA: C9          RET

29BB: D8          RET  C

29BC: B6          OR   (HL)
29BD: 58          LD   E,B
29BE: 96          SUB  (HL)
29BF: 5A          LD   E,D
29C0: 74          LD   (HL),H
29C1: 58          LD   E,B
29C2: 54          LD   D,H
29C3: 5A          LD   E,D
29C4: 57          LD   D,A
29C5: 59          LD   E,C
29C6: 3D          DEC  A
29C7: 58          LD   E,B
29C8: 30 59       JR   NC,$2A23
29CA: BC          CP   H
29CB: 59          LD   E,C
29CC: F7          RST  $30
29CD: 59          LD   E,C
29CE: E6 57       AND  $57
29D0: E6 5A       AND  $5A
29D2: 06 59       LD   B,$59
29D4: C5          PUSH BC
29D5: CB 7F       BIT  7,A
29D7: 11 6E 56    LD   DE,$566E
29DA: C4 20 2A    CALL NZ,$2A20
29DD: CB 77       BIT  6,A
29DF: 11 13 57    LD   DE,$5713
29E2: C4 20 2A    CALL NZ,$2A20
29E5: 06 06       LD   B,$06
29E7: 0F          RRCA
29E8: 30 31       JR   NC,$2A1B
29EA: F5          PUSH AF
29EB: 16 00       LD   D,$00
29ED: 5E          LD   E,(HL)
29EE: 08          EX   AF,AF'
29EF: 7B          LD   A,E
29F0: 08          EX   AF,AF'
29F1: 1D          DEC  E
29F2: CD 37 11    CALL $1137
29F5: E5          PUSH HL
29F6: 2A 5D 79    LD   HL,($795D)
29F9: 19          ADD  HL,DE
29FA: C5          PUSH BC
29FB: 01 02 0F    LD   BC,$0F02
29FE: 3A 82 7C    LD   A,($7C82)
2A01: CD 4F 11    CALL $114F
2A04: C1          POP  BC
2A05: 2A 59 79    LD   HL,($7959)
2A08: 08          EX   AF,AF'
2A09: 77          LD   (HL),A
2A0A: 23          INC  HL
2A0B: 22 59 79    LD   ($7959),HL
2A0E: 2A 5B 79    LD   HL,($795B)
2A11: D6 0F       SUB  $0F
2A13: 77          LD   (HL),A
2A14: 23          INC  HL
2A15: 22 5B 79    LD   ($795B),HL
2A18: 08          EX   AF,AF'
2A19: E1          POP  HL
2A1A: F1          POP  AF
2A1B: 23          INC  HL
2A1C: 10 C9       DJNZ $29E7
2A1E: C1          POP  BC
2A1F: C9          RET

2A20: F5          PUSH AF
2A21: C5          PUSH BC
2A22: E5          PUSH HL
2A23: D5          PUSH DE
2A24: 11 30 03    LD   DE,$0330
2A27: 79          LD   A,C
2A28: FE 01       CP   $01
2A2A: 28 03       JR   Z,$2A2F
2A2C: 11 50 6B    LD   DE,$6B50
2A2F: 2A 5D 79    LD   HL,($795D)
2A32: 19          ADD  HL,DE
2A33: E5          PUSH HL
2A34: DD E1       POP  IX
2A36: E1          POP  HL
2A37: 0E 1D       LD   C,$1D
2A39: 3E 0F       LD   A,$0F
2A3B: 32 52 7C    LD   ($7C52),A
2A3E: CD 56 1B    CALL $1B56
2A41: E1          POP  HL
2A42: C1          POP  BC
2A43: F1          POP  AF
2A44: C9          RET

2A45: 24          INC  H
2A46: 33          INC  SP
2A47: 42          LD   B,D
2A48: 51          LD   D,C
2A49: 60          LD   H,B
2A4A: 6F          LD   L,A
2A4B: 7E          LD   A,(HL)
2A4C: 8D          ADC  A,L
2A4D: 9C          SBC  A,H
2A4E: AB          XOR  E
2A4F: BA          CP   D
2A50: C9          RET

2A51: 06 05       LD   B,$05
2A53: 07          RLCA
2A54: D2 02 2B    JP   NC,$2B02
2A57: F5          PUSH AF
2A58: C5          PUSH BC
2A59: E5          PUSH HL
2A5A: CD 16 35    CALL $3516
2A5D: D1          POP  DE
2A5E: 97          SUB  A
2A5F: 77          LD   (HL),A
2A60: 23          INC  HL
2A61: 77          LD   (HL),A
2A62: 23          INC  HL
2A63: 13          INC  DE
2A64: 1A          LD   A,(DE)
2A65: 3D          DEC  A
2A66: 06 10       LD   B,$10
2A68: D5          PUSH DE
2A69: CD 2B 11    CALL $112B
2A6C: 7B          LD   A,E
2A6D: D1          POP  DE
2A6E: C6 0B       ADD  A,$0B
2A70: 32 A6 78    LD   ($78A6),A
2A73: 77          LD   (HL),A
2A74: 13          INC  DE
2A75: 23          INC  HL
2A76: 23          INC  HL
2A77: 1A          LD   A,(DE)
2A78: 32 AD 78    LD   ($78AD),A
2A7B: 77          LD   (HL),A
2A7C: 13          INC  DE
2A7D: 23          INC  HL
2A7E: 1A          LD   A,(DE)
2A7F: 32 AE 78    LD   ($78AE),A
2A82: 77          LD   (HL),A
2A83: 13          INC  DE
2A84: 23          INC  HL
2A85: 1A          LD   A,(DE)
2A86: 32 AF 78    LD   ($78AF),A
2A89: 77          LD   (HL),A
2A8A: 13          INC  DE
2A8B: 23          INC  HL
2A8C: 1A          LD   A,(DE)
2A8D: 32 B0 78    LD   ($78B0),A
2A90: 77          LD   (HL),A
2A91: C1          POP  BC
2A92: C5          PUSH BC
2A93: D5          PUSH DE
2A94: 58          LD   E,B
2A95: 16 00       LD   D,$00
2A97: 21 06 2B    LD   HL,$2B06
2A9A: 19          ADD  HL,DE
2A9B: 5E          LD   E,(HL)
2A9C: CD 37 11    CALL $1137
2A9F: D5          PUSH DE
2AA0: 21 00 80    LD   HL,$8000
2AA3: 19          ADD  HL,DE
2AA4: 3A AD 78    LD   A,($78AD)
2AA7: 5F          LD   E,A
2AA8: 3A AE 78    LD   A,($78AE)
2AAB: 93          SUB  E
2AAC: C6 0F       ADD  A,$0F
2AAE: 16 00       LD   D,$00
2AB0: 19          ADD  HL,DE
2AB1: 47          LD   B,A
2AB2: 0E 01       LD   C,$01
2AB4: 3E FF       LD   A,$FF
2AB6: CD 4F 11    CALL $114F
2AB9: 11 90 F8    LD   DE,$F890
2ABC: 19          ADD  HL,DE
2ABD: CD 4F 11    CALL $114F
2AC0: D1          POP  DE
2AC1: 21 53 73    LD   HL,$7353
2AC4: 19          ADD  HL,DE
2AC5: 3A AF 78    LD   A,($78AF)
2AC8: CD 0C 2B    CALL $2B0C
2ACB: 11 90 0F    LD   DE,$0F90
2ACE: 19          ADD  HL,DE
2ACF: 3A B0 78    LD   A,($78B0)
2AD2: CD 0C 2B    CALL $2B0C
2AD5: 11 75 F5    LD   DE,$F575
2AD8: 19          ADD  HL,DE
2AD9: 16 00       LD   D,$00
2ADB: 3A A6 78    LD   A,($78A6)
2ADE: 5F          LD   E,A
2ADF: 19          ADD  HL,DE
2AE0: 01 02 0F    LD   BC,$0F02
2AE3: 3E EE       LD   A,$EE
2AE5: CD 4F 11    CALL $114F
2AE8: 01 0D 01    LD   BC,$010D
2AEB: CD 4F 11    CALL $114F
2AEE: 11 0E 00    LD   DE,$000E
2AF1: 19          ADD  HL,DE
2AF2: CD 4F 11    CALL $114F
2AF5: 01 02 0F    LD   BC,$0F02
2AF8: 11 CA 05    LD   DE,$05CA
2AFB: 19          ADD  HL,DE
2AFC: CD 4F 11    CALL $114F
2AFF: E1          POP  HL
2B00: C1          POP  BC
2B01: F1          POP  AF
2B02: 05          DEC  B
2B03: C2 53 2A    JP   NZ,$2A53
2B06: C9          RET

2B07: D7          RST  $10
2B08: AA          XOR  D
2B09: 7D          LD   A,L
2B0A: 50          LD   D,B
2B0B: 23          INC  HL
2B0C: 06 06       LD   B,$06
2B0E: 0F          RRCA
2B0F: CB 47       BIT  0,A
2B11: 28 06       JR   Z,$2B19
2B13: 11 5D 56    LD   DE,$565D
2B16: CD 84 30    CALL $3084
2B19: 11 10 00    LD   DE,$0010
2B1C: 19          ADD  HL,DE
2B1D: 10 EF       DJNZ $2B0E
2B1F: C9          RET

2B20: E5          PUSH HL
2B21: 21 46 2B    LD   HL,$2B46
2B24: 7E          LD   A,(HL)
2B25: FE FF       CP   $FF
2B27: 28 1B       JR   Z,$2B44
2B29: 4F          LD   C,A
2B2A: 23          INC  HL
2B2B: 46          LD   B,(HL)
2B2C: 23          INC  HL
2B2D: 5E          LD   E,(HL)
2B2E: 23          INC  HL
2B2F: 56          LD   D,(HL)
2B30: 23          INC  HL
2B31: 7E          LD   A,(HL)
2B32: 23          INC  HL
2B33: E5          PUSH HL
2B34: D5          PUSH DE
2B35: 21 82 7C    LD   HL,$7C82
2B38: 16 00       LD   D,$00
2B3A: 5F          LD   E,A
2B3B: 19          ADD  HL,DE
2B3C: 7E          LD   A,(HL)
2B3D: E1          POP  HL
2B3E: CD 4F 11    CALL $114F
2B41: E1          POP  HL
2B42: 18 E0       JR   $2B24
2B44: E1          POP  HL
2B45: C9          RET

2B46: 04          INC  B
2B47: 63          LD   H,E
2B48: 19          ADD  HL,DE
2B49: 81          ADD  A,C
2B4A: 00          NOP
2B4B: 04          INC  B
2B4C: 63          LD   H,E
2B4D: C1          POP  BC
2B4E: FA 00 E7    JP   M,$E700
2B51: 01 02 82    LD   BC,$8202
2B54: 03          INC  BC
2B55: E7          RST  $20
2B56: 01 A2 81    LD   BC,$81A2
2B59: 02          LD   (BC),A
2B5A: 02          LD   (BC),A
2B5B: 61          LD   H,C
2B5C: A2          AND  D
2B5D: 81          ADD  A,C
2B5E: 01 02 61    LD   BC,$6102
2B61: 4A          LD   C,D
2B62: FB          EI
2B63: 01 E7 01    LD   BC,$01E7
2B66: 03          INC  BC
2B67: 82          ADD  A,D
2B68: 02          LD   (BC),A
2B69: E7          RST  $20
2B6A: 01 A1 81    LD   BC,$81A1
2B6D: 03          INC  BC
2B6E: E1          POP  HL
2B6F: 01 4A 83    LD   BC,$834A
2B72: 00          NOP
2B73: E1          POP  HL
2B74: 01 5A 83    LD   BC,$835A
2B77: 00          NOP
2B78: E1          POP  HL
2B79: 01 6A 83    LD   BC,$836A
2B7C: 00          NOP
2B7D: E1          POP  HL
2B7E: 01 7A 83    LD   BC,$837A
2B81: 00          NOP
2B82: E1          POP  HL
2B83: 01 8A 83    LD   BC,$838A
2B86: 00          NOP
2B87: FF          RST  $38
2B88: 06 0B       LD   B,$0B
2B8A: 3B          DEC  SP
2B8B: 83          ADD  A,E
2B8C: DA 42 9F    JP   C,$9F42
2B8F: 3D          DEC  A
2B90: 80          ADD  A,B
2B91: 00          NOP
2B92: F5          PUSH AF
2B93: C5          PUSH BC
2B94: D5          PUSH DE
2B95: E5          PUSH HL
2B96: E5          PUSH HL
2B97: 46          LD   B,(HL)
2B98: 23          INC  HL
2B99: 7E          LD   A,(HL)
2B9A: E6 F0       AND  $F0
2B9C: F6 0B       OR   $0B
2B9E: 77          LD   (HL),A
2B9F: E5          PUSH HL
2BA0: 21 00 80    LD   HL,$8000
2BA3: 16 00       LD   D,$00
2BA5: 5F          LD   E,A
2BA6: 19          ADD  HL,DE
2BA7: 58          LD   E,B
2BA8: CD 37 11    CALL $1137
2BAB: 19          ADD  HL,DE
2BAC: EB          EX   DE,HL
2BAD: E1          POP  HL
2BAE: 23          INC  HL
2BAF: 73          LD   (HL),E
2BB0: 23          INC  HL
2BB1: 72          LD   (HL),D
2BB2: E5          PUSH HL
2BB3: 21 E6 2B    LD   HL,$2BE6
2BB6: 3A A1 78    LD   A,($78A1)
2BB9: 3D          DEC  A
2BBA: 07          RLCA
2BBB: 16 00       LD   D,$00
2BBD: 5F          LD   E,A
2BBE: 19          ADD  HL,DE
2BBF: 5E          LD   E,(HL)
2BC0: 23          INC  HL
2BC1: 56          LD   D,(HL)
2BC2: E1          POP  HL
2BC3: 23          INC  HL
2BC4: 73          LD   (HL),E
2BC5: 23          INC  HL
2BC6: 72          LD   (HL),D
2BC7: E5          PUSH HL
2BC8: 21 F0 2B    LD   HL,$2BF0
2BCB: 16 00       LD   D,$00
2BCD: 5F          LD   E,A
2BCE: 19          ADD  HL,DE
2BCF: 5E          LD   E,(HL)
2BD0: 23          INC  HL
2BD1: 56          LD   D,(HL)
2BD2: E1          POP  HL
2BD3: 23          INC  HL
2BD4: 73          LD   (HL),E
2BD5: 23          INC  HL
2BD6: 72          LD   (HL),D
2BD7: 23          INC  HL
2BD8: 36 A0       LD   (HL),$A0
2BDA: 23          INC  HL
2BDB: 36 00       LD   (HL),$00
2BDD: E1          POP  HL
2BDE: CD 34 30    CALL $3034
2BE1: E1          POP  HL
2BE2: D1          POP  DE
2BE3: C1          POP  BC
2BE4: F1          POP  AF
2BE5: C9          RET

2BE6: 69          LD   L,C
2BE7: 4C          LD   C,H
2BE8: A5          AND  L
2BE9: 51          LD   D,C
2BEA: 44          LD   B,H
2BEB: 5B          LD   E,E
2BEC: 5C          LD   E,H
2BED: 62          LD   H,D
2BEE: AC          XOR  H
2BEF: 68          LD   L,B
2BF0: CC 37 B9    CALL Z,$B937
2BF3: 38 EF       JR   C,$2BE4
2BF5: 39          ADD  HL,SP
2BF6: 26 3B       LD   H,$3B
2BF8: 66          LD   H,(HL)
2BF9: 3C          INC  A
2BFA: 21 0A 77    LD   HL,$770A
2BFD: 22 7D 7C    LD   ($7C7D),HL
2C00: 3A 9A 79    LD   A,($799A)
2C03: 3C          INC  A
2C04: E6 03       AND  $03
2C06: 32 9A 79    LD   ($799A),A
2C09: CD E9 2F    CALL $2FE9
2C0C: 3A B4 7C    LD   A,($7CB4)
2C0F: FE 01       CP   $01
2C11: 20 03       JR   NZ,$2C16
2C13: CD 93 25    CALL $2593
2C16: 3A 88 7C    LD   A,($7C88)
2C19: 32 87 7C    LD   ($7C87),A
2C1C: 21 00 78    LD   HL,$7800
2C1F: 3E 80       LD   A,$80
2C21: 32 A1 78    LD   ($78A1),A
2C24: 3E FF       LD   A,$FF
2C26: 32 65 79    LD   ($7965),A
2C29: CD 9F 30    CALL $309F
2C2C: CD C7 2E    CALL $2EC7
2C2F: 3A 62 79    LD   A,($7962)
2C32: 32 6A 79    LD   ($796A),A
2C35: FE 00       CP   $00
2C37: 28 69       JR   Z,$2CA2
2C39: 3A A7 78    LD   A,($78A7)
2C3C: E6 7E       AND  $7E
2C3E: FE 04       CP   $04
2C40: 20 05       JR   NZ,$2C47
2C42: 3E 10       LD   A,$10
2C44: CD 53 0B    CALL $0B53
2C47: 0E 06       LD   C,$06
2C49: CD B0 2F    CALL $2FB0
2C4C: FE 00       CP   $00
2C4E: 28 05       JR   Z,$2C55
2C50: 3E 0A       LD   A,$0A
2C52: CD 53 0B    CALL $0B53
2C55: 0E 10       LD   C,$10
2C57: CD B0 2F    CALL $2FB0
2C5A: FE 00       CP   $00
2C5C: 28 1A       JR   Z,$2C78
2C5E: 3E 01       LD   A,$01
2C60: 32 8A 7C    LD   ($7C8A),A
2C63: 3E 05       LD   A,$05
2C65: 32 64 79    LD   ($7964),A
2C68: 3A 89 7C    LD   A,($7C89)
2C6B: FE 01       CP   $01
2C6D: 20 09       JR   NZ,$2C78
2C6F: 97          SUB  A
2C70: 32 89 7C    LD   ($7C89),A
2C73: 3E 08       LD   A,$08
2C75: CD 53 0B    CALL $0B53
2C78: CD C3 2F    CALL $2FC3
2C7B: FE 00       CP   $00
2C7D: 28 17       JR   Z,$2C96
2C7F: 3A 8B 7C    LD   A,($7C8B)
2C82: FE 01       CP   $01
2C84: 20 10       JR   NZ,$2C96
2C86: 3A 89 7C    LD   A,($7C89)
2C89: FE 00       CP   $00
2C8B: 20 09       JR   NZ,$2C96
2C8D: 3C          INC  A
2C8E: 32 89 7C    LD   ($7C89),A
2C91: 3E 07       LD   A,$07
2C93: CD 53 0B    CALL $0B53
2C96: CD D6 2F    CALL $2FD6
2C99: FE 00       CP   $00
2C9B: 28 05       JR   Z,$2CA2
2C9D: 3E 09       LD   A,$09
2C9F: CD 53 0B    CALL $0B53
2CA2: 21 08 78    LD   HL,$7808
2CA5: CB 66       BIT  4,(HL)
2CA7: 20 04       JR   NZ,$2CAD
2CA9: 97          SUB  A
2CAA: 32 8A 7C    LD   ($7C8A),A
2CAD: 21 64 79    LD   HL,$7964
2CB0: 35          DEC  (HL)
2CB1: 20 04       JR   NZ,$2CB7
2CB3: 97          SUB  A
2CB4: 32 8A 7C    LD   ($7C8A),A
2CB7: 21 0A 78    LD   HL,$780A
2CBA: 06 08       LD   B,$08
2CBC: 3E 08       LD   A,$08
2CBE: 90          SUB  B
2CBF: 32 65 79    LD   ($7965),A
2CC2: E5          PUSH HL
2CC3: 21 71 79    LD   HL,$7971
2CC6: 16 00       LD   D,$00
2CC8: 5F          LD   E,A
2CC9: 19          ADD  HL,DE
2CCA: 7E          LD   A,(HL)
2CCB: 32 A1 78    LD   ($78A1),A
2CCE: E1          POP  HL
2CCF: E5          PUSH HL
2CD0: 11 08 00    LD   DE,$0008
2CD3: 19          ADD  HL,DE
2CD4: 7E          LD   A,(HL)
2CD5: 11 F8 FF    LD   DE,$FFF8
2CD8: 19          ADD  HL,DE
2CD9: CB 7F       BIT  7,A
2CDB: CA 0D 2E    JP   Z,$2E0D
2CDE: F5          PUSH AF
2CDF: 3A 87 7C    LD   A,($7C87)
2CE2: FE 03       CP   $03
2CE4: 38 05       JR   C,$2CEB
2CE6: D6 02       SUB  $02
2CE8: 32 87 7C    LD   ($7C87),A
2CEB: F1          POP  AF
2CEC: CB 77       BIT  6,A
2CEE: 20 69       JR   NZ,$2D59
2CF0: CB 6F       BIT  5,A
2CF2: 20 65       JR   NZ,$2D59
2CF4: E5          PUSH HL
2CF5: E5          PUSH HL
2CF6: 21 08 78    LD   HL,$7808
2CF9: 4E          LD   C,(HL)
2CFA: 11 F8 FF    LD   DE,$FFF8
2CFD: 19          ADD  HL,DE
2CFE: 5E          LD   E,(HL)
2CFF: 23          INC  HL
2D00: 56          LD   D,(HL)
2D01: E1          POP  HL
2D02: 7E          LD   A,(HL)
2D03: 93          SUB  E
2D04: CB 7F       BIT  7,A
2D06: 28 02       JR   Z,$2D0A
2D08: ED 44       NEG
2D0A: FE 08       CP   $08
2D0C: 30 4A       JR   NC,$2D58
2D0E: 23          INC  HL
2D0F: 7E          LD   A,(HL)
2D10: 92          SUB  D
2D11: 20 2A       JR   NZ,$2D3D
2D13: 11 08 00    LD   DE,$0008
2D16: 19          ADD  HL,DE
2D17: CB 7E       BIT  7,(HL)
2D19: 11 F8 FF    LD   DE,$FFF8
2D1C: 19          ADD  HL,DE
2D1D: 20 39       JR   NZ,$2D58
2D1F: 3A 8A 7C    LD   A,($7C8A)
2D22: FE 01       CP   $01
2D24: 28 32       JR   Z,$2D58
2D26: 79          LD   A,C
2D27: E6 06       AND  $06
2D29: FE 06       CP   $06
2D2B: 28 2B       JR   Z,$2D58
2D2D: E5          PUSH HL
2D2E: 21 6E 7D    LD   HL,$7D6E
2D31: 3A 65 79    LD   A,($7965)
2D34: 16 00       LD   D,$00
2D36: 5F          LD   E,A
2D37: 19          ADD  HL,DE
2D38: 36 01       LD   (HL),$01
2D3A: E1          POP  HL
2D3B: 18 1B       JR   $2D58
2D3D: CB 61       BIT  4,C
2D3F: 28 17       JR   Z,$2D58
2D41: CB 7F       BIT  7,A
2D43: 28 13       JR   Z,$2D58
2D45: ED 44       NEG
2D47: FE 10       CP   $10
2D49: 30 0D       JR   NC,$2D58
2D4B: 3A 8A 7C    LD   A,($7C8A)
2D4E: FE 01       CP   $01
2D50: 20 06       JR   NZ,$2D58
2D52: 11 08 00    LD   DE,$0008
2D55: 19          ADD  HL,DE
2D56: CB FE       SET  7,(HL)
2D58: E1          POP  HL
2D59: CD 9F 30    CALL $309F
2D5C: 11 08 00    LD   DE,$0008
2D5F: 19          ADD  HL,DE
2D60: CB 76       BIT  6,(HL)
2D62: 28 0C       JR   Z,$2D70
2D64: 21 6E 7D    LD   HL,$7D6E
2D67: 3A 65 79    LD   A,($7965)
2D6A: 16 00       LD   D,$00
2D6C: 5F          LD   E,A
2D6D: 19          ADD  HL,DE
2D6E: 36 00       LD   (HL),$00
2D70: E1          POP  HL
2D71: 11 0A 00    LD   DE,$000A
2D74: 19          ADD  HL,DE
2D75: 05          DEC  B
2D76: C2 BC 2C    JP   NZ,$2CBC
2D79: 3A 76 7D    LD   A,($7D76)
2D7C: FE 01       CP   $01
2D7E: 28 5B       JR   Z,$2DDB
2D80: 3A 87 7C    LD   A,($7C87)
2D83: 47          LD   B,A
2D84: CD AC 11    CALL $11AC
2D87: CD 3A 2E    CALL $2E3A
2D8A: 3A 99 79    LD   A,($7999)
2D8D: FE 01       CP   $01
2D8F: 28 28       JR   Z,$2DB9
2D91: 3A 6D 7D    LD   A,($7D6D)
2D94: FE 01       CP   $01
2D96: 28 47       JR   Z,$2DDF
2D98: 3A 08 78    LD   A,($7808)
2D9B: E6 06       AND  $06
2D9D: FE 06       CP   $06
2D9F: 20 08       JR   NZ,$2DA9
2DA1: 3A 6A 79    LD   A,($796A)
2DA4: FE 01       CP   $01
2DA6: C2 00 2C    JP   NZ,$2C00
2DA9: 06 08       LD   B,$08
2DAB: 21 6E 7D    LD   HL,$7D6E
2DAE: 7E          LD   A,(HL)
2DAF: FE 01       CP   $01
2DB1: 28 2C       JR   Z,$2DDF
2DB3: 23          INC  HL
2DB4: 10 F8       DJNZ $2DAE
2DB6: C3 00 2C    JP   $2C00
2DB9: 97          SUB  A
2DBA: 32 6D 7D    LD   ($7D6D),A
2DBD: CD EF 18    CALL $18EF
2DC0: CD 3B 09    CALL $093B
2DC3: 3E 0D       LD   A,$0D
2DC5: CD 53 0B    CALL $0B53
2DC8: CD B8 11    CALL $11B8
2DCB: 3A 64 7D    LD   A,($7D64)
2DCE: FE 01       CP   $01
2DD0: 21 7F 7D    LD   HL,$7D7F
2DD3: 28 03       JR   Z,$2DD8
2DD5: 21 80 7D    LD   HL,$7D80
2DD8: 36 01       LD   (HL),$01
2DDA: C9          RET

2DDB: 3E 11       LD   A,$11
2DDD: 18 02       JR   $2DE1
2DDF: 3E 0C       LD   A,$0C
2DE1: CD 3B 09    CALL $093B
2DE4: CD 53 0B    CALL $0B53
2DE7: CD B8 11    CALL $11B8
2DEA: 3A 64 7D    LD   A,($7D64)
2DED: FE 01       CP   $01
2DEF: 11 62 7A    LD   DE,$7A62
2DF2: 21 7F 7D    LD   HL,$7D7F
2DF5: 28 06       JR   Z,$2DFD
2DF7: 11 28 7B    LD   DE,$7B28
2DFA: 21 80 7D    LD   HL,$7D80
2DFD: 36 00       LD   (HL),$00
2DFF: 21 9C 79    LD   HL,$799C
2E02: 06 C6       LD   B,$C6
2E04: CD 84 11    CALL $1184
2E07: 3E 01       LD   A,$01
2E09: 32 6D 7D    LD   ($7D6D),A
2E0C: C9          RET

2E0D: 3A 9A 79    LD   A,($799A)
2E10: FE 00       CP   $00
2E12: C2 70 2D    JP   NZ,$2D70
2E15: 3A 65 79    LD   A,($7965)
2E18: 21 79 79    LD   HL,$7979
2E1B: 16 00       LD   D,$00
2E1D: 5F          LD   E,A
2E1E: 19          ADD  HL,DE
2E1F: 35          DEC  (HL)
2E20: C2 70 2D    JP   NZ,$2D70
2E23: 11 08 00    LD   DE,$0008
2E26: 19          ADD  HL,DE
2E27: 7E          LD   A,(HL)
2E28: 11 F8 FF    LD   DE,$FFF8
2E2B: 19          ADD  HL,DE
2E2C: 77          LD   (HL),A
2E2D: E1          POP  HL
2E2E: E5          PUSH HL
2E2F: CD 92 2B    CALL $2B92
2E32: 3E 14       LD   A,$14
2E34: CD 53 0B    CALL $0B53
2E37: C3 59 2D    JP   $2D59
2E3A: 21 00 78    LD   HL,$7800
2E3D: 4E          LD   C,(HL)
2E3E: 23          INC  HL
2E3F: 7E          LD   A,(HL)
2E40: 11 07 00    LD   DE,$0007
2E43: 19          ADD  HL,DE
2E44: CB 66       BIT  4,(HL)
2E46: 20 78       JR   NZ,$2EC0
2E48: E6 70       AND  $70
2E4A: 0F          RRCA
2E4B: 0F          RRCA
2E4C: 0F          RRCA
2E4D: 0F          RRCA
2E4E: 32 61 79    LD   ($7961),A
2E51: 5F          LD   E,A
2E52: 07          RLCA
2E53: 07          RLCA
2E54: 07          RLCA
2E55: 07          RLCA
2E56: 07          RLCA
2E57: 83          ADD  A,E
2E58: 16 00       LD   D,$00
2E5A: 5F          LD   E,A
2E5B: 21 9C 79    LD   HL,$799C
2E5E: 19          ADD  HL,DE
2E5F: 7E          LD   A,(HL)
2E60: FE FF       CP   $FF
2E62: 28 57       JR   Z,$2EBB
2E64: FE 00       CP   $00
2E66: 23          INC  HL
2E67: 28 0E       JR   Z,$2E77
2E69: 7E          LD   A,(HL)
2E6A: 91          SUB  C
2E6B: 28 0D       JR   Z,$2E7A
2E6D: CB 7F       BIT  7,A
2E6F: 28 02       JR   Z,$2E73
2E71: ED 44       NEG
2E73: FE 04       CP   $04
2E75: 38 03       JR   C,$2E7A
2E77: 23          INC  HL
2E78: 18 E5       JR   $2E5F
2E7A: 3A 61 79    LD   A,($7961)
2E7D: 07          RLCA
2E7E: 07          RLCA
2E7F: 07          RLCA
2E80: 07          RLCA
2E81: 16 00       LD   D,$00
2E83: 5F          LD   E,A
2E84: 4E          LD   C,(HL)
2E85: 2B          DEC  HL
2E86: 36 00       LD   (HL),$00
2E88: 21 0B 80    LD   HL,$800B
2E8B: 19          ADD  HL,DE
2E8C: ED 5B 5F 79 LD   DE,($795F)
2E90: 1A          LD   A,(DE)
2E91: 13          INC  DE
2E92: D5          PUSH DE
2E93: 81          ADD  A,C
2E94: 16 00       LD   D,$00
2E96: 5F          LD   E,A
2E97: CD 37 11    CALL $1137
2E9A: 19          ADD  HL,DE
2E9B: 97          SUB  A
2E9C: 32 A2 78    LD   ($78A2),A
2E9F: 3A 63 79    LD   A,($7963)
2EA2: C6 05       ADD  A,$05
2EA4: CD EF 18    CALL $18EF
2EA7: D1          POP  DE
2EA8: CD 84 30    CALL $3084
2EAB: 3E 0F       LD   A,$0F
2EAD: CD 53 0B    CALL $0B53
2EB0: 21 9B 79    LD   HL,$799B
2EB3: 35          DEC  (HL)
2EB4: 20 05       JR   NZ,$2EBB
2EB6: 3E 01       LD   A,$01
2EB8: 32 99 79    LD   ($7999),A
2EBB: 3A 7D 7D    LD   A,($7D7D)
2EBE: 18 03       JR   $2EC3
2EC0: 3A 7E 7D    LD   A,($7D7E)
2EC3: CD 97 1A    CALL $1A97
2EC6: C9          RET

2EC7: 06 05       LD   B,$05
2EC9: 3A 86 7C    LD   A,($7C86)
2ECC: 4F          LD   C,A
2ECD: 21 6E 78    LD   HL,$786E
2ED0: CB 21       SLA  C
2ED2: 30 39       JR   NC,$2F0D
2ED4: 7E          LD   A,(HL)
2ED5: FE 02       CP   $02
2ED7: 28 3D       JR   Z,$2F16
2ED9: FE 01       CP   $01
2EDB: 20 30       JR   NZ,$2F0D
2EDD: 23          INC  HL
2EDE: 7E          LD   A,(HL)
2EDF: 32 A5 78    LD   ($78A5),A
2EE2: 23          INC  HL
2EE3: 5E          LD   E,(HL)
2EE4: 83          ADD  A,E
2EE5: 5F          LD   E,A
2EE6: 23          INC  HL
2EE7: 56          LD   D,(HL)
2EE8: BA          CP   D
2EE9: 2B          DEC  HL
2EEA: 20 1E       JR   NZ,$2F0A
2EEC: D5          PUSH DE
2EED: E5          PUSH HL
2EEE: 11 06 00    LD   DE,$0006
2EF1: 19          ADD  HL,DE
2EF2: 5E          LD   E,(HL)
2EF3: 23          INC  HL
2EF4: 56          LD   D,(HL)
2EF5: EB          EX   DE,HL
2EF6: 11 55 56    LD   DE,$5655
2EF9: CD 84 30    CALL $3084
2EFC: E1          POP  HL
2EFD: D1          POP  DE
2EFE: 2B          DEC  HL
2EFF: 2B          DEC  HL
2F00: 3E 02       LD   A,$02
2F02: CD 53 0B    CALL $0B53
2F05: 97          SUB  A
2F06: 77          LD   (HL),A
2F07: 23          INC  HL
2F08: 77          LD   (HL),A
2F09: 23          INC  HL
2F0A: 73          LD   (HL),E
2F0B: 18 14       JR   $2F21
2F0D: 23          INC  HL
2F0E: 23          INC  HL
2F0F: 11 08 00    LD   DE,$0008
2F12: 19          ADD  HL,DE
2F13: 10 BB       DJNZ $2ED0
2F15: C9          RET

2F16: 23          INC  HL
2F17: 7E          LD   A,(HL)
2F18: 23          INC  HL
2F19: 5E          LD   E,(HL)
2F1A: 32 A5 78    LD   ($78A5),A
2F1D: 83          ADD  A,E
2F1E: 5F          LD   E,A
2F1F: 18 E9       JR   $2F0A
2F21: C5          PUSH BC
2F22: E5          PUSH HL
2F23: 7B          LD   A,E
2F24: 21 A9 2F    LD   HL,$2FA9
2F27: 16 00       LD   D,$00
2F29: 58          LD   E,B
2F2A: 1D          DEC  E
2F2B: 19          ADD  HL,DE
2F2C: 5E          LD   E,(HL)
2F2D: CD 37 11    CALL $1137
2F30: 21 00 80    LD   HL,$8000
2F33: 19          ADD  HL,DE
2F34: 16 00       LD   D,$00
2F36: 5F          LD   E,A
2F37: 19          ADD  HL,DE
2F38: 3A A5 78    LD   A,($78A5)
2F3B: CB 7F       BIT  7,A
2F3D: 20 02       JR   NZ,$2F41
2F3F: 2B          DEC  HL
2F40: 2B          DEC  HL
2F41: E5          PUSH HL
2F42: 21 94 2F    LD   HL,$2F94
2F45: 22 AA 78    LD   ($78AA),HL
2F48: E1          POP  HL
2F49: 3E 04       LD   A,$04
2F4B: 32 A0 78    LD   ($78A0),A
2F4E: 01 02 02    LD   BC,$0202
2F51: E5          PUSH HL				;Store HL on stack
2F52: 2A AA 78    LD   HL,($78AA)		;
2F55: 5E          LD   E,(HL)			;
2F56: 23          INC  HL				;
2F57: 56          LD   D,(HL)			;
2F58: 23          INC  HL				;
2F59: 22 AA 78    LD   ($78AA),HL		;
2F5C: E1          POP  HL				;
2F5D: 19          ADD  HL,DE			;
2F5E: 3E EE       LD   A,$EE			;Load the inverter color into A (light green)
2F60: CD 67 11    CALL $1167			;GOSUB: DRAW_ELEVATOR
2F63: 3A A0 78    LD   A,($78A0)
2F66: 3D          DEC  A
2F67: 32 A0 78    LD   ($78A0),A
2F6A: 20 E5       JR   NZ,$2F51
2F6C: 3E 04       LD   A,$04
2F6E: 32 A0 78    LD   ($78A0),A
2F71: 01 09 01    LD   BC,$0109
2F74: E5          PUSH HL
2F75: 2A AA 78    LD   HL,($78AA)
2F78: 5E          LD   E,(HL)
2F79: 23          INC  HL
2F7A: 56          LD   D,(HL)
2F7B: 23          INC  HL
2F7C: 22 AA 78    LD   ($78AA),HL
2F7F: E1          POP  HL
2F80: 19          ADD  HL,DE
2F81: 3E EE       LD   A,$EE
2F83: CD 67 11    CALL $1167
2F86: 3A A0 78    LD   A,($78A0)
2F89: 3D          DEC  A
2F8A: 32 A0 78    LD   ($78A0),A
2F8D: 20 E5       JR   NZ,$2F74
2F8F: E1          POP  HL
2F90: C1          POP  BC
2F91: C3 0F 2F    JP   $2F0F
2F94: 00          NOP
2F95: 00          NOP
2F96: D8          RET  C

2F97: 05          DEC  B
2F98: 0F          RRCA
2F99: 00          NOP
2F9A: 28 FA       JR   Z,$2F96
2F9C: 11 01 FE    LD   DE,$FE01
2F9F: FF          RST  $38
2FA0: F4 FF FE    CALL P,$FEFF
2FA3: FF          RST  $38
2FA4: 15          DEC  D
2FA5: 42          LD   B,D
2FA6: 6F          LD   L,A
2FA7: 9C          SBC  A,H
2FA8: C9          RET

2FA9: CA 9D 70    JP   Z,$709D
2FAC: 43          LD   B,E
2FAD: 16 97       LD   D,$97
2FAF: C9          RET

2FB0: 3A A8 78    LD   A,($78A8)
2FB3: E6 7E       AND  $7E
2FB5: B9          CP   C
2FB6: 20 F6       JR   NZ,$2FAE
2FB8: 3A A7 78    LD   A,($78A7)
2FBB: E6 7E       AND  $7E
2FBD: B9          CP   C
2FBE: 28 EE       JR   Z,$2FAE
2FC0: 3E 01       LD   A,$01
2FC2: C9          RET

2FC3: 3A A8 78    LD   A,($78A8)
2FC6: E6 7E       AND  $7E
2FC8: B9          CP   C
2FC9: 28 E3       JR   Z,$2FAE
2FCB: 3A A7 78    LD   A,($78A7)
2FCE: E6 7E       AND  $7E
2FD0: B9          CP   C
2FD1: 20 DB       JR   NZ,$2FAE
2FD3: 3E 01       LD   A,$01
2FD5: C9          RET

2FD6: 3A A8 78    LD   A,($78A8)
2FD9: E6 7E       AND  $7E
2FDB: B9          CP   C
2FDC: 20 D0       JR   NZ,$2FAE
2FDE: 3A A7 78    LD   A,($78A7)
2FE1: E6 7E       AND  $7E
2FE3: B9          CP   C
2FE4: 20 C8       JR   NZ,$2FAE
2FE6: 3E 01       LD   A,$01
2FE8: C9          RET

2FE9: 3A 8C 7C    LD   A,($7C8C)
2FEC: FE 01       CP   $01
2FEE: 20 05       JR   NZ,$2FF5
2FF0: DB 00       IN   A,($00)
2FF2: CB 7F       BIT  7,A
2FF4: C0          RET  NZ

2FF5: 2A 7D 7C    LD   HL,($7C7D)
2FF8: 3A 7F 7C    LD   A,($7C7F)
2FFB: 3C          INC  A
2FFC: 32 7F 7C    LD   ($7C7F),A
2FFF: FE 78       CP   $78
3001: 20 0A       JR   NZ,$300D
3003: 97          SUB  A
3004: 32 7F 7C    LD   ($7C7F),A
3007: 21 0A 77    LD   HL,$770A
300A: 22 7D 7C    LD   ($7C7D),HL
300D: 0E 0A       LD   C,$0A
300F: 06 04       LD   B,$04
3011: CD 2D 30    CALL $302D
3014: 0E 07       LD   C,$07
3016: 06 F8       LD   B,$F8
3018: CD 2D 30    CALL $302D
301B: 0E 04       LD   C,$04
301D: 46          LD   B,(HL)
301E: 23          INC  HL
301F: CD 2D 30    CALL $302D
3022: 0C          INC  C
3023: 7E          LD   A,(HL)
3024: 23          INC  HL
3025: 47          LD   B,A
3026: CD 2D 30    CALL $302D
3029: 22 7D 7C    LD   ($7C7D),HL
302C: C9          RET

302D: 79          LD   A,C
302E: D3 06       OUT  ($06),A
3030: 78          LD   A,B
3031: D3 02       OUT  ($02),A
3033: C9          RET

3034: F5          PUSH AF
3035: C5          PUSH BC
3036: D5          PUSH DE
3037: E5          PUSH HL
3038: 23          INC  HL
3039: 23          INC  HL
303A: 4E          LD   C,(HL)
303B: 23          INC  HL
303C: 46          LD   B,(HL)
303D: 23          INC  HL
303E: 5E          LD   E,(HL)
303F: 23          INC  HL
3040: 56          LD   D,(HL)
3041: C5          PUSH BC
3042: E1          POP  HL
3043: 08          EX   AF,AF'
3044: 1A          LD   A,(DE)
3045: 4F          LD   C,A
3046: 13          INC  DE
3047: 1A          LD   A,(DE)
3048: 47          LD   B,A
3049: 13          INC  DE
304A: 08          EX   AF,AF'
304B: D9          EXX
304C: 3A A2 78    LD   A,($78A2)
304F: FE 00       CP   $00
3051: 06 00       LD   B,$00
3053: 3E 88       LD   A,$88
3055: 28 0F       JR   Z,$3066
3057: 05          DEC  B
3058: 3E 78       LD   A,$78
305A: D9          EXX
305B: D5          PUSH DE
305C: 16 00       LD   D,$00
305E: 59          LD   E,C
305F: 1D          DEC  E
3060: CD 37 11    CALL $1137
3063: 19          ADD  HL,DE
3064: D1          POP  DE
3065: D9          EXX
3066: D9          EXX
3067: 90          SUB  B
3068: D9          EXX
3069: 4F          LD   C,A
306A: D9          EXX
306B: 1A          LD   A,(DE)
306C: AE          XOR  (HL)
306D: 77          LD   (HL),A
306E: 23          INC  HL
306F: 13          INC  DE
3070: 10 F9       DJNZ $306B
3072: 08          EX   AF,AF'
3073: 47          LD   B,A
3074: 08          EX   AF,AF'
3075: E5          PUSH HL
3076: D9          EXX
3077: E1          POP  HL
3078: 09          ADD  HL,BC
3079: E5          PUSH HL
307A: D9          EXX
307B: E1          POP  HL
307C: 0D          DEC  C
307D: 20 EC       JR   NZ,$306B
307F: E1          POP  HL
3080: D1          POP  DE
3081: C1          POP  BC
3082: F1          POP  AF
3083: C9          RET

3084: F5          PUSH AF
3085: C5          PUSH BC
3086: E5          PUSH HL
3087: 01 66 78    LD   BC,$7866
308A: 7D          LD   A,L
308B: 02          LD   (BC),A
308C: 03          INC  BC
308D: 7C          LD   A,H
308E: 02          LD   (BC),A
308F: 03          INC  BC
3090: 7B          LD   A,E
3091: 02          LD   (BC),A
3092: 03          INC  BC
3093: 7A          LD   A,D
3094: 02          LD   (BC),A
3095: 21 64 78    LD   HL,$7864
3098: CD 34 30    CALL $3034
309B: E1          POP  HL
309C: C1          POP  BC
309D: F1          POP  AF
309E: C9          RET

309F: F5          PUSH AF
30A0: C5          PUSH BC
30A1: D5          PUSH DE
30A2: E5          PUSH HL
30A3: 97          SUB  A
30A4: 32 62 79    LD   ($7962),A
30A7: 32 8B 7C    LD   ($7C8B),A
30AA: 11 06 00    LD   DE,$0006
30AD: 19          ADD  HL,DE
30AE: 5E          LD   E,(HL)
30AF: 23          INC  HL
30B0: 56          LD   D,(HL)
30B1: 2B          DEC  HL
30B2: 2B          DEC  HL
30B3: 1A          LD   A,(DE)
30B4: 32 69 79    LD   ($7969),A
30B7: CB 7F       BIT  7,A
30B9: C2 4E 31    JP   NZ,$314E
30BC: 77          LD   (HL),A
30BD: 13          INC  DE
30BE: 1A          LD   A,(DE)
30BF: 2B          DEC  HL
30C0: 77          LD   (HL),A
30C1: 13          INC  DE
30C2: 1A          LD   A,(DE)
30C3: 47          LD   B,A
30C4: 13          INC  DE
30C5: 1A          LD   A,(DE)
30C6: 4F          LD   C,A
30C7: D5          PUSH DE
30C8: 2B          DEC  HL
30C9: 56          LD   D,(HL)
30CA: 2B          DEC  HL
30CB: 5E          LD   E,(HL)
30CC: EB          EX   DE,HL
30CD: 09          ADD  HL,BC
30CE: EB          EX   DE,HL
30CF: 73          LD   (HL),E
30D0: 23          INC  HL
30D1: 72          LD   (HL),D
30D2: D1          POP  DE
30D3: 13          INC  DE
30D4: 1A          LD   A,(DE)
30D5: 2B          DEC  HL
30D6: 2B          DEC  HL
30D7: 46          LD   B,(HL)
30D8: 80          ADD  A,B
30D9: 77          LD   (HL),A
30DA: 13          INC  DE
30DB: 1A          LD   A,(DE)
30DC: 2B          DEC  HL
30DD: 46          LD   B,(HL)
30DE: 80          ADD  A,B
30DF: 77          LD   (HL),A
30E0: 13          INC  DE
30E1: 1A          LD   A,(DE)
30E2: 47          LD   B,A
30E3: 13          INC  DE
30E4: 1A          LD   A,(DE)
30E5: 4F          LD   C,A
30E6: D5          PUSH DE
30E7: 23          INC  HL
30E8: 23          INC  HL
30E9: 5E          LD   E,(HL)
30EA: 23          INC  HL
30EB: 56          LD   D,(HL)
30EC: EB          EX   DE,HL
30ED: 09          ADD  HL,BC
30EE: EB          EX   DE,HL
30EF: 72          LD   (HL),D
30F0: 2B          DEC  HL
30F1: 73          LD   (HL),E
30F2: 11 07 00    LD   DE,$0007
30F5: 19          ADD  HL,DE
30F6: 7E          LD   A,(HL)
30F7: CB BF       RES  7,A
30F9: 32 A2 78    LD   ($78A2),A
30FC: 11 F7 FF    LD   DE,$FFF7
30FF: 19          ADD  HL,DE
3100: CD 34 30    CALL $3034
3103: 23          INC  HL
3104: 23          INC  HL
3105: 5E          LD   E,(HL)
3106: 23          INC  HL
3107: 56          LD   D,(HL)
3108: EB          EX   DE,HL
3109: AF          XOR  A
310A: ED 42       SBC  HL,BC
310C: EB          EX   DE,HL
310D: 72          LD   (HL),D
310E: 2B          DEC  HL
310F: 73          LD   (HL),E
3110: D1          POP  DE
3111: 13          INC  DE
3112: 01 04 00    LD   BC,$0004
3115: 09          ADD  HL,BC
3116: 73          LD   (HL),E
3117: 23          INC  HL
3118: 72          LD   (HL),D
3119: E1          POP  HL
311A: D1          POP  DE
311B: C1          POP  BC
311C: F1          POP  AF
311D: C9          RET

311E: E5          PUSH HL
311F: 3A A1 78    LD   A,($78A1)
3122: CB 7F       BIT  7,A
3124: 11 27 37    LD   DE,$3727
3127: 20 0C       JR   NZ,$3135
3129: 3D          DEC  A
312A: 07          RLCA
312B: 5F          LD   E,A
312C: 16 00       LD   D,$00
312E: 21 C3 36    LD   HL,$36C3
3131: 19          ADD  HL,DE
3132: 5E          LD   E,(HL)
3133: 23          INC  HL
3134: 56          LD   D,(HL)
3135: E1          POP  HL
3136: 7E          LD   A,(HL)
3137: CD 9A 36    CALL $369A
313A: E5          PUSH HL
313B: 26 00       LD   H,$00
313D: 07          RLCA
313E: 6F          LD   L,A
313F: 19          ADD  HL,DE
3140: 5E          LD   E,(HL)
3141: 23          INC  HL
3142: 56          LD   D,(HL)
3143: CD BB 36    CALL $36BB
3146: E1          POP  HL
3147: 2B          DEC  HL
3148: 72          LD   (HL),D
3149: 2B          DEC  HL
314A: 73          LD   (HL),E
314B: C3 B2 30    JP   $30B2
314E: E5          PUSH HL
314F: FE CC       CP   $CC
3151: 20 0B       JR   NZ,$315E
3153: 13          INC  DE
3154: 26 FF       LD   H,$FF
3156: 1A          LD   A,(DE)
3157: 6F          LD   L,A
3158: 19          ADD  HL,DE
3159: EB          EX   DE,HL
315A: E1          POP  HL
315B: C3 B3 30    JP   $30B3
315E: FE DD       CP   $DD
3160: 20 25       JR   NZ,$3187
3162: 3E 01       LD   A,$01
3164: 32 AC 78    LD   ($78AC),A
3167: CD CC 31    CALL $31CC
316A: 23          INC  HL
316B: 23          INC  HL
316C: 23          INC  HL
316D: 46          LD   B,(HL)
316E: E1          POP  HL
316F: 13          INC  DE
3170: 13          INC  DE
3171: B8          CP   B
3172: CA B3 30    JP   Z,$30B3
3175: CB 77       BIT  6,A
3177: 28 08       JR   Z,$3181
3179: E5          PUSH HL
317A: 23          INC  HL
317B: 23          INC  HL
317C: 23          INC  HL
317D: 23          INC  HL
317E: CB FE       SET  7,(HL)
3180: E1          POP  HL
3181: E5          PUSH HL
3182: 1B          DEC  DE
3183: 26 00       LD   H,$00
3185: 18 CF       JR   $3156
3187: FE EE       CP   $EE
3189: C2 BF 36    JP   NZ,$36BF
318C: 97          SUB  A
318D: 32 AC 78    LD   ($78AC),A
3190: CD CC 31    CALL $31CC
3193: D1          POP  DE
3194: 23          INC  HL
3195: 23          INC  HL
3196: 23          INC  HL
3197: CB 77       BIT  6,A
3199: 20 12       JR   NZ,$31AD
319B: CB 7F       BIT  7,A
319D: 28 22       JR   Z,$31C1
319F: 77          LD   (HL),A
31A0: 23          INC  HL
31A1: 36 00       LD   (HL),$00
31A3: FE 84       CP   $84
31A5: 20 02       JR   NZ,$31A9
31A7: 36 01       LD   (HL),$01
31A9: 2B          DEC  HL
31AA: C3 1E 31    JP   $311E
31AD: 3A A1 78    LD   A,($78A1)
31B0: CB 7F       BIT  7,A
31B2: C2 19 31    JP   NZ,$3119
31B5: CD EF 18    CALL $18EF
31B8: 3E 0E       LD   A,$0E
31BA: CD 53 0B    CALL $0B53
31BD: 3E C0       LD   A,$C0
31BF: 18 DE       JR   $319F
31C1: 3A A1 78    LD   A,($78A1)
31C4: CB 7F       BIT  7,A
31C6: C2 19 31    JP   NZ,$3119
31C9: 97          SUB  A
31CA: 18 D3       JR   $319F
31CC: C5          PUSH BC
31CD: D5          PUSH DE
31CE: E5          PUSH HL
31CF: 97          SUB  A
31D0: 32 66 79    LD   ($7966),A
31D3: 3C          INC  A
31D4: 32 62 79    LD   ($7962),A
31D7: 3A AC 78    LD   A,($78AC)
31DA: FE 01       CP   $01
31DC: 28 05       JR   Z,$31E3
31DE: 3E 01       LD   A,$01
31E0: 32 8B 7C    LD   ($7C8B),A
31E3: 3A 8C 7C    LD   A,($7C8C)
31E6: FE 01       CP   $01
31E8: 20 09       JR   NZ,$31F3
31EA: CD D7 21    CALL $21D7
31ED: 3A B3 7C    LD   A,($7CB3)
31F0: 4F          LD   C,A
31F1: 18 44       JR   $3237
31F3: 3A A1 78    LD   A,($78A1)
31F6: CB 7F       BIT  7,A
31F8: 28 3A       JR   Z,$3234
31FA: F3          DI
31FB: 3A 62 7D    LD   A,($7D62)
31FE: 4F          LD   C,A
31FF: 3E FF       LD   A,$FF
3201: 32 62 7D    LD   ($7D62),A
3204: FB          EI
3205: 79          LD   A,C
3206: 2F          CPL
3207: 0E 80       LD   C,$80
3209: CB 57       BIT  2,A
320B: 28 04       JR   Z,$3211
320D: CB E1       SET  4,C
320F: 18 26       JR   $3237
3211: CB 5F       BIT  3,A
3213: 28 04       JR   Z,$3219
3215: CB D9       SET  3,C
3217: 18 1E       JR   $3237
3219: E6 33       AND  $33
321B: 28 1A       JR   Z,$3237
321D: CB D1       SET  2,C
321F: 47          LD   B,A
3220: E6 03       AND  $03
3222: 28 06       JR   Z,$322A
3224: CB 47       BIT  0,A
3226: 28 0F       JR   Z,$3237
3228: 18 06       JR   $3230
322A: CB C9       SET  1,C
322C: CB 60       BIT  4,B
322E: 28 07       JR   Z,$3237
3230: CB C1       SET  0,C
3232: 18 03       JR   $3237
3234: CD 38 35    CALL $3538
3237: 97          SUB  A
3238: 32 A3 78    LD   ($78A3),A
323B: 32 A4 78    LD   ($78A4),A
323E: 11 03 00    LD   DE,$0003
3241: 19          ADD  HL,DE
3242: 7E          LD   A,(HL)
3243: 32 A8 78    LD   ($78A8),A
3246: CB 77       BIT  6,A
3248: 28 04       JR   Z,$324E
324A: 0E 00       LD   C,$00
324C: 18 0A       JR   $3258
324E: 23          INC  HL
324F: CB 7E       BIT  7,(HL)
3251: CB BE       RES  7,(HL)
3253: 2B          DEC  HL
3254: 28 02       JR   Z,$3258
3256: 0E C0       LD   C,$C0
3258: 79          LD   A,C
3259: 32 A7 78    LD   ($78A7),A
325C: 11 F8 FF    LD   DE,$FFF8
325F: 19          ADD  HL,DE
3260: 4E          LD   C,(HL)
3261: 23          INC  HL
3262: 7E          LD   A,(HL)
3263: 32 A6 78    LD   ($78A6),A
3266: E6 0F       AND  $0F
3268: FE 0B       CP   $0B
326A: 28 1B       JR   Z,$3287
326C: 3A A8 78    LD   A,($78A8)
326F: CB 67       BIT  4,A
3271: 20 14       JR   NZ,$3287
3273: E6 81       AND  $81
3275: 5F          LD   E,A
3276: 3A A7 78    LD   A,($78A7)
3279: E6 7E       AND  $7E
327B: FE 06       CP   $06
327D: 28 08       JR   Z,$3287
327F: B3          OR   E
3280: E6 87       AND  $87
3282: F6 06       OR   $06
3284: 32 A7 78    LD   ($78A7),A
3287: 3A 86 7C    LD   A,($7C86)
328A: 11 A4 2F    LD   DE,$2FA4
328D: 06 05       LD   B,$05
328F: F5          PUSH AF
3290: 1A          LD   A,(DE)
3291: 91          SUB  C
3292: CA DA 33    JP   Z,$33DA
3295: FE 0F       CP   $0F
3297: CA A1 33    JP   Z,$33A1
329A: FE F1       CP   $F1
329C: CA BD 33    JP   Z,$33BD
329F: F1          POP  AF
32A0: 07          RLCA
32A1: 13          INC  DE
32A2: 10 EB       DJNZ $328F
32A4: 3A A7 78    LD   A,($78A7)
32A7: CB 4F       BIT  1,A
32A9: 20 42       JR   NZ,$32ED
32AB: CB 8F       RES  1,A
32AD: CB 77       BIT  6,A
32AF: C2 DC 34    JP   NZ,$34DC
32B2: CB 6F       BIT  5,A
32B4: C2 DC 34    JP   NZ,$34DC
32B7: CB 67       BIT  4,A
32B9: C2 DC 34    JP   NZ,$34DC
32BC: CB 5F       BIT  3,A
32BE: C2 6E 34    JP   NZ,$346E
32C1: CB 57       BIT  2,A
32C3: CA DC 34    JP   Z,$34DC
32C6: CB 4F       BIT  1,A
32C8: 32 A7 78    LD   ($78A7),A
32CB: CA 5D 33    JP   Z,$335D
32CE: 3A A4 78    LD   A,($78A4)
32D1: FE 01       CP   $01
32D3: 3A A7 78    LD   A,($78A7)
32D6: 20 15       JR   NZ,$32ED
32D8: E5          PUSH HL
32D9: CB 47       BIT  0,A
32DB: 7E          LD   A,(HL)
32DC: F5          PUSH AF
32DD: CD 16 35    CALL $3516
32E0: 11 04 00    LD   DE,$0004
32E3: 19          ADD  HL,DE
32E4: F1          POP  AF
32E5: 28 23       JR   Z,$330A
32E7: 23          INC  HL
32E8: BE          CP   (HL)
32E9: 2B          DEC  HL
32EA: 20 21       JR   NZ,$330D
32EC: E1          POP  HL
32ED: 3A A1 78    LD   A,($78A1)
32F0: CB 7F       BIT  7,A
32F2: 20 0E       JR   NZ,$3302
32F4: FE 04       CP   $04
32F6: 28 0A       JR   Z,$3302
32F8: 3A A7 78    LD   A,($78A7)
32FB: CB 8F       RES  1,A
32FD: 32 A7 78    LD   ($78A7),A
3300: 18 5B       JR   $335D
3302: 3A A7 78    LD   A,($78A7)
3305: CB 97       RES  2,A
3307: C3 DC 34    JP   $34DC
330A: BE          CP   (HL)
330B: 28 DF       JR   Z,$32EC
330D: C1          POP  BC
330E: 3A AC 78    LD   A,($78AC)
3311: FE 01       CP   $01
3313: CA D9 34    JP   Z,$34D9
3316: 0E 02       LD   C,$02
3318: 06 00       LD   B,$00
331A: 3A A7 78    LD   A,($78A7)
331D: CB 47       BIT  0,A
331F: 20 04       JR   NZ,$3325
3321: 0E FE       LD   C,$FE
3323: 06 01       LD   B,$01
3325: 79          LD   A,C
3326: 32 A5 78    LD   ($78A5),A
3329: 11 FC FF    LD   DE,$FFFC
332C: 19          ADD  HL,DE
332D: 3A A8 78    LD   A,($78A8)
3330: E6 06       AND  $06
3332: FE 06       CP   $06
3334: 28 06       JR   Z,$333C
3336: 7E          LD   A,(HL)
3337: FE 00       CP   $00
3339: C2 D9 34    JP   NZ,$34D9
333C: 36 02       LD   (HL),$02
333E: 23          INC  HL
333F: 3A A5 78    LD   A,($78A5)
3342: 77          LD   (HL),A
3343: 3A A1 78    LD   A,($78A1)
3346: CB 7F       BIT  7,A
3348: CA D9 34    JP   Z,$34D9
334B: 3A A7 78    LD   A,($78A7)
334E: 4F          LD   C,A
334F: 3A A8 78    LD   A,($78A8)
3352: B9          CP   C
3353: CA D9 34    JP   Z,$34D9
3356: 78          LD   A,B
3357: CD 53 0B    CALL $0B53
335A: C3 D9 34    JP   $34D9
335D: CB 47       BIT  0,A
335F: F5          PUSH AF
3360: 7E          LD   A,(HL)
3361: E6 70       AND  $70
3363: 0F          RRCA
3364: 0F          RRCA
3365: 0F          RRCA
3366: 0F          RRCA
3367: 5F          LD   E,A
3368: 07          RLCA
3369: 83          ADD  A,E
336A: 07          RLCA
336B: 83          ADD  A,E
336C: 07          RLCA
336D: 16 00       LD   D,$00
336F: 5F          LD   E,A
3370: F1          POP  AF
3371: 2B          DEC  HL
3372: 4E          LD   C,(HL)
3373: 20 16       JR   NZ,$338B
3375: 21 B1 78    LD   HL,$78B1
3378: 19          ADD  HL,DE
3379: 7E          LD   A,(HL)
337A: FE FF       CP   $FF
337C: CA D9 34    JP   Z,$34D9
337F: 91          SUB  C
3380: CA 02 33    JP   Z,$3302
3383: FE FD       CP   $FD
3385: CA 02 33    JP   Z,$3302
3388: 23          INC  HL
3389: 18 EE       JR   $3379
338B: 21 05 79    LD   HL,$7905
338E: 19          ADD  HL,DE
338F: 7E          LD   A,(HL)
3390: FE FF       CP   $FF
3392: CA D9 34    JP   Z,$34D9
3395: 91          SUB  C
3396: CA 02 33    JP   Z,$3302
3399: FE 03       CP   $03
339B: CA 02 33    JP   Z,$3302
339E: 23          INC  HL
339F: 18 EE       JR   $338F
33A1: F1          POP  AF
33A2: CB 7F       BIT  7,A
33A4: CA A4 32    JP   Z,$32A4
33A7: E5          PUSH HL
33A8: CD FB 34    CALL $34FB
33AB: 5E          LD   E,(HL)
33AC: E1          POP  HL
33AD: CD 26 35    CALL $3526
33B0: FE 01       CP   $01
33B2: C2 A4 32    JP   NZ,$32A4
33B5: 3E 01       LD   A,$01
33B7: 32 A3 78    LD   ($78A3),A
33BA: C3 A4 32    JP   $32A4
33BD: F1          POP  AF
33BE: CB 7F       BIT  7,A
33C0: CA A4 32    JP   Z,$32A4
33C3: E5          PUSH HL
33C4: CD FB 34    CALL $34FB
33C7: 23          INC  HL
33C8: 5E          LD   E,(HL)
33C9: E1          POP  HL
33CA: CD 26 35    CALL $3526
33CD: FE 01       CP   $01
33CF: C2 A4 32    JP   NZ,$32A4
33D2: 3E 01       LD   A,$01
33D4: 32 A3 78    LD   ($78A3),A
33D7: C3 A4 32    JP   $32A4
33DA: F1          POP  AF
33DB: CB 7F       BIT  7,A
33DD: CA A4 32    JP   Z,$32A4
33E0: E5          PUSH HL
33E1: CD FB 34    CALL $34FB
33E4: 11 FA FF    LD   DE,$FFFA
33E7: 19          ADD  HL,DE
33E8: 5E          LD   E,(HL)
33E9: 23          INC  HL
33EA: 23          INC  HL
33EB: 3A A6 78    LD   A,($78A6)
33EE: 96          SUB  (HL)
33EF: 28 35       JR   Z,$3426
33F1: CB 7F       BIT  7,A
33F3: 16 0E       LD   D,$0E
33F5: 28 04       JR   Z,$33FB
33F7: 16 08       LD   D,$08
33F9: ED 44       NEG
33FB: BA          CP   D
33FC: E1          POP  HL
33FD: D2 A4 32    JP   NC,$32A4
3400: 97          SUB  A
3401: BB          CP   E
3402: CA A4 32    JP   Z,$32A4
3405: 3A A1 78    LD   A,($78A1)
3408: CB 7F       BIT  7,A
340A: 28 0D       JR   Z,$3419
340C: 3A AC 78    LD   A,($78AC)
340F: FE 01       CP   $01
3411: CA A4 32    JP   Z,$32A4
3414: 3E 01       LD   A,$01
3416: 32 76 7D    LD   ($7D76),A
3419: 3A A7 78    LD   A,($78A7)
341C: CB 7F       BIT  7,A
341E: CA DC 34    JP   Z,$34DC
3421: CB F7       SET  6,A
3423: C3 DC 34    JP   $34DC
3426: 3E 01       LD   A,$01
3428: 32 A4 78    LD   ($78A4),A
342B: 2B          DEC  HL
342C: 2B          DEC  HL
342D: 3A A8 78    LD   A,($78A8)
3430: CB 4F       BIT  1,A
3432: 28 0F       JR   Z,$3443
3434: 3E 01       LD   A,$01
3436: 32 66 79    LD   ($7966),A
3439: 22 67 79    LD   ($7967),HL
343C: E1          POP  HL
343D: 3A A7 78    LD   A,($78A7)
3440: C3 AD 32    JP   $32AD
3443: E1          POP  HL
3444: 97          SUB  A
3445: BB          CP   E
3446: 3A A7 78    LD   A,($78A7)
3449: CA AD 32    JP   Z,$32AD
344C: 3A AC 78    LD   A,($78AC)
344F: FE 01       CP   $01
3451: 3A A7 78    LD   A,($78A7)
3454: CA AD 32    JP   Z,$32AD
3457: 3A A1 78    LD   A,($78A1)
345A: CB 7F       BIT  7,A
345C: 28 05       JR   Z,$3463
345E: 3E 01       LD   A,$01
3460: 32 76 7D    LD   ($7D76),A
3463: 3A A7 78    LD   A,($78A7)
3466: CB 7F       BIT  7,A
3468: 28 72       JR   Z,$34DC
346A: CB F7       SET  6,A
346C: 18 6E       JR   $34DC
346E: 32 A7 78    LD   ($78A7),A
3471: 22 6F 79    LD   ($796F),HL
3474: 3A A3 78    LD   A,($78A3)
3477: FE 01       CP   $01
3479: 20 5E       JR   NZ,$34D9
347B: 3A AC 78    LD   A,($78AC)
347E: FE 01       CP   $01
3480: 28 57       JR   Z,$34D9
3482: CD 16 35    CALL $3516
3485: 97          SUB  A
3486: BE          CP   (HL)
3487: 20 50       JR   NZ,$34D9
3489: 36 01       LD   (HL),$01
348B: 23          INC  HL
348C: 23          INC  HL
348D: 3A A1 78    LD   A,($78A1)
3490: CB 7F       BIT  7,A
3492: 28 05       JR   Z,$3499
3494: 3E 04       LD   A,$04
3496: CD 53 0B    CALL $0B53
3499: 3A A6 78    LD   A,($78A6)
349C: 96          SUB  (HL)
349D: 20 06       JR   NZ,$34A5
349F: 2B          DEC  HL
34A0: 2B          DEC  HL
34A1: 36 00       LD   (HL),$00
34A3: 18 34       JR   $34D9
34A5: F5          PUSH AF
34A6: E5          PUSH HL
34A7: 2A 6F 79    LD   HL,($796F)
34AA: 7E          LD   A,(HL)
34AB: 2B          DEC  HL
34AC: 16 00       LD   D,$00
34AE: 5E          LD   E,(HL)
34AF: CD 37 11    CALL $1137
34B2: 21 38 83    LD   HL,$8338
34B5: 19          ADD  HL,DE
34B6: 16 00       LD   D,$00
34B8: 5F          LD   E,A
34B9: 19          ADD  HL,DE
34BA: 11 55 56    LD   DE,$5655
34BD: CD 84 30    CALL $3084
34C0: EB          EX   DE,HL
34C1: E1          POP  HL
34C2: E5          PUSH HL
34C3: 01 06 00    LD   BC,$0006
34C6: 09          ADD  HL,BC
34C7: 73          LD   (HL),E
34C8: 23          INC  HL
34C9: 72          LD   (HL),D
34CA: E1          POP  HL
34CB: F1          POP  AF
34CC: 2B          DEC  HL
34CD: 36 FE       LD   (HL),$FE
34CF: 38 02       JR   C,$34D3
34D1: 36 02       LD   (HL),$02
34D3: 23          INC  HL
34D4: 23          INC  HL
34D5: 3A A6 78    LD   A,($78A6)
34D8: 77          LD   (HL),A
34D9: 3A A7 78    LD   A,($78A7)
34DC: 32 A7 78    LD   ($78A7),A
34DF: 3A 66 79    LD   A,($7966)
34E2: FE 01       CP   $01
34E4: 3A A7 78    LD   A,($78A7)
34E7: 20 0E       JR   NZ,$34F7
34E9: E6 06       AND  $06
34EB: FE 06       CP   $06
34ED: 3A A7 78    LD   A,($78A7)
34F0: 28 05       JR   Z,$34F7
34F2: 2A 67 79    LD   HL,($7967)
34F5: CB 8E       RES  1,(HL)
34F7: E1          POP  HL
34F8: D1          POP  DE
34F9: C1          POP  BC
34FA: C9          RET

34FB: 7E          LD   A,(HL)
34FC: F5          PUSH AF
34FD: CD 16 35    CALL $3516
3500: F1          POP  AF
3501: 11 04 00    LD   DE,$0004
3504: 19          ADD  HL,DE
3505: 5E          LD   E,(HL)
3506: BB          CP   E
3507: 38 08       JR   C,$3511
3509: 5F          LD   E,A
350A: 23          INC  HL
350B: 7E          LD   A,(HL)
350C: 23          INC  HL
350D: BB          CP   E
350E: 38 01       JR   C,$3511
3510: C9          RET

3511: F1          POP  AF
3512: E1          POP  HL
3513: C3 A4 32    JP   $32A4
3516: 3E 05       LD   A,$05
3518: 90          SUB  B
3519: 5F          LD   E,A
351A: 07          RLCA
351B: 07          RLCA
351C: 83          ADD  A,E
351D: 07          RLCA
351E: 16 00       LD   D,$00
3520: 5F          LD   E,A
3521: 21 6E 78    LD   HL,$786E
3524: 19          ADD  HL,DE
3525: C9          RET

3526: C5          PUSH BC
3527: 7E          LD   A,(HL)
3528: E6 70       AND  $70
352A: 0F          RRCA
352B: 0F          RRCA
352C: 0F          RRCA
352D: 0F          RRCA
352E: 47          LD   B,A
352F: 04          INC  B
3530: 7B          LD   A,E
3531: 0F          RRCA
3532: 10 FD       DJNZ $3531
3534: E6 01       AND  $01
3536: C1          POP  BC
3537: C9          RET

3538: F5          PUSH AF
3539: D5          PUSH DE
353A: E5          PUSH HL
353B: E5          PUSH HL
353C: 3A 65 79    LD   A,($7965)
353F: 47          LD   B,A
3540: 21 89 79    LD   HL,$7989
3543: 16 00       LD   D,$00
3545: 58          LD   E,B
3546: 19          ADD  HL,DE
3547: 35          DEC  (HL)
3548: 20 32       JR   NZ,$357C
354A: 3A 69 79    LD   A,($7969)
354D: FE DD       CP   $DD
354F: 0E 01       LD   C,$01
3551: 28 09       JR   Z,$355C
3553: 11 08 00    LD   DE,$0008
3556: 19          ADD  HL,DE
3557: 4E          LD   C,(HL)
3558: 11 F8 FF    LD   DE,$FFF8
355B: 19          ADD  HL,DE
355C: 71          LD   (HL),C
355D: 21 71 79    LD   HL,$7971
3560: 16 00       LD   D,$00
3562: 58          LD   E,B
3563: 19          ADD  HL,DE
3564: D1          POP  DE
3565: 7E          LD   A,(HL)
3566: FE 01       CP   $01
3568: 28 1B       JR   Z,$3585
356A: FE 02       CP   $02
356C: 28 21       JR   Z,$358F
356E: FE 03       CP   $03
3570: 28 2F       JR   Z,$35A1
3572: FE 04       CP   $04
3574: 28 6B       JR   Z,$35E1
3576: FE 05       CP   $05
3578: 28 51       JR   Z,$35CB
357A: 18 FE       JR   $357A
357C: E1          POP  HL
357D: 23          INC  HL
357E: 23          INC  HL
357F: 23          INC  HL
3580: 4E          LD   C,(HL)
3581: E1          POP  HL
3582: D1          POP  DE
3583: F1          POP  AF
3584: C9          RET

3585: 0E 84       LD   C,$84
3587: ED 5F       LD   A,R
3589: E6 01       AND  $01
358B: B1          OR   C
358C: 4F          LD   C,A
358D: 18 F2       JR   $3581
358F: 0E 84       LD   C,$84
3591: ED 5F       LD   A,R
3593: E6 11       AND  $11
3595: 20 04       JR   NZ,$359B
3597: 0E 88       LD   C,$88
3599: 18 E6       JR   $3581
359B: E6 01       AND  $01
359D: B1          OR   C
359E: 4F          LD   C,A
359F: 18 E0       JR   $3581
35A1: 13          INC  DE
35A2: 13          INC  DE
35A3: 13          INC  DE
35A4: 1A          LD   A,(DE)
35A5: 4F          LD   C,A
35A6: E6 06       AND  $06
35A8: FE 06       CP   $06
35AA: 20 15       JR   NZ,$35C1
35AC: 21 F9 FF    LD   HL,$FFF9
35AF: 19          ADD  HL,DE
35B0: 7E          LD   A,(HL)
35B1: E6 0F       AND  $0F
35B3: FE 0B       CP   $0B
35B5: 20 CA       JR   NZ,$3581
35B7: ED 5F       LD   A,R
35B9: E6 02       AND  $02
35BB: 20 C4       JR   NZ,$3581
35BD: 0E 84       LD   C,$84
35BF: 18 02       JR   $35C3
35C1: 0E 86       LD   C,$86
35C3: ED 5F       LD   A,R
35C5: E6 01       AND  $01
35C7: B1          OR   C
35C8: 4F          LD   C,A
35C9: 18 B6       JR   $3581
35CB: 3E 06       LD   A,$06
35CD: 32 6B 79    LD   ($796B),A
35D0: 3E 0E       LD   A,$0E
35D2: 32 6C 79    LD   ($796C),A
35D5: 3E 0A       LD   A,$0A
35D7: 32 6E 79    LD   ($796E),A
35DA: 3E 1E       LD   A,$1E
35DC: 32 6D 79    LD   ($796D),A
35DF: 18 14       JR   $35F5
35E1: 3E 02       LD   A,$02
35E3: 32 6B 79    LD   ($796B),A
35E6: 3E 04       LD   A,$04
35E8: 32 6C 79    LD   ($796C),A
35EB: 3E 0B       LD   A,$0B
35ED: 32 6E 79    LD   ($796E),A
35F0: 3E 2D       LD   A,$2D
35F2: 32 6D 79    LD   ($796D),A
35F5: 21 FB FF    LD   HL,$FFFB
35F8: 19          ADD  HL,DE
35F9: 06 05       LD   B,$05
35FB: 11 95 36    LD   DE,$3695
35FE: 1A          LD   A,(DE)
35FF: BE          CP   (HL)
3600: 28 51       JR   Z,$3653
3602: 13          INC  DE
3603: 10 F9       DJNZ $35FE
3605: ED 5F       LD   A,R
3607: E6 06       AND  $06
3609: 28 43       JR   Z,$364E
360B: 3A 00 78    LD   A,($7800)
360E: 96          SUB  (HL)
360F: 06 01       LD   B,$01
3611: 30 03       JR   NC,$3616
3613: 05          DEC  B
3614: ED 44       NEG
3616: 4F          LD   C,A
3617: 3A 6D 79    LD   A,($796D)
361A: B9          CP   C
361B: 38 2A       JR   C,$3647
361D: ED 5F       LD   A,R
361F: 47          LD   B,A
3620: 11 08 00    LD   DE,$0008
3623: 19          ADD  HL,DE
3624: 7E          LD   A,(HL)
3625: CB 57       BIT  2,A
3627: 20 05       JR   NZ,$362E
3629: 0E 84       LD   C,$84
362B: C3 C3 35    JP   $35C3
362E: E6 01       AND  $01
3630: 4F          LD   C,A
3631: 3A 6E 79    LD   A,($796E)
3634: A0          AND  B
3635: 20 09       JR   NZ,$3640
3637: 3E 84       LD   A,$84
3639: B1          OR   C
363A: EE 01       XOR  $01
363C: 4F          LD   C,A
363D: C3 81 35    JP   $3581
3640: 3E 84       LD   A,$84
3642: B1          OR   C
3643: 4F          LD   C,A
3644: C3 81 35    JP   $3581
3647: 3E 84       LD   A,$84
3649: B0          OR   B
364A: 4F          LD   C,A
364B: C3 81 35    JP   $3581
364E: 0E 88       LD   C,$88
3650: C3 81 35    JP   $3581
3653: ED 5F       LD   A,R
3655: 47          LD   B,A
3656: 3A 6B 79    LD   A,($796B)
3659: A0          AND  B
365A: 28 AF       JR   Z,$360B
365C: 23          INC  HL
365D: 4E          LD   C,(HL)
365E: 11 07 00    LD   DE,$0007
3661: 19          ADD  HL,DE
3662: 7E          LD   A,(HL)
3663: E6 06       AND  $06
3665: FE 06       CP   $06
3667: 20 18       JR   NZ,$3681
3669: 79          LD   A,C
366A: E6 0F       AND  $0F
366C: FE 0B       CP   $0B
366E: 4E          LD   C,(HL)
366F: C2 81 35    JP   NZ,$3581
3672: ED 5F       LD   A,R
3674: 47          LD   B,A
3675: 3A 6C 79    LD   A,($796C)
3678: A0          AND  B
3679: C2 81 35    JP   NZ,$3581
367C: 0E 84       LD   C,$84
367E: C3 C3 35    JP   $35C3
3681: 3A 01 78    LD   A,($7801)
3684: 91          SUB  C
3685: 06 01       LD   B,$01
3687: CB 7F       BIT  7,A
3689: 28 03       JR   Z,$368E
368B: 05          DEC  B
368C: ED 44       NEG
368E: 3E 86       LD   A,$86
3690: B0          OR   B
3691: 4F          LD   C,A
3692: C3 81 35    JP   $3581
3695: 15          DEC  D
3696: 42          LD   B,D
3697: 6F          LD   L,A
3698: 9C          SBC  A,H
3699: C9          RET

369A: C5          PUSH BC
369B: 06 08       LD   B,$08
369D: CB 77       BIT  6,A
369F: 20 17       JR   NZ,$36B8
36A1: 05          DEC  B
36A2: CB 6F       BIT  5,A
36A4: 20 12       JR   NZ,$36B8
36A6: 05          DEC  B
36A7: CB 67       BIT  4,A
36A9: 20 0D       JR   NZ,$36B8
36AB: 05          DEC  B
36AC: CB 5F       BIT  3,A
36AE: 20 08       JR   NZ,$36B8
36B0: 05          DEC  B
36B1: CB 57       BIT  2,A
36B3: 28 03       JR   Z,$36B8
36B5: E6 03       AND  $03
36B7: 47          LD   B,A
36B8: 78          LD   A,B
36B9: C1          POP  BC
36BA: C9          RET

36BB: 3E FF       LD   A,$FF
36BD: BA          CP   D
36BE: C0          RET  NZ

36BF: 18 FE       JR   $36BF
36C1: FF          RST  $38
36C2: FF          RST  $38
36C3: CD 36 DF    CALL $DF36
36C6: 36 F1       LD   (HL),$F1
36C8: 36 03       LD   (HL),$03
36CA: 37          SCF
36CB: 15          DEC  D
36CC: 37          SCF
36CD: 39          ADD  HL,SP
36CE: 37          SCF
36CF: 76          HALT
36D0: 37          SCF
36D1: C1          POP  BC
36D2: 36 C1       LD   (HL),$C1
36D4: 36 B3       LD   (HL),$B3
36D6: 37          SCF
36D7: C1          POP  BC
36D8: 36 C1       LD   (HL),$C1
36DA: 36 CC       LD   (HL),$CC
36DC: 37          SCF
36DD: 15          DEC  D
36DE: 38 56       JR   C,$3736
36E0: 38 7F       JR   C,$3761
36E2: 38 C1       JR   C,$36A5
36E4: 36 C1       LD   (HL),$C1
36E6: 36 A8       LD   (HL),$A8
36E8: 38 3B       JR   C,$3725
36EA: 39          ADD  HL,SP
36EB: C1          POP  BC
36EC: 36 B9       LD   (HL),$B9
36EE: 38 FA       JR   C,$36EA
36F0: 38 5C       JR   C,$374E
36F2: 39          ADD  HL,SP
36F3: 99          SBC  A,C
36F4: 39          ADD  HL,SP
36F5: 81          ADD  A,C
36F6: 3A 8A 3A    LD   A,($3A8A)
36F9: D6 39       SUB  $39
36FB: C1          POP  BC
36FC: 36 C1       LD   (HL),$C1
36FE: 36 EF       LD   (HL),$EF
3700: 39          ADD  HL,SP
3701: 40          LD   B,B
3702: 3A 93 3A    LD   A,($3A93)
3705: D0          RET  NC

3706: 3A A0 3B    LD   A,($3BA0)
3709: A9          XOR  C
370A: 3B          DEC  SP
370B: 0D          DEC  C
370C: 3B          DEC  SP
370D: B2          OR   D
370E: 3B          DEC  SP
370F: C1          POP  BC
3710: 36 26       LD   (HL),$26
3712: 3B          DEC  SP
3713: 5F          LD   E,A
3714: 3B          DEC  SP
3715: D3 3B       OUT  ($3B),A
3717: 10 3C       DJNZ $3755
3719: E0          RET  PO

371A: 3C          INC  A
371B: E9          JP   (HL)
371C: 3C          INC  A
371D: 4D          LD   C,L
371E: 3C          INC  A
371F: F2 3C C1    JP   P,$C13C
3722: 36 66       LD   (HL),$66
3724: 3C          INC  A
3725: 9F          SBC  A,A
3726: 3C          INC  A
3727: 13          INC  DE
3728: 3D          DEC  A
3729: 50          LD   D,B
372A: 3D          DEC  A
372B: 8D          ADC  A,L
372C: 3D          DEC  A
372D: 96          SUB  (HL)
372E: 3D          DEC  A
372F: 9F          SBC  A,A
3730: 3D          DEC  A
3731: B0          OR   B
3732: 3D          DEC  A
3733: D5          PUSH DE
3734: 3D          DEC  A
3735: C1          POP  BC
3736: 36 C1       LD   (HL),$C1
3738: 36 4D       LD   (HL),$4D
373A: 5D          LD   E,L
373B: 00          NOP
373C: 00          NOP
373D: 00          NOP
373E: 00          NOP
373F: 00          NOP
3740: 00          NOP
3741: 4D          LD   C,L
3742: D7          RST  $10
3743: FE 68       CP   $68
3745: 00          NOP
3746: FD 00       DB   $FD
3748: 00          NOP
3749: 4E          LD   C,(HL)
374A: 69          LD   L,C
374B: FE 68       CP   $68
374D: 00          NOP
374E: FD 00       DB   $FD
3750: 00          NOP
3751: 4E          LD   C,(HL)
3752: FB          EI
3753: FE 68       CP   $68
3755: 00          NOP
3756: FD 00       DB   $FD
3758: 00          NOP
3759: 4F          LD   C,A
375A: 8D          ADC  A,L
375B: FE 68       CP   $68
375D: 00          NOP
375E: FD 00       DB   $FD
3760: 00          NOP
3761: 50          LD   D,B
3762: 1F          RRA
3763: FE 68       CP   $68
3765: 00          NOP
3766: FD 00       DB   $FD
3768: 00          NOP
3769: DD 03       DB   $DD
376B: CC D5 4D    CALL Z,$4DD5
376E: 5D          LD   E,L
376F: 00          NOP
3770: 00          NOP
3771: 00          NOP
3772: 00          NOP
3773: 00          NOP
3774: 00          NOP
3775: EE 4D       XOR  $4D
3777: 5D          LD   E,L
3778: 00          NOP
3779: 00          NOP
377A: 00          NOP
377B: 00          NOP
377C: 00          NOP
377D: 00          NOP
377E: 4D          LD   C,L
377F: D7          RST  $10
3780: 01 98 00    LD   BC,$0098
3783: 03          INC  BC
3784: FE 68       CP   $68
3786: 4E          LD   C,(HL)
3787: 69          LD   L,C
3788: 01 98 00    LD   BC,$0098
378B: 03          INC  BC
378C: FE 68       CP   $68
378E: 4E          LD   C,(HL)
378F: FB          EI
3790: 01 98 00    LD   BC,$0098
3793: 03          INC  BC
3794: FE 68       CP   $68
3796: 4F          LD   C,A
3797: 8D          ADC  A,L
3798: 01 98 00    LD   BC,$0098
379B: 03          INC  BC
379C: FE 68       CP   $68
379E: 50          LD   D,B
379F: 1F          RRA
37A0: 01 98 00    LD   BC,$0098
37A3: 03          INC  BC
37A4: FE 68       CP   $68
37A6: DD 03       DB   $DD
37A8: CC D5 4D    CALL Z,$4DD5
37AB: 5D          LD   E,L
37AC: 00          NOP
37AD: 00          NOP
37AE: 00          NOP
37AF: 00          NOP
37B0: 00          NOP
37B1: 00          NOP
37B2: EE 42       XOR  $42
37B4: D7          RST  $10
37B5: 00          NOP
37B6: 00          NOP
37B7: 00          NOP
37B8: 00          NOP
37B9: 00          NOP
37BA: 00          NOP
37BB: 4C          LD   C,H
37BC: E3          EX   (SP),HL
37BD: 00          NOP
37BE: 00          NOP
37BF: 00          NOP
37C0: 00          NOP
37C1: 00          NOP
37C2: 00          NOP
37C3: 4C          LD   C,H
37C4: E3          EX   (SP),HL
37C5: 00          NOP
37C6: 00          NOP
37C7: 00          NOP
37C8: 00          NOP
37C9: 00          NOP
37CA: 00          NOP
37CB: EE 51       XOR  $51
37CD: 2B          DEC  HL
37CE: 00          NOP
37CF: 00          NOP
37D0: 00          NOP
37D1: 00          NOP
37D2: 00          NOP
37D3: 00          NOP
37D4: 42          LD   B,D
37D5: D7          RST  $10
37D6: 00          NOP
37D7: 00          NOP
37D8: 00          NOP
37D9: 00          NOP
37DA: 00          NOP
37DB: 00          NOP
37DC: 42          LD   B,D
37DD: D7          RST  $10
37DE: 00          NOP
37DF: 00          NOP
37E0: 00          NOP
37E1: 00          NOP
37E2: 00          NOP
37E3: 00          NOP
37E4: 51          LD   D,C
37E5: 2B          DEC  HL
37E6: 00          NOP
37E7: 00          NOP
37E8: 00          NOP
37E9: 00          NOP
37EA: 00          NOP
37EB: 00          NOP
37EC: 42          LD   B,D
37ED: D7          RST  $10
37EE: 00          NOP
37EF: 00          NOP
37F0: 00          NOP
37F1: 00          NOP
37F2: 00          NOP
37F3: 00          NOP
37F4: 51          LD   D,C
37F5: 2B          DEC  HL
37F6: 00          NOP
37F7: 00          NOP
37F8: 00          NOP
37F9: 00          NOP
37FA: 00          NOP
37FB: 00          NOP
37FC: 42          LD   B,D
37FD: D7          RST  $10
37FE: 00          NOP
37FF: 00          NOP
3800: 00          NOP
3801: 00          NOP
3802: 00          NOP
3803: 00          NOP
3804: 42          LD   B,D
3805: D7          RST  $10
3806: 00          NOP
3807: 00          NOP
3808: 00          NOP
3809: 00          NOP
380A: 00          NOP
380B: 00          NOP
380C: 51          LD   D,C
380D: 2B          DEC  HL
380E: 00          NOP
380F: 00          NOP
3810: 00          NOP
3811: 00          NOP
3812: 00          NOP
3813: 00          NOP
3814: EE 50       XOR  $50
3816: B1          OR   C
3817: 00          NOP
3818: 00          NOP
3819: 00          NOP
381A: 00          NOP
381B: 00          NOP
381C: 00          NOP
381D: 42          LD   B,D
381E: D7          RST  $10
381F: 00          NOP
3820: 00          NOP
3821: 00          NOP
3822: 00          NOP
3823: 00          NOP
3824: 00          NOP
3825: 42          LD   B,D
3826: D7          RST  $10
3827: 00          NOP
3828: 00          NOP
3829: 00          NOP
382A: 00          NOP
382B: 00          NOP
382C: 00          NOP
382D: 42          LD   B,D
382E: D7          RST  $10
382F: 00          NOP
3830: 00          NOP
3831: 00          NOP
3832: 00          NOP
3833: 00          NOP
3834: 00          NOP
3835: 42          LD   B,D
3836: D7          RST  $10
3837: 00          NOP
3838: 00          NOP
3839: 00          NOP
383A: 00          NOP
383B: 00          NOP
383C: 00          NOP
383D: 42          LD   B,D
383E: D7          RST  $10
383F: 00          NOP
3840: 00          NOP
3841: 00          NOP
3842: 00          NOP
3843: 00          NOP
3844: 00          NOP
3845: 50          LD   D,B
3846: B1          OR   C
3847: 00          NOP
3848: 00          NOP
3849: 00          NOP
384A: 00          NOP
384B: 00          NOP
384C: 00          NOP
384D: 4C          LD   C,H
384E: 69          LD   L,C
384F: 00          NOP
3850: 00          NOP
3851: 00          NOP
3852: 00          NOP
3853: 00          NOP
3854: 00          NOP
3855: EE 52       XOR  $52
3857: 90          SUB  B
3858: FE 68       CP   $68
385A: 00          NOP
385B: FD 00       DB   $FD
385D: 00          NOP
385E: 53          LD   D,E
385F: 34          INC  (HL)
3860: FE 68       CP   $68
3862: 00          NOP
3863: FD 00       DB   $FD
3865: 00          NOP
3866: 52          LD   D,D
3867: 10 FE       DJNZ $3867
3869: 68          LD   L,B
386A: 00          NOP
386B: FD 00       DB   $FD
386D: 00          NOP
386E: 53          LD   D,E
386F: D8          RET  C

3870: FE 68       CP   $68
3872: 00          NOP
3873: FD 00       DB   $FD
3875: 00          NOP
3876: 54          LD   D,H
3877: 58          LD   E,B
3878: FE 68       CP   $68
387A: 00          NOP
387B: FD 00       DB   $FD
387D: 00          NOP
387E: EE 52       XOR  $52
3880: 90          SUB  B
3881: 01 98 00    LD   BC,$0098
3884: 03          INC  BC
3885: FE 68       CP   $68
3887: 53          LD   D,E
3888: 34          INC  (HL)
3889: 01 98 00    LD   BC,$0098
388C: 03          INC  BC
388D: FE 68       CP   $68
388F: 52          LD   D,D
3890: 10 01       DJNZ $3893
3892: 98          SBC  A,B
3893: 00          NOP
3894: 03          INC  BC
3895: FE 68       CP   $68
3897: 53          LD   D,E
3898: D8          RET  C

3899: 01 98 00    LD   BC,$0098
389C: 03          INC  BC
389D: FE 68       CP   $68
389F: 54          LD   D,H
38A0: 58          LD   E,B
38A1: 01 98 00    LD   BC,$0098
38A4: 03          INC  BC
38A5: FE 68       CP   $68
38A7: EE 42       XOR  $42
38A9: D7          RST  $10
38AA: 00          NOP
38AB: 00          NOP
38AC: 00          NOP
38AD: 00          NOP
38AE: 00          NOP
38AF: 00          NOP
38B0: 42          LD   B,D
38B1: D7          RST  $10
38B2: 00          NOP
38B3: 00          NOP
38B4: 00          NOP
38B5: 00          NOP
38B6: 00          NOP
38B7: 00          NOP
38B8: EE 55       XOR  $55
38BA: DB 00       IN   A,($00)
38BC: 00          NOP
38BD: 00          NOP
38BE: 00          NOP
38BF: 00          NOP
38C0: 00          NOP
38C1: 42          LD   B,D
38C2: D7          RST  $10
38C3: 00          NOP
38C4: 00          NOP
38C5: 00          NOP
38C6: 00          NOP
38C7: 00          NOP
38C8: 00          NOP
38C9: 55          LD   D,L
38CA: DB 00       IN   A,($00)
38CC: 00          NOP
38CD: 00          NOP
38CE: 00          NOP
38CF: 00          NOP
38D0: 00          NOP
38D1: 42          LD   B,D
38D2: D7          RST  $10
38D3: 00          NOP
38D4: 00          NOP
38D5: 00          NOP
38D6: 00          NOP
38D7: 00          NOP
38D8: 00          NOP
38D9: 42          LD   B,D
38DA: D7          RST  $10
38DB: 00          NOP
38DC: 00          NOP
38DD: 00          NOP
38DE: 00          NOP
38DF: 00          NOP
38E0: 00          NOP
38E1: 55          LD   D,L
38E2: DB 00       IN   A,($00)
38E4: 00          NOP
38E5: 00          NOP
38E6: 00          NOP
38E7: 00          NOP
38E8: 00          NOP
38E9: 42          LD   B,D
38EA: D7          RST  $10
38EB: 00          NOP
38EC: 00          NOP
38ED: 00          NOP
38EE: 00          NOP
38EF: 00          NOP
38F0: 00          NOP
38F1: 55          LD   D,L
38F2: DB 00       IN   A,($00)
38F4: 00          NOP
38F5: 00          NOP
38F6: 00          NOP
38F7: 00          NOP
38F8: 00          NOP
38F9: EE 55       XOR  $55
38FB: 70          LD   (HL),B
38FC: 00          NOP
38FD: 00          NOP
38FE: 00          NOP
38FF: 00          NOP
3900: 00          NOP
3901: 00          NOP
3902: 42          LD   B,D
3903: D7          RST  $10
3904: 00          NOP
3905: 00          NOP
3906: 00          NOP
3907: 00          NOP
3908: 00          NOP
3909: 00          NOP
390A: 42          LD   B,D
390B: D7          RST  $10
390C: 00          NOP
390D: 00          NOP
390E: 00          NOP
390F: 00          NOP
3910: 00          NOP
3911: 00          NOP
3912: 42          LD   B,D
3913: D7          RST  $10
3914: 00          NOP
3915: 00          NOP
3916: 00          NOP
3917: 00          NOP
3918: 00          NOP
3919: 00          NOP
391A: 42          LD   B,D
391B: D7          RST  $10
391C: 00          NOP
391D: 00          NOP
391E: 00          NOP
391F: 00          NOP
3920: 00          NOP
3921: 00          NOP
3922: 42          LD   B,D
3923: D7          RST  $10
3924: 00          NOP
3925: 00          NOP
3926: 00          NOP
3927: 00          NOP
3928: 00          NOP
3929: 00          NOP
392A: 55          LD   D,L
392B: 70          LD   (HL),B
392C: 00          NOP
392D: 00          NOP
392E: 00          NOP
392F: 00          NOP
3930: 00          NOP
3931: 00          NOP
3932: 51          LD   D,C
3933: A5          AND  L
3934: 00          NOP
3935: 00          NOP
3936: 00          NOP
3937: 00          NOP
3938: 00          NOP
3939: 00          NOP
393A: EE 54       XOR  $54
393C: D8          RET  C

393D: 00          NOP
393E: 00          NOP
393F: 00          NOP
3940: 00          NOP
3941: 00          NOP
3942: 00          NOP
3943: 42          LD   B,D
3944: D7          RST  $10
3945: 00          NOP
3946: 00          NOP
3947: 00          NOP
3948: 00          NOP
3949: 00          NOP
394A: 00          NOP
394B: 42          LD   B,D
394C: D7          RST  $10
394D: 00          NOP
394E: 00          NOP
394F: 00          NOP
3950: 00          NOP
3951: 00          NOP
3952: 00          NOP
3953: 54          LD   D,H
3954: D8          RET  C

3955: 00          NOP
3956: 00          NOP
3957: 00          NOP
3958: 00          NOP
3959: 00          NOP
395A: 00          NOP
395B: EE 5C       XOR  $5C
395D: 74          LD   (HL),H
395E: 00          NOP
395F: 00          NOP
3960: 00          NOP
3961: 00          NOP
3962: 00          NOP
3963: 00          NOP
3964: 5F          LD   E,A
3965: C0          RET  NZ

3966: FE 68       CP   $68
3968: 00          NOP
3969: FD 00       DB   $FD
396B: 00          NOP
396C: 5D          LD   E,L
396D: 0C          INC  C
396E: FE 68       CP   $68
3970: 00          NOP
3971: FD 00       DB   $FD
3973: 00          NOP
3974: 5D          LD   E,L
3975: C2 FE 68    JP   NZ,$68FE
3978: 00          NOP
3979: FD 00       DB   $FD
397B: 00          NOP
397C: 5E          LD   E,(HL)
397D: 78          LD   A,B
397E: FE 68       CP   $68
3980: 00          NOP
3981: FD 00       DB   $FD
3983: 00          NOP
3984: 5F          LD   E,A
3985: 2E FE       LD   L,$FE
3987: 68          LD   L,B
3988: 00          NOP
3989: FD 00       DB   $FD
398B: 00          NOP
398C: DD 03       DB   $DD
398E: CC D5 5C    CALL Z,$5CD5
3991: 74          LD   (HL),H
3992: 00          NOP
3993: 00          NOP
3994: 00          NOP
3995: 00          NOP
3996: 00          NOP
3997: 00          NOP
3998: EE 5C       XOR  $5C
399A: 74          LD   (HL),H
399B: 00          NOP
399C: 00          NOP
399D: 00          NOP
399E: 00          NOP
399F: 00          NOP
39A0: 00          NOP
39A1: 5F          LD   E,A
39A2: C0          RET  NZ

39A3: 01 98 00    LD   BC,$0098
39A6: 03          INC  BC
39A7: FE 68       CP   $68
39A9: 5D          LD   E,L
39AA: 0C          INC  C
39AB: 01 98 00    LD   BC,$0098
39AE: 03          INC  BC
39AF: FE 68       CP   $68
39B1: 5D          LD   E,L
39B2: C2 01 98    JP   NZ,$9801
39B5: 00          NOP
39B6: 03          INC  BC
39B7: FE 68       CP   $68
39B9: 5E          LD   E,(HL)
39BA: 78          LD   A,B
39BB: 01 98 00    LD   BC,$0098
39BE: 03          INC  BC
39BF: FE 68       CP   $68
39C1: 5F          LD   E,A
39C2: 2E 01       LD   L,$01
39C4: 98          SBC  A,B
39C5: 00          NOP
39C6: 03          INC  BC
39C7: FE 68       CP   $68
39C9: DD 03       DB   $DD
39CB: CC D5 5C    CALL Z,$5CD5
39CE: 74          LD   (HL),H
39CF: 00          NOP
39D0: 00          NOP
39D1: 00          NOP
39D2: 00          NOP
39D3: 00          NOP
39D4: 00          NOP
39D5: EE 42       XOR  $42
39D7: D7          RST  $10
39D8: 00          NOP
39D9: 00          NOP
39DA: 00          NOP
39DB: 00          NOP
39DC: 00          NOP
39DD: 00          NOP
39DE: 5B          LD   E,E
39DF: DC 00 00    CALL C,$0000
39E2: 00          NOP
39E3: 00          NOP
39E4: 00          NOP
39E5: 00          NOP
39E6: 5B          LD   E,E
39E7: DC 00 00    CALL C,$0000
39EA: 00          NOP
39EB: 00          NOP
39EC: 00          NOP
39ED: 00          NOP
39EE: EE 60       XOR  $60
39F0: 76          HALT
39F1: 00          NOP
39F2: 00          NOP
39F3: 00          NOP
39F4: 00          NOP
39F5: 00          NOP
39F6: 00          NOP
39F7: 42          LD   B,D
39F8: D7          RST  $10
39F9: 00          NOP
39FA: 00          NOP
39FB: 00          NOP
39FC: 00          NOP
39FD: 00          NOP
39FE: 00          NOP
39FF: 42          LD   B,D
3A00: D7          RST  $10
3A01: 00          NOP
3A02: 00          NOP
3A03: 00          NOP
3A04: 00          NOP
3A05: 00          NOP
3A06: 00          NOP
3A07: 60          LD   H,B
3A08: 76          HALT
3A09: 00          NOP
3A0A: 00          NOP
3A0B: 00          NOP
3A0C: 00          NOP
3A0D: 00          NOP
3A0E: 00          NOP
3A0F: 42          LD   B,D
3A10: D7          RST  $10
3A11: 00          NOP
3A12: 00          NOP
3A13: 00          NOP
3A14: 00          NOP
3A15: 00          NOP
3A16: 00          NOP
3A17: 42          LD   B,D
3A18: D7          RST  $10
3A19: 00          NOP
3A1A: 00          NOP
3A1B: 00          NOP
3A1C: 00          NOP
3A1D: 00          NOP
3A1E: 00          NOP
3A1F: 60          LD   H,B
3A20: 76          HALT
3A21: 00          NOP
3A22: 00          NOP
3A23: 00          NOP
3A24: 00          NOP
3A25: 00          NOP
3A26: 00          NOP
3A27: 42          LD   B,D
3A28: D7          RST  $10
3A29: 00          NOP
3A2A: 00          NOP
3A2B: 00          NOP
3A2C: 00          NOP
3A2D: 00          NOP
3A2E: 00          NOP
3A2F: 42          LD   B,D
3A30: D7          RST  $10
3A31: 00          NOP
3A32: 00          NOP
3A33: 00          NOP
3A34: 00          NOP
3A35: 00          NOP
3A36: 00          NOP
3A37: 60          LD   H,B
3A38: 76          HALT
3A39: 00          NOP
3A3A: 00          NOP
3A3B: 00          NOP
3A3C: 00          NOP
3A3D: 00          NOP
3A3E: 00          NOP
3A3F: EE 61       XOR  $61
3A41: 0E 00       LD   C,$00
3A43: 00          NOP
3A44: 00          NOP
3A45: 00          NOP
3A46: 00          NOP
3A47: 00          NOP
3A48: 42          LD   B,D
3A49: D7          RST  $10
3A4A: 00          NOP
3A4B: 00          NOP
3A4C: 00          NOP
3A4D: 00          NOP
3A4E: 00          NOP
3A4F: 00          NOP
3A50: 42          LD   B,D
3A51: D7          RST  $10
3A52: 00          NOP
3A53: 00          NOP
3A54: 00          NOP
3A55: 00          NOP
3A56: 00          NOP
3A57: 00          NOP
3A58: 42          LD   B,D
3A59: D7          RST  $10
3A5A: 00          NOP
3A5B: 00          NOP
3A5C: 00          NOP
3A5D: 00          NOP
3A5E: 00          NOP
3A5F: 00          NOP
3A60: 42          LD   B,D
3A61: D7          RST  $10
3A62: 00          NOP
3A63: 00          NOP
3A64: 00          NOP
3A65: 00          NOP
3A66: 00          NOP
3A67: 00          NOP
3A68: 42          LD   B,D
3A69: D7          RST  $10
3A6A: 00          NOP
3A6B: 00          NOP
3A6C: 00          NOP
3A6D: 00          NOP
3A6E: 00          NOP
3A6F: 00          NOP
3A70: 61          LD   H,C
3A71: 0E 00       LD   C,$00
3A73: 00          NOP
3A74: 00          NOP
3A75: 00          NOP
3A76: 00          NOP
3A77: 00          NOP
3A78: 5B          LD   E,E
3A79: 44          LD   B,H
3A7A: 00          NOP
3A7B: 00          NOP
3A7C: 00          NOP
3A7D: 00          NOP
3A7E: 00          NOP
3A7F: 00          NOP
3A80: EE 61       XOR  $61
3A82: A6          AND  (HL)
3A83: FF          RST  $38
3A84: FE FE       CP   $FE
3A86: 00          NOP
3A87: 00          NOP
3A88: 00          NOP
3A89: EE 61       XOR  $61
3A8B: A6          AND  (HL)
3A8C: 00          NOP
3A8D: 02          LD   (BC),A
3A8E: 02          LD   (BC),A
3A8F: 00          NOP
3A90: FF          RST  $38
3A91: FE EE       CP   $EE
3A93: 63          LD   H,E
3A94: CA 00 00    JP   Z,$0000
3A97: 00          NOP
3A98: 00          NOP
3A99: 00          NOP
3A9A: 00          NOP
3A9B: 66          LD   H,(HL)
3A9C: A4          AND  H
3A9D: FE 68       CP   $68
3A9F: 00          NOP
3AA0: FD FF       DB   $FD
3AA2: 78          LD   A,B
3AA3: 64          LD   H,H
3AA4: 44          LD   B,H
3AA5: FE 68       CP   $68
3AA7: 00          NOP
3AA8: FD 00       DB   $FD
3AAA: 00          NOP
3AAB: 64          LD   H,H
3AAC: D6 FE       SUB  $FE
3AAE: 68          LD   L,B
3AAF: 00          NOP
3AB0: FD 00       DB   $FD
3AB2: 00          NOP
3AB3: 65          LD   H,L
3AB4: 70          LD   (HL),B
3AB5: FE 68       CP   $68
3AB7: 00          NOP
3AB8: FD 00       DB   $FD
3ABA: 00          NOP
3ABB: 66          LD   H,(HL)
3ABC: 0A          LD   A,(BC)
3ABD: FE 68       CP   $68
3ABF: 00          NOP
3AC0: FD 00       DB   $FD
3AC2: 00          NOP
3AC3: DD 03       DB   $DD
3AC5: CC D5 63    CALL Z,$63D5
3AC8: CA 00 00    JP   Z,$0000
3ACB: 00          NOP
3ACC: 00          NOP
3ACD: 00          NOP
3ACE: 00          NOP
3ACF: EE 63       XOR  $63
3AD1: CA 00 00    JP   Z,$0000
3AD4: 00          NOP
3AD5: 00          NOP
3AD6: 00          NOP
3AD7: 00          NOP
3AD8: 66          LD   H,(HL)
3AD9: A4          AND  H
3ADA: 01 98 00    LD   BC,$0098
3ADD: 03          INC  BC
3ADE: FE 68       CP   $68
3AE0: 64          LD   H,H
3AE1: 44          LD   B,H
3AE2: 01 98 00    LD   BC,$0098
3AE5: 03          INC  BC
3AE6: FE 68       CP   $68
3AE8: 64          LD   H,H
3AE9: D6 01       SUB  $01
3AEB: 98          SBC  A,B
3AEC: 00          NOP
3AED: 03          INC  BC
3AEE: FD E0       DB   $FD				;This does not appear to be a valid instruction

3AF0: 65          LD   H,L
3AF1: 70          LD   (HL),B
3AF2: 01 98 00    LD   BC,$0098
3AF5: 03          INC  BC
3AF6: FD E0       DB   $FD				;This does not appear to be a valid instruction

3AF8: 66          LD   H,(HL)
3AF9: 0A          LD   A,(BC)
3AFA: 01 98 00    LD   BC,$0098
3AFD: 03          INC  BC
3AFE: FD E0       DB   $FD				;This does not appear to be a valid instruction

3B00: DD 03       DB   $DD
3B02: CC D5 63    CALL Z,$63D5
3B05: CA 00 00    JP   Z,$0000
3B08: 00          NOP
3B09: 00          NOP
3B0A: 00          NOP
3B0B: 00          NOP
3B0C: EE 42       XOR  $42
3B0E: D7          RST  $10
3B0F: 00          NOP
3B10: 00          NOP
3B11: 00          NOP
3B12: 00          NOP
3B13: 00          NOP
3B14: 00          NOP
3B15: 63          LD   H,E
3B16: 50          LD   D,B
3B17: 00          NOP
3B18: 00          NOP
3B19: 00          NOP
3B1A: 00          NOP
3B1B: 00          NOP
3B1C: 00          NOP
3B1D: 63          LD   H,E
3B1E: 50          LD   D,B
3B1F: 00          NOP
3B20: 00          NOP
3B21: 00          NOP
3B22: 00          NOP
3B23: 00          NOP
3B24: 00          NOP
3B25: EE 67       XOR  $67
3B27: D6 00       SUB  $00
3B29: 00          NOP
3B2A: 00          NOP
3B2B: 00          NOP
3B2C: 00          NOP
3B2D: 00          NOP
3B2E: 42          LD   B,D
3B2F: D7          RST  $10
3B30: 00          NOP
3B31: 00          NOP
3B32: 00          NOP
3B33: 00          NOP
3B34: 00          NOP
3B35: 00          NOP
3B36: 67          LD   H,A
3B37: D6 00       SUB  $00
3B39: 00          NOP
3B3A: 00          NOP
3B3B: 00          NOP
3B3C: 00          NOP
3B3D: 00          NOP
3B3E: 42          LD   B,D
3B3F: D7          RST  $10
3B40: 00          NOP
3B41: 00          NOP
3B42: 00          NOP
3B43: 00          NOP
3B44: 00          NOP
3B45: 00          NOP
3B46: 67          LD   H,A
3B47: D6 00       SUB  $00
3B49: 00          NOP
3B4A: 00          NOP
3B4B: 00          NOP
3B4C: 00          NOP
3B4D: 00          NOP
3B4E: 42          LD   B,D
3B4F: D7          RST  $10
3B50: 00          NOP
3B51: 00          NOP
3B52: 00          NOP
3B53: 00          NOP
3B54: 00          NOP
3B55: 00          NOP
3B56: 67          LD   H,A
3B57: D6 00       SUB  $00
3B59: 00          NOP
3B5A: 00          NOP
3B5B: 00          NOP
3B5C: 00          NOP
3B5D: 00          NOP
3B5E: EE 68       XOR  $68
3B60: 41          LD   B,C
3B61: 00          NOP
3B62: 00          NOP
3B63: 00          NOP
3B64: 00          NOP
3B65: 00          NOP
3B66: 00          NOP
3B67: 42          LD   B,D
3B68: D7          RST  $10
3B69: 00          NOP
3B6A: 00          NOP
3B6B: 00          NOP
3B6C: 00          NOP
3B6D: 00          NOP
3B6E: 00          NOP
3B6F: 42          LD   B,D
3B70: D7          RST  $10
3B71: 00          NOP
3B72: 00          NOP
3B73: 00          NOP
3B74: 00          NOP
3B75: 00          NOP
3B76: 00          NOP
3B77: 42          LD   B,D
3B78: D7          RST  $10
3B79: 00          NOP
3B7A: 00          NOP
3B7B: 00          NOP
3B7C: 00          NOP
3B7D: 00          NOP
3B7E: 00          NOP
3B7F: 42          LD   B,D
3B80: D7          RST  $10
3B81: 00          NOP
3B82: 00          NOP
3B83: 00          NOP
3B84: 00          NOP
3B85: 00          NOP
3B86: 00          NOP
3B87: 42          LD   B,D
3B88: D7          RST  $10
3B89: 00          NOP
3B8A: 00          NOP
3B8B: 00          NOP
3B8C: 00          NOP
3B8D: 00          NOP
3B8E: 00          NOP
3B8F: 68          LD   L,B
3B90: 41          LD   B,C
3B91: 00          NOP
3B92: 00          NOP
3B93: 00          NOP
3B94: 00          NOP
3B95: 00          NOP
3B96: 00          NOP
3B97: 62          LD   H,D
3B98: 5C          LD   E,H
3B99: 00          NOP
3B9A: 00          NOP
3B9B: 00          NOP
3B9C: 00          NOP
3B9D: 00          NOP
3B9E: 00          NOP
3B9F: EE 62       XOR  $62
3BA1: C7          RST  $00
3BA2: FF          RST  $38
3BA3: FE FE       CP   $FE
3BA5: 00          NOP
3BA6: 00          NOP
3BA7: 00          NOP
3BA8: EE 62       XOR  $62
3BAA: C7          RST  $00
3BAB: 00          NOP
3BAC: 02          LD   (BC),A
3BAD: 02          LD   (BC),A
3BAE: 00          NOP
3BAF: FF          RST  $38
3BB0: FE EE       CP   $EE
3BB2: 67          LD   H,A
3BB3: 3E 00       LD   A,$00
3BB5: 00          NOP
3BB6: 00          NOP
3BB7: 00          NOP
3BB8: 00          NOP
3BB9: 00          NOP
3BBA: 42          LD   B,D
3BBB: D7          RST  $10
3BBC: 00          NOP
3BBD: 00          NOP
3BBE: 00          NOP
3BBF: 00          NOP
3BC0: 00          NOP
3BC1: 00          NOP
3BC2: 42          LD   B,D
3BC3: D7          RST  $10
3BC4: 00          NOP
3BC5: 00          NOP
3BC6: 00          NOP
3BC7: 00          NOP
3BC8: 00          NOP
3BC9: 00          NOP
3BCA: 67          LD   H,A
3BCB: 3E 00       LD   A,$00
3BCD: 00          NOP
3BCE: 00          NOP
3BCF: 00          NOP
3BD0: 00          NOP
3BD1: 00          NOP
3BD2: EE 6A       XOR  $6A
3BD4: 38 00       JR   C,$3BD6
3BD6: 00          NOP
3BD7: 00          NOP
3BD8: 00          NOP
3BD9: 00          NOP
3BDA: 00          NOP
3BDB: 6A          LD   L,D
3BDC: BA          CP   D
3BDD: FE 68       CP   $68
3BDF: 00          NOP
3BE0: FD 00       DB   $FD
3BE2: 00          NOP
3BE3: 6B          LD   L,E
3BE4: 1B          DEC  DE
3BE5: FE 68       CP   $68
3BE7: 00          NOP
3BE8: FD 00       DB   $FD
3BEA: 00          NOP
3BEB: 6B          LD   L,E
3BEC: 81          ADD  A,C
3BED: FE 68       CP   $68
3BEF: 00          NOP
3BF0: FD 00       DB   $FD
3BF2: 00          NOP
3BF3: 6B          LD   L,E
3BF4: E7          RST  $20
3BF5: FE 68       CP   $68
3BF7: 00          NOP
3BF8: FD 00       DB   $FD
3BFA: 00          NOP
3BFB: 6C          LD   L,H
3BFC: 48          LD   C,B
3BFD: FE 68       CP   $68
3BFF: 00          NOP
3C00: FD 00       DB   $FD
3C02: 00          NOP
3C03: DD 03       DB   $DD
3C05: CC D5 6A    CALL Z,$6AD5
3C08: 38 00       JR   C,$3C0A
3C0A: 00          NOP
3C0B: 00          NOP
3C0C: 00          NOP
3C0D: 00          NOP
3C0E: 00          NOP
3C0F: EE 6A       XOR  $6A
3C11: 38 00       JR   C,$3C13
3C13: 00          NOP
3C14: 00          NOP
3C15: 00          NOP
3C16: FF          RST  $38
3C17: 78          LD   A,B
3C18: 6A          LD   L,D
3C19: BA          CP   D
3C1A: 01 98 00    LD   BC,$0098
3C1D: 03          INC  BC
3C1E: FD E0       DB   $FD				;This does not appear to be a valid instruction

3C20: 6B          LD   L,E
3C21: 1B          DEC  DE
3C22: 01 98 00    LD   BC,$0098
3C25: 03          INC  BC
3C26: FD 58       DB   $FD
3C28: 6B          LD   L,E
3C29: 81          ADD  A,C
3C2A: 01 98 00    LD   BC,$0098
3C2D: 03          INC  BC
3C2E: FD 58       DB   $FD
3C30: 6B          LD   L,E
3C31: E7          RST  $20
3C32: 01 98 00    LD   BC,$0098
3C35: 03          INC  BC
3C36: FD E0       DB   $FD				;This does not appear to be a valid instruction

3C38: 6C          LD   L,H
3C39: 48          LD   C,B
3C3A: 01 98 00    LD   BC,$0098
3C3D: 03          INC  BC
3C3E: FD 58       DB   $FD
3C40: DD 03       DB   $DD
3C42: CC D5 6A    CALL Z,$6AD5
3C45: 38 00       JR   C,$3C47
3C47: 00          NOP
3C48: 00          NOP
3C49: 00          NOP
3C4A: FF          RST  $38
3C4B: 78          LD   A,B
3C4C: EE 42       XOR  $42
3C4E: D7          RST  $10
3C4F: 00          NOP
3C50: 00          NOP
3C51: 00          NOP
3C52: 00          NOP
3C53: 00          NOP
3C54: 00          NOP
3C55: 69          LD   L,C
3C56: 26 00       LD   H,$00
3C58: 00          NOP
3C59: 00          NOP
3C5A: 00          NOP
3C5B: 00          NOP
3C5C: 00          NOP
3C5D: 69          LD   L,C
3C5E: 26 00       LD   H,$00
3C60: 00          NOP
3C61: 00          NOP
3C62: 00          NOP
3C63: 00          NOP
3C64: 00          NOP
3C65: EE 6D       XOR  $6D
3C67: B1          OR   C
3C68: 00          NOP
3C69: 00          NOP
3C6A: 00          NOP
3C6B: 00          NOP
3C6C: 00          NOP
3C6D: 00          NOP
3C6E: 42          LD   B,D
3C6F: D7          RST  $10
3C70: 00          NOP
3C71: 00          NOP
3C72: 00          NOP
3C73: 00          NOP
3C74: 00          NOP
3C75: 00          NOP
3C76: 6D          LD   L,L
3C77: B1          OR   C
3C78: 00          NOP
3C79: 00          NOP
3C7A: 00          NOP
3C7B: 00          NOP
3C7C: 00          NOP
3C7D: 00          NOP
3C7E: 42          LD   B,D
3C7F: D7          RST  $10
3C80: 00          NOP
3C81: 00          NOP
3C82: 00          NOP
3C83: 00          NOP
3C84: 00          NOP
3C85: 00          NOP
3C86: 6D          LD   L,L
3C87: B1          OR   C
3C88: 00          NOP
3C89: 00          NOP
3C8A: 00          NOP
3C8B: 00          NOP
3C8C: 00          NOP
3C8D: 00          NOP
3C8E: 42          LD   B,D
3C8F: D7          RST  $10
3C90: 00          NOP
3C91: 00          NOP
3C92: 00          NOP
3C93: 00          NOP
3C94: 00          NOP
3C95: 00          NOP
3C96: 6D          LD   L,L
3C97: B1          OR   C
3C98: 00          NOP
3C99: 00          NOP
3C9A: 00          NOP
3C9B: 00          NOP
3C9C: 00          NOP
3C9D: 00          NOP
3C9E: EE 6D       XOR  $6D
3CA0: 37          SCF
3CA1: 00          NOP
3CA2: 00          NOP
3CA3: 00          NOP
3CA4: 00          NOP
3CA5: 00          NOP
3CA6: 00          NOP
3CA7: 42          LD   B,D
3CA8: D7          RST  $10
3CA9: 00          NOP
3CAA: 00          NOP
3CAB: 00          NOP
3CAC: 00          NOP
3CAD: 00          NOP
3CAE: 00          NOP
3CAF: 42          LD   B,D
3CB0: D7          RST  $10
3CB1: 00          NOP
3CB2: 00          NOP
3CB3: 00          NOP
3CB4: 00          NOP
3CB5: 00          NOP
3CB6: 00          NOP
3CB7: 42          LD   B,D
3CB8: D7          RST  $10
3CB9: 00          NOP
3CBA: 00          NOP
3CBB: 00          NOP
3CBC: 00          NOP
3CBD: 00          NOP
3CBE: 00          NOP
3CBF: 42          LD   B,D
3CC0: D7          RST  $10
3CC1: 00          NOP
3CC2: 00          NOP
3CC3: 00          NOP
3CC4: 00          NOP
3CC5: 00          NOP
3CC6: 00          NOP
3CC7: 42          LD   B,D
3CC8: D7          RST  $10
3CC9: 00          NOP
3CCA: 00          NOP
3CCB: 00          NOP
3CCC: 00          NOP
3CCD: 00          NOP
3CCE: 00          NOP
3CCF: 6D          LD   L,L
3CD0: 37          SCF
3CD1: 00          NOP
3CD2: 00          NOP
3CD3: 00          NOP
3CD4: 00          NOP
3CD5: 00          NOP
3CD6: 00          NOP
3CD7: 68          LD   L,B
3CD8: AC          XOR  H
3CD9: 00          NOP
3CDA: 00          NOP
3CDB: 00          NOP
3CDC: 00          NOP
3CDD: 00          NOP
3CDE: 00          NOP
3CDF: EE 69       XOR  $69
3CE1: A0          AND  B
3CE2: FF          RST  $38
3CE3: FE FE       CP   $FE
3CE5: 00          NOP
3CE6: 00          NOP
3CE7: 00          NOP
3CE8: EE 69       XOR  $69
3CEA: A0          AND  B
3CEB: 00          NOP
3CEC: 02          LD   (BC),A
3CED: 02          LD   (BC),A
3CEE: 00          NOP
3CEF: FF          RST  $38
3CF0: FE EE       CP   $EE
3CF2: 6C          LD   L,H
3CF3: AE          XOR  (HL)
3CF4: 00          NOP
3CF5: 00          NOP
3CF6: 00          NOP
3CF7: 00          NOP
3CF8: 00          NOP
3CF9: 00          NOP
3CFA: 42          LD   B,D
3CFB: D7          RST  $10
3CFC: 00          NOP
3CFD: 00          NOP
3CFE: 00          NOP
3CFF: 00          NOP
3D00: 00          NOP
3D01: 00          NOP
3D02: 42          LD   B,D
3D03: D7          RST  $10
3D04: 00          NOP
3D05: 00          NOP
3D06: 00          NOP
3D07: 00          NOP
3D08: 00          NOP
3D09: 00          NOP
3D0A: 6C          LD   L,H
3D0B: AE          XOR  (HL)
3D0C: 00          NOP
3D0D: 00          NOP
3D0E: 00          NOP
3D0F: 00          NOP
3D10: 00          NOP
3D11: 00          NOP
3D12: EE 43       XOR  $43
3D14: F0          RET  P

3D15: 00          NOP
3D16: 00          NOP
3D17: 00          NOP
3D18: 00          NOP
3D19: 00          NOP
3D1A: 88          ADC  A,B
3D1B: 44          LD   B,H
3D1C: 5A          LD   E,D
3D1D: FE 68       CP   $68
3D1F: 00          NOP
3D20: FD 00       DB   $FD				;This does not appear to be a valid instruction
3D22: 00          NOP
3D23: 44          LD   B,H
3D24: E4 FE 68    CALL PO,$68FE
3D27: 00          NOP
3D28: FD 00       DB   $FD				;This does not appear to be a valid instruction
3D2A: 00          NOP
3D2B: 45          LD   B,L
3D2C: 9A          SBC  A,D
3D2D: FE 68       CP   $68
3D2F: 00          NOP
3D30: FD 00       DB   $FD				;This does not appear to be a valid instruction
3D32: 00          NOP
3D33: 46          LD   B,(HL)
3D34: 47          LD   B,A
3D35: FE 68       CP   $68
3D37: 00          NOP
3D38: FD FE       DB   $FD				;This does not appear to be a valid instruction
3D3A: F0          RET  P
3D3B: DD 0B       DB   $DD				;This does not appear to be a valid instruction
3D3D: 49          LD   C,C
3D3E: BA          CP   D
3D3F: FE 68       CP   $68
3D41: 00          NOP
3D42: FD 00       DB   $FD				;This does not appear to be a valid instruction
3D44: 88          ADC  A,B
3D45: CC D5 46    CALL Z,$46D5
3D48: F1          POP  AF
3D49: FE 68       CP   $68
3D4B: 00          NOP
3D4C: FD 00       DB   $FD				;This does not appear to be a valid instruction
3D4E: 88          ADC  A,B
3D4F: EE 43       XOR  $43
3D51: F0          RET  P

3D52: 00          NOP
3D53: 00          NOP
3D54: 00          NOP
3D55: 00          NOP
3D56: 00          NOP
3D57: 88          ADC  A,B
3D58: 44          LD   B,H
3D59: 5A          LD   E,D
3D5A: 01 98 00    LD   BC,$0098
3D5D: 03          INC  BC
3D5E: FE F0       CP   $F0
3D60: 44          LD   B,H
3D61: E4 01 98    CALL PO,$9801
3D64: 00          NOP
3D65: 03          INC  BC
3D66: FD 58       DB   $FD				;This does not appear to be a valid instruction
3D68: 45          LD   B,L
3D69: 9A          SBC  A,D
3D6A: 01 98 00    LD   BC,$0098
3D6D: 03          INC  BC
3D6E: FD E0       DB   $FD				;This does not appear to be a valid instruction

3D70: 46          LD   B,(HL)
3D71: 47          LD   B,A
3D72: 01 98 00    LD   BC,$0098
3D75: 03          INC  BC
3D76: FD E0       DB   $FD				;This does not appear to be a valid instruction

3D78: DD 0B       DB   $DD				;This does not appear to be a valid instruction
3D7A: 49          LD   C,C
3D7B: BA          CP   D
3D7C: 01 98 00    LD   BC,$0098
3D7F: 03          INC  BC
3D80: FD 58       DB   $FD				;This does not appear to be a valid instruction
3D82: CC D5 46    CALL Z,$46D5
3D85: F1          POP  AF
3D86: 01 98 00    LD   BC,$0098
3D89: 03          INC  BC
3D8A: FD 58       DB   $FD				;This does not appear to be a valid instruction
3D8C: EE 43       XOR  $43
3D8E: 86          ADD  A,(HL)
3D8F: FF          RST  $38
3D90: FE FE       CP   $FE
3D92: 00          NOP
3D93: 00          NOP
3D94: 88          ADC  A,B
3D95: EE 43       XOR  $43
3D97: 86          ADD  A,(HL)
3D98: 00          NOP
3D99: 02          LD   (BC),A
3D9A: 02          LD   (BC),A
3D9B: 00          NOP
3D9C: 00          NOP
3D9D: 86          ADD  A,(HL)
3D9E: EE 43       XOR  $43
3DA0: 2A 00 00    LD   HL,($0000)
3DA3: 00          NOP
3DA4: 00          NOP
3DA5: 00          NOP
3DA6: 00          NOP
3DA7: 43          LD   B,E
3DA8: 2A 00 00    LD   HL,($0000)
3DAB: 00          NOP
3DAC: 00          NOP
3DAD: 00          NOP
3DAE: 00          NOP
3DAF: EE 4A       XOR  $4A
3DB1: 54          LD   D,H
3DB2: 00          NOP
3DB3: 00          NOP
3DB4: 00          NOP
3DB5: 00          NOP
3DB6: 00          NOP
3DB7: 00          NOP
3DB8: DD 13       DB   $DD
3DBA: 4A          LD   C,D
3DBB: DD 00       DB   $DD
3DBD: 00          NOP
3DBE: 00          NOP
3DBF: 00          NOP
3DC0: 00          NOP
3DC1: 00          NOP
3DC2: 4A          LD   C,D
3DC3: DD 00       DB   $DD
3DC5: 00          NOP
3DC6: 00          NOP
3DC7: 00          NOP
3DC8: 00          NOP
3DC9: 00          NOP
3DCA: CC ED 4A    CALL Z,$4AED
3DCD: 54          LD   D,H
3DCE: 00          NOP
3DCF: 00          NOP
3DD0: 00          NOP
3DD1: 00          NOP
3DD2: 00          NOP
3DD3: 00          NOP
3DD4: EE 43       XOR  $43
3DD6: F0          RET  P

3DD7: 00          NOP
3DD8: 00          NOP
3DD9: 00          NOP
3DDA: 00          NOP
3DDB: 00          NOP
3DDC: 88          ADC  A,B
3DDD: 47          LD   B,A
3DDE: D9          EXX
3DDF: 00          NOP
3DE0: 03          INC  BC
3DE1: 03          INC  BC
3DE2: 00          NOP
3DE3: FF          RST  $38
3DE4: FD 4B       DB   $FD
3DE6: 66          LD   H,(HL)
3DE7: 00          NOP
3DE8: 03          INC  BC
3DE9: 03          INC  BC
3DEA: 00          NOP
3DEB: FF          RST  $38
3DEC: FD 48       DB   $FD
3DEE: 71          LD   (HL),C
3DEF: 00          NOP
3DF0: 03          INC  BC
3DF1: 03          INC  BC
3DF2: 00          NOP
3DF3: FF          RST  $38
3DF4: FD DD       DB   $FD
3DF6: 13          INC  DE
3DF7: 4B          LD   C,E
3DF8: FE 00       CP   $00
3DFA: 00          NOP
3DFB: 00          NOP
3DFC: 00          NOP
3DFD: FF          RST  $38
3DFE: FF          RST  $38
3DFF: 4B          LD   C,E
3E00: FE 00       CP   $00
3E02: 00          NOP
3E03: 00          NOP
3E04: 00          NOP
3E05: FF          RST  $38
3E06: FF          RST  $38
3E07: CC ED 48    CALL Z,$48ED
3E0A: 71          LD   (HL),C
3E0B: FF          RST  $38
3E0C: FD FD       DB   $FD
3E0E: 00          NOP
3E0F: 00          NOP
3E10: 00          NOP
3E11: 4B          LD   C,E
3E12: 66          LD   H,(HL)
3E13: FF          RST  $38
3E14: FD FD       DB   $FD
3E16: 00          NOP
3E17: 00          NOP
3E18: 00          NOP
3E19: 48          LD   C,B
3E1A: FA FF FD    JP   M,$FDFF
3E1D: FD 00       DB   $FD
3E1F: FE F0       CP   $F0
3E21: 47          LD   B,A
3E22: 65          LD   H,L
3E23: 00          NOP
3E24: 00          NOP
3E25: 00          NOP
3E26: 00          NOP
3E27: FE F0       CP   $F0
3E29: EE F5       XOR  $F5
3E2B: C5          PUSH BC
3E2C: D5          PUSH DE
3E2D: E5          PUSH HL
3E2E: DD E5       PUSH IX
3E30: FD E5       PUSH IY
3E32: 3A 66 7D    LD   A,($7D66)
3E35: FE 01       CP   $01
3E37: 28 27       JR   Z,$3E60
3E39: DD 21 88 7D LD   IX,$7D88
3E3D: 21 8B 7D    LD   HL,$7D8B
3E40: 11 43 7C    LD   DE,$7C43
3E43: 06 03       LD   B,$03
3E45: 7E          LD   A,(HL)
3E46: 12          LD   (DE),A
3E47: 23          INC  HL
3E48: 1B          DEC  DE
3E49: 10 FA       DJNZ $3E45
3E4B: CD 3E 41    CALL $413E
3E4E: 3A 46 7C    LD   A,($7C46)
3E51: FE 00       CP   $00
3E53: 20 08       JR   NZ,$3E5D
3E55: CD 82 3E    CALL $3E82
3E58: CD 89 3E    CALL $3E89
3E5B: 18 06       JR   $3E63
3E5D: CD 89 3E    CALL $3E89
3E60: CD 82 3E    CALL $3E82
3E63: 3A 4E 7C    LD   A,($7C4E)
3E66: FE 01       CP   $01
3E68: 20 0F       JR   NZ,$3E79
3E6A: 97          SUB  A
3E6B: 32 4E 7C    LD   ($7C4E),A
3E6E: CD 45 12    CALL $1245
3E71: CD 16 42    CALL $4216
3E74: 06 78       LD   B,$78
3E76: CD 9B 11    CALL $119B
3E79: FD E1       POP  IY
3E7B: DD E1       POP  IX
3E7D: E1          POP  HL
3E7E: D1          POP  DE
3E7F: C1          POP  BC
3E80: F1          POP  AF
3E81: C9          RET

3E82: 21 88 7D    LD   HL,$7D88
3E85: 3E 01       LD   A,$01
3E87: 18 05       JR   $3E8E
3E89: 21 8B 7D    LD   HL,$7D8B
3E8C: 3E 02       LD   A,$02
3E8E: CD 98 3E    CALL $3E98
3E91: 32 44 7C    LD   ($7C44),A
3E94: CD A6 3E    CALL $3EA6
3E97: C9          RET

3E98: F5          PUSH AF
3E99: 11 3D 7C    LD   DE,$7C3D
3E9C: 06 03       LD   B,$03
3E9E: 7E          LD   A,(HL)
3E9F: 12          LD   (DE),A
3EA0: 23          INC  HL
3EA1: 1B          DEC  DE
3EA2: 10 FA       DJNZ $3E9E
3EA4: F1          POP  AF
3EA5: C9          RET

3EA6: F5          PUSH AF
3EA7: C5          PUSH BC
3EA8: D5          PUSH DE
3EA9: E5          PUSH HL
3EAA: DD E5       PUSH IX
3EAC: 3A 4B 7C    LD   A,($7C4B)
3EAF: FE 0A       CP   $0A
3EB1: 28 04       JR   Z,$3EB7
3EB3: 3C          INC  A
3EB4: 32 4B 7C    LD   ($7C4B),A
3EB7: DD 21 2F 7C LD   IX,$7C2F
3EBB: 21 3B 7C    LD   HL,$7C3B
3EBE: 11 41 7C    LD   DE,$7C41
3EC1: 06 03       LD   B,$03
3EC3: 7E          LD   A,(HL)
3EC4: 12          LD   (DE),A
3EC5: 23          INC  HL
3EC6: 13          INC  DE
3EC7: 10 FA       DJNZ $3EC3
3EC9: CD 3E 41    CALL $413E
3ECC: 3A 46 7C    LD   A,($7C46)
3ECF: FE 00       CP   $00
3ED1: 28 1C       JR   Z,$3EEF
3ED3: 3E 01       LD   A,$01
3ED5: 32 4E 7C    LD   ($7C4E),A
3ED8: 11 35 7C    LD   DE,$7C35
3EDB: 06 03       LD   B,$03
3EDD: 2B          DEC  HL
3EDE: 7E          LD   A,(HL)
3EDF: 12          LD   (DE),A
3EE0: 13          INC  DE
3EE1: 10 FA       DJNZ $3EDD
3EE3: 97          SUB  A
3EE4: 12          LD   (DE),A
3EE5: 13          INC  DE
3EE6: 12          LD   (DE),A
3EE7: 13          INC  DE
3EE8: 12          LD   (DE),A
3EE9: CD F6 3E    CALL $3EF6
3EEC: CD E6 40    CALL $40E6
3EEF: DD E1       POP  IX
3EF1: E1          POP  HL
3EF2: D1          POP  DE
3EF3: C1          POP  BC
3EF4: F1          POP  AF
3EF5: C9          RET

3EF6: F5          PUSH AF
3EF7: C5          PUSH BC
3EF8: D5          PUSH DE
3EF9: E5          PUSH HL
3EFA: DD E5       PUSH IX
3EFC: FD E5       PUSH IY
3EFE: 97          SUB  A
3EFF: CD 45 12    CALL $1245
3F02: CD D2 1A    CALL $1AD2
3F05: 32 4C 7C    LD   ($7C4C),A
3F08: 3E 0B       LD   A,$0B
3F0A: CD 53 0B    CALL $0B53
3F0D: FD 21 E6 41 LD   IY,$41E6
3F11: DD 21 33 9F LD   IX,$9F33
3F15: CD 98 12    CALL $1298
3F18: FD 21 88 41 LD   IY,$4188
3F1C: DD 21 08 95 LD   IX,$9508
3F20: CD 93 12    CALL $1293
3F23: FD 21 F5 41 LD   IY,$41F5
3F27: DD 21 2A B0 LD   IX,$B02A
3F2B: CD 93 12    CALL $1293
3F2E: FD 21 00 42 LD   IY,$4200
3F32: 3A 44 7C    LD   A,($7C44)
3F35: FE 01       CP   $01
3F37: 20 04       JR   NZ,$3F3D
3F39: FD 21 FE 41 LD   IY,$41FE
3F3D: DD 21 BA CA LD   IX,$CABA
3F41: CD 93 12    CALL $1293
3F44: FD 21 02 42 LD   IY,$4202
3F48: DD 21 53 AE LD   IX,$AE53
3F4C: CD 93 12    CALL $1293
3F4F: FD 21 0E 42 LD   IY,$420E
3F53: DD 21 A4 B1 LD   IX,$B1A4
3F57: CD 98 12    CALL $1298
3F5A: 3E 03       LD   A,$03
3F5C: 32 F2 7B    LD   ($7BF2),A
3F5F: 3E 30       LD   A,$30
3F61: 32 47 7C    LD   ($7C47),A
3F64: CD CC 40    CALL $40CC
3F67: 3E 14       LD   A,$14
3F69: 32 45 7C    LD   ($7C45),A
3F6C: 11 49 7C    LD   DE,$7C49
3F6F: 3E 01       LD   A,$01
3F71: 32 48 7C    LD   ($7C48),A
3F74: 12          LD   (DE),A
3F75: CD 8D 40    CALL $408D
3F78: 06 3C       LD   B,$3C
3F7A: 32 5E 7D    LD   ($7D5E),A
3F7D: CD 62 40    CALL $4062
3F80: 3A 4C 7C    LD   A,($7C4C)
3F83: FE 01       CP   $01
3F85: CA 59 40    JP   Z,$4059
3F88: DB 02       IN   A,($02)
3F8A: CB 57       BIT  2,A
3F8C: 20 30       JR   NZ,$3FBE
3F8E: 3A 48 7C    LD   A,($7C48)
3F91: 21 37 7C    LD   HL,$7C37
3F94: 85          ADD  A,L
3F95: 6F          LD   L,A
3F96: 7C          LD   A,H
3F97: CE 00       ADC  A,$00
3F99: 67          LD   H,A
3F9A: 1A          LD   A,(DE)
3F9B: 77          LD   (HL),A
3F9C: 3A 48 7C    LD   A,($7C48)
3F9F: FE 03       CP   $03
3FA1: CA 59 40    JP   Z,$4059
3FA4: 3C          INC  A
3FA5: 32 48 7C    LD   ($7C48),A
3FA8: DB 02       IN   A,($02)
3FAA: CB 57       BIT  2,A
3FAC: 20 0D       JR   NZ,$3FBB
3FAE: CD 62 40    CALL $4062
3FB1: 3A 4C 7C    LD   A,($7C4C)
3FB4: FE 01       CP   $01
3FB6: CA 59 40    JP   Z,$4059
3FB9: 18 ED       JR   $3FA8
3FBB: CD 8D 40    CALL $408D
3FBE: DB 02       IN   A,($02)
3FC0: CB 6F       BIT  5,A
3FC2: 20 0B       JR   NZ,$3FCF
3FC4: 1A          LD   A,(DE)
3FC5: 3D          DEC  A
3FC6: FE FF       CP   $FF
3FC8: 20 02       JR   NZ,$3FCC
3FCA: 3E 37       LD   A,$37
3FCC: 12          LD   (DE),A
3FCD: 18 0D       JR   $3FDC
3FCF: DB 02       IN   A,($02)
3FD1: CB 67       BIT  4,A
3FD3: 20 A8       JR   NZ,$3F7D
3FD5: 1A          LD   A,(DE)
3FD6: 3C          INC  A
3FD7: FE 38       CP   $38
3FD9: 20 01       JR   NZ,$3FDC
3FDB: 97          SUB  A
3FDC: 12          LD   (DE),A
3FDD: CD 8D 40    CALL $408D
3FE0: 3A 45 7C    LD   A,($7C45)
3FE3: FE 06       CP   $06
3FE5: 38 05       JR   C,$3FEC
3FE7: 3D          DEC  A
3FE8: 3D          DEC  A
3FE9: 32 45 7C    LD   ($7C45),A
3FEC: 32 4A 7C    LD   ($7C4A),A
3FEF: DB 02       IN   A,($02)
3FF1: D3 00       OUT  ($00),A
3FF3: CB 6F       BIT  5,A
3FF5: 28 0C       JR   Z,$4003
3FF7: CB 67       BIT  4,A
3FF9: 28 08       JR   Z,$4003
3FFB: 3E 14       LD   A,$14
3FFD: 32 45 7C    LD   ($7C45),A