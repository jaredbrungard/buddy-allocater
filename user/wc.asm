
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	20000d93          	li	s11,512
  32:	00001d17          	auipc	s10,0x1
  36:	fded0d13          	addi	s10,s10,-34 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	9e4a0a13          	addi	s4,s4,-1564 # a20 <malloc+0x100>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a035                	j	70 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1c8000ef          	jal	210 <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if(buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if(!inword){
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  70:	866e                	mv	a2,s11
  72:	85ea                	mv	a1,s10
  74:	f8843503          	ld	a0,-120(s0)
  78:	3b4000ef          	jal	42c <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	9a250513          	addi	a0,a0,-1630 # a40 <malloc+0x120>
  a6:	7c2000ef          	jal	868 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	96850513          	addi	a0,a0,-1688 # a30 <malloc+0x110>
  d0:	798000ef          	jal	868 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	33e000ef          	jal	414 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	34c000ef          	jal	454 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	320000ef          	jal	43c <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2ec000ef          	jal	414 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8f658593          	addi	a1,a1,-1802 # a28 <malloc+0x108>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2d2000ef          	jal	414 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	90650513          	addi	a0,a0,-1786 # a50 <malloc+0x130>
 152:	716000ef          	jal	868 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2bc000ef          	jal	414 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	2aa000ef          	jal	414 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 176:	87aa                	mv	a5,a0
 178:	0585                	addi	a1,a1,1
 17a:	0785                	addi	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fb75                	bnez	a4,178 <strcpy+0xa>
    ;
  return os;
}
 186:	60a2                	ld	ra,8(sp)
 188:	6402                	ld	s0,0(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret

000000000000018e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb91                	beqz	a5,1ae <strcmp+0x20>
 19c:	0005c703          	lbu	a4,0(a1)
 1a0:	00f71763          	bne	a4,a5,1ae <strcmp+0x20>
    p++, q++;
 1a4:	0505                	addi	a0,a0,1
 1a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a8:	00054783          	lbu	a5,0(a0)
 1ac:	fbe5                	bnez	a5,19c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ae:	0005c503          	lbu	a0,0(a1)
}
 1b2:	40a7853b          	subw	a0,a5,a0
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cf91                	beqz	a5,1e6 <strlen+0x28>
 1cc:	00150793          	addi	a5,a0,1
 1d0:	86be                	mv	a3,a5
 1d2:	0785                	addi	a5,a5,1
 1d4:	fff7c703          	lbu	a4,-1(a5)
 1d8:	ff65                	bnez	a4,1d0 <strlen+0x12>
 1da:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  for(n = 0; s[n]; n++)
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <strlen+0x20>

