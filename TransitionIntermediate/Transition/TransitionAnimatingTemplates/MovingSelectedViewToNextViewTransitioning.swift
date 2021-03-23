//
//  MovingSelectedViewToNextViewTransitioning.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/23.
//

import UIKit

class MovingSelectedViewToNextViewTransitioning: NSObject, TransitionAnimator {
    var isPresenting = false
    var duration = 0.3
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
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        containerView.addSubview(toView)
        toView.alpha = 0
        let whiteView = UIView(frame: containerView.bounds)
        whiteView.backgroundColor = .clear
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.addSubview(whiteView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedView)
        
        guard let secondViewController = transitionContext.viewController(forKey: .to) as? DetailViewController else { return }
        let imageViewRect = secondViewController.thumbnailImageView.convert(secondViewController.thumbnailImageView.bounds, to: secondViewController.view)
        let tableViewRect = secondViewController.tableView.convert(secondViewController.tableView.bounds, to: secondViewController.view)
        secondViewController.tableView.frame = CGRect(x: 0, y: 1000, width: secondViewController.view.frame.width, height: secondViewController.view.frame.height)
        selectedView.frame = initalFrame
        
        UIView.animate(withDuration: duration) { [weak self] in
            guard let self = self else { return }
            self.selectedView.frame = imageViewRect
            secondViewController.tableView.frame = tableViewRect
            toView.alpha = 1
        } completion: { [weak self] in
            backgroundView.removeFromSuperview()
            self?.selectedView.removeFromSuperview()
            transitionContext.completeTransition($0)
        }
    }
}
