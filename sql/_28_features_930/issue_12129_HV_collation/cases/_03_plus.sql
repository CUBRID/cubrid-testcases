set names iso88591;

prepare stmt from 'select ? + ?, collation (? + ?)'; 
execute stmt using _utf8'x', _utf8'y', _utf8'x', _utf8'y';
execute stmt using _euckr'x', _euckr'y', _euckr'x', _euckr'y';
execute stmt using _utf8'x', _iso88591'y', _utf8'x', _iso88591'y';
execute stmt using _utf8'x', _euckr'y', _utf8'x', _euckr'y';
execute stmt using _euckr'x', _utf8'y', _euckr'x', _utf8'y';
deallocate prepare stmt;


prepare s from 'select rtrim(? + ?, ?), collation (rtrim(? + ?, ?))';
execute s using _utf8'a', _utf8'x', _utf8'y', _utf8'a', _utf8'x', _utf8'y';
-- this case cannot be solved
execute s using _utf8'a', _utf8'x', _iso88591'y', _utf8'a', _utf8'x', _iso88591'y';

execute s using _euckr'a', _euckr'x', _euckr'y', _euckr'a', _euckr'x', _euckr'y';
deallocate prepare s;

create table t1 (s1 string collate utf8_en_ci,s2 int);
insert into t1 values('a',1);
insert into t1 values('A',2);

prepare stmt from 'select ? + s1, collation (? + s1) from t1 order by s2'; 

execute stmt using _utf8'x', _utf8'x';
execute stmt using _iso88591'x', _iso88591'x';
execute stmt using _euckr'x', _euckr'x';

set names utf8 collate utf8_en_cs;
execute stmt using 'x', 'x';

prepare s from 'select s1 + ?, collation (s1 + ?) from t1 order by s2';
set names iso88591;
execute s using 'A','A';
execute s using _iso88591'A',_iso88591'A';
set names utf8 collate utf8_en_cs;
execute stmt using 'A', 'A';

deallocate prepare stmt;
deallocate prepare s;


prepare stmt from 'select ? + ? + s1, collation (? + ? + s1) from t1 order by s2'; 

execute stmt using _utf8'x', _utf8'y', _utf8'x', _utf8'y';
execute stmt using _euckr'x', _euckr'y', _euckr'x', _euckr'y';
execute stmt using _utf8'x', _iso88591'y', _utf8'x', _iso88591'y';
execute stmt using _utf8'x', _euckr'y', _utf8'x', _euckr'y';
execute stmt using _euckr'x', _utf8'y', _euckr'x', _utf8'y';
deallocate prepare stmt;



select 'create table with type maybe results';

show full columns in t1;
prepare stmt from 'create table t2 as select ? + ? + s1 as x1, collation (? + ? + s1) as x2 from t1';

execute stmt using _utf8'x', _utf8'y', _utf8'x', _utf8'y';
show full columns in t2;
drop table if exists t2;

execute stmt using _euckr'x', _euckr'y', _euckr'x', _euckr'y';
show full columns in t2;
drop table if exists t2;

execute stmt using _utf8'x', _iso88591'y', _utf8'x', _iso88591'y';
show full columns in t2;
drop table if exists t2;

execute stmt using _euckr'x', _utf8'y', _euckr'x', _utf8'y';
show full columns in t2;
drop table if exists t2;
deallocate prepare stmt;


select 'plus with compare';

prepare stmt from 'select * from t1 where s1 + ? > ? order by 1'; 
truncate t1;
insert into t1 values ('X',3);
insert into t1 values ('x',4);
execute stmt using _utf8'x', _utf8'x';
execute stmt using _euckr'x', _euckr'x';
execute stmt using _utf8'x', _euckr'x';
execute stmt using _utf8'x', _euckr'x';
deallocate prepare stmt;


select 'plus as argument of another expression';
prepare s from 'select rtrim(s1 + ?,?), collation (rtrim(s1 + ?,?)) from t1 order by 1';
set names utf8 collate utf8_en_cs;
execute s using 'A','c','A','c';
execute s using 'A','a','A','a';
execute s using _euckr'A',_euckr'a',_euckr'A',_euckr'a';
deallocate prepare s;

prepare s from 'select replace(s1 + ?,?, ?), collation (replace(s1 + ?,?,?)) from t1 order by 1';
set names utf8 collate utf8_en_cs;
execute s using 'A','A','c','A','A','c';
execute s using 'A','a','c','a','A','c';
execute s using _euckr'A',_euckr'a', _euckr'e',_euckr'A',_euckr'a',_euckr'e';
deallocate prepare s;

drop table t1;

set names iso88591 collate iso88591_en_cs;
create table t1 (s1 string collate utf8_en_ci);
insert into t1 values ('Ab'),( 'aa');
select * from t1 where 'aa' > s1 + '0' order by 1;
prepare s from 'select * from t1 where ? > s1 + ? order by 1' ;
execute s using 'aa','0';
deallocate prepare s;

prepare s from 'select * from t1 where ? > s1 || ? order by 1' ;
execute s using 'aa','0';
deallocate prepare s;

drop table t1;

set names iso88591;


