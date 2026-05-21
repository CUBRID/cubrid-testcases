/**
 * This test case verifies CBRD-26520:
 * XASL conversion drops SP call node 'next' link, causing arguments
 * after a nested SP call to be lost during execution.
 *
 * Coverage:
 * 1 - Nested SP call as 1st argument of 2-arg function
 * 2 - Nested SP call as 2nd argument of 2-arg function
 * 3 - Nested SP call as 1st argument of 3-arg function
 * 4 - Nested SP call as 2nd (middle) argument of 3-arg function
 * 5 - Nested SP call as 3rd (last) argument of 3-arg function
 */

create or replace function add_two(a int, b int) return int as
begin
    return a + b;
end;

create or replace function add_three(a int, b int, c int) return int as
begin
    return a + b + c;
end;

evaluate 'Case 1: nested SP call as 1st arg of 2-arg function';
select add_two(add_two(1, 2), 3);

evaluate 'Case 2: nested SP call as 2nd arg of 2-arg function';
select add_two(1, add_two(2, 3));

evaluate 'Case 3: nested SP call as 1st arg of 3-arg function';
select add_three(add_two(1, 2), 3, 4);

evaluate 'Case 4: nested SP call as middle arg of 3-arg function';
select add_three(1, add_two(2, 3), 4);

evaluate 'Case 5: nested SP call as last arg of 3-arg function';
select add_three(1, 2, add_two(3, 4));

drop function add_two;
drop function add_three;
