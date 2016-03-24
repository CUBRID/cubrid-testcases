-- [er]retrieve by function of to_timestamp using parameter of blank

create class func_04 ( a string, b char(22), c varchar(22), d int );
insert into func_04 values (null, null,null,1);
insert into func_04 values ('01:01:01 am 01/01/2000','01:01:01 am 01/01/2000','01:01:01 am 01/01/2000',1);
insert into func_04 values ('01:01 am 01/01/2000','01:01 am 01/01/2000','01:01 am 01/01/2000',1);
insert into func_04 values ('01:01:01 pm 01/01/2000','01:01:01 pm 01/01/2000','01:01:01 pm 01/01/2000',1);
insert into func_04 values ('01:01:01 01/01/2000','01:01:01 01/01/2000','01:01:01 01/01/2000',1);
insert into func_04 values ('01:01 01/01/2000','01:01 01/01/2000','01:01 01/01/2000',1);
insert into func_04 values ('21:01 01/01/2000','21:01 01/01/2000','21:01 01/01/2000',1);
 
select to_timestamp() from func_04;

 
drop class func_04;