
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
  44:	8e058593          	addi	a1,a1,-1824 # 920 <malloc+0xf6>
  48:	4509                	li	a0,2
  4a:	6fe000ef          	jal	748 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2ce000ef          	jal	31e <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	8e258593          	addi	a1,a1,-1822 # 938 <malloc+0x10e>
  5e:	4509                	li	a0,2
  60:	6e8000ef          	jal	748 <fprintf>
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

00000000000003be <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 3be:	48d9                	li	a7,22
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c6:	1101                	addi	sp,sp,-32
 3c8:	ec06                	sd	ra,24(sp)
 3ca:	e822                	sd	s0,16(sp)
 3cc:	1000                	addi	s0,sp,32
 3ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d2:	4605                	li	a2,1
 3d4:	fef40593          	addi	a1,s0,-17
 3d8:	f67ff0ef          	jal	33e <write>
}
 3dc:	60e2                	ld	ra,24(sp)
 3de:	6442                	ld	s0,16(sp)
 3e0:	6105                	addi	sp,sp,32
 3e2:	8082                	ret

00000000000003e4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3e4:	715d                	addi	sp,sp,-80
 3e6:	e486                	sd	ra,72(sp)
 3e8:	e0a2                	sd	s0,64(sp)
 3ea:	f84a                	sd	s2,48(sp)
 3ec:	f44e                	sd	s3,40(sp)
 3ee:	0880                	addi	s0,sp,80
 3f0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f2:	cac1                	beqz	a3,482 <printint+0x9e>
 3f4:	0805d763          	bgez	a1,482 <printint+0x9e>
    neg = 1;
    x = -xx;
 3f8:	40b005bb          	negw	a1,a1
    neg = 1;
 3fc:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3fe:	fb840993          	addi	s3,s0,-72
  neg = 0;
 402:	86ce                	mv	a3,s3
  i = 0;
 404:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 406:	00000817          	auipc	a6,0x0
 40a:	55a80813          	addi	a6,a6,1370 # 960 <digits>
 40e:	88ba                	mv	a7,a4
 410:	0017051b          	addiw	a0,a4,1
 414:	872a                	mv	a4,a0
 416:	02c5f7bb          	remuw	a5,a1,a2
 41a:	1782                	slli	a5,a5,0x20
 41c:	9381                	srli	a5,a5,0x20
 41e:	97c2                	add	a5,a5,a6
 420:	0007c783          	lbu	a5,0(a5)
 424:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 428:	87ae                	mv	a5,a1
 42a:	02c5d5bb          	divuw	a1,a1,a2
 42e:	0685                	addi	a3,a3,1
 430:	fcc7ffe3          	bgeu	a5,a2,40e <printint+0x2a>
  if(neg)
 434:	00030c63          	beqz	t1,44c <printint+0x68>
    buf[i++] = '-';
 438:	fd050793          	addi	a5,a0,-48
 43c:	00878533          	add	a0,a5,s0
 440:	02d00793          	li	a5,45
 444:	fef50423          	sb	a5,-24(a0)
 448:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 44c:	02e05563          	blez	a4,476 <printint+0x92>
 450:	fc26                	sd	s1,56(sp)
 452:	377d                	addiw	a4,a4,-1
 454:	00e984b3          	add	s1,s3,a4
 458:	19fd                	addi	s3,s3,-1
 45a:	99ba                	add	s3,s3,a4
 45c:	1702                	slli	a4,a4,0x20
 45e:	9301                	srli	a4,a4,0x20
 460:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 464:	0004c583          	lbu	a1,0(s1)
 468:	854a                	mv	a0,s2
 46a:	f5dff0ef          	jal	3c6 <putc>
  while(--i >= 0)
 46e:	14fd                	addi	s1,s1,-1
 470:	ff349ae3          	bne	s1,s3,464 <printint+0x80>
 474:	74e2                	ld	s1,56(sp)
}
 476:	60a6                	ld	ra,72(sp)
 478:	6406                	ld	s0,64(sp)
 47a:	7942                	ld	s2,48(sp)
 47c:	79a2                	ld	s3,40(sp)
 47e:	6161                	addi	sp,sp,80
 480:	8082                	ret
    x = xx;
 482:	2581                	sext.w	a1,a1
  neg = 0;
 484:	4301                	li	t1,0
 486:	bfa5                	j	3fe <printint+0x1a>

