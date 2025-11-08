
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
  14:	97050513          	addi	a0,a0,-1680 # 980 <malloc+0xfe>
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
  30:	95450513          	addi	a0,a0,-1708 # 980 <malloc+0xfe>
  34:	39a000ef          	jal	3ce <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	94250513          	addi	a0,a0,-1726 # 980 <malloc+0xfe>
  46:	378000ef          	jal	3be <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	98e50513          	addi	a0,a0,-1650 # 9e0 <malloc+0x15e>
  5a:	770000ef          	jal	7ca <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	31e000ef          	jal	37e <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	92a50513          	addi	a0,a0,-1750 # 990 <malloc+0x10e>
  6e:	75c000ef          	jal	7ca <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	30a000ef          	jal	37e <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	93068693          	addi	a3,a3,-1744 # 9a8 <malloc+0x126>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	92e58593          	addi	a1,a1,-1746 # 9b0 <malloc+0x12e>
  8a:	4509                	li	a0,2
  8c:	714000ef          	jal	7a0 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2ec000ef          	jal	37e <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	93050513          	addi	a0,a0,-1744 # 9c8 <malloc+0x146>
  a0:	72a000ef          	jal	7ca <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2d8000ef          	jal	37e <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	94a50513          	addi	a0,a0,-1718 # 9f8 <malloc+0x176>
  b6:	714000ef          	jal	7ca <printf>
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

000000000000041e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41e:	1101                	addi	sp,sp,-32
 420:	ec06                	sd	ra,24(sp)
 422:	e822                	sd	s0,16(sp)
 424:	1000                	addi	s0,sp,32
 426:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42a:	4605                	li	a2,1
 42c:	fef40593          	addi	a1,s0,-17
 430:	f6fff0ef          	jal	39e <write>
}
 434:	60e2                	ld	ra,24(sp)
 436:	6442                	ld	s0,16(sp)
 438:	6105                	addi	sp,sp,32
 43a:	8082                	ret

000000000000043c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 43c:	715d                	addi	sp,sp,-80
 43e:	e486                	sd	ra,72(sp)
 440:	e0a2                	sd	s0,64(sp)
 442:	f84a                	sd	s2,48(sp)
 444:	f44e                	sd	s3,40(sp)
 446:	0880                	addi	s0,sp,80
 448:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44a:	cac1                	beqz	a3,4da <printint+0x9e>
 44c:	0805d763          	bgez	a1,4da <printint+0x9e>
    neg = 1;
    x = -xx;
 450:	40b005bb          	negw	a1,a1
    neg = 1;
 454:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 456:	fb840993          	addi	s3,s0,-72
  neg = 0;
 45a:	86ce                	mv	a3,s3
  i = 0;
 45c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 45e:	00000817          	auipc	a6,0x0
 462:	5c280813          	addi	a6,a6,1474 # a20 <digits>
 466:	88ba                	mv	a7,a4
 468:	0017051b          	addiw	a0,a4,1
 46c:	872a                	mv	a4,a0
 46e:	02c5f7bb          	remuw	a5,a1,a2
 472:	1782                	slli	a5,a5,0x20
 474:	9381                	srli	a5,a5,0x20
 476:	97c2                	add	a5,a5,a6
 478:	0007c783          	lbu	a5,0(a5)
 47c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 480:	87ae                	mv	a5,a1
 482:	02c5d5bb          	divuw	a1,a1,a2
 486:	0685                	addi	a3,a3,1
 488:	fcc7ffe3          	bgeu	a5,a2,466 <printint+0x2a>
  if(neg)
 48c:	00030c63          	beqz	t1,4a4 <printint+0x68>
    buf[i++] = '-';
 490:	fd050793          	addi	a5,a0,-48
 494:	00878533          	add	a0,a5,s0
 498:	02d00793          	li	a5,45
 49c:	fef50423          	sb	a5,-24(a0)
 4a0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4a4:	02e05563          	blez	a4,4ce <printint+0x92>
 4a8:	fc26                	sd	s1,56(sp)
 4aa:	377d                	addiw	a4,a4,-1
 4ac:	00e984b3          	add	s1,s3,a4
 4b0:	19fd                	addi	s3,s3,-1
 4b2:	99ba                	add	s3,s3,a4
 4b4:	1702                	slli	a4,a4,0x20
 4b6:	9301                	srli	a4,a4,0x20
 4b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4bc:	0004c583          	lbu	a1,0(s1)
 4c0:	854a                	mv	a0,s2
 4c2:	f5dff0ef          	jal	41e <putc>
  while(--i >= 0)
 4c6:	14fd                	addi	s1,s1,-1
 4c8:	ff349ae3          	bne	s1,s3,4bc <printint+0x80>
 4cc:	74e2                	ld	s1,56(sp)
}
 4ce:	60a6                	ld	ra,72(sp)
 4d0:	6406                	ld	s0,64(sp)
 4d2:	7942                	ld	s2,48(sp)
 4d4:	79a2                	ld	s3,40(sp)
 4d6:	6161                	addi	sp,sp,80
 4d8:	8082                	ret
    x = xx;
 4da:	2581                	sext.w	a1,a1
  neg = 0;
 4dc:	4301                	li	t1,0
 4de:	bfa5                	j	456 <printint+0x1a>

