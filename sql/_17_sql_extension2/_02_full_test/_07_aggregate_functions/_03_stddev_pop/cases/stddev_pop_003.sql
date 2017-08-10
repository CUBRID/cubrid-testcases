--pass a group of collection arguments


create table voo (col1 float, col2 set, col3 multiset, col4 list);

insert into voo values (95.68, {1, 3, 5, 4, 3}, {1, 2, 2, 3, 3, 5}, {3, 1, 4, 3, 5});
insert into voo values (88.88, {34, 56, 89}, {19, 45, 33, 78}, {122, 101, 56, 47});
insert into voo values (76.89, {2, 4, 5, 56}, {1, 2, 5, 6}, {11, 22, 33, 44});

select * from voo order by 1;
select stddev_pop(col1) from voo;
select stddev_pop(col2) from voo;
select stddev_pop(col3) from voo;
select stddev_pop(col4) from voo;


delete from voo;
drop table voo;

