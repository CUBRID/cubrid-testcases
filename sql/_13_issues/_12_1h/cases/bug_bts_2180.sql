--+ holdcas on;
drop if exists tbl;

create table tbl (id int) partition by range (id + 1) (partition p0 values less than (2), partition p1 values less than MAXVALUE);
insert into tbl values (22);
select tbl into :x from tbl;
update object :x set id = 44;
select * from tbl;

delete from tbl;
insert into tbl values(0);
select tbl into :x from tbl;
update object :x set id = 44;
select * from tbl;

drop tbl;

create table tbl (v varchar(10)) partition by hash(substring(v,1,1)) partitions 2;
insert into tbl values('aa');
select tbl into :x from tbl;
update object :x set v = 'ca';
select * from tbl;

delete from tbl;
insert into tbl values('aa');
select tbl into :x from tbl;
update object :x set v = 'ba';
select * from tbl;

drop tbl;
create table tbl (d date) partition by list(add_months(d,3)) (partition p0 values in ('2013-05-06','2013-06-06'),partition p1 values in ('2012-03-19','2012-04-19'));
insert into tbl values('2013-02-06');
select tbl into :x from tbl;
update object :x set d = '2013-03-06';
select * from tbl;

delete from tbl;
insert into tbl values('2013-02-06');
select tbl into :x from tbl;
update object :x set d = '2011-12-19';
select * from tbl;

drop tbl;

--+ holdcas off;
