; this example shows how to access virtual ports (0 to 65535).
; these ports are emulated in this file: c:\emu8086.io

; this technology allows to make external add-on devices
; for emu8086, such as led displays, robots, thermometers, stepper-motors, etc... etc...

; anyone can create an animated virtual device.

; c:\emu8086\devices\led_display.exe
 
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
mov ax,@data
mov ds,ax
mov es,ax    

mov ax, 1234
out 199, ax

mov ax, -5678
out 199, ax

; Eternal loop to write
; values to port:
mov ax, 0                                                                     
    cadena_color linea,80,0,0,0,0,1eh  
    cadena_color linea,80,12,0,0,0,1eh  
    cadena_color linea,80,24,0,0,0,1eh  
     cadena_color titulo,35,0,23,0,0,0ECh             
    mov cx, 24  
pintar:
     push cx                                   
         cadena_color car,1,ren,0,0,0,1eh      
         cadena_color car,1,ren,39,0,0,1eh   
         cadena_color car,1,ren,79,0,0,1eh         
         inc ren         
    pop cx
    loop pintar     
    
    
    
                        
contador:     
      in al,125  ; Leer un byte del puerto 127-termómetro
      mov temperatura,al                                       
      mov ax, numero
      out 199, ax 
      cmp temperatura, 20 ; se acercan los moustros
      je  alarmaActiva    
checar:      
      cmp numero, 20  
      je reiniciar   
      inc numero                                 
      jmp contador  
alarmaActiva:     
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
      mov numero,0      
      jmp contador    
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

fin:
        MOV AX, 4c00h
        INT 21h
end        
                  