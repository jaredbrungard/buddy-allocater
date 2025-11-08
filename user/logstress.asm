
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
  42:	97250513          	addi	a0,a0,-1678 # 9b0 <malloc+0xf2>
  46:	7c0000ef          	jal	806 <printf>
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
  b0:	91c50513          	addi	a0,a0,-1764 # 9c8 <malloc+0x10a>
  b4:	752000ef          	jal	806 <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	300000ef          	jal	3ba <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	92050513          	addi	a0,a0,-1760 # 9e0 <malloc+0x122>
  c8:	73e000ef          	jal	806 <printf>
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

000000000000045a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45a:	1101                	addi	sp,sp,-32
 45c:	ec06                	sd	ra,24(sp)
 45e:	e822                	sd	s0,16(sp)
 460:	1000                	addi	s0,sp,32
 462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 466:	4605                	li	a2,1
 468:	fef40593          	addi	a1,s0,-17
 46c:	f6fff0ef          	jal	3da <write>
}
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	6105                	addi	sp,sp,32
 476:	8082                	ret

0000000000000478 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 478:	715d                	addi	sp,sp,-80
 47a:	e486                	sd	ra,72(sp)
 47c:	e0a2                	sd	s0,64(sp)
 47e:	f84a                	sd	s2,48(sp)
 480:	f44e                	sd	s3,40(sp)
 482:	0880                	addi	s0,sp,80
 484:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 486:	cac1                	beqz	a3,516 <printint+0x9e>
 488:	0805d763          	bgez	a1,516 <printint+0x9e>
    neg = 1;
    x = -xx;
 48c:	40b005bb          	negw	a1,a1
    neg = 1;
 490:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 492:	fb840993          	addi	s3,s0,-72
  neg = 0;
 496:	86ce                	mv	a3,s3
  i = 0;
 498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49a:	00000817          	auipc	a6,0x0
 49e:	56680813          	addi	a6,a6,1382 # a00 <digits>
 4a2:	88ba                	mv	a7,a4
 4a4:	0017051b          	addiw	a0,a4,1
 4a8:	872a                	mv	a4,a0
 4aa:	02c5f7bb          	remuw	a5,a1,a2
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	97c2                	add	a5,a5,a6
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4bc:	87ae                	mv	a5,a1
 4be:	02c5d5bb          	divuw	a1,a1,a2
 4c2:	0685                	addi	a3,a3,1
 4c4:	fcc7ffe3          	bgeu	a5,a2,4a2 <printint+0x2a>
  if(neg)
 4c8:	00030c63          	beqz	t1,4e0 <printint+0x68>
    buf[i++] = '-';
 4cc:	fd050793          	addi	a5,a0,-48
 4d0:	00878533          	add	a0,a5,s0
 4d4:	02d00793          	li	a5,45
 4d8:	fef50423          	sb	a5,-24(a0)
 4dc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4e0:	02e05563          	blez	a4,50a <printint+0x92>
 4e4:	fc26                	sd	s1,56(sp)
 4e6:	377d                	addiw	a4,a4,-1
 4e8:	00e984b3          	add	s1,s3,a4
 4ec:	19fd                	addi	s3,s3,-1
 4ee:	99ba                	add	s3,s3,a4
 4f0:	1702                	slli	a4,a4,0x20
 4f2:	9301                	srli	a4,a4,0x20
 4f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f8:	0004c583          	lbu	a1,0(s1)
 4fc:	854a                	mv	a0,s2
 4fe:	f5dff0ef          	jal	45a <putc>
  while(--i >= 0)
 502:	14fd                	addi	s1,s1,-1
 504:	ff349ae3          	bne	s1,s3,4f8 <printint+0x80>
 508:	74e2                	ld	s1,56(sp)
}
 50a:	60a6                	ld	ra,72(sp)
 50c:	6406                	ld	s0,64(sp)
 50e:	7942                	ld	s2,48(sp)
 510:	79a2                	ld	s3,40(sp)
 512:	6161                	addi	sp,sp,80
 514:	8082                	ret
    x = xx;
 516:	2581                	sext.w	a1,a1
  neg = 0;
 518:	4301                	li	t1,0
 51a:	bfa5                	j	492 <printint+0x1a>

