import 'package:capstone/business_logic/bloc/bloc.dart';
import 'package:capstone/business_logic/bloc/city/bloc.dart';
import 'package:capstone/data/models/models.dart';
import 'package:capstone/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaticDropDown extends StatefulWidget {
  final TextEditingController controller;
  final String defaultCity;
  final String defaultDistrict;
  StaticDropDown(
      {@required this.controller, this.defaultCity, this.defaultDistrict});

  @override
  _StaticDropDownState createState() =>
      _StaticDropDownState(controller, defaultCity, defaultDistrict);
}

class _StaticDropDownState extends State<StaticDropDown> {
  final TextEditingController controller;
  final String defaultCity;
  final String defaultDistrict;
  _StaticDropDownState(this.controller, this.defaultCity, this.defaultDistrict);

  List<String> countries = ['Ho Chi Minh', 'Ha Noi'];
  List<String> hcmCity = [
    'District 1',
    "District 2",
    "District 3",
    "District 4",
    "District 5",
    "District 6",
    "District 7",
    "District 8",
    "District 9",
    "District 10",
    "District 11",
    "District 12"
  ];
  List<String> hnCity = [
    'Ba Dinh District',
    "Bac Tu Liem District",
    "Cau giay District",
    "Dong Da District",
    "Ha Dong District",
    "Hai Ba Trung District",
    "Hoan Kiem District",
    "Hoan Mai District",
    "Long Bien District",
    "Nam Tu Liem District",
    "Tay Ho District",
    "Thanh Xuan District",
  ];
  List<String> dictricts = [];
  String selectedCity;
  String selectedDistrict;

  @override
  void initState() {
    if (defaultCity.isEmpty || defaultCity == null) {
    } else {
      selectedCity = defaultCity;
      if (defaultCity == 'Ho Chi Minh') {
        dictricts = hcmCity;
      } else if (defaultCity == 'Ha Noi') {
        dictricts = hnCity;
      }
      selectedDistrict = defaultDistrict;
      BlocProvider.of<CityBloc>(context).add(CityFetchEvent());
      var state = BlocProvider.of<CityBloc>(context).state;
      List<City> cities;
      if (state is CityLoaded) {
        cities = state.cities;
      }
      if (cities != null) {
        cities.forEach((city) {
          if (city.cityName == selectedCity) {
            city.listDistrict.forEach((district) {
              if (district.districtName == selectedDistrict) {
                controller.value = TextEditingValue(text: district.districtId);
              }
            });
          }
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CityBloc>(context).add(CityFetchEvent());
    var state = BlocProvider.of<CityBloc>(context).state;
    List<City> cities;
    return Column(
      children: [
        // Country Dropdown
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))),
            hint: Text(
              'Choose City',
              style: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(169, 176, 185, 1),
              ),
            ),
            value: selectedCity,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            isExpanded: true,
            items: countries.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (country) {
              if (country == 'Ho Chi Minh') {
                dictricts = hcmCity;
              } else if (country == 'Ha Noi') {
                dictricts = hnCity;
              } else {
                dictricts = [];
              }
              setState(() {
                selectedDistrict = null;
                selectedCity = country;
              });
            },
          ),
        ),
        // Country Dropdown Ends here
        SizedBox(height: 15.0),
        // Province Dropdown
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))),
            hint: Text(
              'Choose District',
              style: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(169, 176, 185, 1),
              ),
            ),
            value: selectedDistrict,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            isExpanded: true,
            items: dictricts.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (district) {
              setState(() {
                selectedDistrict = district;
              });

              if (state is CityLoaded) {
                cities = state.cities;
              }
              if (cities != null) {
                cities.forEach((city) {
                  if (city.cityName == selectedCity) {
                    city.listDistrict.forEach((district) {
                      if (district.districtName == selectedDistrict) {
                        controller.value =
                            TextEditingValue(text: district.districtId);
                      }
                    });
                  }
                });
              }
            },
          ),
        ),
        // Province Dropdown Ends here
      ],
    );
  }
}

class StoreDropDown extends StatefulWidget {
  final TextEditingController selectedStore;
  final String defaultStore;
  StoreDropDown({
    @required this.selectedStore,
    @required this.defaultStore,
  });

  @override
  _StoreDropDownState createState() =>
      _StoreDropDownState(selectedStore, defaultStore);
}

class _StoreDropDownState extends State<StoreDropDown> {
  final TextEditingController controller;
  final String defaultStore;

  _StoreDropDownState(this.controller, this.defaultStore);

