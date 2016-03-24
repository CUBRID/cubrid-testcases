autocommit off;
create class bar (a int);
insert into bar values(1) into :b1;
insert into bar values(2) into :b2;
insert into bar values(3) into :b3;
insert into bar values(4) into :b4;
insert into bar values(5) into :b5;
insert into bar values(6) into :b6;
create class foo (i int, f float, d double, c character(20), 
		  t time, ts timestamp, dt date, m monetary, sh short, 
		  n numeric(5, 2), b bit(12), vb bit varying(12), 
		  vc character varying(20), nc nchar(20), 
		  vnc nchar varying(20), bar_ptr bar);
--set optimization: level 257;
/* first try indexes created before the instances are inserted */
create index idx1 on foo(i);
create index idx2 on foo(f);
create index idx3 on foo(d);
create index idx4 on foo(vc);
create index idx5 on foo(t);
create index idx6 on foo(ts);
create index idx7 on foo(dt);
create index idx8 on foo(m);
create index idx9 on foo(sh);
create index idx10 on foo(n);
create index idx11 on foo(b);
create index idx12 on foo(vb);
create index idx13 on foo(c);
create index idx14 on foo(nc);
create index idx15 on foo(vnc);
create index idx16 on foo(bar_ptr);
insert into foo values
   (1, 1.1e0, 1.1e0, 'character 1', time '10:21 PM', 
    timestamp '01/10/1991 10:21 PM', date '01/10/1991', $1.11,
    1, 1.1, b'10101', b'10101', 'var character 1', 
    n'ncharacter 1', n'var ncharacter 1', :b1);
insert into foo values
   (2, 2.2e0, 2.2e0, 'character 2', time '10:22 PM', 
    timestamp '02/20/1992 10:22 PM', date '02/20/1992', $2.22,
    2, 2.2, b'101011', b'101011', 'var character 2', 
    n'ncharacter 2', n'var ncharacter 2', :b2);
insert into foo values
   (3, 3.3e0, 3.3e0, 'character 3', time '10:23 PM', 
    timestamp '03/30/1993 10:23 PM', date '03/30/1993', $3.33,
    3, 3.3, b'1010111', b'1010111', 'var character 3', 
    n'ncharacter 3', n'var ncharacter 3', :b3);
insert into foo values
   (4, 4.4e0, 4.4e0, 'character 4', time '10:24 PM', 
    timestamp '04/10/1994 10:24 PM', date '04/10/1994', $4.44,
    4, 4.4, b'10101111', b'10101111', 'var character 4',
    n'ncharacter 4', n'var ncharacter 4', :b4);
insert into foo values
   (5, 5.5e0, 5.5e0, 'character 5', time '10:25 PM', 
    timestamp '05/10/1995 10:25 PM', date '05/10/1995', $5.55,
    5, 5.5, b'101011111', b'101011111', 'var character 5', 
    n'ncharacter 5', n'var ncharacter 5', :b5);
insert into foo values
   (6, 6.6e0, 6.6e0, 'character 6', time '10:26 PM', 
    timestamp '06/10/1996 10:26 PM', date '06/10/1996', $6.66,
    6, 6.6, b'1010111111', b'1010111111', 'var character 6', 
    n'ncharacter 6', n'var ncharacter 6', :b6);
select i from foo where i = 3;
select i from foo where i < 3;
select i from foo where i between 4 and 5;
select i from foo where f > 3.0e0 and f < 3.31e0;
select i from foo where f < 3.3e0;
select i from foo where f between 4.0e0 and 5.6e0;
select i from foo where d > 3.0e0 and d < 3.31e0;
select i from foo where d < 3.3e0;
select i from foo where d between 4.0e0 and 5.6e0;
select i from foo where vc = 'var character 3';
select i from foo where vc < 'var character 3';
select i from foo where vc between 'var character 4' and 'var character 5';
select i from foo where bar_ptr = :b3;
select i from foo where bar_ptr = :b1 or bar_ptr = :b2;
select i from foo where bar_ptr = :b4 or bar_ptr = :b5;
select i from foo where t = time '10:23 PM';
select i from foo where t < time '10:23 PM';
select i from foo where t between time '10:24 PM' and time '10:25 PM';
select i from foo where ts = timestamp '03/30/1993 10:23 PM';
select i from foo where ts < timestamp '03/30/1993 10:23 PM';
select i from foo where ts between timestamp '04/10/1994 10:24 PM'
 		           and timestamp '05/10/1995 10:25 PM';
