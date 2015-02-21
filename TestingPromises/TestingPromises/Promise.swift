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

public class Promise<T> {
    
    private var value : T? = nil
    private var fulfilled = false
    private var thenBlock : (T -> Void)? = nil {
        didSet {
            if let block = thenBlock {
                if fulfilled {
                    executeThen(value!)
                }
            }
        }
    }
    
    func then<U>(f : T -> U) -> Promise<U> {
        let promise = Promise<U>()
        
        thenBlock = { value in
            promise.fulfill(f(value))
        }
        
        return promise
    }
    
    func then(f : T -> Void) -> Promise<Void> {
        let promise = Promise<Void>()
        thenBlock = { value in
            promise.fulfill(f(value))
        }
        return promise
    }
    
    func then<U>(f: T -> Promise<U>) -> Promise<U> {
        let promise = Promise<U>()
        
        thenBlock = { value in
            let anotherPromise = f(value)
            anotherPromise.then({
                promise.fulfill($0)
            })
        }
        
        return promise
    }
    
    func fulfill(value : T) {
        if !fulfilled {
            fulfilled = true
            self.value = value
            executeThen(value)
        }
    }
    
    private func executeThen(value : T) {
        if NSThread.isMainThread() {
            thenBlock?(value)
        } else {
            if let block = thenBlock {
                dispatch_async(dispatch_get_main_queue(), {
                    block(value)
                })
            }
        }
    }
}