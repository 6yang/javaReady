-- 查看Mysql存储引擎
show engines;
show variables like '%storage_engine%';

-- join 复习
create database db1019;
use db1019;

#建表
CREATE TABLE `t_dept` (
 `id` INT(11) NOT NULL AUTO_INCREMENT,
 `deptName` VARCHAR(30) DEFAULT NULL,
 `address` VARCHAR(40) DEFAULT NULL,
 PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
 
CREATE TABLE `t_emp` (
 `id` INT(11) NOT NULL AUTO_INCREMENT,
 `name` VARCHAR(20) DEFAULT NULL,
  `age` INT(3) DEFAULT NULL,
 `deptId` INT(11) DEFAULT NULL,
 PRIMARY KEY (`id`),
 KEY `fk_dept_id` (`deptId`)
 #CONSTRAINT `fk_dept_id` FOREIGN KEY (`deptId`) REFERENCES `t_dept` (`id`)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
 
INSERT INTO t_dept(deptName,address) VALUES('华山','华山');
INSERT INTO t_dept(deptName,address) VALUES('丐帮','洛阳');
INSERT INTO t_dept(deptName,address) VALUES('峨眉','峨眉山');
INSERT INTO t_dept(deptName,address) VALUES('武当','武当山');
INSERT INTO t_dept(deptName,address) VALUES('明教','光明顶');
 INSERT INTO t_dept(deptName,address) VALUES('少林','少林寺');
 
INSERT INTO t_emp(NAME,age,deptId) VALUES('风清扬',90,1);
INSERT INTO t_emp(NAME,age,deptId) VALUES('岳不群',50,1);
INSERT INTO t_emp(NAME,age,deptId) VALUES('令狐冲',24,1);
INSERT INTO t_emp(NAME,age,deptId) VALUES('洪七公',70,2);
INSERT INTO t_emp(NAME,age,deptId) VALUES('乔峰',35,2); 
INSERT INTO t_emp(NAME,age,deptId) VALUES('灭绝师太',70,3);
INSERT INTO t_emp(NAME,age,deptId) VALUES('周芷若',20,3);  
INSERT INTO t_emp(NAME,age,deptId) VALUES('张三丰',100,4);
INSERT INTO t_emp(NAME,age,deptId) VALUES('张无忌',25,5);
INSERT INTO t_emp(NAME,age,deptId) VALUES('武则天',25,99);
INSERT INTO t_emp(NAME,age,deptId) VALUES('韦小宝',18,null);

#查询
select * from t_dept;
select * from t_emp;

#inner join 
select * from t_emp a INNER JOIN t_dept b on a.deptId = b.id;

#left join 
select * from t_emp a LEFT JOIN t_dept b on a.deptId = b.id;

#right join 
select * from t_emp a RIGHT JOIN t_dept b on a.deptId = b.id;

#left join 少公有部分
select * from t_emp a LEFT JOIN t_dept b on a.deptId = b.id where b.id is null;

#right join 少公有部分
select * from t_emp a RIGHT JOIN t_dept b on a.deptId = b.id where a.id is null;

#A和B的全部
select * from t_emp a LEFT JOIN t_dept b on a.deptId = b.id
UNION
select * from t_emp a RIGHT JOIN t_dept b on a.deptId = b.id;

#不包括A和B的公有
select * from t_emp a LEFT JOIN t_dept b on a.deptId = b.id where b.id is null
UNION
select * from t_emp a RIGHT JOIN t_dept b on a.deptId = b.id where a.id is null;

#增加掌门字段
ALTER table `t_dept` ADD ceo int(11);

update t_dept set CEO=2 where id=1;
update t_dept set CEO=4 where id=2;
update t_dept set CEO=6 where id=3;
update t_dept set CEO=8 where id=4;
update t_dept set CEO=9 where id=5;

#求各个门派对应的掌门人
select * from t_dept a left join t_emp b on a.ceo = b.id;

#求各个掌门人的平均年龄
select AVG(age) from t_emp a inner join t_dept b on a.id = b.ceo;


-- 索引
show index from t_emp;
show index from t_dept;

-- explain 
explain select * from t_emp;

-- 建表
CREATE TABLE t1(id INT(10) AUTO_INCREMENT,content  VARCHAR(100) NULL ,  PRIMARY KEY (id));
CREATE TABLE t2(id INT(10) AUTO_INCREMENT,content  VARCHAR(100) NULL ,  PRIMARY KEY (id));
CREATE TABLE t3(id INT(10) AUTO_INCREMENT,content  VARCHAR(100) NULL ,  PRIMARY KEY (id));
CREATE TABLE t4(id INT(10) AUTO_INCREMENT,content  VARCHAR(100) NULL ,  PRIMARY KEY (id));
 
 
INSERT INTO t1(content) VALUES(CONCAT('t1_',FLOOR(1+RAND()*1000)));
 
INSERT INTO t2(content) VALUES(CONCAT('t2_',FLOOR(1+RAND()*1000)));
  
INSERT INTO t3(content) VALUES(CONCAT('t3_',FLOOR(1+RAND()*1000)));
    
INSERT INTO t4(content) VALUES(CONCAT('t4_',FLOOR(1+RAND()*1000)));

########################## id 
#######select查询的序列号,包含一组数字，表示查询中执行select子句或操作表的顺序

-- id相同 (id顺序执行)
explain select *
from t1,t2,t3
where t1.id = t2.id and t1.id = t3.id 
and t1.content='';

-- id不同(id从大到小执行)
explain select t1.id from t1 where t1.id in
	(select t2.id from t2 where t2.id in 
			(select t3.id from t3 where t3.content=''));

-- id相同不同(先执行id最大的，顺序相同再顺序执行)
-- 衍生表 = derived2 --> derived + 2 （2 表示由 id =2 的查询衍生出来的表。type 肯定是 all ，因为衍生的表没有建立索引）
EXPLAIN SELECT t2.* FROM t2,( SELECT * FROM t3 WHERE t3.content = '' ) s3 
WHERE
	s3.id = t2.id;


########################### select_type
#########查询的类型，主要是用于区别普通查询、联合查询、子查询等的复杂查询

-- 1、SIMPLE 
-- 简单的 select 查询,查询中不包含子查询或者UNION
explain select * from t1;

-- 2、PRIMARY
-- 查询中若包含任何复杂的子部分，最外层查询则被标记为Primary
explain select * from (select t1.content from t1) a;

-- 3、DERIVED
-- 在FROM列表中包含的子查询被标记为DERIVED(衍生)MySQL会递归执行这些子查询, 把结果放在临时表里
explain select * from (select t1.content from t1) a;

-- 4、SUBQUERY
-- 在SELECT或WHERE列表中包含了子查询
explain select t2.id from t2 where t2.id =(select t3.id from t3 where t3.id = 1);

-- 5、UNION
-- 若第二个SELECT出现在UNION之后，则被标记为UNION；若UNION包含在FROM子句的子查询中,外层SELECT将被标记为：DERIVED
explain select t2.id ,t2.content from t2 
union 
select t3.id ,t3.content from t3;

-- 6、UNION RESULT
-- 从UNION表获取结果的SELECT
explain select t2.id ,t2.content from t2 
union 
select t3.id ,t3.content from t3;

######################### table 
#######显示这一行的数据是关于哪张表的


######################### type
#######访问类型排列

-- type显示的是访问类型，是较为重要的一个指标，结果值从最好到最坏依次是： 
-- system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range(尽量保证) > index > ALL 

-- 简化 
-- system>const>eq_ref>ref>range>index>ALL
-- 一般来说，得保证查询至少达到range级别，最好能达到ref。


-- 1、system 
-- 表只有一行记录（等于系统表），这是const类型的特列，平时不会出现，这个也可以忽略不计

-- 2、const
-- 表示通过索引一次就找到了,const用于比较primary key或者unique索引。因为只匹配一行数据，所以很快如将主键置于where列表中，MySQL就能将该查询转换为一个常量
explain select * from t1 where id =1;

-- 3、eq_ref
-- 唯一性索引扫描，对于每个索引键，表中只有一条记录与之匹配。常见于主键或唯一索引扫描
explain select * from t1,t2 where t1.id = t2.id;

-- 4、ref
-- 非唯一性索引扫描，返回匹配某个单独值的所有行.本质上也是一种索引访问，它返回所有匹配某个单独值的行，然而，它可能会找到多个符合条件的行，所以他应该属于查找和扫描的混合体
explain select * from t1,t2 where t1.content = t2.content;
-- 创建索引
create index idx_t2_cont on t2(content);

explain select * from t1,t2 where t1.content = t2.content;

-- 5、range 
-- 只检索给定范围的行,使用一个索引来选择行。key 列显示使用了哪个索引一般就是在你的where语句中出现了between、<、>、in等的查询这种范围扫描索引扫描比全表扫描要好，因为它只需要开始于索引的某一点，而结束语另一点，不用扫描全部索引。
explain select * from t1 where t1.id<10;

explain select * from t1 where t1.id in (10,20);

-- 6、index 
-- Full Index Scan，index与ALL区别为index类型只遍历索引树。这通常比ALL快，因为索引文件通常比数据文件小。（也就是说虽然all和Index都是读全表，但index是从索引中读取的，而all是从硬盘中读的）

explain select id from t1;

-- 7、all
-- Full Table Scan，将遍历全表以找到匹配的行

explain select t1.content from t1;

#######################possible_keys 
############显示可能应用在这张表中的索引，一个或多个。查询涉及到的字段上若存在索引，则该索引将被列出，但不一定被查询实际使用

###################### key 
##########实际使用的索引。如果为NULL，则没有使用索引

-- 查询中若使用了覆盖索引，则该索引和查询的select字段重叠

explain select t4.id,t4.content from t4;

create index idx_id_content on t4(id,content);

explain select t4.id,t4.content from t4;

###################### key_len

-- 表示索引中使用的字节数，可通过该列计算查询中使用的索引的长度。 
-- key_len字段能够帮你检查是否充分的利用上了索引



###################### ref 
-- 显示索引的哪一列被使用了，如果可能的话，是一个常数。哪些列或常量被用于查找索引列上的值
explain select t2.* from
t1,t2,t3 where t1.id = t2.id and t1.id = t3.id 
and t1.content ='';

explain select * from t1,t4 where t4.content = t1.content and t4.content='';

###################### rows
-- rows列显示MySQL认为它执行查询时必须检查的行数。
-- 越少越好


###################### Extra
-- 包含不适合在其他列中显示但十分重要的额外信息

-- Using filesort
-- 说明mysql会对数据使用一个外部的索引排序，而不是按照表内的索引顺序进行读取。MySQL中无法利用索引完成的排序操作称为“文件排序”

-- Using temporary
-- 使了用临时表保存中间结果,MySQL在对查询结果排序时使用临时表。常见于排序 order by 和分组查询 group by。

-- using index 
-- 表示相应的select操作中使用了覆盖索引(Covering Index)，避免访问了表的数据行，效率不错！
-- 如果同时出现using where，表明索引被用来执行索引键值的查找;
-- 如果没有同时出现using where，表明索引只是用来读取数据而非利用索引执行查找。

-- using where 
-- 表明使用了where过滤

-- using join buffer
-- 使用了连接缓存：

-- impossible where
-- where子句的值总是false，不能用来获取任何元组
explain select * from t4 where id >100 and id <10;



########## 索引分析

-- 单表
CREATE TABLE IF NOT EXISTS `article` (
`id` INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
`author_id` INT(10) UNSIGNED NOT NULL,
`category_id` INT(10) UNSIGNED NOT NULL,
`views` INT(10) UNSIGNED NOT NULL,
`comments` INT(10) UNSIGNED NOT NULL,
`title` VARBINARY(255) NOT NULL,
`content` TEXT NOT NULL
);
 
INSERT INTO `article`(`author_id`, `category_id`, `views`, `comments`, `title`, `content`) VALUES
(1, 1, 1, 1, '1', '1'),
(2, 2, 2, 2, '2', '2'),
(1, 1, 3, 3, '3', '3');
 
SELECT * FROM article;

-- 查询 category_id 为1 且  comments 大于 1 的情况下,views 最多的 article_id。 

explain select id,author_id from article where category_id =1 and comments>1 order by views desc LIMIT 1;

-- 结论：很显然,type 是 ALL,即最坏的情况。Extra 里还出现了 Using filesort,也是最坏的情况。优化是必须的。
 
show index from article;

-- 开始优化
-- 第一次尝试创建索引
create index idx_article_ccv on article(category_id,comments,views);

show index from article;

explain select id,author_id from article where category_id =1 and comments>1 order by views desc LIMIT 1;

#结论：
#type 变成了 range,这是可以忍受的。但是 extra 里使用 Using filesort 仍是无法接受的。
#但是我们已经建立了索引,为啥没用呢?
#这是因为按照 BTree 索引的工作原理,
# 先排序 category_id,
# 如果遇到相同的 category_id 则再排序 comments,如果遇到相同的 comments 则再排序 views。
#当 comments 字段在联合索引里处于中间位置时,
#因comments > 1 条件是一个范围值(所谓 range),
#MySQL 无法利用索引再对后面的 views 部分进行检索,即 range 类型查询字段后面的索引无效。
#最左匹配原则
 

##重新来 删除刚刚建的索引
drop index idx_article_ccv on article;

-- 第二次建索引
create index idx_article_cv on article(category_id,views);

explain select id,author_id from article where category_id =1 and comments>1 order by views desc LIMIT 1;

#结论：可以看到,type 变为了 ref,Extra 中的 Using filesort 也消失了,结果非常理想。
DROP INDEX idx_article_cv ON article;


-- 两表案例

CREATE TABLE IF NOT EXISTS `class` (
`id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
`card` INT(10) UNSIGNED NOT NULL,
PRIMARY KEY (`id`)
);
CREATE TABLE IF NOT EXISTS `book` (
`bookid` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
`card` INT(10) UNSIGNED NOT NULL,
PRIMARY KEY (`bookid`)
);
 
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO class(card) VALUES(FLOOR(1 + (RAND() * 20)));
 
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
INSERT INTO book(card) VALUES(FLOOR(1 + (RAND() * 20)));
 
select * from class; 
select * from book;


select * from book inner join class where book.card = class.card;

-- 开始案例
explain select * from class left join book on class.card = book.card;

#结论：type 有All
 
# 添加索引优化
alter table book add index Y(card);
#可以看到第二行的 type 变为了 ref,rows 也变成了优化比较明显。
#这是由左连接特性决定的。LEFT JOIN 条件用于确定如何从右表搜索行,左边一定都有,
#所以右边是我们的关键点,一定需要建立索引。

 
# 删除旧索引 + 新建 + 第3次explain
DROP INDEX Y ON book;
ALTER TABLE class ADD INDEX X (card);
EXPLAIN SELECT * FROM class LEFT JOIN book ON class.card = book.card;

DROP INDEX X ON class;

-- 右连接例子

explain select * from class right join book on class.card = book.card;

alter table class add index X(card);


explain select * from class right join book on class.card = book.card;

### 结论
#左连接一定要建右索引
#右连接一定建建左索引
##相反建立索引

-- 三表案例

create table if not EXISTS `phone`(
	`phoneid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`card` int(10) UNSIGNED not null,
	PRIMARY KEY(`phoneid`)
)ENGINE=INNODB;

INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));
INSERT INTO phone(card) VALUES(FLOOR(1+(RAND()*20)));

SELECT * from phone;


show index from class;
show index from book;
show index from phone;

drop index 

















