--TEST: [Multi-table Update] The update result is incorrect when joining a table with itself.

--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(a int);
insert into t1 values(1), (2), (3), (4);


update statistics on class t1; 
update t1 m1, t1 m2 set m1.a=100, m2.a=200 where m1.a=m2.a;
select * from t1;
--The result is undefinable for this type of updates
--update statistics on class t1; 
--update t1 m1, t1 m2 set m1.a=100, m2.a=200 where m1.a=m2.a;
-select * from t1;
--update statistics on class t1; 
--update t1 m1, t1 m2 set m1.a=100, m2.a=200 where m1.a=m2.a;
--select * from t1;

drop table t1;


--2 columns
create table t1(a int, b varchar);
insert into t1 values(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd');

update t1 m1, t1 m2 set m1.a=100, m2.a=200, m2.b='AA', m1.b='BB' where m1.a=m2.a;
select * from t1;
--The result is undefinable for this type of updates
--update t1 m1, t1 m2 set m1.a=100, m2.a=200, m1.b='BB', m2.b='AA' where m1.a=m2.a;
--select * from t1;
--update t1 m2, t1 m1 set m2.b='AA', m1.b='BB', m1.a=100, m2.a=200 where m1.a=m2.a;
--select * from t1;

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

