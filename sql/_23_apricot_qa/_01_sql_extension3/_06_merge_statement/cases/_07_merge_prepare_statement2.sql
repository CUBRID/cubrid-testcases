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
--test with prepare statement


autocommit off;


--create target table
create table products(
	product_id int,
	product_name char(30),
	category char(20)
);

insert into products values(1501, 'vivitar 35mm', 'electrncs');
insert into products values(1502, 'olympus is50', 'electrncs');
insert into products values(1600, 'play gym', 'toys');
insert into products values(1601, 'lamaze', 'toys');
insert into products values(1666, 'harry potter', 'dvd');


--create source table
create table new_products(
	product_id int,
	product_name char(30),
        category char(20)
);

insert into new_products values(1502, 'olympus camera', 'electrncs');
insert into new_products values(1601, 'lamaze', 'toys');
insert into new_products values(1666, 'harry potter', 'toys');
insert into new_products values(1700, 'wait interface', 'books');

commit;


--TEST: error, without both update and insert clause
prepare st from 'merge into products
using new_products
on (p.product_id = np.product_id)';
execute st;


--TEST: with update clause, without insert clause, without parentheses on condition part
prepare st from 'merge into products p
using new_products np
on p.product_id = np.product_id
when matched then
update
set p.product_name = np.product_name, p.category = np.category';
execute st;
--TEST: check merge result
select * from products order by product_id;

--TEST: with update clause, without insert clause, 3 rows merged
prepare st from 'merge into products p
using new_products np
on (p.product_id = np.product_id)
when matched then
update
set p.product_name = np.product_name, p.category = np.category';
execute st;
--TEST: check merge result
select * from products order by product_id;
rollback;


--TEST: with insert clause, without update clause, 1 row merged
prepare st from 'merge into products p
using new_products np
on (p.product_id = np.product_id)
when not matched then
insert
values(np.product_id, np.product_name, np.category)';
execute st;
--TEST: check merge result
select * from products order by product_id;
rollback;


--TEST: with update clause with where conditions, 2 rows merged
prepare st from 'merge into products p
using new_products np
on (p.product_id = np.product_id)
when matched then
update
set p.product_name = np.product_name
where p.category = np.category'; 
execute st;
--TEST: check merge result
select * from products order by product_id;
rollback;


--TEST: with both update and insert clause with where conditions, 1 row merged
prepare st from 'merge into products p
using new_products np
on (p.product_id = np.product_id)
when matched then
update
set p.product_name = np.product_name,
p.category = np.category
where p.category = ?
when not matched then
insert 
values(np.product_id, np.product_name, np.category)
where np.category != ?';
execute st using 'dvd', 'books';
--TEST: check merge result
select * from products order by product_id;
rollback;


--TEST: with delete clause, 4 rows merged
prepare st from 'merge into products p
using new_products np
on (p.product_id = np.product_id)
when matched then
update
set p.product_name = np.product_name,
p.category = np.category
delete where(p.category = ?)
when not matched then
insert
values(np.product_id, np.product_name, np.category)';
execute st using 'electrncs';
--TEST: check merge result
select * from products order by product_id;
rollback;


deallocate prepare st;
drop table products, new_products;
commit;


autocommit on;
