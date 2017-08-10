--[er]create two tables with varchar and nchar varying data types and tests a create syntax with conditions like 'varchar(-1)','nchar varying(-1)' and then report syntax error
create class c_v (v varchar(-1));
create class c_nv (nv nchar varying(-1));

drop c_v;
drop c_nv;
