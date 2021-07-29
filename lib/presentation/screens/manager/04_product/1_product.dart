import 'package:capstone/business_logic/bloc/bloc.dart';
import 'package:capstone/data/data_providers/const_common.dart';
import 'package:capstone/data/models/models.dart';
import 'package:capstone/presentation/screens/screens.dart';
import 'package:capstone/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenProductManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarText('Product'),
        backgroundColor: Colors.grey[200],
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenProductSearch()));
            },
          )
        ],
      ),
      drawer: ManagerNavigator(),
      body: Stack(
        children: [
          BlocBuilder<ProductBloc, ProductState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is ProductLoaded) {
                return ProductContentManager();
              } else if (state is ProductError) {
                return FailureStateWidget();
              } else if (state is ProductLoading) {
                return LoadingWidget();
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ProductContentManager extends StatefulWidget {
  @override
  _ProductContentManagerState createState() => _ProductContentManagerState();
}

class _ProductContentManagerState extends State<ProductContentManager> {
  @override
  Widget build(BuildContext context) {
    List<Product> products;
    var state = BlocProvider.of<ProductBloc>(context).state;
    if (state is ProductLoaded) {
      products = state.products;
    }
    Future<Null> _onProductRefresh(BuildContext context) async {
      BlocProvider.of<ProductBloc>(context)
          .add(ProductFetchEvent(StatusIntBase.All));
      setState(() {
        products.clear();
      });
    }

    return RefreshIndicator(
      onRefresh: () async {
        _onProductRefresh(context);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 50, 0, 60),
        child: FutureBuilder<List<Product>>(
          initialData: products,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> productLst = snapshot.data;
              return ListView.builder(
                itemCount: productLst.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(productLst[index].imageUrl),
                      backgroundColor: Colors.white,
                    ),
                    title: Text(productLst[index].productName),
                    subtitle: Text(productLst[index].productName),
                    trailing: StatusText(productLst[index].statusName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScreenProductDetailManager()),
                      );
                      BlocProvider.of<ProductDetailBloc>(context).add(
                          ProductDetailFetchEvent(productLst[index].productId));
                    },
                  );
                },
              );
            } else if (snapshot.data == null) {
              return NoRecordWidget();
            } else if (snapshot.hasError) {
              return Text("No Record: ${snapshot.error}");
            }
            return LoadingWidget();
          },
        ),
      ),
    );
  }
}
