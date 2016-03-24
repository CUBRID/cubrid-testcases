-- [er]retrieve by function of to_timestamp using defult format_argument to suit the string whith not is the format 'HH:MI[:SS] [am|pm] MM/DD/YYYY'
create class func_04 ( a string, b char(22), c varchar(22), d int );
insert into func_04 values (null, null,null,1);
insert into func_04 values ('01:01:01 am 01/01/2000','01:01:01 am 01/01/2000','01:01:01 am 01/01/2000',1);
insert into func_04 values ('01:01 am 01/01/2000','01:01 am 01/01/2000','01:01 am 01/01/2000',1);
insert into func_04 values ('01:01:01 pm 01/01/2000','01:01:01 pm 01/01/2000','01:01:01 pm 01/01/2000',1);
insert into func_04 values ('01:01:01 01/01/2000','01:01:01 01/01/2000','01:01:01 01/01/2000',1);
insert into func_04 values ('01:01 01/01/2000','01:01 01/01/2000','01:01 01/01/2000',1);
insert into func_04 values ('21:01 01/01/2000','21:01 01/01/2000','21:01 01/01/2000',1);

 


select a,to_timestamp('aa') from func_04 where d = 1 order by 1;
 
drop class func_04;