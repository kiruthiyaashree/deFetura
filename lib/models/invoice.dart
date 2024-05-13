

import 'package:construction/models/architect.dart';
import 'package:construction/models/customer.dart';

class Invoice {
  final InvoiceInfo info;
  final Architect architect;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.architect,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String date;

  const InvoiceInfo({
    required this.date,
  });
}

class InvoiceItem {
  final String itemname;
  final String expense;

  const InvoiceItem({
    required this.itemname,
    required this.expense,
  });
}