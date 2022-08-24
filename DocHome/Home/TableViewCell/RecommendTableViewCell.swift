//
//  RecommendTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/15.
//

import UIKit
import SnapKit

class RecommendTableViewCell: UITableViewCell {

    lazy var cellView = { () -> UIView in
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
        label.text = "가을로 가슴속에 하나에 불러 내린 릴케 언덕 멀리 까닭입니다. 이름을 다하지 이런 오면 언덕 듯합니다. 동경과 잔디가 때 가을 추억과 있습니다. 마리아 릴케 별에도 언덕 부끄러운 헤는 거외다. 못 위에도 오면 까닭입니다."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    lazy var hospitalLocationLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "가을로 가슴속에 하나에 불러 내린 릴케 언덕 멀리 까닭입니다. 이름을 다하지 이런 오면 언덕 듯합니다. 동경과 잔디가 때 가을 추억과 있습니다. 마리아 릴케 별에도 언덕 부끄러운 헤는 거외다. 못 위에도 오면 까닭입니다."
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        
        return label
    }()
    
    lazy var hospitalPhoneLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "010-1234-1234"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        
        return label
    }()
    
    lazy var hospitalDistanceLabel = { () -> UILabel in
        let label = UILabel()
        label.text = "나누리병원"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(named: "COLOR_PURPLE")
        
        return label
    }()
    
    //MARK: - init()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        addLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 라이프사이클
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - UI 관련
    func addViews() {
        self.addSubview(cellView)
        cellView.addSubview(hospitalNameLabel)
        cellView.addSubview(hospitalLocationLabel)
        cellView.addSubview(hospitalPhoneLabel)
        cellView.addSubview(hospitalDistanceLabel)
    }
    
    func addLayoutConstraints() {
        cellView.snp.makeConstraints { make in
            make.edges.equalTo(0).inset(UIEdgeInsets(top: 0, left: 15, bottom: 5, right: 15))
            make.height.equalTo(120)
        }
        
        hospitalNameLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        hospitalLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalNameLabel.snp.bottom).offset(10)
            make.left.equalTo(hospitalNameLabel.snp.left)
            make.right.equalTo(hospitalNameLabel.snp.right)
        }
        
        hospitalPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalLocationLabel.snp.bottom).offset(10)
            make.left.equalTo(hospitalLocationLabel.snp.left)
        }
        
        hospitalDistanceLabel.snp.makeConstraints { make in
            make.top.equalTo(hospitalPhoneLabel.snp.top)
            make.left.equalTo(hospitalPhoneLabel.snp.right).offset(10)
            make.right.equalTo(hospitalNameLabel.snp.right).offset(-5)
        }
    }
    
    func configureCell(searchResult: Document) {
        hospitalNameLabel.text = searchResult.placeName
        hospitalLocationLabel.text = searchResult.roadAddressName
        hospitalPhoneLabel.text = searchResult.phone
        hospitalDistanceLabel.text = "\(searchResult.distance) m"
    }
}
