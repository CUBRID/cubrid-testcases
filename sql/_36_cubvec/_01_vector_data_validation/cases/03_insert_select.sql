drop table if exists vt;
create table vt (vec VECTOR(3));

insert into vt values ('[1, 2, 3]');
insert into vt values ('[' || '4, 5, 6' || ']');
insert into vt values (concat ('[', '7, 8, 9', ']'));

insert into vt values ([1,2,3]);
insert into vt values '[1,2,3]';
insert into vt values ('[1,2,3]';
insert into vt values '[1,2,3]');

insert into vt values ('[-2e+20, -3e+30, -4e+40]');
insert into vt values ('[2e+20, 3e+30, 4e+40]');
insert into vt values ('[1, 2, nan]');
insert into vt values ('[1, 2, 'abc']');
--insert into vt values ('[1, 2]');
--insert into vt values ('[1, 2, 3, 4]');

select * from vt;

drop table if exists vt;