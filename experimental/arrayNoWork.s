			.text
			.globl main

main:		#li		$v0, 5			# gets n from user
			#syscall
			#move	$s1, $v0		# s1 = n
			#mul		$s2, $s1, $s1	# s2 = len = s1 * s1 == n * n
			la		$s0, BOARD		# s0 = &BOARD
			
			#add		$s3, $s2, $s2 		# t1 = 2len
			#add		$s3, $s3, $s3 		# t1 = 4len
			#jal		init
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
			
			lw		$a0, 36($s0)
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