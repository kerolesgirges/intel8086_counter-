                                         
.model small
 .stack 100
 PORTA EQU 00H       ; to select port A via A0-A1 in ppi 
 PORTB EQU 02H       ; to select port b via A0-A1 in ppi    
 PORT_CON EQU 06H    ; to enable via A0-A1 in ppi 
 .data
 ARRAY DB 1,2,3,4,5  ; array configration 
 MAX DB 0            ; defind max intial as 0  
 SUM DW 0            ; defind sum intial as 0
 AVG DW 5            ; defind avg intial as 0
.code
 ORG 100H            
 
MOV DX, PORT_CON     ; move configration to dx to out it from ports
MOV AL, 10000010B    ; bit 7 is 1 always , port c output - port B -MODE 0 -  
OUT DX, AL           ; out zero in output bins 
MOV AL, 11000000B    ; bit 7 is 1 always ,port A input port C 	out put ,mode 0 ,port b out ,port c out  
MOV DX, PORTA        ;load port A to output (DX) to ppi 
OUT DX,AL      		 ; ppi receved that port A is out 

loop1:               ;to check push bottons stats
MOV DX, PORTB        ; to get status of port B (buttons )
IN AL, DX 		     ; to get status of port B
MOV DX, PORTA    	 ;cofegration to get ready to be port A our output 
CMP AL, 11111110B	 ;check frist push bottons 
JZ get_max           ;if pushed get max 
CMP AL, 11111101B	 ;check second push bottons
JZ get_avg           ;if pushed get avg
JMP loop1            ;not pushed then check againe 

get_max:             ;get MAX NUMBER IN THE ARRAY
loop2:
MOV AX,@data
MOV DS,AX             ;move address of data to Data Segment
XOR DI,DI             ;clear DI 
MOV CL ,5             ;array length
LEA BX,ARRAY          ;load address of array
MOV AL,MAX            ;move max value 
loop3:                ;loop3 to get sum 
CMP AL,[BX+DI]        ;compare vlaues to get max 
JNC run               ;if AL >[BX+DI] JUMP  
MOV DL,[BX+DI]         
MOV AL,DL
run:
INC DI
DEC CL
JNZ loop3
MOV MAX,AL
MOV AL,MAX

OUT DX,AL           ;out the vlaue to output  
JMP loop1           ;JUMP TO loop1 to repete assumtion 

get_avg:            ;THE AVERAGE OF THE ARRAY
mov ax,0
mov cx,5            ; counter of array 
get_SUM:            ;to get sum of all array 
add AL,ARRAY[SI]    
inc SI
cmp SI,5            ;compare with counter 
jnz get_SUM         ;if si== contue if not jump to get_sum  
div CX    
OUT DX,AL
JMP loop1
END
