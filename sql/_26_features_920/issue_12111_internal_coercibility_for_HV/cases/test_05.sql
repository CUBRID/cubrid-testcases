--+ holdcas on;

create table t1(id int, a enum('A', 'B') collate utf8_en_cs);
insert into t1 values (1, 1);
insert into t1 values (2, 2);
prepare stmt from 'insert into t1 values (?, ?)';
set names utf8 collate utf8_en_ci;
execute stmt using 3, 'a';
execute stmt using 4, 'b';
execute stmt using 5, 'c';
deallocate prepare stmt;
drop table t1;

create table t1(id int, a enum('A', 'B') collate utf8_en_ci);
insert into t1 values (1, 1);
insert into t1 values (2, 2);
prepare stmt from 'insert into t1 values (?, ?)';
set names utf8 collate utf8_en_ci;
execute stmt using 3, 'a';
execute stmt using 4, 'b';
execute stmt using 5, 'c';
deallocate prepare stmt;
prepare stmt from 'select * from t1 where cast(a as varchar collate utf8_en_cs) > ? order by 1,2';
set names utf8 collate utf8_en_cs;
execute stmt using 'a';
execute stmt using 'A';
deallocate prepare stmt;
drop table t1;


-- CBRD-27583: the statements below, which run SET NAMES between PREPARE and EXECUTE, were written to check that
-- a literal of the statement keeps the collation of the session at PREPARE time. Since CBRD-27583 a PREPARE whose
-- statement has a position typed by its value makes no plan, and the first EXECUTE compiles it, so the literal
-- takes the collation of the session at EXECUTE time and these statements no longer check that.
set names utf8 collate utf8_en_cs;
prepare stmt from 'select coercibility(?), coercibility(''a''), collation(?), collation(''a''), ? = ''a''';
set names utf8 collate utf8_en_ci;
execute stmt using 'A', 'A', 'A';
deallocate prepare stmt;

--TODO
--set names iso88591;
--set @v1='a';
--prepare stmt from 'select coercibility(?), coercibility(@v1), collation(?), collation(@v1), ? = @v1';
--set names utf8 collate utf8_en_ci;
--execute stmt using 'A', 'A', 'A';
--set names utf8 collate utf8_en_cs;
--execute stmt using 'A', 'A', 'A';
--deallocate prepare stmt;

set names utf8 collate utf8_bin;
evaluate 'a' into :v1;
prepare stmt from 'select coercibility(?), coercibility(:v1), collation(?), collation(:v1), ? = :v1';
set names utf8 collate utf8_en_ci;
execute stmt using 'A', 'A', 'A';
deallocate prepare stmt;

drop variable @v1;
set names utf8;

--+ holdcas off;
