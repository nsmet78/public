# STDCONVERT
STDCONVERT est un projet Mapping Connect conçu pour convertir les fichiers XML "pivots" en fichiers XML "draw" dédiés au Designer Mapping.

Nom du Format Connect : XML4DESIGN

Paramètres obligatoires :
- DB.INPUT_XML (fichier xml de données)
- DB.PARAM_XML (fichier xml de paramétrage)
- DB.OUTPUT_XML (fichier xml "draw" pour le Designer)
- DB.MAPPING_DATASTREAM=XML (paramètre technique)

Paramètres facultatifs :
- DB.nb-decimal (nombre de chiffres après la virgule)
- DB.decimal-separator (séparateur de décimales)
- DB.thousands-separator (séparateur de milliers)
- DB.culture (fr-FR , en-US , en-UK)


## Exemple de fichier XML de données (facture)
```xml
<data version="1.0" xmlns="http://mappingsuite.com/designer">
  <field id="inv_num">12456</field>
  <field id="cust_num">Durand</field>
  <list id="products">
    <item>
      <field id="reference">6547358</field>
      <field id="label">My first product</field>
      <list id="options">
        <item>
          (...)
        </item>
      </list>
    </item>
    <item>
      <field id="reference">3245786</field>
      <field id="label">My second product</field>
      <list id="options">
        <item>
          (...)
        </item>
      </list>
    </item>
  </list>
</data>
```

## Exemple de fichier XML de paramétrage
```xml
<param version="1.0" data-version="1.0" xmlns="http://mappingsuite.com/designer">
  <field id="inv_num"/>
  <list id="products">
    <items>
      <line>
        <field id="label"/>
      </line>
    </items>
  </list>
</param>
```
