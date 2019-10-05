//
//  BattleLogicTests.swift
//  transformersTests
//
//  Created by Jules Burt on 2019-09-19.
//  Copyright © 2019 bethegame Inc. All rights reserved.
//

import XCTest
@testable import transformers

class BattleLogicTests: XCTestCase {
    
    let sut = Battle()
    
    //     Test individual rules broken out...
    
    // < 4 more points courage and 3 < more strength loses..
    func testCourageStrength() {
        
        XCTAssert(sut.ultimateShowdownOccured == false, "logic showing there has been no battle between Optimus and Predaking")
        let transformerHighSkillCourage = Transformer(name: "Prime", team: Team.autobot, strength: 9, courage: 8)
        let transformerLowSkillCourage = Transformer(name: "Bumblebee", team: Team.autobot, strength: 6, courage: 4, skill: 3)
        let transformerMedSkillCourage = Transformer(name: "Ratchet", team:Team.decepticon, strength: 7, courage: 5, skill: 8)
        
        var result = sut.courageStrengthLimitsMet(first: transformerHighSkillCourage, second: transformerLowSkillCourage)
        XCTAssert(result == true, "logic failed to determine a winner with 4 or more points of courage and 3 or more points of strength")
        result = sut.courageStrengthLimitsMet(first: transformerMedSkillCourage, second: transformerLowSkillCourage)
        XCTAssert(result == false, "logic failed to determine no winner with less 4 or more points of courage and or less 3 or more points of strength")
    }
    
    // < 3 or more skill...
    func testSkill() {
        let transformerHighSkill = Transformer(name: "Jazz", team: Team.decepticon, skill: 8)
        let transformerMedSkill = Transformer(name: "Bumblebee", team: Team.autobot, skill: 6)
        let transformerLowSkill = Transformer(name: "Prime", team: Team.autobot, skill: 5)
        var result = sut.skillLimitsMet(first: transformerHighSkill, second: transformerLowSkill)
        XCTAssert(result == true, "logic failed to determine a winner with more 3 or more points of skill")
        result = sut.skillLimitsMet(first: transformerMedSkill, second: transformerLowSkill)
        XCTAssert(result == false, "logic failed to determine no winner with less 3 points of skill")
    }
    
    // otherwise highest rating? rating = Strength + Intelligence + Speed + Endurance + Firepower
    func testRating() {
        let transformerHighRating = Transformer(name: "Blurr", team: Team.decepticon, strength:10, intelligence:8, speed:8, endurance:8, firepower:8)
        let transformerSameHighRating = Transformer(name: "Bumblebee", team: Team.autobot, strength:8, intelligence:8, speed:8, endurance:10, firepower:8)
        XCTAssert(abs(transformerHighRating.overall_rating - transformerSameHighRating.overall_rating) == 0, "logic failed to determine no winner with same overall_rating...")
    }
    
    // check key Players win...
    func testOptimusPredaking() {
        let transformerOptimus = Transformer(name: "Optimus Prime", team: Team.autobot)
        let transformerNotOptimus = Transformer(name: "Bumblebee", team: Team.autobot)
        let transformerPredaking = Transformer(name: "Predaking", team: Team.decepticon)
        var result = sut.namedOptimusPredaking(first: transformerOptimus, second: transformerNotOptimus)
        XCTAssert(result == true, "logic failed to determine a winner with one named Optimus")
        result = sut.namedOptimusPredaking(first: transformerNotOptimus, second: transformerPredaking)
        XCTAssert(result == true, "logic failed to determine a winner with one named Predaking")
    }
    
    //    overall battle logic checks winner if...
    