select i from foo where dt = date '03/30/1993';
select i from foo where dt < date '03/30/1993';
select i from foo where dt between date '04/10/1994' and date '05/10/1995';
select i from foo where m > $3.0 and m < $3.331;
select i from foo where m < $3.3;
select i from foo where m between $4.0 and $5.6;
select i from foo where sh = 3;
select i from foo where sh < 3;
select i from foo where sh between 4 and 5;
select i from foo where n = 3.3;
select i from foo where n < 3.3;
select i from foo where n between 4.4 and 5.5;
select i from foo where b = cast(b'1010111' as bit(20));
select i from foo where b < b'1010111';
select i from foo where b between b'10101111' and cast(b'101011111' as bit(20));
select i from foo where vb = b'1010111';
select i from foo where vb < b'1010111';
select i from foo where vb between b'10101111' and b'101011111';
select i from foo where c = 'character 3';
select i from foo where c < 'character 3';
select i from foo where c between 'character 4' and 'character 5';
select i from foo where nc = n'ncharacter 3';
select i from foo where nc < n'ncharacter 3';
select i from foo where nc between n'ncharacter 4' and n'ncharacter 5';
select i from foo where vnc = n'var ncharacter 3';
select i from foo where vnc < n'var ncharacter 3';
select i from foo where vnc between n'var ncharacter 4' and n'var ncharacter 5';
/* now test bt_load (insert before index creation) */
delete from foo;
drop index idx1 on foo(i);
drop index idx2 on foo(f);
drop index idx3 on foo(d);
drop index idx4 on foo(vc);
drop index idx5 on foo(t);
drop index idx6 on foo(ts);
drop index idx7 on foo(dt);
drop index idx8 on foo(m);
drop index idx9 on foo(sh);
drop index idx10 on foo(n);
drop index idx11 on foo(b);
drop index idx12 on foo(vb);
drop index idx13 on foo(c);
drop index idx14 on foo(nc);
drop index idx15 on foo(vnc);
drop index idx16 on foo(bar_ptr);
insert into foo values
   (1, 1.1e0, 1.1e0, 'character 1', time '10:21 PM', 
    timestamp '01/10/1991 10:21 PM', date '01/10/1991', $1.11,
    1, 1.1, b'10101', b'10101', 'var character 1', 
    n'ncharacter 1', n'var ncharacter 1', :b1);
insert into foo values
   (2, 2.2e0, 2.2e0, 'character 2', time '10:22 PM', 
    timestamp '02/20/1992 10:22 PM', date '02/20/1992', $2.22,
    2, 2.2, b'101011', b'101011', 'var character 2', 
    n'ncharacter 2', n'var ncharacter 2', :b2);
insert into foo values
   (3, 3.3e0, 3.3e0, 'character 3', time '10:23 PM', 
    timestamp '03/30/1993 10:23 PM', date '03/30/1993', $3.33,
    3, 3.3, b'1010111', b'1010111', 'var character 3', 
    n'ncharacter 3', n'var ncharacter 3', :b3);
insert into foo values
   (4, 4.4e0, 4.4e0, 'character 4', time '10:24 PM', 
    timestamp '04/10/1994 10:24 PM', date '04/10/1994', $4.44,
    4, 4.4, b'10101111', b'10101111', 'var character 4',
    n'ncharacter 4', n'var ncharacter 4', :b4);
