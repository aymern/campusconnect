import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../marketplace/data/repositories/marketplace_repository.dart';
import '../../../marketplace/presentation/pages/marketplace_home_page.dart';
import '../../../marketplace/presentation/providers/marketplace_provider.dart';

/// Marketplace feature page.
class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MarketplaceProvider>(
      create: (_) => MarketplaceProvider(
        repository: SqliteMarketplaceRepository(),
      ),
      child: const MarketplaceHomePage(),
    );
  }
}
