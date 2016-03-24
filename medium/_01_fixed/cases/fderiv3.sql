autocommit off;

create class customer (name string, address string);
create class product (name string, price monetary);
create class line_item (qty int, prod product);
create class purchase_order (po# int, cust customer, ls sequence of line_item);
insert into customer values ('Acme', 'White Sands, Utah') to acme;
insert into customer values ('Ace', 'Sasquatch Valley, Oregon') to ace;
insert into customer values ('TIC', 'Metropolis') to tic;
insert into product values ('widget', $5.00) to widget;
insert into product values ('framus', $100.00) to framus;
insert into product values ('frobnicator', $1000.00) to frobnicator;
insert into purchase_order values (
	100,
	acme,
	{(insert into line_item values (12, widget))});
insert into purchase_order values (
	101,
	acme,
	{(insert into line_item values (1, frobnicator))});
insert into purchase_order values (
	102,
	ace,
	{(insert into line_item values (4, framus)),
	 (insert into line_item values (4, frobnicator))});
insert into purchase_order values (
	103,
	acme,
	{(insert into line_item values (16, widget)),
	 (insert into line_item values (4, framus)),
	 (insert into line_item values (4, frobnicator))});
insert into purchase_order values (
	104,
	ace,
	{(insert into line_item values (200, widget))});
insert into purchase_order values (
	105,
	tic,
	{(insert into line_item values (1, widget))});
	select sum(item.qty)
	from purchase_order as po, table(po.ls) as t(item)
	where po.cust.name = 'Acme'
	and item.prod.name = 'widget'
	select po.po#,
	       (select sum(item.qty * item.prod.price)
		from table(po.ls) as t(item))
	from purchase_order as po
	select distinct po.cust.name
	from purchase_order as po, table(po.ls) as t(item)
	where item.qty > 25 and item.prod.name = 'widget'
	select cpo.name, cpo.pos
	from (select c.name,
		     set(select po
			 from purchase_order as po
			 where po.cust.name = c.name)
	      from customer as c) as cpo(name, pos)
	where (select sum(item.qty * item.prod.price)
	       from table(cpo.pos) as t0(po), table(po.ls) as t1(item)) > $500
rollback;
