# 进阶1: 基础查询
/*
语法
SELECT 查询列表 from 表名；

类似于：System.out.println(打印东西);

特点：
1. 查询列表可以是：表中的字段、常量值、表达式、函数
2. 查询的结果是一个虚拟的表格
*/

USE myemployees;

# 1. 查询表中的单个字段
SELECT last_name FROM employees;

# 2. 查询表中的多个字段
SELECT last_name, salary, email FROM employees;

# 3. 查询表中的所有字段 (* 列顺序与原表完全一样）
SELECT * FROM employees e;

# `着重号`用法: 区分SQL关键字和字段名

# 4. 查询常量值
SELECT 100;
SELECT 'john';

# 5. 查询表达式
SELECT 100%98;

# 6. 查询函数
SELECT VERSION();

# 7. 起别名
/*
 好处：
 1. 便于理解
 2. 如果要查询的字段有重名的情况，使用别名可以区分开
 */
# Method 1: AS
SELECT 100%98 AS result;
# Method 2; space
SELECT last_name lastname, first_name firstname FROM employees e;
# 当别名中含有关键字时，用双引号（or 单引号）
SELECT last_name "last name", first_name "first name" FROM employees e;

# 8. 去重 DISTINCT
# 案例：查询员工表中涉及到的所有部门编号
SELECT DISTINCT department_id FROM employees e;

# 9. +的作用
/*
 java中的+：
 1. 运算符：两个操作数都为数值型
 2. 连接符：只要有一个操作数为字符串
 
 mysql中的+：
 仅仅只有一个功能：运算符
 SELECT 100+90; 两个操作数都为数值型，则做加法运算
 其中一方为字符型，试图将字符型数值转换成数值型
 SELECT '100'+90; 如果转换成功，则做加法运算
 SELECT 'john'+90; 如果转换失败，则将字符转换成0做加法运算
 SELECT null+90; 如果一方为NULL，则结果为NULL
 */
# 连接字符串：concat
# 当某些字段为NULL，则concat结果为NULL
# 案例：查询员工名和姓连接成一个字段。并显示为姓名
SELECT
	CONCAT(last_name, ' ', first_name) AS Name
FROM
	employees e;

# Exercise
# 显示出表employees的几列，各列之间用comma连接，列名为OUTPUT
# （由于commission_pct列存在NULL，因此要成功连接需要分情况讨论
SELECT
	IFNULL(commission_pct, 0) AS new_commission_pct,
	commission_pct
FROM
	employees e;
#------------------------------------
SELECT
	CONCAT(first_name, ',', last_name, ',', job_id, ',', IFNULL(commission_pct, 0)) AS 'OUTPUT'
FROM
	employees e;


# 显示表的结构
DESC departments;

# 进阶2：条件查询
/*
 * 语法：
 * SELECT 查询列表
 * FROM 表名
 * WHERE 筛选条件；
 * 
 * 分类：
 * 1. 按条件表达式筛选 
 * 条件运算符：> < = != <> >= <=
 * 2. 按逻辑表达式筛选 
 * 逻辑运算符：&& || ! and or not
 * 作用：连接条件表达式
 * && and：两个条件都为true，结果为true，反之为false
 * || or：只要有一个条件为true，结果为true，反之为false
 * ! not：如果连接条件为false，结果为true，反之为false
 * 3. 模糊查询
 * like 
 * between and
 * in 
 * is null
 */
# 1. 按条件表达式筛选 
# eg 1. 查询工资大于12000的员工信息
SELECT
	*
FROM
	employees e
WHERE
	salary > 12000;
# eg 2. 查询部门编号不等于90的员工名和部门编号
SELECT
	last_name,
	department_id
FROM
	employees e
WHERE
	department_id <> 90;

# 2. 按逻辑表达式筛选
# eg 1. 查询工资在10000到20000之间的员工名、工资及奖金
SELECT
	last_name,
	salary,
	commission_pct
FROM
	employees e
WHERE
	salary >= 10000
	and salary <= 20000;
# eg 2. 查询部门编号不是在90到110之间，或者工资高于15000的员工信息
SELECT
	*
FROM
	employees e
WHERE
	department_id < 90
	OR department_id > 110
	OR salary > 15000;
# or
SELECT
	*
FROM
	employees e
WHERE
	NOT(department_id >= 90
	AND department_id <= 110)
	OR salary > 15000;
# 3. 模糊查询
/*
 * like
 * between and
 * in
 * is null 
 * is not null
 */

# like
/*
 * 特点
 * 1. 一般和通配符搭配使用
 * 通配符
 * 	% 任意多个字符，包含0个字符
 * 	_ 任一单个字符
 */ 
# eg 1. 查询员工名中包含字符a的员工信息
SELECT
	*
FROM
	employees e
WHERE
	last_name LIKE '%a%';
# eg 2. 查询员工名中包含第三个字符为n，第五个字符为l员工名和工资
SELECT
	last_name,
	salary
FROM
	employees e
WHERE
	last_name LIKE '__n_l%';
# eg 3. 查询员工名中第二个字符为_的员工名
SELECT
	last_name
FROM
	employees e
WHERE
	last_name LIKE '_\_%';
# or 指定转义符
 SELECT
	last_name
FROM
	employees e
WHERE
	last_name LIKE '_$_%' ESCAPE '$';

# between and
/*
 * 特点
 * 1. 使用between and 可以提高语句的简洁度
 * 2. 包含两个临界值
 * 3. 两个临界值不可改变顺序
 */
# eg 1. 查询员工编号在100到120之间的员工信息
SELECT
	*
FROM
	employees e
WHERE
	employee_id >= 100
	AND employee_id <= 120;
#-------------------------
SELECT
	*
FROM
	employees e
WHERE
	employee_id BETWEEN 100 AND 120;

# in
/*
 * 用法：判断某字段的值是否属于in列表中的某一项
 * 特点：
 * 1. 使用in提高语句简洁度
 * 2. in 列表的值类型必须一致或兼容
 * 3. 不支持通配符
 */
