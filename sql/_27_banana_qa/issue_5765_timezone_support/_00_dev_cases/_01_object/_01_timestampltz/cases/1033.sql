--[er]test timestamp with TO_TIMESTAMP('00:00:00 AM 1/1/2039').
select TO_TIMESTAMP('00:00:00 AM 1/1/2039') from db_root;