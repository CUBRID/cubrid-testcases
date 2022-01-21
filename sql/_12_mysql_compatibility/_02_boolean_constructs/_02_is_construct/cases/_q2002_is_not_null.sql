select if(null is null, 2,3) from db_root;
select if(null is not null, 2,3) from db_root;
select 1 from db_root where (1|1)<>0 IS TRUE;
select 1 from db_root where (1&1)<>0 IS false;
select 1 from db_root where (1&1 -1)<>0 IS false;
select 1 from db_root where (1|1)<>0 IS not TRUE;
select 1 from db_root where (1&1)<>0 IS not false;
select 1 from db_root where (1&1 -1)<>0 IS not false;
