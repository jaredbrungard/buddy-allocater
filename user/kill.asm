
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1ba000ef          	jal	1e2 <atoi>
  2c:	310000ef          	jal	33c <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2d4000ef          	jal	30c <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8d058593          	addi	a1,a1,-1840 # 910 <malloc+0x100>
  48:	4509                	li	a0,2
  4a:	6e4000ef          	jal	72e <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2bc000ef          	jal	30c <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5c:	fa5ff0ef          	jal	0 <main>
  exit(0);
  60:	4501                	li	a0,0
  62:	2aa000ef          	jal	30c <exit>

0000000000000066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	87aa                	mv	a5,a0
  70:	0585                	addi	a1,a1,1
  72:	0785                	addi	a5,a5,1
  74:	fff5c703          	lbu	a4,-1(a1)
  78:	fee78fa3          	sb	a4,-1(a5)
  7c:	fb75                	bnez	a4,70 <strcpy+0xa>
    ;
  return os;
}
  7e:	60a2                	ld	ra,8(sp)
  80:	6402                	ld	s0,0(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret

0000000000000086 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  86:	1141                	addi	sp,sp,-16
  88:	e406                	sd	ra,8(sp)
  8a:	e022                	sd	s0,0(sp)
  8c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cb91                	beqz	a5,a6 <strcmp+0x20>
  94:	0005c703          	lbu	a4,0(a1)
  98:	00f71763          	bne	a4,a5,a6 <strcmp+0x20>
    p++, q++;
  9c:	0505                	addi	a0,a0,1
  9e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	fbe5                	bnez	a5,94 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a6:	0005c503          	lbu	a0,0(a1)
}
  aa:	40a7853b          	subw	a0,a5,a0
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strlen>:

uint
strlen(const char *s)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e406                	sd	ra,8(sp)
  ba:	e022                	sd	s0,0(sp)
  bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cf91                	beqz	a5,de <strlen+0x28>
  c4:	00150793          	addi	a5,a0,1
  c8:	86be                	mv	a3,a5
  ca:	0785                	addi	a5,a5,1
  cc:	fff7c703          	lbu	a4,-1(a5)
  d0:	ff65                	bnez	a4,c8 <strlen+0x12>
  d2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  for(n = 0; s[n]; n++)
  de:	4501                	li	a0,0
  e0:	bfdd                	j	d6 <strlen+0x20>

00000000000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ea:	ca19                	beqz	a2,100 <memset+0x1e>
  ec:	87aa                	mv	a5,a0
  ee:	1602                	slli	a2,a2,0x20
  f0:	9201                	srli	a2,a2,0x20
  f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fa:	0785                	addi	a5,a5,1
  fc:	fee79de3          	bne	a5,a4,f6 <memset+0x14>
  }
  return dst;
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cf81                	beqz	a5,12c <strchr+0x24>
    if(*s == c)
 116:	00f58763          	beq	a1,a5,124 <strchr+0x1c>
  for(; *s; s++)
 11a:	0505                	addi	a0,a0,1
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbfd                	bnez	a5,116 <strchr+0xe>
      return (char*)s;
  return 0;
 122:	4501                	li	a0,0
}
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfdd                	j	124 <strchr+0x1c>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	e862                	sd	s8,16(sp)
 146:	1080                	addi	s0,sp,96
 148:	8baa                	mv	s7,a0
 14a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	892a                	mv	s2,a0
 14e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 150:	faf40b13          	addi	s6,s0,-81
 154:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 156:	8c26                	mv	s8,s1
 158:	0014899b          	addiw	s3,s1,1
 15c:	84ce                	mv	s1,s3
 15e:	0349d463          	bge	s3,s4,186 <gets+0x56>
    cc = read(0, &c, 1);
 162:	8656                	mv	a2,s5
 164:	85da                	mv	a1,s6
 166:	4501                	li	a0,0
 168:	1bc000ef          	jal	324 <read>
    if(cc < 1)
 16c:	00a05d63          	blez	a0,186 <gets+0x56>
      break;
    buf[i++] = c;
 170:	faf44783          	lbu	a5,-81(s0)
 174:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 178:	0905                	addi	s2,s2,1
 17a:	ff678713          	addi	a4,a5,-10
 17e:	c319                	beqz	a4,184 <gets+0x54>
 180:	17cd                	addi	a5,a5,-13
 182:	fbf1                	bnez	a5,156 <gets+0x26>
    buf[i++] = c;
 184:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 186:	9c5e                	add	s8,s8,s7
 188:	000c0023          	sb	zero,0(s8)
  return buf;
}
 18c:	855e                	mv	a0,s7
 18e:	60e6                	ld	ra,88(sp)
 190:	6446                	ld	s0,80(sp)
 192:	64a6                	ld	s1,72(sp)
 194:	6906                	ld	s2,64(sp)
 196:	79e2                	ld	s3,56(sp)
 198:	7a42                	ld	s4,48(sp)
 19a:	7aa2                	ld	s5,40(sp)
 19c:	7b02                	ld	s6,32(sp)
 19e:	6be2                	ld	s7,24(sp)
 1a0:	6c42                	ld	s8,16(sp)
 1a2:	6125                	addi	sp,sp,96
 1a4:	8082                	ret

