//
//  Threading.swift
//  pedalaMI
//
//  Created by Ivano Rotondo on 30/03/16.
//  Copyright © 2016 IvanoRotondo. All rights reserved.
//
//http://ijoshsmith.com/2014/07/05/custom-threading-operator-in-swift/

import Foundation

infix operator ~> {}

/**
 Executes the lefthand closure on a background thread and,
 upon completion, the righthand closure on the main thread.
 Passes the background closure's output, if any, to the main closure.
 */
func ~> <R> (
    backgroundClosure: () -> R,
    mainClosure:       (result: R) -> ())
{
    dispatch_async(queue) {
        let result = backgroundClosure()
        dispatch_async(dispatch_get_main_queue(), {
            mainClosure(result: result)
        })
    }
}

/** Serial dispatch queue used by the ~> operator. */
private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)