
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
  44:	8d058593          	addi	a1,a1,-1840 # 910 <malloc+0xf8>
  48:	4509                	li	a0,2
  4a:	6ec000ef          	jal	736 <fprintf>
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

00000000000003ac <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 3ac:	48d9                	li	a7,22
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b4:	1101                	addi	sp,sp,-32
 3b6:	ec06                	sd	ra,24(sp)
 3b8:	e822                	sd	s0,16(sp)
 3ba:	1000                	addi	s0,sp,32
 3bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c0:	4605                	li	a2,1
 3c2:	fef40593          	addi	a1,s0,-17
 3c6:	f67ff0ef          	jal	32c <write>
}
 3ca:	60e2                	ld	ra,24(sp)
 3cc:	6442                	ld	s0,16(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret

00000000000003d2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d2:	715d                	addi	sp,sp,-80
 3d4:	e486                	sd	ra,72(sp)
 3d6:	e0a2                	sd	s0,64(sp)
 3d8:	f84a                	sd	s2,48(sp)
 3da:	f44e                	sd	s3,40(sp)
 3dc:	0880                	addi	s0,sp,80
 3de:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e0:	cac1                	beqz	a3,470 <printint+0x9e>
 3e2:	0805d763          	bgez	a1,470 <printint+0x9e>
    neg = 1;
    x = -xx;
 3e6:	40b005bb          	negw	a1,a1
    neg = 1;
 3ea:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3ec:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3f0:	86ce                	mv	a3,s3
  i = 0;
 3f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f4:	00000817          	auipc	a6,0x0
 3f8:	53c80813          	addi	a6,a6,1340 # 930 <digits>
 3fc:	88ba                	mv	a7,a4
 3fe:	0017051b          	addiw	a0,a4,1
 402:	872a                	mv	a4,a0
 404:	02c5f7bb          	remuw	a5,a1,a2
 408:	1782                	slli	a5,a5,0x20
 40a:	9381                	srli	a5,a5,0x20
 40c:	97c2                	add	a5,a5,a6
 40e:	0007c783          	lbu	a5,0(a5)
 412:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 416:	87ae                	mv	a5,a1
 418:	02c5d5bb          	divuw	a1,a1,a2
 41c:	0685                	addi	a3,a3,1
 41e:	fcc7ffe3          	bgeu	a5,a2,3fc <printint+0x2a>
  if(neg)
 422:	00030c63          	beqz	t1,43a <printint+0x68>
    buf[i++] = '-';
 426:	fd050793          	addi	a5,a0,-48
 42a:	00878533          	add	a0,a5,s0
 42e:	02d00793          	li	a5,45
 432:	fef50423          	sb	a5,-24(a0)
 436:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 43a:	02e05563          	blez	a4,464 <printint+0x92>
 43e:	fc26                	sd	s1,56(sp)
 440:	377d                	addiw	a4,a4,-1
 442:	00e984b3          	add	s1,s3,a4
 446:	19fd                	addi	s3,s3,-1
 448:	99ba                	add	s3,s3,a4
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 452:	0004c583          	lbu	a1,0(s1)
 456:	854a                	mv	a0,s2
 458:	f5dff0ef          	jal	3b4 <putc>
  while(--i >= 0)
 45c:	14fd                	addi	s1,s1,-1
 45e:	ff349ae3          	bne	s1,s3,452 <printint+0x80>
 462:	74e2                	ld	s1,56(sp)
}
 464:	60a6                	ld	ra,72(sp)
 466:	6406                	ld	s0,64(sp)
 468:	7942                	ld	s2,48(sp)
 46a:	79a2                	ld	s3,40(sp)
 46c:	6161                	addi	sp,sp,80
 46e:	8082                	ret
    x = xx;
 470:	2581                	sext.w	a1,a1
  neg = 0;
 472:	4301                	li	t1,0
 474:	bfa5                	j	3ec <printint+0x1a>

