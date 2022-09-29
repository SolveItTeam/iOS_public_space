//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___. All rights reserved.
//

import UIKit

/// Protocol that describes to ___VARIABLE_sceneName:identifier___Presenter sends events to ___VARIABLE_sceneName:identifier___ViewController
protocol ___VARIABLE_sceneName:identifier___PresenterOutput where Self: UIViewController { }

/// Contains logic for сonverting data from various sources into a form suitable for display on the screen
final class ___VARIABLE_sceneName:identifier___Presenter {
    private weak var output: ___VARIABLE_sceneName:identifier___PresenterOutput?
    
    //MARK: - Initialization
    init(output: ___VARIABLE_sceneName:identifier___PresenterOutput) {
        self.output = output
    }
}

//MARK: - InteractorOutput
extension ___VARIABLE_sceneName:identifier___Presenter: ___VARIABLE_sceneName:identifier___InteractorOutput {
    
}

//MARK: - ErrorPresentable
extension ___VARIABLE_sceneName:identifier___Presenter: ErrorPresentable {
    func presentError(_ error: Error, retryBody: (() -> Void)?) {
        
    }
}
