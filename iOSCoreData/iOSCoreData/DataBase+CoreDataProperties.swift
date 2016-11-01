//
//  DataBase+CoreDataProperties.swift
//  iOSCoreData
//
//  Created by 黄穆斌 on 16/11/1.
//  Copyright © 2016年 Myron. All rights reserved.
//

import Foundation
import CoreData


extension DataBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataBase> {
        return NSFetchRequest<DataBase>(entityName: "DataBase");
    }


}
