import UIKit

protocol HeaderViewDelegate: class {
  func headerView(_ headerView: HeaderView, didPressDeleteButton deleteButton: UIButton)
  func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
}

open class HeaderView: UIView {
  open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.CloseButton.text,
      attributes: LightboxConfig.CloseButton.textAttributes)

    let button = UIButton(type: .system)

    // button.setAttributedTitle(title, for: UIControl.State())

    if let size = LightboxConfig.CloseButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

    button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
      for: .touchUpInside)

    if let image = LightboxConfig.CloseButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !LightboxConfig.CloseButton.enabled
      if #available(iOS 14.0, *) {
          button.setImage(UIImage(systemName: "arrow.left")?.withTintColor(.white,
                                                                           renderingMode: .alwaysTemplate), for: .normal)
          
          button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
          button.layer.cornerRadius = button.frame.size.height/2
          button.layer.masksToBounds = true
      }

      
    return button
  }()

  open fileprivate(set) lazy var deleteButton: UIButton = { [unowned self] in
    let title = NSAttributedString(
      string: LightboxConfig.DeleteButton.text,
      attributes: LightboxConfig.DeleteButton.textAttributes)

    let button = UIButton(type: .system)

   // button.setAttributedTitle(title, for: .normal)

    if let size = LightboxConfig.DeleteButton.size {
      button.frame.size = size
    } else {
      button.sizeToFit()
    }

//    button.addTarget(self, action: #selector(deleteButtonDidPress(_:)),
//      for: .touchUpInside)

    if let image = LightboxConfig.DeleteButton.image {
        button.setBackgroundImage(image, for: UIControl.State())
    }

    button.isHidden = !LightboxConfig.DeleteButton.enabled
      if #available(iOS 14.0, *) {
          button.setImage(UIImage(systemName: "ellipsis")?.withTintColor(.white,
                                                                         renderingMode: .alwaysTemplate), for: .normal)
          
          button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
          button.layer.cornerRadius = button.frame.size.height/2
          button.layer.masksToBounds = true

      }

    return button
  }()

  weak var delegate: HeaderViewDelegate?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear
      
      if #available(iOS 14.0, *) {
          let imageView = UIImage(systemName: "square.and.arrow.down")?.withTintColor(.white,
                                                                                      renderingMode: .alwaysTemplate)
          
          let save = UIAction(title: "حفظ",image: imageView) { _ in
              self.delegate?.headerView(self, didPressDeleteButton: self.deleteButton)
          }
          deleteButton.showsMenuAsPrimaryAction = true
          deleteButton.menu = UIMenu(title: "", children: [save])
      }
     

    [deleteButton , closeButton ].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc func deleteButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressDeleteButton: button)
  }

  @objc func closeButtonDidPress(_ button: UIButton) {
    delegate?.headerView(self, didPressCloseButton: button)
  }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {

  @objc public func configureLayout() {
    let topPadding: CGFloat

    if #available(iOS 11, *) {
      topPadding = safeAreaInsets.top
    } else {
      topPadding = 0
    }

    deleteButton.frame.origin = CGPoint(
      x: bounds.width - deleteButton.frame.width - 17,
      y: topPadding
    )

    closeButton.frame.origin = CGPoint(
      x: 17,
      y: topPadding
    )
  }
}
