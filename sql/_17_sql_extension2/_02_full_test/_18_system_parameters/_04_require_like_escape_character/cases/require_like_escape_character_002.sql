--+ holdcas on;
--test backslash escape in pattern match

set system parameters 'no_backslash_escapes=no';
set system parameters 'require_like_escape_character=yes';

create table ptmatch(col1 varchar(30));

insert into ptmatch values ('hellothere'), ('hahahellome'), ('hello%%%%%dd'), ('aahello_aaabbb');


select * from ptmatch where col1 like 'hello\%';
select * from ptmatch where col1 like 'hello%' order by col1 desc;
select * from ptmatch where col1 like '%hello\%';
select * from ptmatch where col1 like 'hello%' order by col1 desc;
select * from ptmatch where col1 like '%hello\_%';
select * from ptmatch where col1 like '%hello_%' order by col1 desc;


drop table ptmatch;


set system parameters 'require_like_escape_character=no';
set system parameters 'no_backslash_escapes=yes';
commit;
--+ holdcas off;
