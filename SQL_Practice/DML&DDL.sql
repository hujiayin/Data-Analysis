# DML语言
/*
 * 数据操作语言
 * 插入：insert
 * 修改：update
 * 删除：delete
 * 
 */

# 插入语句
/*
 * 语法1：
 * insert into 表名(列名, ...) values(新值1, ...)
 * 
 * 1. 插入的值的类型要与列的类型一致或兼容
 * 2. 不可以为NULL的列必须插入值;
 * 	  可以为NULL的列如何插入值：1.写列名写NULL值；2.不写列名不写值
 * 3. 列的顺序可以调换，随之值的顺序也要调换
 * 4. 列和值得个数必须一致
 * 5. 可以省略列名，默认所有列，且列的顺序和表中列的顺序一致
 * 		INSERT INTO 表名 VALUES(值1, ...)
 * 
 * 语法2：
 * insert into 表名 set 列名1=值1, ...
 * 
 * 两种方法对比
 * 1. 语法1支持插入多行insert into 表名(列名, ...) values(新值1, ...), (新值1, ...), ...
 * 2. 语法1支持子查询 insert into 表名(列名, ...) select语句
 */

# 修改语句
/*
 * 1. 修改单表的记录
 * 语法：
 * update 表名 set 列1=新值1, 列2=新值2,...
 * where 筛选条件
 * 
 * 2. 修改多表的记录
 * 使用场景：要通过一张表的信息找到另一张表需要更改的部分
 * 语法：
 * SQL92
 * update 表1 别名1, 表2 别名2
 * set 列=值, ...
 * where 连接条件 and 筛选条件
 * 
 * SQL99
 * update 表1 别名1
 * inner|left|right join 表2 别名2
 * on 连接条件
 * set 列=值, ...
 * where 筛选条件
 */
 
# 删除语句
/*
 * 语法1：delete 删除符合条件的记录
 * 1. 单表的删除
 * delete from 表名 where 筛选条件
 * 2. 多表的删除
 * sql92
 * delete 别名1, 别名2 （删谁加谁）
 * from 表1 别名1, 表2 别名2
 * where 连接条件 and 筛选条件
 * 
 * sql99
 * delete 别名1, 别名2
 * from 表1 别名1 
 * inner|left|right 表2 别名2
 * on 连接条件
 * where 筛选条件
 * 
 * 语法2：truncate 删除整张表
 * truncate table 表名
 * truncate语法中没有where
 * 
 * 比较
 * 1. delete可以加where条件，truncate不能加
 * 2. truncate删除，效率高一点
 * 3. 假如要删除的表中有自增长列
 * 		如果用delete删除后，再插入数据，自增长列的值从断点开始
 * 		如果用truncate删除后，再插入数据，自增长列的值从1开始
 * 4. truncate删除后没有返回值，delete删除有返回值
 * 5. truncate删除不能回滚，delete删除可以回滚
 */

# Exercise
# 1. 运行以下脚本创建表my_employees
USE myemployees; # 指定表所在的数据库
CREATE TABLE my_employees(
id INT(10),
first_name VARCHAR(10),
last_name VARCHAR(10),
userid VARCHAR(10),
salary double(10,2)
);
CREATE TABLE users( id INT(10),
userid VARCHAR(10),
department_id INT 
);

# 2. 显示表my_employees的结构
DESC my_employees;

# 3. 向my_employees插入数据
# Method 1
INSERT INTO my_employees
VALUES(1, 'patel', 'Ralph', 'Rpatel', 895),
(2, 'Dancs', 'Betty', 'Bdancs', 860),
(3, 'Biri', 'Ben', 'Bbiri', 1100),
(4, 'Newman', 'Chad', 'Cnewman', 750),
(5, 'Ropeburn', 'Audrey', 'Aropebur', 1550);
SELECT * FROM my_employees;
DELETE FROM my_employees;
# Method 2
INSERT INTO my_employees
SELECT 1, 'patel', 'Ralph', 'Rpatel', 895 UNION
SELECT 2, 'Dancs', 'Betty', 'Bdancs', 860 UNION
SELECT 3, 'Biri', 'Ben', 'Bbiri', 1100 UNION
SELECT 4, 'Newman', 'Chad', 'Cnewman', 750 UNION
SELECT 5, 'Ropeburn', 'Audrey', 'Aropebur', 1550;

