; PICAXE8M_HB_TR 20230520 RJB
;
setint OR %00001100,%00001100,C ; interrupt when pin4, C.3 or pin5 C2 goes high
let w0 = 0
let w1 = 0

high C.1	; pin6 high
pause 500	
low C.1
pause 200
high C.1	; pin6 high
pause 500	
low C.1


main:           inc w0
                if w0 >= 300 then relay         ; 5 Minutes
		    pause 1000                      ; 1 second
                w1 = 0
                goto main                       ; loop back to start

relay:
                setint OR %00000000,%00000000,C ; de-activate interrupt
                high C.4				; pin3 high - relay
		    high C.1				; pin6 high - led
                pause 10000			      ; 10 seconds (low power)
                low C.4					; pin3 low - relay
		    low C.1					; pin6 low - led
                w0 = 0				      ; reset the 5 minute timer
		    setint OR %00001100,%00001100,C ; re-activate interrupt
                goto main

interrupt:      ; Interrupts disable upon entry
		    if w1 > 5000 then               ; if C.3 set high for 30s then toggle c.4 to reset
		      high C.4				; pin3 high - relay
			high C.1				; pin6 high - led
                  pause 10000			      ; 10 seconds (low power)
                  low C.4				; pin3 low - relay
			low C.1				; pin6 low - led
			w1 = 0			
	          else if pinC.2 = 1 then		; see if pin5 went high
		      high C.4				; pin3 high - relay
			high C.1				; pin6 high - led
                  pause 10000			      ; 10 seconds (low power)
                  low C.4				; pin3 low - relay
			low C.1				; pin6 low - led
	          endif
	          w0 = 0		  			; reset the 5 minute timer
	          inc w1
		    setint OR %00001100,%00001100,C ; re-activate interrupt
                return
		    
