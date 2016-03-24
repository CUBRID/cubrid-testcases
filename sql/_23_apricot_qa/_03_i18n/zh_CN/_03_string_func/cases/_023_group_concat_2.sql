--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_gen, a int);
-- UTF-8 test CHAR collate utf8_gen is stored in 3 bytes
insert into t1 values (1, '颠',1);
insert into t1 values (2, '颠',1);
insert into t1 values (3, '颠',1);
insert into t1 values (4, '颠',1);
insert into t1 values (5, '颠',1);
insert into t1 values (6, '颠',1);

set system parameters 'group_concat_max_len=5';

select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=1024';

drop table t1;


-- fixed CHAR collate utf8_gen
create table t1 (i1 int , s1 CHAR(2) collate utf8_gen, a int);
insert into t1 values (1, '颠',1);
insert into t1 values (2, '颠',1);
insert into t1 values (3, '颠',1);
insert into t1 values (4, '颠',1);
insert into t1 values (5, '颠',1);
insert into t1 values (6, '颠',1);

set system parameters 'group_concat_max_len=5';

select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=6';

select group_concat (s1 order by 1 separator '_') from t1 group by a;

set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;


