--[er]test substring function using null and other type as its operand
select substring(null) from db_root;
select substring(null for) from db_root;
select substring(null for  from ) from db_root;

select substring(null for 10 from 10) from db_root;
select substring(null for 10 from 10.11) from db_root;
select substring(null for 10 from 'char111') from db_root;
select substring(null for 10 from n'nchar111') from db_root;
select substring(null for 10 from date'1/1/2001') from db_root;
select substring(null for 10 from null) from db_root;
select substring(null for 10 from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for 10 from {3,4,5}) from db_root;
select substring(null for 10 from b'01001000') from db_root;

select substring(null for 10.11 from 10) from db_root;
select substring(null for 10.11 from 10.11) from db_root;
select substring(null for 10.11 from 'char111') from db_root;
select substring(null for 10.11 from n'nchar111') from db_root;
select substring(null for 10.11 from date'1/1/2001') from db_root;
select substring(null for 10.11  from null) from db_root;
select substring(null for 10.11 from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for 10.11 from {3,4,5}) from db_root;
select substring(null for 10.11 from b'01001000') from db_root;

select substring(null for 'char111' from 10) from db_root;
select substring(null for 'char111' from 10.11) from db_root;
select substring(null for 'char111' from 'char111') from db_root;
select substring(null for 'char111' from n'nchar111') from db_root;
select substring(null for 'char111' from date'1/1/2001') from db_root;
select substring(null for 'char111' from null) from db_root;
select substring(null for 'char111' from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for 'char111' from {3,4,5}) from db_root;
select substring(null for 'char111' from b'01001000') from db_root;

select substring(null for n'nchar111' from 10) from db_root;
select substring(null for n'nchar111' from 10.11) from db_root;
select substring(null for n'nchar111' from 'char111') from db_root;
select substring(null for n'nchar111' from n'nchar111') from db_root;
select substring(null for n'nchar111' from date'1/1/2001') from db_root;
select substring(null for n'nchar111' from null) from db_root;
select substring(null for n'nchar111' from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for n'nchar111' from {3,4,5}) from db_root;
select substring(null for n'nchar111' from b'01001000') from db_root;

select substring(null for date'1/1/2001' from 10) from db_root;
select substring(null for date'1/1/2001' from 10.11) from db_root;
select substring(null for date'1/1/2001' from 'char111') from db_root;
select substring(null for date'1/1/2001' from n'nchar111') from db_root;
select substring(null for date'1/1/2001' from date'1/1/2001') from db_root;
select substring(null for date'1/1/2001' from null) from db_root;
select substring(null for date'1/1/2001' from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for date'1/1/2001' from {3,4,5}) from db_root;
select substring(null for date'1/1/2001' from b'01001000') from db_root;

select substring(null for timestamp'1/1/2001 2:2:2 am' from 10) from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from 10.11) from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from 'char111') from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from n'nchar111') from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from date'1/1/2001') from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from null) from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from {3,4,5}) from db_root;
select substring(null for timestamp'1/1/2001 2:2:2 am' from b'01001000') from db_root;

select substring(null for {3,4,5} from 10) from db_root;
select substring(null for {3,4,5} from 10.11) from db_root;
select substring(null for {3,4,5} from 'char111') from db_root;
select substring(null for {3,4,5} from n'nchar111') from db_root;
select substring(null for {3,4,5} from date'1/1/2001') from db_root;
select substring(null for {3,4,5} from null) from db_root;
select substring(null for {3,4,5} from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for {3,4,5} from {3,4,5}) from db_root;
select substring(null for {3,4,5} from b'01001000') from db_root;

