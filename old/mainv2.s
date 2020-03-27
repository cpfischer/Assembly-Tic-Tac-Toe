#================================================================
# Filename: mainExperimental.s
# Author: Caleb Fischer
#
# Description
# in word:  0 = ' ', 1 = 'O', 2 = 'X'
# Register usage:
# s0 = address of board
# s1 = n == user input
# s2 = length of board == n * n
# s3 = 4(len) *for loop end for looping through whole board*
# s4 = turn  0 for O 1 for X
# t0 = i
# t1 = max of i for loops
# t2 = j
# t3 = comparisons
# t4-9 computations
# a0-2 = pass values
# v0-2 = return values
#================================================================

#################################################################
#
# text segment
#
#################################################################
		.text
		.globl main

#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# init()
#
# Initializes the game board to 0s in each spot of the board.  
# Word size = 4(n * n)  Board length = n * n
#
# c++:
#    for (int i = 0; i < (g.n * g.n); ++i)
#    {
#        g.board[i] = ' ';
#    }
#    g.turn = 'X';
#
#------------------------------------------------------------------------------
init:			li		$t0, 0				# t0 = i
				move	$t4, $s0			# t4 = &board
				li		$s4, 1				# turn 0 for O 1 for X
				
initLoop:		bge		$t0, $s3, exitInit	# i < 4len. Else, back to main
				add		$t4, $s0, $t0		# &board = &board + i
				sw		$zero, 0($t4)		# board[i] = 0 == ' '
				addi	$t0, 4				# add 4 to i. Goes to next index
				j 		initLoop
				
exitInit:		jr		$ra

#------------------------------------------------------------------------------
# Prints the game board.  0 = ' ', 1 = 'X', 2 = '0'
#
# c++:
#    printSeperator(g);
#    for (int i = 0; i < (g.n * g.n); ++i)
#    {
#        if (i >= g.n && (i % g.n == 0))
#        {
#            std::cout << "|";
#            printSeperator(g);
#        }
#        std::cout << '|';
#        std::cout << g.board[i];
#    }
#    std::cout << "|";
#    printSeperator(g);
#------------------------------------------------------------------------------
printBoard:		li		$a2, 1				# counts for sep loop
				li		$t0, 0				# t0 = i
				move	$t4, $s0			# t4 = &board
				addiu	$sp, $sp, -8		# moves sp down 2 words
				sw		$ra, 4($sp)			# stores &$ra into top of stack
				sw		$t0, 0($sp)			# t0 under $ra
				
				move	$a1, $t0
				sw		$t0, 0($sp)			# t0 under $ra
				jal		firstSep			# prints top line.  Skips check 
				lw		$t0, 0($sp)			# restores t0
				
printLoop:		bge		$t0, $s3, exitPrint	# i < 4len. Else, back to main
				jal		printLine			# prints '|'
				add		$t4, $s0, $t0		# &board = &board + i
				lw		$a1, 0($t4)			# a0 = board[i]
				jal		printVal			# prints value in board[i]
				
				move	$a1, $t0			# a0 = i for passing into seperator
				sw		$t0, 0($sp)			# t0 under $ra
				jal		seperator			# prints divider lines
				lw		$t0, 0($sp)			# restores t0
					
				addi	$t0, 4				# add 4 to i.  Goes to index
				addi	$a2, 1
				j		printLoop
				
				
exitPrint:		lw		$ra, 4($sp)			# restores ra
				addiu	$sp, $sp, 8			# restores &sp to 0		
				jr		$ra					# goes back to function that called
				
printLine:		la		$a0, LINE
				li		$v0, 4
				syscall
				jr		$ra
				
printVal:		la		$t5, PT				# t5 = &PT
				addu	$t6, $a1, $a1		# t6 = 2(a0) = board[i]
				addu	$t6, $t6, $t6		# t6 = 4(a0) = board[i]
				addu	$t5, $t6, $t5		# t5 = 4(a0) + &PT	
				lw		$t5, 0($t5)			# t5 = PT[i]
				jr		$t5

L0:				la		$a0, SPACE			# prints ' '
				li		$v0, 4
				syscall
				jr		$ra
				
L1:				la		$a0, X				# prints 'X'
				li		$v0, 4
				syscall				
				jr		$ra
				
L2:				la		$a0, O				# prints 'O'
				li		$v0, 4
				syscall
				jr		$ra

