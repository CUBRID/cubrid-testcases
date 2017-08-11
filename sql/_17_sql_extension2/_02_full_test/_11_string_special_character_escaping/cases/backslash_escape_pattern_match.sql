--test backslash escape in pattern match


create table ptmatch(col1 varchar(30));

insert into ptmatch values ('hellothere'), ('hahahellome'), ('hello%%%%%dd'), ('aahello_aaabbb');


select * from ptmatch where col1 like 'hello\%' order by col1 ; 
select * from ptmatch where col1 like 'hello%' order by col1 ; 
select * from ptmatch where col1 like '%hello\%' order by col1 ; 
select * from ptmatch where col1 like 'hello%' order by col1 ; 
select * from ptmatch where col1 like '%hello\_%' order by col1 ; 
select * from ptmatch where col1 like '%hello_%' order by col1 ; 


drop table ptmatch;
