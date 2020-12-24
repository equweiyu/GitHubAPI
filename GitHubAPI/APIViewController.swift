//
//  APIListViewController.swift
//  GitHubAPI
//
//  Created by 白天伟 on 2020/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class APIViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var resultModel: (String,Data)?
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        if let resultModel = resultModel {
            let result = try? JSONSerialization.jsonObject(with: resultModel.1, options: .allowFragments) as? [String:String]
            self.textView.text = result?.description
            self.title = resultModel.0
            return
        }
        
        let loadData = URLSession.shared
            .rx
            .response(request: URLRequest(url: URL(string: "https://api.github.com/")!))
            .retry(3)
            .observe(on: MainScheduler.instance)
            .map { (response,data) -> String? in
                if let date = response.value(forHTTPHeaderField: "Date") {
                    HistoryManage.shared.add(date: date, data: data)
                }
                
                let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:String]
                return result?.description
            }
        
        Observable<Int>.interval(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
            .flatMapLatest({ (_)  in
                loadData
            })
            .bind(to: self.textView.rx.text).disposed(by: disposeBag)
    }
}

