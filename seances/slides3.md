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
3. Le package `plyr`:w
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
======


```r
library(RCurl)
```

```
## Loading required package: bitops
```

```r
lam = read.table("http://files.figshare.com/143154/lamellodiscus.txt", sep = "\t", 
    h = TRUE, dec = ".")
print(colnames(lam))
```

```
##  [1] "sphote" "sppar"  "para"   "a"      "b"      "c"      "d"     
##  [8] "f"      "g"      "aa"     "bb"     "cc"     "lm"     "li"
```


Taille d'échantillon
======


```r
print(xtabs(~sppar + sphote, lam))
```

```
##       sphote
## sppar  Dian Dipu Disa Divu Limo Obme Sasa
##   conf    0    0    1    0    0    0    1
##   dipl    0    0    0    2    0    0    0
##   eleg    2    0   35   16    0    6    0
##   erge    0    4   13    2    0    0    0
##   falc    0    0    2    7    0    0    0
##   frat    6    0    0    0    0    0    0
##   furc    0    0    7    0    0    0    0
##   igno    0    2   18    8   10    0    5
##   kech    0    0    7   23    0    0    0
##   morm    0    0    1    0    0    0    0
##   neif    0    0    5    1    0    0    0
##   ther    0    2    0    0    0    0    0
##   tome    0    0    0    3    0    0    0
```


Valeur moyenne de a
======


```r
agr = aggregate(lam$a, by = list(host = lam$sphote, parasite = lam$sppar), mean, 
    na.rm = TRUE)
print(head(agr))
```

```
##   host parasite     x
## 1 Disa     conf 1.204
## 2 Sasa     conf 1.300
## 3 Divu     dipl 1.100
## 4 Dian     eleg 1.650
## 5 Disa     eleg 1.740
## 6 Divu     eleg 1.760
```


Valeur moyenne de a
======


```r
print(xtabs(round(x, 1) ~ host + parasite, agr))
```

```
##       parasite
## host   conf dipl eleg erge falc frat furc igno kech morm neif ther tome
##   Dian  0.0  0.0  1.6  0.0  0.0  1.6  0.0  0.0  0.0  0.0  0.0  0.0  0.0
##   Dipu  0.0  0.0  0.0  2.4  0.0  0.0  0.0  1.3  0.0  0.0  0.0  2.4  0.0
##   Disa  1.2  0.0  1.7  1.9  1.4  0.0  2.0  1.2  1.8  1.6  0.9  0.0  0.0
##   Divu  0.0  1.1  1.8  2.2  1.4  0.0  0.0  1.2  1.8  0.0  1.8  0.0  2.3
##   Limo  0.0  0.0  0.0  0.0  0.0  0.0  0.0  1.0  0.0  0.0  0.0  0.0  0.0
##   Obme  0.0  0.0  1.4  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0  0.0
##   Sasa  1.3  0.0  0.0  0.0  0.0  0.0  0.0  1.1  0.0  0.0  0.0  0.0  0.0
```


Stratégie d'analyse
=====

1. `split`: diviser les données en ensembles (*pieces*) sur lesquels on travaille
2. `apply`: appliquer la fonction de traitement à chaque *piece*
3. `combine`: "re-coller" les objets dans un objet final

Fonction de traitement
=====

1. Prend une *piece* comme argument
2. Applique la mesure, statistique, *etc*.
3. Renvoie un objet (idéalement) de la même nature que la *piece*

**Important:** La fonction de traitement doit *toujours* renvoyer un objet du même type (rappel séance 1: prédictibilité)

plyr
======


```r
library(plyr)
lam = lam[, -which(colnames(lam) == "para")]
ddply(lam, c("sphote", "sppar"), .fun = function(x) mean(x$a, na.rm = TRUE))
```

