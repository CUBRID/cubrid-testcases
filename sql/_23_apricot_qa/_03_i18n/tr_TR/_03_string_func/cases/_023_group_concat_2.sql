--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_tr_cs_uca, a int);
-- UTF-8 test char is stored in 3 bytes
insert into t1 values (1, '好',1);
insert into t1 values (2, '好',1);
insert into t1 values (3, '好',1);
insert into t1 values (4, '好',1);
insert into t1 values (5, '好',1);
insert into t1 values (6, '好人',1);
insert into t1 values (6, null,1);

set system parameters 'group_concat_max_len=5';

--test
select group_concat (s1 order by 1 separator ' ') from t1 group by a;

set system parameters 'group_concat_max_len=1024';

drop table t1;


-- fixed char
create table t1 (i1 int , s1 char(10) collate binary, a int);
insert into t1 values (1, '好',1);
insert into t1 values (2, '好人',1);
insert into t1 values (3, '好',1);
insert into t1 values (4, '好',1);
insert into t1 values (5, '好',1);
insert into t1 values (6, '好人人',1);
--test
set system parameters 'group_concat_max_len=5';

select group_concat (s1 order by 1 separator '_') from t1 group by a;
--test
set system parameters 'group_concat_max_len=6';
--test
select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;


