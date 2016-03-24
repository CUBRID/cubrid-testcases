autocommit off;
create table dual (
	dummy varchar(1)
);
insert into dual values ('X');

select add_months(date '1/31/1',.0) from dual;

select add_months(date '1/31/1',1.9) from dual;

select add_months(date '1/31/1',2400) from dual;

select add_months(date '2/28/1',12) from dual;
select add_months(date '2/28/1',48) from dual;
select add_months(date '2/28/1',24000-12) from dual;
select add_months(date '2/28/1',24000) from dual;

select add_months(date '1/31/1',-1) from dual;
select add_months(date '1/31/1',120000) from dual;
select add_months(date '12/31/9999',1) from dual;

drop table dual;
rollback;
