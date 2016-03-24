select 0 | 9223372036854775807 from db_root;
select 1 | 9223372036854775807 from db_root;
select -1 | 9223372036854775807 from db_root;

select 0 | 9223372036854775808 from db_root;
select 1 | 9223372036854775808 from db_root;
select -1 | 9223372036854775808 from db_root;

select 0 | -9223372036854775808 from db_root;
select 1 | -9223372036854775808 from db_root;
select -1 | -9223372036854775808 from db_root;

select 0 | -9223372036854775807 from db_root;
select 1 | -9223372036854775807 from db_root;
select -1 | -9223372036854775807 from db_root;

select 11 | -11 from db_root where 11 | -11 =-1 && 111 | -111 <0 ;

select 11 | -11 from db_root where 1 = (select 111 & -111 from db_root where 1 = 111 & -111);

select 11 & -11 from db_root where !1 = (select 111 | -111 from db_root where -1 = 111 | -111);

select 11 | -1131 from db_root where !1 = (select 111 & -1111 from db_root where 1 = 111 & -111);