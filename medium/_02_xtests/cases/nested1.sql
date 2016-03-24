autocommit off;
insert into person(name, age, phones, hobbies, residence, lifetime, clubs)
values ('Amy', 20, {3437190, 3437191}, { 'reading', 'camping' , 111}, 
         ( insert into address(street, city)
 		    values ('1 Wolf St. ', 'Austin')), 223344, 
	{124, 'club1'}) to  person1;
insert into person(name, age, phones, residence, lifetime, clubs, love)
values ('John', 30, {3437290, 3437291}, (insert into address(street, city)
  		    values ('2 Eeat 20 st. ', 'Austin')), 223344,
	{125, 'club2',  person1},  person1) to  person2;
insert into person(name, phones, hobbies, residence, age, lifetime, love)
values ('Kent', {3437390}, {'music', 222},
       (insert into address(street, city)
       values ('10 West 1 St. ', 'New York')),
       35, 223355,  person2) to  person3;
insert into person(name, age, phones, hobbies, residence, lifetime, love)
values ('Ali', 24, {3437390}, {'music','travelling','reading'},
        (insert into address(street, city)
 		    values ('12707 Pond Woods ', 'Austin')), 223366, 
	 person3)
	to  person4;
insert into person(name, age, phones, hobbies, residence, lifetime, love)
values ('Ali2', 54, {3437392, 3437393, 3437394, 3437395},
                    {'travelling','reading','movies', 333},
                    (insert into address(street, city)
  		    values ('1234 Jollyville Rd. ', 'Austin')), 223377, 
	 person4)
	to  person5;
insert into person(name, phones, hobbies, residence, age, lifetime, love)
values ('Sheng', {3437390, 3437391},
                    {'travelling','reading','movies', 444},
       (insert into address(street, city)
       values ('1000 Great Hills ', 'Austin')),
       31, 223388,  person5) to  person6;
insert into person(name, age, phones, residence, lifetime, love)
values ('Jack', 15, {3437490}, ( insert into address(street, city)
 		    values ('11 Wolf St. ', 'Houston')), 223399, 
	 person6)
	to  person7;
insert into person(name, age, phones, hobbies, residence, lifetime, love)
values ('Bob', 22, {3437491}, {'music'},( insert into address(street, city)
  		    values ('22 Eeat 20 st. ', 'Dallas')), 224400, 
	 person7)
	to  person8;
insert into person(name, phones, residence, age, lifetime, love)
values ('Emily', {3437493},
       ( insert into address(street, city)
       values ('100 West 1 St. ', 'Dallas')), 
       35, 224411,  person8) to  person9;
insert into person(name, phones, residence, age, lifetime, love)
values ('Chank', {3437494},
       ( insert into address(street, city)
       values ('150 West 1 St. ', 'Austin')), 
       45, 224422,  person9) to  person10;
insert into person(name, phones, hobbies, residence, age, lifetime, love)
values ('Robert', {3437495},
       { 'camping','music','movies','reading','travelling'},
       ( insert into address(street, city)
       values ('10 East 1 St. ', 'Austin')), 
       40, 224433,  person10) to  person11;
insert into person(name, phones, hobbies, residence, age, lifetime, love)
values ('Jack', {3437496}, {'reading'},
       ( insert into address(street, city)
       values ('1250 Pond Rd. #235 ', 'Houston')), 
       45, 224444,  person11) to  person12;
insert into person(name, phones, hobbies, residence, age, lifetime, love)
values ('Lima', {3437497}, {'reading'},
       ( insert into address(street, city)
       values ('235 North Dr. ', 'Austin')), 
       55, 224455,  person12) to  person13;
insert into person(name, phones, hobbies, residence, age, lifetime, love)
values ('Manuel', {3437498}, {'reading'},
       ( insert into address(street, city)
       values ('200 Round Rock. ', 'Dallas')), 
       25, 224466,  person13) to  person14;
insert into person(name, phones, residence, age, lifetime, love)
values ('Melody', {3437499},
       ( insert into address(street, city)
       values ('1200 East Rd. ', 'Houston')), 
       45, 225511,  person14) to  person15;
insert into person(name, phones, hobbies, residence, age, lifetime, love)
values ('Vance', {3437590}, {'reading', 'music'},
       ( insert into address(street, city)
       values ('150 West 1 St. ', 'Atlanta')), 
       28, 225511,  person15) to  person16;
insert into department(name, emps)
values ('dep1', { person1,  person12,  person3,  person5}) to  d1;
insert into department(name, emps)
values ('dep2', { person2,  person4,  person6}) to  d2;
insert into department(name, emps)
values ('dep3', { person3,  person7,  person8}) to  d3;
insert into department(name, emps)
values ('dep4', { person11,  person7,  person13}) to  d4;
insert into department(name, emps)
values ('dep5', { person14,  person10,  person12}) to  d5;
insert into department(name, emps)
values ('dep6', { person9,  person14,  person12,  person11}) 
	to  d6;
insert into department(name, emps)
values ('dep7', { person5,  person8,  person7,  person6, 
	 person2}) to  d7;
