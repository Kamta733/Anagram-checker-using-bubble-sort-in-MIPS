
.data
prompt1: .asciiz "\nEnter String 1 (Length <= 80 ) :"
prompt2: .asciiz "\nEnter String 2 (Length <= 80 ) :"
error1: .asciiz "\nLength Not equal - NOT AN ANAGRAM"
error2: .asciiz "\nAll characters used are not same - NOT AN ANAGRAM"
success: .asciiz "\nGiven strings are Anagram"
str1: .space 81
str1_Size: .word 80
str2: .space 81
str2_Size: .word 80
.text


.globl main
main:

       # Prompt for the string 1 to enter
       
li $v0, 4
la $a0, prompt1
syscall

       # Read the string1.
        
li $v0, 8
la $a0, str1
lw $a1, str1_Size
syscall

        # Prompt for the string 2 to enter
         
li $v0, 4
la $a0, prompt2
syscall

        # Read the string 2 .
          
li $v0, 8
la $a0, str2
lw $a1, str2_Size
syscall

         # Finding the length of string 1
         
li $t1,0
la $t0,str1

loop1:
lb $a0,0($t0)
beq $a0,'\n',done1
addi $t0,$t0,1                # Point to next char
addi $t1,$t1,1                # Incrementing the counter
j loop1

done1:
add $s5,$0,$t1 # $s5 will contain length of str1

         # Finding the length of string 2
        
li $t1,0
la $t0,str2
loop2:
lb $a0,0($t0)
beq $a0,'\n',done2
addi $t0,$t0,1                # Point to next char
addi $t1,$t1,1                # Incrementing the counter
j loop2

done2:
add $s6,$0,$t1                # $s6 will contain length of str2


        # comparing Length

bne $s5,$s6,Err1              # comparing the length of str1 and str2

        # Str1 upper to lower conversion
        
addi $t4,$zero,0

        # In ASCII the difference between upper case and lower case letters is the 0x20 bit.
        # To correctly handle converting from uppercase to lowercase, the letters should be OR'ed with 0x20
        
convLoop1:
lb $t2,str1($t4)              # get next char from str1
beqz $t2,done3
ori $s2,$t2,0x20
sb $s2,str1($t4)
addi $t4,$t4,1
j convLoop1

done3:
addi $t7,$zero,0

        # Str2 upper to lower conversion
        
addi $t4,$zero,0

        # In ASCII the difference between upper case and lower case letters is the 0x20 bit.
        # To correctly handle converting from uppercase to lowercase, the letters should be OR'ed with 0x20
        
convLoop2:
lb $t2,str2($t4)                # get next char from str1
beqz $t2,done4
ori $s2,$t2,0x20
sb $s2,str2($t4)
addi $t4,$t4,1
j convLoop2

done4:

         #BubbleSort str 1
         
li $t0,0                         # $t0 outer loop counter in C its like 'i'
addi $s5,$s5,-2                  # i <= str1_lenght-1
outer: bge $t0,$s5,endouter
li $t1,0                         # $t1 outer loop counter in C its like 'j'
sub $t4,$s5,$t0                  # j <= str1_lenght-1-i , $t4 = str1_lenght-1-i

inner:
sle $t2,$t1,$t4
beqz $t2,endinner
addi $t3,$t1,1                   # $t3 outer loop counter in C its like 'j+1'
lb $s0,str1($t1)
lb $s1,str1($t3)
sgt $t2,$s0,$s1
beqz $t2,endswap
sb $s0,str1($t3)
sb $s1,str1($t1)

endswap:
addi $t1,$t1,1
b inner
endinner:
addi $t7,$zero,0
addi $t0,$t0,1
b outer

endouter:
addi $t7,$zero,0

         #BubbleSort str2
li $t0,0
addi $s6,$s6,-2
outer2: bge $t0,$s6,endouter2
li $t1,0
sub $t4,$s6,$t0

inner2:
sle $t2,$t1,$t4
beqz $t2,endinner2
addi $t3,$t1,1
lb $s0,str2($t1)
lb $s1,str2($t3)
sgt $t2,$s0,$s1
beqz $t2,endswap2
sb $s0,str2($t3)
sb $s1,str2($t1)

endswap2:
addi $t1,$t1,1
b inner2
endinner2:
addi $t7,$zero,0
addi $t0,$t0,1
b outer2

endouter2:
addi $t7,$zero,0

          # Comparing Str1 and Str2
          
li $t0,0
cmploop:
lb $t2,str1($t0)                 # get next char from str1
lb $t3,str2($t0)                 # get next char from str2
bne $t2,$t3,Err2                 # are they different? if yes, fly
beq $t2,$zero,End                # at EOS? yes, fly (strings equal)
addi $t0,$t0,1
j cmploop
  
         # Error 1 : Length Not Equal
         
Err1:
li $v0, 4
la $a0, error1
syscall
j Exit

         # Error 2 : All character are not same
         
Err2:
li $v0, 4
la $a0, error2
syscall
j Exit

End:
li $v0, 4
la $a0,success
syscall
j Exit

         # Exit the program
         
Exit:
li $v0, 10
syscall
