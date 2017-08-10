---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- name change

-- name collision : with a normal attribute 
create class c1 class attribute (c_i integer)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i i integer;

select class c1.i, i from c1 order by 1,2;

show columns in c1;

drop class c1;

-- name collision : with a shared attribute 
create class c1 class attribute (c_i integer)  ( i integer shared -1) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i i integer;

select class c1.i, i from c1 order by 1,2;

show columns in c1;

drop class c1;


-- name collision : with another class attribute 
create class c1 class attribute (c_i integer, i integer)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i i integer;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;
