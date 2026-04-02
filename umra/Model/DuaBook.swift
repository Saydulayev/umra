//
//  DuaBook.swift
//  umra
//

import Foundation

// MARK: - Dua Model

struct Dua: Identifiable, Hashable, Sendable {
    let id: String
    let arabic: String
    let transliteration: String
    let titleKey: String
    let translationKey: String
    let audioFile: String?

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Dua, rhs: Dua) -> Bool { lhs.id == rhs.id }
}

struct DuaCategory: Identifiable, Hashable, Sendable {
    let id: String
    let titleKey: String
    let sfSymbol: String
    let duas: [Dua]

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: DuaCategory, rhs: DuaCategory) -> Bool { lhs.id == rhs.id }
}

// MARK: - Data

enum DuaBookData {

    static let categories: [DuaCategory] = [umrahCategory, hajjCategory]

    // MARK: Umrah

    static let umrahCategory = DuaCategory(
        id: "umrah",
        titleKey: "dua_category_umrah",
        sfSymbol: "u.circle.fill",
        duas: [
            Dua(
                id: "niyyah_umrah",
                arabic: "لَبَّيْكَ اللَّهُمَّ بِعُمْرَةَ",
                transliteration: "Labbayka Allāhumma bi-ʿumrah",
                titleKey: "dua_niyyah_umrah_title",
                translationKey: "dua_niyyah_umrah_trans",
                audioFile: "1"
            ),
            Dua(
                id: "ihram_umrah",
                arabic: "اَللَّهُمَّ هَذِهِ عُمْرَةٌ لَا رِيَاءَ فِيهَا وَلَا سُمْعَةَ",
                transliteration: "Allāhumma hādhihi ʿumratun lā riyāʾa fī-hā wa lā sumʿah",
                titleKey: "dua_ihram_umrah_title",
                translationKey: "dua_ihram_umrah_trans",
                audioFile: "2"
            ),
            Dua(
                id: "talbiyah",
                arabic: "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ،\nإِنَّ الْحَمْدَ، وَالنِّعْمَةَ، لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ",
                transliteration: "Labbayka Allāhumma labbayk! Labbayka lā sharīka laka labbayk!\nInna l-ḥamda, wa n-niʿmata, laka wa l-mulk, lā sharīka lak",
                titleKey: "dua_talbiyah_title",
                translationKey: "dua_talbiyah_trans",
                audioFile: "3"
            ),
            Dua(
                id: "masjid_enter",
                arabic: "اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَسَلِّمْ،\nاَللَّهُمَّ افْتَحْ لِي اَبْوَابَ رَحْمَتِكَ",
                transliteration: "Allāhumma ṣalli ʿalā Muḥammadin wa sallim!\nAllāhumma ftaḥ lī abwāba raḥmatik",
                titleKey: "dua_masjid_enter_title",
                translationKey: "dua_masjid_enter_trans",
                audioFile: "4"
            ),
            Dua(
                id: "condition",
                arabic: "اَللَّهُمَّ مَحِلِّي حَيْثُ حَبَسْتَنِي",
                transliteration: "Allāhumma maḥillī ḥaythu ḥabastanī",
                titleKey: "dua_condition_title",
                translationKey: "dua_condition_trans",
                audioFile: "5"
            ),
            Dua(
                id: "rabbana_atina",
                arabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً\nوَقِنَا عَذَابَ النَّارِ",
                transliteration: "Rabbanā ātinā fi d-dunyā ḥasanatan wa fi l-ākhirati ḥasanatan\nwa qinā ʿadhāba n-nār",
                titleKey: "dua_rabbana_title",
                translationKey: "dua_rabbana_trans",
                audioFile: "7"
            ),
            Dua(
                id: "maqam_ibrahim",
                arabic: "وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّى",
                transliteration: "Wa-ttakhidhū min maqāmi Ibrāhīma muṣallā",
                titleKey: "dua_maqam_ibrahim_title",
                translationKey: "dua_maqam_ibrahim_trans",
                audioFile: "13"
            ),
            Dua(
                id: "safa_ayah",
                arabic: "إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللهِ ۖ فَمَنْ حَجَّ الْبَيْتَ أَوِ اعْتَمَرَ\nفَلَا جُنَاحَ عَلَيْهِ أَنْ يَطَّوَّفَ بِهِمَا ۚ وَمَنْ تَطَوَّعَ خَيْرًا\nفَإِنَّ اللهَ شَاكِرٌ عَلِيمٌ",
                transliteration: "Inna ṣ-Ṣafā wa l-Marwata min shaʿāʾiri Llāh, fa-man ḥajja l-bayta\nawi ʿtamara fa-lā junāḥa ʿalayhi an yaṭṭawwafa bi-himā,\nwa man taṭawwaʿa khayran fa-inna Llāha shākirun ʿalīm",
                titleKey: "dua_safa_ayah_title",
                translationKey: "dua_safa_ayah_trans",
                audioFile: "8"
            ),
            Dua(
                id: "nabdau",
                arabic: "نَبْدَأُ بِمَا بَدَأَ اللهُ بِهِ",
                transliteration: "Nabdaʾu bi-mā badaʾa Llāhu bihi",
                titleKey: "dua_nabdau_title",
                translationKey: "dua_nabdau_trans",
                audioFile: "9"
            ),
            Dua(
                id: "zikr_safa",
                arabic: "اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ،\nلٰا إِلَهَ إِلَّا اللهُ وَحْدَهُ لٰا شَرِيكَ لَهُ،\nلَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، يُحْيِي وَيُمِيتُ،\nوَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ،\nلَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ،\nأَنْجَزَ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ",
                transliteration: "Allāhu Akbar! Allāhu Akbar! Allāhu Akbar!\nLā ilāha illa Llāhu waḥdahu lā sharīka lahu,\nlahu l-mulku wa lahu l-ḥamdu, yuḥyī wa yumītu,\nwa huwa ʿalā kulli shayʾin qadīr.\nLā ilāha illa Llāhu waḥdahu lā sharīka lahu,\nanjaza waʿdahu, wa naṣara ʿabdahu, wa hazama l-aḥzāba waḥdah",
                titleKey: "dua_zikr_safa_title",
                translationKey: "dua_zikr_safa_trans",
                audioFile: "10"
            ),
            Dua(
                id: "rabbi_ighfir",
                arabic: "رَبِّ اغْفِرْ وَارْحَمْ، إِنَّكَ أَنْتَ الْأَعَزُّ الْأَكْرَمُ",
                transliteration: "Rabbi ghfir wa rḥam, innaka anta l-Aʿazzu l-Akram",
                titleKey: "dua_rabbi_ighfir_title",
                translationKey: "dua_rabbi_ighfir_trans",
                audioFile: "11"
            ),
            Dua(
                id: "masjid_exit",
                arabic: "اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَسَلِّمْ،\nاَللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ",
                transliteration: "Allāhumma ṣalli ʿalā Muḥammadin wa sallim!\nAllāhumma innī asʾaluka min faḍlik",
                titleKey: "dua_masjid_exit_title",
                translationKey: "dua_masjid_exit_trans",
                audioFile: "12"
            ),
        ]
    )

