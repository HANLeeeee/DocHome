//
//  SearchView.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/21.
//

import Foundation

class SearchView: UIView {
    
    lazy var searchView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "COLOR_PURPLE")?.cgColor
        
        return view
    }()
    
    lazy var searchBtn = { () -> UIButton in
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = UIColor(named: "COLOR_PURPLE")
        btn.addTarget(self,
                      action: #selector(didTabSearchBtn(_:)),
                      for: .touchUpInside)
        return btn
    }()
    
    lazy var searchTextField = { () -> UITextField in
        let tf = UITextField()
        tf.placeholder = "병원명을 입력하세요"
        tf.addTarget(self,
                     action: #selector(didChangeSearchTF(_:)),
                     for: .editingChanged)
        return tf
    }()
    
    //MARK: - init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
        configureView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        makeConstraints()
    }
    
    
    //MARK: - func
    func addViews() {
        self.addSubview(searchView)
        searchView.addSubview(searchBtn)
        searchView.addSubview(searchTextField)
    }
    
    func makeConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
        
        searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 50))
        }
    }
    
    //MARK: - configure
    func configureView() {
        self.tabEndEditing()
    }
    
    //MARK: - objc func
    @objc func didChangeSearchTF(_ sender: Any) {
        print("텍스트필드 입력중")
    }
    
    @objc func didTabSearchBtn(_ sender: Any) {
        print("검색 버튼 클릭")
        self.endEditing(true)
    }
}