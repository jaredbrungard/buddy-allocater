
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };
  
  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	8a2e                	mv	s4,a1
  for (int i = 1; i < argc; i++){
  1a:	84be                	mv	s1,a5
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	392000ef          	jal	3b2 <fork>
    if(pid1 < 0){
  24:	00054b63          	bltz	a0,3a <main+0x3a>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  28:	c505                	beqz	a0,50 <main+0x50>
  for (int i = 1; i < argc; i++){
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  32:	4905                	li	s2,1
    wait(&xstatus);
  34:	fcc40993          	addi	s3,s0,-52
  38:	a871                	j	d4 <main+0xd4>
      printf("%s: fork failed\n", argv[0]);
  3a:	000a3583          	ld	a1,0(s4)
  3e:	00001517          	auipc	a0,0x1
  42:	98250513          	addi	a0,a0,-1662 # 9c0 <malloc+0xfa>
  46:	7c8000ef          	jal	80e <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	36e000ef          	jal	3ba <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	39c000ef          	jal	3fa <open>
  62:	89aa                	mv	s3,a0
      if(fd < 0){
  64:	04054063          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0'+i, SZ);
  68:	7d000613          	li	a2,2000
  6c:	0304859b          	addiw	a1,s1,48
  70:	00001517          	auipc	a0,0x1
  74:	fa050513          	addi	a0,a0,-96 # 1010 <buf>
  78:	118000ef          	jal	190 <memset>
  7c:	0fa00493          	li	s1,250
        if((n = write(fd, buf, SZ)) != SZ){
  80:	7d000913          	li	s2,2000
  84:	00001a17          	auipc	s4,0x1
  88:	f8ca0a13          	addi	s4,s4,-116 # 1010 <buf>
  8c:	864a                	mv	a2,s2
  8e:	85d2                	mv	a1,s4
  90:	854e                	mv	a0,s3
  92:	348000ef          	jal	3da <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for(i = 0; i < N; i++){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	31a000ef          	jal	3ba <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	92c50513          	addi	a0,a0,-1748 # 9d8 <malloc+0x112>
  b4:	75a000ef          	jal	80e <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	300000ef          	jal	3ba <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	93050513          	addi	a0,a0,-1744 # 9f0 <malloc+0x12a>
  c8:	746000ef          	jal	80e <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2ec000ef          	jal	3ba <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	2ec000ef          	jal	3c2 <wait>
    if(xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2497e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	2c0000ef          	jal	3ba <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10a:	ef7ff0ef          	jal	0 <main>
  exit(0);
 10e:	4501                	li	a0,0
 110:	2aa000ef          	jal	3ba <exit>

0000000000000114 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 114:	1141                	addi	sp,sp,-16
 116:	e406                	sd	ra,8(sp)
 118:	e022                	sd	s0,0(sp)
 11a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11c:	87aa                	mv	a5,a0
 11e:	0585                	addi	a1,a1,1
 120:	0785                	addi	a5,a5,1
 122:	fff5c703          	lbu	a4,-1(a1)
 126:	fee78fa3          	sb	a4,-1(a5)
 12a:	fb75                	bnez	a4,11e <strcpy+0xa>
    ;
  return os;
}
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cb91                	beqz	a5,154 <strcmp+0x20>
 142:	0005c703          	lbu	a4,0(a1)
 146:	00f71763          	bne	a4,a5,154 <strcmp+0x20>
    p++, q++;
 14a:	0505                	addi	a0,a0,1
 14c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbe5                	bnez	a5,142 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 154:	0005c503          	lbu	a0,0(a1)
}
 158:	40a7853b          	subw	a0,a5,a0
 15c:	60a2                	ld	ra,8(sp)
 15e:	6402                	ld	s0,0(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strlen>:

uint
strlen(const char *s)
{
 164:	1141                	addi	sp,sp,-16
 166:	e406                	sd	ra,8(sp)
 168:	e022                	sd	s0,0(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x28>
 172:	00150793          	addi	a5,a0,1
 176:	86be                	mv	a3,a5
 178:	0785                	addi	a5,a5,1
 17a:	fff7c703          	lbu	a4,-1(a5)
 17e:	ff65                	bnez	a4,176 <strlen+0x12>
 180:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfdd                	j	184 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 198:	ca19                	beqz	a2,1ae <memset+0x1e>
 19a:	87aa                	mv	a5,a0
 19c:	1602                	slli	a2,a2,0x20
 19e:	9201                	srli	a2,a2,0x20
 1a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a8:	0785                	addi	a5,a5,1
 1aa:	fee79de3          	bne	a5,a4,1a4 <memset+0x14>
  }
  return dst;
}
 1ae:	60a2                	ld	ra,8(sp)
 1b0:	6402                	ld	s0,0(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf81                	beqz	a5,1da <strchr+0x24>
    if(*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1c>
  for(; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xe>
      return (char*)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfdd                	j	1d2 <strchr+0x1c>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	e862                	sd	s8,16(sp)
 1f4:	1080                	addi	s0,sp,96
 1f6:	8baa                	mv	s7,a0
 1f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fa:	892a                	mv	s2,a0
 1fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1fe:	faf40b13          	addi	s6,s0,-81
 202:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 204:	8c26                	mv	s8,s1
 206:	0014899b          	addiw	s3,s1,1
 20a:	84ce                	mv	s1,s3
 20c:	0349d463          	bge	s3,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 210:	8656                	mv	a2,s5
 212:	85da                	mv	a1,s6
 214:	4501                	li	a0,0
 216:	1bc000ef          	jal	3d2 <read>
    if(cc < 1)
 21a:	00a05d63          	blez	a0,234 <gets+0x56>
      break;
    buf[i++] = c;
 21e:	faf44783          	lbu	a5,-81(s0)
 222:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 226:	0905                	addi	s2,s2,1
 228:	ff678713          	addi	a4,a5,-10
 22c:	c319                	beqz	a4,232 <gets+0x54>
 22e:	17cd                	addi	a5,a5,-13
 230:	fbf1                	bnez	a5,204 <gets+0x26>
    buf[i++] = c;
 232:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 234:	9c5e                	add	s8,s8,s7
 236:	000c0023          	sb	zero,0(s8)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6c42                	ld	s8,16(sp)
 250:	6125                	addi	sp,sp,96
 252:	8082                	ret

0000000000000254 <stat>:

int
stat(const char *n, struct stat *st)
{
 254:	1101                	addi	sp,sp,-32
 256:	ec06                	sd	ra,24(sp)
 258:	e822                	sd	s0,16(sp)
 25a:	e04a                	sd	s2,0(sp)
 25c:	1000                	addi	s0,sp,32
 25e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 260:	4581                	li	a1,0
 262:	198000ef          	jal	3fa <open>
  if(fd < 0)
 266:	02054263          	bltz	a0,28a <stat+0x36>
 26a:	e426                	sd	s1,8(sp)
 26c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26e:	85ca                	mv	a1,s2
 270:	1a2000ef          	jal	412 <fstat>
 274:	892a                	mv	s2,a0
  close(fd);
 276:	8526                	mv	a0,s1
 278:	16a000ef          	jal	3e2 <close>
  return r;
 27c:	64a2                	ld	s1,8(sp)
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	6902                	ld	s2,0(sp)
 286:	6105                	addi	sp,sp,32
 288:	8082                	ret
    return -1;
 28a:	57fd                	li	a5,-1
 28c:	893e                	mv	s2,a5
 28e:	bfc5                	j	27e <stat+0x2a>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 298:	00054683          	lbu	a3,0(a0)
 29c:	fd06879b          	addiw	a5,a3,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	4625                	li	a2,9
 2a6:	02f66963          	bltu	a2,a5,2d8 <atoi+0x48>
 2aa:	872a                	mv	a4,a0
  n = 0;
 2ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ae:	0705                	addi	a4,a4,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb5                	addw	a5,a5,a3
 2bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c0:	00074683          	lbu	a3,0(a4)
 2c4:	fd06879b          	addiw	a5,a3,-48
 2c8:	0ff7f793          	zext.b	a5,a5
 2cc:	fef671e3          	bgeu	a2,a5,2ae <atoi+0x1e>
  return n;
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  n = 0;
 2d8:	4501                	li	a0,0
 2da:	bfdd                	j	2d0 <atoi+0x40>

00000000000002dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57563          	bgeu	a0,a1,30e <memmove+0x32>
    while(n-- > 0)
 2e8:	00c05f63          	blez	a2,306 <memmove+0x2a>
 2ec:	1602                	slli	a2,a2,0x20
 2ee:	9201                	srli	a2,a2,0x20
 2f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f6:	0585                	addi	a1,a1,1
 2f8:	0705                	addi	a4,a4,1
 2fa:	fff5c683          	lbu	a3,-1(a1)
 2fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 302:	fee79ae3          	bne	a5,a4,2f6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    while(n-- > 0)
 30e:	fec05ce3          	blez	a2,306 <memmove+0x2a>
    dst += n;
 312:	00c50733          	add	a4,a0,a2
    src += n;
 316:	95b2                	add	a1,a1,a2
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 332:	fef71ae3          	bne	a4,a5,326 <memmove+0x4a>
 336:	bfc1                	j	306 <memmove+0x2a>

0000000000000338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 340:	c61d                	beqz	a2,36e <memcmp+0x36>
 342:	1602                	slli	a2,a2,0x20
 344:	9201                	srli	a2,a2,0x20
 346:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 34a:	00054783          	lbu	a5,0(a0)
 34e:	0005c703          	lbu	a4,0(a1)
 352:	00e79863          	bne	a5,a4,362 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 356:	0505                	addi	a0,a0,1
    p2++;
 358:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35a:	fed518e3          	bne	a0,a3,34a <memcmp+0x12>
  }
  return 0;
 35e:	4501                	li	a0,0
 360:	a019                	j	366 <memcmp+0x2e>
      return *p1 - *p2;
 362:	40e7853b          	subw	a0,a5,a4
}
 366:	60a2                	ld	ra,8(sp)
 368:	6402                	ld	s0,0(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  return 0;
 36e:	4501                	li	a0,0
 370:	bfdd                	j	366 <memcmp+0x2e>

0000000000000372 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37a:	f63ff0ef          	jal	2dc <memmove>
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <sbrk>:

char *
sbrk(int n) {
 386:	1141                	addi	sp,sp,-16
 388:	e406                	sd	ra,8(sp)
 38a:	e022                	sd	s0,0(sp)
 38c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 38e:	4585                	li	a1,1
 390:	0b2000ef          	jal	442 <sys_sbrk>
}
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret

000000000000039c <sbrklazy>:

char *
sbrklazy(int n) {
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a4:	4589                	li	a1,2
 3a6:	09c000ef          	jal	442 <sys_sbrk>
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret

00000000000003b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b2:	4885                	li	a7,1
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ba:	4889                	li	a7,2
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c2:	488d                	li	a7,3
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ca:	4891                	li	a7,4
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <read>:
.global read
read:
 li a7, SYS_read
 3d2:	4895                	li	a7,5
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <write>:
.global write
write:
 li a7, SYS_write
 3da:	48c1                	li	a7,16
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <close>:
.global close
close:
 li a7, SYS_close
 3e2:	48d5                	li	a7,21
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ea:	4899                	li	a7,6
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f2:	489d                	li	a7,7
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <open>:
.global open
open:
 li a7, SYS_open
 3fa:	48bd                	li	a7,15
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 402:	48c5                	li	a7,17
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 40a:	48c9                	li	a7,18
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 412:	48a1                	li	a7,8
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <link>:
.global link
link:
 li a7, SYS_link
 41a:	48cd                	li	a7,19
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 422:	48d1                	li	a7,20
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 42a:	48a5                	li	a7,9
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <dup>:
.global dup
dup:
 li a7, SYS_dup
 432:	48a9                	li	a7,10
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 43a:	48ad                	li	a7,11
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 442:	48b1                	li	a7,12
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <pause>:
.global pause
pause:
 li a7, SYS_pause
 44a:	48b5                	li	a7,13
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 452:	48b9                	li	a7,14
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 45a:	48d9                	li	a7,22
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 462:	1101                	addi	sp,sp,-32
 464:	ec06                	sd	ra,24(sp)
 466:	e822                	sd	s0,16(sp)
 468:	1000                	addi	s0,sp,32
 46a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46e:	4605                	li	a2,1
 470:	fef40593          	addi	a1,s0,-17
 474:	f67ff0ef          	jal	3da <write>
}
 478:	60e2                	ld	ra,24(sp)
 47a:	6442                	ld	s0,16(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 480:	715d                	addi	sp,sp,-80
 482:	e486                	sd	ra,72(sp)
 484:	e0a2                	sd	s0,64(sp)
 486:	f84a                	sd	s2,48(sp)
 488:	f44e                	sd	s3,40(sp)
 48a:	0880                	addi	s0,sp,80
 48c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48e:	cac1                	beqz	a3,51e <printint+0x9e>
 490:	0805d763          	bgez	a1,51e <printint+0x9e>
    neg = 1;
    x = -xx;
 494:	40b005bb          	negw	a1,a1
    neg = 1;
 498:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 49a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 49e:	86ce                	mv	a3,s3
  i = 0;
 4a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a2:	00000817          	auipc	a6,0x0
 4a6:	56e80813          	addi	a6,a6,1390 # a10 <digits>
 4aa:	88ba                	mv	a7,a4
 4ac:	0017051b          	addiw	a0,a4,1
 4b0:	872a                	mv	a4,a0
 4b2:	02c5f7bb          	remuw	a5,a1,a2
 4b6:	1782                	slli	a5,a5,0x20
 4b8:	9381                	srli	a5,a5,0x20
 4ba:	97c2                	add	a5,a5,a6
 4bc:	0007c783          	lbu	a5,0(a5)
 4c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c4:	87ae                	mv	a5,a1
 4c6:	02c5d5bb          	divuw	a1,a1,a2
 4ca:	0685                	addi	a3,a3,1
 4cc:	fcc7ffe3          	bgeu	a5,a2,4aa <printint+0x2a>
  if(neg)
 4d0:	00030c63          	beqz	t1,4e8 <printint+0x68>
    buf[i++] = '-';
 4d4:	fd050793          	addi	a5,a0,-48
 4d8:	00878533          	add	a0,a5,s0
 4dc:	02d00793          	li	a5,45
 4e0:	fef50423          	sb	a5,-24(a0)
 4e4:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4e8:	02e05563          	blez	a4,512 <printint+0x92>
 4ec:	fc26                	sd	s1,56(sp)
 4ee:	377d                	addiw	a4,a4,-1
 4f0:	00e984b3          	add	s1,s3,a4
 4f4:	19fd                	addi	s3,s3,-1
 4f6:	99ba                	add	s3,s3,a4
 4f8:	1702                	slli	a4,a4,0x20
 4fa:	9301                	srli	a4,a4,0x20
 4fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 500:	0004c583          	lbu	a1,0(s1)
 504:	854a                	mv	a0,s2
 506:	f5dff0ef          	jal	462 <putc>
  while(--i >= 0)
 50a:	14fd                	addi	s1,s1,-1
 50c:	ff349ae3          	bne	s1,s3,500 <printint+0x80>
 510:	74e2                	ld	s1,56(sp)
}
 512:	60a6                	ld	ra,72(sp)
 514:	6406                	ld	s0,64(sp)
 516:	7942                	ld	s2,48(sp)
 518:	79a2                	ld	s3,40(sp)
 51a:	6161                	addi	sp,sp,80
 51c:	8082                	ret
    x = xx;
 51e:	2581                	sext.w	a1,a1
  neg = 0;
 520:	4301                	li	t1,0
 522:	bfa5                	j	49a <printint+0x1a>

0000000000000524 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 524:	711d                	addi	sp,sp,-96
 526:	ec86                	sd	ra,88(sp)
 528:	e8a2                	sd	s0,80(sp)
 52a:	e4a6                	sd	s1,72(sp)
 52c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c483          	lbu	s1,0(a1)
 532:	22048363          	beqz	s1,758 <vprintf+0x234>
 536:	e0ca                	sd	s2,64(sp)
 538:	fc4e                	sd	s3,56(sp)
 53a:	f852                	sd	s4,48(sp)
 53c:	f456                	sd	s5,40(sp)
 53e:	f05a                	sd	s6,32(sp)
 540:	ec5e                	sd	s7,24(sp)
 542:	e862                	sd	s8,16(sp)
 544:	8b2a                	mv	s6,a0
 546:	8a2e                	mv	s4,a1
 548:	8bb2                	mv	s7,a2
  state = 0;
 54a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 54c:	4901                	li	s2,0
 54e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 550:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 554:	06400c13          	li	s8,100
 558:	a00d                	j	57a <vprintf+0x56>
        putc(fd, c0);
 55a:	85a6                	mv	a1,s1
 55c:	855a                	mv	a0,s6
 55e:	f05ff0ef          	jal	462 <putc>
 562:	a019                	j	568 <vprintf+0x44>
    } else if(state == '%'){
 564:	03598363          	beq	s3,s5,58a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 568:	0019079b          	addiw	a5,s2,1
 56c:	893e                	mv	s2,a5
 56e:	873e                	mv	a4,a5
 570:	97d2                	add	a5,a5,s4
 572:	0007c483          	lbu	s1,0(a5)
 576:	1c048a63          	beqz	s1,74a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 57a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 57e:	fe0993e3          	bnez	s3,564 <vprintf+0x40>
      if(c0 == '%'){
 582:	fd579ce3          	bne	a5,s5,55a <vprintf+0x36>
        state = '%';
 586:	89be                	mv	s3,a5
 588:	b7c5                	j	568 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 58a:	00ea06b3          	add	a3,s4,a4
 58e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 592:	1c060863          	beqz	a2,762 <vprintf+0x23e>
      if(c0 == 'd'){
 596:	03878763          	beq	a5,s8,5c4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 59a:	f9478693          	addi	a3,a5,-108
 59e:	0016b693          	seqz	a3,a3
 5a2:	f9c60593          	addi	a1,a2,-100
 5a6:	e99d                	bnez	a1,5dc <vprintf+0xb8>
 5a8:	ca95                	beqz	a3,5dc <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000bb583          	ld	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	ec9ff0ef          	jal	480 <printint>
        i += 1;
 5bc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b75d                	j	568 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	eafff0ef          	jal	480 <printint>
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b779                	j	568 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5dc:	9752                	add	a4,a4,s4
 5de:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e2:	f9460713          	addi	a4,a2,-108
 5e6:	00173713          	seqz	a4,a4
 5ea:	8f75                	and	a4,a4,a3
 5ec:	f9c58513          	addi	a0,a1,-100
 5f0:	18051363          	bnez	a0,776 <vprintf+0x252>
 5f4:	18070163          	beqz	a4,776 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e7bff0ef          	jal	480 <printint>
        i += 2;
 60a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
        i += 2;
 610:	bfa1                	j	568 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000be583          	lwu	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e61ff0ef          	jal	480 <printint>
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
 628:	b781                	j	568 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e49ff0ef          	jal	480 <printint>
        i += 1;
 63c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	b71d                	j	568 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	e2fff0ef          	jal	480 <printint>
        i += 2;
 656:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
        i += 2;
 65c:	b731                	j	568 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000be583          	lwu	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e15ff0ef          	jal	480 <printint>
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	bdd5                	j	568 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	008b8493          	addi	s1,s7,8
 67a:	4681                	li	a3,0
 67c:	4641                	li	a2,16
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	dfdff0ef          	jal	480 <printint>
        i += 1;
 688:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bde9                	j	568 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	de3ff0ef          	jal	480 <printint>
        i += 2;
 6a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 2;
 6a8:	b5c1                	j	568 <vprintf+0x44>
 6aa:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6ac:	008b8793          	addi	a5,s7,8
 6b0:	8cbe                	mv	s9,a5
 6b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b6:	03000593          	li	a1,48
 6ba:	855a                	mv	a0,s6
 6bc:	da7ff0ef          	jal	462 <putc>
  putc(fd, 'x');
 6c0:	07800593          	li	a1,120
 6c4:	855a                	mv	a0,s6
 6c6:	d9dff0ef          	jal	462 <putc>
 6ca:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6cc:	00000b97          	auipc	s7,0x0
 6d0:	344b8b93          	addi	s7,s7,836 # a10 <digits>
 6d4:	03c9d793          	srli	a5,s3,0x3c
 6d8:	97de                	add	a5,a5,s7
 6da:	0007c583          	lbu	a1,0(a5)
 6de:	855a                	mv	a0,s6
 6e0:	d83ff0ef          	jal	462 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e4:	0992                	slli	s3,s3,0x4
 6e6:	34fd                	addiw	s1,s1,-1
 6e8:	f4f5                	bnez	s1,6d4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6ea:	8be6                	mv	s7,s9
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	6ca2                	ld	s9,8(sp)
 6f0:	bda5                	j	568 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6f2:	008b8493          	addi	s1,s7,8
 6f6:	000bc583          	lbu	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	d67ff0ef          	jal	462 <putc>
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
 704:	b595                	j	568 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 706:	008b8993          	addi	s3,s7,8
 70a:	000bb483          	ld	s1,0(s7)
 70e:	cc91                	beqz	s1,72a <vprintf+0x206>
        for(; *s; s++)
 710:	0004c583          	lbu	a1,0(s1)
 714:	c985                	beqz	a1,744 <vprintf+0x220>
          putc(fd, *s);
 716:	855a                	mv	a0,s6
 718:	d4bff0ef          	jal	462 <putc>
        for(; *s; s++)
 71c:	0485                	addi	s1,s1,1
 71e:	0004c583          	lbu	a1,0(s1)
 722:	f9f5                	bnez	a1,716 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	b581                	j	568 <vprintf+0x44>
          s = "(null)";
 72a:	00000497          	auipc	s1,0x0
 72e:	2de48493          	addi	s1,s1,734 # a08 <malloc+0x142>
        for(; *s; s++)
 732:	02800593          	li	a1,40
 736:	b7c5                	j	716 <vprintf+0x1f2>
        putc(fd, '%');
 738:	85be                	mv	a1,a5
 73a:	855a                	mv	a0,s6
 73c:	d27ff0ef          	jal	462 <putc>
      state = 0;
 740:	4981                	li	s3,0
 742:	b51d                	j	568 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 744:	8bce                	mv	s7,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	b505                	j	568 <vprintf+0x44>
 74a:	6906                	ld	s2,64(sp)
 74c:	79e2                	ld	s3,56(sp)
 74e:	7a42                	ld	s4,48(sp)
 750:	7aa2                	ld	s5,40(sp)
 752:	7b02                	ld	s6,32(sp)
 754:	6be2                	ld	s7,24(sp)
 756:	6c42                	ld	s8,16(sp)
    }
  }
}
 758:	60e6                	ld	ra,88(sp)
 75a:	6446                	ld	s0,80(sp)
 75c:	64a6                	ld	s1,72(sp)
 75e:	6125                	addi	sp,sp,96
 760:	8082                	ret
      if(c0 == 'd'){
 762:	06400713          	li	a4,100
 766:	e4e78fe3          	beq	a5,a4,5c4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 76a:	f9478693          	addi	a3,a5,-108
 76e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 772:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 774:	4701                	li	a4,0
      } else if(c0 == 'u'){
 776:	07500513          	li	a0,117
 77a:	e8a78ce3          	beq	a5,a0,612 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 77e:	f8b60513          	addi	a0,a2,-117
 782:	e119                	bnez	a0,788 <vprintf+0x264>
 784:	ea0693e3          	bnez	a3,62a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 788:	f8b58513          	addi	a0,a1,-117
 78c:	e119                	bnez	a0,792 <vprintf+0x26e>
 78e:	ea071be3          	bnez	a4,644 <vprintf+0x120>
      } else if(c0 == 'x'){
 792:	07800513          	li	a0,120
 796:	eca784e3          	beq	a5,a0,65e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 79a:	f8860613          	addi	a2,a2,-120
 79e:	e219                	bnez	a2,7a4 <vprintf+0x280>
 7a0:	ec069be3          	bnez	a3,676 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a4:	f8858593          	addi	a1,a1,-120
 7a8:	e199                	bnez	a1,7ae <vprintf+0x28a>
 7aa:	ee0713e3          	bnez	a4,690 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7ae:	07000713          	li	a4,112
 7b2:	eee78ce3          	beq	a5,a4,6aa <vprintf+0x186>
      } else if(c0 == 'c'){
 7b6:	06300713          	li	a4,99
 7ba:	f2e78ce3          	beq	a5,a4,6f2 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7be:	07300713          	li	a4,115
 7c2:	f4e782e3          	beq	a5,a4,706 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7c6:	02500713          	li	a4,37
 7ca:	f6e787e3          	beq	a5,a4,738 <vprintf+0x214>
        putc(fd, '%');
 7ce:	02500593          	li	a1,37
 7d2:	855a                	mv	a0,s6
 7d4:	c8fff0ef          	jal	462 <putc>
        putc(fd, c0);
 7d8:	85a6                	mv	a1,s1
 7da:	855a                	mv	a0,s6
 7dc:	c87ff0ef          	jal	462 <putc>
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b359                	j	568 <vprintf+0x44>

00000000000007e4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e4:	715d                	addi	sp,sp,-80
 7e6:	ec06                	sd	ra,24(sp)
 7e8:	e822                	sd	s0,16(sp)
 7ea:	1000                	addi	s0,sp,32
 7ec:	e010                	sd	a2,0(s0)
 7ee:	e414                	sd	a3,8(s0)
 7f0:	e818                	sd	a4,16(s0)
 7f2:	ec1c                	sd	a5,24(s0)
 7f4:	03043023          	sd	a6,32(s0)
 7f8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	8622                	mv	a2,s0
 7fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 802:	d23ff0ef          	jal	524 <vprintf>
}
 806:	60e2                	ld	ra,24(sp)
 808:	6442                	ld	s0,16(sp)
 80a:	6161                	addi	sp,sp,80
 80c:	8082                	ret

000000000000080e <printf>:

void
printf(const char *fmt, ...)
{
 80e:	711d                	addi	sp,sp,-96
 810:	ec06                	sd	ra,24(sp)
 812:	e822                	sd	s0,16(sp)
 814:	1000                	addi	s0,sp,32
 816:	e40c                	sd	a1,8(s0)
 818:	e810                	sd	a2,16(s0)
 81a:	ec14                	sd	a3,24(s0)
 81c:	f018                	sd	a4,32(s0)
 81e:	f41c                	sd	a5,40(s0)
 820:	03043823          	sd	a6,48(s0)
 824:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 828:	00840613          	addi	a2,s0,8
 82c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 830:	85aa                	mv	a1,a0
 832:	4505                	li	a0,1
 834:	cf1ff0ef          	jal	524 <vprintf>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6125                	addi	sp,sp,96
 83e:	8082                	ret

0000000000000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	1141                	addi	sp,sp,-16
 842:	e406                	sd	ra,8(sp)
 844:	e022                	sd	s0,0(sp)
 846:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 848:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	00000797          	auipc	a5,0x0
 850:	7b47b783          	ld	a5,1972(a5) # 1000 <freep>
 854:	a039                	j	862 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	6398                	ld	a4,0(a5)
 858:	00e7e463          	bltu	a5,a4,860 <free+0x20>
 85c:	00e6ea63          	bltu	a3,a4,870 <free+0x30>
{
 860:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	fed7fae3          	bgeu	a5,a3,856 <free+0x16>
 866:	6398                	ld	a4,0(a5)
 868:	00e6e463          	bltu	a3,a4,870 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	fee7eae3          	bltu	a5,a4,860 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 870:	ff852583          	lw	a1,-8(a0)
 874:	6390                	ld	a2,0(a5)
 876:	02059813          	slli	a6,a1,0x20
 87a:	01c85713          	srli	a4,a6,0x1c
 87e:	9736                	add	a4,a4,a3
 880:	02e60563          	beq	a2,a4,8aa <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 884:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 888:	4790                	lw	a2,8(a5)
 88a:	02061593          	slli	a1,a2,0x20
 88e:	01c5d713          	srli	a4,a1,0x1c
 892:	973e                	add	a4,a4,a5
 894:	02e68263          	beq	a3,a4,8b8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 898:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
}
 8a2:	60a2                	ld	ra,8(sp)
 8a4:	6402                	ld	s0,0(sp)
 8a6:	0141                	addi	sp,sp,16
 8a8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8aa:	4618                	lw	a4,8(a2)
 8ac:	9f2d                	addw	a4,a4,a1
 8ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	6310                	ld	a2,0(a4)
 8b6:	b7f9                	j	884 <free+0x44>
    p->s.size += bp->s.size;
 8b8:	ff852703          	lw	a4,-8(a0)
 8bc:	9f31                	addw	a4,a4,a2
 8be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c0:	ff053683          	ld	a3,-16(a0)
 8c4:	bfd1                	j	898 <free+0x58>

00000000000008c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c6:	7139                	addi	sp,sp,-64
 8c8:	fc06                	sd	ra,56(sp)
 8ca:	f822                	sd	s0,48(sp)
 8cc:	f04a                	sd	s2,32(sp)
 8ce:	ec4e                	sd	s3,24(sp)
 8d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d2:	02051993          	slli	s3,a0,0x20
 8d6:	0209d993          	srli	s3,s3,0x20
 8da:	09bd                	addi	s3,s3,15
 8dc:	0049d993          	srli	s3,s3,0x4
 8e0:	2985                	addiw	s3,s3,1
 8e2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8e4:	00000517          	auipc	a0,0x0
 8e8:	71c53503          	ld	a0,1820(a0) # 1000 <freep>
 8ec:	c905                	beqz	a0,91c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f0:	4798                	lw	a4,8(a5)
 8f2:	09377663          	bgeu	a4,s3,97e <malloc+0xb8>
 8f6:	f426                	sd	s1,40(sp)
 8f8:	e852                	sd	s4,16(sp)
 8fa:	e456                	sd	s5,8(sp)
 8fc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8fe:	8a4e                	mv	s4,s3
 900:	6705                	lui	a4,0x1
 902:	00e9f363          	bgeu	s3,a4,908 <malloc+0x42>
 906:	6a05                	lui	s4,0x1
 908:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 910:	00000497          	auipc	s1,0x0
 914:	6f048493          	addi	s1,s1,1776 # 1000 <freep>
  if(p == SBRK_ERROR)
 918:	5afd                	li	s5,-1
 91a:	a83d                	j	958 <malloc+0x92>
 91c:	f426                	sd	s1,40(sp)
 91e:	e852                	sd	s4,16(sp)
 920:	e456                	sd	s5,8(sp)
 922:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 924:	00001797          	auipc	a5,0x1
 928:	8e478793          	addi	a5,a5,-1820 # 1208 <base>
 92c:	00000717          	auipc	a4,0x0
 930:	6cf73a23          	sd	a5,1748(a4) # 1000 <freep>
 934:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 936:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 93a:	b7d1                	j	8fe <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 93c:	6398                	ld	a4,0(a5)
 93e:	e118                	sd	a4,0(a0)
 940:	a899                	j	996 <malloc+0xd0>
  hp->s.size = nu;
 942:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 946:	0541                	addi	a0,a0,16
 948:	ef9ff0ef          	jal	840 <free>
  return freep;
 94c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 94e:	c125                	beqz	a0,9ae <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	03277163          	bgeu	a4,s2,976 <malloc+0xb0>
    if(p == freep)
 958:	6098                	ld	a4,0(s1)
 95a:	853e                	mv	a0,a5
 95c:	fef71ae3          	bne	a4,a5,950 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 960:	8552                	mv	a0,s4
 962:	a25ff0ef          	jal	386 <sbrk>
  if(p == SBRK_ERROR)
 966:	fd551ee3          	bne	a0,s5,942 <malloc+0x7c>
        return 0;
 96a:	4501                	li	a0,0
 96c:	74a2                	ld	s1,40(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
 974:	a03d                	j	9a2 <malloc+0xdc>
 976:	74a2                	ld	s1,40(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 97e:	fae90fe3          	beq	s2,a4,93c <malloc+0x76>
        p->s.size -= nunits;
 982:	4137073b          	subw	a4,a4,s3
 986:	c798                	sw	a4,8(a5)
        p += p->s.size;
 988:	02071693          	slli	a3,a4,0x20
 98c:	01c6d713          	srli	a4,a3,0x1c
 990:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 992:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 996:	00000717          	auipc	a4,0x0
 99a:	66a73523          	sd	a0,1642(a4) # 1000 <freep>
      return (void*)(p + 1);
 99e:	01078513          	addi	a0,a5,16
  }
}
 9a2:	70e2                	ld	ra,56(sp)
 9a4:	7442                	ld	s0,48(sp)
 9a6:	7902                	ld	s2,32(sp)
 9a8:	69e2                	ld	s3,24(sp)
 9aa:	6121                	addi	sp,sp,64
 9ac:	8082                	ret
 9ae:	74a2                	ld	s1,40(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	b7f5                	j	9a2 <malloc+0xdc>
