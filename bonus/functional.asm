; Interpret as 64 bits code
[bits 64]

section .text
global map
global reduce

map:
    push rbp
    mov rbp, rsp

    ; se obtin argumentele functiei
    ; destination_array
    mov r9, rdi
    ; source_array
    mov r10, rsi
    ; array_size
    mov r11, rdx
    ; function_pointer
    mov r12, rcx

    ; se intializeaza contorul pentru loop 
    xor r13, r13
map_loop:
    ; se compara contorul cu dimensiunea vectorului
    cmp r13, r11 
    ; daca i >= array_size, iesim din bucla
    jge end_map 

    ; se obtine source_array[i]
    mov r14, qword [r10 + r13 * 8]

    ; se apeleaza functia to_apply pentru elementul curent din source_array
    mov rdi, r14
    call r12 

    ; se salveaza rezultatul in elementul curent din destination_array
    mov qword [r9 + r13 * 8], rax 

    ; se incrementeaza contorul
    inc r13
    jmp map_loop
end_map:
    leave
    ret

; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    push rbp
    mov rbp, rsp

    ; se obtin argumentele functiei
    ; destination_array
    mov r9, rdi
    ; source_array
    mov r10, rsi
    ; array_size
    mov r11, rdx
    ; accumulator_initial_value
    mov r12, rcx
    ; function_pointer
    mov r13, r8

    ; se initializeaza acumulatorul: accumulator = accumulator_initial_value
    mov r14, r12

    ; se intializeaza contorul pentru loop 
    xor r15, r15
reduce_loop:
    ; se compara contorul cu dimensiunea vectorului
    cmp r15, r11 
    ; daca i >= array_size, iesim din bucla
    jge reduce_end 

    ; se obtine source_array[i]
    mov rbx, qword [r10 + r15 * 8] 

    ; se apeleaza functia to_apply pentru acumulator
    ; si elementul curent din source_array
    ; primul argument este acc
    mov rdi, r14 
    ; al doilea argument este source_array[i]
    mov rsi, rbx
    call r13 

    ; se salveaza rezultatul in acumulator
    mov r14, rax 

    ; se incrementeaza contorul
    inc r15
    jmp reduce_loop

reduce_end:
    ; se returneaza acumulatorul
    mov rax, r14

    ; sa-nceapa festivalu'
    leave
    ret