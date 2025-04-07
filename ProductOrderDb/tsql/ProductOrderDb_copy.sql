-- ProductOrderDb, A database for Physical Database Design
-- SQL Server Version
--
-- Michal Kratky, Radim Baca
-- dbedu@cs.vsb.cz, 2023-2024
-- last update: 2025-02-21

insert into Customer select * from ProductOrder.dbo.Customer;
insert into Product select * from ProductOrder.dbo.Product;
insert into Store select * from ProductOrder.dbo.Store;
insert into Staff select * from ProductOrder.dbo.Staff;
insert into "Order" select * from ProductOrder.dbo."Order";
insert into OrderItem select * from ProductOrder.dbo.OrderItem;