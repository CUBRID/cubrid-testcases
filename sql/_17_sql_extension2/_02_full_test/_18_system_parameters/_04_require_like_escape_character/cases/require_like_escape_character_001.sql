--+ holdcas on;
--test backslash escape in pattern match

set system parameters 'require_like_escape_character=no';

create table ptmatch(col1 varchar(30));

insert into ptmatch values ('hellothere'), ('hahahellome'), ('hello%%%%%dd'), ('aahello_aaabbb');


select * from ptmatch where col1 like 'hello\%' order by col1 desc;
select * from ptmatch where col1 like 'hello%' order by col1 desc;
select * from ptmatch where col1 like '%hello\%' order by col1 desc;
select * from ptmatch where col1 like 'hello%' order by col1 desc;
select * from ptmatch where col1 like '%hello\_%' order by col1 desc;
select * from ptmatch where col1 like '%hello_%' order by col1 desc;


drop table ptmatch;
commit;
--+ holdcas off;
