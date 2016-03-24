autocommit off;
insert into kitsch_v (atom_i, atom_c, attr_1, attr_6,
                      set_attr_1, set_attr_6)
values (10, 'c', '10', 10, {'10'}, {10});
insert into kitsch_v (atom_i, atom_c, attr_1, set_attr_1)
values (10, 'c', '11', {'11'});
rollback work;
rollback;