# eg 1. 查询员工的工种编号是IT_PROG AD_VP AD_PRES中一个的员工名和工种编号
SELECT
	last_name,
	job_id
FROM
	employees e
WHERE
	job_id IN('IT_PROG',
	'AD_VP',
	'AD_PRES');

# is null/ is not null
/*
 * = <>不能用来判断null
 * is null/ is not null 用来判断null
 */
# eg 1. 查询没有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees e
WHERE
	commission_pct IS NULL;
# eg 2. 查询有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees e
WHERE
	commission_pct IS NOT NULL;

# 安全等于 <=>
# eg 1. 查询没有奖金的员工名和奖金率
SELECT
	last_name,
	commission_pct
FROM
	employees e
WHERE
	commission_pct <=> NULL;
# eg 2. 查询工资为12000的员工信息
SELECT
	*
FROM
	employees e
WHERE
	salary <=> 12000;

/* 
 * 比较 is null 和 <=>
 * is null: 仅用来判断null，可读性较高，建议使用
 * <=>: 既可以判断null，又可以判断普通数值，可读性较低
 */
 
# Excercise
# 1. 查询没有奖金，且工资小于18000的salary last_name
SELECT
	salary,
	last_name
FROM
	employees e
WHERE
	commission_pct IS NULL
	AND salary < 18000;

# 2. 查询employees表中，job_id不为IT或者工资为12000的员工信息
SELECT
	*
FROM
	employees e
WHERE
	job_id <> 'IT'
	OR salary = 12000;

# 3. 查看部门department表的结构
DESC departments;
	
# 4. 查询departments表中涉及到了哪些位置编号
SELECT DISTINCT location_id
FROM departments d;

# 5. 面试题：下面命令的结果是否一样
SELECT
	*
FROM
	employees e;
#---------------------
SELECT
	*
FROM
	employees e
WHERE
	commission_pct LIKE '%%'
	AND last_name LIKE '%%';
#---------------------
# 结果不同
# 当判断字段有null时，like不会筛选出null

# 进阶3：排序查询
/*
 * 语法：
 * SELECT 查询列表
 * FROM 表
 * 【where 筛选条件】
 * order by 排序列表 【asc|desc】
 * 
 * 特点
 * 1. asc为升序，desc为降序。默认为asc
 * 2. order by子句中可以支持单个字段、多个字段、表达式、函数、别名
 * 3. order by子句一般是放在查询语句的最后面，limit子句除外
 */

# eg 1. 查询员工信息，要求工资从高到低排序
SELECT
	*
FROM
	employees e
ORDER BY
	salary DESC;
# 改：查询员工信息，要求工资从低到高排序
SELECT
	*
FROM
	employees e
ORDER BY
	salary ASC;
#------------------
SELECT
	*
FROM
	employees e
ORDER BY
	salary;

# eg 2. 查询部门编号>=90的员工信息，按入职时间先后进行排序【添加筛选条件】
SELECT
	*
FROM
	employees e
WHERE
	department_id >= 90
ORDER BY
	hiredate ASC;

# eg 3. 按年薪的高低显示员工的信息和年薪【按表达式排序】
SELECT *, salary * 12 * (1+IFNULL(commission_pct, 0)) AS 'annual salary'
FROM employees e
ORDER BY salary * 12 * (1+IFNULL(commission_pct, 0)) DESC;

# eg 4. 按年薪的高低显示员工的信息和年薪【按别名排序】
SELECT *, salary * 12 * (1+IFNULL(commission_pct, 0)) AS 'annual salary'
FROM employees e
ORDER BY `annual salary` DESC;

# eg 5. 按姓名的长度显示员工的姓名和工资【按函数排序】
SELECT
	LENGTH(last_name) name_length,
	last_name,
	salary
FROM
	employees e
ORDER BY
	LENGTH(last_name) DESC;

# eg 6. 查询员工信息， 要求先按工资排序，再按员工编号排序【按多个字段排序】
SELECT
	*
FROM
	employees e
ORDER BY
	salary ASC,
	employee_id ASC;

# Exercise
# 1. 查询员工的姓名和部门号和年薪，按年薪降序，按姓名升序
SELECT
	last_name,
	department_id,
	salary * 12 * (1 + IFNULL(commission_pct, 0)) AS annual_salary
FROM
	employees e
ORDER BY
	annual_salary DESC,
	last_name ASC;

# 2. 选择工资不在8000到17000的员工的姓名和工资，按工资降序
SELECT
	last_name,
	salary
FROM
	employees e
WHERE
	NOT(salary BETWEEN 8000 AND 17000)
#	salary NOT BETWEEN 8000 AND 17000
ORDER BY
	salary DESC;

# 3. 查询邮箱中包含a的的员工信息，并按邮箱的字节数降序，再按部门号升序
SELECT
	*
FROM
	employees e
WHERE
	email LIKE '%a%'
ORDER BY
	LENGTH(email) DESC,
	department_id ASC;

# 进阶4：常见函数
/*
 * 概念：类似于java的方法，将一组逻辑语句封装在方法体中，对外暴露方法名
 * 好处：
 * 1. 隐藏了实现细节
 * 2. 提高代码的重用性
 * 调用：SELECT 函数名(实参列表) 【from 表】
 * 特点：关注函数名和功能
 * 分类：
 * 1. 单行函数：
 * 字符函数: length concat substr instr trim upper lower lpad rpad replace
 * 数学函数: round ceil floor truncate mod
 * 日期函数: now curdate curtime year month monthname day hour minute second str_to_date date_format
 * 其他函数: version database user
 * 控制函数: if case
 * 2. 分组函数：做统计使用，又称为统计函数、聚合函数、组函数
 * 分类：
 * sum：求和  avg：平均值  max：最大值  min：最小值  count：计算个数
 * 
 */

# A 单行函数
# 字符函数
# 1. length
SELECT LENGTH('john');
SELECT LENGTH('张三丰')；

SHOW VARIABLES LIKE '%char%';

# 2. concat 拼接字符串
SELECT
	CONCAT(last_name, '_', first_name)