    // >=4 courage && >= 3 strength difference
    func testWinnerWithCourageStrength() {
        let transformerCourageStrengthLoserHighRanking = Transformer(name: "Jazz", team: Team.decepticon, strength:7, intelligence:10, speed:10, endurance:10, courage:6, firepower:10)
        let transformerCourageStrengthWinner = Transformer(name: "Jazz", team: Team.decepticon, strength:10, intelligence:8, speed:8, endurance:8, courage:10, firepower:8)
        let result = sut.battle(first: transformerCourageStrengthWinner, second: transformerCourageStrengthLoserHighRanking)
        XCTAssert(result.winners.first!.id == transformerCourageStrengthWinner.id, "logic failed to determine a winner with high courage and strength over overall_rating")
        XCTAssert(result.losers.first!.id == transformerCourageStrengthLoserHighRanking.id, "logic failed to determine a loser with low courage and strength over overall_rating")
    }
    
    // >=3 skill difference
    func testWinnerWithSkill() {
        let transformerHighSkillWinner = Transformer(name: "Jazz", team: Team.autobot, strength:5, intelligence:5, speed:5, endurance:5, firepower:5, skill:10)
        let transformerMedSkillLoser = Transformer(name: "Jazz", team: Team.autobot, strength:8, intelligence:8, speed:8, endurance:8, firepower:8, skill: 9)
        let transformerLowSkillLoser = Transformer(name: "Wheeljack", team: Team.autobot, strength:8, intelligence:8, speed:8, endurance:8, firepower:8, skill: 7)
        var result = sut.battle(first: transformerHighSkillWinner, second: transformerLowSkillLoser)
        XCTAssert(result.winners.first!.id == transformerHighSkillWinner.id, "logic failed to determine a winner with high skill over high overall_rating")
        XCTAssert(result.losers.first!.id == transformerLowSkillLoser.id, "logic failed to determine a winner with high skill over high overall_rating")
        result = sut.battle(first: transformerHighSkillWinner, second: transformerMedSkillLoser)
        XCTAssert(result.winners.first!.id == transformerMedSkillLoser.id, "logic failed to determine an overall_rating win over a non skill win")
        XCTAssert(result.losers.first!.id == transformerHighSkillWinner.id, "logic failed to determine a loser in overall_rating win over a non skill win")
    }
    
    // highest overall_rating
    let transformerHighRatingMedSkillCourageStrength = Transformer(name: "Jazz", team: Team.autobot, strength:7, intelligence:10, speed:10, endurance:10, courage: 7, firepower:10, skill: 8)
    let transformerLowRatingHighSkillCourageStrength = Transformer(name: "Mega", team: Team.autobot, strength:10, intelligence:1, speed:1, endurance:1, courage: 10, firepower:1, skill: 10)
    func testHighestOverallRating() {
        let result = sut.battle(first: transformerHighRatingMedSkillCourageStrength, second: transformerLowRatingHighSkillCourageStrength)
        XCTAssert(result.winners.first!.id == transformerHighRatingMedSkillCourageStrength.id, "logic failed to determine an overall_rating winner")
        XCTAssert(result.losers.first!.id == transformerLowRatingHighSkillCourageStrength.id, "logic failed to determine an overall_rating loser")
        
    }
    
    // tie both are eliminated
    func testTieRatings() {
        let transformerSameRatingHighSkillCourageStrength = Transformer(name: "Jazz", team: Team.autobot, strength:10, intelligence:1, speed:1, endurance:1, courage: 10, firepower:1, skill: 8)
        let result = sut.battle(first: transformerLowRatingHighSkillCourageStrength, second: transformerSameRatingHighSkillCourageStrength)
        XCTAssert(result.winners.count == 0, "logic failed to determine no winners with same overall_rating")
        XCTAssert(result.losers.map { $0.name }.contains("Mega") && result.losers.map { $0.name }.contains("Jazz"), "logic failed to determine both losers are eliminated if overall_rating is same")
        
    }
    
