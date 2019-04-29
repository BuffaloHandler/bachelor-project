format:
.string	"%d\n"
.data
.align 8
heap0:
.space 16384
freeHeap1:
.space 8
endHeap2:
.space 8
mainSPoint3:
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
	subq $136, %rsp
	movq %rsp, mainSPoint3
	movq $heap0, freeHeap1
	movq $heap0, endHeap2
	addq $16384, endHeap2
	push %rbx
	movq %rbp, %rbx
	movq $-9, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $-9, %rdx
	movq (%rbp,%rdx,8), %rbx
	movq %rbx, %rdi
	pop %rbx
	movq freeHeap1, %rbx
	movq $-6, %rdx
	movq %rbx, (%rdi,%rdx,8)
	movq %rbp, %rdi#resetting basepointer
	addq $24, freeHeap1
	movq freeHeap1, %rbx
	cmp endHeap2, %rbx#may be out of order
	jl allocSucc3
	movq $6, %rax#outofMemory
	jmp errorCleanup4
allocSucc3:
	push %rbx
	movq %rbp, %rbx
	movq $-10, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $-10, %rdx
	movq (%rbp,%rdx,8), %rbx
	movq %rbx, %rdi
	pop %rbx
#creating record dereferencing
	movq $-6, %rdx
	movq (%rdi,%rdx,8), %rbx
	movq %rbp, %rdi#resetting basepointer
	addq $8, %rbx
	movq $-11, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq freeHeap1, %rbx
	movq $-11, %rdx
	movq (%rbp,%rdx,8), %rcx
	movq %rbx, (%rcx)
	movq %rbp, %rdi#resetting basepointer
	addq $24, freeHeap1
	movq freeHeap1, %rbx
	cmp endHeap2, %rbx#may be out of order
	jl allocSucc4
	movq $6, %rax#outofMemory
	jmp errorCleanup4
allocSucc4:
	push %rbx
	movq %rbp, %rbx
	movq $-12, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $-12, %rdx
	movq (%rbp,%rdx,8), %rbx
	movq %rbx, %rdi
	pop %rbx
	movq freeHeap1, %rbx
	movq $-7, %rdx
	movq %rbx, (%rdi,%rdx,8)
	movq %rbp, %rdi#resetting basepointer
	movq $-13, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $3, %rbx
	cmp $0, %rbx
	jg allocPos5
	movq $4, %rax#negative allocation size
	jmp errorCleanup4
allocPos5:
	addq $1, %rbx#making room for arraySize
	imulq $8, %rbx
	addq %rbx, freeHeap1
	movq freeHeap1, %rbx
	cmp endHeap2, %rbx#may be out of order
	jl allocSucc6
	movq $6, %rax#outofMemory
	jmp errorCleanup4
allocSucc6:
	movq $3, %rbx
	movq $-13, %rdx
	movq (%rbp,%rdx,8), %rcx
	movq %rbx, (%rcx)
	push %rbx
	movq %rbp, %rbx
	movq $-15, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $-15, %rdx
	movq (%rbp,%rdx,8), %rbx
	movq %rbx, %rdi
	pop %rbx
	movq $-7, %rdx
	movq (%rdi,%rdx,8), %rbx
	movq $-14, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq %rbp, %rdi#resetting basepointer
	movq $2, %rbx
	movq %rbp, %rdi#resetting basepointer
	movq $-14, %rdx
	movq (%rbp,%rdx,8), %rcx
	cmp (%rcx), %rbx
	jge indeksError8#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed7#not indexOutOfBounds
indeksError8:
#Exit program with error here
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup4
indeksAllowed7:
	addq $1, %rbx#moving past array-size-value
	imulq $8, %rbx
	movq $-14, %rdx
	addq %rbx, (%rbp,%rdx,8)
	movq freeHeap1, %rbx
	movq $-14, %rdx
	movq (%rbp,%rdx,8), %rcx
	movq %rbx, (%rcx)
	movq %rbp, %rdi#resetting basepointer
	movq $-16, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $300, %rbx
	cmp $0, %rbx
	jg allocPos9
	movq $4, %rax#negative allocation size
	jmp errorCleanup4
