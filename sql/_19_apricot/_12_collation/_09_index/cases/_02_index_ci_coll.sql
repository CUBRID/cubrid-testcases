
create table t_i (s1 string collate 'utf8_en_ci');
insert into t_i values ('aa');
insert into t_i values ('Ab');
insert into t_i values ('aaa');
insert into t_i values ('Aba');
insert into t_i values ('aaA');
insert into t_i values ('AbA');
insert into t_i values ('aac');
insert into t_i values ('Abc');
insert into t_i values ('aaC');
insert into t_i values ('AbC');
insert into t_i values ('aa1');
insert into t_i values ('Ab1');
insert into t_i values ('aaa1');
insert into t_i values ('Aba1');
insert into t_i values ('aaA1');
insert into t_i values ('AbA1');
insert into t_i values ('aac1');
insert into t_i values ('Abc1');
insert into t_i values ('aaC1');
insert into t_i values ('AbC1');

create index i_t_i_s1 on t_i (s1);

select * from (select /*+ RECOMPILE */ s1 from t_i order by 1) order by s1 collate utf8_en_cs;

select * from (select /*+ RECOMPILE */ s1 from t_i where s1 > 'aa' order by 1) order by s1 collate utf8_en_cs;

-- error : incompatible collations
select * from (select /*+ RECOMPILE */ s1 from t_i where s1 > cast ('aa' as string collate 'utf8_en_cs') order by 1) order by s1 collate utf8_en_cs;

select * from (select /*+ RECOMPILE */ s1 from t_i where s1 > 'a' order by 1) order by s1 collate utf8_en_cs;

select * from (select /*+ RECOMPILE */ s1 from t_i where cast (s1 as string collate 'utf8_en_cs') > 'a' order by 1) order by s1 collate utf8_en_cs;

select /*+ RECOMPILE */ s1 from t_i where cast (s1 as string collate 'utf8_en_cs') > 'a' using index none order by s1 collate utf8_en_cs;

select /*+ RECOMPILE */ cast (s1 as string collate 'utf8_en_cs') from t_i order by 1;

select /*+ RECOMPILE */ cast (s1 as string collate 'utf8_en_cs') from t_i where cast (s1 as string collate 'utf8_en_cs') > 'a' order by 1;

drop table t_i;
