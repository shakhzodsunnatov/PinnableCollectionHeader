//
//  CustomCells.swift
//  Pinnable Header
//
//  Created by Shakhzod on 25/08/22.
//

import UIKit

class HeaderCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    
    var index: Int = 0 {
        didSet {
            titleLable.text = "\(index)"
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backGroundView.backgroundColor = isSelected ? .orange : .yellow
        }
    }
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var backGroundView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupUI()
        self.contentView.addSubview(backGroundView)
        backGroundView.addSubview(titleLable)
        
        self.backGroundView.backgroundColor = isSelected ? .orange : .yellow
        self.backGroundView.layer.cornerRadius = 16
    
        
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backGroundView.topAnchor.constraint(equalTo:   self.topAnchor),
            backGroundView.leftAnchor.constraint(equalTo:  self.leftAnchor),
            backGroundView.bottomAnchor.constraint(equalTo:self.bottomAnchor),
            backGroundView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
//
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo:   backGroundView.topAnchor),
            titleLable.leftAnchor.constraint(equalTo:  backGroundView.leftAnchor),
            titleLable.bottomAnchor.constraint(equalTo:backGroundView.bottomAnchor),
            titleLable.rightAnchor.constraint(equalTo: backGroundView.rightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
