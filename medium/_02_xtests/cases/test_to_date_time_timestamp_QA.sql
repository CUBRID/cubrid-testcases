autocommit off;
create table dual (
	dummy varchar(1)
);
insert into dual values ('X');
create table test_to_date_time_timestamp (
	type_char char(30),
	type_varchar varchar(30),
	type_nchar nchar(30),
	type_nchar_varying nchar varying(30)
);
select to_date('9/6/1976','mm/dd/yyyy') from dual;

select  extract(year from sys_date) - extract(year from to_date('9','mm')) from dual;
select  1 - extract(day from to_date('9','mm')) from dual;

select  extract(month from sys_date) - extract(month from to_date('1976','yyyy')) from dual;
select  extract(year from sys_date) - extract(year from to_date('9','mm')) from dual;

select  extract(year from sys_date) - extract(year from to_date('9 06','mm dd')) from dual;

select  1 - extract(day from to_date('1976 6','yyyy mm')) from dual;

select  1 - extract(day from to_date('1976 9','yyyy mm')) from dual;

select to_time('12�� 30�� 20��','HH"��" MI"��" SS"��"') from dual;
select to_time('12�� 30�� 20�� pm','HH"��" MI"��" SS"��" p.m.') from dual;
select to_time('pm','p.m.') from dual;
select to_time('am','p.m.') from dual;

select to_time('13�� 10�� 20��','hh24"��" mi"��" ss"��"') from dual; 
select to_time('12:14:29 pm','hh:mi:ss am') from dual; 
select to_time('12:14 pm','hh12:mi p.m.') from dual; 

select to_time('12:14: ','hh:mi: ') from dual; 

select to_time('12: :29','hh: :ss') from dual; 

select to_time('14:29: ','mi:ss: ') from dual; 


select  1  - extract( day from to_timestamp('Sep, 16 12:14: ','mon, yy hh:mi: ')) from dual;

select extract(month from sys_timestamp) - extract(month from to_timestamp('6, 16 12: :29','dd, yy hh: :ss')) from dual;

select extract(year from sys_timestamp) - extract(year from to_timestamp('6 Sep 14:29: ','dd mon mi:ss: ')) from dual;

select to_date('9/6/1976') from dual;
select to_time('14:30:30') from dual;
select to_timestamp('14:30:30 9/6/1976') from dual;
select to_date(NULL) from dual;
select to_date(NULL,NULL) from dual;
select to_time(NULL) from dual;
select to_time(NULL,NULL) from dual;
select to_timestamp(NULL) from dual;
select to_timestamp(NULL,NULL) from dual;
drop table dual;
drop table test_to_date_time_timestamp;
rollback;
