bits 32
global start
extern exit, printf, scanf, gets
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import gets msvcrt.dll

segment data use32 class=data
    sir db 0
    msg1 db "Introduceti un numar par de caractere (minim 10, maxim 20): ",10,0
    msg2 db "Ati introdus %d < 10 caractere. Incercati din nou",0
    msg3 db "Ati introdus %d > 20 caractere. Incercati din nou",0
    msg4 db "Ati introdus %d - un numar impar de caractere. Incercati din nou",0
    msg5 db "Au fost comparate caracterele %c si %c. Primul caracter este majuscula",10,0
    msg6 db "Au fost comparate caracterele %c si %c. Al doilea caracter este majuscula",10,0
    msg7 db "Au fost comparate caracterele %c si %c. Niciun caracter nu e majuscula",10,0
    msg8 db "Au fost comparate caracterele %c si %c. Ambele caractere sunt majuscule",10,0
    format db "%s", 0
    formatChar db "%c", 0
    formatHexa db "%X",0
    formatDec db "%d",0

segment code use32 class=code

majuscule:
cmp EBP, dword 41h
jl c1_nu_majuscula
cmp EBP, dword 5Ah
jg c1_nu_majuscula
;c1 e majuscula
cmp EBX, dword 41h
jl c1_majuscula_c2_nu_majuscula
cmp EBX, dword 5Ah
jg c1_majuscula_c2_nu_majuscula
;c1_majuscula_c2_majuscula
push dword EBX
push dword EBP
push dword msg8
call [printf]
add ESP,4*3
jmp final_proc
c1_nu_majuscula:

;c1 nu e majuscula

cmp EBX,dword 41h
jl c1_nu_majuscula_c2_nu_majuscula
cmp EBX,dword 5Ah
jg c1_nu_majuscula_c2_nu_majuscula
;c1_nu_majuscula_c2_majuscula
push dword EBX
push dword EBP
push dword msg6
call [printf]
add ESP,4*3
jmp final_proc
c1_majuscula_c2_nu_majuscula:
push dword EBX
push dword EBP
push dword msg5
call [printf]
add ESP,4*3
jmp final_proc
c1_nu_majuscula_c2_nu_majuscula:
push dword EBX
push dword EBP
push dword msg7
call [printf]
add ESP,4*3
final_proc:
ret


start:
    ; Afiseaza mesajul
    push dword msg1
    push dword format
    call [printf]
    add ESP, 4*2

    ; Citeste sirul
    push dword sir
    call [gets]
    add ESP, 4

    ;in EAX se contine caracterul curent
    ;EBX este contorul
    mov EBX,0
    count:  
        mov EAX,0
        mov AL,byte[sir+EBX]
        cmp EAX, 0h
        je final
        inc dword EBX
        jmp count 
        
    final:
    ;in EBX se contine lungimea sirului
    mov EAX,EBX
    cmp EBX,10d
    jl prea_putine
    cmp EBX, 20d
    jg prea_multe
    shr EAX, 1
    ;daca CF=1, lungime impara
    ;daca CF=0, lungime para
    jC lung_impara
    ;e introdus numar corect de caractere
    jmp continua
    
    prea_putine:
    ;afiseaza msg cu prea putine caractere
    push dword EBX
    push dword msg2
    call [printf]
    add ESP,4*2   
    jmp termina_programul
    
    prea_multe:
    ;afiseaza msg cu prea multe caractere
    push dword EBX
    push dword msg3
    call [printf]
    add ESP,4*2 
    jmp termina_programul
    
    lung_impara:
    ;afiseaza msg cu lungime impara
    push dword EBX
    push dword msg4
    call [printf]
    add ESP,4*2 
    jmp termina_programul
    
      
    continua:
    mov ESI,EBX ;ESI contine lungimea sirului
    mov EDI,0;EDI este contorul
    ;trebe sa pun in EAX c1 
    ;trebe sa pun in EBX c2
    ;ca sa pot apela procedura
    
    
   compara_loop:
        mov EBP,0
        mov EBX,0
        
        mov BP,word[sir+EDI+0]
        shl BP,8
        shr BP,8
        mov BL,byte[sir+EDI+1]   
        inc dword EDI
        inc dword EDI 
        call majuscule        
        cmp EDI, ESI
        jne compara_loop
    
    termina_programul:
    push dword 0
    call [exit]
