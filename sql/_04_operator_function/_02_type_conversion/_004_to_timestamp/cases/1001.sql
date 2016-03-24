-- retrieve by function of to_timestamp using parameter of string,char,varchar field and using format_argument of 'YYYY MM DD HH ":"  MI ":" SS'   ,'YYYY MM DD HH12 ":"  MI ":" SS','YYYY MM DD HH24 ":"  MI ":" SS','yyyy mm dd hh24 ":"  mi ":" ss','YYYY MM DD HH24 ":"  MI ":" SS','yyyy mm dd hh24 ":"  mi ":" ss' and using 'between' keyword

create class func_04 ( a string, b char(22), c varchar(22), d int );
insert into func_04 values (null, null,null,1);
insert into func_04 values ('01:01:01 am 01/01/2000','01:01:01 am 01/01/2000','01:01:01 am 01/01/2000',1);
insert into func_04 values ('01:01 am 01/01/2000','01:01 am 01/01/2000','01:01 am 01/01/2000',1);
insert into func_04 values ('01:01:01 pm 01/01/2000','01:01:01 pm 01/01/2000','01:01:01 pm 01/01/2000',1);
insert into func_04 values ('01:01:01 01/01/2000','01:01:01 01/01/2000','01:01:01 01/01/2000',1);
insert into func_04 values ('01:01 01/01/2000','01:01 01/01/2000','01:01 01/01/2000',1);
insert into func_04 values ('21:01 01/01/2000','21:01 01/01/2000','21:01 01/01/2000',1);



select a,to_timestamp(a), b,to_timestamp(b) from func_04 where d = 1 order by 1,3;	
select c,to_timestamp(c) from func_04 where d = 1 order by 1;	
select a,to_timestamp(a) from func_04 where d=1 and to_timestamp(a) between to_timestamp(a) and to_timestamp(a) order by 1;	
select to_timestamp('1997 12 31 1:12:13','YYYY MM DD HH ":"  MI ":" SS') from func_04	;
select to_timestamp('1997 12 31 1:12:13','YYYY MM DD HH12 ":"  MI ":" SS') from func_04	;
select to_timestamp('1997 12 31 1:12:13','YYYY MM DD HH24 ":"  MI ":" SS') from func_04	;
select to_timestamp('1997 12 31 1:12:13','yyyy mm dd hh24 ":"  mi ":" ss') from func_04	;
select to_timestamp('1997 12 31 21:12:13','YYYY MM DD HH24 ":"  MI ":" SS') from func_04	;
select to_timestamp('1997 12 31 21:12:13','yyyy mm dd hh24 ":"  mi ":" ss') from func_04	;
select to_timestamp(null) from func_04;
 
drop class func_04;