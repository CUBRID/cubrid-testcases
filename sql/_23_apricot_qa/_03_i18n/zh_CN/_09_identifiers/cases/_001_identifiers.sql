--+ holdcas on;
set names utf8;
-- table name
create table 测试表(s1 char(200));

-- column
alter table 测试表 add column i_列1 int;

-- trigger
create trigger 触发器 before update on 测试表 execute update 测试表 set i_列1 = 0;

-- constraint
alter table 测试表 add constraint i_列1_i_u unique index (i_列1);

desc 测试表;
show index in 测试表;

drop trigger 触发器;

alter table 测试表 drop constraint i_列1_i_u;

alter table 测试表 drop column i_列1;

drop table 测试表;



create table 表 (列 int);

alter table 表 add column 列1 int;

create trigger 触发器 before update on 表 execute update 表 set 列 = 0;

alter table 表 add constraint 约束1 unique index (列);
alter table 表 add constraint 约束2 unique index (列1);

desc 表;
show index in 表;

drop trigger 触发器;

alter table 表 drop constraint 约束1;
alter table 表 drop constraint 约束2;

alter table 表 drop column 列;
alter table 表 drop column 列1;
drop table 表;
set names iso88591;
commit;
--+ holdcas off;

