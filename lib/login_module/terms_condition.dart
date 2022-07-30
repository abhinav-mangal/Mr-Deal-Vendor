import 'package:flutter/material.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';

class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: const TextWidget(
        text:
            "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available. It is also used to temporarily replace text in a process called greeking, which allows designers to consider the form of a webpage or publication, without the meaning of the text influencing the design.\nLorem ipsum is typically a corrupted version of De finibus bonorum et malorum, a 1st-century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.\nVersions of the Lorem ipsum text have been used in typesetting at least since the 1960s, when it was popularized by advertisements for Letraset transfer sheets.[1] Lorem ipsum was introduced to the digital world in the mid-1980s, when Aldus employed it in graphic and word-processing templates for its desktop publishing program PageMaker. Other popular word processors, including Pages and Microsoft Word, have since adopted Lorem ipsum,[2] as have many LaTeX packages,[3][4][5] web content managers such as Joomla! and WordPress, and CSS libraries such as Semantic UI.",
        size: text_size_16,
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
      backgroundColor: theme_color,
      centerTitle: false,
      automaticallyImplyLeading: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: theme_color),
      ),
      title: const TextWidget(
        text: 'Terms and Conditions',
        size: text_size_18,
        color: white_color,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: PreferredSize(
                child: _appbar(), preferredSize: const Size.fromHeight(60)),
            body: SingleChildScrollView(child: _body()),
          )),
    );
  }
}
