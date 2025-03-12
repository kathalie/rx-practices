//
//  ViewController.swift
//  FunCatFact
//
//  Created by Kathryn Verkhogliad on 07.03.2025.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private let vm = CatViewModel()
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var funCatFactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.funCatFactLabelState
            .subscribe(
                onNext: { [weak self] in
                    self?.funCatFactLabel.text = $0
                }
            )
            .disposed(by: vm.disposeBag)
        
        vm.canImageState
            .subscribe(
                onNext: { [weak self] in
                    self?.catImageView.image = $0
                }
            )
            .disposed(by: vm.disposeBag)
    }
    
    @IBAction func generateCatStory(_ sender: UIButton) {
        vm.generateCatStory()
    }
}

class CatViewModel {
    let placeholderImage = UIImage(named: "CatImagePlaceholder")!
    
    let funCatFactLabelState = PublishSubject<String>()
    let canImageState = PublishSubject<UIImage>()
    
    var disposeBag = DisposeBag()
    
    func generateCatStory() {
        funCatFactLabelState.onNext("Loading, please wait...")
        canImageState.onNext(placeholderImage)
        
        Single.zip(getFunCatFact(), getCatImage())
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: {[weak self] funCatFact, image in
                    self?.funCatFactLabelState.onNext(funCatFact)
                    self?.canImageState.onNext(image)
                },
                onFailure: { [weak self] error in
                    print(error)
                    
                    self?.funCatFactLabelState.onNext("Error: Something went wrong")
                    self?.canImageState.onNext(self?.placeholderImage ?? UIImage())
                }
            )
            .disposed(by: disposeBag)
    }
}
