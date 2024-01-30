; Dungeon Delver Engine
; This is a CRPG engine that implements a subset of OGL SRD 5.1

; Test assembly program for Model 100
.org $E290

; Keep this at the top; this is the entry point
    call main
    ret

#include "constants.asm"
#include "rom_api.asm"
#include "random.asm"
#include "dice.asm"
#include "string.asm"

#include "character_builder.asm"

test_string: .ascii "This is a test string"
.db 10
.db 13
.db 0


to_string_test_buffer: .asciz "    "

counter: .db 0

main:
    call seed_random

    call roll_abilities_ui

    ret
