## 1、面试题中的sql

### 1.1 求总分最高的前三个

```sql
select 
	sc.SId,
	s.Sname,
	sum(sc.score)
from 
	sc,
	student s
WHERE
	sc.SId = s.SId
GROUP BY
	sc.SId
ORDER BY
	sum(sc.score) desc
LIMIT 0,3	
```

## 2 sql练习

### 2.1 **建表**

```sql
-- 学生表
create table Student(SId varchar(10),Sname varchar(10),Sage datetime,Ssex varchar(10));
insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-05-20' , '男');
insert into Student values('04' , '李云' , '1990-08-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into Student values('09' , '张三' , '2017-12-20' , '女');
insert into Student values('10' , '李四' , '2017-12-25' , '女');
insert into Student values('11' , '李四' , '2017-12-30' , '女');
insert into Student values('12' , '赵六' , '2017-01-01' , '女');
insert into Student values('13' , '孙七' , '2018-01-01' , '女');
-- 课程表
create table Course(CId varchar(10),Cname nvarchar(10),TId varchar(10))
insert into Course values('01' , '语文' , '02')
insert into Course values('02' , '数学' , '01')
insert into Course values('03' , '英语' , '03')
-- 老师表
create table Teacher(TId varchar(10),Tname varchar(10))
insert into Teacher values('01' , '张三')
insert into Teacher values('02' , '李四')
insert into Teacher values('03' , '王五')
-- 选课表
create table SC(SId varchar(10),CId varchar(10),score decimal(18,1))
insert into SC values('01' , '01' , 80)
insert into SC values('01' , '02' , 90)
insert into SC values('01' , '03' , 99)
insert into SC values('02' , '01' , 70)
insert into SC values('02' , '02' , 60)
insert into SC values('02' , '03' , 80)
insert into SC values('03' , '01' , 80)
insert into SC values('03' , '02' , 80)
insert into SC values('03' , '03' , 80)
insert into SC values('04' , '01' , 50)
insert into SC values('04' , '02' , 30)
insert into SC values('04' , '03' , 20)
insert into SC values('05' , '01' , 76)
insert into SC values('05' , '02' , 87)
insert into SC values('06' , '01' , 31)
insert into SC values('06' , '03' , 34)
insert into SC values('07' , '02' , 89)
insert into SC values('07' , '03' , 98)
```

### 2.2  题目

####  **1. 查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数**

```sql
SELECT
	t1.SId AS '学号',
	t1.score AS '01课程',
	t2.score AS '02 课程' 
FROM
	( SELECT SId, score FROM SC WHERE CId = "01" ) t1,
	( SELECT SId, score FROM SC WHERE CId = "02" ) t2 
WHERE
	t1.SId = t2.SId 
	AND t1.score > t2.score;
```

####  1.1 查询同时存在" 01 "课程和" 02 "课程的情况 

```sql
SELECT
	t1.SId 
FROM
	( SELECT SId FROM SC WHERE CId = "01" ) t1,
	( SELECT SId FROM SC WHERE CId = "02" ) t2 
WHERE
	t1.SId = t2.SId;
```

####   1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null ) 

```mysql
SELECT
	* 
FROM
	( SELECT SId, score FROM SC WHERE CId = "01" ) AS t1
	LEFT JOIN 
	( SELECT SId, score FROM SC WHERE CId = "02" ) AS t2 ON t1.SId = t2.SId;

```

####  1.3 查询不存在" 01 "课程但存在" 02 "课程的情况 

```sql
SELECT
	* 
FROM
	SC 
WHERE
	SId NOT IN ( SELECT sid FROM SC WHERE CId = "01" ) 
	AND CId = "02";
```



#### 2  查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩 

```sql
SELECT
	s.SId,
	s.Sname,
	AVG( sc.score ) 
FROM
	student s,
	sc 
WHERE
	s.SId = sc.SId 
GROUP BY
	sc.SId 
HAVING
	AVG( sc.score ) >= 60;
```

#### 3  查询在 SC 表存在成绩的学生信息 

```sql
SELECT
	s.* 
FROM
	sc,
	student s 
WHERE
	sc.SId = s.SId 
GROUP BY
	sc.SId;
```

####  4.查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为null) 

```sql
SELECT
	s.SId,
	s.Sname,
	COUNT( sc.CId ),
	SUM( sc.score ) 
FROM
	student s,
	sc 
WHERE
	s.SId = sc.SId
GROUP BY
	sc.SId;
```



#### 5 查询「李」姓老师的数量

```sql
SELECT
	COUNT( * ) 
FROM
	teacher t 
WHERE
	t.Tname LIKE '李%';
```



#### 6 查询学过「张三」老师授课的同学的信息 

```sql
SELECT
	s.* 
FROM
	teacher t,
	course c,
	student s,
	sc 
WHERE
	t.Tname = "张三" 
	AND t.TId = c.TId 
	AND c.CId = sc.CId 
	AND sc.SId = s.SId;
```



####  7 查询没有学全所有课程的同学的信息 

