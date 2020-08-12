autocommit off;
create table tb (
	dummy varchar(1)
);
insert into tb values ('X');
select cast(sys_timestamp as date) - sys_date from tb;
select cast(sys_timestamp as time) - sys_time from tb;
drop table tb;
rollback;
