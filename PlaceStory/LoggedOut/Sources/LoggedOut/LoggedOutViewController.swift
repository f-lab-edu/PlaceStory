//
//  LoggedOutViewController.swift
//  PlaceStory
//
//  Created by 최제환 on 12/2/23.
//

import AuthenticationServices
import Combine
import ModernRIBs
import ProxyPackage
import SnapKit
import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    func handleSignInWithApple()
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    
    // MARK: - Property
    
    weak var listener: LoggedOutPresentableListener?
    
    // MARK: - UI Component
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Place\t\t\t\n\t\t\tStory"
        label.textAlignment = .center
        label.font = .italicSystemFont(ofSize: 84)
        label.layer.shadowColor = UIColor(named: "logoLabelShadow")?.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowOffset = CGSize(width: 5, height: 5)
        label.numberOfLines = 2
        label.textColor = UIColor(named: "logoLabel")
        
        return label
    }()
    
    lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(didTappedAppleLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Custom Method
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoLabel)
        view.addSubview(appleLoginButton)
        
        configureLogoLabelConstraint()
        configureAppleLoginButtonConstraint()
    }
    
    private func configureLogoLabelConstraint() {
        logoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY).offset(-150)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func configureAppleLoginButtonConstraint() {
        appleLoginButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.snp.bottom).offset(-80)
            make.height.equalTo(56)
        }
    }
    
    @objc
    private func didTappedAppleLoginButton() {
        listener?.handleSignInWithApple()
    }
}
