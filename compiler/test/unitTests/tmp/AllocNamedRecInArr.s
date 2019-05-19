format:
.string	"%d\n"
.data
.align 8
heap1:
.space 1048576
freeHeap2:
.space 8
endHeap3:
.space 8
mainSPoint4:
.space 8
mainBPoint5:
.space 8
.text
.globl main
main:
	push %rbp
	movq %rsp, %rbp
	push %rbx
	push %r12
	push %r13
	push %r14
	push %r15
	subq $288, %rsp
	movq %rsp, mainSPoint4
	movq %rbp, mainBPoint5
	movq $heap1, freeHeap2
	movq $heap1, endHeap3
	addq $1048576, endHeap3
#line: 4 allocate of length statement
	movq %rbp, %rdi
	movq freeHeap2, %r8
	movq $-6, %rdx
	movq %r8, (%rdi,%rdx,8)
	movq %rbp, %rdi		#resetting basepointer
	movq $30, %r9
	movq %r9, %rbx
	cmp $0, %rbx
	jg allocPos8
	movq $4, %rax#negative allocation size
	jmp errorCleanup6
allocPos8:
	movq %r9, %rbx
	incq %rbx#making room for arraySize
	imulq $8, %rbx
	addq %rbx, freeHeap2
	movq freeHeap2, %rbx
	cmp endHeap3, %rbx
	jl allocSucc9
	movq $6, %rax#outofMemory
	jmp errorCleanup6
allocSucc9:
	movq %r8, %rcx
	movq %r9, (%rcx)
#line: 5 allocate statement
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref12#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref12:
	movq $0, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError11#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed10#not indexOutOfBounds
indeksError11:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed10:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref13#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref13:
	movq freeHeap2, %rbx
	movq %r8, %rcx
	movq %rbx, (%rcx)
	addq $16, freeHeap2
	movq freeHeap2, %rbx
	cmp endHeap3, %rbx
	jl allocSucc14
	movq $6, %rax#outofMemory
	jmp errorCleanup6
allocSucc14:
#line: 6 allocate statement
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref17#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref17:
	movq $1, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError16#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed15#not indexOutOfBounds
indeksError16:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed15:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref18#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref18:
	movq freeHeap2, %rbx
	movq %r8, %rcx
	movq %rbx, (%rcx)
	addq $16, freeHeap2
	movq freeHeap2, %rbx
	cmp endHeap3, %rbx
	jl allocSucc19
	movq $6, %rax#outofMemory
	jmp errorCleanup6
allocSucc19:
#line: 7 assign statement
	movq $0, %r9
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref24#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref24:
	movq $0, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError23#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed22#not indexOutOfBounds
indeksError23:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed22:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref25#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref25:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref20#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref20:
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref21#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref21:
	movq %r8, %rcx
	movq %r9, (%rcx)
#line: 8 assign statement
	movq $1, %r9
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref30#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref30:
	movq $1, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError29#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed28#not indexOutOfBounds
indeksError29:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed28:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref31#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref31:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref26#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref26:
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref27#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref27:
	movq %r8, %rcx
	movq %r9, (%rcx)
#line: 9 assign statement
	movq $1, %r9
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref36#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref36:
	movq $0, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError35#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed34#not indexOutOfBounds
indeksError35:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed34:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref37#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref37:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref32#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref32:
	addq $8, %rbx
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref33#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref33:
	movq %r8, %rcx
	movq %r9, (%rcx)
#line: 10 assign statement
	movq $0, %r9
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref42#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref42:
	movq $1, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError41#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed40#not indexOutOfBounds
indeksError41:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed40:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref43#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref43:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref38#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref38:
	addq $8, %rbx
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref39#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref39:
	movq %r8, %rcx
	movq %r9, (%rcx)
#line: 12 write statement
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref48#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref48:
	movq $0, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError47#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed46#not indexOutOfBounds
indeksError47:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed46:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref49#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref49:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref44#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref44:
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref45#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref45:
	push %rdi
	movq %r8, %rcx
	movq (%rcx), %rsi
	movq $format, %rdi
	movq $0, %rax
	call printf
	pop %rdi
#line: 13 write statement
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref54#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref54:
	movq $1, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError53#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed52#not indexOutOfBounds
indeksError53:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed52:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref55#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref55:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref50#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref50:
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref51#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref51:
	push %rdi
	movq %r8, %rcx
	movq (%rcx), %rsi
	movq $format, %rdi
	movq $0, %rax
	call printf
	pop %rdi
#line: 14 write statement
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref60#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref60:
	movq $0, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError59#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed58#not indexOutOfBounds
indeksError59:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed58:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref61#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref61:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref56#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref56:
	addq $8, %rbx
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref57#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref57:
	push %rdi
	movq %r8, %rcx
	movq (%rcx), %rsi
	movq $format, %rdi
	movq $0, %rax
	call printf
	pop %rdi
#line: 15 write statement
	movq %rbp, %rdi
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %r8
	movq %rbp, %rdi		#resetting basepointer
	cmp $0, %r8
	jne nonNullDeref66#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref66:
	movq $1, %rbx
	movq %r8, %rcx
	cmp (%rcx), %rbx
	jge indeksError65#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed64#not indexOutOfBounds
indeksError65:
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup6
indeksAllowed64:
	incq %rbx#moving past array-size-value
	imulq $8, %rbx
	addq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref67#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref67:
	movq %r8, %rcx
	movq (%rcx), %rbx
	cmp $0, %rbx
	jne nonNullDeref62#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref62:
	addq $8, %rbx
	movq %rbx, %r8
	cmp $0, %r8
	jne nonNullDeref63#not NULL
	movq $5, %rax
	jmp errorCleanup6
nonNullDeref63:
	push %rdi
	movq %r8, %rcx
	movq (%rcx), %rsi
	movq $format, %rdi
	movq $0, %rax
	call printf
	pop %rdi
	movq $0, %rax
mainend:
	addq $288, %rsp
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %rbx
	movq %rbp, %rsp
	pop %rbp
	ret 



errorCleanup6:
	movq mainSPoint4, %rsp
	movq mainBPoint5, %rbp
	jmp mainend
