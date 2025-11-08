
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	96250513          	addi	a0,a0,-1694 # 970 <malloc+0xf8>
  16:	39e000ef          	jal	3b4 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3cc000ef          	jal	3ec <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3c6000ef          	jal	3ec <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	94e90913          	addi	s2,s2,-1714 # 978 <malloc+0x100>
  32:	854a                	mv	a0,s2
  34:	78c000ef          	jal	7c0 <printf>
    pid = fork();
  38:	334000ef          	jal	36c <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	336000ef          	jal	37c <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	97650513          	addi	a0,a0,-1674 # 9c8 <malloc+0x150>
  5a:	766000ef          	jal	7c0 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	314000ef          	jal	374 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	90850513          	addi	a0,a0,-1784 # 970 <malloc+0xf8>
  70:	34c000ef          	jal	3bc <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8fa50513          	addi	a0,a0,-1798 # 970 <malloc+0xf8>
  7e:	336000ef          	jal	3b4 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	90c50513          	addi	a0,a0,-1780 # 990 <malloc+0x118>
  8c:	734000ef          	jal	7c0 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2e2000ef          	jal	374 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	90a50513          	addi	a0,a0,-1782 # 9a8 <malloc+0x130>
  a6:	306000ef          	jal	3ac <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	90650513          	addi	a0,a0,-1786 # 9b0 <malloc+0x138>
  b2:	70e000ef          	jal	7c0 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2bc000ef          	jal	374 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c4:	f3dff0ef          	jal	0 <main>
  exit(0);
  c8:	4501                	li	a0,0
  ca:	2aa000ef          	jal	374 <exit>

00000000000000ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e406                	sd	ra,8(sp)
  d2:	e022                	sd	s0,0(sp)
  d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d6:	87aa                	mv	a5,a0
  d8:	0585                	addi	a1,a1,1
  da:	0785                	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fb75                	bnez	a4,d8 <strcpy+0xa>
    ;
  return os;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x20>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x20>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf91                	beqz	a5,146 <strlen+0x28>
 12c:	00150793          	addi	a5,a0,1
 130:	86be                	mv	a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	ff65                	bnez	a4,130 <strlen+0x12>
 13a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  for(n = 0; s[n]; n++)
 146:	4501                	li	a0,0
 148:	bfdd                	j	13e <strlen+0x20>

000000000000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 152:	ca19                	beqz	a2,168 <memset+0x1e>
 154:	87aa                	mv	a5,a0
 156:	1602                	slli	a2,a2,0x20
 158:	9201                	srli	a2,a2,0x20
 15a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 162:	0785                	addi	a5,a5,1
 164:	fee79de3          	bne	a5,a4,15e <memset+0x14>
  }
  return dst;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret

