//
//  OrderInputCell.swift
//  AchouFood
//
//  Created by Silvano Malfatti on 05/02/26.
//

import UIKit
import SnapKit

struct OrderInputCellConstants {
    static let containerHeight = 160.0
    static let padding = 18.0
}

final class OrderInputCell: UITableViewCell {
    
    var onTextChanged: ((String) -> Void)?
    static let reuseIdentifier: String = "OrderInputCell"
    private var inputEditing = false
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = Color.gray200.cgColor
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.font = Typography.bodyMd
        view.textColor = Color.gray400
        view.keyboardType = .alphabet
        view.textContainerInset = UIEdgeInsets(
            top: Metrics.small,
            left: Metrics.small,
            bottom: Metrics.small,
            right: Metrics.small
        )
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.bodyMd
        view.textColor = Color.gray400
        view.numberOfLines = 3
        view.text = "Ex: sem cebola"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = ""
        onTextChanged = nil
    }
    
    func configure(placeHolder: String = "Ex: sem cebola", text: String? = nil) {
        placeholderLabel.text = placeHolder
        textView.text = text ?? ""
        updatePleceHolderVisibility()
    }
    
    func updatePleceHolderVisibility() {
        placeholderLabel.isHidden = inputEditing || !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension OrderInputCell: ViewCodeProtocol {
    func setViewHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(textView)
        containerView.addSubview(placeholderLabel)
    }
    
    func setViewConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Metrics.tiny)
            make.height.greaterThanOrEqualTo(OrderInputCellConstants.containerHeight)
        }
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(OrderInputCellConstants.padding)
            make.leading.equalToSuperview().offset(OrderInputCellConstants.padding)
            make.trailing.equalToSuperview().offset(-OrderInputCellConstants.padding)
        }
    }
    
    func setViewConfigs() {
        textView.delegate = self
    }
}

extension OrderInputCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        inputEditing = true
        updatePleceHolderVisibility()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        inputEditing = false
        updatePleceHolderVisibility()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRanges ranges: [NSValue], replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updatePleceHolderVisibility()
        onTextChanged?(textView.text)
    }
}
