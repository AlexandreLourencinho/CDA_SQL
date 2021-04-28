DELIMITER $$
CREATE TRIGGER t_pays AFTER INSERT ON order_details FOR EACH ROW
BEGIN
DECLARE pays_fournisseur VARCHAR (15);
DECLARE pays_livraison VARCHAR (15);
DECLARE id_com INT;
DECLARE id_produit INT;
SET id_produit = NEW.productid;
SET id_com = NEW.orderid;
SELECT Country,ShipCountry INTO @pays_fournisseur, @pays_livraison FROM suppliers
INNER JOIN products ON products.SupplierID =suppliers.SupplierID
INNER JOIN order_details ON order_details.ProductID  = products.ProductID
INNER JOIN orders ON orders.OrderID = order_details.OrderID
WHERE order_details.ProductID = id_produit
AND orders.OrderID = id_com;
IF @pays_fournisseur <> @pays_livraison THEN
SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Les pays diffèrent, vous voulez faire exploser nos coûts de livraison?';
END IF;
END $$
DELIMITER ;