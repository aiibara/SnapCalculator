//
//  FileManagerDataManager.swift
//  SnapCalculator
//
//  Created by Widya Limarto on 07/02/23.
//

import Foundation

class FileManagerDataManager: DataManagerProtocol {
    
    static let shared = FileManagerDataManager()
    let fileName = "expressions.json"
    let folderName = "com.mp.snapcalculator"
    
    init() {
        createFolderIfNotExist()
    }
    
    func save(expression: Expression) -> Result<String, Error> {
        let encoder = PropertyListEncoder()
        
        let getDataResult = getData()
        var expressions: [Expression] = []
        
        switch(getDataResult) {
            case .success(let exps):
                expressions.append(contentsOf: exps)
            case .failure(let error):
                print("failed to get data \(error)")
                break
        }
        
        expressions.append(expression)
        
        guard let path: URL = getFilePath()
        else { return .failure(DataError.pathError)}
        
        do {
            let data = try encoder.encode(expressions)
            try data.write(to: path, options: .completeFileProtection)
            return .success("Success saved data")
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func getData() -> Result<[Expression], Error> {
        let decoder = PropertyListDecoder()
        
        guard let path: URL = getFilePath(), FileManager.default.fileExists(atPath: path.path)
        else { return .failure(DataError.pathError)}
        print(path.path)
        do {
            let data = try Data(contentsOf: path)
            let result = try decoder.decode([Expression].self, from: data)
            
            return .success(result)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    func removeData() -> Result<String, Error> {
        guard let path: URL = getFilePath(), FileManager.default.fileExists(atPath: path.path)
        else { return .failure(DataError.pathError)}
        
        do {
            try FileManager.default.removeItem(at: path)
            return .success("file deleted")
        } catch let error {
            return .failure(error)
        }
        
    }
    
    func getFilePath() -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .appendingPathComponent(fileName)
        else { return nil }
        return path
    }
    
    func createFolderIfNotExist() {
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName).path
        else {
            fatalError("unable to get folder path")
        }
                
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
                print("success creating folder")
            } catch let error {
                fatalError("unable to get folder path \(error.localizedDescription)")
            }
        }
    }
    
}
