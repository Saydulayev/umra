//
//  JanazaPrayerGuide.swift
//  umra
//
//  Created by Saydulayev on 17.09.24.
//

import Foundation

// MARK: - Руководство по джаназа-намазу
struct JanazaPrayerGuide {
    static func title(bundle: Bundle?) -> String {
        "title_janaza_guide".localized(bundle: bundle)
    }

    static func basicRules(bundle: Bundle?) -> String {
        "basic_rules".localized(bundle: bundle)
    }

    static func janazaBasicRules(bundle: Bundle?) -> String {
        "janaza_basic_rules".localized(bundle: bundle)
    }

    static func firstTakbirTitle(bundle: Bundle?) -> String {
        "first_takbir_title".localized(bundle: bundle)
    }

    static func firstTakbirText(bundle: Bundle?) -> String {
        "first_takbir_text".localized(bundle: bundle)
    }

    static func secondTakbirTitle(bundle: Bundle?) -> String {
        "second_takbir_title".localized(bundle: bundle)
    }

    static func secondTakbirText(bundle: Bundle?) -> String {
        "second_takbir_text".localized(bundle: bundle)
    }

    static func translateSecondTakbirText(bundle: Bundle?) -> String {
        "translate_second_takbir_text".localized(bundle: bundle)
    }

    static func thirdTakbirTitle(bundle: Bundle?) -> String {
        "third_takbir_title".localized(bundle: bundle)
    }

    static func thirdTakbirText(bundle: Bundle?) -> String {
        "third_takbir_text".localized(bundle: bundle)
    }

    static func translateThirdTakbirText(bundle: Bundle?) -> String {
        "translate_third_takbir_text".localized(bundle: bundle)
    }

    static func duaVariationsTitle(bundle: Bundle?) -> String {
        "dua_variations_title".localized(bundle: bundle)
    }

    static func duaVariationsText(bundle: Bundle?) -> String {
        "dua_variations_text".localized(bundle: bundle)
    }

    static func fourthTakbirTitle(bundle: Bundle?) -> String {
        "fourth_takbir_title".localized(bundle: bundle)
    }

    static func fourthTakbirText(bundle: Bundle?) -> String {
        "fourth_takbir_text".localized(bundle: bundle)
    }

    static func fourthTakbirAdditionalInfo(bundle: Bundle?) -> String {
        "fourth_takbir_additional_info".localized(bundle: bundle)
    }

    static func taslimTitle(bundle: Bundle?) -> String {
        "taslim_title".localized(bundle: bundle)
    }

    static func taslimText(bundle: Bundle?) -> String {
        "taslim_text".localized(bundle: bundle)
    }
}
