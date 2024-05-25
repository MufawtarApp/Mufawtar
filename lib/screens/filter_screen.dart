import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mufawtar/addInvoice.dart';
import 'package:mufawtar/invoce.dart';

class FilterScreen extends StatefulWidget {
  final List<Invoice> invoices;

  const FilterScreen({Key? key, required this.invoices}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  DateTime? selectedDate;
  String? selectedCompanyName;
  List<Invoice> filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    filteredInvoices = InvoiceManager().invoices;

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _applyFilters();
      });
    }
  }

  Future<void> _selectCompanyName(BuildContext context) async {
    final List<String> companyNames = widget.invoices.map((invoice) => invoice.companyName).toSet().toList();
    final String? selectedName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Company Name'),
          content: SingleChildScrollView(
            child: ListBody(
              children: companyNames.map((name) {
                return GestureDetector(
                  child: Text(name),
                  onTap: () {
                    Navigator.of(context).pop(name);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    if (selectedName != null) {
      setState(() {
        selectedCompanyName = selectedName;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    filteredInvoices = widget.invoices;
    if (selectedDate != null) {
      filteredInvoices = filteredInvoices.where((invoice) {
        final invoiceDate = DateTime.parse(invoice.dateOfTime);
        return invoiceDate.year == selectedDate!.year &&
               invoiceDate.month == selectedDate!.month &&
               invoiceDate.day == selectedDate!.day;
      }).toList();
    }
    if (selectedCompanyName != null) {
      filteredInvoices = filteredInvoices.where((invoice) => invoice.companyName == selectedCompanyName).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Invoices', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Select Date'),
            subtitle: selectedDate != null ? Text(DateFormat('MMM d, yyyy').format(selectedDate!)) : null,
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Select Company Name'),
            subtitle: selectedCompanyName != null ? Text(selectedCompanyName!) : null,
            onTap: () => _selectCompanyName(context),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredInvoices.length,
              itemBuilder: (context, index) {
                final invoice = filteredInvoices[index];
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        invoice.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.business, color: Colors.purple),
                                const SizedBox(width: 8),
                                Text(
                                  invoice.companyName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.attach_money, color: Colors.purple),
                                const SizedBox(width: 8),
                                Text(
                                  'Total Price: ${invoice.totalPrice} US',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.purple),
                                const SizedBox(width: 8),
                                Text(
                                  'Date Of Time: ${DateFormat('MMM d, yyyy hh:mm a').format(DateTime.parse(invoice.dateOfTime))}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}