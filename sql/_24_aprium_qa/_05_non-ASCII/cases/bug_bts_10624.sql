
--+ holdcas on;
drop if exists À;
drop if exists Ö;
create table À(À int);
SHOW full COLUMNS FROM À;
rename table À as Ö;
SHOW full COLUMNS FROM Ö;
rename table Ö to À;
SHOW full COLUMNS FROM À;
drop table À;
create table À(À int);
SHOW full COLUMNS FROM À;
alter table À rename À as Ö;
SHOW full COLUMNS FROM À;
alter table À rename Ö to À ;
SHOW full COLUMNS FROM À;
alter table À CHANGE  À Ö char(10) ;
SHOW full COLUMNS FROM À;
drop table À;
create table À(À string);
insert into À values('À');
select * from À;
update À set À='Ö';
select * from À;
delete from À;
insert into À values('À');
select * from À;
truncate À;
drop table À;

create table 计算机(s1 char(200));
alter table 计算机 add column i_列1 int;
create trigger 机器人 before update on 计算机 execute update 计算机 set i_列1 = 0;
alter table 计算机 add constraint i_列1_i_u unique index (i_列1);
desc 计算机;
show index in 计算机;
drop trigger 机器人;
alter table 计算机 drop constraint i_列1_i_u;
alter table 计算机 drop column i_列1;
drop table 计算机;
create table 我 (列 int);
alter table 我 add column 列1 int;
create trigger 机器人 before update on 我 execute update 我 set 列 = 0;
alter table 我 add constraint 约束1 unique index (列);
alter table 我 add constraint 约束2 unique index (列1);
desc 我;
show index in 我;
drop trigger 机器人;
alter table 我 drop constraint 约束1;
alter table 我 drop constraint 约束2;
alter table 我 drop column 列;
alter table 我 drop column 列1;
drop table 我;

create table t1 (i integer);
create user 用户1;
create user 用户组 members 用户1;
grant select on t1 to 用户1;
grant delete on t1 to 用户组;
show grants for 用户1;
show grants for 用户组;
drop user 用户组;
drop user 用户1;
drop table t1;

create table 计算机( i_列1 int) partition by range (i_列1) (partition p0 VALUES LESS THAN (2),partition p1 VALUES LESS THAN (20));
insert into 计算机 values (1), (3), (5);
select * from 计算机__P__P0;
select * from 计算机__p__p1;
desc 计算机;
drop table 计算机;

set @人工智能 = 2;

select @人工智能 + 2;

drop variable @人工智能;

create table "计算机" ( `i_列1` int , [a_列2] int);

desc 计算机;

drop table `计算机`;

CREATE TABLE test_cn ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_gen);
  
insert into test_cn values (1,'鸢尾花');
insert into test_cn values (2,'你们'); 
insert into test_cn values (3,'你们');
insert into test_cn values (103,'你们');
insert into test_cn values (203,'你们');
insert into test_cn values (303,'你们.我们');
insert into test_cn values (403,'你们 他们');
insert into test_cn values (4,'他们');
insert into test_cn values (104,'迎春');
insert into test_cn values (5,'我们'); 
insert into test_cn values (105,'秋海棠');
insert into test_cn values (205,'碧桃'); 
insert into test_cn values (6,'水仙');
insert into test_cn values (106,'%水仙'); 
insert into test_cn values (7,'梨花');
insert into test_cn values (107,'_梨花');
insert into test_cn values (8,'桔梗');
insert into test_cn values (9,'科学');
insert into test_cn values (109,'?科学');
insert into test_cn values (10,'夹竹桃');
insert into test_cn values (110,'*夹竹桃');

select id, name, CHAR_LENGTH (name), lower (name), CHAR_LENGTH (lower(name)), upper(name), CHAR_LENGTH (upper(name))  from test_cn order by 1;

select id, name, OCTET_LENGTH (name), lower (name), OCTET_LENGTH (lower(name)), upper(name), OCTET_LENGTH (upper(name))  from test_cn order by 1;

drop table test_cn;
--+ holdcas on;
set system parameters 'intl_date_lang = zh_CN';
-- date
select 'to_date( , DAY )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-01 星期日', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-02 星期一', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-03 星期二', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-04 星期三', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-05 星期四', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-06 星期五', 'yyyy-MM-DD DAY');
--test
SELECT TO_DATE('2011-05-07 星期六', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-01 星期日', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-02 星期一', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-03 星期二', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-04 星期三', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-05 星期四', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-06 星期五', 'yyyy-MM-DD day');
--test
SELECT TO_DATE('2011-05-07 星期六', 'yyyy-MM-DD day');

select 'to_date( , DY )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-01 周日', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-02 周一', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-03 周二', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-04 周三', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-05 周四', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-06 周五', 'yyyy-MM-DD DY');
--test
SELECT TO_DATE('2011-05-07 周六', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
--test
SELECT TO_DATE('2011年5月1日 星期日', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-01 周日', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-02 周一', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-03 周二', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-04 周三', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-05 周四', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-06 周五', 'yyyy-MM-DD dy');
--test
SELECT TO_DATE('2011-05-07 周六', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 二月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 三月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 四月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 五月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 六月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 七月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 八月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 九月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 十月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 十一月', 'yyyy-dd MONTH');
--test
SELECT TO_DATE('2010-01 十二月', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 一月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 二月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 三月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 四月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 五月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 六月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 七月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 八月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 九月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 十月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 十一月', 'yyyy-dd month');
--test
SELECT TO_DATE('2010-01 十二月', 'yyyy-dd month');


select 'to_date( ,  MON)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 1月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 2月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 3月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 4月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 5月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 6月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 7月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 8月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 9月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 10月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 11月', 'yyyy-dd MON');
--test
SELECT TO_DATE('2010-01 12月', 'yyyy-dd MON');

select 'to_date( ,  mon)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 1月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 2月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 3月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 4月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 5月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 6月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 7月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 8月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 9月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 10月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 11月', 'yyyy-dd mon');
--test
SELECT TO_DATE('2010-01 12月', 'yyyy-dd mon');

select 'to_date( ,  Month)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 一月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 二月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 三月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 四月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 五月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 六月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 七月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 八月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 九月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 十月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 十一月', 'yyyy-dd Month');
--test
SELECT TO_DATE('2010-01 十二月', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
--test
SELECT TO_DATE('2010年1月1日', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 1月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 2月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 3月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 4月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 5月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 6月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 7月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 8月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 9月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 10月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 11月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 12月', 'yyyy-dd Mon');

--test
SELECT TO_DATE('2010-01 测试 十一月', 'yyyy-dd "测试" Mon');
--test
SELECT TO_DATE('2010-01 测试 十一月', 'yyyy-dd "测试" Mon');
set system parameters 'intl_date_lang = en_US';
commit;
--+ holdcas off;

