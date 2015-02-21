//The MIT License (MIT)
//
//Copyright (c) 2015 Fábio Bernardo
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation

let queue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT)

func getFirstWord() -> Promise<String> {
    let promise = Promise<String>()
    
    println("fetching first word")
    
    dispatch_async(queue, {
        sleep(1)
        promise.fulfill("Hello")
    })
    
    return promise
}

func getSecondWord(previousString : String) -> Promise<String> {
    let promise = Promise<String>()
    
    println("fetching second word")
    
    dispatch_async(queue, {
        sleep(1)
        promise.fulfill(previousString + " Promises")
    })
    
    return promise
}

func getThirdWord(previousString : String) -> Promise<String> {
    let promise = Promise<String>()
    
    println("fetching third word")
    
    dispatch_async(queue, {
        sleep(1)
        promise.fulfill(previousString + " World")
    })
    
    return promise
}

func getFirstNumber() -> Promise<Int> {
    let promise = Promise<Int>()
    
    println("fetching first number")
    
    dispatch_async(queue, {
        sleep(1)
        promise.fulfill(1)
    })
    
    return promise
}

func getSecondNumber() -> Promise<Int> {
    let promise = Promise<Int>()
    
    println("fetching second number")
    
    dispatch_async(queue, {
        sleep(1)
        promise.fulfill(1)
    })
    
    return promise
}

func getNextNumber(previousNumbers : [Int]) -> Promise<Int> {
    let promise = Promise<Int>()
    
    println("fetching next number")
    
    dispatch_async(queue, {
        sleep(1)
        promise.fulfill(previousNumbers.reduce(0, combine: +))
    })
    
    return promise
}

func when<T>(promises : [Promise<T>]) -> Promise<[T]> {
    let promise = Promise<[T]>()
    var results : [T] = []
    
    let count = promises.count
    
    for aPromise in promises {
        aPromise.then( {
            results.append($0)
            if results.count == count {
                promise.fulfill(results)
            }
            })
    }
    
    return promise
}


func main() {
    //Main function, program entry point
    
    let wordsPromise = getFirstWord().then(getSecondWord).then(getThirdWord).then(println)
    
    let numbersPromise = when([getFirstNumber(),getSecondNumber()]).then(getNextNumber).then( { println("number is \($0)") } )
    
    let composedPromise = when([wordsPromise,numbersPromise]).then( { _ in println("both finished") } )
    
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 5))
    
    wordsPromise.then({println("this should execute now!")}).then({println("and now!")})
    
    println("end.")
}

main()

