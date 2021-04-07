--+ holdcas on;

create table foo (id int not null, treeid int, age int, text char(8192));

insert into foo values(2, 0, null, 'C');

insert into foo values(3, 1, 6, 'CBBA');

insert into foo values(1, 2, 2, 'DBB');

create index i_foo_id_text on foo(id, text);
create index i_foo_id_treeid_text on foo(id, treeid, text);
create index i_foo_id_treeid on foo(id, treeid);

set optimization level 513;

select /*+ RECOMPILE */ id, age from foo where id > 0;

set optimization level 1;
drop foo;
commit;
--+ holdcas off;


