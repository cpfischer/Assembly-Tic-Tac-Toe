#================================================================
# Filename:
# Author: Caleb Fischer
#
# Description
# in word:  0 = ' ', 1 = 'O', 2 = 'X'
# Register usage:
# s0 = address of board
# s1 = n
# s2 = length of board
# $t3 = i
#================================================================

#################################################################
#
# text segment
#
#################################################################
		.text
		.globl main

main:		li		$v0, 5			# gets n from user
			syscall
			move	$s1, $v0		# store n into s1
			mul		$s2, $s1, $s1	# s2 = s1 * s1 == n * n == length
			la		$s0, BOARD		# stores address of board into s0
		
			add		$t0, $s2, $s2 	# t0 = 2len
			add		$t0, $t0, $t0 	# t0 = 4len
			li		$t1, 0			# t1 = i
			move	$t2, $s0		# t2 = &board

init:		bge		$t1, $t0, end_init	# i >= 4len
			add		$t2, $t1, $t2		# &board += i
			sw		$zero, 0($t2)		# board[i] = 0 == ' '
			addi	$t1, 4				# add 4 to i.  Goes to next array index
			j		init
		
		
end_init:		add		$t0, $s2, $s2 	# t0 = 2len
				add		$t0, $t0, $t0 	# t0 = 4len
			
				li		$t1, 0			# t1 = i
				move 	$t2, $s0		# t2 = &board
				jal		divider				# prints top divider
				
print_board:	bge		$t1, $t0, EXIT		# i >= 4len
				add		$t2, $t1, $t2		# &board += i
				jal 	print_line			# prints '|'
				lw		$a0, 0($t2)			# a0 = board[i]
				li		$v0, 1				# print int
				syscall
				jal		print_line			# prints '|'
				#bge		$t1, $s1, check_div	# i > n check_div
				
				addi	$t1, 4			# add 4 to i.  Goes to next array index
				j		print_board

print_line:		la		$a0, LINE
				li		$v0, 4
				syscall
				jr		$ra
#check_div:		
############################################################
#
# prints "\n-+-+-+\n", -+ specifically for n times
#
############################################################
divider:	li		$t3, 0 				# t3 = i
			la		$a0, NEWLINE		# a0 = '\n'
			li		$v0, 4				# print NEWLINE
			
			la		$a0, PLUS			# a0 = '+'
			li 		$v0, 4
			syscall
			
print_div:	bge		$t3, $s1, end_div	# i > n go to ENDDIV			
			la 		$a0, DIVIDER		# t0 = "-+"
			li 		$v0, 4				# print DIV
			syscall
			addi	$t3, 1			# i++
			j		print_div
			
end_div:	la		$a0, NEWLINE		# t0 = '\n'
			li		$v0, 4				# print NEWLINE
			syscall
			jr		$ra
			
			
EXIT:		li		$v0, 10
			syscall
		
#################################################################
# 
# data segment 
# 
#################################################################
			.data

LINE:		.asciiz "|"
DIVIDER:	.asciiz "-+"
NEWLINE:	.asciiz	"\n"
PLUS:		.asciiz "+"
BOARD:		.word 0