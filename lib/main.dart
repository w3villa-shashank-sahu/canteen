import 'package:canteen/payment_page.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      debugShowCheckedModeBanner: false,
      title: 'Canteen',
      home: const MyHomePage(title: 'CANTEEN'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.qr_code_scanner, size: 28),
          label: const Text(
            'Scan QR Code',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          onPressed: () => scan(context),
        ),
      ),
    );
  }

  void scan(BuildContext context) async {
    try {
      // String res = await FlutterBarcodeScanner.scanBarcode(
      //     "#f44336", "cancelButtonText", true, ScanMode.BARCODE);
      var res = await BarcodeScanner.scan();
      debugPrint(res.rawContent);
      if (!context.mounted) return;
      if (res.rawContent.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cancelled by use')),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPayment(id: res.rawContent),
          // builder: (context) => ConfirmPayment(id: "234932"),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      showDialog(context: context, builder: (context) => AlertDialog(content: Text(e.toString())));
    }
  }
}
