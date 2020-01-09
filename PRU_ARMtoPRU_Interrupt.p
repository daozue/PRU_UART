.origin 0
.entrypoint ARM_TO_PRU_INTERRUPT

#include "PRU_ARMtoPRU_Interrupt.hp"
      
ARM_TO_PRU_INTERRUPT:
POLL:
    // Poll for receipt of interrupt on host 1, if(eventStatus & (1 << (31 & 0x1f))) jmp EVENT
    QBBS      EVENT, eventStatus, 31    // PRU0 need different
    JMP       POLL

EVENT:	
init1: 
	gpioSet tran_en1
	gpioSet tran_en2
	gpioSet tran_en3
	ldi  para.temp32,0
	
	//记录buf内数据长度，低16位为队列头地址，高16位为队列尾地址。初始值清零。
	ldi  global.regPointer.w0, BUFHEADTAIL_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, BUFHEADTAIL_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, BUFHEADTAIL_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	
	//读标志位置0   
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	
	//地址数据指针区置0
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4

	//接收缓存区置0
	zero &r20,32
	ldi  global.regPointer.w0, RECVBUF_ADDR_UART1
    ldi  global.regPointer.w2, 0xc6c0
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
	ldi  global.regPointer.w0, RECVBUF_ADDR_UART2
    ldi  global.regPointer.w2, 0xc6c0
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
	ldi  global.regPointer.w0, RECVBUF_ADDR_UART3
    ldi  global.regPointer.w2, 0xc6c0
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32


	//写标志位置0
	ldi  global.regPointer.w0, TRAN_STATUS_FLAG_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, TRAN_CONTROL_FLAG_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, TRAN_STATUS_FLAG_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, TRAN_CONTROL_FLAG_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, TRAN_STATUS_FLAG_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4
	ldi  global.regPointer.w0, TRAN_CONTROL_FLAG_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo para.temp32,global.regPointer,0,4

	ldi sendqueue.sendaddrtail_buf_uart1,SENDADDR_BUF_UART1
	add sendqueue.sendbaseaddr_buf_uart1,sendqueue.sendaddrtail_buf_uart1,64
	ldi sendqueue.sendaddrhead_buf_uart1,SENDADDR_BUF_UART1
	
	ldi sendqueue.sendaddrtail_buf_uart2,SENDADDR_BUF_UART2
	add sendqueue.sendbaseaddr_buf_uart2,sendqueue.sendaddrtail_buf_uart2,64
	ldi sendqueue.sendaddrhead_buf_uart2,SENDADDR_BUF_UART2
	
	ldi sendqueue.sendaddrtail_buf_uart3,SENDADDR_BUF_UART3
	add sendqueue.sendbaseaddr_buf_uart3,sendqueue.sendaddrtail_buf_uart3,64
	ldi sendqueue.sendaddrhead_buf_uart3,SENDADDR_BUF_UART3
	
	set para.temp32,10
	ldi recvqueue.recvaddrtail_buf_uart1,RECVBUF_ADDR_UART1
	add recvqueue.recvbaseaddr_buf_uart1,recvqueue.recvaddrtail_buf_uart1,para.temp32
	ldi recvqueue.recvaddrhead_buf_uart1,RECVBUF_ADDR_UART1
	
	ldi recvqueue.recvaddrtail_buf_uart2,RECVBUF_ADDR_UART2
	add recvqueue.recvbaseaddr_buf_uart2,recvqueue.recvaddrtail_buf_uart2,para.temp32
	ldi recvqueue.recvaddrhead_buf_uart2,RECVBUF_ADDR_UART2
	
	ldi recvqueue.recvaddrtail_buf_uart3,RECVBUF_ADDR_UART3
	add recvqueue.recvbaseaddr_buf_uart3,recvqueue.recvaddrtail_buf_uart3,para.temp32
	ldi recvqueue.recvaddrhead_buf_uart3,RECVBUF_ADDR_UART3
//波特率设置	
baudrateset:
	ldi  global.regPointer.w0, BAUDRATE_UART1
    ldi  global.regPointer.w2, 0x8000
	lbbo baudrate.uart1,global.regPointer,0,4
	
	ldi  global.regPointer.w0, BAUDRATE_UART2
    ldi  global.regPointer.w2, 0x8000
	lbbo baudrate.uart2,global.regPointer,0,4
	
	ldi  global.regPointer.w0, BAUDRATE_UART3
    ldi  global.regPointer.w2, 0x8000
	lbbo baudrate.uart3,global.regPointer,0,4
	
	ldi baudrate.uart1,3
	ldi baudrate.uart2,2
	ldi baudrate.uart3,1	
	
	//jmp  recvstart	
//**************************a_trandatastart**********************
a_checktrancontrol:
	//检查控制位,如果为0，表示没有新数据需要发送
	ldi global.regPointer.w0,TRAN_CONTROL_FLAG_UART1      
	ldi global.regPointer.w2,0x8000
	lbbo global.regVal, global.regPointer,0,4
	qbeq a_checksendbuf, global.regVal, 0
	
a_settranflag1:
	ldi global.regPointer.w0,TRAN_STATUS_FLAG_UART1      
	ldi global.regPointer.w2,0x8000
	ldi para.temp8,1
	sbbo para.temp8 ,global.regPointer,0,4 //写标志位置1
	
a_writeaddrtobuf:	
	ldi global.regPointer.w0,SENDDATA_ADDR_UART1      
	ldi global.regPointer.w2,0x8000
	lbbo para.p1add, global.regPointer,0,4
	
	mov global.regPointer.w0,sendqueue.sendaddrtail_buf_uart1      
	ldi global.regPointer.w2,0x8000
	sbbo para.p1add, global.regPointer,0,4  //将数据地址保存到buf
	sbbo global.regVal, global.regPointer,4,4//紧接着将数据长度保存到buf
	
	add sendqueue.sendaddrtail_buf_uart1,sendqueue.sendaddrtail_buf_uart1,8
	qbeq a_resetbuftail0,sendqueue.sendbaseaddr_buf_uart1,sendqueue.sendaddrtail_buf_uart1
	jmp a_settranflag0
a_resetbuftail0:
	ldi sendqueue.sendaddrtail_buf_uart1,SENDADDR_BUF_UART1

a_settranflag0:
	ldi global.regPointer.w0,TRAN_CONTROL_FLAG_UART1      
	ldi global.regPointer.w2,0x8000
	ldi para.p1poi ,0x00
	sbbo para.p1poi ,global.regPointer,0,4  //控制位置0
	
	ldi global.regPointer.w0,TRAN_STATUS_FLAG_UART1      
	ldi global.regPointer.w2,0x8000
	sbbo para.p1poi ,global.regPointer,0,4 //写标志位置0
	