000000000000051c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51c:	711d                	addi	sp,sp,-96
 51e:	ec86                	sd	ra,88(sp)
 520:	e8a2                	sd	s0,80(sp)
 522:	e4a6                	sd	s1,72(sp)
 524:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 526:	0005c483          	lbu	s1,0(a1)
 52a:	22048363          	beqz	s1,750 <vprintf+0x234>
 52e:	e0ca                	sd	s2,64(sp)
 530:	fc4e                	sd	s3,56(sp)
 532:	f852                	sd	s4,48(sp)
 534:	f456                	sd	s5,40(sp)
 536:	f05a                	sd	s6,32(sp)
 538:	ec5e                	sd	s7,24(sp)
 53a:	e862                	sd	s8,16(sp)
 53c:	8b2a                	mv	s6,a0
 53e:	8a2e                	mv	s4,a1
 540:	8bb2                	mv	s7,a2
  state = 0;
 542:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 544:	4901                	li	s2,0
 546:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 548:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 54c:	06400c13          	li	s8,100
 550:	a00d                	j	572 <vprintf+0x56>
        putc(fd, c0);
 552:	85a6                	mv	a1,s1
 554:	855a                	mv	a0,s6
 556:	f05ff0ef          	jal	45a <putc>
 55a:	a019                	j	560 <vprintf+0x44>
    } else if(state == '%'){
 55c:	03598363          	beq	s3,s5,582 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 560:	0019079b          	addiw	a5,s2,1
 564:	893e                	mv	s2,a5
 566:	873e                	mv	a4,a5
 568:	97d2                	add	a5,a5,s4
 56a:	0007c483          	lbu	s1,0(a5)
 56e:	1c048a63          	beqz	s1,742 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 572:	0004879b          	sext.w	a5,s1
    if(state == 0){
 576:	fe0993e3          	bnez	s3,55c <vprintf+0x40>
      if(c0 == '%'){
 57a:	fd579ce3          	bne	a5,s5,552 <vprintf+0x36>
        state = '%';
 57e:	89be                	mv	s3,a5
 580:	b7c5                	j	560 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 582:	00ea06b3          	add	a3,s4,a4
 586:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 58a:	1c060863          	beqz	a2,75a <vprintf+0x23e>
      if(c0 == 'd'){
 58e:	03878763          	beq	a5,s8,5bc <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 592:	f9478693          	addi	a3,a5,-108
 596:	0016b693          	seqz	a3,a3
 59a:	f9c60593          	addi	a1,a2,-100
 59e:	e99d                	bnez	a1,5d4 <vprintf+0xb8>
 5a0:	ca95                	beqz	a3,5d4 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000bb583          	ld	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	ec9ff0ef          	jal	478 <printint>
        i += 1;
 5b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b75d                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	eafff0ef          	jal	478 <printint>
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b779                	j	560 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5d4:	9752                	add	a4,a4,s4
 5d6:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5da:	f9460713          	addi	a4,a2,-108
 5de:	00173713          	seqz	a4,a4
 5e2:	8f75                	and	a4,a4,a3
 5e4:	f9c58513          	addi	a0,a1,-100
 5e8:	18051363          	bnez	a0,76e <vprintf+0x252>
 5ec:	18070163          	beqz	a4,76e <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e7bff0ef          	jal	478 <printint>
        i += 2;
 602:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	bfa1                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000be583          	lwu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e61ff0ef          	jal	478 <printint>
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	b781                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e49ff0ef          	jal	478 <printint>
        i += 1;
 634:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	b71d                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e2fff0ef          	jal	478 <printint>
        i += 2;
 64e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	b731                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000be583          	lwu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	e15ff0ef          	jal	478 <printint>
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bdd5                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dfdff0ef          	jal	478 <printint>
        i += 1;
 680:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
 686:	bde9                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	de3ff0ef          	jal	478 <printint>
        i += 2;
 69a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	b5c1                	j	560 <vprintf+0x44>
 6a2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a4:	008b8793          	addi	a5,s7,8
 6a8:	8cbe                	mv	s9,a5
 6aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ae:	03000593          	li	a1,48
 6b2:	855a                	mv	a0,s6
 6b4:	da7ff0ef          	jal	45a <putc>
  putc(fd, 'x');
 6b8:	07800593          	li	a1,120
 6bc:	855a                	mv	a0,s6
 6be:	d9dff0ef          	jal	45a <putc>
 6c2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c4:	00000b97          	auipc	s7,0x0
 6c8:	33cb8b93          	addi	s7,s7,828 # a00 <digits>
 6cc:	03c9d793          	srli	a5,s3,0x3c
 6d0:	97de                	add	a5,a5,s7
 6d2:	0007c583          	lbu	a1,0(a5)
 6d6:	855a                	mv	a0,s6
 6d8:	d83ff0ef          	jal	45a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6dc:	0992                	slli	s3,s3,0x4
 6de:	34fd                	addiw	s1,s1,-1
 6e0:	f4f5                	bnez	s1,6cc <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6e2:	8be6                	mv	s7,s9
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	6ca2                	ld	s9,8(sp)
 6e8:	bda5                	j	560 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	000bc583          	lbu	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	d67ff0ef          	jal	45a <putc>
 6f8:	8ba6                	mv	s7,s1
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b595                	j	560 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6fe:	008b8993          	addi	s3,s7,8
 702:	000bb483          	ld	s1,0(s7)
 706:	cc91                	beqz	s1,722 <vprintf+0x206>
        for(; *s; s++)
 708:	0004c583          	lbu	a1,0(s1)
 70c:	c985                	beqz	a1,73c <vprintf+0x220>
          putc(fd, *s);
 70e:	855a                	mv	a0,s6
 710:	d4bff0ef          	jal	45a <putc>
        for(; *s; s++)
 714:	0485                	addi	s1,s1,1
 716:	0004c583          	lbu	a1,0(s1)
 71a:	f9f5                	bnez	a1,70e <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 71c:	8bce                	mv	s7,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	b581                	j	560 <vprintf+0x44>
          s = "(null)";
 722:	00000497          	auipc	s1,0x0
 726:	2d648493          	addi	s1,s1,726 # 9f8 <malloc+0x13a>
        for(; *s; s++)
 72a:	02800593          	li	a1,40
 72e:	b7c5                	j	70e <vprintf+0x1f2>
        putc(fd, '%');
 730:	85be                	mv	a1,a5
 732:	855a                	mv	a0,s6
 734:	d27ff0ef          	jal	45a <putc>
      state = 0;
 738:	4981                	li	s3,0
 73a:	b51d                	j	560 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b505                	j	560 <vprintf+0x44>
 742:	6906                	ld	s2,64(sp)
 744:	79e2                	ld	s3,56(sp)
 746:	7a42                	ld	s4,48(sp)
 748:	7aa2                	ld	s5,40(sp)
 74a:	7b02                	ld	s6,32(sp)
 74c:	6be2                	ld	s7,24(sp)
 74e:	6c42                	ld	s8,16(sp)
    }
  }
}
 750:	60e6                	ld	ra,88(sp)
 752:	6446                	ld	s0,80(sp)
 754:	64a6                	ld	s1,72(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret
      if(c0 == 'd'){
 75a:	06400713          	li	a4,100
 75e:	e4e78fe3          	beq	a5,a4,5bc <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 762:	f9478693          	addi	a3,a5,-108
 766:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 76a:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 76c:	4701                	li	a4,0
      } else if(c0 == 'u'){
 76e:	07500513          	li	a0,117
 772:	e8a78ce3          	beq	a5,a0,60a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 776:	f8b60513          	addi	a0,a2,-117
 77a:	e119                	bnez	a0,780 <vprintf+0x264>
 77c:	ea0693e3          	bnez	a3,622 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 780:	f8b58513          	addi	a0,a1,-117
 784:	e119                	bnez	a0,78a <vprintf+0x26e>
 786:	ea071be3          	bnez	a4,63c <vprintf+0x120>
      } else if(c0 == 'x'){
 78a:	07800513          	li	a0,120
 78e:	eca784e3          	beq	a5,a0,656 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 792:	f8860613          	addi	a2,a2,-120
 796:	e219                	bnez	a2,79c <vprintf+0x280>
 798:	ec069be3          	bnez	a3,66e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79c:	f8858593          	addi	a1,a1,-120
 7a0:	e199                	bnez	a1,7a6 <vprintf+0x28a>
 7a2:	ee0713e3          	bnez	a4,688 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7a6:	07000713          	li	a4,112
 7aa:	eee78ce3          	beq	a5,a4,6a2 <vprintf+0x186>
      } else if(c0 == 'c'){
 7ae:	06300713          	li	a4,99
 7b2:	f2e78ce3          	beq	a5,a4,6ea <vprintf+0x1ce>
      } else if(c0 == 's'){
 7b6:	07300713          	li	a4,115
 7ba:	f4e782e3          	beq	a5,a4,6fe <vprintf+0x1e2>
      } else if(c0 == '%'){
 7be:	02500713          	li	a4,37
 7c2:	f6e787e3          	beq	a5,a4,730 <vprintf+0x214>
        putc(fd, '%');
 7c6:	02500593          	li	a1,37
 7ca:	855a                	mv	a0,s6
 7cc:	c8fff0ef          	jal	45a <putc>
        putc(fd, c0);
 7d0:	85a6                	mv	a1,s1
 7d2:	855a                	mv	a0,s6
 7d4:	c87ff0ef          	jal	45a <putc>
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b359                	j	560 <vprintf+0x44>

00000000000007dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e010                	sd	a2,0(s0)
 7e6:	e414                	sd	a3,8(s0)
 7e8:	e818                	sd	a4,16(s0)
 7ea:	ec1c                	sd	a5,24(s0)
 7ec:	03043023          	sd	a6,32(s0)
 7f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	8622                	mv	a2,s0
 7f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fa:	d23ff0ef          	jal	51c <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6161                	addi	sp,sp,80
 804:	8082                	ret

0000000000000806 <printf>:

void
printf(const char *fmt, ...)
{
 806:	711d                	addi	sp,sp,-96
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e40c                	sd	a1,8(s0)
 810:	e810                	sd	a2,16(s0)
 812:	ec14                	sd	a3,24(s0)
 814:	f018                	sd	a4,32(s0)
 816:	f41c                	sd	a5,40(s0)
 818:	03043823          	sd	a6,48(s0)
 81c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	00840613          	addi	a2,s0,8
 824:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 828:	85aa                	mv	a1,a0
 82a:	4505                	li	a0,1
 82c:	cf1ff0ef          	jal	51c <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6125                	addi	sp,sp,96
 836:	8082                	ret

0000000000000838 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 838:	1141                	addi	sp,sp,-16
 83a:	e406                	sd	ra,8(sp)
 83c:	e022                	sd	s0,0(sp)
 83e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 840:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	00000797          	auipc	a5,0x0
 848:	7bc7b783          	ld	a5,1980(a5) # 1000 <freep>
 84c:	a039                	j	85a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6398                	ld	a4,0(a5)
 850:	00e7e463          	bltu	a5,a4,858 <free+0x20>
 854:	00e6ea63          	bltu	a3,a4,868 <free+0x30>
{
 858:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fed7fae3          	bgeu	a5,a3,84e <free+0x16>
 85e:	6398                	ld	a4,0(a5)
 860:	00e6e463          	bltu	a3,a4,868 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	fee7eae3          	bltu	a5,a4,858 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059813          	slli	a6,a1,0x20
 872:	01c85713          	srli	a4,a6,0x1c
 876:	9736                	add	a4,a4,a3
 878:	02e60563          	beq	a2,a4,8a2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 880:	4790                	lw	a2,8(a5)
 882:	02061593          	slli	a1,a2,0x20
 886:	01c5d713          	srli	a4,a1,0x1c
 88a:	973e                	add	a4,a4,a5
 88c:	02e68263          	beq	a3,a4,8b0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 890:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	76f73723          	sd	a5,1902(a4) # 1000 <freep>
}
 89a:	60a2                	ld	ra,8(sp)
 89c:	6402                	ld	s0,0(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8a2:	4618                	lw	a4,8(a2)
 8a4:	9f2d                	addw	a4,a4,a1
 8a6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	6310                	ld	a2,0(a4)
 8ae:	b7f9                	j	87c <free+0x44>
    p->s.size += bp->s.size;
 8b0:	ff852703          	lw	a4,-8(a0)
 8b4:	9f31                	addw	a4,a4,a2
 8b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b8:	ff053683          	ld	a3,-16(a0)
 8bc:	bfd1                	j	890 <free+0x58>

00000000000008be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8be:	7139                	addi	sp,sp,-64
 8c0:	fc06                	sd	ra,56(sp)
 8c2:	f822                	sd	s0,48(sp)
 8c4:	f04a                	sd	s2,32(sp)
 8c6:	ec4e                	sd	s3,24(sp)
 8c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ca:	02051993          	slli	s3,a0,0x20
 8ce:	0209d993          	srli	s3,s3,0x20
 8d2:	09bd                	addi	s3,s3,15
 8d4:	0049d993          	srli	s3,s3,0x4
 8d8:	2985                	addiw	s3,s3,1
 8da:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8dc:	00000517          	auipc	a0,0x0
 8e0:	72453503          	ld	a0,1828(a0) # 1000 <freep>
 8e4:	c905                	beqz	a0,914 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e8:	4798                	lw	a4,8(a5)
 8ea:	09377663          	bgeu	a4,s3,976 <malloc+0xb8>
 8ee:	f426                	sd	s1,40(sp)
 8f0:	e852                	sd	s4,16(sp)
 8f2:	e456                	sd	s5,8(sp)
 8f4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f6:	8a4e                	mv	s4,s3
 8f8:	6705                	lui	a4,0x1
 8fa:	00e9f363          	bgeu	s3,a4,900 <malloc+0x42>
 8fe:	6a05                	lui	s4,0x1
 900:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 904:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 908:	00000497          	auipc	s1,0x0
 90c:	6f848493          	addi	s1,s1,1784 # 1000 <freep>
  if(p == SBRK_ERROR)
 910:	5afd                	li	s5,-1
 912:	a83d                	j	950 <malloc+0x92>
 914:	f426                	sd	s1,40(sp)
 916:	e852                	sd	s4,16(sp)
 918:	e456                	sd	s5,8(sp)
 91a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 91c:	00001797          	auipc	a5,0x1
 920:	8ec78793          	addi	a5,a5,-1812 # 1208 <base>
 924:	00000717          	auipc	a4,0x0
 928:	6cf73e23          	sd	a5,1756(a4) # 1000 <freep>
 92c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 932:	b7d1                	j	8f6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 934:	6398                	ld	a4,0(a5)
 936:	e118                	sd	a4,0(a0)
 938:	a899                	j	98e <malloc+0xd0>
  hp->s.size = nu;
 93a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93e:	0541                	addi	a0,a0,16
 940:	ef9ff0ef          	jal	838 <free>
  return freep;
 944:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 946:	c125                	beqz	a0,9a6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	03277163          	bgeu	a4,s2,96e <malloc+0xb0>
    if(p == freep)
 950:	6098                	ld	a4,0(s1)
 952:	853e                	mv	a0,a5
 954:	fef71ae3          	bne	a4,a5,948 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 958:	8552                	mv	a0,s4
 95a:	a2dff0ef          	jal	386 <sbrk>
  if(p == SBRK_ERROR)
 95e:	fd551ee3          	bne	a0,s5,93a <malloc+0x7c>
        return 0;
 962:	4501                	li	a0,0
 964:	74a2                	ld	s1,40(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
 96c:	a03d                	j	99a <malloc+0xdc>
 96e:	74a2                	ld	s1,40(sp)
 970:	6a42                	ld	s4,16(sp)
 972:	6aa2                	ld	s5,8(sp)
 974:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 976:	fae90fe3          	beq	s2,a4,934 <malloc+0x76>
        p->s.size -= nunits;
 97a:	4137073b          	subw	a4,a4,s3
 97e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 980:	02071693          	slli	a3,a4,0x20
 984:	01c6d713          	srli	a4,a3,0x1c
 988:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98e:	00000717          	auipc	a4,0x0
 992:	66a73923          	sd	a0,1650(a4) # 1000 <freep>
      return (void*)(p + 1);
 996:	01078513          	addi	a0,a5,16
  }
}
 99a:	70e2                	ld	ra,56(sp)
 99c:	7442                	ld	s0,48(sp)
 99e:	7902                	ld	s2,32(sp)
 9a0:	69e2                	ld	s3,24(sp)
 9a2:	6121                	addi	sp,sp,64
 9a4:	8082                	ret
 9a6:	74a2                	ld	s1,40(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	b7f5                	j	99a <malloc+0xdc>
