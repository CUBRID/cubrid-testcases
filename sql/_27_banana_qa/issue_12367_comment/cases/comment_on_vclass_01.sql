drop table if exists t;
create table t (a int comment 'col a comment', b int comment 'col b comment') comment 'tbl t comment';

-- create vclass with comment
create or replace view v_t (x int comment 'x private comment', y int comment 'y private comment') 
as select * from t comment = 'this is a comment for view v_t rather than table t';

select vclass_name, comment from db_vclass where vclass_name = 'v_t';

-- alter vclass with comment
alter view v_t comment = 'this is new comment for v_t';

select vclass_name, comment from db_vclass where vclass_name = 'v_t';

-- alter vclass reset query and alter comment
alter view v_t as select * from t where t.a in (1,2,3) comment = 'updated comment for v_t';

select vclass_name, comment from db_vclass where vclass_name = 'v_t';

-- alter vclass add query and alter comment
alter view v_t add query select * from t where t.a in (4,5) comment = '1,2,3,4,5 for v_t';

select vclass_name, comment from db_vclass where vclass_name = 'v_t';

drop view v_t;
drop table t;
