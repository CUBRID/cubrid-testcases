create table t1(a integer not null, b integer not null, c integer not null, d varchar(256));

insert into t1 values 
(4, 5, 6, '456'), 
(3, 4, 5, '345'), 
(2, 3, 4, '234'), 
(5, 8, 7, '587'), 
(5, 9, 9, '599'), 
(5, 1, 8, '518'), 
(5, 2, 7, '527'), 
(5, 3, 6, '536'), 
(5, 3, 5, '535'), 
(5, 3, 4, '534'), 
(5, 6, 3, '563'), 
(3, 1, 3, '313'), 
(3, 1, 31, '3131'), 
(3, 1, 32, '3132'), 
(3, 1, 33, '3133'), 
(3, 1, 34, '3134'), 
(3, 1, 35, '3135'), 
(3, 1, 36, '3136'), 
(3, 1, 37, '3137'), 
(9, 1, 38, '9138'), 
(3, 1, 39, '3139'), 
(3, 1, 40, '3140'), 
(8, 1, 41, '8141'), 
(0, 1, 42, '0142'), 
(1, 2, 3, '123');

create index iex on t1(a, b, c);

select t.a, t.b, t.c from (select * from t1 group by a, b, c) as t;
select t.a, t.b, t.c from (select * from t1 where a = 5 group by b, c) as t;
select t.a, t.b, t.c from (select * from t1 where b < 100 group by a) as t;
select t.a, t.b, t.c from (select * from t1 where b > 1 group by a) as t;
select t.a, t.b, t.c from (select * from t1 where b in (1,2,6) group by a) as t;
select t.a, t.b, t.c from (select * from t1 where b between 1 and 6 group by a) as t;
select t.a, t.b, t.c from (select * from t1 where b = 1 group by a limit 10) as t;

drop table t1;
