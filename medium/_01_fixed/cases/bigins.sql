autocommit off;
create class big_address 
(street string,
city string);
create index i_big_address_city on big_address (city);
create index i_big_address_street on big_address (street);
insert into big_address(street, city)
 		    values ('1 Wolf St. ', 'Austin') to add1;
insert into big_address(street, city)
  		    values ('2 Eeat 20 st. ', 'Austin') to add2;
insert into big_address(street, city)
       values ('10 West 1 St. ', 'New York') to add3;
insert into big_address(street, city)
 		    values ('12707 Pond Woods ', 'Austin') to add4;
insert into big_address(street, city)
  		    values ('1234 Jollyville Rd. ', 'Austin') to add5;
insert into big_address(street, city)
       values ('1000 Great Hills ', 'Austin') to add6;
insert into big_address(street, city)
 		    values ('11 Wolf St. ', 'Houston') to add7;
insert into big_address(street, city)
  		    values ('22 Eeat 20 st. ', 'Dallas') to add8;
insert into big_address(street, city)
       values ('100 West 1 St. ', 'Dallas') to add9;
insert into big_address(street, city)
       values ('150 West 1 St. ', 'Austin') to add10;
insert into big_address(street, city)
       values ('10 East 1 St. ', 'Austin') to add11;
insert into big_address(street, city)
       values ('1250 Pond Rd. #235 ', 'Houston') to add12;
insert into big_address(street, city)
       values ('235 North Dr. ', 'Austin') to add13;
insert into big_address(street, city)
       values ('200 Round Rock. ', 'Dallas') to add14;
insert into big_address(street, city)
       values ('1200 East Rd. ', 'Houston') to add15;
insert into big_address(street, city)
       values ('150 West 1 St. ', 'Atlanta') to add16;
create class big_person
(name string,
class global_addr set_of(integer) default {1, 5, 10},
classification string shared 'people',
share_attr set_of(integer, float, object) shared {},
age integer,
lifetime timestamp,
love object,
clubs set_of(string, integer, object),
phones set_of(integer),
hobbies set_of(),
residence big_address);
/* create index on big_person (age); */
create index i_big_person_lifetime on big_person (lifetime);
insert into big_person(name, age, phones, hobbies, residence, lifetime, clubs)
values ('Amy', 20, {3437190, 3437191}, { 'reading', 'camping' , 111}, 
         add1, 223344, 
	{124, 'club1'}) to  big_person1;
insert into big_person(name, age, phones, residence, lifetime, clubs, love)
values ('John', 30, {3437290, 3437291}, add2, 223344,
    set	{125, 'club2',  big_person1},  big_person1) to  big_person2;
insert into big_person(name, phones, hobbies, residence, age, lifetime, love)
values ('Kent', {3437390}, {'music', 222}, add3,
       35, 223355,  big_person2) to  big_person3;
insert into big_person(name, age, phones, hobbies, residence, lifetime, love)
values ('Ali', 24, {3437390}, {'music','travelling','reading'},
        add4, 223366, 
	 big_person3)
	to  big_person4;
insert into big_person(name, age, phones, hobbies, residence, lifetime, love)
values ('Ali2', 54, {3437392, 3437393, 3437394, 3437395},
                    {'travelling','reading','movies', 333},
                    add5, 223377, 
	 big_person4)
	to  big_person5;
insert into big_person(name, phones, hobbies, residence, age, lifetime, love)
values ('Sheng', {3437390, 3437391},
                    {'travelling','reading','movies', 444},
       add6,
       31, 223388,  big_person5) to  big_person6;
insert into big_person(name, age, phones, residence, lifetime, love)
values ('Jack', 15, {3437490}, add7, 223399, 
	 big_person6)
	to  big_person7;
insert into big_person(name, age, phones, hobbies, residence, lifetime, love)
values ('Bob', 22, {3437491}, {'music'}, add8, 224400, 
	 big_person7)
	to  big_person8;
insert into big_person(name, phones, residence, age, lifetime, love)
values ('Emily', {3437493},
       add9, 
       35, 224411,  big_person8) to  big_person9;