```
##    sphote sppar     V1
## 1    Dian  eleg 1.6500
## 2    Dian  frat 1.6333
## 3    Dipu  erge 2.3865
## 4    Dipu  igno 1.2776
## 5    Dipu  ther 2.3652
## 6    Disa  conf 1.2035
## 7    Disa  eleg 1.7402
## 8    Disa  erge 1.9312
## 9    Disa  falc 1.4428
## 10   Disa  furc 1.9684
## 11   Disa  igno 1.1604
## 12   Disa  kech 1.7886
## 13   Disa  morm 1.6000
## 14   Disa  neif 0.8625
## 15   Divu  dipl 1.1000
## 16   Divu  eleg 1.7600
## 17   Divu  erge 2.1700
## 18   Divu  falc 1.4071
## 19   Divu  igno 1.2288
## 20   Divu  kech 1.8109
## 21   Divu  neif 1.8146
## 22   Divu  tome 2.2833
## 23   Limo  igno 1.0200
## 24   Obme  eleg 1.3917
## 25   Sasa  conf 1.3000
## 26   Sasa  igno 1.1250
```


plyr
======

Nommage des fonctions de `plyr`: `**ply()`

- `d`: `data.frame`
- `a`: `array` (vecteur)
- `l`: `list`
- `_`: *discard* (only for the second letter)

**Exemple:** `dlply` prend un `data.frame` en entrée, renvoie une `list`

Une note importante
======

Les `data.frame` sont des `list` d'`array`. On peut donc les utiliser dans `l*ply()`.

Les `data.frame` sont des `array` a deux dimensions. On peut donc les utiliser dans `a*ply()`.

Procédure
======

1. Définir le type entrée/sortie
2. Définir la fonction de traitement
3. Appeller la fonction `**ply` qui correspond

Exemple
=====

On a des données spatiales hétérogènes


```r
n = 100
x = round(runif(4), 1)
y = round(runif(4), 1)
pop = data.frame(X = sample(x, n, replace = T), Y = sample(y, n, replace = T), 
    N = rlnorm(n, 2))
```


On veut standardiser (`scale`) les données *par site*.

Approche R "classique"
======


```r
head(aggregate(pop$N, list(X = pop$X, Y = pop$Y), scale))
```

```
##     X   Y
## 1 0.4 0.1
## 2 0.7 0.1
## 3 0.8 0.1
## 4 0.9 0.1
## 5 0.4 0.7
## 6 0.7 0.7
##                                                                               x
## 1                   -0.1094, -0.3011, -0.7162, -0.6131, 0.2569, 2.1277, -0.6447
## 2   -0.7235, 1.5661, -1.1904, -0.2887, 0.0230, 1.5530, -0.2263, -0.9912, 0.2780
## 3                                                       0.8103, -1.1176, 0.3073
## 4                                                      -0.7498, 1.1354, -0.3856
## 5 2.3171, -0.2184, -0.1075, -0.1370, -0.3094, 0.6829, -0.2745, -0.9132, -1.0399
## 6                             -0.8440, 0.3147, -0.7723, 0.8530, 1.3999, -0.9512
```


Approche plyr - scale
======


```r
head(ddply(pop, .(X, Y), function(df) scale(df$N)))
```

```
##     X   Y       1
## 1 0.4 0.1 -0.1094
## 2 0.4 0.1 -0.3011
## 3 0.4 0.1 -0.7162
## 4 0.4 0.1 -0.6131
## 5 0.4 0.1  0.2569
## 6 0.4 0.1  2.1277
```


Approche plyr - nombre d'échantillons
======


```r
out = ddply(pop, .(X, Y), function(df) length(df$N))
head(out)
```

```
##     X   Y V1
## 1 0.4 0.1  7
## 2 0.4 0.7  9
## 3 0.4 0.9  7
## 4 0.7 0.1  9
## 5 0.7 0.7  6
## 6 0.7 0.9 15
```


Retour aux données
======


```r
a_by_h_p = ddply(lam, .(sppar, sphote), function(x) return(data.frame(a = mean(x$a))))
head(a_by_h_p)
```

```
##   sppar sphote     a
## 1  conf   Disa 1.204
## 2  conf   Sasa 1.300
## 3  dipl   Divu 1.100
## 4  eleg   Dian 1.650
## 5  eleg   Disa 1.740
## 6  eleg   Divu 1.760
```


GGplot2
======


```r
library(ggplot2)
ggplot(lam, aes(x = sppar, fill = sphote, y = a)) + geom_boxplot()
```

```
## Warning: Removed 4 rows containing non-finite values (stat_boxplot).
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11.png) 

