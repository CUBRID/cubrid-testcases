--test multiple rows select using select queries and set operator with char type
create class ttt ( t char(1));
create class tbl ( t char(1));
insert into ttt values('a');
insert into tbl values ('b');
insert into tbl values('a');
select set { t, 'a' } from ttt order by 1;
select *  from tbl order by 1;
select set{t,'a'} from tbl order by 1;


drop class ttt;
drop class tbl;
