
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	90058593          	addi	a1,a1,-1792 # 910 <malloc+0xfe>
  18:	4509                	li	a0,2
  1a:	716000ef          	jal	730 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e6000ef          	jal	306 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	33a000ef          	jal	366 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2d0000ef          	jal	306 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8ea58593          	addi	a1,a1,-1814 # 928 <malloc+0x116>
  46:	4509                	li	a0,2
  48:	6e8000ef          	jal	730 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  extern int main();
  main();
  56:	fabff0ef          	jal	0 <main>
  exit(0);
  5a:	4501                	li	a0,0
  5c:	2aa000ef          	jal	306 <exit>

0000000000000060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e406                	sd	ra,8(sp)
  64:	e022                	sd	s0,0(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0xa>
    ;
  return os;
}
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x20>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x20>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	60a2                	ld	ra,8(sp)
  aa:	6402                	ld	s0,0(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strlen>:

uint
strlen(const char *s)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	cf91                	beqz	a5,d8 <strlen+0x28>
  be:	00150793          	addi	a5,a0,1
  c2:	86be                	mv	a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	ff65                	bnez	a4,c2 <strlen+0x12>
  cc:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  for(n = 0; s[n]; n++)
  d8:	4501                	li	a0,0
  da:	bfdd                	j	d0 <strlen+0x20>

00000000000000dc <memset>:

void*
memset(void *dst, int c, uint n)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1e>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x14>
  }
  return dst;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf81                	beqz	a5,126 <strchr+0x24>
    if(*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1c>
  for(; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xe>
      return (char*)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret
  return 0;
 126:	4501                	li	a0,0
 128:	bfdd                	j	11e <strchr+0x1c>

000000000000012a <gets>:

char*
gets(char *buf, int max)
{
 12a:	711d                	addi	sp,sp,-96
 12c:	ec86                	sd	ra,88(sp)
 12e:	e8a2                	sd	s0,80(sp)
 130:	e4a6                	sd	s1,72(sp)
 132:	e0ca                	sd	s2,64(sp)
 134:	fc4e                	sd	s3,56(sp)
 136:	f852                	sd	s4,48(sp)
 138:	f456                	sd	s5,40(sp)
 13a:	f05a                	sd	s6,32(sp)
 13c:	ec5e                	sd	s7,24(sp)
 13e:	e862                	sd	s8,16(sp)
 140:	1080                	addi	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14a:	faf40b13          	addi	s6,s0,-81
 14e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 150:	8c26                	mv	s8,s1
 152:	0014899b          	addiw	s3,s1,1
 156:	84ce                	mv	s1,s3
 158:	0349d463          	bge	s3,s4,180 <gets+0x56>
    cc = read(0, &c, 1);
 15c:	8656                	mv	a2,s5
 15e:	85da                	mv	a1,s6
 160:	4501                	li	a0,0
 162:	1bc000ef          	jal	31e <read>
    if(cc < 1)
 166:	00a05d63          	blez	a0,180 <gets+0x56>
      break;
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	0905                	addi	s2,s2,1
 174:	ff678713          	addi	a4,a5,-10
 178:	c319                	beqz	a4,17e <gets+0x54>
 17a:	17cd                	addi	a5,a5,-13
 17c:	fbf1                	bnez	a5,150 <gets+0x26>
    buf[i++] = c;
 17e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 180:	9c5e                	add	s8,s8,s7
 182:	000c0023          	sb	zero,0(s8)
  return buf;
}
 186:	855e                	mv	a0,s7
 188:	60e6                	ld	ra,88(sp)
 18a:	6446                	ld	s0,80(sp)
 18c:	64a6                	ld	s1,72(sp)
 18e:	6906                	ld	s2,64(sp)
 190:	79e2                	ld	s3,56(sp)
 192:	7a42                	ld	s4,48(sp)
 194:	7aa2                	ld	s5,40(sp)
 196:	7b02                	ld	s6,32(sp)
 198:	6be2                	ld	s7,24(sp)
 19a:	6c42                	ld	s8,16(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e04a                	sd	s2,0(sp)
 1a8:	1000                	addi	s0,sp,32
 1aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ac:	4581                	li	a1,0
 1ae:	198000ef          	jal	346 <open>
  if(fd < 0)
 1b2:	02054263          	bltz	a0,1d6 <stat+0x36>
 1b6:	e426                	sd	s1,8(sp)
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	1a2000ef          	jal	35e <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	16a000ef          	jal	32e <close>
  return r;
 1c8:	64a2                	ld	s1,8(sp)
}
 1ca:	854a                	mv	a0,s2
 1cc:	60e2                	ld	ra,24(sp)
 1ce:	6442                	ld	s0,16(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	57fd                	li	a5,-1
 1d8:	893e                	mv	s2,a5
 1da:	bfc5                	j	1ca <stat+0x2a>

00000000000001dc <atoi>:

int
atoi(const char *s)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e406                	sd	ra,8(sp)
 1e0:	e022                	sd	s0,0(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e4:	00054683          	lbu	a3,0(a0)
 1e8:	fd06879b          	addiw	a5,a3,-48
 1ec:	0ff7f793          	zext.b	a5,a5
 1f0:	4625                	li	a2,9
 1f2:	02f66963          	bltu	a2,a5,224 <atoi+0x48>
 1f6:	872a                	mv	a4,a0
  n = 0;
 1f8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1fa:	0705                	addi	a4,a4,1
 1fc:	0025179b          	slliw	a5,a0,0x2
 200:	9fa9                	addw	a5,a5,a0
 202:	0017979b          	slliw	a5,a5,0x1
 206:	9fb5                	addw	a5,a5,a3
 208:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20c:	00074683          	lbu	a3,0(a4)
 210:	fd06879b          	addiw	a5,a3,-48
 214:	0ff7f793          	zext.b	a5,a5
 218:	fef671e3          	bgeu	a2,a5,1fa <atoi+0x1e>
  return n;
}
 21c:	60a2                	ld	ra,8(sp)
 21e:	6402                	ld	s0,0(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  n = 0;
 224:	4501                	li	a0,0
 226:	bfdd                	j	21c <atoi+0x40>

0000000000000228 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 230:	02b57563          	bgeu	a0,a1,25a <memmove+0x32>
    while(n-- > 0)
 234:	00c05f63          	blez	a2,252 <memmove+0x2a>
 238:	1602                	slli	a2,a2,0x20
 23a:	9201                	srli	a2,a2,0x20
 23c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 240:	872a                	mv	a4,a0
      *dst++ = *src++;
 242:	0585                	addi	a1,a1,1
 244:	0705                	addi	a4,a4,1
 246:	fff5c683          	lbu	a3,-1(a1)
 24a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24e:	fee79ae3          	bne	a5,a4,242 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 252:	60a2                	ld	ra,8(sp)
 254:	6402                	ld	s0,0(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret
    while(n-- > 0)
 25a:	fec05ce3          	blez	a2,252 <memmove+0x2a>
    dst += n;
 25e:	00c50733          	add	a4,a0,a2
    src += n;
 262:	95b2                	add	a1,a1,a2
 264:	fff6079b          	addiw	a5,a2,-1
 268:	1782                	slli	a5,a5,0x20
 26a:	9381                	srli	a5,a5,0x20
 26c:	fff7c793          	not	a5,a5
 270:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 272:	15fd                	addi	a1,a1,-1
 274:	177d                	addi	a4,a4,-1
 276:	0005c683          	lbu	a3,0(a1)
 27a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27e:	fef71ae3          	bne	a4,a5,272 <memmove+0x4a>
 282:	bfc1                	j	252 <memmove+0x2a>

0000000000000284 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28c:	c61d                	beqz	a2,2ba <memcmp+0x36>
 28e:	1602                	slli	a2,a2,0x20
 290:	9201                	srli	a2,a2,0x20
 292:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 296:	00054783          	lbu	a5,0(a0)
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00e79863          	bne	a5,a4,2ae <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a2:	0505                	addi	a0,a0,1
    p2++;
 2a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a6:	fed518e3          	bne	a0,a3,296 <memcmp+0x12>
  }
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	a019                	j	2b2 <memcmp+0x2e>
      return *p1 - *p2;
 2ae:	40e7853b          	subw	a0,a5,a4
}
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
  return 0;
 2ba:	4501                	li	a0,0
 2bc:	bfdd                	j	2b2 <memcmp+0x2e>

00000000000002be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c6:	f63ff0ef          	jal	228 <memmove>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <sbrk>:

char *
sbrk(int n) {
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2da:	4585                	li	a1,1
 2dc:	0b2000ef          	jal	38e <sys_sbrk>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrklazy>:

char *
sbrklazy(int n) {
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f0:	4589                	li	a1,2
 2f2:	09c000ef          	jal	38e <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fe:	4885                	li	a7,1
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <exit>:
.global exit
exit:
 li a7, SYS_exit
 306:	4889                	li	a7,2
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <wait>:
.global wait
wait:
 li a7, SYS_wait
 30e:	488d                	li	a7,3
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 316:	4891                	li	a7,4
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <read>:
.global read
read:
 li a7, SYS_read
 31e:	4895                	li	a7,5
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <write>:
.global write
write:
 li a7, SYS_write
 326:	48c1                	li	a7,16
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <close>:
.global close
close:
 li a7, SYS_close
 32e:	48d5                	li	a7,21
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <kill>:
.global kill
kill:
 li a7, SYS_kill
 336:	4899                	li	a7,6
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <exec>:
.global exec
exec:
 li a7, SYS_exec
 33e:	489d                	li	a7,7
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <open>:
.global open
open:
 li a7, SYS_open
 346:	48bd                	li	a7,15
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34e:	48c5                	li	a7,17
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 356:	48c9                	li	a7,18
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35e:	48a1                	li	a7,8
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <link>:
.global link
link:
 li a7, SYS_link
 366:	48cd                	li	a7,19
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36e:	48d1                	li	a7,20
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 376:	48a5                	li	a7,9
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <dup>:
.global dup
dup:
 li a7, SYS_dup
 37e:	48a9                	li	a7,10
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 386:	48ad                	li	a7,11
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38e:	48b1                	li	a7,12
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <pause>:
.global pause
pause:
 li a7, SYS_pause
 396:	48b5                	li	a7,13
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39e:	48b9                	li	a7,14
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 3a6:	48d9                	li	a7,22
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ae:	1101                	addi	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	fef40593          	addi	a1,s0,-17
 3c0:	f67ff0ef          	jal	326 <write>
}
 3c4:	60e2                	ld	ra,24(sp)
 3c6:	6442                	ld	s0,16(sp)
 3c8:	6105                	addi	sp,sp,32
 3ca:	8082                	ret

00000000000003cc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3cc:	715d                	addi	sp,sp,-80
 3ce:	e486                	sd	ra,72(sp)
 3d0:	e0a2                	sd	s0,64(sp)
 3d2:	f84a                	sd	s2,48(sp)
 3d4:	f44e                	sd	s3,40(sp)
 3d6:	0880                	addi	s0,sp,80
 3d8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	cac1                	beqz	a3,46a <printint+0x9e>
 3dc:	0805d763          	bgez	a1,46a <printint+0x9e>
    neg = 1;
    x = -xx;
 3e0:	40b005bb          	negw	a1,a1
    neg = 1;
 3e4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3e6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3ea:	86ce                	mv	a3,s3
  i = 0;
 3ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ee:	00000817          	auipc	a6,0x0
 3f2:	55a80813          	addi	a6,a6,1370 # 948 <digits>
 3f6:	88ba                	mv	a7,a4
 3f8:	0017051b          	addiw	a0,a4,1
 3fc:	872a                	mv	a4,a0
 3fe:	02c5f7bb          	remuw	a5,a1,a2
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	97c2                	add	a5,a5,a6
 408:	0007c783          	lbu	a5,0(a5)
 40c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 410:	87ae                	mv	a5,a1
 412:	02c5d5bb          	divuw	a1,a1,a2
 416:	0685                	addi	a3,a3,1
 418:	fcc7ffe3          	bgeu	a5,a2,3f6 <printint+0x2a>
  if(neg)
 41c:	00030c63          	beqz	t1,434 <printint+0x68>
    buf[i++] = '-';
 420:	fd050793          	addi	a5,a0,-48
 424:	00878533          	add	a0,a5,s0
 428:	02d00793          	li	a5,45
 42c:	fef50423          	sb	a5,-24(a0)
 430:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 434:	02e05563          	blez	a4,45e <printint+0x92>
 438:	fc26                	sd	s1,56(sp)
 43a:	377d                	addiw	a4,a4,-1
 43c:	00e984b3          	add	s1,s3,a4
 440:	19fd                	addi	s3,s3,-1
 442:	99ba                	add	s3,s3,a4
 444:	1702                	slli	a4,a4,0x20
 446:	9301                	srli	a4,a4,0x20
 448:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44c:	0004c583          	lbu	a1,0(s1)
 450:	854a                	mv	a0,s2
 452:	f5dff0ef          	jal	3ae <putc>
  while(--i >= 0)
 456:	14fd                	addi	s1,s1,-1
 458:	ff349ae3          	bne	s1,s3,44c <printint+0x80>
 45c:	74e2                	ld	s1,56(sp)
}
 45e:	60a6                	ld	ra,72(sp)
 460:	6406                	ld	s0,64(sp)
 462:	7942                	ld	s2,48(sp)
 464:	79a2                	ld	s3,40(sp)
 466:	6161                	addi	sp,sp,80
 468:	8082                	ret
    x = xx;
 46a:	2581                	sext.w	a1,a1
  neg = 0;
 46c:	4301                	li	t1,0
 46e:	bfa5                	j	3e6 <printint+0x1a>

0000000000000470 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 470:	711d                	addi	sp,sp,-96
 472:	ec86                	sd	ra,88(sp)
 474:	e8a2                	sd	s0,80(sp)
 476:	e4a6                	sd	s1,72(sp)
 478:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47a:	0005c483          	lbu	s1,0(a1)
 47e:	22048363          	beqz	s1,6a4 <vprintf+0x234>
 482:	e0ca                	sd	s2,64(sp)
 484:	fc4e                	sd	s3,56(sp)
 486:	f852                	sd	s4,48(sp)
 488:	f456                	sd	s5,40(sp)
 48a:	f05a                	sd	s6,32(sp)
 48c:	ec5e                	sd	s7,24(sp)
 48e:	e862                	sd	s8,16(sp)
 490:	8b2a                	mv	s6,a0
 492:	8a2e                	mv	s4,a1
 494:	8bb2                	mv	s7,a2
  state = 0;
 496:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 498:	4901                	li	s2,0
 49a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 49c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a0:	06400c13          	li	s8,100
 4a4:	a00d                	j	4c6 <vprintf+0x56>
        putc(fd, c0);
 4a6:	85a6                	mv	a1,s1
 4a8:	855a                	mv	a0,s6
 4aa:	f05ff0ef          	jal	3ae <putc>
 4ae:	a019                	j	4b4 <vprintf+0x44>
    } else if(state == '%'){
 4b0:	03598363          	beq	s3,s5,4d6 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4b4:	0019079b          	addiw	a5,s2,1
 4b8:	893e                	mv	s2,a5
 4ba:	873e                	mv	a4,a5
 4bc:	97d2                	add	a5,a5,s4
 4be:	0007c483          	lbu	s1,0(a5)
 4c2:	1c048a63          	beqz	s1,696 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4c6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ca:	fe0993e3          	bnez	s3,4b0 <vprintf+0x40>
      if(c0 == '%'){
 4ce:	fd579ce3          	bne	a5,s5,4a6 <vprintf+0x36>
        state = '%';
 4d2:	89be                	mv	s3,a5
 4d4:	b7c5                	j	4b4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d6:	00ea06b3          	add	a3,s4,a4
 4da:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4de:	1c060863          	beqz	a2,6ae <vprintf+0x23e>
      if(c0 == 'd'){
 4e2:	03878763          	beq	a5,s8,510 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e6:	f9478693          	addi	a3,a5,-108
 4ea:	0016b693          	seqz	a3,a3
 4ee:	f9c60593          	addi	a1,a2,-100
 4f2:	e99d                	bnez	a1,528 <vprintf+0xb8>
 4f4:	ca95                	beqz	a3,528 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f6:	008b8493          	addi	s1,s7,8
 4fa:	4685                	li	a3,1
 4fc:	4629                	li	a2,10
 4fe:	000bb583          	ld	a1,0(s7)
 502:	855a                	mv	a0,s6
 504:	ec9ff0ef          	jal	3cc <printint>
        i += 1;
 508:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 50a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 50c:	4981                	li	s3,0
 50e:	b75d                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 510:	008b8493          	addi	s1,s7,8
 514:	4685                	li	a3,1
 516:	4629                	li	a2,10
 518:	000ba583          	lw	a1,0(s7)
 51c:	855a                	mv	a0,s6
 51e:	eafff0ef          	jal	3cc <printint>
 522:	8ba6                	mv	s7,s1
      state = 0;
 524:	4981                	li	s3,0
 526:	b779                	j	4b4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 528:	9752                	add	a4,a4,s4
 52a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52e:	f9460713          	addi	a4,a2,-108
 532:	00173713          	seqz	a4,a4
 536:	8f75                	and	a4,a4,a3
 538:	f9c58513          	addi	a0,a1,-100
 53c:	18051363          	bnez	a0,6c2 <vprintf+0x252>
 540:	18070163          	beqz	a4,6c2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 544:	008b8493          	addi	s1,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000bb583          	ld	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e7bff0ef          	jal	3cc <printint>
        i += 2;
 556:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 558:	8ba6                	mv	s7,s1
      state = 0;
 55a:	4981                	li	s3,0
        i += 2;
 55c:	bfa1                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 55e:	008b8493          	addi	s1,s7,8
 562:	4681                	li	a3,0
 564:	4629                	li	a2,10
 566:	000be583          	lwu	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	e61ff0ef          	jal	3cc <printint>
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
 574:	b781                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	008b8493          	addi	s1,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000bb583          	ld	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	e49ff0ef          	jal	3cc <printint>
        i += 1;
 588:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	8ba6                	mv	s7,s1
      state = 0;
 58c:	4981                	li	s3,0
 58e:	b71d                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	008b8493          	addi	s1,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000bb583          	ld	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e2fff0ef          	jal	3cc <printint>
        i += 2;
 5a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a4:	8ba6                	mv	s7,s1
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	b731                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4681                	li	a3,0
 5b0:	4641                	li	a2,16
 5b2:	000be583          	lwu	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e15ff0ef          	jal	3cc <printint>
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bdd5                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	dfdff0ef          	jal	3cc <printint>
        i += 1;
 5d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bde9                	j	4b4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5dc:	008b8493          	addi	s1,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4641                	li	a2,16
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	de3ff0ef          	jal	3cc <printint>
        i += 2;
 5ee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	8ba6                	mv	s7,s1
      state = 0;
 5f2:	4981                	li	s3,0
        i += 2;
 5f4:	b5c1                	j	4b4 <vprintf+0x44>
 5f6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5f8:	008b8793          	addi	a5,s7,8
 5fc:	8cbe                	mv	s9,a5
 5fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 602:	03000593          	li	a1,48
 606:	855a                	mv	a0,s6
 608:	da7ff0ef          	jal	3ae <putc>
  putc(fd, 'x');
 60c:	07800593          	li	a1,120
 610:	855a                	mv	a0,s6
 612:	d9dff0ef          	jal	3ae <putc>
 616:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 618:	00000b97          	auipc	s7,0x0
 61c:	330b8b93          	addi	s7,s7,816 # 948 <digits>
 620:	03c9d793          	srli	a5,s3,0x3c
 624:	97de                	add	a5,a5,s7
 626:	0007c583          	lbu	a1,0(a5)
 62a:	855a                	mv	a0,s6
 62c:	d83ff0ef          	jal	3ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 630:	0992                	slli	s3,s3,0x4
 632:	34fd                	addiw	s1,s1,-1
 634:	f4f5                	bnez	s1,620 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 636:	8be6                	mv	s7,s9
      state = 0;
 638:	4981                	li	s3,0
 63a:	6ca2                	ld	s9,8(sp)
 63c:	bda5                	j	4b4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 63e:	008b8493          	addi	s1,s7,8
 642:	000bc583          	lbu	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	d67ff0ef          	jal	3ae <putc>
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
 650:	b595                	j	4b4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 652:	008b8993          	addi	s3,s7,8
 656:	000bb483          	ld	s1,0(s7)
 65a:	cc91                	beqz	s1,676 <vprintf+0x206>
        for(; *s; s++)
 65c:	0004c583          	lbu	a1,0(s1)
 660:	c985                	beqz	a1,690 <vprintf+0x220>
          putc(fd, *s);
 662:	855a                	mv	a0,s6
 664:	d4bff0ef          	jal	3ae <putc>
        for(; *s; s++)
 668:	0485                	addi	s1,s1,1
 66a:	0004c583          	lbu	a1,0(s1)
 66e:	f9f5                	bnez	a1,662 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 670:	8bce                	mv	s7,s3
      state = 0;
 672:	4981                	li	s3,0
 674:	b581                	j	4b4 <vprintf+0x44>
          s = "(null)";
 676:	00000497          	auipc	s1,0x0
 67a:	2ca48493          	addi	s1,s1,714 # 940 <malloc+0x12e>
        for(; *s; s++)
 67e:	02800593          	li	a1,40
 682:	b7c5                	j	662 <vprintf+0x1f2>
        putc(fd, '%');
 684:	85be                	mv	a1,a5
 686:	855a                	mv	a0,s6
 688:	d27ff0ef          	jal	3ae <putc>
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b51d                	j	4b4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 690:	8bce                	mv	s7,s3
      state = 0;
 692:	4981                	li	s3,0
 694:	b505                	j	4b4 <vprintf+0x44>
 696:	6906                	ld	s2,64(sp)
 698:	79e2                	ld	s3,56(sp)
 69a:	7a42                	ld	s4,48(sp)
 69c:	7aa2                	ld	s5,40(sp)
 69e:	7b02                	ld	s6,32(sp)
 6a0:	6be2                	ld	s7,24(sp)
 6a2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6a4:	60e6                	ld	ra,88(sp)
 6a6:	6446                	ld	s0,80(sp)
 6a8:	64a6                	ld	s1,72(sp)
 6aa:	6125                	addi	sp,sp,96
 6ac:	8082                	ret
      if(c0 == 'd'){
 6ae:	06400713          	li	a4,100
 6b2:	e4e78fe3          	beq	a5,a4,510 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6b6:	f9478693          	addi	a3,a5,-108
 6ba:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6be:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c0:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6c2:	07500513          	li	a0,117
 6c6:	e8a78ce3          	beq	a5,a0,55e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6ca:	f8b60513          	addi	a0,a2,-117
 6ce:	e119                	bnez	a0,6d4 <vprintf+0x264>
 6d0:	ea0693e3          	bnez	a3,576 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6d4:	f8b58513          	addi	a0,a1,-117
 6d8:	e119                	bnez	a0,6de <vprintf+0x26e>
 6da:	ea071be3          	bnez	a4,590 <vprintf+0x120>
      } else if(c0 == 'x'){
 6de:	07800513          	li	a0,120
 6e2:	eca784e3          	beq	a5,a0,5aa <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6e6:	f8860613          	addi	a2,a2,-120
 6ea:	e219                	bnez	a2,6f0 <vprintf+0x280>
 6ec:	ec069be3          	bnez	a3,5c2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f0:	f8858593          	addi	a1,a1,-120
 6f4:	e199                	bnez	a1,6fa <vprintf+0x28a>
 6f6:	ee0713e3          	bnez	a4,5dc <vprintf+0x16c>
      } else if(c0 == 'p'){
 6fa:	07000713          	li	a4,112
 6fe:	eee78ce3          	beq	a5,a4,5f6 <vprintf+0x186>
      } else if(c0 == 'c'){
 702:	06300713          	li	a4,99
 706:	f2e78ce3          	beq	a5,a4,63e <vprintf+0x1ce>
      } else if(c0 == 's'){
 70a:	07300713          	li	a4,115
 70e:	f4e782e3          	beq	a5,a4,652 <vprintf+0x1e2>
      } else if(c0 == '%'){
 712:	02500713          	li	a4,37
 716:	f6e787e3          	beq	a5,a4,684 <vprintf+0x214>
        putc(fd, '%');
 71a:	02500593          	li	a1,37
 71e:	855a                	mv	a0,s6
 720:	c8fff0ef          	jal	3ae <putc>
        putc(fd, c0);
 724:	85a6                	mv	a1,s1
 726:	855a                	mv	a0,s6
 728:	c87ff0ef          	jal	3ae <putc>
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b359                	j	4b4 <vprintf+0x44>

0000000000000730 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 730:	715d                	addi	sp,sp,-80
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	addi	s0,sp,32
 738:	e010                	sd	a2,0(s0)
 73a:	e414                	sd	a3,8(s0)
 73c:	e818                	sd	a4,16(s0)
 73e:	ec1c                	sd	a5,24(s0)
 740:	03043023          	sd	a6,32(s0)
 744:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	8622                	mv	a2,s0
 74a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74e:	d23ff0ef          	jal	470 <vprintf>
}
 752:	60e2                	ld	ra,24(sp)
 754:	6442                	ld	s0,16(sp)
 756:	6161                	addi	sp,sp,80
 758:	8082                	ret

000000000000075a <printf>:

void
printf(const char *fmt, ...)
{
 75a:	711d                	addi	sp,sp,-96
 75c:	ec06                	sd	ra,24(sp)
 75e:	e822                	sd	s0,16(sp)
 760:	1000                	addi	s0,sp,32
 762:	e40c                	sd	a1,8(s0)
 764:	e810                	sd	a2,16(s0)
 766:	ec14                	sd	a3,24(s0)
 768:	f018                	sd	a4,32(s0)
 76a:	f41c                	sd	a5,40(s0)
 76c:	03043823          	sd	a6,48(s0)
 770:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	00840613          	addi	a2,s0,8
 778:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77c:	85aa                	mv	a1,a0
 77e:	4505                	li	a0,1
 780:	cf1ff0ef          	jal	470 <vprintf>
}
 784:	60e2                	ld	ra,24(sp)
 786:	6442                	ld	s0,16(sp)
 788:	6125                	addi	sp,sp,96
 78a:	8082                	ret

000000000000078c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78c:	1141                	addi	sp,sp,-16
 78e:	e406                	sd	ra,8(sp)
 790:	e022                	sd	s0,0(sp)
 792:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 794:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 798:	00001797          	auipc	a5,0x1
 79c:	8687b783          	ld	a5,-1944(a5) # 1000 <freep>
 7a0:	a039                	j	7ae <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a2:	6398                	ld	a4,0(a5)
 7a4:	00e7e463          	bltu	a5,a4,7ac <free+0x20>
 7a8:	00e6ea63          	bltu	a3,a4,7bc <free+0x30>
{
 7ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	fed7fae3          	bgeu	a5,a3,7a2 <free+0x16>
 7b2:	6398                	ld	a4,0(a5)
 7b4:	00e6e463          	bltu	a3,a4,7bc <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	fee7eae3          	bltu	a5,a4,7ac <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7bc:	ff852583          	lw	a1,-8(a0)
 7c0:	6390                	ld	a2,0(a5)
 7c2:	02059813          	slli	a6,a1,0x20
 7c6:	01c85713          	srli	a4,a6,0x1c
 7ca:	9736                	add	a4,a4,a3
 7cc:	02e60563          	beq	a2,a4,7f6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7d4:	4790                	lw	a2,8(a5)
 7d6:	02061593          	slli	a1,a2,0x20
 7da:	01c5d713          	srli	a4,a1,0x1c
 7de:	973e                	add	a4,a4,a5
 7e0:	02e68263          	beq	a3,a4,804 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e6:	00001717          	auipc	a4,0x1
 7ea:	80f73d23          	sd	a5,-2022(a4) # 1000 <freep>
}
 7ee:	60a2                	ld	ra,8(sp)
 7f0:	6402                	ld	s0,0(sp)
 7f2:	0141                	addi	sp,sp,16
 7f4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7f6:	4618                	lw	a4,8(a2)
 7f8:	9f2d                	addw	a4,a4,a1
 7fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	6398                	ld	a4,0(a5)
 800:	6310                	ld	a2,0(a4)
 802:	b7f9                	j	7d0 <free+0x44>
    p->s.size += bp->s.size;
 804:	ff852703          	lw	a4,-8(a0)
 808:	9f31                	addw	a4,a4,a2
 80a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80c:	ff053683          	ld	a3,-16(a0)
 810:	bfd1                	j	7e4 <free+0x58>

0000000000000812 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 812:	7139                	addi	sp,sp,-64
 814:	fc06                	sd	ra,56(sp)
 816:	f822                	sd	s0,48(sp)
 818:	f04a                	sd	s2,32(sp)
 81a:	ec4e                	sd	s3,24(sp)
 81c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81e:	02051993          	slli	s3,a0,0x20
 822:	0209d993          	srli	s3,s3,0x20
 826:	09bd                	addi	s3,s3,15
 828:	0049d993          	srli	s3,s3,0x4
 82c:	2985                	addiw	s3,s3,1
 82e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 830:	00000517          	auipc	a0,0x0
 834:	7d053503          	ld	a0,2000(a0) # 1000 <freep>
 838:	c905                	beqz	a0,868 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	09377663          	bgeu	a4,s3,8ca <malloc+0xb8>
 842:	f426                	sd	s1,40(sp)
 844:	e852                	sd	s4,16(sp)
 846:	e456                	sd	s5,8(sp)
 848:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 84a:	8a4e                	mv	s4,s3
 84c:	6705                	lui	a4,0x1
 84e:	00e9f363          	bgeu	s3,a4,854 <malloc+0x42>
 852:	6a05                	lui	s4,0x1
 854:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 858:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85c:	00000497          	auipc	s1,0x0
 860:	7a448493          	addi	s1,s1,1956 # 1000 <freep>
  if(p == SBRK_ERROR)
 864:	5afd                	li	s5,-1
 866:	a83d                	j	8a4 <malloc+0x92>
 868:	f426                	sd	s1,40(sp)
 86a:	e852                	sd	s4,16(sp)
 86c:	e456                	sd	s5,8(sp)
 86e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 870:	00000797          	auipc	a5,0x0
 874:	7a078793          	addi	a5,a5,1952 # 1010 <base>
 878:	00000717          	auipc	a4,0x0
 87c:	78f73423          	sd	a5,1928(a4) # 1000 <freep>
 880:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 882:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 886:	b7d1                	j	84a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 888:	6398                	ld	a4,0(a5)
 88a:	e118                	sd	a4,0(a0)
 88c:	a899                	j	8e2 <malloc+0xd0>
  hp->s.size = nu;
 88e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 892:	0541                	addi	a0,a0,16
 894:	ef9ff0ef          	jal	78c <free>
  return freep;
 898:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 89a:	c125                	beqz	a0,8fa <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89e:	4798                	lw	a4,8(a5)
 8a0:	03277163          	bgeu	a4,s2,8c2 <malloc+0xb0>
    if(p == freep)
 8a4:	6098                	ld	a4,0(s1)
 8a6:	853e                	mv	a0,a5
 8a8:	fef71ae3          	bne	a4,a5,89c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ac:	8552                	mv	a0,s4
 8ae:	a25ff0ef          	jal	2d2 <sbrk>
  if(p == SBRK_ERROR)
 8b2:	fd551ee3          	bne	a0,s5,88e <malloc+0x7c>
        return 0;
 8b6:	4501                	li	a0,0
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
 8c0:	a03d                	j	8ee <malloc+0xdc>
 8c2:	74a2                	ld	s1,40(sp)
 8c4:	6a42                	ld	s4,16(sp)
 8c6:	6aa2                	ld	s5,8(sp)
 8c8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ca:	fae90fe3          	beq	s2,a4,888 <malloc+0x76>
        p->s.size -= nunits;
 8ce:	4137073b          	subw	a4,a4,s3
 8d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d4:	02071693          	slli	a3,a4,0x20
 8d8:	01c6d713          	srli	a4,a3,0x1c
 8dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e2:	00000717          	auipc	a4,0x0
 8e6:	70a73f23          	sd	a0,1822(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ea:	01078513          	addi	a0,a5,16
  }
}
 8ee:	70e2                	ld	ra,56(sp)
 8f0:	7442                	ld	s0,48(sp)
 8f2:	7902                	ld	s2,32(sp)
 8f4:	69e2                	ld	s3,24(sp)
 8f6:	6121                	addi	sp,sp,64
 8f8:	8082                	ret
 8fa:	74a2                	ld	s1,40(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
 902:	b7f5                	j	8ee <malloc+0xdc>
