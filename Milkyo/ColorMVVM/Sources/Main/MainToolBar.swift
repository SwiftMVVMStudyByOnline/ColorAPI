//
//  MainToolBar.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/03/28.
//

import UIKit

class MainToolBar: UIView {
    
    weak var favoriteButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorLists.gray5
        
        let favoriteButton = UIButton()
        favoriteButton.tintColor = ColorLists.label
        if #available(iOS 13.0, *) {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        } else {
            favoriteButton.setTitle("HEART", for: .normal)
        }
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
        self.favoriteButton = favoriteButton
        
        let refreshButton = UIButton()
        refreshButton.tintColor = ColorLists.label
        if #available(iOS 13.0, *) {
            refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        } else {
            favoriteButton.setTitle("REFRESH", for: .normal)
        }
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(refreshButton)
        NSLayoutConstraint.activate([
            refreshButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            refreshButton.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
