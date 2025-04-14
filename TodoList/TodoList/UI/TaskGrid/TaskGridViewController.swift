//
//  TaskGridViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 09.04.2025.
//

import Foundation
import UIKit

class TaskGridViewController: UIViewController {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
    }
}

extension TaskGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1 //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell() // TODO
    }
    
    
}

extension TaskGridViewController: UICollectionViewDelegate {
    
}


#Preview {
    TaskGridViewController()
}
