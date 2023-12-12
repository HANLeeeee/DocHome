//
//  SearchKeywordTableViewCell.swift
//  DocHome
//
//  Created by 최하늘 on 2022/08/25.
//

import UIKit
import SnapKit

final class SearchKeywordTableViewCell: UITableViewCell {
    
    private let resultView = { ()-> UIView in
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
        return view
    }()
    
    private let hospitalNameLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let hospitalLocationLabel = { () -> UILabel in
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hospitalNameLabel.text = ""
        hospitalLocationLabel.text = ""
    }
    
    private func addSubViews() {
        self.contentView.addSubview(resultView)
        resultView.addSubview(hospitalNameLabel)
        resultView.addSubview(hospitalLocationLabel)
    }
    
    private func makeConstraints() {
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