    // exception. Fighter Oprtimis Prime or Predaking win regardless
    // if both face off with each other or clones everyone loses!
    func testKeyNamesAlwaysWin() {
        // testCheckNoUltimateBattleOccured
        XCTAssert(sut.ultimateShowdownOccured == false, "logic incorrectly thinks Predaking and Optimus has had a showdown?")
        let transformerPredakingWinner = Transformer(name: "Predaking", team: Team.autobot, strength:7, intelligence:10, speed:10, endurance:10, courage:6, firepower:10)
        let transformerOptimusWinner = Transformer(name: "Optimus Prime", team: Team.autobot, strength:7, intelligence:10, speed:10, endurance:10, courage:6, firepower:10)
        let transformerCourageStrengthWinner = Transformer(name: "Jazz", team: Team.autobot, strength:10, intelligence:8, speed:8, endurance:8, courage:10, firepower:8)
        var result = sut.battle(first: transformerOptimusWinner, second: transformerCourageStrengthWinner)
        XCTAssert(result.winners.first!.name == "Optimus Prime", "logic failed to determine key Name Winner Optimus Prime!")
        XCTAssert(result.losers.first!.id == transformerCourageStrengthWinner.id, "logic failed to determine loser against Optimus!?")
        result = sut.battle(first: transformerPredakingWinner, second: transformerCourageStrengthWinner)
        XCTAssert(result.winners.first!.name == "Predaking", "logic failed to determine key Name Winner predaking!")
        XCTAssert(result.losers.first!.id == transformerCourageStrengthWinner.id, "logic failed to determine loser against Predaking!?")
        result = sut.battle(first: transformerPredakingWinner, second: transformerOptimusWinner)
        XCTAssert(result.winners.count == 0, "logic failed to determine no winners if Optimus and Predaking battling each other")
        XCTAssert(result.losers.map { $0.name }.contains("Optimus Prime") && result.losers.map { $0.name }.contains("Predaking"), "logic failed to determine boths losers when Optimus Prime battles against Predaking!?")
        XCTAssert(sut.ultimateShowdownOccured == true, "logic incorrectly thinks Predaking and Optimus have not had a showdown?")
    }
    
    //    battle process, overall logic with two sets of contenders
    //     and est ranking of teams...
    
    let transformerHighSkillCourage = Transformer(name: "Prime", team: Team.autobot, strength: 9, rank:4, courage: 8)
    let transformerLowSkillCourage = Transformer(name: "Bumblebee", team: Team.autobot, strength: 6, rank:8, courage: 4, skill: 3)
    let transformerExtra = Transformer(name: "Ultra Magnus", team: Team.autobot, strength: 6, rank:3, courage: 4, skill: 3)
    let transformerMedSkillCourage = Transformer(name: "Ratchet", team:Team.decepticon, strength: 7, rank:7, courage: 5, skill: 8)
    let transformerLowSkillLoser = Transformer(name: "Wheeljack", team: Team.decepticon, strength:8, intelligence:8, speed:8, endurance:8, rank: 9, firepower:8, skill: 7)
    
    func testRanking() {
        
        let transformerDB1 = [
            "first" : transformerHighSkillCourage,
            "second" : transformerLowSkillCourage,
            "third" : transformerMedSkillCourage,
            "fourth" : transformerLowSkillLoser,
            "fifth" : transformerExtra
        ]
        
        let result = Battle.rankedTeams(transformerDB1)
        XCTAssert(result.autobots.map { $0.name } == ["Bumblebee", "Prime", "Ultra Magnus"], "logic failed to rank autobots correctly")
        XCTAssert(result.decepticons.map { $0.name } == ["Wheeljack", "Ratchet"], "logic failed to rank decepticons correctly")
        
    }
    
    // test Odd ones out don't play
    func testLastOddOnesDontBattle() {
        let transformerDB1 = [
            "first" : transformerHighSkillCourage,
            "second" : transformerLowSkillCourage,
            "third" : transformerMedSkillCourage,
            "fourth" : transformerLowSkillLoser,
            "fifth" : transformerExtra
        ]
        
        let result = sut.battleResults(teams: Battle.rankedTeams(transformerDB1))
        XCTAssert(result.count == 2, "logic failed to only create 2 battles between 4 of 5 opponents")
        
        
        let allContendersNames:[String] = result.compactMap { $0.winners + $0.losers }
            .reduce([], +).map { $0.name }
        XCTAssert(allContendersNames.filter { $0 == "fifth"}.count == 0, "logic failed to ensure that the odd lowest ranked contender wasn't included in the battle")
    }
    
