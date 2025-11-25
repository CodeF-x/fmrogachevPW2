import UIKit

struct WishEventModel: Codable {
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
}


class WishCalendarViewController: UIViewController {
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private var events: [WishEventModel] = []
    private let addEventButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEventsFromDefaults()
        view.backgroundColor = .systemPink
        configureAddEventButton()
        configureCollection()
    }
    
    private func loadEventsFromDefaults() {
        if let data = UserDefaults.standard.data(forKey: Constants.wishesKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([WishEventModel].self, from: data) {
                self.events = decoded
            }
        }
    }
    
    private func configureCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = Constants.contentInset
        if let layout = collectionView.collectionViewLayout as?
            UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.invalidateLayout()
        }
        collectionView.register(
            WishEventCell.self,
            forCellWithReuseIdentifier: WishEventCell.reuseIdentifier
        )
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: addEventButton.topAnchor, constant: Constants.stackBottom)
        ])
    }
    
    private func configureAddEventButton() {
        view.addSubview(addEventButton)
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.backgroundColor = .white
        addEventButton.setTitleColor(.systemPink, for: .normal)
        addEventButton.setTitle(Constants.buttonText3, for: .normal)
        addEventButton.layer.cornerRadius = Constants.buttonRadius
        addEventButton.addTarget(self, action: #selector(addEventButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addEventButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addEventButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonBottom),
            addEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonSide),
            addEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonSide)
        ])
    }
    
    @objc
    private func addEventButtonPressed() {
        let creationVC = WishEventCreationView()
        
        creationVC.onEventCreated = { [weak self] newEvent in
            guard let self = self else { return }
            self.events.append(newEvent)
            let indexPath = IndexPath(item: self.events.count - 1, section: 0)
            self.collectionView.insertItems(at: [indexPath])
        }
        
        present(creationVC, animated: true)
    }
    
}
// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath)
        guard let wishEventCell = cell as? WishEventCell else { return cell }
        wishEventCell.configure(with: events[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 10, height: 100)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("Cell tapped at index \(indexPath.item)")
    }
}


final class WishEventCreationView: UIViewController {
    
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startDateField = UIDatePicker()
    private let endDateField = UIDatePicker()
    var onEventCreated: ((WishEventModel) -> Void)?
    private let defaults = UserDefaults.standard
    private var eventArray: [String] = []
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGreen
        button.setTitle("Add event", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.layer.cornerRadius = Constants.buttonRadius
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let textView1: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .lightGray
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.cornerRadius = 8
        return tv
    }()
    private let textView2: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .lightGray
        tv.font = .systemFont(ofSize: 16)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.cornerRadius = 8
        return tv
    }()
    private let textView3: UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .date
        dp.backgroundColor = .lightGray
        dp.layer.borderWidth = 1
        dp.layer.borderColor = UIColor.gray.cgColor
        dp.layer.cornerRadius = 8
        return dp
    }()
    private let textView4: UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .date
        dp.backgroundColor = .lightGray
        dp.layer.borderWidth = 1
        dp.layer.borderColor = UIColor.gray.cgColor
        dp.layer.cornerRadius = 8
        return dp
    }()
    
    
    private let eventLabel1: UILabel = {
        let tv = UILabel()
        tv.text = "Название"
        tv.textColor = .black
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    private let eventLabel2: UILabel = {
        let tv = UILabel()
        tv.text = "Описание"
        tv.textColor = .black
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    private let eventLabel3: UILabel = {
        let tv = UILabel()
        tv.text = "Время начала"
        tv.textColor = .black
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    private let eventLabel4: UILabel = {
        let tv = UILabel()
        tv.text = "Время конца"
        tv.textColor = .black
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        if let savedEvents = defaults.array(forKey: Constants.wishesKey) as? [String] {
            eventArray = savedEvents
        }
        configureUI()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Success",
                                      message: "Event added to calendar",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [eventLabel1,textView1,eventLabel2,textView2,eventLabel3,textView3,eventLabel4,textView4, saveButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .white
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textView1.heightAnchor.constraint(equalToConstant: 40),
            textView2.heightAnchor.constraint(equalToConstant: 40),
            textView3.heightAnchor.constraint(equalToConstant: 40),
            textView4.heightAnchor.constraint(equalToConstant: 40),
            eventLabel1.heightAnchor.constraint(equalToConstant: 40),
            eventLabel2.heightAnchor.constraint(equalToConstant: 40),
            eventLabel3.heightAnchor.constraint(equalToConstant: 40),
            eventLabel4.heightAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
        ])
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    
    @objc private func saveButtonPressed() {
        let text1 = textView1.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let text2 = textView2.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let text3 = textView3.date
        let text4 = textView4.date
        
        guard !text1.isEmpty, !text2.isEmpty else { return }
        let newEvent = WishEventModel(
            title: textView1.text,
            description: textView2.text,
            startDate: text3,
            endDate: text4
        )
        
        
        
        
        
        let calendarEvent = CalendarEventModel(
            title: newEvent.title,
            startDate: newEvent.startDate,
            endDate: newEvent.endDate,
            note: newEvent.description
        )
        CalendarManager().create(eventModel: calendarEvent)
        onEventCreated?(newEvent)
        saveEventToDefaults(newEvent)
        showAlert()
        textView1.text = ""
        textView2.text = ""
    }
    
    private func saveEventToDefaults(_ event: WishEventModel) {
            var savedEvents: [WishEventModel] = []
            if let data = defaults.data(forKey: Constants.wishesKey) {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([WishEventModel].self, from: data) {
                    savedEvents = decoded
                }
            }

            savedEvents.append(event)

            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(savedEvents) {
                defaults.set(encoded, forKey: Constants.wishesKey)
            }
        }
}
