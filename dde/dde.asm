; Dungeon Delver Engine
; This is a CRPG engine that implements a subset of OGL SRD 5.1

; Test assembly program for Model 100
.org $E290

; constants
#include "rom_api.asm"

    call init
    jp main

test_string: .ascii "This is a test string"
.db 10
.db 13
.db 0

newline:
.db 10
.db 13
.db 0

to_string_test_buffer: .ascii "    "
.db 0

counter: .db 0

#include "util.asm"

init:
    call seed_random
    ret

main:
    ld hl, test_string
    call print_string

    ld hl, newline
    call print_string

    ; Now try getting some random numbers
    ld a, 5
random_loop:
    ld (counter), a
    call random_16

    ld de, hl
    ld bc, to_string_test_buffer
    call de_to_hex_str

    ld hl, to_string_test_buffer
    call print_string

    ld hl, newline
    call print_string

    ld a, (counter)
    dec a
    jp nz, random_loop

    ret