a_checksendbuf:
	qbeq a_trandataend,sendqueue.sendaddrhead_buf_uart1,sendqueue.sendaddrtail_buf_uart1
	
a_trandata:
a_loaddataPointer:									
	mov global.regPointer.w0,sendqueue.sendaddrhead_buf_uart1      //获取数据与长度
	ldi global.regPointer.w2,0x8000
	lbbo para.p1add,global.regPointer,0,4
a_loaddatalen:
	lbbo para.tranlen,global.regPointer,4,4
		
	//清除相应地址
	ldi global.regVal,0x00
	sbbo global.regVal,global.regPointer,0,4
	sbbo global.regVal,global.regPointer,4,4
	//sendaddrhead_buf_uart1偏移8位
	add sendqueue.sendaddrhead_buf_uart1,sendqueue.sendaddrhead_buf_uart1,8
	qbeq a_resetbufhead0,sendqueue.sendbaseaddr_buf_uart1,sendqueue.sendaddrhead_buf_uart1
	jmp a_loaddata
a_resetbufhead0:
	ldi sendqueue.sendaddrhead_buf_uart1,SENDADDR_BUF_UART1
	
a_loaddata:
	ldi para.temp16,0
	
    lbbo para.p1poi,para.p1add,0,4              
	ldi global.regVal,0x00
	
a_senddata:
	//gpioSet tran_en1	
a_sendstartbit:
	ldi para.temp8,0 //建立循环8次
	gpioClr tran_en1
	ldi para.temp8,0
	ldi para.temp8,0
a_sendbety: 

	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	qbeq a_baud115200,baudrate.uart1,1 //115200
	qbeq a_baud19200,baudrate.uart1,2 //19200
	qbeq a_baud9600,baudrate.uart1,3  //9600
a_baud115200:
	call dlyau
	jmp a_sendbety1
a_baud19200:
	call dlybu
	jmp a_sendbety1
a_baud9600:
	call dlycu
//	jmp a_sendbety1
	
a_sendbety1:	
	and global.regval,para.p1poi.b0,1	
	add  para.temp8,  para.temp8, 1
	qblt a_sendstopbit, para.temp8, 8
	qbeq a_send1, global.regVal, 1
	
a_send0:
	gpioClr tran_en1
	lsr para.p1poi,para.p1poi,1
	jmp a_sendbety
	
a_send1: 
	gpioSet tran_en1
	lsr para.p1poi,para.p1poi,1
	jmp a_sendbety

a_sendstopbit:
	ldi global.regVal,0x00
	gpioSet tran_en1
	sub para.tranlen,para.tranlen,1
	qbeq a_sendcomplete, para.tranlen, 0
a_checkloaddata:	
	add para.temp16,para.temp16,1
	qbeq  a_getnewdata,para.temp16,4
	
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	qbeq a_baud115200a,baudrate.uart1,1 //115200
	qbeq a_baud19200a,baudrate.uart1,2 //19200
	qbeq a_baud9600a,baudrate.uart1,3  //9600
a_baud115200a:
	call dlyau
	jmp a_baudchoosea
a_baud19200a:
	call dlybu
	jmp a_baudchoosea
a_baud9600a:
	call dlycu
//	jmp a_baudchoosea

a_baudchoosea:
	jmp a_senddata

a_getnewdata:
	add para.p1add,para.p1add,4   //偏移4字节
	
	qbeq a_baud115200b,baudrate.uart1,1 //115200
	qbeq a_baud19200b,baudrate.uart1,2 //19200
	qbeq a_baud9600b,baudrate.uart1,3  //9600
a_baud115200b:
	call dlyau
	jmp a_baudchooseb
a_baud19200b:
	call dlybu
	jmp a_baudchooseb
a_baud9600b:
	call dlycu
//	jmp a_baudchooseb

a_baudchooseb:
	jmp a_loaddata

a_sendcomplete:
	gpioSet tran_en1
	jmp a_checktrancontrol	
a_trandataend:
	jmp a_recvstart
	
//**************************a_trandataend**********************

//*****************************a_RECVDATA**********************
a_recvstart:	
	ldi para.temp32,0
	ldi recvbuffer.cnt,0
	ldi recvbuffer.tmpbuf,0
	ldi para.p1add,0
a_recvbety:
	ldi para.temp8,0	
a_checkrecvstatus:
	qbbs a_recvcomplete0, eventStatus, Rcv_en1	
	qbeq a_baud115200f,baudrate.uart1,1 //115200
	qbeq a_baud19200f,baudrate.uart1,2 //19200
	qbeq a_baud9600f,baudrate.uart1,3  //9600
a_baud115200f:
	call dly2au
	jmp a_baudchoosef
a_baud19200f:
	call dly2bu
	jmp a_baudchoosef
a_baud9600f:
	call dly2cu

a_baudchoosef:
	add para.temp8,para.temp8,1
	qbgt a_checkrecvstatus,para.temp8,8
	
a_continuerecv:	
	qbbs a_recvcomplete1, eventStatus,  Rcv_en1
	ldi para.temp8,0
	//ldi para.p1add,0
	//ldi para.temp16,0
	//ldi para.temp16,0

a_recvbit:
	ldi para.temp16,0
	ldi para.temp16,0
a_tempdly:
	add para.temp16,para.temp16,1
	qbgt a_tempdly,para.temp16,2
	qbeq a_baud115200e,baudrate.uart1,1 //115200
	qbeq a_baud19200e,baudrate.uart1,2 //19200
	qbeq a_baud9600e,baudrate.uart1,3  //9600
a_baud115200e:
	call dlyau
	jmp a_baudchoosee
a_baud19200e:
	call dlybu
	jmp a_baudchoosee
a_baud9600e:
	call dlycu
//	jmp a_baudchoosee

a_baudchoosee:
	qbbs  a_recv1, eventStatus, Rcv_en1
	
a_recv0:
	clr para.p1add,para.temp8
	add para.temp8, para.temp8, 1
	qblt a_getstopbit, para.temp8, 7
	jmp a_recvbit	
a_recv1: 	
	set  para.p1add, para.temp8
	add  para.temp8, para.temp8, 1
	qblt a_getstopbit, para.temp8, 7
	jmp  a_recvbit	

a_getstopbit:  //此处重新优化。给定一个重新校准的时机。
				//先等待16个采样时间。
				//然后重新从等待起始位。
	ldi para.temp16,0
