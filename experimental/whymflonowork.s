			.text
			.globl main
			
main:		li		$t1, 10
			li		$s0, 100
			divu	$s0, $t1	# divide s0 by 10 to get HI, LO
			mflo	$s0			# move quotient of s0 / 10 into s0
			mfhi	$s1			# move s0 % 10 into s1
					
			li		$t1, 10
			li		$s0, 100
			divu	$s0, $t1
			mflo	$s0
			mfhi	$s1
			
			li		$t1, -10
			li		$t2, 100
			divu 	$t2, $t1			# t8 / t7 = 2
			mflo	$s0
			move	$a0, $s0
			li		$v0, 1
			syscall
			
EXIT:		li		$v0, 10
			syscall