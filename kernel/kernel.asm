
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	86010113          	addi	sp,sp,-1952 # 80007860 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc97>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e2a78793          	addi	a5,a5,-470 # 80000eae <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	7119                	addi	sp,sp,-128
    800000d6:	fc86                	sd	ra,120(sp)
    800000d8:	f8a2                	sd	s0,112(sp)
    800000da:	f4a6                	sd	s1,104(sp)
    800000dc:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800000de:	06c05b63          	blez	a2,80000154 <consolewrite+0x80>
    800000e2:	f0ca                	sd	s2,96(sp)
    800000e4:	ecce                	sd	s3,88(sp)
    800000e6:	e8d2                	sd	s4,80(sp)
    800000e8:	e4d6                	sd	s5,72(sp)
    800000ea:	e0da                	sd	s6,64(sp)
    800000ec:	fc5e                	sd	s7,56(sp)
    800000ee:	f862                	sd	s8,48(sp)
    800000f0:	f466                	sd	s9,40(sp)
    800000f2:	f06a                	sd	s10,32(sp)
    800000f4:	8b2a                	mv	s6,a0
    800000f6:	8bae                	mv	s7,a1
    800000f8:	8a32                	mv	s4,a2
  int i = 0;
    800000fa:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000fc:	02000c93          	li	s9,32
    80000100:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000104:	f8040a93          	addi	s5,s0,-128
    80000108:	5c7d                	li	s8,-1
    8000010a:	a025                	j	80000132 <consolewrite+0x5e>
    if(nn > n - i)
    8000010c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000110:	86ce                	mv	a3,s3
    80000112:	01748633          	add	a2,s1,s7
    80000116:	85da                	mv	a1,s6
    80000118:	8556                	mv	a0,s5
    8000011a:	1b6020ef          	jal	800022d0 <either_copyin>
    8000011e:	03850d63          	beq	a0,s8,80000158 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000122:	85ce                	mv	a1,s3
    80000124:	8556                	mv	a0,s5
    80000126:	7b4000ef          	jal	800008da <uartwrite>
    i += nn;
    8000012a:	009904bb          	addw	s1,s2,s1
  while(i < n){
    8000012e:	0144d963          	bge	s1,s4,80000140 <consolewrite+0x6c>
    if(nn > n - i)
    80000132:	409a07bb          	subw	a5,s4,s1
    80000136:	893e                	mv	s2,a5
    80000138:	fcfcdae3          	bge	s9,a5,8000010c <consolewrite+0x38>
    8000013c:	896a                	mv	s2,s10
    8000013e:	b7f9                	j	8000010c <consolewrite+0x38>
    80000140:	7906                	ld	s2,96(sp)
    80000142:	69e6                	ld	s3,88(sp)
    80000144:	6a46                	ld	s4,80(sp)
    80000146:	6aa6                	ld	s5,72(sp)
    80000148:	6b06                	ld	s6,64(sp)
    8000014a:	7be2                	ld	s7,56(sp)
    8000014c:	7c42                	ld	s8,48(sp)
    8000014e:	7ca2                	ld	s9,40(sp)
    80000150:	7d02                	ld	s10,32(sp)
    80000152:	a821                	j	8000016a <consolewrite+0x96>
  int i = 0;
    80000154:	4481                	li	s1,0
    80000156:	a811                	j	8000016a <consolewrite+0x96>
    80000158:	7906                	ld	s2,96(sp)
    8000015a:	69e6                	ld	s3,88(sp)
    8000015c:	6a46                	ld	s4,80(sp)
    8000015e:	6aa6                	ld	s5,72(sp)
    80000160:	6b06                	ld	s6,64(sp)
    80000162:	7be2                	ld	s7,56(sp)
    80000164:	7c42                	ld	s8,48(sp)
    80000166:	7ca2                	ld	s9,40(sp)
    80000168:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016a:	8526                	mv	a0,s1
    8000016c:	70e6                	ld	ra,120(sp)
    8000016e:	7446                	ld	s0,112(sp)
    80000170:	74a6                	ld	s1,104(sp)
    80000172:	6109                	addi	sp,sp,128
    80000174:	8082                	ret

0000000080000176 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	addi	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f05a                	sd	s6,32(sp)
    80000186:	ec5e                	sd	s7,24(sp)
    80000188:	1080                	addi	s0,sp,96
    8000018a:	8b2a                	mv	s6,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000192:	0000f517          	auipc	a0,0xf
    80000196:	6ce50513          	addi	a0,a0,1742 # 8000f860 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	0000f497          	auipc	s1,0xf
    800001a2:	6c248493          	addi	s1,s1,1730 # 8000f860 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	0000f917          	auipc	s2,0xf
    800001aa:	75290913          	addi	s2,s2,1874 # 8000f8f8 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	770010ef          	jal	8000192e <myproc>
    800001c2:	7a7010ef          	jal	80002168 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	561010ef          	jal	80001f2c <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	0000f717          	auipc	a4,0xf
    800001e2:	68270713          	addi	a4,a4,1666 # 8000f860 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	04da8663          	beq	s5,a3,8000024a <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	855a                	mv	a0,s6
    80000210:	076020ef          	jal	80002286 <either_copyout>
    80000214:	57fd                	li	a5,-1
    80000216:	04f50663          	beq	a0,a5,80000262 <consoleread+0xec>
      break;

    dst++;
    8000021a:	0a05                	addi	s4,s4,1
    --n;
    8000021c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000021e:	47a9                	li	a5,10
    80000220:	04fa8b63          	beq	s5,a5,80000276 <consoleread+0x100>
    80000224:	7aa2                	ld	s5,40(sp)
    80000226:	b761                	j	800001ae <consoleread+0x38>
        release(&cons.lock);
    80000228:	0000f517          	auipc	a0,0xf
    8000022c:	63850513          	addi	a0,a0,1592 # 8000f860 <cons>
    80000230:	28d000ef          	jal	80000cbc <release>
        return -1;
    80000234:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000236:	60e6                	ld	ra,88(sp)
    80000238:	6446                	ld	s0,80(sp)
    8000023a:	64a6                	ld	s1,72(sp)
    8000023c:	6906                	ld	s2,64(sp)
    8000023e:	79e2                	ld	s3,56(sp)
    80000240:	7a42                	ld	s4,48(sp)
    80000242:	7b02                	ld	s6,32(sp)
    80000244:	6be2                	ld	s7,24(sp)
    80000246:	6125                	addi	sp,sp,96
    80000248:	8082                	ret
      if(n < target){
    8000024a:	0179fa63          	bgeu	s3,s7,8000025e <consoleread+0xe8>
        cons.r--;
    8000024e:	0000f717          	auipc	a4,0xf
    80000252:	6af72523          	sw	a5,1706(a4) # 8000f8f8 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	0000f517          	auipc	a0,0xf
    80000268:	5fc50513          	addi	a0,a0,1532 # 8000f860 <cons>
    8000026c:	251000ef          	jal	80000cbc <release>
  return target - n;
    80000270:	413b853b          	subw	a0,s7,s3
    80000274:	b7c9                	j	80000236 <consoleread+0xc0>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	b7f5                	j	80000264 <consoleread+0xee>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50863          	beq	a0,a5,80000296 <consputc+0x1c>
    uartputc_sync(c);
    8000028a:	6e4000ef          	jal	8000096e <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	6d6000ef          	jal	8000096e <uartputc_sync>
    8000029c:	02000513          	li	a0,32
    800002a0:	6ce000ef          	jal	8000096e <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	6c8000ef          	jal	8000096e <uartputc_sync>
    800002aa:	b7d5                	j	8000028e <consputc+0x14>

00000000800002ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ac:	1101                	addi	sp,sp,-32
    800002ae:	ec06                	sd	ra,24(sp)
    800002b0:	e822                	sd	s0,16(sp)
    800002b2:	e426                	sd	s1,8(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	0000f517          	auipc	a0,0xf
    800002bc:	5a850513          	addi	a0,a0,1448 # 8000f860 <cons>
    800002c0:	169000ef          	jal	80000c28 <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	08f48d63          	beq	s1,a5,80000360 <consoleintr+0xb4>
    800002ca:	0297c563          	blt	a5,s1,800002f4 <consoleintr+0x48>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48263          	beq	s1,a5,800003b4 <consoleintr+0x108>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49363          	bne	s1,a5,800003dc <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800002da:	040020ef          	jal	8000231a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	0000f517          	auipc	a0,0xf
    800002e2:	58250513          	addi	a0,a0,1410 # 8000f860 <cons>
    800002e6:	1d7000ef          	jal	80000cbc <release>
}
    800002ea:	60e2                	ld	ra,24(sp)
    800002ec:	6442                	ld	s0,16(sp)
    800002ee:	64a2                	ld	s1,8(sp)
    800002f0:	6105                	addi	sp,sp,32
    800002f2:	8082                	ret
  switch(c){
    800002f4:	07f00793          	li	a5,127
    800002f8:	0af48e63          	beq	s1,a5,800003b4 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fc:	0000f717          	auipc	a4,0xf
    80000300:	56470713          	addi	a4,a4,1380 # 8000f860 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09872703          	lw	a4,152(a4)
    8000030c:	9f99                	subw	a5,a5,a4
    8000030e:	07f00713          	li	a4,127
    80000312:	fcf766e3          	bltu	a4,a5,800002de <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000316:	47b5                	li	a5,13
    80000318:	0cf48563          	beq	s1,a5,800003e2 <consoleintr+0x136>
      consputc(c);
    8000031c:	8526                	mv	a0,s1
    8000031e:	f5dff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000322:	0000f717          	auipc	a4,0xf
    80000326:	53e70713          	addi	a4,a4,1342 # 8000f860 <cons>
    8000032a:	0a072683          	lw	a3,160(a4)
    8000032e:	0016879b          	addiw	a5,a3,1
    80000332:	863e                	mv	a2,a5
    80000334:	0af72023          	sw	a5,160(a4)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	9736                	add	a4,a4,a3
    8000033e:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	ff648713          	addi	a4,s1,-10
    80000346:	c371                	beqz	a4,8000040a <consoleintr+0x15e>
    80000348:	14f1                	addi	s1,s1,-4
    8000034a:	c0e1                	beqz	s1,8000040a <consoleintr+0x15e>
    8000034c:	0000f717          	auipc	a4,0xf
    80000350:	5ac72703          	lw	a4,1452(a4) # 8000f8f8 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	0000f717          	auipc	a4,0xf
    80000366:	4fe70713          	addi	a4,a4,1278 # 8000f860 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	0000f497          	auipc	s1,0xf
    80000376:	4ee48493          	addi	s1,s1,1262 # 8000f860 <cons>
    while(cons.e != cons.w &&
    8000037a:	4929                	li	s2,10
    8000037c:	02f70863          	beq	a4,a5,800003ac <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000380:	37fd                	addiw	a5,a5,-1
    80000382:	07f7f713          	andi	a4,a5,127
    80000386:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000388:	01874703          	lbu	a4,24(a4)
    8000038c:	03270263          	beq	a4,s2,800003b0 <consoleintr+0x104>
      cons.e--;
    80000390:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000394:	10000513          	li	a0,256
    80000398:	ee3ff0ef          	jal	8000027a <consputc>
    while(cons.e != cons.w &&
    8000039c:	0a04a783          	lw	a5,160(s1)
    800003a0:	09c4a703          	lw	a4,156(s1)
    800003a4:	fcf71ee3          	bne	a4,a5,80000380 <consoleintr+0xd4>
    800003a8:	6902                	ld	s2,0(sp)
    800003aa:	bf15                	j	800002de <consoleintr+0x32>
    800003ac:	6902                	ld	s2,0(sp)
    800003ae:	bf05                	j	800002de <consoleintr+0x32>
    800003b0:	6902                	ld	s2,0(sp)
    800003b2:	b735                	j	800002de <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b4:	0000f717          	auipc	a4,0xf
    800003b8:	4ac70713          	addi	a4,a4,1196 # 8000f860 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	0000f717          	auipc	a4,0xf
    800003ce:	52f72b23          	sw	a5,1334(a4) # 8000f900 <cons+0xa0>
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	ea5ff0ef          	jal	8000027a <consputc>
    800003da:	b711                	j	800002de <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003dc:	f00481e3          	beqz	s1,800002de <consoleintr+0x32>
    800003e0:	bf31                	j	800002fc <consoleintr+0x50>
      consputc(c);
    800003e2:	4529                	li	a0,10
    800003e4:	e97ff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003e8:	0000f797          	auipc	a5,0xf
    800003ec:	47878793          	addi	a5,a5,1144 # 8000f860 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	0000f797          	auipc	a5,0xf
    8000040e:	4ec7a923          	sw	a2,1266(a5) # 8000f8fc <cons+0x9c>
        wakeup(&cons.r);
    80000412:	0000f517          	auipc	a0,0xf
    80000416:	4e650513          	addi	a0,a0,1254 # 8000f8f8 <cons+0x98>
    8000041a:	35f010ef          	jal	80001f78 <wakeup>
    8000041e:	b5c1                	j	800002de <consoleintr+0x32>

0000000080000420 <consoleinit>:

void
consoleinit(void)
{
    80000420:	1141                	addi	sp,sp,-16
    80000422:	e406                	sd	ra,8(sp)
    80000424:	e022                	sd	s0,0(sp)
    80000426:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000428:	00007597          	auipc	a1,0x7
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80007000 <etext>
    80000430:	0000f517          	auipc	a0,0xf
    80000434:	43050513          	addi	a0,a0,1072 # 8000f860 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	0001f797          	auipc	a5,0x1f
    80000444:	59078793          	addi	a5,a5,1424 # 8001f9d0 <devsw>
    80000448:	00000717          	auipc	a4,0x0
    8000044c:	d2e70713          	addi	a4,a4,-722 # 80000176 <consoleread>
    80000450:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000452:	00000717          	auipc	a4,0x0
    80000456:	c8270713          	addi	a4,a4,-894 # 800000d4 <consolewrite>
    8000045a:	ef98                	sd	a4,24(a5)
}
    8000045c:	60a2                	ld	ra,8(sp)
    8000045e:	6402                	ld	s0,0(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f04a                	sd	s2,32(sp)
    8000046c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000046e:	c219                	beqz	a2,80000474 <printint+0x10>
    80000470:	08054163          	bltz	a0,800004f2 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000474:	4301                	li	t1,0

  i = 0;
    80000476:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000047a:	86ca                	mv	a3,s2
  i = 0;
    8000047c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00007817          	auipc	a6,0x7
    80000482:	29280813          	addi	a6,a6,658 # 80007710 <digits>
    80000486:	88ba                	mv	a7,a4
    80000488:	0017061b          	addiw	a2,a4,1
    8000048c:	8732                	mv	a4,a2
    8000048e:	02b577b3          	remu	a5,a0,a1
    80000492:	97c2                	add	a5,a5,a6
    80000494:	0007c783          	lbu	a5,0(a5)
    80000498:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000049c:	87aa                	mv	a5,a0
    8000049e:	02b55533          	divu	a0,a0,a1
    800004a2:	0685                	addi	a3,a3,1
    800004a4:	feb7f1e3          	bgeu	a5,a1,80000486 <printint+0x22>

  if(sign)
    800004a8:	00030c63          	beqz	t1,800004c0 <printint+0x5c>
    buf[i++] = '-';
    800004ac:	fe060793          	addi	a5,a2,-32
    800004b0:	00878633          	add	a2,a5,s0
    800004b4:	02d00793          	li	a5,45
    800004b8:	fef60423          	sb	a5,-24(a2)
    800004bc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800004c0:	02e05463          	blez	a4,800004e8 <printint+0x84>
    800004c4:	f426                	sd	s1,40(sp)
    800004c6:	377d                	addiw	a4,a4,-1
    800004c8:	00e904b3          	add	s1,s2,a4
    800004cc:	197d                	addi	s2,s2,-1
    800004ce:	993a                	add	s2,s2,a4
    800004d0:	1702                	slli	a4,a4,0x20
    800004d2:	9301                	srli	a4,a4,0x20
    800004d4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004d8:	0004c503          	lbu	a0,0(s1)
    800004dc:	d9fff0ef          	jal	8000027a <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x74>
    800004e6:	74a2                	ld	s1,40(sp)
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4305                	li	t1,1
    x = -xx;
    800004f8:	bfbd                	j	80000476 <printint+0x12>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	f0ca                	sd	s2,96(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	892a                	mv	s2,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	00007797          	auipc	a5,0x7
    8000051c:	31c7a783          	lw	a5,796(a5) # 80007834 <panicking>
    80000520:	cf9d                	beqz	a5,8000055e <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	00094503          	lbu	a0,0(s2)
    8000052e:	22050663          	beqz	a0,8000075a <printf+0x260>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	ecce                	sd	s3,88(sp)
    80000536:	e8d2                	sd	s4,80(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	fc5e                	sd	s7,56(sp)
    8000053e:	f862                	sd	s8,48(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4a01                	li	s4,0
    if(cx != '%'){
    80000546:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000054a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000054e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000552:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000556:	4b29                	li	s6,10
    if(c0 == 'd'){
    80000558:	06400b93          	li	s7,100
    8000055c:	a015                	j	80000580 <printf+0x86>
    acquire(&pr.lock);
    8000055e:	0000f517          	auipc	a0,0xf
    80000562:	3aa50513          	addi	a0,a0,938 # 8000f908 <pr>
    80000566:	6c2000ef          	jal	80000c28 <acquire>
    8000056a:	bf65                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056c:	d0fff0ef          	jal	8000027a <consputc>
      continue;
    80000570:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000572:	2485                	addiw	s1,s1,1
    80000574:	8a26                	mv	s4,s1
    80000576:	94ca                	add	s1,s1,s2
    80000578:	0004c503          	lbu	a0,0(s1)
    8000057c:	1c050663          	beqz	a0,80000748 <printf+0x24e>
    if(cx != '%'){
    80000580:	ff3516e3          	bne	a0,s3,8000056c <printf+0x72>
    i++;
    80000584:	001a079b          	addiw	a5,s4,1
    80000588:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000058a:	00f90733          	add	a4,s2,a5
    8000058e:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000592:	200a8963          	beqz	s5,800007a4 <printf+0x2aa>
    80000596:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059a:	1e068c63          	beqz	a3,80000792 <printf+0x298>
    if(c0 == 'd'){
    8000059e:	037a8863          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800005a2:	f94a8713          	addi	a4,s5,-108
    800005a6:	00173713          	seqz	a4,a4
    800005aa:	f9c68613          	addi	a2,a3,-100
    800005ae:	ee05                	bnez	a2,800005e6 <printf+0xec>
    800005b0:	cb1d                	beqz	a4,800005e6 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	addi	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4605                	li	a2,1
    800005c0:	85da                	mv	a1,s6
    800005c2:	6388                	ld	a0,0(a5)
    800005c4:	ea1ff0ef          	jal	80000464 <printint>
      i += 1;
    800005c8:	002a049b          	addiw	s1,s4,2
    800005cc:	b75d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	addi	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4605                	li	a2,1
    800005dc:	85da                	mv	a1,s6
    800005de:	4388                	lw	a0,0(a5)
    800005e0:	e85ff0ef          	jal	80000464 <printint>
    800005e4:	b779                	j	80000572 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800005e6:	97ca                	add	a5,a5,s2
    800005e8:	8636                	mv	a2,a3
    800005ea:	0027c683          	lbu	a3,2(a5)
    800005ee:	a2c9                	j	800007b0 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800005f0:	f8843783          	ld	a5,-120(s0)
    800005f4:	00878713          	addi	a4,a5,8
    800005f8:	f8e43423          	sd	a4,-120(s0)
    800005fc:	4605                	li	a2,1
    800005fe:	45a9                	li	a1,10
    80000600:	6388                	ld	a0,0(a5)
    80000602:	e63ff0ef          	jal	80000464 <printint>
      i += 2;
    80000606:	003a049b          	addiw	s1,s4,3
    8000060a:	b7a5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000060c:	f8843783          	ld	a5,-120(s0)
    80000610:	00878713          	addi	a4,a5,8
    80000614:	f8e43423          	sd	a4,-120(s0)
    80000618:	4601                	li	a2,0
    8000061a:	85da                	mv	a1,s6
    8000061c:	0007e503          	lwu	a0,0(a5)
    80000620:	e45ff0ef          	jal	80000464 <printint>
    80000624:	b7b9                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000626:	f8843783          	ld	a5,-120(s0)
    8000062a:	00878713          	addi	a4,a5,8
    8000062e:	f8e43423          	sd	a4,-120(s0)
    80000632:	4601                	li	a2,0
    80000634:	85da                	mv	a1,s6
    80000636:	6388                	ld	a0,0(a5)
    80000638:	e2dff0ef          	jal	80000464 <printint>
      i += 1;
    8000063c:	002a049b          	addiw	s1,s4,2
    80000640:	bf0d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	addi	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4601                	li	a2,0
    80000650:	45a9                	li	a1,10
    80000652:	6388                	ld	a0,0(a5)
    80000654:	e11ff0ef          	jal	80000464 <printint>
      i += 2;
    80000658:	003a049b          	addiw	s1,s4,3
    8000065c:	bf19                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4601                	li	a2,0
    8000066c:	45c1                	li	a1,16
    8000066e:	0007e503          	lwu	a0,0(a5)
    80000672:	df3ff0ef          	jal	80000464 <printint>
    80000676:	bdf5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	45c1                	li	a1,16
    80000686:	6388                	ld	a0,0(a5)
    80000688:	dddff0ef          	jal	80000464 <printint>
      i += 1;
    8000068c:	002a049b          	addiw	s1,s4,2
    80000690:	b5cd                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4601                	li	a2,0
    800006a0:	45c1                	li	a1,16
    800006a2:	6388                	ld	a0,0(a5)
    800006a4:	dc1ff0ef          	jal	80000464 <printint>
      i += 2;
    800006a8:	003a049b          	addiw	s1,s4,3
    800006ac:	b5d9                	j	80000572 <printf+0x78>
    800006ae:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006c0:	03000513          	li	a0,48
    800006c4:	bb7ff0ef          	jal	8000027a <consputc>
  consputc('x');
    800006c8:	07800513          	li	a0,120
    800006cc:	bafff0ef          	jal	8000027a <consputc>
    800006d0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	00007c97          	auipc	s9,0x7
    800006d6:	03ec8c93          	addi	s9,s9,62 # 80007710 <digits>
    800006da:	03cad793          	srli	a5,s5,0x3c
    800006de:	97e6                	add	a5,a5,s9
    800006e0:	0007c503          	lbu	a0,0(a5)
    800006e4:	b97ff0ef          	jal	8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e8:	0a92                	slli	s5,s5,0x4
    800006ea:	3a7d                	addiw	s4,s4,-1
    800006ec:	fe0a17e3          	bnez	s4,800006da <printf+0x1e0>
    800006f0:	7ca2                	ld	s9,40(sp)
    800006f2:	b541                	j	80000572 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	addi	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	4388                	lw	a0,0(a5)
    80000702:	b79ff0ef          	jal	8000027a <consputc>
    80000706:	b5b5                	j	80000572 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80000708:	f8843783          	ld	a5,-120(s0)
    8000070c:	00878713          	addi	a4,a5,8
    80000710:	f8e43423          	sd	a4,-120(s0)
    80000714:	0007ba03          	ld	s4,0(a5)
    80000718:	000a0d63          	beqz	s4,80000732 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000071c:	000a4503          	lbu	a0,0(s4)
    80000720:	e40509e3          	beqz	a0,80000572 <printf+0x78>
        consputc(*s);
    80000724:	b57ff0ef          	jal	8000027a <consputc>
      for(; *s; s++)
    80000728:	0a05                	addi	s4,s4,1
    8000072a:	000a4503          	lbu	a0,0(s4)
    8000072e:	f97d                	bnez	a0,80000724 <printf+0x22a>
    80000730:	b589                	j	80000572 <printf+0x78>
        s = "(null)";
    80000732:	00007a17          	auipc	s4,0x7
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80007008 <etext+0x8>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7dd                	j	80000724 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80000740:	8556                	mv	a0,s5
    80000742:	b39ff0ef          	jal	8000027a <consputc>
    80000746:	b535                	j	80000572 <printf+0x78>
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7d02                	ld	s10,32(sp)
    80000758:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000075a:	00007797          	auipc	a5,0x7
    8000075e:	0da7a783          	lw	a5,218(a5) # 80007834 <panicking>
    80000762:	c38d                	beqz	a5,80000784 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80000764:	4501                	li	a0,0
    80000766:	70e6                	ld	ra,120(sp)
    80000768:	7446                	ld	s0,112(sp)
    8000076a:	7906                	ld	s2,96(sp)
    8000076c:	6129                	addi	sp,sp,192
    8000076e:	8082                	ret
    80000770:	74a6                	ld	s1,104(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7d02                	ld	s10,32(sp)
    80000780:	6de2                	ld	s11,24(sp)
    80000782:	bfe1                	j	8000075a <printf+0x260>
    release(&pr.lock);
    80000784:	0000f517          	auipc	a0,0xf
    80000788:	18450513          	addi	a0,a0,388 # 8000f908 <pr>
    8000078c:	530000ef          	jal	80000cbc <release>
  return 0;
    80000790:	bfd1                	j	80000764 <printf+0x26a>
    if(c0 == 'd'){
    80000792:	e37a8ee3          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80000796:	f94a8713          	addi	a4,s5,-108
    8000079a:	00173713          	seqz	a4,a4
    8000079e:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007a0:	4781                	li	a5,0
    800007a2:	a00d                	j	800007c4 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800007a4:	f94a8713          	addi	a4,s5,-108
    800007a8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007ac:	8656                	mv	a2,s5
    800007ae:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007b0:	f9460793          	addi	a5,a2,-108
    800007b4:	0017b793          	seqz	a5,a5
    800007b8:	8ff9                	and	a5,a5,a4
    800007ba:	f9c68593          	addi	a1,a3,-100
    800007be:	e199                	bnez	a1,800007c4 <printf+0x2ca>
    800007c0:	e20798e3          	bnez	a5,800005f0 <printf+0xf6>
    } else if(c0 == 'u'){
    800007c4:	e58a84e3          	beq	s5,s8,8000060c <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800007c8:	f8b60593          	addi	a1,a2,-117
    800007cc:	e199                	bnez	a1,800007d2 <printf+0x2d8>
    800007ce:	e4071ce3          	bnez	a4,80000626 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800007d2:	f8b68593          	addi	a1,a3,-117
    800007d6:	e199                	bnez	a1,800007dc <printf+0x2e2>
    800007d8:	e60795e3          	bnez	a5,80000642 <printf+0x148>
    } else if(c0 == 'x'){
    800007dc:	e9aa81e3          	beq	s5,s10,8000065e <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800007e0:	f8860613          	addi	a2,a2,-120
    800007e4:	e219                	bnez	a2,800007ea <printf+0x2f0>
    800007e6:	e80719e3          	bnez	a4,80000678 <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800007ea:	f8868693          	addi	a3,a3,-120
    800007ee:	e299                	bnez	a3,800007f4 <printf+0x2fa>
    800007f0:	ea0791e3          	bnez	a5,80000692 <printf+0x198>
    } else if(c0 == 'p'){
    800007f4:	ebba8de3          	beq	s5,s11,800006ae <printf+0x1b4>
    } else if(c0 == 'c'){
    800007f8:	06300793          	li	a5,99
    800007fc:	eefa8ce3          	beq	s5,a5,800006f4 <printf+0x1fa>
    } else if(c0 == 's'){
    80000800:	07300793          	li	a5,115
    80000804:	f0fa82e3          	beq	s5,a5,80000708 <printf+0x20e>
    } else if(c0 == '%'){
    80000808:	02500793          	li	a5,37
    8000080c:	f2fa8ae3          	beq	s5,a5,80000740 <printf+0x246>
    } else if(c0 == 0){
    80000810:	f60a80e3          	beqz	s5,80000770 <printf+0x276>
      consputc('%');
    80000814:	02500513          	li	a0,37
    80000818:	a63ff0ef          	jal	8000027a <consputc>
      consputc(c0);
    8000081c:	8556                	mv	a0,s5
    8000081e:	a5dff0ef          	jal	8000027a <consputc>
    80000822:	bb81                	j	80000572 <printf+0x78>

0000000080000824 <panic>:

void
panic(char *s)
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	e04a                	sd	s2,0(sp)
    8000082e:	1000                	addi	s0,sp,32
    80000830:	892a                	mv	s2,a0
  panicking = 1;
    80000832:	4485                	li	s1,1
    80000834:	00007797          	auipc	a5,0x7
    80000838:	0097a023          	sw	s1,0(a5) # 80007834 <panicking>
  printf("panic: ");
    8000083c:	00006517          	auipc	a0,0x6
    80000840:	7dc50513          	addi	a0,a0,2012 # 80007018 <etext+0x18>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00006517          	auipc	a0,0x6
    8000084e:	7d650513          	addi	a0,a0,2006 # 80007020 <etext+0x20>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	00007797          	auipc	a5,0x7
    8000085a:	fc97ad23          	sw	s1,-38(a5) # 80007830 <panicked>
  for(;;)
    8000085e:	a001                	j	8000085e <panic+0x3a>

0000000080000860 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000868:	00006597          	auipc	a1,0x6
    8000086c:	7c058593          	addi	a1,a1,1984 # 80007028 <etext+0x28>
    80000870:	0000f517          	auipc	a0,0xf
    80000874:	09850513          	addi	a0,a0,152 # 8000f908 <pr>
    80000878:	326000ef          	jal	80000b9e <initlock>
}
    8000087c:	60a2                	ld	ra,8(sp)
    8000087e:	6402                	ld	s0,0(sp)
    80000880:	0141                	addi	sp,sp,16
    80000882:	8082                	ret

0000000080000884 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000088c:	100007b7          	lui	a5,0x10000
    80000890:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000894:	10000737          	lui	a4,0x10000
    80000898:	f8000693          	li	a3,-128
    8000089c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008a0:	468d                	li	a3,3
    800008a2:	10000637          	lui	a2,0x10000
    800008a6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008aa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008ae:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008b2:	8732                	mv	a4,a2
    800008b4:	461d                	li	a2,7
    800008b6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ba:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008be:	00006597          	auipc	a1,0x6
    800008c2:	77258593          	addi	a1,a1,1906 # 80007030 <etext+0x30>
    800008c6:	0000f517          	auipc	a0,0xf
    800008ca:	05a50513          	addi	a0,a0,90 # 8000f920 <tx_lock>
    800008ce:	2d0000ef          	jal	80000b9e <initlock>
}
    800008d2:	60a2                	ld	ra,8(sp)
    800008d4:	6402                	ld	s0,0(sp)
    800008d6:	0141                	addi	sp,sp,16
    800008d8:	8082                	ret

00000000800008da <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008da:	715d                	addi	sp,sp,-80
    800008dc:	e486                	sd	ra,72(sp)
    800008de:	e0a2                	sd	s0,64(sp)
    800008e0:	fc26                	sd	s1,56(sp)
    800008e2:	ec56                	sd	s5,24(sp)
    800008e4:	0880                	addi	s0,sp,80
    800008e6:	8aaa                	mv	s5,a0
    800008e8:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008ea:	0000f517          	auipc	a0,0xf
    800008ee:	03650513          	addi	a0,a0,54 # 8000f920 <tx_lock>
    800008f2:	336000ef          	jal	80000c28 <acquire>

  int i = 0;
  while(i < n){ 
    800008f6:	06905063          	blez	s1,80000956 <uartwrite+0x7c>
    800008fa:	f84a                	sd	s2,48(sp)
    800008fc:	f44e                	sd	s3,40(sp)
    800008fe:	f052                	sd	s4,32(sp)
    80000900:	e85a                	sd	s6,16(sp)
    80000902:	e45e                	sd	s7,8(sp)
    80000904:	8a56                	mv	s4,s5
    80000906:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000908:	00007497          	auipc	s1,0x7
    8000090c:	f3448493          	addi	s1,s1,-204 # 8000783c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	0000f997          	auipc	s3,0xf
    80000914:	01098993          	addi	s3,s3,16 # 8000f920 <tx_lock>
    80000918:	00007917          	auipc	s2,0x7
    8000091c:	f2090913          	addi	s2,s2,-224 # 80007838 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80000920:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000924:	4b05                	li	s6,1
    80000926:	a005                	j	80000946 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80000928:	85ce                	mv	a1,s3
    8000092a:	854a                	mv	a0,s2
    8000092c:	600010ef          	jal	80001f2c <sleep>
    while(tx_busy != 0){
    80000930:	409c                	lw	a5,0(s1)
    80000932:	fbfd                	bnez	a5,80000928 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000934:	000a4783          	lbu	a5,0(s4)
    80000938:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000093c:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80000940:	0a05                	addi	s4,s4,1
    80000942:	015a0563          	beq	s4,s5,8000094c <uartwrite+0x72>
    while(tx_busy != 0){
    80000946:	409c                	lw	a5,0(s1)
    80000948:	f3e5                	bnez	a5,80000928 <uartwrite+0x4e>
    8000094a:	b7ed                	j	80000934 <uartwrite+0x5a>
    8000094c:	7942                	ld	s2,48(sp)
    8000094e:	79a2                	ld	s3,40(sp)
    80000950:	7a02                	ld	s4,32(sp)
    80000952:	6b42                	ld	s6,16(sp)
    80000954:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000956:	0000f517          	auipc	a0,0xf
    8000095a:	fca50513          	addi	a0,a0,-54 # 8000f920 <tx_lock>
    8000095e:	35e000ef          	jal	80000cbc <release>
}
    80000962:	60a6                	ld	ra,72(sp)
    80000964:	6406                	ld	s0,64(sp)
    80000966:	74e2                	ld	s1,56(sp)
    80000968:	6ae2                	ld	s5,24(sp)
    8000096a:	6161                	addi	sp,sp,80
    8000096c:	8082                	ret

000000008000096e <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000096e:	1101                	addi	sp,sp,-32
    80000970:	ec06                	sd	ra,24(sp)
    80000972:	e822                	sd	s0,16(sp)
    80000974:	e426                	sd	s1,8(sp)
    80000976:	1000                	addi	s0,sp,32
    80000978:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000097a:	00007797          	auipc	a5,0x7
    8000097e:	eba7a783          	lw	a5,-326(a5) # 80007834 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00007797          	auipc	a5,0x7
    80000988:	eac7a783          	lw	a5,-340(a5) # 80007830 <panicked>
    8000098c:	ef85                	bnez	a5,800009c4 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000098e:	10000737          	lui	a4,0x10000
    80000992:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000994:	00074783          	lbu	a5,0(a4)
    80000998:	0207f793          	andi	a5,a5,32
    8000099c:	dfe5                	beqz	a5,80000994 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000099e:	0ff4f513          	zext.b	a0,s1
    800009a2:	100007b7          	lui	a5,0x10000
    800009a6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800009aa:	00007797          	auipc	a5,0x7
    800009ae:	e8a7a783          	lw	a5,-374(a5) # 80007834 <panicking>
    800009b2:	cb91                	beqz	a5,800009c6 <uartputc_sync+0x58>
    pop_off();
}
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    push_off();
    800009be:	226000ef          	jal	80000be4 <push_off>
    800009c2:	b7c9                	j	80000984 <uartputc_sync+0x16>
    for(;;)
    800009c4:	a001                	j	800009c4 <uartputc_sync+0x56>
    pop_off();
    800009c6:	2a6000ef          	jal	80000c6c <pop_off>
}
    800009ca:	b7ed                	j	800009b4 <uartputc_sync+0x46>

00000000800009cc <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009cc:	1141                	addi	sp,sp,-16
    800009ce:	e406                	sd	ra,8(sp)
    800009d0:	e022                	sd	s0,0(sp)
    800009d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800009d4:	100007b7          	lui	a5,0x10000
    800009d8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009dc:	8b85                	andi	a5,a5,1
    800009de:	cb89                	beqz	a5,800009f0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009e8:	60a2                	ld	ra,8(sp)
    800009ea:	6402                	ld	s0,0(sp)
    800009ec:	0141                	addi	sp,sp,16
    800009ee:	8082                	ret
    return -1;
    800009f0:	557d                	li	a0,-1
    800009f2:	bfdd                	j	800009e8 <uartgetc+0x1c>

00000000800009f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000a06:	0000f517          	auipc	a0,0xf
    80000a0a:	f1a50513          	addi	a0,a0,-230 # 8000f920 <tx_lock>
    80000a0e:	21a000ef          	jal	80000c28 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80000a12:	100007b7          	lui	a5,0x10000
    80000a16:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a1a:	0207f793          	andi	a5,a5,32
    80000a1e:	ef99                	bnez	a5,80000a3c <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a20:	0000f517          	auipc	a0,0xf
    80000a24:	f0050513          	addi	a0,a0,-256 # 8000f920 <tx_lock>
    80000a28:	294000ef          	jal	80000cbc <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a2c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a2e:	f9fff0ef          	jal	800009cc <uartgetc>
    if(c == -1)
    80000a32:	02950063          	beq	a0,s1,80000a52 <uartintr+0x5e>
      break;
    consoleintr(c);
    80000a36:	877ff0ef          	jal	800002ac <consoleintr>
  while(1){
    80000a3a:	bfd5                	j	80000a2e <uartintr+0x3a>
    tx_busy = 0;
    80000a3c:	00007797          	auipc	a5,0x7
    80000a40:	e007a023          	sw	zero,-512(a5) # 8000783c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00007517          	auipc	a0,0x7
    80000a48:	df450513          	addi	a0,a0,-524 # 80007838 <tx_chan>
    80000a4c:	52c010ef          	jal	80001f78 <wakeup>
    80000a50:	bfc1                	j	80000a20 <uartintr+0x2c>
  }
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	e04a                	sd	s2,0(sp)
    80000a66:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a68:	00020797          	auipc	a5,0x20
    80000a6c:	10078793          	addi	a5,a5,256 # 80020b68 <end>
    80000a70:	00f53733          	sltu	a4,a0,a5
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	17fd                	addi	a5,a5,-1
    80000a7a:	00a7b7b3          	sltu	a5,a5,a0
    80000a7e:	8fd9                	or	a5,a5,a4
    80000a80:	ef95                	bnez	a5,80000abc <kfree+0x60>
    80000a82:	84aa                	mv	s1,a0
    80000a84:	03451793          	slli	a5,a0,0x34
    80000a88:	eb95                	bnez	a5,80000abc <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	4585                	li	a1,1
    80000a8e:	26a000ef          	jal	80000cf8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a92:	0000f917          	auipc	s2,0xf
    80000a96:	ea690913          	addi	s2,s2,-346 # 8000f938 <kmem>
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	18c000ef          	jal	80000c28 <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	210000ef          	jal	80000cbc <release>
}
    80000ab0:	60e2                	ld	ra,24(sp)
    80000ab2:	6442                	ld	s0,16(sp)
    80000ab4:	64a2                	ld	s1,8(sp)
    80000ab6:	6902                	ld	s2,0(sp)
    80000ab8:	6105                	addi	sp,sp,32
    80000aba:	8082                	ret
    panic("kfree");
    80000abc:	00006517          	auipc	a0,0x6
    80000ac0:	57c50513          	addi	a0,a0,1404 # 80007038 <etext+0x38>
    80000ac4:	d61ff0ef          	jal	80000824 <panic>

0000000080000ac8 <freerange>:
{
    80000ac8:	7179                	addi	sp,sp,-48
    80000aca:	f406                	sd	ra,40(sp)
    80000acc:	f022                	sd	s0,32(sp)
    80000ace:	ec26                	sd	s1,24(sp)
    80000ad0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	00e504b3          	add	s1,a0,a4
    80000adc:	777d                	lui	a4,0xfffff
    80000ade:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0295e263          	bltu	a1,s1,80000b06 <freerange+0x3e>
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	892e                	mv	s2,a1
    kfree(p);
    80000aee:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	89be                	mv	s3,a5
    kfree(p);
    80000af2:	01448533          	add	a0,s1,s4
    80000af6:	f67ff0ef          	jal	80000a5c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000afa:	94ce                	add	s1,s1,s3
    80000afc:	fe997be3          	bgeu	s2,s1,80000af2 <freerange+0x2a>
    80000b00:	6942                	ld	s2,16(sp)
    80000b02:	69a2                	ld	s3,8(sp)
    80000b04:	6a02                	ld	s4,0(sp)
}
    80000b06:	70a2                	ld	ra,40(sp)
    80000b08:	7402                	ld	s0,32(sp)
    80000b0a:	64e2                	ld	s1,24(sp)
    80000b0c:	6145                	addi	sp,sp,48
    80000b0e:	8082                	ret

0000000080000b10 <kinit>:
{
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b18:	00006597          	auipc	a1,0x6
    80000b1c:	52858593          	addi	a1,a1,1320 # 80007040 <etext+0x40>
    80000b20:	0000f517          	auipc	a0,0xf
    80000b24:	e1850513          	addi	a0,a0,-488 # 8000f938 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00020517          	auipc	a0,0x20
    80000b34:	03850513          	addi	a0,a0,56 # 80020b68 <end>
    80000b38:	f91ff0ef          	jal	80000ac8 <freerange>
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret

0000000080000b44 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b44:	1101                	addi	sp,sp,-32
    80000b46:	ec06                	sd	ra,24(sp)
    80000b48:	e822                	sd	s0,16(sp)
    80000b4a:	e426                	sd	s1,8(sp)
    80000b4c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b4e:	0000f517          	auipc	a0,0xf
    80000b52:	dea50513          	addi	a0,a0,-534 # 8000f938 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	0000f497          	auipc	s1,0xf
    80000b5e:	df64b483          	ld	s1,-522(s1) # 8000f950 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	0000f717          	auipc	a4,0xf
    80000b6a:	def73523          	sd	a5,-534(a4) # 8000f950 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	0000f517          	auipc	a0,0xf
    80000b72:	dca50513          	addi	a0,a0,-566 # 8000f938 <kmem>
    80000b76:	146000ef          	jal	80000cbc <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7a:	6605                	lui	a2,0x1
    80000b7c:	4595                	li	a1,5
    80000b7e:	8526                	mv	a0,s1
    80000b80:	178000ef          	jal	80000cf8 <memset>
  return (void*)r;
}
    80000b84:	8526                	mv	a0,s1
    80000b86:	60e2                	ld	ra,24(sp)
    80000b88:	6442                	ld	s0,16(sp)
    80000b8a:	64a2                	ld	s1,8(sp)
    80000b8c:	6105                	addi	sp,sp,32
    80000b8e:	8082                	ret
  release(&kmem.lock);
    80000b90:	0000f517          	auipc	a0,0xf
    80000b94:	da850513          	addi	a0,a0,-600 # 8000f938 <kmem>
    80000b98:	124000ef          	jal	80000cbc <release>
  if(r)
    80000b9c:	b7e5                	j	80000b84 <kalloc+0x40>

0000000080000b9e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b9e:	1141                	addi	sp,sp,-16
    80000ba0:	e406                	sd	ra,8(sp)
    80000ba2:	e022                	sd	s0,0(sp)
    80000ba4:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ba6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ba8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bac:	00053823          	sd	zero,16(a0)
}
    80000bb0:	60a2                	ld	ra,8(sp)
    80000bb2:	6402                	ld	s0,0(sp)
    80000bb4:	0141                	addi	sp,sp,16
    80000bb6:	8082                	ret

0000000080000bb8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	411c                	lw	a5,0(a0)
    80000bba:	e399                	bnez	a5,80000bc0 <holding+0x8>
    80000bbc:	4501                	li	a0,0
  return r;
}
    80000bbe:	8082                	ret
{
    80000bc0:	1101                	addi	sp,sp,-32
    80000bc2:	ec06                	sd	ra,24(sp)
    80000bc4:	e822                	sd	s0,16(sp)
    80000bc6:	e426                	sd	s1,8(sp)
    80000bc8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bca:	691c                	ld	a5,16(a0)
    80000bcc:	84be                	mv	s1,a5
    80000bce:	541000ef          	jal	8000190e <mycpu>
    80000bd2:	40a48533          	sub	a0,s1,a0
    80000bd6:	00153513          	seqz	a0,a0
}
    80000bda:	60e2                	ld	ra,24(sp)
    80000bdc:	6442                	ld	s0,16(sp)
    80000bde:	64a2                	ld	s1,8(sp)
    80000be0:	6105                	addi	sp,sp,32
    80000be2:	8082                	ret

0000000080000be4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000be4:	1101                	addi	sp,sp,-32
    80000be6:	ec06                	sd	ra,24(sp)
    80000be8:	e822                	sd	s0,16(sp)
    80000bea:	e426                	sd	s1,8(sp)
    80000bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bee:	100027f3          	csrr	a5,sstatus
    80000bf2:	84be                	mv	s1,a5
    80000bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bfa:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bfe:	511000ef          	jal	8000190e <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	509000ef          	jal	8000190e <mycpu>
    80000c0a:	5d3c                	lw	a5,120(a0)
    80000c0c:	2785                	addiw	a5,a5,1
    80000c0e:	dd3c                	sw	a5,120(a0)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    mycpu()->intena = old;
    80000c1a:	4f5000ef          	jal	8000190e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c1e:	0014d793          	srli	a5,s1,0x1
    80000c22:	8b85                	andi	a5,a5,1
    80000c24:	dd7c                	sw	a5,124(a0)
    80000c26:	b7c5                	j	80000c06 <push_off+0x22>

0000000080000c28 <acquire>:
{
    80000c28:	1101                	addi	sp,sp,-32
    80000c2a:	ec06                	sd	ra,24(sp)
    80000c2c:	e822                	sd	s0,16(sp)
    80000c2e:	e426                	sd	s1,8(sp)
    80000c30:	1000                	addi	s0,sp,32
    80000c32:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c34:	fb1ff0ef          	jal	80000be4 <push_off>
  if(holding(lk))
    80000c38:	8526                	mv	a0,s1
    80000c3a:	f7fff0ef          	jal	80000bb8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	4705                	li	a4,1
  if(holding(lk))
    80000c40:	e105                	bnez	a0,80000c60 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c42:	87ba                	mv	a5,a4
    80000c44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c48:	2781                	sext.w	a5,a5
    80000c4a:	ffe5                	bnez	a5,80000c42 <acquire+0x1a>
  __sync_synchronize();
    80000c4c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c50:	4bf000ef          	jal	8000190e <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00006517          	auipc	a0,0x6
    80000c64:	3e850513          	addi	a0,a0,1000 # 80007048 <etext+0x48>
    80000c68:	bbdff0ef          	jal	80000824 <panic>

0000000080000c6c <pop_off>:

void
pop_off(void)
{
    80000c6c:	1141                	addi	sp,sp,-16
    80000c6e:	e406                	sd	ra,8(sp)
    80000c70:	e022                	sd	s0,0(sp)
    80000c72:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c74:	49b000ef          	jal	8000190e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c7c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7e:	e39d                	bnez	a5,80000ca4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c80:	5d3c                	lw	a5,120(a0)
    80000c82:	02f05763          	blez	a5,80000cb0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c86:	37fd                	addiw	a5,a5,-1
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb89                	bnez	a5,80000c9c <pop_off+0x30>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00006517          	auipc	a0,0x6
    80000ca8:	3ac50513          	addi	a0,a0,940 # 80007050 <etext+0x50>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00006517          	auipc	a0,0x6
    80000cb4:	3b850513          	addi	a0,a0,952 # 80007068 <etext+0x68>
    80000cb8:	b6dff0ef          	jal	80000824 <panic>

0000000080000cbc <release>:
{
    80000cbc:	1101                	addi	sp,sp,-32
    80000cbe:	ec06                	sd	ra,24(sp)
    80000cc0:	e822                	sd	s0,16(sp)
    80000cc2:	e426                	sd	s1,8(sp)
    80000cc4:	1000                	addi	s0,sp,32
    80000cc6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc8:	ef1ff0ef          	jal	80000bb8 <holding>
    80000ccc:	c105                	beqz	a0,80000cec <release+0x30>
  lk->cpu = 0;
    80000cce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cd6:	0310000f          	fence	rw,w
    80000cda:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cde:	f8fff0ef          	jal	80000c6c <pop_off>
}
    80000ce2:	60e2                	ld	ra,24(sp)
    80000ce4:	6442                	ld	s0,16(sp)
    80000ce6:	64a2                	ld	s1,8(sp)
    80000ce8:	6105                	addi	sp,sp,32
    80000cea:	8082                	ret
    panic("release");
    80000cec:	00006517          	auipc	a0,0x6
    80000cf0:	38450513          	addi	a0,a0,900 # 80007070 <etext+0x70>
    80000cf4:	b31ff0ef          	jal	80000824 <panic>

0000000080000cf8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e406                	sd	ra,8(sp)
    80000cfc:	e022                	sd	s0,0(sp)
    80000cfe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d00:	ca19                	beqz	a2,80000d16 <memset+0x1e>
    80000d02:	87aa                	mv	a5,a0
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d10:	0785                	addi	a5,a5,1
    80000d12:	fee79de3          	bne	a5,a4,80000d0c <memset+0x14>
  }
  return dst;
}
    80000d16:	60a2                	ld	ra,8(sp)
    80000d18:	6402                	ld	s0,0(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e406                	sd	ra,8(sp)
    80000d22:	e022                	sd	s0,0(sp)
    80000d24:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d26:	c61d                	beqz	a2,80000d54 <memcmp+0x36>
    80000d28:	1602                	slli	a2,a2,0x20
    80000d2a:	9201                	srli	a2,a2,0x20
    80000d2c:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d30:	00054783          	lbu	a5,0(a0)
    80000d34:	0005c703          	lbu	a4,0(a1)
    80000d38:	00e79863          	bne	a5,a4,80000d48 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d3c:	0505                	addi	a0,a0,1
    80000d3e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d40:	fed518e3          	bne	a0,a3,80000d30 <memcmp+0x12>
  }

  return 0;
    80000d44:	4501                	li	a0,0
    80000d46:	a019                	j	80000d4c <memcmp+0x2e>
      return *s1 - *s2;
    80000d48:	40e7853b          	subw	a0,a5,a4
}
    80000d4c:	60a2                	ld	ra,8(sp)
    80000d4e:	6402                	ld	s0,0(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  return 0;
    80000d54:	4501                	li	a0,0
    80000d56:	bfdd                	j	80000d4c <memcmp+0x2e>

0000000080000d58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d60:	c205                	beqz	a2,80000d80 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d62:	02a5e363          	bltu	a1,a0,80000d88 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d66:	1602                	slli	a2,a2,0x20
    80000d68:	9201                	srli	a2,a2,0x20
    80000d6a:	00c587b3          	add	a5,a1,a2
{
    80000d6e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d70:	0585                	addi	a1,a1,1
    80000d72:	0705                	addi	a4,a4,1
    80000d74:	fff5c683          	lbu	a3,-1(a1)
    80000d78:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d7c:	feb79ae3          	bne	a5,a1,80000d70 <memmove+0x18>

  return dst;
}
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
  if(s < d && s + n > d){
    80000d88:	02061693          	slli	a3,a2,0x20
    80000d8c:	9281                	srli	a3,a3,0x20
    80000d8e:	00d58733          	add	a4,a1,a3
    80000d92:	fce57ae3          	bgeu	a0,a4,80000d66 <memmove+0xe>
    d += n;
    80000d96:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d98:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d9c:	1782                	slli	a5,a5,0x20
    80000d9e:	9381                	srli	a5,a5,0x20
    80000da0:	fff7c793          	not	a5,a5
    80000da4:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000da6:	177d                	addi	a4,a4,-1
    80000da8:	16fd                	addi	a3,a3,-1
    80000daa:	00074603          	lbu	a2,0(a4)
    80000dae:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000db2:	fee79ae3          	bne	a5,a4,80000da6 <memmove+0x4e>
    80000db6:	b7e9                	j	80000d80 <memmove+0x28>

0000000080000db8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dc0:	f99ff0ef          	jal	80000d58 <memmove>
}
    80000dc4:	60a2                	ld	ra,8(sp)
    80000dc6:	6402                	ld	s0,0(sp)
    80000dc8:	0141                	addi	sp,sp,16
    80000dca:	8082                	ret

0000000080000dcc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dcc:	1141                	addi	sp,sp,-16
    80000dce:	e406                	sd	ra,8(sp)
    80000dd0:	e022                	sd	s0,0(sp)
    80000dd2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dd4:	ce11                	beqz	a2,80000df0 <strncmp+0x24>
    80000dd6:	00054783          	lbu	a5,0(a0)
    80000dda:	cf89                	beqz	a5,80000df4 <strncmp+0x28>
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	00f71a63          	bne	a4,a5,80000df4 <strncmp+0x28>
    n--, p++, q++;
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	0505                	addi	a0,a0,1
    80000de8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dea:	f675                	bnez	a2,80000dd6 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dec:	4501                	li	a0,0
    80000dee:	a801                	j	80000dfe <strncmp+0x32>
    80000df0:	4501                	li	a0,0
    80000df2:	a031                	j	80000dfe <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000df4:	00054503          	lbu	a0,0(a0)
    80000df8:	0005c783          	lbu	a5,0(a1)
    80000dfc:	9d1d                	subw	a0,a0,a5
}
    80000dfe:	60a2                	ld	ra,8(sp)
    80000e00:	6402                	ld	s0,0(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e406                	sd	ra,8(sp)
    80000e0a:	e022                	sd	s0,0(sp)
    80000e0c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e0e:	87aa                	mv	a5,a0
    80000e10:	a011                	j	80000e14 <strncpy+0xe>
    80000e12:	8636                	mv	a2,a3
    80000e14:	02c05863          	blez	a2,80000e44 <strncpy+0x3e>
    80000e18:	fff6069b          	addiw	a3,a2,-1
    80000e1c:	8836                	mv	a6,a3
    80000e1e:	0785                	addi	a5,a5,1
    80000e20:	0005c703          	lbu	a4,0(a1)
    80000e24:	fee78fa3          	sb	a4,-1(a5)
    80000e28:	0585                	addi	a1,a1,1
    80000e2a:	f765                	bnez	a4,80000e12 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e2c:	873e                	mv	a4,a5
    80000e2e:	01005b63          	blez	a6,80000e44 <strncpy+0x3e>
    80000e32:	9fb1                	addw	a5,a5,a2
    80000e34:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e36:	0705                	addi	a4,a4,1
    80000e38:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e3c:	40e786bb          	subw	a3,a5,a4
    80000e40:	fed04be3          	bgtz	a3,80000e36 <strncpy+0x30>
  return os;
}
    80000e44:	60a2                	ld	ra,8(sp)
    80000e46:	6402                	ld	s0,0(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e406                	sd	ra,8(sp)
    80000e50:	e022                	sd	s0,0(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e54:	02c05363          	blez	a2,80000e7a <safestrcpy+0x2e>
    80000e58:	fff6069b          	addiw	a3,a2,-1
    80000e5c:	1682                	slli	a3,a3,0x20
    80000e5e:	9281                	srli	a3,a3,0x20
    80000e60:	96ae                	add	a3,a3,a1
    80000e62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e64:	00d58963          	beq	a1,a3,80000e76 <safestrcpy+0x2a>
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff5c703          	lbu	a4,-1(a1)
    80000e70:	fee78fa3          	sb	a4,-1(a5)
    80000e74:	fb65                	bnez	a4,80000e64 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e7a:	60a2                	ld	ra,8(sp)
    80000e7c:	6402                	ld	s0,0(sp)
    80000e7e:	0141                	addi	sp,sp,16
    80000e80:	8082                	ret

0000000080000e82 <strlen>:

int
strlen(const char *s)
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e8a:	00054783          	lbu	a5,0(a0)
    80000e8e:	cf91                	beqz	a5,80000eaa <strlen+0x28>
    80000e90:	00150793          	addi	a5,a0,1
    80000e94:	86be                	mv	a3,a5
    80000e96:	0785                	addi	a5,a5,1
    80000e98:	fff7c703          	lbu	a4,-1(a5)
    80000e9c:	ff65                	bnez	a4,80000e94 <strlen+0x12>
    80000e9e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000ea2:	60a2                	ld	ra,8(sp)
    80000ea4:	6402                	ld	s0,0(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eaa:	4501                	li	a0,0
    80000eac:	bfdd                	j	80000ea2 <strlen+0x20>

0000000080000eae <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eae:	1141                	addi	sp,sp,-16
    80000eb0:	e406                	sd	ra,8(sp)
    80000eb2:	e022                	sd	s0,0(sp)
    80000eb4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb6:	245000ef          	jal	800018fa <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00007717          	auipc	a4,0x7
    80000ebe:	98670713          	addi	a4,a4,-1658 # 80007840 <started>
  if(cpuid() == 0){
    80000ec2:	c51d                	beqz	a0,80000ef0 <main+0x42>
    while(started == 0)
    80000ec4:	431c                	lw	a5,0(a4)
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	dff5                	beqz	a5,80000ec4 <main+0x16>
      ;
    __sync_synchronize();
    80000eca:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ece:	22d000ef          	jal	800018fa <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00006517          	auipc	a0,0x6
    80000ed8:	1c450513          	addi	a0,a0,452 # 80007098 <etext+0x98>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	568010ef          	jal	8000244c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	570040ef          	jal	80005458 <plicinithart>
  }

  scheduler();        
    80000eec:	6a7000ef          	jal	80001d92 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00006517          	auipc	a0,0x6
    80000efc:	18050513          	addi	a0,a0,384 # 80007078 <etext+0x78>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00006517          	auipc	a0,0x6
    80000f08:	17c50513          	addi	a0,a0,380 # 80007080 <etext+0x80>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00006517          	auipc	a0,0x6
    80000f14:	16850513          	addi	a0,a0,360 # 80007078 <etext+0x78>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2cc000ef          	jal	800011ec <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	11d000ef          	jal	80001844 <procinit>
    trapinit();      // trap vectors
    80000f2c:	4fc010ef          	jal	80002428 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	51c010ef          	jal	8000244c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	50a040ef          	jal	8000543e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	520040ef          	jal	80005458 <plicinithart>
    binit();         // buffer cache
    80000f3c:	39d010ef          	jal	80002ad8 <binit>
    iinit();         // inode table
    80000f40:	0ee020ef          	jal	8000302e <iinit>
    fileinit();      // file table
    80000f44:	01a030ef          	jal	80003f5e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	600040ef          	jal	80005548 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	4ad000ef          	jal	80001bf8 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	00007717          	auipc	a4,0x7
    80000f5a:	8ef72523          	sw	a5,-1814(a4) # 80007840 <started>
    80000f5e:	b779                	j	80000eec <main+0x3e>

0000000080000f60 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f60:	1141                	addi	sp,sp,-16
    80000f62:	e406                	sd	ra,8(sp)
    80000f64:	e022                	sd	s0,0(sp)
    80000f66:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f68:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f6c:	00007797          	auipc	a5,0x7
    80000f70:	8dc7b783          	ld	a5,-1828(a5) # 80007848 <kernel_pagetable>
    80000f74:	83b1                	srli	a5,a5,0xc
    80000f76:	577d                	li	a4,-1
    80000f78:	177e                	slli	a4,a4,0x3f
    80000f7a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f7c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f80:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f84:	60a2                	ld	ra,8(sp)
    80000f86:	6402                	ld	s0,0(sp)
    80000f88:	0141                	addi	sp,sp,16
    80000f8a:	8082                	ret

0000000080000f8c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f8c:	7139                	addi	sp,sp,-64
    80000f8e:	fc06                	sd	ra,56(sp)
    80000f90:	f822                	sd	s0,48(sp)
    80000f92:	f426                	sd	s1,40(sp)
    80000f94:	f04a                	sd	s2,32(sp)
    80000f96:	ec4e                	sd	s3,24(sp)
    80000f98:	e852                	sd	s4,16(sp)
    80000f9a:	e456                	sd	s5,8(sp)
    80000f9c:	e05a                	sd	s6,0(sp)
    80000f9e:	0080                	addi	s0,sp,64
    80000fa0:	84aa                	mv	s1,a0
    80000fa2:	89ae                	mv	s3,a1
    80000fa4:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80000fa6:	57fd                	li	a5,-1
    80000fa8:	83e9                	srli	a5,a5,0x1a
    80000faa:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fac:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000fae:	04b7e263          	bltu	a5,a1,80000ff2 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fb2:	0149d933          	srl	s2,s3,s4
    80000fb6:	1ff97913          	andi	s2,s2,511
    80000fba:	090e                	slli	s2,s2,0x3
    80000fbc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fbe:	00093483          	ld	s1,0(s2)
    80000fc2:	0014f793          	andi	a5,s1,1
    80000fc6:	cf85                	beqz	a5,80000ffe <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fc8:	80a9                	srli	s1,s1,0xa
    80000fca:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fcc:	3a5d                	addiw	s4,s4,-9
    80000fce:	ff5a12e3          	bne	s4,s5,80000fb2 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fd2:	00c9d513          	srli	a0,s3,0xc
    80000fd6:	1ff57513          	andi	a0,a0,511
    80000fda:	050e                	slli	a0,a0,0x3
    80000fdc:	9526                	add	a0,a0,s1
}
    80000fde:	70e2                	ld	ra,56(sp)
    80000fe0:	7442                	ld	s0,48(sp)
    80000fe2:	74a2                	ld	s1,40(sp)
    80000fe4:	7902                	ld	s2,32(sp)
    80000fe6:	69e2                	ld	s3,24(sp)
    80000fe8:	6a42                	ld	s4,16(sp)
    80000fea:	6aa2                	ld	s5,8(sp)
    80000fec:	6b02                	ld	s6,0(sp)
    80000fee:	6121                	addi	sp,sp,64
    80000ff0:	8082                	ret
    panic("walk");
    80000ff2:	00006517          	auipc	a0,0x6
    80000ff6:	0be50513          	addi	a0,a0,190 # 800070b0 <etext+0xb0>
    80000ffa:	82bff0ef          	jal	80000824 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ffe:	020b0263          	beqz	s6,80001022 <walk+0x96>
    80001002:	b43ff0ef          	jal	80000b44 <kalloc>
    80001006:	84aa                	mv	s1,a0
    80001008:	d979                	beqz	a0,80000fde <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000100a:	6605                	lui	a2,0x1
    8000100c:	4581                	li	a1,0
    8000100e:	cebff0ef          	jal	80000cf8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001012:	00c4d793          	srli	a5,s1,0xc
    80001016:	07aa                	slli	a5,a5,0xa
    80001018:	0017e793          	ori	a5,a5,1
    8000101c:	00f93023          	sd	a5,0(s2)
    80001020:	b775                	j	80000fcc <walk+0x40>
        return 0;
    80001022:	4501                	li	a0,0
    80001024:	bf6d                	j	80000fde <walk+0x52>

0000000080001026 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001026:	57fd                	li	a5,-1
    80001028:	83e9                	srli	a5,a5,0x1a
    8000102a:	00b7f463          	bgeu	a5,a1,80001032 <walkaddr+0xc>
    return 0;
    8000102e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001030:	8082                	ret
{
    80001032:	1141                	addi	sp,sp,-16
    80001034:	e406                	sd	ra,8(sp)
    80001036:	e022                	sd	s0,0(sp)
    80001038:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000103a:	4601                	li	a2,0
    8000103c:	f51ff0ef          	jal	80000f8c <walk>
  if(pte == 0)
    80001040:	c901                	beqz	a0,80001050 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    80001042:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001044:	0117f693          	andi	a3,a5,17
    80001048:	4745                	li	a4,17
    return 0;
    8000104a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000104c:	00e68663          	beq	a3,a4,80001058 <walkaddr+0x32>
}
    80001050:	60a2                	ld	ra,8(sp)
    80001052:	6402                	ld	s0,0(sp)
    80001054:	0141                	addi	sp,sp,16
    80001056:	8082                	ret
  pa = PTE2PA(*pte);
    80001058:	83a9                	srli	a5,a5,0xa
    8000105a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000105e:	bfcd                	j	80001050 <walkaddr+0x2a>

0000000080001060 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001060:	715d                	addi	sp,sp,-80
    80001062:	e486                	sd	ra,72(sp)
    80001064:	e0a2                	sd	s0,64(sp)
    80001066:	fc26                	sd	s1,56(sp)
    80001068:	f84a                	sd	s2,48(sp)
    8000106a:	f44e                	sd	s3,40(sp)
    8000106c:	f052                	sd	s4,32(sp)
    8000106e:	ec56                	sd	s5,24(sp)
    80001070:	e85a                	sd	s6,16(sp)
    80001072:	e45e                	sd	s7,8(sp)
    80001074:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001076:	03459793          	slli	a5,a1,0x34
    8000107a:	eba1                	bnez	a5,800010ca <mappages+0x6a>
    8000107c:	8a2a                	mv	s4,a0
    8000107e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001080:	03461793          	slli	a5,a2,0x34
    80001084:	eba9                	bnez	a5,800010d6 <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    80001086:	ce31                	beqz	a2,800010e2 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001088:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000108c:	80060613          	addi	a2,a2,-2048
    80001090:	00b60933          	add	s2,a2,a1
  a = va;
    80001094:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001096:	4b05                	li	s6,1
    80001098:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000109c:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000109e:	865a                	mv	a2,s6
    800010a0:	85a6                	mv	a1,s1
    800010a2:	8552                	mv	a0,s4
    800010a4:	ee9ff0ef          	jal	80000f8c <walk>
    800010a8:	c929                	beqz	a0,800010fa <mappages+0x9a>
    if(*pte & PTE_V)
    800010aa:	611c                	ld	a5,0(a0)
    800010ac:	8b85                	andi	a5,a5,1
    800010ae:	e3a1                	bnez	a5,800010ee <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010b0:	013487b3          	add	a5,s1,s3
    800010b4:	83b1                	srli	a5,a5,0xc
    800010b6:	07aa                	slli	a5,a5,0xa
    800010b8:	0157e7b3          	or	a5,a5,s5
    800010bc:	0017e793          	ori	a5,a5,1
    800010c0:	e11c                	sd	a5,0(a0)
    if(a == last)
    800010c2:	05248863          	beq	s1,s2,80001112 <mappages+0xb2>
    a += PGSIZE;
    800010c6:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c8:	bfd9                	j	8000109e <mappages+0x3e>
    panic("mappages: va not aligned");
    800010ca:	00006517          	auipc	a0,0x6
    800010ce:	fee50513          	addi	a0,a0,-18 # 800070b8 <etext+0xb8>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
    panic("mappages: size not aligned");
    800010d6:	00006517          	auipc	a0,0x6
    800010da:	00250513          	addi	a0,a0,2 # 800070d8 <etext+0xd8>
    800010de:	f46ff0ef          	jal	80000824 <panic>
    panic("mappages: size");
    800010e2:	00006517          	auipc	a0,0x6
    800010e6:	01650513          	addi	a0,a0,22 # 800070f8 <etext+0xf8>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
      panic("mappages: remap");
    800010ee:	00006517          	auipc	a0,0x6
    800010f2:	01a50513          	addi	a0,a0,26 # 80007108 <etext+0x108>
    800010f6:	f2eff0ef          	jal	80000824 <panic>
      return -1;
    800010fa:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010fc:	60a6                	ld	ra,72(sp)
    800010fe:	6406                	ld	s0,64(sp)
    80001100:	74e2                	ld	s1,56(sp)
    80001102:	7942                	ld	s2,48(sp)
    80001104:	79a2                	ld	s3,40(sp)
    80001106:	7a02                	ld	s4,32(sp)
    80001108:	6ae2                	ld	s5,24(sp)
    8000110a:	6b42                	ld	s6,16(sp)
    8000110c:	6ba2                	ld	s7,8(sp)
    8000110e:	6161                	addi	sp,sp,80
    80001110:	8082                	ret
  return 0;
    80001112:	4501                	li	a0,0
    80001114:	b7e5                	j	800010fc <mappages+0x9c>

0000000080001116 <kvmmap>:
{
    80001116:	1141                	addi	sp,sp,-16
    80001118:	e406                	sd	ra,8(sp)
    8000111a:	e022                	sd	s0,0(sp)
    8000111c:	0800                	addi	s0,sp,16
    8000111e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001120:	86b2                	mv	a3,a2
    80001122:	863e                	mv	a2,a5
    80001124:	f3dff0ef          	jal	80001060 <mappages>
    80001128:	e509                	bnez	a0,80001132 <kvmmap+0x1c>
}
    8000112a:	60a2                	ld	ra,8(sp)
    8000112c:	6402                	ld	s0,0(sp)
    8000112e:	0141                	addi	sp,sp,16
    80001130:	8082                	ret
    panic("kvmmap");
    80001132:	00006517          	auipc	a0,0x6
    80001136:	fe650513          	addi	a0,a0,-26 # 80007118 <etext+0x118>
    8000113a:	eeaff0ef          	jal	80000824 <panic>

000000008000113e <kvmmake>:
{
    8000113e:	1101                	addi	sp,sp,-32
    80001140:	ec06                	sd	ra,24(sp)
    80001142:	e822                	sd	s0,16(sp)
    80001144:	e426                	sd	s1,8(sp)
    80001146:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001148:	9fdff0ef          	jal	80000b44 <kalloc>
    8000114c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000114e:	6605                	lui	a2,0x1
    80001150:	4581                	li	a1,0
    80001152:	ba7ff0ef          	jal	80000cf8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001156:	4719                	li	a4,6
    80001158:	6685                	lui	a3,0x1
    8000115a:	10000637          	lui	a2,0x10000
    8000115e:	85b2                	mv	a1,a2
    80001160:	8526                	mv	a0,s1
    80001162:	fb5ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001166:	4719                	li	a4,6
    80001168:	6685                	lui	a3,0x1
    8000116a:	10001637          	lui	a2,0x10001
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	fa5ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001176:	4719                	li	a4,6
    80001178:	040006b7          	lui	a3,0x4000
    8000117c:	0c000637          	lui	a2,0xc000
    80001180:	85b2                	mv	a1,a2
    80001182:	8526                	mv	a0,s1
    80001184:	f93ff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001188:	4729                	li	a4,10
    8000118a:	80006697          	auipc	a3,0x80006
    8000118e:	e7668693          	addi	a3,a3,-394 # 7000 <_entry-0x7fff9000>
    80001192:	4605                	li	a2,1
    80001194:	067e                	slli	a2,a2,0x1f
    80001196:	85b2                	mv	a1,a2
    80001198:	8526                	mv	a0,s1
    8000119a:	f7dff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119e:	4719                	li	a4,6
    800011a0:	00006697          	auipc	a3,0x6
    800011a4:	e6068693          	addi	a3,a3,-416 # 80007000 <etext>
    800011a8:	47c5                	li	a5,17
    800011aa:	07ee                	slli	a5,a5,0x1b
    800011ac:	40d786b3          	sub	a3,a5,a3
    800011b0:	00006617          	auipc	a2,0x6
    800011b4:	e5060613          	addi	a2,a2,-432 # 80007000 <etext>
    800011b8:	85b2                	mv	a1,a2
    800011ba:	8526                	mv	a0,s1
    800011bc:	f5bff0ef          	jal	80001116 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c0:	4729                	li	a4,10
    800011c2:	6685                	lui	a3,0x1
    800011c4:	00005617          	auipc	a2,0x5
    800011c8:	e3c60613          	addi	a2,a2,-452 # 80006000 <_trampoline>
    800011cc:	040005b7          	lui	a1,0x4000
    800011d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d2:	05b2                	slli	a1,a1,0xc
    800011d4:	8526                	mv	a0,s1
    800011d6:	f41ff0ef          	jal	80001116 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011da:	8526                	mv	a0,s1
    800011dc:	5c4000ef          	jal	800017a0 <proc_mapstacks>
}
    800011e0:	8526                	mv	a0,s1
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <kvminit>:
{
    800011ec:	1141                	addi	sp,sp,-16
    800011ee:	e406                	sd	ra,8(sp)
    800011f0:	e022                	sd	s0,0(sp)
    800011f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011f4:	f4bff0ef          	jal	8000113e <kvmmake>
    800011f8:	00006797          	auipc	a5,0x6
    800011fc:	64a7b823          	sd	a0,1616(a5) # 80007848 <kernel_pagetable>
}
    80001200:	60a2                	ld	ra,8(sp)
    80001202:	6402                	ld	s0,0(sp)
    80001204:	0141                	addi	sp,sp,16
    80001206:	8082                	ret

0000000080001208 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001212:	933ff0ef          	jal	80000b44 <kalloc>
    80001216:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001218:	c509                	beqz	a0,80001222 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000121a:	6605                	lui	a2,0x1
    8000121c:	4581                	li	a1,0
    8000121e:	adbff0ef          	jal	80000cf8 <memset>
  return pagetable;
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000122e:	7139                	addi	sp,sp,-64
    80001230:	fc06                	sd	ra,56(sp)
    80001232:	f822                	sd	s0,48(sp)
    80001234:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001236:	03459793          	slli	a5,a1,0x34
    8000123a:	e38d                	bnez	a5,8000125c <uvmunmap+0x2e>
    8000123c:	f04a                	sd	s2,32(sp)
    8000123e:	ec4e                	sd	s3,24(sp)
    80001240:	e852                	sd	s4,16(sp)
    80001242:	e456                	sd	s5,8(sp)
    80001244:	e05a                	sd	s6,0(sp)
    80001246:	8a2a                	mv	s4,a0
    80001248:	892e                	mv	s2,a1
    8000124a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124c:	0632                	slli	a2,a2,0xc
    8000124e:	00b609b3          	add	s3,a2,a1
    80001252:	6b05                	lui	s6,0x1
    80001254:	0535f963          	bgeu	a1,s3,800012a6 <uvmunmap+0x78>
    80001258:	f426                	sd	s1,40(sp)
    8000125a:	a015                	j	8000127e <uvmunmap+0x50>
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	f04a                	sd	s2,32(sp)
    80001260:	ec4e                	sd	s3,24(sp)
    80001262:	e852                	sd	s4,16(sp)
    80001264:	e456                	sd	s5,8(sp)
    80001266:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001268:	00006517          	auipc	a0,0x6
    8000126c:	eb850513          	addi	a0,a0,-328 # 80007120 <etext+0x120>
    80001270:	db4ff0ef          	jal	80000824 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001274:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001278:	995a                	add	s2,s2,s6
    8000127a:	03397563          	bgeu	s2,s3,800012a4 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000127e:	4601                	li	a2,0
    80001280:	85ca                	mv	a1,s2
    80001282:	8552                	mv	a0,s4
    80001284:	d09ff0ef          	jal	80000f8c <walk>
    80001288:	84aa                	mv	s1,a0
    8000128a:	d57d                	beqz	a0,80001278 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000128c:	611c                	ld	a5,0(a0)
    8000128e:	0017f713          	andi	a4,a5,1
    80001292:	d37d                	beqz	a4,80001278 <uvmunmap+0x4a>
    if(do_free){
    80001294:	fe0a80e3          	beqz	s5,80001274 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001298:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000129a:	00c79513          	slli	a0,a5,0xc
    8000129e:	fbeff0ef          	jal	80000a5c <kfree>
    800012a2:	bfc9                	j	80001274 <uvmunmap+0x46>
    800012a4:	74a2                	ld	s1,40(sp)
    800012a6:	7902                	ld	s2,32(sp)
    800012a8:	69e2                	ld	s3,24(sp)
    800012aa:	6a42                	ld	s4,16(sp)
    800012ac:	6aa2                	ld	s5,8(sp)
    800012ae:	6b02                	ld	s6,0(sp)
  }
}
    800012b0:	70e2                	ld	ra,56(sp)
    800012b2:	7442                	ld	s0,48(sp)
    800012b4:	6121                	addi	sp,sp,64
    800012b6:	8082                	ret

00000000800012b8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012b8:	1101                	addi	sp,sp,-32
    800012ba:	ec06                	sd	ra,24(sp)
    800012bc:	e822                	sd	s0,16(sp)
    800012be:	e426                	sd	s1,8(sp)
    800012c0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012c2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012c4:	00b67d63          	bgeu	a2,a1,800012de <uvmdealloc+0x26>
    800012c8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012ca:	6785                	lui	a5,0x1
    800012cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ce:	00f60733          	add	a4,a2,a5
    800012d2:	76fd                	lui	a3,0xfffff
    800012d4:	8f75                	and	a4,a4,a3
    800012d6:	97ae                	add	a5,a5,a1
    800012d8:	8ff5                	and	a5,a5,a3
    800012da:	00f76863          	bltu	a4,a5,800012ea <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012de:	8526                	mv	a0,s1
    800012e0:	60e2                	ld	ra,24(sp)
    800012e2:	6442                	ld	s0,16(sp)
    800012e4:	64a2                	ld	s1,8(sp)
    800012e6:	6105                	addi	sp,sp,32
    800012e8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ea:	8f99                	sub	a5,a5,a4
    800012ec:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012ee:	4685                	li	a3,1
    800012f0:	0007861b          	sext.w	a2,a5
    800012f4:	85ba                	mv	a1,a4
    800012f6:	f39ff0ef          	jal	8000122e <uvmunmap>
    800012fa:	b7d5                	j	800012de <uvmdealloc+0x26>

00000000800012fc <uvmalloc>:
  if(newsz < oldsz)
    800012fc:	0ab66163          	bltu	a2,a1,8000139e <uvmalloc+0xa2>
{
    80001300:	715d                	addi	sp,sp,-80
    80001302:	e486                	sd	ra,72(sp)
    80001304:	e0a2                	sd	s0,64(sp)
    80001306:	f84a                	sd	s2,48(sp)
    80001308:	f052                	sd	s4,32(sp)
    8000130a:	ec56                	sd	s5,24(sp)
    8000130c:	e45e                	sd	s7,8(sp)
    8000130e:	0880                	addi	s0,sp,80
    80001310:	8aaa                	mv	s5,a0
    80001312:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001314:	6785                	lui	a5,0x1
    80001316:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001318:	95be                	add	a1,a1,a5
    8000131a:	77fd                	lui	a5,0xfffff
    8000131c:	00f5f933          	and	s2,a1,a5
    80001320:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001322:	08c97063          	bgeu	s2,a2,800013a2 <uvmalloc+0xa6>
    80001326:	fc26                	sd	s1,56(sp)
    80001328:	f44e                	sd	s3,40(sp)
    8000132a:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    8000132c:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000132e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001332:	813ff0ef          	jal	80000b44 <kalloc>
    80001336:	84aa                	mv	s1,a0
    if(mem == 0){
    80001338:	c50d                	beqz	a0,80001362 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    8000133a:	864e                	mv	a2,s3
    8000133c:	4581                	li	a1,0
    8000133e:	9bbff0ef          	jal	80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001342:	875a                	mv	a4,s6
    80001344:	86a6                	mv	a3,s1
    80001346:	864e                	mv	a2,s3
    80001348:	85ca                	mv	a1,s2
    8000134a:	8556                	mv	a0,s5
    8000134c:	d15ff0ef          	jal	80001060 <mappages>
    80001350:	e915                	bnez	a0,80001384 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001352:	994e                	add	s2,s2,s3
    80001354:	fd496fe3          	bltu	s2,s4,80001332 <uvmalloc+0x36>
  return newsz;
    80001358:	8552                	mv	a0,s4
    8000135a:	74e2                	ld	s1,56(sp)
    8000135c:	79a2                	ld	s3,40(sp)
    8000135e:	6b42                	ld	s6,16(sp)
    80001360:	a811                	j	80001374 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001362:	865e                	mv	a2,s7
    80001364:	85ca                	mv	a1,s2
    80001366:	8556                	mv	a0,s5
    80001368:	f51ff0ef          	jal	800012b8 <uvmdealloc>
      return 0;
    8000136c:	4501                	li	a0,0
    8000136e:	74e2                	ld	s1,56(sp)
    80001370:	79a2                	ld	s3,40(sp)
    80001372:	6b42                	ld	s6,16(sp)
}
    80001374:	60a6                	ld	ra,72(sp)
    80001376:	6406                	ld	s0,64(sp)
    80001378:	7942                	ld	s2,48(sp)
    8000137a:	7a02                	ld	s4,32(sp)
    8000137c:	6ae2                	ld	s5,24(sp)
    8000137e:	6ba2                	ld	s7,8(sp)
    80001380:	6161                	addi	sp,sp,80
    80001382:	8082                	ret
      kfree(mem);
    80001384:	8526                	mv	a0,s1
    80001386:	ed6ff0ef          	jal	80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000138a:	865e                	mv	a2,s7
    8000138c:	85ca                	mv	a1,s2
    8000138e:	8556                	mv	a0,s5
    80001390:	f29ff0ef          	jal	800012b8 <uvmdealloc>
      return 0;
    80001394:	4501                	li	a0,0
    80001396:	74e2                	ld	s1,56(sp)
    80001398:	79a2                	ld	s3,40(sp)
    8000139a:	6b42                	ld	s6,16(sp)
    8000139c:	bfe1                	j	80001374 <uvmalloc+0x78>
    return oldsz;
    8000139e:	852e                	mv	a0,a1
}
    800013a0:	8082                	ret
  return newsz;
    800013a2:	8532                	mv	a0,a2
    800013a4:	bfc1                	j	80001374 <uvmalloc+0x78>

00000000800013a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013a6:	7179                	addi	sp,sp,-48
    800013a8:	f406                	sd	ra,40(sp)
    800013aa:	f022                	sd	s0,32(sp)
    800013ac:	ec26                	sd	s1,24(sp)
    800013ae:	e84a                	sd	s2,16(sp)
    800013b0:	e44e                	sd	s3,8(sp)
    800013b2:	1800                	addi	s0,sp,48
    800013b4:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013b6:	84aa                	mv	s1,a0
    800013b8:	6905                	lui	s2,0x1
    800013ba:	992a                	add	s2,s2,a0
    800013bc:	a811                	j	800013d0 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800013be:	00006517          	auipc	a0,0x6
    800013c2:	d7a50513          	addi	a0,a0,-646 # 80007138 <etext+0x138>
    800013c6:	c5eff0ef          	jal	80000824 <panic>
  for(int i = 0; i < 512; i++){
    800013ca:	04a1                	addi	s1,s1,8
    800013cc:	03248163          	beq	s1,s2,800013ee <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013d0:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013d2:	0017f713          	andi	a4,a5,1
    800013d6:	db75                	beqz	a4,800013ca <freewalk+0x24>
    800013d8:	00e7f713          	andi	a4,a5,14
    800013dc:	f36d                	bnez	a4,800013be <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800013de:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013e0:	00c79513          	slli	a0,a5,0xc
    800013e4:	fc3ff0ef          	jal	800013a6 <freewalk>
      pagetable[i] = 0;
    800013e8:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013ec:	bff9                	j	800013ca <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800013ee:	854e                	mv	a0,s3
    800013f0:	e6cff0ef          	jal	80000a5c <kfree>
}
    800013f4:	70a2                	ld	ra,40(sp)
    800013f6:	7402                	ld	s0,32(sp)
    800013f8:	64e2                	ld	s1,24(sp)
    800013fa:	6942                	ld	s2,16(sp)
    800013fc:	69a2                	ld	s3,8(sp)
    800013fe:	6145                	addi	sp,sp,48
    80001400:	8082                	ret

0000000080001402 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001402:	1101                	addi	sp,sp,-32
    80001404:	ec06                	sd	ra,24(sp)
    80001406:	e822                	sd	s0,16(sp)
    80001408:	e426                	sd	s1,8(sp)
    8000140a:	1000                	addi	s0,sp,32
    8000140c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000140e:	e989                	bnez	a1,80001420 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001410:	8526                	mv	a0,s1
    80001412:	f95ff0ef          	jal	800013a6 <freewalk>
}
    80001416:	60e2                	ld	ra,24(sp)
    80001418:	6442                	ld	s0,16(sp)
    8000141a:	64a2                	ld	s1,8(sp)
    8000141c:	6105                	addi	sp,sp,32
    8000141e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001420:	6785                	lui	a5,0x1
    80001422:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001424:	95be                	add	a1,a1,a5
    80001426:	4685                	li	a3,1
    80001428:	00c5d613          	srli	a2,a1,0xc
    8000142c:	4581                	li	a1,0
    8000142e:	e01ff0ef          	jal	8000122e <uvmunmap>
    80001432:	bff9                	j	80001410 <uvmfree+0xe>

0000000080001434 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001434:	ca59                	beqz	a2,800014ca <uvmcopy+0x96>
{
    80001436:	715d                	addi	sp,sp,-80
    80001438:	e486                	sd	ra,72(sp)
    8000143a:	e0a2                	sd	s0,64(sp)
    8000143c:	fc26                	sd	s1,56(sp)
    8000143e:	f84a                	sd	s2,48(sp)
    80001440:	f44e                	sd	s3,40(sp)
    80001442:	f052                	sd	s4,32(sp)
    80001444:	ec56                	sd	s5,24(sp)
    80001446:	e85a                	sd	s6,16(sp)
    80001448:	e45e                	sd	s7,8(sp)
    8000144a:	0880                	addi	s0,sp,80
    8000144c:	8b2a                	mv	s6,a0
    8000144e:	8bae                	mv	s7,a1
    80001450:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001452:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001454:	6a05                	lui	s4,0x1
    80001456:	a021                	j	8000145e <uvmcopy+0x2a>
  for(i = 0; i < sz; i += PGSIZE){
    80001458:	94d2                	add	s1,s1,s4
    8000145a:	0554fc63          	bgeu	s1,s5,800014b2 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    8000145e:	4601                	li	a2,0
    80001460:	85a6                	mv	a1,s1
    80001462:	855a                	mv	a0,s6
    80001464:	b29ff0ef          	jal	80000f8c <walk>
    80001468:	d965                	beqz	a0,80001458 <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    8000146a:	00053983          	ld	s3,0(a0)
    8000146e:	0019f793          	andi	a5,s3,1
    80001472:	d3fd                	beqz	a5,80001458 <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    80001474:	ed0ff0ef          	jal	80000b44 <kalloc>
    80001478:	892a                	mv	s2,a0
    8000147a:	c11d                	beqz	a0,800014a0 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000147c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001480:	8652                	mv	a2,s4
    80001482:	05b2                	slli	a1,a1,0xc
    80001484:	8d5ff0ef          	jal	80000d58 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001488:	3ff9f713          	andi	a4,s3,1023
    8000148c:	86ca                	mv	a3,s2
    8000148e:	8652                	mv	a2,s4
    80001490:	85a6                	mv	a1,s1
    80001492:	855e                	mv	a0,s7
    80001494:	bcdff0ef          	jal	80001060 <mappages>
    80001498:	d161                	beqz	a0,80001458 <uvmcopy+0x24>
      kfree(mem);
    8000149a:	854a                	mv	a0,s2
    8000149c:	dc0ff0ef          	jal	80000a5c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014a0:	4685                	li	a3,1
    800014a2:	00c4d613          	srli	a2,s1,0xc
    800014a6:	4581                	li	a1,0
    800014a8:	855e                	mv	a0,s7
    800014aa:	d85ff0ef          	jal	8000122e <uvmunmap>
  return -1;
    800014ae:	557d                	li	a0,-1
    800014b0:	a011                	j	800014b4 <uvmcopy+0x80>
  return 0;
    800014b2:	4501                	li	a0,0
}
    800014b4:	60a6                	ld	ra,72(sp)
    800014b6:	6406                	ld	s0,64(sp)
    800014b8:	74e2                	ld	s1,56(sp)
    800014ba:	7942                	ld	s2,48(sp)
    800014bc:	79a2                	ld	s3,40(sp)
    800014be:	7a02                	ld	s4,32(sp)
    800014c0:	6ae2                	ld	s5,24(sp)
    800014c2:	6b42                	ld	s6,16(sp)
    800014c4:	6ba2                	ld	s7,8(sp)
    800014c6:	6161                	addi	sp,sp,80
    800014c8:	8082                	ret
  return 0;
    800014ca:	4501                	li	a0,0
}
    800014cc:	8082                	ret

00000000800014ce <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014ce:	1141                	addi	sp,sp,-16
    800014d0:	e406                	sd	ra,8(sp)
    800014d2:	e022                	sd	s0,0(sp)
    800014d4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014d6:	4601                	li	a2,0
    800014d8:	ab5ff0ef          	jal	80000f8c <walk>
  if(pte == 0)
    800014dc:	c901                	beqz	a0,800014ec <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014de:	611c                	ld	a5,0(a0)
    800014e0:	9bbd                	andi	a5,a5,-17
    800014e2:	e11c                	sd	a5,0(a0)
}
    800014e4:	60a2                	ld	ra,8(sp)
    800014e6:	6402                	ld	s0,0(sp)
    800014e8:	0141                	addi	sp,sp,16
    800014ea:	8082                	ret
    panic("uvmclear");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	c5c50513          	addi	a0,a0,-932 # 80007148 <etext+0x148>
    800014f4:	b30ff0ef          	jal	80000824 <panic>

00000000800014f8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800014f8:	cac5                	beqz	a3,800015a8 <copyinstr+0xb0>
{
    800014fa:	715d                	addi	sp,sp,-80
    800014fc:	e486                	sd	ra,72(sp)
    800014fe:	e0a2                	sd	s0,64(sp)
    80001500:	fc26                	sd	s1,56(sp)
    80001502:	f84a                	sd	s2,48(sp)
    80001504:	f44e                	sd	s3,40(sp)
    80001506:	f052                	sd	s4,32(sp)
    80001508:	ec56                	sd	s5,24(sp)
    8000150a:	e85a                	sd	s6,16(sp)
    8000150c:	e45e                	sd	s7,8(sp)
    8000150e:	0880                	addi	s0,sp,80
    80001510:	8aaa                	mv	s5,a0
    80001512:	84ae                	mv	s1,a1
    80001514:	8bb2                	mv	s7,a2
    80001516:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001518:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000151a:	6a05                	lui	s4,0x1
    8000151c:	a82d                	j	80001556 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000151e:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80001522:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001524:	0017c793          	xori	a5,a5,1
    80001528:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000152c:	60a6                	ld	ra,72(sp)
    8000152e:	6406                	ld	s0,64(sp)
    80001530:	74e2                	ld	s1,56(sp)
    80001532:	7942                	ld	s2,48(sp)
    80001534:	79a2                	ld	s3,40(sp)
    80001536:	7a02                	ld	s4,32(sp)
    80001538:	6ae2                	ld	s5,24(sp)
    8000153a:	6b42                	ld	s6,16(sp)
    8000153c:	6ba2                	ld	s7,8(sp)
    8000153e:	6161                	addi	sp,sp,80
    80001540:	8082                	ret
    80001542:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001546:	9726                	add	a4,a4,s1
      --max;
    80001548:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    8000154c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001550:	04e58463          	beq	a1,a4,80001598 <copyinstr+0xa0>
{
    80001554:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001556:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000155a:	85ca                	mv	a1,s2
    8000155c:	8556                	mv	a0,s5
    8000155e:	ac9ff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0)
    80001562:	cd0d                	beqz	a0,8000159c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001564:	417906b3          	sub	a3,s2,s7
    80001568:	96d2                	add	a3,a3,s4
    if(n > max)
    8000156a:	00d9f363          	bgeu	s3,a3,80001570 <copyinstr+0x78>
    8000156e:	86ce                	mv	a3,s3
    while(n > 0){
    80001570:	ca85                	beqz	a3,800015a0 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80001572:	01750633          	add	a2,a0,s7
    80001576:	41260633          	sub	a2,a2,s2
    8000157a:	87a6                	mv	a5,s1
      if(*p == '\0'){
    8000157c:	8e05                	sub	a2,a2,s1
    while(n > 0){
    8000157e:	96a6                	add	a3,a3,s1
    80001580:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001582:	00f60733          	add	a4,a2,a5
    80001586:	00074703          	lbu	a4,0(a4)
    8000158a:	db51                	beqz	a4,8000151e <copyinstr+0x26>
        *dst = *p;
    8000158c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001590:	0785                	addi	a5,a5,1
    while(n > 0){
    80001592:	fed797e3          	bne	a5,a3,80001580 <copyinstr+0x88>
    80001596:	b775                	j	80001542 <copyinstr+0x4a>
    80001598:	4781                	li	a5,0
    8000159a:	b769                	j	80001524 <copyinstr+0x2c>
      return -1;
    8000159c:	557d                	li	a0,-1
    8000159e:	b779                	j	8000152c <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800015a0:	6b85                	lui	s7,0x1
    800015a2:	9bca                	add	s7,s7,s2
    800015a4:	87a6                	mv	a5,s1
    800015a6:	b77d                	j	80001554 <copyinstr+0x5c>
  int got_null = 0;
    800015a8:	4781                	li	a5,0
  if(got_null){
    800015aa:	0017c793          	xori	a5,a5,1
    800015ae:	40f0053b          	negw	a0,a5
}
    800015b2:	8082                	ret

00000000800015b4 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800015b4:	1141                	addi	sp,sp,-16
    800015b6:	e406                	sd	ra,8(sp)
    800015b8:	e022                	sd	s0,0(sp)
    800015ba:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800015bc:	4601                	li	a2,0
    800015be:	9cfff0ef          	jal	80000f8c <walk>
  if (pte == 0) {
    800015c2:	c119                	beqz	a0,800015c8 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    800015c4:	6108                	ld	a0,0(a0)
    800015c6:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800015c8:	60a2                	ld	ra,8(sp)
    800015ca:	6402                	ld	s0,0(sp)
    800015cc:	0141                	addi	sp,sp,16
    800015ce:	8082                	ret

00000000800015d0 <vmfault>:
{
    800015d0:	7179                	addi	sp,sp,-48
    800015d2:	f406                	sd	ra,40(sp)
    800015d4:	f022                	sd	s0,32(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	e44e                	sd	s3,8(sp)
    800015da:	1800                	addi	s0,sp,48
    800015dc:	89aa                	mv	s3,a0
    800015de:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015e0:	34e000ef          	jal	8000192e <myproc>
  if (va >= p->sz)
    800015e4:	653c                	ld	a5,72(a0)
    800015e6:	00f96a63          	bltu	s2,a5,800015fa <vmfault+0x2a>
    return 0;
    800015ea:	4981                	li	s3,0
}
    800015ec:	854e                	mv	a0,s3
    800015ee:	70a2                	ld	ra,40(sp)
    800015f0:	7402                	ld	s0,32(sp)
    800015f2:	6942                	ld	s2,16(sp)
    800015f4:	69a2                	ld	s3,8(sp)
    800015f6:	6145                	addi	sp,sp,48
    800015f8:	8082                	ret
    800015fa:	ec26                	sd	s1,24(sp)
    800015fc:	e052                	sd	s4,0(sp)
    800015fe:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80001600:	77fd                	lui	a5,0xfffff
    80001602:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80001606:	85d2                	mv	a1,s4
    80001608:	854e                	mv	a0,s3
    8000160a:	fabff0ef          	jal	800015b4 <ismapped>
    return 0;
    8000160e:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001610:	c501                	beqz	a0,80001618 <vmfault+0x48>
    80001612:	64e2                	ld	s1,24(sp)
    80001614:	6a02                	ld	s4,0(sp)
    80001616:	bfd9                	j	800015ec <vmfault+0x1c>
  mem = (uint64) kalloc();
    80001618:	d2cff0ef          	jal	80000b44 <kalloc>
    8000161c:	892a                	mv	s2,a0
  if(mem == 0)
    8000161e:	c905                	beqz	a0,8000164e <vmfault+0x7e>
  mem = (uint64) kalloc();
    80001620:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001622:	6605                	lui	a2,0x1
    80001624:	4581                	li	a1,0
    80001626:	ed2ff0ef          	jal	80000cf8 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000162a:	4759                	li	a4,22
    8000162c:	86ca                	mv	a3,s2
    8000162e:	6605                	lui	a2,0x1
    80001630:	85d2                	mv	a1,s4
    80001632:	68a8                	ld	a0,80(s1)
    80001634:	a2dff0ef          	jal	80001060 <mappages>
    80001638:	e501                	bnez	a0,80001640 <vmfault+0x70>
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6a02                	ld	s4,0(sp)
    8000163e:	b77d                	j	800015ec <vmfault+0x1c>
    kfree((void *)mem);
    80001640:	854a                	mv	a0,s2
    80001642:	c1aff0ef          	jal	80000a5c <kfree>
    return 0;
    80001646:	4981                	li	s3,0
    80001648:	64e2                	ld	s1,24(sp)
    8000164a:	6a02                	ld	s4,0(sp)
    8000164c:	b745                	j	800015ec <vmfault+0x1c>
    8000164e:	64e2                	ld	s1,24(sp)
    80001650:	6a02                	ld	s4,0(sp)
    80001652:	bf69                	j	800015ec <vmfault+0x1c>

0000000080001654 <copyout>:
  while(len > 0){
    80001654:	cad1                	beqz	a3,800016e8 <copyout+0x94>
{
    80001656:	711d                	addi	sp,sp,-96
    80001658:	ec86                	sd	ra,88(sp)
    8000165a:	e8a2                	sd	s0,80(sp)
    8000165c:	e4a6                	sd	s1,72(sp)
    8000165e:	e0ca                	sd	s2,64(sp)
    80001660:	fc4e                	sd	s3,56(sp)
    80001662:	f852                	sd	s4,48(sp)
    80001664:	f456                	sd	s5,40(sp)
    80001666:	f05a                	sd	s6,32(sp)
    80001668:	ec5e                	sd	s7,24(sp)
    8000166a:	e862                	sd	s8,16(sp)
    8000166c:	e466                	sd	s9,8(sp)
    8000166e:	e06a                	sd	s10,0(sp)
    80001670:	1080                	addi	s0,sp,96
    80001672:	8baa                	mv	s7,a0
    80001674:	8a2e                	mv	s4,a1
    80001676:	8b32                	mv	s6,a2
    80001678:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000167a:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    8000167c:	5cfd                	li	s9,-1
    8000167e:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001682:	6c05                	lui	s8,0x1
    80001684:	a005                	j	800016a4 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001686:	409a0533          	sub	a0,s4,s1
    8000168a:	0009061b          	sext.w	a2,s2
    8000168e:	85da                	mv	a1,s6
    80001690:	954e                	add	a0,a0,s3
    80001692:	ec6ff0ef          	jal	80000d58 <memmove>
    len -= n;
    80001696:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000169a:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000169c:	01848a33          	add	s4,s1,s8
  while(len > 0){
    800016a0:	040a8263          	beqz	s5,800016e4 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    800016a4:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    800016a8:	049ce263          	bltu	s9,s1,800016ec <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    800016ac:	85a6                	mv	a1,s1
    800016ae:	855e                	mv	a0,s7
    800016b0:	977ff0ef          	jal	80001026 <walkaddr>
    800016b4:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    800016b6:	e901                	bnez	a0,800016c6 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800016b8:	4601                	li	a2,0
    800016ba:	85a6                	mv	a1,s1
    800016bc:	855e                	mv	a0,s7
    800016be:	f13ff0ef          	jal	800015d0 <vmfault>
    800016c2:	89aa                	mv	s3,a0
    800016c4:	c139                	beqz	a0,8000170a <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    800016c6:	4601                	li	a2,0
    800016c8:	85a6                	mv	a1,s1
    800016ca:	855e                	mv	a0,s7
    800016cc:	8c1ff0ef          	jal	80000f8c <walk>
    if((*pte & PTE_W) == 0)
    800016d0:	611c                	ld	a5,0(a0)
    800016d2:	8b91                	andi	a5,a5,4
    800016d4:	cf8d                	beqz	a5,8000170e <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    800016d6:	41448933          	sub	s2,s1,s4
    800016da:	9962                	add	s2,s2,s8
    if(n > len)
    800016dc:	fb2af5e3          	bgeu	s5,s2,80001686 <copyout+0x32>
    800016e0:	8956                	mv	s2,s5
    800016e2:	b755                	j	80001686 <copyout+0x32>
  return 0;
    800016e4:	4501                	li	a0,0
    800016e6:	a021                	j	800016ee <copyout+0x9a>
    800016e8:	4501                	li	a0,0
}
    800016ea:	8082                	ret
      return -1;
    800016ec:	557d                	li	a0,-1
}
    800016ee:	60e6                	ld	ra,88(sp)
    800016f0:	6446                	ld	s0,80(sp)
    800016f2:	64a6                	ld	s1,72(sp)
    800016f4:	6906                	ld	s2,64(sp)
    800016f6:	79e2                	ld	s3,56(sp)
    800016f8:	7a42                	ld	s4,48(sp)
    800016fa:	7aa2                	ld	s5,40(sp)
    800016fc:	7b02                	ld	s6,32(sp)
    800016fe:	6be2                	ld	s7,24(sp)
    80001700:	6c42                	ld	s8,16(sp)
    80001702:	6ca2                	ld	s9,8(sp)
    80001704:	6d02                	ld	s10,0(sp)
    80001706:	6125                	addi	sp,sp,96
    80001708:	8082                	ret
        return -1;
    8000170a:	557d                	li	a0,-1
    8000170c:	b7cd                	j	800016ee <copyout+0x9a>
      return -1;
    8000170e:	557d                	li	a0,-1
    80001710:	bff9                	j	800016ee <copyout+0x9a>

0000000080001712 <copyin>:
  while(len > 0){
    80001712:	c6c9                	beqz	a3,8000179c <copyin+0x8a>
{
    80001714:	715d                	addi	sp,sp,-80
    80001716:	e486                	sd	ra,72(sp)
    80001718:	e0a2                	sd	s0,64(sp)
    8000171a:	fc26                	sd	s1,56(sp)
    8000171c:	f84a                	sd	s2,48(sp)
    8000171e:	f44e                	sd	s3,40(sp)
    80001720:	f052                	sd	s4,32(sp)
    80001722:	ec56                	sd	s5,24(sp)
    80001724:	e85a                	sd	s6,16(sp)
    80001726:	e45e                	sd	s7,8(sp)
    80001728:	e062                	sd	s8,0(sp)
    8000172a:	0880                	addi	s0,sp,80
    8000172c:	8baa                	mv	s7,a0
    8000172e:	8aae                	mv	s5,a1
    80001730:	8932                	mv	s2,a2
    80001732:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001734:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001736:	6b05                	lui	s6,0x1
    80001738:	a035                	j	80001764 <copyin+0x52>
    8000173a:	412984b3          	sub	s1,s3,s2
    8000173e:	94da                	add	s1,s1,s6
    if(n > len)
    80001740:	009a7363          	bgeu	s4,s1,80001746 <copyin+0x34>
    80001744:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001746:	413905b3          	sub	a1,s2,s3
    8000174a:	0004861b          	sext.w	a2,s1
    8000174e:	95aa                	add	a1,a1,a0
    80001750:	8556                	mv	a0,s5
    80001752:	e06ff0ef          	jal	80000d58 <memmove>
    len -= n;
    80001756:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000175a:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000175c:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001760:	020a0163          	beqz	s4,80001782 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001764:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001768:	85ce                	mv	a1,s3
    8000176a:	855e                	mv	a0,s7
    8000176c:	8bbff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0) {
    80001770:	f569                	bnez	a0,8000173a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001772:	4601                	li	a2,0
    80001774:	85ce                	mv	a1,s3
    80001776:	855e                	mv	a0,s7
    80001778:	e59ff0ef          	jal	800015d0 <vmfault>
    8000177c:	fd5d                	bnez	a0,8000173a <copyin+0x28>
        return -1;
    8000177e:	557d                	li	a0,-1
    80001780:	a011                	j	80001784 <copyin+0x72>
  return 0;
    80001782:	4501                	li	a0,0
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6c02                	ld	s8,0(sp)
    80001798:	6161                	addi	sp,sp,80
    8000179a:	8082                	ret
  return 0;
    8000179c:	4501                	li	a0,0
}
    8000179e:	8082                	ret

00000000800017a0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017a0:	715d                	addi	sp,sp,-80
    800017a2:	e486                	sd	ra,72(sp)
    800017a4:	e0a2                	sd	s0,64(sp)
    800017a6:	fc26                	sd	s1,56(sp)
    800017a8:	f84a                	sd	s2,48(sp)
    800017aa:	f44e                	sd	s3,40(sp)
    800017ac:	f052                	sd	s4,32(sp)
    800017ae:	ec56                	sd	s5,24(sp)
    800017b0:	e85a                	sd	s6,16(sp)
    800017b2:	e45e                	sd	s7,8(sp)
    800017b4:	e062                	sd	s8,0(sp)
    800017b6:	0880                	addi	s0,sp,80
    800017b8:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ba:	0000e497          	auipc	s1,0xe
    800017be:	5ce48493          	addi	s1,s1,1486 # 8000fd88 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017c2:	8c26                	mv	s8,s1
    800017c4:	000a57b7          	lui	a5,0xa5
    800017c8:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    800017cc:	07b2                	slli	a5,a5,0xc
    800017ce:	fa578793          	addi	a5,a5,-91
    800017d2:	4fa50937          	lui	s2,0x4fa50
    800017d6:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    800017da:	1902                	slli	s2,s2,0x20
    800017dc:	993e                	add	s2,s2,a5
    800017de:	040009b7          	lui	s3,0x4000
    800017e2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017e4:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e6:	4b99                	li	s7,6
    800017e8:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ea:	00014a97          	auipc	s5,0x14
    800017ee:	f9ea8a93          	addi	s5,s5,-98 # 80015788 <tickslock>
    char *pa = kalloc();
    800017f2:	b52ff0ef          	jal	80000b44 <kalloc>
    800017f6:	862a                	mv	a2,a0
    if(pa == 0)
    800017f8:	c121                	beqz	a0,80001838 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    800017fa:	418485b3          	sub	a1,s1,s8
    800017fe:	858d                	srai	a1,a1,0x3
    80001800:	032585b3          	mul	a1,a1,s2
    80001804:	05b6                	slli	a1,a1,0xd
    80001806:	6789                	lui	a5,0x2
    80001808:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000180a:	875e                	mv	a4,s7
    8000180c:	86da                	mv	a3,s6
    8000180e:	40b985b3          	sub	a1,s3,a1
    80001812:	8552                	mv	a0,s4
    80001814:	903ff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001818:	16848493          	addi	s1,s1,360
    8000181c:	fd549be3          	bne	s1,s5,800017f2 <proc_mapstacks+0x52>
  }
}
    80001820:	60a6                	ld	ra,72(sp)
    80001822:	6406                	ld	s0,64(sp)
    80001824:	74e2                	ld	s1,56(sp)
    80001826:	7942                	ld	s2,48(sp)
    80001828:	79a2                	ld	s3,40(sp)
    8000182a:	7a02                	ld	s4,32(sp)
    8000182c:	6ae2                	ld	s5,24(sp)
    8000182e:	6b42                	ld	s6,16(sp)
    80001830:	6ba2                	ld	s7,8(sp)
    80001832:	6c02                	ld	s8,0(sp)
    80001834:	6161                	addi	sp,sp,80
    80001836:	8082                	ret
      panic("kalloc");
    80001838:	00006517          	auipc	a0,0x6
    8000183c:	92050513          	addi	a0,a0,-1760 # 80007158 <etext+0x158>
    80001840:	fe5fe0ef          	jal	80000824 <panic>

0000000080001844 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001844:	7139                	addi	sp,sp,-64
    80001846:	fc06                	sd	ra,56(sp)
    80001848:	f822                	sd	s0,48(sp)
    8000184a:	f426                	sd	s1,40(sp)
    8000184c:	f04a                	sd	s2,32(sp)
    8000184e:	ec4e                	sd	s3,24(sp)
    80001850:	e852                	sd	s4,16(sp)
    80001852:	e456                	sd	s5,8(sp)
    80001854:	e05a                	sd	s6,0(sp)
    80001856:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001858:	00006597          	auipc	a1,0x6
    8000185c:	90858593          	addi	a1,a1,-1784 # 80007160 <etext+0x160>
    80001860:	0000e517          	auipc	a0,0xe
    80001864:	0f850513          	addi	a0,a0,248 # 8000f958 <pid_lock>
    80001868:	b36ff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000186c:	00006597          	auipc	a1,0x6
    80001870:	8fc58593          	addi	a1,a1,-1796 # 80007168 <etext+0x168>
    80001874:	0000e517          	auipc	a0,0xe
    80001878:	0fc50513          	addi	a0,a0,252 # 8000f970 <wait_lock>
    8000187c:	b22ff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001880:	0000e497          	auipc	s1,0xe
    80001884:	50848493          	addi	s1,s1,1288 # 8000fd88 <proc>
      initlock(&p->lock, "proc");
    80001888:	00006b17          	auipc	s6,0x6
    8000188c:	8f0b0b13          	addi	s6,s6,-1808 # 80007178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001890:	8aa6                	mv	s5,s1
    80001892:	000a57b7          	lui	a5,0xa5
    80001896:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    8000189a:	07b2                	slli	a5,a5,0xc
    8000189c:	fa578793          	addi	a5,a5,-91
    800018a0:	4fa50937          	lui	s2,0x4fa50
    800018a4:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    800018a8:	1902                	slli	s2,s2,0x20
    800018aa:	993e                	add	s2,s2,a5
    800018ac:	040009b7          	lui	s3,0x4000
    800018b0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018b2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b4:	00014a17          	auipc	s4,0x14
    800018b8:	ed4a0a13          	addi	s4,s4,-300 # 80015788 <tickslock>
      initlock(&p->lock, "proc");
    800018bc:	85da                	mv	a1,s6
    800018be:	8526                	mv	a0,s1
    800018c0:	adeff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    800018c4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018c8:	415487b3          	sub	a5,s1,s5
    800018cc:	878d                	srai	a5,a5,0x3
    800018ce:	032787b3          	mul	a5,a5,s2
    800018d2:	07b6                	slli	a5,a5,0xd
    800018d4:	6709                	lui	a4,0x2
    800018d6:	9fb9                	addw	a5,a5,a4
    800018d8:	40f987b3          	sub	a5,s3,a5
    800018dc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018de:	16848493          	addi	s1,s1,360
    800018e2:	fd449de3          	bne	s1,s4,800018bc <procinit+0x78>
  }
}
    800018e6:	70e2                	ld	ra,56(sp)
    800018e8:	7442                	ld	s0,48(sp)
    800018ea:	74a2                	ld	s1,40(sp)
    800018ec:	7902                	ld	s2,32(sp)
    800018ee:	69e2                	ld	s3,24(sp)
    800018f0:	6a42                	ld	s4,16(sp)
    800018f2:	6aa2                	ld	s5,8(sp)
    800018f4:	6b02                	ld	s6,0(sp)
    800018f6:	6121                	addi	sp,sp,64
    800018f8:	8082                	ret

00000000800018fa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018fa:	1141                	addi	sp,sp,-16
    800018fc:	e406                	sd	ra,8(sp)
    800018fe:	e022                	sd	s0,0(sp)
    80001900:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001902:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001904:	2501                	sext.w	a0,a0
    80001906:	60a2                	ld	ra,8(sp)
    80001908:	6402                	ld	s0,0(sp)
    8000190a:	0141                	addi	sp,sp,16
    8000190c:	8082                	ret

000000008000190e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000190e:	1141                	addi	sp,sp,-16
    80001910:	e406                	sd	ra,8(sp)
    80001912:	e022                	sd	s0,0(sp)
    80001914:	0800                	addi	s0,sp,16
    80001916:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001918:	2781                	sext.w	a5,a5
    8000191a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000191c:	0000e517          	auipc	a0,0xe
    80001920:	06c50513          	addi	a0,a0,108 # 8000f988 <cpus>
    80001924:	953e                	add	a0,a0,a5
    80001926:	60a2                	ld	ra,8(sp)
    80001928:	6402                	ld	s0,0(sp)
    8000192a:	0141                	addi	sp,sp,16
    8000192c:	8082                	ret

000000008000192e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000192e:	1101                	addi	sp,sp,-32
    80001930:	ec06                	sd	ra,24(sp)
    80001932:	e822                	sd	s0,16(sp)
    80001934:	e426                	sd	s1,8(sp)
    80001936:	1000                	addi	s0,sp,32
  push_off();
    80001938:	aacff0ef          	jal	80000be4 <push_off>
    8000193c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000193e:	2781                	sext.w	a5,a5
    80001940:	079e                	slli	a5,a5,0x7
    80001942:	0000e717          	auipc	a4,0xe
    80001946:	01670713          	addi	a4,a4,22 # 8000f958 <pid_lock>
    8000194a:	97ba                	add	a5,a5,a4
    8000194c:	7b9c                	ld	a5,48(a5)
    8000194e:	84be                	mv	s1,a5
  pop_off();
    80001950:	b1cff0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001954:	8526                	mv	a0,s1
    80001956:	60e2                	ld	ra,24(sp)
    80001958:	6442                	ld	s0,16(sp)
    8000195a:	64a2                	ld	s1,8(sp)
    8000195c:	6105                	addi	sp,sp,32
    8000195e:	8082                	ret

0000000080001960 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001960:	7179                	addi	sp,sp,-48
    80001962:	f406                	sd	ra,40(sp)
    80001964:	f022                	sd	s0,32(sp)
    80001966:	ec26                	sd	s1,24(sp)
    80001968:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000196a:	fc5ff0ef          	jal	8000192e <myproc>
    8000196e:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001970:	b4cff0ef          	jal	80000cbc <release>

  if (first) {
    80001974:	00006797          	auipc	a5,0x6
    80001978:	eac7a783          	lw	a5,-340(a5) # 80007820 <first.1>
    8000197c:	cf95                	beqz	a5,800019b8 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000197e:	4505                	li	a0,1
    80001980:	36b010ef          	jal	800034ea <fsinit>

    first = 0;
    80001984:	00006797          	auipc	a5,0x6
    80001988:	e807ae23          	sw	zero,-356(a5) # 80007820 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000198c:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001990:	00005797          	auipc	a5,0x5
    80001994:	7f078793          	addi	a5,a5,2032 # 80007180 <etext+0x180>
    80001998:	fcf43823          	sd	a5,-48(s0)
    8000199c:	fc043c23          	sd	zero,-40(s0)
    800019a0:	fd040593          	addi	a1,s0,-48
    800019a4:	853e                	mv	a0,a5
    800019a6:	4c3020ef          	jal	80004668 <kexec>
    800019aa:	6cbc                	ld	a5,88(s1)
    800019ac:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800019ae:	6cbc                	ld	a5,88(s1)
    800019b0:	7bb8                	ld	a4,112(a5)
    800019b2:	57fd                	li	a5,-1
    800019b4:	02f70d63          	beq	a4,a5,800019ee <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019b8:	2b1000ef          	jal	80002468 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019bc:	68a8                	ld	a0,80(s1)
    800019be:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019c0:	04000737          	lui	a4,0x4000
    800019c4:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019c6:	0732                	slli	a4,a4,0xc
    800019c8:	00004797          	auipc	a5,0x4
    800019cc:	6d478793          	addi	a5,a5,1748 # 8000609c <userret>
    800019d0:	00004697          	auipc	a3,0x4
    800019d4:	63068693          	addi	a3,a3,1584 # 80006000 <_trampoline>
    800019d8:	8f95                	sub	a5,a5,a3
    800019da:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019dc:	577d                	li	a4,-1
    800019de:	177e                	slli	a4,a4,0x3f
    800019e0:	8d59                	or	a0,a0,a4
    800019e2:	9782                	jalr	a5
}
    800019e4:	70a2                	ld	ra,40(sp)
    800019e6:	7402                	ld	s0,32(sp)
    800019e8:	64e2                	ld	s1,24(sp)
    800019ea:	6145                	addi	sp,sp,48
    800019ec:	8082                	ret
      panic("exec");
    800019ee:	00005517          	auipc	a0,0x5
    800019f2:	79a50513          	addi	a0,a0,1946 # 80007188 <etext+0x188>
    800019f6:	e2ffe0ef          	jal	80000824 <panic>

00000000800019fa <allocpid>:
{
    800019fa:	1101                	addi	sp,sp,-32
    800019fc:	ec06                	sd	ra,24(sp)
    800019fe:	e822                	sd	s0,16(sp)
    80001a00:	e426                	sd	s1,8(sp)
    80001a02:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a04:	0000e517          	auipc	a0,0xe
    80001a08:	f5450513          	addi	a0,a0,-172 # 8000f958 <pid_lock>
    80001a0c:	a1cff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80001a10:	00006797          	auipc	a5,0x6
    80001a14:	e1478793          	addi	a5,a5,-492 # 80007824 <nextpid>
    80001a18:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a1a:	0014871b          	addiw	a4,s1,1
    80001a1e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a20:	0000e517          	auipc	a0,0xe
    80001a24:	f3850513          	addi	a0,a0,-200 # 8000f958 <pid_lock>
    80001a28:	a94ff0ef          	jal	80000cbc <release>
}
    80001a2c:	8526                	mv	a0,s1
    80001a2e:	60e2                	ld	ra,24(sp)
    80001a30:	6442                	ld	s0,16(sp)
    80001a32:	64a2                	ld	s1,8(sp)
    80001a34:	6105                	addi	sp,sp,32
    80001a36:	8082                	ret

0000000080001a38 <proc_pagetable>:
{
    80001a38:	1101                	addi	sp,sp,-32
    80001a3a:	ec06                	sd	ra,24(sp)
    80001a3c:	e822                	sd	s0,16(sp)
    80001a3e:	e426                	sd	s1,8(sp)
    80001a40:	e04a                	sd	s2,0(sp)
    80001a42:	1000                	addi	s0,sp,32
    80001a44:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a46:	fc2ff0ef          	jal	80001208 <uvmcreate>
    80001a4a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a4c:	cd05                	beqz	a0,80001a84 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a4e:	4729                	li	a4,10
    80001a50:	00004697          	auipc	a3,0x4
    80001a54:	5b068693          	addi	a3,a3,1456 # 80006000 <_trampoline>
    80001a58:	6605                	lui	a2,0x1
    80001a5a:	040005b7          	lui	a1,0x4000
    80001a5e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a60:	05b2                	slli	a1,a1,0xc
    80001a62:	dfeff0ef          	jal	80001060 <mappages>
    80001a66:	02054663          	bltz	a0,80001a92 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a6a:	4719                	li	a4,6
    80001a6c:	05893683          	ld	a3,88(s2)
    80001a70:	6605                	lui	a2,0x1
    80001a72:	020005b7          	lui	a1,0x2000
    80001a76:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a78:	05b6                	slli	a1,a1,0xd
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	de4ff0ef          	jal	80001060 <mappages>
    80001a80:	00054f63          	bltz	a0,80001a9e <proc_pagetable+0x66>
}
    80001a84:	8526                	mv	a0,s1
    80001a86:	60e2                	ld	ra,24(sp)
    80001a88:	6442                	ld	s0,16(sp)
    80001a8a:	64a2                	ld	s1,8(sp)
    80001a8c:	6902                	ld	s2,0(sp)
    80001a8e:	6105                	addi	sp,sp,32
    80001a90:	8082                	ret
    uvmfree(pagetable, 0);
    80001a92:	4581                	li	a1,0
    80001a94:	8526                	mv	a0,s1
    80001a96:	96dff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001a9a:	4481                	li	s1,0
    80001a9c:	b7e5                	j	80001a84 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a9e:	4681                	li	a3,0
    80001aa0:	4605                	li	a2,1
    80001aa2:	040005b7          	lui	a1,0x4000
    80001aa6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aa8:	05b2                	slli	a1,a1,0xc
    80001aaa:	8526                	mv	a0,s1
    80001aac:	f82ff0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    80001ab0:	4581                	li	a1,0
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	94fff0ef          	jal	80001402 <uvmfree>
    return 0;
    80001ab8:	4481                	li	s1,0
    80001aba:	b7e9                	j	80001a84 <proc_pagetable+0x4c>

0000000080001abc <proc_freepagetable>:
{
    80001abc:	1101                	addi	sp,sp,-32
    80001abe:	ec06                	sd	ra,24(sp)
    80001ac0:	e822                	sd	s0,16(sp)
    80001ac2:	e426                	sd	s1,8(sp)
    80001ac4:	e04a                	sd	s2,0(sp)
    80001ac6:	1000                	addi	s0,sp,32
    80001ac8:	84aa                	mv	s1,a0
    80001aca:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001acc:	4681                	li	a3,0
    80001ace:	4605                	li	a2,1
    80001ad0:	040005b7          	lui	a1,0x4000
    80001ad4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ad6:	05b2                	slli	a1,a1,0xc
    80001ad8:	f56ff0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001adc:	4681                	li	a3,0
    80001ade:	4605                	li	a2,1
    80001ae0:	020005b7          	lui	a1,0x2000
    80001ae4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ae6:	05b6                	slli	a1,a1,0xd
    80001ae8:	8526                	mv	a0,s1
    80001aea:	f44ff0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    80001aee:	85ca                	mv	a1,s2
    80001af0:	8526                	mv	a0,s1
    80001af2:	911ff0ef          	jal	80001402 <uvmfree>
}
    80001af6:	60e2                	ld	ra,24(sp)
    80001af8:	6442                	ld	s0,16(sp)
    80001afa:	64a2                	ld	s1,8(sp)
    80001afc:	6902                	ld	s2,0(sp)
    80001afe:	6105                	addi	sp,sp,32
    80001b00:	8082                	ret

0000000080001b02 <freeproc>:
{
    80001b02:	1101                	addi	sp,sp,-32
    80001b04:	ec06                	sd	ra,24(sp)
    80001b06:	e822                	sd	s0,16(sp)
    80001b08:	e426                	sd	s1,8(sp)
    80001b0a:	1000                	addi	s0,sp,32
    80001b0c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b0e:	6d28                	ld	a0,88(a0)
    80001b10:	c119                	beqz	a0,80001b16 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001b12:	f4bfe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001b16:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b1a:	68a8                	ld	a0,80(s1)
    80001b1c:	c501                	beqz	a0,80001b24 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b1e:	64ac                	ld	a1,72(s1)
    80001b20:	f9dff0ef          	jal	80001abc <proc_freepagetable>
  p->pagetable = 0;
    80001b24:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b28:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b2c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b30:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b34:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b38:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b3c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b40:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b44:	0004ac23          	sw	zero,24(s1)
}
    80001b48:	60e2                	ld	ra,24(sp)
    80001b4a:	6442                	ld	s0,16(sp)
    80001b4c:	64a2                	ld	s1,8(sp)
    80001b4e:	6105                	addi	sp,sp,32
    80001b50:	8082                	ret

0000000080001b52 <allocproc>:
{
    80001b52:	1101                	addi	sp,sp,-32
    80001b54:	ec06                	sd	ra,24(sp)
    80001b56:	e822                	sd	s0,16(sp)
    80001b58:	e426                	sd	s1,8(sp)
    80001b5a:	e04a                	sd	s2,0(sp)
    80001b5c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b5e:	0000e497          	auipc	s1,0xe
    80001b62:	22a48493          	addi	s1,s1,554 # 8000fd88 <proc>
    80001b66:	00014917          	auipc	s2,0x14
    80001b6a:	c2290913          	addi	s2,s2,-990 # 80015788 <tickslock>
    acquire(&p->lock);
    80001b6e:	8526                	mv	a0,s1
    80001b70:	8b8ff0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001b74:	4c9c                	lw	a5,24(s1)
    80001b76:	cb91                	beqz	a5,80001b8a <allocproc+0x38>
      release(&p->lock);
    80001b78:	8526                	mv	a0,s1
    80001b7a:	942ff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b7e:	16848493          	addi	s1,s1,360
    80001b82:	ff2496e3          	bne	s1,s2,80001b6e <allocproc+0x1c>
  return 0;
    80001b86:	4481                	li	s1,0
    80001b88:	a089                	j	80001bca <allocproc+0x78>
  p->pid = allocpid();
    80001b8a:	e71ff0ef          	jal	800019fa <allocpid>
    80001b8e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b90:	4785                	li	a5,1
    80001b92:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b94:	fb1fe0ef          	jal	80000b44 <kalloc>
    80001b98:	892a                	mv	s2,a0
    80001b9a:	eca8                	sd	a0,88(s1)
    80001b9c:	cd15                	beqz	a0,80001bd8 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	e99ff0ef          	jal	80001a38 <proc_pagetable>
    80001ba4:	892a                	mv	s2,a0
    80001ba6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001ba8:	c121                	beqz	a0,80001be8 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001baa:	07000613          	li	a2,112
    80001bae:	4581                	li	a1,0
    80001bb0:	06048513          	addi	a0,s1,96
    80001bb4:	944ff0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001bb8:	00000797          	auipc	a5,0x0
    80001bbc:	da878793          	addi	a5,a5,-600 # 80001960 <forkret>
    80001bc0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bc2:	60bc                	ld	a5,64(s1)
    80001bc4:	6705                	lui	a4,0x1
    80001bc6:	97ba                	add	a5,a5,a4
    80001bc8:	f4bc                	sd	a5,104(s1)
}
    80001bca:	8526                	mv	a0,s1
    80001bcc:	60e2                	ld	ra,24(sp)
    80001bce:	6442                	ld	s0,16(sp)
    80001bd0:	64a2                	ld	s1,8(sp)
    80001bd2:	6902                	ld	s2,0(sp)
    80001bd4:	6105                	addi	sp,sp,32
    80001bd6:	8082                	ret
    freeproc(p);
    80001bd8:	8526                	mv	a0,s1
    80001bda:	f29ff0ef          	jal	80001b02 <freeproc>
    release(&p->lock);
    80001bde:	8526                	mv	a0,s1
    80001be0:	8dcff0ef          	jal	80000cbc <release>
    return 0;
    80001be4:	84ca                	mv	s1,s2
    80001be6:	b7d5                	j	80001bca <allocproc+0x78>
    freeproc(p);
    80001be8:	8526                	mv	a0,s1
    80001bea:	f19ff0ef          	jal	80001b02 <freeproc>
    release(&p->lock);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	8ccff0ef          	jal	80000cbc <release>
    return 0;
    80001bf4:	84ca                	mv	s1,s2
    80001bf6:	bfd1                	j	80001bca <allocproc+0x78>

0000000080001bf8 <userinit>:
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c02:	f51ff0ef          	jal	80001b52 <allocproc>
    80001c06:	84aa                	mv	s1,a0
  initproc = p;
    80001c08:	00006797          	auipc	a5,0x6
    80001c0c:	c4a7b423          	sd	a0,-952(a5) # 80007850 <initproc>
  p->cwd = namei("/");
    80001c10:	00005517          	auipc	a0,0x5
    80001c14:	58050513          	addi	a0,a0,1408 # 80007190 <etext+0x190>
    80001c18:	60d010ef          	jal	80003a24 <namei>
    80001c1c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c20:	478d                	li	a5,3
    80001c22:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c24:	8526                	mv	a0,s1
    80001c26:	896ff0ef          	jal	80000cbc <release>
}
    80001c2a:	60e2                	ld	ra,24(sp)
    80001c2c:	6442                	ld	s0,16(sp)
    80001c2e:	64a2                	ld	s1,8(sp)
    80001c30:	6105                	addi	sp,sp,32
    80001c32:	8082                	ret

0000000080001c34 <growproc>:
{
    80001c34:	1101                	addi	sp,sp,-32
    80001c36:	ec06                	sd	ra,24(sp)
    80001c38:	e822                	sd	s0,16(sp)
    80001c3a:	e426                	sd	s1,8(sp)
    80001c3c:	e04a                	sd	s2,0(sp)
    80001c3e:	1000                	addi	s0,sp,32
    80001c40:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001c42:	cedff0ef          	jal	8000192e <myproc>
    80001c46:	84aa                	mv	s1,a0
  sz = p->sz;
    80001c48:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c4a:	01204c63          	bgtz	s2,80001c62 <growproc+0x2e>
  } else if(n < 0){
    80001c4e:	02094463          	bltz	s2,80001c76 <growproc+0x42>
  p->sz = sz;
    80001c52:	e4ac                	sd	a1,72(s1)
  return 0;
    80001c54:	4501                	li	a0,0
}
    80001c56:	60e2                	ld	ra,24(sp)
    80001c58:	6442                	ld	s0,16(sp)
    80001c5a:	64a2                	ld	s1,8(sp)
    80001c5c:	6902                	ld	s2,0(sp)
    80001c5e:	6105                	addi	sp,sp,32
    80001c60:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c62:	4691                	li	a3,4
    80001c64:	00b90633          	add	a2,s2,a1
    80001c68:	6928                	ld	a0,80(a0)
    80001c6a:	e92ff0ef          	jal	800012fc <uvmalloc>
    80001c6e:	85aa                	mv	a1,a0
    80001c70:	f16d                	bnez	a0,80001c52 <growproc+0x1e>
      return -1;
    80001c72:	557d                	li	a0,-1
    80001c74:	b7cd                	j	80001c56 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c76:	00b90633          	add	a2,s2,a1
    80001c7a:	6928                	ld	a0,80(a0)
    80001c7c:	e3cff0ef          	jal	800012b8 <uvmdealloc>
    80001c80:	85aa                	mv	a1,a0
    80001c82:	bfc1                	j	80001c52 <growproc+0x1e>

0000000080001c84 <kfork>:
{
    80001c84:	7139                	addi	sp,sp,-64
    80001c86:	fc06                	sd	ra,56(sp)
    80001c88:	f822                	sd	s0,48(sp)
    80001c8a:	f426                	sd	s1,40(sp)
    80001c8c:	e456                	sd	s5,8(sp)
    80001c8e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c90:	c9fff0ef          	jal	8000192e <myproc>
    80001c94:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c96:	ebdff0ef          	jal	80001b52 <allocproc>
    80001c9a:	0e050a63          	beqz	a0,80001d8e <kfork+0x10a>
    80001c9e:	e852                	sd	s4,16(sp)
    80001ca0:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ca2:	048ab603          	ld	a2,72(s5)
    80001ca6:	692c                	ld	a1,80(a0)
    80001ca8:	050ab503          	ld	a0,80(s5)
    80001cac:	f88ff0ef          	jal	80001434 <uvmcopy>
    80001cb0:	04054863          	bltz	a0,80001d00 <kfork+0x7c>
    80001cb4:	f04a                	sd	s2,32(sp)
    80001cb6:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cb8:	048ab783          	ld	a5,72(s5)
    80001cbc:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cc0:	058ab683          	ld	a3,88(s5)
    80001cc4:	87b6                	mv	a5,a3
    80001cc6:	058a3703          	ld	a4,88(s4)
    80001cca:	12068693          	addi	a3,a3,288
    80001cce:	6388                	ld	a0,0(a5)
    80001cd0:	678c                	ld	a1,8(a5)
    80001cd2:	6b90                	ld	a2,16(a5)
    80001cd4:	e308                	sd	a0,0(a4)
    80001cd6:	e70c                	sd	a1,8(a4)
    80001cd8:	eb10                	sd	a2,16(a4)
    80001cda:	6f90                	ld	a2,24(a5)
    80001cdc:	ef10                	sd	a2,24(a4)
    80001cde:	02078793          	addi	a5,a5,32
    80001ce2:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001ce6:	fed794e3          	bne	a5,a3,80001cce <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001cea:	058a3783          	ld	a5,88(s4)
    80001cee:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001cf2:	0d0a8493          	addi	s1,s5,208
    80001cf6:	0d0a0913          	addi	s2,s4,208
    80001cfa:	150a8993          	addi	s3,s5,336
    80001cfe:	a831                	j	80001d1a <kfork+0x96>
    freeproc(np);
    80001d00:	8552                	mv	a0,s4
    80001d02:	e01ff0ef          	jal	80001b02 <freeproc>
    release(&np->lock);
    80001d06:	8552                	mv	a0,s4
    80001d08:	fb5fe0ef          	jal	80000cbc <release>
    return -1;
    80001d0c:	54fd                	li	s1,-1
    80001d0e:	6a42                	ld	s4,16(sp)
    80001d10:	a885                	j	80001d80 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001d12:	04a1                	addi	s1,s1,8
    80001d14:	0921                	addi	s2,s2,8
    80001d16:	01348963          	beq	s1,s3,80001d28 <kfork+0xa4>
    if(p->ofile[i])
    80001d1a:	6088                	ld	a0,0(s1)
    80001d1c:	d97d                	beqz	a0,80001d12 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d1e:	2c2020ef          	jal	80003fe0 <filedup>
    80001d22:	00a93023          	sd	a0,0(s2)
    80001d26:	b7f5                	j	80001d12 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001d28:	150ab503          	ld	a0,336(s5)
    80001d2c:	494010ef          	jal	800031c0 <idup>
    80001d30:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d34:	4641                	li	a2,16
    80001d36:	158a8593          	addi	a1,s5,344
    80001d3a:	158a0513          	addi	a0,s4,344
    80001d3e:	90eff0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001d42:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001d46:	8552                	mv	a0,s4
    80001d48:	f75fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001d4c:	0000e517          	auipc	a0,0xe
    80001d50:	c2450513          	addi	a0,a0,-988 # 8000f970 <wait_lock>
    80001d54:	ed5fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80001d58:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d5c:	0000e517          	auipc	a0,0xe
    80001d60:	c1450513          	addi	a0,a0,-1004 # 8000f970 <wait_lock>
    80001d64:	f59fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001d68:	8552                	mv	a0,s4
    80001d6a:	ebffe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80001d6e:	478d                	li	a5,3
    80001d70:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d74:	8552                	mv	a0,s4
    80001d76:	f47fe0ef          	jal	80000cbc <release>
  return pid;
    80001d7a:	7902                	ld	s2,32(sp)
    80001d7c:	69e2                	ld	s3,24(sp)
    80001d7e:	6a42                	ld	s4,16(sp)
}
    80001d80:	8526                	mv	a0,s1
    80001d82:	70e2                	ld	ra,56(sp)
    80001d84:	7442                	ld	s0,48(sp)
    80001d86:	74a2                	ld	s1,40(sp)
    80001d88:	6aa2                	ld	s5,8(sp)
    80001d8a:	6121                	addi	sp,sp,64
    80001d8c:	8082                	ret
    return -1;
    80001d8e:	54fd                	li	s1,-1
    80001d90:	bfc5                	j	80001d80 <kfork+0xfc>

0000000080001d92 <scheduler>:
{
    80001d92:	715d                	addi	sp,sp,-80
    80001d94:	e486                	sd	ra,72(sp)
    80001d96:	e0a2                	sd	s0,64(sp)
    80001d98:	fc26                	sd	s1,56(sp)
    80001d9a:	f84a                	sd	s2,48(sp)
    80001d9c:	f44e                	sd	s3,40(sp)
    80001d9e:	f052                	sd	s4,32(sp)
    80001da0:	ec56                	sd	s5,24(sp)
    80001da2:	e85a                	sd	s6,16(sp)
    80001da4:	e45e                	sd	s7,8(sp)
    80001da6:	e062                	sd	s8,0(sp)
    80001da8:	0880                	addi	s0,sp,80
    80001daa:	8792                	mv	a5,tp
  int id = r_tp();
    80001dac:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001dae:	00779b13          	slli	s6,a5,0x7
    80001db2:	0000e717          	auipc	a4,0xe
    80001db6:	ba670713          	addi	a4,a4,-1114 # 8000f958 <pid_lock>
    80001dba:	975a                	add	a4,a4,s6
    80001dbc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001dc0:	0000e717          	auipc	a4,0xe
    80001dc4:	bd070713          	addi	a4,a4,-1072 # 8000f990 <cpus+0x8>
    80001dc8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001dca:	4c11                	li	s8,4
        c->proc = p;
    80001dcc:	079e                	slli	a5,a5,0x7
    80001dce:	0000ea17          	auipc	s4,0xe
    80001dd2:	b8aa0a13          	addi	s4,s4,-1142 # 8000f958 <pid_lock>
    80001dd6:	9a3e                	add	s4,s4,a5
        found = 1;
    80001dd8:	4b85                	li	s7,1
    80001dda:	a83d                	j	80001e18 <scheduler+0x86>
      release(&p->lock);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	edffe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001de2:	16848493          	addi	s1,s1,360
    80001de6:	03248563          	beq	s1,s2,80001e10 <scheduler+0x7e>
      acquire(&p->lock);
    80001dea:	8526                	mv	a0,s1
    80001dec:	e3dfe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    80001df0:	4c9c                	lw	a5,24(s1)
    80001df2:	ff3795e3          	bne	a5,s3,80001ddc <scheduler+0x4a>
        p->state = RUNNING;
    80001df6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dfa:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001dfe:	06048593          	addi	a1,s1,96
    80001e02:	855a                	mv	a0,s6
    80001e04:	5ba000ef          	jal	800023be <swtch>
        c->proc = 0;
    80001e08:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e0c:	8ade                	mv	s5,s7
    80001e0e:	b7f9                	j	80001ddc <scheduler+0x4a>
    if(found == 0) {
    80001e10:	000a9463          	bnez	s5,80001e18 <scheduler+0x86>
      asm volatile("wfi");
    80001e14:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e1c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e20:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2a:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e2e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e30:	0000e497          	auipc	s1,0xe
    80001e34:	f5848493          	addi	s1,s1,-168 # 8000fd88 <proc>
      if(p->state == RUNNABLE) {
    80001e38:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e3a:	00014917          	auipc	s2,0x14
    80001e3e:	94e90913          	addi	s2,s2,-1714 # 80015788 <tickslock>
    80001e42:	b765                	j	80001dea <scheduler+0x58>

0000000080001e44 <sched>:
{
    80001e44:	7179                	addi	sp,sp,-48
    80001e46:	f406                	sd	ra,40(sp)
    80001e48:	f022                	sd	s0,32(sp)
    80001e4a:	ec26                	sd	s1,24(sp)
    80001e4c:	e84a                	sd	s2,16(sp)
    80001e4e:	e44e                	sd	s3,8(sp)
    80001e50:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e52:	addff0ef          	jal	8000192e <myproc>
    80001e56:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e58:	d61fe0ef          	jal	80000bb8 <holding>
    80001e5c:	c935                	beqz	a0,80001ed0 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e5e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e60:	2781                	sext.w	a5,a5
    80001e62:	079e                	slli	a5,a5,0x7
    80001e64:	0000e717          	auipc	a4,0xe
    80001e68:	af470713          	addi	a4,a4,-1292 # 8000f958 <pid_lock>
    80001e6c:	97ba                	add	a5,a5,a4
    80001e6e:	0a87a703          	lw	a4,168(a5)
    80001e72:	4785                	li	a5,1
    80001e74:	06f71463          	bne	a4,a5,80001edc <sched+0x98>
  if(p->state == RUNNING)
    80001e78:	4c98                	lw	a4,24(s1)
    80001e7a:	4791                	li	a5,4
    80001e7c:	06f70663          	beq	a4,a5,80001ee8 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e80:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e84:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e86:	e7bd                	bnez	a5,80001ef4 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e88:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e8a:	0000e917          	auipc	s2,0xe
    80001e8e:	ace90913          	addi	s2,s2,-1330 # 8000f958 <pid_lock>
    80001e92:	2781                	sext.w	a5,a5
    80001e94:	079e                	slli	a5,a5,0x7
    80001e96:	97ca                	add	a5,a5,s2
    80001e98:	0ac7a983          	lw	s3,172(a5)
    80001e9c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e9e:	2781                	sext.w	a5,a5
    80001ea0:	079e                	slli	a5,a5,0x7
    80001ea2:	07a1                	addi	a5,a5,8
    80001ea4:	0000e597          	auipc	a1,0xe
    80001ea8:	ae458593          	addi	a1,a1,-1308 # 8000f988 <cpus>
    80001eac:	95be                	add	a1,a1,a5
    80001eae:	06048513          	addi	a0,s1,96
    80001eb2:	50c000ef          	jal	800023be <swtch>
    80001eb6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001eb8:	2781                	sext.w	a5,a5
    80001eba:	079e                	slli	a5,a5,0x7
    80001ebc:	993e                	add	s2,s2,a5
    80001ebe:	0b392623          	sw	s3,172(s2)
}
    80001ec2:	70a2                	ld	ra,40(sp)
    80001ec4:	7402                	ld	s0,32(sp)
    80001ec6:	64e2                	ld	s1,24(sp)
    80001ec8:	6942                	ld	s2,16(sp)
    80001eca:	69a2                	ld	s3,8(sp)
    80001ecc:	6145                	addi	sp,sp,48
    80001ece:	8082                	ret
    panic("sched p->lock");
    80001ed0:	00005517          	auipc	a0,0x5
    80001ed4:	2c850513          	addi	a0,a0,712 # 80007198 <etext+0x198>
    80001ed8:	94dfe0ef          	jal	80000824 <panic>
    panic("sched locks");
    80001edc:	00005517          	auipc	a0,0x5
    80001ee0:	2cc50513          	addi	a0,a0,716 # 800071a8 <etext+0x1a8>
    80001ee4:	941fe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    80001ee8:	00005517          	auipc	a0,0x5
    80001eec:	2d050513          	addi	a0,a0,720 # 800071b8 <etext+0x1b8>
    80001ef0:	935fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    80001ef4:	00005517          	auipc	a0,0x5
    80001ef8:	2d450513          	addi	a0,a0,724 # 800071c8 <etext+0x1c8>
    80001efc:	929fe0ef          	jal	80000824 <panic>

0000000080001f00 <yield>:
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f0a:	a25ff0ef          	jal	8000192e <myproc>
    80001f0e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f10:	d19fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    80001f14:	478d                	li	a5,3
    80001f16:	cc9c                	sw	a5,24(s1)
  sched();
    80001f18:	f2dff0ef          	jal	80001e44 <sched>
  release(&p->lock);
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	d9ffe0ef          	jal	80000cbc <release>
}
    80001f22:	60e2                	ld	ra,24(sp)
    80001f24:	6442                	ld	s0,16(sp)
    80001f26:	64a2                	ld	s1,8(sp)
    80001f28:	6105                	addi	sp,sp,32
    80001f2a:	8082                	ret

0000000080001f2c <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f2c:	7179                	addi	sp,sp,-48
    80001f2e:	f406                	sd	ra,40(sp)
    80001f30:	f022                	sd	s0,32(sp)
    80001f32:	ec26                	sd	s1,24(sp)
    80001f34:	e84a                	sd	s2,16(sp)
    80001f36:	e44e                	sd	s3,8(sp)
    80001f38:	1800                	addi	s0,sp,48
    80001f3a:	89aa                	mv	s3,a0
    80001f3c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f3e:	9f1ff0ef          	jal	8000192e <myproc>
    80001f42:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f44:	ce5fe0ef          	jal	80000c28 <acquire>
  release(lk);
    80001f48:	854a                	mv	a0,s2
    80001f4a:	d73fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    80001f4e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f52:	4789                	li	a5,2
    80001f54:	cc9c                	sw	a5,24(s1)

  sched();
    80001f56:	eefff0ef          	jal	80001e44 <sched>

  // Tidy up.
  p->chan = 0;
    80001f5a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	d5dfe0ef          	jal	80000cbc <release>
  acquire(lk);
    80001f64:	854a                	mv	a0,s2
    80001f66:	cc3fe0ef          	jal	80000c28 <acquire>
}
    80001f6a:	70a2                	ld	ra,40(sp)
    80001f6c:	7402                	ld	s0,32(sp)
    80001f6e:	64e2                	ld	s1,24(sp)
    80001f70:	6942                	ld	s2,16(sp)
    80001f72:	69a2                	ld	s3,8(sp)
    80001f74:	6145                	addi	sp,sp,48
    80001f76:	8082                	ret

0000000080001f78 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f78:	7139                	addi	sp,sp,-64
    80001f7a:	fc06                	sd	ra,56(sp)
    80001f7c:	f822                	sd	s0,48(sp)
    80001f7e:	f426                	sd	s1,40(sp)
    80001f80:	f04a                	sd	s2,32(sp)
    80001f82:	ec4e                	sd	s3,24(sp)
    80001f84:	e852                	sd	s4,16(sp)
    80001f86:	e456                	sd	s5,8(sp)
    80001f88:	0080                	addi	s0,sp,64
    80001f8a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f8c:	0000e497          	auipc	s1,0xe
    80001f90:	dfc48493          	addi	s1,s1,-516 # 8000fd88 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f94:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f96:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f98:	00013917          	auipc	s2,0x13
    80001f9c:	7f090913          	addi	s2,s2,2032 # 80015788 <tickslock>
    80001fa0:	a801                	j	80001fb0 <wakeup+0x38>
      }
      release(&p->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	d19fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fa8:	16848493          	addi	s1,s1,360
    80001fac:	03248263          	beq	s1,s2,80001fd0 <wakeup+0x58>
    if(p != myproc()){
    80001fb0:	97fff0ef          	jal	8000192e <myproc>
    80001fb4:	fe950ae3          	beq	a0,s1,80001fa8 <wakeup+0x30>
      acquire(&p->lock);
    80001fb8:	8526                	mv	a0,s1
    80001fba:	c6ffe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001fbe:	4c9c                	lw	a5,24(s1)
    80001fc0:	ff3791e3          	bne	a5,s3,80001fa2 <wakeup+0x2a>
    80001fc4:	709c                	ld	a5,32(s1)
    80001fc6:	fd479ee3          	bne	a5,s4,80001fa2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fca:	0154ac23          	sw	s5,24(s1)
    80001fce:	bfd1                	j	80001fa2 <wakeup+0x2a>
    }
  }
}
    80001fd0:	70e2                	ld	ra,56(sp)
    80001fd2:	7442                	ld	s0,48(sp)
    80001fd4:	74a2                	ld	s1,40(sp)
    80001fd6:	7902                	ld	s2,32(sp)
    80001fd8:	69e2                	ld	s3,24(sp)
    80001fda:	6a42                	ld	s4,16(sp)
    80001fdc:	6aa2                	ld	s5,8(sp)
    80001fde:	6121                	addi	sp,sp,64
    80001fe0:	8082                	ret

0000000080001fe2 <reparent>:
{
    80001fe2:	7179                	addi	sp,sp,-48
    80001fe4:	f406                	sd	ra,40(sp)
    80001fe6:	f022                	sd	s0,32(sp)
    80001fe8:	ec26                	sd	s1,24(sp)
    80001fea:	e84a                	sd	s2,16(sp)
    80001fec:	e44e                	sd	s3,8(sp)
    80001fee:	e052                	sd	s4,0(sp)
    80001ff0:	1800                	addi	s0,sp,48
    80001ff2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ff4:	0000e497          	auipc	s1,0xe
    80001ff8:	d9448493          	addi	s1,s1,-620 # 8000fd88 <proc>
      pp->parent = initproc;
    80001ffc:	00006a17          	auipc	s4,0x6
    80002000:	854a0a13          	addi	s4,s4,-1964 # 80007850 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002004:	00013997          	auipc	s3,0x13
    80002008:	78498993          	addi	s3,s3,1924 # 80015788 <tickslock>
    8000200c:	a029                	j	80002016 <reparent+0x34>
    8000200e:	16848493          	addi	s1,s1,360
    80002012:	01348b63          	beq	s1,s3,80002028 <reparent+0x46>
    if(pp->parent == p){
    80002016:	7c9c                	ld	a5,56(s1)
    80002018:	ff279be3          	bne	a5,s2,8000200e <reparent+0x2c>
      pp->parent = initproc;
    8000201c:	000a3503          	ld	a0,0(s4)
    80002020:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002022:	f57ff0ef          	jal	80001f78 <wakeup>
    80002026:	b7e5                	j	8000200e <reparent+0x2c>
}
    80002028:	70a2                	ld	ra,40(sp)
    8000202a:	7402                	ld	s0,32(sp)
    8000202c:	64e2                	ld	s1,24(sp)
    8000202e:	6942                	ld	s2,16(sp)
    80002030:	69a2                	ld	s3,8(sp)
    80002032:	6a02                	ld	s4,0(sp)
    80002034:	6145                	addi	sp,sp,48
    80002036:	8082                	ret

0000000080002038 <kexit>:
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	e052                	sd	s4,0(sp)
    80002046:	1800                	addi	s0,sp,48
    80002048:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000204a:	8e5ff0ef          	jal	8000192e <myproc>
    8000204e:	89aa                	mv	s3,a0
  if(p == initproc)
    80002050:	00006797          	auipc	a5,0x6
    80002054:	8007b783          	ld	a5,-2048(a5) # 80007850 <initproc>
    80002058:	0d050493          	addi	s1,a0,208
    8000205c:	15050913          	addi	s2,a0,336
    80002060:	00a79b63          	bne	a5,a0,80002076 <kexit+0x3e>
    panic("init exiting");
    80002064:	00005517          	auipc	a0,0x5
    80002068:	17c50513          	addi	a0,a0,380 # 800071e0 <etext+0x1e0>
    8000206c:	fb8fe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002070:	04a1                	addi	s1,s1,8
    80002072:	01248963          	beq	s1,s2,80002084 <kexit+0x4c>
    if(p->ofile[fd]){
    80002076:	6088                	ld	a0,0(s1)
    80002078:	dd65                	beqz	a0,80002070 <kexit+0x38>
      fileclose(f);
    8000207a:	7ad010ef          	jal	80004026 <fileclose>
      p->ofile[fd] = 0;
    8000207e:	0004b023          	sd	zero,0(s1)
    80002082:	b7fd                	j	80002070 <kexit+0x38>
  begin_op();
    80002084:	37f010ef          	jal	80003c02 <begin_op>
  iput(p->cwd);
    80002088:	1509b503          	ld	a0,336(s3)
    8000208c:	2ec010ef          	jal	80003378 <iput>
  end_op();
    80002090:	3e3010ef          	jal	80003c72 <end_op>
  p->cwd = 0;
    80002094:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002098:	0000e517          	auipc	a0,0xe
    8000209c:	8d850513          	addi	a0,a0,-1832 # 8000f970 <wait_lock>
    800020a0:	b89fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800020a4:	854e                	mv	a0,s3
    800020a6:	f3dff0ef          	jal	80001fe2 <reparent>
  wakeup(p->parent);
    800020aa:	0389b503          	ld	a0,56(s3)
    800020ae:	ecbff0ef          	jal	80001f78 <wakeup>
  acquire(&p->lock);
    800020b2:	854e                	mv	a0,s3
    800020b4:	b75fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800020b8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020bc:	4795                	li	a5,5
    800020be:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020c2:	0000e517          	auipc	a0,0xe
    800020c6:	8ae50513          	addi	a0,a0,-1874 # 8000f970 <wait_lock>
    800020ca:	bf3fe0ef          	jal	80000cbc <release>
  sched();
    800020ce:	d77ff0ef          	jal	80001e44 <sched>
  panic("zombie exit");
    800020d2:	00005517          	auipc	a0,0x5
    800020d6:	11e50513          	addi	a0,a0,286 # 800071f0 <etext+0x1f0>
    800020da:	f4afe0ef          	jal	80000824 <panic>

00000000800020de <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020de:	7179                	addi	sp,sp,-48
    800020e0:	f406                	sd	ra,40(sp)
    800020e2:	f022                	sd	s0,32(sp)
    800020e4:	ec26                	sd	s1,24(sp)
    800020e6:	e84a                	sd	s2,16(sp)
    800020e8:	e44e                	sd	s3,8(sp)
    800020ea:	1800                	addi	s0,sp,48
    800020ec:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020ee:	0000e497          	auipc	s1,0xe
    800020f2:	c9a48493          	addi	s1,s1,-870 # 8000fd88 <proc>
    800020f6:	00013997          	auipc	s3,0x13
    800020fa:	69298993          	addi	s3,s3,1682 # 80015788 <tickslock>
    acquire(&p->lock);
    800020fe:	8526                	mv	a0,s1
    80002100:	b29fe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    80002104:	589c                	lw	a5,48(s1)
    80002106:	01278b63          	beq	a5,s2,8000211c <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	bb1fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002110:	16848493          	addi	s1,s1,360
    80002114:	ff3495e3          	bne	s1,s3,800020fe <kkill+0x20>
  }
  return -1;
    80002118:	557d                	li	a0,-1
    8000211a:	a819                	j	80002130 <kkill+0x52>
      p->killed = 1;
    8000211c:	4785                	li	a5,1
    8000211e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002120:	4c98                	lw	a4,24(s1)
    80002122:	4789                	li	a5,2
    80002124:	00f70d63          	beq	a4,a5,8000213e <kkill+0x60>
      release(&p->lock);
    80002128:	8526                	mv	a0,s1
    8000212a:	b93fe0ef          	jal	80000cbc <release>
      return 0;
    8000212e:	4501                	li	a0,0
}
    80002130:	70a2                	ld	ra,40(sp)
    80002132:	7402                	ld	s0,32(sp)
    80002134:	64e2                	ld	s1,24(sp)
    80002136:	6942                	ld	s2,16(sp)
    80002138:	69a2                	ld	s3,8(sp)
    8000213a:	6145                	addi	sp,sp,48
    8000213c:	8082                	ret
        p->state = RUNNABLE;
    8000213e:	478d                	li	a5,3
    80002140:	cc9c                	sw	a5,24(s1)
    80002142:	b7dd                	j	80002128 <kkill+0x4a>

0000000080002144 <setkilled>:

void
setkilled(struct proc *p)
{
    80002144:	1101                	addi	sp,sp,-32
    80002146:	ec06                	sd	ra,24(sp)
    80002148:	e822                	sd	s0,16(sp)
    8000214a:	e426                	sd	s1,8(sp)
    8000214c:	1000                	addi	s0,sp,32
    8000214e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002150:	ad9fe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002154:	4785                	li	a5,1
    80002156:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002158:	8526                	mv	a0,s1
    8000215a:	b63fe0ef          	jal	80000cbc <release>
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6105                	addi	sp,sp,32
    80002166:	8082                	ret

0000000080002168 <killed>:

int
killed(struct proc *p)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	e426                	sd	s1,8(sp)
    80002170:	e04a                	sd	s2,0(sp)
    80002172:	1000                	addi	s0,sp,32
    80002174:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002176:	ab3fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    8000217a:	549c                	lw	a5,40(s1)
    8000217c:	893e                	mv	s2,a5
  release(&p->lock);
    8000217e:	8526                	mv	a0,s1
    80002180:	b3dfe0ef          	jal	80000cbc <release>
  return k;
}
    80002184:	854a                	mv	a0,s2
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	64a2                	ld	s1,8(sp)
    8000218c:	6902                	ld	s2,0(sp)
    8000218e:	6105                	addi	sp,sp,32
    80002190:	8082                	ret

0000000080002192 <kwait>:
{
    80002192:	715d                	addi	sp,sp,-80
    80002194:	e486                	sd	ra,72(sp)
    80002196:	e0a2                	sd	s0,64(sp)
    80002198:	fc26                	sd	s1,56(sp)
    8000219a:	f84a                	sd	s2,48(sp)
    8000219c:	f44e                	sd	s3,40(sp)
    8000219e:	f052                	sd	s4,32(sp)
    800021a0:	ec56                	sd	s5,24(sp)
    800021a2:	e85a                	sd	s6,16(sp)
    800021a4:	e45e                	sd	s7,8(sp)
    800021a6:	0880                	addi	s0,sp,80
    800021a8:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021aa:	f84ff0ef          	jal	8000192e <myproc>
    800021ae:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021b0:	0000d517          	auipc	a0,0xd
    800021b4:	7c050513          	addi	a0,a0,1984 # 8000f970 <wait_lock>
    800021b8:	a71fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800021bc:	4a15                	li	s4,5
        havekids = 1;
    800021be:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021c0:	00013997          	auipc	s3,0x13
    800021c4:	5c898993          	addi	s3,s3,1480 # 80015788 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021c8:	0000db17          	auipc	s6,0xd
    800021cc:	7a8b0b13          	addi	s6,s6,1960 # 8000f970 <wait_lock>
    800021d0:	a869                	j	8000226a <kwait+0xd8>
          pid = pp->pid;
    800021d2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021d6:	000b8c63          	beqz	s7,800021ee <kwait+0x5c>
    800021da:	4691                	li	a3,4
    800021dc:	02c48613          	addi	a2,s1,44
    800021e0:	85de                	mv	a1,s7
    800021e2:	05093503          	ld	a0,80(s2)
    800021e6:	c6eff0ef          	jal	80001654 <copyout>
    800021ea:	02054a63          	bltz	a0,8000221e <kwait+0x8c>
          freeproc(pp);
    800021ee:	8526                	mv	a0,s1
    800021f0:	913ff0ef          	jal	80001b02 <freeproc>
          release(&pp->lock);
    800021f4:	8526                	mv	a0,s1
    800021f6:	ac7fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    800021fa:	0000d517          	auipc	a0,0xd
    800021fe:	77650513          	addi	a0,a0,1910 # 8000f970 <wait_lock>
    80002202:	abbfe0ef          	jal	80000cbc <release>
}
    80002206:	854e                	mv	a0,s3
    80002208:	60a6                	ld	ra,72(sp)
    8000220a:	6406                	ld	s0,64(sp)
    8000220c:	74e2                	ld	s1,56(sp)
    8000220e:	7942                	ld	s2,48(sp)
    80002210:	79a2                	ld	s3,40(sp)
    80002212:	7a02                	ld	s4,32(sp)
    80002214:	6ae2                	ld	s5,24(sp)
    80002216:	6b42                	ld	s6,16(sp)
    80002218:	6ba2                	ld	s7,8(sp)
    8000221a:	6161                	addi	sp,sp,80
    8000221c:	8082                	ret
            release(&pp->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	a9dfe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002224:	0000d517          	auipc	a0,0xd
    80002228:	74c50513          	addi	a0,a0,1868 # 8000f970 <wait_lock>
    8000222c:	a91fe0ef          	jal	80000cbc <release>
            return -1;
    80002230:	59fd                	li	s3,-1
    80002232:	bfd1                	j	80002206 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002234:	16848493          	addi	s1,s1,360
    80002238:	03348063          	beq	s1,s3,80002258 <kwait+0xc6>
      if(pp->parent == p){
    8000223c:	7c9c                	ld	a5,56(s1)
    8000223e:	ff279be3          	bne	a5,s2,80002234 <kwait+0xa2>
        acquire(&pp->lock);
    80002242:	8526                	mv	a0,s1
    80002244:	9e5fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    80002248:	4c9c                	lw	a5,24(s1)
    8000224a:	f94784e3          	beq	a5,s4,800021d2 <kwait+0x40>
        release(&pp->lock);
    8000224e:	8526                	mv	a0,s1
    80002250:	a6dfe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002254:	8756                	mv	a4,s5
    80002256:	bff9                	j	80002234 <kwait+0xa2>
    if(!havekids || killed(p)){
    80002258:	cf19                	beqz	a4,80002276 <kwait+0xe4>
    8000225a:	854a                	mv	a0,s2
    8000225c:	f0dff0ef          	jal	80002168 <killed>
    80002260:	e919                	bnez	a0,80002276 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002262:	85da                	mv	a1,s6
    80002264:	854a                	mv	a0,s2
    80002266:	cc7ff0ef          	jal	80001f2c <sleep>
    havekids = 0;
    8000226a:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000226c:	0000e497          	auipc	s1,0xe
    80002270:	b1c48493          	addi	s1,s1,-1252 # 8000fd88 <proc>
    80002274:	b7e1                	j	8000223c <kwait+0xaa>
      release(&wait_lock);
    80002276:	0000d517          	auipc	a0,0xd
    8000227a:	6fa50513          	addi	a0,a0,1786 # 8000f970 <wait_lock>
    8000227e:	a3ffe0ef          	jal	80000cbc <release>
      return -1;
    80002282:	59fd                	li	s3,-1
    80002284:	b749                	j	80002206 <kwait+0x74>

0000000080002286 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002286:	7179                	addi	sp,sp,-48
    80002288:	f406                	sd	ra,40(sp)
    8000228a:	f022                	sd	s0,32(sp)
    8000228c:	ec26                	sd	s1,24(sp)
    8000228e:	e84a                	sd	s2,16(sp)
    80002290:	e44e                	sd	s3,8(sp)
    80002292:	e052                	sd	s4,0(sp)
    80002294:	1800                	addi	s0,sp,48
    80002296:	84aa                	mv	s1,a0
    80002298:	8a2e                	mv	s4,a1
    8000229a:	89b2                	mv	s3,a2
    8000229c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000229e:	e90ff0ef          	jal	8000192e <myproc>
  if(user_dst){
    800022a2:	cc99                	beqz	s1,800022c0 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800022a4:	86ca                	mv	a3,s2
    800022a6:	864e                	mv	a2,s3
    800022a8:	85d2                	mv	a1,s4
    800022aa:	6928                	ld	a0,80(a0)
    800022ac:	ba8ff0ef          	jal	80001654 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022b0:	70a2                	ld	ra,40(sp)
    800022b2:	7402                	ld	s0,32(sp)
    800022b4:	64e2                	ld	s1,24(sp)
    800022b6:	6942                	ld	s2,16(sp)
    800022b8:	69a2                	ld	s3,8(sp)
    800022ba:	6a02                	ld	s4,0(sp)
    800022bc:	6145                	addi	sp,sp,48
    800022be:	8082                	ret
    memmove((char *)dst, src, len);
    800022c0:	0009061b          	sext.w	a2,s2
    800022c4:	85ce                	mv	a1,s3
    800022c6:	8552                	mv	a0,s4
    800022c8:	a91fe0ef          	jal	80000d58 <memmove>
    return 0;
    800022cc:	8526                	mv	a0,s1
    800022ce:	b7cd                	j	800022b0 <either_copyout+0x2a>

00000000800022d0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022d0:	7179                	addi	sp,sp,-48
    800022d2:	f406                	sd	ra,40(sp)
    800022d4:	f022                	sd	s0,32(sp)
    800022d6:	ec26                	sd	s1,24(sp)
    800022d8:	e84a                	sd	s2,16(sp)
    800022da:	e44e                	sd	s3,8(sp)
    800022dc:	e052                	sd	s4,0(sp)
    800022de:	1800                	addi	s0,sp,48
    800022e0:	8a2a                	mv	s4,a0
    800022e2:	84ae                	mv	s1,a1
    800022e4:	89b2                	mv	s3,a2
    800022e6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022e8:	e46ff0ef          	jal	8000192e <myproc>
  if(user_src){
    800022ec:	cc99                	beqz	s1,8000230a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022ee:	86ca                	mv	a3,s2
    800022f0:	864e                	mv	a2,s3
    800022f2:	85d2                	mv	a1,s4
    800022f4:	6928                	ld	a0,80(a0)
    800022f6:	c1cff0ef          	jal	80001712 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022fa:	70a2                	ld	ra,40(sp)
    800022fc:	7402                	ld	s0,32(sp)
    800022fe:	64e2                	ld	s1,24(sp)
    80002300:	6942                	ld	s2,16(sp)
    80002302:	69a2                	ld	s3,8(sp)
    80002304:	6a02                	ld	s4,0(sp)
    80002306:	6145                	addi	sp,sp,48
    80002308:	8082                	ret
    memmove(dst, (char*)src, len);
    8000230a:	0009061b          	sext.w	a2,s2
    8000230e:	85ce                	mv	a1,s3
    80002310:	8552                	mv	a0,s4
    80002312:	a47fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002316:	8526                	mv	a0,s1
    80002318:	b7cd                	j	800022fa <either_copyin+0x2a>

000000008000231a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000231a:	715d                	addi	sp,sp,-80
    8000231c:	e486                	sd	ra,72(sp)
    8000231e:	e0a2                	sd	s0,64(sp)
    80002320:	fc26                	sd	s1,56(sp)
    80002322:	f84a                	sd	s2,48(sp)
    80002324:	f44e                	sd	s3,40(sp)
    80002326:	f052                	sd	s4,32(sp)
    80002328:	ec56                	sd	s5,24(sp)
    8000232a:	e85a                	sd	s6,16(sp)
    8000232c:	e45e                	sd	s7,8(sp)
    8000232e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002330:	00005517          	auipc	a0,0x5
    80002334:	d4850513          	addi	a0,a0,-696 # 80007078 <etext+0x78>
    80002338:	9c2fe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000233c:	0000e497          	auipc	s1,0xe
    80002340:	ba448493          	addi	s1,s1,-1116 # 8000fee0 <proc+0x158>
    80002344:	00013917          	auipc	s2,0x13
    80002348:	59c90913          	addi	s2,s2,1436 # 800158e0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000234c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000234e:	00005997          	auipc	s3,0x5
    80002352:	eb298993          	addi	s3,s3,-334 # 80007200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80002356:	00005a97          	auipc	s5,0x5
    8000235a:	eb2a8a93          	addi	s5,s5,-334 # 80007208 <etext+0x208>
    printf("\n");
    8000235e:	00005a17          	auipc	s4,0x5
    80002362:	d1aa0a13          	addi	s4,s4,-742 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002366:	00005b97          	auipc	s7,0x5
    8000236a:	3c2b8b93          	addi	s7,s7,962 # 80007728 <states.0>
    8000236e:	a829                	j	80002388 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002370:	ed86a583          	lw	a1,-296(a3)
    80002374:	8556                	mv	a0,s5
    80002376:	984fe0ef          	jal	800004fa <printf>
    printf("\n");
    8000237a:	8552                	mv	a0,s4
    8000237c:	97efe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002380:	16848493          	addi	s1,s1,360
    80002384:	03248263          	beq	s1,s2,800023a8 <procdump+0x8e>
    if(p->state == UNUSED)
    80002388:	86a6                	mv	a3,s1
    8000238a:	ec04a783          	lw	a5,-320(s1)
    8000238e:	dbed                	beqz	a5,80002380 <procdump+0x66>
      state = "???";
    80002390:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002392:	fcfb6fe3          	bltu	s6,a5,80002370 <procdump+0x56>
    80002396:	02079713          	slli	a4,a5,0x20
    8000239a:	01d75793          	srli	a5,a4,0x1d
    8000239e:	97de                	add	a5,a5,s7
    800023a0:	6390                	ld	a2,0(a5)
    800023a2:	f679                	bnez	a2,80002370 <procdump+0x56>
      state = "???";
    800023a4:	864e                	mv	a2,s3
    800023a6:	b7e9                	j	80002370 <procdump+0x56>
  }
}
    800023a8:	60a6                	ld	ra,72(sp)
    800023aa:	6406                	ld	s0,64(sp)
    800023ac:	74e2                	ld	s1,56(sp)
    800023ae:	7942                	ld	s2,48(sp)
    800023b0:	79a2                	ld	s3,40(sp)
    800023b2:	7a02                	ld	s4,32(sp)
    800023b4:	6ae2                	ld	s5,24(sp)
    800023b6:	6b42                	ld	s6,16(sp)
    800023b8:	6ba2                	ld	s7,8(sp)
    800023ba:	6161                	addi	sp,sp,80
    800023bc:	8082                	ret

00000000800023be <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023be:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023c2:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023c6:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023c8:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023ca:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023ce:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023d2:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023d6:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023da:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023de:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023e2:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800023e6:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800023ea:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800023ee:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800023f2:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800023f6:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023fa:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800023fc:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023fe:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002402:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002406:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000240a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000240e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002412:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002416:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000241a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000241e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002422:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002426:	8082                	ret

0000000080002428 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002428:	1141                	addi	sp,sp,-16
    8000242a:	e406                	sd	ra,8(sp)
    8000242c:	e022                	sd	s0,0(sp)
    8000242e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002430:	00005597          	auipc	a1,0x5
    80002434:	e1858593          	addi	a1,a1,-488 # 80007248 <etext+0x248>
    80002438:	00013517          	auipc	a0,0x13
    8000243c:	35050513          	addi	a0,a0,848 # 80015788 <tickslock>
    80002440:	f5efe0ef          	jal	80000b9e <initlock>
}
    80002444:	60a2                	ld	ra,8(sp)
    80002446:	6402                	ld	s0,0(sp)
    80002448:	0141                	addi	sp,sp,16
    8000244a:	8082                	ret

000000008000244c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000244c:	1141                	addi	sp,sp,-16
    8000244e:	e406                	sd	ra,8(sp)
    80002450:	e022                	sd	s0,0(sp)
    80002452:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002454:	00003797          	auipc	a5,0x3
    80002458:	f8c78793          	addi	a5,a5,-116 # 800053e0 <kernelvec>
    8000245c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002460:	60a2                	ld	ra,8(sp)
    80002462:	6402                	ld	s0,0(sp)
    80002464:	0141                	addi	sp,sp,16
    80002466:	8082                	ret

0000000080002468 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002468:	1141                	addi	sp,sp,-16
    8000246a:	e406                	sd	ra,8(sp)
    8000246c:	e022                	sd	s0,0(sp)
    8000246e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002470:	cbeff0ef          	jal	8000192e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002474:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002478:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000247a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000247e:	04000737          	lui	a4,0x4000
    80002482:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002484:	0732                	slli	a4,a4,0xc
    80002486:	00004797          	auipc	a5,0x4
    8000248a:	b7a78793          	addi	a5,a5,-1158 # 80006000 <_trampoline>
    8000248e:	00004697          	auipc	a3,0x4
    80002492:	b7268693          	addi	a3,a3,-1166 # 80006000 <_trampoline>
    80002496:	8f95                	sub	a5,a5,a3
    80002498:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000249a:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000249e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024a0:	18002773          	csrr	a4,satp
    800024a4:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024a6:	6d38                	ld	a4,88(a0)
    800024a8:	613c                	ld	a5,64(a0)
    800024aa:	6685                	lui	a3,0x1
    800024ac:	97b6                	add	a5,a5,a3
    800024ae:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024b0:	6d3c                	ld	a5,88(a0)
    800024b2:	00000717          	auipc	a4,0x0
    800024b6:	0fc70713          	addi	a4,a4,252 # 800025ae <usertrap>
    800024ba:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800024bc:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024be:	8712                	mv	a4,tp
    800024c0:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024c2:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024c6:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024ca:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024ce:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024d2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024d4:	6f9c                	ld	a5,24(a5)
    800024d6:	14179073          	csrw	sepc,a5
}
    800024da:	60a2                	ld	ra,8(sp)
    800024dc:	6402                	ld	s0,0(sp)
    800024de:	0141                	addi	sp,sp,16
    800024e0:	8082                	ret

00000000800024e2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024e2:	1141                	addi	sp,sp,-16
    800024e4:	e406                	sd	ra,8(sp)
    800024e6:	e022                	sd	s0,0(sp)
    800024e8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800024ea:	c10ff0ef          	jal	800018fa <cpuid>
    800024ee:	cd11                	beqz	a0,8000250a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024f0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024f4:	000f4737          	lui	a4,0xf4
    800024f8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024fc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800024fe:	14d79073          	csrw	stimecmp,a5
}
    80002502:	60a2                	ld	ra,8(sp)
    80002504:	6402                	ld	s0,0(sp)
    80002506:	0141                	addi	sp,sp,16
    80002508:	8082                	ret
    acquire(&tickslock);
    8000250a:	00013517          	auipc	a0,0x13
    8000250e:	27e50513          	addi	a0,a0,638 # 80015788 <tickslock>
    80002512:	f16fe0ef          	jal	80000c28 <acquire>
    ticks++;
    80002516:	00005717          	auipc	a4,0x5
    8000251a:	34270713          	addi	a4,a4,834 # 80007858 <ticks>
    8000251e:	431c                	lw	a5,0(a4)
    80002520:	2785                	addiw	a5,a5,1
    80002522:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002524:	853a                	mv	a0,a4
    80002526:	a53ff0ef          	jal	80001f78 <wakeup>
    release(&tickslock);
    8000252a:	00013517          	auipc	a0,0x13
    8000252e:	25e50513          	addi	a0,a0,606 # 80015788 <tickslock>
    80002532:	f8afe0ef          	jal	80000cbc <release>
    80002536:	bf6d                	j	800024f0 <clockintr+0xe>

0000000080002538 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002538:	1101                	addi	sp,sp,-32
    8000253a:	ec06                	sd	ra,24(sp)
    8000253c:	e822                	sd	s0,16(sp)
    8000253e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002540:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002544:	57fd                	li	a5,-1
    80002546:	17fe                	slli	a5,a5,0x3f
    80002548:	07a5                	addi	a5,a5,9
    8000254a:	00f70c63          	beq	a4,a5,80002562 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000254e:	57fd                	li	a5,-1
    80002550:	17fe                	slli	a5,a5,0x3f
    80002552:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002554:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002556:	04f70863          	beq	a4,a5,800025a6 <devintr+0x6e>
  }
}
    8000255a:	60e2                	ld	ra,24(sp)
    8000255c:	6442                	ld	s0,16(sp)
    8000255e:	6105                	addi	sp,sp,32
    80002560:	8082                	ret
    80002562:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002564:	729020ef          	jal	8000548c <plic_claim>
    80002568:	872a                	mv	a4,a0
    8000256a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000256c:	47a9                	li	a5,10
    8000256e:	00f50963          	beq	a0,a5,80002580 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80002572:	4785                	li	a5,1
    80002574:	00f50963          	beq	a0,a5,80002586 <devintr+0x4e>
    return 1;
    80002578:	4505                	li	a0,1
    } else if(irq){
    8000257a:	eb09                	bnez	a4,8000258c <devintr+0x54>
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	bff1                	j	8000255a <devintr+0x22>
      uartintr();
    80002580:	c74fe0ef          	jal	800009f4 <uartintr>
    if(irq)
    80002584:	a819                	j	8000259a <devintr+0x62>
      virtio_disk_intr();
    80002586:	39c030ef          	jal	80005922 <virtio_disk_intr>
    if(irq)
    8000258a:	a801                	j	8000259a <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    8000258c:	85ba                	mv	a1,a4
    8000258e:	00005517          	auipc	a0,0x5
    80002592:	cc250513          	addi	a0,a0,-830 # 80007250 <etext+0x250>
    80002596:	f65fd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    8000259a:	8526                	mv	a0,s1
    8000259c:	711020ef          	jal	800054ac <plic_complete>
    return 1;
    800025a0:	4505                	li	a0,1
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	bf5d                	j	8000255a <devintr+0x22>
    clockintr();
    800025a6:	f3dff0ef          	jal	800024e2 <clockintr>
    return 2;
    800025aa:	4509                	li	a0,2
    800025ac:	b77d                	j	8000255a <devintr+0x22>

00000000800025ae <usertrap>:
{
    800025ae:	1101                	addi	sp,sp,-32
    800025b0:	ec06                	sd	ra,24(sp)
    800025b2:	e822                	sd	s0,16(sp)
    800025b4:	e426                	sd	s1,8(sp)
    800025b6:	e04a                	sd	s2,0(sp)
    800025b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025ba:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025be:	1007f793          	andi	a5,a5,256
    800025c2:	eba5                	bnez	a5,80002632 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025c4:	00003797          	auipc	a5,0x3
    800025c8:	e1c78793          	addi	a5,a5,-484 # 800053e0 <kernelvec>
    800025cc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025d0:	b5eff0ef          	jal	8000192e <myproc>
    800025d4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025d6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025d8:	14102773          	csrr	a4,sepc
    800025dc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025de:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025e2:	47a1                	li	a5,8
    800025e4:	04f70d63          	beq	a4,a5,8000263e <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800025e8:	f51ff0ef          	jal	80002538 <devintr>
    800025ec:	892a                	mv	s2,a0
    800025ee:	e945                	bnez	a0,8000269e <usertrap+0xf0>
    800025f0:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800025f4:	47bd                	li	a5,15
    800025f6:	08f70863          	beq	a4,a5,80002686 <usertrap+0xd8>
    800025fa:	14202773          	csrr	a4,scause
    800025fe:	47b5                	li	a5,13
    80002600:	08f70363          	beq	a4,a5,80002686 <usertrap+0xd8>
    80002604:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002608:	5890                	lw	a2,48(s1)
    8000260a:	00005517          	auipc	a0,0x5
    8000260e:	c8650513          	addi	a0,a0,-890 # 80007290 <etext+0x290>
    80002612:	ee9fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002616:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000261a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000261e:	00005517          	auipc	a0,0x5
    80002622:	ca250513          	addi	a0,a0,-862 # 800072c0 <etext+0x2c0>
    80002626:	ed5fd0ef          	jal	800004fa <printf>
    setkilled(p);
    8000262a:	8526                	mv	a0,s1
    8000262c:	b19ff0ef          	jal	80002144 <setkilled>
    80002630:	a035                	j	8000265c <usertrap+0xae>
    panic("usertrap: not from user mode");
    80002632:	00005517          	auipc	a0,0x5
    80002636:	c3e50513          	addi	a0,a0,-962 # 80007270 <etext+0x270>
    8000263a:	9eafe0ef          	jal	80000824 <panic>
    if(killed(p))
    8000263e:	b2bff0ef          	jal	80002168 <killed>
    80002642:	ed15                	bnez	a0,8000267e <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002644:	6cb8                	ld	a4,88(s1)
    80002646:	6f1c                	ld	a5,24(a4)
    80002648:	0791                	addi	a5,a5,4
    8000264a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000264c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002650:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002654:	10079073          	csrw	sstatus,a5
    syscall();
    80002658:	240000ef          	jal	80002898 <syscall>
  if(killed(p))
    8000265c:	8526                	mv	a0,s1
    8000265e:	b0bff0ef          	jal	80002168 <killed>
    80002662:	e139                	bnez	a0,800026a8 <usertrap+0xfa>
  prepare_return();
    80002664:	e05ff0ef          	jal	80002468 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002668:	68a8                	ld	a0,80(s1)
    8000266a:	8131                	srli	a0,a0,0xc
    8000266c:	57fd                	li	a5,-1
    8000266e:	17fe                	slli	a5,a5,0x3f
    80002670:	8d5d                	or	a0,a0,a5
}
    80002672:	60e2                	ld	ra,24(sp)
    80002674:	6442                	ld	s0,16(sp)
    80002676:	64a2                	ld	s1,8(sp)
    80002678:	6902                	ld	s2,0(sp)
    8000267a:	6105                	addi	sp,sp,32
    8000267c:	8082                	ret
      kexit(-1);
    8000267e:	557d                	li	a0,-1
    80002680:	9b9ff0ef          	jal	80002038 <kexit>
    80002684:	b7c1                	j	80002644 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002686:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000268a:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    8000268e:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002690:	00163613          	seqz	a2,a2
    80002694:	68a8                	ld	a0,80(s1)
    80002696:	f3bfe0ef          	jal	800015d0 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    8000269a:	f169                	bnez	a0,8000265c <usertrap+0xae>
    8000269c:	b7a5                	j	80002604 <usertrap+0x56>
  if(killed(p))
    8000269e:	8526                	mv	a0,s1
    800026a0:	ac9ff0ef          	jal	80002168 <killed>
    800026a4:	c511                	beqz	a0,800026b0 <usertrap+0x102>
    800026a6:	a011                	j	800026aa <usertrap+0xfc>
    800026a8:	4901                	li	s2,0
    kexit(-1);
    800026aa:	557d                	li	a0,-1
    800026ac:	98dff0ef          	jal	80002038 <kexit>
  if(which_dev == 2)
    800026b0:	4789                	li	a5,2
    800026b2:	faf919e3          	bne	s2,a5,80002664 <usertrap+0xb6>
    yield();
    800026b6:	84bff0ef          	jal	80001f00 <yield>
    800026ba:	b76d                	j	80002664 <usertrap+0xb6>

00000000800026bc <kerneltrap>:
{
    800026bc:	7179                	addi	sp,sp,-48
    800026be:	f406                	sd	ra,40(sp)
    800026c0:	f022                	sd	s0,32(sp)
    800026c2:	ec26                	sd	s1,24(sp)
    800026c4:	e84a                	sd	s2,16(sp)
    800026c6:	e44e                	sd	s3,8(sp)
    800026c8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026ca:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ce:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026d2:	142027f3          	csrr	a5,scause
    800026d6:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    800026d8:	1004f793          	andi	a5,s1,256
    800026dc:	c795                	beqz	a5,80002708 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026de:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026e2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026e4:	eb85                	bnez	a5,80002714 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    800026e6:	e53ff0ef          	jal	80002538 <devintr>
    800026ea:	c91d                	beqz	a0,80002720 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    800026ec:	4789                	li	a5,2
    800026ee:	04f50a63          	beq	a0,a5,80002742 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026f2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026f6:	10049073          	csrw	sstatus,s1
}
    800026fa:	70a2                	ld	ra,40(sp)
    800026fc:	7402                	ld	s0,32(sp)
    800026fe:	64e2                	ld	s1,24(sp)
    80002700:	6942                	ld	s2,16(sp)
    80002702:	69a2                	ld	s3,8(sp)
    80002704:	6145                	addi	sp,sp,48
    80002706:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002708:	00005517          	auipc	a0,0x5
    8000270c:	be050513          	addi	a0,a0,-1056 # 800072e8 <etext+0x2e8>
    80002710:	914fe0ef          	jal	80000824 <panic>
    panic("kerneltrap: interrupts enabled");
    80002714:	00005517          	auipc	a0,0x5
    80002718:	bfc50513          	addi	a0,a0,-1028 # 80007310 <etext+0x310>
    8000271c:	908fe0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002720:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002724:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002728:	85ce                	mv	a1,s3
    8000272a:	00005517          	auipc	a0,0x5
    8000272e:	c0650513          	addi	a0,a0,-1018 # 80007330 <etext+0x330>
    80002732:	dc9fd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80002736:	00005517          	auipc	a0,0x5
    8000273a:	c2250513          	addi	a0,a0,-990 # 80007358 <etext+0x358>
    8000273e:	8e6fe0ef          	jal	80000824 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002742:	9ecff0ef          	jal	8000192e <myproc>
    80002746:	d555                	beqz	a0,800026f2 <kerneltrap+0x36>
    yield();
    80002748:	fb8ff0ef          	jal	80001f00 <yield>
    8000274c:	b75d                	j	800026f2 <kerneltrap+0x36>

000000008000274e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	1000                	addi	s0,sp,32
    80002758:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000275a:	9d4ff0ef          	jal	8000192e <myproc>
  switch (n) {
    8000275e:	4795                	li	a5,5
    80002760:	0497e163          	bltu	a5,s1,800027a2 <argraw+0x54>
    80002764:	048a                	slli	s1,s1,0x2
    80002766:	00005717          	auipc	a4,0x5
    8000276a:	ff270713          	addi	a4,a4,-14 # 80007758 <states.0+0x30>
    8000276e:	94ba                	add	s1,s1,a4
    80002770:	409c                	lw	a5,0(s1)
    80002772:	97ba                	add	a5,a5,a4
    80002774:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002776:	6d3c                	ld	a5,88(a0)
    80002778:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000277a:	60e2                	ld	ra,24(sp)
    8000277c:	6442                	ld	s0,16(sp)
    8000277e:	64a2                	ld	s1,8(sp)
    80002780:	6105                	addi	sp,sp,32
    80002782:	8082                	ret
    return p->trapframe->a1;
    80002784:	6d3c                	ld	a5,88(a0)
    80002786:	7fa8                	ld	a0,120(a5)
    80002788:	bfcd                	j	8000277a <argraw+0x2c>
    return p->trapframe->a2;
    8000278a:	6d3c                	ld	a5,88(a0)
    8000278c:	63c8                	ld	a0,128(a5)
    8000278e:	b7f5                	j	8000277a <argraw+0x2c>
    return p->trapframe->a3;
    80002790:	6d3c                	ld	a5,88(a0)
    80002792:	67c8                	ld	a0,136(a5)
    80002794:	b7dd                	j	8000277a <argraw+0x2c>
    return p->trapframe->a4;
    80002796:	6d3c                	ld	a5,88(a0)
    80002798:	6bc8                	ld	a0,144(a5)
    8000279a:	b7c5                	j	8000277a <argraw+0x2c>
    return p->trapframe->a5;
    8000279c:	6d3c                	ld	a5,88(a0)
    8000279e:	6fc8                	ld	a0,152(a5)
    800027a0:	bfe9                	j	8000277a <argraw+0x2c>
  panic("argraw");
    800027a2:	00005517          	auipc	a0,0x5
    800027a6:	bc650513          	addi	a0,a0,-1082 # 80007368 <etext+0x368>
    800027aa:	87afe0ef          	jal	80000824 <panic>

00000000800027ae <fetchaddr>:
{
    800027ae:	1101                	addi	sp,sp,-32
    800027b0:	ec06                	sd	ra,24(sp)
    800027b2:	e822                	sd	s0,16(sp)
    800027b4:	e426                	sd	s1,8(sp)
    800027b6:	e04a                	sd	s2,0(sp)
    800027b8:	1000                	addi	s0,sp,32
    800027ba:	84aa                	mv	s1,a0
    800027bc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027be:	970ff0ef          	jal	8000192e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027c2:	653c                	ld	a5,72(a0)
    800027c4:	02f4f663          	bgeu	s1,a5,800027f0 <fetchaddr+0x42>
    800027c8:	00848713          	addi	a4,s1,8
    800027cc:	02e7e463          	bltu	a5,a4,800027f4 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027d0:	46a1                	li	a3,8
    800027d2:	8626                	mv	a2,s1
    800027d4:	85ca                	mv	a1,s2
    800027d6:	6928                	ld	a0,80(a0)
    800027d8:	f3bfe0ef          	jal	80001712 <copyin>
    800027dc:	00a03533          	snez	a0,a0
    800027e0:	40a0053b          	negw	a0,a0
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6902                	ld	s2,0(sp)
    800027ec:	6105                	addi	sp,sp,32
    800027ee:	8082                	ret
    return -1;
    800027f0:	557d                	li	a0,-1
    800027f2:	bfcd                	j	800027e4 <fetchaddr+0x36>
    800027f4:	557d                	li	a0,-1
    800027f6:	b7fd                	j	800027e4 <fetchaddr+0x36>

00000000800027f8 <fetchstr>:
{
    800027f8:	7179                	addi	sp,sp,-48
    800027fa:	f406                	sd	ra,40(sp)
    800027fc:	f022                	sd	s0,32(sp)
    800027fe:	ec26                	sd	s1,24(sp)
    80002800:	e84a                	sd	s2,16(sp)
    80002802:	e44e                	sd	s3,8(sp)
    80002804:	1800                	addi	s0,sp,48
    80002806:	89aa                	mv	s3,a0
    80002808:	84ae                	mv	s1,a1
    8000280a:	8932                	mv	s2,a2
  struct proc *p = myproc();
    8000280c:	922ff0ef          	jal	8000192e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002810:	86ca                	mv	a3,s2
    80002812:	864e                	mv	a2,s3
    80002814:	85a6                	mv	a1,s1
    80002816:	6928                	ld	a0,80(a0)
    80002818:	ce1fe0ef          	jal	800014f8 <copyinstr>
    8000281c:	00054c63          	bltz	a0,80002834 <fetchstr+0x3c>
  return strlen(buf);
    80002820:	8526                	mv	a0,s1
    80002822:	e60fe0ef          	jal	80000e82 <strlen>
}
    80002826:	70a2                	ld	ra,40(sp)
    80002828:	7402                	ld	s0,32(sp)
    8000282a:	64e2                	ld	s1,24(sp)
    8000282c:	6942                	ld	s2,16(sp)
    8000282e:	69a2                	ld	s3,8(sp)
    80002830:	6145                	addi	sp,sp,48
    80002832:	8082                	ret
    return -1;
    80002834:	557d                	li	a0,-1
    80002836:	bfc5                	j	80002826 <fetchstr+0x2e>

0000000080002838 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002838:	1101                	addi	sp,sp,-32
    8000283a:	ec06                	sd	ra,24(sp)
    8000283c:	e822                	sd	s0,16(sp)
    8000283e:	e426                	sd	s1,8(sp)
    80002840:	1000                	addi	s0,sp,32
    80002842:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002844:	f0bff0ef          	jal	8000274e <argraw>
    80002848:	c088                	sw	a0,0(s1)
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret

0000000080002854 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002854:	1101                	addi	sp,sp,-32
    80002856:	ec06                	sd	ra,24(sp)
    80002858:	e822                	sd	s0,16(sp)
    8000285a:	e426                	sd	s1,8(sp)
    8000285c:	1000                	addi	s0,sp,32
    8000285e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002860:	eefff0ef          	jal	8000274e <argraw>
    80002864:	e088                	sd	a0,0(s1)
}
    80002866:	60e2                	ld	ra,24(sp)
    80002868:	6442                	ld	s0,16(sp)
    8000286a:	64a2                	ld	s1,8(sp)
    8000286c:	6105                	addi	sp,sp,32
    8000286e:	8082                	ret

0000000080002870 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002870:	1101                	addi	sp,sp,-32
    80002872:	ec06                	sd	ra,24(sp)
    80002874:	e822                	sd	s0,16(sp)
    80002876:	e426                	sd	s1,8(sp)
    80002878:	e04a                	sd	s2,0(sp)
    8000287a:	1000                	addi	s0,sp,32
    8000287c:	892e                	mv	s2,a1
    8000287e:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002880:	ecfff0ef          	jal	8000274e <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002884:	8626                	mv	a2,s1
    80002886:	85ca                	mv	a1,s2
    80002888:	f71ff0ef          	jal	800027f8 <fetchstr>
}
    8000288c:	60e2                	ld	ra,24(sp)
    8000288e:	6442                	ld	s0,16(sp)
    80002890:	64a2                	ld	s1,8(sp)
    80002892:	6902                	ld	s2,0(sp)
    80002894:	6105                	addi	sp,sp,32
    80002896:	8082                	ret

0000000080002898 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002898:	1101                	addi	sp,sp,-32
    8000289a:	ec06                	sd	ra,24(sp)
    8000289c:	e822                	sd	s0,16(sp)
    8000289e:	e426                	sd	s1,8(sp)
    800028a0:	e04a                	sd	s2,0(sp)
    800028a2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028a4:	88aff0ef          	jal	8000192e <myproc>
    800028a8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028aa:	05853903          	ld	s2,88(a0)
    800028ae:	0a893783          	ld	a5,168(s2)
    800028b2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028b6:	37fd                	addiw	a5,a5,-1
    800028b8:	4751                	li	a4,20
    800028ba:	00f76f63          	bltu	a4,a5,800028d8 <syscall+0x40>
    800028be:	00369713          	slli	a4,a3,0x3
    800028c2:	00005797          	auipc	a5,0x5
    800028c6:	eae78793          	addi	a5,a5,-338 # 80007770 <syscalls>
    800028ca:	97ba                	add	a5,a5,a4
    800028cc:	639c                	ld	a5,0(a5)
    800028ce:	c789                	beqz	a5,800028d8 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028d0:	9782                	jalr	a5
    800028d2:	06a93823          	sd	a0,112(s2)
    800028d6:	a829                	j	800028f0 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800028d8:	15848613          	addi	a2,s1,344
    800028dc:	588c                	lw	a1,48(s1)
    800028de:	00005517          	auipc	a0,0x5
    800028e2:	a9250513          	addi	a0,a0,-1390 # 80007370 <etext+0x370>
    800028e6:	c15fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800028ea:	6cbc                	ld	a5,88(s1)
    800028ec:	577d                	li	a4,-1
    800028ee:	fbb8                	sd	a4,112(a5)
  }
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret

00000000800028fc <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    800028fc:	1101                	addi	sp,sp,-32
    800028fe:	ec06                	sd	ra,24(sp)
    80002900:	e822                	sd	s0,16(sp)
    80002902:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002904:	fec40593          	addi	a1,s0,-20
    80002908:	4501                	li	a0,0
    8000290a:	f2fff0ef          	jal	80002838 <argint>
  kexit(n);
    8000290e:	fec42503          	lw	a0,-20(s0)
    80002912:	f26ff0ef          	jal	80002038 <kexit>
  return 0;  // not reached
}
    80002916:	4501                	li	a0,0
    80002918:	60e2                	ld	ra,24(sp)
    8000291a:	6442                	ld	s0,16(sp)
    8000291c:	6105                	addi	sp,sp,32
    8000291e:	8082                	ret

0000000080002920 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002920:	1141                	addi	sp,sp,-16
    80002922:	e406                	sd	ra,8(sp)
    80002924:	e022                	sd	s0,0(sp)
    80002926:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002928:	806ff0ef          	jal	8000192e <myproc>
}
    8000292c:	5908                	lw	a0,48(a0)
    8000292e:	60a2                	ld	ra,8(sp)
    80002930:	6402                	ld	s0,0(sp)
    80002932:	0141                	addi	sp,sp,16
    80002934:	8082                	ret

0000000080002936 <sys_fork>:

uint64
sys_fork(void)
{
    80002936:	1141                	addi	sp,sp,-16
    80002938:	e406                	sd	ra,8(sp)
    8000293a:	e022                	sd	s0,0(sp)
    8000293c:	0800                	addi	s0,sp,16
  return kfork();
    8000293e:	b46ff0ef          	jal	80001c84 <kfork>
}
    80002942:	60a2                	ld	ra,8(sp)
    80002944:	6402                	ld	s0,0(sp)
    80002946:	0141                	addi	sp,sp,16
    80002948:	8082                	ret

000000008000294a <sys_wait>:

uint64
sys_wait(void)
{
    8000294a:	1101                	addi	sp,sp,-32
    8000294c:	ec06                	sd	ra,24(sp)
    8000294e:	e822                	sd	s0,16(sp)
    80002950:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002952:	fe840593          	addi	a1,s0,-24
    80002956:	4501                	li	a0,0
    80002958:	efdff0ef          	jal	80002854 <argaddr>
  return kwait(p);
    8000295c:	fe843503          	ld	a0,-24(s0)
    80002960:	833ff0ef          	jal	80002192 <kwait>
}
    80002964:	60e2                	ld	ra,24(sp)
    80002966:	6442                	ld	s0,16(sp)
    80002968:	6105                	addi	sp,sp,32
    8000296a:	8082                	ret

000000008000296c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000296c:	7179                	addi	sp,sp,-48
    8000296e:	f406                	sd	ra,40(sp)
    80002970:	f022                	sd	s0,32(sp)
    80002972:	ec26                	sd	s1,24(sp)
    80002974:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002976:	fd840593          	addi	a1,s0,-40
    8000297a:	4501                	li	a0,0
    8000297c:	ebdff0ef          	jal	80002838 <argint>
  argint(1, &t);
    80002980:	fdc40593          	addi	a1,s0,-36
    80002984:	4505                	li	a0,1
    80002986:	eb3ff0ef          	jal	80002838 <argint>
  addr = myproc()->sz;
    8000298a:	fa5fe0ef          	jal	8000192e <myproc>
    8000298e:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002990:	fdc42703          	lw	a4,-36(s0)
    80002994:	4785                	li	a5,1
    80002996:	02f70163          	beq	a4,a5,800029b8 <sys_sbrk+0x4c>
    8000299a:	fd842783          	lw	a5,-40(s0)
    8000299e:	0007cd63          	bltz	a5,800029b8 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    800029a2:	97a6                	add	a5,a5,s1
    800029a4:	0297e863          	bltu	a5,s1,800029d4 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    800029a8:	f87fe0ef          	jal	8000192e <myproc>
    800029ac:	fd842703          	lw	a4,-40(s0)
    800029b0:	653c                	ld	a5,72(a0)
    800029b2:	97ba                	add	a5,a5,a4
    800029b4:	e53c                	sd	a5,72(a0)
    800029b6:	a039                	j	800029c4 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    800029b8:	fd842503          	lw	a0,-40(s0)
    800029bc:	a78ff0ef          	jal	80001c34 <growproc>
    800029c0:	00054863          	bltz	a0,800029d0 <sys_sbrk+0x64>
  }
  return addr;
}
    800029c4:	8526                	mv	a0,s1
    800029c6:	70a2                	ld	ra,40(sp)
    800029c8:	7402                	ld	s0,32(sp)
    800029ca:	64e2                	ld	s1,24(sp)
    800029cc:	6145                	addi	sp,sp,48
    800029ce:	8082                	ret
      return -1;
    800029d0:	54fd                	li	s1,-1
    800029d2:	bfcd                	j	800029c4 <sys_sbrk+0x58>
      return -1;
    800029d4:	54fd                	li	s1,-1
    800029d6:	b7fd                	j	800029c4 <sys_sbrk+0x58>

00000000800029d8 <sys_pause>:

uint64
sys_pause(void)
{
    800029d8:	7139                	addi	sp,sp,-64
    800029da:	fc06                	sd	ra,56(sp)
    800029dc:	f822                	sd	s0,48(sp)
    800029de:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029e0:	fcc40593          	addi	a1,s0,-52
    800029e4:	4501                	li	a0,0
    800029e6:	e53ff0ef          	jal	80002838 <argint>
  if(n < 0)
    800029ea:	fcc42783          	lw	a5,-52(s0)
    800029ee:	0607c863          	bltz	a5,80002a5e <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800029f2:	00013517          	auipc	a0,0x13
    800029f6:	d9650513          	addi	a0,a0,-618 # 80015788 <tickslock>
    800029fa:	a2efe0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    800029fe:	fcc42783          	lw	a5,-52(s0)
    80002a02:	c3b9                	beqz	a5,80002a48 <sys_pause+0x70>
    80002a04:	f426                	sd	s1,40(sp)
    80002a06:	f04a                	sd	s2,32(sp)
    80002a08:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a0a:	00005997          	auipc	s3,0x5
    80002a0e:	e4e9a983          	lw	s3,-434(s3) # 80007858 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a12:	00013917          	auipc	s2,0x13
    80002a16:	d7690913          	addi	s2,s2,-650 # 80015788 <tickslock>
    80002a1a:	00005497          	auipc	s1,0x5
    80002a1e:	e3e48493          	addi	s1,s1,-450 # 80007858 <ticks>
    if(killed(myproc())){
    80002a22:	f0dfe0ef          	jal	8000192e <myproc>
    80002a26:	f42ff0ef          	jal	80002168 <killed>
    80002a2a:	ed0d                	bnez	a0,80002a64 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a2c:	85ca                	mv	a1,s2
    80002a2e:	8526                	mv	a0,s1
    80002a30:	cfcff0ef          	jal	80001f2c <sleep>
  while(ticks - ticks0 < n){
    80002a34:	409c                	lw	a5,0(s1)
    80002a36:	413787bb          	subw	a5,a5,s3
    80002a3a:	fcc42703          	lw	a4,-52(s0)
    80002a3e:	fee7e2e3          	bltu	a5,a4,80002a22 <sys_pause+0x4a>
    80002a42:	74a2                	ld	s1,40(sp)
    80002a44:	7902                	ld	s2,32(sp)
    80002a46:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a48:	00013517          	auipc	a0,0x13
    80002a4c:	d4050513          	addi	a0,a0,-704 # 80015788 <tickslock>
    80002a50:	a6cfe0ef          	jal	80000cbc <release>
  return 0;
    80002a54:	4501                	li	a0,0
}
    80002a56:	70e2                	ld	ra,56(sp)
    80002a58:	7442                	ld	s0,48(sp)
    80002a5a:	6121                	addi	sp,sp,64
    80002a5c:	8082                	ret
    n = 0;
    80002a5e:	fc042623          	sw	zero,-52(s0)
    80002a62:	bf41                	j	800029f2 <sys_pause+0x1a>
      release(&tickslock);
    80002a64:	00013517          	auipc	a0,0x13
    80002a68:	d2450513          	addi	a0,a0,-732 # 80015788 <tickslock>
    80002a6c:	a50fe0ef          	jal	80000cbc <release>
      return -1;
    80002a70:	557d                	li	a0,-1
    80002a72:	74a2                	ld	s1,40(sp)
    80002a74:	7902                	ld	s2,32(sp)
    80002a76:	69e2                	ld	s3,24(sp)
    80002a78:	bff9                	j	80002a56 <sys_pause+0x7e>

0000000080002a7a <sys_kill>:

uint64
sys_kill(void)
{
    80002a7a:	1101                	addi	sp,sp,-32
    80002a7c:	ec06                	sd	ra,24(sp)
    80002a7e:	e822                	sd	s0,16(sp)
    80002a80:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a82:	fec40593          	addi	a1,s0,-20
    80002a86:	4501                	li	a0,0
    80002a88:	db1ff0ef          	jal	80002838 <argint>
  return kkill(pid);
    80002a8c:	fec42503          	lw	a0,-20(s0)
    80002a90:	e4eff0ef          	jal	800020de <kkill>
}
    80002a94:	60e2                	ld	ra,24(sp)
    80002a96:	6442                	ld	s0,16(sp)
    80002a98:	6105                	addi	sp,sp,32
    80002a9a:	8082                	ret

0000000080002a9c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a9c:	1101                	addi	sp,sp,-32
    80002a9e:	ec06                	sd	ra,24(sp)
    80002aa0:	e822                	sd	s0,16(sp)
    80002aa2:	e426                	sd	s1,8(sp)
    80002aa4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002aa6:	00013517          	auipc	a0,0x13
    80002aaa:	ce250513          	addi	a0,a0,-798 # 80015788 <tickslock>
    80002aae:	97afe0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80002ab2:	00005797          	auipc	a5,0x5
    80002ab6:	da67a783          	lw	a5,-602(a5) # 80007858 <ticks>
    80002aba:	84be                	mv	s1,a5
  release(&tickslock);
    80002abc:	00013517          	auipc	a0,0x13
    80002ac0:	ccc50513          	addi	a0,a0,-820 # 80015788 <tickslock>
    80002ac4:	9f8fe0ef          	jal	80000cbc <release>
  return xticks;
}
    80002ac8:	02049513          	slli	a0,s1,0x20
    80002acc:	9101                	srli	a0,a0,0x20
    80002ace:	60e2                	ld	ra,24(sp)
    80002ad0:	6442                	ld	s0,16(sp)
    80002ad2:	64a2                	ld	s1,8(sp)
    80002ad4:	6105                	addi	sp,sp,32
    80002ad6:	8082                	ret

0000000080002ad8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ad8:	7179                	addi	sp,sp,-48
    80002ada:	f406                	sd	ra,40(sp)
    80002adc:	f022                	sd	s0,32(sp)
    80002ade:	ec26                	sd	s1,24(sp)
    80002ae0:	e84a                	sd	s2,16(sp)
    80002ae2:	e44e                	sd	s3,8(sp)
    80002ae4:	e052                	sd	s4,0(sp)
    80002ae6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ae8:	00005597          	auipc	a1,0x5
    80002aec:	8a858593          	addi	a1,a1,-1880 # 80007390 <etext+0x390>
    80002af0:	00013517          	auipc	a0,0x13
    80002af4:	cb050513          	addi	a0,a0,-848 # 800157a0 <bcache>
    80002af8:	8a6fe0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002afc:	0001b797          	auipc	a5,0x1b
    80002b00:	ca478793          	addi	a5,a5,-860 # 8001d7a0 <bcache+0x8000>
    80002b04:	0001b717          	auipc	a4,0x1b
    80002b08:	f0470713          	addi	a4,a4,-252 # 8001da08 <bcache+0x8268>
    80002b0c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b10:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b14:	00013497          	auipc	s1,0x13
    80002b18:	ca448493          	addi	s1,s1,-860 # 800157b8 <bcache+0x18>
    b->next = bcache.head.next;
    80002b1c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b1e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b20:	00005a17          	auipc	s4,0x5
    80002b24:	878a0a13          	addi	s4,s4,-1928 # 80007398 <etext+0x398>
    b->next = bcache.head.next;
    80002b28:	2b893783          	ld	a5,696(s2)
    80002b2c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b2e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b32:	85d2                	mv	a1,s4
    80002b34:	01048513          	addi	a0,s1,16
    80002b38:	328010ef          	jal	80003e60 <initsleeplock>
    bcache.head.next->prev = b;
    80002b3c:	2b893783          	ld	a5,696(s2)
    80002b40:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b42:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b46:	45848493          	addi	s1,s1,1112
    80002b4a:	fd349fe3          	bne	s1,s3,80002b28 <binit+0x50>
  }
}
    80002b4e:	70a2                	ld	ra,40(sp)
    80002b50:	7402                	ld	s0,32(sp)
    80002b52:	64e2                	ld	s1,24(sp)
    80002b54:	6942                	ld	s2,16(sp)
    80002b56:	69a2                	ld	s3,8(sp)
    80002b58:	6a02                	ld	s4,0(sp)
    80002b5a:	6145                	addi	sp,sp,48
    80002b5c:	8082                	ret

0000000080002b5e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b5e:	7179                	addi	sp,sp,-48
    80002b60:	f406                	sd	ra,40(sp)
    80002b62:	f022                	sd	s0,32(sp)
    80002b64:	ec26                	sd	s1,24(sp)
    80002b66:	e84a                	sd	s2,16(sp)
    80002b68:	e44e                	sd	s3,8(sp)
    80002b6a:	1800                	addi	s0,sp,48
    80002b6c:	892a                	mv	s2,a0
    80002b6e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b70:	00013517          	auipc	a0,0x13
    80002b74:	c3050513          	addi	a0,a0,-976 # 800157a0 <bcache>
    80002b78:	8b0fe0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b7c:	0001b497          	auipc	s1,0x1b
    80002b80:	edc4b483          	ld	s1,-292(s1) # 8001da58 <bcache+0x82b8>
    80002b84:	0001b797          	auipc	a5,0x1b
    80002b88:	e8478793          	addi	a5,a5,-380 # 8001da08 <bcache+0x8268>
    80002b8c:	02f48b63          	beq	s1,a5,80002bc2 <bread+0x64>
    80002b90:	873e                	mv	a4,a5
    80002b92:	a021                	j	80002b9a <bread+0x3c>
    80002b94:	68a4                	ld	s1,80(s1)
    80002b96:	02e48663          	beq	s1,a4,80002bc2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002b9a:	449c                	lw	a5,8(s1)
    80002b9c:	ff279ce3          	bne	a5,s2,80002b94 <bread+0x36>
    80002ba0:	44dc                	lw	a5,12(s1)
    80002ba2:	ff3799e3          	bne	a5,s3,80002b94 <bread+0x36>
      b->refcnt++;
    80002ba6:	40bc                	lw	a5,64(s1)
    80002ba8:	2785                	addiw	a5,a5,1
    80002baa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bac:	00013517          	auipc	a0,0x13
    80002bb0:	bf450513          	addi	a0,a0,-1036 # 800157a0 <bcache>
    80002bb4:	908fe0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002bb8:	01048513          	addi	a0,s1,16
    80002bbc:	2da010ef          	jal	80003e96 <acquiresleep>
      return b;
    80002bc0:	a889                	j	80002c12 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bc2:	0001b497          	auipc	s1,0x1b
    80002bc6:	e8e4b483          	ld	s1,-370(s1) # 8001da50 <bcache+0x82b0>
    80002bca:	0001b797          	auipc	a5,0x1b
    80002bce:	e3e78793          	addi	a5,a5,-450 # 8001da08 <bcache+0x8268>
    80002bd2:	00f48863          	beq	s1,a5,80002be2 <bread+0x84>
    80002bd6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002bd8:	40bc                	lw	a5,64(s1)
    80002bda:	cb91                	beqz	a5,80002bee <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bdc:	64a4                	ld	s1,72(s1)
    80002bde:	fee49de3          	bne	s1,a4,80002bd8 <bread+0x7a>
  panic("bget: no buffers");
    80002be2:	00004517          	auipc	a0,0x4
    80002be6:	7be50513          	addi	a0,a0,1982 # 800073a0 <etext+0x3a0>
    80002bea:	c3bfd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80002bee:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002bf2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002bf6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002bfa:	4785                	li	a5,1
    80002bfc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bfe:	00013517          	auipc	a0,0x13
    80002c02:	ba250513          	addi	a0,a0,-1118 # 800157a0 <bcache>
    80002c06:	8b6fe0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002c0a:	01048513          	addi	a0,s1,16
    80002c0e:	288010ef          	jal	80003e96 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c12:	409c                	lw	a5,0(s1)
    80002c14:	cb89                	beqz	a5,80002c26 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c16:	8526                	mv	a0,s1
    80002c18:	70a2                	ld	ra,40(sp)
    80002c1a:	7402                	ld	s0,32(sp)
    80002c1c:	64e2                	ld	s1,24(sp)
    80002c1e:	6942                	ld	s2,16(sp)
    80002c20:	69a2                	ld	s3,8(sp)
    80002c22:	6145                	addi	sp,sp,48
    80002c24:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c26:	4581                	li	a1,0
    80002c28:	8526                	mv	a0,s1
    80002c2a:	2e7020ef          	jal	80005710 <virtio_disk_rw>
    b->valid = 1;
    80002c2e:	4785                	li	a5,1
    80002c30:	c09c                	sw	a5,0(s1)
  return b;
    80002c32:	b7d5                	j	80002c16 <bread+0xb8>

0000000080002c34 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c34:	1101                	addi	sp,sp,-32
    80002c36:	ec06                	sd	ra,24(sp)
    80002c38:	e822                	sd	s0,16(sp)
    80002c3a:	e426                	sd	s1,8(sp)
    80002c3c:	1000                	addi	s0,sp,32
    80002c3e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c40:	0541                	addi	a0,a0,16
    80002c42:	2d2010ef          	jal	80003f14 <holdingsleep>
    80002c46:	c911                	beqz	a0,80002c5a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c48:	4585                	li	a1,1
    80002c4a:	8526                	mv	a0,s1
    80002c4c:	2c5020ef          	jal	80005710 <virtio_disk_rw>
}
    80002c50:	60e2                	ld	ra,24(sp)
    80002c52:	6442                	ld	s0,16(sp)
    80002c54:	64a2                	ld	s1,8(sp)
    80002c56:	6105                	addi	sp,sp,32
    80002c58:	8082                	ret
    panic("bwrite");
    80002c5a:	00004517          	auipc	a0,0x4
    80002c5e:	75e50513          	addi	a0,a0,1886 # 800073b8 <etext+0x3b8>
    80002c62:	bc3fd0ef          	jal	80000824 <panic>

0000000080002c66 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c66:	1101                	addi	sp,sp,-32
    80002c68:	ec06                	sd	ra,24(sp)
    80002c6a:	e822                	sd	s0,16(sp)
    80002c6c:	e426                	sd	s1,8(sp)
    80002c6e:	e04a                	sd	s2,0(sp)
    80002c70:	1000                	addi	s0,sp,32
    80002c72:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c74:	01050913          	addi	s2,a0,16
    80002c78:	854a                	mv	a0,s2
    80002c7a:	29a010ef          	jal	80003f14 <holdingsleep>
    80002c7e:	c125                	beqz	a0,80002cde <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002c80:	854a                	mv	a0,s2
    80002c82:	25a010ef          	jal	80003edc <releasesleep>

  acquire(&bcache.lock);
    80002c86:	00013517          	auipc	a0,0x13
    80002c8a:	b1a50513          	addi	a0,a0,-1254 # 800157a0 <bcache>
    80002c8e:	f9bfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002c92:	40bc                	lw	a5,64(s1)
    80002c94:	37fd                	addiw	a5,a5,-1
    80002c96:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002c98:	e79d                	bnez	a5,80002cc6 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002c9a:	68b8                	ld	a4,80(s1)
    80002c9c:	64bc                	ld	a5,72(s1)
    80002c9e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002ca0:	68b8                	ld	a4,80(s1)
    80002ca2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002ca4:	0001b797          	auipc	a5,0x1b
    80002ca8:	afc78793          	addi	a5,a5,-1284 # 8001d7a0 <bcache+0x8000>
    80002cac:	2b87b703          	ld	a4,696(a5)
    80002cb0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002cb2:	0001b717          	auipc	a4,0x1b
    80002cb6:	d5670713          	addi	a4,a4,-682 # 8001da08 <bcache+0x8268>
    80002cba:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cbc:	2b87b703          	ld	a4,696(a5)
    80002cc0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002cc2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002cc6:	00013517          	auipc	a0,0x13
    80002cca:	ada50513          	addi	a0,a0,-1318 # 800157a0 <bcache>
    80002cce:	feffd0ef          	jal	80000cbc <release>
}
    80002cd2:	60e2                	ld	ra,24(sp)
    80002cd4:	6442                	ld	s0,16(sp)
    80002cd6:	64a2                	ld	s1,8(sp)
    80002cd8:	6902                	ld	s2,0(sp)
    80002cda:	6105                	addi	sp,sp,32
    80002cdc:	8082                	ret
    panic("brelse");
    80002cde:	00004517          	auipc	a0,0x4
    80002ce2:	6e250513          	addi	a0,a0,1762 # 800073c0 <etext+0x3c0>
    80002ce6:	b3ffd0ef          	jal	80000824 <panic>

0000000080002cea <bpin>:

void
bpin(struct buf *b) {
    80002cea:	1101                	addi	sp,sp,-32
    80002cec:	ec06                	sd	ra,24(sp)
    80002cee:	e822                	sd	s0,16(sp)
    80002cf0:	e426                	sd	s1,8(sp)
    80002cf2:	1000                	addi	s0,sp,32
    80002cf4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002cf6:	00013517          	auipc	a0,0x13
    80002cfa:	aaa50513          	addi	a0,a0,-1366 # 800157a0 <bcache>
    80002cfe:	f2bfd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    80002d02:	40bc                	lw	a5,64(s1)
    80002d04:	2785                	addiw	a5,a5,1
    80002d06:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d08:	00013517          	auipc	a0,0x13
    80002d0c:	a9850513          	addi	a0,a0,-1384 # 800157a0 <bcache>
    80002d10:	fadfd0ef          	jal	80000cbc <release>
}
    80002d14:	60e2                	ld	ra,24(sp)
    80002d16:	6442                	ld	s0,16(sp)
    80002d18:	64a2                	ld	s1,8(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret

0000000080002d1e <bunpin>:

void
bunpin(struct buf *b) {
    80002d1e:	1101                	addi	sp,sp,-32
    80002d20:	ec06                	sd	ra,24(sp)
    80002d22:	e822                	sd	s0,16(sp)
    80002d24:	e426                	sd	s1,8(sp)
    80002d26:	1000                	addi	s0,sp,32
    80002d28:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d2a:	00013517          	auipc	a0,0x13
    80002d2e:	a7650513          	addi	a0,a0,-1418 # 800157a0 <bcache>
    80002d32:	ef7fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002d36:	40bc                	lw	a5,64(s1)
    80002d38:	37fd                	addiw	a5,a5,-1
    80002d3a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d3c:	00013517          	auipc	a0,0x13
    80002d40:	a6450513          	addi	a0,a0,-1436 # 800157a0 <bcache>
    80002d44:	f79fd0ef          	jal	80000cbc <release>
}
    80002d48:	60e2                	ld	ra,24(sp)
    80002d4a:	6442                	ld	s0,16(sp)
    80002d4c:	64a2                	ld	s1,8(sp)
    80002d4e:	6105                	addi	sp,sp,32
    80002d50:	8082                	ret

0000000080002d52 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	e426                	sd	s1,8(sp)
    80002d5a:	e04a                	sd	s2,0(sp)
    80002d5c:	1000                	addi	s0,sp,32
    80002d5e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d60:	00d5d79b          	srliw	a5,a1,0xd
    80002d64:	0001b597          	auipc	a1,0x1b
    80002d68:	1185a583          	lw	a1,280(a1) # 8001de7c <sb+0x1c>
    80002d6c:	9dbd                	addw	a1,a1,a5
    80002d6e:	df1ff0ef          	jal	80002b5e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d72:	0074f713          	andi	a4,s1,7
    80002d76:	4785                	li	a5,1
    80002d78:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002d7c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002d7e:	90d9                	srli	s1,s1,0x36
    80002d80:	00950733          	add	a4,a0,s1
    80002d84:	05874703          	lbu	a4,88(a4)
    80002d88:	00e7f6b3          	and	a3,a5,a4
    80002d8c:	c29d                	beqz	a3,80002db2 <bfree+0x60>
    80002d8e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002d90:	94aa                	add	s1,s1,a0
    80002d92:	fff7c793          	not	a5,a5
    80002d96:	8f7d                	and	a4,a4,a5
    80002d98:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002d9c:	000010ef          	jal	80003d9c <log_write>
  brelse(bp);
    80002da0:	854a                	mv	a0,s2
    80002da2:	ec5ff0ef          	jal	80002c66 <brelse>
}
    80002da6:	60e2                	ld	ra,24(sp)
    80002da8:	6442                	ld	s0,16(sp)
    80002daa:	64a2                	ld	s1,8(sp)
    80002dac:	6902                	ld	s2,0(sp)
    80002dae:	6105                	addi	sp,sp,32
    80002db0:	8082                	ret
    panic("freeing free block");
    80002db2:	00004517          	auipc	a0,0x4
    80002db6:	61650513          	addi	a0,a0,1558 # 800073c8 <etext+0x3c8>
    80002dba:	a6bfd0ef          	jal	80000824 <panic>

0000000080002dbe <balloc>:
{
    80002dbe:	715d                	addi	sp,sp,-80
    80002dc0:	e486                	sd	ra,72(sp)
    80002dc2:	e0a2                	sd	s0,64(sp)
    80002dc4:	fc26                	sd	s1,56(sp)
    80002dc6:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002dc8:	0001b797          	auipc	a5,0x1b
    80002dcc:	09c7a783          	lw	a5,156(a5) # 8001de64 <sb+0x4>
    80002dd0:	0e078263          	beqz	a5,80002eb4 <balloc+0xf6>
    80002dd4:	f84a                	sd	s2,48(sp)
    80002dd6:	f44e                	sd	s3,40(sp)
    80002dd8:	f052                	sd	s4,32(sp)
    80002dda:	ec56                	sd	s5,24(sp)
    80002ddc:	e85a                	sd	s6,16(sp)
    80002dde:	e45e                	sd	s7,8(sp)
    80002de0:	e062                	sd	s8,0(sp)
    80002de2:	8baa                	mv	s7,a0
    80002de4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002de6:	0001bb17          	auipc	s6,0x1b
    80002dea:	07ab0b13          	addi	s6,s6,122 # 8001de60 <sb>
      m = 1 << (bi % 8);
    80002dee:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002df0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002df2:	6c09                	lui	s8,0x2
    80002df4:	a09d                	j	80002e5a <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002df6:	97ca                	add	a5,a5,s2
    80002df8:	8e55                	or	a2,a2,a3
    80002dfa:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002dfe:	854a                	mv	a0,s2
    80002e00:	79d000ef          	jal	80003d9c <log_write>
        brelse(bp);
    80002e04:	854a                	mv	a0,s2
    80002e06:	e61ff0ef          	jal	80002c66 <brelse>
  bp = bread(dev, bno);
    80002e0a:	85a6                	mv	a1,s1
    80002e0c:	855e                	mv	a0,s7
    80002e0e:	d51ff0ef          	jal	80002b5e <bread>
    80002e12:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e14:	40000613          	li	a2,1024
    80002e18:	4581                	li	a1,0
    80002e1a:	05850513          	addi	a0,a0,88
    80002e1e:	edbfd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80002e22:	854a                	mv	a0,s2
    80002e24:	779000ef          	jal	80003d9c <log_write>
  brelse(bp);
    80002e28:	854a                	mv	a0,s2
    80002e2a:	e3dff0ef          	jal	80002c66 <brelse>
}
    80002e2e:	7942                	ld	s2,48(sp)
    80002e30:	79a2                	ld	s3,40(sp)
    80002e32:	7a02                	ld	s4,32(sp)
    80002e34:	6ae2                	ld	s5,24(sp)
    80002e36:	6b42                	ld	s6,16(sp)
    80002e38:	6ba2                	ld	s7,8(sp)
    80002e3a:	6c02                	ld	s8,0(sp)
}
    80002e3c:	8526                	mv	a0,s1
    80002e3e:	60a6                	ld	ra,72(sp)
    80002e40:	6406                	ld	s0,64(sp)
    80002e42:	74e2                	ld	s1,56(sp)
    80002e44:	6161                	addi	sp,sp,80
    80002e46:	8082                	ret
    brelse(bp);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	e1dff0ef          	jal	80002c66 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e4e:	015c0abb          	addw	s5,s8,s5
    80002e52:	004b2783          	lw	a5,4(s6)
    80002e56:	04faf863          	bgeu	s5,a5,80002ea6 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002e5a:	40dad59b          	sraiw	a1,s5,0xd
    80002e5e:	01cb2783          	lw	a5,28(s6)
    80002e62:	9dbd                	addw	a1,a1,a5
    80002e64:	855e                	mv	a0,s7
    80002e66:	cf9ff0ef          	jal	80002b5e <bread>
    80002e6a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e6c:	004b2503          	lw	a0,4(s6)
    80002e70:	84d6                	mv	s1,s5
    80002e72:	4701                	li	a4,0
    80002e74:	fca4fae3          	bgeu	s1,a0,80002e48 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002e78:	00777693          	andi	a3,a4,7
    80002e7c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002e80:	41f7579b          	sraiw	a5,a4,0x1f
    80002e84:	01d7d79b          	srliw	a5,a5,0x1d
    80002e88:	9fb9                	addw	a5,a5,a4
    80002e8a:	4037d79b          	sraiw	a5,a5,0x3
    80002e8e:	00f90633          	add	a2,s2,a5
    80002e92:	05864603          	lbu	a2,88(a2)
    80002e96:	00c6f5b3          	and	a1,a3,a2
    80002e9a:	ddb1                	beqz	a1,80002df6 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e9c:	2705                	addiw	a4,a4,1
    80002e9e:	2485                	addiw	s1,s1,1
    80002ea0:	fd471ae3          	bne	a4,s4,80002e74 <balloc+0xb6>
    80002ea4:	b755                	j	80002e48 <balloc+0x8a>
    80002ea6:	7942                	ld	s2,48(sp)
    80002ea8:	79a2                	ld	s3,40(sp)
    80002eaa:	7a02                	ld	s4,32(sp)
    80002eac:	6ae2                	ld	s5,24(sp)
    80002eae:	6b42                	ld	s6,16(sp)
    80002eb0:	6ba2                	ld	s7,8(sp)
    80002eb2:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002eb4:	00004517          	auipc	a0,0x4
    80002eb8:	52c50513          	addi	a0,a0,1324 # 800073e0 <etext+0x3e0>
    80002ebc:	e3efd0ef          	jal	800004fa <printf>
  return 0;
    80002ec0:	4481                	li	s1,0
    80002ec2:	bfad                	j	80002e3c <balloc+0x7e>

0000000080002ec4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ec4:	7179                	addi	sp,sp,-48
    80002ec6:	f406                	sd	ra,40(sp)
    80002ec8:	f022                	sd	s0,32(sp)
    80002eca:	ec26                	sd	s1,24(sp)
    80002ecc:	e84a                	sd	s2,16(sp)
    80002ece:	e44e                	sd	s3,8(sp)
    80002ed0:	1800                	addi	s0,sp,48
    80002ed2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002ed4:	47ad                	li	a5,11
    80002ed6:	02b7e363          	bltu	a5,a1,80002efc <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002eda:	02059793          	slli	a5,a1,0x20
    80002ede:	01e7d593          	srli	a1,a5,0x1e
    80002ee2:	00b509b3          	add	s3,a0,a1
    80002ee6:	0509a483          	lw	s1,80(s3)
    80002eea:	e0b5                	bnez	s1,80002f4e <bmap+0x8a>
      addr = balloc(ip->dev);
    80002eec:	4108                	lw	a0,0(a0)
    80002eee:	ed1ff0ef          	jal	80002dbe <balloc>
    80002ef2:	84aa                	mv	s1,a0
      if(addr == 0)
    80002ef4:	cd29                	beqz	a0,80002f4e <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002ef6:	04a9a823          	sw	a0,80(s3)
    80002efa:	a891                	j	80002f4e <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002efc:	ff45879b          	addiw	a5,a1,-12
    80002f00:	873e                	mv	a4,a5
    80002f02:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002f04:	0ff00793          	li	a5,255
    80002f08:	06e7e763          	bltu	a5,a4,80002f76 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f0c:	08052483          	lw	s1,128(a0)
    80002f10:	e891                	bnez	s1,80002f24 <bmap+0x60>
      addr = balloc(ip->dev);
    80002f12:	4108                	lw	a0,0(a0)
    80002f14:	eabff0ef          	jal	80002dbe <balloc>
    80002f18:	84aa                	mv	s1,a0
      if(addr == 0)
    80002f1a:	c915                	beqz	a0,80002f4e <bmap+0x8a>
    80002f1c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f1e:	08a92023          	sw	a0,128(s2)
    80002f22:	a011                	j	80002f26 <bmap+0x62>
    80002f24:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f26:	85a6                	mv	a1,s1
    80002f28:	00092503          	lw	a0,0(s2)
    80002f2c:	c33ff0ef          	jal	80002b5e <bread>
    80002f30:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f32:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f36:	02099713          	slli	a4,s3,0x20
    80002f3a:	01e75593          	srli	a1,a4,0x1e
    80002f3e:	97ae                	add	a5,a5,a1
    80002f40:	89be                	mv	s3,a5
    80002f42:	4384                	lw	s1,0(a5)
    80002f44:	cc89                	beqz	s1,80002f5e <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f46:	8552                	mv	a0,s4
    80002f48:	d1fff0ef          	jal	80002c66 <brelse>
    return addr;
    80002f4c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f4e:	8526                	mv	a0,s1
    80002f50:	70a2                	ld	ra,40(sp)
    80002f52:	7402                	ld	s0,32(sp)
    80002f54:	64e2                	ld	s1,24(sp)
    80002f56:	6942                	ld	s2,16(sp)
    80002f58:	69a2                	ld	s3,8(sp)
    80002f5a:	6145                	addi	sp,sp,48
    80002f5c:	8082                	ret
      addr = balloc(ip->dev);
    80002f5e:	00092503          	lw	a0,0(s2)
    80002f62:	e5dff0ef          	jal	80002dbe <balloc>
    80002f66:	84aa                	mv	s1,a0
      if(addr){
    80002f68:	dd79                	beqz	a0,80002f46 <bmap+0x82>
        a[bn] = addr;
    80002f6a:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002f6e:	8552                	mv	a0,s4
    80002f70:	62d000ef          	jal	80003d9c <log_write>
    80002f74:	bfc9                	j	80002f46 <bmap+0x82>
    80002f76:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002f78:	00004517          	auipc	a0,0x4
    80002f7c:	48050513          	addi	a0,a0,1152 # 800073f8 <etext+0x3f8>
    80002f80:	8a5fd0ef          	jal	80000824 <panic>

0000000080002f84 <iget>:
{
    80002f84:	7179                	addi	sp,sp,-48
    80002f86:	f406                	sd	ra,40(sp)
    80002f88:	f022                	sd	s0,32(sp)
    80002f8a:	ec26                	sd	s1,24(sp)
    80002f8c:	e84a                	sd	s2,16(sp)
    80002f8e:	e44e                	sd	s3,8(sp)
    80002f90:	e052                	sd	s4,0(sp)
    80002f92:	1800                	addi	s0,sp,48
    80002f94:	892a                	mv	s2,a0
    80002f96:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002f98:	0001b517          	auipc	a0,0x1b
    80002f9c:	ee850513          	addi	a0,a0,-280 # 8001de80 <itable>
    80002fa0:	c89fd0ef          	jal	80000c28 <acquire>
  empty = 0;
    80002fa4:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fa6:	0001b497          	auipc	s1,0x1b
    80002faa:	ef248493          	addi	s1,s1,-270 # 8001de98 <itable+0x18>
    80002fae:	0001d697          	auipc	a3,0x1d
    80002fb2:	97a68693          	addi	a3,a3,-1670 # 8001f928 <log>
    80002fb6:	a809                	j	80002fc8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fb8:	e781                	bnez	a5,80002fc0 <iget+0x3c>
    80002fba:	00099363          	bnez	s3,80002fc0 <iget+0x3c>
      empty = ip;
    80002fbe:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fc0:	08848493          	addi	s1,s1,136
    80002fc4:	02d48563          	beq	s1,a3,80002fee <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002fc8:	449c                	lw	a5,8(s1)
    80002fca:	fef057e3          	blez	a5,80002fb8 <iget+0x34>
    80002fce:	4098                	lw	a4,0(s1)
    80002fd0:	ff2718e3          	bne	a4,s2,80002fc0 <iget+0x3c>
    80002fd4:	40d8                	lw	a4,4(s1)
    80002fd6:	ff4715e3          	bne	a4,s4,80002fc0 <iget+0x3c>
      ip->ref++;
    80002fda:	2785                	addiw	a5,a5,1
    80002fdc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002fde:	0001b517          	auipc	a0,0x1b
    80002fe2:	ea250513          	addi	a0,a0,-350 # 8001de80 <itable>
    80002fe6:	cd7fd0ef          	jal	80000cbc <release>
      return ip;
    80002fea:	89a6                	mv	s3,s1
    80002fec:	a015                	j	80003010 <iget+0x8c>
  if(empty == 0)
    80002fee:	02098a63          	beqz	s3,80003022 <iget+0x9e>
  ip->dev = dev;
    80002ff2:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002ff6:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002ffa:	4785                	li	a5,1
    80002ffc:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003000:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003004:	0001b517          	auipc	a0,0x1b
    80003008:	e7c50513          	addi	a0,a0,-388 # 8001de80 <itable>
    8000300c:	cb1fd0ef          	jal	80000cbc <release>
}
    80003010:	854e                	mv	a0,s3
    80003012:	70a2                	ld	ra,40(sp)
    80003014:	7402                	ld	s0,32(sp)
    80003016:	64e2                	ld	s1,24(sp)
    80003018:	6942                	ld	s2,16(sp)
    8000301a:	69a2                	ld	s3,8(sp)
    8000301c:	6a02                	ld	s4,0(sp)
    8000301e:	6145                	addi	sp,sp,48
    80003020:	8082                	ret
    panic("iget: no inodes");
    80003022:	00004517          	auipc	a0,0x4
    80003026:	3ee50513          	addi	a0,a0,1006 # 80007410 <etext+0x410>
    8000302a:	ffafd0ef          	jal	80000824 <panic>

000000008000302e <iinit>:
{
    8000302e:	7179                	addi	sp,sp,-48
    80003030:	f406                	sd	ra,40(sp)
    80003032:	f022                	sd	s0,32(sp)
    80003034:	ec26                	sd	s1,24(sp)
    80003036:	e84a                	sd	s2,16(sp)
    80003038:	e44e                	sd	s3,8(sp)
    8000303a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000303c:	00004597          	auipc	a1,0x4
    80003040:	3e458593          	addi	a1,a1,996 # 80007420 <etext+0x420>
    80003044:	0001b517          	auipc	a0,0x1b
    80003048:	e3c50513          	addi	a0,a0,-452 # 8001de80 <itable>
    8000304c:	b53fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    80003050:	0001b497          	auipc	s1,0x1b
    80003054:	e5848493          	addi	s1,s1,-424 # 8001dea8 <itable+0x28>
    80003058:	0001d997          	auipc	s3,0x1d
    8000305c:	8e098993          	addi	s3,s3,-1824 # 8001f938 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003060:	00004917          	auipc	s2,0x4
    80003064:	3c890913          	addi	s2,s2,968 # 80007428 <etext+0x428>
    80003068:	85ca                	mv	a1,s2
    8000306a:	8526                	mv	a0,s1
    8000306c:	5f5000ef          	jal	80003e60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003070:	08848493          	addi	s1,s1,136
    80003074:	ff349ae3          	bne	s1,s3,80003068 <iinit+0x3a>
}
    80003078:	70a2                	ld	ra,40(sp)
    8000307a:	7402                	ld	s0,32(sp)
    8000307c:	64e2                	ld	s1,24(sp)
    8000307e:	6942                	ld	s2,16(sp)
    80003080:	69a2                	ld	s3,8(sp)
    80003082:	6145                	addi	sp,sp,48
    80003084:	8082                	ret

0000000080003086 <ialloc>:
{
    80003086:	7139                	addi	sp,sp,-64
    80003088:	fc06                	sd	ra,56(sp)
    8000308a:	f822                	sd	s0,48(sp)
    8000308c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000308e:	0001b717          	auipc	a4,0x1b
    80003092:	dde72703          	lw	a4,-546(a4) # 8001de6c <sb+0xc>
    80003096:	4785                	li	a5,1
    80003098:	06e7f063          	bgeu	a5,a4,800030f8 <ialloc+0x72>
    8000309c:	f426                	sd	s1,40(sp)
    8000309e:	f04a                	sd	s2,32(sp)
    800030a0:	ec4e                	sd	s3,24(sp)
    800030a2:	e852                	sd	s4,16(sp)
    800030a4:	e456                	sd	s5,8(sp)
    800030a6:	e05a                	sd	s6,0(sp)
    800030a8:	8aaa                	mv	s5,a0
    800030aa:	8b2e                	mv	s6,a1
    800030ac:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800030ae:	0001ba17          	auipc	s4,0x1b
    800030b2:	db2a0a13          	addi	s4,s4,-590 # 8001de60 <sb>
    800030b6:	00495593          	srli	a1,s2,0x4
    800030ba:	018a2783          	lw	a5,24(s4)
    800030be:	9dbd                	addw	a1,a1,a5
    800030c0:	8556                	mv	a0,s5
    800030c2:	a9dff0ef          	jal	80002b5e <bread>
    800030c6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800030c8:	05850993          	addi	s3,a0,88
    800030cc:	00f97793          	andi	a5,s2,15
    800030d0:	079a                	slli	a5,a5,0x6
    800030d2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800030d4:	00099783          	lh	a5,0(s3)
    800030d8:	cb9d                	beqz	a5,8000310e <ialloc+0x88>
    brelse(bp);
    800030da:	b8dff0ef          	jal	80002c66 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800030de:	0905                	addi	s2,s2,1
    800030e0:	00ca2703          	lw	a4,12(s4)
    800030e4:	0009079b          	sext.w	a5,s2
    800030e8:	fce7e7e3          	bltu	a5,a4,800030b6 <ialloc+0x30>
    800030ec:	74a2                	ld	s1,40(sp)
    800030ee:	7902                	ld	s2,32(sp)
    800030f0:	69e2                	ld	s3,24(sp)
    800030f2:	6a42                	ld	s4,16(sp)
    800030f4:	6aa2                	ld	s5,8(sp)
    800030f6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800030f8:	00004517          	auipc	a0,0x4
    800030fc:	33850513          	addi	a0,a0,824 # 80007430 <etext+0x430>
    80003100:	bfafd0ef          	jal	800004fa <printf>
  return 0;
    80003104:	4501                	li	a0,0
}
    80003106:	70e2                	ld	ra,56(sp)
    80003108:	7442                	ld	s0,48(sp)
    8000310a:	6121                	addi	sp,sp,64
    8000310c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000310e:	04000613          	li	a2,64
    80003112:	4581                	li	a1,0
    80003114:	854e                	mv	a0,s3
    80003116:	be3fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    8000311a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000311e:	8526                	mv	a0,s1
    80003120:	47d000ef          	jal	80003d9c <log_write>
      brelse(bp);
    80003124:	8526                	mv	a0,s1
    80003126:	b41ff0ef          	jal	80002c66 <brelse>
      return iget(dev, inum);
    8000312a:	0009059b          	sext.w	a1,s2
    8000312e:	8556                	mv	a0,s5
    80003130:	e55ff0ef          	jal	80002f84 <iget>
    80003134:	74a2                	ld	s1,40(sp)
    80003136:	7902                	ld	s2,32(sp)
    80003138:	69e2                	ld	s3,24(sp)
    8000313a:	6a42                	ld	s4,16(sp)
    8000313c:	6aa2                	ld	s5,8(sp)
    8000313e:	6b02                	ld	s6,0(sp)
    80003140:	b7d9                	j	80003106 <ialloc+0x80>

0000000080003142 <iupdate>:
{
    80003142:	1101                	addi	sp,sp,-32
    80003144:	ec06                	sd	ra,24(sp)
    80003146:	e822                	sd	s0,16(sp)
    80003148:	e426                	sd	s1,8(sp)
    8000314a:	e04a                	sd	s2,0(sp)
    8000314c:	1000                	addi	s0,sp,32
    8000314e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003150:	415c                	lw	a5,4(a0)
    80003152:	0047d79b          	srliw	a5,a5,0x4
    80003156:	0001b597          	auipc	a1,0x1b
    8000315a:	d225a583          	lw	a1,-734(a1) # 8001de78 <sb+0x18>
    8000315e:	9dbd                	addw	a1,a1,a5
    80003160:	4108                	lw	a0,0(a0)
    80003162:	9fdff0ef          	jal	80002b5e <bread>
    80003166:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003168:	05850793          	addi	a5,a0,88
    8000316c:	40d8                	lw	a4,4(s1)
    8000316e:	8b3d                	andi	a4,a4,15
    80003170:	071a                	slli	a4,a4,0x6
    80003172:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003174:	04449703          	lh	a4,68(s1)
    80003178:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000317c:	04649703          	lh	a4,70(s1)
    80003180:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003184:	04849703          	lh	a4,72(s1)
    80003188:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000318c:	04a49703          	lh	a4,74(s1)
    80003190:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003194:	44f8                	lw	a4,76(s1)
    80003196:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003198:	03400613          	li	a2,52
    8000319c:	05048593          	addi	a1,s1,80
    800031a0:	00c78513          	addi	a0,a5,12
    800031a4:	bb5fd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    800031a8:	854a                	mv	a0,s2
    800031aa:	3f3000ef          	jal	80003d9c <log_write>
  brelse(bp);
    800031ae:	854a                	mv	a0,s2
    800031b0:	ab7ff0ef          	jal	80002c66 <brelse>
}
    800031b4:	60e2                	ld	ra,24(sp)
    800031b6:	6442                	ld	s0,16(sp)
    800031b8:	64a2                	ld	s1,8(sp)
    800031ba:	6902                	ld	s2,0(sp)
    800031bc:	6105                	addi	sp,sp,32
    800031be:	8082                	ret

00000000800031c0 <idup>:
{
    800031c0:	1101                	addi	sp,sp,-32
    800031c2:	ec06                	sd	ra,24(sp)
    800031c4:	e822                	sd	s0,16(sp)
    800031c6:	e426                	sd	s1,8(sp)
    800031c8:	1000                	addi	s0,sp,32
    800031ca:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800031cc:	0001b517          	auipc	a0,0x1b
    800031d0:	cb450513          	addi	a0,a0,-844 # 8001de80 <itable>
    800031d4:	a55fd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    800031d8:	449c                	lw	a5,8(s1)
    800031da:	2785                	addiw	a5,a5,1
    800031dc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800031de:	0001b517          	auipc	a0,0x1b
    800031e2:	ca250513          	addi	a0,a0,-862 # 8001de80 <itable>
    800031e6:	ad7fd0ef          	jal	80000cbc <release>
}
    800031ea:	8526                	mv	a0,s1
    800031ec:	60e2                	ld	ra,24(sp)
    800031ee:	6442                	ld	s0,16(sp)
    800031f0:	64a2                	ld	s1,8(sp)
    800031f2:	6105                	addi	sp,sp,32
    800031f4:	8082                	ret

00000000800031f6 <ilock>:
{
    800031f6:	1101                	addi	sp,sp,-32
    800031f8:	ec06                	sd	ra,24(sp)
    800031fa:	e822                	sd	s0,16(sp)
    800031fc:	e426                	sd	s1,8(sp)
    800031fe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003200:	cd19                	beqz	a0,8000321e <ilock+0x28>
    80003202:	84aa                	mv	s1,a0
    80003204:	451c                	lw	a5,8(a0)
    80003206:	00f05c63          	blez	a5,8000321e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000320a:	0541                	addi	a0,a0,16
    8000320c:	48b000ef          	jal	80003e96 <acquiresleep>
  if(ip->valid == 0){
    80003210:	40bc                	lw	a5,64(s1)
    80003212:	cf89                	beqz	a5,8000322c <ilock+0x36>
}
    80003214:	60e2                	ld	ra,24(sp)
    80003216:	6442                	ld	s0,16(sp)
    80003218:	64a2                	ld	s1,8(sp)
    8000321a:	6105                	addi	sp,sp,32
    8000321c:	8082                	ret
    8000321e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003220:	00004517          	auipc	a0,0x4
    80003224:	22850513          	addi	a0,a0,552 # 80007448 <etext+0x448>
    80003228:	dfcfd0ef          	jal	80000824 <panic>
    8000322c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000322e:	40dc                	lw	a5,4(s1)
    80003230:	0047d79b          	srliw	a5,a5,0x4
    80003234:	0001b597          	auipc	a1,0x1b
    80003238:	c445a583          	lw	a1,-956(a1) # 8001de78 <sb+0x18>
    8000323c:	9dbd                	addw	a1,a1,a5
    8000323e:	4088                	lw	a0,0(s1)
    80003240:	91fff0ef          	jal	80002b5e <bread>
    80003244:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003246:	05850593          	addi	a1,a0,88
    8000324a:	40dc                	lw	a5,4(s1)
    8000324c:	8bbd                	andi	a5,a5,15
    8000324e:	079a                	slli	a5,a5,0x6
    80003250:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003252:	00059783          	lh	a5,0(a1)
    80003256:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000325a:	00259783          	lh	a5,2(a1)
    8000325e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003262:	00459783          	lh	a5,4(a1)
    80003266:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000326a:	00659783          	lh	a5,6(a1)
    8000326e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003272:	459c                	lw	a5,8(a1)
    80003274:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003276:	03400613          	li	a2,52
    8000327a:	05b1                	addi	a1,a1,12
    8000327c:	05048513          	addi	a0,s1,80
    80003280:	ad9fd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    80003284:	854a                	mv	a0,s2
    80003286:	9e1ff0ef          	jal	80002c66 <brelse>
    ip->valid = 1;
    8000328a:	4785                	li	a5,1
    8000328c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000328e:	04449783          	lh	a5,68(s1)
    80003292:	c399                	beqz	a5,80003298 <ilock+0xa2>
    80003294:	6902                	ld	s2,0(sp)
    80003296:	bfbd                	j	80003214 <ilock+0x1e>
      panic("ilock: no type");
    80003298:	00004517          	auipc	a0,0x4
    8000329c:	1b850513          	addi	a0,a0,440 # 80007450 <etext+0x450>
    800032a0:	d84fd0ef          	jal	80000824 <panic>

00000000800032a4 <iunlock>:
{
    800032a4:	1101                	addi	sp,sp,-32
    800032a6:	ec06                	sd	ra,24(sp)
    800032a8:	e822                	sd	s0,16(sp)
    800032aa:	e426                	sd	s1,8(sp)
    800032ac:	e04a                	sd	s2,0(sp)
    800032ae:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032b0:	c505                	beqz	a0,800032d8 <iunlock+0x34>
    800032b2:	84aa                	mv	s1,a0
    800032b4:	01050913          	addi	s2,a0,16
    800032b8:	854a                	mv	a0,s2
    800032ba:	45b000ef          	jal	80003f14 <holdingsleep>
    800032be:	cd09                	beqz	a0,800032d8 <iunlock+0x34>
    800032c0:	449c                	lw	a5,8(s1)
    800032c2:	00f05b63          	blez	a5,800032d8 <iunlock+0x34>
  releasesleep(&ip->lock);
    800032c6:	854a                	mv	a0,s2
    800032c8:	415000ef          	jal	80003edc <releasesleep>
}
    800032cc:	60e2                	ld	ra,24(sp)
    800032ce:	6442                	ld	s0,16(sp)
    800032d0:	64a2                	ld	s1,8(sp)
    800032d2:	6902                	ld	s2,0(sp)
    800032d4:	6105                	addi	sp,sp,32
    800032d6:	8082                	ret
    panic("iunlock");
    800032d8:	00004517          	auipc	a0,0x4
    800032dc:	18850513          	addi	a0,a0,392 # 80007460 <etext+0x460>
    800032e0:	d44fd0ef          	jal	80000824 <panic>

00000000800032e4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800032e4:	7179                	addi	sp,sp,-48
    800032e6:	f406                	sd	ra,40(sp)
    800032e8:	f022                	sd	s0,32(sp)
    800032ea:	ec26                	sd	s1,24(sp)
    800032ec:	e84a                	sd	s2,16(sp)
    800032ee:	e44e                	sd	s3,8(sp)
    800032f0:	1800                	addi	s0,sp,48
    800032f2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800032f4:	05050493          	addi	s1,a0,80
    800032f8:	08050913          	addi	s2,a0,128
    800032fc:	a021                	j	80003304 <itrunc+0x20>
    800032fe:	0491                	addi	s1,s1,4
    80003300:	01248b63          	beq	s1,s2,80003316 <itrunc+0x32>
    if(ip->addrs[i]){
    80003304:	408c                	lw	a1,0(s1)
    80003306:	dde5                	beqz	a1,800032fe <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003308:	0009a503          	lw	a0,0(s3)
    8000330c:	a47ff0ef          	jal	80002d52 <bfree>
      ip->addrs[i] = 0;
    80003310:	0004a023          	sw	zero,0(s1)
    80003314:	b7ed                	j	800032fe <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003316:	0809a583          	lw	a1,128(s3)
    8000331a:	ed89                	bnez	a1,80003334 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000331c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003320:	854e                	mv	a0,s3
    80003322:	e21ff0ef          	jal	80003142 <iupdate>
}
    80003326:	70a2                	ld	ra,40(sp)
    80003328:	7402                	ld	s0,32(sp)
    8000332a:	64e2                	ld	s1,24(sp)
    8000332c:	6942                	ld	s2,16(sp)
    8000332e:	69a2                	ld	s3,8(sp)
    80003330:	6145                	addi	sp,sp,48
    80003332:	8082                	ret
    80003334:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003336:	0009a503          	lw	a0,0(s3)
    8000333a:	825ff0ef          	jal	80002b5e <bread>
    8000333e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003340:	05850493          	addi	s1,a0,88
    80003344:	45850913          	addi	s2,a0,1112
    80003348:	a021                	j	80003350 <itrunc+0x6c>
    8000334a:	0491                	addi	s1,s1,4
    8000334c:	01248963          	beq	s1,s2,8000335e <itrunc+0x7a>
      if(a[j])
    80003350:	408c                	lw	a1,0(s1)
    80003352:	dde5                	beqz	a1,8000334a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003354:	0009a503          	lw	a0,0(s3)
    80003358:	9fbff0ef          	jal	80002d52 <bfree>
    8000335c:	b7fd                	j	8000334a <itrunc+0x66>
    brelse(bp);
    8000335e:	8552                	mv	a0,s4
    80003360:	907ff0ef          	jal	80002c66 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003364:	0809a583          	lw	a1,128(s3)
    80003368:	0009a503          	lw	a0,0(s3)
    8000336c:	9e7ff0ef          	jal	80002d52 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003370:	0809a023          	sw	zero,128(s3)
    80003374:	6a02                	ld	s4,0(sp)
    80003376:	b75d                	j	8000331c <itrunc+0x38>

0000000080003378 <iput>:
{
    80003378:	1101                	addi	sp,sp,-32
    8000337a:	ec06                	sd	ra,24(sp)
    8000337c:	e822                	sd	s0,16(sp)
    8000337e:	e426                	sd	s1,8(sp)
    80003380:	1000                	addi	s0,sp,32
    80003382:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003384:	0001b517          	auipc	a0,0x1b
    80003388:	afc50513          	addi	a0,a0,-1284 # 8001de80 <itable>
    8000338c:	89dfd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003390:	4498                	lw	a4,8(s1)
    80003392:	4785                	li	a5,1
    80003394:	02f70063          	beq	a4,a5,800033b4 <iput+0x3c>
  ip->ref--;
    80003398:	449c                	lw	a5,8(s1)
    8000339a:	37fd                	addiw	a5,a5,-1
    8000339c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000339e:	0001b517          	auipc	a0,0x1b
    800033a2:	ae250513          	addi	a0,a0,-1310 # 8001de80 <itable>
    800033a6:	917fd0ef          	jal	80000cbc <release>
}
    800033aa:	60e2                	ld	ra,24(sp)
    800033ac:	6442                	ld	s0,16(sp)
    800033ae:	64a2                	ld	s1,8(sp)
    800033b0:	6105                	addi	sp,sp,32
    800033b2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033b4:	40bc                	lw	a5,64(s1)
    800033b6:	d3ed                	beqz	a5,80003398 <iput+0x20>
    800033b8:	04a49783          	lh	a5,74(s1)
    800033bc:	fff1                	bnez	a5,80003398 <iput+0x20>
    800033be:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800033c0:	01048793          	addi	a5,s1,16
    800033c4:	893e                	mv	s2,a5
    800033c6:	853e                	mv	a0,a5
    800033c8:	2cf000ef          	jal	80003e96 <acquiresleep>
    release(&itable.lock);
    800033cc:	0001b517          	auipc	a0,0x1b
    800033d0:	ab450513          	addi	a0,a0,-1356 # 8001de80 <itable>
    800033d4:	8e9fd0ef          	jal	80000cbc <release>
    itrunc(ip);
    800033d8:	8526                	mv	a0,s1
    800033da:	f0bff0ef          	jal	800032e4 <itrunc>
    ip->type = 0;
    800033de:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800033e2:	8526                	mv	a0,s1
    800033e4:	d5fff0ef          	jal	80003142 <iupdate>
    ip->valid = 0;
    800033e8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800033ec:	854a                	mv	a0,s2
    800033ee:	2ef000ef          	jal	80003edc <releasesleep>
    acquire(&itable.lock);
    800033f2:	0001b517          	auipc	a0,0x1b
    800033f6:	a8e50513          	addi	a0,a0,-1394 # 8001de80 <itable>
    800033fa:	82ffd0ef          	jal	80000c28 <acquire>
    800033fe:	6902                	ld	s2,0(sp)
    80003400:	bf61                	j	80003398 <iput+0x20>

0000000080003402 <iunlockput>:
{
    80003402:	1101                	addi	sp,sp,-32
    80003404:	ec06                	sd	ra,24(sp)
    80003406:	e822                	sd	s0,16(sp)
    80003408:	e426                	sd	s1,8(sp)
    8000340a:	1000                	addi	s0,sp,32
    8000340c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000340e:	e97ff0ef          	jal	800032a4 <iunlock>
  iput(ip);
    80003412:	8526                	mv	a0,s1
    80003414:	f65ff0ef          	jal	80003378 <iput>
}
    80003418:	60e2                	ld	ra,24(sp)
    8000341a:	6442                	ld	s0,16(sp)
    8000341c:	64a2                	ld	s1,8(sp)
    8000341e:	6105                	addi	sp,sp,32
    80003420:	8082                	ret

0000000080003422 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003422:	0001b717          	auipc	a4,0x1b
    80003426:	a4a72703          	lw	a4,-1462(a4) # 8001de6c <sb+0xc>
    8000342a:	4785                	li	a5,1
    8000342c:	0ae7fe63          	bgeu	a5,a4,800034e8 <ireclaim+0xc6>
{
    80003430:	7139                	addi	sp,sp,-64
    80003432:	fc06                	sd	ra,56(sp)
    80003434:	f822                	sd	s0,48(sp)
    80003436:	f426                	sd	s1,40(sp)
    80003438:	f04a                	sd	s2,32(sp)
    8000343a:	ec4e                	sd	s3,24(sp)
    8000343c:	e852                	sd	s4,16(sp)
    8000343e:	e456                	sd	s5,8(sp)
    80003440:	e05a                	sd	s6,0(sp)
    80003442:	0080                	addi	s0,sp,64
    80003444:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003446:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003448:	0001ba17          	auipc	s4,0x1b
    8000344c:	a18a0a13          	addi	s4,s4,-1512 # 8001de60 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003450:	00004b17          	auipc	s6,0x4
    80003454:	018b0b13          	addi	s6,s6,24 # 80007468 <etext+0x468>
    80003458:	a099                	j	8000349e <ireclaim+0x7c>
    8000345a:	85ce                	mv	a1,s3
    8000345c:	855a                	mv	a0,s6
    8000345e:	89cfd0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003462:	85ce                	mv	a1,s3
    80003464:	8556                	mv	a0,s5
    80003466:	b1fff0ef          	jal	80002f84 <iget>
    8000346a:	89aa                	mv	s3,a0
    brelse(bp);
    8000346c:	854a                	mv	a0,s2
    8000346e:	ff8ff0ef          	jal	80002c66 <brelse>
    if (ip) {
    80003472:	00098f63          	beqz	s3,80003490 <ireclaim+0x6e>
      begin_op();
    80003476:	78c000ef          	jal	80003c02 <begin_op>
      ilock(ip);
    8000347a:	854e                	mv	a0,s3
    8000347c:	d7bff0ef          	jal	800031f6 <ilock>
      iunlock(ip);
    80003480:	854e                	mv	a0,s3
    80003482:	e23ff0ef          	jal	800032a4 <iunlock>
      iput(ip);
    80003486:	854e                	mv	a0,s3
    80003488:	ef1ff0ef          	jal	80003378 <iput>
      end_op();
    8000348c:	7e6000ef          	jal	80003c72 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003490:	0485                	addi	s1,s1,1
    80003492:	00ca2703          	lw	a4,12(s4)
    80003496:	0004879b          	sext.w	a5,s1
    8000349a:	02e7fd63          	bgeu	a5,a4,800034d4 <ireclaim+0xb2>
    8000349e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034a2:	0044d593          	srli	a1,s1,0x4
    800034a6:	018a2783          	lw	a5,24(s4)
    800034aa:	9dbd                	addw	a1,a1,a5
    800034ac:	8556                	mv	a0,s5
    800034ae:	eb0ff0ef          	jal	80002b5e <bread>
    800034b2:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800034b4:	05850793          	addi	a5,a0,88
    800034b8:	00f9f713          	andi	a4,s3,15
    800034bc:	071a                	slli	a4,a4,0x6
    800034be:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800034c0:	00079703          	lh	a4,0(a5)
    800034c4:	c701                	beqz	a4,800034cc <ireclaim+0xaa>
    800034c6:	00679783          	lh	a5,6(a5)
    800034ca:	dbc1                	beqz	a5,8000345a <ireclaim+0x38>
    brelse(bp);
    800034cc:	854a                	mv	a0,s2
    800034ce:	f98ff0ef          	jal	80002c66 <brelse>
    if (ip) {
    800034d2:	bf7d                	j	80003490 <ireclaim+0x6e>
}
    800034d4:	70e2                	ld	ra,56(sp)
    800034d6:	7442                	ld	s0,48(sp)
    800034d8:	74a2                	ld	s1,40(sp)
    800034da:	7902                	ld	s2,32(sp)
    800034dc:	69e2                	ld	s3,24(sp)
    800034de:	6a42                	ld	s4,16(sp)
    800034e0:	6aa2                	ld	s5,8(sp)
    800034e2:	6b02                	ld	s6,0(sp)
    800034e4:	6121                	addi	sp,sp,64
    800034e6:	8082                	ret
    800034e8:	8082                	ret

00000000800034ea <fsinit>:
fsinit(int dev) {
    800034ea:	1101                	addi	sp,sp,-32
    800034ec:	ec06                	sd	ra,24(sp)
    800034ee:	e822                	sd	s0,16(sp)
    800034f0:	e426                	sd	s1,8(sp)
    800034f2:	e04a                	sd	s2,0(sp)
    800034f4:	1000                	addi	s0,sp,32
    800034f6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034f8:	4585                	li	a1,1
    800034fa:	e64ff0ef          	jal	80002b5e <bread>
    800034fe:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003500:	02000613          	li	a2,32
    80003504:	05850593          	addi	a1,a0,88
    80003508:	0001b517          	auipc	a0,0x1b
    8000350c:	95850513          	addi	a0,a0,-1704 # 8001de60 <sb>
    80003510:	849fd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    80003514:	8526                	mv	a0,s1
    80003516:	f50ff0ef          	jal	80002c66 <brelse>
  if(sb.magic != FSMAGIC)
    8000351a:	0001b717          	auipc	a4,0x1b
    8000351e:	94672703          	lw	a4,-1722(a4) # 8001de60 <sb>
    80003522:	102037b7          	lui	a5,0x10203
    80003526:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000352a:	02f71263          	bne	a4,a5,8000354e <fsinit+0x64>
  initlog(dev, &sb);
    8000352e:	0001b597          	auipc	a1,0x1b
    80003532:	93258593          	addi	a1,a1,-1742 # 8001de60 <sb>
    80003536:	854a                	mv	a0,s2
    80003538:	648000ef          	jal	80003b80 <initlog>
  ireclaim(dev);
    8000353c:	854a                	mv	a0,s2
    8000353e:	ee5ff0ef          	jal	80003422 <ireclaim>
}
    80003542:	60e2                	ld	ra,24(sp)
    80003544:	6442                	ld	s0,16(sp)
    80003546:	64a2                	ld	s1,8(sp)
    80003548:	6902                	ld	s2,0(sp)
    8000354a:	6105                	addi	sp,sp,32
    8000354c:	8082                	ret
    panic("invalid file system");
    8000354e:	00004517          	auipc	a0,0x4
    80003552:	f3a50513          	addi	a0,a0,-198 # 80007488 <etext+0x488>
    80003556:	acefd0ef          	jal	80000824 <panic>

000000008000355a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000355a:	1141                	addi	sp,sp,-16
    8000355c:	e406                	sd	ra,8(sp)
    8000355e:	e022                	sd	s0,0(sp)
    80003560:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003562:	411c                	lw	a5,0(a0)
    80003564:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003566:	415c                	lw	a5,4(a0)
    80003568:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000356a:	04451783          	lh	a5,68(a0)
    8000356e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003572:	04a51783          	lh	a5,74(a0)
    80003576:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000357a:	04c56783          	lwu	a5,76(a0)
    8000357e:	e99c                	sd	a5,16(a1)
}
    80003580:	60a2                	ld	ra,8(sp)
    80003582:	6402                	ld	s0,0(sp)
    80003584:	0141                	addi	sp,sp,16
    80003586:	8082                	ret

0000000080003588 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003588:	457c                	lw	a5,76(a0)
    8000358a:	0ed7e663          	bltu	a5,a3,80003676 <readi+0xee>
{
    8000358e:	7159                	addi	sp,sp,-112
    80003590:	f486                	sd	ra,104(sp)
    80003592:	f0a2                	sd	s0,96(sp)
    80003594:	eca6                	sd	s1,88(sp)
    80003596:	e0d2                	sd	s4,64(sp)
    80003598:	fc56                	sd	s5,56(sp)
    8000359a:	f85a                	sd	s6,48(sp)
    8000359c:	f45e                	sd	s7,40(sp)
    8000359e:	1880                	addi	s0,sp,112
    800035a0:	8b2a                	mv	s6,a0
    800035a2:	8bae                	mv	s7,a1
    800035a4:	8a32                	mv	s4,a2
    800035a6:	84b6                	mv	s1,a3
    800035a8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800035aa:	9f35                	addw	a4,a4,a3
    return 0;
    800035ac:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800035ae:	0ad76b63          	bltu	a4,a3,80003664 <readi+0xdc>
    800035b2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800035b4:	00e7f463          	bgeu	a5,a4,800035bc <readi+0x34>
    n = ip->size - off;
    800035b8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035bc:	080a8b63          	beqz	s5,80003652 <readi+0xca>
    800035c0:	e8ca                	sd	s2,80(sp)
    800035c2:	f062                	sd	s8,32(sp)
    800035c4:	ec66                	sd	s9,24(sp)
    800035c6:	e86a                	sd	s10,16(sp)
    800035c8:	e46e                	sd	s11,8(sp)
    800035ca:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035cc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800035d0:	5c7d                	li	s8,-1
    800035d2:	a80d                	j	80003604 <readi+0x7c>
    800035d4:	020d1d93          	slli	s11,s10,0x20
    800035d8:	020ddd93          	srli	s11,s11,0x20
    800035dc:	05890613          	addi	a2,s2,88
    800035e0:	86ee                	mv	a3,s11
    800035e2:	963e                	add	a2,a2,a5
    800035e4:	85d2                	mv	a1,s4
    800035e6:	855e                	mv	a0,s7
    800035e8:	c9ffe0ef          	jal	80002286 <either_copyout>
    800035ec:	05850363          	beq	a0,s8,80003632 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800035f0:	854a                	mv	a0,s2
    800035f2:	e74ff0ef          	jal	80002c66 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035f6:	013d09bb          	addw	s3,s10,s3
    800035fa:	009d04bb          	addw	s1,s10,s1
    800035fe:	9a6e                	add	s4,s4,s11
    80003600:	0559f363          	bgeu	s3,s5,80003646 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003604:	00a4d59b          	srliw	a1,s1,0xa
    80003608:	855a                	mv	a0,s6
    8000360a:	8bbff0ef          	jal	80002ec4 <bmap>
    8000360e:	85aa                	mv	a1,a0
    if(addr == 0)
    80003610:	c139                	beqz	a0,80003656 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003612:	000b2503          	lw	a0,0(s6)
    80003616:	d48ff0ef          	jal	80002b5e <bread>
    8000361a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000361c:	3ff4f793          	andi	a5,s1,1023
    80003620:	40fc873b          	subw	a4,s9,a5
    80003624:	413a86bb          	subw	a3,s5,s3
    80003628:	8d3a                	mv	s10,a4
    8000362a:	fae6f5e3          	bgeu	a3,a4,800035d4 <readi+0x4c>
    8000362e:	8d36                	mv	s10,a3
    80003630:	b755                	j	800035d4 <readi+0x4c>
      brelse(bp);
    80003632:	854a                	mv	a0,s2
    80003634:	e32ff0ef          	jal	80002c66 <brelse>
      tot = -1;
    80003638:	59fd                	li	s3,-1
      break;
    8000363a:	6946                	ld	s2,80(sp)
    8000363c:	7c02                	ld	s8,32(sp)
    8000363e:	6ce2                	ld	s9,24(sp)
    80003640:	6d42                	ld	s10,16(sp)
    80003642:	6da2                	ld	s11,8(sp)
    80003644:	a831                	j	80003660 <readi+0xd8>
    80003646:	6946                	ld	s2,80(sp)
    80003648:	7c02                	ld	s8,32(sp)
    8000364a:	6ce2                	ld	s9,24(sp)
    8000364c:	6d42                	ld	s10,16(sp)
    8000364e:	6da2                	ld	s11,8(sp)
    80003650:	a801                	j	80003660 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003652:	89d6                	mv	s3,s5
    80003654:	a031                	j	80003660 <readi+0xd8>
    80003656:	6946                	ld	s2,80(sp)
    80003658:	7c02                	ld	s8,32(sp)
    8000365a:	6ce2                	ld	s9,24(sp)
    8000365c:	6d42                	ld	s10,16(sp)
    8000365e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003660:	854e                	mv	a0,s3
    80003662:	69a6                	ld	s3,72(sp)
}
    80003664:	70a6                	ld	ra,104(sp)
    80003666:	7406                	ld	s0,96(sp)
    80003668:	64e6                	ld	s1,88(sp)
    8000366a:	6a06                	ld	s4,64(sp)
    8000366c:	7ae2                	ld	s5,56(sp)
    8000366e:	7b42                	ld	s6,48(sp)
    80003670:	7ba2                	ld	s7,40(sp)
    80003672:	6165                	addi	sp,sp,112
    80003674:	8082                	ret
    return 0;
    80003676:	4501                	li	a0,0
}
    80003678:	8082                	ret

000000008000367a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000367a:	457c                	lw	a5,76(a0)
    8000367c:	0ed7eb63          	bltu	a5,a3,80003772 <writei+0xf8>
{
    80003680:	7159                	addi	sp,sp,-112
    80003682:	f486                	sd	ra,104(sp)
    80003684:	f0a2                	sd	s0,96(sp)
    80003686:	e8ca                	sd	s2,80(sp)
    80003688:	e0d2                	sd	s4,64(sp)
    8000368a:	fc56                	sd	s5,56(sp)
    8000368c:	f85a                	sd	s6,48(sp)
    8000368e:	f45e                	sd	s7,40(sp)
    80003690:	1880                	addi	s0,sp,112
    80003692:	8aaa                	mv	s5,a0
    80003694:	8bae                	mv	s7,a1
    80003696:	8a32                	mv	s4,a2
    80003698:	8936                	mv	s2,a3
    8000369a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000369c:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800036a0:	00043737          	lui	a4,0x43
    800036a4:	0cf76963          	bltu	a4,a5,80003776 <writei+0xfc>
    800036a8:	0cd7e763          	bltu	a5,a3,80003776 <writei+0xfc>
    800036ac:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036ae:	0a0b0a63          	beqz	s6,80003762 <writei+0xe8>
    800036b2:	eca6                	sd	s1,88(sp)
    800036b4:	f062                	sd	s8,32(sp)
    800036b6:	ec66                	sd	s9,24(sp)
    800036b8:	e86a                	sd	s10,16(sp)
    800036ba:	e46e                	sd	s11,8(sp)
    800036bc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036be:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800036c2:	5c7d                	li	s8,-1
    800036c4:	a825                	j	800036fc <writei+0x82>
    800036c6:	020d1d93          	slli	s11,s10,0x20
    800036ca:	020ddd93          	srli	s11,s11,0x20
    800036ce:	05848513          	addi	a0,s1,88
    800036d2:	86ee                	mv	a3,s11
    800036d4:	8652                	mv	a2,s4
    800036d6:	85de                	mv	a1,s7
    800036d8:	953e                	add	a0,a0,a5
    800036da:	bf7fe0ef          	jal	800022d0 <either_copyin>
    800036de:	05850663          	beq	a0,s8,8000372a <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    800036e2:	8526                	mv	a0,s1
    800036e4:	6b8000ef          	jal	80003d9c <log_write>
    brelse(bp);
    800036e8:	8526                	mv	a0,s1
    800036ea:	d7cff0ef          	jal	80002c66 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036ee:	013d09bb          	addw	s3,s10,s3
    800036f2:	012d093b          	addw	s2,s10,s2
    800036f6:	9a6e                	add	s4,s4,s11
    800036f8:	0369fc63          	bgeu	s3,s6,80003730 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800036fc:	00a9559b          	srliw	a1,s2,0xa
    80003700:	8556                	mv	a0,s5
    80003702:	fc2ff0ef          	jal	80002ec4 <bmap>
    80003706:	85aa                	mv	a1,a0
    if(addr == 0)
    80003708:	c505                	beqz	a0,80003730 <writei+0xb6>
    bp = bread(ip->dev, addr);
    8000370a:	000aa503          	lw	a0,0(s5)
    8000370e:	c50ff0ef          	jal	80002b5e <bread>
    80003712:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003714:	3ff97793          	andi	a5,s2,1023
    80003718:	40fc873b          	subw	a4,s9,a5
    8000371c:	413b06bb          	subw	a3,s6,s3
    80003720:	8d3a                	mv	s10,a4
    80003722:	fae6f2e3          	bgeu	a3,a4,800036c6 <writei+0x4c>
    80003726:	8d36                	mv	s10,a3
    80003728:	bf79                	j	800036c6 <writei+0x4c>
      brelse(bp);
    8000372a:	8526                	mv	a0,s1
    8000372c:	d3aff0ef          	jal	80002c66 <brelse>
  }

  if(off > ip->size)
    80003730:	04caa783          	lw	a5,76(s5)
    80003734:	0327f963          	bgeu	a5,s2,80003766 <writei+0xec>
    ip->size = off;
    80003738:	052aa623          	sw	s2,76(s5)
    8000373c:	64e6                	ld	s1,88(sp)
    8000373e:	7c02                	ld	s8,32(sp)
    80003740:	6ce2                	ld	s9,24(sp)
    80003742:	6d42                	ld	s10,16(sp)
    80003744:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003746:	8556                	mv	a0,s5
    80003748:	9fbff0ef          	jal	80003142 <iupdate>

  return tot;
    8000374c:	854e                	mv	a0,s3
    8000374e:	69a6                	ld	s3,72(sp)
}
    80003750:	70a6                	ld	ra,104(sp)
    80003752:	7406                	ld	s0,96(sp)
    80003754:	6946                	ld	s2,80(sp)
    80003756:	6a06                	ld	s4,64(sp)
    80003758:	7ae2                	ld	s5,56(sp)
    8000375a:	7b42                	ld	s6,48(sp)
    8000375c:	7ba2                	ld	s7,40(sp)
    8000375e:	6165                	addi	sp,sp,112
    80003760:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003762:	89da                	mv	s3,s6
    80003764:	b7cd                	j	80003746 <writei+0xcc>
    80003766:	64e6                	ld	s1,88(sp)
    80003768:	7c02                	ld	s8,32(sp)
    8000376a:	6ce2                	ld	s9,24(sp)
    8000376c:	6d42                	ld	s10,16(sp)
    8000376e:	6da2                	ld	s11,8(sp)
    80003770:	bfd9                	j	80003746 <writei+0xcc>
    return -1;
    80003772:	557d                	li	a0,-1
}
    80003774:	8082                	ret
    return -1;
    80003776:	557d                	li	a0,-1
    80003778:	bfe1                	j	80003750 <writei+0xd6>

000000008000377a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000377a:	1141                	addi	sp,sp,-16
    8000377c:	e406                	sd	ra,8(sp)
    8000377e:	e022                	sd	s0,0(sp)
    80003780:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003782:	4639                	li	a2,14
    80003784:	e48fd0ef          	jal	80000dcc <strncmp>
}
    80003788:	60a2                	ld	ra,8(sp)
    8000378a:	6402                	ld	s0,0(sp)
    8000378c:	0141                	addi	sp,sp,16
    8000378e:	8082                	ret

0000000080003790 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003790:	711d                	addi	sp,sp,-96
    80003792:	ec86                	sd	ra,88(sp)
    80003794:	e8a2                	sd	s0,80(sp)
    80003796:	e4a6                	sd	s1,72(sp)
    80003798:	e0ca                	sd	s2,64(sp)
    8000379a:	fc4e                	sd	s3,56(sp)
    8000379c:	f852                	sd	s4,48(sp)
    8000379e:	f456                	sd	s5,40(sp)
    800037a0:	f05a                	sd	s6,32(sp)
    800037a2:	ec5e                	sd	s7,24(sp)
    800037a4:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800037a6:	04451703          	lh	a4,68(a0)
    800037aa:	4785                	li	a5,1
    800037ac:	00f71f63          	bne	a4,a5,800037ca <dirlookup+0x3a>
    800037b0:	892a                	mv	s2,a0
    800037b2:	8aae                	mv	s5,a1
    800037b4:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800037b6:	457c                	lw	a5,76(a0)
    800037b8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037ba:	fa040a13          	addi	s4,s0,-96
    800037be:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800037c0:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800037c4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037c6:	e39d                	bnez	a5,800037ec <dirlookup+0x5c>
    800037c8:	a8b9                	j	80003826 <dirlookup+0x96>
    panic("dirlookup not DIR");
    800037ca:	00004517          	auipc	a0,0x4
    800037ce:	cd650513          	addi	a0,a0,-810 # 800074a0 <etext+0x4a0>
    800037d2:	852fd0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    800037d6:	00004517          	auipc	a0,0x4
    800037da:	ce250513          	addi	a0,a0,-798 # 800074b8 <etext+0x4b8>
    800037de:	846fd0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037e2:	24c1                	addiw	s1,s1,16
    800037e4:	04c92783          	lw	a5,76(s2)
    800037e8:	02f4fe63          	bgeu	s1,a5,80003824 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037ec:	874e                	mv	a4,s3
    800037ee:	86a6                	mv	a3,s1
    800037f0:	8652                	mv	a2,s4
    800037f2:	4581                	li	a1,0
    800037f4:	854a                	mv	a0,s2
    800037f6:	d93ff0ef          	jal	80003588 <readi>
    800037fa:	fd351ee3          	bne	a0,s3,800037d6 <dirlookup+0x46>
    if(de.inum == 0)
    800037fe:	fa045783          	lhu	a5,-96(s0)
    80003802:	d3e5                	beqz	a5,800037e2 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003804:	85da                	mv	a1,s6
    80003806:	8556                	mv	a0,s5
    80003808:	f73ff0ef          	jal	8000377a <namecmp>
    8000380c:	f979                	bnez	a0,800037e2 <dirlookup+0x52>
      if(poff)
    8000380e:	000b8463          	beqz	s7,80003816 <dirlookup+0x86>
        *poff = off;
    80003812:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003816:	fa045583          	lhu	a1,-96(s0)
    8000381a:	00092503          	lw	a0,0(s2)
    8000381e:	f66ff0ef          	jal	80002f84 <iget>
    80003822:	a011                	j	80003826 <dirlookup+0x96>
  return 0;
    80003824:	4501                	li	a0,0
}
    80003826:	60e6                	ld	ra,88(sp)
    80003828:	6446                	ld	s0,80(sp)
    8000382a:	64a6                	ld	s1,72(sp)
    8000382c:	6906                	ld	s2,64(sp)
    8000382e:	79e2                	ld	s3,56(sp)
    80003830:	7a42                	ld	s4,48(sp)
    80003832:	7aa2                	ld	s5,40(sp)
    80003834:	7b02                	ld	s6,32(sp)
    80003836:	6be2                	ld	s7,24(sp)
    80003838:	6125                	addi	sp,sp,96
    8000383a:	8082                	ret

000000008000383c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000383c:	711d                	addi	sp,sp,-96
    8000383e:	ec86                	sd	ra,88(sp)
    80003840:	e8a2                	sd	s0,80(sp)
    80003842:	e4a6                	sd	s1,72(sp)
    80003844:	e0ca                	sd	s2,64(sp)
    80003846:	fc4e                	sd	s3,56(sp)
    80003848:	f852                	sd	s4,48(sp)
    8000384a:	f456                	sd	s5,40(sp)
    8000384c:	f05a                	sd	s6,32(sp)
    8000384e:	ec5e                	sd	s7,24(sp)
    80003850:	e862                	sd	s8,16(sp)
    80003852:	e466                	sd	s9,8(sp)
    80003854:	e06a                	sd	s10,0(sp)
    80003856:	1080                	addi	s0,sp,96
    80003858:	84aa                	mv	s1,a0
    8000385a:	8b2e                	mv	s6,a1
    8000385c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000385e:	00054703          	lbu	a4,0(a0)
    80003862:	02f00793          	li	a5,47
    80003866:	00f70f63          	beq	a4,a5,80003884 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000386a:	8c4fe0ef          	jal	8000192e <myproc>
    8000386e:	15053503          	ld	a0,336(a0)
    80003872:	94fff0ef          	jal	800031c0 <idup>
    80003876:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003878:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    8000387c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000387e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003880:	4b85                	li	s7,1
    80003882:	a879                	j	80003920 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003884:	4585                	li	a1,1
    80003886:	852e                	mv	a0,a1
    80003888:	efcff0ef          	jal	80002f84 <iget>
    8000388c:	8a2a                	mv	s4,a0
    8000388e:	b7ed                	j	80003878 <namex+0x3c>
      iunlockput(ip);
    80003890:	8552                	mv	a0,s4
    80003892:	b71ff0ef          	jal	80003402 <iunlockput>
      return 0;
    80003896:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003898:	8552                	mv	a0,s4
    8000389a:	60e6                	ld	ra,88(sp)
    8000389c:	6446                	ld	s0,80(sp)
    8000389e:	64a6                	ld	s1,72(sp)
    800038a0:	6906                	ld	s2,64(sp)
    800038a2:	79e2                	ld	s3,56(sp)
    800038a4:	7a42                	ld	s4,48(sp)
    800038a6:	7aa2                	ld	s5,40(sp)
    800038a8:	7b02                	ld	s6,32(sp)
    800038aa:	6be2                	ld	s7,24(sp)
    800038ac:	6c42                	ld	s8,16(sp)
    800038ae:	6ca2                	ld	s9,8(sp)
    800038b0:	6d02                	ld	s10,0(sp)
    800038b2:	6125                	addi	sp,sp,96
    800038b4:	8082                	ret
      iunlock(ip);
    800038b6:	8552                	mv	a0,s4
    800038b8:	9edff0ef          	jal	800032a4 <iunlock>
      return ip;
    800038bc:	bff1                	j	80003898 <namex+0x5c>
      iunlockput(ip);
    800038be:	8552                	mv	a0,s4
    800038c0:	b43ff0ef          	jal	80003402 <iunlockput>
      return 0;
    800038c4:	8a4a                	mv	s4,s2
    800038c6:	bfc9                	j	80003898 <namex+0x5c>
  len = path - s;
    800038c8:	40990633          	sub	a2,s2,s1
    800038cc:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800038d0:	09ac5463          	bge	s8,s10,80003958 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    800038d4:	8666                	mv	a2,s9
    800038d6:	85a6                	mv	a1,s1
    800038d8:	8556                	mv	a0,s5
    800038da:	c7efd0ef          	jal	80000d58 <memmove>
    800038de:	84ca                	mv	s1,s2
  while(*path == '/')
    800038e0:	0004c783          	lbu	a5,0(s1)
    800038e4:	01379763          	bne	a5,s3,800038f2 <namex+0xb6>
    path++;
    800038e8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800038ea:	0004c783          	lbu	a5,0(s1)
    800038ee:	ff378de3          	beq	a5,s3,800038e8 <namex+0xac>
    ilock(ip);
    800038f2:	8552                	mv	a0,s4
    800038f4:	903ff0ef          	jal	800031f6 <ilock>
    if(ip->type != T_DIR){
    800038f8:	044a1783          	lh	a5,68(s4)
    800038fc:	f9779ae3          	bne	a5,s7,80003890 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003900:	000b0563          	beqz	s6,8000390a <namex+0xce>
    80003904:	0004c783          	lbu	a5,0(s1)
    80003908:	d7dd                	beqz	a5,800038b6 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000390a:	4601                	li	a2,0
    8000390c:	85d6                	mv	a1,s5
    8000390e:	8552                	mv	a0,s4
    80003910:	e81ff0ef          	jal	80003790 <dirlookup>
    80003914:	892a                	mv	s2,a0
    80003916:	d545                	beqz	a0,800038be <namex+0x82>
    iunlockput(ip);
    80003918:	8552                	mv	a0,s4
    8000391a:	ae9ff0ef          	jal	80003402 <iunlockput>
    ip = next;
    8000391e:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003920:	0004c783          	lbu	a5,0(s1)
    80003924:	01379763          	bne	a5,s3,80003932 <namex+0xf6>
    path++;
    80003928:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000392a:	0004c783          	lbu	a5,0(s1)
    8000392e:	ff378de3          	beq	a5,s3,80003928 <namex+0xec>
  if(*path == 0)
    80003932:	cf8d                	beqz	a5,8000396c <namex+0x130>
  while(*path != '/' && *path != 0)
    80003934:	0004c783          	lbu	a5,0(s1)
    80003938:	fd178713          	addi	a4,a5,-47
    8000393c:	cb19                	beqz	a4,80003952 <namex+0x116>
    8000393e:	cb91                	beqz	a5,80003952 <namex+0x116>
    80003940:	8926                	mv	s2,s1
    path++;
    80003942:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003944:	00094783          	lbu	a5,0(s2)
    80003948:	fd178713          	addi	a4,a5,-47
    8000394c:	df35                	beqz	a4,800038c8 <namex+0x8c>
    8000394e:	fbf5                	bnez	a5,80003942 <namex+0x106>
    80003950:	bfa5                	j	800038c8 <namex+0x8c>
    80003952:	8926                	mv	s2,s1
  len = path - s;
    80003954:	4d01                	li	s10,0
    80003956:	4601                	li	a2,0
    memmove(name, s, len);
    80003958:	2601                	sext.w	a2,a2
    8000395a:	85a6                	mv	a1,s1
    8000395c:	8556                	mv	a0,s5
    8000395e:	bfafd0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80003962:	9d56                	add	s10,s10,s5
    80003964:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde498>
    80003968:	84ca                	mv	s1,s2
    8000396a:	bf9d                	j	800038e0 <namex+0xa4>
  if(nameiparent){
    8000396c:	f20b06e3          	beqz	s6,80003898 <namex+0x5c>
    iput(ip);
    80003970:	8552                	mv	a0,s4
    80003972:	a07ff0ef          	jal	80003378 <iput>
    return 0;
    80003976:	4a01                	li	s4,0
    80003978:	b705                	j	80003898 <namex+0x5c>

000000008000397a <dirlink>:
{
    8000397a:	715d                	addi	sp,sp,-80
    8000397c:	e486                	sd	ra,72(sp)
    8000397e:	e0a2                	sd	s0,64(sp)
    80003980:	f84a                	sd	s2,48(sp)
    80003982:	ec56                	sd	s5,24(sp)
    80003984:	e85a                	sd	s6,16(sp)
    80003986:	0880                	addi	s0,sp,80
    80003988:	892a                	mv	s2,a0
    8000398a:	8aae                	mv	s5,a1
    8000398c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000398e:	4601                	li	a2,0
    80003990:	e01ff0ef          	jal	80003790 <dirlookup>
    80003994:	ed1d                	bnez	a0,800039d2 <dirlink+0x58>
    80003996:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003998:	04c92483          	lw	s1,76(s2)
    8000399c:	c4b9                	beqz	s1,800039ea <dirlink+0x70>
    8000399e:	f44e                	sd	s3,40(sp)
    800039a0:	f052                	sd	s4,32(sp)
    800039a2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039a4:	fb040a13          	addi	s4,s0,-80
    800039a8:	49c1                	li	s3,16
    800039aa:	874e                	mv	a4,s3
    800039ac:	86a6                	mv	a3,s1
    800039ae:	8652                	mv	a2,s4
    800039b0:	4581                	li	a1,0
    800039b2:	854a                	mv	a0,s2
    800039b4:	bd5ff0ef          	jal	80003588 <readi>
    800039b8:	03351163          	bne	a0,s3,800039da <dirlink+0x60>
    if(de.inum == 0)
    800039bc:	fb045783          	lhu	a5,-80(s0)
    800039c0:	c39d                	beqz	a5,800039e6 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039c2:	24c1                	addiw	s1,s1,16
    800039c4:	04c92783          	lw	a5,76(s2)
    800039c8:	fef4e1e3          	bltu	s1,a5,800039aa <dirlink+0x30>
    800039cc:	79a2                	ld	s3,40(sp)
    800039ce:	7a02                	ld	s4,32(sp)
    800039d0:	a829                	j	800039ea <dirlink+0x70>
    iput(ip);
    800039d2:	9a7ff0ef          	jal	80003378 <iput>
    return -1;
    800039d6:	557d                	li	a0,-1
    800039d8:	a83d                	j	80003a16 <dirlink+0x9c>
      panic("dirlink read");
    800039da:	00004517          	auipc	a0,0x4
    800039de:	aee50513          	addi	a0,a0,-1298 # 800074c8 <etext+0x4c8>
    800039e2:	e43fc0ef          	jal	80000824 <panic>
    800039e6:	79a2                	ld	s3,40(sp)
    800039e8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800039ea:	4639                	li	a2,14
    800039ec:	85d6                	mv	a1,s5
    800039ee:	fb240513          	addi	a0,s0,-78
    800039f2:	c14fd0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    800039f6:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039fa:	4741                	li	a4,16
    800039fc:	86a6                	mv	a3,s1
    800039fe:	fb040613          	addi	a2,s0,-80
    80003a02:	4581                	li	a1,0
    80003a04:	854a                	mv	a0,s2
    80003a06:	c75ff0ef          	jal	8000367a <writei>
    80003a0a:	1541                	addi	a0,a0,-16
    80003a0c:	00a03533          	snez	a0,a0
    80003a10:	40a0053b          	negw	a0,a0
    80003a14:	74e2                	ld	s1,56(sp)
}
    80003a16:	60a6                	ld	ra,72(sp)
    80003a18:	6406                	ld	s0,64(sp)
    80003a1a:	7942                	ld	s2,48(sp)
    80003a1c:	6ae2                	ld	s5,24(sp)
    80003a1e:	6b42                	ld	s6,16(sp)
    80003a20:	6161                	addi	sp,sp,80
    80003a22:	8082                	ret

0000000080003a24 <namei>:

struct inode*
namei(char *path)
{
    80003a24:	1101                	addi	sp,sp,-32
    80003a26:	ec06                	sd	ra,24(sp)
    80003a28:	e822                	sd	s0,16(sp)
    80003a2a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a2c:	fe040613          	addi	a2,s0,-32
    80003a30:	4581                	li	a1,0
    80003a32:	e0bff0ef          	jal	8000383c <namex>
}
    80003a36:	60e2                	ld	ra,24(sp)
    80003a38:	6442                	ld	s0,16(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret

0000000080003a3e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a3e:	1141                	addi	sp,sp,-16
    80003a40:	e406                	sd	ra,8(sp)
    80003a42:	e022                	sd	s0,0(sp)
    80003a44:	0800                	addi	s0,sp,16
    80003a46:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a48:	4585                	li	a1,1
    80003a4a:	df3ff0ef          	jal	8000383c <namex>
}
    80003a4e:	60a2                	ld	ra,8(sp)
    80003a50:	6402                	ld	s0,0(sp)
    80003a52:	0141                	addi	sp,sp,16
    80003a54:	8082                	ret

0000000080003a56 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a56:	1101                	addi	sp,sp,-32
    80003a58:	ec06                	sd	ra,24(sp)
    80003a5a:	e822                	sd	s0,16(sp)
    80003a5c:	e426                	sd	s1,8(sp)
    80003a5e:	e04a                	sd	s2,0(sp)
    80003a60:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a62:	0001c917          	auipc	s2,0x1c
    80003a66:	ec690913          	addi	s2,s2,-314 # 8001f928 <log>
    80003a6a:	01892583          	lw	a1,24(s2)
    80003a6e:	02492503          	lw	a0,36(s2)
    80003a72:	8ecff0ef          	jal	80002b5e <bread>
    80003a76:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a78:	02892603          	lw	a2,40(s2)
    80003a7c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a7e:	00c05f63          	blez	a2,80003a9c <write_head+0x46>
    80003a82:	0001c717          	auipc	a4,0x1c
    80003a86:	ed270713          	addi	a4,a4,-302 # 8001f954 <log+0x2c>
    80003a8a:	87aa                	mv	a5,a0
    80003a8c:	060a                	slli	a2,a2,0x2
    80003a8e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003a90:	4314                	lw	a3,0(a4)
    80003a92:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003a94:	0711                	addi	a4,a4,4
    80003a96:	0791                	addi	a5,a5,4
    80003a98:	fec79ce3          	bne	a5,a2,80003a90 <write_head+0x3a>
  }
  bwrite(buf);
    80003a9c:	8526                	mv	a0,s1
    80003a9e:	996ff0ef          	jal	80002c34 <bwrite>
  brelse(buf);
    80003aa2:	8526                	mv	a0,s1
    80003aa4:	9c2ff0ef          	jal	80002c66 <brelse>
}
    80003aa8:	60e2                	ld	ra,24(sp)
    80003aaa:	6442                	ld	s0,16(sp)
    80003aac:	64a2                	ld	s1,8(sp)
    80003aae:	6902                	ld	s2,0(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret

0000000080003ab4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ab4:	0001c797          	auipc	a5,0x1c
    80003ab8:	e9c7a783          	lw	a5,-356(a5) # 8001f950 <log+0x28>
    80003abc:	0cf05163          	blez	a5,80003b7e <install_trans+0xca>
{
    80003ac0:	715d                	addi	sp,sp,-80
    80003ac2:	e486                	sd	ra,72(sp)
    80003ac4:	e0a2                	sd	s0,64(sp)
    80003ac6:	fc26                	sd	s1,56(sp)
    80003ac8:	f84a                	sd	s2,48(sp)
    80003aca:	f44e                	sd	s3,40(sp)
    80003acc:	f052                	sd	s4,32(sp)
    80003ace:	ec56                	sd	s5,24(sp)
    80003ad0:	e85a                	sd	s6,16(sp)
    80003ad2:	e45e                	sd	s7,8(sp)
    80003ad4:	e062                	sd	s8,0(sp)
    80003ad6:	0880                	addi	s0,sp,80
    80003ad8:	8b2a                	mv	s6,a0
    80003ada:	0001ca97          	auipc	s5,0x1c
    80003ade:	e7aa8a93          	addi	s5,s5,-390 # 8001f954 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ae2:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003ae4:	00004c17          	auipc	s8,0x4
    80003ae8:	9f4c0c13          	addi	s8,s8,-1548 # 800074d8 <etext+0x4d8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003aec:	0001ca17          	auipc	s4,0x1c
    80003af0:	e3ca0a13          	addi	s4,s4,-452 # 8001f928 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003af4:	40000b93          	li	s7,1024
    80003af8:	a025                	j	80003b20 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003afa:	000aa603          	lw	a2,0(s5)
    80003afe:	85ce                	mv	a1,s3
    80003b00:	8562                	mv	a0,s8
    80003b02:	9f9fc0ef          	jal	800004fa <printf>
    80003b06:	a839                	j	80003b24 <install_trans+0x70>
    brelse(lbuf);
    80003b08:	854a                	mv	a0,s2
    80003b0a:	95cff0ef          	jal	80002c66 <brelse>
    brelse(dbuf);
    80003b0e:	8526                	mv	a0,s1
    80003b10:	956ff0ef          	jal	80002c66 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b14:	2985                	addiw	s3,s3,1
    80003b16:	0a91                	addi	s5,s5,4
    80003b18:	028a2783          	lw	a5,40(s4)
    80003b1c:	04f9d563          	bge	s3,a5,80003b66 <install_trans+0xb2>
    if(recovering) {
    80003b20:	fc0b1de3          	bnez	s6,80003afa <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b24:	018a2583          	lw	a1,24(s4)
    80003b28:	013585bb          	addw	a1,a1,s3
    80003b2c:	2585                	addiw	a1,a1,1
    80003b2e:	024a2503          	lw	a0,36(s4)
    80003b32:	82cff0ef          	jal	80002b5e <bread>
    80003b36:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b38:	000aa583          	lw	a1,0(s5)
    80003b3c:	024a2503          	lw	a0,36(s4)
    80003b40:	81eff0ef          	jal	80002b5e <bread>
    80003b44:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b46:	865e                	mv	a2,s7
    80003b48:	05890593          	addi	a1,s2,88
    80003b4c:	05850513          	addi	a0,a0,88
    80003b50:	a08fd0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b54:	8526                	mv	a0,s1
    80003b56:	8deff0ef          	jal	80002c34 <bwrite>
    if(recovering == 0)
    80003b5a:	fa0b17e3          	bnez	s6,80003b08 <install_trans+0x54>
      bunpin(dbuf);
    80003b5e:	8526                	mv	a0,s1
    80003b60:	9beff0ef          	jal	80002d1e <bunpin>
    80003b64:	b755                	j	80003b08 <install_trans+0x54>
}
    80003b66:	60a6                	ld	ra,72(sp)
    80003b68:	6406                	ld	s0,64(sp)
    80003b6a:	74e2                	ld	s1,56(sp)
    80003b6c:	7942                	ld	s2,48(sp)
    80003b6e:	79a2                	ld	s3,40(sp)
    80003b70:	7a02                	ld	s4,32(sp)
    80003b72:	6ae2                	ld	s5,24(sp)
    80003b74:	6b42                	ld	s6,16(sp)
    80003b76:	6ba2                	ld	s7,8(sp)
    80003b78:	6c02                	ld	s8,0(sp)
    80003b7a:	6161                	addi	sp,sp,80
    80003b7c:	8082                	ret
    80003b7e:	8082                	ret

0000000080003b80 <initlog>:
{
    80003b80:	7179                	addi	sp,sp,-48
    80003b82:	f406                	sd	ra,40(sp)
    80003b84:	f022                	sd	s0,32(sp)
    80003b86:	ec26                	sd	s1,24(sp)
    80003b88:	e84a                	sd	s2,16(sp)
    80003b8a:	e44e                	sd	s3,8(sp)
    80003b8c:	1800                	addi	s0,sp,48
    80003b8e:	84aa                	mv	s1,a0
    80003b90:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003b92:	0001c917          	auipc	s2,0x1c
    80003b96:	d9690913          	addi	s2,s2,-618 # 8001f928 <log>
    80003b9a:	00004597          	auipc	a1,0x4
    80003b9e:	95e58593          	addi	a1,a1,-1698 # 800074f8 <etext+0x4f8>
    80003ba2:	854a                	mv	a0,s2
    80003ba4:	ffbfc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80003ba8:	0149a583          	lw	a1,20(s3)
    80003bac:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003bb0:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003bb4:	8526                	mv	a0,s1
    80003bb6:	fa9fe0ef          	jal	80002b5e <bread>
  log.lh.n = lh->n;
    80003bba:	4d30                	lw	a2,88(a0)
    80003bbc:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003bc0:	00c05f63          	blez	a2,80003bde <initlog+0x5e>
    80003bc4:	87aa                	mv	a5,a0
    80003bc6:	0001c717          	auipc	a4,0x1c
    80003bca:	d8e70713          	addi	a4,a4,-626 # 8001f954 <log+0x2c>
    80003bce:	060a                	slli	a2,a2,0x2
    80003bd0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003bd2:	4ff4                	lw	a3,92(a5)
    80003bd4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003bd6:	0791                	addi	a5,a5,4
    80003bd8:	0711                	addi	a4,a4,4
    80003bda:	fec79ce3          	bne	a5,a2,80003bd2 <initlog+0x52>
  brelse(buf);
    80003bde:	888ff0ef          	jal	80002c66 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003be2:	4505                	li	a0,1
    80003be4:	ed1ff0ef          	jal	80003ab4 <install_trans>
  log.lh.n = 0;
    80003be8:	0001c797          	auipc	a5,0x1c
    80003bec:	d607a423          	sw	zero,-664(a5) # 8001f950 <log+0x28>
  write_head(); // clear the log
    80003bf0:	e67ff0ef          	jal	80003a56 <write_head>
}
    80003bf4:	70a2                	ld	ra,40(sp)
    80003bf6:	7402                	ld	s0,32(sp)
    80003bf8:	64e2                	ld	s1,24(sp)
    80003bfa:	6942                	ld	s2,16(sp)
    80003bfc:	69a2                	ld	s3,8(sp)
    80003bfe:	6145                	addi	sp,sp,48
    80003c00:	8082                	ret

0000000080003c02 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c02:	1101                	addi	sp,sp,-32
    80003c04:	ec06                	sd	ra,24(sp)
    80003c06:	e822                	sd	s0,16(sp)
    80003c08:	e426                	sd	s1,8(sp)
    80003c0a:	e04a                	sd	s2,0(sp)
    80003c0c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c0e:	0001c517          	auipc	a0,0x1c
    80003c12:	d1a50513          	addi	a0,a0,-742 # 8001f928 <log>
    80003c16:	812fd0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80003c1a:	0001c497          	auipc	s1,0x1c
    80003c1e:	d0e48493          	addi	s1,s1,-754 # 8001f928 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c22:	4979                	li	s2,30
    80003c24:	a029                	j	80003c2e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c26:	85a6                	mv	a1,s1
    80003c28:	8526                	mv	a0,s1
    80003c2a:	b02fe0ef          	jal	80001f2c <sleep>
    if(log.committing){
    80003c2e:	509c                	lw	a5,32(s1)
    80003c30:	fbfd                	bnez	a5,80003c26 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c32:	4cd8                	lw	a4,28(s1)
    80003c34:	2705                	addiw	a4,a4,1
    80003c36:	0027179b          	slliw	a5,a4,0x2
    80003c3a:	9fb9                	addw	a5,a5,a4
    80003c3c:	0017979b          	slliw	a5,a5,0x1
    80003c40:	5494                	lw	a3,40(s1)
    80003c42:	9fb5                	addw	a5,a5,a3
    80003c44:	00f95763          	bge	s2,a5,80003c52 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c48:	85a6                	mv	a1,s1
    80003c4a:	8526                	mv	a0,s1
    80003c4c:	ae0fe0ef          	jal	80001f2c <sleep>
    80003c50:	bff9                	j	80003c2e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c52:	0001c797          	auipc	a5,0x1c
    80003c56:	cee7a923          	sw	a4,-782(a5) # 8001f944 <log+0x1c>
      release(&log.lock);
    80003c5a:	0001c517          	auipc	a0,0x1c
    80003c5e:	cce50513          	addi	a0,a0,-818 # 8001f928 <log>
    80003c62:	85afd0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80003c66:	60e2                	ld	ra,24(sp)
    80003c68:	6442                	ld	s0,16(sp)
    80003c6a:	64a2                	ld	s1,8(sp)
    80003c6c:	6902                	ld	s2,0(sp)
    80003c6e:	6105                	addi	sp,sp,32
    80003c70:	8082                	ret

0000000080003c72 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c72:	7139                	addi	sp,sp,-64
    80003c74:	fc06                	sd	ra,56(sp)
    80003c76:	f822                	sd	s0,48(sp)
    80003c78:	f426                	sd	s1,40(sp)
    80003c7a:	f04a                	sd	s2,32(sp)
    80003c7c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c7e:	0001c497          	auipc	s1,0x1c
    80003c82:	caa48493          	addi	s1,s1,-854 # 8001f928 <log>
    80003c86:	8526                	mv	a0,s1
    80003c88:	fa1fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80003c8c:	4cdc                	lw	a5,28(s1)
    80003c8e:	37fd                	addiw	a5,a5,-1
    80003c90:	893e                	mv	s2,a5
    80003c92:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003c94:	509c                	lw	a5,32(s1)
    80003c96:	e7b1                	bnez	a5,80003ce2 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003c98:	04091e63          	bnez	s2,80003cf4 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003c9c:	0001c497          	auipc	s1,0x1c
    80003ca0:	c8c48493          	addi	s1,s1,-884 # 8001f928 <log>
    80003ca4:	4785                	li	a5,1
    80003ca6:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ca8:	8526                	mv	a0,s1
    80003caa:	812fd0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cae:	549c                	lw	a5,40(s1)
    80003cb0:	06f04463          	bgtz	a5,80003d18 <end_op+0xa6>
    acquire(&log.lock);
    80003cb4:	0001c517          	auipc	a0,0x1c
    80003cb8:	c7450513          	addi	a0,a0,-908 # 8001f928 <log>
    80003cbc:	f6dfc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80003cc0:	0001c797          	auipc	a5,0x1c
    80003cc4:	c807a423          	sw	zero,-888(a5) # 8001f948 <log+0x20>
    wakeup(&log);
    80003cc8:	0001c517          	auipc	a0,0x1c
    80003ccc:	c6050513          	addi	a0,a0,-928 # 8001f928 <log>
    80003cd0:	aa8fe0ef          	jal	80001f78 <wakeup>
    release(&log.lock);
    80003cd4:	0001c517          	auipc	a0,0x1c
    80003cd8:	c5450513          	addi	a0,a0,-940 # 8001f928 <log>
    80003cdc:	fe1fc0ef          	jal	80000cbc <release>
}
    80003ce0:	a035                	j	80003d0c <end_op+0x9a>
    80003ce2:	ec4e                	sd	s3,24(sp)
    80003ce4:	e852                	sd	s4,16(sp)
    80003ce6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003ce8:	00004517          	auipc	a0,0x4
    80003cec:	81850513          	addi	a0,a0,-2024 # 80007500 <etext+0x500>
    80003cf0:	b35fc0ef          	jal	80000824 <panic>
    wakeup(&log);
    80003cf4:	0001c517          	auipc	a0,0x1c
    80003cf8:	c3450513          	addi	a0,a0,-972 # 8001f928 <log>
    80003cfc:	a7cfe0ef          	jal	80001f78 <wakeup>
  release(&log.lock);
    80003d00:	0001c517          	auipc	a0,0x1c
    80003d04:	c2850513          	addi	a0,a0,-984 # 8001f928 <log>
    80003d08:	fb5fc0ef          	jal	80000cbc <release>
}
    80003d0c:	70e2                	ld	ra,56(sp)
    80003d0e:	7442                	ld	s0,48(sp)
    80003d10:	74a2                	ld	s1,40(sp)
    80003d12:	7902                	ld	s2,32(sp)
    80003d14:	6121                	addi	sp,sp,64
    80003d16:	8082                	ret
    80003d18:	ec4e                	sd	s3,24(sp)
    80003d1a:	e852                	sd	s4,16(sp)
    80003d1c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d1e:	0001ca97          	auipc	s5,0x1c
    80003d22:	c36a8a93          	addi	s5,s5,-970 # 8001f954 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d26:	0001ca17          	auipc	s4,0x1c
    80003d2a:	c02a0a13          	addi	s4,s4,-1022 # 8001f928 <log>
    80003d2e:	018a2583          	lw	a1,24(s4)
    80003d32:	012585bb          	addw	a1,a1,s2
    80003d36:	2585                	addiw	a1,a1,1
    80003d38:	024a2503          	lw	a0,36(s4)
    80003d3c:	e23fe0ef          	jal	80002b5e <bread>
    80003d40:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d42:	000aa583          	lw	a1,0(s5)
    80003d46:	024a2503          	lw	a0,36(s4)
    80003d4a:	e15fe0ef          	jal	80002b5e <bread>
    80003d4e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d50:	40000613          	li	a2,1024
    80003d54:	05850593          	addi	a1,a0,88
    80003d58:	05848513          	addi	a0,s1,88
    80003d5c:	ffdfc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    80003d60:	8526                	mv	a0,s1
    80003d62:	ed3fe0ef          	jal	80002c34 <bwrite>
    brelse(from);
    80003d66:	854e                	mv	a0,s3
    80003d68:	efffe0ef          	jal	80002c66 <brelse>
    brelse(to);
    80003d6c:	8526                	mv	a0,s1
    80003d6e:	ef9fe0ef          	jal	80002c66 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d72:	2905                	addiw	s2,s2,1
    80003d74:	0a91                	addi	s5,s5,4
    80003d76:	028a2783          	lw	a5,40(s4)
    80003d7a:	faf94ae3          	blt	s2,a5,80003d2e <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d7e:	cd9ff0ef          	jal	80003a56 <write_head>
    install_trans(0); // Now install writes to home locations
    80003d82:	4501                	li	a0,0
    80003d84:	d31ff0ef          	jal	80003ab4 <install_trans>
    log.lh.n = 0;
    80003d88:	0001c797          	auipc	a5,0x1c
    80003d8c:	bc07a423          	sw	zero,-1080(a5) # 8001f950 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003d90:	cc7ff0ef          	jal	80003a56 <write_head>
    80003d94:	69e2                	ld	s3,24(sp)
    80003d96:	6a42                	ld	s4,16(sp)
    80003d98:	6aa2                	ld	s5,8(sp)
    80003d9a:	bf29                	j	80003cb4 <end_op+0x42>

0000000080003d9c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003d9c:	1101                	addi	sp,sp,-32
    80003d9e:	ec06                	sd	ra,24(sp)
    80003da0:	e822                	sd	s0,16(sp)
    80003da2:	e426                	sd	s1,8(sp)
    80003da4:	1000                	addi	s0,sp,32
    80003da6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003da8:	0001c517          	auipc	a0,0x1c
    80003dac:	b8050513          	addi	a0,a0,-1152 # 8001f928 <log>
    80003db0:	e79fc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003db4:	0001c617          	auipc	a2,0x1c
    80003db8:	b9c62603          	lw	a2,-1124(a2) # 8001f950 <log+0x28>
    80003dbc:	47f5                	li	a5,29
    80003dbe:	04c7cd63          	blt	a5,a2,80003e18 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003dc2:	0001c797          	auipc	a5,0x1c
    80003dc6:	b827a783          	lw	a5,-1150(a5) # 8001f944 <log+0x1c>
    80003dca:	04f05d63          	blez	a5,80003e24 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003dce:	4781                	li	a5,0
    80003dd0:	06c05063          	blez	a2,80003e30 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dd4:	44cc                	lw	a1,12(s1)
    80003dd6:	0001c717          	auipc	a4,0x1c
    80003dda:	b7e70713          	addi	a4,a4,-1154 # 8001f954 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003dde:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003de0:	4314                	lw	a3,0(a4)
    80003de2:	04b68763          	beq	a3,a1,80003e30 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003de6:	2785                	addiw	a5,a5,1
    80003de8:	0711                	addi	a4,a4,4
    80003dea:	fef61be3          	bne	a2,a5,80003de0 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003dee:	060a                	slli	a2,a2,0x2
    80003df0:	02060613          	addi	a2,a2,32
    80003df4:	0001c797          	auipc	a5,0x1c
    80003df8:	b3478793          	addi	a5,a5,-1228 # 8001f928 <log>
    80003dfc:	97b2                	add	a5,a5,a2
    80003dfe:	44d8                	lw	a4,12(s1)
    80003e00:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e02:	8526                	mv	a0,s1
    80003e04:	ee7fe0ef          	jal	80002cea <bpin>
    log.lh.n++;
    80003e08:	0001c717          	auipc	a4,0x1c
    80003e0c:	b2070713          	addi	a4,a4,-1248 # 8001f928 <log>
    80003e10:	571c                	lw	a5,40(a4)
    80003e12:	2785                	addiw	a5,a5,1
    80003e14:	d71c                	sw	a5,40(a4)
    80003e16:	a815                	j	80003e4a <log_write+0xae>
    panic("too big a transaction");
    80003e18:	00003517          	auipc	a0,0x3
    80003e1c:	6f850513          	addi	a0,a0,1784 # 80007510 <etext+0x510>
    80003e20:	a05fc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80003e24:	00003517          	auipc	a0,0x3
    80003e28:	70450513          	addi	a0,a0,1796 # 80007528 <etext+0x528>
    80003e2c:	9f9fc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80003e30:	00279693          	slli	a3,a5,0x2
    80003e34:	02068693          	addi	a3,a3,32
    80003e38:	0001c717          	auipc	a4,0x1c
    80003e3c:	af070713          	addi	a4,a4,-1296 # 8001f928 <log>
    80003e40:	9736                	add	a4,a4,a3
    80003e42:	44d4                	lw	a3,12(s1)
    80003e44:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e46:	faf60ee3          	beq	a2,a5,80003e02 <log_write+0x66>
  }
  release(&log.lock);
    80003e4a:	0001c517          	auipc	a0,0x1c
    80003e4e:	ade50513          	addi	a0,a0,-1314 # 8001f928 <log>
    80003e52:	e6bfc0ef          	jal	80000cbc <release>
}
    80003e56:	60e2                	ld	ra,24(sp)
    80003e58:	6442                	ld	s0,16(sp)
    80003e5a:	64a2                	ld	s1,8(sp)
    80003e5c:	6105                	addi	sp,sp,32
    80003e5e:	8082                	ret

0000000080003e60 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003e60:	1101                	addi	sp,sp,-32
    80003e62:	ec06                	sd	ra,24(sp)
    80003e64:	e822                	sd	s0,16(sp)
    80003e66:	e426                	sd	s1,8(sp)
    80003e68:	e04a                	sd	s2,0(sp)
    80003e6a:	1000                	addi	s0,sp,32
    80003e6c:	84aa                	mv	s1,a0
    80003e6e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003e70:	00003597          	auipc	a1,0x3
    80003e74:	6d858593          	addi	a1,a1,1752 # 80007548 <etext+0x548>
    80003e78:	0521                	addi	a0,a0,8
    80003e7a:	d25fc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    80003e7e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003e82:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e86:	0204a423          	sw	zero,40(s1)
}
    80003e8a:	60e2                	ld	ra,24(sp)
    80003e8c:	6442                	ld	s0,16(sp)
    80003e8e:	64a2                	ld	s1,8(sp)
    80003e90:	6902                	ld	s2,0(sp)
    80003e92:	6105                	addi	sp,sp,32
    80003e94:	8082                	ret

0000000080003e96 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003e96:	1101                	addi	sp,sp,-32
    80003e98:	ec06                	sd	ra,24(sp)
    80003e9a:	e822                	sd	s0,16(sp)
    80003e9c:	e426                	sd	s1,8(sp)
    80003e9e:	e04a                	sd	s2,0(sp)
    80003ea0:	1000                	addi	s0,sp,32
    80003ea2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ea4:	00850913          	addi	s2,a0,8
    80003ea8:	854a                	mv	a0,s2
    80003eaa:	d7ffc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80003eae:	409c                	lw	a5,0(s1)
    80003eb0:	c799                	beqz	a5,80003ebe <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003eb2:	85ca                	mv	a1,s2
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	876fe0ef          	jal	80001f2c <sleep>
  while (lk->locked) {
    80003eba:	409c                	lw	a5,0(s1)
    80003ebc:	fbfd                	bnez	a5,80003eb2 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003ebe:	4785                	li	a5,1
    80003ec0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ec2:	a6dfd0ef          	jal	8000192e <myproc>
    80003ec6:	591c                	lw	a5,48(a0)
    80003ec8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003eca:	854a                	mv	a0,s2
    80003ecc:	df1fc0ef          	jal	80000cbc <release>
}
    80003ed0:	60e2                	ld	ra,24(sp)
    80003ed2:	6442                	ld	s0,16(sp)
    80003ed4:	64a2                	ld	s1,8(sp)
    80003ed6:	6902                	ld	s2,0(sp)
    80003ed8:	6105                	addi	sp,sp,32
    80003eda:	8082                	ret

0000000080003edc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003edc:	1101                	addi	sp,sp,-32
    80003ede:	ec06                	sd	ra,24(sp)
    80003ee0:	e822                	sd	s0,16(sp)
    80003ee2:	e426                	sd	s1,8(sp)
    80003ee4:	e04a                	sd	s2,0(sp)
    80003ee6:	1000                	addi	s0,sp,32
    80003ee8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003eea:	00850913          	addi	s2,a0,8
    80003eee:	854a                	mv	a0,s2
    80003ef0:	d39fc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    80003ef4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ef8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003efc:	8526                	mv	a0,s1
    80003efe:	87afe0ef          	jal	80001f78 <wakeup>
  release(&lk->lk);
    80003f02:	854a                	mv	a0,s2
    80003f04:	db9fc0ef          	jal	80000cbc <release>
}
    80003f08:	60e2                	ld	ra,24(sp)
    80003f0a:	6442                	ld	s0,16(sp)
    80003f0c:	64a2                	ld	s1,8(sp)
    80003f0e:	6902                	ld	s2,0(sp)
    80003f10:	6105                	addi	sp,sp,32
    80003f12:	8082                	ret

0000000080003f14 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003f14:	7179                	addi	sp,sp,-48
    80003f16:	f406                	sd	ra,40(sp)
    80003f18:	f022                	sd	s0,32(sp)
    80003f1a:	ec26                	sd	s1,24(sp)
    80003f1c:	e84a                	sd	s2,16(sp)
    80003f1e:	1800                	addi	s0,sp,48
    80003f20:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003f22:	00850913          	addi	s2,a0,8
    80003f26:	854a                	mv	a0,s2
    80003f28:	d01fc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f2c:	409c                	lw	a5,0(s1)
    80003f2e:	ef81                	bnez	a5,80003f46 <holdingsleep+0x32>
    80003f30:	4481                	li	s1,0
  release(&lk->lk);
    80003f32:	854a                	mv	a0,s2
    80003f34:	d89fc0ef          	jal	80000cbc <release>
  return r;
}
    80003f38:	8526                	mv	a0,s1
    80003f3a:	70a2                	ld	ra,40(sp)
    80003f3c:	7402                	ld	s0,32(sp)
    80003f3e:	64e2                	ld	s1,24(sp)
    80003f40:	6942                	ld	s2,16(sp)
    80003f42:	6145                	addi	sp,sp,48
    80003f44:	8082                	ret
    80003f46:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003f48:	0284a983          	lw	s3,40(s1)
    80003f4c:	9e3fd0ef          	jal	8000192e <myproc>
    80003f50:	5904                	lw	s1,48(a0)
    80003f52:	413484b3          	sub	s1,s1,s3
    80003f56:	0014b493          	seqz	s1,s1
    80003f5a:	69a2                	ld	s3,8(sp)
    80003f5c:	bfd9                	j	80003f32 <holdingsleep+0x1e>

0000000080003f5e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003f5e:	1141                	addi	sp,sp,-16
    80003f60:	e406                	sd	ra,8(sp)
    80003f62:	e022                	sd	s0,0(sp)
    80003f64:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003f66:	00003597          	auipc	a1,0x3
    80003f6a:	5f258593          	addi	a1,a1,1522 # 80007558 <etext+0x558>
    80003f6e:	0001c517          	auipc	a0,0x1c
    80003f72:	b0250513          	addi	a0,a0,-1278 # 8001fa70 <ftable>
    80003f76:	c29fc0ef          	jal	80000b9e <initlock>
}
    80003f7a:	60a2                	ld	ra,8(sp)
    80003f7c:	6402                	ld	s0,0(sp)
    80003f7e:	0141                	addi	sp,sp,16
    80003f80:	8082                	ret

0000000080003f82 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003f82:	1101                	addi	sp,sp,-32
    80003f84:	ec06                	sd	ra,24(sp)
    80003f86:	e822                	sd	s0,16(sp)
    80003f88:	e426                	sd	s1,8(sp)
    80003f8a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003f8c:	0001c517          	auipc	a0,0x1c
    80003f90:	ae450513          	addi	a0,a0,-1308 # 8001fa70 <ftable>
    80003f94:	c95fc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f98:	0001c497          	auipc	s1,0x1c
    80003f9c:	af048493          	addi	s1,s1,-1296 # 8001fa88 <ftable+0x18>
    80003fa0:	0001d717          	auipc	a4,0x1d
    80003fa4:	a8870713          	addi	a4,a4,-1400 # 80020a28 <disk>
    if(f->ref == 0){
    80003fa8:	40dc                	lw	a5,4(s1)
    80003faa:	cf89                	beqz	a5,80003fc4 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003fac:	02848493          	addi	s1,s1,40
    80003fb0:	fee49ce3          	bne	s1,a4,80003fa8 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003fb4:	0001c517          	auipc	a0,0x1c
    80003fb8:	abc50513          	addi	a0,a0,-1348 # 8001fa70 <ftable>
    80003fbc:	d01fc0ef          	jal	80000cbc <release>
  return 0;
    80003fc0:	4481                	li	s1,0
    80003fc2:	a809                	j	80003fd4 <filealloc+0x52>
      f->ref = 1;
    80003fc4:	4785                	li	a5,1
    80003fc6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003fc8:	0001c517          	auipc	a0,0x1c
    80003fcc:	aa850513          	addi	a0,a0,-1368 # 8001fa70 <ftable>
    80003fd0:	cedfc0ef          	jal	80000cbc <release>
}
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	60e2                	ld	ra,24(sp)
    80003fd8:	6442                	ld	s0,16(sp)
    80003fda:	64a2                	ld	s1,8(sp)
    80003fdc:	6105                	addi	sp,sp,32
    80003fde:	8082                	ret

0000000080003fe0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003fe0:	1101                	addi	sp,sp,-32
    80003fe2:	ec06                	sd	ra,24(sp)
    80003fe4:	e822                	sd	s0,16(sp)
    80003fe6:	e426                	sd	s1,8(sp)
    80003fe8:	1000                	addi	s0,sp,32
    80003fea:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003fec:	0001c517          	auipc	a0,0x1c
    80003ff0:	a8450513          	addi	a0,a0,-1404 # 8001fa70 <ftable>
    80003ff4:	c35fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80003ff8:	40dc                	lw	a5,4(s1)
    80003ffa:	02f05063          	blez	a5,8000401a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003ffe:	2785                	addiw	a5,a5,1
    80004000:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004002:	0001c517          	auipc	a0,0x1c
    80004006:	a6e50513          	addi	a0,a0,-1426 # 8001fa70 <ftable>
    8000400a:	cb3fc0ef          	jal	80000cbc <release>
  return f;
}
    8000400e:	8526                	mv	a0,s1
    80004010:	60e2                	ld	ra,24(sp)
    80004012:	6442                	ld	s0,16(sp)
    80004014:	64a2                	ld	s1,8(sp)
    80004016:	6105                	addi	sp,sp,32
    80004018:	8082                	ret
    panic("filedup");
    8000401a:	00003517          	auipc	a0,0x3
    8000401e:	54650513          	addi	a0,a0,1350 # 80007560 <etext+0x560>
    80004022:	803fc0ef          	jal	80000824 <panic>

0000000080004026 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004026:	7139                	addi	sp,sp,-64
    80004028:	fc06                	sd	ra,56(sp)
    8000402a:	f822                	sd	s0,48(sp)
    8000402c:	f426                	sd	s1,40(sp)
    8000402e:	0080                	addi	s0,sp,64
    80004030:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004032:	0001c517          	auipc	a0,0x1c
    80004036:	a3e50513          	addi	a0,a0,-1474 # 8001fa70 <ftable>
    8000403a:	beffc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    8000403e:	40dc                	lw	a5,4(s1)
    80004040:	04f05a63          	blez	a5,80004094 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004044:	37fd                	addiw	a5,a5,-1
    80004046:	c0dc                	sw	a5,4(s1)
    80004048:	06f04063          	bgtz	a5,800040a8 <fileclose+0x82>
    8000404c:	f04a                	sd	s2,32(sp)
    8000404e:	ec4e                	sd	s3,24(sp)
    80004050:	e852                	sd	s4,16(sp)
    80004052:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004054:	0004a903          	lw	s2,0(s1)
    80004058:	0094c783          	lbu	a5,9(s1)
    8000405c:	89be                	mv	s3,a5
    8000405e:	689c                	ld	a5,16(s1)
    80004060:	8a3e                	mv	s4,a5
    80004062:	6c9c                	ld	a5,24(s1)
    80004064:	8abe                	mv	s5,a5
  f->ref = 0;
    80004066:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000406a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000406e:	0001c517          	auipc	a0,0x1c
    80004072:	a0250513          	addi	a0,a0,-1534 # 8001fa70 <ftable>
    80004076:	c47fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    8000407a:	4785                	li	a5,1
    8000407c:	04f90163          	beq	s2,a5,800040be <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004080:	ffe9079b          	addiw	a5,s2,-2
    80004084:	4705                	li	a4,1
    80004086:	04f77563          	bgeu	a4,a5,800040d0 <fileclose+0xaa>
    8000408a:	7902                	ld	s2,32(sp)
    8000408c:	69e2                	ld	s3,24(sp)
    8000408e:	6a42                	ld	s4,16(sp)
    80004090:	6aa2                	ld	s5,8(sp)
    80004092:	a00d                	j	800040b4 <fileclose+0x8e>
    80004094:	f04a                	sd	s2,32(sp)
    80004096:	ec4e                	sd	s3,24(sp)
    80004098:	e852                	sd	s4,16(sp)
    8000409a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000409c:	00003517          	auipc	a0,0x3
    800040a0:	4cc50513          	addi	a0,a0,1228 # 80007568 <etext+0x568>
    800040a4:	f80fc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    800040a8:	0001c517          	auipc	a0,0x1c
    800040ac:	9c850513          	addi	a0,a0,-1592 # 8001fa70 <ftable>
    800040b0:	c0dfc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800040b4:	70e2                	ld	ra,56(sp)
    800040b6:	7442                	ld	s0,48(sp)
    800040b8:	74a2                	ld	s1,40(sp)
    800040ba:	6121                	addi	sp,sp,64
    800040bc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800040be:	85ce                	mv	a1,s3
    800040c0:	8552                	mv	a0,s4
    800040c2:	348000ef          	jal	8000440a <pipeclose>
    800040c6:	7902                	ld	s2,32(sp)
    800040c8:	69e2                	ld	s3,24(sp)
    800040ca:	6a42                	ld	s4,16(sp)
    800040cc:	6aa2                	ld	s5,8(sp)
    800040ce:	b7dd                	j	800040b4 <fileclose+0x8e>
    begin_op();
    800040d0:	b33ff0ef          	jal	80003c02 <begin_op>
    iput(ff.ip);
    800040d4:	8556                	mv	a0,s5
    800040d6:	aa2ff0ef          	jal	80003378 <iput>
    end_op();
    800040da:	b99ff0ef          	jal	80003c72 <end_op>
    800040de:	7902                	ld	s2,32(sp)
    800040e0:	69e2                	ld	s3,24(sp)
    800040e2:	6a42                	ld	s4,16(sp)
    800040e4:	6aa2                	ld	s5,8(sp)
    800040e6:	b7f9                	j	800040b4 <fileclose+0x8e>

00000000800040e8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800040e8:	715d                	addi	sp,sp,-80
    800040ea:	e486                	sd	ra,72(sp)
    800040ec:	e0a2                	sd	s0,64(sp)
    800040ee:	fc26                	sd	s1,56(sp)
    800040f0:	f052                	sd	s4,32(sp)
    800040f2:	0880                	addi	s0,sp,80
    800040f4:	84aa                	mv	s1,a0
    800040f6:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800040f8:	837fd0ef          	jal	8000192e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800040fc:	409c                	lw	a5,0(s1)
    800040fe:	37f9                	addiw	a5,a5,-2
    80004100:	4705                	li	a4,1
    80004102:	04f76263          	bltu	a4,a5,80004146 <filestat+0x5e>
    80004106:	f84a                	sd	s2,48(sp)
    80004108:	f44e                	sd	s3,40(sp)
    8000410a:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000410c:	6c88                	ld	a0,24(s1)
    8000410e:	8e8ff0ef          	jal	800031f6 <ilock>
    stati(f->ip, &st);
    80004112:	fb840913          	addi	s2,s0,-72
    80004116:	85ca                	mv	a1,s2
    80004118:	6c88                	ld	a0,24(s1)
    8000411a:	c40ff0ef          	jal	8000355a <stati>
    iunlock(f->ip);
    8000411e:	6c88                	ld	a0,24(s1)
    80004120:	984ff0ef          	jal	800032a4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004124:	46e1                	li	a3,24
    80004126:	864a                	mv	a2,s2
    80004128:	85d2                	mv	a1,s4
    8000412a:	0509b503          	ld	a0,80(s3)
    8000412e:	d26fd0ef          	jal	80001654 <copyout>
    80004132:	41f5551b          	sraiw	a0,a0,0x1f
    80004136:	7942                	ld	s2,48(sp)
    80004138:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000413a:	60a6                	ld	ra,72(sp)
    8000413c:	6406                	ld	s0,64(sp)
    8000413e:	74e2                	ld	s1,56(sp)
    80004140:	7a02                	ld	s4,32(sp)
    80004142:	6161                	addi	sp,sp,80
    80004144:	8082                	ret
  return -1;
    80004146:	557d                	li	a0,-1
    80004148:	bfcd                	j	8000413a <filestat+0x52>

000000008000414a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000414a:	7179                	addi	sp,sp,-48
    8000414c:	f406                	sd	ra,40(sp)
    8000414e:	f022                	sd	s0,32(sp)
    80004150:	e84a                	sd	s2,16(sp)
    80004152:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004154:	00854783          	lbu	a5,8(a0)
    80004158:	cfd1                	beqz	a5,800041f4 <fileread+0xaa>
    8000415a:	ec26                	sd	s1,24(sp)
    8000415c:	e44e                	sd	s3,8(sp)
    8000415e:	84aa                	mv	s1,a0
    80004160:	892e                	mv	s2,a1
    80004162:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004164:	411c                	lw	a5,0(a0)
    80004166:	4705                	li	a4,1
    80004168:	04e78363          	beq	a5,a4,800041ae <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000416c:	470d                	li	a4,3
    8000416e:	04e78763          	beq	a5,a4,800041bc <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004172:	4709                	li	a4,2
    80004174:	06e79a63          	bne	a5,a4,800041e8 <fileread+0x9e>
    ilock(f->ip);
    80004178:	6d08                	ld	a0,24(a0)
    8000417a:	87cff0ef          	jal	800031f6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000417e:	874e                	mv	a4,s3
    80004180:	5094                	lw	a3,32(s1)
    80004182:	864a                	mv	a2,s2
    80004184:	4585                	li	a1,1
    80004186:	6c88                	ld	a0,24(s1)
    80004188:	c00ff0ef          	jal	80003588 <readi>
    8000418c:	892a                	mv	s2,a0
    8000418e:	00a05563          	blez	a0,80004198 <fileread+0x4e>
      f->off += r;
    80004192:	509c                	lw	a5,32(s1)
    80004194:	9fa9                	addw	a5,a5,a0
    80004196:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004198:	6c88                	ld	a0,24(s1)
    8000419a:	90aff0ef          	jal	800032a4 <iunlock>
    8000419e:	64e2                	ld	s1,24(sp)
    800041a0:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800041a2:	854a                	mv	a0,s2
    800041a4:	70a2                	ld	ra,40(sp)
    800041a6:	7402                	ld	s0,32(sp)
    800041a8:	6942                	ld	s2,16(sp)
    800041aa:	6145                	addi	sp,sp,48
    800041ac:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800041ae:	6908                	ld	a0,16(a0)
    800041b0:	3b0000ef          	jal	80004560 <piperead>
    800041b4:	892a                	mv	s2,a0
    800041b6:	64e2                	ld	s1,24(sp)
    800041b8:	69a2                	ld	s3,8(sp)
    800041ba:	b7e5                	j	800041a2 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800041bc:	02451783          	lh	a5,36(a0)
    800041c0:	03079693          	slli	a3,a5,0x30
    800041c4:	92c1                	srli	a3,a3,0x30
    800041c6:	4725                	li	a4,9
    800041c8:	02d76963          	bltu	a4,a3,800041fa <fileread+0xb0>
    800041cc:	0792                	slli	a5,a5,0x4
    800041ce:	0001c717          	auipc	a4,0x1c
    800041d2:	80270713          	addi	a4,a4,-2046 # 8001f9d0 <devsw>
    800041d6:	97ba                	add	a5,a5,a4
    800041d8:	639c                	ld	a5,0(a5)
    800041da:	c78d                	beqz	a5,80004204 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    800041dc:	4505                	li	a0,1
    800041de:	9782                	jalr	a5
    800041e0:	892a                	mv	s2,a0
    800041e2:	64e2                	ld	s1,24(sp)
    800041e4:	69a2                	ld	s3,8(sp)
    800041e6:	bf75                	j	800041a2 <fileread+0x58>
    panic("fileread");
    800041e8:	00003517          	auipc	a0,0x3
    800041ec:	39050513          	addi	a0,a0,912 # 80007578 <etext+0x578>
    800041f0:	e34fc0ef          	jal	80000824 <panic>
    return -1;
    800041f4:	57fd                	li	a5,-1
    800041f6:	893e                	mv	s2,a5
    800041f8:	b76d                	j	800041a2 <fileread+0x58>
      return -1;
    800041fa:	57fd                	li	a5,-1
    800041fc:	893e                	mv	s2,a5
    800041fe:	64e2                	ld	s1,24(sp)
    80004200:	69a2                	ld	s3,8(sp)
    80004202:	b745                	j	800041a2 <fileread+0x58>
    80004204:	57fd                	li	a5,-1
    80004206:	893e                	mv	s2,a5
    80004208:	64e2                	ld	s1,24(sp)
    8000420a:	69a2                	ld	s3,8(sp)
    8000420c:	bf59                	j	800041a2 <fileread+0x58>

000000008000420e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000420e:	00954783          	lbu	a5,9(a0)
    80004212:	10078f63          	beqz	a5,80004330 <filewrite+0x122>
{
    80004216:	711d                	addi	sp,sp,-96
    80004218:	ec86                	sd	ra,88(sp)
    8000421a:	e8a2                	sd	s0,80(sp)
    8000421c:	e0ca                	sd	s2,64(sp)
    8000421e:	f456                	sd	s5,40(sp)
    80004220:	f05a                	sd	s6,32(sp)
    80004222:	1080                	addi	s0,sp,96
    80004224:	892a                	mv	s2,a0
    80004226:	8b2e                	mv	s6,a1
    80004228:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000422a:	411c                	lw	a5,0(a0)
    8000422c:	4705                	li	a4,1
    8000422e:	02e78a63          	beq	a5,a4,80004262 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004232:	470d                	li	a4,3
    80004234:	02e78b63          	beq	a5,a4,8000426a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004238:	4709                	li	a4,2
    8000423a:	0ce79f63          	bne	a5,a4,80004318 <filewrite+0x10a>
    8000423e:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004240:	0ac05a63          	blez	a2,800042f4 <filewrite+0xe6>
    80004244:	e4a6                	sd	s1,72(sp)
    80004246:	fc4e                	sd	s3,56(sp)
    80004248:	ec5e                	sd	s7,24(sp)
    8000424a:	e862                	sd	s8,16(sp)
    8000424c:	e466                	sd	s9,8(sp)
    int i = 0;
    8000424e:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004250:	6b85                	lui	s7,0x1
    80004252:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004256:	6785                	lui	a5,0x1
    80004258:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000425c:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000425e:	4c05                	li	s8,1
    80004260:	a8ad                	j	800042da <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004262:	6908                	ld	a0,16(a0)
    80004264:	204000ef          	jal	80004468 <pipewrite>
    80004268:	a04d                	j	8000430a <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000426a:	02451783          	lh	a5,36(a0)
    8000426e:	03079693          	slli	a3,a5,0x30
    80004272:	92c1                	srli	a3,a3,0x30
    80004274:	4725                	li	a4,9
    80004276:	0ad76f63          	bltu	a4,a3,80004334 <filewrite+0x126>
    8000427a:	0792                	slli	a5,a5,0x4
    8000427c:	0001b717          	auipc	a4,0x1b
    80004280:	75470713          	addi	a4,a4,1876 # 8001f9d0 <devsw>
    80004284:	97ba                	add	a5,a5,a4
    80004286:	679c                	ld	a5,8(a5)
    80004288:	cbc5                	beqz	a5,80004338 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    8000428a:	4505                	li	a0,1
    8000428c:	9782                	jalr	a5
    8000428e:	a8b5                	j	8000430a <filewrite+0xfc>
      if(n1 > max)
    80004290:	2981                	sext.w	s3,s3
      begin_op();
    80004292:	971ff0ef          	jal	80003c02 <begin_op>
      ilock(f->ip);
    80004296:	01893503          	ld	a0,24(s2)
    8000429a:	f5dfe0ef          	jal	800031f6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000429e:	874e                	mv	a4,s3
    800042a0:	02092683          	lw	a3,32(s2)
    800042a4:	016a0633          	add	a2,s4,s6
    800042a8:	85e2                	mv	a1,s8
    800042aa:	01893503          	ld	a0,24(s2)
    800042ae:	bccff0ef          	jal	8000367a <writei>
    800042b2:	84aa                	mv	s1,a0
    800042b4:	00a05763          	blez	a0,800042c2 <filewrite+0xb4>
        f->off += r;
    800042b8:	02092783          	lw	a5,32(s2)
    800042bc:	9fa9                	addw	a5,a5,a0
    800042be:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800042c2:	01893503          	ld	a0,24(s2)
    800042c6:	fdffe0ef          	jal	800032a4 <iunlock>
      end_op();
    800042ca:	9a9ff0ef          	jal	80003c72 <end_op>

      if(r != n1){
    800042ce:	02999563          	bne	s3,s1,800042f8 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    800042d2:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800042d6:	015a5963          	bge	s4,s5,800042e8 <filewrite+0xda>
      int n1 = n - i;
    800042da:	414a87bb          	subw	a5,s5,s4
    800042de:	89be                	mv	s3,a5
      if(n1 > max)
    800042e0:	fafbd8e3          	bge	s7,a5,80004290 <filewrite+0x82>
    800042e4:	89e6                	mv	s3,s9
    800042e6:	b76d                	j	80004290 <filewrite+0x82>
    800042e8:	64a6                	ld	s1,72(sp)
    800042ea:	79e2                	ld	s3,56(sp)
    800042ec:	6be2                	ld	s7,24(sp)
    800042ee:	6c42                	ld	s8,16(sp)
    800042f0:	6ca2                	ld	s9,8(sp)
    800042f2:	a801                	j	80004302 <filewrite+0xf4>
    int i = 0;
    800042f4:	4a01                	li	s4,0
    800042f6:	a031                	j	80004302 <filewrite+0xf4>
    800042f8:	64a6                	ld	s1,72(sp)
    800042fa:	79e2                	ld	s3,56(sp)
    800042fc:	6be2                	ld	s7,24(sp)
    800042fe:	6c42                	ld	s8,16(sp)
    80004300:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004302:	034a9d63          	bne	s5,s4,8000433c <filewrite+0x12e>
    80004306:	8556                	mv	a0,s5
    80004308:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000430a:	60e6                	ld	ra,88(sp)
    8000430c:	6446                	ld	s0,80(sp)
    8000430e:	6906                	ld	s2,64(sp)
    80004310:	7aa2                	ld	s5,40(sp)
    80004312:	7b02                	ld	s6,32(sp)
    80004314:	6125                	addi	sp,sp,96
    80004316:	8082                	ret
    80004318:	e4a6                	sd	s1,72(sp)
    8000431a:	fc4e                	sd	s3,56(sp)
    8000431c:	f852                	sd	s4,48(sp)
    8000431e:	ec5e                	sd	s7,24(sp)
    80004320:	e862                	sd	s8,16(sp)
    80004322:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004324:	00003517          	auipc	a0,0x3
    80004328:	26450513          	addi	a0,a0,612 # 80007588 <etext+0x588>
    8000432c:	cf8fc0ef          	jal	80000824 <panic>
    return -1;
    80004330:	557d                	li	a0,-1
}
    80004332:	8082                	ret
      return -1;
    80004334:	557d                	li	a0,-1
    80004336:	bfd1                	j	8000430a <filewrite+0xfc>
    80004338:	557d                	li	a0,-1
    8000433a:	bfc1                	j	8000430a <filewrite+0xfc>
    ret = (i == n ? n : -1);
    8000433c:	557d                	li	a0,-1
    8000433e:	7a42                	ld	s4,48(sp)
    80004340:	b7e9                	j	8000430a <filewrite+0xfc>

0000000080004342 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004342:	7179                	addi	sp,sp,-48
    80004344:	f406                	sd	ra,40(sp)
    80004346:	f022                	sd	s0,32(sp)
    80004348:	ec26                	sd	s1,24(sp)
    8000434a:	e052                	sd	s4,0(sp)
    8000434c:	1800                	addi	s0,sp,48
    8000434e:	84aa                	mv	s1,a0
    80004350:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004352:	0005b023          	sd	zero,0(a1)
    80004356:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000435a:	c29ff0ef          	jal	80003f82 <filealloc>
    8000435e:	e088                	sd	a0,0(s1)
    80004360:	c549                	beqz	a0,800043ea <pipealloc+0xa8>
    80004362:	c21ff0ef          	jal	80003f82 <filealloc>
    80004366:	00aa3023          	sd	a0,0(s4)
    8000436a:	cd25                	beqz	a0,800043e2 <pipealloc+0xa0>
    8000436c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000436e:	fd6fc0ef          	jal	80000b44 <kalloc>
    80004372:	892a                	mv	s2,a0
    80004374:	c12d                	beqz	a0,800043d6 <pipealloc+0x94>
    80004376:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004378:	4985                	li	s3,1
    8000437a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000437e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004382:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004386:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000438a:	00003597          	auipc	a1,0x3
    8000438e:	20e58593          	addi	a1,a1,526 # 80007598 <etext+0x598>
    80004392:	80dfc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004396:	609c                	ld	a5,0(s1)
    80004398:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000439c:	609c                	ld	a5,0(s1)
    8000439e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800043a2:	609c                	ld	a5,0(s1)
    800043a4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800043a8:	609c                	ld	a5,0(s1)
    800043aa:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800043ae:	000a3783          	ld	a5,0(s4)
    800043b2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800043b6:	000a3783          	ld	a5,0(s4)
    800043ba:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800043be:	000a3783          	ld	a5,0(s4)
    800043c2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800043c6:	000a3783          	ld	a5,0(s4)
    800043ca:	0127b823          	sd	s2,16(a5)
  return 0;
    800043ce:	4501                	li	a0,0
    800043d0:	6942                	ld	s2,16(sp)
    800043d2:	69a2                	ld	s3,8(sp)
    800043d4:	a01d                	j	800043fa <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800043d6:	6088                	ld	a0,0(s1)
    800043d8:	c119                	beqz	a0,800043de <pipealloc+0x9c>
    800043da:	6942                	ld	s2,16(sp)
    800043dc:	a029                	j	800043e6 <pipealloc+0xa4>
    800043de:	6942                	ld	s2,16(sp)
    800043e0:	a029                	j	800043ea <pipealloc+0xa8>
    800043e2:	6088                	ld	a0,0(s1)
    800043e4:	c10d                	beqz	a0,80004406 <pipealloc+0xc4>
    fileclose(*f0);
    800043e6:	c41ff0ef          	jal	80004026 <fileclose>
  if(*f1)
    800043ea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800043ee:	557d                	li	a0,-1
  if(*f1)
    800043f0:	c789                	beqz	a5,800043fa <pipealloc+0xb8>
    fileclose(*f1);
    800043f2:	853e                	mv	a0,a5
    800043f4:	c33ff0ef          	jal	80004026 <fileclose>
  return -1;
    800043f8:	557d                	li	a0,-1
}
    800043fa:	70a2                	ld	ra,40(sp)
    800043fc:	7402                	ld	s0,32(sp)
    800043fe:	64e2                	ld	s1,24(sp)
    80004400:	6a02                	ld	s4,0(sp)
    80004402:	6145                	addi	sp,sp,48
    80004404:	8082                	ret
  return -1;
    80004406:	557d                	li	a0,-1
    80004408:	bfcd                	j	800043fa <pipealloc+0xb8>

000000008000440a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000440a:	1101                	addi	sp,sp,-32
    8000440c:	ec06                	sd	ra,24(sp)
    8000440e:	e822                	sd	s0,16(sp)
    80004410:	e426                	sd	s1,8(sp)
    80004412:	e04a                	sd	s2,0(sp)
    80004414:	1000                	addi	s0,sp,32
    80004416:	84aa                	mv	s1,a0
    80004418:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000441a:	80ffc0ef          	jal	80000c28 <acquire>
  if(writable){
    8000441e:	02090763          	beqz	s2,8000444c <pipeclose+0x42>
    pi->writeopen = 0;
    80004422:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004426:	21848513          	addi	a0,s1,536
    8000442a:	b4ffd0ef          	jal	80001f78 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000442e:	2204a783          	lw	a5,544(s1)
    80004432:	e781                	bnez	a5,8000443a <pipeclose+0x30>
    80004434:	2244a783          	lw	a5,548(s1)
    80004438:	c38d                	beqz	a5,8000445a <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    8000443a:	8526                	mv	a0,s1
    8000443c:	881fc0ef          	jal	80000cbc <release>
}
    80004440:	60e2                	ld	ra,24(sp)
    80004442:	6442                	ld	s0,16(sp)
    80004444:	64a2                	ld	s1,8(sp)
    80004446:	6902                	ld	s2,0(sp)
    80004448:	6105                	addi	sp,sp,32
    8000444a:	8082                	ret
    pi->readopen = 0;
    8000444c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004450:	21c48513          	addi	a0,s1,540
    80004454:	b25fd0ef          	jal	80001f78 <wakeup>
    80004458:	bfd9                	j	8000442e <pipeclose+0x24>
    release(&pi->lock);
    8000445a:	8526                	mv	a0,s1
    8000445c:	861fc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    80004460:	8526                	mv	a0,s1
    80004462:	dfafc0ef          	jal	80000a5c <kfree>
    80004466:	bfe9                	j	80004440 <pipeclose+0x36>

0000000080004468 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004468:	7159                	addi	sp,sp,-112
    8000446a:	f486                	sd	ra,104(sp)
    8000446c:	f0a2                	sd	s0,96(sp)
    8000446e:	eca6                	sd	s1,88(sp)
    80004470:	e8ca                	sd	s2,80(sp)
    80004472:	e4ce                	sd	s3,72(sp)
    80004474:	e0d2                	sd	s4,64(sp)
    80004476:	fc56                	sd	s5,56(sp)
    80004478:	1880                	addi	s0,sp,112
    8000447a:	84aa                	mv	s1,a0
    8000447c:	8aae                	mv	s5,a1
    8000447e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004480:	caefd0ef          	jal	8000192e <myproc>
    80004484:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004486:	8526                	mv	a0,s1
    80004488:	fa0fc0ef          	jal	80000c28 <acquire>
  while(i < n){
    8000448c:	0d405263          	blez	s4,80004550 <pipewrite+0xe8>
    80004490:	f85a                	sd	s6,48(sp)
    80004492:	f45e                	sd	s7,40(sp)
    80004494:	f062                	sd	s8,32(sp)
    80004496:	ec66                	sd	s9,24(sp)
    80004498:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000449a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000449c:	f9f40c13          	addi	s8,s0,-97
    800044a0:	4b85                	li	s7,1
    800044a2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800044a4:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800044a8:	21c48c93          	addi	s9,s1,540
    800044ac:	a82d                	j	800044e6 <pipewrite+0x7e>
      release(&pi->lock);
    800044ae:	8526                	mv	a0,s1
    800044b0:	80dfc0ef          	jal	80000cbc <release>
      return -1;
    800044b4:	597d                	li	s2,-1
    800044b6:	7b42                	ld	s6,48(sp)
    800044b8:	7ba2                	ld	s7,40(sp)
    800044ba:	7c02                	ld	s8,32(sp)
    800044bc:	6ce2                	ld	s9,24(sp)
    800044be:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800044c0:	854a                	mv	a0,s2
    800044c2:	70a6                	ld	ra,104(sp)
    800044c4:	7406                	ld	s0,96(sp)
    800044c6:	64e6                	ld	s1,88(sp)
    800044c8:	6946                	ld	s2,80(sp)
    800044ca:	69a6                	ld	s3,72(sp)
    800044cc:	6a06                	ld	s4,64(sp)
    800044ce:	7ae2                	ld	s5,56(sp)
    800044d0:	6165                	addi	sp,sp,112
    800044d2:	8082                	ret
      wakeup(&pi->nread);
    800044d4:	856a                	mv	a0,s10
    800044d6:	aa3fd0ef          	jal	80001f78 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800044da:	85a6                	mv	a1,s1
    800044dc:	8566                	mv	a0,s9
    800044de:	a4ffd0ef          	jal	80001f2c <sleep>
  while(i < n){
    800044e2:	05495a63          	bge	s2,s4,80004536 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800044e6:	2204a783          	lw	a5,544(s1)
    800044ea:	d3f1                	beqz	a5,800044ae <pipewrite+0x46>
    800044ec:	854e                	mv	a0,s3
    800044ee:	c7bfd0ef          	jal	80002168 <killed>
    800044f2:	fd55                	bnez	a0,800044ae <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800044f4:	2184a783          	lw	a5,536(s1)
    800044f8:	21c4a703          	lw	a4,540(s1)
    800044fc:	2007879b          	addiw	a5,a5,512
    80004500:	fcf70ae3          	beq	a4,a5,800044d4 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004504:	86de                	mv	a3,s7
    80004506:	01590633          	add	a2,s2,s5
    8000450a:	85e2                	mv	a1,s8
    8000450c:	0509b503          	ld	a0,80(s3)
    80004510:	a02fd0ef          	jal	80001712 <copyin>
    80004514:	05650063          	beq	a0,s6,80004554 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004518:	21c4a783          	lw	a5,540(s1)
    8000451c:	0017871b          	addiw	a4,a5,1
    80004520:	20e4ae23          	sw	a4,540(s1)
    80004524:	1ff7f793          	andi	a5,a5,511
    80004528:	97a6                	add	a5,a5,s1
    8000452a:	f9f44703          	lbu	a4,-97(s0)
    8000452e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004532:	2905                	addiw	s2,s2,1
    80004534:	b77d                	j	800044e2 <pipewrite+0x7a>
    80004536:	7b42                	ld	s6,48(sp)
    80004538:	7ba2                	ld	s7,40(sp)
    8000453a:	7c02                	ld	s8,32(sp)
    8000453c:	6ce2                	ld	s9,24(sp)
    8000453e:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004540:	21848513          	addi	a0,s1,536
    80004544:	a35fd0ef          	jal	80001f78 <wakeup>
  release(&pi->lock);
    80004548:	8526                	mv	a0,s1
    8000454a:	f72fc0ef          	jal	80000cbc <release>
  return i;
    8000454e:	bf8d                	j	800044c0 <pipewrite+0x58>
  int i = 0;
    80004550:	4901                	li	s2,0
    80004552:	b7fd                	j	80004540 <pipewrite+0xd8>
    80004554:	7b42                	ld	s6,48(sp)
    80004556:	7ba2                	ld	s7,40(sp)
    80004558:	7c02                	ld	s8,32(sp)
    8000455a:	6ce2                	ld	s9,24(sp)
    8000455c:	6d42                	ld	s10,16(sp)
    8000455e:	b7cd                	j	80004540 <pipewrite+0xd8>

0000000080004560 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004560:	711d                	addi	sp,sp,-96
    80004562:	ec86                	sd	ra,88(sp)
    80004564:	e8a2                	sd	s0,80(sp)
    80004566:	e4a6                	sd	s1,72(sp)
    80004568:	e0ca                	sd	s2,64(sp)
    8000456a:	fc4e                	sd	s3,56(sp)
    8000456c:	f852                	sd	s4,48(sp)
    8000456e:	f456                	sd	s5,40(sp)
    80004570:	1080                	addi	s0,sp,96
    80004572:	84aa                	mv	s1,a0
    80004574:	892e                	mv	s2,a1
    80004576:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004578:	bb6fd0ef          	jal	8000192e <myproc>
    8000457c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000457e:	8526                	mv	a0,s1
    80004580:	ea8fc0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004584:	2184a703          	lw	a4,536(s1)
    80004588:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000458c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004590:	02f71763          	bne	a4,a5,800045be <piperead+0x5e>
    80004594:	2244a783          	lw	a5,548(s1)
    80004598:	cf85                	beqz	a5,800045d0 <piperead+0x70>
    if(killed(pr)){
    8000459a:	8552                	mv	a0,s4
    8000459c:	bcdfd0ef          	jal	80002168 <killed>
    800045a0:	e11d                	bnez	a0,800045c6 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800045a2:	85a6                	mv	a1,s1
    800045a4:	854e                	mv	a0,s3
    800045a6:	987fd0ef          	jal	80001f2c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800045aa:	2184a703          	lw	a4,536(s1)
    800045ae:	21c4a783          	lw	a5,540(s1)
    800045b2:	fef701e3          	beq	a4,a5,80004594 <piperead+0x34>
    800045b6:	f05a                	sd	s6,32(sp)
    800045b8:	ec5e                	sd	s7,24(sp)
    800045ba:	e862                	sd	s8,16(sp)
    800045bc:	a829                	j	800045d6 <piperead+0x76>
    800045be:	f05a                	sd	s6,32(sp)
    800045c0:	ec5e                	sd	s7,24(sp)
    800045c2:	e862                	sd	s8,16(sp)
    800045c4:	a809                	j	800045d6 <piperead+0x76>
      release(&pi->lock);
    800045c6:	8526                	mv	a0,s1
    800045c8:	ef4fc0ef          	jal	80000cbc <release>
      return -1;
    800045cc:	59fd                	li	s3,-1
    800045ce:	a09d                	j	80004634 <piperead+0xd4>
    800045d0:	f05a                	sd	s6,32(sp)
    800045d2:	ec5e                	sd	s7,24(sp)
    800045d4:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045d6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800045d8:	faf40c13          	addi	s8,s0,-81
    800045dc:	4b85                	li	s7,1
    800045de:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800045e0:	05505063          	blez	s5,80004620 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    800045e4:	2184a783          	lw	a5,536(s1)
    800045e8:	21c4a703          	lw	a4,540(s1)
    800045ec:	02f70a63          	beq	a4,a5,80004620 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800045f0:	0017871b          	addiw	a4,a5,1
    800045f4:	20e4ac23          	sw	a4,536(s1)
    800045f8:	1ff7f793          	andi	a5,a5,511
    800045fc:	97a6                	add	a5,a5,s1
    800045fe:	0187c783          	lbu	a5,24(a5)
    80004602:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004606:	86de                	mv	a3,s7
    80004608:	8662                	mv	a2,s8
    8000460a:	85ca                	mv	a1,s2
    8000460c:	050a3503          	ld	a0,80(s4)
    80004610:	844fd0ef          	jal	80001654 <copyout>
    80004614:	01650663          	beq	a0,s6,80004620 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004618:	2985                	addiw	s3,s3,1
    8000461a:	0905                	addi	s2,s2,1
    8000461c:	fd3a94e3          	bne	s5,s3,800045e4 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004620:	21c48513          	addi	a0,s1,540
    80004624:	955fd0ef          	jal	80001f78 <wakeup>
  release(&pi->lock);
    80004628:	8526                	mv	a0,s1
    8000462a:	e92fc0ef          	jal	80000cbc <release>
    8000462e:	7b02                	ld	s6,32(sp)
    80004630:	6be2                	ld	s7,24(sp)
    80004632:	6c42                	ld	s8,16(sp)
  return i;
}
    80004634:	854e                	mv	a0,s3
    80004636:	60e6                	ld	ra,88(sp)
    80004638:	6446                	ld	s0,80(sp)
    8000463a:	64a6                	ld	s1,72(sp)
    8000463c:	6906                	ld	s2,64(sp)
    8000463e:	79e2                	ld	s3,56(sp)
    80004640:	7a42                	ld	s4,48(sp)
    80004642:	7aa2                	ld	s5,40(sp)
    80004644:	6125                	addi	sp,sp,96
    80004646:	8082                	ret

0000000080004648 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004648:	1141                	addi	sp,sp,-16
    8000464a:	e406                	sd	ra,8(sp)
    8000464c:	e022                	sd	s0,0(sp)
    8000464e:	0800                	addi	s0,sp,16
    80004650:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004652:	0035151b          	slliw	a0,a0,0x3
    80004656:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004658:	8b89                	andi	a5,a5,2
    8000465a:	c399                	beqz	a5,80004660 <flags2perm+0x18>
      perm |= PTE_W;
    8000465c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004660:	60a2                	ld	ra,8(sp)
    80004662:	6402                	ld	s0,0(sp)
    80004664:	0141                	addi	sp,sp,16
    80004666:	8082                	ret

0000000080004668 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004668:	de010113          	addi	sp,sp,-544
    8000466c:	20113c23          	sd	ra,536(sp)
    80004670:	20813823          	sd	s0,528(sp)
    80004674:	20913423          	sd	s1,520(sp)
    80004678:	21213023          	sd	s2,512(sp)
    8000467c:	1400                	addi	s0,sp,544
    8000467e:	892a                	mv	s2,a0
    80004680:	dea43823          	sd	a0,-528(s0)
    80004684:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004688:	aa6fd0ef          	jal	8000192e <myproc>
    8000468c:	84aa                	mv	s1,a0

  begin_op();
    8000468e:	d74ff0ef          	jal	80003c02 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004692:	854a                	mv	a0,s2
    80004694:	b90ff0ef          	jal	80003a24 <namei>
    80004698:	cd21                	beqz	a0,800046f0 <kexec+0x88>
    8000469a:	fbd2                	sd	s4,496(sp)
    8000469c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000469e:	b59fe0ef          	jal	800031f6 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800046a2:	04000713          	li	a4,64
    800046a6:	4681                	li	a3,0
    800046a8:	e5040613          	addi	a2,s0,-432
    800046ac:	4581                	li	a1,0
    800046ae:	8552                	mv	a0,s4
    800046b0:	ed9fe0ef          	jal	80003588 <readi>
    800046b4:	04000793          	li	a5,64
    800046b8:	00f51a63          	bne	a0,a5,800046cc <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    800046bc:	e5042703          	lw	a4,-432(s0)
    800046c0:	464c47b7          	lui	a5,0x464c4
    800046c4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800046c8:	02f70863          	beq	a4,a5,800046f8 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800046cc:	8552                	mv	a0,s4
    800046ce:	d35fe0ef          	jal	80003402 <iunlockput>
    end_op();
    800046d2:	da0ff0ef          	jal	80003c72 <end_op>
  }
  return -1;
    800046d6:	557d                	li	a0,-1
    800046d8:	7a5e                	ld	s4,496(sp)
}
    800046da:	21813083          	ld	ra,536(sp)
    800046de:	21013403          	ld	s0,528(sp)
    800046e2:	20813483          	ld	s1,520(sp)
    800046e6:	20013903          	ld	s2,512(sp)
    800046ea:	22010113          	addi	sp,sp,544
    800046ee:	8082                	ret
    end_op();
    800046f0:	d82ff0ef          	jal	80003c72 <end_op>
    return -1;
    800046f4:	557d                	li	a0,-1
    800046f6:	b7d5                	j	800046da <kexec+0x72>
    800046f8:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800046fa:	8526                	mv	a0,s1
    800046fc:	b3cfd0ef          	jal	80001a38 <proc_pagetable>
    80004700:	8b2a                	mv	s6,a0
    80004702:	26050f63          	beqz	a0,80004980 <kexec+0x318>
    80004706:	ffce                	sd	s3,504(sp)
    80004708:	f7d6                	sd	s5,488(sp)
    8000470a:	efde                	sd	s7,472(sp)
    8000470c:	ebe2                	sd	s8,464(sp)
    8000470e:	e7e6                	sd	s9,456(sp)
    80004710:	e3ea                	sd	s10,448(sp)
    80004712:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004714:	e8845783          	lhu	a5,-376(s0)
    80004718:	0e078963          	beqz	a5,8000480a <kexec+0x1a2>
    8000471c:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004720:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004722:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004724:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80004728:	6c85                	lui	s9,0x1
    8000472a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000472e:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004732:	6a85                	lui	s5,0x1
    80004734:	a085                	j	80004794 <kexec+0x12c>
      panic("loadseg: address should exist");
    80004736:	00003517          	auipc	a0,0x3
    8000473a:	e6a50513          	addi	a0,a0,-406 # 800075a0 <etext+0x5a0>
    8000473e:	8e6fc0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    80004742:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004744:	874a                	mv	a4,s2
    80004746:	009b86bb          	addw	a3,s7,s1
    8000474a:	4581                	li	a1,0
    8000474c:	8552                	mv	a0,s4
    8000474e:	e3bfe0ef          	jal	80003588 <readi>
    80004752:	22a91b63          	bne	s2,a0,80004988 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80004756:	009a84bb          	addw	s1,s5,s1
    8000475a:	0334f263          	bgeu	s1,s3,8000477e <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    8000475e:	02049593          	slli	a1,s1,0x20
    80004762:	9181                	srli	a1,a1,0x20
    80004764:	95e2                	add	a1,a1,s8
    80004766:	855a                	mv	a0,s6
    80004768:	8bffc0ef          	jal	80001026 <walkaddr>
    8000476c:	862a                	mv	a2,a0
    if(pa == 0)
    8000476e:	d561                	beqz	a0,80004736 <kexec+0xce>
    if(sz - i < PGSIZE)
    80004770:	409987bb          	subw	a5,s3,s1
    80004774:	893e                	mv	s2,a5
    80004776:	fcfcf6e3          	bgeu	s9,a5,80004742 <kexec+0xda>
    8000477a:	8956                	mv	s2,s5
    8000477c:	b7d9                	j	80004742 <kexec+0xda>
    sz = sz1;
    8000477e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004782:	2d05                	addiw	s10,s10,1
    80004784:	e0843783          	ld	a5,-504(s0)
    80004788:	0387869b          	addiw	a3,a5,56
    8000478c:	e8845783          	lhu	a5,-376(s0)
    80004790:	06fd5e63          	bge	s10,a5,8000480c <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004794:	e0d43423          	sd	a3,-504(s0)
    80004798:	876e                	mv	a4,s11
    8000479a:	e1840613          	addi	a2,s0,-488
    8000479e:	4581                	li	a1,0
    800047a0:	8552                	mv	a0,s4
    800047a2:	de7fe0ef          	jal	80003588 <readi>
    800047a6:	1db51f63          	bne	a0,s11,80004984 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    800047aa:	e1842783          	lw	a5,-488(s0)
    800047ae:	4705                	li	a4,1
    800047b0:	fce799e3          	bne	a5,a4,80004782 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    800047b4:	e4043483          	ld	s1,-448(s0)
    800047b8:	e3843783          	ld	a5,-456(s0)
    800047bc:	1ef4e463          	bltu	s1,a5,800049a4 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800047c0:	e2843783          	ld	a5,-472(s0)
    800047c4:	94be                	add	s1,s1,a5
    800047c6:	1ef4e263          	bltu	s1,a5,800049aa <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    800047ca:	de843703          	ld	a4,-536(s0)
    800047ce:	8ff9                	and	a5,a5,a4
    800047d0:	1e079063          	bnez	a5,800049b0 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800047d4:	e1c42503          	lw	a0,-484(s0)
    800047d8:	e71ff0ef          	jal	80004648 <flags2perm>
    800047dc:	86aa                	mv	a3,a0
    800047de:	8626                	mv	a2,s1
    800047e0:	85ca                	mv	a1,s2
    800047e2:	855a                	mv	a0,s6
    800047e4:	b19fc0ef          	jal	800012fc <uvmalloc>
    800047e8:	dea43c23          	sd	a0,-520(s0)
    800047ec:	1c050563          	beqz	a0,800049b6 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047f0:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047f4:	00098863          	beqz	s3,80004804 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047f8:	e2843c03          	ld	s8,-472(s0)
    800047fc:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004800:	4481                	li	s1,0
    80004802:	bfb1                	j	8000475e <kexec+0xf6>
    sz = sz1;
    80004804:	df843903          	ld	s2,-520(s0)
    80004808:	bfad                	j	80004782 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000480a:	4901                	li	s2,0
  iunlockput(ip);
    8000480c:	8552                	mv	a0,s4
    8000480e:	bf5fe0ef          	jal	80003402 <iunlockput>
  end_op();
    80004812:	c60ff0ef          	jal	80003c72 <end_op>
  p = myproc();
    80004816:	918fd0ef          	jal	8000192e <myproc>
    8000481a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000481c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004820:	6985                	lui	s3,0x1
    80004822:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004824:	99ca                	add	s3,s3,s2
    80004826:	77fd                	lui	a5,0xfffff
    80004828:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000482c:	4691                	li	a3,4
    8000482e:	6609                	lui	a2,0x2
    80004830:	964e                	add	a2,a2,s3
    80004832:	85ce                	mv	a1,s3
    80004834:	855a                	mv	a0,s6
    80004836:	ac7fc0ef          	jal	800012fc <uvmalloc>
    8000483a:	8a2a                	mv	s4,a0
    8000483c:	e105                	bnez	a0,8000485c <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    8000483e:	85ce                	mv	a1,s3
    80004840:	855a                	mv	a0,s6
    80004842:	a7afd0ef          	jal	80001abc <proc_freepagetable>
  return -1;
    80004846:	557d                	li	a0,-1
    80004848:	79fe                	ld	s3,504(sp)
    8000484a:	7a5e                	ld	s4,496(sp)
    8000484c:	7abe                	ld	s5,488(sp)
    8000484e:	7b1e                	ld	s6,480(sp)
    80004850:	6bfe                	ld	s7,472(sp)
    80004852:	6c5e                	ld	s8,464(sp)
    80004854:	6cbe                	ld	s9,456(sp)
    80004856:	6d1e                	ld	s10,448(sp)
    80004858:	7dfa                	ld	s11,440(sp)
    8000485a:	b541                	j	800046da <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000485c:	75f9                	lui	a1,0xffffe
    8000485e:	95aa                	add	a1,a1,a0
    80004860:	855a                	mv	a0,s6
    80004862:	c6dfc0ef          	jal	800014ce <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004866:	800a0b93          	addi	s7,s4,-2048
    8000486a:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    8000486e:	e0043783          	ld	a5,-512(s0)
    80004872:	6388                	ld	a0,0(a5)
  sp = sz;
    80004874:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004876:	4481                	li	s1,0
    ustack[argc] = sp;
    80004878:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    8000487c:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004880:	cd21                	beqz	a0,800048d8 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80004882:	e00fc0ef          	jal	80000e82 <strlen>
    80004886:	0015079b          	addiw	a5,a0,1
    8000488a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000488e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004892:	13796563          	bltu	s2,s7,800049bc <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004896:	e0043d83          	ld	s11,-512(s0)
    8000489a:	000db983          	ld	s3,0(s11)
    8000489e:	854e                	mv	a0,s3
    800048a0:	de2fc0ef          	jal	80000e82 <strlen>
    800048a4:	0015069b          	addiw	a3,a0,1
    800048a8:	864e                	mv	a2,s3
    800048aa:	85ca                	mv	a1,s2
    800048ac:	855a                	mv	a0,s6
    800048ae:	da7fc0ef          	jal	80001654 <copyout>
    800048b2:	10054763          	bltz	a0,800049c0 <kexec+0x358>
    ustack[argc] = sp;
    800048b6:	00349793          	slli	a5,s1,0x3
    800048ba:	97e6                	add	a5,a5,s9
    800048bc:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffde498>
  for(argc = 0; argv[argc]; argc++) {
    800048c0:	0485                	addi	s1,s1,1
    800048c2:	008d8793          	addi	a5,s11,8
    800048c6:	e0f43023          	sd	a5,-512(s0)
    800048ca:	008db503          	ld	a0,8(s11)
    800048ce:	c509                	beqz	a0,800048d8 <kexec+0x270>
    if(argc >= MAXARG)
    800048d0:	fb8499e3          	bne	s1,s8,80004882 <kexec+0x21a>
  sz = sz1;
    800048d4:	89d2                	mv	s3,s4
    800048d6:	b7a5                	j	8000483e <kexec+0x1d6>
  ustack[argc] = 0;
    800048d8:	00349793          	slli	a5,s1,0x3
    800048dc:	f9078793          	addi	a5,a5,-112
    800048e0:	97a2                	add	a5,a5,s0
    800048e2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800048e6:	00349693          	slli	a3,s1,0x3
    800048ea:	06a1                	addi	a3,a3,8
    800048ec:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800048f0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800048f4:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800048f6:	f57964e3          	bltu	s2,s7,8000483e <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800048fa:	e9040613          	addi	a2,s0,-368
    800048fe:	85ca                	mv	a1,s2
    80004900:	855a                	mv	a0,s6
    80004902:	d53fc0ef          	jal	80001654 <copyout>
    80004906:	f2054ce3          	bltz	a0,8000483e <kexec+0x1d6>
  p->trapframe->a1 = sp;
    8000490a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000490e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004912:	df043783          	ld	a5,-528(s0)
    80004916:	0007c703          	lbu	a4,0(a5)
    8000491a:	cf11                	beqz	a4,80004936 <kexec+0x2ce>
    8000491c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000491e:	02f00693          	li	a3,47
    80004922:	a029                	j	8000492c <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80004924:	0785                	addi	a5,a5,1
    80004926:	fff7c703          	lbu	a4,-1(a5)
    8000492a:	c711                	beqz	a4,80004936 <kexec+0x2ce>
    if(*s == '/')
    8000492c:	fed71ce3          	bne	a4,a3,80004924 <kexec+0x2bc>
      last = s+1;
    80004930:	def43823          	sd	a5,-528(s0)
    80004934:	bfc5                	j	80004924 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004936:	4641                	li	a2,16
    80004938:	df043583          	ld	a1,-528(s0)
    8000493c:	158a8513          	addi	a0,s5,344
    80004940:	d0cfc0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    80004944:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004948:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000494c:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004950:	058ab783          	ld	a5,88(s5)
    80004954:	e6843703          	ld	a4,-408(s0)
    80004958:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000495a:	058ab783          	ld	a5,88(s5)
    8000495e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004962:	85ea                	mv	a1,s10
    80004964:	958fd0ef          	jal	80001abc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004968:	0004851b          	sext.w	a0,s1
    8000496c:	79fe                	ld	s3,504(sp)
    8000496e:	7a5e                	ld	s4,496(sp)
    80004970:	7abe                	ld	s5,488(sp)
    80004972:	7b1e                	ld	s6,480(sp)
    80004974:	6bfe                	ld	s7,472(sp)
    80004976:	6c5e                	ld	s8,464(sp)
    80004978:	6cbe                	ld	s9,456(sp)
    8000497a:	6d1e                	ld	s10,448(sp)
    8000497c:	7dfa                	ld	s11,440(sp)
    8000497e:	bbb1                	j	800046da <kexec+0x72>
    80004980:	7b1e                	ld	s6,480(sp)
    80004982:	b3a9                	j	800046cc <kexec+0x64>
    80004984:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004988:	df843583          	ld	a1,-520(s0)
    8000498c:	855a                	mv	a0,s6
    8000498e:	92efd0ef          	jal	80001abc <proc_freepagetable>
  if(ip){
    80004992:	79fe                	ld	s3,504(sp)
    80004994:	7abe                	ld	s5,488(sp)
    80004996:	7b1e                	ld	s6,480(sp)
    80004998:	6bfe                	ld	s7,472(sp)
    8000499a:	6c5e                	ld	s8,464(sp)
    8000499c:	6cbe                	ld	s9,456(sp)
    8000499e:	6d1e                	ld	s10,448(sp)
    800049a0:	7dfa                	ld	s11,440(sp)
    800049a2:	b32d                	j	800046cc <kexec+0x64>
    800049a4:	df243c23          	sd	s2,-520(s0)
    800049a8:	b7c5                	j	80004988 <kexec+0x320>
    800049aa:	df243c23          	sd	s2,-520(s0)
    800049ae:	bfe9                	j	80004988 <kexec+0x320>
    800049b0:	df243c23          	sd	s2,-520(s0)
    800049b4:	bfd1                	j	80004988 <kexec+0x320>
    800049b6:	df243c23          	sd	s2,-520(s0)
    800049ba:	b7f9                	j	80004988 <kexec+0x320>
  sz = sz1;
    800049bc:	89d2                	mv	s3,s4
    800049be:	b541                	j	8000483e <kexec+0x1d6>
    800049c0:	89d2                	mv	s3,s4
    800049c2:	bdb5                	j	8000483e <kexec+0x1d6>

00000000800049c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800049c4:	7179                	addi	sp,sp,-48
    800049c6:	f406                	sd	ra,40(sp)
    800049c8:	f022                	sd	s0,32(sp)
    800049ca:	ec26                	sd	s1,24(sp)
    800049cc:	e84a                	sd	s2,16(sp)
    800049ce:	1800                	addi	s0,sp,48
    800049d0:	892e                	mv	s2,a1
    800049d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800049d4:	fdc40593          	addi	a1,s0,-36
    800049d8:	e61fd0ef          	jal	80002838 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800049dc:	fdc42703          	lw	a4,-36(s0)
    800049e0:	47bd                	li	a5,15
    800049e2:	02e7ea63          	bltu	a5,a4,80004a16 <argfd+0x52>
    800049e6:	f49fc0ef          	jal	8000192e <myproc>
    800049ea:	fdc42703          	lw	a4,-36(s0)
    800049ee:	00371793          	slli	a5,a4,0x3
    800049f2:	0d078793          	addi	a5,a5,208
    800049f6:	953e                	add	a0,a0,a5
    800049f8:	611c                	ld	a5,0(a0)
    800049fa:	c385                	beqz	a5,80004a1a <argfd+0x56>
    return -1;
  if(pfd)
    800049fc:	00090463          	beqz	s2,80004a04 <argfd+0x40>
    *pfd = fd;
    80004a00:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004a04:	4501                	li	a0,0
  if(pf)
    80004a06:	c091                	beqz	s1,80004a0a <argfd+0x46>
    *pf = f;
    80004a08:	e09c                	sd	a5,0(s1)
}
    80004a0a:	70a2                	ld	ra,40(sp)
    80004a0c:	7402                	ld	s0,32(sp)
    80004a0e:	64e2                	ld	s1,24(sp)
    80004a10:	6942                	ld	s2,16(sp)
    80004a12:	6145                	addi	sp,sp,48
    80004a14:	8082                	ret
    return -1;
    80004a16:	557d                	li	a0,-1
    80004a18:	bfcd                	j	80004a0a <argfd+0x46>
    80004a1a:	557d                	li	a0,-1
    80004a1c:	b7fd                	j	80004a0a <argfd+0x46>

0000000080004a1e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004a1e:	1101                	addi	sp,sp,-32
    80004a20:	ec06                	sd	ra,24(sp)
    80004a22:	e822                	sd	s0,16(sp)
    80004a24:	e426                	sd	s1,8(sp)
    80004a26:	1000                	addi	s0,sp,32
    80004a28:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004a2a:	f05fc0ef          	jal	8000192e <myproc>
    80004a2e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004a30:	0d050793          	addi	a5,a0,208
    80004a34:	4501                	li	a0,0
    80004a36:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004a38:	6398                	ld	a4,0(a5)
    80004a3a:	cb19                	beqz	a4,80004a50 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004a3c:	2505                	addiw	a0,a0,1
    80004a3e:	07a1                	addi	a5,a5,8
    80004a40:	fed51ce3          	bne	a0,a3,80004a38 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004a44:	557d                	li	a0,-1
}
    80004a46:	60e2                	ld	ra,24(sp)
    80004a48:	6442                	ld	s0,16(sp)
    80004a4a:	64a2                	ld	s1,8(sp)
    80004a4c:	6105                	addi	sp,sp,32
    80004a4e:	8082                	ret
      p->ofile[fd] = f;
    80004a50:	00351793          	slli	a5,a0,0x3
    80004a54:	0d078793          	addi	a5,a5,208
    80004a58:	963e                	add	a2,a2,a5
    80004a5a:	e204                	sd	s1,0(a2)
      return fd;
    80004a5c:	b7ed                	j	80004a46 <fdalloc+0x28>

0000000080004a5e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004a5e:	715d                	addi	sp,sp,-80
    80004a60:	e486                	sd	ra,72(sp)
    80004a62:	e0a2                	sd	s0,64(sp)
    80004a64:	fc26                	sd	s1,56(sp)
    80004a66:	f84a                	sd	s2,48(sp)
    80004a68:	f44e                	sd	s3,40(sp)
    80004a6a:	f052                	sd	s4,32(sp)
    80004a6c:	ec56                	sd	s5,24(sp)
    80004a6e:	e85a                	sd	s6,16(sp)
    80004a70:	0880                	addi	s0,sp,80
    80004a72:	892e                	mv	s2,a1
    80004a74:	8a2e                	mv	s4,a1
    80004a76:	8ab2                	mv	s5,a2
    80004a78:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004a7a:	fb040593          	addi	a1,s0,-80
    80004a7e:	fc1fe0ef          	jal	80003a3e <nameiparent>
    80004a82:	84aa                	mv	s1,a0
    80004a84:	10050763          	beqz	a0,80004b92 <create+0x134>
    return 0;

  ilock(dp);
    80004a88:	f6efe0ef          	jal	800031f6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004a8c:	4601                	li	a2,0
    80004a8e:	fb040593          	addi	a1,s0,-80
    80004a92:	8526                	mv	a0,s1
    80004a94:	cfdfe0ef          	jal	80003790 <dirlookup>
    80004a98:	89aa                	mv	s3,a0
    80004a9a:	c131                	beqz	a0,80004ade <create+0x80>
    iunlockput(dp);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	965fe0ef          	jal	80003402 <iunlockput>
    ilock(ip);
    80004aa2:	854e                	mv	a0,s3
    80004aa4:	f52fe0ef          	jal	800031f6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004aa8:	4789                	li	a5,2
    80004aaa:	02f91563          	bne	s2,a5,80004ad4 <create+0x76>
    80004aae:	0449d783          	lhu	a5,68(s3)
    80004ab2:	37f9                	addiw	a5,a5,-2
    80004ab4:	17c2                	slli	a5,a5,0x30
    80004ab6:	93c1                	srli	a5,a5,0x30
    80004ab8:	4705                	li	a4,1
    80004aba:	00f76d63          	bltu	a4,a5,80004ad4 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004abe:	854e                	mv	a0,s3
    80004ac0:	60a6                	ld	ra,72(sp)
    80004ac2:	6406                	ld	s0,64(sp)
    80004ac4:	74e2                	ld	s1,56(sp)
    80004ac6:	7942                	ld	s2,48(sp)
    80004ac8:	79a2                	ld	s3,40(sp)
    80004aca:	7a02                	ld	s4,32(sp)
    80004acc:	6ae2                	ld	s5,24(sp)
    80004ace:	6b42                	ld	s6,16(sp)
    80004ad0:	6161                	addi	sp,sp,80
    80004ad2:	8082                	ret
    iunlockput(ip);
    80004ad4:	854e                	mv	a0,s3
    80004ad6:	92dfe0ef          	jal	80003402 <iunlockput>
    return 0;
    80004ada:	4981                	li	s3,0
    80004adc:	b7cd                	j	80004abe <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004ade:	85ca                	mv	a1,s2
    80004ae0:	4088                	lw	a0,0(s1)
    80004ae2:	da4fe0ef          	jal	80003086 <ialloc>
    80004ae6:	892a                	mv	s2,a0
    80004ae8:	cd15                	beqz	a0,80004b24 <create+0xc6>
  ilock(ip);
    80004aea:	f0cfe0ef          	jal	800031f6 <ilock>
  ip->major = major;
    80004aee:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004af2:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004af6:	4785                	li	a5,1
    80004af8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004afc:	854a                	mv	a0,s2
    80004afe:	e44fe0ef          	jal	80003142 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004b02:	4705                	li	a4,1
    80004b04:	02ea0463          	beq	s4,a4,80004b2c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b08:	00492603          	lw	a2,4(s2)
    80004b0c:	fb040593          	addi	a1,s0,-80
    80004b10:	8526                	mv	a0,s1
    80004b12:	e69fe0ef          	jal	8000397a <dirlink>
    80004b16:	06054263          	bltz	a0,80004b7a <create+0x11c>
  iunlockput(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	8e7fe0ef          	jal	80003402 <iunlockput>
  return ip;
    80004b20:	89ca                	mv	s3,s2
    80004b22:	bf71                	j	80004abe <create+0x60>
    iunlockput(dp);
    80004b24:	8526                	mv	a0,s1
    80004b26:	8ddfe0ef          	jal	80003402 <iunlockput>
    return 0;
    80004b2a:	bf51                	j	80004abe <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004b2c:	00492603          	lw	a2,4(s2)
    80004b30:	00003597          	auipc	a1,0x3
    80004b34:	a9058593          	addi	a1,a1,-1392 # 800075c0 <etext+0x5c0>
    80004b38:	854a                	mv	a0,s2
    80004b3a:	e41fe0ef          	jal	8000397a <dirlink>
    80004b3e:	02054e63          	bltz	a0,80004b7a <create+0x11c>
    80004b42:	40d0                	lw	a2,4(s1)
    80004b44:	00003597          	auipc	a1,0x3
    80004b48:	a8458593          	addi	a1,a1,-1404 # 800075c8 <etext+0x5c8>
    80004b4c:	854a                	mv	a0,s2
    80004b4e:	e2dfe0ef          	jal	8000397a <dirlink>
    80004b52:	02054463          	bltz	a0,80004b7a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004b56:	00492603          	lw	a2,4(s2)
    80004b5a:	fb040593          	addi	a1,s0,-80
    80004b5e:	8526                	mv	a0,s1
    80004b60:	e1bfe0ef          	jal	8000397a <dirlink>
    80004b64:	00054b63          	bltz	a0,80004b7a <create+0x11c>
    dp->nlink++;  // for ".."
    80004b68:	04a4d783          	lhu	a5,74(s1)
    80004b6c:	2785                	addiw	a5,a5,1
    80004b6e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b72:	8526                	mv	a0,s1
    80004b74:	dcefe0ef          	jal	80003142 <iupdate>
    80004b78:	b74d                	j	80004b1a <create+0xbc>
  ip->nlink = 0;
    80004b7a:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004b7e:	854a                	mv	a0,s2
    80004b80:	dc2fe0ef          	jal	80003142 <iupdate>
  iunlockput(ip);
    80004b84:	854a                	mv	a0,s2
    80004b86:	87dfe0ef          	jal	80003402 <iunlockput>
  iunlockput(dp);
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	877fe0ef          	jal	80003402 <iunlockput>
  return 0;
    80004b90:	b73d                	j	80004abe <create+0x60>
    return 0;
    80004b92:	89aa                	mv	s3,a0
    80004b94:	b72d                	j	80004abe <create+0x60>

0000000080004b96 <sys_dup>:
{
    80004b96:	7179                	addi	sp,sp,-48
    80004b98:	f406                	sd	ra,40(sp)
    80004b9a:	f022                	sd	s0,32(sp)
    80004b9c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004b9e:	fd840613          	addi	a2,s0,-40
    80004ba2:	4581                	li	a1,0
    80004ba4:	4501                	li	a0,0
    80004ba6:	e1fff0ef          	jal	800049c4 <argfd>
    return -1;
    80004baa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004bac:	02054363          	bltz	a0,80004bd2 <sys_dup+0x3c>
    80004bb0:	ec26                	sd	s1,24(sp)
    80004bb2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004bb4:	fd843483          	ld	s1,-40(s0)
    80004bb8:	8526                	mv	a0,s1
    80004bba:	e65ff0ef          	jal	80004a1e <fdalloc>
    80004bbe:	892a                	mv	s2,a0
    return -1;
    80004bc0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004bc2:	00054d63          	bltz	a0,80004bdc <sys_dup+0x46>
  filedup(f);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	c18ff0ef          	jal	80003fe0 <filedup>
  return fd;
    80004bcc:	87ca                	mv	a5,s2
    80004bce:	64e2                	ld	s1,24(sp)
    80004bd0:	6942                	ld	s2,16(sp)
}
    80004bd2:	853e                	mv	a0,a5
    80004bd4:	70a2                	ld	ra,40(sp)
    80004bd6:	7402                	ld	s0,32(sp)
    80004bd8:	6145                	addi	sp,sp,48
    80004bda:	8082                	ret
    80004bdc:	64e2                	ld	s1,24(sp)
    80004bde:	6942                	ld	s2,16(sp)
    80004be0:	bfcd                	j	80004bd2 <sys_dup+0x3c>

0000000080004be2 <sys_read>:
{
    80004be2:	7179                	addi	sp,sp,-48
    80004be4:	f406                	sd	ra,40(sp)
    80004be6:	f022                	sd	s0,32(sp)
    80004be8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004bea:	fd840593          	addi	a1,s0,-40
    80004bee:	4505                	li	a0,1
    80004bf0:	c65fd0ef          	jal	80002854 <argaddr>
  argint(2, &n);
    80004bf4:	fe440593          	addi	a1,s0,-28
    80004bf8:	4509                	li	a0,2
    80004bfa:	c3ffd0ef          	jal	80002838 <argint>
  if(argfd(0, 0, &f) < 0)
    80004bfe:	fe840613          	addi	a2,s0,-24
    80004c02:	4581                	li	a1,0
    80004c04:	4501                	li	a0,0
    80004c06:	dbfff0ef          	jal	800049c4 <argfd>
    80004c0a:	87aa                	mv	a5,a0
    return -1;
    80004c0c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c0e:	0007ca63          	bltz	a5,80004c22 <sys_read+0x40>
  return fileread(f, p, n);
    80004c12:	fe442603          	lw	a2,-28(s0)
    80004c16:	fd843583          	ld	a1,-40(s0)
    80004c1a:	fe843503          	ld	a0,-24(s0)
    80004c1e:	d2cff0ef          	jal	8000414a <fileread>
}
    80004c22:	70a2                	ld	ra,40(sp)
    80004c24:	7402                	ld	s0,32(sp)
    80004c26:	6145                	addi	sp,sp,48
    80004c28:	8082                	ret

0000000080004c2a <sys_write>:
{
    80004c2a:	7179                	addi	sp,sp,-48
    80004c2c:	f406                	sd	ra,40(sp)
    80004c2e:	f022                	sd	s0,32(sp)
    80004c30:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c32:	fd840593          	addi	a1,s0,-40
    80004c36:	4505                	li	a0,1
    80004c38:	c1dfd0ef          	jal	80002854 <argaddr>
  argint(2, &n);
    80004c3c:	fe440593          	addi	a1,s0,-28
    80004c40:	4509                	li	a0,2
    80004c42:	bf7fd0ef          	jal	80002838 <argint>
  if(argfd(0, 0, &f) < 0)
    80004c46:	fe840613          	addi	a2,s0,-24
    80004c4a:	4581                	li	a1,0
    80004c4c:	4501                	li	a0,0
    80004c4e:	d77ff0ef          	jal	800049c4 <argfd>
    80004c52:	87aa                	mv	a5,a0
    return -1;
    80004c54:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c56:	0007ca63          	bltz	a5,80004c6a <sys_write+0x40>
  return filewrite(f, p, n);
    80004c5a:	fe442603          	lw	a2,-28(s0)
    80004c5e:	fd843583          	ld	a1,-40(s0)
    80004c62:	fe843503          	ld	a0,-24(s0)
    80004c66:	da8ff0ef          	jal	8000420e <filewrite>
}
    80004c6a:	70a2                	ld	ra,40(sp)
    80004c6c:	7402                	ld	s0,32(sp)
    80004c6e:	6145                	addi	sp,sp,48
    80004c70:	8082                	ret

0000000080004c72 <sys_close>:
{
    80004c72:	1101                	addi	sp,sp,-32
    80004c74:	ec06                	sd	ra,24(sp)
    80004c76:	e822                	sd	s0,16(sp)
    80004c78:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004c7a:	fe040613          	addi	a2,s0,-32
    80004c7e:	fec40593          	addi	a1,s0,-20
    80004c82:	4501                	li	a0,0
    80004c84:	d41ff0ef          	jal	800049c4 <argfd>
    return -1;
    80004c88:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004c8a:	02054163          	bltz	a0,80004cac <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004c8e:	ca1fc0ef          	jal	8000192e <myproc>
    80004c92:	fec42783          	lw	a5,-20(s0)
    80004c96:	078e                	slli	a5,a5,0x3
    80004c98:	0d078793          	addi	a5,a5,208
    80004c9c:	953e                	add	a0,a0,a5
    80004c9e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ca2:	fe043503          	ld	a0,-32(s0)
    80004ca6:	b80ff0ef          	jal	80004026 <fileclose>
  return 0;
    80004caa:	4781                	li	a5,0
}
    80004cac:	853e                	mv	a0,a5
    80004cae:	60e2                	ld	ra,24(sp)
    80004cb0:	6442                	ld	s0,16(sp)
    80004cb2:	6105                	addi	sp,sp,32
    80004cb4:	8082                	ret

0000000080004cb6 <sys_fstat>:
{
    80004cb6:	1101                	addi	sp,sp,-32
    80004cb8:	ec06                	sd	ra,24(sp)
    80004cba:	e822                	sd	s0,16(sp)
    80004cbc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004cbe:	fe040593          	addi	a1,s0,-32
    80004cc2:	4505                	li	a0,1
    80004cc4:	b91fd0ef          	jal	80002854 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004cc8:	fe840613          	addi	a2,s0,-24
    80004ccc:	4581                	li	a1,0
    80004cce:	4501                	li	a0,0
    80004cd0:	cf5ff0ef          	jal	800049c4 <argfd>
    80004cd4:	87aa                	mv	a5,a0
    return -1;
    80004cd6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004cd8:	0007c863          	bltz	a5,80004ce8 <sys_fstat+0x32>
  return filestat(f, st);
    80004cdc:	fe043583          	ld	a1,-32(s0)
    80004ce0:	fe843503          	ld	a0,-24(s0)
    80004ce4:	c04ff0ef          	jal	800040e8 <filestat>
}
    80004ce8:	60e2                	ld	ra,24(sp)
    80004cea:	6442                	ld	s0,16(sp)
    80004cec:	6105                	addi	sp,sp,32
    80004cee:	8082                	ret

0000000080004cf0 <sys_link>:
{
    80004cf0:	7169                	addi	sp,sp,-304
    80004cf2:	f606                	sd	ra,296(sp)
    80004cf4:	f222                	sd	s0,288(sp)
    80004cf6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004cf8:	08000613          	li	a2,128
    80004cfc:	ed040593          	addi	a1,s0,-304
    80004d00:	4501                	li	a0,0
    80004d02:	b6ffd0ef          	jal	80002870 <argstr>
    return -1;
    80004d06:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d08:	0c054e63          	bltz	a0,80004de4 <sys_link+0xf4>
    80004d0c:	08000613          	li	a2,128
    80004d10:	f5040593          	addi	a1,s0,-176
    80004d14:	4505                	li	a0,1
    80004d16:	b5bfd0ef          	jal	80002870 <argstr>
    return -1;
    80004d1a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d1c:	0c054463          	bltz	a0,80004de4 <sys_link+0xf4>
    80004d20:	ee26                	sd	s1,280(sp)
  begin_op();
    80004d22:	ee1fe0ef          	jal	80003c02 <begin_op>
  if((ip = namei(old)) == 0){
    80004d26:	ed040513          	addi	a0,s0,-304
    80004d2a:	cfbfe0ef          	jal	80003a24 <namei>
    80004d2e:	84aa                	mv	s1,a0
    80004d30:	c53d                	beqz	a0,80004d9e <sys_link+0xae>
  ilock(ip);
    80004d32:	cc4fe0ef          	jal	800031f6 <ilock>
  if(ip->type == T_DIR){
    80004d36:	04449703          	lh	a4,68(s1)
    80004d3a:	4785                	li	a5,1
    80004d3c:	06f70663          	beq	a4,a5,80004da8 <sys_link+0xb8>
    80004d40:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004d42:	04a4d783          	lhu	a5,74(s1)
    80004d46:	2785                	addiw	a5,a5,1
    80004d48:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	bf4fe0ef          	jal	80003142 <iupdate>
  iunlock(ip);
    80004d52:	8526                	mv	a0,s1
    80004d54:	d50fe0ef          	jal	800032a4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004d58:	fd040593          	addi	a1,s0,-48
    80004d5c:	f5040513          	addi	a0,s0,-176
    80004d60:	cdffe0ef          	jal	80003a3e <nameiparent>
    80004d64:	892a                	mv	s2,a0
    80004d66:	cd21                	beqz	a0,80004dbe <sys_link+0xce>
  ilock(dp);
    80004d68:	c8efe0ef          	jal	800031f6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004d6c:	854a                	mv	a0,s2
    80004d6e:	00092703          	lw	a4,0(s2)
    80004d72:	409c                	lw	a5,0(s1)
    80004d74:	04f71263          	bne	a4,a5,80004db8 <sys_link+0xc8>
    80004d78:	40d0                	lw	a2,4(s1)
    80004d7a:	fd040593          	addi	a1,s0,-48
    80004d7e:	bfdfe0ef          	jal	8000397a <dirlink>
    80004d82:	02054b63          	bltz	a0,80004db8 <sys_link+0xc8>
  iunlockput(dp);
    80004d86:	854a                	mv	a0,s2
    80004d88:	e7afe0ef          	jal	80003402 <iunlockput>
  iput(ip);
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	deafe0ef          	jal	80003378 <iput>
  end_op();
    80004d92:	ee1fe0ef          	jal	80003c72 <end_op>
  return 0;
    80004d96:	4781                	li	a5,0
    80004d98:	64f2                	ld	s1,280(sp)
    80004d9a:	6952                	ld	s2,272(sp)
    80004d9c:	a0a1                	j	80004de4 <sys_link+0xf4>
    end_op();
    80004d9e:	ed5fe0ef          	jal	80003c72 <end_op>
    return -1;
    80004da2:	57fd                	li	a5,-1
    80004da4:	64f2                	ld	s1,280(sp)
    80004da6:	a83d                	j	80004de4 <sys_link+0xf4>
    iunlockput(ip);
    80004da8:	8526                	mv	a0,s1
    80004daa:	e58fe0ef          	jal	80003402 <iunlockput>
    end_op();
    80004dae:	ec5fe0ef          	jal	80003c72 <end_op>
    return -1;
    80004db2:	57fd                	li	a5,-1
    80004db4:	64f2                	ld	s1,280(sp)
    80004db6:	a03d                	j	80004de4 <sys_link+0xf4>
    iunlockput(dp);
    80004db8:	854a                	mv	a0,s2
    80004dba:	e48fe0ef          	jal	80003402 <iunlockput>
  ilock(ip);
    80004dbe:	8526                	mv	a0,s1
    80004dc0:	c36fe0ef          	jal	800031f6 <ilock>
  ip->nlink--;
    80004dc4:	04a4d783          	lhu	a5,74(s1)
    80004dc8:	37fd                	addiw	a5,a5,-1
    80004dca:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004dce:	8526                	mv	a0,s1
    80004dd0:	b72fe0ef          	jal	80003142 <iupdate>
  iunlockput(ip);
    80004dd4:	8526                	mv	a0,s1
    80004dd6:	e2cfe0ef          	jal	80003402 <iunlockput>
  end_op();
    80004dda:	e99fe0ef          	jal	80003c72 <end_op>
  return -1;
    80004dde:	57fd                	li	a5,-1
    80004de0:	64f2                	ld	s1,280(sp)
    80004de2:	6952                	ld	s2,272(sp)
}
    80004de4:	853e                	mv	a0,a5
    80004de6:	70b2                	ld	ra,296(sp)
    80004de8:	7412                	ld	s0,288(sp)
    80004dea:	6155                	addi	sp,sp,304
    80004dec:	8082                	ret

0000000080004dee <sys_unlink>:
{
    80004dee:	7151                	addi	sp,sp,-240
    80004df0:	f586                	sd	ra,232(sp)
    80004df2:	f1a2                	sd	s0,224(sp)
    80004df4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004df6:	08000613          	li	a2,128
    80004dfa:	f3040593          	addi	a1,s0,-208
    80004dfe:	4501                	li	a0,0
    80004e00:	a71fd0ef          	jal	80002870 <argstr>
    80004e04:	14054d63          	bltz	a0,80004f5e <sys_unlink+0x170>
    80004e08:	eda6                	sd	s1,216(sp)
  begin_op();
    80004e0a:	df9fe0ef          	jal	80003c02 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004e0e:	fb040593          	addi	a1,s0,-80
    80004e12:	f3040513          	addi	a0,s0,-208
    80004e16:	c29fe0ef          	jal	80003a3e <nameiparent>
    80004e1a:	84aa                	mv	s1,a0
    80004e1c:	c955                	beqz	a0,80004ed0 <sys_unlink+0xe2>
  ilock(dp);
    80004e1e:	bd8fe0ef          	jal	800031f6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004e22:	00002597          	auipc	a1,0x2
    80004e26:	79e58593          	addi	a1,a1,1950 # 800075c0 <etext+0x5c0>
    80004e2a:	fb040513          	addi	a0,s0,-80
    80004e2e:	94dfe0ef          	jal	8000377a <namecmp>
    80004e32:	10050b63          	beqz	a0,80004f48 <sys_unlink+0x15a>
    80004e36:	00002597          	auipc	a1,0x2
    80004e3a:	79258593          	addi	a1,a1,1938 # 800075c8 <etext+0x5c8>
    80004e3e:	fb040513          	addi	a0,s0,-80
    80004e42:	939fe0ef          	jal	8000377a <namecmp>
    80004e46:	10050163          	beqz	a0,80004f48 <sys_unlink+0x15a>
    80004e4a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004e4c:	f2c40613          	addi	a2,s0,-212
    80004e50:	fb040593          	addi	a1,s0,-80
    80004e54:	8526                	mv	a0,s1
    80004e56:	93bfe0ef          	jal	80003790 <dirlookup>
    80004e5a:	892a                	mv	s2,a0
    80004e5c:	0e050563          	beqz	a0,80004f46 <sys_unlink+0x158>
    80004e60:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004e62:	b94fe0ef          	jal	800031f6 <ilock>
  if(ip->nlink < 1)
    80004e66:	04a91783          	lh	a5,74(s2)
    80004e6a:	06f05863          	blez	a5,80004eda <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004e6e:	04491703          	lh	a4,68(s2)
    80004e72:	4785                	li	a5,1
    80004e74:	06f70963          	beq	a4,a5,80004ee6 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004e78:	fc040993          	addi	s3,s0,-64
    80004e7c:	4641                	li	a2,16
    80004e7e:	4581                	li	a1,0
    80004e80:	854e                	mv	a0,s3
    80004e82:	e77fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e86:	4741                	li	a4,16
    80004e88:	f2c42683          	lw	a3,-212(s0)
    80004e8c:	864e                	mv	a2,s3
    80004e8e:	4581                	li	a1,0
    80004e90:	8526                	mv	a0,s1
    80004e92:	fe8fe0ef          	jal	8000367a <writei>
    80004e96:	47c1                	li	a5,16
    80004e98:	08f51863          	bne	a0,a5,80004f28 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004e9c:	04491703          	lh	a4,68(s2)
    80004ea0:	4785                	li	a5,1
    80004ea2:	08f70963          	beq	a4,a5,80004f34 <sys_unlink+0x146>
  iunlockput(dp);
    80004ea6:	8526                	mv	a0,s1
    80004ea8:	d5afe0ef          	jal	80003402 <iunlockput>
  ip->nlink--;
    80004eac:	04a95783          	lhu	a5,74(s2)
    80004eb0:	37fd                	addiw	a5,a5,-1
    80004eb2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004eb6:	854a                	mv	a0,s2
    80004eb8:	a8afe0ef          	jal	80003142 <iupdate>
  iunlockput(ip);
    80004ebc:	854a                	mv	a0,s2
    80004ebe:	d44fe0ef          	jal	80003402 <iunlockput>
  end_op();
    80004ec2:	db1fe0ef          	jal	80003c72 <end_op>
  return 0;
    80004ec6:	4501                	li	a0,0
    80004ec8:	64ee                	ld	s1,216(sp)
    80004eca:	694e                	ld	s2,208(sp)
    80004ecc:	69ae                	ld	s3,200(sp)
    80004ece:	a061                	j	80004f56 <sys_unlink+0x168>
    end_op();
    80004ed0:	da3fe0ef          	jal	80003c72 <end_op>
    return -1;
    80004ed4:	557d                	li	a0,-1
    80004ed6:	64ee                	ld	s1,216(sp)
    80004ed8:	a8bd                	j	80004f56 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004eda:	00002517          	auipc	a0,0x2
    80004ede:	6f650513          	addi	a0,a0,1782 # 800075d0 <etext+0x5d0>
    80004ee2:	943fb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ee6:	04c92703          	lw	a4,76(s2)
    80004eea:	02000793          	li	a5,32
    80004eee:	f8e7f5e3          	bgeu	a5,a4,80004e78 <sys_unlink+0x8a>
    80004ef2:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ef4:	4741                	li	a4,16
    80004ef6:	86ce                	mv	a3,s3
    80004ef8:	f1840613          	addi	a2,s0,-232
    80004efc:	4581                	li	a1,0
    80004efe:	854a                	mv	a0,s2
    80004f00:	e88fe0ef          	jal	80003588 <readi>
    80004f04:	47c1                	li	a5,16
    80004f06:	00f51b63          	bne	a0,a5,80004f1c <sys_unlink+0x12e>
    if(de.inum != 0)
    80004f0a:	f1845783          	lhu	a5,-232(s0)
    80004f0e:	ebb1                	bnez	a5,80004f62 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004f10:	29c1                	addiw	s3,s3,16
    80004f12:	04c92783          	lw	a5,76(s2)
    80004f16:	fcf9efe3          	bltu	s3,a5,80004ef4 <sys_unlink+0x106>
    80004f1a:	bfb9                	j	80004e78 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004f1c:	00002517          	auipc	a0,0x2
    80004f20:	6cc50513          	addi	a0,a0,1740 # 800075e8 <etext+0x5e8>
    80004f24:	901fb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    80004f28:	00002517          	auipc	a0,0x2
    80004f2c:	6d850513          	addi	a0,a0,1752 # 80007600 <etext+0x600>
    80004f30:	8f5fb0ef          	jal	80000824 <panic>
    dp->nlink--;
    80004f34:	04a4d783          	lhu	a5,74(s1)
    80004f38:	37fd                	addiw	a5,a5,-1
    80004f3a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f3e:	8526                	mv	a0,s1
    80004f40:	a02fe0ef          	jal	80003142 <iupdate>
    80004f44:	b78d                	j	80004ea6 <sys_unlink+0xb8>
    80004f46:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004f48:	8526                	mv	a0,s1
    80004f4a:	cb8fe0ef          	jal	80003402 <iunlockput>
  end_op();
    80004f4e:	d25fe0ef          	jal	80003c72 <end_op>
  return -1;
    80004f52:	557d                	li	a0,-1
    80004f54:	64ee                	ld	s1,216(sp)
}
    80004f56:	70ae                	ld	ra,232(sp)
    80004f58:	740e                	ld	s0,224(sp)
    80004f5a:	616d                	addi	sp,sp,240
    80004f5c:	8082                	ret
    return -1;
    80004f5e:	557d                	li	a0,-1
    80004f60:	bfdd                	j	80004f56 <sys_unlink+0x168>
    iunlockput(ip);
    80004f62:	854a                	mv	a0,s2
    80004f64:	c9efe0ef          	jal	80003402 <iunlockput>
    goto bad;
    80004f68:	694e                	ld	s2,208(sp)
    80004f6a:	69ae                	ld	s3,200(sp)
    80004f6c:	bff1                	j	80004f48 <sys_unlink+0x15a>

0000000080004f6e <sys_open>:

uint64
sys_open(void)
{
    80004f6e:	7131                	addi	sp,sp,-192
    80004f70:	fd06                	sd	ra,184(sp)
    80004f72:	f922                	sd	s0,176(sp)
    80004f74:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004f76:	f4c40593          	addi	a1,s0,-180
    80004f7a:	4505                	li	a0,1
    80004f7c:	8bdfd0ef          	jal	80002838 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f80:	08000613          	li	a2,128
    80004f84:	f5040593          	addi	a1,s0,-176
    80004f88:	4501                	li	a0,0
    80004f8a:	8e7fd0ef          	jal	80002870 <argstr>
    80004f8e:	87aa                	mv	a5,a0
    return -1;
    80004f90:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004f92:	0a07c363          	bltz	a5,80005038 <sys_open+0xca>
    80004f96:	f526                	sd	s1,168(sp)

  begin_op();
    80004f98:	c6bfe0ef          	jal	80003c02 <begin_op>

  if(omode & O_CREATE){
    80004f9c:	f4c42783          	lw	a5,-180(s0)
    80004fa0:	2007f793          	andi	a5,a5,512
    80004fa4:	c3dd                	beqz	a5,8000504a <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004fa6:	4681                	li	a3,0
    80004fa8:	4601                	li	a2,0
    80004faa:	4589                	li	a1,2
    80004fac:	f5040513          	addi	a0,s0,-176
    80004fb0:	aafff0ef          	jal	80004a5e <create>
    80004fb4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004fb6:	c549                	beqz	a0,80005040 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004fb8:	04449703          	lh	a4,68(s1)
    80004fbc:	478d                	li	a5,3
    80004fbe:	00f71763          	bne	a4,a5,80004fcc <sys_open+0x5e>
    80004fc2:	0464d703          	lhu	a4,70(s1)
    80004fc6:	47a5                	li	a5,9
    80004fc8:	0ae7ee63          	bltu	a5,a4,80005084 <sys_open+0x116>
    80004fcc:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004fce:	fb5fe0ef          	jal	80003f82 <filealloc>
    80004fd2:	892a                	mv	s2,a0
    80004fd4:	c561                	beqz	a0,8000509c <sys_open+0x12e>
    80004fd6:	ed4e                	sd	s3,152(sp)
    80004fd8:	a47ff0ef          	jal	80004a1e <fdalloc>
    80004fdc:	89aa                	mv	s3,a0
    80004fde:	0a054b63          	bltz	a0,80005094 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004fe2:	04449703          	lh	a4,68(s1)
    80004fe6:	478d                	li	a5,3
    80004fe8:	0cf70363          	beq	a4,a5,800050ae <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004fec:	4789                	li	a5,2
    80004fee:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004ff2:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004ff6:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004ffa:	f4c42783          	lw	a5,-180(s0)
    80004ffe:	0017f713          	andi	a4,a5,1
    80005002:	00174713          	xori	a4,a4,1
    80005006:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000500a:	0037f713          	andi	a4,a5,3
    8000500e:	00e03733          	snez	a4,a4
    80005012:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005016:	4007f793          	andi	a5,a5,1024
    8000501a:	c791                	beqz	a5,80005026 <sys_open+0xb8>
    8000501c:	04449703          	lh	a4,68(s1)
    80005020:	4789                	li	a5,2
    80005022:	08f70d63          	beq	a4,a5,800050bc <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005026:	8526                	mv	a0,s1
    80005028:	a7cfe0ef          	jal	800032a4 <iunlock>
  end_op();
    8000502c:	c47fe0ef          	jal	80003c72 <end_op>

  return fd;
    80005030:	854e                	mv	a0,s3
    80005032:	74aa                	ld	s1,168(sp)
    80005034:	790a                	ld	s2,160(sp)
    80005036:	69ea                	ld	s3,152(sp)
}
    80005038:	70ea                	ld	ra,184(sp)
    8000503a:	744a                	ld	s0,176(sp)
    8000503c:	6129                	addi	sp,sp,192
    8000503e:	8082                	ret
      end_op();
    80005040:	c33fe0ef          	jal	80003c72 <end_op>
      return -1;
    80005044:	557d                	li	a0,-1
    80005046:	74aa                	ld	s1,168(sp)
    80005048:	bfc5                	j	80005038 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000504a:	f5040513          	addi	a0,s0,-176
    8000504e:	9d7fe0ef          	jal	80003a24 <namei>
    80005052:	84aa                	mv	s1,a0
    80005054:	c11d                	beqz	a0,8000507a <sys_open+0x10c>
    ilock(ip);
    80005056:	9a0fe0ef          	jal	800031f6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000505a:	04449703          	lh	a4,68(s1)
    8000505e:	4785                	li	a5,1
    80005060:	f4f71ce3          	bne	a4,a5,80004fb8 <sys_open+0x4a>
    80005064:	f4c42783          	lw	a5,-180(s0)
    80005068:	d3b5                	beqz	a5,80004fcc <sys_open+0x5e>
      iunlockput(ip);
    8000506a:	8526                	mv	a0,s1
    8000506c:	b96fe0ef          	jal	80003402 <iunlockput>
      end_op();
    80005070:	c03fe0ef          	jal	80003c72 <end_op>
      return -1;
    80005074:	557d                	li	a0,-1
    80005076:	74aa                	ld	s1,168(sp)
    80005078:	b7c1                	j	80005038 <sys_open+0xca>
      end_op();
    8000507a:	bf9fe0ef          	jal	80003c72 <end_op>
      return -1;
    8000507e:	557d                	li	a0,-1
    80005080:	74aa                	ld	s1,168(sp)
    80005082:	bf5d                	j	80005038 <sys_open+0xca>
    iunlockput(ip);
    80005084:	8526                	mv	a0,s1
    80005086:	b7cfe0ef          	jal	80003402 <iunlockput>
    end_op();
    8000508a:	be9fe0ef          	jal	80003c72 <end_op>
    return -1;
    8000508e:	557d                	li	a0,-1
    80005090:	74aa                	ld	s1,168(sp)
    80005092:	b75d                	j	80005038 <sys_open+0xca>
      fileclose(f);
    80005094:	854a                	mv	a0,s2
    80005096:	f91fe0ef          	jal	80004026 <fileclose>
    8000509a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000509c:	8526                	mv	a0,s1
    8000509e:	b64fe0ef          	jal	80003402 <iunlockput>
    end_op();
    800050a2:	bd1fe0ef          	jal	80003c72 <end_op>
    return -1;
    800050a6:	557d                	li	a0,-1
    800050a8:	74aa                	ld	s1,168(sp)
    800050aa:	790a                	ld	s2,160(sp)
    800050ac:	b771                	j	80005038 <sys_open+0xca>
    f->type = FD_DEVICE;
    800050ae:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800050b2:	04649783          	lh	a5,70(s1)
    800050b6:	02f91223          	sh	a5,36(s2)
    800050ba:	bf35                	j	80004ff6 <sys_open+0x88>
    itrunc(ip);
    800050bc:	8526                	mv	a0,s1
    800050be:	a26fe0ef          	jal	800032e4 <itrunc>
    800050c2:	b795                	j	80005026 <sys_open+0xb8>

00000000800050c4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800050c4:	7175                	addi	sp,sp,-144
    800050c6:	e506                	sd	ra,136(sp)
    800050c8:	e122                	sd	s0,128(sp)
    800050ca:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800050cc:	b37fe0ef          	jal	80003c02 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800050d0:	08000613          	li	a2,128
    800050d4:	f7040593          	addi	a1,s0,-144
    800050d8:	4501                	li	a0,0
    800050da:	f96fd0ef          	jal	80002870 <argstr>
    800050de:	02054363          	bltz	a0,80005104 <sys_mkdir+0x40>
    800050e2:	4681                	li	a3,0
    800050e4:	4601                	li	a2,0
    800050e6:	4585                	li	a1,1
    800050e8:	f7040513          	addi	a0,s0,-144
    800050ec:	973ff0ef          	jal	80004a5e <create>
    800050f0:	c911                	beqz	a0,80005104 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050f2:	b10fe0ef          	jal	80003402 <iunlockput>
  end_op();
    800050f6:	b7dfe0ef          	jal	80003c72 <end_op>
  return 0;
    800050fa:	4501                	li	a0,0
}
    800050fc:	60aa                	ld	ra,136(sp)
    800050fe:	640a                	ld	s0,128(sp)
    80005100:	6149                	addi	sp,sp,144
    80005102:	8082                	ret
    end_op();
    80005104:	b6ffe0ef          	jal	80003c72 <end_op>
    return -1;
    80005108:	557d                	li	a0,-1
    8000510a:	bfcd                	j	800050fc <sys_mkdir+0x38>

000000008000510c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000510c:	7135                	addi	sp,sp,-160
    8000510e:	ed06                	sd	ra,152(sp)
    80005110:	e922                	sd	s0,144(sp)
    80005112:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005114:	aeffe0ef          	jal	80003c02 <begin_op>
  argint(1, &major);
    80005118:	f6c40593          	addi	a1,s0,-148
    8000511c:	4505                	li	a0,1
    8000511e:	f1afd0ef          	jal	80002838 <argint>
  argint(2, &minor);
    80005122:	f6840593          	addi	a1,s0,-152
    80005126:	4509                	li	a0,2
    80005128:	f10fd0ef          	jal	80002838 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000512c:	08000613          	li	a2,128
    80005130:	f7040593          	addi	a1,s0,-144
    80005134:	4501                	li	a0,0
    80005136:	f3afd0ef          	jal	80002870 <argstr>
    8000513a:	02054563          	bltz	a0,80005164 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000513e:	f6841683          	lh	a3,-152(s0)
    80005142:	f6c41603          	lh	a2,-148(s0)
    80005146:	458d                	li	a1,3
    80005148:	f7040513          	addi	a0,s0,-144
    8000514c:	913ff0ef          	jal	80004a5e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005150:	c911                	beqz	a0,80005164 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005152:	ab0fe0ef          	jal	80003402 <iunlockput>
  end_op();
    80005156:	b1dfe0ef          	jal	80003c72 <end_op>
  return 0;
    8000515a:	4501                	li	a0,0
}
    8000515c:	60ea                	ld	ra,152(sp)
    8000515e:	644a                	ld	s0,144(sp)
    80005160:	610d                	addi	sp,sp,160
    80005162:	8082                	ret
    end_op();
    80005164:	b0ffe0ef          	jal	80003c72 <end_op>
    return -1;
    80005168:	557d                	li	a0,-1
    8000516a:	bfcd                	j	8000515c <sys_mknod+0x50>

000000008000516c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000516c:	7135                	addi	sp,sp,-160
    8000516e:	ed06                	sd	ra,152(sp)
    80005170:	e922                	sd	s0,144(sp)
    80005172:	e14a                	sd	s2,128(sp)
    80005174:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005176:	fb8fc0ef          	jal	8000192e <myproc>
    8000517a:	892a                	mv	s2,a0
  
  begin_op();
    8000517c:	a87fe0ef          	jal	80003c02 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005180:	08000613          	li	a2,128
    80005184:	f6040593          	addi	a1,s0,-160
    80005188:	4501                	li	a0,0
    8000518a:	ee6fd0ef          	jal	80002870 <argstr>
    8000518e:	04054363          	bltz	a0,800051d4 <sys_chdir+0x68>
    80005192:	e526                	sd	s1,136(sp)
    80005194:	f6040513          	addi	a0,s0,-160
    80005198:	88dfe0ef          	jal	80003a24 <namei>
    8000519c:	84aa                	mv	s1,a0
    8000519e:	c915                	beqz	a0,800051d2 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800051a0:	856fe0ef          	jal	800031f6 <ilock>
  if(ip->type != T_DIR){
    800051a4:	04449703          	lh	a4,68(s1)
    800051a8:	4785                	li	a5,1
    800051aa:	02f71963          	bne	a4,a5,800051dc <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051ae:	8526                	mv	a0,s1
    800051b0:	8f4fe0ef          	jal	800032a4 <iunlock>
  iput(p->cwd);
    800051b4:	15093503          	ld	a0,336(s2)
    800051b8:	9c0fe0ef          	jal	80003378 <iput>
  end_op();
    800051bc:	ab7fe0ef          	jal	80003c72 <end_op>
  p->cwd = ip;
    800051c0:	14993823          	sd	s1,336(s2)
  return 0;
    800051c4:	4501                	li	a0,0
    800051c6:	64aa                	ld	s1,136(sp)
}
    800051c8:	60ea                	ld	ra,152(sp)
    800051ca:	644a                	ld	s0,144(sp)
    800051cc:	690a                	ld	s2,128(sp)
    800051ce:	610d                	addi	sp,sp,160
    800051d0:	8082                	ret
    800051d2:	64aa                	ld	s1,136(sp)
    end_op();
    800051d4:	a9ffe0ef          	jal	80003c72 <end_op>
    return -1;
    800051d8:	557d                	li	a0,-1
    800051da:	b7fd                	j	800051c8 <sys_chdir+0x5c>
    iunlockput(ip);
    800051dc:	8526                	mv	a0,s1
    800051de:	a24fe0ef          	jal	80003402 <iunlockput>
    end_op();
    800051e2:	a91fe0ef          	jal	80003c72 <end_op>
    return -1;
    800051e6:	557d                	li	a0,-1
    800051e8:	64aa                	ld	s1,136(sp)
    800051ea:	bff9                	j	800051c8 <sys_chdir+0x5c>

00000000800051ec <sys_exec>:

uint64
sys_exec(void)
{
    800051ec:	7105                	addi	sp,sp,-480
    800051ee:	ef86                	sd	ra,472(sp)
    800051f0:	eba2                	sd	s0,464(sp)
    800051f2:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051f4:	e2840593          	addi	a1,s0,-472
    800051f8:	4505                	li	a0,1
    800051fa:	e5afd0ef          	jal	80002854 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051fe:	08000613          	li	a2,128
    80005202:	f3040593          	addi	a1,s0,-208
    80005206:	4501                	li	a0,0
    80005208:	e68fd0ef          	jal	80002870 <argstr>
    8000520c:	87aa                	mv	a5,a0
    return -1;
    8000520e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005210:	0e07c063          	bltz	a5,800052f0 <sys_exec+0x104>
    80005214:	e7a6                	sd	s1,456(sp)
    80005216:	e3ca                	sd	s2,448(sp)
    80005218:	ff4e                	sd	s3,440(sp)
    8000521a:	fb52                	sd	s4,432(sp)
    8000521c:	f756                	sd	s5,424(sp)
    8000521e:	f35a                	sd	s6,416(sp)
    80005220:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005222:	e3040a13          	addi	s4,s0,-464
    80005226:	10000613          	li	a2,256
    8000522a:	4581                	li	a1,0
    8000522c:	8552                	mv	a0,s4
    8000522e:	acbfb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005232:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005234:	89d2                	mv	s3,s4
    80005236:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005238:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000523c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000523e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005242:	00391513          	slli	a0,s2,0x3
    80005246:	85d6                	mv	a1,s5
    80005248:	e2843783          	ld	a5,-472(s0)
    8000524c:	953e                	add	a0,a0,a5
    8000524e:	d60fd0ef          	jal	800027ae <fetchaddr>
    80005252:	02054663          	bltz	a0,8000527e <sys_exec+0x92>
    if(uarg == 0){
    80005256:	e2043783          	ld	a5,-480(s0)
    8000525a:	c7a1                	beqz	a5,800052a2 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000525c:	8e9fb0ef          	jal	80000b44 <kalloc>
    80005260:	85aa                	mv	a1,a0
    80005262:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005266:	cd01                	beqz	a0,8000527e <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005268:	865a                	mv	a2,s6
    8000526a:	e2043503          	ld	a0,-480(s0)
    8000526e:	d8afd0ef          	jal	800027f8 <fetchstr>
    80005272:	00054663          	bltz	a0,8000527e <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80005276:	0905                	addi	s2,s2,1
    80005278:	09a1                	addi	s3,s3,8
    8000527a:	fd7914e3          	bne	s2,s7,80005242 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000527e:	100a0a13          	addi	s4,s4,256
    80005282:	6088                	ld	a0,0(s1)
    80005284:	cd31                	beqz	a0,800052e0 <sys_exec+0xf4>
    kfree(argv[i]);
    80005286:	fd6fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000528a:	04a1                	addi	s1,s1,8
    8000528c:	ff449be3          	bne	s1,s4,80005282 <sys_exec+0x96>
  return -1;
    80005290:	557d                	li	a0,-1
    80005292:	64be                	ld	s1,456(sp)
    80005294:	691e                	ld	s2,448(sp)
    80005296:	79fa                	ld	s3,440(sp)
    80005298:	7a5a                	ld	s4,432(sp)
    8000529a:	7aba                	ld	s5,424(sp)
    8000529c:	7b1a                	ld	s6,416(sp)
    8000529e:	6bfa                	ld	s7,408(sp)
    800052a0:	a881                	j	800052f0 <sys_exec+0x104>
      argv[i] = 0;
    800052a2:	0009079b          	sext.w	a5,s2
    800052a6:	e3040593          	addi	a1,s0,-464
    800052aa:	078e                	slli	a5,a5,0x3
    800052ac:	97ae                	add	a5,a5,a1
    800052ae:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800052b2:	f3040513          	addi	a0,s0,-208
    800052b6:	bb2ff0ef          	jal	80004668 <kexec>
    800052ba:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052bc:	100a0a13          	addi	s4,s4,256
    800052c0:	6088                	ld	a0,0(s1)
    800052c2:	c511                	beqz	a0,800052ce <sys_exec+0xe2>
    kfree(argv[i]);
    800052c4:	f98fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052c8:	04a1                	addi	s1,s1,8
    800052ca:	ff449be3          	bne	s1,s4,800052c0 <sys_exec+0xd4>
  return ret;
    800052ce:	854a                	mv	a0,s2
    800052d0:	64be                	ld	s1,456(sp)
    800052d2:	691e                	ld	s2,448(sp)
    800052d4:	79fa                	ld	s3,440(sp)
    800052d6:	7a5a                	ld	s4,432(sp)
    800052d8:	7aba                	ld	s5,424(sp)
    800052da:	7b1a                	ld	s6,416(sp)
    800052dc:	6bfa                	ld	s7,408(sp)
    800052de:	a809                	j	800052f0 <sys_exec+0x104>
  return -1;
    800052e0:	557d                	li	a0,-1
    800052e2:	64be                	ld	s1,456(sp)
    800052e4:	691e                	ld	s2,448(sp)
    800052e6:	79fa                	ld	s3,440(sp)
    800052e8:	7a5a                	ld	s4,432(sp)
    800052ea:	7aba                	ld	s5,424(sp)
    800052ec:	7b1a                	ld	s6,416(sp)
    800052ee:	6bfa                	ld	s7,408(sp)
}
    800052f0:	60fe                	ld	ra,472(sp)
    800052f2:	645e                	ld	s0,464(sp)
    800052f4:	613d                	addi	sp,sp,480
    800052f6:	8082                	ret

00000000800052f8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800052f8:	7139                	addi	sp,sp,-64
    800052fa:	fc06                	sd	ra,56(sp)
    800052fc:	f822                	sd	s0,48(sp)
    800052fe:	f426                	sd	s1,40(sp)
    80005300:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005302:	e2cfc0ef          	jal	8000192e <myproc>
    80005306:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005308:	fd840593          	addi	a1,s0,-40
    8000530c:	4501                	li	a0,0
    8000530e:	d46fd0ef          	jal	80002854 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005312:	fc840593          	addi	a1,s0,-56
    80005316:	fd040513          	addi	a0,s0,-48
    8000531a:	828ff0ef          	jal	80004342 <pipealloc>
    return -1;
    8000531e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005320:	0a054763          	bltz	a0,800053ce <sys_pipe+0xd6>
  fd0 = -1;
    80005324:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005328:	fd043503          	ld	a0,-48(s0)
    8000532c:	ef2ff0ef          	jal	80004a1e <fdalloc>
    80005330:	fca42223          	sw	a0,-60(s0)
    80005334:	08054463          	bltz	a0,800053bc <sys_pipe+0xc4>
    80005338:	fc843503          	ld	a0,-56(s0)
    8000533c:	ee2ff0ef          	jal	80004a1e <fdalloc>
    80005340:	fca42023          	sw	a0,-64(s0)
    80005344:	06054263          	bltz	a0,800053a8 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005348:	4691                	li	a3,4
    8000534a:	fc440613          	addi	a2,s0,-60
    8000534e:	fd843583          	ld	a1,-40(s0)
    80005352:	68a8                	ld	a0,80(s1)
    80005354:	b00fc0ef          	jal	80001654 <copyout>
    80005358:	00054e63          	bltz	a0,80005374 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000535c:	4691                	li	a3,4
    8000535e:	fc040613          	addi	a2,s0,-64
    80005362:	fd843583          	ld	a1,-40(s0)
    80005366:	95b6                	add	a1,a1,a3
    80005368:	68a8                	ld	a0,80(s1)
    8000536a:	aeafc0ef          	jal	80001654 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000536e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005370:	04055f63          	bgez	a0,800053ce <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80005374:	fc442783          	lw	a5,-60(s0)
    80005378:	078e                	slli	a5,a5,0x3
    8000537a:	0d078793          	addi	a5,a5,208
    8000537e:	97a6                	add	a5,a5,s1
    80005380:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005384:	fc042783          	lw	a5,-64(s0)
    80005388:	078e                	slli	a5,a5,0x3
    8000538a:	0d078793          	addi	a5,a5,208
    8000538e:	97a6                	add	a5,a5,s1
    80005390:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005394:	fd043503          	ld	a0,-48(s0)
    80005398:	c8ffe0ef          	jal	80004026 <fileclose>
    fileclose(wf);
    8000539c:	fc843503          	ld	a0,-56(s0)
    800053a0:	c87fe0ef          	jal	80004026 <fileclose>
    return -1;
    800053a4:	57fd                	li	a5,-1
    800053a6:	a025                	j	800053ce <sys_pipe+0xd6>
    if(fd0 >= 0)
    800053a8:	fc442783          	lw	a5,-60(s0)
    800053ac:	0007c863          	bltz	a5,800053bc <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    800053b0:	078e                	slli	a5,a5,0x3
    800053b2:	0d078793          	addi	a5,a5,208
    800053b6:	97a6                	add	a5,a5,s1
    800053b8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800053bc:	fd043503          	ld	a0,-48(s0)
    800053c0:	c67fe0ef          	jal	80004026 <fileclose>
    fileclose(wf);
    800053c4:	fc843503          	ld	a0,-56(s0)
    800053c8:	c5ffe0ef          	jal	80004026 <fileclose>
    return -1;
    800053cc:	57fd                	li	a5,-1
}
    800053ce:	853e                	mv	a0,a5
    800053d0:	70e2                	ld	ra,56(sp)
    800053d2:	7442                	ld	s0,48(sp)
    800053d4:	74a2                	ld	s1,40(sp)
    800053d6:	6121                	addi	sp,sp,64
    800053d8:	8082                	ret
    800053da:	0000                	unimp
    800053dc:	0000                	unimp
	...

00000000800053e0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800053e0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800053e2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800053e4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800053e6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800053e8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800053ea:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800053ec:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800053ee:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800053f0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800053f2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800053f4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800053f6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800053f8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800053fa:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800053fc:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800053fe:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005400:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005402:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005404:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005406:	ab6fd0ef          	jal	800026bc <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000540a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000540c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000540e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005410:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005412:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005414:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005416:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005418:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000541a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000541c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000541e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005420:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005422:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005424:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005426:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005428:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000542a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000542c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000542e:	10200073          	sret
    80005432:	00000013          	nop
    80005436:	00000013          	nop
    8000543a:	00000013          	nop

000000008000543e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000543e:	1141                	addi	sp,sp,-16
    80005440:	e406                	sd	ra,8(sp)
    80005442:	e022                	sd	s0,0(sp)
    80005444:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005446:	0c000737          	lui	a4,0xc000
    8000544a:	4785                	li	a5,1
    8000544c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000544e:	c35c                	sw	a5,4(a4)
}
    80005450:	60a2                	ld	ra,8(sp)
    80005452:	6402                	ld	s0,0(sp)
    80005454:	0141                	addi	sp,sp,16
    80005456:	8082                	ret

0000000080005458 <plicinithart>:

void
plicinithart(void)
{
    80005458:	1141                	addi	sp,sp,-16
    8000545a:	e406                	sd	ra,8(sp)
    8000545c:	e022                	sd	s0,0(sp)
    8000545e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005460:	c9afc0ef          	jal	800018fa <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005464:	0085171b          	slliw	a4,a0,0x8
    80005468:	0c0027b7          	lui	a5,0xc002
    8000546c:	97ba                	add	a5,a5,a4
    8000546e:	40200713          	li	a4,1026
    80005472:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005476:	00d5151b          	slliw	a0,a0,0xd
    8000547a:	0c2017b7          	lui	a5,0xc201
    8000547e:	97aa                	add	a5,a5,a0
    80005480:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005484:	60a2                	ld	ra,8(sp)
    80005486:	6402                	ld	s0,0(sp)
    80005488:	0141                	addi	sp,sp,16
    8000548a:	8082                	ret

000000008000548c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000548c:	1141                	addi	sp,sp,-16
    8000548e:	e406                	sd	ra,8(sp)
    80005490:	e022                	sd	s0,0(sp)
    80005492:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005494:	c66fc0ef          	jal	800018fa <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005498:	00d5151b          	slliw	a0,a0,0xd
    8000549c:	0c2017b7          	lui	a5,0xc201
    800054a0:	97aa                	add	a5,a5,a0
  return irq;
}
    800054a2:	43c8                	lw	a0,4(a5)
    800054a4:	60a2                	ld	ra,8(sp)
    800054a6:	6402                	ld	s0,0(sp)
    800054a8:	0141                	addi	sp,sp,16
    800054aa:	8082                	ret

00000000800054ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054ac:	1101                	addi	sp,sp,-32
    800054ae:	ec06                	sd	ra,24(sp)
    800054b0:	e822                	sd	s0,16(sp)
    800054b2:	e426                	sd	s1,8(sp)
    800054b4:	1000                	addi	s0,sp,32
    800054b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054b8:	c42fc0ef          	jal	800018fa <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054bc:	00d5179b          	slliw	a5,a0,0xd
    800054c0:	0c201737          	lui	a4,0xc201
    800054c4:	97ba                	add	a5,a5,a4
    800054c6:	c3c4                	sw	s1,4(a5)
}
    800054c8:	60e2                	ld	ra,24(sp)
    800054ca:	6442                	ld	s0,16(sp)
    800054cc:	64a2                	ld	s1,8(sp)
    800054ce:	6105                	addi	sp,sp,32
    800054d0:	8082                	ret

00000000800054d2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054d2:	1141                	addi	sp,sp,-16
    800054d4:	e406                	sd	ra,8(sp)
    800054d6:	e022                	sd	s0,0(sp)
    800054d8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054da:	479d                	li	a5,7
    800054dc:	04a7ca63          	blt	a5,a0,80005530 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800054e0:	0001b797          	auipc	a5,0x1b
    800054e4:	54878793          	addi	a5,a5,1352 # 80020a28 <disk>
    800054e8:	97aa                	add	a5,a5,a0
    800054ea:	0187c783          	lbu	a5,24(a5)
    800054ee:	e7b9                	bnez	a5,8000553c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054f0:	00451693          	slli	a3,a0,0x4
    800054f4:	0001b797          	auipc	a5,0x1b
    800054f8:	53478793          	addi	a5,a5,1332 # 80020a28 <disk>
    800054fc:	6398                	ld	a4,0(a5)
    800054fe:	9736                	add	a4,a4,a3
    80005500:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005504:	6398                	ld	a4,0(a5)
    80005506:	9736                	add	a4,a4,a3
    80005508:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000550c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005510:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005514:	97aa                	add	a5,a5,a0
    80005516:	4705                	li	a4,1
    80005518:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000551c:	0001b517          	auipc	a0,0x1b
    80005520:	52450513          	addi	a0,a0,1316 # 80020a40 <disk+0x18>
    80005524:	a55fc0ef          	jal	80001f78 <wakeup>
}
    80005528:	60a2                	ld	ra,8(sp)
    8000552a:	6402                	ld	s0,0(sp)
    8000552c:	0141                	addi	sp,sp,16
    8000552e:	8082                	ret
    panic("free_desc 1");
    80005530:	00002517          	auipc	a0,0x2
    80005534:	0e050513          	addi	a0,a0,224 # 80007610 <etext+0x610>
    80005538:	aecfb0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    8000553c:	00002517          	auipc	a0,0x2
    80005540:	0e450513          	addi	a0,a0,228 # 80007620 <etext+0x620>
    80005544:	ae0fb0ef          	jal	80000824 <panic>

0000000080005548 <virtio_disk_init>:
{
    80005548:	1101                	addi	sp,sp,-32
    8000554a:	ec06                	sd	ra,24(sp)
    8000554c:	e822                	sd	s0,16(sp)
    8000554e:	e426                	sd	s1,8(sp)
    80005550:	e04a                	sd	s2,0(sp)
    80005552:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005554:	00002597          	auipc	a1,0x2
    80005558:	0dc58593          	addi	a1,a1,220 # 80007630 <etext+0x630>
    8000555c:	0001b517          	auipc	a0,0x1b
    80005560:	5f450513          	addi	a0,a0,1524 # 80020b50 <disk+0x128>
    80005564:	e3afb0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005568:	100017b7          	lui	a5,0x10001
    8000556c:	4398                	lw	a4,0(a5)
    8000556e:	2701                	sext.w	a4,a4
    80005570:	747277b7          	lui	a5,0x74727
    80005574:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005578:	14f71863          	bne	a4,a5,800056c8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	43dc                	lw	a5,4(a5)
    80005582:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005584:	4709                	li	a4,2
    80005586:	14e79163          	bne	a5,a4,800056c8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000558a:	100017b7          	lui	a5,0x10001
    8000558e:	479c                	lw	a5,8(a5)
    80005590:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005592:	12e79b63          	bne	a5,a4,800056c8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005596:	100017b7          	lui	a5,0x10001
    8000559a:	47d8                	lw	a4,12(a5)
    8000559c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000559e:	554d47b7          	lui	a5,0x554d4
    800055a2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055a6:	12f71163          	bne	a4,a5,800056c8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055aa:	100017b7          	lui	a5,0x10001
    800055ae:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b2:	4705                	li	a4,1
    800055b4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b6:	470d                	li	a4,3
    800055b8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055ba:	10001737          	lui	a4,0x10001
    800055be:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055c0:	c7ffe6b7          	lui	a3,0xc7ffe
    800055c4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fddbf7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055c8:	8f75                	and	a4,a4,a3
    800055ca:	100016b7          	lui	a3,0x10001
    800055ce:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055d0:	472d                	li	a4,11
    800055d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055d4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800055d8:	439c                	lw	a5,0(a5)
    800055da:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800055de:	8ba1                	andi	a5,a5,8
    800055e0:	0e078a63          	beqz	a5,800056d4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055e4:	100017b7          	lui	a5,0x10001
    800055e8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800055ec:	43fc                	lw	a5,68(a5)
    800055ee:	2781                	sext.w	a5,a5
    800055f0:	0e079863          	bnez	a5,800056e0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055f4:	100017b7          	lui	a5,0x10001
    800055f8:	5bdc                	lw	a5,52(a5)
    800055fa:	2781                	sext.w	a5,a5
  if(max == 0)
    800055fc:	0e078863          	beqz	a5,800056ec <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005600:	471d                	li	a4,7
    80005602:	0ef77b63          	bgeu	a4,a5,800056f8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005606:	d3efb0ef          	jal	80000b44 <kalloc>
    8000560a:	0001b497          	auipc	s1,0x1b
    8000560e:	41e48493          	addi	s1,s1,1054 # 80020a28 <disk>
    80005612:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005614:	d30fb0ef          	jal	80000b44 <kalloc>
    80005618:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000561a:	d2afb0ef          	jal	80000b44 <kalloc>
    8000561e:	87aa                	mv	a5,a0
    80005620:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005622:	6088                	ld	a0,0(s1)
    80005624:	0e050063          	beqz	a0,80005704 <virtio_disk_init+0x1bc>
    80005628:	0001b717          	auipc	a4,0x1b
    8000562c:	40873703          	ld	a4,1032(a4) # 80020a30 <disk+0x8>
    80005630:	cb71                	beqz	a4,80005704 <virtio_disk_init+0x1bc>
    80005632:	cbe9                	beqz	a5,80005704 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005634:	6605                	lui	a2,0x1
    80005636:	4581                	li	a1,0
    80005638:	ec0fb0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000563c:	0001b497          	auipc	s1,0x1b
    80005640:	3ec48493          	addi	s1,s1,1004 # 80020a28 <disk>
    80005644:	6605                	lui	a2,0x1
    80005646:	4581                	li	a1,0
    80005648:	6488                	ld	a0,8(s1)
    8000564a:	eaefb0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    8000564e:	6605                	lui	a2,0x1
    80005650:	4581                	li	a1,0
    80005652:	6888                	ld	a0,16(s1)
    80005654:	ea4fb0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005658:	100017b7          	lui	a5,0x10001
    8000565c:	4721                	li	a4,8
    8000565e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005660:	4098                	lw	a4,0(s1)
    80005662:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005666:	40d8                	lw	a4,4(s1)
    80005668:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000566c:	649c                	ld	a5,8(s1)
    8000566e:	0007869b          	sext.w	a3,a5
    80005672:	10001737          	lui	a4,0x10001
    80005676:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000567a:	9781                	srai	a5,a5,0x20
    8000567c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005680:	689c                	ld	a5,16(s1)
    80005682:	0007869b          	sext.w	a3,a5
    80005686:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000568a:	9781                	srai	a5,a5,0x20
    8000568c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005690:	4785                	li	a5,1
    80005692:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005694:	00f48c23          	sb	a5,24(s1)
    80005698:	00f48ca3          	sb	a5,25(s1)
    8000569c:	00f48d23          	sb	a5,26(s1)
    800056a0:	00f48da3          	sb	a5,27(s1)
    800056a4:	00f48e23          	sb	a5,28(s1)
    800056a8:	00f48ea3          	sb	a5,29(s1)
    800056ac:	00f48f23          	sb	a5,30(s1)
    800056b0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056b4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056b8:	07272823          	sw	s2,112(a4)
}
    800056bc:	60e2                	ld	ra,24(sp)
    800056be:	6442                	ld	s0,16(sp)
    800056c0:	64a2                	ld	s1,8(sp)
    800056c2:	6902                	ld	s2,0(sp)
    800056c4:	6105                	addi	sp,sp,32
    800056c6:	8082                	ret
    panic("could not find virtio disk");
    800056c8:	00002517          	auipc	a0,0x2
    800056cc:	f7850513          	addi	a0,a0,-136 # 80007640 <etext+0x640>
    800056d0:	954fb0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    800056d4:	00002517          	auipc	a0,0x2
    800056d8:	f8c50513          	addi	a0,a0,-116 # 80007660 <etext+0x660>
    800056dc:	948fb0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    800056e0:	00002517          	auipc	a0,0x2
    800056e4:	fa050513          	addi	a0,a0,-96 # 80007680 <etext+0x680>
    800056e8:	93cfb0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    800056ec:	00002517          	auipc	a0,0x2
    800056f0:	fb450513          	addi	a0,a0,-76 # 800076a0 <etext+0x6a0>
    800056f4:	930fb0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    800056f8:	00002517          	auipc	a0,0x2
    800056fc:	fc850513          	addi	a0,a0,-56 # 800076c0 <etext+0x6c0>
    80005700:	924fb0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005704:	00002517          	auipc	a0,0x2
    80005708:	fdc50513          	addi	a0,a0,-36 # 800076e0 <etext+0x6e0>
    8000570c:	918fb0ef          	jal	80000824 <panic>

0000000080005710 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005710:	711d                	addi	sp,sp,-96
    80005712:	ec86                	sd	ra,88(sp)
    80005714:	e8a2                	sd	s0,80(sp)
    80005716:	e4a6                	sd	s1,72(sp)
    80005718:	e0ca                	sd	s2,64(sp)
    8000571a:	fc4e                	sd	s3,56(sp)
    8000571c:	f852                	sd	s4,48(sp)
    8000571e:	f456                	sd	s5,40(sp)
    80005720:	f05a                	sd	s6,32(sp)
    80005722:	ec5e                	sd	s7,24(sp)
    80005724:	e862                	sd	s8,16(sp)
    80005726:	1080                	addi	s0,sp,96
    80005728:	89aa                	mv	s3,a0
    8000572a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000572c:	00c52b83          	lw	s7,12(a0)
    80005730:	001b9b9b          	slliw	s7,s7,0x1
    80005734:	1b82                	slli	s7,s7,0x20
    80005736:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000573a:	0001b517          	auipc	a0,0x1b
    8000573e:	41650513          	addi	a0,a0,1046 # 80020b50 <disk+0x128>
    80005742:	ce6fb0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005746:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005748:	0001ba97          	auipc	s5,0x1b
    8000574c:	2e0a8a93          	addi	s5,s5,736 # 80020a28 <disk>
  for(int i = 0; i < 3; i++){
    80005750:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005752:	5c7d                	li	s8,-1
    80005754:	a095                	j	800057b8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005756:	00fa8733          	add	a4,s5,a5
    8000575a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000575e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005760:	0207c563          	bltz	a5,8000578a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005764:	2905                	addiw	s2,s2,1
    80005766:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005768:	05490c63          	beq	s2,s4,800057c0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000576c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000576e:	0001b717          	auipc	a4,0x1b
    80005772:	2ba70713          	addi	a4,a4,698 # 80020a28 <disk>
    80005776:	4781                	li	a5,0
    if(disk.free[i]){
    80005778:	01874683          	lbu	a3,24(a4)
    8000577c:	fee9                	bnez	a3,80005756 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000577e:	2785                	addiw	a5,a5,1
    80005780:	0705                	addi	a4,a4,1
    80005782:	fe979be3          	bne	a5,s1,80005778 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005786:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000578a:	01205d63          	blez	s2,800057a4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000578e:	fa042503          	lw	a0,-96(s0)
    80005792:	d41ff0ef          	jal	800054d2 <free_desc>
      for(int j = 0; j < i; j++)
    80005796:	4785                	li	a5,1
    80005798:	0127d663          	bge	a5,s2,800057a4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000579c:	fa442503          	lw	a0,-92(s0)
    800057a0:	d33ff0ef          	jal	800054d2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057a4:	0001b597          	auipc	a1,0x1b
    800057a8:	3ac58593          	addi	a1,a1,940 # 80020b50 <disk+0x128>
    800057ac:	0001b517          	auipc	a0,0x1b
    800057b0:	29450513          	addi	a0,a0,660 # 80020a40 <disk+0x18>
    800057b4:	f78fc0ef          	jal	80001f2c <sleep>
  for(int i = 0; i < 3; i++){
    800057b8:	fa040613          	addi	a2,s0,-96
    800057bc:	4901                	li	s2,0
    800057be:	b77d                	j	8000576c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057c0:	fa042503          	lw	a0,-96(s0)
    800057c4:	00451693          	slli	a3,a0,0x4

  if(write)
    800057c8:	0001b797          	auipc	a5,0x1b
    800057cc:	26078793          	addi	a5,a5,608 # 80020a28 <disk>
    800057d0:	00451713          	slli	a4,a0,0x4
    800057d4:	0a070713          	addi	a4,a4,160
    800057d8:	973e                	add	a4,a4,a5
    800057da:	01603633          	snez	a2,s6
    800057de:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057e0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800057e4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800057e8:	6398                	ld	a4,0(a5)
    800057ea:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ec:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800057f0:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057f2:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057f4:	6390                	ld	a2,0(a5)
    800057f6:	00d60833          	add	a6,a2,a3
    800057fa:	4741                	li	a4,16
    800057fc:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005800:	4585                	li	a1,1
    80005802:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005806:	fa442703          	lw	a4,-92(s0)
    8000580a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000580e:	0712                	slli	a4,a4,0x4
    80005810:	963a                	add	a2,a2,a4
    80005812:	05898813          	addi	a6,s3,88
    80005816:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000581a:	0007b883          	ld	a7,0(a5)
    8000581e:	9746                	add	a4,a4,a7
    80005820:	40000613          	li	a2,1024
    80005824:	c710                	sw	a2,8(a4)
  if(write)
    80005826:	001b3613          	seqz	a2,s6
    8000582a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000582e:	8e4d                	or	a2,a2,a1
    80005830:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005834:	fa842603          	lw	a2,-88(s0)
    80005838:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000583c:	00451813          	slli	a6,a0,0x4
    80005840:	02080813          	addi	a6,a6,32
    80005844:	983e                	add	a6,a6,a5
    80005846:	577d                	li	a4,-1
    80005848:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000584c:	0612                	slli	a2,a2,0x4
    8000584e:	98b2                	add	a7,a7,a2
    80005850:	03068713          	addi	a4,a3,48
    80005854:	973e                	add	a4,a4,a5
    80005856:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000585a:	6398                	ld	a4,0(a5)
    8000585c:	9732                	add	a4,a4,a2
    8000585e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005860:	4689                	li	a3,2
    80005862:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005866:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000586a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    8000586e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005872:	6794                	ld	a3,8(a5)
    80005874:	0026d703          	lhu	a4,2(a3)
    80005878:	8b1d                	andi	a4,a4,7
    8000587a:	0706                	slli	a4,a4,0x1
    8000587c:	96ba                	add	a3,a3,a4
    8000587e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005882:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005886:	6798                	ld	a4,8(a5)
    80005888:	00275783          	lhu	a5,2(a4)
    8000588c:	2785                	addiw	a5,a5,1
    8000588e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005892:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005896:	100017b7          	lui	a5,0x10001
    8000589a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000589e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800058a2:	0001b917          	auipc	s2,0x1b
    800058a6:	2ae90913          	addi	s2,s2,686 # 80020b50 <disk+0x128>
  while(b->disk == 1) {
    800058aa:	84ae                	mv	s1,a1
    800058ac:	00b79a63          	bne	a5,a1,800058c0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800058b0:	85ca                	mv	a1,s2
    800058b2:	854e                	mv	a0,s3
    800058b4:	e78fc0ef          	jal	80001f2c <sleep>
  while(b->disk == 1) {
    800058b8:	0049a783          	lw	a5,4(s3)
    800058bc:	fe978ae3          	beq	a5,s1,800058b0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800058c0:	fa042903          	lw	s2,-96(s0)
    800058c4:	00491713          	slli	a4,s2,0x4
    800058c8:	02070713          	addi	a4,a4,32
    800058cc:	0001b797          	auipc	a5,0x1b
    800058d0:	15c78793          	addi	a5,a5,348 # 80020a28 <disk>
    800058d4:	97ba                	add	a5,a5,a4
    800058d6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058da:	0001b997          	auipc	s3,0x1b
    800058de:	14e98993          	addi	s3,s3,334 # 80020a28 <disk>
    800058e2:	00491713          	slli	a4,s2,0x4
    800058e6:	0009b783          	ld	a5,0(s3)
    800058ea:	97ba                	add	a5,a5,a4
    800058ec:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058f0:	854a                	mv	a0,s2
    800058f2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058f6:	bddff0ef          	jal	800054d2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058fa:	8885                	andi	s1,s1,1
    800058fc:	f0fd                	bnez	s1,800058e2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058fe:	0001b517          	auipc	a0,0x1b
    80005902:	25250513          	addi	a0,a0,594 # 80020b50 <disk+0x128>
    80005906:	bb6fb0ef          	jal	80000cbc <release>
}
    8000590a:	60e6                	ld	ra,88(sp)
    8000590c:	6446                	ld	s0,80(sp)
    8000590e:	64a6                	ld	s1,72(sp)
    80005910:	6906                	ld	s2,64(sp)
    80005912:	79e2                	ld	s3,56(sp)
    80005914:	7a42                	ld	s4,48(sp)
    80005916:	7aa2                	ld	s5,40(sp)
    80005918:	7b02                	ld	s6,32(sp)
    8000591a:	6be2                	ld	s7,24(sp)
    8000591c:	6c42                	ld	s8,16(sp)
    8000591e:	6125                	addi	sp,sp,96
    80005920:	8082                	ret

0000000080005922 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005922:	1101                	addi	sp,sp,-32
    80005924:	ec06                	sd	ra,24(sp)
    80005926:	e822                	sd	s0,16(sp)
    80005928:	e426                	sd	s1,8(sp)
    8000592a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000592c:	0001b497          	auipc	s1,0x1b
    80005930:	0fc48493          	addi	s1,s1,252 # 80020a28 <disk>
    80005934:	0001b517          	auipc	a0,0x1b
    80005938:	21c50513          	addi	a0,a0,540 # 80020b50 <disk+0x128>
    8000593c:	aecfb0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005940:	100017b7          	lui	a5,0x10001
    80005944:	53bc                	lw	a5,96(a5)
    80005946:	8b8d                	andi	a5,a5,3
    80005948:	10001737          	lui	a4,0x10001
    8000594c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000594e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005952:	689c                	ld	a5,16(s1)
    80005954:	0204d703          	lhu	a4,32(s1)
    80005958:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000595c:	04f70863          	beq	a4,a5,800059ac <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005960:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005964:	6898                	ld	a4,16(s1)
    80005966:	0204d783          	lhu	a5,32(s1)
    8000596a:	8b9d                	andi	a5,a5,7
    8000596c:	078e                	slli	a5,a5,0x3
    8000596e:	97ba                	add	a5,a5,a4
    80005970:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005972:	00479713          	slli	a4,a5,0x4
    80005976:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000597a:	9726                	add	a4,a4,s1
    8000597c:	01074703          	lbu	a4,16(a4)
    80005980:	e329                	bnez	a4,800059c2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005982:	0792                	slli	a5,a5,0x4
    80005984:	02078793          	addi	a5,a5,32
    80005988:	97a6                	add	a5,a5,s1
    8000598a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000598c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005990:	de8fc0ef          	jal	80001f78 <wakeup>

    disk.used_idx += 1;
    80005994:	0204d783          	lhu	a5,32(s1)
    80005998:	2785                	addiw	a5,a5,1
    8000599a:	17c2                	slli	a5,a5,0x30
    8000599c:	93c1                	srli	a5,a5,0x30
    8000599e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059a2:	6898                	ld	a4,16(s1)
    800059a4:	00275703          	lhu	a4,2(a4)
    800059a8:	faf71ce3          	bne	a4,a5,80005960 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800059ac:	0001b517          	auipc	a0,0x1b
    800059b0:	1a450513          	addi	a0,a0,420 # 80020b50 <disk+0x128>
    800059b4:	b08fb0ef          	jal	80000cbc <release>
}
    800059b8:	60e2                	ld	ra,24(sp)
    800059ba:	6442                	ld	s0,16(sp)
    800059bc:	64a2                	ld	s1,8(sp)
    800059be:	6105                	addi	sp,sp,32
    800059c0:	8082                	ret
      panic("virtio_disk_intr status");
    800059c2:	00002517          	auipc	a0,0x2
    800059c6:	d3650513          	addi	a0,a0,-714 # 800076f8 <etext+0x6f8>
    800059ca:	e5bfa0ef          	jal	80000824 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