a_tempdly1:
	add para.temp16,para.temp16,1
	qbgt a_tempdly1,para.temp16,3
	
	qbeq a_baud115200c,baudrate.uart1,1 //115200
	qbeq a_baud19200c,baudrate.uart1,2 //19200
	qbeq a_baud9600c,baudrate.uart1,3  //9600
a_baud115200c:
	call dlyau
	jmp a_baudchoosec
a_baud19200c:
	call dlybu
	jmp a_baudchoosec
a_baud9600c:
	call dlycu
//	jmp a_baudchoosec

a_baudchoosec:
	qbbs a_savedata,  eventStatus, Rcv_en1  //=1获取到停止位
	ldi para.temp16,0

	jmp a_nosetbit       	//数据获取失败
	//jmp a_recvcomplete0
a_savedata:
	
	//判断已经存储了哪些块，继续后面的块存储
	//直接放入buffer
	
	mov  global.regPointer.w0, recvqueue.recvaddrtail_buf_uart1
    ldi  global.regPointer.w2, 0xc6c0
	
	sbbo para.p1add, global.regPointer,para.temp32,1 //写入buf块
	add  para.temp32, para.temp32, 1			//如果超过128字节，需要处理，暂不处理，应该是报错，数据过长	


//==========================================================================
a_a1:
	ldi para.temp8,0
a_checkrecvstatus1:
	qbbc a_recvbety, eventStatus, Rcv_en1  //检测到0

	qbeq a_baud115200f1,baudrate.uart1,1 //115200
	qbeq a_baud19200f1,baudrate.uart1,2 //19200
	qbeq a_baud9600f1,baudrate.uart1,3  //9600
a_baud115200f1:
	call dly2au
	jmp a_baudchoosef1
a_baud19200f1:
	call dly2bu
	jmp a_baudchoosef1
a_baud9600f1:
	call dly2cu

a_baudchoosef1:
	add para.temp8,para.temp8,1
	qbgt a_checkrecvstatus1,para.temp8,10

	jmp a_recvcomplete1
		
//=========================================================================	
a_nosetbit:
	//清除本次写的块
	
	//将状态恢复到此次接收之前
	
	ldi para.temp16,0
	ldi para.p1add,0
	jmp b_checktrancontrol //		清除本次读取操作，跳出，报错。。。        
 
a_recvcomplete1:
	//尾部加128
	add  recvqueue.recvaddrtail_buf_uart1,recvqueue.recvaddrtail_buf_uart1,128
	
	qbeq a_resetpointerw2,recvqueue.recvaddrtail_buf_uart1,recvqueue.recvbaseaddr_buf_uart1
	jmp a_recvcomplete0
a_resetpointerw2:
	ldi recvqueue.recvaddrtail_buf_uart1,RECVBUF_ADDR_UART1
	//检测读标志，如果为0，检测buffer区是否有数据，有则写入一个块区的内容，并标志位置1
	//首先检测标志位，如果标志位为1，清掉前一次读的buf区的数据，直接可以写数据。
	//如果为0，则去查看数据区是否有数据地址，没有，也可以写数据
	//读数据地址，判断是否是0，如果是0，可以存数据
a_recvcomplete0:
	ldi  global.regval,0x00
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART1
    ldi  global.regPointer.w2, 0x8000
	lbbo para.flag, global.regPointer,0,4
	qbeq a_checkbuflen,para.flag,1
	qbeq a_cleanall,para.flag,2
	
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART1
    ldi  global.regPointer.w2, 0x8000
	lbbo global.regval, global.regPointer,0,4
	qbne a_recvend,global.regval,0

a_checkbuflen:
	qbeq a_cleandata,recvqueue.recvaddrhead_buf_uart1,recvqueue.recvaddrtail_buf_uart1  //如果数据超过8个块，就会出现bug。
	
	//清掉前一次读的buf区的数据
	//qbeq a_back8bock,recvqueue.recvaddrhead_buf_uart1,RECVBUF_ADDR_UART1
	//mov  global.regPointer.w0,recvqueue.recvaddrhead_buf_uart1
	//jmp a_cleanbuf
	ldi global.regPointer.w0,RECVBUF_ADDR_UART1
	qbeq a_back8bock,recvqueue.recvaddrhead_buf_uart1,global.regPointer.w0
	mov global.regPointer.w0,recvqueue.recvaddrhead_buf_uart1
	jmp a_cleanbuf
a_back8bock:
	mov global.regPointer.w0,recvqueue.recvbaseaddr_buf_uart1
a_cleanbuf:	
	sub  global.regPointer.w0,global.regPointer.w0,128
	ldi  global.regPointer.w2,0xc6c0

a_clean32:
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
a_writedatapointer:
	mov  global.regVal.w0,recvqueue.recvaddrhead_buf_uart1
	ldi  global.regVal.w2,0xc6c0
	
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4   //直接将存数据的地址传入
	
	ldi  global.regVal,0
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal, global.regPointer,0,4
	
	add  recvqueue.recvaddrhead_buf_uart1,recvqueue.recvaddrhead_buf_uart1,128 //队列头向后移128字节
	qbeq a_resetpointerw0,recvqueue.recvaddrhead_buf_uart1,recvqueue.recvbaseaddr_buf_uart1
	jmp  a_movehead
a_resetpointerw0:
	ldi recvqueue.recvaddrhead_buf_uart1,RECVBUF_ADDR_UART1
a_movehead:
	jmp  a_recvend

a_cleandata:
	ldi  global.regVal,0
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
a_recvend:
	jmp b_checktrancontrol

a_cleanall:
	ldi  global.regVal,0
	
	//记录buf内数据长度，低16位为队列头地址，高16位为队列尾地址。初始值清零。
	ldi  global.regPointer.w0, BUFHEADTAIL_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
	
	//读标志位置0   
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
	
	//地址数据指针区置0
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART1
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4

	//接收缓存区置0
	ldi  global.regPointer.w0, RECVBUF_ADDR_UART1
    ldi  global.regPointer.w2, 0xc6c0
	
a_cleanall32:
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
	set global.regVal,10
	ldi recvqueue.recvaddrtail_buf_uart1,RECVBUF_ADDR_UART1
	add recvqueue.recvbaseaddr_buf_uart1,recvqueue.recvaddrtail_buf_uart1,global.regVal
	ldi recvqueue.recvaddrhead_buf_uart1,RECVBUF_ADDR_UART1
	
	jmp b_checktrancontrol

//***************************a_RECVDATAEND***********************	

//**************************b_trandatastart**********************
b_checktrancontrol:
	//检查控制位,如果为0，表示没有新数据需要发送
	ldi global.regPointer.w0,TRAN_CONTROL_FLAG_UART2      
	ldi global.regPointer.w2,0x8000
	lbbo global.regVal, global.regPointer,0,4
	qbeq b_checksendbuf, global.regVal, 0
	
