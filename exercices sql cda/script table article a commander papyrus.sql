CREATE TABLE article_a_commander(
numero_com INT AUTO_INCREMENT,
codart CHAR(4) NOT NULL,
quantite_commande INT NOT NULL,
prix_unitaire INT NOT NULL,
prix_total INT NOT NULL,
PRIMARY KEY(numero_com),
FOREIGN KEY(codart) REFERENCES produit(codart)
);
