--+ holdcas on;
--test backslash escape in pattern match

set system parameters 'require_like_escape_character=yes';
set system parameters 'no_backslash_escapes=yes';

create table ptmatch(col1 varchar(30));

insert into ptmatch values ('hellothere'), ('hahahellome'), ('hello%%%%%dd'), ('aahello_aaabbb');


select * from ptmatch where col1 like 'hello\%' order by 1;
select * from ptmatch where col1 like 'hello%' order by 1;
select * from ptmatch where col1 like '%hello\%' order by 1;
select * from ptmatch where col1 like 'hello%' order by 1;
select * from ptmatch where col1 like '%hello\_%' order by 1;
select * from ptmatch where col1 like '%hello\_%' escape '\' order by 1;
select * from ptmatch where col1 like '%hello_%' order by 1;


drop table ptmatch;


set system parameters 'require_like_escape_character=no';
commit;
--+ holdcas off;


