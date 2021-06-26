;***********************************************************
;**                                                       **
;**  a86汇编语言，与TASM/NASM都有些不同                   **
;**  该代码从30年前的教材附录中MINIX v1.0清单抄摘         **
;**  凌应标 输入并加注解        2016/3/21                 **
;**  仅教学中解释原理时供参考阅读                         **
;**  不完整，使用者可改为TASM语法或者NASM语法，自行完善   **
;***********************************************************


;MINIX的PCB共76字节
;
;+--------------+       -----+
;|   ax         |  +0        |
;+--------------+            |
;|   bx         |  +2        |
;+--------------+             |
;|   cx         |  +4          |
;+--------------+               |
;|   dx         |  +6            |
;+--------------+                 |
;|   si         |  +8             |
;+--------------+                 |
;|   di         |  +10       p_regs[NR_REGS]
;+--------------+                 |
;|   bp         |  +12            |  <<<<<------  ROFF=12
;+--------------+                 |
;|   es         |  +14           |
;+--------------+               |
;|   ds         |  +16         |
;+--------------+             |   <<<<<------  OFF=18
;|   cs         |  +18       |  
;+--------------+            |
;|   ss         |  +20       |
;+--------------+      ------+       |
;|   sp         |  +22       
;+--------------+      ------+
;|   pc(IP)     |  +24        |
;+--------------+              |
;|   cs         |  +26        p_PSW
;+--------------+              |
;|   psw(FLAGS) |  +28        |
;+--------------+      ------+
;|   p_flags    |  +30       
;+--------------+      ------+
;|seg_text 6    |  +32        |
;+--------------+              |
;|seg_data 6    |  +38          |
;+--------------+            p_regs[NR_SEGS]
;|seg_stack6    |  +44        |
;+--------------+      ------+      
;|*p_slimit     |  +50        
;+--------------+             
;| p_pid        |  +52       
;+--------------+             
;| user_time    |  +54       
;+--------------+            
;| sys_time     |  +56       
;+--------------+            
;| child_utime  |  +58       
;+--------------+            
;| child_stime  |  +60       
;+--------------+            
;| p_alarm      |  +62       
;+--------------+            
;| *p_callerq   |  +64       
;+--------------+            
;| *p_sendlink  |  +66       
;+--------------+            
;| *p_messbuf   |  +68       
;+--------------+            
;| p_getfrom    |  +70       
;+--------------+            
;| child_stime  |  +72       
;+--------------+            
;| *p_nestready |  +74       
;+--------------+           
;| p_pending    |  +76       
;+--------------+     







.text
begtext:
;**************************
;*    MINIX               * 
;**************************
MINIX:                   
jmp M.0
.word 0,0                  | 由生成内核映像时在此填入内核的数据段地址
M.0: cli                   | 关中断
mov ax,cs                  |
mov ds,ax                  |
mov ax,4                   | 在ds:[4]一个字保留了内核的数据段地址
mov ds,ax                  | 
mov ss,ax                  |
mov scan_code,bx           | bx是引导程序传来的菜单选择
mov sp,#_k_stack           | k_stack[]是c模块中定义的栈区
add sp,#K_STACK_BYTES      | 栈大小256字节

call main                  | 调用C模块的主程序
M.1:jmp M.1                | 

;**************************
;*    s_call              * 
;**************************
_s_call:
call save
mov bp,_proc_ptr
push 2(bp)
push (bp)
push cur_proc
push 4(bp)
call sys_call
jmp restart



;***************************
;*    tty_int              * 
;***************************
_tty_int:
call save
call keyboard
jmp restart


;***************************
;*    lpr_int              * 
;***************************
_lpr_int:
call save
call pr_char
jmp restart


;***************************
;*    disk_int             * 
;***************************
_disk_int:
call save
mov int_mess+2,*DISKINT
mov ax,#_int_mess
push ax
mov ax,*FLOPPY
push ax
call interrupt
jmp restart

;***************************
;*    wini_int             * 
;***************************
_wini_int:
call save
mov int_mess+2,*DISKINT
mov ax,#_int_mess
push ax
mov ax,*WINI
push ax
call interrupt
jmp restart

;***************************
;*    clock_int            * 
;***************************
_clock_int:
call save
mov int_mess+2,*DISKINT
mov ax,#_int_mess
push ax
mov ax,*CLOCK
push ax
call interrupt
jmp restart


;***************************
;*    surprise             * 
;***************************
_lpr_int:
call save
call unexpected_int
jmp restart


;***************************
;*    trp_int              * 
;***************************
_lpr_int:
call save
call trap
jmp restart


;***************************
;*    dividebyzero         * 
;***************************
_divide:
call save
call divide
jmp restart



;***************************
;*    save                 * 
;***************************
save:                      | 当前进程被中断后来到内核save时，CPU的多数寄存器内容和所用的栈都还是当前用户进程的，真不好办！  
                           | 当前进程的栈顶内容：*\FL\CS\IP\RE,其中RE是调用save的返回地址
