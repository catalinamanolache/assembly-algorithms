; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp

    ; sa-nceapa concursul
    ; ( = 0x28
    ; ) = 0x29
    ; [ = 0x5b
    ; ] = 0x5d
    ; { = 0x7b
    ; } = 0x7d
    ; se obtine argumentul functiei, char *str
    mov edx, [ebp + 8]

    ; se initializeaza contorul pentru bucla
    xor esi, esi
    ; se presupune ca parantezarea e corecta
    mov eax, 0
for_i:
    ; se ia caracterul curent
    mov cl, byte [edx + esi]
    ; verificam daca s-a ajuns la sfarsitul sirului
    cmp cl, 0
    ; daca da, iesim din bucla
    jz end_for_i

    ; verificam daca caracterul curent este o paranteza rotunda inchisa
    cmp cl, 0x29
    je p_round_closed

    ; verificam daca caracterul curent este o paranteza dreapta inchisa
    cmp cl, 0x5d
    je p_square_closed

    ; verificam daca caracterul curent este o acolada inchisa
    cmp cl, 0x7d
    je p_bracket_closed

    ; daca nu este o paranteza inchisa, este una deschisa si o punem pe stiva
    movzx ecx, cl
    push ecx

    ; trecem la urmatorul caracter
    inc esi
    jmp for_i
p_round_closed:
    ; verificam daca ultima paranteza deschisa este o paranteza rotunda
    pop ecx
    cmp ecx, 0x28

    ; daca nu, este o parantezare gresita
    jne wrong

    ; daca da, trecem la urmatorul caracter
    inc esi
    jmp for_i
p_square_closed:
    ; verificam daca ultima paranteza deschisa este o paranteza dreapta
    pop ecx
    cmp ecx, 0x5b

    ; daca nu, este o parantezare gresita
    jne wrong

    ; daca da, trecem la urmatorul caracter
    inc esi
    jmp for_i
p_bracket_closed:
    ; verificam daca ultima paranteza deschisa este o acolada
    pop ecx
    cmp ecx, 0x7b

    ; daca nu, este o parantezare gresita
    jne wrong

    ; daca da, trecem la urmatorul caracter
    inc esi
    jmp for_i
wrong:
    ; returnam 1, adica parantezarea e gresita
    mov eax, 1
    jmp end_for_i
end_for_i:
    leave
    ret
