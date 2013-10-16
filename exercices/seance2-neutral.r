generatePool = function(J) c(1:J)

generateIsland = function(K, pool) sample(pool, K, replace=TRUE)

timeStep = function(island, pool, m, n)
{
   K = length(island)
   island = island[rbinom(K, 1, m) == FALSE]
   new_ind = K-length(island)
   new_sp = replicate(new_ind, ifelse(runif(1) < n, sample(island, 1), sample(pool, 1)))
   return(as.numeric(c(island, new_sp)))
}

richness = function(island) length(unique(island))

simulation = function(K, J, m, n, steps)
{
  Po = generatePool(J)
  Sp = matrix(0, ncol=K, nrow=steps)
  Sp[1, ] = generateIsland(K, Po)
  for(i in c(2:steps)) Sp[i,] = timeStep(Sp[(i-1),], Po, m, n)
  return(Sp)
}

out = simulation(80, 100, 0.4, 0.6, 30)
plot(apply(out, 1, richness), type='l')
