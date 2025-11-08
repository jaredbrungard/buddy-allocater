
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	96878793          	addi	a5,a5,-1688 # 7978 <malloc+0x257c>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	6ef040ef          	jal	4f38 <open>
    if(fd >= 0){
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00005517          	auipc	a0,0x5
      70:	48450513          	addi	a0,a0,1156 # 54f0 <malloc+0xf4>
      74:	2d0050ef          	jal	5344 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	67f040ef          	jal	4ef8 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      7e:	00009797          	auipc	a5,0x9
      82:	51a78793          	addi	a5,a5,1306 # 9598 <uninit>
      86:	0000c697          	auipc	a3,0xc
      8a:	c2268693          	addi	a3,a3,-990 # bca8 <buf>
    if(uninit[i] != '\0'){
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00005517          	auipc	a0,0x5
      aa:	46a50513          	addi	a0,a0,1130 # 5510 <malloc+0x114>
      ae:	296050ef          	jal	5344 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	645040ef          	jal	4ef8 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00005517          	auipc	a0,0x5
      ca:	46250513          	addi	a0,a0,1122 # 5528 <malloc+0x12c>
      ce:	66b040ef          	jal	4f38 <open>
  if(fd < 0){
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	64b040ef          	jal	4f20 <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	46c50513          	addi	a0,a0,1132 # 5548 <malloc+0x14c>
      e4:	655040ef          	jal	4f38 <open>
  if(fd >= 0){
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00005517          	auipc	a0,0x5
      fc:	43850513          	addi	a0,a0,1080 # 5530 <malloc+0x134>
     100:	244050ef          	jal	5344 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	5f3040ef          	jal	4ef8 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	44c50513          	addi	a0,a0,1100 # 5558 <malloc+0x15c>
     114:	230050ef          	jal	5344 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	5df040ef          	jal	4ef8 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00005517          	auipc	a0,0x5
     132:	45250513          	addi	a0,a0,1106 # 5580 <malloc+0x184>
     136:	613040ef          	jal	4f48 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	44250513          	addi	a0,a0,1090 # 5580 <malloc+0x184>
     146:	5f3040ef          	jal	4f38 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	44258593          	addi	a1,a1,1090 # 5590 <malloc+0x194>
     156:	5c3040ef          	jal	4f18 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	42250513          	addi	a0,a0,1058 # 5580 <malloc+0x184>
     166:	5d3040ef          	jal	4f38 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	42a58593          	addi	a1,a1,1066 # 5598 <malloc+0x19c>
     176:	8526                	mv	a0,s1
     178:	5a1040ef          	jal	4f18 <write>
  if(n != -1){
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	3fe50513          	addi	a0,a0,1022 # 5580 <malloc+0x184>
     18a:	5bf040ef          	jal	4f48 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	591040ef          	jal	4f20 <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	58b040ef          	jal	4f20 <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00005517          	auipc	a0,0x5
     1b0:	3f450513          	addi	a0,a0,1012 # 55a0 <malloc+0x1a4>
     1b4:	190050ef          	jal	5344 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	53f040ef          	jal	4ef8 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	547040ef          	jal	4f38 <open>
    close(fd);
     1f6:	52b040ef          	jal	4f20 <close>
  for(i = 0; i < N; i++){
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	527040ef          	jal	4f48 <unlink>
  for(i = 0; i < N; i++){
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00005517          	auipc	a0,0x5
     260:	36c50513          	addi	a0,a0,876 # 55c8 <malloc+0x1cc>
     264:	4e5040ef          	jal	4f48 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00005a17          	auipc	s4,0x5
     274:	358a0a13          	addi	s4,s4,856 # 55c8 <malloc+0x1cc>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000c997          	auipc	s3,0xc
     27e:	a2e98993          	addi	s3,s3,-1490 # bca8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <subdir+0x4c9>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	4ad040ef          	jal	4f38 <open>
     290:	892a                	mv	s2,a0
    if(fd < 0){
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	47b040ef          	jal	4f18 <write>
      if(cc != sz){
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for(i = 0; i < 2; i++){
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	473040ef          	jal	4f20 <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	495040ef          	jal	4f48 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00005517          	auipc	a0,0x5
     2e0:	2fc50513          	addi	a0,a0,764 # 55d8 <malloc+0x1dc>
     2e4:	060050ef          	jal	5344 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	40f040ef          	jal	4ef8 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00005517          	auipc	a0,0x5
     2f8:	30450513          	addi	a0,a0,772 # 55f8 <malloc+0x1fc>
     2fc:	048050ef          	jal	5344 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	3f7040ef          	jal	4ef8 <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     31a:	00005517          	auipc	a0,0x5
     31e:	2f650513          	addi	a0,a0,758 # 5610 <malloc+0x214>
     322:	427040ef          	jal	4f48 <unlink>
     326:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00005997          	auipc	s3,0x5
     332:	2e298993          	addi	s3,s3,738 # 5610 <malloc+0x214>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	3f7040ef          	jal	4f38 <open>
     346:	84aa                	mv	s1,a0
    if(fd < 0){
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	3c9040ef          	jal	4f18 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	3cb040ef          	jal	4f20 <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	3ed040ef          	jal	4f48 <unlink>
  for(int i = 0; i < assumed_free; i++){
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00005517          	auipc	a0,0x5
     36e:	2a650513          	addi	a0,a0,678 # 5610 <malloc+0x214>
     372:	3c7040ef          	jal	4f38 <open>
     376:	84aa                	mv	s1,a0
  if(fd < 0){
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     37c:	4605                	li	a2,1
     37e:	00005597          	auipc	a1,0x5
     382:	21a58593          	addi	a1,a1,538 # 5598 <malloc+0x19c>
     386:	393040ef          	jal	4f18 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00005517          	auipc	a0,0x5
     394:	2a050513          	addi	a0,a0,672 # 5630 <malloc+0x234>
     398:	7ad040ef          	jal	5344 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	35b040ef          	jal	4ef8 <exit>
      printf("open junk failed\n");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	27650513          	addi	a0,a0,630 # 5618 <malloc+0x21c>
     3aa:	79b040ef          	jal	5344 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	349040ef          	jal	4ef8 <exit>
    printf("open junk failed\n");
     3b4:	00005517          	auipc	a0,0x5
     3b8:	26450513          	addi	a0,a0,612 # 5618 <malloc+0x21c>
     3bc:	789040ef          	jal	5344 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	337040ef          	jal	4ef8 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	359040ef          	jal	4f20 <close>
  unlink("junk");
     3cc:	00005517          	auipc	a0,0x5
     3d0:	24450513          	addi	a0,a0,580 # 5610 <malloc+0x214>
     3d4:	375040ef          	jal	4f48 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	31f040ef          	jal	4ef8 <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	315040ef          	jal	4f48 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	2fd040ef          	jal	4f38 <open>
    if(fd < 0){
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	2dd040ef          	jal	4f20 <close>
  for(int i = 0; i < nzz; i++){
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
     44e:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	2bb040ef          	jal	4f48 <unlink>
  for(int i = 0; i < nzz; i++){
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00007797          	auipc	a5,0x7
     4c8:	4b478793          	addi	a5,a5,1204 # 7978 <malloc+0x257c>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00005a97          	auipc	s5,0x5
     4fa:	14aa8a93          	addi	s5,s5,330 # 5640 <malloc+0x244>
    int n = write(fd, (void*)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     500:	4c05                	li	s8,1
    if(pipe(fds) < 0){
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	22b040ef          	jal	4f38 <open>
     512:	84aa                	mv	s1,a0
    if(fd < 0){
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	1fd040ef          	jal	4f18 <write>
    if(n >= 0){
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	1fb040ef          	jal	4f20 <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	21d040ef          	jal	4f48 <unlink>
    n = write(1, (char*)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	1e3040ef          	jal	4f18 <write>
    if(n > 0){
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if(pipe(fds) < 0){
     53e:	855e                	mv	a0,s7
     540:	1c9040ef          	jal	4f08 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	1c9040ef          	jal	4f18 <write>
    if(n > 0){
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	1c5040ef          	jal	4f20 <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	1bd040ef          	jal	4f20 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00005517          	auipc	a0,0x5
     58c:	0c050513          	addi	a0,a0,192 # 5648 <malloc+0x24c>
     590:	5b5040ef          	jal	5344 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	163040ef          	jal	4ef8 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00005517          	auipc	a0,0x5
     5a2:	0c250513          	addi	a0,a0,194 # 5660 <malloc+0x264>
     5a6:	59f040ef          	jal	5344 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	14d040ef          	jal	4ef8 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00005517          	auipc	a0,0x5
     5b8:	0dc50513          	addi	a0,a0,220 # 5690 <malloc+0x294>
     5bc:	589040ef          	jal	5344 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	137040ef          	jal	4ef8 <exit>
      printf("pipe() failed\n");
     5c6:	00005517          	auipc	a0,0x5
     5ca:	0fa50513          	addi	a0,a0,250 # 56c0 <malloc+0x2c4>
     5ce:	577040ef          	jal	5344 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	125040ef          	jal	4ef8 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00005517          	auipc	a0,0x5
     5e0:	0f450513          	addi	a0,a0,244 # 56d0 <malloc+0x2d4>
     5e4:	561040ef          	jal	5344 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	10f040ef          	jal	4ef8 <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     608:	00007797          	auipc	a5,0x7
     60c:	37078793          	addi	a5,a5,880 # 7978 <malloc+0x257c>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00005b17          	auipc	s6,0x5
     640:	0c4b0b13          	addi	s6,s6,196 # 5700 <malloc+0x304>
    int n = read(fd, (void*)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	f4cb8b93          	addi	s7,s7,-180 # 5598 <malloc+0x19c>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	0dd040ef          	jal	4f38 <open>
     660:	84aa                	mv	s1,a0
    if(fd < 0){
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	0a7040ef          	jal	4f10 <read>
    if(n > 0){
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	0ad040ef          	jal	4f20 <close>
    if(pipe(fds) < 0){
     678:	8562                	mv	a0,s8
     67a:	08f040ef          	jal	4f08 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	08f040ef          	jal	4f18 <write>
    if(n != 1){
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	077040ef          	jal	4f10 <read>
    if(n > 0){
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	07b040ef          	jal	4f20 <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	073040ef          	jal	4f20 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00005517          	auipc	a0,0x5
     6d6:	03650513          	addi	a0,a0,54 # 5708 <malloc+0x30c>
     6da:	46b040ef          	jal	5344 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	019040ef          	jal	4ef8 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00005517          	auipc	a0,0x5
     6ec:	03850513          	addi	a0,a0,56 # 5720 <malloc+0x324>
     6f0:	455040ef          	jal	5344 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	003040ef          	jal	4ef8 <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	fc650513          	addi	a0,a0,-58 # 56c0 <malloc+0x2c4>
     702:	443040ef          	jal	5344 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	7f0040ef          	jal	4ef8 <exit>
      printf("pipe write failed\n");
     70c:	00005517          	auipc	a0,0x5
     710:	04450513          	addi	a0,a0,68 # 5750 <malloc+0x354>
     714:	431040ef          	jal	5344 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	7de040ef          	jal	4ef8 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00005517          	auipc	a0,0x5
     726:	04650513          	addi	a0,a0,70 # 5768 <malloc+0x36c>
     72a:	41b040ef          	jal	5344 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	7c8040ef          	jal	4ef8 <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	e3850513          	addi	a0,a0,-456 # 5580 <malloc+0x184>
     750:	7f8040ef          	jal	4f48 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	e2850513          	addi	a0,a0,-472 # 5580 <malloc+0x184>
     760:	7d8040ef          	jal	4f38 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	e2858593          	addi	a1,a1,-472 # 5590 <malloc+0x194>
     770:	7a8040ef          	jal	4f18 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	7aa040ef          	jal	4f20 <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	e0450513          	addi	a0,a0,-508 # 5580 <malloc+0x184>
     784:	7b4040ef          	jal	4f38 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	77e040ef          	jal	4f10 <read>
  if(n != 4){
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	de050513          	addi	a0,a0,-544 # 5580 <malloc+0x184>
     7a8:	790040ef          	jal	4f38 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	dd050513          	addi	a0,a0,-560 # 5580 <malloc+0x184>
     7b8:	780040ef          	jal	4f38 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	74a040ef          	jal	4f10 <read>
     7ca:	8aaa                	mv	s5,a0
  if(n != 0){
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	738040ef          	jal	4f10 <read>
     7dc:	8aaa                	mv	s5,a0
  if(n != 0){
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	01658593          	addi	a1,a1,22 # 57f8 <malloc+0x3fc>
     7ea:	854e                	mv	a0,s3
     7ec:	72c040ef          	jal	4f18 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	716040ef          	jal	4f10 <read>
  if(n != 6){
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	702040ef          	jal	4f10 <read>
  if(n != 2){
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	d6850513          	addi	a0,a0,-664 # 5580 <malloc+0x184>
     820:	728040ef          	jal	4f48 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	6fa040ef          	jal	4f20 <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	6f4040ef          	jal	4f20 <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	6ee040ef          	jal	4f20 <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	f4c50513          	addi	a0,a0,-180 # 5798 <malloc+0x39c>
     854:	2f1040ef          	jal	5344 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	69e040ef          	jal	4ef8 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	f5850513          	addi	a0,a0,-168 # 57b8 <malloc+0x3bc>
     868:	2dd040ef          	jal	5344 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	f5850513          	addi	a0,a0,-168 # 57c8 <malloc+0x3cc>
     878:	2cd040ef          	jal	5344 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	67a040ef          	jal	4ef8 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	f6450513          	addi	a0,a0,-156 # 57e8 <malloc+0x3ec>
     88c:	2b9040ef          	jal	5344 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	f3450513          	addi	a0,a0,-204 # 57c8 <malloc+0x3cc>
     89c:	2a9040ef          	jal	5344 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	656040ef          	jal	4ef8 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	f5650513          	addi	a0,a0,-170 # 5800 <malloc+0x404>
     8b2:	293040ef          	jal	5344 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	640040ef          	jal	4ef8 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	f6050513          	addi	a0,a0,-160 # 5820 <malloc+0x424>
     8c8:	27d040ef          	jal	5344 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	62a040ef          	jal	4ef8 <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	f5250513          	addi	a0,a0,-174 # 5840 <malloc+0x444>
     8f6:	642040ef          	jal	4f38 <open>
  if(fd < 0){
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	f64a0a13          	addi	s4,s4,-156 # 5868 <malloc+0x46c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     90c:	00005b17          	auipc	s6,0x5
     910:	f94b0b13          	addi	s6,s6,-108 # 58a0 <malloc+0x4a4>
  for(i = 0; i < N; i++){
     914:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	5fa040ef          	jal	4f18 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	5ec040ef          	jal	4f18 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for(i = 0; i < N; i++){
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	5e4040ef          	jal	4f20 <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	efe50513          	addi	a0,a0,-258 # 5840 <malloc+0x444>
     94a:	5ee040ef          	jal	4f38 <open>
     94e:	84aa                	mv	s1,a0
  if(fd < 0){
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
     954:	7d000613          	li	a2,2000
     958:	0000b597          	auipc	a1,0xb
     95c:	35058593          	addi	a1,a1,848 # bca8 <buf>
     960:	5b0040ef          	jal	4f10 <read>
  if(i != N*SZ*2){
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	5b2040ef          	jal	4f20 <close>
  if(unlink("small") < 0){
     972:	00005517          	auipc	a0,0x5
     976:	ece50513          	addi	a0,a0,-306 # 5840 <malloc+0x444>
     97a:	5ce040ef          	jal	4f48 <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	eae50513          	addi	a0,a0,-338 # 5848 <malloc+0x44c>
     9a2:	1a3040ef          	jal	5344 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	550040ef          	jal	4ef8 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	ec850513          	addi	a0,a0,-312 # 5878 <malloc+0x47c>
     9b8:	18d040ef          	jal	5344 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	53a040ef          	jal	4ef8 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	eea50513          	addi	a0,a0,-278 # 58b0 <malloc+0x4b4>
     9ce:	177040ef          	jal	5344 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	524040ef          	jal	4ef8 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	efe50513          	addi	a0,a0,-258 # 58d8 <malloc+0x4dc>
     9e2:	163040ef          	jal	5344 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	510040ef          	jal	4ef8 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	f0a50513          	addi	a0,a0,-246 # 58f8 <malloc+0x4fc>
     9f6:	14f040ef          	jal	5344 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	4fc040ef          	jal	4ef8 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	f0e50513          	addi	a0,a0,-242 # 5910 <malloc+0x514>
     a0a:	13b040ef          	jal	5344 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	4e8040ef          	jal	4ef8 <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	f0250513          	addi	a0,a0,-254 # 5930 <malloc+0x534>
     a36:	502040ef          	jal	4f38 <open>
  if(fd < 0){
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a42:	0000b997          	auipc	s3,0xb
     a46:	26698993          	addi	s3,s3,614 # bca8 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     a4a:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     a4e:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	4bc040ef          	jal	4f18 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	4b4040ef          	jal	4f20 <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	ebe50513          	addi	a0,a0,-322 # 5930 <malloc+0x534>
     a7a:	4be040ef          	jal	4f38 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000b917          	auipc	s2,0xb
     a8a:	22290913          	addi	s2,s2,546 # bca8 <buf>
  if(fd < 0){
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	478040ef          	jal	4f10 <read>
    if(i == 0){
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if(i != BSIZE){
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if(((int*)buf)[0] != n){
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	e8850513          	addi	a0,a0,-376 # 5938 <malloc+0x53c>
     ab8:	08d040ef          	jal	5344 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	43a040ef          	jal	4ef8 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	e9250513          	addi	a0,a0,-366 # 5958 <malloc+0x55c>
     ace:	077040ef          	jal	5344 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	424040ef          	jal	4ef8 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	ea650513          	addi	a0,a0,-346 # 5980 <malloc+0x584>
     ae2:	063040ef          	jal	5344 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	410040ef          	jal	4ef8 <exit>
      if(n != MAXFILE){
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	42a040ef          	jal	4f20 <close>
  if(unlink("big") < 0){
     afa:	00005517          	auipc	a0,0x5
     afe:	e3650513          	addi	a0,a0,-458 # 5930 <malloc+0x534>
     b02:	446040ef          	jal	4f48 <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	e7e50513          	addi	a0,a0,-386 # 59a0 <malloc+0x5a4>
     b2a:	01b040ef          	jal	5344 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	3c8040ef          	jal	4ef8 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	e9050513          	addi	a0,a0,-368 # 59c8 <malloc+0x5cc>
     b40:	005040ef          	jal	5344 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	3b2040ef          	jal	4ef8 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	e9250513          	addi	a0,a0,-366 # 59e0 <malloc+0x5e4>
     b56:	7ee040ef          	jal	5344 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	39c040ef          	jal	4ef8 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	ea650513          	addi	a0,a0,-346 # 5a08 <malloc+0x60c>
     b6a:	7da040ef          	jal	5344 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	388040ef          	jal	4ef8 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	e9850513          	addi	a0,a0,-360 # 5a20 <malloc+0x624>
     b90:	3a8040ef          	jal	4f38 <open>
  if(fd < 0){
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	eb458593          	addi	a1,a1,-332 # 5a50 <malloc+0x654>
     ba4:	374040ef          	jal	4f18 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	376040ef          	jal	4f20 <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	e7050513          	addi	a0,a0,-400 # 5a20 <malloc+0x624>
     bb8:	380040ef          	jal	4f38 <open>
     bbc:	84aa                	mv	s1,a0
  if(fd < 0){
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     bc2:	00005517          	auipc	a0,0x5
     bc6:	e5e50513          	addi	a0,a0,-418 # 5a20 <malloc+0x624>
     bca:	37e040ef          	jal	4f48 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	e4c50513          	addi	a0,a0,-436 # 5a20 <malloc+0x624>
     bdc:	35c040ef          	jal	4f38 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	eb458593          	addi	a1,a1,-332 # 5a98 <malloc+0x69c>
     bec:	32c040ef          	jal	4f18 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	32e040ef          	jal	4f20 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     bf6:	660d                	lui	a2,0x3
     bf8:	0000b597          	auipc	a1,0xb
     bfc:	0b058593          	addi	a1,a1,176 # bca8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	30e040ef          	jal	4f10 <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if(buf[0] != 'h'){
     c0c:	0000b717          	auipc	a4,0xb
     c10:	09c74703          	lbu	a4,156(a4) # bca8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     c1c:	4629                	li	a2,10
     c1e:	0000b597          	auipc	a1,0xb
     c22:	08a58593          	addi	a1,a1,138 # bca8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	2f0040ef          	jal	4f18 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	2ec040ef          	jal	4f20 <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	de850513          	addi	a0,a0,-536 # 5a20 <malloc+0x624>
     c40:	308040ef          	jal	4f48 <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	ddc50513          	addi	a0,a0,-548 # 5a30 <malloc+0x634>
     c5c:	6e8040ef          	jal	5344 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	296040ef          	jal	4ef8 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	df050513          	addi	a0,a0,-528 # 5a58 <malloc+0x65c>
     c70:	6d4040ef          	jal	5344 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	282040ef          	jal	4ef8 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	dfc50513          	addi	a0,a0,-516 # 5a78 <malloc+0x67c>
     c84:	6c0040ef          	jal	5344 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	26e040ef          	jal	4ef8 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	e1050513          	addi	a0,a0,-496 # 5aa0 <malloc+0x6a4>
     c98:	6ac040ef          	jal	5344 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	25a040ef          	jal	4ef8 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	e1c50513          	addi	a0,a0,-484 # 5ac0 <malloc+0x6c4>
     cac:	698040ef          	jal	5344 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	246040ef          	jal	4ef8 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	e2850513          	addi	a0,a0,-472 # 5ae0 <malloc+0x6e4>
     cc0:	684040ef          	jal	5344 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	232040ef          	jal	4ef8 <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	e2850513          	addi	a0,a0,-472 # 5b00 <malloc+0x704>
     ce0:	268040ef          	jal	4f48 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	e2450513          	addi	a0,a0,-476 # 5b08 <malloc+0x70c>
     cec:	25c040ef          	jal	4f48 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	e0c50513          	addi	a0,a0,-500 # 5b00 <malloc+0x704>
     cfc:	23c040ef          	jal	4f38 <open>
  if(fd < 0){
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	d4858593          	addi	a1,a1,-696 # 5a50 <malloc+0x654>
     d10:	208040ef          	jal	4f18 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	204040ef          	jal	4f20 <close>
  if(link("lf1", "lf2") < 0){
     d20:	00005597          	auipc	a1,0x5
     d24:	de858593          	addi	a1,a1,-536 # 5b08 <malloc+0x70c>
     d28:	00005517          	auipc	a0,0x5
     d2c:	dd850513          	addi	a0,a0,-552 # 5b00 <malloc+0x704>
     d30:	228040ef          	jal	4f58 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	dc850513          	addi	a0,a0,-568 # 5b00 <malloc+0x704>
     d40:	208040ef          	jal	4f48 <unlink>
  if(open("lf1", 0) >= 0){
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	dba50513          	addi	a0,a0,-582 # 5b00 <malloc+0x704>
     d4e:	1ea040ef          	jal	4f38 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	db050513          	addi	a0,a0,-592 # 5b08 <malloc+0x70c>
     d60:	1d8040ef          	jal	4f38 <open>
     d64:	84aa                	mv	s1,a0
  if(fd < 0){
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d6a:	660d                	lui	a2,0x3
     d6c:	0000b597          	auipc	a1,0xb
     d70:	f3c58593          	addi	a1,a1,-196 # bca8 <buf>
     d74:	19c040ef          	jal	4f10 <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	1a0040ef          	jal	4f20 <close>
  if(link("lf2", "lf2") >= 0){
     d84:	00005597          	auipc	a1,0x5
     d88:	d8458593          	addi	a1,a1,-636 # 5b08 <malloc+0x70c>
     d8c:	852e                	mv	a0,a1
     d8e:	1ca040ef          	jal	4f58 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	d7250513          	addi	a0,a0,-654 # 5b08 <malloc+0x70c>
     d9e:	1aa040ef          	jal	4f48 <unlink>
  if(link("lf2", "lf1") >= 0){
     da2:	00005597          	auipc	a1,0x5
     da6:	d5e58593          	addi	a1,a1,-674 # 5b00 <malloc+0x704>
     daa:	00005517          	auipc	a0,0x5
     dae:	d5e50513          	addi	a0,a0,-674 # 5b08 <malloc+0x70c>
     db2:	1a6040ef          	jal	4f58 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     dba:	00005597          	auipc	a1,0x5
     dbe:	d4658593          	addi	a1,a1,-698 # 5b00 <malloc+0x704>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	e4e50513          	addi	a0,a0,-434 # 5c10 <malloc+0x814>
     dca:	18e040ef          	jal	4f58 <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	d3050513          	addi	a0,a0,-720 # 5b10 <malloc+0x714>
     de8:	55c040ef          	jal	5344 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	10a040ef          	jal	4ef8 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	d3450513          	addi	a0,a0,-716 # 5b28 <malloc+0x72c>
     dfc:	548040ef          	jal	5344 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	0f6040ef          	jal	4ef8 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	d3850513          	addi	a0,a0,-712 # 5b40 <malloc+0x744>
     e10:	534040ef          	jal	5344 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	0e2040ef          	jal	4ef8 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	d4450513          	addi	a0,a0,-700 # 5b60 <malloc+0x764>
     e24:	520040ef          	jal	5344 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	0ce040ef          	jal	4ef8 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	d6050513          	addi	a0,a0,-672 # 5b90 <malloc+0x794>
     e38:	50c040ef          	jal	5344 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	0ba040ef          	jal	4ef8 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	d6450513          	addi	a0,a0,-668 # 5ba8 <malloc+0x7ac>
     e4c:	4f8040ef          	jal	5344 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	0a6040ef          	jal	4ef8 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	d6850513          	addi	a0,a0,-664 # 5bc0 <malloc+0x7c4>
     e60:	4e4040ef          	jal	5344 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	092040ef          	jal	4ef8 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	d7c50513          	addi	a0,a0,-644 # 5be8 <malloc+0x7ec>
     e74:	4d0040ef          	jal	5344 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	07e040ef          	jal	4ef8 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	d9850513          	addi	a0,a0,-616 # 5c18 <malloc+0x81c>
     e88:	4bc040ef          	jal	5344 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	06a040ef          	jal	4ef8 <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ea8:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     eaa:	00005997          	auipc	s3,0x5
     eae:	d8e98993          	addi	s3,s3,-626 # 5c38 <malloc+0x83c>
     eb2:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	09a040ef          	jal	4f58 <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	d6650513          	addi	a0,a0,-666 # 5c48 <malloc+0x84c>
     eea:	45a040ef          	jal	5344 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	008040ef          	jal	4ef8 <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	d5c50513          	addi	a0,a0,-676 # 5c68 <malloc+0x86c>
     f14:	034040ef          	jal	4f48 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	d4c50513          	addi	a0,a0,-692 # 5c68 <malloc+0x86c>
     f24:	014040ef          	jal	4f38 <open>
  if(fd < 0){
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	7f5030ef          	jal	4f20 <close>
  for(i = 0; i < N; i++){
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	d2e98993          	addi	s3,s3,-722 # 5c68 <malloc+0x86c>
  for(i = 0; i < N; i++){
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	7e1030ef          	jal	4f58 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for(i = 0; i < N; i++){
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	ce250513          	addi	a0,a0,-798 # 5c68 <malloc+0x86c>
     f8e:	7bb030ef          	jal	4f48 <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if(unlink(name) != 0){
     f96:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
     fcc:	854a                	mv	a0,s2
     fce:	77b030ef          	jal	4f48 <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for(i = 0; i < N; i++){
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	c7e50513          	addi	a0,a0,-898 # 5c70 <malloc+0x874>
     ffa:	34a040ef          	jal	5344 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	6f9030ef          	jal	4ef8 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	c8450513          	addi	a0,a0,-892 # 5c90 <malloc+0x894>
    1014:	330040ef          	jal	5344 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	6df030ef          	jal	4ef8 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	c9850513          	addi	a0,a0,-872 # 5cb8 <malloc+0x8bc>
    1028:	31c040ef          	jal	5344 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	6cb030ef          	jal	4ef8 <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00007497          	auipc	s1,0x7
    1044:	fc048493          	addi	s1,s1,-64 # 8000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	6e3030ef          	jal	4f30 <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	6b5030ef          	jal	4f08 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	69f030ef          	jal	4ef8 <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <buf+0x6a8>
    argv[0] = (char*)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00004997          	auipc	s3,0x4
    1082:	4aa98993          	addi	s3,s3,1194 # 5528 <malloc+0x12c>
    argv[0] = (char*)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	69f030ef          	jal	4f30 <exec>
  for(int i = 0; i < 50000; i++){
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	65d030ef          	jal	4ef8 <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	683030ef          	jal	4f48 <unlink>
  if(ret != -1){
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	661030ef          	jal	4f38 <open>
  if(fd != -1){
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	671030ef          	jal	4f58 <link>
  if(ret != -1){
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    10f2:	00006797          	auipc	a5,0x6
    10f6:	d1678793          	addi	a5,a5,-746 # 6e08 <malloc+0x1a0c>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	627030ef          	jal	4f30 <exec>
  if(ret != -1){
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	5dd030ef          	jal	4ef0 <fork>
  if(pid < 0){
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if(pid == 0){
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00007797          	auipc	a5,0x7
    1124:	47078793          	addi	a5,a5,1136 # 8590 <big.0>
    1128:	00008697          	auipc	a3,0x8
    112c:	46868693          	addi	a3,a3,1128 # 9590 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	00008797          	auipc	a5,0x8
    1142:	44078923          	sb	zero,1106(a5) # 9590 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1146:	00007797          	auipc	a5,0x7
    114a:	83278793          	addi	a5,a5,-1998 # 7978 <malloc+0x257c>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00004517          	auipc	a0,0x4
    116e:	3be50513          	addi	a0,a0,958 # 5528 <malloc+0x12c>
    1172:	5bf030ef          	jal	4f30 <exec>
    if(ret != -1){
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	be250513          	addi	a0,a0,-1054 # 5d60 <malloc+0x964>
    1186:	1be040ef          	jal	5344 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	56d030ef          	jal	4ef8 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	b4250513          	addi	a0,a0,-1214 # 5cd8 <malloc+0x8dc>
    119e:	1a6040ef          	jal	5344 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	555030ef          	jal	4ef8 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	b4a50513          	addi	a0,a0,-1206 # 5cf8 <malloc+0x8fc>
    11b6:	18e040ef          	jal	5344 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	53d030ef          	jal	4ef8 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	b5050513          	addi	a0,a0,-1200 # 5d18 <malloc+0x91c>
    11d0:	174040ef          	jal	5344 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	523030ef          	jal	4ef8 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	b6050513          	addi	a0,a0,-1184 # 5d40 <malloc+0x944>
    11e8:	15c040ef          	jal	5344 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	50b030ef          	jal	4ef8 <exit>
    printf("fork failed\n");
    11f2:	00006517          	auipc	a0,0x6
    11f6:	16e50513          	addi	a0,a0,366 # 7360 <malloc+0x1f64>
    11fa:	14a040ef          	jal	5344 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	4f9030ef          	jal	4ef8 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	4f1030ef          	jal	4ef8 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	4ed030ef          	jal	4f00 <wait>
  if(st != 747){
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	b5c50513          	addi	a0,a0,-1188 # 5d88 <malloc+0x98c>
    1234:	110040ef          	jal	5344 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	4bf030ef          	jal	4ef8 <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00004517          	auipc	a0,0x4
    1252:	33250513          	addi	a0,a0,818 # 5580 <malloc+0x184>
    1256:	4e3030ef          	jal	4f38 <open>
    125a:	4c7030ef          	jal	4f20 <close>
  pid = fork();
    125e:	493030ef          	jal	4ef0 <fork>
  if(pid < 0){
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if(pid == 0){
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00004997          	auipc	s3,0x4
    1282:	30298993          	addi	s3,s3,770 # 5580 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	b60b0b13          	addi	s6,s6,-1184 # 5de8 <malloc+0x9ec>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	49d030ef          	jal	4f38 <open>
    12a0:	84aa                	mv	s1,a0
      if(fd < 0){
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	46f030ef          	jal	4f18 <write>
      if(n != 10){
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	46d030ef          	jal	4f20 <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	47d030ef          	jal	4f38 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	44b030ef          	jal	4f10 <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	455030ef          	jal	4f20 <close>
    for(int i = 0; i < 100; i++){
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	421030ef          	jal	4ef8 <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	aca50513          	addi	a0,a0,-1334 # 5db8 <malloc+0x9bc>
    12f6:	04e040ef          	jal	5344 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	3fd030ef          	jal	4ef8 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	ace50513          	addi	a0,a0,-1330 # 5dd0 <malloc+0x9d4>
    130a:	03a040ef          	jal	5344 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	3e9030ef          	jal	4ef8 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	ae050513          	addi	a0,a0,-1312 # 5df8 <malloc+0x9fc>
    1320:	024040ef          	jal	5344 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	3d3030ef          	jal	4ef8 <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00004a17          	auipc	s4,0x4
    1342:	242a0a13          	addi	s4,s4,578 # 5580 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	ad0b0b13          	addi	s6,s6,-1328 # 5e18 <malloc+0xa1c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	3e5030ef          	jal	4f38 <open>
    1358:	84aa                	mv	s1,a0
    if(fd < 0){
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	3b7030ef          	jal	4f18 <write>
    if(n != 3){
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	3b5030ef          	jal	4f20 <close>
  for(int i = 0; i < 150; i++){
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	383030ef          	jal	4f00 <wait>
  unlink("truncfile");
    1382:	00004517          	auipc	a0,0x4
    1386:	1fe50513          	addi	a0,a0,510 # 5580 <malloc+0x184>
    138a:	3bf030ef          	jal	4f48 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	367030ef          	jal	4ef8 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	a3450513          	addi	a0,a0,-1484 # 5dd0 <malloc+0x9d4>
    13a4:	7a1030ef          	jal	5344 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	34f030ef          	jal	4ef8 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	a6a50513          	addi	a0,a0,-1430 # 5e20 <malloc+0xa24>
    13be:	787030ef          	jal	5344 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	335030ef          	jal	4ef8 <exit>

00000000000013c8 <exectest>:
{
    13c8:	715d                	addi	sp,sp,-80
    13ca:	e486                	sd	ra,72(sp)
    13cc:	e0a2                	sd	s0,64(sp)
    13ce:	f84a                	sd	s2,48(sp)
    13d0:	0880                	addi	s0,sp,80
    13d2:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    13d4:	00004797          	auipc	a5,0x4
    13d8:	15478793          	addi	a5,a5,340 # 5528 <malloc+0x12c>
    13dc:	fcf43023          	sd	a5,-64(s0)
    13e0:	00005797          	auipc	a5,0x5
    13e4:	a6078793          	addi	a5,a5,-1440 # 5e40 <malloc+0xa44>
    13e8:	fcf43423          	sd	a5,-56(s0)
    13ec:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    13f0:	00005517          	auipc	a0,0x5
    13f4:	a5850513          	addi	a0,a0,-1448 # 5e48 <malloc+0xa4c>
    13f8:	351030ef          	jal	4f48 <unlink>
  pid = fork();
    13fc:	2f5030ef          	jal	4ef0 <fork>
  if(pid < 0) {
    1400:	02054f63          	bltz	a0,143e <exectest+0x76>
    1404:	fc26                	sd	s1,56(sp)
    1406:	84aa                	mv	s1,a0
  if(pid == 0) {
    1408:	e935                	bnez	a0,147c <exectest+0xb4>
    close(1);
    140a:	4505                	li	a0,1
    140c:	315030ef          	jal	4f20 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1410:	20100593          	li	a1,513
    1414:	00005517          	auipc	a0,0x5
    1418:	a3450513          	addi	a0,a0,-1484 # 5e48 <malloc+0xa4c>
    141c:	31d030ef          	jal	4f38 <open>
    if(fd < 0) {
    1420:	02054a63          	bltz	a0,1454 <exectest+0x8c>
    if(fd != 1) {
    1424:	4785                	li	a5,1
    1426:	04f50163          	beq	a0,a5,1468 <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    142a:	85ca                	mv	a1,s2
    142c:	00005517          	auipc	a0,0x5
    1430:	a3c50513          	addi	a0,a0,-1476 # 5e68 <malloc+0xa6c>
    1434:	711030ef          	jal	5344 <printf>
      exit(1);
    1438:	4505                	li	a0,1
    143a:	2bf030ef          	jal	4ef8 <exit>
    143e:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1440:	85ca                	mv	a1,s2
    1442:	00005517          	auipc	a0,0x5
    1446:	97650513          	addi	a0,a0,-1674 # 5db8 <malloc+0x9bc>
    144a:	6fb030ef          	jal	5344 <printf>
     exit(1);
    144e:	4505                	li	a0,1
    1450:	2a9030ef          	jal	4ef8 <exit>
      printf("%s: create failed\n", s);
    1454:	85ca                	mv	a1,s2
    1456:	00005517          	auipc	a0,0x5
    145a:	9fa50513          	addi	a0,a0,-1542 # 5e50 <malloc+0xa54>
    145e:	6e7030ef          	jal	5344 <printf>
      exit(1);
    1462:	4505                	li	a0,1
    1464:	295030ef          	jal	4ef8 <exit>
    if(exec("echo", echoargv) < 0){
    1468:	fc040593          	addi	a1,s0,-64
    146c:	00004517          	auipc	a0,0x4
    1470:	0bc50513          	addi	a0,a0,188 # 5528 <malloc+0x12c>
    1474:	2bd030ef          	jal	4f30 <exec>
    1478:	00054d63          	bltz	a0,1492 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    147c:	fdc40513          	addi	a0,s0,-36
    1480:	281030ef          	jal	4f00 <wait>
    1484:	02951163          	bne	a0,s1,14a6 <exectest+0xde>
  if(xstatus != 0)
    1488:	fdc42503          	lw	a0,-36(s0)
    148c:	c50d                	beqz	a0,14b6 <exectest+0xee>
    exit(xstatus);
    148e:	26b030ef          	jal	4ef8 <exit>
      printf("%s: exec echo failed\n", s);
    1492:	85ca                	mv	a1,s2
    1494:	00005517          	auipc	a0,0x5
    1498:	9e450513          	addi	a0,a0,-1564 # 5e78 <malloc+0xa7c>
    149c:	6a9030ef          	jal	5344 <printf>
      exit(1);
    14a0:	4505                	li	a0,1
    14a2:	257030ef          	jal	4ef8 <exit>
    printf("%s: wait failed!\n", s);
    14a6:	85ca                	mv	a1,s2
    14a8:	00005517          	auipc	a0,0x5
    14ac:	9e850513          	addi	a0,a0,-1560 # 5e90 <malloc+0xa94>
    14b0:	695030ef          	jal	5344 <printf>
    14b4:	bfd1                	j	1488 <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    14b6:	4581                	li	a1,0
    14b8:	00005517          	auipc	a0,0x5
    14bc:	99050513          	addi	a0,a0,-1648 # 5e48 <malloc+0xa4c>
    14c0:	279030ef          	jal	4f38 <open>
  if(fd < 0) {
    14c4:	02054463          	bltz	a0,14ec <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    14c8:	4609                	li	a2,2
    14ca:	fb840593          	addi	a1,s0,-72
    14ce:	243030ef          	jal	4f10 <read>
    14d2:	4789                	li	a5,2
    14d4:	02f50663          	beq	a0,a5,1500 <exectest+0x138>
    printf("%s: read failed\n", s);
    14d8:	85ca                	mv	a1,s2
    14da:	00004517          	auipc	a0,0x4
    14de:	41e50513          	addi	a0,a0,1054 # 58f8 <malloc+0x4fc>
    14e2:	663030ef          	jal	5344 <printf>
    exit(1);
    14e6:	4505                	li	a0,1
    14e8:	211030ef          	jal	4ef8 <exit>
    printf("%s: open failed\n", s);
    14ec:	85ca                	mv	a1,s2
    14ee:	00005517          	auipc	a0,0x5
    14f2:	8e250513          	addi	a0,a0,-1822 # 5dd0 <malloc+0x9d4>
    14f6:	64f030ef          	jal	5344 <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	1fd030ef          	jal	4ef8 <exit>
  unlink("echo-ok");
    1500:	00005517          	auipc	a0,0x5
    1504:	94850513          	addi	a0,a0,-1720 # 5e48 <malloc+0xa4c>
    1508:	241030ef          	jal	4f48 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    150c:	fb844703          	lbu	a4,-72(s0)
    1510:	04f00793          	li	a5,79
    1514:	00f71863          	bne	a4,a5,1524 <exectest+0x15c>
    1518:	fb944703          	lbu	a4,-71(s0)
    151c:	04b00793          	li	a5,75
    1520:	00f70c63          	beq	a4,a5,1538 <exectest+0x170>
    printf("%s: wrong output\n", s);
    1524:	85ca                	mv	a1,s2
    1526:	00005517          	auipc	a0,0x5
    152a:	98250513          	addi	a0,a0,-1662 # 5ea8 <malloc+0xaac>
    152e:	617030ef          	jal	5344 <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	1c5030ef          	jal	4ef8 <exit>
    exit(0);
    1538:	4501                	li	a0,0
    153a:	1bf030ef          	jal	4ef8 <exit>

000000000000153e <pipe1>:
{
    153e:	711d                	addi	sp,sp,-96
    1540:	ec86                	sd	ra,88(sp)
    1542:	e8a2                	sd	s0,80(sp)
    1544:	e862                	sd	s8,16(sp)
    1546:	1080                	addi	s0,sp,96
    1548:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    154a:	fa840513          	addi	a0,s0,-88
    154e:	1bb030ef          	jal	4f08 <pipe>
    1552:	e925                	bnez	a0,15c2 <pipe1+0x84>
    1554:	e4a6                	sd	s1,72(sp)
    1556:	fc4e                	sd	s3,56(sp)
    1558:	84aa                	mv	s1,a0
  pid = fork();
    155a:	197030ef          	jal	4ef0 <fork>
    155e:	89aa                	mv	s3,a0
  if(pid == 0){
    1560:	c151                	beqz	a0,15e4 <pipe1+0xa6>
  } else if(pid > 0){
    1562:	16a05063          	blez	a0,16c2 <pipe1+0x184>
    1566:	e0ca                	sd	s2,64(sp)
    1568:	f852                	sd	s4,48(sp)
    close(fds[1]);
    156a:	fac42503          	lw	a0,-84(s0)
    156e:	1b3030ef          	jal	4f20 <close>
    total = 0;
    1572:	89a6                	mv	s3,s1
    cc = 1;
    1574:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1576:	0000aa17          	auipc	s4,0xa
    157a:	732a0a13          	addi	s4,s4,1842 # bca8 <buf>
    157e:	864a                	mv	a2,s2
    1580:	85d2                	mv	a1,s4
    1582:	fa842503          	lw	a0,-88(s0)
    1586:	18b030ef          	jal	4f10 <read>
    158a:	85aa                	mv	a1,a0
    158c:	0ea05963          	blez	a0,167e <pipe1+0x140>
    1590:	0000a797          	auipc	a5,0xa
    1594:	71878793          	addi	a5,a5,1816 # bca8 <buf>
    1598:	00b4863b          	addw	a2,s1,a1
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    159c:	0007c683          	lbu	a3,0(a5)
    15a0:	0ff4f713          	zext.b	a4,s1
    15a4:	0ae69d63          	bne	a3,a4,165e <pipe1+0x120>
    15a8:	2485                	addiw	s1,s1,1
      for(i = 0; i < n; i++){
    15aa:	0785                	addi	a5,a5,1
    15ac:	fec498e3          	bne	s1,a2,159c <pipe1+0x5e>
      total += n;
    15b0:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    15b4:	0019191b          	slliw	s2,s2,0x1
      if(cc > sizeof(buf))
    15b8:	678d                	lui	a5,0x3
    15ba:	fd27f2e3          	bgeu	a5,s2,157e <pipe1+0x40>
        cc = sizeof(buf);
    15be:	893e                	mv	s2,a5
    15c0:	bf7d                	j	157e <pipe1+0x40>
    15c2:	e4a6                	sd	s1,72(sp)
    15c4:	e0ca                	sd	s2,64(sp)
    15c6:	fc4e                	sd	s3,56(sp)
    15c8:	f852                	sd	s4,48(sp)
    15ca:	f456                	sd	s5,40(sp)
    15cc:	f05a                	sd	s6,32(sp)
    15ce:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    15d0:	85e2                	mv	a1,s8
    15d2:	00005517          	auipc	a0,0x5
    15d6:	8ee50513          	addi	a0,a0,-1810 # 5ec0 <malloc+0xac4>
    15da:	56b030ef          	jal	5344 <printf>
    exit(1);
    15de:	4505                	li	a0,1
    15e0:	119030ef          	jal	4ef8 <exit>
    15e4:	e0ca                	sd	s2,64(sp)
    15e6:	f852                	sd	s4,48(sp)
    15e8:	f456                	sd	s5,40(sp)
    15ea:	f05a                	sd	s6,32(sp)
    15ec:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    15ee:	fa842503          	lw	a0,-88(s0)
    15f2:	12f030ef          	jal	4f20 <close>
    for(n = 0; n < N; n++){
    15f6:	0000ab17          	auipc	s6,0xa
    15fa:	6b2b0b13          	addi	s6,s6,1714 # bca8 <buf>
    15fe:	416004bb          	negw	s1,s6
    1602:	0ff4f493          	zext.b	s1,s1
    1606:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    160a:	40900a13          	li	s4,1033
    160e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1610:	6a85                	lui	s5,0x1
    1612:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0x65>
{
    1616:	87da                	mv	a5,s6
        buf[i] = seq++;
    1618:	0097873b          	addw	a4,a5,s1
    161c:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x300>
      for(i = 0; i < SZ; i++)
    1620:	0785                	addi	a5,a5,1
    1622:	ff279be3          	bne	a5,s2,1618 <pipe1+0xda>
      if(write(fds[1], buf, SZ) != SZ){
    1626:	8652                	mv	a2,s4
    1628:	85de                	mv	a1,s7
    162a:	fac42503          	lw	a0,-84(s0)
    162e:	0eb030ef          	jal	4f18 <write>
    1632:	01451c63          	bne	a0,s4,164a <pipe1+0x10c>
    1636:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    163a:	24a5                	addiw	s1,s1,9
    163c:	0ff4f493          	zext.b	s1,s1
    1640:	fd599be3          	bne	s3,s5,1616 <pipe1+0xd8>
    exit(0);
    1644:	4501                	li	a0,0
    1646:	0b3030ef          	jal	4ef8 <exit>
        printf("%s: pipe1 oops 1\n", s);
    164a:	85e2                	mv	a1,s8
    164c:	00005517          	auipc	a0,0x5
    1650:	88c50513          	addi	a0,a0,-1908 # 5ed8 <malloc+0xadc>
    1654:	4f1030ef          	jal	5344 <printf>
        exit(1);
    1658:	4505                	li	a0,1
    165a:	09f030ef          	jal	4ef8 <exit>
          printf("%s: pipe1 oops 2\n", s);
    165e:	85e2                	mv	a1,s8
    1660:	00005517          	auipc	a0,0x5
    1664:	89050513          	addi	a0,a0,-1904 # 5ef0 <malloc+0xaf4>
    1668:	4dd030ef          	jal	5344 <printf>
          return;
    166c:	64a6                	ld	s1,72(sp)
    166e:	6906                	ld	s2,64(sp)
    1670:	79e2                	ld	s3,56(sp)
    1672:	7a42                	ld	s4,48(sp)
}
    1674:	60e6                	ld	ra,88(sp)
    1676:	6446                	ld	s0,80(sp)
    1678:	6c42                	ld	s8,16(sp)
    167a:	6125                	addi	sp,sp,96
    167c:	8082                	ret
    if(total != N * SZ){
    167e:	6785                	lui	a5,0x1
    1680:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0x65>
    1684:	02f98063          	beq	s3,a5,16a4 <pipe1+0x166>
    1688:	f456                	sd	s5,40(sp)
    168a:	f05a                	sd	s6,32(sp)
    168c:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    168e:	864e                	mv	a2,s3
    1690:	85e2                	mv	a1,s8
    1692:	00005517          	auipc	a0,0x5
    1696:	87650513          	addi	a0,a0,-1930 # 5f08 <malloc+0xb0c>
    169a:	4ab030ef          	jal	5344 <printf>
      exit(1);
    169e:	4505                	li	a0,1
    16a0:	059030ef          	jal	4ef8 <exit>
    16a4:	f456                	sd	s5,40(sp)
    16a6:	f05a                	sd	s6,32(sp)
    16a8:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    16aa:	fa842503          	lw	a0,-88(s0)
    16ae:	073030ef          	jal	4f20 <close>
    wait(&xstatus);
    16b2:	fa440513          	addi	a0,s0,-92
    16b6:	04b030ef          	jal	4f00 <wait>
    exit(xstatus);
    16ba:	fa442503          	lw	a0,-92(s0)
    16be:	03b030ef          	jal	4ef8 <exit>
    16c2:	e0ca                	sd	s2,64(sp)
    16c4:	f852                	sd	s4,48(sp)
    16c6:	f456                	sd	s5,40(sp)
    16c8:	f05a                	sd	s6,32(sp)
    16ca:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    16cc:	85e2                	mv	a1,s8
    16ce:	00005517          	auipc	a0,0x5
    16d2:	85a50513          	addi	a0,a0,-1958 # 5f28 <malloc+0xb2c>
    16d6:	46f030ef          	jal	5344 <printf>
    exit(1);
    16da:	4505                	li	a0,1
    16dc:	01d030ef          	jal	4ef8 <exit>

00000000000016e0 <exitwait>:
{
    16e0:	715d                	addi	sp,sp,-80
    16e2:	e486                	sd	ra,72(sp)
    16e4:	e0a2                	sd	s0,64(sp)
    16e6:	fc26                	sd	s1,56(sp)
    16e8:	f84a                	sd	s2,48(sp)
    16ea:	f44e                	sd	s3,40(sp)
    16ec:	f052                	sd	s4,32(sp)
    16ee:	ec56                	sd	s5,24(sp)
    16f0:	0880                	addi	s0,sp,80
    16f2:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    16f4:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    16f6:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    16fa:	06400a13          	li	s4,100
    pid = fork();
    16fe:	7f2030ef          	jal	4ef0 <fork>
    1702:	84aa                	mv	s1,a0
    if(pid < 0){
    1704:	02054863          	bltz	a0,1734 <exitwait+0x54>
    if(pid){
    1708:	c525                	beqz	a0,1770 <exitwait+0x90>
      if(wait(&xstate) != pid){
    170a:	854e                	mv	a0,s3
    170c:	7f4030ef          	jal	4f00 <wait>
    1710:	02951c63          	bne	a0,s1,1748 <exitwait+0x68>
      if(i != xstate) {
    1714:	fbc42783          	lw	a5,-68(s0)
    1718:	05279263          	bne	a5,s2,175c <exitwait+0x7c>
  for(i = 0; i < 100; i++){
    171c:	2905                	addiw	s2,s2,1
    171e:	ff4910e3          	bne	s2,s4,16fe <exitwait+0x1e>
}
    1722:	60a6                	ld	ra,72(sp)
    1724:	6406                	ld	s0,64(sp)
    1726:	74e2                	ld	s1,56(sp)
    1728:	7942                	ld	s2,48(sp)
    172a:	79a2                	ld	s3,40(sp)
    172c:	7a02                	ld	s4,32(sp)
    172e:	6ae2                	ld	s5,24(sp)
    1730:	6161                	addi	sp,sp,80
    1732:	8082                	ret
      printf("%s: fork failed\n", s);
    1734:	85d6                	mv	a1,s5
    1736:	00004517          	auipc	a0,0x4
    173a:	68250513          	addi	a0,a0,1666 # 5db8 <malloc+0x9bc>
    173e:	407030ef          	jal	5344 <printf>
      exit(1);
    1742:	4505                	li	a0,1
    1744:	7b4030ef          	jal	4ef8 <exit>
        printf("%s: wait wrong pid\n", s);
    1748:	85d6                	mv	a1,s5
    174a:	00004517          	auipc	a0,0x4
    174e:	7f650513          	addi	a0,a0,2038 # 5f40 <malloc+0xb44>
    1752:	3f3030ef          	jal	5344 <printf>
        exit(1);
    1756:	4505                	li	a0,1
    1758:	7a0030ef          	jal	4ef8 <exit>
        printf("%s: wait wrong exit status\n", s);
    175c:	85d6                	mv	a1,s5
    175e:	00004517          	auipc	a0,0x4
    1762:	7fa50513          	addi	a0,a0,2042 # 5f58 <malloc+0xb5c>
    1766:	3df030ef          	jal	5344 <printf>
        exit(1);
    176a:	4505                	li	a0,1
    176c:	78c030ef          	jal	4ef8 <exit>
      exit(i);
    1770:	854a                	mv	a0,s2
    1772:	786030ef          	jal	4ef8 <exit>

0000000000001776 <twochildren>:
{
    1776:	1101                	addi	sp,sp,-32
    1778:	ec06                	sd	ra,24(sp)
    177a:	e822                	sd	s0,16(sp)
    177c:	e426                	sd	s1,8(sp)
    177e:	e04a                	sd	s2,0(sp)
    1780:	1000                	addi	s0,sp,32
    1782:	892a                	mv	s2,a0
    1784:	3e800493          	li	s1,1000
    int pid1 = fork();
    1788:	768030ef          	jal	4ef0 <fork>
    if(pid1 < 0){
    178c:	02054663          	bltz	a0,17b8 <twochildren+0x42>
    if(pid1 == 0){
    1790:	cd15                	beqz	a0,17cc <twochildren+0x56>
      int pid2 = fork();
    1792:	75e030ef          	jal	4ef0 <fork>
      if(pid2 < 0){
    1796:	02054d63          	bltz	a0,17d0 <twochildren+0x5a>
      if(pid2 == 0){
    179a:	c529                	beqz	a0,17e4 <twochildren+0x6e>
        wait(0);
    179c:	4501                	li	a0,0
    179e:	762030ef          	jal	4f00 <wait>
        wait(0);
    17a2:	4501                	li	a0,0
    17a4:	75c030ef          	jal	4f00 <wait>
  for(int i = 0; i < 1000; i++){
    17a8:	34fd                	addiw	s1,s1,-1
    17aa:	fcf9                	bnez	s1,1788 <twochildren+0x12>
}
    17ac:	60e2                	ld	ra,24(sp)
    17ae:	6442                	ld	s0,16(sp)
    17b0:	64a2                	ld	s1,8(sp)
    17b2:	6902                	ld	s2,0(sp)
    17b4:	6105                	addi	sp,sp,32
    17b6:	8082                	ret
      printf("%s: fork failed\n", s);
    17b8:	85ca                	mv	a1,s2
    17ba:	00004517          	auipc	a0,0x4
    17be:	5fe50513          	addi	a0,a0,1534 # 5db8 <malloc+0x9bc>
    17c2:	383030ef          	jal	5344 <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	730030ef          	jal	4ef8 <exit>
      exit(0);
    17cc:	72c030ef          	jal	4ef8 <exit>
        printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00004517          	auipc	a0,0x4
    17d6:	5e650513          	addi	a0,a0,1510 # 5db8 <malloc+0x9bc>
    17da:	36b030ef          	jal	5344 <printf>
        exit(1);
    17de:	4505                	li	a0,1
    17e0:	718030ef          	jal	4ef8 <exit>
        exit(0);
    17e4:	714030ef          	jal	4ef8 <exit>

00000000000017e8 <forkfork>:
{
    17e8:	7179                	addi	sp,sp,-48
    17ea:	f406                	sd	ra,40(sp)
    17ec:	f022                	sd	s0,32(sp)
    17ee:	ec26                	sd	s1,24(sp)
    17f0:	1800                	addi	s0,sp,48
    17f2:	84aa                	mv	s1,a0
    int pid = fork();
    17f4:	6fc030ef          	jal	4ef0 <fork>
    if(pid < 0){
    17f8:	02054b63          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    17fc:	c139                	beqz	a0,1842 <forkfork+0x5a>
    int pid = fork();
    17fe:	6f2030ef          	jal	4ef0 <fork>
    if(pid < 0){
    1802:	02054663          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    1806:	cd15                	beqz	a0,1842 <forkfork+0x5a>
    wait(&xstatus);
    1808:	fdc40513          	addi	a0,s0,-36
    180c:	6f4030ef          	jal	4f00 <wait>
    if(xstatus != 0) {
    1810:	fdc42783          	lw	a5,-36(s0)
    1814:	ebb9                	bnez	a5,186a <forkfork+0x82>
    wait(&xstatus);
    1816:	fdc40513          	addi	a0,s0,-36
    181a:	6e6030ef          	jal	4f00 <wait>
    if(xstatus != 0) {
    181e:	fdc42783          	lw	a5,-36(s0)
    1822:	e7a1                	bnez	a5,186a <forkfork+0x82>
}
    1824:	70a2                	ld	ra,40(sp)
    1826:	7402                	ld	s0,32(sp)
    1828:	64e2                	ld	s1,24(sp)
    182a:	6145                	addi	sp,sp,48
    182c:	8082                	ret
      printf("%s: fork failed", s);
    182e:	85a6                	mv	a1,s1
    1830:	00004517          	auipc	a0,0x4
    1834:	74850513          	addi	a0,a0,1864 # 5f78 <malloc+0xb7c>
    1838:	30d030ef          	jal	5344 <printf>
      exit(1);
    183c:	4505                	li	a0,1
    183e:	6ba030ef          	jal	4ef8 <exit>
{
    1842:	0c800493          	li	s1,200
        int pid1 = fork();
    1846:	6aa030ef          	jal	4ef0 <fork>
        if(pid1 < 0){
    184a:	00054b63          	bltz	a0,1860 <forkfork+0x78>
        if(pid1 == 0){
    184e:	cd01                	beqz	a0,1866 <forkfork+0x7e>
        wait(0);
    1850:	4501                	li	a0,0
    1852:	6ae030ef          	jal	4f00 <wait>
      for(int j = 0; j < 200; j++){
    1856:	34fd                	addiw	s1,s1,-1
    1858:	f4fd                	bnez	s1,1846 <forkfork+0x5e>
      exit(0);
    185a:	4501                	li	a0,0
    185c:	69c030ef          	jal	4ef8 <exit>
          exit(1);
    1860:	4505                	li	a0,1
    1862:	696030ef          	jal	4ef8 <exit>
          exit(0);
    1866:	692030ef          	jal	4ef8 <exit>
      printf("%s: fork in child failed", s);
    186a:	85a6                	mv	a1,s1
    186c:	00004517          	auipc	a0,0x4
    1870:	71c50513          	addi	a0,a0,1820 # 5f88 <malloc+0xb8c>
    1874:	2d1030ef          	jal	5344 <printf>
      exit(1);
    1878:	4505                	li	a0,1
    187a:	67e030ef          	jal	4ef8 <exit>

000000000000187e <reparent2>:
{
    187e:	1101                	addi	sp,sp,-32
    1880:	ec06                	sd	ra,24(sp)
    1882:	e822                	sd	s0,16(sp)
    1884:	e426                	sd	s1,8(sp)
    1886:	1000                	addi	s0,sp,32
    1888:	32000493          	li	s1,800
    int pid1 = fork();
    188c:	664030ef          	jal	4ef0 <fork>
    if(pid1 < 0){
    1890:	00054b63          	bltz	a0,18a6 <reparent2+0x28>
    if(pid1 == 0){
    1894:	c115                	beqz	a0,18b8 <reparent2+0x3a>
    wait(0);
    1896:	4501                	li	a0,0
    1898:	668030ef          	jal	4f00 <wait>
  for(int i = 0; i < 800; i++){
    189c:	34fd                	addiw	s1,s1,-1
    189e:	f4fd                	bnez	s1,188c <reparent2+0xe>
  exit(0);
    18a0:	4501                	li	a0,0
    18a2:	656030ef          	jal	4ef8 <exit>
      printf("fork failed\n");
    18a6:	00006517          	auipc	a0,0x6
    18aa:	aba50513          	addi	a0,a0,-1350 # 7360 <malloc+0x1f64>
    18ae:	297030ef          	jal	5344 <printf>
      exit(1);
    18b2:	4505                	li	a0,1
    18b4:	644030ef          	jal	4ef8 <exit>
      fork();
    18b8:	638030ef          	jal	4ef0 <fork>
      fork();
    18bc:	634030ef          	jal	4ef0 <fork>
      exit(0);
    18c0:	4501                	li	a0,0
    18c2:	636030ef          	jal	4ef8 <exit>

00000000000018c6 <createdelete>:
{
    18c6:	7135                	addi	sp,sp,-160
    18c8:	ed06                	sd	ra,152(sp)
    18ca:	e922                	sd	s0,144(sp)
    18cc:	e526                	sd	s1,136(sp)
    18ce:	e14a                	sd	s2,128(sp)
    18d0:	fcce                	sd	s3,120(sp)
    18d2:	f8d2                	sd	s4,112(sp)
    18d4:	f4d6                	sd	s5,104(sp)
    18d6:	f0da                	sd	s6,96(sp)
    18d8:	ecde                	sd	s7,88(sp)
    18da:	e8e2                	sd	s8,80(sp)
    18dc:	e4e6                	sd	s9,72(sp)
    18de:	e0ea                	sd	s10,64(sp)
    18e0:	fc6e                	sd	s11,56(sp)
    18e2:	1100                	addi	s0,sp,160
    18e4:	8daa                	mv	s11,a0
  for(pi = 0; pi < NCHILD; pi++){
    18e6:	4901                	li	s2,0
    18e8:	4991                	li	s3,4
    pid = fork();
    18ea:	606030ef          	jal	4ef0 <fork>
    18ee:	84aa                	mv	s1,a0
    if(pid < 0){
    18f0:	04054063          	bltz	a0,1930 <createdelete+0x6a>
    if(pid == 0){
    18f4:	c921                	beqz	a0,1944 <createdelete+0x7e>
  for(pi = 0; pi < NCHILD; pi++){
    18f6:	2905                	addiw	s2,s2,1
    18f8:	ff3919e3          	bne	s2,s3,18ea <createdelete+0x24>
    18fc:	4491                	li	s1,4
    wait(&xstatus);
    18fe:	f6c40913          	addi	s2,s0,-148
    1902:	854a                	mv	a0,s2
    1904:	5fc030ef          	jal	4f00 <wait>
    if(xstatus != 0)
    1908:	f6c42a83          	lw	s5,-148(s0)
    190c:	0c0a9263          	bnez	s5,19d0 <createdelete+0x10a>
  for(pi = 0; pi < NCHILD; pi++){
    1910:	34fd                	addiw	s1,s1,-1
    1912:	f8e5                	bnez	s1,1902 <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    1914:	f6040923          	sb	zero,-142(s0)
    1918:	03000913          	li	s2,48
    191c:	5a7d                	li	s4,-1
      if((i == 0 || i >= N/2) && fd < 0){
    191e:	4d25                	li	s10,9
    1920:	07000c93          	li	s9,112
      fd = open(name, 0);
    1924:	f7040c13          	addi	s8,s0,-144
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1928:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    192a:	07400b13          	li	s6,116
    192e:	aa39                	j	1a4c <createdelete+0x186>
      printf("%s: fork failed\n", s);
    1930:	85ee                	mv	a1,s11
    1932:	00004517          	auipc	a0,0x4
    1936:	48650513          	addi	a0,a0,1158 # 5db8 <malloc+0x9bc>
    193a:	20b030ef          	jal	5344 <printf>
      exit(1);
    193e:	4505                	li	a0,1
    1940:	5b8030ef          	jal	4ef8 <exit>
      name[0] = 'p' + pi;
    1944:	0709091b          	addiw	s2,s2,112
    1948:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    194c:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1950:	f7040913          	addi	s2,s0,-144
    1954:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1958:	4a51                	li	s4,20
    195a:	a815                	j	198e <createdelete+0xc8>
          printf("%s: create failed\n", s);
    195c:	85ee                	mv	a1,s11
    195e:	00004517          	auipc	a0,0x4
    1962:	4f250513          	addi	a0,a0,1266 # 5e50 <malloc+0xa54>
    1966:	1df030ef          	jal	5344 <printf>
          exit(1);
    196a:	4505                	li	a0,1
    196c:	58c030ef          	jal	4ef8 <exit>
          name[1] = '0' + (i / 2);
    1970:	01f4d79b          	srliw	a5,s1,0x1f
    1974:	9fa5                	addw	a5,a5,s1
    1976:	4017d79b          	sraiw	a5,a5,0x1
    197a:	0307879b          	addiw	a5,a5,48
    197e:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    1982:	854a                	mv	a0,s2
    1984:	5c4030ef          	jal	4f48 <unlink>
    1988:	02054a63          	bltz	a0,19bc <createdelete+0xf6>
      for(i = 0; i < N; i++){
    198c:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    198e:	0304879b          	addiw	a5,s1,48
    1992:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1996:	85ce                	mv	a1,s3
    1998:	854a                	mv	a0,s2
    199a:	59e030ef          	jal	4f38 <open>
        if(fd < 0){
    199e:	fa054fe3          	bltz	a0,195c <createdelete+0x96>
        close(fd);
    19a2:	57e030ef          	jal	4f20 <close>
        if(i > 0 && (i % 2 ) == 0){
    19a6:	fe9053e3          	blez	s1,198c <createdelete+0xc6>
    19aa:	0014f793          	andi	a5,s1,1
    19ae:	d3e9                	beqz	a5,1970 <createdelete+0xaa>
      for(i = 0; i < N; i++){
    19b0:	2485                	addiw	s1,s1,1
    19b2:	fd449ee3          	bne	s1,s4,198e <createdelete+0xc8>
      exit(0);
    19b6:	4501                	li	a0,0
    19b8:	540030ef          	jal	4ef8 <exit>
            printf("%s: unlink failed\n", s);
    19bc:	85ee                	mv	a1,s11
    19be:	00004517          	auipc	a0,0x4
    19c2:	5ea50513          	addi	a0,a0,1514 # 5fa8 <malloc+0xbac>
    19c6:	17f030ef          	jal	5344 <printf>
            exit(1);
    19ca:	4505                	li	a0,1
    19cc:	52c030ef          	jal	4ef8 <exit>
      exit(1);
    19d0:	4505                	li	a0,1
    19d2:	526030ef          	jal	4ef8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    19d6:	054bf263          	bgeu	s7,s4,1a1a <createdelete+0x154>
      if(fd >= 0)
    19da:	04055e63          	bgez	a0,1a36 <createdelete+0x170>
    for(pi = 0; pi < NCHILD; pi++){
    19de:	2485                	addiw	s1,s1,1
    19e0:	0ff4f493          	zext.b	s1,s1
    19e4:	05648c63          	beq	s1,s6,1a3c <createdelete+0x176>
      name[0] = 'p' + pi;
    19e8:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    19ec:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    19f0:	4581                	li	a1,0
    19f2:	8562                	mv	a0,s8
    19f4:	544030ef          	jal	4f38 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    19f8:	01f5579b          	srliw	a5,a0,0x1f
    19fc:	dfe9                	beqz	a5,19d6 <createdelete+0x110>
    19fe:	fc098ce3          	beqz	s3,19d6 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1a02:	f7040613          	addi	a2,s0,-144
    1a06:	85ee                	mv	a1,s11
    1a08:	00004517          	auipc	a0,0x4
    1a0c:	5b850513          	addi	a0,a0,1464 # 5fc0 <malloc+0xbc4>
    1a10:	135030ef          	jal	5344 <printf>
        exit(1);
    1a14:	4505                	li	a0,1
    1a16:	4e2030ef          	jal	4ef8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a1a:	fc0542e3          	bltz	a0,19de <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a1e:	f7040613          	addi	a2,s0,-144
    1a22:	85ee                	mv	a1,s11
    1a24:	00004517          	auipc	a0,0x4
    1a28:	5c450513          	addi	a0,a0,1476 # 5fe8 <malloc+0xbec>
    1a2c:	119030ef          	jal	5344 <printf>
        exit(1);
    1a30:	4505                	li	a0,1
    1a32:	4c6030ef          	jal	4ef8 <exit>
        close(fd);
    1a36:	4ea030ef          	jal	4f20 <close>
    1a3a:	b755                	j	19de <createdelete+0x118>
  for(i = 0; i < N; i++){
    1a3c:	2a85                	addiw	s5,s5,1
    1a3e:	2a05                	addiw	s4,s4,1
    1a40:	2905                	addiw	s2,s2,1
    1a42:	0ff97913          	zext.b	s2,s2
    1a46:	47d1                	li	a5,20
    1a48:	00fa8a63          	beq	s5,a5,1a5c <createdelete+0x196>
      if((i == 0 || i >= N/2) && fd < 0){
    1a4c:	001ab993          	seqz	s3,s5
    1a50:	015d27b3          	slt	a5,s10,s5
    1a54:	00f9e9b3          	or	s3,s3,a5
    1a58:	84e6                	mv	s1,s9
    1a5a:	b779                	j	19e8 <createdelete+0x122>
    1a5c:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1a60:	07000b13          	li	s6,112
      unlink(name);
    1a64:	f7040a13          	addi	s4,s0,-144
    for(pi = 0; pi < NCHILD; pi++){
    1a68:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1a6c:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    1a70:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    1a72:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1a76:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1a7a:	8552                	mv	a0,s4
    1a7c:	4cc030ef          	jal	4f48 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1a80:	2485                	addiw	s1,s1,1
    1a82:	0ff4f493          	zext.b	s1,s1
    1a86:	ff3496e3          	bne	s1,s3,1a72 <createdelete+0x1ac>
  for(i = 0; i < N; i++){
    1a8a:	2905                	addiw	s2,s2,1
    1a8c:	0ff97913          	zext.b	s2,s2
    1a90:	ff5910e3          	bne	s2,s5,1a70 <createdelete+0x1aa>
}
    1a94:	60ea                	ld	ra,152(sp)
    1a96:	644a                	ld	s0,144(sp)
    1a98:	64aa                	ld	s1,136(sp)
    1a9a:	690a                	ld	s2,128(sp)
    1a9c:	79e6                	ld	s3,120(sp)
    1a9e:	7a46                	ld	s4,112(sp)
    1aa0:	7aa6                	ld	s5,104(sp)
    1aa2:	7b06                	ld	s6,96(sp)
    1aa4:	6be6                	ld	s7,88(sp)
    1aa6:	6c46                	ld	s8,80(sp)
    1aa8:	6ca6                	ld	s9,72(sp)
    1aaa:	6d06                	ld	s10,64(sp)
    1aac:	7de2                	ld	s11,56(sp)
    1aae:	610d                	addi	sp,sp,160
    1ab0:	8082                	ret

0000000000001ab2 <linkunlink>:
{
    1ab2:	711d                	addi	sp,sp,-96
    1ab4:	ec86                	sd	ra,88(sp)
    1ab6:	e8a2                	sd	s0,80(sp)
    1ab8:	e4a6                	sd	s1,72(sp)
    1aba:	e0ca                	sd	s2,64(sp)
    1abc:	fc4e                	sd	s3,56(sp)
    1abe:	f852                	sd	s4,48(sp)
    1ac0:	f456                	sd	s5,40(sp)
    1ac2:	f05a                	sd	s6,32(sp)
    1ac4:	ec5e                	sd	s7,24(sp)
    1ac6:	e862                	sd	s8,16(sp)
    1ac8:	e466                	sd	s9,8(sp)
    1aca:	e06a                	sd	s10,0(sp)
    1acc:	1080                	addi	s0,sp,96
    1ace:	84aa                	mv	s1,a0
  unlink("x");
    1ad0:	00004517          	auipc	a0,0x4
    1ad4:	ac850513          	addi	a0,a0,-1336 # 5598 <malloc+0x19c>
    1ad8:	470030ef          	jal	4f48 <unlink>
  pid = fork();
    1adc:	414030ef          	jal	4ef0 <fork>
  if(pid < 0){
    1ae0:	04054363          	bltz	a0,1b26 <linkunlink+0x74>
    1ae4:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1ae6:	06100913          	li	s2,97
    1aea:	c111                	beqz	a0,1aee <linkunlink+0x3c>
    1aec:	4905                	li	s2,1
    1aee:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1af2:	41c65ab7          	lui	s5,0x41c65
    1af6:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c561c5>
    1afa:	6a0d                	lui	s4,0x3
    1afc:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x339>
    if((x % 3) == 0){
    1b00:	000ab9b7          	lui	s3,0xab
    1b04:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9be03>
    1b08:	09b2                	slli	s3,s3,0xc
    1b0a:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b0e:	4b85                	li	s7,1
      unlink("x");
    1b10:	00004b17          	auipc	s6,0x4
    1b14:	a88b0b13          	addi	s6,s6,-1400 # 5598 <malloc+0x19c>
      link("cat", "x");
    1b18:	00004c97          	auipc	s9,0x4
    1b1c:	4f8c8c93          	addi	s9,s9,1272 # 6010 <malloc+0xc14>
      close(open("x", O_RDWR | O_CREATE));
    1b20:	20200c13          	li	s8,514
    1b24:	a03d                	j	1b52 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b26:	85a6                	mv	a1,s1
    1b28:	00004517          	auipc	a0,0x4
    1b2c:	29050513          	addi	a0,a0,656 # 5db8 <malloc+0x9bc>
    1b30:	015030ef          	jal	5344 <printf>
    exit(1);
    1b34:	4505                	li	a0,1
    1b36:	3c2030ef          	jal	4ef8 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b3a:	85e2                	mv	a1,s8
    1b3c:	855a                	mv	a0,s6
    1b3e:	3fa030ef          	jal	4f38 <open>
    1b42:	3de030ef          	jal	4f20 <close>
    1b46:	a021                	j	1b4e <linkunlink+0x9c>
      unlink("x");
    1b48:	855a                	mv	a0,s6
    1b4a:	3fe030ef          	jal	4f48 <unlink>
  for(i = 0; i < 100; i++){
    1b4e:	34fd                	addiw	s1,s1,-1
    1b50:	c885                	beqz	s1,1b80 <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    1b52:	035907bb          	mulw	a5,s2,s5
    1b56:	00fa07bb          	addw	a5,s4,a5
    1b5a:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1b5c:	02079713          	slli	a4,a5,0x20
    1b60:	9301                	srli	a4,a4,0x20
    1b62:	03370733          	mul	a4,a4,s3
    1b66:	9305                	srli	a4,a4,0x21
    1b68:	0017169b          	slliw	a3,a4,0x1
    1b6c:	9f35                	addw	a4,a4,a3
    1b6e:	9f99                	subw	a5,a5,a4
    1b70:	d7e9                	beqz	a5,1b3a <linkunlink+0x88>
    } else if((x % 3) == 1){
    1b72:	fd779be3          	bne	a5,s7,1b48 <linkunlink+0x96>
      link("cat", "x");
    1b76:	85da                	mv	a1,s6
    1b78:	8566                	mv	a0,s9
    1b7a:	3de030ef          	jal	4f58 <link>
    1b7e:	bfc1                	j	1b4e <linkunlink+0x9c>
  if(pid)
    1b80:	020d0363          	beqz	s10,1ba6 <linkunlink+0xf4>
    wait(0);
    1b84:	4501                	li	a0,0
    1b86:	37a030ef          	jal	4f00 <wait>
}
    1b8a:	60e6                	ld	ra,88(sp)
    1b8c:	6446                	ld	s0,80(sp)
    1b8e:	64a6                	ld	s1,72(sp)
    1b90:	6906                	ld	s2,64(sp)
    1b92:	79e2                	ld	s3,56(sp)
    1b94:	7a42                	ld	s4,48(sp)
    1b96:	7aa2                	ld	s5,40(sp)
    1b98:	7b02                	ld	s6,32(sp)
    1b9a:	6be2                	ld	s7,24(sp)
    1b9c:	6c42                	ld	s8,16(sp)
    1b9e:	6ca2                	ld	s9,8(sp)
    1ba0:	6d02                	ld	s10,0(sp)
    1ba2:	6125                	addi	sp,sp,96
    1ba4:	8082                	ret
    exit(0);
    1ba6:	4501                	li	a0,0
    1ba8:	350030ef          	jal	4ef8 <exit>

0000000000001bac <forktest>:
{
    1bac:	7179                	addi	sp,sp,-48
    1bae:	f406                	sd	ra,40(sp)
    1bb0:	f022                	sd	s0,32(sp)
    1bb2:	ec26                	sd	s1,24(sp)
    1bb4:	e84a                	sd	s2,16(sp)
    1bb6:	e44e                	sd	s3,8(sp)
    1bb8:	1800                	addi	s0,sp,48
    1bba:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1bbc:	4481                	li	s1,0
    1bbe:	3e800913          	li	s2,1000
    pid = fork();
    1bc2:	32e030ef          	jal	4ef0 <fork>
    if(pid < 0)
    1bc6:	06054063          	bltz	a0,1c26 <forktest+0x7a>
    if(pid == 0)
    1bca:	cd11                	beqz	a0,1be6 <forktest+0x3a>
  for(n=0; n<N; n++){
    1bcc:	2485                	addiw	s1,s1,1
    1bce:	ff249ae3          	bne	s1,s2,1bc2 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1bd2:	85ce                	mv	a1,s3
    1bd4:	00004517          	auipc	a0,0x4
    1bd8:	48c50513          	addi	a0,a0,1164 # 6060 <malloc+0xc64>
    1bdc:	768030ef          	jal	5344 <printf>
    exit(1);
    1be0:	4505                	li	a0,1
    1be2:	316030ef          	jal	4ef8 <exit>
      exit(0);
    1be6:	312030ef          	jal	4ef8 <exit>
    printf("%s: no fork at all!\n", s);
    1bea:	85ce                	mv	a1,s3
    1bec:	00004517          	auipc	a0,0x4
    1bf0:	42c50513          	addi	a0,a0,1068 # 6018 <malloc+0xc1c>
    1bf4:	750030ef          	jal	5344 <printf>
    exit(1);
    1bf8:	4505                	li	a0,1
    1bfa:	2fe030ef          	jal	4ef8 <exit>
      printf("%s: wait stopped early\n", s);
    1bfe:	85ce                	mv	a1,s3
    1c00:	00004517          	auipc	a0,0x4
    1c04:	43050513          	addi	a0,a0,1072 # 6030 <malloc+0xc34>
    1c08:	73c030ef          	jal	5344 <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	2ea030ef          	jal	4ef8 <exit>
    printf("%s: wait got too many\n", s);
    1c12:	85ce                	mv	a1,s3
    1c14:	00004517          	auipc	a0,0x4
    1c18:	43450513          	addi	a0,a0,1076 # 6048 <malloc+0xc4c>
    1c1c:	728030ef          	jal	5344 <printf>
    exit(1);
    1c20:	4505                	li	a0,1
    1c22:	2d6030ef          	jal	4ef8 <exit>
  if (n == 0) {
    1c26:	d0f1                	beqz	s1,1bea <forktest+0x3e>
  for(; n > 0; n--){
    1c28:	00905963          	blez	s1,1c3a <forktest+0x8e>
    if(wait(0) < 0){
    1c2c:	4501                	li	a0,0
    1c2e:	2d2030ef          	jal	4f00 <wait>
    1c32:	fc0546e3          	bltz	a0,1bfe <forktest+0x52>
  for(; n > 0; n--){
    1c36:	34fd                	addiw	s1,s1,-1
    1c38:	f8f5                	bnez	s1,1c2c <forktest+0x80>
  if(wait(0) != -1){
    1c3a:	4501                	li	a0,0
    1c3c:	2c4030ef          	jal	4f00 <wait>
    1c40:	57fd                	li	a5,-1
    1c42:	fcf518e3          	bne	a0,a5,1c12 <forktest+0x66>
}
    1c46:	70a2                	ld	ra,40(sp)
    1c48:	7402                	ld	s0,32(sp)
    1c4a:	64e2                	ld	s1,24(sp)
    1c4c:	6942                	ld	s2,16(sp)
    1c4e:	69a2                	ld	s3,8(sp)
    1c50:	6145                	addi	sp,sp,48
    1c52:	8082                	ret

0000000000001c54 <kernmem>:
{
    1c54:	715d                	addi	sp,sp,-80
    1c56:	e486                	sd	ra,72(sp)
    1c58:	e0a2                	sd	s0,64(sp)
    1c5a:	fc26                	sd	s1,56(sp)
    1c5c:	f84a                	sd	s2,48(sp)
    1c5e:	f44e                	sd	s3,40(sp)
    1c60:	f052                	sd	s4,32(sp)
    1c62:	ec56                	sd	s5,24(sp)
    1c64:	e85a                	sd	s6,16(sp)
    1c66:	0880                	addi	s0,sp,80
    1c68:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c6a:	4485                	li	s1,1
    1c6c:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1c6e:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    1c72:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c74:	69b1                	lui	s3,0xc
    1c76:	35098993          	addi	s3,s3,848 # c350 <buf+0x6a8>
    1c7a:	1003d937          	lui	s2,0x1003d
    1c7e:	090e                	slli	s2,s2,0x3
    1c80:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e7d8>
    pid = fork();
    1c84:	26c030ef          	jal	4ef0 <fork>
    if(pid < 0){
    1c88:	02054763          	bltz	a0,1cb6 <kernmem+0x62>
    if(pid == 0){
    1c8c:	cd1d                	beqz	a0,1cca <kernmem+0x76>
    wait(&xstatus);
    1c8e:	8556                	mv	a0,s5
    1c90:	270030ef          	jal	4f00 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c94:	fbc42783          	lw	a5,-68(s0)
    1c98:	05479663          	bne	a5,s4,1ce4 <kernmem+0x90>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c9c:	94ce                	add	s1,s1,s3
    1c9e:	ff2493e3          	bne	s1,s2,1c84 <kernmem+0x30>
}
    1ca2:	60a6                	ld	ra,72(sp)
    1ca4:	6406                	ld	s0,64(sp)
    1ca6:	74e2                	ld	s1,56(sp)
    1ca8:	7942                	ld	s2,48(sp)
    1caa:	79a2                	ld	s3,40(sp)
    1cac:	7a02                	ld	s4,32(sp)
    1cae:	6ae2                	ld	s5,24(sp)
    1cb0:	6b42                	ld	s6,16(sp)
    1cb2:	6161                	addi	sp,sp,80
    1cb4:	8082                	ret
      printf("%s: fork failed\n", s);
    1cb6:	85da                	mv	a1,s6
    1cb8:	00004517          	auipc	a0,0x4
    1cbc:	10050513          	addi	a0,a0,256 # 5db8 <malloc+0x9bc>
    1cc0:	684030ef          	jal	5344 <printf>
      exit(1);
    1cc4:	4505                	li	a0,1
    1cc6:	232030ef          	jal	4ef8 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1cca:	0004c683          	lbu	a3,0(s1)
    1cce:	8626                	mv	a2,s1
    1cd0:	85da                	mv	a1,s6
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	3b650513          	addi	a0,a0,950 # 6088 <malloc+0xc8c>
    1cda:	66a030ef          	jal	5344 <printf>
      exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	218030ef          	jal	4ef8 <exit>
      exit(1);
    1ce4:	4505                	li	a0,1
    1ce6:	212030ef          	jal	4ef8 <exit>

0000000000001cea <MAXVAplus>:
{
    1cea:	7139                	addi	sp,sp,-64
    1cec:	fc06                	sd	ra,56(sp)
    1cee:	f822                	sd	s0,48(sp)
    1cf0:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1cf2:	4785                	li	a5,1
    1cf4:	179a                	slli	a5,a5,0x26
    1cf6:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    1cfa:	fc843783          	ld	a5,-56(s0)
    1cfe:	cf9d                	beqz	a5,1d3c <MAXVAplus+0x52>
    1d00:	f426                	sd	s1,40(sp)
    1d02:	f04a                	sd	s2,32(sp)
    1d04:	ec4e                	sd	s3,24(sp)
    1d06:	89aa                	mv	s3,a0
    wait(&xstatus);
    1d08:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    1d0c:	54fd                	li	s1,-1
    pid = fork();
    1d0e:	1e2030ef          	jal	4ef0 <fork>
    if(pid < 0){
    1d12:	02054963          	bltz	a0,1d44 <MAXVAplus+0x5a>
    if(pid == 0){
    1d16:	c129                	beqz	a0,1d58 <MAXVAplus+0x6e>
    wait(&xstatus);
    1d18:	854a                	mv	a0,s2
    1d1a:	1e6030ef          	jal	4f00 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1d1e:	fc442783          	lw	a5,-60(s0)
    1d22:	04979d63          	bne	a5,s1,1d7c <MAXVAplus+0x92>
  for( ; a != 0; a <<= 1){
    1d26:	fc843783          	ld	a5,-56(s0)
    1d2a:	0786                	slli	a5,a5,0x1
    1d2c:	fcf43423          	sd	a5,-56(s0)
    1d30:	fc843783          	ld	a5,-56(s0)
    1d34:	ffe9                	bnez	a5,1d0e <MAXVAplus+0x24>
    1d36:	74a2                	ld	s1,40(sp)
    1d38:	7902                	ld	s2,32(sp)
    1d3a:	69e2                	ld	s3,24(sp)
}
    1d3c:	70e2                	ld	ra,56(sp)
    1d3e:	7442                	ld	s0,48(sp)
    1d40:	6121                	addi	sp,sp,64
    1d42:	8082                	ret
      printf("%s: fork failed\n", s);
    1d44:	85ce                	mv	a1,s3
    1d46:	00004517          	auipc	a0,0x4
    1d4a:	07250513          	addi	a0,a0,114 # 5db8 <malloc+0x9bc>
    1d4e:	5f6030ef          	jal	5344 <printf>
      exit(1);
    1d52:	4505                	li	a0,1
    1d54:	1a4030ef          	jal	4ef8 <exit>
      *(char*)a = 99;
    1d58:	fc843783          	ld	a5,-56(s0)
    1d5c:	06300713          	li	a4,99
    1d60:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1d64:	fc843603          	ld	a2,-56(s0)
    1d68:	85ce                	mv	a1,s3
    1d6a:	00004517          	auipc	a0,0x4
    1d6e:	33e50513          	addi	a0,a0,830 # 60a8 <malloc+0xcac>
    1d72:	5d2030ef          	jal	5344 <printf>
      exit(1);
    1d76:	4505                	li	a0,1
    1d78:	180030ef          	jal	4ef8 <exit>
      exit(1);
    1d7c:	4505                	li	a0,1
    1d7e:	17a030ef          	jal	4ef8 <exit>

0000000000001d82 <stacktest>:
{
    1d82:	7179                	addi	sp,sp,-48
    1d84:	f406                	sd	ra,40(sp)
    1d86:	f022                	sd	s0,32(sp)
    1d88:	ec26                	sd	s1,24(sp)
    1d8a:	1800                	addi	s0,sp,48
    1d8c:	84aa                	mv	s1,a0
  pid = fork();
    1d8e:	162030ef          	jal	4ef0 <fork>
  if(pid == 0) {
    1d92:	cd11                	beqz	a0,1dae <stacktest+0x2c>
  } else if(pid < 0){
    1d94:	02054c63          	bltz	a0,1dcc <stacktest+0x4a>
  wait(&xstatus);
    1d98:	fdc40513          	addi	a0,s0,-36
    1d9c:	164030ef          	jal	4f00 <wait>
  if(xstatus == -1)  // kernel killed child?
    1da0:	fdc42503          	lw	a0,-36(s0)
    1da4:	57fd                	li	a5,-1
    1da6:	02f50d63          	beq	a0,a5,1de0 <stacktest+0x5e>
    exit(xstatus);
    1daa:	14e030ef          	jal	4ef8 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1dae:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1db0:	80078793          	addi	a5,a5,-2048
    1db4:	8007c603          	lbu	a2,-2048(a5)
    1db8:	85a6                	mv	a1,s1
    1dba:	00004517          	auipc	a0,0x4
    1dbe:	30650513          	addi	a0,a0,774 # 60c0 <malloc+0xcc4>
    1dc2:	582030ef          	jal	5344 <printf>
    exit(1);
    1dc6:	4505                	li	a0,1
    1dc8:	130030ef          	jal	4ef8 <exit>
    printf("%s: fork failed\n", s);
    1dcc:	85a6                	mv	a1,s1
    1dce:	00004517          	auipc	a0,0x4
    1dd2:	fea50513          	addi	a0,a0,-22 # 5db8 <malloc+0x9bc>
    1dd6:	56e030ef          	jal	5344 <printf>
    exit(1);
    1dda:	4505                	li	a0,1
    1ddc:	11c030ef          	jal	4ef8 <exit>
    exit(0);
    1de0:	4501                	li	a0,0
    1de2:	116030ef          	jal	4ef8 <exit>

0000000000001de6 <nowrite>:
{
    1de6:	7159                	addi	sp,sp,-112
    1de8:	f486                	sd	ra,104(sp)
    1dea:	f0a2                	sd	s0,96(sp)
    1dec:	eca6                	sd	s1,88(sp)
    1dee:	e8ca                	sd	s2,80(sp)
    1df0:	e4ce                	sd	s3,72(sp)
    1df2:	e0d2                	sd	s4,64(sp)
    1df4:	1880                	addi	s0,sp,112
    1df6:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1df8:	00006797          	auipc	a5,0x6
    1dfc:	b8078793          	addi	a5,a5,-1152 # 7978 <malloc+0x257c>
    1e00:	7788                	ld	a0,40(a5)
    1e02:	7b8c                	ld	a1,48(a5)
    1e04:	7f90                	ld	a2,56(a5)
    1e06:	63b4                	ld	a3,64(a5)
    1e08:	67b8                	ld	a4,72(a5)
    1e0a:	f8a43c23          	sd	a0,-104(s0)
    1e0e:	fab43023          	sd	a1,-96(s0)
    1e12:	fac43423          	sd	a2,-88(s0)
    1e16:	fad43823          	sd	a3,-80(s0)
    1e1a:	fae43c23          	sd	a4,-72(s0)
    1e1e:	6bbc                	ld	a5,80(a5)
    1e20:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e24:	4481                	li	s1,0
    wait(&xstatus);
    1e26:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e2a:	4999                	li	s3,6
    pid = fork();
    1e2c:	0c4030ef          	jal	4ef0 <fork>
    if(pid == 0) {
    1e30:	cd19                	beqz	a0,1e4e <nowrite+0x68>
    } else if(pid < 0){
    1e32:	04054163          	bltz	a0,1e74 <nowrite+0x8e>
    wait(&xstatus);
    1e36:	854a                	mv	a0,s2
    1e38:	0c8030ef          	jal	4f00 <wait>
    if(xstatus == 0){
    1e3c:	fcc42783          	lw	a5,-52(s0)
    1e40:	c7a1                	beqz	a5,1e88 <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e42:	2485                	addiw	s1,s1,1
    1e44:	ff3494e3          	bne	s1,s3,1e2c <nowrite+0x46>
  exit(0);
    1e48:	4501                	li	a0,0
    1e4a:	0ae030ef          	jal	4ef8 <exit>
      volatile int *addr = (int *) addrs[ai];
    1e4e:	048e                	slli	s1,s1,0x3
    1e50:	fd048793          	addi	a5,s1,-48
    1e54:	008784b3          	add	s1,a5,s0
    1e58:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1e5c:	47a9                	li	a5,10
    1e5e:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1e60:	85d2                	mv	a1,s4
    1e62:	00004517          	auipc	a0,0x4
    1e66:	28650513          	addi	a0,a0,646 # 60e8 <malloc+0xcec>
    1e6a:	4da030ef          	jal	5344 <printf>
      exit(0);
    1e6e:	4501                	li	a0,0
    1e70:	088030ef          	jal	4ef8 <exit>
      printf("%s: fork failed\n", s);
    1e74:	85d2                	mv	a1,s4
    1e76:	00004517          	auipc	a0,0x4
    1e7a:	f4250513          	addi	a0,a0,-190 # 5db8 <malloc+0x9bc>
    1e7e:	4c6030ef          	jal	5344 <printf>
      exit(1);
    1e82:	4505                	li	a0,1
    1e84:	074030ef          	jal	4ef8 <exit>
      exit(1);
    1e88:	4505                	li	a0,1
    1e8a:	06e030ef          	jal	4ef8 <exit>

0000000000001e8e <manywrites>:
{
    1e8e:	7159                	addi	sp,sp,-112
    1e90:	f486                	sd	ra,104(sp)
    1e92:	f0a2                	sd	s0,96(sp)
    1e94:	eca6                	sd	s1,88(sp)
    1e96:	e8ca                	sd	s2,80(sp)
    1e98:	e4ce                	sd	s3,72(sp)
    1e9a:	ec66                	sd	s9,24(sp)
    1e9c:	1880                	addi	s0,sp,112
    1e9e:	8caa                	mv	s9,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ea0:	4901                	li	s2,0
    1ea2:	4991                	li	s3,4
    int pid = fork();
    1ea4:	04c030ef          	jal	4ef0 <fork>
    1ea8:	84aa                	mv	s1,a0
    if(pid < 0){
    1eaa:	02054c63          	bltz	a0,1ee2 <manywrites+0x54>
    if(pid == 0){
    1eae:	c929                	beqz	a0,1f00 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1eb0:	2905                	addiw	s2,s2,1
    1eb2:	ff3919e3          	bne	s2,s3,1ea4 <manywrites+0x16>
    1eb6:	4491                	li	s1,4
    wait(&st);
    1eb8:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1ebc:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1ec0:	854a                	mv	a0,s2
    1ec2:	03e030ef          	jal	4f00 <wait>
    if(st != 0)
    1ec6:	f9842503          	lw	a0,-104(s0)
    1eca:	0e051763          	bnez	a0,1fb8 <manywrites+0x12a>
  for(int ci = 0; ci < nchildren; ci++){
    1ece:	34fd                	addiw	s1,s1,-1
    1ed0:	f4f5                	bnez	s1,1ebc <manywrites+0x2e>
    1ed2:	e0d2                	sd	s4,64(sp)
    1ed4:	fc56                	sd	s5,56(sp)
    1ed6:	f85a                	sd	s6,48(sp)
    1ed8:	f45e                	sd	s7,40(sp)
    1eda:	f062                	sd	s8,32(sp)
    1edc:	e86a                	sd	s10,16(sp)
  exit(0);
    1ede:	01a030ef          	jal	4ef8 <exit>
    1ee2:	e0d2                	sd	s4,64(sp)
    1ee4:	fc56                	sd	s5,56(sp)
    1ee6:	f85a                	sd	s6,48(sp)
    1ee8:	f45e                	sd	s7,40(sp)
    1eea:	f062                	sd	s8,32(sp)
    1eec:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	47250513          	addi	a0,a0,1138 # 7360 <malloc+0x1f64>
    1ef6:	44e030ef          	jal	5344 <printf>
      exit(1);
    1efa:	4505                	li	a0,1
    1efc:	7fd020ef          	jal	4ef8 <exit>
    1f00:	e0d2                	sd	s4,64(sp)
    1f02:	fc56                	sd	s5,56(sp)
    1f04:	f85a                	sd	s6,48(sp)
    1f06:	f45e                	sd	s7,40(sp)
    1f08:	f062                	sd	s8,32(sp)
    1f0a:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1f0c:	06200793          	li	a5,98
    1f10:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1f14:	0619079b          	addiw	a5,s2,97
    1f18:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1f1c:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1f20:	f9840513          	addi	a0,s0,-104
    1f24:	024030ef          	jal	4f48 <unlink>
    1f28:	47f9                	li	a5,30
    1f2a:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1f2c:	f9840b93          	addi	s7,s0,-104
    1f30:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1f34:	6a8d                	lui	s5,0x3
    1f36:	0000ac17          	auipc	s8,0xa
    1f3a:	d72c0c13          	addi	s8,s8,-654 # bca8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f3e:	8a26                	mv	s4,s1
    1f40:	02094563          	bltz	s2,1f6a <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1f44:	85da                	mv	a1,s6
    1f46:	855e                	mv	a0,s7
    1f48:	7f1020ef          	jal	4f38 <open>
    1f4c:	89aa                	mv	s3,a0
          if(fd < 0){
    1f4e:	02054d63          	bltz	a0,1f88 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1f52:	8656                	mv	a2,s5
    1f54:	85e2                	mv	a1,s8
    1f56:	7c3020ef          	jal	4f18 <write>
          if(cc != sz){
    1f5a:	05551363          	bne	a0,s5,1fa0 <manywrites+0x112>
          close(fd);
    1f5e:	854e                	mv	a0,s3
    1f60:	7c1020ef          	jal	4f20 <close>
        for(int i = 0; i < ci+1; i++){
    1f64:	2a05                	addiw	s4,s4,1
    1f66:	fd495fe3          	bge	s2,s4,1f44 <manywrites+0xb6>
        unlink(name);
    1f6a:	f9840513          	addi	a0,s0,-104
    1f6e:	7db020ef          	jal	4f48 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f72:	fffd079b          	addiw	a5,s10,-1
    1f76:	8d3e                	mv	s10,a5
    1f78:	f3f9                	bnez	a5,1f3e <manywrites+0xb0>
      unlink(name);
    1f7a:	f9840513          	addi	a0,s0,-104
    1f7e:	7cb020ef          	jal	4f48 <unlink>
      exit(0);
    1f82:	4501                	li	a0,0
    1f84:	775020ef          	jal	4ef8 <exit>
            printf("%s: cannot create %s\n", s, name);
    1f88:	f9840613          	addi	a2,s0,-104
    1f8c:	85e6                	mv	a1,s9
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	17a50513          	addi	a0,a0,378 # 6108 <malloc+0xd0c>
    1f96:	3ae030ef          	jal	5344 <printf>
            exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	75d020ef          	jal	4ef8 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fa0:	86aa                	mv	a3,a0
    1fa2:	660d                	lui	a2,0x3
    1fa4:	85e6                	mv	a1,s9
    1fa6:	00003517          	auipc	a0,0x3
    1faa:	65250513          	addi	a0,a0,1618 # 55f8 <malloc+0x1fc>
    1fae:	396030ef          	jal	5344 <printf>
            exit(1);
    1fb2:	4505                	li	a0,1
    1fb4:	745020ef          	jal	4ef8 <exit>
    1fb8:	e0d2                	sd	s4,64(sp)
    1fba:	fc56                	sd	s5,56(sp)
    1fbc:	f85a                	sd	s6,48(sp)
    1fbe:	f45e                	sd	s7,40(sp)
    1fc0:	f062                	sd	s8,32(sp)
    1fc2:	e86a                	sd	s10,16(sp)
      exit(st);
    1fc4:	735020ef          	jal	4ef8 <exit>

0000000000001fc8 <copyinstr3>:
{
    1fc8:	7179                	addi	sp,sp,-48
    1fca:	f406                	sd	ra,40(sp)
    1fcc:	f022                	sd	s0,32(sp)
    1fce:	ec26                	sd	s1,24(sp)
    1fd0:	1800                	addi	s0,sp,48
  sbrk(8192);
    1fd2:	6509                	lui	a0,0x2
    1fd4:	6f1020ef          	jal	4ec4 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1fd8:	4501                	li	a0,0
    1fda:	6eb020ef          	jal	4ec4 <sbrk>
  if((top % PGSIZE) != 0){
    1fde:	03451793          	slli	a5,a0,0x34
    1fe2:	e7bd                	bnez	a5,2050 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1fe4:	4501                	li	a0,0
    1fe6:	6df020ef          	jal	4ec4 <sbrk>
  if(top % PGSIZE){
    1fea:	03451793          	slli	a5,a0,0x34
    1fee:	ebad                	bnez	a5,2060 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ff0:	fff50493          	addi	s1,a0,-1 # 1fff <copyinstr3+0x37>
  *b = 'x';
    1ff4:	07800793          	li	a5,120
    1ff8:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1ffc:	8526                	mv	a0,s1
    1ffe:	74b020ef          	jal	4f48 <unlink>
  if(ret != -1){
    2002:	57fd                	li	a5,-1
    2004:	06f51763          	bne	a0,a5,2072 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    2008:	20100593          	li	a1,513
    200c:	8526                	mv	a0,s1
    200e:	72b020ef          	jal	4f38 <open>
  if(fd != -1){
    2012:	57fd                	li	a5,-1
    2014:	06f51a63          	bne	a0,a5,2088 <copyinstr3+0xc0>
  ret = link(b, b);
    2018:	85a6                	mv	a1,s1
    201a:	8526                	mv	a0,s1
    201c:	73d020ef          	jal	4f58 <link>
  if(ret != -1){
    2020:	57fd                	li	a5,-1
    2022:	06f51e63          	bne	a0,a5,209e <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    2026:	00005797          	auipc	a5,0x5
    202a:	de278793          	addi	a5,a5,-542 # 6e08 <malloc+0x1a0c>
    202e:	fcf43823          	sd	a5,-48(s0)
    2032:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2036:	fd040593          	addi	a1,s0,-48
    203a:	8526                	mv	a0,s1
    203c:	6f5020ef          	jal	4f30 <exec>
  if(ret != -1){
    2040:	57fd                	li	a5,-1
    2042:	06f51a63          	bne	a0,a5,20b6 <copyinstr3+0xee>
}
    2046:	70a2                	ld	ra,40(sp)
    2048:	7402                	ld	s0,32(sp)
    204a:	64e2                	ld	s1,24(sp)
    204c:	6145                	addi	sp,sp,48
    204e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2050:	0347d513          	srli	a0,a5,0x34
    2054:	6785                	lui	a5,0x1
    2056:	40a7853b          	subw	a0,a5,a0
    205a:	66b020ef          	jal	4ec4 <sbrk>
    205e:	b759                	j	1fe4 <copyinstr3+0x1c>
    printf("oops\n");
    2060:	00004517          	auipc	a0,0x4
    2064:	0c050513          	addi	a0,a0,192 # 6120 <malloc+0xd24>
    2068:	2dc030ef          	jal	5344 <printf>
    exit(1);
    206c:	4505                	li	a0,1
    206e:	68b020ef          	jal	4ef8 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2072:	862a                	mv	a2,a0
    2074:	85a6                	mv	a1,s1
    2076:	00004517          	auipc	a0,0x4
    207a:	c6250513          	addi	a0,a0,-926 # 5cd8 <malloc+0x8dc>
    207e:	2c6030ef          	jal	5344 <printf>
    exit(1);
    2082:	4505                	li	a0,1
    2084:	675020ef          	jal	4ef8 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2088:	862a                	mv	a2,a0
    208a:	85a6                	mv	a1,s1
    208c:	00004517          	auipc	a0,0x4
    2090:	c6c50513          	addi	a0,a0,-916 # 5cf8 <malloc+0x8fc>
    2094:	2b0030ef          	jal	5344 <printf>
    exit(1);
    2098:	4505                	li	a0,1
    209a:	65f020ef          	jal	4ef8 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    209e:	86aa                	mv	a3,a0
    20a0:	8626                	mv	a2,s1
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	c7450513          	addi	a0,a0,-908 # 5d18 <malloc+0x91c>
    20ac:	298030ef          	jal	5344 <printf>
    exit(1);
    20b0:	4505                	li	a0,1
    20b2:	647020ef          	jal	4ef8 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20b6:	863e                	mv	a2,a5
    20b8:	85a6                	mv	a1,s1
    20ba:	00004517          	auipc	a0,0x4
    20be:	c8650513          	addi	a0,a0,-890 # 5d40 <malloc+0x944>
    20c2:	282030ef          	jal	5344 <printf>
    exit(1);
    20c6:	4505                	li	a0,1
    20c8:	631020ef          	jal	4ef8 <exit>

00000000000020cc <rwsbrk>:
{
    20cc:	1101                	addi	sp,sp,-32
    20ce:	ec06                	sd	ra,24(sp)
    20d0:	e822                	sd	s0,16(sp)
    20d2:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    20d4:	6509                	lui	a0,0x2
    20d6:	5ef020ef          	jal	4ec4 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    20da:	57fd                	li	a5,-1
    20dc:	04f50a63          	beq	a0,a5,2130 <rwsbrk+0x64>
    20e0:	e426                	sd	s1,8(sp)
    20e2:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    20e4:	7579                	lui	a0,0xffffe
    20e6:	5df020ef          	jal	4ec4 <sbrk>
    20ea:	57fd                	li	a5,-1
    20ec:	04f50d63          	beq	a0,a5,2146 <rwsbrk+0x7a>
    20f0:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    20f2:	20100593          	li	a1,513
    20f6:	00004517          	auipc	a0,0x4
    20fa:	06a50513          	addi	a0,a0,106 # 6160 <malloc+0xd64>
    20fe:	63b020ef          	jal	4f38 <open>
    2102:	892a                	mv	s2,a0
  if(fd < 0){
    2104:	04054b63          	bltz	a0,215a <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    2108:	6785                	lui	a5,0x1
    210a:	94be                	add	s1,s1,a5
    210c:	40000613          	li	a2,1024
    2110:	85a6                	mv	a1,s1
    2112:	607020ef          	jal	4f18 <write>
    2116:	862a                	mv	a2,a0
  if(n >= 0){
    2118:	04054a63          	bltz	a0,216c <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    211c:	85a6                	mv	a1,s1
    211e:	00004517          	auipc	a0,0x4
    2122:	06250513          	addi	a0,a0,98 # 6180 <malloc+0xd84>
    2126:	21e030ef          	jal	5344 <printf>
    exit(1);
    212a:	4505                	li	a0,1
    212c:	5cd020ef          	jal	4ef8 <exit>
    2130:	e426                	sd	s1,8(sp)
    2132:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2134:	00004517          	auipc	a0,0x4
    2138:	ff450513          	addi	a0,a0,-12 # 6128 <malloc+0xd2c>
    213c:	208030ef          	jal	5344 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	5b7020ef          	jal	4ef8 <exit>
    2146:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2148:	00004517          	auipc	a0,0x4
    214c:	ff850513          	addi	a0,a0,-8 # 6140 <malloc+0xd44>
    2150:	1f4030ef          	jal	5344 <printf>
    exit(1);
    2154:	4505                	li	a0,1
    2156:	5a3020ef          	jal	4ef8 <exit>
    printf("open(rwsbrk) failed\n");
    215a:	00004517          	auipc	a0,0x4
    215e:	00e50513          	addi	a0,a0,14 # 6168 <malloc+0xd6c>
    2162:	1e2030ef          	jal	5344 <printf>
    exit(1);
    2166:	4505                	li	a0,1
    2168:	591020ef          	jal	4ef8 <exit>
  close(fd);
    216c:	854a                	mv	a0,s2
    216e:	5b3020ef          	jal	4f20 <close>
  unlink("rwsbrk");
    2172:	00004517          	auipc	a0,0x4
    2176:	fee50513          	addi	a0,a0,-18 # 6160 <malloc+0xd64>
    217a:	5cf020ef          	jal	4f48 <unlink>
  fd = open("README", O_RDONLY);
    217e:	4581                	li	a1,0
    2180:	00003517          	auipc	a0,0x3
    2184:	58050513          	addi	a0,a0,1408 # 5700 <malloc+0x304>
    2188:	5b1020ef          	jal	4f38 <open>
    218c:	892a                	mv	s2,a0
  if(fd < 0){
    218e:	02054363          	bltz	a0,21b4 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2192:	4629                	li	a2,10
    2194:	85a6                	mv	a1,s1
    2196:	57b020ef          	jal	4f10 <read>
    219a:	862a                	mv	a2,a0
  if(n >= 0){
    219c:	02054563          	bltz	a0,21c6 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    21a0:	85a6                	mv	a1,s1
    21a2:	00004517          	auipc	a0,0x4
    21a6:	00e50513          	addi	a0,a0,14 # 61b0 <malloc+0xdb4>
    21aa:	19a030ef          	jal	5344 <printf>
    exit(1);
    21ae:	4505                	li	a0,1
    21b0:	549020ef          	jal	4ef8 <exit>
    printf("open(README) failed\n");
    21b4:	00003517          	auipc	a0,0x3
    21b8:	55450513          	addi	a0,a0,1364 # 5708 <malloc+0x30c>
    21bc:	188030ef          	jal	5344 <printf>
    exit(1);
    21c0:	4505                	li	a0,1
    21c2:	537020ef          	jal	4ef8 <exit>
  close(fd);
    21c6:	854a                	mv	a0,s2
    21c8:	559020ef          	jal	4f20 <close>
  exit(0);
    21cc:	4501                	li	a0,0
    21ce:	52b020ef          	jal	4ef8 <exit>

00000000000021d2 <sbrkbasic>:
{
    21d2:	715d                	addi	sp,sp,-80
    21d4:	e486                	sd	ra,72(sp)
    21d6:	e0a2                	sd	s0,64(sp)
    21d8:	ec56                	sd	s5,24(sp)
    21da:	0880                	addi	s0,sp,80
    21dc:	8aaa                	mv	s5,a0
  pid = fork();
    21de:	513020ef          	jal	4ef0 <fork>
  if(pid < 0){
    21e2:	02054c63          	bltz	a0,221a <sbrkbasic+0x48>
  if(pid == 0){
    21e6:	ed31                	bnez	a0,2242 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    21e8:	40000537          	lui	a0,0x40000
    21ec:	4d9020ef          	jal	4ec4 <sbrk>
    if(a == (char*)SBRK_ERROR){
    21f0:	57fd                	li	a5,-1
    21f2:	04f50163          	beq	a0,a5,2234 <sbrkbasic+0x62>
    21f6:	fc26                	sd	s1,56(sp)
    21f8:	f84a                	sd	s2,48(sp)
    21fa:	f44e                	sd	s3,40(sp)
    21fc:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    21fe:	400007b7          	lui	a5,0x40000
    2202:	97aa                	add	a5,a5,a0
      *b = 99;
    2204:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2208:	6705                	lui	a4,0x1
      *b = 99;
    220a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1358>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    220e:	953a                	add	a0,a0,a4
    2210:	fef51de3          	bne	a0,a5,220a <sbrkbasic+0x38>
    exit(1);
    2214:	4505                	li	a0,1
    2216:	4e3020ef          	jal	4ef8 <exit>
    221a:	fc26                	sd	s1,56(sp)
    221c:	f84a                	sd	s2,48(sp)
    221e:	f44e                	sd	s3,40(sp)
    2220:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2222:	00004517          	auipc	a0,0x4
    2226:	fb650513          	addi	a0,a0,-74 # 61d8 <malloc+0xddc>
    222a:	11a030ef          	jal	5344 <printf>
    exit(1);
    222e:	4505                	li	a0,1
    2230:	4c9020ef          	jal	4ef8 <exit>
    2234:	fc26                	sd	s1,56(sp)
    2236:	f84a                	sd	s2,48(sp)
    2238:	f44e                	sd	s3,40(sp)
    223a:	f052                	sd	s4,32(sp)
      exit(0);
    223c:	4501                	li	a0,0
    223e:	4bb020ef          	jal	4ef8 <exit>
  wait(&xstatus);
    2242:	fbc40513          	addi	a0,s0,-68
    2246:	4bb020ef          	jal	4f00 <wait>
  if(xstatus == 1){
    224a:	fbc42703          	lw	a4,-68(s0)
    224e:	4785                	li	a5,1
    2250:	02f70063          	beq	a4,a5,2270 <sbrkbasic+0x9e>
    2254:	fc26                	sd	s1,56(sp)
    2256:	f84a                	sd	s2,48(sp)
    2258:	f44e                	sd	s3,40(sp)
    225a:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    225c:	4501                	li	a0,0
    225e:	467020ef          	jal	4ec4 <sbrk>
    2262:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2264:	4901                	li	s2,0
    b = sbrk(1);
    2266:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2268:	6a05                	lui	s4,0x1
    226a:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    226e:	a005                	j	228e <sbrkbasic+0xbc>
    2270:	fc26                	sd	s1,56(sp)
    2272:	f84a                	sd	s2,48(sp)
    2274:	f44e                	sd	s3,40(sp)
    2276:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2278:	85d6                	mv	a1,s5
    227a:	00004517          	auipc	a0,0x4
    227e:	f7e50513          	addi	a0,a0,-130 # 61f8 <malloc+0xdfc>
    2282:	0c2030ef          	jal	5344 <printf>
    exit(1);
    2286:	4505                	li	a0,1
    2288:	471020ef          	jal	4ef8 <exit>
    228c:	84be                	mv	s1,a5
    b = sbrk(1);
    228e:	854e                	mv	a0,s3
    2290:	435020ef          	jal	4ec4 <sbrk>
    if(b != a){
    2294:	04951163          	bne	a0,s1,22d6 <sbrkbasic+0x104>
    *b = 1;
    2298:	01348023          	sb	s3,0(s1)
    a = b + 1;
    229c:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    22a0:	2905                	addiw	s2,s2,1
    22a2:	ff4915e3          	bne	s2,s4,228c <sbrkbasic+0xba>
  pid = fork();
    22a6:	44b020ef          	jal	4ef0 <fork>
    22aa:	892a                	mv	s2,a0
  if(pid < 0){
    22ac:	04054263          	bltz	a0,22f0 <sbrkbasic+0x11e>
  c = sbrk(1);
    22b0:	4505                	li	a0,1
    22b2:	413020ef          	jal	4ec4 <sbrk>
  c = sbrk(1);
    22b6:	4505                	li	a0,1
    22b8:	40d020ef          	jal	4ec4 <sbrk>
  if(c != a + 1){
    22bc:	0489                	addi	s1,s1,2
    22be:	04950363          	beq	a0,s1,2304 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    22c2:	85d6                	mv	a1,s5
    22c4:	00004517          	auipc	a0,0x4
    22c8:	f9450513          	addi	a0,a0,-108 # 6258 <malloc+0xe5c>
    22cc:	078030ef          	jal	5344 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	427020ef          	jal	4ef8 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    22d6:	872a                	mv	a4,a0
    22d8:	86a6                	mv	a3,s1
    22da:	864a                	mv	a2,s2
    22dc:	85d6                	mv	a1,s5
    22de:	00004517          	auipc	a0,0x4
    22e2:	f3a50513          	addi	a0,a0,-198 # 6218 <malloc+0xe1c>
    22e6:	05e030ef          	jal	5344 <printf>
      exit(1);
    22ea:	4505                	li	a0,1
    22ec:	40d020ef          	jal	4ef8 <exit>
    printf("%s: sbrk test fork failed\n", s);
    22f0:	85d6                	mv	a1,s5
    22f2:	00004517          	auipc	a0,0x4
    22f6:	f4650513          	addi	a0,a0,-186 # 6238 <malloc+0xe3c>
    22fa:	04a030ef          	jal	5344 <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	3f9020ef          	jal	4ef8 <exit>
  if(pid == 0)
    2304:	00091563          	bnez	s2,230e <sbrkbasic+0x13c>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	3ef020ef          	jal	4ef8 <exit>
  wait(&xstatus);
    230e:	fbc40513          	addi	a0,s0,-68
    2312:	3ef020ef          	jal	4f00 <wait>
  exit(xstatus);
    2316:	fbc42503          	lw	a0,-68(s0)
    231a:	3df020ef          	jal	4ef8 <exit>

000000000000231e <sbrkmuch>:
{
    231e:	7179                	addi	sp,sp,-48
    2320:	f406                	sd	ra,40(sp)
    2322:	f022                	sd	s0,32(sp)
    2324:	ec26                	sd	s1,24(sp)
    2326:	e84a                	sd	s2,16(sp)
    2328:	e44e                	sd	s3,8(sp)
    232a:	e052                	sd	s4,0(sp)
    232c:	1800                	addi	s0,sp,48
    232e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2330:	4501                	li	a0,0
    2332:	393020ef          	jal	4ec4 <sbrk>
    2336:	892a                	mv	s2,a0
  a = sbrk(0);
    2338:	4501                	li	a0,0
    233a:	38b020ef          	jal	4ec4 <sbrk>
    233e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2340:	06400537          	lui	a0,0x6400
    2344:	9d05                	subw	a0,a0,s1
    2346:	37f020ef          	jal	4ec4 <sbrk>
  if (p != a) {
    234a:	08a49963          	bne	s1,a0,23dc <sbrkmuch+0xbe>
  *lastaddr = 99;
    234e:	064007b7          	lui	a5,0x6400
    2352:	06300713          	li	a4,99
    2356:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1357>
  a = sbrk(0);
    235a:	4501                	li	a0,0
    235c:	369020ef          	jal	4ec4 <sbrk>
    2360:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2362:	757d                	lui	a0,0xfffff
    2364:	361020ef          	jal	4ec4 <sbrk>
  if(c == (char*)SBRK_ERROR){
    2368:	57fd                	li	a5,-1
    236a:	08f50363          	beq	a0,a5,23f0 <sbrkmuch+0xd2>
  c = sbrk(0);
    236e:	4501                	li	a0,0
    2370:	355020ef          	jal	4ec4 <sbrk>
  if(c != a - PGSIZE){
    2374:	80048793          	addi	a5,s1,-2048
    2378:	80078793          	addi	a5,a5,-2048
    237c:	08f51463          	bne	a0,a5,2404 <sbrkmuch+0xe6>
  a = sbrk(0);
    2380:	4501                	li	a0,0
    2382:	343020ef          	jal	4ec4 <sbrk>
    2386:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2388:	6505                	lui	a0,0x1
    238a:	33b020ef          	jal	4ec4 <sbrk>
    238e:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2390:	08a49663          	bne	s1,a0,241c <sbrkmuch+0xfe>
    2394:	4501                	li	a0,0
    2396:	32f020ef          	jal	4ec4 <sbrk>
    239a:	6785                	lui	a5,0x1
    239c:	97a6                	add	a5,a5,s1
    239e:	06f51f63          	bne	a0,a5,241c <sbrkmuch+0xfe>
  if(*lastaddr == 99){
    23a2:	064007b7          	lui	a5,0x6400
    23a6:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1357>
    23aa:	06300793          	li	a5,99
    23ae:	08f70363          	beq	a4,a5,2434 <sbrkmuch+0x116>
  a = sbrk(0);
    23b2:	4501                	li	a0,0
    23b4:	311020ef          	jal	4ec4 <sbrk>
    23b8:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    23ba:	4501                	li	a0,0
    23bc:	309020ef          	jal	4ec4 <sbrk>
    23c0:	40a9053b          	subw	a0,s2,a0
    23c4:	301020ef          	jal	4ec4 <sbrk>
  if(c != a){
    23c8:	08a49063          	bne	s1,a0,2448 <sbrkmuch+0x12a>
}
    23cc:	70a2                	ld	ra,40(sp)
    23ce:	7402                	ld	s0,32(sp)
    23d0:	64e2                	ld	s1,24(sp)
    23d2:	6942                	ld	s2,16(sp)
    23d4:	69a2                	ld	s3,8(sp)
    23d6:	6a02                	ld	s4,0(sp)
    23d8:	6145                	addi	sp,sp,48
    23da:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    23dc:	85ce                	mv	a1,s3
    23de:	00004517          	auipc	a0,0x4
    23e2:	e9a50513          	addi	a0,a0,-358 # 6278 <malloc+0xe7c>
    23e6:	75f020ef          	jal	5344 <printf>
    exit(1);
    23ea:	4505                	li	a0,1
    23ec:	30d020ef          	jal	4ef8 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    23f0:	85ce                	mv	a1,s3
    23f2:	00004517          	auipc	a0,0x4
    23f6:	ece50513          	addi	a0,a0,-306 # 62c0 <malloc+0xec4>
    23fa:	74b020ef          	jal	5344 <printf>
    exit(1);
    23fe:	4505                	li	a0,1
    2400:	2f9020ef          	jal	4ef8 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2404:	86aa                	mv	a3,a0
    2406:	8626                	mv	a2,s1
    2408:	85ce                	mv	a1,s3
    240a:	00004517          	auipc	a0,0x4
    240e:	ed650513          	addi	a0,a0,-298 # 62e0 <malloc+0xee4>
    2412:	733020ef          	jal	5344 <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	2e1020ef          	jal	4ef8 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    241c:	86d2                	mv	a3,s4
    241e:	8626                	mv	a2,s1
    2420:	85ce                	mv	a1,s3
    2422:	00004517          	auipc	a0,0x4
    2426:	efe50513          	addi	a0,a0,-258 # 6320 <malloc+0xf24>
    242a:	71b020ef          	jal	5344 <printf>
    exit(1);
    242e:	4505                	li	a0,1
    2430:	2c9020ef          	jal	4ef8 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2434:	85ce                	mv	a1,s3
    2436:	00004517          	auipc	a0,0x4
    243a:	f1a50513          	addi	a0,a0,-230 # 6350 <malloc+0xf54>
    243e:	707020ef          	jal	5344 <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	2b5020ef          	jal	4ef8 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2448:	86aa                	mv	a3,a0
    244a:	8626                	mv	a2,s1
    244c:	85ce                	mv	a1,s3
    244e:	00004517          	auipc	a0,0x4
    2452:	f3a50513          	addi	a0,a0,-198 # 6388 <malloc+0xf8c>
    2456:	6ef020ef          	jal	5344 <printf>
    exit(1);
    245a:	4505                	li	a0,1
    245c:	29d020ef          	jal	4ef8 <exit>

0000000000002460 <sbrkarg>:
{
    2460:	7179                	addi	sp,sp,-48
    2462:	f406                	sd	ra,40(sp)
    2464:	f022                	sd	s0,32(sp)
    2466:	ec26                	sd	s1,24(sp)
    2468:	e84a                	sd	s2,16(sp)
    246a:	e44e                	sd	s3,8(sp)
    246c:	1800                	addi	s0,sp,48
    246e:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2470:	6505                	lui	a0,0x1
    2472:	253020ef          	jal	4ec4 <sbrk>
    2476:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2478:	20100593          	li	a1,513
    247c:	00004517          	auipc	a0,0x4
    2480:	f3450513          	addi	a0,a0,-204 # 63b0 <malloc+0xfb4>
    2484:	2b5020ef          	jal	4f38 <open>
    2488:	84aa                	mv	s1,a0
  unlink("sbrk");
    248a:	00004517          	auipc	a0,0x4
    248e:	f2650513          	addi	a0,a0,-218 # 63b0 <malloc+0xfb4>
    2492:	2b7020ef          	jal	4f48 <unlink>
  if(fd < 0)  {
    2496:	0204c963          	bltz	s1,24c8 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    249a:	6605                	lui	a2,0x1
    249c:	85ca                	mv	a1,s2
    249e:	8526                	mv	a0,s1
    24a0:	279020ef          	jal	4f18 <write>
    24a4:	02054c63          	bltz	a0,24dc <sbrkarg+0x7c>
  close(fd);
    24a8:	8526                	mv	a0,s1
    24aa:	277020ef          	jal	4f20 <close>
  a = sbrk(PGSIZE);
    24ae:	6505                	lui	a0,0x1
    24b0:	215020ef          	jal	4ec4 <sbrk>
  if(pipe((int *) a) != 0){
    24b4:	255020ef          	jal	4f08 <pipe>
    24b8:	ed05                	bnez	a0,24f0 <sbrkarg+0x90>
}
    24ba:	70a2                	ld	ra,40(sp)
    24bc:	7402                	ld	s0,32(sp)
    24be:	64e2                	ld	s1,24(sp)
    24c0:	6942                	ld	s2,16(sp)
    24c2:	69a2                	ld	s3,8(sp)
    24c4:	6145                	addi	sp,sp,48
    24c6:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    24c8:	85ce                	mv	a1,s3
    24ca:	00004517          	auipc	a0,0x4
    24ce:	eee50513          	addi	a0,a0,-274 # 63b8 <malloc+0xfbc>
    24d2:	673020ef          	jal	5344 <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	221020ef          	jal	4ef8 <exit>
    printf("%s: write sbrk failed\n", s);
    24dc:	85ce                	mv	a1,s3
    24de:	00004517          	auipc	a0,0x4
    24e2:	ef250513          	addi	a0,a0,-270 # 63d0 <malloc+0xfd4>
    24e6:	65f020ef          	jal	5344 <printf>
    exit(1);
    24ea:	4505                	li	a0,1
    24ec:	20d020ef          	jal	4ef8 <exit>
    printf("%s: pipe() failed\n", s);
    24f0:	85ce                	mv	a1,s3
    24f2:	00004517          	auipc	a0,0x4
    24f6:	9ce50513          	addi	a0,a0,-1586 # 5ec0 <malloc+0xac4>
    24fa:	64b020ef          	jal	5344 <printf>
    exit(1);
    24fe:	4505                	li	a0,1
    2500:	1f9020ef          	jal	4ef8 <exit>

0000000000002504 <argptest>:
{
    2504:	1101                	addi	sp,sp,-32
    2506:	ec06                	sd	ra,24(sp)
    2508:	e822                	sd	s0,16(sp)
    250a:	e426                	sd	s1,8(sp)
    250c:	e04a                	sd	s2,0(sp)
    250e:	1000                	addi	s0,sp,32
    2510:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2512:	4581                	li	a1,0
    2514:	00004517          	auipc	a0,0x4
    2518:	ed450513          	addi	a0,a0,-300 # 63e8 <malloc+0xfec>
    251c:	21d020ef          	jal	4f38 <open>
  if (fd < 0) {
    2520:	02054563          	bltz	a0,254a <argptest+0x46>
    2524:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2526:	4501                	li	a0,0
    2528:	19d020ef          	jal	4ec4 <sbrk>
    252c:	567d                	li	a2,-1
    252e:	00c505b3          	add	a1,a0,a2
    2532:	8526                	mv	a0,s1
    2534:	1dd020ef          	jal	4f10 <read>
  close(fd);
    2538:	8526                	mv	a0,s1
    253a:	1e7020ef          	jal	4f20 <close>
}
    253e:	60e2                	ld	ra,24(sp)
    2540:	6442                	ld	s0,16(sp)
    2542:	64a2                	ld	s1,8(sp)
    2544:	6902                	ld	s2,0(sp)
    2546:	6105                	addi	sp,sp,32
    2548:	8082                	ret
    printf("%s: open failed\n", s);
    254a:	85ca                	mv	a1,s2
    254c:	00004517          	auipc	a0,0x4
    2550:	88450513          	addi	a0,a0,-1916 # 5dd0 <malloc+0x9d4>
    2554:	5f1020ef          	jal	5344 <printf>
    exit(1);
    2558:	4505                	li	a0,1
    255a:	19f020ef          	jal	4ef8 <exit>

000000000000255e <sbrkbugs>:
{
    255e:	1141                	addi	sp,sp,-16
    2560:	e406                	sd	ra,8(sp)
    2562:	e022                	sd	s0,0(sp)
    2564:	0800                	addi	s0,sp,16
  int pid = fork();
    2566:	18b020ef          	jal	4ef0 <fork>
  if(pid < 0){
    256a:	00054c63          	bltz	a0,2582 <sbrkbugs+0x24>
  if(pid == 0){
    256e:	e11d                	bnez	a0,2594 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2570:	155020ef          	jal	4ec4 <sbrk>
    sbrk(-sz);
    2574:	40a0053b          	negw	a0,a0
    2578:	14d020ef          	jal	4ec4 <sbrk>
    exit(0);
    257c:	4501                	li	a0,0
    257e:	17b020ef          	jal	4ef8 <exit>
    printf("fork failed\n");
    2582:	00005517          	auipc	a0,0x5
    2586:	dde50513          	addi	a0,a0,-546 # 7360 <malloc+0x1f64>
    258a:	5bb020ef          	jal	5344 <printf>
    exit(1);
    258e:	4505                	li	a0,1
    2590:	169020ef          	jal	4ef8 <exit>
  wait(0);
    2594:	4501                	li	a0,0
    2596:	16b020ef          	jal	4f00 <wait>
  pid = fork();
    259a:	157020ef          	jal	4ef0 <fork>
  if(pid < 0){
    259e:	00054f63          	bltz	a0,25bc <sbrkbugs+0x5e>
  if(pid == 0){
    25a2:	e515                	bnez	a0,25ce <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    25a4:	121020ef          	jal	4ec4 <sbrk>
    sbrk(-(sz - 3500));
    25a8:	6785                	lui	a5,0x1
    25aa:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    25ae:	40a7853b          	subw	a0,a5,a0
    25b2:	113020ef          	jal	4ec4 <sbrk>
    exit(0);
    25b6:	4501                	li	a0,0
    25b8:	141020ef          	jal	4ef8 <exit>
    printf("fork failed\n");
    25bc:	00005517          	auipc	a0,0x5
    25c0:	da450513          	addi	a0,a0,-604 # 7360 <malloc+0x1f64>
    25c4:	581020ef          	jal	5344 <printf>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	12f020ef          	jal	4ef8 <exit>
  wait(0);
    25ce:	4501                	li	a0,0
    25d0:	131020ef          	jal	4f00 <wait>
  pid = fork();
    25d4:	11d020ef          	jal	4ef0 <fork>
  if(pid < 0){
    25d8:	02054263          	bltz	a0,25fc <sbrkbugs+0x9e>
  if(pid == 0){
    25dc:	e90d                	bnez	a0,260e <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    25de:	0e7020ef          	jal	4ec4 <sbrk>
    25e2:	67ad                	lui	a5,0xb
    25e4:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1268>
    25e8:	40a7853b          	subw	a0,a5,a0
    25ec:	0d9020ef          	jal	4ec4 <sbrk>
    sbrk(-10);
    25f0:	5559                	li	a0,-10
    25f2:	0d3020ef          	jal	4ec4 <sbrk>
    exit(0);
    25f6:	4501                	li	a0,0
    25f8:	101020ef          	jal	4ef8 <exit>
    printf("fork failed\n");
    25fc:	00005517          	auipc	a0,0x5
    2600:	d6450513          	addi	a0,a0,-668 # 7360 <malloc+0x1f64>
    2604:	541020ef          	jal	5344 <printf>
    exit(1);
    2608:	4505                	li	a0,1
    260a:	0ef020ef          	jal	4ef8 <exit>
  wait(0);
    260e:	4501                	li	a0,0
    2610:	0f1020ef          	jal	4f00 <wait>
  exit(0);
    2614:	4501                	li	a0,0
    2616:	0e3020ef          	jal	4ef8 <exit>

000000000000261a <sbrklast>:
{
    261a:	7179                	addi	sp,sp,-48
    261c:	f406                	sd	ra,40(sp)
    261e:	f022                	sd	s0,32(sp)
    2620:	ec26                	sd	s1,24(sp)
    2622:	e84a                	sd	s2,16(sp)
    2624:	e44e                	sd	s3,8(sp)
    2626:	e052                	sd	s4,0(sp)
    2628:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    262a:	4501                	li	a0,0
    262c:	099020ef          	jal	4ec4 <sbrk>
  if((top % PGSIZE) != 0)
    2630:	03451793          	slli	a5,a0,0x34
    2634:	ebad                	bnez	a5,26a6 <sbrklast+0x8c>
  sbrk(PGSIZE);
    2636:	6505                	lui	a0,0x1
    2638:	08d020ef          	jal	4ec4 <sbrk>
  sbrk(10);
    263c:	4529                	li	a0,10
    263e:	087020ef          	jal	4ec4 <sbrk>
  sbrk(-20);
    2642:	5531                	li	a0,-20
    2644:	081020ef          	jal	4ec4 <sbrk>
  top = (uint64) sbrk(0);
    2648:	4501                	li	a0,0
    264a:	07b020ef          	jal	4ec4 <sbrk>
    264e:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2650:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    2654:	07800993          	li	s3,120
    2658:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    265c:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2660:	20200593          	li	a1,514
    2664:	854a                	mv	a0,s2
    2666:	0d3020ef          	jal	4f38 <open>
    266a:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    266c:	4605                	li	a2,1
    266e:	85ca                	mv	a1,s2
    2670:	0a9020ef          	jal	4f18 <write>
  close(fd);
    2674:	8552                	mv	a0,s4
    2676:	0ab020ef          	jal	4f20 <close>
  fd = open(p, O_RDWR);
    267a:	4589                	li	a1,2
    267c:	854a                	mv	a0,s2
    267e:	0bb020ef          	jal	4f38 <open>
  p[0] = '\0';
    2682:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2686:	4605                	li	a2,1
    2688:	85ca                	mv	a1,s2
    268a:	087020ef          	jal	4f10 <read>
  if(p[0] != 'x')
    268e:	fc04c783          	lbu	a5,-64(s1)
    2692:	03379263          	bne	a5,s3,26b6 <sbrklast+0x9c>
}
    2696:	70a2                	ld	ra,40(sp)
    2698:	7402                	ld	s0,32(sp)
    269a:	64e2                	ld	s1,24(sp)
    269c:	6942                	ld	s2,16(sp)
    269e:	69a2                	ld	s3,8(sp)
    26a0:	6a02                	ld	s4,0(sp)
    26a2:	6145                	addi	sp,sp,48
    26a4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26a6:	0347d513          	srli	a0,a5,0x34
    26aa:	6785                	lui	a5,0x1
    26ac:	40a7853b          	subw	a0,a5,a0
    26b0:	015020ef          	jal	4ec4 <sbrk>
    26b4:	b749                	j	2636 <sbrklast+0x1c>
    exit(1);
    26b6:	4505                	li	a0,1
    26b8:	041020ef          	jal	4ef8 <exit>

00000000000026bc <sbrk8000>:
{
    26bc:	1141                	addi	sp,sp,-16
    26be:	e406                	sd	ra,8(sp)
    26c0:	e022                	sd	s0,0(sp)
    26c2:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    26c4:	80000537          	lui	a0,0x80000
    26c8:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff135c>
    26ca:	7fa020ef          	jal	4ec4 <sbrk>
  volatile char *top = sbrk(0);
    26ce:	4501                	li	a0,0
    26d0:	7f4020ef          	jal	4ec4 <sbrk>
  *(top-1) = *(top-1) + 1;
    26d4:	fff54783          	lbu	a5,-1(a0)
    26d8:	0785                	addi	a5,a5,1 # 1001 <bigdir+0x10d>
    26da:	0ff7f793          	zext.b	a5,a5
    26de:	fef50fa3          	sb	a5,-1(a0)
}
    26e2:	60a2                	ld	ra,8(sp)
    26e4:	6402                	ld	s0,0(sp)
    26e6:	0141                	addi	sp,sp,16
    26e8:	8082                	ret

00000000000026ea <execout>:
{
    26ea:	711d                	addi	sp,sp,-96
    26ec:	ec86                	sd	ra,88(sp)
    26ee:	e8a2                	sd	s0,80(sp)
    26f0:	e4a6                	sd	s1,72(sp)
    26f2:	e0ca                	sd	s2,64(sp)
    26f4:	fc4e                	sd	s3,56(sp)
    26f6:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    26f8:	4901                	li	s2,0
    26fa:	49bd                	li	s3,15
    int pid = fork();
    26fc:	7f4020ef          	jal	4ef0 <fork>
    2700:	84aa                	mv	s1,a0
    if(pid < 0){
    2702:	00054e63          	bltz	a0,271e <execout+0x34>
    } else if(pid == 0){
    2706:	c51d                	beqz	a0,2734 <execout+0x4a>
      wait((int*)0);
    2708:	4501                	li	a0,0
    270a:	7f6020ef          	jal	4f00 <wait>
  for(int avail = 0; avail < 15; avail++){
    270e:	2905                	addiw	s2,s2,1
    2710:	ff3916e3          	bne	s2,s3,26fc <execout+0x12>
    2714:	f852                	sd	s4,48(sp)
    2716:	f456                	sd	s5,40(sp)
  exit(0);
    2718:	4501                	li	a0,0
    271a:	7de020ef          	jal	4ef8 <exit>
    271e:	f852                	sd	s4,48(sp)
    2720:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    2722:	00005517          	auipc	a0,0x5
    2726:	c3e50513          	addi	a0,a0,-962 # 7360 <malloc+0x1f64>
    272a:	41b020ef          	jal	5344 <printf>
      exit(1);
    272e:	4505                	li	a0,1
    2730:	7c8020ef          	jal	4ef8 <exit>
    2734:	f852                	sd	s4,48(sp)
    2736:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    2738:	6985                	lui	s3,0x1
        if(a == SBRK_ERROR)
    273a:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    273c:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    273e:	854e                	mv	a0,s3
    2740:	784020ef          	jal	4ec4 <sbrk>
        if(a == SBRK_ERROR)
    2744:	01450663          	beq	a0,s4,2750 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    2748:	954e                	add	a0,a0,s3
    274a:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    274e:	bfc5                	j	273e <execout+0x54>
        sbrk(-PGSIZE);
    2750:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    2752:	01205863          	blez	s2,2762 <execout+0x78>
        sbrk(-PGSIZE);
    2756:	854e                	mv	a0,s3
    2758:	76c020ef          	jal	4ec4 <sbrk>
      for(int i = 0; i < avail; i++)
    275c:	2485                	addiw	s1,s1,1
    275e:	ff249ce3          	bne	s1,s2,2756 <execout+0x6c>
      close(1);
    2762:	4505                	li	a0,1
    2764:	7bc020ef          	jal	4f20 <close>
      char *args[] = { "echo", "x", 0 };
    2768:	00003797          	auipc	a5,0x3
    276c:	dc078793          	addi	a5,a5,-576 # 5528 <malloc+0x12c>
    2770:	faf43423          	sd	a5,-88(s0)
    2774:	00003797          	auipc	a5,0x3
    2778:	e2478793          	addi	a5,a5,-476 # 5598 <malloc+0x19c>
    277c:	faf43823          	sd	a5,-80(s0)
    2780:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    2784:	fa840593          	addi	a1,s0,-88
    2788:	00003517          	auipc	a0,0x3
    278c:	da050513          	addi	a0,a0,-608 # 5528 <malloc+0x12c>
    2790:	7a0020ef          	jal	4f30 <exec>
      exit(0);
    2794:	4501                	li	a0,0
    2796:	762020ef          	jal	4ef8 <exit>

000000000000279a <fourteen>:
{
    279a:	1101                	addi	sp,sp,-32
    279c:	ec06                	sd	ra,24(sp)
    279e:	e822                	sd	s0,16(sp)
    27a0:	e426                	sd	s1,8(sp)
    27a2:	1000                	addi	s0,sp,32
    27a4:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    27a6:	00004517          	auipc	a0,0x4
    27aa:	e1a50513          	addi	a0,a0,-486 # 65c0 <malloc+0x11c4>
    27ae:	7b2020ef          	jal	4f60 <mkdir>
    27b2:	e555                	bnez	a0,285e <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    27b4:	00004517          	auipc	a0,0x4
    27b8:	c6450513          	addi	a0,a0,-924 # 6418 <malloc+0x101c>
    27bc:	7a4020ef          	jal	4f60 <mkdir>
    27c0:	e94d                	bnez	a0,2872 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27c2:	20000593          	li	a1,512
    27c6:	00004517          	auipc	a0,0x4
    27ca:	caa50513          	addi	a0,a0,-854 # 6470 <malloc+0x1074>
    27ce:	76a020ef          	jal	4f38 <open>
  if(fd < 0){
    27d2:	0a054a63          	bltz	a0,2886 <fourteen+0xec>
  close(fd);
    27d6:	74a020ef          	jal	4f20 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27da:	4581                	li	a1,0
    27dc:	00004517          	auipc	a0,0x4
    27e0:	d0c50513          	addi	a0,a0,-756 # 64e8 <malloc+0x10ec>
    27e4:	754020ef          	jal	4f38 <open>
  if(fd < 0){
    27e8:	0a054963          	bltz	a0,289a <fourteen+0x100>
  close(fd);
    27ec:	734020ef          	jal	4f20 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    27f0:	00004517          	auipc	a0,0x4
    27f4:	d6850513          	addi	a0,a0,-664 # 6558 <malloc+0x115c>
    27f8:	768020ef          	jal	4f60 <mkdir>
    27fc:	c94d                	beqz	a0,28ae <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    27fe:	00004517          	auipc	a0,0x4
    2802:	db250513          	addi	a0,a0,-590 # 65b0 <malloc+0x11b4>
    2806:	75a020ef          	jal	4f60 <mkdir>
    280a:	cd45                	beqz	a0,28c2 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    280c:	00004517          	auipc	a0,0x4
    2810:	da450513          	addi	a0,a0,-604 # 65b0 <malloc+0x11b4>
    2814:	734020ef          	jal	4f48 <unlink>
  unlink("12345678901234/12345678901234");
    2818:	00004517          	auipc	a0,0x4
    281c:	d4050513          	addi	a0,a0,-704 # 6558 <malloc+0x115c>
    2820:	728020ef          	jal	4f48 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2824:	00004517          	auipc	a0,0x4
    2828:	cc450513          	addi	a0,a0,-828 # 64e8 <malloc+0x10ec>
    282c:	71c020ef          	jal	4f48 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2830:	00004517          	auipc	a0,0x4
    2834:	c4050513          	addi	a0,a0,-960 # 6470 <malloc+0x1074>
    2838:	710020ef          	jal	4f48 <unlink>
  unlink("12345678901234/123456789012345");
    283c:	00004517          	auipc	a0,0x4
    2840:	bdc50513          	addi	a0,a0,-1060 # 6418 <malloc+0x101c>
    2844:	704020ef          	jal	4f48 <unlink>
  unlink("12345678901234");
    2848:	00004517          	auipc	a0,0x4
    284c:	d7850513          	addi	a0,a0,-648 # 65c0 <malloc+0x11c4>
    2850:	6f8020ef          	jal	4f48 <unlink>
}
    2854:	60e2                	ld	ra,24(sp)
    2856:	6442                	ld	s0,16(sp)
    2858:	64a2                	ld	s1,8(sp)
    285a:	6105                	addi	sp,sp,32
    285c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    285e:	85a6                	mv	a1,s1
    2860:	00004517          	auipc	a0,0x4
    2864:	b9050513          	addi	a0,a0,-1136 # 63f0 <malloc+0xff4>
    2868:	2dd020ef          	jal	5344 <printf>
    exit(1);
    286c:	4505                	li	a0,1
    286e:	68a020ef          	jal	4ef8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2872:	85a6                	mv	a1,s1
    2874:	00004517          	auipc	a0,0x4
    2878:	bc450513          	addi	a0,a0,-1084 # 6438 <malloc+0x103c>
    287c:	2c9020ef          	jal	5344 <printf>
    exit(1);
    2880:	4505                	li	a0,1
    2882:	676020ef          	jal	4ef8 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2886:	85a6                	mv	a1,s1
    2888:	00004517          	auipc	a0,0x4
    288c:	c1850513          	addi	a0,a0,-1000 # 64a0 <malloc+0x10a4>
    2890:	2b5020ef          	jal	5344 <printf>
    exit(1);
    2894:	4505                	li	a0,1
    2896:	662020ef          	jal	4ef8 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    289a:	85a6                	mv	a1,s1
    289c:	00004517          	auipc	a0,0x4
    28a0:	c7c50513          	addi	a0,a0,-900 # 6518 <malloc+0x111c>
    28a4:	2a1020ef          	jal	5344 <printf>
    exit(1);
    28a8:	4505                	li	a0,1
    28aa:	64e020ef          	jal	4ef8 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    28ae:	85a6                	mv	a1,s1
    28b0:	00004517          	auipc	a0,0x4
    28b4:	cc850513          	addi	a0,a0,-824 # 6578 <malloc+0x117c>
    28b8:	28d020ef          	jal	5344 <printf>
    exit(1);
    28bc:	4505                	li	a0,1
    28be:	63a020ef          	jal	4ef8 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    28c2:	85a6                	mv	a1,s1
    28c4:	00004517          	auipc	a0,0x4
    28c8:	d0c50513          	addi	a0,a0,-756 # 65d0 <malloc+0x11d4>
    28cc:	279020ef          	jal	5344 <printf>
    exit(1);
    28d0:	4505                	li	a0,1
    28d2:	626020ef          	jal	4ef8 <exit>

00000000000028d6 <diskfull>:
{
    28d6:	b6010113          	addi	sp,sp,-1184
    28da:	48113c23          	sd	ra,1176(sp)
    28de:	48813823          	sd	s0,1168(sp)
    28e2:	48913423          	sd	s1,1160(sp)
    28e6:	49213023          	sd	s2,1152(sp)
    28ea:	47313c23          	sd	s3,1144(sp)
    28ee:	47413823          	sd	s4,1136(sp)
    28f2:	47513423          	sd	s5,1128(sp)
    28f6:	47613023          	sd	s6,1120(sp)
    28fa:	45713c23          	sd	s7,1112(sp)
    28fe:	45813823          	sd	s8,1104(sp)
    2902:	45913423          	sd	s9,1096(sp)
    2906:	45a13023          	sd	s10,1088(sp)
    290a:	43b13c23          	sd	s11,1080(sp)
    290e:	4a010413          	addi	s0,sp,1184
    2912:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2916:	00004517          	auipc	a0,0x4
    291a:	cf250513          	addi	a0,a0,-782 # 6608 <malloc+0x120c>
    291e:	62a020ef          	jal	4f48 <unlink>
    2922:	03000a93          	li	s5,48
    name[0] = 'b';
    2926:	06200d13          	li	s10,98
    name[1] = 'i';
    292a:	06900c93          	li	s9,105
    name[2] = 'g';
    292e:	06700c13          	li	s8,103
    unlink(name);
    2932:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2936:	60200b93          	li	s7,1538
    293a:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    293e:	b9040a13          	addi	s4,s0,-1136
    2942:	aa8d                	j	2ab4 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    2944:	b7040613          	addi	a2,s0,-1168
    2948:	b6843583          	ld	a1,-1176(s0)
    294c:	00004517          	auipc	a0,0x4
    2950:	ccc50513          	addi	a0,a0,-820 # 6618 <malloc+0x121c>
    2954:	1f1020ef          	jal	5344 <printf>
      break;
    2958:	a039                	j	2966 <diskfull+0x90>
        close(fd);
    295a:	854e                	mv	a0,s3
    295c:	5c4020ef          	jal	4f20 <close>
    close(fd);
    2960:	854e                	mv	a0,s3
    2962:	5be020ef          	jal	4f20 <close>
  for(int i = 0; i < nzz; i++){
    2966:	4481                	li	s1,0
    name[0] = 'z';
    2968:	07a00993          	li	s3,122
    unlink(name);
    296c:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2970:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    2974:	08000a93          	li	s5,128
    name[0] = 'z';
    2978:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    297c:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2980:	41f4d71b          	sraiw	a4,s1,0x1f
    2984:	01b7571b          	srliw	a4,a4,0x1b
    2988:	009707bb          	addw	a5,a4,s1
    298c:	4057d69b          	sraiw	a3,a5,0x5
    2990:	0306869b          	addiw	a3,a3,48
    2994:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2998:	8bfd                	andi	a5,a5,31
    299a:	9f99                	subw	a5,a5,a4
    299c:	0307879b          	addiw	a5,a5,48
    29a0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    29a4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    29a8:	854a                	mv	a0,s2
    29aa:	59e020ef          	jal	4f48 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29ae:	85d2                	mv	a1,s4
    29b0:	854a                	mv	a0,s2
    29b2:	586020ef          	jal	4f38 <open>
    if(fd < 0)
    29b6:	00054763          	bltz	a0,29c4 <diskfull+0xee>
    close(fd);
    29ba:	566020ef          	jal	4f20 <close>
  for(int i = 0; i < nzz; i++){
    29be:	2485                	addiw	s1,s1,1
    29c0:	fb549ce3          	bne	s1,s5,2978 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
    29c4:	00004517          	auipc	a0,0x4
    29c8:	c4450513          	addi	a0,a0,-956 # 6608 <malloc+0x120c>
    29cc:	594020ef          	jal	4f60 <mkdir>
    29d0:	12050363          	beqz	a0,2af6 <diskfull+0x220>
  unlink("diskfulldir");
    29d4:	00004517          	auipc	a0,0x4
    29d8:	c3450513          	addi	a0,a0,-972 # 6608 <malloc+0x120c>
    29dc:	56c020ef          	jal	4f48 <unlink>
  for(int i = 0; i < nzz; i++){
    29e0:	4481                	li	s1,0
    name[0] = 'z';
    29e2:	07a00913          	li	s2,122
    unlink(name);
    29e6:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    29ea:	08000993          	li	s3,128
    name[0] = 'z';
    29ee:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    29f2:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    29f6:	41f4d71b          	sraiw	a4,s1,0x1f
    29fa:	01b7571b          	srliw	a4,a4,0x1b
    29fe:	009707bb          	addw	a5,a4,s1
    2a02:	4057d69b          	sraiw	a3,a5,0x5
    2a06:	0306869b          	addiw	a3,a3,48
    2a0a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2a0e:	8bfd                	andi	a5,a5,31
    2a10:	9f99                	subw	a5,a5,a4
    2a12:	0307879b          	addiw	a5,a5,48
    2a16:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2a1a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a1e:	8552                	mv	a0,s4
    2a20:	528020ef          	jal	4f48 <unlink>
  for(int i = 0; i < nzz; i++){
    2a24:	2485                	addiw	s1,s1,1
    2a26:	fd3494e3          	bne	s1,s3,29ee <diskfull+0x118>
    2a2a:	03000493          	li	s1,48
    name[0] = 'b';
    2a2e:	06200b13          	li	s6,98
    name[1] = 'i';
    2a32:	06900a93          	li	s5,105
    name[2] = 'g';
    2a36:	06700a13          	li	s4,103
    unlink(name);
    2a3a:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    2a3e:	07f00913          	li	s2,127
    name[0] = 'b';
    2a42:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2a46:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2a4a:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    2a4e:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2a52:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a56:	854e                	mv	a0,s3
    2a58:	4f0020ef          	jal	4f48 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2a5c:	2485                	addiw	s1,s1,1
    2a5e:	0ff4f493          	zext.b	s1,s1
    2a62:	ff2490e3          	bne	s1,s2,2a42 <diskfull+0x16c>
}
    2a66:	49813083          	ld	ra,1176(sp)
    2a6a:	49013403          	ld	s0,1168(sp)
    2a6e:	48813483          	ld	s1,1160(sp)
    2a72:	48013903          	ld	s2,1152(sp)
    2a76:	47813983          	ld	s3,1144(sp)
    2a7a:	47013a03          	ld	s4,1136(sp)
    2a7e:	46813a83          	ld	s5,1128(sp)
    2a82:	46013b03          	ld	s6,1120(sp)
    2a86:	45813b83          	ld	s7,1112(sp)
    2a8a:	45013c03          	ld	s8,1104(sp)
    2a8e:	44813c83          	ld	s9,1096(sp)
    2a92:	44013d03          	ld	s10,1088(sp)
    2a96:	43813d83          	ld	s11,1080(sp)
    2a9a:	4a010113          	addi	sp,sp,1184
    2a9e:	8082                	ret
    close(fd);
    2aa0:	854e                	mv	a0,s3
    2aa2:	47e020ef          	jal	4f20 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2aa6:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x301>
    2aa8:	0ffafa93          	zext.b	s5,s5
    2aac:	07f00793          	li	a5,127
    2ab0:	eafa8be3          	beq	s5,a5,2966 <diskfull+0x90>
    name[0] = 'b';
    2ab4:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2ab8:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2abc:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2ac0:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2ac4:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2ac8:	855a                	mv	a0,s6
    2aca:	47e020ef          	jal	4f48 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2ace:	85de                	mv	a1,s7
    2ad0:	855a                	mv	a0,s6
    2ad2:	466020ef          	jal	4f38 <open>
    2ad6:	89aa                	mv	s3,a0
    if(fd < 0){
    2ad8:	e60546e3          	bltz	a0,2944 <diskfull+0x6e>
    2adc:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    2ade:	40000913          	li	s2,1024
    2ae2:	864a                	mv	a2,s2
    2ae4:	85d2                	mv	a1,s4
    2ae6:	854e                	mv	a0,s3
    2ae8:	430020ef          	jal	4f18 <write>
    2aec:	e72517e3          	bne	a0,s2,295a <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
    2af0:	34fd                	addiw	s1,s1,-1
    2af2:	f8e5                	bnez	s1,2ae2 <diskfull+0x20c>
    2af4:	b775                	j	2aa0 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2af6:	b6843583          	ld	a1,-1176(s0)
    2afa:	00004517          	auipc	a0,0x4
    2afe:	b3e50513          	addi	a0,a0,-1218 # 6638 <malloc+0x123c>
    2b02:	043020ef          	jal	5344 <printf>
    2b06:	b5f9                	j	29d4 <diskfull+0xfe>

0000000000002b08 <iputtest>:
{
    2b08:	1101                	addi	sp,sp,-32
    2b0a:	ec06                	sd	ra,24(sp)
    2b0c:	e822                	sd	s0,16(sp)
    2b0e:	e426                	sd	s1,8(sp)
    2b10:	1000                	addi	s0,sp,32
    2b12:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b14:	00004517          	auipc	a0,0x4
    2b18:	b5450513          	addi	a0,a0,-1196 # 6668 <malloc+0x126c>
    2b1c:	444020ef          	jal	4f60 <mkdir>
    2b20:	02054f63          	bltz	a0,2b5e <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2b24:	00004517          	auipc	a0,0x4
    2b28:	b4450513          	addi	a0,a0,-1212 # 6668 <malloc+0x126c>
    2b2c:	43c020ef          	jal	4f68 <chdir>
    2b30:	04054163          	bltz	a0,2b72 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2b34:	00004517          	auipc	a0,0x4
    2b38:	b7450513          	addi	a0,a0,-1164 # 66a8 <malloc+0x12ac>
    2b3c:	40c020ef          	jal	4f48 <unlink>
    2b40:	04054363          	bltz	a0,2b86 <iputtest+0x7e>
  if(chdir("/") < 0){
    2b44:	00004517          	auipc	a0,0x4
    2b48:	b9450513          	addi	a0,a0,-1132 # 66d8 <malloc+0x12dc>
    2b4c:	41c020ef          	jal	4f68 <chdir>
    2b50:	04054563          	bltz	a0,2b9a <iputtest+0x92>
}
    2b54:	60e2                	ld	ra,24(sp)
    2b56:	6442                	ld	s0,16(sp)
    2b58:	64a2                	ld	s1,8(sp)
    2b5a:	6105                	addi	sp,sp,32
    2b5c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b5e:	85a6                	mv	a1,s1
    2b60:	00004517          	auipc	a0,0x4
    2b64:	b1050513          	addi	a0,a0,-1264 # 6670 <malloc+0x1274>
    2b68:	7dc020ef          	jal	5344 <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	38a020ef          	jal	4ef8 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	b1450513          	addi	a0,a0,-1260 # 6688 <malloc+0x128c>
    2b7c:	7c8020ef          	jal	5344 <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	376020ef          	jal	4ef8 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2b86:	85a6                	mv	a1,s1
    2b88:	00004517          	auipc	a0,0x4
    2b8c:	b3050513          	addi	a0,a0,-1232 # 66b8 <malloc+0x12bc>
    2b90:	7b4020ef          	jal	5344 <printf>
    exit(1);
    2b94:	4505                	li	a0,1
    2b96:	362020ef          	jal	4ef8 <exit>
    printf("%s: chdir / failed\n", s);
    2b9a:	85a6                	mv	a1,s1
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	b4450513          	addi	a0,a0,-1212 # 66e0 <malloc+0x12e4>
    2ba4:	7a0020ef          	jal	5344 <printf>
    exit(1);
    2ba8:	4505                	li	a0,1
    2baa:	34e020ef          	jal	4ef8 <exit>

0000000000002bae <exitiputtest>:
{
    2bae:	7179                	addi	sp,sp,-48
    2bb0:	f406                	sd	ra,40(sp)
    2bb2:	f022                	sd	s0,32(sp)
    2bb4:	ec26                	sd	s1,24(sp)
    2bb6:	1800                	addi	s0,sp,48
    2bb8:	84aa                	mv	s1,a0
  pid = fork();
    2bba:	336020ef          	jal	4ef0 <fork>
  if(pid < 0){
    2bbe:	02054e63          	bltz	a0,2bfa <exitiputtest+0x4c>
  if(pid == 0){
    2bc2:	e541                	bnez	a0,2c4a <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2bc4:	00004517          	auipc	a0,0x4
    2bc8:	aa450513          	addi	a0,a0,-1372 # 6668 <malloc+0x126c>
    2bcc:	394020ef          	jal	4f60 <mkdir>
    2bd0:	02054f63          	bltz	a0,2c0e <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2bd4:	00004517          	auipc	a0,0x4
    2bd8:	a9450513          	addi	a0,a0,-1388 # 6668 <malloc+0x126c>
    2bdc:	38c020ef          	jal	4f68 <chdir>
    2be0:	04054163          	bltz	a0,2c22 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2be4:	00004517          	auipc	a0,0x4
    2be8:	ac450513          	addi	a0,a0,-1340 # 66a8 <malloc+0x12ac>
    2bec:	35c020ef          	jal	4f48 <unlink>
    2bf0:	04054363          	bltz	a0,2c36 <exitiputtest+0x88>
    exit(0);
    2bf4:	4501                	li	a0,0
    2bf6:	302020ef          	jal	4ef8 <exit>
    printf("%s: fork failed\n", s);
    2bfa:	85a6                	mv	a1,s1
    2bfc:	00003517          	auipc	a0,0x3
    2c00:	1bc50513          	addi	a0,a0,444 # 5db8 <malloc+0x9bc>
    2c04:	740020ef          	jal	5344 <printf>
    exit(1);
    2c08:	4505                	li	a0,1
    2c0a:	2ee020ef          	jal	4ef8 <exit>
      printf("%s: mkdir failed\n", s);
    2c0e:	85a6                	mv	a1,s1
    2c10:	00004517          	auipc	a0,0x4
    2c14:	a6050513          	addi	a0,a0,-1440 # 6670 <malloc+0x1274>
    2c18:	72c020ef          	jal	5344 <printf>
      exit(1);
    2c1c:	4505                	li	a0,1
    2c1e:	2da020ef          	jal	4ef8 <exit>
      printf("%s: child chdir failed\n", s);
    2c22:	85a6                	mv	a1,s1
    2c24:	00004517          	auipc	a0,0x4
    2c28:	ad450513          	addi	a0,a0,-1324 # 66f8 <malloc+0x12fc>
    2c2c:	718020ef          	jal	5344 <printf>
      exit(1);
    2c30:	4505                	li	a0,1
    2c32:	2c6020ef          	jal	4ef8 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c36:	85a6                	mv	a1,s1
    2c38:	00004517          	auipc	a0,0x4
    2c3c:	a8050513          	addi	a0,a0,-1408 # 66b8 <malloc+0x12bc>
    2c40:	704020ef          	jal	5344 <printf>
      exit(1);
    2c44:	4505                	li	a0,1
    2c46:	2b2020ef          	jal	4ef8 <exit>
  wait(&xstatus);
    2c4a:	fdc40513          	addi	a0,s0,-36
    2c4e:	2b2020ef          	jal	4f00 <wait>
  exit(xstatus);
    2c52:	fdc42503          	lw	a0,-36(s0)
    2c56:	2a2020ef          	jal	4ef8 <exit>

0000000000002c5a <dirtest>:
{
    2c5a:	1101                	addi	sp,sp,-32
    2c5c:	ec06                	sd	ra,24(sp)
    2c5e:	e822                	sd	s0,16(sp)
    2c60:	e426                	sd	s1,8(sp)
    2c62:	1000                	addi	s0,sp,32
    2c64:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2c66:	00004517          	auipc	a0,0x4
    2c6a:	aaa50513          	addi	a0,a0,-1366 # 6710 <malloc+0x1314>
    2c6e:	2f2020ef          	jal	4f60 <mkdir>
    2c72:	02054f63          	bltz	a0,2cb0 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2c76:	00004517          	auipc	a0,0x4
    2c7a:	a9a50513          	addi	a0,a0,-1382 # 6710 <malloc+0x1314>
    2c7e:	2ea020ef          	jal	4f68 <chdir>
    2c82:	04054163          	bltz	a0,2cc4 <dirtest+0x6a>
  if(chdir("..") < 0){
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	aaa50513          	addi	a0,a0,-1366 # 6730 <malloc+0x1334>
    2c8e:	2da020ef          	jal	4f68 <chdir>
    2c92:	04054363          	bltz	a0,2cd8 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2c96:	00004517          	auipc	a0,0x4
    2c9a:	a7a50513          	addi	a0,a0,-1414 # 6710 <malloc+0x1314>
    2c9e:	2aa020ef          	jal	4f48 <unlink>
    2ca2:	04054563          	bltz	a0,2cec <dirtest+0x92>
}
    2ca6:	60e2                	ld	ra,24(sp)
    2ca8:	6442                	ld	s0,16(sp)
    2caa:	64a2                	ld	s1,8(sp)
    2cac:	6105                	addi	sp,sp,32
    2cae:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cb0:	85a6                	mv	a1,s1
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	9be50513          	addi	a0,a0,-1602 # 6670 <malloc+0x1274>
    2cba:	68a020ef          	jal	5344 <printf>
    exit(1);
    2cbe:	4505                	li	a0,1
    2cc0:	238020ef          	jal	4ef8 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2cc4:	85a6                	mv	a1,s1
    2cc6:	00004517          	auipc	a0,0x4
    2cca:	a5250513          	addi	a0,a0,-1454 # 6718 <malloc+0x131c>
    2cce:	676020ef          	jal	5344 <printf>
    exit(1);
    2cd2:	4505                	li	a0,1
    2cd4:	224020ef          	jal	4ef8 <exit>
    printf("%s: chdir .. failed\n", s);
    2cd8:	85a6                	mv	a1,s1
    2cda:	00004517          	auipc	a0,0x4
    2cde:	a5e50513          	addi	a0,a0,-1442 # 6738 <malloc+0x133c>
    2ce2:	662020ef          	jal	5344 <printf>
    exit(1);
    2ce6:	4505                	li	a0,1
    2ce8:	210020ef          	jal	4ef8 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2cec:	85a6                	mv	a1,s1
    2cee:	00004517          	auipc	a0,0x4
    2cf2:	a6250513          	addi	a0,a0,-1438 # 6750 <malloc+0x1354>
    2cf6:	64e020ef          	jal	5344 <printf>
    exit(1);
    2cfa:	4505                	li	a0,1
    2cfc:	1fc020ef          	jal	4ef8 <exit>

0000000000002d00 <subdir>:
{
    2d00:	1101                	addi	sp,sp,-32
    2d02:	ec06                	sd	ra,24(sp)
    2d04:	e822                	sd	s0,16(sp)
    2d06:	e426                	sd	s1,8(sp)
    2d08:	e04a                	sd	s2,0(sp)
    2d0a:	1000                	addi	s0,sp,32
    2d0c:	892a                	mv	s2,a0
  unlink("ff");
    2d0e:	00004517          	auipc	a0,0x4
    2d12:	b8a50513          	addi	a0,a0,-1142 # 6898 <malloc+0x149c>
    2d16:	232020ef          	jal	4f48 <unlink>
  if(mkdir("dd") != 0){
    2d1a:	00004517          	auipc	a0,0x4
    2d1e:	a4e50513          	addi	a0,a0,-1458 # 6768 <malloc+0x136c>
    2d22:	23e020ef          	jal	4f60 <mkdir>
    2d26:	2e051263          	bnez	a0,300a <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d2a:	20200593          	li	a1,514
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	a5a50513          	addi	a0,a0,-1446 # 6788 <malloc+0x138c>
    2d36:	202020ef          	jal	4f38 <open>
    2d3a:	84aa                	mv	s1,a0
  if(fd < 0){
    2d3c:	2e054163          	bltz	a0,301e <subdir+0x31e>
  write(fd, "ff", 2);
    2d40:	4609                	li	a2,2
    2d42:	00004597          	auipc	a1,0x4
    2d46:	b5658593          	addi	a1,a1,-1194 # 6898 <malloc+0x149c>
    2d4a:	1ce020ef          	jal	4f18 <write>
  close(fd);
    2d4e:	8526                	mv	a0,s1
    2d50:	1d0020ef          	jal	4f20 <close>
  if(unlink("dd") >= 0){
    2d54:	00004517          	auipc	a0,0x4
    2d58:	a1450513          	addi	a0,a0,-1516 # 6768 <malloc+0x136c>
    2d5c:	1ec020ef          	jal	4f48 <unlink>
    2d60:	2c055963          	bgez	a0,3032 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2d64:	00004517          	auipc	a0,0x4
    2d68:	a7c50513          	addi	a0,a0,-1412 # 67e0 <malloc+0x13e4>
    2d6c:	1f4020ef          	jal	4f60 <mkdir>
    2d70:	2c051b63          	bnez	a0,3046 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d74:	20200593          	li	a1,514
    2d78:	00004517          	auipc	a0,0x4
    2d7c:	a9050513          	addi	a0,a0,-1392 # 6808 <malloc+0x140c>
    2d80:	1b8020ef          	jal	4f38 <open>
    2d84:	84aa                	mv	s1,a0
  if(fd < 0){
    2d86:	2c054a63          	bltz	a0,305a <subdir+0x35a>
  write(fd, "FF", 2);
    2d8a:	4609                	li	a2,2
    2d8c:	00004597          	auipc	a1,0x4
    2d90:	aac58593          	addi	a1,a1,-1364 # 6838 <malloc+0x143c>
    2d94:	184020ef          	jal	4f18 <write>
  close(fd);
    2d98:	8526                	mv	a0,s1
    2d9a:	186020ef          	jal	4f20 <close>
  fd = open("dd/dd/../ff", 0);
    2d9e:	4581                	li	a1,0
    2da0:	00004517          	auipc	a0,0x4
    2da4:	aa050513          	addi	a0,a0,-1376 # 6840 <malloc+0x1444>
    2da8:	190020ef          	jal	4f38 <open>
    2dac:	84aa                	mv	s1,a0
  if(fd < 0){
    2dae:	2c054063          	bltz	a0,306e <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2db2:	660d                	lui	a2,0x3
    2db4:	00009597          	auipc	a1,0x9
    2db8:	ef458593          	addi	a1,a1,-268 # bca8 <buf>
    2dbc:	154020ef          	jal	4f10 <read>
  if(cc != 2 || buf[0] != 'f'){
    2dc0:	4789                	li	a5,2
    2dc2:	2cf51063          	bne	a0,a5,3082 <subdir+0x382>
    2dc6:	00009717          	auipc	a4,0x9
    2dca:	ee274703          	lbu	a4,-286(a4) # bca8 <buf>
    2dce:	06600793          	li	a5,102
    2dd2:	2af71863          	bne	a4,a5,3082 <subdir+0x382>
  close(fd);
    2dd6:	8526                	mv	a0,s1
    2dd8:	148020ef          	jal	4f20 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2ddc:	00004597          	auipc	a1,0x4
    2de0:	ab458593          	addi	a1,a1,-1356 # 6890 <malloc+0x1494>
    2de4:	00004517          	auipc	a0,0x4
    2de8:	a2450513          	addi	a0,a0,-1500 # 6808 <malloc+0x140c>
    2dec:	16c020ef          	jal	4f58 <link>
    2df0:	2a051363          	bnez	a0,3096 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2df4:	00004517          	auipc	a0,0x4
    2df8:	a1450513          	addi	a0,a0,-1516 # 6808 <malloc+0x140c>
    2dfc:	14c020ef          	jal	4f48 <unlink>
    2e00:	2a051563          	bnez	a0,30aa <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e04:	4581                	li	a1,0
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	a0250513          	addi	a0,a0,-1534 # 6808 <malloc+0x140c>
    2e0e:	12a020ef          	jal	4f38 <open>
    2e12:	2a055663          	bgez	a0,30be <subdir+0x3be>
  if(chdir("dd") != 0){
    2e16:	00004517          	auipc	a0,0x4
    2e1a:	95250513          	addi	a0,a0,-1710 # 6768 <malloc+0x136c>
    2e1e:	14a020ef          	jal	4f68 <chdir>
    2e22:	2a051863          	bnez	a0,30d2 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	b0250513          	addi	a0,a0,-1278 # 6928 <malloc+0x152c>
    2e2e:	13a020ef          	jal	4f68 <chdir>
    2e32:	2a051a63          	bnez	a0,30e6 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2e36:	00004517          	auipc	a0,0x4
    2e3a:	b2250513          	addi	a0,a0,-1246 # 6958 <malloc+0x155c>
    2e3e:	12a020ef          	jal	4f68 <chdir>
    2e42:	2a051c63          	bnez	a0,30fa <subdir+0x3fa>
  if(chdir("./..") != 0){
    2e46:	00004517          	auipc	a0,0x4
    2e4a:	b4a50513          	addi	a0,a0,-1206 # 6990 <malloc+0x1594>
    2e4e:	11a020ef          	jal	4f68 <chdir>
    2e52:	2a051e63          	bnez	a0,310e <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2e56:	4581                	li	a1,0
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	a3850513          	addi	a0,a0,-1480 # 6890 <malloc+0x1494>
    2e60:	0d8020ef          	jal	4f38 <open>
    2e64:	84aa                	mv	s1,a0
  if(fd < 0){
    2e66:	2a054e63          	bltz	a0,3122 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e6a:	660d                	lui	a2,0x3
    2e6c:	00009597          	auipc	a1,0x9
    2e70:	e3c58593          	addi	a1,a1,-452 # bca8 <buf>
    2e74:	09c020ef          	jal	4f10 <read>
    2e78:	4789                	li	a5,2
    2e7a:	2af51e63          	bne	a0,a5,3136 <subdir+0x436>
  close(fd);
    2e7e:	8526                	mv	a0,s1
    2e80:	0a0020ef          	jal	4f20 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e84:	4581                	li	a1,0
    2e86:	00004517          	auipc	a0,0x4
    2e8a:	98250513          	addi	a0,a0,-1662 # 6808 <malloc+0x140c>
    2e8e:	0aa020ef          	jal	4f38 <open>
    2e92:	2a055c63          	bgez	a0,314a <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2e96:	20200593          	li	a1,514
    2e9a:	00004517          	auipc	a0,0x4
    2e9e:	b8650513          	addi	a0,a0,-1146 # 6a20 <malloc+0x1624>
    2ea2:	096020ef          	jal	4f38 <open>
    2ea6:	2a055c63          	bgez	a0,315e <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2eaa:	20200593          	li	a1,514
    2eae:	00004517          	auipc	a0,0x4
    2eb2:	ba250513          	addi	a0,a0,-1118 # 6a50 <malloc+0x1654>
    2eb6:	082020ef          	jal	4f38 <open>
    2eba:	2a055c63          	bgez	a0,3172 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2ebe:	20000593          	li	a1,512
    2ec2:	00004517          	auipc	a0,0x4
    2ec6:	8a650513          	addi	a0,a0,-1882 # 6768 <malloc+0x136c>
    2eca:	06e020ef          	jal	4f38 <open>
    2ece:	2a055c63          	bgez	a0,3186 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2ed2:	4589                	li	a1,2
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	89450513          	addi	a0,a0,-1900 # 6768 <malloc+0x136c>
    2edc:	05c020ef          	jal	4f38 <open>
    2ee0:	2a055d63          	bgez	a0,319a <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2ee4:	4585                	li	a1,1
    2ee6:	00004517          	auipc	a0,0x4
    2eea:	88250513          	addi	a0,a0,-1918 # 6768 <malloc+0x136c>
    2eee:	04a020ef          	jal	4f38 <open>
    2ef2:	2a055e63          	bgez	a0,31ae <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2ef6:	00004597          	auipc	a1,0x4
    2efa:	bea58593          	addi	a1,a1,-1046 # 6ae0 <malloc+0x16e4>
    2efe:	00004517          	auipc	a0,0x4
    2f02:	b2250513          	addi	a0,a0,-1246 # 6a20 <malloc+0x1624>
    2f06:	052020ef          	jal	4f58 <link>
    2f0a:	2a050c63          	beqz	a0,31c2 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f0e:	00004597          	auipc	a1,0x4
    2f12:	bd258593          	addi	a1,a1,-1070 # 6ae0 <malloc+0x16e4>
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	b3a50513          	addi	a0,a0,-1222 # 6a50 <malloc+0x1654>
    2f1e:	03a020ef          	jal	4f58 <link>
    2f22:	2a050a63          	beqz	a0,31d6 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f26:	00004597          	auipc	a1,0x4
    2f2a:	96a58593          	addi	a1,a1,-1686 # 6890 <malloc+0x1494>
    2f2e:	00004517          	auipc	a0,0x4
    2f32:	85a50513          	addi	a0,a0,-1958 # 6788 <malloc+0x138c>
    2f36:	022020ef          	jal	4f58 <link>
    2f3a:	2a050863          	beqz	a0,31ea <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2f3e:	00004517          	auipc	a0,0x4
    2f42:	ae250513          	addi	a0,a0,-1310 # 6a20 <malloc+0x1624>
    2f46:	01a020ef          	jal	4f60 <mkdir>
    2f4a:	2a050a63          	beqz	a0,31fe <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	b0250513          	addi	a0,a0,-1278 # 6a50 <malloc+0x1654>
    2f56:	00a020ef          	jal	4f60 <mkdir>
    2f5a:	2a050c63          	beqz	a0,3212 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	93250513          	addi	a0,a0,-1742 # 6890 <malloc+0x1494>
    2f66:	7fb010ef          	jal	4f60 <mkdir>
    2f6a:	2a050e63          	beqz	a0,3226 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2f6e:	00004517          	auipc	a0,0x4
    2f72:	ae250513          	addi	a0,a0,-1310 # 6a50 <malloc+0x1654>
    2f76:	7d3010ef          	jal	4f48 <unlink>
    2f7a:	2c050063          	beqz	a0,323a <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	aa250513          	addi	a0,a0,-1374 # 6a20 <malloc+0x1624>
    2f86:	7c3010ef          	jal	4f48 <unlink>
    2f8a:	2c050263          	beqz	a0,324e <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2f8e:	00003517          	auipc	a0,0x3
    2f92:	7fa50513          	addi	a0,a0,2042 # 6788 <malloc+0x138c>
    2f96:	7d3010ef          	jal	4f68 <chdir>
    2f9a:	2c050463          	beqz	a0,3262 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2f9e:	00004517          	auipc	a0,0x4
    2fa2:	c9250513          	addi	a0,a0,-878 # 6c30 <malloc+0x1834>
    2fa6:	7c3010ef          	jal	4f68 <chdir>
    2faa:	2c050663          	beqz	a0,3276 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	8e250513          	addi	a0,a0,-1822 # 6890 <malloc+0x1494>
    2fb6:	793010ef          	jal	4f48 <unlink>
    2fba:	2c051863          	bnez	a0,328a <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2fbe:	00003517          	auipc	a0,0x3
    2fc2:	7ca50513          	addi	a0,a0,1994 # 6788 <malloc+0x138c>
    2fc6:	783010ef          	jal	4f48 <unlink>
    2fca:	2c051a63          	bnez	a0,329e <subdir+0x59e>
  if(unlink("dd") == 0){
    2fce:	00003517          	auipc	a0,0x3
    2fd2:	79a50513          	addi	a0,a0,1946 # 6768 <malloc+0x136c>
    2fd6:	773010ef          	jal	4f48 <unlink>
    2fda:	2c050c63          	beqz	a0,32b2 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	cc250513          	addi	a0,a0,-830 # 6ca0 <malloc+0x18a4>
    2fe6:	763010ef          	jal	4f48 <unlink>
    2fea:	2c054e63          	bltz	a0,32c6 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2fee:	00003517          	auipc	a0,0x3
    2ff2:	77a50513          	addi	a0,a0,1914 # 6768 <malloc+0x136c>
    2ff6:	753010ef          	jal	4f48 <unlink>
    2ffa:	2e054063          	bltz	a0,32da <subdir+0x5da>
}
    2ffe:	60e2                	ld	ra,24(sp)
    3000:	6442                	ld	s0,16(sp)
    3002:	64a2                	ld	s1,8(sp)
    3004:	6902                	ld	s2,0(sp)
    3006:	6105                	addi	sp,sp,32
    3008:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    300a:	85ca                	mv	a1,s2
    300c:	00003517          	auipc	a0,0x3
    3010:	76450513          	addi	a0,a0,1892 # 6770 <malloc+0x1374>
    3014:	330020ef          	jal	5344 <printf>
    exit(1);
    3018:	4505                	li	a0,1
    301a:	6df010ef          	jal	4ef8 <exit>
    printf("%s: create dd/ff failed\n", s);
    301e:	85ca                	mv	a1,s2
    3020:	00003517          	auipc	a0,0x3
    3024:	77050513          	addi	a0,a0,1904 # 6790 <malloc+0x1394>
    3028:	31c020ef          	jal	5344 <printf>
    exit(1);
    302c:	4505                	li	a0,1
    302e:	6cb010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3032:	85ca                	mv	a1,s2
    3034:	00003517          	auipc	a0,0x3
    3038:	77c50513          	addi	a0,a0,1916 # 67b0 <malloc+0x13b4>
    303c:	308020ef          	jal	5344 <printf>
    exit(1);
    3040:	4505                	li	a0,1
    3042:	6b7010ef          	jal	4ef8 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3046:	85ca                	mv	a1,s2
    3048:	00003517          	auipc	a0,0x3
    304c:	7a050513          	addi	a0,a0,1952 # 67e8 <malloc+0x13ec>
    3050:	2f4020ef          	jal	5344 <printf>
    exit(1);
    3054:	4505                	li	a0,1
    3056:	6a3010ef          	jal	4ef8 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    305a:	85ca                	mv	a1,s2
    305c:	00003517          	auipc	a0,0x3
    3060:	7bc50513          	addi	a0,a0,1980 # 6818 <malloc+0x141c>
    3064:	2e0020ef          	jal	5344 <printf>
    exit(1);
    3068:	4505                	li	a0,1
    306a:	68f010ef          	jal	4ef8 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    306e:	85ca                	mv	a1,s2
    3070:	00003517          	auipc	a0,0x3
    3074:	7e050513          	addi	a0,a0,2016 # 6850 <malloc+0x1454>
    3078:	2cc020ef          	jal	5344 <printf>
    exit(1);
    307c:	4505                	li	a0,1
    307e:	67b010ef          	jal	4ef8 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3082:	85ca                	mv	a1,s2
    3084:	00003517          	auipc	a0,0x3
    3088:	7ec50513          	addi	a0,a0,2028 # 6870 <malloc+0x1474>
    308c:	2b8020ef          	jal	5344 <printf>
    exit(1);
    3090:	4505                	li	a0,1
    3092:	667010ef          	jal	4ef8 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3096:	85ca                	mv	a1,s2
    3098:	00004517          	auipc	a0,0x4
    309c:	80850513          	addi	a0,a0,-2040 # 68a0 <malloc+0x14a4>
    30a0:	2a4020ef          	jal	5344 <printf>
    exit(1);
    30a4:	4505                	li	a0,1
    30a6:	653010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30aa:	85ca                	mv	a1,s2
    30ac:	00004517          	auipc	a0,0x4
    30b0:	81c50513          	addi	a0,a0,-2020 # 68c8 <malloc+0x14cc>
    30b4:	290020ef          	jal	5344 <printf>
    exit(1);
    30b8:	4505                	li	a0,1
    30ba:	63f010ef          	jal	4ef8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    30be:	85ca                	mv	a1,s2
    30c0:	00004517          	auipc	a0,0x4
    30c4:	82850513          	addi	a0,a0,-2008 # 68e8 <malloc+0x14ec>
    30c8:	27c020ef          	jal	5344 <printf>
    exit(1);
    30cc:	4505                	li	a0,1
    30ce:	62b010ef          	jal	4ef8 <exit>
    printf("%s: chdir dd failed\n", s);
    30d2:	85ca                	mv	a1,s2
    30d4:	00004517          	auipc	a0,0x4
    30d8:	83c50513          	addi	a0,a0,-1988 # 6910 <malloc+0x1514>
    30dc:	268020ef          	jal	5344 <printf>
    exit(1);
    30e0:	4505                	li	a0,1
    30e2:	617010ef          	jal	4ef8 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    30e6:	85ca                	mv	a1,s2
    30e8:	00004517          	auipc	a0,0x4
    30ec:	85050513          	addi	a0,a0,-1968 # 6938 <malloc+0x153c>
    30f0:	254020ef          	jal	5344 <printf>
    exit(1);
    30f4:	4505                	li	a0,1
    30f6:	603010ef          	jal	4ef8 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    30fa:	85ca                	mv	a1,s2
    30fc:	00004517          	auipc	a0,0x4
    3100:	86c50513          	addi	a0,a0,-1940 # 6968 <malloc+0x156c>
    3104:	240020ef          	jal	5344 <printf>
    exit(1);
    3108:	4505                	li	a0,1
    310a:	5ef010ef          	jal	4ef8 <exit>
    printf("%s: chdir ./.. failed\n", s);
    310e:	85ca                	mv	a1,s2
    3110:	00004517          	auipc	a0,0x4
    3114:	88850513          	addi	a0,a0,-1912 # 6998 <malloc+0x159c>
    3118:	22c020ef          	jal	5344 <printf>
    exit(1);
    311c:	4505                	li	a0,1
    311e:	5db010ef          	jal	4ef8 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3122:	85ca                	mv	a1,s2
    3124:	00004517          	auipc	a0,0x4
    3128:	88c50513          	addi	a0,a0,-1908 # 69b0 <malloc+0x15b4>
    312c:	218020ef          	jal	5344 <printf>
    exit(1);
    3130:	4505                	li	a0,1
    3132:	5c7010ef          	jal	4ef8 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3136:	85ca                	mv	a1,s2
    3138:	00004517          	auipc	a0,0x4
    313c:	89850513          	addi	a0,a0,-1896 # 69d0 <malloc+0x15d4>
    3140:	204020ef          	jal	5344 <printf>
    exit(1);
    3144:	4505                	li	a0,1
    3146:	5b3010ef          	jal	4ef8 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    314a:	85ca                	mv	a1,s2
    314c:	00004517          	auipc	a0,0x4
    3150:	8a450513          	addi	a0,a0,-1884 # 69f0 <malloc+0x15f4>
    3154:	1f0020ef          	jal	5344 <printf>
    exit(1);
    3158:	4505                	li	a0,1
    315a:	59f010ef          	jal	4ef8 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    315e:	85ca                	mv	a1,s2
    3160:	00004517          	auipc	a0,0x4
    3164:	8d050513          	addi	a0,a0,-1840 # 6a30 <malloc+0x1634>
    3168:	1dc020ef          	jal	5344 <printf>
    exit(1);
    316c:	4505                	li	a0,1
    316e:	58b010ef          	jal	4ef8 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3172:	85ca                	mv	a1,s2
    3174:	00004517          	auipc	a0,0x4
    3178:	8ec50513          	addi	a0,a0,-1812 # 6a60 <malloc+0x1664>
    317c:	1c8020ef          	jal	5344 <printf>
    exit(1);
    3180:	4505                	li	a0,1
    3182:	577010ef          	jal	4ef8 <exit>
    printf("%s: create dd succeeded!\n", s);
    3186:	85ca                	mv	a1,s2
    3188:	00004517          	auipc	a0,0x4
    318c:	8f850513          	addi	a0,a0,-1800 # 6a80 <malloc+0x1684>
    3190:	1b4020ef          	jal	5344 <printf>
    exit(1);
    3194:	4505                	li	a0,1
    3196:	563010ef          	jal	4ef8 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    319a:	85ca                	mv	a1,s2
    319c:	00004517          	auipc	a0,0x4
    31a0:	90450513          	addi	a0,a0,-1788 # 6aa0 <malloc+0x16a4>
    31a4:	1a0020ef          	jal	5344 <printf>
    exit(1);
    31a8:	4505                	li	a0,1
    31aa:	54f010ef          	jal	4ef8 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    31ae:	85ca                	mv	a1,s2
    31b0:	00004517          	auipc	a0,0x4
    31b4:	91050513          	addi	a0,a0,-1776 # 6ac0 <malloc+0x16c4>
    31b8:	18c020ef          	jal	5344 <printf>
    exit(1);
    31bc:	4505                	li	a0,1
    31be:	53b010ef          	jal	4ef8 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    31c2:	85ca                	mv	a1,s2
    31c4:	00004517          	auipc	a0,0x4
    31c8:	92c50513          	addi	a0,a0,-1748 # 6af0 <malloc+0x16f4>
    31cc:	178020ef          	jal	5344 <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	527010ef          	jal	4ef8 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    31d6:	85ca                	mv	a1,s2
    31d8:	00004517          	auipc	a0,0x4
    31dc:	94050513          	addi	a0,a0,-1728 # 6b18 <malloc+0x171c>
    31e0:	164020ef          	jal	5344 <printf>
    exit(1);
    31e4:	4505                	li	a0,1
    31e6:	513010ef          	jal	4ef8 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    31ea:	85ca                	mv	a1,s2
    31ec:	00004517          	auipc	a0,0x4
    31f0:	95450513          	addi	a0,a0,-1708 # 6b40 <malloc+0x1744>
    31f4:	150020ef          	jal	5344 <printf>
    exit(1);
    31f8:	4505                	li	a0,1
    31fa:	4ff010ef          	jal	4ef8 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    31fe:	85ca                	mv	a1,s2
    3200:	00004517          	auipc	a0,0x4
    3204:	96850513          	addi	a0,a0,-1688 # 6b68 <malloc+0x176c>
    3208:	13c020ef          	jal	5344 <printf>
    exit(1);
    320c:	4505                	li	a0,1
    320e:	4eb010ef          	jal	4ef8 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3212:	85ca                	mv	a1,s2
    3214:	00004517          	auipc	a0,0x4
    3218:	97450513          	addi	a0,a0,-1676 # 6b88 <malloc+0x178c>
    321c:	128020ef          	jal	5344 <printf>
    exit(1);
    3220:	4505                	li	a0,1
    3222:	4d7010ef          	jal	4ef8 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3226:	85ca                	mv	a1,s2
    3228:	00004517          	auipc	a0,0x4
    322c:	98050513          	addi	a0,a0,-1664 # 6ba8 <malloc+0x17ac>
    3230:	114020ef          	jal	5344 <printf>
    exit(1);
    3234:	4505                	li	a0,1
    3236:	4c3010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    323a:	85ca                	mv	a1,s2
    323c:	00004517          	auipc	a0,0x4
    3240:	99450513          	addi	a0,a0,-1644 # 6bd0 <malloc+0x17d4>
    3244:	100020ef          	jal	5344 <printf>
    exit(1);
    3248:	4505                	li	a0,1
    324a:	4af010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    324e:	85ca                	mv	a1,s2
    3250:	00004517          	auipc	a0,0x4
    3254:	9a050513          	addi	a0,a0,-1632 # 6bf0 <malloc+0x17f4>
    3258:	0ec020ef          	jal	5344 <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	49b010ef          	jal	4ef8 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3262:	85ca                	mv	a1,s2
    3264:	00004517          	auipc	a0,0x4
    3268:	9ac50513          	addi	a0,a0,-1620 # 6c10 <malloc+0x1814>
    326c:	0d8020ef          	jal	5344 <printf>
    exit(1);
    3270:	4505                	li	a0,1
    3272:	487010ef          	jal	4ef8 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3276:	85ca                	mv	a1,s2
    3278:	00004517          	auipc	a0,0x4
    327c:	9c050513          	addi	a0,a0,-1600 # 6c38 <malloc+0x183c>
    3280:	0c4020ef          	jal	5344 <printf>
    exit(1);
    3284:	4505                	li	a0,1
    3286:	473010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    328a:	85ca                	mv	a1,s2
    328c:	00003517          	auipc	a0,0x3
    3290:	63c50513          	addi	a0,a0,1596 # 68c8 <malloc+0x14cc>
    3294:	0b0020ef          	jal	5344 <printf>
    exit(1);
    3298:	4505                	li	a0,1
    329a:	45f010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    329e:	85ca                	mv	a1,s2
    32a0:	00004517          	auipc	a0,0x4
    32a4:	9b850513          	addi	a0,a0,-1608 # 6c58 <malloc+0x185c>
    32a8:	09c020ef          	jal	5344 <printf>
    exit(1);
    32ac:	4505                	li	a0,1
    32ae:	44b010ef          	jal	4ef8 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    32b2:	85ca                	mv	a1,s2
    32b4:	00004517          	auipc	a0,0x4
    32b8:	9c450513          	addi	a0,a0,-1596 # 6c78 <malloc+0x187c>
    32bc:	088020ef          	jal	5344 <printf>
    exit(1);
    32c0:	4505                	li	a0,1
    32c2:	437010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    32c6:	85ca                	mv	a1,s2
    32c8:	00004517          	auipc	a0,0x4
    32cc:	9e050513          	addi	a0,a0,-1568 # 6ca8 <malloc+0x18ac>
    32d0:	074020ef          	jal	5344 <printf>
    exit(1);
    32d4:	4505                	li	a0,1
    32d6:	423010ef          	jal	4ef8 <exit>
    printf("%s: unlink dd failed\n", s);
    32da:	85ca                	mv	a1,s2
    32dc:	00004517          	auipc	a0,0x4
    32e0:	9ec50513          	addi	a0,a0,-1556 # 6cc8 <malloc+0x18cc>
    32e4:	060020ef          	jal	5344 <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	40f010ef          	jal	4ef8 <exit>

00000000000032ee <rmdot>:
{
    32ee:	1101                	addi	sp,sp,-32
    32f0:	ec06                	sd	ra,24(sp)
    32f2:	e822                	sd	s0,16(sp)
    32f4:	e426                	sd	s1,8(sp)
    32f6:	1000                	addi	s0,sp,32
    32f8:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    32fa:	00004517          	auipc	a0,0x4
    32fe:	9e650513          	addi	a0,a0,-1562 # 6ce0 <malloc+0x18e4>
    3302:	45f010ef          	jal	4f60 <mkdir>
    3306:	e53d                	bnez	a0,3374 <rmdot+0x86>
  if(chdir("dots") != 0){
    3308:	00004517          	auipc	a0,0x4
    330c:	9d850513          	addi	a0,a0,-1576 # 6ce0 <malloc+0x18e4>
    3310:	459010ef          	jal	4f68 <chdir>
    3314:	e935                	bnez	a0,3388 <rmdot+0x9a>
  if(unlink(".") == 0){
    3316:	00003517          	auipc	a0,0x3
    331a:	8fa50513          	addi	a0,a0,-1798 # 5c10 <malloc+0x814>
    331e:	42b010ef          	jal	4f48 <unlink>
    3322:	cd2d                	beqz	a0,339c <rmdot+0xae>
  if(unlink("..") == 0){
    3324:	00003517          	auipc	a0,0x3
    3328:	40c50513          	addi	a0,a0,1036 # 6730 <malloc+0x1334>
    332c:	41d010ef          	jal	4f48 <unlink>
    3330:	c141                	beqz	a0,33b0 <rmdot+0xc2>
  if(chdir("/") != 0){
    3332:	00003517          	auipc	a0,0x3
    3336:	3a650513          	addi	a0,a0,934 # 66d8 <malloc+0x12dc>
    333a:	42f010ef          	jal	4f68 <chdir>
    333e:	e159                	bnez	a0,33c4 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3340:	00004517          	auipc	a0,0x4
    3344:	a0850513          	addi	a0,a0,-1528 # 6d48 <malloc+0x194c>
    3348:	401010ef          	jal	4f48 <unlink>
    334c:	c551                	beqz	a0,33d8 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    334e:	00004517          	auipc	a0,0x4
    3352:	a2250513          	addi	a0,a0,-1502 # 6d70 <malloc+0x1974>
    3356:	3f3010ef          	jal	4f48 <unlink>
    335a:	c949                	beqz	a0,33ec <rmdot+0xfe>
  if(unlink("dots") != 0){
    335c:	00004517          	auipc	a0,0x4
    3360:	98450513          	addi	a0,a0,-1660 # 6ce0 <malloc+0x18e4>
    3364:	3e5010ef          	jal	4f48 <unlink>
    3368:	ed41                	bnez	a0,3400 <rmdot+0x112>
}
    336a:	60e2                	ld	ra,24(sp)
    336c:	6442                	ld	s0,16(sp)
    336e:	64a2                	ld	s1,8(sp)
    3370:	6105                	addi	sp,sp,32
    3372:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3374:	85a6                	mv	a1,s1
    3376:	00004517          	auipc	a0,0x4
    337a:	97250513          	addi	a0,a0,-1678 # 6ce8 <malloc+0x18ec>
    337e:	7c7010ef          	jal	5344 <printf>
    exit(1);
    3382:	4505                	li	a0,1
    3384:	375010ef          	jal	4ef8 <exit>
    printf("%s: chdir dots failed\n", s);
    3388:	85a6                	mv	a1,s1
    338a:	00004517          	auipc	a0,0x4
    338e:	97650513          	addi	a0,a0,-1674 # 6d00 <malloc+0x1904>
    3392:	7b3010ef          	jal	5344 <printf>
    exit(1);
    3396:	4505                	li	a0,1
    3398:	361010ef          	jal	4ef8 <exit>
    printf("%s: rm . worked!\n", s);
    339c:	85a6                	mv	a1,s1
    339e:	00004517          	auipc	a0,0x4
    33a2:	97a50513          	addi	a0,a0,-1670 # 6d18 <malloc+0x191c>
    33a6:	79f010ef          	jal	5344 <printf>
    exit(1);
    33aa:	4505                	li	a0,1
    33ac:	34d010ef          	jal	4ef8 <exit>
    printf("%s: rm .. worked!\n", s);
    33b0:	85a6                	mv	a1,s1
    33b2:	00004517          	auipc	a0,0x4
    33b6:	97e50513          	addi	a0,a0,-1666 # 6d30 <malloc+0x1934>
    33ba:	78b010ef          	jal	5344 <printf>
    exit(1);
    33be:	4505                	li	a0,1
    33c0:	339010ef          	jal	4ef8 <exit>
    printf("%s: chdir / failed\n", s);
    33c4:	85a6                	mv	a1,s1
    33c6:	00003517          	auipc	a0,0x3
    33ca:	31a50513          	addi	a0,a0,794 # 66e0 <malloc+0x12e4>
    33ce:	777010ef          	jal	5344 <printf>
    exit(1);
    33d2:	4505                	li	a0,1
    33d4:	325010ef          	jal	4ef8 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    33d8:	85a6                	mv	a1,s1
    33da:	00004517          	auipc	a0,0x4
    33de:	97650513          	addi	a0,a0,-1674 # 6d50 <malloc+0x1954>
    33e2:	763010ef          	jal	5344 <printf>
    exit(1);
    33e6:	4505                	li	a0,1
    33e8:	311010ef          	jal	4ef8 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    33ec:	85a6                	mv	a1,s1
    33ee:	00004517          	auipc	a0,0x4
    33f2:	98a50513          	addi	a0,a0,-1654 # 6d78 <malloc+0x197c>
    33f6:	74f010ef          	jal	5344 <printf>
    exit(1);
    33fa:	4505                	li	a0,1
    33fc:	2fd010ef          	jal	4ef8 <exit>
    printf("%s: unlink dots failed!\n", s);
    3400:	85a6                	mv	a1,s1
    3402:	00004517          	auipc	a0,0x4
    3406:	99650513          	addi	a0,a0,-1642 # 6d98 <malloc+0x199c>
    340a:	73b010ef          	jal	5344 <printf>
    exit(1);
    340e:	4505                	li	a0,1
    3410:	2e9010ef          	jal	4ef8 <exit>

0000000000003414 <dirfile>:
{
    3414:	1101                	addi	sp,sp,-32
    3416:	ec06                	sd	ra,24(sp)
    3418:	e822                	sd	s0,16(sp)
    341a:	e426                	sd	s1,8(sp)
    341c:	e04a                	sd	s2,0(sp)
    341e:	1000                	addi	s0,sp,32
    3420:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3422:	20000593          	li	a1,512
    3426:	00004517          	auipc	a0,0x4
    342a:	99250513          	addi	a0,a0,-1646 # 6db8 <malloc+0x19bc>
    342e:	30b010ef          	jal	4f38 <open>
  if(fd < 0){
    3432:	0c054563          	bltz	a0,34fc <dirfile+0xe8>
  close(fd);
    3436:	2eb010ef          	jal	4f20 <close>
  if(chdir("dirfile") == 0){
    343a:	00004517          	auipc	a0,0x4
    343e:	97e50513          	addi	a0,a0,-1666 # 6db8 <malloc+0x19bc>
    3442:	327010ef          	jal	4f68 <chdir>
    3446:	c569                	beqz	a0,3510 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3448:	4581                	li	a1,0
    344a:	00004517          	auipc	a0,0x4
    344e:	9b650513          	addi	a0,a0,-1610 # 6e00 <malloc+0x1a04>
    3452:	2e7010ef          	jal	4f38 <open>
  if(fd >= 0){
    3456:	0c055763          	bgez	a0,3524 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    345a:	20000593          	li	a1,512
    345e:	00004517          	auipc	a0,0x4
    3462:	9a250513          	addi	a0,a0,-1630 # 6e00 <malloc+0x1a04>
    3466:	2d3010ef          	jal	4f38 <open>
  if(fd >= 0){
    346a:	0c055763          	bgez	a0,3538 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    346e:	00004517          	auipc	a0,0x4
    3472:	99250513          	addi	a0,a0,-1646 # 6e00 <malloc+0x1a04>
    3476:	2eb010ef          	jal	4f60 <mkdir>
    347a:	0c050963          	beqz	a0,354c <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    347e:	00004517          	auipc	a0,0x4
    3482:	98250513          	addi	a0,a0,-1662 # 6e00 <malloc+0x1a04>
    3486:	2c3010ef          	jal	4f48 <unlink>
    348a:	0c050b63          	beqz	a0,3560 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    348e:	00004597          	auipc	a1,0x4
    3492:	97258593          	addi	a1,a1,-1678 # 6e00 <malloc+0x1a04>
    3496:	00002517          	auipc	a0,0x2
    349a:	26a50513          	addi	a0,a0,618 # 5700 <malloc+0x304>
    349e:	2bb010ef          	jal	4f58 <link>
    34a2:	0c050963          	beqz	a0,3574 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    34a6:	00004517          	auipc	a0,0x4
    34aa:	91250513          	addi	a0,a0,-1774 # 6db8 <malloc+0x19bc>
    34ae:	29b010ef          	jal	4f48 <unlink>
    34b2:	0c051b63          	bnez	a0,3588 <dirfile+0x174>
  fd = open(".", O_RDWR);
    34b6:	4589                	li	a1,2
    34b8:	00002517          	auipc	a0,0x2
    34bc:	75850513          	addi	a0,a0,1880 # 5c10 <malloc+0x814>
    34c0:	279010ef          	jal	4f38 <open>
  if(fd >= 0){
    34c4:	0c055c63          	bgez	a0,359c <dirfile+0x188>
  fd = open(".", 0);
    34c8:	4581                	li	a1,0
    34ca:	00002517          	auipc	a0,0x2
    34ce:	74650513          	addi	a0,a0,1862 # 5c10 <malloc+0x814>
    34d2:	267010ef          	jal	4f38 <open>
    34d6:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    34d8:	4605                	li	a2,1
    34da:	00002597          	auipc	a1,0x2
    34de:	0be58593          	addi	a1,a1,190 # 5598 <malloc+0x19c>
    34e2:	237010ef          	jal	4f18 <write>
    34e6:	0ca04563          	bgtz	a0,35b0 <dirfile+0x19c>
  close(fd);
    34ea:	8526                	mv	a0,s1
    34ec:	235010ef          	jal	4f20 <close>
}
    34f0:	60e2                	ld	ra,24(sp)
    34f2:	6442                	ld	s0,16(sp)
    34f4:	64a2                	ld	s1,8(sp)
    34f6:	6902                	ld	s2,0(sp)
    34f8:	6105                	addi	sp,sp,32
    34fa:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    34fc:	85ca                	mv	a1,s2
    34fe:	00004517          	auipc	a0,0x4
    3502:	8c250513          	addi	a0,a0,-1854 # 6dc0 <malloc+0x19c4>
    3506:	63f010ef          	jal	5344 <printf>
    exit(1);
    350a:	4505                	li	a0,1
    350c:	1ed010ef          	jal	4ef8 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3510:	85ca                	mv	a1,s2
    3512:	00004517          	auipc	a0,0x4
    3516:	8ce50513          	addi	a0,a0,-1842 # 6de0 <malloc+0x19e4>
    351a:	62b010ef          	jal	5344 <printf>
    exit(1);
    351e:	4505                	li	a0,1
    3520:	1d9010ef          	jal	4ef8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3524:	85ca                	mv	a1,s2
    3526:	00004517          	auipc	a0,0x4
    352a:	8ea50513          	addi	a0,a0,-1814 # 6e10 <malloc+0x1a14>
    352e:	617010ef          	jal	5344 <printf>
    exit(1);
    3532:	4505                	li	a0,1
    3534:	1c5010ef          	jal	4ef8 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3538:	85ca                	mv	a1,s2
    353a:	00004517          	auipc	a0,0x4
    353e:	8d650513          	addi	a0,a0,-1834 # 6e10 <malloc+0x1a14>
    3542:	603010ef          	jal	5344 <printf>
    exit(1);
    3546:	4505                	li	a0,1
    3548:	1b1010ef          	jal	4ef8 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    354c:	85ca                	mv	a1,s2
    354e:	00004517          	auipc	a0,0x4
    3552:	8ea50513          	addi	a0,a0,-1814 # 6e38 <malloc+0x1a3c>
    3556:	5ef010ef          	jal	5344 <printf>
    exit(1);
    355a:	4505                	li	a0,1
    355c:	19d010ef          	jal	4ef8 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3560:	85ca                	mv	a1,s2
    3562:	00004517          	auipc	a0,0x4
    3566:	8fe50513          	addi	a0,a0,-1794 # 6e60 <malloc+0x1a64>
    356a:	5db010ef          	jal	5344 <printf>
    exit(1);
    356e:	4505                	li	a0,1
    3570:	189010ef          	jal	4ef8 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3574:	85ca                	mv	a1,s2
    3576:	00004517          	auipc	a0,0x4
    357a:	91250513          	addi	a0,a0,-1774 # 6e88 <malloc+0x1a8c>
    357e:	5c7010ef          	jal	5344 <printf>
    exit(1);
    3582:	4505                	li	a0,1
    3584:	175010ef          	jal	4ef8 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3588:	85ca                	mv	a1,s2
    358a:	00004517          	auipc	a0,0x4
    358e:	92650513          	addi	a0,a0,-1754 # 6eb0 <malloc+0x1ab4>
    3592:	5b3010ef          	jal	5344 <printf>
    exit(1);
    3596:	4505                	li	a0,1
    3598:	161010ef          	jal	4ef8 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    359c:	85ca                	mv	a1,s2
    359e:	00004517          	auipc	a0,0x4
    35a2:	93250513          	addi	a0,a0,-1742 # 6ed0 <malloc+0x1ad4>
    35a6:	59f010ef          	jal	5344 <printf>
    exit(1);
    35aa:	4505                	li	a0,1
    35ac:	14d010ef          	jal	4ef8 <exit>
    printf("%s: write . succeeded!\n", s);
    35b0:	85ca                	mv	a1,s2
    35b2:	00004517          	auipc	a0,0x4
    35b6:	94650513          	addi	a0,a0,-1722 # 6ef8 <malloc+0x1afc>
    35ba:	58b010ef          	jal	5344 <printf>
    exit(1);
    35be:	4505                	li	a0,1
    35c0:	139010ef          	jal	4ef8 <exit>

00000000000035c4 <iref>:
{
    35c4:	715d                	addi	sp,sp,-80
    35c6:	e486                	sd	ra,72(sp)
    35c8:	e0a2                	sd	s0,64(sp)
    35ca:	fc26                	sd	s1,56(sp)
    35cc:	f84a                	sd	s2,48(sp)
    35ce:	f44e                	sd	s3,40(sp)
    35d0:	f052                	sd	s4,32(sp)
    35d2:	ec56                	sd	s5,24(sp)
    35d4:	e85a                	sd	s6,16(sp)
    35d6:	e45e                	sd	s7,8(sp)
    35d8:	0880                	addi	s0,sp,80
    35da:	8baa                	mv	s7,a0
    35dc:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    35e0:	00004a97          	auipc	s5,0x4
    35e4:	930a8a93          	addi	s5,s5,-1744 # 6f10 <malloc+0x1b14>
    mkdir("");
    35e8:	00003497          	auipc	s1,0x3
    35ec:	43048493          	addi	s1,s1,1072 # 6a18 <malloc+0x161c>
    link("README", "");
    35f0:	00002b17          	auipc	s6,0x2
    35f4:	110b0b13          	addi	s6,s6,272 # 5700 <malloc+0x304>
    fd = open("", O_CREATE);
    35f8:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    35fc:	00004997          	auipc	s3,0x4
    3600:	80c98993          	addi	s3,s3,-2036 # 6e08 <malloc+0x1a0c>
    3604:	a835                	j	3640 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3606:	85de                	mv	a1,s7
    3608:	00004517          	auipc	a0,0x4
    360c:	91050513          	addi	a0,a0,-1776 # 6f18 <malloc+0x1b1c>
    3610:	535010ef          	jal	5344 <printf>
      exit(1);
    3614:	4505                	li	a0,1
    3616:	0e3010ef          	jal	4ef8 <exit>
      printf("%s: chdir irefd failed\n", s);
    361a:	85de                	mv	a1,s7
    361c:	00004517          	auipc	a0,0x4
    3620:	91450513          	addi	a0,a0,-1772 # 6f30 <malloc+0x1b34>
    3624:	521010ef          	jal	5344 <printf>
      exit(1);
    3628:	4505                	li	a0,1
    362a:	0cf010ef          	jal	4ef8 <exit>
      close(fd);
    362e:	0f3010ef          	jal	4f20 <close>
    3632:	a825                	j	366a <iref+0xa6>
    unlink("xx");
    3634:	854e                	mv	a0,s3
    3636:	113010ef          	jal	4f48 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    363a:	397d                	addiw	s2,s2,-1
    363c:	04090063          	beqz	s2,367c <iref+0xb8>
    if(mkdir("irefd") != 0){
    3640:	8556                	mv	a0,s5
    3642:	11f010ef          	jal	4f60 <mkdir>
    3646:	f161                	bnez	a0,3606 <iref+0x42>
    if(chdir("irefd") != 0){
    3648:	8556                	mv	a0,s5
    364a:	11f010ef          	jal	4f68 <chdir>
    364e:	f571                	bnez	a0,361a <iref+0x56>
    mkdir("");
    3650:	8526                	mv	a0,s1
    3652:	10f010ef          	jal	4f60 <mkdir>
    link("README", "");
    3656:	85a6                	mv	a1,s1
    3658:	855a                	mv	a0,s6
    365a:	0ff010ef          	jal	4f58 <link>
    fd = open("", O_CREATE);
    365e:	85d2                	mv	a1,s4
    3660:	8526                	mv	a0,s1
    3662:	0d7010ef          	jal	4f38 <open>
    if(fd >= 0)
    3666:	fc0554e3          	bgez	a0,362e <iref+0x6a>
    fd = open("xx", O_CREATE);
    366a:	85d2                	mv	a1,s4
    366c:	854e                	mv	a0,s3
    366e:	0cb010ef          	jal	4f38 <open>
    if(fd >= 0)
    3672:	fc0541e3          	bltz	a0,3634 <iref+0x70>
      close(fd);
    3676:	0ab010ef          	jal	4f20 <close>
    367a:	bf6d                	j	3634 <iref+0x70>
    367c:	03300493          	li	s1,51
    chdir("..");
    3680:	00003997          	auipc	s3,0x3
    3684:	0b098993          	addi	s3,s3,176 # 6730 <malloc+0x1334>
    unlink("irefd");
    3688:	00004917          	auipc	s2,0x4
    368c:	88890913          	addi	s2,s2,-1912 # 6f10 <malloc+0x1b14>
    chdir("..");
    3690:	854e                	mv	a0,s3
    3692:	0d7010ef          	jal	4f68 <chdir>
    unlink("irefd");
    3696:	854a                	mv	a0,s2
    3698:	0b1010ef          	jal	4f48 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    369c:	34fd                	addiw	s1,s1,-1
    369e:	f8ed                	bnez	s1,3690 <iref+0xcc>
  chdir("/");
    36a0:	00003517          	auipc	a0,0x3
    36a4:	03850513          	addi	a0,a0,56 # 66d8 <malloc+0x12dc>
    36a8:	0c1010ef          	jal	4f68 <chdir>
}
    36ac:	60a6                	ld	ra,72(sp)
    36ae:	6406                	ld	s0,64(sp)
    36b0:	74e2                	ld	s1,56(sp)
    36b2:	7942                	ld	s2,48(sp)
    36b4:	79a2                	ld	s3,40(sp)
    36b6:	7a02                	ld	s4,32(sp)
    36b8:	6ae2                	ld	s5,24(sp)
    36ba:	6b42                	ld	s6,16(sp)
    36bc:	6ba2                	ld	s7,8(sp)
    36be:	6161                	addi	sp,sp,80
    36c0:	8082                	ret

00000000000036c2 <openiputtest>:
{
    36c2:	7179                	addi	sp,sp,-48
    36c4:	f406                	sd	ra,40(sp)
    36c6:	f022                	sd	s0,32(sp)
    36c8:	ec26                	sd	s1,24(sp)
    36ca:	1800                	addi	s0,sp,48
    36cc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    36ce:	00004517          	auipc	a0,0x4
    36d2:	87a50513          	addi	a0,a0,-1926 # 6f48 <malloc+0x1b4c>
    36d6:	08b010ef          	jal	4f60 <mkdir>
    36da:	02054a63          	bltz	a0,370e <openiputtest+0x4c>
  pid = fork();
    36de:	013010ef          	jal	4ef0 <fork>
  if(pid < 0){
    36e2:	04054063          	bltz	a0,3722 <openiputtest+0x60>
  if(pid == 0){
    36e6:	e939                	bnez	a0,373c <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    36e8:	4589                	li	a1,2
    36ea:	00004517          	auipc	a0,0x4
    36ee:	85e50513          	addi	a0,a0,-1954 # 6f48 <malloc+0x1b4c>
    36f2:	047010ef          	jal	4f38 <open>
    if(fd >= 0){
    36f6:	04054063          	bltz	a0,3736 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    36fa:	85a6                	mv	a1,s1
    36fc:	00004517          	auipc	a0,0x4
    3700:	86c50513          	addi	a0,a0,-1940 # 6f68 <malloc+0x1b6c>
    3704:	441010ef          	jal	5344 <printf>
      exit(1);
    3708:	4505                	li	a0,1
    370a:	7ee010ef          	jal	4ef8 <exit>
    printf("%s: mkdir oidir failed\n", s);
    370e:	85a6                	mv	a1,s1
    3710:	00004517          	auipc	a0,0x4
    3714:	84050513          	addi	a0,a0,-1984 # 6f50 <malloc+0x1b54>
    3718:	42d010ef          	jal	5344 <printf>
    exit(1);
    371c:	4505                	li	a0,1
    371e:	7da010ef          	jal	4ef8 <exit>
    printf("%s: fork failed\n", s);
    3722:	85a6                	mv	a1,s1
    3724:	00002517          	auipc	a0,0x2
    3728:	69450513          	addi	a0,a0,1684 # 5db8 <malloc+0x9bc>
    372c:	419010ef          	jal	5344 <printf>
    exit(1);
    3730:	4505                	li	a0,1
    3732:	7c6010ef          	jal	4ef8 <exit>
    exit(0);
    3736:	4501                	li	a0,0
    3738:	7c0010ef          	jal	4ef8 <exit>
  pause(1);
    373c:	4505                	li	a0,1
    373e:	04b010ef          	jal	4f88 <pause>
  if(unlink("oidir") != 0){
    3742:	00004517          	auipc	a0,0x4
    3746:	80650513          	addi	a0,a0,-2042 # 6f48 <malloc+0x1b4c>
    374a:	7fe010ef          	jal	4f48 <unlink>
    374e:	c919                	beqz	a0,3764 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3750:	85a6                	mv	a1,s1
    3752:	00003517          	auipc	a0,0x3
    3756:	85650513          	addi	a0,a0,-1962 # 5fa8 <malloc+0xbac>
    375a:	3eb010ef          	jal	5344 <printf>
    exit(1);
    375e:	4505                	li	a0,1
    3760:	798010ef          	jal	4ef8 <exit>
  wait(&xstatus);
    3764:	fdc40513          	addi	a0,s0,-36
    3768:	798010ef          	jal	4f00 <wait>
  exit(xstatus);
    376c:	fdc42503          	lw	a0,-36(s0)
    3770:	788010ef          	jal	4ef8 <exit>

0000000000003774 <forkforkfork>:
{
    3774:	1101                	addi	sp,sp,-32
    3776:	ec06                	sd	ra,24(sp)
    3778:	e822                	sd	s0,16(sp)
    377a:	e426                	sd	s1,8(sp)
    377c:	1000                	addi	s0,sp,32
    377e:	84aa                	mv	s1,a0
  unlink("stopforking");
    3780:	00004517          	auipc	a0,0x4
    3784:	81050513          	addi	a0,a0,-2032 # 6f90 <malloc+0x1b94>
    3788:	7c0010ef          	jal	4f48 <unlink>
  int pid = fork();
    378c:	764010ef          	jal	4ef0 <fork>
  if(pid < 0){
    3790:	02054b63          	bltz	a0,37c6 <forkforkfork+0x52>
  if(pid == 0){
    3794:	c139                	beqz	a0,37da <forkforkfork+0x66>
  pause(20); // two seconds
    3796:	4551                	li	a0,20
    3798:	7f0010ef          	jal	4f88 <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    379c:	20200593          	li	a1,514
    37a0:	00003517          	auipc	a0,0x3
    37a4:	7f050513          	addi	a0,a0,2032 # 6f90 <malloc+0x1b94>
    37a8:	790010ef          	jal	4f38 <open>
    37ac:	774010ef          	jal	4f20 <close>
  wait(0);
    37b0:	4501                	li	a0,0
    37b2:	74e010ef          	jal	4f00 <wait>
  pause(10); // one second
    37b6:	4529                	li	a0,10
    37b8:	7d0010ef          	jal	4f88 <pause>
}
    37bc:	60e2                	ld	ra,24(sp)
    37be:	6442                	ld	s0,16(sp)
    37c0:	64a2                	ld	s1,8(sp)
    37c2:	6105                	addi	sp,sp,32
    37c4:	8082                	ret
    printf("%s: fork failed", s);
    37c6:	85a6                	mv	a1,s1
    37c8:	00002517          	auipc	a0,0x2
    37cc:	7b050513          	addi	a0,a0,1968 # 5f78 <malloc+0xb7c>
    37d0:	375010ef          	jal	5344 <printf>
    exit(1);
    37d4:	4505                	li	a0,1
    37d6:	722010ef          	jal	4ef8 <exit>
      int fd = open("stopforking", 0);
    37da:	4581                	li	a1,0
    37dc:	00003517          	auipc	a0,0x3
    37e0:	7b450513          	addi	a0,a0,1972 # 6f90 <malloc+0x1b94>
    37e4:	754010ef          	jal	4f38 <open>
      if(fd >= 0){
    37e8:	02055163          	bgez	a0,380a <forkforkfork+0x96>
      if(fork() < 0){
    37ec:	704010ef          	jal	4ef0 <fork>
    37f0:	fe0555e3          	bgez	a0,37da <forkforkfork+0x66>
        close(open("stopforking", O_CREATE|O_RDWR));
    37f4:	20200593          	li	a1,514
    37f8:	00003517          	auipc	a0,0x3
    37fc:	79850513          	addi	a0,a0,1944 # 6f90 <malloc+0x1b94>
    3800:	738010ef          	jal	4f38 <open>
    3804:	71c010ef          	jal	4f20 <close>
    3808:	bfc9                	j	37da <forkforkfork+0x66>
        exit(0);
    380a:	4501                	li	a0,0
    380c:	6ec010ef          	jal	4ef8 <exit>

0000000000003810 <killstatus>:
{
    3810:	715d                	addi	sp,sp,-80
    3812:	e486                	sd	ra,72(sp)
    3814:	e0a2                	sd	s0,64(sp)
    3816:	fc26                	sd	s1,56(sp)
    3818:	f84a                	sd	s2,48(sp)
    381a:	f44e                	sd	s3,40(sp)
    381c:	f052                	sd	s4,32(sp)
    381e:	ec56                	sd	s5,24(sp)
    3820:	e85a                	sd	s6,16(sp)
    3822:	0880                	addi	s0,sp,80
    3824:	8b2a                	mv	s6,a0
    3826:	06400913          	li	s2,100
    pause(1);
    382a:	4a85                	li	s5,1
    wait(&xst);
    382c:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    3830:	59fd                	li	s3,-1
    int pid1 = fork();
    3832:	6be010ef          	jal	4ef0 <fork>
    3836:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3838:	02054663          	bltz	a0,3864 <killstatus+0x54>
    if(pid1 == 0){
    383c:	cd15                	beqz	a0,3878 <killstatus+0x68>
    pause(1);
    383e:	8556                	mv	a0,s5
    3840:	748010ef          	jal	4f88 <pause>
    kill(pid1);
    3844:	8526                	mv	a0,s1
    3846:	6e2010ef          	jal	4f28 <kill>
    wait(&xst);
    384a:	8552                	mv	a0,s4
    384c:	6b4010ef          	jal	4f00 <wait>
    if(xst != -1) {
    3850:	fbc42783          	lw	a5,-68(s0)
    3854:	03379563          	bne	a5,s3,387e <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    3858:	397d                	addiw	s2,s2,-1
    385a:	fc091ce3          	bnez	s2,3832 <killstatus+0x22>
  exit(0);
    385e:	4501                	li	a0,0
    3860:	698010ef          	jal	4ef8 <exit>
      printf("%s: fork failed\n", s);
    3864:	85da                	mv	a1,s6
    3866:	00002517          	auipc	a0,0x2
    386a:	55250513          	addi	a0,a0,1362 # 5db8 <malloc+0x9bc>
    386e:	2d7010ef          	jal	5344 <printf>
      exit(1);
    3872:	4505                	li	a0,1
    3874:	684010ef          	jal	4ef8 <exit>
        getpid();
    3878:	700010ef          	jal	4f78 <getpid>
      while(1) {
    387c:	bff5                	j	3878 <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    387e:	85da                	mv	a1,s6
    3880:	00003517          	auipc	a0,0x3
    3884:	72050513          	addi	a0,a0,1824 # 6fa0 <malloc+0x1ba4>
    3888:	2bd010ef          	jal	5344 <printf>
       exit(1);
    388c:	4505                	li	a0,1
    388e:	66a010ef          	jal	4ef8 <exit>

0000000000003892 <preempt>:
{
    3892:	7139                	addi	sp,sp,-64
    3894:	fc06                	sd	ra,56(sp)
    3896:	f822                	sd	s0,48(sp)
    3898:	f426                	sd	s1,40(sp)
    389a:	f04a                	sd	s2,32(sp)
    389c:	ec4e                	sd	s3,24(sp)
    389e:	e852                	sd	s4,16(sp)
    38a0:	0080                	addi	s0,sp,64
    38a2:	892a                	mv	s2,a0
  pid1 = fork();
    38a4:	64c010ef          	jal	4ef0 <fork>
  if(pid1 < 0) {
    38a8:	00054563          	bltz	a0,38b2 <preempt+0x20>
    38ac:	84aa                	mv	s1,a0
  if(pid1 == 0)
    38ae:	ed01                	bnez	a0,38c6 <preempt+0x34>
    for(;;)
    38b0:	a001                	j	38b0 <preempt+0x1e>
    printf("%s: fork failed", s);
    38b2:	85ca                	mv	a1,s2
    38b4:	00002517          	auipc	a0,0x2
    38b8:	6c450513          	addi	a0,a0,1732 # 5f78 <malloc+0xb7c>
    38bc:	289010ef          	jal	5344 <printf>
    exit(1);
    38c0:	4505                	li	a0,1
    38c2:	636010ef          	jal	4ef8 <exit>
  pid2 = fork();
    38c6:	62a010ef          	jal	4ef0 <fork>
    38ca:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    38cc:	00054463          	bltz	a0,38d4 <preempt+0x42>
  if(pid2 == 0)
    38d0:	ed01                	bnez	a0,38e8 <preempt+0x56>
    for(;;)
    38d2:	a001                	j	38d2 <preempt+0x40>
    printf("%s: fork failed\n", s);
    38d4:	85ca                	mv	a1,s2
    38d6:	00002517          	auipc	a0,0x2
    38da:	4e250513          	addi	a0,a0,1250 # 5db8 <malloc+0x9bc>
    38de:	267010ef          	jal	5344 <printf>
    exit(1);
    38e2:	4505                	li	a0,1
    38e4:	614010ef          	jal	4ef8 <exit>
  pipe(pfds);
    38e8:	fc840513          	addi	a0,s0,-56
    38ec:	61c010ef          	jal	4f08 <pipe>
  pid3 = fork();
    38f0:	600010ef          	jal	4ef0 <fork>
    38f4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    38f6:	02054863          	bltz	a0,3926 <preempt+0x94>
  if(pid3 == 0){
    38fa:	e921                	bnez	a0,394a <preempt+0xb8>
    close(pfds[0]);
    38fc:	fc842503          	lw	a0,-56(s0)
    3900:	620010ef          	jal	4f20 <close>
    if(write(pfds[1], "x", 1) != 1)
    3904:	4605                	li	a2,1
    3906:	00002597          	auipc	a1,0x2
    390a:	c9258593          	addi	a1,a1,-878 # 5598 <malloc+0x19c>
    390e:	fcc42503          	lw	a0,-52(s0)
    3912:	606010ef          	jal	4f18 <write>
    3916:	4785                	li	a5,1
    3918:	02f51163          	bne	a0,a5,393a <preempt+0xa8>
    close(pfds[1]);
    391c:	fcc42503          	lw	a0,-52(s0)
    3920:	600010ef          	jal	4f20 <close>
    for(;;)
    3924:	a001                	j	3924 <preempt+0x92>
     printf("%s: fork failed\n", s);
    3926:	85ca                	mv	a1,s2
    3928:	00002517          	auipc	a0,0x2
    392c:	49050513          	addi	a0,a0,1168 # 5db8 <malloc+0x9bc>
    3930:	215010ef          	jal	5344 <printf>
     exit(1);
    3934:	4505                	li	a0,1
    3936:	5c2010ef          	jal	4ef8 <exit>
      printf("%s: preempt write error", s);
    393a:	85ca                	mv	a1,s2
    393c:	00003517          	auipc	a0,0x3
    3940:	68450513          	addi	a0,a0,1668 # 6fc0 <malloc+0x1bc4>
    3944:	201010ef          	jal	5344 <printf>
    3948:	bfd1                	j	391c <preempt+0x8a>
  close(pfds[1]);
    394a:	fcc42503          	lw	a0,-52(s0)
    394e:	5d2010ef          	jal	4f20 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3952:	660d                	lui	a2,0x3
    3954:	00008597          	auipc	a1,0x8
    3958:	35458593          	addi	a1,a1,852 # bca8 <buf>
    395c:	fc842503          	lw	a0,-56(s0)
    3960:	5b0010ef          	jal	4f10 <read>
    3964:	4785                	li	a5,1
    3966:	02f50163          	beq	a0,a5,3988 <preempt+0xf6>
    printf("%s: preempt read error", s);
    396a:	85ca                	mv	a1,s2
    396c:	00003517          	auipc	a0,0x3
    3970:	66c50513          	addi	a0,a0,1644 # 6fd8 <malloc+0x1bdc>
    3974:	1d1010ef          	jal	5344 <printf>
}
    3978:	70e2                	ld	ra,56(sp)
    397a:	7442                	ld	s0,48(sp)
    397c:	74a2                	ld	s1,40(sp)
    397e:	7902                	ld	s2,32(sp)
    3980:	69e2                	ld	s3,24(sp)
    3982:	6a42                	ld	s4,16(sp)
    3984:	6121                	addi	sp,sp,64
    3986:	8082                	ret
  close(pfds[0]);
    3988:	fc842503          	lw	a0,-56(s0)
    398c:	594010ef          	jal	4f20 <close>
  printf("kill... ");
    3990:	00003517          	auipc	a0,0x3
    3994:	66050513          	addi	a0,a0,1632 # 6ff0 <malloc+0x1bf4>
    3998:	1ad010ef          	jal	5344 <printf>
  kill(pid1);
    399c:	8526                	mv	a0,s1
    399e:	58a010ef          	jal	4f28 <kill>
  kill(pid2);
    39a2:	854e                	mv	a0,s3
    39a4:	584010ef          	jal	4f28 <kill>
  kill(pid3);
    39a8:	8552                	mv	a0,s4
    39aa:	57e010ef          	jal	4f28 <kill>
  printf("wait... ");
    39ae:	00003517          	auipc	a0,0x3
    39b2:	65250513          	addi	a0,a0,1618 # 7000 <malloc+0x1c04>
    39b6:	18f010ef          	jal	5344 <printf>
  wait(0);
    39ba:	4501                	li	a0,0
    39bc:	544010ef          	jal	4f00 <wait>
  wait(0);
    39c0:	4501                	li	a0,0
    39c2:	53e010ef          	jal	4f00 <wait>
  wait(0);
    39c6:	4501                	li	a0,0
    39c8:	538010ef          	jal	4f00 <wait>
    39cc:	b775                	j	3978 <preempt+0xe6>

00000000000039ce <reparent>:
{
    39ce:	7179                	addi	sp,sp,-48
    39d0:	f406                	sd	ra,40(sp)
    39d2:	f022                	sd	s0,32(sp)
    39d4:	ec26                	sd	s1,24(sp)
    39d6:	e84a                	sd	s2,16(sp)
    39d8:	e44e                	sd	s3,8(sp)
    39da:	e052                	sd	s4,0(sp)
    39dc:	1800                	addi	s0,sp,48
    39de:	89aa                	mv	s3,a0
  int master_pid = getpid();
    39e0:	598010ef          	jal	4f78 <getpid>
    39e4:	8a2a                	mv	s4,a0
    39e6:	0c800913          	li	s2,200
    int pid = fork();
    39ea:	506010ef          	jal	4ef0 <fork>
    39ee:	84aa                	mv	s1,a0
    if(pid < 0){
    39f0:	00054e63          	bltz	a0,3a0c <reparent+0x3e>
    if(pid){
    39f4:	c121                	beqz	a0,3a34 <reparent+0x66>
      if(wait(0) != pid){
    39f6:	4501                	li	a0,0
    39f8:	508010ef          	jal	4f00 <wait>
    39fc:	02951263          	bne	a0,s1,3a20 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3a00:	397d                	addiw	s2,s2,-1
    3a02:	fe0914e3          	bnez	s2,39ea <reparent+0x1c>
  exit(0);
    3a06:	4501                	li	a0,0
    3a08:	4f0010ef          	jal	4ef8 <exit>
      printf("%s: fork failed\n", s);
    3a0c:	85ce                	mv	a1,s3
    3a0e:	00002517          	auipc	a0,0x2
    3a12:	3aa50513          	addi	a0,a0,938 # 5db8 <malloc+0x9bc>
    3a16:	12f010ef          	jal	5344 <printf>
      exit(1);
    3a1a:	4505                	li	a0,1
    3a1c:	4dc010ef          	jal	4ef8 <exit>
        printf("%s: wait wrong pid\n", s);
    3a20:	85ce                	mv	a1,s3
    3a22:	00002517          	auipc	a0,0x2
    3a26:	51e50513          	addi	a0,a0,1310 # 5f40 <malloc+0xb44>
    3a2a:	11b010ef          	jal	5344 <printf>
        exit(1);
    3a2e:	4505                	li	a0,1
    3a30:	4c8010ef          	jal	4ef8 <exit>
      int pid2 = fork();
    3a34:	4bc010ef          	jal	4ef0 <fork>
      if(pid2 < 0){
    3a38:	00054563          	bltz	a0,3a42 <reparent+0x74>
      exit(0);
    3a3c:	4501                	li	a0,0
    3a3e:	4ba010ef          	jal	4ef8 <exit>
        kill(master_pid);
    3a42:	8552                	mv	a0,s4
    3a44:	4e4010ef          	jal	4f28 <kill>
        exit(1);
    3a48:	4505                	li	a0,1
    3a4a:	4ae010ef          	jal	4ef8 <exit>

0000000000003a4e <sbrkfail>:
{
    3a4e:	7175                	addi	sp,sp,-144
    3a50:	e506                	sd	ra,136(sp)
    3a52:	e122                	sd	s0,128(sp)
    3a54:	fca6                	sd	s1,120(sp)
    3a56:	f8ca                	sd	s2,112(sp)
    3a58:	f4ce                	sd	s3,104(sp)
    3a5a:	f0d2                	sd	s4,96(sp)
    3a5c:	ecd6                	sd	s5,88(sp)
    3a5e:	e8da                	sd	s6,80(sp)
    3a60:	e4de                	sd	s7,72(sp)
    3a62:	e0e2                	sd	s8,64(sp)
    3a64:	0900                	addi	s0,sp,144
    3a66:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    3a68:	fa040513          	addi	a0,s0,-96
    3a6c:	49c010ef          	jal	4f08 <pipe>
    3a70:	ed01                	bnez	a0,3a88 <sbrkfail+0x3a>
    3a72:	8baa                	mv	s7,a0
    3a74:	f7040493          	addi	s1,s0,-144
    3a78:	f9840993          	addi	s3,s0,-104
    3a7c:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    3a7e:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3a80:	f9f40b13          	addi	s6,s0,-97
    3a84:	4a85                	li	s5,1
    3a86:	a095                	j	3aea <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3a88:	85e2                	mv	a1,s8
    3a8a:	00002517          	auipc	a0,0x2
    3a8e:	43650513          	addi	a0,a0,1078 # 5ec0 <malloc+0xac4>
    3a92:	0b3010ef          	jal	5344 <printf>
    exit(1);
    3a96:	4505                	li	a0,1
    3a98:	460010ef          	jal	4ef8 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3a9c:	428010ef          	jal	4ec4 <sbrk>
    3aa0:	064007b7          	lui	a5,0x6400
    3aa4:	40a7853b          	subw	a0,a5,a0
    3aa8:	41c010ef          	jal	4ec4 <sbrk>
    3aac:	57fd                	li	a5,-1
    3aae:	02f50163          	beq	a0,a5,3ad0 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3ab2:	4605                	li	a2,1
    3ab4:	00004597          	auipc	a1,0x4
    3ab8:	bec58593          	addi	a1,a1,-1044 # 76a0 <malloc+0x22a4>
    3abc:	fa442503          	lw	a0,-92(s0)
    3ac0:	458010ef          	jal	4f18 <write>
      for(;;) pause(1000);
    3ac4:	3e800493          	li	s1,1000
    3ac8:	8526                	mv	a0,s1
    3aca:	4be010ef          	jal	4f88 <pause>
    3ace:	bfed                	j	3ac8 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3ad0:	4605                	li	a2,1
    3ad2:	00003597          	auipc	a1,0x3
    3ad6:	53e58593          	addi	a1,a1,1342 # 7010 <malloc+0x1c14>
    3ada:	fa442503          	lw	a0,-92(s0)
    3ade:	43a010ef          	jal	4f18 <write>
    3ae2:	b7cd                	j	3ac4 <sbrkfail+0x76>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3ae4:	0911                	addi	s2,s2,4
    3ae6:	03390a63          	beq	s2,s3,3b1a <sbrkfail+0xcc>
    if((pids[i] = fork()) == 0){
    3aea:	406010ef          	jal	4ef0 <fork>
    3aee:	00a92023          	sw	a0,0(s2)
    3af2:	d54d                	beqz	a0,3a9c <sbrkfail+0x4e>
    if(pids[i] != -1) {
    3af4:	ff4508e3          	beq	a0,s4,3ae4 <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3af8:	8656                	mv	a2,s5
    3afa:	85da                	mv	a1,s6
    3afc:	fa042503          	lw	a0,-96(s0)
    3b00:	410010ef          	jal	4f10 <read>
      if(scratch == '0')
    3b04:	f9f44783          	lbu	a5,-97(s0)
    3b08:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63f1328>
    3b0c:	0017b793          	seqz	a5,a5
    3b10:	00fbe7b3          	or	a5,s7,a5
    3b14:	00078b9b          	sext.w	s7,a5
    3b18:	b7f1                	j	3ae4 <sbrkfail+0x96>
  if(!failed) {
    3b1a:	000b8863          	beqz	s7,3b2a <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3b1e:	6505                	lui	a0,0x1
    3b20:	3a4010ef          	jal	4ec4 <sbrk>
    3b24:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3b26:	597d                	li	s2,-1
    3b28:	a821                	j	3b40 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3b2a:	85e2                	mv	a1,s8
    3b2c:	00003517          	auipc	a0,0x3
    3b30:	4ec50513          	addi	a0,a0,1260 # 7018 <malloc+0x1c1c>
    3b34:	011010ef          	jal	5344 <printf>
    3b38:	b7dd                	j	3b1e <sbrkfail+0xd0>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3b3a:	0491                	addi	s1,s1,4
    3b3c:	01348b63          	beq	s1,s3,3b52 <sbrkfail+0x104>
    if(pids[i] == -1)
    3b40:	4088                	lw	a0,0(s1)
    3b42:	ff250ce3          	beq	a0,s2,3b3a <sbrkfail+0xec>
    kill(pids[i]);
    3b46:	3e2010ef          	jal	4f28 <kill>
    wait(0);
    3b4a:	4501                	li	a0,0
    3b4c:	3b4010ef          	jal	4f00 <wait>
    3b50:	b7ed                	j	3b3a <sbrkfail+0xec>
  if(c == (char*)SBRK_ERROR){
    3b52:	57fd                	li	a5,-1
    3b54:	02fa0a63          	beq	s4,a5,3b88 <sbrkfail+0x13a>
  pid = fork();
    3b58:	398010ef          	jal	4ef0 <fork>
  if(pid < 0){
    3b5c:	04054063          	bltz	a0,3b9c <sbrkfail+0x14e>
  if(pid == 0){
    3b60:	e939                	bnez	a0,3bb6 <sbrkfail+0x168>
    a = sbrk(10*BIG);
    3b62:	3e800537          	lui	a0,0x3e800
    3b66:	35e010ef          	jal	4ec4 <sbrk>
    if(a == (char*)SBRK_ERROR){
    3b6a:	57fd                	li	a5,-1
    3b6c:	04f50263          	beq	a0,a5,3bb0 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    3b70:	3e800637          	lui	a2,0x3e800
    3b74:	85e2                	mv	a1,s8
    3b76:	00003517          	auipc	a0,0x3
    3b7a:	4f250513          	addi	a0,a0,1266 # 7068 <malloc+0x1c6c>
    3b7e:	7c6010ef          	jal	5344 <printf>
    exit(1);
    3b82:	4505                	li	a0,1
    3b84:	374010ef          	jal	4ef8 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3b88:	85e2                	mv	a1,s8
    3b8a:	00003517          	auipc	a0,0x3
    3b8e:	4be50513          	addi	a0,a0,1214 # 7048 <malloc+0x1c4c>
    3b92:	7b2010ef          	jal	5344 <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	360010ef          	jal	4ef8 <exit>
    printf("%s: fork failed\n", s);
    3b9c:	85e2                	mv	a1,s8
    3b9e:	00002517          	auipc	a0,0x2
    3ba2:	21a50513          	addi	a0,a0,538 # 5db8 <malloc+0x9bc>
    3ba6:	79e010ef          	jal	5344 <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	34c010ef          	jal	4ef8 <exit>
      exit(0);
    3bb0:	4501                	li	a0,0
    3bb2:	346010ef          	jal	4ef8 <exit>
  wait(&xstatus);
    3bb6:	fac40513          	addi	a0,s0,-84
    3bba:	346010ef          	jal	4f00 <wait>
  if(xstatus != 0)
    3bbe:	fac42783          	lw	a5,-84(s0)
    3bc2:	ef89                	bnez	a5,3bdc <sbrkfail+0x18e>
}
    3bc4:	60aa                	ld	ra,136(sp)
    3bc6:	640a                	ld	s0,128(sp)
    3bc8:	74e6                	ld	s1,120(sp)
    3bca:	7946                	ld	s2,112(sp)
    3bcc:	79a6                	ld	s3,104(sp)
    3bce:	7a06                	ld	s4,96(sp)
    3bd0:	6ae6                	ld	s5,88(sp)
    3bd2:	6b46                	ld	s6,80(sp)
    3bd4:	6ba6                	ld	s7,72(sp)
    3bd6:	6c06                	ld	s8,64(sp)
    3bd8:	6149                	addi	sp,sp,144
    3bda:	8082                	ret
    exit(1);
    3bdc:	4505                	li	a0,1
    3bde:	31a010ef          	jal	4ef8 <exit>

0000000000003be2 <mem>:
{
    3be2:	7139                	addi	sp,sp,-64
    3be4:	fc06                	sd	ra,56(sp)
    3be6:	f822                	sd	s0,48(sp)
    3be8:	f426                	sd	s1,40(sp)
    3bea:	f04a                	sd	s2,32(sp)
    3bec:	ec4e                	sd	s3,24(sp)
    3bee:	0080                	addi	s0,sp,64
    3bf0:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3bf2:	2fe010ef          	jal	4ef0 <fork>
    m1 = 0;
    3bf6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3bf8:	6909                	lui	s2,0x2
    3bfa:	71190913          	addi	s2,s2,1809 # 2711 <execout+0x27>
  if((pid = fork()) == 0){
    3bfe:	cd11                	beqz	a0,3c1a <mem+0x38>
    wait(&xstatus);
    3c00:	fcc40513          	addi	a0,s0,-52
    3c04:	2fc010ef          	jal	4f00 <wait>
    if(xstatus == -1){
    3c08:	fcc42503          	lw	a0,-52(s0)
    3c0c:	57fd                	li	a5,-1
    3c0e:	04f50363          	beq	a0,a5,3c54 <mem+0x72>
    exit(xstatus);
    3c12:	2e6010ef          	jal	4ef8 <exit>
      *(char**)m2 = m1;
    3c16:	e104                	sd	s1,0(a0)
      m1 = m2;
    3c18:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3c1a:	854a                	mv	a0,s2
    3c1c:	7e0010ef          	jal	53fc <malloc>
    3c20:	f97d                	bnez	a0,3c16 <mem+0x34>
    while(m1){
    3c22:	c491                	beqz	s1,3c2e <mem+0x4c>
      m2 = *(char**)m1;
    3c24:	8526                	mv	a0,s1
    3c26:	6084                	ld	s1,0(s1)
      free(m1);
    3c28:	74e010ef          	jal	5376 <free>
    while(m1){
    3c2c:	fce5                	bnez	s1,3c24 <mem+0x42>
    m1 = malloc(1024*20);
    3c2e:	6515                	lui	a0,0x5
    3c30:	7cc010ef          	jal	53fc <malloc>
    if(m1 == 0){
    3c34:	c511                	beqz	a0,3c40 <mem+0x5e>
    free(m1);
    3c36:	740010ef          	jal	5376 <free>
    exit(0);
    3c3a:	4501                	li	a0,0
    3c3c:	2bc010ef          	jal	4ef8 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c40:	85ce                	mv	a1,s3
    3c42:	00003517          	auipc	a0,0x3
    3c46:	45650513          	addi	a0,a0,1110 # 7098 <malloc+0x1c9c>
    3c4a:	6fa010ef          	jal	5344 <printf>
      exit(1);
    3c4e:	4505                	li	a0,1
    3c50:	2a8010ef          	jal	4ef8 <exit>
      exit(0);
    3c54:	4501                	li	a0,0
    3c56:	2a2010ef          	jal	4ef8 <exit>

0000000000003c5a <sharedfd>:
{
    3c5a:	7159                	addi	sp,sp,-112
    3c5c:	f486                	sd	ra,104(sp)
    3c5e:	f0a2                	sd	s0,96(sp)
    3c60:	eca6                	sd	s1,88(sp)
    3c62:	f85a                	sd	s6,48(sp)
    3c64:	1880                	addi	s0,sp,112
    3c66:	84aa                	mv	s1,a0
    3c68:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3c6a:	00003517          	auipc	a0,0x3
    3c6e:	44e50513          	addi	a0,a0,1102 # 70b8 <malloc+0x1cbc>
    3c72:	2d6010ef          	jal	4f48 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3c76:	20200593          	li	a1,514
    3c7a:	00003517          	auipc	a0,0x3
    3c7e:	43e50513          	addi	a0,a0,1086 # 70b8 <malloc+0x1cbc>
    3c82:	2b6010ef          	jal	4f38 <open>
  if(fd < 0){
    3c86:	04054863          	bltz	a0,3cd6 <sharedfd+0x7c>
    3c8a:	e8ca                	sd	s2,80(sp)
    3c8c:	e4ce                	sd	s3,72(sp)
    3c8e:	e0d2                	sd	s4,64(sp)
    3c90:	fc56                	sd	s5,56(sp)
    3c92:	89aa                	mv	s3,a0
  pid = fork();
    3c94:	25c010ef          	jal	4ef0 <fork>
    3c98:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3c9a:	07000593          	li	a1,112
    3c9e:	e119                	bnez	a0,3ca4 <sharedfd+0x4a>
    3ca0:	06300593          	li	a1,99
    3ca4:	4629                	li	a2,10
    3ca6:	fa040513          	addi	a0,s0,-96
    3caa:	024010ef          	jal	4cce <memset>
    3cae:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3cb2:	fa040a13          	addi	s4,s0,-96
    3cb6:	4929                	li	s2,10
    3cb8:	864a                	mv	a2,s2
    3cba:	85d2                	mv	a1,s4
    3cbc:	854e                	mv	a0,s3
    3cbe:	25a010ef          	jal	4f18 <write>
    3cc2:	03251963          	bne	a0,s2,3cf4 <sharedfd+0x9a>
  for(i = 0; i < N; i++){
    3cc6:	34fd                	addiw	s1,s1,-1
    3cc8:	f8e5                	bnez	s1,3cb8 <sharedfd+0x5e>
  if(pid == 0) {
    3cca:	040a9063          	bnez	s5,3d0a <sharedfd+0xb0>
    3cce:	f45e                	sd	s7,40(sp)
    exit(0);
    3cd0:	4501                	li	a0,0
    3cd2:	226010ef          	jal	4ef8 <exit>
    3cd6:	e8ca                	sd	s2,80(sp)
    3cd8:	e4ce                	sd	s3,72(sp)
    3cda:	e0d2                	sd	s4,64(sp)
    3cdc:	fc56                	sd	s5,56(sp)
    3cde:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3ce0:	85a6                	mv	a1,s1
    3ce2:	00003517          	auipc	a0,0x3
    3ce6:	3e650513          	addi	a0,a0,998 # 70c8 <malloc+0x1ccc>
    3cea:	65a010ef          	jal	5344 <printf>
    exit(1);
    3cee:	4505                	li	a0,1
    3cf0:	208010ef          	jal	4ef8 <exit>
    3cf4:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3cf6:	85da                	mv	a1,s6
    3cf8:	00003517          	auipc	a0,0x3
    3cfc:	3f850513          	addi	a0,a0,1016 # 70f0 <malloc+0x1cf4>
    3d00:	644010ef          	jal	5344 <printf>
      exit(1);
    3d04:	4505                	li	a0,1
    3d06:	1f2010ef          	jal	4ef8 <exit>
    wait(&xstatus);
    3d0a:	f9c40513          	addi	a0,s0,-100
    3d0e:	1f2010ef          	jal	4f00 <wait>
    if(xstatus != 0)
    3d12:	f9c42a03          	lw	s4,-100(s0)
    3d16:	000a0663          	beqz	s4,3d22 <sharedfd+0xc8>
    3d1a:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3d1c:	8552                	mv	a0,s4
    3d1e:	1da010ef          	jal	4ef8 <exit>
    3d22:	f45e                	sd	s7,40(sp)
  close(fd);
    3d24:	854e                	mv	a0,s3
    3d26:	1fa010ef          	jal	4f20 <close>
  fd = open("sharedfd", 0);
    3d2a:	4581                	li	a1,0
    3d2c:	00003517          	auipc	a0,0x3
    3d30:	38c50513          	addi	a0,a0,908 # 70b8 <malloc+0x1cbc>
    3d34:	204010ef          	jal	4f38 <open>
    3d38:	8baa                	mv	s7,a0
  nc = np = 0;
    3d3a:	89d2                	mv	s3,s4
  if(fd < 0){
    3d3c:	02054363          	bltz	a0,3d62 <sharedfd+0x108>
    3d40:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3d44:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3d48:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d4c:	4629                	li	a2,10
    3d4e:	fa040593          	addi	a1,s0,-96
    3d52:	855e                	mv	a0,s7
    3d54:	1bc010ef          	jal	4f10 <read>
    3d58:	02a05b63          	blez	a0,3d8e <sharedfd+0x134>
    3d5c:	fa040793          	addi	a5,s0,-96
    3d60:	a839                	j	3d7e <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3d62:	85da                	mv	a1,s6
    3d64:	00003517          	auipc	a0,0x3
    3d68:	3ac50513          	addi	a0,a0,940 # 7110 <malloc+0x1d14>
    3d6c:	5d8010ef          	jal	5344 <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	186010ef          	jal	4ef8 <exit>
        nc++;
    3d76:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    3d78:	0785                	addi	a5,a5,1
    3d7a:	fd2789e3          	beq	a5,s2,3d4c <sharedfd+0xf2>
      if(buf[i] == 'c')
    3d7e:	0007c703          	lbu	a4,0(a5)
    3d82:	fe970ae3          	beq	a4,s1,3d76 <sharedfd+0x11c>
      if(buf[i] == 'p')
    3d86:	ff5719e3          	bne	a4,s5,3d78 <sharedfd+0x11e>
        np++;
    3d8a:	2985                	addiw	s3,s3,1
    3d8c:	b7f5                	j	3d78 <sharedfd+0x11e>
  close(fd);
    3d8e:	855e                	mv	a0,s7
    3d90:	190010ef          	jal	4f20 <close>
  unlink("sharedfd");
    3d94:	00003517          	auipc	a0,0x3
    3d98:	32450513          	addi	a0,a0,804 # 70b8 <malloc+0x1cbc>
    3d9c:	1ac010ef          	jal	4f48 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3da0:	6789                	lui	a5,0x2
    3da2:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x26>
    3da6:	00fa1763          	bne	s4,a5,3db4 <sharedfd+0x15a>
    3daa:	01499563          	bne	s3,s4,3db4 <sharedfd+0x15a>
    exit(0);
    3dae:	4501                	li	a0,0
    3db0:	148010ef          	jal	4ef8 <exit>
    printf("%s: nc/np test fails\n", s);
    3db4:	85da                	mv	a1,s6
    3db6:	00003517          	auipc	a0,0x3
    3dba:	38250513          	addi	a0,a0,898 # 7138 <malloc+0x1d3c>
    3dbe:	586010ef          	jal	5344 <printf>
    exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	134010ef          	jal	4ef8 <exit>

0000000000003dc8 <fourfiles>:
{
    3dc8:	7135                	addi	sp,sp,-160
    3dca:	ed06                	sd	ra,152(sp)
    3dcc:	e922                	sd	s0,144(sp)
    3dce:	e526                	sd	s1,136(sp)
    3dd0:	e14a                	sd	s2,128(sp)
    3dd2:	fcce                	sd	s3,120(sp)
    3dd4:	f8d2                	sd	s4,112(sp)
    3dd6:	f4d6                	sd	s5,104(sp)
    3dd8:	f0da                	sd	s6,96(sp)
    3dda:	ecde                	sd	s7,88(sp)
    3ddc:	e8e2                	sd	s8,80(sp)
    3dde:	e4e6                	sd	s9,72(sp)
    3de0:	e0ea                	sd	s10,64(sp)
    3de2:	fc6e                	sd	s11,56(sp)
    3de4:	1100                	addi	s0,sp,160
    3de6:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3de8:	00003797          	auipc	a5,0x3
    3dec:	36878793          	addi	a5,a5,872 # 7150 <malloc+0x1d54>
    3df0:	f6f43823          	sd	a5,-144(s0)
    3df4:	00003797          	auipc	a5,0x3
    3df8:	36478793          	addi	a5,a5,868 # 7158 <malloc+0x1d5c>
    3dfc:	f6f43c23          	sd	a5,-136(s0)
    3e00:	00003797          	auipc	a5,0x3
    3e04:	36078793          	addi	a5,a5,864 # 7160 <malloc+0x1d64>
    3e08:	f8f43023          	sd	a5,-128(s0)
    3e0c:	00003797          	auipc	a5,0x3
    3e10:	35c78793          	addi	a5,a5,860 # 7168 <malloc+0x1d6c>
    3e14:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3e18:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3e1c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3e1e:	4481                	li	s1,0
    3e20:	4a11                	li	s4,4
    fname = names[pi];
    3e22:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e26:	854e                	mv	a0,s3
    3e28:	120010ef          	jal	4f48 <unlink>
    pid = fork();
    3e2c:	0c4010ef          	jal	4ef0 <fork>
    if(pid < 0){
    3e30:	04054063          	bltz	a0,3e70 <fourfiles+0xa8>
    if(pid == 0){
    3e34:	c921                	beqz	a0,3e84 <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3e36:	2485                	addiw	s1,s1,1
    3e38:	0921                	addi	s2,s2,8
    3e3a:	ff4494e3          	bne	s1,s4,3e22 <fourfiles+0x5a>
    3e3e:	4491                	li	s1,4
    wait(&xstatus);
    3e40:	f6c40913          	addi	s2,s0,-148
    3e44:	854a                	mv	a0,s2
    3e46:	0ba010ef          	jal	4f00 <wait>
    if(xstatus != 0)
    3e4a:	f6c42b03          	lw	s6,-148(s0)
    3e4e:	0a0b1463          	bnez	s6,3ef6 <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3e52:	34fd                	addiw	s1,s1,-1
    3e54:	f8e5                	bnez	s1,3e44 <fourfiles+0x7c>
    3e56:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e5a:	6a8d                	lui	s5,0x3
    3e5c:	00008a17          	auipc	s4,0x8
    3e60:	e4ca0a13          	addi	s4,s4,-436 # bca8 <buf>
    if(total != N*SZ){
    3e64:	6d05                	lui	s10,0x1
    3e66:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x90>
  for(i = 0; i < NCHILD; i++){
    3e6a:	03400d93          	li	s11,52
    3e6e:	a86d                	j	3f28 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3e70:	85e6                	mv	a1,s9
    3e72:	00002517          	auipc	a0,0x2
    3e76:	f4650513          	addi	a0,a0,-186 # 5db8 <malloc+0x9bc>
    3e7a:	4ca010ef          	jal	5344 <printf>
      exit(1);
    3e7e:	4505                	li	a0,1
    3e80:	078010ef          	jal	4ef8 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3e84:	20200593          	li	a1,514
    3e88:	854e                	mv	a0,s3
    3e8a:	0ae010ef          	jal	4f38 <open>
    3e8e:	892a                	mv	s2,a0
      if(fd < 0){
    3e90:	04054063          	bltz	a0,3ed0 <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3e94:	1f400613          	li	a2,500
    3e98:	0304859b          	addiw	a1,s1,48
    3e9c:	00008517          	auipc	a0,0x8
    3ea0:	e0c50513          	addi	a0,a0,-500 # bca8 <buf>
    3ea4:	62b000ef          	jal	4cce <memset>
    3ea8:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3eaa:	1f400993          	li	s3,500
    3eae:	00008a17          	auipc	s4,0x8
    3eb2:	dfaa0a13          	addi	s4,s4,-518 # bca8 <buf>
    3eb6:	864e                	mv	a2,s3
    3eb8:	85d2                	mv	a1,s4
    3eba:	854a                	mv	a0,s2
    3ebc:	05c010ef          	jal	4f18 <write>
    3ec0:	85aa                	mv	a1,a0
    3ec2:	03351163          	bne	a0,s3,3ee4 <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3ec6:	34fd                	addiw	s1,s1,-1
    3ec8:	f4fd                	bnez	s1,3eb6 <fourfiles+0xee>
      exit(0);
    3eca:	4501                	li	a0,0
    3ecc:	02c010ef          	jal	4ef8 <exit>
        printf("%s: create failed\n", s);
    3ed0:	85e6                	mv	a1,s9
    3ed2:	00002517          	auipc	a0,0x2
    3ed6:	f7e50513          	addi	a0,a0,-130 # 5e50 <malloc+0xa54>
    3eda:	46a010ef          	jal	5344 <printf>
        exit(1);
    3ede:	4505                	li	a0,1
    3ee0:	018010ef          	jal	4ef8 <exit>
          printf("write failed %d\n", n);
    3ee4:	00003517          	auipc	a0,0x3
    3ee8:	28c50513          	addi	a0,a0,652 # 7170 <malloc+0x1d74>
    3eec:	458010ef          	jal	5344 <printf>
          exit(1);
    3ef0:	4505                	li	a0,1
    3ef2:	006010ef          	jal	4ef8 <exit>
      exit(xstatus);
    3ef6:	855a                	mv	a0,s6
    3ef8:	000010ef          	jal	4ef8 <exit>
          printf("%s: wrong char\n", s);
    3efc:	85e6                	mv	a1,s9
    3efe:	00003517          	auipc	a0,0x3
    3f02:	28a50513          	addi	a0,a0,650 # 7188 <malloc+0x1d8c>
    3f06:	43e010ef          	jal	5344 <printf>
          exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	7ed000ef          	jal	4ef8 <exit>
    close(fd);
    3f10:	854e                	mv	a0,s3
    3f12:	00e010ef          	jal	4f20 <close>
    if(total != N*SZ){
    3f16:	05a91863          	bne	s2,s10,3f66 <fourfiles+0x19e>
    unlink(fname);
    3f1a:	8562                	mv	a0,s8
    3f1c:	02c010ef          	jal	4f48 <unlink>
  for(i = 0; i < NCHILD; i++){
    3f20:	0ba1                	addi	s7,s7,8
    3f22:	2485                	addiw	s1,s1,1
    3f24:	05b48b63          	beq	s1,s11,3f7a <fourfiles+0x1b2>
    fname = names[i];
    3f28:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f2c:	4581                	li	a1,0
    3f2e:	8562                	mv	a0,s8
    3f30:	008010ef          	jal	4f38 <open>
    3f34:	89aa                	mv	s3,a0
    total = 0;
    3f36:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3f38:	8656                	mv	a2,s5
    3f3a:	85d2                	mv	a1,s4
    3f3c:	854e                	mv	a0,s3
    3f3e:	7d3000ef          	jal	4f10 <read>
    3f42:	fca057e3          	blez	a0,3f10 <fourfiles+0x148>
    3f46:	00008797          	auipc	a5,0x8
    3f4a:	d6278793          	addi	a5,a5,-670 # bca8 <buf>
    3f4e:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3f52:	0007c703          	lbu	a4,0(a5)
    3f56:	fa9713e3          	bne	a4,s1,3efc <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3f5a:	0785                	addi	a5,a5,1
    3f5c:	fed79be3          	bne	a5,a3,3f52 <fourfiles+0x18a>
      total += n;
    3f60:	00a9093b          	addw	s2,s2,a0
    3f64:	bfd1                	j	3f38 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3f66:	85ca                	mv	a1,s2
    3f68:	00003517          	auipc	a0,0x3
    3f6c:	23050513          	addi	a0,a0,560 # 7198 <malloc+0x1d9c>
    3f70:	3d4010ef          	jal	5344 <printf>
      exit(1);
    3f74:	4505                	li	a0,1
    3f76:	783000ef          	jal	4ef8 <exit>
}
    3f7a:	60ea                	ld	ra,152(sp)
    3f7c:	644a                	ld	s0,144(sp)
    3f7e:	64aa                	ld	s1,136(sp)
    3f80:	690a                	ld	s2,128(sp)
    3f82:	79e6                	ld	s3,120(sp)
    3f84:	7a46                	ld	s4,112(sp)
    3f86:	7aa6                	ld	s5,104(sp)
    3f88:	7b06                	ld	s6,96(sp)
    3f8a:	6be6                	ld	s7,88(sp)
    3f8c:	6c46                	ld	s8,80(sp)
    3f8e:	6ca6                	ld	s9,72(sp)
    3f90:	6d06                	ld	s10,64(sp)
    3f92:	7de2                	ld	s11,56(sp)
    3f94:	610d                	addi	sp,sp,160
    3f96:	8082                	ret

0000000000003f98 <concreate>:
{
    3f98:	7171                	addi	sp,sp,-176
    3f9a:	f506                	sd	ra,168(sp)
    3f9c:	f122                	sd	s0,160(sp)
    3f9e:	ed26                	sd	s1,152(sp)
    3fa0:	e94a                	sd	s2,144(sp)
    3fa2:	e54e                	sd	s3,136(sp)
    3fa4:	e152                	sd	s4,128(sp)
    3fa6:	fcd6                	sd	s5,120(sp)
    3fa8:	f8da                	sd	s6,112(sp)
    3faa:	f4de                	sd	s7,104(sp)
    3fac:	f0e2                	sd	s8,96(sp)
    3fae:	ece6                	sd	s9,88(sp)
    3fb0:	e8ea                	sd	s10,80(sp)
    3fb2:	1900                	addi	s0,sp,176
    3fb4:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3fb6:	04300793          	li	a5,67
    3fba:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3fbe:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3fc2:	4901                	li	s2,0
    unlink(file);
    3fc4:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3fc8:	55555b37          	lui	s6,0x55555
    3fcc:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555468ae>
    3fd0:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    3fd2:	20200c13          	li	s8,514
      link("C0", file);
    3fd6:	00003c97          	auipc	s9,0x3
    3fda:	1dac8c93          	addi	s9,s9,474 # 71b0 <malloc+0x1db4>
      wait(&xstatus);
    3fde:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3fe2:	02800a13          	li	s4,40
    3fe6:	ac25                	j	421e <concreate+0x286>
      link("C0", file);
    3fe8:	85ce                	mv	a1,s3
    3fea:	8566                	mv	a0,s9
    3fec:	76d000ef          	jal	4f58 <link>
    if(pid == 0) {
    3ff0:	ac29                	j	420a <concreate+0x272>
    } else if(pid == 0 && (i % 5) == 1){
    3ff2:	666667b7          	lui	a5,0x66666
    3ff6:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666579bf>
    3ffa:	02f907b3          	mul	a5,s2,a5
    3ffe:	9785                	srai	a5,a5,0x21
    4000:	41f9571b          	sraiw	a4,s2,0x1f
    4004:	9f99                	subw	a5,a5,a4
    4006:	0027971b          	slliw	a4,a5,0x2
    400a:	9fb9                	addw	a5,a5,a4
    400c:	40f9093b          	subw	s2,s2,a5
    4010:	4785                	li	a5,1
    4012:	02f90563          	beq	s2,a5,403c <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    4016:	20200593          	li	a1,514
    401a:	f9840513          	addi	a0,s0,-104
    401e:	71b000ef          	jal	4f38 <open>
      if(fd < 0){
    4022:	1c055f63          	bgez	a0,4200 <concreate+0x268>
        printf("concreate create %s failed\n", file);
    4026:	f9840593          	addi	a1,s0,-104
    402a:	00003517          	auipc	a0,0x3
    402e:	18e50513          	addi	a0,a0,398 # 71b8 <malloc+0x1dbc>
    4032:	312010ef          	jal	5344 <printf>
        exit(1);
    4036:	4505                	li	a0,1
    4038:	6c1000ef          	jal	4ef8 <exit>
      link("C0", file);
    403c:	f9840593          	addi	a1,s0,-104
    4040:	00003517          	auipc	a0,0x3
    4044:	17050513          	addi	a0,a0,368 # 71b0 <malloc+0x1db4>
    4048:	711000ef          	jal	4f58 <link>
      exit(0);
    404c:	4501                	li	a0,0
    404e:	6ab000ef          	jal	4ef8 <exit>
        exit(1);
    4052:	4505                	li	a0,1
    4054:	6a5000ef          	jal	4ef8 <exit>
  memset(fa, 0, sizeof(fa));
    4058:	02800613          	li	a2,40
    405c:	4581                	li	a1,0
    405e:	f7040513          	addi	a0,s0,-144
    4062:	46d000ef          	jal	4cce <memset>
  fd = open(".", 0);
    4066:	4581                	li	a1,0
    4068:	00002517          	auipc	a0,0x2
    406c:	ba850513          	addi	a0,a0,-1112 # 5c10 <malloc+0x814>
    4070:	6c9000ef          	jal	4f38 <open>
    4074:	892a                	mv	s2,a0
  n = 0;
    4076:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    4078:	f6040a13          	addi	s4,s0,-160
    407c:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    407e:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    4082:	02700b93          	li	s7,39
      fa[i] = 1;
    4086:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    4088:	864e                	mv	a2,s3
    408a:	85d2                	mv	a1,s4
    408c:	854a                	mv	a0,s2
    408e:	683000ef          	jal	4f10 <read>
    4092:	06a05763          	blez	a0,4100 <concreate+0x168>
    if(de.inum == 0)
    4096:	f6045783          	lhu	a5,-160(s0)
    409a:	d7fd                	beqz	a5,4088 <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    409c:	f6244783          	lbu	a5,-158(s0)
    40a0:	ff5794e3          	bne	a5,s5,4088 <concreate+0xf0>
    40a4:	f6444783          	lbu	a5,-156(s0)
    40a8:	f3e5                	bnez	a5,4088 <concreate+0xf0>
      i = de.name[1] - '0';
    40aa:	f6344783          	lbu	a5,-157(s0)
    40ae:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    40b2:	00fbef63          	bltu	s7,a5,40d0 <concreate+0x138>
      if(fa[i]){
    40b6:	fa078713          	addi	a4,a5,-96
    40ba:	9722                	add	a4,a4,s0
    40bc:	fd074703          	lbu	a4,-48(a4)
    40c0:	e705                	bnez	a4,40e8 <concreate+0x150>
      fa[i] = 1;
    40c2:	fa078793          	addi	a5,a5,-96
    40c6:	97a2                	add	a5,a5,s0
    40c8:	fd878823          	sb	s8,-48(a5)
      n++;
    40cc:	2b05                	addiw	s6,s6,1
    40ce:	bf6d                	j	4088 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    40d0:	f6240613          	addi	a2,s0,-158
    40d4:	85ea                	mv	a1,s10
    40d6:	00003517          	auipc	a0,0x3
    40da:	10250513          	addi	a0,a0,258 # 71d8 <malloc+0x1ddc>
    40de:	266010ef          	jal	5344 <printf>
        exit(1);
    40e2:	4505                	li	a0,1
    40e4:	615000ef          	jal	4ef8 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    40e8:	f6240613          	addi	a2,s0,-158
    40ec:	85ea                	mv	a1,s10
    40ee:	00003517          	auipc	a0,0x3
    40f2:	10a50513          	addi	a0,a0,266 # 71f8 <malloc+0x1dfc>
    40f6:	24e010ef          	jal	5344 <printf>
        exit(1);
    40fa:	4505                	li	a0,1
    40fc:	5fd000ef          	jal	4ef8 <exit>
  close(fd);
    4100:	854a                	mv	a0,s2
    4102:	61f000ef          	jal	4f20 <close>
  if(n != N){
    4106:	02800793          	li	a5,40
    410a:	00fb1a63          	bne	s6,a5,411e <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    410e:	55555a37          	lui	s4,0x55555
    4112:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555468ae>
      close(open(file, 0));
    4116:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    411a:	8ada                	mv	s5,s6
    411c:	a049                	j	419e <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    411e:	85ea                	mv	a1,s10
    4120:	00003517          	auipc	a0,0x3
    4124:	10050513          	addi	a0,a0,256 # 7220 <malloc+0x1e24>
    4128:	21c010ef          	jal	5344 <printf>
    exit(1);
    412c:	4505                	li	a0,1
    412e:	5cb000ef          	jal	4ef8 <exit>
      printf("%s: fork failed\n", s);
    4132:	85ea                	mv	a1,s10
    4134:	00002517          	auipc	a0,0x2
    4138:	c8450513          	addi	a0,a0,-892 # 5db8 <malloc+0x9bc>
    413c:	208010ef          	jal	5344 <printf>
      exit(1);
    4140:	4505                	li	a0,1
    4142:	5b7000ef          	jal	4ef8 <exit>
      close(open(file, 0));
    4146:	4581                	li	a1,0
    4148:	854e                	mv	a0,s3
    414a:	5ef000ef          	jal	4f38 <open>
    414e:	5d3000ef          	jal	4f20 <close>
      close(open(file, 0));
    4152:	4581                	li	a1,0
    4154:	854e                	mv	a0,s3
    4156:	5e3000ef          	jal	4f38 <open>
    415a:	5c7000ef          	jal	4f20 <close>
      close(open(file, 0));
    415e:	4581                	li	a1,0
    4160:	854e                	mv	a0,s3
    4162:	5d7000ef          	jal	4f38 <open>
    4166:	5bb000ef          	jal	4f20 <close>
      close(open(file, 0));
    416a:	4581                	li	a1,0
    416c:	854e                	mv	a0,s3
    416e:	5cb000ef          	jal	4f38 <open>
    4172:	5af000ef          	jal	4f20 <close>
      close(open(file, 0));
    4176:	4581                	li	a1,0
    4178:	854e                	mv	a0,s3
    417a:	5bf000ef          	jal	4f38 <open>
    417e:	5a3000ef          	jal	4f20 <close>
      close(open(file, 0));
    4182:	4581                	li	a1,0
    4184:	854e                	mv	a0,s3
    4186:	5b3000ef          	jal	4f38 <open>
    418a:	597000ef          	jal	4f20 <close>
    if(pid == 0)
    418e:	06090663          	beqz	s2,41fa <concreate+0x262>
      wait(0);
    4192:	4501                	li	a0,0
    4194:	56d000ef          	jal	4f00 <wait>
  for(i = 0; i < N; i++){
    4198:	2485                	addiw	s1,s1,1
    419a:	0d548163          	beq	s1,s5,425c <concreate+0x2c4>
    file[1] = '0' + i;
    419e:	0304879b          	addiw	a5,s1,48
    41a2:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    41a6:	54b000ef          	jal	4ef0 <fork>
    41aa:	892a                	mv	s2,a0
    if(pid < 0){
    41ac:	f80543e3          	bltz	a0,4132 <concreate+0x19a>
    if(((i % 3) == 0 && pid == 0) ||
    41b0:	03448733          	mul	a4,s1,s4
    41b4:	9301                	srli	a4,a4,0x20
    41b6:	41f4d79b          	sraiw	a5,s1,0x1f
    41ba:	9f1d                	subw	a4,a4,a5
    41bc:	0017179b          	slliw	a5,a4,0x1
    41c0:	9fb9                	addw	a5,a5,a4
    41c2:	40f487bb          	subw	a5,s1,a5
    41c6:	00a7e733          	or	a4,a5,a0
    41ca:	2701                	sext.w	a4,a4
    41cc:	df2d                	beqz	a4,4146 <concreate+0x1ae>
       ((i % 3) == 1 && pid != 0)){
    41ce:	c119                	beqz	a0,41d4 <concreate+0x23c>
    if(((i % 3) == 0 && pid == 0) ||
    41d0:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    41d2:	dbb5                	beqz	a5,4146 <concreate+0x1ae>
      unlink(file);
    41d4:	854e                	mv	a0,s3
    41d6:	573000ef          	jal	4f48 <unlink>
      unlink(file);
    41da:	854e                	mv	a0,s3
    41dc:	56d000ef          	jal	4f48 <unlink>
      unlink(file);
    41e0:	854e                	mv	a0,s3
    41e2:	567000ef          	jal	4f48 <unlink>
      unlink(file);
    41e6:	854e                	mv	a0,s3
    41e8:	561000ef          	jal	4f48 <unlink>
      unlink(file);
    41ec:	854e                	mv	a0,s3
    41ee:	55b000ef          	jal	4f48 <unlink>
      unlink(file);
    41f2:	854e                	mv	a0,s3
    41f4:	555000ef          	jal	4f48 <unlink>
    41f8:	bf59                	j	418e <concreate+0x1f6>
      exit(0);
    41fa:	4501                	li	a0,0
    41fc:	4fd000ef          	jal	4ef8 <exit>
      close(fd);
    4200:	521000ef          	jal	4f20 <close>
    if(pid == 0) {
    4204:	b5a1                	j	404c <concreate+0xb4>
      close(fd);
    4206:	51b000ef          	jal	4f20 <close>
      wait(&xstatus);
    420a:	8556                	mv	a0,s5
    420c:	4f5000ef          	jal	4f00 <wait>
      if(xstatus != 0)
    4210:	f5c42483          	lw	s1,-164(s0)
    4214:	e2049fe3          	bnez	s1,4052 <concreate+0xba>
  for(i = 0; i < N; i++){
    4218:	2905                	addiw	s2,s2,1
    421a:	e3490fe3          	beq	s2,s4,4058 <concreate+0xc0>
    file[1] = '0' + i;
    421e:	0309079b          	addiw	a5,s2,48
    4222:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4226:	854e                	mv	a0,s3
    4228:	521000ef          	jal	4f48 <unlink>
    pid = fork();
    422c:	4c5000ef          	jal	4ef0 <fork>
    if(pid && (i % 3) == 1){
    4230:	dc0501e3          	beqz	a0,3ff2 <concreate+0x5a>
    4234:	036907b3          	mul	a5,s2,s6
    4238:	9381                	srli	a5,a5,0x20
    423a:	41f9571b          	sraiw	a4,s2,0x1f
    423e:	9f99                	subw	a5,a5,a4
    4240:	0017971b          	slliw	a4,a5,0x1
    4244:	9fb9                	addw	a5,a5,a4
    4246:	40f907bb          	subw	a5,s2,a5
    424a:	d9778fe3          	beq	a5,s7,3fe8 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    424e:	85e2                	mv	a1,s8
    4250:	854e                	mv	a0,s3
    4252:	4e7000ef          	jal	4f38 <open>
      if(fd < 0){
    4256:	fa0558e3          	bgez	a0,4206 <concreate+0x26e>
    425a:	b3f1                	j	4026 <concreate+0x8e>
}
    425c:	70aa                	ld	ra,168(sp)
    425e:	740a                	ld	s0,160(sp)
    4260:	64ea                	ld	s1,152(sp)
    4262:	694a                	ld	s2,144(sp)
    4264:	69aa                	ld	s3,136(sp)
    4266:	6a0a                	ld	s4,128(sp)
    4268:	7ae6                	ld	s5,120(sp)
    426a:	7b46                	ld	s6,112(sp)
    426c:	7ba6                	ld	s7,104(sp)
    426e:	7c06                	ld	s8,96(sp)
    4270:	6ce6                	ld	s9,88(sp)
    4272:	6d46                	ld	s10,80(sp)
    4274:	614d                	addi	sp,sp,176
    4276:	8082                	ret

0000000000004278 <bigfile>:
{
    4278:	7139                	addi	sp,sp,-64
    427a:	fc06                	sd	ra,56(sp)
    427c:	f822                	sd	s0,48(sp)
    427e:	f426                	sd	s1,40(sp)
    4280:	f04a                	sd	s2,32(sp)
    4282:	ec4e                	sd	s3,24(sp)
    4284:	e852                	sd	s4,16(sp)
    4286:	e456                	sd	s5,8(sp)
    4288:	e05a                	sd	s6,0(sp)
    428a:	0080                	addi	s0,sp,64
    428c:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    428e:	00003517          	auipc	a0,0x3
    4292:	fca50513          	addi	a0,a0,-54 # 7258 <malloc+0x1e5c>
    4296:	4b3000ef          	jal	4f48 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    429a:	20200593          	li	a1,514
    429e:	00003517          	auipc	a0,0x3
    42a2:	fba50513          	addi	a0,a0,-70 # 7258 <malloc+0x1e5c>
    42a6:	493000ef          	jal	4f38 <open>
  if(fd < 0){
    42aa:	08054a63          	bltz	a0,433e <bigfile+0xc6>
    42ae:	8a2a                	mv	s4,a0
    42b0:	4481                	li	s1,0
    memset(buf, i, SZ);
    42b2:	25800913          	li	s2,600
    42b6:	00008997          	auipc	s3,0x8
    42ba:	9f298993          	addi	s3,s3,-1550 # bca8 <buf>
  for(i = 0; i < N; i++){
    42be:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42c0:	864a                	mv	a2,s2
    42c2:	85a6                	mv	a1,s1
    42c4:	854e                	mv	a0,s3
    42c6:	209000ef          	jal	4cce <memset>
    if(write(fd, buf, SZ) != SZ){
    42ca:	864a                	mv	a2,s2
    42cc:	85ce                	mv	a1,s3
    42ce:	8552                	mv	a0,s4
    42d0:	449000ef          	jal	4f18 <write>
    42d4:	07251f63          	bne	a0,s2,4352 <bigfile+0xda>
  for(i = 0; i < N; i++){
    42d8:	2485                	addiw	s1,s1,1
    42da:	ff5493e3          	bne	s1,s5,42c0 <bigfile+0x48>
  close(fd);
    42de:	8552                	mv	a0,s4
    42e0:	441000ef          	jal	4f20 <close>
  fd = open("bigfile.dat", 0);
    42e4:	4581                	li	a1,0
    42e6:	00003517          	auipc	a0,0x3
    42ea:	f7250513          	addi	a0,a0,-142 # 7258 <malloc+0x1e5c>
    42ee:	44b000ef          	jal	4f38 <open>
    42f2:	8aaa                	mv	s5,a0
  total = 0;
    42f4:	4a01                	li	s4,0
  for(i = 0; ; i++){
    42f6:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    42f8:	12c00993          	li	s3,300
    42fc:	00008917          	auipc	s2,0x8
    4300:	9ac90913          	addi	s2,s2,-1620 # bca8 <buf>
  if(fd < 0){
    4304:	06054163          	bltz	a0,4366 <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    4308:	864e                	mv	a2,s3
    430a:	85ca                	mv	a1,s2
    430c:	8556                	mv	a0,s5
    430e:	403000ef          	jal	4f10 <read>
    if(cc < 0){
    4312:	06054463          	bltz	a0,437a <bigfile+0x102>
    if(cc == 0)
    4316:	c145                	beqz	a0,43b6 <bigfile+0x13e>
    if(cc != SZ/2){
    4318:	07351b63          	bne	a0,s3,438e <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    431c:	01f4d79b          	srliw	a5,s1,0x1f
    4320:	9fa5                	addw	a5,a5,s1
    4322:	4017d79b          	sraiw	a5,a5,0x1
    4326:	00094703          	lbu	a4,0(s2)
    432a:	06f71c63          	bne	a4,a5,43a2 <bigfile+0x12a>
    432e:	12b94703          	lbu	a4,299(s2)
    4332:	06f71863          	bne	a4,a5,43a2 <bigfile+0x12a>
    total += cc;
    4336:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    433a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    433c:	b7f1                	j	4308 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    433e:	85da                	mv	a1,s6
    4340:	00003517          	auipc	a0,0x3
    4344:	f2850513          	addi	a0,a0,-216 # 7268 <malloc+0x1e6c>
    4348:	7fd000ef          	jal	5344 <printf>
    exit(1);
    434c:	4505                	li	a0,1
    434e:	3ab000ef          	jal	4ef8 <exit>
      printf("%s: write bigfile failed\n", s);
    4352:	85da                	mv	a1,s6
    4354:	00003517          	auipc	a0,0x3
    4358:	f3450513          	addi	a0,a0,-204 # 7288 <malloc+0x1e8c>
    435c:	7e9000ef          	jal	5344 <printf>
      exit(1);
    4360:	4505                	li	a0,1
    4362:	397000ef          	jal	4ef8 <exit>
    printf("%s: cannot open bigfile\n", s);
    4366:	85da                	mv	a1,s6
    4368:	00003517          	auipc	a0,0x3
    436c:	f4050513          	addi	a0,a0,-192 # 72a8 <malloc+0x1eac>
    4370:	7d5000ef          	jal	5344 <printf>
    exit(1);
    4374:	4505                	li	a0,1
    4376:	383000ef          	jal	4ef8 <exit>
      printf("%s: read bigfile failed\n", s);
    437a:	85da                	mv	a1,s6
    437c:	00003517          	auipc	a0,0x3
    4380:	f4c50513          	addi	a0,a0,-180 # 72c8 <malloc+0x1ecc>
    4384:	7c1000ef          	jal	5344 <printf>
      exit(1);
    4388:	4505                	li	a0,1
    438a:	36f000ef          	jal	4ef8 <exit>
      printf("%s: short read bigfile\n", s);
    438e:	85da                	mv	a1,s6
    4390:	00003517          	auipc	a0,0x3
    4394:	f5850513          	addi	a0,a0,-168 # 72e8 <malloc+0x1eec>
    4398:	7ad000ef          	jal	5344 <printf>
      exit(1);
    439c:	4505                	li	a0,1
    439e:	35b000ef          	jal	4ef8 <exit>
      printf("%s: read bigfile wrong data\n", s);
    43a2:	85da                	mv	a1,s6
    43a4:	00003517          	auipc	a0,0x3
    43a8:	f5c50513          	addi	a0,a0,-164 # 7300 <malloc+0x1f04>
    43ac:	799000ef          	jal	5344 <printf>
      exit(1);
    43b0:	4505                	li	a0,1
    43b2:	347000ef          	jal	4ef8 <exit>
  close(fd);
    43b6:	8556                	mv	a0,s5
    43b8:	369000ef          	jal	4f20 <close>
  if(total != N*SZ){
    43bc:	678d                	lui	a5,0x3
    43be:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1e0>
    43c2:	02fa1263          	bne	s4,a5,43e6 <bigfile+0x16e>
  unlink("bigfile.dat");
    43c6:	00003517          	auipc	a0,0x3
    43ca:	e9250513          	addi	a0,a0,-366 # 7258 <malloc+0x1e5c>
    43ce:	37b000ef          	jal	4f48 <unlink>
}
    43d2:	70e2                	ld	ra,56(sp)
    43d4:	7442                	ld	s0,48(sp)
    43d6:	74a2                	ld	s1,40(sp)
    43d8:	7902                	ld	s2,32(sp)
    43da:	69e2                	ld	s3,24(sp)
    43dc:	6a42                	ld	s4,16(sp)
    43de:	6aa2                	ld	s5,8(sp)
    43e0:	6b02                	ld	s6,0(sp)
    43e2:	6121                	addi	sp,sp,64
    43e4:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    43e6:	85da                	mv	a1,s6
    43e8:	00003517          	auipc	a0,0x3
    43ec:	f3850513          	addi	a0,a0,-200 # 7320 <malloc+0x1f24>
    43f0:	755000ef          	jal	5344 <printf>
    exit(1);
    43f4:	4505                	li	a0,1
    43f6:	303000ef          	jal	4ef8 <exit>

00000000000043fa <bigargtest>:
{
    43fa:	7121                	addi	sp,sp,-448
    43fc:	ff06                	sd	ra,440(sp)
    43fe:	fb22                	sd	s0,432(sp)
    4400:	f726                	sd	s1,424(sp)
    4402:	0380                	addi	s0,sp,448
    4404:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4406:	00003517          	auipc	a0,0x3
    440a:	f3a50513          	addi	a0,a0,-198 # 7340 <malloc+0x1f44>
    440e:	33b000ef          	jal	4f48 <unlink>
  pid = fork();
    4412:	2df000ef          	jal	4ef0 <fork>
  if(pid == 0){
    4416:	c915                	beqz	a0,444a <bigargtest+0x50>
  } else if(pid < 0){
    4418:	08054c63          	bltz	a0,44b0 <bigargtest+0xb6>
  wait(&xstatus);
    441c:	fdc40513          	addi	a0,s0,-36
    4420:	2e1000ef          	jal	4f00 <wait>
  if(xstatus != 0)
    4424:	fdc42503          	lw	a0,-36(s0)
    4428:	ed51                	bnez	a0,44c4 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    442a:	4581                	li	a1,0
    442c:	00003517          	auipc	a0,0x3
    4430:	f1450513          	addi	a0,a0,-236 # 7340 <malloc+0x1f44>
    4434:	305000ef          	jal	4f38 <open>
  if(fd < 0){
    4438:	08054863          	bltz	a0,44c8 <bigargtest+0xce>
  close(fd);
    443c:	2e5000ef          	jal	4f20 <close>
}
    4440:	70fa                	ld	ra,440(sp)
    4442:	745a                	ld	s0,432(sp)
    4444:	74ba                	ld	s1,424(sp)
    4446:	6139                	addi	sp,sp,448
    4448:	8082                	ret
    memset(big, ' ', sizeof(big));
    444a:	19000613          	li	a2,400
    444e:	02000593          	li	a1,32
    4452:	e4840513          	addi	a0,s0,-440
    4456:	079000ef          	jal	4cce <memset>
    big[sizeof(big)-1] = '\0';
    445a:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    445e:	00004797          	auipc	a5,0x4
    4462:	03278793          	addi	a5,a5,50 # 8490 <args.1>
    4466:	00004697          	auipc	a3,0x4
    446a:	12268693          	addi	a3,a3,290 # 8588 <args.1+0xf8>
      args[i] = big;
    446e:	e4840713          	addi	a4,s0,-440
    4472:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4474:	07a1                	addi	a5,a5,8
    4476:	fed79ee3          	bne	a5,a3,4472 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    447a:	00004797          	auipc	a5,0x4
    447e:	1007b723          	sd	zero,270(a5) # 8588 <args.1+0xf8>
    exec("echo", args);
    4482:	00004597          	auipc	a1,0x4
    4486:	00e58593          	addi	a1,a1,14 # 8490 <args.1>
    448a:	00001517          	auipc	a0,0x1
    448e:	09e50513          	addi	a0,a0,158 # 5528 <malloc+0x12c>
    4492:	29f000ef          	jal	4f30 <exec>
    fd = open("bigarg-ok", O_CREATE);
    4496:	20000593          	li	a1,512
    449a:	00003517          	auipc	a0,0x3
    449e:	ea650513          	addi	a0,a0,-346 # 7340 <malloc+0x1f44>
    44a2:	297000ef          	jal	4f38 <open>
    close(fd);
    44a6:	27b000ef          	jal	4f20 <close>
    exit(0);
    44aa:	4501                	li	a0,0
    44ac:	24d000ef          	jal	4ef8 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44b0:	85a6                	mv	a1,s1
    44b2:	00003517          	auipc	a0,0x3
    44b6:	e9e50513          	addi	a0,a0,-354 # 7350 <malloc+0x1f54>
    44ba:	68b000ef          	jal	5344 <printf>
    exit(1);
    44be:	4505                	li	a0,1
    44c0:	239000ef          	jal	4ef8 <exit>
    exit(xstatus);
    44c4:	235000ef          	jal	4ef8 <exit>
    printf("%s: bigarg test failed!\n", s);
    44c8:	85a6                	mv	a1,s1
    44ca:	00003517          	auipc	a0,0x3
    44ce:	ea650513          	addi	a0,a0,-346 # 7370 <malloc+0x1f74>
    44d2:	673000ef          	jal	5344 <printf>
    exit(1);
    44d6:	4505                	li	a0,1
    44d8:	221000ef          	jal	4ef8 <exit>

00000000000044dc <lazy_alloc>:
{
    44dc:	1141                	addi	sp,sp,-16
    44de:	e406                	sd	ra,8(sp)
    44e0:	e022                	sd	s0,0(sp)
    44e2:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    44e4:	40000537          	lui	a0,0x40000
    44e8:	1f3000ef          	jal	4eda <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    44ec:	57fd                	li	a5,-1
    44ee:	02f50a63          	beq	a0,a5,4522 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    44f2:	6605                	lui	a2,0x1
    44f4:	962a                	add	a2,a2,a0
    44f6:	400017b7          	lui	a5,0x40001
    44fa:	00f50733          	add	a4,a0,a5
    44fe:	87b2                	mv	a5,a2
    4500:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4504:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4506:	97b6                	add	a5,a5,a3
    4508:	fee79ee3          	bne	a5,a4,4504 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    450c:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4510:	621c                	ld	a5,0(a2)
    4512:	02c79163          	bne	a5,a2,4534 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4516:	9636                	add	a2,a2,a3
    4518:	fee61ce3          	bne	a2,a4,4510 <lazy_alloc+0x34>
  exit(0);
    451c:	4501                	li	a0,0
    451e:	1db000ef          	jal	4ef8 <exit>
    printf("sbrklazy() failed\n");
    4522:	00003517          	auipc	a0,0x3
    4526:	e6e50513          	addi	a0,a0,-402 # 7390 <malloc+0x1f94>
    452a:	61b000ef          	jal	5344 <printf>
    exit(1);
    452e:	4505                	li	a0,1
    4530:	1c9000ef          	jal	4ef8 <exit>
      printf("failed to read value from memory\n");
    4534:	00003517          	auipc	a0,0x3
    4538:	e7450513          	addi	a0,a0,-396 # 73a8 <malloc+0x1fac>
    453c:	609000ef          	jal	5344 <printf>
      exit(1);
    4540:	4505                	li	a0,1
    4542:	1b7000ef          	jal	4ef8 <exit>

0000000000004546 <lazy_unmap>:
{
    4546:	7139                	addi	sp,sp,-64
    4548:	fc06                	sd	ra,56(sp)
    454a:	f822                	sd	s0,48(sp)
    454c:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    454e:	40000537          	lui	a0,0x40000
    4552:	189000ef          	jal	4eda <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4556:	57fd                	li	a5,-1
    4558:	04f50863          	beq	a0,a5,45a8 <lazy_unmap+0x62>
    455c:	f426                	sd	s1,40(sp)
    455e:	f04a                	sd	s2,32(sp)
    4560:	ec4e                	sd	s3,24(sp)
    4562:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4564:	6905                	lui	s2,0x1
    4566:	992a                	add	s2,s2,a0
    4568:	400017b7          	lui	a5,0x40001
    456c:	00f504b3          	add	s1,a0,a5
    4570:	87ca                	mv	a5,s2
    4572:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4576:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4578:	97ba                	add	a5,a5,a4
    457a:	fe979ee3          	bne	a5,s1,4576 <lazy_unmap+0x30>
      wait(&status);
    457e:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4582:	01000a37          	lui	s4,0x1000
    pid = fork();
    4586:	16b000ef          	jal	4ef0 <fork>
    if (pid < 0) {
    458a:	02054c63          	bltz	a0,45c2 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    458e:	c139                	beqz	a0,45d4 <lazy_unmap+0x8e>
      wait(&status);
    4590:	854e                	mv	a0,s3
    4592:	16f000ef          	jal	4f00 <wait>
      if (status == 0) {
    4596:	fcc42783          	lw	a5,-52(s0)
    459a:	c7b1                	beqz	a5,45e6 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    459c:	9952                	add	s2,s2,s4
    459e:	fe9914e3          	bne	s2,s1,4586 <lazy_unmap+0x40>
  exit(0);
    45a2:	4501                	li	a0,0
    45a4:	155000ef          	jal	4ef8 <exit>
    45a8:	f426                	sd	s1,40(sp)
    45aa:	f04a                	sd	s2,32(sp)
    45ac:	ec4e                	sd	s3,24(sp)
    45ae:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    45b0:	00003517          	auipc	a0,0x3
    45b4:	de050513          	addi	a0,a0,-544 # 7390 <malloc+0x1f94>
    45b8:	58d000ef          	jal	5344 <printf>
    exit(1);
    45bc:	4505                	li	a0,1
    45be:	13b000ef          	jal	4ef8 <exit>
      printf("error forking\n");
    45c2:	00003517          	auipc	a0,0x3
    45c6:	e0e50513          	addi	a0,a0,-498 # 73d0 <malloc+0x1fd4>
    45ca:	57b000ef          	jal	5344 <printf>
      exit(1);
    45ce:	4505                	li	a0,1
    45d0:	129000ef          	jal	4ef8 <exit>
      sbrklazy(-1L * REGION_SZ);
    45d4:	c0000537          	lui	a0,0xc0000
    45d8:	103000ef          	jal	4eda <sbrklazy>
      *(char **)i = i;
    45dc:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    45e0:	4501                	li	a0,0
    45e2:	117000ef          	jal	4ef8 <exit>
        printf("memory not unmapped\n");
    45e6:	00003517          	auipc	a0,0x3
    45ea:	dfa50513          	addi	a0,a0,-518 # 73e0 <malloc+0x1fe4>
    45ee:	557000ef          	jal	5344 <printf>
        exit(1);
    45f2:	4505                	li	a0,1
    45f4:	105000ef          	jal	4ef8 <exit>

00000000000045f8 <lazy_copy>:
{
    45f8:	7119                	addi	sp,sp,-128
    45fa:	fc86                	sd	ra,120(sp)
    45fc:	f8a2                	sd	s0,112(sp)
    45fe:	f4a6                	sd	s1,104(sp)
    4600:	f0ca                	sd	s2,96(sp)
    4602:	ecce                	sd	s3,88(sp)
    4604:	e8d2                	sd	s4,80(sp)
    4606:	e4d6                	sd	s5,72(sp)
    4608:	e0da                	sd	s6,64(sp)
    460a:	fc5e                	sd	s7,56(sp)
    460c:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    460e:	4501                	li	a0,0
    4610:	0b5000ef          	jal	4ec4 <sbrk>
    4614:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    4616:	6511                	lui	a0,0x4
    4618:	0c3000ef          	jal	4eda <sbrklazy>
    open(p + 8192, 0);
    461c:	4581                	li	a1,0
    461e:	6509                	lui	a0,0x2
    4620:	9526                	add	a0,a0,s1
    4622:	117000ef          	jal	4f38 <open>
    void *xx = sbrk(0);
    4626:	4501                	li	a0,0
    4628:	09d000ef          	jal	4ec4 <sbrk>
    462c:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    462e:	fff54513          	not	a0,a0
    4632:	2501                	sext.w	a0,a0
    4634:	091000ef          	jal	4ec4 <sbrk>
    if(ret != xx){
    4638:	00a48c63          	beq	s1,a0,4650 <lazy_copy+0x58>
    463c:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    463e:	00003517          	auipc	a0,0x3
    4642:	dba50513          	addi	a0,a0,-582 # 73f8 <malloc+0x1ffc>
    4646:	4ff000ef          	jal	5344 <printf>
      exit(1);
    464a:	4505                	li	a0,1
    464c:	0ad000ef          	jal	4ef8 <exit>
  unsigned long bad[] = {
    4650:	00003797          	auipc	a5,0x3
    4654:	32878793          	addi	a5,a5,808 # 7978 <malloc+0x257c>
    4658:	7fa8                	ld	a0,120(a5)
    465a:	63cc                	ld	a1,128(a5)
    465c:	67d0                	ld	a2,136(a5)
    465e:	6bd4                	ld	a3,144(a5)
    4660:	6fd8                	ld	a4,152(a5)
    4662:	f8a43023          	sd	a0,-128(s0)
    4666:	f8b43423          	sd	a1,-120(s0)
    466a:	f8c43823          	sd	a2,-112(s0)
    466e:	f8d43c23          	sd	a3,-104(s0)
    4672:	fae43023          	sd	a4,-96(s0)
    4676:	73dc                	ld	a5,160(a5)
    4678:	faf43423          	sd	a5,-88(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    467c:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4680:	00001a97          	auipc	s5,0x1
    4684:	080a8a93          	addi	s5,s5,128 # 5700 <malloc+0x304>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4688:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    468c:	60200b93          	li	s7,1538
    4690:	00001b17          	auipc	s6,0x1
    4694:	f80b0b13          	addi	s6,s6,-128 # 5610 <malloc+0x214>
    int fd = open("README", 0);
    4698:	4581                	li	a1,0
    469a:	8556                	mv	a0,s5
    469c:	09d000ef          	jal	4f38 <open>
    46a0:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46a2:	04054563          	bltz	a0,46ec <lazy_copy+0xf4>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    46a6:	00093983          	ld	s3,0(s2)
    46aa:	8652                	mv	a2,s4
    46ac:	85ce                	mv	a1,s3
    46ae:	063000ef          	jal	4f10 <read>
    46b2:	04055663          	bgez	a0,46fe <lazy_copy+0x106>
    close(fd);
    46b6:	8526                	mv	a0,s1
    46b8:	069000ef          	jal	4f20 <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    46bc:	85de                	mv	a1,s7
    46be:	855a                	mv	a0,s6
    46c0:	079000ef          	jal	4f38 <open>
    46c4:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    46c6:	04054563          	bltz	a0,4710 <lazy_copy+0x118>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    46ca:	8652                	mv	a2,s4
    46cc:	85ce                	mv	a1,s3
    46ce:	04b000ef          	jal	4f18 <write>
    46d2:	04055863          	bgez	a0,4722 <lazy_copy+0x12a>
    close(fd);
    46d6:	8526                	mv	a0,s1
    46d8:	049000ef          	jal	4f20 <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    46dc:	0921                	addi	s2,s2,8
    46de:	fb040793          	addi	a5,s0,-80
    46e2:	faf91be3          	bne	s2,a5,4698 <lazy_copy+0xa0>
  exit(0);
    46e6:	4501                	li	a0,0
    46e8:	011000ef          	jal	4ef8 <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46ec:	00003517          	auipc	a0,0x3
    46f0:	d3c50513          	addi	a0,a0,-708 # 7428 <malloc+0x202c>
    46f4:	451000ef          	jal	5344 <printf>
    46f8:	4505                	li	a0,1
    46fa:	7fe000ef          	jal	4ef8 <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    46fe:	00003517          	auipc	a0,0x3
    4702:	d4250513          	addi	a0,a0,-702 # 7440 <malloc+0x2044>
    4706:	43f000ef          	jal	5344 <printf>
    470a:	4505                	li	a0,1
    470c:	7ec000ef          	jal	4ef8 <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4710:	00003517          	auipc	a0,0x3
    4714:	d4050513          	addi	a0,a0,-704 # 7450 <malloc+0x2054>
    4718:	42d000ef          	jal	5344 <printf>
    471c:	4505                	li	a0,1
    471e:	7da000ef          	jal	4ef8 <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4722:	00003517          	auipc	a0,0x3
    4726:	d4650513          	addi	a0,a0,-698 # 7468 <malloc+0x206c>
    472a:	41b000ef          	jal	5344 <printf>
    472e:	4505                	li	a0,1
    4730:	7c8000ef          	jal	4ef8 <exit>

0000000000004734 <fsfull>:
{
    4734:	7171                	addi	sp,sp,-176
    4736:	f506                	sd	ra,168(sp)
    4738:	f122                	sd	s0,160(sp)
    473a:	ed26                	sd	s1,152(sp)
    473c:	e94a                	sd	s2,144(sp)
    473e:	e54e                	sd	s3,136(sp)
    4740:	e152                	sd	s4,128(sp)
    4742:	fcd6                	sd	s5,120(sp)
    4744:	f8da                	sd	s6,112(sp)
    4746:	f4de                	sd	s7,104(sp)
    4748:	f0e2                	sd	s8,96(sp)
    474a:	ece6                	sd	s9,88(sp)
    474c:	e8ea                	sd	s10,80(sp)
    474e:	e4ee                	sd	s11,72(sp)
    4750:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4752:	00003517          	auipc	a0,0x3
    4756:	d2e50513          	addi	a0,a0,-722 # 7480 <malloc+0x2084>
    475a:	3eb000ef          	jal	5344 <printf>
  for(nfiles = 0; ; nfiles++){
    475e:	4481                	li	s1,0
    name[0] = 'f';
    4760:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4764:	10625cb7          	lui	s9,0x10625
    4768:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061612b>
    name[2] = '0' + (nfiles % 1000) / 100;
    476c:	51eb8ab7          	lui	s5,0x51eb8
    4770:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea9877>
    name[3] = '0' + (nfiles % 100) / 10;
    4774:	66666a37          	lui	s4,0x66666
    4778:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666579bf>
    printf("writing %s\n", name);
    477c:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4780:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4784:	039487b3          	mul	a5,s1,s9
    4788:	9799                	srai	a5,a5,0x26
    478a:	41f4d69b          	sraiw	a3,s1,0x1f
    478e:	9f95                	subw	a5,a5,a3
    4790:	0307871b          	addiw	a4,a5,48
    4794:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4798:	3e800713          	li	a4,1000
    479c:	02f707bb          	mulw	a5,a4,a5
    47a0:	40f487bb          	subw	a5,s1,a5
    47a4:	03578733          	mul	a4,a5,s5
    47a8:	9715                	srai	a4,a4,0x25
    47aa:	41f7d79b          	sraiw	a5,a5,0x1f
    47ae:	40f707bb          	subw	a5,a4,a5
    47b2:	0307879b          	addiw	a5,a5,48
    47b6:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    47ba:	035487b3          	mul	a5,s1,s5
    47be:	9795                	srai	a5,a5,0x25
    47c0:	9f95                	subw	a5,a5,a3
    47c2:	06400713          	li	a4,100
    47c6:	02f707bb          	mulw	a5,a4,a5
    47ca:	40f487bb          	subw	a5,s1,a5
    47ce:	03478733          	mul	a4,a5,s4
    47d2:	9709                	srai	a4,a4,0x22
    47d4:	41f7d79b          	sraiw	a5,a5,0x1f
    47d8:	40f707bb          	subw	a5,a4,a5
    47dc:	0307879b          	addiw	a5,a5,48
    47e0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    47e4:	03448733          	mul	a4,s1,s4
    47e8:	9709                	srai	a4,a4,0x22
    47ea:	9f15                	subw	a4,a4,a3
    47ec:	0027179b          	slliw	a5,a4,0x2
    47f0:	9fb9                	addw	a5,a5,a4
    47f2:	0017979b          	slliw	a5,a5,0x1
    47f6:	40f487bb          	subw	a5,s1,a5
    47fa:	0307879b          	addiw	a5,a5,48
    47fe:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4802:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4806:	85ea                	mv	a1,s10
    4808:	00003517          	auipc	a0,0x3
    480c:	c8850513          	addi	a0,a0,-888 # 7490 <malloc+0x2094>
    4810:	335000ef          	jal	5344 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4814:	20200593          	li	a1,514
    4818:	856a                	mv	a0,s10
    481a:	71e000ef          	jal	4f38 <open>
    481e:	892a                	mv	s2,a0
    if(fd < 0){
    4820:	0e055b63          	bgez	a0,4916 <fsfull+0x1e2>
      printf("open %s failed\n", name);
    4824:	f5040593          	addi	a1,s0,-176
    4828:	00003517          	auipc	a0,0x3
    482c:	c7850513          	addi	a0,a0,-904 # 74a0 <malloc+0x20a4>
    4830:	315000ef          	jal	5344 <printf>
  while(nfiles >= 0){
    4834:	0a04cc63          	bltz	s1,48ec <fsfull+0x1b8>
    name[0] = 'f';
    4838:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    483c:	10625a37          	lui	s4,0x10625
    4840:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061612b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4844:	3e800b93          	li	s7,1000
    4848:	51eb89b7          	lui	s3,0x51eb8
    484c:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea9877>
    name[3] = '0' + (nfiles % 100) / 10;
    4850:	06400b13          	li	s6,100
    4854:	66666937          	lui	s2,0x66666
    4858:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666579bf>
    unlink(name);
    485c:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    4860:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4864:	034487b3          	mul	a5,s1,s4
    4868:	9799                	srai	a5,a5,0x26
    486a:	41f4d69b          	sraiw	a3,s1,0x1f
    486e:	9f95                	subw	a5,a5,a3
    4870:	0307871b          	addiw	a4,a5,48
    4874:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4878:	02fb87bb          	mulw	a5,s7,a5
    487c:	40f487bb          	subw	a5,s1,a5
    4880:	03378733          	mul	a4,a5,s3
    4884:	9715                	srai	a4,a4,0x25
    4886:	41f7d79b          	sraiw	a5,a5,0x1f
    488a:	40f707bb          	subw	a5,a4,a5
    488e:	0307879b          	addiw	a5,a5,48
    4892:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4896:	033487b3          	mul	a5,s1,s3
    489a:	9795                	srai	a5,a5,0x25
    489c:	9f95                	subw	a5,a5,a3
    489e:	02fb07bb          	mulw	a5,s6,a5
    48a2:	40f487bb          	subw	a5,s1,a5
    48a6:	03278733          	mul	a4,a5,s2
    48aa:	9709                	srai	a4,a4,0x22
    48ac:	41f7d79b          	sraiw	a5,a5,0x1f
    48b0:	40f707bb          	subw	a5,a4,a5
    48b4:	0307879b          	addiw	a5,a5,48
    48b8:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    48bc:	03248733          	mul	a4,s1,s2
    48c0:	9709                	srai	a4,a4,0x22
    48c2:	9f15                	subw	a4,a4,a3
    48c4:	0027179b          	slliw	a5,a4,0x2
    48c8:	9fb9                	addw	a5,a5,a4
    48ca:	0017979b          	slliw	a5,a5,0x1
    48ce:	40f487bb          	subw	a5,s1,a5
    48d2:	0307879b          	addiw	a5,a5,48
    48d6:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    48da:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    48de:	8556                	mv	a0,s5
    48e0:	668000ef          	jal	4f48 <unlink>
    nfiles--;
    48e4:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    48e6:	57fd                	li	a5,-1
    48e8:	f6f49ce3          	bne	s1,a5,4860 <fsfull+0x12c>
  printf("fsfull test finished\n");
    48ec:	00003517          	auipc	a0,0x3
    48f0:	bd450513          	addi	a0,a0,-1068 # 74c0 <malloc+0x20c4>
    48f4:	251000ef          	jal	5344 <printf>
}
    48f8:	70aa                	ld	ra,168(sp)
    48fa:	740a                	ld	s0,160(sp)
    48fc:	64ea                	ld	s1,152(sp)
    48fe:	694a                	ld	s2,144(sp)
    4900:	69aa                	ld	s3,136(sp)
    4902:	6a0a                	ld	s4,128(sp)
    4904:	7ae6                	ld	s5,120(sp)
    4906:	7b46                	ld	s6,112(sp)
    4908:	7ba6                	ld	s7,104(sp)
    490a:	7c06                	ld	s8,96(sp)
    490c:	6ce6                	ld	s9,88(sp)
    490e:	6d46                	ld	s10,80(sp)
    4910:	6da6                	ld	s11,72(sp)
    4912:	614d                	addi	sp,sp,176
    4914:	8082                	ret
    int total = 0;
    4916:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4918:	40000c13          	li	s8,1024
    491c:	00007b97          	auipc	s7,0x7
    4920:	38cb8b93          	addi	s7,s7,908 # bca8 <buf>
      if(cc < BSIZE)
    4924:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    4928:	8662                	mv	a2,s8
    492a:	85de                	mv	a1,s7
    492c:	854a                	mv	a0,s2
    492e:	5ea000ef          	jal	4f18 <write>
      if(cc < BSIZE)
    4932:	00ab5563          	bge	s6,a0,493c <fsfull+0x208>
      total += cc;
    4936:	00a989bb          	addw	s3,s3,a0
    while(1){
    493a:	b7fd                	j	4928 <fsfull+0x1f4>
    printf("wrote %d bytes\n", total);
    493c:	85ce                	mv	a1,s3
    493e:	00003517          	auipc	a0,0x3
    4942:	b7250513          	addi	a0,a0,-1166 # 74b0 <malloc+0x20b4>
    4946:	1ff000ef          	jal	5344 <printf>
    close(fd);
    494a:	854a                	mv	a0,s2
    494c:	5d4000ef          	jal	4f20 <close>
    if(total == 0)
    4950:	ee0982e3          	beqz	s3,4834 <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    4954:	2485                	addiw	s1,s1,1
    4956:	b52d                	j	4780 <fsfull+0x4c>

0000000000004958 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4958:	7179                	addi	sp,sp,-48
    495a:	f406                	sd	ra,40(sp)
    495c:	f022                	sd	s0,32(sp)
    495e:	ec26                	sd	s1,24(sp)
    4960:	e84a                	sd	s2,16(sp)
    4962:	1800                	addi	s0,sp,48
    4964:	84aa                	mv	s1,a0
    4966:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4968:	00003517          	auipc	a0,0x3
    496c:	b7050513          	addi	a0,a0,-1168 # 74d8 <malloc+0x20dc>
    4970:	1d5000ef          	jal	5344 <printf>
  if((pid = fork()) < 0) {
    4974:	57c000ef          	jal	4ef0 <fork>
    4978:	02054a63          	bltz	a0,49ac <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    497c:	c129                	beqz	a0,49be <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    497e:	fdc40513          	addi	a0,s0,-36
    4982:	57e000ef          	jal	4f00 <wait>
    if(xstatus != 0) 
    4986:	fdc42783          	lw	a5,-36(s0)
    498a:	cf9d                	beqz	a5,49c8 <run+0x70>
      printf("FAILED\n");
    498c:	00003517          	auipc	a0,0x3
    4990:	b7450513          	addi	a0,a0,-1164 # 7500 <malloc+0x2104>
    4994:	1b1000ef          	jal	5344 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4998:	fdc42503          	lw	a0,-36(s0)
  }
}
    499c:	00153513          	seqz	a0,a0
    49a0:	70a2                	ld	ra,40(sp)
    49a2:	7402                	ld	s0,32(sp)
    49a4:	64e2                	ld	s1,24(sp)
    49a6:	6942                	ld	s2,16(sp)
    49a8:	6145                	addi	sp,sp,48
    49aa:	8082                	ret
    printf("runtest: fork error\n");
    49ac:	00003517          	auipc	a0,0x3
    49b0:	b3c50513          	addi	a0,a0,-1220 # 74e8 <malloc+0x20ec>
    49b4:	191000ef          	jal	5344 <printf>
    exit(1);
    49b8:	4505                	li	a0,1
    49ba:	53e000ef          	jal	4ef8 <exit>
    f(s);
    49be:	854a                	mv	a0,s2
    49c0:	9482                	jalr	s1
    exit(0);
    49c2:	4501                	li	a0,0
    49c4:	534000ef          	jal	4ef8 <exit>
      printf("OK\n");
    49c8:	00003517          	auipc	a0,0x3
    49cc:	b4050513          	addi	a0,a0,-1216 # 7508 <malloc+0x210c>
    49d0:	175000ef          	jal	5344 <printf>
    49d4:	b7d1                	j	4998 <run+0x40>

00000000000049d6 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    49d6:	7179                	addi	sp,sp,-48
    49d8:	f406                	sd	ra,40(sp)
    49da:	f022                	sd	s0,32(sp)
    49dc:	ec26                	sd	s1,24(sp)
    49de:	e44e                	sd	s3,8(sp)
    49e0:	1800                	addi	s0,sp,48
    49e2:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    49e4:	6508                	ld	a0,8(a0)
    49e6:	cd29                	beqz	a0,4a40 <runtests+0x6a>
    49e8:	e84a                	sd	s2,16(sp)
    49ea:	e052                	sd	s4,0(sp)
    49ec:	892e                	mv	s2,a1
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    49ee:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    49f0:	00c03a33          	snez	s4,a2
  int ntests = 0;
    49f4:	4981                	li	s3,0
    49f6:	a029                	j	4a00 <runtests+0x2a>
      ntests++;
    49f8:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    49fa:	04c1                	addi	s1,s1,16
    49fc:	6488                	ld	a0,8(s1)
    49fe:	c905                	beqz	a0,4a2e <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4a00:	00090663          	beqz	s2,4a0c <runtests+0x36>
    4a04:	85ca                	mv	a1,s2
    4a06:	26c000ef          	jal	4c72 <strcmp>
    4a0a:	f965                	bnez	a0,49fa <runtests+0x24>
      if(!run(t->f, t->s)){
    4a0c:	648c                	ld	a1,8(s1)
    4a0e:	6088                	ld	a0,0(s1)
    4a10:	f49ff0ef          	jal	4958 <run>
        if(continuous != 2){
    4a14:	f175                	bnez	a0,49f8 <runtests+0x22>
    4a16:	fe0a01e3          	beqz	s4,49f8 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4a1a:	00003517          	auipc	a0,0x3
    4a1e:	af650513          	addi	a0,a0,-1290 # 7510 <malloc+0x2114>
    4a22:	123000ef          	jal	5344 <printf>
          return -1;
    4a26:	59fd                	li	s3,-1
    4a28:	6942                	ld	s2,16(sp)
    4a2a:	6a02                	ld	s4,0(sp)
    4a2c:	a019                	j	4a32 <runtests+0x5c>
    4a2e:	6942                	ld	s2,16(sp)
    4a30:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    4a32:	854e                	mv	a0,s3
    4a34:	70a2                	ld	ra,40(sp)
    4a36:	7402                	ld	s0,32(sp)
    4a38:	64e2                	ld	s1,24(sp)
    4a3a:	69a2                	ld	s3,8(sp)
    4a3c:	6145                	addi	sp,sp,48
    4a3e:	8082                	ret
  return ntests;
    4a40:	4981                	li	s3,0
    4a42:	bfc5                	j	4a32 <runtests+0x5c>

0000000000004a44 <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4a44:	7179                	addi	sp,sp,-48
    4a46:	f406                	sd	ra,40(sp)
    4a48:	f022                	sd	s0,32(sp)
    4a4a:	ec26                	sd	s1,24(sp)
    4a4c:	e84a                	sd	s2,16(sp)
    4a4e:	e44e                	sd	s3,8(sp)
    4a50:	e052                	sd	s4,0(sp)
    4a52:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4a54:	4501                	li	a0,0
    4a56:	46e000ef          	jal	4ec4 <sbrk>
    4a5a:	8a2a                	mv	s4,a0
  int n = 0;
    4a5c:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    4a5e:	6985                	lui	s3,0x1
    if(a == SBRK_ERROR){
    4a60:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    4a62:	854e                	mv	a0,s3
    4a64:	460000ef          	jal	4ec4 <sbrk>
    if(a == SBRK_ERROR){
    4a68:	01250463          	beq	a0,s2,4a70 <countfree+0x2c>
      break;
    }
    n += 1;
    4a6c:	2485                	addiw	s1,s1,1
  while(1){
    4a6e:	bfd5                	j	4a62 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    4a70:	4501                	li	a0,0
    4a72:	452000ef          	jal	4ec4 <sbrk>
    4a76:	40aa053b          	subw	a0,s4,a0
    4a7a:	44a000ef          	jal	4ec4 <sbrk>
  return n;
}
    4a7e:	8526                	mv	a0,s1
    4a80:	70a2                	ld	ra,40(sp)
    4a82:	7402                	ld	s0,32(sp)
    4a84:	64e2                	ld	s1,24(sp)
    4a86:	6942                	ld	s2,16(sp)
    4a88:	69a2                	ld	s3,8(sp)
    4a8a:	6a02                	ld	s4,0(sp)
    4a8c:	6145                	addi	sp,sp,48
    4a8e:	8082                	ret

0000000000004a90 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4a90:	7159                	addi	sp,sp,-112
    4a92:	f486                	sd	ra,104(sp)
    4a94:	f0a2                	sd	s0,96(sp)
    4a96:	eca6                	sd	s1,88(sp)
    4a98:	e8ca                	sd	s2,80(sp)
    4a9a:	e4ce                	sd	s3,72(sp)
    4a9c:	e0d2                	sd	s4,64(sp)
    4a9e:	fc56                	sd	s5,56(sp)
    4aa0:	f85a                	sd	s6,48(sp)
    4aa2:	f45e                	sd	s7,40(sp)
    4aa4:	f062                	sd	s8,32(sp)
    4aa6:	ec66                	sd	s9,24(sp)
    4aa8:	e86a                	sd	s10,16(sp)
    4aaa:	e46e                	sd	s11,8(sp)
    4aac:	1880                	addi	s0,sp,112
    4aae:	8aaa                	mv	s5,a0
    4ab0:	89ae                	mv	s3,a1
    4ab2:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4ab4:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    4ab8:	00003c17          	auipc	s8,0x3
    4abc:	a70c0c13          	addi	s8,s8,-1424 # 7528 <malloc+0x212c>
    n = runtests(quicktests, justone, continuous);
    4ac0:	00003b97          	auipc	s7,0x3
    4ac4:	550b8b93          	addi	s7,s7,1360 # 8010 <quicktests>
      if(continuous != 2) {
    4ac8:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    4aca:	00004c97          	auipc	s9,0x4
    4ace:	946c8c93          	addi	s9,s9,-1722 # 8410 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4ad2:	00003d97          	auipc	s11,0x3
    4ad6:	a8ed8d93          	addi	s11,s11,-1394 # 7560 <malloc+0x2164>
    4ada:	a82d                	j	4b14 <drivetests+0x84>
      if(continuous != 2) {
    4adc:	0b699363          	bne	s3,s6,4b82 <drivetests+0xf2>
    int ntests = 0;
    4ae0:	4481                	li	s1,0
    4ae2:	a0b9                	j	4b30 <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    4ae4:	00003517          	auipc	a0,0x3
    4ae8:	a5c50513          	addi	a0,a0,-1444 # 7540 <malloc+0x2144>
    4aec:	059000ef          	jal	5344 <printf>
    4af0:	a0a1                	j	4b38 <drivetests+0xa8>
        if(continuous != 2) {
    4af2:	05698b63          	beq	s3,s6,4b48 <drivetests+0xb8>
          return 1;
    4af6:	4505                	li	a0,1
    4af8:	a0b5                	j	4b64 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4afa:	864a                	mv	a2,s2
    4afc:	85aa                	mv	a1,a0
    4afe:	856e                	mv	a0,s11
    4b00:	045000ef          	jal	5344 <printf>
      if(continuous != 2) {
    4b04:	09699163          	bne	s3,s6,4b86 <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    4b08:	e491                	bnez	s1,4b14 <drivetests+0x84>
    4b0a:	000d0563          	beqz	s10,4b14 <drivetests+0x84>
    4b0e:	a0a1                	j	4b56 <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    4b10:	06098d63          	beqz	s3,4b8a <drivetests+0xfa>
    printf("usertests starting\n");
    4b14:	8562                	mv	a0,s8
    4b16:	02f000ef          	jal	5344 <printf>
    int free0 = countfree();
    4b1a:	f2bff0ef          	jal	4a44 <countfree>
    4b1e:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4b20:	864e                	mv	a2,s3
    4b22:	85d2                	mv	a1,s4
    4b24:	855e                	mv	a0,s7
    4b26:	eb1ff0ef          	jal	49d6 <runtests>
    4b2a:	84aa                	mv	s1,a0
    if (n < 0) {
    4b2c:	fa0548e3          	bltz	a0,4adc <drivetests+0x4c>
    if(!quick) {
    4b30:	000a9c63          	bnez	s5,4b48 <drivetests+0xb8>
      if (justone == 0)
    4b34:	fa0a08e3          	beqz	s4,4ae4 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    4b38:	864e                	mv	a2,s3
    4b3a:	85d2                	mv	a1,s4
    4b3c:	8566                	mv	a0,s9
    4b3e:	e99ff0ef          	jal	49d6 <runtests>
      if (n < 0) {
    4b42:	fa0548e3          	bltz	a0,4af2 <drivetests+0x62>
        ntests += n;
    4b46:	9ca9                	addw	s1,s1,a0
    if((free1 = countfree()) < free0) {
    4b48:	efdff0ef          	jal	4a44 <countfree>
    4b4c:	fb2547e3          	blt	a0,s2,4afa <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    4b50:	f0e1                	bnez	s1,4b10 <drivetests+0x80>
    4b52:	fa0d0fe3          	beqz	s10,4b10 <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    4b56:	00003517          	auipc	a0,0x3
    4b5a:	a3a50513          	addi	a0,a0,-1478 # 7590 <malloc+0x2194>
    4b5e:	7e6000ef          	jal	5344 <printf>
      return 1;
    4b62:	4505                	li	a0,1
  return 0;
}
    4b64:	70a6                	ld	ra,104(sp)
    4b66:	7406                	ld	s0,96(sp)
    4b68:	64e6                	ld	s1,88(sp)
    4b6a:	6946                	ld	s2,80(sp)
    4b6c:	69a6                	ld	s3,72(sp)
    4b6e:	6a06                	ld	s4,64(sp)
    4b70:	7ae2                	ld	s5,56(sp)
    4b72:	7b42                	ld	s6,48(sp)
    4b74:	7ba2                	ld	s7,40(sp)
    4b76:	7c02                	ld	s8,32(sp)
    4b78:	6ce2                	ld	s9,24(sp)
    4b7a:	6d42                	ld	s10,16(sp)
    4b7c:	6da2                	ld	s11,8(sp)
    4b7e:	6165                	addi	sp,sp,112
    4b80:	8082                	ret
        return 1;
    4b82:	4505                	li	a0,1
    4b84:	b7c5                	j	4b64 <drivetests+0xd4>
        return 1;
    4b86:	4505                	li	a0,1
    4b88:	bff1                	j	4b64 <drivetests+0xd4>
  return 0;
    4b8a:	854e                	mv	a0,s3
    4b8c:	bfe1                	j	4b64 <drivetests+0xd4>

0000000000004b8e <main>:

int
main(int argc, char *argv[])
{
    4b8e:	1101                	addi	sp,sp,-32
    4b90:	ec06                	sd	ra,24(sp)
    4b92:	e822                	sd	s0,16(sp)
    4b94:	e426                	sd	s1,8(sp)
    4b96:	e04a                	sd	s2,0(sp)
    4b98:	1000                	addi	s0,sp,32
    4b9a:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4b9c:	4789                	li	a5,2
    4b9e:	00f50e63          	beq	a0,a5,4bba <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4ba2:	4785                	li	a5,1
    4ba4:	06a7c663          	blt	a5,a0,4c10 <main+0x82>
  char *justone = 0;
    4ba8:	4601                	li	a2,0
  int quick = 0;
    4baa:	4501                	li	a0,0
  int continuous = 0;
    4bac:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4bae:	ee3ff0ef          	jal	4a90 <drivetests>
    4bb2:	cd35                	beqz	a0,4c2e <main+0xa0>
    exit(1);
    4bb4:	4505                	li	a0,1
    4bb6:	342000ef          	jal	4ef8 <exit>
    4bba:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4bbc:	00003597          	auipc	a1,0x3
    4bc0:	9ec58593          	addi	a1,a1,-1556 # 75a8 <malloc+0x21ac>
    4bc4:	00893503          	ld	a0,8(s2)
    4bc8:	0aa000ef          	jal	4c72 <strcmp>
    4bcc:	85aa                	mv	a1,a0
    4bce:	e501                	bnez	a0,4bd6 <main+0x48>
  char *justone = 0;
    4bd0:	4601                	li	a2,0
    quick = 1;
    4bd2:	4505                	li	a0,1
    4bd4:	bfe9                	j	4bae <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4bd6:	00003597          	auipc	a1,0x3
    4bda:	9da58593          	addi	a1,a1,-1574 # 75b0 <malloc+0x21b4>
    4bde:	00893503          	ld	a0,8(s2)
    4be2:	090000ef          	jal	4c72 <strcmp>
    4be6:	cd15                	beqz	a0,4c22 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4be8:	00003597          	auipc	a1,0x3
    4bec:	a1858593          	addi	a1,a1,-1512 # 7600 <malloc+0x2204>
    4bf0:	00893503          	ld	a0,8(s2)
    4bf4:	07e000ef          	jal	4c72 <strcmp>
    4bf8:	c905                	beqz	a0,4c28 <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    4bfa:	00893603          	ld	a2,8(s2)
    4bfe:	00064703          	lbu	a4,0(a2)
    4c02:	02d00793          	li	a5,45
    4c06:	00f70563          	beq	a4,a5,4c10 <main+0x82>
  int quick = 0;
    4c0a:	4501                	li	a0,0
  int continuous = 0;
    4c0c:	4581                	li	a1,0
    4c0e:	b745                	j	4bae <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4c10:	00003517          	auipc	a0,0x3
    4c14:	9a850513          	addi	a0,a0,-1624 # 75b8 <malloc+0x21bc>
    4c18:	72c000ef          	jal	5344 <printf>
    exit(1);
    4c1c:	4505                	li	a0,1
    4c1e:	2da000ef          	jal	4ef8 <exit>
  char *justone = 0;
    4c22:	4601                	li	a2,0
    continuous = 1;
    4c24:	4585                	li	a1,1
    4c26:	b761                	j	4bae <main+0x20>
    continuous = 2;
    4c28:	85a6                	mv	a1,s1
  char *justone = 0;
    4c2a:	4601                	li	a2,0
    4c2c:	b749                	j	4bae <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4c2e:	00003517          	auipc	a0,0x3
    4c32:	9ba50513          	addi	a0,a0,-1606 # 75e8 <malloc+0x21ec>
    4c36:	70e000ef          	jal	5344 <printf>
  exit(0);
    4c3a:	4501                	li	a0,0
    4c3c:	2bc000ef          	jal	4ef8 <exit>

0000000000004c40 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    4c40:	1141                	addi	sp,sp,-16
    4c42:	e406                	sd	ra,8(sp)
    4c44:	e022                	sd	s0,0(sp)
    4c46:	0800                	addi	s0,sp,16
  extern int main();
  main();
    4c48:	f47ff0ef          	jal	4b8e <main>
  exit(0);
    4c4c:	4501                	li	a0,0
    4c4e:	2aa000ef          	jal	4ef8 <exit>

0000000000004c52 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4c52:	1141                	addi	sp,sp,-16
    4c54:	e406                	sd	ra,8(sp)
    4c56:	e022                	sd	s0,0(sp)
    4c58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4c5a:	87aa                	mv	a5,a0
    4c5c:	0585                	addi	a1,a1,1
    4c5e:	0785                	addi	a5,a5,1
    4c60:	fff5c703          	lbu	a4,-1(a1)
    4c64:	fee78fa3          	sb	a4,-1(a5)
    4c68:	fb75                	bnez	a4,4c5c <strcpy+0xa>
    ;
  return os;
}
    4c6a:	60a2                	ld	ra,8(sp)
    4c6c:	6402                	ld	s0,0(sp)
    4c6e:	0141                	addi	sp,sp,16
    4c70:	8082                	ret

0000000000004c72 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4c72:	1141                	addi	sp,sp,-16
    4c74:	e406                	sd	ra,8(sp)
    4c76:	e022                	sd	s0,0(sp)
    4c78:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4c7a:	00054783          	lbu	a5,0(a0)
    4c7e:	cb91                	beqz	a5,4c92 <strcmp+0x20>
    4c80:	0005c703          	lbu	a4,0(a1)
    4c84:	00f71763          	bne	a4,a5,4c92 <strcmp+0x20>
    p++, q++;
    4c88:	0505                	addi	a0,a0,1
    4c8a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4c8c:	00054783          	lbu	a5,0(a0)
    4c90:	fbe5                	bnez	a5,4c80 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4c92:	0005c503          	lbu	a0,0(a1)
}
    4c96:	40a7853b          	subw	a0,a5,a0
    4c9a:	60a2                	ld	ra,8(sp)
    4c9c:	6402                	ld	s0,0(sp)
    4c9e:	0141                	addi	sp,sp,16
    4ca0:	8082                	ret

0000000000004ca2 <strlen>:

uint
strlen(const char *s)
{
    4ca2:	1141                	addi	sp,sp,-16
    4ca4:	e406                	sd	ra,8(sp)
    4ca6:	e022                	sd	s0,0(sp)
    4ca8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4caa:	00054783          	lbu	a5,0(a0)
    4cae:	cf91                	beqz	a5,4cca <strlen+0x28>
    4cb0:	00150793          	addi	a5,a0,1
    4cb4:	86be                	mv	a3,a5
    4cb6:	0785                	addi	a5,a5,1
    4cb8:	fff7c703          	lbu	a4,-1(a5)
    4cbc:	ff65                	bnez	a4,4cb4 <strlen+0x12>
    4cbe:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4cc2:	60a2                	ld	ra,8(sp)
    4cc4:	6402                	ld	s0,0(sp)
    4cc6:	0141                	addi	sp,sp,16
    4cc8:	8082                	ret
  for(n = 0; s[n]; n++)
    4cca:	4501                	li	a0,0
    4ccc:	bfdd                	j	4cc2 <strlen+0x20>

0000000000004cce <memset>:

void*
memset(void *dst, int c, uint n)
{
    4cce:	1141                	addi	sp,sp,-16
    4cd0:	e406                	sd	ra,8(sp)
    4cd2:	e022                	sd	s0,0(sp)
    4cd4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4cd6:	ca19                	beqz	a2,4cec <memset+0x1e>
    4cd8:	87aa                	mv	a5,a0
    4cda:	1602                	slli	a2,a2,0x20
    4cdc:	9201                	srli	a2,a2,0x20
    4cde:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4ce2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4ce6:	0785                	addi	a5,a5,1
    4ce8:	fee79de3          	bne	a5,a4,4ce2 <memset+0x14>
  }
  return dst;
}
    4cec:	60a2                	ld	ra,8(sp)
    4cee:	6402                	ld	s0,0(sp)
    4cf0:	0141                	addi	sp,sp,16
    4cf2:	8082                	ret

0000000000004cf4 <strchr>:

char*
strchr(const char *s, char c)
{
    4cf4:	1141                	addi	sp,sp,-16
    4cf6:	e406                	sd	ra,8(sp)
    4cf8:	e022                	sd	s0,0(sp)
    4cfa:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4cfc:	00054783          	lbu	a5,0(a0)
    4d00:	cf81                	beqz	a5,4d18 <strchr+0x24>
    if(*s == c)
    4d02:	00f58763          	beq	a1,a5,4d10 <strchr+0x1c>
  for(; *s; s++)
    4d06:	0505                	addi	a0,a0,1
    4d08:	00054783          	lbu	a5,0(a0)
    4d0c:	fbfd                	bnez	a5,4d02 <strchr+0xe>
      return (char*)s;
  return 0;
    4d0e:	4501                	li	a0,0
}
    4d10:	60a2                	ld	ra,8(sp)
    4d12:	6402                	ld	s0,0(sp)
    4d14:	0141                	addi	sp,sp,16
    4d16:	8082                	ret
  return 0;
    4d18:	4501                	li	a0,0
    4d1a:	bfdd                	j	4d10 <strchr+0x1c>

0000000000004d1c <gets>:

char*
gets(char *buf, int max)
{
    4d1c:	711d                	addi	sp,sp,-96
    4d1e:	ec86                	sd	ra,88(sp)
    4d20:	e8a2                	sd	s0,80(sp)
    4d22:	e4a6                	sd	s1,72(sp)
    4d24:	e0ca                	sd	s2,64(sp)
    4d26:	fc4e                	sd	s3,56(sp)
    4d28:	f852                	sd	s4,48(sp)
    4d2a:	f456                	sd	s5,40(sp)
    4d2c:	f05a                	sd	s6,32(sp)
    4d2e:	ec5e                	sd	s7,24(sp)
    4d30:	e862                	sd	s8,16(sp)
    4d32:	1080                	addi	s0,sp,96
    4d34:	8baa                	mv	s7,a0
    4d36:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4d38:	892a                	mv	s2,a0
    4d3a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4d3c:	faf40b13          	addi	s6,s0,-81
    4d40:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    4d42:	8c26                	mv	s8,s1
    4d44:	0014899b          	addiw	s3,s1,1
    4d48:	84ce                	mv	s1,s3
    4d4a:	0349d463          	bge	s3,s4,4d72 <gets+0x56>
    cc = read(0, &c, 1);
    4d4e:	8656                	mv	a2,s5
    4d50:	85da                	mv	a1,s6
    4d52:	4501                	li	a0,0
    4d54:	1bc000ef          	jal	4f10 <read>
    if(cc < 1)
    4d58:	00a05d63          	blez	a0,4d72 <gets+0x56>
      break;
    buf[i++] = c;
    4d5c:	faf44783          	lbu	a5,-81(s0)
    4d60:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4d64:	0905                	addi	s2,s2,1
    4d66:	ff678713          	addi	a4,a5,-10
    4d6a:	c319                	beqz	a4,4d70 <gets+0x54>
    4d6c:	17cd                	addi	a5,a5,-13
    4d6e:	fbf1                	bnez	a5,4d42 <gets+0x26>
    buf[i++] = c;
    4d70:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4d72:	9c5e                	add	s8,s8,s7
    4d74:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4d78:	855e                	mv	a0,s7
    4d7a:	60e6                	ld	ra,88(sp)
    4d7c:	6446                	ld	s0,80(sp)
    4d7e:	64a6                	ld	s1,72(sp)
    4d80:	6906                	ld	s2,64(sp)
    4d82:	79e2                	ld	s3,56(sp)
    4d84:	7a42                	ld	s4,48(sp)
    4d86:	7aa2                	ld	s5,40(sp)
    4d88:	7b02                	ld	s6,32(sp)
    4d8a:	6be2                	ld	s7,24(sp)
    4d8c:	6c42                	ld	s8,16(sp)
    4d8e:	6125                	addi	sp,sp,96
    4d90:	8082                	ret

0000000000004d92 <stat>:

int
stat(const char *n, struct stat *st)
{
    4d92:	1101                	addi	sp,sp,-32
    4d94:	ec06                	sd	ra,24(sp)
    4d96:	e822                	sd	s0,16(sp)
    4d98:	e04a                	sd	s2,0(sp)
    4d9a:	1000                	addi	s0,sp,32
    4d9c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4d9e:	4581                	li	a1,0
    4da0:	198000ef          	jal	4f38 <open>
  if(fd < 0)
    4da4:	02054263          	bltz	a0,4dc8 <stat+0x36>
    4da8:	e426                	sd	s1,8(sp)
    4daa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4dac:	85ca                	mv	a1,s2
    4dae:	1a2000ef          	jal	4f50 <fstat>
    4db2:	892a                	mv	s2,a0
  close(fd);
    4db4:	8526                	mv	a0,s1
    4db6:	16a000ef          	jal	4f20 <close>
  return r;
    4dba:	64a2                	ld	s1,8(sp)
}
    4dbc:	854a                	mv	a0,s2
    4dbe:	60e2                	ld	ra,24(sp)
    4dc0:	6442                	ld	s0,16(sp)
    4dc2:	6902                	ld	s2,0(sp)
    4dc4:	6105                	addi	sp,sp,32
    4dc6:	8082                	ret
    return -1;
    4dc8:	57fd                	li	a5,-1
    4dca:	893e                	mv	s2,a5
    4dcc:	bfc5                	j	4dbc <stat+0x2a>

0000000000004dce <atoi>:

int
atoi(const char *s)
{
    4dce:	1141                	addi	sp,sp,-16
    4dd0:	e406                	sd	ra,8(sp)
    4dd2:	e022                	sd	s0,0(sp)
    4dd4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4dd6:	00054683          	lbu	a3,0(a0)
    4dda:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x31328>
    4dde:	0ff7f793          	zext.b	a5,a5
    4de2:	4625                	li	a2,9
    4de4:	02f66963          	bltu	a2,a5,4e16 <atoi+0x48>
    4de8:	872a                	mv	a4,a0
  n = 0;
    4dea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4dec:	0705                	addi	a4,a4,1 # 1000001 <base+0xff1359>
    4dee:	0025179b          	slliw	a5,a0,0x2
    4df2:	9fa9                	addw	a5,a5,a0
    4df4:	0017979b          	slliw	a5,a5,0x1
    4df8:	9fb5                	addw	a5,a5,a3
    4dfa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4dfe:	00074683          	lbu	a3,0(a4)
    4e02:	fd06879b          	addiw	a5,a3,-48
    4e06:	0ff7f793          	zext.b	a5,a5
    4e0a:	fef671e3          	bgeu	a2,a5,4dec <atoi+0x1e>
  return n;
}
    4e0e:	60a2                	ld	ra,8(sp)
    4e10:	6402                	ld	s0,0(sp)
    4e12:	0141                	addi	sp,sp,16
    4e14:	8082                	ret
  n = 0;
    4e16:	4501                	li	a0,0
    4e18:	bfdd                	j	4e0e <atoi+0x40>

0000000000004e1a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4e1a:	1141                	addi	sp,sp,-16
    4e1c:	e406                	sd	ra,8(sp)
    4e1e:	e022                	sd	s0,0(sp)
    4e20:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4e22:	02b57563          	bgeu	a0,a1,4e4c <memmove+0x32>
    while(n-- > 0)
    4e26:	00c05f63          	blez	a2,4e44 <memmove+0x2a>
    4e2a:	1602                	slli	a2,a2,0x20
    4e2c:	9201                	srli	a2,a2,0x20
    4e2e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4e32:	872a                	mv	a4,a0
      *dst++ = *src++;
    4e34:	0585                	addi	a1,a1,1
    4e36:	0705                	addi	a4,a4,1
    4e38:	fff5c683          	lbu	a3,-1(a1)
    4e3c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4e40:	fee79ae3          	bne	a5,a4,4e34 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4e44:	60a2                	ld	ra,8(sp)
    4e46:	6402                	ld	s0,0(sp)
    4e48:	0141                	addi	sp,sp,16
    4e4a:	8082                	ret
    while(n-- > 0)
    4e4c:	fec05ce3          	blez	a2,4e44 <memmove+0x2a>
    dst += n;
    4e50:	00c50733          	add	a4,a0,a2
    src += n;
    4e54:	95b2                	add	a1,a1,a2
    4e56:	fff6079b          	addiw	a5,a2,-1
    4e5a:	1782                	slli	a5,a5,0x20
    4e5c:	9381                	srli	a5,a5,0x20
    4e5e:	fff7c793          	not	a5,a5
    4e62:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4e64:	15fd                	addi	a1,a1,-1
    4e66:	177d                	addi	a4,a4,-1
    4e68:	0005c683          	lbu	a3,0(a1)
    4e6c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4e70:	fef71ae3          	bne	a4,a5,4e64 <memmove+0x4a>
    4e74:	bfc1                	j	4e44 <memmove+0x2a>

0000000000004e76 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4e76:	1141                	addi	sp,sp,-16
    4e78:	e406                	sd	ra,8(sp)
    4e7a:	e022                	sd	s0,0(sp)
    4e7c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4e7e:	c61d                	beqz	a2,4eac <memcmp+0x36>
    4e80:	1602                	slli	a2,a2,0x20
    4e82:	9201                	srli	a2,a2,0x20
    4e84:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    4e88:	00054783          	lbu	a5,0(a0)
    4e8c:	0005c703          	lbu	a4,0(a1)
    4e90:	00e79863          	bne	a5,a4,4ea0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    4e94:	0505                	addi	a0,a0,1
    p2++;
    4e96:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4e98:	fed518e3          	bne	a0,a3,4e88 <memcmp+0x12>
  }
  return 0;
    4e9c:	4501                	li	a0,0
    4e9e:	a019                	j	4ea4 <memcmp+0x2e>
      return *p1 - *p2;
    4ea0:	40e7853b          	subw	a0,a5,a4
}
    4ea4:	60a2                	ld	ra,8(sp)
    4ea6:	6402                	ld	s0,0(sp)
    4ea8:	0141                	addi	sp,sp,16
    4eaa:	8082                	ret
  return 0;
    4eac:	4501                	li	a0,0
    4eae:	bfdd                	j	4ea4 <memcmp+0x2e>

0000000000004eb0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4eb0:	1141                	addi	sp,sp,-16
    4eb2:	e406                	sd	ra,8(sp)
    4eb4:	e022                	sd	s0,0(sp)
    4eb6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4eb8:	f63ff0ef          	jal	4e1a <memmove>
}
    4ebc:	60a2                	ld	ra,8(sp)
    4ebe:	6402                	ld	s0,0(sp)
    4ec0:	0141                	addi	sp,sp,16
    4ec2:	8082                	ret

0000000000004ec4 <sbrk>:

char *
sbrk(int n) {
    4ec4:	1141                	addi	sp,sp,-16
    4ec6:	e406                	sd	ra,8(sp)
    4ec8:	e022                	sd	s0,0(sp)
    4eca:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4ecc:	4585                	li	a1,1
    4ece:	0b2000ef          	jal	4f80 <sys_sbrk>
}
    4ed2:	60a2                	ld	ra,8(sp)
    4ed4:	6402                	ld	s0,0(sp)
    4ed6:	0141                	addi	sp,sp,16
    4ed8:	8082                	ret

0000000000004eda <sbrklazy>:

char *
sbrklazy(int n) {
    4eda:	1141                	addi	sp,sp,-16
    4edc:	e406                	sd	ra,8(sp)
    4ede:	e022                	sd	s0,0(sp)
    4ee0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4ee2:	4589                	li	a1,2
    4ee4:	09c000ef          	jal	4f80 <sys_sbrk>
}
    4ee8:	60a2                	ld	ra,8(sp)
    4eea:	6402                	ld	s0,0(sp)
    4eec:	0141                	addi	sp,sp,16
    4eee:	8082                	ret

0000000000004ef0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4ef0:	4885                	li	a7,1
 ecall
    4ef2:	00000073          	ecall
 ret
    4ef6:	8082                	ret

0000000000004ef8 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4ef8:	4889                	li	a7,2
 ecall
    4efa:	00000073          	ecall
 ret
    4efe:	8082                	ret

0000000000004f00 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4f00:	488d                	li	a7,3
 ecall
    4f02:	00000073          	ecall
 ret
    4f06:	8082                	ret

0000000000004f08 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4f08:	4891                	li	a7,4
 ecall
    4f0a:	00000073          	ecall
 ret
    4f0e:	8082                	ret

0000000000004f10 <read>:
.global read
read:
 li a7, SYS_read
    4f10:	4895                	li	a7,5
 ecall
    4f12:	00000073          	ecall
 ret
    4f16:	8082                	ret

0000000000004f18 <write>:
.global write
write:
 li a7, SYS_write
    4f18:	48c1                	li	a7,16
 ecall
    4f1a:	00000073          	ecall
 ret
    4f1e:	8082                	ret

0000000000004f20 <close>:
.global close
close:
 li a7, SYS_close
    4f20:	48d5                	li	a7,21
 ecall
    4f22:	00000073          	ecall
 ret
    4f26:	8082                	ret

0000000000004f28 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4f28:	4899                	li	a7,6
 ecall
    4f2a:	00000073          	ecall
 ret
    4f2e:	8082                	ret

0000000000004f30 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4f30:	489d                	li	a7,7
 ecall
    4f32:	00000073          	ecall
 ret
    4f36:	8082                	ret

0000000000004f38 <open>:
.global open
open:
 li a7, SYS_open
    4f38:	48bd                	li	a7,15
 ecall
    4f3a:	00000073          	ecall
 ret
    4f3e:	8082                	ret

0000000000004f40 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4f40:	48c5                	li	a7,17
 ecall
    4f42:	00000073          	ecall
 ret
    4f46:	8082                	ret

0000000000004f48 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4f48:	48c9                	li	a7,18
 ecall
    4f4a:	00000073          	ecall
 ret
    4f4e:	8082                	ret

0000000000004f50 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4f50:	48a1                	li	a7,8
 ecall
    4f52:	00000073          	ecall
 ret
    4f56:	8082                	ret

0000000000004f58 <link>:
.global link
link:
 li a7, SYS_link
    4f58:	48cd                	li	a7,19
 ecall
    4f5a:	00000073          	ecall
 ret
    4f5e:	8082                	ret

0000000000004f60 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4f60:	48d1                	li	a7,20
 ecall
    4f62:	00000073          	ecall
 ret
    4f66:	8082                	ret

0000000000004f68 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4f68:	48a5                	li	a7,9
 ecall
    4f6a:	00000073          	ecall
 ret
    4f6e:	8082                	ret

0000000000004f70 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4f70:	48a9                	li	a7,10
 ecall
    4f72:	00000073          	ecall
 ret
    4f76:	8082                	ret

0000000000004f78 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4f78:	48ad                	li	a7,11
 ecall
    4f7a:	00000073          	ecall
 ret
    4f7e:	8082                	ret

0000000000004f80 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4f80:	48b1                	li	a7,12
 ecall
    4f82:	00000073          	ecall
 ret
    4f86:	8082                	ret

0000000000004f88 <pause>:
.global pause
pause:
 li a7, SYS_pause
    4f88:	48b5                	li	a7,13
 ecall
    4f8a:	00000073          	ecall
 ret
    4f8e:	8082                	ret

0000000000004f90 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4f90:	48b9                	li	a7,14
 ecall
    4f92:	00000073          	ecall
 ret
    4f96:	8082                	ret

0000000000004f98 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4f98:	1101                	addi	sp,sp,-32
    4f9a:	ec06                	sd	ra,24(sp)
    4f9c:	e822                	sd	s0,16(sp)
    4f9e:	1000                	addi	s0,sp,32
    4fa0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4fa4:	4605                	li	a2,1
    4fa6:	fef40593          	addi	a1,s0,-17
    4faa:	f6fff0ef          	jal	4f18 <write>
}
    4fae:	60e2                	ld	ra,24(sp)
    4fb0:	6442                	ld	s0,16(sp)
    4fb2:	6105                	addi	sp,sp,32
    4fb4:	8082                	ret

0000000000004fb6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4fb6:	715d                	addi	sp,sp,-80
    4fb8:	e486                	sd	ra,72(sp)
    4fba:	e0a2                	sd	s0,64(sp)
    4fbc:	f84a                	sd	s2,48(sp)
    4fbe:	f44e                	sd	s3,40(sp)
    4fc0:	0880                	addi	s0,sp,80
    4fc2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4fc4:	cac1                	beqz	a3,5054 <printint+0x9e>
    4fc6:	0805d763          	bgez	a1,5054 <printint+0x9e>
    neg = 1;
    x = -xx;
    4fca:	40b005bb          	negw	a1,a1
    neg = 1;
    4fce:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    4fd0:	fb840993          	addi	s3,s0,-72
  neg = 0;
    4fd4:	86ce                	mv	a3,s3
  i = 0;
    4fd6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4fd8:	00003817          	auipc	a6,0x3
    4fdc:	a4880813          	addi	a6,a6,-1464 # 7a20 <digits>
    4fe0:	88ba                	mv	a7,a4
    4fe2:	0017051b          	addiw	a0,a4,1
    4fe6:	872a                	mv	a4,a0
    4fe8:	02c5f7bb          	remuw	a5,a1,a2
    4fec:	1782                	slli	a5,a5,0x20
    4fee:	9381                	srli	a5,a5,0x20
    4ff0:	97c2                	add	a5,a5,a6
    4ff2:	0007c783          	lbu	a5,0(a5)
    4ff6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4ffa:	87ae                	mv	a5,a1
    4ffc:	02c5d5bb          	divuw	a1,a1,a2
    5000:	0685                	addi	a3,a3,1
    5002:	fcc7ffe3          	bgeu	a5,a2,4fe0 <printint+0x2a>
  if(neg)
    5006:	00030c63          	beqz	t1,501e <printint+0x68>
    buf[i++] = '-';
    500a:	fd050793          	addi	a5,a0,-48
    500e:	00878533          	add	a0,a5,s0
    5012:	02d00793          	li	a5,45
    5016:	fef50423          	sb	a5,-24(a0)
    501a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    501e:	02e05563          	blez	a4,5048 <printint+0x92>
    5022:	fc26                	sd	s1,56(sp)
    5024:	377d                	addiw	a4,a4,-1
    5026:	00e984b3          	add	s1,s3,a4
    502a:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    502c:	99ba                	add	s3,s3,a4
    502e:	1702                	slli	a4,a4,0x20
    5030:	9301                	srli	a4,a4,0x20
    5032:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5036:	0004c583          	lbu	a1,0(s1)
    503a:	854a                	mv	a0,s2
    503c:	f5dff0ef          	jal	4f98 <putc>
  while(--i >= 0)
    5040:	14fd                	addi	s1,s1,-1
    5042:	ff349ae3          	bne	s1,s3,5036 <printint+0x80>
    5046:	74e2                	ld	s1,56(sp)
}
    5048:	60a6                	ld	ra,72(sp)
    504a:	6406                	ld	s0,64(sp)
    504c:	7942                	ld	s2,48(sp)
    504e:	79a2                	ld	s3,40(sp)
    5050:	6161                	addi	sp,sp,80
    5052:	8082                	ret
    x = xx;
    5054:	2581                	sext.w	a1,a1
  neg = 0;
    5056:	4301                	li	t1,0
    5058:	bfa5                	j	4fd0 <printint+0x1a>

000000000000505a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    505a:	711d                	addi	sp,sp,-96
    505c:	ec86                	sd	ra,88(sp)
    505e:	e8a2                	sd	s0,80(sp)
    5060:	e4a6                	sd	s1,72(sp)
    5062:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5064:	0005c483          	lbu	s1,0(a1)
    5068:	22048363          	beqz	s1,528e <vprintf+0x234>
    506c:	e0ca                	sd	s2,64(sp)
    506e:	fc4e                	sd	s3,56(sp)
    5070:	f852                	sd	s4,48(sp)
    5072:	f456                	sd	s5,40(sp)
    5074:	f05a                	sd	s6,32(sp)
    5076:	ec5e                	sd	s7,24(sp)
    5078:	e862                	sd	s8,16(sp)
    507a:	8b2a                	mv	s6,a0
    507c:	8a2e                	mv	s4,a1
    507e:	8bb2                	mv	s7,a2
  state = 0;
    5080:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    5082:	4901                	li	s2,0
    5084:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    5086:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    508a:	06400c13          	li	s8,100
    508e:	a00d                	j	50b0 <vprintf+0x56>
        putc(fd, c0);
    5090:	85a6                	mv	a1,s1
    5092:	855a                	mv	a0,s6
    5094:	f05ff0ef          	jal	4f98 <putc>
    5098:	a019                	j	509e <vprintf+0x44>
    } else if(state == '%'){
    509a:	03598363          	beq	s3,s5,50c0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    509e:	0019079b          	addiw	a5,s2,1
    50a2:	893e                	mv	s2,a5
    50a4:	873e                	mv	a4,a5
    50a6:	97d2                	add	a5,a5,s4
    50a8:	0007c483          	lbu	s1,0(a5)
    50ac:	1c048a63          	beqz	s1,5280 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    50b0:	0004879b          	sext.w	a5,s1
    if(state == 0){
    50b4:	fe0993e3          	bnez	s3,509a <vprintf+0x40>
      if(c0 == '%'){
    50b8:	fd579ce3          	bne	a5,s5,5090 <vprintf+0x36>
        state = '%';
    50bc:	89be                	mv	s3,a5
    50be:	b7c5                	j	509e <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    50c0:	00ea06b3          	add	a3,s4,a4
    50c4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    50c8:	1c060863          	beqz	a2,5298 <vprintf+0x23e>
      if(c0 == 'd'){
    50cc:	03878763          	beq	a5,s8,50fa <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    50d0:	f9478693          	addi	a3,a5,-108
    50d4:	0016b693          	seqz	a3,a3
    50d8:	f9c60593          	addi	a1,a2,-100
    50dc:	e99d                	bnez	a1,5112 <vprintf+0xb8>
    50de:	ca95                	beqz	a3,5112 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    50e0:	008b8493          	addi	s1,s7,8
    50e4:	4685                	li	a3,1
    50e6:	4629                	li	a2,10
    50e8:	000bb583          	ld	a1,0(s7)
    50ec:	855a                	mv	a0,s6
    50ee:	ec9ff0ef          	jal	4fb6 <printint>
        i += 1;
    50f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    50f4:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    50f6:	4981                	li	s3,0
    50f8:	b75d                	j	509e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    50fa:	008b8493          	addi	s1,s7,8
    50fe:	4685                	li	a3,1
    5100:	4629                	li	a2,10
    5102:	000ba583          	lw	a1,0(s7)
    5106:	855a                	mv	a0,s6
    5108:	eafff0ef          	jal	4fb6 <printint>
    510c:	8ba6                	mv	s7,s1
      state = 0;
    510e:	4981                	li	s3,0
    5110:	b779                	j	509e <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    5112:	9752                	add	a4,a4,s4
    5114:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5118:	f9460713          	addi	a4,a2,-108
    511c:	00173713          	seqz	a4,a4
    5120:	8f75                	and	a4,a4,a3
    5122:	f9c58513          	addi	a0,a1,-100
    5126:	18051363          	bnez	a0,52ac <vprintf+0x252>
    512a:	18070163          	beqz	a4,52ac <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    512e:	008b8493          	addi	s1,s7,8
    5132:	4685                	li	a3,1
    5134:	4629                	li	a2,10
    5136:	000bb583          	ld	a1,0(s7)
    513a:	855a                	mv	a0,s6
    513c:	e7bff0ef          	jal	4fb6 <printint>
        i += 2;
    5140:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5142:	8ba6                	mv	s7,s1
      state = 0;
    5144:	4981                	li	s3,0
        i += 2;
    5146:	bfa1                	j	509e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5148:	008b8493          	addi	s1,s7,8
    514c:	4681                	li	a3,0
    514e:	4629                	li	a2,10
    5150:	000be583          	lwu	a1,0(s7)
    5154:	855a                	mv	a0,s6
    5156:	e61ff0ef          	jal	4fb6 <printint>
    515a:	8ba6                	mv	s7,s1
      state = 0;
    515c:	4981                	li	s3,0
    515e:	b781                	j	509e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5160:	008b8493          	addi	s1,s7,8
    5164:	4681                	li	a3,0
    5166:	4629                	li	a2,10
    5168:	000bb583          	ld	a1,0(s7)
    516c:	855a                	mv	a0,s6
    516e:	e49ff0ef          	jal	4fb6 <printint>
        i += 1;
    5172:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5174:	8ba6                	mv	s7,s1
      state = 0;
    5176:	4981                	li	s3,0
    5178:	b71d                	j	509e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    517a:	008b8493          	addi	s1,s7,8
    517e:	4681                	li	a3,0
    5180:	4629                	li	a2,10
    5182:	000bb583          	ld	a1,0(s7)
    5186:	855a                	mv	a0,s6
    5188:	e2fff0ef          	jal	4fb6 <printint>
        i += 2;
    518c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    518e:	8ba6                	mv	s7,s1
      state = 0;
    5190:	4981                	li	s3,0
        i += 2;
    5192:	b731                	j	509e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5194:	008b8493          	addi	s1,s7,8
    5198:	4681                	li	a3,0
    519a:	4641                	li	a2,16
    519c:	000be583          	lwu	a1,0(s7)
    51a0:	855a                	mv	a0,s6
    51a2:	e15ff0ef          	jal	4fb6 <printint>
    51a6:	8ba6                	mv	s7,s1
      state = 0;
    51a8:	4981                	li	s3,0
    51aa:	bdd5                	j	509e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    51ac:	008b8493          	addi	s1,s7,8
    51b0:	4681                	li	a3,0
    51b2:	4641                	li	a2,16
    51b4:	000bb583          	ld	a1,0(s7)
    51b8:	855a                	mv	a0,s6
    51ba:	dfdff0ef          	jal	4fb6 <printint>
        i += 1;
    51be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    51c0:	8ba6                	mv	s7,s1
      state = 0;
    51c2:	4981                	li	s3,0
    51c4:	bde9                	j	509e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    51c6:	008b8493          	addi	s1,s7,8
    51ca:	4681                	li	a3,0
    51cc:	4641                	li	a2,16
    51ce:	000bb583          	ld	a1,0(s7)
    51d2:	855a                	mv	a0,s6
    51d4:	de3ff0ef          	jal	4fb6 <printint>
        i += 2;
    51d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    51da:	8ba6                	mv	s7,s1
      state = 0;
    51dc:	4981                	li	s3,0
        i += 2;
    51de:	b5c1                	j	509e <vprintf+0x44>
    51e0:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    51e2:	008b8793          	addi	a5,s7,8
    51e6:	8cbe                	mv	s9,a5
    51e8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    51ec:	03000593          	li	a1,48
    51f0:	855a                	mv	a0,s6
    51f2:	da7ff0ef          	jal	4f98 <putc>
  putc(fd, 'x');
    51f6:	07800593          	li	a1,120
    51fa:	855a                	mv	a0,s6
    51fc:	d9dff0ef          	jal	4f98 <putc>
    5200:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5202:	00003b97          	auipc	s7,0x3
    5206:	81eb8b93          	addi	s7,s7,-2018 # 7a20 <digits>
    520a:	03c9d793          	srli	a5,s3,0x3c
    520e:	97de                	add	a5,a5,s7
    5210:	0007c583          	lbu	a1,0(a5)
    5214:	855a                	mv	a0,s6
    5216:	d83ff0ef          	jal	4f98 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    521a:	0992                	slli	s3,s3,0x4
    521c:	34fd                	addiw	s1,s1,-1
    521e:	f4f5                	bnez	s1,520a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    5220:	8be6                	mv	s7,s9
      state = 0;
    5222:	4981                	li	s3,0
    5224:	6ca2                	ld	s9,8(sp)
    5226:	bda5                	j	509e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5228:	008b8493          	addi	s1,s7,8
    522c:	000bc583          	lbu	a1,0(s7)
    5230:	855a                	mv	a0,s6
    5232:	d67ff0ef          	jal	4f98 <putc>
    5236:	8ba6                	mv	s7,s1
      state = 0;
    5238:	4981                	li	s3,0
    523a:	b595                	j	509e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    523c:	008b8993          	addi	s3,s7,8
    5240:	000bb483          	ld	s1,0(s7)
    5244:	cc91                	beqz	s1,5260 <vprintf+0x206>
        for(; *s; s++)
    5246:	0004c583          	lbu	a1,0(s1)
    524a:	c985                	beqz	a1,527a <vprintf+0x220>
          putc(fd, *s);
    524c:	855a                	mv	a0,s6
    524e:	d4bff0ef          	jal	4f98 <putc>
        for(; *s; s++)
    5252:	0485                	addi	s1,s1,1
    5254:	0004c583          	lbu	a1,0(s1)
    5258:	f9f5                	bnez	a1,524c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    525a:	8bce                	mv	s7,s3
      state = 0;
    525c:	4981                	li	s3,0
    525e:	b581                	j	509e <vprintf+0x44>
          s = "(null)";
    5260:	00002497          	auipc	s1,0x2
    5264:	71048493          	addi	s1,s1,1808 # 7970 <malloc+0x2574>
        for(; *s; s++)
    5268:	02800593          	li	a1,40
    526c:	b7c5                	j	524c <vprintf+0x1f2>
        putc(fd, '%');
    526e:	85be                	mv	a1,a5
    5270:	855a                	mv	a0,s6
    5272:	d27ff0ef          	jal	4f98 <putc>
      state = 0;
    5276:	4981                	li	s3,0
    5278:	b51d                	j	509e <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    527a:	8bce                	mv	s7,s3
      state = 0;
    527c:	4981                	li	s3,0
    527e:	b505                	j	509e <vprintf+0x44>
    5280:	6906                	ld	s2,64(sp)
    5282:	79e2                	ld	s3,56(sp)
    5284:	7a42                	ld	s4,48(sp)
    5286:	7aa2                	ld	s5,40(sp)
    5288:	7b02                	ld	s6,32(sp)
    528a:	6be2                	ld	s7,24(sp)
    528c:	6c42                	ld	s8,16(sp)
    }
  }
}
    528e:	60e6                	ld	ra,88(sp)
    5290:	6446                	ld	s0,80(sp)
    5292:	64a6                	ld	s1,72(sp)
    5294:	6125                	addi	sp,sp,96
    5296:	8082                	ret
      if(c0 == 'd'){
    5298:	06400713          	li	a4,100
    529c:	e4e78fe3          	beq	a5,a4,50fa <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    52a0:	f9478693          	addi	a3,a5,-108
    52a4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    52a8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    52aa:	4701                	li	a4,0
      } else if(c0 == 'u'){
    52ac:	07500513          	li	a0,117
    52b0:	e8a78ce3          	beq	a5,a0,5148 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    52b4:	f8b60513          	addi	a0,a2,-117
    52b8:	e119                	bnez	a0,52be <vprintf+0x264>
    52ba:	ea0693e3          	bnez	a3,5160 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    52be:	f8b58513          	addi	a0,a1,-117
    52c2:	e119                	bnez	a0,52c8 <vprintf+0x26e>
    52c4:	ea071be3          	bnez	a4,517a <vprintf+0x120>
      } else if(c0 == 'x'){
    52c8:	07800513          	li	a0,120
    52cc:	eca784e3          	beq	a5,a0,5194 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    52d0:	f8860613          	addi	a2,a2,-120
    52d4:	e219                	bnez	a2,52da <vprintf+0x280>
    52d6:	ec069be3          	bnez	a3,51ac <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    52da:	f8858593          	addi	a1,a1,-120
    52de:	e199                	bnez	a1,52e4 <vprintf+0x28a>
    52e0:	ee0713e3          	bnez	a4,51c6 <vprintf+0x16c>
      } else if(c0 == 'p'){
    52e4:	07000713          	li	a4,112
    52e8:	eee78ce3          	beq	a5,a4,51e0 <vprintf+0x186>
      } else if(c0 == 'c'){
    52ec:	06300713          	li	a4,99
    52f0:	f2e78ce3          	beq	a5,a4,5228 <vprintf+0x1ce>
      } else if(c0 == 's'){
    52f4:	07300713          	li	a4,115
    52f8:	f4e782e3          	beq	a5,a4,523c <vprintf+0x1e2>
      } else if(c0 == '%'){
    52fc:	02500713          	li	a4,37
    5300:	f6e787e3          	beq	a5,a4,526e <vprintf+0x214>
        putc(fd, '%');
    5304:	02500593          	li	a1,37
    5308:	855a                	mv	a0,s6
    530a:	c8fff0ef          	jal	4f98 <putc>
        putc(fd, c0);
    530e:	85a6                	mv	a1,s1
    5310:	855a                	mv	a0,s6
    5312:	c87ff0ef          	jal	4f98 <putc>
      state = 0;
    5316:	4981                	li	s3,0
    5318:	b359                	j	509e <vprintf+0x44>

000000000000531a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    531a:	715d                	addi	sp,sp,-80
    531c:	ec06                	sd	ra,24(sp)
    531e:	e822                	sd	s0,16(sp)
    5320:	1000                	addi	s0,sp,32
    5322:	e010                	sd	a2,0(s0)
    5324:	e414                	sd	a3,8(s0)
    5326:	e818                	sd	a4,16(s0)
    5328:	ec1c                	sd	a5,24(s0)
    532a:	03043023          	sd	a6,32(s0)
    532e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5332:	8622                	mv	a2,s0
    5334:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5338:	d23ff0ef          	jal	505a <vprintf>
}
    533c:	60e2                	ld	ra,24(sp)
    533e:	6442                	ld	s0,16(sp)
    5340:	6161                	addi	sp,sp,80
    5342:	8082                	ret

0000000000005344 <printf>:

void
printf(const char *fmt, ...)
{
    5344:	711d                	addi	sp,sp,-96
    5346:	ec06                	sd	ra,24(sp)
    5348:	e822                	sd	s0,16(sp)
    534a:	1000                	addi	s0,sp,32
    534c:	e40c                	sd	a1,8(s0)
    534e:	e810                	sd	a2,16(s0)
    5350:	ec14                	sd	a3,24(s0)
    5352:	f018                	sd	a4,32(s0)
    5354:	f41c                	sd	a5,40(s0)
    5356:	03043823          	sd	a6,48(s0)
    535a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    535e:	00840613          	addi	a2,s0,8
    5362:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5366:	85aa                	mv	a1,a0
    5368:	4505                	li	a0,1
    536a:	cf1ff0ef          	jal	505a <vprintf>
}
    536e:	60e2                	ld	ra,24(sp)
    5370:	6442                	ld	s0,16(sp)
    5372:	6125                	addi	sp,sp,96
    5374:	8082                	ret

0000000000005376 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5376:	1141                	addi	sp,sp,-16
    5378:	e406                	sd	ra,8(sp)
    537a:	e022                	sd	s0,0(sp)
    537c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    537e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5382:	00003797          	auipc	a5,0x3
    5386:	0fe7b783          	ld	a5,254(a5) # 8480 <freep>
    538a:	a039                	j	5398 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    538c:	6398                	ld	a4,0(a5)
    538e:	00e7e463          	bltu	a5,a4,5396 <free+0x20>
    5392:	00e6ea63          	bltu	a3,a4,53a6 <free+0x30>
{
    5396:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5398:	fed7fae3          	bgeu	a5,a3,538c <free+0x16>
    539c:	6398                	ld	a4,0(a5)
    539e:	00e6e463          	bltu	a3,a4,53a6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    53a2:	fee7eae3          	bltu	a5,a4,5396 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    53a6:	ff852583          	lw	a1,-8(a0)
    53aa:	6390                	ld	a2,0(a5)
    53ac:	02059813          	slli	a6,a1,0x20
    53b0:	01c85713          	srli	a4,a6,0x1c
    53b4:	9736                	add	a4,a4,a3
    53b6:	02e60563          	beq	a2,a4,53e0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    53ba:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    53be:	4790                	lw	a2,8(a5)
    53c0:	02061593          	slli	a1,a2,0x20
    53c4:	01c5d713          	srli	a4,a1,0x1c
    53c8:	973e                	add	a4,a4,a5
    53ca:	02e68263          	beq	a3,a4,53ee <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    53ce:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    53d0:	00003717          	auipc	a4,0x3
    53d4:	0af73823          	sd	a5,176(a4) # 8480 <freep>
}
    53d8:	60a2                	ld	ra,8(sp)
    53da:	6402                	ld	s0,0(sp)
    53dc:	0141                	addi	sp,sp,16
    53de:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    53e0:	4618                	lw	a4,8(a2)
    53e2:	9f2d                	addw	a4,a4,a1
    53e4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    53e8:	6398                	ld	a4,0(a5)
    53ea:	6310                	ld	a2,0(a4)
    53ec:	b7f9                	j	53ba <free+0x44>
    p->s.size += bp->s.size;
    53ee:	ff852703          	lw	a4,-8(a0)
    53f2:	9f31                	addw	a4,a4,a2
    53f4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    53f6:	ff053683          	ld	a3,-16(a0)
    53fa:	bfd1                	j	53ce <free+0x58>

00000000000053fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    53fc:	7139                	addi	sp,sp,-64
    53fe:	fc06                	sd	ra,56(sp)
    5400:	f822                	sd	s0,48(sp)
    5402:	f04a                	sd	s2,32(sp)
    5404:	ec4e                	sd	s3,24(sp)
    5406:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5408:	02051993          	slli	s3,a0,0x20
    540c:	0209d993          	srli	s3,s3,0x20
    5410:	09bd                	addi	s3,s3,15
    5412:	0049d993          	srli	s3,s3,0x4
    5416:	2985                	addiw	s3,s3,1
    5418:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    541a:	00003517          	auipc	a0,0x3
    541e:	06653503          	ld	a0,102(a0) # 8480 <freep>
    5422:	c905                	beqz	a0,5452 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5424:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5426:	4798                	lw	a4,8(a5)
    5428:	09377663          	bgeu	a4,s3,54b4 <malloc+0xb8>
    542c:	f426                	sd	s1,40(sp)
    542e:	e852                	sd	s4,16(sp)
    5430:	e456                	sd	s5,8(sp)
    5432:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5434:	8a4e                	mv	s4,s3
    5436:	6705                	lui	a4,0x1
    5438:	00e9f363          	bgeu	s3,a4,543e <malloc+0x42>
    543c:	6a05                	lui	s4,0x1
    543e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5442:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5446:	00003497          	auipc	s1,0x3
    544a:	03a48493          	addi	s1,s1,58 # 8480 <freep>
  if(p == SBRK_ERROR)
    544e:	5afd                	li	s5,-1
    5450:	a83d                	j	548e <malloc+0x92>
    5452:	f426                	sd	s1,40(sp)
    5454:	e852                	sd	s4,16(sp)
    5456:	e456                	sd	s5,8(sp)
    5458:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    545a:	0000a797          	auipc	a5,0xa
    545e:	84e78793          	addi	a5,a5,-1970 # eca8 <base>
    5462:	00003717          	auipc	a4,0x3
    5466:	00f73f23          	sd	a5,30(a4) # 8480 <freep>
    546a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    546c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5470:	b7d1                	j	5434 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5472:	6398                	ld	a4,0(a5)
    5474:	e118                	sd	a4,0(a0)
    5476:	a899                	j	54cc <malloc+0xd0>
  hp->s.size = nu;
    5478:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    547c:	0541                	addi	a0,a0,16
    547e:	ef9ff0ef          	jal	5376 <free>
  return freep;
    5482:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5484:	c125                	beqz	a0,54e4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5486:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5488:	4798                	lw	a4,8(a5)
    548a:	03277163          	bgeu	a4,s2,54ac <malloc+0xb0>
    if(p == freep)
    548e:	6098                	ld	a4,0(s1)
    5490:	853e                	mv	a0,a5
    5492:	fef71ae3          	bne	a4,a5,5486 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5496:	8552                	mv	a0,s4
    5498:	a2dff0ef          	jal	4ec4 <sbrk>
  if(p == SBRK_ERROR)
    549c:	fd551ee3          	bne	a0,s5,5478 <malloc+0x7c>
        return 0;
    54a0:	4501                	li	a0,0
    54a2:	74a2                	ld	s1,40(sp)
    54a4:	6a42                	ld	s4,16(sp)
    54a6:	6aa2                	ld	s5,8(sp)
    54a8:	6b02                	ld	s6,0(sp)
    54aa:	a03d                	j	54d8 <malloc+0xdc>
    54ac:	74a2                	ld	s1,40(sp)
    54ae:	6a42                	ld	s4,16(sp)
    54b0:	6aa2                	ld	s5,8(sp)
    54b2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    54b4:	fae90fe3          	beq	s2,a4,5472 <malloc+0x76>
        p->s.size -= nunits;
    54b8:	4137073b          	subw	a4,a4,s3
    54bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    54be:	02071693          	slli	a3,a4,0x20
    54c2:	01c6d713          	srli	a4,a3,0x1c
    54c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    54c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    54cc:	00003717          	auipc	a4,0x3
    54d0:	faa73a23          	sd	a0,-76(a4) # 8480 <freep>
      return (void*)(p + 1);
    54d4:	01078513          	addi	a0,a5,16
  }
}
    54d8:	70e2                	ld	ra,56(sp)
    54da:	7442                	ld	s0,48(sp)
    54dc:	7902                	ld	s2,32(sp)
    54de:	69e2                	ld	s3,24(sp)
    54e0:	6121                	addi	sp,sp,64
    54e2:	8082                	ret
    54e4:	74a2                	ld	s1,40(sp)
    54e6:	6a42                	ld	s4,16(sp)
    54e8:	6aa2                	ld	s5,8(sp)
    54ea:	6b02                	ld	s6,0(sp)
    54ec:	b7f5                	j	54d8 <malloc+0xdc>
