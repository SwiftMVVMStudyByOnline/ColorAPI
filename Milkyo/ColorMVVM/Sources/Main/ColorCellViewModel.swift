//
//  ColorCellViewModel.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/04/01.
//

import Foundation

protocol ColorCellViewModelOutput {
    var color: Color { get }
}

protocol ColorCellViewModelType {
    var output: ColorCellViewModelOutput { get }
}

class ColorCellViewModel: ColorCellViewModelType, ColorCellViewModelOutput {
    var output: ColorCellViewModelOutput { self }
    var color: Color
    
    init(_ color: Color) {
        self.color = color
    }
}
