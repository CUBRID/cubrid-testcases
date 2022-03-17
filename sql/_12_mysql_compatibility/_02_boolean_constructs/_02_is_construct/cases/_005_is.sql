select 1 from db_root where 1<>0 IS TRUE;
select 1 from db_root where 0<>0 IS FALSE;
select 1 from db_root where NULL<>0 IS UNKNOWN;
select 1 from db_root where 'a'<>0 IS TRUE;
select 1 from db_root where 123456789012345<>0 is true;
select 1 from db_root where 123456789012345 is null;
