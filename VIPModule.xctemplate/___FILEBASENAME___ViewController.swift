//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___. All rights reserved.
//

import UIKit

/// ___VARIABLE_sceneName:identifier___ events handler. Describes how ___VARIABLE_sceneName:identifier___ module communicates with a flow (Flow coordinator should become module delegate)
protocol ___VARIABLE_sceneName:identifier___ViewControllerDelegate: AnyObject { }

final class ___VARIABLE_sceneName:identifier___ViewController: UIViewController {
    //MARK: - Properties
    var interactor: ___VARIABLE_sceneName:identifier___InteractorInput!
    weak var delegate: ___VARIABLE_sceneName:identifier___ViewControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

//MARK: - PresenterOutput
extension ___VARIABLE_sceneName:identifier___ViewController: ___VARIABLE_sceneName:identifier___PresenterOutput {
    
}
