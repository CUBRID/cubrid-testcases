--test to_time function with statements insert, select
create class func_04 ( a time );

insert into func_04 values (to_time('10:00:00 AM')); 

select * from func_04 where a='10:00:00 AM';
select * from func_04 where a=to_time('10:00:00 AM');

drop class func_04;