
 
include BIBLIO_MACROS.lib
#start=led_display.exe#                               
#start=thermometer.exe#  
    
.model small
.stack
.data                                
        lineaArriba   db 27 dup(205),'$' 
        linea         db 80 dup(178),'$'       
        esquina1      db 1  dup(201),'$'      
        esquina2      db 1  dup(187),'$'      
        esquina3      db 1  dup(200),'$'      
        esquina4      db 1  dup(188),'$'  
        barra         db 1  dup(186),'$'
        titulo        db 'LUZ REVELADORA. CENTRO DE MONITOREO';35   
        msjB          db 'BIENVENIDO A LUZ REVELADORA'        ;27    
        usuario       db 'USUARIO     : '; 12                                           
        contra        db 'CONTRASE',165,'A  :'; 12   
        user          db  9,0,9 dup('$')
        pass          db  9,0,9 dup('$')     
        passW         db '123'
        passInco      db 'CONTRASE',165,'A INCORRECTA'  ;21
        temperatura   db 0         
        presioneTecla db 'Presiona una tecla para continuar'      ;23
        ms2           db 'zona 2'
        ms1           db 'zona 1' 
        ms3           db 'zona 3' 
        ms4           db 'zona 4'                
        ren1          db 3  
        ren2          db 3  
        ren3          db 15  
        ren4          db 15  
        numero        dw 0  
        ren           db 1 
        car           db 178
     
.code  
    MOV AX,@data
    MOV ds,AX
    MOV es,AX    
    
    MOV AX, 1234
    out 199, AX
    
    MOV AX, -5678
    out 199, AX           
bienvenida:     

    cadena_color msjB,27,7,27,0,0,0ECh                                                                        
    cadena_color esquina1,1,6,26,0,0,0ECh                                                                           
    cadena_color esquina2,1,6,54,0,0,0ECh                                                                           
    cadena_color esquina3,1,8,26,0,0,0ECh                                                                           
    cadena_color esquina4,1,8,54,0,0,0ECh                                                                           
    cadena_color barra,1,7,26,0,0,0ECh                                                                         
    cadena_color barra,1,7,54,0,0,0ECh                                                                       
    cadena_color lineaArriba,27,6,27,0,0,0ECh                                                                        
    cadena_color lineaArriba,27,8,27,0,0,0ECh 
    
    CADENA_COLOR usuario, 12, 11, 27, 0, 0, 0ECh                                   
    CADENA_COLOR contra, 12, 13, 27, 0, 0, 0ECh       
     
    CURSOR 11,40,0
    LEER_CADENA user
    CURSOR 13,40,0
    LEER_CADENA pass   
comprobar_contra:
        LEA SI, passW
        LEA DI, pass+2 ; Dos bytes de control
        
        MOV CX, 3      ;COMPARA 5 CARACTERES,
        
        REPE CMPSB   
        
        JZ iguales        
        CADENA_COLOR passInco, 21, 16, 27, 0,0, 0ECh   
        call tecla
        JMP fin     
iguales:
    CADENA_COLOR presioneTecla,33, 16, 22, 0,0, 0ECh   
    call TECLA           
    CAMBIAR_PAGINA 1
    
pantalla_dos:         
;**************INICICALIZAMOS LA PANTALLA CON MENSAJE Y MARCOS                                                                                    
    cadena_color linea,80,0,0,1,0,1eh  
    cadena_color linea,80,12,0,1,0,1eh  
    cadena_color linea,80,24,0,1,0,1eh  
    cadena_color titulo,35,0,23,1,0,0ECh             
    MOV cx, 24  
pintar:
     push cx                                   
         cadena_color car,1,ren,0,1,0,1eh      
         cadena_color car,1,ren,39,1,0,1eh   
         cadena_color car,1,ren,79,1,0,1eh         
         inc ren         
    pop cx
    loop pintar     
;*****************************************************************                            
medidor:     
      in al,125  ; Leer un byte del puerto 127-termómetro
      MOV temperatura,al                                       
      MOV AX, numero
      out 199, AX 
      cmp temperatura, 20 ; ALGUIEN PASO POR AHI
      je  encenderLuz     ; PRENDEMOS LA LUZ 
checar:      
      cmp numero, 20  
      je reiniciar        ; REINICIAMOS EL DISPLAY 
      inc numero                                 
      jmp medidor  
encenderLuz:     
      MOV numero, AX 
      cmp numero, 15
      jg zona4
      cmp numero, 10
      jg zona3
      cmp numero, 5
      jg zona2
      cmp numero, 0
      jg zona1
reiniciar:
      MOV numero,0      
      jmp medidor    
;************* ESCRIBIMO DEPENDIENDO LA ZONA *************      
zona1:         
    CADENA_COLOR ms1,6,ren1,17,0,0,1eh   
    inc ren1
    jmp checar
zona2:
    CADENA_COLOR ms2,6,ren2,57,0,0,1eh   
    inc ren2
    jmp checar
zona3:
    CADENA_COLOR ms3,6,ren3,17,0,0,1eh   
    inc ren3
    jmp checar
zona4:
    CADENA_COLOR ms4,6,ren4,57,0,0,1eh   
    inc ren4
    jmp checar                                            
;*****************************************************************

fin:
        MOV AX, 4c00h
        INT 21h
;**************** SECCIÓN DE PROCEDIMIENTOS **************
tecla PROC 
        MOV AH, 0    ; CÓDIGO DE RASTREO
        INT 16h
     RET
 ENDP
;****************** FIN DE PROCEDIMIENTOS ****************    
END         
                  