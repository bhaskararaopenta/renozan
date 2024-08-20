import 'package:app/core/base_provider.dart';
import 'package:app/core/ui/body_below_app_bar_widget.dart';
import 'package:app/core/ui/custom_snackbars.dart';
import 'package:app/core/ui/empty_body_progress_indicator.dart';
import 'package:app/services/service_locator.dart';
import 'package:app/template/page_with_api_data/page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ProductsViewModel>()..fetchProducts(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Consumer<ProductsViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.getState) {
              case ViewState.loading:
                return const BodyBelowAppBarWidget(
                    child: EmptyBodyProgressIndicatorWidget());
              case ViewState.done:
                return BodyBelowAppBarWidget(child: _body(viewModel));
              case ViewState.error:
                showCustomSnackBar(context, viewModel.errorMessage);
                return BodyBelowAppBarWidget(child: _body(viewModel));
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Padding _body(ProductsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: viewModel.products.length,
        itemBuilder: (context, index) {
          var product = viewModel.products[index];
          return Card(
            child: ListTile(
              title: Text(product.title),
              subtitle: Text(product.description),
              trailing: Text('\$${product.price}'),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}