FROM
	employees e;

# 3. upper/lower
# eg 姓变成大写字母，名变成小写字母
SELECT
	CONCAT(UPPER(last_name), '_', LOWER(first_name))
FROM
	employees e;

# 4. substr/substring
# index从1开始
# 截取指定index以后的所有字符
SELECT SUBSTR('qwertyuiop', 6)
# 截取指定index以后指定字符长度的字符
SELECT SUBSTR('qwertyuiop', 6, 3)

# eg 姓中首字符大写，其他字符小写，用_拼接
SELECT
	CONCAT(UPPER(SUBSTRING(last_name, 1, 1)), '_', LOWER(SUBSTRING(last_name, 2))) AS last_name
FROM
	employees e;

# 5. instr
# 子串第一次出现的索引，如果找不到返回0
SELECT INSTR('qwertyuiop', 'iop');

# 6. trim
SELECT TRIM('     qwer   ');
SELECT TRIM('a' FROM 'aaaaaqweraaaa');

# 7. lpad 用指定字符实现左填充
SELECT LPAD('qwer', 8, '*');
# 8. rpad 用指定字符实现右填充
SELECT RPAD('qwer', 8, '*');

# 9. replace 替换
SELECT REPLACE('asdfaaa', 'a', 'e')

# 数学函数
# 1. round 四舍五入
SELECT round(1.65);
SELECT round(1.65, 1);

# 2. ceil 向上取整 返回大于等于该参数的最小整数
SELECT CEIL(1.002);
SELECT CEIL(1.000); #1

# 3. floor 向下取整 返回小于等于该参数的最大整数
SELECT FLOOR(9.99);
SELECT FLOOR(-9.99);

# 4. truncate 截断
SELECT TRUNCATE(1.69999, 1);

# 5. mod 取余
/*
 * mod(a, b): a-a/b*b
 */
SELECT mod(-10, 3);
SELECT 10%3

# 日期函数
# 1. now 返回当前系统日期和时间
# 2. curdate 返回当前系统日期
# 3. curtime 返回当前系统时间
SELECT NOW();
SELECT CURDATE();
SELECT CURTIME();

# 4. 获取指定的部分：年月日时分秒
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT MONTHNAME(NOW());

# 5. str_to_date 将日期格式的字符转换成指定格式的日期
/*
 * 日期格式
 * %Y 4位年 %y 2位年
 * %m 2位月 %c 月(1-12)
 * %d 2位日
 * %H 24小时制小时 %h 12小时制小时
 * %i 2位分 %s 2位秒
 */
SELECT STR_TO_DATE('1998-3-2', '%Y-%c-%d');
# eg 查询1992-4-3入职的员工信息
SELECT
	*
FROM
	employees e
WHERE
	hiredate = '1992-4-3';
#-------------------------
SELECT
	*
FROM
	employees e
WHERE
	hiredate = STR_TO_DATE('4-3 1992','%c-%d %Y');

# 6. date_format 将日期转换成日期格式的字符
SELECT DATE_FORMAT(NOW(), 'YEAR:%Y, Month:%m, Day:%d'); 
# eg 查询有奖金的员工名和入职日期（XX月/XX日 XX年）
SELECT last_name, DATE_FORMAT(hiredate, '%m月/%d日 %y年') AS hiredate
FROM employees e 
WHERE commission_pct IS NOT NULL;

# 其他函数
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

# 流程控制函数
# 1. if函数 
SELECT
	last_name,
	commission_pct,
	IF(commission_pct IS NULL,
	'Without Commission',
	'With Commission') commission
FROM
	employees e;

# 2. case函数
/*
 * 使用1：等值判断
 * CASE 要判断的字段或表达式
 * when 常量1 then 要显示的常量1或语句1;
 * when 常量2 then 要显示的常量2或语句2;
 * ...
 * else 要显示的常量n或语句n;
 * end
 */
# eg 查询员工的工资， 要求
/*
 * 部门号=30， 显示工资1.1倍
 * 部门号=40， 显示工资1.2倍
 * 部门号=50， 显示工资1.3倍
 * 其他部门，显示原工资
 */
SELECT salary orginal_salary, department_id, 
CASE department_id 
WHEN 30 THEN salary * 1.1
WHEN 40 THEN salary * 1.2
WHEN 50 THEN salary * 1.3
ELSE salary 
END AS new_salary
FROM employees e;

/*
 * 使用2：用于判断区间
 * CASE 
 * WHEN 条件1 THEN 要显示的值1或语句1;
 * WHEN 条件2 THEN 要显示的值2或语句2;
 * ...
 * ELSE 要显示的值n或语句n
 * END
 */
# eg 查询员工的工资的情况
/*
 * 如果工资>20000，显示'Level A'
 * 如果工资>15000，显示'Level B'
 * 如果工资>10000，显示'Level C'
 * 否则，显示'Level D'
 */
SELECT
	salary,
	CASE WHEN salary>20000 THEN 'Level A'
	WHEN salary>15000 THEN 'Level B'
	WHEN salary>10000 THEN 'Level C'
	ELSE 'Level D' END AS salary_level
FROM
	employees e;

# Exercise
# 1. 查询员工号、姓名、工资及工资提高20%以后的结果
SELECT
	employee_id,
	last_name,
	salary,
	salary * (1 + 0.2) AS new_salary
FROM
	employees e;
# 2. 员工姓名按首字母排序，并写出姓名的长度
SELECT
	last_name,
	SUBSTRING(last_name, 1, 1) AS initial,
	LENGTH(last_name) AS name_length
FROM
	employees e
ORDER BY
	initial ASC;
# 3. <last_name> earns <salary> monthly but wants <salary * 3>.
SELECT
	CONCAT(last_name, ' earns ', salary, ' monthly but wants ', salary * 3, '.') Dream_salary
FROM
	employees e;
# 4. 按职位分等级
SELECT
	last_name,
	job_id job,
	CASE job_id WHEN 'AD_PRES' THEN 'A'
	WHEN 'ST_MAN' THEN 'B'
	WHEN 'IT_PROG' THEN 'C'
	WHEN 'SA_REP' THEN 'D'
	WHEN 'ST_CLERK' THEN 'E' END AS grade
