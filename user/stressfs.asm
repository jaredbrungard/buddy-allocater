
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	9b278793          	addi	a5,a5,-1614 # 9d0 <malloc+0x124>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	96c50513          	addi	a0,a0,-1684 # 9a0 <malloc+0xf4>
  3c:	7b8000ef          	jal	7f4 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	12a000ef          	jal	176 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	344000ef          	jal	398 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for(i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	95450513          	addi	a0,a0,-1708 # 9b8 <malloc+0x10c>
  6c:	788000ef          	jal	7f4 <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	35e000ef          	jal	3e0 <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	328000ef          	jal	3c0 <write>
  for(i = 0; i < 20; i++)
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	326000ef          	jal	3c8 <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	92250513          	addi	a0,a0,-1758 # 9c8 <malloc+0x11c>
  ae:	746000ef          	jal	7f4 <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	328000ef          	jal	3e0 <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2ea000ef          	jal	3b8 <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	2f0000ef          	jal	3c8 <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2ca000ef          	jal	3a8 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2bc000ef          	jal	3a0 <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
  f0:	f11ff0ef          	jal	0 <main>
  exit(0);
  f4:	4501                	li	a0,0
  f6:	2aa000ef          	jal	3a0 <exit>

00000000000000fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0xa>
    ;
  return os;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 122:	00054783          	lbu	a5,0(a0)
 126:	cb91                	beqz	a5,13a <strcmp+0x20>
 128:	0005c703          	lbu	a4,0(a1)
 12c:	00f71763          	bne	a4,a5,13a <strcmp+0x20>
    p++, q++;
 130:	0505                	addi	a0,a0,1
 132:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	fbe5                	bnez	a5,128 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 13a:	0005c503          	lbu	a0,0(a1)
}
 13e:	40a7853b          	subw	a0,a5,a0
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strlen>:

uint
strlen(const char *s)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 152:	00054783          	lbu	a5,0(a0)
 156:	cf91                	beqz	a5,172 <strlen+0x28>
 158:	00150793          	addi	a5,a0,1
 15c:	86be                	mv	a3,a5
 15e:	0785                	addi	a5,a5,1
 160:	fff7c703          	lbu	a4,-1(a5)
 164:	ff65                	bnez	a4,15c <strlen+0x12>
 166:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  for(n = 0; s[n]; n++)
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strlen+0x20>

0000000000000176 <memset>:

void*
memset(void *dst, int c, uint n)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17e:	ca19                	beqz	a2,194 <memset+0x1e>
 180:	87aa                	mv	a5,a0
 182:	1602                	slli	a2,a2,0x20
 184:	9201                	srli	a2,a2,0x20
 186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18e:	0785                	addi	a5,a5,1
 190:	fee79de3          	bne	a5,a4,18a <memset+0x14>
  }
  return dst;
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cf81                	beqz	a5,1c0 <strchr+0x24>
    if(*s == c)
 1aa:	00f58763          	beq	a1,a5,1b8 <strchr+0x1c>
  for(; *s; s++)
 1ae:	0505                	addi	a0,a0,1
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbfd                	bnez	a5,1aa <strchr+0xe>
      return (char*)s;
  return 0;
 1b6:	4501                	li	a0,0
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  return 0;
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strchr+0x1c>

