# TCL
/*
 * 事务控制语言 Transaction Control Language
 * 
 * 事务：一个或一组SQL语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行
 * 整个单独的单元作为一个不可分割的整体，如果单元中某条SQL语句一旦执行失败或产生错误，整个单元将会回滚，即所有受影响的数据将返回到事务开始以前的状态
 * 
 * 存储引擎：在MySQL中的数据用各种不同的技术存储在文件或内存中
 * 查看存储引擎：SHOW ENGINES;
 * 常用的存储引擎：Innodb、Myisam、memory等，其中Innodb支持事务
 * 
 * 事务的特点 ACID属性
 * 1. 原子性 Atomicity
 * 原子性是指食物是一个不可分割的工作单位，事务中的操作要么都发生、要么都不发生
 * 2. 一致性 Consistency
 * 事务必须使数据库从一个一致性状态变换到另一个一致性状态
 * 3. 隔离性 Isolation
 * 一个事物的执行不能被其他事务干扰，即一个事物内部的操作及使用的数据对并发的其他事物是隔离的，并发执行的各个事务之间不能互相干扰
 * 4，持久性 Durability
 * 事务一旦被提交，它对数据库中数据的改变是永久性的，接下来的其他操作和数据库故障不应该对其有任何影响
 * 
 * 事物的创建
 * 
 * 隐式事务：事务没有名次按的开启和结束标记。比如 insert update delete
 * SHOW VARIABLES LIKE 'autocommit';
 * default autocommit='on' 自动提交开启
 * 
 * 显式事务：事务具有明显的开启和结束标记
 * 前提：必须设置自动提交功能禁用 autocommit='off' 
 * SET autocommit=0;
 * 
 */

# step 1. 开启事务
SET autocommit=0;
START TRANSACTION;
# step 2. 编写事务中的SQL语句（select insert update delete）
# ...
# step 3. 结束事务
# 提交事务
COMMIT;
# 回滚事务
ROLLBACK;
# 设置节点（保存点）
# SAVEPOINT 节点名;

# 1. 事务的使用步骤
USE exercise;
DROP TABLE IF EXISTS account;
CREATE TABLE account( 
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(20),
balance DOUBLE
);
INSERT INTO account(username, balance) VALUES('Jack', 1000), ('Joyce', 1000);
# 开启事务
SET autocommit=0;
START TRANSACTION;
# 编写一组事务语句
UPDATE account SET balance = 1500 WHERE username = 'Jack';
UPDATE account SET balance = 500 WHERE username = 'Jack';
# 结束事务
COMMIT;
# or----------
ROLLBACK;

SELECT * FROM account;

# 2. delete和truncate在事务使用时的区别
# 演示delete：支持ROLLBACK
SET autocommit=0;
START TRANSACTION;
DELETE FROM account;
ROLLBACK;
# 演示truncate：不支持ROLLBACK
SET autocommit=0;
START TRANSACTION;
TRUNCATE TABLE account;
ROLLBACK;

# 3. savepoint的使用
# 本例中id=1被删掉，id=3保留
SET autocommit=0;
START TRANSACTION;
TRUNCATE TABLE account;
INSERT INTO account(username, balance) VALUES('Jack', 1000), ('Joyce', 1000), ('Abc', 800);
SELECT * FROM account;
DELETE FROM account WHERE id=1;
SAVEPOINT a;
DELETE FROM account WHERE id=3;
ROLLBACK TO a;



/*
 * 数据库的隔离级别
 * 对于同时运行的多个事务，当这些事务访问数据库中相同的数据时，如果没有采取必要的隔离机制，就会导致各种并发问题
 * 1. 脏读：对于两个事物T1 T2，T1读取了已经被T2【更新但是还没有被提交】的字段。之后若T2回滚，T1读取的内容就是临时切勿小的
 * 2. 不可重复读：对于两个事物T1 T2，T1读取了一个字段，然后T2【更新】了该字段。之后T1在此读取同一个字段，值就不同了
 * 3. 幻读：对于两个事物T1 T2，T1读取了一个字段，然后T2【插入】了一些新的行。之后T1在此读取同一个表，就会多出几行
 * 
 * MySQL支持4种事务隔离级
 * 默认：RepeatableRead
 * 								脏读				不可重复读			幻读
 * 1. READ UNCOMMITTED 			Y				Y					Y
 * 2. READ COMMITTED 			N				Y					Y
 * 3. REPEATABLE READ			N				N					Y
 * 4. SERIALIZABLE				N				N					N
 * 
 * 
 */
