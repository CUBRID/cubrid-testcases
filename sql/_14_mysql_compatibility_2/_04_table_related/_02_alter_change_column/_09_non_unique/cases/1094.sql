---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : new constraints same as old constraints :  NON-UNIQUE INDEX
-- ordering : no order defined
-- name : same name or different
-- contains indexes on other columns 


-------------- compound index , precision increase, same name
create table t1 (i1 integer,s2 varchar(3), i3 integer);

insert into t1 values (10,'abc',1),(20,'xyz',2),(30,'jkl',3);
insert into t1 values (1,'1',10),(2,'2',20),(3,'3',30);

alter table t1 add index idx1 (i1,s2);

alter table t1 add index idx2 (i1,i3);

select * from t1 order by 1,2;
-- MYSQL : OK
alter table t1 change column s2 s2 varchar(200);



insert into t1 values (5,'abc+111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',5);
insert into t1 values (6,'bbc+111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',6);
insert into t1 values (7,'cbc+111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',7);


select * from t1 where s2<'abd' order by 1,2; 
select * from t1 where s2>'abc' order by 1,2;

drop table t1;




