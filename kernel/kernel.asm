
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00009117          	auipc	sp,0x9
    80000004:	ba010113          	addi	sp,sp,-1120 # 80008ba0 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc907>
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
    8000011a:	1ba020ef          	jal	800022d4 <either_copyin>
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
    80000192:	00011517          	auipc	a0,0x11
    80000196:	a0e50513          	addi	a0,a0,-1522 # 80010ba0 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00011497          	auipc	s1,0x11
    800001a2:	a0248493          	addi	s1,s1,-1534 # 80010ba0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00011917          	auipc	s2,0x11
    800001aa:	a9290913          	addi	s2,s2,-1390 # 80010c38 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	774010ef          	jal	80001932 <myproc>
    800001c2:	7ab010ef          	jal	8000216c <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	565010ef          	jal	80001f30 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00011717          	auipc	a4,0x11
    800001e2:	9c270713          	addi	a4,a4,-1598 # 80010ba0 <cons>
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
    80000210:	07a020ef          	jal	8000228a <either_copyout>
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
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	97850513          	addi	a0,a0,-1672 # 80010ba0 <cons>
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
    8000024e:	00011717          	auipc	a4,0x11
    80000252:	9ef72523          	sw	a5,-1558(a4) # 80010c38 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00011517          	auipc	a0,0x11
    80000268:	93c50513          	addi	a0,a0,-1732 # 80010ba0 <cons>
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
    800002b8:	00011517          	auipc	a0,0x11
    800002bc:	8e850513          	addi	a0,a0,-1816 # 80010ba0 <cons>
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
    800002da:	044020ef          	jal	8000231e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00011517          	auipc	a0,0x11
    800002e2:	8c250513          	addi	a0,a0,-1854 # 80010ba0 <cons>
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
    800002fc:	00011717          	auipc	a4,0x11
    80000300:	8a470713          	addi	a4,a4,-1884 # 80010ba0 <cons>
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
    80000322:	00011717          	auipc	a4,0x11
    80000326:	87e70713          	addi	a4,a4,-1922 # 80010ba0 <cons>
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
    8000034c:	00011717          	auipc	a4,0x11
    80000350:	8ec72703          	lw	a4,-1812(a4) # 80010c38 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00011717          	auipc	a4,0x11
    80000366:	83e70713          	addi	a4,a4,-1986 # 80010ba0 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00011497          	auipc	s1,0x11
    80000376:	82e48493          	addi	s1,s1,-2002 # 80010ba0 <cons>
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
    800003b4:	00010717          	auipc	a4,0x10
    800003b8:	7ec70713          	addi	a4,a4,2028 # 80010ba0 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00011717          	auipc	a4,0x11
    800003ce:	86f72b23          	sw	a5,-1930(a4) # 80010c40 <cons+0xa0>
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
    800003e8:	00010797          	auipc	a5,0x10
    800003ec:	7b878793          	addi	a5,a5,1976 # 80010ba0 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	00011797          	auipc	a5,0x11
    8000040e:	82c7a923          	sw	a2,-1998(a5) # 80010c3c <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00011517          	auipc	a0,0x11
    80000416:	82650513          	addi	a0,a0,-2010 # 80010c38 <cons+0x98>
    8000041a:	363010ef          	jal	80001f7c <wakeup>
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
    80000428:	00008597          	auipc	a1,0x8
    8000042c:	be858593          	addi	a1,a1,-1048 # 80008010 <etext+0x10>
    80000430:	00010517          	auipc	a0,0x10
    80000434:	77050513          	addi	a0,a0,1904 # 80010ba0 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	00021797          	auipc	a5,0x21
    80000444:	92078793          	addi	a5,a5,-1760 # 80020d60 <devsw>
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
    8000047e:	00008817          	auipc	a6,0x8
    80000482:	5ca80813          	addi	a6,a6,1482 # 80008a48 <digits>
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
    80000518:	00008797          	auipc	a5,0x8
    8000051c:	65c7a783          	lw	a5,1628(a5) # 80008b74 <panicking>
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
    8000055e:	00010517          	auipc	a0,0x10
    80000562:	6ea50513          	addi	a0,a0,1770 # 80010c48 <pr>
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
    800006d2:	00008c97          	auipc	s9,0x8
    800006d6:	376c8c93          	addi	s9,s9,886 # 80008a48 <digits>
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
    80000732:	00008a17          	auipc	s4,0x8
    80000736:	8e6a0a13          	addi	s4,s4,-1818 # 80008018 <etext+0x18>
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
    8000075a:	00008797          	auipc	a5,0x8
    8000075e:	41a7a783          	lw	a5,1050(a5) # 80008b74 <panicking>
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
    80000784:	00010517          	auipc	a0,0x10
    80000788:	4c450513          	addi	a0,a0,1220 # 80010c48 <pr>
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
    80000834:	00008797          	auipc	a5,0x8
    80000838:	3497a023          	sw	s1,832(a5) # 80008b74 <panicking>
  printf("panic: ");
    8000083c:	00007517          	auipc	a0,0x7
    80000840:	7ec50513          	addi	a0,a0,2028 # 80008028 <etext+0x28>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00007517          	auipc	a0,0x7
    8000084e:	7e650513          	addi	a0,a0,2022 # 80008030 <etext+0x30>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	00008797          	auipc	a5,0x8
    8000085a:	3097ad23          	sw	s1,794(a5) # 80008b70 <panicked>
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
    80000868:	00007597          	auipc	a1,0x7
    8000086c:	7d058593          	addi	a1,a1,2000 # 80008038 <etext+0x38>
    80000870:	00010517          	auipc	a0,0x10
    80000874:	3d850513          	addi	a0,a0,984 # 80010c48 <pr>
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
    800008be:	00007597          	auipc	a1,0x7
    800008c2:	78258593          	addi	a1,a1,1922 # 80008040 <etext+0x40>
    800008c6:	00010517          	auipc	a0,0x10
    800008ca:	39a50513          	addi	a0,a0,922 # 80010c60 <tx_lock>
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
    800008ea:	00010517          	auipc	a0,0x10
    800008ee:	37650513          	addi	a0,a0,886 # 80010c60 <tx_lock>
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
    80000908:	00008497          	auipc	s1,0x8
    8000090c:	27448493          	addi	s1,s1,628 # 80008b7c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00010997          	auipc	s3,0x10
    80000914:	35098993          	addi	s3,s3,848 # 80010c60 <tx_lock>
    80000918:	00008917          	auipc	s2,0x8
    8000091c:	26090913          	addi	s2,s2,608 # 80008b78 <tx_chan>
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
    8000092c:	604010ef          	jal	80001f30 <sleep>
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
    80000956:	00010517          	auipc	a0,0x10
    8000095a:	30a50513          	addi	a0,a0,778 # 80010c60 <tx_lock>
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
    8000097a:	00008797          	auipc	a5,0x8
    8000097e:	1fa7a783          	lw	a5,506(a5) # 80008b74 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00008797          	auipc	a5,0x8
    80000988:	1ec7a783          	lw	a5,492(a5) # 80008b70 <panicked>
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
    800009aa:	00008797          	auipc	a5,0x8
    800009ae:	1ca7a783          	lw	a5,458(a5) # 80008b74 <panicking>
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
    80000a06:	00010517          	auipc	a0,0x10
    80000a0a:	25a50513          	addi	a0,a0,602 # 80010c60 <tx_lock>
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
    80000a20:	00010517          	auipc	a0,0x10
    80000a24:	24050513          	addi	a0,a0,576 # 80010c60 <tx_lock>
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
    80000a3c:	00008797          	auipc	a5,0x8
    80000a40:	1407a023          	sw	zero,320(a5) # 80008b7c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00008517          	auipc	a0,0x8
    80000a48:	13450513          	addi	a0,a0,308 # 80008b78 <tx_chan>
    80000a4c:	530010ef          	jal	80001f7c <wakeup>
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
    80000a68:	00021797          	auipc	a5,0x21
    80000a6c:	49078793          	addi	a5,a5,1168 # 80021ef8 <end>
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
    80000a92:	00010917          	auipc	s2,0x10
    80000a96:	1e690913          	addi	s2,s2,486 # 80010c78 <kmem>
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
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	58c50513          	addi	a0,a0,1420 # 80008048 <etext+0x48>
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
    80000b18:	00007597          	auipc	a1,0x7
    80000b1c:	53858593          	addi	a1,a1,1336 # 80008050 <etext+0x50>
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	15850513          	addi	a0,a0,344 # 80010c78 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00021517          	auipc	a0,0x21
    80000b34:	3c850513          	addi	a0,a0,968 # 80021ef8 <end>
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
    80000b4e:	00010517          	auipc	a0,0x10
    80000b52:	12a50513          	addi	a0,a0,298 # 80010c78 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00010497          	auipc	s1,0x10
    80000b5e:	1364b483          	ld	s1,310(s1) # 80010c90 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00010717          	auipc	a4,0x10
    80000b6a:	12f73523          	sd	a5,298(a4) # 80010c90 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00010517          	auipc	a0,0x10
    80000b72:	10a50513          	addi	a0,a0,266 # 80010c78 <kmem>
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
    80000b90:	00010517          	auipc	a0,0x10
    80000b94:	0e850513          	addi	a0,a0,232 # 80010c78 <kmem>
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
    80000bce:	545000ef          	jal	80001912 <mycpu>
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
    80000bfe:	515000ef          	jal	80001912 <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	50d000ef          	jal	80001912 <mycpu>
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
    80000c1a:	4f9000ef          	jal	80001912 <mycpu>
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
    80000c50:	4c3000ef          	jal	80001912 <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	3f850513          	addi	a0,a0,1016 # 80008058 <etext+0x58>
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
    80000c74:	49f000ef          	jal	80001912 <mycpu>
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
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3bc50513          	addi	a0,a0,956 # 80008060 <etext+0x60>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	3c850513          	addi	a0,a0,968 # 80008078 <etext+0x78>
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
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	39450513          	addi	a0,a0,916 # 80008080 <etext+0x80>
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
    80000eb6:	249000ef          	jal	800018fe <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00008717          	auipc	a4,0x8
    80000ebe:	cc670713          	addi	a4,a4,-826 # 80008b80 <started>
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
    80000ece:	231000ef          	jal	800018fe <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1d450513          	addi	a0,a0,468 # 800080a8 <etext+0xa8>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	084000ef          	jal	80000f64 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	56c010ef          	jal	80002450 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	4d1040ef          	jal	80005bb8 <plicinithart>
  }

  scheduler();        
    80000eec:	6ab000ef          	jal	80001d96 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	19050513          	addi	a0,a0,400 # 80008088 <etext+0x88>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	18c50513          	addi	a0,a0,396 # 80008090 <etext+0x90>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	17850513          	addi	a0,a0,376 # 80008088 <etext+0x88>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2d0000ef          	jal	800011f0 <kvminit>
    kvminithart();   // turn on paging
    80000f24:	040000ef          	jal	80000f64 <kvminithart>
    procinit();      // process table
    80000f28:	121000ef          	jal	80001848 <procinit>
    trapinit();      // trap vectors
    80000f2c:	500010ef          	jal	8000242c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	520010ef          	jal	80002450 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	46b040ef          	jal	80005b9e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	481040ef          	jal	80005bb8 <plicinithart>
    binit();         // buffer cache
    80000f3c:	3b7010ef          	jal	80002af2 <binit>
    buddyinit();     // buddy system allocator
    80000f40:	196030ef          	jal	800040d6 <buddyinit>
    iinit();         // inode table
    80000f44:	104020ef          	jal	80003048 <iinit>
    fileinit();      // file table
    80000f48:	774030ef          	jal	800046bc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f4c:	55d040ef          	jal	80005ca8 <virtio_disk_init>
    userinit();      // first user process
    80000f50:	4ad000ef          	jal	80001bfc <userinit>
    __sync_synchronize();
    80000f54:	0330000f          	fence	rw,rw
    started = 1;
    80000f58:	4785                	li	a5,1
    80000f5a:	00008717          	auipc	a4,0x8
    80000f5e:	c2f72323          	sw	a5,-986(a4) # 80008b80 <started>
    80000f62:	b769                	j	80000eec <main+0x3e>

0000000080000f64 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f64:	1141                	addi	sp,sp,-16
    80000f66:	e406                	sd	ra,8(sp)
    80000f68:	e022                	sd	s0,0(sp)
    80000f6a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f6c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f70:	00008797          	auipc	a5,0x8
    80000f74:	c187b783          	ld	a5,-1000(a5) # 80008b88 <kernel_pagetable>
    80000f78:	83b1                	srli	a5,a5,0xc
    80000f7a:	577d                	li	a4,-1
    80000f7c:	177e                	slli	a4,a4,0x3f
    80000f7e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f80:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f84:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f88:	60a2                	ld	ra,8(sp)
    80000f8a:	6402                	ld	s0,0(sp)
    80000f8c:	0141                	addi	sp,sp,16
    80000f8e:	8082                	ret

0000000080000f90 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f90:	7139                	addi	sp,sp,-64
    80000f92:	fc06                	sd	ra,56(sp)
    80000f94:	f822                	sd	s0,48(sp)
    80000f96:	f426                	sd	s1,40(sp)
    80000f98:	f04a                	sd	s2,32(sp)
    80000f9a:	ec4e                	sd	s3,24(sp)
    80000f9c:	e852                	sd	s4,16(sp)
    80000f9e:	e456                	sd	s5,8(sp)
    80000fa0:	e05a                	sd	s6,0(sp)
    80000fa2:	0080                	addi	s0,sp,64
    80000fa4:	84aa                	mv	s1,a0
    80000fa6:	89ae                	mv	s3,a1
    80000fa8:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80000faa:	57fd                	li	a5,-1
    80000fac:	83e9                	srli	a5,a5,0x1a
    80000fae:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fb0:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000fb2:	04b7e263          	bltu	a5,a1,80000ff6 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fb6:	0149d933          	srl	s2,s3,s4
    80000fba:	1ff97913          	andi	s2,s2,511
    80000fbe:	090e                	slli	s2,s2,0x3
    80000fc0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fc2:	00093483          	ld	s1,0(s2)
    80000fc6:	0014f793          	andi	a5,s1,1
    80000fca:	cf85                	beqz	a5,80001002 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fcc:	80a9                	srli	s1,s1,0xa
    80000fce:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000fd0:	3a5d                	addiw	s4,s4,-9
    80000fd2:	ff5a12e3          	bne	s4,s5,80000fb6 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fd6:	00c9d513          	srli	a0,s3,0xc
    80000fda:	1ff57513          	andi	a0,a0,511
    80000fde:	050e                	slli	a0,a0,0x3
    80000fe0:	9526                	add	a0,a0,s1
}
    80000fe2:	70e2                	ld	ra,56(sp)
    80000fe4:	7442                	ld	s0,48(sp)
    80000fe6:	74a2                	ld	s1,40(sp)
    80000fe8:	7902                	ld	s2,32(sp)
    80000fea:	69e2                	ld	s3,24(sp)
    80000fec:	6a42                	ld	s4,16(sp)
    80000fee:	6aa2                	ld	s5,8(sp)
    80000ff0:	6b02                	ld	s6,0(sp)
    80000ff2:	6121                	addi	sp,sp,64
    80000ff4:	8082                	ret
    panic("walk");
    80000ff6:	00007517          	auipc	a0,0x7
    80000ffa:	0ca50513          	addi	a0,a0,202 # 800080c0 <etext+0xc0>
    80000ffe:	827ff0ef          	jal	80000824 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001002:	020b0263          	beqz	s6,80001026 <walk+0x96>
    80001006:	b3fff0ef          	jal	80000b44 <kalloc>
    8000100a:	84aa                	mv	s1,a0
    8000100c:	d979                	beqz	a0,80000fe2 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000100e:	6605                	lui	a2,0x1
    80001010:	4581                	li	a1,0
    80001012:	ce7ff0ef          	jal	80000cf8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001016:	00c4d793          	srli	a5,s1,0xc
    8000101a:	07aa                	slli	a5,a5,0xa
    8000101c:	0017e793          	ori	a5,a5,1
    80001020:	00f93023          	sd	a5,0(s2)
    80001024:	b775                	j	80000fd0 <walk+0x40>
        return 0;
    80001026:	4501                	li	a0,0
    80001028:	bf6d                	j	80000fe2 <walk+0x52>

000000008000102a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000102a:	57fd                	li	a5,-1
    8000102c:	83e9                	srli	a5,a5,0x1a
    8000102e:	00b7f463          	bgeu	a5,a1,80001036 <walkaddr+0xc>
    return 0;
    80001032:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001034:	8082                	ret
{
    80001036:	1141                	addi	sp,sp,-16
    80001038:	e406                	sd	ra,8(sp)
    8000103a:	e022                	sd	s0,0(sp)
    8000103c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000103e:	4601                	li	a2,0
    80001040:	f51ff0ef          	jal	80000f90 <walk>
  if(pte == 0)
    80001044:	c901                	beqz	a0,80001054 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    80001046:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001048:	0117f693          	andi	a3,a5,17
    8000104c:	4745                	li	a4,17
    return 0;
    8000104e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001050:	00e68663          	beq	a3,a4,8000105c <walkaddr+0x32>
}
    80001054:	60a2                	ld	ra,8(sp)
    80001056:	6402                	ld	s0,0(sp)
    80001058:	0141                	addi	sp,sp,16
    8000105a:	8082                	ret
  pa = PTE2PA(*pte);
    8000105c:	83a9                	srli	a5,a5,0xa
    8000105e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001062:	bfcd                	j	80001054 <walkaddr+0x2a>

0000000080001064 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001064:	715d                	addi	sp,sp,-80
    80001066:	e486                	sd	ra,72(sp)
    80001068:	e0a2                	sd	s0,64(sp)
    8000106a:	fc26                	sd	s1,56(sp)
    8000106c:	f84a                	sd	s2,48(sp)
    8000106e:	f44e                	sd	s3,40(sp)
    80001070:	f052                	sd	s4,32(sp)
    80001072:	ec56                	sd	s5,24(sp)
    80001074:	e85a                	sd	s6,16(sp)
    80001076:	e45e                	sd	s7,8(sp)
    80001078:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000107a:	03459793          	slli	a5,a1,0x34
    8000107e:	eba1                	bnez	a5,800010ce <mappages+0x6a>
    80001080:	8a2a                	mv	s4,a0
    80001082:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001084:	03461793          	slli	a5,a2,0x34
    80001088:	eba9                	bnez	a5,800010da <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    8000108a:	ce31                	beqz	a2,800010e6 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000108c:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80001090:	80060613          	addi	a2,a2,-2048
    80001094:	00b60933          	add	s2,a2,a1
  a = va;
    80001098:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000109a:	4b05                	li	s6,1
    8000109c:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010a0:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a2:	865a                	mv	a2,s6
    800010a4:	85a6                	mv	a1,s1
    800010a6:	8552                	mv	a0,s4
    800010a8:	ee9ff0ef          	jal	80000f90 <walk>
    800010ac:	c929                	beqz	a0,800010fe <mappages+0x9a>
    if(*pte & PTE_V)
    800010ae:	611c                	ld	a5,0(a0)
    800010b0:	8b85                	andi	a5,a5,1
    800010b2:	e3a1                	bnez	a5,800010f2 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010b4:	013487b3          	add	a5,s1,s3
    800010b8:	83b1                	srli	a5,a5,0xc
    800010ba:	07aa                	slli	a5,a5,0xa
    800010bc:	0157e7b3          	or	a5,a5,s5
    800010c0:	0017e793          	ori	a5,a5,1
    800010c4:	e11c                	sd	a5,0(a0)
    if(a == last)
    800010c6:	05248863          	beq	s1,s2,80001116 <mappages+0xb2>
    a += PGSIZE;
    800010ca:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010cc:	bfd9                	j	800010a2 <mappages+0x3e>
    panic("mappages: va not aligned");
    800010ce:	00007517          	auipc	a0,0x7
    800010d2:	ffa50513          	addi	a0,a0,-6 # 800080c8 <etext+0xc8>
    800010d6:	f4eff0ef          	jal	80000824 <panic>
    panic("mappages: size not aligned");
    800010da:	00007517          	auipc	a0,0x7
    800010de:	00e50513          	addi	a0,a0,14 # 800080e8 <etext+0xe8>
    800010e2:	f42ff0ef          	jal	80000824 <panic>
    panic("mappages: size");
    800010e6:	00007517          	auipc	a0,0x7
    800010ea:	02250513          	addi	a0,a0,34 # 80008108 <etext+0x108>
    800010ee:	f36ff0ef          	jal	80000824 <panic>
      panic("mappages: remap");
    800010f2:	00007517          	auipc	a0,0x7
    800010f6:	02650513          	addi	a0,a0,38 # 80008118 <etext+0x118>
    800010fa:	f2aff0ef          	jal	80000824 <panic>
      return -1;
    800010fe:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001100:	60a6                	ld	ra,72(sp)
    80001102:	6406                	ld	s0,64(sp)
    80001104:	74e2                	ld	s1,56(sp)
    80001106:	7942                	ld	s2,48(sp)
    80001108:	79a2                	ld	s3,40(sp)
    8000110a:	7a02                	ld	s4,32(sp)
    8000110c:	6ae2                	ld	s5,24(sp)
    8000110e:	6b42                	ld	s6,16(sp)
    80001110:	6ba2                	ld	s7,8(sp)
    80001112:	6161                	addi	sp,sp,80
    80001114:	8082                	ret
  return 0;
    80001116:	4501                	li	a0,0
    80001118:	b7e5                	j	80001100 <mappages+0x9c>

000000008000111a <kvmmap>:
{
    8000111a:	1141                	addi	sp,sp,-16
    8000111c:	e406                	sd	ra,8(sp)
    8000111e:	e022                	sd	s0,0(sp)
    80001120:	0800                	addi	s0,sp,16
    80001122:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001124:	86b2                	mv	a3,a2
    80001126:	863e                	mv	a2,a5
    80001128:	f3dff0ef          	jal	80001064 <mappages>
    8000112c:	e509                	bnez	a0,80001136 <kvmmap+0x1c>
}
    8000112e:	60a2                	ld	ra,8(sp)
    80001130:	6402                	ld	s0,0(sp)
    80001132:	0141                	addi	sp,sp,16
    80001134:	8082                	ret
    panic("kvmmap");
    80001136:	00007517          	auipc	a0,0x7
    8000113a:	ff250513          	addi	a0,a0,-14 # 80008128 <etext+0x128>
    8000113e:	ee6ff0ef          	jal	80000824 <panic>

0000000080001142 <kvmmake>:
{
    80001142:	1101                	addi	sp,sp,-32
    80001144:	ec06                	sd	ra,24(sp)
    80001146:	e822                	sd	s0,16(sp)
    80001148:	e426                	sd	s1,8(sp)
    8000114a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000114c:	9f9ff0ef          	jal	80000b44 <kalloc>
    80001150:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001152:	6605                	lui	a2,0x1
    80001154:	4581                	li	a1,0
    80001156:	ba3ff0ef          	jal	80000cf8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000115a:	4719                	li	a4,6
    8000115c:	6685                	lui	a3,0x1
    8000115e:	10000637          	lui	a2,0x10000
    80001162:	85b2                	mv	a1,a2
    80001164:	8526                	mv	a0,s1
    80001166:	fb5ff0ef          	jal	8000111a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000116a:	4719                	li	a4,6
    8000116c:	6685                	lui	a3,0x1
    8000116e:	10001637          	lui	a2,0x10001
    80001172:	85b2                	mv	a1,a2
    80001174:	8526                	mv	a0,s1
    80001176:	fa5ff0ef          	jal	8000111a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000117a:	4719                	li	a4,6
    8000117c:	040006b7          	lui	a3,0x4000
    80001180:	0c000637          	lui	a2,0xc000
    80001184:	85b2                	mv	a1,a2
    80001186:	8526                	mv	a0,s1
    80001188:	f93ff0ef          	jal	8000111a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000118c:	4729                	li	a4,10
    8000118e:	80007697          	auipc	a3,0x80007
    80001192:	e7268693          	addi	a3,a3,-398 # 8000 <_entry-0x7fff8000>
    80001196:	4605                	li	a2,1
    80001198:	067e                	slli	a2,a2,0x1f
    8000119a:	85b2                	mv	a1,a2
    8000119c:	8526                	mv	a0,s1
    8000119e:	f7dff0ef          	jal	8000111a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011a2:	4719                	li	a4,6
    800011a4:	00007697          	auipc	a3,0x7
    800011a8:	e5c68693          	addi	a3,a3,-420 # 80008000 <etext>
    800011ac:	47c5                	li	a5,17
    800011ae:	07ee                	slli	a5,a5,0x1b
    800011b0:	40d786b3          	sub	a3,a5,a3
    800011b4:	00007617          	auipc	a2,0x7
    800011b8:	e4c60613          	addi	a2,a2,-436 # 80008000 <etext>
    800011bc:	85b2                	mv	a1,a2
    800011be:	8526                	mv	a0,s1
    800011c0:	f5bff0ef          	jal	8000111a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c4:	4729                	li	a4,10
    800011c6:	6685                	lui	a3,0x1
    800011c8:	00006617          	auipc	a2,0x6
    800011cc:	e3860613          	addi	a2,a2,-456 # 80007000 <_trampoline>
    800011d0:	040005b7          	lui	a1,0x4000
    800011d4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d6:	05b2                	slli	a1,a1,0xc
    800011d8:	8526                	mv	a0,s1
    800011da:	f41ff0ef          	jal	8000111a <kvmmap>
  proc_mapstacks(kpgtbl);
    800011de:	8526                	mv	a0,s1
    800011e0:	5c4000ef          	jal	800017a4 <proc_mapstacks>
}
    800011e4:	8526                	mv	a0,s1
    800011e6:	60e2                	ld	ra,24(sp)
    800011e8:	6442                	ld	s0,16(sp)
    800011ea:	64a2                	ld	s1,8(sp)
    800011ec:	6105                	addi	sp,sp,32
    800011ee:	8082                	ret

00000000800011f0 <kvminit>:
{
    800011f0:	1141                	addi	sp,sp,-16
    800011f2:	e406                	sd	ra,8(sp)
    800011f4:	e022                	sd	s0,0(sp)
    800011f6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011f8:	f4bff0ef          	jal	80001142 <kvmmake>
    800011fc:	00008797          	auipc	a5,0x8
    80001200:	98a7b623          	sd	a0,-1652(a5) # 80008b88 <kernel_pagetable>
}
    80001204:	60a2                	ld	ra,8(sp)
    80001206:	6402                	ld	s0,0(sp)
    80001208:	0141                	addi	sp,sp,16
    8000120a:	8082                	ret

000000008000120c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000120c:	1101                	addi	sp,sp,-32
    8000120e:	ec06                	sd	ra,24(sp)
    80001210:	e822                	sd	s0,16(sp)
    80001212:	e426                	sd	s1,8(sp)
    80001214:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001216:	92fff0ef          	jal	80000b44 <kalloc>
    8000121a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000121c:	c509                	beqz	a0,80001226 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000121e:	6605                	lui	a2,0x1
    80001220:	4581                	li	a1,0
    80001222:	ad7ff0ef          	jal	80000cf8 <memset>
  return pagetable;
}
    80001226:	8526                	mv	a0,s1
    80001228:	60e2                	ld	ra,24(sp)
    8000122a:	6442                	ld	s0,16(sp)
    8000122c:	64a2                	ld	s1,8(sp)
    8000122e:	6105                	addi	sp,sp,32
    80001230:	8082                	ret

0000000080001232 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001232:	7139                	addi	sp,sp,-64
    80001234:	fc06                	sd	ra,56(sp)
    80001236:	f822                	sd	s0,48(sp)
    80001238:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000123a:	03459793          	slli	a5,a1,0x34
    8000123e:	e38d                	bnez	a5,80001260 <uvmunmap+0x2e>
    80001240:	f04a                	sd	s2,32(sp)
    80001242:	ec4e                	sd	s3,24(sp)
    80001244:	e852                	sd	s4,16(sp)
    80001246:	e456                	sd	s5,8(sp)
    80001248:	e05a                	sd	s6,0(sp)
    8000124a:	8a2a                	mv	s4,a0
    8000124c:	892e                	mv	s2,a1
    8000124e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001250:	0632                	slli	a2,a2,0xc
    80001252:	00b609b3          	add	s3,a2,a1
    80001256:	6b05                	lui	s6,0x1
    80001258:	0535f963          	bgeu	a1,s3,800012aa <uvmunmap+0x78>
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	a015                	j	80001282 <uvmunmap+0x50>
    80001260:	f426                	sd	s1,40(sp)
    80001262:	f04a                	sd	s2,32(sp)
    80001264:	ec4e                	sd	s3,24(sp)
    80001266:	e852                	sd	s4,16(sp)
    80001268:	e456                	sd	s5,8(sp)
    8000126a:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000126c:	00007517          	auipc	a0,0x7
    80001270:	ec450513          	addi	a0,a0,-316 # 80008130 <etext+0x130>
    80001274:	db0ff0ef          	jal	80000824 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001278:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000127c:	995a                	add	s2,s2,s6
    8000127e:	03397563          	bgeu	s2,s3,800012a8 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001282:	4601                	li	a2,0
    80001284:	85ca                	mv	a1,s2
    80001286:	8552                	mv	a0,s4
    80001288:	d09ff0ef          	jal	80000f90 <walk>
    8000128c:	84aa                	mv	s1,a0
    8000128e:	d57d                	beqz	a0,8000127c <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80001290:	611c                	ld	a5,0(a0)
    80001292:	0017f713          	andi	a4,a5,1
    80001296:	d37d                	beqz	a4,8000127c <uvmunmap+0x4a>
    if(do_free){
    80001298:	fe0a80e3          	beqz	s5,80001278 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000129c:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000129e:	00c79513          	slli	a0,a5,0xc
    800012a2:	fbaff0ef          	jal	80000a5c <kfree>
    800012a6:	bfc9                	j	80001278 <uvmunmap+0x46>
    800012a8:	74a2                	ld	s1,40(sp)
    800012aa:	7902                	ld	s2,32(sp)
    800012ac:	69e2                	ld	s3,24(sp)
    800012ae:	6a42                	ld	s4,16(sp)
    800012b0:	6aa2                	ld	s5,8(sp)
    800012b2:	6b02                	ld	s6,0(sp)
  }
}
    800012b4:	70e2                	ld	ra,56(sp)
    800012b6:	7442                	ld	s0,48(sp)
    800012b8:	6121                	addi	sp,sp,64
    800012ba:	8082                	ret

00000000800012bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012bc:	1101                	addi	sp,sp,-32
    800012be:	ec06                	sd	ra,24(sp)
    800012c0:	e822                	sd	s0,16(sp)
    800012c2:	e426                	sd	s1,8(sp)
    800012c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800012c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800012c8:	00b67d63          	bgeu	a2,a1,800012e2 <uvmdealloc+0x26>
    800012cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800012ce:	6785                	lui	a5,0x1
    800012d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012d2:	00f60733          	add	a4,a2,a5
    800012d6:	76fd                	lui	a3,0xfffff
    800012d8:	8f75                	and	a4,a4,a3
    800012da:	97ae                	add	a5,a5,a1
    800012dc:	8ff5                	and	a5,a5,a3
    800012de:	00f76863          	bltu	a4,a5,800012ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012e2:	8526                	mv	a0,s1
    800012e4:	60e2                	ld	ra,24(sp)
    800012e6:	6442                	ld	s0,16(sp)
    800012e8:	64a2                	ld	s1,8(sp)
    800012ea:	6105                	addi	sp,sp,32
    800012ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ee:	8f99                	sub	a5,a5,a4
    800012f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012f2:	4685                	li	a3,1
    800012f4:	0007861b          	sext.w	a2,a5
    800012f8:	85ba                	mv	a1,a4
    800012fa:	f39ff0ef          	jal	80001232 <uvmunmap>
    800012fe:	b7d5                	j	800012e2 <uvmdealloc+0x26>

0000000080001300 <uvmalloc>:
  if(newsz < oldsz)
    80001300:	0ab66163          	bltu	a2,a1,800013a2 <uvmalloc+0xa2>
{
    80001304:	715d                	addi	sp,sp,-80
    80001306:	e486                	sd	ra,72(sp)
    80001308:	e0a2                	sd	s0,64(sp)
    8000130a:	f84a                	sd	s2,48(sp)
    8000130c:	f052                	sd	s4,32(sp)
    8000130e:	ec56                	sd	s5,24(sp)
    80001310:	e45e                	sd	s7,8(sp)
    80001312:	0880                	addi	s0,sp,80
    80001314:	8aaa                	mv	s5,a0
    80001316:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001318:	6785                	lui	a5,0x1
    8000131a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000131c:	95be                	add	a1,a1,a5
    8000131e:	77fd                	lui	a5,0xfffff
    80001320:	00f5f933          	and	s2,a1,a5
    80001324:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001326:	08c97063          	bgeu	s2,a2,800013a6 <uvmalloc+0xa6>
    8000132a:	fc26                	sd	s1,56(sp)
    8000132c:	f44e                	sd	s3,40(sp)
    8000132e:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    80001330:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001332:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001336:	80fff0ef          	jal	80000b44 <kalloc>
    8000133a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000133c:	c50d                	beqz	a0,80001366 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    8000133e:	864e                	mv	a2,s3
    80001340:	4581                	li	a1,0
    80001342:	9b7ff0ef          	jal	80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001346:	875a                	mv	a4,s6
    80001348:	86a6                	mv	a3,s1
    8000134a:	864e                	mv	a2,s3
    8000134c:	85ca                	mv	a1,s2
    8000134e:	8556                	mv	a0,s5
    80001350:	d15ff0ef          	jal	80001064 <mappages>
    80001354:	e915                	bnez	a0,80001388 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001356:	994e                	add	s2,s2,s3
    80001358:	fd496fe3          	bltu	s2,s4,80001336 <uvmalloc+0x36>
  return newsz;
    8000135c:	8552                	mv	a0,s4
    8000135e:	74e2                	ld	s1,56(sp)
    80001360:	79a2                	ld	s3,40(sp)
    80001362:	6b42                	ld	s6,16(sp)
    80001364:	a811                	j	80001378 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001366:	865e                	mv	a2,s7
    80001368:	85ca                	mv	a1,s2
    8000136a:	8556                	mv	a0,s5
    8000136c:	f51ff0ef          	jal	800012bc <uvmdealloc>
      return 0;
    80001370:	4501                	li	a0,0
    80001372:	74e2                	ld	s1,56(sp)
    80001374:	79a2                	ld	s3,40(sp)
    80001376:	6b42                	ld	s6,16(sp)
}
    80001378:	60a6                	ld	ra,72(sp)
    8000137a:	6406                	ld	s0,64(sp)
    8000137c:	7942                	ld	s2,48(sp)
    8000137e:	7a02                	ld	s4,32(sp)
    80001380:	6ae2                	ld	s5,24(sp)
    80001382:	6ba2                	ld	s7,8(sp)
    80001384:	6161                	addi	sp,sp,80
    80001386:	8082                	ret
      kfree(mem);
    80001388:	8526                	mv	a0,s1
    8000138a:	ed2ff0ef          	jal	80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000138e:	865e                	mv	a2,s7
    80001390:	85ca                	mv	a1,s2
    80001392:	8556                	mv	a0,s5
    80001394:	f29ff0ef          	jal	800012bc <uvmdealloc>
      return 0;
    80001398:	4501                	li	a0,0
    8000139a:	74e2                	ld	s1,56(sp)
    8000139c:	79a2                	ld	s3,40(sp)
    8000139e:	6b42                	ld	s6,16(sp)
    800013a0:	bfe1                	j	80001378 <uvmalloc+0x78>
    return oldsz;
    800013a2:	852e                	mv	a0,a1
}
    800013a4:	8082                	ret
  return newsz;
    800013a6:	8532                	mv	a0,a2
    800013a8:	bfc1                	j	80001378 <uvmalloc+0x78>

00000000800013aa <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013aa:	7179                	addi	sp,sp,-48
    800013ac:	f406                	sd	ra,40(sp)
    800013ae:	f022                	sd	s0,32(sp)
    800013b0:	ec26                	sd	s1,24(sp)
    800013b2:	e84a                	sd	s2,16(sp)
    800013b4:	e44e                	sd	s3,8(sp)
    800013b6:	1800                	addi	s0,sp,48
    800013b8:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013ba:	84aa                	mv	s1,a0
    800013bc:	6905                	lui	s2,0x1
    800013be:	992a                	add	s2,s2,a0
    800013c0:	a811                	j	800013d4 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800013c2:	00007517          	auipc	a0,0x7
    800013c6:	d8650513          	addi	a0,a0,-634 # 80008148 <etext+0x148>
    800013ca:	c5aff0ef          	jal	80000824 <panic>
  for(int i = 0; i < 512; i++){
    800013ce:	04a1                	addi	s1,s1,8
    800013d0:	03248163          	beq	s1,s2,800013f2 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013d4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013d6:	0017f713          	andi	a4,a5,1
    800013da:	db75                	beqz	a4,800013ce <freewalk+0x24>
    800013dc:	00e7f713          	andi	a4,a5,14
    800013e0:	f36d                	bnez	a4,800013c2 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800013e2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013e4:	00c79513          	slli	a0,a5,0xc
    800013e8:	fc3ff0ef          	jal	800013aa <freewalk>
      pagetable[i] = 0;
    800013ec:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013f0:	bff9                	j	800013ce <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800013f2:	854e                	mv	a0,s3
    800013f4:	e68ff0ef          	jal	80000a5c <kfree>
}
    800013f8:	70a2                	ld	ra,40(sp)
    800013fa:	7402                	ld	s0,32(sp)
    800013fc:	64e2                	ld	s1,24(sp)
    800013fe:	6942                	ld	s2,16(sp)
    80001400:	69a2                	ld	s3,8(sp)
    80001402:	6145                	addi	sp,sp,48
    80001404:	8082                	ret

0000000080001406 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001406:	1101                	addi	sp,sp,-32
    80001408:	ec06                	sd	ra,24(sp)
    8000140a:	e822                	sd	s0,16(sp)
    8000140c:	e426                	sd	s1,8(sp)
    8000140e:	1000                	addi	s0,sp,32
    80001410:	84aa                	mv	s1,a0
  if(sz > 0)
    80001412:	e989                	bnez	a1,80001424 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001414:	8526                	mv	a0,s1
    80001416:	f95ff0ef          	jal	800013aa <freewalk>
}
    8000141a:	60e2                	ld	ra,24(sp)
    8000141c:	6442                	ld	s0,16(sp)
    8000141e:	64a2                	ld	s1,8(sp)
    80001420:	6105                	addi	sp,sp,32
    80001422:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001424:	6785                	lui	a5,0x1
    80001426:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001428:	95be                	add	a1,a1,a5
    8000142a:	4685                	li	a3,1
    8000142c:	00c5d613          	srli	a2,a1,0xc
    80001430:	4581                	li	a1,0
    80001432:	e01ff0ef          	jal	80001232 <uvmunmap>
    80001436:	bff9                	j	80001414 <uvmfree+0xe>

0000000080001438 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001438:	ca59                	beqz	a2,800014ce <uvmcopy+0x96>
{
    8000143a:	715d                	addi	sp,sp,-80
    8000143c:	e486                	sd	ra,72(sp)
    8000143e:	e0a2                	sd	s0,64(sp)
    80001440:	fc26                	sd	s1,56(sp)
    80001442:	f84a                	sd	s2,48(sp)
    80001444:	f44e                	sd	s3,40(sp)
    80001446:	f052                	sd	s4,32(sp)
    80001448:	ec56                	sd	s5,24(sp)
    8000144a:	e85a                	sd	s6,16(sp)
    8000144c:	e45e                	sd	s7,8(sp)
    8000144e:	0880                	addi	s0,sp,80
    80001450:	8b2a                	mv	s6,a0
    80001452:	8bae                	mv	s7,a1
    80001454:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001456:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001458:	6a05                	lui	s4,0x1
    8000145a:	a021                	j	80001462 <uvmcopy+0x2a>
  for(i = 0; i < sz; i += PGSIZE){
    8000145c:	94d2                	add	s1,s1,s4
    8000145e:	0554fc63          	bgeu	s1,s5,800014b6 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    80001462:	4601                	li	a2,0
    80001464:	85a6                	mv	a1,s1
    80001466:	855a                	mv	a0,s6
    80001468:	b29ff0ef          	jal	80000f90 <walk>
    8000146c:	d965                	beqz	a0,8000145c <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    8000146e:	00053983          	ld	s3,0(a0)
    80001472:	0019f793          	andi	a5,s3,1
    80001476:	d3fd                	beqz	a5,8000145c <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    80001478:	eccff0ef          	jal	80000b44 <kalloc>
    8000147c:	892a                	mv	s2,a0
    8000147e:	c11d                	beqz	a0,800014a4 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    80001480:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001484:	8652                	mv	a2,s4
    80001486:	05b2                	slli	a1,a1,0xc
    80001488:	8d1ff0ef          	jal	80000d58 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000148c:	3ff9f713          	andi	a4,s3,1023
    80001490:	86ca                	mv	a3,s2
    80001492:	8652                	mv	a2,s4
    80001494:	85a6                	mv	a1,s1
    80001496:	855e                	mv	a0,s7
    80001498:	bcdff0ef          	jal	80001064 <mappages>
    8000149c:	d161                	beqz	a0,8000145c <uvmcopy+0x24>
      kfree(mem);
    8000149e:	854a                	mv	a0,s2
    800014a0:	dbcff0ef          	jal	80000a5c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014a4:	4685                	li	a3,1
    800014a6:	00c4d613          	srli	a2,s1,0xc
    800014aa:	4581                	li	a1,0
    800014ac:	855e                	mv	a0,s7
    800014ae:	d85ff0ef          	jal	80001232 <uvmunmap>
  return -1;
    800014b2:	557d                	li	a0,-1
    800014b4:	a011                	j	800014b8 <uvmcopy+0x80>
  return 0;
    800014b6:	4501                	li	a0,0
}
    800014b8:	60a6                	ld	ra,72(sp)
    800014ba:	6406                	ld	s0,64(sp)
    800014bc:	74e2                	ld	s1,56(sp)
    800014be:	7942                	ld	s2,48(sp)
    800014c0:	79a2                	ld	s3,40(sp)
    800014c2:	7a02                	ld	s4,32(sp)
    800014c4:	6ae2                	ld	s5,24(sp)
    800014c6:	6b42                	ld	s6,16(sp)
    800014c8:	6ba2                	ld	s7,8(sp)
    800014ca:	6161                	addi	sp,sp,80
    800014cc:	8082                	ret
  return 0;
    800014ce:	4501                	li	a0,0
}
    800014d0:	8082                	ret

00000000800014d2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014d2:	1141                	addi	sp,sp,-16
    800014d4:	e406                	sd	ra,8(sp)
    800014d6:	e022                	sd	s0,0(sp)
    800014d8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800014da:	4601                	li	a2,0
    800014dc:	ab5ff0ef          	jal	80000f90 <walk>
  if(pte == 0)
    800014e0:	c901                	beqz	a0,800014f0 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014e2:	611c                	ld	a5,0(a0)
    800014e4:	9bbd                	andi	a5,a5,-17
    800014e6:	e11c                	sd	a5,0(a0)
}
    800014e8:	60a2                	ld	ra,8(sp)
    800014ea:	6402                	ld	s0,0(sp)
    800014ec:	0141                	addi	sp,sp,16
    800014ee:	8082                	ret
    panic("uvmclear");
    800014f0:	00007517          	auipc	a0,0x7
    800014f4:	c6850513          	addi	a0,a0,-920 # 80008158 <etext+0x158>
    800014f8:	b2cff0ef          	jal	80000824 <panic>

00000000800014fc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800014fc:	cac5                	beqz	a3,800015ac <copyinstr+0xb0>
{
    800014fe:	715d                	addi	sp,sp,-80
    80001500:	e486                	sd	ra,72(sp)
    80001502:	e0a2                	sd	s0,64(sp)
    80001504:	fc26                	sd	s1,56(sp)
    80001506:	f84a                	sd	s2,48(sp)
    80001508:	f44e                	sd	s3,40(sp)
    8000150a:	f052                	sd	s4,32(sp)
    8000150c:	ec56                	sd	s5,24(sp)
    8000150e:	e85a                	sd	s6,16(sp)
    80001510:	e45e                	sd	s7,8(sp)
    80001512:	0880                	addi	s0,sp,80
    80001514:	8aaa                	mv	s5,a0
    80001516:	84ae                	mv	s1,a1
    80001518:	8bb2                	mv	s7,a2
    8000151a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000151c:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000151e:	6a05                	lui	s4,0x1
    80001520:	a82d                	j	8000155a <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001522:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80001526:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001528:	0017c793          	xori	a5,a5,1
    8000152c:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001530:	60a6                	ld	ra,72(sp)
    80001532:	6406                	ld	s0,64(sp)
    80001534:	74e2                	ld	s1,56(sp)
    80001536:	7942                	ld	s2,48(sp)
    80001538:	79a2                	ld	s3,40(sp)
    8000153a:	7a02                	ld	s4,32(sp)
    8000153c:	6ae2                	ld	s5,24(sp)
    8000153e:	6b42                	ld	s6,16(sp)
    80001540:	6ba2                	ld	s7,8(sp)
    80001542:	6161                	addi	sp,sp,80
    80001544:	8082                	ret
    80001546:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    8000154a:	9726                	add	a4,a4,s1
      --max;
    8000154c:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001550:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001554:	04e58463          	beq	a1,a4,8000159c <copyinstr+0xa0>
{
    80001558:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    8000155a:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000155e:	85ca                	mv	a1,s2
    80001560:	8556                	mv	a0,s5
    80001562:	ac9ff0ef          	jal	8000102a <walkaddr>
    if(pa0 == 0)
    80001566:	cd0d                	beqz	a0,800015a0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001568:	417906b3          	sub	a3,s2,s7
    8000156c:	96d2                	add	a3,a3,s4
    if(n > max)
    8000156e:	00d9f363          	bgeu	s3,a3,80001574 <copyinstr+0x78>
    80001572:	86ce                	mv	a3,s3
    while(n > 0){
    80001574:	ca85                	beqz	a3,800015a4 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80001576:	01750633          	add	a2,a0,s7
    8000157a:	41260633          	sub	a2,a2,s2
    8000157e:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80001580:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80001582:	96a6                	add	a3,a3,s1
    80001584:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001586:	00f60733          	add	a4,a2,a5
    8000158a:	00074703          	lbu	a4,0(a4)
    8000158e:	db51                	beqz	a4,80001522 <copyinstr+0x26>
        *dst = *p;
    80001590:	00e78023          	sb	a4,0(a5)
      dst++;
    80001594:	0785                	addi	a5,a5,1
    while(n > 0){
    80001596:	fed797e3          	bne	a5,a3,80001584 <copyinstr+0x88>
    8000159a:	b775                	j	80001546 <copyinstr+0x4a>
    8000159c:	4781                	li	a5,0
    8000159e:	b769                	j	80001528 <copyinstr+0x2c>
      return -1;
    800015a0:	557d                	li	a0,-1
    800015a2:	b779                	j	80001530 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800015a4:	6b85                	lui	s7,0x1
    800015a6:	9bca                	add	s7,s7,s2
    800015a8:	87a6                	mv	a5,s1
    800015aa:	b77d                	j	80001558 <copyinstr+0x5c>
  int got_null = 0;
    800015ac:	4781                	li	a5,0
  if(got_null){
    800015ae:	0017c793          	xori	a5,a5,1
    800015b2:	40f0053b          	negw	a0,a5
}
    800015b6:	8082                	ret

00000000800015b8 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800015b8:	1141                	addi	sp,sp,-16
    800015ba:	e406                	sd	ra,8(sp)
    800015bc:	e022                	sd	s0,0(sp)
    800015be:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800015c0:	4601                	li	a2,0
    800015c2:	9cfff0ef          	jal	80000f90 <walk>
  if (pte == 0) {
    800015c6:	c119                	beqz	a0,800015cc <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    800015c8:	6108                	ld	a0,0(a0)
    800015ca:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800015cc:	60a2                	ld	ra,8(sp)
    800015ce:	6402                	ld	s0,0(sp)
    800015d0:	0141                	addi	sp,sp,16
    800015d2:	8082                	ret

00000000800015d4 <vmfault>:
{
    800015d4:	7179                	addi	sp,sp,-48
    800015d6:	f406                	sd	ra,40(sp)
    800015d8:	f022                	sd	s0,32(sp)
    800015da:	e84a                	sd	s2,16(sp)
    800015dc:	e44e                	sd	s3,8(sp)
    800015de:	1800                	addi	s0,sp,48
    800015e0:	89aa                	mv	s3,a0
    800015e2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015e4:	34e000ef          	jal	80001932 <myproc>
  if (va >= p->sz)
    800015e8:	653c                	ld	a5,72(a0)
    800015ea:	00f96a63          	bltu	s2,a5,800015fe <vmfault+0x2a>
    return 0;
    800015ee:	4981                	li	s3,0
}
    800015f0:	854e                	mv	a0,s3
    800015f2:	70a2                	ld	ra,40(sp)
    800015f4:	7402                	ld	s0,32(sp)
    800015f6:	6942                	ld	s2,16(sp)
    800015f8:	69a2                	ld	s3,8(sp)
    800015fa:	6145                	addi	sp,sp,48
    800015fc:	8082                	ret
    800015fe:	ec26                	sd	s1,24(sp)
    80001600:	e052                	sd	s4,0(sp)
    80001602:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80001604:	77fd                	lui	a5,0xfffff
    80001606:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    8000160a:	85d2                	mv	a1,s4
    8000160c:	854e                	mv	a0,s3
    8000160e:	fabff0ef          	jal	800015b8 <ismapped>
    return 0;
    80001612:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80001614:	c501                	beqz	a0,8000161c <vmfault+0x48>
    80001616:	64e2                	ld	s1,24(sp)
    80001618:	6a02                	ld	s4,0(sp)
    8000161a:	bfd9                	j	800015f0 <vmfault+0x1c>
  mem = (uint64) kalloc();
    8000161c:	d28ff0ef          	jal	80000b44 <kalloc>
    80001620:	892a                	mv	s2,a0
  if(mem == 0)
    80001622:	c905                	beqz	a0,80001652 <vmfault+0x7e>
  mem = (uint64) kalloc();
    80001624:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80001626:	6605                	lui	a2,0x1
    80001628:	4581                	li	a1,0
    8000162a:	eceff0ef          	jal	80000cf8 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    8000162e:	4759                	li	a4,22
    80001630:	86ca                	mv	a3,s2
    80001632:	6605                	lui	a2,0x1
    80001634:	85d2                	mv	a1,s4
    80001636:	68a8                	ld	a0,80(s1)
    80001638:	a2dff0ef          	jal	80001064 <mappages>
    8000163c:	e501                	bnez	a0,80001644 <vmfault+0x70>
    8000163e:	64e2                	ld	s1,24(sp)
    80001640:	6a02                	ld	s4,0(sp)
    80001642:	b77d                	j	800015f0 <vmfault+0x1c>
    kfree((void *)mem);
    80001644:	854a                	mv	a0,s2
    80001646:	c16ff0ef          	jal	80000a5c <kfree>
    return 0;
    8000164a:	4981                	li	s3,0
    8000164c:	64e2                	ld	s1,24(sp)
    8000164e:	6a02                	ld	s4,0(sp)
    80001650:	b745                	j	800015f0 <vmfault+0x1c>
    80001652:	64e2                	ld	s1,24(sp)
    80001654:	6a02                	ld	s4,0(sp)
    80001656:	bf69                	j	800015f0 <vmfault+0x1c>

0000000080001658 <copyout>:
  while(len > 0){
    80001658:	cad1                	beqz	a3,800016ec <copyout+0x94>
{
    8000165a:	711d                	addi	sp,sp,-96
    8000165c:	ec86                	sd	ra,88(sp)
    8000165e:	e8a2                	sd	s0,80(sp)
    80001660:	e4a6                	sd	s1,72(sp)
    80001662:	e0ca                	sd	s2,64(sp)
    80001664:	fc4e                	sd	s3,56(sp)
    80001666:	f852                	sd	s4,48(sp)
    80001668:	f456                	sd	s5,40(sp)
    8000166a:	f05a                	sd	s6,32(sp)
    8000166c:	ec5e                	sd	s7,24(sp)
    8000166e:	e862                	sd	s8,16(sp)
    80001670:	e466                	sd	s9,8(sp)
    80001672:	e06a                	sd	s10,0(sp)
    80001674:	1080                	addi	s0,sp,96
    80001676:	8baa                	mv	s7,a0
    80001678:	8a2e                	mv	s4,a1
    8000167a:	8b32                	mv	s6,a2
    8000167c:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000167e:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80001680:	5cfd                	li	s9,-1
    80001682:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001686:	6c05                	lui	s8,0x1
    80001688:	a005                	j	800016a8 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000168a:	409a0533          	sub	a0,s4,s1
    8000168e:	0009061b          	sext.w	a2,s2
    80001692:	85da                	mv	a1,s6
    80001694:	954e                	add	a0,a0,s3
    80001696:	ec2ff0ef          	jal	80000d58 <memmove>
    len -= n;
    8000169a:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000169e:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    800016a0:	01848a33          	add	s4,s1,s8
  while(len > 0){
    800016a4:	040a8263          	beqz	s5,800016e8 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    800016a8:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    800016ac:	049ce263          	bltu	s9,s1,800016f0 <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    800016b0:	85a6                	mv	a1,s1
    800016b2:	855e                	mv	a0,s7
    800016b4:	977ff0ef          	jal	8000102a <walkaddr>
    800016b8:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    800016ba:	e901                	bnez	a0,800016ca <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800016bc:	4601                	li	a2,0
    800016be:	85a6                	mv	a1,s1
    800016c0:	855e                	mv	a0,s7
    800016c2:	f13ff0ef          	jal	800015d4 <vmfault>
    800016c6:	89aa                	mv	s3,a0
    800016c8:	c139                	beqz	a0,8000170e <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    800016ca:	4601                	li	a2,0
    800016cc:	85a6                	mv	a1,s1
    800016ce:	855e                	mv	a0,s7
    800016d0:	8c1ff0ef          	jal	80000f90 <walk>
    if((*pte & PTE_W) == 0)
    800016d4:	611c                	ld	a5,0(a0)
    800016d6:	8b91                	andi	a5,a5,4
    800016d8:	cf8d                	beqz	a5,80001712 <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    800016da:	41448933          	sub	s2,s1,s4
    800016de:	9962                	add	s2,s2,s8
    if(n > len)
    800016e0:	fb2af5e3          	bgeu	s5,s2,8000168a <copyout+0x32>
    800016e4:	8956                	mv	s2,s5
    800016e6:	b755                	j	8000168a <copyout+0x32>
  return 0;
    800016e8:	4501                	li	a0,0
    800016ea:	a021                	j	800016f2 <copyout+0x9a>
    800016ec:	4501                	li	a0,0
}
    800016ee:	8082                	ret
      return -1;
    800016f0:	557d                	li	a0,-1
}
    800016f2:	60e6                	ld	ra,88(sp)
    800016f4:	6446                	ld	s0,80(sp)
    800016f6:	64a6                	ld	s1,72(sp)
    800016f8:	6906                	ld	s2,64(sp)
    800016fa:	79e2                	ld	s3,56(sp)
    800016fc:	7a42                	ld	s4,48(sp)
    800016fe:	7aa2                	ld	s5,40(sp)
    80001700:	7b02                	ld	s6,32(sp)
    80001702:	6be2                	ld	s7,24(sp)
    80001704:	6c42                	ld	s8,16(sp)
    80001706:	6ca2                	ld	s9,8(sp)
    80001708:	6d02                	ld	s10,0(sp)
    8000170a:	6125                	addi	sp,sp,96
    8000170c:	8082                	ret
        return -1;
    8000170e:	557d                	li	a0,-1
    80001710:	b7cd                	j	800016f2 <copyout+0x9a>
      return -1;
    80001712:	557d                	li	a0,-1
    80001714:	bff9                	j	800016f2 <copyout+0x9a>

0000000080001716 <copyin>:
  while(len > 0){
    80001716:	c6c9                	beqz	a3,800017a0 <copyin+0x8a>
{
    80001718:	715d                	addi	sp,sp,-80
    8000171a:	e486                	sd	ra,72(sp)
    8000171c:	e0a2                	sd	s0,64(sp)
    8000171e:	fc26                	sd	s1,56(sp)
    80001720:	f84a                	sd	s2,48(sp)
    80001722:	f44e                	sd	s3,40(sp)
    80001724:	f052                	sd	s4,32(sp)
    80001726:	ec56                	sd	s5,24(sp)
    80001728:	e85a                	sd	s6,16(sp)
    8000172a:	e45e                	sd	s7,8(sp)
    8000172c:	e062                	sd	s8,0(sp)
    8000172e:	0880                	addi	s0,sp,80
    80001730:	8baa                	mv	s7,a0
    80001732:	8aae                	mv	s5,a1
    80001734:	8932                	mv	s2,a2
    80001736:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001738:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    8000173a:	6b05                	lui	s6,0x1
    8000173c:	a035                	j	80001768 <copyin+0x52>
    8000173e:	412984b3          	sub	s1,s3,s2
    80001742:	94da                	add	s1,s1,s6
    if(n > len)
    80001744:	009a7363          	bgeu	s4,s1,8000174a <copyin+0x34>
    80001748:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000174a:	413905b3          	sub	a1,s2,s3
    8000174e:	0004861b          	sext.w	a2,s1
    80001752:	95aa                	add	a1,a1,a0
    80001754:	8556                	mv	a0,s5
    80001756:	e02ff0ef          	jal	80000d58 <memmove>
    len -= n;
    8000175a:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000175e:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001760:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001764:	020a0163          	beqz	s4,80001786 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001768:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    8000176c:	85ce                	mv	a1,s3
    8000176e:	855e                	mv	a0,s7
    80001770:	8bbff0ef          	jal	8000102a <walkaddr>
    if(pa0 == 0) {
    80001774:	f569                	bnez	a0,8000173e <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001776:	4601                	li	a2,0
    80001778:	85ce                	mv	a1,s3
    8000177a:	855e                	mv	a0,s7
    8000177c:	e59ff0ef          	jal	800015d4 <vmfault>
    80001780:	fd5d                	bnez	a0,8000173e <copyin+0x28>
        return -1;
    80001782:	557d                	li	a0,-1
    80001784:	a011                	j	80001788 <copyin+0x72>
  return 0;
    80001786:	4501                	li	a0,0
}
    80001788:	60a6                	ld	ra,72(sp)
    8000178a:	6406                	ld	s0,64(sp)
    8000178c:	74e2                	ld	s1,56(sp)
    8000178e:	7942                	ld	s2,48(sp)
    80001790:	79a2                	ld	s3,40(sp)
    80001792:	7a02                	ld	s4,32(sp)
    80001794:	6ae2                	ld	s5,24(sp)
    80001796:	6b42                	ld	s6,16(sp)
    80001798:	6ba2                	ld	s7,8(sp)
    8000179a:	6c02                	ld	s8,0(sp)
    8000179c:	6161                	addi	sp,sp,80
    8000179e:	8082                	ret
  return 0;
    800017a0:	4501                	li	a0,0
}
    800017a2:	8082                	ret

00000000800017a4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800017a4:	715d                	addi	sp,sp,-80
    800017a6:	e486                	sd	ra,72(sp)
    800017a8:	e0a2                	sd	s0,64(sp)
    800017aa:	fc26                	sd	s1,56(sp)
    800017ac:	f84a                	sd	s2,48(sp)
    800017ae:	f44e                	sd	s3,40(sp)
    800017b0:	f052                	sd	s4,32(sp)
    800017b2:	ec56                	sd	s5,24(sp)
    800017b4:	e85a                	sd	s6,16(sp)
    800017b6:	e45e                	sd	s7,8(sp)
    800017b8:	e062                	sd	s8,0(sp)
    800017ba:	0880                	addi	s0,sp,80
    800017bc:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017be:	00010497          	auipc	s1,0x10
    800017c2:	90a48493          	addi	s1,s1,-1782 # 800110c8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017c6:	8c26                	mv	s8,s1
    800017c8:	000a57b7          	lui	a5,0xa5
    800017cc:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    800017d0:	07b2                	slli	a5,a5,0xc
    800017d2:	fa578793          	addi	a5,a5,-91
    800017d6:	4fa50937          	lui	s2,0x4fa50
    800017da:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    800017de:	1902                	slli	s2,s2,0x20
    800017e0:	993e                	add	s2,s2,a5
    800017e2:	040009b7          	lui	s3,0x4000
    800017e6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017e8:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017ea:	4b99                	li	s7,6
    800017ec:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ee:	00015a97          	auipc	s5,0x15
    800017f2:	2daa8a93          	addi	s5,s5,730 # 80016ac8 <tickslock>
    char *pa = kalloc();
    800017f6:	b4eff0ef          	jal	80000b44 <kalloc>
    800017fa:	862a                	mv	a2,a0
    if(pa == 0)
    800017fc:	c121                	beqz	a0,8000183c <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    800017fe:	418485b3          	sub	a1,s1,s8
    80001802:	858d                	srai	a1,a1,0x3
    80001804:	032585b3          	mul	a1,a1,s2
    80001808:	05b6                	slli	a1,a1,0xd
    8000180a:	6789                	lui	a5,0x2
    8000180c:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000180e:	875e                	mv	a4,s7
    80001810:	86da                	mv	a3,s6
    80001812:	40b985b3          	sub	a1,s3,a1
    80001816:	8552                	mv	a0,s4
    80001818:	903ff0ef          	jal	8000111a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000181c:	16848493          	addi	s1,s1,360
    80001820:	fd549be3          	bne	s1,s5,800017f6 <proc_mapstacks+0x52>
  }
}
    80001824:	60a6                	ld	ra,72(sp)
    80001826:	6406                	ld	s0,64(sp)
    80001828:	74e2                	ld	s1,56(sp)
    8000182a:	7942                	ld	s2,48(sp)
    8000182c:	79a2                	ld	s3,40(sp)
    8000182e:	7a02                	ld	s4,32(sp)
    80001830:	6ae2                	ld	s5,24(sp)
    80001832:	6b42                	ld	s6,16(sp)
    80001834:	6ba2                	ld	s7,8(sp)
    80001836:	6c02                	ld	s8,0(sp)
    80001838:	6161                	addi	sp,sp,80
    8000183a:	8082                	ret
      panic("kalloc");
    8000183c:	00007517          	auipc	a0,0x7
    80001840:	92c50513          	addi	a0,a0,-1748 # 80008168 <etext+0x168>
    80001844:	fe1fe0ef          	jal	80000824 <panic>

0000000080001848 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001848:	7139                	addi	sp,sp,-64
    8000184a:	fc06                	sd	ra,56(sp)
    8000184c:	f822                	sd	s0,48(sp)
    8000184e:	f426                	sd	s1,40(sp)
    80001850:	f04a                	sd	s2,32(sp)
    80001852:	ec4e                	sd	s3,24(sp)
    80001854:	e852                	sd	s4,16(sp)
    80001856:	e456                	sd	s5,8(sp)
    80001858:	e05a                	sd	s6,0(sp)
    8000185a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000185c:	00007597          	auipc	a1,0x7
    80001860:	91458593          	addi	a1,a1,-1772 # 80008170 <etext+0x170>
    80001864:	0000f517          	auipc	a0,0xf
    80001868:	43450513          	addi	a0,a0,1076 # 80010c98 <pid_lock>
    8000186c:	b32ff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001870:	00007597          	auipc	a1,0x7
    80001874:	90858593          	addi	a1,a1,-1784 # 80008178 <etext+0x178>
    80001878:	0000f517          	auipc	a0,0xf
    8000187c:	43850513          	addi	a0,a0,1080 # 80010cb0 <wait_lock>
    80001880:	b1eff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001884:	00010497          	auipc	s1,0x10
    80001888:	84448493          	addi	s1,s1,-1980 # 800110c8 <proc>
      initlock(&p->lock, "proc");
    8000188c:	00007b17          	auipc	s6,0x7
    80001890:	8fcb0b13          	addi	s6,s6,-1796 # 80008188 <etext+0x188>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001894:	8aa6                	mv	s5,s1
    80001896:	000a57b7          	lui	a5,0xa5
    8000189a:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    8000189e:	07b2                	slli	a5,a5,0xc
    800018a0:	fa578793          	addi	a5,a5,-91
    800018a4:	4fa50937          	lui	s2,0x4fa50
    800018a8:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    800018ac:	1902                	slli	s2,s2,0x20
    800018ae:	993e                	add	s2,s2,a5
    800018b0:	040009b7          	lui	s3,0x4000
    800018b4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018b6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b8:	00015a17          	auipc	s4,0x15
    800018bc:	210a0a13          	addi	s4,s4,528 # 80016ac8 <tickslock>
      initlock(&p->lock, "proc");
    800018c0:	85da                	mv	a1,s6
    800018c2:	8526                	mv	a0,s1
    800018c4:	adaff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    800018c8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018cc:	415487b3          	sub	a5,s1,s5
    800018d0:	878d                	srai	a5,a5,0x3
    800018d2:	032787b3          	mul	a5,a5,s2
    800018d6:	07b6                	slli	a5,a5,0xd
    800018d8:	6709                	lui	a4,0x2
    800018da:	9fb9                	addw	a5,a5,a4
    800018dc:	40f987b3          	sub	a5,s3,a5
    800018e0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018e2:	16848493          	addi	s1,s1,360
    800018e6:	fd449de3          	bne	s1,s4,800018c0 <procinit+0x78>
  }
}
    800018ea:	70e2                	ld	ra,56(sp)
    800018ec:	7442                	ld	s0,48(sp)
    800018ee:	74a2                	ld	s1,40(sp)
    800018f0:	7902                	ld	s2,32(sp)
    800018f2:	69e2                	ld	s3,24(sp)
    800018f4:	6a42                	ld	s4,16(sp)
    800018f6:	6aa2                	ld	s5,8(sp)
    800018f8:	6b02                	ld	s6,0(sp)
    800018fa:	6121                	addi	sp,sp,64
    800018fc:	8082                	ret

00000000800018fe <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018fe:	1141                	addi	sp,sp,-16
    80001900:	e406                	sd	ra,8(sp)
    80001902:	e022                	sd	s0,0(sp)
    80001904:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001906:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001908:	2501                	sext.w	a0,a0
    8000190a:	60a2                	ld	ra,8(sp)
    8000190c:	6402                	ld	s0,0(sp)
    8000190e:	0141                	addi	sp,sp,16
    80001910:	8082                	ret

0000000080001912 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001912:	1141                	addi	sp,sp,-16
    80001914:	e406                	sd	ra,8(sp)
    80001916:	e022                	sd	s0,0(sp)
    80001918:	0800                	addi	s0,sp,16
    8000191a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000191c:	2781                	sext.w	a5,a5
    8000191e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001920:	0000f517          	auipc	a0,0xf
    80001924:	3a850513          	addi	a0,a0,936 # 80010cc8 <cpus>
    80001928:	953e                	add	a0,a0,a5
    8000192a:	60a2                	ld	ra,8(sp)
    8000192c:	6402                	ld	s0,0(sp)
    8000192e:	0141                	addi	sp,sp,16
    80001930:	8082                	ret

0000000080001932 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001932:	1101                	addi	sp,sp,-32
    80001934:	ec06                	sd	ra,24(sp)
    80001936:	e822                	sd	s0,16(sp)
    80001938:	e426                	sd	s1,8(sp)
    8000193a:	1000                	addi	s0,sp,32
  push_off();
    8000193c:	aa8ff0ef          	jal	80000be4 <push_off>
    80001940:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001942:	2781                	sext.w	a5,a5
    80001944:	079e                	slli	a5,a5,0x7
    80001946:	0000f717          	auipc	a4,0xf
    8000194a:	35270713          	addi	a4,a4,850 # 80010c98 <pid_lock>
    8000194e:	97ba                	add	a5,a5,a4
    80001950:	7b9c                	ld	a5,48(a5)
    80001952:	84be                	mv	s1,a5
  pop_off();
    80001954:	b18ff0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001958:	8526                	mv	a0,s1
    8000195a:	60e2                	ld	ra,24(sp)
    8000195c:	6442                	ld	s0,16(sp)
    8000195e:	64a2                	ld	s1,8(sp)
    80001960:	6105                	addi	sp,sp,32
    80001962:	8082                	ret

0000000080001964 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001964:	7179                	addi	sp,sp,-48
    80001966:	f406                	sd	ra,40(sp)
    80001968:	f022                	sd	s0,32(sp)
    8000196a:	ec26                	sd	s1,24(sp)
    8000196c:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000196e:	fc5ff0ef          	jal	80001932 <myproc>
    80001972:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001974:	b48ff0ef          	jal	80000cbc <release>

  if (first) {
    80001978:	00007797          	auipc	a5,0x7
    8000197c:	1e87a783          	lw	a5,488(a5) # 80008b60 <first.1>
    80001980:	cf95                	beqz	a5,800019bc <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001982:	4505                	li	a0,1
    80001984:	381010ef          	jal	80003504 <fsinit>

    first = 0;
    80001988:	00007797          	auipc	a5,0x7
    8000198c:	1c07ac23          	sw	zero,472(a5) # 80008b60 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001990:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001994:	00006797          	auipc	a5,0x6
    80001998:	7fc78793          	addi	a5,a5,2044 # 80008190 <etext+0x190>
    8000199c:	fcf43823          	sd	a5,-48(s0)
    800019a0:	fc043c23          	sd	zero,-40(s0)
    800019a4:	fd040593          	addi	a1,s0,-48
    800019a8:	853e                	mv	a0,a5
    800019aa:	41c030ef          	jal	80004dc6 <kexec>
    800019ae:	6cbc                	ld	a5,88(s1)
    800019b0:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800019b2:	6cbc                	ld	a5,88(s1)
    800019b4:	7bb8                	ld	a4,112(a5)
    800019b6:	57fd                	li	a5,-1
    800019b8:	02f70d63          	beq	a4,a5,800019f2 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800019bc:	2b1000ef          	jal	8000246c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800019c0:	68a8                	ld	a0,80(s1)
    800019c2:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019c4:	04000737          	lui	a4,0x4000
    800019c8:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019ca:	0732                	slli	a4,a4,0xc
    800019cc:	00005797          	auipc	a5,0x5
    800019d0:	6d078793          	addi	a5,a5,1744 # 8000709c <userret>
    800019d4:	00005697          	auipc	a3,0x5
    800019d8:	62c68693          	addi	a3,a3,1580 # 80007000 <_trampoline>
    800019dc:	8f95                	sub	a5,a5,a3
    800019de:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019e0:	577d                	li	a4,-1
    800019e2:	177e                	slli	a4,a4,0x3f
    800019e4:	8d59                	or	a0,a0,a4
    800019e6:	9782                	jalr	a5
}
    800019e8:	70a2                	ld	ra,40(sp)
    800019ea:	7402                	ld	s0,32(sp)
    800019ec:	64e2                	ld	s1,24(sp)
    800019ee:	6145                	addi	sp,sp,48
    800019f0:	8082                	ret
      panic("exec");
    800019f2:	00006517          	auipc	a0,0x6
    800019f6:	7a650513          	addi	a0,a0,1958 # 80008198 <etext+0x198>
    800019fa:	e2bfe0ef          	jal	80000824 <panic>

00000000800019fe <allocpid>:
{
    800019fe:	1101                	addi	sp,sp,-32
    80001a00:	ec06                	sd	ra,24(sp)
    80001a02:	e822                	sd	s0,16(sp)
    80001a04:	e426                	sd	s1,8(sp)
    80001a06:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a08:	0000f517          	auipc	a0,0xf
    80001a0c:	29050513          	addi	a0,a0,656 # 80010c98 <pid_lock>
    80001a10:	a18ff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80001a14:	00007797          	auipc	a5,0x7
    80001a18:	15078793          	addi	a5,a5,336 # 80008b64 <nextpid>
    80001a1c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a1e:	0014871b          	addiw	a4,s1,1
    80001a22:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a24:	0000f517          	auipc	a0,0xf
    80001a28:	27450513          	addi	a0,a0,628 # 80010c98 <pid_lock>
    80001a2c:	a90ff0ef          	jal	80000cbc <release>
}
    80001a30:	8526                	mv	a0,s1
    80001a32:	60e2                	ld	ra,24(sp)
    80001a34:	6442                	ld	s0,16(sp)
    80001a36:	64a2                	ld	s1,8(sp)
    80001a38:	6105                	addi	sp,sp,32
    80001a3a:	8082                	ret

0000000080001a3c <proc_pagetable>:
{
    80001a3c:	1101                	addi	sp,sp,-32
    80001a3e:	ec06                	sd	ra,24(sp)
    80001a40:	e822                	sd	s0,16(sp)
    80001a42:	e426                	sd	s1,8(sp)
    80001a44:	e04a                	sd	s2,0(sp)
    80001a46:	1000                	addi	s0,sp,32
    80001a48:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a4a:	fc2ff0ef          	jal	8000120c <uvmcreate>
    80001a4e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a50:	cd05                	beqz	a0,80001a88 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a52:	4729                	li	a4,10
    80001a54:	00005697          	auipc	a3,0x5
    80001a58:	5ac68693          	addi	a3,a3,1452 # 80007000 <_trampoline>
    80001a5c:	6605                	lui	a2,0x1
    80001a5e:	040005b7          	lui	a1,0x4000
    80001a62:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a64:	05b2                	slli	a1,a1,0xc
    80001a66:	dfeff0ef          	jal	80001064 <mappages>
    80001a6a:	02054663          	bltz	a0,80001a96 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a6e:	4719                	li	a4,6
    80001a70:	05893683          	ld	a3,88(s2)
    80001a74:	6605                	lui	a2,0x1
    80001a76:	020005b7          	lui	a1,0x2000
    80001a7a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a7c:	05b6                	slli	a1,a1,0xd
    80001a7e:	8526                	mv	a0,s1
    80001a80:	de4ff0ef          	jal	80001064 <mappages>
    80001a84:	00054f63          	bltz	a0,80001aa2 <proc_pagetable+0x66>
}
    80001a88:	8526                	mv	a0,s1
    80001a8a:	60e2                	ld	ra,24(sp)
    80001a8c:	6442                	ld	s0,16(sp)
    80001a8e:	64a2                	ld	s1,8(sp)
    80001a90:	6902                	ld	s2,0(sp)
    80001a92:	6105                	addi	sp,sp,32
    80001a94:	8082                	ret
    uvmfree(pagetable, 0);
    80001a96:	4581                	li	a1,0
    80001a98:	8526                	mv	a0,s1
    80001a9a:	96dff0ef          	jal	80001406 <uvmfree>
    return 0;
    80001a9e:	4481                	li	s1,0
    80001aa0:	b7e5                	j	80001a88 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aa2:	4681                	li	a3,0
    80001aa4:	4605                	li	a2,1
    80001aa6:	040005b7          	lui	a1,0x4000
    80001aaa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aac:	05b2                	slli	a1,a1,0xc
    80001aae:	8526                	mv	a0,s1
    80001ab0:	f82ff0ef          	jal	80001232 <uvmunmap>
    uvmfree(pagetable, 0);
    80001ab4:	4581                	li	a1,0
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	94fff0ef          	jal	80001406 <uvmfree>
    return 0;
    80001abc:	4481                	li	s1,0
    80001abe:	b7e9                	j	80001a88 <proc_pagetable+0x4c>

0000000080001ac0 <proc_freepagetable>:
{
    80001ac0:	1101                	addi	sp,sp,-32
    80001ac2:	ec06                	sd	ra,24(sp)
    80001ac4:	e822                	sd	s0,16(sp)
    80001ac6:	e426                	sd	s1,8(sp)
    80001ac8:	e04a                	sd	s2,0(sp)
    80001aca:	1000                	addi	s0,sp,32
    80001acc:	84aa                	mv	s1,a0
    80001ace:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ad0:	4681                	li	a3,0
    80001ad2:	4605                	li	a2,1
    80001ad4:	040005b7          	lui	a1,0x4000
    80001ad8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ada:	05b2                	slli	a1,a1,0xc
    80001adc:	f56ff0ef          	jal	80001232 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ae0:	4681                	li	a3,0
    80001ae2:	4605                	li	a2,1
    80001ae4:	020005b7          	lui	a1,0x2000
    80001ae8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aea:	05b6                	slli	a1,a1,0xd
    80001aec:	8526                	mv	a0,s1
    80001aee:	f44ff0ef          	jal	80001232 <uvmunmap>
  uvmfree(pagetable, sz);
    80001af2:	85ca                	mv	a1,s2
    80001af4:	8526                	mv	a0,s1
    80001af6:	911ff0ef          	jal	80001406 <uvmfree>
}
    80001afa:	60e2                	ld	ra,24(sp)
    80001afc:	6442                	ld	s0,16(sp)
    80001afe:	64a2                	ld	s1,8(sp)
    80001b00:	6902                	ld	s2,0(sp)
    80001b02:	6105                	addi	sp,sp,32
    80001b04:	8082                	ret

0000000080001b06 <freeproc>:
{
    80001b06:	1101                	addi	sp,sp,-32
    80001b08:	ec06                	sd	ra,24(sp)
    80001b0a:	e822                	sd	s0,16(sp)
    80001b0c:	e426                	sd	s1,8(sp)
    80001b0e:	1000                	addi	s0,sp,32
    80001b10:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b12:	6d28                	ld	a0,88(a0)
    80001b14:	c119                	beqz	a0,80001b1a <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001b16:	f47fe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001b1a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b1e:	68a8                	ld	a0,80(s1)
    80001b20:	c501                	beqz	a0,80001b28 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001b22:	64ac                	ld	a1,72(s1)
    80001b24:	f9dff0ef          	jal	80001ac0 <proc_freepagetable>
  p->pagetable = 0;
    80001b28:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b2c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b30:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b34:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b38:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b3c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b40:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b44:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b48:	0004ac23          	sw	zero,24(s1)
}
    80001b4c:	60e2                	ld	ra,24(sp)
    80001b4e:	6442                	ld	s0,16(sp)
    80001b50:	64a2                	ld	s1,8(sp)
    80001b52:	6105                	addi	sp,sp,32
    80001b54:	8082                	ret

0000000080001b56 <allocproc>:
{
    80001b56:	1101                	addi	sp,sp,-32
    80001b58:	ec06                	sd	ra,24(sp)
    80001b5a:	e822                	sd	s0,16(sp)
    80001b5c:	e426                	sd	s1,8(sp)
    80001b5e:	e04a                	sd	s2,0(sp)
    80001b60:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b62:	0000f497          	auipc	s1,0xf
    80001b66:	56648493          	addi	s1,s1,1382 # 800110c8 <proc>
    80001b6a:	00015917          	auipc	s2,0x15
    80001b6e:	f5e90913          	addi	s2,s2,-162 # 80016ac8 <tickslock>
    acquire(&p->lock);
    80001b72:	8526                	mv	a0,s1
    80001b74:	8b4ff0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001b78:	4c9c                	lw	a5,24(s1)
    80001b7a:	cb91                	beqz	a5,80001b8e <allocproc+0x38>
      release(&p->lock);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	93eff0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b82:	16848493          	addi	s1,s1,360
    80001b86:	ff2496e3          	bne	s1,s2,80001b72 <allocproc+0x1c>
  return 0;
    80001b8a:	4481                	li	s1,0
    80001b8c:	a089                	j	80001bce <allocproc+0x78>
  p->pid = allocpid();
    80001b8e:	e71ff0ef          	jal	800019fe <allocpid>
    80001b92:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b94:	4785                	li	a5,1
    80001b96:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b98:	fadfe0ef          	jal	80000b44 <kalloc>
    80001b9c:	892a                	mv	s2,a0
    80001b9e:	eca8                	sd	a0,88(s1)
    80001ba0:	cd15                	beqz	a0,80001bdc <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	e99ff0ef          	jal	80001a3c <proc_pagetable>
    80001ba8:	892a                	mv	s2,a0
    80001baa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001bac:	c121                	beqz	a0,80001bec <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001bae:	07000613          	li	a2,112
    80001bb2:	4581                	li	a1,0
    80001bb4:	06048513          	addi	a0,s1,96
    80001bb8:	940ff0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001bbc:	00000797          	auipc	a5,0x0
    80001bc0:	da878793          	addi	a5,a5,-600 # 80001964 <forkret>
    80001bc4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001bc6:	60bc                	ld	a5,64(s1)
    80001bc8:	6705                	lui	a4,0x1
    80001bca:	97ba                	add	a5,a5,a4
    80001bcc:	f4bc                	sd	a5,104(s1)
}
    80001bce:	8526                	mv	a0,s1
    80001bd0:	60e2                	ld	ra,24(sp)
    80001bd2:	6442                	ld	s0,16(sp)
    80001bd4:	64a2                	ld	s1,8(sp)
    80001bd6:	6902                	ld	s2,0(sp)
    80001bd8:	6105                	addi	sp,sp,32
    80001bda:	8082                	ret
    freeproc(p);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	f29ff0ef          	jal	80001b06 <freeproc>
    release(&p->lock);
    80001be2:	8526                	mv	a0,s1
    80001be4:	8d8ff0ef          	jal	80000cbc <release>
    return 0;
    80001be8:	84ca                	mv	s1,s2
    80001bea:	b7d5                	j	80001bce <allocproc+0x78>
    freeproc(p);
    80001bec:	8526                	mv	a0,s1
    80001bee:	f19ff0ef          	jal	80001b06 <freeproc>
    release(&p->lock);
    80001bf2:	8526                	mv	a0,s1
    80001bf4:	8c8ff0ef          	jal	80000cbc <release>
    return 0;
    80001bf8:	84ca                	mv	s1,s2
    80001bfa:	bfd1                	j	80001bce <allocproc+0x78>

0000000080001bfc <userinit>:
{
    80001bfc:	1101                	addi	sp,sp,-32
    80001bfe:	ec06                	sd	ra,24(sp)
    80001c00:	e822                	sd	s0,16(sp)
    80001c02:	e426                	sd	s1,8(sp)
    80001c04:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c06:	f51ff0ef          	jal	80001b56 <allocproc>
    80001c0a:	84aa                	mv	s1,a0
  initproc = p;
    80001c0c:	00007797          	auipc	a5,0x7
    80001c10:	f8a7b223          	sd	a0,-124(a5) # 80008b90 <initproc>
  p->cwd = namei("/");
    80001c14:	00006517          	auipc	a0,0x6
    80001c18:	58c50513          	addi	a0,a0,1420 # 800081a0 <etext+0x1a0>
    80001c1c:	623010ef          	jal	80003a3e <namei>
    80001c20:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001c24:	478d                	li	a5,3
    80001c26:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	892ff0ef          	jal	80000cbc <release>
}
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6105                	addi	sp,sp,32
    80001c36:	8082                	ret

0000000080001c38 <growproc>:
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	e04a                	sd	s2,0(sp)
    80001c42:	1000                	addi	s0,sp,32
    80001c44:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001c46:	cedff0ef          	jal	80001932 <myproc>
    80001c4a:	84aa                	mv	s1,a0
  sz = p->sz;
    80001c4c:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c4e:	01204c63          	bgtz	s2,80001c66 <growproc+0x2e>
  } else if(n < 0){
    80001c52:	02094463          	bltz	s2,80001c7a <growproc+0x42>
  p->sz = sz;
    80001c56:	e4ac                	sd	a1,72(s1)
  return 0;
    80001c58:	4501                	li	a0,0
}
    80001c5a:	60e2                	ld	ra,24(sp)
    80001c5c:	6442                	ld	s0,16(sp)
    80001c5e:	64a2                	ld	s1,8(sp)
    80001c60:	6902                	ld	s2,0(sp)
    80001c62:	6105                	addi	sp,sp,32
    80001c64:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c66:	4691                	li	a3,4
    80001c68:	00b90633          	add	a2,s2,a1
    80001c6c:	6928                	ld	a0,80(a0)
    80001c6e:	e92ff0ef          	jal	80001300 <uvmalloc>
    80001c72:	85aa                	mv	a1,a0
    80001c74:	f16d                	bnez	a0,80001c56 <growproc+0x1e>
      return -1;
    80001c76:	557d                	li	a0,-1
    80001c78:	b7cd                	j	80001c5a <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c7a:	00b90633          	add	a2,s2,a1
    80001c7e:	6928                	ld	a0,80(a0)
    80001c80:	e3cff0ef          	jal	800012bc <uvmdealloc>
    80001c84:	85aa                	mv	a1,a0
    80001c86:	bfc1                	j	80001c56 <growproc+0x1e>

0000000080001c88 <kfork>:
{
    80001c88:	7139                	addi	sp,sp,-64
    80001c8a:	fc06                	sd	ra,56(sp)
    80001c8c:	f822                	sd	s0,48(sp)
    80001c8e:	f426                	sd	s1,40(sp)
    80001c90:	e456                	sd	s5,8(sp)
    80001c92:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c94:	c9fff0ef          	jal	80001932 <myproc>
    80001c98:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c9a:	ebdff0ef          	jal	80001b56 <allocproc>
    80001c9e:	0e050a63          	beqz	a0,80001d92 <kfork+0x10a>
    80001ca2:	e852                	sd	s4,16(sp)
    80001ca4:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ca6:	048ab603          	ld	a2,72(s5)
    80001caa:	692c                	ld	a1,80(a0)
    80001cac:	050ab503          	ld	a0,80(s5)
    80001cb0:	f88ff0ef          	jal	80001438 <uvmcopy>
    80001cb4:	04054863          	bltz	a0,80001d04 <kfork+0x7c>
    80001cb8:	f04a                	sd	s2,32(sp)
    80001cba:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cbc:	048ab783          	ld	a5,72(s5)
    80001cc0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cc4:	058ab683          	ld	a3,88(s5)
    80001cc8:	87b6                	mv	a5,a3
    80001cca:	058a3703          	ld	a4,88(s4)
    80001cce:	12068693          	addi	a3,a3,288
    80001cd2:	6388                	ld	a0,0(a5)
    80001cd4:	678c                	ld	a1,8(a5)
    80001cd6:	6b90                	ld	a2,16(a5)
    80001cd8:	e308                	sd	a0,0(a4)
    80001cda:	e70c                	sd	a1,8(a4)
    80001cdc:	eb10                	sd	a2,16(a4)
    80001cde:	6f90                	ld	a2,24(a5)
    80001ce0:	ef10                	sd	a2,24(a4)
    80001ce2:	02078793          	addi	a5,a5,32
    80001ce6:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001cea:	fed794e3          	bne	a5,a3,80001cd2 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001cee:	058a3783          	ld	a5,88(s4)
    80001cf2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001cf6:	0d0a8493          	addi	s1,s5,208
    80001cfa:	0d0a0913          	addi	s2,s4,208
    80001cfe:	150a8993          	addi	s3,s5,336
    80001d02:	a831                	j	80001d1e <kfork+0x96>
    freeproc(np);
    80001d04:	8552                	mv	a0,s4
    80001d06:	e01ff0ef          	jal	80001b06 <freeproc>
    release(&np->lock);
    80001d0a:	8552                	mv	a0,s4
    80001d0c:	fb1fe0ef          	jal	80000cbc <release>
    return -1;
    80001d10:	54fd                	li	s1,-1
    80001d12:	6a42                	ld	s4,16(sp)
    80001d14:	a885                	j	80001d84 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001d16:	04a1                	addi	s1,s1,8
    80001d18:	0921                	addi	s2,s2,8
    80001d1a:	01348963          	beq	s1,s3,80001d2c <kfork+0xa4>
    if(p->ofile[i])
    80001d1e:	6088                	ld	a0,0(s1)
    80001d20:	d97d                	beqz	a0,80001d16 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d22:	21d020ef          	jal	8000473e <filedup>
    80001d26:	00a93023          	sd	a0,0(s2)
    80001d2a:	b7f5                	j	80001d16 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001d2c:	150ab503          	ld	a0,336(s5)
    80001d30:	4aa010ef          	jal	800031da <idup>
    80001d34:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d38:	4641                	li	a2,16
    80001d3a:	158a8593          	addi	a1,s5,344
    80001d3e:	158a0513          	addi	a0,s4,344
    80001d42:	90aff0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001d46:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001d4a:	8552                	mv	a0,s4
    80001d4c:	f71fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001d50:	0000f517          	auipc	a0,0xf
    80001d54:	f6050513          	addi	a0,a0,-160 # 80010cb0 <wait_lock>
    80001d58:	ed1fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80001d5c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001d60:	0000f517          	auipc	a0,0xf
    80001d64:	f5050513          	addi	a0,a0,-176 # 80010cb0 <wait_lock>
    80001d68:	f55fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001d6c:	8552                	mv	a0,s4
    80001d6e:	ebbfe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80001d72:	478d                	li	a5,3
    80001d74:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d78:	8552                	mv	a0,s4
    80001d7a:	f43fe0ef          	jal	80000cbc <release>
  return pid;
    80001d7e:	7902                	ld	s2,32(sp)
    80001d80:	69e2                	ld	s3,24(sp)
    80001d82:	6a42                	ld	s4,16(sp)
}
    80001d84:	8526                	mv	a0,s1
    80001d86:	70e2                	ld	ra,56(sp)
    80001d88:	7442                	ld	s0,48(sp)
    80001d8a:	74a2                	ld	s1,40(sp)
    80001d8c:	6aa2                	ld	s5,8(sp)
    80001d8e:	6121                	addi	sp,sp,64
    80001d90:	8082                	ret
    return -1;
    80001d92:	54fd                	li	s1,-1
    80001d94:	bfc5                	j	80001d84 <kfork+0xfc>

0000000080001d96 <scheduler>:
{
    80001d96:	715d                	addi	sp,sp,-80
    80001d98:	e486                	sd	ra,72(sp)
    80001d9a:	e0a2                	sd	s0,64(sp)
    80001d9c:	fc26                	sd	s1,56(sp)
    80001d9e:	f84a                	sd	s2,48(sp)
    80001da0:	f44e                	sd	s3,40(sp)
    80001da2:	f052                	sd	s4,32(sp)
    80001da4:	ec56                	sd	s5,24(sp)
    80001da6:	e85a                	sd	s6,16(sp)
    80001da8:	e45e                	sd	s7,8(sp)
    80001daa:	e062                	sd	s8,0(sp)
    80001dac:	0880                	addi	s0,sp,80
    80001dae:	8792                	mv	a5,tp
  int id = r_tp();
    80001db0:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001db2:	00779b13          	slli	s6,a5,0x7
    80001db6:	0000f717          	auipc	a4,0xf
    80001dba:	ee270713          	addi	a4,a4,-286 # 80010c98 <pid_lock>
    80001dbe:	975a                	add	a4,a4,s6
    80001dc0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001dc4:	0000f717          	auipc	a4,0xf
    80001dc8:	f0c70713          	addi	a4,a4,-244 # 80010cd0 <cpus+0x8>
    80001dcc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001dce:	4c11                	li	s8,4
        c->proc = p;
    80001dd0:	079e                	slli	a5,a5,0x7
    80001dd2:	0000fa17          	auipc	s4,0xf
    80001dd6:	ec6a0a13          	addi	s4,s4,-314 # 80010c98 <pid_lock>
    80001dda:	9a3e                	add	s4,s4,a5
        found = 1;
    80001ddc:	4b85                	li	s7,1
    80001dde:	a83d                	j	80001e1c <scheduler+0x86>
      release(&p->lock);
    80001de0:	8526                	mv	a0,s1
    80001de2:	edbfe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001de6:	16848493          	addi	s1,s1,360
    80001dea:	03248563          	beq	s1,s2,80001e14 <scheduler+0x7e>
      acquire(&p->lock);
    80001dee:	8526                	mv	a0,s1
    80001df0:	e39fe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    80001df4:	4c9c                	lw	a5,24(s1)
    80001df6:	ff3795e3          	bne	a5,s3,80001de0 <scheduler+0x4a>
        p->state = RUNNING;
    80001dfa:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dfe:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001e02:	06048593          	addi	a1,s1,96
    80001e06:	855a                	mv	a0,s6
    80001e08:	5ba000ef          	jal	800023c2 <swtch>
        c->proc = 0;
    80001e0c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e10:	8ade                	mv	s5,s7
    80001e12:	b7f9                	j	80001de0 <scheduler+0x4a>
    if(found == 0) {
    80001e14:	000a9463          	bnez	s5,80001e1c <scheduler+0x86>
      asm volatile("wfi");
    80001e18:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e20:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e24:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e28:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e32:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e34:	0000f497          	auipc	s1,0xf
    80001e38:	29448493          	addi	s1,s1,660 # 800110c8 <proc>
      if(p->state == RUNNABLE) {
    80001e3c:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e3e:	00015917          	auipc	s2,0x15
    80001e42:	c8a90913          	addi	s2,s2,-886 # 80016ac8 <tickslock>
    80001e46:	b765                	j	80001dee <scheduler+0x58>

0000000080001e48 <sched>:
{
    80001e48:	7179                	addi	sp,sp,-48
    80001e4a:	f406                	sd	ra,40(sp)
    80001e4c:	f022                	sd	s0,32(sp)
    80001e4e:	ec26                	sd	s1,24(sp)
    80001e50:	e84a                	sd	s2,16(sp)
    80001e52:	e44e                	sd	s3,8(sp)
    80001e54:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e56:	addff0ef          	jal	80001932 <myproc>
    80001e5a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e5c:	d5dfe0ef          	jal	80000bb8 <holding>
    80001e60:	c935                	beqz	a0,80001ed4 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e62:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e64:	2781                	sext.w	a5,a5
    80001e66:	079e                	slli	a5,a5,0x7
    80001e68:	0000f717          	auipc	a4,0xf
    80001e6c:	e3070713          	addi	a4,a4,-464 # 80010c98 <pid_lock>
    80001e70:	97ba                	add	a5,a5,a4
    80001e72:	0a87a703          	lw	a4,168(a5)
    80001e76:	4785                	li	a5,1
    80001e78:	06f71463          	bne	a4,a5,80001ee0 <sched+0x98>
  if(p->state == RUNNING)
    80001e7c:	4c98                	lw	a4,24(s1)
    80001e7e:	4791                	li	a5,4
    80001e80:	06f70663          	beq	a4,a5,80001eec <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e84:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e88:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e8a:	e7bd                	bnez	a5,80001ef8 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e8c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e8e:	0000f917          	auipc	s2,0xf
    80001e92:	e0a90913          	addi	s2,s2,-502 # 80010c98 <pid_lock>
    80001e96:	2781                	sext.w	a5,a5
    80001e98:	079e                	slli	a5,a5,0x7
    80001e9a:	97ca                	add	a5,a5,s2
    80001e9c:	0ac7a983          	lw	s3,172(a5)
    80001ea0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001ea2:	2781                	sext.w	a5,a5
    80001ea4:	079e                	slli	a5,a5,0x7
    80001ea6:	07a1                	addi	a5,a5,8
    80001ea8:	0000f597          	auipc	a1,0xf
    80001eac:	e2058593          	addi	a1,a1,-480 # 80010cc8 <cpus>
    80001eb0:	95be                	add	a1,a1,a5
    80001eb2:	06048513          	addi	a0,s1,96
    80001eb6:	50c000ef          	jal	800023c2 <swtch>
    80001eba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ebc:	2781                	sext.w	a5,a5
    80001ebe:	079e                	slli	a5,a5,0x7
    80001ec0:	993e                	add	s2,s2,a5
    80001ec2:	0b392623          	sw	s3,172(s2)
}
    80001ec6:	70a2                	ld	ra,40(sp)
    80001ec8:	7402                	ld	s0,32(sp)
    80001eca:	64e2                	ld	s1,24(sp)
    80001ecc:	6942                	ld	s2,16(sp)
    80001ece:	69a2                	ld	s3,8(sp)
    80001ed0:	6145                	addi	sp,sp,48
    80001ed2:	8082                	ret
    panic("sched p->lock");
    80001ed4:	00006517          	auipc	a0,0x6
    80001ed8:	2d450513          	addi	a0,a0,724 # 800081a8 <etext+0x1a8>
    80001edc:	949fe0ef          	jal	80000824 <panic>
    panic("sched locks");
    80001ee0:	00006517          	auipc	a0,0x6
    80001ee4:	2d850513          	addi	a0,a0,728 # 800081b8 <etext+0x1b8>
    80001ee8:	93dfe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    80001eec:	00006517          	auipc	a0,0x6
    80001ef0:	2dc50513          	addi	a0,a0,732 # 800081c8 <etext+0x1c8>
    80001ef4:	931fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    80001ef8:	00006517          	auipc	a0,0x6
    80001efc:	2e050513          	addi	a0,a0,736 # 800081d8 <etext+0x1d8>
    80001f00:	925fe0ef          	jal	80000824 <panic>

0000000080001f04 <yield>:
{
    80001f04:	1101                	addi	sp,sp,-32
    80001f06:	ec06                	sd	ra,24(sp)
    80001f08:	e822                	sd	s0,16(sp)
    80001f0a:	e426                	sd	s1,8(sp)
    80001f0c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f0e:	a25ff0ef          	jal	80001932 <myproc>
    80001f12:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f14:	d15fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    80001f18:	478d                	li	a5,3
    80001f1a:	cc9c                	sw	a5,24(s1)
  sched();
    80001f1c:	f2dff0ef          	jal	80001e48 <sched>
  release(&p->lock);
    80001f20:	8526                	mv	a0,s1
    80001f22:	d9bfe0ef          	jal	80000cbc <release>
}
    80001f26:	60e2                	ld	ra,24(sp)
    80001f28:	6442                	ld	s0,16(sp)
    80001f2a:	64a2                	ld	s1,8(sp)
    80001f2c:	6105                	addi	sp,sp,32
    80001f2e:	8082                	ret

0000000080001f30 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f30:	7179                	addi	sp,sp,-48
    80001f32:	f406                	sd	ra,40(sp)
    80001f34:	f022                	sd	s0,32(sp)
    80001f36:	ec26                	sd	s1,24(sp)
    80001f38:	e84a                	sd	s2,16(sp)
    80001f3a:	e44e                	sd	s3,8(sp)
    80001f3c:	1800                	addi	s0,sp,48
    80001f3e:	89aa                	mv	s3,a0
    80001f40:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f42:	9f1ff0ef          	jal	80001932 <myproc>
    80001f46:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f48:	ce1fe0ef          	jal	80000c28 <acquire>
  release(lk);
    80001f4c:	854a                	mv	a0,s2
    80001f4e:	d6ffe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    80001f52:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f56:	4789                	li	a5,2
    80001f58:	cc9c                	sw	a5,24(s1)

  sched();
    80001f5a:	eefff0ef          	jal	80001e48 <sched>

  // Tidy up.
  p->chan = 0;
    80001f5e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f62:	8526                	mv	a0,s1
    80001f64:	d59fe0ef          	jal	80000cbc <release>
  acquire(lk);
    80001f68:	854a                	mv	a0,s2
    80001f6a:	cbffe0ef          	jal	80000c28 <acquire>
}
    80001f6e:	70a2                	ld	ra,40(sp)
    80001f70:	7402                	ld	s0,32(sp)
    80001f72:	64e2                	ld	s1,24(sp)
    80001f74:	6942                	ld	s2,16(sp)
    80001f76:	69a2                	ld	s3,8(sp)
    80001f78:	6145                	addi	sp,sp,48
    80001f7a:	8082                	ret

0000000080001f7c <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f7c:	7139                	addi	sp,sp,-64
    80001f7e:	fc06                	sd	ra,56(sp)
    80001f80:	f822                	sd	s0,48(sp)
    80001f82:	f426                	sd	s1,40(sp)
    80001f84:	f04a                	sd	s2,32(sp)
    80001f86:	ec4e                	sd	s3,24(sp)
    80001f88:	e852                	sd	s4,16(sp)
    80001f8a:	e456                	sd	s5,8(sp)
    80001f8c:	0080                	addi	s0,sp,64
    80001f8e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f90:	0000f497          	auipc	s1,0xf
    80001f94:	13848493          	addi	s1,s1,312 # 800110c8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001f98:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f9a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f9c:	00015917          	auipc	s2,0x15
    80001fa0:	b2c90913          	addi	s2,s2,-1236 # 80016ac8 <tickslock>
    80001fa4:	a801                	j	80001fb4 <wakeup+0x38>
      }
      release(&p->lock);
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	d15fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fac:	16848493          	addi	s1,s1,360
    80001fb0:	03248263          	beq	s1,s2,80001fd4 <wakeup+0x58>
    if(p != myproc()){
    80001fb4:	97fff0ef          	jal	80001932 <myproc>
    80001fb8:	fe950ae3          	beq	a0,s1,80001fac <wakeup+0x30>
      acquire(&p->lock);
    80001fbc:	8526                	mv	a0,s1
    80001fbe:	c6bfe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001fc2:	4c9c                	lw	a5,24(s1)
    80001fc4:	ff3791e3          	bne	a5,s3,80001fa6 <wakeup+0x2a>
    80001fc8:	709c                	ld	a5,32(s1)
    80001fca:	fd479ee3          	bne	a5,s4,80001fa6 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fce:	0154ac23          	sw	s5,24(s1)
    80001fd2:	bfd1                	j	80001fa6 <wakeup+0x2a>
    }
  }
}
    80001fd4:	70e2                	ld	ra,56(sp)
    80001fd6:	7442                	ld	s0,48(sp)
    80001fd8:	74a2                	ld	s1,40(sp)
    80001fda:	7902                	ld	s2,32(sp)
    80001fdc:	69e2                	ld	s3,24(sp)
    80001fde:	6a42                	ld	s4,16(sp)
    80001fe0:	6aa2                	ld	s5,8(sp)
    80001fe2:	6121                	addi	sp,sp,64
    80001fe4:	8082                	ret

0000000080001fe6 <reparent>:
{
    80001fe6:	7179                	addi	sp,sp,-48
    80001fe8:	f406                	sd	ra,40(sp)
    80001fea:	f022                	sd	s0,32(sp)
    80001fec:	ec26                	sd	s1,24(sp)
    80001fee:	e84a                	sd	s2,16(sp)
    80001ff0:	e44e                	sd	s3,8(sp)
    80001ff2:	e052                	sd	s4,0(sp)
    80001ff4:	1800                	addi	s0,sp,48
    80001ff6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ff8:	0000f497          	auipc	s1,0xf
    80001ffc:	0d048493          	addi	s1,s1,208 # 800110c8 <proc>
      pp->parent = initproc;
    80002000:	00007a17          	auipc	s4,0x7
    80002004:	b90a0a13          	addi	s4,s4,-1136 # 80008b90 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002008:	00015997          	auipc	s3,0x15
    8000200c:	ac098993          	addi	s3,s3,-1344 # 80016ac8 <tickslock>
    80002010:	a029                	j	8000201a <reparent+0x34>
    80002012:	16848493          	addi	s1,s1,360
    80002016:	01348b63          	beq	s1,s3,8000202c <reparent+0x46>
    if(pp->parent == p){
    8000201a:	7c9c                	ld	a5,56(s1)
    8000201c:	ff279be3          	bne	a5,s2,80002012 <reparent+0x2c>
      pp->parent = initproc;
    80002020:	000a3503          	ld	a0,0(s4)
    80002024:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002026:	f57ff0ef          	jal	80001f7c <wakeup>
    8000202a:	b7e5                	j	80002012 <reparent+0x2c>
}
    8000202c:	70a2                	ld	ra,40(sp)
    8000202e:	7402                	ld	s0,32(sp)
    80002030:	64e2                	ld	s1,24(sp)
    80002032:	6942                	ld	s2,16(sp)
    80002034:	69a2                	ld	s3,8(sp)
    80002036:	6a02                	ld	s4,0(sp)
    80002038:	6145                	addi	sp,sp,48
    8000203a:	8082                	ret

000000008000203c <kexit>:
{
    8000203c:	7179                	addi	sp,sp,-48
    8000203e:	f406                	sd	ra,40(sp)
    80002040:	f022                	sd	s0,32(sp)
    80002042:	ec26                	sd	s1,24(sp)
    80002044:	e84a                	sd	s2,16(sp)
    80002046:	e44e                	sd	s3,8(sp)
    80002048:	e052                	sd	s4,0(sp)
    8000204a:	1800                	addi	s0,sp,48
    8000204c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000204e:	8e5ff0ef          	jal	80001932 <myproc>
    80002052:	89aa                	mv	s3,a0
  if(p == initproc)
    80002054:	00007797          	auipc	a5,0x7
    80002058:	b3c7b783          	ld	a5,-1220(a5) # 80008b90 <initproc>
    8000205c:	0d050493          	addi	s1,a0,208
    80002060:	15050913          	addi	s2,a0,336
    80002064:	00a79b63          	bne	a5,a0,8000207a <kexit+0x3e>
    panic("init exiting");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	18850513          	addi	a0,a0,392 # 800081f0 <etext+0x1f0>
    80002070:	fb4fe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002074:	04a1                	addi	s1,s1,8
    80002076:	01248963          	beq	s1,s2,80002088 <kexit+0x4c>
    if(p->ofile[fd]){
    8000207a:	6088                	ld	a0,0(s1)
    8000207c:	dd65                	beqz	a0,80002074 <kexit+0x38>
      fileclose(f);
    8000207e:	706020ef          	jal	80004784 <fileclose>
      p->ofile[fd] = 0;
    80002082:	0004b023          	sd	zero,0(s1)
    80002086:	b7fd                	j	80002074 <kexit+0x38>
  begin_op();
    80002088:	395010ef          	jal	80003c1c <begin_op>
  iput(p->cwd);
    8000208c:	1509b503          	ld	a0,336(s3)
    80002090:	302010ef          	jal	80003392 <iput>
  end_op();
    80002094:	3f9010ef          	jal	80003c8c <end_op>
  p->cwd = 0;
    80002098:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000209c:	0000f517          	auipc	a0,0xf
    800020a0:	c1450513          	addi	a0,a0,-1004 # 80010cb0 <wait_lock>
    800020a4:	b85fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800020a8:	854e                	mv	a0,s3
    800020aa:	f3dff0ef          	jal	80001fe6 <reparent>
  wakeup(p->parent);
    800020ae:	0389b503          	ld	a0,56(s3)
    800020b2:	ecbff0ef          	jal	80001f7c <wakeup>
  acquire(&p->lock);
    800020b6:	854e                	mv	a0,s3
    800020b8:	b71fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800020bc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020c0:	4795                	li	a5,5
    800020c2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020c6:	0000f517          	auipc	a0,0xf
    800020ca:	bea50513          	addi	a0,a0,-1046 # 80010cb0 <wait_lock>
    800020ce:	beffe0ef          	jal	80000cbc <release>
  sched();
    800020d2:	d77ff0ef          	jal	80001e48 <sched>
  panic("zombie exit");
    800020d6:	00006517          	auipc	a0,0x6
    800020da:	12a50513          	addi	a0,a0,298 # 80008200 <etext+0x200>
    800020de:	f46fe0ef          	jal	80000824 <panic>

00000000800020e2 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	e84a                	sd	s2,16(sp)
    800020ec:	e44e                	sd	s3,8(sp)
    800020ee:	1800                	addi	s0,sp,48
    800020f0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020f2:	0000f497          	auipc	s1,0xf
    800020f6:	fd648493          	addi	s1,s1,-42 # 800110c8 <proc>
    800020fa:	00015997          	auipc	s3,0x15
    800020fe:	9ce98993          	addi	s3,s3,-1586 # 80016ac8 <tickslock>
    acquire(&p->lock);
    80002102:	8526                	mv	a0,s1
    80002104:	b25fe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    80002108:	589c                	lw	a5,48(s1)
    8000210a:	01278b63          	beq	a5,s2,80002120 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000210e:	8526                	mv	a0,s1
    80002110:	badfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002114:	16848493          	addi	s1,s1,360
    80002118:	ff3495e3          	bne	s1,s3,80002102 <kkill+0x20>
  }
  return -1;
    8000211c:	557d                	li	a0,-1
    8000211e:	a819                	j	80002134 <kkill+0x52>
      p->killed = 1;
    80002120:	4785                	li	a5,1
    80002122:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002124:	4c98                	lw	a4,24(s1)
    80002126:	4789                	li	a5,2
    80002128:	00f70d63          	beq	a4,a5,80002142 <kkill+0x60>
      release(&p->lock);
    8000212c:	8526                	mv	a0,s1
    8000212e:	b8ffe0ef          	jal	80000cbc <release>
      return 0;
    80002132:	4501                	li	a0,0
}
    80002134:	70a2                	ld	ra,40(sp)
    80002136:	7402                	ld	s0,32(sp)
    80002138:	64e2                	ld	s1,24(sp)
    8000213a:	6942                	ld	s2,16(sp)
    8000213c:	69a2                	ld	s3,8(sp)
    8000213e:	6145                	addi	sp,sp,48
    80002140:	8082                	ret
        p->state = RUNNABLE;
    80002142:	478d                	li	a5,3
    80002144:	cc9c                	sw	a5,24(s1)
    80002146:	b7dd                	j	8000212c <kkill+0x4a>

0000000080002148 <setkilled>:

void
setkilled(struct proc *p)
{
    80002148:	1101                	addi	sp,sp,-32
    8000214a:	ec06                	sd	ra,24(sp)
    8000214c:	e822                	sd	s0,16(sp)
    8000214e:	e426                	sd	s1,8(sp)
    80002150:	1000                	addi	s0,sp,32
    80002152:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002154:	ad5fe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002158:	4785                	li	a5,1
    8000215a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000215c:	8526                	mv	a0,s1
    8000215e:	b5ffe0ef          	jal	80000cbc <release>
}
    80002162:	60e2                	ld	ra,24(sp)
    80002164:	6442                	ld	s0,16(sp)
    80002166:	64a2                	ld	s1,8(sp)
    80002168:	6105                	addi	sp,sp,32
    8000216a:	8082                	ret

000000008000216c <killed>:

int
killed(struct proc *p)
{
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	e426                	sd	s1,8(sp)
    80002174:	e04a                	sd	s2,0(sp)
    80002176:	1000                	addi	s0,sp,32
    80002178:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000217a:	aaffe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    8000217e:	549c                	lw	a5,40(s1)
    80002180:	893e                	mv	s2,a5
  release(&p->lock);
    80002182:	8526                	mv	a0,s1
    80002184:	b39fe0ef          	jal	80000cbc <release>
  return k;
}
    80002188:	854a                	mv	a0,s2
    8000218a:	60e2                	ld	ra,24(sp)
    8000218c:	6442                	ld	s0,16(sp)
    8000218e:	64a2                	ld	s1,8(sp)
    80002190:	6902                	ld	s2,0(sp)
    80002192:	6105                	addi	sp,sp,32
    80002194:	8082                	ret

0000000080002196 <kwait>:
{
    80002196:	715d                	addi	sp,sp,-80
    80002198:	e486                	sd	ra,72(sp)
    8000219a:	e0a2                	sd	s0,64(sp)
    8000219c:	fc26                	sd	s1,56(sp)
    8000219e:	f84a                	sd	s2,48(sp)
    800021a0:	f44e                	sd	s3,40(sp)
    800021a2:	f052                	sd	s4,32(sp)
    800021a4:	ec56                	sd	s5,24(sp)
    800021a6:	e85a                	sd	s6,16(sp)
    800021a8:	e45e                	sd	s7,8(sp)
    800021aa:	0880                	addi	s0,sp,80
    800021ac:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021ae:	f84ff0ef          	jal	80001932 <myproc>
    800021b2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021b4:	0000f517          	auipc	a0,0xf
    800021b8:	afc50513          	addi	a0,a0,-1284 # 80010cb0 <wait_lock>
    800021bc:	a6dfe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800021c0:	4a15                	li	s4,5
        havekids = 1;
    800021c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021c4:	00015997          	auipc	s3,0x15
    800021c8:	90498993          	addi	s3,s3,-1788 # 80016ac8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021cc:	0000fb17          	auipc	s6,0xf
    800021d0:	ae4b0b13          	addi	s6,s6,-1308 # 80010cb0 <wait_lock>
    800021d4:	a869                	j	8000226e <kwait+0xd8>
          pid = pp->pid;
    800021d6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021da:	000b8c63          	beqz	s7,800021f2 <kwait+0x5c>
    800021de:	4691                	li	a3,4
    800021e0:	02c48613          	addi	a2,s1,44
    800021e4:	85de                	mv	a1,s7
    800021e6:	05093503          	ld	a0,80(s2)
    800021ea:	c6eff0ef          	jal	80001658 <copyout>
    800021ee:	02054a63          	bltz	a0,80002222 <kwait+0x8c>
          freeproc(pp);
    800021f2:	8526                	mv	a0,s1
    800021f4:	913ff0ef          	jal	80001b06 <freeproc>
          release(&pp->lock);
    800021f8:	8526                	mv	a0,s1
    800021fa:	ac3fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    800021fe:	0000f517          	auipc	a0,0xf
    80002202:	ab250513          	addi	a0,a0,-1358 # 80010cb0 <wait_lock>
    80002206:	ab7fe0ef          	jal	80000cbc <release>
}
    8000220a:	854e                	mv	a0,s3
    8000220c:	60a6                	ld	ra,72(sp)
    8000220e:	6406                	ld	s0,64(sp)
    80002210:	74e2                	ld	s1,56(sp)
    80002212:	7942                	ld	s2,48(sp)
    80002214:	79a2                	ld	s3,40(sp)
    80002216:	7a02                	ld	s4,32(sp)
    80002218:	6ae2                	ld	s5,24(sp)
    8000221a:	6b42                	ld	s6,16(sp)
    8000221c:	6ba2                	ld	s7,8(sp)
    8000221e:	6161                	addi	sp,sp,80
    80002220:	8082                	ret
            release(&pp->lock);
    80002222:	8526                	mv	a0,s1
    80002224:	a99fe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002228:	0000f517          	auipc	a0,0xf
    8000222c:	a8850513          	addi	a0,a0,-1400 # 80010cb0 <wait_lock>
    80002230:	a8dfe0ef          	jal	80000cbc <release>
            return -1;
    80002234:	59fd                	li	s3,-1
    80002236:	bfd1                	j	8000220a <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002238:	16848493          	addi	s1,s1,360
    8000223c:	03348063          	beq	s1,s3,8000225c <kwait+0xc6>
      if(pp->parent == p){
    80002240:	7c9c                	ld	a5,56(s1)
    80002242:	ff279be3          	bne	a5,s2,80002238 <kwait+0xa2>
        acquire(&pp->lock);
    80002246:	8526                	mv	a0,s1
    80002248:	9e1fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    8000224c:	4c9c                	lw	a5,24(s1)
    8000224e:	f94784e3          	beq	a5,s4,800021d6 <kwait+0x40>
        release(&pp->lock);
    80002252:	8526                	mv	a0,s1
    80002254:	a69fe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002258:	8756                	mv	a4,s5
    8000225a:	bff9                	j	80002238 <kwait+0xa2>
    if(!havekids || killed(p)){
    8000225c:	cf19                	beqz	a4,8000227a <kwait+0xe4>
    8000225e:	854a                	mv	a0,s2
    80002260:	f0dff0ef          	jal	8000216c <killed>
    80002264:	e919                	bnez	a0,8000227a <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002266:	85da                	mv	a1,s6
    80002268:	854a                	mv	a0,s2
    8000226a:	cc7ff0ef          	jal	80001f30 <sleep>
    havekids = 0;
    8000226e:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002270:	0000f497          	auipc	s1,0xf
    80002274:	e5848493          	addi	s1,s1,-424 # 800110c8 <proc>
    80002278:	b7e1                	j	80002240 <kwait+0xaa>
      release(&wait_lock);
    8000227a:	0000f517          	auipc	a0,0xf
    8000227e:	a3650513          	addi	a0,a0,-1482 # 80010cb0 <wait_lock>
    80002282:	a3bfe0ef          	jal	80000cbc <release>
      return -1;
    80002286:	59fd                	li	s3,-1
    80002288:	b749                	j	8000220a <kwait+0x74>

000000008000228a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000228a:	7179                	addi	sp,sp,-48
    8000228c:	f406                	sd	ra,40(sp)
    8000228e:	f022                	sd	s0,32(sp)
    80002290:	ec26                	sd	s1,24(sp)
    80002292:	e84a                	sd	s2,16(sp)
    80002294:	e44e                	sd	s3,8(sp)
    80002296:	e052                	sd	s4,0(sp)
    80002298:	1800                	addi	s0,sp,48
    8000229a:	84aa                	mv	s1,a0
    8000229c:	8a2e                	mv	s4,a1
    8000229e:	89b2                	mv	s3,a2
    800022a0:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022a2:	e90ff0ef          	jal	80001932 <myproc>
  if(user_dst){
    800022a6:	cc99                	beqz	s1,800022c4 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800022a8:	86ca                	mv	a3,s2
    800022aa:	864e                	mv	a2,s3
    800022ac:	85d2                	mv	a1,s4
    800022ae:	6928                	ld	a0,80(a0)
    800022b0:	ba8ff0ef          	jal	80001658 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022b4:	70a2                	ld	ra,40(sp)
    800022b6:	7402                	ld	s0,32(sp)
    800022b8:	64e2                	ld	s1,24(sp)
    800022ba:	6942                	ld	s2,16(sp)
    800022bc:	69a2                	ld	s3,8(sp)
    800022be:	6a02                	ld	s4,0(sp)
    800022c0:	6145                	addi	sp,sp,48
    800022c2:	8082                	ret
    memmove((char *)dst, src, len);
    800022c4:	0009061b          	sext.w	a2,s2
    800022c8:	85ce                	mv	a1,s3
    800022ca:	8552                	mv	a0,s4
    800022cc:	a8dfe0ef          	jal	80000d58 <memmove>
    return 0;
    800022d0:	8526                	mv	a0,s1
    800022d2:	b7cd                	j	800022b4 <either_copyout+0x2a>

00000000800022d4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022d4:	7179                	addi	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	e052                	sd	s4,0(sp)
    800022e2:	1800                	addi	s0,sp,48
    800022e4:	8a2a                	mv	s4,a0
    800022e6:	84ae                	mv	s1,a1
    800022e8:	89b2                	mv	s3,a2
    800022ea:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022ec:	e46ff0ef          	jal	80001932 <myproc>
  if(user_src){
    800022f0:	cc99                	beqz	s1,8000230e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022f2:	86ca                	mv	a3,s2
    800022f4:	864e                	mv	a2,s3
    800022f6:	85d2                	mv	a1,s4
    800022f8:	6928                	ld	a0,80(a0)
    800022fa:	c1cff0ef          	jal	80001716 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022fe:	70a2                	ld	ra,40(sp)
    80002300:	7402                	ld	s0,32(sp)
    80002302:	64e2                	ld	s1,24(sp)
    80002304:	6942                	ld	s2,16(sp)
    80002306:	69a2                	ld	s3,8(sp)
    80002308:	6a02                	ld	s4,0(sp)
    8000230a:	6145                	addi	sp,sp,48
    8000230c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000230e:	0009061b          	sext.w	a2,s2
    80002312:	85ce                	mv	a1,s3
    80002314:	8552                	mv	a0,s4
    80002316:	a43fe0ef          	jal	80000d58 <memmove>
    return 0;
    8000231a:	8526                	mv	a0,s1
    8000231c:	b7cd                	j	800022fe <either_copyin+0x2a>

000000008000231e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000231e:	715d                	addi	sp,sp,-80
    80002320:	e486                	sd	ra,72(sp)
    80002322:	e0a2                	sd	s0,64(sp)
    80002324:	fc26                	sd	s1,56(sp)
    80002326:	f84a                	sd	s2,48(sp)
    80002328:	f44e                	sd	s3,40(sp)
    8000232a:	f052                	sd	s4,32(sp)
    8000232c:	ec56                	sd	s5,24(sp)
    8000232e:	e85a                	sd	s6,16(sp)
    80002330:	e45e                	sd	s7,8(sp)
    80002332:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002334:	00006517          	auipc	a0,0x6
    80002338:	d5450513          	addi	a0,a0,-684 # 80008088 <etext+0x88>
    8000233c:	9befe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002340:	0000f497          	auipc	s1,0xf
    80002344:	ee048493          	addi	s1,s1,-288 # 80011220 <proc+0x158>
    80002348:	00015917          	auipc	s2,0x15
    8000234c:	8d890913          	addi	s2,s2,-1832 # 80016c20 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002350:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002352:	00006997          	auipc	s3,0x6
    80002356:	ebe98993          	addi	s3,s3,-322 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    8000235a:	00006a97          	auipc	s5,0x6
    8000235e:	ebea8a93          	addi	s5,s5,-322 # 80008218 <etext+0x218>
    printf("\n");
    80002362:	00006a17          	auipc	s4,0x6
    80002366:	d26a0a13          	addi	s4,s4,-730 # 80008088 <etext+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000236a:	00006b97          	auipc	s7,0x6
    8000236e:	6f6b8b93          	addi	s7,s7,1782 # 80008a60 <states.0>
    80002372:	a829                	j	8000238c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002374:	ed86a583          	lw	a1,-296(a3)
    80002378:	8556                	mv	a0,s5
    8000237a:	980fe0ef          	jal	800004fa <printf>
    printf("\n");
    8000237e:	8552                	mv	a0,s4
    80002380:	97afe0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002384:	16848493          	addi	s1,s1,360
    80002388:	03248263          	beq	s1,s2,800023ac <procdump+0x8e>
    if(p->state == UNUSED)
    8000238c:	86a6                	mv	a3,s1
    8000238e:	ec04a783          	lw	a5,-320(s1)
    80002392:	dbed                	beqz	a5,80002384 <procdump+0x66>
      state = "???";
    80002394:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002396:	fcfb6fe3          	bltu	s6,a5,80002374 <procdump+0x56>
    8000239a:	02079713          	slli	a4,a5,0x20
    8000239e:	01d75793          	srli	a5,a4,0x1d
    800023a2:	97de                	add	a5,a5,s7
    800023a4:	6390                	ld	a2,0(a5)
    800023a6:	f679                	bnez	a2,80002374 <procdump+0x56>
      state = "???";
    800023a8:	864e                	mv	a2,s3
    800023aa:	b7e9                	j	80002374 <procdump+0x56>
  }
}
    800023ac:	60a6                	ld	ra,72(sp)
    800023ae:	6406                	ld	s0,64(sp)
    800023b0:	74e2                	ld	s1,56(sp)
    800023b2:	7942                	ld	s2,48(sp)
    800023b4:	79a2                	ld	s3,40(sp)
    800023b6:	7a02                	ld	s4,32(sp)
    800023b8:	6ae2                	ld	s5,24(sp)
    800023ba:	6b42                	ld	s6,16(sp)
    800023bc:	6ba2                	ld	s7,8(sp)
    800023be:	6161                	addi	sp,sp,80
    800023c0:	8082                	ret

00000000800023c2 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023c2:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023c6:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023ca:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023cc:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023ce:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023d2:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023d6:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023da:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023de:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023e2:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023e6:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800023ea:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800023ee:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800023f2:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800023f6:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800023fa:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023fe:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002400:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002402:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002406:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000240a:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000240e:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002412:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002416:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000241a:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000241e:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002422:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002426:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000242a:	8082                	ret

000000008000242c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000242c:	1141                	addi	sp,sp,-16
    8000242e:	e406                	sd	ra,8(sp)
    80002430:	e022                	sd	s0,0(sp)
    80002432:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002434:	00006597          	auipc	a1,0x6
    80002438:	e2458593          	addi	a1,a1,-476 # 80008258 <etext+0x258>
    8000243c:	00014517          	auipc	a0,0x14
    80002440:	68c50513          	addi	a0,a0,1676 # 80016ac8 <tickslock>
    80002444:	f5afe0ef          	jal	80000b9e <initlock>
}
    80002448:	60a2                	ld	ra,8(sp)
    8000244a:	6402                	ld	s0,0(sp)
    8000244c:	0141                	addi	sp,sp,16
    8000244e:	8082                	ret

0000000080002450 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002450:	1141                	addi	sp,sp,-16
    80002452:	e406                	sd	ra,8(sp)
    80002454:	e022                	sd	s0,0(sp)
    80002456:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002458:	00003797          	auipc	a5,0x3
    8000245c:	6e878793          	addi	a5,a5,1768 # 80005b40 <kernelvec>
    80002460:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002464:	60a2                	ld	ra,8(sp)
    80002466:	6402                	ld	s0,0(sp)
    80002468:	0141                	addi	sp,sp,16
    8000246a:	8082                	ret

000000008000246c <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000246c:	1141                	addi	sp,sp,-16
    8000246e:	e406                	sd	ra,8(sp)
    80002470:	e022                	sd	s0,0(sp)
    80002472:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002474:	cbeff0ef          	jal	80001932 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002478:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000247c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000247e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002482:	04000737          	lui	a4,0x4000
    80002486:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002488:	0732                	slli	a4,a4,0xc
    8000248a:	00005797          	auipc	a5,0x5
    8000248e:	b7678793          	addi	a5,a5,-1162 # 80007000 <_trampoline>
    80002492:	00005697          	auipc	a3,0x5
    80002496:	b6e68693          	addi	a3,a3,-1170 # 80007000 <_trampoline>
    8000249a:	8f95                	sub	a5,a5,a3
    8000249c:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000249e:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024a2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024a4:	18002773          	csrr	a4,satp
    800024a8:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024aa:	6d38                	ld	a4,88(a0)
    800024ac:	613c                	ld	a5,64(a0)
    800024ae:	6685                	lui	a3,0x1
    800024b0:	97b6                	add	a5,a5,a3
    800024b2:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024b4:	6d3c                	ld	a5,88(a0)
    800024b6:	00000717          	auipc	a4,0x0
    800024ba:	0fc70713          	addi	a4,a4,252 # 800025b2 <usertrap>
    800024be:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800024c0:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024c2:	8712                	mv	a4,tp
    800024c4:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024c6:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024ca:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024ce:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024d2:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024d6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024d8:	6f9c                	ld	a5,24(a5)
    800024da:	14179073          	csrw	sepc,a5
}
    800024de:	60a2                	ld	ra,8(sp)
    800024e0:	6402                	ld	s0,0(sp)
    800024e2:	0141                	addi	sp,sp,16
    800024e4:	8082                	ret

00000000800024e6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024e6:	1141                	addi	sp,sp,-16
    800024e8:	e406                	sd	ra,8(sp)
    800024ea:	e022                	sd	s0,0(sp)
    800024ec:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800024ee:	c10ff0ef          	jal	800018fe <cpuid>
    800024f2:	cd11                	beqz	a0,8000250e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800024f4:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024f8:	000f4737          	lui	a4,0xf4
    800024fc:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002500:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002502:	14d79073          	csrw	stimecmp,a5
}
    80002506:	60a2                	ld	ra,8(sp)
    80002508:	6402                	ld	s0,0(sp)
    8000250a:	0141                	addi	sp,sp,16
    8000250c:	8082                	ret
    acquire(&tickslock);
    8000250e:	00014517          	auipc	a0,0x14
    80002512:	5ba50513          	addi	a0,a0,1466 # 80016ac8 <tickslock>
    80002516:	f12fe0ef          	jal	80000c28 <acquire>
    ticks++;
    8000251a:	00006717          	auipc	a4,0x6
    8000251e:	67e70713          	addi	a4,a4,1662 # 80008b98 <ticks>
    80002522:	431c                	lw	a5,0(a4)
    80002524:	2785                	addiw	a5,a5,1
    80002526:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002528:	853a                	mv	a0,a4
    8000252a:	a53ff0ef          	jal	80001f7c <wakeup>
    release(&tickslock);
    8000252e:	00014517          	auipc	a0,0x14
    80002532:	59a50513          	addi	a0,a0,1434 # 80016ac8 <tickslock>
    80002536:	f86fe0ef          	jal	80000cbc <release>
    8000253a:	bf6d                	j	800024f4 <clockintr+0xe>

000000008000253c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000253c:	1101                	addi	sp,sp,-32
    8000253e:	ec06                	sd	ra,24(sp)
    80002540:	e822                	sd	s0,16(sp)
    80002542:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002544:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002548:	57fd                	li	a5,-1
    8000254a:	17fe                	slli	a5,a5,0x3f
    8000254c:	07a5                	addi	a5,a5,9
    8000254e:	00f70c63          	beq	a4,a5,80002566 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002552:	57fd                	li	a5,-1
    80002554:	17fe                	slli	a5,a5,0x3f
    80002556:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002558:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000255a:	04f70863          	beq	a4,a5,800025aa <devintr+0x6e>
  }
}
    8000255e:	60e2                	ld	ra,24(sp)
    80002560:	6442                	ld	s0,16(sp)
    80002562:	6105                	addi	sp,sp,32
    80002564:	8082                	ret
    80002566:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002568:	684030ef          	jal	80005bec <plic_claim>
    8000256c:	872a                	mv	a4,a0
    8000256e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002570:	47a9                	li	a5,10
    80002572:	00f50963          	beq	a0,a5,80002584 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80002576:	4785                	li	a5,1
    80002578:	00f50963          	beq	a0,a5,8000258a <devintr+0x4e>
    return 1;
    8000257c:	4505                	li	a0,1
    } else if(irq){
    8000257e:	eb09                	bnez	a4,80002590 <devintr+0x54>
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	bff1                	j	8000255e <devintr+0x22>
      uartintr();
    80002584:	c70fe0ef          	jal	800009f4 <uartintr>
    if(irq)
    80002588:	a819                	j	8000259e <devintr+0x62>
      virtio_disk_intr();
    8000258a:	2f9030ef          	jal	80006082 <virtio_disk_intr>
    if(irq)
    8000258e:	a801                	j	8000259e <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80002590:	85ba                	mv	a1,a4
    80002592:	00006517          	auipc	a0,0x6
    80002596:	cce50513          	addi	a0,a0,-818 # 80008260 <etext+0x260>
    8000259a:	f61fd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    8000259e:	8526                	mv	a0,s1
    800025a0:	66c030ef          	jal	80005c0c <plic_complete>
    return 1;
    800025a4:	4505                	li	a0,1
    800025a6:	64a2                	ld	s1,8(sp)
    800025a8:	bf5d                	j	8000255e <devintr+0x22>
    clockintr();
    800025aa:	f3dff0ef          	jal	800024e6 <clockintr>
    return 2;
    800025ae:	4509                	li	a0,2
    800025b0:	b77d                	j	8000255e <devintr+0x22>

00000000800025b2 <usertrap>:
{
    800025b2:	1101                	addi	sp,sp,-32
    800025b4:	ec06                	sd	ra,24(sp)
    800025b6:	e822                	sd	s0,16(sp)
    800025b8:	e426                	sd	s1,8(sp)
    800025ba:	e04a                	sd	s2,0(sp)
    800025bc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025be:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025c2:	1007f793          	andi	a5,a5,256
    800025c6:	eba5                	bnez	a5,80002636 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025c8:	00003797          	auipc	a5,0x3
    800025cc:	57878793          	addi	a5,a5,1400 # 80005b40 <kernelvec>
    800025d0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025d4:	b5eff0ef          	jal	80001932 <myproc>
    800025d8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025da:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800025dc:	14102773          	csrr	a4,sepc
    800025e0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025e2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800025e6:	47a1                	li	a5,8
    800025e8:	04f70d63          	beq	a4,a5,80002642 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    800025ec:	f51ff0ef          	jal	8000253c <devintr>
    800025f0:	892a                	mv	s2,a0
    800025f2:	e945                	bnez	a0,800026a2 <usertrap+0xf0>
    800025f4:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    800025f8:	47bd                	li	a5,15
    800025fa:	08f70863          	beq	a4,a5,8000268a <usertrap+0xd8>
    800025fe:	14202773          	csrr	a4,scause
    80002602:	47b5                	li	a5,13
    80002604:	08f70363          	beq	a4,a5,8000268a <usertrap+0xd8>
    80002608:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000260c:	5890                	lw	a2,48(s1)
    8000260e:	00006517          	auipc	a0,0x6
    80002612:	c9250513          	addi	a0,a0,-878 # 800082a0 <etext+0x2a0>
    80002616:	ee5fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000261a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000261e:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002622:	00006517          	auipc	a0,0x6
    80002626:	cae50513          	addi	a0,a0,-850 # 800082d0 <etext+0x2d0>
    8000262a:	ed1fd0ef          	jal	800004fa <printf>
    setkilled(p);
    8000262e:	8526                	mv	a0,s1
    80002630:	b19ff0ef          	jal	80002148 <setkilled>
    80002634:	a035                	j	80002660 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80002636:	00006517          	auipc	a0,0x6
    8000263a:	c4a50513          	addi	a0,a0,-950 # 80008280 <etext+0x280>
    8000263e:	9e6fe0ef          	jal	80000824 <panic>
    if(killed(p))
    80002642:	b2bff0ef          	jal	8000216c <killed>
    80002646:	ed15                	bnez	a0,80002682 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002648:	6cb8                	ld	a4,88(s1)
    8000264a:	6f1c                	ld	a5,24(a4)
    8000264c:	0791                	addi	a5,a5,4
    8000264e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002650:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002654:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002658:	10079073          	csrw	sstatus,a5
    syscall();
    8000265c:	240000ef          	jal	8000289c <syscall>
  if(killed(p))
    80002660:	8526                	mv	a0,s1
    80002662:	b0bff0ef          	jal	8000216c <killed>
    80002666:	e139                	bnez	a0,800026ac <usertrap+0xfa>
  prepare_return();
    80002668:	e05ff0ef          	jal	8000246c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000266c:	68a8                	ld	a0,80(s1)
    8000266e:	8131                	srli	a0,a0,0xc
    80002670:	57fd                	li	a5,-1
    80002672:	17fe                	slli	a5,a5,0x3f
    80002674:	8d5d                	or	a0,a0,a5
}
    80002676:	60e2                	ld	ra,24(sp)
    80002678:	6442                	ld	s0,16(sp)
    8000267a:	64a2                	ld	s1,8(sp)
    8000267c:	6902                	ld	s2,0(sp)
    8000267e:	6105                	addi	sp,sp,32
    80002680:	8082                	ret
      kexit(-1);
    80002682:	557d                	li	a0,-1
    80002684:	9b9ff0ef          	jal	8000203c <kexit>
    80002688:	b7c1                	j	80002648 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000268a:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000268e:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002692:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002694:	00163613          	seqz	a2,a2
    80002698:	68a8                	ld	a0,80(s1)
    8000269a:	f3bfe0ef          	jal	800015d4 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    8000269e:	f169                	bnez	a0,80002660 <usertrap+0xae>
    800026a0:	b7a5                	j	80002608 <usertrap+0x56>
  if(killed(p))
    800026a2:	8526                	mv	a0,s1
    800026a4:	ac9ff0ef          	jal	8000216c <killed>
    800026a8:	c511                	beqz	a0,800026b4 <usertrap+0x102>
    800026aa:	a011                	j	800026ae <usertrap+0xfc>
    800026ac:	4901                	li	s2,0
    kexit(-1);
    800026ae:	557d                	li	a0,-1
    800026b0:	98dff0ef          	jal	8000203c <kexit>
  if(which_dev == 2)
    800026b4:	4789                	li	a5,2
    800026b6:	faf919e3          	bne	s2,a5,80002668 <usertrap+0xb6>
    yield();
    800026ba:	84bff0ef          	jal	80001f04 <yield>
    800026be:	b76d                	j	80002668 <usertrap+0xb6>

00000000800026c0 <kerneltrap>:
{
    800026c0:	7179                	addi	sp,sp,-48
    800026c2:	f406                	sd	ra,40(sp)
    800026c4:	f022                	sd	s0,32(sp)
    800026c6:	ec26                	sd	s1,24(sp)
    800026c8:	e84a                	sd	s2,16(sp)
    800026ca:	e44e                	sd	s3,8(sp)
    800026cc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026ce:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026d6:	142027f3          	csrr	a5,scause
    800026da:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    800026dc:	1004f793          	andi	a5,s1,256
    800026e0:	c795                	beqz	a5,8000270c <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026e6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026e8:	eb85                	bnez	a5,80002718 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    800026ea:	e53ff0ef          	jal	8000253c <devintr>
    800026ee:	c91d                	beqz	a0,80002724 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    800026f0:	4789                	li	a5,2
    800026f2:	04f50a63          	beq	a0,a5,80002746 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026f6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026fa:	10049073          	csrw	sstatus,s1
}
    800026fe:	70a2                	ld	ra,40(sp)
    80002700:	7402                	ld	s0,32(sp)
    80002702:	64e2                	ld	s1,24(sp)
    80002704:	6942                	ld	s2,16(sp)
    80002706:	69a2                	ld	s3,8(sp)
    80002708:	6145                	addi	sp,sp,48
    8000270a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000270c:	00006517          	auipc	a0,0x6
    80002710:	bec50513          	addi	a0,a0,-1044 # 800082f8 <etext+0x2f8>
    80002714:	910fe0ef          	jal	80000824 <panic>
    panic("kerneltrap: interrupts enabled");
    80002718:	00006517          	auipc	a0,0x6
    8000271c:	c0850513          	addi	a0,a0,-1016 # 80008320 <etext+0x320>
    80002720:	904fe0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002724:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002728:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000272c:	85ce                	mv	a1,s3
    8000272e:	00006517          	auipc	a0,0x6
    80002732:	c1250513          	addi	a0,a0,-1006 # 80008340 <etext+0x340>
    80002736:	dc5fd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    8000273a:	00006517          	auipc	a0,0x6
    8000273e:	c2e50513          	addi	a0,a0,-978 # 80008368 <etext+0x368>
    80002742:	8e2fe0ef          	jal	80000824 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002746:	9ecff0ef          	jal	80001932 <myproc>
    8000274a:	d555                	beqz	a0,800026f6 <kerneltrap+0x36>
    yield();
    8000274c:	fb8ff0ef          	jal	80001f04 <yield>
    80002750:	b75d                	j	800026f6 <kerneltrap+0x36>

0000000080002752 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002752:	1101                	addi	sp,sp,-32
    80002754:	ec06                	sd	ra,24(sp)
    80002756:	e822                	sd	s0,16(sp)
    80002758:	e426                	sd	s1,8(sp)
    8000275a:	1000                	addi	s0,sp,32
    8000275c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000275e:	9d4ff0ef          	jal	80001932 <myproc>
  switch (n) {
    80002762:	4795                	li	a5,5
    80002764:	0497e163          	bltu	a5,s1,800027a6 <argraw+0x54>
    80002768:	048a                	slli	s1,s1,0x2
    8000276a:	00006717          	auipc	a4,0x6
    8000276e:	32670713          	addi	a4,a4,806 # 80008a90 <states.0+0x30>
    80002772:	94ba                	add	s1,s1,a4
    80002774:	409c                	lw	a5,0(s1)
    80002776:	97ba                	add	a5,a5,a4
    80002778:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000277a:	6d3c                	ld	a5,88(a0)
    8000277c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000277e:	60e2                	ld	ra,24(sp)
    80002780:	6442                	ld	s0,16(sp)
    80002782:	64a2                	ld	s1,8(sp)
    80002784:	6105                	addi	sp,sp,32
    80002786:	8082                	ret
    return p->trapframe->a1;
    80002788:	6d3c                	ld	a5,88(a0)
    8000278a:	7fa8                	ld	a0,120(a5)
    8000278c:	bfcd                	j	8000277e <argraw+0x2c>
    return p->trapframe->a2;
    8000278e:	6d3c                	ld	a5,88(a0)
    80002790:	63c8                	ld	a0,128(a5)
    80002792:	b7f5                	j	8000277e <argraw+0x2c>
    return p->trapframe->a3;
    80002794:	6d3c                	ld	a5,88(a0)
    80002796:	67c8                	ld	a0,136(a5)
    80002798:	b7dd                	j	8000277e <argraw+0x2c>
    return p->trapframe->a4;
    8000279a:	6d3c                	ld	a5,88(a0)
    8000279c:	6bc8                	ld	a0,144(a5)
    8000279e:	b7c5                	j	8000277e <argraw+0x2c>
    return p->trapframe->a5;
    800027a0:	6d3c                	ld	a5,88(a0)
    800027a2:	6fc8                	ld	a0,152(a5)
    800027a4:	bfe9                	j	8000277e <argraw+0x2c>
  panic("argraw");
    800027a6:	00006517          	auipc	a0,0x6
    800027aa:	bd250513          	addi	a0,a0,-1070 # 80008378 <etext+0x378>
    800027ae:	876fe0ef          	jal	80000824 <panic>

00000000800027b2 <fetchaddr>:
{
    800027b2:	1101                	addi	sp,sp,-32
    800027b4:	ec06                	sd	ra,24(sp)
    800027b6:	e822                	sd	s0,16(sp)
    800027b8:	e426                	sd	s1,8(sp)
    800027ba:	e04a                	sd	s2,0(sp)
    800027bc:	1000                	addi	s0,sp,32
    800027be:	84aa                	mv	s1,a0
    800027c0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027c2:	970ff0ef          	jal	80001932 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027c6:	653c                	ld	a5,72(a0)
    800027c8:	02f4f663          	bgeu	s1,a5,800027f4 <fetchaddr+0x42>
    800027cc:	00848713          	addi	a4,s1,8
    800027d0:	02e7e463          	bltu	a5,a4,800027f8 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027d4:	46a1                	li	a3,8
    800027d6:	8626                	mv	a2,s1
    800027d8:	85ca                	mv	a1,s2
    800027da:	6928                	ld	a0,80(a0)
    800027dc:	f3bfe0ef          	jal	80001716 <copyin>
    800027e0:	00a03533          	snez	a0,a0
    800027e4:	40a0053b          	negw	a0,a0
}
    800027e8:	60e2                	ld	ra,24(sp)
    800027ea:	6442                	ld	s0,16(sp)
    800027ec:	64a2                	ld	s1,8(sp)
    800027ee:	6902                	ld	s2,0(sp)
    800027f0:	6105                	addi	sp,sp,32
    800027f2:	8082                	ret
    return -1;
    800027f4:	557d                	li	a0,-1
    800027f6:	bfcd                	j	800027e8 <fetchaddr+0x36>
    800027f8:	557d                	li	a0,-1
    800027fa:	b7fd                	j	800027e8 <fetchaddr+0x36>

00000000800027fc <fetchstr>:
{
    800027fc:	7179                	addi	sp,sp,-48
    800027fe:	f406                	sd	ra,40(sp)
    80002800:	f022                	sd	s0,32(sp)
    80002802:	ec26                	sd	s1,24(sp)
    80002804:	e84a                	sd	s2,16(sp)
    80002806:	e44e                	sd	s3,8(sp)
    80002808:	1800                	addi	s0,sp,48
    8000280a:	89aa                	mv	s3,a0
    8000280c:	84ae                	mv	s1,a1
    8000280e:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002810:	922ff0ef          	jal	80001932 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002814:	86ca                	mv	a3,s2
    80002816:	864e                	mv	a2,s3
    80002818:	85a6                	mv	a1,s1
    8000281a:	6928                	ld	a0,80(a0)
    8000281c:	ce1fe0ef          	jal	800014fc <copyinstr>
    80002820:	00054c63          	bltz	a0,80002838 <fetchstr+0x3c>
  return strlen(buf);
    80002824:	8526                	mv	a0,s1
    80002826:	e5cfe0ef          	jal	80000e82 <strlen>
}
    8000282a:	70a2                	ld	ra,40(sp)
    8000282c:	7402                	ld	s0,32(sp)
    8000282e:	64e2                	ld	s1,24(sp)
    80002830:	6942                	ld	s2,16(sp)
    80002832:	69a2                	ld	s3,8(sp)
    80002834:	6145                	addi	sp,sp,48
    80002836:	8082                	ret
    return -1;
    80002838:	557d                	li	a0,-1
    8000283a:	bfc5                	j	8000282a <fetchstr+0x2e>

000000008000283c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000283c:	1101                	addi	sp,sp,-32
    8000283e:	ec06                	sd	ra,24(sp)
    80002840:	e822                	sd	s0,16(sp)
    80002842:	e426                	sd	s1,8(sp)
    80002844:	1000                	addi	s0,sp,32
    80002846:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002848:	f0bff0ef          	jal	80002752 <argraw>
    8000284c:	c088                	sw	a0,0(s1)
}
    8000284e:	60e2                	ld	ra,24(sp)
    80002850:	6442                	ld	s0,16(sp)
    80002852:	64a2                	ld	s1,8(sp)
    80002854:	6105                	addi	sp,sp,32
    80002856:	8082                	ret

0000000080002858 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002858:	1101                	addi	sp,sp,-32
    8000285a:	ec06                	sd	ra,24(sp)
    8000285c:	e822                	sd	s0,16(sp)
    8000285e:	e426                	sd	s1,8(sp)
    80002860:	1000                	addi	s0,sp,32
    80002862:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002864:	eefff0ef          	jal	80002752 <argraw>
    80002868:	e088                	sd	a0,0(s1)
}
    8000286a:	60e2                	ld	ra,24(sp)
    8000286c:	6442                	ld	s0,16(sp)
    8000286e:	64a2                	ld	s1,8(sp)
    80002870:	6105                	addi	sp,sp,32
    80002872:	8082                	ret

0000000080002874 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002874:	1101                	addi	sp,sp,-32
    80002876:	ec06                	sd	ra,24(sp)
    80002878:	e822                	sd	s0,16(sp)
    8000287a:	e426                	sd	s1,8(sp)
    8000287c:	e04a                	sd	s2,0(sp)
    8000287e:	1000                	addi	s0,sp,32
    80002880:	892e                	mv	s2,a1
    80002882:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002884:	ecfff0ef          	jal	80002752 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002888:	8626                	mv	a2,s1
    8000288a:	85ca                	mv	a1,s2
    8000288c:	f71ff0ef          	jal	800027fc <fetchstr>
}
    80002890:	60e2                	ld	ra,24(sp)
    80002892:	6442                	ld	s0,16(sp)
    80002894:	64a2                	ld	s1,8(sp)
    80002896:	6902                	ld	s2,0(sp)
    80002898:	6105                	addi	sp,sp,32
    8000289a:	8082                	ret

000000008000289c <syscall>:
[SYS_buddytest] sys_buddytest
};

void
syscall(void)
{
    8000289c:	1101                	addi	sp,sp,-32
    8000289e:	ec06                	sd	ra,24(sp)
    800028a0:	e822                	sd	s0,16(sp)
    800028a2:	e426                	sd	s1,8(sp)
    800028a4:	e04a                	sd	s2,0(sp)
    800028a6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028a8:	88aff0ef          	jal	80001932 <myproc>
    800028ac:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028ae:	05853903          	ld	s2,88(a0)
    800028b2:	0a893783          	ld	a5,168(s2)
    800028b6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028ba:	37fd                	addiw	a5,a5,-1
    800028bc:	4755                	li	a4,21
    800028be:	00f76f63          	bltu	a4,a5,800028dc <syscall+0x40>
    800028c2:	00369713          	slli	a4,a3,0x3
    800028c6:	00006797          	auipc	a5,0x6
    800028ca:	1e278793          	addi	a5,a5,482 # 80008aa8 <syscalls>
    800028ce:	97ba                	add	a5,a5,a4
    800028d0:	639c                	ld	a5,0(a5)
    800028d2:	c789                	beqz	a5,800028dc <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028d4:	9782                	jalr	a5
    800028d6:	06a93823          	sd	a0,112(s2)
    800028da:	a829                	j	800028f4 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800028dc:	15848613          	addi	a2,s1,344
    800028e0:	588c                	lw	a1,48(s1)
    800028e2:	00006517          	auipc	a0,0x6
    800028e6:	a9e50513          	addi	a0,a0,-1378 # 80008380 <etext+0x380>
    800028ea:	c11fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800028ee:	6cbc                	ld	a5,88(s1)
    800028f0:	577d                	li	a4,-1
    800028f2:	fbb8                	sd	a4,112(a5)
  }
}
    800028f4:	60e2                	ld	ra,24(sp)
    800028f6:	6442                	ld	s0,16(sp)
    800028f8:	64a2                	ld	s1,8(sp)
    800028fa:	6902                	ld	s2,0(sp)
    800028fc:	6105                	addi	sp,sp,32
    800028fe:	8082                	ret

0000000080002900 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002900:	1101                	addi	sp,sp,-32
    80002902:	ec06                	sd	ra,24(sp)
    80002904:	e822                	sd	s0,16(sp)
    80002906:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002908:	fec40593          	addi	a1,s0,-20
    8000290c:	4501                	li	a0,0
    8000290e:	f2fff0ef          	jal	8000283c <argint>
  kexit(n);
    80002912:	fec42503          	lw	a0,-20(s0)
    80002916:	f26ff0ef          	jal	8000203c <kexit>
  return 0;  // not reached
}
    8000291a:	4501                	li	a0,0
    8000291c:	60e2                	ld	ra,24(sp)
    8000291e:	6442                	ld	s0,16(sp)
    80002920:	6105                	addi	sp,sp,32
    80002922:	8082                	ret

0000000080002924 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002924:	1141                	addi	sp,sp,-16
    80002926:	e406                	sd	ra,8(sp)
    80002928:	e022                	sd	s0,0(sp)
    8000292a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000292c:	806ff0ef          	jal	80001932 <myproc>
}
    80002930:	5908                	lw	a0,48(a0)
    80002932:	60a2                	ld	ra,8(sp)
    80002934:	6402                	ld	s0,0(sp)
    80002936:	0141                	addi	sp,sp,16
    80002938:	8082                	ret

000000008000293a <sys_fork>:

uint64
sys_fork(void)
{
    8000293a:	1141                	addi	sp,sp,-16
    8000293c:	e406                	sd	ra,8(sp)
    8000293e:	e022                	sd	s0,0(sp)
    80002940:	0800                	addi	s0,sp,16
  return kfork();
    80002942:	b46ff0ef          	jal	80001c88 <kfork>
}
    80002946:	60a2                	ld	ra,8(sp)
    80002948:	6402                	ld	s0,0(sp)
    8000294a:	0141                	addi	sp,sp,16
    8000294c:	8082                	ret

000000008000294e <sys_wait>:

uint64
sys_wait(void)
{
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002956:	fe840593          	addi	a1,s0,-24
    8000295a:	4501                	li	a0,0
    8000295c:	efdff0ef          	jal	80002858 <argaddr>
  return kwait(p);
    80002960:	fe843503          	ld	a0,-24(s0)
    80002964:	833ff0ef          	jal	80002196 <kwait>
}
    80002968:	60e2                	ld	ra,24(sp)
    8000296a:	6442                	ld	s0,16(sp)
    8000296c:	6105                	addi	sp,sp,32
    8000296e:	8082                	ret

0000000080002970 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002970:	7179                	addi	sp,sp,-48
    80002972:	f406                	sd	ra,40(sp)
    80002974:	f022                	sd	s0,32(sp)
    80002976:	ec26                	sd	s1,24(sp)
    80002978:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    8000297a:	fd840593          	addi	a1,s0,-40
    8000297e:	4501                	li	a0,0
    80002980:	ebdff0ef          	jal	8000283c <argint>
  argint(1, &t);
    80002984:	fdc40593          	addi	a1,s0,-36
    80002988:	4505                	li	a0,1
    8000298a:	eb3ff0ef          	jal	8000283c <argint>
  addr = myproc()->sz;
    8000298e:	fa5fe0ef          	jal	80001932 <myproc>
    80002992:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80002994:	fdc42703          	lw	a4,-36(s0)
    80002998:	4785                	li	a5,1
    8000299a:	02f70163          	beq	a4,a5,800029bc <sys_sbrk+0x4c>
    8000299e:	fd842783          	lw	a5,-40(s0)
    800029a2:	0007cd63          	bltz	a5,800029bc <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    800029a6:	97a6                	add	a5,a5,s1
    800029a8:	0297e863          	bltu	a5,s1,800029d8 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    800029ac:	f87fe0ef          	jal	80001932 <myproc>
    800029b0:	fd842703          	lw	a4,-40(s0)
    800029b4:	653c                	ld	a5,72(a0)
    800029b6:	97ba                	add	a5,a5,a4
    800029b8:	e53c                	sd	a5,72(a0)
    800029ba:	a039                	j	800029c8 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    800029bc:	fd842503          	lw	a0,-40(s0)
    800029c0:	a78ff0ef          	jal	80001c38 <growproc>
    800029c4:	00054863          	bltz	a0,800029d4 <sys_sbrk+0x64>
  }
  return addr;
}
    800029c8:	8526                	mv	a0,s1
    800029ca:	70a2                	ld	ra,40(sp)
    800029cc:	7402                	ld	s0,32(sp)
    800029ce:	64e2                	ld	s1,24(sp)
    800029d0:	6145                	addi	sp,sp,48
    800029d2:	8082                	ret
      return -1;
    800029d4:	54fd                	li	s1,-1
    800029d6:	bfcd                	j	800029c8 <sys_sbrk+0x58>
      return -1;
    800029d8:	54fd                	li	s1,-1
    800029da:	b7fd                	j	800029c8 <sys_sbrk+0x58>

00000000800029dc <sys_pause>:

uint64
sys_pause(void)
{
    800029dc:	7139                	addi	sp,sp,-64
    800029de:	fc06                	sd	ra,56(sp)
    800029e0:	f822                	sd	s0,48(sp)
    800029e2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029e4:	fcc40593          	addi	a1,s0,-52
    800029e8:	4501                	li	a0,0
    800029ea:	e53ff0ef          	jal	8000283c <argint>
  if(n < 0)
    800029ee:	fcc42783          	lw	a5,-52(s0)
    800029f2:	0607c863          	bltz	a5,80002a62 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800029f6:	00014517          	auipc	a0,0x14
    800029fa:	0d250513          	addi	a0,a0,210 # 80016ac8 <tickslock>
    800029fe:	a2afe0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002a02:	fcc42783          	lw	a5,-52(s0)
    80002a06:	c3b9                	beqz	a5,80002a4c <sys_pause+0x70>
    80002a08:	f426                	sd	s1,40(sp)
    80002a0a:	f04a                	sd	s2,32(sp)
    80002a0c:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a0e:	00006997          	auipc	s3,0x6
    80002a12:	18a9a983          	lw	s3,394(s3) # 80008b98 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a16:	00014917          	auipc	s2,0x14
    80002a1a:	0b290913          	addi	s2,s2,178 # 80016ac8 <tickslock>
    80002a1e:	00006497          	auipc	s1,0x6
    80002a22:	17a48493          	addi	s1,s1,378 # 80008b98 <ticks>
    if(killed(myproc())){
    80002a26:	f0dfe0ef          	jal	80001932 <myproc>
    80002a2a:	f42ff0ef          	jal	8000216c <killed>
    80002a2e:	ed0d                	bnez	a0,80002a68 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a30:	85ca                	mv	a1,s2
    80002a32:	8526                	mv	a0,s1
    80002a34:	cfcff0ef          	jal	80001f30 <sleep>
  while(ticks - ticks0 < n){
    80002a38:	409c                	lw	a5,0(s1)
    80002a3a:	413787bb          	subw	a5,a5,s3
    80002a3e:	fcc42703          	lw	a4,-52(s0)
    80002a42:	fee7e2e3          	bltu	a5,a4,80002a26 <sys_pause+0x4a>
    80002a46:	74a2                	ld	s1,40(sp)
    80002a48:	7902                	ld	s2,32(sp)
    80002a4a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a4c:	00014517          	auipc	a0,0x14
    80002a50:	07c50513          	addi	a0,a0,124 # 80016ac8 <tickslock>
    80002a54:	a68fe0ef          	jal	80000cbc <release>
  return 0;
    80002a58:	4501                	li	a0,0
}
    80002a5a:	70e2                	ld	ra,56(sp)
    80002a5c:	7442                	ld	s0,48(sp)
    80002a5e:	6121                	addi	sp,sp,64
    80002a60:	8082                	ret
    n = 0;
    80002a62:	fc042623          	sw	zero,-52(s0)
    80002a66:	bf41                	j	800029f6 <sys_pause+0x1a>
      release(&tickslock);
    80002a68:	00014517          	auipc	a0,0x14
    80002a6c:	06050513          	addi	a0,a0,96 # 80016ac8 <tickslock>
    80002a70:	a4cfe0ef          	jal	80000cbc <release>
      return -1;
    80002a74:	557d                	li	a0,-1
    80002a76:	74a2                	ld	s1,40(sp)
    80002a78:	7902                	ld	s2,32(sp)
    80002a7a:	69e2                	ld	s3,24(sp)
    80002a7c:	bff9                	j	80002a5a <sys_pause+0x7e>

0000000080002a7e <sys_kill>:

uint64
sys_kill(void)
{
    80002a7e:	1101                	addi	sp,sp,-32
    80002a80:	ec06                	sd	ra,24(sp)
    80002a82:	e822                	sd	s0,16(sp)
    80002a84:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a86:	fec40593          	addi	a1,s0,-20
    80002a8a:	4501                	li	a0,0
    80002a8c:	db1ff0ef          	jal	8000283c <argint>
  return kkill(pid);
    80002a90:	fec42503          	lw	a0,-20(s0)
    80002a94:	e4eff0ef          	jal	800020e2 <kkill>
}
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	6105                	addi	sp,sp,32
    80002a9e:	8082                	ret

0000000080002aa0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002aa0:	1101                	addi	sp,sp,-32
    80002aa2:	ec06                	sd	ra,24(sp)
    80002aa4:	e822                	sd	s0,16(sp)
    80002aa6:	e426                	sd	s1,8(sp)
    80002aa8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002aaa:	00014517          	auipc	a0,0x14
    80002aae:	01e50513          	addi	a0,a0,30 # 80016ac8 <tickslock>
    80002ab2:	976fe0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80002ab6:	00006797          	auipc	a5,0x6
    80002aba:	0e27a783          	lw	a5,226(a5) # 80008b98 <ticks>
    80002abe:	84be                	mv	s1,a5
  release(&tickslock);
    80002ac0:	00014517          	auipc	a0,0x14
    80002ac4:	00850513          	addi	a0,a0,8 # 80016ac8 <tickslock>
    80002ac8:	9f4fe0ef          	jal	80000cbc <release>
  return xticks;
}
    80002acc:	02049513          	slli	a0,s1,0x20
    80002ad0:	9101                	srli	a0,a0,0x20
    80002ad2:	60e2                	ld	ra,24(sp)
    80002ad4:	6442                	ld	s0,16(sp)
    80002ad6:	64a2                	ld	s1,8(sp)
    80002ad8:	6105                	addi	sp,sp,32
    80002ada:	8082                	ret

0000000080002adc <sys_buddytest>:

// At the end of kernel/sysproc.c

uint64
sys_buddytest(void)
{
    80002adc:	1141                	addi	sp,sp,-16
    80002ade:	e406                	sd	ra,8(sp)
    80002ae0:	e022                	sd	s0,0(sp)
    80002ae2:	0800                	addi	s0,sp,16
  buddy_test();
    80002ae4:	1c1010ef          	jal	800044a4 <buddy_test>
  return 0;
}
    80002ae8:	4501                	li	a0,0
    80002aea:	60a2                	ld	ra,8(sp)
    80002aec:	6402                	ld	s0,0(sp)
    80002aee:	0141                	addi	sp,sp,16
    80002af0:	8082                	ret

0000000080002af2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002af2:	7179                	addi	sp,sp,-48
    80002af4:	f406                	sd	ra,40(sp)
    80002af6:	f022                	sd	s0,32(sp)
    80002af8:	ec26                	sd	s1,24(sp)
    80002afa:	e84a                	sd	s2,16(sp)
    80002afc:	e44e                	sd	s3,8(sp)
    80002afe:	e052                	sd	s4,0(sp)
    80002b00:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b02:	00006597          	auipc	a1,0x6
    80002b06:	89e58593          	addi	a1,a1,-1890 # 800083a0 <etext+0x3a0>
    80002b0a:	00014517          	auipc	a0,0x14
    80002b0e:	fd650513          	addi	a0,a0,-42 # 80016ae0 <bcache>
    80002b12:	88cfe0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b16:	0001c797          	auipc	a5,0x1c
    80002b1a:	fca78793          	addi	a5,a5,-54 # 8001eae0 <bcache+0x8000>
    80002b1e:	0001c717          	auipc	a4,0x1c
    80002b22:	22a70713          	addi	a4,a4,554 # 8001ed48 <bcache+0x8268>
    80002b26:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b2a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b2e:	00014497          	auipc	s1,0x14
    80002b32:	fca48493          	addi	s1,s1,-54 # 80016af8 <bcache+0x18>
    b->next = bcache.head.next;
    80002b36:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b38:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b3a:	00006a17          	auipc	s4,0x6
    80002b3e:	86ea0a13          	addi	s4,s4,-1938 # 800083a8 <etext+0x3a8>
    b->next = bcache.head.next;
    80002b42:	2b893783          	ld	a5,696(s2)
    80002b46:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b48:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b4c:	85d2                	mv	a1,s4
    80002b4e:	01048513          	addi	a0,s1,16
    80002b52:	26d010ef          	jal	800045be <initsleeplock>
    bcache.head.next->prev = b;
    80002b56:	2b893783          	ld	a5,696(s2)
    80002b5a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b5c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b60:	45848493          	addi	s1,s1,1112
    80002b64:	fd349fe3          	bne	s1,s3,80002b42 <binit+0x50>
  }
}
    80002b68:	70a2                	ld	ra,40(sp)
    80002b6a:	7402                	ld	s0,32(sp)
    80002b6c:	64e2                	ld	s1,24(sp)
    80002b6e:	6942                	ld	s2,16(sp)
    80002b70:	69a2                	ld	s3,8(sp)
    80002b72:	6a02                	ld	s4,0(sp)
    80002b74:	6145                	addi	sp,sp,48
    80002b76:	8082                	ret

0000000080002b78 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002b78:	7179                	addi	sp,sp,-48
    80002b7a:	f406                	sd	ra,40(sp)
    80002b7c:	f022                	sd	s0,32(sp)
    80002b7e:	ec26                	sd	s1,24(sp)
    80002b80:	e84a                	sd	s2,16(sp)
    80002b82:	e44e                	sd	s3,8(sp)
    80002b84:	1800                	addi	s0,sp,48
    80002b86:	892a                	mv	s2,a0
    80002b88:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002b8a:	00014517          	auipc	a0,0x14
    80002b8e:	f5650513          	addi	a0,a0,-170 # 80016ae0 <bcache>
    80002b92:	896fe0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002b96:	0001c497          	auipc	s1,0x1c
    80002b9a:	2024b483          	ld	s1,514(s1) # 8001ed98 <bcache+0x82b8>
    80002b9e:	0001c797          	auipc	a5,0x1c
    80002ba2:	1aa78793          	addi	a5,a5,426 # 8001ed48 <bcache+0x8268>
    80002ba6:	02f48b63          	beq	s1,a5,80002bdc <bread+0x64>
    80002baa:	873e                	mv	a4,a5
    80002bac:	a021                	j	80002bb4 <bread+0x3c>
    80002bae:	68a4                	ld	s1,80(s1)
    80002bb0:	02e48663          	beq	s1,a4,80002bdc <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002bb4:	449c                	lw	a5,8(s1)
    80002bb6:	ff279ce3          	bne	a5,s2,80002bae <bread+0x36>
    80002bba:	44dc                	lw	a5,12(s1)
    80002bbc:	ff3799e3          	bne	a5,s3,80002bae <bread+0x36>
      b->refcnt++;
    80002bc0:	40bc                	lw	a5,64(s1)
    80002bc2:	2785                	addiw	a5,a5,1
    80002bc4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bc6:	00014517          	auipc	a0,0x14
    80002bca:	f1a50513          	addi	a0,a0,-230 # 80016ae0 <bcache>
    80002bce:	8eefe0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002bd2:	01048513          	addi	a0,s1,16
    80002bd6:	21f010ef          	jal	800045f4 <acquiresleep>
      return b;
    80002bda:	a889                	j	80002c2c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bdc:	0001c497          	auipc	s1,0x1c
    80002be0:	1b44b483          	ld	s1,436(s1) # 8001ed90 <bcache+0x82b0>
    80002be4:	0001c797          	auipc	a5,0x1c
    80002be8:	16478793          	addi	a5,a5,356 # 8001ed48 <bcache+0x8268>
    80002bec:	00f48863          	beq	s1,a5,80002bfc <bread+0x84>
    80002bf0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002bf2:	40bc                	lw	a5,64(s1)
    80002bf4:	cb91                	beqz	a5,80002c08 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002bf6:	64a4                	ld	s1,72(s1)
    80002bf8:	fee49de3          	bne	s1,a4,80002bf2 <bread+0x7a>
  panic("bget: no buffers");
    80002bfc:	00005517          	auipc	a0,0x5
    80002c00:	7b450513          	addi	a0,a0,1972 # 800083b0 <etext+0x3b0>
    80002c04:	c21fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80002c08:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c0c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c10:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c14:	4785                	li	a5,1
    80002c16:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c18:	00014517          	auipc	a0,0x14
    80002c1c:	ec850513          	addi	a0,a0,-312 # 80016ae0 <bcache>
    80002c20:	89cfe0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002c24:	01048513          	addi	a0,s1,16
    80002c28:	1cd010ef          	jal	800045f4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c2c:	409c                	lw	a5,0(s1)
    80002c2e:	cb89                	beqz	a5,80002c40 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c30:	8526                	mv	a0,s1
    80002c32:	70a2                	ld	ra,40(sp)
    80002c34:	7402                	ld	s0,32(sp)
    80002c36:	64e2                	ld	s1,24(sp)
    80002c38:	6942                	ld	s2,16(sp)
    80002c3a:	69a2                	ld	s3,8(sp)
    80002c3c:	6145                	addi	sp,sp,48
    80002c3e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c40:	4581                	li	a1,0
    80002c42:	8526                	mv	a0,s1
    80002c44:	22c030ef          	jal	80005e70 <virtio_disk_rw>
    b->valid = 1;
    80002c48:	4785                	li	a5,1
    80002c4a:	c09c                	sw	a5,0(s1)
  return b;
    80002c4c:	b7d5                	j	80002c30 <bread+0xb8>

0000000080002c4e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c4e:	1101                	addi	sp,sp,-32
    80002c50:	ec06                	sd	ra,24(sp)
    80002c52:	e822                	sd	s0,16(sp)
    80002c54:	e426                	sd	s1,8(sp)
    80002c56:	1000                	addi	s0,sp,32
    80002c58:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c5a:	0541                	addi	a0,a0,16
    80002c5c:	217010ef          	jal	80004672 <holdingsleep>
    80002c60:	c911                	beqz	a0,80002c74 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c62:	4585                	li	a1,1
    80002c64:	8526                	mv	a0,s1
    80002c66:	20a030ef          	jal	80005e70 <virtio_disk_rw>
}
    80002c6a:	60e2                	ld	ra,24(sp)
    80002c6c:	6442                	ld	s0,16(sp)
    80002c6e:	64a2                	ld	s1,8(sp)
    80002c70:	6105                	addi	sp,sp,32
    80002c72:	8082                	ret
    panic("bwrite");
    80002c74:	00005517          	auipc	a0,0x5
    80002c78:	75450513          	addi	a0,a0,1876 # 800083c8 <etext+0x3c8>
    80002c7c:	ba9fd0ef          	jal	80000824 <panic>

0000000080002c80 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c80:	1101                	addi	sp,sp,-32
    80002c82:	ec06                	sd	ra,24(sp)
    80002c84:	e822                	sd	s0,16(sp)
    80002c86:	e426                	sd	s1,8(sp)
    80002c88:	e04a                	sd	s2,0(sp)
    80002c8a:	1000                	addi	s0,sp,32
    80002c8c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c8e:	01050913          	addi	s2,a0,16
    80002c92:	854a                	mv	a0,s2
    80002c94:	1df010ef          	jal	80004672 <holdingsleep>
    80002c98:	c125                	beqz	a0,80002cf8 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	19f010ef          	jal	8000463a <releasesleep>

  acquire(&bcache.lock);
    80002ca0:	00014517          	auipc	a0,0x14
    80002ca4:	e4050513          	addi	a0,a0,-448 # 80016ae0 <bcache>
    80002ca8:	f81fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002cac:	40bc                	lw	a5,64(s1)
    80002cae:	37fd                	addiw	a5,a5,-1
    80002cb0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002cb2:	e79d                	bnez	a5,80002ce0 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002cb4:	68b8                	ld	a4,80(s1)
    80002cb6:	64bc                	ld	a5,72(s1)
    80002cb8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002cba:	68b8                	ld	a4,80(s1)
    80002cbc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002cbe:	0001c797          	auipc	a5,0x1c
    80002cc2:	e2278793          	addi	a5,a5,-478 # 8001eae0 <bcache+0x8000>
    80002cc6:	2b87b703          	ld	a4,696(a5)
    80002cca:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002ccc:	0001c717          	auipc	a4,0x1c
    80002cd0:	07c70713          	addi	a4,a4,124 # 8001ed48 <bcache+0x8268>
    80002cd4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cd6:	2b87b703          	ld	a4,696(a5)
    80002cda:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002cdc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002ce0:	00014517          	auipc	a0,0x14
    80002ce4:	e0050513          	addi	a0,a0,-512 # 80016ae0 <bcache>
    80002ce8:	fd5fd0ef          	jal	80000cbc <release>
}
    80002cec:	60e2                	ld	ra,24(sp)
    80002cee:	6442                	ld	s0,16(sp)
    80002cf0:	64a2                	ld	s1,8(sp)
    80002cf2:	6902                	ld	s2,0(sp)
    80002cf4:	6105                	addi	sp,sp,32
    80002cf6:	8082                	ret
    panic("brelse");
    80002cf8:	00005517          	auipc	a0,0x5
    80002cfc:	6d850513          	addi	a0,a0,1752 # 800083d0 <etext+0x3d0>
    80002d00:	b25fd0ef          	jal	80000824 <panic>

0000000080002d04 <bpin>:

void
bpin(struct buf *b) {
    80002d04:	1101                	addi	sp,sp,-32
    80002d06:	ec06                	sd	ra,24(sp)
    80002d08:	e822                	sd	s0,16(sp)
    80002d0a:	e426                	sd	s1,8(sp)
    80002d0c:	1000                	addi	s0,sp,32
    80002d0e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d10:	00014517          	auipc	a0,0x14
    80002d14:	dd050513          	addi	a0,a0,-560 # 80016ae0 <bcache>
    80002d18:	f11fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    80002d1c:	40bc                	lw	a5,64(s1)
    80002d1e:	2785                	addiw	a5,a5,1
    80002d20:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d22:	00014517          	auipc	a0,0x14
    80002d26:	dbe50513          	addi	a0,a0,-578 # 80016ae0 <bcache>
    80002d2a:	f93fd0ef          	jal	80000cbc <release>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6105                	addi	sp,sp,32
    80002d36:	8082                	ret

0000000080002d38 <bunpin>:

void
bunpin(struct buf *b) {
    80002d38:	1101                	addi	sp,sp,-32
    80002d3a:	ec06                	sd	ra,24(sp)
    80002d3c:	e822                	sd	s0,16(sp)
    80002d3e:	e426                	sd	s1,8(sp)
    80002d40:	1000                	addi	s0,sp,32
    80002d42:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d44:	00014517          	auipc	a0,0x14
    80002d48:	d9c50513          	addi	a0,a0,-612 # 80016ae0 <bcache>
    80002d4c:	eddfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002d50:	40bc                	lw	a5,64(s1)
    80002d52:	37fd                	addiw	a5,a5,-1
    80002d54:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d56:	00014517          	auipc	a0,0x14
    80002d5a:	d8a50513          	addi	a0,a0,-630 # 80016ae0 <bcache>
    80002d5e:	f5ffd0ef          	jal	80000cbc <release>
}
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	64a2                	ld	s1,8(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret

0000000080002d6c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d6c:	1101                	addi	sp,sp,-32
    80002d6e:	ec06                	sd	ra,24(sp)
    80002d70:	e822                	sd	s0,16(sp)
    80002d72:	e426                	sd	s1,8(sp)
    80002d74:	e04a                	sd	s2,0(sp)
    80002d76:	1000                	addi	s0,sp,32
    80002d78:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d7a:	00d5d79b          	srliw	a5,a1,0xd
    80002d7e:	0001c597          	auipc	a1,0x1c
    80002d82:	43e5a583          	lw	a1,1086(a1) # 8001f1bc <sb+0x1c>
    80002d86:	9dbd                	addw	a1,a1,a5
    80002d88:	df1ff0ef          	jal	80002b78 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002d8c:	0074f713          	andi	a4,s1,7
    80002d90:	4785                	li	a5,1
    80002d92:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002d96:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002d98:	90d9                	srli	s1,s1,0x36
    80002d9a:	00950733          	add	a4,a0,s1
    80002d9e:	05874703          	lbu	a4,88(a4)
    80002da2:	00e7f6b3          	and	a3,a5,a4
    80002da6:	c29d                	beqz	a3,80002dcc <bfree+0x60>
    80002da8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002daa:	94aa                	add	s1,s1,a0
    80002dac:	fff7c793          	not	a5,a5
    80002db0:	8f7d                	and	a4,a4,a5
    80002db2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002db6:	000010ef          	jal	80003db6 <log_write>
  brelse(bp);
    80002dba:	854a                	mv	a0,s2
    80002dbc:	ec5ff0ef          	jal	80002c80 <brelse>
}
    80002dc0:	60e2                	ld	ra,24(sp)
    80002dc2:	6442                	ld	s0,16(sp)
    80002dc4:	64a2                	ld	s1,8(sp)
    80002dc6:	6902                	ld	s2,0(sp)
    80002dc8:	6105                	addi	sp,sp,32
    80002dca:	8082                	ret
    panic("freeing free block");
    80002dcc:	00005517          	auipc	a0,0x5
    80002dd0:	60c50513          	addi	a0,a0,1548 # 800083d8 <etext+0x3d8>
    80002dd4:	a51fd0ef          	jal	80000824 <panic>

0000000080002dd8 <balloc>:
{
    80002dd8:	715d                	addi	sp,sp,-80
    80002dda:	e486                	sd	ra,72(sp)
    80002ddc:	e0a2                	sd	s0,64(sp)
    80002dde:	fc26                	sd	s1,56(sp)
    80002de0:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002de2:	0001c797          	auipc	a5,0x1c
    80002de6:	3c27a783          	lw	a5,962(a5) # 8001f1a4 <sb+0x4>
    80002dea:	0e078263          	beqz	a5,80002ece <balloc+0xf6>
    80002dee:	f84a                	sd	s2,48(sp)
    80002df0:	f44e                	sd	s3,40(sp)
    80002df2:	f052                	sd	s4,32(sp)
    80002df4:	ec56                	sd	s5,24(sp)
    80002df6:	e85a                	sd	s6,16(sp)
    80002df8:	e45e                	sd	s7,8(sp)
    80002dfa:	e062                	sd	s8,0(sp)
    80002dfc:	8baa                	mv	s7,a0
    80002dfe:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e00:	0001cb17          	auipc	s6,0x1c
    80002e04:	3a0b0b13          	addi	s6,s6,928 # 8001f1a0 <sb>
      m = 1 << (bi % 8);
    80002e08:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e0a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002e0c:	6c09                	lui	s8,0x2
    80002e0e:	a09d                	j	80002e74 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002e10:	97ca                	add	a5,a5,s2
    80002e12:	8e55                	or	a2,a2,a3
    80002e14:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e18:	854a                	mv	a0,s2
    80002e1a:	79d000ef          	jal	80003db6 <log_write>
        brelse(bp);
    80002e1e:	854a                	mv	a0,s2
    80002e20:	e61ff0ef          	jal	80002c80 <brelse>
  bp = bread(dev, bno);
    80002e24:	85a6                	mv	a1,s1
    80002e26:	855e                	mv	a0,s7
    80002e28:	d51ff0ef          	jal	80002b78 <bread>
    80002e2c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e2e:	40000613          	li	a2,1024
    80002e32:	4581                	li	a1,0
    80002e34:	05850513          	addi	a0,a0,88
    80002e38:	ec1fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	779000ef          	jal	80003db6 <log_write>
  brelse(bp);
    80002e42:	854a                	mv	a0,s2
    80002e44:	e3dff0ef          	jal	80002c80 <brelse>
}
    80002e48:	7942                	ld	s2,48(sp)
    80002e4a:	79a2                	ld	s3,40(sp)
    80002e4c:	7a02                	ld	s4,32(sp)
    80002e4e:	6ae2                	ld	s5,24(sp)
    80002e50:	6b42                	ld	s6,16(sp)
    80002e52:	6ba2                	ld	s7,8(sp)
    80002e54:	6c02                	ld	s8,0(sp)
}
    80002e56:	8526                	mv	a0,s1
    80002e58:	60a6                	ld	ra,72(sp)
    80002e5a:	6406                	ld	s0,64(sp)
    80002e5c:	74e2                	ld	s1,56(sp)
    80002e5e:	6161                	addi	sp,sp,80
    80002e60:	8082                	ret
    brelse(bp);
    80002e62:	854a                	mv	a0,s2
    80002e64:	e1dff0ef          	jal	80002c80 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e68:	015c0abb          	addw	s5,s8,s5
    80002e6c:	004b2783          	lw	a5,4(s6)
    80002e70:	04faf863          	bgeu	s5,a5,80002ec0 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002e74:	40dad59b          	sraiw	a1,s5,0xd
    80002e78:	01cb2783          	lw	a5,28(s6)
    80002e7c:	9dbd                	addw	a1,a1,a5
    80002e7e:	855e                	mv	a0,s7
    80002e80:	cf9ff0ef          	jal	80002b78 <bread>
    80002e84:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e86:	004b2503          	lw	a0,4(s6)
    80002e8a:	84d6                	mv	s1,s5
    80002e8c:	4701                	li	a4,0
    80002e8e:	fca4fae3          	bgeu	s1,a0,80002e62 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002e92:	00777693          	andi	a3,a4,7
    80002e96:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002e9a:	41f7579b          	sraiw	a5,a4,0x1f
    80002e9e:	01d7d79b          	srliw	a5,a5,0x1d
    80002ea2:	9fb9                	addw	a5,a5,a4
    80002ea4:	4037d79b          	sraiw	a5,a5,0x3
    80002ea8:	00f90633          	add	a2,s2,a5
    80002eac:	05864603          	lbu	a2,88(a2)
    80002eb0:	00c6f5b3          	and	a1,a3,a2
    80002eb4:	ddb1                	beqz	a1,80002e10 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002eb6:	2705                	addiw	a4,a4,1
    80002eb8:	2485                	addiw	s1,s1,1
    80002eba:	fd471ae3          	bne	a4,s4,80002e8e <balloc+0xb6>
    80002ebe:	b755                	j	80002e62 <balloc+0x8a>
    80002ec0:	7942                	ld	s2,48(sp)
    80002ec2:	79a2                	ld	s3,40(sp)
    80002ec4:	7a02                	ld	s4,32(sp)
    80002ec6:	6ae2                	ld	s5,24(sp)
    80002ec8:	6b42                	ld	s6,16(sp)
    80002eca:	6ba2                	ld	s7,8(sp)
    80002ecc:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002ece:	00005517          	auipc	a0,0x5
    80002ed2:	52250513          	addi	a0,a0,1314 # 800083f0 <etext+0x3f0>
    80002ed6:	e24fd0ef          	jal	800004fa <printf>
  return 0;
    80002eda:	4481                	li	s1,0
    80002edc:	bfad                	j	80002e56 <balloc+0x7e>

0000000080002ede <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ede:	7179                	addi	sp,sp,-48
    80002ee0:	f406                	sd	ra,40(sp)
    80002ee2:	f022                	sd	s0,32(sp)
    80002ee4:	ec26                	sd	s1,24(sp)
    80002ee6:	e84a                	sd	s2,16(sp)
    80002ee8:	e44e                	sd	s3,8(sp)
    80002eea:	1800                	addi	s0,sp,48
    80002eec:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002eee:	47ad                	li	a5,11
    80002ef0:	02b7e363          	bltu	a5,a1,80002f16 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002ef4:	02059793          	slli	a5,a1,0x20
    80002ef8:	01e7d593          	srli	a1,a5,0x1e
    80002efc:	00b509b3          	add	s3,a0,a1
    80002f00:	0509a483          	lw	s1,80(s3)
    80002f04:	e0b5                	bnez	s1,80002f68 <bmap+0x8a>
      addr = balloc(ip->dev);
    80002f06:	4108                	lw	a0,0(a0)
    80002f08:	ed1ff0ef          	jal	80002dd8 <balloc>
    80002f0c:	84aa                	mv	s1,a0
      if(addr == 0)
    80002f0e:	cd29                	beqz	a0,80002f68 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002f10:	04a9a823          	sw	a0,80(s3)
    80002f14:	a891                	j	80002f68 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f16:	ff45879b          	addiw	a5,a1,-12
    80002f1a:	873e                	mv	a4,a5
    80002f1c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002f1e:	0ff00793          	li	a5,255
    80002f22:	06e7e763          	bltu	a5,a4,80002f90 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f26:	08052483          	lw	s1,128(a0)
    80002f2a:	e891                	bnez	s1,80002f3e <bmap+0x60>
      addr = balloc(ip->dev);
    80002f2c:	4108                	lw	a0,0(a0)
    80002f2e:	eabff0ef          	jal	80002dd8 <balloc>
    80002f32:	84aa                	mv	s1,a0
      if(addr == 0)
    80002f34:	c915                	beqz	a0,80002f68 <bmap+0x8a>
    80002f36:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f38:	08a92023          	sw	a0,128(s2)
    80002f3c:	a011                	j	80002f40 <bmap+0x62>
    80002f3e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f40:	85a6                	mv	a1,s1
    80002f42:	00092503          	lw	a0,0(s2)
    80002f46:	c33ff0ef          	jal	80002b78 <bread>
    80002f4a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f4c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002f50:	02099713          	slli	a4,s3,0x20
    80002f54:	01e75593          	srli	a1,a4,0x1e
    80002f58:	97ae                	add	a5,a5,a1
    80002f5a:	89be                	mv	s3,a5
    80002f5c:	4384                	lw	s1,0(a5)
    80002f5e:	cc89                	beqz	s1,80002f78 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f60:	8552                	mv	a0,s4
    80002f62:	d1fff0ef          	jal	80002c80 <brelse>
    return addr;
    80002f66:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f68:	8526                	mv	a0,s1
    80002f6a:	70a2                	ld	ra,40(sp)
    80002f6c:	7402                	ld	s0,32(sp)
    80002f6e:	64e2                	ld	s1,24(sp)
    80002f70:	6942                	ld	s2,16(sp)
    80002f72:	69a2                	ld	s3,8(sp)
    80002f74:	6145                	addi	sp,sp,48
    80002f76:	8082                	ret
      addr = balloc(ip->dev);
    80002f78:	00092503          	lw	a0,0(s2)
    80002f7c:	e5dff0ef          	jal	80002dd8 <balloc>
    80002f80:	84aa                	mv	s1,a0
      if(addr){
    80002f82:	dd79                	beqz	a0,80002f60 <bmap+0x82>
        a[bn] = addr;
    80002f84:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002f88:	8552                	mv	a0,s4
    80002f8a:	62d000ef          	jal	80003db6 <log_write>
    80002f8e:	bfc9                	j	80002f60 <bmap+0x82>
    80002f90:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002f92:	00005517          	auipc	a0,0x5
    80002f96:	47650513          	addi	a0,a0,1142 # 80008408 <etext+0x408>
    80002f9a:	88bfd0ef          	jal	80000824 <panic>

0000000080002f9e <iget>:
{
    80002f9e:	7179                	addi	sp,sp,-48
    80002fa0:	f406                	sd	ra,40(sp)
    80002fa2:	f022                	sd	s0,32(sp)
    80002fa4:	ec26                	sd	s1,24(sp)
    80002fa6:	e84a                	sd	s2,16(sp)
    80002fa8:	e44e                	sd	s3,8(sp)
    80002faa:	e052                	sd	s4,0(sp)
    80002fac:	1800                	addi	s0,sp,48
    80002fae:	892a                	mv	s2,a0
    80002fb0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002fb2:	0001c517          	auipc	a0,0x1c
    80002fb6:	20e50513          	addi	a0,a0,526 # 8001f1c0 <itable>
    80002fba:	c6ffd0ef          	jal	80000c28 <acquire>
  empty = 0;
    80002fbe:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fc0:	0001c497          	auipc	s1,0x1c
    80002fc4:	21848493          	addi	s1,s1,536 # 8001f1d8 <itable+0x18>
    80002fc8:	0001e697          	auipc	a3,0x1e
    80002fcc:	ca068693          	addi	a3,a3,-864 # 80020c68 <log>
    80002fd0:	a809                	j	80002fe2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002fd2:	e781                	bnez	a5,80002fda <iget+0x3c>
    80002fd4:	00099363          	bnez	s3,80002fda <iget+0x3c>
      empty = ip;
    80002fd8:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002fda:	08848493          	addi	s1,s1,136
    80002fde:	02d48563          	beq	s1,a3,80003008 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002fe2:	449c                	lw	a5,8(s1)
    80002fe4:	fef057e3          	blez	a5,80002fd2 <iget+0x34>
    80002fe8:	4098                	lw	a4,0(s1)
    80002fea:	ff2718e3          	bne	a4,s2,80002fda <iget+0x3c>
    80002fee:	40d8                	lw	a4,4(s1)
    80002ff0:	ff4715e3          	bne	a4,s4,80002fda <iget+0x3c>
      ip->ref++;
    80002ff4:	2785                	addiw	a5,a5,1
    80002ff6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ff8:	0001c517          	auipc	a0,0x1c
    80002ffc:	1c850513          	addi	a0,a0,456 # 8001f1c0 <itable>
    80003000:	cbdfd0ef          	jal	80000cbc <release>
      return ip;
    80003004:	89a6                	mv	s3,s1
    80003006:	a015                	j	8000302a <iget+0x8c>
  if(empty == 0)
    80003008:	02098a63          	beqz	s3,8000303c <iget+0x9e>
  ip->dev = dev;
    8000300c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003010:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003014:	4785                	li	a5,1
    80003016:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000301a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000301e:	0001c517          	auipc	a0,0x1c
    80003022:	1a250513          	addi	a0,a0,418 # 8001f1c0 <itable>
    80003026:	c97fd0ef          	jal	80000cbc <release>
}
    8000302a:	854e                	mv	a0,s3
    8000302c:	70a2                	ld	ra,40(sp)
    8000302e:	7402                	ld	s0,32(sp)
    80003030:	64e2                	ld	s1,24(sp)
    80003032:	6942                	ld	s2,16(sp)
    80003034:	69a2                	ld	s3,8(sp)
    80003036:	6a02                	ld	s4,0(sp)
    80003038:	6145                	addi	sp,sp,48
    8000303a:	8082                	ret
    panic("iget: no inodes");
    8000303c:	00005517          	auipc	a0,0x5
    80003040:	3e450513          	addi	a0,a0,996 # 80008420 <etext+0x420>
    80003044:	fe0fd0ef          	jal	80000824 <panic>

0000000080003048 <iinit>:
{
    80003048:	7179                	addi	sp,sp,-48
    8000304a:	f406                	sd	ra,40(sp)
    8000304c:	f022                	sd	s0,32(sp)
    8000304e:	ec26                	sd	s1,24(sp)
    80003050:	e84a                	sd	s2,16(sp)
    80003052:	e44e                	sd	s3,8(sp)
    80003054:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003056:	00005597          	auipc	a1,0x5
    8000305a:	3da58593          	addi	a1,a1,986 # 80008430 <etext+0x430>
    8000305e:	0001c517          	auipc	a0,0x1c
    80003062:	16250513          	addi	a0,a0,354 # 8001f1c0 <itable>
    80003066:	b39fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    8000306a:	0001c497          	auipc	s1,0x1c
    8000306e:	17e48493          	addi	s1,s1,382 # 8001f1e8 <itable+0x28>
    80003072:	0001e997          	auipc	s3,0x1e
    80003076:	c0698993          	addi	s3,s3,-1018 # 80020c78 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000307a:	00005917          	auipc	s2,0x5
    8000307e:	3be90913          	addi	s2,s2,958 # 80008438 <etext+0x438>
    80003082:	85ca                	mv	a1,s2
    80003084:	8526                	mv	a0,s1
    80003086:	538010ef          	jal	800045be <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000308a:	08848493          	addi	s1,s1,136
    8000308e:	ff349ae3          	bne	s1,s3,80003082 <iinit+0x3a>
}
    80003092:	70a2                	ld	ra,40(sp)
    80003094:	7402                	ld	s0,32(sp)
    80003096:	64e2                	ld	s1,24(sp)
    80003098:	6942                	ld	s2,16(sp)
    8000309a:	69a2                	ld	s3,8(sp)
    8000309c:	6145                	addi	sp,sp,48
    8000309e:	8082                	ret

00000000800030a0 <ialloc>:
{
    800030a0:	7139                	addi	sp,sp,-64
    800030a2:	fc06                	sd	ra,56(sp)
    800030a4:	f822                	sd	s0,48(sp)
    800030a6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800030a8:	0001c717          	auipc	a4,0x1c
    800030ac:	10472703          	lw	a4,260(a4) # 8001f1ac <sb+0xc>
    800030b0:	4785                	li	a5,1
    800030b2:	06e7f063          	bgeu	a5,a4,80003112 <ialloc+0x72>
    800030b6:	f426                	sd	s1,40(sp)
    800030b8:	f04a                	sd	s2,32(sp)
    800030ba:	ec4e                	sd	s3,24(sp)
    800030bc:	e852                	sd	s4,16(sp)
    800030be:	e456                	sd	s5,8(sp)
    800030c0:	e05a                	sd	s6,0(sp)
    800030c2:	8aaa                	mv	s5,a0
    800030c4:	8b2e                	mv	s6,a1
    800030c6:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800030c8:	0001ca17          	auipc	s4,0x1c
    800030cc:	0d8a0a13          	addi	s4,s4,216 # 8001f1a0 <sb>
    800030d0:	00495593          	srli	a1,s2,0x4
    800030d4:	018a2783          	lw	a5,24(s4)
    800030d8:	9dbd                	addw	a1,a1,a5
    800030da:	8556                	mv	a0,s5
    800030dc:	a9dff0ef          	jal	80002b78 <bread>
    800030e0:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800030e2:	05850993          	addi	s3,a0,88
    800030e6:	00f97793          	andi	a5,s2,15
    800030ea:	079a                	slli	a5,a5,0x6
    800030ec:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800030ee:	00099783          	lh	a5,0(s3)
    800030f2:	cb9d                	beqz	a5,80003128 <ialloc+0x88>
    brelse(bp);
    800030f4:	b8dff0ef          	jal	80002c80 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800030f8:	0905                	addi	s2,s2,1
    800030fa:	00ca2703          	lw	a4,12(s4)
    800030fe:	0009079b          	sext.w	a5,s2
    80003102:	fce7e7e3          	bltu	a5,a4,800030d0 <ialloc+0x30>
    80003106:	74a2                	ld	s1,40(sp)
    80003108:	7902                	ld	s2,32(sp)
    8000310a:	69e2                	ld	s3,24(sp)
    8000310c:	6a42                	ld	s4,16(sp)
    8000310e:	6aa2                	ld	s5,8(sp)
    80003110:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003112:	00005517          	auipc	a0,0x5
    80003116:	32e50513          	addi	a0,a0,814 # 80008440 <etext+0x440>
    8000311a:	be0fd0ef          	jal	800004fa <printf>
  return 0;
    8000311e:	4501                	li	a0,0
}
    80003120:	70e2                	ld	ra,56(sp)
    80003122:	7442                	ld	s0,48(sp)
    80003124:	6121                	addi	sp,sp,64
    80003126:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003128:	04000613          	li	a2,64
    8000312c:	4581                	li	a1,0
    8000312e:	854e                	mv	a0,s3
    80003130:	bc9fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003134:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003138:	8526                	mv	a0,s1
    8000313a:	47d000ef          	jal	80003db6 <log_write>
      brelse(bp);
    8000313e:	8526                	mv	a0,s1
    80003140:	b41ff0ef          	jal	80002c80 <brelse>
      return iget(dev, inum);
    80003144:	0009059b          	sext.w	a1,s2
    80003148:	8556                	mv	a0,s5
    8000314a:	e55ff0ef          	jal	80002f9e <iget>
    8000314e:	74a2                	ld	s1,40(sp)
    80003150:	7902                	ld	s2,32(sp)
    80003152:	69e2                	ld	s3,24(sp)
    80003154:	6a42                	ld	s4,16(sp)
    80003156:	6aa2                	ld	s5,8(sp)
    80003158:	6b02                	ld	s6,0(sp)
    8000315a:	b7d9                	j	80003120 <ialloc+0x80>

000000008000315c <iupdate>:
{
    8000315c:	1101                	addi	sp,sp,-32
    8000315e:	ec06                	sd	ra,24(sp)
    80003160:	e822                	sd	s0,16(sp)
    80003162:	e426                	sd	s1,8(sp)
    80003164:	e04a                	sd	s2,0(sp)
    80003166:	1000                	addi	s0,sp,32
    80003168:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000316a:	415c                	lw	a5,4(a0)
    8000316c:	0047d79b          	srliw	a5,a5,0x4
    80003170:	0001c597          	auipc	a1,0x1c
    80003174:	0485a583          	lw	a1,72(a1) # 8001f1b8 <sb+0x18>
    80003178:	9dbd                	addw	a1,a1,a5
    8000317a:	4108                	lw	a0,0(a0)
    8000317c:	9fdff0ef          	jal	80002b78 <bread>
    80003180:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003182:	05850793          	addi	a5,a0,88
    80003186:	40d8                	lw	a4,4(s1)
    80003188:	8b3d                	andi	a4,a4,15
    8000318a:	071a                	slli	a4,a4,0x6
    8000318c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000318e:	04449703          	lh	a4,68(s1)
    80003192:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003196:	04649703          	lh	a4,70(s1)
    8000319a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000319e:	04849703          	lh	a4,72(s1)
    800031a2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800031a6:	04a49703          	lh	a4,74(s1)
    800031aa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800031ae:	44f8                	lw	a4,76(s1)
    800031b0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031b2:	03400613          	li	a2,52
    800031b6:	05048593          	addi	a1,s1,80
    800031ba:	00c78513          	addi	a0,a5,12
    800031be:	b9bfd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    800031c2:	854a                	mv	a0,s2
    800031c4:	3f3000ef          	jal	80003db6 <log_write>
  brelse(bp);
    800031c8:	854a                	mv	a0,s2
    800031ca:	ab7ff0ef          	jal	80002c80 <brelse>
}
    800031ce:	60e2                	ld	ra,24(sp)
    800031d0:	6442                	ld	s0,16(sp)
    800031d2:	64a2                	ld	s1,8(sp)
    800031d4:	6902                	ld	s2,0(sp)
    800031d6:	6105                	addi	sp,sp,32
    800031d8:	8082                	ret

00000000800031da <idup>:
{
    800031da:	1101                	addi	sp,sp,-32
    800031dc:	ec06                	sd	ra,24(sp)
    800031de:	e822                	sd	s0,16(sp)
    800031e0:	e426                	sd	s1,8(sp)
    800031e2:	1000                	addi	s0,sp,32
    800031e4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800031e6:	0001c517          	auipc	a0,0x1c
    800031ea:	fda50513          	addi	a0,a0,-38 # 8001f1c0 <itable>
    800031ee:	a3bfd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    800031f2:	449c                	lw	a5,8(s1)
    800031f4:	2785                	addiw	a5,a5,1
    800031f6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800031f8:	0001c517          	auipc	a0,0x1c
    800031fc:	fc850513          	addi	a0,a0,-56 # 8001f1c0 <itable>
    80003200:	abdfd0ef          	jal	80000cbc <release>
}
    80003204:	8526                	mv	a0,s1
    80003206:	60e2                	ld	ra,24(sp)
    80003208:	6442                	ld	s0,16(sp)
    8000320a:	64a2                	ld	s1,8(sp)
    8000320c:	6105                	addi	sp,sp,32
    8000320e:	8082                	ret

0000000080003210 <ilock>:
{
    80003210:	1101                	addi	sp,sp,-32
    80003212:	ec06                	sd	ra,24(sp)
    80003214:	e822                	sd	s0,16(sp)
    80003216:	e426                	sd	s1,8(sp)
    80003218:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000321a:	cd19                	beqz	a0,80003238 <ilock+0x28>
    8000321c:	84aa                	mv	s1,a0
    8000321e:	451c                	lw	a5,8(a0)
    80003220:	00f05c63          	blez	a5,80003238 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003224:	0541                	addi	a0,a0,16
    80003226:	3ce010ef          	jal	800045f4 <acquiresleep>
  if(ip->valid == 0){
    8000322a:	40bc                	lw	a5,64(s1)
    8000322c:	cf89                	beqz	a5,80003246 <ilock+0x36>
}
    8000322e:	60e2                	ld	ra,24(sp)
    80003230:	6442                	ld	s0,16(sp)
    80003232:	64a2                	ld	s1,8(sp)
    80003234:	6105                	addi	sp,sp,32
    80003236:	8082                	ret
    80003238:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000323a:	00005517          	auipc	a0,0x5
    8000323e:	21e50513          	addi	a0,a0,542 # 80008458 <etext+0x458>
    80003242:	de2fd0ef          	jal	80000824 <panic>
    80003246:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003248:	40dc                	lw	a5,4(s1)
    8000324a:	0047d79b          	srliw	a5,a5,0x4
    8000324e:	0001c597          	auipc	a1,0x1c
    80003252:	f6a5a583          	lw	a1,-150(a1) # 8001f1b8 <sb+0x18>
    80003256:	9dbd                	addw	a1,a1,a5
    80003258:	4088                	lw	a0,0(s1)
    8000325a:	91fff0ef          	jal	80002b78 <bread>
    8000325e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003260:	05850593          	addi	a1,a0,88
    80003264:	40dc                	lw	a5,4(s1)
    80003266:	8bbd                	andi	a5,a5,15
    80003268:	079a                	slli	a5,a5,0x6
    8000326a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000326c:	00059783          	lh	a5,0(a1)
    80003270:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003274:	00259783          	lh	a5,2(a1)
    80003278:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000327c:	00459783          	lh	a5,4(a1)
    80003280:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003284:	00659783          	lh	a5,6(a1)
    80003288:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000328c:	459c                	lw	a5,8(a1)
    8000328e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003290:	03400613          	li	a2,52
    80003294:	05b1                	addi	a1,a1,12
    80003296:	05048513          	addi	a0,s1,80
    8000329a:	abffd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    8000329e:	854a                	mv	a0,s2
    800032a0:	9e1ff0ef          	jal	80002c80 <brelse>
    ip->valid = 1;
    800032a4:	4785                	li	a5,1
    800032a6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800032a8:	04449783          	lh	a5,68(s1)
    800032ac:	c399                	beqz	a5,800032b2 <ilock+0xa2>
    800032ae:	6902                	ld	s2,0(sp)
    800032b0:	bfbd                	j	8000322e <ilock+0x1e>
      panic("ilock: no type");
    800032b2:	00005517          	auipc	a0,0x5
    800032b6:	1ae50513          	addi	a0,a0,430 # 80008460 <etext+0x460>
    800032ba:	d6afd0ef          	jal	80000824 <panic>

00000000800032be <iunlock>:
{
    800032be:	1101                	addi	sp,sp,-32
    800032c0:	ec06                	sd	ra,24(sp)
    800032c2:	e822                	sd	s0,16(sp)
    800032c4:	e426                	sd	s1,8(sp)
    800032c6:	e04a                	sd	s2,0(sp)
    800032c8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032ca:	c505                	beqz	a0,800032f2 <iunlock+0x34>
    800032cc:	84aa                	mv	s1,a0
    800032ce:	01050913          	addi	s2,a0,16
    800032d2:	854a                	mv	a0,s2
    800032d4:	39e010ef          	jal	80004672 <holdingsleep>
    800032d8:	cd09                	beqz	a0,800032f2 <iunlock+0x34>
    800032da:	449c                	lw	a5,8(s1)
    800032dc:	00f05b63          	blez	a5,800032f2 <iunlock+0x34>
  releasesleep(&ip->lock);
    800032e0:	854a                	mv	a0,s2
    800032e2:	358010ef          	jal	8000463a <releasesleep>
}
    800032e6:	60e2                	ld	ra,24(sp)
    800032e8:	6442                	ld	s0,16(sp)
    800032ea:	64a2                	ld	s1,8(sp)
    800032ec:	6902                	ld	s2,0(sp)
    800032ee:	6105                	addi	sp,sp,32
    800032f0:	8082                	ret
    panic("iunlock");
    800032f2:	00005517          	auipc	a0,0x5
    800032f6:	17e50513          	addi	a0,a0,382 # 80008470 <etext+0x470>
    800032fa:	d2afd0ef          	jal	80000824 <panic>

00000000800032fe <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800032fe:	7179                	addi	sp,sp,-48
    80003300:	f406                	sd	ra,40(sp)
    80003302:	f022                	sd	s0,32(sp)
    80003304:	ec26                	sd	s1,24(sp)
    80003306:	e84a                	sd	s2,16(sp)
    80003308:	e44e                	sd	s3,8(sp)
    8000330a:	1800                	addi	s0,sp,48
    8000330c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000330e:	05050493          	addi	s1,a0,80
    80003312:	08050913          	addi	s2,a0,128
    80003316:	a021                	j	8000331e <itrunc+0x20>
    80003318:	0491                	addi	s1,s1,4
    8000331a:	01248b63          	beq	s1,s2,80003330 <itrunc+0x32>
    if(ip->addrs[i]){
    8000331e:	408c                	lw	a1,0(s1)
    80003320:	dde5                	beqz	a1,80003318 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003322:	0009a503          	lw	a0,0(s3)
    80003326:	a47ff0ef          	jal	80002d6c <bfree>
      ip->addrs[i] = 0;
    8000332a:	0004a023          	sw	zero,0(s1)
    8000332e:	b7ed                	j	80003318 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003330:	0809a583          	lw	a1,128(s3)
    80003334:	ed89                	bnez	a1,8000334e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003336:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000333a:	854e                	mv	a0,s3
    8000333c:	e21ff0ef          	jal	8000315c <iupdate>
}
    80003340:	70a2                	ld	ra,40(sp)
    80003342:	7402                	ld	s0,32(sp)
    80003344:	64e2                	ld	s1,24(sp)
    80003346:	6942                	ld	s2,16(sp)
    80003348:	69a2                	ld	s3,8(sp)
    8000334a:	6145                	addi	sp,sp,48
    8000334c:	8082                	ret
    8000334e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003350:	0009a503          	lw	a0,0(s3)
    80003354:	825ff0ef          	jal	80002b78 <bread>
    80003358:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000335a:	05850493          	addi	s1,a0,88
    8000335e:	45850913          	addi	s2,a0,1112
    80003362:	a021                	j	8000336a <itrunc+0x6c>
    80003364:	0491                	addi	s1,s1,4
    80003366:	01248963          	beq	s1,s2,80003378 <itrunc+0x7a>
      if(a[j])
    8000336a:	408c                	lw	a1,0(s1)
    8000336c:	dde5                	beqz	a1,80003364 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000336e:	0009a503          	lw	a0,0(s3)
    80003372:	9fbff0ef          	jal	80002d6c <bfree>
    80003376:	b7fd                	j	80003364 <itrunc+0x66>
    brelse(bp);
    80003378:	8552                	mv	a0,s4
    8000337a:	907ff0ef          	jal	80002c80 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000337e:	0809a583          	lw	a1,128(s3)
    80003382:	0009a503          	lw	a0,0(s3)
    80003386:	9e7ff0ef          	jal	80002d6c <bfree>
    ip->addrs[NDIRECT] = 0;
    8000338a:	0809a023          	sw	zero,128(s3)
    8000338e:	6a02                	ld	s4,0(sp)
    80003390:	b75d                	j	80003336 <itrunc+0x38>

0000000080003392 <iput>:
{
    80003392:	1101                	addi	sp,sp,-32
    80003394:	ec06                	sd	ra,24(sp)
    80003396:	e822                	sd	s0,16(sp)
    80003398:	e426                	sd	s1,8(sp)
    8000339a:	1000                	addi	s0,sp,32
    8000339c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000339e:	0001c517          	auipc	a0,0x1c
    800033a2:	e2250513          	addi	a0,a0,-478 # 8001f1c0 <itable>
    800033a6:	883fd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033aa:	4498                	lw	a4,8(s1)
    800033ac:	4785                	li	a5,1
    800033ae:	02f70063          	beq	a4,a5,800033ce <iput+0x3c>
  ip->ref--;
    800033b2:	449c                	lw	a5,8(s1)
    800033b4:	37fd                	addiw	a5,a5,-1
    800033b6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033b8:	0001c517          	auipc	a0,0x1c
    800033bc:	e0850513          	addi	a0,a0,-504 # 8001f1c0 <itable>
    800033c0:	8fdfd0ef          	jal	80000cbc <release>
}
    800033c4:	60e2                	ld	ra,24(sp)
    800033c6:	6442                	ld	s0,16(sp)
    800033c8:	64a2                	ld	s1,8(sp)
    800033ca:	6105                	addi	sp,sp,32
    800033cc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800033ce:	40bc                	lw	a5,64(s1)
    800033d0:	d3ed                	beqz	a5,800033b2 <iput+0x20>
    800033d2:	04a49783          	lh	a5,74(s1)
    800033d6:	fff1                	bnez	a5,800033b2 <iput+0x20>
    800033d8:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800033da:	01048793          	addi	a5,s1,16
    800033de:	893e                	mv	s2,a5
    800033e0:	853e                	mv	a0,a5
    800033e2:	212010ef          	jal	800045f4 <acquiresleep>
    release(&itable.lock);
    800033e6:	0001c517          	auipc	a0,0x1c
    800033ea:	dda50513          	addi	a0,a0,-550 # 8001f1c0 <itable>
    800033ee:	8cffd0ef          	jal	80000cbc <release>
    itrunc(ip);
    800033f2:	8526                	mv	a0,s1
    800033f4:	f0bff0ef          	jal	800032fe <itrunc>
    ip->type = 0;
    800033f8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800033fc:	8526                	mv	a0,s1
    800033fe:	d5fff0ef          	jal	8000315c <iupdate>
    ip->valid = 0;
    80003402:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003406:	854a                	mv	a0,s2
    80003408:	232010ef          	jal	8000463a <releasesleep>
    acquire(&itable.lock);
    8000340c:	0001c517          	auipc	a0,0x1c
    80003410:	db450513          	addi	a0,a0,-588 # 8001f1c0 <itable>
    80003414:	815fd0ef          	jal	80000c28 <acquire>
    80003418:	6902                	ld	s2,0(sp)
    8000341a:	bf61                	j	800033b2 <iput+0x20>

000000008000341c <iunlockput>:
{
    8000341c:	1101                	addi	sp,sp,-32
    8000341e:	ec06                	sd	ra,24(sp)
    80003420:	e822                	sd	s0,16(sp)
    80003422:	e426                	sd	s1,8(sp)
    80003424:	1000                	addi	s0,sp,32
    80003426:	84aa                	mv	s1,a0
  iunlock(ip);
    80003428:	e97ff0ef          	jal	800032be <iunlock>
  iput(ip);
    8000342c:	8526                	mv	a0,s1
    8000342e:	f65ff0ef          	jal	80003392 <iput>
}
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6105                	addi	sp,sp,32
    8000343a:	8082                	ret

000000008000343c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000343c:	0001c717          	auipc	a4,0x1c
    80003440:	d7072703          	lw	a4,-656(a4) # 8001f1ac <sb+0xc>
    80003444:	4785                	li	a5,1
    80003446:	0ae7fe63          	bgeu	a5,a4,80003502 <ireclaim+0xc6>
{
    8000344a:	7139                	addi	sp,sp,-64
    8000344c:	fc06                	sd	ra,56(sp)
    8000344e:	f822                	sd	s0,48(sp)
    80003450:	f426                	sd	s1,40(sp)
    80003452:	f04a                	sd	s2,32(sp)
    80003454:	ec4e                	sd	s3,24(sp)
    80003456:	e852                	sd	s4,16(sp)
    80003458:	e456                	sd	s5,8(sp)
    8000345a:	e05a                	sd	s6,0(sp)
    8000345c:	0080                	addi	s0,sp,64
    8000345e:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003460:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003462:	0001ca17          	auipc	s4,0x1c
    80003466:	d3ea0a13          	addi	s4,s4,-706 # 8001f1a0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    8000346a:	00005b17          	auipc	s6,0x5
    8000346e:	00eb0b13          	addi	s6,s6,14 # 80008478 <etext+0x478>
    80003472:	a099                	j	800034b8 <ireclaim+0x7c>
    80003474:	85ce                	mv	a1,s3
    80003476:	855a                	mv	a0,s6
    80003478:	882fd0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    8000347c:	85ce                	mv	a1,s3
    8000347e:	8556                	mv	a0,s5
    80003480:	b1fff0ef          	jal	80002f9e <iget>
    80003484:	89aa                	mv	s3,a0
    brelse(bp);
    80003486:	854a                	mv	a0,s2
    80003488:	ff8ff0ef          	jal	80002c80 <brelse>
    if (ip) {
    8000348c:	00098f63          	beqz	s3,800034aa <ireclaim+0x6e>
      begin_op();
    80003490:	78c000ef          	jal	80003c1c <begin_op>
      ilock(ip);
    80003494:	854e                	mv	a0,s3
    80003496:	d7bff0ef          	jal	80003210 <ilock>
      iunlock(ip);
    8000349a:	854e                	mv	a0,s3
    8000349c:	e23ff0ef          	jal	800032be <iunlock>
      iput(ip);
    800034a0:	854e                	mv	a0,s3
    800034a2:	ef1ff0ef          	jal	80003392 <iput>
      end_op();
    800034a6:	7e6000ef          	jal	80003c8c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034aa:	0485                	addi	s1,s1,1
    800034ac:	00ca2703          	lw	a4,12(s4)
    800034b0:	0004879b          	sext.w	a5,s1
    800034b4:	02e7fd63          	bgeu	a5,a4,800034ee <ireclaim+0xb2>
    800034b8:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034bc:	0044d593          	srli	a1,s1,0x4
    800034c0:	018a2783          	lw	a5,24(s4)
    800034c4:	9dbd                	addw	a1,a1,a5
    800034c6:	8556                	mv	a0,s5
    800034c8:	eb0ff0ef          	jal	80002b78 <bread>
    800034cc:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800034ce:	05850793          	addi	a5,a0,88
    800034d2:	00f9f713          	andi	a4,s3,15
    800034d6:	071a                	slli	a4,a4,0x6
    800034d8:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800034da:	00079703          	lh	a4,0(a5)
    800034de:	c701                	beqz	a4,800034e6 <ireclaim+0xaa>
    800034e0:	00679783          	lh	a5,6(a5)
    800034e4:	dbc1                	beqz	a5,80003474 <ireclaim+0x38>
    brelse(bp);
    800034e6:	854a                	mv	a0,s2
    800034e8:	f98ff0ef          	jal	80002c80 <brelse>
    if (ip) {
    800034ec:	bf7d                	j	800034aa <ireclaim+0x6e>
}
    800034ee:	70e2                	ld	ra,56(sp)
    800034f0:	7442                	ld	s0,48(sp)
    800034f2:	74a2                	ld	s1,40(sp)
    800034f4:	7902                	ld	s2,32(sp)
    800034f6:	69e2                	ld	s3,24(sp)
    800034f8:	6a42                	ld	s4,16(sp)
    800034fa:	6aa2                	ld	s5,8(sp)
    800034fc:	6b02                	ld	s6,0(sp)
    800034fe:	6121                	addi	sp,sp,64
    80003500:	8082                	ret
    80003502:	8082                	ret

0000000080003504 <fsinit>:
fsinit(int dev) {
    80003504:	1101                	addi	sp,sp,-32
    80003506:	ec06                	sd	ra,24(sp)
    80003508:	e822                	sd	s0,16(sp)
    8000350a:	e426                	sd	s1,8(sp)
    8000350c:	e04a                	sd	s2,0(sp)
    8000350e:	1000                	addi	s0,sp,32
    80003510:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003512:	4585                	li	a1,1
    80003514:	e64ff0ef          	jal	80002b78 <bread>
    80003518:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000351a:	02000613          	li	a2,32
    8000351e:	05850593          	addi	a1,a0,88
    80003522:	0001c517          	auipc	a0,0x1c
    80003526:	c7e50513          	addi	a0,a0,-898 # 8001f1a0 <sb>
    8000352a:	82ffd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    8000352e:	8526                	mv	a0,s1
    80003530:	f50ff0ef          	jal	80002c80 <brelse>
  if(sb.magic != FSMAGIC)
    80003534:	0001c717          	auipc	a4,0x1c
    80003538:	c6c72703          	lw	a4,-916(a4) # 8001f1a0 <sb>
    8000353c:	102037b7          	lui	a5,0x10203
    80003540:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003544:	02f71263          	bne	a4,a5,80003568 <fsinit+0x64>
  initlog(dev, &sb);
    80003548:	0001c597          	auipc	a1,0x1c
    8000354c:	c5858593          	addi	a1,a1,-936 # 8001f1a0 <sb>
    80003550:	854a                	mv	a0,s2
    80003552:	648000ef          	jal	80003b9a <initlog>
  ireclaim(dev);
    80003556:	854a                	mv	a0,s2
    80003558:	ee5ff0ef          	jal	8000343c <ireclaim>
}
    8000355c:	60e2                	ld	ra,24(sp)
    8000355e:	6442                	ld	s0,16(sp)
    80003560:	64a2                	ld	s1,8(sp)
    80003562:	6902                	ld	s2,0(sp)
    80003564:	6105                	addi	sp,sp,32
    80003566:	8082                	ret
    panic("invalid file system");
    80003568:	00005517          	auipc	a0,0x5
    8000356c:	f3050513          	addi	a0,a0,-208 # 80008498 <etext+0x498>
    80003570:	ab4fd0ef          	jal	80000824 <panic>

0000000080003574 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003574:	1141                	addi	sp,sp,-16
    80003576:	e406                	sd	ra,8(sp)
    80003578:	e022                	sd	s0,0(sp)
    8000357a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000357c:	411c                	lw	a5,0(a0)
    8000357e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003580:	415c                	lw	a5,4(a0)
    80003582:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003584:	04451783          	lh	a5,68(a0)
    80003588:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000358c:	04a51783          	lh	a5,74(a0)
    80003590:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003594:	04c56783          	lwu	a5,76(a0)
    80003598:	e99c                	sd	a5,16(a1)
}
    8000359a:	60a2                	ld	ra,8(sp)
    8000359c:	6402                	ld	s0,0(sp)
    8000359e:	0141                	addi	sp,sp,16
    800035a0:	8082                	ret

00000000800035a2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800035a2:	457c                	lw	a5,76(a0)
    800035a4:	0ed7e663          	bltu	a5,a3,80003690 <readi+0xee>
{
    800035a8:	7159                	addi	sp,sp,-112
    800035aa:	f486                	sd	ra,104(sp)
    800035ac:	f0a2                	sd	s0,96(sp)
    800035ae:	eca6                	sd	s1,88(sp)
    800035b0:	e0d2                	sd	s4,64(sp)
    800035b2:	fc56                	sd	s5,56(sp)
    800035b4:	f85a                	sd	s6,48(sp)
    800035b6:	f45e                	sd	s7,40(sp)
    800035b8:	1880                	addi	s0,sp,112
    800035ba:	8b2a                	mv	s6,a0
    800035bc:	8bae                	mv	s7,a1
    800035be:	8a32                	mv	s4,a2
    800035c0:	84b6                	mv	s1,a3
    800035c2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800035c4:	9f35                	addw	a4,a4,a3
    return 0;
    800035c6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800035c8:	0ad76b63          	bltu	a4,a3,8000367e <readi+0xdc>
    800035cc:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800035ce:	00e7f463          	bgeu	a5,a4,800035d6 <readi+0x34>
    n = ip->size - off;
    800035d2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035d6:	080a8b63          	beqz	s5,8000366c <readi+0xca>
    800035da:	e8ca                	sd	s2,80(sp)
    800035dc:	f062                	sd	s8,32(sp)
    800035de:	ec66                	sd	s9,24(sp)
    800035e0:	e86a                	sd	s10,16(sp)
    800035e2:	e46e                	sd	s11,8(sp)
    800035e4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800035e6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800035ea:	5c7d                	li	s8,-1
    800035ec:	a80d                	j	8000361e <readi+0x7c>
    800035ee:	020d1d93          	slli	s11,s10,0x20
    800035f2:	020ddd93          	srli	s11,s11,0x20
    800035f6:	05890613          	addi	a2,s2,88
    800035fa:	86ee                	mv	a3,s11
    800035fc:	963e                	add	a2,a2,a5
    800035fe:	85d2                	mv	a1,s4
    80003600:	855e                	mv	a0,s7
    80003602:	c89fe0ef          	jal	8000228a <either_copyout>
    80003606:	05850363          	beq	a0,s8,8000364c <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000360a:	854a                	mv	a0,s2
    8000360c:	e74ff0ef          	jal	80002c80 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003610:	013d09bb          	addw	s3,s10,s3
    80003614:	009d04bb          	addw	s1,s10,s1
    80003618:	9a6e                	add	s4,s4,s11
    8000361a:	0559f363          	bgeu	s3,s5,80003660 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000361e:	00a4d59b          	srliw	a1,s1,0xa
    80003622:	855a                	mv	a0,s6
    80003624:	8bbff0ef          	jal	80002ede <bmap>
    80003628:	85aa                	mv	a1,a0
    if(addr == 0)
    8000362a:	c139                	beqz	a0,80003670 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000362c:	000b2503          	lw	a0,0(s6)
    80003630:	d48ff0ef          	jal	80002b78 <bread>
    80003634:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003636:	3ff4f793          	andi	a5,s1,1023
    8000363a:	40fc873b          	subw	a4,s9,a5
    8000363e:	413a86bb          	subw	a3,s5,s3
    80003642:	8d3a                	mv	s10,a4
    80003644:	fae6f5e3          	bgeu	a3,a4,800035ee <readi+0x4c>
    80003648:	8d36                	mv	s10,a3
    8000364a:	b755                	j	800035ee <readi+0x4c>
      brelse(bp);
    8000364c:	854a                	mv	a0,s2
    8000364e:	e32ff0ef          	jal	80002c80 <brelse>
      tot = -1;
    80003652:	59fd                	li	s3,-1
      break;
    80003654:	6946                	ld	s2,80(sp)
    80003656:	7c02                	ld	s8,32(sp)
    80003658:	6ce2                	ld	s9,24(sp)
    8000365a:	6d42                	ld	s10,16(sp)
    8000365c:	6da2                	ld	s11,8(sp)
    8000365e:	a831                	j	8000367a <readi+0xd8>
    80003660:	6946                	ld	s2,80(sp)
    80003662:	7c02                	ld	s8,32(sp)
    80003664:	6ce2                	ld	s9,24(sp)
    80003666:	6d42                	ld	s10,16(sp)
    80003668:	6da2                	ld	s11,8(sp)
    8000366a:	a801                	j	8000367a <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000366c:	89d6                	mv	s3,s5
    8000366e:	a031                	j	8000367a <readi+0xd8>
    80003670:	6946                	ld	s2,80(sp)
    80003672:	7c02                	ld	s8,32(sp)
    80003674:	6ce2                	ld	s9,24(sp)
    80003676:	6d42                	ld	s10,16(sp)
    80003678:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000367a:	854e                	mv	a0,s3
    8000367c:	69a6                	ld	s3,72(sp)
}
    8000367e:	70a6                	ld	ra,104(sp)
    80003680:	7406                	ld	s0,96(sp)
    80003682:	64e6                	ld	s1,88(sp)
    80003684:	6a06                	ld	s4,64(sp)
    80003686:	7ae2                	ld	s5,56(sp)
    80003688:	7b42                	ld	s6,48(sp)
    8000368a:	7ba2                	ld	s7,40(sp)
    8000368c:	6165                	addi	sp,sp,112
    8000368e:	8082                	ret
    return 0;
    80003690:	4501                	li	a0,0
}
    80003692:	8082                	ret

0000000080003694 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003694:	457c                	lw	a5,76(a0)
    80003696:	0ed7eb63          	bltu	a5,a3,8000378c <writei+0xf8>
{
    8000369a:	7159                	addi	sp,sp,-112
    8000369c:	f486                	sd	ra,104(sp)
    8000369e:	f0a2                	sd	s0,96(sp)
    800036a0:	e8ca                	sd	s2,80(sp)
    800036a2:	e0d2                	sd	s4,64(sp)
    800036a4:	fc56                	sd	s5,56(sp)
    800036a6:	f85a                	sd	s6,48(sp)
    800036a8:	f45e                	sd	s7,40(sp)
    800036aa:	1880                	addi	s0,sp,112
    800036ac:	8aaa                	mv	s5,a0
    800036ae:	8bae                	mv	s7,a1
    800036b0:	8a32                	mv	s4,a2
    800036b2:	8936                	mv	s2,a3
    800036b4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036b6:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800036ba:	00043737          	lui	a4,0x43
    800036be:	0cf76963          	bltu	a4,a5,80003790 <writei+0xfc>
    800036c2:	0cd7e763          	bltu	a5,a3,80003790 <writei+0xfc>
    800036c6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800036c8:	0a0b0a63          	beqz	s6,8000377c <writei+0xe8>
    800036cc:	eca6                	sd	s1,88(sp)
    800036ce:	f062                	sd	s8,32(sp)
    800036d0:	ec66                	sd	s9,24(sp)
    800036d2:	e86a                	sd	s10,16(sp)
    800036d4:	e46e                	sd	s11,8(sp)
    800036d6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800036d8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800036dc:	5c7d                	li	s8,-1
    800036de:	a825                	j	80003716 <writei+0x82>
    800036e0:	020d1d93          	slli	s11,s10,0x20
    800036e4:	020ddd93          	srli	s11,s11,0x20
    800036e8:	05848513          	addi	a0,s1,88
    800036ec:	86ee                	mv	a3,s11
    800036ee:	8652                	mv	a2,s4
    800036f0:	85de                	mv	a1,s7
    800036f2:	953e                	add	a0,a0,a5
    800036f4:	be1fe0ef          	jal	800022d4 <either_copyin>
    800036f8:	05850663          	beq	a0,s8,80003744 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    800036fc:	8526                	mv	a0,s1
    800036fe:	6b8000ef          	jal	80003db6 <log_write>
    brelse(bp);
    80003702:	8526                	mv	a0,s1
    80003704:	d7cff0ef          	jal	80002c80 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003708:	013d09bb          	addw	s3,s10,s3
    8000370c:	012d093b          	addw	s2,s10,s2
    80003710:	9a6e                	add	s4,s4,s11
    80003712:	0369fc63          	bgeu	s3,s6,8000374a <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003716:	00a9559b          	srliw	a1,s2,0xa
    8000371a:	8556                	mv	a0,s5
    8000371c:	fc2ff0ef          	jal	80002ede <bmap>
    80003720:	85aa                	mv	a1,a0
    if(addr == 0)
    80003722:	c505                	beqz	a0,8000374a <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003724:	000aa503          	lw	a0,0(s5)
    80003728:	c50ff0ef          	jal	80002b78 <bread>
    8000372c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000372e:	3ff97793          	andi	a5,s2,1023
    80003732:	40fc873b          	subw	a4,s9,a5
    80003736:	413b06bb          	subw	a3,s6,s3
    8000373a:	8d3a                	mv	s10,a4
    8000373c:	fae6f2e3          	bgeu	a3,a4,800036e0 <writei+0x4c>
    80003740:	8d36                	mv	s10,a3
    80003742:	bf79                	j	800036e0 <writei+0x4c>
      brelse(bp);
    80003744:	8526                	mv	a0,s1
    80003746:	d3aff0ef          	jal	80002c80 <brelse>
  }

  if(off > ip->size)
    8000374a:	04caa783          	lw	a5,76(s5)
    8000374e:	0327f963          	bgeu	a5,s2,80003780 <writei+0xec>
    ip->size = off;
    80003752:	052aa623          	sw	s2,76(s5)
    80003756:	64e6                	ld	s1,88(sp)
    80003758:	7c02                	ld	s8,32(sp)
    8000375a:	6ce2                	ld	s9,24(sp)
    8000375c:	6d42                	ld	s10,16(sp)
    8000375e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003760:	8556                	mv	a0,s5
    80003762:	9fbff0ef          	jal	8000315c <iupdate>

  return tot;
    80003766:	854e                	mv	a0,s3
    80003768:	69a6                	ld	s3,72(sp)
}
    8000376a:	70a6                	ld	ra,104(sp)
    8000376c:	7406                	ld	s0,96(sp)
    8000376e:	6946                	ld	s2,80(sp)
    80003770:	6a06                	ld	s4,64(sp)
    80003772:	7ae2                	ld	s5,56(sp)
    80003774:	7b42                	ld	s6,48(sp)
    80003776:	7ba2                	ld	s7,40(sp)
    80003778:	6165                	addi	sp,sp,112
    8000377a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000377c:	89da                	mv	s3,s6
    8000377e:	b7cd                	j	80003760 <writei+0xcc>
    80003780:	64e6                	ld	s1,88(sp)
    80003782:	7c02                	ld	s8,32(sp)
    80003784:	6ce2                	ld	s9,24(sp)
    80003786:	6d42                	ld	s10,16(sp)
    80003788:	6da2                	ld	s11,8(sp)
    8000378a:	bfd9                	j	80003760 <writei+0xcc>
    return -1;
    8000378c:	557d                	li	a0,-1
}
    8000378e:	8082                	ret
    return -1;
    80003790:	557d                	li	a0,-1
    80003792:	bfe1                	j	8000376a <writei+0xd6>

0000000080003794 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003794:	1141                	addi	sp,sp,-16
    80003796:	e406                	sd	ra,8(sp)
    80003798:	e022                	sd	s0,0(sp)
    8000379a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000379c:	4639                	li	a2,14
    8000379e:	e2efd0ef          	jal	80000dcc <strncmp>
}
    800037a2:	60a2                	ld	ra,8(sp)
    800037a4:	6402                	ld	s0,0(sp)
    800037a6:	0141                	addi	sp,sp,16
    800037a8:	8082                	ret

00000000800037aa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037aa:	711d                	addi	sp,sp,-96
    800037ac:	ec86                	sd	ra,88(sp)
    800037ae:	e8a2                	sd	s0,80(sp)
    800037b0:	e4a6                	sd	s1,72(sp)
    800037b2:	e0ca                	sd	s2,64(sp)
    800037b4:	fc4e                	sd	s3,56(sp)
    800037b6:	f852                	sd	s4,48(sp)
    800037b8:	f456                	sd	s5,40(sp)
    800037ba:	f05a                	sd	s6,32(sp)
    800037bc:	ec5e                	sd	s7,24(sp)
    800037be:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800037c0:	04451703          	lh	a4,68(a0)
    800037c4:	4785                	li	a5,1
    800037c6:	00f71f63          	bne	a4,a5,800037e4 <dirlookup+0x3a>
    800037ca:	892a                	mv	s2,a0
    800037cc:	8aae                	mv	s5,a1
    800037ce:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800037d0:	457c                	lw	a5,76(a0)
    800037d2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037d4:	fa040a13          	addi	s4,s0,-96
    800037d8:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800037da:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800037de:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037e0:	e39d                	bnez	a5,80003806 <dirlookup+0x5c>
    800037e2:	a8b9                	j	80003840 <dirlookup+0x96>
    panic("dirlookup not DIR");
    800037e4:	00005517          	auipc	a0,0x5
    800037e8:	ccc50513          	addi	a0,a0,-820 # 800084b0 <etext+0x4b0>
    800037ec:	838fd0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    800037f0:	00005517          	auipc	a0,0x5
    800037f4:	cd850513          	addi	a0,a0,-808 # 800084c8 <etext+0x4c8>
    800037f8:	82cfd0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800037fc:	24c1                	addiw	s1,s1,16
    800037fe:	04c92783          	lw	a5,76(s2)
    80003802:	02f4fe63          	bgeu	s1,a5,8000383e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003806:	874e                	mv	a4,s3
    80003808:	86a6                	mv	a3,s1
    8000380a:	8652                	mv	a2,s4
    8000380c:	4581                	li	a1,0
    8000380e:	854a                	mv	a0,s2
    80003810:	d93ff0ef          	jal	800035a2 <readi>
    80003814:	fd351ee3          	bne	a0,s3,800037f0 <dirlookup+0x46>
    if(de.inum == 0)
    80003818:	fa045783          	lhu	a5,-96(s0)
    8000381c:	d3e5                	beqz	a5,800037fc <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    8000381e:	85da                	mv	a1,s6
    80003820:	8556                	mv	a0,s5
    80003822:	f73ff0ef          	jal	80003794 <namecmp>
    80003826:	f979                	bnez	a0,800037fc <dirlookup+0x52>
      if(poff)
    80003828:	000b8463          	beqz	s7,80003830 <dirlookup+0x86>
        *poff = off;
    8000382c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003830:	fa045583          	lhu	a1,-96(s0)
    80003834:	00092503          	lw	a0,0(s2)
    80003838:	f66ff0ef          	jal	80002f9e <iget>
    8000383c:	a011                	j	80003840 <dirlookup+0x96>
  return 0;
    8000383e:	4501                	li	a0,0
}
    80003840:	60e6                	ld	ra,88(sp)
    80003842:	6446                	ld	s0,80(sp)
    80003844:	64a6                	ld	s1,72(sp)
    80003846:	6906                	ld	s2,64(sp)
    80003848:	79e2                	ld	s3,56(sp)
    8000384a:	7a42                	ld	s4,48(sp)
    8000384c:	7aa2                	ld	s5,40(sp)
    8000384e:	7b02                	ld	s6,32(sp)
    80003850:	6be2                	ld	s7,24(sp)
    80003852:	6125                	addi	sp,sp,96
    80003854:	8082                	ret

0000000080003856 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003856:	711d                	addi	sp,sp,-96
    80003858:	ec86                	sd	ra,88(sp)
    8000385a:	e8a2                	sd	s0,80(sp)
    8000385c:	e4a6                	sd	s1,72(sp)
    8000385e:	e0ca                	sd	s2,64(sp)
    80003860:	fc4e                	sd	s3,56(sp)
    80003862:	f852                	sd	s4,48(sp)
    80003864:	f456                	sd	s5,40(sp)
    80003866:	f05a                	sd	s6,32(sp)
    80003868:	ec5e                	sd	s7,24(sp)
    8000386a:	e862                	sd	s8,16(sp)
    8000386c:	e466                	sd	s9,8(sp)
    8000386e:	e06a                	sd	s10,0(sp)
    80003870:	1080                	addi	s0,sp,96
    80003872:	84aa                	mv	s1,a0
    80003874:	8b2e                	mv	s6,a1
    80003876:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003878:	00054703          	lbu	a4,0(a0)
    8000387c:	02f00793          	li	a5,47
    80003880:	00f70f63          	beq	a4,a5,8000389e <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003884:	8aefe0ef          	jal	80001932 <myproc>
    80003888:	15053503          	ld	a0,336(a0)
    8000388c:	94fff0ef          	jal	800031da <idup>
    80003890:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003892:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80003896:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003898:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000389a:	4b85                	li	s7,1
    8000389c:	a879                	j	8000393a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    8000389e:	4585                	li	a1,1
    800038a0:	852e                	mv	a0,a1
    800038a2:	efcff0ef          	jal	80002f9e <iget>
    800038a6:	8a2a                	mv	s4,a0
    800038a8:	b7ed                	j	80003892 <namex+0x3c>
      iunlockput(ip);
    800038aa:	8552                	mv	a0,s4
    800038ac:	b71ff0ef          	jal	8000341c <iunlockput>
      return 0;
    800038b0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800038b2:	8552                	mv	a0,s4
    800038b4:	60e6                	ld	ra,88(sp)
    800038b6:	6446                	ld	s0,80(sp)
    800038b8:	64a6                	ld	s1,72(sp)
    800038ba:	6906                	ld	s2,64(sp)
    800038bc:	79e2                	ld	s3,56(sp)
    800038be:	7a42                	ld	s4,48(sp)
    800038c0:	7aa2                	ld	s5,40(sp)
    800038c2:	7b02                	ld	s6,32(sp)
    800038c4:	6be2                	ld	s7,24(sp)
    800038c6:	6c42                	ld	s8,16(sp)
    800038c8:	6ca2                	ld	s9,8(sp)
    800038ca:	6d02                	ld	s10,0(sp)
    800038cc:	6125                	addi	sp,sp,96
    800038ce:	8082                	ret
      iunlock(ip);
    800038d0:	8552                	mv	a0,s4
    800038d2:	9edff0ef          	jal	800032be <iunlock>
      return ip;
    800038d6:	bff1                	j	800038b2 <namex+0x5c>
      iunlockput(ip);
    800038d8:	8552                	mv	a0,s4
    800038da:	b43ff0ef          	jal	8000341c <iunlockput>
      return 0;
    800038de:	8a4a                	mv	s4,s2
    800038e0:	bfc9                	j	800038b2 <namex+0x5c>
  len = path - s;
    800038e2:	40990633          	sub	a2,s2,s1
    800038e6:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800038ea:	09ac5463          	bge	s8,s10,80003972 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    800038ee:	8666                	mv	a2,s9
    800038f0:	85a6                	mv	a1,s1
    800038f2:	8556                	mv	a0,s5
    800038f4:	c64fd0ef          	jal	80000d58 <memmove>
    800038f8:	84ca                	mv	s1,s2
  while(*path == '/')
    800038fa:	0004c783          	lbu	a5,0(s1)
    800038fe:	01379763          	bne	a5,s3,8000390c <namex+0xb6>
    path++;
    80003902:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003904:	0004c783          	lbu	a5,0(s1)
    80003908:	ff378de3          	beq	a5,s3,80003902 <namex+0xac>
    ilock(ip);
    8000390c:	8552                	mv	a0,s4
    8000390e:	903ff0ef          	jal	80003210 <ilock>
    if(ip->type != T_DIR){
    80003912:	044a1783          	lh	a5,68(s4)
    80003916:	f9779ae3          	bne	a5,s7,800038aa <namex+0x54>
    if(nameiparent && *path == '\0'){
    8000391a:	000b0563          	beqz	s6,80003924 <namex+0xce>
    8000391e:	0004c783          	lbu	a5,0(s1)
    80003922:	d7dd                	beqz	a5,800038d0 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003924:	4601                	li	a2,0
    80003926:	85d6                	mv	a1,s5
    80003928:	8552                	mv	a0,s4
    8000392a:	e81ff0ef          	jal	800037aa <dirlookup>
    8000392e:	892a                	mv	s2,a0
    80003930:	d545                	beqz	a0,800038d8 <namex+0x82>
    iunlockput(ip);
    80003932:	8552                	mv	a0,s4
    80003934:	ae9ff0ef          	jal	8000341c <iunlockput>
    ip = next;
    80003938:	8a4a                	mv	s4,s2
  while(*path == '/')
    8000393a:	0004c783          	lbu	a5,0(s1)
    8000393e:	01379763          	bne	a5,s3,8000394c <namex+0xf6>
    path++;
    80003942:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003944:	0004c783          	lbu	a5,0(s1)
    80003948:	ff378de3          	beq	a5,s3,80003942 <namex+0xec>
  if(*path == 0)
    8000394c:	cf8d                	beqz	a5,80003986 <namex+0x130>
  while(*path != '/' && *path != 0)
    8000394e:	0004c783          	lbu	a5,0(s1)
    80003952:	fd178713          	addi	a4,a5,-47
    80003956:	cb19                	beqz	a4,8000396c <namex+0x116>
    80003958:	cb91                	beqz	a5,8000396c <namex+0x116>
    8000395a:	8926                	mv	s2,s1
    path++;
    8000395c:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    8000395e:	00094783          	lbu	a5,0(s2)
    80003962:	fd178713          	addi	a4,a5,-47
    80003966:	df35                	beqz	a4,800038e2 <namex+0x8c>
    80003968:	fbf5                	bnez	a5,8000395c <namex+0x106>
    8000396a:	bfa5                	j	800038e2 <namex+0x8c>
    8000396c:	8926                	mv	s2,s1
  len = path - s;
    8000396e:	4d01                	li	s10,0
    80003970:	4601                	li	a2,0
    memmove(name, s, len);
    80003972:	2601                	sext.w	a2,a2
    80003974:	85a6                	mv	a1,s1
    80003976:	8556                	mv	a0,s5
    80003978:	be0fd0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    8000397c:	9d56                	add	s10,s10,s5
    8000397e:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdd108>
    80003982:	84ca                	mv	s1,s2
    80003984:	bf9d                	j	800038fa <namex+0xa4>
  if(nameiparent){
    80003986:	f20b06e3          	beqz	s6,800038b2 <namex+0x5c>
    iput(ip);
    8000398a:	8552                	mv	a0,s4
    8000398c:	a07ff0ef          	jal	80003392 <iput>
    return 0;
    80003990:	4a01                	li	s4,0
    80003992:	b705                	j	800038b2 <namex+0x5c>

0000000080003994 <dirlink>:
{
    80003994:	715d                	addi	sp,sp,-80
    80003996:	e486                	sd	ra,72(sp)
    80003998:	e0a2                	sd	s0,64(sp)
    8000399a:	f84a                	sd	s2,48(sp)
    8000399c:	ec56                	sd	s5,24(sp)
    8000399e:	e85a                	sd	s6,16(sp)
    800039a0:	0880                	addi	s0,sp,80
    800039a2:	892a                	mv	s2,a0
    800039a4:	8aae                	mv	s5,a1
    800039a6:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800039a8:	4601                	li	a2,0
    800039aa:	e01ff0ef          	jal	800037aa <dirlookup>
    800039ae:	ed1d                	bnez	a0,800039ec <dirlink+0x58>
    800039b0:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039b2:	04c92483          	lw	s1,76(s2)
    800039b6:	c4b9                	beqz	s1,80003a04 <dirlink+0x70>
    800039b8:	f44e                	sd	s3,40(sp)
    800039ba:	f052                	sd	s4,32(sp)
    800039bc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039be:	fb040a13          	addi	s4,s0,-80
    800039c2:	49c1                	li	s3,16
    800039c4:	874e                	mv	a4,s3
    800039c6:	86a6                	mv	a3,s1
    800039c8:	8652                	mv	a2,s4
    800039ca:	4581                	li	a1,0
    800039cc:	854a                	mv	a0,s2
    800039ce:	bd5ff0ef          	jal	800035a2 <readi>
    800039d2:	03351163          	bne	a0,s3,800039f4 <dirlink+0x60>
    if(de.inum == 0)
    800039d6:	fb045783          	lhu	a5,-80(s0)
    800039da:	c39d                	beqz	a5,80003a00 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800039dc:	24c1                	addiw	s1,s1,16
    800039de:	04c92783          	lw	a5,76(s2)
    800039e2:	fef4e1e3          	bltu	s1,a5,800039c4 <dirlink+0x30>
    800039e6:	79a2                	ld	s3,40(sp)
    800039e8:	7a02                	ld	s4,32(sp)
    800039ea:	a829                	j	80003a04 <dirlink+0x70>
    iput(ip);
    800039ec:	9a7ff0ef          	jal	80003392 <iput>
    return -1;
    800039f0:	557d                	li	a0,-1
    800039f2:	a83d                	j	80003a30 <dirlink+0x9c>
      panic("dirlink read");
    800039f4:	00005517          	auipc	a0,0x5
    800039f8:	ae450513          	addi	a0,a0,-1308 # 800084d8 <etext+0x4d8>
    800039fc:	e29fc0ef          	jal	80000824 <panic>
    80003a00:	79a2                	ld	s3,40(sp)
    80003a02:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003a04:	4639                	li	a2,14
    80003a06:	85d6                	mv	a1,s5
    80003a08:	fb240513          	addi	a0,s0,-78
    80003a0c:	bfafd0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    80003a10:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a14:	4741                	li	a4,16
    80003a16:	86a6                	mv	a3,s1
    80003a18:	fb040613          	addi	a2,s0,-80
    80003a1c:	4581                	li	a1,0
    80003a1e:	854a                	mv	a0,s2
    80003a20:	c75ff0ef          	jal	80003694 <writei>
    80003a24:	1541                	addi	a0,a0,-16
    80003a26:	00a03533          	snez	a0,a0
    80003a2a:	40a0053b          	negw	a0,a0
    80003a2e:	74e2                	ld	s1,56(sp)
}
    80003a30:	60a6                	ld	ra,72(sp)
    80003a32:	6406                	ld	s0,64(sp)
    80003a34:	7942                	ld	s2,48(sp)
    80003a36:	6ae2                	ld	s5,24(sp)
    80003a38:	6b42                	ld	s6,16(sp)
    80003a3a:	6161                	addi	sp,sp,80
    80003a3c:	8082                	ret

0000000080003a3e <namei>:

struct inode*
namei(char *path)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a46:	fe040613          	addi	a2,s0,-32
    80003a4a:	4581                	li	a1,0
    80003a4c:	e0bff0ef          	jal	80003856 <namex>
}
    80003a50:	60e2                	ld	ra,24(sp)
    80003a52:	6442                	ld	s0,16(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret

0000000080003a58 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003a58:	1141                	addi	sp,sp,-16
    80003a5a:	e406                	sd	ra,8(sp)
    80003a5c:	e022                	sd	s0,0(sp)
    80003a5e:	0800                	addi	s0,sp,16
    80003a60:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a62:	4585                	li	a1,1
    80003a64:	df3ff0ef          	jal	80003856 <namex>
}
    80003a68:	60a2                	ld	ra,8(sp)
    80003a6a:	6402                	ld	s0,0(sp)
    80003a6c:	0141                	addi	sp,sp,16
    80003a6e:	8082                	ret

0000000080003a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a70:	1101                	addi	sp,sp,-32
    80003a72:	ec06                	sd	ra,24(sp)
    80003a74:	e822                	sd	s0,16(sp)
    80003a76:	e426                	sd	s1,8(sp)
    80003a78:	e04a                	sd	s2,0(sp)
    80003a7a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003a7c:	0001d917          	auipc	s2,0x1d
    80003a80:	1ec90913          	addi	s2,s2,492 # 80020c68 <log>
    80003a84:	01892583          	lw	a1,24(s2)
    80003a88:	02492503          	lw	a0,36(s2)
    80003a8c:	8ecff0ef          	jal	80002b78 <bread>
    80003a90:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a92:	02892603          	lw	a2,40(s2)
    80003a96:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a98:	00c05f63          	blez	a2,80003ab6 <write_head+0x46>
    80003a9c:	0001d717          	auipc	a4,0x1d
    80003aa0:	1f870713          	addi	a4,a4,504 # 80020c94 <log+0x2c>
    80003aa4:	87aa                	mv	a5,a0
    80003aa6:	060a                	slli	a2,a2,0x2
    80003aa8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003aaa:	4314                	lw	a3,0(a4)
    80003aac:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003aae:	0711                	addi	a4,a4,4
    80003ab0:	0791                	addi	a5,a5,4
    80003ab2:	fec79ce3          	bne	a5,a2,80003aaa <write_head+0x3a>
  }
  bwrite(buf);
    80003ab6:	8526                	mv	a0,s1
    80003ab8:	996ff0ef          	jal	80002c4e <bwrite>
  brelse(buf);
    80003abc:	8526                	mv	a0,s1
    80003abe:	9c2ff0ef          	jal	80002c80 <brelse>
}
    80003ac2:	60e2                	ld	ra,24(sp)
    80003ac4:	6442                	ld	s0,16(sp)
    80003ac6:	64a2                	ld	s1,8(sp)
    80003ac8:	6902                	ld	s2,0(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret

0000000080003ace <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ace:	0001d797          	auipc	a5,0x1d
    80003ad2:	1c27a783          	lw	a5,450(a5) # 80020c90 <log+0x28>
    80003ad6:	0cf05163          	blez	a5,80003b98 <install_trans+0xca>
{
    80003ada:	715d                	addi	sp,sp,-80
    80003adc:	e486                	sd	ra,72(sp)
    80003ade:	e0a2                	sd	s0,64(sp)
    80003ae0:	fc26                	sd	s1,56(sp)
    80003ae2:	f84a                	sd	s2,48(sp)
    80003ae4:	f44e                	sd	s3,40(sp)
    80003ae6:	f052                	sd	s4,32(sp)
    80003ae8:	ec56                	sd	s5,24(sp)
    80003aea:	e85a                	sd	s6,16(sp)
    80003aec:	e45e                	sd	s7,8(sp)
    80003aee:	e062                	sd	s8,0(sp)
    80003af0:	0880                	addi	s0,sp,80
    80003af2:	8b2a                	mv	s6,a0
    80003af4:	0001da97          	auipc	s5,0x1d
    80003af8:	1a0a8a93          	addi	s5,s5,416 # 80020c94 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003afc:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003afe:	00005c17          	auipc	s8,0x5
    80003b02:	9eac0c13          	addi	s8,s8,-1558 # 800084e8 <etext+0x4e8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b06:	0001da17          	auipc	s4,0x1d
    80003b0a:	162a0a13          	addi	s4,s4,354 # 80020c68 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b0e:	40000b93          	li	s7,1024
    80003b12:	a025                	j	80003b3a <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b14:	000aa603          	lw	a2,0(s5)
    80003b18:	85ce                	mv	a1,s3
    80003b1a:	8562                	mv	a0,s8
    80003b1c:	9dffc0ef          	jal	800004fa <printf>
    80003b20:	a839                	j	80003b3e <install_trans+0x70>
    brelse(lbuf);
    80003b22:	854a                	mv	a0,s2
    80003b24:	95cff0ef          	jal	80002c80 <brelse>
    brelse(dbuf);
    80003b28:	8526                	mv	a0,s1
    80003b2a:	956ff0ef          	jal	80002c80 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b2e:	2985                	addiw	s3,s3,1
    80003b30:	0a91                	addi	s5,s5,4
    80003b32:	028a2783          	lw	a5,40(s4)
    80003b36:	04f9d563          	bge	s3,a5,80003b80 <install_trans+0xb2>
    if(recovering) {
    80003b3a:	fc0b1de3          	bnez	s6,80003b14 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003b3e:	018a2583          	lw	a1,24(s4)
    80003b42:	013585bb          	addw	a1,a1,s3
    80003b46:	2585                	addiw	a1,a1,1
    80003b48:	024a2503          	lw	a0,36(s4)
    80003b4c:	82cff0ef          	jal	80002b78 <bread>
    80003b50:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003b52:	000aa583          	lw	a1,0(s5)
    80003b56:	024a2503          	lw	a0,36(s4)
    80003b5a:	81eff0ef          	jal	80002b78 <bread>
    80003b5e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003b60:	865e                	mv	a2,s7
    80003b62:	05890593          	addi	a1,s2,88
    80003b66:	05850513          	addi	a0,a0,88
    80003b6a:	9eefd0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003b6e:	8526                	mv	a0,s1
    80003b70:	8deff0ef          	jal	80002c4e <bwrite>
    if(recovering == 0)
    80003b74:	fa0b17e3          	bnez	s6,80003b22 <install_trans+0x54>
      bunpin(dbuf);
    80003b78:	8526                	mv	a0,s1
    80003b7a:	9beff0ef          	jal	80002d38 <bunpin>
    80003b7e:	b755                	j	80003b22 <install_trans+0x54>
}
    80003b80:	60a6                	ld	ra,72(sp)
    80003b82:	6406                	ld	s0,64(sp)
    80003b84:	74e2                	ld	s1,56(sp)
    80003b86:	7942                	ld	s2,48(sp)
    80003b88:	79a2                	ld	s3,40(sp)
    80003b8a:	7a02                	ld	s4,32(sp)
    80003b8c:	6ae2                	ld	s5,24(sp)
    80003b8e:	6b42                	ld	s6,16(sp)
    80003b90:	6ba2                	ld	s7,8(sp)
    80003b92:	6c02                	ld	s8,0(sp)
    80003b94:	6161                	addi	sp,sp,80
    80003b96:	8082                	ret
    80003b98:	8082                	ret

0000000080003b9a <initlog>:
{
    80003b9a:	7179                	addi	sp,sp,-48
    80003b9c:	f406                	sd	ra,40(sp)
    80003b9e:	f022                	sd	s0,32(sp)
    80003ba0:	ec26                	sd	s1,24(sp)
    80003ba2:	e84a                	sd	s2,16(sp)
    80003ba4:	e44e                	sd	s3,8(sp)
    80003ba6:	1800                	addi	s0,sp,48
    80003ba8:	84aa                	mv	s1,a0
    80003baa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003bac:	0001d917          	auipc	s2,0x1d
    80003bb0:	0bc90913          	addi	s2,s2,188 # 80020c68 <log>
    80003bb4:	00005597          	auipc	a1,0x5
    80003bb8:	95458593          	addi	a1,a1,-1708 # 80008508 <etext+0x508>
    80003bbc:	854a                	mv	a0,s2
    80003bbe:	fe1fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80003bc2:	0149a583          	lw	a1,20(s3)
    80003bc6:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003bca:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003bce:	8526                	mv	a0,s1
    80003bd0:	fa9fe0ef          	jal	80002b78 <bread>
  log.lh.n = lh->n;
    80003bd4:	4d30                	lw	a2,88(a0)
    80003bd6:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003bda:	00c05f63          	blez	a2,80003bf8 <initlog+0x5e>
    80003bde:	87aa                	mv	a5,a0
    80003be0:	0001d717          	auipc	a4,0x1d
    80003be4:	0b470713          	addi	a4,a4,180 # 80020c94 <log+0x2c>
    80003be8:	060a                	slli	a2,a2,0x2
    80003bea:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003bec:	4ff4                	lw	a3,92(a5)
    80003bee:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003bf0:	0791                	addi	a5,a5,4
    80003bf2:	0711                	addi	a4,a4,4
    80003bf4:	fec79ce3          	bne	a5,a2,80003bec <initlog+0x52>
  brelse(buf);
    80003bf8:	888ff0ef          	jal	80002c80 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003bfc:	4505                	li	a0,1
    80003bfe:	ed1ff0ef          	jal	80003ace <install_trans>
  log.lh.n = 0;
    80003c02:	0001d797          	auipc	a5,0x1d
    80003c06:	0807a723          	sw	zero,142(a5) # 80020c90 <log+0x28>
  write_head(); // clear the log
    80003c0a:	e67ff0ef          	jal	80003a70 <write_head>
}
    80003c0e:	70a2                	ld	ra,40(sp)
    80003c10:	7402                	ld	s0,32(sp)
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	6942                	ld	s2,16(sp)
    80003c16:	69a2                	ld	s3,8(sp)
    80003c18:	6145                	addi	sp,sp,48
    80003c1a:	8082                	ret

0000000080003c1c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c1c:	1101                	addi	sp,sp,-32
    80003c1e:	ec06                	sd	ra,24(sp)
    80003c20:	e822                	sd	s0,16(sp)
    80003c22:	e426                	sd	s1,8(sp)
    80003c24:	e04a                	sd	s2,0(sp)
    80003c26:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c28:	0001d517          	auipc	a0,0x1d
    80003c2c:	04050513          	addi	a0,a0,64 # 80020c68 <log>
    80003c30:	ff9fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80003c34:	0001d497          	auipc	s1,0x1d
    80003c38:	03448493          	addi	s1,s1,52 # 80020c68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c3c:	4979                	li	s2,30
    80003c3e:	a029                	j	80003c48 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c40:	85a6                	mv	a1,s1
    80003c42:	8526                	mv	a0,s1
    80003c44:	aecfe0ef          	jal	80001f30 <sleep>
    if(log.committing){
    80003c48:	509c                	lw	a5,32(s1)
    80003c4a:	fbfd                	bnez	a5,80003c40 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003c4c:	4cd8                	lw	a4,28(s1)
    80003c4e:	2705                	addiw	a4,a4,1
    80003c50:	0027179b          	slliw	a5,a4,0x2
    80003c54:	9fb9                	addw	a5,a5,a4
    80003c56:	0017979b          	slliw	a5,a5,0x1
    80003c5a:	5494                	lw	a3,40(s1)
    80003c5c:	9fb5                	addw	a5,a5,a3
    80003c5e:	00f95763          	bge	s2,a5,80003c6c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c62:	85a6                	mv	a1,s1
    80003c64:	8526                	mv	a0,s1
    80003c66:	acafe0ef          	jal	80001f30 <sleep>
    80003c6a:	bff9                	j	80003c48 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c6c:	0001d797          	auipc	a5,0x1d
    80003c70:	00e7ac23          	sw	a4,24(a5) # 80020c84 <log+0x1c>
      release(&log.lock);
    80003c74:	0001d517          	auipc	a0,0x1d
    80003c78:	ff450513          	addi	a0,a0,-12 # 80020c68 <log>
    80003c7c:	840fd0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80003c80:	60e2                	ld	ra,24(sp)
    80003c82:	6442                	ld	s0,16(sp)
    80003c84:	64a2                	ld	s1,8(sp)
    80003c86:	6902                	ld	s2,0(sp)
    80003c88:	6105                	addi	sp,sp,32
    80003c8a:	8082                	ret

0000000080003c8c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003c8c:	7139                	addi	sp,sp,-64
    80003c8e:	fc06                	sd	ra,56(sp)
    80003c90:	f822                	sd	s0,48(sp)
    80003c92:	f426                	sd	s1,40(sp)
    80003c94:	f04a                	sd	s2,32(sp)
    80003c96:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003c98:	0001d497          	auipc	s1,0x1d
    80003c9c:	fd048493          	addi	s1,s1,-48 # 80020c68 <log>
    80003ca0:	8526                	mv	a0,s1
    80003ca2:	f87fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80003ca6:	4cdc                	lw	a5,28(s1)
    80003ca8:	37fd                	addiw	a5,a5,-1
    80003caa:	893e                	mv	s2,a5
    80003cac:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003cae:	509c                	lw	a5,32(s1)
    80003cb0:	e7b1                	bnez	a5,80003cfc <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003cb2:	04091e63          	bnez	s2,80003d0e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003cb6:	0001d497          	auipc	s1,0x1d
    80003cba:	fb248493          	addi	s1,s1,-78 # 80020c68 <log>
    80003cbe:	4785                	li	a5,1
    80003cc0:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003cc2:	8526                	mv	a0,s1
    80003cc4:	ff9fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cc8:	549c                	lw	a5,40(s1)
    80003cca:	06f04463          	bgtz	a5,80003d32 <end_op+0xa6>
    acquire(&log.lock);
    80003cce:	0001d517          	auipc	a0,0x1d
    80003cd2:	f9a50513          	addi	a0,a0,-102 # 80020c68 <log>
    80003cd6:	f53fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80003cda:	0001d797          	auipc	a5,0x1d
    80003cde:	fa07a723          	sw	zero,-82(a5) # 80020c88 <log+0x20>
    wakeup(&log);
    80003ce2:	0001d517          	auipc	a0,0x1d
    80003ce6:	f8650513          	addi	a0,a0,-122 # 80020c68 <log>
    80003cea:	a92fe0ef          	jal	80001f7c <wakeup>
    release(&log.lock);
    80003cee:	0001d517          	auipc	a0,0x1d
    80003cf2:	f7a50513          	addi	a0,a0,-134 # 80020c68 <log>
    80003cf6:	fc7fc0ef          	jal	80000cbc <release>
}
    80003cfa:	a035                	j	80003d26 <end_op+0x9a>
    80003cfc:	ec4e                	sd	s3,24(sp)
    80003cfe:	e852                	sd	s4,16(sp)
    80003d00:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003d02:	00005517          	auipc	a0,0x5
    80003d06:	80e50513          	addi	a0,a0,-2034 # 80008510 <etext+0x510>
    80003d0a:	b1bfc0ef          	jal	80000824 <panic>
    wakeup(&log);
    80003d0e:	0001d517          	auipc	a0,0x1d
    80003d12:	f5a50513          	addi	a0,a0,-166 # 80020c68 <log>
    80003d16:	a66fe0ef          	jal	80001f7c <wakeup>
  release(&log.lock);
    80003d1a:	0001d517          	auipc	a0,0x1d
    80003d1e:	f4e50513          	addi	a0,a0,-178 # 80020c68 <log>
    80003d22:	f9bfc0ef          	jal	80000cbc <release>
}
    80003d26:	70e2                	ld	ra,56(sp)
    80003d28:	7442                	ld	s0,48(sp)
    80003d2a:	74a2                	ld	s1,40(sp)
    80003d2c:	7902                	ld	s2,32(sp)
    80003d2e:	6121                	addi	sp,sp,64
    80003d30:	8082                	ret
    80003d32:	ec4e                	sd	s3,24(sp)
    80003d34:	e852                	sd	s4,16(sp)
    80003d36:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d38:	0001da97          	auipc	s5,0x1d
    80003d3c:	f5ca8a93          	addi	s5,s5,-164 # 80020c94 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003d40:	0001da17          	auipc	s4,0x1d
    80003d44:	f28a0a13          	addi	s4,s4,-216 # 80020c68 <log>
    80003d48:	018a2583          	lw	a1,24(s4)
    80003d4c:	012585bb          	addw	a1,a1,s2
    80003d50:	2585                	addiw	a1,a1,1
    80003d52:	024a2503          	lw	a0,36(s4)
    80003d56:	e23fe0ef          	jal	80002b78 <bread>
    80003d5a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d5c:	000aa583          	lw	a1,0(s5)
    80003d60:	024a2503          	lw	a0,36(s4)
    80003d64:	e15fe0ef          	jal	80002b78 <bread>
    80003d68:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d6a:	40000613          	li	a2,1024
    80003d6e:	05850593          	addi	a1,a0,88
    80003d72:	05848513          	addi	a0,s1,88
    80003d76:	fe3fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    80003d7a:	8526                	mv	a0,s1
    80003d7c:	ed3fe0ef          	jal	80002c4e <bwrite>
    brelse(from);
    80003d80:	854e                	mv	a0,s3
    80003d82:	efffe0ef          	jal	80002c80 <brelse>
    brelse(to);
    80003d86:	8526                	mv	a0,s1
    80003d88:	ef9fe0ef          	jal	80002c80 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d8c:	2905                	addiw	s2,s2,1
    80003d8e:	0a91                	addi	s5,s5,4
    80003d90:	028a2783          	lw	a5,40(s4)
    80003d94:	faf94ae3          	blt	s2,a5,80003d48 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003d98:	cd9ff0ef          	jal	80003a70 <write_head>
    install_trans(0); // Now install writes to home locations
    80003d9c:	4501                	li	a0,0
    80003d9e:	d31ff0ef          	jal	80003ace <install_trans>
    log.lh.n = 0;
    80003da2:	0001d797          	auipc	a5,0x1d
    80003da6:	ee07a723          	sw	zero,-274(a5) # 80020c90 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003daa:	cc7ff0ef          	jal	80003a70 <write_head>
    80003dae:	69e2                	ld	s3,24(sp)
    80003db0:	6a42                	ld	s4,16(sp)
    80003db2:	6aa2                	ld	s5,8(sp)
    80003db4:	bf29                	j	80003cce <end_op+0x42>

0000000080003db6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003db6:	1101                	addi	sp,sp,-32
    80003db8:	ec06                	sd	ra,24(sp)
    80003dba:	e822                	sd	s0,16(sp)
    80003dbc:	e426                	sd	s1,8(sp)
    80003dbe:	1000                	addi	s0,sp,32
    80003dc0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003dc2:	0001d517          	auipc	a0,0x1d
    80003dc6:	ea650513          	addi	a0,a0,-346 # 80020c68 <log>
    80003dca:	e5ffc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003dce:	0001d617          	auipc	a2,0x1d
    80003dd2:	ec262603          	lw	a2,-318(a2) # 80020c90 <log+0x28>
    80003dd6:	47f5                	li	a5,29
    80003dd8:	04c7cd63          	blt	a5,a2,80003e32 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ddc:	0001d797          	auipc	a5,0x1d
    80003de0:	ea87a783          	lw	a5,-344(a5) # 80020c84 <log+0x1c>
    80003de4:	04f05d63          	blez	a5,80003e3e <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003de8:	4781                	li	a5,0
    80003dea:	06c05063          	blez	a2,80003e4a <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dee:	44cc                	lw	a1,12(s1)
    80003df0:	0001d717          	auipc	a4,0x1d
    80003df4:	ea470713          	addi	a4,a4,-348 # 80020c94 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003df8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003dfa:	4314                	lw	a3,0(a4)
    80003dfc:	04b68763          	beq	a3,a1,80003e4a <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003e00:	2785                	addiw	a5,a5,1
    80003e02:	0711                	addi	a4,a4,4
    80003e04:	fef61be3          	bne	a2,a5,80003dfa <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e08:	060a                	slli	a2,a2,0x2
    80003e0a:	02060613          	addi	a2,a2,32
    80003e0e:	0001d797          	auipc	a5,0x1d
    80003e12:	e5a78793          	addi	a5,a5,-422 # 80020c68 <log>
    80003e16:	97b2                	add	a5,a5,a2
    80003e18:	44d8                	lw	a4,12(s1)
    80003e1a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003e1c:	8526                	mv	a0,s1
    80003e1e:	ee7fe0ef          	jal	80002d04 <bpin>
    log.lh.n++;
    80003e22:	0001d717          	auipc	a4,0x1d
    80003e26:	e4670713          	addi	a4,a4,-442 # 80020c68 <log>
    80003e2a:	571c                	lw	a5,40(a4)
    80003e2c:	2785                	addiw	a5,a5,1
    80003e2e:	d71c                	sw	a5,40(a4)
    80003e30:	a815                	j	80003e64 <log_write+0xae>
    panic("too big a transaction");
    80003e32:	00004517          	auipc	a0,0x4
    80003e36:	6ee50513          	addi	a0,a0,1774 # 80008520 <etext+0x520>
    80003e3a:	9ebfc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80003e3e:	00004517          	auipc	a0,0x4
    80003e42:	6fa50513          	addi	a0,a0,1786 # 80008538 <etext+0x538>
    80003e46:	9dffc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80003e4a:	00279693          	slli	a3,a5,0x2
    80003e4e:	02068693          	addi	a3,a3,32
    80003e52:	0001d717          	auipc	a4,0x1d
    80003e56:	e1670713          	addi	a4,a4,-490 # 80020c68 <log>
    80003e5a:	9736                	add	a4,a4,a3
    80003e5c:	44d4                	lw	a3,12(s1)
    80003e5e:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003e60:	faf60ee3          	beq	a2,a5,80003e1c <log_write+0x66>
  }
  release(&log.lock);
    80003e64:	0001d517          	auipc	a0,0x1d
    80003e68:	e0450513          	addi	a0,a0,-508 # 80020c68 <log>
    80003e6c:	e51fc0ef          	jal	80000cbc <release>
}
    80003e70:	60e2                	ld	ra,24(sp)
    80003e72:	6442                	ld	s0,16(sp)
    80003e74:	64a2                	ld	s1,8(sp)
    80003e76:	6105                	addi	sp,sp,32
    80003e78:	8082                	ret

0000000080003e7a <size_to_order>:

// Get size order (log2) from a size (e.g., 32 -> 5)
// Returns -1 if size is not a power of two.
static int
size_to_order(uint64 size)
{
    80003e7a:	1141                	addi	sp,sp,-16
    80003e7c:	e406                	sd	ra,8(sp)
    80003e7e:	e022                	sd	s0,0(sp)
    80003e80:	0800                	addi	s0,sp,16
    80003e82:	86aa                	mv	a3,a0
    int order = 0;
    uint64 s = size;
    while (s > 1)
    80003e84:	4785                	li	a5,1
    80003e86:	02a7f263          	bgeu	a5,a0,80003eaa <size_to_order+0x30>
    uint64 s = size;
    80003e8a:	87aa                	mv	a5,a0
    int order = 0;
    80003e8c:	4501                	li	a0,0
    while (s > 1)
    80003e8e:	4705                	li	a4,1
    {
        s >>= 1;
    80003e90:	8385                	srli	a5,a5,0x1
        order++;
    80003e92:	2505                	addiw	a0,a0,1
    while (s > 1)
    80003e94:	fef76ee3          	bltu	a4,a5,80003e90 <size_to_order+0x16>
    }
    // Verify it was a power of two
    if (1L << order != size)
    80003e98:	4785                	li	a5,1
    80003e9a:	00a797b3          	sll	a5,a5,a0
    80003e9e:	00d79863          	bne	a5,a3,80003eae <size_to_order+0x34>
    {
        return -1;
    }
    return order;
}
    80003ea2:	60a2                	ld	ra,8(sp)
    80003ea4:	6402                	ld	s0,0(sp)
    80003ea6:	0141                	addi	sp,sp,16
    80003ea8:	8082                	ret
    int order = 0;
    80003eaa:	4501                	li	a0,0
    80003eac:	b7f5                	j	80003e98 <size_to_order+0x1e>
        return -1;
    80003eae:	557d                	li	a0,-1
    80003eb0:	bfcd                	j	80003ea2 <size_to_order+0x28>

0000000080003eb2 <insert_free_block>:
}

// Insert a block into the correct free list, ordered by address.
static void
insert_free_block(struct header *block)
{
    80003eb2:	1101                	addi	sp,sp,-32
    80003eb4:	ec06                	sd	ra,24(sp)
    80003eb6:	e822                	sd	s0,16(sp)
    80003eb8:	e426                	sd	s1,8(sp)
    80003eba:	1000                	addi	s0,sp,32
    80003ebc:	84aa                	mv	s1,a0
    block->magic = MAGIC_FREE;
    80003ebe:	00004797          	auipc	a5,0x4
    80003ec2:	1427b783          	ld	a5,322(a5) # 80008000 <etext>
    80003ec6:	e11c                	sd	a5,0(a0)
    int order = size_to_order(block->size);
    80003ec8:	6508                	ld	a0,8(a0)
    80003eca:	fb1ff0ef          	jal	80003e7a <size_to_order>
    return order - MIN_ORDER;
    80003ece:	356d                	addiw	a0,a0,-5
    return (void *)((char *)block + sizeof(struct header));
    80003ed0:	01048713          	addi	a4,s1,16
    int index = order_to_index(order);

    struct free_block *fb_to_add = (struct free_block *)block_to_ptr(block);

    struct free_block **list_head = &free_lists[index];
    struct free_block *rover = *list_head;
    80003ed4:	00351693          	slli	a3,a0,0x3
    80003ed8:	0001d797          	auipc	a5,0x1d
    80003edc:	e3878793          	addi	a5,a5,-456 # 80020d10 <free_lists>
    80003ee0:	97b6                	add	a5,a5,a3
    80003ee2:	639c                	ld	a5,0(a5)
    struct free_block *prev = 0;

    // Find insertion point to keep list sorted by address
    while (rover && (uint64)rover < (uint64)fb_to_add)
    80003ee4:	cf99                	beqz	a5,80003f02 <insert_free_block+0x50>
    80003ee6:	00e7fe63          	bgeu	a5,a4,80003f02 <insert_free_block+0x50>
    {
        prev = rover;
        rover = rover->next;
    80003eea:	86be                	mv	a3,a5
    80003eec:	639c                	ld	a5,0(a5)
    while (rover && (uint64)rover < (uint64)fb_to_add)
    80003eee:	c399                	beqz	a5,80003ef4 <insert_free_block+0x42>
    80003ef0:	fee7ede3          	bltu	a5,a4,80003eea <insert_free_block+0x38>
    }

    if (prev)
    {
        prev->next = fb_to_add;
    80003ef4:	e298                	sd	a4,0(a3)
    }
    else
    {
        *list_head = fb_to_add;
    }
    fb_to_add->next = rover;
    80003ef6:	e89c                	sd	a5,16(s1)
}
    80003ef8:	60e2                	ld	ra,24(sp)
    80003efa:	6442                	ld	s0,16(sp)
    80003efc:	64a2                	ld	s1,8(sp)
    80003efe:	6105                	addi	sp,sp,32
    80003f00:	8082                	ret
        *list_head = fb_to_add;
    80003f02:	050e                	slli	a0,a0,0x3
    80003f04:	0001d697          	auipc	a3,0x1d
    80003f08:	e0c68693          	addi	a3,a3,-500 # 80020d10 <free_lists>
    80003f0c:	96aa                	add	a3,a3,a0
    80003f0e:	e298                	sd	a4,0(a3)
    80003f10:	b7dd                	j	80003ef6 <insert_free_block+0x44>

0000000080003f12 <print_tree>:
// Recursive helper for buddy_print
// Recursive helper for buddy_print
// Recursive helper for buddy_print
static void
print_tree(struct header *block, int order, char *prefix, int is_top)
{
    80003f12:	714d                	addi	sp,sp,-336
    80003f14:	e686                	sd	ra,328(sp)
    80003f16:	e2a2                	sd	s0,320(sp)
    80003f18:	fe26                	sd	s1,312(sp)
    80003f1a:	fa4a                	sd	s2,304(sp)
    80003f1c:	f64e                	sd	s3,296(sp)
    80003f1e:	f252                	sd	s4,288(sp)
    80003f20:	ea5a                	sd	s6,272(sp)
    80003f22:	e65e                	sd	s7,264(sp)
    80003f24:	0a80                	addi	s0,sp,336
    80003f26:	892a                	mv	s2,a0
    80003f28:	8a2e                	mv	s4,a1
    80003f2a:	8b32                	mv	s6,a2
    80003f2c:	89b6                	mv	s3,a3
    80003f2e:	8bb6                	mv	s7,a3
    uint64 size = 1L << order;
    80003f30:	4485                	li	s1,1
    80003f32:	00b494b3          	sll	s1,s1,a1

    // Print the prefix string passed down from the parent
    printf("%s", prefix);
    80003f36:	85b2                	mv	a1,a2
    80003f38:	00004517          	auipc	a0,0x4
    80003f3c:	69050513          	addi	a0,a0,1680 # 800085c8 <etext+0x5c8>
    80003f40:	dbafc0ef          	jal	800004fa <printf>

    // Check if this block is a "leaf" (not split further)
    if (block->size == size)
    80003f44:	00893783          	ld	a5,8(s2)
    80003f48:	0a979163          	bne	a5,s1,80003fea <print_tree+0xd8>
    {
        // This block is not split (it's a leaf at this level)
        printf("%s", is_top ? "┌──── " : "└─────── ");
    80003f4c:	00004597          	auipc	a1,0x4
    80003f50:	62458593          	addi	a1,a1,1572 # 80008570 <etext+0x570>
    80003f54:	00098663          	beqz	s3,80003f60 <print_tree+0x4e>
    80003f58:	00004597          	auipc	a1,0x4
    80003f5c:	60058593          	addi	a1,a1,1536 # 80008558 <etext+0x558>
    80003f60:	00004517          	auipc	a0,0x4
    80003f64:	66850513          	addi	a0,a0,1640 # 800085c8 <etext+0x5c8>
    80003f68:	d92fc0ef          	jal	800004fa <printf>

        if (block->magic == MAGIC_USED)
    80003f6c:	00093683          	ld	a3,0(s2)
    80003f70:	5f77f737          	lui	a4,0x5f77f
    80003f74:	0706                	slli	a4,a4,0x1
    80003f76:	ead70713          	addi	a4,a4,-339 # 5f77eead <_entry-0x20881153>
    80003f7a:	37ab77b7          	lui	a5,0x37ab7
    80003f7e:	078a                	slli	a5,a5,0x2
    80003f80:	eef78793          	addi	a5,a5,-273 # 37ab6eef <_entry-0x48549111>
    80003f84:	1782                	slli	a5,a5,0x20
    80003f86:	97ba                	add	a5,a5,a4
    80003f88:	04f68163          	beq	a3,a5,80003fca <print_tree+0xb8>
            printf("used (%lu)\n", size);
        else if (block->magic == MAGIC_FREE)
    80003f8c:	ffeee7b7          	lui	a5,0xffeee
    80003f90:	bef78793          	addi	a5,a5,-1041 # ffffffffffeedbef <end+0xffffffff7fecbcf7>
    80003f94:	07de                	slli	a5,a5,0x17
    80003f96:	80078793          	addi	a5,a5,-2048
    80003f9a:	f5f78793          	addi	a5,a5,-161
    80003f9e:	07b6                	slli	a5,a5,0xd
    80003fa0:	eef78793          	addi	a5,a5,-273
    80003fa4:	02f68b63          	beq	a3,a5,80003fda <print_tree+0xc8>
            printf("free (%lu)\n", size);
        else
            printf("corrupt (%lu)\n", size);
    80003fa8:	85a6                	mv	a1,s1
    80003faa:	00004517          	auipc	a0,0x4
    80003fae:	64650513          	addi	a0,a0,1606 # 800085f0 <etext+0x5f0>
    80003fb2:	d48fc0ef          	jal	800004fa <printf>
        memmove(next_prefix + len, "        ", 8); // 8 bytes
        next_prefix[len + 8] = '\0';

        print_tree(block, next_order, next_prefix, 0); // 0 = is bottom child
    }
}
    80003fb6:	60b6                	ld	ra,328(sp)
    80003fb8:	6416                	ld	s0,320(sp)
    80003fba:	74f2                	ld	s1,312(sp)
    80003fbc:	7952                	ld	s2,304(sp)
    80003fbe:	79b2                	ld	s3,296(sp)
    80003fc0:	7a12                	ld	s4,288(sp)
    80003fc2:	6b52                	ld	s6,272(sp)
    80003fc4:	6bb2                	ld	s7,264(sp)
    80003fc6:	6171                	addi	sp,sp,336
    80003fc8:	8082                	ret
            printf("used (%lu)\n", size);
    80003fca:	85a6                	mv	a1,s1
    80003fcc:	00004517          	auipc	a0,0x4
    80003fd0:	60450513          	addi	a0,a0,1540 # 800085d0 <etext+0x5d0>
    80003fd4:	d26fc0ef          	jal	800004fa <printf>
    80003fd8:	bff9                	j	80003fb6 <print_tree+0xa4>
            printf("free (%lu)\n", size);
    80003fda:	85a6                	mv	a1,s1
    80003fdc:	00004517          	auipc	a0,0x4
    80003fe0:	60450513          	addi	a0,a0,1540 # 800085e0 <etext+0x5e0>
    80003fe4:	d16fc0ef          	jal	800004fa <printf>
    80003fe8:	b7f9                	j	80003fb6 <print_tree+0xa4>
        uint64 len = strlen(prefix);
    80003fea:	855a                	mv	a0,s6
    80003fec:	e97fc0ef          	jal	80000e82 <strlen>
    80003ff0:	89aa                	mv	s3,a0
        if (len + 11 > 256) { // 10 bytes for "│       " + 1 null
    80003ff2:	00b50713          	addi	a4,a0,11
    80003ff6:	10000793          	li	a5,256
    80003ffa:	0ae7ee63          	bltu	a5,a4,800040b6 <print_tree+0x1a4>
    80003ffe:	ee56                	sd	s5,280(sp)
    80004000:	e262                	sd	s8,256(sp)
        int next_order = order - 1;
    80004002:	3a7d                	addiw	s4,s4,-1
        uint64 split_size = size / 2;
    80004004:	8085                	srli	s1,s1,0x1
        struct header *buddy = (struct header *)((char *)block + split_size);
    80004006:	00990ab3          	add	s5,s2,s1
        memmove(next_prefix, prefix, len);
    8000400a:	eb040493          	addi	s1,s0,-336
    8000400e:	862a                	mv	a2,a0
    80004010:	85da                	mv	a1,s6
    80004012:	8526                	mv	a0,s1
    80004014:	d45fc0ef          	jal	80000d58 <memmove>
        memmove(next_prefix + len, "│       ", 10); // 10 bytes
    80004018:	013487b3          	add	a5,s1,s3
    8000401c:	8c3e                	mv	s8,a5
    8000401e:	4629                	li	a2,10
    80004020:	00004597          	auipc	a1,0x4
    80004024:	60858593          	addi	a1,a1,1544 # 80008628 <etext+0x628>
    80004028:	853e                	mv	a0,a5
    8000402a:	d2ffc0ef          	jal	80000d58 <memmove>
        next_prefix[len + 10] = '\0';
    8000402e:	fd098793          	addi	a5,s3,-48
    80004032:	fe040713          	addi	a4,s0,-32
    80004036:	97ba                	add	a5,a5,a4
    80004038:	f0078523          	sb	zero,-246(a5)
        print_tree(buddy, next_order, next_prefix, 1); // 1 = is top child
    8000403c:	4685                	li	a3,1
    8000403e:	8626                	mv	a2,s1
    80004040:	85d2                	mv	a1,s4
    80004042:	8556                	mv	a0,s5
    80004044:	ecfff0ef          	jal	80003f12 <print_tree>
        printf("%s%s", prefix, is_top ? "├───┤\n" : "└───────┤\n");
    80004048:	00004617          	auipc	a2,0x4
    8000404c:	56060613          	addi	a2,a2,1376 # 800085a8 <etext+0x5a8>
    80004050:	000b8663          	beqz	s7,8000405c <print_tree+0x14a>
    80004054:	00004617          	auipc	a2,0x4
    80004058:	53c60613          	addi	a2,a2,1340 # 80008590 <etext+0x590>
    8000405c:	85da                	mv	a1,s6
    8000405e:	00004517          	auipc	a0,0x4
    80004062:	5da50513          	addi	a0,a0,1498 # 80008638 <etext+0x638>
    80004066:	c94fc0ef          	jal	800004fa <printf>
        if (len + 9 > 256) { // 8 bytes for "        " + 1 null
    8000406a:	00998793          	addi	a5,s3,9
    8000406e:	10000713          	li	a4,256
    80004072:	04f76963          	bltu	a4,a5,800040c4 <print_tree+0x1b2>
        memmove(next_prefix, prefix, len);
    80004076:	eb040493          	addi	s1,s0,-336
    8000407a:	864e                	mv	a2,s3
    8000407c:	85da                	mv	a1,s6
    8000407e:	8526                	mv	a0,s1
    80004080:	cd9fc0ef          	jal	80000d58 <memmove>
        memmove(next_prefix + len, "        ", 8); // 8 bytes
    80004084:	4621                	li	a2,8
    80004086:	00004597          	auipc	a1,0x4
    8000408a:	5ba58593          	addi	a1,a1,1466 # 80008640 <etext+0x640>
    8000408e:	8562                	mv	a0,s8
    80004090:	cc9fc0ef          	jal	80000d58 <memmove>
        next_prefix[len + 8] = '\0';
    80004094:	fd098793          	addi	a5,s3,-48
    80004098:	fe040713          	addi	a4,s0,-32
    8000409c:	00e78633          	add	a2,a5,a4
    800040a0:	f0060423          	sb	zero,-248(a2)
        print_tree(block, next_order, next_prefix, 0); // 0 = is bottom child
    800040a4:	4681                	li	a3,0
    800040a6:	8626                	mv	a2,s1
    800040a8:	85d2                	mv	a1,s4
    800040aa:	854a                	mv	a0,s2
    800040ac:	e67ff0ef          	jal	80003f12 <print_tree>
    800040b0:	6af2                	ld	s5,280(sp)
    800040b2:	6c12                	ld	s8,256(sp)
    800040b4:	b709                	j	80003fb6 <print_tree+0xa4>
            printf("buddy_print: prefix string too long\n");
    800040b6:	00004517          	auipc	a0,0x4
    800040ba:	54a50513          	addi	a0,a0,1354 # 80008600 <etext+0x600>
    800040be:	c3cfc0ef          	jal	800004fa <printf>
            return;
    800040c2:	bdd5                	j	80003fb6 <print_tree+0xa4>
             printf("buddy_print: prefix string too long\n");
    800040c4:	00004517          	auipc	a0,0x4
    800040c8:	53c50513          	addi	a0,a0,1340 # 80008600 <etext+0x600>
    800040cc:	c2efc0ef          	jal	800004fa <printf>
             return;
    800040d0:	6af2                	ld	s5,280(sp)
    800040d2:	6c12                	ld	s8,256(sp)
    800040d4:	b5cd                	j	80003fb6 <print_tree+0xa4>

00000000800040d6 <buddyinit>:
{
    800040d6:	1101                	addi	sp,sp,-32
    800040d8:	ec06                	sd	ra,24(sp)
    800040da:	e822                	sd	s0,16(sp)
    800040dc:	e426                	sd	s1,8(sp)
    800040de:	1000                	addi	s0,sp,32
    initlock(&buddy_lock, "buddy");
    800040e0:	0001d497          	auipc	s1,0x1d
    800040e4:	c3048493          	addi	s1,s1,-976 # 80020d10 <free_lists>
    800040e8:	00004597          	auipc	a1,0x4
    800040ec:	56858593          	addi	a1,a1,1384 # 80008650 <etext+0x650>
    800040f0:	0001d517          	auipc	a0,0x1d
    800040f4:	c5850513          	addi	a0,a0,-936 # 80020d48 <buddy_lock>
    800040f8:	aa7fc0ef          	jal	80000b9e <initlock>
        free_lists[i] = 0;
    800040fc:	0004b023          	sd	zero,0(s1)
    80004100:	0004b423          	sd	zero,8(s1)
    80004104:	0004b823          	sd	zero,16(s1)
    80004108:	0004bc23          	sd	zero,24(s1)
    8000410c:	0204b023          	sd	zero,32(s1)
    80004110:	0204b423          	sd	zero,40(s1)
    80004114:	0204b823          	sd	zero,48(s1)
}
    80004118:	60e2                	ld	ra,24(sp)
    8000411a:	6442                	ld	s0,16(sp)
    8000411c:	64a2                	ld	s1,8(sp)
    8000411e:	6105                	addi	sp,sp,32
    80004120:	8082                	ret

0000000080004122 <buddy_alloc>:
{
    80004122:	7179                	addi	sp,sp,-48
    80004124:	f406                	sd	ra,40(sp)
    80004126:	f022                	sd	s0,32(sp)
    80004128:	e84a                	sd	s2,16(sp)
    8000412a:	1800                	addi	s0,sp,48
    if (length == 0 || length > (MAX_SIZE - sizeof(struct header)))
    8000412c:	fff50713          	addi	a4,a0,-1
    80004130:	6785                	lui	a5,0x1
    80004132:	17bd                	addi	a5,a5,-17 # fef <_entry-0x7ffff011>
    80004134:	12e7e563          	bltu	a5,a4,8000425e <buddy_alloc+0x13c>
    80004138:	ec26                	sd	s1,24(sp)
    uint64 total_needed = length + sizeof(struct header);
    8000413a:	0541                	addi	a0,a0,16
    while (size < total_needed)
    8000413c:	02000793          	li	a5,32
    80004140:	12a7f163          	bgeu	a5,a0,80004262 <buddy_alloc+0x140>
    uint64 size = 1L << MIN_ORDER; // Start at 32
    80004144:	84be                	mv	s1,a5
        size <<= 1;
    80004146:	0486                	slli	s1,s1,0x1
    while (size < total_needed)
    80004148:	fea4efe3          	bltu	s1,a0,80004146 <buddy_alloc+0x24>
    acquire(&buddy_lock);
    8000414c:	0001d517          	auipc	a0,0x1d
    80004150:	bfc50513          	addi	a0,a0,-1028 # 80020d48 <buddy_lock>
    80004154:	ad5fc0ef          	jal	80000c28 <acquire>
    if (size == MAX_SIZE)
    80004158:	6785                	lui	a5,0x1
    8000415a:	04f48363          	beq	s1,a5,800041a0 <buddy_alloc+0x7e>
    8000415e:	e44e                	sd	s3,8(sp)
    int target_order = size_to_order(size);
    80004160:	8526                	mv	a0,s1
    80004162:	d19ff0ef          	jal	80003e7a <size_to_order>
    80004166:	89aa                	mv	s3,a0
    return order - MIN_ORDER;
    80004168:	ffb5079b          	addiw	a5,a0,-5
    for (i = target_index; i < NUM_LISTS; i++)
    8000416c:	4719                	li	a4,6
    8000416e:	06f74563          	blt	a4,a5,800041d8 <buddy_alloc+0xb6>
    80004172:	00379693          	slli	a3,a5,0x3
    80004176:	0001d717          	auipc	a4,0x1d
    8000417a:	b9a70713          	addi	a4,a4,-1126 # 80020d10 <free_lists>
    8000417e:	9736                	add	a4,a4,a3
    80004180:	461d                	li	a2,7
        if (free_lists[i])
    80004182:	6314                	ld	a3,0(a4)
    80004184:	eea9                	bnez	a3,800041de <buddy_alloc+0xbc>
    for (i = target_index; i < NUM_LISTS; i++)
    80004186:	2785                	addiw	a5,a5,1 # 1001 <_entry-0x7fffefff>
    80004188:	0721                	addi	a4,a4,8
    8000418a:	fec79ce3          	bne	a5,a2,80004182 <buddy_alloc+0x60>
        block_to_use = (struct header *)kalloc();
    8000418e:	9b7fc0ef          	jal	80000b44 <kalloc>
    80004192:	892a                	mv	s2,a0
        if (!block_to_use)
    80004194:	cd45                	beqz	a0,8000424c <buddy_alloc+0x12a>
    80004196:	e052                	sd	s4,0(sp)
        block_to_use->size = MAX_SIZE;
    80004198:	6785                	lui	a5,0x1
    8000419a:	e51c                	sd	a5,8(a0)
        found_order = MAX_ORDER;
    8000419c:	44b1                	li	s1,12
    8000419e:	a08d                	j	80004200 <buddy_alloc+0xde>
        struct header *block = (struct header *)kalloc();
    800041a0:	9a5fc0ef          	jal	80000b44 <kalloc>
    800041a4:	892a                	mv	s2,a0
        if (!block)
    800041a6:	c10d                	beqz	a0,800041c8 <buddy_alloc+0xa6>
        block->magic = MAGIC_USED;
    800041a8:	00004797          	auipc	a5,0x4
    800041ac:	e607b783          	ld	a5,-416(a5) # 80008008 <etext+0x8>
    800041b0:	e11c                	sd	a5,0(a0)
        block->size = MAX_SIZE;
    800041b2:	6785                	lui	a5,0x1
    800041b4:	e51c                	sd	a5,8(a0)
        release(&buddy_lock);
    800041b6:	0001d517          	auipc	a0,0x1d
    800041ba:	b9250513          	addi	a0,a0,-1134 # 80020d48 <buddy_lock>
    800041be:	afffc0ef          	jal	80000cbc <release>
    return (void *)((char *)block + sizeof(struct header));
    800041c2:	0941                	addi	s2,s2,16
        return block_to_ptr(block);
    800041c4:	64e2                	ld	s1,24(sp)
    800041c6:	a8ad                	j	80004240 <buddy_alloc+0x11e>
            release(&buddy_lock);
    800041c8:	0001d517          	auipc	a0,0x1d
    800041cc:	b8050513          	addi	a0,a0,-1152 # 80020d48 <buddy_lock>
    800041d0:	aedfc0ef          	jal	80000cbc <release>
            return 0; // kalloc failed
    800041d4:	64e2                	ld	s1,24(sp)
    800041d6:	a0ad                	j	80004240 <buddy_alloc+0x11e>
    if (i == NUM_LISTS)
    800041d8:	471d                	li	a4,7
    800041da:	fae78ae3          	beq	a5,a4,8000418e <buddy_alloc+0x6c>
    800041de:	e052                	sd	s4,0(sp)
        struct free_block *fb = free_lists[i];
    800041e0:	078e                	slli	a5,a5,0x3
    800041e2:	0001d717          	auipc	a4,0x1d
    800041e6:	b2e70713          	addi	a4,a4,-1234 # 80020d10 <free_lists>
    800041ea:	97ba                	add	a5,a5,a4
    800041ec:	6398                	ld	a4,0(a5)
        free_lists[i] = fb->next; // Unlink from list
    800041ee:	6314                	ld	a3,0(a4)
    800041f0:	e394                	sd	a3,0(a5)
    return (struct header *)((char *)ptr - sizeof(struct header));
    800041f2:	ff070913          	addi	s2,a4,-16
        found_order = size_to_order(block_to_use->size);
    800041f6:	ff873503          	ld	a0,-8(a4)
    800041fa:	c81ff0ef          	jal	80003e7a <size_to_order>
    800041fe:	84aa                	mv	s1,a0
        uint64 current_size = 1L << found_order;
    80004200:	4a05                	li	s4,1
    while (found_order > target_order)
    80004202:	0099df63          	bge	s3,s1,80004220 <buddy_alloc+0xfe>
        uint64 current_size = 1L << found_order;
    80004206:	009a17b3          	sll	a5,s4,s1
        uint64 split_size = current_size / 2;
    8000420a:	8385                	srli	a5,a5,0x1
        block_to_use->size = split_size;
    8000420c:	00f93423          	sd	a5,8(s2)
        struct header *buddy = (struct header *)((char *)block_to_use + split_size);
    80004210:	00f90533          	add	a0,s2,a5
        buddy->size = split_size;
    80004214:	e51c                	sd	a5,8(a0)
        insert_free_block(buddy);
    80004216:	c9dff0ef          	jal	80003eb2 <insert_free_block>
        found_order--; // Continue splitting the first half
    8000421a:	34fd                	addiw	s1,s1,-1
    while (found_order > target_order)
    8000421c:	fe9995e3          	bne	s3,s1,80004206 <buddy_alloc+0xe4>
    block_to_use->magic = MAGIC_USED;
    80004220:	00004797          	auipc	a5,0x4
    80004224:	de87b783          	ld	a5,-536(a5) # 80008008 <etext+0x8>
    80004228:	00f93023          	sd	a5,0(s2)
    release(&buddy_lock);
    8000422c:	0001d517          	auipc	a0,0x1d
    80004230:	b1c50513          	addi	a0,a0,-1252 # 80020d48 <buddy_lock>
    80004234:	a89fc0ef          	jal	80000cbc <release>
    return (void *)((char *)block + sizeof(struct header));
    80004238:	0941                	addi	s2,s2,16
    return block_to_ptr(block_to_use);
    8000423a:	64e2                	ld	s1,24(sp)
    8000423c:	69a2                	ld	s3,8(sp)
    8000423e:	6a02                	ld	s4,0(sp)
}
    80004240:	854a                	mv	a0,s2
    80004242:	70a2                	ld	ra,40(sp)
    80004244:	7402                	ld	s0,32(sp)
    80004246:	6942                	ld	s2,16(sp)
    80004248:	6145                	addi	sp,sp,48
    8000424a:	8082                	ret
            release(&buddy_lock);
    8000424c:	0001d517          	auipc	a0,0x1d
    80004250:	afc50513          	addi	a0,a0,-1284 # 80020d48 <buddy_lock>
    80004254:	a69fc0ef          	jal	80000cbc <release>
            return 0;
    80004258:	64e2                	ld	s1,24(sp)
    8000425a:	69a2                	ld	s3,8(sp)
    8000425c:	b7d5                	j	80004240 <buddy_alloc+0x11e>
        return 0; // Request is 0 or larger than 4080 bytes
    8000425e:	4901                	li	s2,0
    80004260:	b7c5                	j	80004240 <buddy_alloc+0x11e>
    80004262:	e44e                	sd	s3,8(sp)
    acquire(&buddy_lock);
    80004264:	0001d517          	auipc	a0,0x1d
    80004268:	ae450513          	addi	a0,a0,-1308 # 80020d48 <buddy_lock>
    8000426c:	9bdfc0ef          	jal	80000c28 <acquire>
    uint64 size = 1L << MIN_ORDER; // Start at 32
    80004270:	02000493          	li	s1,32
    80004274:	b5f5                	j	80004160 <buddy_alloc+0x3e>

0000000080004276 <buddy_free>:
    if (ptr == 0)
    80004276:	14050763          	beqz	a0,800043c4 <buddy_free+0x14e>
{
    8000427a:	7139                	addi	sp,sp,-64
    8000427c:	fc06                	sd	ra,56(sp)
    8000427e:	f822                	sd	s0,48(sp)
    80004280:	f426                	sd	s1,40(sp)
    80004282:	f04a                	sd	s2,32(sp)
    80004284:	ec4e                	sd	s3,24(sp)
    80004286:	e852                	sd	s4,16(sp)
    80004288:	e456                	sd	s5,8(sp)
    8000428a:	0080                	addi	s0,sp,64
    8000428c:	8a2a                	mv	s4,a0
    if (block->magic != MAGIC_USED)
    8000428e:	5f77f737          	lui	a4,0x5f77f
    80004292:	0706                	slli	a4,a4,0x1
    80004294:	ead70713          	addi	a4,a4,-339 # 5f77eead <_entry-0x20881153>
    80004298:	37ab77b7          	lui	a5,0x37ab7
    8000429c:	078a                	slli	a5,a5,0x2
    8000429e:	eef78793          	addi	a5,a5,-273 # 37ab6eef <_entry-0x48549111>
    800042a2:	1782                	slli	a5,a5,0x20
    800042a4:	97ba                	add	a5,a5,a4
    800042a6:	ff053703          	ld	a4,-16(a0)
    800042aa:	06f71063          	bne	a4,a5,8000430a <buddy_free+0x94>
    uint64 size = block->size;
    800042ae:	ff853483          	ld	s1,-8(a0)
    int order = size_to_order(size);
    800042b2:	8526                	mv	a0,s1
    800042b4:	bc7ff0ef          	jal	80003e7a <size_to_order>
    800042b8:	89aa                	mv	s3,a0
    if (order < MIN_ORDER || order > MAX_ORDER)
    800042ba:	ffb50a9b          	addiw	s5,a0,-5
    800042be:	479d                	li	a5,7
    800042c0:	0557eb63          	bltu	a5,s5,80004316 <buddy_free+0xa0>
    return (struct header *)((char *)ptr - sizeof(struct header));
    800042c4:	ff0a0913          	addi	s2,s4,-16
    if ((uint64)block % size != 0)
    800042c8:	029977b3          	remu	a5,s2,s1
    800042cc:	ebb9                	bnez	a5,80004322 <buddy_free+0xac>
    acquire(&buddy_lock);
    800042ce:	0001d517          	auipc	a0,0x1d
    800042d2:	a7a50513          	addi	a0,a0,-1414 # 80020d48 <buddy_lock>
    800042d6:	953fc0ef          	jal	80000c28 <acquire>
    while (order < MAX_ORDER - 1)
    800042da:	47a9                	li	a5,10
    800042dc:	0b37c563          	blt	a5,s3,80004386 <buddy_free+0x110>
    800042e0:	0a8e                	slli	s5,s5,0x3
    800042e2:	0001d597          	auipc	a1,0x1d
    800042e6:	a2e58593          	addi	a1,a1,-1490 # 80020d10 <free_lists>
    800042ea:	95d6                	add	a1,a1,s5
        if (buddy->magic != MAGIC_FREE || buddy->size != size)
    800042ec:	ffeee537          	lui	a0,0xffeee
    800042f0:	bef50513          	addi	a0,a0,-1041 # ffffffffffeedbef <end+0xffffffff7fecbcf7>
    800042f4:	055e                	slli	a0,a0,0x17
    800042f6:	80050513          	addi	a0,a0,-2048
    800042fa:	f5f50513          	addi	a0,a0,-161
    800042fe:	0536                	slli	a0,a0,0xd
    80004300:	eef50513          	addi	a0,a0,-273
        size = 1L << order;
    80004304:	4305                	li	t1,1
    while (order < MAX_ORDER - 1)
    80004306:	48ad                	li	a7,11
    80004308:	a099                	j	8000434e <buddy_free+0xd8>
        panic("buddy_free: invalid magic number");
    8000430a:	00004517          	auipc	a0,0x4
    8000430e:	34e50513          	addi	a0,a0,846 # 80008658 <etext+0x658>
    80004312:	d12fc0ef          	jal	80000824 <panic>
        panic("buddy_free: invalid block size");
    80004316:	00004517          	auipc	a0,0x4
    8000431a:	36a50513          	addi	a0,a0,874 # 80008680 <etext+0x680>
    8000431e:	d06fc0ef          	jal	80000824 <panic>
        panic("buddy_free: invalid alignment");
    80004322:	00004517          	auipc	a0,0x4
    80004326:	37e50513          	addi	a0,a0,894 # 800086a0 <etext+0x6a0>
    8000432a:	cfafc0ef          	jal	80000824 <panic>
        if (rover == 0)
    8000432e:	c7b1                	beqz	a5,8000437a <buddy_free+0x104>
            prev->next = rover->next;
    80004330:	639c                	ld	a5,0(a5)
    80004332:	e29c                	sd	a5,0(a3)
        if ((uint64)buddy < (uint64)block)
    80004334:	01067363          	bgeu	a2,a6,8000433a <buddy_free+0xc4>
            block = buddy; // New block starts at buddy's address
    80004338:	8932                	mv	s2,a2
        order++;
    8000433a:	0019849b          	addiw	s1,s3,1
    8000433e:	89a6                	mv	s3,s1
        size = 1L << order;
    80004340:	009314b3          	sll	s1,t1,s1
        block->size = size;
    80004344:	00993423          	sd	s1,8(s2)
    while (order < MAX_ORDER - 1)
    80004348:	05a1                	addi	a1,a1,8
    8000434a:	05198763          	beq	s3,a7,80004398 <buddy_free+0x122>
        uint64 buddy_addr = (uint64)block ^ size;
    8000434e:	884a                	mv	a6,s2
    80004350:	00994633          	xor	a2,s2,s1
        if (buddy->magic != MAGIC_FREE || buddy->size != size)
    80004354:	621c                	ld	a5,0(a2)
    80004356:	04a79163          	bne	a5,a0,80004398 <buddy_free+0x122>
    8000435a:	661c                	ld	a5,8(a2)
    8000435c:	02979e63          	bne	a5,s1,80004398 <buddy_free+0x122>
        struct free_block *rover = *list_head;
    80004360:	86ae                	mv	a3,a1
    80004362:	619c                	ld	a5,0(a1)
    return (void *)((char *)block + sizeof(struct header));
    80004364:	01060713          	addi	a4,a2,16
        while (rover && rover != fb_buddy)
    80004368:	cbb1                	beqz	a5,800043bc <buddy_free+0x146>
    8000436a:	04e78963          	beq	a5,a4,800043bc <buddy_free+0x146>
            rover = rover->next;
    8000436e:	86be                	mv	a3,a5
    80004370:	639c                	ld	a5,0(a5)
        while (rover && rover != fb_buddy)
    80004372:	dfd5                	beqz	a5,8000432e <buddy_free+0xb8>
    80004374:	fee79de3          	bne	a5,a4,8000436e <buddy_free+0xf8>
    80004378:	bf5d                	j	8000432e <buddy_free+0xb8>
            panic("buddy_free: free list corruption");
    8000437a:	00004517          	auipc	a0,0x4
    8000437e:	34650513          	addi	a0,a0,838 # 800086c0 <etext+0x6c0>
    80004382:	ca2fc0ef          	jal	80000824 <panic>
    if (order == MAX_ORDER)
    80004386:	47b1                	li	a5,12
    80004388:	00f99863          	bne	s3,a5,80004398 <buddy_free+0x122>
        block->magic = 0; // Invalidate magic
    8000438c:	fe0a3823          	sd	zero,-16(s4)
        kfree((void *)block);
    80004390:	854a                	mv	a0,s2
    80004392:	ecafc0ef          	jal	80000a5c <kfree>
    80004396:	a021                	j	8000439e <buddy_free+0x128>
        insert_free_block(block);
    80004398:	854a                	mv	a0,s2
    8000439a:	b19ff0ef          	jal	80003eb2 <insert_free_block>
    release(&buddy_lock);
    8000439e:	0001d517          	auipc	a0,0x1d
    800043a2:	9aa50513          	addi	a0,a0,-1622 # 80020d48 <buddy_lock>
    800043a6:	917fc0ef          	jal	80000cbc <release>
}
    800043aa:	70e2                	ld	ra,56(sp)
    800043ac:	7442                	ld	s0,48(sp)
    800043ae:	74a2                	ld	s1,40(sp)
    800043b0:	7902                	ld	s2,32(sp)
    800043b2:	69e2                	ld	s3,24(sp)
    800043b4:	6a42                	ld	s4,16(sp)
    800043b6:	6aa2                	ld	s5,8(sp)
    800043b8:	6121                	addi	sp,sp,64
    800043ba:	8082                	ret
        if (rover == 0)
    800043bc:	dfdd                	beqz	a5,8000437a <buddy_free+0x104>
            *list_head = rover->next;
    800043be:	639c                	ld	a5,0(a5)
    800043c0:	e29c                	sd	a5,0(a3)
    800043c2:	bf8d                	j	80004334 <buddy_free+0xbe>
    800043c4:	8082                	ret

00000000800043c6 <buddy_print>:
// Print the structure of a 4096-byte block
void buddy_print(void *ptr)
{
    800043c6:	1101                	addi	sp,sp,-32
    800043c8:	ec06                	sd	ra,24(sp)
    800043ca:	e822                	sd	s0,16(sp)
    800043cc:	1000                	addi	s0,sp,32
    if (ptr == 0)
    800043ce:	c52d                	beqz	a0,80004438 <buddy_print+0x72>
    800043d0:	e426                	sd	s1,8(sp)
    return (struct header *)((char *)ptr - sizeof(struct header));
    800043d2:	1541                	addi	a0,a0,-16
        printf("\nbuddy_print: null pointer\n");
        return;
    }

    struct header *block = ptr_to_block(ptr);
    uint64 page_addr = (uint64)block & ~(MAX_SIZE - 1);
    800043d4:	77fd                	lui	a5,0xfffff
    800043d6:	00f574b3          	and	s1,a0,a5
    struct header *page = (struct header *)page_addr;

    printf("\n"); // Start with a newline per example
    800043da:	00004517          	auipc	a0,0x4
    800043de:	cae50513          	addi	a0,a0,-850 # 80008088 <etext+0x88>
    800043e2:	918fc0ef          	jal	800004fa <printf>

    // Check the 4096-byte page itself
    if (page->size == MAX_SIZE)
    800043e6:	6498                	ld	a4,8(s1)
    800043e8:	6785                	lui	a5,0x1
    800043ea:	06f71e63          	bne	a4,a5,80004466 <buddy_print+0xa0>
    {
        if (page->magic == MAGIC_USED)
    800043ee:	6094                	ld	a3,0(s1)
    800043f0:	5f77f737          	lui	a4,0x5f77f
    800043f4:	0706                	slli	a4,a4,0x1
    800043f6:	ead70713          	addi	a4,a4,-339 # 5f77eead <_entry-0x20881153>
    800043fa:	37ab77b7          	lui	a5,0x37ab7
    800043fe:	078a                	slli	a5,a5,0x2
    80004400:	eef78793          	addi	a5,a5,-273 # 37ab6eef <_entry-0x48549111>
    80004404:	1782                	slli	a5,a5,0x20
    80004406:	97ba                	add	a5,a5,a4
    80004408:	02f68f63          	beq	a3,a5,80004446 <buddy_print+0x80>
        {
            printf("used (4096)\n");
        }
        else if (page->magic == MAGIC_FREE)
    8000440c:	ffeee7b7          	lui	a5,0xffeee
    80004410:	bef78793          	addi	a5,a5,-1041 # ffffffffffeedbef <end+0xffffffff7fecbcf7>
    80004414:	07de                	slli	a5,a5,0x17
    80004416:	80078793          	addi	a5,a5,-2048
    8000441a:	f5f78793          	addi	a5,a5,-161
    8000441e:	07b6                	slli	a5,a5,0xd
    80004420:	eef78793          	addi	a5,a5,-273
    80004424:	02f68963          	beq	a3,a5,80004456 <buddy_print+0x90>
        {
            printf("free (4096)\n");
        }
        else
        {
            printf("corrupt (4096)\n");
    80004428:	00004517          	auipc	a0,0x4
    8000442c:	30050513          	addi	a0,a0,768 # 80008728 <etext+0x728>
    80004430:	8cafc0ef          	jal	800004fa <printf>
    80004434:	64a2                	ld	s1,8(sp)
    80004436:	a09d                	j	8000449c <buddy_print+0xd6>
        printf("\nbuddy_print: null pointer\n");
    80004438:	00004517          	auipc	a0,0x4
    8000443c:	2b050513          	addi	a0,a0,688 # 800086e8 <etext+0x6e8>
    80004440:	8bafc0ef          	jal	800004fa <printf>
        return;
    80004444:	a8a1                	j	8000449c <buddy_print+0xd6>
            printf("used (4096)\n");
    80004446:	00004517          	auipc	a0,0x4
    8000444a:	2c250513          	addi	a0,a0,706 # 80008708 <etext+0x708>
    8000444e:	8acfc0ef          	jal	800004fa <printf>
    80004452:	64a2                	ld	s1,8(sp)
    80004454:	a0a1                	j	8000449c <buddy_print+0xd6>
            printf("free (4096)\n");
    80004456:	00004517          	auipc	a0,0x4
    8000445a:	2c250513          	addi	a0,a0,706 # 80008718 <etext+0x718>
    8000445e:	89cfc0ef          	jal	800004fa <printf>
    80004462:	64a2                	ld	s1,8(sp)
    80004464:	a825                	j	8000449c <buddy_print+0xd6>
        // It's split. Call the recursive helper.
        uint64 split_size = MAX_SIZE / 2;
        struct header *buddy = (struct header *)((char *)page + split_size);

        // We pass "   " (3 ASCII spaces) as the *base* prefix
        print_tree(buddy, MAX_ORDER - 1, "   ", 1); // 1 = is top child
    80004466:	4685                	li	a3,1
    80004468:	00004617          	auipc	a2,0x4
    8000446c:	2d060613          	addi	a2,a2,720 # 80008738 <etext+0x738>
    80004470:	45ad                	li	a1,11
    80004472:	7ff48513          	addi	a0,s1,2047
    80004476:	9536                	add	a0,a0,a3
    80004478:	a9bff0ef          	jal	80003f12 <print_tree>
        printf("───┤\n");
    8000447c:	00004517          	auipc	a0,0x4
    80004480:	2c450513          	addi	a0,a0,708 # 80008740 <etext+0x740>
    80004484:	876fc0ef          	jal	800004fa <printf>
        print_tree(page, MAX_ORDER - 1, "   ", 0); // 0 = is bottom child
    80004488:	4681                	li	a3,0
    8000448a:	00004617          	auipc	a2,0x4
    8000448e:	2ae60613          	addi	a2,a2,686 # 80008738 <etext+0x738>
    80004492:	45ad                	li	a1,11
    80004494:	8526                	mv	a0,s1
    80004496:	a7dff0ef          	jal	80003f12 <print_tree>
    8000449a:	64a2                	ld	s1,8(sp)
    }
}
    8000449c:	60e2                	ld	ra,24(sp)
    8000449e:	6442                	ld	s0,16(sp)
    800044a0:	6105                	addi	sp,sp,32
    800044a2:	8082                	ret

00000000800044a4 <buddy_test>:
// Test function as provided in the prompt
void buddy_test(void)
{
    800044a4:	7179                	addi	sp,sp,-48
    800044a6:	f406                	sd	ra,40(sp)
    800044a8:	f022                	sd	s0,32(sp)
    800044aa:	ec26                	sd	s1,24(sp)
    800044ac:	e84a                	sd	s2,16(sp)
    800044ae:	e44e                	sd	s3,8(sp)
    800044b0:	1800                	addi	s0,sp,48
    printf("Starting buddy test\n");
    800044b2:	00004517          	auipc	a0,0x4
    800044b6:	29e50513          	addi	a0,a0,670 # 80008750 <etext+0x750>
    800044ba:	840fc0ef          	jal	800004fa <printf>

    printf("\nallocating 1024-byte block\n");
    800044be:	00004517          	auipc	a0,0x4
    800044c2:	2aa50513          	addi	a0,a0,682 # 80008768 <etext+0x768>
    800044c6:	834fc0ef          	jal	800004fa <printf>
    void *e = buddy_alloc(1000);
    800044ca:	3e800513          	li	a0,1000
    800044ce:	c55ff0ef          	jal	80004122 <buddy_alloc>
    800044d2:	84aa                	mv	s1,a0
    buddy_print(e);
    800044d4:	ef3ff0ef          	jal	800043c6 <buddy_print>

    printf("\nallocating 128-byte block\n");
    800044d8:	00004517          	auipc	a0,0x4
    800044dc:	2b050513          	addi	a0,a0,688 # 80008788 <etext+0x788>
    800044e0:	81afc0ef          	jal	800004fa <printf>
    void *c = buddy_alloc(112);
    800044e4:	07000513          	li	a0,112
    800044e8:	c3bff0ef          	jal	80004122 <buddy_alloc>
    800044ec:	89aa                	mv	s3,a0
    buddy_print(c);
    800044ee:	ed9ff0ef          	jal	800043c6 <buddy_print>

    printf("\nallocating 32-byte block\n");
    800044f2:	00004517          	auipc	a0,0x4
    800044f6:	2b650513          	addi	a0,a0,694 # 800087a8 <etext+0x7a8>
    800044fa:	800fc0ef          	jal	800004fa <printf>
    void *a = buddy_alloc(16);
    800044fe:	4541                	li	a0,16
    80004500:	c23ff0ef          	jal	80004122 <buddy_alloc>
    80004504:	892a                	mv	s2,a0
    buddy_print(a);
    80004506:	ec1ff0ef          	jal	800043c6 <buddy_print>

    printf("\nfreeing 1024-byte block\n");
    8000450a:	00004517          	auipc	a0,0x4
    8000450e:	2be50513          	addi	a0,a0,702 # 800087c8 <etext+0x7c8>
    80004512:	fe9fb0ef          	jal	800004fa <printf>
    buddy_free(e);
    80004516:	8526                	mv	a0,s1
    80004518:	d5fff0ef          	jal	80004276 <buddy_free>
    buddy_print(a);
    8000451c:	854a                	mv	a0,s2
    8000451e:	ea9ff0ef          	jal	800043c6 <buddy_print>

    printf("\nallocating 128-byte block\n");
    80004522:	00004517          	auipc	a0,0x4
    80004526:	26650513          	addi	a0,a0,614 # 80008788 <etext+0x788>
    8000452a:	fd1fb0ef          	jal	800004fa <printf>
    void *b = buddy_alloc(112);
    8000452e:	07000513          	li	a0,112
    80004532:	bf1ff0ef          	jal	80004122 <buddy_alloc>
    80004536:	84aa                	mv	s1,a0
    buddy_print(b);
    80004538:	e8fff0ef          	jal	800043c6 <buddy_print>

    printf("\nfreeing 32-byte block\n");
    8000453c:	00004517          	auipc	a0,0x4
    80004540:	2ac50513          	addi	a0,a0,684 # 800087e8 <etext+0x7e8>
    80004544:	fb7fb0ef          	jal	800004fa <printf>
    buddy_free(a);
    80004548:	854a                	mv	a0,s2
    8000454a:	d2dff0ef          	jal	80004276 <buddy_free>
    buddy_print(b);
    8000454e:	8526                	mv	a0,s1
    80004550:	e77ff0ef          	jal	800043c6 <buddy_print>

    printf("\nfreeing first 128-byte block\n");
    80004554:	00004517          	auipc	a0,0x4
    80004558:	2ac50513          	addi	a0,a0,684 # 80008800 <etext+0x800>
    8000455c:	f9ffb0ef          	jal	800004fa <printf>
    buddy_free(c);
    80004560:	854e                	mv	a0,s3
    80004562:	d15ff0ef          	jal	80004276 <buddy_free>
    buddy_print(b);
    80004566:	8526                	mv	a0,s1
    80004568:	e5fff0ef          	jal	800043c6 <buddy_print>

    printf("\nallocating 2048-byte block\n");
    8000456c:	00004517          	auipc	a0,0x4
    80004570:	2b450513          	addi	a0,a0,692 # 80008820 <etext+0x820>
    80004574:	f87fb0ef          	jal	800004fa <printf>
    void *d = buddy_alloc(2000);
    80004578:	7d000513          	li	a0,2000
    8000457c:	ba7ff0ef          	jal	80004122 <buddy_alloc>
    80004580:	892a                	mv	s2,a0
    buddy_print(d);
    80004582:	e45ff0ef          	jal	800043c6 <buddy_print>

    printf("\nfreeing other 128-byte block\n");
    80004586:	00004517          	auipc	a0,0x4
    8000458a:	2ba50513          	addi	a0,a0,698 # 80008840 <etext+0x840>
    8000458e:	f6dfb0ef          	jal	800004fa <printf>
    buddy_free(b);
    80004592:	8526                	mv	a0,s1
    80004594:	ce3ff0ef          	jal	80004276 <buddy_free>
    buddy_print(d);
    80004598:	854a                	mv	a0,s2
    8000459a:	e2dff0ef          	jal	800043c6 <buddy_print>

    printf("\nfreeing 2048-byte block\n");
    8000459e:	00004517          	auipc	a0,0x4
    800045a2:	2c250513          	addi	a0,a0,706 # 80008860 <etext+0x860>
    800045a6:	f55fb0ef          	jal	800004fa <printf>
    buddy_free(d);
    800045aa:	854a                	mv	a0,s2
    800045ac:	ccbff0ef          	jal	80004276 <buddy_free>
}
    800045b0:	70a2                	ld	ra,40(sp)
    800045b2:	7402                	ld	s0,32(sp)
    800045b4:	64e2                	ld	s1,24(sp)
    800045b6:	6942                	ld	s2,16(sp)
    800045b8:	69a2                	ld	s3,8(sp)
    800045ba:	6145                	addi	sp,sp,48
    800045bc:	8082                	ret

00000000800045be <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800045be:	1101                	addi	sp,sp,-32
    800045c0:	ec06                	sd	ra,24(sp)
    800045c2:	e822                	sd	s0,16(sp)
    800045c4:	e426                	sd	s1,8(sp)
    800045c6:	e04a                	sd	s2,0(sp)
    800045c8:	1000                	addi	s0,sp,32
    800045ca:	84aa                	mv	s1,a0
    800045cc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800045ce:	00004597          	auipc	a1,0x4
    800045d2:	2b258593          	addi	a1,a1,690 # 80008880 <etext+0x880>
    800045d6:	0521                	addi	a0,a0,8
    800045d8:	dc6fc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    800045dc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800045e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800045e4:	0204a423          	sw	zero,40(s1)
}
    800045e8:	60e2                	ld	ra,24(sp)
    800045ea:	6442                	ld	s0,16(sp)
    800045ec:	64a2                	ld	s1,8(sp)
    800045ee:	6902                	ld	s2,0(sp)
    800045f0:	6105                	addi	sp,sp,32
    800045f2:	8082                	ret

00000000800045f4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800045f4:	1101                	addi	sp,sp,-32
    800045f6:	ec06                	sd	ra,24(sp)
    800045f8:	e822                	sd	s0,16(sp)
    800045fa:	e426                	sd	s1,8(sp)
    800045fc:	e04a                	sd	s2,0(sp)
    800045fe:	1000                	addi	s0,sp,32
    80004600:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004602:	00850913          	addi	s2,a0,8
    80004606:	854a                	mv	a0,s2
    80004608:	e20fc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    8000460c:	409c                	lw	a5,0(s1)
    8000460e:	c799                	beqz	a5,8000461c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004610:	85ca                	mv	a1,s2
    80004612:	8526                	mv	a0,s1
    80004614:	91dfd0ef          	jal	80001f30 <sleep>
  while (lk->locked) {
    80004618:	409c                	lw	a5,0(s1)
    8000461a:	fbfd                	bnez	a5,80004610 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000461c:	4785                	li	a5,1
    8000461e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004620:	b12fd0ef          	jal	80001932 <myproc>
    80004624:	591c                	lw	a5,48(a0)
    80004626:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004628:	854a                	mv	a0,s2
    8000462a:	e92fc0ef          	jal	80000cbc <release>
}
    8000462e:	60e2                	ld	ra,24(sp)
    80004630:	6442                	ld	s0,16(sp)
    80004632:	64a2                	ld	s1,8(sp)
    80004634:	6902                	ld	s2,0(sp)
    80004636:	6105                	addi	sp,sp,32
    80004638:	8082                	ret

000000008000463a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000463a:	1101                	addi	sp,sp,-32
    8000463c:	ec06                	sd	ra,24(sp)
    8000463e:	e822                	sd	s0,16(sp)
    80004640:	e426                	sd	s1,8(sp)
    80004642:	e04a                	sd	s2,0(sp)
    80004644:	1000                	addi	s0,sp,32
    80004646:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004648:	00850913          	addi	s2,a0,8
    8000464c:	854a                	mv	a0,s2
    8000464e:	ddafc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    80004652:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004656:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000465a:	8526                	mv	a0,s1
    8000465c:	921fd0ef          	jal	80001f7c <wakeup>
  release(&lk->lk);
    80004660:	854a                	mv	a0,s2
    80004662:	e5afc0ef          	jal	80000cbc <release>
}
    80004666:	60e2                	ld	ra,24(sp)
    80004668:	6442                	ld	s0,16(sp)
    8000466a:	64a2                	ld	s1,8(sp)
    8000466c:	6902                	ld	s2,0(sp)
    8000466e:	6105                	addi	sp,sp,32
    80004670:	8082                	ret

0000000080004672 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004672:	7179                	addi	sp,sp,-48
    80004674:	f406                	sd	ra,40(sp)
    80004676:	f022                	sd	s0,32(sp)
    80004678:	ec26                	sd	s1,24(sp)
    8000467a:	e84a                	sd	s2,16(sp)
    8000467c:	1800                	addi	s0,sp,48
    8000467e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004680:	00850913          	addi	s2,a0,8
    80004684:	854a                	mv	a0,s2
    80004686:	da2fc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000468a:	409c                	lw	a5,0(s1)
    8000468c:	ef81                	bnez	a5,800046a4 <holdingsleep+0x32>
    8000468e:	4481                	li	s1,0
  release(&lk->lk);
    80004690:	854a                	mv	a0,s2
    80004692:	e2afc0ef          	jal	80000cbc <release>
  return r;
}
    80004696:	8526                	mv	a0,s1
    80004698:	70a2                	ld	ra,40(sp)
    8000469a:	7402                	ld	s0,32(sp)
    8000469c:	64e2                	ld	s1,24(sp)
    8000469e:	6942                	ld	s2,16(sp)
    800046a0:	6145                	addi	sp,sp,48
    800046a2:	8082                	ret
    800046a4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800046a6:	0284a983          	lw	s3,40(s1)
    800046aa:	a88fd0ef          	jal	80001932 <myproc>
    800046ae:	5904                	lw	s1,48(a0)
    800046b0:	413484b3          	sub	s1,s1,s3
    800046b4:	0014b493          	seqz	s1,s1
    800046b8:	69a2                	ld	s3,8(sp)
    800046ba:	bfd9                	j	80004690 <holdingsleep+0x1e>

00000000800046bc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800046bc:	1141                	addi	sp,sp,-16
    800046be:	e406                	sd	ra,8(sp)
    800046c0:	e022                	sd	s0,0(sp)
    800046c2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800046c4:	00004597          	auipc	a1,0x4
    800046c8:	1cc58593          	addi	a1,a1,460 # 80008890 <etext+0x890>
    800046cc:	0001c517          	auipc	a0,0x1c
    800046d0:	73450513          	addi	a0,a0,1844 # 80020e00 <ftable>
    800046d4:	ccafc0ef          	jal	80000b9e <initlock>
}
    800046d8:	60a2                	ld	ra,8(sp)
    800046da:	6402                	ld	s0,0(sp)
    800046dc:	0141                	addi	sp,sp,16
    800046de:	8082                	ret

00000000800046e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800046e0:	1101                	addi	sp,sp,-32
    800046e2:	ec06                	sd	ra,24(sp)
    800046e4:	e822                	sd	s0,16(sp)
    800046e6:	e426                	sd	s1,8(sp)
    800046e8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800046ea:	0001c517          	auipc	a0,0x1c
    800046ee:	71650513          	addi	a0,a0,1814 # 80020e00 <ftable>
    800046f2:	d36fc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800046f6:	0001c497          	auipc	s1,0x1c
    800046fa:	72248493          	addi	s1,s1,1826 # 80020e18 <ftable+0x18>
    800046fe:	0001d717          	auipc	a4,0x1d
    80004702:	6ba70713          	addi	a4,a4,1722 # 80021db8 <disk>
    if(f->ref == 0){
    80004706:	40dc                	lw	a5,4(s1)
    80004708:	cf89                	beqz	a5,80004722 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000470a:	02848493          	addi	s1,s1,40
    8000470e:	fee49ce3          	bne	s1,a4,80004706 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004712:	0001c517          	auipc	a0,0x1c
    80004716:	6ee50513          	addi	a0,a0,1774 # 80020e00 <ftable>
    8000471a:	da2fc0ef          	jal	80000cbc <release>
  return 0;
    8000471e:	4481                	li	s1,0
    80004720:	a809                	j	80004732 <filealloc+0x52>
      f->ref = 1;
    80004722:	4785                	li	a5,1
    80004724:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004726:	0001c517          	auipc	a0,0x1c
    8000472a:	6da50513          	addi	a0,a0,1754 # 80020e00 <ftable>
    8000472e:	d8efc0ef          	jal	80000cbc <release>
}
    80004732:	8526                	mv	a0,s1
    80004734:	60e2                	ld	ra,24(sp)
    80004736:	6442                	ld	s0,16(sp)
    80004738:	64a2                	ld	s1,8(sp)
    8000473a:	6105                	addi	sp,sp,32
    8000473c:	8082                	ret

000000008000473e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000473e:	1101                	addi	sp,sp,-32
    80004740:	ec06                	sd	ra,24(sp)
    80004742:	e822                	sd	s0,16(sp)
    80004744:	e426                	sd	s1,8(sp)
    80004746:	1000                	addi	s0,sp,32
    80004748:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000474a:	0001c517          	auipc	a0,0x1c
    8000474e:	6b650513          	addi	a0,a0,1718 # 80020e00 <ftable>
    80004752:	cd6fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004756:	40dc                	lw	a5,4(s1)
    80004758:	02f05063          	blez	a5,80004778 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000475c:	2785                	addiw	a5,a5,1
    8000475e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004760:	0001c517          	auipc	a0,0x1c
    80004764:	6a050513          	addi	a0,a0,1696 # 80020e00 <ftable>
    80004768:	d54fc0ef          	jal	80000cbc <release>
  return f;
}
    8000476c:	8526                	mv	a0,s1
    8000476e:	60e2                	ld	ra,24(sp)
    80004770:	6442                	ld	s0,16(sp)
    80004772:	64a2                	ld	s1,8(sp)
    80004774:	6105                	addi	sp,sp,32
    80004776:	8082                	ret
    panic("filedup");
    80004778:	00004517          	auipc	a0,0x4
    8000477c:	12050513          	addi	a0,a0,288 # 80008898 <etext+0x898>
    80004780:	8a4fc0ef          	jal	80000824 <panic>

0000000080004784 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004784:	7139                	addi	sp,sp,-64
    80004786:	fc06                	sd	ra,56(sp)
    80004788:	f822                	sd	s0,48(sp)
    8000478a:	f426                	sd	s1,40(sp)
    8000478c:	0080                	addi	s0,sp,64
    8000478e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004790:	0001c517          	auipc	a0,0x1c
    80004794:	67050513          	addi	a0,a0,1648 # 80020e00 <ftable>
    80004798:	c90fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    8000479c:	40dc                	lw	a5,4(s1)
    8000479e:	04f05a63          	blez	a5,800047f2 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800047a2:	37fd                	addiw	a5,a5,-1
    800047a4:	c0dc                	sw	a5,4(s1)
    800047a6:	06f04063          	bgtz	a5,80004806 <fileclose+0x82>
    800047aa:	f04a                	sd	s2,32(sp)
    800047ac:	ec4e                	sd	s3,24(sp)
    800047ae:	e852                	sd	s4,16(sp)
    800047b0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800047b2:	0004a903          	lw	s2,0(s1)
    800047b6:	0094c783          	lbu	a5,9(s1)
    800047ba:	89be                	mv	s3,a5
    800047bc:	689c                	ld	a5,16(s1)
    800047be:	8a3e                	mv	s4,a5
    800047c0:	6c9c                	ld	a5,24(s1)
    800047c2:	8abe                	mv	s5,a5
  f->ref = 0;
    800047c4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800047c8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800047cc:	0001c517          	auipc	a0,0x1c
    800047d0:	63450513          	addi	a0,a0,1588 # 80020e00 <ftable>
    800047d4:	ce8fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    800047d8:	4785                	li	a5,1
    800047da:	04f90163          	beq	s2,a5,8000481c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800047de:	ffe9079b          	addiw	a5,s2,-2
    800047e2:	4705                	li	a4,1
    800047e4:	04f77563          	bgeu	a4,a5,8000482e <fileclose+0xaa>
    800047e8:	7902                	ld	s2,32(sp)
    800047ea:	69e2                	ld	s3,24(sp)
    800047ec:	6a42                	ld	s4,16(sp)
    800047ee:	6aa2                	ld	s5,8(sp)
    800047f0:	a00d                	j	80004812 <fileclose+0x8e>
    800047f2:	f04a                	sd	s2,32(sp)
    800047f4:	ec4e                	sd	s3,24(sp)
    800047f6:	e852                	sd	s4,16(sp)
    800047f8:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800047fa:	00004517          	auipc	a0,0x4
    800047fe:	0a650513          	addi	a0,a0,166 # 800088a0 <etext+0x8a0>
    80004802:	822fc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    80004806:	0001c517          	auipc	a0,0x1c
    8000480a:	5fa50513          	addi	a0,a0,1530 # 80020e00 <ftable>
    8000480e:	caefc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004812:	70e2                	ld	ra,56(sp)
    80004814:	7442                	ld	s0,48(sp)
    80004816:	74a2                	ld	s1,40(sp)
    80004818:	6121                	addi	sp,sp,64
    8000481a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000481c:	85ce                	mv	a1,s3
    8000481e:	8552                	mv	a0,s4
    80004820:	348000ef          	jal	80004b68 <pipeclose>
    80004824:	7902                	ld	s2,32(sp)
    80004826:	69e2                	ld	s3,24(sp)
    80004828:	6a42                	ld	s4,16(sp)
    8000482a:	6aa2                	ld	s5,8(sp)
    8000482c:	b7dd                	j	80004812 <fileclose+0x8e>
    begin_op();
    8000482e:	beeff0ef          	jal	80003c1c <begin_op>
    iput(ff.ip);
    80004832:	8556                	mv	a0,s5
    80004834:	b5ffe0ef          	jal	80003392 <iput>
    end_op();
    80004838:	c54ff0ef          	jal	80003c8c <end_op>
    8000483c:	7902                	ld	s2,32(sp)
    8000483e:	69e2                	ld	s3,24(sp)
    80004840:	6a42                	ld	s4,16(sp)
    80004842:	6aa2                	ld	s5,8(sp)
    80004844:	b7f9                	j	80004812 <fileclose+0x8e>

0000000080004846 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004846:	715d                	addi	sp,sp,-80
    80004848:	e486                	sd	ra,72(sp)
    8000484a:	e0a2                	sd	s0,64(sp)
    8000484c:	fc26                	sd	s1,56(sp)
    8000484e:	f052                	sd	s4,32(sp)
    80004850:	0880                	addi	s0,sp,80
    80004852:	84aa                	mv	s1,a0
    80004854:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004856:	8dcfd0ef          	jal	80001932 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000485a:	409c                	lw	a5,0(s1)
    8000485c:	37f9                	addiw	a5,a5,-2
    8000485e:	4705                	li	a4,1
    80004860:	04f76263          	bltu	a4,a5,800048a4 <filestat+0x5e>
    80004864:	f84a                	sd	s2,48(sp)
    80004866:	f44e                	sd	s3,40(sp)
    80004868:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000486a:	6c88                	ld	a0,24(s1)
    8000486c:	9a5fe0ef          	jal	80003210 <ilock>
    stati(f->ip, &st);
    80004870:	fb840913          	addi	s2,s0,-72
    80004874:	85ca                	mv	a1,s2
    80004876:	6c88                	ld	a0,24(s1)
    80004878:	cfdfe0ef          	jal	80003574 <stati>
    iunlock(f->ip);
    8000487c:	6c88                	ld	a0,24(s1)
    8000487e:	a41fe0ef          	jal	800032be <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004882:	46e1                	li	a3,24
    80004884:	864a                	mv	a2,s2
    80004886:	85d2                	mv	a1,s4
    80004888:	0509b503          	ld	a0,80(s3)
    8000488c:	dcdfc0ef          	jal	80001658 <copyout>
    80004890:	41f5551b          	sraiw	a0,a0,0x1f
    80004894:	7942                	ld	s2,48(sp)
    80004896:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004898:	60a6                	ld	ra,72(sp)
    8000489a:	6406                	ld	s0,64(sp)
    8000489c:	74e2                	ld	s1,56(sp)
    8000489e:	7a02                	ld	s4,32(sp)
    800048a0:	6161                	addi	sp,sp,80
    800048a2:	8082                	ret
  return -1;
    800048a4:	557d                	li	a0,-1
    800048a6:	bfcd                	j	80004898 <filestat+0x52>

00000000800048a8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800048a8:	7179                	addi	sp,sp,-48
    800048aa:	f406                	sd	ra,40(sp)
    800048ac:	f022                	sd	s0,32(sp)
    800048ae:	e84a                	sd	s2,16(sp)
    800048b0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800048b2:	00854783          	lbu	a5,8(a0)
    800048b6:	cfd1                	beqz	a5,80004952 <fileread+0xaa>
    800048b8:	ec26                	sd	s1,24(sp)
    800048ba:	e44e                	sd	s3,8(sp)
    800048bc:	84aa                	mv	s1,a0
    800048be:	892e                	mv	s2,a1
    800048c0:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800048c2:	411c                	lw	a5,0(a0)
    800048c4:	4705                	li	a4,1
    800048c6:	04e78363          	beq	a5,a4,8000490c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048ca:	470d                	li	a4,3
    800048cc:	04e78763          	beq	a5,a4,8000491a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800048d0:	4709                	li	a4,2
    800048d2:	06e79a63          	bne	a5,a4,80004946 <fileread+0x9e>
    ilock(f->ip);
    800048d6:	6d08                	ld	a0,24(a0)
    800048d8:	939fe0ef          	jal	80003210 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800048dc:	874e                	mv	a4,s3
    800048de:	5094                	lw	a3,32(s1)
    800048e0:	864a                	mv	a2,s2
    800048e2:	4585                	li	a1,1
    800048e4:	6c88                	ld	a0,24(s1)
    800048e6:	cbdfe0ef          	jal	800035a2 <readi>
    800048ea:	892a                	mv	s2,a0
    800048ec:	00a05563          	blez	a0,800048f6 <fileread+0x4e>
      f->off += r;
    800048f0:	509c                	lw	a5,32(s1)
    800048f2:	9fa9                	addw	a5,a5,a0
    800048f4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800048f6:	6c88                	ld	a0,24(s1)
    800048f8:	9c7fe0ef          	jal	800032be <iunlock>
    800048fc:	64e2                	ld	s1,24(sp)
    800048fe:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004900:	854a                	mv	a0,s2
    80004902:	70a2                	ld	ra,40(sp)
    80004904:	7402                	ld	s0,32(sp)
    80004906:	6942                	ld	s2,16(sp)
    80004908:	6145                	addi	sp,sp,48
    8000490a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000490c:	6908                	ld	a0,16(a0)
    8000490e:	3b0000ef          	jal	80004cbe <piperead>
    80004912:	892a                	mv	s2,a0
    80004914:	64e2                	ld	s1,24(sp)
    80004916:	69a2                	ld	s3,8(sp)
    80004918:	b7e5                	j	80004900 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000491a:	02451783          	lh	a5,36(a0)
    8000491e:	03079693          	slli	a3,a5,0x30
    80004922:	92c1                	srli	a3,a3,0x30
    80004924:	4725                	li	a4,9
    80004926:	02d76963          	bltu	a4,a3,80004958 <fileread+0xb0>
    8000492a:	0792                	slli	a5,a5,0x4
    8000492c:	0001c717          	auipc	a4,0x1c
    80004930:	43470713          	addi	a4,a4,1076 # 80020d60 <devsw>
    80004934:	97ba                	add	a5,a5,a4
    80004936:	639c                	ld	a5,0(a5)
    80004938:	c78d                	beqz	a5,80004962 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    8000493a:	4505                	li	a0,1
    8000493c:	9782                	jalr	a5
    8000493e:	892a                	mv	s2,a0
    80004940:	64e2                	ld	s1,24(sp)
    80004942:	69a2                	ld	s3,8(sp)
    80004944:	bf75                	j	80004900 <fileread+0x58>
    panic("fileread");
    80004946:	00004517          	auipc	a0,0x4
    8000494a:	f6a50513          	addi	a0,a0,-150 # 800088b0 <etext+0x8b0>
    8000494e:	ed7fb0ef          	jal	80000824 <panic>
    return -1;
    80004952:	57fd                	li	a5,-1
    80004954:	893e                	mv	s2,a5
    80004956:	b76d                	j	80004900 <fileread+0x58>
      return -1;
    80004958:	57fd                	li	a5,-1
    8000495a:	893e                	mv	s2,a5
    8000495c:	64e2                	ld	s1,24(sp)
    8000495e:	69a2                	ld	s3,8(sp)
    80004960:	b745                	j	80004900 <fileread+0x58>
    80004962:	57fd                	li	a5,-1
    80004964:	893e                	mv	s2,a5
    80004966:	64e2                	ld	s1,24(sp)
    80004968:	69a2                	ld	s3,8(sp)
    8000496a:	bf59                	j	80004900 <fileread+0x58>

000000008000496c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000496c:	00954783          	lbu	a5,9(a0)
    80004970:	10078f63          	beqz	a5,80004a8e <filewrite+0x122>
{
    80004974:	711d                	addi	sp,sp,-96
    80004976:	ec86                	sd	ra,88(sp)
    80004978:	e8a2                	sd	s0,80(sp)
    8000497a:	e0ca                	sd	s2,64(sp)
    8000497c:	f456                	sd	s5,40(sp)
    8000497e:	f05a                	sd	s6,32(sp)
    80004980:	1080                	addi	s0,sp,96
    80004982:	892a                	mv	s2,a0
    80004984:	8b2e                	mv	s6,a1
    80004986:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004988:	411c                	lw	a5,0(a0)
    8000498a:	4705                	li	a4,1
    8000498c:	02e78a63          	beq	a5,a4,800049c0 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004990:	470d                	li	a4,3
    80004992:	02e78b63          	beq	a5,a4,800049c8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004996:	4709                	li	a4,2
    80004998:	0ce79f63          	bne	a5,a4,80004a76 <filewrite+0x10a>
    8000499c:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000499e:	0ac05a63          	blez	a2,80004a52 <filewrite+0xe6>
    800049a2:	e4a6                	sd	s1,72(sp)
    800049a4:	fc4e                	sd	s3,56(sp)
    800049a6:	ec5e                	sd	s7,24(sp)
    800049a8:	e862                	sd	s8,16(sp)
    800049aa:	e466                	sd	s9,8(sp)
    int i = 0;
    800049ac:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800049ae:	6b85                	lui	s7,0x1
    800049b0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800049b4:	6785                	lui	a5,0x1
    800049b6:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800049ba:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800049bc:	4c05                	li	s8,1
    800049be:	a8ad                	j	80004a38 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800049c0:	6908                	ld	a0,16(a0)
    800049c2:	204000ef          	jal	80004bc6 <pipewrite>
    800049c6:	a04d                	j	80004a68 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800049c8:	02451783          	lh	a5,36(a0)
    800049cc:	03079693          	slli	a3,a5,0x30
    800049d0:	92c1                	srli	a3,a3,0x30
    800049d2:	4725                	li	a4,9
    800049d4:	0ad76f63          	bltu	a4,a3,80004a92 <filewrite+0x126>
    800049d8:	0792                	slli	a5,a5,0x4
    800049da:	0001c717          	auipc	a4,0x1c
    800049de:	38670713          	addi	a4,a4,902 # 80020d60 <devsw>
    800049e2:	97ba                	add	a5,a5,a4
    800049e4:	679c                	ld	a5,8(a5)
    800049e6:	cbc5                	beqz	a5,80004a96 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800049e8:	4505                	li	a0,1
    800049ea:	9782                	jalr	a5
    800049ec:	a8b5                	j	80004a68 <filewrite+0xfc>
      if(n1 > max)
    800049ee:	2981                	sext.w	s3,s3
      begin_op();
    800049f0:	a2cff0ef          	jal	80003c1c <begin_op>
      ilock(f->ip);
    800049f4:	01893503          	ld	a0,24(s2)
    800049f8:	819fe0ef          	jal	80003210 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800049fc:	874e                	mv	a4,s3
    800049fe:	02092683          	lw	a3,32(s2)
    80004a02:	016a0633          	add	a2,s4,s6
    80004a06:	85e2                	mv	a1,s8
    80004a08:	01893503          	ld	a0,24(s2)
    80004a0c:	c89fe0ef          	jal	80003694 <writei>
    80004a10:	84aa                	mv	s1,a0
    80004a12:	00a05763          	blez	a0,80004a20 <filewrite+0xb4>
        f->off += r;
    80004a16:	02092783          	lw	a5,32(s2)
    80004a1a:	9fa9                	addw	a5,a5,a0
    80004a1c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004a20:	01893503          	ld	a0,24(s2)
    80004a24:	89bfe0ef          	jal	800032be <iunlock>
      end_op();
    80004a28:	a64ff0ef          	jal	80003c8c <end_op>

      if(r != n1){
    80004a2c:	02999563          	bne	s3,s1,80004a56 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004a30:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004a34:	015a5963          	bge	s4,s5,80004a46 <filewrite+0xda>
      int n1 = n - i;
    80004a38:	414a87bb          	subw	a5,s5,s4
    80004a3c:	89be                	mv	s3,a5
      if(n1 > max)
    80004a3e:	fafbd8e3          	bge	s7,a5,800049ee <filewrite+0x82>
    80004a42:	89e6                	mv	s3,s9
    80004a44:	b76d                	j	800049ee <filewrite+0x82>
    80004a46:	64a6                	ld	s1,72(sp)
    80004a48:	79e2                	ld	s3,56(sp)
    80004a4a:	6be2                	ld	s7,24(sp)
    80004a4c:	6c42                	ld	s8,16(sp)
    80004a4e:	6ca2                	ld	s9,8(sp)
    80004a50:	a801                	j	80004a60 <filewrite+0xf4>
    int i = 0;
    80004a52:	4a01                	li	s4,0
    80004a54:	a031                	j	80004a60 <filewrite+0xf4>
    80004a56:	64a6                	ld	s1,72(sp)
    80004a58:	79e2                	ld	s3,56(sp)
    80004a5a:	6be2                	ld	s7,24(sp)
    80004a5c:	6c42                	ld	s8,16(sp)
    80004a5e:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004a60:	034a9d63          	bne	s5,s4,80004a9a <filewrite+0x12e>
    80004a64:	8556                	mv	a0,s5
    80004a66:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004a68:	60e6                	ld	ra,88(sp)
    80004a6a:	6446                	ld	s0,80(sp)
    80004a6c:	6906                	ld	s2,64(sp)
    80004a6e:	7aa2                	ld	s5,40(sp)
    80004a70:	7b02                	ld	s6,32(sp)
    80004a72:	6125                	addi	sp,sp,96
    80004a74:	8082                	ret
    80004a76:	e4a6                	sd	s1,72(sp)
    80004a78:	fc4e                	sd	s3,56(sp)
    80004a7a:	f852                	sd	s4,48(sp)
    80004a7c:	ec5e                	sd	s7,24(sp)
    80004a7e:	e862                	sd	s8,16(sp)
    80004a80:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004a82:	00004517          	auipc	a0,0x4
    80004a86:	e3e50513          	addi	a0,a0,-450 # 800088c0 <etext+0x8c0>
    80004a8a:	d9bfb0ef          	jal	80000824 <panic>
    return -1;
    80004a8e:	557d                	li	a0,-1
}
    80004a90:	8082                	ret
      return -1;
    80004a92:	557d                	li	a0,-1
    80004a94:	bfd1                	j	80004a68 <filewrite+0xfc>
    80004a96:	557d                	li	a0,-1
    80004a98:	bfc1                	j	80004a68 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004a9a:	557d                	li	a0,-1
    80004a9c:	7a42                	ld	s4,48(sp)
    80004a9e:	b7e9                	j	80004a68 <filewrite+0xfc>

0000000080004aa0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004aa0:	7179                	addi	sp,sp,-48
    80004aa2:	f406                	sd	ra,40(sp)
    80004aa4:	f022                	sd	s0,32(sp)
    80004aa6:	ec26                	sd	s1,24(sp)
    80004aa8:	e052                	sd	s4,0(sp)
    80004aaa:	1800                	addi	s0,sp,48
    80004aac:	84aa                	mv	s1,a0
    80004aae:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004ab0:	0005b023          	sd	zero,0(a1)
    80004ab4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ab8:	c29ff0ef          	jal	800046e0 <filealloc>
    80004abc:	e088                	sd	a0,0(s1)
    80004abe:	c549                	beqz	a0,80004b48 <pipealloc+0xa8>
    80004ac0:	c21ff0ef          	jal	800046e0 <filealloc>
    80004ac4:	00aa3023          	sd	a0,0(s4)
    80004ac8:	cd25                	beqz	a0,80004b40 <pipealloc+0xa0>
    80004aca:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004acc:	878fc0ef          	jal	80000b44 <kalloc>
    80004ad0:	892a                	mv	s2,a0
    80004ad2:	c12d                	beqz	a0,80004b34 <pipealloc+0x94>
    80004ad4:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004ad6:	4985                	li	s3,1
    80004ad8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004adc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004ae0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004ae4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ae8:	00004597          	auipc	a1,0x4
    80004aec:	de858593          	addi	a1,a1,-536 # 800088d0 <etext+0x8d0>
    80004af0:	8aefc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004af4:	609c                	ld	a5,0(s1)
    80004af6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004afa:	609c                	ld	a5,0(s1)
    80004afc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004b00:	609c                	ld	a5,0(s1)
    80004b02:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004b06:	609c                	ld	a5,0(s1)
    80004b08:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004b0c:	000a3783          	ld	a5,0(s4)
    80004b10:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004b14:	000a3783          	ld	a5,0(s4)
    80004b18:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004b1c:	000a3783          	ld	a5,0(s4)
    80004b20:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004b24:	000a3783          	ld	a5,0(s4)
    80004b28:	0127b823          	sd	s2,16(a5)
  return 0;
    80004b2c:	4501                	li	a0,0
    80004b2e:	6942                	ld	s2,16(sp)
    80004b30:	69a2                	ld	s3,8(sp)
    80004b32:	a01d                	j	80004b58 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004b34:	6088                	ld	a0,0(s1)
    80004b36:	c119                	beqz	a0,80004b3c <pipealloc+0x9c>
    80004b38:	6942                	ld	s2,16(sp)
    80004b3a:	a029                	j	80004b44 <pipealloc+0xa4>
    80004b3c:	6942                	ld	s2,16(sp)
    80004b3e:	a029                	j	80004b48 <pipealloc+0xa8>
    80004b40:	6088                	ld	a0,0(s1)
    80004b42:	c10d                	beqz	a0,80004b64 <pipealloc+0xc4>
    fileclose(*f0);
    80004b44:	c41ff0ef          	jal	80004784 <fileclose>
  if(*f1)
    80004b48:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004b4c:	557d                	li	a0,-1
  if(*f1)
    80004b4e:	c789                	beqz	a5,80004b58 <pipealloc+0xb8>
    fileclose(*f1);
    80004b50:	853e                	mv	a0,a5
    80004b52:	c33ff0ef          	jal	80004784 <fileclose>
  return -1;
    80004b56:	557d                	li	a0,-1
}
    80004b58:	70a2                	ld	ra,40(sp)
    80004b5a:	7402                	ld	s0,32(sp)
    80004b5c:	64e2                	ld	s1,24(sp)
    80004b5e:	6a02                	ld	s4,0(sp)
    80004b60:	6145                	addi	sp,sp,48
    80004b62:	8082                	ret
  return -1;
    80004b64:	557d                	li	a0,-1
    80004b66:	bfcd                	j	80004b58 <pipealloc+0xb8>

0000000080004b68 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004b68:	1101                	addi	sp,sp,-32
    80004b6a:	ec06                	sd	ra,24(sp)
    80004b6c:	e822                	sd	s0,16(sp)
    80004b6e:	e426                	sd	s1,8(sp)
    80004b70:	e04a                	sd	s2,0(sp)
    80004b72:	1000                	addi	s0,sp,32
    80004b74:	84aa                	mv	s1,a0
    80004b76:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b78:	8b0fc0ef          	jal	80000c28 <acquire>
  if(writable){
    80004b7c:	02090763          	beqz	s2,80004baa <pipeclose+0x42>
    pi->writeopen = 0;
    80004b80:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b84:	21848513          	addi	a0,s1,536
    80004b88:	bf4fd0ef          	jal	80001f7c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004b8c:	2204a783          	lw	a5,544(s1)
    80004b90:	e781                	bnez	a5,80004b98 <pipeclose+0x30>
    80004b92:	2244a783          	lw	a5,548(s1)
    80004b96:	c38d                	beqz	a5,80004bb8 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	922fc0ef          	jal	80000cbc <release>
}
    80004b9e:	60e2                	ld	ra,24(sp)
    80004ba0:	6442                	ld	s0,16(sp)
    80004ba2:	64a2                	ld	s1,8(sp)
    80004ba4:	6902                	ld	s2,0(sp)
    80004ba6:	6105                	addi	sp,sp,32
    80004ba8:	8082                	ret
    pi->readopen = 0;
    80004baa:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004bae:	21c48513          	addi	a0,s1,540
    80004bb2:	bcafd0ef          	jal	80001f7c <wakeup>
    80004bb6:	bfd9                	j	80004b8c <pipeclose+0x24>
    release(&pi->lock);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	902fc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    80004bbe:	8526                	mv	a0,s1
    80004bc0:	e9dfb0ef          	jal	80000a5c <kfree>
    80004bc4:	bfe9                	j	80004b9e <pipeclose+0x36>

0000000080004bc6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004bc6:	7159                	addi	sp,sp,-112
    80004bc8:	f486                	sd	ra,104(sp)
    80004bca:	f0a2                	sd	s0,96(sp)
    80004bcc:	eca6                	sd	s1,88(sp)
    80004bce:	e8ca                	sd	s2,80(sp)
    80004bd0:	e4ce                	sd	s3,72(sp)
    80004bd2:	e0d2                	sd	s4,64(sp)
    80004bd4:	fc56                	sd	s5,56(sp)
    80004bd6:	1880                	addi	s0,sp,112
    80004bd8:	84aa                	mv	s1,a0
    80004bda:	8aae                	mv	s5,a1
    80004bdc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004bde:	d55fc0ef          	jal	80001932 <myproc>
    80004be2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004be4:	8526                	mv	a0,s1
    80004be6:	842fc0ef          	jal	80000c28 <acquire>
  while(i < n){
    80004bea:	0d405263          	blez	s4,80004cae <pipewrite+0xe8>
    80004bee:	f85a                	sd	s6,48(sp)
    80004bf0:	f45e                	sd	s7,40(sp)
    80004bf2:	f062                	sd	s8,32(sp)
    80004bf4:	ec66                	sd	s9,24(sp)
    80004bf6:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004bf8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004bfa:	f9f40c13          	addi	s8,s0,-97
    80004bfe:	4b85                	li	s7,1
    80004c00:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004c02:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004c06:	21c48c93          	addi	s9,s1,540
    80004c0a:	a82d                	j	80004c44 <pipewrite+0x7e>
      release(&pi->lock);
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	8aefc0ef          	jal	80000cbc <release>
      return -1;
    80004c12:	597d                	li	s2,-1
    80004c14:	7b42                	ld	s6,48(sp)
    80004c16:	7ba2                	ld	s7,40(sp)
    80004c18:	7c02                	ld	s8,32(sp)
    80004c1a:	6ce2                	ld	s9,24(sp)
    80004c1c:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004c1e:	854a                	mv	a0,s2
    80004c20:	70a6                	ld	ra,104(sp)
    80004c22:	7406                	ld	s0,96(sp)
    80004c24:	64e6                	ld	s1,88(sp)
    80004c26:	6946                	ld	s2,80(sp)
    80004c28:	69a6                	ld	s3,72(sp)
    80004c2a:	6a06                	ld	s4,64(sp)
    80004c2c:	7ae2                	ld	s5,56(sp)
    80004c2e:	6165                	addi	sp,sp,112
    80004c30:	8082                	ret
      wakeup(&pi->nread);
    80004c32:	856a                	mv	a0,s10
    80004c34:	b48fd0ef          	jal	80001f7c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004c38:	85a6                	mv	a1,s1
    80004c3a:	8566                	mv	a0,s9
    80004c3c:	af4fd0ef          	jal	80001f30 <sleep>
  while(i < n){
    80004c40:	05495a63          	bge	s2,s4,80004c94 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004c44:	2204a783          	lw	a5,544(s1)
    80004c48:	d3f1                	beqz	a5,80004c0c <pipewrite+0x46>
    80004c4a:	854e                	mv	a0,s3
    80004c4c:	d20fd0ef          	jal	8000216c <killed>
    80004c50:	fd55                	bnez	a0,80004c0c <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004c52:	2184a783          	lw	a5,536(s1)
    80004c56:	21c4a703          	lw	a4,540(s1)
    80004c5a:	2007879b          	addiw	a5,a5,512
    80004c5e:	fcf70ae3          	beq	a4,a5,80004c32 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c62:	86de                	mv	a3,s7
    80004c64:	01590633          	add	a2,s2,s5
    80004c68:	85e2                	mv	a1,s8
    80004c6a:	0509b503          	ld	a0,80(s3)
    80004c6e:	aa9fc0ef          	jal	80001716 <copyin>
    80004c72:	05650063          	beq	a0,s6,80004cb2 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c76:	21c4a783          	lw	a5,540(s1)
    80004c7a:	0017871b          	addiw	a4,a5,1
    80004c7e:	20e4ae23          	sw	a4,540(s1)
    80004c82:	1ff7f793          	andi	a5,a5,511
    80004c86:	97a6                	add	a5,a5,s1
    80004c88:	f9f44703          	lbu	a4,-97(s0)
    80004c8c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004c90:	2905                	addiw	s2,s2,1
    80004c92:	b77d                	j	80004c40 <pipewrite+0x7a>
    80004c94:	7b42                	ld	s6,48(sp)
    80004c96:	7ba2                	ld	s7,40(sp)
    80004c98:	7c02                	ld	s8,32(sp)
    80004c9a:	6ce2                	ld	s9,24(sp)
    80004c9c:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004c9e:	21848513          	addi	a0,s1,536
    80004ca2:	adafd0ef          	jal	80001f7c <wakeup>
  release(&pi->lock);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	814fc0ef          	jal	80000cbc <release>
  return i;
    80004cac:	bf8d                	j	80004c1e <pipewrite+0x58>
  int i = 0;
    80004cae:	4901                	li	s2,0
    80004cb0:	b7fd                	j	80004c9e <pipewrite+0xd8>
    80004cb2:	7b42                	ld	s6,48(sp)
    80004cb4:	7ba2                	ld	s7,40(sp)
    80004cb6:	7c02                	ld	s8,32(sp)
    80004cb8:	6ce2                	ld	s9,24(sp)
    80004cba:	6d42                	ld	s10,16(sp)
    80004cbc:	b7cd                	j	80004c9e <pipewrite+0xd8>

0000000080004cbe <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004cbe:	711d                	addi	sp,sp,-96
    80004cc0:	ec86                	sd	ra,88(sp)
    80004cc2:	e8a2                	sd	s0,80(sp)
    80004cc4:	e4a6                	sd	s1,72(sp)
    80004cc6:	e0ca                	sd	s2,64(sp)
    80004cc8:	fc4e                	sd	s3,56(sp)
    80004cca:	f852                	sd	s4,48(sp)
    80004ccc:	f456                	sd	s5,40(sp)
    80004cce:	1080                	addi	s0,sp,96
    80004cd0:	84aa                	mv	s1,a0
    80004cd2:	892e                	mv	s2,a1
    80004cd4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004cd6:	c5dfc0ef          	jal	80001932 <myproc>
    80004cda:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	f4bfb0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ce2:	2184a703          	lw	a4,536(s1)
    80004ce6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004cea:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004cee:	02f71763          	bne	a4,a5,80004d1c <piperead+0x5e>
    80004cf2:	2244a783          	lw	a5,548(s1)
    80004cf6:	cf85                	beqz	a5,80004d2e <piperead+0x70>
    if(killed(pr)){
    80004cf8:	8552                	mv	a0,s4
    80004cfa:	c72fd0ef          	jal	8000216c <killed>
    80004cfe:	e11d                	bnez	a0,80004d24 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d00:	85a6                	mv	a1,s1
    80004d02:	854e                	mv	a0,s3
    80004d04:	a2cfd0ef          	jal	80001f30 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d08:	2184a703          	lw	a4,536(s1)
    80004d0c:	21c4a783          	lw	a5,540(s1)
    80004d10:	fef701e3          	beq	a4,a5,80004cf2 <piperead+0x34>
    80004d14:	f05a                	sd	s6,32(sp)
    80004d16:	ec5e                	sd	s7,24(sp)
    80004d18:	e862                	sd	s8,16(sp)
    80004d1a:	a829                	j	80004d34 <piperead+0x76>
    80004d1c:	f05a                	sd	s6,32(sp)
    80004d1e:	ec5e                	sd	s7,24(sp)
    80004d20:	e862                	sd	s8,16(sp)
    80004d22:	a809                	j	80004d34 <piperead+0x76>
      release(&pi->lock);
    80004d24:	8526                	mv	a0,s1
    80004d26:	f97fb0ef          	jal	80000cbc <release>
      return -1;
    80004d2a:	59fd                	li	s3,-1
    80004d2c:	a09d                	j	80004d92 <piperead+0xd4>
    80004d2e:	f05a                	sd	s6,32(sp)
    80004d30:	ec5e                	sd	s7,24(sp)
    80004d32:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d34:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d36:	faf40c13          	addi	s8,s0,-81
    80004d3a:	4b85                	li	s7,1
    80004d3c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d3e:	05505063          	blez	s5,80004d7e <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80004d42:	2184a783          	lw	a5,536(s1)
    80004d46:	21c4a703          	lw	a4,540(s1)
    80004d4a:	02f70a63          	beq	a4,a5,80004d7e <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004d4e:	0017871b          	addiw	a4,a5,1
    80004d52:	20e4ac23          	sw	a4,536(s1)
    80004d56:	1ff7f793          	andi	a5,a5,511
    80004d5a:	97a6                	add	a5,a5,s1
    80004d5c:	0187c783          	lbu	a5,24(a5)
    80004d60:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d64:	86de                	mv	a3,s7
    80004d66:	8662                	mv	a2,s8
    80004d68:	85ca                	mv	a1,s2
    80004d6a:	050a3503          	ld	a0,80(s4)
    80004d6e:	8ebfc0ef          	jal	80001658 <copyout>
    80004d72:	01650663          	beq	a0,s6,80004d7e <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d76:	2985                	addiw	s3,s3,1
    80004d78:	0905                	addi	s2,s2,1
    80004d7a:	fd3a94e3          	bne	s5,s3,80004d42 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d7e:	21c48513          	addi	a0,s1,540
    80004d82:	9fafd0ef          	jal	80001f7c <wakeup>
  release(&pi->lock);
    80004d86:	8526                	mv	a0,s1
    80004d88:	f35fb0ef          	jal	80000cbc <release>
    80004d8c:	7b02                	ld	s6,32(sp)
    80004d8e:	6be2                	ld	s7,24(sp)
    80004d90:	6c42                	ld	s8,16(sp)
  return i;
}
    80004d92:	854e                	mv	a0,s3
    80004d94:	60e6                	ld	ra,88(sp)
    80004d96:	6446                	ld	s0,80(sp)
    80004d98:	64a6                	ld	s1,72(sp)
    80004d9a:	6906                	ld	s2,64(sp)
    80004d9c:	79e2                	ld	s3,56(sp)
    80004d9e:	7a42                	ld	s4,48(sp)
    80004da0:	7aa2                	ld	s5,40(sp)
    80004da2:	6125                	addi	sp,sp,96
    80004da4:	8082                	ret

0000000080004da6 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004da6:	1141                	addi	sp,sp,-16
    80004da8:	e406                	sd	ra,8(sp)
    80004daa:	e022                	sd	s0,0(sp)
    80004dac:	0800                	addi	s0,sp,16
    80004dae:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004db0:	0035151b          	slliw	a0,a0,0x3
    80004db4:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004db6:	8b89                	andi	a5,a5,2
    80004db8:	c399                	beqz	a5,80004dbe <flags2perm+0x18>
      perm |= PTE_W;
    80004dba:	00456513          	ori	a0,a0,4
    return perm;
}
    80004dbe:	60a2                	ld	ra,8(sp)
    80004dc0:	6402                	ld	s0,0(sp)
    80004dc2:	0141                	addi	sp,sp,16
    80004dc4:	8082                	ret

0000000080004dc6 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004dc6:	de010113          	addi	sp,sp,-544
    80004dca:	20113c23          	sd	ra,536(sp)
    80004dce:	20813823          	sd	s0,528(sp)
    80004dd2:	20913423          	sd	s1,520(sp)
    80004dd6:	21213023          	sd	s2,512(sp)
    80004dda:	1400                	addi	s0,sp,544
    80004ddc:	892a                	mv	s2,a0
    80004dde:	dea43823          	sd	a0,-528(s0)
    80004de2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004de6:	b4dfc0ef          	jal	80001932 <myproc>
    80004dea:	84aa                	mv	s1,a0

  begin_op();
    80004dec:	e31fe0ef          	jal	80003c1c <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004df0:	854a                	mv	a0,s2
    80004df2:	c4dfe0ef          	jal	80003a3e <namei>
    80004df6:	cd21                	beqz	a0,80004e4e <kexec+0x88>
    80004df8:	fbd2                	sd	s4,496(sp)
    80004dfa:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004dfc:	c14fe0ef          	jal	80003210 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e00:	04000713          	li	a4,64
    80004e04:	4681                	li	a3,0
    80004e06:	e5040613          	addi	a2,s0,-432
    80004e0a:	4581                	li	a1,0
    80004e0c:	8552                	mv	a0,s4
    80004e0e:	f94fe0ef          	jal	800035a2 <readi>
    80004e12:	04000793          	li	a5,64
    80004e16:	00f51a63          	bne	a0,a5,80004e2a <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004e1a:	e5042703          	lw	a4,-432(s0)
    80004e1e:	464c47b7          	lui	a5,0x464c4
    80004e22:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004e26:	02f70863          	beq	a4,a5,80004e56 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004e2a:	8552                	mv	a0,s4
    80004e2c:	df0fe0ef          	jal	8000341c <iunlockput>
    end_op();
    80004e30:	e5dfe0ef          	jal	80003c8c <end_op>
  }
  return -1;
    80004e34:	557d                	li	a0,-1
    80004e36:	7a5e                	ld	s4,496(sp)
}
    80004e38:	21813083          	ld	ra,536(sp)
    80004e3c:	21013403          	ld	s0,528(sp)
    80004e40:	20813483          	ld	s1,520(sp)
    80004e44:	20013903          	ld	s2,512(sp)
    80004e48:	22010113          	addi	sp,sp,544
    80004e4c:	8082                	ret
    end_op();
    80004e4e:	e3ffe0ef          	jal	80003c8c <end_op>
    return -1;
    80004e52:	557d                	li	a0,-1
    80004e54:	b7d5                	j	80004e38 <kexec+0x72>
    80004e56:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004e58:	8526                	mv	a0,s1
    80004e5a:	be3fc0ef          	jal	80001a3c <proc_pagetable>
    80004e5e:	8b2a                	mv	s6,a0
    80004e60:	26050f63          	beqz	a0,800050de <kexec+0x318>
    80004e64:	ffce                	sd	s3,504(sp)
    80004e66:	f7d6                	sd	s5,488(sp)
    80004e68:	efde                	sd	s7,472(sp)
    80004e6a:	ebe2                	sd	s8,464(sp)
    80004e6c:	e7e6                	sd	s9,456(sp)
    80004e6e:	e3ea                	sd	s10,448(sp)
    80004e70:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e72:	e8845783          	lhu	a5,-376(s0)
    80004e76:	0e078963          	beqz	a5,80004f68 <kexec+0x1a2>
    80004e7a:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e7e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e80:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e82:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80004e86:	6c85                	lui	s9,0x1
    80004e88:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004e8c:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004e90:	6a85                	lui	s5,0x1
    80004e92:	a085                	j	80004ef2 <kexec+0x12c>
      panic("loadseg: address should exist");
    80004e94:	00004517          	auipc	a0,0x4
    80004e98:	a4450513          	addi	a0,a0,-1468 # 800088d8 <etext+0x8d8>
    80004e9c:	989fb0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    80004ea0:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004ea2:	874a                	mv	a4,s2
    80004ea4:	009b86bb          	addw	a3,s7,s1
    80004ea8:	4581                	li	a1,0
    80004eaa:	8552                	mv	a0,s4
    80004eac:	ef6fe0ef          	jal	800035a2 <readi>
    80004eb0:	22a91b63          	bne	s2,a0,800050e6 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80004eb4:	009a84bb          	addw	s1,s5,s1
    80004eb8:	0334f263          	bgeu	s1,s3,80004edc <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004ebc:	02049593          	slli	a1,s1,0x20
    80004ec0:	9181                	srli	a1,a1,0x20
    80004ec2:	95e2                	add	a1,a1,s8
    80004ec4:	855a                	mv	a0,s6
    80004ec6:	964fc0ef          	jal	8000102a <walkaddr>
    80004eca:	862a                	mv	a2,a0
    if(pa == 0)
    80004ecc:	d561                	beqz	a0,80004e94 <kexec+0xce>
    if(sz - i < PGSIZE)
    80004ece:	409987bb          	subw	a5,s3,s1
    80004ed2:	893e                	mv	s2,a5
    80004ed4:	fcfcf6e3          	bgeu	s9,a5,80004ea0 <kexec+0xda>
    80004ed8:	8956                	mv	s2,s5
    80004eda:	b7d9                	j	80004ea0 <kexec+0xda>
    sz = sz1;
    80004edc:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ee0:	2d05                	addiw	s10,s10,1
    80004ee2:	e0843783          	ld	a5,-504(s0)
    80004ee6:	0387869b          	addiw	a3,a5,56
    80004eea:	e8845783          	lhu	a5,-376(s0)
    80004eee:	06fd5e63          	bge	s10,a5,80004f6a <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004ef2:	e0d43423          	sd	a3,-504(s0)
    80004ef6:	876e                	mv	a4,s11
    80004ef8:	e1840613          	addi	a2,s0,-488
    80004efc:	4581                	li	a1,0
    80004efe:	8552                	mv	a0,s4
    80004f00:	ea2fe0ef          	jal	800035a2 <readi>
    80004f04:	1db51f63          	bne	a0,s11,800050e2 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80004f08:	e1842783          	lw	a5,-488(s0)
    80004f0c:	4705                	li	a4,1
    80004f0e:	fce799e3          	bne	a5,a4,80004ee0 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80004f12:	e4043483          	ld	s1,-448(s0)
    80004f16:	e3843783          	ld	a5,-456(s0)
    80004f1a:	1ef4e463          	bltu	s1,a5,80005102 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004f1e:	e2843783          	ld	a5,-472(s0)
    80004f22:	94be                	add	s1,s1,a5
    80004f24:	1ef4e263          	bltu	s1,a5,80005108 <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80004f28:	de843703          	ld	a4,-536(s0)
    80004f2c:	8ff9                	and	a5,a5,a4
    80004f2e:	1e079063          	bnez	a5,8000510e <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f32:	e1c42503          	lw	a0,-484(s0)
    80004f36:	e71ff0ef          	jal	80004da6 <flags2perm>
    80004f3a:	86aa                	mv	a3,a0
    80004f3c:	8626                	mv	a2,s1
    80004f3e:	85ca                	mv	a1,s2
    80004f40:	855a                	mv	a0,s6
    80004f42:	bbefc0ef          	jal	80001300 <uvmalloc>
    80004f46:	dea43c23          	sd	a0,-520(s0)
    80004f4a:	1c050563          	beqz	a0,80005114 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f4e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f52:	00098863          	beqz	s3,80004f62 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f56:	e2843c03          	ld	s8,-472(s0)
    80004f5a:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f5e:	4481                	li	s1,0
    80004f60:	bfb1                	j	80004ebc <kexec+0xf6>
    sz = sz1;
    80004f62:	df843903          	ld	s2,-520(s0)
    80004f66:	bfad                	j	80004ee0 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f68:	4901                	li	s2,0
  iunlockput(ip);
    80004f6a:	8552                	mv	a0,s4
    80004f6c:	cb0fe0ef          	jal	8000341c <iunlockput>
  end_op();
    80004f70:	d1dfe0ef          	jal	80003c8c <end_op>
  p = myproc();
    80004f74:	9bffc0ef          	jal	80001932 <myproc>
    80004f78:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004f7a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004f7e:	6985                	lui	s3,0x1
    80004f80:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004f82:	99ca                	add	s3,s3,s2
    80004f84:	77fd                	lui	a5,0xfffff
    80004f86:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004f8a:	4691                	li	a3,4
    80004f8c:	6609                	lui	a2,0x2
    80004f8e:	964e                	add	a2,a2,s3
    80004f90:	85ce                	mv	a1,s3
    80004f92:	855a                	mv	a0,s6
    80004f94:	b6cfc0ef          	jal	80001300 <uvmalloc>
    80004f98:	8a2a                	mv	s4,a0
    80004f9a:	e105                	bnez	a0,80004fba <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80004f9c:	85ce                	mv	a1,s3
    80004f9e:	855a                	mv	a0,s6
    80004fa0:	b21fc0ef          	jal	80001ac0 <proc_freepagetable>
  return -1;
    80004fa4:	557d                	li	a0,-1
    80004fa6:	79fe                	ld	s3,504(sp)
    80004fa8:	7a5e                	ld	s4,496(sp)
    80004faa:	7abe                	ld	s5,488(sp)
    80004fac:	7b1e                	ld	s6,480(sp)
    80004fae:	6bfe                	ld	s7,472(sp)
    80004fb0:	6c5e                	ld	s8,464(sp)
    80004fb2:	6cbe                	ld	s9,456(sp)
    80004fb4:	6d1e                	ld	s10,448(sp)
    80004fb6:	7dfa                	ld	s11,440(sp)
    80004fb8:	b541                	j	80004e38 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004fba:	75f9                	lui	a1,0xffffe
    80004fbc:	95aa                	add	a1,a1,a0
    80004fbe:	855a                	mv	a0,s6
    80004fc0:	d12fc0ef          	jal	800014d2 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004fc4:	800a0b93          	addi	s7,s4,-2048
    80004fc8:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80004fcc:	e0043783          	ld	a5,-512(s0)
    80004fd0:	6388                	ld	a0,0(a5)
  sp = sz;
    80004fd2:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004fd4:	4481                	li	s1,0
    ustack[argc] = sp;
    80004fd6:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004fda:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004fde:	cd21                	beqz	a0,80005036 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80004fe0:	ea3fb0ef          	jal	80000e82 <strlen>
    80004fe4:	0015079b          	addiw	a5,a0,1
    80004fe8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004fec:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004ff0:	13796563          	bltu	s2,s7,8000511a <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ff4:	e0043d83          	ld	s11,-512(s0)
    80004ff8:	000db983          	ld	s3,0(s11)
    80004ffc:	854e                	mv	a0,s3
    80004ffe:	e85fb0ef          	jal	80000e82 <strlen>
    80005002:	0015069b          	addiw	a3,a0,1
    80005006:	864e                	mv	a2,s3
    80005008:	85ca                	mv	a1,s2
    8000500a:	855a                	mv	a0,s6
    8000500c:	e4cfc0ef          	jal	80001658 <copyout>
    80005010:	10054763          	bltz	a0,8000511e <kexec+0x358>
    ustack[argc] = sp;
    80005014:	00349793          	slli	a5,s1,0x3
    80005018:	97e6                	add	a5,a5,s9
    8000501a:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdd108>
  for(argc = 0; argv[argc]; argc++) {
    8000501e:	0485                	addi	s1,s1,1
    80005020:	008d8793          	addi	a5,s11,8
    80005024:	e0f43023          	sd	a5,-512(s0)
    80005028:	008db503          	ld	a0,8(s11)
    8000502c:	c509                	beqz	a0,80005036 <kexec+0x270>
    if(argc >= MAXARG)
    8000502e:	fb8499e3          	bne	s1,s8,80004fe0 <kexec+0x21a>
  sz = sz1;
    80005032:	89d2                	mv	s3,s4
    80005034:	b7a5                	j	80004f9c <kexec+0x1d6>
  ustack[argc] = 0;
    80005036:	00349793          	slli	a5,s1,0x3
    8000503a:	f9078793          	addi	a5,a5,-112
    8000503e:	97a2                	add	a5,a5,s0
    80005040:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005044:	00349693          	slli	a3,s1,0x3
    80005048:	06a1                	addi	a3,a3,8
    8000504a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000504e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005052:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005054:	f57964e3          	bltu	s2,s7,80004f9c <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005058:	e9040613          	addi	a2,s0,-368
    8000505c:	85ca                	mv	a1,s2
    8000505e:	855a                	mv	a0,s6
    80005060:	df8fc0ef          	jal	80001658 <copyout>
    80005064:	f2054ce3          	bltz	a0,80004f9c <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80005068:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000506c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005070:	df043783          	ld	a5,-528(s0)
    80005074:	0007c703          	lbu	a4,0(a5)
    80005078:	cf11                	beqz	a4,80005094 <kexec+0x2ce>
    8000507a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000507c:	02f00693          	li	a3,47
    80005080:	a029                	j	8000508a <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80005082:	0785                	addi	a5,a5,1
    80005084:	fff7c703          	lbu	a4,-1(a5)
    80005088:	c711                	beqz	a4,80005094 <kexec+0x2ce>
    if(*s == '/')
    8000508a:	fed71ce3          	bne	a4,a3,80005082 <kexec+0x2bc>
      last = s+1;
    8000508e:	def43823          	sd	a5,-528(s0)
    80005092:	bfc5                	j	80005082 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80005094:	4641                	li	a2,16
    80005096:	df043583          	ld	a1,-528(s0)
    8000509a:	158a8513          	addi	a0,s5,344
    8000509e:	daffb0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    800050a2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800050a6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800050aa:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800050ae:	058ab783          	ld	a5,88(s5)
    800050b2:	e6843703          	ld	a4,-408(s0)
    800050b6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800050b8:	058ab783          	ld	a5,88(s5)
    800050bc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800050c0:	85ea                	mv	a1,s10
    800050c2:	9fffc0ef          	jal	80001ac0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050c6:	0004851b          	sext.w	a0,s1
    800050ca:	79fe                	ld	s3,504(sp)
    800050cc:	7a5e                	ld	s4,496(sp)
    800050ce:	7abe                	ld	s5,488(sp)
    800050d0:	7b1e                	ld	s6,480(sp)
    800050d2:	6bfe                	ld	s7,472(sp)
    800050d4:	6c5e                	ld	s8,464(sp)
    800050d6:	6cbe                	ld	s9,456(sp)
    800050d8:	6d1e                	ld	s10,448(sp)
    800050da:	7dfa                	ld	s11,440(sp)
    800050dc:	bbb1                	j	80004e38 <kexec+0x72>
    800050de:	7b1e                	ld	s6,480(sp)
    800050e0:	b3a9                	j	80004e2a <kexec+0x64>
    800050e2:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800050e6:	df843583          	ld	a1,-520(s0)
    800050ea:	855a                	mv	a0,s6
    800050ec:	9d5fc0ef          	jal	80001ac0 <proc_freepagetable>
  if(ip){
    800050f0:	79fe                	ld	s3,504(sp)
    800050f2:	7abe                	ld	s5,488(sp)
    800050f4:	7b1e                	ld	s6,480(sp)
    800050f6:	6bfe                	ld	s7,472(sp)
    800050f8:	6c5e                	ld	s8,464(sp)
    800050fa:	6cbe                	ld	s9,456(sp)
    800050fc:	6d1e                	ld	s10,448(sp)
    800050fe:	7dfa                	ld	s11,440(sp)
    80005100:	b32d                	j	80004e2a <kexec+0x64>
    80005102:	df243c23          	sd	s2,-520(s0)
    80005106:	b7c5                	j	800050e6 <kexec+0x320>
    80005108:	df243c23          	sd	s2,-520(s0)
    8000510c:	bfe9                	j	800050e6 <kexec+0x320>
    8000510e:	df243c23          	sd	s2,-520(s0)
    80005112:	bfd1                	j	800050e6 <kexec+0x320>
    80005114:	df243c23          	sd	s2,-520(s0)
    80005118:	b7f9                	j	800050e6 <kexec+0x320>
  sz = sz1;
    8000511a:	89d2                	mv	s3,s4
    8000511c:	b541                	j	80004f9c <kexec+0x1d6>
    8000511e:	89d2                	mv	s3,s4
    80005120:	bdb5                	j	80004f9c <kexec+0x1d6>

0000000080005122 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005122:	7179                	addi	sp,sp,-48
    80005124:	f406                	sd	ra,40(sp)
    80005126:	f022                	sd	s0,32(sp)
    80005128:	ec26                	sd	s1,24(sp)
    8000512a:	e84a                	sd	s2,16(sp)
    8000512c:	1800                	addi	s0,sp,48
    8000512e:	892e                	mv	s2,a1
    80005130:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005132:	fdc40593          	addi	a1,s0,-36
    80005136:	f06fd0ef          	jal	8000283c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000513a:	fdc42703          	lw	a4,-36(s0)
    8000513e:	47bd                	li	a5,15
    80005140:	02e7ea63          	bltu	a5,a4,80005174 <argfd+0x52>
    80005144:	feefc0ef          	jal	80001932 <myproc>
    80005148:	fdc42703          	lw	a4,-36(s0)
    8000514c:	00371793          	slli	a5,a4,0x3
    80005150:	0d078793          	addi	a5,a5,208
    80005154:	953e                	add	a0,a0,a5
    80005156:	611c                	ld	a5,0(a0)
    80005158:	c385                	beqz	a5,80005178 <argfd+0x56>
    return -1;
  if(pfd)
    8000515a:	00090463          	beqz	s2,80005162 <argfd+0x40>
    *pfd = fd;
    8000515e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005162:	4501                	li	a0,0
  if(pf)
    80005164:	c091                	beqz	s1,80005168 <argfd+0x46>
    *pf = f;
    80005166:	e09c                	sd	a5,0(s1)
}
    80005168:	70a2                	ld	ra,40(sp)
    8000516a:	7402                	ld	s0,32(sp)
    8000516c:	64e2                	ld	s1,24(sp)
    8000516e:	6942                	ld	s2,16(sp)
    80005170:	6145                	addi	sp,sp,48
    80005172:	8082                	ret
    return -1;
    80005174:	557d                	li	a0,-1
    80005176:	bfcd                	j	80005168 <argfd+0x46>
    80005178:	557d                	li	a0,-1
    8000517a:	b7fd                	j	80005168 <argfd+0x46>

000000008000517c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000517c:	1101                	addi	sp,sp,-32
    8000517e:	ec06                	sd	ra,24(sp)
    80005180:	e822                	sd	s0,16(sp)
    80005182:	e426                	sd	s1,8(sp)
    80005184:	1000                	addi	s0,sp,32
    80005186:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005188:	faafc0ef          	jal	80001932 <myproc>
    8000518c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000518e:	0d050793          	addi	a5,a0,208
    80005192:	4501                	li	a0,0
    80005194:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005196:	6398                	ld	a4,0(a5)
    80005198:	cb19                	beqz	a4,800051ae <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000519a:	2505                	addiw	a0,a0,1
    8000519c:	07a1                	addi	a5,a5,8
    8000519e:	fed51ce3          	bne	a0,a3,80005196 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800051a2:	557d                	li	a0,-1
}
    800051a4:	60e2                	ld	ra,24(sp)
    800051a6:	6442                	ld	s0,16(sp)
    800051a8:	64a2                	ld	s1,8(sp)
    800051aa:	6105                	addi	sp,sp,32
    800051ac:	8082                	ret
      p->ofile[fd] = f;
    800051ae:	00351793          	slli	a5,a0,0x3
    800051b2:	0d078793          	addi	a5,a5,208
    800051b6:	963e                	add	a2,a2,a5
    800051b8:	e204                	sd	s1,0(a2)
      return fd;
    800051ba:	b7ed                	j	800051a4 <fdalloc+0x28>

00000000800051bc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800051bc:	715d                	addi	sp,sp,-80
    800051be:	e486                	sd	ra,72(sp)
    800051c0:	e0a2                	sd	s0,64(sp)
    800051c2:	fc26                	sd	s1,56(sp)
    800051c4:	f84a                	sd	s2,48(sp)
    800051c6:	f44e                	sd	s3,40(sp)
    800051c8:	f052                	sd	s4,32(sp)
    800051ca:	ec56                	sd	s5,24(sp)
    800051cc:	e85a                	sd	s6,16(sp)
    800051ce:	0880                	addi	s0,sp,80
    800051d0:	892e                	mv	s2,a1
    800051d2:	8a2e                	mv	s4,a1
    800051d4:	8ab2                	mv	s5,a2
    800051d6:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800051d8:	fb040593          	addi	a1,s0,-80
    800051dc:	87dfe0ef          	jal	80003a58 <nameiparent>
    800051e0:	84aa                	mv	s1,a0
    800051e2:	10050763          	beqz	a0,800052f0 <create+0x134>
    return 0;

  ilock(dp);
    800051e6:	82afe0ef          	jal	80003210 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800051ea:	4601                	li	a2,0
    800051ec:	fb040593          	addi	a1,s0,-80
    800051f0:	8526                	mv	a0,s1
    800051f2:	db8fe0ef          	jal	800037aa <dirlookup>
    800051f6:	89aa                	mv	s3,a0
    800051f8:	c131                	beqz	a0,8000523c <create+0x80>
    iunlockput(dp);
    800051fa:	8526                	mv	a0,s1
    800051fc:	a20fe0ef          	jal	8000341c <iunlockput>
    ilock(ip);
    80005200:	854e                	mv	a0,s3
    80005202:	80efe0ef          	jal	80003210 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005206:	4789                	li	a5,2
    80005208:	02f91563          	bne	s2,a5,80005232 <create+0x76>
    8000520c:	0449d783          	lhu	a5,68(s3)
    80005210:	37f9                	addiw	a5,a5,-2
    80005212:	17c2                	slli	a5,a5,0x30
    80005214:	93c1                	srli	a5,a5,0x30
    80005216:	4705                	li	a4,1
    80005218:	00f76d63          	bltu	a4,a5,80005232 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000521c:	854e                	mv	a0,s3
    8000521e:	60a6                	ld	ra,72(sp)
    80005220:	6406                	ld	s0,64(sp)
    80005222:	74e2                	ld	s1,56(sp)
    80005224:	7942                	ld	s2,48(sp)
    80005226:	79a2                	ld	s3,40(sp)
    80005228:	7a02                	ld	s4,32(sp)
    8000522a:	6ae2                	ld	s5,24(sp)
    8000522c:	6b42                	ld	s6,16(sp)
    8000522e:	6161                	addi	sp,sp,80
    80005230:	8082                	ret
    iunlockput(ip);
    80005232:	854e                	mv	a0,s3
    80005234:	9e8fe0ef          	jal	8000341c <iunlockput>
    return 0;
    80005238:	4981                	li	s3,0
    8000523a:	b7cd                	j	8000521c <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000523c:	85ca                	mv	a1,s2
    8000523e:	4088                	lw	a0,0(s1)
    80005240:	e61fd0ef          	jal	800030a0 <ialloc>
    80005244:	892a                	mv	s2,a0
    80005246:	cd15                	beqz	a0,80005282 <create+0xc6>
  ilock(ip);
    80005248:	fc9fd0ef          	jal	80003210 <ilock>
  ip->major = major;
    8000524c:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005250:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005254:	4785                	li	a5,1
    80005256:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000525a:	854a                	mv	a0,s2
    8000525c:	f01fd0ef          	jal	8000315c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005260:	4705                	li	a4,1
    80005262:	02ea0463          	beq	s4,a4,8000528a <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005266:	00492603          	lw	a2,4(s2)
    8000526a:	fb040593          	addi	a1,s0,-80
    8000526e:	8526                	mv	a0,s1
    80005270:	f24fe0ef          	jal	80003994 <dirlink>
    80005274:	06054263          	bltz	a0,800052d8 <create+0x11c>
  iunlockput(dp);
    80005278:	8526                	mv	a0,s1
    8000527a:	9a2fe0ef          	jal	8000341c <iunlockput>
  return ip;
    8000527e:	89ca                	mv	s3,s2
    80005280:	bf71                	j	8000521c <create+0x60>
    iunlockput(dp);
    80005282:	8526                	mv	a0,s1
    80005284:	998fe0ef          	jal	8000341c <iunlockput>
    return 0;
    80005288:	bf51                	j	8000521c <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000528a:	00492603          	lw	a2,4(s2)
    8000528e:	00003597          	auipc	a1,0x3
    80005292:	66a58593          	addi	a1,a1,1642 # 800088f8 <etext+0x8f8>
    80005296:	854a                	mv	a0,s2
    80005298:	efcfe0ef          	jal	80003994 <dirlink>
    8000529c:	02054e63          	bltz	a0,800052d8 <create+0x11c>
    800052a0:	40d0                	lw	a2,4(s1)
    800052a2:	00003597          	auipc	a1,0x3
    800052a6:	65e58593          	addi	a1,a1,1630 # 80008900 <etext+0x900>
    800052aa:	854a                	mv	a0,s2
    800052ac:	ee8fe0ef          	jal	80003994 <dirlink>
    800052b0:	02054463          	bltz	a0,800052d8 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800052b4:	00492603          	lw	a2,4(s2)
    800052b8:	fb040593          	addi	a1,s0,-80
    800052bc:	8526                	mv	a0,s1
    800052be:	ed6fe0ef          	jal	80003994 <dirlink>
    800052c2:	00054b63          	bltz	a0,800052d8 <create+0x11c>
    dp->nlink++;  // for ".."
    800052c6:	04a4d783          	lhu	a5,74(s1)
    800052ca:	2785                	addiw	a5,a5,1
    800052cc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052d0:	8526                	mv	a0,s1
    800052d2:	e8bfd0ef          	jal	8000315c <iupdate>
    800052d6:	b74d                	j	80005278 <create+0xbc>
  ip->nlink = 0;
    800052d8:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    800052dc:	854a                	mv	a0,s2
    800052de:	e7ffd0ef          	jal	8000315c <iupdate>
  iunlockput(ip);
    800052e2:	854a                	mv	a0,s2
    800052e4:	938fe0ef          	jal	8000341c <iunlockput>
  iunlockput(dp);
    800052e8:	8526                	mv	a0,s1
    800052ea:	932fe0ef          	jal	8000341c <iunlockput>
  return 0;
    800052ee:	b73d                	j	8000521c <create+0x60>
    return 0;
    800052f0:	89aa                	mv	s3,a0
    800052f2:	b72d                	j	8000521c <create+0x60>

00000000800052f4 <sys_dup>:
{
    800052f4:	7179                	addi	sp,sp,-48
    800052f6:	f406                	sd	ra,40(sp)
    800052f8:	f022                	sd	s0,32(sp)
    800052fa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800052fc:	fd840613          	addi	a2,s0,-40
    80005300:	4581                	li	a1,0
    80005302:	4501                	li	a0,0
    80005304:	e1fff0ef          	jal	80005122 <argfd>
    return -1;
    80005308:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000530a:	02054363          	bltz	a0,80005330 <sys_dup+0x3c>
    8000530e:	ec26                	sd	s1,24(sp)
    80005310:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005312:	fd843483          	ld	s1,-40(s0)
    80005316:	8526                	mv	a0,s1
    80005318:	e65ff0ef          	jal	8000517c <fdalloc>
    8000531c:	892a                	mv	s2,a0
    return -1;
    8000531e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005320:	00054d63          	bltz	a0,8000533a <sys_dup+0x46>
  filedup(f);
    80005324:	8526                	mv	a0,s1
    80005326:	c18ff0ef          	jal	8000473e <filedup>
  return fd;
    8000532a:	87ca                	mv	a5,s2
    8000532c:	64e2                	ld	s1,24(sp)
    8000532e:	6942                	ld	s2,16(sp)
}
    80005330:	853e                	mv	a0,a5
    80005332:	70a2                	ld	ra,40(sp)
    80005334:	7402                	ld	s0,32(sp)
    80005336:	6145                	addi	sp,sp,48
    80005338:	8082                	ret
    8000533a:	64e2                	ld	s1,24(sp)
    8000533c:	6942                	ld	s2,16(sp)
    8000533e:	bfcd                	j	80005330 <sys_dup+0x3c>

0000000080005340 <sys_read>:
{
    80005340:	7179                	addi	sp,sp,-48
    80005342:	f406                	sd	ra,40(sp)
    80005344:	f022                	sd	s0,32(sp)
    80005346:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005348:	fd840593          	addi	a1,s0,-40
    8000534c:	4505                	li	a0,1
    8000534e:	d0afd0ef          	jal	80002858 <argaddr>
  argint(2, &n);
    80005352:	fe440593          	addi	a1,s0,-28
    80005356:	4509                	li	a0,2
    80005358:	ce4fd0ef          	jal	8000283c <argint>
  if(argfd(0, 0, &f) < 0)
    8000535c:	fe840613          	addi	a2,s0,-24
    80005360:	4581                	li	a1,0
    80005362:	4501                	li	a0,0
    80005364:	dbfff0ef          	jal	80005122 <argfd>
    80005368:	87aa                	mv	a5,a0
    return -1;
    8000536a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000536c:	0007ca63          	bltz	a5,80005380 <sys_read+0x40>
  return fileread(f, p, n);
    80005370:	fe442603          	lw	a2,-28(s0)
    80005374:	fd843583          	ld	a1,-40(s0)
    80005378:	fe843503          	ld	a0,-24(s0)
    8000537c:	d2cff0ef          	jal	800048a8 <fileread>
}
    80005380:	70a2                	ld	ra,40(sp)
    80005382:	7402                	ld	s0,32(sp)
    80005384:	6145                	addi	sp,sp,48
    80005386:	8082                	ret

0000000080005388 <sys_write>:
{
    80005388:	7179                	addi	sp,sp,-48
    8000538a:	f406                	sd	ra,40(sp)
    8000538c:	f022                	sd	s0,32(sp)
    8000538e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005390:	fd840593          	addi	a1,s0,-40
    80005394:	4505                	li	a0,1
    80005396:	cc2fd0ef          	jal	80002858 <argaddr>
  argint(2, &n);
    8000539a:	fe440593          	addi	a1,s0,-28
    8000539e:	4509                	li	a0,2
    800053a0:	c9cfd0ef          	jal	8000283c <argint>
  if(argfd(0, 0, &f) < 0)
    800053a4:	fe840613          	addi	a2,s0,-24
    800053a8:	4581                	li	a1,0
    800053aa:	4501                	li	a0,0
    800053ac:	d77ff0ef          	jal	80005122 <argfd>
    800053b0:	87aa                	mv	a5,a0
    return -1;
    800053b2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053b4:	0007ca63          	bltz	a5,800053c8 <sys_write+0x40>
  return filewrite(f, p, n);
    800053b8:	fe442603          	lw	a2,-28(s0)
    800053bc:	fd843583          	ld	a1,-40(s0)
    800053c0:	fe843503          	ld	a0,-24(s0)
    800053c4:	da8ff0ef          	jal	8000496c <filewrite>
}
    800053c8:	70a2                	ld	ra,40(sp)
    800053ca:	7402                	ld	s0,32(sp)
    800053cc:	6145                	addi	sp,sp,48
    800053ce:	8082                	ret

00000000800053d0 <sys_close>:
{
    800053d0:	1101                	addi	sp,sp,-32
    800053d2:	ec06                	sd	ra,24(sp)
    800053d4:	e822                	sd	s0,16(sp)
    800053d6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800053d8:	fe040613          	addi	a2,s0,-32
    800053dc:	fec40593          	addi	a1,s0,-20
    800053e0:	4501                	li	a0,0
    800053e2:	d41ff0ef          	jal	80005122 <argfd>
    return -1;
    800053e6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800053e8:	02054163          	bltz	a0,8000540a <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800053ec:	d46fc0ef          	jal	80001932 <myproc>
    800053f0:	fec42783          	lw	a5,-20(s0)
    800053f4:	078e                	slli	a5,a5,0x3
    800053f6:	0d078793          	addi	a5,a5,208
    800053fa:	953e                	add	a0,a0,a5
    800053fc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005400:	fe043503          	ld	a0,-32(s0)
    80005404:	b80ff0ef          	jal	80004784 <fileclose>
  return 0;
    80005408:	4781                	li	a5,0
}
    8000540a:	853e                	mv	a0,a5
    8000540c:	60e2                	ld	ra,24(sp)
    8000540e:	6442                	ld	s0,16(sp)
    80005410:	6105                	addi	sp,sp,32
    80005412:	8082                	ret

0000000080005414 <sys_fstat>:
{
    80005414:	1101                	addi	sp,sp,-32
    80005416:	ec06                	sd	ra,24(sp)
    80005418:	e822                	sd	s0,16(sp)
    8000541a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000541c:	fe040593          	addi	a1,s0,-32
    80005420:	4505                	li	a0,1
    80005422:	c36fd0ef          	jal	80002858 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005426:	fe840613          	addi	a2,s0,-24
    8000542a:	4581                	li	a1,0
    8000542c:	4501                	li	a0,0
    8000542e:	cf5ff0ef          	jal	80005122 <argfd>
    80005432:	87aa                	mv	a5,a0
    return -1;
    80005434:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005436:	0007c863          	bltz	a5,80005446 <sys_fstat+0x32>
  return filestat(f, st);
    8000543a:	fe043583          	ld	a1,-32(s0)
    8000543e:	fe843503          	ld	a0,-24(s0)
    80005442:	c04ff0ef          	jal	80004846 <filestat>
}
    80005446:	60e2                	ld	ra,24(sp)
    80005448:	6442                	ld	s0,16(sp)
    8000544a:	6105                	addi	sp,sp,32
    8000544c:	8082                	ret

000000008000544e <sys_link>:
{
    8000544e:	7169                	addi	sp,sp,-304
    80005450:	f606                	sd	ra,296(sp)
    80005452:	f222                	sd	s0,288(sp)
    80005454:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005456:	08000613          	li	a2,128
    8000545a:	ed040593          	addi	a1,s0,-304
    8000545e:	4501                	li	a0,0
    80005460:	c14fd0ef          	jal	80002874 <argstr>
    return -1;
    80005464:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005466:	0c054e63          	bltz	a0,80005542 <sys_link+0xf4>
    8000546a:	08000613          	li	a2,128
    8000546e:	f5040593          	addi	a1,s0,-176
    80005472:	4505                	li	a0,1
    80005474:	c00fd0ef          	jal	80002874 <argstr>
    return -1;
    80005478:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000547a:	0c054463          	bltz	a0,80005542 <sys_link+0xf4>
    8000547e:	ee26                	sd	s1,280(sp)
  begin_op();
    80005480:	f9cfe0ef          	jal	80003c1c <begin_op>
  if((ip = namei(old)) == 0){
    80005484:	ed040513          	addi	a0,s0,-304
    80005488:	db6fe0ef          	jal	80003a3e <namei>
    8000548c:	84aa                	mv	s1,a0
    8000548e:	c53d                	beqz	a0,800054fc <sys_link+0xae>
  ilock(ip);
    80005490:	d81fd0ef          	jal	80003210 <ilock>
  if(ip->type == T_DIR){
    80005494:	04449703          	lh	a4,68(s1)
    80005498:	4785                	li	a5,1
    8000549a:	06f70663          	beq	a4,a5,80005506 <sys_link+0xb8>
    8000549e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800054a0:	04a4d783          	lhu	a5,74(s1)
    800054a4:	2785                	addiw	a5,a5,1
    800054a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054aa:	8526                	mv	a0,s1
    800054ac:	cb1fd0ef          	jal	8000315c <iupdate>
  iunlock(ip);
    800054b0:	8526                	mv	a0,s1
    800054b2:	e0dfd0ef          	jal	800032be <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800054b6:	fd040593          	addi	a1,s0,-48
    800054ba:	f5040513          	addi	a0,s0,-176
    800054be:	d9afe0ef          	jal	80003a58 <nameiparent>
    800054c2:	892a                	mv	s2,a0
    800054c4:	cd21                	beqz	a0,8000551c <sys_link+0xce>
  ilock(dp);
    800054c6:	d4bfd0ef          	jal	80003210 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800054ca:	854a                	mv	a0,s2
    800054cc:	00092703          	lw	a4,0(s2)
    800054d0:	409c                	lw	a5,0(s1)
    800054d2:	04f71263          	bne	a4,a5,80005516 <sys_link+0xc8>
    800054d6:	40d0                	lw	a2,4(s1)
    800054d8:	fd040593          	addi	a1,s0,-48
    800054dc:	cb8fe0ef          	jal	80003994 <dirlink>
    800054e0:	02054b63          	bltz	a0,80005516 <sys_link+0xc8>
  iunlockput(dp);
    800054e4:	854a                	mv	a0,s2
    800054e6:	f37fd0ef          	jal	8000341c <iunlockput>
  iput(ip);
    800054ea:	8526                	mv	a0,s1
    800054ec:	ea7fd0ef          	jal	80003392 <iput>
  end_op();
    800054f0:	f9cfe0ef          	jal	80003c8c <end_op>
  return 0;
    800054f4:	4781                	li	a5,0
    800054f6:	64f2                	ld	s1,280(sp)
    800054f8:	6952                	ld	s2,272(sp)
    800054fa:	a0a1                	j	80005542 <sys_link+0xf4>
    end_op();
    800054fc:	f90fe0ef          	jal	80003c8c <end_op>
    return -1;
    80005500:	57fd                	li	a5,-1
    80005502:	64f2                	ld	s1,280(sp)
    80005504:	a83d                	j	80005542 <sys_link+0xf4>
    iunlockput(ip);
    80005506:	8526                	mv	a0,s1
    80005508:	f15fd0ef          	jal	8000341c <iunlockput>
    end_op();
    8000550c:	f80fe0ef          	jal	80003c8c <end_op>
    return -1;
    80005510:	57fd                	li	a5,-1
    80005512:	64f2                	ld	s1,280(sp)
    80005514:	a03d                	j	80005542 <sys_link+0xf4>
    iunlockput(dp);
    80005516:	854a                	mv	a0,s2
    80005518:	f05fd0ef          	jal	8000341c <iunlockput>
  ilock(ip);
    8000551c:	8526                	mv	a0,s1
    8000551e:	cf3fd0ef          	jal	80003210 <ilock>
  ip->nlink--;
    80005522:	04a4d783          	lhu	a5,74(s1)
    80005526:	37fd                	addiw	a5,a5,-1
    80005528:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000552c:	8526                	mv	a0,s1
    8000552e:	c2ffd0ef          	jal	8000315c <iupdate>
  iunlockput(ip);
    80005532:	8526                	mv	a0,s1
    80005534:	ee9fd0ef          	jal	8000341c <iunlockput>
  end_op();
    80005538:	f54fe0ef          	jal	80003c8c <end_op>
  return -1;
    8000553c:	57fd                	li	a5,-1
    8000553e:	64f2                	ld	s1,280(sp)
    80005540:	6952                	ld	s2,272(sp)
}
    80005542:	853e                	mv	a0,a5
    80005544:	70b2                	ld	ra,296(sp)
    80005546:	7412                	ld	s0,288(sp)
    80005548:	6155                	addi	sp,sp,304
    8000554a:	8082                	ret

000000008000554c <sys_unlink>:
{
    8000554c:	7151                	addi	sp,sp,-240
    8000554e:	f586                	sd	ra,232(sp)
    80005550:	f1a2                	sd	s0,224(sp)
    80005552:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005554:	08000613          	li	a2,128
    80005558:	f3040593          	addi	a1,s0,-208
    8000555c:	4501                	li	a0,0
    8000555e:	b16fd0ef          	jal	80002874 <argstr>
    80005562:	14054d63          	bltz	a0,800056bc <sys_unlink+0x170>
    80005566:	eda6                	sd	s1,216(sp)
  begin_op();
    80005568:	eb4fe0ef          	jal	80003c1c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000556c:	fb040593          	addi	a1,s0,-80
    80005570:	f3040513          	addi	a0,s0,-208
    80005574:	ce4fe0ef          	jal	80003a58 <nameiparent>
    80005578:	84aa                	mv	s1,a0
    8000557a:	c955                	beqz	a0,8000562e <sys_unlink+0xe2>
  ilock(dp);
    8000557c:	c95fd0ef          	jal	80003210 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005580:	00003597          	auipc	a1,0x3
    80005584:	37858593          	addi	a1,a1,888 # 800088f8 <etext+0x8f8>
    80005588:	fb040513          	addi	a0,s0,-80
    8000558c:	a08fe0ef          	jal	80003794 <namecmp>
    80005590:	10050b63          	beqz	a0,800056a6 <sys_unlink+0x15a>
    80005594:	00003597          	auipc	a1,0x3
    80005598:	36c58593          	addi	a1,a1,876 # 80008900 <etext+0x900>
    8000559c:	fb040513          	addi	a0,s0,-80
    800055a0:	9f4fe0ef          	jal	80003794 <namecmp>
    800055a4:	10050163          	beqz	a0,800056a6 <sys_unlink+0x15a>
    800055a8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800055aa:	f2c40613          	addi	a2,s0,-212
    800055ae:	fb040593          	addi	a1,s0,-80
    800055b2:	8526                	mv	a0,s1
    800055b4:	9f6fe0ef          	jal	800037aa <dirlookup>
    800055b8:	892a                	mv	s2,a0
    800055ba:	0e050563          	beqz	a0,800056a4 <sys_unlink+0x158>
    800055be:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800055c0:	c51fd0ef          	jal	80003210 <ilock>
  if(ip->nlink < 1)
    800055c4:	04a91783          	lh	a5,74(s2)
    800055c8:	06f05863          	blez	a5,80005638 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055cc:	04491703          	lh	a4,68(s2)
    800055d0:	4785                	li	a5,1
    800055d2:	06f70963          	beq	a4,a5,80005644 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800055d6:	fc040993          	addi	s3,s0,-64
    800055da:	4641                	li	a2,16
    800055dc:	4581                	li	a1,0
    800055de:	854e                	mv	a0,s3
    800055e0:	f18fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055e4:	4741                	li	a4,16
    800055e6:	f2c42683          	lw	a3,-212(s0)
    800055ea:	864e                	mv	a2,s3
    800055ec:	4581                	li	a1,0
    800055ee:	8526                	mv	a0,s1
    800055f0:	8a4fe0ef          	jal	80003694 <writei>
    800055f4:	47c1                	li	a5,16
    800055f6:	08f51863          	bne	a0,a5,80005686 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800055fa:	04491703          	lh	a4,68(s2)
    800055fe:	4785                	li	a5,1
    80005600:	08f70963          	beq	a4,a5,80005692 <sys_unlink+0x146>
  iunlockput(dp);
    80005604:	8526                	mv	a0,s1
    80005606:	e17fd0ef          	jal	8000341c <iunlockput>
  ip->nlink--;
    8000560a:	04a95783          	lhu	a5,74(s2)
    8000560e:	37fd                	addiw	a5,a5,-1
    80005610:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005614:	854a                	mv	a0,s2
    80005616:	b47fd0ef          	jal	8000315c <iupdate>
  iunlockput(ip);
    8000561a:	854a                	mv	a0,s2
    8000561c:	e01fd0ef          	jal	8000341c <iunlockput>
  end_op();
    80005620:	e6cfe0ef          	jal	80003c8c <end_op>
  return 0;
    80005624:	4501                	li	a0,0
    80005626:	64ee                	ld	s1,216(sp)
    80005628:	694e                	ld	s2,208(sp)
    8000562a:	69ae                	ld	s3,200(sp)
    8000562c:	a061                	j	800056b4 <sys_unlink+0x168>
    end_op();
    8000562e:	e5efe0ef          	jal	80003c8c <end_op>
    return -1;
    80005632:	557d                	li	a0,-1
    80005634:	64ee                	ld	s1,216(sp)
    80005636:	a8bd                	j	800056b4 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80005638:	00003517          	auipc	a0,0x3
    8000563c:	2d050513          	addi	a0,a0,720 # 80008908 <etext+0x908>
    80005640:	9e4fb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005644:	04c92703          	lw	a4,76(s2)
    80005648:	02000793          	li	a5,32
    8000564c:	f8e7f5e3          	bgeu	a5,a4,800055d6 <sys_unlink+0x8a>
    80005650:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005652:	4741                	li	a4,16
    80005654:	86ce                	mv	a3,s3
    80005656:	f1840613          	addi	a2,s0,-232
    8000565a:	4581                	li	a1,0
    8000565c:	854a                	mv	a0,s2
    8000565e:	f45fd0ef          	jal	800035a2 <readi>
    80005662:	47c1                	li	a5,16
    80005664:	00f51b63          	bne	a0,a5,8000567a <sys_unlink+0x12e>
    if(de.inum != 0)
    80005668:	f1845783          	lhu	a5,-232(s0)
    8000566c:	ebb1                	bnez	a5,800056c0 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000566e:	29c1                	addiw	s3,s3,16
    80005670:	04c92783          	lw	a5,76(s2)
    80005674:	fcf9efe3          	bltu	s3,a5,80005652 <sys_unlink+0x106>
    80005678:	bfb9                	j	800055d6 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000567a:	00003517          	auipc	a0,0x3
    8000567e:	2a650513          	addi	a0,a0,678 # 80008920 <etext+0x920>
    80005682:	9a2fb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    80005686:	00003517          	auipc	a0,0x3
    8000568a:	2b250513          	addi	a0,a0,690 # 80008938 <etext+0x938>
    8000568e:	996fb0ef          	jal	80000824 <panic>
    dp->nlink--;
    80005692:	04a4d783          	lhu	a5,74(s1)
    80005696:	37fd                	addiw	a5,a5,-1
    80005698:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000569c:	8526                	mv	a0,s1
    8000569e:	abffd0ef          	jal	8000315c <iupdate>
    800056a2:	b78d                	j	80005604 <sys_unlink+0xb8>
    800056a4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800056a6:	8526                	mv	a0,s1
    800056a8:	d75fd0ef          	jal	8000341c <iunlockput>
  end_op();
    800056ac:	de0fe0ef          	jal	80003c8c <end_op>
  return -1;
    800056b0:	557d                	li	a0,-1
    800056b2:	64ee                	ld	s1,216(sp)
}
    800056b4:	70ae                	ld	ra,232(sp)
    800056b6:	740e                	ld	s0,224(sp)
    800056b8:	616d                	addi	sp,sp,240
    800056ba:	8082                	ret
    return -1;
    800056bc:	557d                	li	a0,-1
    800056be:	bfdd                	j	800056b4 <sys_unlink+0x168>
    iunlockput(ip);
    800056c0:	854a                	mv	a0,s2
    800056c2:	d5bfd0ef          	jal	8000341c <iunlockput>
    goto bad;
    800056c6:	694e                	ld	s2,208(sp)
    800056c8:	69ae                	ld	s3,200(sp)
    800056ca:	bff1                	j	800056a6 <sys_unlink+0x15a>

00000000800056cc <sys_open>:

uint64
sys_open(void)
{
    800056cc:	7131                	addi	sp,sp,-192
    800056ce:	fd06                	sd	ra,184(sp)
    800056d0:	f922                	sd	s0,176(sp)
    800056d2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800056d4:	f4c40593          	addi	a1,s0,-180
    800056d8:	4505                	li	a0,1
    800056da:	962fd0ef          	jal	8000283c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800056de:	08000613          	li	a2,128
    800056e2:	f5040593          	addi	a1,s0,-176
    800056e6:	4501                	li	a0,0
    800056e8:	98cfd0ef          	jal	80002874 <argstr>
    800056ec:	87aa                	mv	a5,a0
    return -1;
    800056ee:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800056f0:	0a07c363          	bltz	a5,80005796 <sys_open+0xca>
    800056f4:	f526                	sd	s1,168(sp)

  begin_op();
    800056f6:	d26fe0ef          	jal	80003c1c <begin_op>

  if(omode & O_CREATE){
    800056fa:	f4c42783          	lw	a5,-180(s0)
    800056fe:	2007f793          	andi	a5,a5,512
    80005702:	c3dd                	beqz	a5,800057a8 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005704:	4681                	li	a3,0
    80005706:	4601                	li	a2,0
    80005708:	4589                	li	a1,2
    8000570a:	f5040513          	addi	a0,s0,-176
    8000570e:	aafff0ef          	jal	800051bc <create>
    80005712:	84aa                	mv	s1,a0
    if(ip == 0){
    80005714:	c549                	beqz	a0,8000579e <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005716:	04449703          	lh	a4,68(s1)
    8000571a:	478d                	li	a5,3
    8000571c:	00f71763          	bne	a4,a5,8000572a <sys_open+0x5e>
    80005720:	0464d703          	lhu	a4,70(s1)
    80005724:	47a5                	li	a5,9
    80005726:	0ae7ee63          	bltu	a5,a4,800057e2 <sys_open+0x116>
    8000572a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000572c:	fb5fe0ef          	jal	800046e0 <filealloc>
    80005730:	892a                	mv	s2,a0
    80005732:	c561                	beqz	a0,800057fa <sys_open+0x12e>
    80005734:	ed4e                	sd	s3,152(sp)
    80005736:	a47ff0ef          	jal	8000517c <fdalloc>
    8000573a:	89aa                	mv	s3,a0
    8000573c:	0a054b63          	bltz	a0,800057f2 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005740:	04449703          	lh	a4,68(s1)
    80005744:	478d                	li	a5,3
    80005746:	0cf70363          	beq	a4,a5,8000580c <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000574a:	4789                	li	a5,2
    8000574c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005750:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005754:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005758:	f4c42783          	lw	a5,-180(s0)
    8000575c:	0017f713          	andi	a4,a5,1
    80005760:	00174713          	xori	a4,a4,1
    80005764:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005768:	0037f713          	andi	a4,a5,3
    8000576c:	00e03733          	snez	a4,a4
    80005770:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005774:	4007f793          	andi	a5,a5,1024
    80005778:	c791                	beqz	a5,80005784 <sys_open+0xb8>
    8000577a:	04449703          	lh	a4,68(s1)
    8000577e:	4789                	li	a5,2
    80005780:	08f70d63          	beq	a4,a5,8000581a <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005784:	8526                	mv	a0,s1
    80005786:	b39fd0ef          	jal	800032be <iunlock>
  end_op();
    8000578a:	d02fe0ef          	jal	80003c8c <end_op>

  return fd;
    8000578e:	854e                	mv	a0,s3
    80005790:	74aa                	ld	s1,168(sp)
    80005792:	790a                	ld	s2,160(sp)
    80005794:	69ea                	ld	s3,152(sp)
}
    80005796:	70ea                	ld	ra,184(sp)
    80005798:	744a                	ld	s0,176(sp)
    8000579a:	6129                	addi	sp,sp,192
    8000579c:	8082                	ret
      end_op();
    8000579e:	ceefe0ef          	jal	80003c8c <end_op>
      return -1;
    800057a2:	557d                	li	a0,-1
    800057a4:	74aa                	ld	s1,168(sp)
    800057a6:	bfc5                	j	80005796 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800057a8:	f5040513          	addi	a0,s0,-176
    800057ac:	a92fe0ef          	jal	80003a3e <namei>
    800057b0:	84aa                	mv	s1,a0
    800057b2:	c11d                	beqz	a0,800057d8 <sys_open+0x10c>
    ilock(ip);
    800057b4:	a5dfd0ef          	jal	80003210 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800057b8:	04449703          	lh	a4,68(s1)
    800057bc:	4785                	li	a5,1
    800057be:	f4f71ce3          	bne	a4,a5,80005716 <sys_open+0x4a>
    800057c2:	f4c42783          	lw	a5,-180(s0)
    800057c6:	d3b5                	beqz	a5,8000572a <sys_open+0x5e>
      iunlockput(ip);
    800057c8:	8526                	mv	a0,s1
    800057ca:	c53fd0ef          	jal	8000341c <iunlockput>
      end_op();
    800057ce:	cbefe0ef          	jal	80003c8c <end_op>
      return -1;
    800057d2:	557d                	li	a0,-1
    800057d4:	74aa                	ld	s1,168(sp)
    800057d6:	b7c1                	j	80005796 <sys_open+0xca>
      end_op();
    800057d8:	cb4fe0ef          	jal	80003c8c <end_op>
      return -1;
    800057dc:	557d                	li	a0,-1
    800057de:	74aa                	ld	s1,168(sp)
    800057e0:	bf5d                	j	80005796 <sys_open+0xca>
    iunlockput(ip);
    800057e2:	8526                	mv	a0,s1
    800057e4:	c39fd0ef          	jal	8000341c <iunlockput>
    end_op();
    800057e8:	ca4fe0ef          	jal	80003c8c <end_op>
    return -1;
    800057ec:	557d                	li	a0,-1
    800057ee:	74aa                	ld	s1,168(sp)
    800057f0:	b75d                	j	80005796 <sys_open+0xca>
      fileclose(f);
    800057f2:	854a                	mv	a0,s2
    800057f4:	f91fe0ef          	jal	80004784 <fileclose>
    800057f8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800057fa:	8526                	mv	a0,s1
    800057fc:	c21fd0ef          	jal	8000341c <iunlockput>
    end_op();
    80005800:	c8cfe0ef          	jal	80003c8c <end_op>
    return -1;
    80005804:	557d                	li	a0,-1
    80005806:	74aa                	ld	s1,168(sp)
    80005808:	790a                	ld	s2,160(sp)
    8000580a:	b771                	j	80005796 <sys_open+0xca>
    f->type = FD_DEVICE;
    8000580c:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005810:	04649783          	lh	a5,70(s1)
    80005814:	02f91223          	sh	a5,36(s2)
    80005818:	bf35                	j	80005754 <sys_open+0x88>
    itrunc(ip);
    8000581a:	8526                	mv	a0,s1
    8000581c:	ae3fd0ef          	jal	800032fe <itrunc>
    80005820:	b795                	j	80005784 <sys_open+0xb8>

0000000080005822 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005822:	7175                	addi	sp,sp,-144
    80005824:	e506                	sd	ra,136(sp)
    80005826:	e122                	sd	s0,128(sp)
    80005828:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000582a:	bf2fe0ef          	jal	80003c1c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000582e:	08000613          	li	a2,128
    80005832:	f7040593          	addi	a1,s0,-144
    80005836:	4501                	li	a0,0
    80005838:	83cfd0ef          	jal	80002874 <argstr>
    8000583c:	02054363          	bltz	a0,80005862 <sys_mkdir+0x40>
    80005840:	4681                	li	a3,0
    80005842:	4601                	li	a2,0
    80005844:	4585                	li	a1,1
    80005846:	f7040513          	addi	a0,s0,-144
    8000584a:	973ff0ef          	jal	800051bc <create>
    8000584e:	c911                	beqz	a0,80005862 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005850:	bcdfd0ef          	jal	8000341c <iunlockput>
  end_op();
    80005854:	c38fe0ef          	jal	80003c8c <end_op>
  return 0;
    80005858:	4501                	li	a0,0
}
    8000585a:	60aa                	ld	ra,136(sp)
    8000585c:	640a                	ld	s0,128(sp)
    8000585e:	6149                	addi	sp,sp,144
    80005860:	8082                	ret
    end_op();
    80005862:	c2afe0ef          	jal	80003c8c <end_op>
    return -1;
    80005866:	557d                	li	a0,-1
    80005868:	bfcd                	j	8000585a <sys_mkdir+0x38>

000000008000586a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000586a:	7135                	addi	sp,sp,-160
    8000586c:	ed06                	sd	ra,152(sp)
    8000586e:	e922                	sd	s0,144(sp)
    80005870:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005872:	baafe0ef          	jal	80003c1c <begin_op>
  argint(1, &major);
    80005876:	f6c40593          	addi	a1,s0,-148
    8000587a:	4505                	li	a0,1
    8000587c:	fc1fc0ef          	jal	8000283c <argint>
  argint(2, &minor);
    80005880:	f6840593          	addi	a1,s0,-152
    80005884:	4509                	li	a0,2
    80005886:	fb7fc0ef          	jal	8000283c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000588a:	08000613          	li	a2,128
    8000588e:	f7040593          	addi	a1,s0,-144
    80005892:	4501                	li	a0,0
    80005894:	fe1fc0ef          	jal	80002874 <argstr>
    80005898:	02054563          	bltz	a0,800058c2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000589c:	f6841683          	lh	a3,-152(s0)
    800058a0:	f6c41603          	lh	a2,-148(s0)
    800058a4:	458d                	li	a1,3
    800058a6:	f7040513          	addi	a0,s0,-144
    800058aa:	913ff0ef          	jal	800051bc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800058ae:	c911                	beqz	a0,800058c2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058b0:	b6dfd0ef          	jal	8000341c <iunlockput>
  end_op();
    800058b4:	bd8fe0ef          	jal	80003c8c <end_op>
  return 0;
    800058b8:	4501                	li	a0,0
}
    800058ba:	60ea                	ld	ra,152(sp)
    800058bc:	644a                	ld	s0,144(sp)
    800058be:	610d                	addi	sp,sp,160
    800058c0:	8082                	ret
    end_op();
    800058c2:	bcafe0ef          	jal	80003c8c <end_op>
    return -1;
    800058c6:	557d                	li	a0,-1
    800058c8:	bfcd                	j	800058ba <sys_mknod+0x50>

00000000800058ca <sys_chdir>:

uint64
sys_chdir(void)
{
    800058ca:	7135                	addi	sp,sp,-160
    800058cc:	ed06                	sd	ra,152(sp)
    800058ce:	e922                	sd	s0,144(sp)
    800058d0:	e14a                	sd	s2,128(sp)
    800058d2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800058d4:	85efc0ef          	jal	80001932 <myproc>
    800058d8:	892a                	mv	s2,a0
  
  begin_op();
    800058da:	b42fe0ef          	jal	80003c1c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800058de:	08000613          	li	a2,128
    800058e2:	f6040593          	addi	a1,s0,-160
    800058e6:	4501                	li	a0,0
    800058e8:	f8dfc0ef          	jal	80002874 <argstr>
    800058ec:	04054363          	bltz	a0,80005932 <sys_chdir+0x68>
    800058f0:	e526                	sd	s1,136(sp)
    800058f2:	f6040513          	addi	a0,s0,-160
    800058f6:	948fe0ef          	jal	80003a3e <namei>
    800058fa:	84aa                	mv	s1,a0
    800058fc:	c915                	beqz	a0,80005930 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800058fe:	913fd0ef          	jal	80003210 <ilock>
  if(ip->type != T_DIR){
    80005902:	04449703          	lh	a4,68(s1)
    80005906:	4785                	li	a5,1
    80005908:	02f71963          	bne	a4,a5,8000593a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000590c:	8526                	mv	a0,s1
    8000590e:	9b1fd0ef          	jal	800032be <iunlock>
  iput(p->cwd);
    80005912:	15093503          	ld	a0,336(s2)
    80005916:	a7dfd0ef          	jal	80003392 <iput>
  end_op();
    8000591a:	b72fe0ef          	jal	80003c8c <end_op>
  p->cwd = ip;
    8000591e:	14993823          	sd	s1,336(s2)
  return 0;
    80005922:	4501                	li	a0,0
    80005924:	64aa                	ld	s1,136(sp)
}
    80005926:	60ea                	ld	ra,152(sp)
    80005928:	644a                	ld	s0,144(sp)
    8000592a:	690a                	ld	s2,128(sp)
    8000592c:	610d                	addi	sp,sp,160
    8000592e:	8082                	ret
    80005930:	64aa                	ld	s1,136(sp)
    end_op();
    80005932:	b5afe0ef          	jal	80003c8c <end_op>
    return -1;
    80005936:	557d                	li	a0,-1
    80005938:	b7fd                	j	80005926 <sys_chdir+0x5c>
    iunlockput(ip);
    8000593a:	8526                	mv	a0,s1
    8000593c:	ae1fd0ef          	jal	8000341c <iunlockput>
    end_op();
    80005940:	b4cfe0ef          	jal	80003c8c <end_op>
    return -1;
    80005944:	557d                	li	a0,-1
    80005946:	64aa                	ld	s1,136(sp)
    80005948:	bff9                	j	80005926 <sys_chdir+0x5c>

000000008000594a <sys_exec>:

uint64
sys_exec(void)
{
    8000594a:	7105                	addi	sp,sp,-480
    8000594c:	ef86                	sd	ra,472(sp)
    8000594e:	eba2                	sd	s0,464(sp)
    80005950:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005952:	e2840593          	addi	a1,s0,-472
    80005956:	4505                	li	a0,1
    80005958:	f01fc0ef          	jal	80002858 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000595c:	08000613          	li	a2,128
    80005960:	f3040593          	addi	a1,s0,-208
    80005964:	4501                	li	a0,0
    80005966:	f0ffc0ef          	jal	80002874 <argstr>
    8000596a:	87aa                	mv	a5,a0
    return -1;
    8000596c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000596e:	0e07c063          	bltz	a5,80005a4e <sys_exec+0x104>
    80005972:	e7a6                	sd	s1,456(sp)
    80005974:	e3ca                	sd	s2,448(sp)
    80005976:	ff4e                	sd	s3,440(sp)
    80005978:	fb52                	sd	s4,432(sp)
    8000597a:	f756                	sd	s5,424(sp)
    8000597c:	f35a                	sd	s6,416(sp)
    8000597e:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005980:	e3040a13          	addi	s4,s0,-464
    80005984:	10000613          	li	a2,256
    80005988:	4581                	li	a1,0
    8000598a:	8552                	mv	a0,s4
    8000598c:	b6cfb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005990:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005992:	89d2                	mv	s3,s4
    80005994:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005996:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000599a:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000599c:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800059a0:	00391513          	slli	a0,s2,0x3
    800059a4:	85d6                	mv	a1,s5
    800059a6:	e2843783          	ld	a5,-472(s0)
    800059aa:	953e                	add	a0,a0,a5
    800059ac:	e07fc0ef          	jal	800027b2 <fetchaddr>
    800059b0:	02054663          	bltz	a0,800059dc <sys_exec+0x92>
    if(uarg == 0){
    800059b4:	e2043783          	ld	a5,-480(s0)
    800059b8:	c7a1                	beqz	a5,80005a00 <sys_exec+0xb6>
    argv[i] = kalloc();
    800059ba:	98afb0ef          	jal	80000b44 <kalloc>
    800059be:	85aa                	mv	a1,a0
    800059c0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800059c4:	cd01                	beqz	a0,800059dc <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800059c6:	865a                	mv	a2,s6
    800059c8:	e2043503          	ld	a0,-480(s0)
    800059cc:	e31fc0ef          	jal	800027fc <fetchstr>
    800059d0:	00054663          	bltz	a0,800059dc <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800059d4:	0905                	addi	s2,s2,1
    800059d6:	09a1                	addi	s3,s3,8
    800059d8:	fd7914e3          	bne	s2,s7,800059a0 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059dc:	100a0a13          	addi	s4,s4,256
    800059e0:	6088                	ld	a0,0(s1)
    800059e2:	cd31                	beqz	a0,80005a3e <sys_exec+0xf4>
    kfree(argv[i]);
    800059e4:	878fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059e8:	04a1                	addi	s1,s1,8
    800059ea:	ff449be3          	bne	s1,s4,800059e0 <sys_exec+0x96>
  return -1;
    800059ee:	557d                	li	a0,-1
    800059f0:	64be                	ld	s1,456(sp)
    800059f2:	691e                	ld	s2,448(sp)
    800059f4:	79fa                	ld	s3,440(sp)
    800059f6:	7a5a                	ld	s4,432(sp)
    800059f8:	7aba                	ld	s5,424(sp)
    800059fa:	7b1a                	ld	s6,416(sp)
    800059fc:	6bfa                	ld	s7,408(sp)
    800059fe:	a881                	j	80005a4e <sys_exec+0x104>
      argv[i] = 0;
    80005a00:	0009079b          	sext.w	a5,s2
    80005a04:	e3040593          	addi	a1,s0,-464
    80005a08:	078e                	slli	a5,a5,0x3
    80005a0a:	97ae                	add	a5,a5,a1
    80005a0c:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005a10:	f3040513          	addi	a0,s0,-208
    80005a14:	bb2ff0ef          	jal	80004dc6 <kexec>
    80005a18:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a1a:	100a0a13          	addi	s4,s4,256
    80005a1e:	6088                	ld	a0,0(s1)
    80005a20:	c511                	beqz	a0,80005a2c <sys_exec+0xe2>
    kfree(argv[i]);
    80005a22:	83afb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a26:	04a1                	addi	s1,s1,8
    80005a28:	ff449be3          	bne	s1,s4,80005a1e <sys_exec+0xd4>
  return ret;
    80005a2c:	854a                	mv	a0,s2
    80005a2e:	64be                	ld	s1,456(sp)
    80005a30:	691e                	ld	s2,448(sp)
    80005a32:	79fa                	ld	s3,440(sp)
    80005a34:	7a5a                	ld	s4,432(sp)
    80005a36:	7aba                	ld	s5,424(sp)
    80005a38:	7b1a                	ld	s6,416(sp)
    80005a3a:	6bfa                	ld	s7,408(sp)
    80005a3c:	a809                	j	80005a4e <sys_exec+0x104>
  return -1;
    80005a3e:	557d                	li	a0,-1
    80005a40:	64be                	ld	s1,456(sp)
    80005a42:	691e                	ld	s2,448(sp)
    80005a44:	79fa                	ld	s3,440(sp)
    80005a46:	7a5a                	ld	s4,432(sp)
    80005a48:	7aba                	ld	s5,424(sp)
    80005a4a:	7b1a                	ld	s6,416(sp)
    80005a4c:	6bfa                	ld	s7,408(sp)
}
    80005a4e:	60fe                	ld	ra,472(sp)
    80005a50:	645e                	ld	s0,464(sp)
    80005a52:	613d                	addi	sp,sp,480
    80005a54:	8082                	ret

0000000080005a56 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005a56:	7139                	addi	sp,sp,-64
    80005a58:	fc06                	sd	ra,56(sp)
    80005a5a:	f822                	sd	s0,48(sp)
    80005a5c:	f426                	sd	s1,40(sp)
    80005a5e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005a60:	ed3fb0ef          	jal	80001932 <myproc>
    80005a64:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005a66:	fd840593          	addi	a1,s0,-40
    80005a6a:	4501                	li	a0,0
    80005a6c:	dedfc0ef          	jal	80002858 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005a70:	fc840593          	addi	a1,s0,-56
    80005a74:	fd040513          	addi	a0,s0,-48
    80005a78:	828ff0ef          	jal	80004aa0 <pipealloc>
    return -1;
    80005a7c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005a7e:	0a054763          	bltz	a0,80005b2c <sys_pipe+0xd6>
  fd0 = -1;
    80005a82:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005a86:	fd043503          	ld	a0,-48(s0)
    80005a8a:	ef2ff0ef          	jal	8000517c <fdalloc>
    80005a8e:	fca42223          	sw	a0,-60(s0)
    80005a92:	08054463          	bltz	a0,80005b1a <sys_pipe+0xc4>
    80005a96:	fc843503          	ld	a0,-56(s0)
    80005a9a:	ee2ff0ef          	jal	8000517c <fdalloc>
    80005a9e:	fca42023          	sw	a0,-64(s0)
    80005aa2:	06054263          	bltz	a0,80005b06 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005aa6:	4691                	li	a3,4
    80005aa8:	fc440613          	addi	a2,s0,-60
    80005aac:	fd843583          	ld	a1,-40(s0)
    80005ab0:	68a8                	ld	a0,80(s1)
    80005ab2:	ba7fb0ef          	jal	80001658 <copyout>
    80005ab6:	00054e63          	bltz	a0,80005ad2 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005aba:	4691                	li	a3,4
    80005abc:	fc040613          	addi	a2,s0,-64
    80005ac0:	fd843583          	ld	a1,-40(s0)
    80005ac4:	95b6                	add	a1,a1,a3
    80005ac6:	68a8                	ld	a0,80(s1)
    80005ac8:	b91fb0ef          	jal	80001658 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005acc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ace:	04055f63          	bgez	a0,80005b2c <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80005ad2:	fc442783          	lw	a5,-60(s0)
    80005ad6:	078e                	slli	a5,a5,0x3
    80005ad8:	0d078793          	addi	a5,a5,208
    80005adc:	97a6                	add	a5,a5,s1
    80005ade:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ae2:	fc042783          	lw	a5,-64(s0)
    80005ae6:	078e                	slli	a5,a5,0x3
    80005ae8:	0d078793          	addi	a5,a5,208
    80005aec:	97a6                	add	a5,a5,s1
    80005aee:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005af2:	fd043503          	ld	a0,-48(s0)
    80005af6:	c8ffe0ef          	jal	80004784 <fileclose>
    fileclose(wf);
    80005afa:	fc843503          	ld	a0,-56(s0)
    80005afe:	c87fe0ef          	jal	80004784 <fileclose>
    return -1;
    80005b02:	57fd                	li	a5,-1
    80005b04:	a025                	j	80005b2c <sys_pipe+0xd6>
    if(fd0 >= 0)
    80005b06:	fc442783          	lw	a5,-60(s0)
    80005b0a:	0007c863          	bltz	a5,80005b1a <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80005b0e:	078e                	slli	a5,a5,0x3
    80005b10:	0d078793          	addi	a5,a5,208
    80005b14:	97a6                	add	a5,a5,s1
    80005b16:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005b1a:	fd043503          	ld	a0,-48(s0)
    80005b1e:	c67fe0ef          	jal	80004784 <fileclose>
    fileclose(wf);
    80005b22:	fc843503          	ld	a0,-56(s0)
    80005b26:	c5ffe0ef          	jal	80004784 <fileclose>
    return -1;
    80005b2a:	57fd                	li	a5,-1
}
    80005b2c:	853e                	mv	a0,a5
    80005b2e:	70e2                	ld	ra,56(sp)
    80005b30:	7442                	ld	s0,48(sp)
    80005b32:	74a2                	ld	s1,40(sp)
    80005b34:	6121                	addi	sp,sp,64
    80005b36:	8082                	ret
	...

0000000080005b40 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005b40:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005b42:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005b44:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005b46:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005b48:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005b4a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80005b4c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80005b4e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005b50:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005b52:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005b54:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005b56:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005b58:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005b5a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80005b5c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80005b5e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005b60:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005b62:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005b64:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005b66:	b5bfc0ef          	jal	800026c0 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005b6a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80005b6c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80005b6e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005b70:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005b72:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005b74:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005b76:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005b78:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005b7a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80005b7c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80005b7e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005b80:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005b82:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005b84:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005b86:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005b88:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005b8a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80005b8c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80005b8e:	10200073          	sret
    80005b92:	00000013          	nop
    80005b96:	00000013          	nop
    80005b9a:	00000013          	nop

0000000080005b9e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005b9e:	1141                	addi	sp,sp,-16
    80005ba0:	e406                	sd	ra,8(sp)
    80005ba2:	e022                	sd	s0,0(sp)
    80005ba4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005ba6:	0c000737          	lui	a4,0xc000
    80005baa:	4785                	li	a5,1
    80005bac:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005bae:	c35c                	sw	a5,4(a4)
}
    80005bb0:	60a2                	ld	ra,8(sp)
    80005bb2:	6402                	ld	s0,0(sp)
    80005bb4:	0141                	addi	sp,sp,16
    80005bb6:	8082                	ret

0000000080005bb8 <plicinithart>:

void
plicinithart(void)
{
    80005bb8:	1141                	addi	sp,sp,-16
    80005bba:	e406                	sd	ra,8(sp)
    80005bbc:	e022                	sd	s0,0(sp)
    80005bbe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005bc0:	d3ffb0ef          	jal	800018fe <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005bc4:	0085171b          	slliw	a4,a0,0x8
    80005bc8:	0c0027b7          	lui	a5,0xc002
    80005bcc:	97ba                	add	a5,a5,a4
    80005bce:	40200713          	li	a4,1026
    80005bd2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005bd6:	00d5151b          	slliw	a0,a0,0xd
    80005bda:	0c2017b7          	lui	a5,0xc201
    80005bde:	97aa                	add	a5,a5,a0
    80005be0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005be4:	60a2                	ld	ra,8(sp)
    80005be6:	6402                	ld	s0,0(sp)
    80005be8:	0141                	addi	sp,sp,16
    80005bea:	8082                	ret

0000000080005bec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005bec:	1141                	addi	sp,sp,-16
    80005bee:	e406                	sd	ra,8(sp)
    80005bf0:	e022                	sd	s0,0(sp)
    80005bf2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005bf4:	d0bfb0ef          	jal	800018fe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005bf8:	00d5151b          	slliw	a0,a0,0xd
    80005bfc:	0c2017b7          	lui	a5,0xc201
    80005c00:	97aa                	add	a5,a5,a0
  return irq;
}
    80005c02:	43c8                	lw	a0,4(a5)
    80005c04:	60a2                	ld	ra,8(sp)
    80005c06:	6402                	ld	s0,0(sp)
    80005c08:	0141                	addi	sp,sp,16
    80005c0a:	8082                	ret

0000000080005c0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005c0c:	1101                	addi	sp,sp,-32
    80005c0e:	ec06                	sd	ra,24(sp)
    80005c10:	e822                	sd	s0,16(sp)
    80005c12:	e426                	sd	s1,8(sp)
    80005c14:	1000                	addi	s0,sp,32
    80005c16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005c18:	ce7fb0ef          	jal	800018fe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005c1c:	00d5179b          	slliw	a5,a0,0xd
    80005c20:	0c201737          	lui	a4,0xc201
    80005c24:	97ba                	add	a5,a5,a4
    80005c26:	c3c4                	sw	s1,4(a5)
}
    80005c28:	60e2                	ld	ra,24(sp)
    80005c2a:	6442                	ld	s0,16(sp)
    80005c2c:	64a2                	ld	s1,8(sp)
    80005c2e:	6105                	addi	sp,sp,32
    80005c30:	8082                	ret

0000000080005c32 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005c32:	1141                	addi	sp,sp,-16
    80005c34:	e406                	sd	ra,8(sp)
    80005c36:	e022                	sd	s0,0(sp)
    80005c38:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005c3a:	479d                	li	a5,7
    80005c3c:	04a7ca63          	blt	a5,a0,80005c90 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005c40:	0001c797          	auipc	a5,0x1c
    80005c44:	17878793          	addi	a5,a5,376 # 80021db8 <disk>
    80005c48:	97aa                	add	a5,a5,a0
    80005c4a:	0187c783          	lbu	a5,24(a5)
    80005c4e:	e7b9                	bnez	a5,80005c9c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005c50:	00451693          	slli	a3,a0,0x4
    80005c54:	0001c797          	auipc	a5,0x1c
    80005c58:	16478793          	addi	a5,a5,356 # 80021db8 <disk>
    80005c5c:	6398                	ld	a4,0(a5)
    80005c5e:	9736                	add	a4,a4,a3
    80005c60:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005c64:	6398                	ld	a4,0(a5)
    80005c66:	9736                	add	a4,a4,a3
    80005c68:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005c6c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005c70:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005c74:	97aa                	add	a5,a5,a0
    80005c76:	4705                	li	a4,1
    80005c78:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005c7c:	0001c517          	auipc	a0,0x1c
    80005c80:	15450513          	addi	a0,a0,340 # 80021dd0 <disk+0x18>
    80005c84:	af8fc0ef          	jal	80001f7c <wakeup>
}
    80005c88:	60a2                	ld	ra,8(sp)
    80005c8a:	6402                	ld	s0,0(sp)
    80005c8c:	0141                	addi	sp,sp,16
    80005c8e:	8082                	ret
    panic("free_desc 1");
    80005c90:	00003517          	auipc	a0,0x3
    80005c94:	cb850513          	addi	a0,a0,-840 # 80008948 <etext+0x948>
    80005c98:	b8dfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    80005c9c:	00003517          	auipc	a0,0x3
    80005ca0:	cbc50513          	addi	a0,a0,-836 # 80008958 <etext+0x958>
    80005ca4:	b81fa0ef          	jal	80000824 <panic>

0000000080005ca8 <virtio_disk_init>:
{
    80005ca8:	1101                	addi	sp,sp,-32
    80005caa:	ec06                	sd	ra,24(sp)
    80005cac:	e822                	sd	s0,16(sp)
    80005cae:	e426                	sd	s1,8(sp)
    80005cb0:	e04a                	sd	s2,0(sp)
    80005cb2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005cb4:	00003597          	auipc	a1,0x3
    80005cb8:	cb458593          	addi	a1,a1,-844 # 80008968 <etext+0x968>
    80005cbc:	0001c517          	auipc	a0,0x1c
    80005cc0:	22450513          	addi	a0,a0,548 # 80021ee0 <disk+0x128>
    80005cc4:	edbfa0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005cc8:	100017b7          	lui	a5,0x10001
    80005ccc:	4398                	lw	a4,0(a5)
    80005cce:	2701                	sext.w	a4,a4
    80005cd0:	747277b7          	lui	a5,0x74727
    80005cd4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005cd8:	14f71863          	bne	a4,a5,80005e28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005cdc:	100017b7          	lui	a5,0x10001
    80005ce0:	43dc                	lw	a5,4(a5)
    80005ce2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ce4:	4709                	li	a4,2
    80005ce6:	14e79163          	bne	a5,a4,80005e28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cea:	100017b7          	lui	a5,0x10001
    80005cee:	479c                	lw	a5,8(a5)
    80005cf0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005cf2:	12e79b63          	bne	a5,a4,80005e28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005cf6:	100017b7          	lui	a5,0x10001
    80005cfa:	47d8                	lw	a4,12(a5)
    80005cfc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005cfe:	554d47b7          	lui	a5,0x554d4
    80005d02:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005d06:	12f71163          	bne	a4,a5,80005e28 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d0a:	100017b7          	lui	a5,0x10001
    80005d0e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d12:	4705                	li	a4,1
    80005d14:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d16:	470d                	li	a4,3
    80005d18:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005d1a:	10001737          	lui	a4,0x10001
    80005d1e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005d20:	c7ffe6b7          	lui	a3,0xc7ffe
    80005d24:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc867>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005d28:	8f75                	and	a4,a4,a3
    80005d2a:	100016b7          	lui	a3,0x10001
    80005d2e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d30:	472d                	li	a4,11
    80005d32:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d34:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005d38:	439c                	lw	a5,0(a5)
    80005d3a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005d3e:	8ba1                	andi	a5,a5,8
    80005d40:	0e078a63          	beqz	a5,80005e34 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005d44:	100017b7          	lui	a5,0x10001
    80005d48:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005d4c:	43fc                	lw	a5,68(a5)
    80005d4e:	2781                	sext.w	a5,a5
    80005d50:	0e079863          	bnez	a5,80005e40 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005d54:	100017b7          	lui	a5,0x10001
    80005d58:	5bdc                	lw	a5,52(a5)
    80005d5a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005d5c:	0e078863          	beqz	a5,80005e4c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005d60:	471d                	li	a4,7
    80005d62:	0ef77b63          	bgeu	a4,a5,80005e58 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005d66:	ddffa0ef          	jal	80000b44 <kalloc>
    80005d6a:	0001c497          	auipc	s1,0x1c
    80005d6e:	04e48493          	addi	s1,s1,78 # 80021db8 <disk>
    80005d72:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005d74:	dd1fa0ef          	jal	80000b44 <kalloc>
    80005d78:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005d7a:	dcbfa0ef          	jal	80000b44 <kalloc>
    80005d7e:	87aa                	mv	a5,a0
    80005d80:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005d82:	6088                	ld	a0,0(s1)
    80005d84:	0e050063          	beqz	a0,80005e64 <virtio_disk_init+0x1bc>
    80005d88:	0001c717          	auipc	a4,0x1c
    80005d8c:	03873703          	ld	a4,56(a4) # 80021dc0 <disk+0x8>
    80005d90:	cb71                	beqz	a4,80005e64 <virtio_disk_init+0x1bc>
    80005d92:	cbe9                	beqz	a5,80005e64 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005d94:	6605                	lui	a2,0x1
    80005d96:	4581                	li	a1,0
    80005d98:	f61fa0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005d9c:	0001c497          	auipc	s1,0x1c
    80005da0:	01c48493          	addi	s1,s1,28 # 80021db8 <disk>
    80005da4:	6605                	lui	a2,0x1
    80005da6:	4581                	li	a1,0
    80005da8:	6488                	ld	a0,8(s1)
    80005daa:	f4ffa0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005dae:	6605                	lui	a2,0x1
    80005db0:	4581                	li	a1,0
    80005db2:	6888                	ld	a0,16(s1)
    80005db4:	f45fa0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005db8:	100017b7          	lui	a5,0x10001
    80005dbc:	4721                	li	a4,8
    80005dbe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005dc0:	4098                	lw	a4,0(s1)
    80005dc2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005dc6:	40d8                	lw	a4,4(s1)
    80005dc8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005dcc:	649c                	ld	a5,8(s1)
    80005dce:	0007869b          	sext.w	a3,a5
    80005dd2:	10001737          	lui	a4,0x10001
    80005dd6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005dda:	9781                	srai	a5,a5,0x20
    80005ddc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005de0:	689c                	ld	a5,16(s1)
    80005de2:	0007869b          	sext.w	a3,a5
    80005de6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005dea:	9781                	srai	a5,a5,0x20
    80005dec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005df0:	4785                	li	a5,1
    80005df2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005df4:	00f48c23          	sb	a5,24(s1)
    80005df8:	00f48ca3          	sb	a5,25(s1)
    80005dfc:	00f48d23          	sb	a5,26(s1)
    80005e00:	00f48da3          	sb	a5,27(s1)
    80005e04:	00f48e23          	sb	a5,28(s1)
    80005e08:	00f48ea3          	sb	a5,29(s1)
    80005e0c:	00f48f23          	sb	a5,30(s1)
    80005e10:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005e14:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e18:	07272823          	sw	s2,112(a4)
}
    80005e1c:	60e2                	ld	ra,24(sp)
    80005e1e:	6442                	ld	s0,16(sp)
    80005e20:	64a2                	ld	s1,8(sp)
    80005e22:	6902                	ld	s2,0(sp)
    80005e24:	6105                	addi	sp,sp,32
    80005e26:	8082                	ret
    panic("could not find virtio disk");
    80005e28:	00003517          	auipc	a0,0x3
    80005e2c:	b5050513          	addi	a0,a0,-1200 # 80008978 <etext+0x978>
    80005e30:	9f5fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005e34:	00003517          	auipc	a0,0x3
    80005e38:	b6450513          	addi	a0,a0,-1180 # 80008998 <etext+0x998>
    80005e3c:	9e9fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80005e40:	00003517          	auipc	a0,0x3
    80005e44:	b7850513          	addi	a0,a0,-1160 # 800089b8 <etext+0x9b8>
    80005e48:	9ddfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    80005e4c:	00003517          	auipc	a0,0x3
    80005e50:	b8c50513          	addi	a0,a0,-1140 # 800089d8 <etext+0x9d8>
    80005e54:	9d1fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80005e58:	00003517          	auipc	a0,0x3
    80005e5c:	ba050513          	addi	a0,a0,-1120 # 800089f8 <etext+0x9f8>
    80005e60:	9c5fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005e64:	00003517          	auipc	a0,0x3
    80005e68:	bb450513          	addi	a0,a0,-1100 # 80008a18 <etext+0xa18>
    80005e6c:	9b9fa0ef          	jal	80000824 <panic>

0000000080005e70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005e70:	711d                	addi	sp,sp,-96
    80005e72:	ec86                	sd	ra,88(sp)
    80005e74:	e8a2                	sd	s0,80(sp)
    80005e76:	e4a6                	sd	s1,72(sp)
    80005e78:	e0ca                	sd	s2,64(sp)
    80005e7a:	fc4e                	sd	s3,56(sp)
    80005e7c:	f852                	sd	s4,48(sp)
    80005e7e:	f456                	sd	s5,40(sp)
    80005e80:	f05a                	sd	s6,32(sp)
    80005e82:	ec5e                	sd	s7,24(sp)
    80005e84:	e862                	sd	s8,16(sp)
    80005e86:	1080                	addi	s0,sp,96
    80005e88:	89aa                	mv	s3,a0
    80005e8a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005e8c:	00c52b83          	lw	s7,12(a0)
    80005e90:	001b9b9b          	slliw	s7,s7,0x1
    80005e94:	1b82                	slli	s7,s7,0x20
    80005e96:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005e9a:	0001c517          	auipc	a0,0x1c
    80005e9e:	04650513          	addi	a0,a0,70 # 80021ee0 <disk+0x128>
    80005ea2:	d87fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005ea6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005ea8:	0001ca97          	auipc	s5,0x1c
    80005eac:	f10a8a93          	addi	s5,s5,-240 # 80021db8 <disk>
  for(int i = 0; i < 3; i++){
    80005eb0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005eb2:	5c7d                	li	s8,-1
    80005eb4:	a095                	j	80005f18 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005eb6:	00fa8733          	add	a4,s5,a5
    80005eba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005ebe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005ec0:	0207c563          	bltz	a5,80005eea <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005ec4:	2905                	addiw	s2,s2,1
    80005ec6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005ec8:	05490c63          	beq	s2,s4,80005f20 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80005ecc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005ece:	0001c717          	auipc	a4,0x1c
    80005ed2:	eea70713          	addi	a4,a4,-278 # 80021db8 <disk>
    80005ed6:	4781                	li	a5,0
    if(disk.free[i]){
    80005ed8:	01874683          	lbu	a3,24(a4)
    80005edc:	fee9                	bnez	a3,80005eb6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80005ede:	2785                	addiw	a5,a5,1
    80005ee0:	0705                	addi	a4,a4,1
    80005ee2:	fe979be3          	bne	a5,s1,80005ed8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005ee6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80005eea:	01205d63          	blez	s2,80005f04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005eee:	fa042503          	lw	a0,-96(s0)
    80005ef2:	d41ff0ef          	jal	80005c32 <free_desc>
      for(int j = 0; j < i; j++)
    80005ef6:	4785                	li	a5,1
    80005ef8:	0127d663          	bge	a5,s2,80005f04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005efc:	fa442503          	lw	a0,-92(s0)
    80005f00:	d33ff0ef          	jal	80005c32 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005f04:	0001c597          	auipc	a1,0x1c
    80005f08:	fdc58593          	addi	a1,a1,-36 # 80021ee0 <disk+0x128>
    80005f0c:	0001c517          	auipc	a0,0x1c
    80005f10:	ec450513          	addi	a0,a0,-316 # 80021dd0 <disk+0x18>
    80005f14:	81cfc0ef          	jal	80001f30 <sleep>
  for(int i = 0; i < 3; i++){
    80005f18:	fa040613          	addi	a2,s0,-96
    80005f1c:	4901                	li	s2,0
    80005f1e:	b77d                	j	80005ecc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005f20:	fa042503          	lw	a0,-96(s0)
    80005f24:	00451693          	slli	a3,a0,0x4

  if(write)
    80005f28:	0001c797          	auipc	a5,0x1c
    80005f2c:	e9078793          	addi	a5,a5,-368 # 80021db8 <disk>
    80005f30:	00451713          	slli	a4,a0,0x4
    80005f34:	0a070713          	addi	a4,a4,160
    80005f38:	973e                	add	a4,a4,a5
    80005f3a:	01603633          	snez	a2,s6
    80005f3e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005f40:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005f44:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005f48:	6398                	ld	a4,0(a5)
    80005f4a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005f4c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005f50:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005f52:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005f54:	6390                	ld	a2,0(a5)
    80005f56:	00d60833          	add	a6,a2,a3
    80005f5a:	4741                	li	a4,16
    80005f5c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005f60:	4585                	li	a1,1
    80005f62:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005f66:	fa442703          	lw	a4,-92(s0)
    80005f6a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005f6e:	0712                	slli	a4,a4,0x4
    80005f70:	963a                	add	a2,a2,a4
    80005f72:	05898813          	addi	a6,s3,88
    80005f76:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005f7a:	0007b883          	ld	a7,0(a5)
    80005f7e:	9746                	add	a4,a4,a7
    80005f80:	40000613          	li	a2,1024
    80005f84:	c710                	sw	a2,8(a4)
  if(write)
    80005f86:	001b3613          	seqz	a2,s6
    80005f8a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005f8e:	8e4d                	or	a2,a2,a1
    80005f90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005f94:	fa842603          	lw	a2,-88(s0)
    80005f98:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005f9c:	00451813          	slli	a6,a0,0x4
    80005fa0:	02080813          	addi	a6,a6,32
    80005fa4:	983e                	add	a6,a6,a5
    80005fa6:	577d                	li	a4,-1
    80005fa8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005fac:	0612                	slli	a2,a2,0x4
    80005fae:	98b2                	add	a7,a7,a2
    80005fb0:	03068713          	addi	a4,a3,48
    80005fb4:	973e                	add	a4,a4,a5
    80005fb6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005fba:	6398                	ld	a4,0(a5)
    80005fbc:	9732                	add	a4,a4,a2
    80005fbe:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005fc0:	4689                	li	a3,2
    80005fc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005fc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005fca:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005fce:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005fd2:	6794                	ld	a3,8(a5)
    80005fd4:	0026d703          	lhu	a4,2(a3)
    80005fd8:	8b1d                	andi	a4,a4,7
    80005fda:	0706                	slli	a4,a4,0x1
    80005fdc:	96ba                	add	a3,a3,a4
    80005fde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005fe2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005fe6:	6798                	ld	a4,8(a5)
    80005fe8:	00275783          	lhu	a5,2(a4)
    80005fec:	2785                	addiw	a5,a5,1
    80005fee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005ff2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005ff6:	100017b7          	lui	a5,0x10001
    80005ffa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005ffe:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006002:	0001c917          	auipc	s2,0x1c
    80006006:	ede90913          	addi	s2,s2,-290 # 80021ee0 <disk+0x128>
  while(b->disk == 1) {
    8000600a:	84ae                	mv	s1,a1
    8000600c:	00b79a63          	bne	a5,a1,80006020 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80006010:	85ca                	mv	a1,s2
    80006012:	854e                	mv	a0,s3
    80006014:	f1dfb0ef          	jal	80001f30 <sleep>
  while(b->disk == 1) {
    80006018:	0049a783          	lw	a5,4(s3)
    8000601c:	fe978ae3          	beq	a5,s1,80006010 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80006020:	fa042903          	lw	s2,-96(s0)
    80006024:	00491713          	slli	a4,s2,0x4
    80006028:	02070713          	addi	a4,a4,32
    8000602c:	0001c797          	auipc	a5,0x1c
    80006030:	d8c78793          	addi	a5,a5,-628 # 80021db8 <disk>
    80006034:	97ba                	add	a5,a5,a4
    80006036:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000603a:	0001c997          	auipc	s3,0x1c
    8000603e:	d7e98993          	addi	s3,s3,-642 # 80021db8 <disk>
    80006042:	00491713          	slli	a4,s2,0x4
    80006046:	0009b783          	ld	a5,0(s3)
    8000604a:	97ba                	add	a5,a5,a4
    8000604c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006050:	854a                	mv	a0,s2
    80006052:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006056:	bddff0ef          	jal	80005c32 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000605a:	8885                	andi	s1,s1,1
    8000605c:	f0fd                	bnez	s1,80006042 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000605e:	0001c517          	auipc	a0,0x1c
    80006062:	e8250513          	addi	a0,a0,-382 # 80021ee0 <disk+0x128>
    80006066:	c57fa0ef          	jal	80000cbc <release>
}
    8000606a:	60e6                	ld	ra,88(sp)
    8000606c:	6446                	ld	s0,80(sp)
    8000606e:	64a6                	ld	s1,72(sp)
    80006070:	6906                	ld	s2,64(sp)
    80006072:	79e2                	ld	s3,56(sp)
    80006074:	7a42                	ld	s4,48(sp)
    80006076:	7aa2                	ld	s5,40(sp)
    80006078:	7b02                	ld	s6,32(sp)
    8000607a:	6be2                	ld	s7,24(sp)
    8000607c:	6c42                	ld	s8,16(sp)
    8000607e:	6125                	addi	sp,sp,96
    80006080:	8082                	ret

0000000080006082 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006082:	1101                	addi	sp,sp,-32
    80006084:	ec06                	sd	ra,24(sp)
    80006086:	e822                	sd	s0,16(sp)
    80006088:	e426                	sd	s1,8(sp)
    8000608a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000608c:	0001c497          	auipc	s1,0x1c
    80006090:	d2c48493          	addi	s1,s1,-724 # 80021db8 <disk>
    80006094:	0001c517          	auipc	a0,0x1c
    80006098:	e4c50513          	addi	a0,a0,-436 # 80021ee0 <disk+0x128>
    8000609c:	b8dfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800060a0:	100017b7          	lui	a5,0x10001
    800060a4:	53bc                	lw	a5,96(a5)
    800060a6:	8b8d                	andi	a5,a5,3
    800060a8:	10001737          	lui	a4,0x10001
    800060ac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800060ae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800060b2:	689c                	ld	a5,16(s1)
    800060b4:	0204d703          	lhu	a4,32(s1)
    800060b8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800060bc:	04f70863          	beq	a4,a5,8000610c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800060c0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800060c4:	6898                	ld	a4,16(s1)
    800060c6:	0204d783          	lhu	a5,32(s1)
    800060ca:	8b9d                	andi	a5,a5,7
    800060cc:	078e                	slli	a5,a5,0x3
    800060ce:	97ba                	add	a5,a5,a4
    800060d0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800060d2:	00479713          	slli	a4,a5,0x4
    800060d6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    800060da:	9726                	add	a4,a4,s1
    800060dc:	01074703          	lbu	a4,16(a4)
    800060e0:	e329                	bnez	a4,80006122 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800060e2:	0792                	slli	a5,a5,0x4
    800060e4:	02078793          	addi	a5,a5,32
    800060e8:	97a6                	add	a5,a5,s1
    800060ea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800060ec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800060f0:	e8dfb0ef          	jal	80001f7c <wakeup>

    disk.used_idx += 1;
    800060f4:	0204d783          	lhu	a5,32(s1)
    800060f8:	2785                	addiw	a5,a5,1
    800060fa:	17c2                	slli	a5,a5,0x30
    800060fc:	93c1                	srli	a5,a5,0x30
    800060fe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006102:	6898                	ld	a4,16(s1)
    80006104:	00275703          	lhu	a4,2(a4)
    80006108:	faf71ce3          	bne	a4,a5,800060c0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000610c:	0001c517          	auipc	a0,0x1c
    80006110:	dd450513          	addi	a0,a0,-556 # 80021ee0 <disk+0x128>
    80006114:	ba9fa0ef          	jal	80000cbc <release>
}
    80006118:	60e2                	ld	ra,24(sp)
    8000611a:	6442                	ld	s0,16(sp)
    8000611c:	64a2                	ld	s1,8(sp)
    8000611e:	6105                	addi	sp,sp,32
    80006120:	8082                	ret
      panic("virtio_disk_intr status");
    80006122:	00003517          	auipc	a0,0x3
    80006126:	90e50513          	addi	a0,a0,-1778 # 80008a30 <etext+0xa30>
    8000612a:	efafa0ef          	jal	80000824 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
