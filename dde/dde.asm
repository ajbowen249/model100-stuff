; Dungeon Delver Engine
; This is a CRPG engine that implements a subset of OGL SRD 5.1

; Test assembly program for Model 100
.org $E290

; Keep this at the top; this is the entry point
    call main
    ret

#include "rom_api.asm"
#include "random.asm"
#include "dice.asm"
#include "string.asm"

test_string: .ascii "This is a test string"
.db 10
.db 13
.db 0

d4_test_header: .ascii "D4 test:"
.db 10
.db 13
.db 0

d6_test_header: .ascii "D6 test:"
.db 10
.db 13
.db 0

d8_test_header: .ascii "D8 test:"
.db 10
.db 13
.db 0

d10_test_header: .ascii "D10 test:"
.db 10
.db 13
.db 0

d16_test_header: .ascii "D16 test:"
.db 10
.db 13
.db 0

d20_test_header: .ascii "D20 test:"
.db 10
.db 13
.db 0


to_string_test_buffer: .ascii "    "
.db 0

counter: .db 0

main:
    call seed_random

    ld hl, test_string
    call print_string

    ld hl, newline_string
    call print_string


; Now try getting some random numbers

roll_label_count = 0

.macro ROLL_TEST &HEADER, &ROLL_MAX
    ld hl, &HEADER
    call print_string

    ld a, 5
random_loop_{roll_label_count}:
    ld (counter), a
    ld a, &ROLL_MAX
    call roll_n

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

    ROLL_TEST d4_test_header, 4
    ROLL_TEST d6_test_header, 6
    ROLL_TEST d8_test_header, 8
    ROLL_TEST d10_test_header, 10
    ROLL_TEST d16_test_header, 16
    ROLL_TEST d20_test_header, 20

    ret
