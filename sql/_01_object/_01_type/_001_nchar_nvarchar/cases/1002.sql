-- [er]create two tables with varchar and nchar varying data types and tests a create syntax with conditions like 'varchar(0)' or 'nchar varying(0)' and then report syntax error

create class c_v (v varchar(0)); 
create class c_nv (nv nchar varying(0));

drop class c_v;
drop class c_nv;