FROM
	employees e;

# B 分组函数
# 分类
# sum：求和  avg：平均值  max：最大值  min：最小值  count：计算个数
/*
 * 特点：
 * 1. 参数支持哪些类型
 * sum avg 一般只适用于数值型
 * min max 可用于数值、字符、日期
 * count 可用于数值、字符、日期，但只计非NULL值
 * 2. 是否忽略NULL值
 * sum avg min max count 忽略NULL值
 * 3. 和distinct搭配去重
 * 4. count的介绍
 * 5. 和分组函数一同查询的字段要求是group by后的字段
 */
# 1. 简单使用
SELECT SUM(salary) FROM employees e;
SELECT AVG(salary) FROM employees e;
SELECT MIN(salary) FROM employees e;
SELECT MAX(salary) FROM employees e;
SELECT COUNT(salary) FROM employees e;

SELECT
	SUM(salary),
	AVG(salary),
	MIN(salary),
	MAX(salary),
	COUNT(salary)
FROM
	employees e;
# 2. 参数类型
# sum avg 一般只适用于数值型
# min max 可用于数值、字符、日期
# count 可用于数值、字符、日期，但只计非NULL值
SELECT SUM(last_name), AVG(last_name) FROM employees e;
SELECT SUM(hiredate), AVG(hiredate) FROM employees e;
SELECT MAX(last_name), MIN(last_name) FROM employees e;
SELECT MAX(hiredate), MIN(hiredate) FROM employees e;
SELECT COUNT(last_name) FROM employees e;
SELECT COUNT(commission_pct) FROM employees e;

# 3. 是否忽略NULL值
# sum avg min max count 忽略NULL值
SELECT SUM(commission_pct), AVG(commission_pct), SUM(commission_pct)/35, SUM(commission_pct)/107 FROM employees e;
SELECT MAX(commission_pct), MIN(commission_pct) FROM employees e;
SELECT COUNT(commission_pct) FROM employees e;

# 4. 和distinct搭配
SELECT SUM(DISTINCT salary), SUM(salary) FROM employees e;
SELECT COUNT(DISTINCT salary), COUNT(salary) FROM employees e;

# 5. count函数详细介绍
# 统计总行数
# 效率：
# MYISAM存储引擎下，COUNT(*)效率高 （MySQL5.5以前的默认存储引擎）
# INNODB存储引擎下，COUNT(*)和COUNT(1)效率差不多，比COUNT(字段)效率高
SELECT COUNT(*) FROM employees e;
SELECT COUNT(1) FROM employees e;

# 6. 和分组函数一同查询的字段有限制
# 没有意义的查询
SELECT AVG(salary), employee_id FROM employees e;

# Exercise 
# 1. 查询员工表中最大入职时间和最小入职时间的相差天数
SELECT DATEDIFF(MAX(hiredate), MIN(hiredate)) Difference
FROM employees e;
# 2. 查询部门编号为90的员工个数
SELECT COUNT(*)
FROM employees e
WHERE department_id = 90;

# 进阶5： 分组查询
/*
 * SELECT 分组函数, 列（要求出现在group by的后面）
 * FROM 表
 * 【where 筛选条件】
 * group by 分组的列表
 * 【order by 子句】
 * 注意：查询列表必须特殊，要求是分组函数和group by后出现的字段
 * 
 * 特点：
 * 1. 分组查询中的筛选条件分为两类：
 * 					数据源			位置				关键字
 * 分组前筛选			原始表			group by子句前	where
 * 分组后筛选			分组后的结果集		group by子句后	having
 * 分组函数做条件一定放在HAVING子句中
 * 能用分组前筛选的，就优先考虑使用分组前筛选
 * 2. group by子句支持单个字段分组、多个字段分组（多个字段之间用逗号隔开没有顺序要求），表达式或函数（用的较少）
 * 3. 也可以添加排序（放在整个语句最后）
 */

# eg 1. 查询每个工种的最高工资
SELECT
	MAX(salary),
	job_id
FROM
	employees e
GROUP BY
	job_id;

# eg 2. 查询每个位置上的部门个数
SELECT
	COUNT(*),
	location_id
FROM
	departments d
GROUP BY
	location_id;
	
# 添加筛选条件（分组前）
# eg 1. 查询邮箱中包含a字符的，每个部门的平均工资
SELECT
	AVG(salary),
	department_id
FROM
	employees e
WHERE
	email LIKE '%a%'
GROUP BY
	department_id;
	
# eg 2. 查询每个领导手下有奖金的员工的最高工资
SELECT MAX(salary), manager_id
FROM employees e 
WHERE commission_pct IS NOT NULL 
GROUP BY manager_id;

# 添加复杂的筛选条件（分组后）
# eg 1. 查询哪个部门的员工个数>2
/*
 * 1. 查询每个部门的员工个数
 * 2. 根据1的结果进行筛选，查询哪个部门的员工个数>2
 */
# Step 1.
SELECT COUNT(*), department_id
FROM employees e 
GROUP BY department_id;
# Step 2.
SELECT COUNT(*), department_id
FROM employees e 
GROUP BY department_id
HAVING COUNT(*)>2;

# eg 2. 查询每个工种有奖金的，最高工资>12000的工种编号和最高工资
SELECT MAX(salary), job_id
FROM employees e 
WHERE commission_pct IS NOT NULL 
GROUP BY job_id
HAVING MAX(salary)>12000;

# eg 3. 查询领导编号>102的每个领导手下的最低工资>5000的领导编号及最低工资
SELECT MIN(salary), manager_id
FROM employees e 
WHERE manager_id > 102
GROUP BY manager_id 
HAVING MIN(salary) > 5000;

# 按表达式or函数分组
# eg 按员工姓名的长度分组，查询每一组员工个数，筛选员工个数>5的
SELECT COUNT(*), LENGTH(last_name) name_len
FROM employees e 
GROUP BY name_len
HAVING COUNT(*) > 5;

