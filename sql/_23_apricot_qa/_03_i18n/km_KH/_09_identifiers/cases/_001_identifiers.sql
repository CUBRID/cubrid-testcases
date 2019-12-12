--+ holdcas on;
set names utf8;
-- table name
create table កខណតថ(s1 char(200));

-- column
alter table កខណតថ add column i_បី1 int;

-- trigger
create trigger ប្រាំមូយ before update on កខណតថ execute update កខណតថ set i_បី1 = 0;

-- constraint
alter table កខណតថ add constraint i_បី1_i_u unique index (i_បី1);

desc កខណតថ;
show index in កខណតថ;

drop trigger ប្រាំមូយ;

alter table កខណតថ drop constraint i_បី1_i_u;

alter table កខណតថ drop column i_បី1;

drop table កខណតថ;



create table តថ (បី int);

alter table តថ add column បី1 int;

create trigger ប្រាំមូយ before update on តថ execute update តថ set បី = 0;

alter table តថ add constraint ប្រាំបី1 unique index (បី);
alter table តថ add constraint ប្រាំបី2 unique index (បី1);

desc តថ;
show index in តថ;

drop trigger ប្រាំមូយ;

alter table តថ drop constraint ប្រាំបី1;
alter table តថ drop constraint ប្រាំបី2;

alter table តថ drop column បី;
alter table តថ drop column បី1;
drop table តថ;
set names iso88591;
commit;
--+ holdcas off;

