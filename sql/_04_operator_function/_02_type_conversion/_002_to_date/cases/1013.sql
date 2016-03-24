--test to_date with nchar
select to_date(n'20060107', 'YYYYMMDD') from db_root;
select to_date(n'20060107', n'YYYYMMDD') from db_root;
select to_date('20060107', 'YYYYMMDD') from db_root order by 1;