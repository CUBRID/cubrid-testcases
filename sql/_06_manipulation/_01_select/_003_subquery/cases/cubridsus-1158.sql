---To test a sub query include where, the result wether is correct.

create class test1 (id int);
create class test2 (id int);
create class test3 (id int);

insert into test2 values (1);
insert into test2 values (2);
insert into test2 values (3);
insert into test2 values (4);
insert into test2 values (5);
insert into test2 values (6);
insert into test2 values (7);

select count(*) as cnt,'test1' as class_name from test1
union all
select count(*) as cnt,'test2' as class_name from test2
union all
select count(*) as cnt,'test3' as class_name from test3;


select * 
from 
( 
select count(*) as cnt, 'test1' as class_name from test1
union all
select count(*) as cnt, 'test2' as class_name from test2
union all
select count(*) as cnt, 'test3' as class_name from test3
) as a 
where cnt = 0 and class_name not in ('test1');


select * 
from 
( select count(*) as cnt, 'test1' as class_name from test1
union all
select count(*) as cnt, 'test2' as class_name from test2
union all
select count(*) as cnt, 'test3' as class_name from test3
) as a 
where cnt = 0 and class_name <> 'test1';


select * 
from 
( 
select count(*) as cnt, 'test1' as class_name from test1
union all
select count(*) as cnt, 'test2' as class_name from test2
union all
select count(*) as cnt, 'test3' as class_name from test3
) as a 
where cnt < 1 and class_name not in ('test1');

drop class test1;
drop class test2;
drop class test3;
