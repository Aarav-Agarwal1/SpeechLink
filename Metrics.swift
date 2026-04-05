/*
See the License.txt file for this sample’s licensing information.
*/

import Foundation
//import CreateML
import Combine


struct PredictionMetric: Identifiable {
    var id: String { category }
    let category: String
    let value: Double
}

extension PredictionMetric: Equatable {
    static func == (lhs: PredictionMetric, rhs: PredictionMetric) -> Bool {
        return lhs.id == rhs.id &&
               lhs.category == rhs.category &&
               lhs.value == rhs.value
    }
}

class PredictionMetrics: ObservableObject, Identifiable {
    var data = [PredictionMetric]()
    var dictionary: [String : Double] = [:]
    init() {}
    
    func getNewPredictions(from probabilities: [String: Double]) {
        var tempData = [PredictionMetric]()
        dictionary = probabilities
        
        _ = dictionary.map { (key: String, value: Double) in
            tempData.append(PredictionMetric(category: key, value: value))
        }
        data = tempData.sorted(by: { $0.category > $1.category })
    }
}
