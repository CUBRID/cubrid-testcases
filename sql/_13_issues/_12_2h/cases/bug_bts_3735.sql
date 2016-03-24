SELECT CAST(9223372036854775807 as bigint) + TIME '11:59:59 pm'; 
SELECT CAST(-9223372036854775807 as bigint) + TIME '11:59:59 pm'; 
SELECT CAST(-922337203685477580888 as bigint) + TIME '11:59:59 pm';
SELECT cast(-0 as bigint)+time '11:59:59 pm'
SELECT cast((1-1) as bigint)+time '11:59:59 pm';