--+ holdcas on;
set names utf8;
drop table if exists t;

create table t(s1 string collate utf8_gen,s2 string collate utf8_bin,s3 string collate iso88591_bin);
insert into t values('a','b','c');
prepare st from 'select coercibility(s1),coercibility(s2),coercibility(s3) from t';
execute st;
deallocate prepare st;
drop t;

set names utf8 collate utf8_gen;
prepare st from 'select coercibility(?)';
execute st using 'a';
deallocate prepare st;

set names iso88591 collate iso88591_bin;
prepare st from 'select coercibility(?)';
execute st using 'a';
deallocate prepare st;

set @a='a';
prepare st from 'select coercibility(@a)';
execute st;
deallocate prepare st;
prepare st from 'select coercibility(?)';
execute st using @a;
deallocate prepare st;

set names utf8;

create table t(s string collate utf8_bin);
insert into t values('bbb');
set names utf8 collate utf8_gen_ci;
select * from t where s like '_B_';
prepare st from 'select * from t where s like ?';
execute st using '_B_';
deallocate prepare st;
drop variable @a;

drop t;

set names iso88591;

--+ holdcas off;
