
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
  22:	9b278793          	addi	a5,a5,-1614 # 9d0 <malloc+0x12c>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	96c50513          	addi	a0,a0,-1684 # 9a0 <malloc+0xfc>
  3c:	7b0000ef          	jal	7ec <printf>
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
  68:	95450513          	addi	a0,a0,-1708 # 9b8 <malloc+0x114>
  6c:	780000ef          	jal	7ec <printf>

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
  aa:	92250513          	addi	a0,a0,-1758 # 9c8 <malloc+0x124>
  ae:	73e000ef          	jal	7ec <printf>

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

0000000000000440 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 440:	1101                	addi	sp,sp,-32
 442:	ec06                	sd	ra,24(sp)
 444:	e822                	sd	s0,16(sp)
 446:	1000                	addi	s0,sp,32
 448:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44c:	4605                	li	a2,1
 44e:	fef40593          	addi	a1,s0,-17
 452:	f6fff0ef          	jal	3c0 <write>
}
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6105                	addi	sp,sp,32
 45c:	8082                	ret

000000000000045e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 45e:	715d                	addi	sp,sp,-80
 460:	e486                	sd	ra,72(sp)
 462:	e0a2                	sd	s0,64(sp)
 464:	f84a                	sd	s2,48(sp)
 466:	f44e                	sd	s3,40(sp)
 468:	0880                	addi	s0,sp,80
 46a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46c:	cac1                	beqz	a3,4fc <printint+0x9e>
 46e:	0805d763          	bgez	a1,4fc <printint+0x9e>
    neg = 1;
    x = -xx;
 472:	40b005bb          	negw	a1,a1
    neg = 1;
 476:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 478:	fb840993          	addi	s3,s0,-72
  neg = 0;
 47c:	86ce                	mv	a3,s3
  i = 0;
 47e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 480:	00000817          	auipc	a6,0x0
 484:	56880813          	addi	a6,a6,1384 # 9e8 <digits>
 488:	88ba                	mv	a7,a4
 48a:	0017051b          	addiw	a0,a4,1
 48e:	872a                	mv	a4,a0
 490:	02c5f7bb          	remuw	a5,a1,a2
 494:	1782                	slli	a5,a5,0x20
 496:	9381                	srli	a5,a5,0x20
 498:	97c2                	add	a5,a5,a6
 49a:	0007c783          	lbu	a5,0(a5)
 49e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a2:	87ae                	mv	a5,a1
 4a4:	02c5d5bb          	divuw	a1,a1,a2
 4a8:	0685                	addi	a3,a3,1
 4aa:	fcc7ffe3          	bgeu	a5,a2,488 <printint+0x2a>
  if(neg)
 4ae:	00030c63          	beqz	t1,4c6 <printint+0x68>
    buf[i++] = '-';
 4b2:	fd050793          	addi	a5,a0,-48
 4b6:	00878533          	add	a0,a5,s0
 4ba:	02d00793          	li	a5,45
 4be:	fef50423          	sb	a5,-24(a0)
 4c2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4c6:	02e05563          	blez	a4,4f0 <printint+0x92>
 4ca:	fc26                	sd	s1,56(sp)
 4cc:	377d                	addiw	a4,a4,-1
 4ce:	00e984b3          	add	s1,s3,a4
 4d2:	19fd                	addi	s3,s3,-1
 4d4:	99ba                	add	s3,s3,a4
 4d6:	1702                	slli	a4,a4,0x20
 4d8:	9301                	srli	a4,a4,0x20
 4da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4de:	0004c583          	lbu	a1,0(s1)
 4e2:	854a                	mv	a0,s2
 4e4:	f5dff0ef          	jal	440 <putc>
  while(--i >= 0)
 4e8:	14fd                	addi	s1,s1,-1
 4ea:	ff349ae3          	bne	s1,s3,4de <printint+0x80>
 4ee:	74e2                	ld	s1,56(sp)
}
 4f0:	60a6                	ld	ra,72(sp)
 4f2:	6406                	ld	s0,64(sp)
 4f4:	7942                	ld	s2,48(sp)
 4f6:	79a2                	ld	s3,40(sp)
 4f8:	6161                	addi	sp,sp,80
 4fa:	8082                	ret
    x = xx;
 4fc:	2581                	sext.w	a1,a1
  neg = 0;
 4fe:	4301                	li	t1,0
 500:	bfa5                	j	478 <printint+0x1a>