# 按多个字段分组
# eg 查询每个部门每个工种的员工的平均工资
SELECT AVG(salary), department_id, job_id
FROM employees e 
GROUP BY department_id, job_id;

# 添加排序
# eg 查询每个部门每个工种的员工的平均工资， 并按平均工资高低排列
SELECT AVG(salary), department_id, job_id
FROM employees e 
GROUP BY department_id, job_id
ORDER BY AVG(salary) DESC;

# Exercise
# 1. 查询各job_id的员工工资的最大值、最小值、平均值、总和，并按job_id升序排列
SELECT job_id, MAX(salary), MIN(salary), AVG(salary), SUM(salary)
FROM employees e
GROUP BY job_id
ORDER BY job_id ASC;
# 2. 查询员工最高工资和最低工资的差距
SELECT MAX(salary)- MIN(salary) Difference
FROM employees e;
# 3. 查询各个管理者手下员工的最低工资，其中最低工资不能低于6000，没有管理者的员工不计算在内
SELECT MIN(salary), manager_id
FROM employees e
WHERE manager_id IS NOT NULL 
GROUP BY manager_id 
HAVING MIN(salary) >= 6000;
# 4. 查询所有部门的编号、员工数量和工资平均值，并按平均工资降序
SELECT department_id, COUNT(*), AVG(salary)
FROM employees e
GROUP BY department_id
ORDER BY AVG(salary) DESC;
# 5. 选择具有各个job_id的员工人数
SELECT job_id, COUNT(*)
FROM employees e 
WHERE job_id IS NOT NULL 
GROUP BY job_id;

# 进阶6: 连接查询（多表查询）
/*
 * 当查询的字段来自多个表，用到连接查询
 * 
 * 笛卡尔乘积现象：表1有m行，表2有n行，简单匹配连接后得到m*n行
 * 原因：没有有效的连接条件
 * 如何避免：添加有效的连接条件
 * 
 * 分类：
 * 1. 按年代分类：
 * 				sql92标准：仅支持内连接
 * 				sql99标准（推荐）：支持内连接+外连接（左外+右外）+交叉连接
 * 2. 按功能分类：
 * 				内连接：等值连接、非等值连接、自连接
 * 				外连接：左外连接，右外连接，全外连接
 * 				交叉连接
 * 
 * sql92与sql99比较
 * 1. 功能：sql99支持的功能多
 * 2. 可读性：sql99实现连接条件和筛选条件的分离，可读性强
 * 
 */

# sql92标准
# 1. 等值连接
/*
 * 1. 多表等值连接的结果为夺标的交集部分
 * 2. n表连接，至少需要n-1个连接条件
 * 3. 多表的顺序没有要求
 * 4. 一般需要为表起别名
 * 5. 可以搭配前面介绍的所有子句使用，比如排序、分组、筛选
 */
# eg 查询员工名对应的部门名
SELECT last_name, department_name
FROM employees e , departments d 
WHERE e.department_id = d.department_id;
/*
 * 连接表时可以为表起别名
 * 1. 提高语句简洁度
 * 2. 区分多个重名字段
 * 如果为表起了别名，就不能用原始的表名
 * 
 */

# 添加筛选
# eg 1. 查询有奖金的员工名和部门名
SELECT last_name, department_name
FROM employees e, departments d 
WHERE e.department_id = d.department_id 
AND e.commission_pct IS NOT NULL;

# eg 2. 查询城市命中第二个字符为o的部门名与城市名
SELECT department_name, city
FROM departments d, locations l 
WHERE d.location_id = l.location_id
AND city LIKE '_o%';

# 添加分组
# eg 1. 查询每个城市的部门个数
SELECT COUNT(*), city
FROM departments d, locations l 
WHERE d.location_id = l.location_id 
GROUP BY city;
# eg 2. 查询有奖金的员工所在部门的部门名和部门领导编号和该部门的最低工资
SELECT department_name, d.manager_id, MIN(salary)
FROM employees e, departments d 
WHERE e.department_id = d.department_id 
AND commission_pct IS NOT NULL 
GROUP BY department_name, d.manager_id;

# 添加排序
# eg 查询每个工种的工种名和员工的个数，并按员工个数降序
SELECT job_title, COUNT(*)
FROM employees e, jobs j 
WHERE e.job_id = j.job_id 
GROUP BY job_title 
ORDER BY COUNT(*) DESC;

# 三表链接
# eg 查询员工名、部门名和所在城市
SELECT last_name, department_name, city
FROM employees e, departments d, locations l 
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id;

# 2. 非等值连接
# 新建一个表
CREATE  TABLE job_grades
(grade_level VARCHAR(3),
lowest_sal INT,
highest_sal INT);
INSERT INTO job_grades
VALUES ('A', 1000, 2999);
INSERT INTO job_grades
VALUES ('b', 3000, 5999);
INSERT INTO job_grades
VALUES ('C', 6000, 9999);
INSERT INTO job_grades
VALUES ('D', 10000, 14999);
INSERT INTO job_grades
VALUES ('E', 15000, 24999);
INSERT INTO job_grades
VALUES ('F', 25000, 40000);

# eg 查询员工的工资和工资级别
SELECT salary, grade_level
FROM employees e, job_grades jg 
WHERE salary BETWEEN jg.lowest_sal AND jg.highest_sal;

# 3. 自连接
# eg 查询员工名和其上级的名字
SELECT e1.last_name employee, e2.last_name manager
from employees e1, employees e2
WHERE e1.manager_id = e2.employee_id;

# Exercise
# 1. 显示所有员工的姓名、部门号和部门名称
SELECT e.last_name, d.department_id, d.department_name 
FROM employees e, departments d 
WHERE e.department_id = d.department_id;

# 2. 查询90号部门的员工的job_id和90号部门的location_id
SELECT
	d.department_id,
	e.job_id,
	d.location_id
FROM
	employees e,
	departments d
WHERE
	e.department_id = d.department_id
	AND d.department_id = 90;

