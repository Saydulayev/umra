//
//  HajjUmrahObligation.swift
//  umra
//
//  Created by Saydulayev on 19.02.25.
//

import Foundation

struct HajjUmrahObligation {
    static func obligationEvidence(bundle: Bundle?) -> String {
        "hajj_umrah_obligation_obligation_evidence".localized(bundle: bundle)
    }

    static func evidenceUmrahObligation(bundle: Bundle?) -> String {
        "hajj_umrah_obligation_evidence_umrah_obligation".localized(bundle: bundle)
    }

    static func concludingEvidence(bundle: Bundle?) -> String {
        "hajj_umrah_obligation_concluding_evidence".localized(bundle: bundle)
    }
}
