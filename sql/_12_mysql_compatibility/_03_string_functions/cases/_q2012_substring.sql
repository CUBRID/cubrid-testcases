--+ holdcas on;
set system parameters 'compat_mode=mysql';
select substring('George',0,3) as sub_string;
select substring('George',1,3) as sub_string;
select substring('George',-4,3) as sub_string;
select substring('George',1,1999999999) as sub_string;
select substring('George',1,2000000000) as sub_string;
select substring('George',1,2000000000-1) as sub_string;
select substring('George',1,1999999999+1) as sub_string;
select 1 as a from (select substring('중abc이',0,2) FROM DB_ROOT) as t1;
select substring('ABCDEFG',2,0) FROM DB_ROOT;
select substring('ABCDEFG',null,2) FROM DB_ROOT;
select substring('ABCDEFG',2,null) FROM DB_ROOT;
select CHAR_LENGTH(substring('ABCDEFG',2,3)) FROM DB_ROOT;
select substring('ABCDEFG',2,LOCATE('bar', 'foobarbar')) FROM DB_ROOT;
select substring(concat_ws('aaa','bbb','ccc','eee'),FIELD(LEFT('foobarbar', 5),'foo','foob','fooba','foobar','foobarb'),2);

set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