0000000000000488 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 488:	711d                	addi	sp,sp,-96
 48a:	ec86                	sd	ra,88(sp)
 48c:	e8a2                	sd	s0,80(sp)
 48e:	e4a6                	sd	s1,72(sp)
 490:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 492:	0005c483          	lbu	s1,0(a1)
 496:	22048363          	beqz	s1,6bc <vprintf+0x234>
 49a:	e0ca                	sd	s2,64(sp)
 49c:	fc4e                	sd	s3,56(sp)
 49e:	f852                	sd	s4,48(sp)
 4a0:	f456                	sd	s5,40(sp)
 4a2:	f05a                	sd	s6,32(sp)
 4a4:	ec5e                	sd	s7,24(sp)
 4a6:	e862                	sd	s8,16(sp)
 4a8:	8b2a                	mv	s6,a0
 4aa:	8a2e                	mv	s4,a1
 4ac:	8bb2                	mv	s7,a2
  state = 0;
 4ae:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4b0:	4901                	li	s2,0
 4b2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b8:	06400c13          	li	s8,100
 4bc:	a00d                	j	4de <vprintf+0x56>
        putc(fd, c0);
 4be:	85a6                	mv	a1,s1
 4c0:	855a                	mv	a0,s6
 4c2:	f05ff0ef          	jal	3c6 <putc>
 4c6:	a019                	j	4cc <vprintf+0x44>
    } else if(state == '%'){
 4c8:	03598363          	beq	s3,s5,4ee <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4cc:	0019079b          	addiw	a5,s2,1
 4d0:	893e                	mv	s2,a5
 4d2:	873e                	mv	a4,a5
 4d4:	97d2                	add	a5,a5,s4
 4d6:	0007c483          	lbu	s1,0(a5)
 4da:	1c048a63          	beqz	s1,6ae <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4de:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4e2:	fe0993e3          	bnez	s3,4c8 <vprintf+0x40>
      if(c0 == '%'){
 4e6:	fd579ce3          	bne	a5,s5,4be <vprintf+0x36>
        state = '%';
 4ea:	89be                	mv	s3,a5
 4ec:	b7c5                	j	4cc <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ee:	00ea06b3          	add	a3,s4,a4
 4f2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4f6:	1c060863          	beqz	a2,6c6 <vprintf+0x23e>
      if(c0 == 'd'){
 4fa:	03878763          	beq	a5,s8,528 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4fe:	f9478693          	addi	a3,a5,-108
 502:	0016b693          	seqz	a3,a3
 506:	f9c60593          	addi	a1,a2,-100
 50a:	e99d                	bnez	a1,540 <vprintf+0xb8>
 50c:	ca95                	beqz	a3,540 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50e:	008b8493          	addi	s1,s7,8
 512:	4685                	li	a3,1
 514:	4629                	li	a2,10
 516:	000bb583          	ld	a1,0(s7)
 51a:	855a                	mv	a0,s6
 51c:	ec9ff0ef          	jal	3e4 <printint>
        i += 1;
 520:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 522:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 524:	4981                	li	s3,0
 526:	b75d                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 528:	008b8493          	addi	s1,s7,8
 52c:	4685                	li	a3,1
 52e:	4629                	li	a2,10
 530:	000ba583          	lw	a1,0(s7)
 534:	855a                	mv	a0,s6
 536:	eafff0ef          	jal	3e4 <printint>
 53a:	8ba6                	mv	s7,s1
      state = 0;
 53c:	4981                	li	s3,0
 53e:	b779                	j	4cc <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 540:	9752                	add	a4,a4,s4
 542:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 546:	f9460713          	addi	a4,a2,-108
 54a:	00173713          	seqz	a4,a4
 54e:	8f75                	and	a4,a4,a3
 550:	f9c58513          	addi	a0,a1,-100
 554:	18051363          	bnez	a0,6da <vprintf+0x252>
 558:	18070163          	beqz	a4,6da <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	008b8493          	addi	s1,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000bb583          	ld	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e7bff0ef          	jal	3e4 <printint>
        i += 2;
 56e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
        i += 2;
 574:	bfa1                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 576:	008b8493          	addi	s1,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000be583          	lwu	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	e61ff0ef          	jal	3e4 <printint>
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b781                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	008b8493          	addi	s1,s7,8
 592:	4681                	li	a3,0
 594:	4629                	li	a2,10
 596:	000bb583          	ld	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e49ff0ef          	jal	3e4 <printint>
        i += 1;
 5a0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b71d                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e2fff0ef          	jal	3e4 <printint>
        i += 2;
 5ba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
        i += 2;
 5c0:	b731                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000be583          	lwu	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e15ff0ef          	jal	3e4 <printint>
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bdd5                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4681                	li	a3,0
 5e0:	4641                	li	a2,16
 5e2:	000bb583          	ld	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	dfdff0ef          	jal	3e4 <printint>
        i += 1;
 5ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bde9                	j	4cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	de3ff0ef          	jal	3e4 <printint>
        i += 2;
 606:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	b5c1                	j	4cc <vprintf+0x44>
 60e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 610:	008b8793          	addi	a5,s7,8
 614:	8cbe                	mv	s9,a5
 616:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61a:	03000593          	li	a1,48
 61e:	855a                	mv	a0,s6
 620:	da7ff0ef          	jal	3c6 <putc>
  putc(fd, 'x');
 624:	07800593          	li	a1,120
 628:	855a                	mv	a0,s6
 62a:	d9dff0ef          	jal	3c6 <putc>
 62e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 630:	00000b97          	auipc	s7,0x0
 634:	330b8b93          	addi	s7,s7,816 # 960 <digits>
 638:	03c9d793          	srli	a5,s3,0x3c
 63c:	97de                	add	a5,a5,s7
 63e:	0007c583          	lbu	a1,0(a5)
 642:	855a                	mv	a0,s6
 644:	d83ff0ef          	jal	3c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 648:	0992                	slli	s3,s3,0x4
 64a:	34fd                	addiw	s1,s1,-1
 64c:	f4f5                	bnez	s1,638 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 64e:	8be6                	mv	s7,s9
      state = 0;
 650:	4981                	li	s3,0
 652:	6ca2                	ld	s9,8(sp)
 654:	bda5                	j	4cc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 656:	008b8493          	addi	s1,s7,8
 65a:	000bc583          	lbu	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	d67ff0ef          	jal	3c6 <putc>
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
 668:	b595                	j	4cc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb483          	ld	s1,0(s7)
 672:	cc91                	beqz	s1,68e <vprintf+0x206>
        for(; *s; s++)
 674:	0004c583          	lbu	a1,0(s1)
 678:	c985                	beqz	a1,6a8 <vprintf+0x220>
          putc(fd, *s);
 67a:	855a                	mv	a0,s6
 67c:	d4bff0ef          	jal	3c6 <putc>
        for(; *s; s++)
 680:	0485                	addi	s1,s1,1
 682:	0004c583          	lbu	a1,0(s1)
 686:	f9f5                	bnez	a1,67a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b581                	j	4cc <vprintf+0x44>
          s = "(null)";
 68e:	00000497          	auipc	s1,0x0
 692:	2ca48493          	addi	s1,s1,714 # 958 <malloc+0x12e>
        for(; *s; s++)
 696:	02800593          	li	a1,40
 69a:	b7c5                	j	67a <vprintf+0x1f2>
        putc(fd, '%');
 69c:	85be                	mv	a1,a5
 69e:	855a                	mv	a0,s6
 6a0:	d27ff0ef          	jal	3c6 <putc>
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b51d                	j	4cc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b505                	j	4cc <vprintf+0x44>
 6ae:	6906                	ld	s2,64(sp)
 6b0:	79e2                	ld	s3,56(sp)
 6b2:	7a42                	ld	s4,48(sp)
 6b4:	7aa2                	ld	s5,40(sp)
 6b6:	7b02                	ld	s6,32(sp)
 6b8:	6be2                	ld	s7,24(sp)
 6ba:	6c42                	ld	s8,16(sp)
    }
  }
}
 6bc:	60e6                	ld	ra,88(sp)
 6be:	6446                	ld	s0,80(sp)
 6c0:	64a6                	ld	s1,72(sp)
 6c2:	6125                	addi	sp,sp,96
 6c4:	8082                	ret
      if(c0 == 'd'){
 6c6:	06400713          	li	a4,100
 6ca:	e4e78fe3          	beq	a5,a4,528 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6ce:	f9478693          	addi	a3,a5,-108
 6d2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6d6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d8:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6da:	07500513          	li	a0,117
 6de:	e8a78ce3          	beq	a5,a0,576 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6e2:	f8b60513          	addi	a0,a2,-117
 6e6:	e119                	bnez	a0,6ec <vprintf+0x264>
 6e8:	ea0693e3          	bnez	a3,58e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ec:	f8b58513          	addi	a0,a1,-117
 6f0:	e119                	bnez	a0,6f6 <vprintf+0x26e>
 6f2:	ea071be3          	bnez	a4,5a8 <vprintf+0x120>
      } else if(c0 == 'x'){
 6f6:	07800513          	li	a0,120
 6fa:	eca784e3          	beq	a5,a0,5c2 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6fe:	f8860613          	addi	a2,a2,-120
 702:	e219                	bnez	a2,708 <vprintf+0x280>
 704:	ec069be3          	bnez	a3,5da <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 708:	f8858593          	addi	a1,a1,-120
 70c:	e199                	bnez	a1,712 <vprintf+0x28a>
 70e:	ee0713e3          	bnez	a4,5f4 <vprintf+0x16c>
      } else if(c0 == 'p'){
 712:	07000713          	li	a4,112
 716:	eee78ce3          	beq	a5,a4,60e <vprintf+0x186>
      } else if(c0 == 'c'){
 71a:	06300713          	li	a4,99
 71e:	f2e78ce3          	beq	a5,a4,656 <vprintf+0x1ce>
      } else if(c0 == 's'){
 722:	07300713          	li	a4,115
 726:	f4e782e3          	beq	a5,a4,66a <vprintf+0x1e2>
      } else if(c0 == '%'){
 72a:	02500713          	li	a4,37
 72e:	f6e787e3          	beq	a5,a4,69c <vprintf+0x214>
        putc(fd, '%');
 732:	02500593          	li	a1,37
 736:	855a                	mv	a0,s6
 738:	c8fff0ef          	jal	3c6 <putc>
        putc(fd, c0);
 73c:	85a6                	mv	a1,s1
 73e:	855a                	mv	a0,s6
 740:	c87ff0ef          	jal	3c6 <putc>
      state = 0;
 744:	4981                	li	s3,0
 746:	b359                	j	4cc <vprintf+0x44>

0000000000000748 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 748:	715d                	addi	sp,sp,-80
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e010                	sd	a2,0(s0)
 752:	e414                	sd	a3,8(s0)
 754:	e818                	sd	a4,16(s0)
 756:	ec1c                	sd	a5,24(s0)
 758:	03043023          	sd	a6,32(s0)
 75c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	8622                	mv	a2,s0
 762:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 766:	d23ff0ef          	jal	488 <vprintf>
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6161                	addi	sp,sp,80
 770:	8082                	ret

0000000000000772 <printf>:

void
printf(const char *fmt, ...)
{
 772:	711d                	addi	sp,sp,-96
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	e40c                	sd	a1,8(s0)
 77c:	e810                	sd	a2,16(s0)
 77e:	ec14                	sd	a3,24(s0)
 780:	f018                	sd	a4,32(s0)
 782:	f41c                	sd	a5,40(s0)
 784:	03043823          	sd	a6,48(s0)
 788:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	00840613          	addi	a2,s0,8
 790:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 794:	85aa                	mv	a1,a0
 796:	4505                	li	a0,1
 798:	cf1ff0ef          	jal	488 <vprintf>
}
 79c:	60e2                	ld	ra,24(sp)
 79e:	6442                	ld	s0,16(sp)
 7a0:	6125                	addi	sp,sp,96
 7a2:	8082                	ret

00000000000007a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a4:	1141                	addi	sp,sp,-16
 7a6:	e406                	sd	ra,8(sp)
 7a8:	e022                	sd	s0,0(sp)
 7aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	00001797          	auipc	a5,0x1
 7b4:	8507b783          	ld	a5,-1968(a5) # 1000 <freep>
 7b8:	a039                	j	7c6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x20>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x30>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x16>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059813          	slli	a6,a1,0x20
 7de:	01c85713          	srli	a4,a6,0x1c
 7e2:	9736                	add	a4,a4,a3
 7e4:	02e60563          	beq	a2,a4,80e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061593          	slli	a1,a2,0x20
 7f2:	01c5d713          	srli	a4,a1,0x1c
 7f6:	973e                	add	a4,a4,a5
 7f8:	02e68263          	beq	a3,a4,81c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73123          	sd	a5,-2046(a4) # 1000 <freep>
}
 806:	60a2                	ld	ra,8(sp)
 808:	6402                	ld	s0,0(sp)
 80a:	0141                	addi	sp,sp,16
 80c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 80e:	4618                	lw	a4,8(a2)
 810:	9f2d                	addw	a4,a4,a1
 812:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	6310                	ld	a2,0(a4)
 81a:	b7f9                	j	7e8 <free+0x44>
    p->s.size += bp->s.size;
 81c:	ff852703          	lw	a4,-8(a0)
 820:	9f31                	addw	a4,a4,a2
 822:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 824:	ff053683          	ld	a3,-16(a0)
 828:	bfd1                	j	7fc <free+0x58>