00000000000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	711d                	addi	sp,sp,-96
 1c6:	ec86                	sd	ra,88(sp)
 1c8:	e8a2                	sd	s0,80(sp)
 1ca:	e4a6                	sd	s1,72(sp)
 1cc:	e0ca                	sd	s2,64(sp)
 1ce:	fc4e                	sd	s3,56(sp)
 1d0:	f852                	sd	s4,48(sp)
 1d2:	f456                	sd	s5,40(sp)
 1d4:	f05a                	sd	s6,32(sp)
 1d6:	ec5e                	sd	s7,24(sp)
 1d8:	e862                	sd	s8,16(sp)
 1da:	1080                	addi	s0,sp,96
 1dc:	8baa                	mv	s7,a0
 1de:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	892a                	mv	s2,a0
 1e2:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e4:	faf40b13          	addi	s6,s0,-81
 1e8:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1ea:	8c26                	mv	s8,s1
 1ec:	0014899b          	addiw	s3,s1,1
 1f0:	84ce                	mv	s1,s3
 1f2:	0349d463          	bge	s3,s4,21a <gets+0x56>
    cc = read(0, &c, 1);
 1f6:	8656                	mv	a2,s5
 1f8:	85da                	mv	a1,s6
 1fa:	4501                	li	a0,0
 1fc:	1bc000ef          	jal	3b8 <read>
    if(cc < 1)
 200:	00a05d63          	blez	a0,21a <gets+0x56>
      break;
    buf[i++] = c;
 204:	faf44783          	lbu	a5,-81(s0)
 208:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20c:	0905                	addi	s2,s2,1
 20e:	ff678713          	addi	a4,a5,-10
 212:	c319                	beqz	a4,218 <gets+0x54>
 214:	17cd                	addi	a5,a5,-13
 216:	fbf1                	bnez	a5,1ea <gets+0x26>
    buf[i++] = c;
 218:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 21a:	9c5e                	add	s8,s8,s7
 21c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 220:	855e                	mv	a0,s7
 222:	60e6                	ld	ra,88(sp)
 224:	6446                	ld	s0,80(sp)
 226:	64a6                	ld	s1,72(sp)
 228:	6906                	ld	s2,64(sp)
 22a:	79e2                	ld	s3,56(sp)
 22c:	7a42                	ld	s4,48(sp)
 22e:	7aa2                	ld	s5,40(sp)
 230:	7b02                	ld	s6,32(sp)
 232:	6be2                	ld	s7,24(sp)
 234:	6c42                	ld	s8,16(sp)
 236:	6125                	addi	sp,sp,96
 238:	8082                	ret

000000000000023a <stat>:

int
stat(const char *n, struct stat *st)
{
 23a:	1101                	addi	sp,sp,-32
 23c:	ec06                	sd	ra,24(sp)
 23e:	e822                	sd	s0,16(sp)
 240:	e04a                	sd	s2,0(sp)
 242:	1000                	addi	s0,sp,32
 244:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 246:	4581                	li	a1,0
 248:	198000ef          	jal	3e0 <open>
  if(fd < 0)
 24c:	02054263          	bltz	a0,270 <stat+0x36>
 250:	e426                	sd	s1,8(sp)
 252:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 254:	85ca                	mv	a1,s2
 256:	1a2000ef          	jal	3f8 <fstat>
 25a:	892a                	mv	s2,a0
  close(fd);
 25c:	8526                	mv	a0,s1
 25e:	16a000ef          	jal	3c8 <close>
  return r;
 262:	64a2                	ld	s1,8(sp)
}
 264:	854a                	mv	a0,s2
 266:	60e2                	ld	ra,24(sp)
 268:	6442                	ld	s0,16(sp)
 26a:	6902                	ld	s2,0(sp)
 26c:	6105                	addi	sp,sp,32
 26e:	8082                	ret
    return -1;
 270:	57fd                	li	a5,-1
 272:	893e                	mv	s2,a5
 274:	bfc5                	j	264 <stat+0x2a>

0000000000000276 <atoi>:

int
atoi(const char *s)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27e:	00054683          	lbu	a3,0(a0)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	4625                	li	a2,9
 28c:	02f66963          	bltu	a2,a5,2be <atoi+0x48>
 290:	872a                	mv	a4,a0
  n = 0;
 292:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 294:	0705                	addi	a4,a4,1
 296:	0025179b          	slliw	a5,a0,0x2
 29a:	9fa9                	addw	a5,a5,a0
 29c:	0017979b          	slliw	a5,a5,0x1
 2a0:	9fb5                	addw	a5,a5,a3
 2a2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a6:	00074683          	lbu	a3,0(a4)
 2aa:	fd06879b          	addiw	a5,a3,-48
 2ae:	0ff7f793          	zext.b	a5,a5
 2b2:	fef671e3          	bgeu	a2,a5,294 <atoi+0x1e>
  return n;
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  n = 0;
 2be:	4501                	li	a0,0
 2c0:	bfdd                	j	2b6 <atoi+0x40>