00000000000004e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e0:	711d                	addi	sp,sp,-96
 4e2:	ec86                	sd	ra,88(sp)
 4e4:	e8a2                	sd	s0,80(sp)
 4e6:	e4a6                	sd	s1,72(sp)
 4e8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ea:	0005c483          	lbu	s1,0(a1)
 4ee:	22048363          	beqz	s1,714 <vprintf+0x234>
 4f2:	e0ca                	sd	s2,64(sp)
 4f4:	fc4e                	sd	s3,56(sp)
 4f6:	f852                	sd	s4,48(sp)
 4f8:	f456                	sd	s5,40(sp)
 4fa:	f05a                	sd	s6,32(sp)
 4fc:	ec5e                	sd	s7,24(sp)
 4fe:	e862                	sd	s8,16(sp)
 500:	8b2a                	mv	s6,a0
 502:	8a2e                	mv	s4,a1
 504:	8bb2                	mv	s7,a2
  state = 0;
 506:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 508:	4901                	li	s2,0
 50a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 50c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 510:	06400c13          	li	s8,100
 514:	a00d                	j	536 <vprintf+0x56>
        putc(fd, c0);
 516:	85a6                	mv	a1,s1
 518:	855a                	mv	a0,s6
 51a:	f05ff0ef          	jal	41e <putc>
 51e:	a019                	j	524 <vprintf+0x44>
    } else if(state == '%'){
 520:	03598363          	beq	s3,s5,546 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 524:	0019079b          	addiw	a5,s2,1
 528:	893e                	mv	s2,a5
 52a:	873e                	mv	a4,a5
 52c:	97d2                	add	a5,a5,s4
 52e:	0007c483          	lbu	s1,0(a5)
 532:	1c048a63          	beqz	s1,706 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 536:	0004879b          	sext.w	a5,s1
    if(state == 0){
 53a:	fe0993e3          	bnez	s3,520 <vprintf+0x40>
      if(c0 == '%'){
 53e:	fd579ce3          	bne	a5,s5,516 <vprintf+0x36>
        state = '%';
 542:	89be                	mv	s3,a5
 544:	b7c5                	j	524 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 546:	00ea06b3          	add	a3,s4,a4
 54a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 54e:	1c060863          	beqz	a2,71e <vprintf+0x23e>
      if(c0 == 'd'){
 552:	03878763          	beq	a5,s8,580 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 556:	f9478693          	addi	a3,a5,-108
 55a:	0016b693          	seqz	a3,a3
 55e:	f9c60593          	addi	a1,a2,-100
 562:	e99d                	bnez	a1,598 <vprintf+0xb8>
 564:	ca95                	beqz	a3,598 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 566:	008b8493          	addi	s1,s7,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000bb583          	ld	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	ec9ff0ef          	jal	43c <printint>
        i += 1;
 578:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 57c:	4981                	li	s3,0
 57e:	b75d                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 580:	008b8493          	addi	s1,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	eafff0ef          	jal	43c <printint>
 592:	8ba6                	mv	s7,s1
      state = 0;
 594:	4981                	li	s3,0
 596:	b779                	j	524 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 598:	9752                	add	a4,a4,s4
 59a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 59e:	f9460713          	addi	a4,a2,-108
 5a2:	00173713          	seqz	a4,a4
 5a6:	8f75                	and	a4,a4,a3
 5a8:	f9c58513          	addi	a0,a1,-100
 5ac:	18051363          	bnez	a0,732 <vprintf+0x252>
 5b0:	18070163          	beqz	a4,732 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4685                	li	a3,1
 5ba:	4629                	li	a2,10
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e7bff0ef          	jal	43c <printint>
        i += 2;
 5c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	bfa1                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4629                	li	a2,10
 5d6:	000be583          	lwu	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e61ff0ef          	jal	43c <printint>
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b781                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4629                	li	a2,10
 5ee:	000bb583          	ld	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	e49ff0ef          	jal	43c <printint>
        i += 1;
 5f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b71d                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b8493          	addi	s1,s7,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e2fff0ef          	jal	43c <printint>
        i += 2;
 612:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
        i += 2;
 618:	b731                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 61a:	008b8493          	addi	s1,s7,8
 61e:	4681                	li	a3,0
 620:	4641                	li	a2,16
 622:	000be583          	lwu	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	e15ff0ef          	jal	43c <printint>
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
 630:	bdd5                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	008b8493          	addi	s1,s7,8
 636:	4681                	li	a3,0
 638:	4641                	li	a2,16
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	dfdff0ef          	jal	43c <printint>
        i += 1;
 644:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
 64a:	bde9                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	008b8493          	addi	s1,s7,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	de3ff0ef          	jal	43c <printint>
        i += 2;
 65e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	8ba6                	mv	s7,s1
      state = 0;
 662:	4981                	li	s3,0
        i += 2;
 664:	b5c1                	j	524 <vprintf+0x44>
 666:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 668:	008b8793          	addi	a5,s7,8
 66c:	8cbe                	mv	s9,a5
 66e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 672:	03000593          	li	a1,48
 676:	855a                	mv	a0,s6
 678:	da7ff0ef          	jal	41e <putc>
  putc(fd, 'x');
 67c:	07800593          	li	a1,120
 680:	855a                	mv	a0,s6
 682:	d9dff0ef          	jal	41e <putc>
 686:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 688:	00000b97          	auipc	s7,0x0
 68c:	398b8b93          	addi	s7,s7,920 # a20 <digits>
 690:	03c9d793          	srli	a5,s3,0x3c
 694:	97de                	add	a5,a5,s7
 696:	0007c583          	lbu	a1,0(a5)
 69a:	855a                	mv	a0,s6
 69c:	d83ff0ef          	jal	41e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a0:	0992                	slli	s3,s3,0x4
 6a2:	34fd                	addiw	s1,s1,-1
 6a4:	f4f5                	bnez	s1,690 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6a6:	8be6                	mv	s7,s9
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	6ca2                	ld	s9,8(sp)
 6ac:	bda5                	j	524 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ae:	008b8493          	addi	s1,s7,8
 6b2:	000bc583          	lbu	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	d67ff0ef          	jal	41e <putc>
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b595                	j	524 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6c2:	008b8993          	addi	s3,s7,8
 6c6:	000bb483          	ld	s1,0(s7)
 6ca:	cc91                	beqz	s1,6e6 <vprintf+0x206>
        for(; *s; s++)
 6cc:	0004c583          	lbu	a1,0(s1)
 6d0:	c985                	beqz	a1,700 <vprintf+0x220>
          putc(fd, *s);
 6d2:	855a                	mv	a0,s6
 6d4:	d4bff0ef          	jal	41e <putc>
        for(; *s; s++)
 6d8:	0485                	addi	s1,s1,1
 6da:	0004c583          	lbu	a1,0(s1)
 6de:	f9f5                	bnez	a1,6d2 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6e0:	8bce                	mv	s7,s3
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b581                	j	524 <vprintf+0x44>
          s = "(null)";
 6e6:	00000497          	auipc	s1,0x0
 6ea:	33248493          	addi	s1,s1,818 # a18 <malloc+0x196>
        for(; *s; s++)
 6ee:	02800593          	li	a1,40
 6f2:	b7c5                	j	6d2 <vprintf+0x1f2>
        putc(fd, '%');
 6f4:	85be                	mv	a1,a5
 6f6:	855a                	mv	a0,s6
 6f8:	d27ff0ef          	jal	41e <putc>
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b51d                	j	524 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	b505                	j	524 <vprintf+0x44>
 706:	6906                	ld	s2,64(sp)
 708:	79e2                	ld	s3,56(sp)
 70a:	7a42                	ld	s4,48(sp)
 70c:	7aa2                	ld	s5,40(sp)
 70e:	7b02                	ld	s6,32(sp)
 710:	6be2                	ld	s7,24(sp)
 712:	6c42                	ld	s8,16(sp)
    }
  }
}
 714:	60e6                	ld	ra,88(sp)
 716:	6446                	ld	s0,80(sp)
 718:	64a6                	ld	s1,72(sp)
 71a:	6125                	addi	sp,sp,96
 71c:	8082                	ret
      if(c0 == 'd'){
 71e:	06400713          	li	a4,100
 722:	e4e78fe3          	beq	a5,a4,580 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 726:	f9478693          	addi	a3,a5,-108
 72a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 72e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 730:	4701                	li	a4,0
      } else if(c0 == 'u'){
 732:	07500513          	li	a0,117
 736:	e8a78ce3          	beq	a5,a0,5ce <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 73a:	f8b60513          	addi	a0,a2,-117
 73e:	e119                	bnez	a0,744 <vprintf+0x264>
 740:	ea0693e3          	bnez	a3,5e6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 744:	f8b58513          	addi	a0,a1,-117
 748:	e119                	bnez	a0,74e <vprintf+0x26e>
 74a:	ea071be3          	bnez	a4,600 <vprintf+0x120>
      } else if(c0 == 'x'){
 74e:	07800513          	li	a0,120
 752:	eca784e3          	beq	a5,a0,61a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 756:	f8860613          	addi	a2,a2,-120
 75a:	e219                	bnez	a2,760 <vprintf+0x280>
 75c:	ec069be3          	bnez	a3,632 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 760:	f8858593          	addi	a1,a1,-120
 764:	e199                	bnez	a1,76a <vprintf+0x28a>
 766:	ee0713e3          	bnez	a4,64c <vprintf+0x16c>
      } else if(c0 == 'p'){
 76a:	07000713          	li	a4,112
 76e:	eee78ce3          	beq	a5,a4,666 <vprintf+0x186>
      } else if(c0 == 'c'){
 772:	06300713          	li	a4,99
 776:	f2e78ce3          	beq	a5,a4,6ae <vprintf+0x1ce>
      } else if(c0 == 's'){
 77a:	07300713          	li	a4,115
 77e:	f4e782e3          	beq	a5,a4,6c2 <vprintf+0x1e2>
      } else if(c0 == '%'){
 782:	02500713          	li	a4,37
 786:	f6e787e3          	beq	a5,a4,6f4 <vprintf+0x214>
        putc(fd, '%');
 78a:	02500593          	li	a1,37
 78e:	855a                	mv	a0,s6
 790:	c8fff0ef          	jal	41e <putc>
        putc(fd, c0);
 794:	85a6                	mv	a1,s1
 796:	855a                	mv	a0,s6
 798:	c87ff0ef          	jal	41e <putc>
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b359                	j	524 <vprintf+0x44>

00000000000007a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a0:	715d                	addi	sp,sp,-80
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e010                	sd	a2,0(s0)
 7aa:	e414                	sd	a3,8(s0)
 7ac:	e818                	sd	a4,16(s0)
 7ae:	ec1c                	sd	a5,24(s0)
 7b0:	03043023          	sd	a6,32(s0)
 7b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	8622                	mv	a2,s0
 7ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7be:	d23ff0ef          	jal	4e0 <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6161                	addi	sp,sp,80
 7c8:	8082                	ret

00000000000007ca <printf>:

void
printf(const char *fmt, ...)
{
 7ca:	711d                	addi	sp,sp,-96
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e40c                	sd	a1,8(s0)
 7d4:	e810                	sd	a2,16(s0)
 7d6:	ec14                	sd	a3,24(s0)
 7d8:	f018                	sd	a4,32(s0)
 7da:	f41c                	sd	a5,40(s0)
 7dc:	03043823          	sd	a6,48(s0)
 7e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	00840613          	addi	a2,s0,8
 7e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ec:	85aa                	mv	a1,a0
 7ee:	4505                	li	a0,1
 7f0:	cf1ff0ef          	jal	4e0 <vprintf>
}
 7f4:	60e2                	ld	ra,24(sp)
 7f6:	6442                	ld	s0,16(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fc:	1141                	addi	sp,sp,-16
 7fe:	e406                	sd	ra,8(sp)
 800:	e022                	sd	s0,0(sp)
 802:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 804:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	00000797          	auipc	a5,0x0
 80c:	7f87b783          	ld	a5,2040(a5) # 1000 <freep>
 810:	a039                	j	81e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	6398                	ld	a4,0(a5)
 814:	00e7e463          	bltu	a5,a4,81c <free+0x20>
 818:	00e6ea63          	bltu	a3,a4,82c <free+0x30>
{
 81c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	fed7fae3          	bgeu	a5,a3,812 <free+0x16>
 822:	6398                	ld	a4,0(a5)
 824:	00e6e463          	bltu	a3,a4,82c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	fee7eae3          	bltu	a5,a4,81c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 82c:	ff852583          	lw	a1,-8(a0)
 830:	6390                	ld	a2,0(a5)
 832:	02059813          	slli	a6,a1,0x20
 836:	01c85713          	srli	a4,a6,0x1c
 83a:	9736                	add	a4,a4,a3
 83c:	02e60563          	beq	a2,a4,866 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 844:	4790                	lw	a2,8(a5)
 846:	02061593          	slli	a1,a2,0x20
 84a:	01c5d713          	srli	a4,a1,0x1c
 84e:	973e                	add	a4,a4,a5
 850:	02e68263          	beq	a3,a4,874 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 854:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 856:	00000717          	auipc	a4,0x0
 85a:	7af73523          	sd	a5,1962(a4) # 1000 <freep>
}
 85e:	60a2                	ld	ra,8(sp)
 860:	6402                	ld	s0,0(sp)
 862:	0141                	addi	sp,sp,16
 864:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 866:	4618                	lw	a4,8(a2)
 868:	9f2d                	addw	a4,a4,a1
 86a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	6310                	ld	a2,0(a4)
 872:	b7f9                	j	840 <free+0x44>
    p->s.size += bp->s.size;
 874:	ff852703          	lw	a4,-8(a0)
 878:	9f31                	addw	a4,a4,a2
 87a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87c:	ff053683          	ld	a3,-16(a0)
 880:	bfd1                	j	854 <free+0x58>

0000000000000882 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 882:	7139                	addi	sp,sp,-64
 884:	fc06                	sd	ra,56(sp)
 886:	f822                	sd	s0,48(sp)
 888:	f04a                	sd	s2,32(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	02051993          	slli	s3,a0,0x20
 892:	0209d993          	srli	s3,s3,0x20
 896:	09bd                	addi	s3,s3,15
 898:	0049d993          	srli	s3,s3,0x4
 89c:	2985                	addiw	s3,s3,1
 89e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8a0:	00000517          	auipc	a0,0x0
 8a4:	76053503          	ld	a0,1888(a0) # 1000 <freep>
 8a8:	c905                	beqz	a0,8d8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ac:	4798                	lw	a4,8(a5)
 8ae:	09377663          	bgeu	a4,s3,93a <malloc+0xb8>
 8b2:	f426                	sd	s1,40(sp)
 8b4:	e852                	sd	s4,16(sp)
 8b6:	e456                	sd	s5,8(sp)
 8b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ba:	8a4e                	mv	s4,s3
 8bc:	6705                	lui	a4,0x1
 8be:	00e9f363          	bgeu	s3,a4,8c4 <malloc+0x42>
 8c2:	6a05                	lui	s4,0x1
 8c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8cc:	00000497          	auipc	s1,0x0
 8d0:	73448493          	addi	s1,s1,1844 # 1000 <freep>
  if(p == SBRK_ERROR)
 8d4:	5afd                	li	s5,-1
 8d6:	a83d                	j	914 <malloc+0x92>
 8d8:	f426                	sd	s1,40(sp)
 8da:	e852                	sd	s4,16(sp)
 8dc:	e456                	sd	s5,8(sp)
 8de:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e0:	00001797          	auipc	a5,0x1
 8e4:	92878793          	addi	a5,a5,-1752 # 1208 <base>
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70f73c23          	sd	a5,1816(a4) # 1000 <freep>
 8f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f6:	b7d1                	j	8ba <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8f8:	6398                	ld	a4,0(a5)
 8fa:	e118                	sd	a4,0(a0)
 8fc:	a899                	j	952 <malloc+0xd0>
  hp->s.size = nu;
 8fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 902:	0541                	addi	a0,a0,16
 904:	ef9ff0ef          	jal	7fc <free>
  return freep;
 908:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 90a:	c125                	beqz	a0,96a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	03277163          	bgeu	a4,s2,932 <malloc+0xb0>
    if(p == freep)
 914:	6098                	ld	a4,0(s1)
 916:	853e                	mv	a0,a5
 918:	fef71ae3          	bne	a4,a5,90c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 91c:	8552                	mv	a0,s4
 91e:	a2dff0ef          	jal	34a <sbrk>
  if(p == SBRK_ERROR)
 922:	fd551ee3          	bne	a0,s5,8fe <malloc+0x7c>
        return 0;
 926:	4501                	li	a0,0
 928:	74a2                	ld	s1,40(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	a03d                	j	95e <malloc+0xdc>
 932:	74a2                	ld	s1,40(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 93a:	fae90fe3          	beq	s2,a4,8f8 <malloc+0x76>
        p->s.size -= nunits;
 93e:	4137073b          	subw	a4,a4,s3
 942:	c798                	sw	a4,8(a5)
        p += p->s.size;
 944:	02071693          	slli	a3,a4,0x20
 948:	01c6d713          	srli	a4,a3,0x1c
 94c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 952:	00000717          	auipc	a4,0x0
 956:	6aa73723          	sd	a0,1710(a4) # 1000 <freep>
      return (void*)(p + 1);
 95a:	01078513          	addi	a0,a5,16
  }
}
 95e:	70e2                	ld	ra,56(sp)
 960:	7442                	ld	s0,48(sp)
 962:	7902                	ld	s2,32(sp)
 964:	69e2                	ld	s3,24(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
 96a:	74a2                	ld	s1,40(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	b7f5                	j	95e <malloc+0xdc>
