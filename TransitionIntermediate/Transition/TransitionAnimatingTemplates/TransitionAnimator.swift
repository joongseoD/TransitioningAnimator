//
//  TransitionAnimator.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/22.
//

import UIKit

protocol TransitionAnimator {
    var duration: TimeInterval { get set }
    var isPresenting: Bool { get set }
    
    func transitioningAnimator(isPresenting: Bool) -> Self?
}

protocol TransitionDestination where Self: UIViewController {
    var animationViews: [UIView] { get }
}
