import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
import '../../menu/data/menu_repository.dart';
import '../../menu/screens/item_detail_screen.dart';
import '../../menu/widgets/menu_item_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({required this.repository, super.key});

  final MenuRepository repository;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = widget.repository.search(_query);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Menu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.contentInset),
            child: TextField(
              key: const Key('menu-search-field'),
              controller: _queryController,
              onChanged: (query) => setState(() => _query = query),
              decoration: InputDecoration(
                labelText: 'Search menu',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        key: const Key('clear-search'),
                        tooltip: 'Clear search',
                        onPressed: () {
                          _queryController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.surface),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentInset,
              0,
              AppSpacing.contentInset,
              AppSpacing.compact,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${results.length} items',
                key: const Key('search-result-count'),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF73788A)),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('No menu items match your search.'))
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.contentInset,
                    ),
                    children: [
                      for (final item in results)
                        MenuItemCard(
                          item: item,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ItemDetailScreen(
                                  repository: widget.repository,
                                  itemId: item.id,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
