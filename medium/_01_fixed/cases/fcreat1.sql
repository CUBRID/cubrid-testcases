autocommit off;
create class sd_2_1_
 (res_test     float default 340282346638528859811704183484516925440.000000e0);
create class cc_address 
  (street string,
   city string);
create class cc_person
  (name string,
   age smallint,
   lifetime timestamp,
   love object,
   clubs set_of(string, integer, object),
   phones set_of(integer),
   hobbies set_of(),
   residence cc_address);
create class cc_department
  (name string,
   emps set_of(cc_person));
 
create class cc_company
  (name string,
   headquarter cc_address,
   president cc_person,
   cc_departments set_of(cc_department));
create class cc_employee as subclass of cc_person
  (salary  integer,
   friends set_of(cc_person),
   worksfor set_of (cc_company),
   emp_date date,
   emp_time time,
   tax monetary);
select distinct name from cc_employee order by 1 ASC, name ASC;
rollback work;
create class cccc (a int default 7, b int);
insert into cccc (b) values(77);
select a,b from cccc;
rollback;
