//
//  Yo_RecommendViewController.swift
//  DouYuAPP
//
//  Created by shying li on 2017/3/28.
//  Copyright © 2017年 李世洋. All rights reserved.
//

import UIKit

class Yo_RecommendViewController: GenericViewController<Yo_RecommendContentView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.setupUI()
        
        collectionViewModel.registerCell {[weak self] () -> (listView: UICollectionView, cell: [String : UICollectionViewCell.Type]) in
            return ((self?.contentView.collectionView)!, [normalCellID: Yo_RecommendNormalCell.self, prettyCellID: Yo_RecommendPrettyCell.self])
        }
        
        collectionViewModel.registerReusableView(Kind: UICollectionElementKindSectionHeader) {[weak self] () -> (listView: UICollectionView, view: [String : UIView.Type]) in
            return ((self?.contentView.collectionView)!, [sectionHeaderID: Yo_HomeSectionHeaderView.self])
        }
        
        gameViewModel.registerCell {[weak self] () -> (listView: UICollectionView, cell: [String : UICollectionViewCell.Type]) in
            return ((self?.contentView.gameView)!, [HomeGameViewCell: Yo_HomeGameViewCell.self])
        }
        
        loadData()
    }
    
    fileprivate lazy var recommendViewModel: Yo_RecommendViewModel = {
        return Yo_RecommendViewModel()
    }()
    
    fileprivate lazy var collectionViewModel: Yo_RecommendCollectionViewModel = {[weak self] in
        let viewModel = Yo_RecommendCollectionViewModel(sourceView: (self?.contentView.collectionView)!)
        viewModel.delegate = self
        return viewModel
        }()
    
    fileprivate lazy var cycleViewModel: Yo_HomeCycleViewModel = {[weak self] in
        let cycleViewModel = Yo_HomeCycleViewModel(CycleView: (self?.contentView.cycleView)!)
        return cycleViewModel
        }()
    
    fileprivate lazy var gameViewModel: Yo_RecommendGameCollectionViewModel = {[weak self] in
        return Yo_RecommendGameCollectionViewModel(sourceView: (self?.contentView.gameView)!)
        }()
}

extension Yo_RecommendViewController {
    fileprivate func loadData() {
        recommendViewModel.loadRecommendData {[weak self] (dataArray, gameArray) in
            self?.collectionViewModel.set(DataSource: { () -> [Yo_AnchorBaseGroup] in
                return dataArray
            }, completion: {
                self?.contentView.collectionView.reloadData()
            })
            
            self?.gameViewModel.set(DataSource: { () -> [Yo_AnchorBaseGroup] in
                return gameArray
            }, completion: {
                self?.contentView.gameView.reloadData()
            })
        }
        
        recommendViewModel.loadCycleData {[weak self] (dataArray) in
            self?.cycleViewModel.setCycleDataSoure({ () -> [Yo_HomeCycleModel]? in
                return dataArray
            }, completion: {
                self?.contentView.cycleView.reloadData()
            })
        }
    }
}

extension Yo_RecommendViewController: Yo_RecommendCollectionViewModelDeleagte {
    func presentShowRoom() {
        let showRoomVc = Yo_RoomShowViewController()
        present(showRoomVc, animated: true, completion: nil)
    }
    
    func pushNormalRoom() {
        let normalRoomVc = Yo_RoomNormalViewController()
        navigationController?.pushViewController(normalRoomVc, animated: true)
    }
}
