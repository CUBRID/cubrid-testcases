--[er]test nvl, nvl2 with date and other type
select nvl(n'sss', timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2(n'sss', timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;

select nvl('sss', timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2('sss', timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;

select nvl({1,2}, timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2({1,2}, timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;

select nvl(1, timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2(1, timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;

select nvl(1.11, timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2(1.11, timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;

select nvl(time'3:3:3 am', timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2(time'3:3:3 am', timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;

select nvl(date'2/2/2001', timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2(date'2/2/2001', timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;

select nvl(b'001010', timestamp'2/3/2003 2:2:2 am') from db_root;
select nvl2(b'001010', timestamp'2/3/2003 2:2:2 am', timestamp'2/3/2003 2:3:2 am') from db_root;
