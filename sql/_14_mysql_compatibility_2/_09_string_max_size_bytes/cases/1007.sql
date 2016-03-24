--+ holdcas on;
-- test cases on system parameter holding the maximum size of a string
-- (CHAR, NCHAR, VARCHAR , VARNCHAR, BIT, VARBIT) when created with :
-- SPACE, REPEAT, GROUP_CONCAT, CONCAT, CONCAT_WS, STRCAT ,INSERT, + (PLUS )


-- GROUP_CONCAT
set system parameters 'string_max_size_bytes=64';
create table t1 (s1 char varying(32),i1 int);
insert into t1 values('123456789012345678901234567890++',1);
insert into t1 values('123456789012345678901234567890++',2);
insert into t1 values('123456789012345678901234567890++',3);
insert into t1 values('123456789012345678901234567890++',3);
insert into t1 values('123456789012345678901234567890++',2);
insert into t1 values('123456789012345678901234567890++',4);
insert into t1 values('123456789012345678901234567890++',3);


-- limit for warning level less than max size of string
set system parameters 'group_concat_max_len=63';

select i1,group_concat(s1) from t1 group by i1; 



-- limit for warning level equal to max size of string
set system parameters 'group_concat_max_len=64';

select i1,group_concat(s1) from t1 group by i1; 


-- limit for warning level greater than max size of string
set system parameters 'group_concat_max_len=65';

select i1,group_concat(s1) from t1 group by i1; 

drop t1;


set system parameters 'group_concat_max_len=1024';
set system parameters 'string_max_size_bytes=10000000';

commit;
--+ holdcas off;
