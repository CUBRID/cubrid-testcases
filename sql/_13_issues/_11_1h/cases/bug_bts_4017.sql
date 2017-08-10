--+ holdcas on;

set system parameters 'compat_mode=mysql';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\\%' escape '\\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;

set system parameters 'compat_mode=cubrid';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\%' escape '\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;
--

set system parameters 'compat_mode=mysql';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\\%' escape '\\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;

set system parameters 'compat_mode=cubrid';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\%' escape '\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;
--

set system parameters 'compat_mode=mysql';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\\%' escape '\\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;

set system parameters 'compat_mode=cubrid';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\%' escape '\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;
--

set system parameters 'compat_mode=mysql';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\\%' escape '\\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;

set system parameters 'compat_mode=cubrid';
create class dml_0001 (b varchar(10));
create view vdml_0001 (b) as select b from dml_0001 where b like 'b%aa\%';
create view vdml_0002 (b) as select b from dml_0001 where b like 'b%aa\%' escape '\';
insert into dml_0001 values ('bzaa%');
select * from vdml_0001 where b='bzaa%';
select * from vdml_0002 where b='bzaa%';
SELECT * FROM dml_0001 WHERE b LIKE 'bz|a|a|%' ESCAPE '|';
drop view vdml_0001;
drop view vdml_0002;
drop class dml_0001;

commit;

--+ holdcas off;

