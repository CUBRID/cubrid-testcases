--[er]test substring function using date and other type as its operand
select substring(date'7/2/2003') from db_root;
select substring(date'7/2/2003' for) from db_root;
select substring(date'7/2/2003' for  from ) from db_root;

select substring(date'7/2/2003' for 10 from 10) from db_root;
select substring(date'7/2/2003' for 10 from 10.11) from db_root;
select substring(date'7/2/2003' for 10 from 'char111') from db_root;
select substring(date'7/2/2003' for 10 from n'nchar111') from db_root;
select substring(date'7/2/2003' for 10 from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for 10 from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for 10 from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for 10 from {3,4,5}) from db_root;
select substring(date'7/2/2003' for 10 from b'01001000') from db_root;

select substring(date'7/2/2003' for 10.11 from 10) from db_root;
select substring(date'7/2/2003' for 10.11 from 10.11) from db_root;
select substring(date'7/2/2003' for 10.11 from 'char111') from db_root;
select substring(date'7/2/2003' for 10.11 from n'nchar111') from db_root;
select substring(date'7/2/2003' for 10.11 from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for 10.11  from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for 10.11 from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for 10.11 from {3,4,5}) from db_root;
select substring(date'7/2/2003' for 10.11 from b'01001000') from db_root;

select substring(date'7/2/2003' for 'char111' from 10) from db_root;
select substring(date'7/2/2003' for 'char111' from 10.11) from db_root;
select substring(date'7/2/2003' for 'char111' from 'char111') from db_root;
select substring(date'7/2/2003' for 'char111' from n'nchar111') from db_root;
select substring(date'7/2/2003' for 'char111' from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for 'char111' from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for 'char111' from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for 'char111' from {3,4,5}) from db_root;
select substring(date'7/2/2003' for 'char111' from b'01001000') from db_root;

select substring(date'7/2/2003' for n'nchar111' from 10) from db_root;
select substring(date'7/2/2003' for n'nchar111' from 10.11) from db_root;
select substring(date'7/2/2003' for n'nchar111' from 'char111') from db_root;
select substring(date'7/2/2003' for n'nchar111' from n'nchar111') from db_root;
select substring(date'7/2/2003' for n'nchar111' from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for n'nchar111' from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for n'nchar111' from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for n'nchar111' from {3,4,5}) from db_root;
select substring(date'7/2/2003' for n'nchar111' from b'01001000') from db_root;

select substring(date'7/2/2003' for date'1/1/2001' from 10) from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from 10.11) from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from 'char111') from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from n'nchar111') from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from {3,4,5}) from db_root;
select substring(date'7/2/2003' for date'1/1/2001' from b'01001000') from db_root;

select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from 10) from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from 10.11) from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from 'char111') from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from n'nchar111') from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from {3,4,5}) from db_root;
select substring(date'7/2/2003' for timestamp'1/1/2001 2:2:2 am' from b'01001000') from db_root;

select substring(date'7/2/2003' for {3,4,5} from 10) from db_root;
select substring(date'7/2/2003' for {3,4,5} from 10.11) from db_root;
select substring(date'7/2/2003' for {3,4,5} from 'char111') from db_root;
select substring(date'7/2/2003' for {3,4,5} from n'nchar111') from db_root;
select substring(date'7/2/2003' for {3,4,5} from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for {3,4,5} from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for {3,4,5} from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for {3,4,5} from {3,4,5}) from db_root;
select substring(date'7/2/2003' for {3,4,5} from b'01001000') from db_root;

select substring(date'7/2/2003' for b'01001000' from 10) from db_root;
select substring(date'7/2/2003' for b'01001000' from 10.11) from db_root;
select substring(date'7/2/2003' for b'01001000' from 'char111') from db_root;
select substring(date'7/2/2003' for b'01001000' from n'nchar111') from db_root;
select substring(date'7/2/2003' for b'01001000' from date'1/1/2001') from db_root;
select substring(date'7/2/2003' for b'01001000' from time'2:2:3 am') from db_root;
select substring(date'7/2/2003' for b'01001000' from timestamp'1/1/2001 2:2:3 am') from db_root;
select substring(date'7/2/2003' for b'01001000' from {3,4,5}) from db_root;
select substring(date'7/2/2003' for b'01001000' from b'01001000') from db_root;
