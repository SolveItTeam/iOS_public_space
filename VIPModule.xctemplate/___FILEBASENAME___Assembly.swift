//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___. All rights reserved.
//

import UIKit

/// Creates parts of a ___VARIABLE_sceneName:identifier___ module and install dependencies between them.
struct ___VARIABLE_sceneName:identifier___Assembly: SceneAssembly {
    private let sceneOutput: ___VARIABLE_sceneName:identifier___ViewControllerDelegate
    
    init(sceneOutput: ___VARIABLE_sceneName:identifier___ViewControllerDelegate) {
        self.sceneOutput = sceneOutput
    }
    
    func makeScene() -> UIViewController {
        let view = ___VARIABLE_sceneName:identifier___ViewController()
        let presenter = ___VARIABLE_sceneName:identifier___Presenter(output: view)
        let interactor = ___VARIABLE_sceneName:identifier___Interactor(
            output: presenter,
            dependencies: ___VARIABLE_sceneName:identifier___Interactor.Dependencies()
        )
        view.interactor = interactor
        view.delegate = sceneOutput
        
        return view
    }
}
