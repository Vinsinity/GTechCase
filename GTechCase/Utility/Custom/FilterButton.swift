//
//  FilterButton.swift
//  GTechCase
//
//  Created by Erhan on 17.09.2022.
//

import UIKit

class FilterButton: UIButton {

    var filterType: FilterType?
    
    func setFilterType(filterType: FilterType) {
        self.filterType = filterType
    }
    
    func getFilterType() -> FilterType {
        return self.filterType ?? .movie
    }

}
