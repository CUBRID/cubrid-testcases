-- insert data  whith create hash partition class on a date field with size 8 and query data with function of last_day,add_months and to_date and trunc and then drop class

create table hash_date(id int, test_date date)
partition by hash(test_date)
partitions 8;

insert into hash_date values(1,'2005-01-01');
insert into hash_date values(2,'2006-01-01');
insert into hash_date values(3,'2007-02-05');
insert into hash_date values(4,'2007-03-31');
select * from hash_date where test_date = last_day(date '2007-03-02');
select * from hash_date where test_date = add_months(date '2006-12-05', 2);
select * from hash_date where test_date = to_date('2007-02-05','YYYY-MM-DD');

drop class hash_date;