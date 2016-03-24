drop table if exists t,t2;

create table t(a integer, b varchar(255), c varchar(4096)) PARTITION BY RANGE(a) (

	 PARTITION p0 VALUES LESS THAN (13),

        PARTITION p1 VALUES LESS THAN (15),

        PARTITION p2 VALUES LESS THAN (20),

        PARTITION p3 VALUES LESS THAN MAXVALUE

      );


insert into t values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

insert into t values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;


create index i_t_a on t(a);
create index i_t_b on t(b);
create index i_t_c on t(c);
create index i_t_d on t(a,b,c);

create table t2(a bigint, b varchar(255), c varchar(4096)) PARTITION BY RANGE(a) (

	 PARTITION p0 VALUES LESS THAN (13),

        PARTITION p1 VALUES LESS THAN (15),

        PARTITION p2 VALUES LESS THAN (20),

        PARTITION p3 VALUES LESS THAN MAXVALUE

);

insert into t2 values(10, 'aab', 'the textbook'),(11, 'xab', 'book descr'),(12, 'xxy', 'book chapters'),(13, 'xa0', 'author names'),(14, 'xa1', 'xa1'),(15, 'xab', 'xab'),(16, 'aff', 'syntax descr'),(17, 'afg', 'operators list') ;

create index i_t2_a on t2(a);
create index i_t2_b on t2(b);
create index i_t2_c on t2(c);
create index i_t2_d on t2(a,b,c);

select /*+ recompile */ t.a,t.b,t2.c from t left join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a>11  group by t.a having t.a>15 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.a having t.a>15 limit 1,3;

select /*+ recompile */ t.a,t.b,t2.c from t right join t2 on t.a=t2.a  where t.a in (10,11,12,13)  group by t.a having t.a<15 and t.a>0 limit 1,3;

select /*+ recompile */distinct t.a,t.b,t2.c,count(*),avg(t.a) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.a having t.a<15 and t.a>0 limit 1,3 ;

select /*+ recompile */ t.a,t.b,t2.c,count(*),avg(t.a) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.a having t.a<15 and t.a>0 limit 1,3 ;

select /*+ recompile */ distinct t.a,t.b,t2.c,count(*) from t right outer join t2 on t.a=t2.a  where t.a in (10,11,12,13) group by t.a having t.a<15 and t.a>0 limit 3 ;

drop table if exists t,t2;

