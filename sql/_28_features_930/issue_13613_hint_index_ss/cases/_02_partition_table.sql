create table t1 (id int primary key, a int, b int, c int) 
PARTITION BY RANGE ( id ) (
    PARTITION p1 VALUES LESS THAN ( 100),
    PARTITION p2 VALUES LESS THAN ( 100000 )
);
create index i_t1_abc on t1(a,b,c);

select /*+ recompile index_ss(t1) */ * from t1 partition(p1) where b<10;
select /*+ recompile index_ss(s1) ordered */ * from t1 partition(p1) s1, t1 partition(p2) s2 where s1.b<10 and s1.b=s2.b;
select /*+ recompile index_ss(s2) ordered */ * from t1 partition(p1) s1, t1 partition(p2) s2 where s1.b<10 and s2.b<10 and s1.b=s2.b;

drop table t1;

