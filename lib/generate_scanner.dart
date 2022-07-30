import 'package:flutter/material.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/wallet_module/wallet_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'common_widgets/font_size.dart';

class GenerateQR extends StatefulWidget {
  final WalletModel? walletModelResp;
  const GenerateQR({Key? key, required this.walletModelResp}) : super(key: key);

  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  String qrData = '';

  @override
  void initState() {
    super.initState();
    qrData = MrDealGlobals.userContact;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _appbar() {
    return AppBar(
      backgroundColor: theme_color,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
        ),
      ),
      title: const TextWidget(
        text: 'MR DEAL QR',
        size: text_size_18,
        color: white_color,
      ),
    );
  }

  Widget _totalPnts() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'Total points',
            size: text_size_18,
            weight: FontWeight.w500,
            alignment: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: theme_color,
                size: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              TextWidget(
                text: (widget.walletModelResp?.data?.length ?? 0) > 0
                    ? '${widget.walletModelResp?.data?[0].shopDetails?.points ?? MrDealGlobals.vendorPnts}'
                    : '0',
                size: text_size_30,
                weight: FontWeight.w600,
                alignment: TextAlign.center,
                color: theme_color,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const TextWidget(
            text: 'MR DEAL Points',
            size: text_size_16,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: _appbar(), preferredSize: const Size.fromHeight(60)),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _totalPnts(),
              const Divider(
                endIndent: 20,
                indent: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              const TextWidget(
                text: 'Scan MR DEAL code',
                size: text_size_22,
                weight: FontWeight.w500,
                alignment: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
                padding: const EdgeInsets.all(10),
                height: 200,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 0.8, color: shadow_color)),
                child: QrImage(data: qrData),
              ),
              const SizedBox(
                height: 20,
              ),
              const TextWidget(
                text: 'Show this QR code to user to\ncollect MR DEAL point',
                size: text_size_18,
                weight: FontWeight.w500,
                alignment: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