00000000000001a6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a6:	1101                	addi	sp,sp,-32
 1a8:	ec06                	sd	ra,24(sp)
 1aa:	e822                	sd	s0,16(sp)
 1ac:	e04a                	sd	s2,0(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	4581                	li	a1,0
 1b4:	198000ef          	jal	34c <open>
  if(fd < 0)
 1b8:	02054263          	bltz	a0,1dc <stat+0x36>
 1bc:	e426                	sd	s1,8(sp)
 1be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c0:	85ca                	mv	a1,s2
 1c2:	1a2000ef          	jal	364 <fstat>
 1c6:	892a                	mv	s2,a0
  close(fd);
 1c8:	8526                	mv	a0,s1
 1ca:	16a000ef          	jal	334 <close>
  return r;
 1ce:	64a2                	ld	s1,8(sp)
}
 1d0:	854a                	mv	a0,s2
 1d2:	60e2                	ld	ra,24(sp)
 1d4:	6442                	ld	s0,16(sp)
 1d6:	6902                	ld	s2,0(sp)
 1d8:	6105                	addi	sp,sp,32
 1da:	8082                	ret
    return -1;
 1dc:	57fd                	li	a5,-1
 1de:	893e                	mv	s2,a5
 1e0:	bfc5                	j	1d0 <stat+0x2a>

00000000000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e406                	sd	ra,8(sp)
 1e6:	e022                	sd	s0,0(sp)
 1e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ea:	00054683          	lbu	a3,0(a0)
 1ee:	fd06879b          	addiw	a5,a3,-48
 1f2:	0ff7f793          	zext.b	a5,a5
 1f6:	4625                	li	a2,9
 1f8:	02f66963          	bltu	a2,a5,22a <atoi+0x48>
 1fc:	872a                	mv	a4,a0
  n = 0;
 1fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 200:	0705                	addi	a4,a4,1
 202:	0025179b          	slliw	a5,a0,0x2
 206:	9fa9                	addw	a5,a5,a0
 208:	0017979b          	slliw	a5,a5,0x1
 20c:	9fb5                	addw	a5,a5,a3
 20e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 212:	00074683          	lbu	a3,0(a4)
 216:	fd06879b          	addiw	a5,a3,-48
 21a:	0ff7f793          	zext.b	a5,a5
 21e:	fef671e3          	bgeu	a2,a5,200 <atoi+0x1e>
  return n;
}
 222:	60a2                	ld	ra,8(sp)
 224:	6402                	ld	s0,0(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  n = 0;
 22a:	4501                	li	a0,0
 22c:	bfdd                	j	222 <atoi+0x40>

000000000000022e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 236:	02b57563          	bgeu	a0,a1,260 <memmove+0x32>
    while(n-- > 0)
 23a:	00c05f63          	blez	a2,258 <memmove+0x2a>
 23e:	1602                	slli	a2,a2,0x20
 240:	9201                	srli	a2,a2,0x20
 242:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 246:	872a                	mv	a4,a0
      *dst++ = *src++;
 248:	0585                	addi	a1,a1,1
 24a:	0705                	addi	a4,a4,1
 24c:	fff5c683          	lbu	a3,-1(a1)
 250:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 254:	fee79ae3          	bne	a5,a4,248 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
    while(n-- > 0)
 260:	fec05ce3          	blez	a2,258 <memmove+0x2a>
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
 26a:	fff6079b          	addiw	a5,a2,-1
 26e:	1782                	slli	a5,a5,0x20
 270:	9381                	srli	a5,a5,0x20
 272:	fff7c793          	not	a5,a5
 276:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 278:	15fd                	addi	a1,a1,-1
 27a:	177d                	addi	a4,a4,-1
 27c:	0005c683          	lbu	a3,0(a1)
 280:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 284:	fef71ae3          	bne	a4,a5,278 <memmove+0x4a>
 288:	bfc1                	j	258 <memmove+0x2a>

000000000000028a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	c61d                	beqz	a2,2c0 <memcmp+0x36>
 294:	1602                	slli	a2,a2,0x20
 296:	9201                	srli	a2,a2,0x20
 298:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00e79863          	bne	a5,a4,2b4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a8:	0505                	addi	a0,a0,1
    p2++;
 2aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ac:	fed518e3          	bne	a0,a3,29c <memcmp+0x12>
  }
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	a019                	j	2b8 <memcmp+0x2e>
      return *p1 - *p2;
 2b4:	40e7853b          	subw	a0,a5,a4
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	bfdd                	j	2b8 <memcmp+0x2e>

