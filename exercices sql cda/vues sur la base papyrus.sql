/*
VUES SUR LA BASE PAPYRUS
2-1:v_GlobalCde correspondant à la requête : A partir de la table Ligcom, afficher par code produit, 
la somme des quantités commandées et le prix total correspondant : on nommera la colonne correspondant à la somme 
des quantités commandées, QteTot et le prix total, PrixTot. */
CREATE VIEW v_GlobalCde AS
SELECT codart AS "code de l'article",SUM(qtecde) AS "QteTot",priuni*qtecde AS "PrixTot" FROM ligcom
GROUP BY codart;
/*2-2:v_VentesI100 correspondant à la requête : Afficher les ventes dont le code produit est le I100 
(affichage de toutes les colonnes de la table Vente). */
CREATE VIEW v_Ventesi100 AS
SELECT * FROM vente WHERE codart="i100";
/*2-3 :A partir de la vue précédente, créez v_VentesI100Grobrigan remontant toutes les ventes concernant le 
produit I100 et le fournisseur 00120. */
CREATE VIEW v_Ventesi100grobrigan AS
SELECT vi100.* FROM v_ventesi100 AS vi100 WHERE numfou=120;
