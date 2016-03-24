create table t1(a int, b varchar charset utf8 collate utf8_en_ci);
insert into t1 values (1, 'a'), (2, 'A'), (3, 'b'), (4, 'B'), (5, 'c'), (6, 'C');
create index i_t1_b on t1(b) where b>'b';

prepare stmt from 'select /*+ recompile */ * from t1 where b > ? using index i_t1_b(+) keylimit 0,2';
set names utf8 collate utf8_en_ci;
execute stmt using 'a';
execute stmt using 'b';
execute stmt using 'c';
deallocate prepare stmt;

prepare stmt from 'select /*+ recompile */ * from t1 where b||? > ?||? using index i_t1_b(+)';
set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'a', 'A';
deallocate prepare stmt;

drop table t1;

set names iso88591;
