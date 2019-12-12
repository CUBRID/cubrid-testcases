--inet_aton_ntoa_select_001.sql
drop table if exists t;
create table t ( ip varchar(30) , num bigint );
insert into t values ('127.0.0.1', (256*256*256*127 + 1));

select if ((inet_aton (ip) = num), 'yes', 'no') as case1 from t; 
select if ((inet_ntoa (num) = ip), 'yes', 'no') as case2 from t;
select if ((inet_ntoa (inet_aton (ip)) = ip), 'yes', 'no') as case3 from t;
select if ((inet_aton (inet_ntoa (num)) = num), 'yes', 'no') as case4 from t;

drop table if exists t;