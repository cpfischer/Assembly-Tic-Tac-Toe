#================================================================
# Filename: mainExperimental.s
# Author: Caleb Fischer
#
# Description
# in word:  0 = ' ', 1 = 'X', 2 = 'O'
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
playerMove:		addi	$t6, $s1, -1
				la		$a0, ROW		# print "Enter row: "
				li		$v0, 4
				syscall
				
				li		$v0, 5			# user inputs row
				syscall
				move	$t4, $v0		# t4 = row
				bgt		$t4, $t6, playerMove	# row > n, re enter
				blt		$t4, $zero, playerMove	# col < 0, re enter
				
colError:		la		$a0, COL		# print "Enter col: "
				li		$v0, 4
				syscall
				
				li		$v0, 5			# user inputs col
				syscall
				move	$t5, $v0		# t5 = col
				bgt		$t5, $t6, colError	# col > n, re enter
				blt		$t5, $zero, colError	# col < 0, re enter
				
				
				mul		$t4, $t4, $s1 	# t4 = t4 * s1 = row * n
				add		$t4, $t4, $t5	# t4 = row * n + col
				add		$t4, $t4, $t4
				add		$t4, $t4, $t4	# 4 * move
				
				add		$t5, $s0, $t4	# t5 = &board[move]
				lw		$t6, 0($t5)
				bne		$t6, $zero, playerMove	# checks if spot is empty
				
				li		$t6, 1			# 1 into t6 for X
				sw		$t6, 0($t5)
				jr		$ra

#------------------------------------------------------------------------------
# botFirst
# bot places O in center
# c++:
#void botFirst(TicTacToeGame & g)
#{
#    int place = g.len / 2;
#    if (g.len % 2 == 0)
#    {
#        place -= g.n / 2 + 1;
#    }
#    
#    g.board[place] = 'O';
#}
#------------------------------------------------------------------------------
botFirst:	li		$t3, 2			# len / 2
			div		$s2, $t3
			mfhi	$t4				# len % 2
			div		$s2, $t3		# if odd, t5 = 4(len / 2)
			mflo	$t5				# t5 = 4len / 2  t5 == place
			add		$t5, $t5, $t5
			add		$t5, $t5, $t5
			
			beq		$t4, $zero, evenFirst
			j		firstMove				

evenFirst:	div		$s1, $t3		# n / 2
			mflo	$t6				# t6 = n / 2
			add		$t6, $t6, $t6	# 2t6
			add		$t6, $t6, $t6	# 4t6
			addi	$t6, $t6, 4		# 4t6 + 4
			sub		$t5, $t5, $t6	# place -= 4(n / 2 + 1)
			
firstMove:	add		$t5, $s0, $t5	# &board + place
			sw		$t3, 0($t5)		# 2 into board[place] = 'O'
			jr		$ra

#------------------------------------------------------------------------------
# bot normal moves.  Checks for win by row, then column, then \, then / diags
# If no wins, attempts to block X.  If no need to block, picks the first open
# space
#------------------------------------------------------------------------------
botMove:		li		$t0, 0		# i
				li		$t1, 2		# O value
				addiu	$sp, $sp, -4			# moves sp down 1 words
				sw		$ra, 0($sp)				# stores &$ra into top of stack
				
botLoop:		bge		$t0, $s3, firstOpen
				
				add		$t4, $s0, $t0		# t4 = &board[i]
				lw		$t5, 0($t4)			# t5 = board[i]
				bne		$t5, $zero, botElse	# checks if spot is empty
				sw		$t1, 0($t4)			# sets &board[i] = 2 = 'O'
				addiu	$sp, $sp, -16		# moves sp down 16
				
				sw		$t0, 0($sp)
				sw		$t1, 4($sp)
				sw		$t4, 8($sp)
				sw		$t5, 12($sp)		# stack: ra, t0, t1, t4, t5
				jal		winCheck	
				
				lw		$t0, 0($sp)
				lw		$t1, 4($sp)
				lw		$t4, 8($sp)
				lw		$t5, 12($sp)		# restores t0, t1, t4, t5
				addiu	$sp, $sp, 16
				
				li		$t6, 1
				beq		$v1, $t6, exitBot	# if bot win, exit
				sw		$zero, 0($t4)		# else, board[i] = 0 = ' '
				
botElse:		addi	$t0, 4		# i + 4
				j		botLoop
				
				
