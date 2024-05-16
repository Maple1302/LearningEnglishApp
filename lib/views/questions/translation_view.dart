import 'package:flutter/material.dart';
import 'package:maple/helper/audio_helper.dart';

class TranselateView extends StatefulWidget {
  final String expectedSentence;
  final String missingSentence;
  final String correctanswers;
  const TranselateView(
      {super.key,
      required this.expectedSentence,
      required this.missingSentence,
      required this.correctanswers});

  @override
  State<TranselateView> createState() => _TranselateViewState();
}

class _TranselateViewState extends State<TranselateView> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.only(top: 10, bottom: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Hoàn tất bản dịch",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Expanded(
                          child: Text(
                            widget.expectedSentence,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(

                          color: Colors.grey, // Màu của viền
                          width: 2.0, // Độ rộng của viền
                        ),
                      ),
                      child: Padding(
                        padding:const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(widget.missingSentence,
                                style: const TextStyle(fontSize: 18)),
                            SizedBox(
                              width: 100,
                              height: 30,
                              child: TextField(
                                style: const TextStyle(fontSize: 18),
                                controller: _textEditingController,
                              ),
                            ),
                          ],
                        ),
                      ))),
                      const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  if(widget.correctanswers.toLowerCase() == _textEditingController.text.toLowerCase()){
                      AudioHelper.playSound("correct");
                          showResultDialog("Chính xác!", true);
                  }
                  else{
                       AudioHelper.playSound("incorrect");
                          showResultDialog("Không chính xác!", false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                child: const Text(
                  'KIỂM TRA',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
  void showResultDialog(String message, bool check) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration:
           const Duration(seconds: 100) ,
      content: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: check ? Colors.green : Colors.red, // Nền màu đỏ
                    shape: BoxShape.circle, // Hình tròn
                  ),
                  padding:
                      const EdgeInsets.all(5.0), // Khoảng đệm xung quanh icon
                  child: Icon(
                    check ? Icons.check : Icons.close,
                    color: Colors.white,
                    weight: 10,
                    opticalSize: 10, // Màu của tích X là màu trắng
                    size: 15.0, // Kích thước của icon
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                        color: check ? Colors.green : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            !check?
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Trả lời đúng",
                  style: TextStyle(
                      color: check ? Colors.green : Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )):const SizedBox(),
             !check? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.correctanswers,
                  style: TextStyle(
                    color: check ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                )): const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              
             shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Góc bo tròn của nút
              ),
              shadowColor: Colors.grey, 
                elevation: 6,
                foregroundColor: Colors.white,
                backgroundColor:check? Colors.green: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child:  Text('Tiếp tục'.toUpperCase()),
            )
          ],
        ),
      ),
    ));
  }
@override
  void dispose(){
    super.dispose();
    AudioHelper.disposeAudio();
    AudioHelper.disposeTts();
  }
}
