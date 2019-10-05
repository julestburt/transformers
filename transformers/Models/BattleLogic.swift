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
    static func rankedTeams(_ allTransformers:[String:Transformer]) -> (autobots:[Transformer], decepticons:[Transformer]) {
        let autobots = allTransformers.map { $0.value }.filter { $0.team == .autobot }.sorted { $0.rank > $1.rank }
        let decepticons = allTransformers.map { $0.value }.filter { $0.team == .decepticon }.sorted { $0.rank > $1.rank }
        return (autobots,decepticons)
    }
    
    static var grabRankedTeams:(autobots:[Transformer], decepticons:[Transformer]) {
        return rankedTeams(Transformers.current.DB)
    }
    
    // Go through each pairing and build the winner/loser tuple
    func battleResults(teams:(autobots:[Transformer], decepticons:[Transformer]) = grabRankedTeams) -> [(winners: [Transformer], losers: [Transformer])] {
        guard teams.autobots.count > 0 && teams.decepticons.count > 0 else { return []} // no know logic of what to do in this case...
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
    
    //------------------------------------------------------------------------------
    // MARK: The battle logic for real
    //------------------------------------------------------------------------------
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
        return abs(first.courage - second.courage) >= 4 &&
            abs(first.strength - second.strength) >= 3 ? true : false
    }
    
    func namedOptimusPredaking(first:Transformer, second:Transformer) -> Bool {
        return (first.name == "Optimus Prime" || first.name == "Predaking") ||
            (second.name == "Optimus Prime" || second.name == "Predaking")
    }
    
}

extension String {
    func containsAny(_ names:[String]) -> Bool {
        return names.reduce(false) { contains, name in
            contains || (name == self)
        }
    }
}
