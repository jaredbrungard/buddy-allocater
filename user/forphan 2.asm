
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";
  
  if ((fd = open(ff, O_CREATE|O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	97050513          	addi	a0,a0,-1680 # 980 <malloc+0xf6>
  18:	3a6000ef          	jal	3be <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if(fstat(fd, &st) < 0){
  20:	fc840593          	addi	a1,s0,-56
  24:	3b2000ef          	jal	3d6 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	95450513          	addi	a0,a0,-1708 # 980 <malloc+0xf6>
  34:	39a000ef          	jal	3ce <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	94250513          	addi	a0,a0,-1726 # 980 <malloc+0xf6>
  46:	378000ef          	jal	3be <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	98e50513          	addi	a0,a0,-1650 # 9e0 <malloc+0x156>
  5a:	778000ef          	jal	7d2 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	31e000ef          	jal	37e <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	92a50513          	addi	a0,a0,-1750 # 990 <malloc+0x106>
  6e:	764000ef          	jal	7d2 <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	30a000ef          	jal	37e <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	93068693          	addi	a3,a3,-1744 # 9a8 <malloc+0x11e>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	92e58593          	addi	a1,a1,-1746 # 9b0 <malloc+0x126>
  8a:	4509                	li	a0,2
  8c:	71c000ef          	jal	7a8 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2ec000ef          	jal	37e <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	93050513          	addi	a0,a0,-1744 # 9c8 <malloc+0x13e>
  a0:	732000ef          	jal	7d2 <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2d8000ef          	jal	37e <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	94a50513          	addi	a0,a0,-1718 # 9f8 <malloc+0x16e>
  b6:	71c000ef          	jal	7d2 <printf>
  // sit around until killed
  for(;;) pause(1000);
  ba:	3e800493          	li	s1,1000
  be:	8526                	mv	a0,s1
  c0:	34e000ef          	jal	40e <pause>
  c4:	bfed                	j	be <main+0xbe>

00000000000000c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ce:	f33ff0ef          	jal	0 <main>
  exit(0);
  d2:	4501                	li	a0,0
  d4:	2aa000ef          	jal	37e <exit>

00000000000000d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e0:	87aa                	mv	a5,a0
  e2:	0585                	addi	a1,a1,1
  e4:	0785                	addi	a5,a5,1
  e6:	fff5c703          	lbu	a4,-1(a1)
  ea:	fee78fa3          	sb	a4,-1(a5)
  ee:	fb75                	bnez	a4,e2 <strcpy+0xa>
    ;
  return os;
}
  f0:	60a2                	ld	ra,8(sp)
  f2:	6402                	ld	s0,0(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb91                	beqz	a5,118 <strcmp+0x20>
 106:	0005c703          	lbu	a4,0(a1)
 10a:	00f71763          	bne	a4,a5,118 <strcmp+0x20>
    p++, q++;
 10e:	0505                	addi	a0,a0,1
 110:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 112:	00054783          	lbu	a5,0(a0)
 116:	fbe5                	bnez	a5,106 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 118:	0005c503          	lbu	a0,0(a1)
}
 11c:	40a7853b          	subw	a0,a5,a0
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strlen>:

uint
strlen(const char *s)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cf91                	beqz	a5,150 <strlen+0x28>
 136:	00150793          	addi	a5,a0,1
 13a:	86be                	mv	a3,a5
 13c:	0785                	addi	a5,a5,1
 13e:	fff7c703          	lbu	a4,-1(a5)
 142:	ff65                	bnez	a4,13a <strlen+0x12>
 144:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 148:	60a2                	ld	ra,8(sp)
 14a:	6402                	ld	s0,0(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  for(n = 0; s[n]; n++)
 150:	4501                	li	a0,0
 152:	bfdd                	j	148 <strlen+0x20>

0000000000000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15c:	ca19                	beqz	a2,172 <memset+0x1e>
 15e:	87aa                	mv	a5,a0
 160:	1602                	slli	a2,a2,0x20
 162:	9201                	srli	a2,a2,0x20
 164:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 168:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16c:	0785                	addi	a5,a5,1
 16e:	fee79de3          	bne	a5,a4,168 <memset+0x14>
  }
  return dst;
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strchr>:

char*
strchr(const char *s, char c)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  for(; *s; s++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf81                	beqz	a5,19e <strchr+0x24>
    if(*s == c)
 188:	00f58763          	beq	a1,a5,196 <strchr+0x1c>
  for(; *s; s++)
 18c:	0505                	addi	a0,a0,1
 18e:	00054783          	lbu	a5,0(a0)
 192:	fbfd                	bnez	a5,188 <strchr+0xe>
      return (char*)s;
  return 0;
 194:	4501                	li	a0,0
}
 196:	60a2                	ld	ra,8(sp)
 198:	6402                	ld	s0,0(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfdd                	j	196 <strchr+0x1c>

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	711d                	addi	sp,sp,-96
 1a4:	ec86                	sd	ra,88(sp)
 1a6:	e8a2                	sd	s0,80(sp)
 1a8:	e4a6                	sd	s1,72(sp)
 1aa:	e0ca                	sd	s2,64(sp)
 1ac:	fc4e                	sd	s3,56(sp)
 1ae:	f852                	sd	s4,48(sp)
 1b0:	f456                	sd	s5,40(sp)
 1b2:	f05a                	sd	s6,32(sp)
 1b4:	ec5e                	sd	s7,24(sp)
 1b6:	e862                	sd	s8,16(sp)
 1b8:	1080                	addi	s0,sp,96
 1ba:	8baa                	mv	s7,a0
 1bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c2:	faf40b13          	addi	s6,s0,-81
 1c6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1c8:	8c26                	mv	s8,s1
 1ca:	0014899b          	addiw	s3,s1,1
 1ce:	84ce                	mv	s1,s3
 1d0:	0349d463          	bge	s3,s4,1f8 <gets+0x56>
    cc = read(0, &c, 1);
 1d4:	8656                	mv	a2,s5
 1d6:	85da                	mv	a1,s6
 1d8:	4501                	li	a0,0
 1da:	1bc000ef          	jal	396 <read>
    if(cc < 1)
 1de:	00a05d63          	blez	a0,1f8 <gets+0x56>
      break;
    buf[i++] = c;
 1e2:	faf44783          	lbu	a5,-81(s0)
 1e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ea:	0905                	addi	s2,s2,1
 1ec:	ff678713          	addi	a4,a5,-10
 1f0:	c319                	beqz	a4,1f6 <gets+0x54>
 1f2:	17cd                	addi	a5,a5,-13
 1f4:	fbf1                	bnez	a5,1c8 <gets+0x26>
    buf[i++] = c;
 1f6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1f8:	9c5e                	add	s8,s8,s7
 1fa:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1fe:	855e                	mv	a0,s7
 200:	60e6                	ld	ra,88(sp)
 202:	6446                	ld	s0,80(sp)
 204:	64a6                	ld	s1,72(sp)
 206:	6906                	ld	s2,64(sp)
 208:	79e2                	ld	s3,56(sp)
 20a:	7a42                	ld	s4,48(sp)
 20c:	7aa2                	ld	s5,40(sp)
 20e:	7b02                	ld	s6,32(sp)
 210:	6be2                	ld	s7,24(sp)
 212:	6c42                	ld	s8,16(sp)
 214:	6125                	addi	sp,sp,96
 216:	8082                	ret

0000000000000218 <stat>:

int
stat(const char *n, struct stat *st)
{
 218:	1101                	addi	sp,sp,-32
 21a:	ec06                	sd	ra,24(sp)
 21c:	e822                	sd	s0,16(sp)
 21e:	e04a                	sd	s2,0(sp)
 220:	1000                	addi	s0,sp,32
 222:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 224:	4581                	li	a1,0
 226:	198000ef          	jal	3be <open>
  if(fd < 0)
 22a:	02054263          	bltz	a0,24e <stat+0x36>
 22e:	e426                	sd	s1,8(sp)
 230:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 232:	85ca                	mv	a1,s2
 234:	1a2000ef          	jal	3d6 <fstat>
 238:	892a                	mv	s2,a0
  close(fd);
 23a:	8526                	mv	a0,s1
 23c:	16a000ef          	jal	3a6 <close>
  return r;
 240:	64a2                	ld	s1,8(sp)
}
 242:	854a                	mv	a0,s2
 244:	60e2                	ld	ra,24(sp)
 246:	6442                	ld	s0,16(sp)
 248:	6902                	ld	s2,0(sp)
 24a:	6105                	addi	sp,sp,32
 24c:	8082                	ret
    return -1;
 24e:	57fd                	li	a5,-1
 250:	893e                	mv	s2,a5
 252:	bfc5                	j	242 <stat+0x2a>

0000000000000254 <atoi>:

int
atoi(const char *s)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	00054683          	lbu	a3,0(a0)
 260:	fd06879b          	addiw	a5,a3,-48
 264:	0ff7f793          	zext.b	a5,a5
 268:	4625                	li	a2,9
 26a:	02f66963          	bltu	a2,a5,29c <atoi+0x48>
 26e:	872a                	mv	a4,a0
  n = 0;
 270:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 272:	0705                	addi	a4,a4,1
 274:	0025179b          	slliw	a5,a0,0x2
 278:	9fa9                	addw	a5,a5,a0
 27a:	0017979b          	slliw	a5,a5,0x1
 27e:	9fb5                	addw	a5,a5,a3
 280:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 284:	00074683          	lbu	a3,0(a4)
 288:	fd06879b          	addiw	a5,a3,-48
 28c:	0ff7f793          	zext.b	a5,a5
 290:	fef671e3          	bgeu	a2,a5,272 <atoi+0x1e>
  return n;
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  n = 0;
 29c:	4501                	li	a0,0
 29e:	bfdd                	j	294 <atoi+0x40>

00000000000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a8:	02b57563          	bgeu	a0,a1,2d2 <memmove+0x32>
    while(n-- > 0)
 2ac:	00c05f63          	blez	a2,2ca <memmove+0x2a>
 2b0:	1602                	slli	a2,a2,0x20
 2b2:	9201                	srli	a2,a2,0x20
 2b4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ba:	0585                	addi	a1,a1,1
 2bc:	0705                	addi	a4,a4,1
 2be:	fff5c683          	lbu	a3,-1(a1)
 2c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c6:	fee79ae3          	bne	a5,a4,2ba <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
    while(n-- > 0)
 2d2:	fec05ce3          	blez	a2,2ca <memmove+0x2a>
    dst += n;
 2d6:	00c50733          	add	a4,a0,a2
    src += n;
 2da:	95b2                	add	a1,a1,a2
 2dc:	fff6079b          	addiw	a5,a2,-1
 2e0:	1782                	slli	a5,a5,0x20
 2e2:	9381                	srli	a5,a5,0x20
 2e4:	fff7c793          	not	a5,a5
 2e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ea:	15fd                	addi	a1,a1,-1
 2ec:	177d                	addi	a4,a4,-1
 2ee:	0005c683          	lbu	a3,0(a1)
 2f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f6:	fef71ae3          	bne	a4,a5,2ea <memmove+0x4a>
 2fa:	bfc1                	j	2ca <memmove+0x2a>

00000000000002fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 304:	c61d                	beqz	a2,332 <memcmp+0x36>
 306:	1602                	slli	a2,a2,0x20
 308:	9201                	srli	a2,a2,0x20
 30a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 30e:	00054783          	lbu	a5,0(a0)
 312:	0005c703          	lbu	a4,0(a1)
 316:	00e79863          	bne	a5,a4,326 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 31a:	0505                	addi	a0,a0,1
    p2++;
 31c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31e:	fed518e3          	bne	a0,a3,30e <memcmp+0x12>
  }
  return 0;
 322:	4501                	li	a0,0
 324:	a019                	j	32a <memcmp+0x2e>
      return *p1 - *p2;
 326:	40e7853b          	subw	a0,a5,a4
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfdd                	j	32a <memcmp+0x2e>

0000000000000336 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33e:	f63ff0ef          	jal	2a0 <memmove>
}
 342:	60a2                	ld	ra,8(sp)
 344:	6402                	ld	s0,0(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret

000000000000034a <sbrk>:

char *
sbrk(int n) {
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 352:	4585                	li	a1,1
 354:	0b2000ef          	jal	406 <sys_sbrk>
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <sbrklazy>:

char *
sbrklazy(int n) {
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 368:	4589                	li	a1,2
 36a:	09c000ef          	jal	406 <sys_sbrk>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 376:	4885                	li	a7,1
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exit>:
.global exit
exit:
 li a7, SYS_exit
 37e:	4889                	li	a7,2
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <wait>:
.global wait
wait:
 li a7, SYS_wait
 386:	488d                	li	a7,3
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38e:	4891                	li	a7,4
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <read>:
.global read
read:
 li a7, SYS_read
 396:	4895                	li	a7,5
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <write>:
.global write
write:
 li a7, SYS_write
 39e:	48c1                	li	a7,16
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <close>:
.global close
close:
 li a7, SYS_close
 3a6:	48d5                	li	a7,21
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ae:	4899                	li	a7,6
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b6:	489d                	li	a7,7
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <open>:
.global open
open:
 li a7, SYS_open
 3be:	48bd                	li	a7,15
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d6:	48a1                	li	a7,8
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <link>:
.global link
link:
 li a7, SYS_link
 3de:	48cd                	li	a7,19
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e6:	48d1                	li	a7,20
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <pause>:
.global pause
pause:
 li a7, SYS_pause
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 41e:	48d9                	li	a7,22
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 426:	1101                	addi	sp,sp,-32
 428:	ec06                	sd	ra,24(sp)
 42a:	e822                	sd	s0,16(sp)
 42c:	1000                	addi	s0,sp,32
 42e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 432:	4605                	li	a2,1
 434:	fef40593          	addi	a1,s0,-17
 438:	f67ff0ef          	jal	39e <write>
}
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	6105                	addi	sp,sp,32
 442:	8082                	ret

0000000000000444 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 444:	715d                	addi	sp,sp,-80
 446:	e486                	sd	ra,72(sp)
 448:	e0a2                	sd	s0,64(sp)
 44a:	f84a                	sd	s2,48(sp)
 44c:	f44e                	sd	s3,40(sp)
 44e:	0880                	addi	s0,sp,80
 450:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 452:	cac1                	beqz	a3,4e2 <printint+0x9e>
 454:	0805d763          	bgez	a1,4e2 <printint+0x9e>
    neg = 1;
    x = -xx;
 458:	40b005bb          	negw	a1,a1
    neg = 1;
 45c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 45e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 462:	86ce                	mv	a3,s3
  i = 0;
 464:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 466:	00000817          	auipc	a6,0x0
 46a:	5ba80813          	addi	a6,a6,1466 # a20 <digits>
 46e:	88ba                	mv	a7,a4
 470:	0017051b          	addiw	a0,a4,1
 474:	872a                	mv	a4,a0
 476:	02c5f7bb          	remuw	a5,a1,a2
 47a:	1782                	slli	a5,a5,0x20
 47c:	9381                	srli	a5,a5,0x20
 47e:	97c2                	add	a5,a5,a6
 480:	0007c783          	lbu	a5,0(a5)
 484:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 488:	87ae                	mv	a5,a1
 48a:	02c5d5bb          	divuw	a1,a1,a2
 48e:	0685                	addi	a3,a3,1
 490:	fcc7ffe3          	bgeu	a5,a2,46e <printint+0x2a>
  if(neg)
 494:	00030c63          	beqz	t1,4ac <printint+0x68>
    buf[i++] = '-';
 498:	fd050793          	addi	a5,a0,-48
 49c:	00878533          	add	a0,a5,s0
 4a0:	02d00793          	li	a5,45
 4a4:	fef50423          	sb	a5,-24(a0)
 4a8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ac:	02e05563          	blez	a4,4d6 <printint+0x92>
 4b0:	fc26                	sd	s1,56(sp)
 4b2:	377d                	addiw	a4,a4,-1
 4b4:	00e984b3          	add	s1,s3,a4
 4b8:	19fd                	addi	s3,s3,-1
 4ba:	99ba                	add	s3,s3,a4
 4bc:	1702                	slli	a4,a4,0x20
 4be:	9301                	srli	a4,a4,0x20
 4c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c4:	0004c583          	lbu	a1,0(s1)
 4c8:	854a                	mv	a0,s2
 4ca:	f5dff0ef          	jal	426 <putc>
  while(--i >= 0)
 4ce:	14fd                	addi	s1,s1,-1
 4d0:	ff349ae3          	bne	s1,s3,4c4 <printint+0x80>
 4d4:	74e2                	ld	s1,56(sp)
}
 4d6:	60a6                	ld	ra,72(sp)
 4d8:	6406                	ld	s0,64(sp)
 4da:	7942                	ld	s2,48(sp)
 4dc:	79a2                	ld	s3,40(sp)
 4de:	6161                	addi	sp,sp,80
 4e0:	8082                	ret
    x = xx;
 4e2:	2581                	sext.w	a1,a1
  neg = 0;
 4e4:	4301                	li	t1,0
 4e6:	bfa5                	j	45e <printint+0x1a>

00000000000004e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e8:	711d                	addi	sp,sp,-96
 4ea:	ec86                	sd	ra,88(sp)
 4ec:	e8a2                	sd	s0,80(sp)
 4ee:	e4a6                	sd	s1,72(sp)
 4f0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f2:	0005c483          	lbu	s1,0(a1)
 4f6:	22048363          	beqz	s1,71c <vprintf+0x234>
 4fa:	e0ca                	sd	s2,64(sp)
 4fc:	fc4e                	sd	s3,56(sp)
 4fe:	f852                	sd	s4,48(sp)
 500:	f456                	sd	s5,40(sp)
 502:	f05a                	sd	s6,32(sp)
 504:	ec5e                	sd	s7,24(sp)
 506:	e862                	sd	s8,16(sp)
 508:	8b2a                	mv	s6,a0
 50a:	8a2e                	mv	s4,a1
 50c:	8bb2                	mv	s7,a2
  state = 0;
 50e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 510:	4901                	li	s2,0
 512:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 514:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 518:	06400c13          	li	s8,100
 51c:	a00d                	j	53e <vprintf+0x56>
        putc(fd, c0);
 51e:	85a6                	mv	a1,s1
 520:	855a                	mv	a0,s6
 522:	f05ff0ef          	jal	426 <putc>
 526:	a019                	j	52c <vprintf+0x44>
    } else if(state == '%'){
 528:	03598363          	beq	s3,s5,54e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 52c:	0019079b          	addiw	a5,s2,1
 530:	893e                	mv	s2,a5
 532:	873e                	mv	a4,a5
 534:	97d2                	add	a5,a5,s4
 536:	0007c483          	lbu	s1,0(a5)
 53a:	1c048a63          	beqz	s1,70e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 53e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 542:	fe0993e3          	bnez	s3,528 <vprintf+0x40>
      if(c0 == '%'){
 546:	fd579ce3          	bne	a5,s5,51e <vprintf+0x36>
        state = '%';
 54a:	89be                	mv	s3,a5
 54c:	b7c5                	j	52c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 54e:	00ea06b3          	add	a3,s4,a4
 552:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 556:	1c060863          	beqz	a2,726 <vprintf+0x23e>
      if(c0 == 'd'){
 55a:	03878763          	beq	a5,s8,588 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 55e:	f9478693          	addi	a3,a5,-108
 562:	0016b693          	seqz	a3,a3
 566:	f9c60593          	addi	a1,a2,-100
 56a:	e99d                	bnez	a1,5a0 <vprintf+0xb8>
 56c:	ca95                	beqz	a3,5a0 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	008b8493          	addi	s1,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000bb583          	ld	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	ec9ff0ef          	jal	444 <printint>
        i += 1;
 580:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 584:	4981                	li	s3,0
 586:	b75d                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 588:	008b8493          	addi	s1,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	eafff0ef          	jal	444 <printint>
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b779                	j	52c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5a0:	9752                	add	a4,a4,s4
 5a2:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a6:	f9460713          	addi	a4,a2,-108
 5aa:	00173713          	seqz	a4,a4
 5ae:	8f75                	and	a4,a4,a3
 5b0:	f9c58513          	addi	a0,a1,-100
 5b4:	18051363          	bnez	a0,73a <vprintf+0x252>
 5b8:	18070163          	beqz	a4,73a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000bb583          	ld	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e7bff0ef          	jal	444 <printint>
        i += 2;
 5ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
        i += 2;
 5d4:	bfa1                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000be583          	lwu	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e61ff0ef          	jal	444 <printint>
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b781                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000bb583          	ld	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	e49ff0ef          	jal	444 <printint>
        i += 1;
 600:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	b71d                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4629                	li	a2,10
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e2fff0ef          	jal	444 <printint>
        i += 2;
 61a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	b731                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000be583          	lwu	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e15ff0ef          	jal	444 <printint>
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
 638:	bdd5                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	dfdff0ef          	jal	444 <printint>
        i += 1;
 64c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
 652:	bde9                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8493          	addi	s1,s7,8
 658:	4681                	li	a3,0
 65a:	4641                	li	a2,16
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	de3ff0ef          	jal	444 <printint>
        i += 2;
 666:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	b5c1                	j	52c <vprintf+0x44>
 66e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 670:	008b8793          	addi	a5,s7,8
 674:	8cbe                	mv	s9,a5
 676:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67a:	03000593          	li	a1,48
 67e:	855a                	mv	a0,s6
 680:	da7ff0ef          	jal	426 <putc>
  putc(fd, 'x');
 684:	07800593          	li	a1,120
 688:	855a                	mv	a0,s6
 68a:	d9dff0ef          	jal	426 <putc>
 68e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	00000b97          	auipc	s7,0x0
 694:	390b8b93          	addi	s7,s7,912 # a20 <digits>
 698:	03c9d793          	srli	a5,s3,0x3c
 69c:	97de                	add	a5,a5,s7
 69e:	0007c583          	lbu	a1,0(a5)
 6a2:	855a                	mv	a0,s6
 6a4:	d83ff0ef          	jal	426 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a8:	0992                	slli	s3,s3,0x4
 6aa:	34fd                	addiw	s1,s1,-1
 6ac:	f4f5                	bnez	s1,698 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6ae:	8be6                	mv	s7,s9
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	6ca2                	ld	s9,8(sp)
 6b4:	bda5                	j	52c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6b6:	008b8493          	addi	s1,s7,8
 6ba:	000bc583          	lbu	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	d67ff0ef          	jal	426 <putc>
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b595                	j	52c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	008b8993          	addi	s3,s7,8
 6ce:	000bb483          	ld	s1,0(s7)
 6d2:	cc91                	beqz	s1,6ee <vprintf+0x206>
        for(; *s; s++)
 6d4:	0004c583          	lbu	a1,0(s1)
 6d8:	c985                	beqz	a1,708 <vprintf+0x220>
          putc(fd, *s);
 6da:	855a                	mv	a0,s6
 6dc:	d4bff0ef          	jal	426 <putc>
        for(; *s; s++)
 6e0:	0485                	addi	s1,s1,1
 6e2:	0004c583          	lbu	a1,0(s1)
 6e6:	f9f5                	bnez	a1,6da <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6e8:	8bce                	mv	s7,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b581                	j	52c <vprintf+0x44>
          s = "(null)";
 6ee:	00000497          	auipc	s1,0x0
 6f2:	32a48493          	addi	s1,s1,810 # a18 <malloc+0x18e>
        for(; *s; s++)
 6f6:	02800593          	li	a1,40
 6fa:	b7c5                	j	6da <vprintf+0x1f2>
        putc(fd, '%');
 6fc:	85be                	mv	a1,a5
 6fe:	855a                	mv	a0,s6
 700:	d27ff0ef          	jal	426 <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	b51d                	j	52c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 708:	8bce                	mv	s7,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b505                	j	52c <vprintf+0x44>
 70e:	6906                	ld	s2,64(sp)
 710:	79e2                	ld	s3,56(sp)
 712:	7a42                	ld	s4,48(sp)
 714:	7aa2                	ld	s5,40(sp)
 716:	7b02                	ld	s6,32(sp)
 718:	6be2                	ld	s7,24(sp)
 71a:	6c42                	ld	s8,16(sp)
    }
  }
}
 71c:	60e6                	ld	ra,88(sp)
 71e:	6446                	ld	s0,80(sp)
 720:	64a6                	ld	s1,72(sp)
 722:	6125                	addi	sp,sp,96
 724:	8082                	ret
      if(c0 == 'd'){
 726:	06400713          	li	a4,100
 72a:	e4e78fe3          	beq	a5,a4,588 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 72e:	f9478693          	addi	a3,a5,-108
 732:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 736:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 738:	4701                	li	a4,0
      } else if(c0 == 'u'){
 73a:	07500513          	li	a0,117
 73e:	e8a78ce3          	beq	a5,a0,5d6 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 742:	f8b60513          	addi	a0,a2,-117
 746:	e119                	bnez	a0,74c <vprintf+0x264>
 748:	ea0693e3          	bnez	a3,5ee <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 74c:	f8b58513          	addi	a0,a1,-117
 750:	e119                	bnez	a0,756 <vprintf+0x26e>
 752:	ea071be3          	bnez	a4,608 <vprintf+0x120>
      } else if(c0 == 'x'){
 756:	07800513          	li	a0,120
 75a:	eca784e3          	beq	a5,a0,622 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 75e:	f8860613          	addi	a2,a2,-120
 762:	e219                	bnez	a2,768 <vprintf+0x280>
 764:	ec069be3          	bnez	a3,63a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 768:	f8858593          	addi	a1,a1,-120
 76c:	e199                	bnez	a1,772 <vprintf+0x28a>
 76e:	ee0713e3          	bnez	a4,654 <vprintf+0x16c>
      } else if(c0 == 'p'){
 772:	07000713          	li	a4,112
 776:	eee78ce3          	beq	a5,a4,66e <vprintf+0x186>
      } else if(c0 == 'c'){
 77a:	06300713          	li	a4,99
 77e:	f2e78ce3          	beq	a5,a4,6b6 <vprintf+0x1ce>
      } else if(c0 == 's'){
 782:	07300713          	li	a4,115
 786:	f4e782e3          	beq	a5,a4,6ca <vprintf+0x1e2>
      } else if(c0 == '%'){
 78a:	02500713          	li	a4,37
 78e:	f6e787e3          	beq	a5,a4,6fc <vprintf+0x214>
        putc(fd, '%');
 792:	02500593          	li	a1,37
 796:	855a                	mv	a0,s6
 798:	c8fff0ef          	jal	426 <putc>
        putc(fd, c0);
 79c:	85a6                	mv	a1,s1
 79e:	855a                	mv	a0,s6
 7a0:	c87ff0ef          	jal	426 <putc>
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b359                	j	52c <vprintf+0x44>

00000000000007a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a8:	715d                	addi	sp,sp,-80
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e010                	sd	a2,0(s0)
 7b2:	e414                	sd	a3,8(s0)
 7b4:	e818                	sd	a4,16(s0)
 7b6:	ec1c                	sd	a5,24(s0)
 7b8:	03043023          	sd	a6,32(s0)
 7bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	8622                	mv	a2,s0
 7c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c6:	d23ff0ef          	jal	4e8 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6161                	addi	sp,sp,80
 7d0:	8082                	ret

00000000000007d2 <printf>:

void
printf(const char *fmt, ...)
{
 7d2:	711d                	addi	sp,sp,-96
 7d4:	ec06                	sd	ra,24(sp)
 7d6:	e822                	sd	s0,16(sp)
 7d8:	1000                	addi	s0,sp,32
 7da:	e40c                	sd	a1,8(s0)
 7dc:	e810                	sd	a2,16(s0)
 7de:	ec14                	sd	a3,24(s0)
 7e0:	f018                	sd	a4,32(s0)
 7e2:	f41c                	sd	a5,40(s0)
 7e4:	03043823          	sd	a6,48(s0)
 7e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ec:	00840613          	addi	a2,s0,8
 7f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f4:	85aa                	mv	a1,a0
 7f6:	4505                	li	a0,1
 7f8:	cf1ff0ef          	jal	4e8 <vprintf>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6125                	addi	sp,sp,96
 802:	8082                	ret

0000000000000804 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 804:	1141                	addi	sp,sp,-16
 806:	e406                	sd	ra,8(sp)
 808:	e022                	sd	s0,0(sp)
 80a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	00000797          	auipc	a5,0x0
 814:	7f07b783          	ld	a5,2032(a5) # 1000 <freep>
 818:	a039                	j	826 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	6398                	ld	a4,0(a5)
 81c:	00e7e463          	bltu	a5,a4,824 <free+0x20>
 820:	00e6ea63          	bltu	a3,a4,834 <free+0x30>
{
 824:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	fed7fae3          	bgeu	a5,a3,81a <free+0x16>
 82a:	6398                	ld	a4,0(a5)
 82c:	00e6e463          	bltu	a3,a4,834 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	fee7eae3          	bltu	a5,a4,824 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 834:	ff852583          	lw	a1,-8(a0)
 838:	6390                	ld	a2,0(a5)
 83a:	02059813          	slli	a6,a1,0x20
 83e:	01c85713          	srli	a4,a6,0x1c
 842:	9736                	add	a4,a4,a3
 844:	02e60563          	beq	a2,a4,86e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 84c:	4790                	lw	a2,8(a5)
 84e:	02061593          	slli	a1,a2,0x20
 852:	01c5d713          	srli	a4,a1,0x1c
 856:	973e                	add	a4,a4,a5
 858:	02e68263          	beq	a3,a4,87c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 85c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
}
 866:	60a2                	ld	ra,8(sp)
 868:	6402                	ld	s0,0(sp)
 86a:	0141                	addi	sp,sp,16
 86c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 86e:	4618                	lw	a4,8(a2)
 870:	9f2d                	addw	a4,a4,a1
 872:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	6310                	ld	a2,0(a4)
 87a:	b7f9                	j	848 <free+0x44>
    p->s.size += bp->s.size;
 87c:	ff852703          	lw	a4,-8(a0)
 880:	9f31                	addw	a4,a4,a2
 882:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 884:	ff053683          	ld	a3,-16(a0)
 888:	bfd1                	j	85c <free+0x58>

000000000000088a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88a:	7139                	addi	sp,sp,-64
 88c:	fc06                	sd	ra,56(sp)
 88e:	f822                	sd	s0,48(sp)
 890:	f04a                	sd	s2,32(sp)
 892:	ec4e                	sd	s3,24(sp)
 894:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	02051993          	slli	s3,a0,0x20
 89a:	0209d993          	srli	s3,s3,0x20
 89e:	09bd                	addi	s3,s3,15
 8a0:	0049d993          	srli	s3,s3,0x4
 8a4:	2985                	addiw	s3,s3,1
 8a6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8a8:	00000517          	auipc	a0,0x0
 8ac:	75853503          	ld	a0,1880(a0) # 1000 <freep>
 8b0:	c905                	beqz	a0,8e0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b4:	4798                	lw	a4,8(a5)
 8b6:	09377663          	bgeu	a4,s3,942 <malloc+0xb8>
 8ba:	f426                	sd	s1,40(sp)
 8bc:	e852                	sd	s4,16(sp)
 8be:	e456                	sd	s5,8(sp)
 8c0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8c2:	8a4e                	mv	s4,s3
 8c4:	6705                	lui	a4,0x1
 8c6:	00e9f363          	bgeu	s3,a4,8cc <malloc+0x42>
 8ca:	6a05                	lui	s4,0x1
 8cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d4:	00000497          	auipc	s1,0x0
 8d8:	72c48493          	addi	s1,s1,1836 # 1000 <freep>
  if(p == SBRK_ERROR)
 8dc:	5afd                	li	s5,-1
 8de:	a83d                	j	91c <malloc+0x92>
 8e0:	f426                	sd	s1,40(sp)
 8e2:	e852                	sd	s4,16(sp)
 8e4:	e456                	sd	s5,8(sp)
 8e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e8:	00001797          	auipc	a5,0x1
 8ec:	92078793          	addi	a5,a5,-1760 # 1208 <base>
 8f0:	00000717          	auipc	a4,0x0
 8f4:	70f73823          	sd	a5,1808(a4) # 1000 <freep>
 8f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fe:	b7d1                	j	8c2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	e118                	sd	a4,0(a0)
 904:	a899                	j	95a <malloc+0xd0>
  hp->s.size = nu;
 906:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90a:	0541                	addi	a0,a0,16
 90c:	ef9ff0ef          	jal	804 <free>
  return freep;
 910:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 912:	c125                	beqz	a0,972 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 916:	4798                	lw	a4,8(a5)
 918:	03277163          	bgeu	a4,s2,93a <malloc+0xb0>
    if(p == freep)
 91c:	6098                	ld	a4,0(s1)
 91e:	853e                	mv	a0,a5
 920:	fef71ae3          	bne	a4,a5,914 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 924:	8552                	mv	a0,s4
 926:	a25ff0ef          	jal	34a <sbrk>
  if(p == SBRK_ERROR)
 92a:	fd551ee3          	bne	a0,s5,906 <malloc+0x7c>
        return 0;
 92e:	4501                	li	a0,0
 930:	74a2                	ld	s1,40(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	a03d                	j	966 <malloc+0xdc>
 93a:	74a2                	ld	s1,40(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 942:	fae90fe3          	beq	s2,a4,900 <malloc+0x76>
        p->s.size -= nunits;
 946:	4137073b          	subw	a4,a4,s3
 94a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94c:	02071693          	slli	a3,a4,0x20
 950:	01c6d713          	srli	a4,a3,0x1c
 954:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 956:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 95a:	00000717          	auipc	a4,0x0
 95e:	6aa73323          	sd	a0,1702(a4) # 1000 <freep>
      return (void*)(p + 1);
 962:	01078513          	addi	a0,a5,16
  }
}
 966:	70e2                	ld	ra,56(sp)
 968:	7442                	ld	s0,48(sp)
 96a:	7902                	ld	s2,32(sp)
 96c:	69e2                	ld	s3,24(sp)
 96e:	6121                	addi	sp,sp,64
 970:	8082                	ret
 972:	74a2                	ld	s1,40(sp)
 974:	6a42                	ld	s4,16(sp)
 976:	6aa2                	ld	s5,8(sp)
 978:	6b02                	ld	s6,0(sp)
 97a:	b7f5                	j	966 <malloc+0xdc>
