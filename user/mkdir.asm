
user/_mkdir:     file format elf64-littleriscv


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
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	35e000ef          	jal	386 <mkdir>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2e6000ef          	jal	31e <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8e058593          	addi	a1,a1,-1824 # 920 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	6f6000ef          	jal	740 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2ce000ef          	jal	31e <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	8e258593          	addi	a1,a1,-1822 # 938 <malloc+0x116>
  5e:	4509                	li	a0,2
  60:	6e0000ef          	jal	740 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	2aa000ef          	jal	31e <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	87aa                	mv	a5,a0
  82:	0585                	addi	a1,a1,1
  84:	0785                	addi	a5,a5,1
  86:	fff5c703          	lbu	a4,-1(a1)
  8a:	fee78fa3          	sb	a4,-1(a5)
  8e:	fb75                	bnez	a4,82 <strcpy+0xa>
    ;
  return os;
}
  90:	60a2                	ld	ra,8(sp)
  92:	6402                	ld	s0,0(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	1141                	addi	sp,sp,-16
  9a:	e406                	sd	ra,8(sp)
  9c:	e022                	sd	s0,0(sp)
  9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x20>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x20>
    p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x28>
  d6:	00150793          	addi	a5,a0,1
  da:	86be                	mv	a3,a5
  dc:	0785                	addi	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x12>
  e4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfdd                	j	e8 <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fc:	ca19                	beqz	a2,112 <memset+0x1e>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x14>
  }
  return dst;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strchr>:

