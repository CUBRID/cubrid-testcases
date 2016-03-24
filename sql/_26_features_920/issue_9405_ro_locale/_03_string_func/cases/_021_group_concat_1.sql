--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_ro_cs, a int);
-- UTF-8 test char is stored in 3 bytes
insert into t1 values (1, 'Ă',1);
insert into t1 values (2, 'ă',1);
insert into t1 values (3, 'Â',1);
insert into t1 values (4, 'â',1);
insert into t1 values (5, 'ş',1);
insert into t1 values (6, 'țţ',1);
insert into t1 values (6, null,1);

set system parameters 'group_concat_max_len=5';

--test
select group_concat (s1 order by 1 separator ' ') from t1 group by a;

set system parameters 'group_concat_max_len=1024';

--test
select group_concat (s1 order by 1 separator ' ') from t1 group by a;

drop table t1;


-- fixed char
create table t1 (i1 int , s1 char(4), a int);
insert into t1 values (1, 'ţ',1);
insert into t1 values (2, 'Tț',1);
insert into t1 values (3, 'Ţ',1);
insert into t1 values (4, 'Ț',1);
insert into t1 values (5, 'Ș',1);
insert into t1 values (6, 'şșŞ',1);
--test
set system parameters 'group_concat_max_len=5';
-- CUBRIDSUS-17805
select group_concat (s1 order by 1 separator '_') from t1 group by a;
--test
set system parameters 'group_concat_max_len=6';
--test
-- CUBRIDSUS-17805
select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=1024';
--test
-- CUBRIDSUS-17805
select group_concat (s1 order by 1 separator '_') from t1 group by a;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;


