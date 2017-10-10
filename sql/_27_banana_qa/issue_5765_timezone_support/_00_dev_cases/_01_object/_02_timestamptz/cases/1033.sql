--[er]test timestamp with TO_TIMESTAMP_TZ('00:00:00 AM 1/1/2039').
select TO_TIMESTAMP_TZ('00:00:00 AM 1/1/2039') from db_root;
