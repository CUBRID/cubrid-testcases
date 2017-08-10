set timezone 'Asia/Seoul';

select trunc(timestampltz'12:00:00 AM 01/07/1990 +9:00');       
select trunc(timestampltz'12:00:00 AM 01/07/1990 +9:00','dd'); 

select trunc(timestamptz'12:00:00 AM 01/07/1990 +9:00');      
select trunc(timestamptz'12:00:00 AM 01/07/1990 +9:00','dd');

select trunc(datetimeltz'12:00:00 AM 01/07/1990 +9:00');  
select trunc(datetimeltz'12:00:00 AM 01/07/1990 +9:00','dd'); 

select trunc(datetimetz'12:00:00 AM 01/07/1990 +9:00');       
select trunc(datetimetz'12:00:00 AM 01/07/1990 +9:00','dd'); 

drop table if exists t;
create table t(tsltz timestampltz);
insert into t values('12:00:00 AM 01/07/1990 +9:00');
select trunc(tsltz) from t;
drop table t;
