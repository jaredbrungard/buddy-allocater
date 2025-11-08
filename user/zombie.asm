
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2c6000ef          	jal	2ce <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2c4000ef          	jal	2d6 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	34e000ef          	jal	366 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	2aa000ef          	jal	2d6 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	87aa                	mv	a5,a0
  3a:	0585                	addi	a1,a1,1
  3c:	0785                	addi	a5,a5,1
  3e:	fff5c703          	lbu	a4,-1(a1)
  42:	fee78fa3          	sb	a4,-1(a5)
  46:	fb75                	bnez	a4,3a <strcpy+0xa>
    ;
  return os;
}
  48:	60a2                	ld	ra,8(sp)
  4a:	6402                	ld	s0,0(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x20>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x20>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strlen>:

uint
strlen(const char *s)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cf91                	beqz	a5,a8 <strlen+0x28>
  8e:	00150793          	addi	a5,a0,1
  92:	86be                	mv	a3,a5
  94:	0785                	addi	a5,a5,1
  96:	fff7c703          	lbu	a4,-1(a5)
  9a:	ff65                	bnez	a4,92 <strlen+0x12>
  9c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  a0:	60a2                	ld	ra,8(sp)
  a2:	6402                	ld	s0,0(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret
  for(n = 0; s[n]; n++)
  a8:	4501                	li	a0,0
  aa:	bfdd                	j	a0 <strlen+0x20>

00000000000000ac <memset>:

void*
memset(void *dst, int c, uint n)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b4:	ca19                	beqz	a2,ca <memset+0x1e>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x14>
  }
  return dst;
}
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strchr>:

char*
strchr(const char *s, char c)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf81                	beqz	a5,f6 <strchr+0x24>
    if(*s == c)
  e0:	00f58763          	beq	a1,a5,ee <strchr+0x1c>
  for(; *s; s++)
  e4:	0505                	addi	a0,a0,1
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbfd                	bnez	a5,e0 <strchr+0xe>
      return (char*)s;
  return 0;
  ec:	4501                	li	a0,0
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfdd                	j	ee <strchr+0x1c>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	711d                	addi	sp,sp,-96
  fc:	ec86                	sd	ra,88(sp)
  fe:	e8a2                	sd	s0,80(sp)
 100:	e4a6                	sd	s1,72(sp)
 102:	e0ca                	sd	s2,64(sp)
 104:	fc4e                	sd	s3,56(sp)
 106:	f852                	sd	s4,48(sp)
 108:	f456                	sd	s5,40(sp)
 10a:	f05a                	sd	s6,32(sp)
 10c:	ec5e                	sd	s7,24(sp)
 10e:	e862                	sd	s8,16(sp)
 110:	1080                	addi	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
 11a:	faf40b13          	addi	s6,s0,-81
 11e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 120:	8c26                	mv	s8,s1
 122:	0014899b          	addiw	s3,s1,1
 126:	84ce                	mv	s1,s3
 128:	0349d463          	bge	s3,s4,150 <gets+0x56>
    cc = read(0, &c, 1);
 12c:	8656                	mv	a2,s5
 12e:	85da                	mv	a1,s6
 130:	4501                	li	a0,0
 132:	1bc000ef          	jal	2ee <read>
    if(cc < 1)
 136:	00a05d63          	blez	a0,150 <gets+0x56>
      break;
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	0905                	addi	s2,s2,1
 144:	ff678713          	addi	a4,a5,-10
 148:	c319                	beqz	a4,14e <gets+0x54>
 14a:	17cd                	addi	a5,a5,-13
 14c:	fbf1                	bnez	a5,120 <gets+0x26>
    buf[i++] = c;
 14e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 150:	9c5e                	add	s8,s8,s7
 152:	000c0023          	sb	zero,0(s8)
  return buf;
}
 156:	855e                	mv	a0,s7
 158:	60e6                	ld	ra,88(sp)
 15a:	6446                	ld	s0,80(sp)
 15c:	64a6                	ld	s1,72(sp)
 15e:	6906                	ld	s2,64(sp)
 160:	79e2                	ld	s3,56(sp)
 162:	7a42                	ld	s4,48(sp)
 164:	7aa2                	ld	s5,40(sp)
 166:	7b02                	ld	s6,32(sp)
 168:	6be2                	ld	s7,24(sp)
 16a:	6c42                	ld	s8,16(sp)
 16c:	6125                	addi	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	addi	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	addi	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	198000ef          	jal	316 <open>
  if(fd < 0)
 182:	02054263          	bltz	a0,1a6 <stat+0x36>
 186:	e426                	sd	s1,8(sp)
 188:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18a:	85ca                	mv	a1,s2
 18c:	1a2000ef          	jal	32e <fstat>
 190:	892a                	mv	s2,a0
  close(fd);
 192:	8526                	mv	a0,s1
 194:	16a000ef          	jal	2fe <close>
  return r;
 198:	64a2                	ld	s1,8(sp)
}
 19a:	854a                	mv	a0,s2
 19c:	60e2                	ld	ra,24(sp)
 19e:	6442                	ld	s0,16(sp)
 1a0:	6902                	ld	s2,0(sp)
 1a2:	6105                	addi	sp,sp,32
 1a4:	8082                	ret
    return -1;
 1a6:	57fd                	li	a5,-1
 1a8:	893e                	mv	s2,a5
 1aa:	bfc5                	j	19a <stat+0x2a>

