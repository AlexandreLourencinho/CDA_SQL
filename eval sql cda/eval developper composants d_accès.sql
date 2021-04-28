/*
2) Procédures stockées
Codez deux procédures stockées correspondant aux requêtes 9 et 10. Les procédures stockées doivent prendre
en compte les éventuels paramètres.

note : j'ai gardé les alias qu'on nous a demandé de mettre dans l'éval de TBDA, puisque la consigne
était d'avoir exactement le même affichage que sur les captures d'écrans du PDF.

northwind requête 9 : 
9 – Depuis quelle date le client « Du monde entier » n’a plus commandé ? 
SELECT MAX(OrderDate) AS `Date de dernière commande` FROM orders,customers
INNER JOIN customers ON customers.CustomerID = orders.CustomerID 
WHERE CompanyName = 'Du monde entier';
Ici, j'ai passé le client en paramètre.
*/
DELIMITER $$
CREATE PROCEDURE date_last_cmd(IN CLIENT VARCHAR (40))
BEGIN
SELECT MAX(OrderDate) AS 'Date de dernière commande' FROM orders
INNER JOIN customers ON  orders.CustomerID = customers.CustomerID 
WHERE CompanyName = CLIENT;
END $$
DELIMITER ;
/*---------------------------------------------------------------------------------------------------------------------------
Northwind requête 10 :

10 – Quel est le délai moyen de livraison en jours ?
SELECT FLOOR(AVG(datediff(ShippedDate,OrderDate))) AS `Délai moyen de livraison en jours`
FROM orders;

Note pour Cédric : j'ai discuté avec Germain de quels paramètres il serait pertinent de prendre en compte 
pour cette requête-ci. Il m'a dit que ce genre de statistiques dans un cas pratique serait pertinent 
pour comparer les délais moyens de livraisons par mois et par année pour un même fournisseur, d'où le fait
que ce soient les deux paramètres que j'ai utilisé ici. Ca permet de comparer les délais de livraisons,
par exemple, de septembre 2018 avec Septembre 2017 PAR client(en appelant cependant deux fois
la procédure,cela dit). 

exemple de requête pouvant sortir les délais moyens de livraison par mois année et fournisseur :
CALL avg_ship_by_client(1996,07,'Ma Maison');
CALL avg_ship_by_client(1997,07,'Ma Maison');

En juillet 96, la compagnie Ma Maison avait pour délai moyen de livraison 12 jours, et en juillet 97,
7 jours.
J'aurai pu regrouper tout ça en une seule procédure, qui prend en paramètres deux années, un seul mois 
(ou même deux mois différents), et un nom de fournisseur, afin de regrouper la comparaison 
en une seule procédure.
*/

DELIMITER $$
CREATE PROCEDURE avg_ship_by_client(IN anne INT,IN mois INT,IN fournisseur VARCHAR (40))
BEGIN
SELECT FLOOR(AVG(datediff(ShippedDate,OrderDate))) AS 'Délai moyen de livraison en jours' FROM orders
INNER JOIN order_details ON order_details.orderID = orders.orderID
INNER JOIN products ON products.productID = order_details.productID
INNER JOIN suppliers ON suppliers.supplierID = products.supplierID 
WHERE YEAR(OrderDate) = anne
AND MONTH(Orderdate) = mois
AND CompanyName = fournisseur;
END $$ 
DELIMITER ;

/* note pour Cédric : bon en fait je l'ai fait, donc voici la v2 : on met 2 années, 2 mois, un fournisseur, et 
la procédure nous sort les délais correspondants. J'ai trouvé ça plus pratique à l'utilisation.
du coup pour la tester, la requête correspondante , comme les deux du dessus, mais cette fois 
en un seul appel de procédure:
CALL v2_avgShipByClient(1996,1997,07,07,'Ma Maison');*/