```sql
SELECT
	s.* 
FROM
	student s,
	sc 
WHERE
	s.SId = sc.SId 
GROUP BY
	sc.SId 
HAVING
	count( * ) < ( SELECT count( * ) FROM course );
```



#### 8  查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息 

```sql
SELECT DISTINCT
	s.* 
FROM
	student s,
	sc 
WHERE
	sc.CId IN ( SELECT CId FROM sc WHERE sc.SId = '01' ) 
	AND s.SId = sc.SId;
```

#### * 9.查询和" 01 "号的同学学习的课程完全相同的其他同学的信息 

```sql
SELECT
	s.* 
FROM
	student s 
WHERE
	s.SId IN (
		SELECT DISTINCT
			sc.SId 
		FROM
			sc 
		WHERE
			sc.SId <> '01' 
		AND sc.CId IN ( SELECT CId FROM sc WHERE SId = '01' ) 
		GROUP BY
			sc.SId 
		HAVING
			count(1) = ( SELECT count( 1 ) FROM sc WHERE SId = '01' ) 
);
```



####  10.查询没学过"张三"老师讲授的任一门课程的学生姓名 

```sql
SELECT
	* 
FROM
	student s 
WHERE
	s.SId NOT IN (
SELECT
	sc.SId 
FROM
	teacher t,
	course c,
	sc 
WHERE
	t.Tname = '张三' 
	AND t.TId = c.TId 
	AND sc.CId = c.CId 
	);
```

#### 11.查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 

```sql
SELECT
	s.SId,
	s.Sname,
	AVG( sc.score ) 
FROM
	sc,
	student s 
WHERE
	sc.SId = s.SId 
	AND sc.score < 60 
	GROUP BY sc.SId HAVING COUNT( * ) >= 2;
```

####  12.检索" 01 "课程分数小于 60，按分数降序排列的学生信息 

```sql
SELECT
	s.*,
	sc.score 
FROM
	student s,
	sc 
WHERE
	sc.CId = '01' 
	AND sc.score < 60 
	AND s.SId = sc.SId 
ORDER BY
	sc.score DESC;
```

####  13、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩 

```sql
SELECT
	sc.SId,
	sc.CId,
	sc.score,
	t1.avgScore 
FROM
	sc
	LEFT JOIN ( SELECT sc.SId, AVG( sc.score ) avgScore 
	FROM sc GROUP BY sc.SId ) t1 ON t1.SId = sc.SId;
```

#### 14、 查询各科成绩最高分、最低分和平均分： 以如下形式显示：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列 

```sql
SELECT
	sc.CId AS '课程ID',
	c.Cname AS '课程name',
	MAX( sc.score ) AS '最高分',
	min( sc.score ) AS '最低分',
	AVG( sc.score ) AS '平均分',
	count( * ) AS '选修人数',
	sum( CASE WHEN sc.score >= 60 THEN 1 ELSE 0 END ) / COUNT( * ) AS '及格率',
	sum( CASE WHEN sc.score >= 70 AND sc.score < 80 THEN 1 ELSE 0 END ) / COUNT( * ) AS '中等率',
	sum( CASE WHEN sc.score >= 80 AND sc.score < 90 THEN 1 ELSE 0 END ) / COUNT( * ) AS '优良率',
	sum( CASE WHEN sc.score > 90 THEN 1 ELSE 0 END ) / COUNT( * ) AS '优秀率' 
FROM
	sc,
	course c 
WHERE
	sc.CId = c.CId 
GROUP BY
	sc.CId 
ORDER BY
	count( * ) DESC,
	sc.CId ASC;

```

#### 15、 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺 

```sql
SELECT
	sc.SId,
	sc.CId,
	@curR := @curR + 1 AS rank,
	sc.score 
FROM
	( SELECT @curR := 0 ) AS t1,
	sc 
ORDER BY
	sc.score DESC;
```

#### 15.1、 按各科成绩进行排序，并显示排名， Score 重复时合并名次 

```sql
SELECT
	sc.CId,
CASE
	WHEN @fontscore = score THEN
	@curRank 
	WHEN @fontscore := score THEN
	@curRank := @curRank + 1 
	END AS rank,
	sc.score 
FROM
	( SELECT @curRank := 0, @fontage := NULL ) AS t,
	sc 
ORDER BY
	sc.score DESC
```

#### 16、 查询学生的总成绩，并进行排名，总分重复时保留名次空缺 

```sql
SELECT
	t1.*,
	@curRank := @curRank + 1 AS rank 
FROM
	(SELECT sc.SId, SUM( sc.score ) AS sum FROM sc GROUP BY sc.SId ORDER BY SUM( sc.		score ) DESC ) AS t1,
	( SELECT @curRank := 0 ) AS t2;

```

####  16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺 

```sql
SELECT
	t1.*,
	case
	when @preScore = t1.sum 
	then @curRank
	when @preScore := t1.sum 
	then  @curRank := @curRank + 1  
	end AS rank 
FROM
	(SELECT sc.SId, SUM( sc.score ) AS sum FROM sc GROUP BY sc.SId ORDER BY SUM( sc.		score ) DESC ) AS t1,
	( SELECT @curRank := 0,@preScore := null ) AS t2;
```

