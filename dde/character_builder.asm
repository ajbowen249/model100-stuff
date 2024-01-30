.local
header: .ascii "Create Character"
.db 0

str_label: .ascii "    Strength"
.db 0

dex_label: .ascii "   Dexterity"
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

build_character_ui::
    call rom_clear_screen

    ; draw static labels
    PRINT_AT_LOCATION 1, 1, header
    PRINT_AT_LOCATION 2, 3, str_label
    PRINT_AT_LOCATION 3, 3, dex_label
    PRINT_AT_LOCATION 4, 3, int_label
    PRINT_AT_LOCATION 5, 3, wis_label
    PRINT_AT_LOCATION 6, 3, chr_label

    ret
.endlocal
