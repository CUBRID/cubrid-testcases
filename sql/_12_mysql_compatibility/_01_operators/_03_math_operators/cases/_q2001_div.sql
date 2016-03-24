select 0 div 9223372036854775807 from db_root;
select 1 div 9223372036854775807 from db_root;
select -1 div 9223372036854775807 from db_root;

select 9223372036854775807 div 9223372036854775807 from db_root;
select 9223372036854775807 div -9223372036854775807 from db_root;
select 9223372036854775807 div 1 from db_root;
select 9223372036854775807 div -1 from db_root;

select -9223372036854775807 div 9223372036854775807 from db_root;
select -9223372036854775807 div -9223372036854775807 from db_root;
select -9223372036854775807 div 1 from db_root;
select -9223372036854775807 div -1 from db_root;

select 927 div 1.5 from db_root;

select ~0 div (0 & 9223372036854775807) from db_root;
select (~(0 | 9223372036854775807)) div 2 from db_root;
select (~0 | (9223372036854775807 div 2)) div 2 from db_root;
select (0 | (9223372036854775807 div 2)) div (~0 | (9223372036854775807 div 2)) from db_root;