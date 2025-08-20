autocommit off;
create class foo (
	num numeric(5,2), i integer, s short, 
	f float, r real, d double, m monetary,
	si set(int), ms multiset(numeric, string), sq sequence(float),
	dt date, t time, ut timestamp, vb bit varying(4), b bit(11));
insert into foo values(123.45, 345, 127, 23.456e0, 123.45e0, 1.2234342e0,$12.56, set{1,2,3,4}, multiset{1.234, 'test1', 23.45},
		       sequence{1.234e0, 23.45e0}, date '05/17/1973', 
		       time '12:33 PM', timestamp '02/14/1994 12:30pm', 
		       b'1010', b'1100110011');
select * from foo;
select cast(345 as int)          from class db_user;
select cast(i   as int)          from foo;
select cast(345 as smallint)     from class db_user;
select cast(i   as smallint)     from foo;
select cast(345 as numeric(7,2)) from class db_user;
select cast(i   as numeric(7,2)) from foo;
select cast(345 as double)       from class db_user;
select cast(i   as double)       from foo;
select cast(345 as monetary)     from class db_user;
select cast(i   as monetary)     from foo;
select cast(345 as char(50))     from class db_user;
select cast(i   as char(50))     from foo;
select cast(345 as varchar(50))  from class db_user;
select cast(i   as varchar(50))  from foo;
select cast(345 as nchar(50))    from class db_user;
select cast(i   as nchar varying(50)) from foo;
select cast(s   as int)          from foo;
select cast(s   as smallint)     from foo;
select cast(s   as numeric(7,2)) from foo;
select cast(s   as double)       from foo;
select cast(s   as monetary)     from foo;
select cast(s   as char(50))     from foo;
select cast(s   as varchar(50))  from foo;
select cast(s   as nchar(50))    from foo;
select cast(s   as nchar varying(50)) from foo;
select cast(123.45 as int)          from class db_user;
select cast(num    as int)          from foo;
select cast(123.45 as smallint)     from class db_user;
select cast(num    as smallint)     from foo;
select cast(123.45 as numeric(7,2)) from class db_user;
select cast(num    as numeric(7,2)) from foo;
select cast(123.45 as double)       from class db_user;
select cast(num    as double)       from foo;
select cast(123.45 as float)        from class db_user;
select cast(num    as float)        from foo;
select cast(123.45 as monetary)     from class db_user;
select cast(num    as monetary)     from foo;
select cast(123.45 as char(50))     from class db_user;
select cast(num    as char(50))     from foo;
select cast(123.45 as varchar(50))  from class db_user;
select cast(num    as varchar(50))  from foo;
select cast(123.45 as nchar(50))    from class db_user;
select cast(num    as nchar(50))    from foo;
select cast(123.45 as nchar varying(50)) from class db_user;
select cast(num    as nchar varying(50)) from foo;
select cast(f as int)          from foo;
select cast(f as smallint)     from foo;
select cast(f as numeric(5,2)) from foo;
select cast(r as float)        from foo;
select cast(f as double)       from foo;
select cast(f as monetary)     from foo;
select cast(f as char(50))     from foo;
select cast(f as varchar(50))  from foo;
select cast(f as nchar(50))    from foo;
select cast(f as nchar varying(50)) from foo;
select cast(r as int)          from foo;
select cast(r as smallint)     from foo;
select cast(r as numeric(5,2)) from foo;
select cast(r as float)        from foo;
select cast(r as double)       from foo;
select cast(r as monetary)     from foo;
select cast(r as char(50))     from foo;
select cast(r as varchar(50))  from foo;
select cast(r as nchar(50))    from foo;
select cast(r as nchar varying(50)) from foo;
select cast(d as int)          from foo;
select cast(d as smallint)     from foo;
select cast(d as numeric(5,2)) from foo;
select cast(d as float)        from foo;
select cast(d as double)       from foo;
select cast(d as monetary)     from foo;
select cast(d as char(50))     from foo;
select cast(d as varchar(50))  from foo;
select cast(d as nchar(50))    from foo;
select cast(d as nchar varying(50)) from foo;
select cast($12.34 as int)          from class db_user;
select cast(m      as int)          from foo;
select cast($12.34 as smallint)     from class db_user;
select cast(m      as smallint)     from foo;
select cast($12.34 as numeric(7,2)) from class db_user;
select cast(m      as numeric(7,2)) from foo;
select cast($12.34 as double)       from class db_user;
select cast(m      as double)       from foo;
select cast($12.34 as float)        from class db_user;
select cast(m      as float)        from foo;
select cast($12.34 as char(50))     from class db_user;
select cast(m      as char(50))     from foo;
select cast($12.34 as varchar(50))  from class db_user;
select cast(m      as varchar(50))  from foo;
select cast($12.34 as nchar(50))    from class db_user;
select cast(m      as nchar(50))    from foo;
select cast($12.34 as nchar varying(50)) from class db_user;
select cast(m      as nchar varying(50)) from foo;
select cast('123'    as int)                   from class db_user;
select cast('123'    as smallint)              from class db_user;
select cast('123'    as numeric(7,2))          from class db_user;
select cast('123'    as float)                 from class db_user;
select cast('123'    as double)                from class db_user;
select cast('123'    as monetary)              from class db_user;
select cast('123'    as char(5))               from class db_user;
select cast('123'    as varchar(5))            from class db_user;
select cast(N'123'   as nchar(5))              from class db_user;
select cast(N'123'   as nchar varying(5))           from class db_user;
select cast(b'101'   as bit(16))                from class db_user;
select cast(b'101'   as bit varying(16))        from class db_user;
select cast('1/1/94' as date)                  from class db_user;
select cast('11:00'  as time)                  from class db_user;
select cast('1/1/1994 11:00' as timestamp)       from class db_user;
select cast(b'10101' as bit(16))       from class db_user;
select cast(b        as bit(16))       from foo;
select cast(b'10101' as bit varying(16))    from class db_user;
select cast(b        as bit varying(16))    from foo;
select cast(b'10101' as char(50))     from class db_user;
select cast(b        as char(50))     from foo;
select cast(b'10101' as varchar(50))  from class db_user;
select cast(b        as varchar(50))  from foo;
select cast(b'10101' as nchar(50))    from class db_user;
select cast(b        as nchar(50))    from foo;
select cast(b'10101' as nchar varying(50)) from class db_user;
select cast(b        as nchar varying(50)) from foo;
select cast(vb  as bit(16))       from foo;
select cast(vb  as bit varying(16))    from foo;
select cast(vb  as char(50))     from foo;
select cast(vb  as varchar(50))  from foo;
select cast(vb  as nchar(50))    from foo;
select cast(vb  as nchar varying(50)) from foo;
select cast(date '10/09/1994' as date)         from class db_user;
select cast(dt                as date)         from foo;
select cast(date '10/09/1994' as timestamp)    from class db_user;
select cast(dt                as timestamp)    from foo;
select cast(date '10/09/1994' as char(50))     from class db_user;
select cast(dt                as char(50))     from foo;
select cast(date '10/09/1994' as varchar(50))  from class db_user;
select cast(dt                as varchar(50))  from foo;
select cast(date '10/09/1994' as nchar(50))    from class db_user;
select cast(dt                as nchar(50))    from foo;
select cast(date '10/09/1994' as nchar varying(50)) from class db_user;
select cast(dt                as nchar varying(50)) from foo;
select cast(time '12:33 PM' as time)         from class db_user;
select cast(t               as time)         from foo;
select cast(time '12:33 PM' as char(50))     from class db_user;
select cast(t               as char(50))     from foo;
select cast(time '12:33 PM' as varchar(50))  from class db_user;
select cast(t               as varchar(50))  from foo;
select cast(time '12:33 PM' as nchar(50))    from class db_user;
select cast(t               as nchar(50))    from foo;
select cast(time '12:33 PM' as nchar varying(50)) from class db_user;
select cast(t               as nchar varying(50)) from foo;
select cast(timestamp '01/14/1994 12:34 PM' as timestamp)
       from class db_user;
