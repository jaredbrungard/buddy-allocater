
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
  40:	9d4a0a13          	addi	s4,s4,-1580 # a10 <malloc+0xf8>
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
  a2:	99250513          	addi	a0,a0,-1646 # a30 <malloc+0x118>
  a6:	7ba000ef          	jal	860 <printf>
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
  cc:	95850513          	addi	a0,a0,-1704 # a20 <malloc+0x108>
  d0:	790000ef          	jal	860 <printf>
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
 136:	8e658593          	addi	a1,a1,-1818 # a18 <malloc+0x100>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2d2000ef          	jal	414 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8f650513          	addi	a0,a0,-1802 # a40 <malloc+0x128>
 152:	70e000ef          	jal	860 <printf>
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

00000000000004b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b4:	1101                	addi	sp,sp,-32
 4b6:	ec06                	sd	ra,24(sp)
 4b8:	e822                	sd	s0,16(sp)
 4ba:	1000                	addi	s0,sp,32
 4bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c0:	4605                	li	a2,1
 4c2:	fef40593          	addi	a1,s0,-17
 4c6:	f6fff0ef          	jal	434 <write>
}
 4ca:	60e2                	ld	ra,24(sp)
 4cc:	6442                	ld	s0,16(sp)
 4ce:	6105                	addi	sp,sp,32
 4d0:	8082                	ret

00000000000004d2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4d2:	715d                	addi	sp,sp,-80
 4d4:	e486                	sd	ra,72(sp)
 4d6:	e0a2                	sd	s0,64(sp)
 4d8:	f84a                	sd	s2,48(sp)
 4da:	f44e                	sd	s3,40(sp)
 4dc:	0880                	addi	s0,sp,80
 4de:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e0:	cac1                	beqz	a3,570 <printint+0x9e>
 4e2:	0805d763          	bgez	a1,570 <printint+0x9e>
    neg = 1;
    x = -xx;
 4e6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ea:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4ec:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4f0:	86ce                	mv	a3,s3
  i = 0;
 4f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f4:	00000817          	auipc	a6,0x0
 4f8:	56c80813          	addi	a6,a6,1388 # a60 <digits>
 4fc:	88ba                	mv	a7,a4
 4fe:	0017051b          	addiw	a0,a4,1
 502:	872a                	mv	a4,a0
 504:	02c5f7bb          	remuw	a5,a1,a2
 508:	1782                	slli	a5,a5,0x20
 50a:	9381                	srli	a5,a5,0x20
 50c:	97c2                	add	a5,a5,a6
 50e:	0007c783          	lbu	a5,0(a5)
 512:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 516:	87ae                	mv	a5,a1
 518:	02c5d5bb          	divuw	a1,a1,a2
 51c:	0685                	addi	a3,a3,1
 51e:	fcc7ffe3          	bgeu	a5,a2,4fc <printint+0x2a>
  if(neg)
 522:	00030c63          	beqz	t1,53a <printint+0x68>
    buf[i++] = '-';
 526:	fd050793          	addi	a5,a0,-48
 52a:	00878533          	add	a0,a5,s0
 52e:	02d00793          	li	a5,45
 532:	fef50423          	sb	a5,-24(a0)
 536:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 53a:	02e05563          	blez	a4,564 <printint+0x92>
 53e:	fc26                	sd	s1,56(sp)
 540:	377d                	addiw	a4,a4,-1
 542:	00e984b3          	add	s1,s3,a4
 546:	19fd                	addi	s3,s3,-1
 548:	99ba                	add	s3,s3,a4
 54a:	1702                	slli	a4,a4,0x20
 54c:	9301                	srli	a4,a4,0x20
 54e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 552:	0004c583          	lbu	a1,0(s1)
 556:	854a                	mv	a0,s2
 558:	f5dff0ef          	jal	4b4 <putc>
  while(--i >= 0)
 55c:	14fd                	addi	s1,s1,-1
 55e:	ff349ae3          	bne	s1,s3,552 <printint+0x80>
 562:	74e2                	ld	s1,56(sp)
}
 564:	60a6                	ld	ra,72(sp)
 566:	6406                	ld	s0,64(sp)
 568:	7942                	ld	s2,48(sp)
 56a:	79a2                	ld	s3,40(sp)
 56c:	6161                	addi	sp,sp,80
 56e:	8082                	ret
    x = xx;
 570:	2581                	sext.w	a1,a1
  neg = 0;
 572:	4301                	li	t1,0
 574:	bfa5                	j	4ec <printint+0x1a>

