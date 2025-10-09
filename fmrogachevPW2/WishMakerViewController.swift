//
//  ViewController.swift
//  fmrogachevPW2
//
//  Created by Feliks Rogachev on 30.09.2025.
//

import UIKit

enum Constants {
    static let sliderMin: Double = 0
    static let sliderMax: Double = 1
    
    static let red: String = "Red"
    static let green: String = "Green"
    static let blue: String = "Blue"
    
    static let stackRadius: CGFloat = 20
    static let stackBottom: CGFloat = -40
    static let stackLeading: CGFloat = 20
}




class WishMakerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    private func configureUI() {
        view.backgroundColor = .systemPink
        configureTitle()
        configureDiscription()
        configureSliders()
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
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackBottom)
            ])
    }
    
    private func updateBackgroundColor(red: CustomSlider, green: CustomSlider, blue: CustomSlider) {
        let color = UIColor(
            red: CGFloat(red.slider.value),
            green: CGFloat(green.slider.value),
            blue: CGFloat(blue.slider.value),
            alpha: 1.0
        )
        view.backgroundColor = color
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



