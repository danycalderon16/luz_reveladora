
 
include BIBLIO_MACROS.lib
#start=led_display.exe#                               
#start=thermometer.exe#  
    
.model small
.stack
.data      
      linea    db 80 dup(178),'$' 
      titulo   db 'LUZ REVELADORA. CENTRO DE MONITOREO';35
      temperatura db 0   
      ms2 db 'zona 2'
      ms1 db 'zona 1' 
      ms3 db 'zona 3' 
      ms4 db 'zona 4'                
      ren1 db 3  
      ren2 db 3  
      ren3 db 15  
      ren4 db 15  
      numero dw 0  
      ren  db 1 
      car db 178
     
.code  
    MOV AX,@data
    MOV ds,AX
    MOV es,AX    
    
    MOV AX, 1234
    out 199, AX
    
    MOV AX, -5678
    out 199, AX
;**************INICICALIZAMOS LA PANTALLA CON MENSAJE Y MARCOS                                                                                    
    cadena_color linea,80,0,0,0,0,1eh  
    cadena_color linea,80,12,0,0,0,1eh  
    cadena_color linea,80,24,0,0,0,1eh  
    cadena_color titulo,35,0,23,0,0,0ECh             
    MOV cx, 24  
pintar:
     push cx                                   
         cadena_color car,1,ren,0,0,0,1eh      
         cadena_color car,1,ren,39,0,0,1eh   
         cadena_color car,1,ren,79,0,0,1eh         
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
end        
                  