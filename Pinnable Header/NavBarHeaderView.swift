//
//  NavBarHeaderView.swift
//  Pinnable Header
//
//  Created by Shakhzod on 29/08/22.
//

import UIKit

protocol SelectedItemIndexDelegate: AnyObject {
    func selectedIndex(index: Int)
}


class NavBarHeaderView: UICollectionReusableView {
    
    private let containerView = UIView()
    
    private var model = [Int]()
    
    var headerSectionIndex = 0 {
        didSet {
            let index = IndexPath(item: headerSectionIndex, section: 0)
            self.headerCollectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
            let cell = headerCollectionView.cellForItem(at: index)
//            print("Index: \(headerSectionIndex) \(cell?.isSelected)")
//            self.headerCollectionView.reloadData()
        }
    }
    
    
    lazy var headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame:.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .blue
        
        collection.register(HeaderCollectionCell.self,
                            forCellWithReuseIdentifier: "HeaderCollectionCell")
        
        return collection
    }()
    
    weak var delegate: SelectedItemIndexDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(containerView)
        containerView.addSubview(headerCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updatedSelectedIndex(_ notification: NSNotification) {
        if let index = notification.userInfo?["index"] as? Int {
            headerCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .left)
          }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .green
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo:   self.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo:  self.leftAnchor),
            containerView.bottomAnchor.constraint(equalTo:self.bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerCollectionView.topAnchor.constraint(equalTo:   containerView.safeAreaLayoutGuide.topAnchor),
            headerCollectionView.leftAnchor.constraint(equalTo:  containerView.leftAnchor),
            headerCollectionView.bottomAnchor.constraint(equalTo:containerView.bottomAnchor),
            headerCollectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
    }
}

extension NavBarHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath) as! HeaderCollectionCell
        
        cell.index = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected.toggle()
        
        collectionView.scrollToItem(at: indexPath,
                                         at: .centeredHorizontally,
                                         animated: true)
        delegate?.selectedIndex(index: indexPath.row)
    }
    
    func configureBy(model:[Int]) {
        self.model = model
        headerCollectionView.reloadData()
    }
}
