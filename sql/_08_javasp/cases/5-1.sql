--+ holdcas on;

CREATE TABLE employees (
   store_id INT NOT NULL
)
PARTITION BY RANGE (store_id + 100) (
PARTITION p0 VALUES LESS THAN (105),
PARTITION p1 VALUES LESS THAN (200),
PARTITION p3 VALUES LESS THAN MAXVALUE
);

insert into employees values(1);
insert into employees values(105);
insert into employees values(106);

select count(*) from employees;
select * from employees order by 1;
$integer,$105;
select * from employees where store_id = ? order by 1;
$integer,$1000005;
select * from employees where store_id < ? order by 1;

create class x ( id int);
insert into  x values(10);
select * from x order by 1;

drop employees;
drop x;

commit;


--+ holdcas off;

