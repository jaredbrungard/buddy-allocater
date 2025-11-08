
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	ff890913          	addi	s2,s2,-8 # 1010 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	39e000ef          	jal	3c6 <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	396000ef          	jal	3ce <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	97058593          	addi	a1,a1,-1680 # 9b0 <malloc+0xf6>
  48:	4509                	li	a0,2
  4a:	78e000ef          	jal	7d8 <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	35e000ef          	jal	3ae <exit>
    }
  }
  if(n < 0){
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	95e58593          	addi	a1,a1,-1698 # 9c8 <malloc+0x10e>
  72:	4509                	li	a0,2
  74:	764000ef          	jal	7d8 <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	334000ef          	jal	3ae <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	342000ef          	jal	3ee <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	31a000ef          	jal	3d6 <close>
  for(i = 1; i < argc; i++){
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2e6000ef          	jal	3ae <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2d4000ef          	jal	3ae <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	8fe58593          	addi	a1,a1,-1794 # 9e0 <malloc+0x126>
  ea:	4509                	li	a0,2
  ec:	6ec000ef          	jal	7d8 <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2bc000ef          	jal	3ae <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  extern int main();
  main();
  fe:	f81ff0ef          	jal	7e <main>
  exit(0);
 102:	4501                	li	a0,0
 104:	2aa000ef          	jal	3ae <exit>

0000000000000108 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 110:	87aa                	mv	a5,a0
 112:	0585                	addi	a1,a1,1
 114:	0785                	addi	a5,a5,1
 116:	fff5c703          	lbu	a4,-1(a1)
 11a:	fee78fa3          	sb	a4,-1(a5)
 11e:	fb75                	bnez	a4,112 <strcpy+0xa>
    ;
  return os;
}
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb91                	beqz	a5,148 <strcmp+0x20>
 136:	0005c703          	lbu	a4,0(a1)
 13a:	00f71763          	bne	a4,a5,148 <strcmp+0x20>
    p++, q++;
 13e:	0505                	addi	a0,a0,1
 140:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 142:	00054783          	lbu	a5,0(a0)
 146:	fbe5                	bnez	a5,136 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 148:	0005c503          	lbu	a0,0(a1)
}
 14c:	40a7853b          	subw	a0,a5,a0
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e406                	sd	ra,8(sp)
 15c:	e022                	sd	s0,0(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x28>
 166:	00150793          	addi	a5,a0,1
 16a:	86be                	mv	a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x12>
 174:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 178:	60a2                	ld	ra,8(sp)
 17a:	6402                	ld	s0,0(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfdd                	j	178 <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18c:	ca19                	beqz	a2,1a2 <memset+0x1e>
 18e:	87aa                	mv	a5,a0
 190:	1602                	slli	a2,a2,0x20
 192:	9201                	srli	a2,a2,0x20
 194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19c:	0785                	addi	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x14>
  }
  return dst;
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strchr>:

char*
strchr(const char *s, char c)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cf81                	beqz	a5,1ce <strchr+0x24>
    if(*s == c)
 1b8:	00f58763          	beq	a1,a5,1c6 <strchr+0x1c>
  for(; *s; s++)
 1bc:	0505                	addi	a0,a0,1
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbfd                	bnez	a5,1b8 <strchr+0xe>
      return (char*)s;
  return 0;
 1c4:	4501                	li	a0,0
}
 1c6:	60a2                	ld	ra,8(sp)
 1c8:	6402                	ld	s0,0(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  return 0;
 1ce:	4501                	li	a0,0
 1d0:	bfdd                	j	1c6 <strchr+0x1c>

00000000000001d2 <gets>:

char*
gets(char *buf, int max)
{
 1d2:	711d                	addi	sp,sp,-96
 1d4:	ec86                	sd	ra,88(sp)
 1d6:	e8a2                	sd	s0,80(sp)
 1d8:	e4a6                	sd	s1,72(sp)
 1da:	e0ca                	sd	s2,64(sp)
 1dc:	fc4e                	sd	s3,56(sp)
 1de:	f852                	sd	s4,48(sp)
 1e0:	f456                	sd	s5,40(sp)
 1e2:	f05a                	sd	s6,32(sp)
 1e4:	ec5e                	sd	s7,24(sp)
 1e6:	e862                	sd	s8,16(sp)
 1e8:	1080                	addi	s0,sp,96
 1ea:	8baa                	mv	s7,a0
 1ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	892a                	mv	s2,a0
 1f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f2:	faf40b13          	addi	s6,s0,-81
 1f6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1f8:	8c26                	mv	s8,s1
 1fa:	0014899b          	addiw	s3,s1,1
 1fe:	84ce                	mv	s1,s3
 200:	0349d463          	bge	s3,s4,228 <gets+0x56>
    cc = read(0, &c, 1);
 204:	8656                	mv	a2,s5
 206:	85da                	mv	a1,s6
 208:	4501                	li	a0,0
 20a:	1bc000ef          	jal	3c6 <read>
    if(cc < 1)
 20e:	00a05d63          	blez	a0,228 <gets+0x56>
      break;
    buf[i++] = c;
 212:	faf44783          	lbu	a5,-81(s0)
 216:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21a:	0905                	addi	s2,s2,1
 21c:	ff678713          	addi	a4,a5,-10
 220:	c319                	beqz	a4,226 <gets+0x54>
 222:	17cd                	addi	a5,a5,-13
 224:	fbf1                	bnez	a5,1f8 <gets+0x26>
    buf[i++] = c;
 226:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 228:	9c5e                	add	s8,s8,s7
 22a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 22e:	855e                	mv	a0,s7
 230:	60e6                	ld	ra,88(sp)
 232:	6446                	ld	s0,80(sp)
 234:	64a6                	ld	s1,72(sp)
 236:	6906                	ld	s2,64(sp)
 238:	79e2                	ld	s3,56(sp)
 23a:	7a42                	ld	s4,48(sp)
 23c:	7aa2                	ld	s5,40(sp)
 23e:	7b02                	ld	s6,32(sp)
 240:	6be2                	ld	s7,24(sp)
 242:	6c42                	ld	s8,16(sp)
 244:	6125                	addi	sp,sp,96
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	1000                	addi	s0,sp,32
 252:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	4581                	li	a1,0
 256:	198000ef          	jal	3ee <open>
  if(fd < 0)
 25a:	02054263          	bltz	a0,27e <stat+0x36>
 25e:	e426                	sd	s1,8(sp)
 260:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 262:	85ca                	mv	a1,s2
 264:	1a2000ef          	jal	406 <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	16a000ef          	jal	3d6 <close>
  return r;
 270:	64a2                	ld	s1,8(sp)
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	57fd                	li	a5,-1
 280:	893e                	mv	s2,a5
 282:	bfc5                	j	272 <stat+0x2a>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28c:	00054683          	lbu	a3,0(a0)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	4625                	li	a2,9
 29a:	02f66963          	bltu	a2,a5,2cc <atoi+0x48>
 29e:	872a                	mv	a4,a0
  n = 0;
 2a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a2:	0705                	addi	a4,a4,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb5                	addw	a5,a5,a3
 2b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	00074683          	lbu	a3,0(a4)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	fef671e3          	bgeu	a2,a5,2a2 <atoi+0x1e>
  return n;
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  n = 0;
 2cc:	4501                	li	a0,0
 2ce:	bfdd                	j	2c4 <atoi+0x40>

00000000000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d8:	02b57563          	bgeu	a0,a1,302 <memmove+0x32>
    while(n-- > 0)
 2dc:	00c05f63          	blez	a2,2fa <memmove+0x2a>
 2e0:	1602                	slli	a2,a2,0x20
 2e2:	9201                	srli	a2,a2,0x20
 2e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ea:	0585                	addi	a1,a1,1
 2ec:	0705                	addi	a4,a4,1
 2ee:	fff5c683          	lbu	a3,-1(a1)
 2f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f6:	fee79ae3          	bne	a5,a4,2ea <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
    while(n-- > 0)
 302:	fec05ce3          	blez	a2,2fa <memmove+0x2a>
    dst += n;
 306:	00c50733          	add	a4,a0,a2
    src += n;
 30a:	95b2                	add	a1,a1,a2
 30c:	fff6079b          	addiw	a5,a2,-1
 310:	1782                	slli	a5,a5,0x20
 312:	9381                	srli	a5,a5,0x20
 314:	fff7c793          	not	a5,a5
 318:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31a:	15fd                	addi	a1,a1,-1
 31c:	177d                	addi	a4,a4,-1
 31e:	0005c683          	lbu	a3,0(a1)
 322:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 326:	fef71ae3          	bne	a4,a5,31a <memmove+0x4a>
 32a:	bfc1                	j	2fa <memmove+0x2a>

000000000000032c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 334:	c61d                	beqz	a2,362 <memcmp+0x36>
 336:	1602                	slli	a2,a2,0x20
 338:	9201                	srli	a2,a2,0x20
 33a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 33e:	00054783          	lbu	a5,0(a0)
 342:	0005c703          	lbu	a4,0(a1)
 346:	00e79863          	bne	a5,a4,356 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 34a:	0505                	addi	a0,a0,1
    p2++;
 34c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34e:	fed518e3          	bne	a0,a3,33e <memcmp+0x12>
  }
  return 0;
 352:	4501                	li	a0,0
 354:	a019                	j	35a <memcmp+0x2e>
      return *p1 - *p2;
 356:	40e7853b          	subw	a0,a5,a4
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret
  return 0;
 362:	4501                	li	a0,0
 364:	bfdd                	j	35a <memcmp+0x2e>

0000000000000366 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36e:	f63ff0ef          	jal	2d0 <memmove>
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret

000000000000037a <sbrk>:

char *
sbrk(int n) {
 37a:	1141                	addi	sp,sp,-16
 37c:	e406                	sd	ra,8(sp)
 37e:	e022                	sd	s0,0(sp)
 380:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 382:	4585                	li	a1,1
 384:	0b2000ef          	jal	436 <sys_sbrk>
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <sbrklazy>:

char *
sbrklazy(int n) {
 390:	1141                	addi	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 398:	4589                	li	a1,2
 39a:	09c000ef          	jal	436 <sys_sbrk>
}
 39e:	60a2                	ld	ra,8(sp)
 3a0:	6402                	ld	s0,0(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a6:	4885                	li	a7,1
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ae:	4889                	li	a7,2
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b6:	488d                	li	a7,3
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3be:	4891                	li	a7,4
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <read>:
.global read
read:
 li a7, SYS_read
 3c6:	4895                	li	a7,5
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <write>:
.global write
write:
 li a7, SYS_write
 3ce:	48c1                	li	a7,16
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <close>:
.global close
close:
 li a7, SYS_close
 3d6:	48d5                	li	a7,21
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <kill>:
.global kill
kill:
 li a7, SYS_kill
 3de:	4899                	li	a7,6
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e6:	489d                	li	a7,7
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <open>:
.global open
open:
 li a7, SYS_open
 3ee:	48bd                	li	a7,15
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f6:	48c5                	li	a7,17
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fe:	48c9                	li	a7,18
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 406:	48a1                	li	a7,8
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <link>:
.global link
link:
 li a7, SYS_link
 40e:	48cd                	li	a7,19
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 416:	48d1                	li	a7,20
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41e:	48a5                	li	a7,9
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <dup>:
.global dup
dup:
 li a7, SYS_dup
 426:	48a9                	li	a7,10
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42e:	48ad                	li	a7,11
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 436:	48b1                	li	a7,12
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <pause>:
.global pause
pause:
 li a7, SYS_pause
 43e:	48b5                	li	a7,13
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 446:	48b9                	li	a7,14
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
 44e:	48d9                	li	a7,22
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 456:	1101                	addi	sp,sp,-32
 458:	ec06                	sd	ra,24(sp)
 45a:	e822                	sd	s0,16(sp)
 45c:	1000                	addi	s0,sp,32
 45e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 462:	4605                	li	a2,1
 464:	fef40593          	addi	a1,s0,-17
 468:	f67ff0ef          	jal	3ce <write>
}
 46c:	60e2                	ld	ra,24(sp)
 46e:	6442                	ld	s0,16(sp)
 470:	6105                	addi	sp,sp,32
 472:	8082                	ret

0000000000000474 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 474:	715d                	addi	sp,sp,-80
 476:	e486                	sd	ra,72(sp)
 478:	e0a2                	sd	s0,64(sp)
 47a:	f84a                	sd	s2,48(sp)
 47c:	f44e                	sd	s3,40(sp)
 47e:	0880                	addi	s0,sp,80
 480:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 482:	cac1                	beqz	a3,512 <printint+0x9e>
 484:	0805d763          	bgez	a1,512 <printint+0x9e>
    neg = 1;
    x = -xx;
 488:	40b005bb          	negw	a1,a1
    neg = 1;
 48c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 48e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 492:	86ce                	mv	a3,s3
  i = 0;
 494:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 496:	00000817          	auipc	a6,0x0
 49a:	56a80813          	addi	a6,a6,1386 # a00 <digits>
 49e:	88ba                	mv	a7,a4
 4a0:	0017051b          	addiw	a0,a4,1
 4a4:	872a                	mv	a4,a0
 4a6:	02c5f7bb          	remuw	a5,a1,a2
 4aa:	1782                	slli	a5,a5,0x20
 4ac:	9381                	srli	a5,a5,0x20
 4ae:	97c2                	add	a5,a5,a6
 4b0:	0007c783          	lbu	a5,0(a5)
 4b4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b8:	87ae                	mv	a5,a1
 4ba:	02c5d5bb          	divuw	a1,a1,a2
 4be:	0685                	addi	a3,a3,1
 4c0:	fcc7ffe3          	bgeu	a5,a2,49e <printint+0x2a>
  if(neg)
 4c4:	00030c63          	beqz	t1,4dc <printint+0x68>
    buf[i++] = '-';
 4c8:	fd050793          	addi	a5,a0,-48
 4cc:	00878533          	add	a0,a5,s0
 4d0:	02d00793          	li	a5,45
 4d4:	fef50423          	sb	a5,-24(a0)
 4d8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4dc:	02e05563          	blez	a4,506 <printint+0x92>
 4e0:	fc26                	sd	s1,56(sp)
 4e2:	377d                	addiw	a4,a4,-1
 4e4:	00e984b3          	add	s1,s3,a4
 4e8:	19fd                	addi	s3,s3,-1
 4ea:	99ba                	add	s3,s3,a4
 4ec:	1702                	slli	a4,a4,0x20
 4ee:	9301                	srli	a4,a4,0x20
 4f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f4:	0004c583          	lbu	a1,0(s1)
 4f8:	854a                	mv	a0,s2
 4fa:	f5dff0ef          	jal	456 <putc>
  while(--i >= 0)
 4fe:	14fd                	addi	s1,s1,-1
 500:	ff349ae3          	bne	s1,s3,4f4 <printint+0x80>
 504:	74e2                	ld	s1,56(sp)
}
 506:	60a6                	ld	ra,72(sp)
 508:	6406                	ld	s0,64(sp)
 50a:	7942                	ld	s2,48(sp)
 50c:	79a2                	ld	s3,40(sp)
 50e:	6161                	addi	sp,sp,80
 510:	8082                	ret
    x = xx;
 512:	2581                	sext.w	a1,a1
  neg = 0;
 514:	4301                	li	t1,0
 516:	bfa5                	j	48e <printint+0x1a>

0000000000000518 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 518:	711d                	addi	sp,sp,-96
 51a:	ec86                	sd	ra,88(sp)
 51c:	e8a2                	sd	s0,80(sp)
 51e:	e4a6                	sd	s1,72(sp)
 520:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 522:	0005c483          	lbu	s1,0(a1)
 526:	22048363          	beqz	s1,74c <vprintf+0x234>
 52a:	e0ca                	sd	s2,64(sp)
 52c:	fc4e                	sd	s3,56(sp)
 52e:	f852                	sd	s4,48(sp)
 530:	f456                	sd	s5,40(sp)
 532:	f05a                	sd	s6,32(sp)
 534:	ec5e                	sd	s7,24(sp)
 536:	e862                	sd	s8,16(sp)
 538:	8b2a                	mv	s6,a0
 53a:	8a2e                	mv	s4,a1
 53c:	8bb2                	mv	s7,a2
  state = 0;
 53e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 540:	4901                	li	s2,0
 542:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 544:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 548:	06400c13          	li	s8,100
 54c:	a00d                	j	56e <vprintf+0x56>
        putc(fd, c0);
 54e:	85a6                	mv	a1,s1
 550:	855a                	mv	a0,s6
 552:	f05ff0ef          	jal	456 <putc>
 556:	a019                	j	55c <vprintf+0x44>
    } else if(state == '%'){
 558:	03598363          	beq	s3,s5,57e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 55c:	0019079b          	addiw	a5,s2,1
 560:	893e                	mv	s2,a5
 562:	873e                	mv	a4,a5
 564:	97d2                	add	a5,a5,s4
 566:	0007c483          	lbu	s1,0(a5)
 56a:	1c048a63          	beqz	s1,73e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 56e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 572:	fe0993e3          	bnez	s3,558 <vprintf+0x40>
      if(c0 == '%'){
 576:	fd579ce3          	bne	a5,s5,54e <vprintf+0x36>
        state = '%';
 57a:	89be                	mv	s3,a5
 57c:	b7c5                	j	55c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 57e:	00ea06b3          	add	a3,s4,a4
 582:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 586:	1c060863          	beqz	a2,756 <vprintf+0x23e>
      if(c0 == 'd'){
 58a:	03878763          	beq	a5,s8,5b8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 58e:	f9478693          	addi	a3,a5,-108
 592:	0016b693          	seqz	a3,a3
 596:	f9c60593          	addi	a1,a2,-100
 59a:	e99d                	bnez	a1,5d0 <vprintf+0xb8>
 59c:	ca95                	beqz	a3,5d0 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	008b8493          	addi	s1,s7,8
 5a2:	4685                	li	a3,1
 5a4:	4629                	li	a2,10
 5a6:	000bb583          	ld	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	ec9ff0ef          	jal	474 <printint>
        i += 1;
 5b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b75d                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4685                	li	a3,1
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	eafff0ef          	jal	474 <printint>
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b779                	j	55c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5d0:	9752                	add	a4,a4,s4
 5d2:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	f9460713          	addi	a4,a2,-108
 5da:	00173713          	seqz	a4,a4
 5de:	8f75                	and	a4,a4,a3
 5e0:	f9c58513          	addi	a0,a1,-100
 5e4:	18051363          	bnez	a0,76a <vprintf+0x252>
 5e8:	18070163          	beqz	a4,76a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4685                	li	a3,1
 5f2:	4629                	li	a2,10
 5f4:	000bb583          	ld	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	e7bff0ef          	jal	474 <printint>
        i += 2;
 5fe:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	bfa1                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000be583          	lwu	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	e61ff0ef          	jal	474 <printint>
 618:	8ba6                	mv	s7,s1
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b781                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b8493          	addi	s1,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	e49ff0ef          	jal	474 <printint>
        i += 1;
 630:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	b71d                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4629                	li	a2,10
 640:	000bb583          	ld	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	e2fff0ef          	jal	474 <printint>
        i += 2;
 64a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
        i += 2;
 650:	b731                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 652:	008b8493          	addi	s1,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000be583          	lwu	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	e15ff0ef          	jal	474 <printint>
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
 668:	bdd5                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66a:	008b8493          	addi	s1,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000bb583          	ld	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	dfdff0ef          	jal	474 <printint>
        i += 1;
 67c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
 682:	bde9                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	008b8493          	addi	s1,s7,8
 688:	4681                	li	a3,0
 68a:	4641                	li	a2,16
 68c:	000bb583          	ld	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	de3ff0ef          	jal	474 <printint>
        i += 2;
 696:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
        i += 2;
 69c:	b5c1                	j	55c <vprintf+0x44>
 69e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a0:	008b8793          	addi	a5,s7,8
 6a4:	8cbe                	mv	s9,a5
 6a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6aa:	03000593          	li	a1,48
 6ae:	855a                	mv	a0,s6
 6b0:	da7ff0ef          	jal	456 <putc>
  putc(fd, 'x');
 6b4:	07800593          	li	a1,120
 6b8:	855a                	mv	a0,s6
 6ba:	d9dff0ef          	jal	456 <putc>
 6be:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c0:	00000b97          	auipc	s7,0x0
 6c4:	340b8b93          	addi	s7,s7,832 # a00 <digits>
 6c8:	03c9d793          	srli	a5,s3,0x3c
 6cc:	97de                	add	a5,a5,s7
 6ce:	0007c583          	lbu	a1,0(a5)
 6d2:	855a                	mv	a0,s6
 6d4:	d83ff0ef          	jal	456 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d8:	0992                	slli	s3,s3,0x4
 6da:	34fd                	addiw	s1,s1,-1
 6dc:	f4f5                	bnez	s1,6c8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6de:	8be6                	mv	s7,s9
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	6ca2                	ld	s9,8(sp)
 6e4:	bda5                	j	55c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6e6:	008b8493          	addi	s1,s7,8
 6ea:	000bc583          	lbu	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	d67ff0ef          	jal	456 <putc>
 6f4:	8ba6                	mv	s7,s1
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b595                	j	55c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6fa:	008b8993          	addi	s3,s7,8
 6fe:	000bb483          	ld	s1,0(s7)
 702:	cc91                	beqz	s1,71e <vprintf+0x206>
        for(; *s; s++)
 704:	0004c583          	lbu	a1,0(s1)
 708:	c985                	beqz	a1,738 <vprintf+0x220>
          putc(fd, *s);
 70a:	855a                	mv	a0,s6
 70c:	d4bff0ef          	jal	456 <putc>
        for(; *s; s++)
 710:	0485                	addi	s1,s1,1
 712:	0004c583          	lbu	a1,0(s1)
 716:	f9f5                	bnez	a1,70a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 718:	8bce                	mv	s7,s3
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b581                	j	55c <vprintf+0x44>
          s = "(null)";
 71e:	00000497          	auipc	s1,0x0
 722:	2da48493          	addi	s1,s1,730 # 9f8 <malloc+0x13e>
        for(; *s; s++)
 726:	02800593          	li	a1,40
 72a:	b7c5                	j	70a <vprintf+0x1f2>
        putc(fd, '%');
 72c:	85be                	mv	a1,a5
 72e:	855a                	mv	a0,s6
 730:	d27ff0ef          	jal	456 <putc>
      state = 0;
 734:	4981                	li	s3,0
 736:	b51d                	j	55c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 738:	8bce                	mv	s7,s3
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b505                	j	55c <vprintf+0x44>
 73e:	6906                	ld	s2,64(sp)
 740:	79e2                	ld	s3,56(sp)
 742:	7a42                	ld	s4,48(sp)
 744:	7aa2                	ld	s5,40(sp)
 746:	7b02                	ld	s6,32(sp)
 748:	6be2                	ld	s7,24(sp)
 74a:	6c42                	ld	s8,16(sp)
    }
  }
}
 74c:	60e6                	ld	ra,88(sp)
 74e:	6446                	ld	s0,80(sp)
 750:	64a6                	ld	s1,72(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret
      if(c0 == 'd'){
 756:	06400713          	li	a4,100
 75a:	e4e78fe3          	beq	a5,a4,5b8 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 75e:	f9478693          	addi	a3,a5,-108
 762:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 766:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 768:	4701                	li	a4,0
      } else if(c0 == 'u'){
 76a:	07500513          	li	a0,117
 76e:	e8a78ce3          	beq	a5,a0,606 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 772:	f8b60513          	addi	a0,a2,-117
 776:	e119                	bnez	a0,77c <vprintf+0x264>
 778:	ea0693e3          	bnez	a3,61e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 77c:	f8b58513          	addi	a0,a1,-117
 780:	e119                	bnez	a0,786 <vprintf+0x26e>
 782:	ea071be3          	bnez	a4,638 <vprintf+0x120>
      } else if(c0 == 'x'){
 786:	07800513          	li	a0,120
 78a:	eca784e3          	beq	a5,a0,652 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 78e:	f8860613          	addi	a2,a2,-120
 792:	e219                	bnez	a2,798 <vprintf+0x280>
 794:	ec069be3          	bnez	a3,66a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 798:	f8858593          	addi	a1,a1,-120
 79c:	e199                	bnez	a1,7a2 <vprintf+0x28a>
 79e:	ee0713e3          	bnez	a4,684 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7a2:	07000713          	li	a4,112
 7a6:	eee78ce3          	beq	a5,a4,69e <vprintf+0x186>
      } else if(c0 == 'c'){
 7aa:	06300713          	li	a4,99
 7ae:	f2e78ce3          	beq	a5,a4,6e6 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7b2:	07300713          	li	a4,115
 7b6:	f4e782e3          	beq	a5,a4,6fa <vprintf+0x1e2>
      } else if(c0 == '%'){
 7ba:	02500713          	li	a4,37
 7be:	f6e787e3          	beq	a5,a4,72c <vprintf+0x214>
        putc(fd, '%');
 7c2:	02500593          	li	a1,37
 7c6:	855a                	mv	a0,s6
 7c8:	c8fff0ef          	jal	456 <putc>
        putc(fd, c0);
 7cc:	85a6                	mv	a1,s1
 7ce:	855a                	mv	a0,s6
 7d0:	c87ff0ef          	jal	456 <putc>
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b359                	j	55c <vprintf+0x44>

00000000000007d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d8:	715d                	addi	sp,sp,-80
 7da:	ec06                	sd	ra,24(sp)
 7dc:	e822                	sd	s0,16(sp)
 7de:	1000                	addi	s0,sp,32
 7e0:	e010                	sd	a2,0(s0)
 7e2:	e414                	sd	a3,8(s0)
 7e4:	e818                	sd	a4,16(s0)
 7e6:	ec1c                	sd	a5,24(s0)
 7e8:	03043023          	sd	a6,32(s0)
 7ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	8622                	mv	a2,s0
 7f2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f6:	d23ff0ef          	jal	518 <vprintf>
}
 7fa:	60e2                	ld	ra,24(sp)
 7fc:	6442                	ld	s0,16(sp)
 7fe:	6161                	addi	sp,sp,80
 800:	8082                	ret

0000000000000802 <printf>:

void
printf(const char *fmt, ...)
{
 802:	711d                	addi	sp,sp,-96
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	e40c                	sd	a1,8(s0)
 80c:	e810                	sd	a2,16(s0)
 80e:	ec14                	sd	a3,24(s0)
 810:	f018                	sd	a4,32(s0)
 812:	f41c                	sd	a5,40(s0)
 814:	03043823          	sd	a6,48(s0)
 818:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81c:	00840613          	addi	a2,s0,8
 820:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 824:	85aa                	mv	a1,a0
 826:	4505                	li	a0,1
 828:	cf1ff0ef          	jal	518 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6125                	addi	sp,sp,96
 832:	8082                	ret

0000000000000834 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 834:	1141                	addi	sp,sp,-16
 836:	e406                	sd	ra,8(sp)
 838:	e022                	sd	s0,0(sp)
 83a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	00000797          	auipc	a5,0x0
 844:	7c07b783          	ld	a5,1984(a5) # 1000 <freep>
 848:	a039                	j	856 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	6398                	ld	a4,0(a5)
 84c:	00e7e463          	bltu	a5,a4,854 <free+0x20>
 850:	00e6ea63          	bltu	a3,a4,864 <free+0x30>
{
 854:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	fed7fae3          	bgeu	a5,a3,84a <free+0x16>
 85a:	6398                	ld	a4,0(a5)
 85c:	00e6e463          	bltu	a3,a4,864 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	fee7eae3          	bltu	a5,a4,854 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 864:	ff852583          	lw	a1,-8(a0)
 868:	6390                	ld	a2,0(a5)
 86a:	02059813          	slli	a6,a1,0x20
 86e:	01c85713          	srli	a4,a6,0x1c
 872:	9736                	add	a4,a4,a3
 874:	02e60563          	beq	a2,a4,89e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 878:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 87c:	4790                	lw	a2,8(a5)
 87e:	02061593          	slli	a1,a2,0x20
 882:	01c5d713          	srli	a4,a1,0x1c
 886:	973e                	add	a4,a4,a5
 888:	02e68263          	beq	a3,a4,8ac <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 88c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88e:	00000717          	auipc	a4,0x0
 892:	76f73923          	sd	a5,1906(a4) # 1000 <freep>
}
 896:	60a2                	ld	ra,8(sp)
 898:	6402                	ld	s0,0(sp)
 89a:	0141                	addi	sp,sp,16
 89c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 89e:	4618                	lw	a4,8(a2)
 8a0:	9f2d                	addw	a4,a4,a1
 8a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	6310                	ld	a2,0(a4)
 8aa:	b7f9                	j	878 <free+0x44>
    p->s.size += bp->s.size;
 8ac:	ff852703          	lw	a4,-8(a0)
 8b0:	9f31                	addw	a4,a4,a2
 8b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b4:	ff053683          	ld	a3,-16(a0)
 8b8:	bfd1                	j	88c <free+0x58>

00000000000008ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ba:	7139                	addi	sp,sp,-64
 8bc:	fc06                	sd	ra,56(sp)
 8be:	f822                	sd	s0,48(sp)
 8c0:	f04a                	sd	s2,32(sp)
 8c2:	ec4e                	sd	s3,24(sp)
 8c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c6:	02051993          	slli	s3,a0,0x20
 8ca:	0209d993          	srli	s3,s3,0x20
 8ce:	09bd                	addi	s3,s3,15
 8d0:	0049d993          	srli	s3,s3,0x4
 8d4:	2985                	addiw	s3,s3,1
 8d6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8d8:	00000517          	auipc	a0,0x0
 8dc:	72853503          	ld	a0,1832(a0) # 1000 <freep>
 8e0:	c905                	beqz	a0,910 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	09377663          	bgeu	a4,s3,972 <malloc+0xb8>
 8ea:	f426                	sd	s1,40(sp)
 8ec:	e852                	sd	s4,16(sp)
 8ee:	e456                	sd	s5,8(sp)
 8f0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f2:	8a4e                	mv	s4,s3
 8f4:	6705                	lui	a4,0x1
 8f6:	00e9f363          	bgeu	s3,a4,8fc <malloc+0x42>
 8fa:	6a05                	lui	s4,0x1
 8fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 900:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 904:	00000497          	auipc	s1,0x0
 908:	6fc48493          	addi	s1,s1,1788 # 1000 <freep>
  if(p == SBRK_ERROR)
 90c:	5afd                	li	s5,-1
 90e:	a83d                	j	94c <malloc+0x92>
 910:	f426                	sd	s1,40(sp)
 912:	e852                	sd	s4,16(sp)
 914:	e456                	sd	s5,8(sp)
 916:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 918:	00001797          	auipc	a5,0x1
 91c:	8f878793          	addi	a5,a5,-1800 # 1210 <base>
 920:	00000717          	auipc	a4,0x0
 924:	6ef73023          	sd	a5,1760(a4) # 1000 <freep>
 928:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92e:	b7d1                	j	8f2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	e118                	sd	a4,0(a0)
 934:	a899                	j	98a <malloc+0xd0>
  hp->s.size = nu;
 936:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93a:	0541                	addi	a0,a0,16
 93c:	ef9ff0ef          	jal	834 <free>
  return freep;
 940:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 942:	c125                	beqz	a0,9a2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 944:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 946:	4798                	lw	a4,8(a5)
 948:	03277163          	bgeu	a4,s2,96a <malloc+0xb0>
    if(p == freep)
 94c:	6098                	ld	a4,0(s1)
 94e:	853e                	mv	a0,a5
 950:	fef71ae3          	bne	a4,a5,944 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 954:	8552                	mv	a0,s4
 956:	a25ff0ef          	jal	37a <sbrk>
  if(p == SBRK_ERROR)
 95a:	fd551ee3          	bne	a0,s5,936 <malloc+0x7c>
        return 0;
 95e:	4501                	li	a0,0
 960:	74a2                	ld	s1,40(sp)
 962:	6a42                	ld	s4,16(sp)
 964:	6aa2                	ld	s5,8(sp)
 966:	6b02                	ld	s6,0(sp)
 968:	a03d                	j	996 <malloc+0xdc>
 96a:	74a2                	ld	s1,40(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 972:	fae90fe3          	beq	s2,a4,930 <malloc+0x76>
        p->s.size -= nunits;
 976:	4137073b          	subw	a4,a4,s3
 97a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97c:	02071693          	slli	a3,a4,0x20
 980:	01c6d713          	srli	a4,a3,0x1c
 984:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 986:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98a:	00000717          	auipc	a4,0x0
 98e:	66a73b23          	sd	a0,1654(a4) # 1000 <freep>
      return (void*)(p + 1);
 992:	01078513          	addi	a0,a5,16
  }
}
 996:	70e2                	ld	ra,56(sp)
 998:	7442                	ld	s0,48(sp)
 99a:	7902                	ld	s2,32(sp)
 99c:	69e2                	ld	s3,24(sp)
 99e:	6121                	addi	sp,sp,64
 9a0:	8082                	ret
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
 9aa:	b7f5                	j	996 <malloc+0xdc>
