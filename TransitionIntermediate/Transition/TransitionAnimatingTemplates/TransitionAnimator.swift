//
//  TransitionAnimator.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/22.
//

import UIKit

protocol TransitioningDestination where Self: UIViewController {}

protocol TransitionAnimator {
    var duration: TimeInterval { get set }
    var isPresenting: Bool { get set } 
}
