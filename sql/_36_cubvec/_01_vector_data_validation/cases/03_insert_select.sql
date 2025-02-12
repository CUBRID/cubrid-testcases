drop table if exists vt;
create table vt (vec VECTOR(3));

-- Valid insertion of vector (Including concatenation)
insert into vt values ('[1, 2, 3]');
insert into vt values ('[' || '4, 5, 6' || ']');
insert into vt values (concat ('[', '7, 8, 9', ']'));

-- Syntax / Semantic errors from insert
insert into vt values ([1,2,3]);
insert into vt values '[1,2,3]';
insert into vt values ('[1,2,3]';
insert into vt values '[1,2,3]');

-- Invalid vector elements
insert into vt values ('[-2e+20, -3e+30, -4e+40]');
insert into vt values ('[2e+20, 3e+30, 4e+40]');
insert into vt values ('[1, 2, nan]');

-- Invalid size of vector
--insert into vt values ('[1, 2]');
--insert into vt values ('[1, 2, 3, 4]');

select * from vt;

drop table if exists vt;
