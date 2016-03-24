autocommit off;
insert into kitsch_v (attr_1, attr_6, set_attr_1, atom_c, csetattr6)
values ('100', NULL, {'10'}, '', {});
rollback work;
rollback;
