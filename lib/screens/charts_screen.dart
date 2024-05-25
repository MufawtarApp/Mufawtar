import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mufawtar/addInvoice.dart';
import 'package:mufawtar/invoce.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String selectedFilter = 'companyName';
  DateTime? selectedDate;
  String? selectedCompanyName;
  int? selectedMonth;
  int? selectedYear;

  // Create chart data for spending by company name
  List<charts.Series<CompanySpending, String>> createCompanyNameChartData() {
    List<Invoice> filteredInvoices = InvoiceManager().invoices;

    if (selectedCompanyName != null) {
      filteredInvoices = filteredInvoices
          .where((invoice) => invoice.companyName == selectedCompanyName)
          .toList();
    }

    if (selectedDate != null) {
      filteredInvoices = filteredInvoices.where((invoice) {
        final invoiceDate = DateTime.parse(invoice.dateOfTime);
        return invoiceDate.year == selectedDate!.year &&
            invoiceDate.month == selectedDate!.month &&
            invoiceDate.day == selectedDate!.day;
      }).toList();
    }

    // Group invoices by company name and calculate total spending
    Map<String, double> spendingByCompany = {};
    for (var invoice in filteredInvoices) {
      if (spendingByCompany.containsKey(invoice.companyName)) {
        spendingByCompany[invoice.companyName] =
            spendingByCompany[invoice.companyName]! +
                double.parse(invoice.totalPrice);
      } else {
        spendingByCompany[invoice.companyName] =
            double.parse(invoice.totalPrice);
      }
    }

    // Convert spending data to chart series
    List<CompanySpending> data = spendingByCompany.entries
        .map((entry) => CompanySpending(entry.key, entry.value))
        .toList();

    return [
      charts.Series<CompanySpending, String>(
        id: 'Spending',
        domainFn: (spending, _) => spending.companyName,
        measureFn: (spending, _) => spending.amount,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.purple.withOpacity(0.5)),
        labelAccessorFn: (CompanySpending spending, _) =>
            '${spending.companyName}\n\$${spending.amount.toStringAsFixed(2)}',
      )
    ];
  }

  // Create chart data for spending by month/year
  List<charts.Series<MonthYearSpending, String>> createMonthYearChartData() {
    Map<String, double> spendingByMonth = {};

    List<Invoice> filteredInvoices = InvoiceManager().invoices;

    if (selectedMonth != null && selectedYear != null) {
      filteredInvoices = filteredInvoices.where((invoice) {
        final invoiceDate = DateTime.parse(invoice.dateOfTime);
        return invoiceDate.year == selectedYear &&
            invoiceDate.month == selectedMonth;
      }).toList();
    }

    for (var invoice in filteredInvoices) {
      final invoiceDate = DateTime.parse(invoice.dateOfTime);
      final monthYear = DateFormat('MMM y').format(invoiceDate);

      if (spendingByMonth.containsKey(monthYear)) {
        spendingByMonth[monthYear] =
            spendingByMonth[monthYear]! + double.parse(invoice.totalPrice);
      } else {
        spendingByMonth[monthYear] = double.parse(invoice.totalPrice);
      }
    }

    List<MonthYearSpending> data = spendingByMonth.entries
        .map((entry) => MonthYearSpending(entry.key, entry.value))
        .toList();

    return [
      charts.Series<MonthYearSpending, String>(
        id: 'Spending',
        domainFn: (spending, _) => spending.monthYear,
        measureFn: (spending, _) => spending.amount,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.purple.withOpacity(0.5)),
        labelAccessorFn: (MonthYearSpending spending, _) =>
            '${spending.monthYear}\n\$${spending.amount.toStringAsFixed(2)}',
      )
    ];
  }

  // Create chart data for spending by company
  List<charts.Series<CompanySpending, String>>
      createSpendingByCompanyChartData() {
    Map<String, double> spendingByCompany = {};

    for (var invoice in InvoiceManager().invoices) {
      if (spendingByCompany.containsKey(invoice.companyName)) {
        spendingByCompany[invoice.companyName] =
            spendingByCompany[invoice.companyName]! +
                double.parse(invoice.totalPrice);
      } else {
        spendingByCompany[invoice.companyName] =
            double.parse(invoice.totalPrice);
      }
    }

    List<CompanySpending> data = spendingByCompany.entries
        .map((entry) => CompanySpending(entry.key, entry.value))
        .toList();

    return [
      charts.Series<CompanySpending, String>(
        id: 'Spending by Company',
        domainFn: (spending, _) => spending.companyName,
        measureFn: (spending, _) => spending.amount,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.purple.withOpacity(0.5)),
        labelAccessorFn: (CompanySpending spending, _) =>
            '${spending.companyName}\n\$${spending.amount.toStringAsFixed(2)}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Filter by:'),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'companyName',
                          child: Text('Company Name'),
                        ),
                        DropdownMenuItem(
                          value: 'monthYear',
                          child: Text('Month/Year'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    if (selectedFilter == 'companyName')
                      DropdownButton<String>(
                        value: selectedCompanyName,
                        onChanged: (value) {
                          setState(() {
                            selectedCompanyName = value;
                          });
                        },
                        items: InvoiceManager()
                            .invoices
                            .map((invoice) => invoice.companyName)
                            .toSet()
                            .map((companyName) => DropdownMenuItem(
                                  value: companyName,
                                  child: Text(companyName),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
              if (selectedFilter == 'companyName')
                Column(
                  children: [
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : 'Select Date'),
                    ),
                  ],
                ),
              if (selectedFilter == 'monthYear')
                Column(
                  children: [
                    DropdownButton<int>(
                      value: selectedMonth,
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value;
                        });
                      },
                      items: List.generate(12, (index) => index + 1)
                          .map((month) => DropdownMenuItem(
                                value: month,
                                child: Text(DateFormat('MMMM')
                                    .format(DateTime(2000, month))),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<int>(
                      value: selectedYear,
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value;
                        });
                      },
                      items: List.generate(
                              DateTime.now().year - 1999, (index) => 2000 + index)
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (selectedFilter == 'companyName')
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: 400,
                    child: charts.BarChart(
                      createCompanyNameChartData(),
                      animate: true,
                      vertical: false,
                      barRendererDecorator: charts.BarLabelDecorator<String>(),
                      domainAxis: const charts.OrdinalAxisSpec(
                        renderSpec: charts.NoneRenderSpec(),
                      ),
                    ),
                  ),
                ),
              if (selectedFilter == 'monthYear')
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: 400,
                    child: charts.BarChart(
                      createMonthYearChartData(),
                      animate: true,
                      vertical: false,
                      barRendererDecorator: charts.BarLabelDecorator<String>(),
                      domainAxis: const charts.OrdinalAxisSpec(
                        renderSpec: charts.NoneRenderSpec(),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                'Spending by Company',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: 400,
                  child: charts.BarChart(
                    createSpendingByCompanyChartData(),
                    animate: true,
                    vertical: false,
                    barRendererDecorator: charts.BarLabelDecorator<String>(),
                    domainAxis: const charts.OrdinalAxisSpec(
                      renderSpec: charts.NoneRenderSpec(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (value) {
          if (value == 0) {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('loginScreen');
          } else if (value == 1) {
            Navigator.of(context).pushReplacementNamed('homeScreen');
          } else if (value == 2) {
            Navigator.of(context).pushReplacementNamed('listInvoicesScreen');
          } else if (value == 3) {
            Navigator.of(context).pushReplacementNamed('chartsScreen');
          } else {
            Navigator.of(context).pushReplacementNamed('homeScreen');
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Log Out',
            icon: Icon(Icons.logout),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'List invoices',
            icon: Icon(Icons.receipt),
          ),
          BottomNavigationBarItem(
            label: 'Summary',
            icon: Icon(Icons.bar_chart),
          ),
        ],
      ),
    );
  }
}

class MonthYearSpending {
  final String monthYear;
  final double amount;

  MonthYearSpending(this.monthYear, this.amount);
}

class CompanySpending {
  final String companyName;
  final double amount;

  CompanySpending(this.companyName, this.amount);
}