00000000000001ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f2:	ca19                	beqz	a2,208 <memset+0x1e>
 1f4:	87aa                	mv	a5,a0
 1f6:	1602                	slli	a2,a2,0x20
 1f8:	9201                	srli	a2,a2,0x20
 1fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 202:	0785                	addi	a5,a5,1
 204:	fee79de3          	bne	a5,a4,1fe <memset+0x14>
  }
  return dst;
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
  for(; *s; s++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cf81                	beqz	a5,234 <strchr+0x24>
    if(*s == c)
 21e:	00f58763          	beq	a1,a5,22c <strchr+0x1c>
  for(; *s; s++)
 222:	0505                	addi	a0,a0,1
 224:	00054783          	lbu	a5,0(a0)
 228:	fbfd                	bnez	a5,21e <strchr+0xe>
      return (char*)s;
  return 0;
 22a:	4501                	li	a0,0
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  return 0;
 234:	4501                	li	a0,0
 236:	bfdd                	j	22c <strchr+0x1c>

0000000000000238 <gets>:

char*
gets(char *buf, int max)
{
 238:	711d                	addi	sp,sp,-96
 23a:	ec86                	sd	ra,88(sp)
 23c:	e8a2                	sd	s0,80(sp)
 23e:	e4a6                	sd	s1,72(sp)
 240:	e0ca                	sd	s2,64(sp)
 242:	fc4e                	sd	s3,56(sp)
 244:	f852                	sd	s4,48(sp)
 246:	f456                	sd	s5,40(sp)
 248:	f05a                	sd	s6,32(sp)
 24a:	ec5e                	sd	s7,24(sp)
 24c:	e862                	sd	s8,16(sp)
 24e:	1080                	addi	s0,sp,96
 250:	8baa                	mv	s7,a0
 252:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 254:	892a                	mv	s2,a0
 256:	4481                	li	s1,0
    cc = read(0, &c, 1);
 258:	faf40b13          	addi	s6,s0,-81
 25c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 25e:	8c26                	mv	s8,s1
 260:	0014899b          	addiw	s3,s1,1
 264:	84ce                	mv	s1,s3
 266:	0349d463          	bge	s3,s4,28e <gets+0x56>
    cc = read(0, &c, 1);
 26a:	8656                	mv	a2,s5
 26c:	85da                	mv	a1,s6
 26e:	4501                	li	a0,0
 270:	1bc000ef          	jal	42c <read>
    if(cc < 1)
 274:	00a05d63          	blez	a0,28e <gets+0x56>
      break;
    buf[i++] = c;
 278:	faf44783          	lbu	a5,-81(s0)
 27c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 280:	0905                	addi	s2,s2,1
 282:	ff678713          	addi	a4,a5,-10
 286:	c319                	beqz	a4,28c <gets+0x54>
 288:	17cd                	addi	a5,a5,-13
 28a:	fbf1                	bnez	a5,25e <gets+0x26>
    buf[i++] = c;
 28c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 28e:	9c5e                	add	s8,s8,s7
 290:	000c0023          	sb	zero,0(s8)
  return buf;
}
 294:	855e                	mv	a0,s7
 296:	60e6                	ld	ra,88(sp)
 298:	6446                	ld	s0,80(sp)
 29a:	64a6                	ld	s1,72(sp)
 29c:	6906                	ld	s2,64(sp)
 29e:	79e2                	ld	s3,56(sp)
 2a0:	7a42                	ld	s4,48(sp)
 2a2:	7aa2                	ld	s5,40(sp)
 2a4:	7b02                	ld	s6,32(sp)
 2a6:	6be2                	ld	s7,24(sp)
 2a8:	6c42                	ld	s8,16(sp)
 2aa:	6125                	addi	sp,sp,96
 2ac:	8082                	ret

00000000000002ae <stat>:

int
stat(const char *n, struct stat *st)
{
 2ae:	1101                	addi	sp,sp,-32
 2b0:	ec06                	sd	ra,24(sp)
 2b2:	e822                	sd	s0,16(sp)
 2b4:	e04a                	sd	s2,0(sp)
 2b6:	1000                	addi	s0,sp,32
 2b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ba:	4581                	li	a1,0
 2bc:	198000ef          	jal	454 <open>
  if(fd < 0)
 2c0:	02054263          	bltz	a0,2e4 <stat+0x36>
 2c4:	e426                	sd	s1,8(sp)
 2c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c8:	85ca                	mv	a1,s2
 2ca:	1a2000ef          	jal	46c <fstat>
 2ce:	892a                	mv	s2,a0
  close(fd);
 2d0:	8526                	mv	a0,s1
 2d2:	16a000ef          	jal	43c <close>
  return r;
 2d6:	64a2                	ld	s1,8(sp)
}
 2d8:	854a                	mv	a0,s2
 2da:	60e2                	ld	ra,24(sp)
 2dc:	6442                	ld	s0,16(sp)
 2de:	6902                	ld	s2,0(sp)
 2e0:	6105                	addi	sp,sp,32
 2e2:	8082                	ret
    return -1;
 2e4:	57fd                	li	a5,-1
 2e6:	893e                	mv	s2,a5
 2e8:	bfc5                	j	2d8 <stat+0x2a>

00000000000002ea <atoi>:

int
atoi(const char *s)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f2:	00054683          	lbu	a3,0(a0)
 2f6:	fd06879b          	addiw	a5,a3,-48
 2fa:	0ff7f793          	zext.b	a5,a5
 2fe:	4625                	li	a2,9
 300:	02f66963          	bltu	a2,a5,332 <atoi+0x48>
 304:	872a                	mv	a4,a0
  n = 0;
 306:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 308:	0705                	addi	a4,a4,1
 30a:	0025179b          	slliw	a5,a0,0x2
 30e:	9fa9                	addw	a5,a5,a0
 310:	0017979b          	slliw	a5,a5,0x1
 314:	9fb5                	addw	a5,a5,a3
 316:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 31a:	00074683          	lbu	a3,0(a4)
 31e:	fd06879b          	addiw	a5,a3,-48
 322:	0ff7f793          	zext.b	a5,a5
 326:	fef671e3          	bgeu	a2,a5,308 <atoi+0x1e>
  return n;
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  n = 0;
 332:	4501                	li	a0,0
 334:	bfdd                	j	32a <atoi+0x40>

0000000000000336 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33e:	02b57563          	bgeu	a0,a1,368 <memmove+0x32>
    while(n-- > 0)
 342:	00c05f63          	blez	a2,360 <memmove+0x2a>
 346:	1602                	slli	a2,a2,0x20
 348:	9201                	srli	a2,a2,0x20
 34a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34e:	872a                	mv	a4,a0
      *dst++ = *src++;
 350:	0585                	addi	a1,a1,1
 352:	0705                	addi	a4,a4,1
 354:	fff5c683          	lbu	a3,-1(a1)
 358:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35c:	fee79ae3          	bne	a5,a4,350 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
    while(n-- > 0)
 368:	fec05ce3          	blez	a2,360 <memmove+0x2a>
    dst += n;
 36c:	00c50733          	add	a4,a0,a2
    src += n;
 370:	95b2                	add	a1,a1,a2
 372:	fff6079b          	addiw	a5,a2,-1
 376:	1782                	slli	a5,a5,0x20
 378:	9381                	srli	a5,a5,0x20
 37a:	fff7c793          	not	a5,a5
 37e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 380:	15fd                	addi	a1,a1,-1
 382:	177d                	addi	a4,a4,-1
 384:	0005c683          	lbu	a3,0(a1)
 388:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 38c:	fef71ae3          	bne	a4,a5,380 <memmove+0x4a>
 390:	bfc1                	j	360 <memmove+0x2a>

0000000000000392 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 39a:	c61d                	beqz	a2,3c8 <memcmp+0x36>
 39c:	1602                	slli	a2,a2,0x20
 39e:	9201                	srli	a2,a2,0x20
 3a0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3a4:	00054783          	lbu	a5,0(a0)
 3a8:	0005c703          	lbu	a4,0(a1)
 3ac:	00e79863          	bne	a5,a4,3bc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3b0:	0505                	addi	a0,a0,1
    p2++;
 3b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b4:	fed518e3          	bne	a0,a3,3a4 <memcmp+0x12>
  }
  return 0;
 3b8:	4501                	li	a0,0
 3ba:	a019                	j	3c0 <memcmp+0x2e>
      return *p1 - *p2;
 3bc:	40e7853b          	subw	a0,a5,a4
}
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	bfdd                	j	3c0 <memcmp+0x2e>