0000000000000576 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 576:	711d                	addi	sp,sp,-96
 578:	ec86                	sd	ra,88(sp)
 57a:	e8a2                	sd	s0,80(sp)
 57c:	e4a6                	sd	s1,72(sp)
 57e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 580:	0005c483          	lbu	s1,0(a1)
 584:	22048363          	beqz	s1,7aa <vprintf+0x234>
 588:	e0ca                	sd	s2,64(sp)
 58a:	fc4e                	sd	s3,56(sp)
 58c:	f852                	sd	s4,48(sp)
 58e:	f456                	sd	s5,40(sp)
 590:	f05a                	sd	s6,32(sp)
 592:	ec5e                	sd	s7,24(sp)
 594:	e862                	sd	s8,16(sp)
 596:	8b2a                	mv	s6,a0
 598:	8a2e                	mv	s4,a1
 59a:	8bb2                	mv	s7,a2
  state = 0;
 59c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 59e:	4901                	li	s2,0
 5a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5a6:	06400c13          	li	s8,100
 5aa:	a00d                	j	5cc <vprintf+0x56>
        putc(fd, c0);
 5ac:	85a6                	mv	a1,s1
 5ae:	855a                	mv	a0,s6
 5b0:	f05ff0ef          	jal	4b4 <putc>
 5b4:	a019                	j	5ba <vprintf+0x44>
    } else if(state == '%'){
 5b6:	03598363          	beq	s3,s5,5dc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5ba:	0019079b          	addiw	a5,s2,1
 5be:	893e                	mv	s2,a5
 5c0:	873e                	mv	a4,a5
 5c2:	97d2                	add	a5,a5,s4
 5c4:	0007c483          	lbu	s1,0(a5)
 5c8:	1c048a63          	beqz	s1,79c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5cc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5d0:	fe0993e3          	bnez	s3,5b6 <vprintf+0x40>
      if(c0 == '%'){
 5d4:	fd579ce3          	bne	a5,s5,5ac <vprintf+0x36>
        state = '%';
 5d8:	89be                	mv	s3,a5
 5da:	b7c5                	j	5ba <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5dc:	00ea06b3          	add	a3,s4,a4
 5e0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5e4:	1c060863          	beqz	a2,7b4 <vprintf+0x23e>
      if(c0 == 'd'){
 5e8:	03878763          	beq	a5,s8,616 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ec:	f9478693          	addi	a3,a5,-108
 5f0:	0016b693          	seqz	a3,a3
 5f4:	f9c60593          	addi	a1,a2,-100
 5f8:	e99d                	bnez	a1,62e <vprintf+0xb8>
 5fa:	ca95                	beqz	a3,62e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4685                	li	a3,1
 602:	4629                	li	a2,10
 604:	000bb583          	ld	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	ec9ff0ef          	jal	4d2 <printint>
        i += 1;
 60e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 610:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 612:	4981                	li	s3,0
 614:	b75d                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 616:	008b8493          	addi	s1,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000ba583          	lw	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	eafff0ef          	jal	4d2 <printint>
 628:	8ba6                	mv	s7,s1
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b779                	j	5ba <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 62e:	9752                	add	a4,a4,s4
 630:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 634:	f9460713          	addi	a4,a2,-108
 638:	00173713          	seqz	a4,a4
 63c:	8f75                	and	a4,a4,a3
 63e:	f9c58513          	addi	a0,a1,-100
 642:	18051363          	bnez	a0,7c8 <vprintf+0x252>
 646:	18070163          	beqz	a4,7c8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	008b8493          	addi	s1,s7,8
 64e:	4685                	li	a3,1
 650:	4629                	li	a2,10
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	e7bff0ef          	jal	4d2 <printint>
        i += 2;
 65c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	8ba6                	mv	s7,s1
      state = 0;
 660:	4981                	li	s3,0
        i += 2;
 662:	bfa1                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 664:	008b8493          	addi	s1,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000be583          	lwu	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e61ff0ef          	jal	4d2 <printint>
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
 67a:	b781                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8493          	addi	s1,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e49ff0ef          	jal	4d2 <printint>
        i += 1;
 68e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
 694:	b71d                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8493          	addi	s1,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000bb583          	ld	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	e2fff0ef          	jal	4d2 <printint>
        i += 2;
 6a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	8ba6                	mv	s7,s1
      state = 0;
 6ac:	4981                	li	s3,0
        i += 2;
 6ae:	b731                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b0:	008b8493          	addi	s1,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000be583          	lwu	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	e15ff0ef          	jal	4d2 <printint>
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bdd5                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	008b8493          	addi	s1,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	dfdff0ef          	jal	4d2 <printint>
        i += 1;
 6da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	8ba6                	mv	s7,s1
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bde9                	j	5ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	008b8493          	addi	s1,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000bb583          	ld	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	de3ff0ef          	jal	4d2 <printint>
        i += 2;
 6f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	8ba6                	mv	s7,s1
      state = 0;
 6f8:	4981                	li	s3,0
        i += 2;
 6fa:	b5c1                	j	5ba <vprintf+0x44>
 6fc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6fe:	008b8793          	addi	a5,s7,8
 702:	8cbe                	mv	s9,a5
 704:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 708:	03000593          	li	a1,48
 70c:	855a                	mv	a0,s6
 70e:	da7ff0ef          	jal	4b4 <putc>
  putc(fd, 'x');
 712:	07800593          	li	a1,120
 716:	855a                	mv	a0,s6
 718:	d9dff0ef          	jal	4b4 <putc>
 71c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71e:	00000b97          	auipc	s7,0x0
 722:	342b8b93          	addi	s7,s7,834 # a60 <digits>
 726:	03c9d793          	srli	a5,s3,0x3c
 72a:	97de                	add	a5,a5,s7
 72c:	0007c583          	lbu	a1,0(a5)
 730:	855a                	mv	a0,s6
 732:	d83ff0ef          	jal	4b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 736:	0992                	slli	s3,s3,0x4
 738:	34fd                	addiw	s1,s1,-1
 73a:	f4f5                	bnez	s1,726 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 73c:	8be6                	mv	s7,s9
      state = 0;
 73e:	4981                	li	s3,0
 740:	6ca2                	ld	s9,8(sp)
 742:	bda5                	j	5ba <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 744:	008b8493          	addi	s1,s7,8
 748:	000bc583          	lbu	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	d67ff0ef          	jal	4b4 <putc>
 752:	8ba6                	mv	s7,s1
      state = 0;
 754:	4981                	li	s3,0
 756:	b595                	j	5ba <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 758:	008b8993          	addi	s3,s7,8
 75c:	000bb483          	ld	s1,0(s7)
 760:	cc91                	beqz	s1,77c <vprintf+0x206>
        for(; *s; s++)
 762:	0004c583          	lbu	a1,0(s1)
 766:	c985                	beqz	a1,796 <vprintf+0x220>
          putc(fd, *s);
 768:	855a                	mv	a0,s6
 76a:	d4bff0ef          	jal	4b4 <putc>
        for(; *s; s++)
 76e:	0485                	addi	s1,s1,1
 770:	0004c583          	lbu	a1,0(s1)
 774:	f9f5                	bnez	a1,768 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 776:	8bce                	mv	s7,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	b581                	j	5ba <vprintf+0x44>
          s = "(null)";
 77c:	00000497          	auipc	s1,0x0
 780:	2dc48493          	addi	s1,s1,732 # a58 <malloc+0x140>
        for(; *s; s++)
 784:	02800593          	li	a1,40
 788:	b7c5                	j	768 <vprintf+0x1f2>
        putc(fd, '%');
 78a:	85be                	mv	a1,a5
 78c:	855a                	mv	a0,s6
 78e:	d27ff0ef          	jal	4b4 <putc>
      state = 0;
 792:	4981                	li	s3,0
 794:	b51d                	j	5ba <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 796:	8bce                	mv	s7,s3
      state = 0;
 798:	4981                	li	s3,0
 79a:	b505                	j	5ba <vprintf+0x44>
 79c:	6906                	ld	s2,64(sp)
 79e:	79e2                	ld	s3,56(sp)
 7a0:	7a42                	ld	s4,48(sp)
 7a2:	7aa2                	ld	s5,40(sp)
 7a4:	7b02                	ld	s6,32(sp)
 7a6:	6be2                	ld	s7,24(sp)
 7a8:	6c42                	ld	s8,16(sp)
    }
  }
}
 7aa:	60e6                	ld	ra,88(sp)
 7ac:	6446                	ld	s0,80(sp)
 7ae:	64a6                	ld	s1,72(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret
      if(c0 == 'd'){
 7b4:	06400713          	li	a4,100
 7b8:	e4e78fe3          	beq	a5,a4,616 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7bc:	f9478693          	addi	a3,a5,-108
 7c0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7c4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7c6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7c8:	07500513          	li	a0,117
 7cc:	e8a78ce3          	beq	a5,a0,664 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7d0:	f8b60513          	addi	a0,a2,-117
 7d4:	e119                	bnez	a0,7da <vprintf+0x264>
 7d6:	ea0693e3          	bnez	a3,67c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7da:	f8b58513          	addi	a0,a1,-117
 7de:	e119                	bnez	a0,7e4 <vprintf+0x26e>
 7e0:	ea071be3          	bnez	a4,696 <vprintf+0x120>
      } else if(c0 == 'x'){
 7e4:	07800513          	li	a0,120
 7e8:	eca784e3          	beq	a5,a0,6b0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7ec:	f8860613          	addi	a2,a2,-120
 7f0:	e219                	bnez	a2,7f6 <vprintf+0x280>
 7f2:	ec069be3          	bnez	a3,6c8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7f6:	f8858593          	addi	a1,a1,-120
 7fa:	e199                	bnez	a1,800 <vprintf+0x28a>
 7fc:	ee0713e3          	bnez	a4,6e2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 800:	07000713          	li	a4,112
 804:	eee78ce3          	beq	a5,a4,6fc <vprintf+0x186>
      } else if(c0 == 'c'){
 808:	06300713          	li	a4,99
 80c:	f2e78ce3          	beq	a5,a4,744 <vprintf+0x1ce>
      } else if(c0 == 's'){
 810:	07300713          	li	a4,115
 814:	f4e782e3          	beq	a5,a4,758 <vprintf+0x1e2>
      } else if(c0 == '%'){
 818:	02500713          	li	a4,37
 81c:	f6e787e3          	beq	a5,a4,78a <vprintf+0x214>
        putc(fd, '%');
 820:	02500593          	li	a1,37
 824:	855a                	mv	a0,s6
 826:	c8fff0ef          	jal	4b4 <putc>
        putc(fd, c0);
 82a:	85a6                	mv	a1,s1
 82c:	855a                	mv	a0,s6
 82e:	c87ff0ef          	jal	4b4 <putc>
      state = 0;
 832:	4981                	li	s3,0
 834:	b359                	j	5ba <vprintf+0x44>

0000000000000836 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 836:	715d                	addi	sp,sp,-80
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	addi	s0,sp,32
 83e:	e010                	sd	a2,0(s0)
 840:	e414                	sd	a3,8(s0)
 842:	e818                	sd	a4,16(s0)
 844:	ec1c                	sd	a5,24(s0)
 846:	03043023          	sd	a6,32(s0)
 84a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	8622                	mv	a2,s0
 850:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 854:	d23ff0ef          	jal	576 <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6161                	addi	sp,sp,80
 85e:	8082                	ret

0000000000000860 <printf>:

void
printf(const char *fmt, ...)
{
 860:	711d                	addi	sp,sp,-96
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e40c                	sd	a1,8(s0)
 86a:	e810                	sd	a2,16(s0)
 86c:	ec14                	sd	a3,24(s0)
 86e:	f018                	sd	a4,32(s0)
 870:	f41c                	sd	a5,40(s0)
 872:	03043823          	sd	a6,48(s0)
 876:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87a:	00840613          	addi	a2,s0,8
 87e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 882:	85aa                	mv	a1,a0
 884:	4505                	li	a0,1
 886:	cf1ff0ef          	jal	576 <vprintf>
}
 88a:	60e2                	ld	ra,24(sp)
 88c:	6442                	ld	s0,16(sp)
 88e:	6125                	addi	sp,sp,96
 890:	8082                	ret

0000000000000892 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 892:	1141                	addi	sp,sp,-16
 894:	e406                	sd	ra,8(sp)
 896:	e022                	sd	s0,0(sp)
 898:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89e:	00000797          	auipc	a5,0x0
 8a2:	7627b783          	ld	a5,1890(a5) # 1000 <freep>
 8a6:	a039                	j	8b4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	6398                	ld	a4,0(a5)
 8aa:	00e7e463          	bltu	a5,a4,8b2 <free+0x20>
 8ae:	00e6ea63          	bltu	a3,a4,8c2 <free+0x30>
{
 8b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	fed7fae3          	bgeu	a5,a3,8a8 <free+0x16>
 8b8:	6398                	ld	a4,0(a5)
 8ba:	00e6e463          	bltu	a3,a4,8c2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	fee7eae3          	bltu	a5,a4,8b2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c2:	ff852583          	lw	a1,-8(a0)
 8c6:	6390                	ld	a2,0(a5)
 8c8:	02059813          	slli	a6,a1,0x20
 8cc:	01c85713          	srli	a4,a6,0x1c
 8d0:	9736                	add	a4,a4,a3
 8d2:	02e60563          	beq	a2,a4,8fc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8d6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8da:	4790                	lw	a2,8(a5)
 8dc:	02061593          	slli	a1,a2,0x20
 8e0:	01c5d713          	srli	a4,a1,0x1c
 8e4:	973e                	add	a4,a4,a5
 8e6:	02e68263          	beq	a3,a4,90a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70f73a23          	sd	a5,1812(a4) # 1000 <freep>
}
 8f4:	60a2                	ld	ra,8(sp)
 8f6:	6402                	ld	s0,0(sp)
 8f8:	0141                	addi	sp,sp,16
 8fa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8fc:	4618                	lw	a4,8(a2)
 8fe:	9f2d                	addw	a4,a4,a1
 900:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 904:	6398                	ld	a4,0(a5)
 906:	6310                	ld	a2,0(a4)
 908:	b7f9                	j	8d6 <free+0x44>
    p->s.size += bp->s.size;
 90a:	ff852703          	lw	a4,-8(a0)
 90e:	9f31                	addw	a4,a4,a2
 910:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 912:	ff053683          	ld	a3,-16(a0)
 916:	bfd1                	j	8ea <free+0x58>

0000000000000918 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 918:	7139                	addi	sp,sp,-64
 91a:	fc06                	sd	ra,56(sp)
 91c:	f822                	sd	s0,48(sp)
 91e:	f04a                	sd	s2,32(sp)
 920:	ec4e                	sd	s3,24(sp)
 922:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 924:	02051993          	slli	s3,a0,0x20
 928:	0209d993          	srli	s3,s3,0x20
 92c:	09bd                	addi	s3,s3,15
 92e:	0049d993          	srli	s3,s3,0x4
 932:	2985                	addiw	s3,s3,1
 934:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 936:	00000517          	auipc	a0,0x0
 93a:	6ca53503          	ld	a0,1738(a0) # 1000 <freep>
 93e:	c905                	beqz	a0,96e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 942:	4798                	lw	a4,8(a5)
 944:	09377663          	bgeu	a4,s3,9d0 <malloc+0xb8>
 948:	f426                	sd	s1,40(sp)
 94a:	e852                	sd	s4,16(sp)
 94c:	e456                	sd	s5,8(sp)
 94e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 950:	8a4e                	mv	s4,s3
 952:	6705                	lui	a4,0x1
 954:	00e9f363          	bgeu	s3,a4,95a <malloc+0x42>
 958:	6a05                	lui	s4,0x1
 95a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 962:	00000497          	auipc	s1,0x0
 966:	69e48493          	addi	s1,s1,1694 # 1000 <freep>
  if(p == SBRK_ERROR)
 96a:	5afd                	li	s5,-1
 96c:	a83d                	j	9aa <malloc+0x92>
 96e:	f426                	sd	s1,40(sp)
 970:	e852                	sd	s4,16(sp)
 972:	e456                	sd	s5,8(sp)
 974:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 976:	00001797          	auipc	a5,0x1
 97a:	89a78793          	addi	a5,a5,-1894 # 1210 <base>
 97e:	00000717          	auipc	a4,0x0
 982:	68f73123          	sd	a5,1666(a4) # 1000 <freep>
 986:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 988:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98c:	b7d1                	j	950 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 98e:	6398                	ld	a4,0(a5)
 990:	e118                	sd	a4,0(a0)
 992:	a899                	j	9e8 <malloc+0xd0>
  hp->s.size = nu;
 994:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 998:	0541                	addi	a0,a0,16
 99a:	ef9ff0ef          	jal	892 <free>
  return freep;
 99e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9a0:	c125                	beqz	a0,a00 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a4:	4798                	lw	a4,8(a5)
 9a6:	03277163          	bgeu	a4,s2,9c8 <malloc+0xb0>
    if(p == freep)
 9aa:	6098                	ld	a4,0(s1)
 9ac:	853e                	mv	a0,a5
 9ae:	fef71ae3          	bne	a4,a5,9a2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9b2:	8552                	mv	a0,s4
 9b4:	a2dff0ef          	jal	3e0 <sbrk>
  if(p == SBRK_ERROR)
 9b8:	fd551ee3          	bne	a0,s5,994 <malloc+0x7c>
        return 0;
 9bc:	4501                	li	a0,0
 9be:	74a2                	ld	s1,40(sp)
 9c0:	6a42                	ld	s4,16(sp)
 9c2:	6aa2                	ld	s5,8(sp)
 9c4:	6b02                	ld	s6,0(sp)
 9c6:	a03d                	j	9f4 <malloc+0xdc>
 9c8:	74a2                	ld	s1,40(sp)
 9ca:	6a42                	ld	s4,16(sp)
 9cc:	6aa2                	ld	s5,8(sp)
 9ce:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9d0:	fae90fe3          	beq	s2,a4,98e <malloc+0x76>
        p->s.size -= nunits;
 9d4:	4137073b          	subw	a4,a4,s3
 9d8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9da:	02071693          	slli	a3,a4,0x20
 9de:	01c6d713          	srli	a4,a3,0x1c
 9e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9e8:	00000717          	auipc	a4,0x0
 9ec:	60a73c23          	sd	a0,1560(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f0:	01078513          	addi	a0,a5,16
  }
}
 9f4:	70e2                	ld	ra,56(sp)
 9f6:	7442                	ld	s0,48(sp)
 9f8:	7902                	ld	s2,32(sp)
 9fa:	69e2                	ld	s3,24(sp)
 9fc:	6121                	addi	sp,sp,64
 9fe:	8082                	ret
 a00:	74a2                	ld	s1,40(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6b02                	ld	s6,0(sp)
 a08:	b7f5                	j	9f4 <malloc+0xdc>
