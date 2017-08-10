-- [er]create class and alter it to add -1 precision nchar varying/varchar attribute


create class c_vb (it int);
alter class c_vb add attribute vb bit varying(-1);
create class c_c (it int);
alter class c_c add attribute c char(-1);

drop class c_vb;
drop class c_c;