00000000000002c4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2cc:	f63ff0ef          	jal	22e <memmove>
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <sbrk>:

char *
sbrk(int n) {
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e0:	4585                	li	a1,1
 2e2:	0b2000ef          	jal	394 <sys_sbrk>
}
 2e6:	60a2                	ld	ra,8(sp)
 2e8:	6402                	ld	s0,0(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <sbrklazy>:

char *
sbrklazy(int n) {
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e406                	sd	ra,8(sp)
 2f2:	e022                	sd	s0,0(sp)
 2f4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f6:	4589                	li	a1,2
 2f8:	09c000ef          	jal	394 <sys_sbrk>
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret

0000000000000304 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 304:	4885                	li	a7,1
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exit>:
.global exit
exit:
 li a7, SYS_exit
 30c:	4889                	li	a7,2
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <wait>:
.global wait
wait:
 li a7, SYS_wait
 314:	488d                	li	a7,3
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31c:	4891                	li	a7,4
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <read>:
.global read
read:
 li a7, SYS_read
 324:	4895                	li	a7,5
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <write>:
.global write
write:
 li a7, SYS_write
 32c:	48c1                	li	a7,16
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <close>:
.global close
close:
 li a7, SYS_close
 334:	48d5                	li	a7,21
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <kill>:
.global kill
kill:
 li a7, SYS_kill
 33c:	4899                	li	a7,6
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <exec>:
.global exec
exec:
 li a7, SYS_exec
 344:	489d                	li	a7,7
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <open>:
.global open
open:
 li a7, SYS_open
 34c:	48bd                	li	a7,15
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 354:	48c5                	li	a7,17
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35c:	48c9                	li	a7,18
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 364:	48a1                	li	a7,8
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <link>:
.global link
link:
 li a7, SYS_link
 36c:	48cd                	li	a7,19
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 374:	48d1                	li	a7,20
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37c:	48a5                	li	a7,9
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <dup>:
.global dup
dup:
 li a7, SYS_dup
 384:	48a9                	li	a7,10
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38c:	48ad                	li	a7,11
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 394:	48b1                	li	a7,12
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <pause>:
.global pause
pause:
 li a7, SYS_pause
 39c:	48b5                	li	a7,13
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a4:	48b9                	li	a7,14
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	f6fff0ef          	jal	32c <write>
}
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret

00000000000003ca <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ca:	715d                	addi	sp,sp,-80
 3cc:	e486                	sd	ra,72(sp)
 3ce:	e0a2                	sd	s0,64(sp)
 3d0:	f84a                	sd	s2,48(sp)
 3d2:	f44e                	sd	s3,40(sp)
 3d4:	0880                	addi	s0,sp,80
 3d6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d8:	cac1                	beqz	a3,468 <printint+0x9e>
 3da:	0805d763          	bgez	a1,468 <printint+0x9e>
    neg = 1;
    x = -xx;
 3de:	40b005bb          	negw	a1,a1
    neg = 1;
 3e2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3e4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3e8:	86ce                	mv	a3,s3
  i = 0;
 3ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ec:	00000817          	auipc	a6,0x0
 3f0:	54480813          	addi	a6,a6,1348 # 930 <digits>
 3f4:	88ba                	mv	a7,a4
 3f6:	0017051b          	addiw	a0,a4,1
 3fa:	872a                	mv	a4,a0
 3fc:	02c5f7bb          	remuw	a5,a1,a2
 400:	1782                	slli	a5,a5,0x20
 402:	9381                	srli	a5,a5,0x20
 404:	97c2                	add	a5,a5,a6
 406:	0007c783          	lbu	a5,0(a5)
 40a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40e:	87ae                	mv	a5,a1
 410:	02c5d5bb          	divuw	a1,a1,a2
 414:	0685                	addi	a3,a3,1
 416:	fcc7ffe3          	bgeu	a5,a2,3f4 <printint+0x2a>
  if(neg)
 41a:	00030c63          	beqz	t1,432 <printint+0x68>
    buf[i++] = '-';
 41e:	fd050793          	addi	a5,a0,-48
 422:	00878533          	add	a0,a5,s0
 426:	02d00793          	li	a5,45
 42a:	fef50423          	sb	a5,-24(a0)
 42e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 432:	02e05563          	blez	a4,45c <printint+0x92>
 436:	fc26                	sd	s1,56(sp)
 438:	377d                	addiw	a4,a4,-1
 43a:	00e984b3          	add	s1,s3,a4
 43e:	19fd                	addi	s3,s3,-1
 440:	99ba                	add	s3,s3,a4
 442:	1702                	slli	a4,a4,0x20
 444:	9301                	srli	a4,a4,0x20
 446:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44a:	0004c583          	lbu	a1,0(s1)
 44e:	854a                	mv	a0,s2
 450:	f5dff0ef          	jal	3ac <putc>
  while(--i >= 0)
 454:	14fd                	addi	s1,s1,-1
 456:	ff349ae3          	bne	s1,s3,44a <printint+0x80>
 45a:	74e2                	ld	s1,56(sp)
}
 45c:	60a6                	ld	ra,72(sp)
 45e:	6406                	ld	s0,64(sp)
 460:	7942                	ld	s2,48(sp)
 462:	79a2                	ld	s3,40(sp)
 464:	6161                	addi	sp,sp,80
 466:	8082                	ret
    x = xx;
 468:	2581                	sext.w	a1,a1
  neg = 0;
 46a:	4301                	li	t1,0
 46c:	bfa5                	j	3e4 <printint+0x1a>

