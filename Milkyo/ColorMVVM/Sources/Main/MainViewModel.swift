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
import RxViewBinder

typealias ColorCellSection = SectionModel<Void, ColorCellViewModelType>

class MainViewBindable: ViewBindable {
    
    enum Command {
        case fetch
        case pressed
    }
    
    struct Action {
        var _color: BehaviorRelay<[ColorCellSection]> = .init(value: [])
        var _isLoading: BehaviorRelay<Bool> = .init(value: false)
        var _isFavorite: BehaviorRelay<Bool> = .init(value: false)
        let _error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    }
    
    struct State {
        var isLoading: Driver<Bool>
        var color: Driver<[ColorCellSection]>
        var isFavorite: Driver<Bool>
        var error: Driver<String?>
        
        init(action: Action) {
            isLoading = action._isLoading.asDriver()
            color = action._color.asDriver()
            isFavorite = action._isFavorite.asDriver()
            error = action._error.asDriver()
        }
    }
    
    let action: Action
    lazy var state = State(action: self.action)
    let networkSevice: NetworkService
    
    func binding(command: Command) {
        switch command {
        case .fetch:
            self.action._isLoading.accept(true)
            var colors =  networkSevice.fetchColors()
            if self.action._isFavorite.value {
                colors = colors.map { $0.filter { $0.isFavorite }}
            }
            
            colors
                .asObservable()
                .catchError({ error in
                    self.action._error.accept(error.localizedDescription)
                    return .empty()
                })
                .map { $0.map { ColorCellViewModel($0)}}
                .map { ([ColorCellSection(model: Void(), items: $0)]) }
                .do(onCompleted: { [weak self] in self?.action._isLoading.accept(false) })
                .bind(to: self.action._color)
                .disposed(by: disposeBag)
        case .pressed:
            self.action._isFavorite.accept(!self.action._isFavorite.value)
        }
    }
    
    
    init(_ networkSevice: NetworkService = NetworkService()) {
        
        self.networkSevice = networkSevice
        self.action = Action()
        
        self.action._isFavorite.withLatestFrom(self.action._color)
            .do(onNext: { _ in self.binding(command: .fetch) })
            .bind(to: self.action._color)
            .disposed(by: self.disposeBag)
        
    }
    
    
}
