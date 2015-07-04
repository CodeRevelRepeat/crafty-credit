//Instructions:

// Accomplish in a language of your choice:

// Input: Given an array of integers

// Output: In whatever representation you wish, output each integer in the array and all the other integers in the array that are
// factors of the first integer.  

// Example:

//   Given an array of [10, 5, 2, 20], the output would be:

// {10: [5, 2], 5: [], 2: [], 20: [10,5,2]}


// See factors function below.  

// Additional Questions: 

// 1.  What if you were to cache the calculation, for example in the file system.  What would an example implementation
// of the cache look like?  By cache I mean, given an array input, skip the calculation of the output if you have already
// calculated the output at least once already.

// See cache funciton below for example of caching.  

// 2.  What is the performance of your caching implementation?  Is there any way to make it more performant.

// My cache implementation does look up in constant time.  However, as new arrays are inputted the storage size will grow.  
// If we wanted to limit storage size, we could implement a system whereby the least recently accessed array is deleted once the storage size reaches
// a certain threshold.   

// 3.  What if you wanted to reverse the functionality.  What if you wanted to output each integer and all the other integers in the 
// array that is the first integer is a factor of I.E:

// Given an array of [10, 5, 2, 20], the output would be:
// {10: [20], 5: [10,20], 2: [10, 20], 20: []}


//See the multiples function below.  

// Would this change your caching algorithm?

// I used the same caching algorithm for multiples.

// With caching, the output should be the same except the calculations are not performed.


var factors = function(array){

  console.log("called factors")

  var result = {};


  for(var i=0; i<array.length; i++){

    var temp = [];

    for(var j=0; j<array.length; j++){
      if(array[i] % array[j] === 0 && array[i]/array[j] !== 1){
        temp.push(array[j]);
      }

    }


    result[array[i]] = temp;

  }


  return result;
}


var multiples = function(array){

  console.log("called multiples");

  var result = {};

  for(var i=0; i<array.length; i++){

    var temp = [];

    for(var j=0; j<array.length; j++){
      if(array[j] % array[i] === 0 && array[j]/array[i] !== 1){
        temp.push(array[j]);
      }

    }


    result[array[i]] = temp;

  }


  return result;
}





var cache = function(expensiveFunc){
  var storage = {};

  return function(){
    var item = JSON.stringify(arguments);
    if (!storage.hasOwnProperty(item)){
      storage[item] = expensiveFunc.apply(this, arguments);
    }
    return storage[item];
  }
}

var cacheFactors = cache(factors);

var cacheMultiples = cache(multiples);




console.log("factors without cache", factors([10, 5, 2, 20]));
console.log("multiples without cache", multiples([10, 5, 2, 20]));
console.log("cacheFactors", cacheFactors([1, 2, 3, 4, 6]));
console.log("cacheFactors", cacheFactors([1, 2, 3, 4, 6]));
console.log("cacheMultiples", cacheMultiples([10, 5, 2, 20]));
console.log("cacheMultiples", cacheMultiples([10, 5, 2, 20]));


