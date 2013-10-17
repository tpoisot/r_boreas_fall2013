Stratégies pour l'analyse de données
=======
author: Timothée Poisot

Dans la dernière séance
=======

- Ne pas utiliser de boucles `for`
- Utiliser les raccourcis le plus possible

Objectifs de la séance
=======

1. Concevoir une stratégie d'analyse de données
2. `split`-`apply`-`combine`
3. Les graphiques avec `ggplot2`

Un exemple
=======

- 147 individus de différentes espèces de parasites, sur différents hôtes
- une dizaine de mesures morphométriques
- certaines données sont manquantes

Pour récupérer les données: `http://dx.doi.org/10.6084/m9.figshare.97320`

La question
=======

> La morphologie des différentes espèces est-elle la même? La morphologie d'une même espèce sur ses différents hôtes?

Pour la réponse: Timothée Poisot, Yves Desdevises (2010) Putative speciation
events in Lamellodiscus (Monogenea: Diplectanidae) assessed by a morphometric
approach. *Biological Journal of the Linnean Society* 99 (3) 559-569.

Lecture des données
=======


```r
library(RCurl)
lam = read.table('http://files.figshare.com/143154/lamellodiscus.txt',sep='\t',h=TRUE,dec='.')
print(colnames(lam))
```

```
 [1] "sphote" "sppar"  "para"   "a"      "b"      "c"      "d"     
 [8] "f"      "g"      "aa"     "bb"     "cc"     "lm"     "li"    
```


Taille d'échantillon
======


```r
print(xtabs(~sppar+sphote,lam))
```

```
      sphote
sppar  Dian Dipu Disa Divu Limo Obme Sasa
  conf    0    0    1    0    0    0    1
  dipl    0    0    0    2    0    0    0
  eleg    2    0   35   16    0    6    0
  erge    0    4   13    2    0    0    0
  falc    0    0    2    7    0    0    0
  frat    6    0    0    0    0    0    0
  furc    0    0    7    0    0    0    0
  igno    0    2   18    8   10    0    5
  kech    0    0    7   23    0    0    0
  morm    0    0    1    0    0    0    0
  neif    0    0    5    1    0    0    0
  ther    0    2    0    0    0    0    0
  tome    0    0    0    3    0    0    0
```


Valeur moyenne de a
======


```r
agr = aggregate(lam$a,by=list(host=lam$sphote, parasite=lam$sppar), mean, na.rm=TRUE)
print(head(agr))
```

```
  host parasite     x
1 Disa     conf 1.204
2 Sasa     conf 1.300
3 Divu     dipl 1.100
4 Dian     eleg 1.650
5 Disa     eleg 1.740
6 Divu     eleg 1.760
```


Valeur moyenne de a
======


```r
print(xtabs(round(x,1)~host+parasite,agr))
```

```
      parasite
host   conf dipl eleg erge falc frat furc igno kech morm neif ther tome
  Dian  0.0  0.0  1.6  0.0  0.0  1.6  0.0  0.0  0.0  0.0  0.0  0.0  0.0
  Dipu  0.0  0.0  0.0  2.4  0.0  0.0  0.0  1.3  0.0  0.0  0.0  2.4  0.0
  Disa  1.2  0.0  1.7  1.9  1.4  0.0  2.0  1.2  1.8  1.6  0.9  0.0  0.0
  Divu  0.0  1.1  1.8  2.2  1.4  0.0  0.0  1.2  1.8  0.0  1.8  0.0  2.3
  Limo  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0
  Obme  0.0  0.0  1.4  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
  Sasa  1.3  0.0  0.0  0.0  0.0  0.0  0.0  1.1  0.0  0.0  0.0  0.0  0.0
```

