//
//  MovingSelectedViewToNextViewTransitioning.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

class MovingSelectedViewToNextViewTransitioning: NSObject, TransitionAnimator {
    var isPresenting = false
    var duration = 0.4
    let selectedView: UIView
    var initalFrame: CGRect
    
    init(selectedView: UIView, initalFrame: CGRect) {
        self.selectedView = selectedView
        self.initalFrame = initalFrame
    }
    
    func transitioningAnimator(isPresenting: Bool) -> Self? {
        self.isPresenting = isPresenting
        return isPresenting ? self : nil
    }
}

extension MovingSelectedViewToNextViewTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        guard let destinationController = transitionContext.viewController(forKey: .to) as? TransitionDestination,
              destinationController.animationViews.count >= 3 else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let backgroundView = UIView(frame: containerView.bounds)
        containerView.addSubview(toView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedView)
        
        let destinationView = destinationController.animationViews[0]
        let moveUpView = destinationController.animationViews[1]
        let moveToLeftView = destinationController.animationViews[2]
        let destinationViewRect = destinationView.convert(destinationView.bounds, to: destinationController.view)
        let moveUpViewRect = moveUpView.convert(moveUpView.bounds, to: destinationController.view)
        let moveToLeftViewRect = moveToLeftView.convert(moveToLeftView.bounds, to: destinationController.view)
        
        toView.alpha = 0
        destinationView.alpha = 0
        selectedView.frame = initalFrame
        moveUpView.frame = CGRect(x: 0, y: moveUpViewRect.minY, width: moveUpViewRect.width, height: 100)
        moveToLeftView.frame = CGRect(x: containerView.frame.width + 10, y: moveToLeftViewRect.origin.y, width: moveToLeftViewRect.width, height: moveToLeftViewRect.height)
        
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
}
