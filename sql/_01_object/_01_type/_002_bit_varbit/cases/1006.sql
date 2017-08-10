-- [er]create table with  varbit using 1073741824 length 

create class c_vb (vb bit varying(1073741824));

drop c_vb;