# 查看隔离级别
select @@global.transaction_isolation, @@transaction_isolation;
# 设置当前会话的隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



#-----------------------------------------------------
#-----------------------------------------------------
#-----------------------------------------------------
#-----------------------------------------------------

# 视图
/*
 * 含义：虚拟表，和普通表一样使用
 * 通过表动态生成的数据。只保存了sql逻辑，不保存查询结果
 * 
 * 好处：
 * 1. 实现了SQL语句的重用
 * 2. 简化了复杂的SQL操作
 * 3. 保护数据，提高安全性
 * 
 */
USE myemployees;
# 创建视图
/*
 * 语法：
 * CREATE VIEW 视图名
 * AS
 * 查询语句;
 */

# 1. 查询姓名中包含a字符的员工名、部门名和工种信息
# 创建
CREATE VIEW myv1
AS
SELECT last_name, department_name, job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON j.job_id = e.job_id;
# 使用
SELECT * FROM myv1 m WHERE last_name LIKE '%a%';

# 2. 查询各部门的平均工资级别
# 创建视图查看每个部门的平均工资
CREATE VIEW myv2
AS 
SELECT AVG(salary), department_id
FROM employees e 
GROUP BY department_id;
# 使用
SELECT myv2.`AVG(salary)` , jg.grade_level
FROM myv2 
JOIN job_grades jg
ON myv2.`AVG(salary)` BETWEEN jg.lowest_sal AND jg.highest_sal;

# 3. 查询平均工资最低的部门的部门信息
# 用上一步的view创建一个新view
CREATE VIEW myv3
AS
SELECT * FROM myv2 m ORDER BY `AVG(salary)` LIMIT 1;
SELECT * FROM myv3;
# 使用
SELECT d.*, myv3.`AVG(salary)`
FROM myv3 
JOIN departments d 
ON d.department_id = myv3.department_id;

# 视图的修改
/*
 * 方式1
 * CREATE OR REPLACE VIEW 视图名
 * AS
 * 查询语句;
 * 
 * 方式2
 * ALTER VIEW 视图名
 * AS
 * 查询语句;
 */

# 查看视图
DESC myv1;
SHOW CREATE VIEW myv1;

# 删除视图
/*
 * 语法
 * DROP VIEW 视图名1, 视图名2, ...;
 */
DROP VIEW myv1, myv2, myv3;


# Exercise
# 1. 创建视图emp_v1，要求查询电话以011开头的员工姓名、工资、邮箱
CREATE OR REPLACE VIEW emp_v1
AS
SELECT last_name, salary, email
FROM employees e
WHERE phone_number LIKE '011%';

# 2. 创建视图emp_v2，要求查询部门的最高工资高于12000的部门信息
CREATE OR REPLACE VIEW emp_v2
AS
SELECT department_id, MAX(salary)
FROM employees e 
GROUP BY department_id 
HAVING MAX(salary) > 12000;
SELECT d.*, emp_v2.`MAX(salary)`
FROM departments d
JOIN emp_v2
WHERE d.department_id = emp_v2.department_id;

# 视图的更新（不推荐使用）
/*
 * 视图的可更新性和视图中查询的定义有关系，包含以下特点的视图不可更新
 * 1. 包含关键字的SQL语句：分组函数，DISTINCT，GROUP BY，HAVING，UNION，UNION ALL
 * 2. 常量视图
 * 3. SELECT中包含子查询
 * 4. JOIN
 * 5. FROM一个不能更新的视图
 * 6. WHERE子句的子查询引用了FROM子句中的表
 */
# 可以更新的一个例子
CREATE OR REPLACE VIEW myv1
AS
SELECT last_name, email
FROM employees e;
SELECT * FROM myv1;
# 1. 插入 （会同时更改原表数据）
INSERT INTO myv1 VALUES('Geng', 'JACK');
SELECT * FROM employees e ;
# 2. 修改
UPDATE myv1 SET last_name = 'Hu' WHERE last_name = 'Geng';
# 3. 删除
DELETE FROM myv1 WHERE last_name = 'Hu';

