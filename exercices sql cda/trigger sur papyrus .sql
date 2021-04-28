/*Création d'un déclencheur AFTER UPDATE

Créer une table ARTICLES_A_COMMANDER avec les colonnes :

CODART : Code de l'article, voir la table produit
DATE : date du jour (par défaut)
QTE : à calculer

Créer un déclencheur UPDATE sur la table produit : lorsque le stock physique devient inférieur ou égal au stock d'alerte, une nouvelle ligne est insérée dans la table ARTICLES_A_COMMANDER.

Attention, il faut prendre en compte les quantités déjà commandées dans la table ARTICLES_A_COMMANDER .

Pour comprendre le problème :

Soit l'article I120, le stock d'alerte = 5, le stock physique = 20

Nous retirons 15 produits du stock. stock d'alerte = 5, le stock physique = 5, le stock physique n'est pas inférieur au stock d'alerte, on ne fait rien.

Nous retirons 1 produit du stock. stock d'alerte = 5, le stock physique = 4, le stock physique est inférieur au stock d'alerte, nous devons recommander des produits. Nous insérons une ligne dans la table ARTICLES_A_COMMANDER avec QTE = (stock alerte - stock physique) = 1

Nous retirons 2 produit du stock. stock d'alerte = 5, le stock physique = 2. le stock physique est inférieur au stock d'alerte, nous devons recommander des produits. Nous insérons une ligne dans la table ARTICLES_A_COMMANDER avec QTE = (stock alerte - stock physique) – quantité déjà commandée dans ARTICLES_A_COMMANDER : QTE = (5 - 2) – 1 = 2
*/
delimiter $$ 
CREATE TRIGGER t_stock AFTER UPDATE ON produit FOR EACH ROW
BEGIN
DECLARE code_article CHAR(4);
DECLARE qte_com INT;
DECLARE stock_alerte INT;
declare stock_phy int;  
DECLARE temp_qte_com INT;   
SET code_article = NEW.codart;
SET stock_phy = NEW.stkphy;
SET stock_alerte = (SELECT produit.stkale FROM produit WHERE produit.codart = code_article);
IF ((stock_phy < stock_alerte) AND (code_article NOT IN (select codart FROM article_a_commander WHERE codart=code_article))) THEN 
SET qte_com = (stock_alerte - stock_phy);
INSERT INTO article_a_commander VALUES (NULL, code_article, qte_com, CURDATE());
ELSE 
SET temp_qte_com = (SELECT SUM(quantite_commande) FROM article_a_commander WHERE article_a_commander.codart = code_article);
SET qte_com = (stock_alerte-stock_phy)-(temp_qte_com);
INSERT INTO article_a_commander VALUES (NULL, code_article, qte_com, CURDATE());
END if;
END $$
delimiter ;
