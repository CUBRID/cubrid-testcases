--test translate function with empty character ''
select translate('','','') from db_root;
select translate('abc', '','d') from db_root;
select translate('', 'b', '') from db_root order by 1;