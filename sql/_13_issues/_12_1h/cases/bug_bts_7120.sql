create serial s1 start with 5 increment by 6;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's1';
alter serial s1 cache 5;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's1';

create serial s2 start with 5 increment by 6 cache 5;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's2';
alter serial s2 nocache; 
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's2';


create serial s3 start with 3 increment by 2;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's3';
select s3.next_value;
select s3.next_value;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's3';
alter serial s3 cache 7;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's3';
select s3.next_value;
select s3.next_value;
select s3.next_value;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's3';
alter serial s3 nocache; 
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's3';
select s3.next_value;
select name,current_val,increment_val,max_val,min_val,started,cached_num from db_serial where name = 's3';

drop serial s1;
drop serial s2;
drop serial s3;