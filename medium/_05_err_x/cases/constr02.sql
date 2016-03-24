autocommit off;
insert into kitsch_v (atom_c, attr_1, attr_6, set_attr_1, set_attr_6)
values ('123456', '10', 10, {'10'}, {10});
rollback work;
rollback;
