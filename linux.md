## 1. find 指令  查找指定文件

​	

​	· find ~ -name “target3.java”：精确查找文件

​	· find ~ -name “target*”：模糊查找文件

​	· find ~ -iname “target*”：不区分文件名大小写去查找文件

​	· ~ 为路径   不指定则从当前目录递归查找



## 2. grep 检索文件内容

 作用：<u>查找文件里符合条件的字符串</u>

![](\img\linux_grep_01.png)

![](\img\linux_grep_02.png)

### 管道操作符|

可将指令连接起来，前一个指令的输出作为后一个指令的输入

![](\img\linux_grep_03.png)

![](\img\linux_grep_04.png)



**使用管道注意的要点**

- 只处理前一个命令正确输入，不处理错误输出

- 右边命令必须能够接受标准输入流，否则传递过程中数据会被抛弃

- sed,awk,grep,cut,head,top,less,more,wc,join,sort,split等



### 常用方式

· grep ‘partial\\[true\\]’  bcs-plat-al-data.info.log

> 查找包含某个内容的文件，并将相关行展示出来

​	· grep -o ‘engine\\[[0-9a-z*\\]’

> 筛选出符合正则表达式的内容

​	· grep -v ‘grap’

> 过滤掉包含相关字符串的内容



## 3. awk 对文件内容做统计

![](\img\linux_awk_01.png)

-F：以什么符号作为分隔符进行切片

![](\img\linux_awk_02.png)



![](\img\linux_awk_03.png)



## 4. sed 指令

​	· 全名stream editor，流编辑器

​	· 适合用于对文本的行内容进行处理

> `sed` ‘/[要替换的内容]/[替换后的内容]/’，^str表示以str打头的字符串，开头s表示是对字符串进行的操作

> 默认是将变更的内容输出到终端，并不改变文件的内容

![](\img\linux_sed_01.png)

> 加入-i，则可以替换文本内容

![](\img\linux_sed_02.png)

> 句号换成分号，$表示以某某结尾

![](\img\linux_sed_03.png)

> 若加入g，则会全部替换，否则只替换一个

![](\img\linux_sed_04.png)

> 要删除空行，因为不是字符串，所以开头不加s，最后的d表示删除

![](\img\linux_sed_05.png)

> 根据Integer删除其所在行

![](\img\linux_sed_06.png)

## 5 I/O模型

### 阻塞式IO

- 使用系统调用，并一直阻塞直到内核将数据准备好，之后再由内核缓冲区复制到用户态，在等待内核准备的这段时间什么也干不了

- 下图函数调用期间，一直被阻塞，直到数据准备好且从内核复制到用户程序才返回，这种IO模型为阻塞式IO

- 阻塞式IO式最流行的IO模型 

  ![img](https://user-gold-cdn.xitu.io/2018/10/30/166c5502f8bcffc9?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

### 非阻塞式IO

- 内核在没有准备好数据的时候会返回错误码，而调用程序不会休眠，而是不断轮询询问内核数据是否准备好

- 下图函数调用时，如果数据没有准备好，不像阻塞式IO那样一直被阻塞，而是返回一个错误码。数据准备好时，函数成功返回。

- 应用程序对这样一个非阻塞描述符循环调用成为轮询。

- 非阻塞式IO的轮询会耗费大量cpu，通常在专门提供某一功能的系统中才会使用。通过为套接字的描述符属性设置非阻塞式，可使用该功能 

  ![img](https://user-gold-cdn.xitu.io/2018/10/30/166c553d1d575e5f?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

### IO多路复用

- 类似与非阻塞，只不过轮询不是由用户线程去执行，而是由内核去轮询，内核监听程序监听到数据准备好后，调用内核函数复制数据到用户态

- 下图中select这个系统调用，充当代理类的角色，不断轮询注册到它这里的所有需要IO的文件描述符，有结果时，把结果告诉被代理的recvfrom函数，它本尊再亲自出马去拿数据

- IO多路复用至少有两次系统调用，如果只有一个代理对象，性能上是不如前面的IO模型的，但是由于它可以同时监听很多套接字，所以性能比前两者高 

  ![img](https://user-gold-cdn.xitu.io/2018/10/30/166c5615fdf084fd?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

- 多路复用包括： 

  - select：线性扫描所有监听的文件描述符，不管他们是不是活跃的。有最大数量限制（32位系统1024，64位系统2048）
  - poll：同select，不过数据结构不同，需要分配一个pollfd结构数组，维护在内核中。它没有大小限制，不过需要很多复制操作
  - epoll：用于代替poll和select，没有大小限制。使用一个文件描述符管理多个文件描述符，使用红黑树存储。同时用事件驱动代替了轮询。epoll_ctl中注册的文件描述符在事件触发的时候会通过回调机制激活该文件描述符。epoll_wait便会收到通知。最后，epoll还采用了mmap虚拟内存映射技术减少用户态和内核态数据传输的开销

### 信号驱动式IO

- 使用信号，内核在数据准备就绪时通过信号来进行通知

- 首先开启信号驱动io套接字，并使用sigaction系统调用来安装信号处理程序，内核直接返回，不会阻塞用户态

- 数据准备好时，内核会发送SIGIO信号，收到信号后开始进行io操作 

  ![img](https://user-gold-cdn.xitu.io/2018/10/30/166c569138a05186?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

### 异步IO

- 异步IO依赖信号处理程序来进行通知

- 不过异步IO与前面IO模型不同的是：前面的都是数据准备阶段的阻塞与非阻塞，异步IO模型通知的是IO操作已经完成，而不是数据准备完成

- 异步IO才是真正的非阻塞，主进程只负责做自己的事情，等IO操作完成(数据成功从内核缓存区复制到应用程序缓冲区)时通过回调函数对数据进行处理

- unix中异步io函数以aio_或lio_打头 

  ![img](https://user-gold-cdn.xitu.io/2018/10/30/166c56cf32b82d81?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

### 各种IO模型对比

- 前面四种IO模型的主要区别在第一阶段，他们第二阶段是一样的：数据从内核缓冲区复制到调用者缓冲区期间都被阻塞住！

- 前面四种IO都是同步IO：IO操作导致请求进程阻塞，直到IO操作完成

- 异步IO：IO操作不导致请求进程阻塞 

  ![img](https://user-gold-cdn.xitu.io/2018/10/30/166c578ad18a1d40?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)



## 6 I/0多路复用

 I/O多路复用就是`通过一种机制，一个线程可以监视多个描述符，一旦某个描述符就绪（一般是读就绪或者写就绪），能够通知程序进行相应的读写操作`。 

 目前支持I/O多路复用的系统调用有 `select，poll，epoll` 

![](img/select_poll_epoll.png)

### 1、select

Linux提供的select相关函数接口如下：

```c

#include <sys/select.h>
#include <sys/time.h>
 
int select(int max_fd, fd_set *readset, fd_set *writeset, fd_set *exceptset, struct timeval *timeout)
FD_ZERO(int fd, fd_set* fds)   //清空集合
FD_SET(int fd, fd_set* fds)    //将给定的描述符加入集合
FD_ISSET(int fd, fd_set* fds)  //将给定的描述符从文件中删除  
FD_CLR(int fd, fd_set* fds)    //判断指定描述符是否在集合中

```

1. select函数的返回值就绪描述符的数目，超时时返回0，出错返回-1。
2. 第一个参数max_fd指待测试的fd个数，它的值是待测试的最大文件描述符加1，文件描述符从0开始到max_fd-1都将被测试。
3. 中间三个参数readset、writeset和exceptset指定要让内核测试**读、写**和**异常**条件的fd集合，如果不需要测试的可以设置为NULL。

整体的使用流程如下图：

![](img/select_01.jpg)

基于select的I/O复用模型的是单进程执行，占用资源少，可以为多个客户端服务。但是select需要轮询每一个描述符，在高并发时仍然会存在效率问题，同时select能支持的最大连接数通常受限。

 

### 2、poll

poll的机制与select类似，与select在本质上没有多大差别，管理多个描述符也是进行轮询，根据描述符的状态进行处理，但是poll没有最大文件描述符数量的限制。

Linux提供的poll函数接口如下：

```c
#include <poll.h>
int poll(struct pollfd fds[], nfds_t nfds, int timeout);
 
typedef struct pollfd {
        int fd;                         // 需要被检测或选择的文件描述符
        short events;                   // 对文件描述符fd上感兴趣的事件
        short revents;                  // 文件描述符fd上当前实际发生的事件*/
} pollfd_t;
```

1. poll()函数返回fds集合中就绪的读、写，或出错的描述符数量，返回0表示超时，返回-1表示出错；
2. fds是一个struct pollfd类型的数组，用于存放需要检测其状态的socket描述符，并且调用poll函数之后fds数组不会被清空；
3. nfds记录数组fds中描述符的总数量；
4. timeout是调用poll函数阻塞的超时时间，单位毫秒；
5. 一个pollfd结构体表示一个被监视的文件描述符，通过传递fds[]指示 poll() 监视多个文件描述符。其中，结构体的events域是监视该文件描述符的事件掩码，由用户来设置这个域，结构体的revents域是文件描述符的操作结果事件掩码，内核在调用返回时设置这个域。events域中请求的任何事件都可能在revents域中返回。


合法的事件如下：
POLLIN 有数据可读 
POLLRDNORM 有普通数据可读
POLLRDBAND 有优先数据可读
POLLPRI 有紧迫数据可读 
POLLOUT 写数据不会导致阻塞 
POLLWRNORM 写普通数据不会导致阻塞 POLLWRBAND 写优先数据不会导致阻塞 POLLMSGSIGPOLL 消息可用
当需要监听多个事件时，使用**POLLIN | POLLRDNORM**设置 events 域；当poll调用之后检测某事件是否发生时，**fds[i].revents & POLLIN**进行判断。

### 3、epoll

epoll在Linux2.6内核正式提出，是基于事件驱动的I/O方式，相对于select和poll来说，epoll没有描述符个数限制，使用一个文件描述符管理多个描述符，将用户关心的文件描述符的事件存放到内核的一个事件表中，这样在用户空间和内核空间的copy只需一次。优点如下：

1. 没有最大并发连接的限制，能打开的fd上限远大于1024（1G的内存能监听约10万个端口）
2. 采用回调的方式，效率提升。只有**活跃可用**的fd才会调用callback函数，也就是说 epoll 只管你“活跃”的连接，而跟连接总数无关，因此在实际的网络环境中，epoll的效率就会远远高于select和poll。
3. 内存拷贝。使用mmap()文件映射内存来加速与内核空间的消息传递，减少复制开销。

epoll对文件描述符的操作有两种模式：LT(level trigger，水平触发)和ET(edge trigger)。

- **水平触发：**默认工作模式，即当epoll_wait检测到某描述符事件就绪并通知应用程序时，应用程序可以不立即处理该事件；下次调用epoll_wait时，会再次通知此事件。
- **边缘触发：**当epoll_wait检测到某描述符事件就绪并通知应用程序时，应用程序必须立即处理该事件。如果不处理，下次调用epoll_wait时，不会再次通知此事件。（直到你做了某些操作导致该描述符变成未就绪状态了，也就是说边缘触发只在状态由未就绪变为就绪时通知一次）。

ET模式很大程度上减少了epoll事件的触发次数，因此效率比LT模式下高。

Linux中提供的epoll相关函数接口如下：

```c

#include <sys/epoll.h>
int epoll_create(int size);
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
int epoll_wait(int epfd, struct epoll_event * events, int maxevents, int timeout);
```

1. **epoll_create**函数创建一个epoll句柄，参数size表明内核要监听的描述符数量。调用成功时返回一个epoll句柄描述符，失败时返回-1。
2. **epoll_ct**l函数注册要监听的事件类型。四个参数解释如下：
   ![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) epfd表示epoll句柄；
   ![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) op表示fd操作类型：**EPOLL_CTL_ADD**（注册新的fd到epfd中），**EPOLL_CTL_MOD**（修改已注册的fd的监听事件），**EPOLL_CTL_DEL**（从epfd中删除一个fd）
   ![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) fd是要监听的描述符；
   ![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) event表示要监听的事件
   epoll_event结构体定义如下：

```c

struct epoll_event {
    __uint32_t events;  /* Epoll events */
    epoll_data_t data;  /* User data variable */
};
 
typedef union epoll_data {
    void *ptr;
    int fd;
    __uint32_t u32;
    __uint64_t u64;
} epoll_data_t;
```

3、 **epoll_wait**函数等待事件的就绪，成功时返回就绪的事件数目，调用失败时返回 -1，等待超时返回 0。
![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) epfd是epoll句柄
![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) events表示从内核得到的就绪事件集合
![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) maxevents告诉内核events的大小
![\circ](https://www.zhihu.com/equation?tex=%5Ccirc+) timeout表示等待的超时事件 

## 7、生产服务器变慢，定位以及性能评估

### top 整机

参考：

[top命令解析](https://www.cnblogs.com/poloyy/p/12551943.html)

[top监控列表解析](https://www.cnblogs.com/poloyy/p/12552041.html)

**使用方法**

> 查看所有进程的的资源占用情况    top
>
> 监控每个逻辑cpu的状况     按1
>
> 高亮显示当前运行进程    按b
>
> 显示完整命令   按c
>
> 切换显示cpu 按t
>
> 切换显示memory 按m
>
> 杀掉进程 按k 输入pid
>
> 改变内存的显示单位 按e 

**统计信息区**

[![img](https://img2020.cnblogs.com/blog/1896874/202003/1896874-20200323194657523-153388347.png)](https://img2020.cnblogs.com/blog/1896874/202003/1896874-20200323194657523-153388347.png)

<u>第一行 输出任务队列信息</u>

> - **18:46:38**：系统当前时间 
> - **up 2days 1:54**：系统开机后到现在的总运行时间
> - **1 user**：当前登录用户数
> - **load average: 0, 0.01, 0.05**：系统负载，系统运行队列的平均利用率，可认为是可运行进程的平均数；三个数值分别为 1分钟、5分钟、15分钟前到现在的平均值；单核CPU中load average的值=1时表示满负荷状态，多核CPU中满负载的load average值为1*CPU核数

<u>第二行：任务进程信息</u>

> - **total：**系统全部进程的数量
> - **running：**运行状态的进程数量
> - **sleeping：**睡眠状态的进程数量
> - **stoped：**停止状态的进程数量
> - **zombie：**僵尸进程数量

<u>第三行 cpu信息</u>

> - **us：**用户空间占用CPU百分比
> - **sy：**内核空间占用CPU百分比
> - **ni：**已调整优先级的用户进程的CPU百分比
> - **id：**空闲CPU百分比，越低说明CPU使用率越高
> - **wa：**等待IO完成的CPU百分比
> - **hi：**处理硬件中断的占用CPU百分比
> - **si：**处理软中断占用CPU百分比
> - **st：**虚拟机占用CPU百分比

<u>第四行 物理内存信息</u>

> 以下内存单位均为**MB**
>
> - **total**：物理内存总量
> - **free**：空闲内存总量
> - **used**：使用中内存总量
> - **buff/cacge**：用于内核缓存的内存量

<u>第五行 交换内存信息</u>

> - **total**：交换区总量
> - **free**：空闲交换区总量
> - **used**：使用的交换区总量
> - **avail Mem**：可用交换区总量

**问题：**内存空间还剩多少空闲呢？

**答案：**空闲内存=空闲内存总量+缓冲内存量 +可用交换区总量

**进程信息区**

[![img](https://img2020.cnblogs.com/blog/1896874/202003/1896874-20200323194713959-1380853505.png)](https://img2020.cnblogs.com/blog/1896874/202003/1896874-20200323194713959-1380853505.png)

> - **PID**：进程号
>
> - **USER**：运行进程的用户
>
> - **PR**：优先级
>
> - **NI**：nice值。负值表示高优先级，正值表示低优先级
>
> - **VIRT**：进程虚拟内存的大小，只要是进程申请过的内存，即便还没有真正分配物理内存，也会计算在内；VIRT=SWAP+RES
>
> - **RES**：进程实际使用的物理内存大小，不包括 Swap 和共享内存
>
> - **SHR**：共享内存大小，比如**与其他进程共同使用的**共享内存、加载的动态链接库以及程序的代码段等
>
> - **S**：进程状态 
>
>   > - R=运行状态
>   > - S=睡眠状态
>   > - D=不可中断的睡眠状态
>   > - T=跟踪/停止
>   > - Z=僵尸进程
>
> - **%CPU**：CPU 使用率
>
> - **%MEM**：进程使用武力内存占系统总内存的百分比
>
> - **TIME+**：上次启动后至今的总运行时间
>
> - **COMMAND**：命令名or命令行



### vmstat cpu 

> 可以展现给定时间间隔的服务器的状态值,包括服务器的CPU使用率，内存使用，虚拟内存交换情况,IO读写情况

使用方法：

vmstat 加两个参数   例如 **vmstat 2 3**  每两秒采集一次  一共采集3次

实际上，在应用过程中，我们会在一段时间内一直监控，不想监控直接结束vmstat就行了,例如:

```bash
root@ubuntu:~# vmstat 2  
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  0      0 3499840 315836 3819660    0    0     0     1    2    0  0  0 100  0
 0  0      0 3499584 315836 3819660    0    0     0     0   88  158  0  0 100  0
 0  0      0 3499708 315836 3819660    0    0     0     2   86  162  0  0 100  0
 0  0      0 3499708 315836 3819660    0    0     0    10   81  151  0  0 100  0
 1  0      0 3499732 315836 3819660    0    0     0     2   83  154  0  0 100  0
```

> **r** 表示运行队列(就是说多少个进程真的分配到CPU)，我测试的服务器目前CPU比较空闲，没什么程序在跑，当这个值超过了CPU数目，就会出现CPU瓶颈了。这个也和top的负载有关系，一般负载超过了3就比较高，超过了5就高，超过了10就不正常了，服务器的状态很危险。top的负载类似每秒的运行队列。如果运行队列过大，表示你的CPU很繁忙，一般会造成CPU使用率很高。
>
> **b** 表示阻塞的进程,这个不多说，进程阻塞，大家懂的。
>
> **swpd** 虚拟内存已使用的大小，如果大于0，表示你的机器物理内存不足了，如果不是程序内存泄露的原因，那么你该升级内存了或者把耗内存的任务迁移到其他机器。
>
> **free**  空闲的物理内存的大小，我的机器内存总共8G，剩余3415M。
>
> **buff**  Linux/Unix系统是用来存储，目录里面有什么内容，权限等的缓存，我本机大概占用300多M
>
> **cache** cache直接用来记忆我们打开的文件,给文件做缓冲，我本机大概占用300多M(这里是Linux/Unix的聪明之处，把空闲的物理内存的一部分拿来做文件和目录的缓存，是为了提高 程序执行的性能，当程序使用内存时，buffer/cached会很快地被使用。)
>
> **si** 每秒从磁盘读入虚拟内存的大小，如果这个值大于0，表示物理内存不够用或者内存泄露了，要查找耗内存进程解决掉。我的机器内存充裕，一切正常。
>
> **so** 每秒虚拟内存写入磁盘的大小，如果这个值大于0，同上。
>
> **bi** 块设备每秒接收的块数量，这里的块设备是指系统上所有的磁盘和其他块设备，默认块大小是1024byte，我本机上没什么IO操作，所以一直是0，但是我曾在处理拷贝大量数据(2-3T)的机器上看过可以达到140000/s，磁盘写入速度差不多140M每秒
>
> **bo** 块设备每秒发送的块数量，例如我们读取文件，bo就要大于0。bi和bo一般都要接近0，不然就是IO过于频繁，需要调整。
>
> **in** 每秒CPU的中断次数，包括时间中断
>
> **cs** 每秒上下文切换次数，例如我们调用系统函数，就要进行上下文切换，线程的切换，也要进程上下文切换，这个值要越小越好，太大了，要考虑调低线程或者进程的数目,例如在apache和nginx这种web服务器中，我们一般做性能测试时会进行几千并发甚至几万并发的测试，选择web服务器的进程可以由进程或者线程的峰值一直下调，压测，直到cs到一个比较小的值，这个进程和线程数就是比较合适的值了。系统调用也是，每次调用系统函数，我们的代码就会进入内核空间，导致上下文切换，这个是很耗资源，也要尽量避免频繁调用系统函数。上下文切换次数过多表示你的CPU大部分浪费在上下文切换，导致CPU干正经事的时间少了，CPU没有充分利用，是不可取的。
>
> **us** 用户CPU时间，我曾经在一个做加密解密很频繁的服务器上，可以看到us接近100,r运行队列达到80(机器在做压力测试，性能表现不佳)。
>
> **sy** 系统CPU时间，如果太高，表示系统调用时间长，例如是IO操作频繁。
>
> **id** 空闲 CPU时间，一般来说，id + us + sy = 100,一般我认为id是空闲CPU使用率，us是用户CPU使用率，sy是系统CPU使用率。
>
> **wt** 等待IO CPU时间。

#### mpstat 查看所有cpuhe核信息

用法  mpstat -P ALL 2   每两秒采集一次

#### pidstat 每个进程使用cpu的用量分解信息 

pidstat -u 1 -p 进程编号



### free 内存

用法  free

**查看额外**

pidstat -p 进程号 -r 采样间隔秒数



### df 硬盘

df -h   查看硬盘



### iostat 磁盘io 

磁盘性能评估

**查看额外**

pidstat -p 进程号 -r 采样间隔秒数



