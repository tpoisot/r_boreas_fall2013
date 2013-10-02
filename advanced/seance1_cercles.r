getBorders = function(circles)
{
   # Finds the coordinates of the rectangle encompassing
   # all circles
   BL = list(x=0.0,y=0.0)
   TR = list(x=0.0,y=0.0)
   for(ci in circles)
   {
      # Find the max and min
      cxMin = min(ci$x - ci$d, ci$x + ci$d)
      cxMax = max(ci$x - ci$d, ci$x + ci$d)
      cyMin = min(ci$y - ci$d, ci$y + ci$d)
      cyMax = max(ci$y - ci$d, ci$y + ci$d)
      # Update
      if(cxMin < BL$x) BL$x = cxMin
      if(cyMin < BL$y) BL$y = cyMin
      if(cxMax > TR$x) TR$x = cxMax
      if(cyMax > TR$y) TR$y = cyMax
   }
   return(list(bottomleft=BL, topright=TR))
}

makeMesh = function(npoints=1000, bottomleft, topright)
{
   # Generates npoints random points in the rectangle
   # defined by bottomleft -> topright
   x = runif(npoints, bottomleft$x, topright$x)
   y = runif(npoints, bottomleft$y, topright$y)
   Points = list()
   for(i in c(1:npoints)) Points[[i]] = list(x=x[i], y=y[i])
   return(Points)
}

euclideanDistance = function(p1, p2)
{
   # Calculates the Euclidean distance between two objects
   # Objects are lists with attributes x and y
   # Returns the distance
   d = 0
   return(d)
}

inCircle = function(point, circle) euclideanDistance(point, circle) < circle$d

getProportionShared = function(c1, c2, npoints)
{
   # Step 1 - find the rectangle
   rectangle = getBorders(c(c1, c2))
   # Step 2 - make the mesh
   mesh = makeMesh(npoints, rectangle$bottomleft, rectangle$topright)
   # Step 3 - for each point, check whether it is in one or two circles
   in_c1 = unlist(lapply(mesh, function(x) inCircle(x, c1)))
   in_c2 = unlist(lapply(mesh, function(x) inCircle(x, c2)))
   in_which = in_c1 + in_c2
   # Step 4 - measure the relative area
   totalIn = sum(in_which > 0)
   totalBoth = sum(in_which == 2)
   return(totalBoth/totalIn)
}

c1 = list(x=0, y=0, d=2)
c2 = list(x=2, y=0.3, d=1.8)

print(getProportionShared(c1, c2, 100))
