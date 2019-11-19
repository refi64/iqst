%define sys_write 1
%define sys_exit 60

%define sys_stdout 1
%define sys_stderr 2

section .data
  usage_msg: db `usage: substring <string> <start> [<end>]\n`
  usage_msg_len: equ $ - usage_msg

  bad_number: db `invalid positive number\n`
  bad_number_len: equ $ - bad_number

section .text

global _start

_start:
  mov rbx, [rsp]
  sub rbx, 3
  js arg_count_fail

  cmp rbx, 1
  jg arg_count_fail

  ; rbx = 1: has end index
  ; rbx = 0: no end index

  ; r12 = the string
  mov r12, [rsp+16]

  ; r13 = length of the string
  mov rdi, r12
  call strlen
  mov r13, rax

  ; r14 = start index
  mov rdi, [rsp+24]
  call atoi
  mov r14, rax

  ; r15 = end index
  mov r15, r13
  test rbx, rbx
  jz main_after_end_index_check

  mov rdi, [rsp+32]
  call atoi
  mov r15, rax

  ; if the end index > start index, then swap them
  cmp r14, r15
  jle main_after_end_index_check
  xchg r14, r15

main_after_end_index_check:
  ; if start index is bigger than the string, clamp it
  sub r13, r14
  jns main_start_index_fixed
  ; if the index was too big, then r13 is now negative of # of places the index(r14) was too big
  add r14, r13
  ; the length to print is now zero
  xor r13, r13

main_start_index_fixed:
  ; move up the main string
  add r12, r14
  ; now, r14 is the # of places moved up & r13 is the new length

  ; adjust the end index
  sub r15, r14
  ; NOTE: r15 should never become negative here, because it was already swapped above

  ; clamp the end index as well
  sub r13, r15
  jns main_end_index_fixed
  ; if the end is too big, then r13 is now a negative # of places the end(r15) was too big
  add r15, r13

main_end_index_fixed:
  ; finally, print the result (trades out the null terminator for a newline)
  mov cl, 10
  mov [r12+r15], cl

  mov rax, sys_write
  mov rdi, sys_stdout
  mov rsi, r12
  mov rdx, r15
  inc rdx
  syscall

  xor rdi, rdi
  mov rax, sys_exit
  syscall

arg_count_fail:
  mov rax, sys_write
  mov rdi, sys_stderr
  mov rsi, usage_msg
  mov rdx, usage_msg_len
  syscall

  mov rax, sys_exit
  mov rdi, 1
  syscall

; basic sse4.2 strlen
strlen:
  pxor xmm0, xmm0
  xor rcx, rcx
  mov rax, -16

strlen_loop:
  add rax, 16
  ; compare the 0'd xmm0 to the string, then ecx will end up with the offset of the first zero
  pcmpistri xmm0, [rdi+rax], 0001000b
  jnz strlen_loop

  add rax, rcx
  ret

; basic string to int conversion w/ error checks
atoi:
  xor rax, rax
  mov r11, 10

  movzx rcx, byte [rdi]
  test cl, cl
  jz atoi_bad_number

atoi_loop:
  ; make sure it's in range
  sub cl, '0'
  js atoi_bad_number
  cmp cl, 9
  jg atoi_bad_number

  ; multiply rax(the result) to add a new place value, then add the current #
  ; NOTE: this ignores overflow in edx
  imul r11
  add rax, rcx

  inc rdi
  mov cl, [rdi]
  test cl, cl
  jnz atoi_loop

atoi_end:
  ret

atoi_bad_number:
  mov rax, sys_write
  mov rdi, sys_stderr
  mov rsi, bad_number
  mov rdx, bad_number_len
  syscall

  mov rax, sys_exit
  mov rdi, 1
  syscall