0000000000000502 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 502:	711d                	addi	sp,sp,-96
 504:	ec86                	sd	ra,88(sp)
 506:	e8a2                	sd	s0,80(sp)
 508:	e4a6                	sd	s1,72(sp)
 50a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 50c:	0005c483          	lbu	s1,0(a1)
 510:	22048363          	beqz	s1,736 <vprintf+0x234>
 514:	e0ca                	sd	s2,64(sp)
 516:	fc4e                	sd	s3,56(sp)
 518:	f852                	sd	s4,48(sp)
 51a:	f456                	sd	s5,40(sp)
 51c:	f05a                	sd	s6,32(sp)
 51e:	ec5e                	sd	s7,24(sp)
 520:	e862                	sd	s8,16(sp)
 522:	8b2a                	mv	s6,a0
 524:	8a2e                	mv	s4,a1
 526:	8bb2                	mv	s7,a2
  state = 0;
 528:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 52a:	4901                	li	s2,0
 52c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 52e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 532:	06400c13          	li	s8,100
 536:	a00d                	j	558 <vprintf+0x56>
        putc(fd, c0);
 538:	85a6                	mv	a1,s1
 53a:	855a                	mv	a0,s6
 53c:	f05ff0ef          	jal	440 <putc>
 540:	a019                	j	546 <vprintf+0x44>
    } else if(state == '%'){
 542:	03598363          	beq	s3,s5,568 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 546:	0019079b          	addiw	a5,s2,1
 54a:	893e                	mv	s2,a5
 54c:	873e                	mv	a4,a5
 54e:	97d2                	add	a5,a5,s4
 550:	0007c483          	lbu	s1,0(a5)
 554:	1c048a63          	beqz	s1,728 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 558:	0004879b          	sext.w	a5,s1
    if(state == 0){
 55c:	fe0993e3          	bnez	s3,542 <vprintf+0x40>
      if(c0 == '%'){
 560:	fd579ce3          	bne	a5,s5,538 <vprintf+0x36>
        state = '%';
 564:	89be                	mv	s3,a5
 566:	b7c5                	j	546 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 568:	00ea06b3          	add	a3,s4,a4
 56c:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 570:	1c060863          	beqz	a2,740 <vprintf+0x23e>
      if(c0 == 'd'){
 574:	03878763          	beq	a5,s8,5a2 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 578:	f9478693          	addi	a3,a5,-108
 57c:	0016b693          	seqz	a3,a3
 580:	f9c60593          	addi	a1,a2,-100
 584:	e99d                	bnez	a1,5ba <vprintf+0xb8>
 586:	ca95                	beqz	a3,5ba <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	008b8493          	addi	s1,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000bb583          	ld	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	ec9ff0ef          	jal	45e <printint>
        i += 1;
 59a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b75d                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	eafff0ef          	jal	45e <printint>
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b779                	j	546 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5ba:	9752                	add	a4,a4,s4
 5bc:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c0:	f9460713          	addi	a4,a2,-108
 5c4:	00173713          	seqz	a4,a4
 5c8:	8f75                	and	a4,a4,a3
 5ca:	f9c58513          	addi	a0,a1,-100
 5ce:	18051363          	bnez	a0,754 <vprintf+0x252>
 5d2:	18070163          	beqz	a4,754 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4685                	li	a3,1
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e7bff0ef          	jal	45e <printint>
        i += 2;
 5e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	bfa1                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4629                	li	a2,10
 5f8:	000be583          	lwu	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e61ff0ef          	jal	45e <printint>
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	b781                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4629                	li	a2,10
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e49ff0ef          	jal	45e <printint>
        i += 1;
 61a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	b71d                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e2fff0ef          	jal	45e <printint>
        i += 2;
 634:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	b731                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000be583          	lwu	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e15ff0ef          	jal	45e <printint>
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
 652:	bdd5                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8493          	addi	s1,s7,8
 658:	4681                	li	a3,0
 65a:	4641                	li	a2,16
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	dfdff0ef          	jal	45e <printint>
        i += 1;
 666:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bde9                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	de3ff0ef          	jal	45e <printint>
        i += 2;
 680:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	b5c1                	j	546 <vprintf+0x44>
 688:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 68a:	008b8793          	addi	a5,s7,8
 68e:	8cbe                	mv	s9,a5
 690:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 694:	03000593          	li	a1,48
 698:	855a                	mv	a0,s6
 69a:	da7ff0ef          	jal	440 <putc>
  putc(fd, 'x');
 69e:	07800593          	li	a1,120
 6a2:	855a                	mv	a0,s6
 6a4:	d9dff0ef          	jal	440 <putc>
 6a8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6aa:	00000b97          	auipc	s7,0x0
 6ae:	33eb8b93          	addi	s7,s7,830 # 9e8 <digits>
 6b2:	03c9d793          	srli	a5,s3,0x3c
 6b6:	97de                	add	a5,a5,s7
 6b8:	0007c583          	lbu	a1,0(a5)
 6bc:	855a                	mv	a0,s6
 6be:	d83ff0ef          	jal	440 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c2:	0992                	slli	s3,s3,0x4
 6c4:	34fd                	addiw	s1,s1,-1
 6c6:	f4f5                	bnez	s1,6b2 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6c8:	8be6                	mv	s7,s9
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	6ca2                	ld	s9,8(sp)
 6ce:	bda5                	j	546 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6d0:	008b8493          	addi	s1,s7,8
 6d4:	000bc583          	lbu	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	d67ff0ef          	jal	440 <putc>
 6de:	8ba6                	mv	s7,s1
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b595                	j	546 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	008b8993          	addi	s3,s7,8
 6e8:	000bb483          	ld	s1,0(s7)
 6ec:	cc91                	beqz	s1,708 <vprintf+0x206>
        for(; *s; s++)
 6ee:	0004c583          	lbu	a1,0(s1)
 6f2:	c985                	beqz	a1,722 <vprintf+0x220>
          putc(fd, *s);
 6f4:	855a                	mv	a0,s6
 6f6:	d4bff0ef          	jal	440 <putc>
        for(; *s; s++)
 6fa:	0485                	addi	s1,s1,1
 6fc:	0004c583          	lbu	a1,0(s1)
 700:	f9f5                	bnez	a1,6f4 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 702:	8bce                	mv	s7,s3
      state = 0;
 704:	4981                	li	s3,0
 706:	b581                	j	546 <vprintf+0x44>
          s = "(null)";
 708:	00000497          	auipc	s1,0x0
 70c:	2d848493          	addi	s1,s1,728 # 9e0 <malloc+0x13c>
        for(; *s; s++)
 710:	02800593          	li	a1,40
 714:	b7c5                	j	6f4 <vprintf+0x1f2>
        putc(fd, '%');
 716:	85be                	mv	a1,a5
 718:	855a                	mv	a0,s6
 71a:	d27ff0ef          	jal	440 <putc>
      state = 0;
 71e:	4981                	li	s3,0
 720:	b51d                	j	546 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 722:	8bce                	mv	s7,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	b505                	j	546 <vprintf+0x44>
 728:	6906                	ld	s2,64(sp)
 72a:	79e2                	ld	s3,56(sp)
 72c:	7a42                	ld	s4,48(sp)
 72e:	7aa2                	ld	s5,40(sp)
 730:	7b02                	ld	s6,32(sp)
 732:	6be2                	ld	s7,24(sp)
 734:	6c42                	ld	s8,16(sp)
    }
  }
}
 736:	60e6                	ld	ra,88(sp)
 738:	6446                	ld	s0,80(sp)
 73a:	64a6                	ld	s1,72(sp)
 73c:	6125                	addi	sp,sp,96
 73e:	8082                	ret
      if(c0 == 'd'){
 740:	06400713          	li	a4,100
 744:	e4e78fe3          	beq	a5,a4,5a2 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 748:	f9478693          	addi	a3,a5,-108
 74c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 750:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 752:	4701                	li	a4,0
      } else if(c0 == 'u'){
 754:	07500513          	li	a0,117
 758:	e8a78ce3          	beq	a5,a0,5f0 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 75c:	f8b60513          	addi	a0,a2,-117
 760:	e119                	bnez	a0,766 <vprintf+0x264>
 762:	ea0693e3          	bnez	a3,608 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 766:	f8b58513          	addi	a0,a1,-117
 76a:	e119                	bnez	a0,770 <vprintf+0x26e>
 76c:	ea071be3          	bnez	a4,622 <vprintf+0x120>
      } else if(c0 == 'x'){
 770:	07800513          	li	a0,120
 774:	eca784e3          	beq	a5,a0,63c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 778:	f8860613          	addi	a2,a2,-120
 77c:	e219                	bnez	a2,782 <vprintf+0x280>
 77e:	ec069be3          	bnez	a3,654 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 782:	f8858593          	addi	a1,a1,-120
 786:	e199                	bnez	a1,78c <vprintf+0x28a>
 788:	ee0713e3          	bnez	a4,66e <vprintf+0x16c>
      } else if(c0 == 'p'){
 78c:	07000713          	li	a4,112
 790:	eee78ce3          	beq	a5,a4,688 <vprintf+0x186>
      } else if(c0 == 'c'){
 794:	06300713          	li	a4,99
 798:	f2e78ce3          	beq	a5,a4,6d0 <vprintf+0x1ce>
      } else if(c0 == 's'){
 79c:	07300713          	li	a4,115
 7a0:	f4e782e3          	beq	a5,a4,6e4 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7a4:	02500713          	li	a4,37
 7a8:	f6e787e3          	beq	a5,a4,716 <vprintf+0x214>
        putc(fd, '%');
 7ac:	02500593          	li	a1,37
 7b0:	855a                	mv	a0,s6
 7b2:	c8fff0ef          	jal	440 <putc>
        putc(fd, c0);
 7b6:	85a6                	mv	a1,s1
 7b8:	855a                	mv	a0,s6
 7ba:	c87ff0ef          	jal	440 <putc>
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b359                	j	546 <vprintf+0x44>

00000000000007c2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c2:	715d                	addi	sp,sp,-80
 7c4:	ec06                	sd	ra,24(sp)
 7c6:	e822                	sd	s0,16(sp)
 7c8:	1000                	addi	s0,sp,32
 7ca:	e010                	sd	a2,0(s0)
 7cc:	e414                	sd	a3,8(s0)
 7ce:	e818                	sd	a4,16(s0)
 7d0:	ec1c                	sd	a5,24(s0)
 7d2:	03043023          	sd	a6,32(s0)
 7d6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7da:	8622                	mv	a2,s0
 7dc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e0:	d23ff0ef          	jal	502 <vprintf>
}
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	6161                	addi	sp,sp,80
 7ea:	8082                	ret

00000000000007ec <printf>:

void
printf(const char *fmt, ...)
{
 7ec:	711d                	addi	sp,sp,-96
 7ee:	ec06                	sd	ra,24(sp)
 7f0:	e822                	sd	s0,16(sp)
 7f2:	1000                	addi	s0,sp,32
 7f4:	e40c                	sd	a1,8(s0)
 7f6:	e810                	sd	a2,16(s0)
 7f8:	ec14                	sd	a3,24(s0)
 7fa:	f018                	sd	a4,32(s0)
 7fc:	f41c                	sd	a5,40(s0)
 7fe:	03043823          	sd	a6,48(s0)
 802:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 806:	00840613          	addi	a2,s0,8
 80a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80e:	85aa                	mv	a1,a0
 810:	4505                	li	a0,1
 812:	cf1ff0ef          	jal	502 <vprintf>
}
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6125                	addi	sp,sp,96
 81c:	8082                	ret

000000000000081e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81e:	1141                	addi	sp,sp,-16
 820:	e406                	sd	ra,8(sp)
 822:	e022                	sd	s0,0(sp)
 824:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 826:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82a:	00000797          	auipc	a5,0x0
 82e:	7d67b783          	ld	a5,2006(a5) # 1000 <freep>
 832:	a039                	j	840 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	6398                	ld	a4,0(a5)
 836:	00e7e463          	bltu	a5,a4,83e <free+0x20>
 83a:	00e6ea63          	bltu	a3,a4,84e <free+0x30>
{
 83e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	fed7fae3          	bgeu	a5,a3,834 <free+0x16>
 844:	6398                	ld	a4,0(a5)
 846:	00e6e463          	bltu	a3,a4,84e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	fee7eae3          	bltu	a5,a4,83e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 84e:	ff852583          	lw	a1,-8(a0)
 852:	6390                	ld	a2,0(a5)
 854:	02059813          	slli	a6,a1,0x20
 858:	01c85713          	srli	a4,a6,0x1c
 85c:	9736                	add	a4,a4,a3
 85e:	02e60563          	beq	a2,a4,888 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 866:	4790                	lw	a2,8(a5)
 868:	02061593          	slli	a1,a2,0x20
 86c:	01c5d713          	srli	a4,a1,0x1c
 870:	973e                	add	a4,a4,a5
 872:	02e68263          	beq	a3,a4,896 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 876:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 878:	00000717          	auipc	a4,0x0
 87c:	78f73423          	sd	a5,1928(a4) # 1000 <freep>
}
 880:	60a2                	ld	ra,8(sp)
 882:	6402                	ld	s0,0(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 888:	4618                	lw	a4,8(a2)
 88a:	9f2d                	addw	a4,a4,a1
 88c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 890:	6398                	ld	a4,0(a5)
 892:	6310                	ld	a2,0(a4)
 894:	b7f9                	j	862 <free+0x44>
    p->s.size += bp->s.size;
 896:	ff852703          	lw	a4,-8(a0)
 89a:	9f31                	addw	a4,a4,a2
 89c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 89e:	ff053683          	ld	a3,-16(a0)
 8a2:	bfd1                	j	876 <free+0x58>

00000000000008a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a4:	7139                	addi	sp,sp,-64
 8a6:	fc06                	sd	ra,56(sp)
 8a8:	f822                	sd	s0,48(sp)
 8aa:	f04a                	sd	s2,32(sp)
 8ac:	ec4e                	sd	s3,24(sp)
 8ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b0:	02051993          	slli	s3,a0,0x20
 8b4:	0209d993          	srli	s3,s3,0x20
 8b8:	09bd                	addi	s3,s3,15
 8ba:	0049d993          	srli	s3,s3,0x4
 8be:	2985                	addiw	s3,s3,1
 8c0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8c2:	00000517          	auipc	a0,0x0
 8c6:	73e53503          	ld	a0,1854(a0) # 1000 <freep>
 8ca:	c905                	beqz	a0,8fa <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ce:	4798                	lw	a4,8(a5)
 8d0:	09377663          	bgeu	a4,s3,95c <malloc+0xb8>
 8d4:	f426                	sd	s1,40(sp)
 8d6:	e852                	sd	s4,16(sp)
 8d8:	e456                	sd	s5,8(sp)
 8da:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8dc:	8a4e                	mv	s4,s3
 8de:	6705                	lui	a4,0x1
 8e0:	00e9f363          	bgeu	s3,a4,8e6 <malloc+0x42>
 8e4:	6a05                	lui	s4,0x1
 8e6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ee:	00000497          	auipc	s1,0x0
 8f2:	71248493          	addi	s1,s1,1810 # 1000 <freep>
  if(p == SBRK_ERROR)
 8f6:	5afd                	li	s5,-1
 8f8:	a83d                	j	936 <malloc+0x92>
 8fa:	f426                	sd	s1,40(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 902:	00000797          	auipc	a5,0x0
 906:	70e78793          	addi	a5,a5,1806 # 1010 <base>
 90a:	00000717          	auipc	a4,0x0
 90e:	6ef73b23          	sd	a5,1782(a4) # 1000 <freep>
 912:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 914:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 918:	b7d1                	j	8dc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 91a:	6398                	ld	a4,0(a5)
 91c:	e118                	sd	a4,0(a0)
 91e:	a899                	j	974 <malloc+0xd0>
  hp->s.size = nu;
 920:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 924:	0541                	addi	a0,a0,16
 926:	ef9ff0ef          	jal	81e <free>
  return freep;
 92a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 92c:	c125                	beqz	a0,98c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 930:	4798                	lw	a4,8(a5)
 932:	03277163          	bgeu	a4,s2,954 <malloc+0xb0>
    if(p == freep)
 936:	6098                	ld	a4,0(s1)
 938:	853e                	mv	a0,a5
 93a:	fef71ae3          	bne	a4,a5,92e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	a2dff0ef          	jal	36c <sbrk>
  if(p == SBRK_ERROR)
 944:	fd551ee3          	bne	a0,s5,920 <malloc+0x7c>
        return 0;
 948:	4501                	li	a0,0
 94a:	74a2                	ld	s1,40(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
 952:	a03d                	j	980 <malloc+0xdc>
 954:	74a2                	ld	s1,40(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 95c:	fae90fe3          	beq	s2,a4,91a <malloc+0x76>
        p->s.size -= nunits;
 960:	4137073b          	subw	a4,a4,s3
 964:	c798                	sw	a4,8(a5)
        p += p->s.size;
 966:	02071693          	slli	a3,a4,0x20
 96a:	01c6d713          	srli	a4,a3,0x1c
 96e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 970:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 974:	00000717          	auipc	a4,0x0
 978:	68a73623          	sd	a0,1676(a4) # 1000 <freep>
      return (void*)(p + 1);
 97c:	01078513          	addi	a0,a5,16
  }
}
 980:	70e2                	ld	ra,56(sp)
 982:	7442                	ld	s0,48(sp)
 984:	7902                	ld	s2,32(sp)
 986:	69e2                	ld	s3,24(sp)
 988:	6121                	addi	sp,sp,64
 98a:	8082                	ret
 98c:	74a2                	ld	s1,40(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	b7f5                	j	980 <malloc+0xdc>