firstOpen:		li		$t0, 0				# i  Sets first open space to 'O'
openLoop:		bge		$t0, $s3, exitBot
				add		$t4, $s0, $t0		 	# t4 = &board[i]
				lw		$t5, 0($t4)			 	# t5 = board[i]
				beq		$t5, $zero, openExit	 # checks if spot is empty
				addi	$t0, 4				 # i + 4		
				j		openLoop
				
openExit:		sw		$t1, 0($t4)			 	# sets &board[i] = 2 = 'O'
				j		exitBot
				
				
exitBot:		lw		$ra, 0($sp)
				addiu	$sp, $sp, 4			# restores ra and sp
				jr		$ra			

#------------------------------------------------------------------------------
# game over checks
#------------------------------------------------------------------------------
winCheck:		li		$t6, 1					# xValue and bool
				li		$t7, 2					# oValue
				
				addiu	$sp, $sp, -4			# moves sp down 1 words
				sw		$ra, 0($sp)				# stores &$ra into top of stack

#------------------------------------------------------------------------------
# row win check
#------------------------------------------------------------------------------
rowWin:			li		$t4, 1					# xWin bool
				li		$t5, 1					# oWin bool
				li		$t0, 0					# i
				add		$t9, $s1, $s1
				add		$t9, $t9, $t9			# t9 = 4n
				
rowLoop:		bge		$t0, $s3, exitRow		# i >= 4len, break
				add		$t1, $s0, $t0			# t1 = &board + i
				lw		$t2, 0($t1)				# board[i]
				
				jal		xFalse					# check if xWin	
				jal		oFalse					# check if oWin
				
				addi	$t0, $t0, 4				# i + 4
				bge		$t0, $t9, exitRowCheck	# i + 4 >= 4n
				j		rowLoop

exitRowCheck:	bge		$t0, $s3, exitRow		# i >= 4len, break
				div		$t0, $t9				# i % 4n
				mfhi	$t3
				bne		$t3, $zero, rowLoop		# i % 4n != 0, loop
				
				beq		$t4, $t6, exitBool		# xWin == 1, exit
				beq		$t5, $t6, exitBool		# oWin == 1, exit
				li		$t4, 1					# resets xWin and oWin to True
				li		$t5, 1					# for next row check
				j		rowLoop
				
exitRow:		beq		$t4, $t6, exitBool		# xWin == 1, exit
				beq		$t5, $t6, exitBool		# oWin == 1, exit

#------------------------------------------------------------------------------
# col win check
#------------------------------------------------------------------------------
colWin:			li		$t4, 1					# xWin bool
				li		$t5, 1					# oWin bool
				li		$t0, 0					# i
				add		$t9, $s1, $s1
				add		$t9, $t9, $t9			# t9 = 4n
				
colILoop:		bge		$t0, $t9, exitCol		# i >= 4n, break
				move	$t8, $t0				# j = i
				
colJLoop:		bge		$t8, $s3, exitColJ		# j >= 4len, break
				add		$t1, $s0, $t8			# t1 = &board + j
				lw		$t2, 0($t1)				# board[i]
				
				jal		xFalse					# check if xWin	
				jal		oFalse					# check if oWin
				
				add		$t8, $t8, $t9			# j + 4n
				j		colJLoop
				
exitColJ:		addi	$t0, 4					# i + 4
				j		exitColCheck

exitColCheck:	bge		$t0, $t9, exitCol		# i >= 4n, break
				beq		$t4, $t6, exitBool		# xWin == 1, exit
				beq		$t5, $t6, exitBool		# oWin == 1, exit
				li		$t4, 1					# resets xWin and oWin to True
				li		$t5, 1					# for next row check
				j		colILoop
				
exitCol:		beq		$t4, $t6, exitBool		# xWin == 1, exit
				beq		$t5, $t6, exitBool		# oWin == 1, exit

#------------------------------------------------------------------------------
# right diagonal check \
#------------------------------------------------------------------------------
				
rightDiag:		li		$t4, 1					# xWin bool
				li		$t5, 1					# oWin bool
				li		$t0, 0					# i
				addi	$t8, $s1, 1				# 1 + n
				add		$t8, $t8, $t8
				add		$t8, $t8, $t8			# 4(n + 1)
	
rdLoop:			bge		$t0, $s3, exitRd		# i >= 4len, next check
				add		$t1, $s0, $t0			# t1 = &board + i
				lw		$t2, 0($t1)				# board[i]
				
				jal		xFalse					# check if xWin	
				jal		oFalse					# check if oWin
				
				add		$t0, $t0, $t8			# i + 4(n + 1)
				j		rdLoop

