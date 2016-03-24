--Test decode() function using date datetype

Create serial Seq_t1
start with 1001
nomaxvalue;

Create class t1(a integer, b date, c varchar(20));

insert into t1 values(seq_t1.next_value, date'05/10/2008','Jerry');
insert into t1 values(seq_t1.next_value, date'03/10/2008','Tom');
insert into t1 values(seq_t1.next_value, date'06/11/2008','Kitty');
insert into t1 values(seq_t1.next_value, date'02/12/2008','Atom');
insert into t1 values(seq_t1.next_value, date'01/01/2008','Nancy');
insert into t1 values(seq_t1.next_value, date'11/01/2008','Cat');

select a, decode(extract(month from b), 
                 3, 'Mar',
                 5, 'May',
                 6, 'Jun',
                 2, 'Feb',
                 1, 'Jan', 'Other'), c
from t1 order by 1;

drop class t1;
drop serial Seq_t1;                                        
