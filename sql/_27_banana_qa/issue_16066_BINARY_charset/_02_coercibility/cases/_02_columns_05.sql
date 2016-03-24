--+ holdcas on;
set names binary;
drop table if exists t1;
create table t1(id int, a enum('A', 'B') collate binary);
insert into t1 values (1, 1);
insert into t1 values (2, 2);

-- binary - > utf8
prepare stmt from 'select a,coercibility(cast(a as varchar collate utf8_en_cs)),coercibility(?) from t1 where cast(a as varchar collate utf8_en_cs) > ?';
set names binary;
execute stmt using 'A','A';
deallocate prepare stmt;

prepare stmt from 'select a,coercibility(cast(a as varchar collate utf8_en_ci)),coercibility(?) from t1 where cast(a as varchar collate utf8_en_ci) > ?';
execute stmt using 'a','a';
deallocate prepare stmt;

set names iso88591;
commit;
--+ holdcas off;