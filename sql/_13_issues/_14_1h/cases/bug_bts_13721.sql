create table t1 (id int primary key, a varchar(100), b varchar(100) collate iso88591_en_ci, c varchar(100));
insert into t1 values (1, 'a', 'a', 'a');
insert into t1 values (2, 'a', 'A', 'a');
create index i_t1_abc on t1(a,b,c);

--@queryplan
select * from t1 where b='a' collate iso88591_en_cs and b='a' using index none;

--@queryplan
select /*+ recompile index_ss(t1) */ * from t1 where b='a' collate iso88591_en_cs and b='a';

drop table t1;

