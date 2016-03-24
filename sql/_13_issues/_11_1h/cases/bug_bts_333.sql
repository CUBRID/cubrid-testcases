
create class xoo ( a int, b int);

insert into xoo values(1,1);
insert into xoo values(2,2);
insert into xoo values(3,3);
insert into xoo values(4,4);
insert into xoo values(5,5);


prepare st from 'select a from xoo where a > 0 order by 1 desc for orderby_num() between (?*(?))  and ? * ?' execute st using 1, '2', 1, '4' drop prepare st;
select  a from xoo where a > 0 order by 1 desc for orderby_num() between (1*(2))  and 1 * 4;
prepare st from 'select a from xoo where a > 0 order by 1 desc for orderby_num() between (?*(?))  and ? * ?' execute st using 1, 2, 1, 4 drop prepare st;

drop table xoo;