# 3. 选择所有有奖金员工的last_name、department_name、location_id、city
SELECT e.last_name, d.department_name, l.location_id, l.city 
FROM employees e, departments d, locations l 
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id 
AND e.commission_pct IS NOT NULL;

# 4. 选择在Toronto工作的员工的last_name、job_id、department_id、department_name
SELECT e.last_name, e.job_id, e.department_id, d.department_name
FROM employees e, departments d, locations l 
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id 
AND l.city = 'Toronto';

# 5. 查询每个工种、每个部门的部门名、工种名和最低工资
SELECT d.department_name, j.job_title, MIN(salary)
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id 
AND e.job_id = j.job_id
GROUP BY j.job_title, d.department_name;

# 6. 查询每个国家中部门个数大于2的国家编号
SELECT country_id, COUNT(*) 
FROM departments d, locations l 
WHERE d.location_id = l.location_id
GROUP BY country_id
HAVING COUNT(*) > 2;

# sql99标准
/*
 * 语法：
 * SELECT 查询列表
 * FROM 表1 别名 【连接类型】
 * join 表2 别名
 * on 连接条件
 * 【where 筛选条件】
 * 【group by 分组】
 * 【having 筛选条件】
 * 【order by 排序列表】
 * 
 * 分类：
 * 内连接：inner
 * 外连接：左外left 【outer】		右外 right 【outer】		全外 full 【outer】
 * 交叉连接：cross
 * 
 */
# 1. 内连接
/*
 * 语法：
 * SELECT 查询列表
 * FROM 表1 别名 
 * inner join 表2 别名
 * on 连接条件
 * 
 * 特点：
 * 1. 添加排序、分组、筛选
 * 2. inner可以省略
 * 3. 筛选条件放在where后面，连接条件放在on后面，提高分离性，便于阅读
 * 4. inner join连接和sql92语法中等值连接实现的效果一样
 * 
 * 
 */
# 等值连接
# 1. 显示所有员工的姓名、部门号和部门名称
SELECT e.last_name, d.department_id, d.department_name 
FROM employees e
INNER JOIN departments d 
ON e.department_id = d.department_id;

# 2. 查询名字中包含e的员工名和工种名（添加筛选）
SELECT last_name, job_title
FROM employees e 
INNER JOIN jobs j
ON e.job_id = j.job_id 
WHERE e.last_name LIKE '%e%';

# 3. 查询部门个数>3的城市名和部门个数（添加分组+筛选）
SELECT city, COUNT(*)
FROM departments d 
INNER JOIN locations l
ON d.location_id = l.location_id 
GROUP BY city
HAVING COUNT(*) > 3;

# 4. 查询员工个数>3的部门的部门名和员工个数，按员工数降序
SELECT department_name, COUNT(*)
FROM employees e 
INNER JOIN departments d
ON e.department_id = d.department_id 
GROUP BY department_name 
ORDER BY COUNT(*) DESC;

# 5. 查询员工名、部门名、工种名，并按部门排序
SELECT last_name, department_name, job_title
FROM employees e 
INNER JOIN departments d ON e.department_id = d.department_id 
INNER JOIN jobs j ON e.job_id =j.job_id 
ORDER by department_name DESC;

# 非等值连接
# eg 1. 查询员工的工资级别
SELECT salary, grade_level
FROM employees e 
JOIN job_grades jg
ON e.salary BETWEEN jg.lowest_sal AND jg.highest_sal;

# eg 2. 查询每个工资级别的个数>20的个数，并且按工资级别降序
SELECT COUNT(*), grade_level
FROM employees e 
JOIN job_grades jg
ON e.salary BETWEEN jg.lowest_sal AND jg.highest_sal
GROUP BY grade_level
HAVING COUNT(*) > 20
ORDER BY grade_level DESC;

# 自连接
# eg 查询员工名和其上级的名字
SELECT e1.last_name, e2.last_name 
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.employee_id;

# 外连接
/*
 * 应用场景：一个表有，而另一个表中不存在 
 * 特点：
 * 1. 外链接的查询结果为主表中的所有记录。
 * 如果从表中有和它匹配的，则显示匹配的值；
 * 如果从表中没有和它匹配的，则显示NULL。
 * 外连接查询结果=内连接的结果+主表中有但从表中没有的记录
 * 2. 左外连接：LEFT JOIN左边的是主表，RIGHT JOIN右边的是主表
 * 3. 左外连接和右外连接两个表交换顺序，可以实现同样的效果
 * 4. 全外连接=内连接结果+表1中有但表2没有的+表2中有但表1中没有的（MySQL中不支持）
 */

# eg 查询没有员工的部门
SELECT d.*, employee_id
FROM departments d 
LEFT JOIN employees e
ON d.department_id = e.department_id 
WHERE e.employee_id IS NULL;

# 交叉连接
/*
 * SELECT  查询列表
 * FROM 表1 别名 
 * CROSS JOIN 表2 别名
 * 
 * 相当于sql92中以,连接无关键字的笛卡尔乘积结果
 */

# Exercise
# 1. 查询没有部门的城市
SELECT DISTINCT city
FROM locations l 
LEFT JOIN departments d
ON d.location_id = l.location_id
WHERE d.department_id IS NULL;

# 2. 查询部门名为SAL或IT的员工信息
SELECT e.*, d.department_name 
FROM departments d 
LEFT JOIN employees e
ON d.department_id = e.department_id 
WHERE d.department_name IN ('SAL', 'IT');

# 进阶7：子查询
/*
 * 含义：出现在其他语句中的SELECT语句，称为子查询或内查询
 * 外部的查询语句，称为外查询或主查询
 * 
 * 分类：
 * 按子查询出现的位置：
 * 1. select后面：仅仅支持标量子查询
 * 2. from后面：支持表子查询
 * 3. （重点）where或having后面：支持标量子查询、列子查询、行子查询
 * 4. exist后面（相关子查询）：表子查询
 * 按子查询结果集的行列数不同：
 * 1. 标量子查询（结果集只有一行一列）
 * 2. 列子查询（结果集只有一列多行）
 * 3. 行子查询（结果集只有一行多列）
 * 4. 表子查询（结果集一般为多行多列）
 * 
 * 特点：
 * 1. 子查询放在小括号内
 * 2. 子查询一般放在条件的右侧
 * 3. 标量子查询一般搭配着单行操作符使用（> < >= <= = <>)
 */

