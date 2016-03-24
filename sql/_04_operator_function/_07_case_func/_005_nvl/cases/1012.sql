--test nvl, nvl2 with date type
select nvl(null, date'2/2/2002') from db_root;
select nvl2(null, date'2/2/2002', date'2/3/2002') from db_root;

select nvl(date'2/2/2002', date'2/2/2002') from db_root;
select nvl2(date'2/2/2002', date'2/2/2002', date'2/3/2002') from db_root;

select nvl('2/2/2002', date'2/2/2002') from db_root;
select nvl2('2/2/2002', date'2/2/2002', date'2/3/2002') from db_root;
