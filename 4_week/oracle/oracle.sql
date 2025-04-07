SELECT lname, fname, residence, COUNT(*) AS pocet_zaznamu
FROM Customer
GROUP BY lname, fname, residence;

SELECT lname, fname, COUNT(*) AS pocet_zaznamu
FROM Customer
GROUP BY lname, fname;

SELECT lname, residence, COUNT(*) AS pocet_zaznamu
FROM Customer
GROUP BY lname, residence;


select * from table(dbms_xplan.display);

call PrintQueryStat('711gdavf8dv47', 2844954298);

select * from customer;

select * from CUSTOMER
where lname like 'Veselá' and fname like 'Věra' and RESIDENCE like 'Jihlava';

select count(*) from CUSTOMER
where lname like 'Veselá' and fname like 'Věra' and RESIDENCE like 'Jihlava';


explain plan for select * from CUSTOMER
where lname like 'Veselá' and fname like 'Věra' and RESIDENCE like 'Jihlava';


SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;

-- obyč bez indexu
-- SQL_ID 47jw0kaprt30d
-- Plan hash value: 2844954298


-- s indexem na customer na 3 atributy
-- SQL_ID 711gdavf8dv47 - s indexem
-- Plan hash value: 3304523282 - s indexem


SELECT SQL_ID, PLAN_HASH_VALUE
FROM V$SQL
WHERE PLAN_HASH_VALUE = 3304523282;


call PrintQueryStat('711gdavf8dv47', 3304523282);




CREATE INDEX CUSTOMER_NAME_RES ON CUSTOMER(LNAME, FNAME, RESIDENCE); -- 896ms

ANALYZE INDEX CUSTOMER_NAME_RES VALIDATE STRUCTURE;

SELECT index_name, num_rows, leaf_blocks, distinct_keys
FROM user_indexes
WHERE index_name = 'CUSTOMER_NAME_RES';



DROP INDEX CUSTOMER_NAME_RES; --pozor všechno musí být capslock

select name, height-1 as h, blocks, lf_blks as leaf_pages, br_blks as inner_pages, lf_rows as leaf_items,
  br_rows as inner_items, pct_used
from index_stats where name like 'CUSTOMER_NAME_RES';

SELECT segment_name, segment_type, blocks, bytes / 1024 / 1024
FROM user_segments
WHERE segment_name='CUSTOMER_NAME_RES';

call PrintPages_space_usage('customer_name_res', 'RUZ0096', 'INDEX');

select index_name, TABLE_NAME from user_indexes
where TABLE_NAME = 'CUSTOMER';

explain plan for SELECT MIN(record_count) AS min_count, MAX(record_count) AS max_count
FROM (
    SELECT LNAME, FNAME, COUNT(*) AS record_count
    FROM CUSTOMER
    GROUP BY LNAME, FNAME
) subquery;

select * from table(dbms_xplan.display);

call PrintQueryStat('###', ###);

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;

call PRINTPAGES('CUSTOMER', 'RUZ0096')