# where或having后面
/* 1. 标量子查询
 * 2. 列子查询 
 * 3. 行子查询
 * 特点：
 * 1. 子查询放在小括号内
 * 2. 子查询一般放在条件的右侧
 * 3. 标量子查询一般搭配单行操作符使用（> < >= <= = <>); 列子查询一般搭配多行操作符使用（in any some all）
 * 4. 子查询的执行优先于主查询执行，主查询的条件用到了子查询的结果
 */
# 1. 标量子查询
# eg 1. 查询比Abel工资高的员工
# step 1. 查询Abel的工资
SELECT salary
FROM employees e 
WHERE last_name = 'Abel';
# step 2. 查询员工的信息，满足salary>step1的结果
SELECT
	*
FROM
	employees e
WHERE
	salary > (
	SELECT
		salary
	FROM
		employees e
	WHERE
		last_name = 'Abel'
	);

# eg 2. 返回job_id与141号员工相同，salary比143号员工多的员工的姓名、job_id和工资
# step 1. 查询141号员工的job_id
SELECT job_id
FROM employees e 
WHERE employee_id = 141;

# step 2. 查询143号员工的salary
SELECT salary
FROM employees e 
WHERE employee_id = 143;

# step 3. 查询员工的姓名、job_id和工资，满足job_id=step1的结果，salary>step2的结果
SELECT
	last_name,
	job_id,
	salary
FROM
	employees e
WHERE
	job_id = (
	SELECT
		job_id
	FROM
		employees e
	WHERE
		employee_id = 141
	) AND salary > (
	SELECT
		salary
	FROM
		employees e
	WHERE
		employee_id = 143
	);

# eg 3. 工资最少的员工的last_name, job_id和salary
# step 1. 查询公司的最低工资
SELECT MIN(salary) FROM employees e;
# step 2. 查询last_name, job_id和salary，满足salary=step1的结果
SELECT
	last_name,
	job_id,
	salary
FROM
	employees e
WHERE
	salary = (
	SELECT
		MIN(salary)
	FROM
		employees e
	);

# eg 4. 查询最低工资大于50号部门最低工资的部门id和其最低工资
# step 1. 查询50号部门的最低工资
SELECT MIN(salary)
FROM employees e 
WHERE department_id = 50;
# step 2. 查询每个公司的最低工资
SELECT MIN(salary), department_id
FROM employees e 
GROUP BY department_id;
# step 3. 筛选step2，满足>step1结果的
SELECT
	MIN(salary),
	department_id
FROM
	employees e
GROUP BY
	department_id
HAVING
	MIN(salary) > (
	SELECT
		MIN(salary)
	FROM
		employees e
	WHERE
		department_id = 50
	);

# 2. 列子查询
/*
 * 多行操作符
 * IN/NOT IN: 等于/不等于列表中的任意一个
 * ANY/SOME: 和子查询返回的某一个值比较
 * ALL: 和子查询返回的所有值比较
 */

# eg 1. 返回location_id是1400或1700的部门中的所有姓名
# step 1. 查询location_id是1400或1700的部门编号
SELECT DISTINCT department_id
FROM departments d 
WHERE location_id IN (1400, 1700);
# step 2. 查询员工姓名，满足部门号是step1列表中的任意一个
SELECT
	last_name
FROM
	employees e
WHERE
	department_id IN ( #IN can be replaced to =ANY
	SELECT
		DISTINCT department_id
	FROM
		departments d
	WHERE
		location_id IN (1400,
		1700)
	);

# eg 2. 返回其他job_id中比job_id为IT_PROG的任一工资低的员工的员工号、姓名、job_id和salary
# step 1. 查询job_id为IT_PROG的部门的工资
SELECT DISTINCT salary
FROM employees e 
WHERE job_id ='IT_PROG';
# step 2. 查询其他job_id的员工的员工号、姓名、job_id和salary，满足salary<step1中任一值(即<max(step1))
SELECT
	last_name,
	employee_id,
	job_id,
	salary
FROM
	employees e
WHERE
	job_id <> 'IT_PROG'
	AND salary < ANY( # ANY can be replaced to MAX
	SELECT
		DISTINCT salary
	FROM
		employees e
	WHERE
		job_id ='IT_PROG'
	);

# eg 3. 返回其他job_id中比job_id为IT_PROG的所有工资低的员工的员工号、姓名、job_id和salary
SELECT
	last_name,
	employee_id,
	job_id,
	salary
FROM
	employees e
WHERE
	job_id <> 'IT_PROG'
	AND salary < ALL( # ALL can be replaced to MIN
	SELECT
		DISTINCT salary
	FROM
		employees e
	WHERE
		job_id ='IT_PROG'
	);

# 3. 行子查询（不常见）
# eg 查询员工编号最小并且工资最高的员工信息
# 原来的方法
# step 1. 查询最小的员工编号
SELECT MIN(employee_id)
FROM employees e;
# step 2. 查询最高工资
SELECT MAX(salary)
FROM employees e;
# step 3. 查询员工信息
SELECT
	*
FROM
	employees e
WHERE
	employee_id = (
	SELECT
		MIN(employee_id)
	FROM
		employees e)
	AND salary = (
	SELECT
		MAX(salary)
	FROM
		employees e
	);
# 两个条件都是相同的操作符，可以用行子查询代替（本例为=）
SELECT
	*
FROM
	employees e
WHERE
	(employee_id,
	salary) = (
	SELECT
		MIN(employee_id),
		MAX(salary)
	FROM
		employees e
	);

# select后面 仅支持标量子查询
# eg 查询每个部门的员工个数放进department表中 (重点！！！）
SELECT
	d.*,
	(
	SELECT
		COUNT(*)
	FROM
		employees e
	WHERE
		e.department_id = d.department_id
	)
