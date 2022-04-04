//
//  UserSequencesViewModel.swift
//  TDStepSequencer
//
//  Created by Beniamin on 03.04.22.
//

import Foundation
import RealmSwift

class UserSequencesViewModel: ObservableObject {
    
    private(set) var realm: Realm?
    @Published var storedSequences: [StoredSequence] = []
    
    init() {
        getRealm()
        getSequences()
    }

    func getRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch {
            print("Error while opening Realm", error)
        }
    }
    
    private func prepareKeyName() -> String {
        let today = Date()
        let formatter = DateFormatter.dateAndTime
        let keyToStore = "Sequence: " + formatter.string(from: today)
        return keyToStore
    }
    
    func addNewSequence(notesToStore: [Float]) {
        guard let realm = realm else {
            print("realm not available")
            return
        }
        
        do {
            //store the sequence
            try realm.write {
                let realmListNotesSequence = List<Float>()
                for note in notesToStore {
                    realmListNotesSequence.append(note)
                }
                let newSequence = StoredSequence(value: ["sequenceName": prepareKeyName(), "sequence": realmListNotesSequence])
                realm.add(newSequence)
                
                getSequences()
                print("New sequence was added")
            }
        } catch {
            print("Error adding task to Realm: \(error)")
        }
    }
    
    //todoben there are some issues with playing the stored sequences, sometimes the chosen sequence is not played
    func getSequences() {
        guard let realm = realm else {
            print("realm not available")
            return
        }
        
        //read stored sequences and append them to the @Published var
        let allStoredSequences = realm.objects(StoredSequence.self)
        storedSequences = []
        allStoredSequences.forEach { sequence in
            storedSequences.append(sequence)
        }
    }
}
