//
//  ViewController.swift
//  Pinnable Header
//
//  Created by Shakhzod on 25/08/22.
//

import UIKit

class ViewController: UIViewController {
    // 999 -> is Header
    private let mockModel = MockDate.model
    private var allDate = [[Int]]() //prodtype
    
    private var itemsData: [Int] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var headersIndex = [Int]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        
        let collection = UICollectionView(frame:.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .red
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.main.bounds.height, right: 0)
        
        collection.register(HeaderCollectionCell.self,
                            forCellWithReuseIdentifier: "HeaderCollectionCell")
        collection.register(TitleHeaderCell.self,
                            forCellWithReuseIdentifier: "TitleHeaderCell")
        collection.register(NavBarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(NavBarHeaderView.self)")
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupInitialView()
        navigationController?.navigationBar.isHidden = true
        sortingData()
        
    }
    
    private func setupInitialView() {
        view.addSubview(collectionView)
        collectionView.frame = view.frame
    }
    
    private func sortingData() {
        
        var sortedData = [[Int]]()
        sortedData.insert([999], at: 0)
        
        allDate = mockModel.map({ model in
            guard let prod = model.prods else { return [] }
            sortedData.append(prod)
            if mockModel.last != model {
                sortedData.append([999])
            }
            return []
        })
        
        itemsData = sortedData.flatMap({$0})
        
        
        
//        headersIndex = flatData.enumerated().compactMap({ index, model in
//            if model == 999 {
//                return index
//            } else {
//                return nil
//            }
//        }) -> Long Variant
        headersIndex = itemsData.enumerated().compactMap({ $1 == 999 ? $0 : nil})
        
        
        print(sortedData)
        print(itemsData)
        print(headersIndex)
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SelectedItemIndexDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return itemsData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        if section == 0 {
            return CGSize(width: (self.view.frame.width/2) , height: 300)
        } else {
            if itemsData[indexPath.row] == 999 {
                return CGSize(width: (self.view.frame.width) - 40, height: 100)
            } else {
                return CGSize(width: (self.view.frame.width/2) - 60, height: (self.view.frame.width/2))
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: self.view.frame.width, height: 100)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "\(NavBarHeaderView.self)",
                for: indexPath) as! NavBarHeaderView
            
            headerView.configureBy(model: headersIndex)
            headerView.delegate = self
            
            return headerView
            
        default:
            assert(false, "Invalid element type")
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let sectionCells: Set<Int> = Set(collectionView.visibleCells.compactMap({ itemsData[collectionView.indexPath(for: $0)?.row ?? 0] == 999 ? collectionView.indexPath(for: $0)?.row : nil })) // Set -> igoning first section item which also has 0 index
        
        print("T cells: \(sectionCells)")
        
        for indexPath in sectionCells {
            let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) as? NavBarHeaderView
            header?.headerSectionIndex = headersIndex.firstIndex(of: indexPath) ?? 0
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.section != 0 {
            if itemsData[indexPath.row] == 999 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleHeaderCell", for: indexPath) as! TitleHeaderCell
                
                cell.orderIndex = headersIndex.firstIndex(of: indexPath.row) ?? 0
                
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath) as! HeaderCollectionCell
            
            cell.index = itemsData[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath) as! HeaderCollectionCell
            
            cell.index = 0
            
            return cell
        }
    }
    
    func selectedIndex(index: Int) {
        //        self.collectionView.scrollToItem(at:IndexPath(item: headersIndex[index], section: 1), at: .top, animated: true)
        guard let layout = collectionView.collectionViewLayout.layoutAttributesForItem(at: IndexPath(item: headersIndex[index], section: 1)) else {
            collectionView.scrollToItem(at: IndexPath(item: headersIndex[index], section: 1), at: .top, animated: true)
            return
        }
        let offset = CGPoint(x: 0, y: layout.frame.minY - 100) // 100 header size
        collectionView.setContentOffset(offset, animated: true)
        
        print("Move to: \(index)")
    }
    
}


typealias SectionModels = [SectionModel]

struct SectionModel: Equatable {
    var prods: [Int]?
    var name: String?
}

class MockDate {
    private init() {}
    
    static let model: SectionModels = [
        SectionModel(prods: Array(repeating: 1, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 2, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 3, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 4, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 5, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 6, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 7, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 8, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 9, count:  8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 10, count: 8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 11, count: 8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 12, count: 8), name: "Malochniy"),
        SectionModel(prods: Array(repeating: 13, count: 8), name: "Malochniy")
    ]
}
