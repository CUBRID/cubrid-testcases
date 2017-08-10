--+ holdcas on;

-- initial vars
set @a = cast (123 as int);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (123 as bigint);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (123.45 as float);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (123.45 as double);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (123 as smallint);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (123.45 as monetary);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (123.45 as numeric(10,4));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (now() as date);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (now() as time);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (now() as datetime);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (now() as timestamp);
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast ('fox' as char(10));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast ('fox' as varchar(10));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (N'fox' as nchar(10));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (N'fox' as nchar varying(10));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast ('fox' as char(10));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (x'8' as bit(10));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;

set @a = cast (x'8' as bit varying(10));
set @te = cast (@a as object);
set @te = cast (@a as xyz);
set @te = cast (cast (@a as object) as varchar);
set @te = cast (cast (@a as varchar) as object);
set @te = cast (cast (@a as varchar) as xyz);
set @te = cast (cast (@a as xyz) as varchar);
drop variable @a, @te;


commit;

--+ holdcas off;
