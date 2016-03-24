select ~0 from db_root;
select ~1 from db_root;
select ~-1 from db_root;
select ~-9223372036854775808  from db_root;
select ~9223372036854775807 from db_root;
select ~9223372036854775806 from db_root;
select ~9223372036854775808 from db_root;

select ~0 & 9223372036854775807 from db_root;
select ~0 | 9223372036854775807 from db_root;
select ~0 ^ 9223372036854775807 from db_root;
select ~0 & -9223372036854775807 from db_root;
select ~0 | -9223372036854775807 from db_root;
select ~0 ^ -9223372036854775807 from db_root;

select ~(0 & 9223372036854775807) from db_root;
select ~(0 | 9223372036854775807) from db_root;
select ~(0 ^ 9223372036854775807) from db_root;
select ~(0 & -9223372036854775807) from db_root;
select ~(0 | -9223372036854775807) from db_root;
select ~(0 ^ -9223372036854775807) from db_root;