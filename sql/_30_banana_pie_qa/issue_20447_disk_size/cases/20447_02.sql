--+ holdcas on;

--test disk_size with operators ||, +
select disk_size('ch'||'nch') from db_root;

select disk_size(concat('ch','nch')) from db_root;

select disk_size('ch'+'nch') from db_root order by 1;

select disk_size(to_char(timestamp'12/12/2016 8:8:8 am')) from db_root order by 1;


--test disk_size with date/int/double/null..
select disk_size(to_date('12/15/2016')) from db_root;

select disk_size(to_time('8:8:8 am')) from db_root order by 1;  

select disk_size(b'0001') from db_root order by 1; 

select disk_size('a');

select disk_size(123.65);

select disk_size(null);

select disk_size('');

select disk_size(repeat('abc',300));

select disk_size(n'test');

select disk_size(1000);

select disk_size(cast(100.01 as double));

-- disk_size about I18N test,please see https://github.com/CUBRID/cubrid-testcases/blob/develop/sql/_13_issues/_16_2h/cases/cbrd_20576.sql

--+ holdcas off;