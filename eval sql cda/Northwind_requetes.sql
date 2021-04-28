/*1) Requêtes d'intérrogation sur la base NorthWind
A partir du document la base Northwind, ecrivrez les requêtes permettants d'obtenir le résultat attendu.
Ecrivez les requêtes permettant d'obtenir les résultats suivant:
consigne datant du TBDA : respectez les noms des colonnes.
1 - Liste des contacts français :------------------------------------------------------------------------------------- */
SELECT companyName AS Société,ContactName AS contact,ContactTitle AS Fonction,Phone AS Téléphone
FROM customers
WHERE Country = 'France';
/* 2 - Produits vendus par le fournisseur « Exotic Liquids » :------------------------------------------------------------*/
SELECT productName AS Produit,UnitPrice AS Prix FROM products
INNER JOIN suppliers ON products.SupplierID = suppliers.SupplierID
WHERE CompanyName = 'Exotic Liquids';
/* 3 - Nombre de produits vendus par les fournisseurs Français dans l’ordre décroissant:-------------------------------- */
SELECT CompanyName AS Fournisseur,COUNT(ProductId) AS `Nombre de produits` FROM suppliers
INNER JOIN suppliers.SupplierID = products.productID
WHERE suppliers.country = 'France'
GROUP BY Fournisseur
ORDER BY `Nombre de produits` DESC;
/* 4 - Liste des clients Français ayant plus de 10 commandes :-------------------------------------------------------------*/
SELECT CompanyName AS Client,COUNT(DISTINCT orders.OrderID) AS `Nombre de commandes` FROM customers
INNER JOIN orders ON customers.CustomerID = orders.CustomerID 
INNER JOIN order_details ON orders.orderID = order_details.OrderID
WHERE customers.country = 'France'
GROUP BY Client
HAVING `Nombre de commandes` > 10;
/* 5 - Liste des clients ayant un chiffre d’affaires > 30.000 :------------------------------------------------------------- */
SELECT CompanyName AS Client,SUM(UnitPrice*Quantity) AS CA,Country AS Pays FROM order_details
INNER JOIN cutstomers ON order_details.OrderID = orders.OrderID 
INNER JOIN orders ON orders.CustomerID = customers.CustomerID
GROUP BY Client
HAVING CA > 30000
ORDER BY CA DESC;
/* 6 – Liste des pays dont les clients ont passé commande de produits fournis par « Exotic  Liquids » :-----------------------*/
SELECT customers.country AS Pays FROM customers
INNER JOIN orders ON orders.customerID = customers.customerID
INNER JOIN order_details ON order_details.orderId = orders.orderID
INNER JOIN products ON products.productID = order_details.productID 
INNER JOIN suppliers ON suppliers.SupplierID = products.SupplierID
WHERE suppliers.CompanyName = 'Exotic Liquids'
GROUP BY  Pays;
/* 7 – Montant des ventes de 1997 : ---------------------------------------------------------------------------------------*/
SELECT SUM(UnitPrice*Quantity) AS `montant ventes 97` FROM order_details
INNER JOIN orders ON orders.OrderID = order_details.OrderID
WHERE YEAR(OrderDate) = 1997;
/* 8 – Montant des ventes de 1997 mois par mois :----------------------------------------------------------------------------*/
SELECT MONTH(Orderdate) AS `Mois 97`,SUM(UnitPrice*Quantity) AS montant_ventes_97 FROM order_details,orders
INNER JOIN orders.OrderID = order_details.OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY `Mois 97`;
/* 9 – Depuis quelle date le client « Du monde entier » n’a plus commandé ? -------------------------------------------------*/
SELECT MAX(OrderDate) AS `Date de dernière commande` FROM orders,customers
INNER JOIN customers ON customers.CustomerID = orders.CustomerID 
WHERE CompanyName = 'Du monde entier';
/* 10 – Quel est le délai moyen de livraison en jours ?---------------------------------------------------------------------*/
SELECT FLOOR(AVG(datediff(ShippedDate,OrderDate))) AS `Délai moyen de livraison en jours`
FROM orders;