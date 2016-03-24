--[er]tests months_between function using bit type as its operands

select months_between(date'11/10/2000', b'000100') from db_root;
select months_between(b'000100', date'11/10/2000') from db_root;
select months_between(b'000100', b'000100') from db_root;
