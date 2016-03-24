--+ holdcas on;
-- test cases on system parameter holding the maximum size of a string
-- (CHAR, NCHAR, VARCHAR , VARNCHAR, BIT, VARBIT) when created with :
-- SPACE, REPEAT, GROUP_CONCAT, CONCAT, CONCAT_WS, STRCAT ,INSERT, + (PLUS )




-- INSERT
set system parameters 'string_max_size_bytes=64';

select insert('1234567890123456789012345678901234567890123456789012345678901234',1,1,'1');
select insert('1234567890123456789012345678901234567890123456789012345678901234',1,1,'12');


select insert(n'123456789012345678901234567890',1,1,n'123');
select insert(n'123456789012345678901234567890',1,1,n'1234');


create table t1 (s1 char(30),s2 varchar(30), s3 national char varying(30));
insert into t1 values ('123456789012345678901234567890','123456789012345678901234567890',n'123456789012345678901234567890');

select insert(s1,1,1,s1) from t1;

select insert(s1,1,1,s1 + s1) from t1;



select insert(s2,1,1, s2) from t1;

select insert(s2,1,1, s2 + s2) from t1;

select insert(s2,1,1,'123456789012') from t1;

select insert(s3,1,1,n'123') from t1;

select insert(s3,1,1,n'1234') from t1;

drop t1;



set system parameters 'string_max_size_bytes=10000000';

commit;
--+ holdcas off;
