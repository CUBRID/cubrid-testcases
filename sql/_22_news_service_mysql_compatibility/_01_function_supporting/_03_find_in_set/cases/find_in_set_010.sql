--+ holdcas on;

--TEST:
set system parameters 'ansi_quotes=no';
select find_in_set("b","a,b,c"),find_in_set("c","a,b,c"),find_in_set("dd","a,bbb,dd"),find_in_set("bbb","a,bbb,dd");
select find_in_set("d","a,b,c"),find_in_set("dd","a,bbb,d"),find_in_set("bb","a,bbb,dd");


--TEST: Wrong usage of functions
set system parameters 'ansi_quotes=no';




select find_in_set("abc","abc"),find_in_set("ab","abc"),find_in_set("abcd","abc");


--TEST: find_in_set is case insensitive even on binary operators
select find_in_set(binary 'a',binary 'A,B,C');
select find_in_set('a',binary 'A,B,C');
select find_in_set(binary 'a', 'A,B,C');


--TEST: FIND_IN_SET fails if set ends with a comma
select find_in_set('1','3,1,');


--TEST: valgrind warnings with find_in_set() functions
--disable_warnings
drop table if exists t1;
--enable_warnings
create table t1 (f1 set('test1','test2','test3') character set utf8 default null);
insert into t1 values (''),(null),(null),(''),(''),('');
select find_in_set(f1,f1) as a from t1,(select find_in_set(f1,f1) as b from t1) a;
drop table t1;

set system parameters 'ansi_quotes=yes';
commit;
--+ holdcas off;
