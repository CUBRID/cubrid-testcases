set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
drop table if exists t_d_1;
create table t_d_1(i int);
insert into t_d_1 select rownum from db_root connect by level<=100;

drop table if exists t_update;
create table t_update(i bigint);
insert into t_update select rownum from db_root connect by level<=100;

drop table if exists t_replace;
create table t_replace(i bigint);
insert into t_replace select rownum from db_root connect by level<=100;


drop table if exists tbl;

create table tbl (id int) 
partition by range (id + 1) 
(partition p0 values less than (2), 
partition p1 values less than MAXVALUE
);
insert into tbl values (-1);
insert into tbl values (3);
insert into tbl values (99) into :xx;

WITH cte1 AS
(
select :xx.id from db_root
)
update t_update set i=(select count(*) from cte1);

WITH cte2 AS
(
select :xx.id from db_root
)
delete from t_d_1 where i=(select count(*) from cte2);


replace into t_replace WITH cte3 AS
(
select :xx.id from db_root
)
select count(*) from cte3;

replace into t_replace select count(*) from (select :xx.id from db_root) cte4;

insert into t_replace WITH cte5 AS
(
select :xx.id from db_root
)
select count(*) from cte5;

insert into t_replace select count(*) from (select :xx.id from db_root) cte6;

WITH cte7 AS
(
select :xx.id from db_root
)
select * from cte7;


insert into t_replace WITH cte8 AS
(
select :xx.id from db_root
)
select * from cte8;


drop table if exists t;
create table t(i int);

set @a = 1;

create table cte9 as WITH cte9 AS
(
select @a
)
select * from cte9;

insert into t 
WITH cte10 AS
(
select @a
)
select * from cte10;
select * from t order by 1;

replace into t 
WITH cte11 AS
(
select @a
)
select * from cte11;
select * from t order by 1;

WITH cte12 AS
(
select @a
)
delete from t where i in (select * from cte12) limit 1;
select * from t order by 1;

WITH cte13 AS
(
select @a
)
update t set i=-1 where i in (select * from cte13);
select * from t order by 1;

drop table if exists t,tbl,t1,t_replace,t_update,t_d_1;
drop variable @a;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