insert into big_person(name, phones, residence, age, lifetime, love)
values ('Chank', {3437494},
       add10, 
       45, 224422,  big_person9) to  big_person10;
insert into big_person(name, phones, hobbies, residence, age, lifetime, love)
values ('Robert', {3437495},
       { 'camping','music','movies','reading','travelling'},
       add11, 
       40, 224433,  big_person10) to  big_person11;
insert into big_person(name, phones, hobbies, residence, age, lifetime, love)
values ('Jack', {3437496}, {'reading'},
       add12, 
       45, 224444,  big_person11) to  big_person12;
insert into big_person(name, phones, hobbies, residence, age, lifetime, love)
values ('Lima', {3437497}, {'reading'},
       add13, 
       55, 224455,  big_person12) to  big_person13;
insert into big_person(name, phones, hobbies, residence, age, lifetime, love)
values ('Manuel', {3437498}, {'reading'},
       add14, 
       25, 224466,  big_person13) to  big_person14;
insert into big_person(name, phones, residence, age, lifetime, love)
values ('Melody', {3437499},
       add15, 
       45, 225511,  big_person14) to  big_person15;
insert into big_person(name, phones, hobbies, residence, age, lifetime, love)
values ('Vance', {3437590}, {'reading', 'music'},
       add16, 
       28, 225511,  big_person15) to  big_person16;
create class big_department
(name string,
 emps set_of(big_person));
create index i_big_department_name on big_department (name);
insert into big_department(name, emps)
values ('dep1', set { big_person1,  big_person12,  big_person3,  big_person5}) to  d1;
insert into big_department(name, emps)
values ('dep2', set { big_person2,  big_person4,  big_person6}) to  d2;
insert into big_department(name, emps)
values ('dep3', set { big_person3,  big_person7,  big_person8}) to  d3;
insert into big_department(name, emps)
values ('dep4', set { big_person11,  big_person7,  big_person13}) to  d4;
insert into big_department(name, emps)
values ('dep5', set { big_person14,  big_person10,  big_person12}) to  d5;
insert into big_department(name, emps)
values ('dep6', set { big_person9,  big_person14,  big_person12,  big_person11}) 
	to  d6;
insert into big_department(name, emps)
values ('dep7', set { big_person5,  big_person8,  big_person7,  big_person6, 
	 big_person2}) to  d7;
insert into big_department(name, emps)
values ('dep8', set { big_person8,  big_person7,  big_person15,  big_person5, 
	 big_person2}) to  d8;
insert into big_department(name, emps)
values ('dep9', set { big_person2,  big_person1,  big_person16,  big_person4, 
	 big_person5}) to  d9;
insert into big_department(name, emps)
values ('dep10', set { big_person14,  big_person4,  big_person11,  big_person9, 
	 big_person10}) to  d10;
 