# 对比视图与表
/*
 * 					创建于发的关键字				是否实际占用物理空间			使用
 * VIEW				CREATE VIEW					只保存SQL逻辑					查询，支持一部分增删改（不推荐）
 * TABLE			CREATE TABLE				保存实际数据					增删改查
 */

#-------------------------------------------
#-------------------------------------------
#-------------------------------------------
#-------------------------------------------
# 变量
/*
 * 分类
 * 系统变量：全局变量、会话变量
 * 自定义变量：用户变量、局部变量
 */

# 1. 系统变量
/*
 * 说明：变量有系统提供，不是用户定义，属于服务器层面
 * 如果是全局级别，需要加GLOBAL
 * 如果是会话级别，需要加SESSION 		如果不写，默认为SESSION
 * 使用的语法
 * 1. 查看系统变量
 * show global|【session】 variables;
 * 2. 查看满足条件的部分系统变量
 * show global|【session】 variables like '%char%;
 * 3. 查看置顶的某个系统变量的值
 * select @@global|【session】.系统变量名;
 * 4. 为某个系统变量赋值
 * set global|【session】 系统变量名=值;
 * set @@global|【session】.系统变量名=值;
 */

# 全局变量
/*
 * 作用域：服务器每次启动将为所有的全局变量赋予初始值，针对于所有的会话（连接）有效，但是不能跨重启
 */
# 查看所有的全局变量
SHOW GLOBAL VARIABLES;
# 查看部分的全局变量
SHOW GLOBAL VARIABLES LIKE '%character%';
# 查看指定的全局变量的值
SELECT @@GLOBAL.AUTOCOMMIT;
SELECT @@GLOBAL.TRANSACTION_ISOLATION;
# 为某个指定的全局变量赋值
SET @@GLOBAL.AUTOCOMMIT=0;
SET GLOBAL AUTOCOMMIT=1;

# 会话变量
/*
 * 作用域：仅仅针对当前会话（连接）有效
 */
# 查看所有的会话变量
SHOW SESSION VARIABLES;
SHOW VARIABLES;
# 查看部分的会话变量
SHOW SESSION VARIABLES LIKE '%character%';
SHOW VARIABLES LIKE '%character%';
# 查看指定的会话变量的值
SELECT @@SESSION.AUTOCOMMIT;
SELECT @@AUTOCOMMIT;
SELECT @@SESSION.TRANSACTION_ISOLATION;
SELECT @@TRANSACTION_ISOLATION;
# 为某个指定的全局变量赋值
SET @@SESSION.AUTOCOMMIT=0;
SET @@AUTOCOMMIT=0;
SET SESSION AUTOCOMMIT=1;
SET AUTOCOMMIT=1;

# 2. 自定义变量
/*
 * 说明：变量是用户自定义的，不是由系统决定的
 * 使用步骤：声明 赋值 使用（查看、比较、运算等）
 */
# 用户变量
/*
 * 作用域：针对当前会话（连接）有效，同于会话变量的作用域
 * 应用在任何地方：可以在begin...end中间，也可以在外面
 * 
 * step 1. 声明并初始化
 * SET @用户变量名 = 值;
 * SET @用户变量名 := 值;
 * SELECT @用户变量名 := 值;
 * 
 * step 2. 赋值（更新用户变量的值）
 * 方式1：通过SET或SELECT
 * SET @用户变量名 = 值;
 * SET @用户变量名 := 值;
 * SELECT @用户变量名 := 值;
 * 方式2：通过SELECT INTO
 * SELECT 字段 INTO @用户变量名
 * FROM 表;
 * 
 * step 3. 使用（查看用户变量的值）
 * SELECT @用户变量名
 */

# eg
# step 1. 声明并初始化
SET @name='Jack';
SET @count=0;
# step 2. 赋值（更新用户变量的值）
SET @name=123;
SELECT COUNT(*) INTO @count
FROM employees e;
# step 3. 使用
SELECT @name;
SELECT @count;

