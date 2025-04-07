select blocks from user_segments
where segment_name = 'CUSTOMER';
-- 2048

select index_name from user_indexes
where table_name='CUSTOMER';
-- SYS_C0023185

select blocks from user_segments
where segment_name = 'SYS_C0023185';
-- 640




begin
    PrintPages('CUSTOMER','RUZ0096');
end;


CREATE TABLE Customer_IOT (
  idCustomer INT PRIMARY KEY,
  fName VARCHAR2(20) NOT NULL,
  lName VARCHAR2(30) NOT NULL,
  residence VARCHAR2(20) NOT NULL,
  gender CHAR(1) NOT NULL,
  birthday DATE NOT NULL
) ORGANIZATION INDEX;

INSERT INTO Customer_IOT
SELECT * FROM Customer;


select * from USER_SEGMENTS
where segment_name = 'CUSTOMER';
-- TODO

select index_name from user_indexes
where table_name='CUSTOMER_IOT';
-- SYS_IOT_TOP_323554

select blocks from user_segments
where segment_name = 'SYS_IOT_TOP_323554';
-- 2176

begin
    PrintPages('CUSTOMER_IOT','RUZ0096');
end;

--[2025-03-24 21:37:41] completed in 19 ms
--blocks: 2176
--size (MB): 17
--used_blocks: 2176
--size used (MB): 17
--unused_blocks: 0
--size unused (MB): 0


alter table CUSTOMER_IOT shrink space;

select blocks from user_segments
where segment_name = 'SYS_IOT_TOP_323554';
begin
    PrintPages('CUSTOMER_IOT','RUZ0096');
end;
--[2025-03-24 21:48:58] completed in 17 ms
--blocks: 1976
--size (MB): 15.4375
--used_blocks: 1974
--size used (MB): 15.421875
--unused_blocks: 2
--size unused (MB): .015625






select * from CUSTOMER_IOT
where idCustomer = 66;

-----------------------------


explain plan for
select * from CUSTOMER_IOT
where idCustomer = 66;

select * from table(dbms_xplan.display);
-- Plan hash value: 1807541868


SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;
-- 8801zxqv9z2vw

begin
    PrintQueryStat('8801zxqv9z2vw', 1807541868);
end;


select count(*) from CUSTOMER_IOT where fname = 'Věra' and lname = 'Veselá' and residence = 'Jihlava';
select * from CUSTOMER_IOT where fname = 'Věra' and lname = 'Veselá' and residence = 'Jihlava';


explain plan for
select * from CUSTOMER_IOT where fname = 'Věra' and lname = 'Veselá' and residence = 'Jihlava';

select * from table(dbms_xplan.display);
-- Plan hash value: 3786218707
SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;
-- 32vfrytnn7fw0

begin
    PrintQueryStat('32vfrytnn7fw0', 3786218707);
end;
---- Query Processing Statistics ----
--executions: 	2
--buffer gets: 	1945
--cpu_time_ms: 	14.7195
--elapsed_time_ms: 	19.639
--rows_processed: 	74
--username: 	RUZ0096
--query: 	select * from CUSTOMER_IOT where fname = 'Věra' and lname = 'Veselá' and residence = 'Jihlava'





CREATE INDEX CUSTOMER_IOT_NAME_RES ON CUSTOMER_IOT(LNAME, FNAME, RESIDENCE);
-- [2025-03-24 23:51:50] completed in 2 s 457 ms

explain plan for
select * from CUSTOMER_IOT where fname = 'Věra' and lname = 'Veselá' and residence = 'Jihlava';

select * from table(dbms_xplan.display);
-- Plan hash value: 1308435866

SELECT sql_id, sql_text, last_active_time
FROM v$sql
WHERE parsing_schema_name = 'RUZ0096'
ORDER BY last_active_time DESC;
-- 32vfrytnn7fw0


begin
    PrintQueryStat('32vfrytnn7fw0', 1308435866);
end;








-- vubec nvm co jsem tu robil


select index_name from user_indexes
where table_name='CUSTOMER_IOT';
-- CUSTOMER_IOT_NAME_RES
-- SYS_IOT_TOP_323554


begin
    PrintPages('CUSTOMER_IOT','RUZ0096');
end;
--[2025-03-24 23:53:56] completed in 18 ms
--blocks: 1976
--size (MB): 15.4375
--used_blocks: 1974
--size used (MB): 15.421875
--unused_blocks: 2
--size unused (MB): .015625


exec PrintPages('ORDERITEM','KRA28', 'TABLE'); -- ????????
exec PrintPages('ORDERITEM_UNITPRICE','KRA28', 'INDEX'); -- ????????

begin
    PrintPages('CUSTOMER_IOT_NAME_RES','RUZ0096');
end;



select blocks from user_segments where segment_name='CUSTOMER_IOT_NAME_RES';
--1920
select blocks from user_segments where segment_name='SYS_IOT_TOP_323554';
--1976
