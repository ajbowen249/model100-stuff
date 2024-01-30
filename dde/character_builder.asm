.local
header: .ascii "Roll Abilities"
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

#define abilities_first_row 2
#define abilities_column 17

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
    call init_screen ; Everything from here is a modification to what this draws

    ld a, 0
    ld (ability_index), a

screen_loop:
    call draw_arrows
    call rom_chget

    cp 31
    jp z, down_arrow

    cp 30
    jp z, up_arrow

    jp screen_loop

.macro ARROW_UP_DOWN &LIMIT, &INC_OR_DEC
    ld a, (ability_index)
    cp a, &LIMIT
    jp z, screen_loop
    call clear_arrows

    ld a, (ability_index)
    &INC_OR_DEC a
    ld (ability_index), a

    call draw_arrows

    jp screen_loop
.endm

down_arrow:
    ARROW_UP_DOWN 5, inc

up_arrow:
    ARROW_UP_DOWN 0, dec

    ret

draw_arrows:
    ld a, (ability_index)
    ld b, abilities_first_row
    add b
    ld l, a

    ld h, abilities_column - 1
    call rom_set_cursor

    ld a, 155
    call rom_print_a

    ld h, abilities_column + 4
    ; l should still have row
    call rom_set_cursor

    ld a, 154
    call rom_print_a

    ret

clear_arrows:
    ld a, (ability_index)
    ld b, abilities_first_row
    add b
    ld l, a

    ld h, abilities_column - 1
    call rom_set_cursor

    ld a, " "
    call rom_print_a

    ld h, abilities_column + 4
    ; l should still have row
    call rom_set_cursor

    ld a, " "
    call rom_print_a

    ret

init_screen:
    call rom_clear_screen

    ; draw static labels
    PRINT_AT_LOCATION 1, 1, header
    PRINT_AT_LOCATION abilities_first_row + 0, 3, str_label
    PRINT_AT_LOCATION abilities_first_row + 1, 3, dex_label
    PRINT_AT_LOCATION abilities_first_row + 2, 3, con_label
    PRINT_AT_LOCATION abilities_first_row + 3, 3, int_label
    PRINT_AT_LOCATION abilities_first_row + 4, 3, wis_label
    PRINT_AT_LOCATION abilities_first_row + 5, 3, chr_label

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

.macro PRINT_ABILITY_SCORE &VALUE, &ROW
    ld d, 0
    ld a, (&VALUE)
    ld e, a
    ld bc, glob_de_to_sex_str_buffer
    call de_to_hex_str

    PRINT_AT_LOCATION &ROW, abilities_column, glob_de_to_sex_str_buffer
.endm

    PRINT_ABILITY_SCORE str_val, 2
    PRINT_ABILITY_SCORE dex_val, 3
    PRINT_ABILITY_SCORE con_val, 4
    PRINT_ABILITY_SCORE int_val, 5
    PRINT_ABILITY_SCORE wis_val, 6
    PRINT_ABILITY_SCORE chr_val, 7

    ret
.endlocal
