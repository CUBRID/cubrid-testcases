autocommit off;
create table tb (
	dummy varchar(1)
);
insert into tb values ('X');

select add_months(date '1/31/1',.0) from tb;

select add_months(date '1/31/1',1.9) from tb;

select add_months(date '1/31/1',2400) from tb;

select add_months(date '2/28/1',12) from tb;
select add_months(date '2/28/1',48) from tb;
select add_months(date '2/28/1',24000-12) from tb;
select add_months(date '2/28/1',24000) from tb;

select add_months(date '1/31/1',-1) from tb;
select add_months(date '1/31/1',120000) from tb;
select add_months(date '12/31/9999',1) from tb;

drop table tb;
rollback;