00000000000002c2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ca:	02b57563          	bgeu	a0,a1,2f4 <memmove+0x32>
    while(n-- > 0)
 2ce:	00c05f63          	blez	a2,2ec <memmove+0x2a>
 2d2:	1602                	slli	a2,a2,0x20
 2d4:	9201                	srli	a2,a2,0x20
 2d6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2da:	872a                	mv	a4,a0
      *dst++ = *src++;
 2dc:	0585                	addi	a1,a1,1
 2de:	0705                	addi	a4,a4,1
 2e0:	fff5c683          	lbu	a3,-1(a1)
 2e4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e8:	fee79ae3          	bne	a5,a4,2dc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
    while(n-- > 0)
 2f4:	fec05ce3          	blez	a2,2ec <memmove+0x2a>
    dst += n;
 2f8:	00c50733          	add	a4,a0,a2
    src += n;
 2fc:	95b2                	add	a1,a1,a2
 2fe:	fff6079b          	addiw	a5,a2,-1
 302:	1782                	slli	a5,a5,0x20
 304:	9381                	srli	a5,a5,0x20
 306:	fff7c793          	not	a5,a5
 30a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30c:	15fd                	addi	a1,a1,-1
 30e:	177d                	addi	a4,a4,-1
 310:	0005c683          	lbu	a3,0(a1)
 314:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 318:	fef71ae3          	bne	a4,a5,30c <memmove+0x4a>
 31c:	bfc1                	j	2ec <memmove+0x2a>

000000000000031e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e406                	sd	ra,8(sp)
 322:	e022                	sd	s0,0(sp)
 324:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 326:	c61d                	beqz	a2,354 <memcmp+0x36>
 328:	1602                	slli	a2,a2,0x20
 32a:	9201                	srli	a2,a2,0x20
 32c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 330:	00054783          	lbu	a5,0(a0)
 334:	0005c703          	lbu	a4,0(a1)
 338:	00e79863          	bne	a5,a4,348 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 33c:	0505                	addi	a0,a0,1
    p2++;
 33e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 340:	fed518e3          	bne	a0,a3,330 <memcmp+0x12>
  }
  return 0;
 344:	4501                	li	a0,0
 346:	a019                	j	34c <memcmp+0x2e>
      return *p1 - *p2;
 348:	40e7853b          	subw	a0,a5,a4
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
  return 0;
 354:	4501                	li	a0,0
 356:	bfdd                	j	34c <memcmp+0x2e>

0000000000000358 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e406                	sd	ra,8(sp)
 35c:	e022                	sd	s0,0(sp)
 35e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 360:	f63ff0ef          	jal	2c2 <memmove>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <sbrk>:

