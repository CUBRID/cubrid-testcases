-- create table with nchar using default keyword and nchar varying data type

create class c_v (v nchar(11) DEFAULT N'nchar' ,nv nchar varying(11));

drop c_v;