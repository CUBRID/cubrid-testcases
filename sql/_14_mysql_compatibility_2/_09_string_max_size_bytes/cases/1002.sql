--+ holdcas on;
-- test cases on system parameter holding the maximum size of a string
-- (CHAR, NCHAR, VARCHAR , VARNCHAR, BIT, VARBIT) when created with :
-- SPACE, REPEAT, GROUP_CONCAT, CONCAT, CONCAT_WS, STRCAT ,INSERT, + (PLUS )




-- REPEAT
set system parameters 'string_max_size_bytes=300';

select repeat('abc',100);

select repeat('abc',101);

select repeat(n'abc',100);

select repeat(n'abc',101);


create table t1 (i1 int);
insert into t1 values (299),(300),(301);

select i1,repeat('a',i1) from t1 where i1 <= 299 order by i1;

select i1,repeat('a',i1) from t1 where i1 <= 300 order by i1;

select i1,repeat('a',i1) from t1 where i1 <= 301 order by i1;

drop t1;



set system parameters 'string_max_size_bytes=10000000';

commit;
--+ holdcas off;