b_settranflag1:
	ldi global.regPointer.w0,TRAN_STATUS_FLAG_UART2      
	ldi global.regPointer.w2,0x8000
	ldi para.temp8,1
	sbbo para.temp8 ,global.regPointer,0,4 //写标志位置1
	
b_writeaddrtobuf:	
	ldi global.regPointer.w0,SENDDATA_ADDR_UART2      
	ldi global.regPointer.w2,0x8000
	lbbo para.p1add, global.regPointer,0,4
	
	mov global.regPointer.w0,sendqueue.sendaddrtail_buf_uart2      
	ldi global.regPointer.w2,0x8000
	sbbo para.p1add, global.regPointer,0,4  //将数据地址保存到buf
	sbbo global.regVal, global.regPointer,4,4//紧接着将数据长度保存到buf
	
	add sendqueue.sendaddrtail_buf_uart2,sendqueue.sendaddrtail_buf_uart2,8
	qbeq b_resetbuftail0,sendqueue.sendbaseaddr_buf_uart2,sendqueue.sendaddrtail_buf_uart2
	jmp b_settranflag0
b_resetbuftail0:
	ldi sendqueue.sendaddrtail_buf_uart2,SENDADDR_BUF_UART2

b_settranflag0:
	ldi global.regPointer.w0,TRAN_CONTROL_FLAG_UART2      
	ldi global.regPointer.w2,0x8000
	ldi para.p1poi ,0x00
	sbbo para.p1poi ,global.regPointer,0,4  //控制位置0
	
	ldi global.regPointer.w0,TRAN_STATUS_FLAG_UART2      
	ldi global.regPointer.w2,0x8000
	sbbo para.p1poi ,global.regPointer,0,4 //写标志位置0
	
b_checksendbuf:
	qbeq b_trandataend,sendqueue.sendaddrhead_buf_uart2,sendqueue.sendaddrtail_buf_uart2
	
b_trandata:
b_loaddataPointer:									
	mov global.regPointer.w0,sendqueue.sendaddrhead_buf_uart2      //获取数据与长度
	ldi global.regPointer.w2,0x8000
	lbbo para.p1add,global.regPointer,0,4
b_loaddatalen:
	lbbo para.tranlen,global.regPointer,4,4
		
	//清除相应地址
	ldi global.regVal,0x00
	sbbo global.regVal,global.regPointer,0,4
	sbbo global.regVal,global.regPointer,4,4
	//sendaddrhead_buf_uart2偏移8位
	add sendqueue.sendaddrhead_buf_uart2,sendqueue.sendaddrhead_buf_uart2,8
	qbeq b_resetbufhead0,sendqueue.sendbaseaddr_buf_uart2,sendqueue.sendaddrhead_buf_uart2
	jmp b_loaddata
b_resetbufhead0:
	ldi sendqueue.sendaddrhead_buf_uart2,SENDADDR_BUF_UART2
	
b_loaddata:
	ldi para.temp16,0
	
    lbbo para.p1poi,para.p1add,0,4              
	ldi global.regVal,0x00
	
b_senddata:
	//gpioSet tran_en2	
b_sendstartbit:
	ldi para.temp8,0 //建立循环8次
	gpioClr tran_en2
	ldi para.temp8,0
	ldi para.temp8,0
b_sendbety: 

	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	qbeq b_baud115200,baudrate.uart2,1 //115200
	qbeq b_baud19200,baudrate.uart2,2 //19200
	qbeq b_baud9600,baudrate.uart2,3  //9600
b_baud115200:
	call dlyau
	jmp b_sendbety1
b_baud19200:
	call dlybu
	jmp b_sendbety1
b_baud9600:
	call dlycu
//	jmp b_sendbety1
	
b_sendbety1:	
	and global.regval,para.p1poi.b0,1	
	add  para.temp8,  para.temp8, 1
	qblt b_sendstopbit, para.temp8, 8
	qbeq b_send1, global.regVal, 1
	
b_send0:
	gpioClr tran_en2
	lsr para.p1poi,para.p1poi,1
	jmp b_sendbety
	
b_send1: 
	gpioSet tran_en2
	lsr para.p1poi,para.p1poi,1
	jmp b_sendbety

b_sendstopbit:
	ldi global.regVal,0x00
	gpioSet tran_en2
	sub para.tranlen,para.tranlen,1
	qbeq b_sendcomplete, para.tranlen, 0
b_checkloaddata:	
	add para.temp16,para.temp16,1
	qbeq  b_getnewdata,para.temp16,4
	
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	qbeq b_baud115200a,baudrate.uart2,1 //115200
	qbeq b_baud19200a,baudrate.uart2,2 //19200
	qbeq b_baud9600a,baudrate.uart2,3  //9600
b_baud115200a:
	call dlyau
	jmp b_baudchoosea
b_baud19200a:
	call dlybu
	jmp b_baudchoosea
b_baud9600a:
	call dlycu
//	jmp b_baudchoosea

b_baudchoosea:
	jmp b_senddata

b_getnewdata:
	add para.p1add,para.p1add,4   //偏移4字节
	
	qbeq b_baud115200b,baudrate.uart2,1 //115200
	qbeq b_baud19200b,baudrate.uart2,2 //19200
	qbeq b_baud9600b,baudrate.uart2,3  //9600
b_baud115200b:
	call dlyau
	jmp b_baudchooseb
b_baud19200b:
	call dlybu
	jmp b_baudchooseb
b_baud9600b:
	call dlycu
//	jmp b_baudchooseb

b_baudchooseb:
	jmp b_loaddata

b_sendcomplete:
	gpioSet tran_en2
	jmp b_checktrancontrol	
b_trandataend:
	jmp b_recvstart
	
//**************************b_trandataend**********************

//*****************************b_RECVDATA**********************
b_recvstart:	
	ldi para.temp32,0
	ldi recvbuffer.cnt,0
	ldi recvbuffer.tmpbuf,0
	ldi para.p1add,0
b_recvbety:
	ldi para.temp8,0	
b_checkrecvstatus:
	qbbs b_recvcomplete0, eventStatus,  Rcv_en2
	
	qbeq b_baud115200f,baudrate.uart2,1 //115200
	qbeq b_baud19200f,baudrate.uart2,2 //19200
	qbeq b_baud9600f,baudrate.uart2,3  //9600
b_baud115200f:
	call dly2au
	jmp b_baudchoosef
b_baud19200f:
	call dly2bu
	jmp b_baudchoosef
