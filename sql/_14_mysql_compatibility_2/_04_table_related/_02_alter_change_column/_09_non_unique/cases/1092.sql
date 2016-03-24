---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : new constraints same as old constraints :  NON-UNIQUE INDEX
-- ordering : no order defined
-- name : same name or different


-------------- compound index , precision increase, same name
create table t1 (i1 integer,s2 varchar(3));

insert into t1 values (10,'abc'),(20,'xyz'),(30,'jkl');
insert into t1 values (1,'1'),(2,'2'),(3,'3');

alter table t1 add index idx (i1,s2);

select * from t1 order by 1,2;
-- MYSQL : OK
alter table t1 change column s2 s2 varchar(200);



insert into t1 values (5,'abc+111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');
insert into t1 values (6,'bbc+111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');
insert into t1 values (7,'cbc+111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111');


select * from t1 where s2<'abd' order by 1,2; 
select * from t1 where s2>'abc' order by 1,2;

drop table t1;




