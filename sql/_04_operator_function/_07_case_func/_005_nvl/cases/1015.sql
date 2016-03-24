--test nvl, nvl2 with time type
select nvl(null, {3,4}) from db_root;
select nvl2(null, {3,4}, {1,2}) from db_root;

select nvl({3,4}, {3,4}) from db_root;
select nvl2({3,4}, {3,4}, {1,2}) from db_root;