select substring(null for b'01001000' from 10) from db_root;
select substring(null for b'01001000' from 10.11) from db_root;
select substring(null for b'01001000' from 'char111') from db_root;
select substring(null for b'01001000' from n'nchar111') from db_root;
select substring(null for b'01001000' from date'1/1/2001') from db_root;
select substring(null for b'01001000' from null) from db_root;
select substring(null for b'01001000' from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(null for b'01001000' from {3,4,5}) from db_root;
select substring(null for b'01001000' from b'01001000') from db_root;

select substring(10 for null from 10) from db_root;
select substring(10 for null from 10.11) from db_root;
select substring(10 for null from 'char111') from db_root;
select substring(10 for null from n'nchar111') from db_root;
select substring(10 for null from date'1/1/2001') from db_root;
select substring(10 for null from null) from db_root;
select substring(10 for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(10 for null from {3,4,5}) from db_root;
select substring(10 for null from b'01001000') from db_root;

select substring(10.11 for null from 10) from db_root;
select substring(10.11 for null from 10.11) from db_root;
select substring(10.11 for null from 'char111') from db_root;
select substring(10.11 for null from n'nchar111') from db_root;
select substring(10.11 for null from date'1/1/2001') from db_root;
select substring(10.11 for null from null) from db_root;
select substring(10.11 for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(10.11 for null from {3,4,5}) from db_root;
select substring(10.11 for null from b'01001000') from db_root;

select substring('char111' for null from 10) from db_root;
select substring('char111' for null from 10.11) from db_root;
select substring('char111' for null from 'char111') from db_root;
select substring('char111' for null from n'nchar111') from db_root;
select substring('char111' for null from date'1/1/2001') from db_root;
select substring('char111' for null from null) from db_root;
select substring('char111' for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring('char111' for null from {3,4,5}) from db_root;
select substring('char111' for null from b'01001000') from db_root;

select substring(n'nchar111' for null from 10) from db_root;
select substring(n'nchar111' for null from 10.11) from db_root;
select substring(n'nchar111' for null from 'char111') from db_root;
select substring(n'nchar111' for null from n'nchar111') from db_root;
select substring(n'nchar111' for null from date'1/1/2001') from db_root;
select substring(n'nchar111' for null from null) from db_root;
select substring(n'nchar111' for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(n'nchar111' for null from {3,4,5}) from db_root;
select substring(n'nchar111' for null from b'01001000') from db_root;

select substring(date'1/1/2001' for null from 10) from db_root;
select substring(date'1/1/2001' for null from 10.11) from db_root;
select substring(date'1/1/2001' for null from 'char111') from db_root;
select substring(date'1/1/2001' for null from n'nchar111') from db_root;
select substring(date'1/1/2001' for null from date'1/1/2001') from db_root;
select substring(date'1/1/2001' for null from null) from db_root;
select substring(date'1/1/2001' for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(date'1/1/2001' for null from {3,4,5}) from db_root;
select substring(date'1/1/2001' for null from b'01001000') from db_root;

select substring(timestamp'1/1/2001 2:2:2 am' for null from 10) from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from 10.11) from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from 'char111') from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from n'nchar111') from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from date'1/1/2001') from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from null) from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from {3,4,5}) from db_root;
select substring(timestamp'1/1/2001 2:2:2 am' for null from b'01001000') from db_root;

select substring({3,4,5} for null from 10) from db_root;
select substring({3,4,5} for null from 10.11) from db_root;
select substring({3,4,5} for null from 'char111') from db_root;
select substring({3,4,5} for null from n'nchar111') from db_root;
select substring({3,4,5} for null from date'1/1/2001') from db_root;
select substring({3,4,5} for null from null) from db_root;
select substring({3,4,5} for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring({3,4,5} for null from {3,4,5}) from db_root;
select substring({3,4,5} for null from b'01001000') from db_root;

select substring(b'01001000' for null from 10) from db_root;
select substring(b'01001000' for null from 10.11) from db_root;
select substring(b'01001000' for null from 'char111') from db_root;
select substring(b'01001000' for null from n'nchar111') from db_root;
select substring(b'01001000' for null from date'1/1/2001') from db_root;
select substring(b'01001000' for null from null) from db_root;
select substring(b'01001000' for null from timestamp'1/1/2001 2:2:2 am') from db_root;
select substring(b'01001000' for null from {3,4,5}) from db_root;
select substring(b'01001000' for null from b'01001000') from db_root;



