import 'package:flutter/material.dart';
import 'package:canteen/models.dart';
import 'package:canteen/backend.dart';

class ConfirmPayment extends StatefulWidget {
  final String id;
  const ConfirmPayment({super.key, required this.id});

  @override
  State<ConfirmPayment> createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  final Backend _backend = Backend();
  Student? _student;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    final student = await _backend.fetchData(widget.id);
    setState(() {
      _student = student;
      _loading = false;
    });
  }

  Future<void> _handlePayment() async {
    setState(() => _loading = true);
    try {
      // await _backend.makePurchase(_student!.id, _student!.totalPrice() );
      // await _backend.makePurchase(_student!.id, _student!.totalPrice());
      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Purchase Success'),
              content: const Icon(Icons.check_circle, color: Colors.green, size: 64),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment failed')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_student == null) {
      return const Scaffold(
        body: Center(child: Text('Error loading student data')),
      );
    }

    final total = _student!.totalPrice();
    final hasEnoughBalance = _student!.balance >= total;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for ${_student!.name}'),
        backgroundColor: Colors.blue  ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.person, size: 48, color: Colors.blue.shade800),
                    Text('#${widget.id}'),
                    Text(
                      'Roll No: ${_student!.rollno}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Products',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _student!.products.length,
                itemBuilder: (context, index) {
                  final product = _student!.products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.fastfood, color: Colors.orange),
                      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Quantity: ${product.quantity}'),
                      trailing: Text(
                        '₹${product.price * product.quantity}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount:', style: TextStyle(fontSize: 16)),
                        Text(
                          '₹$total',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Available Balance:', style: TextStyle(fontSize: 16)),
                        Text(
                          '₹${_student!.balance}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: hasEnoughBalance ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!hasEnoughBalance)
              const Card(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Insufficient balance!',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: hasEnoughBalance ? _handlePayment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.payment, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Confirm Payment', style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}