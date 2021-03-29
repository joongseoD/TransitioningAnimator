//
//  ViewController.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let transitionDelegator = TransitionAnimatingDelegator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
    }
    
    private lazy var present: ((_ transitionStyle: TransitionAnimatingStyle, _ color: UIColor) -> Void) = {
        return { [weak self] style, color in
            guard let self = self else { return }
            guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
            detailViewController.thumbnamilImageViewBackgroundColor = color
            self.transitionDelegator.transitionStyle = style
            detailViewController.transitioningDelegate = self.transitionDelegator
            detailViewController.modalPresentationStyle = .overCurrentContext
            
            self.present(detailViewController, animated: true, completion: nil)
        }
    }()

    private func setupUI() {
        navigationController?.delegate = transitionDelegator
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
     
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TransitionAnimatingStyle.allCases[section].description
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TransitionAnimatingStyle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TransitionStyleTableViewCell else { return UITableViewCell() }
        cell.configure(transitionStyle: TransitionAnimatingStyle.allCases[indexPath.section], selectedItem: present)
        return cell
    }
}

//MARK: - TableViewCell
class TransitionStyleTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var colors: [UIColor] = [.blue, .brown, .cyan, .darkGray, .green, .magenta, .orange, .systemPink, .red].lazy.shuffled()
    private var transitionStyle: TransitionAnimatingStyle?
    private var selectedItem: ((TransitionAnimatingStyle, UIColor) -> Void)?
    
    func configure(transitionStyle: TransitionAnimatingStyle, selectedItem: ((TransitionAnimatingStyle, UIColor) -> Void)?) {
        self.transitionStyle = transitionStyle
        self.selectedItem = selectedItem
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension TransitionStyleTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath),
           let snapshotView = selectedCell.snapshotView(afterScreenUpdates: true) {
            var snapshotFrame = collectionView.superview!.convert(selectedCell.frame, from: collectionView)
            let collectionCellFrame = superview!.convert(selectedCell.frame, from: self)
            snapshotFrame.origin.y = collectionCellFrame.origin.y + 70
            let selectedColor = colors[indexPath.row]
            switch transitionStyle {
            case .movingSelectedViewToNextView(selectedView: _, selectedViewFrame: _):
                selectedItem?(.movingSelectedViewToNextView(selectedView: snapshotView, selectedViewFrame: snapshotFrame), selectedColor)
            case .growingView(initalFrame: _):
                selectedItem?(.growingView(initalFrame: snapshotFrame), selectedColor)
            case .spinSelectedView(_, frame: _):
                selectedItem?(.spinSelectedView(snapshotView, frame: snapshotFrame), selectedColor)
            default: break
            }
        }
    }
}

extension TransitionStyleTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}

extension TransitionStyleTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}

