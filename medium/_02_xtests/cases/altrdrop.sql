autocommit off;
	create class s1 (x integer);
	create class s2 (x integer);
	create class c as subclass of s1, s2 (x integer);
	alter class c drop x inherit x of s1;
	
	rollback work;
rollback;
