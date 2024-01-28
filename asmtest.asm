; Test assembly program for Model 100
ORG $E290

MVI A, 65  ; put "A" in A
CALL $4B44 ; print A to console
CALL $12CB ; await key press
jmp $5797 ; return to menu

