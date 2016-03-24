set system parameters 'insert_execution_mode=0';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 3,'3';
select * from foo order by 1;

set system parameters 'insert_execution_mode=1';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 3,'3';
select * from foo order by 1;

set system parameters 'insert_execution_mode=3';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 3,'3';
select * from foo order by 1;


set system parameters 'insert_execution_mode=31';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 3,'3';
select * from foo order by 1;


set system parameters 'insert_execution_mode=0';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 prepare stmt1 from 'replace into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 prepare stmt1 from 'insert  into foo select ?,from_unixtime(?) from db_root limit 1';
execute stmt1 using 3,3;
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?)) on duplicate key update c1=?';
execute stmt1 using 3,3,33;
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 4,'4';
select * from foo order by 1;

set system parameters 'insert_execution_mode=0';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 prepare stmt1 from 'replace into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 prepare stmt1 from 'insert  into foo select ?,from_unixtime(?) from db_root limit 1';
execute stmt1 using 3,3;
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 4,'4';
select * from foo order by 1;

set system parameters 'insert_execution_mode=0';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 prepare stmt1 from 'insert  into foo select ?,from_unixtime(?) from db_root limit 1';
execute stmt1 using 3,3;
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 4,'4';
select * from foo order by 1;

set system parameters 'insert_execution_mode=1';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 prepare stmt1 from 'replace into foo values (?,from_unixtime(?))';
execute stmt1 using 2,2;
 prepare stmt1 from 'insert  into foo select ?,from_unixtime(?) from db_root limit 1';
execute stmt1 using 3,3;
prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using 4,'4';
select * from foo order by 1;


set system parameters 'insert_execution_mode=0';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using '2','2';
 prepare stmt1 from 'insert  into foo select ?,from_unixtime(?) from db_root limit 1';
execute stmt1 using '3','3';
 prepare stmt2 from 'insert into foo values (?,from_unixtime(cast(? as int)))';
execute stmt2 using '4','4';
select * from foo order by 1;

set system parameters 'insert_execution_mode=0';
drop table if exists foo;
create table foo (c1 int, c2 timestamp, primary key(c1));
 insert into foo values (1,from_unixtime(1));
 prepare stmt1 from 'insert into foo values (?,from_unixtime(?))';
execute stmt1 using '2','2';
 prepare stmt1 from 'insert  into foo select ?,from_unixtime(?) from db_root limit 1';
execute stmt1 using '3','3';
 prepare stmt2 from 'insert into foo values (?,from_unixtime(unix_timestamp(?)))';
execute stmt2 using '4','1970-01-02';
select * from foo order by 1;

drop table foo;
set system parameters 'insert_execution_mode=3';
