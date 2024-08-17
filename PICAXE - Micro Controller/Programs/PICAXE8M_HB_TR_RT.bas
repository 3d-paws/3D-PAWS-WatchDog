; PICAXE8M_HB_TR_RT 20240816 RJB
; HB = Heartbeat
; TR = Trigger
; RT = Relay Test

; Set pin to input to check from Relay Test Mode
input C.1
relaytest:
if pinC.1 = 1 then
	high C.4
	pause 500	
	low C.4
	pause 500
	goto relaytest
endif

; Set pin to Output for LED
output C.1 

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
		    
