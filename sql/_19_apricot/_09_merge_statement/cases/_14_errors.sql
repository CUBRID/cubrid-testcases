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

create class bonuses (emp_id int, bonus int);
create class emp (emp_id int, salary int);

-- syntax
merge into using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses, bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e, emp on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = when not matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;

-- ALL not allowed
merge into all bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using all emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;

-- specs, attributes
merge into bonuses b using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.old_salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;

-- update/insert on source table
merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set e.salary=d.bonus+e.salary*0.1 where e.salary<600;
merge into bonuses d using emp e on d.emp_id = e.emp_id when not matched then insert (e.emp_id, e.salary) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into (select * from bonuses) d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600;
merge into (select * from bonuses) d using emp e on d.emp_id = e.emp_id when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;

-- invalid insert
merge into bonuses d using emp e on d.emp_id = e.emp_id when not matched then insert values (e.emp_id, 100+e.salary*0.1), (99, 99) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when not matched then insert (d.emp_id, d.bonus, d.emp_id) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when not matched then insert (d.emp_id, d.bonus) values where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when not matched then insert (d.emp_id, d.bonus) values () where e.salary<=400;

-- invalid use of aggregate
merge into bonuses d using emp e on d.emp_id = count(*) when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=count(*) where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where count(e.salary)<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert values (count(e.emp_id), 100+e.salary*0.1) where e.salary<=400;
merge into bonuses d using emp e on d.emp_id = e.emp_id when matched then update set d.bonus=d.bonus+e.salary*0.1 where e.salary<600 when not matched then insert (d.emp_id, d.bonus) values (e.emp_id, 100+e.salary*0.1) where count(e.salary)<=400;

drop emp;
drop bonuses;
