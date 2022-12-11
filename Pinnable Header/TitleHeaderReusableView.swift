//
//  TitleHeaderReusableView.swift
//  Pinnable Header
//
//  Created by Shakhzod on 29/08/22.
//

import UIKit

class TitleHeaderCell: UICollectionViewCell {
    
    let containerView = UIView()
    
    var orderIndex: Int = 0 {
        didSet {
            self.titleLable.text = "Section \(orderIndex)"
        }
    }
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 32)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(containerView)
        containerView.addSubview(titleLable)
        
        self.backgroundColor = .green
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo:   self.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo:  self.leftAnchor),
            containerView.bottomAnchor.constraint(equalTo:self.bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
//
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo:   containerView.safeAreaLayoutGuide.topAnchor),
            titleLable.leftAnchor.constraint(equalTo:  containerView.leftAnchor),
            titleLable.bottomAnchor.constraint(equalTo:containerView.bottomAnchor),
            titleLable.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
