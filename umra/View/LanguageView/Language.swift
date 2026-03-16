//
//  Language.swift
//  umra
//
//  Created by Saydulayev on 03.12.24.
//

struct Language: Identifiable {
    let code: String
    let title: String
    var id: String { code }
}