allocPos9:
	addq $1, %rbx#making room for arraySize
	imulq $8, %rbx
	addq %rbx, freeHeap1
	movq freeHeap1, %rbx
	cmp endHeap2, %rbx#may be out of order
	jl allocSucc10
	movq $6, %rax#outofMemory
	jmp errorCleanup4
allocSucc10:
	movq $300, %rbx
	movq $-16, %rdx
	movq (%rbp,%rdx,8), %rcx
	movq %rbx, (%rcx)
	push %rbx
	movq %rbp, %rbx
	movq $-18, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $-18, %rdx
	movq (%rbp,%rdx,8), %rbx
	movq %rbx, %rdi
	pop %rbx
	movq $-7, %rdx
	movq (%rdi,%rdx,8), %rbx
	movq $-17, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq %rbp, %rdi#resetting basepointer
	movq $2, %rbx
	movq %rbp, %rdi#resetting basepointer
	movq $-17, %rdx
	movq (%rbp,%rdx,8), %rcx
	cmp (%rcx), %rbx
	jge indeksError12#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed11#not indexOutOfBounds
indeksError12:
#Exit program with error here
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup4
indeksAllowed11:
	addq $1, %rbx#moving past array-size-value
	imulq $8, %rbx
	movq $-17, %rdx
	addq %rbx, (%rbp,%rdx,8)
	movq $-17, %rdx
	movq (%rbp,%rdx,8), %rcx
	movq (%rcx), %rbx
	movq %rbp, %rdi#resetting basepointer
	movq $-19, %rdx
	movq %rbx, (%rbp,%rdx,8)
	push %rbx
	movq %rbp, %rbx
	movq $-22, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq $-22, %rdx
	movq (%rbp,%rdx,8), %rbx
	movq %rbx, %rdi
	pop %rbx
	movq $-7, %rdx
	movq (%rdi,%rdx,8), %rbx
	movq $-21, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq %rbp, %rdi#resetting basepointer
	movq $2, %rbx
	movq %rbp, %rdi#resetting basepointer
	movq $-21, %rdx
	movq (%rbp,%rdx,8), %rcx
	cmp (%rcx), %rbx
	jge indeksError16#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed15#not indexOutOfBounds
indeksError16:
#Exit program with error here
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup4
indeksAllowed15:
	addq $1, %rbx#moving past array-size-value
	imulq $8, %rbx
	movq $-21, %rdx
	addq %rbx, (%rbp,%rdx,8)
	movq $-21, %rdx
	movq (%rbp,%rdx,8), %rcx
	movq (%rcx), %rbx
	movq $-20, %rdx
	movq %rbx, (%rbp,%rdx,8)
	movq %rbp, %rdi#resetting basepointer
	movq $25, %rbx
	movq %rbp, %rdi#resetting basepointer
	movq $-20, %rdx
	movq (%rbp,%rdx,8), %rcx
	cmp (%rcx), %rbx
	jge indeksError14#indexOutOfBounds
	cmp $0, %rbx
	jge indeksAllowed13#not indexOutOfBounds
indeksError14:
#Exit program with error here
	movq $2, %rax#IndexOutOfBounds
	jmp errorCleanup4
indeksAllowed13:
	addq $1, %rbx#moving past array-size-value
	imulq $8, %rbx
	movq $-20, %rdx
	addq %rbx, (%rbp,%rdx,8)
	movq $-19, %rdx
	movq (%rbp,%rdx,8), %rbx
	movq $-20, %rdx
	movq (%rbp,%rdx,8), %rcx
	movq %rbx, (%rcx)
	movq %rbp, %rdi#resetting basepointer
mainend:
	addq $136, %rsp
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %rbx
	movq %rbp, %rsp
	pop %rbp
	ret 



errorCleanup4:
	movq mainSPoint3, %rsp
	jmp mainend
