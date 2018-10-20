## Modified by Alex Hudson 2018-10-19 19:38 CDT

## The functions makeCacheMatrix() and cacheSolve() allow us to 
## define a "matrix" object that is accompanied by a variable 
## whose purpose is to store the inverse of the matrix. In the 
## event that we need to calculate the inverse of the same matrix 
## multiple times, cacheSolve() calls the standard solve() 
## function the first time, then retrieves the cached variable 
## containing the calculated inverse for any subsequent calls.

## The function makeCacheMatrix() returns a list containing four 
## functions. These functions, combined with the variables x and 
## m stored in the object's enclosing environment, allow the user 
## to (1) get the value of the matrix, (2) set the value of the 
## matrix, (3) get the value (or `NULL` if no value) of the inverse 
## of the matrix, and (4) set the value of the inverse of the 
## matrix.

makeCacheMatrix <- function(x = matrix()) {
    inv <- NULL
    set <- function(y) {
        x <<- y
        inv <<- NULL
    }
    get <- function() {x}
    setinv <- function(inverse) {inv <<- inverse}
    getinv <- function() {inv}
    list(set = set, 
         get = get, 
         setinv = setinv, 
         getinv = getinv)
}


## The function cacheSolve() is designed to emulate the solve() 
## function with matrices that have been created using our custom 
## function makeCacheMatrix(). It first checks the value stored 
## as the matrix inverse. If the value is not NULL, then that 
## value is returned; otherwise, the matrix does not have a 
## cached inverse matrix, and so solve() is called to calculate 
## it. The result is stored in the matrix object and returned.

cacheSolve <- function(x, ...) {
    inv <- x$getinv()
    if(!is.null(inv)) {
        message("getting cached inverse")
        return(inv)
    }
    mat <- x$get()
    inv <- solve(mat, ...)
    x$setinv(inv)
    inv
}
