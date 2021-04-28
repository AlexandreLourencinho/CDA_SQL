/*Exercice1 procédure stockée
1) Créez la procédure stockée Lst_fournis correspondant à la requête n°2 afficher le code des fournisseurs 
pour lesquels une commande a été passée.*/
DELIMITER $$
CREATE PROCEDURE lst_fournis() 
BEGIN 
SELECT DISTINCT entcom.numfou as "numéro fournisseur", nomfou AS "nom fournisseur" FROM entcom
JOIN fournis ON entcom.numfou = fournis.numfou;
END $$
DELIMITER ;
/*-- Exercice 2 : création d'une procédure stockée avec un paramètre en entrée
-- Créer la procédure stockée Lst_Commandes, qui liste les commandes ayant un libellé particulier dans le champ obscom 
(cette requête sera construite à partir de la requête n°11). */
DELIMITER $$
CREATE PROCEDURE lst_commandes(IN obs VARCHAR (50))
BEGIN 
SELECT entcom.numcom, entcom.obscom FROM entcom
WHERE obscom LIKE CONCAT('%',obs,'%');
END $$
DELIMITER ;
/*Exercice 3 : création d'une procédure stockée avec plusieurs paramètres
Créer la procédure stockée CA_ Fournisseur, qui pour un code fournisseur et une année entrée en paramètre, 
calcule et restitue le CA potentiel de ce fournisseur pour l'année souhaitée 
(cette requête sera construite à partir de la requête n°19).*/
DELIMITER $$
CREATE PROCEDURE ca_fournisseur(IN année INT,IN numfournisseur INT) 
BEGIN
IF numfournisseur = ANY (SELECT numfou FROM fournis) THEN
SELECT SUM(qtecde*priuni*1.2) AS total,nomfou AS "nom fournisseur" FROM ligcom,fournis,entcom
WHERE ligcom.numcom = entcom.numcom
AND entcom.numfou = fournis.numfou
AND YEAR(datcom) = année
AND fournis.numfou = numfournisseur;
END if ;
END $$
DELIMITER ;
