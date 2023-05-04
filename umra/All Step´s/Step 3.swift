//
//  Step 3.swift
//  umra
//
//  Created by Akhmed on 26.01.23.
//

import SwiftUI

struct Step3: View {
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.98108989, green: 0.9316333532, blue: 0.8719255924, alpha: 1))
                .edgesIgnoringSafeArea(.bottom)
        ScrollView {
                VStack {
                    Text("""

Намаз после обхода Каабы.
""")
                    .font(.custom("Lato-Black", size: 26))
                    .foregroundColor(.black)
                    Group {
                        
                        Text("""
    
    Завершив семикратный обход
    Каабы, мужчина прикрывает
    правое плечо. Затем направьтесь к месту стояния Ибрахима
    и произнесите:
    
    """)
                        
                        Text("""
                        وَاتَّخِذُوا مِن مَّقَامِ إِبْرَاهِيمَ مُصَلًّ
                        """)
                        .customTextforSteps()
                        
                        PlayerView(fileName: "13")
                            .padding()
                        
                    }
                    .font(.system(size: 20, weight: .light, design: .serif))
                    .italic()
                    .foregroundColor(.black)
                    
                    Group {
                        Text("""
    
    Ва-ттахизу мим-макъоми Иброhима мусолля
    
    «Изберите же место [стояния] Ибрахима местом моления» (сура 2 «Аль-Бакара = Корова», аят 125).
    
    При возможности за местом
    стояния Ибрахима либо же
    в любом месте Заповедной
    мечети совершите два рак‘ата
    намаза. Не забудьте установить перед собой преграду так, чтобы между вами и этой преградой никто не проходил.
    В первом рак‘ате после суры 1
    «Аль-Фатиха = Открывающая» прочтите суру 109 «АльКяфирун = Неверующие», а во
    втором рак‘ате после суры «АльФатиха» прочтите суру 112
    «Аль-Ихляс = Очищение веры».
    Завершив намаз, отправьтесь
    к источнику с водой Замзам.
    """)
    
                    }
                    .font(.system(size: 20, weight: .light, design: .serif))
                    .italic()
                    .foregroundColor(.black)
                } .padding(.horizontal, 10)
            }
        } 
    }
}
