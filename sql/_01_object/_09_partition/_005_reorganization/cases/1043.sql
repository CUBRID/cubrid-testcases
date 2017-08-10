-- insert data  whith create range partition table on a char field and add a attribute and a partition and then query data 

create table range_test(id int, name varchar(255)) partition by range (id)(
partition p0 values less than (3),
partition p1 values less than (6),
partition p2 values less than (9),
partition p3 values less than (12));
alter table range_test add attribute d int;
alter table range_test add partition (partition p4 values less than (15));

insert into range_test (id, name, d) values(1, 'xxx', 1);
insert into range_test (id, name, d) values(2, 'xxx', 1);
insert into range_test (id, name, d) values(3, 'xxx', 1);
insert into range_test (id, name, d) values(4, 'xxx', 1);
insert into range_test (id, name, d) values(5, 'xxx', 1);
insert into range_test (id, name, d) values(6, 'xxx', 1);
insert into range_test (id, name, d) values(7, 'xxx', 1);
insert into range_test (id, name, d) values(8, 'xxx', 1);
insert into range_test (id, name, d) values(9, 'xxx', 1);
insert into range_test (id, name, d) values(10, 'xxx', 1);

select range_test, range_test.* from range_test order by 2;
update range_test set id = id + 2;
select range_test, range_test.* from range_test order by 2;

drop table range_test;