insert into department(name, emps)
values ('dep8', { person8,  person7,  person15,  person5, 
	 person2}) to  d8;
insert into department(name, emps)
values ('dep9', { person2,  person1,  person16,  person4, 
	 person5}) to  d9;
insert into department(name, emps)
values ('dep10', { person14,  person4,  person11,  person9, 
	 person10}) to  d10;
insert into company(name, headquarter, president, departments)
	values ( 'IBM',
		( insert into address(street, city)
		values ('6 Red Rd.', 'Cleveland')), 
		( insert into person(name, age, hobbies, residence)
		values ('Jeff', 
                         30, 
                         {'music','reading'},
                         ( insert into address(street, city)
		         values ('11 Wolf St. ', 'Austin')))),
	{ d1,  d5}) to  c1;
insert into company(name, headquarter, president, departments)
	values ( 'UniSQL',
		( insert into address(street, city)
		values ('9380 Research Blvd..', 'Austin')), 
		( insert into person(name, age, hobbies, residence)
		values ('Mike', 
                         35, 
                         {'reading'},
                         ( insert into address(street, city)
		         values ('112 Wolf St. ', 'Austin')))),
	{ d3,  d7,  d9}) to  c2;
insert into company(name, headquarter, president, departments)
	values ( 'UniSQL',
		( insert into address(street, city)
		values ('9380 Research Blvd', 'Austin')), 
		( insert into person(name, age, phones, residence)
		values ('Jeff', 
                         33, 
                         { 3431010, 3452020 },
                         ( insert into address(street, city)
		         values ('11 Wolf St. ', 'Austin')))),
	{ d9,  d10}) to  c3;
insert into company(name, headquarter, president, departments)
	values ( 'IBM',
		( insert into address(street, city)
		values ('67 Red Rd.', 'Cleveland')), 
		( insert into person(name, age, phones, hobbies, residence)
		values ('Bob', 
                         35, 
                         { 3334444, 5556666, 7778888 },
                         { 'music', 'reading', 'travelling' },
                         (insert into address(street, city)
		         values ('12 Wolf St. ', 'Cleveland')))),
	{ d3,  d8}) to  c4;
insert into company(name, headquarter, president, departments)
	values ( 'TI',
		( insert into address(street, city)
		values ('566 Red Rd.', 'Houston')), 
		( insert into person(name, age, phones, residence)
		values ('Mike', 
                         65,
                         { 3456789 },
                         ( insert into address(street, city)
		         values ('112 Wolf St. ', 'Houston')))),
	{ d1,  d4,  d9}) to  c5;
insert into company(name, headquarter, president, departments)
	values ( 'TI',
		( insert into address(street, city)
		values ('6 Red Rd.', 'Dallas')), 
		( insert into person(name, age, residence)
		values ('Hans', 
                         65,
                         ( insert into address(street, city)
		         values ('111 Wolf St. ', 'Dallas')))),
	{ d8,  d10}) to  c6;
insert into company(name, headquarter, president, departments)
	values ( 'IBM',
		( insert into address(street, city)
		values ('60 Blue Rd.', 'Austin')), 
		( insert into person(name, age, phones, hobbies, residence)
		values ('Ted', 
                         55,
                         { 1231212, 1241212 },
                         { 'travelling', 'camping'},
                         ( insert into address(street, city)
		         values ('111 Wolf St. ', 'Houston')))),
	{ d4,  d2}) to  c7;
insert into company(name, headquarter, president, departments)
	values ( 'TI',
		( insert into address(street, city)
		values ('6 Red Rd.', 'Dallas')), 
		( insert into person(name, age, phones, residence)
		values ('Hans', 
                         65,
                         { 3437390, 3437491 },
                         ( insert into address(street, city)
		         values ('111 Wolf St. ', 'Dallas')))),
	{ d5,  d7}) to  c8;
insert into company(name, headquarter, president, departments)
	values ( 'Radan',
		( insert into address(street, city)
		values ('156 North Ave.', 'Austin')), 
		( insert into person(name, age, hobbies, residence)
		values ('Bob', 
                         60,
                         { 'reading' },
                         ( insert into address(street, city)
		         values ('111 Wolf St. ', 'Austin')))),
	{ d4,  d6}) to  c9;
insert into company(name, headquarter, president, departments)
	values ( 'TI',
		( insert into address(street, city)
		values ('6 Red Rd.', 'Dallas')), 
		( insert into person(name, age, residence)
		values ('Hans', 
                         65,
                         ( insert into address(street, city)
		         values ('111 Wolf St. ', 'Dallas')))),
	{ d2,  d9,  d1}) to  c10;
insert into company(name, headquarter, president, departments)
	values ( 'CompX',
		( insert into address(street, city)
		values ('990 Nortwest St.', 'Austin')), 
		( insert into person(name, age, residence)
		values ('Mike', 
                         73,
                         ( insert into address(street, city)
		         values ('100 Cats St. ', 'Austin')))),
	{ d3,  d8}) to  c11;