000000000000082a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 82a:	7139                	addi	sp,sp,-64
 82c:	fc06                	sd	ra,56(sp)
 82e:	f822                	sd	s0,48(sp)
 830:	f04a                	sd	s2,32(sp)
 832:	ec4e                	sd	s3,24(sp)
 834:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	02051993          	slli	s3,a0,0x20
 83a:	0209d993          	srli	s3,s3,0x20
 83e:	09bd                	addi	s3,s3,15
 840:	0049d993          	srli	s3,s3,0x4
 844:	2985                	addiw	s3,s3,1
 846:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 848:	00000517          	auipc	a0,0x0
 84c:	7b853503          	ld	a0,1976(a0) # 1000 <freep>
 850:	c905                	beqz	a0,880 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 852:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 854:	4798                	lw	a4,8(a5)
 856:	09377663          	bgeu	a4,s3,8e2 <malloc+0xb8>
 85a:	f426                	sd	s1,40(sp)
 85c:	e852                	sd	s4,16(sp)
 85e:	e456                	sd	s5,8(sp)
 860:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 862:	8a4e                	mv	s4,s3
 864:	6705                	lui	a4,0x1
 866:	00e9f363          	bgeu	s3,a4,86c <malloc+0x42>
 86a:	6a05                	lui	s4,0x1
 86c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 870:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 874:	00000497          	auipc	s1,0x0
 878:	78c48493          	addi	s1,s1,1932 # 1000 <freep>
  if(p == SBRK_ERROR)
 87c:	5afd                	li	s5,-1
 87e:	a83d                	j	8bc <malloc+0x92>
 880:	f426                	sd	s1,40(sp)
 882:	e852                	sd	s4,16(sp)
 884:	e456                	sd	s5,8(sp)
 886:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 888:	00000797          	auipc	a5,0x0
 88c:	78878793          	addi	a5,a5,1928 # 1010 <base>
 890:	00000717          	auipc	a4,0x0
 894:	76f73823          	sd	a5,1904(a4) # 1000 <freep>
 898:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89e:	b7d1                	j	862 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a0:	6398                	ld	a4,0(a5)
 8a2:	e118                	sd	a4,0(a0)
 8a4:	a899                	j	8fa <malloc+0xd0>
  hp->s.size = nu;
 8a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8aa:	0541                	addi	a0,a0,16
 8ac:	ef9ff0ef          	jal	7a4 <free>
  return freep;
 8b0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8b2:	c125                	beqz	a0,912 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b6:	4798                	lw	a4,8(a5)
 8b8:	03277163          	bgeu	a4,s2,8da <malloc+0xb0>
    if(p == freep)
 8bc:	6098                	ld	a4,0(s1)
 8be:	853e                	mv	a0,a5
 8c0:	fef71ae3          	bne	a4,a5,8b4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c4:	8552                	mv	a0,s4
 8c6:	a25ff0ef          	jal	2ea <sbrk>
  if(p == SBRK_ERROR)
 8ca:	fd551ee3          	bne	a0,s5,8a6 <malloc+0x7c>
        return 0;
 8ce:	4501                	li	a0,0
 8d0:	74a2                	ld	s1,40(sp)
 8d2:	6a42                	ld	s4,16(sp)
 8d4:	6aa2                	ld	s5,8(sp)
 8d6:	6b02                	ld	s6,0(sp)
 8d8:	a03d                	j	906 <malloc+0xdc>
 8da:	74a2                	ld	s1,40(sp)
 8dc:	6a42                	ld	s4,16(sp)
 8de:	6aa2                	ld	s5,8(sp)
 8e0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8e2:	fae90fe3          	beq	s2,a4,8a0 <malloc+0x76>
        p->s.size -= nunits;
 8e6:	4137073b          	subw	a4,a4,s3
 8ea:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ec:	02071693          	slli	a3,a4,0x20
 8f0:	01c6d713          	srli	a4,a3,0x1c
 8f4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fa:	00000717          	auipc	a4,0x0
 8fe:	70a73323          	sd	a0,1798(a4) # 1000 <freep>
      return (void*)(p + 1);
 902:	01078513          	addi	a0,a5,16
  }
}
 906:	70e2                	ld	ra,56(sp)
 908:	7442                	ld	s0,48(sp)
 90a:	7902                	ld	s2,32(sp)
 90c:	69e2                	ld	s3,24(sp)
 90e:	6121                	addi	sp,sp,64
 910:	8082                	ret
 912:	74a2                	ld	s1,40(sp)
 914:	6a42                	ld	s4,16(sp)
 916:	6aa2                	ld	s5,8(sp)
 918:	6b02                	ld	s6,0(sp)
 91a:	b7f5                	j	906 <malloc+0xdc>
