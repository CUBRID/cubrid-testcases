drop if exists t1,t2; 

create table t1(fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'));

insert into t1 values ('orange');
--core dumped 
select * from t1 where fruit in 'apple' ;

select * from t1 where fruit in ('apple');

select * from t1 where fruit in ('apple') and fruit in ('peach');

select * from t1 where fruit in ('null');

select * from t1 where fruit not in 'apple' ;

select * from t1 where fruit not in ('apple') and fruit not in ('peach');

create table t2(fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'));

insert into t2 values ('orange');

select * from t1,t2 where t1.fruit=t2.fruit and t1.fruit in 'apple' ;

select * from t1,t2 where t1.fruit=t2.fruit and t1.fruit in ('orange') ;

select * from t1,t2 where t1.fruit=t2.fruit and t1.fruit  not in ('orange') ;

select * from t1 left join t2 on t1.fruit=t2.fruit where t1.fruit in ('orange') ;

select * from t1 left join t2 on t1.fruit=t2.fruit where t1.fruit not in ('orange') ;

drop table t1,t2; 

create table t1(fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'),col int) partition by hash(col) partitions 2;

insert into t1 values ('orange',1);
--core dumped 
select * from t1 where fruit in 'apple' ;

select * from t1 where fruit in ('apple');

select * from t1 where fruit in ('apple') and fruit in ('peach');

select * from t1 where fruit in ('null');

select * from t1 where fruit not in 'apple' ;

select * from t1 where fruit not in ('apple') and fruit not in ('peach');

drop if exists t1; 