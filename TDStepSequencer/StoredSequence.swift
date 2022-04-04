//
//  StoredSequence.swift
//  TDStepSequencer
//
//  Created by Beniamin on 03.04.22.
//

import Foundation
import RealmSwift

class StoredSequence: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId //make random ObjectIds
    @Persisted var sequenceName: String
    @Persisted var sequence: List<Float>
}
