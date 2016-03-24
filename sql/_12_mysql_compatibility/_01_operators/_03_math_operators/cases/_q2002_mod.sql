select 0 mod 9223372036854775807 from db_root;
select 1 mod 9223372036854775807 from db_root;
select -1 mod 9223372036854775807 from db_root;

select 9223372036854775807 mod 9223372036854775807 from db_root;
select 9223372036854775807 mod -9223372036854775807 from db_root;
select 9223372036854775807 mod 1 from db_root;
select 9223372036854775807 mod -1 from db_root;

select -9223372036854775807 mod 9223372036854775807 from db_root;
select -9223372036854775807 mod -9223372036854775807 from db_root;
select -9223372036854775807 mod 1 from db_root;
select -9223372036854775807 mod -1 from db_root;

select 927 mod 1.5 from db_root;

select ~0 mod (0 & 9223372036854775807) from db_root;
select (~(0 | 9223372036854775807)) mod 2 from db_root;
select (~0 | (9223372036854775807 mod 2)) mod 2 from db_root;
select (0 | (9223372036854775807 mod 2)) mod (~0 | (9223372036854775807 mod 2)) from db_root;