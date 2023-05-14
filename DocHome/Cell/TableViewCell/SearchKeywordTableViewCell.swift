//
//  SearchKeywordTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import UIKit
import SnapKit

class SearchKeywordTableViewCell: UITableViewCell {
    
    lazy var resultView = { ()-> UIView in
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
        
        return view
    }()
    
    lazy var hospitalNameLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.text = "가을로 가슴속에 하나에 불러 내린 릴케 언덕 멀리 까닭입니다. 이름을 다하지 이런 오면 언덕 듯합니다. 동경과 잔디가 때 가을 추억과 있습니다. 마리아 릴케 별에도 언덕 부끄러운 헤는 거외다. 못 위에도 오면 까닭입니다."
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var hospitalLocationLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "어머니 프랑시스 북간도에 한 위에 나는 지나가는 이국 듯합니다. 이름과 하나에 어머님, 거외다. 너무나 불러 쉬이 봄이 다하지 까닭입니다. 하나 아이들의 않은 시와 둘 듯합니다. 까닭이요, 사랑과 아침이 까닭이요, 아이들의 하나의 라이너 까닭입니다. 흙으로 많은 아침이 슬퍼하는 하나에 밤이 하나의 덮어 옥 까닭입니다."
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    //MARK: - init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - UI 관련
    func addSubViews() {
        self.contentView.addSubview(resultView)
        resultView.addSubview(hospitalNameLabel)
        resultView.addSubview(hospitalLocationLabel)
    }
    
    func makeConstraints() {
        resultView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 15, right: 20))
        }
        
        hospitalNameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        hospitalLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.bottom.trailing.equalTo(-15)
        }
    }
    
    func configureCell(searchResult: Document) {
        hospitalNameLabel.text = searchResult.placeName
        hospitalLocationLabel.text = searchResult.roadAddressName
    }
}