  List<Store> stores = [];
  List<String> storeMenu = [];
  String selectedStore;
  @override
  void initState() {
    var storeState = BlocProvider.of<StoreBloc>(context).state;
    if (storeState is StoreLoaded) {
      if (storeState.stores != null || storeState.stores.isNotEmpty) {
        stores = storeState.stores;
        storeMenu.add("All Stores");
        controller.value = TextEditingValue(text: "All");
        selectedStore = "All Stores";
        storeState.stores.forEach((element) {
          storeMenu.add(element.storeName);
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        itemHeight: 100,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
        hint: Text(
          'Choose Store',
          style: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(169, 176, 185, 1),
          ),
        ),
        value: selectedStore,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        isExpanded: true,
        items: storeMenu.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedStore = value;
          });
          // var storeState = BlocProvider.of<StoreBloc>(context).state;
          // if (storeState is StoreLoaded) {
          //   if (storeState.stores != null || storeState.stores.isNotEmpty) {
          //     storeState.stores.forEach((element) {
          //       if (element.storeName == value) {
          //         controller.value = TextEditingValue(text: element.storeId);
          //         BlocProvider.of<ShelfBloc>(context)
          //             .add(FetchShelfByStoreIdEvent(element.storeId));
          //         return;
          //       }
          //     });
          //   }
          // }
          if (value == "All stores") {
            controller.value = TextEditingValue(text: "All");
          } else if (stores != null || stores.isNotEmpty) {
            stores.forEach((element) {
              if (element.storeName == value) {
                controller.value = TextEditingValue(text: element.storeId);
                BlocProvider.of<ShelfBloc>(context)
                    .add(FetchShelfByStoreIdEvent(element.storeId));
                return;
              }
            });
          }
        },
      ),
    );
  }
}

class ShelfDropDown extends StatefulWidget {
  final TextEditingController selectedShelf;
  final String defaultShelf;
  ShelfDropDown({
    @required this.selectedShelf,
    @required this.defaultShelf,
  });

  @override
  _ShelfDropDownState createState() =>
      _ShelfDropDownState(selectedShelf, defaultShelf);
}

class _ShelfDropDownState extends State<ShelfDropDown> {
  final TextEditingController controller;
  final String defaulShelf;

  _ShelfDropDownState(this.controller, this.defaulShelf);

  List<Shelf> shelves;
  List<String> shelveMenu = [];
  String selectedShelf;
  @override
  void initState() {
    var shelfState = BlocProvider.of<ShelfBloc>(context).state;
    if (shelfState is ShelfLoaded) {
      if (shelfState.shelves != null || shelfState.shelves.isNotEmpty) {
        // Set default
        shelves = shelfState.shelves;
        shelveMenu.add("All shelves");
        controller.value = TextEditingValue(text: "All");
        selectedShelf = "All shelves";

        shelfState.shelves.forEach((element) {
          shelveMenu.add(element.shelfName);
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        itemHeight: 100,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
        hint: Text(
          'Choose Shelf',
          style: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(169, 176, 185, 1),
          ),
        ),
        value: selectedShelf,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        isExpanded: true,
        items: shelveMenu.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (shelf) {
          setState(() {
            selectedShelf = shelf;
          });
          var shelfState = BlocProvider.of<ShelfBloc>(context).state;
          if (shelfState is ShelfLoaded) {
            if (shelfState.shelves != null || shelfState.shelves.isNotEmpty) {
              shelfState.shelves.forEach((element) {
                if (element.shelfName == shelf) {
                  controller.value = TextEditingValue(text: element.shelfId);
                  return;
                }
              });
            }
          }
          if (shelf == "All shelves") {
            controller.value = TextEditingValue(text: "All");
          } else if (shelves != null || shelves.isNotEmpty) {
            shelves.forEach((element) {
              if (element.shelfName == shelf) {
                controller.value = TextEditingValue(text: element.shelfId);
                return;
              }
            });
          }
        },
      ),
    );
  }
}

class ProductDropDown extends StatefulWidget {
  final TextEditingController selectedStore;
  final String defaultStore;
  ProductDropDown({
    @required this.selectedStore,
    @required this.defaultStore,
  });

  @override
  _ProductDropDownState createState() =>
      _ProductDropDownState(selectedStore, defaultStore);
}

class _ProductDropDownState extends State<ProductDropDown> {
  final TextEditingController controller;
  final String defaultStore;

  _ProductDropDownState(this.controller, this.defaultStore);

  List<String> stores = [];
  String selectedStore;
  @override
  void initState() {
    var productState = BlocProvider.of<ProductBloc>(context).state;
    if (productState is ProductLoaded) {
      if (productState.products != null || productState.products.isNotEmpty) {
        productState.products.forEach((element) {
          stores.add(element.productName);
          if (productState.products.first.productName == element.productName) {
            selectedStore = element.productName;
            controller.value = TextEditingValue(text: element.productId);
          }
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        itemHeight: 100,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
        hint: Text(
          'Choose Product',
          style: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(169, 176, 185, 1),
          ),
        ),
        value: selectedStore,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
        isExpanded: true,
        items: stores.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedStore = value;
          });
          var productState = BlocProvider.of<ProductBloc>(context).state;
          if (productState is ProductLoaded) {
            if (productState.products != null ||
                productState.products.isNotEmpty) {
              productState.products.forEach((element) {
                if (element.productName == value) {
                  controller.value = TextEditingValue(text: element.productId);
                  return;
                }
              });
            }
          }
        },
      ),
    );
  }
}
