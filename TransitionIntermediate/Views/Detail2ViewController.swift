//
//  Detail2ViewController.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/25.
//

import UIKit

class Detail2ViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    var headerViewBackgroundColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.backgroundColor = headerViewBackgroundColor
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        headerView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tap() {
        dismiss(animated: true, completion: nil)
    }
}

extension Detail2ViewController: MovingSelectedViewTransitioningDestination {
    var movingView: UIView {
        return headerView
    }
    
    var slidingView: (toLeft: Bool, view: UIView) {
        return (false, titleLabel)
    }
    
    var slideUpView: UIView {
        return subtitleLabel
    }
}

extension Detail2ViewController: SpinSelectedViewAnimationTransitioningDestination {
    var spinningView: UIView {
        return headerView
    }
}
