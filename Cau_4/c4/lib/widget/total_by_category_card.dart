import 'package:flutter/material.dart';

class TotalByCategoryCard extends StatelessWidget {
  const TotalByCategoryCard({
    super.key,
    required this.totals,
  });

  final Map<String, double> totals;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng tiền theo category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (totals.isEmpty)
              const Text('Chưa có dữ liệu')
            else
              ...totals.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${entry.key}: ${entry.value.toStringAsFixed(0)} đ',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
