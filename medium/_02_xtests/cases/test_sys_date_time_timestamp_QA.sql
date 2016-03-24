autocommit off;
create table dual (
	dummy varchar(1)
);
insert into dual values ('X');
select cast(sys_timestamp as date) - sys_date from dual;
select cast(sys_timestamp as time) - sys_time from dual;
drop table dual;
rollback;