# 4. 向users插入数据
INSERT INTO users
VALUES(1, 'Rpatel', 10),
(2, 'Bdancs', 10),
(3, 'Bbiri', 20),
(4, 'Cnewman', 30),
(5, 'Aropebur', 40);
SELECT * FROM users;
DELETE FROM users;
# Method 2
INSERT INTO users
SELECT 1, 'Rpatel', 10 UNION
SELECT 2, 'Bdancs', 10 UNION
SELECT 3, 'Bbiri', 20 UNION
SELECT 4, 'Cnewman', 30 UNION
SELECT 5, 'Aropebur', 40;

# 5. 将3号员工的last_name修改为drelxer
UPDATE my_employees SET last_name='drelxer' WHERE id=3;

# 6. 将工资少于900的员工工资改为1000
UPDATE my_employees SET salary=1000 WHERE salary<900;

# 7. 将user_id为Bbiri的users表和my_employee表的记录全部删除
DELETE u, e
FROM users u
JOIN my_employees e
ON u.userid=e.userid
WHERE u.userid='Bbiri';

# 8. 删除所有数据
DELETE FROM my_employees;
DELETE FROM users;

# 9. 检查所做的修正
SELECT * FROM my_employees;
SELECT * FROM users;

# 10. 清空表my_employees
TRUNCATE TABLE my_employees;

# DDL语言
/*
 * 数据定义语言(Data Define Language)：库和表的管理
 * 1. 库的管理
 * 创建、修改、删除
 * 2. 表的管理
 * 创建、修改、删除
 * 
 * 创建：create
 * 修改：alter
 * 删除：drop
 */

# 库的管理
# 1. 库的创建
/*
 * 语法：
 * create database [if not exists] 库名;
 */
# eg 创建库Books
CREATE DATABASE books;
CREATE DATABASE IF NOT EXISTS books; # recommended 

# 2. 库的修改
# 重命名数据库（已弃用）
RENAME DATABASE books TO newbooks; # deprecated
# 更改库的字符集
ALTER DATABASE books CHARACTER SET gbk;

# 3. 库的删除
DROP DATABASE IF EXISTS books;

# 表的管理
# 1. 表的创建
/*
 * create table 【if not exists】 表名(
 * 列名 列的类型【(长度) 约束】,
 * 列名 列的类型【(长度) 约束】,
 * ...
 * )
 */
# eg 创建表Book
USE books;
CREATE TABLE Book(
id INT,
bName VARCHAR(20),
price DOUBLE,
authorId INT,
publishDate DATETIME
);
DESC Book;
# eg 创建表Author
CREATE TABLE Author(
id INT,
auName VARCHAR(20),
nation VARCHAR(10)
);
DESC Author;

# 2. 表的修改
/*
 * alter table 表名 add|drop|modify|change| column 列名 【列类型/约束】;
 */
# a. 修改列名
ALTER TABLE Book CHANGE COLUMN publishDate pubDate DATETIME;
# b. 修改列的类型或约束
ALTER TABLE Book MODIFY COLUMN  pubDate TIMESTAMP;
# c. 添加新列
ALTER TABLE Author ADD COLUMN annual DOUBLE;
# d. 删除列
ALTER TABLE Author DROP COLUMN annual;
# e. 修改表名
ALTER TABLE Author RENAME TO book_author;
ALTER TABLE book_author RENAME TO Author;

# 3. 表的删除
DROP TABLE Author;
DROP TABLE IF EXISTS Author;
SHOW TABLES;

# 通用的写法
DROP DATABASE IF EXISTS 库名;
CREATE DATABASE 库名();
DROP TABLE IF EXISTS 表名;
CREATE TABLE 表名();

# 4. 表的复制
INSERT INTO Author VALUES
(1, '村上春树', '日本'),
(2, '莫言', '中国'),
(3, '冯唐', '中国'),
(4, '金庸', '中国');
SELECT * FROM Author;

# a. 仅仅复制表的结构
CREATE TABLE copy LIKE author;
SELECT * FROM copy;

# b. 复制表的结构和数据
CREATE TABLE copy2
SELECT * FROM Author;
SELECT * FROM copy2;

# c. 复制表的一部分结构和数据
CREATE TABLE copy3
SELECT id, auName FROM Author;
SELECT * FROM copy3;

# d. 复制表的一部分结构
CREATE TABLE copy4
SELECT id, auName FROM Author
WHERE 0;
SELECT * FROM copy4;

