--[er]test nvl, nvl2 with time and other type
select nvl(n'sss', time'2:2:2 am') from db_root;
select nvl2(n'sss', time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl('sss', time'2:2:2 am') from db_root;
select nvl2('sss', time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl({1,2}, time'2:2:2 am') from db_root;
select nvl2({1,2}, time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl(1, time'2:2:2 am') from db_root;
select nvl2(1, time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl(1.11, time'2:2:2 am') from db_root;
select nvl2(1.11, time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl(date'3/3/2003', time'2:2:2 am') from db_root;
select nvl2(date'3/3/2003', time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl(timestamp'2/2/2001 2:2:2 am', time'2:2:2 am') from db_root;
select nvl2(timestamp'2/2/2001 2:2:2 am', time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl(b'001010', time'2:2:2 am') from db_root;
select nvl2(b'001010', time'2:2:2 am', time'2:3:2 am') from db_root;
