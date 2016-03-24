--[er]test nvl, nvl2 with int and other type
select nvl(n'sss', 10) from db_root;
select nvl2(n'sss', 10, 20) from db_root;

select nvl('sss', 10) from db_root;
select nvl2('sss', 10, 20) from db_root;

select nvl({1,2}, 10) from db_root;
select nvl2({1,2}, 10, 20) from db_root;

select nvl(date'2/2/2002', 10) from db_root;
select nvl2(date'2/2/2002', 10, 20) from db_root;

select nvl(time'3:3:3 am', 10) from db_root;
select nvl2(time'3:3:3 am', 10, 20) from db_root;

select nvl(timestamp'2/2/2001 2:2:2 am', 10) from db_root;
select nvl2(timestamp'2/2/2001 2:2:2 am', 10, 20) from db_root;

select nvl(b'001001010', 10) from db_root;
select nvl2(b'001001010', 10, 20) from db_root;
