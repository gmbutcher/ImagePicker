import UIKit

protocol BottomContainerViewDelegate: class {

  func pickerButtonDidPress()
  func doneButtonDidPress()
  func cancelButtonDidPress()
  func imageStackViewDidPress()
}

public class BottomContainerView: UIView {

  struct Dimensions {
    static let height: CGFloat = 101
  }

  lazy var pickerButton: ButtonPicker = self.createPickerButton()
  
  lazy var borderPickerButton: UIView = self.createBorderPickerButton()

  public lazy var doneButton: UIButton = self.createDoneButton()
  
  lazy var stackView = ImageStackView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

  lazy var topSeparator: UIView = self.createTopSeparator()
  
  lazy var tapGestureRecognizer: UITapGestureRecognizer = self.createTapGestureRecognizer()
  
  weak var delegate: BottomContainerViewDelegate?
  var pastCount = 0
  
  // MARK: Lazy compile time fix
  
  private func createPickerButton() -> ButtonPicker {
    let pickerButton = ButtonPicker()
    pickerButton.setTitleColor(.whiteColor(), forState: .Normal)
    pickerButton.delegate = self
    
    return pickerButton
  }
  
  private func createBorderPickerButton() -> UIView {
    let view = UIView()
    view.backgroundColor = .clearColor()
    view.layer.borderColor = UIColor.whiteColor().CGColor
    view.layer.borderWidth = ButtonPicker.Dimensions.borderWidth
    view.layer.cornerRadius = ButtonPicker.Dimensions.buttonBorderSize / 2
    
    return view
  }
  
  private func createDoneButton() -> UIButton {
    let button = UIButton()
    button.setTitle(Configuration.cancelButtonTitle, forState: .Normal)
    button.titleLabel?.font = Configuration.doneButton
    button.addTarget(self, action: #selector(doneButtonDidPress(_:)), forControlEvents: .TouchUpInside)
    
    return button
  }
  
  private func createTopSeparator() -> UIView {
    let view = UIView()
    view.backgroundColor = Configuration.backgroundColor
    
    return view
  }
  
  private func createTapGestureRecognizer() -> UITapGestureRecognizer {
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGestureRecognizer(_:)))
    
    return gesture
  }
  
  // MARK: Initializers
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    [borderPickerButton, pickerButton, doneButton, stackView, topSeparator].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    backgroundColor = Configuration.backgroundColor
    stackView.accessibilityLabel = "Image stack"
    stackView.addGestureRecognizer(tapGestureRecognizer)

    setupConstraints()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Action methods

  func doneButtonDidPress(button: UIButton) {
    if button.currentTitle == Configuration.cancelButtonTitle {
      delegate?.cancelButtonDidPress()
    } else {
      delegate?.doneButtonDidPress()
    }
  }

  func handleTapGestureRecognizer(recognizer: UITapGestureRecognizer) {
    delegate?.imageStackViewDidPress()
  }

  private func animateImageView(imageView: UIImageView) {
    imageView.transform = CGAffineTransformMakeScale(0, 0)

    UIView.animateWithDuration(0.3, animations: {
      imageView.transform = CGAffineTransformMakeScale(1.05, 1.05)
      }) { _ in
        UIView.animateWithDuration(0.2) { _ in
          imageView.transform = CGAffineTransformIdentity
        }
    }
  }
}

// MARK: - ButtonPickerDelegate methods

extension BottomContainerView: ButtonPickerDelegate {

  func buttonDidPress() {
    delegate?.pickerButtonDidPress()
  }
}