    func testEnoughInTeams() {
        let transformerDB1 = [
            "first" : transformerHighSkillCourage,
            "fifth" : transformerExtra
        ]
        let result = sut.battleResults(teams: Battle.rankedTeams(transformerDB1))
        XCTAssert(result.count == 0, "logic failed to identiify teams were short")

    }
    
    // check battle rules work
    func testWinnerIdentified() {
        let transformerFiller = Transformer(name: "Filler", team: Team.autobot, rank:1)
        let transformerHighCourageStrength = Transformer(name: "Prime", team: Team.decepticon, strength: 9, rank: 2, courage: 8)
        let transformerHighCourageStrengthHighOverallRating = Transformer(name: "Prime", team: Team.autobot, strength: 9, intelligence: 9, endurance: 9, rank: 2, courage: 8, firepower: 9)
        let transformerMedCourageStrengthHighSkill = Transformer(name: "Bumblebee", team: Team.autobot, strength: 8, rank: 2, courage: 6, skill: 8)
        let transformerLowCourageStrength = Transformer(name: "Bumblebee", team: Team.autobot, strength: 6, rank: 2, courage: 4)


        let winningTransformersDB1 = [
            "first" : transformerHighCourageStrength, // should be the winner
            "second" : transformerLowCourageStrength,
            "third" : transformerFiller
        ]
        var rankedTeams = Battle.rankedTeams(winningTransformersDB1)
        var result = sut.battleResults(teams: rankedTeams)
        var winners = result.compactMap { $0.winners }.reduce([], +)
        var losers = result.compactMap { $0.losers }.reduce([], +)
//        print ( rankedTeams.autobots.map { $0.name }.joined(separator: ",") )
//        print ( rankedTeams.decepticons.map{ $0.name }.joined(separator: ",") )
//        print ( winners.map { $0.name }.joined(separator: ",") )
//        print ( losers.map{ $0.name }.joined(separator: ",") )

        var winner = winners.first
        var loser = losers.first
        
        XCTAssert(winner?.name ?? "" == transformerHighCourageStrength.name, "logic failed to identifiy opponent with highest courage/strength")
        XCTAssert(loser?.name == transformerLowCourageStrength.name, "logic failed to identifiy opponent with highest rating when courage/strength weren't enough")
        
        let winningTransformersDB2 = [
            "first" : transformerHighCourageStrength, // should be the winner
            "second" : transformerMedCourageStrengthHighSkill,
            "third" : transformerFiller
        ]
        
        rankedTeams = Battle.rankedTeams(winningTransformersDB2)
        result = sut.battleResults(teams: rankedTeams)
        winners = result.compactMap { $0.winners }.reduce([], +)
        losers = result.compactMap { $0.losers }.reduce([], +)
        winner = winners.first
        loser = losers.first
        XCTAssert(winner?.name ?? "" == transformerMedCourageStrengthHighSkill.name, "logic failed to identifiy opponent with highest courage/strength")
        XCTAssert(loser?.name == transformerHighCourageStrength.name, "logic failed to identifiy opponent with highest rating when courage/strength weren't enough")

        let winningTransformersDB3 = [
            "first" : transformerHighCourageStrength, // should be the winner
            "second" : transformerHighCourageStrengthHighOverallRating,
            "third" : transformerFiller
        ]
        
        rankedTeams = Battle.rankedTeams(winningTransformersDB3)
        result = sut.battleResults(teams: rankedTeams)
        winners = result.compactMap { $0.winners }.reduce([], +)
        losers = result.compactMap { $0.losers }.reduce([], +)
        winner = winners.first
        loser = losers.first
        XCTAssert(winner?.name ?? "" == transformerHighCourageStrengthHighOverallRating.name, "logic failed to identifiy opponent with highest courage/strength")
        XCTAssert(loser?.name == transformerHighCourageStrength.name, "logic failed to identifiy opponent with highest rating when courage/strength weren't enough")

        
        
        let transformerNamedOptimusPrime = Transformer(name: "Optimus Prime", team: Team.autobot, strength: 6, rank: 2, courage: 4)

        let winningTransformersDB4 = [
            "first" : transformerHighCourageStrength, // should be the winner
            "second" : transformerNamedOptimusPrime,
            "third" : transformerFiller
        ]
        
        rankedTeams = Battle.rankedTeams(winningTransformersDB4)
        result = sut.battleResults(teams: rankedTeams)
        winners = result.compactMap { $0.winners }.reduce([], +)
        losers = result.compactMap { $0.losers }.reduce([], +)
        winner = winners.first
        loser = losers.first
        XCTAssert(winner?.name ?? "" == transformerNamedOptimusPrime.name, "logic failed to identifiy opponent with highest courage/strength")
        XCTAssert(loser?.name == transformerHighCourageStrength.name, "logic failed to identifiy opponent with highest rating when courage/strength weren't enough")

        // I would likely add a helper function to easily ceate transformers with certain configs...just to ensure readability.
        
    }
    
