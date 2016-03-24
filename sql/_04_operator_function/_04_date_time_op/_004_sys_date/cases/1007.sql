--[er]test '05/26/2008', '14:24:00', '14:24:00 05/26/2008' using parenthesis 
select '05/26/2008'() from db_root;
select '14:24:00'() from db_root;
select '14:24:00 05/26/2008'() from db_root;