# 局部变量
/*
 * 作用域：仅仅在定义它的begin...and中有效
 * 应用于begin...end中的第一句话
 * 
 * step 1. 声明
 * DECALRE 局部变量名 类型;
 * DECALRE 局部变量名 类型 DEFAULT 值;
 * 
 * step 2. 赋值（更新局部变量的值）
 * 方式1：通过SET或SELECT
 * SET 局部变量名 = 值;
 * SET 局部变量名 := 值;
 * SELECT @局部变量名 := 值;
 * 方式2：通过SELECT INTO
 * SELECT 字段 INTO 局部变量名
 * FROM 表;
 * 
 * step 3. 使用（查看局部变量的值）
 * SELECT 局部变量名
 */

# 对比
/*
 * 					作用域			定义和使用的位置			语法
 * 用户变量			当前会话			会话中的任何地方			必须加@符号，不用限定类型
 * 局部变量			begin end中		begin end中第一句话		一般不加@（在用SELECT更改值时需要加@），需要限定类型
 */

# eg 声明两个变量并赋初始值，然后求和并打印
# 1. 用户变量
SET @m = 1;
SET @n = 2;
SET @sum = @m + @n;
SELECT @sum;
# 2. 局部变量（不能直接运行，要放在begin...end）
DECLARE m INT DEFAULT 1;
DECLARE n INT DEFAULT 2;
DECLARE sum INT;
SET sum = m + n;
SELECT sum;

#----------------------------------------------------
#----------------------------------------------------
#----------------------------------------------------
# 存储过程和函数
/*
 * 好处
 * 1. 提高代码的重用性
 * 2. 简化操作
 */


# 存储过程
/*
 * 含义：一组预先编译好的SQL语句的集合，理解成批处理语句
 * 好处
 * 1. 提高代码的重用性
 * 2. 简化操作
 * 3. 减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
 * 
 * 创建语法
 * CREATE PROCEDURE 存储过程名(参数列表)
 * BEGIN
 * 		存储过程体（一组合法有效的SQL语句）
 * END
 * 注意：
 * 1. 参数列表包含3部分：参数模式 参数名 参数类型
 * 参数模式：	IN 该参数可以作为输入，也就是该参数需要调用方传入值
 * 			OUT 该参数可以作为输出，也就是该参数需要调用方返回值
 * 			INOUT 该参数既可以作为输入也可以作为输出，也就是该参数需要传入值，又可以返回值
 * 2. 如果存储过程体仅仅只有一句话，begin end可以省略
 * 存储过程体中的每条SQL语句的结尾要求必须加分号
 * 存储过程的结尾可以使用DELIMITER重新设置 DELIMITER $
 * 
 * 调用语法
 * CALL 存储过程名(实参列表);
 * 
 * 删除语法
 * DROP PROCUDURE 存储过程名;
 * 
 * 查看存储过程的信息
 * SHOW CREATE PROCUDURE 存储过程名;
 * 
 */
USE exercise;
DROP TABLE IF EXISTS admin;
CREATE TABLE admin(
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(10),
password_str VARCHAR(10) 
);
INSERT INTO admin VALUES
(NULL, 'Jack', '8888'),
(NULL, 'Joyce', '6666');
SELECT * FROM admin;
# 1. 空参列表
# eg 插入到admin表中的5条记录
CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO admin(username, password_str)
	VALUES ('John', '8989'), ('Lily', '5555');
END;
# 调用
CALL myp1();

# 2. 创建带in模式参数的存储过程
USE myemployees;
# eg 创建存储过程实现查询不同部门的平均工资
CREATE PROCEDURE myp2(IN dep_id INT)
BEGIN
	SELECT AVG(salary), dep_id
	FROM employees e
	WHERE e.department_id = dep_id;
END;
# 调用
CALL myp2('100');

# eg 创建存储过程实现用户是否登录成功
USE exercise;
CREATE PROCEDURE myp3(IN username VARCHAR(10), IN password_str VARCHAR(10))
BEGIN 
	DECLARE login_result INT DEFAULT 0;

	SELECT COUNT(*) INTO login_result
	FROM admin a
	WHERE a.username = username
	AND a.password_str = password_str;
	
	SELECT IF(login_result>0, 'success', 'fail');
END;
# 调用
CALL myp3('Jack', '8888');

# 3. 创建带out模式参数的存储过程
# 4. 创建带inout模式参数的存储过程
# eg 创建a和b，最终a和b翻倍并返回
CREATE PROCEDURE myp4(INOUT a INT, INOUT b INT)
BEGIN 
	SET a = a*2;
	SET b = b*2;
