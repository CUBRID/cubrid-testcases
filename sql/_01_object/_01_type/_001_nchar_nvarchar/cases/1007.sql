-- create table with varchar and nchar varying data type using default keyword

create class c_v (v varchar(11),nv nchar varying(536870911) DEFAULT N'nchar varying');

drop c_v;