--+ holdcas on;
-- test cases on system parameter holding the maximum size of a string
-- (CHAR, NCHAR, VARCHAR , VARNCHAR, BIT, VARBIT) when created with :
-- SPACE, REPEAT, GROUP_CONCAT, CONCAT, CONCAT_WS, STRCAT ,INSERT, + (PLUS )



-- SPACE
set system parameters 'string_max_size_bytes=300';

select space(300) from db_root;

select space(301) from db_root;


create table t1 (i1 int);
insert into t1 values (299),(300),(301);

select i1,space(i1) from t1 where i1 = 299;

select i1,space(i1) from t1 where i1 = 300;

select i1,space(i1) from t1 where i1 = 301;

drop t1;





set system parameters 'string_max_size_bytes=10000000';

commit;
--+ holdcas off;
