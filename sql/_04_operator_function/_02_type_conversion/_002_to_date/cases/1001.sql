--[er]Test function of to_date using invalid keyword


select to_date('2006-01-02 MONDAY',DAY,'En_US') from db_root order by 1;
