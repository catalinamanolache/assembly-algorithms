; subtask 2 - bsearch
section .text

; se declara functia globala binary_search
global binary_search

binary_search:
    ; se creeaza un nou stack frame
    enter 0, 0

    ; se salveaza registrii care trebuie sa fie pastrati
    push ebx
    push esi
    push edi

    ; ecx = buff, edx = needle, [ebp+8] = start, [ebp+12] = end
    ; se obtin argumentele functiei
    ; buff este in ecx si needle este in edx
    ; start
    mov esi, dword [ebp + 8] 
    ; end
    mov edi, dword [ebp + 12] 

    ; verificam daca end >= start, pentru a cauta intr-un interval valid
    cmp edi, esi 
    jl not_found

    ; construim valoarea lui mid
    ; mid = end
    mov ebx, edi 
    ; mid = end - start
    sub ebx, esi 
    ; mid = (end - start) / 2 
    shr ebx, 1 
    ; mid = start + (end - start) / 2
    add ebx, esi 

    ; verificam daca needle == buff[mid], pentru a returna mid
    cmp dword [ecx + ebx * 4], edx 
    je found_elem

    ; verificam daca needle < buff[mid], pentru a putea apela recursiv
    ; functia pe subarray-ul stang
    cmp edx, dword [ecx + ebx * 4] 
    jl call_for_left_subarray

    ; daca am ajuns aici, inseamna ca needle >= buff[mid], deci apelam recursiv
    ; functia pe subarray-ul drept
    jmp call_for_right_subarray
call_for_left_subarray:
    ; return binary_search(arr, needle, start, mid - 1);
    ; end va fi mid - 1
    dec ebx
    push ebx
    ; start va fi start
    push esi
    call binary_search
    ; se elibereaza stiva
    add esp, 8
    jmp end
call_for_right_subarray:
    ; return binary_search(arr, needle, mid + 1, end);
    ; end va fi end
    push edi
    ; start va fi mid + 1
    inc ebx
    push ebx
    call binary_search
    ; se elibereaza stiva
    add esp, 8
    jmp end
found_elem:
    ; return mid
    mov eax, ebx 
    jmp end
not_found:
    ; return -1
    mov eax, -1
    jmp end
end:
    ; se restaureaza registrii
    pop edi
    pop esi
    pop ebx
    leave
    ret