//
//  ViewController.swift
//  FormCombine
//
//  Created by Muhammad Tafani Rabbani on 04/06/21.
//

import UIKit
// test push

import Combine
//ViewModel

class PasswordViewModel {
    @Published  private var username = ""
    @Published  private var password = ""
    @Published  private var otherPassword = ""
    
    private var cancelable = Set<AnyCancellable>()
    
    var isUsernameEmpty : AnyPublisher<Bool, Never> {
        $username
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{$0.isEmpty}
            .eraseToAnyPublisher()
    }
    var isPassswordSame : AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $otherPassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map{$0 == $1}
            .eraseToAnyPublisher()
        
    }
    
    var isPassswordEmpty : AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $otherPassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map{$0.isEmpty && $1.isEmpty}
            .eraseToAnyPublisher()
    }
    
    var isValidButton : AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isUsernameEmpty, isPassswordSame, isPassswordEmpty)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map{
                !$0 && $1 && !$2
            }
            .eraseToAnyPublisher()
    }
    
    func listenIsButtonValid(onListen: @escaping (Bool)->Void){
        isValidButton
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{ val in
                onListen(val)
            }
            .store(in: &cancelable)
    }
    
    func listenPassword(onListen: @escaping (Bool)-> Void){
        isPassswordSame
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink{ val in
                onListen(val)
            }
            .store(in: &cancelable)
    }
    func listenToNameTextField(publisher: AnyPublisher<String, Never>){
        publisher
            .receive(on: RunLoop.main)
            .sink{ [weak self] val in
                self?.username = val
            }
            .store(in: &cancelable)
    }
    func listenToPassField(publisher: AnyPublisher<String, Never>){
        publisher
            .receive(on: RunLoop.main)
            .sink{ [weak self] val in
                self?.password = val
            }
            .store(in: &cancelable)
    }
    func listenToPassAgainField(publisher: AnyPublisher<String, Never>){
        publisher
            .receive(on: RunLoop.main)
            .sink{ [weak self] val in
                self?.otherPassword = val
            }
            .store(in: &cancelable)
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var repeatpassTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    private var viewModel = PasswordViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        binding()
    }
    
    func binding(){
        listenToTextField()
        
        viewModel.listenIsButtonValid { [weak self] val in
            self?.continueBtn.isEnabled = val
        }
        
        viewModel.listenPassword { [weak self] val in
            if !val{
                self?.statusText.text = "Password are not the same"
            }else{
                self?.statusText.text = ""
            }
        }
    }
    
    func listenToTextField(){
        
        viewModel.listenToNameTextField(publisher: nameTextField.listen())
        
        viewModel.listenToPassField(publisher: passTextField.listen())
        
        viewModel.listenToPassAgainField(publisher: repeatpassTextField.listen())
        
    }
}

extension UITextField{
    
    func listen()->AnyPublisher<String,Never>{
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map( {
                ($0.object as? UITextField)?.text ?? ""
            })
            .eraseToAnyPublisher()
    }
}