push ds                    | 保护当前进程的ds,栈顶：*\FL\CS\IP\ret_address\ds
push cs                    | 通过栈让ds指向内核代码段
pop ds                     |  
mov ds,4                   | 取在ds:[4]一个字保留的内核数据段地址
pop ds_save                | 从当前进程的栈中获得其ds，临时保存在内核特定地方,栈顶：*\FL\CS\IP\RE
pop ret_save               | 从当前进程的栈中获得返回地址RE，临时保存在内核特定地方，栈顶：*\FL\CS\IP
mov bx_save,bx             | 准备使用bx寄存器间接寻址，先将其内容临时保存在内核特定地方
mov bx,_proc_ptr           | 让bx指向当前进程的PCB块首址
add bx,*OFF                | 让bx指向当前进程的PCB块的偏移OFF位置，见上图PCB结构
pop PC-OFF(bx)             | 从当前进程的栈中获得断点的IP，保存到PCB内的特定地方，栈顶：*\FL\CS
pop csreg-OFF(bx)          | 从当前进程的栈中获得断点的CS，保存到PCB内的特定地方，栈顶：*\FL
pop PSW-OFF(bx)            | 从当前进程的栈中获得断点的FL标志寄存器，保存到PCB内的特定地方，栈恢复到中断前的状态
mov ssre-OFF(bx),ss        | 将当前进程的ss保存到PCB内的特定地方
mov SP-OFF(bx),sp          | 将当前进程的sp保存到PCB内的特定地方
mov sp,bx                  | 将sp指向bx，即指向当前进程的PCB块的偏移OFF位置，见上图PCB结构
mov bx,ds                  | 准备用压栈方式保存通用寄存器 
mov ss,bx                  | 将ss指向内核ds，因为PCB在内核数据段中
push ds_save               | 当前进程的ds保存到PCB内的特定地方
push es                    | 当前进程的es保存到PCB内的特定地方
mov es,bx                  | 
push bp                    | 当前进程的bp保存到PCB内的特定地方
push di                    | 当前进程的di保存到PCB内的特定地方
push si                    | 当前进程的si保存到PCB内的特定地方
push dx                    | 当前进程的dx保存到PCB内的特定地方
push cx                    | 当前进程的cx保存到PCB内的特定地方
push bx_save               | 当前进程的bx保存到PCB内的特定地方
push ax                    | 当前进程的ax保存到PCB内的特定地方，至此当前进程的全部通用寄存器内容保存完毕
mov sp,#_k_stck            | 下面4条指令要让内核栈起作用
add sp,#K_STACK_BYTES      |
mov slimit,#_k_stack       |
add slimit,#8              |
mov ax,ret_save            | 用ax间接跳回调用save的位置
jmp(ax)                    |

;***************************
;*    restart              * 
;***************************
restart:                   | 
cmp cur_proc,#IDLE         | 如果当前被中断的进程是内核空转占位进程，直接跳回去
je idle                    |
cli                        | 关中断，准备恢复下一进程运行
mov sp,_proc_ptr           | 用出栈方式从PCB中恢复一些通用寄存器内容
pop ax                     | 恢复ax
pop bx                     | 恢复bx
pop cx                     | 恢复cx
pop dx                     | 恢复dx
pop si                     | 恢复si
pop di                     | 恢复di
mov lds_low,bx             | 要借用bx间接寻址，临时保存到lds_low位置
mov bx,sp                  | bx指向PCB中bp值保存位置
mov bp,SPLIM_ROFF(bx)      | 取栈限送slimit处
mov slimit,bp              |
mov bp,dsreg_ROFF(bx)      | 取PCB中的ds
mov lds_low+2,bp           | 将取到的ds临时保存到lds_low+2位置
pop bp                     | 恢复bp
pop es                     | 恢复es
mov sp,SP_ROFF(bx)         | 恢复sp
mov ss,ssreg_ROFF(bx)      | 恢复ss
push PSW_ROFF(bx)          | 准备返回用户进程的断点，将标志寄存器内容压栈
push csreg_ROFF(bx)        | 将断点的cs寄存器内容压栈
push PC_ROFF(bx)           | 将断点的IP寄存器内容压栈
lds bx,lds_low             | 恢复ds和bx
iret                       | 从栈顶弹出3个字，分别送IP、CS和FL寄存器，CPU离开内核，返回到进程断点的下一指令

;***************************
;*    idle                 * 
;***************************
idle:                      |
sti                        |
L3:wait                    |
jmp L3                     | 



;***************************
;*    data                 * 
;***************************
.data
begdata:
_sizes: word 0x526F        | 幻数，识别内核真假 
.zerow 7                   | 预留
bx_save: .word 0           | 保存bx
ds_save: .word 0           | 保存ds
ret_save: .word 0          | 保存返回地址
lds_low: .word 0,0         | 用于恢复bx和ds

.bss
begbss:


