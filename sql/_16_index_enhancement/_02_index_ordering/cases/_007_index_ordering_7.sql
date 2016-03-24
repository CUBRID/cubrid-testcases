drop table if exists t2;
create table t2(a integer not null, b integer, c integer, d varchar(256));

insert into t2 values 
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

create index i_t2_a_b_c on t2(a, b, c);
create index i_t2_a on t2(a);
create index i_t2_b on t2(b);

select t.b from (select * from t2 where a < b order by b) as t;
select t.b from (select * from t2 where a < b and b < c order by b) as t;
select t.b from (select * from t2 where b - 1 > 0 order by b) as t;
select t.b from (select * from t2 where b * b > 4 order by b) as t;

drop table t2;