# Exercise
CREATE DATABASE IF NOT EXISTS exercise;
USE exercise;
# 1. 创建表
CREATE TABLE dept1(
id INT(7),
NAME VARCHAR(25)
);
DESC dept1;
# 2. 将表department中的数据插入新表dept2中
CREATE TABLE dept2
SELECT * 
FROM myemployees.departments;
DESC dept2;
# 3. 创建表emp5
CREATE TABLE emp5( 
id INT(7),
first_name VARCHAR(25),
last_name VARCHAR(25),
dept_id INT(7)
);
DESC emp5;
# 4. last_name列长度增加到50
ALTER TABLE emp5 MODIFY COLUMN last_name VARCHAR(50);
# 5. 根据表employees创建employees2
CREATE TABLE employees2 LIKE myemployees.employees;
# 6. 删除表emp5
DROP TABLE IF EXISTS emp5;
# 7. 将表employees2重命名为emp5
ALTER TABLE employees2 RENAME TO emp5;
# 8. 在emp5中添加新列test_column
ALTER TABLE emp5 ADD COLUMN test_column INT;
# 9. 删除表emp5中的test_column列
ALTER TABLE emp5 DROP COLUMN test_column;

# 常见的数据类型
/*
 * 数值型：
 * 		整型：
 * 		小数：定点数 浮点数
 * 字符型：
 * 		较短的文本：CHAR VARCHAR
 * 		较长的文本：text blob
 * 日期型
 * 
 * 选择数据类型的原则：越简单越好，能保存数值的类型越小越好
 */

/*
 * 整型 5类
 * 整数类型			字节			有符号范围			无符号范围
 * tinyint			1			-2^7~2^7-1			2^8
 * smallint			2			-2^15~2^15-1		2^16
 * mediumint		3			-2^23~2^23-1		2^24
 * int/integer		4			-2^31~2^31-1		2^32
 * bigint			8			-2^63~2^63-1		2^34
 * 
 * 特点
 * 1. 如果不设置有无符号，默认是有符号，如果要设置无符号，加UNSIGNED
 * 2. 插入的数值超出整型范围，会报错out of range
 * 3. 如果不设置长度，会有默认长度。长度是指数字的位数，当搭配使用关键字zerofill时，数字在左边以0补齐到设定长度，并且忽略符号
 * 
 */
CREATE DATABASE datatype_test;
USE datatype_test;

# 如何设置无符号有符号
# 默认有符号
CREATE TABLE tab_int( 
t1 INT
);
DESC tab_int;
INSERT INTO tab_int VALUES(-101);
# 设置无符号
DROP TABLE IF EXISTS tab_int;
CREATE TABLE tab_int( 
t1 INT,
t2 INT UNSIGNED
);
DESC tab_int;
INSERT INTO tab_int VALUES(-101, -101); # error
# 设置长度
DROP TABLE IF EXISTS tab_int;
CREATE TABLE tab_int( 
t1 INT(7) ZEROFILL,
t2 INT(7) ZEROFILL UNSIGNED
);
INSERT INTO tab_int VALUES(101, 101); 
SELECT * FROM tab_int;

/*
 * 小数
 * 浮点型：
 * 									字节
 * float(M, D)						4
 * double(M, D) 					8
 * 
 * 定点型：
 * DEC(M, D)/ DECIMAL(M, D)			M+2
 * 最大范围与double相同，但精度更高
 * 
 * 特点：
 * 1. M和D是什么？M:整数部位+小数部位 D:小数部位 M和D均可省略。对于decimal默认为(10,0)；对于float和double会根据插入的数值精度来决定
 * 2. 定点型的精确度较高，如果要求插入数值精度高建议使用定点型，如货币计算
 * 
 * 
 */
# 测试M和D
CREATE TABLE tab_float( 
f1 FLOAT(5, 2),
t2 DOUBLE(5, 2),
f3 DECIMAL(5, 2)
);
SELECT * FROM tab_float;
INSERT INTO tab_float VALUES(123.45, 123.45, 123.45);
INSERT INTO tab_float VALUES(123.456, 123.456, 123.456); # round
INSERT INTO tab_float VALUES(123.4, 123.4, 123.4);
INSERT INTO tab_float VALUES(1523.4, 1523.4, 1523.4); # out of range error

/*
 * 字符：
 * 
 * 1. 较短的文本
 * char(M)：固定长度的字符，比较耗费空间，效率较高，对于存储固定长度的内容建议使用。M可以省略，默认为1
 * varchar(M)：可变长度的字符，比较节省空间，效率较低。M不可以省略
 * M该字段保存最多的字符数
 * 
 * 2. 二进制
 * binary：
 * varbinary
 * 
 * 3. 枚举
 * Enum()只能插入规定的字符串，不区分大小写
 * 
 * 4. 集合
 * set() 插入多个规定的字符串，不区分大小写
 */
