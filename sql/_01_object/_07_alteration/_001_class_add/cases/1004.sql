-- [er]create class and alter it to add -1 precision ncahr varying /float attribute


create class c_nv (it int);
alter class c_nv add attribute nv nchar varying(-1);
create class c_f (it int);
alter class c_f add attribute nf float(-1);

drop class c_nv;
drop class c_f;
