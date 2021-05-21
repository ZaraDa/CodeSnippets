//
//  Router.swift
//  Veedup
//
//  Created by Zaruhi Davtyan on 07/10/20.
//  Copyright © 2020 VarmTech. All rights reserved.
//

import UIKit

protocol Routable {
    associatedtype SegueType
    associatedtype SourceType
    func perform(_ segue: SegueType, from source: SourceType)
}
