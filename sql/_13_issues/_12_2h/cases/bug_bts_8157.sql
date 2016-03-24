
create serial s1;
select s1.nextval;
select s1.nextval;
alter serial s1 start with 10;
select s1.nextval;


drop serial s1;
create serial s1;
select s1.nextval;
select started from db_serial;
alter serial s1 start with 10;
select started from db_serial;
select s1.nextval;
select started from db_serial;
select s1.nextval;

drop serial s1;
create serial s1 cache 5;
select s1.nextval;
select s1.nextval;
select s1.nextval;
alter serial s1 start with 10;
select s1.nextval;
drop serial s1;

create serial s1 start with -1000 increment by 1 maxvalue 1000;
select s1.nextval;
select s1.nextval;
select s1.nextval;
alter serial s1 start with 10;
drop serial s1;