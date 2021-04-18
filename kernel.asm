
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 c5 10 80       	mov    $0x8010c5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 34 10 80       	mov    $0x801034d0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 79 10 80       	push   $0x80107920
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 55 4a 00 00       	call   80104ab0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 79 10 80       	push   $0x80107927
80100097:	50                   	push   %eax
80100098:	e8 e3 48 00 00       	call   80104980 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 07 4b 00 00       	call   80104bf0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 49 4b 00 00       	call   80104cb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 48 00 00       	call   801049c0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 25 00 00       	call   80102750 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 79 10 80       	push   $0x8010792e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ad 48 00 00       	call   80104a60 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 87 25 00 00       	jmp    80102750 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 79 10 80       	push   $0x8010793f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 6c 48 00 00       	call   80104a60 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 48 00 00       	call   80104a20 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 e0 49 00 00       	call   80104bf0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 4f 4a 00 00       	jmp    80104cb0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 79 10 80       	push   $0x80107946
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
 uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 0b 1b 00 00       	call   80101d90 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010028c:	e8 5f 49 00 00       	call   80104bf0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 40 b5 10 80       	push   $0x8010b540
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 f6 40 00 00       	call   801043c0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 40 3b 00 00       	call   80103e20 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 40 b5 10 80       	push   $0x8010b540
801002ef:	e8 bc 49 00 00       	call   80104cb0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 19 00 00       	call   80101cb0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 40 b5 10 80       	push   $0x8010b540
8010034d:	e8 5e 49 00 00       	call   80104cb0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 19 00 00       	call   80101cb0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 b2 29 00 00       	call   80102d60 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 79 10 80       	push   $0x8010794d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 8b 83 10 80 	movl   $0x8010838b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 46 00 00       	call   80104ad0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 79 10 80       	push   $0x80107961
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 e1 60 00 00       	call   80106520 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 2f 60 00 00       	call   80106520 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 23 60 00 00       	call   80106520 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 17 60 00 00       	call   80106520 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 87 48 00 00       	call   80104db0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ba 47 00 00       	call   80104d00 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 79 10 80       	push   $0x80107965
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 79 10 80 	movzbl -0x7fef8670(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:


int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 7c 17 00 00       	call   80101d90 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010061b:	e8 d0 45 00 00       	call   80104bf0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 40 b5 10 80       	push   $0x8010b540
80100647:	e8 64 46 00 00       	call   80104cb0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 16 00 00       	call   80101cb0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 74 b5 10 80       	mov    0x8010b574,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 40 b5 10 80       	push   $0x8010b540
8010071f:	e8 8c 45 00 00       	call   80104cb0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 79 10 80       	mov    $0x80107978,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 40 b5 10 80       	push   $0x8010b540
801007f0:	e8 fb 43 00 00       	call   80104bf0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 79 10 80       	push   $0x8010797f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <vga_move_back_cursor>:
void vga_move_back_cursor(){
80100810:	55                   	push   %ebp
80100811:	b8 0e 00 00 00       	mov    $0xe,%eax
80100816:	89 e5                	mov    %esp,%ebp
80100818:	57                   	push   %edi
80100819:	56                   	push   %esi
8010081a:	be d4 03 00 00       	mov    $0x3d4,%esi
8010081f:	53                   	push   %ebx
80100820:	89 f2                	mov    %esi,%edx
80100822:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100823:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100828:	89 da                	mov    %ebx,%edx
8010082a:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010082b:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100830:	0f b6 c8             	movzbl %al,%ecx
80100833:	89 f2                	mov    %esi,%edx
80100835:	c1 e1 08             	shl    $0x8,%ecx
80100838:	89 f8                	mov    %edi,%eax
8010083a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010083b:	89 da                	mov    %ebx,%edx
8010083d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
8010083e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100841:	89 f2                	mov    %esi,%edx
80100843:	09 c1                	or     %eax,%ecx
80100845:	89 f8                	mov    %edi,%eax
  pos--;
80100847:	83 e9 01             	sub    $0x1,%ecx
8010084a:	ee                   	out    %al,(%dx)
8010084b:	89 c8                	mov    %ecx,%eax
8010084d:	89 da                	mov    %ebx,%edx
8010084f:	ee                   	out    %al,(%dx)
80100850:	b8 0e 00 00 00       	mov    $0xe,%eax
80100855:	89 f2                	mov    %esi,%edx
80100857:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100858:	89 c8                	mov    %ecx,%eax
8010085a:	89 da                	mov    %ebx,%edx
8010085c:	c1 f8 08             	sar    $0x8,%eax
8010085f:	ee                   	out    %al,(%dx)
}
80100860:	5b                   	pop    %ebx
80100861:	5e                   	pop    %esi
80100862:	5f                   	pop    %edi
80100863:	5d                   	pop    %ebp
80100864:	c3                   	ret    
80100865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100870 <vga_move_forward_cursor>:
void vga_move_forward_cursor(){
80100870:	55                   	push   %ebp
80100871:	b8 0e 00 00 00       	mov    $0xe,%eax
80100876:	89 e5                	mov    %esp,%ebp
80100878:	57                   	push   %edi
80100879:	56                   	push   %esi
8010087a:	be d4 03 00 00       	mov    $0x3d4,%esi
8010087f:	53                   	push   %ebx
80100880:	89 f2                	mov    %esi,%edx
80100882:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100883:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100888:	89 da                	mov    %ebx,%edx
8010088a:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010088b:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100890:	0f b6 c8             	movzbl %al,%ecx
80100893:	89 f2                	mov    %esi,%edx
80100895:	c1 e1 08             	shl    $0x8,%ecx
80100898:	89 f8                	mov    %edi,%eax
8010089a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010089b:	89 da                	mov    %ebx,%edx
8010089d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
8010089e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801008a1:	89 f2                	mov    %esi,%edx
801008a3:	09 c1                	or     %eax,%ecx
801008a5:	89 f8                	mov    %edi,%eax
  pos++;
801008a7:	83 c1 01             	add    $0x1,%ecx
801008aa:	ee                   	out    %al,(%dx)
801008ab:	89 c8                	mov    %ecx,%eax
801008ad:	89 da                	mov    %ebx,%edx
801008af:	ee                   	out    %al,(%dx)
801008b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801008b5:	89 f2                	mov    %esi,%edx
801008b7:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
801008b8:	89 c8                	mov    %ecx,%eax
801008ba:	89 da                	mov    %ebx,%edx
801008bc:	c1 f8 08             	sar    $0x8,%eax
801008bf:	ee                   	out    %al,(%dx)
}
801008c0:	5b                   	pop    %ebx
801008c1:	5e                   	pop    %esi
801008c2:	5f                   	pop    %edi
801008c3:	5d                   	pop    %ebp
801008c4:	c3                   	ret    
801008c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801008d0 <vga_insert_char>:
void vga_insert_char(int c, int back_counter){
801008d0:	55                   	push   %ebp
801008d1:	b8 0e 00 00 00       	mov    $0xe,%eax
801008d6:	89 e5                	mov    %esp,%ebp
801008d8:	57                   	push   %edi
801008d9:	bf d4 03 00 00       	mov    $0x3d4,%edi
801008de:	56                   	push   %esi
801008df:	89 fa                	mov    %edi,%edx
801008e1:	53                   	push   %ebx
801008e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801008e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801008e6:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801008eb:	89 ca                	mov    %ecx,%edx
801008ed:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801008ee:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801008f1:	89 fa                	mov    %edi,%edx
801008f3:	c1 e0 08             	shl    $0x8,%eax
801008f6:	89 c6                	mov    %eax,%esi
801008f8:	b8 0f 00 00 00       	mov    $0xf,%eax
801008fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801008fe:	89 ca                	mov    %ecx,%edx
80100900:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100901:	0f b6 c0             	movzbl %al,%eax
80100904:	09 f0                	or     %esi,%eax
  for(int i = pos + back_counter; i >= pos; i--){
80100906:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80100909:	39 d0                	cmp    %edx,%eax
8010090b:	7f 21                	jg     8010092e <vga_insert_char+0x5e>
8010090d:	8d 94 12 00 80 0b 80 	lea    -0x7ff48000(%edx,%edx,1),%edx
80100914:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010091b:	90                   	nop
8010091c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    crt[i+1] = crt[i];
80100920:	0f b7 0a             	movzwl (%edx),%ecx
80100923:	83 ea 02             	sub    $0x2,%edx
80100926:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for(int i = pos + back_counter; i >= pos; i--){
8010092a:	39 d6                	cmp    %edx,%esi
8010092c:	75 f2                	jne    80100920 <vga_insert_char+0x50>
  crt[pos] = (c&0xff) | 0x0700;  
8010092e:	0f b6 55 08          	movzbl 0x8(%ebp),%edx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100932:	bf d4 03 00 00       	mov    $0x3d4,%edi
  pos += 1;
80100937:	8d 48 01             	lea    0x1(%eax),%ecx
  crt[pos] = (c&0xff) | 0x0700;  
8010093a:	80 ce 07             	or     $0x7,%dh
8010093d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100944:	80 
80100945:	b8 0e 00 00 00       	mov    $0xe,%eax
8010094a:	89 fa                	mov    %edi,%edx
8010094c:	ee                   	out    %al,(%dx)
8010094d:	be d5 03 00 00       	mov    $0x3d5,%esi
  outb(CRTPORT+1, pos>>8);
80100952:	89 c8                	mov    %ecx,%eax
80100954:	c1 f8 08             	sar    $0x8,%eax
80100957:	89 f2                	mov    %esi,%edx
80100959:	ee                   	out    %al,(%dx)
8010095a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010095f:	89 fa                	mov    %edi,%edx
80100961:	ee                   	out    %al,(%dx)
80100962:	89 c8                	mov    %ecx,%eax
80100964:	89 f2                	mov    %esi,%edx
80100966:	ee                   	out    %al,(%dx)
  crt[pos+back_counter] = ' ' | 0x0700;
80100967:	b8 20 07 00 00       	mov    $0x720,%eax
8010096c:	01 cb                	add    %ecx,%ebx
8010096e:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100975:	80 
}
80100976:	5b                   	pop    %ebx
80100977:	5e                   	pop    %esi
80100978:	5f                   	pop    %edi
80100979:	5d                   	pop    %ebp
8010097a:	c3                   	ret    
8010097b:	90                   	nop
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100980 <consoleintr>:
{
80100980:	55                   	push   %ebp
80100981:	89 e5                	mov    %esp,%ebp
80100983:	57                   	push   %edi
80100984:	56                   	push   %esi
80100985:	53                   	push   %ebx
80100986:	83 ec 38             	sub    $0x38,%esp
80100989:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
8010098c:	68 40 b5 10 80       	push   $0x8010b540
{
80100991:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
80100994:	e8 57 42 00 00       	call   80104bf0 <acquire>
  while((c = getc()) >= 0){
80100999:	83 c4 10             	add    $0x10,%esp
  int c,doprocdump = 0;
8010099c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
801009a3:	90                   	nop
801009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((c = getc()) >= 0){
801009a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009ab:	ff d0                	call   *%eax
801009ad:	85 c0                	test   %eax,%eax
801009af:	0f 88 eb 00 00 00    	js     80100aa0 <consoleintr+0x120>
    switch(c){
801009b5:	83 f8 10             	cmp    $0x10,%eax
801009b8:	0f 84 e2 03 00 00    	je     80100da0 <consoleintr+0x420>
801009be:	0f 8f 04 01 00 00    	jg     80100ac8 <consoleintr+0x148>
801009c4:	83 f8 09             	cmp    $0x9,%eax
801009c7:	0f 84 b3 02 00 00    	je     80100c80 <consoleintr+0x300>
801009cd:	0f 8e dd 03 00 00    	jle    80100db0 <consoleintr+0x430>
801009d3:	83 f8 0b             	cmp    $0xb,%eax
801009d6:	0f 84 94 01 00 00    	je     80100b70 <consoleintr+0x1f0>
801009dc:	83 f8 0c             	cmp    $0xc,%eax
801009df:	0f 85 fb 03 00 00    	jne    80100de0 <consoleintr+0x460>
      while(input.pos < input.e && input.buf[(input.pos)%INPUT_BUF] != 32)
801009e5:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009ea:	8b 3d cc 0f 11 80    	mov    0x80110fcc,%edi
801009f0:	39 f8                	cmp    %edi,%eax
801009f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009f5:	76 b1                	jbe    801009a8 <consoleintr+0x28>
801009f7:	8b 35 20 b5 10 80    	mov    0x8010b520,%esi
801009fd:	89 f8                	mov    %edi,%eax
801009ff:	83 e0 7f             	and    $0x7f,%eax
80100a02:	83 ee 01             	sub    $0x1,%esi
80100a05:	80 b8 40 0f 11 80 20 	cmpb   $0x20,-0x7feef0c0(%eax)
80100a0c:	75 17                	jne    80100a25 <consoleintr+0xa5>
80100a0e:	eb 98                	jmp    801009a8 <consoleintr+0x28>
80100a10:	89 f8                	mov    %edi,%eax
80100a12:	83 ee 01             	sub    $0x1,%esi
80100a15:	83 e0 7f             	and    $0x7f,%eax
80100a18:	80 b8 40 0f 11 80 20 	cmpb   $0x20,-0x7feef0c0(%eax)
80100a1f:	0f 84 33 05 00 00    	je     80100f58 <consoleintr+0x5d8>
        input.pos ++;
80100a25:	83 c7 01             	add    $0x1,%edi
        back_counter -=1;
80100a28:	89 75 dc             	mov    %esi,-0x24(%ebp)
80100a2b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a30:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100a35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a36:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100a3b:	89 da                	mov    %ebx,%edx
80100a3d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100a3e:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a41:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100a46:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a4b:	c1 e1 08             	shl    $0x8,%ecx
80100a4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a4f:	89 da                	mov    %ebx,%edx
80100a51:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100a52:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a55:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100a5a:	09 c1                	or     %eax,%ecx
80100a5c:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos++;
80100a61:	83 c1 01             	add    $0x1,%ecx
80100a64:	ee                   	out    %al,(%dx)
80100a65:	89 c8                	mov    %ecx,%eax
80100a67:	89 da                	mov    %ebx,%edx
80100a69:	ee                   	out    %al,(%dx)
80100a6a:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a6f:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100a74:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100a75:	89 c8                	mov    %ecx,%eax
80100a77:	89 da                	mov    %ebx,%edx
80100a79:	c1 f8 08             	sar    $0x8,%eax
80100a7c:	ee                   	out    %al,(%dx)
      while(input.pos < input.e && input.buf[(input.pos)%INPUT_BUF] != 32)
80100a7d:	3b 7d e0             	cmp    -0x20(%ebp),%edi
80100a80:	75 8e                	jne    80100a10 <consoleintr+0x90>
80100a82:	89 35 20 b5 10 80    	mov    %esi,0x8010b520
80100a88:	89 3d cc 0f 11 80    	mov    %edi,0x80110fcc
  while((c = getc()) >= 0){
80100a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100a91:	ff d0                	call   *%eax
80100a93:	85 c0                	test   %eax,%eax
80100a95:	0f 89 1a ff ff ff    	jns    801009b5 <consoleintr+0x35>
80100a9b:	90                   	nop
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	68 40 b5 10 80       	push   $0x8010b540
80100aa8:	e8 03 42 00 00       	call   80104cb0 <release>
  if(doprocdump) {
80100aad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ab0:	83 c4 10             	add    $0x10,%esp
80100ab3:	85 c0                	test   %eax,%eax
80100ab5:	0f 85 8d 04 00 00    	jne    80100f48 <consoleintr+0x5c8>
}
80100abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100abe:	5b                   	pop    %ebx
80100abf:	5e                   	pop    %esi
80100ac0:	5f                   	pop    %edi
80100ac1:	5d                   	pop    %ebp
80100ac2:	c3                   	ret    
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100ac8:	83 f8 7f             	cmp    $0x7f,%eax
80100acb:	0f 84 e4 02 00 00    	je     80100db5 <consoleintr+0x435>
80100ad1:	7e 3d                	jle    80100b10 <consoleintr+0x190>
80100ad3:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100ad8:	0f 84 12 04 00 00    	je     80100ef0 <consoleintr+0x570>
80100ade:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100ae3:	0f 85 f7 02 00 00    	jne    80100de0 <consoleintr+0x460>
      if(input.pos < input.e){   // cannot beyond most left character
80100ae9:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100aee:	3b 05 c8 0f 11 80    	cmp    0x80110fc8,%eax
80100af4:	0f 83 ae fe ff ff    	jae    801009a8 <consoleintr+0x28>
        input.pos ++; // move back one
80100afa:	83 c0 01             	add    $0x1,%eax
        back_counter -= 1;
80100afd:	83 2d 20 b5 10 80 01 	subl   $0x1,0x8010b520
        input.pos ++; // move back one
80100b04:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
80100b09:	e9 1b 01 00 00       	jmp    80100c29 <consoleintr+0x2a9>
80100b0e:	66 90                	xchg   %ax,%ax
    switch(c){
80100b10:	83 f8 15             	cmp    $0x15,%eax
80100b13:	0f 85 c7 02 00 00    	jne    80100de0 <consoleintr+0x460>
      while(input.e != input.w &&
80100b19:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100b1e:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100b24:	75 2a                	jne    80100b50 <consoleintr+0x1d0>
80100b26:	e9 7d fe ff ff       	jmp    801009a8 <consoleintr+0x28>
80100b2b:	90                   	nop
80100b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.e--;
80100b30:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100b35:	b8 00 01 00 00       	mov    $0x100,%eax
80100b3a:	e8 d1 f8 ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
80100b3f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100b44:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100b4a:	0f 84 58 fe ff ff    	je     801009a8 <consoleintr+0x28>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100b50:	83 e8 01             	sub    $0x1,%eax
80100b53:	89 c2                	mov    %eax,%edx
80100b55:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100b58:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100b5f:	75 cf                	jne    80100b30 <consoleintr+0x1b0>
80100b61:	e9 42 fe ff ff       	jmp    801009a8 <consoleintr+0x28>
80100b66:	8d 76 00             	lea    0x0(%esi),%esi
80100b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      while(input.pos > input.r && input.buf[(input.pos)%INPUT_BUF] != 32)
80100b70:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
80100b75:	8b 3d cc 0f 11 80    	mov    0x80110fcc,%edi
80100b7b:	8b 35 20 b5 10 80    	mov    0x8010b520,%esi
80100b81:	39 f8                	cmp    %edi,%eax
80100b83:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100b86:	89 75 e0             	mov    %esi,-0x20(%ebp)
80100b89:	0f 83 87 00 00 00    	jae    80100c16 <consoleintr+0x296>
80100b8f:	89 f8                	mov    %edi,%eax
80100b91:	83 c6 01             	add    $0x1,%esi
80100b94:	83 e0 7f             	and    $0x7f,%eax
80100b97:	80 b8 40 0f 11 80 20 	cmpb   $0x20,-0x7feef0c0(%eax)
80100b9e:	75 19                	jne    80100bb9 <consoleintr+0x239>
80100ba0:	eb 74                	jmp    80100c16 <consoleintr+0x296>
80100ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ba8:	89 f8                	mov    %edi,%eax
80100baa:	83 c6 01             	add    $0x1,%esi
80100bad:	83 e0 7f             	and    $0x7f,%eax
80100bb0:	80 b8 40 0f 11 80 20 	cmpb   $0x20,-0x7feef0c0(%eax)
80100bb7:	74 5d                	je     80100c16 <consoleintr+0x296>
        input.pos --;
80100bb9:	83 ef 01             	sub    $0x1,%edi
        back_counter +=1;
80100bbc:	89 75 e0             	mov    %esi,-0x20(%ebp)
80100bbf:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bc4:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bc9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bca:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100bcf:	89 da                	mov    %ebx,%edx
80100bd1:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100bd2:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bd5:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bda:	b8 0f 00 00 00       	mov    $0xf,%eax
80100bdf:	c1 e1 08             	shl    $0x8,%ecx
80100be2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100be3:	89 da                	mov    %ebx,%edx
80100be5:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100be6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100be9:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100bee:	09 c1                	or     %eax,%ecx
80100bf0:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos--;
80100bf5:	83 e9 01             	sub    $0x1,%ecx
80100bf8:	ee                   	out    %al,(%dx)
80100bf9:	89 c8                	mov    %ecx,%eax
80100bfb:	89 da                	mov    %ebx,%edx
80100bfd:	ee                   	out    %al,(%dx)
80100bfe:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c03:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100c08:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100c09:	89 c8                	mov    %ecx,%eax
80100c0b:	89 da                	mov    %ebx,%edx
80100c0d:	c1 f8 08             	sar    $0x8,%eax
80100c10:	ee                   	out    %al,(%dx)
      while(input.pos > input.r && input.buf[(input.pos)%INPUT_BUF] != 32)
80100c11:	3b 7d dc             	cmp    -0x24(%ebp),%edi
80100c14:	75 92                	jne    80100ba8 <consoleintr+0x228>
      input.pos ++;
80100c16:	8d 47 01             	lea    0x1(%edi),%eax
80100c19:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
      back_counter -=1;
80100c1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c21:	83 e8 01             	sub    $0x1,%eax
80100c24:	a3 20 b5 10 80       	mov    %eax,0x8010b520
80100c29:	be d4 03 00 00       	mov    $0x3d4,%esi
80100c2e:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c33:	89 f2                	mov    %esi,%edx
80100c35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c36:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c3b:	89 da                	mov    %ebx,%edx
80100c3d:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c3e:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100c43:	0f b6 c8             	movzbl %al,%ecx
80100c46:	89 f2                	mov    %esi,%edx
80100c48:	c1 e1 08             	shl    $0x8,%ecx
80100c4b:	89 f8                	mov    %edi,%eax
80100c4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c4e:	89 da                	mov    %ebx,%edx
80100c50:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100c51:	0f b6 c0             	movzbl %al,%eax
80100c54:	09 c1                	or     %eax,%ecx
  pos++;
80100c56:	83 c1 01             	add    $0x1,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c59:	89 f8                	mov    %edi,%eax
80100c5b:	89 f2                	mov    %esi,%edx
80100c5d:	ee                   	out    %al,(%dx)
80100c5e:	89 c8                	mov    %ecx,%eax
80100c60:	89 da                	mov    %ebx,%edx
80100c62:	ee                   	out    %al,(%dx)
80100c63:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c68:	89 f2                	mov    %esi,%edx
80100c6a:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, (unsigned char )((pos>>8)&0xFF));
80100c6b:	89 c8                	mov    %ecx,%eax
80100c6d:	89 da                	mov    %ebx,%edx
80100c6f:	c1 f8 08             	sar    $0x8,%eax
80100c72:	ee                   	out    %al,(%dx)
80100c73:	e9 30 fd ff ff       	jmp    801009a8 <consoleintr+0x28>
80100c78:	90                   	nop
80100c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int z = input.pos - input.r; z>0; z--){
80100c80:	8b 3d cc 0f 11 80    	mov    0x80110fcc,%edi
80100c86:	89 f8                	mov    %edi,%eax
80100c88:	2b 05 c0 0f 11 80    	sub    0x80110fc0,%eax
80100c8e:	85 c0                	test   %eax,%eax
80100c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c93:	0f 8e 0f fd ff ff    	jle    801009a8 <consoleintr+0x28>
80100c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(int k=input.pos - 1; k <= input.e; k++)
80100ca0:	8b 35 c8 0f 11 80    	mov    0x80110fc8,%esi
80100ca6:	83 ef 01             	sub    $0x1,%edi
80100ca9:	89 f8                	mov    %edi,%eax
80100cab:	39 f7                	cmp    %esi,%edi
80100cad:	77 36                	ja     80100ce5 <consoleintr+0x365>
80100caf:	90                   	nop
              input.buf[(k) % INPUT_BUF] = input.buf[(k+1) % INPUT_BUF];
80100cb0:	8d 50 01             	lea    0x1(%eax),%edx
80100cb3:	89 d3                	mov    %edx,%ebx
80100cb5:	c1 fb 1f             	sar    $0x1f,%ebx
80100cb8:	c1 eb 19             	shr    $0x19,%ebx
80100cbb:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80100cbe:	83 e1 7f             	and    $0x7f,%ecx
80100cc1:	29 d9                	sub    %ebx,%ecx
80100cc3:	89 c3                	mov    %eax,%ebx
80100cc5:	c1 fb 1f             	sar    $0x1f,%ebx
80100cc8:	0f b6 89 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%ecx
80100ccf:	c1 eb 19             	shr    $0x19,%ebx
80100cd2:	01 d8                	add    %ebx,%eax
80100cd4:	83 e0 7f             	and    $0x7f,%eax
80100cd7:	29 d8                	sub    %ebx,%eax
      for(int k=input.pos - 1; k <= input.e; k++)
80100cd9:	39 d6                	cmp    %edx,%esi
              input.buf[(k) % INPUT_BUF] = input.buf[(k+1) % INPUT_BUF];
80100cdb:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
      for(int k=input.pos - 1; k <= input.e; k++)
80100ce1:	89 d0                	mov    %edx,%eax
80100ce3:	73 cb                	jae    80100cb0 <consoleintr+0x330>
      back_counter +=1;
80100ce5:	a1 20 b5 10 80       	mov    0x8010b520,%eax
      input.e--;
80100cea:	83 ee 01             	sub    $0x1,%esi
      input.pos--;
80100ced:	89 3d cc 0f 11 80    	mov    %edi,0x80110fcc
      input.e--;
80100cf3:	89 35 c8 0f 11 80    	mov    %esi,0x80110fc8
80100cf9:	ba d4 03 00 00       	mov    $0x3d4,%edx
      back_counter +=1;
80100cfe:	8d 48 01             	lea    0x1(%eax),%ecx
80100d01:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d06:	89 0d 20 b5 10 80    	mov    %ecx,0x8010b520
80100d0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d0d:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100d12:	ec                   	in     (%dx),%al
      posi = inb(CRTPORT+1) << 8;
80100d13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d16:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d1b:	c1 e0 08             	shl    $0x8,%eax
80100d1e:	89 c3                	mov    %eax,%ebx
80100d20:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d25:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d26:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100d2b:	ec                   	in     (%dx),%al
      posi |= inb(CRTPORT+1);
80100d2c:	0f b6 c0             	movzbl %al,%eax
80100d2f:	09 d8                	or     %ebx,%eax
      for(int i = posi-1 ; i <= posi + back_counter; i++)
80100d31:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100d34:	01 c1                	add    %eax,%ecx
80100d36:	39 cb                	cmp    %ecx,%ebx
80100d38:	7f 27                	jg     80100d61 <consoleintr+0x3e1>
80100d3a:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
80100d41:	89 d9                	mov    %ebx,%ecx
80100d43:	90                   	nop
80100d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        crt[i] = crt[i+1];
80100d48:	0f b7 32             	movzwl (%edx),%esi
      for(int i = posi-1 ; i <= posi + back_counter; i++)
80100d4b:	83 c1 01             	add    $0x1,%ecx
80100d4e:	83 c2 02             	add    $0x2,%edx
        crt[i] = crt[i+1];
80100d51:	66 89 72 fc          	mov    %si,-0x4(%edx)
      for(int i = posi-1 ; i <= posi + back_counter; i++)
80100d55:	8b 35 20 b5 10 80    	mov    0x8010b520,%esi
80100d5b:	01 c6                	add    %eax,%esi
80100d5d:	39 ce                	cmp    %ecx,%esi
80100d5f:	7d e7                	jge    80100d48 <consoleintr+0x3c8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d61:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d66:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d6b:	ee                   	out    %al,(%dx)
      outb(CRTPORT+1, posi>>8);
80100d6c:	89 d8                	mov    %ebx,%eax
80100d6e:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100d73:	c1 f8 08             	sar    $0x8,%eax
80100d76:	ee                   	out    %al,(%dx)
80100d77:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d7c:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100d81:	ee                   	out    %al,(%dx)
80100d82:	ba d5 03 00 00       	mov    $0x3d5,%edx
80100d87:	89 d8                	mov    %ebx,%eax
80100d89:	ee                   	out    %al,(%dx)
    for(int z = input.pos - input.r; z>0; z--){
80100d8a:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
80100d8e:	0f 84 14 fc ff ff    	je     801009a8 <consoleintr+0x28>
80100d94:	8b 3d cc 0f 11 80    	mov    0x80110fcc,%edi
80100d9a:	e9 01 ff ff ff       	jmp    80100ca0 <consoleintr+0x320>
80100d9f:	90                   	nop
      doprocdump = 1;
80100da0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
80100da7:	e9 fc fb ff ff       	jmp    801009a8 <consoleintr+0x28>
80100dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100db0:	83 f8 08             	cmp    $0x8,%eax
80100db3:	75 2b                	jne    80100de0 <consoleintr+0x460>
      if(input.e != input.w){
80100db5:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100dba:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100dc0:	0f 84 e2 fb ff ff    	je     801009a8 <consoleintr+0x28>
        input.e--;
80100dc6:	83 e8 01             	sub    $0x1,%eax
80100dc9:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100dce:	b8 00 01 00 00       	mov    $0x100,%eax
80100dd3:	e8 38 f6 ff ff       	call   80100410 <consputc>
80100dd8:	e9 cb fb ff ff       	jmp    801009a8 <consoleintr+0x28>
80100ddd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100de0:	85 c0                	test   %eax,%eax
80100de2:	0f 84 c0 fb ff ff    	je     801009a8 <consoleintr+0x28>
80100de8:	8b 15 c8 0f 11 80    	mov    0x80110fc8,%edx
80100dee:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
80100df4:	83 fa 7f             	cmp    $0x7f,%edx
80100df7:	0f 87 ab fb ff ff    	ja     801009a8 <consoleintr+0x28>
        uartputc('-');
80100dfd:	83 ec 0c             	sub    $0xc,%esp
80100e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e03:	6a 2d                	push   $0x2d
80100e05:	e8 16 57 00 00       	call   80106520 <uartputc>
        uartputc(c); 
80100e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e0d:	89 04 24             	mov    %eax,(%esp)
80100e10:	e8 0b 57 00 00       	call   80106520 <uartputc>
        c = (c == '\r') ? '\n' : c;
80100e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e18:	83 c4 10             	add    $0x10,%esp
80100e1b:	8b 0d c8 0f 11 80    	mov    0x80110fc8,%ecx
80100e21:	83 f8 0d             	cmp    $0xd,%eax
80100e24:	0f 84 41 01 00 00    	je     80100f6b <consoleintr+0x5eb>
80100e2a:	8d 79 01             	lea    0x1(%ecx),%edi
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){ // if input is \n, put it on the back, and process it
80100e2d:	83 f8 0a             	cmp    $0xa,%eax
80100e30:	88 45 dc             	mov    %al,-0x24(%ebp)
80100e33:	89 7d e0             	mov    %edi,-0x20(%ebp)
80100e36:	0f 84 3e 01 00 00    	je     80100f7a <consoleintr+0x5fa>
80100e3c:	83 f8 04             	cmp    $0x4,%eax
80100e3f:	0f 84 35 01 00 00    	je     80100f7a <consoleintr+0x5fa>
80100e45:	8b 3d c0 0f 11 80    	mov    0x80110fc0,%edi
80100e4b:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
80100e51:	39 ca                	cmp    %ecx,%edx
80100e53:	0f 84 21 01 00 00    	je     80100f7a <consoleintr+0x5fa>
            if(input.pos == input.e){
80100e59:	8b 3d cc 0f 11 80    	mov    0x80110fcc,%edi
80100e5f:	89 fe                	mov    %edi,%esi
80100e61:	83 e6 7f             	and    $0x7f,%esi
80100e64:	39 cf                	cmp    %ecx,%edi
80100e66:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80100e69:	8d 77 01             	lea    0x1(%edi),%esi
80100e6c:	89 75 d0             	mov    %esi,-0x30(%ebp)
80100e6f:	75 41                	jne    80100eb2 <consoleintr+0x532>
80100e71:	e9 4d 01 00 00       	jmp    80100fc3 <consoleintr+0x643>
80100e76:	8d 76 00             	lea    0x0(%esi),%esi
80100e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80100e80:	89 cb                	mov    %ecx,%ebx
80100e82:	c1 fb 1f             	sar    $0x1f,%ebx
80100e85:	c1 eb 19             	shr    $0x19,%ebx
80100e88:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
80100e8b:	83 e2 7f             	and    $0x7f,%edx
80100e8e:	29 da                	sub    %ebx,%edx
80100e90:	0f b6 9a 40 0f 11 80 	movzbl -0x7feef0c0(%edx),%ebx
80100e97:	8d 51 01             	lea    0x1(%ecx),%edx
            for(int k=input.e; k >= input.pos; k--){
80100e9a:	83 e9 01             	sub    $0x1,%ecx
              input.buf[(k + 1) % INPUT_BUF] = input.buf[k % INPUT_BUF];
80100e9d:	89 d6                	mov    %edx,%esi
80100e9f:	c1 fe 1f             	sar    $0x1f,%esi
80100ea2:	c1 ee 19             	shr    $0x19,%esi
80100ea5:	01 f2                	add    %esi,%edx
80100ea7:	83 e2 7f             	and    $0x7f,%edx
80100eaa:	29 f2                	sub    %esi,%edx
80100eac:	88 9a 40 0f 11 80    	mov    %bl,-0x7feef0c0(%edx)
            for(int k=input.e; k >= input.pos; k--){
80100eb2:	39 cf                	cmp    %ecx,%edi
80100eb4:	76 ca                	jbe    80100e80 <consoleintr+0x500>
            input.buf[input.pos % INPUT_BUF] = c;
80100eb6:	0f b6 5d dc          	movzbl -0x24(%ebp),%ebx
80100eba:	8b 7d d4             	mov    -0x2c(%ebp),%edi
            vga_insert_char(c, back_counter);
80100ebd:	83 ec 08             	sub    $0x8,%esp
80100ec0:	ff 35 20 b5 10 80    	pushl  0x8010b520
80100ec6:	50                   	push   %eax
            input.buf[input.pos % INPUT_BUF] = c;
80100ec7:	88 9f 40 0f 11 80    	mov    %bl,-0x7feef0c0(%edi)
            input.e++;
80100ecd:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100ed0:	89 3d c8 0f 11 80    	mov    %edi,0x80110fc8
            input.pos++;
80100ed6:	8b 7d d0             	mov    -0x30(%ebp),%edi
80100ed9:	89 3d cc 0f 11 80    	mov    %edi,0x80110fcc
            vga_insert_char(c, back_counter);
80100edf:	e8 ec f9 ff ff       	call   801008d0 <vga_insert_char>
80100ee4:	83 c4 10             	add    $0x10,%esp
80100ee7:	e9 bc fa ff ff       	jmp    801009a8 <consoleintr+0x28>
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.pos > input.r){   // cannot beyond most left character
80100ef0:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100ef5:	3b 05 c0 0f 11 80    	cmp    0x80110fc0,%eax
80100efb:	0f 86 a7 fa ff ff    	jbe    801009a8 <consoleintr+0x28>
        input.pos --; // move back one
80100f01:	83 e8 01             	sub    $0x1,%eax
80100f04:	be d4 03 00 00       	mov    $0x3d4,%esi
        back_counter += 1;
80100f09:	83 05 20 b5 10 80 01 	addl   $0x1,0x8010b520
        input.pos --; // move back one
80100f10:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
80100f15:	89 f2                	mov    %esi,%edx
80100f17:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f1d:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100f22:	89 da                	mov    %ebx,%edx
80100f24:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f25:	bf 0f 00 00 00       	mov    $0xf,%edi
  pos = inb(CRTPORT+1) << 8;
80100f2a:	0f b6 c8             	movzbl %al,%ecx
80100f2d:	89 f2                	mov    %esi,%edx
80100f2f:	c1 e1 08             	shl    $0x8,%ecx
80100f32:	89 f8                	mov    %edi,%eax
80100f34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f35:	89 da                	mov    %ebx,%edx
80100f37:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);    
80100f38:	0f b6 c0             	movzbl %al,%eax
80100f3b:	09 c1                	or     %eax,%ecx
  pos--;
80100f3d:	83 e9 01             	sub    $0x1,%ecx
80100f40:	e9 14 fd ff ff       	jmp    80100c59 <consoleintr+0x2d9>
80100f45:	8d 76 00             	lea    0x0(%esi),%esi
}
80100f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4b:	5b                   	pop    %ebx
80100f4c:	5e                   	pop    %esi
80100f4d:	5f                   	pop    %edi
80100f4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100f4f:	e9 0c 37 00 00       	jmp    80104660 <procdump>
80100f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f5b:	89 3d cc 0f 11 80    	mov    %edi,0x80110fcc
80100f61:	a3 20 b5 10 80       	mov    %eax,0x8010b520
80100f66:	e9 3d fa ff ff       	jmp    801009a8 <consoleintr+0x28>
80100f6b:	8d 41 01             	lea    0x1(%ecx),%eax
        c = (c == '\r') ? '\n' : c;
80100f6e:	c6 45 dc 0a          	movb   $0xa,-0x24(%ebp)
80100f72:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100f75:	b8 0a 00 00 00       	mov    $0xa,%eax
          input.buf[input.e++ % INPUT_BUF] = c;
80100f7a:	0f b6 5d dc          	movzbl -0x24(%ebp),%ebx
80100f7e:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100f81:	83 e1 7f             	and    $0x7f,%ecx
80100f84:	89 3d c8 0f 11 80    	mov    %edi,0x80110fc8
80100f8a:	88 99 40 0f 11 80    	mov    %bl,-0x7feef0c0(%ecx)
          consputc(c);
80100f90:	e8 7b f4 ff ff       	call   80100410 <consputc>
          input.w = input.e;
80100f95:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
          wakeup(&input.r);
80100f9a:	83 ec 0c             	sub    $0xc,%esp
          back_counter = 0;
80100f9d:	c7 05 20 b5 10 80 00 	movl   $0x0,0x8010b520
80100fa4:	00 00 00 
          wakeup(&input.r);
80100fa7:	68 c0 0f 11 80       	push   $0x80110fc0
          input.w = input.e;
80100fac:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          input.pos = input.e;
80100fb1:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
          wakeup(&input.r);
80100fb6:	e8 c5 35 00 00       	call   80104580 <wakeup>
80100fbb:	83 c4 10             	add    $0x10,%esp
80100fbe:	e9 e5 f9 ff ff       	jmp    801009a8 <consoleintr+0x28>
            input.buf[input.e++ % INPUT_BUF] = c;
80100fc3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80100fc6:	89 35 c8 0f 11 80    	mov    %esi,0x80110fc8
80100fcc:	88 87 40 0f 11 80    	mov    %al,-0x7feef0c0(%edi)
            input.pos ++;
80100fd2:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100fd5:	89 3d cc 0f 11 80    	mov    %edi,0x80110fcc
            consputc(c);
80100fdb:	e8 30 f4 ff ff       	call   80100410 <consputc>
80100fe0:	e9 c3 f9 ff ff       	jmp    801009a8 <consoleintr+0x28>
80100fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <consoleinit>:

void
consoleinit(void)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ff6:	68 88 79 10 80       	push   $0x80107988
80100ffb:	68 40 b5 10 80       	push   $0x8010b540
80101000:	e8 ab 3a 00 00       	call   80104ab0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101005:	58                   	pop    %eax
80101006:	5a                   	pop    %edx
80101007:	6a 00                	push   $0x0
80101009:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010100b:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
80101012:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101015:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
8010101c:	02 10 80 
  cons.locking = 1;
8010101f:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
80101026:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101029:	e8 d2 18 00 00       	call   80102900 <ioapicenable>
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	c9                   	leave  
80101032:	c3                   	ret    
80101033:	66 90                	xchg   %ax,%ax
80101035:	66 90                	xchg   %ax,%ax
80101037:	66 90                	xchg   %ax,%ax
80101039:	66 90                	xchg   %ax,%ax
8010103b:	66 90                	xchg   %ax,%ax
8010103d:	66 90                	xchg   %ax,%ax
8010103f:	90                   	nop

80101040 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010104c:	e8 cf 2d 00 00       	call   80103e20 <myproc>
80101051:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80101057:	e8 74 21 00 00       	call   801031d0 <begin_op>

  if((ip = namei(path)) == 0){
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	ff 75 08             	pushl  0x8(%ebp)
80101062:	e8 a9 14 00 00       	call   80102510 <namei>
80101067:	83 c4 10             	add    $0x10,%esp
8010106a:	85 c0                	test   %eax,%eax
8010106c:	0f 84 91 01 00 00    	je     80101203 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101072:	83 ec 0c             	sub    $0xc,%esp
80101075:	89 c3                	mov    %eax,%ebx
80101077:	50                   	push   %eax
80101078:	e8 33 0c 00 00       	call   80101cb0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010107d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101083:	6a 34                	push   $0x34
80101085:	6a 00                	push   $0x0
80101087:	50                   	push   %eax
80101088:	53                   	push   %ebx
80101089:	e8 02 0f 00 00       	call   80101f90 <readi>
8010108e:	83 c4 20             	add    $0x20,%esp
80101091:	83 f8 34             	cmp    $0x34,%eax
80101094:	74 22                	je     801010b8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	53                   	push   %ebx
8010109a:	e8 a1 0e 00 00       	call   80101f40 <iunlockput>
    end_op();
8010109f:	e8 9c 21 00 00       	call   80103240 <end_op>
801010a4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801010a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010af:	5b                   	pop    %ebx
801010b0:	5e                   	pop    %esi
801010b1:	5f                   	pop    %edi
801010b2:	5d                   	pop    %ebp
801010b3:	c3                   	ret    
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
801010b8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801010bf:	45 4c 46 
801010c2:	75 d2                	jne    80101096 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
801010c4:	e8 a7 65 00 00       	call   80107670 <setupkvm>
801010c9:	85 c0                	test   %eax,%eax
801010cb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801010d1:	74 c3                	je     80101096 <exec+0x56>
  sz = 0;
801010d3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010d5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801010dc:	00 
801010dd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
801010e3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
801010e9:	0f 84 8c 02 00 00    	je     8010137b <exec+0x33b>
801010ef:	31 f6                	xor    %esi,%esi
801010f1:	eb 7f                	jmp    80101172 <exec+0x132>
801010f3:	90                   	nop
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
801010f8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801010ff:	75 63                	jne    80101164 <exec+0x124>
    if(ph.memsz < ph.filesz)
80101101:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101107:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010110d:	0f 82 86 00 00 00    	jb     80101199 <exec+0x159>
80101113:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101119:	72 7e                	jb     80101199 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010111b:	83 ec 04             	sub    $0x4,%esp
8010111e:	50                   	push   %eax
8010111f:	57                   	push   %edi
80101120:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101126:	e8 65 63 00 00       	call   80107490 <allocuvm>
8010112b:	83 c4 10             	add    $0x10,%esp
8010112e:	85 c0                	test   %eax,%eax
80101130:	89 c7                	mov    %eax,%edi
80101132:	74 65                	je     80101199 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80101134:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010113a:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010113f:	75 58                	jne    80101199 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101141:	83 ec 0c             	sub    $0xc,%esp
80101144:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010114a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101150:	53                   	push   %ebx
80101151:	50                   	push   %eax
80101152:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101158:	e8 73 62 00 00       	call   801073d0 <loaduvm>
8010115d:	83 c4 20             	add    $0x20,%esp
80101160:	85 c0                	test   %eax,%eax
80101162:	78 35                	js     80101199 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101164:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010116b:	83 c6 01             	add    $0x1,%esi
8010116e:	39 f0                	cmp    %esi,%eax
80101170:	7e 3d                	jle    801011af <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101172:	89 f0                	mov    %esi,%eax
80101174:	6a 20                	push   $0x20
80101176:	c1 e0 05             	shl    $0x5,%eax
80101179:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
8010117f:	50                   	push   %eax
80101180:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101186:	50                   	push   %eax
80101187:	53                   	push   %ebx
80101188:	e8 03 0e 00 00       	call   80101f90 <readi>
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	83 f8 20             	cmp    $0x20,%eax
80101193:	0f 84 5f ff ff ff    	je     801010f8 <exec+0xb8>
    freevm(pgdir);
80101199:	83 ec 0c             	sub    $0xc,%esp
8010119c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801011a2:	e8 49 64 00 00       	call   801075f0 <freevm>
801011a7:	83 c4 10             	add    $0x10,%esp
801011aa:	e9 e7 fe ff ff       	jmp    80101096 <exec+0x56>
801011af:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801011b5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801011bb:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	53                   	push   %ebx
801011c5:	e8 76 0d 00 00       	call   80101f40 <iunlockput>
  end_op();
801011ca:	e8 71 20 00 00       	call   80103240 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801011cf:	83 c4 0c             	add    $0xc,%esp
801011d2:	56                   	push   %esi
801011d3:	57                   	push   %edi
801011d4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801011da:	e8 b1 62 00 00       	call   80107490 <allocuvm>
801011df:	83 c4 10             	add    $0x10,%esp
801011e2:	85 c0                	test   %eax,%eax
801011e4:	89 c6                	mov    %eax,%esi
801011e6:	75 3a                	jne    80101222 <exec+0x1e2>
    freevm(pgdir);
801011e8:	83 ec 0c             	sub    $0xc,%esp
801011eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801011f1:	e8 fa 63 00 00       	call   801075f0 <freevm>
801011f6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011fe:	e9 a9 fe ff ff       	jmp    801010ac <exec+0x6c>
    end_op();
80101203:	e8 38 20 00 00       	call   80103240 <end_op>
    cprintf("exec: fail\n");
80101208:	83 ec 0c             	sub    $0xc,%esp
8010120b:	68 a1 79 10 80       	push   $0x801079a1
80101210:	e8 4b f4 ff ff       	call   80100660 <cprintf>
    return -1;
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010121d:	e9 8a fe ff ff       	jmp    801010ac <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101222:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80101228:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
8010122b:	31 ff                	xor    %edi,%edi
8010122d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010122f:	50                   	push   %eax
80101230:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101236:	e8 d5 64 00 00       	call   80107710 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
8010123b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010123e:	83 c4 10             	add    $0x10,%esp
80101241:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101247:	8b 00                	mov    (%eax),%eax
80101249:	85 c0                	test   %eax,%eax
8010124b:	74 70                	je     801012bd <exec+0x27d>
8010124d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80101253:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101259:	eb 0a                	jmp    80101265 <exec+0x225>
8010125b:	90                   	nop
8010125c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80101260:	83 ff 20             	cmp    $0x20,%edi
80101263:	74 83                	je     801011e8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101265:	83 ec 0c             	sub    $0xc,%esp
80101268:	50                   	push   %eax
80101269:	e8 b2 3c 00 00       	call   80104f20 <strlen>
8010126e:	f7 d0                	not    %eax
80101270:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101272:	8b 45 0c             	mov    0xc(%ebp),%eax
80101275:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101276:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101279:	ff 34 b8             	pushl  (%eax,%edi,4)
8010127c:	e8 9f 3c 00 00       	call   80104f20 <strlen>
80101281:	83 c0 01             	add    $0x1,%eax
80101284:	50                   	push   %eax
80101285:	8b 45 0c             	mov    0xc(%ebp),%eax
80101288:	ff 34 b8             	pushl  (%eax,%edi,4)
8010128b:	53                   	push   %ebx
8010128c:	56                   	push   %esi
8010128d:	e8 de 65 00 00       	call   80107870 <copyout>
80101292:	83 c4 20             	add    $0x20,%esp
80101295:	85 c0                	test   %eax,%eax
80101297:	0f 88 4b ff ff ff    	js     801011e8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
8010129d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801012a0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801012a7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801012aa:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801012b0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801012b3:	85 c0                	test   %eax,%eax
801012b5:	75 a9                	jne    80101260 <exec+0x220>
801012b7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012bd:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801012c4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801012c6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801012cd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
801012d1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801012d8:	ff ff ff 
  ustack[1] = argc;
801012db:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012e1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801012e3:	83 c0 0c             	add    $0xc,%eax
801012e6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801012e8:	50                   	push   %eax
801012e9:	52                   	push   %edx
801012ea:	53                   	push   %ebx
801012eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012f1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801012f7:	e8 74 65 00 00       	call   80107870 <copyout>
801012fc:	83 c4 10             	add    $0x10,%esp
801012ff:	85 c0                	test   %eax,%eax
80101301:	0f 88 e1 fe ff ff    	js     801011e8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80101307:	8b 45 08             	mov    0x8(%ebp),%eax
8010130a:	0f b6 00             	movzbl (%eax),%eax
8010130d:	84 c0                	test   %al,%al
8010130f:	74 17                	je     80101328 <exec+0x2e8>
80101311:	8b 55 08             	mov    0x8(%ebp),%edx
80101314:	89 d1                	mov    %edx,%ecx
80101316:	83 c1 01             	add    $0x1,%ecx
80101319:	3c 2f                	cmp    $0x2f,%al
8010131b:	0f b6 01             	movzbl (%ecx),%eax
8010131e:	0f 44 d1             	cmove  %ecx,%edx
80101321:	84 c0                	test   %al,%al
80101323:	75 f1                	jne    80101316 <exec+0x2d6>
80101325:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101328:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
8010132e:	50                   	push   %eax
8010132f:	6a 10                	push   $0x10
80101331:	ff 75 08             	pushl  0x8(%ebp)
80101334:	89 f8                	mov    %edi,%eax
80101336:	83 c0 6c             	add    $0x6c,%eax
80101339:	50                   	push   %eax
8010133a:	e8 a1 3b 00 00       	call   80104ee0 <safestrcpy>
  curproc->pgdir = pgdir;
8010133f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80101345:	89 f9                	mov    %edi,%ecx
80101347:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
8010134a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
8010134d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
8010134f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80101352:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101358:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
8010135b:	8b 41 18             	mov    0x18(%ecx),%eax
8010135e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101361:	89 0c 24             	mov    %ecx,(%esp)
80101364:	e8 d7 5e 00 00       	call   80107240 <switchuvm>
  freevm(oldpgdir);
80101369:	89 3c 24             	mov    %edi,(%esp)
8010136c:	e8 7f 62 00 00       	call   801075f0 <freevm>
  return 0;
80101371:	83 c4 10             	add    $0x10,%esp
80101374:	31 c0                	xor    %eax,%eax
80101376:	e9 31 fd ff ff       	jmp    801010ac <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010137b:	be 00 20 00 00       	mov    $0x2000,%esi
80101380:	e9 3c fe ff ff       	jmp    801011c1 <exec+0x181>
80101385:	66 90                	xchg   %ax,%ax
80101387:	66 90                	xchg   %ax,%ax
80101389:	66 90                	xchg   %ax,%ax
8010138b:	66 90                	xchg   %ax,%ax
8010138d:	66 90                	xchg   %ax,%ax
8010138f:	90                   	nop

80101390 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101396:	68 ad 79 10 80       	push   $0x801079ad
8010139b:	68 e0 0f 11 80       	push   $0x80110fe0
801013a0:	e8 0b 37 00 00       	call   80104ab0 <initlock>
}
801013a5:	83 c4 10             	add    $0x10,%esp
801013a8:	c9                   	leave  
801013a9:	c3                   	ret    
801013aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013b0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801013b4:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
801013b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801013bc:	68 e0 0f 11 80       	push   $0x80110fe0
801013c1:	e8 2a 38 00 00       	call   80104bf0 <acquire>
801013c6:	83 c4 10             	add    $0x10,%esp
801013c9:	eb 10                	jmp    801013db <filealloc+0x2b>
801013cb:	90                   	nop
801013cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801013d0:	83 c3 18             	add    $0x18,%ebx
801013d3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
801013d9:	73 25                	jae    80101400 <filealloc+0x50>
    if(f->ref == 0){
801013db:	8b 43 04             	mov    0x4(%ebx),%eax
801013de:	85 c0                	test   %eax,%eax
801013e0:	75 ee                	jne    801013d0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801013e2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801013e5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801013ec:	68 e0 0f 11 80       	push   $0x80110fe0
801013f1:	e8 ba 38 00 00       	call   80104cb0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801013f6:	89 d8                	mov    %ebx,%eax
      return f;
801013f8:	83 c4 10             	add    $0x10,%esp
}
801013fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013fe:	c9                   	leave  
801013ff:	c3                   	ret    
  release(&ftable.lock);
80101400:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101403:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101405:	68 e0 0f 11 80       	push   $0x80110fe0
8010140a:	e8 a1 38 00 00       	call   80104cb0 <release>
}
8010140f:	89 d8                	mov    %ebx,%eax
  return 0;
80101411:	83 c4 10             	add    $0x10,%esp
}
80101414:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101417:	c9                   	leave  
80101418:	c3                   	ret    
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	53                   	push   %ebx
80101424:	83 ec 10             	sub    $0x10,%esp
80101427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010142a:	68 e0 0f 11 80       	push   $0x80110fe0
8010142f:	e8 bc 37 00 00       	call   80104bf0 <acquire>
  if(f->ref < 1)
80101434:	8b 43 04             	mov    0x4(%ebx),%eax
80101437:	83 c4 10             	add    $0x10,%esp
8010143a:	85 c0                	test   %eax,%eax
8010143c:	7e 1a                	jle    80101458 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010143e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101441:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101444:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101447:	68 e0 0f 11 80       	push   $0x80110fe0
8010144c:	e8 5f 38 00 00       	call   80104cb0 <release>
  return f;
}
80101451:	89 d8                	mov    %ebx,%eax
80101453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101456:	c9                   	leave  
80101457:	c3                   	ret    
    panic("filedup");
80101458:	83 ec 0c             	sub    $0xc,%esp
8010145b:	68 b4 79 10 80       	push   $0x801079b4
80101460:	e8 2b ef ff ff       	call   80100390 <panic>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	53                   	push   %ebx
80101476:	83 ec 28             	sub    $0x28,%esp
80101479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010147c:	68 e0 0f 11 80       	push   $0x80110fe0
80101481:	e8 6a 37 00 00       	call   80104bf0 <acquire>
  if(f->ref < 1)
80101486:	8b 43 04             	mov    0x4(%ebx),%eax
80101489:	83 c4 10             	add    $0x10,%esp
8010148c:	85 c0                	test   %eax,%eax
8010148e:	0f 8e 9b 00 00 00    	jle    8010152f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101494:	83 e8 01             	sub    $0x1,%eax
80101497:	85 c0                	test   %eax,%eax
80101499:	89 43 04             	mov    %eax,0x4(%ebx)
8010149c:	74 1a                	je     801014b8 <fileclose+0x48>
    release(&ftable.lock);
8010149e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801014a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a8:	5b                   	pop    %ebx
801014a9:	5e                   	pop    %esi
801014aa:	5f                   	pop    %edi
801014ab:	5d                   	pop    %ebp
    release(&ftable.lock);
801014ac:	e9 ff 37 00 00       	jmp    80104cb0 <release>
801014b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
801014b8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801014bc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
801014be:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801014c1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
801014c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801014ca:	88 45 e7             	mov    %al,-0x19(%ebp)
801014cd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801014d0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
801014d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801014d8:	e8 d3 37 00 00       	call   80104cb0 <release>
  if(ff.type == FD_PIPE)
801014dd:	83 c4 10             	add    $0x10,%esp
801014e0:	83 ff 01             	cmp    $0x1,%edi
801014e3:	74 13                	je     801014f8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801014e5:	83 ff 02             	cmp    $0x2,%edi
801014e8:	74 26                	je     80101510 <fileclose+0xa0>
}
801014ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ed:	5b                   	pop    %ebx
801014ee:	5e                   	pop    %esi
801014ef:	5f                   	pop    %edi
801014f0:	5d                   	pop    %ebp
801014f1:	c3                   	ret    
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
801014f8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801014fc:	83 ec 08             	sub    $0x8,%esp
801014ff:	53                   	push   %ebx
80101500:	56                   	push   %esi
80101501:	e8 7a 24 00 00       	call   80103980 <pipeclose>
80101506:	83 c4 10             	add    $0x10,%esp
80101509:	eb df                	jmp    801014ea <fileclose+0x7a>
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101510:	e8 bb 1c 00 00       	call   801031d0 <begin_op>
    iput(ff.ip);
80101515:	83 ec 0c             	sub    $0xc,%esp
80101518:	ff 75 e0             	pushl  -0x20(%ebp)
8010151b:	e8 c0 08 00 00       	call   80101de0 <iput>
    end_op();
80101520:	83 c4 10             	add    $0x10,%esp
}
80101523:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101526:	5b                   	pop    %ebx
80101527:	5e                   	pop    %esi
80101528:	5f                   	pop    %edi
80101529:	5d                   	pop    %ebp
    end_op();
8010152a:	e9 11 1d 00 00       	jmp    80103240 <end_op>
    panic("fileclose");
8010152f:	83 ec 0c             	sub    $0xc,%esp
80101532:	68 bc 79 10 80       	push   $0x801079bc
80101537:	e8 54 ee ff ff       	call   80100390 <panic>
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	53                   	push   %ebx
80101544:	83 ec 04             	sub    $0x4,%esp
80101547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010154a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010154d:	75 31                	jne    80101580 <filestat+0x40>
    ilock(f->ip);
8010154f:	83 ec 0c             	sub    $0xc,%esp
80101552:	ff 73 10             	pushl  0x10(%ebx)
80101555:	e8 56 07 00 00       	call   80101cb0 <ilock>
    stati(f->ip, st);
8010155a:	58                   	pop    %eax
8010155b:	5a                   	pop    %edx
8010155c:	ff 75 0c             	pushl  0xc(%ebp)
8010155f:	ff 73 10             	pushl  0x10(%ebx)
80101562:	e8 f9 09 00 00       	call   80101f60 <stati>
    iunlock(f->ip);
80101567:	59                   	pop    %ecx
80101568:	ff 73 10             	pushl  0x10(%ebx)
8010156b:	e8 20 08 00 00       	call   80101d90 <iunlock>
    return 0;
80101570:	83 c4 10             	add    $0x10,%esp
80101573:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101578:	c9                   	leave  
80101579:	c3                   	ret    
8010157a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101585:	eb ee                	jmp    80101575 <filestat+0x35>
80101587:	89 f6                	mov    %esi,%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101590 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
80101596:	83 ec 0c             	sub    $0xc,%esp
80101599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010159c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010159f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801015a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801015a6:	74 60                	je     80101608 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801015a8:	8b 03                	mov    (%ebx),%eax
801015aa:	83 f8 01             	cmp    $0x1,%eax
801015ad:	74 41                	je     801015f0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801015af:	83 f8 02             	cmp    $0x2,%eax
801015b2:	75 5b                	jne    8010160f <fileread+0x7f>
    ilock(f->ip);
801015b4:	83 ec 0c             	sub    $0xc,%esp
801015b7:	ff 73 10             	pushl  0x10(%ebx)
801015ba:	e8 f1 06 00 00       	call   80101cb0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801015bf:	57                   	push   %edi
801015c0:	ff 73 14             	pushl  0x14(%ebx)
801015c3:	56                   	push   %esi
801015c4:	ff 73 10             	pushl  0x10(%ebx)
801015c7:	e8 c4 09 00 00       	call   80101f90 <readi>
801015cc:	83 c4 20             	add    $0x20,%esp
801015cf:	85 c0                	test   %eax,%eax
801015d1:	89 c6                	mov    %eax,%esi
801015d3:	7e 03                	jle    801015d8 <fileread+0x48>
      f->off += r;
801015d5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801015d8:	83 ec 0c             	sub    $0xc,%esp
801015db:	ff 73 10             	pushl  0x10(%ebx)
801015de:	e8 ad 07 00 00       	call   80101d90 <iunlock>
    return r;
801015e3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801015e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015e9:	89 f0                	mov    %esi,%eax
801015eb:	5b                   	pop    %ebx
801015ec:	5e                   	pop    %esi
801015ed:	5f                   	pop    %edi
801015ee:	5d                   	pop    %ebp
801015ef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801015f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801015f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801015f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015f9:	5b                   	pop    %ebx
801015fa:	5e                   	pop    %esi
801015fb:	5f                   	pop    %edi
801015fc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801015fd:	e9 2e 25 00 00       	jmp    80103b30 <piperead>
80101602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101608:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010160d:	eb d7                	jmp    801015e6 <fileread+0x56>
  panic("fileread");
8010160f:	83 ec 0c             	sub    $0xc,%esp
80101612:	68 c6 79 10 80       	push   $0x801079c6
80101617:	e8 74 ed ff ff       	call   80100390 <panic>
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 1c             	sub    $0x1c,%esp
80101629:	8b 75 08             	mov    0x8(%ebp),%esi
8010162c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010162f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101633:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101636:	8b 45 10             	mov    0x10(%ebp),%eax
80101639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010163c:	0f 84 aa 00 00 00    	je     801016ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101642:	8b 06                	mov    (%esi),%eax
80101644:	83 f8 01             	cmp    $0x1,%eax
80101647:	0f 84 c3 00 00 00    	je     80101710 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010164d:	83 f8 02             	cmp    $0x2,%eax
80101650:	0f 85 d9 00 00 00    	jne    8010172f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101659:	31 ff                	xor    %edi,%edi
    while(i < n){
8010165b:	85 c0                	test   %eax,%eax
8010165d:	7f 34                	jg     80101693 <filewrite+0x73>
8010165f:	e9 9c 00 00 00       	jmp    80101700 <filewrite+0xe0>
80101664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101668:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010166b:	83 ec 0c             	sub    $0xc,%esp
8010166e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101671:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101674:	e8 17 07 00 00       	call   80101d90 <iunlock>
      end_op();
80101679:	e8 c2 1b 00 00       	call   80103240 <end_op>
8010167e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101681:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101684:	39 c3                	cmp    %eax,%ebx
80101686:	0f 85 96 00 00 00    	jne    80101722 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010168c:	01 df                	add    %ebx,%edi
    while(i < n){
8010168e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101691:	7e 6d                	jle    80101700 <filewrite+0xe0>
      int n1 = n - i;
80101693:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101696:	b8 00 06 00 00       	mov    $0x600,%eax
8010169b:	29 fb                	sub    %edi,%ebx
8010169d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801016a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801016a6:	e8 25 1b 00 00       	call   801031d0 <begin_op>
      ilock(f->ip);
801016ab:	83 ec 0c             	sub    $0xc,%esp
801016ae:	ff 76 10             	pushl  0x10(%esi)
801016b1:	e8 fa 05 00 00       	call   80101cb0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801016b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801016b9:	53                   	push   %ebx
801016ba:	ff 76 14             	pushl  0x14(%esi)
801016bd:	01 f8                	add    %edi,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 76 10             	pushl  0x10(%esi)
801016c3:	e8 c8 09 00 00       	call   80102090 <writei>
801016c8:	83 c4 20             	add    $0x20,%esp
801016cb:	85 c0                	test   %eax,%eax
801016cd:	7f 99                	jg     80101668 <filewrite+0x48>
      iunlock(f->ip);
801016cf:	83 ec 0c             	sub    $0xc,%esp
801016d2:	ff 76 10             	pushl  0x10(%esi)
801016d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801016d8:	e8 b3 06 00 00       	call   80101d90 <iunlock>
      end_op();
801016dd:	e8 5e 1b 00 00       	call   80103240 <end_op>
      if(r < 0)
801016e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801016e5:	83 c4 10             	add    $0x10,%esp
801016e8:	85 c0                	test   %eax,%eax
801016ea:	74 98                	je     80101684 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801016ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801016ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801016f4:	89 f8                	mov    %edi,%eax
801016f6:	5b                   	pop    %ebx
801016f7:	5e                   	pop    %esi
801016f8:	5f                   	pop    %edi
801016f9:	5d                   	pop    %ebp
801016fa:	c3                   	ret    
801016fb:	90                   	nop
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101700:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101703:	75 e7                	jne    801016ec <filewrite+0xcc>
}
80101705:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101708:	89 f8                	mov    %edi,%eax
8010170a:	5b                   	pop    %ebx
8010170b:	5e                   	pop    %esi
8010170c:	5f                   	pop    %edi
8010170d:	5d                   	pop    %ebp
8010170e:	c3                   	ret    
8010170f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101710:	8b 46 0c             	mov    0xc(%esi),%eax
80101713:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101716:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101719:	5b                   	pop    %ebx
8010171a:	5e                   	pop    %esi
8010171b:	5f                   	pop    %edi
8010171c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010171d:	e9 fe 22 00 00       	jmp    80103a20 <pipewrite>
        panic("short filewrite");
80101722:	83 ec 0c             	sub    $0xc,%esp
80101725:	68 cf 79 10 80       	push   $0x801079cf
8010172a:	e8 61 ec ff ff       	call   80100390 <panic>
  panic("filewrite");
8010172f:	83 ec 0c             	sub    $0xc,%esp
80101732:	68 d5 79 10 80       	push   $0x801079d5
80101737:	e8 54 ec ff ff       	call   80100390 <panic>
8010173c:	66 90                	xchg   %ax,%ax
8010173e:	66 90                	xchg   %ax,%ax

80101740 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101747:	c1 ea 0c             	shr    $0xc,%edx
8010174a:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101750:	83 ec 08             	sub    $0x8,%esp
80101753:	52                   	push   %edx
80101754:	50                   	push   %eax
80101755:	e8 76 e9 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010175a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010175c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010175f:	ba 01 00 00 00       	mov    $0x1,%edx
80101764:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101767:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010176d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101770:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101772:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101777:	85 d1                	test   %edx,%ecx
80101779:	74 25                	je     801017a0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010177b:	f7 d2                	not    %edx
8010177d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010177f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101782:	21 ca                	and    %ecx,%edx
80101784:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101788:	56                   	push   %esi
80101789:	e8 12 1c 00 00       	call   801033a0 <log_write>
  brelse(bp);
8010178e:	89 34 24             	mov    %esi,(%esp)
80101791:	e8 4a ea ff ff       	call   801001e0 <brelse>
}
80101796:	83 c4 10             	add    $0x10,%esp
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
8010179f:	c3                   	ret    
    panic("freeing free block");
801017a0:	83 ec 0c             	sub    $0xc,%esp
801017a3:	68 df 79 10 80       	push   $0x801079df
801017a8:	e8 e3 eb ff ff       	call   80100390 <panic>
801017ad:	8d 76 00             	lea    0x0(%esi),%esi

801017b0 <balloc>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801017b9:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
801017bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801017c2:	85 c9                	test   %ecx,%ecx
801017c4:	0f 84 87 00 00 00    	je     80101851 <balloc+0xa1>
801017ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801017d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801017d4:	83 ec 08             	sub    $0x8,%esp
801017d7:	89 f0                	mov    %esi,%eax
801017d9:	c1 f8 0c             	sar    $0xc,%eax
801017dc:	03 05 f8 19 11 80    	add    0x801119f8,%eax
801017e2:	50                   	push   %eax
801017e3:	ff 75 d8             	pushl  -0x28(%ebp)
801017e6:	e8 e5 e8 ff ff       	call   801000d0 <bread>
801017eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017ee:	a1 e0 19 11 80       	mov    0x801119e0,%eax
801017f3:	83 c4 10             	add    $0x10,%esp
801017f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801017f9:	31 c0                	xor    %eax,%eax
801017fb:	eb 2f                	jmp    8010182c <balloc+0x7c>
801017fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101800:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101802:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101805:	bb 01 00 00 00       	mov    $0x1,%ebx
8010180a:	83 e1 07             	and    $0x7,%ecx
8010180d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010180f:	89 c1                	mov    %eax,%ecx
80101811:	c1 f9 03             	sar    $0x3,%ecx
80101814:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101819:	85 df                	test   %ebx,%edi
8010181b:	89 fa                	mov    %edi,%edx
8010181d:	74 41                	je     80101860 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010181f:	83 c0 01             	add    $0x1,%eax
80101822:	83 c6 01             	add    $0x1,%esi
80101825:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010182a:	74 05                	je     80101831 <balloc+0x81>
8010182c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010182f:	77 cf                	ja     80101800 <balloc+0x50>
    brelse(bp);
80101831:	83 ec 0c             	sub    $0xc,%esp
80101834:	ff 75 e4             	pushl  -0x1c(%ebp)
80101837:	e8 a4 e9 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010183c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101843:	83 c4 10             	add    $0x10,%esp
80101846:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101849:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
8010184f:	77 80                	ja     801017d1 <balloc+0x21>
  panic("balloc: out of blocks");
80101851:	83 ec 0c             	sub    $0xc,%esp
80101854:	68 f2 79 10 80       	push   $0x801079f2
80101859:	e8 32 eb ff ff       	call   80100390 <panic>
8010185e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101860:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101863:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101866:	09 da                	or     %ebx,%edx
80101868:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010186c:	57                   	push   %edi
8010186d:	e8 2e 1b 00 00       	call   801033a0 <log_write>
        brelse(bp);
80101872:	89 3c 24             	mov    %edi,(%esp)
80101875:	e8 66 e9 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010187a:	58                   	pop    %eax
8010187b:	5a                   	pop    %edx
8010187c:	56                   	push   %esi
8010187d:	ff 75 d8             	pushl  -0x28(%ebp)
80101880:	e8 4b e8 ff ff       	call   801000d0 <bread>
80101885:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101887:	8d 40 5c             	lea    0x5c(%eax),%eax
8010188a:	83 c4 0c             	add    $0xc,%esp
8010188d:	68 00 02 00 00       	push   $0x200
80101892:	6a 00                	push   $0x0
80101894:	50                   	push   %eax
80101895:	e8 66 34 00 00       	call   80104d00 <memset>
  log_write(bp);
8010189a:	89 1c 24             	mov    %ebx,(%esp)
8010189d:	e8 fe 1a 00 00       	call   801033a0 <log_write>
  brelse(bp);
801018a2:	89 1c 24             	mov    %ebx,(%esp)
801018a5:	e8 36 e9 ff ff       	call   801001e0 <brelse>
}
801018aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ad:	89 f0                	mov    %esi,%eax
801018af:	5b                   	pop    %ebx
801018b0:	5e                   	pop    %esi
801018b1:	5f                   	pop    %edi
801018b2:	5d                   	pop    %ebp
801018b3:	c3                   	ret    
801018b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801018c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801018c8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018ca:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
801018cf:	83 ec 28             	sub    $0x28,%esp
801018d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801018d5:	68 00 1a 11 80       	push   $0x80111a00
801018da:	e8 11 33 00 00       	call   80104bf0 <acquire>
801018df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801018e5:	eb 17                	jmp    801018fe <iget+0x3e>
801018e7:	89 f6                	mov    %esi,%esi
801018e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801018f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018f6:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801018fc:	73 22                	jae    80101920 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101901:	85 c9                	test   %ecx,%ecx
80101903:	7e 04                	jle    80101909 <iget+0x49>
80101905:	39 3b                	cmp    %edi,(%ebx)
80101907:	74 4f                	je     80101958 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101909:	85 f6                	test   %esi,%esi
8010190b:	75 e3                	jne    801018f0 <iget+0x30>
8010190d:	85 c9                	test   %ecx,%ecx
8010190f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101912:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101918:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010191e:	72 de                	jb     801018fe <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101920:	85 f6                	test   %esi,%esi
80101922:	74 5b                	je     8010197f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101924:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101927:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101929:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010192c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101933:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010193a:	68 00 1a 11 80       	push   $0x80111a00
8010193f:	e8 6c 33 00 00       	call   80104cb0 <release>

  return ip;
80101944:	83 c4 10             	add    $0x10,%esp
}
80101947:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010194a:	89 f0                	mov    %esi,%eax
8010194c:	5b                   	pop    %ebx
8010194d:	5e                   	pop    %esi
8010194e:	5f                   	pop    %edi
8010194f:	5d                   	pop    %ebp
80101950:	c3                   	ret    
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101958:	39 53 04             	cmp    %edx,0x4(%ebx)
8010195b:	75 ac                	jne    80101909 <iget+0x49>
      release(&icache.lock);
8010195d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101960:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101963:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101965:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
8010196a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010196d:	e8 3e 33 00 00       	call   80104cb0 <release>
      return ip;
80101972:	83 c4 10             	add    $0x10,%esp
}
80101975:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101978:	89 f0                	mov    %esi,%eax
8010197a:	5b                   	pop    %ebx
8010197b:	5e                   	pop    %esi
8010197c:	5f                   	pop    %edi
8010197d:	5d                   	pop    %ebp
8010197e:	c3                   	ret    
    panic("iget: no inodes");
8010197f:	83 ec 0c             	sub    $0xc,%esp
80101982:	68 08 7a 10 80       	push   $0x80107a08
80101987:	e8 04 ea ff ff       	call   80100390 <panic>
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	89 c6                	mov    %eax,%esi
80101998:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010199b:	83 fa 0b             	cmp    $0xb,%edx
8010199e:	77 18                	ja     801019b8 <bmap+0x28>
801019a0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801019a3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801019a6:	85 db                	test   %ebx,%ebx
801019a8:	74 76                	je     80101a20 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801019aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ad:	89 d8                	mov    %ebx,%eax
801019af:	5b                   	pop    %ebx
801019b0:	5e                   	pop    %esi
801019b1:	5f                   	pop    %edi
801019b2:	5d                   	pop    %ebp
801019b3:	c3                   	ret    
801019b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801019b8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801019bb:	83 fb 7f             	cmp    $0x7f,%ebx
801019be:	0f 87 90 00 00 00    	ja     80101a54 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801019c4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801019ca:	8b 00                	mov    (%eax),%eax
801019cc:	85 d2                	test   %edx,%edx
801019ce:	74 70                	je     80101a40 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801019d0:	83 ec 08             	sub    $0x8,%esp
801019d3:	52                   	push   %edx
801019d4:	50                   	push   %eax
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801019da:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801019de:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801019e1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801019e3:	8b 1a                	mov    (%edx),%ebx
801019e5:	85 db                	test   %ebx,%ebx
801019e7:	75 1d                	jne    80101a06 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801019e9:	8b 06                	mov    (%esi),%eax
801019eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801019ee:	e8 bd fd ff ff       	call   801017b0 <balloc>
801019f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801019f6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801019f9:	89 c3                	mov    %eax,%ebx
801019fb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801019fd:	57                   	push   %edi
801019fe:	e8 9d 19 00 00       	call   801033a0 <log_write>
80101a03:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a06:	83 ec 0c             	sub    $0xc,%esp
80101a09:	57                   	push   %edi
80101a0a:	e8 d1 e7 ff ff       	call   801001e0 <brelse>
80101a0f:	83 c4 10             	add    $0x10,%esp
}
80101a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a15:	89 d8                	mov    %ebx,%eax
80101a17:	5b                   	pop    %ebx
80101a18:	5e                   	pop    %esi
80101a19:	5f                   	pop    %edi
80101a1a:	5d                   	pop    %ebp
80101a1b:	c3                   	ret    
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101a20:	8b 00                	mov    (%eax),%eax
80101a22:	e8 89 fd ff ff       	call   801017b0 <balloc>
80101a27:	89 47 5c             	mov    %eax,0x5c(%edi)
}
80101a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
80101a2d:	89 c3                	mov    %eax,%ebx
}
80101a2f:	89 d8                	mov    %ebx,%eax
80101a31:	5b                   	pop    %ebx
80101a32:	5e                   	pop    %esi
80101a33:	5f                   	pop    %edi
80101a34:	5d                   	pop    %ebp
80101a35:	c3                   	ret    
80101a36:	8d 76 00             	lea    0x0(%esi),%esi
80101a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101a40:	e8 6b fd ff ff       	call   801017b0 <balloc>
80101a45:	89 c2                	mov    %eax,%edx
80101a47:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101a4d:	8b 06                	mov    (%esi),%eax
80101a4f:	e9 7c ff ff ff       	jmp    801019d0 <bmap+0x40>
  panic("bmap: out of range");
80101a54:	83 ec 0c             	sub    $0xc,%esp
80101a57:	68 18 7a 10 80       	push   $0x80107a18
80101a5c:	e8 2f e9 ff ff       	call   80100390 <panic>
80101a61:	eb 0d                	jmp    80101a70 <readsb>
80101a63:	90                   	nop
80101a64:	90                   	nop
80101a65:	90                   	nop
80101a66:	90                   	nop
80101a67:	90                   	nop
80101a68:	90                   	nop
80101a69:	90                   	nop
80101a6a:	90                   	nop
80101a6b:	90                   	nop
80101a6c:	90                   	nop
80101a6d:	90                   	nop
80101a6e:	90                   	nop
80101a6f:	90                   	nop

80101a70 <readsb>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	56                   	push   %esi
80101a74:	53                   	push   %ebx
80101a75:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101a78:	83 ec 08             	sub    $0x8,%esp
80101a7b:	6a 01                	push   $0x1
80101a7d:	ff 75 08             	pushl  0x8(%ebp)
80101a80:	e8 4b e6 ff ff       	call   801000d0 <bread>
80101a85:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a87:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a8a:	83 c4 0c             	add    $0xc,%esp
80101a8d:	6a 1c                	push   $0x1c
80101a8f:	50                   	push   %eax
80101a90:	56                   	push   %esi
80101a91:	e8 1a 33 00 00       	call   80104db0 <memmove>
  brelse(bp);
80101a96:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a99:	83 c4 10             	add    $0x10,%esp
}
80101a9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a9f:	5b                   	pop    %ebx
80101aa0:	5e                   	pop    %esi
80101aa1:	5d                   	pop    %ebp
  brelse(bp);
80101aa2:	e9 39 e7 ff ff       	jmp    801001e0 <brelse>
80101aa7:	89 f6                	mov    %esi,%esi
80101aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ab0 <iinit>:
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	53                   	push   %ebx
80101ab4:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101ab9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101abc:	68 2b 7a 10 80       	push   $0x80107a2b
80101ac1:	68 00 1a 11 80       	push   $0x80111a00
80101ac6:	e8 e5 2f 00 00       	call   80104ab0 <initlock>
80101acb:	83 c4 10             	add    $0x10,%esp
80101ace:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101ad0:	83 ec 08             	sub    $0x8,%esp
80101ad3:	68 32 7a 10 80       	push   $0x80107a32
80101ad8:	53                   	push   %ebx
80101ad9:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101adf:	e8 9c 2e 00 00       	call   80104980 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101ae4:	83 c4 10             	add    $0x10,%esp
80101ae7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
80101aed:	75 e1                	jne    80101ad0 <iinit+0x20>
  readsb(dev, &sb);
80101aef:	83 ec 08             	sub    $0x8,%esp
80101af2:	68 e0 19 11 80       	push   $0x801119e0
80101af7:	ff 75 08             	pushl  0x8(%ebp)
80101afa:	e8 71 ff ff ff       	call   80101a70 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101aff:	ff 35 f8 19 11 80    	pushl  0x801119f8
80101b05:	ff 35 f4 19 11 80    	pushl  0x801119f4
80101b0b:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101b11:	ff 35 ec 19 11 80    	pushl  0x801119ec
80101b17:	ff 35 e8 19 11 80    	pushl  0x801119e8
80101b1d:	ff 35 e4 19 11 80    	pushl  0x801119e4
80101b23:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101b29:	68 98 7a 10 80       	push   $0x80107a98
80101b2e:	e8 2d eb ff ff       	call   80100660 <cprintf>
}
80101b33:	83 c4 30             	add    $0x30,%esp
80101b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b39:	c9                   	leave  
80101b3a:	c3                   	ret    
80101b3b:	90                   	nop
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b40 <ialloc>:
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	57                   	push   %edi
80101b44:	56                   	push   %esi
80101b45:	53                   	push   %ebx
80101b46:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b49:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101b50:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b53:	8b 75 08             	mov    0x8(%ebp),%esi
80101b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101b59:	0f 86 91 00 00 00    	jbe    80101bf0 <ialloc+0xb0>
80101b5f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101b64:	eb 21                	jmp    80101b87 <ialloc+0x47>
80101b66:	8d 76 00             	lea    0x0(%esi),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101b70:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b73:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101b76:	57                   	push   %edi
80101b77:	e8 64 e6 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b7c:	83 c4 10             	add    $0x10,%esp
80101b7f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101b85:	76 69                	jbe    80101bf0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b87:	89 d8                	mov    %ebx,%eax
80101b89:	83 ec 08             	sub    $0x8,%esp
80101b8c:	c1 e8 03             	shr    $0x3,%eax
80101b8f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101b95:	50                   	push   %eax
80101b96:	56                   	push   %esi
80101b97:	e8 34 e5 ff ff       	call   801000d0 <bread>
80101b9c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101b9e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101ba0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101ba3:	83 e0 07             	and    $0x7,%eax
80101ba6:	c1 e0 06             	shl    $0x6,%eax
80101ba9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101bad:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101bb1:	75 bd                	jne    80101b70 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101bb3:	83 ec 04             	sub    $0x4,%esp
80101bb6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101bb9:	6a 40                	push   $0x40
80101bbb:	6a 00                	push   $0x0
80101bbd:	51                   	push   %ecx
80101bbe:	e8 3d 31 00 00       	call   80104d00 <memset>
      dip->type = type;
80101bc3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101bc7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101bca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101bcd:	89 3c 24             	mov    %edi,(%esp)
80101bd0:	e8 cb 17 00 00       	call   801033a0 <log_write>
      brelse(bp);
80101bd5:	89 3c 24             	mov    %edi,(%esp)
80101bd8:	e8 03 e6 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
80101bdd:	83 c4 10             	add    $0x10,%esp
}
80101be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101be3:	89 da                	mov    %ebx,%edx
80101be5:	89 f0                	mov    %esi,%eax
}
80101be7:	5b                   	pop    %ebx
80101be8:	5e                   	pop    %esi
80101be9:	5f                   	pop    %edi
80101bea:	5d                   	pop    %ebp
      return iget(dev, inum);
80101beb:	e9 d0 fc ff ff       	jmp    801018c0 <iget>
  panic("ialloc: no inodes");
80101bf0:	83 ec 0c             	sub    $0xc,%esp
80101bf3:	68 38 7a 10 80       	push   $0x80107a38
80101bf8:	e8 93 e7 ff ff       	call   80100390 <panic>
80101bfd:	8d 76 00             	lea    0x0(%esi),%esi

80101c00 <iupdate>:
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	56                   	push   %esi
80101c04:	53                   	push   %ebx
80101c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c08:	83 ec 08             	sub    $0x8,%esp
80101c0b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c0e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c11:	c1 e8 03             	shr    $0x3,%eax
80101c14:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101c1a:	50                   	push   %eax
80101c1b:	ff 73 a4             	pushl  -0x5c(%ebx)
80101c1e:	e8 ad e4 ff ff       	call   801000d0 <bread>
80101c23:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c25:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101c28:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c2c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c2f:	83 e0 07             	and    $0x7,%eax
80101c32:	c1 e0 06             	shl    $0x6,%eax
80101c35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101c39:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101c3c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c40:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101c43:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101c47:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101c4b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101c4f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101c53:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101c57:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101c5a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c5d:	6a 34                	push   $0x34
80101c5f:	53                   	push   %ebx
80101c60:	50                   	push   %eax
80101c61:	e8 4a 31 00 00       	call   80104db0 <memmove>
  log_write(bp);
80101c66:	89 34 24             	mov    %esi,(%esp)
80101c69:	e8 32 17 00 00       	call   801033a0 <log_write>
  brelse(bp);
80101c6e:	89 75 08             	mov    %esi,0x8(%ebp)
80101c71:	83 c4 10             	add    $0x10,%esp
}
80101c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5d                   	pop    %ebp
  brelse(bp);
80101c7a:	e9 61 e5 ff ff       	jmp    801001e0 <brelse>
80101c7f:	90                   	nop

80101c80 <idup>:
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	53                   	push   %ebx
80101c84:	83 ec 10             	sub    $0x10,%esp
80101c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c8a:	68 00 1a 11 80       	push   $0x80111a00
80101c8f:	e8 5c 2f 00 00       	call   80104bf0 <acquire>
  ip->ref++;
80101c94:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c98:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c9f:	e8 0c 30 00 00       	call   80104cb0 <release>
}
80101ca4:	89 d8                	mov    %ebx,%eax
80101ca6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ca9:	c9                   	leave  
80101caa:	c3                   	ret    
80101cab:	90                   	nop
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <ilock>:
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	56                   	push   %esi
80101cb4:	53                   	push   %ebx
80101cb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101cb8:	85 db                	test   %ebx,%ebx
80101cba:	0f 84 b7 00 00 00    	je     80101d77 <ilock+0xc7>
80101cc0:	8b 53 08             	mov    0x8(%ebx),%edx
80101cc3:	85 d2                	test   %edx,%edx
80101cc5:	0f 8e ac 00 00 00    	jle    80101d77 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101ccb:	8d 43 0c             	lea    0xc(%ebx),%eax
80101cce:	83 ec 0c             	sub    $0xc,%esp
80101cd1:	50                   	push   %eax
80101cd2:	e8 e9 2c 00 00       	call   801049c0 <acquiresleep>
  if(ip->valid == 0){
80101cd7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	85 c0                	test   %eax,%eax
80101cdf:	74 0f                	je     80101cf0 <ilock+0x40>
}
80101ce1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ce4:	5b                   	pop    %ebx
80101ce5:	5e                   	pop    %esi
80101ce6:	5d                   	pop    %ebp
80101ce7:	c3                   	ret    
80101ce8:	90                   	nop
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cf0:	8b 43 04             	mov    0x4(%ebx),%eax
80101cf3:	83 ec 08             	sub    $0x8,%esp
80101cf6:	c1 e8 03             	shr    $0x3,%eax
80101cf9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101cff:	50                   	push   %eax
80101d00:	ff 33                	pushl  (%ebx)
80101d02:	e8 c9 e3 ff ff       	call   801000d0 <bread>
80101d07:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d09:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d0c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d0f:	83 e0 07             	and    $0x7,%eax
80101d12:	c1 e0 06             	shl    $0x6,%eax
80101d15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101d19:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d1c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101d1f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101d23:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101d27:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101d2b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101d2f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101d33:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101d37:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101d3b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101d3e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d41:	6a 34                	push   $0x34
80101d43:	50                   	push   %eax
80101d44:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101d47:	50                   	push   %eax
80101d48:	e8 63 30 00 00       	call   80104db0 <memmove>
    brelse(bp);
80101d4d:	89 34 24             	mov    %esi,(%esp)
80101d50:	e8 8b e4 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101d55:	83 c4 10             	add    $0x10,%esp
80101d58:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101d5d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d64:	0f 85 77 ff ff ff    	jne    80101ce1 <ilock+0x31>
      panic("ilock: no type");
80101d6a:	83 ec 0c             	sub    $0xc,%esp
80101d6d:	68 50 7a 10 80       	push   $0x80107a50
80101d72:	e8 19 e6 ff ff       	call   80100390 <panic>
    panic("ilock");
80101d77:	83 ec 0c             	sub    $0xc,%esp
80101d7a:	68 4a 7a 10 80       	push   $0x80107a4a
80101d7f:	e8 0c e6 ff ff       	call   80100390 <panic>
80101d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d90 <iunlock>:
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	56                   	push   %esi
80101d94:	53                   	push   %ebx
80101d95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d98:	85 db                	test   %ebx,%ebx
80101d9a:	74 28                	je     80101dc4 <iunlock+0x34>
80101d9c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	56                   	push   %esi
80101da3:	e8 b8 2c 00 00       	call   80104a60 <holdingsleep>
80101da8:	83 c4 10             	add    $0x10,%esp
80101dab:	85 c0                	test   %eax,%eax
80101dad:	74 15                	je     80101dc4 <iunlock+0x34>
80101daf:	8b 43 08             	mov    0x8(%ebx),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	7e 0e                	jle    80101dc4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101db6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101db9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dbc:	5b                   	pop    %ebx
80101dbd:	5e                   	pop    %esi
80101dbe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101dbf:	e9 5c 2c 00 00       	jmp    80104a20 <releasesleep>
    panic("iunlock");
80101dc4:	83 ec 0c             	sub    $0xc,%esp
80101dc7:	68 5f 7a 10 80       	push   $0x80107a5f
80101dcc:	e8 bf e5 ff ff       	call   80100390 <panic>
80101dd1:	eb 0d                	jmp    80101de0 <iput>
80101dd3:	90                   	nop
80101dd4:	90                   	nop
80101dd5:	90                   	nop
80101dd6:	90                   	nop
80101dd7:	90                   	nop
80101dd8:	90                   	nop
80101dd9:	90                   	nop
80101dda:	90                   	nop
80101ddb:	90                   	nop
80101ddc:	90                   	nop
80101ddd:	90                   	nop
80101dde:	90                   	nop
80101ddf:	90                   	nop

80101de0 <iput>:
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	83 ec 28             	sub    $0x28,%esp
80101de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101dec:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101def:	57                   	push   %edi
80101df0:	e8 cb 2b 00 00       	call   801049c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101df5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101df8:	83 c4 10             	add    $0x10,%esp
80101dfb:	85 d2                	test   %edx,%edx
80101dfd:	74 07                	je     80101e06 <iput+0x26>
80101dff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101e04:	74 32                	je     80101e38 <iput+0x58>
  releasesleep(&ip->lock);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	57                   	push   %edi
80101e0a:	e8 11 2c 00 00       	call   80104a20 <releasesleep>
  acquire(&icache.lock);
80101e0f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101e16:	e8 d5 2d 00 00       	call   80104bf0 <acquire>
  ip->ref--;
80101e1b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101e1f:	83 c4 10             	add    $0x10,%esp
80101e22:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e2c:	5b                   	pop    %ebx
80101e2d:	5e                   	pop    %esi
80101e2e:	5f                   	pop    %edi
80101e2f:	5d                   	pop    %ebp
  release(&icache.lock);
80101e30:	e9 7b 2e 00 00       	jmp    80104cb0 <release>
80101e35:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101e38:	83 ec 0c             	sub    $0xc,%esp
80101e3b:	68 00 1a 11 80       	push   $0x80111a00
80101e40:	e8 ab 2d 00 00       	call   80104bf0 <acquire>
    int r = ip->ref;
80101e45:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101e48:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101e4f:	e8 5c 2e 00 00       	call   80104cb0 <release>
    if(r == 1){
80101e54:	83 c4 10             	add    $0x10,%esp
80101e57:	83 fe 01             	cmp    $0x1,%esi
80101e5a:	75 aa                	jne    80101e06 <iput+0x26>
80101e5c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e65:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e68:	89 cf                	mov    %ecx,%edi
80101e6a:	eb 0b                	jmp    80101e77 <iput+0x97>
80101e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e70:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e73:	39 fe                	cmp    %edi,%esi
80101e75:	74 19                	je     80101e90 <iput+0xb0>
    if(ip->addrs[i]){
80101e77:	8b 16                	mov    (%esi),%edx
80101e79:	85 d2                	test   %edx,%edx
80101e7b:	74 f3                	je     80101e70 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101e7d:	8b 03                	mov    (%ebx),%eax
80101e7f:	e8 bc f8 ff ff       	call   80101740 <bfree>
      ip->addrs[i] = 0;
80101e84:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e8a:	eb e4                	jmp    80101e70 <iput+0x90>
80101e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e90:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e99:	85 c0                	test   %eax,%eax
80101e9b:	75 33                	jne    80101ed0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e9d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ea0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ea7:	53                   	push   %ebx
80101ea8:	e8 53 fd ff ff       	call   80101c00 <iupdate>
      ip->type = 0;
80101ead:	31 c0                	xor    %eax,%eax
80101eaf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101eb3:	89 1c 24             	mov    %ebx,(%esp)
80101eb6:	e8 45 fd ff ff       	call   80101c00 <iupdate>
      ip->valid = 0;
80101ebb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	e9 3c ff ff ff       	jmp    80101e06 <iput+0x26>
80101eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ed0:	83 ec 08             	sub    $0x8,%esp
80101ed3:	50                   	push   %eax
80101ed4:	ff 33                	pushl  (%ebx)
80101ed6:	e8 f5 e1 ff ff       	call   801000d0 <bread>
80101edb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ee1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ee4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101ee7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101eea:	83 c4 10             	add    $0x10,%esp
80101eed:	89 cf                	mov    %ecx,%edi
80101eef:	eb 0e                	jmp    80101eff <iput+0x11f>
80101ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101efb:	39 fe                	cmp    %edi,%esi
80101efd:	74 0f                	je     80101f0e <iput+0x12e>
      if(a[j])
80101eff:	8b 16                	mov    (%esi),%edx
80101f01:	85 d2                	test   %edx,%edx
80101f03:	74 f3                	je     80101ef8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101f05:	8b 03                	mov    (%ebx),%eax
80101f07:	e8 34 f8 ff ff       	call   80101740 <bfree>
80101f0c:	eb ea                	jmp    80101ef8 <iput+0x118>
    brelse(bp);
80101f0e:	83 ec 0c             	sub    $0xc,%esp
80101f11:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f14:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f17:	e8 c4 e2 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f1c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101f22:	8b 03                	mov    (%ebx),%eax
80101f24:	e8 17 f8 ff ff       	call   80101740 <bfree>
    ip->addrs[NDIRECT] = 0;
80101f29:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101f30:	00 00 00 
80101f33:	83 c4 10             	add    $0x10,%esp
80101f36:	e9 62 ff ff ff       	jmp    80101e9d <iput+0xbd>
80101f3b:	90                   	nop
80101f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f40 <iunlockput>:
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	53                   	push   %ebx
80101f44:	83 ec 10             	sub    $0x10,%esp
80101f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101f4a:	53                   	push   %ebx
80101f4b:	e8 40 fe ff ff       	call   80101d90 <iunlock>
  iput(ip);
80101f50:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f53:	83 c4 10             	add    $0x10,%esp
}
80101f56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f59:	c9                   	leave  
  iput(ip);
80101f5a:	e9 81 fe ff ff       	jmp    80101de0 <iput>
80101f5f:	90                   	nop

80101f60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	8b 55 08             	mov    0x8(%ebp),%edx
80101f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f69:	8b 0a                	mov    (%edx),%ecx
80101f6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f83:	8b 52 58             	mov    0x58(%edx),%edx
80101f86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f89:	5d                   	pop    %ebp
80101f8a:	c3                   	ret    
80101f8b:	90                   	nop
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	83 ec 1c             	sub    $0x1c,%esp
80101f99:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101fa7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101faa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101fad:	8b 75 10             	mov    0x10(%ebp),%esi
80101fb0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101fb3:	0f 84 a7 00 00 00    	je     80102060 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101fb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fbc:	8b 40 58             	mov    0x58(%eax),%eax
80101fbf:	39 c6                	cmp    %eax,%esi
80101fc1:	0f 87 ba 00 00 00    	ja     80102081 <readi+0xf1>
80101fc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101fca:	89 f9                	mov    %edi,%ecx
80101fcc:	01 f1                	add    %esi,%ecx
80101fce:	0f 82 ad 00 00 00    	jb     80102081 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101fd4:	89 c2                	mov    %eax,%edx
80101fd6:	29 f2                	sub    %esi,%edx
80101fd8:	39 c8                	cmp    %ecx,%eax
80101fda:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fdd:	31 ff                	xor    %edi,%edi
80101fdf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101fe1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fe4:	74 6c                	je     80102052 <readi+0xc2>
80101fe6:	8d 76 00             	lea    0x0(%esi),%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ff0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ff3:	89 f2                	mov    %esi,%edx
80101ff5:	c1 ea 09             	shr    $0x9,%edx
80101ff8:	89 d8                	mov    %ebx,%eax
80101ffa:	e8 91 f9 ff ff       	call   80101990 <bmap>
80101fff:	83 ec 08             	sub    $0x8,%esp
80102002:	50                   	push   %eax
80102003:	ff 33                	pushl  (%ebx)
80102005:	e8 c6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010200a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010200d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
8010200f:	89 f0                	mov    %esi,%eax
80102011:	25 ff 01 00 00       	and    $0x1ff,%eax
80102016:	b9 00 02 00 00       	mov    $0x200,%ecx
8010201b:	83 c4 0c             	add    $0xc,%esp
8010201e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102020:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80102024:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102027:	29 fb                	sub    %edi,%ebx
80102029:	39 d9                	cmp    %ebx,%ecx
8010202b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010202e:	53                   	push   %ebx
8010202f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102030:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102032:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102035:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102037:	e8 74 2d 00 00       	call   80104db0 <memmove>
    brelse(bp);
8010203c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010203f:	89 14 24             	mov    %edx,(%esp)
80102042:	e8 99 e1 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102047:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102050:	77 9e                	ja     80101ff0 <readi+0x60>
  }
  return n;
80102052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102055:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102058:	5b                   	pop    %ebx
80102059:	5e                   	pop    %esi
8010205a:	5f                   	pop    %edi
8010205b:	5d                   	pop    %ebp
8010205c:	c3                   	ret    
8010205d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102060:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102064:	66 83 f8 09          	cmp    $0x9,%ax
80102068:	77 17                	ja     80102081 <readi+0xf1>
8010206a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80102071:	85 c0                	test   %eax,%eax
80102073:	74 0c                	je     80102081 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102075:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5f                   	pop    %edi
8010207e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010207f:	ff e0                	jmp    *%eax
      return -1;
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb cd                	jmp    80102055 <readi+0xc5>
80102088:	90                   	nop
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
80102099:	8b 45 08             	mov    0x8(%ebp),%eax
8010209c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010209f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801020a7:	89 75 dc             	mov    %esi,-0x24(%ebp)
801020aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020ad:	8b 75 10             	mov    0x10(%ebp),%esi
801020b0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801020b3:	0f 84 b7 00 00 00    	je     80102170 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801020b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020bc:	39 70 58             	cmp    %esi,0x58(%eax)
801020bf:	0f 82 eb 00 00 00    	jb     801021b0 <writei+0x120>
801020c5:	8b 7d e0             	mov    -0x20(%ebp),%edi
801020c8:	31 d2                	xor    %edx,%edx
801020ca:	89 f8                	mov    %edi,%eax
801020cc:	01 f0                	add    %esi,%eax
801020ce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
801020d1:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020d6:	0f 87 d4 00 00 00    	ja     801021b0 <writei+0x120>
801020dc:	85 d2                	test   %edx,%edx
801020de:	0f 85 cc 00 00 00    	jne    801021b0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e4:	85 ff                	test   %edi,%edi
801020e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801020ed:	74 72                	je     80102161 <writei+0xd1>
801020ef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020f0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801020f3:	89 f2                	mov    %esi,%edx
801020f5:	c1 ea 09             	shr    $0x9,%edx
801020f8:	89 f8                	mov    %edi,%eax
801020fa:	e8 91 f8 ff ff       	call   80101990 <bmap>
801020ff:	83 ec 08             	sub    $0x8,%esp
80102102:	50                   	push   %eax
80102103:	ff 37                	pushl  (%edi)
80102105:	e8 c6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010210a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010210d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102110:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102112:	89 f0                	mov    %esi,%eax
80102114:	b9 00 02 00 00       	mov    $0x200,%ecx
80102119:	83 c4 0c             	add    $0xc,%esp
8010211c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102121:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102123:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102127:	39 d9                	cmp    %ebx,%ecx
80102129:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010212c:	53                   	push   %ebx
8010212d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102130:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80102132:	50                   	push   %eax
80102133:	e8 78 2c 00 00       	call   80104db0 <memmove>
    log_write(bp);
80102138:	89 3c 24             	mov    %edi,(%esp)
8010213b:	e8 60 12 00 00       	call   801033a0 <log_write>
    brelse(bp);
80102140:	89 3c 24             	mov    %edi,(%esp)
80102143:	e8 98 e0 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102148:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010214b:	01 5d dc             	add    %ebx,-0x24(%ebp)
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102154:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102157:	77 97                	ja     801020f0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102159:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010215c:	3b 70 58             	cmp    0x58(%eax),%esi
8010215f:	77 37                	ja     80102198 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102161:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102167:	5b                   	pop    %ebx
80102168:	5e                   	pop    %esi
80102169:	5f                   	pop    %edi
8010216a:	5d                   	pop    %ebp
8010216b:	c3                   	ret    
8010216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102170:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102174:	66 83 f8 09          	cmp    $0x9,%ax
80102178:	77 36                	ja     801021b0 <writei+0x120>
8010217a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80102181:	85 c0                	test   %eax,%eax
80102183:	74 2b                	je     801021b0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80102185:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102188:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218b:	5b                   	pop    %ebx
8010218c:	5e                   	pop    %esi
8010218d:	5f                   	pop    %edi
8010218e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010218f:	ff e0                	jmp    *%eax
80102191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102198:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010219b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010219e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801021a1:	50                   	push   %eax
801021a2:	e8 59 fa ff ff       	call   80101c00 <iupdate>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	eb b5                	jmp    80102161 <writei+0xd1>
801021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
801021b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b5:	eb ad                	jmp    80102164 <writei+0xd4>
801021b7:	89 f6                	mov    %esi,%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801021c6:	6a 0e                	push   $0xe
801021c8:	ff 75 0c             	pushl  0xc(%ebp)
801021cb:	ff 75 08             	pushl  0x8(%ebp)
801021ce:	e8 4d 2c 00 00       	call   80104e20 <strncmp>
}
801021d3:	c9                   	leave  
801021d4:	c3                   	ret    
801021d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	57                   	push   %edi
801021e4:	56                   	push   %esi
801021e5:	53                   	push   %ebx
801021e6:	83 ec 1c             	sub    $0x1c,%esp
801021e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021f1:	0f 85 85 00 00 00    	jne    8010227c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f7:	8b 53 58             	mov    0x58(%ebx),%edx
801021fa:	31 ff                	xor    %edi,%edi
801021fc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021ff:	85 d2                	test   %edx,%edx
80102201:	74 3e                	je     80102241 <dirlookup+0x61>
80102203:	90                   	nop
80102204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102208:	6a 10                	push   $0x10
8010220a:	57                   	push   %edi
8010220b:	56                   	push   %esi
8010220c:	53                   	push   %ebx
8010220d:	e8 7e fd ff ff       	call   80101f90 <readi>
80102212:	83 c4 10             	add    $0x10,%esp
80102215:	83 f8 10             	cmp    $0x10,%eax
80102218:	75 55                	jne    8010226f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010221a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010221f:	74 18                	je     80102239 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102221:	8d 45 da             	lea    -0x26(%ebp),%eax
80102224:	83 ec 04             	sub    $0x4,%esp
80102227:	6a 0e                	push   $0xe
80102229:	50                   	push   %eax
8010222a:	ff 75 0c             	pushl  0xc(%ebp)
8010222d:	e8 ee 2b 00 00       	call   80104e20 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102232:	83 c4 10             	add    $0x10,%esp
80102235:	85 c0                	test   %eax,%eax
80102237:	74 17                	je     80102250 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102239:	83 c7 10             	add    $0x10,%edi
8010223c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010223f:	72 c7                	jb     80102208 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102241:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102244:	31 c0                	xor    %eax,%eax
}
80102246:	5b                   	pop    %ebx
80102247:	5e                   	pop    %esi
80102248:	5f                   	pop    %edi
80102249:	5d                   	pop    %ebp
8010224a:	c3                   	ret    
8010224b:	90                   	nop
8010224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80102250:	8b 45 10             	mov    0x10(%ebp),%eax
80102253:	85 c0                	test   %eax,%eax
80102255:	74 05                	je     8010225c <dirlookup+0x7c>
        *poff = off;
80102257:	8b 45 10             	mov    0x10(%ebp),%eax
8010225a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010225c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102260:	8b 03                	mov    (%ebx),%eax
80102262:	e8 59 f6 ff ff       	call   801018c0 <iget>
}
80102267:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010226a:	5b                   	pop    %ebx
8010226b:	5e                   	pop    %esi
8010226c:	5f                   	pop    %edi
8010226d:	5d                   	pop    %ebp
8010226e:	c3                   	ret    
      panic("dirlookup read");
8010226f:	83 ec 0c             	sub    $0xc,%esp
80102272:	68 79 7a 10 80       	push   $0x80107a79
80102277:	e8 14 e1 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
8010227c:	83 ec 0c             	sub    $0xc,%esp
8010227f:	68 67 7a 10 80       	push   $0x80107a67
80102284:	e8 07 e1 ff ff       	call   80100390 <panic>
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102290 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	89 cf                	mov    %ecx,%edi
80102298:	89 c3                	mov    %eax,%ebx
8010229a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010229d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801022a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
801022a3:	0f 84 67 01 00 00    	je     80102410 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801022a9:	e8 72 1b 00 00       	call   80103e20 <myproc>
  acquire(&icache.lock);
801022ae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801022b1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801022b4:	68 00 1a 11 80       	push   $0x80111a00
801022b9:	e8 32 29 00 00       	call   80104bf0 <acquire>
  ip->ref++;
801022be:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801022c2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801022c9:	e8 e2 29 00 00       	call   80104cb0 <release>
801022ce:	83 c4 10             	add    $0x10,%esp
801022d1:	eb 08                	jmp    801022db <namex+0x4b>
801022d3:	90                   	nop
801022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801022db:	0f b6 03             	movzbl (%ebx),%eax
801022de:	3c 2f                	cmp    $0x2f,%al
801022e0:	74 f6                	je     801022d8 <namex+0x48>
  if(*path == 0)
801022e2:	84 c0                	test   %al,%al
801022e4:	0f 84 ee 00 00 00    	je     801023d8 <namex+0x148>
  while(*path != '/' && *path != 0)
801022ea:	0f b6 03             	movzbl (%ebx),%eax
801022ed:	3c 2f                	cmp    $0x2f,%al
801022ef:	0f 84 b3 00 00 00    	je     801023a8 <namex+0x118>
801022f5:	84 c0                	test   %al,%al
801022f7:	89 da                	mov    %ebx,%edx
801022f9:	75 09                	jne    80102304 <namex+0x74>
801022fb:	e9 a8 00 00 00       	jmp    801023a8 <namex+0x118>
80102300:	84 c0                	test   %al,%al
80102302:	74 0a                	je     8010230e <namex+0x7e>
    path++;
80102304:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102307:	0f b6 02             	movzbl (%edx),%eax
8010230a:	3c 2f                	cmp    $0x2f,%al
8010230c:	75 f2                	jne    80102300 <namex+0x70>
8010230e:	89 d1                	mov    %edx,%ecx
80102310:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102312:	83 f9 0d             	cmp    $0xd,%ecx
80102315:	0f 8e 91 00 00 00    	jle    801023ac <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010231b:	83 ec 04             	sub    $0x4,%esp
8010231e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102321:	6a 0e                	push   $0xe
80102323:	53                   	push   %ebx
80102324:	57                   	push   %edi
80102325:	e8 86 2a 00 00       	call   80104db0 <memmove>
    path++;
8010232a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010232d:	83 c4 10             	add    $0x10,%esp
    path++;
80102330:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102332:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102335:	75 11                	jne    80102348 <namex+0xb8>
80102337:	89 f6                	mov    %esi,%esi
80102339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102340:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102343:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102346:	74 f8                	je     80102340 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	56                   	push   %esi
8010234c:	e8 5f f9 ff ff       	call   80101cb0 <ilock>
    if(ip->type != T_DIR){
80102351:	83 c4 10             	add    $0x10,%esp
80102354:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102359:	0f 85 91 00 00 00    	jne    801023f0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010235f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102362:	85 d2                	test   %edx,%edx
80102364:	74 09                	je     8010236f <namex+0xdf>
80102366:	80 3b 00             	cmpb   $0x0,(%ebx)
80102369:	0f 84 b7 00 00 00    	je     80102426 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010236f:	83 ec 04             	sub    $0x4,%esp
80102372:	6a 00                	push   $0x0
80102374:	57                   	push   %edi
80102375:	56                   	push   %esi
80102376:	e8 65 fe ff ff       	call   801021e0 <dirlookup>
8010237b:	83 c4 10             	add    $0x10,%esp
8010237e:	85 c0                	test   %eax,%eax
80102380:	74 6e                	je     801023f0 <namex+0x160>
  iunlock(ip);
80102382:	83 ec 0c             	sub    $0xc,%esp
80102385:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102388:	56                   	push   %esi
80102389:	e8 02 fa ff ff       	call   80101d90 <iunlock>
  iput(ip);
8010238e:	89 34 24             	mov    %esi,(%esp)
80102391:	e8 4a fa ff ff       	call   80101de0 <iput>
80102396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	89 c6                	mov    %eax,%esi
8010239e:	e9 38 ff ff ff       	jmp    801022db <namex+0x4b>
801023a3:	90                   	nop
801023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801023ac:	83 ec 04             	sub    $0x4,%esp
801023af:	89 55 dc             	mov    %edx,-0x24(%ebp)
801023b2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801023b5:	51                   	push   %ecx
801023b6:	53                   	push   %ebx
801023b7:	57                   	push   %edi
801023b8:	e8 f3 29 00 00       	call   80104db0 <memmove>
    name[len] = 0;
801023bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801023c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801023c3:	83 c4 10             	add    $0x10,%esp
801023c6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801023ca:	89 d3                	mov    %edx,%ebx
801023cc:	e9 61 ff ff ff       	jmp    80102332 <namex+0xa2>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023db:	85 c0                	test   %eax,%eax
801023dd:	75 5d                	jne    8010243c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801023df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e2:	89 f0                	mov    %esi,%eax
801023e4:	5b                   	pop    %ebx
801023e5:	5e                   	pop    %esi
801023e6:	5f                   	pop    %edi
801023e7:	5d                   	pop    %ebp
801023e8:	c3                   	ret    
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801023f0:	83 ec 0c             	sub    $0xc,%esp
801023f3:	56                   	push   %esi
801023f4:	e8 97 f9 ff ff       	call   80101d90 <iunlock>
  iput(ip);
801023f9:	89 34 24             	mov    %esi,(%esp)
      return 0;
801023fc:	31 f6                	xor    %esi,%esi
  iput(ip);
801023fe:	e8 dd f9 ff ff       	call   80101de0 <iput>
      return 0;
80102403:	83 c4 10             	add    $0x10,%esp
}
80102406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102409:	89 f0                	mov    %esi,%eax
8010240b:	5b                   	pop    %ebx
8010240c:	5e                   	pop    %esi
8010240d:	5f                   	pop    %edi
8010240e:	5d                   	pop    %ebp
8010240f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102410:	ba 01 00 00 00       	mov    $0x1,%edx
80102415:	b8 01 00 00 00       	mov    $0x1,%eax
8010241a:	e8 a1 f4 ff ff       	call   801018c0 <iget>
8010241f:	89 c6                	mov    %eax,%esi
80102421:	e9 b5 fe ff ff       	jmp    801022db <namex+0x4b>
      iunlock(ip);
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	56                   	push   %esi
8010242a:	e8 61 f9 ff ff       	call   80101d90 <iunlock>
      return ip;
8010242f:	83 c4 10             	add    $0x10,%esp
}
80102432:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102435:	89 f0                	mov    %esi,%eax
80102437:	5b                   	pop    %ebx
80102438:	5e                   	pop    %esi
80102439:	5f                   	pop    %edi
8010243a:	5d                   	pop    %ebp
8010243b:	c3                   	ret    
    iput(ip);
8010243c:	83 ec 0c             	sub    $0xc,%esp
8010243f:	56                   	push   %esi
    return 0;
80102440:	31 f6                	xor    %esi,%esi
    iput(ip);
80102442:	e8 99 f9 ff ff       	call   80101de0 <iput>
    return 0;
80102447:	83 c4 10             	add    $0x10,%esp
8010244a:	eb 93                	jmp    801023df <namex+0x14f>
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102450 <dirlink>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	57                   	push   %edi
80102454:	56                   	push   %esi
80102455:	53                   	push   %ebx
80102456:	83 ec 20             	sub    $0x20,%esp
80102459:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010245c:	6a 00                	push   $0x0
8010245e:	ff 75 0c             	pushl  0xc(%ebp)
80102461:	53                   	push   %ebx
80102462:	e8 79 fd ff ff       	call   801021e0 <dirlookup>
80102467:	83 c4 10             	add    $0x10,%esp
8010246a:	85 c0                	test   %eax,%eax
8010246c:	75 67                	jne    801024d5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010246e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102471:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102474:	85 ff                	test   %edi,%edi
80102476:	74 29                	je     801024a1 <dirlink+0x51>
80102478:	31 ff                	xor    %edi,%edi
8010247a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010247d:	eb 09                	jmp    80102488 <dirlink+0x38>
8010247f:	90                   	nop
80102480:	83 c7 10             	add    $0x10,%edi
80102483:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102486:	73 19                	jae    801024a1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102488:	6a 10                	push   $0x10
8010248a:	57                   	push   %edi
8010248b:	56                   	push   %esi
8010248c:	53                   	push   %ebx
8010248d:	e8 fe fa ff ff       	call   80101f90 <readi>
80102492:	83 c4 10             	add    $0x10,%esp
80102495:	83 f8 10             	cmp    $0x10,%eax
80102498:	75 4e                	jne    801024e8 <dirlink+0x98>
    if(de.inum == 0)
8010249a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010249f:	75 df                	jne    80102480 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801024a1:	8d 45 da             	lea    -0x26(%ebp),%eax
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	6a 0e                	push   $0xe
801024a9:	ff 75 0c             	pushl  0xc(%ebp)
801024ac:	50                   	push   %eax
801024ad:	e8 ce 29 00 00       	call   80104e80 <strncpy>
  de.inum = inum;
801024b2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024b5:	6a 10                	push   $0x10
801024b7:	57                   	push   %edi
801024b8:	56                   	push   %esi
801024b9:	53                   	push   %ebx
  de.inum = inum;
801024ba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024be:	e8 cd fb ff ff       	call   80102090 <writei>
801024c3:	83 c4 20             	add    $0x20,%esp
801024c6:	83 f8 10             	cmp    $0x10,%eax
801024c9:	75 2a                	jne    801024f5 <dirlink+0xa5>
  return 0;
801024cb:	31 c0                	xor    %eax,%eax
}
801024cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024d0:	5b                   	pop    %ebx
801024d1:	5e                   	pop    %esi
801024d2:	5f                   	pop    %edi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    
    iput(ip);
801024d5:	83 ec 0c             	sub    $0xc,%esp
801024d8:	50                   	push   %eax
801024d9:	e8 02 f9 ff ff       	call   80101de0 <iput>
    return -1;
801024de:	83 c4 10             	add    $0x10,%esp
801024e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024e6:	eb e5                	jmp    801024cd <dirlink+0x7d>
      panic("dirlink read");
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 88 7a 10 80       	push   $0x80107a88
801024f0:	e8 9b de ff ff       	call   80100390 <panic>
    panic("dirlink");
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	68 12 81 10 80       	push   $0x80108112
801024fd:	e8 8e de ff ff       	call   80100390 <panic>
80102502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <namei>:

struct inode*
namei(char *path)
{
80102510:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102511:	31 d2                	xor    %edx,%edx
{
80102513:	89 e5                	mov    %esp,%ebp
80102515:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
8010251b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010251e:	e8 6d fd ff ff       	call   80102290 <namex>
}
80102523:	c9                   	leave  
80102524:	c3                   	ret    
80102525:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102530 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102530:	55                   	push   %ebp
  return namex(path, 1, name);
80102531:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102536:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102538:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010253b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010253e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010253f:	e9 4c fd ff ff       	jmp    80102290 <namex>
80102544:	66 90                	xchg   %ax,%ax
80102546:	66 90                	xchg   %ax,%ax
80102548:	66 90                	xchg   %ax,%ax
8010254a:	66 90                	xchg   %ax,%ax
8010254c:	66 90                	xchg   %ax,%ax
8010254e:	66 90                	xchg   %ax,%ax

80102550 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	57                   	push   %edi
80102554:	56                   	push   %esi
80102555:	53                   	push   %ebx
80102556:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102559:	85 c0                	test   %eax,%eax
8010255b:	0f 84 b4 00 00 00    	je     80102615 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102561:	8b 58 08             	mov    0x8(%eax),%ebx
80102564:	89 c6                	mov    %eax,%esi
80102566:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010256c:	0f 87 96 00 00 00    	ja     80102608 <idestart+0xb8>
80102572:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102577:	89 f6                	mov    %esi,%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102580:	89 ca                	mov    %ecx,%edx
80102582:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102583:	83 e0 c0             	and    $0xffffffc0,%eax
80102586:	3c 40                	cmp    $0x40,%al
80102588:	75 f6                	jne    80102580 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010258a:	31 ff                	xor    %edi,%edi
8010258c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102591:	89 f8                	mov    %edi,%eax
80102593:	ee                   	out    %al,(%dx)
80102594:	b8 01 00 00 00       	mov    $0x1,%eax
80102599:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010259e:	ee                   	out    %al,(%dx)
8010259f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025a4:	89 d8                	mov    %ebx,%eax
801025a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025a7:	89 d8                	mov    %ebx,%eax
801025a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025ae:	c1 f8 08             	sar    $0x8,%eax
801025b1:	ee                   	out    %al,(%dx)
801025b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025b7:	89 f8                	mov    %edi,%eax
801025b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025ba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801025be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025c3:	c1 e0 04             	shl    $0x4,%eax
801025c6:	83 e0 10             	and    $0x10,%eax
801025c9:	83 c8 e0             	or     $0xffffffe0,%eax
801025cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025cd:	f6 06 04             	testb  $0x4,(%esi)
801025d0:	75 16                	jne    801025e8 <idestart+0x98>
801025d2:	b8 20 00 00 00       	mov    $0x20,%eax
801025d7:	89 ca                	mov    %ecx,%edx
801025d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801025da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025dd:	5b                   	pop    %ebx
801025de:	5e                   	pop    %esi
801025df:	5f                   	pop    %edi
801025e0:	5d                   	pop    %ebp
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025e8:	b8 30 00 00 00       	mov    $0x30,%eax
801025ed:	89 ca                	mov    %ecx,%edx
801025ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801025f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801025f5:	83 c6 5c             	add    $0x5c,%esi
801025f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025fd:	fc                   	cld    
801025fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102603:	5b                   	pop    %ebx
80102604:	5e                   	pop    %esi
80102605:	5f                   	pop    %edi
80102606:	5d                   	pop    %ebp
80102607:	c3                   	ret    
    panic("incorrect blockno");
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	68 f4 7a 10 80       	push   $0x80107af4
80102610:	e8 7b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102615:	83 ec 0c             	sub    $0xc,%esp
80102618:	68 eb 7a 10 80       	push   $0x80107aeb
8010261d:	e8 6e dd ff ff       	call   80100390 <panic>
80102622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <ideinit>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102636:	68 06 7b 10 80       	push   $0x80107b06
8010263b:	68 a0 b5 10 80       	push   $0x8010b5a0
80102640:	e8 6b 24 00 00       	call   80104ab0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102645:	58                   	pop    %eax
80102646:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010264b:	5a                   	pop    %edx
8010264c:	83 e8 01             	sub    $0x1,%eax
8010264f:	50                   	push   %eax
80102650:	6a 0e                	push   $0xe
80102652:	e8 a9 02 00 00       	call   80102900 <ioapicenable>
80102657:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010265a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010265f:	90                   	nop
80102660:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102661:	83 e0 c0             	and    $0xffffffc0,%eax
80102664:	3c 40                	cmp    $0x40,%al
80102666:	75 f8                	jne    80102660 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102668:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010266d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102672:	ee                   	out    %al,(%dx)
80102673:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102678:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010267d:	eb 06                	jmp    80102685 <ideinit+0x55>
8010267f:	90                   	nop
  for(i=0; i<1000; i++){
80102680:	83 e9 01             	sub    $0x1,%ecx
80102683:	74 0f                	je     80102694 <ideinit+0x64>
80102685:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102686:	84 c0                	test   %al,%al
80102688:	74 f6                	je     80102680 <ideinit+0x50>
      havedisk1 = 1;
8010268a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102691:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102694:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102699:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010269e:	ee                   	out    %al,(%dx)
}
8010269f:	c9                   	leave  
801026a0:	c3                   	ret    
801026a1:	eb 0d                	jmp    801026b0 <ideintr>
801026a3:	90                   	nop
801026a4:	90                   	nop
801026a5:	90                   	nop
801026a6:	90                   	nop
801026a7:	90                   	nop
801026a8:	90                   	nop
801026a9:	90                   	nop
801026aa:	90                   	nop
801026ab:	90                   	nop
801026ac:	90                   	nop
801026ad:	90                   	nop
801026ae:	90                   	nop
801026af:	90                   	nop

801026b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	57                   	push   %edi
801026b4:	56                   	push   %esi
801026b5:	53                   	push   %ebx
801026b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026b9:	68 a0 b5 10 80       	push   $0x8010b5a0
801026be:	e8 2d 25 00 00       	call   80104bf0 <acquire>

  if((b = idequeue) == 0){
801026c3:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
801026c9:	83 c4 10             	add    $0x10,%esp
801026cc:	85 db                	test   %ebx,%ebx
801026ce:	74 67                	je     80102737 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801026d0:	8b 43 58             	mov    0x58(%ebx),%eax
801026d3:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026d8:	8b 3b                	mov    (%ebx),%edi
801026da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801026e0:	75 31                	jne    80102713 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801026f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026f1:	89 c6                	mov    %eax,%esi
801026f3:	83 e6 c0             	and    $0xffffffc0,%esi
801026f6:	89 f1                	mov    %esi,%ecx
801026f8:	80 f9 40             	cmp    $0x40,%cl
801026fb:	75 f3                	jne    801026f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026fd:	a8 21                	test   $0x21,%al
801026ff:	75 12                	jne    80102713 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102701:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102704:	b9 80 00 00 00       	mov    $0x80,%ecx
80102709:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010270e:	fc                   	cld    
8010270f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102711:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102713:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102716:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102719:	89 f9                	mov    %edi,%ecx
8010271b:	83 c9 02             	or     $0x2,%ecx
8010271e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102720:	53                   	push   %ebx
80102721:	e8 5a 1e 00 00       	call   80104580 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102726:	a1 84 b5 10 80       	mov    0x8010b584,%eax
8010272b:	83 c4 10             	add    $0x10,%esp
8010272e:	85 c0                	test   %eax,%eax
80102730:	74 05                	je     80102737 <ideintr+0x87>
    idestart(idequeue);
80102732:	e8 19 fe ff ff       	call   80102550 <idestart>
    release(&idelock);
80102737:	83 ec 0c             	sub    $0xc,%esp
8010273a:	68 a0 b5 10 80       	push   $0x8010b5a0
8010273f:	e8 6c 25 00 00       	call   80104cb0 <release>

  release(&idelock);
}
80102744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102747:	5b                   	pop    %ebx
80102748:	5e                   	pop    %esi
80102749:	5f                   	pop    %edi
8010274a:	5d                   	pop    %ebp
8010274b:	c3                   	ret    
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	53                   	push   %ebx
80102754:	83 ec 10             	sub    $0x10,%esp
80102757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010275a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010275d:	50                   	push   %eax
8010275e:	e8 fd 22 00 00       	call   80104a60 <holdingsleep>
80102763:	83 c4 10             	add    $0x10,%esp
80102766:	85 c0                	test   %eax,%eax
80102768:	0f 84 c6 00 00 00    	je     80102834 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010276e:	8b 03                	mov    (%ebx),%eax
80102770:	83 e0 06             	and    $0x6,%eax
80102773:	83 f8 02             	cmp    $0x2,%eax
80102776:	0f 84 ab 00 00 00    	je     80102827 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010277c:	8b 53 04             	mov    0x4(%ebx),%edx
8010277f:	85 d2                	test   %edx,%edx
80102781:	74 0d                	je     80102790 <iderw+0x40>
80102783:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80102788:	85 c0                	test   %eax,%eax
8010278a:	0f 84 b1 00 00 00    	je     80102841 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 a0 b5 10 80       	push   $0x8010b5a0
80102798:	e8 53 24 00 00       	call   80104bf0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010279d:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
801027a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801027a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ad:	85 d2                	test   %edx,%edx
801027af:	75 09                	jne    801027ba <iderw+0x6a>
801027b1:	eb 6d                	jmp    80102820 <iderw+0xd0>
801027b3:	90                   	nop
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b8:	89 c2                	mov    %eax,%edx
801027ba:	8b 42 58             	mov    0x58(%edx),%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	75 f7                	jne    801027b8 <iderw+0x68>
801027c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027c6:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
801027cc:	74 42                	je     80102810 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ce:	8b 03                	mov    (%ebx),%eax
801027d0:	83 e0 06             	and    $0x6,%eax
801027d3:	83 f8 02             	cmp    $0x2,%eax
801027d6:	74 23                	je     801027fb <iderw+0xab>
801027d8:	90                   	nop
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801027e0:	83 ec 08             	sub    $0x8,%esp
801027e3:	68 a0 b5 10 80       	push   $0x8010b5a0
801027e8:	53                   	push   %ebx
801027e9:	e8 d2 1b 00 00       	call   801043c0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ee:	8b 03                	mov    (%ebx),%eax
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	83 e0 06             	and    $0x6,%eax
801027f6:	83 f8 02             	cmp    $0x2,%eax
801027f9:	75 e5                	jne    801027e0 <iderw+0x90>
  }


  release(&idelock);
801027fb:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
80102802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102805:	c9                   	leave  
  release(&idelock);
80102806:	e9 a5 24 00 00       	jmp    80104cb0 <release>
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102810:	89 d8                	mov    %ebx,%eax
80102812:	e8 39 fd ff ff       	call   80102550 <idestart>
80102817:	eb b5                	jmp    801027ce <iderw+0x7e>
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102820:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
80102825:	eb 9d                	jmp    801027c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102827:	83 ec 0c             	sub    $0xc,%esp
8010282a:	68 20 7b 10 80       	push   $0x80107b20
8010282f:	e8 5c db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	68 0a 7b 10 80       	push   $0x80107b0a
8010283c:	e8 4f db ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102841:	83 ec 0c             	sub    $0xc,%esp
80102844:	68 35 7b 10 80       	push   $0x80107b35
80102849:	e8 42 db ff ff       	call   80100390 <panic>
8010284e:	66 90                	xchg   %ax,%ax

80102850 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102850:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102851:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102858:	00 c0 fe 
{
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	56                   	push   %esi
8010285e:	53                   	push   %ebx
  ioapic->reg = reg;
8010285f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102866:	00 00 00 
  return ioapic->data;
80102869:	a1 54 36 11 80       	mov    0x80113654,%eax
8010286e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102877:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010287d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102884:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102887:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010288a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010288d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102890:	39 c2                	cmp    %eax,%edx
80102892:	74 16                	je     801028aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102894:	83 ec 0c             	sub    $0xc,%esp
80102897:	68 54 7b 10 80       	push   $0x80107b54
8010289c:	e8 bf dd ff ff       	call   80100660 <cprintf>
801028a1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801028a7:	83 c4 10             	add    $0x10,%esp
801028aa:	83 c3 21             	add    $0x21,%ebx
{
801028ad:	ba 10 00 00 00       	mov    $0x10,%edx
801028b2:	b8 20 00 00 00       	mov    $0x20,%eax
801028b7:	89 f6                	mov    %esi,%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801028c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801028c2:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028c8:	89 c6                	mov    %eax,%esi
801028ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801028d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801028d3:	89 71 10             	mov    %esi,0x10(%ecx)
801028d6:	8d 72 01             	lea    0x1(%edx),%esi
801028d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801028dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801028de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801028e0:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801028e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801028ed:	75 d1                	jne    801028c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801028ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f2:	5b                   	pop    %ebx
801028f3:	5e                   	pop    %esi
801028f4:	5d                   	pop    %ebp
801028f5:	c3                   	ret    
801028f6:	8d 76 00             	lea    0x0(%esi),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102900:	55                   	push   %ebp
  ioapic->reg = reg;
80102901:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
80102907:	89 e5                	mov    %esp,%ebp
80102909:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010290c:	8d 50 20             	lea    0x20(%eax),%edx
8010290f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102913:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102915:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010291b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010291e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102921:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102924:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102926:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010292b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010292e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102931:	5d                   	pop    %ebp
80102932:	c3                   	ret    
80102933:	66 90                	xchg   %ax,%ax
80102935:	66 90                	xchg   %ax,%ax
80102937:	66 90                	xchg   %ax,%ax
80102939:	66 90                	xchg   %ax,%ax
8010293b:	66 90                	xchg   %ax,%ax
8010293d:	66 90                	xchg   %ax,%ax
8010293f:	90                   	nop

80102940 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	53                   	push   %ebx
80102944:	83 ec 04             	sub    $0x4,%esp
80102947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010294a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102950:	75 70                	jne    801029c2 <kfree+0x82>
80102952:	81 fb c8 65 11 80    	cmp    $0x801165c8,%ebx
80102958:	72 68                	jb     801029c2 <kfree+0x82>
8010295a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102960:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102965:	77 5b                	ja     801029c2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102967:	83 ec 04             	sub    $0x4,%esp
8010296a:	68 00 10 00 00       	push   $0x1000
8010296f:	6a 01                	push   $0x1
80102971:	53                   	push   %ebx
80102972:	e8 89 23 00 00       	call   80104d00 <memset>

  if(kmem.use_lock)
80102977:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010297d:	83 c4 10             	add    $0x10,%esp
80102980:	85 d2                	test   %edx,%edx
80102982:	75 2c                	jne    801029b0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102984:	a1 98 36 11 80       	mov    0x80113698,%eax
80102989:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010298b:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102990:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102996:	85 c0                	test   %eax,%eax
80102998:	75 06                	jne    801029a0 <kfree+0x60>
    release(&kmem.lock);
}
8010299a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010299d:	c9                   	leave  
8010299e:	c3                   	ret    
8010299f:	90                   	nop
    release(&kmem.lock);
801029a0:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
801029a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029aa:	c9                   	leave  
    release(&kmem.lock);
801029ab:	e9 00 23 00 00       	jmp    80104cb0 <release>
    acquire(&kmem.lock);
801029b0:	83 ec 0c             	sub    $0xc,%esp
801029b3:	68 60 36 11 80       	push   $0x80113660
801029b8:	e8 33 22 00 00       	call   80104bf0 <acquire>
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	eb c2                	jmp    80102984 <kfree+0x44>
    panic("kfree");
801029c2:	83 ec 0c             	sub    $0xc,%esp
801029c5:	68 86 7b 10 80       	push   $0x80107b86
801029ca:	e8 c1 d9 ff ff       	call   80100390 <panic>
801029cf:	90                   	nop

801029d0 <freerange>:
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	56                   	push   %esi
801029d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801029db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029ed:	39 de                	cmp    %ebx,%esi
801029ef:	72 23                	jb     80102a14 <freerange+0x44>
801029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801029f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801029fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a07:	50                   	push   %eax
80102a08:	e8 33 ff ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	39 f3                	cmp    %esi,%ebx
80102a12:	76 e4                	jbe    801029f8 <freerange+0x28>
}
80102a14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a17:	5b                   	pop    %ebx
80102a18:	5e                   	pop    %esi
80102a19:	5d                   	pop    %ebp
80102a1a:	c3                   	ret    
80102a1b:	90                   	nop
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a20 <kinit1>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
80102a24:	53                   	push   %ebx
80102a25:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a28:	83 ec 08             	sub    $0x8,%esp
80102a2b:	68 8c 7b 10 80       	push   $0x80107b8c
80102a30:	68 60 36 11 80       	push   $0x80113660
80102a35:	e8 76 20 00 00       	call   80104ab0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a3d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a40:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102a47:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a4a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a50:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a5c:	39 de                	cmp    %ebx,%esi
80102a5e:	72 1c                	jb     80102a7c <kinit1+0x5c>
    kfree(p);
80102a60:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102a66:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a6f:	50                   	push   %eax
80102a70:	e8 cb fe ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a75:	83 c4 10             	add    $0x10,%esp
80102a78:	39 de                	cmp    %ebx,%esi
80102a7a:	73 e4                	jae    80102a60 <kinit1+0x40>
}
80102a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a7f:	5b                   	pop    %ebx
80102a80:	5e                   	pop    %esi
80102a81:	5d                   	pop    %ebp
80102a82:	c3                   	ret    
80102a83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a90 <kinit2>:
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	56                   	push   %esi
80102a94:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a95:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a98:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a9b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102aa1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aad:	39 de                	cmp    %ebx,%esi
80102aaf:	72 23                	jb     80102ad4 <kinit2+0x44>
80102ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102ab8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102abe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ac7:	50                   	push   %eax
80102ac8:	e8 73 fe ff ff       	call   80102940 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acd:	83 c4 10             	add    $0x10,%esp
80102ad0:	39 de                	cmp    %ebx,%esi
80102ad2:	73 e4                	jae    80102ab8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ad4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102adb:	00 00 00 
}
80102ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ae1:	5b                   	pop    %ebx
80102ae2:	5e                   	pop    %esi
80102ae3:	5d                   	pop    %ebp
80102ae4:	c3                   	ret    
80102ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102af0:	a1 94 36 11 80       	mov    0x80113694,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	75 1f                	jne    80102b18 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102af9:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102afe:	85 c0                	test   %eax,%eax
80102b00:	74 0e                	je     80102b10 <kalloc+0x20>
    kmem.freelist = r->next;
80102b02:	8b 10                	mov    (%eax),%edx
80102b04:	89 15 98 36 11 80    	mov    %edx,0x80113698
80102b0a:	c3                   	ret    
80102b0b:	90                   	nop
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102b10:	f3 c3                	repz ret 
80102b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102b18:	55                   	push   %ebp
80102b19:	89 e5                	mov    %esp,%ebp
80102b1b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b1e:	68 60 36 11 80       	push   $0x80113660
80102b23:	e8 c8 20 00 00       	call   80104bf0 <acquire>
  r = kmem.freelist;
80102b28:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102b2d:	83 c4 10             	add    $0x10,%esp
80102b30:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102b36:	85 c0                	test   %eax,%eax
80102b38:	74 08                	je     80102b42 <kalloc+0x52>
    kmem.freelist = r->next;
80102b3a:	8b 08                	mov    (%eax),%ecx
80102b3c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102b42:	85 d2                	test   %edx,%edx
80102b44:	74 16                	je     80102b5c <kalloc+0x6c>
    release(&kmem.lock);
80102b46:	83 ec 0c             	sub    $0xc,%esp
80102b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b4c:	68 60 36 11 80       	push   $0x80113660
80102b51:	e8 5a 21 00 00       	call   80104cb0 <release>
  return (char*)r;
80102b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b59:	83 c4 10             	add    $0x10,%esp
}
80102b5c:	c9                   	leave  
80102b5d:	c3                   	ret    
80102b5e:	66 90                	xchg   %ax,%ax

80102b60 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b60:	ba 64 00 00 00       	mov    $0x64,%edx
80102b65:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b66:	a8 01                	test   $0x1,%al
80102b68:	0f 84 c2 00 00 00    	je     80102c30 <kbdgetc+0xd0>
80102b6e:	ba 60 00 00 00       	mov    $0x60,%edx
80102b73:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102b74:	0f b6 d0             	movzbl %al,%edx
80102b77:	8b 0d d4 b5 10 80    	mov    0x8010b5d4,%ecx

  if(data == 0xE0){
80102b7d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102b83:	0f 84 7f 00 00 00    	je     80102c08 <kbdgetc+0xa8>
{
80102b89:	55                   	push   %ebp
80102b8a:	89 e5                	mov    %esp,%ebp
80102b8c:	53                   	push   %ebx
80102b8d:	89 cb                	mov    %ecx,%ebx
80102b8f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b92:	84 c0                	test   %al,%al
80102b94:	78 4a                	js     80102be0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102b96:	85 db                	test   %ebx,%ebx
80102b98:	74 09                	je     80102ba3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102b9a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102b9d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102ba0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102ba3:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
80102baa:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102bac:	0f b6 82 c0 7b 10 80 	movzbl -0x7fef8440(%edx),%eax
80102bb3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bb5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bb7:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bbd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bc0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bc3:	8b 04 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%eax
80102bca:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bce:	74 31                	je     80102c01 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102bd0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bd3:	83 fa 19             	cmp    $0x19,%edx
80102bd6:	77 40                	ja     80102c18 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102bd8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bdb:	5b                   	pop    %ebx
80102bdc:	5d                   	pop    %ebp
80102bdd:	c3                   	ret    
80102bde:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102be0:	83 e0 7f             	and    $0x7f,%eax
80102be3:	85 db                	test   %ebx,%ebx
80102be5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102be8:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
80102bef:	83 c8 40             	or     $0x40,%eax
80102bf2:	0f b6 c0             	movzbl %al,%eax
80102bf5:	f7 d0                	not    %eax
80102bf7:	21 c1                	and    %eax,%ecx
    return 0;
80102bf9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102bfb:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
80102c01:	5b                   	pop    %ebx
80102c02:	5d                   	pop    %ebp
80102c03:	c3                   	ret    
80102c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102c08:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102c0b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c0d:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
    return 0;
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c18:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c1b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c1e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102c1f:	83 f9 1a             	cmp    $0x1a,%ecx
80102c22:	0f 42 c2             	cmovb  %edx,%eax
}
80102c25:	5d                   	pop    %ebp
80102c26:	c3                   	ret    
80102c27:	89 f6                	mov    %esi,%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <kbdintr>:

void
kbdintr(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c46:	68 60 2b 10 80       	push   $0x80102b60
80102c4b:	e8 30 dd ff ff       	call   80100980 <consoleintr>
}
80102c50:	83 c4 10             	add    $0x10,%esp
80102c53:	c9                   	leave  
80102c54:	c3                   	ret    
80102c55:	66 90                	xchg   %ax,%ax
80102c57:	66 90                	xchg   %ax,%ax
80102c59:	66 90                	xchg   %ax,%ax
80102c5b:	66 90                	xchg   %ax,%ax
80102c5d:	66 90                	xchg   %ax,%ax
80102c5f:	90                   	nop

80102c60 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102c60:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102c65:	55                   	push   %ebp
80102c66:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102c68:	85 c0                	test   %eax,%eax
80102c6a:	0f 84 c8 00 00 00    	je     80102d38 <lapicinit+0xd8>
  lapic[index] = value;
80102c70:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c77:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c7d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c8a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102c91:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102c94:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c97:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102c9e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cb8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cbb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cbe:	8b 50 30             	mov    0x30(%eax),%edx
80102cc1:	c1 ea 10             	shr    $0x10,%edx
80102cc4:	80 fa 03             	cmp    $0x3,%dl
80102cc7:	77 77                	ja     80102d40 <lapicinit+0xe0>
  lapic[index] = value;
80102cc9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102cd0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cdd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ced:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cf7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cfd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d11:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d14:	8b 50 20             	mov    0x20(%eax),%edx
80102d17:	89 f6                	mov    %esi,%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d20:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d26:	80 e6 10             	and    $0x10,%dh
80102d29:	75 f5                	jne    80102d20 <lapicinit+0xc0>
  lapic[index] = value;
80102d2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d32:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d35:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d38:	5d                   	pop    %ebp
80102d39:	c3                   	ret    
80102d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102d40:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d47:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4a:	8b 50 20             	mov    0x20(%eax),%edx
80102d4d:	e9 77 ff ff ff       	jmp    80102cc9 <lapicinit+0x69>
80102d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d60 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102d60:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
80102d66:	55                   	push   %ebp
80102d67:	31 c0                	xor    %eax,%eax
80102d69:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102d6b:	85 d2                	test   %edx,%edx
80102d6d:	74 06                	je     80102d75 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102d6f:	8b 42 20             	mov    0x20(%edx),%eax
80102d72:	c1 e8 18             	shr    $0x18,%eax
}
80102d75:	5d                   	pop    %ebp
80102d76:	c3                   	ret    
80102d77:	89 f6                	mov    %esi,%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d80 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102d80:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102d85:	55                   	push   %ebp
80102d86:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102d88:	85 c0                	test   %eax,%eax
80102d8a:	74 0d                	je     80102d99 <lapiceoi+0x19>
  lapic[index] = value;
80102d8c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d93:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d96:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102d99:	5d                   	pop    %ebp
80102d9a:	c3                   	ret    
80102d9b:	90                   	nop
80102d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102da0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
}
80102da3:	5d                   	pop    %ebp
80102da4:	c3                   	ret    
80102da5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102db0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102db0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102db6:	ba 70 00 00 00       	mov    $0x70,%edx
80102dbb:	89 e5                	mov    %esp,%ebp
80102dbd:	53                   	push   %ebx
80102dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102dc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dc4:	ee                   	out    %al,(%dx)
80102dc5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dca:	ba 71 00 00 00       	mov    $0x71,%edx
80102dcf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102dd0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102dd2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102dd5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102ddb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ddd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102de0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102de3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102de5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102de8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102dee:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102df3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102df9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dfc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e3a:	5b                   	pop    %ebx
80102e3b:	5d                   	pop    %ebp
80102e3c:	c3                   	ret    
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e40:	55                   	push   %ebp
80102e41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e46:	ba 70 00 00 00       	mov    $0x70,%edx
80102e4b:	89 e5                	mov    %esp,%ebp
80102e4d:	57                   	push   %edi
80102e4e:	56                   	push   %esi
80102e4f:	53                   	push   %ebx
80102e50:	83 ec 4c             	sub    $0x4c,%esp
80102e53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e54:	ba 71 00 00 00       	mov    $0x71,%edx
80102e59:	ec                   	in     (%dx),%al
80102e5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e5d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e65:	8d 76 00             	lea    0x0(%esi),%esi
80102e68:	31 c0                	xor    %eax,%eax
80102e6a:	89 da                	mov    %ebx,%edx
80102e6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e72:	89 ca                	mov    %ecx,%edx
80102e74:	ec                   	in     (%dx),%al
80102e75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e78:	89 da                	mov    %ebx,%edx
80102e7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102e7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e80:	89 ca                	mov    %ecx,%edx
80102e82:	ec                   	in     (%dx),%al
80102e83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e86:	89 da                	mov    %ebx,%edx
80102e88:	b8 04 00 00 00       	mov    $0x4,%eax
80102e8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e8e:	89 ca                	mov    %ecx,%edx
80102e90:	ec                   	in     (%dx),%al
80102e91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e94:	89 da                	mov    %ebx,%edx
80102e96:	b8 07 00 00 00       	mov    $0x7,%eax
80102e9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9c:	89 ca                	mov    %ecx,%edx
80102e9e:	ec                   	in     (%dx),%al
80102e9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea2:	89 da                	mov    %ebx,%edx
80102ea4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ea9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eaa:	89 ca                	mov    %ecx,%edx
80102eac:	ec                   	in     (%dx),%al
80102ead:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eaf:	89 da                	mov    %ebx,%edx
80102eb1:	b8 09 00 00 00       	mov    $0x9,%eax
80102eb6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb7:	89 ca                	mov    %ecx,%edx
80102eb9:	ec                   	in     (%dx),%al
80102eba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebc:	89 da                	mov    %ebx,%edx
80102ebe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ec3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec4:	89 ca                	mov    %ecx,%edx
80102ec6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ec7:	84 c0                	test   %al,%al
80102ec9:	78 9d                	js     80102e68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102ecb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ecf:	89 fa                	mov    %edi,%edx
80102ed1:	0f b6 fa             	movzbl %dl,%edi
80102ed4:	89 f2                	mov    %esi,%edx
80102ed6:	0f b6 f2             	movzbl %dl,%esi
80102ed9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102edc:	89 da                	mov    %ebx,%edx
80102ede:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ee1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ee4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ee8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102eeb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102eef:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ef2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ef6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ef9:	31 c0                	xor    %eax,%eax
80102efb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efc:	89 ca                	mov    %ecx,%edx
80102efe:	ec                   	in     (%dx),%al
80102eff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f02:	89 da                	mov    %ebx,%edx
80102f04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f07:	b8 02 00 00 00       	mov    $0x2,%eax
80102f0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f0d:	89 ca                	mov    %ecx,%edx
80102f0f:	ec                   	in     (%dx),%al
80102f10:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f13:	89 da                	mov    %ebx,%edx
80102f15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f18:	b8 04 00 00 00       	mov    $0x4,%eax
80102f1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f1e:	89 ca                	mov    %ecx,%edx
80102f20:	ec                   	in     (%dx),%al
80102f21:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f24:	89 da                	mov    %ebx,%edx
80102f26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f29:	b8 07 00 00 00       	mov    $0x7,%eax
80102f2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2f:	89 ca                	mov    %ecx,%edx
80102f31:	ec                   	in     (%dx),%al
80102f32:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f35:	89 da                	mov    %ebx,%edx
80102f37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f40:	89 ca                	mov    %ecx,%edx
80102f42:	ec                   	in     (%dx),%al
80102f43:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f46:	89 da                	mov    %ebx,%edx
80102f48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102f50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f51:	89 ca                	mov    %ecx,%edx
80102f53:	ec                   	in     (%dx),%al
80102f54:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f57:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f60:	6a 18                	push   $0x18
80102f62:	50                   	push   %eax
80102f63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f66:	50                   	push   %eax
80102f67:	e8 e4 1d 00 00       	call   80104d50 <memcmp>
80102f6c:	83 c4 10             	add    $0x10,%esp
80102f6f:	85 c0                	test   %eax,%eax
80102f71:	0f 85 f1 fe ff ff    	jne    80102e68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102f77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f7b:	75 78                	jne    80102ff5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f80:	89 c2                	mov    %eax,%edx
80102f82:	83 e0 0f             	and    $0xf,%eax
80102f85:	c1 ea 04             	shr    $0x4,%edx
80102f88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102f91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f94:	89 c2                	mov    %eax,%edx
80102f96:	83 e0 0f             	and    $0xf,%eax
80102f99:	c1 ea 04             	shr    $0x4,%edx
80102f9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fa2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fa5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fa8:	89 c2                	mov    %eax,%edx
80102faa:	83 e0 0f             	and    $0xf,%eax
80102fad:	c1 ea 04             	shr    $0x4,%edx
80102fb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fbc:	89 c2                	mov    %eax,%edx
80102fbe:	83 e0 0f             	and    $0xf,%eax
80102fc1:	c1 ea 04             	shr    $0x4,%edx
80102fc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102fcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fd0:	89 c2                	mov    %eax,%edx
80102fd2:	83 e0 0f             	and    $0xf,%eax
80102fd5:	c1 ea 04             	shr    $0x4,%edx
80102fd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fde:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102fe1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fe4:	89 c2                	mov    %eax,%edx
80102fe6:	83 e0 0f             	and    $0xf,%eax
80102fe9:	c1 ea 04             	shr    $0x4,%edx
80102fec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ff5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ff8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ffb:	89 06                	mov    %eax,(%esi)
80102ffd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103000:	89 46 04             	mov    %eax,0x4(%esi)
80103003:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103006:	89 46 08             	mov    %eax,0x8(%esi)
80103009:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010300c:	89 46 0c             	mov    %eax,0xc(%esi)
8010300f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103012:	89 46 10             	mov    %eax,0x10(%esi)
80103015:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103018:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010301b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103022:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103025:	5b                   	pop    %ebx
80103026:	5e                   	pop    %esi
80103027:	5f                   	pop    %edi
80103028:	5d                   	pop    %ebp
80103029:	c3                   	ret    
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103030:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103036:	85 c9                	test   %ecx,%ecx
80103038:	0f 8e 8a 00 00 00    	jle    801030c8 <install_trans+0x98>
{
8010303e:	55                   	push   %ebp
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	57                   	push   %edi
80103042:	56                   	push   %esi
80103043:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103044:	31 db                	xor    %ebx,%ebx
{
80103046:	83 ec 0c             	sub    $0xc,%esp
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103050:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103055:	83 ec 08             	sub    $0x8,%esp
80103058:	01 d8                	add    %ebx,%eax
8010305a:	83 c0 01             	add    $0x1,%eax
8010305d:	50                   	push   %eax
8010305e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80103064:	e8 67 d0 ff ff       	call   801000d0 <bread>
80103069:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010306b:	58                   	pop    %eax
8010306c:	5a                   	pop    %edx
8010306d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80103074:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010307a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010307d:	e8 4e d0 ff ff       	call   801000d0 <bread>
80103082:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103084:	8d 47 5c             	lea    0x5c(%edi),%eax
80103087:	83 c4 0c             	add    $0xc,%esp
8010308a:	68 00 02 00 00       	push   $0x200
8010308f:	50                   	push   %eax
80103090:	8d 46 5c             	lea    0x5c(%esi),%eax
80103093:	50                   	push   %eax
80103094:	e8 17 1d 00 00       	call   80104db0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103099:	89 34 24             	mov    %esi,(%esp)
8010309c:	e8 ff d0 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801030a1:	89 3c 24             	mov    %edi,(%esp)
801030a4:	e8 37 d1 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 2f d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
801030ba:	7f 94                	jg     80103050 <install_trans+0x20>
  }
}
801030bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5f                   	pop    %edi
801030c2:	5d                   	pop    %ebp
801030c3:	c3                   	ret    
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030c8:	f3 c3                	repz ret 
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	56                   	push   %esi
801030d4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801030d5:	83 ec 08             	sub    $0x8,%esp
801030d8:	ff 35 d4 36 11 80    	pushl  0x801136d4
801030de:	ff 35 e4 36 11 80    	pushl  0x801136e4
801030e4:	e8 e7 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801030e9:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
801030ef:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801030f2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
801030f4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
801030f6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801030f9:	7e 16                	jle    80103111 <write_head+0x41>
801030fb:	c1 e3 02             	shl    $0x2,%ebx
801030fe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103100:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80103106:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010310a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010310d:	39 da                	cmp    %ebx,%edx
8010310f:	75 ef                	jne    80103100 <write_head+0x30>
  }
  bwrite(buf);
80103111:	83 ec 0c             	sub    $0xc,%esp
80103114:	56                   	push   %esi
80103115:	e8 86 d0 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010311a:	89 34 24             	mov    %esi,(%esp)
8010311d:	e8 be d0 ff ff       	call   801001e0 <brelse>
}
80103122:	83 c4 10             	add    $0x10,%esp
80103125:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103128:	5b                   	pop    %ebx
80103129:	5e                   	pop    %esi
8010312a:	5d                   	pop    %ebp
8010312b:	c3                   	ret    
8010312c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103130 <initlog>:
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	53                   	push   %ebx
80103134:	83 ec 2c             	sub    $0x2c,%esp
80103137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010313a:	68 c0 7d 10 80       	push   $0x80107dc0
8010313f:	68 a0 36 11 80       	push   $0x801136a0
80103144:	e8 67 19 00 00       	call   80104ab0 <initlock>
  readsb(dev, &sb);
80103149:	58                   	pop    %eax
8010314a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010314d:	5a                   	pop    %edx
8010314e:	50                   	push   %eax
8010314f:	53                   	push   %ebx
80103150:	e8 1b e9 ff ff       	call   80101a70 <readsb>
  log.size = sb.nlog;
80103155:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010315b:	59                   	pop    %ecx
  log.dev = dev;
8010315c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80103162:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80103168:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
8010316d:	5a                   	pop    %edx
8010316e:	50                   	push   %eax
8010316f:	53                   	push   %ebx
80103170:	e8 5b cf ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103175:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103178:	83 c4 10             	add    $0x10,%esp
8010317b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010317d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80103183:	7e 1c                	jle    801031a1 <initlog+0x71>
80103185:	c1 e3 02             	shl    $0x2,%ebx
80103188:	31 d2                	xor    %edx,%edx
8010318a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103190:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103194:	83 c2 04             	add    $0x4,%edx
80103197:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010319d:	39 d3                	cmp    %edx,%ebx
8010319f:	75 ef                	jne    80103190 <initlog+0x60>
  brelse(buf);
801031a1:	83 ec 0c             	sub    $0xc,%esp
801031a4:	50                   	push   %eax
801031a5:	e8 36 d0 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031aa:	e8 81 fe ff ff       	call   80103030 <install_trans>
  log.lh.n = 0;
801031af:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
801031b6:	00 00 00 
  write_head(); // clear the log
801031b9:	e8 12 ff ff ff       	call   801030d0 <write_head>
}
801031be:	83 c4 10             	add    $0x10,%esp
801031c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031c4:	c9                   	leave  
801031c5:	c3                   	ret    
801031c6:	8d 76 00             	lea    0x0(%esi),%esi
801031c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031d6:	68 a0 36 11 80       	push   $0x801136a0
801031db:	e8 10 1a 00 00       	call   80104bf0 <acquire>
801031e0:	83 c4 10             	add    $0x10,%esp
801031e3:	eb 18                	jmp    801031fd <begin_op+0x2d>
801031e5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801031e8:	83 ec 08             	sub    $0x8,%esp
801031eb:	68 a0 36 11 80       	push   $0x801136a0
801031f0:	68 a0 36 11 80       	push   $0x801136a0
801031f5:	e8 c6 11 00 00       	call   801043c0 <sleep>
801031fa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801031fd:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80103202:	85 c0                	test   %eax,%eax
80103204:	75 e2                	jne    801031e8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103206:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010320b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80103211:	83 c0 01             	add    $0x1,%eax
80103214:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103217:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010321a:	83 fa 1e             	cmp    $0x1e,%edx
8010321d:	7f c9                	jg     801031e8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010321f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103222:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80103227:	68 a0 36 11 80       	push   $0x801136a0
8010322c:	e8 7f 1a 00 00       	call   80104cb0 <release>
      break;
    }
  }
}
80103231:	83 c4 10             	add    $0x10,%esp
80103234:	c9                   	leave  
80103235:	c3                   	ret    
80103236:	8d 76 00             	lea    0x0(%esi),%esi
80103239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103240 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103249:	68 a0 36 11 80       	push   $0x801136a0
8010324e:	e8 9d 19 00 00       	call   80104bf0 <acquire>
  log.outstanding -= 1;
80103253:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80103258:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
8010325e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103261:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103264:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103266:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
8010326c:	0f 85 1a 01 00 00    	jne    8010338c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103272:	85 db                	test   %ebx,%ebx
80103274:	0f 85 ee 00 00 00    	jne    80103368 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010327a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010327d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80103284:	00 00 00 
  release(&log.lock);
80103287:	68 a0 36 11 80       	push   $0x801136a0
8010328c:	e8 1f 1a 00 00       	call   80104cb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103291:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103297:	83 c4 10             	add    $0x10,%esp
8010329a:	85 c9                	test   %ecx,%ecx
8010329c:	0f 8e 85 00 00 00    	jle    80103327 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801032a2:	a1 d4 36 11 80       	mov    0x801136d4,%eax
801032a7:	83 ec 08             	sub    $0x8,%esp
801032aa:	01 d8                	add    %ebx,%eax
801032ac:	83 c0 01             	add    $0x1,%eax
801032af:	50                   	push   %eax
801032b0:	ff 35 e4 36 11 80    	pushl  0x801136e4
801032b6:	e8 15 ce ff ff       	call   801000d0 <bread>
801032bb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032bd:	58                   	pop    %eax
801032be:	5a                   	pop    %edx
801032bf:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
801032c6:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
801032cc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032cf:	e8 fc cd ff ff       	call   801000d0 <bread>
801032d4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801032d6:	8d 40 5c             	lea    0x5c(%eax),%eax
801032d9:	83 c4 0c             	add    $0xc,%esp
801032dc:	68 00 02 00 00       	push   $0x200
801032e1:	50                   	push   %eax
801032e2:	8d 46 5c             	lea    0x5c(%esi),%eax
801032e5:	50                   	push   %eax
801032e6:	e8 c5 1a 00 00       	call   80104db0 <memmove>
    bwrite(to);  // write the log
801032eb:	89 34 24             	mov    %esi,(%esp)
801032ee:	e8 ad ce ff ff       	call   801001a0 <bwrite>
    brelse(from);
801032f3:	89 3c 24             	mov    %edi,(%esp)
801032f6:	e8 e5 ce ff ff       	call   801001e0 <brelse>
    brelse(to);
801032fb:	89 34 24             	mov    %esi,(%esp)
801032fe:	e8 dd ce ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103303:	83 c4 10             	add    $0x10,%esp
80103306:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
8010330c:	7c 94                	jl     801032a2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010330e:	e8 bd fd ff ff       	call   801030d0 <write_head>
    install_trans(); // Now install writes to home locations
80103313:	e8 18 fd ff ff       	call   80103030 <install_trans>
    log.lh.n = 0;
80103318:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
8010331f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103322:	e8 a9 fd ff ff       	call   801030d0 <write_head>
    acquire(&log.lock);
80103327:	83 ec 0c             	sub    $0xc,%esp
8010332a:	68 a0 36 11 80       	push   $0x801136a0
8010332f:	e8 bc 18 00 00       	call   80104bf0 <acquire>
    wakeup(&log);
80103334:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
8010333b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80103342:	00 00 00 
    wakeup(&log);
80103345:	e8 36 12 00 00       	call   80104580 <wakeup>
    release(&log.lock);
8010334a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103351:	e8 5a 19 00 00       	call   80104cb0 <release>
80103356:	83 c4 10             	add    $0x10,%esp
}
80103359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335c:	5b                   	pop    %ebx
8010335d:	5e                   	pop    %esi
8010335e:	5f                   	pop    %edi
8010335f:	5d                   	pop    %ebp
80103360:	c3                   	ret    
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103368:	83 ec 0c             	sub    $0xc,%esp
8010336b:	68 a0 36 11 80       	push   $0x801136a0
80103370:	e8 0b 12 00 00       	call   80104580 <wakeup>
  release(&log.lock);
80103375:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
8010337c:	e8 2f 19 00 00       	call   80104cb0 <release>
80103381:	83 c4 10             	add    $0x10,%esp
}
80103384:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103387:	5b                   	pop    %ebx
80103388:	5e                   	pop    %esi
80103389:	5f                   	pop    %edi
8010338a:	5d                   	pop    %ebp
8010338b:	c3                   	ret    
    panic("log.committing");
8010338c:	83 ec 0c             	sub    $0xc,%esp
8010338f:	68 c4 7d 10 80       	push   $0x80107dc4
80103394:	e8 f7 cf ff ff       	call   80100390 <panic>
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	53                   	push   %ebx
801033a4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033a7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
801033ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033b0:	83 fa 1d             	cmp    $0x1d,%edx
801033b3:	0f 8f 9d 00 00 00    	jg     80103456 <log_write+0xb6>
801033b9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
801033be:	83 e8 01             	sub    $0x1,%eax
801033c1:	39 c2                	cmp    %eax,%edx
801033c3:	0f 8d 8d 00 00 00    	jge    80103456 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801033c9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801033ce:	85 c0                	test   %eax,%eax
801033d0:	0f 8e 8d 00 00 00    	jle    80103463 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801033d6:	83 ec 0c             	sub    $0xc,%esp
801033d9:	68 a0 36 11 80       	push   $0x801136a0
801033de:	e8 0d 18 00 00       	call   80104bf0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801033e3:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	83 f9 00             	cmp    $0x0,%ecx
801033ef:	7e 57                	jle    80103448 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801033f1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801033f4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801033f6:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
801033fc:	75 0b                	jne    80103409 <log_write+0x69>
801033fe:	eb 38                	jmp    80103438 <log_write+0x98>
80103400:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80103407:	74 2f                	je     80103438 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103409:	83 c0 01             	add    $0x1,%eax
8010340c:	39 c1                	cmp    %eax,%ecx
8010340e:	75 f0                	jne    80103400 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103410:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103417:	83 c0 01             	add    $0x1,%eax
8010341a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
8010341f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103422:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80103429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010342c:	c9                   	leave  
  release(&log.lock);
8010342d:	e9 7e 18 00 00       	jmp    80104cb0 <release>
80103432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103438:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
8010343f:	eb de                	jmp    8010341f <log_write+0x7f>
80103441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103448:	8b 43 08             	mov    0x8(%ebx),%eax
8010344b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80103450:	75 cd                	jne    8010341f <log_write+0x7f>
80103452:	31 c0                	xor    %eax,%eax
80103454:	eb c1                	jmp    80103417 <log_write+0x77>
    panic("too big a transaction");
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	68 d3 7d 10 80       	push   $0x80107dd3
8010345e:	e8 2d cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103463:	83 ec 0c             	sub    $0xc,%esp
80103466:	68 e9 7d 10 80       	push   $0x80107de9
8010346b:	e8 20 cf ff ff       	call   80100390 <panic>

80103470 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	53                   	push   %ebx
80103474:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103477:	e8 84 09 00 00       	call   80103e00 <cpuid>
8010347c:	89 c3                	mov    %eax,%ebx
8010347e:	e8 7d 09 00 00       	call   80103e00 <cpuid>
80103483:	83 ec 04             	sub    $0x4,%esp
80103486:	53                   	push   %ebx
80103487:	50                   	push   %eax
80103488:	68 04 7e 10 80       	push   $0x80107e04
8010348d:	e8 ce d1 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103492:	e8 99 2c 00 00       	call   80106130 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103497:	e8 e4 08 00 00       	call   80103d80 <mycpu>
8010349c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010349e:	b8 01 00 00 00       	mov    $0x1,%eax
801034a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034aa:	e8 31 0c 00 00       	call   801040e0 <scheduler>
801034af:	90                   	nop

801034b0 <mpenter>:
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034b6:	e8 65 3d 00 00       	call   80107220 <switchkvm>
  seginit();
801034bb:	e8 d0 3c 00 00       	call   80107190 <seginit>
  lapicinit();
801034c0:	e8 9b f7 ff ff       	call   80102c60 <lapicinit>
  mpmain();
801034c5:	e8 a6 ff ff ff       	call   80103470 <mpmain>
801034ca:	66 90                	xchg   %ax,%ax
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <main>:
{
801034d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034d4:	83 e4 f0             	and    $0xfffffff0,%esp
801034d7:	ff 71 fc             	pushl  -0x4(%ecx)
801034da:	55                   	push   %ebp
801034db:	89 e5                	mov    %esp,%ebp
801034dd:	53                   	push   %ebx
801034de:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034df:	83 ec 08             	sub    $0x8,%esp
801034e2:	68 00 00 40 80       	push   $0x80400000
801034e7:	68 c8 65 11 80       	push   $0x801165c8
801034ec:	e8 2f f5 ff ff       	call   80102a20 <kinit1>
  kvmalloc();      // kernel page table
801034f1:	e8 fa 41 00 00       	call   801076f0 <kvmalloc>
  mpinit();        // detect other processors
801034f6:	e8 75 01 00 00       	call   80103670 <mpinit>
  lapicinit();     // interrupt controller
801034fb:	e8 60 f7 ff ff       	call   80102c60 <lapicinit>
  seginit();       // segment descriptors
80103500:	e8 8b 3c 00 00       	call   80107190 <seginit>
  picinit();       // disable pic
80103505:	e8 46 03 00 00       	call   80103850 <picinit>
  ioapicinit();    // another interrupt controller
8010350a:	e8 41 f3 ff ff       	call   80102850 <ioapicinit>
  consoleinit();   // console hardware
8010350f:	e8 dc da ff ff       	call   80100ff0 <consoleinit>
  uartinit();      // serial port
80103514:	e8 47 2f 00 00       	call   80106460 <uartinit>
  pinit();         // process table
80103519:	e8 42 08 00 00       	call   80103d60 <pinit>
  tvinit();        // trap vectors
8010351e:	e8 8d 2b 00 00       	call   801060b0 <tvinit>
  binit();         // buffer cache
80103523:	e8 18 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103528:	e8 63 de ff ff       	call   80101390 <fileinit>
  ideinit();       // disk 
8010352d:	e8 fe f0 ff ff       	call   80102630 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103532:	83 c4 0c             	add    $0xc,%esp
80103535:	68 8a 00 00 00       	push   $0x8a
8010353a:	68 8c b4 10 80       	push   $0x8010b48c
8010353f:	68 00 70 00 80       	push   $0x80007000
80103544:	e8 67 18 00 00       	call   80104db0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103549:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103550:	00 00 00 
80103553:	83 c4 10             	add    $0x10,%esp
80103556:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010355b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103560:	76 71                	jbe    801035d3 <main+0x103>
80103562:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80103567:	89 f6                	mov    %esi,%esi
80103569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103570:	e8 0b 08 00 00       	call   80103d80 <mycpu>
80103575:	39 d8                	cmp    %ebx,%eax
80103577:	74 41                	je     801035ba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103579:	e8 72 f5 ff ff       	call   80102af0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010357e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103583:	c7 05 f8 6f 00 80 b0 	movl   $0x801034b0,0x80006ff8
8010358a:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010358d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103594:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103597:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010359c:	0f b6 03             	movzbl (%ebx),%eax
8010359f:	83 ec 08             	sub    $0x8,%esp
801035a2:	68 00 70 00 00       	push   $0x7000
801035a7:	50                   	push   %eax
801035a8:	e8 03 f8 ff ff       	call   80102db0 <lapicstartap>
801035ad:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801035b6:	85 c0                	test   %eax,%eax
801035b8:	74 f6                	je     801035b0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801035ba:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801035c1:	00 00 00 
801035c4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035ca:	05 a0 37 11 80       	add    $0x801137a0,%eax
801035cf:	39 c3                	cmp    %eax,%ebx
801035d1:	72 9d                	jb     80103570 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035d3:	83 ec 08             	sub    $0x8,%esp
801035d6:	68 00 00 00 8e       	push   $0x8e000000
801035db:	68 00 00 40 80       	push   $0x80400000
801035e0:	e8 ab f4 ff ff       	call   80102a90 <kinit2>
  userinit();      // first user process
801035e5:	e8 66 08 00 00       	call   80103e50 <userinit>
  mpmain();        // finish this processor's setup
801035ea:	e8 81 fe ff ff       	call   80103470 <mpmain>
801035ef:	90                   	nop

801035f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801035f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801035fb:	53                   	push   %ebx
  e = addr+len;
801035fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801035ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103602:	39 de                	cmp    %ebx,%esi
80103604:	72 10                	jb     80103616 <mpsearch1+0x26>
80103606:	eb 50                	jmp    80103658 <mpsearch1+0x68>
80103608:	90                   	nop
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103610:	39 fb                	cmp    %edi,%ebx
80103612:	89 fe                	mov    %edi,%esi
80103614:	76 42                	jbe    80103658 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103616:	83 ec 04             	sub    $0x4,%esp
80103619:	8d 7e 10             	lea    0x10(%esi),%edi
8010361c:	6a 04                	push   $0x4
8010361e:	68 18 7e 10 80       	push   $0x80107e18
80103623:	56                   	push   %esi
80103624:	e8 27 17 00 00       	call   80104d50 <memcmp>
80103629:	83 c4 10             	add    $0x10,%esp
8010362c:	85 c0                	test   %eax,%eax
8010362e:	75 e0                	jne    80103610 <mpsearch1+0x20>
80103630:	89 f1                	mov    %esi,%ecx
80103632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103638:	0f b6 11             	movzbl (%ecx),%edx
8010363b:	83 c1 01             	add    $0x1,%ecx
8010363e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103640:	39 f9                	cmp    %edi,%ecx
80103642:	75 f4                	jne    80103638 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103644:	84 c0                	test   %al,%al
80103646:	75 c8                	jne    80103610 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103648:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364b:	89 f0                	mov    %esi,%eax
8010364d:	5b                   	pop    %ebx
8010364e:	5e                   	pop    %esi
8010364f:	5f                   	pop    %edi
80103650:	5d                   	pop    %ebp
80103651:	c3                   	ret    
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103658:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010365b:	31 f6                	xor    %esi,%esi
}
8010365d:	89 f0                	mov    %esi,%eax
8010365f:	5b                   	pop    %ebx
80103660:	5e                   	pop    %esi
80103661:	5f                   	pop    %edi
80103662:	5d                   	pop    %ebp
80103663:	c3                   	ret    
80103664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010366a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103670 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	57                   	push   %edi
80103674:	56                   	push   %esi
80103675:	53                   	push   %ebx
80103676:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103679:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103680:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103687:	c1 e0 08             	shl    $0x8,%eax
8010368a:	09 d0                	or     %edx,%eax
8010368c:	c1 e0 04             	shl    $0x4,%eax
8010368f:	85 c0                	test   %eax,%eax
80103691:	75 1b                	jne    801036ae <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103693:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010369a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036a1:	c1 e0 08             	shl    $0x8,%eax
801036a4:	09 d0                	or     %edx,%eax
801036a6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036a9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036ae:	ba 00 04 00 00       	mov    $0x400,%edx
801036b3:	e8 38 ff ff ff       	call   801035f0 <mpsearch1>
801036b8:	85 c0                	test   %eax,%eax
801036ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036bd:	0f 84 3d 01 00 00    	je     80103800 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036c6:	8b 58 04             	mov    0x4(%eax),%ebx
801036c9:	85 db                	test   %ebx,%ebx
801036cb:	0f 84 4f 01 00 00    	je     80103820 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801036d7:	83 ec 04             	sub    $0x4,%esp
801036da:	6a 04                	push   $0x4
801036dc:	68 35 7e 10 80       	push   $0x80107e35
801036e1:	56                   	push   %esi
801036e2:	e8 69 16 00 00       	call   80104d50 <memcmp>
801036e7:	83 c4 10             	add    $0x10,%esp
801036ea:	85 c0                	test   %eax,%eax
801036ec:	0f 85 2e 01 00 00    	jne    80103820 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801036f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801036f9:	3c 01                	cmp    $0x1,%al
801036fb:	0f 95 c2             	setne  %dl
801036fe:	3c 04                	cmp    $0x4,%al
80103700:	0f 95 c0             	setne  %al
80103703:	20 c2                	and    %al,%dl
80103705:	0f 85 15 01 00 00    	jne    80103820 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010370b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103712:	66 85 ff             	test   %di,%di
80103715:	74 1a                	je     80103731 <mpinit+0xc1>
80103717:	89 f0                	mov    %esi,%eax
80103719:	01 f7                	add    %esi,%edi
  sum = 0;
8010371b:	31 d2                	xor    %edx,%edx
8010371d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103720:	0f b6 08             	movzbl (%eax),%ecx
80103723:	83 c0 01             	add    $0x1,%eax
80103726:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103728:	39 c7                	cmp    %eax,%edi
8010372a:	75 f4                	jne    80103720 <mpinit+0xb0>
8010372c:	84 d2                	test   %dl,%dl
8010372e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103731:	85 f6                	test   %esi,%esi
80103733:	0f 84 e7 00 00 00    	je     80103820 <mpinit+0x1b0>
80103739:	84 d2                	test   %dl,%dl
8010373b:	0f 85 df 00 00 00    	jne    80103820 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103741:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103747:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010374c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103753:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103759:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010375e:	01 d6                	add    %edx,%esi
80103760:	39 c6                	cmp    %eax,%esi
80103762:	76 23                	jbe    80103787 <mpinit+0x117>
    switch(*p){
80103764:	0f b6 10             	movzbl (%eax),%edx
80103767:	80 fa 04             	cmp    $0x4,%dl
8010376a:	0f 87 ca 00 00 00    	ja     8010383a <mpinit+0x1ca>
80103770:	ff 24 95 5c 7e 10 80 	jmp    *-0x7fef81a4(,%edx,4)
80103777:	89 f6                	mov    %esi,%esi
80103779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103780:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103783:	39 c6                	cmp    %eax,%esi
80103785:	77 dd                	ja     80103764 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103787:	85 db                	test   %ebx,%ebx
80103789:	0f 84 9e 00 00 00    	je     8010382d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103792:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103796:	74 15                	je     801037ad <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103798:	b8 70 00 00 00       	mov    $0x70,%eax
8010379d:	ba 22 00 00 00       	mov    $0x22,%edx
801037a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037a3:	ba 23 00 00 00       	mov    $0x23,%edx
801037a8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037a9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ac:	ee                   	out    %al,(%dx)
  }
}
801037ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b0:	5b                   	pop    %ebx
801037b1:	5e                   	pop    %esi
801037b2:	5f                   	pop    %edi
801037b3:	5d                   	pop    %ebp
801037b4:	c3                   	ret    
801037b5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801037b8:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
801037be:	83 f9 07             	cmp    $0x7,%ecx
801037c1:	7f 19                	jg     801037dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801037c7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801037cd:	83 c1 01             	add    $0x1,%ecx
801037d0:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037d6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
801037dc:	83 c0 14             	add    $0x14,%eax
      continue;
801037df:	e9 7c ff ff ff       	jmp    80103760 <mpinit+0xf0>
801037e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801037e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801037ec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801037ef:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
801037f5:	e9 66 ff ff ff       	jmp    80103760 <mpinit+0xf0>
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103800:	ba 00 00 01 00       	mov    $0x10000,%edx
80103805:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010380a:	e8 e1 fd ff ff       	call   801035f0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010380f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103811:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103814:	0f 85 a9 fe ff ff    	jne    801036c3 <mpinit+0x53>
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	68 1d 7e 10 80       	push   $0x80107e1d
80103828:	e8 63 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010382d:	83 ec 0c             	sub    $0xc,%esp
80103830:	68 3c 7e 10 80       	push   $0x80107e3c
80103835:	e8 56 cb ff ff       	call   80100390 <panic>
      ismp = 0;
8010383a:	31 db                	xor    %ebx,%ebx
8010383c:	e9 26 ff ff ff       	jmp    80103767 <mpinit+0xf7>
80103841:	66 90                	xchg   %ax,%ax
80103843:	66 90                	xchg   %ax,%ax
80103845:	66 90                	xchg   %ax,%ax
80103847:	66 90                	xchg   %ax,%ax
80103849:	66 90                	xchg   %ax,%ax
8010384b:	66 90                	xchg   %ax,%ax
8010384d:	66 90                	xchg   %ax,%ax
8010384f:	90                   	nop

80103850 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103850:	55                   	push   %ebp
80103851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103856:	ba 21 00 00 00       	mov    $0x21,%edx
8010385b:	89 e5                	mov    %esp,%ebp
8010385d:	ee                   	out    %al,(%dx)
8010385e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103863:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103864:	5d                   	pop    %ebp
80103865:	c3                   	ret    
80103866:	66 90                	xchg   %ax,%ax
80103868:	66 90                	xchg   %ax,%ax
8010386a:	66 90                	xchg   %ax,%ax
8010386c:	66 90                	xchg   %ax,%ax
8010386e:	66 90                	xchg   %ax,%ax

80103870 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 0c             	sub    $0xc,%esp
80103879:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010387c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010387f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103885:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010388b:	e8 20 db ff ff       	call   801013b0 <filealloc>
80103890:	85 c0                	test   %eax,%eax
80103892:	89 03                	mov    %eax,(%ebx)
80103894:	74 22                	je     801038b8 <pipealloc+0x48>
80103896:	e8 15 db ff ff       	call   801013b0 <filealloc>
8010389b:	85 c0                	test   %eax,%eax
8010389d:	89 06                	mov    %eax,(%esi)
8010389f:	74 3f                	je     801038e0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801038a1:	e8 4a f2 ff ff       	call   80102af0 <kalloc>
801038a6:	85 c0                	test   %eax,%eax
801038a8:	89 c7                	mov    %eax,%edi
801038aa:	75 54                	jne    80103900 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801038ac:	8b 03                	mov    (%ebx),%eax
801038ae:	85 c0                	test   %eax,%eax
801038b0:	75 34                	jne    801038e6 <pipealloc+0x76>
801038b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801038b8:	8b 06                	mov    (%esi),%eax
801038ba:	85 c0                	test   %eax,%eax
801038bc:	74 0c                	je     801038ca <pipealloc+0x5a>
    fileclose(*f1);
801038be:	83 ec 0c             	sub    $0xc,%esp
801038c1:	50                   	push   %eax
801038c2:	e8 a9 db ff ff       	call   80101470 <fileclose>
801038c7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801038ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801038cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801038d2:	5b                   	pop    %ebx
801038d3:	5e                   	pop    %esi
801038d4:	5f                   	pop    %edi
801038d5:	5d                   	pop    %ebp
801038d6:	c3                   	ret    
801038d7:	89 f6                	mov    %esi,%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801038e0:	8b 03                	mov    (%ebx),%eax
801038e2:	85 c0                	test   %eax,%eax
801038e4:	74 e4                	je     801038ca <pipealloc+0x5a>
    fileclose(*f0);
801038e6:	83 ec 0c             	sub    $0xc,%esp
801038e9:	50                   	push   %eax
801038ea:	e8 81 db ff ff       	call   80101470 <fileclose>
  if(*f1)
801038ef:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801038f1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801038f4:	85 c0                	test   %eax,%eax
801038f6:	75 c6                	jne    801038be <pipealloc+0x4e>
801038f8:	eb d0                	jmp    801038ca <pipealloc+0x5a>
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103900:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103903:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010390a:	00 00 00 
  p->writeopen = 1;
8010390d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103914:	00 00 00 
  p->nwrite = 0;
80103917:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010391e:	00 00 00 
  p->nread = 0;
80103921:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103928:	00 00 00 
  initlock(&p->lock, "pipe");
8010392b:	68 70 7e 10 80       	push   $0x80107e70
80103930:	50                   	push   %eax
80103931:	e8 7a 11 00 00       	call   80104ab0 <initlock>
  (*f0)->type = FD_PIPE;
80103936:	8b 03                	mov    (%ebx),%eax
  return 0;
80103938:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010393b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103941:	8b 03                	mov    (%ebx),%eax
80103943:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103947:	8b 03                	mov    (%ebx),%eax
80103949:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010394d:	8b 03                	mov    (%ebx),%eax
8010394f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103952:	8b 06                	mov    (%esi),%eax
80103954:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010395a:	8b 06                	mov    (%esi),%eax
8010395c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103960:	8b 06                	mov    (%esi),%eax
80103962:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103966:	8b 06                	mov    (%esi),%eax
80103968:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010396b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010396e:	31 c0                	xor    %eax,%eax
}
80103970:	5b                   	pop    %ebx
80103971:	5e                   	pop    %esi
80103972:	5f                   	pop    %edi
80103973:	5d                   	pop    %ebp
80103974:	c3                   	ret    
80103975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103980 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	56                   	push   %esi
80103984:	53                   	push   %ebx
80103985:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103988:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010398b:	83 ec 0c             	sub    $0xc,%esp
8010398e:	53                   	push   %ebx
8010398f:	e8 5c 12 00 00       	call   80104bf0 <acquire>
  if(writable){
80103994:	83 c4 10             	add    $0x10,%esp
80103997:	85 f6                	test   %esi,%esi
80103999:	74 45                	je     801039e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010399b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039a1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801039a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039ab:	00 00 00 
    wakeup(&p->nread);
801039ae:	50                   	push   %eax
801039af:	e8 cc 0b 00 00       	call   80104580 <wakeup>
801039b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801039b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801039bd:	85 d2                	test   %edx,%edx
801039bf:	75 0a                	jne    801039cb <pipeclose+0x4b>
801039c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801039c7:	85 c0                	test   %eax,%eax
801039c9:	74 35                	je     80103a00 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801039cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801039ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039d1:	5b                   	pop    %ebx
801039d2:	5e                   	pop    %esi
801039d3:	5d                   	pop    %ebp
    release(&p->lock);
801039d4:	e9 d7 12 00 00       	jmp    80104cb0 <release>
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801039e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801039e6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801039e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801039f0:	00 00 00 
    wakeup(&p->nwrite);
801039f3:	50                   	push   %eax
801039f4:	e8 87 0b 00 00       	call   80104580 <wakeup>
801039f9:	83 c4 10             	add    $0x10,%esp
801039fc:	eb b9                	jmp    801039b7 <pipeclose+0x37>
801039fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	53                   	push   %ebx
80103a04:	e8 a7 12 00 00       	call   80104cb0 <release>
    kfree((char*)p);
80103a09:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a0c:	83 c4 10             	add    $0x10,%esp
}
80103a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a12:	5b                   	pop    %ebx
80103a13:	5e                   	pop    %esi
80103a14:	5d                   	pop    %ebp
    kfree((char*)p);
80103a15:	e9 26 ef ff ff       	jmp    80102940 <kfree>
80103a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a20 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 28             	sub    $0x28,%esp
80103a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a2c:	53                   	push   %ebx
80103a2d:	e8 be 11 00 00       	call   80104bf0 <acquire>
  for(i = 0; i < n; i++){
80103a32:	8b 45 10             	mov    0x10(%ebp),%eax
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	85 c0                	test   %eax,%eax
80103a3a:	0f 8e c9 00 00 00    	jle    80103b09 <pipewrite+0xe9>
80103a40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103a43:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a49:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a4f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103a52:	03 4d 10             	add    0x10(%ebp),%ecx
80103a55:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a58:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103a5e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103a64:	39 d0                	cmp    %edx,%eax
80103a66:	75 71                	jne    80103ad9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103a68:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a6e:	85 c0                	test   %eax,%eax
80103a70:	74 4e                	je     80103ac0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a72:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103a78:	eb 3a                	jmp    80103ab4 <pipewrite+0x94>
80103a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	57                   	push   %edi
80103a84:	e8 f7 0a 00 00       	call   80104580 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a89:	5a                   	pop    %edx
80103a8a:	59                   	pop    %ecx
80103a8b:	53                   	push   %ebx
80103a8c:	56                   	push   %esi
80103a8d:	e8 2e 09 00 00       	call   801043c0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a92:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103a98:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103a9e:	83 c4 10             	add    $0x10,%esp
80103aa1:	05 00 02 00 00       	add    $0x200,%eax
80103aa6:	39 c2                	cmp    %eax,%edx
80103aa8:	75 36                	jne    80103ae0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103aaa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ab0:	85 c0                	test   %eax,%eax
80103ab2:	74 0c                	je     80103ac0 <pipewrite+0xa0>
80103ab4:	e8 67 03 00 00       	call   80103e20 <myproc>
80103ab9:	8b 40 24             	mov    0x24(%eax),%eax
80103abc:	85 c0                	test   %eax,%eax
80103abe:	74 c0                	je     80103a80 <pipewrite+0x60>
        release(&p->lock);
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	53                   	push   %ebx
80103ac4:	e8 e7 11 00 00       	call   80104cb0 <release>
        return -1;
80103ac9:	83 c4 10             	add    $0x10,%esp
80103acc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad4:	5b                   	pop    %ebx
80103ad5:	5e                   	pop    %esi
80103ad6:	5f                   	pop    %edi
80103ad7:	5d                   	pop    %ebp
80103ad8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ad9:	89 c2                	mov    %eax,%edx
80103adb:	90                   	nop
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ae0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ae3:	8d 42 01             	lea    0x1(%edx),%eax
80103ae6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103aec:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103af2:	83 c6 01             	add    $0x1,%esi
80103af5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103af9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103afc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103aff:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b03:	0f 85 4f ff ff ff    	jne    80103a58 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b09:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b0f:	83 ec 0c             	sub    $0xc,%esp
80103b12:	50                   	push   %eax
80103b13:	e8 68 0a 00 00       	call   80104580 <wakeup>
  release(&p->lock);
80103b18:	89 1c 24             	mov    %ebx,(%esp)
80103b1b:	e8 90 11 00 00       	call   80104cb0 <release>
  return n;
80103b20:	83 c4 10             	add    $0x10,%esp
80103b23:	8b 45 10             	mov    0x10(%ebp),%eax
80103b26:	eb a9                	jmp    80103ad1 <pipewrite+0xb1>
80103b28:	90                   	nop
80103b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b30 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 18             	sub    $0x18,%esp
80103b39:	8b 75 08             	mov    0x8(%ebp),%esi
80103b3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b3f:	56                   	push   %esi
80103b40:	e8 ab 10 00 00       	call   80104bf0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b4e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b54:	75 6a                	jne    80103bc0 <piperead+0x90>
80103b56:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103b5c:	85 db                	test   %ebx,%ebx
80103b5e:	0f 84 c4 00 00 00    	je     80103c28 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103b64:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b6a:	eb 2d                	jmp    80103b99 <piperead+0x69>
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b70:	83 ec 08             	sub    $0x8,%esp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	e8 46 08 00 00       	call   801043c0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b7a:	83 c4 10             	add    $0x10,%esp
80103b7d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b83:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b89:	75 35                	jne    80103bc0 <piperead+0x90>
80103b8b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103b91:	85 d2                	test   %edx,%edx
80103b93:	0f 84 8f 00 00 00    	je     80103c28 <piperead+0xf8>
    if(myproc()->killed){
80103b99:	e8 82 02 00 00       	call   80103e20 <myproc>
80103b9e:	8b 48 24             	mov    0x24(%eax),%ecx
80103ba1:	85 c9                	test   %ecx,%ecx
80103ba3:	74 cb                	je     80103b70 <piperead+0x40>
      release(&p->lock);
80103ba5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ba8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103bad:	56                   	push   %esi
80103bae:	e8 fd 10 00 00       	call   80104cb0 <release>
      return -1;
80103bb3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bb9:	89 d8                	mov    %ebx,%eax
80103bbb:	5b                   	pop    %ebx
80103bbc:	5e                   	pop    %esi
80103bbd:	5f                   	pop    %edi
80103bbe:	5d                   	pop    %ebp
80103bbf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bc0:	8b 45 10             	mov    0x10(%ebp),%eax
80103bc3:	85 c0                	test   %eax,%eax
80103bc5:	7e 61                	jle    80103c28 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103bc7:	31 db                	xor    %ebx,%ebx
80103bc9:	eb 13                	jmp    80103bde <piperead+0xae>
80103bcb:	90                   	nop
80103bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bd0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103bd6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103bdc:	74 1f                	je     80103bfd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103bde:	8d 41 01             	lea    0x1(%ecx),%eax
80103be1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103be7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103bed:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103bf2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bf5:	83 c3 01             	add    $0x1,%ebx
80103bf8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103bfb:	75 d3                	jne    80103bd0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103bfd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	50                   	push   %eax
80103c07:	e8 74 09 00 00       	call   80104580 <wakeup>
  release(&p->lock);
80103c0c:	89 34 24             	mov    %esi,(%esp)
80103c0f:	e8 9c 10 00 00       	call   80104cb0 <release>
  return i;
80103c14:	83 c4 10             	add    $0x10,%esp
}
80103c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c1a:	89 d8                	mov    %ebx,%eax
80103c1c:	5b                   	pop    %ebx
80103c1d:	5e                   	pop    %esi
80103c1e:	5f                   	pop    %edi
80103c1f:	5d                   	pop    %ebp
80103c20:	c3                   	ret    
80103c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c28:	31 db                	xor    %ebx,%ebx
80103c2a:	eb d1                	jmp    80103bfd <piperead+0xcd>
80103c2c:	66 90                	xchg   %ax,%ax
80103c2e:	66 90                	xchg   %ax,%ax

80103c30 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c34:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103c39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c3c:	68 40 3d 11 80       	push   $0x80113d40
80103c41:	e8 aa 0f 00 00       	call   80104bf0 <acquire>
80103c46:	83 c4 10             	add    $0x10,%esp
80103c49:	eb 14                	jmp    80103c5f <allocproc+0x2f>
80103c4b:	90                   	nop
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c50:	83 eb 80             	sub    $0xffffff80,%ebx
80103c53:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
80103c59:	0f 83 81 00 00 00    	jae    80103ce0 <allocproc+0xb0>
    if(p->state == UNUSED)
80103c5f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c62:	85 c0                	test   %eax,%eax
80103c64:	75 ea                	jne    80103c50 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c66:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  
  p->ctime = ticks;


  release(&ptable.lock);
80103c6b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c6e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c75:	8d 50 01             	lea    0x1(%eax),%edx
80103c78:	89 43 10             	mov    %eax,0x10(%ebx)
  p->ctime = ticks;
80103c7b:	a1 c0 65 11 80       	mov    0x801165c0,%eax
  p->pid = nextpid++;
80103c80:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->ctime = ticks;
80103c86:	89 43 7c             	mov    %eax,0x7c(%ebx)
  release(&ptable.lock);
80103c89:	68 40 3d 11 80       	push   $0x80113d40
80103c8e:	e8 1d 10 00 00       	call   80104cb0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103c93:	e8 58 ee ff ff       	call   80102af0 <kalloc>
80103c98:	83 c4 10             	add    $0x10,%esp
80103c9b:	85 c0                	test   %eax,%eax
80103c9d:	89 43 08             	mov    %eax,0x8(%ebx)
80103ca0:	74 57                	je     80103cf9 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ca2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ca8:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cab:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cb0:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cb3:	c7 40 14 9c 60 10 80 	movl   $0x8010609c,0x14(%eax)
  p->context = (struct context*)sp;
80103cba:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cbd:	6a 14                	push   $0x14
80103cbf:	6a 00                	push   $0x0
80103cc1:	50                   	push   %eax
80103cc2:	e8 39 10 00 00       	call   80104d00 <memset>
  p->context->eip = (uint)forkret;
80103cc7:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103cca:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ccd:	c7 40 10 10 3d 10 80 	movl   $0x80103d10,0x10(%eax)
}
80103cd4:	89 d8                	mov    %ebx,%eax
80103cd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cd9:	c9                   	leave  
80103cda:	c3                   	ret    
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ce3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103ce5:	68 40 3d 11 80       	push   $0x80113d40
80103cea:	e8 c1 0f 00 00       	call   80104cb0 <release>
}
80103cef:	89 d8                	mov    %ebx,%eax
  return 0;
80103cf1:	83 c4 10             	add    $0x10,%esp
}
80103cf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf7:	c9                   	leave  
80103cf8:	c3                   	ret    
    p->state = UNUSED;
80103cf9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d00:	31 db                	xor    %ebx,%ebx
80103d02:	eb d0                	jmp    80103cd4 <allocproc+0xa4>
80103d04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d10 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d16:	68 40 3d 11 80       	push   $0x80113d40
80103d1b:	e8 90 0f 00 00       	call   80104cb0 <release>

  if (first) {
80103d20:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d25:	83 c4 10             	add    $0x10,%esp
80103d28:	85 c0                	test   %eax,%eax
80103d2a:	75 04                	jne    80103d30 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d2c:	c9                   	leave  
80103d2d:	c3                   	ret    
80103d2e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103d30:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103d33:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d3a:	00 00 00 
    iinit(ROOTDEV);
80103d3d:	6a 01                	push   $0x1
80103d3f:	e8 6c dd ff ff       	call   80101ab0 <iinit>
    initlog(ROOTDEV);
80103d44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d4b:	e8 e0 f3 ff ff       	call   80103130 <initlog>
80103d50:	83 c4 10             	add    $0x10,%esp
}
80103d53:	c9                   	leave  
80103d54:	c3                   	ret    
80103d55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d60 <pinit>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d66:	68 75 7e 10 80       	push   $0x80107e75
80103d6b:	68 40 3d 11 80       	push   $0x80113d40
80103d70:	e8 3b 0d 00 00       	call   80104ab0 <initlock>
}
80103d75:	83 c4 10             	add    $0x10,%esp
80103d78:	c9                   	leave  
80103d79:	c3                   	ret    
80103d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d80 <mycpu>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d85:	9c                   	pushf  
80103d86:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d87:	f6 c4 02             	test   $0x2,%ah
80103d8a:	75 5e                	jne    80103dea <mycpu+0x6a>
  apicid = lapicid();
80103d8c:	e8 cf ef ff ff       	call   80102d60 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103d91:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103d97:	85 f6                	test   %esi,%esi
80103d99:	7e 42                	jle    80103ddd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d9b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103da2:	39 d0                	cmp    %edx,%eax
80103da4:	74 30                	je     80103dd6 <mycpu+0x56>
80103da6:	b9 50 38 11 80       	mov    $0x80113850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103dab:	31 d2                	xor    %edx,%edx
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
80103db0:	83 c2 01             	add    $0x1,%edx
80103db3:	39 f2                	cmp    %esi,%edx
80103db5:	74 26                	je     80103ddd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103db7:	0f b6 19             	movzbl (%ecx),%ebx
80103dba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103dc0:	39 c3                	cmp    %eax,%ebx
80103dc2:	75 ec                	jne    80103db0 <mycpu+0x30>
80103dc4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103dca:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
80103dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dd2:	5b                   	pop    %ebx
80103dd3:	5e                   	pop    %esi
80103dd4:	5d                   	pop    %ebp
80103dd5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103dd6:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
      return &cpus[i];
80103ddb:	eb f2                	jmp    80103dcf <mycpu+0x4f>
  panic("unknown apicid\n");
80103ddd:	83 ec 0c             	sub    $0xc,%esp
80103de0:	68 7c 7e 10 80       	push   $0x80107e7c
80103de5:	e8 a6 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	68 6c 7f 10 80       	push   $0x80107f6c
80103df2:	e8 99 c5 ff ff       	call   80100390 <panic>
80103df7:	89 f6                	mov    %esi,%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <cpuid>:
cpuid() {
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e06:	e8 75 ff ff ff       	call   80103d80 <mycpu>
80103e0b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103e10:	c9                   	leave  
  return mycpu()-cpus;
80103e11:	c1 f8 04             	sar    $0x4,%eax
80103e14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e1a:	c3                   	ret    
80103e1b:	90                   	nop
80103e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e20 <myproc>:
myproc(void) {
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	53                   	push   %ebx
80103e24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e27:	e8 f4 0c 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103e2c:	e8 4f ff ff ff       	call   80103d80 <mycpu>
  p = c->proc;
80103e31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e37:	e8 24 0d 00 00       	call   80104b60 <popcli>
}
80103e3c:	83 c4 04             	add    $0x4,%esp
80103e3f:	89 d8                	mov    %ebx,%eax
80103e41:	5b                   	pop    %ebx
80103e42:	5d                   	pop    %ebp
80103e43:	c3                   	ret    
80103e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e50 <userinit>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e57:	e8 d4 fd ff ff       	call   80103c30 <allocproc>
80103e5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e5e:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
80103e63:	e8 08 38 00 00       	call   80107670 <setupkvm>
80103e68:	85 c0                	test   %eax,%eax
80103e6a:	89 43 04             	mov    %eax,0x4(%ebx)
80103e6d:	0f 84 bd 00 00 00    	je     80103f30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e73:	83 ec 04             	sub    $0x4,%esp
80103e76:	68 2c 00 00 00       	push   $0x2c
80103e7b:	68 60 b4 10 80       	push   $0x8010b460
80103e80:	50                   	push   %eax
80103e81:	e8 ca 34 00 00       	call   80107350 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e8f:	6a 4c                	push   $0x4c
80103e91:	6a 00                	push   $0x0
80103e93:	ff 73 18             	pushl  0x18(%ebx)
80103e96:	e8 65 0e 00 00       	call   80104d00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ea3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ea8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103eab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103eaf:	8b 43 18             	mov    0x18(%ebx),%eax
80103eb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103eb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103eb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ebd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ec1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ec8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ecc:	8b 43 18             	mov    0x18(%ebx),%eax
80103ecf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ed6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ee0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103eed:	6a 10                	push   $0x10
80103eef:	68 a5 7e 10 80       	push   $0x80107ea5
80103ef4:	50                   	push   %eax
80103ef5:	e8 e6 0f 00 00       	call   80104ee0 <safestrcpy>
  p->cwd = namei("/");
80103efa:	c7 04 24 ae 7e 10 80 	movl   $0x80107eae,(%esp)
80103f01:	e8 0a e6 ff ff       	call   80102510 <namei>
80103f06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f09:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103f10:	e8 db 0c 00 00       	call   80104bf0 <acquire>
  p->state = RUNNABLE;
80103f15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f1c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103f23:	e8 88 0d 00 00       	call   80104cb0 <release>
}
80103f28:	83 c4 10             	add    $0x10,%esp
80103f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f2e:	c9                   	leave  
80103f2f:	c3                   	ret    
    panic("userinit: out of memory?");
80103f30:	83 ec 0c             	sub    $0xc,%esp
80103f33:	68 8c 7e 10 80       	push   $0x80107e8c
80103f38:	e8 53 c4 ff ff       	call   80100390 <panic>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi

80103f40 <growproc>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
80103f45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f48:	e8 d3 0b 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103f4d:	e8 2e fe ff ff       	call   80103d80 <mycpu>
  p = c->proc;
80103f52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f58:	e8 03 0c 00 00       	call   80104b60 <popcli>
  if(n > 0){
80103f5d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103f60:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f62:	7f 1c                	jg     80103f80 <growproc+0x40>
  } else if(n < 0){
80103f64:	75 3a                	jne    80103fa0 <growproc+0x60>
  switchuvm(curproc);
80103f66:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f69:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f6b:	53                   	push   %ebx
80103f6c:	e8 cf 32 00 00       	call   80107240 <switchuvm>
  return 0;
80103f71:	83 c4 10             	add    $0x10,%esp
80103f74:	31 c0                	xor    %eax,%eax
}
80103f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f79:	5b                   	pop    %ebx
80103f7a:	5e                   	pop    %esi
80103f7b:	5d                   	pop    %ebp
80103f7c:	c3                   	ret    
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f80:	83 ec 04             	sub    $0x4,%esp
80103f83:	01 c6                	add    %eax,%esi
80103f85:	56                   	push   %esi
80103f86:	50                   	push   %eax
80103f87:	ff 73 04             	pushl  0x4(%ebx)
80103f8a:	e8 01 35 00 00       	call   80107490 <allocuvm>
80103f8f:	83 c4 10             	add    $0x10,%esp
80103f92:	85 c0                	test   %eax,%eax
80103f94:	75 d0                	jne    80103f66 <growproc+0x26>
      return -1;
80103f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f9b:	eb d9                	jmp    80103f76 <growproc+0x36>
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fa0:	83 ec 04             	sub    $0x4,%esp
80103fa3:	01 c6                	add    %eax,%esi
80103fa5:	56                   	push   %esi
80103fa6:	50                   	push   %eax
80103fa7:	ff 73 04             	pushl  0x4(%ebx)
80103faa:	e8 11 36 00 00       	call   801075c0 <deallocuvm>
80103faf:	83 c4 10             	add    $0x10,%esp
80103fb2:	85 c0                	test   %eax,%eax
80103fb4:	75 b0                	jne    80103f66 <growproc+0x26>
80103fb6:	eb de                	jmp    80103f96 <growproc+0x56>
80103fb8:	90                   	nop
80103fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fc0 <fork>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
80103fc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fc9:	e8 52 0b 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80103fce:	e8 ad fd ff ff       	call   80103d80 <mycpu>
  p = c->proc;
80103fd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fd9:	e8 82 0b 00 00       	call   80104b60 <popcli>
  if((np = allocproc()) == 0){
80103fde:	e8 4d fc ff ff       	call   80103c30 <allocproc>
80103fe3:	85 c0                	test   %eax,%eax
80103fe5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fe8:	0f 84 b7 00 00 00    	je     801040a5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103fee:	83 ec 08             	sub    $0x8,%esp
80103ff1:	ff 33                	pushl  (%ebx)
80103ff3:	ff 73 04             	pushl  0x4(%ebx)
80103ff6:	89 c7                	mov    %eax,%edi
80103ff8:	e8 43 37 00 00       	call   80107740 <copyuvm>
80103ffd:	83 c4 10             	add    $0x10,%esp
80104000:	85 c0                	test   %eax,%eax
80104002:	89 47 04             	mov    %eax,0x4(%edi)
80104005:	0f 84 a1 00 00 00    	je     801040ac <fork+0xec>
  np->sz = curproc->sz;
8010400b:	8b 03                	mov    (%ebx),%eax
8010400d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104010:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80104012:	89 59 14             	mov    %ebx,0x14(%ecx)
80104015:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80104017:	8b 79 18             	mov    0x18(%ecx),%edi
8010401a:	8b 73 18             	mov    0x18(%ebx),%esi
8010401d:	b9 13 00 00 00       	mov    $0x13,%ecx
80104022:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104024:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104026:	8b 40 18             	mov    0x18(%eax),%eax
80104029:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104030:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104034:	85 c0                	test   %eax,%eax
80104036:	74 13                	je     8010404b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	50                   	push   %eax
8010403c:	e8 df d3 ff ff       	call   80101420 <filedup>
80104041:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104044:	83 c4 10             	add    $0x10,%esp
80104047:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010404b:	83 c6 01             	add    $0x1,%esi
8010404e:	83 fe 10             	cmp    $0x10,%esi
80104051:	75 dd                	jne    80104030 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104053:	83 ec 0c             	sub    $0xc,%esp
80104056:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104059:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010405c:	e8 1f dc ff ff       	call   80101c80 <idup>
80104061:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104064:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104067:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010406a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010406d:	6a 10                	push   $0x10
8010406f:	53                   	push   %ebx
80104070:	50                   	push   %eax
80104071:	e8 6a 0e 00 00       	call   80104ee0 <safestrcpy>
  pid = np->pid;
80104076:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104079:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104080:	e8 6b 0b 00 00       	call   80104bf0 <acquire>
  np->state = RUNNABLE;
80104085:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010408c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104093:	e8 18 0c 00 00       	call   80104cb0 <release>
  return pid;
80104098:	83 c4 10             	add    $0x10,%esp
}
8010409b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010409e:	89 d8                	mov    %ebx,%eax
801040a0:	5b                   	pop    %ebx
801040a1:	5e                   	pop    %esi
801040a2:	5f                   	pop    %edi
801040a3:	5d                   	pop    %ebp
801040a4:	c3                   	ret    
    return -1;
801040a5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040aa:	eb ef                	jmp    8010409b <fork+0xdb>
    kfree(np->kstack);
801040ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801040af:	83 ec 0c             	sub    $0xc,%esp
801040b2:	ff 73 08             	pushl  0x8(%ebx)
801040b5:	e8 86 e8 ff ff       	call   80102940 <kfree>
    np->kstack = 0;
801040ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801040c1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040c8:	83 c4 10             	add    $0x10,%esp
801040cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040d0:	eb c9                	jmp    8010409b <fork+0xdb>
801040d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040e0 <scheduler>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	57                   	push   %edi
801040e4:	56                   	push   %esi
801040e5:	53                   	push   %ebx
801040e6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801040e9:	e8 92 fc ff ff       	call   80103d80 <mycpu>
801040ee:	8d 78 04             	lea    0x4(%eax),%edi
801040f1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801040f3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040fa:	00 00 00 
801040fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104100:	fb                   	sti    
    acquire(&ptable.lock);
80104101:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104104:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
80104109:	68 40 3d 11 80       	push   $0x80113d40
8010410e:	e8 dd 0a 00 00       	call   80104bf0 <acquire>
80104113:	83 c4 10             	add    $0x10,%esp
80104116:	8d 76 00             	lea    0x0(%esi),%esi
80104119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104120:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104124:	75 33                	jne    80104159 <scheduler+0x79>
      switchuvm(p);
80104126:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104129:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010412f:	53                   	push   %ebx
80104130:	e8 0b 31 00 00       	call   80107240 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104135:	58                   	pop    %eax
80104136:	5a                   	pop    %edx
80104137:	ff 73 1c             	pushl  0x1c(%ebx)
8010413a:	57                   	push   %edi
      p->state = RUNNING;
8010413b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104142:	e8 f4 0d 00 00       	call   80104f3b <swtch>
      switchkvm();
80104147:	e8 d4 30 00 00       	call   80107220 <switchkvm>
      c->proc = 0;
8010414c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104153:	00 00 00 
80104156:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104159:	83 eb 80             	sub    $0xffffff80,%ebx
8010415c:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
80104162:	72 bc                	jb     80104120 <scheduler+0x40>
    release(&ptable.lock);
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	68 40 3d 11 80       	push   $0x80113d40
8010416c:	e8 3f 0b 00 00       	call   80104cb0 <release>
    sti();
80104171:	83 c4 10             	add    $0x10,%esp
80104174:	eb 8a                	jmp    80104100 <scheduler+0x20>
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <sched>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
  pushcli();
80104185:	e8 96 09 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010418a:	e8 f1 fb ff ff       	call   80103d80 <mycpu>
  p = c->proc;
8010418f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104195:	e8 c6 09 00 00       	call   80104b60 <popcli>
  if(!holding(&ptable.lock))
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	68 40 3d 11 80       	push   $0x80113d40
801041a2:	e8 19 0a 00 00       	call   80104bc0 <holding>
801041a7:	83 c4 10             	add    $0x10,%esp
801041aa:	85 c0                	test   %eax,%eax
801041ac:	74 4f                	je     801041fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801041ae:	e8 cd fb ff ff       	call   80103d80 <mycpu>
801041b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041ba:	75 68                	jne    80104224 <sched+0xa4>
  if(p->state == RUNNING)
801041bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041c0:	74 55                	je     80104217 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041c2:	9c                   	pushf  
801041c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041c4:	f6 c4 02             	test   $0x2,%ah
801041c7:	75 41                	jne    8010420a <sched+0x8a>
  intena = mycpu()->intena;
801041c9:	e8 b2 fb ff ff       	call   80103d80 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801041d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041d7:	e8 a4 fb ff ff       	call   80103d80 <mycpu>
801041dc:	83 ec 08             	sub    $0x8,%esp
801041df:	ff 70 04             	pushl  0x4(%eax)
801041e2:	53                   	push   %ebx
801041e3:	e8 53 0d 00 00       	call   80104f3b <swtch>
  mycpu()->intena = intena;
801041e8:	e8 93 fb ff ff       	call   80103d80 <mycpu>
}
801041ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801041f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041f9:	5b                   	pop    %ebx
801041fa:	5e                   	pop    %esi
801041fb:	5d                   	pop    %ebp
801041fc:	c3                   	ret    
    panic("sched ptable.lock");
801041fd:	83 ec 0c             	sub    $0xc,%esp
80104200:	68 b0 7e 10 80       	push   $0x80107eb0
80104205:	e8 86 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 dc 7e 10 80       	push   $0x80107edc
80104212:	e8 79 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
80104217:	83 ec 0c             	sub    $0xc,%esp
8010421a:	68 ce 7e 10 80       	push   $0x80107ece
8010421f:	e8 6c c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 c2 7e 10 80       	push   $0x80107ec2
8010422c:	e8 5f c1 ff ff       	call   80100390 <panic>
80104231:	eb 0d                	jmp    80104240 <exit>
80104233:	90                   	nop
80104234:	90                   	nop
80104235:	90                   	nop
80104236:	90                   	nop
80104237:	90                   	nop
80104238:	90                   	nop
80104239:	90                   	nop
8010423a:	90                   	nop
8010423b:	90                   	nop
8010423c:	90                   	nop
8010423d:	90                   	nop
8010423e:	90                   	nop
8010423f:	90                   	nop

80104240 <exit>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	57                   	push   %edi
80104244:	56                   	push   %esi
80104245:	53                   	push   %ebx
80104246:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104249:	e8 d2 08 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010424e:	e8 2d fb ff ff       	call   80103d80 <mycpu>
  p = c->proc;
80104253:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104259:	e8 02 09 00 00       	call   80104b60 <popcli>
  if(curproc == initproc)
8010425e:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
80104264:	8d 5e 28             	lea    0x28(%esi),%ebx
80104267:	8d 7e 68             	lea    0x68(%esi),%edi
8010426a:	0f 84 e7 00 00 00    	je     80104357 <exit+0x117>
    if(curproc->ofile[fd]){
80104270:	8b 03                	mov    (%ebx),%eax
80104272:	85 c0                	test   %eax,%eax
80104274:	74 12                	je     80104288 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	50                   	push   %eax
8010427a:	e8 f1 d1 ff ff       	call   80101470 <fileclose>
      curproc->ofile[fd] = 0;
8010427f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104285:	83 c4 10             	add    $0x10,%esp
80104288:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010428b:	39 fb                	cmp    %edi,%ebx
8010428d:	75 e1                	jne    80104270 <exit+0x30>
  begin_op();
8010428f:	e8 3c ef ff ff       	call   801031d0 <begin_op>
  iput(curproc->cwd);
80104294:	83 ec 0c             	sub    $0xc,%esp
80104297:	ff 76 68             	pushl  0x68(%esi)
8010429a:	e8 41 db ff ff       	call   80101de0 <iput>
  end_op();
8010429f:	e8 9c ef ff ff       	call   80103240 <end_op>
  curproc->cwd = 0;
801042a4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801042ab:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801042b2:	e8 39 09 00 00       	call   80104bf0 <acquire>
  wakeup1(curproc->parent);
801042b7:	8b 56 14             	mov    0x14(%esi),%edx
801042ba:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042bd:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801042c2:	eb 0e                	jmp    801042d2 <exit+0x92>
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c8:	83 e8 80             	sub    $0xffffff80,%eax
801042cb:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801042d0:	73 1c                	jae    801042ee <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
801042d2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042d6:	75 f0                	jne    801042c8 <exit+0x88>
801042d8:	3b 50 20             	cmp    0x20(%eax),%edx
801042db:	75 eb                	jne    801042c8 <exit+0x88>
      p->state = RUNNABLE;
801042dd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e4:	83 e8 80             	sub    $0xffffff80,%eax
801042e7:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801042ec:	72 e4                	jb     801042d2 <exit+0x92>
      p->parent = initproc;
801042ee:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f4:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
801042f9:	eb 10                	jmp    8010430b <exit+0xcb>
801042fb:	90                   	nop
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104300:	83 ea 80             	sub    $0xffffff80,%edx
80104303:	81 fa 74 5d 11 80    	cmp    $0x80115d74,%edx
80104309:	73 33                	jae    8010433e <exit+0xfe>
    if(p->parent == curproc){
8010430b:	39 72 14             	cmp    %esi,0x14(%edx)
8010430e:	75 f0                	jne    80104300 <exit+0xc0>
      if(p->state == ZOMBIE)
80104310:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104314:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104317:	75 e7                	jne    80104300 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104319:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010431e:	eb 0a                	jmp    8010432a <exit+0xea>
80104320:	83 e8 80             	sub    $0xffffff80,%eax
80104323:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
80104328:	73 d6                	jae    80104300 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010432a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010432e:	75 f0                	jne    80104320 <exit+0xe0>
80104330:	3b 48 20             	cmp    0x20(%eax),%ecx
80104333:	75 eb                	jne    80104320 <exit+0xe0>
      p->state = RUNNABLE;
80104335:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010433c:	eb e2                	jmp    80104320 <exit+0xe0>
  curproc->state = ZOMBIE;
8010433e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104345:	e8 36 fe ff ff       	call   80104180 <sched>
  panic("zombie exit");
8010434a:	83 ec 0c             	sub    $0xc,%esp
8010434d:	68 fd 7e 10 80       	push   $0x80107efd
80104352:	e8 39 c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104357:	83 ec 0c             	sub    $0xc,%esp
8010435a:	68 f0 7e 10 80       	push   $0x80107ef0
8010435f:	e8 2c c0 ff ff       	call   80100390 <panic>
80104364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010436a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104370 <yield>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104377:	68 40 3d 11 80       	push   $0x80113d40
8010437c:	e8 6f 08 00 00       	call   80104bf0 <acquire>
  pushcli();
80104381:	e8 9a 07 00 00       	call   80104b20 <pushcli>
  c = mycpu();
80104386:	e8 f5 f9 ff ff       	call   80103d80 <mycpu>
  p = c->proc;
8010438b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104391:	e8 ca 07 00 00       	call   80104b60 <popcli>
  myproc()->state = RUNNABLE;
80104396:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010439d:	e8 de fd ff ff       	call   80104180 <sched>
  release(&ptable.lock);
801043a2:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801043a9:	e8 02 09 00 00       	call   80104cb0 <release>
}
801043ae:	83 c4 10             	add    $0x10,%esp
801043b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b4:	c9                   	leave  
801043b5:	c3                   	ret    
801043b6:	8d 76 00             	lea    0x0(%esi),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <sleep>:
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	56                   	push   %esi
801043c5:	53                   	push   %ebx
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043cf:	e8 4c 07 00 00       	call   80104b20 <pushcli>
  c = mycpu();
801043d4:	e8 a7 f9 ff ff       	call   80103d80 <mycpu>
  p = c->proc;
801043d9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043df:	e8 7c 07 00 00       	call   80104b60 <popcli>
  if(p == 0)
801043e4:	85 db                	test   %ebx,%ebx
801043e6:	0f 84 87 00 00 00    	je     80104473 <sleep+0xb3>
  if(lk == 0)
801043ec:	85 f6                	test   %esi,%esi
801043ee:	74 76                	je     80104466 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043f0:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
801043f6:	74 50                	je     80104448 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 40 3d 11 80       	push   $0x80113d40
80104400:	e8 eb 07 00 00       	call   80104bf0 <acquire>
    release(lk);
80104405:	89 34 24             	mov    %esi,(%esp)
80104408:	e8 a3 08 00 00       	call   80104cb0 <release>
  p->chan = chan;
8010440d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104410:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104417:	e8 64 fd ff ff       	call   80104180 <sched>
  p->chan = 0;
8010441c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104423:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010442a:	e8 81 08 00 00       	call   80104cb0 <release>
    acquire(lk);
8010442f:	89 75 08             	mov    %esi,0x8(%ebp)
80104432:	83 c4 10             	add    $0x10,%esp
}
80104435:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104438:	5b                   	pop    %ebx
80104439:	5e                   	pop    %esi
8010443a:	5f                   	pop    %edi
8010443b:	5d                   	pop    %ebp
    acquire(lk);
8010443c:	e9 af 07 00 00       	jmp    80104bf0 <acquire>
80104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104448:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010444b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104452:	e8 29 fd ff ff       	call   80104180 <sched>
  p->chan = 0;
80104457:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010445e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104461:	5b                   	pop    %ebx
80104462:	5e                   	pop    %esi
80104463:	5f                   	pop    %edi
80104464:	5d                   	pop    %ebp
80104465:	c3                   	ret    
    panic("sleep without lk");
80104466:	83 ec 0c             	sub    $0xc,%esp
80104469:	68 0f 7f 10 80       	push   $0x80107f0f
8010446e:	e8 1d bf ff ff       	call   80100390 <panic>
    panic("sleep");
80104473:	83 ec 0c             	sub    $0xc,%esp
80104476:	68 09 7f 10 80       	push   $0x80107f09
8010447b:	e8 10 bf ff ff       	call   80100390 <panic>

80104480 <wait>:
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
  pushcli();
80104485:	e8 96 06 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010448a:	e8 f1 f8 ff ff       	call   80103d80 <mycpu>
  p = c->proc;
8010448f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104495:	e8 c6 06 00 00       	call   80104b60 <popcli>
  acquire(&ptable.lock);
8010449a:	83 ec 0c             	sub    $0xc,%esp
8010449d:	68 40 3d 11 80       	push   $0x80113d40
801044a2:	e8 49 07 00 00       	call   80104bf0 <acquire>
801044a7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801044aa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ac:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
801044b1:	eb 10                	jmp    801044c3 <wait+0x43>
801044b3:	90                   	nop
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b8:	83 eb 80             	sub    $0xffffff80,%ebx
801044bb:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
801044c1:	73 1b                	jae    801044de <wait+0x5e>
      if(p->parent != curproc)
801044c3:	39 73 14             	cmp    %esi,0x14(%ebx)
801044c6:	75 f0                	jne    801044b8 <wait+0x38>
      if(p->state == ZOMBIE){
801044c8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044cc:	74 32                	je     80104500 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ce:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
801044d1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d6:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
801044dc:	72 e5                	jb     801044c3 <wait+0x43>
    if(!havekids || curproc->killed){
801044de:	85 c0                	test   %eax,%eax
801044e0:	74 7b                	je     8010455d <wait+0xdd>
801044e2:	8b 46 24             	mov    0x24(%esi),%eax
801044e5:	85 c0                	test   %eax,%eax
801044e7:	75 74                	jne    8010455d <wait+0xdd>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044e9:	83 ec 08             	sub    $0x8,%esp
801044ec:	68 40 3d 11 80       	push   $0x80113d40
801044f1:	56                   	push   %esi
801044f2:	e8 c9 fe ff ff       	call   801043c0 <sleep>
    havekids = 0;
801044f7:	83 c4 10             	add    $0x10,%esp
801044fa:	eb ae                	jmp    801044aa <wait+0x2a>
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104506:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104509:	e8 32 e4 ff ff       	call   80102940 <kfree>
        freevm(p->pgdir);
8010450e:	5a                   	pop    %edx
8010450f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104512:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104519:	e8 d2 30 00 00       	call   801075f0 <freevm>
        release(&ptable.lock);
8010451e:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
80104525:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010452c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104533:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104537:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010453e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->ctime = 0;
80104545:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        release(&ptable.lock);
8010454c:	e8 5f 07 00 00       	call   80104cb0 <release>
        return pid;
80104551:	83 c4 10             	add    $0x10,%esp
}
80104554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104557:	89 f0                	mov    %esi,%eax
80104559:	5b                   	pop    %ebx
8010455a:	5e                   	pop    %esi
8010455b:	5d                   	pop    %ebp
8010455c:	c3                   	ret    
      release(&ptable.lock);
8010455d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104560:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104565:	68 40 3d 11 80       	push   $0x80113d40
8010456a:	e8 41 07 00 00       	call   80104cb0 <release>
      return -1;
8010456f:	83 c4 10             	add    $0x10,%esp
80104572:	eb e0                	jmp    80104554 <wait+0xd4>
80104574:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010457a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104580 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 10             	sub    $0x10,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010458a:	68 40 3d 11 80       	push   $0x80113d40
8010458f:	e8 5c 06 00 00       	call   80104bf0 <acquire>
80104594:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104597:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010459c:	eb 0c                	jmp    801045aa <wakeup+0x2a>
8010459e:	66 90                	xchg   %ax,%ax
801045a0:	83 e8 80             	sub    $0xffffff80,%eax
801045a3:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801045a8:	73 1c                	jae    801045c6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801045aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045ae:	75 f0                	jne    801045a0 <wakeup+0x20>
801045b0:	3b 58 20             	cmp    0x20(%eax),%ebx
801045b3:	75 eb                	jne    801045a0 <wakeup+0x20>
      p->state = RUNNABLE;
801045b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045bc:	83 e8 80             	sub    $0xffffff80,%eax
801045bf:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
801045c4:	72 e4                	jb     801045aa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801045c6:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
801045cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d0:	c9                   	leave  
  release(&ptable.lock);
801045d1:	e9 da 06 00 00       	jmp    80104cb0 <release>
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 10             	sub    $0x10,%esp
801045e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045ea:	68 40 3d 11 80       	push   $0x80113d40
801045ef:	e8 fc 05 00 00       	call   80104bf0 <acquire>
801045f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801045fc:	eb 0c                	jmp    8010460a <kill+0x2a>
801045fe:	66 90                	xchg   %ax,%ax
80104600:	83 e8 80             	sub    $0xffffff80,%eax
80104603:	3d 74 5d 11 80       	cmp    $0x80115d74,%eax
80104608:	73 36                	jae    80104640 <kill+0x60>
    if(p->pid == pid){
8010460a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010460d:	75 f1                	jne    80104600 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010460f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104613:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010461a:	75 07                	jne    80104623 <kill+0x43>
        p->state = RUNNABLE;
8010461c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104623:	83 ec 0c             	sub    $0xc,%esp
80104626:	68 40 3d 11 80       	push   $0x80113d40
8010462b:	e8 80 06 00 00       	call   80104cb0 <release>
      return 0;
80104630:	83 c4 10             	add    $0x10,%esp
80104633:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104635:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104638:	c9                   	leave  
80104639:	c3                   	ret    
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104640:	83 ec 0c             	sub    $0xc,%esp
80104643:	68 40 3d 11 80       	push   $0x80113d40
80104648:	e8 63 06 00 00       	call   80104cb0 <release>
  return -1;
8010464d:	83 c4 10             	add    $0x10,%esp
80104650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104658:	c9                   	leave  
80104659:	c3                   	ret    
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	56                   	push   %esi
80104665:	53                   	push   %ebx
80104666:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104669:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
8010466e:	83 ec 3c             	sub    $0x3c,%esp
80104671:	eb 24                	jmp    80104697 <procdump+0x37>
80104673:	90                   	nop
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 8b 83 10 80       	push   $0x8010838b
80104680:	e8 db bf ff ff       	call   80100660 <cprintf>
80104685:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104688:	83 eb 80             	sub    $0xffffff80,%ebx
8010468b:	81 fb 74 5d 11 80    	cmp    $0x80115d74,%ebx
80104691:	0f 83 81 00 00 00    	jae    80104718 <procdump+0xb8>
    if(p->state == UNUSED)
80104697:	8b 43 0c             	mov    0xc(%ebx),%eax
8010469a:	85 c0                	test   %eax,%eax
8010469c:	74 ea                	je     80104688 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010469e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801046a1:	ba 20 7f 10 80       	mov    $0x80107f20,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046a6:	77 11                	ja     801046b9 <procdump+0x59>
801046a8:	8b 14 85 04 80 10 80 	mov    -0x7fef7ffc(,%eax,4),%edx
      state = "???";
801046af:	b8 20 7f 10 80       	mov    $0x80107f20,%eax
801046b4:	85 d2                	test   %edx,%edx
801046b6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046bc:	50                   	push   %eax
801046bd:	52                   	push   %edx
801046be:	ff 73 10             	pushl  0x10(%ebx)
801046c1:	68 24 7f 10 80       	push   $0x80107f24
801046c6:	e8 95 bf ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801046cb:	83 c4 10             	add    $0x10,%esp
801046ce:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801046d2:	75 a4                	jne    80104678 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046d4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046d7:	83 ec 08             	sub    $0x8,%esp
801046da:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046dd:	50                   	push   %eax
801046de:	8b 43 1c             	mov    0x1c(%ebx),%eax
801046e1:	8b 40 0c             	mov    0xc(%eax),%eax
801046e4:	83 c0 08             	add    $0x8,%eax
801046e7:	50                   	push   %eax
801046e8:	e8 e3 03 00 00       	call   80104ad0 <getcallerpcs>
801046ed:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801046f0:	8b 17                	mov    (%edi),%edx
801046f2:	85 d2                	test   %edx,%edx
801046f4:	74 82                	je     80104678 <procdump+0x18>
        cprintf(" %p", pc[i]);
801046f6:	83 ec 08             	sub    $0x8,%esp
801046f9:	83 c7 04             	add    $0x4,%edi
801046fc:	52                   	push   %edx
801046fd:	68 61 79 10 80       	push   $0x80107961
80104702:	e8 59 bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104707:	83 c4 10             	add    $0x10,%esp
8010470a:	39 fe                	cmp    %edi,%esi
8010470c:	75 e2                	jne    801046f0 <procdump+0x90>
8010470e:	e9 65 ff ff ff       	jmp    80104678 <procdump+0x18>
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104718:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010471b:	5b                   	pop    %ebx
8010471c:	5e                   	pop    %esi
8010471d:	5f                   	pop    %edi
8010471e:	5d                   	pop    %ebp
8010471f:	c3                   	ret    

80104720 <show_descendant>:

void show_descendant(int parent_pid)
{
80104720:	55                   	push   %ebp
80104721:	b8 84 3d 11 80       	mov    $0x80113d84,%eax

  int have_descendant = 0;
80104726:	31 c9                	xor    %ecx,%ecx
{
80104728:	89 e5                	mov    %esp,%ebp
8010472a:	57                   	push   %edi
8010472b:	56                   	push   %esi
8010472c:	53                   	push   %ebx
  int ids[30];
  int d = 0;
8010472d:	31 db                	xor    %ebx,%ebx
{
8010472f:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
80104735:	8b 7d 08             	mov    0x8(%ebp),%edi
80104738:	90                   	nop
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int c,a = 0;
  int crtime[30];
  for(int i = 0; i < NPROC; i++)
  {
    if(ptable.proc[i].parent->pid == parent_pid)
80104740:	8b 50 04             	mov    0x4(%eax),%edx
80104743:	39 7a 10             	cmp    %edi,0x10(%edx)
80104746:	75 1b                	jne    80104763 <show_descendant+0x43>
    {
      
      ids[d] = ptable.proc[i].pid;
80104748:	8b 10                	mov    (%eax),%edx
      crtime[d] = ptable.proc[i].ctime;
      d++;
      
      have_descendant = 1;
8010474a:	b9 01 00 00 00       	mov    $0x1,%ecx
      ids[d] = ptable.proc[i].pid;
8010474f:	89 94 9d f8 fe ff ff 	mov    %edx,-0x108(%ebp,%ebx,4)
      crtime[d] = ptable.proc[i].ctime;
80104756:	8b 50 6c             	mov    0x6c(%eax),%edx
80104759:	89 94 9d 70 ff ff ff 	mov    %edx,-0x90(%ebp,%ebx,4)
      d++;
80104760:	83 c3 01             	add    $0x1,%ebx
80104763:	83 e8 80             	sub    $0xffffff80,%eax
  for(int i = 0; i < NPROC; i++)
80104766:	3d 84 5d 11 80       	cmp    $0x80115d84,%eax
8010476b:	75 d3                	jne    80104740 <show_descendant+0x20>
    }
  }

  for(int m = 0; m < d; m++)
8010476d:	85 db                	test   %ebx,%ebx
8010476f:	89 8d e8 fe ff ff    	mov    %ecx,-0x118(%ebp)
80104775:	0f 84 07 01 00 00    	je     80104882 <show_descendant+0x162>
8010477b:	31 c9                	xor    %ecx,%ecx
8010477d:	89 7d 08             	mov    %edi,0x8(%ebp)
80104780:	89 9d ec fe ff ff    	mov    %ebx,-0x114(%ebp)
80104786:	89 cf                	mov    %ecx,%edi
80104788:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010478e:	8d b5 f8 fe ff ff    	lea    -0x108(%ebp),%esi
  {
    for(int n = m + 1; n < d; n++)
80104794:	83 c7 01             	add    $0x1,%edi
80104797:	39 bd ec fe ff ff    	cmp    %edi,-0x114(%ebp)
8010479d:	89 c3                	mov    %eax,%ebx
8010479f:	74 7a                	je     8010481b <show_descendant+0xfb>
801047a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a8:	89 f8                	mov    %edi,%eax
801047aa:	89 9d f4 fe ff ff    	mov    %ebx,-0x10c(%ebp)
801047b0:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
801047b6:	8d 76 00             	lea    0x0(%esi),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    {
      if(crtime[m] < crtime[n])
801047c0:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801047c6:	8b 8c 85 70 ff ff ff 	mov    -0x90(%ebp,%eax,4),%ecx
801047cd:	8b 17                	mov    (%edi),%edx
801047cf:	39 ca                	cmp    %ecx,%edx
801047d1:	7d 23                	jge    801047f6 <show_descendant+0xd6>
      {
        c = crtime[m];
        a = ids[m];
801047d3:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
        crtime[m] = crtime[n];
801047d9:	89 0f                	mov    %ecx,(%edi)
        ids[m] = ids[n];
801047db:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
801047de:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
        crtime[n] = c;
801047e4:	89 94 85 70 ff ff ff 	mov    %edx,-0x90(%ebp,%eax,4)
        a = ids[m];
801047eb:	8b 5c 9e fc          	mov    -0x4(%esi,%ebx,4),%ebx
        ids[m] = ids[n];
801047ef:	89 4c be fc          	mov    %ecx,-0x4(%esi,%edi,4)
        ids[n] = a;
801047f3:	89 1c 86             	mov    %ebx,(%esi,%eax,4)
    for(int n = m + 1; n < d; n++)
801047f6:	83 c0 01             	add    $0x1,%eax
801047f9:	39 85 ec fe ff ff    	cmp    %eax,-0x114(%ebp)
801047ff:	75 bf                	jne    801047c0 <show_descendant+0xa0>
80104801:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80104807:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
8010480d:	83 c3 04             	add    $0x4,%ebx
80104810:	83 c7 01             	add    $0x1,%edi
80104813:	39 bd ec fe ff ff    	cmp    %edi,-0x114(%ebp)
80104819:	75 8d                	jne    801047a8 <show_descendant+0x88>
8010481b:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80104821:	8b 7d 08             	mov    0x8(%ebp),%edi
      }
    }
  }
  for(int m = 0; m < d; m++)
80104824:	31 c0                	xor    %eax,%eax
80104826:	89 9d f4 fe ff ff    	mov    %ebx,-0x10c(%ebp)
8010482c:	89 c3                	mov    %eax,%ebx
8010482e:	66 90                	xchg   %ax,%ax
    cprintf("my id: %d, my child id: %d, my child creationtime: %d", parent_pid,ids[m],crtime[m]);
80104830:	ff b4 9d 70 ff ff ff 	pushl  -0x90(%ebp,%ebx,4)
80104837:	ff 34 9e             	pushl  (%esi,%ebx,4)
  for(int m = 0; m < d; m++)
8010483a:	83 c3 01             	add    $0x1,%ebx
    cprintf("my id: %d, my child id: %d, my child creationtime: %d", parent_pid,ids[m],crtime[m]);
8010483d:	57                   	push   %edi
8010483e:	68 94 7f 10 80       	push   $0x80107f94
80104843:	e8 18 be ff ff       	call   80100660 <cprintf>
  for(int m = 0; m < d; m++)
80104848:	83 c4 10             	add    $0x10,%esp
8010484b:	39 9d f4 fe ff ff    	cmp    %ebx,-0x10c(%ebp)
80104851:	75 dd                	jne    80104830 <show_descendant+0x110>

  if(have_descendant)
80104853:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80104859:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
8010485f:	85 c0                	test   %eax,%eax
80104861:	75 29                	jne    8010488c <show_descendant+0x16c>
  for(int m = 0; m < d; m++)
80104863:	31 ff                	xor    %edi,%edi
    cprintf("\n");
  for(int m = 0; m < d; m++)
    show_descendant(ids[m]);
80104865:	83 ec 0c             	sub    $0xc,%esp
80104868:	ff 34 be             	pushl  (%esi,%edi,4)
  for(int m = 0; m < d; m++)
8010486b:	83 c7 01             	add    $0x1,%edi
    show_descendant(ids[m]);
8010486e:	e8 ad fe ff ff       	call   80104720 <show_descendant>
  for(int m = 0; m < d; m++)
80104873:	83 c4 10             	add    $0x10,%esp
80104876:	39 fb                	cmp    %edi,%ebx
80104878:	7f eb                	jg     80104865 <show_descendant+0x145>

}
8010487a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010487d:	5b                   	pop    %ebx
8010487e:	5e                   	pop    %esi
8010487f:	5f                   	pop    %edi
80104880:	5d                   	pop    %ebp
80104881:	c3                   	ret    
  if(have_descendant)
80104882:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
80104888:	85 d2                	test   %edx,%edx
8010488a:	74 ee                	je     8010487a <show_descendant+0x15a>
    cprintf("\n");
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	68 8b 83 10 80       	push   $0x8010838b
80104894:	e8 c7 bd ff ff       	call   80100660 <cprintf>
  for(int m = 0; m < d; m++)
80104899:	83 c4 10             	add    $0x10,%esp
8010489c:	85 db                	test   %ebx,%ebx
8010489e:	74 da                	je     8010487a <show_descendant+0x15a>
801048a0:	8d b5 f8 fe ff ff    	lea    -0x108(%ebp),%esi
801048a6:	eb bb                	jmp    80104863 <show_descendant+0x143>
801048a8:	90                   	nop
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048b0 <show_ancestors>:

void show_ancestors(int my_pid)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 75 08             	mov    0x8(%ebp),%esi
801048b8:	bb 88 3d 11 80       	mov    $0x80113d88,%ebx
801048bd:	eb 0c                	jmp    801048cb <show_ancestors+0x1b>
801048bf:	90                   	nop
801048c0:	83 eb 80             	sub    $0xffffff80,%ebx

  for(int i = 0; i < NPROC; i++)
801048c3:	81 fb 88 5d 11 80    	cmp    $0x80115d88,%ebx
801048c9:	74 43                	je     8010490e <show_ancestors+0x5e>
  {
    if(ptable.proc[i].pid == my_pid)
801048cb:	39 73 fc             	cmp    %esi,-0x4(%ebx)
801048ce:	75 f0                	jne    801048c0 <show_ancestors+0x10>
    {
      
      cprintf("my id: %d, my parent id: %d, my parent creationtime: %d", my_pid,ptable.proc[i].parent->pid,my_pid,ptable.proc[i].parent->ctime);
801048d0:	8b 03                	mov    (%ebx),%eax
801048d2:	83 ec 0c             	sub    $0xc,%esp
801048d5:	83 eb 80             	sub    $0xffffff80,%ebx
801048d8:	ff 70 7c             	pushl  0x7c(%eax)
801048db:	56                   	push   %esi
801048dc:	ff 70 10             	pushl  0x10(%eax)
801048df:	56                   	push   %esi
801048e0:	68 cc 7f 10 80       	push   $0x80107fcc
801048e5:	e8 76 bd ff ff       	call   80100660 <cprintf>
      cprintf("\n");
801048ea:	83 c4 14             	add    $0x14,%esp
801048ed:	68 8b 83 10 80       	push   $0x8010838b
801048f2:	e8 69 bd ff ff       	call   80100660 <cprintf>
      show_ancestors(ptable.proc[i].parent->pid);
801048f7:	58                   	pop    %eax
801048f8:	8b 43 80             	mov    -0x80(%ebx),%eax
801048fb:	ff 70 10             	pushl  0x10(%eax)
801048fe:	e8 ad ff ff ff       	call   801048b0 <show_ancestors>
80104903:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < NPROC; i++)
80104906:	81 fb 88 5d 11 80    	cmp    $0x80115d88,%ebx
8010490c:	75 bd                	jne    801048cb <show_ancestors+0x1b>
    }
  }

}
8010490e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104911:	5b                   	pop    %ebx
80104912:	5e                   	pop    %esi
80104913:	5d                   	pop    %ebp
80104914:	c3                   	ret    
80104915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <sleep_process>:


void sleep_process(void *chan)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104927:	e8 f4 01 00 00       	call   80104b20 <pushcli>
  c = mycpu();
8010492c:	e8 4f f4 ff ff       	call   80103d80 <mycpu>
  p = c->proc;
80104931:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104937:	e8 24 02 00 00       	call   80104b60 <popcli>
  struct proc *p = myproc();
  cprintf("my id: %d", p->pid );
8010493c:	83 ec 08             	sub    $0x8,%esp
8010493f:	ff 73 10             	pushl  0x10(%ebx)
80104942:	68 2d 7f 10 80       	push   $0x80107f2d
80104947:	e8 14 bd ff ff       	call   80100660 <cprintf>
  if(p == 0)
    panic("sleep");


  // Go to sleep.
  p->chan = chan;
8010494c:	8b 45 08             	mov    0x8(%ebp),%eax
  p->state = SLEEPING;
8010494f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  p->chan = chan;
80104956:	89 43 20             	mov    %eax,0x20(%ebx)

  // sched();
  cprintf("my id: %d\n", p->pid );
80104959:	58                   	pop    %eax
8010495a:	5a                   	pop    %edx
8010495b:	ff 73 10             	pushl  0x10(%ebx)
8010495e:	68 37 7f 10 80       	push   $0x80107f37
80104963:	e8 f8 bc ff ff       	call   80100660 <cprintf>


  // Tidy up.
  p->chan = 0;
80104968:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  // if(lk != &ptable.lock){  //DOC: sleeplock2
  //   release(&ptable.lock);
  //   // acquire(lk);
  // }  
8010496f:	83 c4 10             	add    $0x10,%esp
80104972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104975:	c9                   	leave  
80104976:	c3                   	ret    
80104977:	66 90                	xchg   %ax,%ax
80104979:	66 90                	xchg   %ax,%ax
8010497b:	66 90                	xchg   %ax,%ax
8010497d:	66 90                	xchg   %ax,%ax
8010497f:	90                   	nop

80104980 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010498a:	68 1c 80 10 80       	push   $0x8010801c
8010498f:	8d 43 04             	lea    0x4(%ebx),%eax
80104992:	50                   	push   %eax
80104993:	e8 18 01 00 00       	call   80104ab0 <initlock>
  lk->name = name;
80104998:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010499b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b1:	c9                   	leave  
801049b2:	c3                   	ret    
801049b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ce:	56                   	push   %esi
801049cf:	e8 1c 02 00 00       	call   80104bf0 <acquire>
  while (lk->locked) {
801049d4:	8b 13                	mov    (%ebx),%edx
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	85 d2                	test   %edx,%edx
801049db:	74 16                	je     801049f3 <acquiresleep+0x33>
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049e0:	83 ec 08             	sub    $0x8,%esp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	e8 d6 f9 ff ff       	call   801043c0 <sleep>
  while (lk->locked) {
801049ea:	8b 03                	mov    (%ebx),%eax
801049ec:	83 c4 10             	add    $0x10,%esp
801049ef:	85 c0                	test   %eax,%eax
801049f1:	75 ed                	jne    801049e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049f9:	e8 22 f4 ff ff       	call   80103e20 <myproc>
801049fe:	8b 40 10             	mov    0x10(%eax),%eax
80104a01:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a04:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a0a:	5b                   	pop    %ebx
80104a0b:	5e                   	pop    %esi
80104a0c:	5d                   	pop    %ebp
  release(&lk->lk);
80104a0d:	e9 9e 02 00 00       	jmp    80104cb0 <release>
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a2e:	56                   	push   %esi
80104a2f:	e8 bc 01 00 00       	call   80104bf0 <acquire>
  lk->locked = 0;
80104a34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a3a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a41:	89 1c 24             	mov    %ebx,(%esp)
80104a44:	e8 37 fb ff ff       	call   80104580 <wakeup>
  release(&lk->lk);
80104a49:	89 75 08             	mov    %esi,0x8(%ebp)
80104a4c:	83 c4 10             	add    $0x10,%esp
}
80104a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a52:	5b                   	pop    %ebx
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
  release(&lk->lk);
80104a55:	e9 56 02 00 00       	jmp    80104cb0 <release>
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
80104a65:	53                   	push   %ebx
80104a66:	31 ff                	xor    %edi,%edi
80104a68:	83 ec 18             	sub    $0x18,%esp
80104a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a6e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a71:	56                   	push   %esi
80104a72:	e8 79 01 00 00       	call   80104bf0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a77:	8b 03                	mov    (%ebx),%eax
80104a79:	83 c4 10             	add    $0x10,%esp
80104a7c:	85 c0                	test   %eax,%eax
80104a7e:	74 13                	je     80104a93 <holdingsleep+0x33>
80104a80:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a83:	e8 98 f3 ff ff       	call   80103e20 <myproc>
80104a88:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a8b:	0f 94 c0             	sete   %al
80104a8e:	0f b6 c0             	movzbl %al,%eax
80104a91:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104a93:	83 ec 0c             	sub    $0xc,%esp
80104a96:	56                   	push   %esi
80104a97:	e8 14 02 00 00       	call   80104cb0 <release>
  return r;
}
80104a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a9f:	89 f8                	mov    %edi,%eax
80104aa1:	5b                   	pop    %ebx
80104aa2:	5e                   	pop    %esi
80104aa3:	5f                   	pop    %edi
80104aa4:	5d                   	pop    %ebp
80104aa5:	c3                   	ret    
80104aa6:	66 90                	xchg   %ax,%ax
80104aa8:	66 90                	xchg   %ax,%ax
80104aaa:	66 90                	xchg   %ax,%ax
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104abf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ac2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret    
80104acb:	90                   	nop
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ad0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ad1:	31 d2                	xor    %edx,%edx
{
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ad6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104adc:	83 e8 08             	sub    $0x8,%eax
80104adf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ae0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ae6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aec:	77 1a                	ja     80104b08 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aee:	8b 58 04             	mov    0x4(%eax),%ebx
80104af1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104af4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104af7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104af9:	83 fa 0a             	cmp    $0xa,%edx
80104afc:	75 e2                	jne    80104ae0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104afe:	5b                   	pop    %ebx
80104aff:	5d                   	pop    %ebp
80104b00:	c3                   	ret    
80104b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b08:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b0b:	83 c1 28             	add    $0x28,%ecx
80104b0e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b16:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b19:	39 c1                	cmp    %eax,%ecx
80104b1b:	75 f3                	jne    80104b10 <getcallerpcs+0x40>
}
80104b1d:	5b                   	pop    %ebx
80104b1e:	5d                   	pop    %ebp
80104b1f:	c3                   	ret    

80104b20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
80104b27:	9c                   	pushf  
80104b28:	5b                   	pop    %ebx
  asm volatile("cli");
80104b29:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b2a:	e8 51 f2 ff ff       	call   80103d80 <mycpu>
80104b2f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b35:	85 c0                	test   %eax,%eax
80104b37:	75 11                	jne    80104b4a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b39:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b3f:	e8 3c f2 ff ff       	call   80103d80 <mycpu>
80104b44:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b4a:	e8 31 f2 ff ff       	call   80103d80 <mycpu>
80104b4f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b56:	83 c4 04             	add    $0x4,%esp
80104b59:	5b                   	pop    %ebx
80104b5a:	5d                   	pop    %ebp
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <popcli>:

void
popcli(void)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b66:	9c                   	pushf  
80104b67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b68:	f6 c4 02             	test   $0x2,%ah
80104b6b:	75 35                	jne    80104ba2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b6d:	e8 0e f2 ff ff       	call   80103d80 <mycpu>
80104b72:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b79:	78 34                	js     80104baf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b7b:	e8 00 f2 ff ff       	call   80103d80 <mycpu>
80104b80:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b86:	85 d2                	test   %edx,%edx
80104b88:	74 06                	je     80104b90 <popcli+0x30>
    sti();
}
80104b8a:	c9                   	leave  
80104b8b:	c3                   	ret    
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b90:	e8 eb f1 ff ff       	call   80103d80 <mycpu>
80104b95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	74 eb                	je     80104b8a <popcli+0x2a>
  asm volatile("sti");
80104b9f:	fb                   	sti    
}
80104ba0:	c9                   	leave  
80104ba1:	c3                   	ret    
    panic("popcli - interruptible");
80104ba2:	83 ec 0c             	sub    $0xc,%esp
80104ba5:	68 27 80 10 80       	push   $0x80108027
80104baa:	e8 e1 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104baf:	83 ec 0c             	sub    $0xc,%esp
80104bb2:	68 3e 80 10 80       	push   $0x8010803e
80104bb7:	e8 d4 b7 ff ff       	call   80100390 <panic>
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <holding>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 75 08             	mov    0x8(%ebp),%esi
80104bc8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104bca:	e8 51 ff ff ff       	call   80104b20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bcf:	8b 06                	mov    (%esi),%eax
80104bd1:	85 c0                	test   %eax,%eax
80104bd3:	74 10                	je     80104be5 <holding+0x25>
80104bd5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104bd8:	e8 a3 f1 ff ff       	call   80103d80 <mycpu>
80104bdd:	39 c3                	cmp    %eax,%ebx
80104bdf:	0f 94 c3             	sete   %bl
80104be2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104be5:	e8 76 ff ff ff       	call   80104b60 <popcli>
}
80104bea:	89 d8                	mov    %ebx,%eax
80104bec:	5b                   	pop    %ebx
80104bed:	5e                   	pop    %esi
80104bee:	5d                   	pop    %ebp
80104bef:	c3                   	ret    

80104bf0 <acquire>:
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104bf5:	e8 26 ff ff ff       	call   80104b20 <pushcli>
  if(holding(lk))
80104bfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bfd:	83 ec 0c             	sub    $0xc,%esp
80104c00:	53                   	push   %ebx
80104c01:	e8 ba ff ff ff       	call   80104bc0 <holding>
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	85 c0                	test   %eax,%eax
80104c0b:	0f 85 83 00 00 00    	jne    80104c94 <acquire+0xa4>
80104c11:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104c13:	ba 01 00 00 00       	mov    $0x1,%edx
80104c18:	eb 09                	jmp    80104c23 <acquire+0x33>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c23:	89 d0                	mov    %edx,%eax
80104c25:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c28:	85 c0                	test   %eax,%eax
80104c2a:	75 f4                	jne    80104c20 <acquire+0x30>
  __sync_synchronize();
80104c2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c34:	e8 47 f1 ff ff       	call   80103d80 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c39:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104c3c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c3f:	89 e8                	mov    %ebp,%eax
80104c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c48:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104c4e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c54:	77 1a                	ja     80104c70 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c56:	8b 48 04             	mov    0x4(%eax),%ecx
80104c59:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104c5c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c5f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c61:	83 fe 0a             	cmp    $0xa,%esi
80104c64:	75 e2                	jne    80104c48 <acquire+0x58>
}
80104c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c69:	5b                   	pop    %ebx
80104c6a:	5e                   	pop    %esi
80104c6b:	5d                   	pop    %ebp
80104c6c:	c3                   	ret    
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
80104c70:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c73:	83 c2 28             	add    $0x28,%edx
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c86:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c89:	39 d0                	cmp    %edx,%eax
80104c8b:	75 f3                	jne    80104c80 <acquire+0x90>
}
80104c8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c90:	5b                   	pop    %ebx
80104c91:	5e                   	pop    %esi
80104c92:	5d                   	pop    %ebp
80104c93:	c3                   	ret    
    panic("acquire");
80104c94:	83 ec 0c             	sub    $0xc,%esp
80104c97:	68 45 80 10 80       	push   $0x80108045
80104c9c:	e8 ef b6 ff ff       	call   80100390 <panic>
80104ca1:	eb 0d                	jmp    80104cb0 <release>
80104ca3:	90                   	nop
80104ca4:	90                   	nop
80104ca5:	90                   	nop
80104ca6:	90                   	nop
80104ca7:	90                   	nop
80104ca8:	90                   	nop
80104ca9:	90                   	nop
80104caa:	90                   	nop
80104cab:	90                   	nop
80104cac:	90                   	nop
80104cad:	90                   	nop
80104cae:	90                   	nop
80104caf:	90                   	nop

80104cb0 <release>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 10             	sub    $0x10,%esp
80104cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104cba:	53                   	push   %ebx
80104cbb:	e8 00 ff ff ff       	call   80104bc0 <holding>
80104cc0:	83 c4 10             	add    $0x10,%esp
80104cc3:	85 c0                	test   %eax,%eax
80104cc5:	74 22                	je     80104ce9 <release+0x39>
  lk->pcs[0] = 0;
80104cc7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104cd5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cda:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce3:	c9                   	leave  
  popcli();
80104ce4:	e9 77 fe ff ff       	jmp    80104b60 <popcli>
    panic("release");
80104ce9:	83 ec 0c             	sub    $0xc,%esp
80104cec:	68 4d 80 10 80       	push   $0x8010804d
80104cf1:	e8 9a b6 ff ff       	call   80100390 <panic>
80104cf6:	66 90                	xchg   %ax,%ax
80104cf8:	66 90                	xchg   %ax,%ax
80104cfa:	66 90                	xchg   %ax,%ax
80104cfc:	66 90                	xchg   %ax,%ax
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	57                   	push   %edi
80104d04:	53                   	push   %ebx
80104d05:	8b 55 08             	mov    0x8(%ebp),%edx
80104d08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d0b:	f6 c2 03             	test   $0x3,%dl
80104d0e:	75 05                	jne    80104d15 <memset+0x15>
80104d10:	f6 c1 03             	test   $0x3,%cl
80104d13:	74 13                	je     80104d28 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104d15:	89 d7                	mov    %edx,%edi
80104d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1a:	fc                   	cld    
80104d1b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d1d:	5b                   	pop    %ebx
80104d1e:	89 d0                	mov    %edx,%eax
80104d20:	5f                   	pop    %edi
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	90                   	nop
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104d28:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d2c:	c1 e9 02             	shr    $0x2,%ecx
80104d2f:	89 f8                	mov    %edi,%eax
80104d31:	89 fb                	mov    %edi,%ebx
80104d33:	c1 e0 18             	shl    $0x18,%eax
80104d36:	c1 e3 10             	shl    $0x10,%ebx
80104d39:	09 d8                	or     %ebx,%eax
80104d3b:	09 f8                	or     %edi,%eax
80104d3d:	c1 e7 08             	shl    $0x8,%edi
80104d40:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d42:	89 d7                	mov    %edx,%edi
80104d44:	fc                   	cld    
80104d45:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d47:	5b                   	pop    %ebx
80104d48:	89 d0                	mov    %edx,%eax
80104d4a:	5f                   	pop    %edi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi

80104d50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
80104d55:	53                   	push   %ebx
80104d56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d59:	8b 75 08             	mov    0x8(%ebp),%esi
80104d5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d5f:	85 db                	test   %ebx,%ebx
80104d61:	74 29                	je     80104d8c <memcmp+0x3c>
    if(*s1 != *s2)
80104d63:	0f b6 16             	movzbl (%esi),%edx
80104d66:	0f b6 0f             	movzbl (%edi),%ecx
80104d69:	38 d1                	cmp    %dl,%cl
80104d6b:	75 2b                	jne    80104d98 <memcmp+0x48>
80104d6d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d72:	eb 14                	jmp    80104d88 <memcmp+0x38>
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d78:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d7c:	83 c0 01             	add    $0x1,%eax
80104d7f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d84:	38 ca                	cmp    %cl,%dl
80104d86:	75 10                	jne    80104d98 <memcmp+0x48>
  while(n-- > 0){
80104d88:	39 d8                	cmp    %ebx,%eax
80104d8a:	75 ec                	jne    80104d78 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d8c:	5b                   	pop    %ebx
  return 0;
80104d8d:	31 c0                	xor    %eax,%eax
}
80104d8f:	5e                   	pop    %esi
80104d90:	5f                   	pop    %edi
80104d91:	5d                   	pop    %ebp
80104d92:	c3                   	ret    
80104d93:	90                   	nop
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d98:	0f b6 c2             	movzbl %dl,%eax
}
80104d9b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d9c:	29 c8                	sub    %ecx,%eax
}
80104d9e:	5e                   	pop    %esi
80104d9f:	5f                   	pop    %edi
80104da0:	5d                   	pop    %ebp
80104da1:	c3                   	ret    
80104da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	8b 45 08             	mov    0x8(%ebp),%eax
80104db8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104dbb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dbe:	39 c3                	cmp    %eax,%ebx
80104dc0:	73 26                	jae    80104de8 <memmove+0x38>
80104dc2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104dc5:	39 c8                	cmp    %ecx,%eax
80104dc7:	73 1f                	jae    80104de8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104dc9:	85 f6                	test   %esi,%esi
80104dcb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104dce:	74 0f                	je     80104ddf <memmove+0x2f>
      *--d = *--s;
80104dd0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104dd4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104dd7:	83 ea 01             	sub    $0x1,%edx
80104dda:	83 fa ff             	cmp    $0xffffffff,%edx
80104ddd:	75 f1                	jne    80104dd0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ddf:	5b                   	pop    %ebx
80104de0:	5e                   	pop    %esi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	90                   	nop
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104de8:	31 d2                	xor    %edx,%edx
80104dea:	85 f6                	test   %esi,%esi
80104dec:	74 f1                	je     80104ddf <memmove+0x2f>
80104dee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104df0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104df4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104df7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104dfa:	39 d6                	cmp    %edx,%esi
80104dfc:	75 f2                	jne    80104df0 <memmove+0x40>
}
80104dfe:	5b                   	pop    %ebx
80104dff:	5e                   	pop    %esi
80104e00:	5d                   	pop    %ebp
80104e01:	c3                   	ret    
80104e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e13:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104e14:	eb 9a                	jmp    80104db0 <memmove>
80104e16:	8d 76 00             	lea    0x0(%esi),%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	8b 7d 10             	mov    0x10(%ebp),%edi
80104e28:	53                   	push   %ebx
80104e29:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e2f:	85 ff                	test   %edi,%edi
80104e31:	74 2f                	je     80104e62 <strncmp+0x42>
80104e33:	0f b6 01             	movzbl (%ecx),%eax
80104e36:	0f b6 1e             	movzbl (%esi),%ebx
80104e39:	84 c0                	test   %al,%al
80104e3b:	74 37                	je     80104e74 <strncmp+0x54>
80104e3d:	38 c3                	cmp    %al,%bl
80104e3f:	75 33                	jne    80104e74 <strncmp+0x54>
80104e41:	01 f7                	add    %esi,%edi
80104e43:	eb 13                	jmp    80104e58 <strncmp+0x38>
80104e45:	8d 76 00             	lea    0x0(%esi),%esi
80104e48:	0f b6 01             	movzbl (%ecx),%eax
80104e4b:	84 c0                	test   %al,%al
80104e4d:	74 21                	je     80104e70 <strncmp+0x50>
80104e4f:	0f b6 1a             	movzbl (%edx),%ebx
80104e52:	89 d6                	mov    %edx,%esi
80104e54:	38 d8                	cmp    %bl,%al
80104e56:	75 1c                	jne    80104e74 <strncmp+0x54>
    n--, p++, q++;
80104e58:	8d 56 01             	lea    0x1(%esi),%edx
80104e5b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e5e:	39 fa                	cmp    %edi,%edx
80104e60:	75 e6                	jne    80104e48 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e62:	5b                   	pop    %ebx
    return 0;
80104e63:	31 c0                	xor    %eax,%eax
}
80104e65:	5e                   	pop    %esi
80104e66:	5f                   	pop    %edi
80104e67:	5d                   	pop    %ebp
80104e68:	c3                   	ret    
80104e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e70:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e74:	29 d8                	sub    %ebx,%eax
}
80104e76:	5b                   	pop    %ebx
80104e77:	5e                   	pop    %esi
80104e78:	5f                   	pop    %edi
80104e79:	5d                   	pop    %ebp
80104e7a:	c3                   	ret    
80104e7b:	90                   	nop
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	8b 45 08             	mov    0x8(%ebp),%eax
80104e88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e8e:	89 c2                	mov    %eax,%edx
80104e90:	eb 19                	jmp    80104eab <strncpy+0x2b>
80104e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e98:	83 c3 01             	add    $0x1,%ebx
80104e9b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e9f:	83 c2 01             	add    $0x1,%edx
80104ea2:	84 c9                	test   %cl,%cl
80104ea4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ea7:	74 09                	je     80104eb2 <strncpy+0x32>
80104ea9:	89 f1                	mov    %esi,%ecx
80104eab:	85 c9                	test   %ecx,%ecx
80104ead:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104eb0:	7f e6                	jg     80104e98 <strncpy+0x18>
    ;
  while(n-- > 0)
80104eb2:	31 c9                	xor    %ecx,%ecx
80104eb4:	85 f6                	test   %esi,%esi
80104eb6:	7e 17                	jle    80104ecf <strncpy+0x4f>
80104eb8:	90                   	nop
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ec0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ec4:	89 f3                	mov    %esi,%ebx
80104ec6:	83 c1 01             	add    $0x1,%ecx
80104ec9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104ecb:	85 db                	test   %ebx,%ebx
80104ecd:	7f f1                	jg     80104ec0 <strncpy+0x40>
  return os;
}
80104ecf:	5b                   	pop    %ebx
80104ed0:	5e                   	pop    %esi
80104ed1:	5d                   	pop    %ebp
80104ed2:	c3                   	ret    
80104ed3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104eee:	85 c9                	test   %ecx,%ecx
80104ef0:	7e 26                	jle    80104f18 <safestrcpy+0x38>
80104ef2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ef6:	89 c1                	mov    %eax,%ecx
80104ef8:	eb 17                	jmp    80104f11 <safestrcpy+0x31>
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f00:	83 c2 01             	add    $0x1,%edx
80104f03:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f07:	83 c1 01             	add    $0x1,%ecx
80104f0a:	84 db                	test   %bl,%bl
80104f0c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f0f:	74 04                	je     80104f15 <safestrcpy+0x35>
80104f11:	39 f2                	cmp    %esi,%edx
80104f13:	75 eb                	jne    80104f00 <safestrcpy+0x20>
    ;
  *s = 0;
80104f15:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f18:	5b                   	pop    %ebx
80104f19:	5e                   	pop    %esi
80104f1a:	5d                   	pop    %ebp
80104f1b:	c3                   	ret    
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f20 <strlen>:

int
strlen(const char *s)
{
80104f20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f21:	31 c0                	xor    %eax,%eax
{
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f28:	80 3a 00             	cmpb   $0x0,(%edx)
80104f2b:	74 0c                	je     80104f39 <strlen+0x19>
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	83 c0 01             	add    $0x1,%eax
80104f33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f37:	75 f7                	jne    80104f30 <strlen+0x10>
    ;
  return n;
}
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    

80104f3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f43:	55                   	push   %ebp
  pushl %ebx
80104f44:	53                   	push   %ebx
  pushl %esi
80104f45:	56                   	push   %esi
  pushl %edi
80104f46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f49:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f4b:	5f                   	pop    %edi
  popl %esi
80104f4c:	5e                   	pop    %esi
  popl %ebx
80104f4d:	5b                   	pop    %ebx
  popl %ebp
80104f4e:	5d                   	pop    %ebp
  ret
80104f4f:	c3                   	ret    

80104f50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f5a:	e8 c1 ee ff ff       	call   80103e20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f5f:	8b 00                	mov    (%eax),%eax
80104f61:	39 d8                	cmp    %ebx,%eax
80104f63:	76 1b                	jbe    80104f80 <fetchint+0x30>
80104f65:	8d 53 04             	lea    0x4(%ebx),%edx
80104f68:	39 d0                	cmp    %edx,%eax
80104f6a:	72 14                	jb     80104f80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f6f:	8b 13                	mov    (%ebx),%edx
80104f71:	89 10                	mov    %edx,(%eax)
  return 0;
80104f73:	31 c0                	xor    %eax,%eax
}
80104f75:	83 c4 04             	add    $0x4,%esp
80104f78:	5b                   	pop    %ebx
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    
80104f7b:	90                   	nop
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f85:	eb ee                	jmp    80104f75 <fetchint+0x25>
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	53                   	push   %ebx
80104f94:	83 ec 04             	sub    $0x4,%esp
80104f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f9a:	e8 81 ee ff ff       	call   80103e20 <myproc>

  if(addr >= curproc->sz)
80104f9f:	39 18                	cmp    %ebx,(%eax)
80104fa1:	76 29                	jbe    80104fcc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104fa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104fa6:	89 da                	mov    %ebx,%edx
80104fa8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104faa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104fac:	39 c3                	cmp    %eax,%ebx
80104fae:	73 1c                	jae    80104fcc <fetchstr+0x3c>
    if(*s == 0)
80104fb0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104fb3:	75 10                	jne    80104fc5 <fetchstr+0x35>
80104fb5:	eb 39                	jmp    80104ff0 <fetchstr+0x60>
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fc0:	80 3a 00             	cmpb   $0x0,(%edx)
80104fc3:	74 1b                	je     80104fe0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104fc5:	83 c2 01             	add    $0x1,%edx
80104fc8:	39 d0                	cmp    %edx,%eax
80104fca:	77 f4                	ja     80104fc0 <fetchstr+0x30>
    return -1;
80104fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104fd1:	83 c4 04             	add    $0x4,%esp
80104fd4:	5b                   	pop    %ebx
80104fd5:	5d                   	pop    %ebp
80104fd6:	c3                   	ret    
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fe0:	83 c4 04             	add    $0x4,%esp
80104fe3:	89 d0                	mov    %edx,%eax
80104fe5:	29 d8                	sub    %ebx,%eax
80104fe7:	5b                   	pop    %ebx
80104fe8:	5d                   	pop    %ebp
80104fe9:	c3                   	ret    
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104ff0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104ff2:	eb dd                	jmp    80104fd1 <fetchstr+0x41>
80104ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105000 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105005:	e8 16 ee ff ff       	call   80103e20 <myproc>
8010500a:	8b 40 18             	mov    0x18(%eax),%eax
8010500d:	8b 55 08             	mov    0x8(%ebp),%edx
80105010:	8b 40 44             	mov    0x44(%eax),%eax
80105013:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105016:	e8 05 ee ff ff       	call   80103e20 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010501b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010501d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105020:	39 c6                	cmp    %eax,%esi
80105022:	73 1c                	jae    80105040 <argint+0x40>
80105024:	8d 53 08             	lea    0x8(%ebx),%edx
80105027:	39 d0                	cmp    %edx,%eax
80105029:	72 15                	jb     80105040 <argint+0x40>
  *ip = *(int*)(addr);
8010502b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502e:	8b 53 04             	mov    0x4(%ebx),%edx
80105031:	89 10                	mov    %edx,(%eax)
  return 0;
80105033:	31 c0                	xor    %eax,%eax
}
80105035:	5b                   	pop    %ebx
80105036:	5e                   	pop    %esi
80105037:	5d                   	pop    %ebp
80105038:	c3                   	ret    
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105045:	eb ee                	jmp    80105035 <argint+0x35>
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
80105055:	83 ec 10             	sub    $0x10,%esp
80105058:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010505b:	e8 c0 ed ff ff       	call   80103e20 <myproc>
80105060:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105062:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105065:	83 ec 08             	sub    $0x8,%esp
80105068:	50                   	push   %eax
80105069:	ff 75 08             	pushl  0x8(%ebp)
8010506c:	e8 8f ff ff ff       	call   80105000 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105071:	83 c4 10             	add    $0x10,%esp
80105074:	85 c0                	test   %eax,%eax
80105076:	78 28                	js     801050a0 <argptr+0x50>
80105078:	85 db                	test   %ebx,%ebx
8010507a:	78 24                	js     801050a0 <argptr+0x50>
8010507c:	8b 16                	mov    (%esi),%edx
8010507e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105081:	39 c2                	cmp    %eax,%edx
80105083:	76 1b                	jbe    801050a0 <argptr+0x50>
80105085:	01 c3                	add    %eax,%ebx
80105087:	39 da                	cmp    %ebx,%edx
80105089:	72 15                	jb     801050a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010508b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010508e:	89 02                	mov    %eax,(%edx)
  return 0;
80105090:	31 c0                	xor    %eax,%eax
}
80105092:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105095:	5b                   	pop    %ebx
80105096:	5e                   	pop    %esi
80105097:	5d                   	pop    %ebp
80105098:	c3                   	ret    
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb eb                	jmp    80105092 <argptr+0x42>
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050b9:	50                   	push   %eax
801050ba:	ff 75 08             	pushl  0x8(%ebp)
801050bd:	e8 3e ff ff ff       	call   80105000 <argint>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 17                	js     801050e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050c9:	83 ec 08             	sub    $0x8,%esp
801050cc:	ff 75 0c             	pushl  0xc(%ebp)
801050cf:	ff 75 f4             	pushl  -0xc(%ebp)
801050d2:	e8 b9 fe ff ff       	call   80104f90 <fetchstr>
801050d7:	83 c4 10             	add    $0x10,%esp
}
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050f0 <syscall>:
[SYS_sleep_time] sys_sleep_time,
};

void
syscall(void)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	53                   	push   %ebx
801050f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050f7:	e8 24 ed ff ff       	call   80103e20 <myproc>
801050fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050fe:	8b 40 18             	mov    0x18(%eax),%eax
80105101:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105104:	8d 50 ff             	lea    -0x1(%eax),%edx
80105107:	83 fa 19             	cmp    $0x19,%edx
8010510a:	77 1c                	ja     80105128 <syscall+0x38>
8010510c:	8b 14 85 80 80 10 80 	mov    -0x7fef7f80(,%eax,4),%edx
80105113:	85 d2                	test   %edx,%edx
80105115:	74 11                	je     80105128 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105117:	ff d2                	call   *%edx
80105119:	8b 53 18             	mov    0x18(%ebx),%edx
8010511c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010511f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105122:	c9                   	leave  
80105123:	c3                   	ret    
80105124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105128:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105129:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010512c:	50                   	push   %eax
8010512d:	ff 73 10             	pushl  0x10(%ebx)
80105130:	68 55 80 10 80       	push   $0x80108055
80105135:	e8 26 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010513a:	8b 43 18             	mov    0x18(%ebx),%eax
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105147:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010514a:	c9                   	leave  
8010514b:	c3                   	ret    
8010514c:	66 90                	xchg   %ax,%ax
8010514e:	66 90                	xchg   %ax,%ax

80105150 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
80105155:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105156:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105159:	83 ec 34             	sub    $0x34,%esp
8010515c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010515f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105162:	56                   	push   %esi
80105163:	50                   	push   %eax
{
80105164:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105167:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010516a:	e8 c1 d3 ff ff       	call   80102530 <nameiparent>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	85 c0                	test   %eax,%eax
80105174:	0f 84 46 01 00 00    	je     801052c0 <create+0x170>
    return 0;
  ilock(dp);
8010517a:	83 ec 0c             	sub    $0xc,%esp
8010517d:	89 c3                	mov    %eax,%ebx
8010517f:	50                   	push   %eax
80105180:	e8 2b cb ff ff       	call   80101cb0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105185:	83 c4 0c             	add    $0xc,%esp
80105188:	6a 00                	push   $0x0
8010518a:	56                   	push   %esi
8010518b:	53                   	push   %ebx
8010518c:	e8 4f d0 ff ff       	call   801021e0 <dirlookup>
80105191:	83 c4 10             	add    $0x10,%esp
80105194:	85 c0                	test   %eax,%eax
80105196:	89 c7                	mov    %eax,%edi
80105198:	74 36                	je     801051d0 <create+0x80>
    iunlockput(dp);
8010519a:	83 ec 0c             	sub    $0xc,%esp
8010519d:	53                   	push   %ebx
8010519e:	e8 9d cd ff ff       	call   80101f40 <iunlockput>
    ilock(ip);
801051a3:	89 3c 24             	mov    %edi,(%esp)
801051a6:	e8 05 cb ff ff       	call   80101cb0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051ab:	83 c4 10             	add    $0x10,%esp
801051ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051b3:	0f 85 97 00 00 00    	jne    80105250 <create+0x100>
801051b9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801051be:	0f 85 8c 00 00 00    	jne    80105250 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c7:	89 f8                	mov    %edi,%eax
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5f                   	pop    %edi
801051cc:	5d                   	pop    %ebp
801051cd:	c3                   	ret    
801051ce:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
801051d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801051d4:	83 ec 08             	sub    $0x8,%esp
801051d7:	50                   	push   %eax
801051d8:	ff 33                	pushl  (%ebx)
801051da:	e8 61 c9 ff ff       	call   80101b40 <ialloc>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	85 c0                	test   %eax,%eax
801051e4:	89 c7                	mov    %eax,%edi
801051e6:	0f 84 e8 00 00 00    	je     801052d4 <create+0x184>
  ilock(ip);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	50                   	push   %eax
801051f0:	e8 bb ca ff ff       	call   80101cb0 <ilock>
  ip->major = major;
801051f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051f9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801051fd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105201:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105205:	b8 01 00 00 00       	mov    $0x1,%eax
8010520a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010520e:	89 3c 24             	mov    %edi,(%esp)
80105211:	e8 ea c9 ff ff       	call   80101c00 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010521e:	74 50                	je     80105270 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105220:	83 ec 04             	sub    $0x4,%esp
80105223:	ff 77 04             	pushl  0x4(%edi)
80105226:	56                   	push   %esi
80105227:	53                   	push   %ebx
80105228:	e8 23 d2 ff ff       	call   80102450 <dirlink>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	0f 88 8f 00 00 00    	js     801052c7 <create+0x177>
  iunlockput(dp);
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	53                   	push   %ebx
8010523c:	e8 ff cc ff ff       	call   80101f40 <iunlockput>
  return ip;
80105241:	83 c4 10             	add    $0x10,%esp
}
80105244:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105247:	89 f8                	mov    %edi,%eax
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5f                   	pop    %edi
8010524c:	5d                   	pop    %ebp
8010524d:	c3                   	ret    
8010524e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	57                   	push   %edi
    return 0;
80105254:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105256:	e8 e5 cc ff ff       	call   80101f40 <iunlockput>
    return 0;
8010525b:	83 c4 10             	add    $0x10,%esp
}
8010525e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105261:	89 f8                	mov    %edi,%eax
80105263:	5b                   	pop    %ebx
80105264:	5e                   	pop    %esi
80105265:	5f                   	pop    %edi
80105266:	5d                   	pop    %ebp
80105267:	c3                   	ret    
80105268:	90                   	nop
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105270:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105275:	83 ec 0c             	sub    $0xc,%esp
80105278:	53                   	push   %ebx
80105279:	e8 82 c9 ff ff       	call   80101c00 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010527e:	83 c4 0c             	add    $0xc,%esp
80105281:	ff 77 04             	pushl  0x4(%edi)
80105284:	68 08 81 10 80       	push   $0x80108108
80105289:	57                   	push   %edi
8010528a:	e8 c1 d1 ff ff       	call   80102450 <dirlink>
8010528f:	83 c4 10             	add    $0x10,%esp
80105292:	85 c0                	test   %eax,%eax
80105294:	78 1c                	js     801052b2 <create+0x162>
80105296:	83 ec 04             	sub    $0x4,%esp
80105299:	ff 73 04             	pushl  0x4(%ebx)
8010529c:	68 07 81 10 80       	push   $0x80108107
801052a1:	57                   	push   %edi
801052a2:	e8 a9 d1 ff ff       	call   80102450 <dirlink>
801052a7:	83 c4 10             	add    $0x10,%esp
801052aa:	85 c0                	test   %eax,%eax
801052ac:	0f 89 6e ff ff ff    	jns    80105220 <create+0xd0>
      panic("create dots");
801052b2:	83 ec 0c             	sub    $0xc,%esp
801052b5:	68 fb 80 10 80       	push   $0x801080fb
801052ba:	e8 d1 b0 ff ff       	call   80100390 <panic>
801052bf:	90                   	nop
    return 0;
801052c0:	31 ff                	xor    %edi,%edi
801052c2:	e9 fd fe ff ff       	jmp    801051c4 <create+0x74>
    panic("create: dirlink");
801052c7:	83 ec 0c             	sub    $0xc,%esp
801052ca:	68 0a 81 10 80       	push   $0x8010810a
801052cf:	e8 bc b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	68 ec 80 10 80       	push   $0x801080ec
801052dc:	e8 af b0 ff ff       	call   80100390 <panic>
801052e1:	eb 0d                	jmp    801052f0 <argfd.constprop.0>
801052e3:	90                   	nop
801052e4:	90                   	nop
801052e5:	90                   	nop
801052e6:	90                   	nop
801052e7:	90                   	nop
801052e8:	90                   	nop
801052e9:	90                   	nop
801052ea:	90                   	nop
801052eb:	90                   	nop
801052ec:	90                   	nop
801052ed:	90                   	nop
801052ee:	90                   	nop
801052ef:	90                   	nop

801052f0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801052f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801052fa:	89 d6                	mov    %edx,%esi
801052fc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052ff:	50                   	push   %eax
80105300:	6a 00                	push   $0x0
80105302:	e8 f9 fc ff ff       	call   80105000 <argint>
80105307:	83 c4 10             	add    $0x10,%esp
8010530a:	85 c0                	test   %eax,%eax
8010530c:	78 2a                	js     80105338 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010530e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105312:	77 24                	ja     80105338 <argfd.constprop.0+0x48>
80105314:	e8 07 eb ff ff       	call   80103e20 <myproc>
80105319:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010531c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105320:	85 c0                	test   %eax,%eax
80105322:	74 14                	je     80105338 <argfd.constprop.0+0x48>
  if(pfd)
80105324:	85 db                	test   %ebx,%ebx
80105326:	74 02                	je     8010532a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105328:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010532a:	89 06                	mov    %eax,(%esi)
  return 0;
8010532c:	31 c0                	xor    %eax,%eax
}
8010532e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105331:	5b                   	pop    %ebx
80105332:	5e                   	pop    %esi
80105333:	5d                   	pop    %ebp
80105334:	c3                   	ret    
80105335:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533d:	eb ef                	jmp    8010532e <argfd.constprop.0+0x3e>
8010533f:	90                   	nop

80105340 <sys_dup>:
{
80105340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105341:	31 c0                	xor    %eax,%eax
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	56                   	push   %esi
80105346:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105347:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010534a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010534d:	e8 9e ff ff ff       	call   801052f0 <argfd.constprop.0>
80105352:	85 c0                	test   %eax,%eax
80105354:	78 42                	js     80105398 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105356:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105359:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010535b:	e8 c0 ea ff ff       	call   80103e20 <myproc>
80105360:	eb 0e                	jmp    80105370 <sys_dup+0x30>
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105368:	83 c3 01             	add    $0x1,%ebx
8010536b:	83 fb 10             	cmp    $0x10,%ebx
8010536e:	74 28                	je     80105398 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105370:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105374:	85 d2                	test   %edx,%edx
80105376:	75 f0                	jne    80105368 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105378:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	ff 75 f4             	pushl  -0xc(%ebp)
80105382:	e8 99 c0 ff ff       	call   80101420 <filedup>
  return fd;
80105387:	83 c4 10             	add    $0x10,%esp
}
8010538a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010538d:	89 d8                	mov    %ebx,%eax
8010538f:	5b                   	pop    %ebx
80105390:	5e                   	pop    %esi
80105391:	5d                   	pop    %ebp
80105392:	c3                   	ret    
80105393:	90                   	nop
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105398:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010539b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053a0:	89 d8                	mov    %ebx,%eax
801053a2:	5b                   	pop    %ebx
801053a3:	5e                   	pop    %esi
801053a4:	5d                   	pop    %ebp
801053a5:	c3                   	ret    
801053a6:	8d 76 00             	lea    0x0(%esi),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_read>:
{
801053b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b1:	31 c0                	xor    %eax,%eax
{
801053b3:	89 e5                	mov    %esp,%ebp
801053b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053bb:	e8 30 ff ff ff       	call   801052f0 <argfd.constprop.0>
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 4c                	js     80105410 <sys_read+0x60>
801053c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	50                   	push   %eax
801053cb:	6a 02                	push   $0x2
801053cd:	e8 2e fc ff ff       	call   80105000 <argint>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	85 c0                	test   %eax,%eax
801053d7:	78 37                	js     80105410 <sys_read+0x60>
801053d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053dc:	83 ec 04             	sub    $0x4,%esp
801053df:	ff 75 f0             	pushl  -0x10(%ebp)
801053e2:	50                   	push   %eax
801053e3:	6a 01                	push   $0x1
801053e5:	e8 66 fc ff ff       	call   80105050 <argptr>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	85 c0                	test   %eax,%eax
801053ef:	78 1f                	js     80105410 <sys_read+0x60>
  return fileread(f, p, n);
801053f1:	83 ec 04             	sub    $0x4,%esp
801053f4:	ff 75 f0             	pushl  -0x10(%ebp)
801053f7:	ff 75 f4             	pushl  -0xc(%ebp)
801053fa:	ff 75 ec             	pushl  -0x14(%ebp)
801053fd:	e8 8e c1 ff ff       	call   80101590 <fileread>
80105402:	83 c4 10             	add    $0x10,%esp
}
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105415:	c9                   	leave  
80105416:	c3                   	ret    
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <sys_write>:
{
80105420:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105421:	31 c0                	xor    %eax,%eax
{
80105423:	89 e5                	mov    %esp,%ebp
80105425:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105428:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010542b:	e8 c0 fe ff ff       	call   801052f0 <argfd.constprop.0>
80105430:	85 c0                	test   %eax,%eax
80105432:	78 4c                	js     80105480 <sys_write+0x60>
80105434:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105437:	83 ec 08             	sub    $0x8,%esp
8010543a:	50                   	push   %eax
8010543b:	6a 02                	push   $0x2
8010543d:	e8 be fb ff ff       	call   80105000 <argint>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	78 37                	js     80105480 <sys_write+0x60>
80105449:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544c:	83 ec 04             	sub    $0x4,%esp
8010544f:	ff 75 f0             	pushl  -0x10(%ebp)
80105452:	50                   	push   %eax
80105453:	6a 01                	push   $0x1
80105455:	e8 f6 fb ff ff       	call   80105050 <argptr>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	78 1f                	js     80105480 <sys_write+0x60>
  return filewrite(f, p, n);
80105461:	83 ec 04             	sub    $0x4,%esp
80105464:	ff 75 f0             	pushl  -0x10(%ebp)
80105467:	ff 75 f4             	pushl  -0xc(%ebp)
8010546a:	ff 75 ec             	pushl  -0x14(%ebp)
8010546d:	e8 ae c1 ff ff       	call   80101620 <filewrite>
80105472:	83 c4 10             	add    $0x10,%esp
}
80105475:	c9                   	leave  
80105476:	c3                   	ret    
80105477:	89 f6                	mov    %esi,%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105485:	c9                   	leave  
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_close>:
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105496:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105499:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010549c:	e8 4f fe ff ff       	call   801052f0 <argfd.constprop.0>
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 2b                	js     801054d0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801054a5:	e8 76 e9 ff ff       	call   80103e20 <myproc>
801054aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054ad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801054b7:	00 
  fileclose(f);
801054b8:	ff 75 f4             	pushl  -0xc(%ebp)
801054bb:	e8 b0 bf ff ff       	call   80101470 <fileclose>
  return 0;
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	31 c0                	xor    %eax,%eax
}
801054c5:	c9                   	leave  
801054c6:	c3                   	ret    
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <sys_fstat>:
{
801054e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e1:	31 c0                	xor    %eax,%eax
{
801054e3:	89 e5                	mov    %esp,%ebp
801054e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054eb:	e8 00 fe ff ff       	call   801052f0 <argfd.constprop.0>
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 2c                	js     80105520 <sys_fstat+0x40>
801054f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f7:	83 ec 04             	sub    $0x4,%esp
801054fa:	6a 14                	push   $0x14
801054fc:	50                   	push   %eax
801054fd:	6a 01                	push   $0x1
801054ff:	e8 4c fb ff ff       	call   80105050 <argptr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	78 15                	js     80105520 <sys_fstat+0x40>
  return filestat(f, st);
8010550b:	83 ec 08             	sub    $0x8,%esp
8010550e:	ff 75 f4             	pushl  -0xc(%ebp)
80105511:	ff 75 f0             	pushl  -0x10(%ebp)
80105514:	e8 27 c0 ff ff       	call   80101540 <filestat>
80105519:	83 c4 10             	add    $0x10,%esp
}
8010551c:	c9                   	leave  
8010551d:	c3                   	ret    
8010551e:	66 90                	xchg   %ax,%ax
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_link>:
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105536:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105539:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010553c:	50                   	push   %eax
8010553d:	6a 00                	push   $0x0
8010553f:	e8 6c fb ff ff       	call   801050b0 <argstr>
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	85 c0                	test   %eax,%eax
80105549:	0f 88 fb 00 00 00    	js     8010564a <sys_link+0x11a>
8010554f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105552:	83 ec 08             	sub    $0x8,%esp
80105555:	50                   	push   %eax
80105556:	6a 01                	push   $0x1
80105558:	e8 53 fb ff ff       	call   801050b0 <argstr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	0f 88 e2 00 00 00    	js     8010564a <sys_link+0x11a>
  begin_op();
80105568:	e8 63 dc ff ff       	call   801031d0 <begin_op>
  if((ip = namei(old)) == 0){
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	ff 75 d4             	pushl  -0x2c(%ebp)
80105573:	e8 98 cf ff ff       	call   80102510 <namei>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	85 c0                	test   %eax,%eax
8010557d:	89 c3                	mov    %eax,%ebx
8010557f:	0f 84 ea 00 00 00    	je     8010566f <sys_link+0x13f>
  ilock(ip);
80105585:	83 ec 0c             	sub    $0xc,%esp
80105588:	50                   	push   %eax
80105589:	e8 22 c7 ff ff       	call   80101cb0 <ilock>
  if(ip->type == T_DIR){
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105596:	0f 84 bb 00 00 00    	je     80105657 <sys_link+0x127>
  ip->nlink++;
8010559c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801055a1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801055a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055a7:	53                   	push   %ebx
801055a8:	e8 53 c6 ff ff       	call   80101c00 <iupdate>
  iunlock(ip);
801055ad:	89 1c 24             	mov    %ebx,(%esp)
801055b0:	e8 db c7 ff ff       	call   80101d90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055b5:	58                   	pop    %eax
801055b6:	5a                   	pop    %edx
801055b7:	57                   	push   %edi
801055b8:	ff 75 d0             	pushl  -0x30(%ebp)
801055bb:	e8 70 cf ff ff       	call   80102530 <nameiparent>
801055c0:	83 c4 10             	add    $0x10,%esp
801055c3:	85 c0                	test   %eax,%eax
801055c5:	89 c6                	mov    %eax,%esi
801055c7:	74 5b                	je     80105624 <sys_link+0xf4>
  ilock(dp);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	50                   	push   %eax
801055cd:	e8 de c6 ff ff       	call   80101cb0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	8b 03                	mov    (%ebx),%eax
801055d7:	39 06                	cmp    %eax,(%esi)
801055d9:	75 3d                	jne    80105618 <sys_link+0xe8>
801055db:	83 ec 04             	sub    $0x4,%esp
801055de:	ff 73 04             	pushl  0x4(%ebx)
801055e1:	57                   	push   %edi
801055e2:	56                   	push   %esi
801055e3:	e8 68 ce ff ff       	call   80102450 <dirlink>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	78 29                	js     80105618 <sys_link+0xe8>
  iunlockput(dp);
801055ef:	83 ec 0c             	sub    $0xc,%esp
801055f2:	56                   	push   %esi
801055f3:	e8 48 c9 ff ff       	call   80101f40 <iunlockput>
  iput(ip);
801055f8:	89 1c 24             	mov    %ebx,(%esp)
801055fb:	e8 e0 c7 ff ff       	call   80101de0 <iput>
  end_op();
80105600:	e8 3b dc ff ff       	call   80103240 <end_op>
  return 0;
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	31 c0                	xor    %eax,%eax
}
8010560a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010560d:	5b                   	pop    %ebx
8010560e:	5e                   	pop    %esi
8010560f:	5f                   	pop    %edi
80105610:	5d                   	pop    %ebp
80105611:	c3                   	ret    
80105612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	56                   	push   %esi
8010561c:	e8 1f c9 ff ff       	call   80101f40 <iunlockput>
    goto bad;
80105621:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105624:	83 ec 0c             	sub    $0xc,%esp
80105627:	53                   	push   %ebx
80105628:	e8 83 c6 ff ff       	call   80101cb0 <ilock>
  ip->nlink--;
8010562d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105632:	89 1c 24             	mov    %ebx,(%esp)
80105635:	e8 c6 c5 ff ff       	call   80101c00 <iupdate>
  iunlockput(ip);
8010563a:	89 1c 24             	mov    %ebx,(%esp)
8010563d:	e8 fe c8 ff ff       	call   80101f40 <iunlockput>
  end_op();
80105642:	e8 f9 db ff ff       	call   80103240 <end_op>
  return -1;
80105647:	83 c4 10             	add    $0x10,%esp
}
8010564a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010564d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105652:	5b                   	pop    %ebx
80105653:	5e                   	pop    %esi
80105654:	5f                   	pop    %edi
80105655:	5d                   	pop    %ebp
80105656:	c3                   	ret    
    iunlockput(ip);
80105657:	83 ec 0c             	sub    $0xc,%esp
8010565a:	53                   	push   %ebx
8010565b:	e8 e0 c8 ff ff       	call   80101f40 <iunlockput>
    end_op();
80105660:	e8 db db ff ff       	call   80103240 <end_op>
    return -1;
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566d:	eb 9b                	jmp    8010560a <sys_link+0xda>
    end_op();
8010566f:	e8 cc db ff ff       	call   80103240 <end_op>
    return -1;
80105674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105679:	eb 8f                	jmp    8010560a <sys_link+0xda>
8010567b:	90                   	nop
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_unlink>:
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
80105684:	56                   	push   %esi
80105685:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105686:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105689:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010568c:	50                   	push   %eax
8010568d:	6a 00                	push   $0x0
8010568f:	e8 1c fa ff ff       	call   801050b0 <argstr>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	85 c0                	test   %eax,%eax
80105699:	0f 88 77 01 00 00    	js     80105816 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010569f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801056a2:	e8 29 db ff ff       	call   801031d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056a7:	83 ec 08             	sub    $0x8,%esp
801056aa:	53                   	push   %ebx
801056ab:	ff 75 c0             	pushl  -0x40(%ebp)
801056ae:	e8 7d ce ff ff       	call   80102530 <nameiparent>
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	89 c6                	mov    %eax,%esi
801056ba:	0f 84 60 01 00 00    	je     80105820 <sys_unlink+0x1a0>
  ilock(dp);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	50                   	push   %eax
801056c4:	e8 e7 c5 ff ff       	call   80101cb0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056c9:	58                   	pop    %eax
801056ca:	5a                   	pop    %edx
801056cb:	68 08 81 10 80       	push   $0x80108108
801056d0:	53                   	push   %ebx
801056d1:	e8 ea ca ff ff       	call   801021c0 <namecmp>
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	85 c0                	test   %eax,%eax
801056db:	0f 84 03 01 00 00    	je     801057e4 <sys_unlink+0x164>
801056e1:	83 ec 08             	sub    $0x8,%esp
801056e4:	68 07 81 10 80       	push   $0x80108107
801056e9:	53                   	push   %ebx
801056ea:	e8 d1 ca ff ff       	call   801021c0 <namecmp>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	85 c0                	test   %eax,%eax
801056f4:	0f 84 ea 00 00 00    	je     801057e4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801056fa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056fd:	83 ec 04             	sub    $0x4,%esp
80105700:	50                   	push   %eax
80105701:	53                   	push   %ebx
80105702:	56                   	push   %esi
80105703:	e8 d8 ca ff ff       	call   801021e0 <dirlookup>
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	85 c0                	test   %eax,%eax
8010570d:	89 c3                	mov    %eax,%ebx
8010570f:	0f 84 cf 00 00 00    	je     801057e4 <sys_unlink+0x164>
  ilock(ip);
80105715:	83 ec 0c             	sub    $0xc,%esp
80105718:	50                   	push   %eax
80105719:	e8 92 c5 ff ff       	call   80101cb0 <ilock>
  if(ip->nlink < 1)
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105726:	0f 8e 10 01 00 00    	jle    8010583c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010572c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105731:	74 6d                	je     801057a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105733:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105736:	83 ec 04             	sub    $0x4,%esp
80105739:	6a 10                	push   $0x10
8010573b:	6a 00                	push   $0x0
8010573d:	50                   	push   %eax
8010573e:	e8 bd f5 ff ff       	call   80104d00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105743:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105746:	6a 10                	push   $0x10
80105748:	ff 75 c4             	pushl  -0x3c(%ebp)
8010574b:	50                   	push   %eax
8010574c:	56                   	push   %esi
8010574d:	e8 3e c9 ff ff       	call   80102090 <writei>
80105752:	83 c4 20             	add    $0x20,%esp
80105755:	83 f8 10             	cmp    $0x10,%eax
80105758:	0f 85 eb 00 00 00    	jne    80105849 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010575e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105763:	0f 84 97 00 00 00    	je     80105800 <sys_unlink+0x180>
  iunlockput(dp);
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	56                   	push   %esi
8010576d:	e8 ce c7 ff ff       	call   80101f40 <iunlockput>
  ip->nlink--;
80105772:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105777:	89 1c 24             	mov    %ebx,(%esp)
8010577a:	e8 81 c4 ff ff       	call   80101c00 <iupdate>
  iunlockput(ip);
8010577f:	89 1c 24             	mov    %ebx,(%esp)
80105782:	e8 b9 c7 ff ff       	call   80101f40 <iunlockput>
  end_op();
80105787:	e8 b4 da ff ff       	call   80103240 <end_op>
  return 0;
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	31 c0                	xor    %eax,%eax
}
80105791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105794:	5b                   	pop    %ebx
80105795:	5e                   	pop    %esi
80105796:	5f                   	pop    %edi
80105797:	5d                   	pop    %ebp
80105798:	c3                   	ret    
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057a4:	76 8d                	jbe    80105733 <sys_unlink+0xb3>
801057a6:	bf 20 00 00 00       	mov    $0x20,%edi
801057ab:	eb 0f                	jmp    801057bc <sys_unlink+0x13c>
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
801057b0:	83 c7 10             	add    $0x10,%edi
801057b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801057b6:	0f 83 77 ff ff ff    	jae    80105733 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057bf:	6a 10                	push   $0x10
801057c1:	57                   	push   %edi
801057c2:	50                   	push   %eax
801057c3:	53                   	push   %ebx
801057c4:	e8 c7 c7 ff ff       	call   80101f90 <readi>
801057c9:	83 c4 10             	add    $0x10,%esp
801057cc:	83 f8 10             	cmp    $0x10,%eax
801057cf:	75 5e                	jne    8010582f <sys_unlink+0x1af>
    if(de.inum != 0)
801057d1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057d6:	74 d8                	je     801057b0 <sys_unlink+0x130>
    iunlockput(ip);
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	53                   	push   %ebx
801057dc:	e8 5f c7 ff ff       	call   80101f40 <iunlockput>
    goto bad;
801057e1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	56                   	push   %esi
801057e8:	e8 53 c7 ff ff       	call   80101f40 <iunlockput>
  end_op();
801057ed:	e8 4e da ff ff       	call   80103240 <end_op>
  return -1;
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fa:	eb 95                	jmp    80105791 <sys_unlink+0x111>
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105800:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105805:	83 ec 0c             	sub    $0xc,%esp
80105808:	56                   	push   %esi
80105809:	e8 f2 c3 ff ff       	call   80101c00 <iupdate>
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	e9 53 ff ff ff       	jmp    80105769 <sys_unlink+0xe9>
    return -1;
80105816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581b:	e9 71 ff ff ff       	jmp    80105791 <sys_unlink+0x111>
    end_op();
80105820:	e8 1b da ff ff       	call   80103240 <end_op>
    return -1;
80105825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582a:	e9 62 ff ff ff       	jmp    80105791 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010582f:	83 ec 0c             	sub    $0xc,%esp
80105832:	68 2c 81 10 80       	push   $0x8010812c
80105837:	e8 54 ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	68 1a 81 10 80       	push   $0x8010811a
80105844:	e8 47 ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	68 3e 81 10 80       	push   $0x8010813e
80105851:	e8 3a ab ff ff       	call   80100390 <panic>
80105856:	8d 76 00             	lea    0x0(%esi),%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105860 <sys_open>:

int
sys_open(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105866:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105869:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010586c:	50                   	push   %eax
8010586d:	6a 00                	push   $0x0
8010586f:	e8 3c f8 ff ff       	call   801050b0 <argstr>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	0f 88 1d 01 00 00    	js     8010599c <sys_open+0x13c>
8010587f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105882:	83 ec 08             	sub    $0x8,%esp
80105885:	50                   	push   %eax
80105886:	6a 01                	push   $0x1
80105888:	e8 73 f7 ff ff       	call   80105000 <argint>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	0f 88 04 01 00 00    	js     8010599c <sys_open+0x13c>
    return -1;

  begin_op();
80105898:	e8 33 d9 ff ff       	call   801031d0 <begin_op>

  if(omode & O_CREATE){
8010589d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058a1:	0f 85 a9 00 00 00    	jne    80105950 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	ff 75 e0             	pushl  -0x20(%ebp)
801058ad:	e8 5e cc ff ff       	call   80102510 <namei>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	89 c6                	mov    %eax,%esi
801058b9:	0f 84 b2 00 00 00    	je     80105971 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801058bf:	83 ec 0c             	sub    $0xc,%esp
801058c2:	50                   	push   %eax
801058c3:	e8 e8 c3 ff ff       	call   80101cb0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058c8:	83 c4 10             	add    $0x10,%esp
801058cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058d0:	0f 84 aa 00 00 00    	je     80105980 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058d6:	e8 d5 ba ff ff       	call   801013b0 <filealloc>
801058db:	85 c0                	test   %eax,%eax
801058dd:	89 c7                	mov    %eax,%edi
801058df:	0f 84 a6 00 00 00    	je     8010598b <sys_open+0x12b>
  struct proc *curproc = myproc();
801058e5:	e8 36 e5 ff ff       	call   80103e20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ea:	31 db                	xor    %ebx,%ebx
801058ec:	eb 0e                	jmp    801058fc <sys_open+0x9c>
801058ee:	66 90                	xchg   %ax,%ax
801058f0:	83 c3 01             	add    $0x1,%ebx
801058f3:	83 fb 10             	cmp    $0x10,%ebx
801058f6:	0f 84 ac 00 00 00    	je     801059a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801058fc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105900:	85 d2                	test   %edx,%edx
80105902:	75 ec                	jne    801058f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105904:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105907:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010590b:	56                   	push   %esi
8010590c:	e8 7f c4 ff ff       	call   80101d90 <iunlock>
  end_op();
80105911:	e8 2a d9 ff ff       	call   80103240 <end_op>

  f->type = FD_INODE;
80105916:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010591c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010591f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105922:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105925:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010592c:	89 d0                	mov    %edx,%eax
8010592e:	f7 d0                	not    %eax
80105930:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105933:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105936:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105939:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010593d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105940:	89 d8                	mov    %ebx,%eax
80105942:	5b                   	pop    %ebx
80105943:	5e                   	pop    %esi
80105944:	5f                   	pop    %edi
80105945:	5d                   	pop    %ebp
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105956:	31 c9                	xor    %ecx,%ecx
80105958:	6a 00                	push   $0x0
8010595a:	ba 02 00 00 00       	mov    $0x2,%edx
8010595f:	e8 ec f7 ff ff       	call   80105150 <create>
    if(ip == 0){
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105969:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010596b:	0f 85 65 ff ff ff    	jne    801058d6 <sys_open+0x76>
      end_op();
80105971:	e8 ca d8 ff ff       	call   80103240 <end_op>
      return -1;
80105976:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010597b:	eb c0                	jmp    8010593d <sys_open+0xdd>
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105980:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105983:	85 c9                	test   %ecx,%ecx
80105985:	0f 84 4b ff ff ff    	je     801058d6 <sys_open+0x76>
    iunlockput(ip);
8010598b:	83 ec 0c             	sub    $0xc,%esp
8010598e:	56                   	push   %esi
8010598f:	e8 ac c5 ff ff       	call   80101f40 <iunlockput>
    end_op();
80105994:	e8 a7 d8 ff ff       	call   80103240 <end_op>
    return -1;
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a1:	eb 9a                	jmp    8010593d <sys_open+0xdd>
801059a3:	90                   	nop
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	57                   	push   %edi
801059ac:	e8 bf ba ff ff       	call   80101470 <fileclose>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	eb d5                	jmp    8010598b <sys_open+0x12b>
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059c6:	e8 05 d8 ff ff       	call   801031d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	50                   	push   %eax
801059d2:	6a 00                	push   $0x0
801059d4:	e8 d7 f6 ff ff       	call   801050b0 <argstr>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	85 c0                	test   %eax,%eax
801059de:	78 30                	js     80105a10 <sys_mkdir+0x50>
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e6:	31 c9                	xor    %ecx,%ecx
801059e8:	6a 00                	push   $0x0
801059ea:	ba 01 00 00 00       	mov    $0x1,%edx
801059ef:	e8 5c f7 ff ff       	call   80105150 <create>
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	85 c0                	test   %eax,%eax
801059f9:	74 15                	je     80105a10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059fb:	83 ec 0c             	sub    $0xc,%esp
801059fe:	50                   	push   %eax
801059ff:	e8 3c c5 ff ff       	call   80101f40 <iunlockput>
  end_op();
80105a04:	e8 37 d8 ff ff       	call   80103240 <end_op>
  return 0;
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	31 c0                	xor    %eax,%eax
}
80105a0e:	c9                   	leave  
80105a0f:	c3                   	ret    
    end_op();
80105a10:	e8 2b d8 ff ff       	call   80103240 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_mknod>:

int
sys_mknod(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a26:	e8 a5 d7 ff ff       	call   801031d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2e:	83 ec 08             	sub    $0x8,%esp
80105a31:	50                   	push   %eax
80105a32:	6a 00                	push   $0x0
80105a34:	e8 77 f6 ff ff       	call   801050b0 <argstr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	78 60                	js     80105aa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	50                   	push   %eax
80105a47:	6a 01                	push   $0x1
80105a49:	e8 b2 f5 ff ff       	call   80105000 <argint>
  if((argstr(0, &path)) < 0 ||
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	78 4b                	js     80105aa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	50                   	push   %eax
80105a5c:	6a 02                	push   $0x2
80105a5e:	e8 9d f5 ff ff       	call   80105000 <argint>
     argint(1, &major) < 0 ||
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 36                	js     80105aa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a6e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a71:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105a75:	ba 03 00 00 00       	mov    $0x3,%edx
80105a7a:	50                   	push   %eax
80105a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a7e:	e8 cd f6 ff ff       	call   80105150 <create>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	74 16                	je     80105aa0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	50                   	push   %eax
80105a8e:	e8 ad c4 ff ff       	call   80101f40 <iunlockput>
  end_op();
80105a93:	e8 a8 d7 ff ff       	call   80103240 <end_op>
  return 0;
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	31 c0                	xor    %eax,%eax
}
80105a9d:	c9                   	leave  
80105a9e:	c3                   	ret    
80105a9f:	90                   	nop
    end_op();
80105aa0:	e8 9b d7 ff ff       	call   80103240 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_chdir>:

int
sys_chdir(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ab8:	e8 63 e3 ff ff       	call   80103e20 <myproc>
80105abd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105abf:	e8 0c d7 ff ff       	call   801031d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac7:	83 ec 08             	sub    $0x8,%esp
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 de f5 ff ff       	call   801050b0 <argstr>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 77                	js     80105b50 <sys_chdir+0xa0>
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	ff 75 f4             	pushl  -0xc(%ebp)
80105adf:	e8 2c ca ff ff       	call   80102510 <namei>
80105ae4:	83 c4 10             	add    $0x10,%esp
80105ae7:	85 c0                	test   %eax,%eax
80105ae9:	89 c3                	mov    %eax,%ebx
80105aeb:	74 63                	je     80105b50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	50                   	push   %eax
80105af1:	e8 ba c1 ff ff       	call   80101cb0 <ilock>
  if(ip->type != T_DIR){
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105afe:	75 30                	jne    80105b30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	53                   	push   %ebx
80105b04:	e8 87 c2 ff ff       	call   80101d90 <iunlock>
  iput(curproc->cwd);
80105b09:	58                   	pop    %eax
80105b0a:	ff 76 68             	pushl  0x68(%esi)
80105b0d:	e8 ce c2 ff ff       	call   80101de0 <iput>
  end_op();
80105b12:	e8 29 d7 ff ff       	call   80103240 <end_op>
  curproc->cwd = ip;
80105b17:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	31 c0                	xor    %eax,%eax
}
80105b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b22:	5b                   	pop    %ebx
80105b23:	5e                   	pop    %esi
80105b24:	5d                   	pop    %ebp
80105b25:	c3                   	ret    
80105b26:	8d 76 00             	lea    0x0(%esi),%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 07 c4 ff ff       	call   80101f40 <iunlockput>
    end_op();
80105b39:	e8 02 d7 ff ff       	call   80103240 <end_op>
    return -1;
80105b3e:	83 c4 10             	add    $0x10,%esp
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b46:	eb d7                	jmp    80105b1f <sys_chdir+0x6f>
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b50:	e8 eb d6 ff ff       	call   80103240 <end_op>
    return -1;
80105b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5a:	eb c3                	jmp    80105b1f <sys_chdir+0x6f>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_exec>:

int
sys_exec(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b66:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 36 f5 ff ff       	call   801050b0 <argstr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	0f 88 87 00 00 00    	js     80105c0c <sys_exec+0xac>
80105b85:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b8b:	83 ec 08             	sub    $0x8,%esp
80105b8e:	50                   	push   %eax
80105b8f:	6a 01                	push   $0x1
80105b91:	e8 6a f4 ff ff       	call   80105000 <argint>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	78 6f                	js     80105c0c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b9d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ba3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ba6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ba8:	68 80 00 00 00       	push   $0x80
80105bad:	6a 00                	push   $0x0
80105baf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bb5:	50                   	push   %eax
80105bb6:	e8 45 f1 ff ff       	call   80104d00 <memset>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	eb 2c                	jmp    80105bec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105bc0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	74 56                	je     80105c20 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bd6:	52                   	push   %edx
80105bd7:	50                   	push   %eax
80105bd8:	e8 b3 f3 ff ff       	call   80104f90 <fetchstr>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	85 c0                	test   %eax,%eax
80105be2:	78 28                	js     80105c0c <sys_exec+0xac>
  for(i=0;; i++){
80105be4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105be7:	83 fb 20             	cmp    $0x20,%ebx
80105bea:	74 20                	je     80105c0c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bf2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105bf9:	83 ec 08             	sub    $0x8,%esp
80105bfc:	57                   	push   %edi
80105bfd:	01 f0                	add    %esi,%eax
80105bff:	50                   	push   %eax
80105c00:	e8 4b f3 ff ff       	call   80104f50 <fetchint>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	79 b4                	jns    80105bc0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c14:	5b                   	pop    %ebx
80105c15:	5e                   	pop    %esi
80105c16:	5f                   	pop    %edi
80105c17:	5d                   	pop    %ebp
80105c18:	c3                   	ret    
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c20:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c26:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c29:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c30:	00 00 00 00 
  return exec(path, argv);
80105c34:	50                   	push   %eax
80105c35:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c3b:	e8 00 b4 ff ff       	call   80101040 <exec>
80105c40:	83 c4 10             	add    $0x10,%esp
}
80105c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c46:	5b                   	pop    %ebx
80105c47:	5e                   	pop    %esi
80105c48:	5f                   	pop    %edi
80105c49:	5d                   	pop    %ebp
80105c4a:	c3                   	ret    
80105c4b:	90                   	nop
80105c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c50 <sys_pipe>:

int
sys_pipe(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c56:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c59:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c5c:	6a 08                	push   $0x8
80105c5e:	50                   	push   %eax
80105c5f:	6a 00                	push   $0x0
80105c61:	e8 ea f3 ff ff       	call   80105050 <argptr>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	0f 88 ae 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	50                   	push   %eax
80105c78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c7b:	50                   	push   %eax
80105c7c:	e8 ef db ff ff       	call   80103870 <pipealloc>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	85 c0                	test   %eax,%eax
80105c86:	0f 88 93 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c8c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c8f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c91:	e8 8a e1 ff ff       	call   80103e20 <myproc>
80105c96:	eb 10                	jmp    80105ca8 <sys_pipe+0x58>
80105c98:	90                   	nop
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ca0:	83 c3 01             	add    $0x1,%ebx
80105ca3:	83 fb 10             	cmp    $0x10,%ebx
80105ca6:	74 60                	je     80105d08 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105ca8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cac:	85 f6                	test   %esi,%esi
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105cb0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cb3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cba:	e8 61 e1 ff ff       	call   80103e20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cbf:	31 d2                	xor    %edx,%edx
80105cc1:	eb 0d                	jmp    80105cd0 <sys_pipe+0x80>
80105cc3:	90                   	nop
80105cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cc8:	83 c2 01             	add    $0x1,%edx
80105ccb:	83 fa 10             	cmp    $0x10,%edx
80105cce:	74 28                	je     80105cf8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105cd0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cd4:	85 c9                	test   %ecx,%ecx
80105cd6:	75 f0                	jne    80105cc8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105cd8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cdf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ce4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ce7:	31 c0                	xor    %eax,%eax
}
80105ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cec:	5b                   	pop    %ebx
80105ced:	5e                   	pop    %esi
80105cee:	5f                   	pop    %edi
80105cef:	5d                   	pop    %ebp
80105cf0:	c3                   	ret    
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105cf8:	e8 23 e1 ff ff       	call   80103e20 <myproc>
80105cfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d04:	00 
80105d05:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d0e:	e8 5d b7 ff ff       	call   80101470 <fileclose>
    fileclose(wf);
80105d13:	58                   	pop    %eax
80105d14:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d17:	e8 54 b7 ff ff       	call   80101470 <fileclose>
    return -1;
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d24:	eb c3                	jmp    80105ce9 <sys_pipe+0x99>
80105d26:	66 90                	xchg   %ax,%ax
80105d28:	66 90                	xchg   %ax,%ax
80105d2a:	66 90                	xchg   %ax,%ax
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d33:	5d                   	pop    %ebp
  return fork();
80105d34:	e9 87 e2 ff ff       	jmp    80103fc0 <fork>
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_exit>:

int
sys_exit(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d46:	e8 f5 e4 ff ff       	call   80104240 <exit>
  return 0;  // not reached
}
80105d4b:	31 c0                	xor    %eax,%eax
80105d4d:	c9                   	leave  
80105d4e:	c3                   	ret    
80105d4f:	90                   	nop

80105d50 <sys_wait>:

int
sys_wait(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d53:	5d                   	pop    %ebp
  return wait();
80105d54:	e9 27 e7 ff ff       	jmp    80104480 <wait>
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <sys_kill>:

int
sys_kill(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d69:	50                   	push   %eax
80105d6a:	6a 00                	push   $0x0
80105d6c:	e8 8f f2 ff ff       	call   80105000 <argint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 18                	js     80105d90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7e:	e8 5d e8 ff ff       	call   801045e0 <kill>
80105d83:	83 c4 10             	add    $0x10,%esp
}
80105d86:	c9                   	leave  
80105d87:	c3                   	ret    
80105d88:	90                   	nop
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_getpid>:

int
sys_getpid(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105da6:	e8 75 e0 ff ff       	call   80103e20 <myproc>
80105dab:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dae:	c9                   	leave  
80105daf:	c3                   	ret    

80105db0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105db4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105db7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dba:	50                   	push   %eax
80105dbb:	6a 00                	push   $0x0
80105dbd:	e8 3e f2 ff ff       	call   80105000 <argint>
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	78 27                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dc9:	e8 52 e0 ff ff       	call   80103e20 <myproc>
  if(growproc(n) < 0)
80105dce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105dd1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105dd3:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd6:	e8 65 e1 ff ff       	call   80103f40 <growproc>
80105ddb:	83 c4 10             	add    $0x10,%esp
80105dde:	85 c0                	test   %eax,%eax
80105de0:	78 0e                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105de2:	89 d8                	mov    %ebx,%eax
80105de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105de7:	c9                   	leave  
80105de8:	c3                   	ret    
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105df0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105df5:	eb eb                	jmp    80105de2 <sys_sbrk+0x32>
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <sys_sleep>:

int
sys_sleep(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e0a:	50                   	push   %eax
80105e0b:	6a 00                	push   $0x0
80105e0d:	e8 ee f1 ff ff       	call   80105000 <argint>
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	85 c0                	test   %eax,%eax
80105e17:	0f 88 8a 00 00 00    	js     80105ea7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	68 80 5d 11 80       	push   $0x80115d80
80105e25:	e8 c6 ed ff ff       	call   80104bf0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e2d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e30:	8b 1d c0 65 11 80    	mov    0x801165c0,%ebx
  while(ticks - ticks0 < n){
80105e36:	85 d2                	test   %edx,%edx
80105e38:	75 27                	jne    80105e61 <sys_sleep+0x61>
80105e3a:	eb 54                	jmp    80105e90 <sys_sleep+0x90>
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	68 80 5d 11 80       	push   $0x80115d80
80105e48:	68 c0 65 11 80       	push   $0x801165c0
80105e4d:	e8 6e e5 ff ff       	call   801043c0 <sleep>
  while(ticks - ticks0 < n){
80105e52:	a1 c0 65 11 80       	mov    0x801165c0,%eax
80105e57:	83 c4 10             	add    $0x10,%esp
80105e5a:	29 d8                	sub    %ebx,%eax
80105e5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e5f:	73 2f                	jae    80105e90 <sys_sleep+0x90>
    if(myproc()->killed){
80105e61:	e8 ba df ff ff       	call   80103e20 <myproc>
80105e66:	8b 40 24             	mov    0x24(%eax),%eax
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	74 d3                	je     80105e40 <sys_sleep+0x40>
      release(&tickslock);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	68 80 5d 11 80       	push   $0x80115d80
80105e75:	e8 36 ee ff ff       	call   80104cb0 <release>
      return -1;
80105e7a:	83 c4 10             	add    $0x10,%esp
80105e7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e85:	c9                   	leave  
80105e86:	c3                   	ret    
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 80 5d 11 80       	push   $0x80115d80
80105e98:	e8 13 ee ff ff       	call   80104cb0 <release>
  return 0;
80105e9d:	83 c4 10             	add    $0x10,%esp
80105ea0:	31 c0                	xor    %eax,%eax
}
80105ea2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    
    return -1;
80105ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eac:	eb f4                	jmp    80105ea2 <sys_sleep+0xa2>
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	53                   	push   %ebx
80105eb4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105eb7:	68 80 5d 11 80       	push   $0x80115d80
80105ebc:	e8 2f ed ff ff       	call   80104bf0 <acquire>
  xticks = ticks;
80105ec1:	8b 1d c0 65 11 80    	mov    0x801165c0,%ebx
  release(&tickslock);
80105ec7:	c7 04 24 80 5d 11 80 	movl   $0x80115d80,(%esp)
80105ece:	e8 dd ed ff ff       	call   80104cb0 <release>
  return xticks;
}
80105ed3:	89 d8                	mov    %ebx,%eax
80105ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ed8:	c9                   	leave  
80105ed9:	c3                   	ret    
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ee0 <sys_get_descendant>:

int sys_get_descendant(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 20             	sub    $0x20,%esp
  int parent_id;

  if(argint(0, &parent_id) < 0)
80105ee6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ee9:	50                   	push   %eax
80105eea:	6a 00                	push   $0x0
80105eec:	e8 0f f1 ff ff       	call   80105000 <argint>
80105ef1:	83 c4 10             	add    $0x10,%esp
80105ef4:	85 c0                	test   %eax,%eax
80105ef6:	78 18                	js     80105f10 <sys_get_descendant+0x30>
    return -1;
  show_descendant(parent_id);
80105ef8:	83 ec 0c             	sub    $0xc,%esp
80105efb:	ff 75 f4             	pushl  -0xc(%ebp)
80105efe:	e8 1d e8 ff ff       	call   80104720 <show_descendant>
  return 1;
80105f03:	83 c4 10             	add    $0x10,%esp
80105f06:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f0b:	c9                   	leave  
80105f0c:	c3                   	ret    
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f15:	c9                   	leave  
80105f16:	c3                   	ret    
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f20 <sys_get_ancestors>:

int sys_get_ancestors(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 20             	sub    $0x20,%esp
  int my_id;

  if(argint(0, &my_id) < 0)
80105f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f29:	50                   	push   %eax
80105f2a:	6a 00                	push   $0x0
80105f2c:	e8 cf f0 ff ff       	call   80105000 <argint>
80105f31:	83 c4 10             	add    $0x10,%esp
80105f34:	85 c0                	test   %eax,%eax
80105f36:	78 18                	js     80105f50 <sys_get_ancestors+0x30>
    return -1;
  show_ancestors(my_id);
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3e:	e8 6d e9 ff ff       	call   801048b0 <show_ancestors>
  return 1;
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f4b:	c9                   	leave  
80105f4c:	c3                   	ret    
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <sys_get_creation_time>:

int sys_get_creation_time(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->ctime;
80105f66:	e8 b5 de ff ff       	call   80103e20 <myproc>
80105f6b:	8b 40 7c             	mov    0x7c(%eax),%eax
}
80105f6e:	c9                   	leave  
80105f6f:	c3                   	ret    

80105f70 <sys_calc_perfect_square>:

int sys_calc_perfect_square(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	53                   	push   %ebx
80105f74:	83 ec 04             	sub    $0x4,%esp
  struct proc *curproc = myproc();
80105f77:	e8 a4 de ff ff       	call   80103e20 <myproc>
  int number = curproc->tf->edx;
80105f7c:	8b 40 18             	mov    0x18(%eax),%eax
80105f7f:	ba 01 00 00 00       	mov    $0x1,%edx
80105f84:	8b 58 14             	mov    0x14(%eax),%ebx

  int square = 1;
  for(int i = 1; i < number; i++)
  {
    if(i*i <= number)
80105f87:	b8 01 00 00 00       	mov    $0x1,%eax
80105f8c:	8d 4b fe             	lea    -0x2(%ebx),%ecx
80105f8f:	81 f9 fd ff ff 7f    	cmp    $0x7ffffffd,%ecx
80105f95:	76 14                	jbe    80105fab <sys_calc_perfect_square+0x3b>
80105f97:	eb 19                	jmp    80105fb2 <sys_calc_perfect_square+0x42>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fa0:	89 d1                	mov    %edx,%ecx
80105fa2:	0f af ca             	imul   %edx,%ecx
80105fa5:	39 d9                	cmp    %ebx,%ecx
80105fa7:	7f 09                	jg     80105fb2 <sys_calc_perfect_square+0x42>
80105fa9:	89 c8                	mov    %ecx,%eax
  for(int i = 1; i < number; i++)
80105fab:	83 c2 01             	add    $0x1,%edx
80105fae:	39 d3                	cmp    %edx,%ebx
80105fb0:	75 ee                	jne    80105fa0 <sys_calc_perfect_square+0x30>
    {
    return square;       
    }
  }
  return square;
}
80105fb2:	83 c4 04             	add    $0x4,%esp
80105fb5:	5b                   	pop    %ebx
80105fb6:	5d                   	pop    %ebp
80105fb7:	c3                   	ret    
80105fb8:	90                   	nop
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fc0 <sys_sleep_time>:

int sys_sleep_time(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	56                   	push   %esi
80105fc4:	53                   	push   %ebx
80105fc5:	83 ec 10             	sub    $0x10,%esp
  
  struct proc *curproc = myproc();
80105fc8:	e8 53 de ff ff       	call   80103e20 <myproc>
80105fcd:	89 c6                	mov    %eax,%esi
  int n = curproc->tf->edx;
80105fcf:	8b 40 18             	mov    0x18(%eax),%eax
  // int n;
  int ticks0 = 0;
  cprintf("my time bafor sleep: %d\n", ticks );
80105fd2:	83 ec 08             	sub    $0x8,%esp
  int n = curproc->tf->edx;
80105fd5:	8b 40 14             	mov    0x14(%eax),%eax
  cprintf("my time bafor sleep: %d\n", ticks );
80105fd8:	ff 35 c0 65 11 80    	pushl  0x801165c0
80105fde:	68 4d 81 10 80       	push   $0x8010814d
  int n = curproc->tf->edx;
80105fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cprintf("my time bafor sleep: %d\n", ticks );
80105fe6:	e8 75 a6 ff ff       	call   80100660 <cprintf>
  cprintf("my id bafor sleep: %d\n", curproc->pid );
80105feb:	58                   	pop    %eax
80105fec:	5a                   	pop    %edx
80105fed:	ff 76 10             	pushl  0x10(%esi)
80105ff0:	68 66 81 10 80       	push   $0x80108166
80105ff5:	e8 66 a6 ff ff       	call   80100660 <cprintf>
  if(argint(0, &n) < 0)
80105ffa:	59                   	pop    %ecx
80105ffb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ffe:	5b                   	pop    %ebx
80105fff:	50                   	push   %eax
80106000:	6a 00                	push   $0x0
80106002:	e8 f9 ef ff ff       	call   80105000 <argint>
80106007:	83 c4 10             	add    $0x10,%esp
8010600a:	85 c0                	test   %eax,%eax
8010600c:	78 6a                	js     80106078 <sys_sleep_time+0xb8>
    return -1;
  // acquire(&tickslock);

  while(ticks0 < n){
8010600e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80106011:	85 db                	test   %ebx,%ebx
80106013:	7e 2a                	jle    8010603f <sys_sleep_time+0x7f>
    if(curproc->killed){
80106015:	8b 5e 24             	mov    0x24(%esi),%ebx
80106018:	85 db                	test   %ebx,%ebx
8010601a:	74 0b                	je     80106027 <sys_sleep_time+0x67>
8010601c:	eb 5a                	jmp    80106078 <sys_sleep_time+0xb8>
8010601e:	66 90                	xchg   %ax,%ax
80106020:	8b 46 24             	mov    0x24(%esi),%eax
80106023:	85 c0                	test   %eax,%eax
80106025:	75 51                	jne    80106078 <sys_sleep_time+0xb8>
      // release(&tickslock);
      return -1;
    }
    sleep_process(&ticks);
80106027:	83 ec 0c             	sub    $0xc,%esp
    ticks0 ++;
8010602a:	83 c3 01             	add    $0x1,%ebx
    sleep_process(&ticks);
8010602d:	68 c0 65 11 80       	push   $0x801165c0
80106032:	e8 e9 e8 ff ff       	call   80104920 <sleep_process>
  while(ticks0 < n){
80106037:	83 c4 10             	add    $0x10,%esp
8010603a:	39 5d f4             	cmp    %ebx,-0xc(%ebp)
8010603d:	7f e1                	jg     80106020 <sys_sleep_time+0x60>
  }
  cprintf("my id after sleep: %d\n", myproc()->pid );
8010603f:	e8 dc dd ff ff       	call   80103e20 <myproc>
80106044:	83 ec 08             	sub    $0x8,%esp
80106047:	ff 70 10             	pushl  0x10(%eax)
8010604a:	68 7d 81 10 80       	push   $0x8010817d
8010604f:	e8 0c a6 ff ff       	call   80100660 <cprintf>
  cprintf("my time after sleep: %d\n", ticks );
80106054:	5a                   	pop    %edx
80106055:	59                   	pop    %ecx
80106056:	ff 35 c0 65 11 80    	pushl  0x801165c0
8010605c:	68 94 81 10 80       	push   $0x80108194
80106061:	e8 fa a5 ff ff       	call   80100660 <cprintf>
  // release(&tickslock);
  return 0;
80106066:	83 c4 10             	add    $0x10,%esp
}
80106069:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
8010606c:	31 c0                	xor    %eax,%eax
}
8010606e:	5b                   	pop    %ebx
8010606f:	5e                   	pop    %esi
80106070:	5d                   	pop    %ebp
80106071:	c3                   	ret    
80106072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106078:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010607b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106080:	5b                   	pop    %ebx
80106081:	5e                   	pop    %esi
80106082:	5d                   	pop    %ebp
80106083:	c3                   	ret    

80106084 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106084:	1e                   	push   %ds
  pushl %es
80106085:	06                   	push   %es
  pushl %fs
80106086:	0f a0                	push   %fs
  pushl %gs
80106088:	0f a8                	push   %gs
  pushal
8010608a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010608b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010608f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106091:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106093:	54                   	push   %esp
  call trap
80106094:	e8 c7 00 00 00       	call   80106160 <trap>
  addl $4, %esp
80106099:	83 c4 04             	add    $0x4,%esp

8010609c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010609c:	61                   	popa   
  popl %gs
8010609d:	0f a9                	pop    %gs
  popl %fs
8010609f:	0f a1                	pop    %fs
  popl %es
801060a1:	07                   	pop    %es
  popl %ds
801060a2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801060a3:	83 c4 08             	add    $0x8,%esp
  iret
801060a6:	cf                   	iret   
801060a7:	66 90                	xchg   %ax,%ax
801060a9:	66 90                	xchg   %ax,%ax
801060ab:	66 90                	xchg   %ax,%ax
801060ad:	66 90                	xchg   %ax,%ax
801060af:	90                   	nop

801060b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801060b1:	31 c0                	xor    %eax,%eax
{
801060b3:	89 e5                	mov    %esp,%ebp
801060b5:	83 ec 08             	sub    $0x8,%esp
801060b8:	90                   	nop
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060c0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801060c7:	c7 04 c5 c2 5d 11 80 	movl   $0x8e000008,-0x7feea23e(,%eax,8)
801060ce:	08 00 00 8e 
801060d2:	66 89 14 c5 c0 5d 11 	mov    %dx,-0x7feea240(,%eax,8)
801060d9:	80 
801060da:	c1 ea 10             	shr    $0x10,%edx
801060dd:	66 89 14 c5 c6 5d 11 	mov    %dx,-0x7feea23a(,%eax,8)
801060e4:	80 
  for(i = 0; i < 256; i++)
801060e5:	83 c0 01             	add    $0x1,%eax
801060e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801060ed:	75 d1                	jne    801060c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060ef:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801060f4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060f7:	c7 05 c2 5f 11 80 08 	movl   $0xef000008,0x80115fc2
801060fe:	00 00 ef 
  initlock(&tickslock, "time");
80106101:	68 ad 81 10 80       	push   $0x801081ad
80106106:	68 80 5d 11 80       	push   $0x80115d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010610b:	66 a3 c0 5f 11 80    	mov    %ax,0x80115fc0
80106111:	c1 e8 10             	shr    $0x10,%eax
80106114:	66 a3 c6 5f 11 80    	mov    %ax,0x80115fc6
  initlock(&tickslock, "time");
8010611a:	e8 91 e9 ff ff       	call   80104ab0 <initlock>
}
8010611f:	83 c4 10             	add    $0x10,%esp
80106122:	c9                   	leave  
80106123:	c3                   	ret    
80106124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010612a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106130 <idtinit>:

void
idtinit(void)
{
80106130:	55                   	push   %ebp
  pd[0] = size-1;
80106131:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106136:	89 e5                	mov    %esp,%ebp
80106138:	83 ec 10             	sub    $0x10,%esp
8010613b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010613f:	b8 c0 5d 11 80       	mov    $0x80115dc0,%eax
80106144:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106148:	c1 e8 10             	shr    $0x10,%eax
8010614b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010614f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106152:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106155:	c9                   	leave  
80106156:	c3                   	ret    
80106157:	89 f6                	mov    %esi,%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106160 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	57                   	push   %edi
80106164:	56                   	push   %esi
80106165:	53                   	push   %ebx
80106166:	83 ec 1c             	sub    $0x1c,%esp
80106169:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010616c:	8b 47 30             	mov    0x30(%edi),%eax
8010616f:	83 f8 40             	cmp    $0x40,%eax
80106172:	0f 84 f0 00 00 00    	je     80106268 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106178:	83 e8 20             	sub    $0x20,%eax
8010617b:	83 f8 1f             	cmp    $0x1f,%eax
8010617e:	77 10                	ja     80106190 <trap+0x30>
80106180:	ff 24 85 54 82 10 80 	jmp    *-0x7fef7dac(,%eax,4)
80106187:	89 f6                	mov    %esi,%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106190:	e8 8b dc ff ff       	call   80103e20 <myproc>
80106195:	85 c0                	test   %eax,%eax
80106197:	8b 5f 38             	mov    0x38(%edi),%ebx
8010619a:	0f 84 14 02 00 00    	je     801063b4 <trap+0x254>
801061a0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801061a4:	0f 84 0a 02 00 00    	je     801063b4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061aa:	0f 20 d1             	mov    %cr2,%ecx
801061ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061b0:	e8 4b dc ff ff       	call   80103e00 <cpuid>
801061b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801061b8:	8b 47 34             	mov    0x34(%edi),%eax
801061bb:	8b 77 30             	mov    0x30(%edi),%esi
801061be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801061c1:	e8 5a dc ff ff       	call   80103e20 <myproc>
801061c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061c9:	e8 52 dc ff ff       	call   80103e20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801061d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801061d4:	51                   	push   %ecx
801061d5:	53                   	push   %ebx
801061d6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801061d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061da:	ff 75 e4             	pushl  -0x1c(%ebp)
801061dd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801061de:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061e1:	52                   	push   %edx
801061e2:	ff 70 10             	pushl  0x10(%eax)
801061e5:	68 10 82 10 80       	push   $0x80108210
801061ea:	e8 71 a4 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801061ef:	83 c4 20             	add    $0x20,%esp
801061f2:	e8 29 dc ff ff       	call   80103e20 <myproc>
801061f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061fe:	e8 1d dc ff ff       	call   80103e20 <myproc>
80106203:	85 c0                	test   %eax,%eax
80106205:	74 1d                	je     80106224 <trap+0xc4>
80106207:	e8 14 dc ff ff       	call   80103e20 <myproc>
8010620c:	8b 50 24             	mov    0x24(%eax),%edx
8010620f:	85 d2                	test   %edx,%edx
80106211:	74 11                	je     80106224 <trap+0xc4>
80106213:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106217:	83 e0 03             	and    $0x3,%eax
8010621a:	66 83 f8 03          	cmp    $0x3,%ax
8010621e:	0f 84 4c 01 00 00    	je     80106370 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106224:	e8 f7 db ff ff       	call   80103e20 <myproc>
80106229:	85 c0                	test   %eax,%eax
8010622b:	74 0b                	je     80106238 <trap+0xd8>
8010622d:	e8 ee db ff ff       	call   80103e20 <myproc>
80106232:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106236:	74 68                	je     801062a0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106238:	e8 e3 db ff ff       	call   80103e20 <myproc>
8010623d:	85 c0                	test   %eax,%eax
8010623f:	74 19                	je     8010625a <trap+0xfa>
80106241:	e8 da db ff ff       	call   80103e20 <myproc>
80106246:	8b 40 24             	mov    0x24(%eax),%eax
80106249:	85 c0                	test   %eax,%eax
8010624b:	74 0d                	je     8010625a <trap+0xfa>
8010624d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106251:	83 e0 03             	and    $0x3,%eax
80106254:	66 83 f8 03          	cmp    $0x3,%ax
80106258:	74 37                	je     80106291 <trap+0x131>
    exit();
}
8010625a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010625d:	5b                   	pop    %ebx
8010625e:	5e                   	pop    %esi
8010625f:	5f                   	pop    %edi
80106260:	5d                   	pop    %ebp
80106261:	c3                   	ret    
80106262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106268:	e8 b3 db ff ff       	call   80103e20 <myproc>
8010626d:	8b 58 24             	mov    0x24(%eax),%ebx
80106270:	85 db                	test   %ebx,%ebx
80106272:	0f 85 e8 00 00 00    	jne    80106360 <trap+0x200>
    myproc()->tf = tf;
80106278:	e8 a3 db ff ff       	call   80103e20 <myproc>
8010627d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106280:	e8 6b ee ff ff       	call   801050f0 <syscall>
    if(myproc()->killed)
80106285:	e8 96 db ff ff       	call   80103e20 <myproc>
8010628a:	8b 48 24             	mov    0x24(%eax),%ecx
8010628d:	85 c9                	test   %ecx,%ecx
8010628f:	74 c9                	je     8010625a <trap+0xfa>
}
80106291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106294:	5b                   	pop    %ebx
80106295:	5e                   	pop    %esi
80106296:	5f                   	pop    %edi
80106297:	5d                   	pop    %ebp
      exit();
80106298:	e9 a3 df ff ff       	jmp    80104240 <exit>
8010629d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801062a0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801062a4:	75 92                	jne    80106238 <trap+0xd8>
    yield();
801062a6:	e8 c5 e0 ff ff       	call   80104370 <yield>
801062ab:	eb 8b                	jmp    80106238 <trap+0xd8>
801062ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801062b0:	e8 4b db ff ff       	call   80103e00 <cpuid>
801062b5:	85 c0                	test   %eax,%eax
801062b7:	0f 84 c3 00 00 00    	je     80106380 <trap+0x220>
    lapiceoi();
801062bd:	e8 be ca ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062c2:	e8 59 db ff ff       	call   80103e20 <myproc>
801062c7:	85 c0                	test   %eax,%eax
801062c9:	0f 85 38 ff ff ff    	jne    80106207 <trap+0xa7>
801062cf:	e9 50 ff ff ff       	jmp    80106224 <trap+0xc4>
801062d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801062d8:	e8 63 c9 ff ff       	call   80102c40 <kbdintr>
    lapiceoi();
801062dd:	e8 9e ca ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e2:	e8 39 db ff ff       	call   80103e20 <myproc>
801062e7:	85 c0                	test   %eax,%eax
801062e9:	0f 85 18 ff ff ff    	jne    80106207 <trap+0xa7>
801062ef:	e9 30 ff ff ff       	jmp    80106224 <trap+0xc4>
801062f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801062f8:	e8 53 02 00 00       	call   80106550 <uartintr>
    lapiceoi();
801062fd:	e8 7e ca ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106302:	e8 19 db ff ff       	call   80103e20 <myproc>
80106307:	85 c0                	test   %eax,%eax
80106309:	0f 85 f8 fe ff ff    	jne    80106207 <trap+0xa7>
8010630f:	e9 10 ff ff ff       	jmp    80106224 <trap+0xc4>
80106314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106318:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010631c:	8b 77 38             	mov    0x38(%edi),%esi
8010631f:	e8 dc da ff ff       	call   80103e00 <cpuid>
80106324:	56                   	push   %esi
80106325:	53                   	push   %ebx
80106326:	50                   	push   %eax
80106327:	68 b8 81 10 80       	push   $0x801081b8
8010632c:	e8 2f a3 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106331:	e8 4a ca ff ff       	call   80102d80 <lapiceoi>
    break;
80106336:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106339:	e8 e2 da ff ff       	call   80103e20 <myproc>
8010633e:	85 c0                	test   %eax,%eax
80106340:	0f 85 c1 fe ff ff    	jne    80106207 <trap+0xa7>
80106346:	e9 d9 fe ff ff       	jmp    80106224 <trap+0xc4>
8010634b:	90                   	nop
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106350:	e8 5b c3 ff ff       	call   801026b0 <ideintr>
80106355:	e9 63 ff ff ff       	jmp    801062bd <trap+0x15d>
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106360:	e8 db de ff ff       	call   80104240 <exit>
80106365:	e9 0e ff ff ff       	jmp    80106278 <trap+0x118>
8010636a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106370:	e8 cb de ff ff       	call   80104240 <exit>
80106375:	e9 aa fe ff ff       	jmp    80106224 <trap+0xc4>
8010637a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106380:	83 ec 0c             	sub    $0xc,%esp
80106383:	68 80 5d 11 80       	push   $0x80115d80
80106388:	e8 63 e8 ff ff       	call   80104bf0 <acquire>
      wakeup(&ticks);
8010638d:	c7 04 24 c0 65 11 80 	movl   $0x801165c0,(%esp)
      ticks++;
80106394:	83 05 c0 65 11 80 01 	addl   $0x1,0x801165c0
      wakeup(&ticks);
8010639b:	e8 e0 e1 ff ff       	call   80104580 <wakeup>
      release(&tickslock);
801063a0:	c7 04 24 80 5d 11 80 	movl   $0x80115d80,(%esp)
801063a7:	e8 04 e9 ff ff       	call   80104cb0 <release>
801063ac:	83 c4 10             	add    $0x10,%esp
801063af:	e9 09 ff ff ff       	jmp    801062bd <trap+0x15d>
801063b4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063b7:	e8 44 da ff ff       	call   80103e00 <cpuid>
801063bc:	83 ec 0c             	sub    $0xc,%esp
801063bf:	56                   	push   %esi
801063c0:	53                   	push   %ebx
801063c1:	50                   	push   %eax
801063c2:	ff 77 30             	pushl  0x30(%edi)
801063c5:	68 dc 81 10 80       	push   $0x801081dc
801063ca:	e8 91 a2 ff ff       	call   80100660 <cprintf>
      panic("trap");
801063cf:	83 c4 14             	add    $0x14,%esp
801063d2:	68 b2 81 10 80       	push   $0x801081b2
801063d7:	e8 b4 9f ff ff       	call   80100390 <panic>
801063dc:	66 90                	xchg   %ax,%ax
801063de:	66 90                	xchg   %ax,%ax

801063e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801063e0:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
{
801063e5:	55                   	push   %ebp
801063e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801063e8:	85 c0                	test   %eax,%eax
801063ea:	74 1c                	je     80106408 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063f2:	a8 01                	test   $0x1,%al
801063f4:	74 12                	je     80106408 <uartgetc+0x28>
801063f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063fc:	0f b6 c0             	movzbl %al,%eax
}
801063ff:	5d                   	pop    %ebp
80106400:	c3                   	ret    
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010640d:	5d                   	pop    %ebp
8010640e:	c3                   	ret    
8010640f:	90                   	nop

80106410 <uartputc.part.0>:
uartputc(int c)
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	56                   	push   %esi
80106415:	53                   	push   %ebx
80106416:	89 c7                	mov    %eax,%edi
80106418:	bb 80 00 00 00       	mov    $0x80,%ebx
8010641d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106422:	83 ec 0c             	sub    $0xc,%esp
80106425:	eb 1b                	jmp    80106442 <uartputc.part.0+0x32>
80106427:	89 f6                	mov    %esi,%esi
80106429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106430:	83 ec 0c             	sub    $0xc,%esp
80106433:	6a 0a                	push   $0xa
80106435:	e8 66 c9 ff ff       	call   80102da0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010643a:	83 c4 10             	add    $0x10,%esp
8010643d:	83 eb 01             	sub    $0x1,%ebx
80106440:	74 07                	je     80106449 <uartputc.part.0+0x39>
80106442:	89 f2                	mov    %esi,%edx
80106444:	ec                   	in     (%dx),%al
80106445:	a8 20                	test   $0x20,%al
80106447:	74 e7                	je     80106430 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106449:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010644e:	89 f8                	mov    %edi,%eax
80106450:	ee                   	out    %al,(%dx)
}
80106451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106454:	5b                   	pop    %ebx
80106455:	5e                   	pop    %esi
80106456:	5f                   	pop    %edi
80106457:	5d                   	pop    %ebp
80106458:	c3                   	ret    
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <uartinit>:
{
80106460:	55                   	push   %ebp
80106461:	31 c9                	xor    %ecx,%ecx
80106463:	89 c8                	mov    %ecx,%eax
80106465:	89 e5                	mov    %esp,%ebp
80106467:	57                   	push   %edi
80106468:	56                   	push   %esi
80106469:	53                   	push   %ebx
8010646a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010646f:	89 da                	mov    %ebx,%edx
80106471:	83 ec 0c             	sub    $0xc,%esp
80106474:	ee                   	out    %al,(%dx)
80106475:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010647a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010647f:	89 fa                	mov    %edi,%edx
80106481:	ee                   	out    %al,(%dx)
80106482:	b8 0c 00 00 00       	mov    $0xc,%eax
80106487:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648c:	ee                   	out    %al,(%dx)
8010648d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106492:	89 c8                	mov    %ecx,%eax
80106494:	89 f2                	mov    %esi,%edx
80106496:	ee                   	out    %al,(%dx)
80106497:	b8 03 00 00 00       	mov    $0x3,%eax
8010649c:	89 fa                	mov    %edi,%edx
8010649e:	ee                   	out    %al,(%dx)
8010649f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064a4:	89 c8                	mov    %ecx,%eax
801064a6:	ee                   	out    %al,(%dx)
801064a7:	b8 01 00 00 00       	mov    $0x1,%eax
801064ac:	89 f2                	mov    %esi,%edx
801064ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064b5:	3c ff                	cmp    $0xff,%al
801064b7:	74 5a                	je     80106513 <uartinit+0xb3>
  uart = 1;
801064b9:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
801064c0:	00 00 00 
801064c3:	89 da                	mov    %ebx,%edx
801064c5:	ec                   	in     (%dx),%al
801064c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064cb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064cc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801064cf:	bb d4 82 10 80       	mov    $0x801082d4,%ebx
  ioapicenable(IRQ_COM1, 0);
801064d4:	6a 00                	push   $0x0
801064d6:	6a 04                	push   $0x4
801064d8:	e8 23 c4 ff ff       	call   80102900 <ioapicenable>
801064dd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801064e0:	b8 78 00 00 00       	mov    $0x78,%eax
801064e5:	eb 13                	jmp    801064fa <uartinit+0x9a>
801064e7:	89 f6                	mov    %esi,%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801064f0:	83 c3 01             	add    $0x1,%ebx
801064f3:	0f be 03             	movsbl (%ebx),%eax
801064f6:	84 c0                	test   %al,%al
801064f8:	74 19                	je     80106513 <uartinit+0xb3>
  if(!uart)
801064fa:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
80106500:	85 d2                	test   %edx,%edx
80106502:	74 ec                	je     801064f0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106504:	83 c3 01             	add    $0x1,%ebx
80106507:	e8 04 ff ff ff       	call   80106410 <uartputc.part.0>
8010650c:	0f be 03             	movsbl (%ebx),%eax
8010650f:	84 c0                	test   %al,%al
80106511:	75 e7                	jne    801064fa <uartinit+0x9a>
}
80106513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106516:	5b                   	pop    %ebx
80106517:	5e                   	pop    %esi
80106518:	5f                   	pop    %edi
80106519:	5d                   	pop    %ebp
8010651a:	c3                   	ret    
8010651b:	90                   	nop
8010651c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106520 <uartputc>:
  if(!uart)
80106520:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
80106526:	55                   	push   %ebp
80106527:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106529:	85 d2                	test   %edx,%edx
{
8010652b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010652e:	74 10                	je     80106540 <uartputc+0x20>
}
80106530:	5d                   	pop    %ebp
80106531:	e9 da fe ff ff       	jmp    80106410 <uartputc.part.0>
80106536:	8d 76 00             	lea    0x0(%esi),%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106540:	5d                   	pop    %ebp
80106541:	c3                   	ret    
80106542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106550 <uartintr>:

void
uartintr(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106556:	68 e0 63 10 80       	push   $0x801063e0
8010655b:	e8 20 a4 ff ff       	call   80100980 <consoleintr>
}
80106560:	83 c4 10             	add    $0x10,%esp
80106563:	c9                   	leave  
80106564:	c3                   	ret    

80106565 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $0
80106567:	6a 00                	push   $0x0
  jmp alltraps
80106569:	e9 16 fb ff ff       	jmp    80106084 <alltraps>

8010656e <vector1>:
.globl vector1
vector1:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $1
80106570:	6a 01                	push   $0x1
  jmp alltraps
80106572:	e9 0d fb ff ff       	jmp    80106084 <alltraps>

80106577 <vector2>:
.globl vector2
vector2:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $2
80106579:	6a 02                	push   $0x2
  jmp alltraps
8010657b:	e9 04 fb ff ff       	jmp    80106084 <alltraps>

80106580 <vector3>:
.globl vector3
vector3:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $3
80106582:	6a 03                	push   $0x3
  jmp alltraps
80106584:	e9 fb fa ff ff       	jmp    80106084 <alltraps>

80106589 <vector4>:
.globl vector4
vector4:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $4
8010658b:	6a 04                	push   $0x4
  jmp alltraps
8010658d:	e9 f2 fa ff ff       	jmp    80106084 <alltraps>

80106592 <vector5>:
.globl vector5
vector5:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $5
80106594:	6a 05                	push   $0x5
  jmp alltraps
80106596:	e9 e9 fa ff ff       	jmp    80106084 <alltraps>

8010659b <vector6>:
.globl vector6
vector6:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $6
8010659d:	6a 06                	push   $0x6
  jmp alltraps
8010659f:	e9 e0 fa ff ff       	jmp    80106084 <alltraps>

801065a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $7
801065a6:	6a 07                	push   $0x7
  jmp alltraps
801065a8:	e9 d7 fa ff ff       	jmp    80106084 <alltraps>

801065ad <vector8>:
.globl vector8
vector8:
  pushl $8
801065ad:	6a 08                	push   $0x8
  jmp alltraps
801065af:	e9 d0 fa ff ff       	jmp    80106084 <alltraps>

801065b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $9
801065b6:	6a 09                	push   $0x9
  jmp alltraps
801065b8:	e9 c7 fa ff ff       	jmp    80106084 <alltraps>

801065bd <vector10>:
.globl vector10
vector10:
  pushl $10
801065bd:	6a 0a                	push   $0xa
  jmp alltraps
801065bf:	e9 c0 fa ff ff       	jmp    80106084 <alltraps>

801065c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801065c4:	6a 0b                	push   $0xb
  jmp alltraps
801065c6:	e9 b9 fa ff ff       	jmp    80106084 <alltraps>

801065cb <vector12>:
.globl vector12
vector12:
  pushl $12
801065cb:	6a 0c                	push   $0xc
  jmp alltraps
801065cd:	e9 b2 fa ff ff       	jmp    80106084 <alltraps>

801065d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801065d2:	6a 0d                	push   $0xd
  jmp alltraps
801065d4:	e9 ab fa ff ff       	jmp    80106084 <alltraps>

801065d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801065d9:	6a 0e                	push   $0xe
  jmp alltraps
801065db:	e9 a4 fa ff ff       	jmp    80106084 <alltraps>

801065e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $15
801065e2:	6a 0f                	push   $0xf
  jmp alltraps
801065e4:	e9 9b fa ff ff       	jmp    80106084 <alltraps>

801065e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $16
801065eb:	6a 10                	push   $0x10
  jmp alltraps
801065ed:	e9 92 fa ff ff       	jmp    80106084 <alltraps>

801065f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801065f2:	6a 11                	push   $0x11
  jmp alltraps
801065f4:	e9 8b fa ff ff       	jmp    80106084 <alltraps>

801065f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $18
801065fb:	6a 12                	push   $0x12
  jmp alltraps
801065fd:	e9 82 fa ff ff       	jmp    80106084 <alltraps>

80106602 <vector19>:
.globl vector19
vector19:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $19
80106604:	6a 13                	push   $0x13
  jmp alltraps
80106606:	e9 79 fa ff ff       	jmp    80106084 <alltraps>

8010660b <vector20>:
.globl vector20
vector20:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $20
8010660d:	6a 14                	push   $0x14
  jmp alltraps
8010660f:	e9 70 fa ff ff       	jmp    80106084 <alltraps>

80106614 <vector21>:
.globl vector21
vector21:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $21
80106616:	6a 15                	push   $0x15
  jmp alltraps
80106618:	e9 67 fa ff ff       	jmp    80106084 <alltraps>

8010661d <vector22>:
.globl vector22
vector22:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $22
8010661f:	6a 16                	push   $0x16
  jmp alltraps
80106621:	e9 5e fa ff ff       	jmp    80106084 <alltraps>

80106626 <vector23>:
.globl vector23
vector23:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $23
80106628:	6a 17                	push   $0x17
  jmp alltraps
8010662a:	e9 55 fa ff ff       	jmp    80106084 <alltraps>

8010662f <vector24>:
.globl vector24
vector24:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $24
80106631:	6a 18                	push   $0x18
  jmp alltraps
80106633:	e9 4c fa ff ff       	jmp    80106084 <alltraps>

80106638 <vector25>:
.globl vector25
vector25:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $25
8010663a:	6a 19                	push   $0x19
  jmp alltraps
8010663c:	e9 43 fa ff ff       	jmp    80106084 <alltraps>

80106641 <vector26>:
.globl vector26
vector26:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $26
80106643:	6a 1a                	push   $0x1a
  jmp alltraps
80106645:	e9 3a fa ff ff       	jmp    80106084 <alltraps>

8010664a <vector27>:
.globl vector27
vector27:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $27
8010664c:	6a 1b                	push   $0x1b
  jmp alltraps
8010664e:	e9 31 fa ff ff       	jmp    80106084 <alltraps>

80106653 <vector28>:
.globl vector28
vector28:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $28
80106655:	6a 1c                	push   $0x1c
  jmp alltraps
80106657:	e9 28 fa ff ff       	jmp    80106084 <alltraps>

8010665c <vector29>:
.globl vector29
vector29:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $29
8010665e:	6a 1d                	push   $0x1d
  jmp alltraps
80106660:	e9 1f fa ff ff       	jmp    80106084 <alltraps>

80106665 <vector30>:
.globl vector30
vector30:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $30
80106667:	6a 1e                	push   $0x1e
  jmp alltraps
80106669:	e9 16 fa ff ff       	jmp    80106084 <alltraps>

8010666e <vector31>:
.globl vector31
vector31:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $31
80106670:	6a 1f                	push   $0x1f
  jmp alltraps
80106672:	e9 0d fa ff ff       	jmp    80106084 <alltraps>

80106677 <vector32>:
.globl vector32
vector32:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $32
80106679:	6a 20                	push   $0x20
  jmp alltraps
8010667b:	e9 04 fa ff ff       	jmp    80106084 <alltraps>

80106680 <vector33>:
.globl vector33
vector33:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $33
80106682:	6a 21                	push   $0x21
  jmp alltraps
80106684:	e9 fb f9 ff ff       	jmp    80106084 <alltraps>

80106689 <vector34>:
.globl vector34
vector34:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $34
8010668b:	6a 22                	push   $0x22
  jmp alltraps
8010668d:	e9 f2 f9 ff ff       	jmp    80106084 <alltraps>

80106692 <vector35>:
.globl vector35
vector35:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $35
80106694:	6a 23                	push   $0x23
  jmp alltraps
80106696:	e9 e9 f9 ff ff       	jmp    80106084 <alltraps>

8010669b <vector36>:
.globl vector36
vector36:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $36
8010669d:	6a 24                	push   $0x24
  jmp alltraps
8010669f:	e9 e0 f9 ff ff       	jmp    80106084 <alltraps>

801066a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $37
801066a6:	6a 25                	push   $0x25
  jmp alltraps
801066a8:	e9 d7 f9 ff ff       	jmp    80106084 <alltraps>

801066ad <vector38>:
.globl vector38
vector38:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $38
801066af:	6a 26                	push   $0x26
  jmp alltraps
801066b1:	e9 ce f9 ff ff       	jmp    80106084 <alltraps>

801066b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $39
801066b8:	6a 27                	push   $0x27
  jmp alltraps
801066ba:	e9 c5 f9 ff ff       	jmp    80106084 <alltraps>

801066bf <vector40>:
.globl vector40
vector40:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $40
801066c1:	6a 28                	push   $0x28
  jmp alltraps
801066c3:	e9 bc f9 ff ff       	jmp    80106084 <alltraps>

801066c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $41
801066ca:	6a 29                	push   $0x29
  jmp alltraps
801066cc:	e9 b3 f9 ff ff       	jmp    80106084 <alltraps>

801066d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $42
801066d3:	6a 2a                	push   $0x2a
  jmp alltraps
801066d5:	e9 aa f9 ff ff       	jmp    80106084 <alltraps>

801066da <vector43>:
.globl vector43
vector43:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $43
801066dc:	6a 2b                	push   $0x2b
  jmp alltraps
801066de:	e9 a1 f9 ff ff       	jmp    80106084 <alltraps>

801066e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $44
801066e5:	6a 2c                	push   $0x2c
  jmp alltraps
801066e7:	e9 98 f9 ff ff       	jmp    80106084 <alltraps>

801066ec <vector45>:
.globl vector45
vector45:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $45
801066ee:	6a 2d                	push   $0x2d
  jmp alltraps
801066f0:	e9 8f f9 ff ff       	jmp    80106084 <alltraps>

801066f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $46
801066f7:	6a 2e                	push   $0x2e
  jmp alltraps
801066f9:	e9 86 f9 ff ff       	jmp    80106084 <alltraps>

801066fe <vector47>:
.globl vector47
vector47:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $47
80106700:	6a 2f                	push   $0x2f
  jmp alltraps
80106702:	e9 7d f9 ff ff       	jmp    80106084 <alltraps>

80106707 <vector48>:
.globl vector48
vector48:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $48
80106709:	6a 30                	push   $0x30
  jmp alltraps
8010670b:	e9 74 f9 ff ff       	jmp    80106084 <alltraps>

80106710 <vector49>:
.globl vector49
vector49:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $49
80106712:	6a 31                	push   $0x31
  jmp alltraps
80106714:	e9 6b f9 ff ff       	jmp    80106084 <alltraps>

80106719 <vector50>:
.globl vector50
vector50:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $50
8010671b:	6a 32                	push   $0x32
  jmp alltraps
8010671d:	e9 62 f9 ff ff       	jmp    80106084 <alltraps>

80106722 <vector51>:
.globl vector51
vector51:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $51
80106724:	6a 33                	push   $0x33
  jmp alltraps
80106726:	e9 59 f9 ff ff       	jmp    80106084 <alltraps>

8010672b <vector52>:
.globl vector52
vector52:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $52
8010672d:	6a 34                	push   $0x34
  jmp alltraps
8010672f:	e9 50 f9 ff ff       	jmp    80106084 <alltraps>

80106734 <vector53>:
.globl vector53
vector53:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $53
80106736:	6a 35                	push   $0x35
  jmp alltraps
80106738:	e9 47 f9 ff ff       	jmp    80106084 <alltraps>

8010673d <vector54>:
.globl vector54
vector54:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $54
8010673f:	6a 36                	push   $0x36
  jmp alltraps
80106741:	e9 3e f9 ff ff       	jmp    80106084 <alltraps>

80106746 <vector55>:
.globl vector55
vector55:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $55
80106748:	6a 37                	push   $0x37
  jmp alltraps
8010674a:	e9 35 f9 ff ff       	jmp    80106084 <alltraps>

8010674f <vector56>:
.globl vector56
vector56:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $56
80106751:	6a 38                	push   $0x38
  jmp alltraps
80106753:	e9 2c f9 ff ff       	jmp    80106084 <alltraps>

80106758 <vector57>:
.globl vector57
vector57:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $57
8010675a:	6a 39                	push   $0x39
  jmp alltraps
8010675c:	e9 23 f9 ff ff       	jmp    80106084 <alltraps>

80106761 <vector58>:
.globl vector58
vector58:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $58
80106763:	6a 3a                	push   $0x3a
  jmp alltraps
80106765:	e9 1a f9 ff ff       	jmp    80106084 <alltraps>

8010676a <vector59>:
.globl vector59
vector59:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $59
8010676c:	6a 3b                	push   $0x3b
  jmp alltraps
8010676e:	e9 11 f9 ff ff       	jmp    80106084 <alltraps>

80106773 <vector60>:
.globl vector60
vector60:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $60
80106775:	6a 3c                	push   $0x3c
  jmp alltraps
80106777:	e9 08 f9 ff ff       	jmp    80106084 <alltraps>

8010677c <vector61>:
.globl vector61
vector61:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $61
8010677e:	6a 3d                	push   $0x3d
  jmp alltraps
80106780:	e9 ff f8 ff ff       	jmp    80106084 <alltraps>

80106785 <vector62>:
.globl vector62
vector62:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $62
80106787:	6a 3e                	push   $0x3e
  jmp alltraps
80106789:	e9 f6 f8 ff ff       	jmp    80106084 <alltraps>

8010678e <vector63>:
.globl vector63
vector63:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $63
80106790:	6a 3f                	push   $0x3f
  jmp alltraps
80106792:	e9 ed f8 ff ff       	jmp    80106084 <alltraps>

80106797 <vector64>:
.globl vector64
vector64:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $64
80106799:	6a 40                	push   $0x40
  jmp alltraps
8010679b:	e9 e4 f8 ff ff       	jmp    80106084 <alltraps>

801067a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $65
801067a2:	6a 41                	push   $0x41
  jmp alltraps
801067a4:	e9 db f8 ff ff       	jmp    80106084 <alltraps>

801067a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $66
801067ab:	6a 42                	push   $0x42
  jmp alltraps
801067ad:	e9 d2 f8 ff ff       	jmp    80106084 <alltraps>

801067b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $67
801067b4:	6a 43                	push   $0x43
  jmp alltraps
801067b6:	e9 c9 f8 ff ff       	jmp    80106084 <alltraps>

801067bb <vector68>:
.globl vector68
vector68:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $68
801067bd:	6a 44                	push   $0x44
  jmp alltraps
801067bf:	e9 c0 f8 ff ff       	jmp    80106084 <alltraps>

801067c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $69
801067c6:	6a 45                	push   $0x45
  jmp alltraps
801067c8:	e9 b7 f8 ff ff       	jmp    80106084 <alltraps>

801067cd <vector70>:
.globl vector70
vector70:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $70
801067cf:	6a 46                	push   $0x46
  jmp alltraps
801067d1:	e9 ae f8 ff ff       	jmp    80106084 <alltraps>

801067d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $71
801067d8:	6a 47                	push   $0x47
  jmp alltraps
801067da:	e9 a5 f8 ff ff       	jmp    80106084 <alltraps>

801067df <vector72>:
.globl vector72
vector72:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $72
801067e1:	6a 48                	push   $0x48
  jmp alltraps
801067e3:	e9 9c f8 ff ff       	jmp    80106084 <alltraps>

801067e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $73
801067ea:	6a 49                	push   $0x49
  jmp alltraps
801067ec:	e9 93 f8 ff ff       	jmp    80106084 <alltraps>

801067f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $74
801067f3:	6a 4a                	push   $0x4a
  jmp alltraps
801067f5:	e9 8a f8 ff ff       	jmp    80106084 <alltraps>

801067fa <vector75>:
.globl vector75
vector75:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $75
801067fc:	6a 4b                	push   $0x4b
  jmp alltraps
801067fe:	e9 81 f8 ff ff       	jmp    80106084 <alltraps>

80106803 <vector76>:
.globl vector76
vector76:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $76
80106805:	6a 4c                	push   $0x4c
  jmp alltraps
80106807:	e9 78 f8 ff ff       	jmp    80106084 <alltraps>

8010680c <vector77>:
.globl vector77
vector77:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $77
8010680e:	6a 4d                	push   $0x4d
  jmp alltraps
80106810:	e9 6f f8 ff ff       	jmp    80106084 <alltraps>

80106815 <vector78>:
.globl vector78
vector78:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $78
80106817:	6a 4e                	push   $0x4e
  jmp alltraps
80106819:	e9 66 f8 ff ff       	jmp    80106084 <alltraps>

8010681e <vector79>:
.globl vector79
vector79:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $79
80106820:	6a 4f                	push   $0x4f
  jmp alltraps
80106822:	e9 5d f8 ff ff       	jmp    80106084 <alltraps>

80106827 <vector80>:
.globl vector80
vector80:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $80
80106829:	6a 50                	push   $0x50
  jmp alltraps
8010682b:	e9 54 f8 ff ff       	jmp    80106084 <alltraps>

80106830 <vector81>:
.globl vector81
vector81:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $81
80106832:	6a 51                	push   $0x51
  jmp alltraps
80106834:	e9 4b f8 ff ff       	jmp    80106084 <alltraps>

80106839 <vector82>:
.globl vector82
vector82:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $82
8010683b:	6a 52                	push   $0x52
  jmp alltraps
8010683d:	e9 42 f8 ff ff       	jmp    80106084 <alltraps>

80106842 <vector83>:
.globl vector83
vector83:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $83
80106844:	6a 53                	push   $0x53
  jmp alltraps
80106846:	e9 39 f8 ff ff       	jmp    80106084 <alltraps>

8010684b <vector84>:
.globl vector84
vector84:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $84
8010684d:	6a 54                	push   $0x54
  jmp alltraps
8010684f:	e9 30 f8 ff ff       	jmp    80106084 <alltraps>

80106854 <vector85>:
.globl vector85
vector85:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $85
80106856:	6a 55                	push   $0x55
  jmp alltraps
80106858:	e9 27 f8 ff ff       	jmp    80106084 <alltraps>

8010685d <vector86>:
.globl vector86
vector86:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $86
8010685f:	6a 56                	push   $0x56
  jmp alltraps
80106861:	e9 1e f8 ff ff       	jmp    80106084 <alltraps>

80106866 <vector87>:
.globl vector87
vector87:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $87
80106868:	6a 57                	push   $0x57
  jmp alltraps
8010686a:	e9 15 f8 ff ff       	jmp    80106084 <alltraps>

8010686f <vector88>:
.globl vector88
vector88:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $88
80106871:	6a 58                	push   $0x58
  jmp alltraps
80106873:	e9 0c f8 ff ff       	jmp    80106084 <alltraps>

80106878 <vector89>:
.globl vector89
vector89:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $89
8010687a:	6a 59                	push   $0x59
  jmp alltraps
8010687c:	e9 03 f8 ff ff       	jmp    80106084 <alltraps>

80106881 <vector90>:
.globl vector90
vector90:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $90
80106883:	6a 5a                	push   $0x5a
  jmp alltraps
80106885:	e9 fa f7 ff ff       	jmp    80106084 <alltraps>

8010688a <vector91>:
.globl vector91
vector91:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $91
8010688c:	6a 5b                	push   $0x5b
  jmp alltraps
8010688e:	e9 f1 f7 ff ff       	jmp    80106084 <alltraps>

80106893 <vector92>:
.globl vector92
vector92:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $92
80106895:	6a 5c                	push   $0x5c
  jmp alltraps
80106897:	e9 e8 f7 ff ff       	jmp    80106084 <alltraps>

8010689c <vector93>:
.globl vector93
vector93:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $93
8010689e:	6a 5d                	push   $0x5d
  jmp alltraps
801068a0:	e9 df f7 ff ff       	jmp    80106084 <alltraps>

801068a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $94
801068a7:	6a 5e                	push   $0x5e
  jmp alltraps
801068a9:	e9 d6 f7 ff ff       	jmp    80106084 <alltraps>

801068ae <vector95>:
.globl vector95
vector95:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $95
801068b0:	6a 5f                	push   $0x5f
  jmp alltraps
801068b2:	e9 cd f7 ff ff       	jmp    80106084 <alltraps>

801068b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $96
801068b9:	6a 60                	push   $0x60
  jmp alltraps
801068bb:	e9 c4 f7 ff ff       	jmp    80106084 <alltraps>

801068c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $97
801068c2:	6a 61                	push   $0x61
  jmp alltraps
801068c4:	e9 bb f7 ff ff       	jmp    80106084 <alltraps>

801068c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $98
801068cb:	6a 62                	push   $0x62
  jmp alltraps
801068cd:	e9 b2 f7 ff ff       	jmp    80106084 <alltraps>

801068d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $99
801068d4:	6a 63                	push   $0x63
  jmp alltraps
801068d6:	e9 a9 f7 ff ff       	jmp    80106084 <alltraps>

801068db <vector100>:
.globl vector100
vector100:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $100
801068dd:	6a 64                	push   $0x64
  jmp alltraps
801068df:	e9 a0 f7 ff ff       	jmp    80106084 <alltraps>

801068e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $101
801068e6:	6a 65                	push   $0x65
  jmp alltraps
801068e8:	e9 97 f7 ff ff       	jmp    80106084 <alltraps>

801068ed <vector102>:
.globl vector102
vector102:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $102
801068ef:	6a 66                	push   $0x66
  jmp alltraps
801068f1:	e9 8e f7 ff ff       	jmp    80106084 <alltraps>

801068f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $103
801068f8:	6a 67                	push   $0x67
  jmp alltraps
801068fa:	e9 85 f7 ff ff       	jmp    80106084 <alltraps>

801068ff <vector104>:
.globl vector104
vector104:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $104
80106901:	6a 68                	push   $0x68
  jmp alltraps
80106903:	e9 7c f7 ff ff       	jmp    80106084 <alltraps>

80106908 <vector105>:
.globl vector105
vector105:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $105
8010690a:	6a 69                	push   $0x69
  jmp alltraps
8010690c:	e9 73 f7 ff ff       	jmp    80106084 <alltraps>

80106911 <vector106>:
.globl vector106
vector106:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $106
80106913:	6a 6a                	push   $0x6a
  jmp alltraps
80106915:	e9 6a f7 ff ff       	jmp    80106084 <alltraps>

8010691a <vector107>:
.globl vector107
vector107:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $107
8010691c:	6a 6b                	push   $0x6b
  jmp alltraps
8010691e:	e9 61 f7 ff ff       	jmp    80106084 <alltraps>

80106923 <vector108>:
.globl vector108
vector108:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $108
80106925:	6a 6c                	push   $0x6c
  jmp alltraps
80106927:	e9 58 f7 ff ff       	jmp    80106084 <alltraps>

8010692c <vector109>:
.globl vector109
vector109:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $109
8010692e:	6a 6d                	push   $0x6d
  jmp alltraps
80106930:	e9 4f f7 ff ff       	jmp    80106084 <alltraps>

80106935 <vector110>:
.globl vector110
vector110:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $110
80106937:	6a 6e                	push   $0x6e
  jmp alltraps
80106939:	e9 46 f7 ff ff       	jmp    80106084 <alltraps>

8010693e <vector111>:
.globl vector111
vector111:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $111
80106940:	6a 6f                	push   $0x6f
  jmp alltraps
80106942:	e9 3d f7 ff ff       	jmp    80106084 <alltraps>

80106947 <vector112>:
.globl vector112
vector112:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $112
80106949:	6a 70                	push   $0x70
  jmp alltraps
8010694b:	e9 34 f7 ff ff       	jmp    80106084 <alltraps>

80106950 <vector113>:
.globl vector113
vector113:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $113
80106952:	6a 71                	push   $0x71
  jmp alltraps
80106954:	e9 2b f7 ff ff       	jmp    80106084 <alltraps>

80106959 <vector114>:
.globl vector114
vector114:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $114
8010695b:	6a 72                	push   $0x72
  jmp alltraps
8010695d:	e9 22 f7 ff ff       	jmp    80106084 <alltraps>

80106962 <vector115>:
.globl vector115
vector115:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $115
80106964:	6a 73                	push   $0x73
  jmp alltraps
80106966:	e9 19 f7 ff ff       	jmp    80106084 <alltraps>

8010696b <vector116>:
.globl vector116
vector116:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $116
8010696d:	6a 74                	push   $0x74
  jmp alltraps
8010696f:	e9 10 f7 ff ff       	jmp    80106084 <alltraps>

80106974 <vector117>:
.globl vector117
vector117:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $117
80106976:	6a 75                	push   $0x75
  jmp alltraps
80106978:	e9 07 f7 ff ff       	jmp    80106084 <alltraps>

8010697d <vector118>:
.globl vector118
vector118:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $118
8010697f:	6a 76                	push   $0x76
  jmp alltraps
80106981:	e9 fe f6 ff ff       	jmp    80106084 <alltraps>

80106986 <vector119>:
.globl vector119
vector119:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $119
80106988:	6a 77                	push   $0x77
  jmp alltraps
8010698a:	e9 f5 f6 ff ff       	jmp    80106084 <alltraps>

8010698f <vector120>:
.globl vector120
vector120:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $120
80106991:	6a 78                	push   $0x78
  jmp alltraps
80106993:	e9 ec f6 ff ff       	jmp    80106084 <alltraps>

80106998 <vector121>:
.globl vector121
vector121:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $121
8010699a:	6a 79                	push   $0x79
  jmp alltraps
8010699c:	e9 e3 f6 ff ff       	jmp    80106084 <alltraps>

801069a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $122
801069a3:	6a 7a                	push   $0x7a
  jmp alltraps
801069a5:	e9 da f6 ff ff       	jmp    80106084 <alltraps>

801069aa <vector123>:
.globl vector123
vector123:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $123
801069ac:	6a 7b                	push   $0x7b
  jmp alltraps
801069ae:	e9 d1 f6 ff ff       	jmp    80106084 <alltraps>

801069b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $124
801069b5:	6a 7c                	push   $0x7c
  jmp alltraps
801069b7:	e9 c8 f6 ff ff       	jmp    80106084 <alltraps>

801069bc <vector125>:
.globl vector125
vector125:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $125
801069be:	6a 7d                	push   $0x7d
  jmp alltraps
801069c0:	e9 bf f6 ff ff       	jmp    80106084 <alltraps>

801069c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $126
801069c7:	6a 7e                	push   $0x7e
  jmp alltraps
801069c9:	e9 b6 f6 ff ff       	jmp    80106084 <alltraps>

801069ce <vector127>:
.globl vector127
vector127:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $127
801069d0:	6a 7f                	push   $0x7f
  jmp alltraps
801069d2:	e9 ad f6 ff ff       	jmp    80106084 <alltraps>

801069d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $128
801069d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069de:	e9 a1 f6 ff ff       	jmp    80106084 <alltraps>

801069e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $129
801069e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801069ea:	e9 95 f6 ff ff       	jmp    80106084 <alltraps>

801069ef <vector130>:
.globl vector130
vector130:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $130
801069f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069f6:	e9 89 f6 ff ff       	jmp    80106084 <alltraps>

801069fb <vector131>:
.globl vector131
vector131:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $131
801069fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a02:	e9 7d f6 ff ff       	jmp    80106084 <alltraps>

80106a07 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $132
80106a09:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a0e:	e9 71 f6 ff ff       	jmp    80106084 <alltraps>

80106a13 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $133
80106a15:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a1a:	e9 65 f6 ff ff       	jmp    80106084 <alltraps>

80106a1f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $134
80106a21:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a26:	e9 59 f6 ff ff       	jmp    80106084 <alltraps>

80106a2b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $135
80106a2d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a32:	e9 4d f6 ff ff       	jmp    80106084 <alltraps>

80106a37 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $136
80106a39:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a3e:	e9 41 f6 ff ff       	jmp    80106084 <alltraps>

80106a43 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $137
80106a45:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a4a:	e9 35 f6 ff ff       	jmp    80106084 <alltraps>

80106a4f <vector138>:
.globl vector138
vector138:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $138
80106a51:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a56:	e9 29 f6 ff ff       	jmp    80106084 <alltraps>

80106a5b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $139
80106a5d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a62:	e9 1d f6 ff ff       	jmp    80106084 <alltraps>

80106a67 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $140
80106a69:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a6e:	e9 11 f6 ff ff       	jmp    80106084 <alltraps>

80106a73 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $141
80106a75:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a7a:	e9 05 f6 ff ff       	jmp    80106084 <alltraps>

80106a7f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $142
80106a81:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a86:	e9 f9 f5 ff ff       	jmp    80106084 <alltraps>

80106a8b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $143
80106a8d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a92:	e9 ed f5 ff ff       	jmp    80106084 <alltraps>

80106a97 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $144
80106a99:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a9e:	e9 e1 f5 ff ff       	jmp    80106084 <alltraps>

80106aa3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $145
80106aa5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aaa:	e9 d5 f5 ff ff       	jmp    80106084 <alltraps>

80106aaf <vector146>:
.globl vector146
vector146:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $146
80106ab1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ab6:	e9 c9 f5 ff ff       	jmp    80106084 <alltraps>

80106abb <vector147>:
.globl vector147
vector147:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $147
80106abd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ac2:	e9 bd f5 ff ff       	jmp    80106084 <alltraps>

80106ac7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $148
80106ac9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ace:	e9 b1 f5 ff ff       	jmp    80106084 <alltraps>

80106ad3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $149
80106ad5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106ada:	e9 a5 f5 ff ff       	jmp    80106084 <alltraps>

80106adf <vector150>:
.globl vector150
vector150:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $150
80106ae1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ae6:	e9 99 f5 ff ff       	jmp    80106084 <alltraps>

80106aeb <vector151>:
.globl vector151
vector151:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $151
80106aed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106af2:	e9 8d f5 ff ff       	jmp    80106084 <alltraps>

80106af7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $152
80106af9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106afe:	e9 81 f5 ff ff       	jmp    80106084 <alltraps>

80106b03 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $153
80106b05:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b0a:	e9 75 f5 ff ff       	jmp    80106084 <alltraps>

80106b0f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $154
80106b11:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b16:	e9 69 f5 ff ff       	jmp    80106084 <alltraps>

80106b1b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $155
80106b1d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b22:	e9 5d f5 ff ff       	jmp    80106084 <alltraps>

80106b27 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $156
80106b29:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b2e:	e9 51 f5 ff ff       	jmp    80106084 <alltraps>

80106b33 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $157
80106b35:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b3a:	e9 45 f5 ff ff       	jmp    80106084 <alltraps>

80106b3f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $158
80106b41:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b46:	e9 39 f5 ff ff       	jmp    80106084 <alltraps>

80106b4b <vector159>:
.globl vector159
vector159:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $159
80106b4d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b52:	e9 2d f5 ff ff       	jmp    80106084 <alltraps>

80106b57 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $160
80106b59:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b5e:	e9 21 f5 ff ff       	jmp    80106084 <alltraps>

80106b63 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $161
80106b65:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b6a:	e9 15 f5 ff ff       	jmp    80106084 <alltraps>

80106b6f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $162
80106b71:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b76:	e9 09 f5 ff ff       	jmp    80106084 <alltraps>

80106b7b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $163
80106b7d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b82:	e9 fd f4 ff ff       	jmp    80106084 <alltraps>

80106b87 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $164
80106b89:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b8e:	e9 f1 f4 ff ff       	jmp    80106084 <alltraps>

80106b93 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $165
80106b95:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b9a:	e9 e5 f4 ff ff       	jmp    80106084 <alltraps>

80106b9f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $166
80106ba1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ba6:	e9 d9 f4 ff ff       	jmp    80106084 <alltraps>

80106bab <vector167>:
.globl vector167
vector167:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $167
80106bad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bb2:	e9 cd f4 ff ff       	jmp    80106084 <alltraps>

80106bb7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $168
80106bb9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bbe:	e9 c1 f4 ff ff       	jmp    80106084 <alltraps>

80106bc3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $169
80106bc5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bca:	e9 b5 f4 ff ff       	jmp    80106084 <alltraps>

80106bcf <vector170>:
.globl vector170
vector170:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $170
80106bd1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bd6:	e9 a9 f4 ff ff       	jmp    80106084 <alltraps>

80106bdb <vector171>:
.globl vector171
vector171:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $171
80106bdd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106be2:	e9 9d f4 ff ff       	jmp    80106084 <alltraps>

80106be7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $172
80106be9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106bee:	e9 91 f4 ff ff       	jmp    80106084 <alltraps>

80106bf3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $173
80106bf5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106bfa:	e9 85 f4 ff ff       	jmp    80106084 <alltraps>

80106bff <vector174>:
.globl vector174
vector174:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $174
80106c01:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c06:	e9 79 f4 ff ff       	jmp    80106084 <alltraps>

80106c0b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $175
80106c0d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c12:	e9 6d f4 ff ff       	jmp    80106084 <alltraps>

80106c17 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $176
80106c19:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c1e:	e9 61 f4 ff ff       	jmp    80106084 <alltraps>

80106c23 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $177
80106c25:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c2a:	e9 55 f4 ff ff       	jmp    80106084 <alltraps>

80106c2f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $178
80106c31:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c36:	e9 49 f4 ff ff       	jmp    80106084 <alltraps>

80106c3b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $179
80106c3d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c42:	e9 3d f4 ff ff       	jmp    80106084 <alltraps>

80106c47 <vector180>:
.globl vector180
vector180:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $180
80106c49:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c4e:	e9 31 f4 ff ff       	jmp    80106084 <alltraps>

80106c53 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $181
80106c55:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c5a:	e9 25 f4 ff ff       	jmp    80106084 <alltraps>

80106c5f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $182
80106c61:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c66:	e9 19 f4 ff ff       	jmp    80106084 <alltraps>

80106c6b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $183
80106c6d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c72:	e9 0d f4 ff ff       	jmp    80106084 <alltraps>

80106c77 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $184
80106c79:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c7e:	e9 01 f4 ff ff       	jmp    80106084 <alltraps>

80106c83 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $185
80106c85:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c8a:	e9 f5 f3 ff ff       	jmp    80106084 <alltraps>

80106c8f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $186
80106c91:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c96:	e9 e9 f3 ff ff       	jmp    80106084 <alltraps>

80106c9b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $187
80106c9d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ca2:	e9 dd f3 ff ff       	jmp    80106084 <alltraps>

80106ca7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $188
80106ca9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cae:	e9 d1 f3 ff ff       	jmp    80106084 <alltraps>

80106cb3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $189
80106cb5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cba:	e9 c5 f3 ff ff       	jmp    80106084 <alltraps>

80106cbf <vector190>:
.globl vector190
vector190:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $190
80106cc1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106cc6:	e9 b9 f3 ff ff       	jmp    80106084 <alltraps>

80106ccb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $191
80106ccd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cd2:	e9 ad f3 ff ff       	jmp    80106084 <alltraps>

80106cd7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $192
80106cd9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106cde:	e9 a1 f3 ff ff       	jmp    80106084 <alltraps>

80106ce3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $193
80106ce5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106cea:	e9 95 f3 ff ff       	jmp    80106084 <alltraps>

80106cef <vector194>:
.globl vector194
vector194:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $194
80106cf1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106cf6:	e9 89 f3 ff ff       	jmp    80106084 <alltraps>

80106cfb <vector195>:
.globl vector195
vector195:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $195
80106cfd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d02:	e9 7d f3 ff ff       	jmp    80106084 <alltraps>

80106d07 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $196
80106d09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d0e:	e9 71 f3 ff ff       	jmp    80106084 <alltraps>

80106d13 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $197
80106d15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d1a:	e9 65 f3 ff ff       	jmp    80106084 <alltraps>

80106d1f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $198
80106d21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d26:	e9 59 f3 ff ff       	jmp    80106084 <alltraps>

80106d2b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $199
80106d2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d32:	e9 4d f3 ff ff       	jmp    80106084 <alltraps>

80106d37 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $200
80106d39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d3e:	e9 41 f3 ff ff       	jmp    80106084 <alltraps>

80106d43 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $201
80106d45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d4a:	e9 35 f3 ff ff       	jmp    80106084 <alltraps>

80106d4f <vector202>:
.globl vector202
vector202:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $202
80106d51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d56:	e9 29 f3 ff ff       	jmp    80106084 <alltraps>

80106d5b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $203
80106d5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d62:	e9 1d f3 ff ff       	jmp    80106084 <alltraps>

80106d67 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $204
80106d69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d6e:	e9 11 f3 ff ff       	jmp    80106084 <alltraps>

80106d73 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $205
80106d75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d7a:	e9 05 f3 ff ff       	jmp    80106084 <alltraps>

80106d7f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $206
80106d81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d86:	e9 f9 f2 ff ff       	jmp    80106084 <alltraps>

80106d8b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $207
80106d8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d92:	e9 ed f2 ff ff       	jmp    80106084 <alltraps>

80106d97 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $208
80106d99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d9e:	e9 e1 f2 ff ff       	jmp    80106084 <alltraps>

80106da3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $209
80106da5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106daa:	e9 d5 f2 ff ff       	jmp    80106084 <alltraps>

80106daf <vector210>:
.globl vector210
vector210:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $210
80106db1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106db6:	e9 c9 f2 ff ff       	jmp    80106084 <alltraps>

80106dbb <vector211>:
.globl vector211
vector211:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $211
80106dbd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106dc2:	e9 bd f2 ff ff       	jmp    80106084 <alltraps>

80106dc7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $212
80106dc9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106dce:	e9 b1 f2 ff ff       	jmp    80106084 <alltraps>

80106dd3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $213
80106dd5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dda:	e9 a5 f2 ff ff       	jmp    80106084 <alltraps>

80106ddf <vector214>:
.globl vector214
vector214:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $214
80106de1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106de6:	e9 99 f2 ff ff       	jmp    80106084 <alltraps>

80106deb <vector215>:
.globl vector215
vector215:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $215
80106ded:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106df2:	e9 8d f2 ff ff       	jmp    80106084 <alltraps>

80106df7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $216
80106df9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106dfe:	e9 81 f2 ff ff       	jmp    80106084 <alltraps>

80106e03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $217
80106e05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e0a:	e9 75 f2 ff ff       	jmp    80106084 <alltraps>

80106e0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $218
80106e11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e16:	e9 69 f2 ff ff       	jmp    80106084 <alltraps>

80106e1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $219
80106e1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e22:	e9 5d f2 ff ff       	jmp    80106084 <alltraps>

80106e27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $220
80106e29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e2e:	e9 51 f2 ff ff       	jmp    80106084 <alltraps>

80106e33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $221
80106e35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e3a:	e9 45 f2 ff ff       	jmp    80106084 <alltraps>

80106e3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $222
80106e41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e46:	e9 39 f2 ff ff       	jmp    80106084 <alltraps>

80106e4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $223
80106e4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e52:	e9 2d f2 ff ff       	jmp    80106084 <alltraps>

80106e57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $224
80106e59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e5e:	e9 21 f2 ff ff       	jmp    80106084 <alltraps>

80106e63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $225
80106e65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e6a:	e9 15 f2 ff ff       	jmp    80106084 <alltraps>

80106e6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $226
80106e71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e76:	e9 09 f2 ff ff       	jmp    80106084 <alltraps>

80106e7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $227
80106e7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e82:	e9 fd f1 ff ff       	jmp    80106084 <alltraps>

80106e87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $228
80106e89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e8e:	e9 f1 f1 ff ff       	jmp    80106084 <alltraps>

80106e93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $229
80106e95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e9a:	e9 e5 f1 ff ff       	jmp    80106084 <alltraps>

80106e9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $230
80106ea1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ea6:	e9 d9 f1 ff ff       	jmp    80106084 <alltraps>

80106eab <vector231>:
.globl vector231
vector231:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $231
80106ead:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106eb2:	e9 cd f1 ff ff       	jmp    80106084 <alltraps>

80106eb7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $232
80106eb9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ebe:	e9 c1 f1 ff ff       	jmp    80106084 <alltraps>

80106ec3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $233
80106ec5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106eca:	e9 b5 f1 ff ff       	jmp    80106084 <alltraps>

80106ecf <vector234>:
.globl vector234
vector234:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $234
80106ed1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ed6:	e9 a9 f1 ff ff       	jmp    80106084 <alltraps>

80106edb <vector235>:
.globl vector235
vector235:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $235
80106edd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ee2:	e9 9d f1 ff ff       	jmp    80106084 <alltraps>

80106ee7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $236
80106ee9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106eee:	e9 91 f1 ff ff       	jmp    80106084 <alltraps>

80106ef3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $237
80106ef5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106efa:	e9 85 f1 ff ff       	jmp    80106084 <alltraps>

80106eff <vector238>:
.globl vector238
vector238:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $238
80106f01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f06:	e9 79 f1 ff ff       	jmp    80106084 <alltraps>

80106f0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $239
80106f0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f12:	e9 6d f1 ff ff       	jmp    80106084 <alltraps>

80106f17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $240
80106f19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f1e:	e9 61 f1 ff ff       	jmp    80106084 <alltraps>

80106f23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $241
80106f25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f2a:	e9 55 f1 ff ff       	jmp    80106084 <alltraps>

80106f2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $242
80106f31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f36:	e9 49 f1 ff ff       	jmp    80106084 <alltraps>

80106f3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $243
80106f3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f42:	e9 3d f1 ff ff       	jmp    80106084 <alltraps>

80106f47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $244
80106f49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f4e:	e9 31 f1 ff ff       	jmp    80106084 <alltraps>

80106f53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $245
80106f55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f5a:	e9 25 f1 ff ff       	jmp    80106084 <alltraps>

80106f5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $246
80106f61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f66:	e9 19 f1 ff ff       	jmp    80106084 <alltraps>

80106f6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $247
80106f6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f72:	e9 0d f1 ff ff       	jmp    80106084 <alltraps>

80106f77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $248
80106f79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f7e:	e9 01 f1 ff ff       	jmp    80106084 <alltraps>

80106f83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $249
80106f85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f8a:	e9 f5 f0 ff ff       	jmp    80106084 <alltraps>

80106f8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $250
80106f91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f96:	e9 e9 f0 ff ff       	jmp    80106084 <alltraps>

80106f9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $251
80106f9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fa2:	e9 dd f0 ff ff       	jmp    80106084 <alltraps>

80106fa7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $252
80106fa9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fae:	e9 d1 f0 ff ff       	jmp    80106084 <alltraps>

80106fb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $253
80106fb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fba:	e9 c5 f0 ff ff       	jmp    80106084 <alltraps>

80106fbf <vector254>:
.globl vector254
vector254:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $254
80106fc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106fc6:	e9 b9 f0 ff ff       	jmp    80106084 <alltraps>

80106fcb <vector255>:
.globl vector255
vector255:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $255
80106fcd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106fd2:	e9 ad f0 ff ff       	jmp    80106084 <alltraps>
80106fd7:	66 90                	xchg   %ax,%ax
80106fd9:	66 90                	xchg   %ax,%ax
80106fdb:	66 90                	xchg   %ax,%ax
80106fdd:	66 90                	xchg   %ax,%ax
80106fdf:	90                   	nop

80106fe0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106fe6:	89 d3                	mov    %edx,%ebx
{
80106fe8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106fea:	c1 eb 16             	shr    $0x16,%ebx
80106fed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ff0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ff3:	8b 06                	mov    (%esi),%eax
80106ff5:	a8 01                	test   $0x1,%al
80106ff7:	74 27                	je     80107020 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ff9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ffe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107004:	c1 ef 0a             	shr    $0xa,%edi
}
80107007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010700a:	89 fa                	mov    %edi,%edx
8010700c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107012:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
8010701a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107020:	85 c9                	test   %ecx,%ecx
80107022:	74 2c                	je     80107050 <walkpgdir+0x70>
80107024:	e8 c7 ba ff ff       	call   80102af0 <kalloc>
80107029:	85 c0                	test   %eax,%eax
8010702b:	89 c3                	mov    %eax,%ebx
8010702d:	74 21                	je     80107050 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010702f:	83 ec 04             	sub    $0x4,%esp
80107032:	68 00 10 00 00       	push   $0x1000
80107037:	6a 00                	push   $0x0
80107039:	50                   	push   %eax
8010703a:	e8 c1 dc ff ff       	call   80104d00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010703f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107045:	83 c4 10             	add    $0x10,%esp
80107048:	83 c8 07             	or     $0x7,%eax
8010704b:	89 06                	mov    %eax,(%esi)
8010704d:	eb b5                	jmp    80107004 <walkpgdir+0x24>
8010704f:	90                   	nop
}
80107050:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107053:	31 c0                	xor    %eax,%eax
}
80107055:	5b                   	pop    %ebx
80107056:	5e                   	pop    %esi
80107057:	5f                   	pop    %edi
80107058:	5d                   	pop    %ebp
80107059:	c3                   	ret    
8010705a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107060 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107066:	89 d3                	mov    %edx,%ebx
80107068:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010706e:	83 ec 1c             	sub    $0x1c,%esp
80107071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107074:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107078:	8b 7d 08             	mov    0x8(%ebp),%edi
8010707b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107080:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107083:	8b 45 0c             	mov    0xc(%ebp),%eax
80107086:	29 df                	sub    %ebx,%edi
80107088:	83 c8 01             	or     $0x1,%eax
8010708b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010708e:	eb 15                	jmp    801070a5 <mappages+0x45>
    if(*pte & PTE_P)
80107090:	f6 00 01             	testb  $0x1,(%eax)
80107093:	75 45                	jne    801070da <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107095:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107098:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010709b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010709d:	74 31                	je     801070d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010709f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801070ad:	89 da                	mov    %ebx,%edx
801070af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801070b2:	e8 29 ff ff ff       	call   80106fe0 <walkpgdir>
801070b7:	85 c0                	test   %eax,%eax
801070b9:	75 d5                	jne    80107090 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801070bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070c3:	5b                   	pop    %ebx
801070c4:	5e                   	pop    %esi
801070c5:	5f                   	pop    %edi
801070c6:	5d                   	pop    %ebp
801070c7:	c3                   	ret    
801070c8:	90                   	nop
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070d3:	31 c0                	xor    %eax,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
      panic("remap");
801070da:	83 ec 0c             	sub    $0xc,%esp
801070dd:	68 dc 82 10 80       	push   $0x801082dc
801070e2:	e8 a9 92 ff ff       	call   80100390 <panic>
801070e7:	89 f6                	mov    %esi,%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070fc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801070fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107104:	83 ec 1c             	sub    $0x1c,%esp
80107107:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010710a:	39 d3                	cmp    %edx,%ebx
8010710c:	73 66                	jae    80107174 <deallocuvm.part.0+0x84>
8010710e:	89 d6                	mov    %edx,%esi
80107110:	eb 3d                	jmp    8010714f <deallocuvm.part.0+0x5f>
80107112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107118:	8b 10                	mov    (%eax),%edx
8010711a:	f6 c2 01             	test   $0x1,%dl
8010711d:	74 26                	je     80107145 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010711f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107125:	74 58                	je     8010717f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107127:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010712a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107133:	52                   	push   %edx
80107134:	e8 07 b8 ff ff       	call   80102940 <kfree>
      *pte = 0;
80107139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010713c:	83 c4 10             	add    $0x10,%esp
8010713f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107145:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010714b:	39 f3                	cmp    %esi,%ebx
8010714d:	73 25                	jae    80107174 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010714f:	31 c9                	xor    %ecx,%ecx
80107151:	89 da                	mov    %ebx,%edx
80107153:	89 f8                	mov    %edi,%eax
80107155:	e8 86 fe ff ff       	call   80106fe0 <walkpgdir>
    if(!pte)
8010715a:	85 c0                	test   %eax,%eax
8010715c:	75 ba                	jne    80107118 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010715e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107164:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010716a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107170:	39 f3                	cmp    %esi,%ebx
80107172:	72 db                	jb     8010714f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107174:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010717a:	5b                   	pop    %ebx
8010717b:	5e                   	pop    %esi
8010717c:	5f                   	pop    %edi
8010717d:	5d                   	pop    %ebp
8010717e:	c3                   	ret    
        panic("kfree");
8010717f:	83 ec 0c             	sub    $0xc,%esp
80107182:	68 86 7b 10 80       	push   $0x80107b86
80107187:	e8 04 92 ff ff       	call   80100390 <panic>
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107190 <seginit>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107196:	e8 65 cc ff ff       	call   80103e00 <cpuid>
8010719b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801071a1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071aa:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
801071b1:	ff 00 00 
801071b4:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
801071bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071be:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
801071c5:	ff 00 00 
801071c8:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
801071cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071d2:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
801071d9:	ff 00 00 
801071dc:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
801071e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071e6:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
801071ed:	ff 00 00 
801071f0:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
801071f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071fa:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
801071ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107203:	c1 e8 10             	shr    $0x10,%eax
80107206:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010720a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010720d:	0f 01 10             	lgdtl  (%eax)
}
80107210:	c9                   	leave  
80107211:	c3                   	ret    
80107212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107220:	a1 c4 65 11 80       	mov    0x801165c4,%eax
{
80107225:	55                   	push   %ebp
80107226:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107228:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010722d:	0f 22 d8             	mov    %eax,%cr3
}
80107230:	5d                   	pop    %ebp
80107231:	c3                   	ret    
80107232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107240 <switchuvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 1c             	sub    $0x1c,%esp
80107249:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010724c:	85 db                	test   %ebx,%ebx
8010724e:	0f 84 cb 00 00 00    	je     8010731f <switchuvm+0xdf>
  if(p->kstack == 0)
80107254:	8b 43 08             	mov    0x8(%ebx),%eax
80107257:	85 c0                	test   %eax,%eax
80107259:	0f 84 da 00 00 00    	je     80107339 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010725f:	8b 43 04             	mov    0x4(%ebx),%eax
80107262:	85 c0                	test   %eax,%eax
80107264:	0f 84 c2 00 00 00    	je     8010732c <switchuvm+0xec>
  pushcli();
8010726a:	e8 b1 d8 ff ff       	call   80104b20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010726f:	e8 0c cb ff ff       	call   80103d80 <mycpu>
80107274:	89 c6                	mov    %eax,%esi
80107276:	e8 05 cb ff ff       	call   80103d80 <mycpu>
8010727b:	89 c7                	mov    %eax,%edi
8010727d:	e8 fe ca ff ff       	call   80103d80 <mycpu>
80107282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107285:	83 c7 08             	add    $0x8,%edi
80107288:	e8 f3 ca ff ff       	call   80103d80 <mycpu>
8010728d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107290:	83 c0 08             	add    $0x8,%eax
80107293:	ba 67 00 00 00       	mov    $0x67,%edx
80107298:	c1 e8 18             	shr    $0x18,%eax
8010729b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801072a2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801072a9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072af:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072b4:	83 c1 08             	add    $0x8,%ecx
801072b7:	c1 e9 10             	shr    $0x10,%ecx
801072ba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801072c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072c5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072cc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801072d1:	e8 aa ca ff ff       	call   80103d80 <mycpu>
801072d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072dd:	e8 9e ca ff ff       	call   80103d80 <mycpu>
801072e2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072e6:	8b 73 08             	mov    0x8(%ebx),%esi
801072e9:	e8 92 ca ff ff       	call   80103d80 <mycpu>
801072ee:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072f4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072f7:	e8 84 ca ff ff       	call   80103d80 <mycpu>
801072fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107300:	b8 28 00 00 00       	mov    $0x28,%eax
80107305:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107308:	8b 43 04             	mov    0x4(%ebx),%eax
8010730b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107310:	0f 22 d8             	mov    %eax,%cr3
}
80107313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107316:	5b                   	pop    %ebx
80107317:	5e                   	pop    %esi
80107318:	5f                   	pop    %edi
80107319:	5d                   	pop    %ebp
  popcli();
8010731a:	e9 41 d8 ff ff       	jmp    80104b60 <popcli>
    panic("switchuvm: no process");
8010731f:	83 ec 0c             	sub    $0xc,%esp
80107322:	68 e2 82 10 80       	push   $0x801082e2
80107327:	e8 64 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010732c:	83 ec 0c             	sub    $0xc,%esp
8010732f:	68 0d 83 10 80       	push   $0x8010830d
80107334:	e8 57 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107339:	83 ec 0c             	sub    $0xc,%esp
8010733c:	68 f8 82 10 80       	push   $0x801082f8
80107341:	e8 4a 90 ff ff       	call   80100390 <panic>
80107346:	8d 76 00             	lea    0x0(%esi),%esi
80107349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107350 <inituvm>:
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 1c             	sub    $0x1c,%esp
80107359:	8b 75 10             	mov    0x10(%ebp),%esi
8010735c:	8b 45 08             	mov    0x8(%ebp),%eax
8010735f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107362:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010736b:	77 49                	ja     801073b6 <inituvm+0x66>
  mem = kalloc();
8010736d:	e8 7e b7 ff ff       	call   80102af0 <kalloc>
  memset(mem, 0, PGSIZE);
80107372:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107375:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107377:	68 00 10 00 00       	push   $0x1000
8010737c:	6a 00                	push   $0x0
8010737e:	50                   	push   %eax
8010737f:	e8 7c d9 ff ff       	call   80104d00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107384:	58                   	pop    %eax
80107385:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010738b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107390:	5a                   	pop    %edx
80107391:	6a 06                	push   $0x6
80107393:	50                   	push   %eax
80107394:	31 d2                	xor    %edx,%edx
80107396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107399:	e8 c2 fc ff ff       	call   80107060 <mappages>
  memmove(mem, init, sz);
8010739e:	89 75 10             	mov    %esi,0x10(%ebp)
801073a1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801073a4:	83 c4 10             	add    $0x10,%esp
801073a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801073aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ad:	5b                   	pop    %ebx
801073ae:	5e                   	pop    %esi
801073af:	5f                   	pop    %edi
801073b0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073b1:	e9 fa d9 ff ff       	jmp    80104db0 <memmove>
    panic("inituvm: more than a page");
801073b6:	83 ec 0c             	sub    $0xc,%esp
801073b9:	68 21 83 10 80       	push   $0x80108321
801073be:	e8 cd 8f ff ff       	call   80100390 <panic>
801073c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073d0 <loaduvm>:
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801073d9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801073e0:	0f 85 91 00 00 00    	jne    80107477 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801073e6:	8b 75 18             	mov    0x18(%ebp),%esi
801073e9:	31 db                	xor    %ebx,%ebx
801073eb:	85 f6                	test   %esi,%esi
801073ed:	75 1a                	jne    80107409 <loaduvm+0x39>
801073ef:	eb 6f                	jmp    80107460 <loaduvm+0x90>
801073f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073fe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107404:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107407:	76 57                	jbe    80107460 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107409:	8b 55 0c             	mov    0xc(%ebp),%edx
8010740c:	8b 45 08             	mov    0x8(%ebp),%eax
8010740f:	31 c9                	xor    %ecx,%ecx
80107411:	01 da                	add    %ebx,%edx
80107413:	e8 c8 fb ff ff       	call   80106fe0 <walkpgdir>
80107418:	85 c0                	test   %eax,%eax
8010741a:	74 4e                	je     8010746a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010741c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010741e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107421:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107426:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010742b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107431:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107434:	01 d9                	add    %ebx,%ecx
80107436:	05 00 00 00 80       	add    $0x80000000,%eax
8010743b:	57                   	push   %edi
8010743c:	51                   	push   %ecx
8010743d:	50                   	push   %eax
8010743e:	ff 75 10             	pushl  0x10(%ebp)
80107441:	e8 4a ab ff ff       	call   80101f90 <readi>
80107446:	83 c4 10             	add    $0x10,%esp
80107449:	39 f8                	cmp    %edi,%eax
8010744b:	74 ab                	je     801073f8 <loaduvm+0x28>
}
8010744d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107455:	5b                   	pop    %ebx
80107456:	5e                   	pop    %esi
80107457:	5f                   	pop    %edi
80107458:	5d                   	pop    %ebp
80107459:	c3                   	ret    
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107463:	31 c0                	xor    %eax,%eax
}
80107465:	5b                   	pop    %ebx
80107466:	5e                   	pop    %esi
80107467:	5f                   	pop    %edi
80107468:	5d                   	pop    %ebp
80107469:	c3                   	ret    
      panic("loaduvm: address should exist");
8010746a:	83 ec 0c             	sub    $0xc,%esp
8010746d:	68 3b 83 10 80       	push   $0x8010833b
80107472:	e8 19 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107477:	83 ec 0c             	sub    $0xc,%esp
8010747a:	68 dc 83 10 80       	push   $0x801083dc
8010747f:	e8 0c 8f ff ff       	call   80100390 <panic>
80107484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010748a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107490 <allocuvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107499:	8b 7d 10             	mov    0x10(%ebp),%edi
8010749c:	85 ff                	test   %edi,%edi
8010749e:	0f 88 8e 00 00 00    	js     80107532 <allocuvm+0xa2>
  if(newsz < oldsz)
801074a4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801074a7:	0f 82 93 00 00 00    	jb     80107540 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801074ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801074b6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801074bc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801074bf:	0f 86 7e 00 00 00    	jbe    80107543 <allocuvm+0xb3>
801074c5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801074c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801074cb:	eb 42                	jmp    8010750f <allocuvm+0x7f>
801074cd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801074d0:	83 ec 04             	sub    $0x4,%esp
801074d3:	68 00 10 00 00       	push   $0x1000
801074d8:	6a 00                	push   $0x0
801074da:	50                   	push   %eax
801074db:	e8 20 d8 ff ff       	call   80104d00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074e0:	58                   	pop    %eax
801074e1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074e7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074ec:	5a                   	pop    %edx
801074ed:	6a 06                	push   $0x6
801074ef:	50                   	push   %eax
801074f0:	89 da                	mov    %ebx,%edx
801074f2:	89 f8                	mov    %edi,%eax
801074f4:	e8 67 fb ff ff       	call   80107060 <mappages>
801074f9:	83 c4 10             	add    $0x10,%esp
801074fc:	85 c0                	test   %eax,%eax
801074fe:	78 50                	js     80107550 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107500:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107506:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107509:	0f 86 81 00 00 00    	jbe    80107590 <allocuvm+0x100>
    mem = kalloc();
8010750f:	e8 dc b5 ff ff       	call   80102af0 <kalloc>
    if(mem == 0){
80107514:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107516:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107518:	75 b6                	jne    801074d0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010751a:	83 ec 0c             	sub    $0xc,%esp
8010751d:	68 59 83 10 80       	push   $0x80108359
80107522:	e8 39 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107527:	83 c4 10             	add    $0x10,%esp
8010752a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010752d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107530:	77 6e                	ja     801075a0 <allocuvm+0x110>
}
80107532:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107535:	31 ff                	xor    %edi,%edi
}
80107537:	89 f8                	mov    %edi,%eax
80107539:	5b                   	pop    %ebx
8010753a:	5e                   	pop    %esi
8010753b:	5f                   	pop    %edi
8010753c:	5d                   	pop    %ebp
8010753d:	c3                   	ret    
8010753e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107540:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107546:	89 f8                	mov    %edi,%eax
80107548:	5b                   	pop    %ebx
80107549:	5e                   	pop    %esi
8010754a:	5f                   	pop    %edi
8010754b:	5d                   	pop    %ebp
8010754c:	c3                   	ret    
8010754d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107550:	83 ec 0c             	sub    $0xc,%esp
80107553:	68 71 83 10 80       	push   $0x80108371
80107558:	e8 03 91 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010755d:	83 c4 10             	add    $0x10,%esp
80107560:	8b 45 0c             	mov    0xc(%ebp),%eax
80107563:	39 45 10             	cmp    %eax,0x10(%ebp)
80107566:	76 0d                	jbe    80107575 <allocuvm+0xe5>
80107568:	89 c1                	mov    %eax,%ecx
8010756a:	8b 55 10             	mov    0x10(%ebp),%edx
8010756d:	8b 45 08             	mov    0x8(%ebp),%eax
80107570:	e8 7b fb ff ff       	call   801070f0 <deallocuvm.part.0>
      kfree(mem);
80107575:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107578:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010757a:	56                   	push   %esi
8010757b:	e8 c0 b3 ff ff       	call   80102940 <kfree>
      return 0;
80107580:	83 c4 10             	add    $0x10,%esp
}
80107583:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107586:	89 f8                	mov    %edi,%eax
80107588:	5b                   	pop    %ebx
80107589:	5e                   	pop    %esi
8010758a:	5f                   	pop    %edi
8010758b:	5d                   	pop    %ebp
8010758c:	c3                   	ret    
8010758d:	8d 76 00             	lea    0x0(%esi),%esi
80107590:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107593:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107596:	5b                   	pop    %ebx
80107597:	89 f8                	mov    %edi,%eax
80107599:	5e                   	pop    %esi
8010759a:	5f                   	pop    %edi
8010759b:	5d                   	pop    %ebp
8010759c:	c3                   	ret    
8010759d:	8d 76 00             	lea    0x0(%esi),%esi
801075a0:	89 c1                	mov    %eax,%ecx
801075a2:	8b 55 10             	mov    0x10(%ebp),%edx
801075a5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801075a8:	31 ff                	xor    %edi,%edi
801075aa:	e8 41 fb ff ff       	call   801070f0 <deallocuvm.part.0>
801075af:	eb 92                	jmp    80107543 <allocuvm+0xb3>
801075b1:	eb 0d                	jmp    801075c0 <deallocuvm>
801075b3:	90                   	nop
801075b4:	90                   	nop
801075b5:	90                   	nop
801075b6:	90                   	nop
801075b7:	90                   	nop
801075b8:	90                   	nop
801075b9:	90                   	nop
801075ba:	90                   	nop
801075bb:	90                   	nop
801075bc:	90                   	nop
801075bd:	90                   	nop
801075be:	90                   	nop
801075bf:	90                   	nop

801075c0 <deallocuvm>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801075c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801075cc:	39 d1                	cmp    %edx,%ecx
801075ce:	73 10                	jae    801075e0 <deallocuvm+0x20>
}
801075d0:	5d                   	pop    %ebp
801075d1:	e9 1a fb ff ff       	jmp    801070f0 <deallocuvm.part.0>
801075d6:	8d 76 00             	lea    0x0(%esi),%esi
801075d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801075e0:	89 d0                	mov    %edx,%eax
801075e2:	5d                   	pop    %ebp
801075e3:	c3                   	ret    
801075e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075f0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
801075f6:	83 ec 0c             	sub    $0xc,%esp
801075f9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801075fc:	85 f6                	test   %esi,%esi
801075fe:	74 59                	je     80107659 <freevm+0x69>
80107600:	31 c9                	xor    %ecx,%ecx
80107602:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107607:	89 f0                	mov    %esi,%eax
80107609:	e8 e2 fa ff ff       	call   801070f0 <deallocuvm.part.0>
8010760e:	89 f3                	mov    %esi,%ebx
80107610:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107616:	eb 0f                	jmp    80107627 <freevm+0x37>
80107618:	90                   	nop
80107619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107620:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107623:	39 fb                	cmp    %edi,%ebx
80107625:	74 23                	je     8010764a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107627:	8b 03                	mov    (%ebx),%eax
80107629:	a8 01                	test   $0x1,%al
8010762b:	74 f3                	je     80107620 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010762d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107632:	83 ec 0c             	sub    $0xc,%esp
80107635:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107638:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010763d:	50                   	push   %eax
8010763e:	e8 fd b2 ff ff       	call   80102940 <kfree>
80107643:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107646:	39 fb                	cmp    %edi,%ebx
80107648:	75 dd                	jne    80107627 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010764a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010764d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107650:	5b                   	pop    %ebx
80107651:	5e                   	pop    %esi
80107652:	5f                   	pop    %edi
80107653:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107654:	e9 e7 b2 ff ff       	jmp    80102940 <kfree>
    panic("freevm: no pgdir");
80107659:	83 ec 0c             	sub    $0xc,%esp
8010765c:	68 8d 83 10 80       	push   $0x8010838d
80107661:	e8 2a 8d ff ff       	call   80100390 <panic>
80107666:	8d 76 00             	lea    0x0(%esi),%esi
80107669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107670 <setupkvm>:
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	56                   	push   %esi
80107674:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107675:	e8 76 b4 ff ff       	call   80102af0 <kalloc>
8010767a:	85 c0                	test   %eax,%eax
8010767c:	89 c6                	mov    %eax,%esi
8010767e:	74 42                	je     801076c2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107680:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107683:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107688:	68 00 10 00 00       	push   $0x1000
8010768d:	6a 00                	push   $0x0
8010768f:	50                   	push   %eax
80107690:	e8 6b d6 ff ff       	call   80104d00 <memset>
80107695:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107698:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010769b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010769e:	83 ec 08             	sub    $0x8,%esp
801076a1:	8b 13                	mov    (%ebx),%edx
801076a3:	ff 73 0c             	pushl  0xc(%ebx)
801076a6:	50                   	push   %eax
801076a7:	29 c1                	sub    %eax,%ecx
801076a9:	89 f0                	mov    %esi,%eax
801076ab:	e8 b0 f9 ff ff       	call   80107060 <mappages>
801076b0:	83 c4 10             	add    $0x10,%esp
801076b3:	85 c0                	test   %eax,%eax
801076b5:	78 19                	js     801076d0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076b7:	83 c3 10             	add    $0x10,%ebx
801076ba:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076c0:	75 d6                	jne    80107698 <setupkvm+0x28>
}
801076c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076c5:	89 f0                	mov    %esi,%eax
801076c7:	5b                   	pop    %ebx
801076c8:	5e                   	pop    %esi
801076c9:	5d                   	pop    %ebp
801076ca:	c3                   	ret    
801076cb:	90                   	nop
801076cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801076d0:	83 ec 0c             	sub    $0xc,%esp
801076d3:	56                   	push   %esi
      return 0;
801076d4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801076d6:	e8 15 ff ff ff       	call   801075f0 <freevm>
      return 0;
801076db:	83 c4 10             	add    $0x10,%esp
}
801076de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076e1:	89 f0                	mov    %esi,%eax
801076e3:	5b                   	pop    %ebx
801076e4:	5e                   	pop    %esi
801076e5:	5d                   	pop    %ebp
801076e6:	c3                   	ret    
801076e7:	89 f6                	mov    %esi,%esi
801076e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076f0 <kvmalloc>:
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076f6:	e8 75 ff ff ff       	call   80107670 <setupkvm>
801076fb:	a3 c4 65 11 80       	mov    %eax,0x801165c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107700:	05 00 00 00 80       	add    $0x80000000,%eax
80107705:	0f 22 d8             	mov    %eax,%cr3
}
80107708:	c9                   	leave  
80107709:	c3                   	ret    
8010770a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107710 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107710:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107711:	31 c9                	xor    %ecx,%ecx
{
80107713:	89 e5                	mov    %esp,%ebp
80107715:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107718:	8b 55 0c             	mov    0xc(%ebp),%edx
8010771b:	8b 45 08             	mov    0x8(%ebp),%eax
8010771e:	e8 bd f8 ff ff       	call   80106fe0 <walkpgdir>
  if(pte == 0)
80107723:	85 c0                	test   %eax,%eax
80107725:	74 05                	je     8010772c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107727:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010772a:	c9                   	leave  
8010772b:	c3                   	ret    
    panic("clearpteu");
8010772c:	83 ec 0c             	sub    $0xc,%esp
8010772f:	68 9e 83 10 80       	push   $0x8010839e
80107734:	e8 57 8c ff ff       	call   80100390 <panic>
80107739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107740 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107749:	e8 22 ff ff ff       	call   80107670 <setupkvm>
8010774e:	85 c0                	test   %eax,%eax
80107750:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107753:	0f 84 9f 00 00 00    	je     801077f8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107759:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010775c:	85 c9                	test   %ecx,%ecx
8010775e:	0f 84 94 00 00 00    	je     801077f8 <copyuvm+0xb8>
80107764:	31 ff                	xor    %edi,%edi
80107766:	eb 4a                	jmp    801077b2 <copyuvm+0x72>
80107768:	90                   	nop
80107769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107770:	83 ec 04             	sub    $0x4,%esp
80107773:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107779:	68 00 10 00 00       	push   $0x1000
8010777e:	53                   	push   %ebx
8010777f:	50                   	push   %eax
80107780:	e8 2b d6 ff ff       	call   80104db0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107785:	58                   	pop    %eax
80107786:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010778c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107791:	5a                   	pop    %edx
80107792:	ff 75 e4             	pushl  -0x1c(%ebp)
80107795:	50                   	push   %eax
80107796:	89 fa                	mov    %edi,%edx
80107798:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010779b:	e8 c0 f8 ff ff       	call   80107060 <mappages>
801077a0:	83 c4 10             	add    $0x10,%esp
801077a3:	85 c0                	test   %eax,%eax
801077a5:	78 61                	js     80107808 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801077a7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801077ad:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801077b0:	76 46                	jbe    801077f8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077b2:	8b 45 08             	mov    0x8(%ebp),%eax
801077b5:	31 c9                	xor    %ecx,%ecx
801077b7:	89 fa                	mov    %edi,%edx
801077b9:	e8 22 f8 ff ff       	call   80106fe0 <walkpgdir>
801077be:	85 c0                	test   %eax,%eax
801077c0:	74 61                	je     80107823 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801077c2:	8b 00                	mov    (%eax),%eax
801077c4:	a8 01                	test   $0x1,%al
801077c6:	74 4e                	je     80107816 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801077c8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801077ca:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801077cf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801077d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801077d8:	e8 13 b3 ff ff       	call   80102af0 <kalloc>
801077dd:	85 c0                	test   %eax,%eax
801077df:	89 c6                	mov    %eax,%esi
801077e1:	75 8d                	jne    80107770 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801077e3:	83 ec 0c             	sub    $0xc,%esp
801077e6:	ff 75 e0             	pushl  -0x20(%ebp)
801077e9:	e8 02 fe ff ff       	call   801075f0 <freevm>
  return 0;
801077ee:	83 c4 10             	add    $0x10,%esp
801077f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801077f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077fe:	5b                   	pop    %ebx
801077ff:	5e                   	pop    %esi
80107800:	5f                   	pop    %edi
80107801:	5d                   	pop    %ebp
80107802:	c3                   	ret    
80107803:	90                   	nop
80107804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107808:	83 ec 0c             	sub    $0xc,%esp
8010780b:	56                   	push   %esi
8010780c:	e8 2f b1 ff ff       	call   80102940 <kfree>
      goto bad;
80107811:	83 c4 10             	add    $0x10,%esp
80107814:	eb cd                	jmp    801077e3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107816:	83 ec 0c             	sub    $0xc,%esp
80107819:	68 c2 83 10 80       	push   $0x801083c2
8010781e:	e8 6d 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107823:	83 ec 0c             	sub    $0xc,%esp
80107826:	68 a8 83 10 80       	push   $0x801083a8
8010782b:	e8 60 8b ff ff       	call   80100390 <panic>

80107830 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107830:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107831:	31 c9                	xor    %ecx,%ecx
{
80107833:	89 e5                	mov    %esp,%ebp
80107835:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107838:	8b 55 0c             	mov    0xc(%ebp),%edx
8010783b:	8b 45 08             	mov    0x8(%ebp),%eax
8010783e:	e8 9d f7 ff ff       	call   80106fe0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107843:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107845:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107846:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107848:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010784d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107850:	05 00 00 00 80       	add    $0x80000000,%eax
80107855:	83 fa 05             	cmp    $0x5,%edx
80107858:	ba 00 00 00 00       	mov    $0x0,%edx
8010785d:	0f 45 c2             	cmovne %edx,%eax
}
80107860:	c3                   	ret    
80107861:	eb 0d                	jmp    80107870 <copyout>
80107863:	90                   	nop
80107864:	90                   	nop
80107865:	90                   	nop
80107866:	90                   	nop
80107867:	90                   	nop
80107868:	90                   	nop
80107869:	90                   	nop
8010786a:	90                   	nop
8010786b:	90                   	nop
8010786c:	90                   	nop
8010786d:	90                   	nop
8010786e:	90                   	nop
8010786f:	90                   	nop

80107870 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	57                   	push   %edi
80107874:	56                   	push   %esi
80107875:	53                   	push   %ebx
80107876:	83 ec 1c             	sub    $0x1c,%esp
80107879:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010787c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010787f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107882:	85 db                	test   %ebx,%ebx
80107884:	75 40                	jne    801078c6 <copyout+0x56>
80107886:	eb 70                	jmp    801078f8 <copyout+0x88>
80107888:	90                   	nop
80107889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107890:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107893:	89 f1                	mov    %esi,%ecx
80107895:	29 d1                	sub    %edx,%ecx
80107897:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010789d:	39 d9                	cmp    %ebx,%ecx
8010789f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801078a2:	29 f2                	sub    %esi,%edx
801078a4:	83 ec 04             	sub    $0x4,%esp
801078a7:	01 d0                	add    %edx,%eax
801078a9:	51                   	push   %ecx
801078aa:	57                   	push   %edi
801078ab:	50                   	push   %eax
801078ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801078af:	e8 fc d4 ff ff       	call   80104db0 <memmove>
    len -= n;
    buf += n;
801078b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801078b7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801078ba:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801078c0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801078c2:	29 cb                	sub    %ecx,%ebx
801078c4:	74 32                	je     801078f8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801078c6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801078c8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801078cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801078ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801078d4:	56                   	push   %esi
801078d5:	ff 75 08             	pushl  0x8(%ebp)
801078d8:	e8 53 ff ff ff       	call   80107830 <uva2ka>
    if(pa0 == 0)
801078dd:	83 c4 10             	add    $0x10,%esp
801078e0:	85 c0                	test   %eax,%eax
801078e2:	75 ac                	jne    80107890 <copyout+0x20>
  }
  return 0;
}
801078e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078ec:	5b                   	pop    %ebx
801078ed:	5e                   	pop    %esi
801078ee:	5f                   	pop    %edi
801078ef:	5d                   	pop    %ebp
801078f0:	c3                   	ret    
801078f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078fb:	31 c0                	xor    %eax,%eax
}
801078fd:	5b                   	pop    %ebx
801078fe:	5e                   	pop    %esi
801078ff:	5f                   	pop    %edi
80107900:	5d                   	pop    %ebp
80107901:	c3                   	ret    
