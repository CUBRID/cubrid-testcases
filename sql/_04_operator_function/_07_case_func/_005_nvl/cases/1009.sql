--test nvl, nvl2 with numeric type
select nvl(null, 10.11) from db_root;
select nvl2(null, 10.11, 20.11) from db_root;

select nvl(30.11, 10.11) from db_root;
select nvl2(30.11, 10.11, 20.11) from db_root;

select nvl(30, 10.11) from db_root;
select nvl2(30, 10.11, 20.11) from db_root;
