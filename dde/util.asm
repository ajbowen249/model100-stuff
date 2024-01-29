; Prints the string starting at HL
; Destroys HL, a
.local
print_string::
loop:
    ld a, (hl) ; read character
    cp a, 0    ; if it's zero...
    jp z, return ; ...we're done
    call print_a
    inc hl
    jp loop
return:
    ret
.endlocal

.local
; Writes the hex string value of DE to the buffer starting at BC
; Destroys A and HL
de_to_hex_str::
    ld hl, bc ; use HL as the counter to BC is still usable after this
    ld a, d
    rra ; shift upper nibble to lower
    rra
    rra
    rra
    and $0F ; mask off rotated-in nibble
    call write_a_to_hl

    ld a, d
    and $0F ; mask off upper nibble
    call write_a_to_hl

    ld a, e
    rra ; shift upper nibble to lower
    rra
    rra
    rra
    and $0F ; mask off rotated-in nibble
    call write_a_to_hl

    ld a, e
    and $0F ; mask off upper nibble
    call write_a_to_hl

    ld (hl), 0 ; null terminator

    ret

; (Local to de_to_hex_str) writes the hex character for A to HL
write_a_to_hl:
    cp 10
    jp m, char_0_9
    add 55 ; ascii A is 65, but we're already at at least 10
    jp save_char

char_0_9:
    add 48 ; ascii 0 is 48
save_char:
    ld (hl), a
    inc hl
    ret
.endlocal

; yoinked from
; https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Random
;Inputs:
;   (seed1) contains a 16-bit seed value
;   (seed2) contains a NON-ZERO 16-bit seed value
;Outputs:
;   HL is the result
;   BC is the result of the LCG, so not that great of quality
;   DE is preserved
;Destroys:
;   AF
;cycle: 4,294,901,760 (almost 4.3 billion)
;160cc
;26 bytes

seed1: .dw 0
seed2: .dw 0

.local
random_16::
    ld hl,(seed1)
    ld b,h
    ld c,l
    add hl,hl
    add hl,hl
    inc l
    add hl,bc
    ld (seed1),hl
    ld hl,(seed2)
    add hl,hl
    sbc a,a
    and %00101101
    xor l
    ld l,a
    ld (seed2),hl
    add hl,bc
    ret
.endlocal

; seeds the RNG based on the ASCII date characters for current seconds
.local
seed_random::
    ld a,(seconds_10s)
    ld (seed1), a
    inc a
    ld (seed1 + 1), a
    ld a,(seconds_1s)
    ld (seed2), a
    inc a
    ld (seed2 + 1), a
    ret
.endlocal