0000000000000476 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 476:	711d                	addi	sp,sp,-96
 478:	ec86                	sd	ra,88(sp)
 47a:	e8a2                	sd	s0,80(sp)
 47c:	e4a6                	sd	s1,72(sp)
 47e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 480:	0005c483          	lbu	s1,0(a1)
 484:	22048363          	beqz	s1,6aa <vprintf+0x234>
 488:	e0ca                	sd	s2,64(sp)
 48a:	fc4e                	sd	s3,56(sp)
 48c:	f852                	sd	s4,48(sp)
 48e:	f456                	sd	s5,40(sp)
 490:	f05a                	sd	s6,32(sp)
 492:	ec5e                	sd	s7,24(sp)
 494:	e862                	sd	s8,16(sp)
 496:	8b2a                	mv	s6,a0
 498:	8a2e                	mv	s4,a1
 49a:	8bb2                	mv	s7,a2
  state = 0;
 49c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 49e:	4901                	li	s2,0
 4a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a6:	06400c13          	li	s8,100
 4aa:	a00d                	j	4cc <vprintf+0x56>
        putc(fd, c0);
 4ac:	85a6                	mv	a1,s1
 4ae:	855a                	mv	a0,s6
 4b0:	f05ff0ef          	jal	3b4 <putc>
 4b4:	a019                	j	4ba <vprintf+0x44>
    } else if(state == '%'){
 4b6:	03598363          	beq	s3,s5,4dc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4ba:	0019079b          	addiw	a5,s2,1
 4be:	893e                	mv	s2,a5
 4c0:	873e                	mv	a4,a5
 4c2:	97d2                	add	a5,a5,s4
 4c4:	0007c483          	lbu	s1,0(a5)
 4c8:	1c048a63          	beqz	s1,69c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4cc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4d0:	fe0993e3          	bnez	s3,4b6 <vprintf+0x40>
      if(c0 == '%'){
 4d4:	fd579ce3          	bne	a5,s5,4ac <vprintf+0x36>
        state = '%';
 4d8:	89be                	mv	s3,a5
 4da:	b7c5                	j	4ba <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4dc:	00ea06b3          	add	a3,s4,a4
 4e0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4e4:	1c060863          	beqz	a2,6b4 <vprintf+0x23e>
      if(c0 == 'd'){
 4e8:	03878763          	beq	a5,s8,516 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ec:	f9478693          	addi	a3,a5,-108
 4f0:	0016b693          	seqz	a3,a3
 4f4:	f9c60593          	addi	a1,a2,-100
 4f8:	e99d                	bnez	a1,52e <vprintf+0xb8>
 4fa:	ca95                	beqz	a3,52e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4fc:	008b8493          	addi	s1,s7,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000bb583          	ld	a1,0(s7)
 508:	855a                	mv	a0,s6
 50a:	ec9ff0ef          	jal	3d2 <printint>
        i += 1;
 50e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 510:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 512:	4981                	li	s3,0
 514:	b75d                	j	4ba <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 516:	008b8493          	addi	s1,s7,8
 51a:	4685                	li	a3,1
 51c:	4629                	li	a2,10
 51e:	000ba583          	lw	a1,0(s7)
 522:	855a                	mv	a0,s6
 524:	eafff0ef          	jal	3d2 <printint>
 528:	8ba6                	mv	s7,s1
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b779                	j	4ba <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 52e:	9752                	add	a4,a4,s4
 530:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 534:	f9460713          	addi	a4,a2,-108
 538:	00173713          	seqz	a4,a4
 53c:	8f75                	and	a4,a4,a3
 53e:	f9c58513          	addi	a0,a1,-100
 542:	18051363          	bnez	a0,6c8 <vprintf+0x252>
 546:	18070163          	beqz	a4,6c8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	008b8493          	addi	s1,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000bb583          	ld	a1,0(s7)
 556:	855a                	mv	a0,s6
 558:	e7bff0ef          	jal	3d2 <printint>
        i += 2;
 55c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	8ba6                	mv	s7,s1
      state = 0;
 560:	4981                	li	s3,0
        i += 2;
 562:	bfa1                	j	4ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 564:	008b8493          	addi	s1,s7,8
 568:	4681                	li	a3,0
 56a:	4629                	li	a2,10
 56c:	000be583          	lwu	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	e61ff0ef          	jal	3d2 <printint>
 576:	8ba6                	mv	s7,s1
      state = 0;
 578:	4981                	li	s3,0
 57a:	b781                	j	4ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	008b8493          	addi	s1,s7,8
 580:	4681                	li	a3,0
 582:	4629                	li	a2,10
 584:	000bb583          	ld	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	e49ff0ef          	jal	3d2 <printint>
        i += 1;
 58e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	8ba6                	mv	s7,s1
      state = 0;
 592:	4981                	li	s3,0
 594:	b71d                	j	4ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 596:	008b8493          	addi	s1,s7,8
 59a:	4681                	li	a3,0
 59c:	4629                	li	a2,10
 59e:	000bb583          	ld	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e2fff0ef          	jal	3d2 <printint>
        i += 2;
 5a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5aa:	8ba6                	mv	s7,s1
      state = 0;
 5ac:	4981                	li	s3,0
        i += 2;
 5ae:	b731                	j	4ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5b0:	008b8493          	addi	s1,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4641                	li	a2,16
 5b8:	000be583          	lwu	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e15ff0ef          	jal	3d2 <printint>
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bdd5                	j	4ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4641                	li	a2,16
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	dfdff0ef          	jal	3d2 <printint>
        i += 1;
 5da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5dc:	8ba6                	mv	s7,s1
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bde9                	j	4ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4641                	li	a2,16
 5ea:	000bb583          	ld	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	de3ff0ef          	jal	3d2 <printint>
        i += 2;
 5f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	b5c1                	j	4ba <vprintf+0x44>
 5fc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5fe:	008b8793          	addi	a5,s7,8
 602:	8cbe                	mv	s9,a5
 604:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 608:	03000593          	li	a1,48
 60c:	855a                	mv	a0,s6
 60e:	da7ff0ef          	jal	3b4 <putc>
  putc(fd, 'x');
 612:	07800593          	li	a1,120
 616:	855a                	mv	a0,s6
 618:	d9dff0ef          	jal	3b4 <putc>
 61c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61e:	00000b97          	auipc	s7,0x0
 622:	312b8b93          	addi	s7,s7,786 # 930 <digits>
 626:	03c9d793          	srli	a5,s3,0x3c
 62a:	97de                	add	a5,a5,s7
 62c:	0007c583          	lbu	a1,0(a5)
 630:	855a                	mv	a0,s6
 632:	d83ff0ef          	jal	3b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 636:	0992                	slli	s3,s3,0x4
 638:	34fd                	addiw	s1,s1,-1
 63a:	f4f5                	bnez	s1,626 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 63c:	8be6                	mv	s7,s9
      state = 0;
 63e:	4981                	li	s3,0
 640:	6ca2                	ld	s9,8(sp)
 642:	bda5                	j	4ba <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 644:	008b8493          	addi	s1,s7,8
 648:	000bc583          	lbu	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	d67ff0ef          	jal	3b4 <putc>
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
 656:	b595                	j	4ba <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 658:	008b8993          	addi	s3,s7,8
 65c:	000bb483          	ld	s1,0(s7)
 660:	cc91                	beqz	s1,67c <vprintf+0x206>
        for(; *s; s++)
 662:	0004c583          	lbu	a1,0(s1)
 666:	c985                	beqz	a1,696 <vprintf+0x220>
          putc(fd, *s);
 668:	855a                	mv	a0,s6
 66a:	d4bff0ef          	jal	3b4 <putc>
        for(; *s; s++)
 66e:	0485                	addi	s1,s1,1
 670:	0004c583          	lbu	a1,0(s1)
 674:	f9f5                	bnez	a1,668 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 676:	8bce                	mv	s7,s3
      state = 0;
 678:	4981                	li	s3,0
 67a:	b581                	j	4ba <vprintf+0x44>
          s = "(null)";
 67c:	00000497          	auipc	s1,0x0
 680:	2ac48493          	addi	s1,s1,684 # 928 <malloc+0x110>
        for(; *s; s++)
 684:	02800593          	li	a1,40
 688:	b7c5                	j	668 <vprintf+0x1f2>
        putc(fd, '%');
 68a:	85be                	mv	a1,a5
 68c:	855a                	mv	a0,s6
 68e:	d27ff0ef          	jal	3b4 <putc>
      state = 0;
 692:	4981                	li	s3,0
 694:	b51d                	j	4ba <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 696:	8bce                	mv	s7,s3
      state = 0;
 698:	4981                	li	s3,0
 69a:	b505                	j	4ba <vprintf+0x44>
 69c:	6906                	ld	s2,64(sp)
 69e:	79e2                	ld	s3,56(sp)
 6a0:	7a42                	ld	s4,48(sp)
 6a2:	7aa2                	ld	s5,40(sp)
 6a4:	7b02                	ld	s6,32(sp)
 6a6:	6be2                	ld	s7,24(sp)
 6a8:	6c42                	ld	s8,16(sp)
    }
  }
}
 6aa:	60e6                	ld	ra,88(sp)
 6ac:	6446                	ld	s0,80(sp)
 6ae:	64a6                	ld	s1,72(sp)
 6b0:	6125                	addi	sp,sp,96
 6b2:	8082                	ret
      if(c0 == 'd'){
 6b4:	06400713          	li	a4,100
 6b8:	e4e78fe3          	beq	a5,a4,516 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6bc:	f9478693          	addi	a3,a5,-108
 6c0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6c4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6c8:	07500513          	li	a0,117
 6cc:	e8a78ce3          	beq	a5,a0,564 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6d0:	f8b60513          	addi	a0,a2,-117
 6d4:	e119                	bnez	a0,6da <vprintf+0x264>
 6d6:	ea0693e3          	bnez	a3,57c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6da:	f8b58513          	addi	a0,a1,-117
 6de:	e119                	bnez	a0,6e4 <vprintf+0x26e>
 6e0:	ea071be3          	bnez	a4,596 <vprintf+0x120>
      } else if(c0 == 'x'){
 6e4:	07800513          	li	a0,120
 6e8:	eca784e3          	beq	a5,a0,5b0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6ec:	f8860613          	addi	a2,a2,-120
 6f0:	e219                	bnez	a2,6f6 <vprintf+0x280>
 6f2:	ec069be3          	bnez	a3,5c8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f6:	f8858593          	addi	a1,a1,-120
 6fa:	e199                	bnez	a1,700 <vprintf+0x28a>
 6fc:	ee0713e3          	bnez	a4,5e2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 700:	07000713          	li	a4,112
 704:	eee78ce3          	beq	a5,a4,5fc <vprintf+0x186>
      } else if(c0 == 'c'){
 708:	06300713          	li	a4,99
 70c:	f2e78ce3          	beq	a5,a4,644 <vprintf+0x1ce>
      } else if(c0 == 's'){
 710:	07300713          	li	a4,115
 714:	f4e782e3          	beq	a5,a4,658 <vprintf+0x1e2>
      } else if(c0 == '%'){
 718:	02500713          	li	a4,37
 71c:	f6e787e3          	beq	a5,a4,68a <vprintf+0x214>
        putc(fd, '%');
 720:	02500593          	li	a1,37
 724:	855a                	mv	a0,s6
 726:	c8fff0ef          	jal	3b4 <putc>
        putc(fd, c0);
 72a:	85a6                	mv	a1,s1
 72c:	855a                	mv	a0,s6
 72e:	c87ff0ef          	jal	3b4 <putc>
      state = 0;
 732:	4981                	li	s3,0
 734:	b359                	j	4ba <vprintf+0x44>

0000000000000736 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 736:	715d                	addi	sp,sp,-80
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	e010                	sd	a2,0(s0)
 740:	e414                	sd	a3,8(s0)
 742:	e818                	sd	a4,16(s0)
 744:	ec1c                	sd	a5,24(s0)
 746:	03043023          	sd	a6,32(s0)
 74a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	8622                	mv	a2,s0
 750:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 754:	d23ff0ef          	jal	476 <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6161                	addi	sp,sp,80
 75e:	8082                	ret

0000000000000760 <printf>:

void
printf(const char *fmt, ...)
{
 760:	711d                	addi	sp,sp,-96
 762:	ec06                	sd	ra,24(sp)
 764:	e822                	sd	s0,16(sp)
 766:	1000                	addi	s0,sp,32
 768:	e40c                	sd	a1,8(s0)
 76a:	e810                	sd	a2,16(s0)
 76c:	ec14                	sd	a3,24(s0)
 76e:	f018                	sd	a4,32(s0)
 770:	f41c                	sd	a5,40(s0)
 772:	03043823          	sd	a6,48(s0)
 776:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	00840613          	addi	a2,s0,8
 77e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 782:	85aa                	mv	a1,a0
 784:	4505                	li	a0,1
 786:	cf1ff0ef          	jal	476 <vprintf>
}
 78a:	60e2                	ld	ra,24(sp)
 78c:	6442                	ld	s0,16(sp)
 78e:	6125                	addi	sp,sp,96
 790:	8082                	ret

0000000000000792 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 792:	1141                	addi	sp,sp,-16
 794:	e406                	sd	ra,8(sp)
 796:	e022                	sd	s0,0(sp)
 798:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	00001797          	auipc	a5,0x1
 7a2:	8627b783          	ld	a5,-1950(a5) # 1000 <freep>
 7a6:	a039                	j	7b4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e7e463          	bltu	a5,a4,7b2 <free+0x20>
 7ae:	00e6ea63          	bltu	a3,a4,7c2 <free+0x30>
{
 7b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	fed7fae3          	bgeu	a5,a3,7a8 <free+0x16>
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e6e463          	bltu	a3,a4,7c2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	fee7eae3          	bltu	a5,a4,7b2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	slli	a6,a1,0x20
 7cc:	01c85713          	srli	a4,a6,0x1c
 7d0:	9736                	add	a4,a4,a3
 7d2:	02e60563          	beq	a2,a4,7fc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	slli	a1,a2,0x20
 7e0:	01c5d713          	srli	a4,a1,0x1c
 7e4:	973e                	add	a4,a4,a5
 7e6:	02e68263          	beq	a3,a4,80a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
}
 7f4:	60a2                	ld	ra,8(sp)
 7f6:	6402                	ld	s0,0(sp)
 7f8:	0141                	addi	sp,sp,16
 7fa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7fc:	4618                	lw	a4,8(a2)
 7fe:	9f2d                	addw	a4,a4,a1
 800:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	6398                	ld	a4,0(a5)
 806:	6310                	ld	a2,0(a4)
 808:	b7f9                	j	7d6 <free+0x44>
    p->s.size += bp->s.size;
 80a:	ff852703          	lw	a4,-8(a0)
 80e:	9f31                	addw	a4,a4,a2
 810:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 812:	ff053683          	ld	a3,-16(a0)
 816:	bfd1                	j	7ea <free+0x58>

0000000000000818 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 818:	7139                	addi	sp,sp,-64
 81a:	fc06                	sd	ra,56(sp)
 81c:	f822                	sd	s0,48(sp)
 81e:	f04a                	sd	s2,32(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 824:	02051993          	slli	s3,a0,0x20
 828:	0209d993          	srli	s3,s3,0x20
 82c:	09bd                	addi	s3,s3,15
 82e:	0049d993          	srli	s3,s3,0x4
 832:	2985                	addiw	s3,s3,1
 834:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 836:	00000517          	auipc	a0,0x0
 83a:	7ca53503          	ld	a0,1994(a0) # 1000 <freep>
 83e:	c905                	beqz	a0,86e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	09377663          	bgeu	a4,s3,8d0 <malloc+0xb8>
 848:	f426                	sd	s1,40(sp)
 84a:	e852                	sd	s4,16(sp)
 84c:	e456                	sd	s5,8(sp)
 84e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 850:	8a4e                	mv	s4,s3
 852:	6705                	lui	a4,0x1
 854:	00e9f363          	bgeu	s3,a4,85a <malloc+0x42>
 858:	6a05                	lui	s4,0x1
 85a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 862:	00000497          	auipc	s1,0x0
 866:	79e48493          	addi	s1,s1,1950 # 1000 <freep>
  if(p == SBRK_ERROR)
 86a:	5afd                	li	s5,-1
 86c:	a83d                	j	8aa <malloc+0x92>
 86e:	f426                	sd	s1,40(sp)
 870:	e852                	sd	s4,16(sp)
 872:	e456                	sd	s5,8(sp)
 874:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 876:	00000797          	auipc	a5,0x0
 87a:	79a78793          	addi	a5,a5,1946 # 1010 <base>
 87e:	00000717          	auipc	a4,0x0
 882:	78f73123          	sd	a5,1922(a4) # 1000 <freep>
 886:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 888:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88c:	b7d1                	j	850 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	e118                	sd	a4,0(a0)
 892:	a899                	j	8e8 <malloc+0xd0>
  hp->s.size = nu;
 894:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 898:	0541                	addi	a0,a0,16
 89a:	ef9ff0ef          	jal	792 <free>
  return freep;
 89e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a0:	c125                	beqz	a0,900 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a4:	4798                	lw	a4,8(a5)
 8a6:	03277163          	bgeu	a4,s2,8c8 <malloc+0xb0>
    if(p == freep)
 8aa:	6098                	ld	a4,0(s1)
 8ac:	853e                	mv	a0,a5
 8ae:	fef71ae3          	bne	a4,a5,8a2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b2:	8552                	mv	a0,s4
 8b4:	a25ff0ef          	jal	2d8 <sbrk>
  if(p == SBRK_ERROR)
 8b8:	fd551ee3          	bne	a0,s5,894 <malloc+0x7c>
        return 0;
 8bc:	4501                	li	a0,0
 8be:	74a2                	ld	s1,40(sp)
 8c0:	6a42                	ld	s4,16(sp)
 8c2:	6aa2                	ld	s5,8(sp)
 8c4:	6b02                	ld	s6,0(sp)
 8c6:	a03d                	j	8f4 <malloc+0xdc>
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d0:	fae90fe3          	beq	s2,a4,88e <malloc+0x76>
        p->s.size -= nunits;
 8d4:	4137073b          	subw	a4,a4,s3
 8d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8da:	02071693          	slli	a3,a4,0x20
 8de:	01c6d713          	srli	a4,a3,0x1c
 8e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70a73c23          	sd	a0,1816(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f0:	01078513          	addi	a0,a5,16
  }
}
 8f4:	70e2                	ld	ra,56(sp)
 8f6:	7442                	ld	s0,48(sp)
 8f8:	7902                	ld	s2,32(sp)
 8fa:	69e2                	ld	s3,24(sp)
 8fc:	6121                	addi	sp,sp,64
 8fe:	8082                	ret
 900:	74a2                	ld	s1,40(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
 908:	b7f5                	j	8f4 <malloc+0xdc>