    // predaking / optimus fight = all eliminated...
    func testNamedWinnersAllLose() {
    let transformerFiller = Transformer(name: "Filler", team: Team.autobot, rank:1)
    let transformerHighCourageStrength = Transformer(name: "Optimus Prime", team: Team.autobot, strength: 9, rank: 3, courage: 8)
    let transformerHighCourageStrengthHighOverallRating = Transformer(name: "Predaking", team: Team.decepticon, strength: 9, intelligence: 9, endurance: 9, rank: 3, courage: 8, firepower: 9)
        let transformerMedCourageStrengthHighSkill = Transformer(name: "Ratchet", team: Team.decepticon, strength: 8, rank: 2, courage: 6, skill: 8)
        let transformerLowCourageStrength = Transformer(name: "Bumblebee", team: Team.autobot, strength: 6, rank: 2, courage: 4)


    let winningTransformersDB1 = [
        "first" : transformerHighCourageStrength, // should be the winner
        "second" : transformerHighCourageStrengthHighOverallRating,
        "third" : transformerMedCourageStrengthHighSkill,
        "fourth" : transformerMedCourageStrengthHighSkill,
        "fifth" : transformerFiller
    ]
    let rankedTeams = Battle.rankedTeams(winningTransformersDB1)
    var result = sut.battleResults(teams: rankedTeams)
    var winners = result.compactMap { $0.winners }.reduce([], +)
    var losers = result.compactMap { $0.losers }.reduce([], +)

        XCTAssert(winners.count == 0, "logic failed to determine all had lost due to Predaking and Optimus Prime battling")
        XCTAssert(losers.count == winningTransformersDB1.count, "logic failed to place all contenders in the losing stream")
    }
}

extension Transformer {
    
    init(
        name:String,
        team:Team = Team.autobot,
        strength:Int = 1,
        intelligence:Int = 1,
        speed:Int = 1,
        endurance:Int = 1,
        rank:Int = 1,
        courage:Int = 1,
        firepower:Int = 1,
        skill:Int = 1
        ) {
        let ID:String = UUID.init().uuidString

        let newTransformer = Transformer(id: ID, name: name, strength: strength, intelligence: intelligence, speed: speed, endurance: endurance, rank: rank, courage: courage, firepower: firepower, skill: skill, team: team, team_icon: "https://tfwiki.net/mediawiki/images2/archive/f/fe/20110410191732%21Symbol_autobot_reg.png")
        self = newTransformer
    }
    
//    static func makeTransformer(name:String, id:String? = nil, team:Team) -> Transformer {
//        let id:String = id ?? UUID.init().uuidString
//        let jsonTransformer = """
//        {
//        "id": "\(id)", "name": "\(name)", "strength": 10,
//        "intelligence": 10,
//        "speed": 4,
//        "endurance": 8,
//        "rank": 10,
//        "courage": 9,
//        "firepower": 10,
//        "skill": 9,
//        "team": "\(team.rawValue)",
//        "team_icon":
//        "https://tfwiki.net/mediawiki/images2/archive/8/8d/20110410191659%21Symbol_decept_reg.png"
//        }
//        """
//        return Transformer(jsonTransformer)!
//    }


}
