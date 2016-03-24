--test '05/26/2008', '14:24:00', '14:24:00 05/26/2008' with operators +,-,*,/
select date'05/26/2008'-date'05/26/2008' from db_root;
select date'05/26/2008'+date'05/26/2008' from db_root;
select date'05/26/2008'*date'05/26/2008' from db_root;
select date'05/26/2008'/date'05/26/2008' from db_root;

select time'14:24:00'-time'14:24:00' from db_root;
select time'14:24:00'+time'14:24:00' from db_root;
select time'14:24:00'*time'14:24:00' from db_root;
select time'14:24:00'/time'14:24:00' from db_root;

select timestamp'14:24:00 05/26/2008'-timestamp'14:24:00 05/26/2008' from db_root;
select timestamp'14:24:00 05/26/2008'+timestamp'14:24:00 05/26/2008' from db_root;
select timestamp'14:24:00 05/26/2008'*timestamp'14:24:00 05/26/2008' from db_root;
select timestamp'14:24:00 05/26/2008'/timestamp'14:24:00 05/26/2008' from db_root;
