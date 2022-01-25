//
//  ViewController.swift
//  TabbarPaging
//
//  Created by 박상우 on 2022/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let topTapMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 30)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 390, height: 600)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let cellHightlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    private let tapName = ["first", "second", "third", "fourth", "fifth"]
    private let menuBackgroundColor: [UIColor] = [.orange, .purple, .yellow, .green, .brown]
    var constraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = menuCollectionView.collectionViewLayout.collectionViewContentSize.height
        guard let layout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: 390, height: height)
    }
    
    private func configureLayout() {
        view.addSubview(topTapMenuCollectionView)
        view.addSubview(cellHightlightView)
        view.addSubview(menuCollectionView)
        
        topTapMenuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topTapMenuCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        topTapMenuCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topTapMenuCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topTapMenuCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cellHightlightView.translatesAutoresizingMaskIntoConstraints = false
        constraints = [
            cellHightlightView.topAnchor.constraint(equalTo: topTapMenuCollectionView.bottomAnchor),
            cellHightlightView.bottomAnchor.constraint(equalTo: menuCollectionView.topAnchor),
            cellHightlightView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            cellHightlightView.heightAnchor.constraint(equalToConstant: 1),
            cellHightlightView.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)

        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionView.topAnchor.constraint(equalTo: cellHightlightView.bottomAnchor).isActive = true
        menuCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        menuCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        menuCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureCollectionView() {
        self.topTapMenuCollectionView.register(UINib(nibName: TabCollectionViewCell.identifier, bundle: nil),
                                               forCellWithReuseIdentifier: TabCollectionViewCell.identifier)
        self.menuCollectionView.register(UINib(nibName: MenuCollectionViewCell.identier, bundle: nil),
                                         forCellWithReuseIdentifier: MenuCollectionViewCell.identier)
        topTapMenuCollectionView.delegate = self
        topTapMenuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        let firstIndex = IndexPath(item: 0, section: 0)
        
        topTapMenuCollectionView.selectItem(at: firstIndex, animated: false, scrollPosition: .right)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topTapMenuCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.identifier, for: indexPath) as? TabCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(tapName[indexPath.item])
            
            return cell
        } else if collectionView == menuCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identier, for: indexPath) as? MenuCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(color: menuBackgroundColor[indexPath.item])

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topTapMenuCollectionView {
            guard let cell = topTapMenuCollectionView.cellForItem(at: indexPath) as? TabCollectionViewCell else { return }
            
            NSLayoutConstraint.deactivate(constraints)
            cellHightlightView.translatesAutoresizingMaskIntoConstraints = false
            constraints = [
                cellHightlightView.topAnchor.constraint(equalTo: topTapMenuCollectionView.bottomAnchor),
                cellHightlightView.bottomAnchor.constraint(equalTo: menuCollectionView.topAnchor),
                cellHightlightView.heightAnchor.constraint(equalToConstant: 1),
                cellHightlightView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                cellHightlightView.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }

            menuCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension ViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if scrollView == menuCollectionView {
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            let offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)
            let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
            
            targetContentOffset.pointee = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
                                                  y: scrollView.contentInset.top)

            // topTapItem Select
            topTapMenuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            // collectionView didSelectedItemAt delegate
            collectionView(topTapMenuCollectionView, didSelectItemAt: indexPath)
            // topTapMenu Scroll
            topTapMenuCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }

}

