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
deallocate prepare st;

prepare st from 'select a, case c  when ? then ? else ? end from foo order by 1;';
execute st using  1,2,3;
deallocate prepare st;

prepare st from 'select a, case  when (b>5 and c>8 or d<? and a in (select a from foo))  then ? else ?  end from foo order by 1;';
execute st using  1,2,3;
deallocate prepare st;

prepare st from 'select a, case  when (a>5 and b>8 or c<9 and exists (select * from foo))  then ? else ?  end from foo order by 1;';
execute st using  1,2;
deallocate prepare st;

prepare st from 'select a, case  when (b>5 and c>8 or d<9 and e between ? and ?)  then ? else ?  end from foo order by 1;';
execute st using  1,2,3,4;
deallocate prepare st;

prepare st from 'select  case when a=? then NULL else ? end from foo order by 1;';
execute st using  1,2;
deallocate prepare st;


--nest case in when,then, else
prepare st from 'select  case when case when ?<>0 then ? else ? end<>0 then NULL else ? end from foo;';
execute st using  1,2,3,4;
deallocate prepare st;

prepare st from 'select  case when ?<>0 then case when ?<>0 then ? else ? end else ? end from foo;';
execute st using  1,2,3,4,5;
deallocate prepare st;

prepare st from 'select  case when ?<>0 then ? else case when ?<>0 then ? else ? end end from foo;';
execute st using  1,2,3,4,5;
deallocate prepare st;


--NULL VALUE
prepare st from 'select a, case  when NULL<>0 then ? else ? end from foo order by 1;';
execute st using  1,2;
deallocate prepare st;

prepare st from 'select a, case  when ?<>0 then NULL else ? end from foo order by 1;';
execute st using  1,2;
deallocate prepare st;

prepare st from 'select a, case  when ?<>0 then ? else NULL end from foo order by 1;';
execute st using  1,2;
deallocate prepare st;


--not abey the syntax,expected wrong
prepare st from 'select a, case  then ? else ? end from foo;';
deallocate prepare st;
prepare st from 'select a, case  when  then ? else ? end from foo;';
deallocate prepare st;
prepare st from 'select a, case  when a=? then  else ? end from foo;';
deallocate prepare st;
prepare st from 'select a, case  when a=? then ? else  end from foo;';
deallocate prepare st;
prepare st from 'select a, case  when a=? then ? else ? else ? end from foo;';    
deallocate prepare st;
prepare st from 'select a, case  when a=? then ? else ? end else ? end from foo;';
deallocate prepare st;

drop table foo;
