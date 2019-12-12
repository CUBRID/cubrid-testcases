
create table row_number_test (a int, b varchar(20));

insert into row_number_test values (22, 'twenty two');
insert into row_number_test values ( 1, 'one');
insert into row_number_test values (13, 'thirteen');
insert into row_number_test values ( 5, 'five');
insert into row_number_test values ( 4, 'four');

select a, b, row_number() over (order by b) from row_number_test order by 2;
select a, b, row_number() over (order by b) from row_number_test order by a;

drop row_number_test;

create table row_number_test_2 (a int, b varchar(20), c char(1));

insert into row_number_test_2 values (22, 'twenty two',   '*');
insert into row_number_test_2 values ( 1, 'one',          '+');
insert into row_number_test_2 values (13, 'thirteen',     '*');
insert into row_number_test_2 values ( 5, 'five',         '+');
insert into row_number_test_2 values ( 4, 'four',         '+');

select a, b, row_number() over (partition by c order by b) from row_number_test_2 order by c, 2;
select a, b, row_number() over (partition by c order by b) from row_number_test_2 order by a;

drop row_number_test_2;

create table some_table (a int, b varchar(10));

insert into some_table values (5, '*');
insert into some_table values (2, '*');
insert into some_table values (5, '*');
insert into some_table values (3, '*');
insert into some_table values (5, '*');
insert into some_table values (3, '*');
insert into some_table values (2, '*');

insert into some_table values (4, '#');
insert into some_table values (8, '#');
insert into some_table values (4, '#');
insert into some_table values (8, '#');
insert into some_table values (4, '#');

select dense_rank() over (partition by b order by a) dr,
             rank() over (partition by b order by a) rk,
       row_number() over (partition by b order by a) rn,
              a,b
from some_table order by 5, 4;

drop some_table;

create table sum_example (dt date, xy int);

insert into sum_example values (to_date('27.08.1970','DD.MM.YYYY'),4);
insert into sum_example values (to_date('02.09.1970','DD.MM.YYYY'),1);
insert into sum_example values (to_date('09.09.1970','DD.MM.YYYY'),5);
insert into sum_example values (to_date('26.08.1970','DD.MM.YYYY'),3);
insert into sum_example values (to_date('28.08.1970','DD.MM.YYYY'),4);
insert into sum_example values (to_date('26.08.1970','DD.MM.YYYY'),6);
insert into sum_example values (to_date('29.08.1970','DD.MM.YYYY'),9);
insert into sum_example values (to_date('30.08.1970','DD.MM.YYYY'),2);
insert into sum_example values (to_date('12.09.1970','DD.MM.YYYY'),7);
insert into sum_example values (to_date('23.08.1970','DD.MM.YYYY'),2);
insert into sum_example values (to_date('27.08.1970','DD.MM.YYYY'),5);
insert into sum_example values (to_date('09.09.1970','DD.MM.YYYY'),9);
insert into sum_example values (to_date('01.09.1970','DD.MM.YYYY'),3);
insert into sum_example values (to_date('07.09.1970','DD.MM.YYYY'),1);
insert into sum_example values (to_date('12.09.1970','DD.MM.YYYY'),4);
insert into sum_example values (to_date('03.09.1970','DD.MM.YYYY'),5);
insert into sum_example values (to_date('03.09.1970','DD.MM.YYYY'),8);
insert into sum_example values (to_date('07.09.1970','DD.MM.YYYY'),7);
insert into sum_example values (to_date('04.09.1970','DD.MM.YYYY'),8);
insert into sum_example values (to_date('09.09.1970','DD.MM.YYYY'),1);
insert into sum_example values (to_date('29.08.1970','DD.MM.YYYY'),3);
insert into sum_example values (to_date('30.08.1970','DD.MM.YYYY'),7);
insert into sum_example values (to_date('24.08.1970','DD.MM.YYYY'),7);
insert into sum_example values (to_date('07.09.1970','DD.MM.YYYY'),9);
insert into sum_example values (to_date('26.08.1970','DD.MM.YYYY'),2);
insert into sum_example values (to_date('09.09.1970','DD.MM.YYYY'),8);

select dt, sum(xy) over (partition by substr(dt,2) order by dt) s, xy from sum_example order by 1,3;

drop sum_example;
