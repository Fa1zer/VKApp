//
//  TabBarController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 22.06.2022.
//

import UIKit

protocol TabBarCoordinatable {
    
    var tabBarDelegate: TabBarController { get set }
    
    func start()
    
}

final class TabBarController: UITabBarController, RegistrationCoordinatable {
    
    init(dataManager: DataManager, registrationManager: RegistrationManager, keychainManager: KeychainManager, userDefaultsManager: UserDefaultsManager) {
        self.dataManager = dataManager
        self.registrationManager = registrationManager
        self.keychainManager = keychainManager
        self.userDefaultsManager = userDefaultsManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var coordinatorDelegate: RegistrationCoordinator?
    private let dataManager: DataManager
    private let registrationManager: RegistrationManager
    private let keychainManager: KeychainManager
    private let userDefaultsManager: UserDefaultsManager
    
    private let coreDataManager = CoreDataManager()
    private var mainCoordinator: MainCoordinator {
        return MainCoordinator(dataManager: self.dataManager, coreDataManager: self.coreDataManager, tabBarDelegate: self, userDefaultsManager: self.userDefaultsManager)
    }
    
    private var profileCoordinator: ProfileCoordnator {
        return ProfileCoordnator(dataManager: self.dataManager, coreDataManager: self.coreDataManager, registrationManager: self.registrationManager, keychainManager: self.keychainManager, tabBarDelegate: self, userDefaultsManager: self.userDefaultsManager)
    }
    private var savedCoordinator: SavedCoordnator {
        return SavedCoordnator(dataManager: self.dataManager, coreDataManager: self.coreDataManager, tabBarDelegate: self, userDefaultsManager: self.userDefaultsManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationControllers()
        self.setupViews()
    }
    
    func goToOnboarding() {
        self.coordinatorDelegate?.goToOnboarding()
    }
    
    func goToLogOut() {
        self.coordinatorDelegate?.goToLogOut()
    }
    
    private func setupNavigationControllers() {
        let navigationControllers = [
            self.mainCoordinator.navigationController,
            self.profileCoordinator.navigationController,
            self.savedCoordinator.navigationController
        ]
        
        self.viewControllers = navigationControllers
    }
    
    private func setupViews() {
        self.tabBar.tintColor = .systemOrange
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBar.backgroundColor = .backgroundColor
        self.tabBar.alpha = 0.8
    }

}
