;***********************************************************
; Fecha: 10 de junio de 2021
; NL 1
; NOMBRE DANIEL ALEJANDRO CALDERON VIRGEN      
; NL 2
; NOMBRE LUIS SERGIO CALLIRRO SANCHEZ
; HORA 12PM                                                   
;***********************************************************
include BIBLIO_MACROS.lib          
#start=led_display.exe#                                 
#start=thermometer.exe#  
    
.model small
.stack
.data    
        ;****** variables para el diseño *******                            
        lineaArriba   db 27 dup(205),'$' 
        linea         db 80 dup(178),'$'       
        esquina1      db 1  dup(201),'$'      
        esquina2      db 1  dup(187),'$'      
        esquina3      db 1  dup(200),'$'      
        esquina4      db 1  dup(188),'$'  
        barra         db 1  dup(186),'$'   
        car           db 178
        bip           db 7,'$'     
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
        passW         db '123'   ;comparar cadena con contraseña           
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
        
        ;*********************************************
        ruta0   db 'C:\luz_reveladora',0
        ruta1   db 'C:\luz_reveladora\zona1',0
        ruta2   db 'C:\luz_reveladora\zona2',0
        ruta3   db 'C:\luz_reveladora\zona3',0
        ruta4   db 'C:\luz_reveladora\zona4',0
        RUTAb1 DB 'C:\luz_reveladora\zona1\BitacoraZona1.txt',0
        RUTAb2 DB 'C:\luz_reveladora\zona2\BitacoraZona2.txt',0
        RUTAb3 DB 'C:\luz_reveladora\zona3\BitacoraZona3.txt',0
        RUTAb4 DB 'C:\luz_reveladora\zona4\BitacoraZona4.txt',0
        msjIni db 'Creando directorios...'
        msjIniA db 'Creando bitacoras...'
        msjSi  db 'Exito al crear... '
        msjNo  db 'Fallo en el proceso... Verificar directorios o archivos'
        ;msjCre   db 'Creando directorio raiz... ',10,13,'$'
        msjSiEscribir db 'Se ha podido ESCRIBIR el archivo',10,13,'$'
        msjZ   db 'Antes de comenzar. Oprime una tecla para crear directorios del programa'
                                                                             
        datosZ1 db 'Nuevo registro. Hora: '
        datosZ2 db 'Zona 2. Todo Correcto'
        datosZ3 db 'Zona 3. Todo Correcto'
        datosZ4 db 'Zona 4. Todo Correcto'
        
        ;totalEscribir2 dw 21
        LEIDOS DB 500 DUP ('$')
        MSJSALIDA DB 10,13,10,13,'Informacion de la bitacora: ',10,13,'$'
        MANEJADOR1 DW 0
        MANEJADOR2 DW 0
        MANEJADOR3 DW 0
        MANEJADOR4 DW 0
        MANEJADOR DW 0
        ;*********************************************************
        
        totalEscribir dw 0
        totalEscribir1 dw 0
        totalEscribir2 dw 0
        totalEscribir3 dw 0
        totalEscribir4 dw 0
        
        datosEscribir db 500 dup('$')
        datosEscribir1 db 500 dup('$')
        datosEscribir2 db 500 dup('$')
        datosEscribir3 db 500 dup('$')
        datosEscribir4 db 500 dup('$')
        d1 dw 0
        d2 dw 0
        d3 dw 0
        d4 dw 0
        d5 dw 0  
        HORA          DB 0
        MINUTOS       DB 0 
        mensajeAlarma db ' LUZ ENCENDIDA! ';18     
        
     
.code   
    MOV AX,@data
    MOV ds,AX
    MOV es,AX    
    
    MOV AX, 1234
    out 199, AX
    
    MOV AX, -5678
    out 199, AX        


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
    LEER_CADENA pass  ;INGRESAR CONTRASEÑA                 
 ;******************************************************    
comprobar_contra:
        LEA SI, passW
        LEA DI, pass+2 
        
        MOV CX, 3      
        
        REPE CMPSB    ; COMPARAMOS CONTRASEÑA
        
        JZ iguales    ; SI ES CORRECTA ENTRAMOS        
        CADENA_COLOR passInco, 31, 16, 27, 0,0, 0ECh   
        call tecla    ; SI ES INCORRECTA SE SALE
        JMP fin     
