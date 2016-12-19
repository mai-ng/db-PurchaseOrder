/*Script for creating stored procedures*/



--=====================BASIC PROCEDURES================================================
drop procedure NoReceive
CREATE PROCEDURE NoReceive
	@po int, @res bit OUTPUT
AS

	DECLARE @count int
	SELECT @count = COUNT(*) FROM dbo.PurchaseOrder WHERE Id = @po AND isReceived = 0
	IF(@count > 0)
		SET @res= 1
	ELSE
		SET @res = 0	
GO


--test
declare @res bit
EXEC NoReceive 4, @res OUTPUT
PRINT @res

--drop procedure purchase_order_isExisting;
CREATE PROCEDURE PurchaseOrder_isExisting
@po_id int, @isExisting int OUTPUT
AS
BEGIN
	SELECT @isExisting = COUNT(*) FROM dbo.PurchaseOrder WHERE Id = @po_id
END
GO

--DROP PROCEDURE purchase_order_update_isApproved
CREATE PROCEDURE PurchaseOrder_update_isApproved
@po_id int
AS
BEGIN
	UPDATE dbo.PurchaseOrder SET isApproved = 1
		WHERE Id = @po_id
		PRINT 'The order is successfully approved!'
END
GO



--DROP PROCEDURE purchase_order_update_receivedDate
CREATE PROCEDURE PurchaseOrder_update_isReceived
@po_id int
AS
BEGIN
	UPDATE dbo.PurchaseOrder SET isReceived = 1
		WHERE Id = @po_id
		PRINT 'The order is successfully approved!'
END
GO




--=====================COMPLEX PROCEDURES================================================



--create a procedure for method "purchase_order_create"
--drop procedure purchaseOrder_create;
create procedure PurchaseOrder_create(
@po_id int
)
AS
BEGIN
	INSERT INTO dbo.PurchaseOrder(Id) VALUES(@po_id)
	PRINT 'The purchase order is successfully created!'
END
GO



CREATE PROCEDURE PurchaseOrder_create(@po_id int)
AS
DECLARE @isExisting int
--check if the order (@oId) is existing?
	EXEC PurchaseOrder_isExisting @po_id, @isExisting OUTPUT
--update received date if the order is existing
IF(@isExisting > 0)
	PRINT 'The order is already existing!'
ELSE
	BEGIN
	INSERT INTO dbo.PurchaseOrder(Id) VALUES(@po_id)
		PRINT 'The purchase order is successfully created!'
	END
GO




/*create procedure "purchase_order_approve"*/
--drop procedure PurchaseOrder_approve;
create procedure PurchaseOrder_approve(
@po_Id int
)
AS
DECLARE @count int
SELECT @count = 0

--check if the order (@oId) is existing?
SELECT @count = COUNT(*) FROM PurchaseOrder WHERE Id = @po_id

--update isApproved = true if the order is existing
IF(@count = 0)
	PRINT 'The order is not existing!'
ELSE
	BEGIN
		UPDATE PurchaseOrder
		SET isApproved = 1
		WHERE Id = @po_id
		PRINT 'The order is successfully approved!'
	END
GO


CREATE PROCEDURE PurchaseOrder_approve(@po_id int)
AS
DECLARE @isExisting int
--check if the order (@oId) is existing?
	EXEC PurchaseOrder_isExisting @po_id, @isExisting OUTPUT
--update received date if the order is existing
IF(@isExisting = 0)
	PRINT 'The order is NOT existing!'
ELSE
	BEGIN
		EXEC PurchaseOrder_update_isApproved @po_id
	END
GO







/*create procedure "purchase_order_receiveGoods"*/
--drop procedure PurchaseOrder_receive;
create procedure PurchaseOrder_receive(
@po_id int
)
AS
DECLARE @count int
SELECT @count = 0

--check if the order (@oId) is existing?
SELECT @count = COUNT(*) FROM PurchaseOrder WHERE Id = @po_id

--update isReceived = true if the order is existing
IF(@count = 0)
	PRINT 'The order is not existing!'
ELSE
	BEGIN
		UPDATE PurchaseOrder
		SET isReceived = 1
		WHERE Id = @po_id
		PRINT 'The order is successfully completed!'
	END
GO


CREATE PROCEDURE PurchaseOrder_receive(@po_id int)
AS
DECLARE @isExisting int
--check if the order (@oId) is existing?
	EXEC PurchaseOrder_isExisting @po_id, @isExisting OUTPUT
--update received date if the order is existing
IF(@isExisting = 0)
	PRINT 'The order is NOT existing!'
ELSE
	BEGIN
		EXEC PurchaseOrder_update_isReceived @po_id
	END
GO










/*create procedure "purchase_order_modify"*/
--drop procedure purchase_order_modify;
create procedure purchase_order_modify(
@oId int,
@items varchar(25)
)
AS
DECLARE @count int
SELECT @count = 0

--check if the order (@oId) is existing?
SELECT @count = COUNT(*) FROM purchase_order WHERE oId = @oId

--update isReceived = true if the order is existing
IF(@count = 0)
	PRINT 'The order is not existing'
ELSE
	BEGIN
		UPDATE purchase_order
		SET oItems = @items
		WHERE oId = @oId
		PRINT 'The items of this order if successfully modified!'
	END
GO

