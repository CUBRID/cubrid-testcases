--[er]test '05/26/2008', '14:24:00', '14:24:00 05/26/2008' with operators +, *, /
select 'It is '+date'05/26/2008' from db_root;
select 'It is '+time'14:24:00' from db_root;
select 'It is '+timestamp'14:24:00 05/26/2008' from db_root;

select date'05/26/2008'*2 from db_root;
select date'05/26/2008'/2 from db_root;

select time'14:24:00'*2 from db_root;
select time'14:24:00'/2 from db_root;

select timestamp'14:24:00 05/26/2008'*2 from db_root;
select timestamp'14:24:00 05/26/2008'/2 from db_root;
