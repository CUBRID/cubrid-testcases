set system parameters 'create_table_reuseoid=no';
autocommit off;
drop if exists bar,foo; 

CREATE TABLE foo ( id INT PRIMARY KEY, phone VARCHAR(10));
insert into foo values (1, '111-1111');

CREATE TABLE bar ( ID INT, f_col foo );
insert into bar values (1, NULL);
commit;

alter table bar add CONSTRAINT fk_id FOREIGN KEY(id) REFERENCES foo (id) ON DELETE CASCADE ;

select f_col from bar;

rollback;

select f_col from bar;

select f_col from bar;

drop table bar,foo; 
commit;

drop if exists bar,foo; 

CREATE TABLE foo ( id bigint primary key, phone VARCHAR(10) unique);
insert into foo values (1, '111-1111');

CREATE TABLE bar ( ID bigint, f_col foo );
insert into bar values (1, NULL);
commit;

alter table bar add CONSTRAINT fk_id FOREIGN KEY(id) REFERENCES foo (id) ON DELETE CASCADE;

select f_col from bar;

rollback;

select f_col from bar;

select f_col from bar;

drop table bar,foo; 

commit;

autocommit on;
set system parameters 'create_table_reuseoid=yes';
