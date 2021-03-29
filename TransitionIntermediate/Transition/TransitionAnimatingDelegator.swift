//
//  TransitionAnimatingDelegate.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

class TransitionAnimatingDelegator: NSObject {
    var transitionStyle: TransitionAnimatingStyle?
    var isSupportCloseAnimating: Bool = true
}

extension TransitionAnimatingDelegator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let isPresenting = operation == .push
        let destination = isPresenting ? toVC : fromVC
        if isPresenting {
            return transitionStyle?.getAnimator(for: destination, isPresenting: true)
        } else {
            return isSupportCloseAnimating ? transitionStyle?.getAnimator(for: destination, isPresenting: false) : nil
        }
    }
}

extension TransitionAnimatingDelegator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionStyle?.getAnimator(for: presented, isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return isSupportCloseAnimating ? transitionStyle?.getAnimator(for: dismissed, isPresenting: false) : nil
    }
}
