
create table t1 (s1 string collate utf8_en_ci);

insert into t1 values ('Ab'), ('aa');


alter table t1 change s1 s1 string collate utf8_en_cs;

-- error cannot change codeset
alter table t1 change s1 s1 string collate iso88591_en_cs;


drop table t1;


create table t1 (s1 string collate iso88591_en_cs);

insert into t1 values ('Ab'), ('aa');
-- error cannot change codeset
alter table t1 change s1 s1 string collate utf8_en_cs;

drop table t1;


-- table with index
create table t1 (s1 string collate utf8_en_ci);

insert into t1 values ('aa');
insert into t1 values ('Ab');
insert into t1 values ('aaa');
insert into t1 values ('Aba');
insert into t1 values ('aaA');
insert into t1 values ('AbA');
insert into t1 values ('aac');
insert into t1 values ('Abc');
insert into t1 values ('aaC');
insert into t1 values ('AbC');
insert into t1 values ('aa1');
insert into t1 values ('Ab1');
insert into t1 values ('aaa1');
insert into t1 values ('Aba1');
insert into t1 values ('aaA1');
insert into t1 values ('AbA1');
insert into t1 values ('aac1');
insert into t1 values ('Abc1');
insert into t1 values ('aaC1');
insert into t1 values ('AbC1');

create index i_t1_s1 on t1(s1);

select upper(s1) from t1 where s1 > 'a' order by 1;

alter table t1 change s1 s1 string collate utf8_en_cs;

select upper(s1) from t1 where s1 > 'a' order by 1;

drop table t1;
