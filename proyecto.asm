
 
include BIBLIO_MACROS.lib          
#start=led_display.exe#                                 
#start=thermometer.exe#  
    
.model small
.stack
.data    
        ;****** variables para el dise�o *******                            
        lineaArriba   db 27 dup(205),'$' 
        linea         db 80 dup(178),'$'       
        esquina1      db 1  dup(201),'$'      
        esquina2      db 1  dup(187),'$'      
        esquina3      db 1  dup(200),'$'      
        esquina4      db 1  dup(188),'$'  
        barra         db 1  dup(186),'$'   
        car           db 178      
        ;***************************************   
        
        ;****** variables para mensajes *******   
        titulo        db 'LUZ REVELADORA. CENTRO DE MONITOREO';35   
        msjB          db 'BIENVENIDO A LUZ REVELADORA'        ;27    
        usuario       db 'USUARIO     : '; 12                                           
        contra        db 'CONTRASE',165,'A  :'; 12   
        presioneTecla db 'Presiona una tecla para continuar'      ;23   
        passInco      db 'CONTRASE',165,'A INCORRECTA. REINIECE'  ;21       
        vuetasEntrada db 'N',163,'mero (1-9)'     
        ms2           db 'zona 2'
        ms1           db 'zona 1' 
        ms3           db 'zona 3' 
        ms4           db 'zona 4'       
        msjVueltas    db 'Ingrese el n',163,'mero dependiendo la hora de finalizaci',162,'n.'  ;53
        msjFin        db 'Monitoreo finalizado. Revise las bit',160,'coras.'                                       
        teclaSalir    db 'Presiona una tecla para salir.'      ;23   
        ;***************************************      
        
        ;****** variables para recuperar cadenas *******   
        user          db  9,0,9 dup('$')
        pass          db  9,0,9 dup('$')     
        passW         db '123'   ;comparar cadena con contrase�a           
        vueltas       db  2,0,2 dup('$')  ; veces que se checara el termometro
        ;*************************************** 
        
        ;;***** renglones para el posicionar*****                   
        ren1          db 3  ;poner mensaje
        ren2          db 3  
        ren3          db 15  
        ren4          db 15           
        ren           db 1  ;pintar marco   
        vueltasDadas  db 0  
        ;****************************************   
         
        ;********** contadores ******************    
        numero        dw 0  ; contador del display
        temperatura   db 0  ; contador del termometro  
        ;****************************************      
        
     
.code  
    MOV AX,@data
    MOV ds,AX
    MOV es,AX    
    
    MOV AX, 1234
    out 199, AX
    
    MOV AX, -5678
    out 199, AX        
    
;**********************
;CAMBIAR_PAGINA 3  
;jmp fin
;    
;******************
;CAMBIAR_PAGINA 1  
;jmp pantalla_uno
;******************

;****************** INTERFAZ DE LOGIN  ******************           
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
    LEER_CADENA user  ;INGRESAR USUARIO
    CURSOR 13,40,0
    LEER_CADENA pass  ;INGRESAR CONTRASE�A                 
 ;******************************************************    
comprobar_contra:
        LEA SI, passW
        LEA DI, pass+2 
        
        MOV CX, 3      
        
        REPE CMPSB    ; COMPARAMOS CONTRASE�A
        
        JZ iguales    ; SI ES CORRECTA ENTRAMOS        
        CADENA_COLOR passInco, 31, 16, 27, 0,0, 0ECh   
        call tecla    ; SI ES INCORRECTA SE SALE
        JMP fin     
iguales:                      
    CADENA_COLOR presioneTecla,33, 16, 22, 0,0, 0ECh   
    call TECLA           
    CAMBIAR_PAGINA 1  ; NOS VAMOS A OTRA P�GINA
    
;****************** INGREAR VUETAS ******************
pantalla_uno:                                    
    CADENA_COLOR msjVueltas,54, 6, 13, 1,0, 0ECh 
    CADENA_COLOR vuetasEntrada,12, 8, 28, 1,0, 0ECh     
    CURSOR 8,41,1
    LEER_CADENA vueltas                               
    ;ADD vueltas, 30h                                   
    CADENA_COLOR presioneTecla,33, 14, 22, 1,0, 0ECh   
    CURSOR 14,56 1
    CALL TECLA         
    CAMBIAR_PAGINA 2

;****************************************************
       
pantalla_dos:         
;**************INICICALIZAMOS LA PANTALLA CON MENSAJE Y MARCOS                                                                                    
    cadena_color linea,80,0,0,2,0,1eh  
    cadena_color linea,80,12,0,2,0,1eh  
    cadena_color linea,80,24,0,2,0,1eh  
    cadena_color titulo,35,0,23,2,0,0ECh             
    MOV cx, 24  
pintar:
     push cx                                   
         cadena_color car,1,ren,0,2,0,1eh      
         cadena_color car,1,ren,39,2,0,1eh   
         cadena_color car,1,ren,79,2,0,1eh         
         inc ren         
    pop cx
    loop pintar     
;*****************************************************************                            
medidor:     
      in al,125  ; Leer un byte del puerto 127-term�metro
      MOV temperatura,al                                       
      MOV AX, numero
      out 199, AX 
      cmp temperatura, 20 ; ALGUIEN PASO POR AHI
      je  encenderLuz     ; PRENDEMOS LA LUZ 
checar:      
      cmp numero, 20  
      je reiniciar        ; REINICIAMOS EL DISPLAY 
      inc numero       
      mov al,vueltas  
      cmp vueltasDadas,al
      je fin                                  
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
    CADENA_COLOR ms1,6,ren1,17,2,0,1eh   
    inc ren1                              
    inc vueltasDadas
    jmp checar                            
zona2:
    CADENA_COLOR ms2,6,ren2,57,2,0,1eh   
    inc ren2                               
    inc vueltasDadas
    jmp checar
zona3:
    CADENA_COLOR ms3,6,ren3,17,2,0,1eh   
    inc ren3                              
    inc vueltasDadas
    jmp checar
zona4:
    CADENA_COLOR ms4,6,ren4,57,2,0,1eh   
    inc ren4                           
    inc vueltasDadas
    jmp checar                                            
;*****************************************************************

fin:           
        CAMBIAR_PAGINA 3                         
        CADENA_COLOR msjFin,43,8,19,3,0,1eh   
        CADENA_COLOR teclaSalir,30,10,23,3,0,1eh   
        CURSOR 10,54,3           
        CALL tecla
        
        MOV AX, 4c00h
        INT 21h
;**************** SECCI�N DE PROCEDIMIENTOS **************
tecla PROC 
        MOV AH, 0    ; C�DIGO DE RASTREO
        INT 16h
     RET
 ENDP
;****************** FIN DE PROCEDIMIENTOS ****************    
END         
                  