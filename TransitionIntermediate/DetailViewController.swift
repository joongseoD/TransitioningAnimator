//
//  DetailViewController.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/22.
//

import UIKit

class DetailViewController: UIViewController, TransitionDestination {
    var animationViews: [UIView] {
        return [thumbnailImageView, tableView]
    }
    
    @IBOutlet weak var thumbnailImageView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var data = (0...100).map { String($0) }
    var thumbnamilImageViewBackgroundColor: UIColor = .red
    
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        thumbnailImageView.backgroundColor = thumbnamilImageViewBackgroundColor
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        thumbnailImageView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tap() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
