import 'package:flutter/material.dart';
import 'package:jobhub_v1/views/common/sized_box_name.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    print('Rishi MADARCHOD');
    return const SizedBox(
      height: 200,
      width: 200,
      child: SizedBoxName(),
    );
  }
}
