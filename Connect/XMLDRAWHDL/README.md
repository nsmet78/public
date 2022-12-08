Convertisseur permettant de manipuler le contenu d'un XML "Draw" (Designer) déjà existant.

Fonctionnalités : 

  - Ajout des champs de date courante (seule modif systématique même si le param est vide)
  - Formatage des numériques avec @decimal-separator, @thousands-separator, @nb-decimal (cf. documentation/specs du convertisseur XML pivot)
  - Formatage des dates avec @date-in et @date-out (cf. documentation/specs du convertisseur XML pivot)
  - Modification de la casse d'un champ texte avec @case (cf. documentation/specs du convertisseur XML pivot)
  - Découpage d'un champ de "group" en plusieurs lignes avec @split et @indentation (cf. image @split.png)
  - Fusion de la première ligne d'une liste avec son élément parent grâce à @merge-into (cf. image @merge-into.png)