DELIMITER $$
CREATE PROCEDURE v2_avgShipbyclient(IN anne1 INT,IN anne2 INT,IN mois1 INT,IN mois2 INT,IN fournisseur VARCHAR (40))
BEGIN
SELECT FLOOR(AVG(datediff(ShippedDate,OrderDate))) AS 'Délai moyen de livraison en jours',CompanyName as 'Nom du fournisseur' FROM orders
INNER JOIN order_details ON order_details.orderID = orders.orderID
INNER JOIN products ON products.productID = order_details.productID
INNER JOIN suppliers ON suppliers.supplierID = products.supplierID 
WHERE YEAR(OrderDate) = anne1
AND MONTH(Orderdate) = mois1
AND CompanyName = fournisseur;
SELECT FLOOR(AVG(datediff(ShippedDate,OrderDate))) AS 'Délai moyen de livraison en jours',CompanyName as 'Nom du fournisseur' FROM orders
INNER JOIN order_details ON order_details.orderID = orders.orderID
INNER JOIN products ON products.productID = order_details.productID
INNER JOIN suppliers ON suppliers.supplierID = products.supplierID 
WHERE YEAR(OrderDate) = anne2
AND MONTH(Orderdate) = mois2
AND CompanyName = fournisseur;
END $$ 
DELIMITER ;
/*---------------------------------------------------------------------------------------------------------------------------
3) Mise en place d'une règle de gestion
Décrivez par quel moyen et comment vous pourriez implémenter la règle de gestion suivante.
Pour tenir compte des coûts liés au transport, on vérifiera que pour chaque produit d’une commande, 
le client réside dans le même pays que le fournisseur du même produit.*/

/*Note pour Cédric : ici je crois que c'est avec vous que j'en ai discuté, 
le trigger concerné empêche donc l'insertion de produits dans une commande si le pays du fournisseur
(j'ai implicitement compris que c'était aussi le pays de départ du produit, je vois pas lequel autre serait
à prendre en compte sinon) et le pays de livraison du produit sont différents (c'est bien le pays de livraison
qui compte je suppose, et non pas le pays d'origine du client, qui peut très bien résider en islande
mais commander un produit d'un fournisseur français pour qu'il soit livré en france, pour une autre boîte,
ou si c'est un client qui est simplement un sous-traitant qui gère les commandes d'une autre boîte, ou même 
un particulier qui désire faire livrer quelque chose dans sa résidence secondaire, sur son lieu de vacances,
ou à un ami, enfin etc, vous avez l'idée j'imagine), si les pays donc de livraison et du fournisseur
sont différents, donc, le trigger empêche l'insertion du produit dans la commande, sinon, bah
il laisse faire.*/

DELIMITER $$
CREATE TRIGGER t_pays AFTER INSERT ON order_details FOR EACH ROW
BEGIN
DECLARE id_com INT;
DECLARE id_produit INT;
DECLARE id_fournisseur INT;
DECLARE pays_fournisseur VARCHAR (15);
DECLARE pays_livraison VARCHAR (15);
SET id_produit = NEW.productid;
SET id_com = NEW.orderid;
SET id_fournisseur = (SELECT suppliers.SupplierID FROM suppliers
INNER JOIN products ON products.supplierid = suppliers.supplierid
INNER JOIN order_details ON products.productid=order_details.productid
INNER JOIN orders ON orders.OrderID = order_details.OrderID
WHERE order_details.ProductID=id_produit
AND orders.OrderID = id_com);
SET pays_fournisseur = (SELECT Country FROM suppliers
INNER JOIN products ON products.SupplierID =suppliers.SupplierID
INNER JOIN order_details ON order_details.ProductID  = products.ProductID
INNER JOIN orders ON orders.OrderID = order_details.OrderID
WHERE order_details.ProductID = id_produit
AND orders.OrderID = id_com);
SET pays_livraison = (SELECT ShipCountry FROM orders
INNER JOIN order_details ON order_details.OrderID = orders.OrderID
INNER JOIN products ON products.ProductID = order_details.ProductID
WHERE order_details.productID = id_produit
AND orders.OrderID = id_com);
IF pays_fournisseur <> pays_livraison THEN
SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'Les pays diffèrent, vous voulez faire exploser nos coûts de livraison?';
END IF;
END $$
DELIMITER ;

/*test : requête même pays => pas d'erreur :
INSERT INTO order_details VALUES (10248,38,20,10,0);
commande 10248 va en France, produit 38 vient de France*/

/* test 2 : pays différents => erreur :
INSERT INTO order_details VALUES (10248,18,20,10,0);
commande 10248 va en France, produit 18 vient d'Australie */


/* méthode 2 : */



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