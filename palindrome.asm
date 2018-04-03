name "Devon Fazekas"
include "emu8086.inc"
org 100h
mov [numFound], 48d                                 ; Set default numFound to 0.

; Prompt for string input.
printn "Enter a string:"

; Get string.
lea di, buffer										; Store [buffer] in DI.
mov dx, SIZE										; Set string length to SIZE.
call get_string										; Get string, store in memory starting at DI.
 
; Loop through entire string.
printn
mov si, di                                          ; Copy starting index.

mov cx, SIZE                                        ; Set loop counter.
mov bx, cx                                          ; Copy loop counter.
LoopString:                                         
	mov cx, bx                                          ; Restore loop counter.
	mov al, [si]                                        ; Copy char at lastIndex.
	
	; IF (char == null) OR (char == whitespace)
	mov bx, cx                                          ; Copy loop counter.
	cmp al, SPACE                                       ; Compare char with whitespace.                                   
	je Search                                        
	cmp al, NULL                                        ; Compare char with null.                                     
	je Search
	
	; ELSE
	inc si                                              ; Increment lastIndex to next char.  
	loop LoopString	                                    ; Repeat.

Search:
    mov dx, si                                          ; Store lastIndex for later.
    sub si, 1                                           ; Correct lastIndex.
    
    ; Compute length of string
    mov cx, si                                          ; Copy starting index.
    sub cx, di                                          ; cx = di - si
    inc cx                                              ; Correcting length.
    shr cx, 1                                           ; cx = length / 2
     
DetectPalindrome:    
    ; IF (index == lastIndex) OR (Length == 1)
    cmp di, si                                          ; Compare lastIndex with Index.
    je IsPalindrome    
    
    ; ELSE IF (char1 != char2)
    mov al, [di]                                        ; Copy char at index.
    cmp al, [si]                                        ; Compare char with lastChar.
    jne NotPalindrome
    
    ; ELSE
    inc di                                              ; Increment index.
    dec si                                              ; Decrement lastIndex.

    loop DetectPalindrome                               ; Repeat.
    jmp IsPalindrome

NotPalindrome:
    ; IF (lastIndex == NULL)
    mov si, dx                                      ; Restore lastIndex.
    mov al, [si]                                    ; Copy char at lastIndex.
    cmp al, NULL                                    ; Compare lastChar with null.
    je END                                          ; Exit
    
    ; ELSE
    inc si                                          ; Increment lastIndex to next char
    mov di, si                                      ; Set index to lastIndex.
    jmp LoopString                                  ; Return
            
IsPalindrome:
    inc [NumFound]                                      ; Increment NumFound.
    
    ; IF (lastIndex == NULL)
    mov si, dx                                          ; Restore lastIndex.
    mov al, [si]                                        ; Copy char at lastIndex.
    cmp al, NULL                                        ; Compare lastChar with null.
    je END                                              ; Exit
    
    ; ELSE
    inc si                                              ; Increment lastIndex to next char.
    mov di, si                                          ; Set index to lastIndex.
    jmp LoopString                                      ; Return
  
End: 
    mov al, [numFound]                                  ; Copy NumFound.
    cmp al, 48d
    
    ; IF (numFound > 0)
    je PrintNoneFound
    
    ; ELSE
    printn "Found palindromic word in the input string"
    print "Total: "
    mov ah, 0Eh
    int 10h                                             ; Print NumFound.
    ret                                                 ; Stop program.

PrintNoneFound:
    print "No palindromic word found"
    ret

hlt 	
	
; Constants
SIZE EQU 20											; Declaring constant SIZE[20].			
NULL EQU 0h                                         ; Declaring constant NULL[0].
SPACE EQU 20h                                       ; Declaring constant SPACE[20h].

; Variables			
buffer DB SIZE DUP(?)  								; Declaring variable Buffer[SIZE].
numFound DB ?                                       ; Declaring variable NumFound[0].

; Definitions
DEFINE_get_string
DEFINE_print_string