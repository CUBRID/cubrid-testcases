-- This testcase use modified Oracle samples. See below for the license:
-- Copyright (c) 2015 Oracle
-- Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.

create class bonuses (emp_id int, bonus int)
	partition by range (bonus) (partition p1 values less than (101), partition p2 values less than (146), partition p3 values less than maxvalue);
create index i_bonuses_emp_id on bonuses (emp_id);

insert into bonuses values (153,100);
insert into bonuses values (154,100);
insert into bonuses values (155,100);
insert into bonuses values (156,100);
insert into bonuses values (157,100);
insert into bonuses values (158,100);
insert into bonuses values (159,100);
insert into bonuses values (160,100);
insert into bonuses values (161,100);
insert into bonuses values (162,100);
insert into bonuses values (163,100);

create class emp (emp_id int, salary int);
create index i_emp_emp_id on emp (emp_id);
create index i_emp_emp_id_salary on emp (emp_id, salary);

insert into emp values (153,200);
insert into emp values (154,500);
insert into emp values (155,550);
insert into emp values (156,350);
insert into emp values (157,600);
insert into emp values (158,450);
insert into emp values (159,550);
insert into emp values (160,650);
insert into emp values (161,700);
insert into emp values (162,520);
insert into emp values (163,675);
insert into emp values (201,400);
insert into emp values (202,450);
insert into emp values (203,300);

merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;

select * from bonuses__p__p1 order by 1;
select * from bonuses__p__p2 order by 1;
select * from bonuses__p__p3 order by 1;

drop emp;
drop bonuses;
