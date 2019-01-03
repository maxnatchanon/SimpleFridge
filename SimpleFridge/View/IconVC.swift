//
//  IconVC.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 28/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IconVC: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    var delegate: DataPassable?
    private var icons: [String] = []
    private var selectedIcon: String?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconCollectionView.delegate = self
        createIconList()
        bindCollectionView()
    }
    
    /// Pass selected icon to AddVC/ItemVC
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.pass(data: selectedIcon!)
    }
    
    private func createIconList() {
        for number in 1...44 {
            var iconName = "icon"
            iconName += (number < 10) ? "0" : ""
            iconName += String(number)
            icons.append(iconName)
        }
    }
    
    private func bindCollectionView() {
        Observable.just(icons).bind(to: iconCollectionView.rx
            .items(cellIdentifier: IconCell.identifier, cellType: IconCell.self)) {
                (index, icon, cell) in
                cell.iconImage.image = UIImage.init(named: icon)
            }.disposed(by: disposeBag)
        
        iconCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self!.selectedIcon = self!.icons[indexPath.row]
                self!.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let viewWidth = collectionView.frame.size.width
        let rowItemCount = 4
        let cellWidth = flowLayout.itemSize.width
        let contentWidth = cellWidth * CGFloat(rowItemCount)
        let space = (viewWidth - contentWidth) / 5
        
        flowLayout.minimumInteritemSpacing = space
        let insets = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        
        return insets
    }
    
}