0000000000000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	1141                	addi	sp,sp,-16
 172:	e406                	sd	ra,8(sp)
 174:	e022                	sd	s0,0(sp)
 176:	0800                	addi	s0,sp,16
  for(; *s; s++)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cf81                	beqz	a5,194 <strchr+0x24>
    if(*s == c)
 17e:	00f58763          	beq	a1,a5,18c <strchr+0x1c>
  for(; *s; s++)
 182:	0505                	addi	a0,a0,1
 184:	00054783          	lbu	a5,0(a0)
 188:	fbfd                	bnez	a5,17e <strchr+0xe>
      return (char*)s;
  return 0;
 18a:	4501                	li	a0,0
}
 18c:	60a2                	ld	ra,8(sp)
 18e:	6402                	ld	s0,0(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  return 0;
 194:	4501                	li	a0,0
 196:	bfdd                	j	18c <strchr+0x1c>

0000000000000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	711d                	addi	sp,sp,-96
 19a:	ec86                	sd	ra,88(sp)
 19c:	e8a2                	sd	s0,80(sp)
 19e:	e4a6                	sd	s1,72(sp)
 1a0:	e0ca                	sd	s2,64(sp)
 1a2:	fc4e                	sd	s3,56(sp)
 1a4:	f852                	sd	s4,48(sp)
 1a6:	f456                	sd	s5,40(sp)
 1a8:	f05a                	sd	s6,32(sp)
 1aa:	ec5e                	sd	s7,24(sp)
 1ac:	e862                	sd	s8,16(sp)
 1ae:	1080                	addi	s0,sp,96
 1b0:	8baa                	mv	s7,a0
 1b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b4:	892a                	mv	s2,a0
 1b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b8:	faf40b13          	addi	s6,s0,-81
 1bc:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1be:	8c26                	mv	s8,s1
 1c0:	0014899b          	addiw	s3,s1,1
 1c4:	84ce                	mv	s1,s3
 1c6:	0349d463          	bge	s3,s4,1ee <gets+0x56>
    cc = read(0, &c, 1);
 1ca:	8656                	mv	a2,s5
 1cc:	85da                	mv	a1,s6
 1ce:	4501                	li	a0,0
 1d0:	1bc000ef          	jal	38c <read>
    if(cc < 1)
 1d4:	00a05d63          	blez	a0,1ee <gets+0x56>
      break;
    buf[i++] = c;
 1d8:	faf44783          	lbu	a5,-81(s0)
 1dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e0:	0905                	addi	s2,s2,1
 1e2:	ff678713          	addi	a4,a5,-10
 1e6:	c319                	beqz	a4,1ec <gets+0x54>
 1e8:	17cd                	addi	a5,a5,-13
 1ea:	fbf1                	bnez	a5,1be <gets+0x26>
    buf[i++] = c;
 1ec:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ee:	9c5e                	add	s8,s8,s7
 1f0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1f4:	855e                	mv	a0,s7
 1f6:	60e6                	ld	ra,88(sp)
 1f8:	6446                	ld	s0,80(sp)
 1fa:	64a6                	ld	s1,72(sp)
 1fc:	6906                	ld	s2,64(sp)
 1fe:	79e2                	ld	s3,56(sp)
 200:	7a42                	ld	s4,48(sp)
 202:	7aa2                	ld	s5,40(sp)
 204:	7b02                	ld	s6,32(sp)
 206:	6be2                	ld	s7,24(sp)
 208:	6c42                	ld	s8,16(sp)
 20a:	6125                	addi	sp,sp,96
 20c:	8082                	ret

000000000000020e <stat>:

int
stat(const char *n, struct stat *st)
{
 20e:	1101                	addi	sp,sp,-32
 210:	ec06                	sd	ra,24(sp)
 212:	e822                	sd	s0,16(sp)
 214:	e04a                	sd	s2,0(sp)
 216:	1000                	addi	s0,sp,32
 218:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21a:	4581                	li	a1,0
 21c:	198000ef          	jal	3b4 <open>
  if(fd < 0)
 220:	02054263          	bltz	a0,244 <stat+0x36>
 224:	e426                	sd	s1,8(sp)
 226:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 228:	85ca                	mv	a1,s2
 22a:	1a2000ef          	jal	3cc <fstat>
 22e:	892a                	mv	s2,a0
  close(fd);
 230:	8526                	mv	a0,s1
 232:	16a000ef          	jal	39c <close>
  return r;
 236:	64a2                	ld	s1,8(sp)
}
 238:	854a                	mv	a0,s2
 23a:	60e2                	ld	ra,24(sp)
 23c:	6442                	ld	s0,16(sp)
 23e:	6902                	ld	s2,0(sp)
 240:	6105                	addi	sp,sp,32
 242:	8082                	ret
    return -1;
 244:	57fd                	li	a5,-1
 246:	893e                	mv	s2,a5
 248:	bfc5                	j	238 <stat+0x2a>

000000000000024a <atoi>:

int
atoi(const char *s)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66963          	bltu	a2,a5,292 <atoi+0x48>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	addi	a4,a4,1
 26a:	0025179b          	slliw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	slliw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1e>
  return n;
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret
  n = 0;
 292:	4501                	li	a0,0
 294:	bfdd                	j	28a <atoi+0x40>

0000000000000296 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29e:	02b57563          	bgeu	a0,a1,2c8 <memmove+0x32>
    while(n-- > 0)
 2a2:	00c05f63          	blez	a2,2c0 <memmove+0x2a>
 2a6:	1602                	slli	a2,a2,0x20
 2a8:	9201                	srli	a2,a2,0x20
 2aa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b0:	0585                	addi	a1,a1,1
 2b2:	0705                	addi	a4,a4,1
 2b4:	fff5c683          	lbu	a3,-1(a1)
 2b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2bc:	fee79ae3          	bne	a5,a4,2b0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
    while(n-- > 0)
 2c8:	fec05ce3          	blez	a2,2c0 <memmove+0x2a>
    dst += n;
 2cc:	00c50733          	add	a4,a0,a2
    src += n;
 2d0:	95b2                	add	a1,a1,a2
 2d2:	fff6079b          	addiw	a5,a2,-1
 2d6:	1782                	slli	a5,a5,0x20
 2d8:	9381                	srli	a5,a5,0x20
 2da:	fff7c793          	not	a5,a5
 2de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e0:	15fd                	addi	a1,a1,-1
 2e2:	177d                	addi	a4,a4,-1
 2e4:	0005c683          	lbu	a3,0(a1)
 2e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ec:	fef71ae3          	bne	a4,a5,2e0 <memmove+0x4a>
 2f0:	bfc1                	j	2c0 <memmove+0x2a>

00000000000002f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fa:	c61d                	beqz	a2,328 <memcmp+0x36>
 2fc:	1602                	slli	a2,a2,0x20
 2fe:	9201                	srli	a2,a2,0x20
 300:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 304:	00054783          	lbu	a5,0(a0)
 308:	0005c703          	lbu	a4,0(a1)
 30c:	00e79863          	bne	a5,a4,31c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 310:	0505                	addi	a0,a0,1
    p2++;
 312:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 314:	fed518e3          	bne	a0,a3,304 <memcmp+0x12>
  }
  return 0;
 318:	4501                	li	a0,0
 31a:	a019                	j	320 <memcmp+0x2e>
      return *p1 - *p2;
 31c:	40e7853b          	subw	a0,a5,a4
}
 320:	60a2                	ld	ra,8(sp)
 322:	6402                	ld	s0,0(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  return 0;
 328:	4501                	li	a0,0
 32a:	bfdd                	j	320 <memcmp+0x2e>

000000000000032c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 334:	f63ff0ef          	jal	296 <memmove>
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <sbrk>:

char *
sbrk(int n) {
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 348:	4585                	li	a1,1
 34a:	0b2000ef          	jal	3fc <sys_sbrk>
}
 34e:	60a2                	ld	ra,8(sp)
 350:	6402                	ld	s0,0(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <sbrklazy>:

char *
sbrklazy(int n) {
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 35e:	4589                	li	a1,2
 360:	09c000ef          	jal	3fc <sys_sbrk>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36c:	4885                	li	a7,1
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <exit>:
.global exit
exit:
 li a7, SYS_exit
 374:	4889                	li	a7,2
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <wait>:
.global wait
wait:
 li a7, SYS_wait
 37c:	488d                	li	a7,3
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 384:	4891                	li	a7,4
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <read>:
.global read
read:
 li a7, SYS_read
 38c:	4895                	li	a7,5
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <write>:
.global write
write:
 li a7, SYS_write
 394:	48c1                	li	a7,16
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <close>:
.global close
close:
 li a7, SYS_close
 39c:	48d5                	li	a7,21
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a4:	4899                	li	a7,6
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ac:	489d                	li	a7,7
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <open>:
.global open
open:
 li a7, SYS_open
 3b4:	48bd                	li	a7,15
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3bc:	48c5                	li	a7,17
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c4:	48c9                	li	a7,18
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3cc:	48a1                	li	a7,8
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <link>:
.global link
link:
 li a7, SYS_link
 3d4:	48cd                	li	a7,19
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3dc:	48d1                	li	a7,20
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e4:	48a5                	li	a7,9
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ec:	48a9                	li	a7,10
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f4:	48ad                	li	a7,11
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3fc:	48b1                	li	a7,12
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pause>:
.global pause
pause:
 li a7, SYS_pause
 404:	48b5                	li	a7,13
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40c:	48b9                	li	a7,14
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 414:	1101                	addi	sp,sp,-32
 416:	ec06                	sd	ra,24(sp)
 418:	e822                	sd	s0,16(sp)
 41a:	1000                	addi	s0,sp,32
 41c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 420:	4605                	li	a2,1
 422:	fef40593          	addi	a1,s0,-17
 426:	f6fff0ef          	jal	394 <write>
}
 42a:	60e2                	ld	ra,24(sp)
 42c:	6442                	ld	s0,16(sp)
 42e:	6105                	addi	sp,sp,32
 430:	8082                	ret

0000000000000432 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 432:	715d                	addi	sp,sp,-80
 434:	e486                	sd	ra,72(sp)
 436:	e0a2                	sd	s0,64(sp)
 438:	f84a                	sd	s2,48(sp)
 43a:	f44e                	sd	s3,40(sp)
 43c:	0880                	addi	s0,sp,80
 43e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 440:	cac1                	beqz	a3,4d0 <printint+0x9e>
 442:	0805d763          	bgez	a1,4d0 <printint+0x9e>
    neg = 1;
    x = -xx;
 446:	40b005bb          	negw	a1,a1
    neg = 1;
 44a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 44c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 450:	86ce                	mv	a3,s3
  i = 0;
 452:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 454:	00000817          	auipc	a6,0x0
 458:	59c80813          	addi	a6,a6,1436 # 9f0 <digits>
 45c:	88ba                	mv	a7,a4
 45e:	0017051b          	addiw	a0,a4,1
 462:	872a                	mv	a4,a0
 464:	02c5f7bb          	remuw	a5,a1,a2
 468:	1782                	slli	a5,a5,0x20
 46a:	9381                	srli	a5,a5,0x20
 46c:	97c2                	add	a5,a5,a6
 46e:	0007c783          	lbu	a5,0(a5)
 472:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 476:	87ae                	mv	a5,a1
 478:	02c5d5bb          	divuw	a1,a1,a2
 47c:	0685                	addi	a3,a3,1
 47e:	fcc7ffe3          	bgeu	a5,a2,45c <printint+0x2a>
  if(neg)
 482:	00030c63          	beqz	t1,49a <printint+0x68>
    buf[i++] = '-';
 486:	fd050793          	addi	a5,a0,-48
 48a:	00878533          	add	a0,a5,s0
 48e:	02d00793          	li	a5,45
 492:	fef50423          	sb	a5,-24(a0)
 496:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 49a:	02e05563          	blez	a4,4c4 <printint+0x92>
 49e:	fc26                	sd	s1,56(sp)
 4a0:	377d                	addiw	a4,a4,-1
 4a2:	00e984b3          	add	s1,s3,a4
 4a6:	19fd                	addi	s3,s3,-1
 4a8:	99ba                	add	s3,s3,a4
 4aa:	1702                	slli	a4,a4,0x20
 4ac:	9301                	srli	a4,a4,0x20
 4ae:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b2:	0004c583          	lbu	a1,0(s1)
 4b6:	854a                	mv	a0,s2
 4b8:	f5dff0ef          	jal	414 <putc>
  while(--i >= 0)
 4bc:	14fd                	addi	s1,s1,-1
 4be:	ff349ae3          	bne	s1,s3,4b2 <printint+0x80>
 4c2:	74e2                	ld	s1,56(sp)
}
 4c4:	60a6                	ld	ra,72(sp)
 4c6:	6406                	ld	s0,64(sp)
 4c8:	7942                	ld	s2,48(sp)
 4ca:	79a2                	ld	s3,40(sp)
 4cc:	6161                	addi	sp,sp,80
 4ce:	8082                	ret
    x = xx;
 4d0:	2581                	sext.w	a1,a1
  neg = 0;
 4d2:	4301                	li	t1,0
 4d4:	bfa5                	j	44c <printint+0x1a>

00000000000004d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d6:	711d                	addi	sp,sp,-96
 4d8:	ec86                	sd	ra,88(sp)
 4da:	e8a2                	sd	s0,80(sp)
 4dc:	e4a6                	sd	s1,72(sp)
 4de:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e0:	0005c483          	lbu	s1,0(a1)
 4e4:	22048363          	beqz	s1,70a <vprintf+0x234>
 4e8:	e0ca                	sd	s2,64(sp)
 4ea:	fc4e                	sd	s3,56(sp)
 4ec:	f852                	sd	s4,48(sp)
 4ee:	f456                	sd	s5,40(sp)
 4f0:	f05a                	sd	s6,32(sp)
 4f2:	ec5e                	sd	s7,24(sp)
 4f4:	e862                	sd	s8,16(sp)
 4f6:	8b2a                	mv	s6,a0
 4f8:	8a2e                	mv	s4,a1
 4fa:	8bb2                	mv	s7,a2
  state = 0;
 4fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4fe:	4901                	li	s2,0
 500:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 502:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 506:	06400c13          	li	s8,100
 50a:	a00d                	j	52c <vprintf+0x56>
        putc(fd, c0);
 50c:	85a6                	mv	a1,s1
 50e:	855a                	mv	a0,s6
 510:	f05ff0ef          	jal	414 <putc>
 514:	a019                	j	51a <vprintf+0x44>
    } else if(state == '%'){
 516:	03598363          	beq	s3,s5,53c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 51a:	0019079b          	addiw	a5,s2,1
 51e:	893e                	mv	s2,a5
 520:	873e                	mv	a4,a5
 522:	97d2                	add	a5,a5,s4
 524:	0007c483          	lbu	s1,0(a5)
 528:	1c048a63          	beqz	s1,6fc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 52c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 530:	fe0993e3          	bnez	s3,516 <vprintf+0x40>
      if(c0 == '%'){
 534:	fd579ce3          	bne	a5,s5,50c <vprintf+0x36>
        state = '%';
 538:	89be                	mv	s3,a5
 53a:	b7c5                	j	51a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 53c:	00ea06b3          	add	a3,s4,a4
 540:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 544:	1c060863          	beqz	a2,714 <vprintf+0x23e>
      if(c0 == 'd'){
 548:	03878763          	beq	a5,s8,576 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 54c:	f9478693          	addi	a3,a5,-108
 550:	0016b693          	seqz	a3,a3
 554:	f9c60593          	addi	a1,a2,-100
 558:	e99d                	bnez	a1,58e <vprintf+0xb8>
 55a:	ca95                	beqz	a3,58e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	008b8493          	addi	s1,s7,8
 560:	4685                	li	a3,1
 562:	4629                	li	a2,10
 564:	000bb583          	ld	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	ec9ff0ef          	jal	432 <printint>
        i += 1;
 56e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 570:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 572:	4981                	li	s3,0
 574:	b75d                	j	51a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 576:	008b8493          	addi	s1,s7,8
 57a:	4685                	li	a3,1
 57c:	4629                	li	a2,10
 57e:	000ba583          	lw	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	eafff0ef          	jal	432 <printint>
 588:	8ba6                	mv	s7,s1
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b779                	j	51a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 58e:	9752                	add	a4,a4,s4
 590:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 594:	f9460713          	addi	a4,a2,-108
 598:	00173713          	seqz	a4,a4
 59c:	8f75                	and	a4,a4,a3
 59e:	f9c58513          	addi	a0,a1,-100
 5a2:	18051363          	bnez	a0,728 <vprintf+0x252>
 5a6:	18070163          	beqz	a4,728 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000bb583          	ld	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e7bff0ef          	jal	432 <printint>
        i += 2;
 5bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	8ba6                	mv	s7,s1
      state = 0;
 5c0:	4981                	li	s3,0
        i += 2;
 5c2:	bfa1                	j	51a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000be583          	lwu	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e61ff0ef          	jal	432 <printint>
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b781                	j	51a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b8493          	addi	s1,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e49ff0ef          	jal	432 <printint>
        i += 1;
 5ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	8ba6                	mv	s7,s1
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b71d                	j	51a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8493          	addi	s1,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000bb583          	ld	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	e2fff0ef          	jal	432 <printint>
        i += 2;
 608:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	8ba6                	mv	s7,s1
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	b731                	j	51a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 610:	008b8493          	addi	s1,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000be583          	lwu	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e15ff0ef          	jal	432 <printint>
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
 626:	bdd5                	j	51a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8493          	addi	s1,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	dfdff0ef          	jal	432 <printint>
        i += 1;
 63a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
 640:	bde9                	j	51a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	008b8493          	addi	s1,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000bb583          	ld	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	de3ff0ef          	jal	432 <printint>
        i += 2;
 654:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
        i += 2;
 65a:	b5c1                	j	51a <vprintf+0x44>
 65c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 65e:	008b8793          	addi	a5,s7,8
 662:	8cbe                	mv	s9,a5
 664:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	855a                	mv	a0,s6
 66e:	da7ff0ef          	jal	414 <putc>
  putc(fd, 'x');
 672:	07800593          	li	a1,120
 676:	855a                	mv	a0,s6
 678:	d9dff0ef          	jal	414 <putc>
 67c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000b97          	auipc	s7,0x0
 682:	372b8b93          	addi	s7,s7,882 # 9f0 <digits>
 686:	03c9d793          	srli	a5,s3,0x3c
 68a:	97de                	add	a5,a5,s7
 68c:	0007c583          	lbu	a1,0(a5)
 690:	855a                	mv	a0,s6
 692:	d83ff0ef          	jal	414 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 696:	0992                	slli	s3,s3,0x4
 698:	34fd                	addiw	s1,s1,-1
 69a:	f4f5                	bnez	s1,686 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 69c:	8be6                	mv	s7,s9
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	6ca2                	ld	s9,8(sp)
 6a2:	bda5                	j	51a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6a4:	008b8493          	addi	s1,s7,8
 6a8:	000bc583          	lbu	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	d67ff0ef          	jal	414 <putc>
 6b2:	8ba6                	mv	s7,s1
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b595                	j	51a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6b8:	008b8993          	addi	s3,s7,8
 6bc:	000bb483          	ld	s1,0(s7)
 6c0:	cc91                	beqz	s1,6dc <vprintf+0x206>
        for(; *s; s++)
 6c2:	0004c583          	lbu	a1,0(s1)
 6c6:	c985                	beqz	a1,6f6 <vprintf+0x220>
          putc(fd, *s);
 6c8:	855a                	mv	a0,s6
 6ca:	d4bff0ef          	jal	414 <putc>
        for(; *s; s++)
 6ce:	0485                	addi	s1,s1,1
 6d0:	0004c583          	lbu	a1,0(s1)
 6d4:	f9f5                	bnez	a1,6c8 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6d6:	8bce                	mv	s7,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b581                	j	51a <vprintf+0x44>
          s = "(null)";
 6dc:	00000497          	auipc	s1,0x0
 6e0:	30c48493          	addi	s1,s1,780 # 9e8 <malloc+0x170>
        for(; *s; s++)
 6e4:	02800593          	li	a1,40
 6e8:	b7c5                	j	6c8 <vprintf+0x1f2>
        putc(fd, '%');
 6ea:	85be                	mv	a1,a5
 6ec:	855a                	mv	a0,s6
 6ee:	d27ff0ef          	jal	414 <putc>
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b51d                	j	51a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6f6:	8bce                	mv	s7,s3
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b505                	j	51a <vprintf+0x44>
 6fc:	6906                	ld	s2,64(sp)
 6fe:	79e2                	ld	s3,56(sp)
 700:	7a42                	ld	s4,48(sp)
 702:	7aa2                	ld	s5,40(sp)
 704:	7b02                	ld	s6,32(sp)
 706:	6be2                	ld	s7,24(sp)
 708:	6c42                	ld	s8,16(sp)
    }
  }
}
 70a:	60e6                	ld	ra,88(sp)
 70c:	6446                	ld	s0,80(sp)
 70e:	64a6                	ld	s1,72(sp)
 710:	6125                	addi	sp,sp,96
 712:	8082                	ret
      if(c0 == 'd'){
 714:	06400713          	li	a4,100
 718:	e4e78fe3          	beq	a5,a4,576 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 71c:	f9478693          	addi	a3,a5,-108
 720:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 724:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 726:	4701                	li	a4,0
      } else if(c0 == 'u'){
 728:	07500513          	li	a0,117
 72c:	e8a78ce3          	beq	a5,a0,5c4 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 730:	f8b60513          	addi	a0,a2,-117
 734:	e119                	bnez	a0,73a <vprintf+0x264>
 736:	ea0693e3          	bnez	a3,5dc <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 73a:	f8b58513          	addi	a0,a1,-117
 73e:	e119                	bnez	a0,744 <vprintf+0x26e>
 740:	ea071be3          	bnez	a4,5f6 <vprintf+0x120>
      } else if(c0 == 'x'){
 744:	07800513          	li	a0,120
 748:	eca784e3          	beq	a5,a0,610 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 74c:	f8860613          	addi	a2,a2,-120
 750:	e219                	bnez	a2,756 <vprintf+0x280>
 752:	ec069be3          	bnez	a3,628 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 756:	f8858593          	addi	a1,a1,-120
 75a:	e199                	bnez	a1,760 <vprintf+0x28a>
 75c:	ee0713e3          	bnez	a4,642 <vprintf+0x16c>
      } else if(c0 == 'p'){
 760:	07000713          	li	a4,112
 764:	eee78ce3          	beq	a5,a4,65c <vprintf+0x186>
      } else if(c0 == 'c'){
 768:	06300713          	li	a4,99
 76c:	f2e78ce3          	beq	a5,a4,6a4 <vprintf+0x1ce>
      } else if(c0 == 's'){
 770:	07300713          	li	a4,115
 774:	f4e782e3          	beq	a5,a4,6b8 <vprintf+0x1e2>
      } else if(c0 == '%'){
 778:	02500713          	li	a4,37
 77c:	f6e787e3          	beq	a5,a4,6ea <vprintf+0x214>
        putc(fd, '%');
 780:	02500593          	li	a1,37
 784:	855a                	mv	a0,s6
 786:	c8fff0ef          	jal	414 <putc>
        putc(fd, c0);
 78a:	85a6                	mv	a1,s1
 78c:	855a                	mv	a0,s6
 78e:	c87ff0ef          	jal	414 <putc>
      state = 0;
 792:	4981                	li	s3,0
 794:	b359                	j	51a <vprintf+0x44>

0000000000000796 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 796:	715d                	addi	sp,sp,-80
 798:	ec06                	sd	ra,24(sp)
 79a:	e822                	sd	s0,16(sp)
 79c:	1000                	addi	s0,sp,32
 79e:	e010                	sd	a2,0(s0)
 7a0:	e414                	sd	a3,8(s0)
 7a2:	e818                	sd	a4,16(s0)
 7a4:	ec1c                	sd	a5,24(s0)
 7a6:	03043023          	sd	a6,32(s0)
 7aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ae:	8622                	mv	a2,s0
 7b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b4:	d23ff0ef          	jal	4d6 <vprintf>
}
 7b8:	60e2                	ld	ra,24(sp)
 7ba:	6442                	ld	s0,16(sp)
 7bc:	6161                	addi	sp,sp,80
 7be:	8082                	ret

