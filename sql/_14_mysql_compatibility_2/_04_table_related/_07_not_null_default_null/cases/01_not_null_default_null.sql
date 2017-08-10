-- should throw error
create table t (i int not null default null);
create table t (i int default null not null);
create table t (i int not null, j int default null, k int not null default null);


create table t;
alter table t add column i int;
alter table t add column j int not null;
alter table t add column k int default null;
alter table t add column l int not null default null;
alter table t add column l int default null not null;
alter table t add column l int default null not null default 1;
alter table t add column l int not null default 1 default null;
-- finally!
alter table t add column l int default null;


alter table t change column l l int not null default null;
alter table t change column l l int default null not null;


-- this is valid because change column's must specify all the attributes at once. They are not additive.
-- It's sort of a redefinition: forget everything you know about this column, here are all its new properties.
alter table t change column i i int not null, change column i i int default null;

alter table t change column i i int not null, change column i i int default null not null;


alter table t drop column l;
alter table t add column l int, change column l l int not null default null;

alter table t rename to u, add column valid int, add column invalid int not null default null, rename to w;

alter table t add column l int not null default 0;
alter table t add column m string not null default 'vlad';
alter table t add column d date not null default '2011-09-10';


drop table t;