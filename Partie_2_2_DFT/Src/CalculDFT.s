	thumb
	area  moncode, code, readonly
	export CalculDFT
	export entier
	import TabSin
	import TabCos
	import TabSig
	
entier		proc
	push {lr}
	push {r1}
	

	ldr r2,=TabCos
	bl CalculDFT					;recuperation Re(k)
	pop {r1}
	push {r0}					;on met Re(k) dans r0 dans la pile		
	
	ldr r2,=TabSin					
	bl CalculDFT					;on recupere -Im(k) dans r0
	mul r0,r0,r0					;-Im(k)^2
	
	pop{r1}						;mise de Re(k) dans r1
	mul r1,r1,r1					;Re(k)^2
	
	add r0,r0,r1					;addition de Re(k)^2+Im(k)^2
	
	pop {lr}
	bx lr
	endp
	
CalculDFT	proc
	push {lr,r4-r6}

	
	mov r4,r0 					;tab signal
	mov r5,r2 					;tab cos ou sin
	mov r6,r1 					;k
	
	mov r3,#0 					;met i à 0 dans r3
	mov r0,#0 					;resultat de la somme dans r0
boucle	ldrh r2, [r4, r3 ,LSL #1] 			;on charge x(i)
	
	mul r1,r3,r6 					;on charge i*k dans r1
	and r1,r1,#63					;on fais un modulo 64 de ik
	
	ldrh r1,[r5,r1,LSL #1] 				;on charge cos(ik) dans r1
	mul r1, r1,r2 					;multiplication x(i)*cos(ik) dans r1
	add r0, r0, r1 					;ajout dans la somme
	add r3,#1 					;on incremente i
	cmp r3,#63					;if r0=63 
	
	bne boucle
	beq sortie 					;b equal = il vas ou si c =63
	
	
sortie 
	
	pop  {lr,r4-r6}
	bx lr
	
	
	endp
	end
		