#------------------------------------------------------------------------------
# prints seperator -+ n times with a \n between each i % n = 0
# takes in a0 to compute if a seperator needs to be printed
# c++:
# void print(const TicTacToeGame & g)
# {
#    printSeperator(g);
#    for (int i = 0; i < (g.n * g.n); ++i)
#    {
#        if (i >= g.n && (i % g.n == 0))
#        {
#            std::cout << "|";
#            printSeperator(g);
#        }
#        std::cout << '|';
#        std::cout << g.board[i];
#    }
#    std::cout << "|";
#    printSeperator(g);
# }
#------------------------------------------------------------------------------
seperator:	blt		$a2, $s1, exitSep		# i < n break
			divu	$a2, $s1				# i / n
			mfhi	$t3
			bne		$t3, $zero, exitSep		# t3 == 0, else break
			
			addiu	$sp, $sp, -4		# moves sp down a word
			sw		$ra, 0($sp)			# stores &$ra into top of stack		
			jal 	printLine			# prints '|'
			lw		$ra, 0($sp)			# restores ra
			addiu	$sp, $sp, 4			# restores &sp to 0	
			la		$a0, NEWLINE		# a0 = '\n'
			li		$v0, 4				# print NEWLINE
			syscall	
			
firstSep:	la		$a0, PLUS			# a0 = '+'
			li 		$v0, 4
			syscall
			
			li		$t0, 0 				# t0 = i
sepLoop:	bge		$t0, $s1, exitSL	# i > n go to exit			
			la 		$a0, DIVIDER		# a0 = "-+"
			li 		$v0, 4				# print DIV
			syscall
			addi	$t0, 1				# i++
			j		sepLoop
			
exitSL:		la		$a0, NEWLINE		# t0 = '\n'
			li		$v0, 4				# print NEWLINE
			syscall			

exitSep:	jr		$ra


#------------------------------------------------------------------------------
# playerMove  Takes in a row and column number
#
# c++:
# void get_move(TicTacToeGame & g)
#{
#    bool valid = 0;
#    while (!valid)
#    {
#        std::cout << "Player " << g.turn << "'s move: ";
#        std::cin >> g.r >> g.c;
#        g.move = g.r * g.n + g.c;
#        
#        //make sure row and col don't go over n and spot is empty
#        if (g.board[g.move] == ' ' && g.r < g.n && g.c < g.n) valid = 1;
#    }
#}
#------------------------------------------------------------------------------
playerMove:		la		$a0, ROW		# print "Enter row: "
				li		$v0, 4
				syscall
				
				li		$v0, 5			# user inputs row
				syscall
				move	$t4, $v0		# t4 = row
				
				la		$a0, COL		# print "Enter col: "
				li		$v0, 4
				syscall
				
				li		$v0, 5			# user inputs col
				syscall
				move	$t5, $v0		# t5 = col
				
				mul		$t4, $t4, $s1 	# t4 = t4 * s1 = row * n
				add		$t4, $t4, $t5	# t4 = row * n + col
				add		$t4, $t4, $t4
				add		$t4, $t4, $t4	# 4 * move
				
				add		$t5, $s0, $t4	# t5 = &board[move]
				
				li		$t6, 1			# 1 into t6 for X
				sw		$t6, 0($t5)
				j		endCheck
#------------------------------------------------------------------------------
# gameLoop
#------------------------------------------------------------------------------
startGame:		# make bot first move

gameLoop:		jal	printBoard
				#beq		$s4, $zero, botMove		# branches to botMove if O turn
				j	playerMove				# else, player move
endCheck:		# bool checks
				j gameLoop

endGame:		j	EXIT
#------------------------------------------------------------------------------
# main
#------------------------------------------------------------------------------
main:		la		$a0, INTRO		# prints let's play a game of tic-tac-toe
			li		$v0, 4
			syscall
			
			li		$v0, 5			# gets n from user
			syscall
			move	$s1, $v0		# s1 = n
			mul		$s2, $s1, $s1	# s2 = len = s1 * s1 == n * n
			la		$s0, BOARD		# s0 = &BOARD
			
			add		$s3, $s2, $s2 		# t1 = 2len ERROR
			add		$s3, $s3, $s3 		# t1 = 4len ERROR
			jal		init				# initialize board
			
			la		$a0, FIRST		# prints "I'll go first"
			li		$v0, 4
			syscall	
			
			j			startGame
			jal			printBoard
			
EXIT:		li		$v0, 10
			syscall

#################################################################
# 
# data segment 
# 
#################################################################
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
PT:			.word L0 L1 L2		

BOARD:		.word 0
