; MIT License
;
; Copyright (c) 2023 Michael Tennant
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;
;
; ABOUT:
; A simple user input program written in x86_64 assembly langauge for linux.
;
; COMPILE:
; nasm -f elf64 ./user_input.asm -o ./build/user_input.o
; gcc ./build/user_input.o -o ./build/user_input -fno-pie -no-pie
;


global	main													; Make the main function global so it can be linked by gcc


section	.bss													; Reserve memory addresses (variables)

	buffer:			resb	1024								; Reserve 1024 bytes for memory address (variable) labeled buffer



section	.rodata													; Define constants

	BUFFER_SIZE:	dd		1024								; Define BUFFER_SIZE as 1024

	MSG0:			db		"Input a string: ", 0x0				; Define MSG0 constant as "Hello World!\n"
	MSG0_LEN:		equ		$ - MSG0							; Define MSG0_LEN as current_memory_address - MSG0_memory_address
																; AKA the length of MSG0 in bytes
	MSG1:			db		"You inputed the string: ", 0x0		; Define MSG1 constant as "You inputed the string: "
	MSG1_LEN:		equ		$ - MSG1							; Define MSG1_LEN as current_memory_address - MSG1_memory_address
																; AKA the length of MSG1 in bytes
	LINE_FEED:		db		0xa, 0x0							; Define LINE_FEED constant as "\n"
	LINE_FEED_LEN:	equ		$ - LINE_FEED						; Define LINE_FEED_LEN as current_memory_address - LINE_FEED_addr
																; AKA the length of LINE_FEED in bytes



section	.text													; Code section

	%macro	print	2											; Define a macro (subroutine) called print with 2 perameters

		push	rax												; Push the value of %rax onto the stack for preservation
		push	rdi												; Push the value of %rdi onto the stack for preservation
		push	rsi												; Push the value of %rsi onto the stack for preservation
		push	rdx												; Push the value of %rdx onto the stack for preservation

		mov		rax, 1											; Move write syscall number (1) to %rax
		mov		rdi, 1											; Set arg0 (%rdi), file descriptor, to 1 (std_out)
		mov		rsi, %1											; Set arg1 (%rsi), char *buffer, to 1st macro argument
		mov		rdx, %2											; Set arg2 (%rdx), *buffer length, to 2nd macro argument
		syscall													; Call syscall 1 (write) to print 1st macro argument to the console

		pop		rdx												; Restore %rdx from stack
		pop		rsi												; Restore %rsi from stack
		pop		rdi												; Restore %rdi from stack
		pop		rax												; Restore %rax from stack

	%endmacro													; End the multiline macro (subroutine) definition


	%macro	input	2											; Define a macro (subroutine) called input with 2 perameters

		push	rax												; Push the value of %rax onto the stack for preservation
		push	rdi												; Push the value of %rdi onto the stack for preservation
		push	rsi												; Push the value of %rsi onto the stack for preservation
		push	rdx												; Push the value of %rdx onto the stack for preservation

		mov		rax, 0											; Move write syscall number (0) to %rax
		mov		rdi, 0											; Set arg0 (%rdi), file descriptor, to 0 (std_in)
		mov		rsi, %1											; Set arg1 (%rsi), char *buffer, to 1st macro argument
		mov		rdx, %2											; Set arg2 (%rdx), *buffer length, to 2nd macro argument
		syscall													; Call syscall 0 (read) to print MSG to the console

		pop		rdx												; Restore %rdx from stack
		pop		rsi												; Restore %rsi from stack
		pop		rdi												; Restore %rdi from stack
		pop		rax												; Restore %rax from stack

	%endmacro													; End the multiline macro (subroutine) definition


	%macro	exit	0											; Define a macro (subroutine) called exit with 0 parameters
		
		mov		rax, 60											; Move exit syscall number (60) to %rax
		xor		rdi, rdi										; Set arg0 (%rdi), exit code, to 0 (no errors)
		syscall													; Call syscall 60 (exit) with exit code 0 (no errors)
	
	%endmacro													; End the multiline macro (subroutine) definition


	main:														; Define main function, start code here

		print	LINE_FEED, LINE_FEED_LEN						; Print newline to console
		print	MSG0, MSG0_LEN									; Print MSG with length MSG_LEN to the console
		input	buffer, BUFFER_SIZE								; Get user input, save to buffer address
		print	MSG1, MSG1_LEN									; Print MSG1 to console with length MSG1_LEN
		print	buffer, BUFFER_SIZE								; Print buffer to console with length BUFFER_SIZE
		print	LINE_FEED, LINE_FEED_LEN						; Print newline to console

		exit													; Exit the program with no errors
