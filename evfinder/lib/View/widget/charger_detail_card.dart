import 'package:flutter/material.dart';

class ChargerDetailCard extends StatelessWidget {
  const ChargerDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width - 25,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.star, color: Colors.grey)],
              ),

              // Text(station, style: AppTextStyle.koPtBold16()),
              // const SizedBox(height: 5),
              // Text(address, style: AppTextStyle.koPtRegular14()),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(1),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 20), // 내용 영역 주변 여백 제거
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // 텍스트 수직 정렬
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15.0, // leading과 text 사이의 간격
                              child: CircleAvatar(backgroundColor: Colors.white),
                            ),
                            const SizedBox(width: 5),

                            // Text(controller.chgerType(chargerType), style: AppTextStyle.koPtBold14()),
                            // const SizedBox(width: 5),
                            // Text(parkingFree, style: AppTextStyle.koPtBold12grey()),
                          ],
                        ),

                        // remainCharger != null
                        //     ? Padding(
                        //         padding: const EdgeInsets.only(right: 8.0),
                        //         child: Container(
                        //           height: 45,
                        //           width: 45,
                        //           decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(5)),
                        //           child: Column(
                        //             children: [
                        //               const SizedBox(height: 3),
                        //               const Text(
                        //                 "충전가능",
                        //                 style: TextStyle(fontFamily: 'PretendardRegular', fontSize: 10, color: AppColor.grey),
                        //               ),
                        //               const SizedBox(height: 3),
                        //               Row(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Text(
                        //                     remainCharger!,
                        //                     style: const TextStyle(fontFamily: 'PretendardRegular', fontSize: 15, fontWeight: FontWeight.bold, color: AppColor.primary),
                        //                   ),
                        //                   const Text(
                        //                     "/",
                        //                     style: TextStyle(fontFamily: 'PretendardRegular', fontSize: 15, fontWeight: FontWeight.bold, color: AppColor.black),
                        //                   ),
                        //                   Text(
                        //                     totalCharger!,
                        //                     style: const TextStyle(fontFamily: 'PretendardRegular', fontSize: 15, fontWeight: FontWeight.bold, color: AppColor.black),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     : Padding(
                        //         padding: const EdgeInsets.only(right: 16.0),
                        //         child: ChargeChip(name: chargerState!, color: color!),
                        //       ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
