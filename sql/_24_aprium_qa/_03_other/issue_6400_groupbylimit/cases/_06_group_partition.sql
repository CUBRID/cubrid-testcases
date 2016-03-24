drop table if exists t,t2;

create table t(a integer, b varchar(255), c varchar(4096)) PARTITION BY LIST (a) (

PARTITION event1 VALUES IN (10,11, 12 ),

PARTITION event2 VALUES IN (13, 14,15),

PARTITION event3 VALUES IN (16, 17)
);

insert into t values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

insert into t values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

create index i_t_a on t(a);
create index i_t_b on t(b);
create index i_t_c on t(c);
create index i_t_d on t(a,b,c);

create table t2(a bigint, b varchar(255), c varchar(4096)); 

insert into t2 values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

insert into t2 values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

create index i_t2_a on t2(a);
create index i_t2_b on t2(b);
create index i_t2_c on t2(c);
create index i_t2_d on t2(a,b,c);

select /*+ recompile */ t.a,t.b,t2.c from t left join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.c having t.a>15 limit 1,3;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.b having t.a<15 and t.a>0 limit 1,3;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 1000000,1000000;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 10000000000000,100000000000000;

select /*+ recompile */ distinct t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 10000000000000,100000000000000;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t left outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t inner join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0  order by 1 limit 3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t inner join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 limit 1000 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*) from t inner join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.c having t.a<15 and t.a>0 order by 1 limit 1000 ;

drop table if exists t,t2;
