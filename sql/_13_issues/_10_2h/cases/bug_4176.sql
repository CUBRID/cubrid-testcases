create table foo (id varchar(20), parent_id varchar(20),use_yn char(1));
insert into foo values('AFAC000002', 'AFA','Y');
insert into foo values('AFAC000018', 'AFAC000002','Y');
insert into foo values('AFAC000019', 'AFAC000002','Y');
insert into foo values('AFAC000020', 'AFAC000002','Y');
insert into foo values('AFAC000022', 'AFAC000002','Y');

select id,parent_id,use_yn
from foo
start with id='AFAC000002'
connect by nocycle prior id=parent_id;

drop table foo;