FROM
	departments d;

# FROM后面
/*
 * 将子查询结果充当一张表，要求必须起别名
 */
# eg 查询各部门的平均工资的工资等级
# step 1. 查询们各部门的平均工资
SELECT AVG(salary), department_id
FROM employees e 
GROUP BY department_id;
# step 2. 连接step1结果和job_grades表，筛选条件：平均工资在区间中
SELECT avg_dep_sal.*, jg.grade_level 
FROM
	(
	SELECT
		AVG(salary) avg_sal,
		department_id
	FROM
		employees e
	GROUP BY
		department_id
	) avg_dep_sal
INNER JOIN job_grades jg 
ON avg_dep_sal.avg_sal BETWEEN jg.lowest_sal AND jg.highest_sal;

# exists后面（相关子查询）
/*
 * 语法
 * exists(完整的查询语句)
 * 结果：0 or 1
 * 
 */

# eg 查询有员工的部门名
SELECT
	department_name
FROM
	departments d
WHERE
	EXISTS (
	SELECT
		*
	FROM
		employees e
	WHERE
		d.department_id = e.department_id
	);
# 用IN代替------------------------
SELECT
	department_name
FROM
	departments d
WHERE
	d.department_id IN(
	SELECT
		department_id
	FROM
		employees e
	);

# Exercise
# 1. 查询和Zlotkey相同部门的员工姓名和工资
# step 1. 查询Zlotkey的部门
SELECT department_id
FROM employees e 
WHERE last_name = 'Zlotkey';
# step 2. 查询部门号为step1结果的员工
SELECT
	last_name,
	salary
FROM
	employees e
WHERE
	department_id = (
	SELECT
		department_id
	FROM
		employees e
	WHERE
		last_name = 'Zlotkey'
	);
# 2. 查询工资比公司平均工资高的员工的员工号、姓名和工资
# step 1. 查询工资平均工资
SELECT AVG(salary)
FROM employees e;
# step 2. 查询工资比公司平均工资高的员工
SELECT employee_id, last_name, salary
FROM employees e
WHERE salary > (SELECT AVG(salary)
FROM employees e);
# 3. 查询各部门中工资比本部门平均工资高的员工的员工号、姓名和工资
# step 1. 查询各部门平均工资
SELECT department_id, AVG(salary)
FROM employees e 
GROUP BY department_id;
# step 2. 查询各部门中工资比本部门平均工资高的员工
SELECT
	employee_id,
	last_name,
	salary
FROM
	employees e
JOIN (
	SELECT
		department_id,
		AVG(salary) avg_sal
	FROM
		employees
	GROUP BY
		department_id) avg_sal_dep ON
	e.department_id = avg_sal_dep.department_id
WHERE
	e.salary > avg_sal_dep.avg_sal;
# 4. 查询和姓名中包含字母u的员工在相同部门工作的员工的员工号和姓名
# step 1. 查询姓名中包含字母u的员工在的部门
SELECT DISTINCT department_id 
FROM employees e
WHERE last_name LIKE '%u%';
# step 2. 查询step1部门中员工的员工号和姓名
SELECT employee_id, last_name 
FROM employees e 
WHERE department_id IN (
SELECT DISTINCT department_id 
FROM employees e
WHERE last_name LIKE '%u%');
# 5. 查询在部门location_id为1700的部门工作的员工的员工号
# step 1. 查询在部门location_id为1700的部门
SELECT department_id
FROM departments d
WHERE location_id = 1700;
# step 2. 查询在step1部门的员工的员工号
SELECT employee_id 
FROM employees e
WHERE department_id IN (
SELECT department_id
FROM departments d
WHERE location_id = 1700);
# 连接表---------------------------------
SELECT employee_id 
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id 
WHERE d.location_id = 1700;
# 6. 查询管理者是King的员工姓名和工资
SELECT last_name, salary 
FROM employees e
WHERE manager_id = 'King';
# 7. 查询工资最高的员工的姓名，要求first_name和last_name显示为一列	
SELECT CONCAT(first_name, ' ', last_name) name
FROM employees e 
WHERE salary = (
SELECT MAX(salary)
FROM employees e
);

# 进阶8：分页查询
/*
 * 应用场景：当要显示的数据，一页显示不全，需要分页提交sql请求
 * 
 * 语法：
 * SELECT 查询列表
 * FROM 表
 * 【JOIN type JOIN 表2
 * ON 连接条件
 * WHERE 筛选条件
 * GROUP BY 分组字段
 * HAVING 分组后的筛选
 * ORDER BY 排序的字段】
 * LIMIT offset, size
 * 
 * offset：要显示条目的起始索引（从0开始计数）当offset为0时，可以省略
 * size：要显示的条目数
 * 
 * 特点：
 * 1. limit语句放在查询语句的后面（执行也在最后）
 * 2. 公式：要显示的页数：page 每页的条目数：size
 * 			limit (page-1) * size, size
 */

# eg 1. 查询前5条员工信息
SELECT * FROM employees e 
LIMIT 0, 5;

# eg 2. 查询前11-25条员工信息
SELECT * FROM employees e 
LIMIT 10, 15;

# eg 3. 有奖金的员工信息，并且显示工资最高的前十名
SELECT *
FROM employees e 
WHERE commission_pct IS NOT NULL 
LIMIT 10;
		
# 进阶9：联合查询
/*
 * UNION 合并：将多条查询语句的结果合并成一个结果
 * 
 * 语法
 * 查询语句1
 * UNION
 * 查询语句2
 * UNION
 * ...;
 * 应用场景：
 * 要查询的结果来自多个表，而多个表之间没有连接关系，且要查询的信息一致
 * 
 * 特点：
 * 1. 要求多条查询语句的查询列数是一致的
 * 2. 要求多条查询语句的查询的每一列的类型和顺序最好是一致的
 * 3. 当多表中有重复项时，UNION默认去重，如果使用UNION ALL可以包含重复项
 * 
 */

