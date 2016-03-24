-- [er]retrieve by function of to_date using defult format_argument to suit the string whith not is the format 'MM/DD/YYYY'


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

select a, to_date(a), b,to_date(b), c,to_date(c) from  func_04 where d=3;



drop class func_04;