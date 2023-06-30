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
; A simple file handeling program written in x86_64 assembly langauge for linux.
; Note: If out.txt cannot currently create files, you must create out.txt first 
;		in the same directory as the script is getting run in before you run the 
;		script.
;
; TODO: Create out.txt in local dir if it does not exist (O_CREAT flag + modes)
; TODO: Finish commenting code
; TODO: Read from file
;
; COMPILE:
; nasm -f elf64 ./file_handeling.asm -o ./build/file_handeling.o
; gcc ./build/file_handeling.o -o ./build/file_handeling -fno-pie -no-pie
;


global	main													; Make the main function global so it can be linked by gcc


section	.bss

	fd			resw	1


section	.rodata													; Define constants

	O_RDONLY:	dd		00
	O_WRONLY:	dd		01
	O_RDWR:		dd		02

;	O_CREAT:	dd		0100
;
;	S_IWUSR:	dd		00200
;	S_IRUSR:	dd		00400

	FILENAME:	db		"out.txt", 0x0

	MSG:		db		"Help Me", 0xa, 0x0
	MSG_LEN:	equ		$ - MSG


section	.text													; Code section
	
	%macro	open	2											; For when no mode argument passed
		
		push	rdi
		push	rsi

		mov		rax, 2
		mov		rdi, %1
		mov		rsi, %2
		syscall

		pop		rsi
		pop		rdi

	%endmacro


	%macro	open	3											; For when mode argument passed

		push	rdi
		push	rsi
		push	rdx

		mov		rax, 2
		mov		rdi, %1
		mov		rsi, %2
		mov		rdx, %3
		syscall

		pop		rdx
		pop		rsi
		pop		rdi
	
	%endmacro


	%macro	read	3

		push	rdi
		push	rsi

		mov		rax, 0
		mov		rdi, %1
		mov		rsi, %2
		syscall

		pop		rsi
		pop		rdi

	%endmacro


	%macro	write	3

		push	rdi
		push	rsi

		mov		rax, 1
		mov		rdi, %1
		mov		rsi, %2
		syscall

		pop		rsi
		pop		rdi

	%endmacro


	%macro	close	1
		
		push	rdi

		mov		rax, 3
		mov		rdi, %1

		pop		rdi

	%endmacro


	%macro	print	2											; Define a macro (subroutine) called print with 2 perameters

		push	rax												; Push the value of %rax onto the stack for preservation
		push	rdi												; Push the value of %rdi onto the stack for preservation
		push	rsi												; Push the value of %rsi onto the stack for preservation
		push	rdx												; Push the value of %rdx onto the stack for preservation

		mov		rax, 1											; Move write syscall number (1) to %rax
		mov		rdi, 1											; Set arg0 (%rdi), file descriptor, to 1 (std_out)
		mov		rsi, %1											; Set arg1 (%rsi), char *buffer, to 1st macro argument
		mov		rdx, %2											; Set arg2 (%rdx), *buffer length, to 2nd macro argument
		syscall													; Call syscall 1 (write) to print MSG to the console

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
		open	FILENAME, O_WRONLY								; Open out.txt with write only permissions -> file_descriptor
		mov		[fd], ax										; Move file_descriptor to fd address
		write	[fd], MSG, MSG_LEN								; Write to out.txt with MSG_LEN bytes with MSG 
		close	[fd]											; Close out.txt, saving changes
		exit													; Exit the program with no errors
