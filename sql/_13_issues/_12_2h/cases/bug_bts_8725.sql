--+ holdcas on;
set names utf8;
create table t1_8725_001(a string collate utf8_bin);
create table t2_8725_001(a string collate utf8_ko_cs);
--test point
create TRIGGER tri_8725_001 BEFORE UPDATE ON t1_8725_001(a) 
if new.a in (select a from t2_8725_001)
execute reject;

insert into t1_8725_001 values ('a1');
insert into t2_8725_001 values ('a2');

update t1_8725_001 set a = 'a2';
update t1_8725_001 set a = 'a3';

drop trigger tri_8725_001;
drop t1_8725_001;
drop t2_8725_001;
create table t1_8725_002(a string collate utf8_bin);
create table t2_8725_002(a string collate utf8_ko_cs);
--test point
create TRIGGER tri_8725_002 BEFORE UPDATE ON t1_8725_002(a) 
if new.a in ((select a from t2_8725_002) union all (select a from t2_8725_002) intersect (select a from t2_8725_002) union all (select a from t2_8725_002))
execute reject;

insert into t1_8725_002 values ('a1');
insert into t2_8725_002 values ('a2');

update t1_8725_002 set a = 'a2';
update t1_8725_002 set a = 'a3';

drop trigger tri_8725_002;
drop t1_8725_002;
drop t2_8725_002;
create table t1_8725_003(a string collate utf8_bin);
create table t2_8725_003(a string collate utf8_ko_cs);
--test point
create TRIGGER tri_8725_003 BEFORE UPDATE ON t1_8725_003(a) 
if new.a in ((select a from t2_8725_003) union all (select a from t2_8725_003) union all (select a from t2_8725_003))
execute reject;

insert into t1_8725_003 values ('a1');
insert into t2_8725_003 values ('a2');

update t1_8725_003 set a = 'a2';
update t1_8725_003 set a = 'a3';

drop trigger tri_8725_003;
drop t1_8725_003;
drop t2_8725_003;
create table t1_8725_002_in(a string collate utf8_bin);
create table t2_8725_002_in(a string collate utf8_ko_cs);

insert into t1_8725_002_in values ('a1');
insert into t1_8725_002_in values ('a2');

insert into t2_8725_002_in values ('a2');
insert into t2_8725_002_in values ('a3');

select * from t1_8725_002_in where 'a2' in (select a from t2_8725_002_in);
select * from t2_8725_002_in where 'a2' in (select a from t1_8725_002_in);

select * from t1_8725_002_in where a in ((select 'a1' from db_root) union all (select a from t2_8725_002_in) union all (select 'bb' from db_root));

select * from t1_8725_002_in where a not in ((select 'a2' from db_root) union all (select a from t2_8725_002_in) union all (select 'bb' from db_root));

drop t1_8725_002_in;
drop t2_8725_002_in;
create table t1_8725_001_in(a string collate utf8_bin);
create table t2_8725_001_in(a string collate utf8_ko_cs);

insert into t1_8725_001_in values ('a1');
insert into t1_8725_001_in values ('a2');

insert into t2_8725_001_in values ('a2');
insert into t2_8725_001_in values ('a3');

select * from t1_8725_001_in where a in (select a from t2_8725_001_in);
select * from t1_8725_001_in where a not in (select a from t2_8725_001_in);

select * from t1_8725_001_in where a in ((select a from t2_8725_001_in) union all (select '0'+a from t2_8725_001_in) union all (select a+a from t2_8725_001_in));

select * from t2_8725_001_in where a in (select a from t1_8725_001_in);
select * from t2_8725_001_in where a not in (select a from t1_8725_001_in);


drop t1_8725_001_in;
drop t2_8725_001_in;

set names iso88591;
commit;
--+ holdcas off;