insert into company(name, headquarter, president, departments)
	values ( 'CompY',
		( insert into address(street, city)
		values ('126 Red Rd.', 'Dallas')), 
		( insert into person(name, age, hobbies, residence)
		values ('Robert', 
                         72,
                         { 'reading', 'music', 'travelling' },
                         ( insert into address(street, city)
		         values ('1000 Wolf St. ', 'Dallas')))),
	{ d2,  d1}) to  c12;
insert into company(name, headquarter, president, departments)
	values ( 'CompZ',
		( insert into address(street, city)
		values ('623 Red Rd.', 'Austin')), 
		( insert into person(name, age, phones, residence)
		values ('Chen Yung', 
                         62,
                         { 3437590, 3437390 },
                         ( insert into address(street, city)
		         values ('111 Wolf St. ', 'Austin')))),
	{ d6,  d8,  d9}) to  c13;
insert into empl(name, age, residence, salary, worksfor, lifetime, friends,
	emp_date, emp_time, tax)
values ('Jessie', 
	40, 
        ( insert into address(street, city)
	values ('60 Green Rd.', 'Cleveland')), 
	20000,
	{ c1,  c2}, 224477,
	{ person1,  person4},	'1/20/1989', '12:20:30', 6000)
	to  e1;
insert into empl(name, age, residence, salary, worksfor, lifetime, friends,
	emp_date, emp_time, tax)
values ('Yu', 
	35, 
        ( insert into address(street, city)
	values ('689 Green Rd.', 'Atlanta')), 
	36000,
	{ c2,  c3}, 225533,
	{ person3,  person6,  person7},
		'2/9/1990', '23:30:10', 11070.0) to  e2;
insert into empl(name, age, residence, salary, worksfor, lifetime, friends,
	emp_date, emp_time, tax)
values ('Yanmin', 
	27, 
        ( insert into address(street, city)
	values ('60 Green Rd.', 'Austin')), 
	34000,
	{ c5,  c8}, 225566,
	{ person8,  person14},
		'03/19/1976', '12:40', 10000.50) to  e3;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Joyce', 
	40, 
        ( insert into address(street, city)
	values ('60 Green Rd.', 'Cleveland')), 
	25000,
	{ c9,  c12,  c3},
	{ person15}, 	'04/20/1991', '12:20:00', 7990.99) to  e4;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Ted', 
	40, 
        ( insert into address(street, city)
	values ('56 Green Rd.', 'Houston')), 
	55000,
	{ c5},
	{ person14,  person11}, 	'5/23/1987', '16:20:59', 16000.67)
	to  e5;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('John', 
	45, 
        ( insert into address(street, city)
	values ('6 Green Rd.', 'Dallas')), 
	45000,
	{ c4,  c8},
	{ person8,  person6},	'06/12/91', '18:00:00', 12000) to  e6;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Robert', 
	40, 
        ( insert into address(street, city)
	values ('6 Green Rd.', 'Dallas')), 
	34000,
	{ c9,  c11},
	{ person4,  person7},	'7/6/91', '19:00:00', 11000.95) to  
	e7;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Mike', 
	27, 
        ( insert into address(street, city)
	values ('6 Green Rd.', 'Houston')), 
	24000,
	{ c13,  c12},
	{ person1,  person3}, 	'8/1/1991', '2:20 pm', 8999.00)
	to  e8;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Ted', 
	55, 
        ( insert into address(street, city)
	values ('66 East Dr..', 'Austin')), 
	35000,
	{ c1},
	{ person3,  person4}, 	'09/03/1990', '9:02:01 am', 11890)
	to  e9;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Lucy', 
	30, 
        ( insert into address(street, city)
	values ('126 Round Rock', 'Houston')), 
	38000,
	{ c7,  c5,  c10},
	{ person4,  person9}, 	'10/9/1987', '02:01:34', 13000)
	to  e10;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Laura', 
	45, 
        ( insert into address(street, city)
	values ('65 North Loop', 'Austin')), 
	57000,
	{ c10},
	{ person3,  person4}, 	'11/1/1980', '02:07:00 AM', 22000)
	to  e11;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Catherina', 
	32, 
        ( insert into address(street, city)
	values ('126 Blue Circle.', 'Dallas')), 
	35000,
	{ c6,  c12},
	{ person7,  person8}, 	'12/1/91', '3:03:19 PM', 12078)
 	to  e12;
insert into empl(name, age, residence, salary, worksfor, friends, emp_date,
	emp_time, tax)
values ('Chen', 
	55, 
        ( insert into address(street, city)
	values ('126 Solid Rd.', 'Austin')), 
	45000,
	{ c9,  c8,  c13,  c11},
	{ person6}, 	'01/6/1991', '2:30 pm', 13089) to  e13;
select name from empl e  where
 age = (select age from empl where
       e.salary = 30000 AND '183' = e.residence.street);
select name from empl e  where
 age = (select max(age) from empl where
       salary <= e.salary AND '126 Solid Rd.' = e.residence.street);
rollback;
