import 'package:flutter/material.dart';
import 'package:maple/helper/audio_helper.dart';

class CompleteConversation extends StatefulWidget {
  final String question;
  final List<String> items;
  final String correctAnswer;

  const CompleteConversation(
      {super.key, required this.question, required this.items, required this.correctAnswer});

  @override
  State<CompleteConversation> createState() => _CompleteConversationState();
}

class _CompleteConversationState extends State<CompleteConversation> {
 
   int selectedIndex = -1;
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
            children: [
              const Text(
                'Hoàn thành hội thoại',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey, width: 3),
                  ),
                  child: SizedBox(
                    width: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Đảm bảo các icon và text được căn chỉnh đúng
                      children: [
                        const Icon(Icons.volume_up, color: Colors.blue,size: 30,),
                        const SizedBox(width: 8),
                        Expanded(
                          // Sử dụng Expanded để Text có thể bọc xuống và không bị cắt ngang
                          child: Text(
                            widget.question,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withBlue(255),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: const SizedBox(
                      width: 100,
                      height: 30,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text("_______________"),
                      )),
                ),
              ),
              const Spacer(),
              ListView.builder(
                shrinkWrap:
                    true, // Đảm bảo ListView chỉ chiếm không gian cần thiết
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        foregroundColor: Colors.black,
                        backgroundColor: selectedIndex == index ? Colors.white.withBlue(255): Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        side:  BorderSide(color: selectedIndex == index ?Colors.green: Colors.grey,width: 3),
                      ),
                      onPressed: () {
                        // Hành động cho từng nút
                        setState(() {
                           selectedIndex = index;
                        });
                         
                      },
                      child: Text(widget.items[index],style: TextStyle(fontSize: 18,color: selectedIndex == index ?Colors.green: Colors.black,)),
                    ),
                  );
                },
              ),
              
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:selectedIndex == -1 ? Colors.grey[300]: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 6,
                  shadowColor: selectedIndex == -1 ? Colors.grey[300]: Colors.green.withOpacity(0.5),
                ),
                onPressed: () {
                  if(widget.items[selectedIndex] == widget.correctAnswer){
                     AudioHelper.playSound("correct");
                    showResultDialog("Chính xác!", true);
                  }
                  else{
                     AudioHelper.playSound("incorrect");
                    showResultDialog("Không chính xác!", false);
                  }
                },
                child:  Text('KIỂM TRA',
                    style: TextStyle(fontSize: 16, color: selectedIndex == -1 ? Colors.black: Colors.white)),
              ),
            ],
          ),
        ));
  }
   void showResultDialog(String message, bool check) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 100),
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
            !check
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Trả lời đúng",
                      style: TextStyle(
                          color: check ? Colors.green : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))
                : const SizedBox(),
            !check
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.correctAnswer,
                      style: TextStyle(
                        color: check ? Colors.green : Colors.red,
                        fontSize: 16,
                      ),
                    ))
                : const SizedBox(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Góc bo tròn của nút
                ),
                shadowColor: Colors.grey,
                elevation: 6,
                foregroundColor: Colors.white,
                backgroundColor: check ? Colors.green : Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text('Tiếp tục'.toUpperCase()),
            )
          ],
        ),
      ),
    ));
  }

  
}