char*
strchr(const char *s, char c)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  for(; *s; s++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf81                	beqz	a5,13e <strchr+0x24>
    if(*s == c)
 128:	00f58763          	beq	a1,a5,136 <strchr+0x1c>
  for(; *s; s++)
 12c:	0505                	addi	a0,a0,1
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbfd                	bnez	a5,128 <strchr+0xe>
      return (char*)s;
  return 0;
 134:	4501                	li	a0,0
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfdd                	j	136 <strchr+0x1c>

0000000000000142 <gets>:

char*
gets(char *buf, int max)
{
 142:	711d                	addi	sp,sp,-96
 144:	ec86                	sd	ra,88(sp)
 146:	e8a2                	sd	s0,80(sp)
 148:	e4a6                	sd	s1,72(sp)
 14a:	e0ca                	sd	s2,64(sp)
 14c:	fc4e                	sd	s3,56(sp)
 14e:	f852                	sd	s4,48(sp)
 150:	f456                	sd	s5,40(sp)
 152:	f05a                	sd	s6,32(sp)
 154:	ec5e                	sd	s7,24(sp)
 156:	e862                	sd	s8,16(sp)
 158:	1080                	addi	s0,sp,96
 15a:	8baa                	mv	s7,a0
 15c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	892a                	mv	s2,a0
 160:	4481                	li	s1,0
    cc = read(0, &c, 1);
 162:	faf40b13          	addi	s6,s0,-81
 166:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 168:	8c26                	mv	s8,s1
 16a:	0014899b          	addiw	s3,s1,1
 16e:	84ce                	mv	s1,s3
 170:	0349d463          	bge	s3,s4,198 <gets+0x56>
    cc = read(0, &c, 1);
 174:	8656                	mv	a2,s5
 176:	85da                	mv	a1,s6
 178:	4501                	li	a0,0
 17a:	1bc000ef          	jal	336 <read>
    if(cc < 1)
 17e:	00a05d63          	blez	a0,198 <gets+0x56>
      break;
    buf[i++] = c;
 182:	faf44783          	lbu	a5,-81(s0)
 186:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 18a:	0905                	addi	s2,s2,1
 18c:	ff678713          	addi	a4,a5,-10
 190:	c319                	beqz	a4,196 <gets+0x54>
 192:	17cd                	addi	a5,a5,-13
 194:	fbf1                	bnez	a5,168 <gets+0x26>
    buf[i++] = c;
 196:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 198:	9c5e                	add	s8,s8,s7
 19a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 19e:	855e                	mv	a0,s7
 1a0:	60e6                	ld	ra,88(sp)
 1a2:	6446                	ld	s0,80(sp)
 1a4:	64a6                	ld	s1,72(sp)
 1a6:	6906                	ld	s2,64(sp)
 1a8:	79e2                	ld	s3,56(sp)
 1aa:	7a42                	ld	s4,48(sp)
 1ac:	7aa2                	ld	s5,40(sp)
 1ae:	7b02                	ld	s6,32(sp)
 1b0:	6be2                	ld	s7,24(sp)
 1b2:	6c42                	ld	s8,16(sp)
 1b4:	6125                	addi	sp,sp,96
 1b6:	8082                	ret

00000000000001b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b8:	1101                	addi	sp,sp,-32
 1ba:	ec06                	sd	ra,24(sp)
 1bc:	e822                	sd	s0,16(sp)
 1be:	e04a                	sd	s2,0(sp)
 1c0:	1000                	addi	s0,sp,32
 1c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c4:	4581                	li	a1,0
 1c6:	198000ef          	jal	35e <open>
  if(fd < 0)
 1ca:	02054263          	bltz	a0,1ee <stat+0x36>
 1ce:	e426                	sd	s1,8(sp)
 1d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d2:	85ca                	mv	a1,s2
 1d4:	1a2000ef          	jal	376 <fstat>
 1d8:	892a                	mv	s2,a0
  close(fd);
 1da:	8526                	mv	a0,s1
 1dc:	16a000ef          	jal	346 <close>
  return r;
 1e0:	64a2                	ld	s1,8(sp)
}
 1e2:	854a                	mv	a0,s2
 1e4:	60e2                	ld	ra,24(sp)
 1e6:	6442                	ld	s0,16(sp)
 1e8:	6902                	ld	s2,0(sp)
 1ea:	6105                	addi	sp,sp,32
 1ec:	8082                	ret
    return -1;
 1ee:	57fd                	li	a5,-1
 1f0:	893e                	mv	s2,a5
 1f2:	bfc5                	j	1e2 <stat+0x2a>

00000000000001f4 <atoi>:

int
atoi(const char *s)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e406                	sd	ra,8(sp)
 1f8:	e022                	sd	s0,0(sp)
 1fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1fc:	00054683          	lbu	a3,0(a0)
 200:	fd06879b          	addiw	a5,a3,-48
 204:	0ff7f793          	zext.b	a5,a5
 208:	4625                	li	a2,9
 20a:	02f66963          	bltu	a2,a5,23c <atoi+0x48>
 20e:	872a                	mv	a4,a0
  n = 0;
 210:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 212:	0705                	addi	a4,a4,1
 214:	0025179b          	slliw	a5,a0,0x2
 218:	9fa9                	addw	a5,a5,a0
 21a:	0017979b          	slliw	a5,a5,0x1
 21e:	9fb5                	addw	a5,a5,a3
 220:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 224:	00074683          	lbu	a3,0(a4)
 228:	fd06879b          	addiw	a5,a3,-48
 22c:	0ff7f793          	zext.b	a5,a5
 230:	fef671e3          	bgeu	a2,a5,212 <atoi+0x1e>
  return n;
}
 234:	60a2                	ld	ra,8(sp)
 236:	6402                	ld	s0,0(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  n = 0;
 23c:	4501                	li	a0,0
 23e:	bfdd                	j	234 <atoi+0x40>

0000000000000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	1141                	addi	sp,sp,-16
 242:	e406                	sd	ra,8(sp)
 244:	e022                	sd	s0,0(sp)
 246:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 248:	02b57563          	bgeu	a0,a1,272 <memmove+0x32>
    while(n-- > 0)
 24c:	00c05f63          	blez	a2,26a <memmove+0x2a>
 250:	1602                	slli	a2,a2,0x20
 252:	9201                	srli	a2,a2,0x20
 254:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 258:	872a                	mv	a4,a0
      *dst++ = *src++;
 25a:	0585                	addi	a1,a1,1
 25c:	0705                	addi	a4,a4,1
 25e:	fff5c683          	lbu	a3,-1(a1)
 262:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 266:	fee79ae3          	bne	a5,a4,25a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26a:	60a2                	ld	ra,8(sp)
 26c:	6402                	ld	s0,0(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
    while(n-- > 0)
 272:	fec05ce3          	blez	a2,26a <memmove+0x2a>
    dst += n;
 276:	00c50733          	add	a4,a0,a2
    src += n;
 27a:	95b2                	add	a1,a1,a2
 27c:	fff6079b          	addiw	a5,a2,-1
 280:	1782                	slli	a5,a5,0x20
 282:	9381                	srli	a5,a5,0x20
 284:	fff7c793          	not	a5,a5
 288:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28a:	15fd                	addi	a1,a1,-1
 28c:	177d                	addi	a4,a4,-1
 28e:	0005c683          	lbu	a3,0(a1)
 292:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 296:	fef71ae3          	bne	a4,a5,28a <memmove+0x4a>
 29a:	bfc1                	j	26a <memmove+0x2a>

000000000000029c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	c61d                	beqz	a2,2d2 <memcmp+0x36>
 2a6:	1602                	slli	a2,a2,0x20
 2a8:	9201                	srli	a2,a2,0x20
 2aa:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	0005c703          	lbu	a4,0(a1)
 2b6:	00e79863          	bne	a5,a4,2c6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ba:	0505                	addi	a0,a0,1
    p2++;
 2bc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2be:	fed518e3          	bne	a0,a3,2ae <memcmp+0x12>
  }
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	a019                	j	2ca <memcmp+0x2e>
      return *p1 - *p2;
 2c6:	40e7853b          	subw	a0,a5,a4
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfdd                	j	2ca <memcmp+0x2e>

00000000000002d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2de:	f63ff0ef          	jal	240 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <sbrk>:

char *
sbrk(int n) {
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f2:	4585                	li	a1,1
 2f4:	0b2000ef          	jal	3a6 <sys_sbrk>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <sbrklazy>:

char *
sbrklazy(int n) {
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 308:	4589                	li	a1,2
 30a:	09c000ef          	jal	3a6 <sys_sbrk>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 316:	4885                	li	a7,1
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exit>:
.global exit
exit:
 li a7, SYS_exit
 31e:	4889                	li	a7,2
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <wait>:
.global wait
wait:
 li a7, SYS_wait
 326:	488d                	li	a7,3
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32e:	4891                	li	a7,4
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <read>:
.global read
read:
 li a7, SYS_read
 336:	4895                	li	a7,5
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <write>:
.global write
write:
 li a7, SYS_write
 33e:	48c1                	li	a7,16
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <close>:
.global close
close:
 li a7, SYS_close
 346:	48d5                	li	a7,21
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <kill>:
.global kill
kill:
 li a7, SYS_kill
 34e:	4899                	li	a7,6
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exec>:
.global exec
exec:
 li a7, SYS_exec
 356:	489d                	li	a7,7
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <open>:
.global open
open:
 li a7, SYS_open
 35e:	48bd                	li	a7,15
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 366:	48c5                	li	a7,17
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36e:	48c9                	li	a7,18
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 376:	48a1                	li	a7,8
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <link>:
.global link
link:
 li a7, SYS_link
 37e:	48cd                	li	a7,19
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 386:	48d1                	li	a7,20
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38e:	48a5                	li	a7,9
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <dup>:
.global dup
dup:
 li a7, SYS_dup
 396:	48a9                	li	a7,10
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39e:	48ad                	li	a7,11
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a6:	48b1                	li	a7,12
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ae:	48b5                	li	a7,13
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b6:	48b9                	li	a7,14
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	1000                	addi	s0,sp,32
 3c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ca:	4605                	li	a2,1
 3cc:	fef40593          	addi	a1,s0,-17
 3d0:	f6fff0ef          	jal	33e <write>
}
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret

00000000000003dc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3dc:	715d                	addi	sp,sp,-80
 3de:	e486                	sd	ra,72(sp)
 3e0:	e0a2                	sd	s0,64(sp)
 3e2:	f84a                	sd	s2,48(sp)
 3e4:	f44e                	sd	s3,40(sp)
 3e6:	0880                	addi	s0,sp,80
 3e8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ea:	cac1                	beqz	a3,47a <printint+0x9e>
 3ec:	0805d763          	bgez	a1,47a <printint+0x9e>
    neg = 1;
    x = -xx;
 3f0:	40b005bb          	negw	a1,a1
    neg = 1;
 3f4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3fa:	86ce                	mv	a3,s3
  i = 0;
 3fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fe:	00000817          	auipc	a6,0x0
 402:	56280813          	addi	a6,a6,1378 # 960 <digits>
 406:	88ba                	mv	a7,a4
 408:	0017051b          	addiw	a0,a4,1
 40c:	872a                	mv	a4,a0
 40e:	02c5f7bb          	remuw	a5,a1,a2
 412:	1782                	slli	a5,a5,0x20
 414:	9381                	srli	a5,a5,0x20
 416:	97c2                	add	a5,a5,a6
 418:	0007c783          	lbu	a5,0(a5)
 41c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 420:	87ae                	mv	a5,a1
 422:	02c5d5bb          	divuw	a1,a1,a2
 426:	0685                	addi	a3,a3,1
 428:	fcc7ffe3          	bgeu	a5,a2,406 <printint+0x2a>
  if(neg)
 42c:	00030c63          	beqz	t1,444 <printint+0x68>
    buf[i++] = '-';
 430:	fd050793          	addi	a5,a0,-48
 434:	00878533          	add	a0,a5,s0
 438:	02d00793          	li	a5,45
 43c:	fef50423          	sb	a5,-24(a0)
 440:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 444:	02e05563          	blez	a4,46e <printint+0x92>
 448:	fc26                	sd	s1,56(sp)
 44a:	377d                	addiw	a4,a4,-1
 44c:	00e984b3          	add	s1,s3,a4
 450:	19fd                	addi	s3,s3,-1
 452:	99ba                	add	s3,s3,a4
 454:	1702                	slli	a4,a4,0x20
 456:	9301                	srli	a4,a4,0x20
 458:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45c:	0004c583          	lbu	a1,0(s1)
 460:	854a                	mv	a0,s2
 462:	f5dff0ef          	jal	3be <putc>
  while(--i >= 0)
 466:	14fd                	addi	s1,s1,-1
 468:	ff349ae3          	bne	s1,s3,45c <printint+0x80>
 46c:	74e2                	ld	s1,56(sp)
}
 46e:	60a6                	ld	ra,72(sp)
 470:	6406                	ld	s0,64(sp)
 472:	7942                	ld	s2,48(sp)
 474:	79a2                	ld	s3,40(sp)
 476:	6161                	addi	sp,sp,80
 478:	8082                	ret
    x = xx;
 47a:	2581                	sext.w	a1,a1
  neg = 0;
 47c:	4301                	li	t1,0
 47e:	bfa5                	j	3f6 <printint+0x1a>

0000000000000480 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 480:	711d                	addi	sp,sp,-96
 482:	ec86                	sd	ra,88(sp)
 484:	e8a2                	sd	s0,80(sp)
 486:	e4a6                	sd	s1,72(sp)
 488:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48a:	0005c483          	lbu	s1,0(a1)
 48e:	22048363          	beqz	s1,6b4 <vprintf+0x234>
 492:	e0ca                	sd	s2,64(sp)
 494:	fc4e                	sd	s3,56(sp)
 496:	f852                	sd	s4,48(sp)
 498:	f456                	sd	s5,40(sp)
 49a:	f05a                	sd	s6,32(sp)
 49c:	ec5e                	sd	s7,24(sp)
 49e:	e862                	sd	s8,16(sp)
 4a0:	8b2a                	mv	s6,a0
 4a2:	8a2e                	mv	s4,a1
 4a4:	8bb2                	mv	s7,a2
  state = 0;
 4a6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a8:	4901                	li	s2,0
 4aa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ac:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b0:	06400c13          	li	s8,100
 4b4:	a00d                	j	4d6 <vprintf+0x56>
        putc(fd, c0);
 4b6:	85a6                	mv	a1,s1
 4b8:	855a                	mv	a0,s6
 4ba:	f05ff0ef          	jal	3be <putc>
 4be:	a019                	j	4c4 <vprintf+0x44>
    } else if(state == '%'){
 4c0:	03598363          	beq	s3,s5,4e6 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4c4:	0019079b          	addiw	a5,s2,1
 4c8:	893e                	mv	s2,a5
 4ca:	873e                	mv	a4,a5
 4cc:	97d2                	add	a5,a5,s4
 4ce:	0007c483          	lbu	s1,0(a5)
 4d2:	1c048a63          	beqz	s1,6a6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4d6:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4da:	fe0993e3          	bnez	s3,4c0 <vprintf+0x40>
      if(c0 == '%'){
 4de:	fd579ce3          	bne	a5,s5,4b6 <vprintf+0x36>
        state = '%';
 4e2:	89be                	mv	s3,a5
 4e4:	b7c5                	j	4c4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e6:	00ea06b3          	add	a3,s4,a4
 4ea:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4ee:	1c060863          	beqz	a2,6be <vprintf+0x23e>
      if(c0 == 'd'){
 4f2:	03878763          	beq	a5,s8,520 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f6:	f9478693          	addi	a3,a5,-108
 4fa:	0016b693          	seqz	a3,a3
 4fe:	f9c60593          	addi	a1,a2,-100
 502:	e99d                	bnez	a1,538 <vprintf+0xb8>
 504:	ca95                	beqz	a3,538 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 506:	008b8493          	addi	s1,s7,8
 50a:	4685                	li	a3,1
 50c:	4629                	li	a2,10
 50e:	000bb583          	ld	a1,0(s7)
 512:	855a                	mv	a0,s6
 514:	ec9ff0ef          	jal	3dc <printint>
        i += 1;
 518:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 51a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 51c:	4981                	li	s3,0
 51e:	b75d                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 520:	008b8493          	addi	s1,s7,8
 524:	4685                	li	a3,1
 526:	4629                	li	a2,10
 528:	000ba583          	lw	a1,0(s7)
 52c:	855a                	mv	a0,s6
 52e:	eafff0ef          	jal	3dc <printint>
 532:	8ba6                	mv	s7,s1
      state = 0;
 534:	4981                	li	s3,0
 536:	b779                	j	4c4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 538:	9752                	add	a4,a4,s4
 53a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53e:	f9460713          	addi	a4,a2,-108
 542:	00173713          	seqz	a4,a4
 546:	8f75                	and	a4,a4,a3
 548:	f9c58513          	addi	a0,a1,-100
 54c:	18051363          	bnez	a0,6d2 <vprintf+0x252>
 550:	18070163          	beqz	a4,6d2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 554:	008b8493          	addi	s1,s7,8
 558:	4685                	li	a3,1
 55a:	4629                	li	a2,10
 55c:	000bb583          	ld	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	e7bff0ef          	jal	3dc <printint>
        i += 2;
 566:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
        i += 2;
 56c:	bfa1                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 56e:	008b8493          	addi	s1,s7,8
 572:	4681                	li	a3,0
 574:	4629                	li	a2,10
 576:	000be583          	lwu	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e61ff0ef          	jal	3dc <printint>
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
 584:	b781                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	008b8493          	addi	s1,s7,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000bb583          	ld	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e49ff0ef          	jal	3dc <printint>
        i += 1;
 598:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b71d                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	008b8493          	addi	s1,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4629                	li	a2,10
 5a8:	000bb583          	ld	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e2fff0ef          	jal	3dc <printint>
        i += 2;
 5b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	b731                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000be583          	lwu	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e15ff0ef          	jal	3dc <printint>
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bdd5                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4641                	li	a2,16
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	dfdff0ef          	jal	3dc <printint>
        i += 1;
 5e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bde9                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4641                	li	a2,16
 5f4:	000bb583          	ld	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	de3ff0ef          	jal	3dc <printint>
        i += 2;
 5fe:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	b5c1                	j	4c4 <vprintf+0x44>
 606:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 608:	008b8793          	addi	a5,s7,8
 60c:	8cbe                	mv	s9,a5
 60e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 612:	03000593          	li	a1,48
 616:	855a                	mv	a0,s6
 618:	da7ff0ef          	jal	3be <putc>
  putc(fd, 'x');
 61c:	07800593          	li	a1,120
 620:	855a                	mv	a0,s6
 622:	d9dff0ef          	jal	3be <putc>
 626:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 628:	00000b97          	auipc	s7,0x0
 62c:	338b8b93          	addi	s7,s7,824 # 960 <digits>
 630:	03c9d793          	srli	a5,s3,0x3c
 634:	97de                	add	a5,a5,s7
 636:	0007c583          	lbu	a1,0(a5)
 63a:	855a                	mv	a0,s6
 63c:	d83ff0ef          	jal	3be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 640:	0992                	slli	s3,s3,0x4
 642:	34fd                	addiw	s1,s1,-1
 644:	f4f5                	bnez	s1,630 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 646:	8be6                	mv	s7,s9
      state = 0;
 648:	4981                	li	s3,0
 64a:	6ca2                	ld	s9,8(sp)
 64c:	bda5                	j	4c4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 64e:	008b8493          	addi	s1,s7,8
 652:	000bc583          	lbu	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	d67ff0ef          	jal	3be <putc>
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
 660:	b595                	j	4c4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 662:	008b8993          	addi	s3,s7,8
 666:	000bb483          	ld	s1,0(s7)
 66a:	cc91                	beqz	s1,686 <vprintf+0x206>
        for(; *s; s++)
 66c:	0004c583          	lbu	a1,0(s1)
 670:	c985                	beqz	a1,6a0 <vprintf+0x220>
          putc(fd, *s);
 672:	855a                	mv	a0,s6
 674:	d4bff0ef          	jal	3be <putc>
        for(; *s; s++)
 678:	0485                	addi	s1,s1,1
 67a:	0004c583          	lbu	a1,0(s1)
 67e:	f9f5                	bnez	a1,672 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	b581                	j	4c4 <vprintf+0x44>
          s = "(null)";
 686:	00000497          	auipc	s1,0x0
 68a:	2d248493          	addi	s1,s1,722 # 958 <malloc+0x136>
        for(; *s; s++)
 68e:	02800593          	li	a1,40
 692:	b7c5                	j	672 <vprintf+0x1f2>
        putc(fd, '%');
 694:	85be                	mv	a1,a5
 696:	855a                	mv	a0,s6
 698:	d27ff0ef          	jal	3be <putc>
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b51d                	j	4c4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a0:	8bce                	mv	s7,s3
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b505                	j	4c4 <vprintf+0x44>
 6a6:	6906                	ld	s2,64(sp)
 6a8:	79e2                	ld	s3,56(sp)
 6aa:	7a42                	ld	s4,48(sp)
 6ac:	7aa2                	ld	s5,40(sp)
 6ae:	7b02                	ld	s6,32(sp)
 6b0:	6be2                	ld	s7,24(sp)
 6b2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6b4:	60e6                	ld	ra,88(sp)
 6b6:	6446                	ld	s0,80(sp)
 6b8:	64a6                	ld	s1,72(sp)
 6ba:	6125                	addi	sp,sp,96
 6bc:	8082                	ret
      if(c0 == 'd'){
 6be:	06400713          	li	a4,100
 6c2:	e4e78fe3          	beq	a5,a4,520 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6c6:	f9478693          	addi	a3,a5,-108
 6ca:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6ce:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d0:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6d2:	07500513          	li	a0,117
 6d6:	e8a78ce3          	beq	a5,a0,56e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6da:	f8b60513          	addi	a0,a2,-117
 6de:	e119                	bnez	a0,6e4 <vprintf+0x264>
 6e0:	ea0693e3          	bnez	a3,586 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e4:	f8b58513          	addi	a0,a1,-117
 6e8:	e119                	bnez	a0,6ee <vprintf+0x26e>
 6ea:	ea071be3          	bnez	a4,5a0 <vprintf+0x120>
      } else if(c0 == 'x'){
 6ee:	07800513          	li	a0,120
 6f2:	eca784e3          	beq	a5,a0,5ba <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6f6:	f8860613          	addi	a2,a2,-120
 6fa:	e219                	bnez	a2,700 <vprintf+0x280>
 6fc:	ec069be3          	bnez	a3,5d2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 700:	f8858593          	addi	a1,a1,-120
 704:	e199                	bnez	a1,70a <vprintf+0x28a>
 706:	ee0713e3          	bnez	a4,5ec <vprintf+0x16c>
      } else if(c0 == 'p'){
 70a:	07000713          	li	a4,112
 70e:	eee78ce3          	beq	a5,a4,606 <vprintf+0x186>
      } else if(c0 == 'c'){
 712:	06300713          	li	a4,99
 716:	f2e78ce3          	beq	a5,a4,64e <vprintf+0x1ce>
      } else if(c0 == 's'){
 71a:	07300713          	li	a4,115
 71e:	f4e782e3          	beq	a5,a4,662 <vprintf+0x1e2>
      } else if(c0 == '%'){
 722:	02500713          	li	a4,37
 726:	f6e787e3          	beq	a5,a4,694 <vprintf+0x214>
        putc(fd, '%');
 72a:	02500593          	li	a1,37
 72e:	855a                	mv	a0,s6
 730:	c8fff0ef          	jal	3be <putc>
        putc(fd, c0);
 734:	85a6                	mv	a1,s1
 736:	855a                	mv	a0,s6
 738:	c87ff0ef          	jal	3be <putc>
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b359                	j	4c4 <vprintf+0x44>

0000000000000740 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 740:	715d                	addi	sp,sp,-80
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	addi	s0,sp,32
 748:	e010                	sd	a2,0(s0)
 74a:	e414                	sd	a3,8(s0)
 74c:	e818                	sd	a4,16(s0)
 74e:	ec1c                	sd	a5,24(s0)
 750:	03043023          	sd	a6,32(s0)
 754:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 758:	8622                	mv	a2,s0
 75a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 75e:	d23ff0ef          	jal	480 <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6161                	addi	sp,sp,80
 768:	8082                	ret

000000000000076a <printf>:

void
printf(const char *fmt, ...)
{
 76a:	711d                	addi	sp,sp,-96
 76c:	ec06                	sd	ra,24(sp)
 76e:	e822                	sd	s0,16(sp)
 770:	1000                	addi	s0,sp,32
 772:	e40c                	sd	a1,8(s0)
 774:	e810                	sd	a2,16(s0)
 776:	ec14                	sd	a3,24(s0)
 778:	f018                	sd	a4,32(s0)
 77a:	f41c                	sd	a5,40(s0)
 77c:	03043823          	sd	a6,48(s0)
 780:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 784:	00840613          	addi	a2,s0,8
 788:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78c:	85aa                	mv	a1,a0
 78e:	4505                	li	a0,1
 790:	cf1ff0ef          	jal	480 <vprintf>
}
 794:	60e2                	ld	ra,24(sp)
 796:	6442                	ld	s0,16(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret

000000000000079c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79c:	1141                	addi	sp,sp,-16
 79e:	e406                	sd	ra,8(sp)
 7a0:	e022                	sd	s0,0(sp)
 7a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	00001797          	auipc	a5,0x1
 7ac:	8587b783          	ld	a5,-1960(a5) # 1000 <freep>
 7b0:	a039                	j	7be <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	6398                	ld	a4,0(a5)
 7b4:	00e7e463          	bltu	a5,a4,7bc <free+0x20>
 7b8:	00e6ea63          	bltu	a3,a4,7cc <free+0x30>
{
 7bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	fed7fae3          	bgeu	a5,a3,7b2 <free+0x16>
 7c2:	6398                	ld	a4,0(a5)
 7c4:	00e6e463          	bltu	a3,a4,7cc <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	fee7eae3          	bltu	a5,a4,7bc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7cc:	ff852583          	lw	a1,-8(a0)
 7d0:	6390                	ld	a2,0(a5)
 7d2:	02059813          	slli	a6,a1,0x20
 7d6:	01c85713          	srli	a4,a6,0x1c
 7da:	9736                	add	a4,a4,a3
 7dc:	02e60563          	beq	a2,a4,806 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7e4:	4790                	lw	a2,8(a5)
 7e6:	02061593          	slli	a1,a2,0x20
 7ea:	01c5d713          	srli	a4,a1,0x1c
 7ee:	973e                	add	a4,a4,a5
 7f0:	02e68263          	beq	a3,a4,814 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73523          	sd	a5,-2038(a4) # 1000 <freep>
}
 7fe:	60a2                	ld	ra,8(sp)
 800:	6402                	ld	s0,0(sp)
 802:	0141                	addi	sp,sp,16
 804:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 806:	4618                	lw	a4,8(a2)
 808:	9f2d                	addw	a4,a4,a1
 80a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	6310                	ld	a2,0(a4)
 812:	b7f9                	j	7e0 <free+0x44>
    p->s.size += bp->s.size;
 814:	ff852703          	lw	a4,-8(a0)
 818:	9f31                	addw	a4,a4,a2
 81a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81c:	ff053683          	ld	a3,-16(a0)
 820:	bfd1                	j	7f4 <free+0x58>

0000000000000822 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 822:	7139                	addi	sp,sp,-64
 824:	fc06                	sd	ra,56(sp)
 826:	f822                	sd	s0,48(sp)
 828:	f04a                	sd	s2,32(sp)
 82a:	ec4e                	sd	s3,24(sp)
 82c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82e:	02051993          	slli	s3,a0,0x20
 832:	0209d993          	srli	s3,s3,0x20
 836:	09bd                	addi	s3,s3,15
 838:	0049d993          	srli	s3,s3,0x4
 83c:	2985                	addiw	s3,s3,1
 83e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 840:	00000517          	auipc	a0,0x0
 844:	7c053503          	ld	a0,1984(a0) # 1000 <freep>
 848:	c905                	beqz	a0,878 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	09377663          	bgeu	a4,s3,8da <malloc+0xb8>
 852:	f426                	sd	s1,40(sp)
 854:	e852                	sd	s4,16(sp)
 856:	e456                	sd	s5,8(sp)
 858:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 85a:	8a4e                	mv	s4,s3
 85c:	6705                	lui	a4,0x1
 85e:	00e9f363          	bgeu	s3,a4,864 <malloc+0x42>
 862:	6a05                	lui	s4,0x1
 864:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 868:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86c:	00000497          	auipc	s1,0x0
 870:	79448493          	addi	s1,s1,1940 # 1000 <freep>
  if(p == SBRK_ERROR)
 874:	5afd                	li	s5,-1
 876:	a83d                	j	8b4 <malloc+0x92>
 878:	f426                	sd	s1,40(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 880:	00000797          	auipc	a5,0x0
 884:	79078793          	addi	a5,a5,1936 # 1010 <base>
 888:	00000717          	auipc	a4,0x0
 88c:	76f73c23          	sd	a5,1912(a4) # 1000 <freep>
 890:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 892:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 896:	b7d1                	j	85a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	a899                	j	8f2 <malloc+0xd0>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a2:	0541                	addi	a0,a0,16
 8a4:	ef9ff0ef          	jal	79c <free>
  return freep;
 8a8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8aa:	c125                	beqz	a0,90a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	03277163          	bgeu	a4,s2,8d2 <malloc+0xb0>
    if(p == freep)
 8b4:	6098                	ld	a4,0(s1)
 8b6:	853e                	mv	a0,a5
 8b8:	fef71ae3          	bne	a4,a5,8ac <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8bc:	8552                	mv	a0,s4
 8be:	a2dff0ef          	jal	2ea <sbrk>
  if(p == SBRK_ERROR)
 8c2:	fd551ee3          	bne	a0,s5,89e <malloc+0x7c>
        return 0;
 8c6:	4501                	li	a0,0
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
 8d0:	a03d                	j	8fe <malloc+0xdc>
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8da:	fae90fe3          	beq	s2,a4,898 <malloc+0x76>
        p->s.size -= nunits;
 8de:	4137073b          	subw	a4,a4,s3
 8e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e4:	02071693          	slli	a3,a4,0x20
 8e8:	01c6d713          	srli	a4,a3,0x1c
 8ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70a73723          	sd	a0,1806(a4) # 1000 <freep>
      return (void*)(p + 1);
 8fa:	01078513          	addi	a0,a5,16
  }
}
 8fe:	70e2                	ld	ra,56(sp)
 900:	7442                	ld	s0,48(sp)
 902:	7902                	ld	s2,32(sp)
 904:	69e2                	ld	s3,24(sp)
 906:	6121                	addi	sp,sp,64
 908:	8082                	ret
 90a:	74a2                	ld	s1,40(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
 912:	b7f5                	j	8fe <malloc+0xdc>
