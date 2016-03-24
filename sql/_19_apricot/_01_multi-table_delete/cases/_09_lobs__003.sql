--SERVER

create class t(i int);
insert into t values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
insert into t values (11), (12), (13), (14), (15), (16), (17), (18), (19), (20);
insert into t values (21), (22), (23), (24), (25), (26), (27), (28), (29), (30);

create class t1 under t (j int, str1 CLOB);
insert into t1 values (4, 4, '4'), (5,5, '5'), (6, 6, '6'), (7, 7, '7'), (8, 8, '8'), (10, 10, '10');

create class t11 under t1 (k int, str111 CLOB, n int, str112 CLOB);
insert into t11 values (4, 4, '4', 4, '41', 4, '42'), (5, 5, '5', 5, '51', 5, '52'), (6, 6, '6', 6, '61', 6, '62'), (10, 10, '10', 10, '101', 10, '102'), (11, 11, '11', 11, '111', 11, '112');

create class t12 under t1 (k int, str121 CLOB, n int, str122 CLOB);
insert into t12 values (4, 4, '4', 4, '41', 4, '42'), (5, 5, '5', 5, '51', 5, '52'), (6, 6, '6', 6, '61', 6, '62'), (10, 10, '10', 10, '101', 10, '102'), (11, 11, '11', 11, '111', 11, '112');

create class t13 under t1 (k int);
insert into t13 values (4, 4, '4', 4), (5, 5, '5', 5), (6, 6, '6', 6), (10, 10, '10', 10), (11, 11, '11', 11);

create class t2 under t (l int);
insert into t2 values (-4, -4), (-5,-5), (-6, -6), (-7, -7), (-8, -8), (-10, -10);

create class t21 under t2 (m int);
insert into t21 values (-4, -4, -4), (-5, -5, -5), (-6, -6, -6), (-10, -10, -10), (-11, -11, -11);

create class t22 under t2 (str22 CLOB);
insert into t22 values (-4, -4, '-4'), (-5, -5, '-5'), (-6, -6, '-6'), (-10, -10, '10'), (-11, -11, '-11');

create table x(i int, str CLOB);
insert into x values (1, '1'), (2, '2' ), (3, '3'), (4, '4'), (5, '5');;

create class y(i int);
insert into y values (1), (2), (3), (4), (5);

create class y1 under y (j int);
insert into y1 values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

delete t from all t where abs(i)=4;
select 't', i from t order by 2;
select 't1', i, j, clob_to_char(str1) as str1 from t1 order by 2;
select 't11', i, j, clob_to_char(str1) as str1, k, clob_to_char(str111) as astr111, n, clob_to_char(str112) as str112 from t11 order by 2;
select 't12', i, j, clob_to_char(str1) as str1, k, clob_to_char(str121) as astr121, n, clob_to_char(str122) as str122 from t12 order by 2;
select  't13', i, j, clob_to_char(str1) as str1, k from t13 order by 2;
select 't2', i, l from t2 order by 2;
select 't21', i, l, m from t21 order by 2;
select 't22', i, l, clob_to_char(str22) as str22 from t22 order by 2;

delete t1, t2 from all t1 inner join t2 on abs(t1.i)=abs(t2.i) where abs(t1.i)=6;
select 't', i from t order by 2;
select 't1', i, j, clob_to_char(str1) as str1 from t1 order by 2;
select 't11', i, j, clob_to_char(str1) as str1, k, clob_to_char(str111) as astr111, n, clob_to_char(str112) as str112 from t11 order by 2;
select 't12', i, j, clob_to_char(str1) as str1, k, clob_to_char(str121) as astr121, n, clob_to_char(str122) as str122 from t12 order by 2;
select  't13', i, j, clob_to_char(str1) as str1, k from t13 order by 2;
select 't2', i, l from t2 order by 2;
select 't21', i, l, m from t21 order by 2;
select 't22', i, l, clob_to_char(str22) as str22 from t22 order by 2;

delete t1, t2 from t1 inner join all t2 on abs(t1.i)=abs(t2.i) where abs(t1.i)=10;
select 't', i from t order by 2;
select 't1', i, j, clob_to_char(str1) as str1 from t1 order by 2;
select 't11', i, j, clob_to_char(str1) as str1, k, clob_to_char(str111) as astr111, n, clob_to_char(str112) as str112 from t11 order by 2;
select 't12', i, j, clob_to_char(str1) as str1, k, clob_to_char(str121) as astr121, n, clob_to_char(str122) as str122 from t12 order by 2;
select  't13', i, j, clob_to_char(str1) as str1, k from t13 order by 2;
select 't2', i, l from t2 order by 2;
select 't21', i, l, m from t21 order by 2;
select 't22', i, l, clob_to_char(str22) as str22 from t22 order by 2;

delete t1, t2 from all t1 inner join all t2 on abs(t1.i)=abs(t2.i) where abs(t1.i)=7;
select 't', i from t order by 2;
select 't1', i, j, clob_to_char(str1) as str1 from t1 order by 2;
select 't11', i, j, clob_to_char(str1) as str1, k, clob_to_char(str111) as astr111, n, clob_to_char(str112) as str112 from t11 order by 2;
select 't12', i, j, clob_to_char(str1) as str1, k, clob_to_char(str121) as astr121, n, clob_to_char(str122) as str122 from t12 order by 2;
select  't13', i, j, clob_to_char(str1) as str1, k from t13 order by 2;
select 't2', i, l from t2 order by 2;
select 't21', i, l, m from t21 order by 2;
select 't22', i, l, clob_to_char(str22) as str22 from t22 order by 2;

delete t, x, y from all t inner join all x on abs(t.i)=abs(x.i) inner join all y on abs(x.i)=abs(y.i) where abs(t.i)=5;
select 't', i from t order by 2;
select 't1', i, j, clob_to_char(str1) as str1 from t1 order by 2;
select 't11', i, j, clob_to_char(str1) as str1, k, clob_to_char(str111) as astr111, n, clob_to_char(str112) as str112 from t11 order by 2;
select 't12', i, j, clob_to_char(str1) as str1, k, clob_to_char(str121) as astr121, n, clob_to_char(str122) as str122 from t12 order by 2;
select  't13', i, j, clob_to_char(str1) as str1, k from t13 order by 2;
select 't2', i, l from t2 order by 2;
select 't21', i, l, m from t21 order by 2;
select 't22', i, l, clob_to_char(str22) as str22 from t22 order by 2;
select 'x', i, clob_to_char(str) as str from all x order by 1,2;
select 'y', y.* from all y order by 1,2;
select 'y1', y1.* from all y1 order by 1,2;

drop table t11;
drop table t12;
drop table t13;
drop table t1;
drop table t21;
drop table t22;
drop table t2;
drop table t;
drop table x;
drop table y1;
drop table y;
