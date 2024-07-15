; PICAXE8M_TR 20230520 RJB
;

high C.1	; pin6 high
pause 1000	
low C.1

setint OR %00000100,%00000100,C ; interrupt pin5 C2 goes high
main:    	    pause 10000                     ; 1 second
                goto main                       ; loop back to start

interrupt:      ; Interrupts disable upon entry
                high C.4				; pin3 high
                pause 10000			      ; 10 seconds (low power)
                low C.4					; pin3 low
		    setint OR %00000100,%00000100,C ; re-activate interrupt
                return
		    
