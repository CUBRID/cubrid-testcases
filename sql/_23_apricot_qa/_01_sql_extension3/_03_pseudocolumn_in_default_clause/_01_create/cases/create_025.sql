--create table of one column with default value of SYSDATE and SYSDATETIME using 'create table as select' syntax


--TEST: sysdate
create table c25(col date default SYSDATE);
insert into c25 values default;
insert into c25 values default;
insert into c25 values default;
create table a24 as select * from c25;
desc a24;
select if(col = SYSDATE, 'ok', 'nok') from a24 order by 1;
insert into a24 values(default);
select if(col = SYSDATE, 'ok', 'nok') from a24 order by 1 desc limit 1;
drop table if exists c25;
drop table if exists a24;


--TEST: sysdatetime type
create table c25(col datetime default SYSDATETIME);
insert into c25 values default;
insert into c25 values default;
insert into c25 values default;
create table a24 as select * from c25;
desc a24;
select if((SYSDATETIME - col) < 3000, 'ok', 'nok') from a24 order by 1;
insert into a24 values(default);
select if((SYSDATETIME - col) < 3000, 'ok', 'nok') from a24 order by 1 desc limit 1;
drop table if exists c25;
drop table if exists a24;


