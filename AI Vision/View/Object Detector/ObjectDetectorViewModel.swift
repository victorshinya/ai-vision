//
//  Copyright 2020 Victor Shinya
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import UIKit

class ObjectDetectorViewModel {
    
    private let watsonService: WatsonService
    private var resultModel = [VisualRecognitionResultModel]()
    
    init() {
        self.watsonService = WatsonService(apiKey: Constants.WATSON_VISUALRECOGNITIONV3_APIKEY, version: Constants.WATSON_VISUALRECOGNITIONV3_VERSION)
    }
    
    func classify(image: UIImage, completion: @escaping (String) -> Void) {
        resultModel.removeAll()
        watsonService.visualRecognition.classify(image: image, classifierIDs: ["BugDetector_1819574982"]) { response, error in
            guard let classifiedImages = response?.result else {
                return
            }
            
            for classObject in classifiedImages.images[0].classifiers[0].classes {
                self.resultModel.append(VisualRecognitionResultModel(className: classObject.class, score: classObject.score))
            }
            
            var result = ""
            for model in self.resultModel {
                result.append("\(model.className): \(Int(model.score * 100))%\n")
            }
            completion(result)
        }
    }
}
