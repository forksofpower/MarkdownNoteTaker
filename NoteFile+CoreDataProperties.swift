//
//  NoteFile+CoreDataProperties.swift
//  MarkdownNoteTaker
//
//  Created by Patrick Jones on 10/4/25.
//
//

public import Foundation
public import CoreData


public typealias NoteFileCoreDataPropertiesSet = NSSet

extension NoteFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteFile> {
        return NSFetchRequest<NoteFile>(entityName: "NoteFile")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var fileName: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var title: String?

}

extension NoteFile : Identifiable {

}