00000000000007c0 <printf>:

void
printf(const char *fmt, ...)
{
 7c0:	711d                	addi	sp,sp,-96
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	addi	s0,sp,32
 7c8:	e40c                	sd	a1,8(s0)
 7ca:	e810                	sd	a2,16(s0)
 7cc:	ec14                	sd	a3,24(s0)
 7ce:	f018                	sd	a4,32(s0)
 7d0:	f41c                	sd	a5,40(s0)
 7d2:	03043823          	sd	a6,48(s0)
 7d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7da:	00840613          	addi	a2,s0,8
 7de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e2:	85aa                	mv	a1,a0
 7e4:	4505                	li	a0,1
 7e6:	cf1ff0ef          	jal	4d6 <vprintf>
}
 7ea:	60e2                	ld	ra,24(sp)
 7ec:	6442                	ld	s0,16(sp)
 7ee:	6125                	addi	sp,sp,96
 7f0:	8082                	ret

00000000000007f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f2:	1141                	addi	sp,sp,-16
 7f4:	e406                	sd	ra,8(sp)
 7f6:	e022                	sd	s0,0(sp)
 7f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	00001797          	auipc	a5,0x1
 802:	8127b783          	ld	a5,-2030(a5) # 1010 <freep>
 806:	a039                	j	814 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	6398                	ld	a4,0(a5)
 80a:	00e7e463          	bltu	a5,a4,812 <free+0x20>
 80e:	00e6ea63          	bltu	a3,a4,822 <free+0x30>
{
 812:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 814:	fed7fae3          	bgeu	a5,a3,808 <free+0x16>
 818:	6398                	ld	a4,0(a5)
 81a:	00e6e463          	bltu	a3,a4,822 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81e:	fee7eae3          	bltu	a5,a4,812 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 822:	ff852583          	lw	a1,-8(a0)
 826:	6390                	ld	a2,0(a5)
 828:	02059813          	slli	a6,a1,0x20
 82c:	01c85713          	srli	a4,a6,0x1c
 830:	9736                	add	a4,a4,a3
 832:	02e60563          	beq	a2,a4,85c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 836:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 83a:	4790                	lw	a2,8(a5)
 83c:	02061593          	slli	a1,a2,0x20
 840:	01c5d713          	srli	a4,a1,0x1c
 844:	973e                	add	a4,a4,a5
 846:	02e68263          	beq	a3,a4,86a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 84a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 84c:	00000717          	auipc	a4,0x0
 850:	7cf73223          	sd	a5,1988(a4) # 1010 <freep>
}
 854:	60a2                	ld	ra,8(sp)
 856:	6402                	ld	s0,0(sp)
 858:	0141                	addi	sp,sp,16
 85a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 85c:	4618                	lw	a4,8(a2)
 85e:	9f2d                	addw	a4,a4,a1
 860:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 864:	6398                	ld	a4,0(a5)
 866:	6310                	ld	a2,0(a4)
 868:	b7f9                	j	836 <free+0x44>
    p->s.size += bp->s.size;
 86a:	ff852703          	lw	a4,-8(a0)
 86e:	9f31                	addw	a4,a4,a2
 870:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 872:	ff053683          	ld	a3,-16(a0)
 876:	bfd1                	j	84a <free+0x58>