char *
sbrk(int n) {
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 374:	4585                	li	a1,1
 376:	0b2000ef          	jal	428 <sys_sbrk>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <sbrklazy>:

char *
sbrklazy(int n) {
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 38a:	4589                	li	a1,2
 38c:	09c000ef          	jal	428 <sys_sbrk>
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 398:	4885                	li	a7,1
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a0:	4889                	li	a7,2
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a8:	488d                	li	a7,3
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b0:	4891                	li	a7,4
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <read>:
.global read
read:
 li a7, SYS_read
 3b8:	4895                	li	a7,5
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <write>:
.global write
write:
 li a7, SYS_write
 3c0:	48c1                	li	a7,16
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <close>:
.global close
close:
 li a7, SYS_close
 3c8:	48d5                	li	a7,21
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d0:	4899                	li	a7,6
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d8:	489d                	li	a7,7
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <open>:
.global open
open:
 li a7, SYS_open
 3e0:	48bd                	li	a7,15
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e8:	48c5                	li	a7,17
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f0:	48c9                	li	a7,18
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f8:	48a1                	li	a7,8
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <link>:
.global link
link:
 li a7, SYS_link
 400:	48cd                	li	a7,19
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 408:	48d1                	li	a7,20
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 410:	48a5                	li	a7,9
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <dup>:
.global dup
dup:
 li a7, SYS_dup
 418:	48a9                	li	a7,10
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 420:	48ad                	li	a7,11
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 428:	48b1                	li	a7,12
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <pause>:
.global pause
pause:
 li a7, SYS_pause
 430:	48b5                	li	a7,13
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 438:	48b9                	li	a7,14
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 440:	48d9                	li	a7,22
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	1000                	addi	s0,sp,32
 450:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 454:	4605                	li	a2,1
 456:	fef40593          	addi	a1,s0,-17
 45a:	f67ff0ef          	jal	3c0 <write>
}
 45e:	60e2                	ld	ra,24(sp)
 460:	6442                	ld	s0,16(sp)
 462:	6105                	addi	sp,sp,32
 464:	8082                	ret

0000000000000466 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 466:	715d                	addi	sp,sp,-80
 468:	e486                	sd	ra,72(sp)
 46a:	e0a2                	sd	s0,64(sp)
 46c:	f84a                	sd	s2,48(sp)
 46e:	f44e                	sd	s3,40(sp)
 470:	0880                	addi	s0,sp,80
 472:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 474:	cac1                	beqz	a3,504 <printint+0x9e>
 476:	0805d763          	bgez	a1,504 <printint+0x9e>
    neg = 1;
    x = -xx;
 47a:	40b005bb          	negw	a1,a1
    neg = 1;
 47e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 480:	fb840993          	addi	s3,s0,-72
  neg = 0;
 484:	86ce                	mv	a3,s3
  i = 0;
 486:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 488:	00000817          	auipc	a6,0x0
 48c:	56080813          	addi	a6,a6,1376 # 9e8 <digits>
 490:	88ba                	mv	a7,a4
 492:	0017051b          	addiw	a0,a4,1
 496:	872a                	mv	a4,a0
 498:	02c5f7bb          	remuw	a5,a1,a2
 49c:	1782                	slli	a5,a5,0x20
 49e:	9381                	srli	a5,a5,0x20
 4a0:	97c2                	add	a5,a5,a6
 4a2:	0007c783          	lbu	a5,0(a5)
 4a6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4aa:	87ae                	mv	a5,a1
 4ac:	02c5d5bb          	divuw	a1,a1,a2
 4b0:	0685                	addi	a3,a3,1
 4b2:	fcc7ffe3          	bgeu	a5,a2,490 <printint+0x2a>
  if(neg)
 4b6:	00030c63          	beqz	t1,4ce <printint+0x68>
    buf[i++] = '-';
 4ba:	fd050793          	addi	a5,a0,-48
 4be:	00878533          	add	a0,a5,s0
 4c2:	02d00793          	li	a5,45
 4c6:	fef50423          	sb	a5,-24(a0)
 4ca:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ce:	02e05563          	blez	a4,4f8 <printint+0x92>
 4d2:	fc26                	sd	s1,56(sp)
 4d4:	377d                	addiw	a4,a4,-1
 4d6:	00e984b3          	add	s1,s3,a4
 4da:	19fd                	addi	s3,s3,-1
 4dc:	99ba                	add	s3,s3,a4
 4de:	1702                	slli	a4,a4,0x20
 4e0:	9301                	srli	a4,a4,0x20
 4e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e6:	0004c583          	lbu	a1,0(s1)
 4ea:	854a                	mv	a0,s2
 4ec:	f5dff0ef          	jal	448 <putc>
  while(--i >= 0)
 4f0:	14fd                	addi	s1,s1,-1
 4f2:	ff349ae3          	bne	s1,s3,4e6 <printint+0x80>
 4f6:	74e2                	ld	s1,56(sp)
}
 4f8:	60a6                	ld	ra,72(sp)
 4fa:	6406                	ld	s0,64(sp)
 4fc:	7942                	ld	s2,48(sp)
 4fe:	79a2                	ld	s3,40(sp)
 500:	6161                	addi	sp,sp,80
 502:	8082                	ret
    x = xx;
 504:	2581                	sext.w	a1,a1
  neg = 0;
 506:	4301                	li	t1,0
 508:	bfa5                	j	480 <printint+0x1a>

