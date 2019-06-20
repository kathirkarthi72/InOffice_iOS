//
//  GamesViewModel.swift
//  InOfffice
//
//  Created by ktrkathir on 23/08/18.
//  Copyright © 2018 ktrkathir. All rights reserved.
//

import UIKit

class GamesViewModel: NSObject {

}

func rearrange<T>(array: Array<T>, fromIndex: Int, toIndex: Int) -> Array<T> {
    var arr = array
    let element = arr.remove(at: fromIndex)
    arr.insert(element, at: toIndex)
    return arr
}