000000000000046e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46e:	711d                	addi	sp,sp,-96
 470:	ec86                	sd	ra,88(sp)
 472:	e8a2                	sd	s0,80(sp)
 474:	e4a6                	sd	s1,72(sp)
 476:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 478:	0005c483          	lbu	s1,0(a1)
 47c:	22048363          	beqz	s1,6a2 <vprintf+0x234>
 480:	e0ca                	sd	s2,64(sp)
 482:	fc4e                	sd	s3,56(sp)
 484:	f852                	sd	s4,48(sp)
 486:	f456                	sd	s5,40(sp)
 488:	f05a                	sd	s6,32(sp)
 48a:	ec5e                	sd	s7,24(sp)
 48c:	e862                	sd	s8,16(sp)
 48e:	8b2a                	mv	s6,a0
 490:	8a2e                	mv	s4,a1
 492:	8bb2                	mv	s7,a2
  state = 0;
 494:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 496:	4901                	li	s2,0
 498:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 49a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 49e:	06400c13          	li	s8,100
 4a2:	a00d                	j	4c4 <vprintf+0x56>
        putc(fd, c0);
 4a4:	85a6                	mv	a1,s1
 4a6:	855a                	mv	a0,s6
 4a8:	f05ff0ef          	jal	3ac <putc>
 4ac:	a019                	j	4b2 <vprintf+0x44>
    } else if(state == '%'){
 4ae:	03598363          	beq	s3,s5,4d4 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4b2:	0019079b          	addiw	a5,s2,1
 4b6:	893e                	mv	s2,a5
 4b8:	873e                	mv	a4,a5
 4ba:	97d2                	add	a5,a5,s4
 4bc:	0007c483          	lbu	s1,0(a5)
 4c0:	1c048a63          	beqz	s1,694 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4c4:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4c8:	fe0993e3          	bnez	s3,4ae <vprintf+0x40>
      if(c0 == '%'){
 4cc:	fd579ce3          	bne	a5,s5,4a4 <vprintf+0x36>
        state = '%';
 4d0:	89be                	mv	s3,a5
 4d2:	b7c5                	j	4b2 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d4:	00ea06b3          	add	a3,s4,a4
 4d8:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4dc:	1c060863          	beqz	a2,6ac <vprintf+0x23e>
      if(c0 == 'd'){
 4e0:	03878763          	beq	a5,s8,50e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e4:	f9478693          	addi	a3,a5,-108
 4e8:	0016b693          	seqz	a3,a3
 4ec:	f9c60593          	addi	a1,a2,-100
 4f0:	e99d                	bnez	a1,526 <vprintf+0xb8>
 4f2:	ca95                	beqz	a3,526 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f4:	008b8493          	addi	s1,s7,8
 4f8:	4685                	li	a3,1
 4fa:	4629                	li	a2,10
 4fc:	000bb583          	ld	a1,0(s7)
 500:	855a                	mv	a0,s6
 502:	ec9ff0ef          	jal	3ca <printint>
        i += 1;
 506:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 508:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 50a:	4981                	li	s3,0
 50c:	b75d                	j	4b2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 50e:	008b8493          	addi	s1,s7,8
 512:	4685                	li	a3,1
 514:	4629                	li	a2,10
 516:	000ba583          	lw	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	eafff0ef          	jal	3ca <printint>
 520:	8ba6                	mv	s7,s1
      state = 0;
 522:	4981                	li	s3,0
 524:	b779                	j	4b2 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 526:	9752                	add	a4,a4,s4
 528:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 52c:	f9460713          	addi	a4,a2,-108
 530:	00173713          	seqz	a4,a4
 534:	8f75                	and	a4,a4,a3
 536:	f9c58513          	addi	a0,a1,-100
 53a:	18051363          	bnez	a0,6c0 <vprintf+0x252>
 53e:	18070163          	beqz	a4,6c0 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 542:	008b8493          	addi	s1,s7,8
 546:	4685                	li	a3,1
 548:	4629                	li	a2,10
 54a:	000bb583          	ld	a1,0(s7)
 54e:	855a                	mv	a0,s6
 550:	e7bff0ef          	jal	3ca <printint>
        i += 2;
 554:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 556:	8ba6                	mv	s7,s1
      state = 0;
 558:	4981                	li	s3,0
        i += 2;
 55a:	bfa1                	j	4b2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 55c:	008b8493          	addi	s1,s7,8
 560:	4681                	li	a3,0
 562:	4629                	li	a2,10
 564:	000be583          	lwu	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e61ff0ef          	jal	3ca <printint>
 56e:	8ba6                	mv	s7,s1
      state = 0;
 570:	4981                	li	s3,0
 572:	b781                	j	4b2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 574:	008b8493          	addi	s1,s7,8
 578:	4681                	li	a3,0
 57a:	4629                	li	a2,10
 57c:	000bb583          	ld	a1,0(s7)
 580:	855a                	mv	a0,s6
 582:	e49ff0ef          	jal	3ca <printint>
        i += 1;
 586:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b71d                	j	4b2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	008b8493          	addi	s1,s7,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000bb583          	ld	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e2fff0ef          	jal	3ca <printint>
        i += 2;
 5a0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
        i += 2;
 5a6:	b731                	j	4b2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000be583          	lwu	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e15ff0ef          	jal	3ca <printint>
 5ba:	8ba6                	mv	s7,s1
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bdd5                	j	4b2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c0:	008b8493          	addi	s1,s7,8
 5c4:	4681                	li	a3,0
 5c6:	4641                	li	a2,16
 5c8:	000bb583          	ld	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	dfdff0ef          	jal	3ca <printint>
        i += 1;
 5d2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bde9                	j	4b2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4681                	li	a3,0
 5e0:	4641                	li	a2,16
 5e2:	000bb583          	ld	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	de3ff0ef          	jal	3ca <printint>
        i += 2;
 5ec:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
        i += 2;
 5f2:	b5c1                	j	4b2 <vprintf+0x44>
 5f4:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5f6:	008b8793          	addi	a5,s7,8
 5fa:	8cbe                	mv	s9,a5
 5fc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 600:	03000593          	li	a1,48
 604:	855a                	mv	a0,s6
 606:	da7ff0ef          	jal	3ac <putc>
  putc(fd, 'x');
 60a:	07800593          	li	a1,120
 60e:	855a                	mv	a0,s6
 610:	d9dff0ef          	jal	3ac <putc>
 614:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 616:	00000b97          	auipc	s7,0x0
 61a:	31ab8b93          	addi	s7,s7,794 # 930 <digits>
 61e:	03c9d793          	srli	a5,s3,0x3c
 622:	97de                	add	a5,a5,s7
 624:	0007c583          	lbu	a1,0(a5)
 628:	855a                	mv	a0,s6
 62a:	d83ff0ef          	jal	3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62e:	0992                	slli	s3,s3,0x4
 630:	34fd                	addiw	s1,s1,-1
 632:	f4f5                	bnez	s1,61e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 634:	8be6                	mv	s7,s9
      state = 0;
 636:	4981                	li	s3,0
 638:	6ca2                	ld	s9,8(sp)
 63a:	bda5                	j	4b2 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 63c:	008b8493          	addi	s1,s7,8
 640:	000bc583          	lbu	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	d67ff0ef          	jal	3ac <putc>
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b595                	j	4b2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 650:	008b8993          	addi	s3,s7,8
 654:	000bb483          	ld	s1,0(s7)
 658:	cc91                	beqz	s1,674 <vprintf+0x206>
        for(; *s; s++)
 65a:	0004c583          	lbu	a1,0(s1)
 65e:	c985                	beqz	a1,68e <vprintf+0x220>
          putc(fd, *s);
 660:	855a                	mv	a0,s6
 662:	d4bff0ef          	jal	3ac <putc>
        for(; *s; s++)
 666:	0485                	addi	s1,s1,1
 668:	0004c583          	lbu	a1,0(s1)
 66c:	f9f5                	bnez	a1,660 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 66e:	8bce                	mv	s7,s3
      state = 0;
 670:	4981                	li	s3,0
 672:	b581                	j	4b2 <vprintf+0x44>
          s = "(null)";
 674:	00000497          	auipc	s1,0x0
 678:	2b448493          	addi	s1,s1,692 # 928 <malloc+0x118>
        for(; *s; s++)
 67c:	02800593          	li	a1,40
 680:	b7c5                	j	660 <vprintf+0x1f2>
        putc(fd, '%');
 682:	85be                	mv	a1,a5
 684:	855a                	mv	a0,s6
 686:	d27ff0ef          	jal	3ac <putc>
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b51d                	j	4b2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 68e:	8bce                	mv	s7,s3
      state = 0;
 690:	4981                	li	s3,0
 692:	b505                	j	4b2 <vprintf+0x44>
 694:	6906                	ld	s2,64(sp)
 696:	79e2                	ld	s3,56(sp)
 698:	7a42                	ld	s4,48(sp)
 69a:	7aa2                	ld	s5,40(sp)
 69c:	7b02                	ld	s6,32(sp)
 69e:	6be2                	ld	s7,24(sp)
 6a0:	6c42                	ld	s8,16(sp)
    }
  }
}
 6a2:	60e6                	ld	ra,88(sp)
 6a4:	6446                	ld	s0,80(sp)
 6a6:	64a6                	ld	s1,72(sp)
 6a8:	6125                	addi	sp,sp,96
 6aa:	8082                	ret
      if(c0 == 'd'){
 6ac:	06400713          	li	a4,100
 6b0:	e4e78fe3          	beq	a5,a4,50e <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6b4:	f9478693          	addi	a3,a5,-108
 6b8:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6bc:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6be:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6c0:	07500513          	li	a0,117
 6c4:	e8a78ce3          	beq	a5,a0,55c <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6c8:	f8b60513          	addi	a0,a2,-117
 6cc:	e119                	bnez	a0,6d2 <vprintf+0x264>
 6ce:	ea0693e3          	bnez	a3,574 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6d2:	f8b58513          	addi	a0,a1,-117
 6d6:	e119                	bnez	a0,6dc <vprintf+0x26e>
 6d8:	ea071be3          	bnez	a4,58e <vprintf+0x120>
      } else if(c0 == 'x'){
 6dc:	07800513          	li	a0,120
 6e0:	eca784e3          	beq	a5,a0,5a8 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6e4:	f8860613          	addi	a2,a2,-120
 6e8:	e219                	bnez	a2,6ee <vprintf+0x280>
 6ea:	ec069be3          	bnez	a3,5c0 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6ee:	f8858593          	addi	a1,a1,-120
 6f2:	e199                	bnez	a1,6f8 <vprintf+0x28a>
 6f4:	ee0713e3          	bnez	a4,5da <vprintf+0x16c>
      } else if(c0 == 'p'){
 6f8:	07000713          	li	a4,112
 6fc:	eee78ce3          	beq	a5,a4,5f4 <vprintf+0x186>
      } else if(c0 == 'c'){
 700:	06300713          	li	a4,99
 704:	f2e78ce3          	beq	a5,a4,63c <vprintf+0x1ce>
      } else if(c0 == 's'){
 708:	07300713          	li	a4,115
 70c:	f4e782e3          	beq	a5,a4,650 <vprintf+0x1e2>
      } else if(c0 == '%'){
 710:	02500713          	li	a4,37
 714:	f6e787e3          	beq	a5,a4,682 <vprintf+0x214>
        putc(fd, '%');
 718:	02500593          	li	a1,37
 71c:	855a                	mv	a0,s6
 71e:	c8fff0ef          	jal	3ac <putc>
        putc(fd, c0);
 722:	85a6                	mv	a1,s1
 724:	855a                	mv	a0,s6
 726:	c87ff0ef          	jal	3ac <putc>
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b359                	j	4b2 <vprintf+0x44>

000000000000072e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72e:	715d                	addi	sp,sp,-80
 730:	ec06                	sd	ra,24(sp)
 732:	e822                	sd	s0,16(sp)
 734:	1000                	addi	s0,sp,32
 736:	e010                	sd	a2,0(s0)
 738:	e414                	sd	a3,8(s0)
 73a:	e818                	sd	a4,16(s0)
 73c:	ec1c                	sd	a5,24(s0)
 73e:	03043023          	sd	a6,32(s0)
 742:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 746:	8622                	mv	a2,s0
 748:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74c:	d23ff0ef          	jal	46e <vprintf>
}
 750:	60e2                	ld	ra,24(sp)
 752:	6442                	ld	s0,16(sp)
 754:	6161                	addi	sp,sp,80
 756:	8082                	ret

