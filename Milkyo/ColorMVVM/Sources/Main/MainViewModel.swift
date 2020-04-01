//
//  ViewModel.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/04/01.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias ColorCellSection = SectionModel<Void, ColorCellViewModelType>

protocol MainViewModelInput {
    func favoriteButtonPressed()
    func fetchData()
}

protocol MainViewModelOutput {
    var color: Driver<[ColorCellSection]> { get }
    var isLoading: Driver<Bool> { get }
    var isFavorite: Driver<Bool> { get }
}

protocol MainViewModelType {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

class MainViewModel: MainViewModelType, MainViewModelInput, MainViewModelOutput {
    
    var input: MainViewModelInput { return self }
    var output: MainViewModelOutput { return self }
    
    let networkSevice: NetworkService
    let disposeBag = DisposeBag()
    
    lazy var isLoading: Driver<Bool> = _isLoading.asDriver()
    lazy var color: Driver<[ColorCellSection]> = _color.asDriver()
    lazy var isFavorite: Driver<Bool> = _isFavorite.asDriver()
    
    //State
    private var _color: BehaviorRelay<[ColorCellSection]> = .init(value: [])
    private var _isLoading: BehaviorRelay<Bool> = .init(value: false)
    private var _isFavorite: BehaviorRelay<Bool> = .init(value: false)
    
    init(_ networkSevice: NetworkService = NetworkService()) {
        self.networkSevice = networkSevice
    }
    
    func favoriteButtonPressed() {
        self._isFavorite.accept(!self._isFavorite.value)
    }
    
    func fetchData() {
        self._isLoading.accept(true)
        
        networkSevice.fetchColors()
            .map { $0.map { ColorCellViewModel($0)}}
            .map { ([ColorCellSection(model: Void(), items: $0)]) }
            .asObservable()
            .do(onCompleted: { [weak self] in self?._isLoading.accept(false) })
            .bind(to: self._color)
            .disposed(by: disposeBag)
    }
    
}

