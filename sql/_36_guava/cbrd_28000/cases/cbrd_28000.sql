/**
 *  This test case verifies CBRD-28000 : Prune a constant that no range or list partition holds to no partition
 *  An equality or IN term on the partition key whose value no partition holds reads no partition.
 */

drop table if exists t_range;
drop table if exists t_list;
drop table if exists t_func;
drop table if exists t_pk;
drop table if exists t_fk;

create table t_range (id int, k int, v int, index i_range_k (k))
    partition by range (k)
    (
        partition p0 values less than (10),
        partition p1 values less than (20),
        partition p2 values less than (30)
    );
insert into t_range select rownum, mod (rownum, 30), rownum from db_class a, db_class b limit 300;
insert into t_range values (1001, null, 1);

create table t_list (id int, k int, v int, index i_list_k (k))
    partition by list (k)
    (
        partition q0 values in (1, 2),
        partition q1 values in (3, 4),
        partition q2 values in (5, null)
    );
insert into t_list select rownum, mod (rownum, 5) + 1, rownum from db_class a, db_class b limit 100;
insert into t_list values (1001, null, 1);

create table t_func (id int, d date, v int)
    partition by range (year (d))
    (
        partition f0 values less than (2000),
        partition f1 values less than (2010),
        partition f2 values less than (2020)
    );
insert into t_func select rownum, adddate ('1995-01-01', rownum * 30), rownum from db_class a, db_class b limit 200;
insert into t_func values (1001, '2005-03-01', 1);

update statistics on t_range, t_list, t_func;

set trace on;

evaluate '1. range, = out of range: no partition';
select /*+ recompile */ count (*), sum (v) from t_range ignore index (i_range_k) where k = 999;
show trace;

evaluate '2. range, index scan, = out of range: no partition';
select /*+ recompile */ * from t_range use index (i_range_k) where k = 999;
show trace;

evaluate '3. range, IN with every value out of range: no partition';
select /*+ recompile */ count (*) from t_range ignore index (i_range_k) where k in (999, 1000);
show trace;

evaluate '4. range, IN with one value in range: its partition';
select /*+ recompile */ count (*), sum (v) from t_range ignore index (i_range_k) where k in (999, 5);
show trace;
select /*+ recompile */ count (*), sum (v) from t_range ignore index (i_range_k) where k in (5, 999);
show trace;

evaluate '5. range, OR of an out of range value: the other partition';
select /*+ recompile */ count (*), sum (v) from t_range ignore index (i_range_k) where k = 999 or k = 15;
show trace;

evaluate '6. range, OR with a term on another column: every partition';
select /*+ recompile */ count (*), sum (v) from t_range ignore index (i_range_k) where k = 999 or v = 3;
show trace;

evaluate '7. range, <=> NULL: the partition of NULL';
select /*+ recompile */ count (*) from t_range ignore index (i_range_k) where k <=> null;
show trace;

evaluate '8. list, = out of the lists: no partition';
select /*+ recompile */ count (*) from t_list ignore index (i_list_k) where k = 7;
show trace;

evaluate '9. list, IN out of the lists: no partition';
select /*+ recompile */ count (*) from t_list ignore index (i_list_k) where k in (7, 8);
show trace;

evaluate '10. list, <=> NULL: the partition holding NULL';
select /*+ recompile */ count (*) from t_list ignore index (i_list_k) where k <=> null;
show trace;

evaluate '11. function, = out of range: no partition';
select /*+ recompile */ count (*) from t_func where d = '2099-01-01';
show trace;

evaluate '12. function, IN with one value in range: its partition';
select /*+ recompile */ count (*) from t_func where d in ('2099-01-01', '2005-03-01');
show trace;

set trace off;

evaluate '13. aggregates over no partition';
select /*+ recompile */ count (*) from t_range where k = 999;
select /*+ recompile */ min (k), max (k) from t_range where k = 999;
select /*+ recompile */ min (k), max (k) from t_range where k in (5, 999);

evaluate '14. DML of an out of range value';
update t_range set v = v + 1 where k = 999;
delete from t_range where k = 999;
update t_range set v = v + 1 where k in (5, 999);
select count (*), sum (v) from t_range;
update t_range set k = 999 where id = 1;
insert into t_range values (2001, 999, 1);
select * from t_range where id = 1 order by k;

create table t_pk (k int primary key, v int)
    partition by range (k)
    (
        partition p0 values less than (10),
        partition p1 values less than (20)
    );
insert into t_pk values (1, 1), (11, 11);
insert into t_pk values (999, 1) on duplicate key update v = v + 100;
insert into t_pk values (1, 1) on duplicate key update v = v + 100;
merge into t_pk t using (select 999 k, 7 v from db_root) s on (t.k = s.k)
    when matched then update set t.v = s.v when not matched then insert values (s.k, s.v);
merge into t_pk t using (select 11 k, 7 v from db_root) s on (t.k = s.k)
    when matched then update set t.v = s.v when not matched then insert values (s.k, s.v);
select * from t_pk order by 1;

create table t_fk (id int, fk int);
insert into t_fk values (1, 999), (2, 1);
alter table t_fk add constraint fk_t_fk foreign key (fk) references t_pk (k);
delete from t_fk where fk = 999;
alter table t_fk add constraint fk_t_fk foreign key (fk) references t_pk (k);
insert into t_fk values (3, 999);
insert into t_fk values (4, 11);
select * from t_fk order by 1;

drop table t_fk;
drop table t_pk;
drop table t_func;
drop table t_list;
drop table t_range;
