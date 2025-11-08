
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2ae000ef          	jal	2ba <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	286000ef          	jal	2ba <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	60e2                	ld	ra,24(sp)
  42:	6442                	ld	s0,16(sp)
  44:	64a2                	ld	s1,8(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret
  4a:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
  4c:	8526                	mv	a0,s1
  4e:	26c000ef          	jal	2ba <strlen>
  52:	862a                	mv	a2,a0
  54:	85a6                	mv	a1,s1
  56:	00001517          	auipc	a0,0x1
  5a:	fba50513          	addi	a0,a0,-70 # 1010 <buf.0>
  5e:	3d4000ef          	jal	432 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  62:	8526                	mv	a0,s1
  64:	256000ef          	jal	2ba <strlen>
  68:	892a                	mv	s2,a0
  6a:	8526                	mv	a0,s1
  6c:	24e000ef          	jal	2ba <strlen>
  70:	02091793          	slli	a5,s2,0x20
  74:	9381                	srli	a5,a5,0x20
  76:	4639                	li	a2,14
  78:	9e09                	subw	a2,a2,a0
  7a:	02000593          	li	a1,32
  7e:	00001517          	auipc	a0,0x1
  82:	f9250513          	addi	a0,a0,-110 # 1010 <buf.0>
  86:	953e                	add	a0,a0,a5
  88:	25e000ef          	jal	2e6 <memset>
  return buf;
  8c:	00001497          	auipc	s1,0x1
  90:	f8448493          	addi	s1,s1,-124 # 1010 <buf.0>
  94:	6902                	ld	s2,0(sp)
  96:	b765                	j	3e <fmtname+0x3e>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	da010113          	addi	sp,sp,-608
  9c:	24113c23          	sd	ra,600(sp)
  a0:	24813823          	sd	s0,592(sp)
  a4:	25213023          	sd	s2,576(sp)
  a8:	1480                	addi	s0,sp,608
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	4a2000ef          	jal	550 <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913423          	sd	s1,584(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	da840593          	addi	a1,s0,-600
  c0:	4a8000ef          	jal	568 <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	db041783          	lh	a5,-592(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	db842703          	lw	a4,-584(s0)
  e8:	dac42683          	lw	a3,-596(s0)
  ec:	db041603          	lh	a2,-592(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a5050513          	addi	a0,a0,-1456 # b40 <malloc+0x12c>
  f8:	065000ef          	jal	95c <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	43a000ef          	jal	538 <close>
 102:	24813483          	ld	s1,584(sp)
}
 106:	25813083          	ld	ra,600(sp)
 10a:	25013403          	ld	s0,592(sp)
 10e:	24013903          	ld	s2,576(sp)
 112:	26010113          	addi	sp,sp,608
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	9f658593          	addi	a1,a1,-1546 # b10 <malloc+0xfc>
 122:	4509                	li	a0,2
 124:	00f000ef          	jal	932 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	9fc58593          	addi	a1,a1,-1540 # b28 <malloc+0x114>
 134:	4509                	li	a0,2
 136:	7fc000ef          	jal	932 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	3fc000ef          	jal	538 <close>
    return;
 140:	24813483          	ld	s1,584(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	172000ef          	jal	2ba <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	9fa50513          	addi	a0,a0,-1542 # b50 <malloc+0x13c>
 15e:	7fe000ef          	jal	95c <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
 168:	85ca                	mv	a1,s2
 16a:	dd040513          	addi	a0,s0,-560
 16e:	0fc000ef          	jal	26a <strcpy>
    p = buf+strlen(buf);
 172:	dd040513          	addi	a0,s0,-560
 176:	144000ef          	jal	2ba <strlen>
 17a:	1502                	slli	a0,a0,0x20
 17c:	9101                	srli	a0,a0,0x20
 17e:	dd040793          	addi	a5,s0,-560
 182:	00a78733          	add	a4,a5,a0
 186:	893a                	mv	s2,a4
    *p++ = '/';
 188:	00170793          	addi	a5,a4,1
 18c:	89be                	mv	s3,a5
 18e:	02f00793          	li	a5,47
 192:	00f70023          	sb	a5,0(a4)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 196:	a809                	j	1a8 <ls+0x110>
        printf("ls: cannot stat %s\n", buf);
 198:	dd040593          	addi	a1,s0,-560
 19c:	00001517          	auipc	a0,0x1
 1a0:	98c50513          	addi	a0,a0,-1652 # b28 <malloc+0x114>
 1a4:	7b8000ef          	jal	95c <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a8:	4641                	li	a2,16
 1aa:	dc040593          	addi	a1,s0,-576
 1ae:	8526                	mv	a0,s1
 1b0:	378000ef          	jal	528 <read>
 1b4:	47c1                	li	a5,16
 1b6:	04f51763          	bne	a0,a5,204 <ls+0x16c>
      if(de.inum == 0)
 1ba:	dc045783          	lhu	a5,-576(s0)
 1be:	d7ed                	beqz	a5,1a8 <ls+0x110>
      memmove(p, de.name, DIRSIZ);
 1c0:	4639                	li	a2,14
 1c2:	dc240593          	addi	a1,s0,-574
 1c6:	854e                	mv	a0,s3
 1c8:	26a000ef          	jal	432 <memmove>
      p[DIRSIZ] = 0;
 1cc:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1d0:	da840593          	addi	a1,s0,-600
 1d4:	dd040513          	addi	a0,s0,-560
 1d8:	1d2000ef          	jal	3aa <stat>
 1dc:	fa054ee3          	bltz	a0,198 <ls+0x100>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1e0:	dd040513          	addi	a0,s0,-560
 1e4:	e1dff0ef          	jal	0 <fmtname>
 1e8:	85aa                	mv	a1,a0
 1ea:	db842703          	lw	a4,-584(s0)
 1ee:	dac42683          	lw	a3,-596(s0)
 1f2:	db041603          	lh	a2,-592(s0)
 1f6:	00001517          	auipc	a0,0x1
 1fa:	94a50513          	addi	a0,a0,-1718 # b40 <malloc+0x12c>
 1fe:	75e000ef          	jal	95c <printf>
 202:	b75d                	j	1a8 <ls+0x110>
 204:	23813983          	ld	s3,568(sp)
 208:	bdd5                	j	fc <ls+0x64>

000000000000020a <main>:

int
main(int argc, char *argv[])
{
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 212:	4785                	li	a5,1
 214:	02a7d763          	bge	a5,a0,242 <main+0x38>
 218:	e426                	sd	s1,8(sp)
 21a:	e04a                	sd	s2,0(sp)
 21c:	00858493          	addi	s1,a1,8
 220:	ffe5091b          	addiw	s2,a0,-2
 224:	02091793          	slli	a5,s2,0x20
 228:	01d7d913          	srli	s2,a5,0x1d
 22c:	05c1                	addi	a1,a1,16
 22e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 230:	6088                	ld	a0,0(s1)
 232:	e67ff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 236:	04a1                	addi	s1,s1,8
 238:	ff249ce3          	bne	s1,s2,230 <main+0x26>
  exit(0);
 23c:	4501                	li	a0,0
 23e:	2d2000ef          	jal	510 <exit>
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
    ls(".");
 246:	00001517          	auipc	a0,0x1
 24a:	92250513          	addi	a0,a0,-1758 # b68 <malloc+0x154>
 24e:	e4bff0ef          	jal	98 <ls>
    exit(0);
 252:	4501                	li	a0,0
 254:	2bc000ef          	jal	510 <exit>

0000000000000258 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 260:	fabff0ef          	jal	20a <main>
  exit(0);
 264:	4501                	li	a0,0
 266:	2aa000ef          	jal	510 <exit>

000000000000026a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e406                	sd	ra,8(sp)
 26e:	e022                	sd	s0,0(sp)
 270:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 272:	87aa                	mv	a5,a0
 274:	0585                	addi	a1,a1,1
 276:	0785                	addi	a5,a5,1
 278:	fff5c703          	lbu	a4,-1(a1)
 27c:	fee78fa3          	sb	a4,-1(a5)
 280:	fb75                	bnez	a4,274 <strcpy+0xa>
    ;
  return os;
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret

000000000000028a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 292:	00054783          	lbu	a5,0(a0)
 296:	cb91                	beqz	a5,2aa <strcmp+0x20>
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00f71763          	bne	a4,a5,2aa <strcmp+0x20>
    p++, q++;
 2a0:	0505                	addi	a0,a0,1
 2a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	fbe5                	bnez	a5,298 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2aa:	0005c503          	lbu	a0,0(a1)
}
 2ae:	40a7853b          	subw	a0,a5,a0
 2b2:	60a2                	ld	ra,8(sp)
 2b4:	6402                	ld	s0,0(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strlen>:

uint
strlen(const char *s)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c2:	00054783          	lbu	a5,0(a0)
 2c6:	cf91                	beqz	a5,2e2 <strlen+0x28>
 2c8:	00150793          	addi	a5,a0,1
 2cc:	86be                	mv	a3,a5
 2ce:	0785                	addi	a5,a5,1
 2d0:	fff7c703          	lbu	a4,-1(a5)
 2d4:	ff65                	bnez	a4,2cc <strlen+0x12>
 2d6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  for(n = 0; s[n]; n++)
 2e2:	4501                	li	a0,0
 2e4:	bfdd                	j	2da <strlen+0x20>

00000000000002e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ee:	ca19                	beqz	a2,304 <memset+0x1e>
 2f0:	87aa                	mv	a5,a0
 2f2:	1602                	slli	a2,a2,0x20
 2f4:	9201                	srli	a2,a2,0x20
 2f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fe:	0785                	addi	a5,a5,1
 300:	fee79de3          	bne	a5,a4,2fa <memset+0x14>
  }
  return dst;
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <strchr>:

char*
strchr(const char *s, char c)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  for(; *s; s++)
 314:	00054783          	lbu	a5,0(a0)
 318:	cf81                	beqz	a5,330 <strchr+0x24>
    if(*s == c)
 31a:	00f58763          	beq	a1,a5,328 <strchr+0x1c>
  for(; *s; s++)
 31e:	0505                	addi	a0,a0,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbfd                	bnez	a5,31a <strchr+0xe>
      return (char*)s;
  return 0;
 326:	4501                	li	a0,0
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfdd                	j	328 <strchr+0x1c>

0000000000000334 <gets>:

char*
gets(char *buf, int max)
{
 334:	711d                	addi	sp,sp,-96
 336:	ec86                	sd	ra,88(sp)
 338:	e8a2                	sd	s0,80(sp)
 33a:	e4a6                	sd	s1,72(sp)
 33c:	e0ca                	sd	s2,64(sp)
 33e:	fc4e                	sd	s3,56(sp)
 340:	f852                	sd	s4,48(sp)
 342:	f456                	sd	s5,40(sp)
 344:	f05a                	sd	s6,32(sp)
 346:	ec5e                	sd	s7,24(sp)
 348:	e862                	sd	s8,16(sp)
 34a:	1080                	addi	s0,sp,96
 34c:	8baa                	mv	s7,a0
 34e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 350:	892a                	mv	s2,a0
 352:	4481                	li	s1,0
    cc = read(0, &c, 1);
 354:	faf40b13          	addi	s6,s0,-81
 358:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 35a:	8c26                	mv	s8,s1
 35c:	0014899b          	addiw	s3,s1,1
 360:	84ce                	mv	s1,s3
 362:	0349d463          	bge	s3,s4,38a <gets+0x56>
    cc = read(0, &c, 1);
 366:	8656                	mv	a2,s5
 368:	85da                	mv	a1,s6
 36a:	4501                	li	a0,0
 36c:	1bc000ef          	jal	528 <read>
    if(cc < 1)
 370:	00a05d63          	blez	a0,38a <gets+0x56>
      break;
    buf[i++] = c;
 374:	faf44783          	lbu	a5,-81(s0)
 378:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37c:	0905                	addi	s2,s2,1
 37e:	ff678713          	addi	a4,a5,-10
 382:	c319                	beqz	a4,388 <gets+0x54>
 384:	17cd                	addi	a5,a5,-13
 386:	fbf1                	bnez	a5,35a <gets+0x26>
    buf[i++] = c;
 388:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38a:	9c5e                	add	s8,s8,s7
 38c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 390:	855e                	mv	a0,s7
 392:	60e6                	ld	ra,88(sp)
 394:	6446                	ld	s0,80(sp)
 396:	64a6                	ld	s1,72(sp)
 398:	6906                	ld	s2,64(sp)
 39a:	79e2                	ld	s3,56(sp)
 39c:	7a42                	ld	s4,48(sp)
 39e:	7aa2                	ld	s5,40(sp)
 3a0:	7b02                	ld	s6,32(sp)
 3a2:	6be2                	ld	s7,24(sp)
 3a4:	6c42                	ld	s8,16(sp)
 3a6:	6125                	addi	sp,sp,96
 3a8:	8082                	ret

00000000000003aa <stat>:

int
stat(const char *n, struct stat *st)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	e04a                	sd	s2,0(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b6:	4581                	li	a1,0
 3b8:	198000ef          	jal	550 <open>
  if(fd < 0)
 3bc:	02054263          	bltz	a0,3e0 <stat+0x36>
 3c0:	e426                	sd	s1,8(sp)
 3c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c4:	85ca                	mv	a1,s2
 3c6:	1a2000ef          	jal	568 <fstat>
 3ca:	892a                	mv	s2,a0
  close(fd);
 3cc:	8526                	mv	a0,s1
 3ce:	16a000ef          	jal	538 <close>
  return r;
 3d2:	64a2                	ld	s1,8(sp)
}
 3d4:	854a                	mv	a0,s2
 3d6:	60e2                	ld	ra,24(sp)
 3d8:	6442                	ld	s0,16(sp)
 3da:	6902                	ld	s2,0(sp)
 3dc:	6105                	addi	sp,sp,32
 3de:	8082                	ret
    return -1;
 3e0:	57fd                	li	a5,-1
 3e2:	893e                	mv	s2,a5
 3e4:	bfc5                	j	3d4 <stat+0x2a>

00000000000003e6 <atoi>:

int
atoi(const char *s)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e406                	sd	ra,8(sp)
 3ea:	e022                	sd	s0,0(sp)
 3ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ee:	00054683          	lbu	a3,0(a0)
 3f2:	fd06879b          	addiw	a5,a3,-48
 3f6:	0ff7f793          	zext.b	a5,a5
 3fa:	4625                	li	a2,9
 3fc:	02f66963          	bltu	a2,a5,42e <atoi+0x48>
 400:	872a                	mv	a4,a0
  n = 0;
 402:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 404:	0705                	addi	a4,a4,1
 406:	0025179b          	slliw	a5,a0,0x2
 40a:	9fa9                	addw	a5,a5,a0
 40c:	0017979b          	slliw	a5,a5,0x1
 410:	9fb5                	addw	a5,a5,a3
 412:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 416:	00074683          	lbu	a3,0(a4)
 41a:	fd06879b          	addiw	a5,a3,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	fef671e3          	bgeu	a2,a5,404 <atoi+0x1e>
  return n;
}
 426:	60a2                	ld	ra,8(sp)
 428:	6402                	ld	s0,0(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
  n = 0;
 42e:	4501                	li	a0,0
 430:	bfdd                	j	426 <atoi+0x40>

0000000000000432 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43a:	02b57563          	bgeu	a0,a1,464 <memmove+0x32>
    while(n-- > 0)
 43e:	00c05f63          	blez	a2,45c <memmove+0x2a>
 442:	1602                	slli	a2,a2,0x20
 444:	9201                	srli	a2,a2,0x20
 446:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44a:	872a                	mv	a4,a0
      *dst++ = *src++;
 44c:	0585                	addi	a1,a1,1
 44e:	0705                	addi	a4,a4,1
 450:	fff5c683          	lbu	a3,-1(a1)
 454:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 458:	fee79ae3          	bne	a5,a4,44c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45c:	60a2                	ld	ra,8(sp)
 45e:	6402                	ld	s0,0(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret
    while(n-- > 0)
 464:	fec05ce3          	blez	a2,45c <memmove+0x2a>
    dst += n;
 468:	00c50733          	add	a4,a0,a2
    src += n;
 46c:	95b2                	add	a1,a1,a2
 46e:	fff6079b          	addiw	a5,a2,-1
 472:	1782                	slli	a5,a5,0x20
 474:	9381                	srli	a5,a5,0x20
 476:	fff7c793          	not	a5,a5
 47a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47c:	15fd                	addi	a1,a1,-1
 47e:	177d                	addi	a4,a4,-1
 480:	0005c683          	lbu	a3,0(a1)
 484:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 488:	fef71ae3          	bne	a4,a5,47c <memmove+0x4a>
 48c:	bfc1                	j	45c <memmove+0x2a>

000000000000048e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e406                	sd	ra,8(sp)
 492:	e022                	sd	s0,0(sp)
 494:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 496:	c61d                	beqz	a2,4c4 <memcmp+0x36>
 498:	1602                	slli	a2,a2,0x20
 49a:	9201                	srli	a2,a2,0x20
 49c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a0:	00054783          	lbu	a5,0(a0)
 4a4:	0005c703          	lbu	a4,0(a1)
 4a8:	00e79863          	bne	a5,a4,4b8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4ac:	0505                	addi	a0,a0,1
    p2++;
 4ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b0:	fed518e3          	bne	a0,a3,4a0 <memcmp+0x12>
  }
  return 0;
 4b4:	4501                	li	a0,0
 4b6:	a019                	j	4bc <memcmp+0x2e>
      return *p1 - *p2;
 4b8:	40e7853b          	subw	a0,a5,a4
}
 4bc:	60a2                	ld	ra,8(sp)
 4be:	6402                	ld	s0,0(sp)
 4c0:	0141                	addi	sp,sp,16
 4c2:	8082                	ret
  return 0;
 4c4:	4501                	li	a0,0
 4c6:	bfdd                	j	4bc <memcmp+0x2e>

00000000000004c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c8:	1141                	addi	sp,sp,-16
 4ca:	e406                	sd	ra,8(sp)
 4cc:	e022                	sd	s0,0(sp)
 4ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d0:	f63ff0ef          	jal	432 <memmove>
}
 4d4:	60a2                	ld	ra,8(sp)
 4d6:	6402                	ld	s0,0(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret

00000000000004dc <sbrk>:

char *
sbrk(int n) {
 4dc:	1141                	addi	sp,sp,-16
 4de:	e406                	sd	ra,8(sp)
 4e0:	e022                	sd	s0,0(sp)
 4e2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4e4:	4585                	li	a1,1
 4e6:	0b2000ef          	jal	598 <sys_sbrk>
}
 4ea:	60a2                	ld	ra,8(sp)
 4ec:	6402                	ld	s0,0(sp)
 4ee:	0141                	addi	sp,sp,16
 4f0:	8082                	ret

00000000000004f2 <sbrklazy>:

char *
sbrklazy(int n) {
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e406                	sd	ra,8(sp)
 4f6:	e022                	sd	s0,0(sp)
 4f8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4fa:	4589                	li	a1,2
 4fc:	09c000ef          	jal	598 <sys_sbrk>
}
 500:	60a2                	ld	ra,8(sp)
 502:	6402                	ld	s0,0(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret

0000000000000508 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 508:	4885                	li	a7,1
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <exit>:
.global exit
exit:
 li a7, SYS_exit
 510:	4889                	li	a7,2
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <wait>:
.global wait
wait:
 li a7, SYS_wait
 518:	488d                	li	a7,3
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 520:	4891                	li	a7,4
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <read>:
.global read
read:
 li a7, SYS_read
 528:	4895                	li	a7,5
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <write>:
.global write
write:
 li a7, SYS_write
 530:	48c1                	li	a7,16
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <close>:
.global close
close:
 li a7, SYS_close
 538:	48d5                	li	a7,21
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <kill>:
.global kill
kill:
 li a7, SYS_kill
 540:	4899                	li	a7,6
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <exec>:
.global exec
exec:
 li a7, SYS_exec
 548:	489d                	li	a7,7
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <open>:
.global open
open:
 li a7, SYS_open
 550:	48bd                	li	a7,15
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 558:	48c5                	li	a7,17
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 560:	48c9                	li	a7,18
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 568:	48a1                	li	a7,8
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <link>:
.global link
link:
 li a7, SYS_link
 570:	48cd                	li	a7,19
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 578:	48d1                	li	a7,20
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 580:	48a5                	li	a7,9
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <dup>:
.global dup
dup:
 li a7, SYS_dup
 588:	48a9                	li	a7,10
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 590:	48ad                	li	a7,11
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 598:	48b1                	li	a7,12
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5a0:	48b5                	li	a7,13
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a8:	48b9                	li	a7,14
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b0:	1101                	addi	sp,sp,-32
 5b2:	ec06                	sd	ra,24(sp)
 5b4:	e822                	sd	s0,16(sp)
 5b6:	1000                	addi	s0,sp,32
 5b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5bc:	4605                	li	a2,1
 5be:	fef40593          	addi	a1,s0,-17
 5c2:	f6fff0ef          	jal	530 <write>
}
 5c6:	60e2                	ld	ra,24(sp)
 5c8:	6442                	ld	s0,16(sp)
 5ca:	6105                	addi	sp,sp,32
 5cc:	8082                	ret

00000000000005ce <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5ce:	715d                	addi	sp,sp,-80
 5d0:	e486                	sd	ra,72(sp)
 5d2:	e0a2                	sd	s0,64(sp)
 5d4:	f84a                	sd	s2,48(sp)
 5d6:	f44e                	sd	s3,40(sp)
 5d8:	0880                	addi	s0,sp,80
 5da:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5dc:	cac1                	beqz	a3,66c <printint+0x9e>
 5de:	0805d763          	bgez	a1,66c <printint+0x9e>
    neg = 1;
    x = -xx;
 5e2:	40b005bb          	negw	a1,a1
    neg = 1;
 5e6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5e8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 5ec:	86ce                	mv	a3,s3
  i = 0;
 5ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f0:	00000817          	auipc	a6,0x0
 5f4:	58880813          	addi	a6,a6,1416 # b78 <digits>
 5f8:	88ba                	mv	a7,a4
 5fa:	0017051b          	addiw	a0,a4,1
 5fe:	872a                	mv	a4,a0
 600:	02c5f7bb          	remuw	a5,a1,a2
 604:	1782                	slli	a5,a5,0x20
 606:	9381                	srli	a5,a5,0x20
 608:	97c2                	add	a5,a5,a6
 60a:	0007c783          	lbu	a5,0(a5)
 60e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 612:	87ae                	mv	a5,a1
 614:	02c5d5bb          	divuw	a1,a1,a2
 618:	0685                	addi	a3,a3,1
 61a:	fcc7ffe3          	bgeu	a5,a2,5f8 <printint+0x2a>
  if(neg)
 61e:	00030c63          	beqz	t1,636 <printint+0x68>
    buf[i++] = '-';
 622:	fd050793          	addi	a5,a0,-48
 626:	00878533          	add	a0,a5,s0
 62a:	02d00793          	li	a5,45
 62e:	fef50423          	sb	a5,-24(a0)
 632:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 636:	02e05563          	blez	a4,660 <printint+0x92>
 63a:	fc26                	sd	s1,56(sp)
 63c:	377d                	addiw	a4,a4,-1
 63e:	00e984b3          	add	s1,s3,a4
 642:	19fd                	addi	s3,s3,-1
 644:	99ba                	add	s3,s3,a4
 646:	1702                	slli	a4,a4,0x20
 648:	9301                	srli	a4,a4,0x20
 64a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 64e:	0004c583          	lbu	a1,0(s1)
 652:	854a                	mv	a0,s2
 654:	f5dff0ef          	jal	5b0 <putc>
  while(--i >= 0)
 658:	14fd                	addi	s1,s1,-1
 65a:	ff349ae3          	bne	s1,s3,64e <printint+0x80>
 65e:	74e2                	ld	s1,56(sp)
}
 660:	60a6                	ld	ra,72(sp)
 662:	6406                	ld	s0,64(sp)
 664:	7942                	ld	s2,48(sp)
 666:	79a2                	ld	s3,40(sp)
 668:	6161                	addi	sp,sp,80
 66a:	8082                	ret
    x = xx;
 66c:	2581                	sext.w	a1,a1
  neg = 0;
 66e:	4301                	li	t1,0
 670:	bfa5                	j	5e8 <printint+0x1a>

0000000000000672 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 672:	711d                	addi	sp,sp,-96
 674:	ec86                	sd	ra,88(sp)
 676:	e8a2                	sd	s0,80(sp)
 678:	e4a6                	sd	s1,72(sp)
 67a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 67c:	0005c483          	lbu	s1,0(a1)
 680:	22048363          	beqz	s1,8a6 <vprintf+0x234>
 684:	e0ca                	sd	s2,64(sp)
 686:	fc4e                	sd	s3,56(sp)
 688:	f852                	sd	s4,48(sp)
 68a:	f456                	sd	s5,40(sp)
 68c:	f05a                	sd	s6,32(sp)
 68e:	ec5e                	sd	s7,24(sp)
 690:	e862                	sd	s8,16(sp)
 692:	8b2a                	mv	s6,a0
 694:	8a2e                	mv	s4,a1
 696:	8bb2                	mv	s7,a2
  state = 0;
 698:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 69a:	4901                	li	s2,0
 69c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 69e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a2:	06400c13          	li	s8,100
 6a6:	a00d                	j	6c8 <vprintf+0x56>
        putc(fd, c0);
 6a8:	85a6                	mv	a1,s1
 6aa:	855a                	mv	a0,s6
 6ac:	f05ff0ef          	jal	5b0 <putc>
 6b0:	a019                	j	6b6 <vprintf+0x44>
    } else if(state == '%'){
 6b2:	03598363          	beq	s3,s5,6d8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6b6:	0019079b          	addiw	a5,s2,1
 6ba:	893e                	mv	s2,a5
 6bc:	873e                	mv	a4,a5
 6be:	97d2                	add	a5,a5,s4
 6c0:	0007c483          	lbu	s1,0(a5)
 6c4:	1c048a63          	beqz	s1,898 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 6c8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6cc:	fe0993e3          	bnez	s3,6b2 <vprintf+0x40>
      if(c0 == '%'){
 6d0:	fd579ce3          	bne	a5,s5,6a8 <vprintf+0x36>
        state = '%';
 6d4:	89be                	mv	s3,a5
 6d6:	b7c5                	j	6b6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d8:	00ea06b3          	add	a3,s4,a4
 6dc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6e0:	1c060863          	beqz	a2,8b0 <vprintf+0x23e>
      if(c0 == 'd'){
 6e4:	03878763          	beq	a5,s8,712 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6e8:	f9478693          	addi	a3,a5,-108
 6ec:	0016b693          	seqz	a3,a3
 6f0:	f9c60593          	addi	a1,a2,-100
 6f4:	e99d                	bnez	a1,72a <vprintf+0xb8>
 6f6:	ca95                	beqz	a3,72a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	ec9ff0ef          	jal	5ce <printint>
        i += 1;
 70a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 70e:	4981                	li	s3,0
 710:	b75d                	j	6b6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 712:	008b8493          	addi	s1,s7,8
 716:	4685                	li	a3,1
 718:	4629                	li	a2,10
 71a:	000ba583          	lw	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	eafff0ef          	jal	5ce <printint>
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
 728:	b779                	j	6b6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 72a:	9752                	add	a4,a4,s4
 72c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 730:	f9460713          	addi	a4,a2,-108
 734:	00173713          	seqz	a4,a4
 738:	8f75                	and	a4,a4,a3
 73a:	f9c58513          	addi	a0,a1,-100
 73e:	18051363          	bnez	a0,8c4 <vprintf+0x252>
 742:	18070163          	beqz	a4,8c4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 746:	008b8493          	addi	s1,s7,8
 74a:	4685                	li	a3,1
 74c:	4629                	li	a2,10
 74e:	000bb583          	ld	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e7bff0ef          	jal	5ce <printint>
        i += 2;
 758:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
        i += 2;
 75e:	bfa1                	j	6b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 760:	008b8493          	addi	s1,s7,8
 764:	4681                	li	a3,0
 766:	4629                	li	a2,10
 768:	000be583          	lwu	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	e61ff0ef          	jal	5ce <printint>
 772:	8ba6                	mv	s7,s1
      state = 0;
 774:	4981                	li	s3,0
 776:	b781                	j	6b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	008b8493          	addi	s1,s7,8
 77c:	4681                	li	a3,0
 77e:	4629                	li	a2,10
 780:	000bb583          	ld	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	e49ff0ef          	jal	5ce <printint>
        i += 1;
 78a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 78c:	8ba6                	mv	s7,s1
      state = 0;
 78e:	4981                	li	s3,0
 790:	b71d                	j	6b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	008b8493          	addi	s1,s7,8
 796:	4681                	li	a3,0
 798:	4629                	li	a2,10
 79a:	000bb583          	ld	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	e2fff0ef          	jal	5ce <printint>
        i += 2;
 7a4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	8ba6                	mv	s7,s1
      state = 0;
 7a8:	4981                	li	s3,0
        i += 2;
 7aa:	b731                	j	6b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7ac:	008b8493          	addi	s1,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4641                	li	a2,16
 7b4:	000be583          	lwu	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	e15ff0ef          	jal	5ce <printint>
 7be:	8ba6                	mv	s7,s1
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bdd5                	j	6b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c4:	008b8493          	addi	s1,s7,8
 7c8:	4681                	li	a3,0
 7ca:	4641                	li	a2,16
 7cc:	000bb583          	ld	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	dfdff0ef          	jal	5ce <printint>
        i += 1;
 7d6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d8:	8ba6                	mv	s7,s1
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bde9                	j	6b6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7de:	008b8493          	addi	s1,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4641                	li	a2,16
 7e6:	000bb583          	ld	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	de3ff0ef          	jal	5ce <printint>
        i += 2;
 7f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f2:	8ba6                	mv	s7,s1
      state = 0;
 7f4:	4981                	li	s3,0
        i += 2;
 7f6:	b5c1                	j	6b6 <vprintf+0x44>
 7f8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7fa:	008b8793          	addi	a5,s7,8
 7fe:	8cbe                	mv	s9,a5
 800:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 804:	03000593          	li	a1,48
 808:	855a                	mv	a0,s6
 80a:	da7ff0ef          	jal	5b0 <putc>
  putc(fd, 'x');
 80e:	07800593          	li	a1,120
 812:	855a                	mv	a0,s6
 814:	d9dff0ef          	jal	5b0 <putc>
 818:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 81a:	00000b97          	auipc	s7,0x0
 81e:	35eb8b93          	addi	s7,s7,862 # b78 <digits>
 822:	03c9d793          	srli	a5,s3,0x3c
 826:	97de                	add	a5,a5,s7
 828:	0007c583          	lbu	a1,0(a5)
 82c:	855a                	mv	a0,s6
 82e:	d83ff0ef          	jal	5b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 832:	0992                	slli	s3,s3,0x4
 834:	34fd                	addiw	s1,s1,-1
 836:	f4f5                	bnez	s1,822 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 838:	8be6                	mv	s7,s9
      state = 0;
 83a:	4981                	li	s3,0
 83c:	6ca2                	ld	s9,8(sp)
 83e:	bda5                	j	6b6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 840:	008b8493          	addi	s1,s7,8
 844:	000bc583          	lbu	a1,0(s7)
 848:	855a                	mv	a0,s6
 84a:	d67ff0ef          	jal	5b0 <putc>
 84e:	8ba6                	mv	s7,s1
      state = 0;
 850:	4981                	li	s3,0
 852:	b595                	j	6b6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 854:	008b8993          	addi	s3,s7,8
 858:	000bb483          	ld	s1,0(s7)
 85c:	cc91                	beqz	s1,878 <vprintf+0x206>
        for(; *s; s++)
 85e:	0004c583          	lbu	a1,0(s1)
 862:	c985                	beqz	a1,892 <vprintf+0x220>
          putc(fd, *s);
 864:	855a                	mv	a0,s6
 866:	d4bff0ef          	jal	5b0 <putc>
        for(; *s; s++)
 86a:	0485                	addi	s1,s1,1
 86c:	0004c583          	lbu	a1,0(s1)
 870:	f9f5                	bnez	a1,864 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 872:	8bce                	mv	s7,s3
      state = 0;
 874:	4981                	li	s3,0
 876:	b581                	j	6b6 <vprintf+0x44>
          s = "(null)";
 878:	00000497          	auipc	s1,0x0
 87c:	2f848493          	addi	s1,s1,760 # b70 <malloc+0x15c>
        for(; *s; s++)
 880:	02800593          	li	a1,40
 884:	b7c5                	j	864 <vprintf+0x1f2>
        putc(fd, '%');
 886:	85be                	mv	a1,a5
 888:	855a                	mv	a0,s6
 88a:	d27ff0ef          	jal	5b0 <putc>
      state = 0;
 88e:	4981                	li	s3,0
 890:	b51d                	j	6b6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 892:	8bce                	mv	s7,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	b505                	j	6b6 <vprintf+0x44>
 898:	6906                	ld	s2,64(sp)
 89a:	79e2                	ld	s3,56(sp)
 89c:	7a42                	ld	s4,48(sp)
 89e:	7aa2                	ld	s5,40(sp)
 8a0:	7b02                	ld	s6,32(sp)
 8a2:	6be2                	ld	s7,24(sp)
 8a4:	6c42                	ld	s8,16(sp)
    }
  }
}
 8a6:	60e6                	ld	ra,88(sp)
 8a8:	6446                	ld	s0,80(sp)
 8aa:	64a6                	ld	s1,72(sp)
 8ac:	6125                	addi	sp,sp,96
 8ae:	8082                	ret
      if(c0 == 'd'){
 8b0:	06400713          	li	a4,100
 8b4:	e4e78fe3          	beq	a5,a4,712 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 8b8:	f9478693          	addi	a3,a5,-108
 8bc:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8c0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8c2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8c4:	07500513          	li	a0,117
 8c8:	e8a78ce3          	beq	a5,a0,760 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8cc:	f8b60513          	addi	a0,a2,-117
 8d0:	e119                	bnez	a0,8d6 <vprintf+0x264>
 8d2:	ea0693e3          	bnez	a3,778 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8d6:	f8b58513          	addi	a0,a1,-117
 8da:	e119                	bnez	a0,8e0 <vprintf+0x26e>
 8dc:	ea071be3          	bnez	a4,792 <vprintf+0x120>
      } else if(c0 == 'x'){
 8e0:	07800513          	li	a0,120
 8e4:	eca784e3          	beq	a5,a0,7ac <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 8e8:	f8860613          	addi	a2,a2,-120
 8ec:	e219                	bnez	a2,8f2 <vprintf+0x280>
 8ee:	ec069be3          	bnez	a3,7c4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8f2:	f8858593          	addi	a1,a1,-120
 8f6:	e199                	bnez	a1,8fc <vprintf+0x28a>
 8f8:	ee0713e3          	bnez	a4,7de <vprintf+0x16c>
      } else if(c0 == 'p'){
 8fc:	07000713          	li	a4,112
 900:	eee78ce3          	beq	a5,a4,7f8 <vprintf+0x186>
      } else if(c0 == 'c'){
 904:	06300713          	li	a4,99
 908:	f2e78ce3          	beq	a5,a4,840 <vprintf+0x1ce>
      } else if(c0 == 's'){
 90c:	07300713          	li	a4,115
 910:	f4e782e3          	beq	a5,a4,854 <vprintf+0x1e2>
      } else if(c0 == '%'){
 914:	02500713          	li	a4,37
 918:	f6e787e3          	beq	a5,a4,886 <vprintf+0x214>
        putc(fd, '%');
 91c:	02500593          	li	a1,37
 920:	855a                	mv	a0,s6
 922:	c8fff0ef          	jal	5b0 <putc>
        putc(fd, c0);
 926:	85a6                	mv	a1,s1
 928:	855a                	mv	a0,s6
 92a:	c87ff0ef          	jal	5b0 <putc>
      state = 0;
 92e:	4981                	li	s3,0
 930:	b359                	j	6b6 <vprintf+0x44>

0000000000000932 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 932:	715d                	addi	sp,sp,-80
 934:	ec06                	sd	ra,24(sp)
 936:	e822                	sd	s0,16(sp)
 938:	1000                	addi	s0,sp,32
 93a:	e010                	sd	a2,0(s0)
 93c:	e414                	sd	a3,8(s0)
 93e:	e818                	sd	a4,16(s0)
 940:	ec1c                	sd	a5,24(s0)
 942:	03043023          	sd	a6,32(s0)
 946:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 94a:	8622                	mv	a2,s0
 94c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 950:	d23ff0ef          	jal	672 <vprintf>
}
 954:	60e2                	ld	ra,24(sp)
 956:	6442                	ld	s0,16(sp)
 958:	6161                	addi	sp,sp,80
 95a:	8082                	ret

000000000000095c <printf>:

void
printf(const char *fmt, ...)
{
 95c:	711d                	addi	sp,sp,-96
 95e:	ec06                	sd	ra,24(sp)
 960:	e822                	sd	s0,16(sp)
 962:	1000                	addi	s0,sp,32
 964:	e40c                	sd	a1,8(s0)
 966:	e810                	sd	a2,16(s0)
 968:	ec14                	sd	a3,24(s0)
 96a:	f018                	sd	a4,32(s0)
 96c:	f41c                	sd	a5,40(s0)
 96e:	03043823          	sd	a6,48(s0)
 972:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 976:	00840613          	addi	a2,s0,8
 97a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 97e:	85aa                	mv	a1,a0
 980:	4505                	li	a0,1
 982:	cf1ff0ef          	jal	672 <vprintf>
}
 986:	60e2                	ld	ra,24(sp)
 988:	6442                	ld	s0,16(sp)
 98a:	6125                	addi	sp,sp,96
 98c:	8082                	ret

000000000000098e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 98e:	1141                	addi	sp,sp,-16
 990:	e406                	sd	ra,8(sp)
 992:	e022                	sd	s0,0(sp)
 994:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 996:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99a:	00000797          	auipc	a5,0x0
 99e:	6667b783          	ld	a5,1638(a5) # 1000 <freep>
 9a2:	a039                	j	9b0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a4:	6398                	ld	a4,0(a5)
 9a6:	00e7e463          	bltu	a5,a4,9ae <free+0x20>
 9aa:	00e6ea63          	bltu	a3,a4,9be <free+0x30>
{
 9ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b0:	fed7fae3          	bgeu	a5,a3,9a4 <free+0x16>
 9b4:	6398                	ld	a4,0(a5)
 9b6:	00e6e463          	bltu	a3,a4,9be <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ba:	fee7eae3          	bltu	a5,a4,9ae <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9be:	ff852583          	lw	a1,-8(a0)
 9c2:	6390                	ld	a2,0(a5)
 9c4:	02059813          	slli	a6,a1,0x20
 9c8:	01c85713          	srli	a4,a6,0x1c
 9cc:	9736                	add	a4,a4,a3
 9ce:	02e60563          	beq	a2,a4,9f8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9d2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9d6:	4790                	lw	a2,8(a5)
 9d8:	02061593          	slli	a1,a2,0x20
 9dc:	01c5d713          	srli	a4,a1,0x1c
 9e0:	973e                	add	a4,a4,a5
 9e2:	02e68263          	beq	a3,a4,a06 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e8:	00000717          	auipc	a4,0x0
 9ec:	60f73c23          	sd	a5,1560(a4) # 1000 <freep>
}
 9f0:	60a2                	ld	ra,8(sp)
 9f2:	6402                	ld	s0,0(sp)
 9f4:	0141                	addi	sp,sp,16
 9f6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9f8:	4618                	lw	a4,8(a2)
 9fa:	9f2d                	addw	a4,a4,a1
 9fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a00:	6398                	ld	a4,0(a5)
 a02:	6310                	ld	a2,0(a4)
 a04:	b7f9                	j	9d2 <free+0x44>
    p->s.size += bp->s.size;
 a06:	ff852703          	lw	a4,-8(a0)
 a0a:	9f31                	addw	a4,a4,a2
 a0c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a0e:	ff053683          	ld	a3,-16(a0)
 a12:	bfd1                	j	9e6 <free+0x58>

0000000000000a14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a14:	7139                	addi	sp,sp,-64
 a16:	fc06                	sd	ra,56(sp)
 a18:	f822                	sd	s0,48(sp)
 a1a:	f04a                	sd	s2,32(sp)
 a1c:	ec4e                	sd	s3,24(sp)
 a1e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a20:	02051993          	slli	s3,a0,0x20
 a24:	0209d993          	srli	s3,s3,0x20
 a28:	09bd                	addi	s3,s3,15
 a2a:	0049d993          	srli	s3,s3,0x4
 a2e:	2985                	addiw	s3,s3,1
 a30:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a32:	00000517          	auipc	a0,0x0
 a36:	5ce53503          	ld	a0,1486(a0) # 1000 <freep>
 a3a:	c905                	beqz	a0,a6a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3e:	4798                	lw	a4,8(a5)
 a40:	09377663          	bgeu	a4,s3,acc <malloc+0xb8>
 a44:	f426                	sd	s1,40(sp)
 a46:	e852                	sd	s4,16(sp)
 a48:	e456                	sd	s5,8(sp)
 a4a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a4c:	8a4e                	mv	s4,s3
 a4e:	6705                	lui	a4,0x1
 a50:	00e9f363          	bgeu	s3,a4,a56 <malloc+0x42>
 a54:	6a05                	lui	s4,0x1
 a56:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a5a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a5e:	00000497          	auipc	s1,0x0
 a62:	5a248493          	addi	s1,s1,1442 # 1000 <freep>
  if(p == SBRK_ERROR)
 a66:	5afd                	li	s5,-1
 a68:	a83d                	j	aa6 <malloc+0x92>
 a6a:	f426                	sd	s1,40(sp)
 a6c:	e852                	sd	s4,16(sp)
 a6e:	e456                	sd	s5,8(sp)
 a70:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a72:	00000797          	auipc	a5,0x0
 a76:	5ae78793          	addi	a5,a5,1454 # 1020 <base>
 a7a:	00000717          	auipc	a4,0x0
 a7e:	58f73323          	sd	a5,1414(a4) # 1000 <freep>
 a82:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a84:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a88:	b7d1                	j	a4c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a8a:	6398                	ld	a4,0(a5)
 a8c:	e118                	sd	a4,0(a0)
 a8e:	a899                	j	ae4 <malloc+0xd0>
  hp->s.size = nu;
 a90:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a94:	0541                	addi	a0,a0,16
 a96:	ef9ff0ef          	jal	98e <free>
  return freep;
 a9a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a9c:	c125                	beqz	a0,afc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa0:	4798                	lw	a4,8(a5)
 aa2:	03277163          	bgeu	a4,s2,ac4 <malloc+0xb0>
    if(p == freep)
 aa6:	6098                	ld	a4,0(s1)
 aa8:	853e                	mv	a0,a5
 aaa:	fef71ae3          	bne	a4,a5,a9e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 aae:	8552                	mv	a0,s4
 ab0:	a2dff0ef          	jal	4dc <sbrk>
  if(p == SBRK_ERROR)
 ab4:	fd551ee3          	bne	a0,s5,a90 <malloc+0x7c>
        return 0;
 ab8:	4501                	li	a0,0
 aba:	74a2                	ld	s1,40(sp)
 abc:	6a42                	ld	s4,16(sp)
 abe:	6aa2                	ld	s5,8(sp)
 ac0:	6b02                	ld	s6,0(sp)
 ac2:	a03d                	j	af0 <malloc+0xdc>
 ac4:	74a2                	ld	s1,40(sp)
 ac6:	6a42                	ld	s4,16(sp)
 ac8:	6aa2                	ld	s5,8(sp)
 aca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 acc:	fae90fe3          	beq	s2,a4,a8a <malloc+0x76>
        p->s.size -= nunits;
 ad0:	4137073b          	subw	a4,a4,s3
 ad4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ad6:	02071693          	slli	a3,a4,0x20
 ada:	01c6d713          	srli	a4,a3,0x1c
 ade:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ae4:	00000717          	auipc	a4,0x0
 ae8:	50a73e23          	sd	a0,1308(a4) # 1000 <freep>
      return (void*)(p + 1);
 aec:	01078513          	addi	a0,a5,16
  }
}
 af0:	70e2                	ld	ra,56(sp)
 af2:	7442                	ld	s0,48(sp)
 af4:	7902                	ld	s2,32(sp)
 af6:	69e2                	ld	s3,24(sp)
 af8:	6121                	addi	sp,sp,64
 afa:	8082                	ret
 afc:	74a2                	ld	s1,40(sp)
 afe:	6a42                	ld	s4,16(sp)
 b00:	6aa2                	ld	s5,8(sp)
 b02:	6b02                	ld	s6,0(sp)
 b04:	b7f5                	j	af0 <malloc+0xdc>
