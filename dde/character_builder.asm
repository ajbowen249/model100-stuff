.local
header: .ascii "Create Character"
.db 0

str_label: .ascii "    Strength"
.db 0

dex_label: .ascii "   Dexterity"
.db 0

con_label: .ascii "Constitution"
.db 0

int_label: .ascii "Intelligence"
.db 0

wis_label: .ascii "      Wisdom"
.db 0

chr_label: .ascii "    Charisma"
.db 0

.macro PRINT_AT_LOCATION &ROW, &COL, &STRING_ADDR
    ld h, &COL
    ld l, &ROW
    call rom_set_cursor

    ld hl, &STRING_ADDR
    call print_string
.endm

ability_values:
str_val: .db 0
dex_val: .db 0
con_val: .db 0
int_val: .db 0
wis_val: .db 0
chr_val: .db 0

remaining_points: .db 0

ability_index: .db 0
ability_roll_total: .db 0

build_character_ui::
    call rom_clear_screen

    ; draw static labels
    PRINT_AT_LOCATION 1, 1, header
    PRINT_AT_LOCATION 2, 3, str_label
    PRINT_AT_LOCATION 3, 3, dex_label
    PRINT_AT_LOCATION 4, 3, con_label
    PRINT_AT_LOCATION 5, 3, int_label
    PRINT_AT_LOCATION 6, 3, wis_label
    PRINT_AT_LOCATION 7, 3, chr_label

    ; Initialize ability scores
    ld a, 0

roll_loop:
    ld (ability_index), a
    ; You're supposed to roll 4 and add the highest 3. Just gonna roll 3 for simplicity for now.
    call roll_d6
    ld a, l
    ld (ability_roll_total), a
    call roll_d6
    ld a, (ability_roll_total)
    add l
    ld (ability_roll_total), a
    call roll_d6
    ld a, (ability_roll_total)
    add l

    ld d, a

    ld b, 0
    ld a, (ability_index)
    ld c, a

    ld hl, ability_values
    add hl, bc

    ld (hl), d

    inc a
    cp 6

    jp nz, roll_loop

    call print_ability_scores
    call rom_chget
    ret

print_ability_scores:
.macro PRINT_ABILITY_SCORE &VALUE, &ROW
    ld d, 0
    ld a, (&VALUE)
    ld e, a
    ld bc, glob_de_to_sex_str_buffer
    call de_to_hex_str

    PRINT_AT_LOCATION &ROW, 16, glob_de_to_sex_str_buffer
.endm

    PRINT_ABILITY_SCORE str_val, 2
    PRINT_ABILITY_SCORE dex_val, 3
    PRINT_ABILITY_SCORE con_val, 4
    PRINT_ABILITY_SCORE int_val, 5
    PRINT_ABILITY_SCORE wis_val, 6
    PRINT_ABILITY_SCORE chr_val, 7

    ret
.endlocal