00000000000001ac <atoi>:

int
atoi(const char *s)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b4:	00054683          	lbu	a3,0(a0)
 1b8:	fd06879b          	addiw	a5,a3,-48
 1bc:	0ff7f793          	zext.b	a5,a5
 1c0:	4625                	li	a2,9
 1c2:	02f66963          	bltu	a2,a5,1f4 <atoi+0x48>
 1c6:	872a                	mv	a4,a0
  n = 0;
 1c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ca:	0705                	addi	a4,a4,1
 1cc:	0025179b          	slliw	a5,a0,0x2
 1d0:	9fa9                	addw	a5,a5,a0
 1d2:	0017979b          	slliw	a5,a5,0x1
 1d6:	9fb5                	addw	a5,a5,a3
 1d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1dc:	00074683          	lbu	a3,0(a4)
 1e0:	fd06879b          	addiw	a5,a3,-48
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	fef671e3          	bgeu	a2,a5,1ca <atoi+0x1e>
  return n;
}
 1ec:	60a2                	ld	ra,8(sp)
 1ee:	6402                	ld	s0,0(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfdd                	j	1ec <atoi+0x40>

00000000000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 200:	02b57563          	bgeu	a0,a1,22a <memmove+0x32>
    while(n-- > 0)
 204:	00c05f63          	blez	a2,222 <memmove+0x2a>
 208:	1602                	slli	a2,a2,0x20
 20a:	9201                	srli	a2,a2,0x20
 20c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 210:	872a                	mv	a4,a0
      *dst++ = *src++;
 212:	0585                	addi	a1,a1,1
 214:	0705                	addi	a4,a4,1
 216:	fff5c683          	lbu	a3,-1(a1)
 21a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21e:	fee79ae3          	bne	a5,a4,212 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 222:	60a2                	ld	ra,8(sp)
 224:	6402                	ld	s0,0(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
    while(n-- > 0)
 22a:	fec05ce3          	blez	a2,222 <memmove+0x2a>
    dst += n;
 22e:	00c50733          	add	a4,a0,a2
    src += n;
 232:	95b2                	add	a1,a1,a2
 234:	fff6079b          	addiw	a5,a2,-1
 238:	1782                	slli	a5,a5,0x20
 23a:	9381                	srli	a5,a5,0x20
 23c:	fff7c793          	not	a5,a5
 240:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 242:	15fd                	addi	a1,a1,-1
 244:	177d                	addi	a4,a4,-1
 246:	0005c683          	lbu	a3,0(a1)
 24a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24e:	fef71ae3          	bne	a4,a5,242 <memmove+0x4a>
 252:	bfc1                	j	222 <memmove+0x2a>

0000000000000254 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	c61d                	beqz	a2,28a <memcmp+0x36>
 25e:	1602                	slli	a2,a2,0x20
 260:	9201                	srli	a2,a2,0x20
 262:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 266:	00054783          	lbu	a5,0(a0)
 26a:	0005c703          	lbu	a4,0(a1)
 26e:	00e79863          	bne	a5,a4,27e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 272:	0505                	addi	a0,a0,1
    p2++;
 274:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 276:	fed518e3          	bne	a0,a3,266 <memcmp+0x12>
  }
  return 0;
 27a:	4501                	li	a0,0
 27c:	a019                	j	282 <memcmp+0x2e>
      return *p1 - *p2;
 27e:	40e7853b          	subw	a0,a5,a4
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
  return 0;
 28a:	4501                	li	a0,0
 28c:	bfdd                	j	282 <memcmp+0x2e>

000000000000028e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 296:	f63ff0ef          	jal	1f8 <memmove>
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <sbrk>:

char *
sbrk(int n) {
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2aa:	4585                	li	a1,1
 2ac:	0b2000ef          	jal	35e <sys_sbrk>
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <sbrklazy>:

char *
sbrklazy(int n) {
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2c0:	4589                	li	a1,2
 2c2:	09c000ef          	jal	35e <sys_sbrk>
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ce:	4885                	li	a7,1
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d6:	4889                	li	a7,2
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <wait>:
.global wait
wait:
 li a7, SYS_wait
 2de:	488d                	li	a7,3
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e6:	4891                	li	a7,4
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <read>:
.global read
read:
 li a7, SYS_read
 2ee:	4895                	li	a7,5
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <write>:
.global write
write:
 li a7, SYS_write
 2f6:	48c1                	li	a7,16
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <close>:
.global close
close:
 li a7, SYS_close
 2fe:	48d5                	li	a7,21
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <kill>:
.global kill
kill:
 li a7, SYS_kill
 306:	4899                	li	a7,6
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exec>:
.global exec
exec:
 li a7, SYS_exec
 30e:	489d                	li	a7,7
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <open>:
.global open
open:
 li a7, SYS_open
 316:	48bd                	li	a7,15
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31e:	48c5                	li	a7,17
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 326:	48c9                	li	a7,18
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32e:	48a1                	li	a7,8
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <link>:
.global link
link:
 li a7, SYS_link
 336:	48cd                	li	a7,19
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33e:	48d1                	li	a7,20
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 346:	48a5                	li	a7,9
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <dup>:
.global dup
dup:
 li a7, SYS_dup
 34e:	48a9                	li	a7,10
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 356:	48ad                	li	a7,11
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 35e:	48b1                	li	a7,12
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <pause>:
.global pause
pause:
 li a7, SYS_pause
 366:	48b5                	li	a7,13
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36e:	48b9                	li	a7,14
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 376:	1101                	addi	sp,sp,-32
 378:	ec06                	sd	ra,24(sp)
 37a:	e822                	sd	s0,16(sp)
 37c:	1000                	addi	s0,sp,32
 37e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 382:	4605                	li	a2,1
 384:	fef40593          	addi	a1,s0,-17
 388:	f6fff0ef          	jal	2f6 <write>
}
 38c:	60e2                	ld	ra,24(sp)
 38e:	6442                	ld	s0,16(sp)
 390:	6105                	addi	sp,sp,32
 392:	8082                	ret

0000000000000394 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 394:	715d                	addi	sp,sp,-80
 396:	e486                	sd	ra,72(sp)
 398:	e0a2                	sd	s0,64(sp)
 39a:	f84a                	sd	s2,48(sp)
 39c:	f44e                	sd	s3,40(sp)
 39e:	0880                	addi	s0,sp,80
 3a0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a2:	cac1                	beqz	a3,432 <printint+0x9e>
 3a4:	0805d763          	bgez	a1,432 <printint+0x9e>
    neg = 1;
    x = -xx;
 3a8:	40b005bb          	negw	a1,a1
    neg = 1;
 3ac:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ae:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3b2:	86ce                	mv	a3,s3
  i = 0;
 3b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b6:	00000817          	auipc	a6,0x0
 3ba:	52280813          	addi	a6,a6,1314 # 8d8 <digits>
 3be:	88ba                	mv	a7,a4
 3c0:	0017051b          	addiw	a0,a4,1
 3c4:	872a                	mv	a4,a0
 3c6:	02c5f7bb          	remuw	a5,a1,a2
 3ca:	1782                	slli	a5,a5,0x20
 3cc:	9381                	srli	a5,a5,0x20
 3ce:	97c2                	add	a5,a5,a6
 3d0:	0007c783          	lbu	a5,0(a5)
 3d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d8:	87ae                	mv	a5,a1
 3da:	02c5d5bb          	divuw	a1,a1,a2
 3de:	0685                	addi	a3,a3,1
 3e0:	fcc7ffe3          	bgeu	a5,a2,3be <printint+0x2a>
  if(neg)
 3e4:	00030c63          	beqz	t1,3fc <printint+0x68>
    buf[i++] = '-';
 3e8:	fd050793          	addi	a5,a0,-48
 3ec:	00878533          	add	a0,a5,s0
 3f0:	02d00793          	li	a5,45
 3f4:	fef50423          	sb	a5,-24(a0)
 3f8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 3fc:	02e05563          	blez	a4,426 <printint+0x92>
 400:	fc26                	sd	s1,56(sp)
 402:	377d                	addiw	a4,a4,-1
 404:	00e984b3          	add	s1,s3,a4
 408:	19fd                	addi	s3,s3,-1
 40a:	99ba                	add	s3,s3,a4
 40c:	1702                	slli	a4,a4,0x20
 40e:	9301                	srli	a4,a4,0x20
 410:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 414:	0004c583          	lbu	a1,0(s1)
 418:	854a                	mv	a0,s2
 41a:	f5dff0ef          	jal	376 <putc>
  while(--i >= 0)
 41e:	14fd                	addi	s1,s1,-1
 420:	ff349ae3          	bne	s1,s3,414 <printint+0x80>
 424:	74e2                	ld	s1,56(sp)
}
 426:	60a6                	ld	ra,72(sp)
 428:	6406                	ld	s0,64(sp)
 42a:	7942                	ld	s2,48(sp)
 42c:	79a2                	ld	s3,40(sp)
 42e:	6161                	addi	sp,sp,80
 430:	8082                	ret
    x = xx;
 432:	2581                	sext.w	a1,a1
  neg = 0;
 434:	4301                	li	t1,0
 436:	bfa5                	j	3ae <printint+0x1a>

0000000000000438 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 438:	711d                	addi	sp,sp,-96
 43a:	ec86                	sd	ra,88(sp)
 43c:	e8a2                	sd	s0,80(sp)
 43e:	e4a6                	sd	s1,72(sp)
 440:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 442:	0005c483          	lbu	s1,0(a1)
 446:	22048363          	beqz	s1,66c <vprintf+0x234>
 44a:	e0ca                	sd	s2,64(sp)
 44c:	fc4e                	sd	s3,56(sp)
 44e:	f852                	sd	s4,48(sp)
 450:	f456                	sd	s5,40(sp)
 452:	f05a                	sd	s6,32(sp)
 454:	ec5e                	sd	s7,24(sp)
 456:	e862                	sd	s8,16(sp)
 458:	8b2a                	mv	s6,a0
 45a:	8a2e                	mv	s4,a1
 45c:	8bb2                	mv	s7,a2
  state = 0;
 45e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 460:	4901                	li	s2,0
 462:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 464:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 468:	06400c13          	li	s8,100
 46c:	a00d                	j	48e <vprintf+0x56>
        putc(fd, c0);
 46e:	85a6                	mv	a1,s1
 470:	855a                	mv	a0,s6
 472:	f05ff0ef          	jal	376 <putc>
 476:	a019                	j	47c <vprintf+0x44>
    } else if(state == '%'){
 478:	03598363          	beq	s3,s5,49e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 47c:	0019079b          	addiw	a5,s2,1
 480:	893e                	mv	s2,a5
 482:	873e                	mv	a4,a5
 484:	97d2                	add	a5,a5,s4
 486:	0007c483          	lbu	s1,0(a5)
 48a:	1c048a63          	beqz	s1,65e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 48e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 492:	fe0993e3          	bnez	s3,478 <vprintf+0x40>
      if(c0 == '%'){
 496:	fd579ce3          	bne	a5,s5,46e <vprintf+0x36>
        state = '%';
 49a:	89be                	mv	s3,a5
 49c:	b7c5                	j	47c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 49e:	00ea06b3          	add	a3,s4,a4
 4a2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4a6:	1c060863          	beqz	a2,676 <vprintf+0x23e>
      if(c0 == 'd'){
 4aa:	03878763          	beq	a5,s8,4d8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ae:	f9478693          	addi	a3,a5,-108
 4b2:	0016b693          	seqz	a3,a3
 4b6:	f9c60593          	addi	a1,a2,-100
 4ba:	e99d                	bnez	a1,4f0 <vprintf+0xb8>
 4bc:	ca95                	beqz	a3,4f0 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4be:	008b8493          	addi	s1,s7,8
 4c2:	4685                	li	a3,1
 4c4:	4629                	li	a2,10
 4c6:	000bb583          	ld	a1,0(s7)
 4ca:	855a                	mv	a0,s6
 4cc:	ec9ff0ef          	jal	394 <printint>
        i += 1;
 4d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4d2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	b75d                	j	47c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4d8:	008b8493          	addi	s1,s7,8
 4dc:	4685                	li	a3,1
 4de:	4629                	li	a2,10
 4e0:	000ba583          	lw	a1,0(s7)
 4e4:	855a                	mv	a0,s6
 4e6:	eafff0ef          	jal	394 <printint>
 4ea:	8ba6                	mv	s7,s1
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b779                	j	47c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 4f0:	9752                	add	a4,a4,s4
 4f2:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4f6:	f9460713          	addi	a4,a2,-108
 4fa:	00173713          	seqz	a4,a4
 4fe:	8f75                	and	a4,a4,a3
 500:	f9c58513          	addi	a0,a1,-100
 504:	18051363          	bnez	a0,68a <vprintf+0x252>
 508:	18070163          	beqz	a4,68a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50c:	008b8493          	addi	s1,s7,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000bb583          	ld	a1,0(s7)
 518:	855a                	mv	a0,s6
 51a:	e7bff0ef          	jal	394 <printint>
        i += 2;
 51e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 520:	8ba6                	mv	s7,s1
      state = 0;
 522:	4981                	li	s3,0
        i += 2;
 524:	bfa1                	j	47c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 526:	008b8493          	addi	s1,s7,8
 52a:	4681                	li	a3,0
 52c:	4629                	li	a2,10
 52e:	000be583          	lwu	a1,0(s7)
 532:	855a                	mv	a0,s6
 534:	e61ff0ef          	jal	394 <printint>
 538:	8ba6                	mv	s7,s1
      state = 0;
 53a:	4981                	li	s3,0
 53c:	b781                	j	47c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 53e:	008b8493          	addi	s1,s7,8
 542:	4681                	li	a3,0
 544:	4629                	li	a2,10
 546:	000bb583          	ld	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	e49ff0ef          	jal	394 <printint>
        i += 1;
 550:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 552:	8ba6                	mv	s7,s1
      state = 0;
 554:	4981                	li	s3,0
 556:	b71d                	j	47c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	008b8493          	addi	s1,s7,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000bb583          	ld	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e2fff0ef          	jal	394 <printint>
        i += 2;
 56a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	8ba6                	mv	s7,s1
      state = 0;
 56e:	4981                	li	s3,0
        i += 2;
 570:	b731                	j	47c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 572:	008b8493          	addi	s1,s7,8
 576:	4681                	li	a3,0
 578:	4641                	li	a2,16
 57a:	000be583          	lwu	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e15ff0ef          	jal	394 <printint>
 584:	8ba6                	mv	s7,s1
      state = 0;
 586:	4981                	li	s3,0
 588:	bdd5                	j	47c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4681                	li	a3,0
 590:	4641                	li	a2,16
 592:	000bb583          	ld	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	dfdff0ef          	jal	394 <printint>
        i += 1;
 59c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bde9                	j	47c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4641                	li	a2,16
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	de3ff0ef          	jal	394 <printint>
        i += 2;
 5b6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
        i += 2;
 5bc:	b5c1                	j	47c <vprintf+0x44>
 5be:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5c0:	008b8793          	addi	a5,s7,8
 5c4:	8cbe                	mv	s9,a5
 5c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ca:	03000593          	li	a1,48
 5ce:	855a                	mv	a0,s6
 5d0:	da7ff0ef          	jal	376 <putc>
  putc(fd, 'x');
 5d4:	07800593          	li	a1,120
 5d8:	855a                	mv	a0,s6
 5da:	d9dff0ef          	jal	376 <putc>
 5de:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e0:	00000b97          	auipc	s7,0x0
 5e4:	2f8b8b93          	addi	s7,s7,760 # 8d8 <digits>
 5e8:	03c9d793          	srli	a5,s3,0x3c
 5ec:	97de                	add	a5,a5,s7
 5ee:	0007c583          	lbu	a1,0(a5)
 5f2:	855a                	mv	a0,s6
 5f4:	d83ff0ef          	jal	376 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f8:	0992                	slli	s3,s3,0x4
 5fa:	34fd                	addiw	s1,s1,-1
 5fc:	f4f5                	bnez	s1,5e8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 5fe:	8be6                	mv	s7,s9
      state = 0;
 600:	4981                	li	s3,0
 602:	6ca2                	ld	s9,8(sp)
 604:	bda5                	j	47c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 606:	008b8493          	addi	s1,s7,8
 60a:	000bc583          	lbu	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	d67ff0ef          	jal	376 <putc>
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
 618:	b595                	j	47c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 61a:	008b8993          	addi	s3,s7,8
 61e:	000bb483          	ld	s1,0(s7)
 622:	cc91                	beqz	s1,63e <vprintf+0x206>
        for(; *s; s++)
 624:	0004c583          	lbu	a1,0(s1)
 628:	c985                	beqz	a1,658 <vprintf+0x220>
          putc(fd, *s);
 62a:	855a                	mv	a0,s6
 62c:	d4bff0ef          	jal	376 <putc>
        for(; *s; s++)
 630:	0485                	addi	s1,s1,1
 632:	0004c583          	lbu	a1,0(s1)
 636:	f9f5                	bnez	a1,62a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 638:	8bce                	mv	s7,s3
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b581                	j	47c <vprintf+0x44>
          s = "(null)";
 63e:	00000497          	auipc	s1,0x0
 642:	29248493          	addi	s1,s1,658 # 8d0 <malloc+0xf6>
        for(; *s; s++)
 646:	02800593          	li	a1,40
 64a:	b7c5                	j	62a <vprintf+0x1f2>
        putc(fd, '%');
 64c:	85be                	mv	a1,a5
 64e:	855a                	mv	a0,s6
 650:	d27ff0ef          	jal	376 <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	b51d                	j	47c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 658:	8bce                	mv	s7,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b505                	j	47c <vprintf+0x44>
 65e:	6906                	ld	s2,64(sp)
 660:	79e2                	ld	s3,56(sp)
 662:	7a42                	ld	s4,48(sp)
 664:	7aa2                	ld	s5,40(sp)
 666:	7b02                	ld	s6,32(sp)
 668:	6be2                	ld	s7,24(sp)
 66a:	6c42                	ld	s8,16(sp)
    }
  }
}
 66c:	60e6                	ld	ra,88(sp)
 66e:	6446                	ld	s0,80(sp)
 670:	64a6                	ld	s1,72(sp)
 672:	6125                	addi	sp,sp,96
 674:	8082                	ret
      if(c0 == 'd'){
 676:	06400713          	li	a4,100
 67a:	e4e78fe3          	beq	a5,a4,4d8 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 67e:	f9478693          	addi	a3,a5,-108
 682:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 686:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 688:	4701                	li	a4,0
      } else if(c0 == 'u'){
 68a:	07500513          	li	a0,117
 68e:	e8a78ce3          	beq	a5,a0,526 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 692:	f8b60513          	addi	a0,a2,-117
 696:	e119                	bnez	a0,69c <vprintf+0x264>
 698:	ea0693e3          	bnez	a3,53e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 69c:	f8b58513          	addi	a0,a1,-117
 6a0:	e119                	bnez	a0,6a6 <vprintf+0x26e>
 6a2:	ea071be3          	bnez	a4,558 <vprintf+0x120>
      } else if(c0 == 'x'){
 6a6:	07800513          	li	a0,120
 6aa:	eca784e3          	beq	a5,a0,572 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6ae:	f8860613          	addi	a2,a2,-120
 6b2:	e219                	bnez	a2,6b8 <vprintf+0x280>
 6b4:	ec069be3          	bnez	a3,58a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b8:	f8858593          	addi	a1,a1,-120
 6bc:	e199                	bnez	a1,6c2 <vprintf+0x28a>
 6be:	ee0713e3          	bnez	a4,5a4 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6c2:	07000713          	li	a4,112
 6c6:	eee78ce3          	beq	a5,a4,5be <vprintf+0x186>
      } else if(c0 == 'c'){
 6ca:	06300713          	li	a4,99
 6ce:	f2e78ce3          	beq	a5,a4,606 <vprintf+0x1ce>
      } else if(c0 == 's'){
 6d2:	07300713          	li	a4,115
 6d6:	f4e782e3          	beq	a5,a4,61a <vprintf+0x1e2>
      } else if(c0 == '%'){
 6da:	02500713          	li	a4,37
 6de:	f6e787e3          	beq	a5,a4,64c <vprintf+0x214>
        putc(fd, '%');
 6e2:	02500593          	li	a1,37
 6e6:	855a                	mv	a0,s6
 6e8:	c8fff0ef          	jal	376 <putc>
        putc(fd, c0);
 6ec:	85a6                	mv	a1,s1
 6ee:	855a                	mv	a0,s6
 6f0:	c87ff0ef          	jal	376 <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b359                	j	47c <vprintf+0x44>

00000000000006f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f8:	715d                	addi	sp,sp,-80
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e010                	sd	a2,0(s0)
 702:	e414                	sd	a3,8(s0)
 704:	e818                	sd	a4,16(s0)
 706:	ec1c                	sd	a5,24(s0)
 708:	03043023          	sd	a6,32(s0)
 70c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	8622                	mv	a2,s0
 712:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 716:	d23ff0ef          	jal	438 <vprintf>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6161                	addi	sp,sp,80
 720:	8082                	ret

0000000000000722 <printf>:

void
printf(const char *fmt, ...)
{
 722:	711d                	addi	sp,sp,-96
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e40c                	sd	a1,8(s0)
 72c:	e810                	sd	a2,16(s0)
 72e:	ec14                	sd	a3,24(s0)
 730:	f018                	sd	a4,32(s0)
 732:	f41c                	sd	a5,40(s0)
 734:	03043823          	sd	a6,48(s0)
 738:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73c:	00840613          	addi	a2,s0,8
 740:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 744:	85aa                	mv	a1,a0
 746:	4505                	li	a0,1
 748:	cf1ff0ef          	jal	438 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret

0000000000000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	1141                	addi	sp,sp,-16
 756:	e406                	sd	ra,8(sp)
 758:	e022                	sd	s0,0(sp)
 75a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	00001797          	auipc	a5,0x1
 764:	8a07b783          	ld	a5,-1888(a5) # 1000 <freep>
 768:	a039                	j	776 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	6398                	ld	a4,0(a5)
 76c:	00e7e463          	bltu	a5,a4,774 <free+0x20>
 770:	00e6ea63          	bltu	a3,a4,784 <free+0x30>
{
 774:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	fed7fae3          	bgeu	a5,a3,76a <free+0x16>
 77a:	6398                	ld	a4,0(a5)
 77c:	00e6e463          	bltu	a3,a4,784 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	fee7eae3          	bltu	a5,a4,774 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 784:	ff852583          	lw	a1,-8(a0)
 788:	6390                	ld	a2,0(a5)
 78a:	02059813          	slli	a6,a1,0x20
 78e:	01c85713          	srli	a4,a6,0x1c
 792:	9736                	add	a4,a4,a3
 794:	02e60563          	beq	a2,a4,7be <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 79c:	4790                	lw	a2,8(a5)
 79e:	02061593          	slli	a1,a2,0x20
 7a2:	01c5d713          	srli	a4,a1,0x1c
 7a6:	973e                	add	a4,a4,a5
 7a8:	02e68263          	beq	a3,a4,7cc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ae:	00001717          	auipc	a4,0x1
 7b2:	84f73923          	sd	a5,-1966(a4) # 1000 <freep>
}
 7b6:	60a2                	ld	ra,8(sp)
 7b8:	6402                	ld	s0,0(sp)
 7ba:	0141                	addi	sp,sp,16
 7bc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7be:	4618                	lw	a4,8(a2)
 7c0:	9f2d                	addw	a4,a4,a1
 7c2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	6398                	ld	a4,0(a5)
 7c8:	6310                	ld	a2,0(a4)
 7ca:	b7f9                	j	798 <free+0x44>
    p->s.size += bp->s.size;
 7cc:	ff852703          	lw	a4,-8(a0)
 7d0:	9f31                	addw	a4,a4,a2
 7d2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d4:	ff053683          	ld	a3,-16(a0)
 7d8:	bfd1                	j	7ac <free+0x58>

00000000000007da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7da:	7139                	addi	sp,sp,-64
 7dc:	fc06                	sd	ra,56(sp)
 7de:	f822                	sd	s0,48(sp)
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	ec4e                	sd	s3,24(sp)
 7e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e6:	02051993          	slli	s3,a0,0x20
 7ea:	0209d993          	srli	s3,s3,0x20
 7ee:	09bd                	addi	s3,s3,15
 7f0:	0049d993          	srli	s3,s3,0x4
 7f4:	2985                	addiw	s3,s3,1
 7f6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f8:	00001517          	auipc	a0,0x1
 7fc:	80853503          	ld	a0,-2040(a0) # 1000 <freep>
 800:	c905                	beqz	a0,830 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	09377663          	bgeu	a4,s3,892 <malloc+0xb8>
 80a:	f426                	sd	s1,40(sp)
 80c:	e852                	sd	s4,16(sp)
 80e:	e456                	sd	s5,8(sp)
 810:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 812:	8a4e                	mv	s4,s3
 814:	6705                	lui	a4,0x1
 816:	00e9f363          	bgeu	s3,a4,81c <malloc+0x42>
 81a:	6a05                	lui	s4,0x1
 81c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 820:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 824:	00000497          	auipc	s1,0x0
 828:	7dc48493          	addi	s1,s1,2012 # 1000 <freep>
  if(p == SBRK_ERROR)
 82c:	5afd                	li	s5,-1
 82e:	a83d                	j	86c <malloc+0x92>
 830:	f426                	sd	s1,40(sp)
 832:	e852                	sd	s4,16(sp)
 834:	e456                	sd	s5,8(sp)
 836:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 838:	00000797          	auipc	a5,0x0
 83c:	7d878793          	addi	a5,a5,2008 # 1010 <base>
 840:	00000717          	auipc	a4,0x0
 844:	7cf73023          	sd	a5,1984(a4) # 1000 <freep>
 848:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84e:	b7d1                	j	812 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	e118                	sd	a4,0(a0)
 854:	a899                	j	8aa <malloc+0xd0>
  hp->s.size = nu;
 856:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85a:	0541                	addi	a0,a0,16
 85c:	ef9ff0ef          	jal	754 <free>
  return freep;
 860:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 862:	c125                	beqz	a0,8c2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 864:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 866:	4798                	lw	a4,8(a5)
 868:	03277163          	bgeu	a4,s2,88a <malloc+0xb0>
    if(p == freep)
 86c:	6098                	ld	a4,0(s1)
 86e:	853e                	mv	a0,a5
 870:	fef71ae3          	bne	a4,a5,864 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 874:	8552                	mv	a0,s4
 876:	a2dff0ef          	jal	2a2 <sbrk>
  if(p == SBRK_ERROR)
 87a:	fd551ee3          	bne	a0,s5,856 <malloc+0x7c>
        return 0;
 87e:	4501                	li	a0,0
 880:	74a2                	ld	s1,40(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	a03d                	j	8b6 <malloc+0xdc>
 88a:	74a2                	ld	s1,40(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 892:	fae90fe3          	beq	s2,a4,850 <malloc+0x76>
        p->s.size -= nunits;
 896:	4137073b          	subw	a4,a4,s3
 89a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89c:	02071693          	slli	a3,a4,0x20
 8a0:	01c6d713          	srli	a4,a3,0x1c
 8a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74a73b23          	sd	a0,1878(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b2:	01078513          	addi	a0,a5,16
  }
}
 8b6:	70e2                	ld	ra,56(sp)
 8b8:	7442                	ld	s0,48(sp)
 8ba:	7902                	ld	s2,32(sp)
 8bc:	69e2                	ld	s3,24(sp)
 8be:	6121                	addi	sp,sp,64
 8c0:	8082                	ret
 8c2:	74a2                	ld	s1,40(sp)
 8c4:	6a42                	ld	s4,16(sp)
 8c6:	6aa2                	ld	s5,8(sp)
 8c8:	6b02                	ld	s6,0(sp)
 8ca:	b7f5                	j	8b6 <malloc+0xdc>