b_baud9600f:
	call dly2cu

b_baudchoosef:
	add para.temp8,para.temp8,1
	qbgt b_checkrecvstatus,para.temp8,8
	
b_continuerecv:
	qbbs b_recvcomplete1, eventStatus,  Rcv_en2	
	ldi para.temp8,0
	//ldi para.p1add,0
	//ldi para.temp16,0
	//ldi para.temp16,0

b_recvbit:
	ldi para.temp16,0
	ldi para.temp16,0
b_tempdly:
	add para.temp16,para.temp16,1
	qbgt b_tempdly,para.temp16,2
	qbeq b_baud115200e,baudrate.uart2,1 //115200
	qbeq b_baud19200e,baudrate.uart2,2 //19200
	qbeq b_baud9600e,baudrate.uart2,3  //9600
b_baud115200e:
	call dlyau
	jmp b_baudchoosee
b_baud19200e:
	call dlybu
	jmp b_baudchoosee
b_baud9600e:
	call dlycu
//	jmp b_baudchoosee

b_baudchoosee:
	qbbs  b_recv1, eventStatus, Rcv_en2
b_recv0:
	clr para.p1add,para.temp8
	add para.temp8, para.temp8, 1
	qblt b_getstopbit, para.temp8, 7
	jmp b_recvbit	
b_recv1: 	
	set  para.p1add, para.temp8
	add  para.temp8, para.temp8, 1
	qblt b_getstopbit, para.temp8, 7
	jmp  b_recvbit	

b_getstopbit:
	ldi para.temp16,0
b_tempdly1:
	add para.temp16,para.temp16,1
	qbgt b_tempdly1,para.temp16,3
	
	qbeq b_baud115200c,baudrate.uart2,1 //115200
	qbeq b_baud19200c,baudrate.uart2,2 //19200
	qbeq b_baud9600c,baudrate.uart2,3  //9600
b_baud115200c:
	call dlyau
	jmp b_baudchoosec
b_baud19200c:
	call dlybu
	jmp b_baudchoosec
b_baud9600c:
	call dlycu
//	jmp b_baudchoosec

b_baudchoosec:
	qbbs b_savedata,  eventStatus, Rcv_en2  //=1获取到停止位
	ldi para.temp16,0

	jmp b_nosetbit       	//数据获取失败
	//jmp b_recvcomplete0
b_savedata:
	
	//判断已经存储了哪些块，继续后面的块存储
	//直接放入buffer
	
	mov  global.regPointer.w0, recvqueue.recvaddrtail_buf_uart2
    ldi  global.regPointer.w2, 0xc6c0
	
	sbbo para.p1add, global.regPointer,para.temp32,1 //写入buf块
	add  para.temp32, para.temp32, 1			//如果超过128字节，需要处理，暂不处理，应该是报错，数据过长	


//==========================================================================
b_b1:
	ldi para.temp8,0
b_checkrecvstatus1:
	qbbc b_recvbety, eventStatus, Rcv_en2  //检测到0

	qbeq b_baud115200f1,baudrate.uart2,1 //115200
	qbeq b_baud19200f1,baudrate.uart2,2 //19200
	qbeq b_baud9600f1,baudrate.uart2,3  //9600
b_baud115200f1:
	call dly2au
	jmp b_baudchoosef1
b_baud19200f1:
	call dly2bu
	jmp b_baudchoosef1
b_baud9600f1:
	call dly2cu

b_baudchoosef1:
	add para.temp8,para.temp8,1
	qbgt b_checkrecvstatus1,para.temp8,10

	jmp b_recvcomplete1
		
//=========================================================================	
b_nosetbit:
	//清除本次写的块
	
	//将状态恢复到此次接收之前
	
	ldi para.temp16,0
	ldi para.p1add,0
	jmp c_checktrancontrol //		清除本次读取操作，跳出，报错。。。        
 
b_recvcomplete1:
	//尾部加128
	add  recvqueue.recvaddrtail_buf_uart2,recvqueue.recvaddrtail_buf_uart2,128
	
	qbeq b_resetpointerw2,recvqueue.recvaddrtail_buf_uart2,recvqueue.recvbaseaddr_buf_uart2
	jmp b_recvcomplete0
b_resetpointerw2:
	ldi recvqueue.recvaddrtail_buf_uart2,RECVBUF_ADDR_UART2
	//检测读标志，如果为0，检测buffer区是否有数据，有则写入一个块区的内容，并标志位置1
	//首先检测标志位，如果标志位为1，清掉前一次读的buf区的数据，直接可以写数据。
	//如果为0，则去查看数据区是否有数据地址，没有，也可以写数据
	//读数据地址，判断是否是0，如果是0，可以存数据
b_recvcomplete0:
	ldi  global.regval,0x00
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART2
    ldi  global.regPointer.w2, 0x8000
	lbbo para.flag, global.regPointer,0,4
	qbeq b_checkbuflen,para.flag,1
	qbeq b_cleanall,para.flag,2
	
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART2
    ldi  global.regPointer.w2, 0x8000
	lbbo global.regval, global.regPointer,0,4
	qbne b_recvend,global.regval,0

b_checkbuflen:
	qbeq b_cleandata,recvqueue.recvaddrhead_buf_uart2,recvqueue.recvaddrtail_buf_uart2  //如果数据超过8个块，就会出现bug。
	
	//清掉前一次读的buf区的数据
	//qbeq c_back8bock,recvqueue.recvaddrhead_buf_uart2,RECVBUF_ADDR_UART2
	ldi global.regPointer.w0,RECVBUF_ADDR_UART2
	qbeq b_back8bock,recvqueue.recvaddrhead_buf_uart2,global.regPointer.w0
	mov  global.regPointer.w0,recvqueue.recvaddrhead_buf_uart2
	jmp b_cleanbuf
b_back8bock:
	mov global.regPointer.w0,recvqueue.recvbaseaddr_buf_uart2
b_cleanbuf:	
	sub  global.regPointer.w0,global.regPointer.w0,128
	ldi  global.regPointer.w2,0xc6c0

b_clean32:
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
b_writedatapointer:
	mov  global.regVal.w0,recvqueue.recvaddrhead_buf_uart2
	ldi  global.regVal.w2,0xc6c0
	
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4   //直接将存数据的地址传入
	
	ldi  global.regVal,0
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal, global.regPointer,0,4
	
	add  recvqueue.recvaddrhead_buf_uart2,recvqueue.recvaddrhead_buf_uart2,128 //队列头向后移128字节
	qbeq b_resetpointerw0,recvqueue.recvaddrhead_buf_uart2,recvqueue.recvbaseaddr_buf_uart2
	jmp  b_movehead
