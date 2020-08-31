--create list partition table with char data type and alter the separated attribute then add another partition 
set system parameters 'create_table_reuseoid=no';

create table list_test(id int, name varchar(255)) partition by list (id)(
partition p0 values in (1,2,3),
partition p1 values in (4,5,6),
partition p2 values in (7,8,9),
partition p3 values in (10,11,12));
alter table list_test add attribute d int;
alter table list_test add partition (partition p4 values in (13,14,15));

insert into list_test (id, name, d) values(1, 'xxx', 1);
insert into list_test (id, name, d) values(2, 'xxx', 1);
insert into list_test (id, name, d) values(3, 'xxx', 1);
insert into list_test (id, name, d) values(4, 'xxx', 1);
insert into list_test (id, name, d) values(5, 'xxx', 1);
insert into list_test (id, name, d) values(6, 'xxx', 1);
insert into list_test (id, name, d) values(7, 'xxx', 1);
insert into list_test (id, name, d) values(8, 'xxx', 1);
insert into list_test (id, name, d) values(9, 'xxx', 1);
insert into list_test (id, name, d) values(10, 'xxx', 1);

select list_test, list_test.* from list_test order by 2;
update list_test set id = id + 3;
select list_test, list_test.* from list_test order by 2;

drop table list_test;

set system parameters 'create_table_reuseoid=yes';
