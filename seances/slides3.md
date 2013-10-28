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
3. Les *packages* `plyr` et `reshape`
4. Les graphiques avec `ggplot2`

Un exemple
=======

- 147 individus de différentes espèces de parasites, sur différents hôtes
- une dizaine de mesures morphométriques
- certaines données sont manquantes

Pour récupérer les données: `http://dx.doi.org/10.6084/m9.figshare.97320`

La question
======

> La morphologie des différentes espèces est-elle la même? La morphologie d'une même espèce sur ses différents hôtes?

Pour la réponse: Timothée Poisot, Yves Desdevises (2010) Putative speciation
events in *Lamellodiscus* (Monogenea: Diplectanidae) assessed by a morphometric
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
head(lam)
```

```
##   sphote sppar      para    a    b    c    d    f    g   aa   bb   cc   lm
## 1   Divu  eleg elegDivu1 2.06 1.93   NA   NA   NA   NA 1.93 1.81 1.16 5.43
## 2   Divu  eleg elegDivu2 1.93 1.82 1.51 0.41 0.57 0.20 1.77 1.67 1.20 2.35
## 3   Divu  eleg elegDivu2 1.67 1.56 1.20 0.31 0.36 0.26 1.56 1.51 0.94 1.88
## 4   Disa  eleg elegDisa1 1.46 1.41 1.04 0.47 0.67 0.31 1.25 1.20 0.83 1.46
## 5   Disa  eleg elegDisa1 1.30 1.25 0.94 0.36 0.52 0.31 1.14 1.09 0.78   NA
## 6   Disa  eleg elegDisa1 1.41 1.35 0.99 0.36 0.57 0.36 1.25 1.20 0.83 2.08
##     li
## 1 2.66
## 2 2.66
## 3 1.77
## 4 2.19
## 5 2.03
## 6 2.55
```


Préparer les données
=====


```r
library(reshape)
```

```
## Loading required package: plyr
## 
## Attaching package: 'reshape'
## 
## Les objets suivants sont masqués from 'package:plyr':
## 
##     rename, round_any
```

```r
lam = melt(lam, na.rm = TRUE)
```

```
## Using sphote, sppar, para as id variables
```

```r
head(lam)
```

```
##   sphote sppar      para variable value
## 1   Divu  eleg elegDivu1        a  2.06
## 2   Divu  eleg elegDivu2        a  1.93
## 3   Divu  eleg elegDivu2        a  1.67
## 4   Disa  eleg elegDisa1        a  1.46
## 5   Disa  eleg elegDisa1        a  1.30
## 6   Disa  eleg elegDisa1        a  1.41
```


Calculer les moyennes
=====


```r
means = cast(lam, sphote ~ sppar ~ variable, mean, na.rm = TRUE)
means
```

```
## , , variable = a
## 
##       sppar
## sphote  conf dipl  eleg  erge  falc  frat  furc  igno  kech morm   neif
##   Dian   NaN  NaN 1.650   NaN   NaN 1.633   NaN   NaN   NaN  NaN    NaN
##   Dipu   NaN  NaN   NaN 2.386   NaN   NaN   NaN 1.278   NaN  NaN    NaN
##   Disa 1.204  NaN 1.740 1.931 1.443   NaN 1.968 1.160 1.789  1.6 0.8625
##   Divu   NaN  1.1 1.760 2.170 1.407   NaN   NaN 1.229 1.811  NaN 1.8146
##   Limo   NaN  NaN   NaN   NaN   NaN   NaN   NaN 1.020   NaN  NaN    NaN
##   Obme   NaN  NaN 1.392   NaN   NaN   NaN   NaN   NaN   NaN  NaN    NaN
##   Sasa 1.300  NaN   NaN   NaN   NaN   NaN   NaN 1.125   NaN  NaN    NaN
##       sppar
## sphote  ther  tome
##   Dian   NaN   NaN
##   Dipu 2.365   NaN
##   Disa   NaN   NaN
##   Divu   NaN 2.283
##   Limo   NaN   NaN
##   Obme   NaN   NaN
##   Sasa   NaN   NaN
## 
## , , variable = b
## 
##       sppar
## sphote  conf  dipl  eleg  erge  falc  frat  furc  igno  kech morm  neif
##   Dian   NaN   NaN 1.450   NaN   NaN 1.467   NaN   NaN   NaN  NaN   NaN
##   Dipu   NaN   NaN   NaN 2.314   NaN   NaN   NaN 1.274   NaN  NaN   NaN
##   Disa 1.244   NaN 1.662 1.828 0.994   NaN 1.857 1.117 1.833 1.55 0.750
##   Divu   NaN 1.025 1.637 2.045 1.370   NaN   NaN 1.156 1.708  NaN 1.718
##   Limo   NaN   NaN   NaN   NaN   NaN   NaN   NaN 0.910   NaN  NaN   NaN
##   Obme   NaN   NaN 1.292   NaN   NaN   NaN   NaN   NaN   NaN  NaN   NaN
##   Sasa 1.250   NaN   NaN   NaN   NaN   NaN   NaN 1.012   NaN  NaN   NaN
##       sppar
## sphote  ther  tome
##   Dian   NaN   NaN
##   Dipu 2.218   NaN
##   Disa   NaN   NaN
##   Divu   NaN 2.183
##   Limo   NaN   NaN
##   Obme   NaN   NaN
##   Sasa   NaN   NaN
## 
## , , variable = c
## 
##       sppar
## sphote   conf  dipl   eleg  erge   falc  frat  furc   igno  kech morm
##   Dian    NaN   NaN 0.9750   NaN    NaN 1.033   NaN    NaN   NaN  NaN
##   Dipu    NaN   NaN    NaN 1.667    NaN   NaN   NaN 0.8402   NaN  NaN
##   Disa 0.7498   NaN 1.1857 1.278 0.5997   NaN 1.352 0.7640 1.205 1.25
##   Divu    NaN 0.525 1.2436 1.175 0.7040   NaN   NaN 0.7486 1.092  NaN
##   Limo    NaN   NaN    NaN   NaN    NaN   NaN   NaN 0.5050   NaN  NaN
##   Obme    NaN   NaN 0.8667   NaN    NaN   NaN   NaN    NaN   NaN  NaN
##   Sasa 0.5500   NaN    NaN   NaN    NaN   NaN   NaN 0.6625   NaN  NaN
##       sppar
## sphote  neif  ther  tome
##   Dian   NaN   NaN   NaN
##   Dipu   NaN 1.588   NaN
##   Disa 0.450   NaN   NaN
##   Divu 1.289   NaN 1.283
##   Limo   NaN   NaN   NaN
##   Obme   NaN   NaN   NaN
##   Sasa   NaN   NaN   NaN
## 
## , , variable = d
## 
##       sppar
## sphote   conf dipl   eleg   erge  falc   frat   furc   igno   kech morm
##   Dian    NaN  NaN 0.6000    NaN   NaN 0.4833    NaN    NaN    NaN  NaN
##   Dipu    NaN  NaN    NaN 0.8382   NaN    NaN    NaN 0.6224    NaN  NaN
##   Disa 0.7443  NaN 0.5340 0.6802 0.485    NaN 0.6287 0.4677 0.6117  0.7
##   Divu    NaN 0.45 0.5113 0.9250 0.508    NaN    NaN 0.4943 0.5706  NaN
##   Limo    NaN  NaN    NaN    NaN   NaN    NaN    NaN 0.4350    NaN  NaN
##   Obme    NaN  NaN 0.4250    NaN   NaN    NaN    NaN    NaN    NaN  NaN
##   Sasa 0.3000  NaN    NaN    NaN   NaN    NaN    NaN 0.4000    NaN  NaN
##       sppar
## sphote   neif   ther tome
##   Dian    NaN    NaN  NaN
##   Dipu    NaN 0.8393  NaN
##   Disa 0.3250    NaN  NaN
##   Divu 0.7173    NaN  0.8
##   Limo    NaN    NaN  NaN
##   Obme    NaN    NaN  NaN
##   Sasa    NaN    NaN  NaN
## 
## , , variable = f
## 
##       sppar
## sphote   conf  dipl   eleg   erge   falc   frat   furc   igno   kech morm
##   Dian    NaN   NaN 0.6500    NaN    NaN 0.6083    NaN    NaN    NaN  NaN
##   Dipu    NaN   NaN    NaN 1.1478    NaN    NaN    NaN 0.6856    NaN  NaN
##   Disa 0.6972   NaN 0.6263 0.9088 0.4599    NaN 0.7512 0.5664 1.0317  0.8
##   Divu    NaN 0.475 0.5687 0.9000 0.4483    NaN    NaN 0.5443 0.8145  NaN
##   Limo    NaN   NaN    NaN    NaN    NaN    NaN    NaN 0.4600    NaN  NaN
##   Obme    NaN   NaN 0.4667    NaN    NaN    NaN    NaN    NaN    NaN  NaN
##   Sasa 0.3500   NaN    NaN    NaN    NaN    NaN    NaN 0.4125    NaN  NaN
##       sppar
## sphote  neif  ther tome
##   Dian   NaN   NaN  NaN
##   Dipu   NaN 1.087  NaN
##   Disa 0.350   NaN  NaN
##   Divu 0.797   NaN 1.15
##   Limo   NaN   NaN  NaN
##   Obme   NaN   NaN  NaN
##   Sasa   NaN   NaN  NaN
## 
## , , variable = g
## 
##       sppar
## sphote   conf  dipl   eleg   erge   falc   frat   furc   igno   kech morm
##   Dian    NaN   NaN 0.3000    NaN    NaN 0.2917    NaN    NaN    NaN  NaN
##   Dipu    NaN   NaN    NaN 0.5814    NaN    NaN    NaN 0.3492    NaN  NaN
##   Disa 0.3702   NaN 0.3587 0.4777 0.2461    NaN 0.4145 0.2548 0.4483 0.65
##   Divu    NaN 0.225 0.3307 0.6650 0.2740    NaN    NaN 0.3086 0.3847  NaN
##   Limo    NaN   NaN    NaN    NaN    NaN    NaN    NaN 0.2400    NaN  NaN
##   Obme    NaN   NaN 0.3417    NaN    NaN    NaN    NaN    NaN    NaN  NaN
##   Sasa 0.2000   NaN    NaN    NaN    NaN    NaN    NaN 0.2125    NaN  NaN
##       sppar
## sphote   neif   ther   tome
##   Dian    NaN    NaN    NaN
##   Dipu    NaN 0.5883    NaN
##   Disa 0.2000    NaN    NaN
##   Divu 0.4476    NaN 0.3833
##   Limo    NaN    NaN    NaN
##   Obme    NaN    NaN    NaN
##   Sasa    NaN    NaN    NaN
## 
## , , variable = aa
## 
##       sppar
## sphote   conf dipl  eleg  erge   falc  frat  furc  igno  kech morm  neif
##   Dian    NaN  NaN 1.575   NaN    NaN 1.333   NaN   NaN   NaN  NaN   NaN
##   Dipu    NaN  NaN   NaN 1.990    NaN   NaN   NaN 1.182   NaN  NaN   NaN
##   Disa 0.9759  NaN 1.529 1.652 0.9029   NaN 1.769 1.011 1.469  1.4 0.750
##   Divu    NaN  1.2 1.638 1.780 1.2829   NaN   NaN 1.014 1.572  NaN 1.389
##   Limo    NaN  NaN   NaN   NaN    NaN   NaN   NaN 0.915   NaN  NaN   NaN
##   Obme    NaN  NaN 1.183   NaN    NaN   NaN   NaN   NaN   NaN  NaN   NaN
##   Sasa 1.2000  NaN   NaN   NaN    NaN   NaN   NaN 1.062   NaN  NaN   NaN
##       sppar
## sphote ther  tome
##   Dian  NaN   NaN
##   Dipu    2   NaN
##   Disa  NaN   NaN
##   Divu  NaN 1.817
##   Limo  NaN   NaN
##   Obme  NaN   NaN
##   Sasa  NaN   NaN
## 
## , , variable = bb
## 
##       sppar
## sphote   conf  dipl  eleg  erge   falc  frat furc   igno  kech morm   neif
##   Dian    NaN   NaN 1.400   NaN    NaN 1.158  NaN    NaN   NaN  NaN    NaN
##   Dipu    NaN   NaN   NaN 1.899    NaN   NaN  NaN 1.1463   NaN  NaN    NaN
##   Disa 0.9007   NaN 1.476 1.581 0.8876   NaN 1.67 0.9432 1.518  1.3 0.6625
##   Divu    NaN 1.075 1.503 1.835 1.2167   NaN  NaN 0.9188 1.406  NaN 1.3594
##   Limo    NaN   NaN   NaN   NaN    NaN   NaN  NaN 0.7900   NaN  NaN    NaN
##   Obme    NaN   NaN 1.025   NaN    NaN   NaN  NaN    NaN   NaN  NaN    NaN
##   Sasa 1.1000   NaN   NaN   NaN    NaN   NaN  NaN 1.0000   NaN  NaN    NaN
##       sppar
## sphote  ther  tome
##   Dian   NaN   NaN
##   Dipu 1.954   NaN
##   Disa   NaN   NaN
##   Divu   NaN 1.833
##   Limo   NaN   NaN
##   Obme   NaN   NaN
##   Sasa   NaN   NaN
## 
## , , variable = cc
## 
##       sppar
## sphote   conf dipl   eleg   erge   falc   frat  furc   igno   kech morm
##   Dian    NaN  NaN 0.8250    NaN    NaN 0.9333   NaN    NaN    NaN  NaN
##   Dipu    NaN  NaN    NaN 1.1497    NaN    NaN   NaN 0.7165    NaN  NaN
##   Disa 0.6713  NaN 0.9987 0.9307 0.5781    NaN 1.158 0.5483 0.7950  0.8
##   Divu    NaN  0.7 1.0667 1.0100 0.8333    NaN   NaN 0.6050 0.7759  NaN
##   Limo    NaN  NaN    NaN    NaN    NaN    NaN   NaN 0.4700    NaN  NaN
##   Obme    NaN  NaN 0.7000    NaN    NaN    NaN   NaN    NaN    NaN  NaN
##   Sasa 0.6500  NaN    NaN    NaN    NaN    NaN   NaN 0.5500    NaN  NaN
##       sppar
## sphote   neif  ther   tome
##   Dian    NaN   NaN    NaN
##   Dipu    NaN 1.135    NaN
##   Disa 0.3750   NaN    NaN
##   Divu 0.9788   NaN 0.9167
##   Limo    NaN   NaN    NaN
##   Obme    NaN   NaN    NaN
##   Sasa    NaN   NaN    NaN
## 
## , , variable = lm
## 
##       sppar
## sphote  conf dipl  eleg  erge  falc frat  furc  igno  kech morm   neif
##   Dian   NaN  NaN 1.500   NaN   NaN  1.2   NaN   NaN   NaN  NaN    NaN
##   Dipu   NaN  NaN   NaN 2.801   NaN  NaN   NaN 1.789   NaN  NaN    NaN
##   Disa 1.173  NaN 2.007 2.667 1.562  NaN 1.987 1.692 2.080  2.2 0.5125
##   Divu   NaN  1.2 2.205 2.520 1.340  NaN   NaN 1.601 1.789  NaN 1.9052
##   Limo   NaN  NaN   NaN   NaN   NaN  NaN   NaN 1.545   NaN  NaN    NaN
##   Obme   NaN  NaN 1.267   NaN   NaN  NaN   NaN   NaN   NaN  NaN    NaN
##   Sasa 1.300  NaN   NaN   NaN   NaN  NaN   NaN 1.467   NaN  NaN    NaN
##       sppar
## sphote  ther  tome
##   Dian   NaN   NaN
##   Dipu 2.802   NaN
##   Disa   NaN   NaN
##   Divu   NaN 2.817
##   Limo   NaN   NaN
##   Obme   NaN   NaN
##   Sasa   NaN   NaN
## 
## , , variable = li
## 
##       sppar
## sphote  conf  dipl  eleg  erge  falc frat  furc  igno  kech morm  neif
##   Dian   NaN   NaN 2.050   NaN   NaN  1.5   NaN   NaN   NaN  NaN   NaN
##   Dipu   NaN   NaN   NaN 2.639   NaN  NaN   NaN 1.774   NaN  NaN   NaN
##   Disa 1.144   NaN 2.342 2.406 1.297  NaN 2.621 1.497 1.893    2 0.800
##   Divu   NaN 1.575 2.272 2.940 1.374  NaN   NaN 1.550 1.806  NaN 1.838
##   Limo   NaN   NaN   NaN   NaN   NaN  NaN   NaN 1.410   NaN  NaN   NaN
##   Obme   NaN   NaN 1.530   NaN   NaN  NaN   NaN   NaN   NaN  NaN   NaN
##   Sasa 1.300   NaN   NaN   NaN   NaN  NaN   NaN 1.363   NaN  NaN   NaN
##       sppar
## sphote  ther  tome
##   Dian   NaN   NaN
##   Dipu 2.812   NaN
##   Disa   NaN   NaN
##   Divu   NaN 3.083
##   Limo   NaN   NaN
##   Obme   NaN   NaN
##   Sasa   NaN   NaN
```


Reformater les moyennes
=====


```r
head(melt(means, na.rm = TRUE))
```

```
##   sphote sppar variable value
## 1   Dian  conf        a   NaN
## 2   Dipu  conf        a   NaN
## 3   Disa  conf        a 1.204
## 4   Divu  conf        a   NaN
## 5   Limo  conf        a   NaN
## 6   Obme  conf        a   NaN
```


Taille d'échantillon
=====


```r
cast(lam, sppar ~ sphote, length, subset = variable == "a")
```

```
##    sppar Dian Dipu Disa Divu Limo Obme Sasa
## 1   conf    0    0    1    0    0    0    1
## 2   dipl    0    0    0    2    0    0    0
## 3   eleg    2    0   35   16    0    6    0
## 4   erge    0    4   12    2    0    0    0
## 5   falc    0    0    2    7    0    0    0
## 6   frat    6    0    0    0    0    0    0
## 7   furc    0    0    7    0    0    0    0
## 8   igno    0    2   17    8   10    0    4
## 9   kech    0    0    7   23    0    0    0
## 10  morm    0    0    1    0    0    0    0
## 11  neif    0    0    4    1    0    0    0
## 12  ther    0    2    0    0    0    0    0
## 13  tome    0    0    0    3    0    0    0
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
head(ddply(lam, sphote ~ sppar ~ variable, function(x) mean(x$value)))
```

```
##   sphote sppar variable    V1
## 1   Dian  eleg        a 1.650
## 2   Dian  eleg        b 1.450
## 3   Dian  eleg        c 0.975
## 4   Dian  eleg        d 0.600
## 5   Dian  eleg        f 0.650
## 6   Dian  eleg        g 0.300
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
## 1 0.2 0.0
## 2 0.4 0.0
## 3 0.8 0.0
## 4 0.2 0.1
## 5 0.4 0.1
## 6 0.8 0.1
##                                                                                                                                      x
## 1 1.56513, -0.41750, -0.89211, -0.68817, 0.48053, 0.95529, -0.97648, 0.46416, -0.95464, -0.74699, 0.07977, 2.09612, -0.00347, -0.96164
## 2                                                                                                     -0.1425, 0.4654, 1.0028, -1.3257
## 3                                                                                            -0.4968, 0.5929, 1.3724, -0.2654, -1.2032
## 4                                         -0.6254, 0.0538, -0.8456, 0.4390, -0.8641, -0.7842, 1.3166, -0.6331, 1.9383, -0.8477, 0.8525
## 5                                                                   -0.1584, 0.3677, -1.1746, 1.1112, -0.9997, 0.9526, 1.0261, -1.1249
## 6                                                                                       -0.60425, 1.72397, -0.64577, 0.02137, -0.49531
```


Approche plyr - scale
======


```r
head(ddply(pop, .(X, Y), function(df) scale(df$N)))
```

```
##     X Y       1
## 1 0.2 0  1.5651
## 2 0.2 0 -0.4175
## 3 0.2 0 -0.8921
## 4 0.2 0 -0.6882
## 5 0.2 0  0.4805
## 6 0.2 0  0.9553
```


Approche plyr - nombre d'échantillons
======


```r
out = ddply(pop, .(X, Y), function(df) length(df$N))
head(out)
```

```
##     X   Y V1
## 1 0.2 0.0 14
## 2 0.2 0.1 11
## 3 0.2 0.3  6
## 4 0.2 0.7 17
## 5 0.4 0.0  4
## 6 0.4 0.1  8
```


Retour aux données
======


```r
ddply(lam, sphote ~ sppar ~ variable, summarize, mean = mean(value), sd = sd(value), 
    n = length(value), min = min(value), max = max(value), median = median(value))