b_resetpointerw0:
	ldi recvqueue.recvaddrhead_buf_uart2,RECVBUF_ADDR_UART2
b_movehead:
	jmp  b_recvend

b_cleandata:
	ldi  global.regVal,0
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
b_recvend:
	jmp c_checktrancontrol

b_cleanall:
	ldi  global.regVal,0
	
	//记录buf内数据长度，低16位为队列头地址，高16位为队列尾地址。初始值清零。
	ldi  global.regPointer.w0, BUFHEADTAIL_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
	
	//读标志位置0   
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
	
	//地址数据指针区置0
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART2
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4

	//接收缓存区置0
	ldi  global.regPointer.w0, RECVBUF_ADDR_UART2
    ldi  global.regPointer.w2, 0xc6c0
	
b_cleanall32:
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
	set global.regVal,10
	ldi recvqueue.recvaddrtail_buf_uart2,RECVBUF_ADDR_UART2
	add recvqueue.recvbaseaddr_buf_uart2,recvqueue.recvaddrtail_buf_uart2,global.regVal
	ldi recvqueue.recvaddrhead_buf_uart2,RECVBUF_ADDR_UART2

	jmp c_checktrancontrol

//***************************b_RECVDATAEND***********************

//**************************c_trandatastart**********************
c_checktrancontrol:
	//检查控制位,如果为0，表示没有新数据需要发送
	ldi global.regPointer.w0,TRAN_CONTROL_FLAG_UART3      
	ldi global.regPointer.w2,0x8000
	lbbo global.regVal, global.regPointer,0,4
	qbeq c_checksendbuf, global.regVal, 0
	
c_settranflag1:
	ldi global.regPointer.w0,TRAN_STATUS_FLAG_UART3      
	ldi global.regPointer.w2,0x8000
	ldi para.temp8,1
	sbbo para.temp8 ,global.regPointer,0,4 //写标志位置1
	
c_writeaddrtobuf:	
	ldi global.regPointer.w0,SENDDATA_ADDR_UART3      
	ldi global.regPointer.w2,0x8000
	lbbo para.p1add, global.regPointer,0,4
	
	mov global.regPointer.w0,sendqueue.sendaddrtail_buf_uart3      
	ldi global.regPointer.w2,0x8000
	sbbo para.p1add, global.regPointer,0,4  //将数据地址保存到buf
	sbbo global.regVal, global.regPointer,4,4//紧接着将数据长度保存到buf
	
	add sendqueue.sendaddrtail_buf_uart3,sendqueue.sendaddrtail_buf_uart3,8
	qbeq c_resetbuftail0,sendqueue.sendbaseaddr_buf_uart3,sendqueue.sendaddrtail_buf_uart3
	jmp c_settranflag0
c_resetbuftail0:
	ldi sendqueue.sendaddrtail_buf_uart3,SENDADDR_BUF_UART3

c_settranflag0:
	ldi global.regPointer.w0,TRAN_CONTROL_FLAG_UART3      
	ldi global.regPointer.w2,0x8000
	ldi para.p1poi ,0x00
	sbbo para.p1poi ,global.regPointer,0,4  //控制位置0
	
	ldi global.regPointer.w0,TRAN_STATUS_FLAG_UART3      
	ldi global.regPointer.w2,0x8000
	sbbo para.p1poi ,global.regPointer,0,4 //写标志位置0
	
c_checksendbuf:
	qbeq c_trandataend,sendqueue.sendaddrhead_buf_uart3,sendqueue.sendaddrtail_buf_uart3
	
c_trandata:
c_loaddataPointer:									
	mov global.regPointer.w0,sendqueue.sendaddrhead_buf_uart3      //获取数据与长度
	ldi global.regPointer.w2,0x8000
	lbbo para.p1add,global.regPointer,0,4
c_loaddatalen:
	lbbo para.tranlen,global.regPointer,4,4
		
	//清除相应地址
	ldi global.regVal,0x00
	sbbo global.regVal,global.regPointer,0,4
	sbbo global.regVal,global.regPointer,4,4
	//sendaddrhead_buf_uart3偏移8位
	add sendqueue.sendaddrhead_buf_uart3,sendqueue.sendaddrhead_buf_uart3,8
	qbeq c_resetbufhead0,sendqueue.sendbaseaddr_buf_uart3,sendqueue.sendaddrhead_buf_uart3
	jmp c_loaddata
c_resetbufhead0:
	ldi sendqueue.sendaddrhead_buf_uart3,SENDADDR_BUF_UART3
	
c_loaddata:
	ldi para.temp16,0
	
    lbbo para.p1poi,para.p1add,0,4              
	ldi global.regVal,0x00
	
c_senddata:
	//gpioSet tran_en3	
c_sendstartbit:
	ldi para.temp8,0 //建立循环8次
	gpioClr tran_en3
	ldi para.temp8,0
	ldi para.temp8,0
c_sendbety: 

	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	qbeq c_baud115200,baudrate.uart3,1 //115200
	qbeq c_baud19200,baudrate.uart3,2 //19200
	qbeq c_baud9600,baudrate.uart3,3  //9600
c_baud115200:
	call dlyau
	jmp c_sendbety1
c_baud19200:
	call dlybu
	jmp c_sendbety1
c_baud9600:
	call dlycu
//	jmp c_sendbety1
	
c_sendbety1:	
	and global.regval,para.p1poi.b0,1	
	add  para.temp8,  para.temp8, 1
	qblt c_sendstopbit, para.temp8, 8
	qbeq c_send1, global.regVal, 1
	
c_send0:
	gpioClr tran_en3
	lsr para.p1poi,para.p1poi,1
	jmp c_sendbety
	
c_send1: 
	gpioSet tran_en3
	lsr para.p1poi,para.p1poi,1
	jmp c_sendbety

c_sendstopbit:
	ldi global.regVal,0x00
	gpioSet tran_en3
	sub para.tranlen,para.tranlen,1
	qbeq c_sendcomplete, para.tranlen, 0
c_checkloaddata:	
	add para.temp16,para.temp16,1
	qbeq  c_getnewdata,para.temp16,4
	
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	ldi para.temp32,0
	qbeq c_baud115200a,baudrate.uart3,1 //115200
	qbeq c_baud19200a,baudrate.uart3,2 //19200
	qbeq c_baud9600a,baudrate.uart3,3  //9600
c_baud115200a:
	call dlyau
	jmp c_baudchoosea
c_baud19200a:
	call dlybu
	jmp c_baudchoosea
c_baud9600a:
	call dlycu
//	jmp c_baudchoosea

