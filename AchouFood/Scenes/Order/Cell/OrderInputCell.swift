//
//  OrderInputCell.swift
//  AchouFood
//
//  Created by Arthur Rios on 06/02/26.
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
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.font = Typography.bodyMd
        textView.textColor = Color.gray400
        textView.keyboardType = .alphabet
        textView.textContainerInset = UIEdgeInsets(
            top: Metrics.small,
            left: Metrics.small,
            bottom: Metrics.small,
            right: Metrics.small
        )
        return textView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bodyMd
        label.textColor = Color.gray400
        label.numberOfLines = 3
        label.text = "Ex: sem cebola"
        return label
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
    
    func configure(placeholder: String = "Ex: sem cebola", text: String? = nil) {
        placeholderLabel.text = placeholder
        textView.text = text ?? ""
        updatePlaceholderVisibility()
    }
    
    func updatePlaceholderVisibility() {
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
            make.trailing.equalToSuperview().offset(OrderInputCellConstants.padding)
        }
    }
    
    func setViewConfigs() {
        textView.delegate = self
    }
}

extension OrderInputCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        inputEditing = true
        updatePlaceholderVisibility()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        inputEditing = false
        updatePlaceholderVisibility()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRanges ranges: [NSValue], replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        onTextChanged?(textView.text)
    }
}
