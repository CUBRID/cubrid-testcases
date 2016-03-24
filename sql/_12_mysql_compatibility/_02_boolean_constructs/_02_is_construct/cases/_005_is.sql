select 1 from db_root where 1 IS TRUE;
select 1 from db_root where 0 IS FALSE;
select 1 from db_root where NULL IS UNKNOWN;
select 1 from db_root where 'a' IS TRUE;
select 1 from db_root where 123456789012345 is true;
select 1 from db_root where 123456789012345 is null;