/*Script for creating functional and security data*/

create database Purchase_Order;

drop table PurchaseOrder;
CREATE TABLE PurchaseOrder(
Id int primary key not null,
createdDate datetime DEFAULT CURRENT_TIMESTAMP not null,
isApproved bit  DEFAULT 0 not null,
isReceived bit DEFAULT 0 not null
);

--truncate table purchase_order;

--select ident_current('purchase_order');

insert into purchase_order values
( 'tables', 0, 0),
( 'computers', 0, 0),
('lamps', 0, 0),
('papers', 0, 0),
('projectors', 0, 0)

--create a log file to store executed methods
drop table LogFile_receive;
CREATE TABLE LogTable_receive(
PURCHASEORDER_ID INT not null,
executed_user VARCHAR(25),
executed_moment DATETIME DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(PURCHASEORDER_ID)
);

DROP TABLE LogFile_create;
CREATE TABLE LogTable_create(
PURCHASEORDER_ID INT not null,
executed_user VARCHAR(25),
executed_moment DATETIME DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(PURCHASEORDER_ID)
);

DROP TABLE LogFile_approve;
CREATE TABLE LogTable_approve(
PURCHASEORDER_ID INT not null,
executed_user VARCHAR(25),
executed_moment DATETIME DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(PURCHASEORDER_ID)
);



--drop table method_audit;
create table method_audit(
audit_id int identity(1,1) not null,
obj_id int not null,
method_name varchar(50) not null,
method_params varchar(50),
executed_user varchar(25),
executed_moment datetime DEFAULT CURRENT_TIMESTAMP,
primary key(audit_id)
);
--delete all records in table method_audit
--truncate table method_audit;
--ALTER TABLE method_audit ADD CONSTRAINT df_time DEFAULT CURRENT_TIMESTAMP FOR executed_moment;


--create a log file to store executed methods
drop table method_log;
create table method_log(
log_id int identity(1,1) not null,
method_name varchar(255) not null,
method_params varchar(50),
order_id int not null DEFAULT 0,
item_id int not null DEFAULT 0,
supplier_id int not null DEFAULT 0,
executed_user varchar(25),
executed_moment datetime DEFAULT CURRENT_TIMESTAMP,
primary key(log_id)
);



--======================create database USER-ROLE============================== 
/*
create user "allice" without login;
create user "bob" without login;
create user "tom" without login;
*/
create login "bob_login" with password = 'pwdbob';
create user "bob_login" for login bob_login;


create login "tom_login" with password = 'pwdtom';
create user "tom_login" for login tom_login;

create login "allice_login" with password = 'pwdallice';
create user "allice_login" for login allice_login;

--create database role
create role manager;
create role staff;
create role employee;

--create application role
create application role staff with password = 'pwdstaff';
drop application role staff;



--add member (users) for role
ALTER ROLE manager ADD MEMBER tom_login;

ALTER ROLE staff ADD MEMBER bob_login;
ALTER ROLE staff ADD MEMBER allice_login;

ALTER ROLE employee ADD MEMBER bob_login;
ALTER ROLE employee ADD MEMBER tom_login;
ALTER ROLE employee ADD MEMBER allice_login;



--=================grant PERMISSION (privileges) to the roles=========================

/*
/*allow manager to update the column "isApproved" in table "purchase_order"*/
grant UPDATE  on dbo.purchase_order(isApproved) to manager ;

/*allow staff to insert new record in table "purchase_order"*/
grant INSERT on dbo.purchase_order to staff;
grant UPDATE on dbo.purchase_order(oItems, isReceived) to staff;

/*all employees can see table purchase_order */
grant SELECT on dbo.PurchaseOrder to employee;

/*all employees can see and create log table method_audit */
grant SELECT, INSERT on dbo.LogTable_create to employee;
grant SELECT, INSERT on dbo.LogTable_approve to employee;
grant SELECT, INSERT on dbo.LogTable_receive to employee;
*/

grant EXECUTE ON OBJECT::dbo.PurchaseOrder_isExisting to employee;
grant EXECUTE ON OBJECT::dbo.PurchaseOrder_update_isApproved to employee;
grant EXECUTE ON OBJECT::dbo.PurchaseOrder_update_isReceived to employee;

/*grant EXECUTE stored procedures to roles*/
grant EXECUTE ON OBJECT::dbo.PurchaseOrder_create to staff;
grant EXECUTE ON OBJECT::dbo.PurchaseOrder_receive to staff;

grant EXECUTE ON OBJECT::dbo.PurchaseOrder_isExisting to staff;
grant EXECUTE ON OBJECT::dbo.PurchaseOrder_isExisting to manager;

grant EXECUTE ON OBJECT::dbo.PurchaseOrder_approve to manager;