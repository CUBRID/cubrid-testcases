--test '05/26/2008', '14:24:00', '14:24:00 05/26/2008' with set definition
select {date'05/26/2008', time'14:24:00', timestamp'14:24:00 05/26/2008'} from db_root order by 1;