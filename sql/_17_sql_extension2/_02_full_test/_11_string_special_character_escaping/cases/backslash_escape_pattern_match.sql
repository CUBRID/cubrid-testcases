--test backslash escape in pattern match


create table ptmatch(col1 varchar(30));

insert into ptmatch values ('hellothere'), ('hahahellome'), ('hello%%%%%dd'), ('aahello_aaabbb');


select * from ptmatch where col1 like 'hello\%';
select * from ptmatch where col1 like 'hello%';
select * from ptmatch where col1 like '%hello\%';
select * from ptmatch where col1 like 'hello%';
select * from ptmatch where col1 like '%hello\_%';
select * from ptmatch where col1 like '%hello_%';


drop table ptmatch;
