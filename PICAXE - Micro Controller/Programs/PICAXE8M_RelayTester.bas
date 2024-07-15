; PICAXE8M_RELAY_TESTER 20230612 RJB
;

main: 
	high C.4	; pin6 high
	pause 500	
	low C.4
	pause 500
	goto main