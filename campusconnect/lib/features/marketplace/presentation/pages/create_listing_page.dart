import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product.dart';
import '../providers/marketplace_provider.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key, this.product});

  final Product? product;

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _categoryId = 'books';
  String _status = 'Available';

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _categoryId = widget.product!.categoryId;
      _status = widget.product!.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketplaceProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Create listing' : 'Edit listing')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoryId,
                items: provider.categories
                    .map((category) => DropdownMenuItem<String>(value: category.id, child: Text(category.name)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _categoryId = value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                items: const [
                  DropdownMenuItem<String>(value: 'Available', child: Text('Available')),
                  DropdownMenuItem<String>(value: 'Reserved', child: Text('Reserved')),
                  DropdownMenuItem<String>(value: 'Sold', child: Text('Sold')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final navigator = Navigator.of(context);
                    await provider.saveProduct(
                      Product(
                        id: widget.product?.id ?? '',
                        title: _titleController.text,
                        description: _descriptionController.text,
                        price: double.tryParse(_priceController.text) ?? 0,
                        categoryId: _categoryId,
                        sellerId: 'seller_1',
                        status: _status,
                        isFavorite: widget.product?.isFavorite ?? false,
                        createdAt: widget.product?.createdAt ?? DateTime.now(),
                      ),
                    );
                    if (mounted) {
                      navigator.pop();
                    }
                  }
                },
                child: const Text('Save listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
