--create range partition table with date data type,insert data to this table and select data in where clause with function last_day,add_months and to_date

create table range_date(id int, test_date date)
partition by range(test_date)
(partition p0 values less than ('2005-01-01'),
partition p1 values less than ('2006-01-01'),
partition p2 values less than ('2007-01-01'),
partition p3 values less than maxvalue);

insert into range_date values(1,'2005-01-01');
insert into range_date values(2,'2006-01-01');
insert into range_date values(3,'2007-02-05');
insert into range_date values(4,'2007-03-31');
select * from range_date where test_date = last_day(date '2007-03-02') order by 1;
select * from range_date where test_date = add_months(date '2006-12-05', 2) order by 1;
select * from range_date where test_date = to_date('2007-02-05','YYYY-MM-DD') order by 1;

drop class range_date;
