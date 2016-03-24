--[er]test nvl, nvl2 with date and other type
select nvl(n'sss', date'2/2/2002') from db_root;
select nvl2(n'sss', date'2/2/2002', date'2/3/2002') from db_root;

select nvl('sss', date'2/2/2002') from db_root;
select nvl2('sss', date'2/2/2002', date'2/3/2002') from db_root;

select nvl({1,2}, date'2/2/2002') from db_root;
select nvl2({1,2}, date'2/2/2002', date'2/3/2002') from db_root;

select nvl(1, date'2/2/2002') from db_root;
select nvl2(1, date'2/2/2002', date'2/3/2002') from db_root;

select nvl(1.11, date'2/2/2002') from db_root;
select nvl2(1.11, date'2/2/2002', date'2/3/2002') from db_root;

select nvl(time'3:3:3 am', date'2/2/2002') from db_root;
select nvl2(time'3:3:3 am', date'2/2/2002', date'2/3/2002') from db_root;

select nvl(timestamp'2/2/2001 2:2:2 am', date'2/2/2002') from db_root;
select nvl2(timestamp'2/2/2001 2:2:2 am', date'2/2/2002', date'2/3/2002') from db_root;

select nvl(b'001010', date'2/2/2002') from db_root;
select nvl2(b'001010', date'2/2/2002', date'2/3/2002') from db_root;
