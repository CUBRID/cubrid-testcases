autocommit off;
insert into kitsch_v (atom_i, atom_c)
values (100, NULL);
rollback work;
rollback;
