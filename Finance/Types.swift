//
//  Types.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 08-02-26.
//

struct UserPermission: Codable {
    let id: Int
    let name: String
}

struct UserGroup: Codable {
    let id: Int
    let name: String
    let permissions: [UserPermission]
}

struct User: Codable {
    let id: Int
    let rut: String
    let name: String
    let creation_date: String
    let expiration: String
    let permissions: [UserPermission]
    let groups: [UserGroup]
}