END;
SET @m = 10;
SET @n = 20;
CALL myp4(@m, @n);


# 函数
/*
 * 好处
 * 1. 提高代码的重用性
 * 2. 简化操作
 * 3. 减少了编译次数并且减少了和数据库服务器的连接次数，提高了效率
 * 
 * 与存储过程的区别
 * 存储过程可以有0个返回、1个返回、多个返回，适合做批量插入、批量更新
 * 函数有且仅有一个返回值，适合做处理数据后返回一个结果
 * 
 * 创建语法
 * CREATE FUNCTION 函数名(参数列表) RETURNS 返回类型
 * BEGIN
 * 		函数体
 * END
 * 
 * 注意：
 * 1. 参数列表包含两部分：参数名 参数类型
 * 2. 函数体中一定会有return语句，如果没有会报错
 * 3. 如果函数体中仅有一句话，则可以省略begin end
 * 4. 使用delimiter语句设置结束标记
 * 
 * 调用语法
 * SELECT 函数名(参数列表);
 * 
 * 查看函数
 * SHOW CREATE FUNCTION 函数名;
 * 
 * 删除函数
 * DROP FUNCTION 函数名;
 */
SET @@GLOBAL.log_bin_trust_function_creators=1;
USE myemployees;
# 1， 无参数有返回 
# eg 返回员工人数
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	DECLARE c INT DEFAULT 0;
	SELECT COUNT(*) INTO c
	FROM employees;
	RETURN c;
