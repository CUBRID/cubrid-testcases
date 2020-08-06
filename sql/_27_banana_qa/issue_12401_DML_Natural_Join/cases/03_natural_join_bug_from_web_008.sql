--+ holdcas on;
set names utf8;
--03_natural_join_bug_from_web_008.sql


--correct
drop table b;
drop table a;
drop table c;
drop table if exists a,b,c;
CREATE TABLE `b` (
  `idb` int(10) NOT NULL auto_increment,
  `value` int(10) NOT NULL default '0',
  PRIMARY KEY  (`idb`)
) ;
INSERT INTO `b` (`idb`,`value`) VALUES (1,1),(2,2),(3,3);
CREATE TABLE `c` (
  `ida` int(10) NOT NULL default '0',
  `idb` int(10)  NOT NULL default '0'
) ;
INSERT INTO `c` (`ida`,`idb`) VALUES (1,1),(2,1),(3,1),(4,1),(5,2),(3,2),(1,2),(2,3),(4,3);
CREATE TABLE `a` (
  `ida` int(10)  NOT NULL auto_increment,
  `value` int(10) NOT NULL default '0',
  PRIMARY KEY  (`ida`)
) ;
INSERT INTO `a` (`ida`,`value`) VALUES (1,1),(2,2),(3,3),(4,4),(5,5);

select * from a join c on a.ida = c.ida join b on b.idb = c.idb where a.ida = 1 order by 1,2,3,4,5;

select * from a join c on a.ida = c.ida cross join b where a.ida = 1 order by 1,2,3,4,5;

select * from a natural join c  join b on b.idb = c.idb where a.ida = 1 order by 1,2,3,4,5;

select * from a natural join c  cross join b where a.ida = 1 order by 1,2,3,4,5;

select * from a natural left join c  join b on b.idb = c.idb where a.ida = 1 order by 1,2,3,4,5;

select * from a natural left join c  cross join b where a.ida = 1 order by 1,2,3,4,5;

select * from a natural right join c  join b on b.idb = c.idb where a.ida = 1 order by 1,2,3,4,5;

select * from a natural right join c  cross join b where a.ida = 1 order by 1,2,3,4,5;

drop table b;
drop table a;
drop table c;
drop table if exists a,b,c;
------------------------------------------------------

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b int); 
create table t2 ( a int, b int);

insert into t1 values(1,1);
insert into t2 values(1,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;
--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b int); 
create table t2 ( b int, a int);

insert into t1 values(1,2);
insert into t2 values(1,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b int); 
create table t2 ( b int, a int);

insert into t1 values(1,2);
insert into t2 values(2,1);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b char); 
create table t2 ( b int, a char);

insert into t1 values(1,'a');
insert into t2 values(1,'a');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 join (select * from t2 order by 1,2) t2 on t1.a=t2.b;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 join (select * from t2 order by 1,2) t2 on t1.b =t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 join (select * from t2 order by 1,2) t2 on t1.a=t2.b and t1.b =t2.a ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 join (select * from t2 order by 1,2) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b char); 
create table t2 ( a int, b char);

insert into t1 values(1,'a');
insert into t2 values(1,'a');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int); 
create table t2 ( b float);

insert into t1 values(1.9999999);
insert into t2 values(1.9999999);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int); 
create table t2 ( b float);

insert into t1 values(1.9999999);
insert into t2 values(2.9999999);
insert into t2 values(2.9999999);
insert into t2 values(2.9999999);
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int); 
create table t2 ( a float);

insert into t1 values(1.9999999);
insert into t2 values(1.9999999);
insert into t2 values(2.9999999);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a nchar(10)); 
create table t2 ( a nchar(20));

insert into t1 values(n'ÄãºÃ');
insert into t2 values(n'ÔÙ¼û');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a nchar(10)); 
create table t2 ( a nchar(20));

insert into t1 values(n'ÄãºÃ');
insert into t2 values(n'ÄãºÃ');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a nchar varying(10)); 
create table t2 ( a nchar varying(20));

insert into t1 values(n'ÄãºÃ');
insert into t2 values(n'ÄãºÃ');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a bit(2)); 
create table t2 ( a bit(20));

insert into t1 values(b'11');
insert into t2 values(b'111111');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a bit(2)); 
create table t2 ( a bit(20));

insert into t1 values(b'11');
insert into t2 values(b'111');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop table if exists t2;

create table t1 ( a bit(3)); 
create table t2 ( a bit(5));

insert into t1 values(b'111');
insert into t2 values(b'00111');

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

select * from (select * from t1 order by 1) t1;
select * from t2;

drop table if exists t1;
create table t1 ( a bit(3)); 
insert into t1 values(b'010');
select * from (select * from t1 order by 1) t1;

drop table if exists t1;
create table t1 ( a bit(4)); 
insert into t1 values(b'10');
select * from (select * from t1 order by 1) t1;

select cast(t1.a as char(30)) from (select * from t1 order by 1) t1;
drop table if exists t1;
create table t1 ( a bit(40)); 
insert into t1 values(b'0010');
select cast(t1.a as bit(50)) from (select * from t1 order by 1) t1;
select * from (select * from t1 order by 1) t1;

drop table if exists t1;
drop table if exists t2;
--
drop table if exists t1;
drop view t2;

create table t1 ( a int); 
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);

create view t2 as (select * from (select * from t1 order by 1) t1 order by 1);
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop view t2;

create table t1 ( a int); 
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);

create view t2 as (select * from (select * from t1 order by 1) t1 where t1.a = 0 order by 1);
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;

--
drop table if exists t1;
drop view t2;

create table t1 ( a int); 
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);

create view t2 as (select * from (select * from t1 order by 1) t1 where t1.a = 0 order by 1);
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 on t1.a=t2.a;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1) t2;


--------------------------------------------------------

drop table if exists t1;
drop view t2;

create table t1 ( a int); 
insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);

create view t2 as (select * from (select * from t1 order by 1) t1 where t1.a = 1 order by 1);

select /*+ RECOMPILE*/ u.a as s ,v.a as t from (select * from t1 order by 1) t1 u natural left join (select * from t2 order by 1) t2 v;
select /*+ RECOMPILE*/ u.a as s ,v.a as t from (select * from t1 order by 1) t1 u natural right join (select * from t2 order by 1) t2 v;



drop table if exists t1;
drop view t2;

set names iso88591;
--+ holdcas off;
