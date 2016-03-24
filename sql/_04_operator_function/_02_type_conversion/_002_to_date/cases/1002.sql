-- retrieve by function of to_date using parameter of string,char,varchar field and using format_argument of 'YYYY MM DD' ,'yyyy mm dd',YYYYMMDD','yyyymmdd', 'ddmmyyyy' 


create class func_04 ( a string, b char(10), c varchar(10), d int);
insert into func_04 values ( null, null, null ,null);
insert into func_04 values ( '19870101', '19870101', '19870101', 1);
insert into func_04 values ( '20001212', '20001212', '20001212', 1);
insert into func_04 values ( '29991231', '29991231', '29991231', 1);
insert into func_04 values ( '01011987', '01011987', '01011987', 2);
insert into func_04 values ( '01012999', '01012999', '01012999', 2);
insert into func_04 values ( '2000/12/12', '2000/12/12', '2000/12/12', 3);
insert into func_04 values ( '01/01/2999', '01/01/2999', '01/01/2999', 4);
insert into func_04 values ( '11111111', '11111111', '11111111', 5);



select a, to_date(a), b,to_date(b), c,to_date(c) from  func_04 where d=4	;
select a, to_date( a, 'YYYY MM DD' ), to_date(a,'yyyy mm dd') from func_04 where d=1	;
select a, to_date( a, 'YYYYMMDD' ), to_date(a,'yyyymmdd') from func_04 where d=1	;
select b, to_date( b, 'YYYY MM DD' ), to_date(b,'yyyy mm dd') from func_04 where d=1	;
select b, to_date( b, 'YYYYMMDD' ), to_date(b,'yyyymmdd') from func_04 where d=1	;
select c, to_date( c, 'YYYY MM DD' ), to_date(c,'yyyy mm dd') from func_04 where d=1	;
select c, to_date( c, 'YYYYMMDD' ), to_date(c,'yyyymmdd') from func_04 where d=1	;
select c, to_date( c, 'YYYYMMDD' ), to_date(c,'yyyymmdd') from func_04 where a is null	;
select  to_date(null ,null  ) from func_04 	;
select  to_date(' 10000101' ,' yyyymmdd'  ) from func_04	;
select c, to_date( a, 'yyyyddmm' ) from func_04  where d=5	;
select c, to_date( a, 'ddmmyyyy' ) from func_04  where d=5	;
select to_date(null) from func_04;

drop class func_04;