create class big_company
(name string,
headquarter big_address,
president big_person,
big_departments set_of(big_department));
create index i_big_company_name on big_company (name);
insert into big_company(name, headquarter, president, big_departments)
	values ( 'IBM',
		( insert into big_address(street, city)
		values ('6 Red Rd.', 'Cleveland')), 
		( insert into big_person(name, age, hobbies, residence)
		values ('Jeff', 
                         30, 
                         {'music','reading'},
                         ( insert into big_address(street, city)
		         values ('11 Wolf St. ', 'Austin')))),
	set { d1,  d5}) to  c1;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'UniSQL',
		( insert into big_address(street, city)
		values ('9380 Research Blvd..', 'Austin')), 
		( insert into big_person(name, age, hobbies, residence)
		values ('Mike', 
                         35, 
                         {'reading'},
                         ( insert into big_address(street, city)
		         values ('112 Wolf St. ', 'Austin')))),
	set { d3,  d7,  d9}) to  c2;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'UniSQL',
		( insert into big_address(street, city)
		values ('9380 Research Blvd', 'Austin')), 
		( insert into big_person(name, age, phones, residence)
		values ('Jeff', 
                         33, 
                         { 3431010, 3452020 },
                         ( insert into big_address(street, city)
		         values ('11 Wolf St. ', 'Austin')))),
	set { d9,  d10}) to  c3;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'IBM',
		( insert into big_address(street, city)
		values ('67 Red Rd.', 'Cleveland')), 
		( insert into big_person(name, age, phones, hobbies, residence)
		values ('Bob', 
                         35, 
                         { 3334444, 5556666, 7778888 },
                         { 'music', 'reading', 'travelling' },
                         ( insert into big_address(street, city)
		         values ('12 Wolf St. ', 'Cleveland')))),
	set { d3,  d8}) to  c4;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'TI',
		( insert into big_address(street, city)
		values ('566 Red Rd.', 'Houston')), 
		( insert into big_person(name, age, phones, residence)
		values ('Mike', 
                         65,
                         { 3456789 },
                         ( insert into big_address(street, city)
		         values ('112 Wolf St. ', 'Houston')))),
	set { d1,  d4,  d9}) to  c5;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'TI',
		( insert into big_address(street, city)
		values ('6 Red Rd.', 'Dallas')), 
		( insert into big_person(name, age, residence)
		values ('Hans', 
                         65,
                         ( insert into big_address(street, city)
		         values ('111 Wolf St. ', 'Dallas')))),
	set { d8,  d10}) to  c6;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'IBM',
		( insert into big_address(street, city)
		values ('60 Blue Rd.', 'Austin')), 
		( insert into big_person(name, age, phones, hobbies, residence)
		values ('Ted', 
                         55,
                         { 1231212, 1241212 },
                         { 'travelling', 'camping'},
                         ( insert into big_address(street, city)
		         values ('111 Wolf St. ', 'Houston')))),
	set { d4,  d2}) to  c7;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'TI',
		( insert into big_address(street, city)
		values ('6 Red Rd.', 'Dallas')), 
		( insert into big_person(name, age, phones, residence)
		values ('Hans', 
                         65,
                         { 3437390, 3437491 },
                         ( insert into big_address(street, city)
		         values ('111 Wolf St. ', 'Dallas')))),
	set { d5,  d7}) to  c8;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'Radan',
		( insert into big_address(street, city)
		values ('156 North Ave.', 'Austin')), 
		( insert into big_person(name, age, hobbies, residence)
		values ('Bob', 
                         60,
                         { 'reading' },
                         ( insert into big_address(street, city)
		         values ('111 Wolf St. ', 'Austin')))),
	set { d4,  d6}) to  c9;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'TI',
		( insert into big_address(street, city)
		values ('6 Red Rd.', 'Dallas')), 
		( insert into big_person(name, age, residence)
		values ('Hans', 
                         65,
                         ( insert into big_address(street, city)
		         values ('111 Wolf St. ', 'Dallas')))),
	set { d2,  d9,  d1}) to  c10;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'CompX',
		( insert into big_address(street, city)
		values ('990 Nortwest St.', 'Austin')), 
		( insert into big_person(name, age, residence)
		values ('Mike', 
                         73,
                         ( insert into big_address(street, city)
		         values ('100 Cats St. ', 'Austin')))),
	set { d3,  d8}) to  c11;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'CompY',
		( insert into big_address(street, city)
		values ('126 Red Rd.', 'Dallas')), 
		( insert into big_person(name, age, hobbies, residence)
		values ('Robert', 
                         72,
                         { 'reading', 'music', 'travelling' },
                         ( insert into big_address(street, city)
		         values ('1000 Wolf St. ', 'Dallas')))),
	set { d2,  d1}) to  c12;
insert into big_company(name, headquarter, president, big_departments)
	values ( 'CompZ',
		( insert into big_address(street, city)
		values ('623 Red Rd.', 'Austin')), 
		( insert into big_person(name, age, phones, residence)
		values ('Chen Yung', 
                         62,
                         { 3437590, 3437390 },
                         ( insert into big_address(street, city)
		         values ('111 Wolf St. ', 'Austin')))),
	set { d6,  d8,  d9}) to  c13;
