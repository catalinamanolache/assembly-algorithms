%include "../include/io.mac"

struc neighbours_t
    .num_neighs resd 1
    .neighs resd 1
endstruc

section .bss
; vector de noduri vizitate cu 10000 elemente
visited resd 10000
global visited

section .data
; format string pentru printf
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
; 
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).
dfs:
    push ebp
    mov ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; se obtin argumentele functiei
    ; node
    mov ecx, dword [ebp + 8]  
    ; expand
    mov edi, dword [ebp + 12] 

    ; se obtine visited[node] pentru a verifica daca nodul a fost vizitat
    mov esi, dword [visited + ecx * 4]
    ; se verifica daca visited[node] == 1, adica a fost vizitat
    cmp esi, 1 
    je end

    ; se marcheaza nodul ca fiind vizitat
    mov dword [visited + ecx * 4], 1 

    ; se salveaza nodul inainte de executia printf
    push ecx 
    ; se apeleaza printf
    push ecx
    push fmt_str
    call printf
    ; se restaureaza stiva
    add esp, 8

    ; se recupereaza nodul
    pop ecx

    ; se apeleaza functia expand pentru a obtine vecinii nodului curent
    push ecx
    call edi
    ; se restaureaza stiva
    add esp, 4

    ; se obtine numarul de vecini din structura returnata de expand
    mov esi, dword [eax] 
    ; se obtine adresa vectorului de vecini din structura returnata de expand
    mov edx, dword [eax + 4]

    ; se verifica daca nodul curent are vecini
    cmp esi, 0
    je end

    ; se initializeaza contorul pentru a parcurge vecinii
    xor eax, eax 
loop_over_neighbours:
    ; se verifica daca au fost parcursi toti vecinii, pentru a iesi din loop
    cmp eax, esi 
    jge end_neighbour_loop

    ; se obtine vecinul curent
    mov ebx, dword [edx + eax * 4] 

    ; se obtine valoarea visited[neighs[i]] pentru
    ; a verifica daca vecinul a fost vizitat
    mov ebx, dword [visited + ebx * 4]

    ; se verifica daca visited[neighs[i]] == 1, adica daca a fost vizitat
    ; daca nu a fost vizitat, apelam dfs pe vecin 
    cmp ebx, 1 
    jne call_dfs
continue_loop:
    ; se incrementeaza contorul pentru a parcurge urmatorul vecin
    inc eax
    jmp loop_over_neighbours
    ; se obtine, din nou, vecinul curent, pentru a apela dfs pe el
call_dfs:
    ; se apeleaza dfs pentru nodul curent
    mov ebx, dword [edx + eax * 4] 
    push edi 
    push ebx 
    call dfs
    ; se restaureaza stiva
    add esp, 8
    jmp continue_loop
end_neighbour_loop:
    jmp end
end:
    ; se restaureaza registrii
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    leave
    ret