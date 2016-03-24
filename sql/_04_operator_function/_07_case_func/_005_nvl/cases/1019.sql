--[er]test nvl, nvl2 with date and other type
select nvl(n'sss', b'00101010') from db_root;
select nvl2(n'sss', b'00101010', b'011101010') from db_root;

select nvl('sss', b'00101010') from db_root;
select nvl2('sss', b'00101010', b'011101010') from db_root;

select nvl({1,2}, b'00101010') from db_root;
select nvl2({1,2}, b'00101010', b'011101010') from db_root;

select nvl(1, b'00101010') from db_root;
select nvl2(1, b'00101010', b'011101010') from db_root;

select nvl(1.11, b'00101010') from db_root;
select nvl2(1.11, b'00101010', b'011101010') from db_root;

select nvl(time'3:3:3 am', b'00101010') from db_root;
select nvl2(time'3:3:3 am', b'00101010', b'011101010') from db_root;

select nvl(timestamp'2/2/2001 2:2:2 am', b'00101010') from db_root;
select nvl2(timestamp'2/2/2001 2:2:2 am', b'00101010', b'011101010') from db_root;

select nvl(date'2/2/2002', b'00101010') from db_root;
select nvl2(date'2/2/2002', b'00101010', b'011101010') from db_root;