# 测试enum
CREATE TABLE tab_char( 
c1 ENUM('a', 'b', 'c')
);
SELECT * FROM tab_char tc;
INSERT INTO tab_char VALUES('a');
INSERT INTO tab_char VALUES('b');
INSERT INTO tab_char VALUES('c');
INSERT INTO tab_char VALUES('m'); # error
INSERT INTO tab_char VALUES('A');

CREATE TABLE tab_set( 
s1 set('a', 'b', 'c', 'd')
);
SELECT * FROM tab_set ts;
INSERT INTO tab_set VALUES('a');
INSERT INTO tab_set VALUES('a,');
INSERT INTO tab_set VALUES('a,c,b');

/*
 * 日期型
 * 1. date 4字节
 * 2. time 3字节
 * 3. year 1字节
 * 4. datetime 8字节 1000-01-01 00:00:00  ~  9999-12-31 23:59:59
 * 5. timestamp 4字节 19700101 08001  ~  2038年的某时刻  受时区和MySQL版本影响
 * 
 */
CREATE TABLE tab_date(
t1 DATETIME,
t2 TIMESTAMP
);
INSERT INTO tab_date VALUES(NOW(), NOW());
SELECT * FROM tab_date;
SHOW VARIABLES LIKE 'time_zone';
SET time_zone = '+9:00'

# 常见约束
/*
 * 含义：一种限制，用于线指标中的数据，为了保证表中数据的准群和可靠性
 * 分类
 * 1. NOT NULL 非空，用于保证该字段的值不能为空。比如姓名学号等
 * 2. DEFAULT 默认，用于保证该字段有默认值。比如性别
 * 3. PRIMARY KEY 主键，用于保证该字段的值非空且唯一。比如学号、员工编号
 * 4. UNIQUE 唯一，用于保证该字段的值具有唯一性，可以为空。比如座位号
 * 5. CHECK 检查，【在MySQL中不支持】
 * 6. FOREIGN KEY 外键，用于限制两个表的关系，用于保证该字段的值必须来自与主表的关联列的值（在从表添加外键约束，用于引用主表中的某列的值）
 * 添加约束的时机：
 * 1. 创建表时
 * 2. 修改表时
 * 约束添加分类：
 * 1. 列级约束：6类约束均可写，但FOREIGN KEY无效
 * 2. 表级约束：除了NOT NULL和DEFAULT，其他约束均可
 * 
 * 主键和唯一的对比
 * 						保证唯一性		是否允许为空			一个表中可以有多少个		是否允许组合（不推荐）
 * PRIMARY KEY				Y				N						0-1					Y PRIMARY KEY(字段1, 字段2)
 * UNIQUE					Y				Y						多个					Y UNIQUE(字段1, 字段2)
 * 
 * 外键注意事项
 * 1. 要求在从表中设置外键关系
 * 2. 从表的外键列的类型和主表的关联列的类型要求一致或兼容
 * 3. 主表的关联列必须是一个key（一般为PRIMARY KEY或UNIQUE）
 * 4. 插入数据时，先插入主表，再插入从表；删除数据时，先删除从表，再删除主表
 * 
 */

CREATE DATABASE student_constrain;
USE student_constrain;

# 创建表时添加约束
# 1. 添加列级约束
/*
 * 直接在字段名和类型后面住家约束类型即可
 * 只支持：DEFAULT/ NOT NULL/ PRIMARY KEY/ UNIQUEpp
 */
CREATE TABLE stuInfo( 
 id INT PRIMARY KEY, # 主键
 stuName VARCHAR(20) NOT NULL, # 非空
 gender CHAR(1) CHECK(gender = '男' OR gender = '女'), # 检查（没有作用）
 seat INT UNIQUE, # 唯一
 age INT DEFAULT 18, # 默认
 majorId INT REFERENCES major(id) # 外键（没有作用）
);
DESC stuInfo;
# 查看所有的索引信息，包括主键、外键和唯一
SHOW INDEX FROM stuInfo;
CREATE TABLE major( 
id INT PRIMARY KEY,
majorName VARCHAR(20)
);

# 2. 添加表级约束
/*
 * 语法：在各个字段的最下面
 * 【CONSTAINT 约束名】 约束类型(字段名),
 */
DROP TABLE IF EXISTS stuInfo;
CREATE TABLE stuInfo( 
 id INT, 
 stuName VARCHAR(20), 
 gender CHAR(1), 
 seat INT, 
 age INT, 
 majorId INT,
 CONSTRAINT pk PRIMARY KEY(id), # primary key （单独命名是无效的，最终都会变为PRIMARY）
 CONSTRAINT uq UNIQUE(seat), # unique (no use)
 CONSTRAINT ck CHECK(gender = '男' OR gender = '女'), # check (no use)
 CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id) # foreign key
);
DESC stuInfo;
SHOW INDEX FROM stuInfo;

