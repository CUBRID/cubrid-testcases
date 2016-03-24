--test drandom with type date,time, timestamp and operators +,-
select if(isnull(date'8/8/2008'+drandom()),'nok','ok') from db_root;
select if(isnull(date'8/8/2008'-drandom()),'nok','ok') from db_root;

select if(isnull(time'8:8:8 am'+drandom()),'nok','ok') from db_root;
select if(isnull(time'8:8:8 am'-drandom()),'nok','ok') from db_root;

select if(isnull(timestamp'8/8/2008 8:8:8 am'+drandom()),'nok','ok') from db_root;
select if(isnull(timestamp'8/8/2008 8:8:8 am'-drandom()),'nok','ok') from db_root;
