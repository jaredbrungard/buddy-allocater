
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	8fcb0b13          	addi	s6,s6,-1796 # 930 <malloc+0xf8>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	310000ef          	jal	354 <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	08a000ef          	jal	de <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	2f6000ef          	jal	354 <write>
    if(i + 1 < argc){
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	8d058593          	addi	a1,a1,-1840 # 938 <malloc+0x100>
  70:	8532                	mv	a0,a2
  72:	2e2000ef          	jal	354 <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	2bc000ef          	jal	334 <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  extern int main();
  main();
  84:	f7dff0ef          	jal	0 <main>
  exit(0);
  88:	4501                	li	a0,0
  8a:	2aa000ef          	jal	334 <exit>

000000000000008e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  96:	87aa                	mv	a5,a0
  98:	0585                	addi	a1,a1,1
  9a:	0785                	addi	a5,a5,1
  9c:	fff5c703          	lbu	a4,-1(a1)
  a0:	fee78fa3          	sb	a4,-1(a5)
  a4:	fb75                	bnez	a4,98 <strcpy+0xa>
    ;
  return os;
}
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x20>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x20>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strlen>:

uint
strlen(const char *s)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e406                	sd	ra,8(sp)
  e2:	e022                	sd	s0,0(sp)
  e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cf91                	beqz	a5,106 <strlen+0x28>
  ec:	00150793          	addi	a5,a0,1
  f0:	86be                	mv	a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	ff65                	bnez	a4,f0 <strlen+0x12>
  fa:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret
  for(n = 0; s[n]; n++)
 106:	4501                	li	a0,0
 108:	bfdd                	j	fe <strlen+0x20>

000000000000010a <memset>:

