//
//  TransitionAnimatingDelegate.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

class TransitionAnimatingDelegate: NSObject {
    private var transitionStyle: TransitionAnimatingStyle?
    
    func set(transition: TransitionAnimatingStyle) {
        transitionStyle = transition
    }
}

extension TransitionAnimatingDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionStyle?.animator?.transitioningAnimator(isPresenting: operation == .push)
    }
}

extension TransitionAnimatingDelegate: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionStyle?.animator?.transitioningAnimator(isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionStyle?.animator?.transitioningAnimator(isPresenting: false)
    }
}
