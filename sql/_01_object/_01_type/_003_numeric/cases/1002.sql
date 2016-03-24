--Test numeric precision

select 1.0 / 7 from db_root;
select 1.00/ 7 from db_root;
select cast( 1 as numeric(38,0)) / 7 from db_root;
select 1.0 / 7.0 from db_root;
