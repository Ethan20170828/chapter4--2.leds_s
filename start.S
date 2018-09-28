/*
 *	文件名：start.S
 *	作者：EthanSong
 *	描述：汇编编写延时函数
 */

#define GPJ0CON	0xE0200240
#define GPJ0DAT	0xE0200244


// 把_start链接属性改为外部，这样其他文件就可以看见_start了
.global _start
_start:
	// 第一步：把所有引脚都设置为输出模式，代码不变
	// 从后面的=可以看出用的是ldr伪指令，因为需要编译器来判断这个数是合法立即数还是非法立即数。一般写代码都用ldr伪指令
	ldr r0, =0x11111111
	ldr r1, =GPJ0CON
	// 寄存器间接寻址。功能是把r0中的数写入到r1中的数为地址的内存中去
	str r0, [r1]

flash:
	// 第二步：全部点亮
	ldr r0, =((0<<5) | (0<<4) | (0<<3))
	ldr r1, =GPJ0DAT
	// 把0写入到GPJ0DAT寄存器中，引脚即输出低电平，LED点亮
	str r0, [r1]
	
	// 第三步：延时
	// 使用bl进行函数调用
	bl delay
	
	// 第四步：全部熄灭
	ldr r0, =((1<<5) | (1<<4) | (1<<3))
	ldr r1, =GPJ0DAT
	// 把1写入到GPJ0DAT寄存器中，引脚即输出高电平，LED熄灭
	str r0, [r1]
	
	// 第五步：延时
	// 使用bl进行函数调用
	bl delay

	b flash


// 延时函数：函数名delay
delay:
	ldr r2, =9000000	// 相当于C语言中的for循环的初始条件
	ldr r3, =0x0
delay_loop:
	// sub相当于C语言中的i--
	sub r2, r2, #1		// 等价于C语言中：r2 = r2 - 1
	// cmp相当于C语言中的终止条件
	cmp r2, r3			// cmp会影响cpsr中的Z标志位，如果r2等于r3，则Z=1，下一句中eq就会成立，就会跳出循环
	bne delay_loop
	mov pc, lr			// 函数调用返回