exitRd:			beq		$t4, $t6, exitBool		# xWin == 1, exit
				beq		$t5, $t6, exitBool		# oWin == 1, exit
					
#------------------------------------------------------------------------------
# left diagonal check /
#------------------------------------------------------------------------------
leftDiag:		li		$t4, 1					# xWin bool
				li		$t5, 1					# oWin bool
				li		$t0, 0					# i
				
				addi	$t8, $s1, -1			# -1 + n
				add		$t8, $t8, $t8
				add		$t8, $t8, $t8			# 4(n - 1)
				move	$t0, $t8				# i = 4(n - 1)
				addi	$t9, $s3, -4			# 4len - 4
				
ldLoop:			bge		$t0, $t9, exitLd		# i >= 4len - 4, break
				add		$t1, $s0, $t0			# t1 = &board + i
				lw		$t2, 0($t1)				# board[i]
				
				jal		xFalse					# check if xWin	
				jal		oFalse					# check if oWin
				
				add		$t0, $t0, $t8			# i + 4(n + 1)
				j		ldLoop

exitLd:			beq		$t4, $t6, exitBool		# xWin == 1, exit
				beq		$t5, $t6, exitBool		# oWin == 1, exit
				
#------------------------------------------------------------------------------
# tie check
#------------------------------------------------------------------------------
				
tieCheck:		li		$t6, 1					# tie bool
				li		$t0, 0					# i
	
tieLoop:		bge		$t0, $s3, exitTie		# i >= 4len, next check
				add		$t1, $s0, $t0			# t1 = &board + i
				lw		$t2, 0($t1)				# board[i]
				
				beq		$t2, $zero, exitBool	# check if noTie	
				
				addi	$t0, $t0, 4			# i + 4
				j		tieLoop

exitTie:		j		tieTrue		# xWin == 1, exit
#------------------------------------------------------------------------------
# checks if t2 is X or O, sets t4 to false otherwise
#------------------------------------------------------------------------------
				
xFalse:			beq		$t2, $t6, xTrue			# board[i] == 1 = X		
				li		$t4, 0					# xWin = 0
xTrue:			jr		$ra

oFalse:			beq		$t2, $t7, oTrue			# board[i] == 2 = O
				li		$t5, 0					# oWin = 0
oTrue:			jr		$ra		
					
exitBool:		li		$t6, 0					# tie = false
				lw		$ra, 0($sp)				# restores ra
				move	$v0, $t4				# v0 = xWin
				move	$v1, $t5				# v1 = oWin
				addiu	$sp, $sp, 4				# moves sp up 1 words
				jr		$ra	

tieTrue:		lw		$ra, 0($sp)				# restores ra
				addiu	$sp, $sp, 4			# moves sp down 1 words
				li		$v0, 0
				li		$v1, 0
				li		$t6, 1					# tie = true, others = false
				jr		$ra
#------------------------------------------------------------------------------
# gameLoop
#------------------------------------------------------------------------------
startGame:		jal		botFirst
				j		gameLoop2
				
gameLoop:		jal		botMove
gameLoop2:		jal		printBoard
				jal		winCheck
				li		$t4, 1					# true
				beq		$v0, $t4, xWinEnd		# xWin message
				beq		$v1, $t4, oWinEnd		# oWin message
				beq 	$t6, $t4, tieEnd
				
				jal		playerMove				# else, player move
				jal		printBoard
				jal 	winCheck
				li		$t4, 1					# true
				beq		$v0, $t4, xWinEnd		# xWin message
				beq 	$t6, $t4, tieEnd
				j 		gameLoop

xWinEnd:		la		$a0, UWIN		# prints "You are the winner!"
				li		$v0, 4
				syscall	
				j		endGame

oWinEnd:		la		$a0, IWIN		# prints "I am the winner!"
				li		$v0, 4
				syscall	
				j		endGame
				
tieEnd:			la		$a0, SCRATCH	# prints "We have a draw!"
				li		$v0, 4
				syscall
				
endGame:		j		EXIT

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
IWIN:		.asciiz "I'm the winner!\n"
UWIN:		.asciiz "You are the winner!\n"
SCRATCH:	.asciiz "We have a draw!\n"
PT:			.word L0 L1 L2		

BOARD:		.word 0