    // MARK: Hajj

    static let hajjCategory = DuaCategory(
        id: "hajj",
        titleKey: "dua_category_hajj",
        sfSymbol: "h.circle.fill",
        duas: [
            Dua(
                id: "niyyah_hajj",
                arabic: "لَبَّيْكَ اللَّهُمَّ بِحَجٍّ",
                transliteration: "Labbayka Allāhumma bi-ḥajj",
                titleKey: "dua_niyyah_hajj_title",
                translationKey: "hajj_step1_ihram_translation",
                audioFile: "14"
            ),
            Dua(
                id: "ihram_hajj",
                arabic: "اللَّهُمَّ هَذِهِ حِجَّةٌ لَا رِيَاءَ فِيهَا وَلَا سُمْعَةَ",
                transliteration: "Allāhumma hādhihi ḥijjatun lā riyāʾa fī-hā wa lā sumʿah",
                titleKey: "dua_ihram_hajj_title",
                translationKey: "hajj_step1_ihram_dua_translation",
                audioFile: "15"
            ),
            Dua(
                id: "talbiyah_hajj",
                arabic: "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ،\nإِنَّ الْحَمْدَ، وَالنِّعْمَةَ، لَكَ وَالْمُلْكَ، لاَ شَرِيكَ لَكَ",
                transliteration: "Labbayka Allāhumma labbayk! Labbayka lā sharīka laka labbayk!\nInna l-ḥamda, wa n-niʿmata, laka wa l-mulk, lā sharīka lak",
                titleKey: "dua_talbiyah_title",
                translationKey: "dua_talbiyah_trans",
                audioFile: "3"
            ),
            Dua(
                id: "arafat",
                arabic: "لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ،\nلَهُ الْمُلْكُ وَلَهُ الْحَمْدُ،\nوَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
                transliteration: "Lā ilāha illa Llāhu waḥdahu lā sharīka lahu,\nlahu l-mulku wa lahu l-ḥamdu,\nwa huwa ʿalā kulli shayʾin qadīr",
                titleKey: "dua_arafat_title",
                translationKey: "hajj_step2_dua_translation",
                audioFile: "16"
            ),
        ]
    )
}
