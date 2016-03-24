autocommit off;
create class addressx
(
	street		string,
	city		string,
	state		string,
	zip		string 
);
create class employeex
(       date_of_hire    date,
        emp_id          integer,
        emp_name        string,
        ss_#            string
);
create class perm_emp as subclass of employeex
(       start_date      date
);
create class manager as subclass of perm_emp
(       dept            string,
        staff           set_of (employeex)
);
create class sales as subclass of perm_emp
(       quota           monetary,
        sales_to_date   monetary
);
create class client
(
	company_name	string,
	addr		addressx,
	telephone	string,
	contact		string
);
create class items
(
	item_descr	string,
	item_price	monetary
);
create class product as subclass of items
(	
	photo		glo
);
create class service as subclass of items;
	
create class line_orders
(
	item		items not null,
	quantity	int,
	price		monetary
);
create class orders
(	
	customer	client,
	purchase_price	monetary,
	order_desc	string,
	order_date	date,	
	line_items	sequence_of (line_orders),
	message		glo,
	order_notes	string
);
alter class line_orders
add attribute line 	orders;
alter class line_orders
add attribute temp_field int unique;
select  line.customer.company_name,
	line.customer.contact, line.customer.addr.city,line.customer.addr.state,
	line.customer.addr.street, line.customer.addr.zip,
	line.message, item, item.item_descr, item.item_price,
	item{p}.photo
from line_orders, product p
where line.message is not NULL
order by line.customer.company_name;
rollback;
