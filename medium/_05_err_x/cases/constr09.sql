autocommit off;
insert into kitsch_v (attr_1, attr_2, set_attr_1)
values ('100', $5000, {'10'});
rollback work;
rollback;