# 通用写法：
CREATE TABLE IF NOT EXISTS stuInfo( 
 id INT PRIMARY KEY, # 主键
 stuName VARCHAR(20) NOT NULL, # 非空
 gender CHAR(1),
 seat INT UNIQUE, # 唯一
 age INT DEFAULT 18, # 默认
 majorId INT,
 CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id) # foreign key
 );

# 修改表时添加约束
/*
 * 添加列级约束
 * ALTER TABLE 表名 MODIFY COLUMN 字段名 字段类型 新约束;
 * 添加表级约束
 * ALTER TABLE 表名 ADD 【CONSTRAINT 约束名】 约束类型(字段名);
 */
# 1. 添加非空约束
ALTER TABLE stuInfo MODIFY COLUMN gender CHAR(1) NOT NULL;
# 2. 添加默认约束
ALTER TABLE stuInfo MODIFY COLUMN age INT DEFAULT 18;
# 3. 添加主键
# 列级约束
ALTER TABLE stuInfo MODIFY COLUMN id INT PRIMARY KEY;
# 表级约束
ALTER TABLE stuInfo ADD PRIMARY KEY(id);
# 4. 添加UNIQUE
# 列级约束
ALTER TABLE stuInfo MODIFY COLUMN seat INT UNIQUE;
# 表级约束
ALTER TABLE stuInfo ADD UNIQUE(seat);
# 5. 添加外键
ALTER TABLE stuInfo ADD CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id);

# 修改表时删除约束
# 1. 删除非空约束
ALTER TABLE stuInfo MODIFY COLUMN gender CHAR(1) NULL;
# 2. 删除默认约束
ALTER TABLE stuInfo MODIFY COLUMN age INT;
# 3. 删除主键
# 列级约束
ALTER TABLE stuInfo MODIFY COLUMN id INT;
# 表级约束
ALTER TABLE stuInfo DROP PRIMARY KEY;
# 4. 删除UNIQUE
# 列级约束
ALTER TABLE stuInfo MODIFY COLUMN seat INT;
# 表级约束
ALTER TABLE stuInfo DROP INDEX seat;
# 5. 删除外键
ALTER TABLE stuInfo DROP FOREIGN KEY fk_stuinfo_major;

# Exercise
USE exercise;
# 添加主键
ALTER TABLE emp5 MODIFY COLUMN employee_id INT PRIMARY KEY;
#--------------
ALTER TABLE emp5 ADD PRIMARY KEY(employee_id);
# 添加外键
ALTER TABLE dept2 ADD PRIMARY KEY(department_id);
ALTER TABLE emp5 ADD CONSTRAINT fk_emp5_dept2 FOREIGN KEY(department_id) REFERENCES dept2(department_id);

/*
 * 总结
 * 				位置			支持的约束类型							是否可以起约束名
 * 列级约束		列的后面		语法都支持，但FOREIGN KEY无效			不可以
 * 表级约束		所有列下面	DEFAULT和NOT NULL不支持，其他支持		可以（对于主键无效）
 */

# 标识列（自增长列）
/*
 * 含义：可以不用手动的插入值，系统提供默认的序列值
 * 
 * Trick：
 * 默认情况下自增长起始值1，步长1。通过SET可以更改步长。虽然不可以通过SET改变自增长的起始值，
 * 但是在插入值时手动插入指定值，即可达到改变自增长初始值或任意位置值的目的
 * 
 * 特点
 * 1. 标识列不是必须和主键搭配，但要求与key搭配（PRIMARY KEY、UNIQUE、FOREIGN KEY）
 * 2. 一个表中只能有一个自增长列
 * 3. 标识列类型只能为数值型
 * 4. 标识列通过SET AUTO_INCREMENT_INCREMENT = 步长;来设置步长，也可通过手动插入值设置起始值
 * 
 */
USE student_constrain;
# 1， 创建表时设置标识列
DROP TABLE IF EXISTS tab_identity;
CREATE TABLE tab_identity( 
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20)
);
INSERT INTO tab_identity VALUES(NULL, 'Jack');
SELECT * FROM tab_identity;

# 设置自增长变量的步长
SHOW VARIABLES LIKE '%AUTO_INCREMENT%';
SET AUTO_INCREMENT_INCREMENT = 3;
SET AUTO_INCREMENT_INCREMENT = 1;

# 2. 修改表时设置标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;
# 3. 修改表时删除标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY;



