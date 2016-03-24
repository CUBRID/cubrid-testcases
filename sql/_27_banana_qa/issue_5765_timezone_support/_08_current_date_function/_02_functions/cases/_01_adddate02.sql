--+ holdcas on;
set timezone '+02:00';
select current_date-adddate(current_date,2);      

set timezone '-02:00';
select current_date-adddate(current_date,2);   


set timezone '+02:00';
select current_datetime-adddate(current_datetime,2);      

set timezone '-02:00';
select current_datetime-adddate(current_datetime,2);

set timezone '+02:00';
select current_timestamp-adddate(current_timestamp,2);

set timezone '-02:00';
select current_timestamp-adddate(current_timestamp,2);


set timezone '+01:00';
select current_timestamp-addtime(current_timestamp,'1:1:1');

set timezone '-01:00';
select current_timestamp-addtime(current_timestamp,'1:1:1');


set timezone '+01:00';
select current_datetime-addtime(current_datetime,'1:1:1');

set timezone '-01:00';
select current_datetime-addtime(current_datetime,'1:1:1');


set timezone '+01:00';
select current_date-addtime(current_date,'1:1:1');

set timezone '-01:00';
select current_date-addtime(current_date,'1:1:1');

set timezone 'Asia/Seoul';

--+ holdcas off;
