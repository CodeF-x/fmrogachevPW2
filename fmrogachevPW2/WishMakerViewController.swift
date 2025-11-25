import UIKit


enum Constants {
    
    static let sliderMin: Double = 0
    static let sliderMax: Double = 1
    
    static let red: String = "Red"
    static let green: String = "Green"
    static let blue: String = "Blue"
    
    static let stackRadius: CGFloat = 20
    static let stackBottom: CGFloat = -10
    static let stackLeading: CGFloat = 20
    
    static let buttonHeight: CGFloat = 50
    static let buttonBottom: CGFloat = 20
    static let buttonSide: CGFloat = 100
    static let buttonText1: String = "My wishes"
    static let buttonRadius: CGFloat = 10
    static let buttonText2: String = "Shadule wish granting"
    static let buttonText3: String = "Add event"
    
    static let tableCornerRadius: CGFloat = 10
    static let tableOffset: CGFloat = 20
    
    static let numberOfSections: Int = 2
    
    static let wishesKey = "savedWishes"
    
    static let spacing: CGFloat = 10

    static let contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
}

class WishMakerViewController: UIViewController {
    
    private let addWishButton: UIButton = UIButton(type: .system)
    private let scheduleWishesButton: UIButton = UIButton(type: .system)
    private var currentColor: UIColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemPink
        configureTitle()
        configureDiscription()
        configureActionStack()
        configureSliders()
        
        
    }
    private func configureActionStack() {
        let actionStack = UIStackView()
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.axis = .vertical
        view.addSubview(actionStack)
        actionStack.spacing = Constants.spacing
        configureAddWishButton()
        configureScheduleMissions()
        for button in [addWishButton, scheduleWishesButton] {
            actionStack.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            actionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            actionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.stackLeading),
            actionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.stackBottom)
        ])
    }
    
    private func configureTitle() {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "WishMaker"
        title.font = UIFont.systemFont(ofSize: 32)
        title.textColor = .white
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    private func configureDiscription() {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "This app can change background color"
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        
        view.addSubview(title)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80)
        ])
    }
    
    
    private func configureSliders(){
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        stack.layer.cornerRadius = Constants.stackRadius
        stack.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax )
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax )
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax )
        
        for slider in [sliderRed, sliderGreen, sliderBlue]{
            stack.addArrangedSubview(slider)
        }
        sliderRed.valueChanged = { [weak self] _ in
            self?.updateBackgroundColor(red: sliderRed, green: sliderGreen, blue: sliderBlue)
        }
        sliderGreen.valueChanged = { [weak self] _ in
            self?.updateBackgroundColor(red: sliderRed, green: sliderGreen, blue: sliderBlue)
        }
        sliderBlue.valueChanged = { [weak self] _ in
            self?.updateBackgroundColor(red: sliderRed, green: sliderGreen, blue: sliderBlue)
        }
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            stack.bottomAnchor.constraint(equalTo: addWishButton.topAnchor, constant: Constants.stackBottom)
        ])
    }
    
    private func configureAddWishButton() {
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.buttonText1, for: .normal)
        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    private func configureScheduleMissions() {
        scheduleWishesButton.backgroundColor = .white
        scheduleWishesButton.setTitleColor(.systemPink, for: .normal)
        scheduleWishesButton.setTitle(Constants.buttonText2, for: .normal)
        scheduleWishesButton.layer.cornerRadius = Constants.buttonRadius
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishesButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func addWishButtonPressed() {
        present(WishStoringViewController(), animated: true)
    }
    
    
    @objc
    private func scheduleWishesButtonPressed() {
        let vc = WishCalendarViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateBackgroundColor(red: CustomSlider, green: CustomSlider, blue: CustomSlider) {
        currentColor = UIColor(
            red: CGFloat(red.slider.value),
            green: CGFloat(green.slider.value),
            blue: CGFloat(blue.slider.value),
            alpha: 1.0
        )
        addWishButton.setTitleColor(currentColor, for: .normal)
        scheduleWishesButton.setTitleColor(currentColor, for: .normal)
        view.backgroundColor = currentColor
    }
    
}

final class CustomSlider: UIView {
    var valueChanged: ((Double) -> Void)?
    
    var slider = UISlider()
    var tittleView = UILabel()
    
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        tittleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder){
        fatalError( "init(coder:) has not been implemented")
    }
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        for view in [slider, tittleView] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tittleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tittleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            tittleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            slider.topAnchor.constraint(equalTo: tittleView.bottomAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
        ])
        
    }
    
    @objc
    private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}

final class WishStoringViewController: UIViewController {
    private let defaults = UserDefaults.standard
    private let table: UITableView = UITableView(frame: .zero)
    private var wishArray: [String] = []
    override func viewDidLoad() {
        view.backgroundColor = .blue
        if let savedWishes = defaults.array(forKey: Constants.wishesKey) as? [String] {
            wishArray = savedWishes
        }
        configureTable()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .red
        table.dataSource = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.tableOffset),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tableOffset),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.tableOffset),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.tableOffset)
        ])
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        
        
    }
    
    
}

extension WishStoringViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return wishArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as! AddWishCell
            cell.addWish = { [weak self] wish in
                guard let self = self else { return }
                self.wishArray.append(wish)
                self.table.reloadData()
                self.defaults.set(self.wishArray, forKey: Constants.wishesKey)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as! WrittenWishCell
            cell.configure(with: wishArray[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}



final class WrittenWishCell: UITableViewCell {
    static let reuseId: String = "WrittenWishCell"
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let wishLabelOffset: CGFloat = 8
    }
    private let wishLabel: UILabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with wish: String) {
        wishLabel.text = wish
    }
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        let wrap: UIView = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrap)
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        
        
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.wrapOffsetV),
            wrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.wrapOffsetV),
            wrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.wrapOffsetH),
            wrap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.wrapOffsetH)
        ])
        
        wishLabel.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(wishLabel)
        
        NSLayoutConstraint.activate([
            wishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.wishLabelOffset),
            wishLabel.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -Constants.wishLabelOffset),
            wishLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.wishLabelOffset),
            wishLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.wishLabelOffset)
        ])
    }
}


final class AddWishCell: UITableViewCell {
    static let reuseId = "AddWishCell"
    private let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.cornerRadius = 8
        return tv
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.layer.cornerRadius = Constants.buttonRadius
        return button
    }()
    
    var addWish: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    private func configureUI() {
        selectionStyle = .none
        let stack = UIStackView(arrangedSubviews: [textView, addButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .red
        stack.backgroundColor = .red
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    @objc private func addButtonPressed() {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        addWish?(text)
        textView.text = ""
    }
}
