## R Programming Course --- Assignment 2 --- R. Hansen

## The following functions provide a mechanism to cache the inverse of a square matrix.
# This is typically used for large matrices where the inverse is used multiple times,
# but we don't want to recompute the inverse each time we use it.
# There are two main functions:
#     makeCacheMatrix() --- This creates a cached matrix object and the functions used to access it.
#     cacheSolve()      --- This function is used to access the (cached) inverted matrix.
#
# Usage:
#     mc <- makeCacheMatrix(mx)   # converts the matrix "mx" into a cached matrix object "mc"
#     cacheSolve(mc)              # returns the inverse of the "mc" matrix object
#
# Notes:  The matrix must be a square matrix to calculate an inverse.
#         No error checking is done for singularity, NULL matrix, etc.

## The "mackeCacheMatrix" function creates a matrix object and the functions used to access it.
# It creates the following 5 methods:
#   set(mx)         --- store the original matrix from the standard matrix supplied as an argument (mx)
#   get()           --- returns the original matrix 
#   setinverse()    --- forces the inverse to be calculated
#   getinverse()    --- returns the inverse (either calculated or cached, as appropriate)
#   inverseValid()  --- flag which indicates if a cached inverse has been calculated
#
# Normally, a user wouldn't need any of these functions because "cacheSolve()" is used to retrieve the cached inverse matrix
# However, a user could use the functions as follows ("mc" is the matrix object):
#   mc$set(mx)      --- This resets the matrix to the matrix values in "mx" (i.e., the matrix object is reused)
#   mc$get()        --- The original matrix is returned
#   mc$setinverse() --- This forces the inverse matrix to be recalculated regardless of whether there is a cached one or not
#   mc$getinverse() --- This is identical to "cacheSolve(mc)" -- it returns the matrix inverse (calculated or cached, as appropriate)
#   mc$inverseValid() --- This returns a boolean that indicates if there is a valid cached inverse
#
makeCacheMatrix <- function(x = matrix())
{
  ## create a variable that will hold the inverse matrix
    inverse <- NULL
  ## create a flag to indicate if the matrix has been inverted or not
    inverted <- FALSE
  
  ## create a function to retrieve the 'inverted' flag
    inverseValid <- function() inverted
    
  ## create a function that sets the contents of the original matrix
    set <- function(y)
    {
      x <<- y   ## set the parent x matrix
      ## since the matrix has been set (or reset), make sure flag is false because inverse is no longer valid
      inverted <<- FALSE   
    }
  
  ## create a function that gets the contents of the matrix
    get <- function() { x } ## There are no parameters; we simply return the matrix
  
  ## create a function that calculates the inverse of the matrix
  ## This normally gets called by "getinverse()" when an inverse matrix hasn't been calculated yet
    setinverse <- function()
    {
      message("Calculating Inverse")  ## we would probably comment out this line in a real application
      
      ## we force 'b' to be empty so that an inverse matrix will be generated, and
      ## so that the user can't enter a 'b' matrix
      inverse <<- solve(x, b=)
      ## and set the flag indicating the cached inverse is valid
      inverted <<- TRUE
    }
  
  ## create a function that retrieves the 'inverse' matrix
    getinverse <- function()
    {
      ## see if an inverse has already been calculated, if not, calculate it (and cache it)
      if(!inverseValid()) setinverse()
      ## return the cached inverse matrix
      inverse
    }
  
  ## create and return a list which is a list of the callable functions
  list(set=set, get=get, setinverse=setinverse, getinverse=getinverse, inverseValid=inverseValid)
}


## The "cacheSolve" function returns the inverse of a matrix object created by "makeCacheMatrix"
# It is modeled after the normal R "solve" function, but takes a single parameter which is
# the matrix object created by "makeCacheMatrix"
# Usage:
#     mc <- makeCacheMatrix(mx)   # converts the matrix "mx" into a cached matrix object "mc"
#     cacheSolve(mc)              # returns the inverse of the "mc" matrix object
# 
cacheSolve <- function(x) {
  ## Return a matrix that is the inverse of 'x' where 'x' is a matrix object created by "makeCacheMatrix"
  ## get the inverted matrix and return it
  x$getinverse()
}



