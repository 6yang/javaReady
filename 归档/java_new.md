# 1 . java基础

## 1. java修饰符

- **default** (即默认，什么也不写）: 在同一包内可见，不使用任何修饰符。使用对象：类、接口、变量、方法。
- **private** : 在同一类内可见。使用对象：变量、方法。 **注意：不能修饰类（外部类）**
- **public** : 对所有类可见。使用对象：类、接口、变量、方法
- **protected** : 对同一包内的类和所有子类可见。使用对象：变量、方法。 **注意：不能修饰类（外部类）**

## 2. 异常和错误

 **Throwable包含了错误(Error)和异常(Exception两类)** 

**Exception 包含**：

- 编译时异常（需要自己进行捕获处理）
- 运行期异常 （可以捕获也可以不捕获）  NullPointerException、IndexOutOfBoundsException 

**Error**

- 程序无法处理了直接终止线程

## 3. 封装、继承、多态

**封装**：

把客观事物封装成抽象的类，并且类可以把自己的数据和方法只让可信的类或者对象操作，对不可信的进行信息隐藏。封装是面向对象的特征之一，是对象和类概念的主要特性。 简单的说，<font color='red'> 一个类就是一个封装了数据以及操作这些数据的代码的逻辑实体。在一个对象内部，某些代码或某些数据可以是私有的，不能被外界访问。通过这种方式，对象对内部数据提供了不同级别的保护，以防止程序中无关的部分意外的改变或错误的使用了对象的私有部分。 </font>

**继承**：

<font color='red'>是指可以让某个类型的对象获得另一个类型的对象的属性的方法。</font>它支持按级分类的概念。继承是指这样一种能力：它可以使用现有类的所有功能，并在无需重新编写原来的类的情况下对这些功能进行扩展。 通过继承创建的新类称为“子类”或“派生类”，被继承的类称为“基类”、“父类”或“超类”。继承的过程，就是从一般到特殊的过程。要实现继承，可以通过“继承”（Inheritance）和“组合”（Composition）来实现。继承概念的实现方式有二类：<font color='cornflowerblue'>实现继承与接口继承。实现继承是指直接使用基类的属性和方法而无需额外编码的能力；接口继承是指仅使用属性和方法的名称、但是子类必须提供实现的能力；</font>

**多态**

<font color='cornflowerblue'> 是指一个类实例的相同方法在不同情形有不同表现形式。多态机制使具有不同内部结构的对象可以共享相同的外部接口 </font>。这意味着，虽然针对不同对象的具体操作不同，但通过一个公共的类，它们（那些操作）可以通过相同的方式予以调用。

### 多态的实现原理

[java多态的]( https://www.cnblogs.com/serendipity-fly/p/9469289.html )

**多态的分类**：编译时多态（静态多态，重载）和运行时多态（动态多态）

**多态的实现方法**：子类继承父类（extends）和类实现接口（implements）

多态的实现原理：

Java 的方法调用方式：Java 的方法调用有两类，动态方法调用与静态方法调用。<font color='red'>静态方法调用是指对于类的静态方法的调用方式，是静态绑定的</font>；<font color='cornflowerblue'>而动态方法调用需要有方法调用所作用的对象，是动态绑定的</font>。类调用 (invokestatic) 是在编译时刻就已经确定好具体调用方法的情况，而实例调用 (invokevirtual) 则是在调用的时候才确定具体的调用方法，这就是动态绑定，也是多态要解决的核心问题。JVM 的方法调用指令有四个，分别是 invokestatic，invokespecial，invokesvirtual 和 invokeinterface。前两个是静态绑定，后两个是动态绑定的。本文也可以说是对于 JVM 后两种调用实现的考察。

## 4. 子类的初始化顺序

1. 父类中静态成员变量和静态代码块

2. 子类中静态成员变量和静态代码块

3. 父类中普通成员变量和代码块，父类的构造函数

4. 子类中普通成员变量和代码块，子类的构造函数

##  5.static可以被继承么  

[static继承]( https://www.cnblogs.com/JMLiu/p/7515795.html )

1,<font color='red'>可以被继承，但是不能被重写</font>，如果父子类静态方法名相同，则会隐藏derive类方法（调用base类的方法）

2.<font color='cornflowerblue'>静态方法是编译时绑定的，方法重写是运行时绑定的。</font>

## 6. 重写equals方法时为什么要重写hashCode

<font color='#f37b1d'> 如果不重写hashcode只重写equals方法的话，放入set集合中会出现属性相等的对象 </font>

**1、首先我们看看对象默认的（Object）的equals方法和hashcode方法**

```java
public booleanequals(Object obj) {
return(this== obj);
}
public native inthashCode();
```

对象在不重写的情况下使用的是Object的equals方法和hashcode方法，从Object类的源码我们知道，默认的equals 判断的是两个对象的引用指向的是不是同一个对象；而hashcode也是根据对象地址生成一个整数数值；

![img](img/java/eq_and_hashcode.jpg)

**2、重写equals**

案例场景：

定义一个User对象有多个属性值姓名、年龄、身份证；

我们写代码的时候会发现，两个new 出来的User()对象 无论他们的的各项值是否一样两个对象equals 永远都是false，两个对象值完全一样放到HashSet里面它会把这两个值完全一样的对象当成两个不同的对象了，这样的话好像HashSet的特性就丢失了；

其实原因就是我们没有重写User 的equals方法，它会调用Object的equals方法，就如上图一样，Object的equals方法是比较对象的引用对象是否是同一个，两个new出来的对象当然不一样。

好了现在需求来了，我们需要两个对象的各项属性值一样的就认为这两个对象是相等的；那么此时我们就需要重写equals方法了；

代码如下：

```java
public classUser {
privateStringname;//姓名
privateStringIdCard;//身份证
private intage;//年龄
/**
* 重写equals
*@paramobj
*@return
*/
@Override
public boolean equals(Object obj) {
 if (obj instanceof User) {
        User user = (User) obj;
 if (user.getIdCard().equals(this.IdCard) && user.getName().equals(this.name) &&      user.getAge() == this.age) {
 return true;
        } else {
 return false;
        }
    } else {
 return false;
    }
}
//......省略N行代码
}
```

**那么现在关键的地方来了：**现在我们重写了User对象的equals方法，但并没有重写hashcode方法。

**（1）首先测试下equals的正确性**

```java
User user1=newUser();
user1.setName("路西");
user1.setAge(18);
user1.setIdCard("430");
User user2=newUser();
user2.setName("路西");
user2.setAge(18);
user2.setIdCard("430");
System.out.println("user1.equals(user2)="+user1.equals(user2));
user1.equals(user2)测试结果为true;
```

**(2)在两个对象equals的情况下进行把他们分别放入Map和Set中**

在上面的代码基础上追加如下代码：

```java
Set set =new HashSet();
set.add(user1);
set.add(user2);
Map map=newHashMap();
map.put(user1,"user1");
map.put(user2,"user2");
System.out.println("set 长度"+set.size());
System.out.println("map 长度"+map.keySet().size());;
```

测试打印结果为：



![img](img/java/hashcode_1.jpg)



好了现在问题来了，明明user1和user2两个对象是equals的那么为什么把他们放到set中会有两个对象（Set特性是不允许重复数据的），还有Map也把两个同样的对象当成了不同的Key（Map的Key是不允许重复的，相同Key会覆盖）；

**（3）这里我先抛出结果，至于原理后面再进行描述**

原因是user1和user2的hashcode 不一样导致的；

![img](img/java/hashcode_2.jpg)

因为我们没有重写父类（Object）的hashcode方法,Object的hashcode方法会根据两个对象的地址生成对相应的hashcode；

user1和user2是分别new出来的，那么他们的地址肯定是不一样的，自然hashcode值也会不一样。

Set区别对象是不是唯一的标准是，两个对象hashcode是不是一样，再判定两个对象是否equals;

Map 是先根据Key值的hashcode分配和获取对象保存数组下标的，然后再根据equals区分唯一值（详见下面的map分析）



**3、重写hashcode方法；**

```java
public classUser  {
privateStringname;//姓名
privateStringIdCard;//身份证
private intage;//年龄
/**
* 重写equals
*@paramobj
*@return
*/
@Override
public boolean equals(Object obj) {
 if (obj instanceof User) {
        User user = (User) obj;
 if (user.getIdCard().equals(this.IdCard) && user.getName().equals(this.name) && user.getAge() == this.age) {
 return true;
        } else {
 return false;
        }
    } else {
 return false;
    }
}

@Override
public int hashCode() {
 int result = name.hashCode();
    result = 31 * result + IdCard.hashCode();
    result = 31 * result + age;
 return result;
}
//......省略N行代码
}
```

我们按之前的流程重新测试一遍结果：

```java
User user1=newUser();
user1.setName("路西");
user1.setAge(18);
user1.setIdCard("430");
User user2=newUser();
user2.setName("路西");
user2.setAge(18);
user2.setIdCard("430");
System.out.println("user1.equals(user2)="+user1.equals(user2));
Set set =newHashSet();
set.add(user1);
set.add(user2);
Map map=newHashMap();
map.put(user1,"user1");
map.put(user2,"user2");
System.out.println("set 长度"+set.size());
System.out.println("map 长度"+map.keySet().size());;
System.out.println("user1的hashcode"+user1.hashCode());
System.out.println("user2的hashcode"+user2.hashCode());
```

打印结果：

![img](img/java/hashcode_3.jpg)

## 7. 抽象类和接口的区别



| 比较       | 抽象类                                                       | 接口                                   |
| :--------- | :----------------------------------------------------------- | -------------------------------------- |
| 默认方法   | 可以有默认方法                                               | jdk8之前没有默认方法                   |
| 实现方式   | 使用extends关键字来继承抽象类，如果子类不是抽象类，那么子类需要提供抽象类中的所有方法实现 | 子类通过implements来实现接口，子类需要 |
| 构造器     | 可以有构造器，但是不能实例化                                 | 不能有构造器                           |
| 访问修饰符 | 抽象方法有public，protected,default等修饰符                  | 只能public                             |
| 多继承     | 一个子类只能继承一个父类                                     | 一个类可以实现多个接口                 |
| 添加新方法 | 抽象类中添加新方法可以支持默认实现，因此可以不需要修改子类   | 子类需要重写新方法                     |

区别：

<img src="img/abstactANDinterface.png" alt="1603944334744" style="zoom:150%;" />

## 8. 重载，重写

**重写**

 <font color='green'> 	重写指子类实现接口或继承父类时，保持方法签名完全相同，实现不同方法体 </font> 

<font color='red'> 两同 </font>（方法名和形参列表），

<font color='red'>两小</font>（子类方法的返回类型和异常类型必须是父类的对应类型或者其子类型）

<font color='red'>一大</font>（子类的访问权限必须大于等于父类）。

<font color='cornflowerblue'> 只发生在可见实例方法中，不能在静态方法和私有方法中 </font>。

**重载**

​         <font color='green'> 方法名一致，形参列表不同。无所谓返回值多少，不作为判断依据。   </font>

​         对编译器来说，方法名称和参数列表组成了一个唯一键，称为方法签名，JVM 通过方法签名决定调用哪种重载方法  

## 9. jdk和jre

JDK： Java Development Kit，开发工具包。提供了编译运行 Java 程序的各种工具，包括编译器、JRE 及常用类库，是 JAVA 核心。

JRE： Java Runtime Environment，运行时环境，运行 Java 程序的必要环境，包括 JVM、核心类库、核心配置工具。

## 10. jdk8新特性

- lambda 表达式：允许把函数作为参数传递到方法，简化匿名内部类代码。
- 函数式接口：使用 @FunctionalInterface 标识，有且仅有一个抽象方法，可被隐式转换为 lambda 表达式。
- 方法引用：可以引用已有类或对象的方法和构造方法，进一步简化 lambda 表达式。
- 接口：接口可以定义 default 修饰的默认方法，降低了接口升级的复杂性，还可以定义静态方法。
- 注解：引入重复注解机制，相同注解在同地方可以声明多次。注解作用范围也进行了扩展，可作用于局部变量、泛型、方法异常等。
- 类型推测：加强了类型推测机制，使代码更加简洁。
- Optional 类：处理空指针异常，提高代码可读性。
- Stream 类：引入函数式编程风格，提供了很多功能，使代码更加简洁。方法包括 forEach 遍历、count 统计个数、filter 按条件过滤、limit 取前 n 个元素、skip 跳过前 n 个元素、map 映射加工、concat 合并 stream 流等。
- 日期：增强了日期和时间 API，新的 java.time 包主要包含了处理日期、时间、日期/时间、时区、时刻和时钟等操作。
- JavaScript：提供了一个新的 JavaScript 引擎，允许在 JVM上运行特定 JavaScript 应用。

## 11. 基本数据类型

<img src="img/basicNUmber.png" alt="1603945832200" style="zoom:150%;" />

<font color='red'> JVM 没有 boolean 赋值的专用字节码指令，boolean f = false 就是使用 ICONST_0 即常数 0 赋值。单个 boolean 变量用 int 代替，boolean 数组会编码成 byte 数组。 </font>

## 12. 自动拆箱和自动装箱

每个基本数据类型都对应一个包装类，除了 int 和 char 对应 Integer 和 Character 外，其余基本数据类型的包装类都是首字母大写即可。

**自动装箱**： <font color='cornflowerblue'> 将基本数据类型包装为一个包装类对象 </font>，例如向一个泛型为 Integer 的集合添加 int 元素。w

**自动拆箱**： <font color='cornflowerblue'> 将一个包装类对象转换为一个基本数据类型，例如将一个包装类对象赋值给一个基本数据类型的变量 </font>。

<font color='red'> 比较两个包装类数值要用 equals ，而不能用 == 。 </font>

## 13. Object的方法  

<font color='cornflowerblue'>1、equals() </font>

检测对象是否相等，默认使用 == 比较对象引用，可以重写 equals 方法自定义比较规则。equals 方法规范：自反性、对称性、传递性、一致性、对于任何非空引用 x，x.equals(null) 返回 false。

 （1）检查是否为同一个对象的引用，如果是直接返回 true；
 （2）检查是否是同一个类型，如果不是，直接返回 false；
 （3）将 Object 对象进行转型；
 （4）判断每个关键域是否相等。
 等价与相等的区别
 对于基本类型，== 判断两个值是否相等，基本类型没有 equals() 方法。
 对于引用类型，== 判断两个变量是否引用同一个对象，而 equals() 判断引用的对象是否等价。

<font color='cornflowerblue'> 2、hashCode() </font>

返回哈希值，HashSet 和 HashMap 等集合类使用了 hashCode() 方法来返回在hash表中对应的位置。散列码是由对象导出的一个整型值，没有规律，每个对象都有默认散列码，值由对象存储地址得出。字符串散列码由内容导出，值可能相同。为了在集合中正确使用，一般需要同时重写 equals 和 hashCode，要求 equals 相同 hashCode 必须相同，hashCode 相同 equals 未必相同，因此 hashCode 是对象相等的必要不充分条件。

<font color='cornflowerblue'>3、toString()</font> 

用于返回以一个字符串表示的 Number 对象值。打印对象时默认的方法，如果没有重写打印的是表示对象值的一个字符串。

<font color='cornflowerblue'> 4、clone()【浅拷贝和深拷贝的区别】 </font>

clone 方法声明为 protected，类只能通过该方法克隆它自己的对象，如果希望其他类也能调用该方法必须定义该方法为 public。如果一个对象的类没有实现 Cloneable 接口，该对象调用 clone 方***抛出一个 CloneNotSupport 异常。默认的 clone 方法是浅拷贝，一般重写 clone 方法需要实现 Cloneable 接口并指定访问修饰符为 public。

用于拷贝对象，分为浅拷贝和深拷贝：

**浅拷贝**： 只复制当前对象的基本数据类型及引用变量，没有复制引用变量指向的实际对象。修改克隆对象可能影响原对象，不安全。
 **深拷贝**： 完全拷贝基本数据类型和引用数据类型，安全。

<font color='red'> 5、finalize() </font>

确定一个对象死亡至少要经过两次标记，如果对象在可达性分析后发现没有与 GC Roots 连接的引用链会被第一次标记，随后进行一次筛选，条件是对象是否有必要执行 finalize 方法。假如对象没有重写该方法或方法已被虚拟机调用，都视为没有必要执行。如果有必要执行，对象会被放置在 F-Queue 队列，由一条低调度优先级的 Finalizer 线程去执行。虚拟机会触发该方法但不保证会结束，这是为了防止某个对象的 finalize 方法执行缓慢或发生死循环。只要对象在 finalize 方法中重新与引用链上的对象建立关联就会在第二次标记时被移出回收集合。由于运行代价高昂且无法保证调用顺序，在 JDK 9 被标记为过时方法，并不适合释放资源。

<font color='cornflowerblue'>6、wait() / notify() / notifyAll()</font>

阻塞或唤醒持有该对象锁的线程。

<font color='cornflowerblue'> 7、getClass </font>

返回包含对象信息的类对象。

## 14. string stringbuffer 和 stringbuilder 区别

**String**: 是<font color='#f37b1d'> 被final修饰的不可变类 </font>，每次对其操作都可以生成一个新的对象

StringBuffer和StringBuilder 都是<font color='#f37b1d'> 可变类 </font>，任何对它们所指代的字符串的改变都不会产生新的对象，不过StringBuffer是线程安全的，支持并发操作，StringBuilder是线程不安全的，不支持并发操作。 StringBuilder类不是线程安全的，但其在单线程中的性能比StringBuffer高。 

### **1.**    **String**不可变的原因：

<font color='cornflowerblue'>被声明为 final，因此它不可被继承</font>。(Integer 等包装类也不能被继承）。String 类和其存储数据的成员变量 value 字节数组都是 final 修饰的。<font color='cornflowerblue'> 对一个 String 对象的任何修改实际上都是创建一个新 String 对象，再引用该对象。只是修改 String 变量引用的对象，没有修改原 String 对象的内容 </font>。

### 2. String不可变的好处：

（1）可以作为hashmap的key
 （2）String Pool 的需要
 （3）安全性，经常作为参数，保证不可变
 （4）线程安全

### 3. 字符串拼接的方式

① <font color='cornflowerblue'> 直接用 +  </font>，底层用 StringBuilder 实现。只适用小数量，如果在循环中使用 + 拼接，<font color='red'>相当于不断创建新的 StringBuilder 对象再转换成 String 对象，效率极差</font>。

② <font color='cornflowerblue'>使用 String 的 concat 方法</font>，<font color='red'>该方法中使用 Arrays.copyOf 创建一个新的字符数组 buf 并将当前字符串 value 数组的值拷贝到 buf 中，buf 长度 = 当前字符串长度 + 拼接字符串长度。</font><font color='red'> 之后调用 getChars 方法使用 System.arraycopy 将拼接字符串的值也拷贝到 buf 数组，最后用 buf 作为构造参数 new 一个新的 String 对象返回 </font>。效率稍高于直接使用 +。

③<font color='cornflowerblue'>  使用 StringBuilder 或 StringBuffer </font>，两者的 append 方法都继承自 AbstractStringBuilder，该方法首先使用 Arrays.copyOf 确定新的字符数组容量，再调用 getChars 方法使用 System.arraycopy 将新的值追加到数组中。StringBuilder 是 JDK5 引入的，效率高但线程不安全。StringBuffer 使用 synchronized 保证线程安全。

> 耗费时间
>
> ＋ >concat() >StringBuffer > StringBuilder
>
> String x = "a1" + "a2"; 编译之后代码就变成了
>
> String x = (new StringBuilder("a1")).append("a2").toString()
>
> 上面的操作显然对多次相加不利

### 4. String a = "a" + new String("b") 创建了几个对象？

<font color='cornflowerblue'> 常量和常量拼接仍是常量，结果在常量池 </font>，<font color='cornflowerblue'> 只要有变量参与拼接结果就是变量，存在堆 </font>。

使用字面量时只创建一个常量池中的常量，<font color='cornflowerblue'>使用 new 时如果常量池中没有该值就会在常量池中新创建，再在堆中创建一个对象引用常量池中常量</font>。因此 String a = "a" + new String("b") 会创建四个对象，常量池中的 a 和 b，堆中的 b 和堆中的 ab。

### 5. String在new和直接赋值时的区别

new是在堆上新建一个对象，直接赋值时指向字符串常量池中 

## 15. final，finalize， finally有什么区别。

finalize的作用以及使用场景，final关键字的作用。

final关键字，final常量存储位置，常量池的好处；

### **1、finalize**

<font color='cornflowerblue'> 一旦垃圾回收器准备释放对象占用的内存空间,将首先调用finalize方法,并且在下一次垃圾回收动作发生,才会真正的回收该对象占用的内存,也就是finalize方法会在垃圾回收器真正回收对象之前调用 </font>。
 使用场景：gc会清理由new分配的内存，finalize清理不是new分配的内存对象，通常用于当对象被回收的时候释放一些资源，比如：一个socket链接，在对象初始化时创建，整个生命周期内有效，那么就需要实现finalize，关闭这个链接。

特殊性：<font color='red'> 一个对象的finalize()方法只会被调用一次，而且finalize()被调用不意味着gc会立即回收该对象，所以有可能调用finalize()后，该对象又不需要被回收了，然后到了真正要被回收的时候，因为前面调用过一次，所以不会调用finalize()，产生问题。所以，推荐不要使用finalize()方法，它跟析构函数不一样。 </font>

### **2、final**

在java中，<font color='cornflowerblue'> final可以用来修饰类，方法和变量（成员变量或局部变量） </font>。

1、<font color='cornflowerblue'>被final修饰的类不可以被继承</font>

2、被<font color='cornflowerblue'>final修饰的方法不可以被重写</font>

 3、<font color='cornflowerblue'> 用final修饰的属性必须要直接赋值或者在构造方法中赋值，并且赋值以后不可更改 </font>

 **不可变的是变量的引用而非引用指向对象的内容** 

4、<font color='cornflowerblue'> 被final修饰的参数不可以被更改 </font>

当函数参数为final类型时，你可以读取使用该参数，但是无法改变该参数的值。

在java中，String被设计成final类，那为什么平时使用时，String的值可以被改变呢？字符串常量池是java堆内存中一个特殊的存储区域，当我们建立一个String对象时，假设常量池不存在该字符串，则创建一个，若存在则直接引用已经存在的字符串。当我们对String对象值改变的时候，例如 String a="A"; a="B" 。a是String对象的一个引用（我们这里所说的String对象其实是指字符串常量），当a=“B”执行时，并不是原本String对象("A")发生改变，而是创建一个新的对象("B")，令a引用它。

**常量池的好处：**

常量池是为了避免频繁的创建和销毁对象而影响系统性能，其实现了对象的共享。例如字符串常量池，在编译阶段就把所有的字符串文字放到一个常量池中。

（1）节省内存空间：常量池中所有相同的字符串常量被合并，只占用一个空间。

（2）节省运行时间：比较字符串时，==比equals()快。对于两个引用变量，只用==判断引用是否相等，也就可以判断实际值是否相等。【对于基本类型，== 判断两个值是否相等，基本类型没有 equals() 方法。对于引用类型，== 判断两个变量是否引用同一个对象，而 equals() 判断引用的对象是否等价。】

**一个类不能被继承，除了final****关键字之外，还有什么方法**

<font color='orange'> 将一个类的构造器用private修饰，其他类就没有访问权限了。  </font>

### 3、finally

finally作为异常处理的一部分，它只能用在try/catch语句中，并且附带一个语句块，表示这段语句最终一定会被执行（不管有没有抛出异常），经常被用在需要释放资源的情况下。（×）（这句话其实存在一定的问题，finally不会被执行的几种情况）

- 在执行try语句块之前已经返回或抛出异常，所以try对应的finally语句并没有执行。
- 在 try 语句块中执行了 System.exit (0) 语句，终止了 Java 虚拟机的运行。
- 当一个线程在执行 try 语句块或者 catch 语句块时被打断（interrupted）或者被终止（killed），与其相对应的 finally 语句块可能不会执行。还有更极端的情况，就是在线程运行 try 语句块或者 catch 语句块时，突然死机或者断电，finally 语句块肯定不会执行了。

<font color='red'> 易错点：当try和catch中有return，且确保正确运行情况下，在return前会先执行finally ，如果finally中也有return的话，会返回finally中return的结果 </font>

## 16. 泛型

### 1、泛型定义

<font color='red'>泛型是对 Java 语言的类型系统的一种扩展，以支持创建可以按类型进行参数化的类<</font>。可以把类型参数看作是使用参数化类型时指定的类型的一个占位符，就像方法的形式参数是运行时传递的值的占位符一样。允许在定义接口、类时声明类型形参，类型形参在整个接口、类体内可当成类型使用，几乎所有可使用普通类型的地方都可以使用这种类型形参。

### 2、泛型的目的

Java 泛型就是把一种语法糖（在计算机语言中添加的某种语法，这种语法对语言的功能并没有影响，但是更方便程序员使用。Java中最常用的语法糖主要有泛型、变长参数、条件编译、自动拆装箱、内部类等。）<font color='red'> ，通过泛型使得在编译阶段完成一些类型转换的工作，避免在运行时强制类型转换而出现 ClassCastException ，即类型转换异常。 </font>

### 3、泛型的好处：

①<font color='red'> 类型安全。类型错误现在在编译期间就被捕获到了 </font>，而不是在运行时当作java.lang.ClassCastException展示出来，将类型检查从运行时挪到编译时有助于开发者更容易找到错误，并提高程序的可靠性。

②<font color='red'> 消除了代码中许多的强制类型转换 </font>，增强了代码的可读性，编码阶段就显式知道泛型集合、泛型方法等处理的对象类型。

③ <font color='red'> 代码重用 </font>，合并了同类型的处理代码。

### 4、Java的泛型是如何工作的 ? 什么是类型擦除 ?

泛型是通过类型擦除来实现的，编译器在编译时擦除了所有类型相关的信息，所以在运行时不存在任何类型相关的信息。例如List<String>在运行时仅用一个List来表示。这样做的目的，是确保能和Java 5之前的版本开发二进制类库进行兼容。你无法在运行时访问到类型参数，因为编译器已经把泛型类型转换成了原始类型。因为不管为泛型的类型形参传入哪一种类型实参，对于Java来说，它们依然被当成同一类处理，在内存中也只占用一块内存空间。从Java泛型这一概念提出的目的来看，其只是作用于代码编译阶段，在编译过程中，对于正确检验泛型结果后，会将泛型的相关信息擦出，也就是说，成功编译过后的class文件中是不包含任何泛型信息的。泛型信息不会进入到运行时阶段。在静态方法、静态初始化块或者静态变量的声明和初始化中不允许使用类型形参。由于系统中并不会真正生成泛型类，所以instanceof运算符后不能使用泛型类。

### 5、什么是泛型中的限定通配符和非限定通配符

限定通配符对类型进行了限制。有两种限定通配符，一种是<? extends T>可以接受任何继承自T的类型的List，它通过确保类型必须是T的子类来设定类型的上界，另一种是<? super T>可以接受任何T的父类构成的List，它通过确保类型必须是T的父类来设定类型的下界。泛型类型必须用限定内的类型来进行初始化，否则会导致编译错误。另一方面<?>表示了非限定通配符，因为<?>可以用任意类型来替代。

### 6、List<A>类型的list,可以加入无继承关系的B类型对象吗？如何加入

可以通过反射添加其它类型元素。在程序中定义了一个ArrayList泛型类型实例化为Integer对象，如果直接调用add()方法，那么只能存储整数数据，不过当我们利用反射调用add()方法的时候，却可以存储字符串，<font color='red'>这说明了Integer泛型实例在编译之后被擦除掉了，只保留了原始类型</font>。

```java
public class genericsTest {
    public static void main(String[] args) throws Exception {
        ArrayList<Integer> list = new ArrayList<>();
        list.add(1);
        list.getClass().getMethod("add",Object.class).invoke(list,"asd");
        for (int i = 0; i < list.size(); i++) {
            System.out.println(list.get(i));
        }
    }
}
```



# 2. 集合

## 1. Map vs Set vs List

| 比较     | list                 | set             | map             |
| -------- | -------------------- | --------------- | --------------- |
| 继承接口 | collection           | collection      |                 |
| 实现类   | ArrayList LinkedList | HashSet TreeSet | HaspMap TreeMap |
| 元素     | 可重复               | 不可重复        | 不可重复        |
| 顺序     | 有序                 | 无序            | 无序            |
| 线程安全 | Vector               |                 | HashTable       |

### 1.1 **List(列表)**

  <font color='cornflowerblue'> List的元素以线性方式存储，可以存放重复对象 </font>，List主要有以下两个实现类：

**ArrayList** : 长度可变的数组，可以对元素进行随机的访问，向ArrayList中插入与删除元素的速度慢。 JDK8 中ArrayList扩容的实现是通过grow()方法里使用语句newCapacity = oldCapacity + (oldCapacity >> 1)（即<font color='cornflowerblue'> 1.5倍扩容 </font>）计算容量，然后调用Arrays.copyof()方法进行对原数组进行复制。

**LinkedList**: 采用链表数据结构，插入和删除速度快，但访问速度慢。

### 1.2 **Set(集合)**

  Set中的对象不按特定(HashCode)的方式排序，并且<font color='cornflowerblue'> 没有重复对象 </font>，Set主要有以下两个实现类：

HashSet： HashSet按照哈希算法来存取集合中的对象，存取速度比较快。当HashSet中的元素个数超过数组大小*loadFactor（默认值为0.75）时，就会进行<font color='cornflowerblue'> 近似两倍扩容 </font>（newCapacity = (oldCapacity << 1) + 1）。
TreeSet ：TreeSet实现了SortedSet接口，能够对集合中的对象进行排序

### 1.3 **Map(映射)**

  Map是一种把键对象和值对象映射的集合，它的每一个元素都包含一个键对象和值对象。 Map主要有以下两个实现类：

<font color='#f37b1d'> HashMap </font>：HashMap基于散列表实现，其插入和查询<K,V>的开销是固定的，可以通过构造器设置容量和负载因子来调整容器的性能。
<font color='#f37b1d'>LinkedHashMap</font>：类似于HashMap，但是迭代遍历它时，取得<K,V>的顺序是其插入次序，或者是最近最少使用(LRU)的次序。
<font color='#f37b1d'> TreeMap </font>：TreeMap基于红黑树实现。查看<K,V>时，它们会被排序。TreeMap是唯一的带有subMap()方法的Map，subMap()可以返回一个子树。

## 2 、Map

### 2.1 HashMap

#### 2.1.1 put 过程

<img src="img/java/hashmap_put.png" style="zoom:67%;" />



```java
 1 public V put(K key, V value) {
 2     // 对key的hashCode()做hash
 3     return putVal(hash(key), key, value, false, true);
 4 }
 5 
 6 final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
 7                boolean evict) {
 8     Node<K,V>[] tab; Node<K,V> p; int n, i;
 9     // 步骤①：tab为空则创建
10     if ((tab = table) == null || (n = tab.length) == 0)
11         n = (tab = resize()).length;
12     // 步骤②：计算index，并对null做处理 
13     if ((p = tab[i = (n - 1) & hash]) == null) 
14         tab[i] = newNode(hash, key, value, null);
15     else {
16         Node<K,V> e; K k;
17         // 步骤③：节点key存在，直接覆盖value
18         if (p.hash == hash &&
19             ((k = p.key) == key || (key != null && key.equals(k))))
20             e = p;
21         // 步骤④：判断该链为红黑树
22         else if (p instanceof TreeNode)
23             e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
24         // 步骤⑤：该链为链表
25         else {
26             for (int binCount = 0; ; ++binCount) {
27                 if ((e = p.next) == null) {
28                     p.next = newNode(hash, key,value,null);
                        //链表长度大于8转换为红黑树进行处理
29                     if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st  
30                         treeifyBin(tab, hash);
31                     break;
32                 }
                    // key已经存在直接覆盖value
33                 if (e.hash == hash &&
34                     ((k = e.key) == key || (key != null && key.equals(k)))) 
35							break;
36                 p = e;
37             }
38         }
39         
40         if (e != null) { // existing mapping for key
41             V oldValue = e.value;
42             if (!onlyIfAbsent || oldValue == null)
43                 e.value = value;
44             afterNodeAccess(e);
45             return oldValue;
46         }
47     }

48     ++modCount;
49     // 步骤⑥：超过最大容量 就扩容
50     if (++size > threshold)
51         resize();
52     afterNodeInsertion(evict);
53     return null;
54 }

```

#### 2.1.2 get 过程

 <img src="img/java/hashmap_get_01.png" style="zoom:50%;" />

```java
public V get(Object key) {
        Node<K,V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
    }
	  /**
     * Implements Map.get and related methods
     *
     * @param hash hash for key
     * @param key the key
     * @return the node, or null if none
     */
	final Node<K,V> getNode(int hash, Object key) {
        Node<K,V>[] tab;//Entry对象数组
	Node<K,V> first,e; //在tab数组中经过散列的第一个位置
	int n;
	K k;
	/*找到插入的第一个Node，方法是hash值和n-1相与，tab[(n - 1) & hash]*/
	//也就是说在一条链上的hash值相同的
        if ((tab = table) != null && (n = tab.length) > 0 &&(first = tab[(n - 1) & hash]) != null) {
	/*检查第一个Node是不是要找的Node*/
            if (first.hash == hash && // always check first node
                ((k = first.key) == key || (key != null && key.equals(k))))//判断条件是hash值要相同，key值要相同
                return first;
	  /*检查first后面的node*/
            if ((e = first.next) != null) {
                if (first instanceof TreeNode)
                    return ((TreeNode<K,V>)first).getTreeNode(hash, key);
				/*遍历后面的链表，找到key值和hash值都相同的Node*/
                do {
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        return e;
                } while ((e = e.next) != null);
            }
        }
        return null;
    }
```

get(key)方法时获取key的hash值，计算hash&(n-1)得到在链表数组中的位置first=tab[hash&(n-1)],先判断first的key是否与参数key相等，不等就遍历后面的链表找到相同的key值返回对应的Value值即可 

#### 2.1.3  resize()

<img src="img/java/hashmapp_resize_01.png" style="zoom: 60%;" />

```java
/**
     * Initializes or doubles table size.  If null, allocates in
     * accord with initial capacity target held in field threshold.
     * Otherwise, because we are using power-of-two expansion, the
     * elements from each bin must either stay at same index, or move
     * with a power of two offset in the new table.
     *
     * @return the table
     */
    final Node<K,V>[] resize() {
        Node<K,V>[] oldTab = table;
        int oldCap = (oldTab == null) ? 0 : oldTab.length;
        int oldThr = threshold;
        int newCap, newThr = 0;
		
	/*如果旧表的长度不是空*/
        if (oldCap > 0) {
            if (oldCap >= MAXIMUM_CAPACITY) {
                threshold = Integer.MAX_VALUE;
                return oldTab;
            }
	/*把新表的长度设置为旧表长度的两倍，newCap=2*oldCap*/
            else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
                     oldCap >= DEFAULT_INITIAL_CAPACITY)
	      /*把新表的门限设置为旧表门限的两倍，newThr=oldThr*2*/
                newThr = oldThr << 1; // double threshold
        }
     /*如果旧表的长度的是0，就是说第一次初始化表*/
        else if (oldThr > 0) // initial capacity was placed in threshold
            newCap = oldThr;
        else {               // zero initial threshold signifies using defaults
            newCap = DEFAULT_INITIAL_CAPACITY;
            newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
        }
		
		
		
        if (newThr == 0) {
            float ft = (float)newCap * loadFactor;//新表长度乘以加载因子
            newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ?
                      (int)ft : Integer.MAX_VALUE);
        }
        threshold = newThr;
        @SuppressWarnings({"rawtypes","unchecked"})
	/*下面开始构造新表，初始化表中的数据*/
        Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
        table = newTab;//把新表赋值给table
        if (oldTab != null) {//原表不是空要把原表中数据移动到新表中	
            /*遍历原来的旧表*/		
            for (int j = 0; j < oldCap; ++j) {
                Node<K,V> e;
                if ((e = oldTab[j]) != null) {
                    oldTab[j] = null;
                    if (e.next == null)//说明这个node没有链表直接放在新表的e.hash & (newCap - 1)位置
                        newTab[e.hash & (newCap - 1)] = e;
                    else if (e instanceof TreeNode)
                        ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
	/*如果e后边有链表,到这里表示e后面带着个单链表，需要遍历单链表，将每个结点重*/
                    else { // preserve order保证顺序
					////新计算在新表的位置，并进行搬运
                        Node<K,V> loHead = null, loTail = null;
                        Node<K,V> hiHead = null, hiTail = null;
                        Node<K,V> next;
						
                        do {
                            next = e.next;//记录下一个结点
			  //新表是旧表的两倍容量，实例上就把单链表拆分为两队，
　　　　　　　　　　　　　　//e.hash&oldCap为偶数一队，e.hash&oldCap为奇数一对
                            if ((e.hash & oldCap) == 0) {
                                if (loTail == null)
                                    loHead = e;
                                else
                                    loTail.next = e;
                                loTail = e;
                            }
                            else {
                                if (hiTail == null)
                                    hiHead = e;
                                else
                                    hiTail.next = e;
                                hiTail = e;
                            }
                        } while ((e = next) != null);
						
                        if (loTail != null) {//lo队不为null，放在新表原位置
                            loTail.next = null;
                            newTab[j] = loHead;
                        }
                        if (hiTail != null) {//hi队不为null，放在新表j+oldCap位置
                            hiTail.next = null;
                            newTab[j + oldCap] = hiHead;
                        }
                    }
                }
            }
        }
        return newTab;
    }
```



### 2.2、HashMap&ConCurrentHashMap

[hashmap & currentHashMap]: https://crossoverjie.top/2018/07/23/java-senior/ConcurrentHashMap/

 jdk1.7 ConcurrentHashMap 采用了分段锁技术，其中 Segment 继承于 ReentrantLock。不会像 HashTable 那样不管是 put 还是 get 操作都需要做同步处理， 



#### 2.2.1 hashmap1.8 做了什么优化？

>  1.7当 Hash 冲突严重时，在桶上形成的链表会变的越来越长，这样在查询时的效率就会越来越低；时间复杂度为 `O(N)`。 

因此1.8 重点优化了这个部分，使用了hash表+链表+红黑树来实现

> put操作

1. 判断当前桶是否为空，空的就需要初始化（resize 中会判断是否进行初始化）。
2. 根据当前 key 的 hashcode 定位到具体的桶中并判断是否为空，为空表明没有 Hash 冲突就直接在当前位置创建一个新桶即可。
3. 如果当前桶有值（ Hash 冲突），那么就要比较当前桶中的 `key、key 的 hashcode` 与写入的 key 是否相等，相等就赋值给 `e`,在第 8 步的时候会统一进行赋值及返回。
4. <u>如果当前桶为红黑树，那就要按照红黑树的方式写入数据。</u>
5. <u>如果是个链表，就需要将当前的 key、value 封装成一个新节点写入到当前桶的后面（形成链表）。</u>
6. <u>接着判断当前链表的大小是否大于预设的阈值，大于时就要转换为红黑树</u>。
7. 如果在遍历过程中找到 key 相同时直接退出遍历。
8. 如果 `e != null` 就相当于存在相同的 key,那就需要将值覆盖。
9. <u>最后判断是否需要进行扩容</u>。

> get 操作

- 首先将 key hash 之后取得所定位的桶。
- 如果桶为空则直接返回 null 。
- <u>否则判断桶的第一个位置(有可能是链表、红黑树)的 key 是否为查询的 key，是就直</u>接返回 value。
- <u>如果第一个不匹配，则判断它的下一个是红黑树还是链表</u>。
- <u>红黑树就按照树的查找方式返回值</u>。
- <u>不然就按照链表的方式遍历匹配返回值。</u>



#### 2.2.2  hashMap的线程不安全会导致哪些问题？

- 多线程的put可能导致元素的丢失

- put和get并发时，可能导致get为null

  >  线程1执行put时，因为元素个数超出threshold而导致rehash，线程2此时执行get，有可能导致这个问题。 

- JDK7中HashMap并发put会造成循环链表，导致get时出现死循环 

  [连接]: https://www.cnblogs.com/chanshuyi/p/java_collection_hashmap_17_infinite_loop.html

[举例说明]: https://juejin.im/post/5c8910286fb9a049ad77e9a3#heading-4



#### 2.2.3 如何解决？有没有线程安全的并发容器？

​	currentHashMap

不安全，因为在多线程同时put时或者在扩容时Put都会有线程安全问题。安全可以使用hashtable、Collections.synchronizedMap、ConcurrentHashMap这三类。但前两类都是直接在方法标签上加了synchronized，所以效率很低。而ConcurrentHashMap效率很好，在1.7中，ConcurrentHashMap是用segment数组为锁住一块区域保证安全性。在1.8中ConcurrentHashMap和hashmap的结构完全一样，但更改了put方法。在计算了哈希值和索引后，先判断索引位置是否正在扩容，如果正在扩容就调用一个协助扩容的函数，如果没扩容再判断是否为空，为空则用CAS的方式放入，不为空则用synchronized锁住格子，判断为链表还是红黑树，分别调用对应方式放入。最后再判断一次冲突长度，大于8则转化为红黑树。 

#### 2.2.4  ConcurrentHashMap 是如何实现的？ 1.7、1.8 实现有何不同？为什么这么做？



其中抛弃了原有的 Segment （ReentrantLock）分段锁，而采用了 `CAS + synchronized` 来保证并发安全性。

> 放弃分段锁的原因
>
> 1. 加入多个分段锁浪费内存空间。
> 2. 生产环境中， map 在放入时竞争同一个锁的概率非常小，分段锁反而会造成更新等操作的长时间等待。
> 3. 为了提高 GC 的效率

也将 1.7 中存放数据的 HashEntry 改为 Node，但作用都是相同的。

其中的 `val next` 都用了 volatile 修饰，保证了可见性。

同样在也在链表大于8时采用红黑树来存储



### 2.3 . HashMap vs HashTable

> **HashTable 是线程安全 Collection**

![](img/hashtable&hashmap.png)

### 2.4  LinkedhashMap的数据结构

LinkedHashMap是HashMap的一个子类，它**保留插入的顺序**，如果需要输出的顺序和输入时的相同，那么就选用LinkedHashMap。

LinkedHashMap是Map接口的哈希表和链接列表实现，具有可预知的迭代顺序。此实现提供所有可选的映射操作，并**允许使用null值和null键**。此类不保证映射的顺序，特别是它**不保证该顺序恒久不变**。

LinkedHashMap实现与HashMap的不同之处在于，后者维护着一个运行于所有条目的双重链接列表。此链接列表定义了迭代顺序，该迭代顺序可以是插入顺序或者是访问顺序。

注意，此实现不是同步的。如果多个线程同时访问链接的哈希映射，而其中至少一个线程从结构上修改了该映射，则它必须保持外部同步。

![](img/linkedHashmap_01.png)

> linkedHashMap 构造方法是有意思的，比 HashMap 多了一个 accessOrder boolean 参数。表示，按照访问顺序来排序。最新访问的放在链表尾部。 

如果看 LinkedHashMap 内部源码，会发现，内部确实维护了一个链表：

```java
   public class LinkedHashMap<K,V> extends HashMap<K,V> implements Map<K,V>
{
  static class Entry<K,V> extends HashMap.Node<K,V> {
    Entry<K,V> before, after;
    Entry(int hash, K key, V value, Node<K,V> next) {
        super(hash, key, value, next);
    }

    // 双向链表头节点
    transient LinkedHashMap.Entry<K,V> head;

    // 双向链表尾节点
    transient LinkedHashMap.Entry<K,V> tail;

    // 指定遍历LinkedHashMap的顺序,true表示按照访问顺序,false表示按照插入顺序，默认为false
    final boolean accessOrder;
  }

}
```

当accessOrder=true,访问顺序的输出是什么意思呢？来看下下面的一段代码

```java
LinkedHashMap<Integer,Integer> map = new LinkedHashMap<>(8, 0.75f, true);

map.put(1, 1);
map.put(2, 2);
map.put(3, 3);

map.get(2);

System.out.println(map);

```

输出结果是

```
{1=1, 3=3, 2=2}
```

 可以看到get了的数据被放到了双向链表尾部，也就是按照了访问时间进行排序,这就是访问顺序的含义。 

> 在插入的时候LinkedHashMap复写了HashMap的newNode以及newTreeNode方法,并且在方法内部更新了双向链表的指向关系。

在添加元素的时候，会追加到尾部。

```java
    Node<K,V> newNode(int hash, K key, V value, Node<K,V> e) {
        LinkedHashMap.Entry<K,V> p =
            new LinkedHashMap.Entry<K,V>(hash, key, value, e);
        linkNodeLast(p);
        return p;
    }

    // link at the end of list
    private void linkNodeLast(LinkedHashMap.Entry<K,V> p) {
        LinkedHashMap.Entry<K,V> last = tail;
        tail = p;
        if (last == null)
            head = p;
        else {
            p.before = last;
            last.after = p;
        }
    }
```

> 在 get 的时候，会根据 accessOrder 属性，修改链表顺序：
>
> 同时插入的时候调用了afterNodeAccess()方法以及afterNodeInsertion()方法,在HashMap中这两个方法是空实现,而在LinkedHashMap中则有具体实现,这两个方法也是专门给LinkedHashMap进行回调处理的。
>
> afterNodeAccess()方法中如果accessOrder=true时会移动节点到双向链表尾部。当我们在调用map.get()方法的时候如果accessOrder=true也会调用这个方法,这就是为什么访问顺序输出时访问到的元素移动到链表尾部的原因。

```java
    public V get(Object key) {
        Node<K,V> e;
        if ((e = getNode(hash(key), key)) == null)
            return null;
        if (accessOrder)
            afterNodeAccess(e);
        return e.value;
    }

    void afterNodeAccess(Node<K,V> e) { // move node to last
        LinkedHashMap.Entry<K,V> last;
        if (accessOrder && (last = tail) != e) {
            LinkedHashMap.Entry<K,V> p =
                (LinkedHashMap.Entry<K,V>)e, b = p.before, a = p.after;
            p.after = null;
            if (b == null)
                head = a;
            else
                b.after = a;
            if (a != null)
                a.before = b;
            else
                last = b;
            if (last == null)
                head = p;
            else {
                p.before = last;
                last.after = p;
            }
            tail = p;
            ++modCount;
        }
    }
```

####  2.4.1 LRU的 使用LinkedHashMap

>  可以通过LinkedHashMap来实现LRU(Least Recently Used,即近期最少使用),只要满足条件,就删除head节点。 

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class LRUCache<K,V> {
    private final int CACHE_SIZE;
    private final float LOAD_FACTOR = 0.75f;

    LinkedHashMap<K,V> map;

    public LRUCache(int CACHE_SIZE) {
        this.CACHE_SIZE = CACHE_SIZE;
        int capacity = (int) (Math.ceil(CACHE_SIZE/LOAD_FACTOR)+1);
        map = new LinkedHashMap(capacity,LOAD_FACTOR,true){
            @Override
            protected boolean removeEldestEntry(Map.Entry eldest) {
                return size()>CACHE_SIZE;
            }
        };
    }
    public synchronized void put(K key,V val){
        map.put(key,val);
    }
    public synchronized V get(K key){
        return map.get(key);
    }
    public synchronized void remove(K key){
        map.remove(key);
    }
    public synchronized int sizi(){
        return map.size();
    }
    public synchronized  void clear(){
        map.clear();
    }
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry entry : map.entrySet()) {
            sb.append(String.format("%s:%s ", entry.getKey(), entry.getValue()));
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        LRUCache<Integer,String> cache = new LRUCache(5);
        cache.put(1,"1");
        cache.put(2,"2");
        cache.put(3,"3");
        cache.put(4,"4");
        cache.put(5,"5");
        System.out.println(cache.toString());
        cache.put(6,"6");
        cache.get(3);
        System.out.println(cache.toString());
        //1:1 2:2 3:3 4:4 5:5 
        //2:2 4:4 5:5 6:6 3:3 
    }
}
```

#### 2.4.2 LRU Cache的链表+HashMap实现

```java
import java.util.HashMap;

public class LRUCache1<K,V> {
    private final int CACHE_SIZE;
    private Entry first;
    private Entry last;

    private HashMap<K,Entry<K,V>> hashMap;

    class Entry<K,V>{
        public Entry pre;
        public Entry next;
        public K key;
        public V value;
    }

    public LRUCache1(int cache_size) {
        this.CACHE_SIZE = cache_size;
        hashMap = new HashMap<>();
    }
    public void put(K key, V value){
        Entry<K, V> entry = getEntry(key);
        if(entry==null){
            if(hashMap.size()>=CACHE_SIZE){
                hashMap.remove(last.key);
                removeLast();
            }
            entry = new Entry<>();
            entry.key = key;
        }
        //有元素
        entry.value = value;
        moveToFirst(entry);
        hashMap.put(key,entry);
    }


    public V get(K key){
        Entry<K, V> entry = getEntry(key);
        if(entry==null) return null;
        moveToFirst(entry);
        return entry.value;
    }

    public void remove(K key){
        Entry<K, V> entry = getEntry(key);
        if(entry!=null){
            if(entry.pre!=null) entry.pre.next = entry.next;
            if(entry.next!=null) entry.next.pre = entry.pre;
            if(entry == first) first = entry.next;
            if(entry == last) last = entry.pre;
        }
        hashMap.remove(key);
    }


    private Entry<K,V> getEntry(K key){
        return hashMap.get(key);
    }

    //把最近访问的一个元素挪到第一个
    private void moveToFirst(Entry entry){
        if(entry == first) return ;
        if(entry.pre!=null) entry.pre.next =  entry.next;
        if(entry.next!=null) entry.next.pre = entry.pre;
        if(entry ==last) last = last.pre;

        if(first == null || last == null){
            first = last = entry;
            return ;
        }
        entry.next = first;
        first.pre = entry;
        first = entry;
        entry.pre = null;
    }
    //删除链表最后一个元素
    private void removeLast(){
        if(last!=null){
            last = last.pre;
            if(last ==null) first = null;
            else last.next = null;
        }
    }
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        Entry entry = first;
        while (entry != null) {
            sb.append(String.format("%s:%s ", entry.key, entry.value));
            entry = entry.next;
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        LRUCache1<Integer,String> cache = new LRUCache1<>(5);
        cache.put(1,"1");
        cache.put(2,"2");
        cache.put(3,"3");
        cache.put(4,"4");
        cache.put(5,"5");
        System.out.println(cache.toString());
        cache.put(6,"6");
        cache.get(3);
        System.out.println(cache.toString());
        //5:5 4:4 3:3 2:2 1:1 
        //3:3 6:6 5:5 4:4 2:2 
    }

}

```



## 2、List

### 2.1 ArrayList &LinkedList

ArrayList

- 基于数组来实现
- 初始长度为10 
- 扩容1.5倍，扩容后复制到新的数组之中

LinkedList

- 基于双向链表来实现的
- 每个链表存储了first 和 last指针 

### 2.1 ArrayList 的简单实现

```java
/**
 * 1.ArrayList的简单实现（手写）
 * 2.包括以下方法：
 *              int size();
 *              MyArrayList();
 *              MyArrayList(int initialCapacity);
 *              boolean isEmpty();
 *              Object get(int index);
 *              boolean add(Object obj);
 *              void add(int index,Object obj)
 *              Object remove(int index)
 *              boolean remove(Object obj)
 *              Object set(int index,Object obj)
 *              void rangeCheck(int index)
 *              void ensureCapacity()
 */
public class MyArrayList<E> {
    private Object element[];
    private int size;
    public MyArrayList() {
        this(10);
    }

    public MyArrayList(int capacity){
        if(capacity<0){
            try {
              throw new IllegalArgumentException();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        element = new Object[capacity];
    }
    public int size(){
        return size;
    }

    public boolean isEmpty(){
        return size == 0;
    }

    public E get(int index){
        rangeCheck(index);
        return (E) element[index];
    }

    public boolean add(E elem){
        ensureCapacity();
        element[size++] = elem;
        return true;
    }

    public void add(int index,Object obj){
        /*
         * 插入操作（指定位置）
         * 1.下标合法性检查
         * 2.数组容量检查、扩容
         * 3.数组复制（原数组，开始下标，目的数组，开始下标，长度）
         */
        rangeCheck(index);
        ensureCapacity();
        System.arraycopy(element, index, element, index+1,size-index);
        element[index]=obj;
        size++;
    }

    public E remove(int index){

        rangeCheck(index);
        E oldValue =  get(index);
        System.arraycopy(element,index+1,element,index-1,size-index-1);
        size--;
        return oldValue;

    }



    private void rangeCheck(int index){
        if(index <0 || index>size-1){
            try {
                throw  new ArrayIndexOutOfBoundsException();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }
    private void ensureCapacity(){
        if(size == element.length) {
            int newSize = size + (size >> 1);
            element = Arrays.copyOf(element, newSize);
        }
    }
}

```



## 3、Set

### 3.1、TreeSet和HashSet

#### HashSet 

**HashSet有以下特点：**

1 、不能保证元素的排列顺序，顺序有可能发生变化
2、不是同步的
3、集合元素可以是null,但只能放入一个null

> 当向HashSet集合中存入一个元素时，HashSet会调用该对象的hashCode()方法来得到该对象的hashCode值，然后根据 hashCode值来决定该对象在HashSet中存储位置。
> 简单的说，HashSet集合判断两个元素相等的标准是两个对象通过equals方法比较相等，并且两个对象的hashCode()方法返回值相 等
> 注意，如果要把一个对象放入HashSet中，重写该对象对应类的equals方法，也应该重写其hashCode()方法。其规则是如果两个对 象通过equals方法比较返回true时，其hashCode也应该相同。另外，对象中用作equals比较标准的属性，都应该用来计算 hashCode的值。



#### TreeSet

TreeSet是`SortedSet`接口的唯一实现类，TreeSet可以确保集合元素处于排序状态。TreeSet支持两种排序方式，自然排序 和定制排序，其中自然排序为默认的排序方式。向TreeSet中加入的应该是同一个类的对象。
TreeSet判断两个对象不相等的方式是两个对象通过equals方法返回false，或者通过CompareTo方法比较没有返回0

自然排序
自然排序使用要排序元素的`CompareTo（Object obj）`方法来比较元素之间大小关系，然后将元素按照升序排列。
Java提供了一个Comparable接口，该接口里定义了一个compareTo(Object obj)方法，该方法返回一个整数值，实现了该接口的对象就可以比较大小。
obj1.compareTo(obj2)方法如果返回0，则说明被比较的两个对象相等，如果返回一个正数，则表明obj1大于obj2，如果是 负数，则表明obj1小于obj2。
如果我们将两个对象的equals方法总是返回true，则这两个对象的compareTo方法返回应该返回0
定制排序
自然排序是根据集合元素的大小，以升序排列，如果要定制排序，应该使用Comparator接口，实现 int compare(T o1,T o2)方法。

#### HashSet 和TreeSet 的比较

1、TreeSet 是二差树实现的,Treeset中的数据是自动排好序的，不允许放入null值。

2、HashSet 是哈希表实现的,HashSet中的数据是无序的，可以放入null，但只能放入一个null，两者中的值都不能重复，就如数据库中唯一约束。

3、HashSet要求放入的对象必须实现HashCode()方法，放入的对象，是以hashcode码作为标识的，而具有相同内容的 String对象，hashcode是一样，所以放入的内容不能重复。但是同一个类的对象可以放入不同的实例 。

## 4. fail-fast和fail-safe

**fail-fast**：在系统设计中，快速失效系统一种可以立即报告任何可能表明故障的情况的系统。快速失效系统通常设计用于停止正常操作，而不是试图继续可能存在缺陷的过程。这种设计通常会在操作中的多个点检查系统的状态，因此可以及早检测到任何故障。快速失败模块的职责是检测错误，然后让系统的下一个最高级别处理错误。

fail-fast机制，默认指的是Java集合的一种错误检测机制。当多个线程对部分集合进行结构上的改变的操作时，有可能会产生fail-fast机制，这个时候就会抛出ConcurrentModificationException。

```java
public void remove() {

​      if (lastRet < 0)

​         throw new IllegalStateException();

​      checkForComodification();

​      try {

​        ArrayList.this.remove(lastRet);

​        cursor = lastRet;

​        lastRet = -1;

​        expectedModCount = modCount;

​      } catch (IndexOutOfBoundsException ex) {

​        throw new ConcurrentModificationException();

​      }

​    }

​    final void checkForComodification() {

​      if (modCount != expectedModCount)

​        throw new ConcurrentModificationException();

​    }
```

可以看到这里就是抛出ConcurrentModificationException异常的地方，那么modCount和expectedModCount分别代表什么呢？

modCount:ArrayList的成员变量，代表集合的修改次数，初始值为0

expected:Itr的成员变量，代表迭代器预期集合的修改次数，初始值等于创建itr时的修改次数，只有通过迭代器对集合进行操作，该值才会改变。

通过foreach来遍历集合，其实就是通过集合的迭代器（Iterator）来遍历的，如果不通过迭代器来修改集合内的元素，只要他发现有某一次修改是未经过自己进行的，那么就会抛出异常。

<font color='red'> ****fail-safe****字面理解 </font>***安全失败***，java.util包下面的所有的集合类都是快速失败的，而java.util.concurrent包下面的所有的类都是安全失败的。快速失败的迭代器会抛出ConcurrentModificationException异常，而安全失败的迭代器永远不会抛出这样的异常。

  

```java
 List<Integer> list = new CopyOnWriteArrayList<Integer>(){{
      for (int i=1;i<=10;i++){
        add(i);
      }
    }}; 
    for (Integer integer:list){
      if (integer==5){
        list.remove(integer);
      }
      System.out.println(integer);
}
```

上面使用CopyOnWriteArrayList这个类来演示fail-safe，这样的集合容器在遍历时不是直接在集合内容上访问的，而是先复制原有集合内容，在拷贝的集合上进行遍历。迭代器遍历的是开始遍历那一刻拿到的集合拷贝，在遍历期间原集合发生的修改迭代器是不知道的。