select cast(ut                              as timestamp)
       from foo;
select cast(timestamp '01/14/1994 12:34 PM' as time)
       from class db_user;
select cast(ut                              as time)
       from foo;
select cast(timestamp '01/14/1994 12:34 PM' as date)
       from class db_user;
select cast(ut                              as date)
       from foo;
select cast(timestamp '01/14/1994 12:34 PM' as char(50))
       from class db_user;
select cast(ut                              as char(50))
       from foo;
select cast(timestamp '01/14/1994 12:34 PM' as varchar(50))
       from class db_user;
select cast(ut                              as varchar(50))
       from foo;
select cast(timestamp '01/14/1994 12:34 PM' as nchar(50))
       from class db_user;
select cast(ut                              as nchar(50))
       from foo;
select cast(timestamp '01/14/1994 12:34 PM' as nchar varying(50))
       from class db_user;
select cast(ut                              as nchar varying(50))
       from foo;
select cast(set{1,2} as set)          from class db_user;
select cast(si       as set)          from foo;
select cast(set{1,2} as multiset)     from class db_user;
select cast(si       as multiset)     from foo;
select cast(multiset{1,2} as set)          from class db_user;
select cast(ms            as set)          from foo;
select cast(multiset{1,2} as multiset)     from class db_user;
select cast(ms            as multiset)     from foo;
select cast(sequence{1,2} as sequence) from class db_user;
select cast(sq            as sequence) from foo;
drop foo;
rollback;
