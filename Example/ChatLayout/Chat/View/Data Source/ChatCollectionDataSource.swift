//
// ChatLayout
// ChatCollectionDataSource.swift
// https://github.com/ekazaev/ChatLayout
//
// Created by Eugene Kazaev in 2020-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import ChatLayout
import Foundation
import RecyclerView
import UIKit

protocol ChatCollectionDataSource: UICollectionViewDataSource, ChatLayoutDelegate, RecyclerViewDataSource<VoidPayload>, ContinuousLayoutEngineDelegate {

    var sections: [Section] { get set }

    func prepare(with collectionView: UICollectionView)

}
