--[er]create class and alter it to add zero precision bit nchar varying attribute


create class c_nv (it int);
alter class c_nv add attribute nv nchar varying(0);



drop class c_nv;