iguales:                      
    CADENA_COLOR presioneTecla,33, 16, 22, 0,0, 0ECh   
    call TECLA
    cadena_sin_color bip           
    CAMBIAR_PAGINA 1  ; NOS VAMOS A OTRA PÁGINA
    
;****************** INGREAR VUETAS ******************
pantalla_uno:                                    
    CADENA_COLOR msjVueltas,54, 6, 13, 1,0, 0ECh 
    CADENA_COLOR vuetasEntrada,12, 8, 28, 1,0, 0ECh     
    CURSOR 8,41,1
    LEER_CADENA vueltas
    SUB VUELTAS[2], 30H                               
    ;ADD vueltas, 30h                                   
    CADENA_COLOR msjZ,71, 14, 3, 1,0, 0ECh   
    CURSOR 14,75 1
    CALL TECLA
    cadena_sin_color bip
    CADENA_COLOR msjIni,22, 16, 22, 1,0, 0ECh
    CURSOR 16,44 1
    ;CALL TECLA
    CREAR_CARPETA ruta0
    CREAR_CARPETA ruta1        
    CREAR_CARPETA ruta2
    CREAR_CARPETA ruta3
    CREAR_CARPETA ruta4
    CREAR_ARCHIVO RUTAb1
    CREAR_ARCHIVO RUTAb2 
    CREAR_ARCHIVO RUTAb3 
    CREAR_ARCHIVO RUTAb4
    mov DI,0     
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
      mov totalEscribir1,0
      mov totalEscribir2,0 
      mov totalEscribir3,0 
      mov totalEscribir4,0     
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
      MOV AL,VUELTAS[2]  
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
    ;mov d1,0         
    CADENA_COLOR ms1,6,ren1,17,2,0,1eh   
    inc ren1                              
    inc vueltasDadas
    ;je  alarmaActiva1
    ABRIR_ARCHIVO RUTAb1, manejador1
    
      
         inc totalEscribir1 
         LEER_HORA    
         MOV hora,CH
         MOV MINUTOS,CL
         XOR AX,AX 
         MOV AL,hora
         AAM
         mov di,d1
         mov datosEscribir1[DI],AH ;Decenas
         add datosEscribir1[DI],30h
         
         INC DI 
         INC totalEscribir1
         MOV datosEscribir1[DI],AL ;Unidades
         add datosEscribir1[DI],30h
         INC DI 
         INC totalEscribir1    
         mov datosEscribir1[DI],':'
         INC DI 
         INC totalEscribir1            
         XOR AX,AX
         MOV AL,MINUTOS
         AAM
         mov datosEscribir1[DI],AH  ;Decenas
         add datosEscribir1[DI],30h
         INC DI
         INC totalEscribir1
         MOV datosEscribir1[DI],AL  ;Unidades
         ADD datosEscribir1[DI],30H
         mov cx,15
         MOV SI,0
msjA1:   push cx   
            INC DI  
            INC totalEscribir1                 
            MOV AL,mensajeAlarma[si]
            mov datosEscribir1[DI],AL
            inc si
         pop cx
         loop msjA1
        
        add d1,DI 
                                    
        ;MOV DI,0
        jmp checar
                            
zona2:
    ;mov DI,0
    CADENA_COLOR ms2,6,ren2,57,2,0,1eh   
    inc ren2                               
    inc vueltasDadas
    ;je  alarmaActiva
    ABRIR_ARCHIVO RUTAb2, manejador2
    inc totalEscribir2 
         LEER_HORA    
         MOV hora,CH
         MOV MINUTOS,CL
         XOR AX,AX 
         MOV AL,hora
         AAM 
         mov di,d2
         mov datosEscribir2[DI],AH ;Decenas
         add datosEscribir2[DI],30h
         
         INC DI 
         INC totalEscribir2
         MOV datosEscribir2[DI],AL ;Unidades
         add datosEscribir2[DI],30h
         INC DI 
         INC totalEscribir2    
         mov datosEscribir2[DI],':'
         INC DI 
         INC totalEscribir2            
         XOR AX,AX
         MOV AL,MINUTOS
         AAM
         mov datosEscribir2[DI],AH  ;Decenas
         add datosEscribir2[DI],30h
         INC DI
         INC totalEscribir2
         MOV datosEscribir2[DI],AL  ;Unidades
         ADD datosEscribir2[DI],30H
         mov cx,15
         MOV SI,0
         
         
