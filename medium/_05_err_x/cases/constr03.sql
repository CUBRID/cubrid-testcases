autocommit off;
insert into kitsch_v (atom_c)
values (NULL);
rollback work;
rollback;
