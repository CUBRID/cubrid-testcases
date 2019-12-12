
create table t_i (s1 string collate utf8_ja_exp);


-- should fail
create index i_s1_3 on t_i(s1(3));

drop table t_i;