00000000000003cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e406                	sd	ra,8(sp)
 3d0:	e022                	sd	s0,0(sp)
 3d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d4:	f63ff0ef          	jal	336 <memmove>
}
 3d8:	60a2                	ld	ra,8(sp)
 3da:	6402                	ld	s0,0(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret

00000000000003e0 <sbrk>:

char *
sbrk(int n) {
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e406                	sd	ra,8(sp)
 3e4:	e022                	sd	s0,0(sp)
 3e6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3e8:	4585                	li	a1,1
 3ea:	0b2000ef          	jal	49c <sys_sbrk>
}
 3ee:	60a2                	ld	ra,8(sp)
 3f0:	6402                	ld	s0,0(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret

00000000000003f6 <sbrklazy>:

char *
sbrklazy(int n) {
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3fe:	4589                	li	a1,2
 400:	09c000ef          	jal	49c <sys_sbrk>
}
 404:	60a2                	ld	ra,8(sp)
 406:	6402                	ld	s0,0(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret

000000000000040c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40c:	4885                	li	a7,1
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <exit>:
.global exit
exit:
 li a7, SYS_exit
 414:	4889                	li	a7,2
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <wait>:
.global wait
wait:
 li a7, SYS_wait
 41c:	488d                	li	a7,3
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 424:	4891                	li	a7,4
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <read>:
.global read
read:
 li a7, SYS_read
 42c:	4895                	li	a7,5
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <write>:
.global write
write:
 li a7, SYS_write
 434:	48c1                	li	a7,16
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <close>:
.global close
close:
 li a7, SYS_close
 43c:	48d5                	li	a7,21
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <kill>:
.global kill
kill:
 li a7, SYS_kill
 444:	4899                	li	a7,6
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <exec>:
.global exec
exec:
 li a7, SYS_exec
 44c:	489d                	li	a7,7
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <open>:
.global open
open:
 li a7, SYS_open
 454:	48bd                	li	a7,15
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45c:	48c5                	li	a7,17
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 464:	48c9                	li	a7,18
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46c:	48a1                	li	a7,8
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <link>:
.global link
link:
 li a7, SYS_link
 474:	48cd                	li	a7,19
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47c:	48d1                	li	a7,20
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 484:	48a5                	li	a7,9
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <dup>:
.global dup
dup:
 li a7, SYS_dup
 48c:	48a9                	li	a7,10
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 494:	48ad                	li	a7,11
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 49c:	48b1                	li	a7,12
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4a4:	48b5                	li	a7,13
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ac:	48b9                	li	a7,14
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 4b4:	48d9                	li	a7,22
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4bc:	1101                	addi	sp,sp,-32
 4be:	ec06                	sd	ra,24(sp)
 4c0:	e822                	sd	s0,16(sp)
 4c2:	1000                	addi	s0,sp,32
 4c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c8:	4605                	li	a2,1
 4ca:	fef40593          	addi	a1,s0,-17
 4ce:	f67ff0ef          	jal	434 <write>
}
 4d2:	60e2                	ld	ra,24(sp)
 4d4:	6442                	ld	s0,16(sp)
 4d6:	6105                	addi	sp,sp,32
 4d8:	8082                	ret

00000000000004da <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4da:	715d                	addi	sp,sp,-80
 4dc:	e486                	sd	ra,72(sp)
 4de:	e0a2                	sd	s0,64(sp)
 4e0:	f84a                	sd	s2,48(sp)
 4e2:	f44e                	sd	s3,40(sp)
 4e4:	0880                	addi	s0,sp,80
 4e6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e8:	cac1                	beqz	a3,578 <printint+0x9e>
 4ea:	0805d763          	bgez	a1,578 <printint+0x9e>
    neg = 1;
    x = -xx;
 4ee:	40b005bb          	negw	a1,a1
    neg = 1;
 4f2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4f4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4f8:	86ce                	mv	a3,s3
  i = 0;
 4fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4fc:	00000817          	auipc	a6,0x0
 500:	57480813          	addi	a6,a6,1396 # a70 <digits>
 504:	88ba                	mv	a7,a4
 506:	0017051b          	addiw	a0,a4,1
 50a:	872a                	mv	a4,a0
 50c:	02c5f7bb          	remuw	a5,a1,a2
 510:	1782                	slli	a5,a5,0x20
 512:	9381                	srli	a5,a5,0x20
 514:	97c2                	add	a5,a5,a6
 516:	0007c783          	lbu	a5,0(a5)
 51a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 51e:	87ae                	mv	a5,a1
 520:	02c5d5bb          	divuw	a1,a1,a2
 524:	0685                	addi	a3,a3,1
 526:	fcc7ffe3          	bgeu	a5,a2,504 <printint+0x2a>
  if(neg)
 52a:	00030c63          	beqz	t1,542 <printint+0x68>
    buf[i++] = '-';
 52e:	fd050793          	addi	a5,a0,-48
 532:	00878533          	add	a0,a5,s0
 536:	02d00793          	li	a5,45
 53a:	fef50423          	sb	a5,-24(a0)
 53e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 542:	02e05563          	blez	a4,56c <printint+0x92>
 546:	fc26                	sd	s1,56(sp)
 548:	377d                	addiw	a4,a4,-1
 54a:	00e984b3          	add	s1,s3,a4
 54e:	19fd                	addi	s3,s3,-1
 550:	99ba                	add	s3,s3,a4
 552:	1702                	slli	a4,a4,0x20
 554:	9301                	srli	a4,a4,0x20
 556:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 55a:	0004c583          	lbu	a1,0(s1)
 55e:	854a                	mv	a0,s2
 560:	f5dff0ef          	jal	4bc <putc>
  while(--i >= 0)
 564:	14fd                	addi	s1,s1,-1
 566:	ff349ae3          	bne	s1,s3,55a <printint+0x80>
 56a:	74e2                	ld	s1,56(sp)
}
 56c:	60a6                	ld	ra,72(sp)
 56e:	6406                	ld	s0,64(sp)
 570:	7942                	ld	s2,48(sp)
 572:	79a2                	ld	s3,40(sp)
 574:	6161                	addi	sp,sp,80
 576:	8082                	ret
    x = xx;
 578:	2581                	sext.w	a1,a1
  neg = 0;
 57a:	4301                	li	t1,0
 57c:	bfa5                	j	4f4 <printint+0x1a>

000000000000057e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57e:	711d                	addi	sp,sp,-96
 580:	ec86                	sd	ra,88(sp)
 582:	e8a2                	sd	s0,80(sp)
 584:	e4a6                	sd	s1,72(sp)
 586:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 588:	0005c483          	lbu	s1,0(a1)
 58c:	22048363          	beqz	s1,7b2 <vprintf+0x234>
 590:	e0ca                	sd	s2,64(sp)
 592:	fc4e                	sd	s3,56(sp)
 594:	f852                	sd	s4,48(sp)
 596:	f456                	sd	s5,40(sp)
 598:	f05a                	sd	s6,32(sp)
 59a:	ec5e                	sd	s7,24(sp)
 59c:	e862                	sd	s8,16(sp)
 59e:	8b2a                	mv	s6,a0
 5a0:	8a2e                	mv	s4,a1
 5a2:	8bb2                	mv	s7,a2
  state = 0;
 5a4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5a6:	4901                	li	s2,0
 5a8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5aa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5ae:	06400c13          	li	s8,100
 5b2:	a00d                	j	5d4 <vprintf+0x56>
        putc(fd, c0);
 5b4:	85a6                	mv	a1,s1
 5b6:	855a                	mv	a0,s6
 5b8:	f05ff0ef          	jal	4bc <putc>
 5bc:	a019                	j	5c2 <vprintf+0x44>
    } else if(state == '%'){
 5be:	03598363          	beq	s3,s5,5e4 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5c2:	0019079b          	addiw	a5,s2,1
 5c6:	893e                	mv	s2,a5
 5c8:	873e                	mv	a4,a5
 5ca:	97d2                	add	a5,a5,s4
 5cc:	0007c483          	lbu	s1,0(a5)
 5d0:	1c048a63          	beqz	s1,7a4 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5d4:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5d8:	fe0993e3          	bnez	s3,5be <vprintf+0x40>
      if(c0 == '%'){
 5dc:	fd579ce3          	bne	a5,s5,5b4 <vprintf+0x36>
        state = '%';
 5e0:	89be                	mv	s3,a5
 5e2:	b7c5                	j	5c2 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e4:	00ea06b3          	add	a3,s4,a4
 5e8:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5ec:	1c060863          	beqz	a2,7bc <vprintf+0x23e>
      if(c0 == 'd'){
 5f0:	03878763          	beq	a5,s8,61e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5f4:	f9478693          	addi	a3,a5,-108
 5f8:	0016b693          	seqz	a3,a3
 5fc:	f9c60593          	addi	a1,a2,-100
 600:	e99d                	bnez	a1,636 <vprintf+0xb8>
 602:	ca95                	beqz	a3,636 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	008b8493          	addi	s1,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000bb583          	ld	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	ec9ff0ef          	jal	4da <printint>
        i += 1;
 616:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 618:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 61a:	4981                	li	s3,0
 61c:	b75d                	j	5c2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 61e:	008b8493          	addi	s1,s7,8
 622:	4685                	li	a3,1
 624:	4629                	li	a2,10
 626:	000ba583          	lw	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	eafff0ef          	jal	4da <printint>
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
 634:	b779                	j	5c2 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 636:	9752                	add	a4,a4,s4
 638:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63c:	f9460713          	addi	a4,a2,-108
 640:	00173713          	seqz	a4,a4
 644:	8f75                	and	a4,a4,a3
 646:	f9c58513          	addi	a0,a1,-100
 64a:	18051363          	bnez	a0,7d0 <vprintf+0x252>
 64e:	18070163          	beqz	a4,7d0 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 652:	008b8493          	addi	s1,s7,8
 656:	4685                	li	a3,1
 658:	4629                	li	a2,10
 65a:	000bb583          	ld	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	e7bff0ef          	jal	4da <printint>
        i += 2;
 664:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 666:	8ba6                	mv	s7,s1
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	bfa1                	j	5c2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 66c:	008b8493          	addi	s1,s7,8
 670:	4681                	li	a3,0
 672:	4629                	li	a2,10
 674:	000be583          	lwu	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	e61ff0ef          	jal	4da <printint>
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
 682:	b781                	j	5c2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	008b8493          	addi	s1,s7,8
 688:	4681                	li	a3,0
 68a:	4629                	li	a2,10
 68c:	000bb583          	ld	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	e49ff0ef          	jal	4da <printint>
        i += 1;
 696:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b71d                	j	5c2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	008b8493          	addi	s1,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4629                	li	a2,10
 6a6:	000bb583          	ld	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	e2fff0ef          	jal	4da <printint>
        i += 2;
 6b0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	8ba6                	mv	s7,s1
      state = 0;
 6b4:	4981                	li	s3,0
        i += 2;
 6b6:	b731                	j	5c2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b8:	008b8493          	addi	s1,s7,8
 6bc:	4681                	li	a3,0
 6be:	4641                	li	a2,16
 6c0:	000be583          	lwu	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e15ff0ef          	jal	4da <printint>
 6ca:	8ba6                	mv	s7,s1
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bdd5                	j	5c2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d0:	008b8493          	addi	s1,s7,8
 6d4:	4681                	li	a3,0
 6d6:	4641                	li	a2,16
 6d8:	000bb583          	ld	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	dfdff0ef          	jal	4da <printint>
        i += 1;
 6e2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e4:	8ba6                	mv	s7,s1
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bde9                	j	5c2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	de3ff0ef          	jal	4da <printint>
        i += 2;
 6fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	b5c1                	j	5c2 <vprintf+0x44>
 704:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 706:	008b8793          	addi	a5,s7,8
 70a:	8cbe                	mv	s9,a5
 70c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 710:	03000593          	li	a1,48
 714:	855a                	mv	a0,s6
 716:	da7ff0ef          	jal	4bc <putc>
  putc(fd, 'x');
 71a:	07800593          	li	a1,120
 71e:	855a                	mv	a0,s6
 720:	d9dff0ef          	jal	4bc <putc>
 724:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 726:	00000b97          	auipc	s7,0x0
 72a:	34ab8b93          	addi	s7,s7,842 # a70 <digits>
 72e:	03c9d793          	srli	a5,s3,0x3c
 732:	97de                	add	a5,a5,s7
 734:	0007c583          	lbu	a1,0(a5)
 738:	855a                	mv	a0,s6
 73a:	d83ff0ef          	jal	4bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73e:	0992                	slli	s3,s3,0x4
 740:	34fd                	addiw	s1,s1,-1
 742:	f4f5                	bnez	s1,72e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 744:	8be6                	mv	s7,s9
      state = 0;
 746:	4981                	li	s3,0
 748:	6ca2                	ld	s9,8(sp)
 74a:	bda5                	j	5c2 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 74c:	008b8493          	addi	s1,s7,8
 750:	000bc583          	lbu	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	d67ff0ef          	jal	4bc <putc>
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b595                	j	5c2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 760:	008b8993          	addi	s3,s7,8
 764:	000bb483          	ld	s1,0(s7)
 768:	cc91                	beqz	s1,784 <vprintf+0x206>
        for(; *s; s++)
 76a:	0004c583          	lbu	a1,0(s1)
 76e:	c985                	beqz	a1,79e <vprintf+0x220>
          putc(fd, *s);
 770:	855a                	mv	a0,s6
 772:	d4bff0ef          	jal	4bc <putc>
        for(; *s; s++)
 776:	0485                	addi	s1,s1,1
 778:	0004c583          	lbu	a1,0(s1)
 77c:	f9f5                	bnez	a1,770 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	b581                	j	5c2 <vprintf+0x44>
          s = "(null)";
 784:	00000497          	auipc	s1,0x0
 788:	2e448493          	addi	s1,s1,740 # a68 <malloc+0x148>
        for(; *s; s++)
 78c:	02800593          	li	a1,40
 790:	b7c5                	j	770 <vprintf+0x1f2>
        putc(fd, '%');
 792:	85be                	mv	a1,a5
 794:	855a                	mv	a0,s6
 796:	d27ff0ef          	jal	4bc <putc>
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b51d                	j	5c2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 79e:	8bce                	mv	s7,s3
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b505                	j	5c2 <vprintf+0x44>
 7a4:	6906                	ld	s2,64(sp)
 7a6:	79e2                	ld	s3,56(sp)
 7a8:	7a42                	ld	s4,48(sp)
 7aa:	7aa2                	ld	s5,40(sp)
 7ac:	7b02                	ld	s6,32(sp)
 7ae:	6be2                	ld	s7,24(sp)
 7b0:	6c42                	ld	s8,16(sp)
    }
  }
}
 7b2:	60e6                	ld	ra,88(sp)
 7b4:	6446                	ld	s0,80(sp)
 7b6:	64a6                	ld	s1,72(sp)
 7b8:	6125                	addi	sp,sp,96
 7ba:	8082                	ret
      if(c0 == 'd'){
 7bc:	06400713          	li	a4,100
 7c0:	e4e78fe3          	beq	a5,a4,61e <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7c4:	f9478693          	addi	a3,a5,-108
 7c8:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7cc:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ce:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7d0:	07500513          	li	a0,117
 7d4:	e8a78ce3          	beq	a5,a0,66c <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7d8:	f8b60513          	addi	a0,a2,-117
 7dc:	e119                	bnez	a0,7e2 <vprintf+0x264>
 7de:	ea0693e3          	bnez	a3,684 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e2:	f8b58513          	addi	a0,a1,-117
 7e6:	e119                	bnez	a0,7ec <vprintf+0x26e>
 7e8:	ea071be3          	bnez	a4,69e <vprintf+0x120>
      } else if(c0 == 'x'){
 7ec:	07800513          	li	a0,120
 7f0:	eca784e3          	beq	a5,a0,6b8 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7f4:	f8860613          	addi	a2,a2,-120
 7f8:	e219                	bnez	a2,7fe <vprintf+0x280>
 7fa:	ec069be3          	bnez	a3,6d0 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7fe:	f8858593          	addi	a1,a1,-120
 802:	e199                	bnez	a1,808 <vprintf+0x28a>
 804:	ee0713e3          	bnez	a4,6ea <vprintf+0x16c>
      } else if(c0 == 'p'){
 808:	07000713          	li	a4,112
 80c:	eee78ce3          	beq	a5,a4,704 <vprintf+0x186>
      } else if(c0 == 'c'){
 810:	06300713          	li	a4,99
 814:	f2e78ce3          	beq	a5,a4,74c <vprintf+0x1ce>
      } else if(c0 == 's'){
 818:	07300713          	li	a4,115
 81c:	f4e782e3          	beq	a5,a4,760 <vprintf+0x1e2>
      } else if(c0 == '%'){
 820:	02500713          	li	a4,37
 824:	f6e787e3          	beq	a5,a4,792 <vprintf+0x214>
        putc(fd, '%');
 828:	02500593          	li	a1,37
 82c:	855a                	mv	a0,s6
 82e:	c8fff0ef          	jal	4bc <putc>
        putc(fd, c0);
 832:	85a6                	mv	a1,s1
 834:	855a                	mv	a0,s6
 836:	c87ff0ef          	jal	4bc <putc>
      state = 0;
 83a:	4981                	li	s3,0
 83c:	b359                	j	5c2 <vprintf+0x44>

000000000000083e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83e:	715d                	addi	sp,sp,-80
 840:	ec06                	sd	ra,24(sp)
 842:	e822                	sd	s0,16(sp)
 844:	1000                	addi	s0,sp,32
 846:	e010                	sd	a2,0(s0)
 848:	e414                	sd	a3,8(s0)
 84a:	e818                	sd	a4,16(s0)
 84c:	ec1c                	sd	a5,24(s0)
 84e:	03043023          	sd	a6,32(s0)
 852:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 856:	8622                	mv	a2,s0
 858:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 85c:	d23ff0ef          	jal	57e <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6161                	addi	sp,sp,80
 866:	8082                	ret

0000000000000868 <printf>:

void
printf(const char *fmt, ...)
{
 868:	711d                	addi	sp,sp,-96
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	1000                	addi	s0,sp,32
 870:	e40c                	sd	a1,8(s0)
 872:	e810                	sd	a2,16(s0)
 874:	ec14                	sd	a3,24(s0)
 876:	f018                	sd	a4,32(s0)
 878:	f41c                	sd	a5,40(s0)
 87a:	03043823          	sd	a6,48(s0)
 87e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 882:	00840613          	addi	a2,s0,8
 886:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 88a:	85aa                	mv	a1,a0
 88c:	4505                	li	a0,1
 88e:	cf1ff0ef          	jal	57e <vprintf>
}
 892:	60e2                	ld	ra,24(sp)
 894:	6442                	ld	s0,16(sp)
 896:	6125                	addi	sp,sp,96
 898:	8082                	ret

000000000000089a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89a:	1141                	addi	sp,sp,-16
 89c:	e406                	sd	ra,8(sp)
 89e:	e022                	sd	s0,0(sp)
 8a0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a6:	00000797          	auipc	a5,0x0
 8aa:	75a7b783          	ld	a5,1882(a5) # 1000 <freep>
 8ae:	a039                	j	8bc <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e7e463          	bltu	a5,a4,8ba <free+0x20>
 8b6:	00e6ea63          	bltu	a3,a4,8ca <free+0x30>
{
 8ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8bc:	fed7fae3          	bgeu	a5,a3,8b0 <free+0x16>
 8c0:	6398                	ld	a4,0(a5)
 8c2:	00e6e463          	bltu	a3,a4,8ca <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	fee7eae3          	bltu	a5,a4,8ba <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8ca:	ff852583          	lw	a1,-8(a0)
 8ce:	6390                	ld	a2,0(a5)
 8d0:	02059813          	slli	a6,a1,0x20
 8d4:	01c85713          	srli	a4,a6,0x1c
 8d8:	9736                	add	a4,a4,a3
 8da:	02e60563          	beq	a2,a4,904 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8e2:	4790                	lw	a2,8(a5)
 8e4:	02061593          	slli	a1,a2,0x20
 8e8:	01c5d713          	srli	a4,a1,0x1c
 8ec:	973e                	add	a4,a4,a5
 8ee:	02e68263          	beq	a3,a4,912 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f4:	00000717          	auipc	a4,0x0
 8f8:	70f73623          	sd	a5,1804(a4) # 1000 <freep>
}
 8fc:	60a2                	ld	ra,8(sp)
 8fe:	6402                	ld	s0,0(sp)
 900:	0141                	addi	sp,sp,16
 902:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 904:	4618                	lw	a4,8(a2)
 906:	9f2d                	addw	a4,a4,a1
 908:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 90c:	6398                	ld	a4,0(a5)
 90e:	6310                	ld	a2,0(a4)
 910:	b7f9                	j	8de <free+0x44>
    p->s.size += bp->s.size;
 912:	ff852703          	lw	a4,-8(a0)
 916:	9f31                	addw	a4,a4,a2
 918:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 91a:	ff053683          	ld	a3,-16(a0)
 91e:	bfd1                	j	8f2 <free+0x58>

0000000000000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	7139                	addi	sp,sp,-64
 922:	fc06                	sd	ra,56(sp)
 924:	f822                	sd	s0,48(sp)
 926:	f04a                	sd	s2,32(sp)
 928:	ec4e                	sd	s3,24(sp)
 92a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92c:	02051993          	slli	s3,a0,0x20
 930:	0209d993          	srli	s3,s3,0x20
 934:	09bd                	addi	s3,s3,15
 936:	0049d993          	srli	s3,s3,0x4
 93a:	2985                	addiw	s3,s3,1
 93c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 93e:	00000517          	auipc	a0,0x0
 942:	6c253503          	ld	a0,1730(a0) # 1000 <freep>
 946:	c905                	beqz	a0,976 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	09377663          	bgeu	a4,s3,9d8 <malloc+0xb8>
 950:	f426                	sd	s1,40(sp)
 952:	e852                	sd	s4,16(sp)
 954:	e456                	sd	s5,8(sp)
 956:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 958:	8a4e                	mv	s4,s3
 95a:	6705                	lui	a4,0x1
 95c:	00e9f363          	bgeu	s3,a4,962 <malloc+0x42>
 960:	6a05                	lui	s4,0x1
 962:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 966:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 96a:	00000497          	auipc	s1,0x0
 96e:	69648493          	addi	s1,s1,1686 # 1000 <freep>
  if(p == SBRK_ERROR)
 972:	5afd                	li	s5,-1
 974:	a83d                	j	9b2 <malloc+0x92>
 976:	f426                	sd	s1,40(sp)
 978:	e852                	sd	s4,16(sp)
 97a:	e456                	sd	s5,8(sp)
 97c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 97e:	00001797          	auipc	a5,0x1
 982:	89278793          	addi	a5,a5,-1902 # 1210 <base>
 986:	00000717          	auipc	a4,0x0
 98a:	66f73d23          	sd	a5,1658(a4) # 1000 <freep>
 98e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 990:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 994:	b7d1                	j	958 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 996:	6398                	ld	a4,0(a5)
 998:	e118                	sd	a4,0(a0)
 99a:	a899                	j	9f0 <malloc+0xd0>
  hp->s.size = nu;
 99c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a0:	0541                	addi	a0,a0,16
 9a2:	ef9ff0ef          	jal	89a <free>
  return freep;
 9a6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9a8:	c125                	beqz	a0,a08 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ac:	4798                	lw	a4,8(a5)
 9ae:	03277163          	bgeu	a4,s2,9d0 <malloc+0xb0>
    if(p == freep)
 9b2:	6098                	ld	a4,0(s1)
 9b4:	853e                	mv	a0,a5
 9b6:	fef71ae3          	bne	a4,a5,9aa <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9ba:	8552                	mv	a0,s4
 9bc:	a25ff0ef          	jal	3e0 <sbrk>
  if(p == SBRK_ERROR)
 9c0:	fd551ee3          	bne	a0,s5,99c <malloc+0x7c>
        return 0;
 9c4:	4501                	li	a0,0
 9c6:	74a2                	ld	s1,40(sp)
 9c8:	6a42                	ld	s4,16(sp)
 9ca:	6aa2                	ld	s5,8(sp)
 9cc:	6b02                	ld	s6,0(sp)
 9ce:	a03d                	j	9fc <malloc+0xdc>
 9d0:	74a2                	ld	s1,40(sp)
 9d2:	6a42                	ld	s4,16(sp)
 9d4:	6aa2                	ld	s5,8(sp)
 9d6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9d8:	fae90fe3          	beq	s2,a4,996 <malloc+0x76>
        p->s.size -= nunits;
 9dc:	4137073b          	subw	a4,a4,s3
 9e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e2:	02071693          	slli	a3,a4,0x20
 9e6:	01c6d713          	srli	a4,a3,0x1c
 9ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f0:	00000717          	auipc	a4,0x0
 9f4:	60a73823          	sd	a0,1552(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f8:	01078513          	addi	a0,a5,16
  }
}
 9fc:	70e2                	ld	ra,56(sp)
 9fe:	7442                	ld	s0,48(sp)
 a00:	7902                	ld	s2,32(sp)
 a02:	69e2                	ld	s3,24(sp)
 a04:	6121                	addi	sp,sp,64
 a06:	8082                	ret
 a08:	74a2                	ld	s1,40(sp)
 a0a:	6a42                	ld	s4,16(sp)
 a0c:	6aa2                	ld	s5,8(sp)
 a0e:	6b02                	ld	s6,0(sp)
 a10:	b7f5                	j	9fc <malloc+0xdc>
