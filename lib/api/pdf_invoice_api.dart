import 'dart:io';

import 'package:construction/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../models/architect.dart';
import '../models/customer.dart';
import '../models/invoice.dart';

class PDFInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(invoice),
          buildTitle(invoice),
          buildInvoice(invoice),
        ],
      ),
    );

    return PdfApi.saveDocument(name: 'Expenses.pdf', pdf: pdf);
  }

  static Widget buildTitle(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Text(
        'Expenses List',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      // Text(invoice.info.date),
      // SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );

  static Widget buildArchitectAddress(Architect architect) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(architect.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(architect.address),
    ],
  );

  static Widget buildCustomerAddress(Customer customer) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
      Text(customer.address),
    ],
  );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Item name', 'Expense'];

    // Check if invoice items is empty
    if (invoice.items.isEmpty) {
      return Text('Credited Amount', style: TextStyle(color: PdfColors.red));
    }

    final data = invoice.items.map((item) {
      // Check if the item name is "Credited Amount" and set its style accordingly
      final textColor = item.itemname == 'Credited Amount' ? PdfColors.red : PdfColors.black;

      return [
        Text(item.itemname, style: TextStyle(color: textColor)),
        Text(item.expense, style: TextStyle(color: textColor)),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
      },
    );
  }

  static Widget buildHeader(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildArchitectAddress(invoice.architect),
        ],
      ),
      SizedBox(height: 1 * PdfPageFormat.cm),

      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCustomerAddress(invoice.customer),
          buildInvoiceInfo(invoice.info),
        ],
      ),
    ],
  );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = ['Date:'];
    final data = [info.date];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
