import 'package:bloc/bloc.dart';
import 'package:flutter_e_commerce_app/Configs/sharedPreferances.dart';
import 'package:flutter_e_commerce_app/bloc/counter_quantity/bloc_state.dart';
import 'package:flutter_e_commerce_app/data/models/shipping_address.dart';

part 'shipping_address_event.dart';
part 'shipping_address_state.dart';

class ShippingAddressBloc extends Bloc<ShippingAddressEvent, ShippingAddressState> {
  ShippingAddressBloc() : super(ShippingAddressInitial(ShippingAddress(title: 'Economy', subtitle: 'Arrive in 10 days', price: "100"),SharedpreferancesHelper.getAddress()??"Not Added Address")) {
    on<ChangeShippingAddressEvent>((event, emit) {
      emit(SelectShippingAddress(event.address,state.homeAddress));
    });
    on<ChangeHomeAddress>((event, emit) {
      emit(SelectShippingAddress(state.address, event.Address));
    },);
  }
}
