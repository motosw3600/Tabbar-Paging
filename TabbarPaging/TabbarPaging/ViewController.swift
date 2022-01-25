//
//  ViewController.swift
//  TabbarPaging
//
//  Created by 박상우 on 2022/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let tapBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 30)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 390, height: 600)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let hightlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()

    private let tapName = ["first", "second", "third", "fourth", "fifth"]
    private let pageBackgroundColor: [UIColor] = [.orange, .purple, .yellow, .green, .brown]
    var constraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = pageCollectionView.collectionViewLayout.collectionViewContentSize.height
        guard let layout = pageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: 390, height: height)
    }
    
    private func configureLayout() {
        view.addSubview(tapBarCollectionView)
        view.addSubview(hightlightView)
        view.addSubview(pageCollectionView)
        
        tapBarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tapBarCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tapBarCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tapBarCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tapBarCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        hightlightView.translatesAutoresizingMaskIntoConstraints = false
        constraints = [
            hightlightView.topAnchor.constraint(equalTo: tapBarCollectionView.bottomAnchor),
            hightlightView.bottomAnchor.constraint(equalTo: pageCollectionView.topAnchor),
            hightlightView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            hightlightView.heightAnchor.constraint(equalToConstant: 1),
            hightlightView.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)

        pageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pageCollectionView.topAnchor.constraint(equalTo: hightlightView.bottomAnchor).isActive = true
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureCollectionView() {
        self.tapBarCollectionView.register(UINib(nibName: TabCollectionViewCell.identifier, bundle: nil),
                                               forCellWithReuseIdentifier: TabCollectionViewCell.identifier)
        self.pageCollectionView.register(UINib(nibName: PageCollectionViewCell.identier, bundle: nil),
                                         forCellWithReuseIdentifier: PageCollectionViewCell.identier)
        tapBarCollectionView.delegate = self
        tapBarCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        let firstIndex = IndexPath(item: 0, section: 0)
        
        tapBarCollectionView.selectItem(at: firstIndex, animated: false, scrollPosition: .right)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tapBarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabCollectionViewCell.identifier, for: indexPath) as? TabCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(tapName[indexPath.item])
            
            return cell
        } else if collectionView == pageCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identier, for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell(color: pageBackgroundColor[indexPath.item])

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tapBarCollectionView {
            guard let cell = tapBarCollectionView.cellForItem(at: indexPath) as? TabCollectionViewCell else { return }
            
            NSLayoutConstraint.deactivate(constraints)
            hightlightView.translatesAutoresizingMaskIntoConstraints = false
            constraints = [
                hightlightView.topAnchor.constraint(equalTo: tapBarCollectionView.bottomAnchor),
                hightlightView.bottomAnchor.constraint(equalTo: pageCollectionView.topAnchor),
                hightlightView.heightAnchor.constraint(equalToConstant: 1),
                hightlightView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                hightlightView.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }

            pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension ViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.pageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        if scrollView == pageCollectionView {
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
            let offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)
            let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
            
            targetContentOffset.pointee = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left,
                                                  y: scrollView.contentInset.top)

            // topTapItem Select
            tapBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
            // collectionView didSelectedItemAt delegate
            collectionView(tapBarCollectionView, didSelectItemAt: indexPath)
            // topTapMenu Scroll
            tapBarCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }

}