c_baudchoosea:
	jmp c_senddata

c_getnewdata:
	add para.p1add,para.p1add,4   //偏移4字节
	
	qbeq c_baud115200b,baudrate.uart3,1 //115200
	qbeq c_baud19200b,baudrate.uart3,2 //19200
	qbeq c_baud9600b,baudrate.uart3,3  //9600
c_baud115200b:
	call dlyau
	jmp c_baudchooseb
c_baud19200b:
	call dlybu
	jmp c_baudchooseb
c_baud9600b:
	call dlycu
//	jmp c_baudchooseb

c_baudchooseb:
	jmp c_loaddata

c_sendcomplete:
	gpioSet tran_en3
	jmp c_checktrancontrol	
c_trandataend:
	jmp c_recvstart
	
//**************************c_trandataend**********************

//*****************************c_RECVDATA**********************
c_recvstart:	
	ldi para.temp32,0
	ldi recvbuffer.cnt,0
	ldi recvbuffer.tmpbuf,0
	ldi para.p1add,0
c_recvbety:
	ldi para.temp8,0	
c_checkrecvstatus:
	qbbs c_recvcomplete0, eventStatus, Rcv_en3	
	qbeq c_baud115200f,baudrate.uart3,1 //115200
	qbeq c_baud19200f,baudrate.uart3,2 //19200
	qbeq c_baud9600f,baudrate.uart3,3  //9600
c_baud115200f:
	call dly2au
	jmp c_baudchoosef
c_baud19200f:
	call dly2bu
	jmp c_baudchoosef
c_baud9600f:
	call dly2cu

c_baudchoosef:
	add para.temp8,para.temp8,1
	qbgt c_checkrecvstatus,para.temp8,8
	
c_continuerecv:
	qbbs c_recvcomplete1, eventStatus,  Rcv_en3
	
	ldi para.temp8,0
	//ldi para.p1add,0
	//ldi para.temp16,0
	//ldi para.temp16,0

c_recvbit:
	ldi para.temp16,0
	ldi para.temp16,0
c_tempdly:
	add para.temp16,para.temp16,1
	qbgt c_tempdly,para.temp16,2
	qbeq c_baud115200e,baudrate.uart3,1 //115200
	qbeq c_baud19200e,baudrate.uart3,2 //19200
	qbeq c_baud9600e,baudrate.uart3,3  //9600
c_baud115200e:
	call dlyau
	jmp c_baudchoosee
c_baud19200e:
	call dlybu
	jmp c_baudchoosee
c_baud9600e:
	call dlycu
//	jmp c_baudchoosee

c_baudchoosee:
	qbbs  c_recv1, eventStatus, Rcv_en3
	
c_recv0:
	clr para.p1add,para.temp8
	add para.temp8, para.temp8, 1
	qblt c_getstopbit, para.temp8, 7
	jmp c_recvbit	
c_recv1: 	
	set  para.p1add, para.temp8
	add  para.temp8, para.temp8, 1
	qblt c_getstopbit, para.temp8, 7
	jmp  c_recvbit	

c_getstopbit:
	ldi para.temp16,0
c_tempdly1:
	add para.temp16,para.temp16,1
	qbgt c_tempdly1,para.temp16,3
	
	qbeq c_baud115200c,baudrate.uart3,1 //115200
	qbeq c_baud19200c,baudrate.uart3,2 //19200
	qbeq c_baud9600c,baudrate.uart3,3  //9600
c_baud115200c:
	call dlyau
	jmp c_baudchoosec
c_baud19200c:
	call dlybu
	jmp c_baudchoosec
c_baud9600c:
	call dlycu
//	jmp c_baudchoosec

c_baudchoosec:
	qbbs c_savedata,  eventStatus, Rcv_en3  //=1获取到停止位
	ldi para.temp16,0

	jmp c_nosetbit       	//数据获取失败
	//jmp c_recvcomplete0
c_savedata:
	
	//判断已经存储了哪些块，继续后面的块存储
	//直接放入buffer
	
	mov  global.regPointer.w0, recvqueue.recvaddrtail_buf_uart3
    ldi  global.regPointer.w2, 0xc6c0
	
	sbbo para.p1add, global.regPointer,para.temp32,1 //写入buf块
	add  para.temp32, para.temp32, 1			//如果超过128字节，需要处理，暂不处理，应该是报错，数据过长	


//==========================================================================
c_c1:
	ldi para.temp8,0
c_checkrecvstatus1:
	qbbc c_recvbety, eventStatus, Rcv_en3  //检测到0

	qbeq c_baud115200f1,baudrate.uart3,1 //115200
	qbeq c_baud19200f1,baudrate.uart3,2 //19200
	qbeq c_baud9600f1,baudrate.uart3,3  //9600
c_baud115200f1:
	call dly2au
	jmp c_baudchoosef1
c_baud19200f1:
	call dly2bu
	jmp c_baudchoosef1
c_baud9600f1:
	call dly2cu

c_baudchoosef1:
	add para.temp8,para.temp8,1
	qbgt c_checkrecvstatus1,para.temp8,10

	jmp c_recvcomplete1
		
//=========================================================================	
c_nosetbit:
	//清除本次写的块
	
	//将状态恢复到此次接收之前
	
	ldi para.temp16,0
	ldi para.p1add,0
	jmp c_checktrancontrol //		清除本次读取操作，跳出，报错。。。        
 
c_recvcomplete1:
	//尾部加128
	add  recvqueue.recvaddrtail_buf_uart3,recvqueue.recvaddrtail_buf_uart3,128
	
	qbeq c_resetpointerw2,recvqueue.recvaddrtail_buf_uart3,recvqueue.recvbaseaddr_buf_uart3
	jmp c_recvcomplete0
c_resetpointerw2:
	ldi recvqueue.recvaddrtail_buf_uart3,RECVBUF_ADDR_UART3
	//检测读标志，如果为0，检测buffer区是否有数据，有则写入一个块区的内容，并标志位置1
	//首先检测标志位，如果标志位为1，清掉前一次读的buf区的数据，直接可以写数据。
	//如果为0，则去查看数据区是否有数据地址，没有，也可以写数据
	//读数据地址，判断是否是0，如果是0，可以存数据
c_recvcomplete0:
	ldi  global.regval,0x00
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART3
    ldi  global.regPointer.w2, 0x8000
	lbbo para.flag, global.regPointer,0,4
	qbeq c_checkbuflen,para.flag,1
	qbeq c_cleanall,para.flag,2
	
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART3
    ldi  global.regPointer.w2, 0x8000
	lbbo global.regval, global.regPointer,0,4
	qbne c_recvend,global.regval,0

