//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___. All rights reserved.
//

import Foundation

/// Protocol that describes how ___VARIABLE_sceneName:identifier___ViewController communicates with ___VARIABLE_sceneName:identifier___Interactor
protocol ___VARIABLE_sceneName:identifier___InteractorInput: SceneViewLifecycleEvents { }

/// Protocol that describes how ___VARIABLE_sceneName:identifier___Interactor pass events to ___VARIABLE_sceneName:identifier___Presenters
protocol ___VARIABLE_sceneName:identifier___InteractorOutput: ErrorPresentable { }

/// Contains all business logic for a ___VARIABLE_sceneName:identifier___ scene
final class ___VARIABLE_sceneName:identifier___Interactor {
    /// Data that should be passed to scene from outside.
    /// Ex: objectID or profileBrief. Services shouldn't be pass in this struct
    struct Dependencies {
        
    }
    
    /// Data that should be used to display data on the screen
    private struct Content: Hashable {
        
    }
    
    private typealias State = LoadableSceneState<Content>
    
    //MARK: - Properties
    private let output: ___VARIABLE_sceneName:identifier___InteractorOutput?
    private let dependencies: Dependencies
    private var state: State
    
    //MARK: - Initialization
    init(
        output: ___VARIABLE_sceneName:identifier___InteractorOutput,
        dependencies: Dependencies
    ) {
        self.output = output
        self.dependencies = dependencies
        self.state = .loading
    }
}

//MARK: - InteractorInput
extension ___VARIABLE_sceneName:identifier___Interactor: ___VARIABLE_sceneName:identifier___InteractorInput {
    
}

//MARK: - SceneViewLifecycleEvents
extension ___VARIABLE_sceneName:identifier___Interactor: SceneViewLifecycleEvents {
    func viewDidLoad() {
        
    }
}
