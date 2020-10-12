## 1、Nosql概述

### CAP+BASE

传统的**ACID**：

> A (Atomicity) 原子性
>
> C (Consistency) 一致性
>
> I (Isolation) 独立性
>
> D (Durability) 持久性

#### CAP

 CAP理论的核心是：一个分布式系统不可能同时很好的满足一致性，可用性和分区容错性这三个需求，
最多只能同时较好的满足两个。
因此，根据 CAP 原理将 NoSQL 数据库分成了满足 CA 原则、满足 CP 原则和满足 AP 原则三 大类：
<font color='cornflowerblue'>CA - 单点集群，满足一致性，可用性的系统，通常在可扩展性上不太强大</font>。
<font color='cornflowerblue'>CP - 满足一致性，分区容忍必的系统，通常性能不是特别高。</font>
<font color='cornflowerblue'>AP - 满足可用性，分区容忍性的系统，通常可能对一致性要求低一些。</font>

> C:Consistency（强一致性）
>
> A:Availability（可用性）
>
> P:Partition tolerance（分区容错性）

![](\img\redis\cap.bmp)

**CAP的3进2**

CAP理论就是说在分布式存储系统中，最多只能实现上面的两点。
而由于当前的网络硬件肯定会出现延迟丢包等问题，所以

<font color='red'>分区容忍性是我们必须需要实现的。</font>

所以我们只能在**一致性**和**可用性**之间进行权衡，没有NoSQL系统能同时保证这三点。

**C:强一致性 A：高可用性 P：分布式容忍性**

<font color='cornflowerblue'>CA 传统Oracle数据库</font>

<font color='cornflowerblue'>AP 大多数网站架构的选择</font>

<font color='cornflowerblue'>CP Redis、Mongodb</font>

 注意：分布式架构的时候必须做出取舍。
一致性和可用性之间取一个平衡。多余大多数web应用，其实并不需要强一致性。

<font color='green'>因此牺牲C换取P，这是目前分布式数据库产品的方向</font>

#### BASE

BASE就是为了解决关系数据库强一致性引起的问题而引起的可用性降低而提出的解决方案。

BASE其实是下面三个术语的缩写：
   <font color='cornflowerblue'> 基本可用（Basically Available）</font>
    <font color='cornflowerblue'>软状态（Soft state）</font>
    <font color='cornflowerblue'>最终一致（Eventually consistent）</font>

> 它的思想是通过让系统放松对某一时刻数据一致性的要求来换取系统整体伸缩性和性能上改观。为什么这么说呢，缘由就在于大型系统往往由于地域分布和极高性能的要求，不可能采用分布式事务来完成这些指标，要想获得这些指标，我们必须采用另外一种方式来完成，这里BASE就是解决这个问题的办法



## 2、redis基础知识

### 单进程

单进程模型来处理客户端的请求。对读写等事件的响应是通过对epoll函数的包装来做到的。Redis的实际处理速度完全依靠主进程的执行效率

Epoll是Linux内核为处理大批量文件描述符而作了改进的epoll，是Linux下多路复用IO接口select/poll的增强版本，它能显著提高程序在大量并发连接中只有少量活跃的情况下的系统CPU利用率

## 3、Redis数据类型

操作文档：<font color='green'>http://redisdoc.com/</font>

![](\img\redis\reids_key.bmp)

### string

<font color='red'>value最大为512M</font>

string是redis最基本的类型，你可以理解成与Memcached一模一样的类型，一个key对应一个value。

string类型是二进制安全的。意思是redis的string可以包含任何数据。比如jpg图片或者序列化的对象 。

![](\img\redis\string_1.bmp)

![](\img\redis\string_2.bmp)

### list

它是一个字符串链表，left、right都可以插入添加；
如果键不存在，创建新的链表；
如果键已存在，新增内容；
如果值全移除，对应的键也就消失了。
链表的操作无论是头和尾效率都极高，但假如是对中间元素进行操作，效率就很惨淡了。

![](\img\redis\list_1.bmp)

![](\img\redis\list_2.bmp)