0000000000000878 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 878:	7139                	addi	sp,sp,-64
 87a:	fc06                	sd	ra,56(sp)
 87c:	f822                	sd	s0,48(sp)
 87e:	f04a                	sd	s2,32(sp)
 880:	ec4e                	sd	s3,24(sp)
 882:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 884:	02051993          	slli	s3,a0,0x20
 888:	0209d993          	srli	s3,s3,0x20
 88c:	09bd                	addi	s3,s3,15
 88e:	0049d993          	srli	s3,s3,0x4
 892:	2985                	addiw	s3,s3,1
 894:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 896:	00000517          	auipc	a0,0x0
 89a:	77a53503          	ld	a0,1914(a0) # 1010 <freep>
 89e:	c905                	beqz	a0,8ce <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a2:	4798                	lw	a4,8(a5)
 8a4:	09377663          	bgeu	a4,s3,930 <malloc+0xb8>
 8a8:	f426                	sd	s1,40(sp)
 8aa:	e852                	sd	s4,16(sp)
 8ac:	e456                	sd	s5,8(sp)
 8ae:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8b0:	8a4e                	mv	s4,s3
 8b2:	6705                	lui	a4,0x1
 8b4:	00e9f363          	bgeu	s3,a4,8ba <malloc+0x42>
 8b8:	6a05                	lui	s4,0x1
 8ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8be:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c2:	00000497          	auipc	s1,0x0
 8c6:	74e48493          	addi	s1,s1,1870 # 1010 <freep>
  if(p == SBRK_ERROR)
 8ca:	5afd                	li	s5,-1
 8cc:	a83d                	j	90a <malloc+0x92>
 8ce:	f426                	sd	s1,40(sp)
 8d0:	e852                	sd	s4,16(sp)
 8d2:	e456                	sd	s5,8(sp)
 8d4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d6:	00000797          	auipc	a5,0x0
 8da:	74a78793          	addi	a5,a5,1866 # 1020 <base>
 8de:	00000717          	auipc	a4,0x0
 8e2:	72f73923          	sd	a5,1842(a4) # 1010 <freep>
 8e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ec:	b7d1                	j	8b0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ee:	6398                	ld	a4,0(a5)
 8f0:	e118                	sd	a4,0(a0)
 8f2:	a899                	j	948 <malloc+0xd0>
  hp->s.size = nu;
 8f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f8:	0541                	addi	a0,a0,16
 8fa:	ef9ff0ef          	jal	7f2 <free>
  return freep;
 8fe:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 900:	c125                	beqz	a0,960 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 902:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 904:	4798                	lw	a4,8(a5)
 906:	03277163          	bgeu	a4,s2,928 <malloc+0xb0>
    if(p == freep)
 90a:	6098                	ld	a4,0(s1)
 90c:	853e                	mv	a0,a5
 90e:	fef71ae3          	bne	a4,a5,902 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 912:	8552                	mv	a0,s4
 914:	a2dff0ef          	jal	340 <sbrk>
  if(p == SBRK_ERROR)
 918:	fd551ee3          	bne	a0,s5,8f4 <malloc+0x7c>
        return 0;
 91c:	4501                	li	a0,0
 91e:	74a2                	ld	s1,40(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	a03d                	j	954 <malloc+0xdc>
 928:	74a2                	ld	s1,40(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 930:	fae90fe3          	beq	s2,a4,8ee <malloc+0x76>
        p->s.size -= nunits;
 934:	4137073b          	subw	a4,a4,s3
 938:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93a:	02071693          	slli	a3,a4,0x20
 93e:	01c6d713          	srli	a4,a3,0x1c
 942:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 944:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 948:	00000717          	auipc	a4,0x0
 94c:	6ca73423          	sd	a0,1736(a4) # 1010 <freep>
      return (void*)(p + 1);
 950:	01078513          	addi	a0,a5,16
  }
}
 954:	70e2                	ld	ra,56(sp)
 956:	7442                	ld	s0,48(sp)
 958:	7902                	ld	s2,32(sp)
 95a:	69e2                	ld	s3,24(sp)
 95c:	6121                	addi	sp,sp,64
 95e:	8082                	ret
 960:	74a2                	ld	s1,40(sp)
 962:	6a42                	ld	s4,16(sp)
 964:	6aa2                	ld	s5,8(sp)
 966:	6b02                	ld	s6,0(sp)
 968:	b7f5                	j	954 <malloc+0xdc>
