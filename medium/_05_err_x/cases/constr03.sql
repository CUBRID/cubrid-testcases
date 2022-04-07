autocommit off;
insert into joe.kitsch_v (atom_c)
values (NULL);
rollback work;
rollback;
