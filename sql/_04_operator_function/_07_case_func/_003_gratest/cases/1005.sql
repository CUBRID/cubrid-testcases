--Test greatest() function with timestamp datatype and convert to string
create class t1 (a int, b timestamp);

select greatest(timestamp'09/05/2008 09:21:00',timestamp'09/11/2008 09:25:00') from db_root;

select greatest(timestamp'09/05/2008 10:21:00',timestamp'09/11/2008 09:25:00') from db_root;

drop class t1;