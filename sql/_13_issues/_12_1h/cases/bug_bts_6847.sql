create table foo(a int,b int,c int,d int,e int);
insert into foo values(1,2,3,4,5);
insert into foo values(2,3,4,5,6);
insert into foo values(3,4,5,6,7);
insert into foo values(4,5,6,7,8);
insert into foo values(5,6,7,8,9);
insert into foo values(9,7,6,6,5);
insert into foo values(10,20,30,40,50);

--abey the syntax
prepare st from 'select a, case  when a=? then ? end from foo order by 1;';
execute st using  1,2;

prepare st from 'select a, case c  when ? then ? else ? end from foo order by 1;';
execute st using  1,2,3;

prepare st from 'select a, case  when (b>5 and c>8 or d<? and a in (select a from foo))  then ? else ?  end from foo order by 1;';
execute st using  1,2,3;

prepare st from 'select a, case  when (a>5 and b>8 or c<9 and exists (select * from foo))  then ? else ?  end from foo order by 1;';
execute st using  1,2;

prepare st from 'select a, case  when (b>5 and c>8 or d<9 and e between ? and ?)  then ? else ?  end from foo order by 1;';
execute st using  1,2,3,4;

prepare st from 'select  case when a=? then NULL else ? end from foo order by 1;';
execute st using  1,2;


--nest case in when,then, else
prepare st from 'select  case when case when ?:0<>0 then ?:1 else ?:2 end<>0 then NULL else ?:3 end from foo;';
execute st using  1,2,3,4;

prepare st from 'select  case when ?:0<>0 then case when ?:1<>0 then ?:2 else ?:3 end else ?:4 end from foo;';
execute st using  1,2,3,4,5;

prepare st from 'select  case when ?:0<>0 then ?:1 else case when ?:2<>0 then ?:3 else ?:4 end end from foo;';
execute st using  1,2,3,4,5;


--NULL VALUE
prepare st from 'select a, case  when NULL<>0 then ?:0 else ?:1 end from foo order by 1;';
execute st using  1,2;

prepare st from 'select a, case  when ?:0<>0 then NULL else ?:1 end from foo order by 1;';
execute st using  1,2;

prepare st from 'select a, case  when ?:0<>0 then ?:1 else NULL end from foo order by 1;';
execute st using  1,2;


--not abey the syntax,expected wrong
prepare st from 'select a, case  then ? else ? end from foo;';
prepare st from 'select a, case  when  then ? else ? end from foo;';
prepare st from 'select a, case  when a=? then  else ? end from foo;';
prepare st from 'select a, case  when a=? then ? else  end from foo;';
prepare st from 'select a, case  when a=? then ? else ? else ? end from foo;';    
prepare st from 'select a, case  when a=? then ? else ? end else ? end from foo;';

drop table foo;
