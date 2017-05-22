-- bug CBRD-21303

-- They are not allowed when it includes subquery.
drop table if exists t1;

create table t1 (a int default (select 1+1) + 1);

create table t1 (a int default (select 1+1)); 

create table t1 (a int default (select 1)); 

create table t1 (a char(2) default (select 'a') || 'a');

drop table if exists t1;


drop table if exists tx;

drop table if exists tx2;

create table tx(a int); 

insert into tx values(1),(2),(3),(4),(5);

-- raise an error
create table tx2 (a int default (select a from tx));

create table tx2 (a int default (select a from tx limit 1));

-- raise an error
create table tx2 (a int default (select count(*) from tx)); 

-- raise an error
create table tx2 (a int default (select count(a) from tx)); 

create table tx2 (a int default (select 1+1 from tx));

create table tx2 (a int default (select length('abc') from tx));

create table tx2 (a int default (select length('abc')));

drop table if exists tx;

drop table if exists tx2;