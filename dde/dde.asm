; Dungeon Delver Engine
; This is a CRPG engine that implements a subset of OGL SRD 5.1

; Test assembly program for Model 100
.org $E290

; Keep these two at the top, this is the entry point
    call init
    jp main

#include "rom_api.asm"
#include "random.asm"
#include "dice.asm"
#include "string.asm"

    DEF_STR_NL test_string, "This is a test string"
    DEF_STR_NL d4_test_header, "D4 test:"
    DEF_STR_NL d6_test_header, "D6 test:"
    DEF_STR_NL d8_test_header, "D8 test:"
    DEF_STR_NL d10_test_header, "D10 test:"
    DEF_STR_NL d16_test_header, "D16 test:"
    DEF_STR_NL d20_test_header, "D20 test:"

to_string_test_buffer: .ascii "    "
.db 0

counter: .db 0

init:
    call seed_random
    ret

main:
    ld hl, test_string
    call print_string

    ld hl, newline_string
    call print_string

; Now try getting some random numbers

roll_label_count =  0

.macro ROLL_TEST &HEADER, &ROLL_SUB
    ld hl, &HEADER
    call print_string

    ld a, 5
random_loop_{roll_label_count}:
    ld (counter), a
    call &ROLL_SUB

    ld de, hl
    ld bc, to_string_test_buffer
    call de_to_hex_str

    ld hl, to_string_test_buffer
    call print_string

    ld hl, newline_string
    call print_string

    ld a, (counter)
    dec a
    jp nz, random_loop_{roll_label_count}
roll_label_count = roll_label_count + 1
.endm

    ROLL_TEST d4_test_header, roll_d4
    ROLL_TEST d6_test_header, roll_d6
    ROLL_TEST d8_test_header, roll_d8
    ROLL_TEST d10_test_header, roll_d10
    ROLL_TEST d16_test_header, roll_d16
    ROLL_TEST d20_test_header, roll_d20

    ret