insert into foo values
   (5, 5.5e0, 5.5e0, 'character 5', time '10:25 PM', 
    timestamp '05/10/1995 10:25 PM', date '05/10/1995', $5.55,
    5, 5.5, b'101011111', b'101011111', 'var character 5', 
    n'ncharacter 5', n'var ncharacter 5', :b5);
insert into foo values
   (6, 6.6e0, 6.6e0, 'character 6', time '10:26 PM', 
    timestamp '06/10/1996 10:26 PM', date '06/10/1996', $6.66,
    6, 6.6, b'1010111111', b'1010111111', 'var character 6', 
    n'ncharacter 6', n'var ncharacter 6', :b6);
create index idx1 on foo(i);
create index idx2 on foo(f);
create index idx3 on foo(d);
create index idx4 on foo(vc);
create index idx5 on foo(t);
create index idx6 on foo(ts);
create index idx7 on foo(dt);
create index idx8 on foo(m);
create index idx9 on foo(sh);
create index idx10 on foo(n);
create index idx11 on foo(b);
create index idx12 on foo(vb);
create index idx13 on foo(c);
create index idx14 on foo(nc);
create index idx15 on foo(vnc);
create index idx16 on foo(bar_ptr);
select i from foo where i = 3;
select i from foo where i < 3;
select i from foo where i between 4 and 5;
select i from foo where f > 3.0e0 and f < 3.31e0;
select i from foo where f < 3.3e0;
select i from foo where f between 4.0e0 and 5.6e0;
select i from foo where d > 3.0e0 and d < 3.31e0;
select i from foo where d < 3.3e0;
select i from foo where d between 4.0e0 and 5.6e0;
select i from foo where vc = 'var character 3';
select i from foo where vc < 'var character 3';
select i from foo where vc between 'var character 4' and 'var character 5';
select i from foo where bar_ptr = :b3;
select i from foo where bar_ptr = :b1 or bar_ptr = :b2;
select i from foo where bar_ptr = :b4 or bar_ptr = :b5;
select i from foo where t = time '10:23 PM';
select i from foo where t < time '10:23 PM';
select i from foo where t between time '10:24 PM' and time '10:25 PM';
select i from foo where ts = timestamp '03/30/1993 10:23 PM';
select i from foo where ts < timestamp '03/30/1993 10:23 PM';
select i from foo where ts between timestamp '04/10/1994 10:24 PM'
 		           and timestamp '05/10/1995 10:25 PM';
select i from foo where dt = date '03/30/1993';
select i from foo where dt < date '03/30/1993';
select i from foo where dt between date '04/10/1994' and date '05/10/1995';
select i from foo where m > $3.0 and m < $3.331;
select i from foo where m < $3.3;
select i from foo where m between $4.0 and $5.6;
select i from foo where sh = 3;
select i from foo where sh < 3;
select i from foo where sh between 4 and 5;
select i from foo where n = 3.3;
select i from foo where n < 3.3;
select i from foo where n between 4.4 and 5.5;
select i from foo where b = cast(b'1010111' as bit(20));
select i from foo where b < b'1010111';
select i from foo where b between b'10101111' and cast(b'101011111' as bit(20));
select i from foo where vb = b'1010111';
select i from foo where vb < b'1010111';
select i from foo where vb between b'10101111' and b'101011111';
select i from foo where c = 'character 3';
select i from foo where c < 'character 3';
select i from foo where c between 'character 4' and 'character 5';
select i from foo where nc = n'ncharacter 3';
select i from foo where nc < n'ncharacter 3';
select i from foo where nc between n'ncharacter 4' and n'ncharacter 5';
select i from foo where vnc = n'var ncharacter 3';
select i from foo where vnc < n'var ncharacter 3';
select i from foo where vnc between n'var ncharacter 4' and n'var ncharacter 5';

drop foo, bar;
rollback;
