//
//  ViewController.swift
//  TransitionIntermediate
//
//  Created by DHN0195 on 2021/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var colors: [UIColor] = [.blue, .brown, .cyan, .darkGray, .green, .magenta, .orange, .systemPink, .red].lazy.shuffled()
    private let transitionDelegate = TransitionAnimatingDelegate()
    private var selectedCell: UIView?
    private var selectedCellFrame: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
    }

    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { return }
        let color = colors[indexPath.row]
        detailViewController.thumbnamilImageViewBackgroundColor = color
        
        if let selectedCell = collectionView.cellForItem(at: indexPath),
           let snapshotView = selectedCell.snapshotView(afterScreenUpdates: true) {
            let snapshotFrame = collectionView.superview!.convert(selectedCell.frame, from: collectionView)
            if indexPath.row.isMultiple(of: 2) {
                transitionDelegate.set(transition: .growingView(initalFrame: snapshotFrame))
                detailViewController.transitioningDelegate = transitionDelegate
                detailViewController.modalPresentationStyle = .overCurrentContext
                present(detailViewController, animated: true, completion: nil)
            } else {
                transitionDelegate.set(transition: .movingSelectedViewToNextView(selectedView: snapshotView, selectedViewFrame: snapshotFrame))
                navigationController?.delegate = transitionDelegate
                navigationController?.interactivePopGestureRecognizer?.delegate = nil
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
}

