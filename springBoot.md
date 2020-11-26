## 1、 SpringBoot自动装配原理 

<font color='#e54d42'>Spring Boot启动的时候会通过@EnableAutoConfiguration注解找到META-INF/spring.factories配置文件中的所有自动配置类，并对其进行加载，而这些自动配置类都是以AutoConfiguration结尾来命名的，它实际上就是一个JavaConfig形式的Spring容器配置类，它能通过以Properties结尾命名的类中取得在全局配置文件中配置的属性如：server.port，而XxxxProperties类是通过@ConfigurationProperties注解与全局配置文件中对应的属性进行绑定的。</font>

## @EnableAutoConfiguration

![img](https://img-blog.csdnimg.cn/20181107115331414.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTQ3NDUwNjk=,size_16,color_FFFFFF,t_70)

 @SpringBootApplication是一个复合注解或派生注解，在@SpringBootApplication中有一个注解@EnableAutoConfiguration，翻译成人话就是**开启自动配置**，其定义如下：

![img](https://img-blog.csdnimg.cn/20181107125035592.png)

 而这个注解也是一个派生注解，其中的关键功能由@Import提供，其导入的**AutoConfigurationImportSelector**的selectImports()方法通过**SpringFactoriesLoader.loadFactoryNames()**扫描所有具有**META-INF/spring.factories**的jar包。spring-boot-autoconfigure-x.x.x.x.jar里就有一个这样的spring.factories文件。

这个spring.factories文件也是一组一组的key=value的形式，其中一个key是EnableAutoConfiguration类的全类名，而它的value是一个xxxxAutoConfiguration的类名的列表，这些类名以逗号分隔，如下图所示：

![img](https://img-blog.csdnimg.cn/20181107130442565.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTQ3NDUwNjk=,size_16,color_FFFFFF,t_70)

这个@EnableAutoConfiguration注解通过@SpringBootApplication被间接的标记在了Spring Boot的启动类上。在SpringApplication.run(...)的内部就会执行selectImports()方法，找到所有JavaConfig自动配置类的全限定名对应的class，然后将所有自动配置类加载到Spring容器中。

## 自动配置生效

每一个XxxxAutoConfiguration自动配置类都是在某些条件之下才会生效的，这些条件的限制在Spring Boot中以注解的形式体现，常见的**条件注解**有如下几项：

> @ConditionalOnBean：当容器里有指定的bean的条件下。
>
> @ConditionalOnMissingBean：当容器里不存在指定bean的条件下。
>
> @ConditionalOnClass：当类路径下有指定类的条件下。
>
> @ConditionalOnMissingClass：当类路径下不存在指定类的条件下。
>
> @ConditionalOnProperty：指定的属性是否有指定的值，比如@ConditionalOnProperties(prefix=”xxx.xxx”, value=”enable”, matchIfMissing=true)，代表当xxx.xxx为enable时条件的布尔值为true，如果没有设置的情况下也为true。

以ServletWebServerFactoryAutoConfiguration配置类为例，解释一下全局配置文件中的属性如何生效，比如：server.port=8081，是如何生效的（当然不配置也会有默认值，这个默认值来自于org.apache.catalina.startup.Tomcat）。

![img](https://img-blog.csdnimg.cn/20181107133910432.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTQ3NDUwNjk=,size_16,color_FFFFFF,t_70)

在ServletWebServerFactoryAutoConfiguration类上，有一个@EnableConfigurationProperties注解：**开启配置属性**，而它后面的参数是一个ServerProperties类，这就是习惯优于配置的最终落地点。

![img](https://img-blog.csdnimg.cn/20181107134400306.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTQ3NDUwNjk=,size_16,color_FFFFFF,t_70)

在这个类上，我们看到了一个非常熟悉的注解：**@ConfigurationProperties**，它的作用就是从配置文件中绑定属性到对应的bean上，而**@EnableConfigurationProperties**负责导入这个已经绑定了属性的bean到spring容器中（见上面截图）。那么所有其他的和这个类相关的属性都可以在全局配置文件中定义，也就是说，真正“限制”我们可以在全局配置文件中配置哪些属性的类就是这些**XxxxProperties**类，它与配置文件中定义的prefix关键字开头的一组属性是唯一对应的。

至此，我们大致可以了解。在全局配置的属性如：server.port等，通过@ConfigurationProperties注解，绑定到对应的XxxxProperties配置实体类上封装为一个bean，然后再通过@EnableConfigurationProperties注解导入到Spring容器中。

而诸多的XxxxAutoConfiguration自动配置类，就是Spring容器的JavaConfig形式，作用就是为Spring 容器导入bean，而所有导入的bean所需要的属性都通过xxxxProperties的bean来获得。

可能到目前为止还是有所疑惑，但面试的时候，其实远远不需要回答的这么具体，你只需要这样回答：



