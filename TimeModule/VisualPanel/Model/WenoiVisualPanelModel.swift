//
//  WenoiVisualPanelModel.swift
//  WenoiUI
//
//  Created by Roushil Singla on 08/09/21.
//  Copyright © 2021 Arpana. All rights reserved.
//

import Foundation

public struct WenoiVisualPanelModel: Equatable {
    
    public static func == (lhs: WenoiVisualPanelModel, rhs: WenoiVisualPanelModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id: String?
    public var name: String?
    public var image: String?
    public var isSelected: Bool?
    
    
    public init() { }
    
    public init(id: String?, name: String?, image: String?, isSelected: Bool?) {
        self.id = id
        self.name = name
        self.image = image
        self.isSelected = isSelected
    }
    
}
