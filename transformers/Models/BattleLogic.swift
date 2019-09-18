//
//  BattleLogic.swift
//  transformers
//
//  Created by Jules Burt on 2019-09-17.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import Foundation

//------------------------------------------------------------------------------
// MARK: Transformer Battle Game Logic
//------------------------------------------------------------------------------

class Battle {
// Get the ranked teams
static var rankedTeams:(autobots:[Transformer], decepticons:[Transformer]) {
    let autobots = Transformers.current.DB.map { $0.value }.filter { $0.team == .autobot }.sorted { $0.rank > $1.rank }
    let decepticons = Transformers.current.DB.map { $0.value }.filter { $0.team == .decepticon }.sorted { $0.rank > $1.rank }
    return (autobots,decepticons)
}

// Go through each pairing and build the winner/loser tuple
func battleResults(teams:(autobots:[Transformer], decepticons:[Transformer]) = rankedTeams) -> [(winners: [Transformer], losers: [Transformer])] {
    let maxCount = min(teams.autobots.count, teams.decepticons.count)
    ultimateShowdownOccured = false // Both contenters name is one of keyNames, so all lose!
    defer {
        ultimateShowdownOccured = false
    }
    let winnersLosers = Range(0...maxCount-1)
        .compactMap { self.battle(first: teams.autobots[$0], second: teams.decepticons[$0])}
    
    guard !ultimateShowdownOccured else {
        var allDestroyed:[Transformer] = teams.autobots
        allDestroyed.append(contentsOf: teams.decepticons)
        return [([], allDestroyed)]
    }
    return winnersLosers
}

var ultimateShowdownOccured = false
func battle(first:Transformer, second:Transformer) -> (winners:[Transformer], losers:[Transformer]) {
    let keyNames = ["Optimus Prime", "Predaking"]
    guard !namedOptimusPredaking(first: first, second: second) else {
        if first.name.containsAny(keyNames) && !second.name.containsAny(keyNames) { return ([first], [second]) }
        else if second.name.containsAny(keyNames) && !first.name.containsAny(keyNames) { return ([second],[first])}
        ultimateShowdownOccured = true
        return ([],[first, second])
    }
    guard !courageStrengthLimitsMet(first: first, second: second) else {
        return first.courage < second.courage ?
            ([second], [first]) : ([first], [second])
    }
    guard !skillLimitsMet(first:first, second:second) else {
        return first.skill < second.skill ?
            ([second], [first]) : ([first], [second])
    }
    
    guard abs(first.overall_rating - second.overall_rating) > 0 else {
        return ([], [first, second]) }
    
    return first.overall_rating > second.overall_rating ?
        ([first], [second]) : ([second], [first])
}

func skillLimitsMet(first:Transformer, second:Transformer) -> Bool {
    return abs(first.skill - second.skill) >= 3
}

func courageStrengthLimitsMet(first:Transformer, second:Transformer) -> Bool {
    // check if courage <= 4 && strength <= 3
    return !(abs(first.courage - second.courage) >= 4 &&
        abs(first.strength - second.strength) >= 3) ? true : false
}

func namedOptimusPredaking(first:Transformer, second:Transformer) -> Bool {
    return (first.name == "Optimus Prime" || first.name == "Predaking") ||
        (second.name == "Optimus Prime" || second.name == "Predaking")
}

}

//func storeTransformers(_ toStore:[Transformer]) {
//    safeSerialQueueTransformer.async(flags:.barrier) {
//        for transformer in toStore {
//            self._transformers[transformer.id] = transformer
//        }
//        self.storeTransformers()
//    }
//}
//
//func addCreatedTransformer(_ transformer:Transformer) {
//    safeSerialQueueTransformer.async(flags:.barrier) {
//        self._transformers[transformer.id] = transformer
//        self.storeTransformers()
//    }
//}
//
////------------------------------------------------------------------------------
//// MARK: Store / Restore localDB to UserDefaults
////------------------------------------------------------------------------------
//
//func restoreTransformers() {
//    guard let storedTransformerJSON = UserDefaults.standard.object(forKey: UserDefaults.keys.transformerStore) as? String,
//        let jsonData = storedTransformerJSON.data(using: .utf8),
//        let json = try? JSON(data: jsonData),
//        let jsonArrayTransformers = json["transformers"].array else { return }
//    let transformers = jsonArrayTransformers.compactMap {
//        Transformer($0.description)
//    }
//    storeTransformers(transformers)
//}
//
//
//func storeTransformers() {
//    let jsonArrayTransformers = self._transformers.map { $0.value.createJSON }.compactMap { $0 }
//    let result:JSON =  ["transformers":"[\(jsonArrayTransformers.joined(separator: ","))]"]
//    UserDefaults.standard.set(result.description, forKey: UserDefaults.keys.transformerStore)
//}
//
//}

// I wouldn't normally extend String just to accomodate this, I would create a new Transformer Name type and extend that!
extension String {
    func containsAny(_ names:[String]) -> Bool {
        return names.reduce(false) { contains, name in
            contains || (name == self)
        }
    }
}