c_checkbuflen:
	qbeq c_cleandata,recvqueue.recvaddrhead_buf_uart3,recvqueue.recvaddrtail_buf_uart3  //如果数据超过8个块，就会出现bug。
	
	//清掉前一次读的buf区的数据
	//qbeq c_back8bock,recvqueue.recvaddrhead_buf_uart3,RECVBUF_ADDR_UART3
	ldi global.regPointer.w0,RECVBUF_ADDR_UART3
	qbeq c_back8bock,recvqueue.recvaddrhead_buf_uart3,global.regPointer.w0
	mov  global.regPointer.w0,recvqueue.recvaddrhead_buf_uart3
	jmp c_cleanbuf
c_back8bock:
	mov global.regPointer.w0,recvqueue.recvbaseaddr_buf_uart3
c_cleanbuf:	
	sub  global.regPointer.w0,global.regPointer.w0,128
	ldi  global.regPointer.w2,0xc6c0

c_clean32:
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
c_writedatapointer:
	mov  global.regVal.w0,recvqueue.recvaddrhead_buf_uart3
	ldi  global.regVal.w2,0xc6c0
	
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4   //直接将存数据的地址传入
	
	ldi  global.regVal,0
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal, global.regPointer,0,4
	
	add  recvqueue.recvaddrhead_buf_uart3,recvqueue.recvaddrhead_buf_uart3,128 //队列头向后移128字节
	qbeq c_resetpointerw0,recvqueue.recvaddrhead_buf_uart3,recvqueue.recvbaseaddr_buf_uart3
	jmp  c_movehead
c_resetpointerw0:
	ldi recvqueue.recvaddrhead_buf_uart3,RECVBUF_ADDR_UART3
c_movehead:
	jmp  c_recvend

c_cleandata:
	ldi  global.regVal,0
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
c_recvend:
	jmp baudrateset

c_cleanall:
	ldi  global.regVal,0
	
	//记录buf内数据长度，低16位为队列头地址，高16位为队列尾地址。初始值清零。
	ldi  global.regPointer.w0, BUFHEADTAIL_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
	
	//读标志位置0   
	ldi  global.regPointer.w0, RECV_STATUS_FLAG_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4
	
	//地址数据指针区置0
	ldi  global.regPointer.w0, RECVDATA_ADDR_UART3
    ldi  global.regPointer.w2, 0x8000
	sbbo global.regVal,global.regPointer,0,4

	//接收缓存区置0
	ldi  global.regPointer.w0, RECVBUF_ADDR_UART3
    ldi  global.regPointer.w2, 0xc6c0
	
c_cleanall32:
	sbbo clrbuffer.block1,global.regPointer, 0,32
	sbbo clrbuffer.block1,global.regPointer,32,32
	sbbo clrbuffer.block1,global.regPointer,64,32
	sbbo clrbuffer.block1,global.regPointer,96,32
	
	set global.regVal,10
	ldi recvqueue.recvaddrtail_buf_uart3,RECVBUF_ADDR_UART3
	add recvqueue.recvbaseaddr_buf_uart3,recvqueue.recvaddrtail_buf_uart3,global.regVal
	ldi recvqueue.recvaddrhead_buf_uart3,RECVBUF_ADDR_UART3
	
	jmp baudrateset

//***************************c_RECVDATAEND*********************	

//**************************115200*****************************	
dlyau: //8000ns	
    ldi global.regPointer.b1,0x00
dlyau1:	
	ldi global.regPointer.b0,0x00
    ldi global.regPointer.b0,0x00
dlyau2:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dlyau2,global.regPointer.b0,227 

	add global.regPointer.b1,global.regPointer.b1,1
	qbgt dlyau1,global.regPointer.b1,4

	ldi global.regPointer.b0,0x00
	ldi global.regPointer.b0,0x00
dlyau3:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dlyau3,global.regPointer.b0,67
    ret
	
dly2au: //522ns
	ldi global.regPointer.b0,0x00
    ldi global.regPointer.b0,0x00
dly2au1:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dly2au1,global.regPointer.b0,58
	ret
	
//**************************19200*****************************
dlybu:   //(2000*x)+(x+1)*2*4.386=50228.072
	ldi global.regPointer.b1,0x00
dlybu1: //2000ns
	ldi global.regPointer.b0,0x00
    ldi global.regPointer.b0,0x00
dlybu2:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dlybu2,global.regPointer.b0,227
	
	add global.regPointer.b1,global.regPointer.b1,1
	qbgt dlybu1,global.regPointer.b1,25

	ldi global.regPointer.b0,0x00
dlybu3:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dlybu3,global.regPointer.b0,204//167//
    ret
	
dly2bu:   //3228.694
	ldi global.regPointer.b0,0x00
    ldi global.regPointer.b0,0x00
dly2bu2:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dly2bu2,global.regPointer.b0,227
   
    ldi global.regPointer.b0,0x00
	//ldi global.regPointer.b0,0x00
dly2bu4:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dly2bu4,global.regPointer.b0,139
    ret	

//**************************9600*****************************	
dlycu:   //x=51,(2000*x)+(x+1)*2*4.386  //102456.144ns
	ldi global.regPointer.b1,0x00
	//ldi global.regPointer.b1,0x00
dlycu1: //2000ns
	ldi global.regPointer.b0,0x00
    ldi global.regPointer.b0,0x00
dlycu2:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dlycu2,global.regPointer.b0,227	
	
	add global.regPointer.b1,global.regPointer.b1,1
	qbgt dlycu1,global.regPointer.b1,51  

	ldi global.regPointer.b0,0x00
	//ldi global.regPointer.b0,0x00
dlycu3:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dlycu3,global.regPointer.b0,187//144//78//88//标准电子称 读卡器      
    ret


dly2cu:   //6479.714875
	ldi global.regPointer.b1,0x00  //6038.88ns
	//ldi global.regPointer.b1,0x00

dly2cu1: //2000ns
	ldi global.regPointer.b0,0x00
    ldi global.regPointer.b0,0x00
dly2cu2:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dly2cu2,global.regPointer.b0,227
	
	add global.regPointer.b1,global.regPointer.b1,1
	qbgt dly2cu1,global.regPointer.b1,3  //循环25次
	
	ldi global.regPointer.b0,0x00
	//ldi global.regPointer.b0,0x00
dly2cu3:	
	add global.regPointer.b0,global.regPointer.b0,1
	qbgt dly2cu3,global.regPointer.b0,50
	ret	
	
//**************************9600******************************


// Send notification to Host for program completion
    MOV R31.b0, #PRU1_ARM_INTERRUPT
    HALT
.end