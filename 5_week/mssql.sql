exec PrintPagesHeap 'Customer';


SELECT
    ix.name AS Index_Name,
    ips.page_count AS Page_Count
FROM
    sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('Customer'), NULL, NULL, 'DETAILED') ips
JOIN
    sys.indexes ix ON ips.OBJECT_ID = ix.OBJECT_ID
WHERE
    ix.is_primary_key = 1 -- Primární index
    AND OBJECT_NAME(ips.OBJECT_ID) = 'Customer';
-- 669





create or alter procedure PrintPagesClusterTable
  @tableName varchar(30)
as
  exec PrintPages @tableName, 1



--create clustered index Customer_Clustered on Customer(idCustomer);

-- Vytvoření nové tabulky clustered_customer s shlukovaným indexem na idCustomer
CREATE TABLE clustered_customer (
  idCustomer INT PRIMARY KEY,  -- primární klíč, automaticky vytvoří shlukovaný index
  fName VARCHAR(20) NOT NULL,
  lName VARCHAR(30) NOT NULL,
  residence VARCHAR(20) NOT NULL,
  gender CHAR(1) NOT NULL,
  birthday DATE NOT NULL
);


INSERT INTO clustered_customer (idCustomer, fName, lName, residence, gender, birthday)
SELECT idCustomer, fName, lName, residence, gender, birthday
FROM Customer;









exec PrintPagesClusterTable 'clustered_customer';
-- TotalPages: 1697
-- Used Pages: 1679

exec PrintPagesHeap 'customer';
-- Total Pages: 1753
-- Used Pages: 1751
--------------------------------

SELECT
t.NAME AS TableName, i.name, i.type_desc, p.rows AS RowCounts,
a.total_pages AS TotalPages, a.used_pages AS UsedPages
FROM sys.tables t
INNER JOIN
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN
    sys.partitions p ON i.object_id = p.OBJECT_ID AND
    i.index_id = p.index_id
INNER JOIN
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.NAME = 'customer' and p.index_id > 1
-- Customer,PK__Customer__D05876877999DE39,NONCLUSTERED,300000,673,673
--Customer,CUSTOMER_NAME_RES,NONCLUSTERED,300000,1874,1623



----------------------------------

select i.name, s.index_level as level, s.page_count, s.record_count,
  s.avg_record_size_in_bytes as avg_record_size,
  round(s.avg_page_space_used_in_percent,1) as page_utilization,
  round(s.avg_fragmentation_in_percent,2) as avg_frag
from sys.dm_db_index_physical_stats(DB_ID(N'ruz0096'), OBJECT_ID(N'customer'), NULL, NULL , 'DETAILED') s
join sys.indexes i on s.object_id=i.object_id and s.index_id=i.index_id
-- where name='PK__Customer__D058768742B8AE8D'

--clustered
-- page_count record_count average_rec_size, page_utilization, average_frag
--PK__clustere__D05876869C244A5F,0,1672,300000,42.997,99.7,0.06
--PK__clustere__D05876869C244A5F,1,5,1672,11,53.7,0
--PK__clustere__D05876869C244A5F,2,1,5,11,0.8,0



alter table clustered_customer rebuild;
--RUZ0096> alter table clustered_customer rebuild
--[2025-03-25 00:39:49] completed in 1 s 99 ms

exec PrintPagesClusterTable 'clustered_customer';
-- Total: 2185
-- USED: 1749

exec PrintPagesHeap 'customer';
-- TOtal: 1753
-- USED: 1751



--drop index PK__OrderIte__CD443163B0970E7F on OrderItem;

select * from clustered_customer where idCustomer = 81;

----------------------------------------
set statistics time off;
set statistics io off;
set showplan_text off;

set statistics time on;
set statistics time off;
set statistics io on;
set statistics io off;
set showplan_text on;
set showplan_text off;

select * from clustered_customer where idCustomer = 81
option (maxdop 1);


select * from sys.dm_exec_query_stats

SELECT
qs.sql_handle,
qs.execution_count,
qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time,
st.text AS sql_text,
qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE st.text LIKE '%clustered_customer%'; -- Nebo jiná část tvého dotazu
-- avg_elapsed_time: 99

----------------------------------------
-- LNAME, FNAME, RESIDENCE
set statistics time on;
set statistics time off;
set statistics io on;
set statistics io off;
set showplan_text on;
set showplan_text off;

select *
from clustered_customer
where lname like 'Kučerová' and fname like 'Věra' and residence like 'Bohumín'
option (maxdop 1);


create index clustered_customer_names_res_index on clustered_customer(LNAME, FNAME, RESIDENCE);

DROP INDEX clustered_customer_names_res_index ON clustered_customer;




--create index clustered_customer_names_res_index on clustered_customer(LNAME, FNAME, RESIDENCE)
--[2025-03-25 10:15:24] 1 row retrieved starting from 1 in 321 ms (execution: 21 ms, fetching: 300 ms)




SELECT qs.execution_count,
 SUBSTRING(qt.text,qs.statement_start_offset/2 +1,
                 (CASE WHEN qs.statement_end_offset = -1
                       THEN LEN(CONVERT(nvarchar(max), qt.text)) * 2
                       ELSE qs.statement_end_offset end -
                            qs.statement_start_offset
                 )/2
             ) AS query_text,
qs.total_worker_time/qs.execution_count AS avg_cpu_time, qp.dbid, qt.text
--   qs.plan_handle, qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) as qp
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
where qp.dbid=DB_ID() and qs.execution_count > 10
--and query_text LIKE '%SELECT * FROM clustered_customer%'
ORDER BY avg_cpu_time DESC;
