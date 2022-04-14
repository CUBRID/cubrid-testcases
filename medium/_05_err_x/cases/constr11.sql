autocommit off;
insert into joe.kitsch_v (attr_1, attr_4, set_attr_1, atom_c, cattr6, csetattr6)
values ('100', NULL, {'10'}, '', 0, {});
rollback work;
rollback;
