create table t1(id int, a varchar collate utf8_en_cs, b varchar collate utf8_en_ci);
insert into t1 values (1, 'Y', 'Y');
insert into t1 values (2, 'y', 'y');
prepare stmt from 'select id, a, ? > a, ? > b from t1 order by id';
execute stmt using 'Z', 'Z';
execute stmt using 'z', 'z';
execute stmt using 'X', 'X';
execute stmt using 'x', 'x';
deallocate prepare stmt;
drop table t1;


prepare stmt from 'select collation(USER), ? > USER';
set names utf8 collate utf8_en_cs;
execute stmt using 'EBA';
execute stmt using 'CBA';
set names utf8 collate utf8_en_ci;
execute stmt using 'eBA';
execute stmt using 'cBA';
deallocate prepare stmt;

prepare stmt from 'select collation(upper(USER)), ? > upper(USER)';
set names utf8 collate utf8_en_cs;
execute stmt using 'EBA';
execute stmt using 'CBA';
set names utf8 collate utf8_en_ci;
execute stmt using 'eBA';
execute stmt using 'cBA';
deallocate prepare stmt;

prepare stmt from 'select collation(upper(USER)), ? > upper(USER)';
set names utf8 collate utf8_en_cs;
execute stmt using 'EBA';
execute stmt using 'CBA';
set names utf8 collate utf8_en_ci;
execute stmt using 'eBA';
execute stmt using 'cBA';
deallocate prepare stmt;

prepare stmt from 'select ? > _utf8''d'' collate utf8_en_ci';
set names utf8 collate utf8_en_cs;
execute stmt using 'e';
execute stmt using 'E';
execute stmt using 'c';
execute stmt using 'C';
set names utf8 collate utf8_en_ci;
execute stmt using 'e';
execute stmt using 'E';
execute stmt using 'c';
execute stmt using 'C';
deallocate prepare stmt;


prepare stmt from 'select ? > _utf8''d'' collate utf8_en_ci';
set names utf8 collate utf8_en_cs;
execute stmt using 'e';
execute stmt using 'E';
execute stmt using 'c';
execute stmt using 'C';
set names utf8 collate utf8_en_ci;
execute stmt using 'e';
execute stmt using 'E';
execute stmt using 'c';
execute stmt using 'C';
deallocate prepare stmt;


prepare stmt from 'select ? > cast(? as varchar(10) collate utf8_en_ci)';
set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'B';
set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'B';
deallocate prepare stmt;


prepare stmt from 'select ? > cast(? as varchar(10) collate utf8_en_cs)';
set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'B';
set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'B';
deallocate prepare stmt;

--TODO
--set names iso88591;
--set @v1='a';
--prepare stmt from 'select coercibility(?), charset(?), collation(?), coercibility(@v1)';
--execute stmt using 'a', 'a', 'a';
--deallocate prepare stmt;

prepare stmt from 'select ?> (? || cast(? as varchar(10) collate utf8_en_cs))';
set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'B', 'c';
set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'B', 'c';
deallocate prepare stmt;

prepare stmt from 'select ?> (? || cast(? as varchar(10) collate utf8_en_ci))';
set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'B', 'c';
set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'B', 'c';
deallocate prepare stmt;

prepare stmt from 'select ?> (? || cast(? as varchar(10) collate utf8_en_ci))';
set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'B', 'c';
set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'B', 'c';
deallocate prepare stmt;
drop variable @v1;

set names iso88591;
