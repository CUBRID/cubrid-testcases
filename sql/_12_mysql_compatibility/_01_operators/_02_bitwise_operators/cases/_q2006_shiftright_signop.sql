select 0 >> 0 from db_root;
select 0 >> 1 from db_root;
select 0 >> -1 from db_root;
select 1 >> 0 from db_root;
select 1 >> 1 from db_root;
select 1 >> -1 from db_root;
select -1 >> 0 from db_root;
select -1 >> 1 from db_root;
select -1 >> -1 from db_root;

select 9223372036854775807 >> 9223372036854775807 from db_root;
select 9223372036854775807 >> -9223372036854775807 from db_root;
select 9223372036854775807 >> 0 from db_root;
select 9223372036854775807 >> -1 from db_root;

select -9223372036854775807 >> 9223372036854775807 from db_root;
select -9223372036854775807 >> -9223372036854775807 from db_root;
select -9223372036854775807 >> 0 from db_root;
select -9223372036854775807 >> -1 from db_root;


select (-9223372036854775807 >> 9223372036854775807) << -1 from db_root;
select (9223372036854775807 >> -9223372036854775807) << -1 from db_root;
select (9223372036854775807 >> 9223372036854775807) << 1 from db_root;
select (9223372036854775807 >> 9223372036854775807) << 1 from db_root;