//
//  DetailsViewController.swift
//  fogata
//
//  Created by Adriancys Jesus Villegas Toro on 13/3/24.
//

import UIKit
import CoreLocation

class DetailsViewController: UIViewController {

    // MARK: - Properties
    
    private let coordinate: CLLocation
    
    private lazy var backView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismissScreen))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var container: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var locationTitle: UILabel = {
       let label = UILabel()
        label.text = "Location"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var latitude: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var longitude: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init(coordinate: CLLocation) {
        self.coordinate = coordinate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        showData()
    }
    

    // MARK: - setUpView
    
    private func setUpView() {
        view.addSubview(backView)
        backView.addSubview(container)
        [locationTitle, latitude, longitude].forEach {
            container.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            container.heightAnchor.constraint(equalToConstant: 400),
            
            locationTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            locationTitle.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            locationTitle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            locationTitle.heightAnchor.constraint(equalToConstant: 30),
            
            latitude.topAnchor.constraint(equalTo: locationTitle.bottomAnchor, constant: 5),
            latitude.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            latitude.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            latitude.heightAnchor.constraint(equalToConstant: 30),
            
            longitude.topAnchor.constraint(equalTo: latitude.bottomAnchor, constant: 5),
            longitude.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            longitude.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
            longitude.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        
        view.backgroundColor = .clear
    }

    func showData() {
        DispatchQueue.main.async {
            self.latitude.text = "Latitude: \(self.coordinate.coordinate.latitude)"
            self.longitude.text = "Longitide: \(self.coordinate.coordinate.longitude)"
        }
    }
    
    // MARK: - Targets
    
    @objc func dismissScreen() {
        dismiss(animated: true)
    }
}
