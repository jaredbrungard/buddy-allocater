
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	27e58593          	addi	a1,a1,638 # 1290 <malloc+0xfc>
      1a:	8532                	mv	a0,a2
      1c:	48d000ef          	jal	ca8 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	239000ef          	jal	a5e <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	27f000ef          	jal	aac <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	24c58593          	addi	a1,a1,588 # 12a0 <malloc+0x10c>
      5c:	4509                	li	a0,2
      5e:	054010ef          	jal	10b2 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	425000ef          	jal	c88 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	411000ef          	jal	c80 <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	22650513          	addi	a0,a0,550 # 12a8 <malloc+0x114>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if(cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	2fe70713          	addi	a4,a4,766 # 13a8 <malloc+0x214>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	3cb000ef          	jal	c88 <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	1ee50513          	addi	a0,a0,494 # 12b0 <malloc+0x11c>
      ca:	f81ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	3eb000ef          	jal	cc0 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	1dc58593          	addi	a1,a1,476 # 12b8 <malloc+0x124>
      e4:	4509                	li	a0,2
      e6:	7cd000ef          	jal	10b2 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	39d000ef          	jal	c88 <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	397000ef          	jal	c88 <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	3b9000ef          	jal	cb0 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	3c9000ef          	jal	cc8 <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	1b858593          	addi	a1,a1,440 # 12c8 <malloc+0x134>
     118:	4509                	li	a0,2
     11a:	799000ef          	jal	10b2 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	369000ef          	jal	c88 <exit>
    if(fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	35f000ef          	jal	c90 <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	359000ef          	jal	c98 <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if(fork1() == 0){
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	361000ef          	jal	cb0 <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	3a9000ef          	jal	d00 <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	351000ef          	jal	cb0 <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	349000ef          	jal	cb0 <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	16650513          	addi	a0,a0,358 # 12d8 <malloc+0x144>
     17a:	ed1ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	32d000ef          	jal	cb0 <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	375000ef          	jal	d00 <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	31d000ef          	jal	cb0 <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	315000ef          	jal	cb0 <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	307000ef          	jal	cb0 <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	2ff000ef          	jal	cb0 <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	2d9000ef          	jal	c90 <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	2d3000ef          	jal	c90 <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if(fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	7b5000ef          	jal	1194 <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	073000ef          	jal	a5e <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	892a                	mv	s2,a0
     216:	89ae                	mv	s3,a1
     218:	8a32                	mv	s4,a2
     21a:	8ab6                	mv	s5,a3
     21c:	8b3a                	mv	s6,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	773000ef          	jal	1194 <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	031000ef          	jal	a5e <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0124b423          	sd	s2,8(s1)
  cmd->file = file;
     23a:	0134b823          	sd	s3,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0354a023          	sw	s5,32(s1)
  cmd->fd = fd;
     246:	0364a223          	sw	s6,36(s1)
  return (struct cmd*)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	892a                	mv	s2,a0
     270:	89ae                	mv	s3,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	721000ef          	jal	1194 <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7e0000ef          	jal	a5e <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     28a:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	892a                	mv	s2,a0
     2ae:	89ae                	mv	s3,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	6e3000ef          	jal	1194 <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	7a2000ef          	jal	a5e <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     2c8:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	6a9000ef          	jal	1194 <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	768000ef          	jal	a5e <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	744000ef          	jal	a84 <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76563          	bltu	a4,a5,3ec <gettoken+0xdc>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6e2000ef          	jal	a84 <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch(*s){
     3ca:	03e00713          	li	a4,62
     3ce:	00e79b63          	bne	a5,a4,3e4 <gettoken+0xd4>
    if(*s == '>'){
     3d2:	0014c703          	lbu	a4,1(s1)
     3d6:	03e00793          	li	a5,62
     3da:	04f70863          	beq	a4,a5,42a <gettoken+0x11a>
    s++;
     3de:	0485                	addi	s1,s1,1
  ret = *s;
     3e0:	8abe                	mv	s5,a5
     3e2:	b75d                	j	388 <gettoken+0x78>
  switch(*s){
     3e4:	07c00713          	li	a4,124
     3e8:	f8e78fe3          	beq	a5,a4,386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3ec:	00002997          	auipc	s3,0x2
     3f0:	c1c98993          	addi	s3,s3,-996 # 2008 <whitespace>
     3f4:	00002a97          	auipc	s5,0x2
     3f8:	c0ca8a93          	addi	s5,s5,-1012 # 2000 <symbols>
     3fc:	0524f163          	bgeu	s1,s2,43e <gettoken+0x12e>
     400:	0004c583          	lbu	a1,0(s1)
     404:	854e                	mv	a0,s3
     406:	67e000ef          	jal	a84 <strchr>
     40a:	e51d                	bnez	a0,438 <gettoken+0x128>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	8556                	mv	a0,s5
     412:	672000ef          	jal	a84 <strchr>
     416:	ed11                	bnez	a0,432 <gettoken+0x122>
      s++;
     418:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     41a:	fe9913e3          	bne	s2,s1,400 <gettoken+0xf0>
  if(eq)
     41e:	84ca                	mv	s1,s2
    ret = 'a';
     420:	06100a93          	li	s5,97
  if(eq)
     424:	f60b14e3          	bnez	s6,38c <gettoken+0x7c>
     428:	b761                	j	3b0 <gettoken+0xa0>
      s++;
     42a:	0489                	addi	s1,s1,2
      ret = '+';
     42c:	02b00a93          	li	s5,43
     430:	bfa1                	j	388 <gettoken+0x78>
    ret = 'a';
     432:	06100a93          	li	s5,97
     436:	bf89                	j	388 <gettoken+0x78>
     438:	06100a93          	li	s5,97
     43c:	b7b1                	j	388 <gettoken+0x78>
     43e:	06100a93          	li	s5,97
  if(eq)
     442:	f40b15e3          	bnez	s6,38c <gettoken+0x7c>
     446:	b7ad                	j	3b0 <gettoken+0xa0>

0000000000000448 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     448:	7139                	addi	sp,sp,-64
     44a:	fc06                	sd	ra,56(sp)
     44c:	f822                	sd	s0,48(sp)
     44e:	f426                	sd	s1,40(sp)
     450:	f04a                	sd	s2,32(sp)
     452:	ec4e                	sd	s3,24(sp)
     454:	e852                	sd	s4,16(sp)
     456:	e456                	sd	s5,8(sp)
     458:	0080                	addi	s0,sp,64
     45a:	8a2a                	mv	s4,a0
     45c:	892e                	mv	s2,a1
     45e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     460:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     462:	00002997          	auipc	s3,0x2
     466:	ba698993          	addi	s3,s3,-1114 # 2008 <whitespace>
     46a:	00b4fc63          	bgeu	s1,a1,482 <peek+0x3a>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	610000ef          	jal	a84 <strchr>
     478:	c509                	beqz	a0,482 <peek+0x3a>
    s++;
     47a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47c:	fe9919e3          	bne	s2,s1,46e <peek+0x26>
     480:	84ca                	mv	s1,s2
  *ps = s;
     482:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     486:	0004c583          	lbu	a1,0(s1)
     48a:	4501                	li	a0,0
     48c:	e991                	bnez	a1,4a0 <peek+0x58>
}
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
  return *s && strchr(toks, *s);
     4a0:	8556                	mv	a0,s5
     4a2:	5e2000ef          	jal	a84 <strchr>
     4a6:	00a03533          	snez	a0,a0
     4aa:	b7d5                	j	48e <peek+0x46>

00000000000004ac <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4ac:	7159                	addi	sp,sp,-112
     4ae:	f486                	sd	ra,104(sp)
     4b0:	f0a2                	sd	s0,96(sp)
     4b2:	eca6                	sd	s1,88(sp)
     4b4:	e8ca                	sd	s2,80(sp)
     4b6:	e4ce                	sd	s3,72(sp)
     4b8:	e0d2                	sd	s4,64(sp)
     4ba:	fc56                	sd	s5,56(sp)
     4bc:	f85a                	sd	s6,48(sp)
     4be:	f45e                	sd	s7,40(sp)
     4c0:	f062                	sd	s8,32(sp)
     4c2:	ec66                	sd	s9,24(sp)
     4c4:	1880                	addi	s0,sp,112
     4c6:	8a2a                	mv	s4,a0
     4c8:	89ae                	mv	s3,a1
     4ca:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4cc:	00001b17          	auipc	s6,0x1
     4d0:	e34b0b13          	addi	s6,s6,-460 # 1300 <malloc+0x16c>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d4:	f9040c93          	addi	s9,s0,-112
     4d8:	f9840c13          	addi	s8,s0,-104
     4dc:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     4e0:	a00d                	j	502 <parseredirs+0x56>
      panic("missing file for redirection");
     4e2:	00001517          	auipc	a0,0x1
     4e6:	dfe50513          	addi	a0,a0,-514 # 12e0 <malloc+0x14c>
     4ea:	b61ff0ef          	jal	4a <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ee:	4701                	li	a4,0
     4f0:	4681                	li	a3,0
     4f2:	f9043603          	ld	a2,-112(s0)
     4f6:	f9843583          	ld	a1,-104(s0)
     4fa:	8552                	mv	a0,s4
     4fc:	d05ff0ef          	jal	200 <redircmd>
     500:	8a2a                	mv	s4,a0
    switch(tok){
     502:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     506:	865a                	mv	a2,s6
     508:	85ca                	mv	a1,s2
     50a:	854e                	mv	a0,s3
     50c:	f3dff0ef          	jal	448 <peek>
     510:	c135                	beqz	a0,574 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
     512:	4681                	li	a3,0
     514:	4601                	li	a2,0
     516:	85ca                	mv	a1,s2
     518:	854e                	mv	a0,s3
     51a:	df7ff0ef          	jal	310 <gettoken>
     51e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     520:	86e6                	mv	a3,s9
     522:	8662                	mv	a2,s8
     524:	85ca                	mv	a1,s2
     526:	854e                	mv	a0,s3
     528:	de9ff0ef          	jal	310 <gettoken>
     52c:	fb751be3          	bne	a0,s7,4e2 <parseredirs+0x36>
    switch(tok){
     530:	fb548fe3          	beq	s1,s5,4ee <parseredirs+0x42>
     534:	03e00793          	li	a5,62
     538:	02f48263          	beq	s1,a5,55c <parseredirs+0xb0>
     53c:	02b00793          	li	a5,43
     540:	fcf493e3          	bne	s1,a5,506 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     544:	4705                	li	a4,1
     546:	20100693          	li	a3,513
     54a:	f9043603          	ld	a2,-112(s0)
     54e:	f9843583          	ld	a1,-104(s0)
     552:	8552                	mv	a0,s4
     554:	cadff0ef          	jal	200 <redircmd>
     558:	8a2a                	mv	s4,a0
      break;
     55a:	b765                	j	502 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     55c:	4705                	li	a4,1
     55e:	60100693          	li	a3,1537
     562:	f9043603          	ld	a2,-112(s0)
     566:	f9843583          	ld	a1,-104(s0)
     56a:	8552                	mv	a0,s4
     56c:	c95ff0ef          	jal	200 <redircmd>
     570:	8a2a                	mv	s4,a0
      break;
     572:	bf41                	j	502 <parseredirs+0x56>
    }
  }
  return cmd;
}
     574:	8552                	mv	a0,s4
     576:	70a6                	ld	ra,104(sp)
     578:	7406                	ld	s0,96(sp)
     57a:	64e6                	ld	s1,88(sp)
     57c:	6946                	ld	s2,80(sp)
     57e:	69a6                	ld	s3,72(sp)
     580:	6a06                	ld	s4,64(sp)
     582:	7ae2                	ld	s5,56(sp)
     584:	7b42                	ld	s6,48(sp)
     586:	7ba2                	ld	s7,40(sp)
     588:	7c02                	ld	s8,32(sp)
     58a:	6ce2                	ld	s9,24(sp)
     58c:	6165                	addi	sp,sp,112
     58e:	8082                	ret

0000000000000590 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     590:	7119                	addi	sp,sp,-128
     592:	fc86                	sd	ra,120(sp)
     594:	f8a2                	sd	s0,112(sp)
     596:	f4a6                	sd	s1,104(sp)
     598:	e8d2                	sd	s4,80(sp)
     59a:	e4d6                	sd	s5,72(sp)
     59c:	0100                	addi	s0,sp,128
     59e:	8a2a                	mv	s4,a0
     5a0:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5a2:	00001617          	auipc	a2,0x1
     5a6:	d6660613          	addi	a2,a2,-666 # 1308 <malloc+0x174>
     5aa:	e9fff0ef          	jal	448 <peek>
     5ae:	e121                	bnez	a0,5ee <parseexec+0x5e>
     5b0:	f0ca                	sd	s2,96(sp)
     5b2:	ecce                	sd	s3,88(sp)
     5b4:	e0da                	sd	s6,64(sp)
     5b6:	fc5e                	sd	s7,56(sp)
     5b8:	f862                	sd	s8,48(sp)
     5ba:	f466                	sd	s9,40(sp)
     5bc:	f06a                	sd	s10,32(sp)
     5be:	ec6e                	sd	s11,24(sp)
     5c0:	892a                	mv	s2,a0
    return parseblock(ps, es);

  ret = execcmd();
     5c2:	c11ff0ef          	jal	1d2 <execcmd>
     5c6:	89aa                	mv	s3,a0
     5c8:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5ca:	8656                	mv	a2,s5
     5cc:	85d2                	mv	a1,s4
     5ce:	edfff0ef          	jal	4ac <parseredirs>
     5d2:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5d4:	09a1                	addi	s3,s3,8
     5d6:	00001b17          	auipc	s6,0x1
     5da:	d52b0b13          	addi	s6,s6,-686 # 1328 <malloc+0x194>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5de:	f8040c13          	addi	s8,s0,-128
     5e2:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     5e6:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ea:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     5ec:	a81d                	j	622 <parseexec+0x92>
    return parseblock(ps, es);
     5ee:	85d6                	mv	a1,s5
     5f0:	8552                	mv	a0,s4
     5f2:	178000ef          	jal	76a <parseblock>
     5f6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5f8:	8526                	mv	a0,s1
     5fa:	70e6                	ld	ra,120(sp)
     5fc:	7446                	ld	s0,112(sp)
     5fe:	74a6                	ld	s1,104(sp)
     600:	6a46                	ld	s4,80(sp)
     602:	6aa6                	ld	s5,72(sp)
     604:	6109                	addi	sp,sp,128
     606:	8082                	ret
      panic("syntax");
     608:	00001517          	auipc	a0,0x1
     60c:	d0850513          	addi	a0,a0,-760 # 1310 <malloc+0x17c>
     610:	a3bff0ef          	jal	4a <panic>
    if(argc >= MAXARGS)
     614:	09a1                	addi	s3,s3,8
    ret = parseredirs(ret, ps, es);
     616:	8656                	mv	a2,s5
     618:	85d2                	mv	a1,s4
     61a:	8526                	mv	a0,s1
     61c:	e91ff0ef          	jal	4ac <parseredirs>
     620:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     622:	865a                	mv	a2,s6
     624:	85d6                	mv	a1,s5
     626:	8552                	mv	a0,s4
     628:	e21ff0ef          	jal	448 <peek>
     62c:	e91d                	bnez	a0,662 <parseexec+0xd2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     62e:	86e2                	mv	a3,s8
     630:	865e                	mv	a2,s7
     632:	85d6                	mv	a1,s5
     634:	8552                	mv	a0,s4
     636:	cdbff0ef          	jal	310 <gettoken>
     63a:	c505                	beqz	a0,662 <parseexec+0xd2>
    if(tok != 'a')
     63c:	fda516e3          	bne	a0,s10,608 <parseexec+0x78>
    cmd->argv[argc] = q;
     640:	f8843783          	ld	a5,-120(s0)
     644:	00f9b023          	sd	a5,0(s3)
    cmd->eargv[argc] = eq;
     648:	f8043783          	ld	a5,-128(s0)
     64c:	04f9b823          	sd	a5,80(s3)
    argc++;
     650:	2905                	addiw	s2,s2,1
    if(argc >= MAXARGS)
     652:	fd9911e3          	bne	s2,s9,614 <parseexec+0x84>
      panic("too many args");
     656:	00001517          	auipc	a0,0x1
     65a:	cc250513          	addi	a0,a0,-830 # 1318 <malloc+0x184>
     65e:	9edff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     662:	090e                	slli	s2,s2,0x3
     664:	012d87b3          	add	a5,s11,s2
     668:	0007b423          	sd	zero,8(a5)
  cmd->eargv[argc] = 0;
     66c:	0407bc23          	sd	zero,88(a5)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6b06                	ld	s6,64(sp)
     676:	7be2                	ld	s7,56(sp)
     678:	7c42                	ld	s8,48(sp)
     67a:	7ca2                	ld	s9,40(sp)
     67c:	7d02                	ld	s10,32(sp)
     67e:	6de2                	ld	s11,24(sp)
  return ret;
     680:	bfa5                	j	5f8 <parseexec+0x68>

0000000000000682 <parsepipe>:
{
     682:	7179                	addi	sp,sp,-48
     684:	f406                	sd	ra,40(sp)
     686:	f022                	sd	s0,32(sp)
     688:	ec26                	sd	s1,24(sp)
     68a:	e84a                	sd	s2,16(sp)
     68c:	e44e                	sd	s3,8(sp)
     68e:	e052                	sd	s4,0(sp)
     690:	1800                	addi	s0,sp,48
     692:	892a                	mv	s2,a0
     694:	8a2a                	mv	s4,a0
     696:	84ae                	mv	s1,a1
  cmd = parseexec(ps, es);
     698:	ef9ff0ef          	jal	590 <parseexec>
     69c:	89aa                	mv	s3,a0
  if(peek(ps, es, "|")){
     69e:	00001617          	auipc	a2,0x1
     6a2:	c9260613          	addi	a2,a2,-878 # 1330 <malloc+0x19c>
     6a6:	85a6                	mv	a1,s1
     6a8:	854a                	mv	a0,s2
     6aa:	d9fff0ef          	jal	448 <peek>
     6ae:	e911                	bnez	a0,6c2 <parsepipe+0x40>
}
     6b0:	854e                	mv	a0,s3
     6b2:	70a2                	ld	ra,40(sp)
     6b4:	7402                	ld	s0,32(sp)
     6b6:	64e2                	ld	s1,24(sp)
     6b8:	6942                	ld	s2,16(sp)
     6ba:	69a2                	ld	s3,8(sp)
     6bc:	6a02                	ld	s4,0(sp)
     6be:	6145                	addi	sp,sp,48
     6c0:	8082                	ret
    gettoken(ps, es, 0, 0);
     6c2:	4681                	li	a3,0
     6c4:	4601                	li	a2,0
     6c6:	85a6                	mv	a1,s1
     6c8:	8552                	mv	a0,s4
     6ca:	c47ff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ce:	85a6                	mv	a1,s1
     6d0:	8552                	mv	a0,s4
     6d2:	fb1ff0ef          	jal	682 <parsepipe>
     6d6:	85aa                	mv	a1,a0
     6d8:	854e                	mv	a0,s3
     6da:	b87ff0ef          	jal	260 <pipecmd>
     6de:	89aa                	mv	s3,a0
  return cmd;
     6e0:	bfc1                	j	6b0 <parsepipe+0x2e>

00000000000006e2 <parseline>:
{
     6e2:	7179                	addi	sp,sp,-48
     6e4:	f406                	sd	ra,40(sp)
     6e6:	f022                	sd	s0,32(sp)
     6e8:	ec26                	sd	s1,24(sp)
     6ea:	e84a                	sd	s2,16(sp)
     6ec:	e44e                	sd	s3,8(sp)
     6ee:	e052                	sd	s4,0(sp)
     6f0:	1800                	addi	s0,sp,48
     6f2:	892a                	mv	s2,a0
     6f4:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6f6:	f8dff0ef          	jal	682 <parsepipe>
     6fa:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6fc:	00001a17          	auipc	s4,0x1
     700:	c3ca0a13          	addi	s4,s4,-964 # 1338 <malloc+0x1a4>
     704:	a819                	j	71a <parseline+0x38>
    gettoken(ps, es, 0, 0);
     706:	4681                	li	a3,0
     708:	4601                	li	a2,0
     70a:	85ce                	mv	a1,s3
     70c:	854a                	mv	a0,s2
     70e:	c03ff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     712:	8526                	mv	a0,s1
     714:	bc9ff0ef          	jal	2dc <backcmd>
     718:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     71a:	8652                	mv	a2,s4
     71c:	85ce                	mv	a1,s3
     71e:	854a                	mv	a0,s2
     720:	d29ff0ef          	jal	448 <peek>
     724:	f16d                	bnez	a0,706 <parseline+0x24>
  if(peek(ps, es, ";")){
     726:	00001617          	auipc	a2,0x1
     72a:	c1a60613          	addi	a2,a2,-998 # 1340 <malloc+0x1ac>
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	d17ff0ef          	jal	448 <peek>
     736:	e911                	bnez	a0,74a <parseline+0x68>
}
     738:	8526                	mv	a0,s1
     73a:	70a2                	ld	ra,40(sp)
     73c:	7402                	ld	s0,32(sp)
     73e:	64e2                	ld	s1,24(sp)
     740:	6942                	ld	s2,16(sp)
     742:	69a2                	ld	s3,8(sp)
     744:	6a02                	ld	s4,0(sp)
     746:	6145                	addi	sp,sp,48
     748:	8082                	ret
    gettoken(ps, es, 0, 0);
     74a:	4681                	li	a3,0
     74c:	4601                	li	a2,0
     74e:	85ce                	mv	a1,s3
     750:	854a                	mv	a0,s2
     752:	bbfff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     756:	85ce                	mv	a1,s3
     758:	854a                	mv	a0,s2
     75a:	f89ff0ef          	jal	6e2 <parseline>
     75e:	85aa                	mv	a1,a0
     760:	8526                	mv	a0,s1
     762:	b3dff0ef          	jal	29e <listcmd>
     766:	84aa                	mv	s1,a0
  return cmd;
     768:	bfc1                	j	738 <parseline+0x56>

000000000000076a <parseblock>:
{
     76a:	7179                	addi	sp,sp,-48
     76c:	f406                	sd	ra,40(sp)
     76e:	f022                	sd	s0,32(sp)
     770:	ec26                	sd	s1,24(sp)
     772:	e84a                	sd	s2,16(sp)
     774:	e44e                	sd	s3,8(sp)
     776:	1800                	addi	s0,sp,48
     778:	84aa                	mv	s1,a0
     77a:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     77c:	00001617          	auipc	a2,0x1
     780:	b8c60613          	addi	a2,a2,-1140 # 1308 <malloc+0x174>
     784:	cc5ff0ef          	jal	448 <peek>
     788:	c539                	beqz	a0,7d6 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     78a:	4681                	li	a3,0
     78c:	4601                	li	a2,0
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	b7fff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     796:	85ca                	mv	a1,s2
     798:	8526                	mv	a0,s1
     79a:	f49ff0ef          	jal	6e2 <parseline>
     79e:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     7a0:	00001617          	auipc	a2,0x1
     7a4:	bb860613          	addi	a2,a2,-1096 # 1358 <malloc+0x1c4>
     7a8:	85ca                	mv	a1,s2
     7aa:	8526                	mv	a0,s1
     7ac:	c9dff0ef          	jal	448 <peek>
     7b0:	c90d                	beqz	a0,7e2 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7b2:	4681                	li	a3,0
     7b4:	4601                	li	a2,0
     7b6:	85ca                	mv	a1,s2
     7b8:	8526                	mv	a0,s1
     7ba:	b57ff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7be:	864a                	mv	a2,s2
     7c0:	85a6                	mv	a1,s1
     7c2:	854e                	mv	a0,s3
     7c4:	ce9ff0ef          	jal	4ac <parseredirs>
}
     7c8:	70a2                	ld	ra,40(sp)
     7ca:	7402                	ld	s0,32(sp)
     7cc:	64e2                	ld	s1,24(sp)
     7ce:	6942                	ld	s2,16(sp)
     7d0:	69a2                	ld	s3,8(sp)
     7d2:	6145                	addi	sp,sp,48
     7d4:	8082                	ret
    panic("parseblock");
     7d6:	00001517          	auipc	a0,0x1
     7da:	b7250513          	addi	a0,a0,-1166 # 1348 <malloc+0x1b4>
     7de:	86dff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7e2:	00001517          	auipc	a0,0x1
     7e6:	b7e50513          	addi	a0,a0,-1154 # 1360 <malloc+0x1cc>
     7ea:	861ff0ef          	jal	4a <panic>

00000000000007ee <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7ee:	1101                	addi	sp,sp,-32
     7f0:	ec06                	sd	ra,24(sp)
     7f2:	e822                	sd	s0,16(sp)
     7f4:	e426                	sd	s1,8(sp)
     7f6:	1000                	addi	s0,sp,32
     7f8:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7fa:	c131                	beqz	a0,83e <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7fc:	4118                	lw	a4,0(a0)
     7fe:	4795                	li	a5,5
     800:	02e7ef63          	bltu	a5,a4,83e <nulterminate+0x50>
     804:	00056783          	lwu	a5,0(a0)
     808:	078a                	slli	a5,a5,0x2
     80a:	00001717          	auipc	a4,0x1
     80e:	bb670713          	addi	a4,a4,-1098 # 13c0 <malloc+0x22c>
     812:	97ba                	add	a5,a5,a4
     814:	439c                	lw	a5,0(a5)
     816:	97ba                	add	a5,a5,a4
     818:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     81a:	651c                	ld	a5,8(a0)
     81c:	c38d                	beqz	a5,83e <nulterminate+0x50>
     81e:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     822:	67b8                	ld	a4,72(a5)
     824:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     828:	07a1                	addi	a5,a5,8
     82a:	ff87b703          	ld	a4,-8(a5)
     82e:	fb75                	bnez	a4,822 <nulterminate+0x34>
     830:	a039                	j	83e <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     832:	6508                	ld	a0,8(a0)
     834:	fbbff0ef          	jal	7ee <nulterminate>
    *rcmd->efile = 0;
     838:	6c9c                	ld	a5,24(s1)
     83a:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     83e:	8526                	mv	a0,s1
     840:	60e2                	ld	ra,24(sp)
     842:	6442                	ld	s0,16(sp)
     844:	64a2                	ld	s1,8(sp)
     846:	6105                	addi	sp,sp,32
     848:	8082                	ret
    nulterminate(pcmd->left);
     84a:	6508                	ld	a0,8(a0)
     84c:	fa3ff0ef          	jal	7ee <nulterminate>
    nulterminate(pcmd->right);
     850:	6888                	ld	a0,16(s1)
     852:	f9dff0ef          	jal	7ee <nulterminate>
    break;
     856:	b7e5                	j	83e <nulterminate+0x50>
    nulterminate(lcmd->left);
     858:	6508                	ld	a0,8(a0)
     85a:	f95ff0ef          	jal	7ee <nulterminate>
    nulterminate(lcmd->right);
     85e:	6888                	ld	a0,16(s1)
     860:	f8fff0ef          	jal	7ee <nulterminate>
    break;
     864:	bfe9                	j	83e <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     866:	6508                	ld	a0,8(a0)
     868:	f87ff0ef          	jal	7ee <nulterminate>
    break;
     86c:	bfc9                	j	83e <nulterminate+0x50>

000000000000086e <parsecmd>:
{
     86e:	7139                	addi	sp,sp,-64
     870:	fc06                	sd	ra,56(sp)
     872:	f822                	sd	s0,48(sp)
     874:	f426                	sd	s1,40(sp)
     876:	f04a                	sd	s2,32(sp)
     878:	ec4e                	sd	s3,24(sp)
     87a:	0080                	addi	s0,sp,64
     87c:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     880:	84aa                	mv	s1,a0
     882:	1b0000ef          	jal	a32 <strlen>
     886:	1502                	slli	a0,a0,0x20
     888:	9101                	srli	a0,a0,0x20
     88a:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     88c:	fc840913          	addi	s2,s0,-56
     890:	85a6                	mv	a1,s1
     892:	854a                	mv	a0,s2
     894:	e4fff0ef          	jal	6e2 <parseline>
     898:	89aa                	mv	s3,a0
  peek(&s, es, "");
     89a:	00001617          	auipc	a2,0x1
     89e:	9fe60613          	addi	a2,a2,-1538 # 1298 <malloc+0x104>
     8a2:	85a6                	mv	a1,s1
     8a4:	854a                	mv	a0,s2
     8a6:	ba3ff0ef          	jal	448 <peek>
  if(s != es){
     8aa:	fc843603          	ld	a2,-56(s0)
     8ae:	00961d63          	bne	a2,s1,8c8 <parsecmd+0x5a>
  nulterminate(cmd);
     8b2:	854e                	mv	a0,s3
     8b4:	f3bff0ef          	jal	7ee <nulterminate>
}
     8b8:	854e                	mv	a0,s3
     8ba:	70e2                	ld	ra,56(sp)
     8bc:	7442                	ld	s0,48(sp)
     8be:	74a2                	ld	s1,40(sp)
     8c0:	7902                	ld	s2,32(sp)
     8c2:	69e2                	ld	s3,24(sp)
     8c4:	6121                	addi	sp,sp,64
     8c6:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8c8:	00001597          	auipc	a1,0x1
     8cc:	ab058593          	addi	a1,a1,-1360 # 1378 <malloc+0x1e4>
     8d0:	4509                	li	a0,2
     8d2:	7e0000ef          	jal	10b2 <fprintf>
    panic("syntax");
     8d6:	00001517          	auipc	a0,0x1
     8da:	a3a50513          	addi	a0,a0,-1478 # 1310 <malloc+0x17c>
     8de:	f6cff0ef          	jal	4a <panic>

00000000000008e2 <main>:
{
     8e2:	7139                	addi	sp,sp,-64
     8e4:	fc06                	sd	ra,56(sp)
     8e6:	f822                	sd	s0,48(sp)
     8e8:	f426                	sd	s1,40(sp)
     8ea:	f04a                	sd	s2,32(sp)
     8ec:	ec4e                	sd	s3,24(sp)
     8ee:	e852                	sd	s4,16(sp)
     8f0:	e456                	sd	s5,8(sp)
     8f2:	e05a                	sd	s6,0(sp)
     8f4:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8f6:	4489                	li	s1,2
     8f8:	00001917          	auipc	s2,0x1
     8fc:	a9090913          	addi	s2,s2,-1392 # 1388 <malloc+0x1f4>
     900:	85a6                	mv	a1,s1
     902:	854a                	mv	a0,s2
     904:	3c4000ef          	jal	cc8 <open>
     908:	00054663          	bltz	a0,914 <main+0x32>
    if(fd >= 3){
     90c:	fea4dae3          	bge	s1,a0,900 <main+0x1e>
      close(fd);
     910:	3a0000ef          	jal	cb0 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     914:	06400993          	li	s3,100
     918:	00001917          	auipc	s2,0x1
     91c:	70890913          	addi	s2,s2,1800 # 2020 <buf.0>
    if (*cmd == '\n') // is a blank command
     920:	4a29                	li	s4,10
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     922:	06300a93          	li	s5,99
     926:	02000b13          	li	s6,32
     92a:	a039                	j	938 <main+0x56>
      if(fork1() == 0)
     92c:	f3cff0ef          	jal	68 <fork1>
     930:	c941                	beqz	a0,9c0 <main+0xde>
      wait(0);
     932:	4501                	li	a0,0
     934:	35c000ef          	jal	c90 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     938:	85ce                	mv	a1,s3
     93a:	854a                	mv	a0,s2
     93c:	ec4ff0ef          	jal	0 <getcmd>
     940:	08054563          	bltz	a0,9ca <main+0xe8>
    while (*cmd == ' ' || *cmd == '\t')
     944:	00094783          	lbu	a5,0(s2)
     948:	fe078713          	addi	a4,a5,-32
     94c:	cb01                	beqz	a4,95c <main+0x7a>
     94e:	ff778713          	addi	a4,a5,-9
    char *cmd = buf;
     952:	00001497          	auipc	s1,0x1
     956:	6ce48493          	addi	s1,s1,1742 # 2020 <buf.0>
    while (*cmd == ' ' || *cmd == '\t')
     95a:	ef11                	bnez	a4,976 <main+0x94>
    char *cmd = buf;
     95c:	00001497          	auipc	s1,0x1
     960:	6c448493          	addi	s1,s1,1732 # 2020 <buf.0>
      cmd++;
     964:	0485                	addi	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     966:	0004c783          	lbu	a5,0(s1)
     96a:	fe078713          	addi	a4,a5,-32
     96e:	db7d                	beqz	a4,964 <main+0x82>
     970:	ff778713          	addi	a4,a5,-9
     974:	db65                	beqz	a4,964 <main+0x82>
    if (*cmd == '\n') // is a blank command
     976:	fd4781e3          	beq	a5,s4,938 <main+0x56>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     97a:	fb5799e3          	bne	a5,s5,92c <main+0x4a>
     97e:	0014c783          	lbu	a5,1(s1)
     982:	fb3795e3          	bne	a5,s3,92c <main+0x4a>
     986:	0024c783          	lbu	a5,2(s1)
     98a:	fb6791e3          	bne	a5,s6,92c <main+0x4a>
      cmd[strlen(cmd)-1] = 0;  // chop \n
     98e:	8526                	mv	a0,s1
     990:	0a2000ef          	jal	a32 <strlen>
     994:	fff5079b          	addiw	a5,a0,-1
     998:	1782                	slli	a5,a5,0x20
     99a:	9381                	srli	a5,a5,0x20
     99c:	97a6                	add	a5,a5,s1
     99e:	00078023          	sb	zero,0(a5)
      if(chdir(cmd+3) < 0)
     9a2:	048d                	addi	s1,s1,3
     9a4:	8526                	mv	a0,s1
     9a6:	352000ef          	jal	cf8 <chdir>
     9aa:	f80557e3          	bgez	a0,938 <main+0x56>
        fprintf(2, "cannot cd %s\n", cmd+3);
     9ae:	8626                	mv	a2,s1
     9b0:	00001597          	auipc	a1,0x1
     9b4:	9e058593          	addi	a1,a1,-1568 # 1390 <malloc+0x1fc>
     9b8:	4509                	li	a0,2
     9ba:	6f8000ef          	jal	10b2 <fprintf>
     9be:	bfad                	j	938 <main+0x56>
        runcmd(parsecmd(cmd));
     9c0:	8526                	mv	a0,s1
     9c2:	eadff0ef          	jal	86e <parsecmd>
     9c6:	ec8ff0ef          	jal	8e <runcmd>
  exit(0);
     9ca:	4501                	li	a0,0
     9cc:	2bc000ef          	jal	c88 <exit>

00000000000009d0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     9d0:	1141                	addi	sp,sp,-16
     9d2:	e406                	sd	ra,8(sp)
     9d4:	e022                	sd	s0,0(sp)
     9d6:	0800                	addi	s0,sp,16
  extern int main();
  main();
     9d8:	f0bff0ef          	jal	8e2 <main>
  exit(0);
     9dc:	4501                	li	a0,0
     9de:	2aa000ef          	jal	c88 <exit>

00000000000009e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9e2:	1141                	addi	sp,sp,-16
     9e4:	e406                	sd	ra,8(sp)
     9e6:	e022                	sd	s0,0(sp)
     9e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9ea:	87aa                	mv	a5,a0
     9ec:	0585                	addi	a1,a1,1
     9ee:	0785                	addi	a5,a5,1
     9f0:	fff5c703          	lbu	a4,-1(a1)
     9f4:	fee78fa3          	sb	a4,-1(a5)
     9f8:	fb75                	bnez	a4,9ec <strcpy+0xa>
    ;
  return os;
}
     9fa:	60a2                	ld	ra,8(sp)
     9fc:	6402                	ld	s0,0(sp)
     9fe:	0141                	addi	sp,sp,16
     a00:	8082                	ret

0000000000000a02 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a02:	1141                	addi	sp,sp,-16
     a04:	e406                	sd	ra,8(sp)
     a06:	e022                	sd	s0,0(sp)
     a08:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     a0a:	00054783          	lbu	a5,0(a0)
     a0e:	cb91                	beqz	a5,a22 <strcmp+0x20>
     a10:	0005c703          	lbu	a4,0(a1)
     a14:	00f71763          	bne	a4,a5,a22 <strcmp+0x20>
    p++, q++;
     a18:	0505                	addi	a0,a0,1
     a1a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a1c:	00054783          	lbu	a5,0(a0)
     a20:	fbe5                	bnez	a5,a10 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a22:	0005c503          	lbu	a0,0(a1)
}
     a26:	40a7853b          	subw	a0,a5,a0
     a2a:	60a2                	ld	ra,8(sp)
     a2c:	6402                	ld	s0,0(sp)
     a2e:	0141                	addi	sp,sp,16
     a30:	8082                	ret

0000000000000a32 <strlen>:

uint
strlen(const char *s)
{
     a32:	1141                	addi	sp,sp,-16
     a34:	e406                	sd	ra,8(sp)
     a36:	e022                	sd	s0,0(sp)
     a38:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a3a:	00054783          	lbu	a5,0(a0)
     a3e:	cf91                	beqz	a5,a5a <strlen+0x28>
     a40:	00150793          	addi	a5,a0,1
     a44:	86be                	mv	a3,a5
     a46:	0785                	addi	a5,a5,1
     a48:	fff7c703          	lbu	a4,-1(a5)
     a4c:	ff65                	bnez	a4,a44 <strlen+0x12>
     a4e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     a52:	60a2                	ld	ra,8(sp)
     a54:	6402                	ld	s0,0(sp)
     a56:	0141                	addi	sp,sp,16
     a58:	8082                	ret
  for(n = 0; s[n]; n++)
     a5a:	4501                	li	a0,0
     a5c:	bfdd                	j	a52 <strlen+0x20>

0000000000000a5e <memset>:

void*
memset(void *dst, int c, uint n)
{
     a5e:	1141                	addi	sp,sp,-16
     a60:	e406                	sd	ra,8(sp)
     a62:	e022                	sd	s0,0(sp)
     a64:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a66:	ca19                	beqz	a2,a7c <memset+0x1e>
     a68:	87aa                	mv	a5,a0
     a6a:	1602                	slli	a2,a2,0x20
     a6c:	9201                	srli	a2,a2,0x20
     a6e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a72:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a76:	0785                	addi	a5,a5,1
     a78:	fee79de3          	bne	a5,a4,a72 <memset+0x14>
  }
  return dst;
}
     a7c:	60a2                	ld	ra,8(sp)
     a7e:	6402                	ld	s0,0(sp)
     a80:	0141                	addi	sp,sp,16
     a82:	8082                	ret

0000000000000a84 <strchr>:

char*
strchr(const char *s, char c)
{
     a84:	1141                	addi	sp,sp,-16
     a86:	e406                	sd	ra,8(sp)
     a88:	e022                	sd	s0,0(sp)
     a8a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a8c:	00054783          	lbu	a5,0(a0)
     a90:	cf81                	beqz	a5,aa8 <strchr+0x24>
    if(*s == c)
     a92:	00f58763          	beq	a1,a5,aa0 <strchr+0x1c>
  for(; *s; s++)
     a96:	0505                	addi	a0,a0,1
     a98:	00054783          	lbu	a5,0(a0)
     a9c:	fbfd                	bnez	a5,a92 <strchr+0xe>
      return (char*)s;
  return 0;
     a9e:	4501                	li	a0,0
}
     aa0:	60a2                	ld	ra,8(sp)
     aa2:	6402                	ld	s0,0(sp)
     aa4:	0141                	addi	sp,sp,16
     aa6:	8082                	ret
  return 0;
     aa8:	4501                	li	a0,0
     aaa:	bfdd                	j	aa0 <strchr+0x1c>

0000000000000aac <gets>:

char*
gets(char *buf, int max)
{
     aac:	711d                	addi	sp,sp,-96
     aae:	ec86                	sd	ra,88(sp)
     ab0:	e8a2                	sd	s0,80(sp)
     ab2:	e4a6                	sd	s1,72(sp)
     ab4:	e0ca                	sd	s2,64(sp)
     ab6:	fc4e                	sd	s3,56(sp)
     ab8:	f852                	sd	s4,48(sp)
     aba:	f456                	sd	s5,40(sp)
     abc:	f05a                	sd	s6,32(sp)
     abe:	ec5e                	sd	s7,24(sp)
     ac0:	e862                	sd	s8,16(sp)
     ac2:	1080                	addi	s0,sp,96
     ac4:	8baa                	mv	s7,a0
     ac6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ac8:	892a                	mv	s2,a0
     aca:	4481                	li	s1,0
    cc = read(0, &c, 1);
     acc:	faf40b13          	addi	s6,s0,-81
     ad0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     ad2:	8c26                	mv	s8,s1
     ad4:	0014899b          	addiw	s3,s1,1
     ad8:	84ce                	mv	s1,s3
     ada:	0349d463          	bge	s3,s4,b02 <gets+0x56>
    cc = read(0, &c, 1);
     ade:	8656                	mv	a2,s5
     ae0:	85da                	mv	a1,s6
     ae2:	4501                	li	a0,0
     ae4:	1bc000ef          	jal	ca0 <read>
    if(cc < 1)
     ae8:	00a05d63          	blez	a0,b02 <gets+0x56>
      break;
    buf[i++] = c;
     aec:	faf44783          	lbu	a5,-81(s0)
     af0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     af4:	0905                	addi	s2,s2,1
     af6:	ff678713          	addi	a4,a5,-10
     afa:	c319                	beqz	a4,b00 <gets+0x54>
     afc:	17cd                	addi	a5,a5,-13
     afe:	fbf1                	bnez	a5,ad2 <gets+0x26>
    buf[i++] = c;
     b00:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     b02:	9c5e                	add	s8,s8,s7
     b04:	000c0023          	sb	zero,0(s8)
  return buf;
}
     b08:	855e                	mv	a0,s7
     b0a:	60e6                	ld	ra,88(sp)
     b0c:	6446                	ld	s0,80(sp)
     b0e:	64a6                	ld	s1,72(sp)
     b10:	6906                	ld	s2,64(sp)
     b12:	79e2                	ld	s3,56(sp)
     b14:	7a42                	ld	s4,48(sp)
     b16:	7aa2                	ld	s5,40(sp)
     b18:	7b02                	ld	s6,32(sp)
     b1a:	6be2                	ld	s7,24(sp)
     b1c:	6c42                	ld	s8,16(sp)
     b1e:	6125                	addi	sp,sp,96
     b20:	8082                	ret

0000000000000b22 <stat>:

int
stat(const char *n, struct stat *st)
{
     b22:	1101                	addi	sp,sp,-32
     b24:	ec06                	sd	ra,24(sp)
     b26:	e822                	sd	s0,16(sp)
     b28:	e04a                	sd	s2,0(sp)
     b2a:	1000                	addi	s0,sp,32
     b2c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b2e:	4581                	li	a1,0
     b30:	198000ef          	jal	cc8 <open>
  if(fd < 0)
     b34:	02054263          	bltz	a0,b58 <stat+0x36>
     b38:	e426                	sd	s1,8(sp)
     b3a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b3c:	85ca                	mv	a1,s2
     b3e:	1a2000ef          	jal	ce0 <fstat>
     b42:	892a                	mv	s2,a0
  close(fd);
     b44:	8526                	mv	a0,s1
     b46:	16a000ef          	jal	cb0 <close>
  return r;
     b4a:	64a2                	ld	s1,8(sp)
}
     b4c:	854a                	mv	a0,s2
     b4e:	60e2                	ld	ra,24(sp)
     b50:	6442                	ld	s0,16(sp)
     b52:	6902                	ld	s2,0(sp)
     b54:	6105                	addi	sp,sp,32
     b56:	8082                	ret
    return -1;
     b58:	57fd                	li	a5,-1
     b5a:	893e                	mv	s2,a5
     b5c:	bfc5                	j	b4c <stat+0x2a>

0000000000000b5e <atoi>:

int
atoi(const char *s)
{
     b5e:	1141                	addi	sp,sp,-16
     b60:	e406                	sd	ra,8(sp)
     b62:	e022                	sd	s0,0(sp)
     b64:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b66:	00054683          	lbu	a3,0(a0)
     b6a:	fd06879b          	addiw	a5,a3,-48
     b6e:	0ff7f793          	zext.b	a5,a5
     b72:	4625                	li	a2,9
     b74:	02f66963          	bltu	a2,a5,ba6 <atoi+0x48>
     b78:	872a                	mv	a4,a0
  n = 0;
     b7a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b7c:	0705                	addi	a4,a4,1
     b7e:	0025179b          	slliw	a5,a0,0x2
     b82:	9fa9                	addw	a5,a5,a0
     b84:	0017979b          	slliw	a5,a5,0x1
     b88:	9fb5                	addw	a5,a5,a3
     b8a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b8e:	00074683          	lbu	a3,0(a4)
     b92:	fd06879b          	addiw	a5,a3,-48
     b96:	0ff7f793          	zext.b	a5,a5
     b9a:	fef671e3          	bgeu	a2,a5,b7c <atoi+0x1e>
  return n;
}
     b9e:	60a2                	ld	ra,8(sp)
     ba0:	6402                	ld	s0,0(sp)
     ba2:	0141                	addi	sp,sp,16
     ba4:	8082                	ret
  n = 0;
     ba6:	4501                	li	a0,0
     ba8:	bfdd                	j	b9e <atoi+0x40>

0000000000000baa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     baa:	1141                	addi	sp,sp,-16
     bac:	e406                	sd	ra,8(sp)
     bae:	e022                	sd	s0,0(sp)
     bb0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     bb2:	02b57563          	bgeu	a0,a1,bdc <memmove+0x32>
    while(n-- > 0)
     bb6:	00c05f63          	blez	a2,bd4 <memmove+0x2a>
     bba:	1602                	slli	a2,a2,0x20
     bbc:	9201                	srli	a2,a2,0x20
     bbe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bc2:	872a                	mv	a4,a0
      *dst++ = *src++;
     bc4:	0585                	addi	a1,a1,1
     bc6:	0705                	addi	a4,a4,1
     bc8:	fff5c683          	lbu	a3,-1(a1)
     bcc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     bd0:	fee79ae3          	bne	a5,a4,bc4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bd4:	60a2                	ld	ra,8(sp)
     bd6:	6402                	ld	s0,0(sp)
     bd8:	0141                	addi	sp,sp,16
     bda:	8082                	ret
    while(n-- > 0)
     bdc:	fec05ce3          	blez	a2,bd4 <memmove+0x2a>
    dst += n;
     be0:	00c50733          	add	a4,a0,a2
    src += n;
     be4:	95b2                	add	a1,a1,a2
     be6:	fff6079b          	addiw	a5,a2,-1
     bea:	1782                	slli	a5,a5,0x20
     bec:	9381                	srli	a5,a5,0x20
     bee:	fff7c793          	not	a5,a5
     bf2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bf4:	15fd                	addi	a1,a1,-1
     bf6:	177d                	addi	a4,a4,-1
     bf8:	0005c683          	lbu	a3,0(a1)
     bfc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     c00:	fef71ae3          	bne	a4,a5,bf4 <memmove+0x4a>
     c04:	bfc1                	j	bd4 <memmove+0x2a>

0000000000000c06 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     c06:	1141                	addi	sp,sp,-16
     c08:	e406                	sd	ra,8(sp)
     c0a:	e022                	sd	s0,0(sp)
     c0c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c0e:	c61d                	beqz	a2,c3c <memcmp+0x36>
     c10:	1602                	slli	a2,a2,0x20
     c12:	9201                	srli	a2,a2,0x20
     c14:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     c18:	00054783          	lbu	a5,0(a0)
     c1c:	0005c703          	lbu	a4,0(a1)
     c20:	00e79863          	bne	a5,a4,c30 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     c24:	0505                	addi	a0,a0,1
    p2++;
     c26:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c28:	fed518e3          	bne	a0,a3,c18 <memcmp+0x12>
  }
  return 0;
     c2c:	4501                	li	a0,0
     c2e:	a019                	j	c34 <memcmp+0x2e>
      return *p1 - *p2;
     c30:	40e7853b          	subw	a0,a5,a4
}
     c34:	60a2                	ld	ra,8(sp)
     c36:	6402                	ld	s0,0(sp)
     c38:	0141                	addi	sp,sp,16
     c3a:	8082                	ret
  return 0;
     c3c:	4501                	li	a0,0
     c3e:	bfdd                	j	c34 <memcmp+0x2e>

0000000000000c40 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c40:	1141                	addi	sp,sp,-16
     c42:	e406                	sd	ra,8(sp)
     c44:	e022                	sd	s0,0(sp)
     c46:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c48:	f63ff0ef          	jal	baa <memmove>
}
     c4c:	60a2                	ld	ra,8(sp)
     c4e:	6402                	ld	s0,0(sp)
     c50:	0141                	addi	sp,sp,16
     c52:	8082                	ret

0000000000000c54 <sbrk>:

char *
sbrk(int n) {
     c54:	1141                	addi	sp,sp,-16
     c56:	e406                	sd	ra,8(sp)
     c58:	e022                	sd	s0,0(sp)
     c5a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c5c:	4585                	li	a1,1
     c5e:	0b2000ef          	jal	d10 <sys_sbrk>
}
     c62:	60a2                	ld	ra,8(sp)
     c64:	6402                	ld	s0,0(sp)
     c66:	0141                	addi	sp,sp,16
     c68:	8082                	ret

0000000000000c6a <sbrklazy>:

char *
sbrklazy(int n) {
     c6a:	1141                	addi	sp,sp,-16
     c6c:	e406                	sd	ra,8(sp)
     c6e:	e022                	sd	s0,0(sp)
     c70:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c72:	4589                	li	a1,2
     c74:	09c000ef          	jal	d10 <sys_sbrk>
}
     c78:	60a2                	ld	ra,8(sp)
     c7a:	6402                	ld	s0,0(sp)
     c7c:	0141                	addi	sp,sp,16
     c7e:	8082                	ret

0000000000000c80 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c80:	4885                	li	a7,1
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c88:	4889                	li	a7,2
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c90:	488d                	li	a7,3
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c98:	4891                	li	a7,4
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <read>:
.global read
read:
 li a7, SYS_read
     ca0:	4895                	li	a7,5
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <write>:
.global write
write:
 li a7, SYS_write
     ca8:	48c1                	li	a7,16
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <close>:
.global close
close:
 li a7, SYS_close
     cb0:	48d5                	li	a7,21
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <kill>:
.global kill
kill:
 li a7, SYS_kill
     cb8:	4899                	li	a7,6
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <exec>:
.global exec
exec:
 li a7, SYS_exec
     cc0:	489d                	li	a7,7
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <open>:
.global open
open:
 li a7, SYS_open
     cc8:	48bd                	li	a7,15
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cd0:	48c5                	li	a7,17
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cd8:	48c9                	li	a7,18
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ce0:	48a1                	li	a7,8
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <link>:
.global link
link:
 li a7, SYS_link
     ce8:	48cd                	li	a7,19
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cf0:	48d1                	li	a7,20
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cf8:	48a5                	li	a7,9
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <dup>:
.global dup
dup:
 li a7, SYS_dup
     d00:	48a9                	li	a7,10
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d08:	48ad                	li	a7,11
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     d10:	48b1                	li	a7,12
 ecall
     d12:	00000073          	ecall
 ret
     d16:	8082                	ret

0000000000000d18 <pause>:
.global pause
pause:
 li a7, SYS_pause
     d18:	48b5                	li	a7,13
 ecall
     d1a:	00000073          	ecall
 ret
     d1e:	8082                	ret

0000000000000d20 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d20:	48b9                	li	a7,14
 ecall
     d22:	00000073          	ecall
 ret
     d26:	8082                	ret

0000000000000d28 <buddytest>:
.global buddytest
buddytest:
 li a7, SYS_buddytest
     d28:	48d9                	li	a7,22
 ecall
     d2a:	00000073          	ecall
 ret
     d2e:	8082                	ret

0000000000000d30 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d30:	1101                	addi	sp,sp,-32
     d32:	ec06                	sd	ra,24(sp)
     d34:	e822                	sd	s0,16(sp)
     d36:	1000                	addi	s0,sp,32
     d38:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d3c:	4605                	li	a2,1
     d3e:	fef40593          	addi	a1,s0,-17
     d42:	f67ff0ef          	jal	ca8 <write>
}
     d46:	60e2                	ld	ra,24(sp)
     d48:	6442                	ld	s0,16(sp)
     d4a:	6105                	addi	sp,sp,32
     d4c:	8082                	ret

0000000000000d4e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d4e:	715d                	addi	sp,sp,-80
     d50:	e486                	sd	ra,72(sp)
     d52:	e0a2                	sd	s0,64(sp)
     d54:	f84a                	sd	s2,48(sp)
     d56:	f44e                	sd	s3,40(sp)
     d58:	0880                	addi	s0,sp,80
     d5a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     d5c:	cac1                	beqz	a3,dec <printint+0x9e>
     d5e:	0805d763          	bgez	a1,dec <printint+0x9e>
    neg = 1;
    x = -xx;
     d62:	40b005bb          	negw	a1,a1
    neg = 1;
     d66:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d68:	fb840993          	addi	s3,s0,-72
  neg = 0;
     d6c:	86ce                	mv	a3,s3
  i = 0;
     d6e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d70:	00000817          	auipc	a6,0x0
     d74:	66880813          	addi	a6,a6,1640 # 13d8 <digits>
     d78:	88ba                	mv	a7,a4
     d7a:	0017051b          	addiw	a0,a4,1
     d7e:	872a                	mv	a4,a0
     d80:	02c5f7bb          	remuw	a5,a1,a2
     d84:	1782                	slli	a5,a5,0x20
     d86:	9381                	srli	a5,a5,0x20
     d88:	97c2                	add	a5,a5,a6
     d8a:	0007c783          	lbu	a5,0(a5)
     d8e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d92:	87ae                	mv	a5,a1
     d94:	02c5d5bb          	divuw	a1,a1,a2
     d98:	0685                	addi	a3,a3,1
     d9a:	fcc7ffe3          	bgeu	a5,a2,d78 <printint+0x2a>
  if(neg)
     d9e:	00030c63          	beqz	t1,db6 <printint+0x68>
    buf[i++] = '-';
     da2:	fd050793          	addi	a5,a0,-48
     da6:	00878533          	add	a0,a5,s0
     daa:	02d00793          	li	a5,45
     dae:	fef50423          	sb	a5,-24(a0)
     db2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     db6:	02e05563          	blez	a4,de0 <printint+0x92>
     dba:	fc26                	sd	s1,56(sp)
     dbc:	377d                	addiw	a4,a4,-1
     dbe:	00e984b3          	add	s1,s3,a4
     dc2:	19fd                	addi	s3,s3,-1
     dc4:	99ba                	add	s3,s3,a4
     dc6:	1702                	slli	a4,a4,0x20
     dc8:	9301                	srli	a4,a4,0x20
     dca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     dce:	0004c583          	lbu	a1,0(s1)
     dd2:	854a                	mv	a0,s2
     dd4:	f5dff0ef          	jal	d30 <putc>
  while(--i >= 0)
     dd8:	14fd                	addi	s1,s1,-1
     dda:	ff349ae3          	bne	s1,s3,dce <printint+0x80>
     dde:	74e2                	ld	s1,56(sp)
}
     de0:	60a6                	ld	ra,72(sp)
     de2:	6406                	ld	s0,64(sp)
     de4:	7942                	ld	s2,48(sp)
     de6:	79a2                	ld	s3,40(sp)
     de8:	6161                	addi	sp,sp,80
     dea:	8082                	ret
    x = xx;
     dec:	2581                	sext.w	a1,a1
  neg = 0;
     dee:	4301                	li	t1,0
     df0:	bfa5                	j	d68 <printint+0x1a>

0000000000000df2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     df2:	711d                	addi	sp,sp,-96
     df4:	ec86                	sd	ra,88(sp)
     df6:	e8a2                	sd	s0,80(sp)
     df8:	e4a6                	sd	s1,72(sp)
     dfa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dfc:	0005c483          	lbu	s1,0(a1)
     e00:	22048363          	beqz	s1,1026 <vprintf+0x234>
     e04:	e0ca                	sd	s2,64(sp)
     e06:	fc4e                	sd	s3,56(sp)
     e08:	f852                	sd	s4,48(sp)
     e0a:	f456                	sd	s5,40(sp)
     e0c:	f05a                	sd	s6,32(sp)
     e0e:	ec5e                	sd	s7,24(sp)
     e10:	e862                	sd	s8,16(sp)
     e12:	8b2a                	mv	s6,a0
     e14:	8a2e                	mv	s4,a1
     e16:	8bb2                	mv	s7,a2
  state = 0;
     e18:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e1a:	4901                	li	s2,0
     e1c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e1e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e22:	06400c13          	li	s8,100
     e26:	a00d                	j	e48 <vprintf+0x56>
        putc(fd, c0);
     e28:	85a6                	mv	a1,s1
     e2a:	855a                	mv	a0,s6
     e2c:	f05ff0ef          	jal	d30 <putc>
     e30:	a019                	j	e36 <vprintf+0x44>
    } else if(state == '%'){
     e32:	03598363          	beq	s3,s5,e58 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     e36:	0019079b          	addiw	a5,s2,1
     e3a:	893e                	mv	s2,a5
     e3c:	873e                	mv	a4,a5
     e3e:	97d2                	add	a5,a5,s4
     e40:	0007c483          	lbu	s1,0(a5)
     e44:	1c048a63          	beqz	s1,1018 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     e48:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e4c:	fe0993e3          	bnez	s3,e32 <vprintf+0x40>
      if(c0 == '%'){
     e50:	fd579ce3          	bne	a5,s5,e28 <vprintf+0x36>
        state = '%';
     e54:	89be                	mv	s3,a5
     e56:	b7c5                	j	e36 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     e58:	00ea06b3          	add	a3,s4,a4
     e5c:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     e60:	1c060863          	beqz	a2,1030 <vprintf+0x23e>
      if(c0 == 'd'){
     e64:	03878763          	beq	a5,s8,e92 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e68:	f9478693          	addi	a3,a5,-108
     e6c:	0016b693          	seqz	a3,a3
     e70:	f9c60593          	addi	a1,a2,-100
     e74:	e99d                	bnez	a1,eaa <vprintf+0xb8>
     e76:	ca95                	beqz	a3,eaa <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e78:	008b8493          	addi	s1,s7,8
     e7c:	4685                	li	a3,1
     e7e:	4629                	li	a2,10
     e80:	000bb583          	ld	a1,0(s7)
     e84:	855a                	mv	a0,s6
     e86:	ec9ff0ef          	jal	d4e <printint>
        i += 1;
     e8a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e8c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e8e:	4981                	li	s3,0
     e90:	b75d                	j	e36 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     e92:	008b8493          	addi	s1,s7,8
     e96:	4685                	li	a3,1
     e98:	4629                	li	a2,10
     e9a:	000ba583          	lw	a1,0(s7)
     e9e:	855a                	mv	a0,s6
     ea0:	eafff0ef          	jal	d4e <printint>
     ea4:	8ba6                	mv	s7,s1
      state = 0;
     ea6:	4981                	li	s3,0
     ea8:	b779                	j	e36 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     eaa:	9752                	add	a4,a4,s4
     eac:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     eb0:	f9460713          	addi	a4,a2,-108
     eb4:	00173713          	seqz	a4,a4
     eb8:	8f75                	and	a4,a4,a3
     eba:	f9c58513          	addi	a0,a1,-100
     ebe:	18051363          	bnez	a0,1044 <vprintf+0x252>
     ec2:	18070163          	beqz	a4,1044 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ec6:	008b8493          	addi	s1,s7,8
     eca:	4685                	li	a3,1
     ecc:	4629                	li	a2,10
     ece:	000bb583          	ld	a1,0(s7)
     ed2:	855a                	mv	a0,s6
     ed4:	e7bff0ef          	jal	d4e <printint>
        i += 2;
     ed8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     eda:	8ba6                	mv	s7,s1
      state = 0;
     edc:	4981                	li	s3,0
        i += 2;
     ede:	bfa1                	j	e36 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     ee0:	008b8493          	addi	s1,s7,8
     ee4:	4681                	li	a3,0
     ee6:	4629                	li	a2,10
     ee8:	000be583          	lwu	a1,0(s7)
     eec:	855a                	mv	a0,s6
     eee:	e61ff0ef          	jal	d4e <printint>
     ef2:	8ba6                	mv	s7,s1
      state = 0;
     ef4:	4981                	li	s3,0
     ef6:	b781                	j	e36 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ef8:	008b8493          	addi	s1,s7,8
     efc:	4681                	li	a3,0
     efe:	4629                	li	a2,10
     f00:	000bb583          	ld	a1,0(s7)
     f04:	855a                	mv	a0,s6
     f06:	e49ff0ef          	jal	d4e <printint>
        i += 1;
     f0a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f0c:	8ba6                	mv	s7,s1
      state = 0;
     f0e:	4981                	li	s3,0
     f10:	b71d                	j	e36 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f12:	008b8493          	addi	s1,s7,8
     f16:	4681                	li	a3,0
     f18:	4629                	li	a2,10
     f1a:	000bb583          	ld	a1,0(s7)
     f1e:	855a                	mv	a0,s6
     f20:	e2fff0ef          	jal	d4e <printint>
        i += 2;
     f24:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f26:	8ba6                	mv	s7,s1
      state = 0;
     f28:	4981                	li	s3,0
        i += 2;
     f2a:	b731                	j	e36 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f2c:	008b8493          	addi	s1,s7,8
     f30:	4681                	li	a3,0
     f32:	4641                	li	a2,16
     f34:	000be583          	lwu	a1,0(s7)
     f38:	855a                	mv	a0,s6
     f3a:	e15ff0ef          	jal	d4e <printint>
     f3e:	8ba6                	mv	s7,s1
      state = 0;
     f40:	4981                	li	s3,0
     f42:	bdd5                	j	e36 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f44:	008b8493          	addi	s1,s7,8
     f48:	4681                	li	a3,0
     f4a:	4641                	li	a2,16
     f4c:	000bb583          	ld	a1,0(s7)
     f50:	855a                	mv	a0,s6
     f52:	dfdff0ef          	jal	d4e <printint>
        i += 1;
     f56:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f58:	8ba6                	mv	s7,s1
      state = 0;
     f5a:	4981                	li	s3,0
     f5c:	bde9                	j	e36 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f5e:	008b8493          	addi	s1,s7,8
     f62:	4681                	li	a3,0
     f64:	4641                	li	a2,16
     f66:	000bb583          	ld	a1,0(s7)
     f6a:	855a                	mv	a0,s6
     f6c:	de3ff0ef          	jal	d4e <printint>
        i += 2;
     f70:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f72:	8ba6                	mv	s7,s1
      state = 0;
     f74:	4981                	li	s3,0
        i += 2;
     f76:	b5c1                	j	e36 <vprintf+0x44>
     f78:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     f7a:	008b8793          	addi	a5,s7,8
     f7e:	8cbe                	mv	s9,a5
     f80:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f84:	03000593          	li	a1,48
     f88:	855a                	mv	a0,s6
     f8a:	da7ff0ef          	jal	d30 <putc>
  putc(fd, 'x');
     f8e:	07800593          	li	a1,120
     f92:	855a                	mv	a0,s6
     f94:	d9dff0ef          	jal	d30 <putc>
     f98:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f9a:	00000b97          	auipc	s7,0x0
     f9e:	43eb8b93          	addi	s7,s7,1086 # 13d8 <digits>
     fa2:	03c9d793          	srli	a5,s3,0x3c
     fa6:	97de                	add	a5,a5,s7
     fa8:	0007c583          	lbu	a1,0(a5)
     fac:	855a                	mv	a0,s6
     fae:	d83ff0ef          	jal	d30 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fb2:	0992                	slli	s3,s3,0x4
     fb4:	34fd                	addiw	s1,s1,-1
     fb6:	f4f5                	bnez	s1,fa2 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     fb8:	8be6                	mv	s7,s9
      state = 0;
     fba:	4981                	li	s3,0
     fbc:	6ca2                	ld	s9,8(sp)
     fbe:	bda5                	j	e36 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     fc0:	008b8493          	addi	s1,s7,8
     fc4:	000bc583          	lbu	a1,0(s7)
     fc8:	855a                	mv	a0,s6
     fca:	d67ff0ef          	jal	d30 <putc>
     fce:	8ba6                	mv	s7,s1
      state = 0;
     fd0:	4981                	li	s3,0
     fd2:	b595                	j	e36 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     fd4:	008b8993          	addi	s3,s7,8
     fd8:	000bb483          	ld	s1,0(s7)
     fdc:	cc91                	beqz	s1,ff8 <vprintf+0x206>
        for(; *s; s++)
     fde:	0004c583          	lbu	a1,0(s1)
     fe2:	c985                	beqz	a1,1012 <vprintf+0x220>
          putc(fd, *s);
     fe4:	855a                	mv	a0,s6
     fe6:	d4bff0ef          	jal	d30 <putc>
        for(; *s; s++)
     fea:	0485                	addi	s1,s1,1
     fec:	0004c583          	lbu	a1,0(s1)
     ff0:	f9f5                	bnez	a1,fe4 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     ff2:	8bce                	mv	s7,s3
      state = 0;
     ff4:	4981                	li	s3,0
     ff6:	b581                	j	e36 <vprintf+0x44>
          s = "(null)";
     ff8:	00000497          	auipc	s1,0x0
     ffc:	3a848493          	addi	s1,s1,936 # 13a0 <malloc+0x20c>
        for(; *s; s++)
    1000:	02800593          	li	a1,40
    1004:	b7c5                	j	fe4 <vprintf+0x1f2>
        putc(fd, '%');
    1006:	85be                	mv	a1,a5
    1008:	855a                	mv	a0,s6
    100a:	d27ff0ef          	jal	d30 <putc>
      state = 0;
    100e:	4981                	li	s3,0
    1010:	b51d                	j	e36 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    1012:	8bce                	mv	s7,s3
      state = 0;
    1014:	4981                	li	s3,0
    1016:	b505                	j	e36 <vprintf+0x44>
    1018:	6906                	ld	s2,64(sp)
    101a:	79e2                	ld	s3,56(sp)
    101c:	7a42                	ld	s4,48(sp)
    101e:	7aa2                	ld	s5,40(sp)
    1020:	7b02                	ld	s6,32(sp)
    1022:	6be2                	ld	s7,24(sp)
    1024:	6c42                	ld	s8,16(sp)
    }
  }
}
    1026:	60e6                	ld	ra,88(sp)
    1028:	6446                	ld	s0,80(sp)
    102a:	64a6                	ld	s1,72(sp)
    102c:	6125                	addi	sp,sp,96
    102e:	8082                	ret
      if(c0 == 'd'){
    1030:	06400713          	li	a4,100
    1034:	e4e78fe3          	beq	a5,a4,e92 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    1038:	f9478693          	addi	a3,a5,-108
    103c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    1040:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1042:	4701                	li	a4,0
      } else if(c0 == 'u'){
    1044:	07500513          	li	a0,117
    1048:	e8a78ce3          	beq	a5,a0,ee0 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    104c:	f8b60513          	addi	a0,a2,-117
    1050:	e119                	bnez	a0,1056 <vprintf+0x264>
    1052:	ea0693e3          	bnez	a3,ef8 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1056:	f8b58513          	addi	a0,a1,-117
    105a:	e119                	bnez	a0,1060 <vprintf+0x26e>
    105c:	ea071be3          	bnez	a4,f12 <vprintf+0x120>
      } else if(c0 == 'x'){
    1060:	07800513          	li	a0,120
    1064:	eca784e3          	beq	a5,a0,f2c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    1068:	f8860613          	addi	a2,a2,-120
    106c:	e219                	bnez	a2,1072 <vprintf+0x280>
    106e:	ec069be3          	bnez	a3,f44 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1072:	f8858593          	addi	a1,a1,-120
    1076:	e199                	bnez	a1,107c <vprintf+0x28a>
    1078:	ee0713e3          	bnez	a4,f5e <vprintf+0x16c>
      } else if(c0 == 'p'){
    107c:	07000713          	li	a4,112
    1080:	eee78ce3          	beq	a5,a4,f78 <vprintf+0x186>
      } else if(c0 == 'c'){
    1084:	06300713          	li	a4,99
    1088:	f2e78ce3          	beq	a5,a4,fc0 <vprintf+0x1ce>
      } else if(c0 == 's'){
    108c:	07300713          	li	a4,115
    1090:	f4e782e3          	beq	a5,a4,fd4 <vprintf+0x1e2>
      } else if(c0 == '%'){
    1094:	02500713          	li	a4,37
    1098:	f6e787e3          	beq	a5,a4,1006 <vprintf+0x214>
        putc(fd, '%');
    109c:	02500593          	li	a1,37
    10a0:	855a                	mv	a0,s6
    10a2:	c8fff0ef          	jal	d30 <putc>
        putc(fd, c0);
    10a6:	85a6                	mv	a1,s1
    10a8:	855a                	mv	a0,s6
    10aa:	c87ff0ef          	jal	d30 <putc>
      state = 0;
    10ae:	4981                	li	s3,0
    10b0:	b359                	j	e36 <vprintf+0x44>

00000000000010b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    10b2:	715d                	addi	sp,sp,-80
    10b4:	ec06                	sd	ra,24(sp)
    10b6:	e822                	sd	s0,16(sp)
    10b8:	1000                	addi	s0,sp,32
    10ba:	e010                	sd	a2,0(s0)
    10bc:	e414                	sd	a3,8(s0)
    10be:	e818                	sd	a4,16(s0)
    10c0:	ec1c                	sd	a5,24(s0)
    10c2:	03043023          	sd	a6,32(s0)
    10c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10ca:	8622                	mv	a2,s0
    10cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10d0:	d23ff0ef          	jal	df2 <vprintf>
}
    10d4:	60e2                	ld	ra,24(sp)
    10d6:	6442                	ld	s0,16(sp)
    10d8:	6161                	addi	sp,sp,80
    10da:	8082                	ret

00000000000010dc <printf>:

void
printf(const char *fmt, ...)
{
    10dc:	711d                	addi	sp,sp,-96
    10de:	ec06                	sd	ra,24(sp)
    10e0:	e822                	sd	s0,16(sp)
    10e2:	1000                	addi	s0,sp,32
    10e4:	e40c                	sd	a1,8(s0)
    10e6:	e810                	sd	a2,16(s0)
    10e8:	ec14                	sd	a3,24(s0)
    10ea:	f018                	sd	a4,32(s0)
    10ec:	f41c                	sd	a5,40(s0)
    10ee:	03043823          	sd	a6,48(s0)
    10f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10f6:	00840613          	addi	a2,s0,8
    10fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10fe:	85aa                	mv	a1,a0
    1100:	4505                	li	a0,1
    1102:	cf1ff0ef          	jal	df2 <vprintf>
}
    1106:	60e2                	ld	ra,24(sp)
    1108:	6442                	ld	s0,16(sp)
    110a:	6125                	addi	sp,sp,96
    110c:	8082                	ret

000000000000110e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    110e:	1141                	addi	sp,sp,-16
    1110:	e406                	sd	ra,8(sp)
    1112:	e022                	sd	s0,0(sp)
    1114:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1116:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    111a:	00001797          	auipc	a5,0x1
    111e:	ef67b783          	ld	a5,-266(a5) # 2010 <freep>
    1122:	a039                	j	1130 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1124:	6398                	ld	a4,0(a5)
    1126:	00e7e463          	bltu	a5,a4,112e <free+0x20>
    112a:	00e6ea63          	bltu	a3,a4,113e <free+0x30>
{
    112e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1130:	fed7fae3          	bgeu	a5,a3,1124 <free+0x16>
    1134:	6398                	ld	a4,0(a5)
    1136:	00e6e463          	bltu	a3,a4,113e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    113a:	fee7eae3          	bltu	a5,a4,112e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    113e:	ff852583          	lw	a1,-8(a0)
    1142:	6390                	ld	a2,0(a5)
    1144:	02059813          	slli	a6,a1,0x20
    1148:	01c85713          	srli	a4,a6,0x1c
    114c:	9736                	add	a4,a4,a3
    114e:	02e60563          	beq	a2,a4,1178 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1152:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1156:	4790                	lw	a2,8(a5)
    1158:	02061593          	slli	a1,a2,0x20
    115c:	01c5d713          	srli	a4,a1,0x1c
    1160:	973e                	add	a4,a4,a5
    1162:	02e68263          	beq	a3,a4,1186 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1166:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1168:	00001717          	auipc	a4,0x1
    116c:	eaf73423          	sd	a5,-344(a4) # 2010 <freep>
}
    1170:	60a2                	ld	ra,8(sp)
    1172:	6402                	ld	s0,0(sp)
    1174:	0141                	addi	sp,sp,16
    1176:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1178:	4618                	lw	a4,8(a2)
    117a:	9f2d                	addw	a4,a4,a1
    117c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1180:	6398                	ld	a4,0(a5)
    1182:	6310                	ld	a2,0(a4)
    1184:	b7f9                	j	1152 <free+0x44>
    p->s.size += bp->s.size;
    1186:	ff852703          	lw	a4,-8(a0)
    118a:	9f31                	addw	a4,a4,a2
    118c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    118e:	ff053683          	ld	a3,-16(a0)
    1192:	bfd1                	j	1166 <free+0x58>

0000000000001194 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1194:	7139                	addi	sp,sp,-64
    1196:	fc06                	sd	ra,56(sp)
    1198:	f822                	sd	s0,48(sp)
    119a:	f04a                	sd	s2,32(sp)
    119c:	ec4e                	sd	s3,24(sp)
    119e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11a0:	02051993          	slli	s3,a0,0x20
    11a4:	0209d993          	srli	s3,s3,0x20
    11a8:	09bd                	addi	s3,s3,15
    11aa:	0049d993          	srli	s3,s3,0x4
    11ae:	2985                	addiw	s3,s3,1
    11b0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    11b2:	00001517          	auipc	a0,0x1
    11b6:	e5e53503          	ld	a0,-418(a0) # 2010 <freep>
    11ba:	c905                	beqz	a0,11ea <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11be:	4798                	lw	a4,8(a5)
    11c0:	09377663          	bgeu	a4,s3,124c <malloc+0xb8>
    11c4:	f426                	sd	s1,40(sp)
    11c6:	e852                	sd	s4,16(sp)
    11c8:	e456                	sd	s5,8(sp)
    11ca:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    11cc:	8a4e                	mv	s4,s3
    11ce:	6705                	lui	a4,0x1
    11d0:	00e9f363          	bgeu	s3,a4,11d6 <malloc+0x42>
    11d4:	6a05                	lui	s4,0x1
    11d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11de:	00001497          	auipc	s1,0x1
    11e2:	e3248493          	addi	s1,s1,-462 # 2010 <freep>
  if(p == SBRK_ERROR)
    11e6:	5afd                	li	s5,-1
    11e8:	a83d                	j	1226 <malloc+0x92>
    11ea:	f426                	sd	s1,40(sp)
    11ec:	e852                	sd	s4,16(sp)
    11ee:	e456                	sd	s5,8(sp)
    11f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11f2:	00001797          	auipc	a5,0x1
    11f6:	e9678793          	addi	a5,a5,-362 # 2088 <base>
    11fa:	00001717          	auipc	a4,0x1
    11fe:	e0f73b23          	sd	a5,-490(a4) # 2010 <freep>
    1202:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1204:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1208:	b7d1                	j	11cc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    120a:	6398                	ld	a4,0(a5)
    120c:	e118                	sd	a4,0(a0)
    120e:	a899                	j	1264 <malloc+0xd0>
  hp->s.size = nu;
    1210:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1214:	0541                	addi	a0,a0,16
    1216:	ef9ff0ef          	jal	110e <free>
  return freep;
    121a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    121c:	c125                	beqz	a0,127c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    121e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1220:	4798                	lw	a4,8(a5)
    1222:	03277163          	bgeu	a4,s2,1244 <malloc+0xb0>
    if(p == freep)
    1226:	6098                	ld	a4,0(s1)
    1228:	853e                	mv	a0,a5
    122a:	fef71ae3          	bne	a4,a5,121e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    122e:	8552                	mv	a0,s4
    1230:	a25ff0ef          	jal	c54 <sbrk>
  if(p == SBRK_ERROR)
    1234:	fd551ee3          	bne	a0,s5,1210 <malloc+0x7c>
        return 0;
    1238:	4501                	li	a0,0
    123a:	74a2                	ld	s1,40(sp)
    123c:	6a42                	ld	s4,16(sp)
    123e:	6aa2                	ld	s5,8(sp)
    1240:	6b02                	ld	s6,0(sp)
    1242:	a03d                	j	1270 <malloc+0xdc>
    1244:	74a2                	ld	s1,40(sp)
    1246:	6a42                	ld	s4,16(sp)
    1248:	6aa2                	ld	s5,8(sp)
    124a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    124c:	fae90fe3          	beq	s2,a4,120a <malloc+0x76>
        p->s.size -= nunits;
    1250:	4137073b          	subw	a4,a4,s3
    1254:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1256:	02071693          	slli	a3,a4,0x20
    125a:	01c6d713          	srli	a4,a3,0x1c
    125e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1260:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1264:	00001717          	auipc	a4,0x1
    1268:	daa73623          	sd	a0,-596(a4) # 2010 <freep>
      return (void*)(p + 1);
    126c:	01078513          	addi	a0,a5,16
  }
}
    1270:	70e2                	ld	ra,56(sp)
    1272:	7442                	ld	s0,48(sp)
    1274:	7902                	ld	s2,32(sp)
    1276:	69e2                	ld	s3,24(sp)
    1278:	6121                	addi	sp,sp,64
    127a:	8082                	ret
    127c:	74a2                	ld	s1,40(sp)
    127e:	6a42                	ld	s4,16(sp)
    1280:	6aa2                	ld	s5,8(sp)
    1282:	6b02                	ld	s6,0(sp)
    1284:	b7f5                	j	1270 <malloc+0xdc>
