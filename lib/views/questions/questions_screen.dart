import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:maple/utils/constants.dart';
import 'package:maple/views/questions/answers_card.dart';
import 'package:maple/views/questions/complete_conversation.dart';
import 'package:maple/views/questions/image_card_check.dart';
import 'package:maple/views/questions/listening_screen.dart';
import 'package:maple/views/questions/matching_pair_screen.dart';
import 'package:maple/views/questions/speech_check.dart';
import 'package:maple/views/questions/background_decoration.dart';
import 'package:maple/views/questions/transerlationscreen.dart';
import 'package:maple/views/questions/translation_view.dart';


class QuestionsScreen extends StatelessWidget {
  final List<Map<String, String>> items = [
    {'image': 'images/restaurant.png', 'text': 'kem', 'mean': 'ice cream'},
    {'image': 'images/crown.png', 'text': 'em bé', 'mean': 'baby'},
    {
      'image': 'images/easter-egg_colorful.png',
      'text': 'màu vàng',
      'mean': 'yellow'
    },
    {'image': 'images/gem.png', 'text': 'sô-cô-la', 'mean': 'socola'},
  ];
  final List<String> itemsConversation = [
    'Yes, He is Tommy',
    'Yes, that\'s my younger brother.',
  ];
  final List<String> itemsWord = [
    'Flew',
    'Flow',
  ];
  final List<Map<String, String>> itemMatchPair = [
   
    {'mean': 'em bé', 'text': 'baby'},
    {'text': 'em bé', 'mean': 'baby'},
    {'mean': 'kem', 'text': 'ice cream'},
    {'text': 'màu vàng', 'mean': 'yellow'},
    {'mean': 'sô-cô-la', 'text': 'socola'},
    {'text': 'sô-cô-la', 'mean': 'socola'},
    {'mean': 'màu vàng', 'text': 'yellow'}, 
    {'text': 'kem', 'mean': 'ice cream'},
  ];
  //final List<String> itemsTranslate =['Hello']
  final Map<String,String> questionConversation = {'text':'Is that boy your brother, Lisa?','mean':'Đây là bạn trai của con có phải không Lisa?'};
    final Map<String,String> correctAnswerConversation = {'text':'Yes, He is Tommy','mean':'Vâng, Anh ấy là Tommy'};
  QuestionsScreen({super.key});
  static String routeName = "/questionScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Loại bỏ bóng mờ của AppBar
        bottom: PreferredSize(
          preferredSize: const Size.square(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, width: 3), // Viền trắng
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FAProgressBar(
                      currentValue: 80,
                      displayText: '%',
                      backgroundColor:
                          Colors.transparent, // Xóa nền của thanh tiến trình
                      borderRadius: BorderRadius.circular(
                          6), // Làm tròn góc của progress bar bên trong
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 30,
                    )),
                const Padding(
                  padding: EdgeInsets.all(0.5),
                  child: Text(
                    '1',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body:    BackgroundDecoration(
        child: Center(
            child:  CompleteConversation(question: questionConversation, items: itemsConversation,correctAnswer: correctAnswerConversation)  /*
                
           TranslationScreen(answers: ['Hello',"What's",'your','have','am','name?',], question: "Hello, What's your name?", mean:"Xin chào, tên bạn là gì?", type: transerlateRead,)
       
           MatchingPairScreen(items: itemMatchPair,type:matchingword)
           ListenScreen(
          items: itemsWord,
          correctAnswer: 'Flow',)  
          
          CompleteConversation(question:  'Is that boy your brother, Lisa?', items: itemsConversation,correctAnswer: 'Yes, it\'s next to the big university.')
           
           ImageSelectionScreen(expectedWord: 'ice cream', correctAnswer: 'kem', items:items ,)
             
         PronunciationCheckView( sampleText: "Hello, What's your name?", mean: 'Xin chào, Bạn tên gì?',),
                
            
  TranselateView(expectedSentence: 'Vâng, tôi muốn hai chiếc Pizza', missingSentence: 'Yes,I would like to ', correctanswers: 'pizzas',)
        
         CardAnswer(
                question: "hodhfishfisdjofsoidfois jofojsdofjsoi",
                correctAnswer: "hello",
                answers: [
              "hi",
              "hello",
              "good",
              "too much"
            ])
           */ //DONE

           
                   /*  
           
           
              */ /* */
            ),
      ),
    );
  }
}

