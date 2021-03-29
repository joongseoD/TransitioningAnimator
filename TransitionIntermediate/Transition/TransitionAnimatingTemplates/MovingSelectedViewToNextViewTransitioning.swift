//
//  MovingSelectedViewToNextViewTransitioning.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

protocol MovingSelectedViewTransitioningDestination: TransitioningDestination {
    var movingView: UIView { get }
    var slidingView: (toLeft: Bool, view: UIView) { get }
    var slideUpView: UIView { get }
}

class MovingSelectedViewToNextViewTransitioning: NSObject, TransitionAnimator {
    var isPresenting = false
    var duration = 0.4
    let selectedView: UIView
    var initalFrame: CGRect
    
    init(selectedView: UIView, initalFrame: CGRect, isPresenting: Bool) {
        self.selectedView = selectedView
        self.initalFrame = initalFrame
        self.isPresenting = isPresenting
    }
}

extension MovingSelectedViewToNextViewTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentAnimation(transitionContext)
        } else {
            dismissAnimation(transitionContext)
        }
    }
    
    private func presentAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        guard let destinationController = transitionContext.viewController(forKey: .to) as? MovingSelectedViewTransitioningDestination else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let backgroundView = UIView(frame: containerView.bounds)
        containerView.addSubview(toView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedView)
        
        let destinationView = destinationController.movingView
        let moveUpView = destinationController.slideUpView
        let moveToLeftView = destinationController.slidingView.view
        let destinationViewRect = destinationView.convert(destinationView.bounds, to: destinationController.view)
        let moveUpViewRect = moveUpView.convert(moveUpView.bounds, to: destinationController.view)
        let moveToLeftViewRect = moveToLeftView.convert(moveToLeftView.bounds, to: destinationController.view)
        
        toView.alpha = 0
        destinationView.alpha = 0
        selectedView.frame = initalFrame
        moveUpView.frame = CGRect(x: 0, y: moveUpViewRect.minY, width: moveUpViewRect.width, height: 100)
        
        if destinationController.slidingView.toLeft {
            moveToLeftView.frame = CGRect(x: containerView.frame.width + 10, y: moveToLeftViewRect.origin.y, width: moveToLeftViewRect.width, height: moveToLeftViewRect.height)
        } else {
            moveToLeftView.frame = CGRect(x: -(moveToLeftViewRect.width + 10), y: moveToLeftViewRect.origin.y, width: moveToLeftViewRect.width, height: moveToLeftViewRect.height)
        }
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.selectedView.frame = destinationViewRect
            moveUpView.frame = moveUpViewRect
            moveToLeftView.frame = moveToLeftViewRect
            toView.alpha = 1
        } completion: { [weak self] in
            destinationView.alpha = 1
            backgroundView.removeFromSuperview()
            self?.selectedView.removeFromSuperview()
            transitionContext.completeTransition($0)
        }
    }
    
    private func dismissAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        guard let destinationViewController = transitionContext.viewController(forKey: .from) as? MovingSelectedViewTransitioningDestination else { return }
        let containerView = transitionContext.containerView
        containerView.addSubview(selectedView)
        let destinationView = destinationViewController.movingView
        
        
        selectedView.frame = destinationView.convert(destinationView.bounds, to: destinationViewController.view)
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.selectedView.frame = self.initalFrame
        } completion: { [weak self] in
            self?.selectedView.removeFromSuperview()
            transitionContext.completeTransition($0)
        }
    }
}
