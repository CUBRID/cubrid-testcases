-- [er]create calss and alter it to add zero precision bit varying /char attribute


create class c_vb (it int);
alter class c_vb add attribute vb bit varying(0);
create class c_c (it int);
alter class c_c add attribute c char(0);

drop class c_vb;
drop class c_c;