0000000000000758 <printf>:

void
printf(const char *fmt, ...)
{
 758:	711d                	addi	sp,sp,-96
 75a:	ec06                	sd	ra,24(sp)
 75c:	e822                	sd	s0,16(sp)
 75e:	1000                	addi	s0,sp,32
 760:	e40c                	sd	a1,8(s0)
 762:	e810                	sd	a2,16(s0)
 764:	ec14                	sd	a3,24(s0)
 766:	f018                	sd	a4,32(s0)
 768:	f41c                	sd	a5,40(s0)
 76a:	03043823          	sd	a6,48(s0)
 76e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 772:	00840613          	addi	a2,s0,8
 776:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77a:	85aa                	mv	a1,a0
 77c:	4505                	li	a0,1
 77e:	cf1ff0ef          	jal	46e <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6125                	addi	sp,sp,96
 788:	8082                	ret

000000000000078a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78a:	1141                	addi	sp,sp,-16
 78c:	e406                	sd	ra,8(sp)
 78e:	e022                	sd	s0,0(sp)
 790:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 792:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	00001797          	auipc	a5,0x1
 79a:	86a7b783          	ld	a5,-1942(a5) # 1000 <freep>
 79e:	a039                	j	7ac <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	6398                	ld	a4,0(a5)
 7a2:	00e7e463          	bltu	a5,a4,7aa <free+0x20>
 7a6:	00e6ea63          	bltu	a3,a4,7ba <free+0x30>
{
 7aa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ac:	fed7fae3          	bgeu	a5,a3,7a0 <free+0x16>
 7b0:	6398                	ld	a4,0(a5)
 7b2:	00e6e463          	bltu	a3,a4,7ba <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b6:	fee7eae3          	bltu	a5,a4,7aa <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ba:	ff852583          	lw	a1,-8(a0)
 7be:	6390                	ld	a2,0(a5)
 7c0:	02059813          	slli	a6,a1,0x20
 7c4:	01c85713          	srli	a4,a6,0x1c
 7c8:	9736                	add	a4,a4,a3
 7ca:	02e60563          	beq	a2,a4,7f4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7d2:	4790                	lw	a2,8(a5)
 7d4:	02061593          	slli	a1,a2,0x20
 7d8:	01c5d713          	srli	a4,a1,0x1c
 7dc:	973e                	add	a4,a4,a5
 7de:	02e68263          	beq	a3,a4,802 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e4:	00001717          	auipc	a4,0x1
 7e8:	80f73e23          	sd	a5,-2020(a4) # 1000 <freep>
}
 7ec:	60a2                	ld	ra,8(sp)
 7ee:	6402                	ld	s0,0(sp)
 7f0:	0141                	addi	sp,sp,16
 7f2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7f4:	4618                	lw	a4,8(a2)
 7f6:	9f2d                	addw	a4,a4,a1
 7f8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	6310                	ld	a2,0(a4)
 800:	b7f9                	j	7ce <free+0x44>
    p->s.size += bp->s.size;
 802:	ff852703          	lw	a4,-8(a0)
 806:	9f31                	addw	a4,a4,a2
 808:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80a:	ff053683          	ld	a3,-16(a0)
 80e:	bfd1                	j	7e2 <free+0x58>

0000000000000810 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 810:	7139                	addi	sp,sp,-64
 812:	fc06                	sd	ra,56(sp)
 814:	f822                	sd	s0,48(sp)
 816:	f04a                	sd	s2,32(sp)
 818:	ec4e                	sd	s3,24(sp)
 81a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81c:	02051993          	slli	s3,a0,0x20
 820:	0209d993          	srli	s3,s3,0x20
 824:	09bd                	addi	s3,s3,15
 826:	0049d993          	srli	s3,s3,0x4
 82a:	2985                	addiw	s3,s3,1
 82c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 82e:	00000517          	auipc	a0,0x0
 832:	7d253503          	ld	a0,2002(a0) # 1000 <freep>
 836:	c905                	beqz	a0,866 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83a:	4798                	lw	a4,8(a5)
 83c:	09377663          	bgeu	a4,s3,8c8 <malloc+0xb8>
 840:	f426                	sd	s1,40(sp)
 842:	e852                	sd	s4,16(sp)
 844:	e456                	sd	s5,8(sp)
 846:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 848:	8a4e                	mv	s4,s3
 84a:	6705                	lui	a4,0x1
 84c:	00e9f363          	bgeu	s3,a4,852 <malloc+0x42>
 850:	6a05                	lui	s4,0x1
 852:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 856:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85a:	00000497          	auipc	s1,0x0
 85e:	7a648493          	addi	s1,s1,1958 # 1000 <freep>
  if(p == SBRK_ERROR)
 862:	5afd                	li	s5,-1
 864:	a83d                	j	8a2 <malloc+0x92>
 866:	f426                	sd	s1,40(sp)
 868:	e852                	sd	s4,16(sp)
 86a:	e456                	sd	s5,8(sp)
 86c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86e:	00000797          	auipc	a5,0x0
 872:	7a278793          	addi	a5,a5,1954 # 1010 <base>
 876:	00000717          	auipc	a4,0x0
 87a:	78f73523          	sd	a5,1930(a4) # 1000 <freep>
 87e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 880:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 884:	b7d1                	j	848 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 886:	6398                	ld	a4,0(a5)
 888:	e118                	sd	a4,0(a0)
 88a:	a899                	j	8e0 <malloc+0xd0>
  hp->s.size = nu;
 88c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 890:	0541                	addi	a0,a0,16
 892:	ef9ff0ef          	jal	78a <free>
  return freep;
 896:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 898:	c125                	beqz	a0,8f8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	03277163          	bgeu	a4,s2,8c0 <malloc+0xb0>
    if(p == freep)
 8a2:	6098                	ld	a4,0(s1)
 8a4:	853e                	mv	a0,a5
 8a6:	fef71ae3          	bne	a4,a5,89a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8aa:	8552                	mv	a0,s4
 8ac:	a2dff0ef          	jal	2d8 <sbrk>
  if(p == SBRK_ERROR)
 8b0:	fd551ee3          	bne	a0,s5,88c <malloc+0x7c>
        return 0;
 8b4:	4501                	li	a0,0
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	a03d                	j	8ec <malloc+0xdc>
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c8:	fae90fe3          	beq	s2,a4,886 <malloc+0x76>
        p->s.size -= nunits;
 8cc:	4137073b          	subw	a4,a4,s3
 8d0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d2:	02071693          	slli	a3,a4,0x20
 8d6:	01c6d713          	srli	a4,a3,0x1c
 8da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	72a73023          	sd	a0,1824(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e8:	01078513          	addi	a0,a5,16
  }
}
 8ec:	70e2                	ld	ra,56(sp)
 8ee:	7442                	ld	s0,48(sp)
 8f0:	7902                	ld	s2,32(sp)
 8f2:	69e2                	ld	s3,24(sp)
 8f4:	6121                	addi	sp,sp,64
 8f6:	8082                	ret
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	b7f5                	j	8ec <malloc+0xdc>
