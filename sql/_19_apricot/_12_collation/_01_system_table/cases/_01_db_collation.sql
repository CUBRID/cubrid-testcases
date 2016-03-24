-- system table

desc db_root;

desc _db_collation;

-- contents of db_root and _db_collation depend on current loaded collations 

-- built-in collations
select * from _db_collation where built_in=1 order by coll_id;

-- basic case sensitive-insenstive order check
create table t0 (s1 string collate iso88591_bin);

create table t1 (s1 string collate utf8_bin);

create table t2 (s1 string collate iso88591_en_cs);

create table t3 (s1 string collate iso88591_en_ci);

create table t4 (s1 string collate utf8_en_cs);

create table t5 (s1 string collate utf8_en_ci);

create table t6 (s1 string collate utf8_tr_cs);

create table t7 (s1 string collate utf8_tr_cs);

create table t8 (s1 string collate utf8_ko_cs);


insert into t0 values ('Ab'),( 'aa');
insert into t1 values ('Ab'),( 'aa');
insert into t2 values ('Ab'),( 'aa');
insert into t3 values ('Ab'),( 'aa');
insert into t4 values ('Ab'),( 'aa');
insert into t5 values ('Ab'),( 'aa');
insert into t6 values ('Ab'),( 'aa');
insert into t7 values ('Ab'),( 'aa');
insert into t8 values ('Ab'),( 'aa');


select * from t0 order by 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t4 order by 1;
select * from t5 order by 1;
select * from t6 order by 1;
select * from t7 order by 1;
select * from t8 order by 1;


drop table t0;
drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t5;
drop table t6;
drop table t7;
drop table t8;
