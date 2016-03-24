
create table t1 (s1 varchar(255) collate 'utf8_en_ci', i1 int auto_increment);
insert into t1(s1) values ('aaA');
insert into t1(s1) values ('aAa');
insert into t1(s1) values ('aaA');
insert into t1(s1) values ('abAa')
insert into t1(s1) values ('AbaA');
insert into t1(s1) values ('AbAa');
insert into t1(s1) values ('aaA');
insert into t1(s1) values ('aaa');
insert into t1(s1) values ('AaA');
insert into t1(s1) values ('ABAa');

insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;
insert into t1(s1) select s1 from t1;


create index i_t1_s1_i1 on t1 (s1,i1);

update statistics on t1  with fullscan;

show index in t1;

select count(*) from t1;

select /*+ RECOMPILE index_ss */ s1,i1 from t1 where i1 < 10 order by 2;

select /*+ RECOMPILE index_ss */ s1,i1 from t1 where i1 = 2 order by 1,2;

select /*+ RECOMPILE index_ss */ s1,i1 from t1 where i1 < 10 order by 1,2;

select /*+ RECOMPILE index_ss */ s1,i1 from t1 where i1 < 10 order by 1 desc,2;


drop table t1;