msjA12:   push cx   
            INC DI  
            INC totalEscribir2                 
            MOV AL,mensajeAlarma[si]
            mov datosEscribir2[DI],AL
            inc si
         pop cx
         loop msjA12
         
         add d2,DI
         jmp checar
                                
zona3:
    ;mov DI,0
    CADENA_COLOR ms3,6,ren3,17,2,0,1eh   
    inc ren3                              
    inc vueltasDadas
    ;je  alarmaActiva
    ABRIR_ARCHIVO RUTAb3, manejador3
    inc totalEscribir3 
         LEER_HORA    
         MOV hora,CH
         MOV MINUTOS,CL
         XOR AX,AX 
         MOV AL,hora
         AAM
         mov di,d3
         mov datosEscribir3[DI],AH ;Decenas
         add datosEscribir3[DI],30h
         
         INC DI 
         INC totalEscribir3
         MOV datosEscribir3[DI],AL ;Unidades
         add datosEscribir3[DI],30h
         INC DI 
         INC totalEscribir3    
         mov datosEscribir3[DI],':'
         INC DI 
         INC totalEscribir3            
         XOR AX,AX
         MOV AL,MINUTOS
         AAM
         mov datosEscribir3[DI],AH  ;Decenas
         add datosEscribir3[DI],30h
         INC DI
         INC totalEscribir3
         MOV datosEscribir3[DI],AL  ;Unidades
         ADD datosEscribir3[DI],30H
         mov cx,15
         MOV SI,0
msjA13:   push cx   
            INC DI  
            INC totalEscribir3                 
            MOV AL,mensajeAlarma[si]
            mov datosEscribir3[DI],AL
            inc si
         pop cx
         loop msjA13
        
        add d3,DI                   
        
        ;MOV DI,0
        jmp checar  
         
zona4:
    ;mov DI,0
    CADENA_COLOR ms4,6,ren4,57,2,0,1eh   
    inc ren4                           
    inc vueltasDadas
    ;je  alarmaActiva
    ABRIR_ARCHIVO RUTAb4, manejador4
    inc totalEscribir4 
         LEER_HORA    
         MOV hora,CH
         MOV MINUTOS,CL
         XOR AX,AX 
         MOV AL,hora
         AAM
         mov di,d4
         mov datosEscribir4[DI],AH ;Decenas
         add datosEscribir4[DI],30h
         
         INC DI 
         INC totalEscribir4
         MOV datosEscribir4[DI],AL ;Unidades
         add datosEscribir4[DI],30h
         INC DI 
         INC totalEscribir4    
         mov datosEscribir4[DI],':'
         INC DI 
         INC totalEscribir4            
         XOR AX,AX
         MOV AL,MINUTOS
         AAM
         mov datosEscribir4[DI],AH  ;Decenas
         add datosEscribir4[DI],30h
         INC DI
         INC totalEscribir4
         MOV datosEscribir4[DI],AL  ;Unidades
         ADD datosEscribir4[DI],30H
         mov cx,15
         MOV SI,0
msjA14:   push cx   
            INC DI  
            INC totalEscribir4                 
            MOV AL,mensajeAlarma[si]
            mov datosEscribir4[DI],AL
            inc si
         pop cx
         loop msjA14
         
         add d4,DI

        ;MOV DI,0
        jmp checar  
         
ERROR:
    ;JMP FIN
    CADENA_COLOR msjNo,55, 18, 17, 1,0, 0ECh
    CURSOR 18,54,3          
        CALL tecla
        
        MOV AX, 4c00h
        INT 21h

fin:    
        ESCRIBIR_ARCHIVO manejador1, d1, datosESCRIBIR1
        ESCRIBIR_ARCHIVO manejador2, d2, datosESCRIBIR2
        ESCRIBIR_ARCHIVO manejador3, d3, datosESCRIBIR3
        ESCRIBIR_ARCHIVO manejador4, d4, datosESCRIBIR4
        
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