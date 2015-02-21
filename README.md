# Swift Promises
A simple and small implementation of [promises](http://en.wikipedia.org/wiki/Futures_and_promises) in Swift. This code exists just to serve as an example and personal exercise.

The objective was to write:

`doAsyncTask().then(doAnotherAsyncTask).then(checkResult)`

or

`when([doAsyncTask(), doAnotherAsyncTask()]).then(checkResult)`

Where `doAsyncTask()` returns a promise, `doAnotherAyncTask()` also returns a promise and `checkResult()` doesn't return anything. The `then` function should be executed immediately if the promise is already fulfilled.

Check `main.swift` for usage.