END;
SELECT myf1();
# 2. 有参有返回
# eg 1. 根据员工名，返回他的工资
CREATE FUNCTION myf2(empName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @sal=0; # 定义用户变量
	SELECT MAX(salary) INTO @sal
	FROM employees e 
	WHERE last_name = empName;
	RETURN @sal;
END;
SELECT myf2('K_ing');
# eg 2. 根据部门名，返回该部门平均工资
CREATE FUNCTION myf3(deptName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	DECLARE sal DOUBLE;
	SELECT AVG(salary) INTO sal
	FROM employees e
	JOIN departments d
	ON d.department_id = e.department_id 
	WHERE d.department_name = deptName;
	RETURN sal;
END;
SELECT myf3('IT');
# 查看
SHOW CREATE FUNCTION myf3;
# 删除
DROP FUNCTION myf3;

# Exercise 
USE Exercise;
# 1. 创建函数，实现传入两个float，返回二者之和
CREATE FUNCTION test_fun1(num1 FLOAT, num2 FLOAT) RETURNS FLOAT
BEGIN
	DECLARE summation FLOAT DEFAULT 0;
	SET summation = num1 + num2;
	RETURN summation;
END;
SELECT test_fun1(2, 3);

#--------------------------------------
#--------------------------------------
#--------------------------------------
#--------------------------------------
# 流程控制结构
/*
 * 顺序结构：程序从上往下依次执行
 * 分支结构：程序从两条或多条路径中选择一条去执行
 * 循环结构：程序在满足一定条件的基础上，重复执行一段代码
 */

# 分支结构
# 1. IF函数
/*
 * 实现简单的双分支
 * SELECT IF(表达式1, 表达式2, 表达式3);
 * 如果表达式1城里，则返回表达式2的值，否则返回表达式3的值
 * 应用：任何地方
 */

# 2. CASE结构
/*
 * 情况1：实现等值判断
 * CASE 变量|表达式|字段
 * WHEN 要判断的值1 THEN 返回值1或语句1;
 * WHEN 要判断的值2 THEN 返回值2或语句2;
 * ...
 * ELSE 返回值n或语句n;
 * END CASE;
 * 
 * 情况2：实现区间判断
 * CASE 
 * WHEN 判断条件1 THEN 返回值1或语句1;
 * WHEN 判断条件1 THEN 返回值2或语句2;
 * ...
 * ELSE 返回值n或语句n;
 * END CASE;
 * 
 * 特点
 * 1. 可以作为表达式，嵌套在其他语句中使用，可以放在任何地方，begin end中或begin end外面
 * 	  可以作为独立的语句时使用，只能放在begin end中
 * 2. 如果WHEN中的值满足或条件城里，则执行对应的THEN后面的语句，并且结束CASE
 * 	  如果都不满足，则执行ELSE中的语句或值
 * 3. ELSE可以省略，如果ELSE省略，并且所有WHEN条件都不满足，则返回NULL
 */

# eg 创建存储过程，根据传入的成绩，来显示等级
CREATE PROCEDURE test_case(IN score INT)
BEGIN
	CASE 
	WHEN score BETWEEN 90 AND 100 THEN SELECT 'A';
	WHEN score BETWEEN 80 AND 90 THEN SELECT 'B';
	WHEN score BETWEEN 60 AND 80 THEN SELECT 'C';
	ELSE SELECT 'D';
	END CASE;
END;
CALL test_case(65);

# 3. IF结构
/*
 * 功能：实现多重分支
 * 语法
 * if 条件1 then 语句1;
 * elseif 条件2 then 语句2;
 * ...
 * 【else 语句n;】
 * end if;
 * 
 * 只能应用在begin end中
 */
# eg 创建存储过程，根据传入的成绩，返回等级
CREATE FUNCTION test_if(score INT) RETURNS CHAR
BEGIN
	IF score BETWEEN 90 AND 100 THEN RETURN 'A';
	ELSEIF score BETWEEN 80 AND 90 THEN RETURN 'B';
	ELSEIF score BETWEEN 60 AND 80 THEN RETURN 'C';
	ELSE RETURN 'D';
	END IF;
END;
SELECT test_if(86);

# 循环结构
/*
 * 分类：while loop repeat
 * 循环控制：iterate（结束本次循环，继续下一次—） leave（结束当前循环）
 * 
 */
# 1. while（先判断后执行）
/*
 * 【标签:】 while 循环条件 do
 * 		循环体;
 * end while 【标签】;
 */
# 2. loop（没有条件的死循环）
/*
 * 【标签:】 loop
 * 		循环体;
 * end loop 【标签】;
 * 可以用来模拟简单的死循环
 */
# 3. repeat（先执行后判断）
/*
 * 【标签:】 repeat
 * 		循环体;
 * until 结束循环的条件;
 * end repeat 【标签】;
 */

# 没有添加循环控制语句
# eg 批量插入：根据次数插入到admin表中多条记录
CREATE PROCEDURE pro_while1(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 1;
	WHILE i<= insertCount DO
		INSERT INTO admin(username, password_str) VALUES (CONCAT('Rose',i), '666');
		SET i=i+1;
	END WHILE;
END;
CALL pro_while1(3);
SELECT * FROM admin;

# 添加leave语句
CREATE PROCEDURE pro_while2(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 1;
	a: WHILE i<= insertCount DO
		INSERT INTO admin(username, password_str) VALUES (CONCAT('John',i), '666');
		IF i >= 20 THEN LEAVE a;
		END IF;
		SET i=i+1;
	END WHILE a;
END;

CALL pro_while2(25);

# 添加iterate语句
CREATE PROCEDURE pro_while3(IN insertCount INT)
BEGIN 
	DECLARE i INT DEFAULT 0;
	a: WHILE i<= insertCount DO
		SET i = i+1;
		IF i%2 = !0 THEN ITERATE a;
		END IF;
		INSERT INTO admin(username, password_str) VALUES (CONCAT('John',i), '666');
	END WHILE a;
END;
CALL pro_while3(10);

# eg 插入随机字符串
DROP TABLE IF EXISTS stringcontent;
CREATE TABLE stringcontent( 
id INT PRIMARY KEY AUTO_INCREMENT,
content VARCHAR(20)
);

CREATE PROCEDURE test_randstr_insert(IN insertCOunt INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE str VARCHAR(26) DEFAULT 'abcdefghijklmnopqrstuvwxyz';
	DECLARE startIndex INT DEFAULT 1; # 起始索引
	DECLARE len INT DEFAULT 1; # 代表截取的字符的长度
	WHILE i <= insertCount DO
		SET len = FLOOR(RAND()*(21-startIndex)+1);# 产生一个随机的整数，代表截取长度
		SET startIndex = FLOOR(RAND()*26+1);
		INSERT INTO stringcontent(content) VALUES(SUBSTR(str, startIndex, len));
		SET i = i+1;
	END WHILE;
END;

CALL test_randstr_insert(10);
SELECT * FROM stringcontent s;




