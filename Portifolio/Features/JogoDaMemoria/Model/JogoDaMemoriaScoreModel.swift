//
//  JogoDaMemoriaScoreModel.swift
//  Portifolio
//
//  Created by Bruno Soares on 24/07/20.
//  Copyright © 2020 Bruno Vieira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class JogoDaMemoriaScoreModel {
    
    private var context: NSManagedObjectContext = {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        return context ?? AppDelegate().persistentContainer.viewContext
    }()
    
    func saveNewScore(player: String?, dateScore: Date?, minute: Int?, second: Int?) {

        let newScore = NSEntityDescription.insertNewObject(forEntityName: "JogoDaMemoriaScore", into: self.context) as? JogoDaMemoriaScore
        
        newScore?.date = dateScore
        newScore?.player = player
        newScore?.minute = Int64(minute ?? 0)
        newScore?.second = Int64(second ?? 0)
        
        try? self.context.save()
    }
    
    func fetchAllScores() -> [JogoDaMemoriaScore] {
        let fetchParam = NSFetchRequest<NSFetchRequestResult>(entityName: "JogoDaMemoriaScore")
        fetchParam.sortDescriptors = [NSSortDescriptor(key: "minute", ascending: true),
                                 NSSortDescriptor(key: "second", ascending: true)]
        fetchParam.fetchLimit = 10
        return (try? self.context.fetch(fetchParam) as? [JogoDaMemoriaScore]) ?? []
    }
    
    func fetchfirstThreePlacesScore() -> [JogoDaMemoriaScore] {
        let fetchParam = NSFetchRequest<NSFetchRequestResult>(entityName: "JogoDaMemoriaScore")
        fetchParam.sortDescriptors = [NSSortDescriptor(key: "minute", ascending: true),
                                 NSSortDescriptor(key: "second", ascending: true)]
        fetchParam.fetchLimit = 3
        return (try? self.context.fetch(fetchParam) as? [JogoDaMemoriaScore]) ?? []
    }
}