```

```
##     sphote sppar variable   mean      sd  n    min    max median
## 1     Dian  eleg        a 1.6500 0.14142  2 1.5500 1.7500 1.6500
## 2     Dian  eleg        b 1.4500 0.07071  2 1.4000 1.5000 1.4500
## 3     Dian  eleg        c 0.9750 0.10607  2 0.9000 1.0500 0.9750
## 4     Dian  eleg        d 0.6000 0.07071  2 0.5500 0.6500 0.6000
## 5     Dian  eleg        f 0.6500 0.07071  2 0.6000 0.7000 0.6500
## 6     Dian  eleg        g 0.3000 0.00000  2 0.3000 0.3000 0.3000
## 7     Dian  eleg       aa 1.5750 0.03536  2 1.5500 1.6000 1.5750
## 8     Dian  eleg       bb 1.4000 0.00000  2 1.4000 1.4000 1.4000
## 9     Dian  eleg       cc 0.8250 0.10607  2 0.7500 0.9000 0.8250
## 10    Dian  eleg       lm 1.5000 0.42426  2 1.2000 1.8000 1.5000
## 11    Dian  eleg       li 2.0500 0.21213  2 1.9000 2.2000 2.0500
## 12    Dian  frat        a 1.6333 0.05164  6 1.6000 1.7000 1.6000
## 13    Dian  frat        b 1.4667 0.10328  6 1.3000 1.6000 1.5000
## 14    Dian  frat        c 1.0333 0.12111  6 0.9000 1.2000 1.0500
## 15    Dian  frat        d 0.4833 0.11690  6 0.3000 0.6500 0.4750
## 16    Dian  frat        f 0.6083 0.10206  6 0.5000 0.7500 0.6000
## 17    Dian  frat        g 0.2917 0.05845  6 0.2500 0.4000 0.2750
## 18    Dian  frat       aa 1.3333 0.08756  6 1.2500 1.5000 1.3000
## 19    Dian  frat       bb 1.1583 0.23752  6 0.7000 1.4000 1.2000
## 20    Dian  frat       cc 0.9333 0.08756  6 0.8000 1.0500 0.9250
## 21    Dian  frat       lm 1.2000 0.29665  6 0.8000 1.7000 1.1500
## 22    Dian  frat       li 1.5000 0.20000  6 1.2000 1.7000 1.5000
## 23    Dipu  erge        a 2.3865 0.06632  4 2.3227 2.4631 2.3800
## 24    Dipu  erge        b 2.3142 0.05540  4 2.2426 2.3666 2.3238
## 25    Dipu  erge        c 1.6667 0.11365  4 1.5488 1.7773 1.6702
## 26    Dipu  erge        d 0.8382 0.09432  4 0.7230 0.9420 0.8440
## 27    Dipu  erge        f 1.1478 0.14474  4 0.9523 1.3013 1.1688
## 28    Dipu  erge        g 0.5814 0.05394  4 0.5390 0.6523 0.5672
## 29    Dipu  erge       aa 1.9896 0.18428  4 1.7204 2.1384 2.0498
## 30    Dipu  erge       bb 1.8985 0.21375  4 1.5915 2.0791 1.9618
## 31    Dipu  erge       cc 1.1497 0.05319  4 1.0991 1.2159 1.1418
## 32    Dipu  erge       lm 2.8011 0.21681  4 2.4925 2.9913 2.8604
## 33    Dipu  erge       li 2.6393 0.09871  4 2.5035 2.7293 2.6622
## 34    Dipu  igno        a 1.2776 0.03099  2 1.2557 1.2995 1.2776
## 35    Dipu  igno        b 1.2736 0.05915  2 1.2318 1.3155 1.2736
## 36    Dipu  igno        c 0.8402 0.07917  2 0.7842 0.8962 0.8402
## 37    Dipu  igno        d 0.6224 0.12635  2 0.5330 0.7117 0.6224
## 38    Dipu  igno        f 0.6856 0.07106  2 0.6354 0.7359 0.6856
## 39    Dipu  igno        g 0.3492 0.02378  2 0.3324 0.3660 0.3492
## 40    Dipu  igno       aa 1.1818 0.03779  2 1.1551 1.2085 1.1818
## 41    Dipu  igno       bb 1.1463 0.03283  2 1.1231 1.1695 1.1463
## 42    Dipu  igno       cc 0.7165 0.05139  2 0.6801 0.7528 0.7165
## 43    Dipu  igno       lm 1.7888 0.09472  2 1.7218 1.8557 1.7888
## 44    Dipu  igno       li 1.7742 0.11591  2 1.6922 1.8562 1.7742
## 45    Dipu  ther        a 2.3652 0.04362  2 2.3344 2.3961 2.3652
## 46    Dipu  ther        b 2.2182 0.12896  2 2.1270 2.3094 2.2182
## 47    Dipu  ther        c 1.5876 0.10768  2 1.5115 1.6637 1.5876
## 48    Dipu  ther        d 0.8393 0.03900  2 0.8117 0.8668 0.8393
## 49    Dipu  ther        f 1.0874 0.08959  2 1.0240 1.1507 1.0874
## 50    Dipu  ther        g 0.5883 0.01671  2 0.5765 0.6001 0.5883
## 51    Dipu  ther       aa 1.9996 0.10629  2 1.9245 2.0748 1.9996
## 52    Dipu  ther       bb 1.9543 0.09822  2 1.8849 2.0238 1.9543
## 53    Dipu  ther       cc 1.1350 0.02980  2 1.1139 1.1561 1.1350
## 54    Dipu  ther       lm 2.8016 0.06902  2 2.7528 2.8504 2.8016
## 55    Dipu  ther       li 2.8119 0.04996  2 2.7766 2.8473 2.8119
## 56    Disa  conf        a 1.2035      NA  1 1.2035 1.2035 1.2035
## 57    Disa  conf        b 1.2436      NA  1 1.2436 1.2436 1.2436
## 58    Disa  conf        c 0.7498      NA  1 0.7498 0.7498 0.7498
## 59    Disa  conf        d 0.7443      NA  1 0.7443 0.7443 0.7443
## 60    Disa  conf        f 0.6972      NA  1 0.6972 0.6972 0.6972
## 61    Disa  conf        g 0.3702      NA  1 0.3702 0.3702 0.3702
## 62    Disa  conf       aa 0.9759      NA  1 0.9759 0.9759 0.9759
## 63    Disa  conf       bb 0.9007      NA  1 0.9007 0.9007 0.9007
## 64    Disa  conf       cc 0.6713      NA  1 0.6713 0.6713 0.6713
## 65    Disa  conf       lm 1.1728      NA  1 1.1728 1.1728 1.1728
## 66    Disa  conf       li 1.1440      NA  1 1.1440 1.1440 1.1440
## 67    Disa  eleg        a 1.7402 0.31848 35 1.3000 2.4500 1.7716
## 68    Disa  eleg        b 1.6621 0.33940 35 1.2000 2.3500 1.7324
## 69    Disa  eleg        c 1.1857 0.26628 35 0.8000 1.8200 1.2000
## 70    Disa  eleg        d 0.5340 0.13952 35 0.3000 0.7686 0.5200
## 71    Disa  eleg        f 0.6263 0.16198 35 0.4000 0.9542 0.6000
## 72    Disa  eleg        g 0.3587 0.08950 34 0.2000 0.5394 0.3401
## 73    Disa  eleg       aa 1.5289 0.28876 35 1.1000 2.0300 1.5000
## 74    Disa  eleg       bb 1.4760 0.31354 35 1.0000 2.0800 1.5000
## 75    Disa  eleg       cc 0.9987 0.18560 35 0.7000 1.3486 1.0000
## 76    Disa  eleg       lm 2.0067 0.37158 34 1.4600 2.6100 2.0799
## 77    Disa  eleg       li 2.3420 0.59459 35 1.5000 3.6000 2.3031
## 78    Disa  erge        a 1.9312 0.35794 12 1.2000 2.3500 2.0276
## 79    Disa  erge        b 1.8283 0.38234 12 1.0000 2.2400 1.9166
## 80    Disa  erge        c 1.2777 0.32909 12 0.6500 1.8800 1.2818
## 81    Disa  erge        d 0.6802 0.17764 12 0.3500 0.9084 0.7420
## 82    Disa  erge        f 0.9088 0.22231 12 0.3500 1.1400 0.9868
## 83    Disa  erge        g 0.4777 0.09884 12 0.3000 0.6200 0.4671
## 84    Disa  erge       aa 1.6516 0.28155 13 1.0000 2.0144 1.6700
## 85    Disa  erge       bb 1.5806 0.32939 13 0.8000 1.9258 1.6700
## 86    Disa  erge       cc 0.9307 0.20277 13 0.4000 1.1595 0.9888
## 87    Disa  erge       lm 2.6667 0.53157 13 1.3000 3.3900 2.7781
## 88    Disa  erge       li 2.4055 0.46826 13 1.4000 3.0300 2.4053
## 89    Disa  falc        a 1.4428 0.50516  2 1.0856 1.8000 1.4428
## 90    Disa  falc        b 0.9940 0.13288  2 0.9000 1.0879 0.9940
## 91    Disa  falc        c 0.5997 0.14105  2 0.5000 0.6995 0.5997
## 92    Disa  falc        d 0.4850 0.12015  2 0.4000 0.5699 0.4850
## 93    Disa  falc        f 0.4599 0.08465  2 0.4000 0.5197 0.4599
## 94    Disa  falc        g 0.2461 0.06523  2 0.2000 0.2923 0.2461
## 95    Disa  falc       aa 0.9029 0.07485  2 0.8500 0.9559 0.9029
## 96    Disa  falc       bb 0.8876 0.19459  2 0.7500 1.0252 0.8876
## 97    Disa  falc       cc 0.5781 0.11039  2 0.5000 0.6561 0.5781
## 98    Disa  falc       lm 1.5615 0.05440  2 1.5231 1.6000 1.5615
## 99    Disa  falc       li 1.2975 0.27929  2 1.1000 1.4950 1.2975
## 100   Disa  furc        a 1.9684 0.09914  7 1.8128 2.1000 2.0000
## 101   Disa  furc        b 1.8575 0.08338  7 1.6910 1.9387 1.8500
## 102   Disa  furc        c 1.3522 0.10327  7 1.2403 1.5000 1.3047
## 103   Disa  furc        d 0.6287 0.06921  7 0.5200 0.7219 0.6000
## 104   Disa  furc        f 0.7512 0.04317  7 0.7000 0.8022 0.7500
## 105   Disa  furc        g 0.4145 0.08908  7 0.3000 0.5374 0.4000
## 106   Disa  furc       aa 1.7694 0.10440  7 1.5785 1.8800 1.8000
## 107   Disa  furc       bb 1.6700 0.10225  7 1.4765 1.7700 1.7000
## 108   Disa  furc       cc 1.1579 0.09091  7 0.9888 1.2685 1.2000
## 109   Disa  furc       lm 1.9873 0.22851  7 1.6926 2.3500 1.9500
## 110   Disa  furc       li 2.6212 0.20412  7 2.1869 2.8000 2.6803
## 111   Disa  igno        a 1.1604 0.30233 17 0.7000 1.6700 1.0400
## 112   Disa  igno        b 1.1171 0.31170 16 0.6000 1.6100 1.0400
## 113   Disa  igno        c 0.7640 0.20751 15 0.4000 1.0400 0.7800
## 114   Disa  igno        d 0.4677 0.15562 15 0.2000 0.7185 0.5000
## 115   Disa  igno        f 0.5664 0.21032 15 0.2500 0.8800 0.5200
## 116   Disa  igno        g 0.2548 0.09291 15 0.1500 0.4166 0.2600
## 117   Disa  igno       aa 1.0110 0.24333 17 0.6500 1.3500 1.0000
## 118   Disa  igno       bb 0.9432 0.26129 16 0.5000 1.3000 0.9650
## 119   Disa  igno       cc 0.5483 0.12650 16 0.3000 0.7300 0.5700
## 120   Disa  igno       lm 1.6923 0.58503 18 0.8000 2.9700 1.5600
## 121   Disa  igno       li 1.4970 0.47339 18 0.8000 2.4000 1.3750
## 122   Disa  kech        a 1.7886 0.53890  7 0.8000 2.1400 2.0800
## 123   Disa  kech        b 1.8333 0.31443  6 1.2000 2.0300 1.9550
## 124   Disa  kech        c 1.2050 0.23484  6 0.7300 1.3500 1.3000
## 125   Disa  kech        d 0.6117 0.10797  6 0.4100 0.7300 0.6200
## 126   Disa  kech        f 1.0317 0.26634  6 0.5200 1.2500 1.1150
## 127   Disa  kech        g 0.4483 0.13318  6 0.2000 0.5700 0.4950
## 128   Disa  kech       aa 1.4686 0.49664  7 0.5000 1.8200 1.6700
## 129   Disa  kech       bb 1.5183 0.24604  6 1.0400 1.7200 1.5850
## 130   Disa  kech       cc 0.7950 0.09138  6 0.6200 0.8800 0.8300
## 131   Disa  kech       lm 2.0800 0.70228  7 0.8000 2.7100 2.2400
## 132   Disa  kech       li 1.8929 0.54301  7 0.9000 2.4000 1.9800
## 133   Disa  morm        a 1.6000      NA  1 1.6000 1.6000 1.6000
## 134   Disa  morm        b 1.5500      NA  1 1.5500 1.5500 1.5500
## 135   Disa  morm        c 1.2500      NA  1 1.2500 1.2500 1.2500
## 136   Disa  morm        d 0.7000      NA  1 0.7000 0.7000 0.7000
## 137   Disa  morm        f 0.8000      NA  1 0.8000 0.8000 0.8000
## 138   Disa  morm        g 0.6500      NA  1 0.6500 0.6500 0.6500
## 139   Disa  morm       aa 1.4000      NA  1 1.4000 1.4000 1.4000
## 140   Disa  morm       bb 1.3000      NA  1 1.3000 1.3000 1.3000
## 141   Disa  morm       cc 0.8000      NA  1 0.8000 0.8000 0.8000
## 142   Disa  morm       lm 2.2000      NA  1 2.2000 2.2000 2.2000
## 143   Disa  morm       li 2.0000      NA  1 2.0000 2.0000 2.0000
## 144   Disa  neif        a 0.8625 0.04787  4 0.8000 0.9000 0.8750
## 145   Disa  neif        b 0.7500 0.05774  4 0.7000 0.8000 0.7500
## 146   Disa  neif        c 0.4500 0.07071  4 0.3500 0.5000 0.4750
## 147   Disa  neif        d 0.3250 0.06455  4 0.2500 0.4000 0.3250
## 148   Disa  neif        f 0.3500 0.04082  4 0.3000 0.4000 0.3500
## 149   Disa  neif        g 0.2000 0.04082  4 0.1500 0.2500 0.2000
## 150   Disa  neif       aa 0.7500 0.04082  4 0.7000 0.8000 0.7500
## 151   Disa  neif       bb 0.6625 0.04787  4 0.6000 0.7000 0.6750
## 152   Disa  neif       cc 0.3750 0.06455  4 0.3000 0.4500 0.3750
## 153   Disa  neif       lm 0.5125 0.16520  4 0.3000 0.7000 0.5250
## 154   Disa  neif       li 0.8000 0.20412  4 0.6500 1.1000 0.7250
## 155   Divu  dipl        a 1.1000 0.14142  2 1.0000 1.2000 1.1000
## 156   Divu  dipl        b 1.0250 0.17678  2 0.9000 1.1500 1.0250
## 157   Divu  dipl        c 0.5250 0.10607  2 0.4500 0.6000 0.5250
## 158   Divu  dipl        d 0.4500 0.07071  2 0.4000 0.5000 0.4500
## 159   Divu  dipl        f 0.4750 0.03536  2 0.4500 0.5000 0.4750
## 160   Divu  dipl        g 0.2250 0.03536  2 0.2000 0.2500 0.2250
## 161   Divu  dipl       aa 1.2000 0.42426  2 0.9000 1.5000 1.2000
## 162   Divu  dipl       bb 1.0750 0.31820  2 0.8500 1.3000 1.0750
## 163   Divu  dipl       cc 0.7000 0.28284  2 0.5000 0.9000 0.7000
## 164   Divu  dipl       lm 1.2000 0.14142  2 1.1000 1.3000 1.2000
## 165   Divu  dipl       li 1.5750 0.38891  2 1.3000 1.8500 1.5750
## 166   Divu  eleg        a 1.7600 0.14394 16 1.5000 2.0600 1.7250
## 167   Divu  eleg        b 1.6373 0.16594 15 1.3000 1.9300 1.6500
## 168   Divu  eleg        c 1.2436 0.10172 14 1.1000 1.5100 1.2250
## 169   Divu  eleg        d 0.5113 0.09812 15 0.3100 0.7000 0.5000
## 170   Divu  eleg        f 0.5687 0.08814 15 0.3600 0.7500 0.5500
## 171   Divu  eleg        g 0.3307 0.05824 15 0.2000 0.4000 0.3500
## 172   Divu  eleg       aa 1.6381 0.12346 16 1.4000 1.9300 1.6250
## 173   Divu  eleg       bb 1.5027 0.17576 15 1.0000 1.8100 1.5000
## 174   Divu  eleg       cc 1.0667 0.15060 15 0.9000 1.5000 1.0000
## 175   Divu  eleg       lm 2.2046 1.02134 13 1.2000 5.4300 1.9000
## 176   Divu  eleg       li 2.2723 0.25862 13 1.7700 2.6600 2.3000
## 177   Divu  erge        a 2.1700 0.09899  2 2.1000 2.2400 2.1700
## 178   Divu  erge        b 2.0450 0.27577  2 1.8500 2.2400 2.0450
## 179   Divu  erge        c 1.1750 0.60104  2 0.7500 1.6000 1.1750
## 180   Divu  erge        d 0.9250 0.17678  2 0.8000 1.0500 0.9250
## 181   Divu  erge        f 0.9000 0.14142  2 0.8000 1.0000 0.9000
## 182   Divu  erge        g 0.6650 0.30406  2 0.4500 0.8800 0.6650
## 183   Divu  erge       aa 1.7800 0.02828  2 1.7600 1.8000 1.7800
## 184   Divu  erge       bb 1.8350 0.12021  2 1.7500 1.9200 1.8350
## 185   Divu  erge       cc 1.0100 0.15556  2 0.9000 1.1200 1.0100
## 186   Divu  erge       lm 2.5200 0.73539  2 2.0000 3.0400 2.5200
## 187   Divu  erge       li 2.9400 0.08485  2 2.8800 3.0000 2.9400
## 188   Divu  falc        a 1.4071 0.69770  7 0.9500 2.8400 1.0900
## 189   Divu  falc        b 1.3700 0.72680  6 0.9000 2.7100 0.9950
## 190   Divu  falc        c 0.7040 0.31477  5 0.4500 1.2500 0.6200
## 191   Divu  falc        d 0.5080 0.06611  5 0.4000 0.5700 0.5200
## 192   Divu  falc        f 0.4483 0.10420  6 0.3500 0.6200 0.4350
## 193   Divu  falc        g 0.2740 0.02881  5 0.2500 0.3100 0.2600
## 194   Divu  falc       aa 1.2829 0.62284  7 0.9000 2.5800 0.9500
## 195   Divu  falc       bb 1.2167 0.68608  6 0.5000 2.4500 0.9950
## 196   Divu  falc       cc 0.8333 0.41244  6 0.3600 1.5500 0.7500
## 197   Divu  falc       lm 1.3400 0.51400  5 0.6200 1.9800 1.4000
## 198   Divu  falc       li 1.3740 0.29653  5 0.9500 1.7700 1.4000
## 199   Divu  igno        a 1.2288 0.19313  8 1.0000 1.5000 1.2000
## 200   Divu  igno        b 1.1557 0.18946  7 0.9000 1.3500 1.2000
## 201   Divu  igno        c 0.7486 0.12321  7 0.6000 0.9400 0.8000
## 202   Divu  igno        d 0.4943 0.15296  7 0.3000 0.6500 0.6000
## 203   Divu  igno        f 0.5443 0.19764  7 0.3000 0.8500 0.6000
## 204   Divu  igno        g 0.3086 0.08859  7 0.2000 0.4500 0.3000
## 205   Divu  igno       aa 1.0137 0.23784  8 0.4700 1.2000 1.0700
## 206   Divu  igno       bb 0.9188 0.24982  8 0.3600 1.1000 0.9950
## 207   Divu  igno       cc 0.6050 0.08159  8 0.5000 0.7500 0.5850
## 208   Divu  igno       lm 1.6013 0.45593  8 1.0000 2.1500 1.5550
## 209   Divu  igno       li 1.5500 0.27568  6 1.2000 1.8000 1.6750
## 210   Divu  kech        a 1.8109 0.16946 23 1.4000 2.0300 1.8000
## 211   Divu  kech        b 1.7077 0.16923 22 1.4000 1.9300 1.7600
## 212   Divu  kech        c 1.0921 0.25174 19 0.7000 1.5600 1.1000
## 213   Divu  kech        d 0.5706 0.12473 18 0.3100 0.8000 0.6000
## 214   Divu  kech        f 0.8145 0.14719 22 0.5000 1.0400 0.8650
## 215   Divu  kech        g 0.3847 0.12782 17 0.2500 0.7300 0.3600
## 216   Divu  kech       aa 1.5722 0.16268 23 1.1000 1.8000 1.5600
## 217   Divu  kech       bb 1.4064 0.24383 22 0.7000 1.7000 1.4600
## 218   Divu  kech       cc 0.7759 0.23734 22 0.3100 1.4000 0.7300
## 219   Divu  kech       lm 1.7886 0.34878 22 0.6200 2.1400 1.8550
## 220   Divu  kech       li 1.8059 0.22549 22 1.3500 2.1900 1.8000
## 221   Divu  neif        a 1.8146      NA  1 1.8146 1.8146 1.8146
## 222   Divu  neif        b 1.7175      NA  1 1.7175 1.7175 1.7175
## 223   Divu  neif        c 1.2890      NA  1 1.2890 1.2890 1.2890
## 224   Divu  neif        d 0.7173      NA  1 0.7173 0.7173 0.7173
## 225   Divu  neif        f 0.7970      NA  1 0.7970 0.7970 0.7970
## 226   Divu  neif        g 0.4476      NA  1 0.4476 0.4476 0.4476
## 227   Divu  neif       aa 1.3888      NA  1 1.3888 1.3888 1.3888
## 228   Divu  neif       bb 1.3594      NA  1 1.3594 1.3594 1.3594
## 229   Divu  neif       cc 0.9788      NA  1 0.9788 0.9788 0.9788
## 230   Divu  neif       lm 1.9052      NA  1 1.9052 1.9052 1.9052
## 231   Divu  neif       li 1.8381      NA  1 1.8381 1.8381 1.8381
## 232   Divu  tome        a 2.2833 0.12583  3 2.1500 2.4000 2.3000
## 233   Divu  tome        b 2.1833 0.07638  3 2.1000 2.2500 2.2000
## 234   Divu  tome        c 1.2833 0.10408  3 1.2000 1.4000 1.2500
## 235   Divu  tome        d 0.8000 0.13229  3 0.6500 0.9000 0.8500
## 236   Divu  tome        f 1.1500 0.08660  3 1.0500 1.2000 1.2000
## 237   Divu  tome        g 0.3833 0.07638  3 0.3000 0.4500 0.4000
## 238   Divu  tome       aa 1.8167 0.02887  3 1.8000 1.8500 1.8000
## 239   Divu  tome       bb 1.8333 0.07638  3 1.7500 1.9000 1.8500
## 240   Divu  tome       cc 0.9167 0.02887  3 0.9000 0.9500 0.9000
## 241   Divu  tome       lm 2.8167 0.44814  3 2.3000 3.1000 3.0500
## 242   Divu  tome       li 3.0833 0.30139  3 2.8000 3.4000 3.0500
## 243   Limo  igno        a 1.0200 0.11106 10 0.8500 1.2000 1.0250
## 244   Limo  igno        b 0.9100 0.10220 10 0.8000 1.1000 0.9000
## 245   Limo  igno        c 0.5050 0.07246 10 0.3500 0.6000 0.5000
## 246   Limo  igno        d 0.4350 0.07091 10 0.3000 0.5000 0.4500
## 247   Limo  igno        f 0.4600 0.09944 10 0.3000 0.6000 0.4750
## 248   Limo  igno        g 0.2400 0.05164 10 0.2000 0.3500 0.2250
## 249   Limo  igno       aa 0.9150 0.07472 10 0.8000 1.0000 0.9000
## 250   Limo  igno       bb 0.7900 0.07746 10 0.7000 0.9000 0.8000
## 251   Limo  igno       cc 0.4700 0.07528 10 0.4000 0.6000 0.4500
## 252   Limo  igno       lm 1.5450 0.19358 10 1.2500 1.9000 1.5250
## 253   Limo  igno       li 1.4100 0.17288 10 1.2000 1.7000 1.4000
## 254   Obme  eleg        a 1.3917 0.05845  6 1.3000 1.4500 1.4000
## 255   Obme  eleg        b 1.2917 0.08010  6 1.2000 1.4000 1.3000
## 256   Obme  eleg        c 0.8667 0.05164  6 0.8000 0.9000 0.9000
## 257   Obme  eleg        d 0.4250 0.06892  6 0.3000 0.5000 0.4500
## 258   Obme  eleg        f 0.4667 0.06055  6 0.4000 0.5500 0.4750
## 259   Obme  eleg        g 0.3417 0.06646  6 0.2500 0.4500 0.3500
## 260   Obme  eleg       aa 1.1833 0.09309  6 1.0500 1.3000 1.2000
## 261   Obme  eleg       bb 1.0250 0.08216  6 0.9000 1.1000 1.0500
## 262   Obme  eleg       cc 0.7000 0.05477  6 0.6500 0.8000 0.7000
## 263   Obme  eleg       lm 1.2667 0.25033  6 0.9000 1.6000 1.3000
## 264   Obme  eleg       li 1.5300 0.17176  5 1.2500 1.7000 1.6000
## 265   Sasa  conf        a 1.3000      NA  1 1.3000 1.3000 1.3000
## 266   Sasa  conf        b 1.2500      NA  1 1.2500 1.2500 1.2500
## 267   Sasa  conf        c 0.5500      NA  1 0.5500 0.5500 0.5500
## 268   Sasa  conf        d 0.3000      NA  1 0.3000 0.3000 0.3000
## 269   Sasa  conf        f 0.3500      NA  1 0.3500 0.3500 0.3500
## 270   Sasa  conf        g 0.2000      NA  1 0.2000 0.2000 0.2000
## 271   Sasa  conf       aa 1.2000      NA  1 1.2000 1.2000 1.2000
## 272   Sasa  conf       bb 1.1000      NA  1 1.1000 1.1000 1.1000
## 273   Sasa  conf       cc 0.6500      NA  1 0.6500 0.6500 0.6500
## 274   Sasa  conf       lm 1.3000      NA  1 1.3000 1.3000 1.3000
## 275   Sasa  conf       li 1.3000      NA  1 1.3000 1.3000 1.3000
## 276   Sasa  igno        a 1.1250 0.10408  4 1.0000 1.2500 1.1250
## 277   Sasa  igno        b 1.0125 0.13150  4 0.9000 1.2000 0.9750
## 278   Sasa  igno        c 0.6625 0.04787  4 0.6000 0.7000 0.6750
## 279   Sasa  igno        d 0.4000 0.09129  4 0.3000 0.5000 0.4000
## 280   Sasa  igno        f 0.4125 0.13150  4 0.3000 0.5500 0.4000
## 281   Sasa  igno        g 0.2125 0.02500  4 0.2000 0.2500 0.2000
## 282   Sasa  igno       aa 1.0625 0.09465  4 1.0000 1.2000 1.0250
## 283   Sasa  igno       bb 1.0000 0.07071  4 0.9500 1.1000 0.9750
## 284   Sasa  igno       cc 0.5500 0.10801  4 0.4500 0.7000 0.5250
## 285   Sasa  igno       lm 1.4667 0.11547  3 1.4000 1.6000 1.4000
## 286   Sasa  igno       li 1.3625 0.13769  4 1.2000 1.5000 1.3750
```



