		.text
		.globl main

init:			li		$t0, 0				# t0 = i
				move	$t4, $s0			# t4 = &board
				li		$s4, 1				# turn 0 for O 1 for X
				li		$t9, 0
				
				##########MUST BE addu $t4, $s0, $t0##################
initLoop:		#addu	$t4, $t4, $t0		# &board = &board + i
				sw		$t9, 0($t4)		# board[i] = 0 == ' '
				lw		$a0, 0($t4)
				li		$v0, 1
				syscall
				
				addi	$t0, 4				# add 4 to i. Goes to next index
				addi	$t9, 1
				blt		$t0, $s3, initLoop	# i < 4len. Else, back to main
				jr		$ra


# printBoard:		li		$a2, 1				# counts for sep loop
				# li		$t0, 0				# t0 = i
				# move	$t4, $s0			# t4 = &board
				# addiu	$sp, $sp, -8		# moves sp down 2 words
				# sw		$ra, 4($sp)			# stores &$ra into top of stack
				# sw		$t0, 0($sp)			# t0 under $ra
				
				# move	$a1, $t0
				# sw		$t0, 0($sp)			# t0 under $ra
				#jal		firstSep			# prints top line.  Skips check 
				# lw		$t0, 0($sp)			# restores t0
				
# printLoop:		#jal		printLine			# prints '|'
				# add		$t4, $t4, $t0		# &board = &board + i
				# lw		$a0, 0($t4)			# a0 = board[i]
				# li		$v0, 1
				# syscall
				#jal		printVal			# prints value in board[i]
				
				# move	$a1, $t0			# a0 = i for passing into seperator
				# sw		$t0, 0($sp)			# t0 under $ra
				#jal		seperator			# prints divider lines
				# lw		$t0, 0($sp)			# restores t0
					
				# addi	$t0, 4				# add 4 to i.  Goes to index
				# addi	$a2, 1
				# blt		$t0, $s3, printLoop	# i < 4len. Else, back to main
				
				# lw		$ra, 4($sp)			# restores ra
				# addiu	$sp, $sp, 8			# restores &sp to 0
				# jr		$ra					# goes back to function that called
				
	
# printVal:		#la		$t5, PT				# t5 = &PT
				#addu	$t6, $a1, $a1		# t6 = 2(a0) = board[i]
				#addu	$t6, $t6, $t6		# t6 = 4(a0) = board[i]
				#addu	$t5, $t6, $t5		# t5 = 4(a0) + &PT	
				#lw		$t5, 0($t5)			# t5 = PT[i]
				# move	$a0, $t5
				# li		$v0, 1
				# syscall
				# jr		$ra
				

main:		li		$v0, 5			# gets n from user
			syscall
			move	$s1, $v0		# s1 = n
			mul		$s2, $s1, $s1	# s2 = len = s1 * s1 == n * n
			la		$s0, BOARD		# s0 = &BOARD
			
			add		$s3, $s2, $s2 		# t1 = 2len
			add		$s3, $s3, $s3 		# t1 = 4len
			jal		init
			#jal 	printBoard
			lw		$a0, 0($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 4($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 8($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 12($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 16($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 20($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 24($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 28($s0)
			li		$v0, 1
			syscall
			
			lw		$a0, 32($s0)
			li		$v0, 1
			syscall
			
EXIT:		li		$v0, 10
			syscall
		
		.data
X:			.asciiz "X"
O:			.asciiz "O"
SPACE:		.asciiz " "
LINE:		.asciiz "|"
DIVIDER:	.asciiz "-+"
NEWLINE:	.asciiz	"\n"
PLUS:		.asciiz "+"
ROW:		.asciiz "Enter row: "
COL:		.asciiz "Enter col: "
INTRO:		.asciiz "Let's play a game of tic-tac-toe.\nEnter n: "
FIRST:		.asciiz "I'll go first.\n"
#PT:			.word L0 L1 L2		
		
BOARD:		.word 0 1 2 3 4 5 6 7 8 9 