--This case was added for cubridsus-1993 1994 1995 1996. cast funcion with other numberic funcion.

select mod(cast(1 as SHORT), cast(1 as BIGINT)) from db_root;

select to_char(exp(cast(1 as SHORT)),'9.9999999') from db_root; 

select to_char(round(cast(15.456 as NUMERIC(15,5)), cast(1 as SHORT)),'99.9') from db_root;

--select cast(9223372036854775807+ cast(1.0 as float)) as bigint) from db_root; 

select cast(9223372036854775808 as bigint) from db_root; 