create class big_employee as subclass of big_person
(salary  integer,
salary_f float,
salary_d double,
father   big_person,
x_names  set_of(big_person, big_company),
friends set_of(big_person),
worksfor set_of (big_company),
schedule sequence_of(date) default sequence{DATE '10/9/1960', DATE '10/10/1960'},
emp_date date,
emp_time time,
tax monetary);
create index i_big_employee_age on big_employee (age);
create index i_big_employee_name on big_employee (name);
create index i_big_employee_salary on big_employee (salary);
create index i_big_employee_residence on big_employee (residence);
create index i_big_employee_salary_f on big_employee (salary_f);
create index i_big_employee_salary_d on big_employee (salary_d);
create index i_big_employee_emp_date on big_employee (emp_date);
create index i_big_employee_emp_time on big_employee (emp_time);
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('Ted', 
	40, 
        ( insert into big_address(street, city)
	values ('56 Green Rd.', 'Houston')), 
	55000, 55000.0, 55000.0,
	set { c5},
	set { big_person14,  big_person11}, DATE '5/23/1987', TIME '16:20:59', 16000.67, 
	big_person3)
	to  e5;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('John', 
	45, 
        ( insert into big_address(street, city)
	values ('6 Green Rd.', 'Dallas')), 
	45000, 45000.0, 45000.0,
	set { c4,  c8},
	set { big_person8,  big_person6}, DATE '06/12/91', TIME '18:00:00', 12000, big_person7) to  e6;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('Robert', 
	40, 
        ( insert into big_address(street, city)
	values ('6 Green Rd.', 'Dallas')), 
	34000, 34000.0, 34000.0,
	set { c9,  c11},
	set { big_person4,  big_person7}, DATE '7/6/91', TIME '19:00:00', 11000.95, big_person5) to  
	e7;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('Mike', 
	27, 
        ( insert into big_address(street, city)
	values ('6 Green Rd.', 'Houston')), 
	24000, 24000.0, 24000.0,
	set { c13,  c12},
	set { big_person1,  big_person3}, DATE '8/1/1991', TIME '2:20 pm', 8999.00, big_person4)
	to  e8;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('Ted', 
	55, 
        ( insert into big_address(street, city)
	values ('66 East Dr..', 'Austin')), 
	35000, 35000.0, 35000.0,
	set { c1},
	set { big_person3,  big_person4}, DATE '09/03/1990', TIME '9:02:01 am', 11890, big_person5)
	to  e9;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('Lucy', 
	30, 
        ( insert into big_address(street, city)
	values ('126 Round Rock', 'Houston')), 
	38000, 38000.0, 38000.0,
	set { c7,  c5,  c10},
	set { big_person4,  big_person9}, DATE '10/9/1987', TIME '02:01:34', 13000, big_person3)
	to  e10;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('Laura', 
	45, 
        ( insert into big_address(street, city)
	values ('65 North Loop', 'Austin')), 
	57000, 57000.0, 57000.0,
	set { c10},
	set { big_person3,  big_person4}, DATE '11/1/1980', TIME '02:07:00 AM', 22000, big_person8)
	to  e11;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father)
values ('Catherina', 
	32, 
        ( insert into big_address(street, city)
	values ('126 Blue Circle.', 'Dallas')), 
	35000, 35000.0, 35000.0,
	set { c6,  c12},
	set { big_person7,  big_person8}, DATE '12/1/91', TIME '3:03:19 PM', 12078, big_person7)
 	to  e12;
insert into big_employee(name, age, residence, salary, salary_f, salary_d, worksfor, friends, emp_date,
	emp_time, tax, father, x_names)
values ('Chen', 
	55, 
        ( insert into big_address(street, city)
	values ('126 Solid Rd.', 'Austin')), 
	45000, 45000.0, 45000.0,
	set { c9,  c8,  c13,  c11},
	set { big_person6}, DATE '01/6/1991', TIME '2:30 pm', 13089, big_person2,
	set {big_person1, c3, c4}) to  e13;
rollback;