void*
memset(void *dst, int c, uint n)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ca19                	beqz	a2,128 <memset+0x1e>
 114:	87aa                	mv	a5,a0
 116:	1602                	slli	a2,a2,0x20
 118:	9201                	srli	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x14>
  }
  return dst;
}
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e406                	sd	ra,8(sp)
 134:	e022                	sd	s0,0(sp)
 136:	0800                	addi	s0,sp,16
  for(; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf81                	beqz	a5,154 <strchr+0x24>
    if(*s == c)
 13e:	00f58763          	beq	a1,a5,14c <strchr+0x1c>
  for(; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	fbfd                	bnez	a5,13e <strchr+0xe>
      return (char*)s;
  return 0;
 14a:	4501                	li	a0,0
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfdd                	j	14c <strchr+0x1c>

0000000000000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	711d                	addi	sp,sp,-96
 15a:	ec86                	sd	ra,88(sp)
 15c:	e8a2                	sd	s0,80(sp)
 15e:	e4a6                	sd	s1,72(sp)
 160:	e0ca                	sd	s2,64(sp)
 162:	fc4e                	sd	s3,56(sp)
 164:	f852                	sd	s4,48(sp)
 166:	f456                	sd	s5,40(sp)
 168:	f05a                	sd	s6,32(sp)
 16a:	ec5e                	sd	s7,24(sp)
 16c:	e862                	sd	s8,16(sp)
 16e:	1080                	addi	s0,sp,96
 170:	8baa                	mv	s7,a0
 172:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	892a                	mv	s2,a0
 176:	4481                	li	s1,0
    cc = read(0, &c, 1);
 178:	faf40b13          	addi	s6,s0,-81
 17c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 17e:	8c26                	mv	s8,s1
 180:	0014899b          	addiw	s3,s1,1
 184:	84ce                	mv	s1,s3
 186:	0349d463          	bge	s3,s4,1ae <gets+0x56>
    cc = read(0, &c, 1);
 18a:	8656                	mv	a2,s5
 18c:	85da                	mv	a1,s6
 18e:	4501                	li	a0,0
 190:	1bc000ef          	jal	34c <read>
    if(cc < 1)
 194:	00a05d63          	blez	a0,1ae <gets+0x56>
      break;
    buf[i++] = c;
 198:	faf44783          	lbu	a5,-81(s0)
 19c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a0:	0905                	addi	s2,s2,1
 1a2:	ff678713          	addi	a4,a5,-10
 1a6:	c319                	beqz	a4,1ac <gets+0x54>
 1a8:	17cd                	addi	a5,a5,-13
 1aa:	fbf1                	bnez	a5,17e <gets+0x26>
    buf[i++] = c;
 1ac:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ae:	9c5e                	add	s8,s8,s7
 1b0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b4:	855e                	mv	a0,s7
 1b6:	60e6                	ld	ra,88(sp)
 1b8:	6446                	ld	s0,80(sp)
 1ba:	64a6                	ld	s1,72(sp)
 1bc:	6906                	ld	s2,64(sp)
 1be:	79e2                	ld	s3,56(sp)
 1c0:	7a42                	ld	s4,48(sp)
 1c2:	7aa2                	ld	s5,40(sp)
 1c4:	7b02                	ld	s6,32(sp)
 1c6:	6be2                	ld	s7,24(sp)
 1c8:	6c42                	ld	s8,16(sp)
 1ca:	6125                	addi	sp,sp,96
 1cc:	8082                	ret

00000000000001ce <stat>:

int
stat(const char *n, struct stat *st)
{
 1ce:	1101                	addi	sp,sp,-32
 1d0:	ec06                	sd	ra,24(sp)
 1d2:	e822                	sd	s0,16(sp)
 1d4:	e04a                	sd	s2,0(sp)
 1d6:	1000                	addi	s0,sp,32
 1d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1da:	4581                	li	a1,0
 1dc:	198000ef          	jal	374 <open>
  if(fd < 0)
 1e0:	02054263          	bltz	a0,204 <stat+0x36>
 1e4:	e426                	sd	s1,8(sp)
 1e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e8:	85ca                	mv	a1,s2
 1ea:	1a2000ef          	jal	38c <fstat>
 1ee:	892a                	mv	s2,a0
  close(fd);
 1f0:	8526                	mv	a0,s1
 1f2:	16a000ef          	jal	35c <close>
  return r;
 1f6:	64a2                	ld	s1,8(sp)
}
 1f8:	854a                	mv	a0,s2
 1fa:	60e2                	ld	ra,24(sp)
 1fc:	6442                	ld	s0,16(sp)
 1fe:	6902                	ld	s2,0(sp)
 200:	6105                	addi	sp,sp,32
 202:	8082                	ret
    return -1;
 204:	57fd                	li	a5,-1
 206:	893e                	mv	s2,a5
 208:	bfc5                	j	1f8 <stat+0x2a>

000000000000020a <atoi>:

int
atoi(const char *s)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e406                	sd	ra,8(sp)
 20e:	e022                	sd	s0,0(sp)
 210:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 212:	00054683          	lbu	a3,0(a0)
 216:	fd06879b          	addiw	a5,a3,-48
 21a:	0ff7f793          	zext.b	a5,a5
 21e:	4625                	li	a2,9
 220:	02f66963          	bltu	a2,a5,252 <atoi+0x48>
 224:	872a                	mv	a4,a0
  n = 0;
 226:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 228:	0705                	addi	a4,a4,1
 22a:	0025179b          	slliw	a5,a0,0x2
 22e:	9fa9                	addw	a5,a5,a0
 230:	0017979b          	slliw	a5,a5,0x1
 234:	9fb5                	addw	a5,a5,a3
 236:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 23a:	00074683          	lbu	a3,0(a4)
 23e:	fd06879b          	addiw	a5,a3,-48
 242:	0ff7f793          	zext.b	a5,a5
 246:	fef671e3          	bgeu	a2,a5,228 <atoi+0x1e>
  return n;
}
 24a:	60a2                	ld	ra,8(sp)
 24c:	6402                	ld	s0,0(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret
  n = 0;
 252:	4501                	li	a0,0
 254:	bfdd                	j	24a <atoi+0x40>

0000000000000256 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25e:	02b57563          	bgeu	a0,a1,288 <memmove+0x32>
    while(n-- > 0)
 262:	00c05f63          	blez	a2,280 <memmove+0x2a>
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26e:	872a                	mv	a4,a0
      *dst++ = *src++;
 270:	0585                	addi	a1,a1,1
 272:	0705                	addi	a4,a4,1
 274:	fff5c683          	lbu	a3,-1(a1)
 278:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27c:	fee79ae3          	bne	a5,a4,270 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
    while(n-- > 0)
 288:	fec05ce3          	blez	a2,280 <memmove+0x2a>
    dst += n;
 28c:	00c50733          	add	a4,a0,a2
    src += n;
 290:	95b2                	add	a1,a1,a2
 292:	fff6079b          	addiw	a5,a2,-1
 296:	1782                	slli	a5,a5,0x20
 298:	9381                	srli	a5,a5,0x20
 29a:	fff7c793          	not	a5,a5
 29e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a0:	15fd                	addi	a1,a1,-1
 2a2:	177d                	addi	a4,a4,-1
 2a4:	0005c683          	lbu	a3,0(a1)
 2a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ac:	fef71ae3          	bne	a4,a5,2a0 <memmove+0x4a>
 2b0:	bfc1                	j	280 <memmove+0x2a>

00000000000002b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ba:	c61d                	beqz	a2,2e8 <memcmp+0x36>
 2bc:	1602                	slli	a2,a2,0x20
 2be:	9201                	srli	a2,a2,0x20
 2c0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00e79863          	bne	a5,a4,2dc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2d0:	0505                	addi	a0,a0,1
    p2++;
 2d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d4:	fed518e3          	bne	a0,a3,2c4 <memcmp+0x12>
  }
  return 0;
 2d8:	4501                	li	a0,0
 2da:	a019                	j	2e0 <memcmp+0x2e>
      return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	bfdd                	j	2e0 <memcmp+0x2e>

00000000000002ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f4:	f63ff0ef          	jal	256 <memmove>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <sbrk>:

char *
sbrk(int n) {
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 308:	4585                	li	a1,1
 30a:	0b2000ef          	jal	3bc <sys_sbrk>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <sbrklazy>:

char *
sbrklazy(int n) {
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 31e:	4589                	li	a1,2
 320:	09c000ef          	jal	3bc <sys_sbrk>
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32c:	4885                	li	a7,1
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exit>:
.global exit
exit:
 li a7, SYS_exit
 334:	4889                	li	a7,2
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <wait>:
.global wait
wait:
 li a7, SYS_wait
 33c:	488d                	li	a7,3
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 344:	4891                	li	a7,4
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <read>:
.global read
read:
 li a7, SYS_read
 34c:	4895                	li	a7,5
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <write>:
.global write
write:
 li a7, SYS_write
 354:	48c1                	li	a7,16
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <close>:
.global close
close:
 li a7, SYS_close
 35c:	48d5                	li	a7,21
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <kill>:
.global kill
kill:
 li a7, SYS_kill
 364:	4899                	li	a7,6
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exec>:
.global exec
exec:
 li a7, SYS_exec
 36c:	489d                	li	a7,7
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <open>:
.global open
open:
 li a7, SYS_open
 374:	48bd                	li	a7,15
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37c:	48c5                	li	a7,17
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 384:	48c9                	li	a7,18
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38c:	48a1                	li	a7,8
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <link>:
.global link
link:
 li a7, SYS_link
 394:	48cd                	li	a7,19
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39c:	48d1                	li	a7,20
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a4:	48a5                	li	a7,9
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ac:	48a9                	li	a7,10
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b4:	48ad                	li	a7,11
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3bc:	48b1                	li	a7,12
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c4:	48b5                	li	a7,13
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3cc:	48b9                	li	a7,14
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d4:	1101                	addi	sp,sp,-32
 3d6:	ec06                	sd	ra,24(sp)
 3d8:	e822                	sd	s0,16(sp)
 3da:	1000                	addi	s0,sp,32
 3dc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e0:	4605                	li	a2,1
 3e2:	fef40593          	addi	a1,s0,-17
 3e6:	f6fff0ef          	jal	354 <write>
}
 3ea:	60e2                	ld	ra,24(sp)
 3ec:	6442                	ld	s0,16(sp)
 3ee:	6105                	addi	sp,sp,32
 3f0:	8082                	ret

00000000000003f2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3f2:	715d                	addi	sp,sp,-80
 3f4:	e486                	sd	ra,72(sp)
 3f6:	e0a2                	sd	s0,64(sp)
 3f8:	f84a                	sd	s2,48(sp)
 3fa:	f44e                	sd	s3,40(sp)
 3fc:	0880                	addi	s0,sp,80
 3fe:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 400:	cac1                	beqz	a3,490 <printint+0x9e>
 402:	0805d763          	bgez	a1,490 <printint+0x9e>
    neg = 1;
    x = -xx;
 406:	40b005bb          	negw	a1,a1
    neg = 1;
 40a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 40c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 410:	86ce                	mv	a3,s3
  i = 0;
 412:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 414:	00000817          	auipc	a6,0x0
 418:	53480813          	addi	a6,a6,1332 # 948 <digits>
 41c:	88ba                	mv	a7,a4
 41e:	0017051b          	addiw	a0,a4,1
 422:	872a                	mv	a4,a0
 424:	02c5f7bb          	remuw	a5,a1,a2
 428:	1782                	slli	a5,a5,0x20
 42a:	9381                	srli	a5,a5,0x20
 42c:	97c2                	add	a5,a5,a6
 42e:	0007c783          	lbu	a5,0(a5)
 432:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 436:	87ae                	mv	a5,a1
 438:	02c5d5bb          	divuw	a1,a1,a2
 43c:	0685                	addi	a3,a3,1
 43e:	fcc7ffe3          	bgeu	a5,a2,41c <printint+0x2a>
  if(neg)
 442:	00030c63          	beqz	t1,45a <printint+0x68>
    buf[i++] = '-';
 446:	fd050793          	addi	a5,a0,-48
 44a:	00878533          	add	a0,a5,s0
 44e:	02d00793          	li	a5,45
 452:	fef50423          	sb	a5,-24(a0)
 456:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 45a:	02e05563          	blez	a4,484 <printint+0x92>
 45e:	fc26                	sd	s1,56(sp)
 460:	377d                	addiw	a4,a4,-1
 462:	00e984b3          	add	s1,s3,a4
 466:	19fd                	addi	s3,s3,-1
 468:	99ba                	add	s3,s3,a4
 46a:	1702                	slli	a4,a4,0x20
 46c:	9301                	srli	a4,a4,0x20
 46e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 472:	0004c583          	lbu	a1,0(s1)
 476:	854a                	mv	a0,s2
 478:	f5dff0ef          	jal	3d4 <putc>
  while(--i >= 0)
 47c:	14fd                	addi	s1,s1,-1
 47e:	ff349ae3          	bne	s1,s3,472 <printint+0x80>
 482:	74e2                	ld	s1,56(sp)
}
 484:	60a6                	ld	ra,72(sp)
 486:	6406                	ld	s0,64(sp)
 488:	7942                	ld	s2,48(sp)
 48a:	79a2                	ld	s3,40(sp)
 48c:	6161                	addi	sp,sp,80
 48e:	8082                	ret
    x = xx;
 490:	2581                	sext.w	a1,a1
  neg = 0;
 492:	4301                	li	t1,0
 494:	bfa5                	j	40c <printint+0x1a>

0000000000000496 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 496:	711d                	addi	sp,sp,-96
 498:	ec86                	sd	ra,88(sp)
 49a:	e8a2                	sd	s0,80(sp)
 49c:	e4a6                	sd	s1,72(sp)
 49e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a0:	0005c483          	lbu	s1,0(a1)
 4a4:	22048363          	beqz	s1,6ca <vprintf+0x234>
 4a8:	e0ca                	sd	s2,64(sp)
 4aa:	fc4e                	sd	s3,56(sp)
 4ac:	f852                	sd	s4,48(sp)
 4ae:	f456                	sd	s5,40(sp)
 4b0:	f05a                	sd	s6,32(sp)
 4b2:	ec5e                	sd	s7,24(sp)
 4b4:	e862                	sd	s8,16(sp)
 4b6:	8b2a                	mv	s6,a0
 4b8:	8a2e                	mv	s4,a1
 4ba:	8bb2                	mv	s7,a2
  state = 0;
 4bc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4be:	4901                	li	s2,0
 4c0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c6:	06400c13          	li	s8,100
 4ca:	a00d                	j	4ec <vprintf+0x56>
        putc(fd, c0);
 4cc:	85a6                	mv	a1,s1
 4ce:	855a                	mv	a0,s6
 4d0:	f05ff0ef          	jal	3d4 <putc>
 4d4:	a019                	j	4da <vprintf+0x44>
    } else if(state == '%'){
 4d6:	03598363          	beq	s3,s5,4fc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4da:	0019079b          	addiw	a5,s2,1
 4de:	893e                	mv	s2,a5
 4e0:	873e                	mv	a4,a5
 4e2:	97d2                	add	a5,a5,s4
 4e4:	0007c483          	lbu	s1,0(a5)
 4e8:	1c048a63          	beqz	s1,6bc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4ec:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4f0:	fe0993e3          	bnez	s3,4d6 <vprintf+0x40>
      if(c0 == '%'){
 4f4:	fd579ce3          	bne	a5,s5,4cc <vprintf+0x36>
        state = '%';
 4f8:	89be                	mv	s3,a5
 4fa:	b7c5                	j	4da <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fc:	00ea06b3          	add	a3,s4,a4
 500:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 504:	1c060863          	beqz	a2,6d4 <vprintf+0x23e>
      if(c0 == 'd'){
 508:	03878763          	beq	a5,s8,536 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	f9478693          	addi	a3,a5,-108
 510:	0016b693          	seqz	a3,a3
 514:	f9c60593          	addi	a1,a2,-100
 518:	e99d                	bnez	a1,54e <vprintf+0xb8>
 51a:	ca95                	beqz	a3,54e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 51c:	008b8493          	addi	s1,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000bb583          	ld	a1,0(s7)
 528:	855a                	mv	a0,s6
 52a:	ec9ff0ef          	jal	3f2 <printint>
        i += 1;
 52e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 530:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 532:	4981                	li	s3,0
 534:	b75d                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 536:	008b8493          	addi	s1,s7,8
 53a:	4685                	li	a3,1
 53c:	4629                	li	a2,10
 53e:	000ba583          	lw	a1,0(s7)
 542:	855a                	mv	a0,s6
 544:	eafff0ef          	jal	3f2 <printint>
 548:	8ba6                	mv	s7,s1
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b779                	j	4da <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 54e:	9752                	add	a4,a4,s4
 550:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 554:	f9460713          	addi	a4,a2,-108
 558:	00173713          	seqz	a4,a4
 55c:	8f75                	and	a4,a4,a3
 55e:	f9c58513          	addi	a0,a1,-100
 562:	18051363          	bnez	a0,6e8 <vprintf+0x252>
 566:	18070163          	beqz	a4,6e8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	008b8493          	addi	s1,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000bb583          	ld	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e7bff0ef          	jal	3f2 <printint>
        i += 2;
 57c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	8ba6                	mv	s7,s1
      state = 0;
 580:	4981                	li	s3,0
        i += 2;
 582:	bfa1                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 584:	008b8493          	addi	s1,s7,8
 588:	4681                	li	a3,0
 58a:	4629                	li	a2,10
 58c:	000be583          	lwu	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	e61ff0ef          	jal	3f2 <printint>
 596:	8ba6                	mv	s7,s1
      state = 0;
 598:	4981                	li	s3,0
 59a:	b781                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4629                	li	a2,10
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e49ff0ef          	jal	3f2 <printint>
        i += 1;
 5ae:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b71d                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e2fff0ef          	jal	3f2 <printint>
        i += 2;
 5c8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	b731                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4641                	li	a2,16
 5d8:	000be583          	lwu	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e15ff0ef          	jal	3f2 <printint>
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bdd5                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	dfdff0ef          	jal	3f2 <printint>
        i += 1;
 5fa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bde9                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	de3ff0ef          	jal	3f2 <printint>
        i += 2;
 614:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	b5c1                	j	4da <vprintf+0x44>
 61c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 61e:	008b8793          	addi	a5,s7,8
 622:	8cbe                	mv	s9,a5
 624:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 628:	03000593          	li	a1,48
 62c:	855a                	mv	a0,s6
 62e:	da7ff0ef          	jal	3d4 <putc>
  putc(fd, 'x');
 632:	07800593          	li	a1,120
 636:	855a                	mv	a0,s6
 638:	d9dff0ef          	jal	3d4 <putc>
 63c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00000b97          	auipc	s7,0x0
 642:	30ab8b93          	addi	s7,s7,778 # 948 <digits>
 646:	03c9d793          	srli	a5,s3,0x3c
 64a:	97de                	add	a5,a5,s7
 64c:	0007c583          	lbu	a1,0(a5)
 650:	855a                	mv	a0,s6
 652:	d83ff0ef          	jal	3d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 656:	0992                	slli	s3,s3,0x4
 658:	34fd                	addiw	s1,s1,-1
 65a:	f4f5                	bnez	s1,646 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 65c:	8be6                	mv	s7,s9
      state = 0;
 65e:	4981                	li	s3,0
 660:	6ca2                	ld	s9,8(sp)
 662:	bda5                	j	4da <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 664:	008b8493          	addi	s1,s7,8
 668:	000bc583          	lbu	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d67ff0ef          	jal	3d4 <putc>
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
 676:	b595                	j	4da <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 678:	008b8993          	addi	s3,s7,8
 67c:	000bb483          	ld	s1,0(s7)
 680:	cc91                	beqz	s1,69c <vprintf+0x206>
        for(; *s; s++)
 682:	0004c583          	lbu	a1,0(s1)
 686:	c985                	beqz	a1,6b6 <vprintf+0x220>
          putc(fd, *s);
 688:	855a                	mv	a0,s6
 68a:	d4bff0ef          	jal	3d4 <putc>
        for(; *s; s++)
 68e:	0485                	addi	s1,s1,1
 690:	0004c583          	lbu	a1,0(s1)
 694:	f9f5                	bnez	a1,688 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 696:	8bce                	mv	s7,s3
      state = 0;
 698:	4981                	li	s3,0
 69a:	b581                	j	4da <vprintf+0x44>
          s = "(null)";
 69c:	00000497          	auipc	s1,0x0
 6a0:	2a448493          	addi	s1,s1,676 # 940 <malloc+0x108>
        for(; *s; s++)
 6a4:	02800593          	li	a1,40
 6a8:	b7c5                	j	688 <vprintf+0x1f2>
        putc(fd, '%');
 6aa:	85be                	mv	a1,a5
 6ac:	855a                	mv	a0,s6
 6ae:	d27ff0ef          	jal	3d4 <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b51d                	j	4da <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b505                	j	4da <vprintf+0x44>
 6bc:	6906                	ld	s2,64(sp)
 6be:	79e2                	ld	s3,56(sp)
 6c0:	7a42                	ld	s4,48(sp)
 6c2:	7aa2                	ld	s5,40(sp)
 6c4:	7b02                	ld	s6,32(sp)
 6c6:	6be2                	ld	s7,24(sp)
 6c8:	6c42                	ld	s8,16(sp)
    }
  }
}
 6ca:	60e6                	ld	ra,88(sp)
 6cc:	6446                	ld	s0,80(sp)
 6ce:	64a6                	ld	s1,72(sp)
 6d0:	6125                	addi	sp,sp,96
 6d2:	8082                	ret
      if(c0 == 'd'){
 6d4:	06400713          	li	a4,100
 6d8:	e4e78fe3          	beq	a5,a4,536 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6dc:	f9478693          	addi	a3,a5,-108
 6e0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6e4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6e8:	07500513          	li	a0,117
 6ec:	e8a78ce3          	beq	a5,a0,584 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6f0:	f8b60513          	addi	a0,a2,-117
 6f4:	e119                	bnez	a0,6fa <vprintf+0x264>
 6f6:	ea0693e3          	bnez	a3,59c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6fa:	f8b58513          	addi	a0,a1,-117
 6fe:	e119                	bnez	a0,704 <vprintf+0x26e>
 700:	ea071be3          	bnez	a4,5b6 <vprintf+0x120>
      } else if(c0 == 'x'){
 704:	07800513          	li	a0,120
 708:	eca784e3          	beq	a5,a0,5d0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 70c:	f8860613          	addi	a2,a2,-120
 710:	e219                	bnez	a2,716 <vprintf+0x280>
 712:	ec069be3          	bnez	a3,5e8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 716:	f8858593          	addi	a1,a1,-120
 71a:	e199                	bnez	a1,720 <vprintf+0x28a>
 71c:	ee0713e3          	bnez	a4,602 <vprintf+0x16c>
      } else if(c0 == 'p'){
 720:	07000713          	li	a4,112
 724:	eee78ce3          	beq	a5,a4,61c <vprintf+0x186>
      } else if(c0 == 'c'){
 728:	06300713          	li	a4,99
 72c:	f2e78ce3          	beq	a5,a4,664 <vprintf+0x1ce>
      } else if(c0 == 's'){
 730:	07300713          	li	a4,115
 734:	f4e782e3          	beq	a5,a4,678 <vprintf+0x1e2>
      } else if(c0 == '%'){
 738:	02500713          	li	a4,37
 73c:	f6e787e3          	beq	a5,a4,6aa <vprintf+0x214>
        putc(fd, '%');
 740:	02500593          	li	a1,37
 744:	855a                	mv	a0,s6
 746:	c8fff0ef          	jal	3d4 <putc>
        putc(fd, c0);
 74a:	85a6                	mv	a1,s1
 74c:	855a                	mv	a0,s6
 74e:	c87ff0ef          	jal	3d4 <putc>
      state = 0;
 752:	4981                	li	s3,0
 754:	b359                	j	4da <vprintf+0x44>

0000000000000756 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 756:	715d                	addi	sp,sp,-80
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e010                	sd	a2,0(s0)
 760:	e414                	sd	a3,8(s0)
 762:	e818                	sd	a4,16(s0)
 764:	ec1c                	sd	a5,24(s0)
 766:	03043023          	sd	a6,32(s0)
 76a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	8622                	mv	a2,s0
 770:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 774:	d23ff0ef          	jal	496 <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6161                	addi	sp,sp,80
 77e:	8082                	ret

0000000000000780 <printf>:

void
printf(const char *fmt, ...)
{
 780:	711d                	addi	sp,sp,-96
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e40c                	sd	a1,8(s0)
 78a:	e810                	sd	a2,16(s0)
 78c:	ec14                	sd	a3,24(s0)
 78e:	f018                	sd	a4,32(s0)
 790:	f41c                	sd	a5,40(s0)
 792:	03043823          	sd	a6,48(s0)
 796:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	00840613          	addi	a2,s0,8
 79e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a2:	85aa                	mv	a1,a0
 7a4:	4505                	li	a0,1
 7a6:	cf1ff0ef          	jal	496 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e406                	sd	ra,8(sp)
 7b6:	e022                	sd	s0,0(sp)
 7b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	00001797          	auipc	a5,0x1
 7c2:	8427b783          	ld	a5,-1982(a5) # 1000 <freep>
 7c6:	a039                	j	7d4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e7e463          	bltu	a5,a4,7d2 <free+0x20>
 7ce:	00e6ea63          	bltu	a3,a4,7e2 <free+0x30>
{
 7d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	fed7fae3          	bgeu	a5,a3,7c8 <free+0x16>
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e6e463          	bltu	a3,a4,7e2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	fee7eae3          	bltu	a5,a4,7d2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e2:	ff852583          	lw	a1,-8(a0)
 7e6:	6390                	ld	a2,0(a5)
 7e8:	02059813          	slli	a6,a1,0x20
 7ec:	01c85713          	srli	a4,a6,0x1c
 7f0:	9736                	add	a4,a4,a3
 7f2:	02e60563          	beq	a2,a4,81c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7fa:	4790                	lw	a2,8(a5)
 7fc:	02061593          	slli	a1,a2,0x20
 800:	01c5d713          	srli	a4,a1,0x1c
 804:	973e                	add	a4,a4,a5
 806:	02e68263          	beq	a3,a4,82a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 80a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80c:	00000717          	auipc	a4,0x0
 810:	7ef73a23          	sd	a5,2036(a4) # 1000 <freep>
}
 814:	60a2                	ld	ra,8(sp)
 816:	6402                	ld	s0,0(sp)
 818:	0141                	addi	sp,sp,16
 81a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 81c:	4618                	lw	a4,8(a2)
 81e:	9f2d                	addw	a4,a4,a1
 820:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	6310                	ld	a2,0(a4)
 828:	b7f9                	j	7f6 <free+0x44>
    p->s.size += bp->s.size;
 82a:	ff852703          	lw	a4,-8(a0)
 82e:	9f31                	addw	a4,a4,a2
 830:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 832:	ff053683          	ld	a3,-16(a0)
 836:	bfd1                	j	80a <free+0x58>

0000000000000838 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 838:	7139                	addi	sp,sp,-64
 83a:	fc06                	sd	ra,56(sp)
 83c:	f822                	sd	s0,48(sp)
 83e:	f04a                	sd	s2,32(sp)
 840:	ec4e                	sd	s3,24(sp)
 842:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	02051993          	slli	s3,a0,0x20
 848:	0209d993          	srli	s3,s3,0x20
 84c:	09bd                	addi	s3,s3,15
 84e:	0049d993          	srli	s3,s3,0x4
 852:	2985                	addiw	s3,s3,1
 854:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 856:	00000517          	auipc	a0,0x0
 85a:	7aa53503          	ld	a0,1962(a0) # 1000 <freep>
 85e:	c905                	beqz	a0,88e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 862:	4798                	lw	a4,8(a5)
 864:	09377663          	bgeu	a4,s3,8f0 <malloc+0xb8>
 868:	f426                	sd	s1,40(sp)
 86a:	e852                	sd	s4,16(sp)
 86c:	e456                	sd	s5,8(sp)
 86e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 870:	8a4e                	mv	s4,s3
 872:	6705                	lui	a4,0x1
 874:	00e9f363          	bgeu	s3,a4,87a <malloc+0x42>
 878:	6a05                	lui	s4,0x1
 87a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 882:	00000497          	auipc	s1,0x0
 886:	77e48493          	addi	s1,s1,1918 # 1000 <freep>
  if(p == SBRK_ERROR)
 88a:	5afd                	li	s5,-1
 88c:	a83d                	j	8ca <malloc+0x92>
 88e:	f426                	sd	s1,40(sp)
 890:	e852                	sd	s4,16(sp)
 892:	e456                	sd	s5,8(sp)
 894:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 896:	00000797          	auipc	a5,0x0
 89a:	77a78793          	addi	a5,a5,1914 # 1010 <base>
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73123          	sd	a5,1890(a4) # 1000 <freep>
 8a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ac:	b7d1                	j	870 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	e118                	sd	a4,0(a0)
 8b2:	a899                	j	908 <malloc+0xd0>
  hp->s.size = nu;
 8b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b8:	0541                	addi	a0,a0,16
 8ba:	ef9ff0ef          	jal	7b2 <free>
  return freep;
 8be:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8c0:	c125                	beqz	a0,920 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	03277163          	bgeu	a4,s2,8e8 <malloc+0xb0>
    if(p == freep)
 8ca:	6098                	ld	a4,0(s1)
 8cc:	853e                	mv	a0,a5
 8ce:	fef71ae3          	bne	a4,a5,8c2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d2:	8552                	mv	a0,s4
 8d4:	a2dff0ef          	jal	300 <sbrk>
  if(p == SBRK_ERROR)
 8d8:	fd551ee3          	bne	a0,s5,8b4 <malloc+0x7c>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	74a2                	ld	s1,40(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	a03d                	j	914 <malloc+0xdc>
 8e8:	74a2                	ld	s1,40(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f0:	fae90fe3          	beq	s2,a4,8ae <malloc+0x76>
        p->s.size -= nunits;
 8f4:	4137073b          	subw	a4,a4,s3
 8f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fa:	02071693          	slli	a3,a4,0x20
 8fe:	01c6d713          	srli	a4,a3,0x1c
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00000717          	auipc	a4,0x0
 90c:	6ea73c23          	sd	a0,1784(a4) # 1000 <freep>
      return (void*)(p + 1);
 910:	01078513          	addi	a0,a5,16
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	7902                	ld	s2,32(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6121                	addi	sp,sp,64
 91e:	8082                	ret
 920:	74a2                	ld	s1,40(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
 928:	b7f5                	j	914 <malloc+0xdc>