000000000000050a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50a:	711d                	addi	sp,sp,-96
 50c:	ec86                	sd	ra,88(sp)
 50e:	e8a2                	sd	s0,80(sp)
 510:	e4a6                	sd	s1,72(sp)
 512:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 514:	0005c483          	lbu	s1,0(a1)
 518:	22048363          	beqz	s1,73e <vprintf+0x234>
 51c:	e0ca                	sd	s2,64(sp)
 51e:	fc4e                	sd	s3,56(sp)
 520:	f852                	sd	s4,48(sp)
 522:	f456                	sd	s5,40(sp)
 524:	f05a                	sd	s6,32(sp)
 526:	ec5e                	sd	s7,24(sp)
 528:	e862                	sd	s8,16(sp)
 52a:	8b2a                	mv	s6,a0
 52c:	8a2e                	mv	s4,a1
 52e:	8bb2                	mv	s7,a2
  state = 0;
 530:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 532:	4901                	li	s2,0
 534:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 536:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53a:	06400c13          	li	s8,100
 53e:	a00d                	j	560 <vprintf+0x56>
        putc(fd, c0);
 540:	85a6                	mv	a1,s1
 542:	855a                	mv	a0,s6
 544:	f05ff0ef          	jal	448 <putc>
 548:	a019                	j	54e <vprintf+0x44>
    } else if(state == '%'){
 54a:	03598363          	beq	s3,s5,570 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 54e:	0019079b          	addiw	a5,s2,1
 552:	893e                	mv	s2,a5
 554:	873e                	mv	a4,a5
 556:	97d2                	add	a5,a5,s4
 558:	0007c483          	lbu	s1,0(a5)
 55c:	1c048a63          	beqz	s1,730 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 560:	0004879b          	sext.w	a5,s1
    if(state == 0){
 564:	fe0993e3          	bnez	s3,54a <vprintf+0x40>
      if(c0 == '%'){
 568:	fd579ce3          	bne	a5,s5,540 <vprintf+0x36>
        state = '%';
 56c:	89be                	mv	s3,a5
 56e:	b7c5                	j	54e <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 570:	00ea06b3          	add	a3,s4,a4
 574:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 578:	1c060863          	beqz	a2,748 <vprintf+0x23e>
      if(c0 == 'd'){
 57c:	03878763          	beq	a5,s8,5aa <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 580:	f9478693          	addi	a3,a5,-108
 584:	0016b693          	seqz	a3,a3
 588:	f9c60593          	addi	a1,a2,-100
 58c:	e99d                	bnez	a1,5c2 <vprintf+0xb8>
 58e:	ca95                	beqz	a3,5c2 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 590:	008b8493          	addi	s1,s7,8
 594:	4685                	li	a3,1
 596:	4629                	li	a2,10
 598:	000bb583          	ld	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	ec9ff0ef          	jal	466 <printint>
        i += 1;
 5a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b75d                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	eafff0ef          	jal	466 <printint>
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b779                	j	54e <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5c2:	9752                	add	a4,a4,s4
 5c4:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c8:	f9460713          	addi	a4,a2,-108
 5cc:	00173713          	seqz	a4,a4
 5d0:	8f75                	and	a4,a4,a3
 5d2:	f9c58513          	addi	a0,a1,-100
 5d6:	18051363          	bnez	a0,75c <vprintf+0x252>
 5da:	18070163          	beqz	a4,75c <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000bb583          	ld	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e7bff0ef          	jal	466 <printint>
        i += 2;
 5f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	bfa1                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000be583          	lwu	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e61ff0ef          	jal	466 <printint>
 60a:	8ba6                	mv	s7,s1
      state = 0;
 60c:	4981                	li	s3,0
 60e:	b781                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	008b8493          	addi	s1,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e49ff0ef          	jal	466 <printint>
        i += 1;
 622:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
 628:	b71d                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e2fff0ef          	jal	466 <printint>
        i += 2;
 63c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	b731                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000be583          	lwu	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	e15ff0ef          	jal	466 <printint>
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
 65a:	bdd5                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8493          	addi	s1,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dfdff0ef          	jal	466 <printint>
        i += 1;
 66e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	bde9                	j	54e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	008b8493          	addi	s1,s7,8
 67a:	4681                	li	a3,0
 67c:	4641                	li	a2,16
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	de3ff0ef          	jal	466 <printint>
        i += 2;
 688:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
        i += 2;
 68e:	b5c1                	j	54e <vprintf+0x44>
 690:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 692:	008b8793          	addi	a5,s7,8
 696:	8cbe                	mv	s9,a5
 698:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 69c:	03000593          	li	a1,48
 6a0:	855a                	mv	a0,s6
 6a2:	da7ff0ef          	jal	448 <putc>
  putc(fd, 'x');
 6a6:	07800593          	li	a1,120
 6aa:	855a                	mv	a0,s6
 6ac:	d9dff0ef          	jal	448 <putc>
 6b0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b2:	00000b97          	auipc	s7,0x0
 6b6:	336b8b93          	addi	s7,s7,822 # 9e8 <digits>
 6ba:	03c9d793          	srli	a5,s3,0x3c
 6be:	97de                	add	a5,a5,s7
 6c0:	0007c583          	lbu	a1,0(a5)
 6c4:	855a                	mv	a0,s6
 6c6:	d83ff0ef          	jal	448 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ca:	0992                	slli	s3,s3,0x4
 6cc:	34fd                	addiw	s1,s1,-1
 6ce:	f4f5                	bnez	s1,6ba <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6d0:	8be6                	mv	s7,s9
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	6ca2                	ld	s9,8(sp)
 6d6:	bda5                	j	54e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6d8:	008b8493          	addi	s1,s7,8
 6dc:	000bc583          	lbu	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d67ff0ef          	jal	448 <putc>
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b595                	j	54e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6ec:	008b8993          	addi	s3,s7,8
 6f0:	000bb483          	ld	s1,0(s7)
 6f4:	cc91                	beqz	s1,710 <vprintf+0x206>
        for(; *s; s++)
 6f6:	0004c583          	lbu	a1,0(s1)
 6fa:	c985                	beqz	a1,72a <vprintf+0x220>
          putc(fd, *s);
 6fc:	855a                	mv	a0,s6
 6fe:	d4bff0ef          	jal	448 <putc>
        for(; *s; s++)
 702:	0485                	addi	s1,s1,1
 704:	0004c583          	lbu	a1,0(s1)
 708:	f9f5                	bnez	a1,6fc <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 70a:	8bce                	mv	s7,s3
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b581                	j	54e <vprintf+0x44>
          s = "(null)";
 710:	00000497          	auipc	s1,0x0
 714:	2d048493          	addi	s1,s1,720 # 9e0 <malloc+0x134>
        for(; *s; s++)
 718:	02800593          	li	a1,40
 71c:	b7c5                	j	6fc <vprintf+0x1f2>
        putc(fd, '%');
 71e:	85be                	mv	a1,a5
 720:	855a                	mv	a0,s6
 722:	d27ff0ef          	jal	448 <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	b51d                	j	54e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 72a:	8bce                	mv	s7,s3
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b505                	j	54e <vprintf+0x44>
 730:	6906                	ld	s2,64(sp)
 732:	79e2                	ld	s3,56(sp)
 734:	7a42                	ld	s4,48(sp)
 736:	7aa2                	ld	s5,40(sp)
 738:	7b02                	ld	s6,32(sp)
 73a:	6be2                	ld	s7,24(sp)
 73c:	6c42                	ld	s8,16(sp)
    }
  }
}
 73e:	60e6                	ld	ra,88(sp)
 740:	6446                	ld	s0,80(sp)
 742:	64a6                	ld	s1,72(sp)
 744:	6125                	addi	sp,sp,96
 746:	8082                	ret
      if(c0 == 'd'){
 748:	06400713          	li	a4,100
 74c:	e4e78fe3          	beq	a5,a4,5aa <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 750:	f9478693          	addi	a3,a5,-108
 754:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 758:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 75a:	4701                	li	a4,0
      } else if(c0 == 'u'){
 75c:	07500513          	li	a0,117
 760:	e8a78ce3          	beq	a5,a0,5f8 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 764:	f8b60513          	addi	a0,a2,-117
 768:	e119                	bnez	a0,76e <vprintf+0x264>
 76a:	ea0693e3          	bnez	a3,610 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 76e:	f8b58513          	addi	a0,a1,-117
 772:	e119                	bnez	a0,778 <vprintf+0x26e>
 774:	ea071be3          	bnez	a4,62a <vprintf+0x120>
      } else if(c0 == 'x'){
 778:	07800513          	li	a0,120
 77c:	eca784e3          	beq	a5,a0,644 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 780:	f8860613          	addi	a2,a2,-120
 784:	e219                	bnez	a2,78a <vprintf+0x280>
 786:	ec069be3          	bnez	a3,65c <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 78a:	f8858593          	addi	a1,a1,-120
 78e:	e199                	bnez	a1,794 <vprintf+0x28a>
 790:	ee0713e3          	bnez	a4,676 <vprintf+0x16c>
      } else if(c0 == 'p'){
 794:	07000713          	li	a4,112
 798:	eee78ce3          	beq	a5,a4,690 <vprintf+0x186>
      } else if(c0 == 'c'){
 79c:	06300713          	li	a4,99
 7a0:	f2e78ce3          	beq	a5,a4,6d8 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7a4:	07300713          	li	a4,115
 7a8:	f4e782e3          	beq	a5,a4,6ec <vprintf+0x1e2>
      } else if(c0 == '%'){
 7ac:	02500713          	li	a4,37
 7b0:	f6e787e3          	beq	a5,a4,71e <vprintf+0x214>
        putc(fd, '%');
 7b4:	02500593          	li	a1,37
 7b8:	855a                	mv	a0,s6
 7ba:	c8fff0ef          	jal	448 <putc>
        putc(fd, c0);
 7be:	85a6                	mv	a1,s1
 7c0:	855a                	mv	a0,s6
 7c2:	c87ff0ef          	jal	448 <putc>
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	b359                	j	54e <vprintf+0x44>

00000000000007ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ca:	715d                	addi	sp,sp,-80
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e010                	sd	a2,0(s0)
 7d4:	e414                	sd	a3,8(s0)
 7d6:	e818                	sd	a4,16(s0)
 7d8:	ec1c                	sd	a5,24(s0)
 7da:	03043023          	sd	a6,32(s0)
 7de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	8622                	mv	a2,s0
 7e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e8:	d23ff0ef          	jal	50a <vprintf>
}
 7ec:	60e2                	ld	ra,24(sp)
 7ee:	6442                	ld	s0,16(sp)
 7f0:	6161                	addi	sp,sp,80
 7f2:	8082                	ret

00000000000007f4 <printf>:

void
printf(const char *fmt, ...)
{
 7f4:	711d                	addi	sp,sp,-96
 7f6:	ec06                	sd	ra,24(sp)
 7f8:	e822                	sd	s0,16(sp)
 7fa:	1000                	addi	s0,sp,32
 7fc:	e40c                	sd	a1,8(s0)
 7fe:	e810                	sd	a2,16(s0)
 800:	ec14                	sd	a3,24(s0)
 802:	f018                	sd	a4,32(s0)
 804:	f41c                	sd	a5,40(s0)
 806:	03043823          	sd	a6,48(s0)
 80a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	00840613          	addi	a2,s0,8
 812:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 816:	85aa                	mv	a1,a0
 818:	4505                	li	a0,1
 81a:	cf1ff0ef          	jal	50a <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6125                	addi	sp,sp,96
 824:	8082                	ret

0000000000000826 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 826:	1141                	addi	sp,sp,-16
 828:	e406                	sd	ra,8(sp)
 82a:	e022                	sd	s0,0(sp)
 82c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 832:	00000797          	auipc	a5,0x0
 836:	7ce7b783          	ld	a5,1998(a5) # 1000 <freep>
 83a:	a039                	j	848 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	6398                	ld	a4,0(a5)
 83e:	00e7e463          	bltu	a5,a4,846 <free+0x20>
 842:	00e6ea63          	bltu	a3,a4,856 <free+0x30>
{
 846:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	fed7fae3          	bgeu	a5,a3,83c <free+0x16>
 84c:	6398                	ld	a4,0(a5)
 84e:	00e6e463          	bltu	a3,a4,856 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	fee7eae3          	bltu	a5,a4,846 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 856:	ff852583          	lw	a1,-8(a0)
 85a:	6390                	ld	a2,0(a5)
 85c:	02059813          	slli	a6,a1,0x20
 860:	01c85713          	srli	a4,a6,0x1c
 864:	9736                	add	a4,a4,a3
 866:	02e60563          	beq	a2,a4,890 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 86a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 86e:	4790                	lw	a2,8(a5)
 870:	02061593          	slli	a1,a2,0x20
 874:	01c5d713          	srli	a4,a1,0x1c
 878:	973e                	add	a4,a4,a5
 87a:	02e68263          	beq	a3,a4,89e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 87e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
}
 888:	60a2                	ld	ra,8(sp)
 88a:	6402                	ld	s0,0(sp)
 88c:	0141                	addi	sp,sp,16
 88e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 890:	4618                	lw	a4,8(a2)
 892:	9f2d                	addw	a4,a4,a1
 894:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	6310                	ld	a2,0(a4)
 89c:	b7f9                	j	86a <free+0x44>
    p->s.size += bp->s.size;
 89e:	ff852703          	lw	a4,-8(a0)
 8a2:	9f31                	addw	a4,a4,a2
 8a4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a6:	ff053683          	ld	a3,-16(a0)
 8aa:	bfd1                	j	87e <free+0x58>

00000000000008ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ac:	7139                	addi	sp,sp,-64
 8ae:	fc06                	sd	ra,56(sp)
 8b0:	f822                	sd	s0,48(sp)
 8b2:	f04a                	sd	s2,32(sp)
 8b4:	ec4e                	sd	s3,24(sp)
 8b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b8:	02051993          	slli	s3,a0,0x20
 8bc:	0209d993          	srli	s3,s3,0x20
 8c0:	09bd                	addi	s3,s3,15
 8c2:	0049d993          	srli	s3,s3,0x4
 8c6:	2985                	addiw	s3,s3,1
 8c8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8ca:	00000517          	auipc	a0,0x0
 8ce:	73653503          	ld	a0,1846(a0) # 1000 <freep>
 8d2:	c905                	beqz	a0,902 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	09377663          	bgeu	a4,s3,964 <malloc+0xb8>
 8dc:	f426                	sd	s1,40(sp)
 8de:	e852                	sd	s4,16(sp)
 8e0:	e456                	sd	s5,8(sp)
 8e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e4:	8a4e                	mv	s4,s3
 8e6:	6705                	lui	a4,0x1
 8e8:	00e9f363          	bgeu	s3,a4,8ee <malloc+0x42>
 8ec:	6a05                	lui	s4,0x1
 8ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f6:	00000497          	auipc	s1,0x0
 8fa:	70a48493          	addi	s1,s1,1802 # 1000 <freep>
  if(p == SBRK_ERROR)
 8fe:	5afd                	li	s5,-1
 900:	a83d                	j	93e <malloc+0x92>
 902:	f426                	sd	s1,40(sp)
 904:	e852                	sd	s4,16(sp)
 906:	e456                	sd	s5,8(sp)
 908:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90a:	00000797          	auipc	a5,0x0
 90e:	70678793          	addi	a5,a5,1798 # 1010 <base>
 912:	00000717          	auipc	a4,0x0
 916:	6ef73723          	sd	a5,1774(a4) # 1000 <freep>
 91a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 920:	b7d1                	j	8e4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 922:	6398                	ld	a4,0(a5)
 924:	e118                	sd	a4,0(a0)
 926:	a899                	j	97c <malloc+0xd0>
  hp->s.size = nu;
 928:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92c:	0541                	addi	a0,a0,16
 92e:	ef9ff0ef          	jal	826 <free>
  return freep;
 932:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 934:	c125                	beqz	a0,994 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 938:	4798                	lw	a4,8(a5)
 93a:	03277163          	bgeu	a4,s2,95c <malloc+0xb0>
    if(p == freep)
 93e:	6098                	ld	a4,0(s1)
 940:	853e                	mv	a0,a5
 942:	fef71ae3          	bne	a4,a5,936 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 946:	8552                	mv	a0,s4
 948:	a25ff0ef          	jal	36c <sbrk>
  if(p == SBRK_ERROR)
 94c:	fd551ee3          	bne	a0,s5,928 <malloc+0x7c>
        return 0;
 950:	4501                	li	a0,0
 952:	74a2                	ld	s1,40(sp)
 954:	6a42                	ld	s4,16(sp)
 956:	6aa2                	ld	s5,8(sp)
 958:	6b02                	ld	s6,0(sp)
 95a:	a03d                	j	988 <malloc+0xdc>
 95c:	74a2                	ld	s1,40(sp)
 95e:	6a42                	ld	s4,16(sp)
 960:	6aa2                	ld	s5,8(sp)
 962:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 964:	fae90fe3          	beq	s2,a4,922 <malloc+0x76>
        p->s.size -= nunits;
 968:	4137073b          	subw	a4,a4,s3
 96c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96e:	02071693          	slli	a3,a4,0x20
 972:	01c6d713          	srli	a4,a3,0x1c
 976:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 978:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97c:	00000717          	auipc	a4,0x0
 980:	68a73223          	sd	a0,1668(a4) # 1000 <freep>
      return (void*)(p + 1);
 984:	01078513          	addi	a0,a5,16
  }
}
 988:	70e2                	ld	ra,56(sp)
 98a:	7442                	ld	s0,48(sp)
 98c:	7902                	ld	s2,32(sp)
 98e:	69e2                	ld	s3,24(sp)
 990:	6121                	addi	sp,sp,64
 992:	8082                	ret
 994:	74a2                	ld	s1,40(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
 99c:	b7f5                	j	988 <malloc+0xdc>
